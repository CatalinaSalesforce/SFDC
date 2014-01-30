/*
@Name : TestBatchFrance
@Author : customersuccess@cloud62.com
@Date : 
@Description : 
*/
@isTest
private class TestBatchFrance{
    
    /*
    @Name :testBatchFranceDeactivateProgramForecast
    @Description : test functionality for BatchFranceDeactivateProgramForecast.
    */
    static testMethod void testBatchFranceDeactivateProgramForecast() {
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        String rtID = [SELECT ID FROM RecordType Where Name = 'Contract France' and SOBJECTTYPE = 'Opportunity'][0].Id;
        String accountRTID = [SELECT ID FROM RecordType Where Name = 'Manufacturing France' and SOBJECTTYPE = 'Account'][0].Id;
        String progrtID = [SELECT ID FROM RecordType Where Name = 'Contract France' and SOBJECTTYPE = 'Program__c'][0].Id;
        
        Account a = new Account(Name = 'Test Account', RecordTypeId = accountRTID);
        insert a;
        
        Opportunity o = new Opportunity(AccountId = a.Id, RecordTypeId = rtID, Name = 'Test oppty', StageName = 'Presented', CloseDate = Date.today());
        insert o;
        
        Ad_Period__c ap1 = new Ad_Period__c(Name = 'C2_CY2012_test', Start_Date__c = Date.valueOf('2012-01-23'), End_Date__c = Date.valueOf('2012-02-19'), Type__c = 'Manufacturing France');
        insert ap1;
        
        Ad_Period__c ap2 = new Ad_Period__c(Name = 'C3_CY2012_test', Start_Date__c = Date.valueOf('2012-01-23'), End_Date__c = Date.valueOf('2012-02-19'), Type__c = 'Manufacturing France');
        insert ap2;
        
        Program__c p = new Program__c(Name = o.Name + ' Base', Opportunity__c = o.Id, RecordTypeId = progrtID, Delivery_Type__c = 'Base', Product_Type__c = 'Base Product Type1', 
        Start_Cycle__c = ap1.Id, End_Cycle__c = ap2.Id);
        insert p;
        
        Program_Forecast__c pf1 = new Program_Forecast__c(Program__c = p.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000);
        insert pf1;
        
        Test.startTest();
        BatchFranceDeactivateProgramForecast u = new BatchFranceDeactivateProgramForecast();
        Database.executeBatch(u, 400);
        String sch = '0 0 23 * * ?'; 
        system.schedule('BatchFranceDeactivateProgramForecast', sch, u); 
        Test.stopTest();
    }
    
    /*
    @Name :testBatchFranceStoreBeginningMonthPropAmt
    @Description : test functionality for BatchFranceStoreBeginningMonthPropAmt.
    */
    static testMethod void testBatchFranceStoreBeginningMonthPropAmt() {
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        Integer todayDate = Date.today().day();
        France_Category_Overlap_NotificationList__c fs = new France_Category_Overlap_NotificationList__c();
        fs.name='FranceCatOverlapNotification';
        fs.Email_Addresses__c='warren@cloud62.com;Stephanie.Lapp@catalinamarketing.com;raj@cloud62.com;benedicte.enrici@catalinamarketing.com';
        fs.Store_Proposal_Day__c=todayDate;
        insert fs;
        
        String rtID = [SELECT ID FROM RecordType Where Name = 'Contract France' and SOBJECTTYPE = 'Opportunity'][0].Id;
        String accountRTID = [SELECT ID FROM RecordType Where Name = 'Manufacturing France' and SOBJECTTYPE = 'Account'][0].Id;
        String progrtID = [SELECT ID FROM RecordType Where Name = 'Contract France' and SOBJECTTYPE = 'Program__c'][0].Id;
        
        Account a = new Account(Name = 'Test Account', RecordTypeId = accountRTID);
        insert a;
        
        Opportunity o = new Opportunity(AccountId = a.Id, RecordTypeId = rtID, Name = 'Test oppty', StageName = 'Presented', CloseDate = Date.today());
        insert o;
        
        Test.startTest();
        BatchFranceStoreBeginningMonthPropAmt u = new BatchFranceStoreBeginningMonthPropAmt();
        Database.executeBatch(u, 400);
        String sch = '0 0 23 * * ?'; 
        system.schedule('BatchFranceStoreBeginningMonthPropAmt', sch, u); 
        Test.stopTest();
    }

}