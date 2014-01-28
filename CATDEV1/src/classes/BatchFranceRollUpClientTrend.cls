global class BatchFranceRollUpClientTrend  implements Database.Batchable<sObject>, Schedulable{
    
    String query;
    
    global void execute(SchedulableContext ctx) {
        BatchFranceRollUpClientTrend batch1 = new BatchFranceRollUpClientTrend();
        ID batchprocessid = Database.executeBatch(batch1, 200);
    }
    
    global Database.querylocator start(Database.BatchableContext BC){
    
        Batch_Log__c batchLog = new Batch_Log__c();
        
        batchLog.Start_Time__c = datetime.now();
        
        batchLog.Class_Name__c = 'BatchFranceRollUpClientTrend';
        
        insert batchLog;
    
        query = 'SELECT ID FROM USER LIMIT 1';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        List<France_Client_Trend__c> list1 = [SELECT ID FROM FRANCE_CLIENT_TREND__C WHERE MONTH__C = '03'];
        update list1;
        
        /*list1 = [SELECT ID FROM FRANCE_CLIENT_TREND__C WHERE MONTH__C = '06'];
        update list1;
        
        list1 = [SELECT ID FROM FRANCE_CLIENT_TREND__C WHERE MONTH__C = '09'];
        update list1;*/
    }
    
    global void finish(Database.BatchableContext BC){
        
        List<Batch_Log__c> batchLog = [select ID from Batch_Log__c where Class_Name__c = 'BatchFranceRollUpClientTrend' AND Start_Time__c >: datetime.now().addDays(-1) ORDER BY Start_Time__c desc limit 1];
        
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
        BatchFranceDeleteMonthlySDLY acctBatch2Sched = new BatchFranceDeleteMonthlySDLY();
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
    }

}