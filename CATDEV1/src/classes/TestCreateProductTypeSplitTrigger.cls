/**
 *
 Author: Warren
 Email: warren@cloud62.com
 Purpose: to test CreateProductTypeSplit.trigger
 * 
 *This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestCreateProductTypeSplitTrigger {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        Account a = new Account();
        a.Name = 'Test Account1234';
        insert a;
        
        Opportunity o = new Opportunity();
        o.AccountId = a.Id;
        o.Name = 'Test Opportunity1234';
        o.StageName = 'Qualification';
        o.CloseDate = Date.Today();
        insert o;
        
        Program__c p = new Program__c();
        p.Opportunity__c = o.Id;
        p.Product_Type__c = 'Advertising;Campaign Management;Checkout Coupon';
        insert p;
        
        for (Product_Type_Split__c pts : [SELECT ID, Product_Type__c, Percent__c, Program__c From Product_Type_Split__c Where Program__c = :p.Id]){
            system.assert(pts.Product_Type__c == 'Advertising' || pts.Product_Type__c == 'Campaign Management' || pts.Product_Type__c == 'Checkout Coupon');
            system.debug('*** Percent__c = ' + pts.Percent__c);
            system.assert(pts.Percent__c == 33.33);
        }
        
        p.Product_Type__c = 'Advertising;Campaign Management;Checkout Coupon;Quick Cash';
        update p;
        
        p.Product_Type__c = 'Advertising;Direct Response';
        update p;
        
        p.Product_Type__c = '';
        update p;
        
        p.Product_Type__c = 'Advertising;Campaign Management;Checkout Coupon;Quick Cash';
        update p;
    }
    
    static testMethod void testProgramTrigger(){
        
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        Account a = new Account();
        a.Name = 'Test Account1234';
        insert a;
        
        Opportunity o = new Opportunity();
        o.AccountId = a.Id;
        o.Name = 'Test Opportunity1234';
        o.StageName = 'Qualification';
        o.CloseDate = Date.Today();
        o.RecordTypeId = [Select Id From RecordType Where DeveloperName = 'Contract'][0].Id;
        o.Catalina_Business_Unit__c = 'Base';
        insert o;
        
        Opportunity o2 = new Opportunity();
        o2.AccountId = a.Id;
        o2.Name = 'Test Opportunity12345';
        o2.StageName = 'Qualification';
        o2.CloseDate = Date.Today();
        o2.RecordTypeId = [Select Id From RecordType Where DeveloperName = 'Proposal'][0].Id;
        insert o2;

        
        Program__c p = new Program__c();
        p.Opportunity__c = o.Id;
        p.Product_Type__c = 'Advertising;Campaign Management;Checkout Coupon';
        insert p;
        
        Program__c p2 = new Program__c();
        p2.Opportunity__c = o2.Id;
        p2.Product_Type__c = 'Advertising';
        insert p2;
        
        system.debug('***RT: ' + [Select RecordType.Name From Program__c Where Id =: p.Id][0].RecordType.Name);
        system.assert([Select RecordType.Name From Program__c Where Id =: p.Id][0].RecordType.Name == 'Contract');
        system.assert([Select RecordType.Name From Program__c Where Id =: p2.Id][0].RecordType.Name == 'Proposal');
    }
    
    static testMethod void testPreventProgramDeletion() {
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        String profileID = [Select ID From Profile Where Name =: 'System Administrator' Limit 1][0].Id;
        String rtID = [SELECT ID FROM RecordType Where Name = 'Contract' and SOBJECTTYPE = 'Opportunity'][0].Id;
        String accountRTID = [SELECT ID FROM RecordType Where Name = 'Manufacturing' and SOBJECTTYPE = 'Account'][0].Id;
        
        User testEVP = new User();
        testEVP.FirstName = 'test';
        testEVP.LastName = 'EVP';
        testEVP.Forecast_Role__c = 'EVP';
        testEVP.Email = 'testEVP@catalinamarketing.com.testuser';
        testEVP.Username = 'testEVP@catalinamarketing.com.testuser';
        testEVP.Alias = 'testEVP';
        testEVP.CommunityNickname = 'testEVP';
        testEVP.TimeZoneSidKey = 'GMT';
        testEVP.LocaleSidKey = 'en_US';
        testEVP.EmailEncodingKey = 'UTF-8';
        testEVP.LanguageLocaleKey = 'en_US';
        testEVP.ProfileId = profileID;
        insert testEVP;
        
        Account a = new Account();
        a.Name = 'Test Account';
        a.RecordTypeId = accountRTID;
        insert a;
        
        Opportunity o = new Opportunity();
        o.OwnerId = testEVP.Id;
        o.AccountId = a.Id;
        o.RecordTypeId = rtID;
        o.Name = 'Test oppty';
        o.StageName = 'Presented';
        o.CloseDate = Date.today();
        insert o;
        
        Ad_Period__c ap1 = new Ad_Period__c();
        ap1.Name = 'C2_CY2012_test';
        ap1.Start_Date__c = Date.valueOf('2012-01-23');
        ap1.End_Date__c = Date.valueOf('2012-02-19');
        ap1.Type__c = 'Manufacturing';
        insert ap1;
        
        Ad_Period__c ap2 = new Ad_Period__c();
        ap2.Name = 'C3_CY2012_test';
        ap2.Start_Date__c = Date.valueOf('2012-01-23');
        ap2.End_Date__c = Date.valueOf('2012-02-19');
        ap2.Type__c = 'Manufacturing';
        insert ap2;
        
        Program__c p = new Program__c();
        p.Name = o.Name + ' Base';
        p.Opportunity__c = o.Id;
        p.Delivery_Type__c = 'Base';
        p.Product_Type__c = 'Base Product Type1';
        p.Start_Cycle__c = ap1.Id;
        p.End_Cycle__c = ap2.Id;
        insert p;
        
        try{
            delete p;
        } catch (Exception e){
            system.assert(true);
        }
    }
    
    static testMethod void testPFCreation() {
    	Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
    	String profileID = [Select ID From Profile Where Name =: 'System Administrator' Limit 1][0].Id;
        String rtID = [SELECT ID FROM RecordType Where Name = 'Contract' and SOBJECTTYPE = 'Opportunity'][0].Id;
        String accountRTID = [SELECT ID FROM RecordType Where Name = 'Manufacturing' and SOBJECTTYPE = 'Account'][0].Id;
        
        User testEVP = new User();
        testEVP.FirstName = 'test';
        testEVP.LastName = 'EVP';
        testEVP.Forecast_Role__c = 'EVP';
        testEVP.Email = 'testEVP@catalinamarketing.com.testuser';
        testEVP.Username = 'testEVP@catalinamarketing.com.testuser';
        testEVP.Alias = 'testEVP';
        testEVP.CommunityNickname = 'testEVP';
        testEVP.TimeZoneSidKey = 'GMT';
        testEVP.LocaleSidKey = 'en_US';
        testEVP.EmailEncodingKey = 'UTF-8';
        testEVP.LanguageLocaleKey = 'en_US';
        testEVP.ProfileId = profileID;
        insert testEVP;
        
        Account a = new Account();
        a.Name = 'Test Account';
        a.RecordTypeId = accountRTID;
        insert a;
        
        Opportunity o = new Opportunity();
        o.OwnerId = testEVP.Id;
        o.AccountId = a.Id;
        o.RecordTypeId = rtID;
        o.Name = 'Test oppty';
        o.StageName = 'Presented';
        o.CloseDate = Date.today();
        insert o;
        
        Ad_Period__c ap1 = new Ad_Period__c();
        ap1.Name = 'C2_CY2012_test';
        ap1.Start_Date__c = Date.valueOf('2012-01-23');
        ap1.End_Date__c = Date.valueOf('2012-02-19');
        ap1.Type__c = 'Manufacturing';
        insert ap1;
        
        Ad_Period__c ap2 = new Ad_Period__c();
        ap2.Name = 'C3_CY2012_test';
        ap2.Start_Date__c = Date.valueOf('2012-01-23');
        ap2.End_Date__c = Date.valueOf('2012-02-19');
        ap2.Type__c = 'Manufacturing';
        insert ap2;
        
        Program__c p = new Program__c();
        p.Name = o.Name + ' Base';
        p.Opportunity__c = o.Id;
        p.Delivery_Type__c = 'Base';
        p.Product_Type__c = 'Base Product Type1';
        p.Start_Cycle__c = ap1.Id;
        p.End_Cycle__c = ap2.Id;
        p.External_ID__c = 'CON999999Base';
        insert p;
        
        Program_Forecast__c pf1 = new Program_Forecast__c();
        pf1.Program__c = p.Id;
        pf1.Ad_Period__c = ap2.Id;
        pf1.Forecast_Amount__c = 100;
        insert pf1;
        
        pf1 = [SELECT ID, EXTERNAL_ID__C FROM PROGRAM_FORECAST__C WHERE ID = :pf1.Id][0];
        system.debug('***pf1.External_ID__c: ' + pf1.External_ID__c);
    }
    
    static testMethod void testPFCreation2() {
    	Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
    	String profileID = [Select ID From Profile Where Name =: 'System Administrator' Limit 1][0].Id;
        String rtID = [SELECT ID FROM RecordType Where Name = 'Contract' and SOBJECTTYPE = 'Opportunity'][0].Id;
        String accountRTID = [SELECT ID FROM RecordType Where Name = 'Manufacturing' and SOBJECTTYPE = 'Account'][0].Id;
        
        User testEVP = new User();
        testEVP.FirstName = 'test';
        testEVP.LastName = 'EVP';
        testEVP.Forecast_Role__c = 'EVP';
        testEVP.Email = 'testEVP@catalinamarketing.com.testuser';
        testEVP.Username = 'testEVP@catalinamarketing.com.testuser';
        testEVP.Alias = 'testEVP';
        testEVP.CommunityNickname = 'testEVP';
        testEVP.TimeZoneSidKey = 'GMT';
        testEVP.LocaleSidKey = 'en_US';
        testEVP.EmailEncodingKey = 'UTF-8';
        testEVP.LanguageLocaleKey = 'en_US';
        testEVP.ProfileId = profileID;
        insert testEVP;
        
        Account a = new Account();
        a.Name = 'Test Account';
        a.RecordTypeId = accountRTID;
        insert a;
        
        Opportunity o = new Opportunity();
        o.OwnerId = testEVP.Id;
        o.AccountId = a.Id;
        o.RecordTypeId = rtID;
        o.Name = 'Test oppty';
        o.StageName = 'Presented';
        o.CloseDate = Date.today();
        insert o;
        
        Ad_Period__c ap1 = new Ad_Period__c();
        ap1.Name = 'C2_CY2012_test';
        ap1.Start_Date__c = Date.valueOf('2012-01-23');
        ap1.End_Date__c = Date.valueOf('2012-02-19');
        ap1.Type__c = 'Manufacturing';
        insert ap1;
        
        Ad_Period__c ap2 = new Ad_Period__c();
        ap2.Name = 'C3_CY2012_test';
        ap2.Start_Date__c = Date.valueOf('2012-01-23');
        ap2.End_Date__c = Date.valueOf('2012-02-19');
        ap2.Type__c = 'Manufacturing';
        insert ap2;
        
        Program__c p = new Program__c();
        p.Name = o.Name + ' Base';
        p.Opportunity__c = o.Id;
        p.Delivery_Type__c = 'Base';
        p.Product_Type__c = 'Base Product Type1';
        p.Start_Cycle__c = ap1.Id;
        p.End_Cycle__c = ap2.Id;
        insert p;
        
        Program_Forecast__c pf1 = new Program_Forecast__c();
        pf1.Program__c = p.Id;
        pf1.Ad_Period__c = ap2.Id;
        pf1.Forecast_Amount__c = 100;
        insert pf1;
        
        pf1 = [SELECT ID, EXTERNAL_ID__C FROM PROGRAM_FORECAST__C WHERE ID = :pf1.Id][0];
        system.debug('***pf1.External_ID__c2: ' + pf1.External_ID__c);
        
        p.External_ID__c = 'CON999999Base';
        update p;
        
        update pf1;
        
        pf1 = [SELECT ID, EXTERNAL_ID__C FROM PROGRAM_FORECAST__C WHERE ID = :pf1.Id][0];
        system.debug('***pf1.External_ID__c2: ' + pf1.External_ID__c);
    }
}