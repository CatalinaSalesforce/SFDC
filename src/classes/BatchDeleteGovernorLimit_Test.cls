@isTest
private class BatchDeleteGovernorLimit_Test {

    
    /*
    @Name :testBatchDeleteGovernorLimitHistory
    @Description : test code for BatchDeleteGovernorLimitHistory 
    */
    public testmethod static void testBatchDeleteGovernorLimitHistory(){
        //Date dF = System.today().addDays(-14);
        //DateTime dt = datetime.newInstance(dF.year(), dF.month(), dF.day());
        Batch_Run__c bRun = new Batch_Run__c(Batch_Class__c='BatchDeleteGovernorLimitHistory', Start_Time__c=System.today().addDays(-15));
        insert bRun;
        Test.startTest();
        BatchDeleteGovernorLimitHistory obj = new BatchDeleteGovernorLimitHistory();
        Database.executeBatch(obj, 200);
        String sch = '0 0 23 * * ?'; 
        system.schedule('BatchDeleteGovernorLimitHistory', sch, obj);  
        Test.stopTest();   
    }  
    
}