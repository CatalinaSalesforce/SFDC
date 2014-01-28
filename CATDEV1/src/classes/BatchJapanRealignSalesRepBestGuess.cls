/*
@Name            : BatchJapanRealignSalesRepBestGuess 
@Author          : customersuccess@cloud62.com
@Date            : December 17th, 2012
@Description     : Batch Proccess to Realign Best Guesses
*/
global class BatchJapanRealignSalesRepBestGuess implements Database.Batchable<sObject>, Schedulable{
    
    String query;
    String limit1;
    
    public BatchJapanRealignSalesRepBestGuess(String x){
        limit1 = x;
    }
    
    public BatchJapanRealignSalesRepBestGuess(){
        limit1 = '';
    }
    
    //method that gets the query used for this batch
    global Database.querylocator start(Database.BatchableContext BC){
        BatchGovernorLimitUtility.insertBatchRun('BatchJapanRealignSalesRepBestGuess');
        query = 'Select ID, OWNERID, Manager__c, Quarter__c, Manager_Best_Guess__c, Manager_Best_Guess__r.OwnerId From Sales_Rep_Best_Guess__c WHERE OwnerID in (select ID from User where Country__c = \'Japan\') ' + limit1;
        return Database.getQueryLocator(query);
    }
    
    global void execute(SchedulableContext ctx) {
        BatchJapanRealignSalesRepBestGuess batch1 = new BatchJapanRealignSalesRepBestGuess();
        ID batchprocessid = Database.executeBatch(batch1);
    }
    
    //method that makes up the body of the batch process    
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        Datetime currentTime = System.now();
        
        //populate map of users and their managers for easy access later
        List<User> users = [SELECT ID, NAME, MANAGERID FROM USER];
        Map<Id, Id> userManagerMap = new Map<Id, Id>();
        for (User a : users){
            if (a.ManagerId != null){
                userManagerMap.put(a.Id, a.ManagerId);
            }
        }
        
        //populate map of MBG records so that SRBG records can be reassigned to the appropriate MBG record
        List<Manager_Best_Guess__c> mbg = [Select ID, OWNERID, Manager__c, Quarter__c, Manager_Best_Guess__c, Manager_Best_Guess__r.OwnerId From Manager_Best_Guess__c Where OwnerID in (select ID from User where Country__c = 'Japan')];
        Map<String, Manager_Best_Guess__c> mbgMap = new Map<String, Manager_Best_Guess__c>(); 
        for (Manager_Best_Guess__c a : mbg){
            mbgMap.put(a.OwnerId + '-' + a.Quarter__c, a);
        }
        
        //compare each SRBG record with who there manager should be, change if necessary
        List<Sales_Rep_Best_Guess__c> srbg = (List<Sales_Rep_Best_Guess__c>)scope; 
        
        for (Sales_Rep_Best_Guess__c a : srbg){
            if (mbgMap.containsKey(a.OwnerId + '-' + a.Quarter__c)){
                a.Manager__c = a.OwnerId;
                a.Manager_Best_Guess__c = mbgMap.get(a.OwnerId + '-' + a.Quarter__c).Id;
            } else {
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
        }
        
        update srbg;
        BatchGovernorLimitUtility.calcualteLimits(Limits.getCpuTime(), Limits.getDMLRows(), Limits.getDMLStatements(), Limits.getHeapSize(), Limits.getQueries(), Limits.getQueryRows(), Limits.getScriptStatements(), scope, currentTime, System.now());
        
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
        String year2 = String.valueOf(Date.today().year() - 1);
        BatchJapanDeleteSalesRepBestGuess acctBatch2Sched = new BatchJapanDeleteSalesRepBestGuess(year2);
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
        BatchGovernorLimitUtility.updateBatchRun();
    
    }

}