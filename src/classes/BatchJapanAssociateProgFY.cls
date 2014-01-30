global class BatchJapanAssociateProgFY implements Database.Batchable<sObject>, Schedulable{
    
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
    
    public BatchJapanAssociateProgFY(String x){
        limit1 = x;
    }
    
    public BatchJapanAssociateProgFY(){
        limit1 = '';
    }
    
    global void execute(SchedulableContext ctx) {
        BatchJapanAssociateProgFY batch1 = new BatchJapanAssociateProgFY();
        ID batchprocessid = Database.executeBatch(batch1, 200);
    }
    
    global Database.querylocator start(Database.BatchableContext BC){

        query = 'SELECT ID, NAME, QUARTER__C, PROGRAM__C ' 
        	+ 'FROM PROGRAM_FY_AMOUNT__C '
        	+ limit1;
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        List<Program_FY_Amount__c> pfScope = (List<Program_FY_Amount__c>)scope;
        Set<Id> progList = new Set<Id>();
        for (Program_FY_Amount__c pf : pfScope){
            progList.add(pf.Program__c);
        }
        List<Program_Amount__c> insertPA = new List<Program_Amount__c>();
        List<Program_Amount__c> currentPA = [SELECT ID, NAME, QUARTER__C, QUARTER_START_DATE__C, 
            QUARTER_END_DATE__C, PROGRAM__C, ACTUAL_AMOUNT__C, FORECAST_CONTRACT__C,
            FORECAST_PROPOSAL__C
            FROM PROGRAM_AMOUNT__C
            WHERE PROGRAM__C IN :progList];
        Map<Id, Map<String, Program_Amount__c>> paMap = new Map<Id, Map<String, Program_Amount__c>>();
        for (Program_Amount__c pa : currentPA){
            if (!paMap.containsKey(pa.Program__c)){
                paMap.put(pa.Program__c, new Map<String, Program_Amount__c>());
            }
            if (!paMap.get(pa.Program__c).containsKey(pa.Quarter__c)){
                paMap.get(pa.Program__c).put(pa.Quarter__c, pa);
            }
        } 
        for (Program_FY_Amount__c pf : pfScope){
            if (!paMap.containsKey(pf.Program__c)){
                paMap.put(pf.Program__c, new Map<String, Program_Amount__c>());
            }
            String nextQuarter = getNY(pf.Quarter__c);
            if (!paMap.get(pf.Program__c).containsKey(nextQuarter)){
                Program_Amount__c newPA = createPA(pf.Program__c, nextQuarter);
                insertPA.add(newPA);
                paMap.get(pf.Program__c).put(nextQuarter, newPA);
            }
        }
        insert insertPA;
        
        currentPA = [SELECT ID, NAME, QUARTER__C, QUARTER_START_DATE__C, 
            QUARTER_END_DATE__C, PROGRAM__C, ACTUAL_AMOUNT__C, FORECAST_CONTRACT__C,
            FORECAST_PROPOSAL__C
            FROM PROGRAM_AMOUNT__C
            WHERE PROGRAM__C IN :progList];
        paMap = new Map<Id, Map<String, Program_Amount__c>>();
        for (Program_Amount__c pa : currentPA){
            if (!paMap.containsKey(pa.Program__c)){
                paMap.put(pa.Program__c, new Map<String, Program_Amount__c>());
            }
            if (!paMap.get(pa.Program__c).containsKey(pa.Quarter__c)){
                paMap.get(pa.Program__c).put(pa.Quarter__c, pa);
            }
        }
        
        for (Program_FY_Amount__c pf : pfScope){
        	Program_Amount__c pa = paMap.get(pf.Program__c).get(getNY(pf.Quarter__c));
        	pa.Program_FY_Amount__c = pf.Id;
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
        BatchJapanAssociateProgSDPY acctBatch2Sched = new BatchJapanAssociateProgSDPY();
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
    }
    
    private Program_Amount__c createPA(String progID, String quarter){
        Program_Amount__c newPA = new Program_Amount__c();
        if (quarter.contains(String.valueOf(Date.today().year()))){
            newPA.Is_This_Year__c = true;
        } else {
            newPA.Is_This_Year__c = false;
        }
        newPA.Program__c = progID;
        newPA.Quarter__c = quarter;
        newPA.Quarter_Start_Date__c = Date.valueOf(getStartQuarter(quarter));
        newPA.Quarter_End_Date__c = Date.valueOf(getEndQuarter(quarter));
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
    
     /*
    Method that accepts a string that represents a Quarter and returns the same quarter last year
    param - String that represents a quarter in the form 'QQYYYY' e.g. 'Q12012'
    return - String that represents the next quarter in the form 'QQYYYY' e.g. 'Q22012'
    */
    private String getPY(String x){
        Integer q = Integer.valueOf(x.substring(1,2));
        Integer year = Integer.valueOf(x.substring(2));
        year--;
        return 'Q' + String.valueOf(q) + String.valueOf(year); 
    }
    
     /*
    Method that accepts a string that represents a Quarter and returns the same quarter NEXT year
    param - String that represents a quarter in the form 'QQYYYY' e.g. 'Q12012'
    return - String that represents the next quarter in the form 'QQYYYY' e.g. 'Q22013'
    */
    private String getNY(String x){
        Integer q = Integer.valueOf(x.substring(1,2));
        Integer year = Integer.valueOf(x.substring(2));
        year++;
        return 'Q' + String.valueOf(q) + String.valueOf(year); 
    }

}