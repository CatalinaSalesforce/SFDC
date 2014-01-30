global class BatchJapanProgramSDPYAmount implements Database.Batchable<sObject>, Schedulable{
    
    //declare static variables
    final static String q1Start = '-01-01';
    final static String q2Start = '-04-01';
    final static String q3Start = '-07-01';
    final static String q4Start = '-10-01';
    final static String q1End = '-03-31';
    final static String q2End = '-06-30';
    final static String q3End = '-09-30';
    final static String q4End = '-12-31';
    final static String defaultSettingsName = 'Default';
    
    //declare variables
    String query;
    String limit1;
    
    public BatchJapanProgramSDPYAmount(String x){
        limit1 = x;
    }
    
    public BatchJapanProgramSDPYAmount(){
        limit1 = '';
    }
    
    global void execute(SchedulableContext ctx) {
        BatchJapanProgramSDPYAmount batch1 = new BatchJapanProgramSDPYAmount();
        ID batchprocessid = Database.executeBatch(batch1, 200);
    }
    
    global Database.querylocator start(Database.BatchableContext BC){
		Date archiveDate = Date.Today();
        
        Date lastyear = Date.Today().addYears(-1);
        //changed by Warren to 25
        Date lastyear1 = lastyear.addDays(25);
        Date lastyear2 = lastyear.addDays(-25);
         
        AggregateResult ar = [Select Max(Archive_Date__c) Expr1 From Archive_Program__c Where Archive_Date__c <= :lastyear and Archive_Date__c >= :lastyear2 AND
        	(OPPORTUNITY__R.RECORDTYPE.NAME = 'CONTRACT JAPAN' OR OPPORTUNITY__R.RECORDTYPE.NAME = 'PROPOSAL JAPAN')];
        AggregateResult ar2 = [Select Min(Archive_Date__c) Expr2 From Archive_Program__c Where Archive_Date__c >= :lastyear and Archive_Date__c <= :lastyear1
        	AND (OPPORTUNITY__R.RECORDTYPE.NAME = 'CONTRACT JAPAN' OR OPPORTUNITY__R.RECORDTYPE.NAME = 'PROPOSAL JAPAN')];
         
        Date nearestBefore = (Date)ar.get('Expr1');
        Date nearestAfter = (Date)ar2.get('Expr2');
        
        if (nearestBefore != null && nearestAfter != null){
            Integer numDaysBefore = nearestBefore.daysBetween(lastyear);
            Integer numDaysAfter = lastyear.daysBetween(nearestAfter);
            // archiveDate stores the nearest date from one year ago 
            if(numDaysBefore > numDaysAfter) 
            {
                archiveDate = nearestAfter;
            }
            else
            {
                archiveDate = nearestBefore;
            }
        } else if (nearestBefore == null && nearestAfter != null){
            archiveDate = nearestAfter;
        } else if (nearestAfter == null && nearestBefore != null){
            archiveDate = nearestBefore;
        } else {
            archiveDate = Date.valueOf('2000-01-01');
        }
            
        query = 'SELECT Active__c, Program__r.RecordType.Name, Actual_Amount__c, Program__r.Product_Type__c, Program__r.Opportunity__r.Account.Id, Ad_Period__r.Quarter__c, Ad_Period__r.Is_Split__c, Weighted_Forecast_Amount__c, Previous_Quarter_Amount__c, Oppty_Probability__c, Next_Quarter_Amount__c, Forecast_Amount__c, Program__r.Opportunity__r.OwnerId, Program__r.Delivery_Type__c, Program__r.Opportunity__r.Account.RecordType.Name,  Weighted_Previous_Quarter_Forecast__c, Weighted_Next_Quarter_Forecast__c, Previous_Quarter_Ratio__c,'
        + 'Previous_Quarter_Actual__c, Next_Quarter_Ratio__c, Next_Quarter_Actual__c, Program__r.Account_Type__c, '
        + 'Program__r.Opportunity__r.RecordType.Name, Program__r.Opportunity__c '
        + ' From Archive_Program_Forecast__c '
        + ' Where PROGRAM__R.OPPORTUNITY__R.ISDELETED = FALSE AND PROGRAM__R.OPPORTUNITY__R.ACCOUNTID != NULL '
        + ' AND Archive_Date__c = ' + archiveDate.year() + '-' + (archiveDate.month() < 10 ? '0' + String.valueOf(archiveDate.month()) : String.valueOf(archiveDate.month())) + '-' + (archiveDate.day() < 10 ? '0' + String.valueOf(archiveDate.day()) : String.valueOf(archiveDate.day()))
        + ' AND (PROGRAM__R.OPPORTUNITY__R.RECORDTYPE.NAME = \'CONTRACT JAPAN\' OR PROGRAM__R.OPPORTUNITY__R.RECORDTYPE.NAME = \'PROPOSAL JAPAN\') '
        + ' ORDER BY Program__r.Opportunity__r.OwnerId, Program__c, Ad_Period__r.Quarter__c ' + limit1;
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        List<Archive_Program_Forecast__c> pfScope = (List<Archive_Program_Forecast__c>)scope;
        Set<Id> progList = new Set<Id>();
        Set<Id> oppList = new Set<Id>();
        Map<String, String> archiveMap = new Map<String,String>();
        Map<Id, Map<String, Id>> oppProgMap = new Map<Id, Map<String, Id>>();
        for (Archive_Program_Forecast__c pf : pfScope){
            oppList.add(pf.Program__r.Opportunity__c);
        }
        
        for (Program__c prog : [SELECT ID, OPPORTUNITY__C, DELIVERY_TYPE__C
        		FROM PROGRAM__C WHERE OPPORTUNITY__C IN : oppList])
        {
        	if (!oppProgMap.containsKey(prog.Opportunity__c)){
        		oppProgMap.put(prog.Opportunity__c, new Map<String, Id>());
        	}
        	if (!oppProgMap.get(prog.Opportunity__c).containsKey(prog.Delivery_Type__c)){
        		oppProgMap.get(prog.Opportunity__c).put(prog.Delivery_Type__c, prog.Id);
        	}
        }
        
        for (Archive_Program_Forecast__c pf : pfScope){
        	if (!archiveMap.containsKey(pf.Program__c)){
	        	if (oppProgMap.containsKey(pf.Program__r.Opportunity__c)){
	        		if (oppProgMap.get(pf.Program__r.Opportunity__c).containsKey(pf.Program__r.Delivery_Type__c)){
	        			archiveMap.put(pf.Program__c, oppProgMap.get(pf.Program__r.Opportunity__c).get(pf.Program__r.Delivery_Type__c));
	        		}
	        	}
        	}
        	if (archiveMap.containsKey(pf.Program__c)) progList.add(archiveMap.get(pf.Program__c));
        }
        
        List<Program_SDPY_Amount__c> insertPA = new List<Program_SDPY_Amount__c>();
        List<Program_SDPY_Amount__c> currentPA = [SELECT ID, NAME, QUARTER__C, QUARTER_START_DATE__C, 
            QUARTER_END_DATE__C, PROGRAM__C, ACTUAL_AMOUNT__C, FORECAST_CONTRACT__C,
            FORECAST_PROPOSAL__C
            FROM Program_SDPY_Amount__c
            WHERE PROGRAM__C IN :progList];
        Map<Id, Map<String, Program_SDPY_Amount__c>> paMap = new Map<Id, Map<String, Program_SDPY_Amount__c>>();
        for (Program_SDPY_Amount__c pa : currentPA){
            if (!paMap.containsKey(pa.Program__c)){
                paMap.put(pa.Program__c, new Map<String, Program_SDPY_Amount__c>());
            }
            if (!paMap.get(pa.Program__c).containsKey(pa.Quarter__c)){
                paMap.get(pa.Program__c).put(pa.Quarter__c, pa);
            }
        } 
        for (Archive_Program_Forecast__c pf : pfScope){
        	String currentProgram  = archiveMap.get(pf.Program__c);
        	if (currentProgram != null){
	            if (!paMap.containsKey(currentProgram)){
	                paMap.put(currentProgram, new Map<String, Program_SDPY_Amount__c>());
	            }
	            if (!paMap.get(currentProgram).containsKey(pf.Ad_Period__r.Quarter__c)){
	                Program_SDPY_Amount__c newPA = createPA(currentProgram, pf.Ad_Period__r.Quarter__c);
	                insertPA.add(newPA);
	                paMap.get(currentProgram).put(pf.Ad_Period__r.Quarter__c, newPA);
	            }
	            if (pf.Ad_Period__r.Is_Split__c == 'true'){
	                String tmpQuarter = getNextQuarter(pf.Ad_Period__r.Quarter__c);
	                if (!paMap.get(currentProgram).containsKey(tmpQuarter)){
	                Program_SDPY_Amount__c newPA = createPA(currentProgram, tmpQuarter);
	                insertPA.add(newPA);
	                paMap.get(currentProgram).put(tmpQuarter, newPA);
	                }
	            }
        	}
        }
        
        insert insertPA;
        
        currentPA = [SELECT ID, NAME, QUARTER__C, QUARTER_START_DATE__C, 
            QUARTER_END_DATE__C, PROGRAM__C, ACTUAL_AMOUNT__C, FORECAST_CONTRACT__C,
            FORECAST_PROPOSAL__C
            FROM Program_SDPY_Amount__c
            WHERE PROGRAM__C IN :progList];
        paMap = new Map<Id, Map<String, Program_SDPY_Amount__c>>();
        for (Program_SDPY_Amount__c pa : currentPA){
            if (pa.Actual_Amount__c == null) pa.Actual_Amount__c = 0;
            if (pa.Forecast_Contract__c == null) pa.Forecast_Contract__c = 0;
            if (pa.Forecast_Proposal__c == null) pa.Forecast_Proposal__c = 0;
            if (!paMap.containsKey(pa.Program__c)){
                paMap.put(pa.Program__c, new Map<String, Program_SDPY_Amount__c>());
            }
            if (!paMap.get(pa.Program__c).containsKey(pa.Quarter__c)){
                paMap.get(pa.Program__c).put(pa.Quarter__c, pa);
            }
        } 
        
        for (Archive_Program_Forecast__c pf : pfScope){
        	String currentProgram  = archiveMap.get(pf.Program__c);
            if (pf.Ad_Period__r.Is_Split__c == 'false'){
                if (paMap.containsKey(currentProgram)){
                    if (paMap.get(currentProgram).containsKey(pf.Ad_Period__r.Quarter__c)){
                        Program_SDPY_Amount__c tempPA = paMap.get(currentProgram).get(pf.Ad_Period__r.Quarter__c);
                        if (pf.Active__c == false){
                            tempPA.Actual_Amount__c += (pf.Actual_Amount__c == null ? 0 : pf.Actual_Amount__c);
                        } else if (pf.Program__r.Opportunity__r.RecordType.Name.contains('Contract')){
                            tempPA.Forecast_Contract__c += (pf.Forecast_Amount__c == null? 0 : pf.Forecast_Amount__c); 
                        } else {
                            tempPA.Forecast_Proposal__c += (pf.Forecast_Amount__c == null? 0 : pf.Forecast_Amount__c); 
                        }
                    }
                }
            } else {
                if (paMap.containsKey(currentProgram)){
                    if (paMap.get(currentProgram).containsKey(pf.Ad_Period__r.Quarter__c)){
                        Program_SDPY_Amount__c tempPA = paMap.get(currentProgram).get(pf.Ad_Period__r.Quarter__c);
                        if (pf.Active__c == false){
                            tempPA.Actual_Amount__c += (pf.Previous_Quarter_Actual__c == null ? (pf.Actual_Amount__c == null? 0 : pf.Actual_Amount__c) * pf.Previous_Quarter_Ratio__c/100 : pf.Previous_Quarter_Actual__c);
                        } else if (pf.Program__r.Opportunity__r.RecordType.Name.contains('Contract')){
                            tempPA.Forecast_Contract__c += (pf.Previous_Quarter_Amount__c == null ? (pf.Forecast_Amount__c == null? 0 : pf.Forecast_Amount__c) * pf.Previous_Quarter_Ratio__c/100 : pf.Previous_Quarter_Amount__c);
                        } else {
                            tempPA.Forecast_Proposal__c += (pf.Previous_Quarter_Amount__c == null ? (pf.Forecast_Amount__c == null? 0 : pf.Forecast_Amount__c) * pf.Previous_Quarter_Ratio__c/100 : pf.Previous_Quarter_Amount__c);
                        }
                    }
                    
                    String tmpQuarter = getNextQuarter(pf.Ad_Period__r.Quarter__c);
                    if (paMap.get(currentProgram).containsKey(tmpQuarter)){
                        Program_SDPY_Amount__c tempPA = paMap.get(currentProgram).get(tmpQuarter);
                        if (pf.Active__c == false){
                            tempPA.Actual_Amount__c += (pf.Next_Quarter_Actual__c == null ? (pf.Actual_Amount__c == null? 0 : pf.Actual_Amount__c) * pf.Next_Quarter_Ratio__c/100 : pf.Next_Quarter_Actual__c);
                        } else if (pf.Program__r.Opportunity__r.RecordType.Name.contains('Contract')){
                            tempPA.Forecast_Contract__c += (pf.Next_Quarter_Amount__c == null ? (pf.Forecast_Amount__c == null? 0 : pf.Forecast_Amount__c) * pf.Next_Quarter_Ratio__c/100 : pf.Next_Quarter_Amount__c);
                        } else {
                            tempPA.Forecast_Proposal__c += (pf.Next_Quarter_Amount__c == null ? (pf.Forecast_Amount__c == null? 0 : pf.Forecast_Amount__c) * pf.Next_Quarter_Ratio__c/100 : pf.Next_Quarter_Amount__c);
                        }
                    }
                }
            }
        }
        
        update currentPA;
    }
    
    global void finish(Database.BatchableContext BC){
    
        System.debug(LoggingLevel.WARN,'Temp_Delete_DeleteSM1Forecast');
        //Build the system time of now + 20 seconds to schedule the batch apex.
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        BatchJapanAssociateProgFY acctBatch2Sched = new BatchJapanAssociateProgFY();
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
    }
    
    private Program_SDPY_Amount__c createPA(String progID, String quarter){
        Program_SDPY_Amount__c newPA = new Program_SDPY_Amount__c();
        if (quarter.contains(String.valueOf(Date.today().year()))){
            newPA.Is_This_Year__c = true;
        } else {
            newPA.Is_This_Year__c = false;
        }
        newPA.Program__c = progID;
        newPA.Quarter__c = quarter;
        newPA.Quarter_Start_Date__c = Date.valueOf(getStartQuarter(quarter));
        newPA.Quarter_End_Date__c = Date.valueOf(getEndQuarter(quarter));
        newPA.CurrencyIsoCode = 'JPY';
        return newPA;
    }
    
    /*
    Method that accepts a string that represents a Quarter and returns the first day of that quarter
    param - String that represents a quarter in the form 'QQYYYY' e.g. 'Q12012'
    return - The String representation of the first day of that quarter in the form 'YYYY-MM-DD' e.g. '2012-01-01'
    */
    private String getStartQuarter(String x){
        String result = x.substring(2);
        String quarter = x.substring(0,2);
        if (quarter == 'Q1'){
            result += q1Start; 
        } else if (quarter == 'Q2'){
            result += q2Start;
        } else if (quarter == 'Q3'){
            result += q3Start;
        } else {
            result += q4Start;
        } 
        return result;
    }
    
    
    /*
    Method that accepts a string that represents a Quarter and returns the last day of that quarter
    param - String that represents a quarter in the form 'QQYYYY' e.g. 'Q12012'
    return - The String representation of the first day of that quarter in the form 'YYYY-MM-DD' e.g. '2012-03-31'
    */
    private String getEndQuarter(String x){
        
        String result = x.substring(2);
        
        String quarter = x.substring(0,2);
        
        if (quarter == 'Q1'){
            result += q1End; 
        } else if (quarter == 'Q2'){
            result += q2End;
        } else if (quarter == 'Q3'){
            result += q3End;
        } else {
            result += q4End;
        }
        return result;
    }


    /*
    Method that accepts a string that represents a Quarter and returns the next Quarter
    param - String that represents a quarter in the form 'QQYYYY' e.g. 'Q12012'
    return - String that represents the next quarter in the form 'QQYYYY' e.g. 'Q22012'
    */
    private String getNextQuarter(String x){
        Integer q = Integer.valueOf(x.substring(1,2));
        Integer year = Integer.valueOf(x.substring(2));
        if (q == 4){
            year++;
        }
        q = math.mod(q, 4) + 1;
        return 'Q' + String.valueOf(q) + String.valueOf(year); 
    }

}