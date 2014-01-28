/*
@Name            : BatchEuropeDeleteProgramCycleAmount
@Author          : customersuccess@cloud62.com
@Date            : April 30th, 2013
@Description     : This class queries old Program Cycle Amounts and deletes the records so they can re-created in subsequent parts of the batch process
*/

global class BatchEuropeDeleteProgramCycleAmount implements Database.Batchable<sObject>, Schedulable{
    
    String query;
    String limit1;
    
    public BatchEuropeDeleteProgramCycleAmount(String x){
        limit1 = x;
    }
    
    public BatchEuropeDeleteProgramCycleAmount(){
        limit1 = '';
    }
    
    //method that gets the query used for this batch
    global Database.querylocator start(Database.BatchableContext BC){
        //query = 'SELECT ID, NAME FROM ACCOUNT LIMIT 200';
        query = 'Select Id From Program_Cycle_Amount__c '
            + ' Where PROGRAM__R.OPPORTUNITY__R.ISDELETED = FALSE AND PROGRAM__R.OPPORTUNITY__R.ACCOUNTID != NULL '
            + ' AND PROGRAM__R.OPPORTUNITY__R.RECORDTYPE.NAME IN (\'CONTRACT FRANCE\',\'PROPOSAL FRANCE\',\'CONTRACT GERMANY\',\'PROPOSAL GERMANY\',\'CONTRACT ITALY\',\'PROPOSAL ITALY\',\'RENEWALS ITALY\',\'RENEWALS FRANCE\',\'RENEWALS GERMANY\') '
            + limit1;
        return Database.getQueryLocator(query);
    }
    
    global void execute(SchedulableContext ctx) {
        BatchEuropeDeleteProgramCycleAmount batch1 = new BatchEuropeDeleteProgramCycleAmount();
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
        BatchEuropeDeleteProgramCycleFYAmount acctBatch2Sched = new BatchEuropeDeleteProgramCycleFYAmount();
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
    }

}