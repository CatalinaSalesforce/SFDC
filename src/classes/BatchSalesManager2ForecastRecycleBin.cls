/*###################################### 
#Contoller Name: BatchSalesManager2ForecastRecycleBin
#Created Date: 21-11-12 
#Questions: customersuccess@cloud62.com
#LastModified Date: 21-11-12 
#Description: Empty Recycle Bin 
#www.cloud62.com
######################################## 
*/
global class BatchSalesManager2ForecastRecycleBin implements Database.Batchable<sObject>, Schedulable{
    
    //variables
    String query;
    
    //start method
    global Database.querylocator start(Database.BatchableContext BC){
        BatchGovernorLimitUtility.insertBatchRun('BatchActivateOppOwners');
        query = 'Select Id from Sales_Manager_2_Forecast__c where isdeleted=true ALL ROWS';
        return Database.getQueryLocator(query);
    }
    
    //schedulable execute method
    global void execute(SchedulableContext ctx) {
        BatchSalesManager2ForecastRecycleBin batch1 = new BatchSalesManager2ForecastRecycleBin();
        ID batchprocessid = Database.executeBatch(batch1);
    }
    
    //Batchable execute method
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        Datetime currentTime = System.now();
        Database.emptyRecycleBin(scope);   
        BatchGovernorLimitUtility.calcualteLimits(Limits.getCpuTime(), Limits.getDMLRows(), Limits.getDMLStatements(), Limits.getHeapSize(), Limits.getQueries(), Limits.getQueryRows(), Limits.getScriptStatements(), scope, currentTime, System.now());    
    }
    
    //finish method
    global void finish(Database.BatchableContext BC){
         //Build the system time of now + 20 seconds to schedule the batch apex.
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        BatchRep1ForecastRecycleBin binBatch2Sched = new BatchRep1ForecastRecycleBin();
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('BatchRep1ForecastRecycleBin ' + sysTime.getTime(),chron_exp,binBatch2Sched);
        BatchGovernorLimitUtility.updateBatchRun();
    }

}