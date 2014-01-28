/*
@Name            : BatchEuropeDeleteProgramCycleSDPYAmount
@Author          : customersuccess@cloud62.com
@Date            : April 30th, 2012
@Description     : This class deletes all the Program Cycle SDPY Amount records so they can be recreated at a later time in the batch process
*/


global class BatchEuropeDeleteProgramCycleSDPYAmount implements Database.Batchable<sObject>, Schedulable{
    
    String query;
    String limit1;
    
    public BatchEuropeDeleteProgramCycleSDPYAmount(String x){
        limit1 = x;
    }
    
    public BatchEuropeDeleteProgramCycleSDPYAmount(){
        limit1 = '';
    }
    
    //method that gets the query used for this batch
    global Database.querylocator start(Database.BatchableContext BC){
        //query = 'SELECT ID, NAME FROM ACCOUNT LIMIT 200';
        query = 'Select Id From Program_Cycle_SDPY_Amount__c '
            + ' Where (PROGRAM__R.OPPORTUNITY__R.ISDELETED = FALSE AND PROGRAM__R.OPPORTUNITY__R.ACCOUNTID != NULL '
            + ' AND PROGRAM__R.OPPORTUNITY__R.RECORDTYPE.NAME IN (\'CONTRACT FRANCE\',\'PROPOSAL FRANCE\',\'CONTRACT GERMANY\',\'PROPOSAL GERMANY\',\'CONTRACT ITALY\',\'PROPOSAL ITALY\',\'RENEWALS ITALY\',\'RENEWALS FRANCE\',\'RENEWALS GERMANY\')) '
            + ' or PROGRAM__C = NULL '
            + limit1;
        return Database.getQueryLocator(query);
    }
    
    global void execute(SchedulableContext ctx) {
        BatchEuropeDeleteProgramCycleSDPYAmount batch1 = new BatchEuropeDeleteProgramCycleSDPYAmount();
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
        BatchEuropeProgramCycleFYAmount acctBatch2Sched = new BatchEuropeProgramCycleFYAmount();
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
    }

}