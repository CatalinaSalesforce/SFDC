/*
@Name            : BatchActivateOppOwners
@Author          : customersuccess@cloud62.com
@Date            : December 17th, 2012
@Description     : Batch Proccess to activate Opportunity Owners
@Modify By       : Naresh. 12-24-2012. Comment out the Governor Limit log code
*/
global class BatchActivateOppOwners implements Database.Batchable<sObject>, Schedulable{
    
    final static String defaultSettingsName = 'Default';
    
    String query;
    
    global void execute(SchedulableContext ctx) {
        BatchActivateOppOwners batch1 = new BatchActivateOppOwners();
        ID batchprocessid = Database.executeBatch(batch1);
    }
    
    global Database.querylocator start(Database.BatchableContext BC){
        //BatchGovernorLimitUtility.insertBatchRun('BatchActivateOppOwners');
        query = 'Select Id FROM USER LIMIT 1';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        Datetime currentTime = System.now();
        
        //get list of inactive users who own opportunities and store in list for activation
        List<User> userList = [SELECT ID, ISACTIVE From User
            WHERE ID IN (SELECT Ownerid From Opportunity)];
            
        List<User> toActivateUsers = new List<User>();
        Set<ID> userSet = new Set<Id>();
        for (User u : userList){
            if (u.isActive == false){
                u.isActive = true;
                toActivateUsers.add(u);
                userSet.add(u.Id);
            }
        }
        
        
        //get list of users who have been put in a pool for nightly deactivation
        Catalina_Forecast_Settings__c settings1 = Catalina_Forecast_Settings__c.getInstance(defaultSettingsName);
        String tempString = settings1.Deactivate_Users__c;
        tempString += settings1.Deactivate_Users_2__c;
        List<String> deactiveUsers = tempString.split(';');
        List<User> toDeactivateUsers = [SELECT ID, ISACTIVE FROM USER WHERE USERNAME IN :deactiveUsers];
        for (User u : toDeactivateUsers){
            u.IsActive = false;
        }
        
        update toDeactivateUsers;
        update toActivateUsers;
        
        system.debug('*****TEST' + userList.size());
        //BatchGovernorLimitUtility.calcualteLimits(Limits.getCpuTime(), Limits.getDMLRows(), Limits.getDMLStatements(), Limits.getHeapSize(), Limits.getQueries(), Limits.getQueryRows(), Limits.getScriptStatements(), scope, currentTime, System.now());
        
        //AsyncCall.insertPFE(userSet);
    }
    
    global void finish(Database.BatchableContext BC){
        System.debug(LoggingLevel.WARN,'Temp_Delete_DeleteSM1Forecast');
        //Build the system time of now + 20 seconds to schedule the batch apex.
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        //BatchDeleteManagerBestGuess acctBatch2Sched = new BatchDeleteManagerBestGuess();
        BatchCreateBGShell acctBatch2Sched = new BatchCreateBGShell();
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
        //BatchGovernorLimitUtility.updateBatchRun();
    }
}