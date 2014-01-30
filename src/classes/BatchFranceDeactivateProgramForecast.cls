/*
@Name           :       BatchDeactivateFranceProgramForecast
@Author         :       Warren
@Date           :       Oct 9 2012
@Description    :       Batch class designed to:
                            a.) Set Program Forecasts to active/inactive
Apr 16 2013 - remove deprecated client trending classes
June 6 2014 - fix class so that this class is run
*/

global class BatchFranceDeactivateProgramForecast implements Database.Batchable<sObject>, Schedulable{
    
    String query;
    String limit1;
    //Set<ID> accountList;

    public BatchFranceDeactivateProgramForecast (String x){
        limit1 = x;
    }
    
    public BatchFranceDeactivateProgramForecast (){
        limit1 = '';
    }
    
    global void execute(SchedulableContext ctx) {
        BatchFranceDeactivateProgramForecast batch1 = new BatchFranceDeactivateProgramForecast();
        ID batchprocessid = Database.executeBatch(batch1);
    }
    
    //method that gets the query used for this batch
    global Database.querylocator start(Database.BatchableContext BC){
    
        Batch_Log__c batchLog = new Batch_Log__c();
        
        batchLog.Start_Time__c = datetime.now();
        
        batchLog.Class_Name__c = 'BatchFranceDeactivateProgramForecast';
        
        insert batchLog;
    
        query = 'Select Id, Ad_Period__r.End_Date__c, Active__c, Program__r.Id, Program__r.Opportunity__r.Id ' +
            ' From Program_Forecast__c ' 
            + 'WHERE PROGRAM__R.OPPORTUNITY__R.ACCOUNTID <> NULL '
            + 'AND PROGRAM__R.OPPORTUNITY__R.ACCOUNT.RECORDTYPE.NAME LIKE \'%FRANCE%\' ' + limit1;
        return Database.getQueryLocator(query);
    }
    
    //method that makes up the body of the batch process
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        List<Program_Forecast__c> pfScope = (List<Program_Forecast__c>)scope;
        for (Program_Forecast__c a : pfScope){
            if (a.Ad_Period__r.End_Date__c + 2 <= Date.Today()){
                a.Active__c = false;
                system.debug('***deactivate - ' + a.Id + ', Program: ' + a.Program__r.Id + ', Oppty: ' + a.Program__r.Opportunity__r);
            } else {
                a.Active__c = true;
                system.debug('***activate - ' + a.Id + ', Program: ' + a.Program__r.Id + ', Oppty: ' + a.Program__r.Opportunity__r);
            }
        }
        update pfScope;
        
    }
    
    //method that runs after the execute() method
    global void finish(Database.BatchableContext BC){
        
        List<Batch_Log__c> batchLog = [select ID from Batch_Log__c where Class_Name__c = 'BatchFranceDeactivateProgramForecast' AND Start_Time__c >: datetime.now().addDays(-1) ORDER BY Start_Time__c desc limit 1];
        
        if(batchLog.size() == 1)
        {
        
        batchLog[0].Finish_Time__c = datetime.now();
        
        batchLog[0].Successful__c = true;
        
        update batchLog[0];
        
        }
    
        System.debug(LoggingLevel.WARN,'Temp_Delete_DeleteSM1Forecast');
        //Build the system time of now + 20 seconds to schedule the batch apex.
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        //BatchFranceDeleteClientTrend acctBatch2Sched = new BatchFranceDeleteClientTrend();
        BatchFranceDeleteMonthlySDLY acctBatch2Sched = new BatchFranceDeleteMonthlySDLY();
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
    }

}