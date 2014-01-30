/*
@Name            : BatchRecalculateBestGuess 
@Author          : customersuccess@cloud62.com
@Date            : December 17th, 2012
@Description     : class to create Program Amount records, these records are used for reporting
					on individual opportunities and viewing their quarterly contributions
*/
global class BatchCreateProgramAmount implements Database.Batchable<sObject>, Schedulable{
    
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
    
    public BatchCreateProgramAmount(String x){
        limit1 = x;
    }
    
    public BatchCreateProgramAmount(){
        limit1 = '';
    }
    
    global void execute(SchedulableContext ctx) {
        BatchCreateProgramAmount batch1 = new BatchCreateProgramAmount();
        ID batchprocessid = Database.executeBatch(batch1, 200);
    }
    
    global Database.querylocator start(Database.BatchableContext BC){
        BatchGovernorLimitUtility.insertBatchRun('BatchCreateProgramAmount');        
    
        query = 'SELECT Active__c, Program__r.RecordType.Name, Actual_Amount__c, Program__r.Product_Type__c, Program__r.Opportunity__r.Account.Id, Ad_Period__r.Quarter__c, Ad_Period__r.Is_Split__c, Weighted_Forecast_Amount__c, Previous_Quarter_Amount__c, Oppty_Probability__c, Next_Quarter_Amount__c, Forecast_Amount__c, Program__r.Opportunity__r.OwnerId, Program__r.Delivery_Type__c, Program__r.Opportunity__r.Account.RecordType.Name,  Weighted_Previous_Quarter_Forecast__c, Weighted_Next_Quarter_Forecast__c, Previous_Quarter_Ratio__c,'
        + 'Previous_Quarter_Actual__c, Next_Quarter_Ratio__c, Next_Quarter_Actual__c, Program__r.Account_Type__c, '
        + 'Program__r.Opportunity__r.RecordType.Name '
        + ' From Program_Forecast__c '
        + ' Where PROGRAM__R.OPPORTUNITY__R.ISDELETED = FALSE AND PROGRAM__R.OPPORTUNITY__R.ACCOUNTID != NULL '
        + ' AND (PROGRAM__R.OPPORTUNITY__R.RECORDTYPE.NAME = \'CONTRACT\' OR PROGRAM__R.OPPORTUNITY__R.RECORDTYPE.NAME = \'PROPOSAL\' OR PROGRAM__R.OPPORTUNITY__R.RECORDTYPE.NAME = \'RECOVERY\' OR PROGRAM__R.OPPORTUNITY__R.RECORDTYPE.NAME = \'RENEWAL\') '
        + ' ORDER BY Program__r.Opportunity__r.OwnerId, Program__c, Ad_Period__r.Quarter__c ' + limit1;
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        Datetime currentTime = System.now();
        List<Program_Forecast__c> pfScope = (List<Program_Forecast__c>)scope;
        //get set of Program__c IDs and create records where necessary by comparing existing records
        //and the unique set of records required to satisfy this batch of 200 PRogram Forecasts
        Set<Id> progList = new Set<Id>();
        for (Program_Forecast__c pf : pfScope){
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
        for (Program_Forecast__c pf : pfScope){
            if (!paMap.containsKey(pf.Program__c)){
                paMap.put(pf.Program__c, new Map<String, Program_Amount__c>());
            }
            if (!paMap.get(pf.Program__c).containsKey(pf.Ad_Period__r.Quarter__c)){
                Program_Amount__c newPA = createPA(pf.Program__c, pf.Ad_Period__r.Quarter__c);
                insertPA.add(newPA);
                paMap.get(pf.Program__c).put(pf.Ad_Period__r.Quarter__c, newPA);
            }
            if (pf.Ad_Period__r.Is_Split__c == 'true'){
                String tmpQuarter = getNextQuarter(pf.Ad_Period__r.Quarter__c);
                if (!paMap.get(pf.Program__c).containsKey(tmpQuarter)){
                Program_Amount__c newPA = createPA(pf.Program__c, tmpQuarter);
                insertPA.add(newPA);
                paMap.get(pf.Program__c).put(tmpQuarter, newPA);
                }
            }
        }
        
        insert insertPA;
        
        //now that all of the records have been created, requery the records, put them in a map, and increment
        currentPA = [SELECT ID, NAME, QUARTER__C, QUARTER_START_DATE__C, 
            QUARTER_END_DATE__C, PROGRAM__C, ACTUAL_AMOUNT__C, FORECAST_CONTRACT__C,
            FORECAST_PROPOSAL__C
            FROM PROGRAM_AMOUNT__C
            WHERE PROGRAM__C IN :progList];
        paMap = new Map<Id, Map<String, Program_Amount__c>>();
        for (Program_Amount__c pa : currentPA){
            if (pa.Actual_Amount__c == null) pa.Actual_Amount__c = 0;
            if (pa.Forecast_Contract__c == null) pa.Forecast_Contract__c = 0;
            if (pa.Forecast_Proposal__c == null) pa.Forecast_Proposal__c = 0;
            if (!paMap.containsKey(pa.Program__c)){
                paMap.put(pa.Program__c, new Map<String, Program_Amount__c>());
            }
            if (!paMap.get(pa.Program__c).containsKey(pa.Quarter__c)){
                paMap.get(pa.Program__c).put(pa.Quarter__c, pa);
            }
        } 
        
        //this for loop simply looks at each Program Forecast and increments the appropriate record
        for (Program_Forecast__c pf : pfScope){
            if (pf.Ad_Period__r.Is_Split__c == 'false'){
                if (paMap.containsKey(pf.Program__c)){
                    if (paMap.get(pf.Program__c).containsKey(pf.Ad_Period__r.Quarter__c)){
                        Program_Amount__c tempPA = paMap.get(pf.Program__c).get(pf.Ad_Period__r.Quarter__c);
                        if (pf.Active__c == false){
                            tempPA.Actual_Amount__c += (pf.Actual_Amount__c == null ? 0 : pf.Actual_Amount__c);
                        } else if (pf.Program__r.Opportunity__r.RecordType.Name == 'Contract'){
                            tempPA.Forecast_Contract__c += (pf.Forecast_Amount__c == null? 0 : pf.Forecast_Amount__c); 
                        } else {
                            tempPA.Forecast_Proposal__c += (pf.Forecast_Amount__c == null? 0 : pf.Forecast_Amount__c); 
                        }
                    }
                }
            } else {
                if (paMap.containsKey(pf.Program__c)){
                    if (paMap.get(pf.Program__c).containsKey(pf.Ad_Period__r.Quarter__c)){
                        Program_Amount__c tempPA = paMap.get(pf.Program__c).get(pf.Ad_Period__r.Quarter__c);
                        if (pf.Active__c == false){
                            tempPA.Actual_Amount__c += (pf.Previous_Quarter_Actual__c == null ? 0 : pf.Previous_Quarter_Actual__c);
                        } else if (pf.Program__r.Opportunity__r.RecordType.Name == 'Contract'){
                            tempPA.Forecast_Contract__c += (pf.Previous_Quarter_Amount__c == null ? (pf.Forecast_Amount__c == null? 0 : pf.Forecast_Amount__c) * pf.Previous_Quarter_Ratio__c/100 : pf.Previous_Quarter_Amount__c);
                        } else {
                            tempPA.Forecast_Proposal__c += (pf.Previous_Quarter_Amount__c == null ? (pf.Forecast_Amount__c == null? 0 : pf.Forecast_Amount__c) * pf.Previous_Quarter_Ratio__c/100 : pf.Previous_Quarter_Amount__c);
                        }
                    }
                    
                    String tmpQuarter = getNextQuarter(pf.Ad_Period__r.Quarter__c);
                    if (paMap.get(pf.Program__c).containsKey(tmpQuarter)){
                        Program_Amount__c tempPA = paMap.get(pf.Program__c).get(tmpQuarter);
                        if (pf.Active__c == false){
                            tempPA.Actual_Amount__c += (pf.Next_Quarter_Actual__c == null ? 0 : pf.Next_Quarter_Actual__c);
                        } else if (pf.Program__r.Opportunity__r.RecordType.Name == 'Contract'){
                            tempPA.Forecast_Contract__c += (pf.Next_Quarter_Amount__c == null ? (pf.Forecast_Amount__c == null? 0 : pf.Forecast_Amount__c) * pf.Next_Quarter_Ratio__c/100 : pf.Next_Quarter_Amount__c);
                        } else {
                            tempPA.Forecast_Proposal__c += (pf.Next_Quarter_Amount__c == null ? (pf.Forecast_Amount__c == null? 0 : pf.Forecast_Amount__c) * pf.Next_Quarter_Ratio__c/100 : pf.Next_Quarter_Amount__c);
                        }
                    }
                }
            }
        }
        
        update currentPA;
        BatchGovernorLimitUtility.calcualteLimits(Limits.getCpuTime(), Limits.getDMLRows(), Limits.getDMLStatements(), Limits.getHeapSize(), Limits.getQueries(), Limits.getQueryRows(), Limits.getScriptStatements(), scope, currentTime, System.now());
    }
    
    global void finish(Database.BatchableContext BC){
    
        System.debug(LoggingLevel.WARN,'Temp_Delete_DeleteSM1Forecast');
        //Build the system time of now + 20 seconds to schedule the batch apex.
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        BatchCreateRepForecast acctBatch2Sched = new BatchCreateRepForecast();
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
        BatchGovernorLimitUtility.updateBatchRun();
    }
    
    /*
    Method that accepts a string that represents a Quarter and returns the first day of that quarter
    param - ID of the program this record is being created for
    param - String that represents a quarter in the form 'QQYYYY' e.g. 'Q12012'
    return - The created Program Amount record
    */
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

}