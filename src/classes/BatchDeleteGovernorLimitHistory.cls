/*
@Name           : BatchDeleteGovernorLimitHistory
@Author         : customersuccess@cloud62.com
@Date           : 1/25/2013
@Description    : Batch class to delete the 14 days old Batch Run data
*/
global class BatchDeleteGovernorLimitHistory implements Database.Batchable<Sobject>, Schedulable{  
    
    //variables
    global final String query;
    global Datetime dateFrom;  
    
    /*
    @Name :constructor
    @Description : create query string.
    */
    global BatchDeleteGovernorLimitHistory(){
        dateFrom = System.today().addDays(-14);
        query='Select Id From Batch_Run__c Where Start_Time__c < :dateFrom';  
    }  
    
    /*
    @Name :execute
    @Description : execute method of schedulable interface
    */
    global void execute(SchedulableContext ctx) {
        BatchDeleteGovernorLimitHistory batch = new BatchDeleteGovernorLimitHistory();
        ID batchprocessid = Database.executeBatch(batch);
    }
    
    /*
    @Name :start method
    @Description : return the query locator.
    */
    global Database.QueryLocator start(Database.BatchableContext BC){  
        return Database.getQueryLocator(query);  
    }  
    
    /*
    @Name :execute
    @Description : execute method of batchable interface
    */
    global void execute(Database.BatchableContext BC, List<SObject> scope){  
        List<Batch_Run__c> lstBatchRun = new list<Batch_Run__c>();  
        //for all objects from our query
        for (SObject s : scope){  
            Batch_Run__c a = (Batch_Run__c)s;
            lstBatchRun.add(a);  
        }  
        
        Delete lstBatchRun;  
    }  
    
    /*
    @Name :finish
    @Description : 
    */
    global void finish(Database.BatchableContext BC){  
    
    }
  
}