/*
@Name            : BatchEuropeDeleteReportingOpps 
@Author          : customersuccess@cloud62.com
@Date            : June 1 2013
@Description     : Batch Proccess to Delete all Opportunities where For_Reporting__c = true.
					These are recreated later in BatchEuropeAggregateSDPY and BatchEuropeAssociateAccountQuota
*/
global class BatchEuropeDeleteReportingOpps implements Database.Batchable<sObject>, Schedulable{
    
    String query;
    String limit1;
    
    public BatchEuropeDeleteReportingOpps(String x){
        limit1 = x;
    }
    
    public BatchEuropeDeleteReportingOpps(){
        limit1 = '';
    }
    
    //method that gets the query used for this batch
    global Database.querylocator start(Database.BatchableContext BC){
        //query = 'SELECT ID, NAME FROM ACCOUNT LIMIT 200';
        query = 'SELECT ID, NAME FROM OPPORTUNITY WHERE FOR_REPORTING__C = TRUE ' + limit1;
        return Database.getQueryLocator(query);
    }
    
    global void execute(SchedulableContext ctx) {
        BatchEuropeDeleteReportingOpps batch1 = new BatchEuropeDeleteReportingOpps();
        ID batchprocessid = Database.executeBatch(batch1);
    } 
    
    //method that makes up the body of the batch process
    global void execute(Database.BatchableContext NC, List<sObject> scope){

        delete scope;
        
    }
    
    //method that runs after the execute() method
    global void finish(Database.BatchableContext BC){
        System.debug(LoggingLevel.WARN,'Temp_Delete_DeleteSM1Forecast');
        //Build the system time of now + 20 seconds to schedule the batch apex.
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        BatchEuropeDeleteProgramCycleAmount acctBatch2Sched = new BatchEuropeDeleteProgramCycleAmount();
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
    }

}