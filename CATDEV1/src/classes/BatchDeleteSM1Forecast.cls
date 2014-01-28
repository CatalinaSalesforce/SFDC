global class BatchDeleteSM1Forecast implements Database.Batchable<sObject>, Schedulable{
    
    String query;
    String limit1;
    
    public BatchDeleteSM1Forecast(String x){
        limit1 = x;
    }
    
    public BatchDeleteSM1Forecast(){
        limit1 = '';
    }
    
    //method that gets the query used for this batch
    global Database.querylocator start(Database.BatchableContext BC){
        //query = 'SELECT ID, NAME FROM ACCOUNT LIMIT 200';
        query = 'Select Id From Sales_Manager_1_Forecast__c WHERE SDPY_Temp__c = null ' + limit1;
        return Database.getQueryLocator(query);
    }
    
    global void execute(SchedulableContext ctx) {
        BatchDeleteSM1Forecast batch1 = new BatchDeleteSM1Forecast();
        ID batchprocessid = Database.executeBatch(batch1);
    } 
    
    //method that makes up the body of the batch process
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        delete scope;
        List<SDPY_Sales_Manager_1_Forecast__c> list1 = [SELECT ID FROM SDPY_Sales_Manager_1_Forecast__c LIMIT 1000];
        delete list1;
        List<Program_Forecast_Exception__c> list2 = [SELECT ID FROM PROGRAM_FORECAST_EXCEPTION__C LIMIT 1000];
        delete list2;
        List<Program_Amount__c> list3 = [SELECT ID FROM PROGRAM_AMOUNT__C
            WHERE (PROGRAM__R.OPPORTUNITY__R.RECORDTYPE.NAME = 'CONTRACT' OR PROGRAM__R.OPPORTUNITY__R.RECORDTYPE.NAME = 'PROPOSAL' OR PROGRAM__R.OPPORTUNITY__R.RECORDTYPE.NAME = 'RECOVERY' OR PROGRAM__R.OPPORTUNITY__R.RECORDTYPE.NAME = 'RENEWAL') LIMIT 2000];
        delete list3;
    }
    
    //method that runs after the execute() method
    global void finish(Database.BatchableContext BC){
        System.debug(LoggingLevel.WARN,'Temp_Delete_DeleteSM1Forecast');
        //Build the system time of now + 20 seconds to schedule the batch apex.
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        BatchDeleteSM2Forecast acctBatch2Sched = new BatchDeleteSM2Forecast();
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
    }

}