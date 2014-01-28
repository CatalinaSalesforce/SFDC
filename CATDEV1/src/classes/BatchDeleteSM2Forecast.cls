/*
@Name            : BatchDeleteSM2Forecast
@Author          : customersuccess@cloud62.com
@Date            : December 17th, 2012
@Description     : Batch Proccess to Delete Sale Manager 2 Forecasts
*/
global class BatchDeleteSM2Forecast implements Database.Batchable<sObject>, Schedulable{
    
    String query;
    String limit1;
    
    public BatchDeleteSM2Forecast(String x){
        limit1 = x;
    }
    
    public BatchDeleteSM2Forecast(){
        limit1 = '';
    }
    
    //method that gets the query used for this batch
    global Database.querylocator start(Database.BatchableContext BC){
        //query = 'SELECT ID, NAME FROM ACCOUNT LIMIT 200';
        BatchGovernorLimitUtility.insertBatchRun('BatchDeleteSM2Forecast');
        query = 'Select Id From Sales_Manager_2_Forecast__c ' + limit1;
        return Database.getQueryLocator(query);
    }
    
    global void execute(SchedulableContext ctx) {
        BatchDeleteSM2Forecast batch1 = new BatchDeleteSM2Forecast();
        ID batchprocessid = Database.executeBatch(batch1);
    } 
    
    //method that makes up the body of the batch process
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        Datetime currentTime = System.now();
        delete scope;
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
        BatchDeleteSR1Forecast acctBatch2Sched = new BatchDeleteSR1Forecast();
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
        BatchGovernorLimitUtility.updateBatchRun();
    }

}