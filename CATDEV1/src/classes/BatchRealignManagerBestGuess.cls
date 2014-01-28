/*
@Name            : BatchRealignManagerBestGuess 
@Author          : customersuccess@cloud62.com
@Date            : December 17th, 2012
@Description     : Batch Proccess to Realing Manager Best Guess
*/
global class BatchRealignManagerBestGuess implements Database.Batchable<sObject>, Schedulable{
    
    String query;
    String limit1;
    
    public BatchRealignManagerBestGuess(String x){
        limit1 = x;
    }
    
    public BatchRealignManagerBestGuess(){
        limit1 = '';
    }
    
    //method that gets the query used for this batch
    global Database.querylocator start(Database.BatchableContext BC){
        BatchGovernorLimitUtility.insertBatchRun('BatchRealignManagerBestGuess');
        query = 'Select ID, OWNERID, Manager__c, Quarter__c, Manager_Best_Guess__c, Manager_Best_Guess__r.OwnerId From Manager_Best_Guess__c ' + limit1;
        return Database.getQueryLocator(query);
    }
    
    global void execute(SchedulableContext ctx) {
        BatchRealignManagerBestGuess batch1 = new BatchRealignManagerBestGuess();
        ID batchprocessid = Database.executeBatch(batch1);
    }
    
    //method that makes up the body of the batch process    
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        Datetime currentTime = System.now();
        
        //store map of users and their managers to be used later in verify MBG records
        List<User> users = [SELECT ID, NAME, MANAGERID FROM USER];
        Map<Id, Id> userManagerMap = new Map<Id, Id>();
        for (User a : users){
            if (a.ManagerId != null){
                userManagerMap.put(a.Id, a.ManagerId);
            }
        }
        
        //store map of MBG records for easy retrieval later
        List<Manager_Best_Guess__c> mbg = [Select ID, OWNERID, Manager__c, Quarter__c, Manager_Best_Guess__c, Manager_Best_Guess__r.OwnerId From Manager_Best_Guess__c];
        Map<String, Manager_Best_Guess__c> mbgMap = new Map<String, Manager_Best_Guess__c>(); 
        for (Manager_Best_Guess__c a : mbg){
            mbgMap.put(a.OwnerId + '-' + a.Quarter__c, a);
        }
        
        //compare all MBG records to the MBG User Map and see if they are in line, change if not
        List<Manager_Best_Guess__c> scopeMBG = (List<Manager_Best_Guess__c>)scope;
        for (Manager_Best_Guess__c a : scopeMBG){
            if (a.Manager__c != userManagerMap.get(a.OwnerID) || a.Manager_Best_Guess__c == null){
                a.Manager__c = userManagerMap.get(a.OwnerID);
                if (mbgMap.containsKey(userManagerMap.get(a.OwnerID) + '-' + a.Quarter__c)){
                    a.Manager_Best_Guess__c = mbgMap.get(userManagerMap.get(a.OwnerID) + '-' + a.Quarter__c).Id;
                }
            } else if (a.Manager_Best_Guess__r.OwnerId != userManagerMap.get(a.OwnerID)){
                a.Manager__c = userManagerMap.get(a.OwnerID);
                if (mbgMap.containsKey(userManagerMap.get(a.OwnerID) + '-' + a.Quarter__c)){
                    a.Manager_Best_Guess__c = mbgMap.get(userManagerMap.get(a.OwnerID) + '-' + a.Quarter__c).Id;
                }
            }
        }
        
        update scopeMBG;
        BatchGovernorLimitUtility.calcualteLimits(Limits.getCpuTime(), Limits.getDMLRows(), Limits.getDMLStatements(), Limits.getHeapSize(), Limits.getQueries(), Limits.getQueryRows(), Limits.getScriptStatements(), scope, currentTime, System.now());
    }
    
    //method that runs after the execute() method
    global void finish(Database.BatchableContext BC){
        System.debug(LoggingLevel.WARN,'Scheduling BatchRealignSalesRepBestGuess');
        //Build the system time of now + 20 seconds to schedule the batch apex.
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        //BatchDeleteManagerBestGuess acctBatch2Sched = new BatchDeleteManagerBestGuess();
        BatchRealignSalesRepBestGuess acctBatch2Sched = new BatchRealignSalesRepBestGuess();
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
        BatchGovernorLimitUtility.updateBatchRun();
    }

}