global class BatchJapanCreateBGShell implements Database.Batchable<sObject>, Schedulable{
    
    //List<String> Quarters = new List<String>{'Q1', 'Q2', 'Q3', 'Q4'};
    final static String q1Start = '-01-01';
    final static String q2Start = '-04-01';
    final static String q3Start = '-07-01';
    final static String q4Start = '-10-01';
    final static String q1End = '-03-31';
    final static String q2End = '-06-30';
    final static String q3End = '-09-30';
    final static String q4End = '-12-31';
    final static String q1 = 'Q1';
    final static String q2 = 'Q2';
    final static String q3 = 'Q3';
    final static String q4 = 'Q4';
    private static final String srbgRTID = [SELECT ID FROM RecordType Where Name = 'Japan' and SOBJECTTYPE = 'Sales_Rep_Best_Guess__c'][0].Id;
    private static final String mbgRTID = [SELECT ID FROM RecordType Where Name = 'Japan' and SOBJECTTYPE = 'Manager_Best_Guess__c'][0].Id;
    
    List<String> quarters;
    String query;
    String year1 = String.valueOf(Date.today().year());
    String year2 = String.valueOf(Date.today().year() + 1);
    Set<Id> managerList;
    Set<Id> sellingList;
    Set<Id> activeList;
    Map<Id, Id> userManagerMap;
    Map<Id, Id> managerMBGmap;
    Map<Id, String> userNameMap;
    Map<Id, String> userForecastRoleMap;
    List<Manager_Best_Guess__c> insertMBG;
    List<Sales_Rep_Best_Guess__c> insertSRBG;

    //method that gets the query used for this batch
    global Database.querylocator start(Database.BatchableContext BC){
    
        query = 'SELECT ID, Name FROM USER LIMIT 1';
        return Database.getQueryLocator(query);
    }
    
    global void execute(SchedulableContext ctx) {
        BatchJapanCreateBGShell batch1 = new BatchJapanCreateBGShell();
        ID batchprocessid = Database.executeBatch(batch1);
    }
    
    //method that makes up the body of the batch process    
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        
        //add list of Quarters
        quarters = new List<String>();
        quarters.add(q1 + year1);
        quarters.add(q2 + year1);
        quarters.add(q3 + year1);
        quarters.add(q4 + year1);
        quarters.add(q1 + year2);
        quarters.add(q2 + year2);
        quarters.add(q3 + year2);
        quarters.add(q4 + year2);
        
        
        activeList = new Set<Id>();
        managerList = new Set<ID>();
        sellingList = new Set<ID>();
        userManagerMap = new Map<Id, Id>();
        userForecastRoleMap = new Map<Id, String>();
        managerMBGMap = new Map<Id, Id>();
        userNameMap = new Map<Id, String>();
        insertSRBG = new List<Sales_Rep_Best_Guess__c>();
        insertMBG = new List<Manager_Best_Guess__c>();
        
        for (User a : [SELECT Id, Name, IsActive From User]){
            If (a.IsActive == true) activeList.add(a.Id);
            userNameMap.put(a.Id, a.Name);
        }
        
        List<User> users = [SELECT Id, Name, ManagerId, Forecast_Role__c, Does_Sell__c From User Where Forecast_Role__c != null AND COUNTRY__C = 'JAPAN'];
        for (User a : users){
            //if (activeList.contains(a.ManagerId)){ //commented out by Warren June 24
                if (a.ManagerId != null){
                    managerList.add(a.ManagerId);
                    userManagerMap.put(a.Id, a.ManagerId);
                    userForecastRoleMap.put(a.Id, a.Forecast_Role__c);
                }
                if (a.Does_Sell__c == true) sellingList.add(a.Id);
            //}
        }
        
        List<Manager_Best_Guess__c> mbg = [SELECT ID, NAME, OWNERID, QUARTER__C FROM MANAGER_BEST_GUESS__C];
        List<Sales_Rep_Best_Guess__c> srbg = [SELECT ID, NAME, OWNERID, QUARTER__C FROM SALES_REP_BEST_GUESS__C];
        
        List<Manager_Best_Guess__c> delMBG = new List<Manager_Best_Guess__c>();
        List<Sales_Rep_Best_Guess__c> delSRBG = new List<Sales_Rep_Best_Guess__c>();
        
        for (Manager_Best_Guess__c a : mbg){
            if (!managerList.contains(a.OwnerId)){
                delMBG.add(a);
            }   
        }
        
        for (Sales_Rep_Best_Guess__c a : srbg){
            if (!sellingList.contains(a.OwnerId)){
                delSRBG.add(a);
            }   
        }
        
        //delete delMBG;
        //delete delSRBG;
        
        mbg = [SELECT ID, NAME, OWNERID, QUARTER__C FROM MANAGER_BEST_GUESS__C];
        Map<String, Manager_Best_Guess__c> mbgMap = new Map<String, Manager_Best_Guess__c>();
        for (Manager_Best_Guess__c a : mbg){
            if (!mbgMap.containsKey(a.OwnerId + '-' + a.Quarter__c)){
                mbgMap.put(a.OwnerId + '-' + a.Quarter__c, a);
            }   
        }
         
        srbg = [SELECT ID, NAME, OWNERID, QUARTER__C FROM SALES_REP_BEST_GUESS__C];
        Map<String, Sales_Rep_Best_Guess__c> srbgMap = new Map<String, Sales_Rep_Best_Guess__c>();
        for (Sales_Rep_Best_Guess__c a : srbg){
            if (!srbgMap.containsKey(a.OwnerId + '-' + a.Quarter__c)){
                srbgMap.put(a.OwnerId + '-' + a.Quarter__c, a);
            }   
        }
        
        for (String x : managerList){
            for (String quarterString : quarters){
                if (!mbgMap.containsKey(x + '-' + quarterString)){
                    Manager_Best_Guess__c a = new Manager_Best_Guess__c();
                    a.OwnerId = x;
                    a.Quarter__c = quarterString;
                    a.Quarter_Start_Date__c = Date.valueOf(getStartQuarter(quarterString));
                    a.Quarter_End_Date__c = Date.valueOf(getEndQuarter(quarterString));
                    a.Forecast_Role__c = userForecastRoleMap.get(x);
                    a.Name = userNameMap.get(x) + ' - ' + quarterString;
                    a.RecordtypeID = mbgRTID;
                    if (userManagerMap.containsKey(x)) a.Manager__c = userManagerMap.get(x);
                    insertMBG.add(a);
                }
            }
        }
        insert insertMBG;
        
        for (String x : sellingList){
            for (String quarterString : quarters){
                if (!srbgMap.containsKey(x + '-' + quarterString)){
                    system.debug('***missing srbg: ' + x + '-' + quarterString);
                    Sales_Rep_Best_Guess__c a = new Sales_Rep_Best_Guess__c();
                    a.OwnerId = x;
                    a.Quarter__c = quarterString;
                    a.Quarter_Start_Date__c = Date.valueOf(getStartQuarter(quarterString));
                    a.Quarter_End_Date__c = Date.valueOf(getEndQuarter(quarterString));
                    a.Name = userNameMap.get(x) + ' - ' + quarterString;
                    a.RecordtypeID = srbgRTID;
                    if (managerList.contains(x)){
                        a.Manager__c = x;
                        a.Manager_Best_Guess__c = managerMBGMap.get(x);
                    } else if (userManagerMap.containsKey(x)){
                        a.Manager__c = userManagerMap.get(x);
                        a.Manager_Best_Guess__c = managerMBGMap.get(userManagerMap.get(x));
                    }
                    insertSRBG.add(a);
                }
            }
        }
        
        insert insertSRBG;
        
    }
    
    //method that runs after the execute() method
    global void finish(Database.BatchableContext BC){
    
        System.debug(LoggingLevel.WARN,'Temp_Delete_DeleteSM1Forecast');
        //Build the system time of now + 20 seconds to schedule the batch apex.
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        //BatchDeleteManagerBestGuess acctBatch2Sched = new BatchDeleteManagerBestGuess();
        BatchJapanRealignManagerBestGuess acctBatch2Sched = new BatchJapanRealignManagerBestGuess();
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
       
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

}