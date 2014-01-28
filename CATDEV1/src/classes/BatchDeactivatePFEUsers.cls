/*
@Name            : BatchDeactivatePFEUsers 
@Author          : customersuccess@cloud62.com
@Date            : December 17th, 2012
@Description     : Batch Proccess to Decativate Users that were previously activated by BatchActivateOppOwners
@Last Modify     : Naresh. 12-26-2012. code change to prevent exceptions relating to mixing DDL and DML
*/
global class BatchDeactivatePFEUsers implements Database.Batchable<sObject>, Schedulable{
    
    final static String defaultSettingsName = 'Default';
    
    String query;
    
    global void execute(SchedulableContext ctx) {
        BatchDeactivatePFEUsers batch1 = new BatchDeactivatePFEUsers();
        ID batchprocessid = Database.executeBatch(batch1);
    }
    
    global Database.querylocator start(Database.BatchableContext BC){
        //BatchGovernorLimitUtility.insertBatchRun('BatchDeactivatePFEUsers');
        query = 'Select Id FROM USER LIMIT 1';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        Datetime currentTime = System.now();
        //get list of activated users for deactivation
        List<User> pfeUsers = [SELECT ID, ISACTIVE FROM USER
            WHERE ID IN (SELECT USER__C FROM PROGRAM_FORECAST_EXCEPTION__C)];
            
        for (User u : pfeUsers){
            u.isActive = false;
        }
        
        //get list of deactivated users for reactivationx
        Catalina_Forecast_Settings__c settings1 = Catalina_Forecast_Settings__c.getInstance(defaultSettingsName);
        String tempString = settings1.Deactivate_Users__c;
        tempString += settings1.Deactivate_Users_2__c;
        List<String> deactiveUsers = tempString.split(';');
        List<User> toActivateUsers = [SELECT ID, ISACTIVE FROM USER WHERE USERNAME IN :deactiveUsers];
        for (User u : toActivateUsers){
            u.IsActive = true;
        }
        
        update toActivateUsers;
        
        update pfeUsers;
        //BatchGovernorLimitUtility.calcualteLimits(Limits.getCpuTime(), Limits.getDMLRows(), Limits.getDMLStatements(), Limits.getHeapSize(), Limits.getQueries(), Limits.getQueryRows(), Limits.getScriptStatements(), scope, currentTime, System.now());
        
    }
    
    global void finish(Database.BatchableContext BC){
        System.debug(LoggingLevel.WARN,'Temp_Delete_DeleteSM1Forecast');
        //Build the system time of now + 20 seconds to schedule the batch apex.
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        BatchNotifyPFE acctBatch2Sched = new BatchNotifyPFE();
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
        //BatchGovernorLimitUtility.updateBatchRun();
    }

}