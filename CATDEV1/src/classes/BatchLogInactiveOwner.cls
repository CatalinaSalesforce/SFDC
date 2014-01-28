/*
@Name            : BatchLogInactiveOwner 
@Author          : customersuccess@cloud62.com
@Date            : December 17th, 2012
@Description     : Batch Proccess to Log Inactice Users
*/
global class BatchLogInactiveOwner implements Database.Batchable<sObject>, Schedulable{
    
    final static String defaultSettingsName = 'Default';
    
    String query;
    
    global void execute(SchedulableContext ctx) {
        BatchLogInactiveOwner batch1 = new BatchLogInactiveOwner();
        ID batchprocessid = Database.executeBatch(batch1);
    }
    
    global Database.querylocator start(Database.BatchableContext BC){
        BatchGovernorLimitUtility.insertBatchRun('BatchLogInactiveOwner');
        query = 'Select Id FROM USER LIMIT 1';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        Datetime currentTime = System.now();
        
        //get list of inactive users who own opportunities and store in Program Forecast Exception
        List<User> userList = [SELECT ID, ISACTIVE From User
            WHERE ID IN (SELECT Ownerid From Opportunity)];
            
        List<User> toActivateUsers = new List<User>();
        List<Program_Forecast_Exception__c> insertPFE = new List<Program_Forecast_Exception__c>();
        
        for (User u : userList){
            if (u.isActive == false){
                Program_Forecast_Exception__c newPFE = new Program_Forecast_Exception__c();
                newPFE.User__c = u.id;
                newPFE.Reason__c = 'Inactive User owns an Opportunity';
                insertPFE.add(newPFE);
            }
        }
        
        insert insertPFE;
        BatchGovernorLimitUtility.calcualteLimits(Limits.getCpuTime(), Limits.getDMLRows(), Limits.getDMLStatements(), Limits.getHeapSize(), Limits.getQueries(), Limits.getQueryRows(), Limits.getScriptStatements(), scope, currentTime, System.now());
        //AsyncCall.insertPFE(userSet);
    }
    
    global void finish(Database.BatchableContext BC){
        System.debug(LoggingLevel.WARN,'Temp_Delete_DeleteSM1Forecast');
        //Build the system time of now + 20 seconds to schedule the batch apex.
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        BatchActivateOppOwners acctBatch2Sched = new BatchActivateOppOwners();
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
        BatchGovernorLimitUtility.updateBatchRun();
    }
}