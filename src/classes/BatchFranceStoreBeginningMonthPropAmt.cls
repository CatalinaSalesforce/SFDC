global class BatchFranceStoreBeginningMonthPropAmt implements Database.Batchable<sObject>, Schedulable{

    final static String defaultSettingsName = 'FranceCatOverlapNotification';
    String query;
    String limit1;
    
    public BatchFranceStoreBeginningMonthPropAmt (String x){
        limit1 = x;
    }
    
    public BatchFranceStoreBeginningMonthPropAmt (){
        limit1 = '';
    }
    
    global void execute(SchedulableContext ctx) {
        BatchFranceStoreBeginningMonthPropAmt batch1 = new BatchFranceStoreBeginningMonthPropAmt();
        ID batchprocessid = Database.executeBatch(batch1);
    }
    
    global Database.querylocator start(Database.BatchableContext BC){
    
        Batch_Log__c batchLog = new Batch_Log__c();
        
        batchLog.Start_Time__c = datetime.now();
        
        batchLog.Class_Name__c = 'BatchFranceStoreBeginningMonthPropAmt';
        
        insert batchLog;
    
        France_Category_Overlap_NotificationList__c setting1 = France_Category_Overlap_NotificationList__c.getInstance(defaultSettingsName);
        
        if(setting1 != null)
        {
        
            query = 'SELECT ID, CLOSEDATE, AMOUNT, ACTUAL_AMOUNT__C, RECORDTYPE.NAME, ACCOUNTID, OWNERID, Probability, '
                + ' ISCLOSED, Proposal_At_Beginning_of_Month__c, ExpectedRevenue '
                + ' FROM OPPORTUNITY '
                + ' WHERE RECORDTYPE.NAME = \'CONTRACT FRANCE\' OR RECORDTYPE.NAME = \'PROPOSAL FRANCE\' '
                + ' ORDER BY ACCOUNTID, OWNERID ' + limit1;
            if (Date.today().day() != setting1.Store_Proposal_Day__c){
                query = 'SELECT ID FROM USER WHERE ID = NULL AND ID != NULL';
            }
        }
        else
        {
        
            query = 'SELECT ID FROM USER WHERE ID = NULL AND ID != NULL';
        
        }
        System.Debug('query$ ' + query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        List<Opportunity> oppScope = (List<Opportunity>)scope;
        
        for (Opportunity o : oppScope){
            if (o.IsClosed){
                o.Proposal_At_Beginning_of_Month__c = null;
            } else {
                o.Proposal_At_Beginning_of_Month__c = o.ExpectedRevenue; 
            }
        }
        
        update oppScope;
    }
    
    global void finish(Database.BatchableContext BC){
        
        List<Batch_Log__c> batchLog = [select ID from Batch_Log__c where Class_Name__c = 'BatchFranceStoreBeginningMonthPropAmt' AND Start_Time__c >: datetime.now().addDays(-1) ORDER BY Start_Time__c desc limit 1];
        
        if(batchLog.size() == 1)
        {
        
        batchLog[0].Finish_Time__c = datetime.now();
        
        batchLog[0].Successful__c = true;
        
        update batchLog[0];
        
        }
        
    }

}