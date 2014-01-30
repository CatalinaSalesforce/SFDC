/*
@Name            : BatchDeleteReportLandingPageTrackers
@Author          : customersuccess@cloud62.com
@Date            : June 24th, 2013
@Description     : Batch Proccess to Report Landing Page Tracker records
*/
global class BatchDeleteReportLandingPageTrackers implements Database.Batchable<sObject>, Schedulable{
    
    global String query;
    global DateTime dateFrom;
    
    global BatchDeleteReportLandingPageTrackers(String x){
        Integer days = Integer.valueOf(x);
        dateFrom = System.today().addDays(-days);
    }
    
    global BatchDeleteReportLandingPageTrackers(){
        dateFrom = System.today().addDays(-30);
        //dateFrom = System.now();
    }
    
    //method that gets the query used for this batch
    global Database.querylocator start(Database.BatchableContext BC){
        query = 'Select Id From Report_Landing_Page_Tracker__c Where CreatedDate <= :dateFrom';
        return Database.getQueryLocator(query);
    }
    
    global void execute(SchedulableContext ctx) {
        BatchDeleteReportLandingPageTrackers batch1 = new BatchDeleteReportLandingPageTrackers();
        ID batchprocessid = Database.executeBatch(batch1, 25);
   } 
    
    //method that makes up the body of the batch process
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        delete scope;
    }
    
    //method that runs after the execute() method
    global void finish(Database.BatchableContext BC){

    } 

}