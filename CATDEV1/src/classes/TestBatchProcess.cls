/**
 * This class contains unit tests for validating the behavior of Apex classes
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
private class TestBatchProcess {
    
    private static final String sysAdmin = 'System Administrator';
    private static final String baseType = 'Base';
    private static final String digitalType = 'Digital O&O';
    private static final String displayType = 'Audience Network';
    private static final String mobileType = 'Mobile';
    private static final String manufacturingType = 'Manufacturing';
    private static final String retailType = 'Retail';
    private static final String coopType = 'coop';
    private static final String SR1Type = 'SR1';
    private static final String SR2Type = 'SR2';
    private static final String SM1Type = 'SM1';
    private static final String SM2Type = 'SM2';
    private static final String pfeEmail = 'fakeemail@myfakeemailplay.com.fake';
    private static final String settingsName = 'Default';
    private static final Integer settingsWindow = 0;
    private static final Integer settingsPercent = 12;
    
    public TestBatchProcess(){
    }
    
    static testMethod void testBatchDeactivateProgramForecasts() {
        // TO DO: implement unit test
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
        String rtID = [SELECT ID FROM RecordType Where Name = 'Contract' and SOBJECTTYPE = 'Opportunity'][0].Id;
        String accountRTID = [SELECT ID FROM RecordType Where Name = 'Manufacturing' and SOBJECTTYPE = 'Account'][0].Id;
        
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
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
        
        User testSM1 = new User();
        testSM1.FirstName = 'test';
        testSM1.LastName = 'SM1';
        testSM1.Forecast_Role__c = 'SM1';
        testSM1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Username = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Alias = 'testSM1';
        testSM1.CommunityNickname = 'testSM1';
        testSM1.TimeZoneSidKey = 'GMT';
        testSM1.LocaleSidKey = 'en_US';
        testSM1.EmailEncodingKey = 'UTF-8';
        testSM1.LanguageLocaleKey = 'en_US';
        testSM1.ProfileId = profileID;
        testSM1.ManagerId = testEVP.Id;
        insert testSM1;
        
        User testSM2 = new User();
        testSM2.FirstName = 'test';
        testSM2.LastName = 'SM2';
        testSM2.Forecast_Role__c = 'SM2';
        testSM1.Forecast_Role__c = 'SM2';
        testSM2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM2.Username = 'testSM2@catalinamarketing.com.testuser';
        testSM2.Alias = 'testSM2';
        testSM2.CommunityNickname = 'testSM2';
        testSM2.TimeZoneSidKey = 'GMT';
        testSM2.LocaleSidKey = 'en_US';
        testSM2.EmailEncodingKey = 'UTF-8';
        testSM2.LanguageLocaleKey = 'en_US';
        testSM2.ProfileId = profileID;
        testSM2.ManagerId = testSM1.Id;
        insert testSM2;
        
        User testSR1 = new User();
        testSR1.FirstName = 'test';
        testSR1.LastName = 'SR1';
        testSR1.Forecast_Role__c = 'SR1';
        testSM1.Forecast_Role__c = 'SR1';
        testSR1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR1.Username = 'testSR1@catalinamarketing.com.testuser';
        testSR1.Alias = 'testSR1';
        testSR1.CommunityNickname = 'testSR1';
        testSR1.TimeZoneSidKey = 'GMT';
        testSR1.LocaleSidKey = 'en_US';
        testSR1.EmailEncodingKey = 'UTF-8';
        testSR1.LanguageLocaleKey = 'en_US';
        testSR1.ProfileId = profileID;
        testSR1.ManagerId = testSM2.Id;
        insert testSR1;
        
        User testSR2 = new User();
        testSR2.FirstName = 'test';
        testSR2.LastName = 'SR2';
        testSR2.Forecast_Role__c = 'SR2';
        testSR2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR2.Username = 'testSR2@catalinamarketing.com.testuser';
        testSR2.Alias = 'testSR2';
        testSR2.CommunityNickname = 'testSR2';
        testSR2.TimeZoneSidKey = 'GMT';
        testSR2.LocaleSidKey = 'en_US';
        testSR2.EmailEncodingKey = 'UTF-8';
        testSR2.LanguageLocaleKey = 'en_US';
        testSR2.ProfileId = profileID;
        testSR2.ManagerId = testSR1.Id;
        insert testSR2;
        
        Account a = new Account();
        a.Name = 'Test Account';
        a.RecordTypeId = accountRTID;
        insert a;
        
        Opportunity o = new Opportunity();
        o.OwnerId = testSR2.Id;
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
        
        Ad_Period__c ap3 = new Ad_Period__c();
        ap3.Name = 'C1_CY2012_test';
        ap3.Start_Date__c = Date.valueOf('2012-12-23');
        ap3.End_Date__c = Date.valueOf('2012-01-19');
        ap3.Type__c = 'Manufacturing';
        insert ap3;
        
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
        pf1.Ad_Period__c = ap1.Id;
        pf1.Forecast_Amount__c = 1000;
        insert pf1;
        
        Program_Forecast__c pf2 = new Program_Forecast__c();
        pf2.Program__c = p.Id;
        pf2.Ad_Period__c = ap3.Id;
        pf2.Forecast_Amount__c = 1000;
        pf2.Active__c = false;
        insert pf2;
        
        Test.startTest();
        BatchDeactivateProgramForecasts obj = new BatchDeactivateProgramForecasts();
        BatchDeactivateProgramForecasts u = new BatchDeactivateProgramForecasts('LIMIT 5');
        Database.executeBatch(u, 400);
        String sch = '0 0 23 * * ?'; 
        system.schedule('BatchDeactivateProgramForecasts', sch, u); 
        Test.stopTest();
    }
    
    static testMethod void testBatchDeleteSM1Forecast() {
        // TO DO: implement unit test
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
        
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
        
        User testSM1 = new User();
        testSM1.FirstName = 'test';
        testSM1.LastName = 'SM1';
        testSM1.Forecast_Role__c = 'SM1';
        testSM1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Username = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Alias = 'testSM1';
        testSM1.CommunityNickname = 'testSM1';
        testSM1.TimeZoneSidKey = 'GMT';
        testSM1.LocaleSidKey = 'en_US';
        testSM1.EmailEncodingKey = 'UTF-8';
        testSM1.LanguageLocaleKey = 'en_US';
        testSM1.ProfileId = profileID;
        testSM1.ManagerId = testEVP.Id;
        insert testSM1;
        
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
               
        Sales_Manager_1_Forecast__c sm1 = new Sales_Manager_1_Forecast__c();
        sm1.OwnerId = testSM1.Id;
        sm1.Quarter__c = 'Q2012';
        sm1.Manager__c = testEVP.Id;
        sm1.Account_Type__c = 'Manufacturing';
        sm1.Delivery_Type__c = 'Digital O&O';
        sm1.Account__c = a.Id;
        insert sm1;
        
        Test.startTest();
        BatchDeleteSM1Forecast u = new BatchDeleteSM1Forecast('LIMIT 400');
        Database.executeBatch(u, 400);
        Test.stopTest();
    }
    
    static testMethod void testBatchDeleteSM2Forecast() {
        // TO DO: implement unit test
        Sales_Manager_2_Forecast__c sm1 = new Sales_Manager_2_Forecast__c();
        insert sm1;
        
        Test.startTest();
        BatchDeleteSM2Forecast u = new BatchDeleteSM2Forecast('LIMIT 400');
        Database.executeBatch(u, 400);
        Test.stopTest();
    }
    
    static testMethod void testBatchDeleteSR1Forecast() {
        // TO DO: implement unit test
        Rep_1_Forecast__c sm1 = new Rep_1_Forecast__c();
        insert sm1;
        
        Test.startTest();
        BatchDeleteSR1Forecast u = new BatchDeleteSR1Forecast('LIMIT 400');
        Database.executeBatch(u, 400);
        Test.stopTest();
    }
    
    static testMethod void testBatchDeleteSR2Forecast() {
        // TO DO: implement unit test
        Rep_2_Forecast__c sm1 = new Rep_2_Forecast__c();
        insert sm1;
        
        Test.startTest();
        BatchDeleteSR2Forecast u = new BatchDeleteSR2Forecast('LIMIT 400');
        Database.executeBatch(u, 400);
        Test.stopTest();
    }
    
    static testMethod void testBatchDeleteSM1FYTotals() {
        // TO DO: implement unit test
        Sales_Manager_1_FY_Total__c sm1 = new Sales_Manager_1_FY_Total__c();
        insert sm1;
        
        Test.startTest();
        BatchDeleteSM1FYTotals u = new BatchDeleteSM1FYTotals('LIMIT 400');
        Database.executeBatch(u, 400);
        Test.stopTest();
    }
    
    static testMethod void BatchDeleteManagerBestGuess() {
        // TO DO: implement unit test
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
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
        
        Manager_Best_Guess__c newMBG = new Manager_Best_Guess__c();
        newMBG.OwnerId = testEVP.Id;
        insert newMBG;
        
        Test.startTest();
        BatchDeleteManagerBestGuess u = new BatchDeleteManagerBestGuess('LIMIT 400');
        Database.executeBatch(u, 400);
        Test.stopTest();
    }
    
    static testMethod void BatchDeleteSalesRepBestGuess() {
        // TO DO: implement unit test
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
        String rtID = [SELECT ID FROM RecordType Where Name = 'Contract' and SOBJECTTYPE = 'Opportunity'][0].Id;
        String accountRTID = [SELECT ID FROM RecordType Where Name = 'Manufacturing' and SOBJECTTYPE = 'Account'][0].Id;
        
        Catalina_Forecast_Settings__c settings = getCatalinaForecastSettingsRecord();
        
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        User testSR1 = new User();
        testSR1.FirstName = 'test';
        testSR1.LastName = 'SR1';
        testSR1.Forecast_Role__c = 'SR1';
        testSR1.Email = 'testSR1@catalinamarketing.com.testuser';
        testSR1.Username = 'testSR1@catalinamarketing.com.testuser';
        testSR1.Alias = 'testSR1';
        testSR1.CommunityNickname = 'testSR1';
        testSR1.TimeZoneSidKey = 'GMT';
        testSR1.LocaleSidKey = 'en_US';
        testSR1.EmailEncodingKey = 'UTF-8';
        testSR1.LanguageLocaleKey = 'en_US';
        testSR1.ProfileId = profileID;
        insert testSR1;
        
        User testSM2 = new User();
        testSM2.FirstName = 'test';
        testSM2.LastName = 'SM2';
        testSM2.Forecast_Role__c = 'SM2';
        testSM2.Email = 'testSM2@catalinamarketing.com.testuser';
        testSM2.Username = 'testSM2@catalinamarketing.com.testuser';
        testSM2.Alias = 'testSM2';
        testSM2.CommunityNickname = 'testSM2';
        testSM2.TimeZoneSidKey = 'GMT';
        testSM2.LocaleSidKey = 'en_US';
        testSM2.EmailEncodingKey = 'UTF-8';
        testSM2.LanguageLocaleKey = 'en_US';
        testSM2.ProfileId = profileID;
        insert testSM2;
        
        Sales_Rep_Best_Guess__c newSRBG = new Sales_Rep_Best_Guess__c();
        newSRBG.OwnerId = testSR1.Id;
        insert newSRBG;
        
        Manager_Best_Guess__c mbg = new Manager_Best_Guess__c();
        mbg.Name = 'Test Manager';
        mbg.Ownerid = testSR1.Id;
        mbg.Quarter__c = 'Q12012';
        insert mbg;
        
        Sales_Rep_Best_Guess__c newSRBG2 = new Sales_Rep_Best_Guess__c();
        newSRBG2.OwnerId = testSM2.Id;
        newSRBG2.Quarter__c = 'Q12012';
        insert newSRBG2;
        
        Manager_Best_Guess__c mbg2 = new Manager_Best_Guess__c();
        mbg2.Name = 'Test Manager';
        mbg2.Quarter__c = 'Q12012';
        mbg2.Ownerid = testSM2.Id;
        insert mbg2;
        
        Test.startTest();
        BatchDeleteSalesRepBestGuess u = new BatchDeleteSalesRepBestGuess('2012');
        Database.executeBatch(u, 400);
        Test.stopTest();
    }

    static testMethod void testBatchCreateRepForecast() {
        // TO DO: implement unit test
        List<Sales_Manager_1_Forecast__c> list1 = [SELECT ID FROM Sales_Manager_1_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 2000];
        delete list1;
        List<Sales_Manager_2_Forecast__c> list2 = [SELECT ID FROM Sales_Manager_2_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 2000];
        delete list2;
        List<Rep_1_Forecast__c> list3 = [SELECT ID FROM Rep_1_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 2000];
        delete list3;
        List<Rep_2_Forecast__c> list4 = [SELECT ID FROM Rep_2_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 2000];
        delete list4;
        
        Catalina_Forecast_Settings__c settings = getCatalinaForecastSettingsRecord();
        
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
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
        
        User testSM1 = new User();
        testSM1.FirstName = 'test';
        testSM1.LastName = 'SM1';
        testSM1.Forecast_Role__c = 'SM1';
        testSM1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Username = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Alias = 'testSM1';
        testSM1.CommunityNickname = 'testSM1';
        testSM1.TimeZoneSidKey = 'GMT';
        testSM1.LocaleSidKey = 'en_US';
        testSM1.EmailEncodingKey = 'UTF-8';
        testSM1.LanguageLocaleKey = 'en_US';
        testSM1.ProfileId = profileID;
        testSM1.ManagerId = testEVP.Id;
        insert testSM1;
        
        User testSM2 = new User();
        testSM2.FirstName = 'test';
        testSM2.LastName = 'SM2';
        testSM2.Forecast_Role__c = 'SM2';
        testSM1.Forecast_Role__c = 'SM2';
        testSM2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM2.Username = 'testSM2@catalinamarketing.com.testuser';
        testSM2.Alias = 'testSM2';
        testSM2.CommunityNickname = 'testSM2';
        testSM2.TimeZoneSidKey = 'GMT';
        testSM2.LocaleSidKey = 'en_US';
        testSM2.EmailEncodingKey = 'UTF-8';
        testSM2.LanguageLocaleKey = 'en_US';
        testSM2.ProfileId = profileID;
        testSM2.ManagerId = testSM1.Id;
        insert testSM2;
        
        User testSR1 = new User();
        testSR1.FirstName = 'test';
        testSR1.LastName = 'SR1';
        testSR1.Forecast_Role__c = 'SR1';
        testSM1.Forecast_Role__c = 'SR1';
        testSR1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR1.Username = 'testSR1@catalinamarketing.com.testuser';
        testSR1.Alias = 'testSR1';
        testSR1.CommunityNickname = 'testSR1';
        testSR1.TimeZoneSidKey = 'GMT';
        testSR1.LocaleSidKey = 'en_US';
        testSR1.EmailEncodingKey = 'UTF-8';
        testSR1.LanguageLocaleKey = 'en_US';
        testSR1.ProfileId = profileID;
        testSR1.ManagerId = testSM2.Id;
        insert testSR1;
        
        User testSR2 = new User();
        testSR2.FirstName = 'test';
        testSR2.LastName = 'SR2';
        testSR2.Forecast_Role__c = 'SR2';
        testSR2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR2.Username = 'testSR2@catalinamarketing.com.testuser';
        testSR2.Alias = 'testSR2';
        testSR2.CommunityNickname = 'testSR2';
        testSR2.TimeZoneSidKey = 'GMT';
        testSR2.LocaleSidKey = 'en_US';
        testSR2.EmailEncodingKey = 'UTF-8';
        testSR2.LanguageLocaleKey = 'en_US';
        testSR2.ProfileId = profileID;
        testSR2.ManagerId = testSR1.Id;
        insert testSR2;
        
        Account a = new Account();
        a.Name = 'Test Account';
        a.RecordTypeId = accountRTID;
        insert a;
        
        Opportunity o = new Opportunity();
        o.OwnerId = testSR2.Id;
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
        pf1.Ad_Period__c = ap1.Id;
        pf1.Forecast_Amount__c = 1000;
        pf1.Active__c = true;
        insert pf1;
        /*
        Opportunity o2 = new Opportunity();
        o2.OwnerId = testSR1.Id;
        o2.AccountId = a.Id;
        o2.RecordTypeId = rtID;
        o2.Name = 'Test oppty';
        o2.StageName = 'Presented';
        o2.CloseDate = Date.today();
        insert o2;
        
        Ad_Period__c ap3 = new Ad_Period__c();
        ap3.Name = 'C1_CY2012_test';
        ap3.Start_Date__c = Date.valueOf('2012-12-23');
        ap3.End_Date__c = Date.valueOf('2012-01-19');
        ap3.Type__c = 'Manufacturing';
        insert ap3;
        
        Program__c p2 = new Program__c();
        p2.Name = o.Name + ' Base';
        p2.Opportunity__c = o2.Id;
        p2.Delivery_Type__c = 'Base';
        p2.Product_Type__c = 'Base Product Type1';
        p2.Start_Cycle__c = ap3.Id;
        p2.End_Cycle__c = ap2.Id;
        insert p2;
        
        Program_Forecast__c pf2 = new Program_Forecast__c();
        pf2.Program__c = p.Id;
        pf2.Ad_Period__c = ap3.Id;
        pf2.Forecast_Amount__c = 1000;
        pf2.Actual_Amount__c = 1000;
        pf2.Previous_Quarter_Actual__c = 200;
        pf2.Next_Quarter_Actual__c = 800;
        pf2.Active__c = false;
        insert pf2;
        */
        Test.startTest();
        BatchCreateRepForecast u = new BatchCreateRepForecast('LIMIT 400');
        Database.executeBatch(u, 400);
        Test.stopTest();
    }

    static testMethod void testBatchCreateRepForecastCOPY() {
        // TO DO: implement unit test
        List<Sales_Manager_1_Forecast__c> list1 = [SELECT ID FROM Sales_Manager_1_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 2000];
        delete list1;
        List<Sales_Manager_2_Forecast__c> list2 = [SELECT ID FROM Sales_Manager_2_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 2000];
        delete list2;
        List<Rep_1_Forecast__c> list3 = [SELECT ID FROM Rep_1_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 2000];
        delete list3;
        List<Rep_2_Forecast__c> list4 = [SELECT ID FROM Rep_2_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 2000];
        delete list4;
        
        Catalina_Forecast_Settings__c settings = getCatalinaForecastSettingsRecord();
        
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
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
        
        User testSM1 = new User();
        testSM1.FirstName = 'test';
        testSM1.LastName = 'SM1';
        testSM1.Forecast_Role__c = 'SM1';
        testSM1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Username = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Alias = 'testSM1';
        testSM1.CommunityNickname = 'testSM1';
        testSM1.TimeZoneSidKey = 'GMT';
        testSM1.LocaleSidKey = 'en_US';
        testSM1.EmailEncodingKey = 'UTF-8';
        testSM1.LanguageLocaleKey = 'en_US';
        testSM1.ProfileId = profileID;
        testSM1.ManagerId = testEVP.Id;
        insert testSM1;
        
        User testSM2 = new User();
        testSM2.FirstName = 'test';
        testSM2.LastName = 'SM2';
        testSM2.Forecast_Role__c = 'SM2';
        testSM1.Forecast_Role__c = 'SM2';
        testSM2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM2.Username = 'testSM2@catalinamarketing.com.testuser';
        testSM2.Alias = 'testSM2';
        testSM2.CommunityNickname = 'testSM2';
        testSM2.TimeZoneSidKey = 'GMT';
        testSM2.LocaleSidKey = 'en_US';
        testSM2.EmailEncodingKey = 'UTF-8';
        testSM2.LanguageLocaleKey = 'en_US';
        testSM2.ProfileId = profileID;
        testSM2.ManagerId = testSM1.Id;
        insert testSM2;
        
        User testSR1 = new User();
        testSR1.FirstName = 'test';
        testSR1.LastName = 'SR1';
        testSR1.Forecast_Role__c = 'SR1';
        testSM1.Forecast_Role__c = 'SR1';
        testSR1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR1.Username = 'testSR1@catalinamarketing.com.testuser';
        testSR1.Alias = 'testSR1';
        testSR1.CommunityNickname = 'testSR1';
        testSR1.TimeZoneSidKey = 'GMT';
        testSR1.LocaleSidKey = 'en_US';
        testSR1.EmailEncodingKey = 'UTF-8';
        testSR1.LanguageLocaleKey = 'en_US';
        testSR1.ProfileId = profileID;
        testSR1.ManagerId = testSM2.Id;
        insert testSR1;
        
        User testSR2 = new User();
        testSR2.FirstName = 'test';
        testSR2.LastName = 'SR2';
        testSR2.Forecast_Role__c = 'SR2';
        testSR2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR2.Username = 'testSR2@catalinamarketing.com.testuser';
        testSR2.Alias = 'testSR2';
        testSR2.CommunityNickname = 'testSR2';
        testSR2.TimeZoneSidKey = 'GMT';
        testSR2.LocaleSidKey = 'en_US';
        testSR2.EmailEncodingKey = 'UTF-8';
        testSR2.LanguageLocaleKey = 'en_US';
        testSR2.ProfileId = profileID;
        testSR2.ManagerId = testSR1.Id;
        insert testSR2;
        
        Account a = new Account();
        a.Name = 'Test Account';
        a.RecordTypeId = accountRTID;
        insert a;
        
        Opportunity o = new Opportunity();
        o.OwnerId = testSR2.Id;
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
        pf1.Ad_Period__c = ap1.Id;
        pf1.Forecast_Amount__c = 1000;
        pf1.Active__c = true;
        insert pf1;
        /*
        Opportunity o2 = new Opportunity();
        o2.OwnerId = testSR1.Id;
        o2.AccountId = a.Id;
        o2.RecordTypeId = rtID;
        o2.Name = 'Test oppty';
        o2.StageName = 'Presented';
        o2.CloseDate = Date.today();
        insert o2;
        
        Ad_Period__c ap3 = new Ad_Period__c();
        ap3.Name = 'C1_CY2012_test';
        ap3.Start_Date__c = Date.valueOf('2012-12-23');
        ap3.End_Date__c = Date.valueOf('2012-01-19');
        ap3.Type__c = 'Manufacturing';
        insert ap3;
        
        Program__c p2 = new Program__c();
        p2.Name = o.Name + ' Base';
        p2.Opportunity__c = o2.Id;
        p2.Delivery_Type__c = 'Base';
        p2.Product_Type__c = 'Base Product Type1';
        p2.Start_Cycle__c = ap3.Id;
        p2.End_Cycle__c = ap2.Id;
        insert p2;
        
        Program_Forecast__c pf2 = new Program_Forecast__c();
        pf2.Program__c = p.Id;
        pf2.Ad_Period__c = ap3.Id;
        pf2.Forecast_Amount__c = 1000;
        pf2.Actual_Amount__c = 1000;
        pf2.Previous_Quarter_Actual__c = 200;
        pf2.Next_Quarter_Actual__c = 800;
        pf2.Active__c = false;
        insert pf2;
        */
        Test.startTest();
        BatchCreateRepForecastCOPY u = new BatchCreateRepForecastCOPY('LIMIT 400');
        Database.executeBatch(u, 400);
        Test.stopTest();
    }
    
    static testMethod void testBatchFYTotal() {
        // TO DO: implement unit test
        Catalina_Forecast_Settings__c settings = getCatalinaForecastSettingsRecord();
        
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
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
        
        User testSM1 = new User();
        testSM1.FirstName = 'test';
        testSM1.LastName = 'SM1';
        testSM1.Forecast_Role__c = 'SM1';
        testSM1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Username = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Alias = 'testSM1';
        testSM1.CommunityNickname = 'testSM1';
        testSM1.TimeZoneSidKey = 'GMT';
        testSM1.LocaleSidKey = 'en_US';
        testSM1.EmailEncodingKey = 'UTF-8';
        testSM1.LanguageLocaleKey = 'en_US';
        testSM1.ProfileId = profileID;
        testSM1.ManagerId = testEVP.Id;
        insert testSM1;
        
        User testSM2 = new User();
        testSM2.FirstName = 'test';
        testSM2.LastName = 'SM2';
        testSM2.Forecast_Role__c = 'SM2';
        testSM1.Forecast_Role__c = 'SM2';
        testSM2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM2.Username = 'testSM2@catalinamarketing.com.testuser';
        testSM2.Alias = 'testSM2';
        testSM2.CommunityNickname = 'testSM2';
        testSM2.TimeZoneSidKey = 'GMT';
        testSM2.LocaleSidKey = 'en_US';
        testSM2.EmailEncodingKey = 'UTF-8';
        testSM2.LanguageLocaleKey = 'en_US';
        testSM2.ProfileId = profileID;
        testSM2.ManagerId = testSM1.Id;
        insert testSM2;
        
        User testSR1 = new User();
        testSR1.FirstName = 'test';
        testSR1.LastName = 'SR1';
        testSR1.Forecast_Role__c = 'SR1';
        testSM1.Forecast_Role__c = 'SR1';
        testSR1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR1.Username = 'testSR1@catalinamarketing.com.testuser';
        testSR1.Alias = 'testSR1';
        testSR1.CommunityNickname = 'testSR1';
        testSR1.TimeZoneSidKey = 'GMT';
        testSR1.LocaleSidKey = 'en_US';
        testSR1.EmailEncodingKey = 'UTF-8';
        testSR1.LanguageLocaleKey = 'en_US';
        testSR1.ProfileId = profileID;
        testSR1.ManagerId = testSM2.Id;
        insert testSR1;
        
        User testSR2 = new User();
        testSR2.FirstName = 'test';
        testSR2.LastName = 'SR2';
        testSR2.Forecast_Role__c = 'SR2';
        testSR2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR2.Username = 'testSR2@catalinamarketing.com.testuser';
        testSR2.Alias = 'testSR2';
        testSR2.CommunityNickname = 'testSR2';
        testSR2.TimeZoneSidKey = 'GMT';
        testSR2.LocaleSidKey = 'en_US';
        testSR2.EmailEncodingKey = 'UTF-8';
        testSR2.LanguageLocaleKey = 'en_US';
        testSR2.ProfileId = profileID;
        testSR2.ManagerId = testSR1.Id;
        insert testSR2;
        
        Account a = new Account();
        a.Name = 'Test Account';
        a.RecordTypeId = accountRTID;
        insert a;
        
        Opportunity o = new Opportunity();
        o.OwnerId = testSR2.Id;
        o.AccountId = a.Id;
        o.RecordTypeId = rtID;
        o.Name = 'Test oppty';
        o.StageName = 'Presented';
        o.CloseDate = Date.today();
        insert o;
        
        Ad_Period__c ap1 = new Ad_Period__c();
        ap1.Name = 'C2_CY2011_test';
        ap1.Start_Date__c = Date.valueOf('2011-03-23');
        ap1.End_Date__c = Date.valueOf('2011-04-19');
        ap1.Type__c = 'Manufacturing';
        insert ap1;
        
        Ad_Period__c ap2 = new Ad_Period__c();
        ap2.Name = 'C3_CY2012_test';
        ap2.Start_Date__c = Date.valueOf('2012-03-23');
        ap2.End_Date__c = Date.valueOf('2012-04-19');
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
        pf1.Ad_Period__c = ap1.Id;
        pf1.Forecast_Amount__c = 1000;
        insert pf1;
        Test.startTest();
        BatchFYTotal u = new BatchFYTotal('2011', 'LIMIT 400');
        Database.executeBatch(u, 400);
        Test.stopTest();
    }    

static testMethod void testBatchFYTotalCOPY() {
        // TO DO: implement unit test
        Catalina_Forecast_Settings__c settings = getCatalinaForecastSettingsRecord();
        
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
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
        
        User testSM1 = new User();
        testSM1.FirstName = 'test';
        testSM1.LastName = 'SM1';
        testSM1.Forecast_Role__c = 'SM1';
        testSM1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Username = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Alias = 'testSM1';
        testSM1.CommunityNickname = 'testSM1';
        testSM1.TimeZoneSidKey = 'GMT';
        testSM1.LocaleSidKey = 'en_US';
        testSM1.EmailEncodingKey = 'UTF-8';
        testSM1.LanguageLocaleKey = 'en_US';
        testSM1.ProfileId = profileID;
        testSM1.ManagerId = testEVP.Id;
        insert testSM1;
        
        User testSM2 = new User();
        testSM2.FirstName = 'test';
        testSM2.LastName = 'SM2';
        testSM2.Forecast_Role__c = 'SM2';
        testSM1.Forecast_Role__c = 'SM2';
        testSM2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM2.Username = 'testSM2@catalinamarketing.com.testuser';
        testSM2.Alias = 'testSM2';
        testSM2.CommunityNickname = 'testSM2';
        testSM2.TimeZoneSidKey = 'GMT';
        testSM2.LocaleSidKey = 'en_US';
        testSM2.EmailEncodingKey = 'UTF-8';
        testSM2.LanguageLocaleKey = 'en_US';
        testSM2.ProfileId = profileID;
        testSM2.ManagerId = testSM1.Id;
        insert testSM2;
        
        User testSR1 = new User();
        testSR1.FirstName = 'test';
        testSR1.LastName = 'SR1';
        testSR1.Forecast_Role__c = 'SR1';
        testSM1.Forecast_Role__c = 'SR1';
        testSR1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR1.Username = 'testSR1@catalinamarketing.com.testuser';
        testSR1.Alias = 'testSR1';
        testSR1.CommunityNickname = 'testSR1';
        testSR1.TimeZoneSidKey = 'GMT';
        testSR1.LocaleSidKey = 'en_US';
        testSR1.EmailEncodingKey = 'UTF-8';
        testSR1.LanguageLocaleKey = 'en_US';
        testSR1.ProfileId = profileID;
        testSR1.ManagerId = testSM2.Id;
        insert testSR1;
        
        User testSR2 = new User();
        testSR2.FirstName = 'test';
        testSR2.LastName = 'SR2';
        testSR2.Forecast_Role__c = 'SR2';
        testSR2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR2.Username = 'testSR2@catalinamarketing.com.testuser';
        testSR2.Alias = 'testSR2';
        testSR2.CommunityNickname = 'testSR2';
        testSR2.TimeZoneSidKey = 'GMT';
        testSR2.LocaleSidKey = 'en_US';
        testSR2.EmailEncodingKey = 'UTF-8';
        testSR2.LanguageLocaleKey = 'en_US';
        testSR2.ProfileId = profileID;
        testSR2.ManagerId = testSR1.Id;
        insert testSR2;
        
        Account a = new Account();
        a.Name = 'Test Account';
        a.RecordTypeId = accountRTID;
        insert a;
        
        Opportunity o = new Opportunity();
        o.OwnerId = testSR2.Id;
        o.AccountId = a.Id;
        o.RecordTypeId = rtID;
        o.Name = 'Test oppty';
        o.StageName = 'Presented';
        o.CloseDate = Date.today();
        insert o;
        
        Ad_Period__c ap1 = new Ad_Period__c();
        ap1.Name = 'C2_CY2011_test';
        ap1.Start_Date__c = Date.valueOf('2011-03-23');
        ap1.End_Date__c = Date.valueOf('2011-04-19');
        ap1.Type__c = 'Manufacturing';
        insert ap1;
        
        Ad_Period__c ap2 = new Ad_Period__c();
        ap2.Name = 'C3_CY2012_test';
        ap2.Start_Date__c = Date.valueOf('2012-03-23');
        ap2.End_Date__c = Date.valueOf('2012-04-19');
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
        pf1.Ad_Period__c = ap1.Id;
        pf1.Forecast_Amount__c = 1000;
        insert pf1;
        Test.startTest();
        BatchFYTotalCOPY u = new BatchFYTotalCOPY('2011', 'LIMIT 400');
        Database.executeBatch(u, 400);
        Test.stopTest();
    }    
    static testMethod void testBatchCreateAccountBG() {
        // TO DO: implement unit test
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
        String rtID = [SELECT ID FROM RecordType Where Name = 'Contract' and SOBJECTTYPE = 'Opportunity'][0].Id;
        String accountRTID = [SELECT ID FROM RecordType Where Name = 'Manufacturing' and SOBJECTTYPE = 'Account'][0].Id;
        
        Account a = new Account();
        a.Name = 'Test Conglomerate';
        a.Type = 'Conglomerate';
        a.RecordTypeId = accountRTID;
        a.Create_Best_Guess__c = true;
        insert a;
        
        Account_Best_Guess_Summary__c abg = new Account_Best_Guess_Summary__c();
        abg.Account__c = a.Id;
        abg.Year__c = '2012';
        insert abg;
        
        Test.startTest();
        BatchCreateAccountBG u = new BatchCreateAccountBG();
        Database.executeBatch(u, 400);
        Test.stopTest();
    }
    
    static testMethod void testBatchCreateBestGuess() {
        // TO DO: implement unit test
        Test.startTest();
        BatchCreateBestGuess u = new BatchCreateBestGuess('Q22012');
        Database.executeBatch(u, 400);
        Test.stopTest();
    }

    static testMethod void testBatchCreateBestGuess1() {
        // TO DO: implement unit test
        Test.startTest();
        BatchCreateBestGuess u1 = new BatchCreateBestGuess('Q32012');
        Database.executeBatch(u1, 400);
        Test.stopTest();
    }

    static testMethod void testBatchCreateBestGuess2() {
        // TO DO: implement unit test
        Test.startTest();
        BatchCreateBestGuess u1 = new BatchCreateBestGuess('Q42012');
        Database.executeBatch(u1, 400);
        Test.stopTest();
    }

    static testMethod void testBatchCreateBestGuess3() {
        // TO DO: implement unit test
        Test.startTest();
        BatchCreateBestGuess u1 = new BatchCreateBestGuess('Q12013');
        Database.executeBatch(u1, 400);
        Test.stopTest();
    } 
    static testMethod void testBatchCreateBestGuess4() {
        // TO DO: implement unit test
        Test.startTest();
        BatchCreateBestGuess u1 = new BatchCreateBestGuess('Q22013');
        Database.executeBatch(u1, 400);
        Test.stopTest();
    }
    static testMethod void testBatchCreateBestGuess5() {
        // TO DO: implement unit test
        Test.startTest();
        BatchCreateBestGuess u1 = new BatchCreateBestGuess('Q32013');
        Database.executeBatch(u1, 400);
        Test.stopTest();
    }    
    static testMethod void testBatchCreateBestGuess6() {
        // TO DO: implement unit test
        Test.startTest();
        BatchCreateBestGuess u1 = new BatchCreateBestGuess('Q42013');
        Database.executeBatch(u1, 400);
        Test.stopTest();
    }
    
    
    static testMethod void testBatchCreateBGShell(){
        Catalina_Forecast_Settings__c settings = getCatalinaForecastSettingsRecord();
        
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
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
        testEVP.IsActive = true;
        testEVP.COUNTRY__C = 'USA';
        testEVP.Does_Sell__c = true;
        insert testEVP;
        
        User testSM1 = new User();
        testSM1.FirstName = 'test';
        testSM1.LastName = 'SM1';
        testSM1.Forecast_Role__c = 'SM1';
        testSM1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Username = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Alias = 'testSM1';
        testSM1.CommunityNickname = 'testSM1';
        testSM1.TimeZoneSidKey = 'GMT';
        testSM1.LocaleSidKey = 'en_US';
        testSM1.EmailEncodingKey = 'UTF-8';
        testSM1.LanguageLocaleKey = 'en_US';
        testSM1.ProfileId = profileID;
        testSM1.ManagerId = testEVP.Id;
        testSM1.IsActive = true;
        testSM1.COUNTRY__C = 'USA';
        testSM1.Does_Sell__c = true;
        insert testSM1;
        
        User testSM2 = new User();
        testSM2.FirstName = 'test';
        testSM2.LastName = 'SM2';
        testSM2.Forecast_Role__c = 'SM2';
        testSM2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM2.Username = 'testSM2@catalinamarketing.com.testuser';
        testSM2.Alias = 'testSM2';
        testSM2.CommunityNickname = 'testSM2';
        testSM2.TimeZoneSidKey = 'GMT';
        testSM2.LocaleSidKey = 'en_US';
        testSM2.EmailEncodingKey = 'UTF-8';
        testSM2.LanguageLocaleKey = 'en_US';
        testSM2.ProfileId = profileID;
        testSM2.ManagerId = testSM1.Id;
        testSM2.IsActive = true;
        testSM2.COUNTRY__C = 'USA';
        testSM2.Does_Sell__c = true;
        insert testSM2;
        
        User testSR1 = new User();
        testSR1.FirstName = 'test';
        testSR1.LastName = 'SR1';
        testSR1.Forecast_Role__c = 'SR1';
        testSR1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR1.Username = 'testSR1@catalinamarketing.com.testuser';
        testSR1.Alias = 'testSR1';
        testSR1.CommunityNickname = 'testSR1';
        testSR1.TimeZoneSidKey = 'GMT';
        testSR1.LocaleSidKey = 'en_US';
        testSR1.EmailEncodingKey = 'UTF-8';
        testSR1.LanguageLocaleKey = 'en_US';
        testSR1.ProfileId = profileID;
        testSR1.ManagerId = testSM2.Id;
        testSR1.IsActive = true;
        testSR1.COUNTRY__C = 'USA';
        testSR1.Does_Sell__c = true;
        insert testSR1;
        
        User testSR2 = new User();
        testSR2.FirstName = 'test';
        testSR2.LastName = 'SR2';
        testSR2.Forecast_Role__c = 'SR2';
        testSR2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR2.Username = 'testSR2@catalinamarketing.com.testuser';
        testSR2.Alias = 'testSR2';
        testSR2.CommunityNickname = 'testSR2';
        testSR2.TimeZoneSidKey = 'GMT';
        testSR2.LocaleSidKey = 'en_US';
        testSR2.EmailEncodingKey = 'UTF-8';
        testSR2.LanguageLocaleKey = 'en_US';
        testSR2.ProfileId = profileID;
        testSR2.ManagerId = testSR1.Id;
        testSR2.IsActive = true;
        testSR2.COUNTRY__C = 'USA';
        testSR2.Does_Sell__c = true;
        insert testSR2;
        
        Manager_Best_Guess__c mbg = new Manager_Best_Guess__c();
        mbg.OwnerId = testSM2.Id;
        mbg.Manager__c = testSR2.Id;
        mbg.Quarter__c = 'Q12012';
        insert mbg;
        
        Sales_Rep_Best_Guess__c sbg = new Sales_Rep_Best_Guess__c();
        sbg.OwnerId = testSR2.Id;
        sbg.Manager__c = testSM2.Id;
        sbg.Quarter__c = 'Q12012';
        sbg.Manager_Best_Guess__c = mbg.Id;
        insert sbg;
        
        Test.startTest();
        BatchCreateBGShell u1 = new BatchCreateBGShell();    
        Database.executeBatch(u1, 400);
        Test.stopTest();
    } 
                      
    static testMethod void testBatchUpdateSDPY1() {
        // TO DO: implement unit test
        Catalina_Forecast_Settings__c settings = getCatalinaForecastSettingsRecord();
        
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        List<Sales_Manager_1_Forecast__c> list1 = [SELECT ID FROM Sales_Manager_1_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 1000];
        delete list1;
        List<Sales_Manager_2_Forecast__c> list2 = [SELECT ID FROM Sales_Manager_2_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 1000];
        delete list2;
        List<Rep_1_Forecast__c> list3 = [SELECT ID FROM Rep_1_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 1000];
        delete list3;
        List<Rep_2_Forecast__c> list4 = [SELECT ID FROM Rep_2_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 1000];
        delete list4;
        List<SDPY_Sales_Manager_1_Forecast__c> list5 = [SELECT ID FROM SDPY_Sales_Manager_1_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 1000];
        delete list5;
        List<SDPY_Sales_Manager_2_Forecast__c> list6 = [SELECT ID FROM SDPY_Sales_Manager_2_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 1000];
        delete list6;
        List<SDPY_Rep_1_Forecast__c> list7 = [SELECT ID FROM SDPY_Rep_1_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 1000];
        delete list7;
        List<SDPY_Rep_2_Forecast__c> list8 = [SELECT ID FROM SDPY_Rep_2_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 1000];
        delete list8;
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
        String rtID = [SELECT ID FROM RecordType Where Name = 'Contract' and SOBJECTTYPE = 'Opportunity'][0].Id;
        
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
        
        User testSM1 = new User();
        testSM1.FirstName = 'test';
        testSM1.LastName = 'SM1';
        testSM1.Forecast_Role__c = 'SM1';
        testSM1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Username = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Alias = 'testSM1';
        testSM1.CommunityNickname = 'testSM1';
        testSM1.TimeZoneSidKey = 'GMT';
        testSM1.LocaleSidKey = 'en_US';
        testSM1.EmailEncodingKey = 'UTF-8';
        testSM1.LanguageLocaleKey = 'en_US';
        testSM1.ProfileId = profileID;
        testSM1.ManagerId = testEVP.Id;
        insert testSM1;
        
        User testSM2 = new User();
        testSM2.FirstName = 'test';
        testSM2.LastName = 'SM2';
        testSM2.Forecast_Role__c = 'SM2';
        testSM1.Forecast_Role__c = 'SM2';
        testSM2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM2.Username = 'testSM2@catalinamarketing.com.testuser';
        testSM2.Alias = 'testSM2';
        testSM2.CommunityNickname = 'testSM2';
        testSM2.TimeZoneSidKey = 'GMT';
        testSM2.LocaleSidKey = 'en_US';
        testSM2.EmailEncodingKey = 'UTF-8';
        testSM2.LanguageLocaleKey = 'en_US';
        testSM2.ProfileId = profileID;
        testSM2.ManagerId = testSM1.Id;
        insert testSM2;
        
        User testSR1 = new User();
        testSR1.FirstName = 'test';
        testSR1.LastName = 'SR1';
        testSR1.Forecast_Role__c = 'SR1';
        testSM1.Forecast_Role__c = 'SR1';
        testSR1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR1.Username = 'testSR1@catalinamarketing.com.testuser';
        testSR1.Alias = 'testSR1';
        testSR1.CommunityNickname = 'testSR1';
        testSR1.TimeZoneSidKey = 'GMT';
        testSR1.LocaleSidKey = 'en_US';
        testSR1.EmailEncodingKey = 'UTF-8';
        testSR1.LanguageLocaleKey = 'en_US';
        testSR1.ProfileId = profileID;
        testSR1.ManagerId = testSM2.Id;
        insert testSR1;
        
        User testSR2 = new User();
        testSR2.FirstName = 'test';
        testSR2.LastName = 'SR2';
        testSR2.Forecast_Role__c = 'SR2';
        testSR2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR2.Username = 'testSR2@catalinamarketing.com.testuser';
        testSR2.Alias = 'testSR2';
        testSR2.CommunityNickname = 'testSR2';
        testSR2.TimeZoneSidKey = 'GMT';
        testSR2.LocaleSidKey = 'en_US';
        testSR2.EmailEncodingKey = 'UTF-8';
        testSR2.LanguageLocaleKey = 'en_US';
        testSR2.ProfileId = profileID;
        testSR2.ManagerId = testSR1.Id;
        insert testSR2;
        
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        
        Opportunity o = new Opportunity();
        o.OwnerId = testSR2.Id;
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
        
        Archive_Program__c p = new Archive_Program__c();
        p.Name = o.Name + ' Base';
        p.Ext_ID__c = '01234567890123456';
        p.Opportunity__c = o.Id;
        p.Delivery_Type__c = 'Base';
        p.Product_Type__c = 'Base Product Type1';
        p.Archive_Date__c = Date.today().addYears(-1).addDays(1);
        insert p;
        
        Archive_Product_Type_Split__c apts = new Archive_Product_Type_Split__c();
        apts.Program__c = p.Id;
        apts.Product_Type__c = 'Base Product Type1';
        apts.Percent__c = 100;
        insert apts;
        
        Archive_Program_Forecast__c pf1 = new Archive_Program_Forecast__c();
        pf1.Program__c = p.Id;
        pf1.Ext_ID__c = '012345678901234567';
        pf1.Ad_Period__c = ap1.Id;
        pf1.Forecast_Amount__c = 1000;
        pf1.Archive_Date__c = Date.today().addYears(-1).addDays(1);
        pf1.Actual_Amount__c = 1000;
        pf1.Active__c = false;
        insert pf1;
        
        Test.startTest();
        BatchUpdateSDPY u = new BatchUpdateSDPY('LIMIT 400');
        Database.executeBatch(u, 400);
        Test.stopTest();
    }

    static testMethod void testBatchUpdateSDPY1COPY() {
        // TO DO: implement unit test
        Catalina_Forecast_Settings__c settings = getCatalinaForecastSettingsRecord();
        
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        List<Sales_Manager_1_Forecast__c> list1 = [SELECT ID FROM Sales_Manager_1_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 1000];
        delete list1;
        List<Sales_Manager_2_Forecast__c> list2 = [SELECT ID FROM Sales_Manager_2_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 1000];
        delete list2;
        List<Rep_1_Forecast__c> list3 = [SELECT ID FROM Rep_1_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 1000];
        delete list3;
        List<Rep_2_Forecast__c> list4 = [SELECT ID FROM Rep_2_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 1000];
        delete list4;
        List<SDPY_Sales_Manager_1_Forecast__c> list5 = [SELECT ID FROM SDPY_Sales_Manager_1_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 1000];
        delete list5;
        List<SDPY_Sales_Manager_2_Forecast__c> list6 = [SELECT ID FROM SDPY_Sales_Manager_2_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 1000];
        delete list6;
        List<SDPY_Rep_1_Forecast__c> list7 = [SELECT ID FROM SDPY_Rep_1_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 1000];
        delete list7;
        List<SDPY_Rep_2_Forecast__c> list8 = [SELECT ID FROM SDPY_Rep_2_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 1000];
        delete list8;
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
        String rtID = [SELECT ID FROM RecordType Where Name = 'Contract' and SOBJECTTYPE = 'Opportunity'][0].Id;
        
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
        
        User testSM1 = new User();
        testSM1.FirstName = 'test';
        testSM1.LastName = 'SM1';
        testSM1.Forecast_Role__c = 'SM1';
        testSM1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Username = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Alias = 'testSM1';
        testSM1.CommunityNickname = 'testSM1';
        testSM1.TimeZoneSidKey = 'GMT';
        testSM1.LocaleSidKey = 'en_US';
        testSM1.EmailEncodingKey = 'UTF-8';
        testSM1.LanguageLocaleKey = 'en_US';
        testSM1.ProfileId = profileID;
        testSM1.ManagerId = testEVP.Id;
        insert testSM1;
        
        User testSM2 = new User();
        testSM2.FirstName = 'test';
        testSM2.LastName = 'SM2';
        testSM2.Forecast_Role__c = 'SM2';
        testSM1.Forecast_Role__c = 'SM2';
        testSM2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM2.Username = 'testSM2@catalinamarketing.com.testuser';
        testSM2.Alias = 'testSM2';
        testSM2.CommunityNickname = 'testSM2';
        testSM2.TimeZoneSidKey = 'GMT';
        testSM2.LocaleSidKey = 'en_US';
        testSM2.EmailEncodingKey = 'UTF-8';
        testSM2.LanguageLocaleKey = 'en_US';
        testSM2.ProfileId = profileID;
        testSM2.ManagerId = testSM1.Id;
        insert testSM2;
        
        User testSR1 = new User();
        testSR1.FirstName = 'test';
        testSR1.LastName = 'SR1';
        testSR1.Forecast_Role__c = 'SR1';
        testSM1.Forecast_Role__c = 'SR1';
        testSR1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR1.Username = 'testSR1@catalinamarketing.com.testuser';
        testSR1.Alias = 'testSR1';
        testSR1.CommunityNickname = 'testSR1';
        testSR1.TimeZoneSidKey = 'GMT';
        testSR1.LocaleSidKey = 'en_US';
        testSR1.EmailEncodingKey = 'UTF-8';
        testSR1.LanguageLocaleKey = 'en_US';
        testSR1.ProfileId = profileID;
        testSR1.ManagerId = testSM2.Id;
        insert testSR1;
        
        User testSR2 = new User();
        testSR2.FirstName = 'test';
        testSR2.LastName = 'SR2';
        testSR2.Forecast_Role__c = 'SR2';
        testSR2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR2.Username = 'testSR2@catalinamarketing.com.testuser';
        testSR2.Alias = 'testSR2';
        testSR2.CommunityNickname = 'testSR2';
        testSR2.TimeZoneSidKey = 'GMT';
        testSR2.LocaleSidKey = 'en_US';
        testSR2.EmailEncodingKey = 'UTF-8';
        testSR2.LanguageLocaleKey = 'en_US';
        testSR2.ProfileId = profileID;
        testSR2.ManagerId = testSR1.Id;
        insert testSR2;
        
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        
        Opportunity o = new Opportunity();
        o.OwnerId = testSR2.Id;
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
        
        Archive_Program__c p = new Archive_Program__c();
        p.Name = o.Name + ' Base';
        p.Ext_ID__c = '01234567890123456';
        p.Opportunity__c = o.Id;
        p.Delivery_Type__c = 'Base';
        p.Product_Type__c = 'Base Product Type1';
        p.Archive_Date__c = Date.today().addYears(-1).addDays(1);
        insert p;
        
        Archive_Product_Type_Split__c apts = new Archive_Product_Type_Split__c();
        apts.Program__c = p.Id;
        apts.Product_Type__c = 'Base Product Type1';
        apts.Percent__c = 100;
        insert apts;
        
        Archive_Program_Forecast__c pf1 = new Archive_Program_Forecast__c();
        pf1.Program__c = p.Id;
        pf1.Ext_ID__c = '012345678901234567';
        pf1.Ad_Period__c = ap1.Id;
        pf1.Forecast_Amount__c = 1000;
        pf1.Archive_Date__c = Date.today().addYears(-1).addDays(1);
        pf1.Actual_Amount__c = 1000;
        pf1.Active__c = false;
        insert pf1;
        
        Test.startTest();
        BatchUpdateSDPYCOPY u = new BatchUpdateSDPYCOPY('LIMIT 400');
        Database.executeBatch(u, 400);
        Test.stopTest();
    }
        
    static testMethod void testBatchUpdateSDPY2() {
        // TO DO: implement unit test
        Catalina_Forecast_Settings__c settings = getCatalinaForecastSettingsRecord();
        
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        List<Sales_Manager_1_Forecast__c> list1 = [SELECT ID FROM Sales_Manager_1_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 1000];
        delete list1;
        List<Sales_Manager_2_Forecast__c> list2 = [SELECT ID FROM Sales_Manager_2_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 1000];
        delete list2;
        List<Rep_1_Forecast__c> list3 = [SELECT ID FROM Rep_1_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 1000];
        delete list3;
        List<Rep_2_Forecast__c> list4 = [SELECT ID FROM Rep_2_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 1000];
        delete list4;
        List<SDPY_Sales_Manager_1_Forecast__c> list5 = [SELECT ID FROM SDPY_Sales_Manager_1_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 1000];
        delete list5;
        List<SDPY_Sales_Manager_2_Forecast__c> list6 = [SELECT ID FROM SDPY_Sales_Manager_2_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 1000];
        delete list6;
        List<SDPY_Rep_1_Forecast__c> list7 = [SELECT ID FROM SDPY_Rep_1_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 1000];
        delete list7;
        List<SDPY_Rep_2_Forecast__c> list8 = [SELECT ID FROM SDPY_Rep_2_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 1000];
        delete list8;
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
        String rtID = [SELECT ID FROM RecordType Where Name = 'Contract' and SOBJECTTYPE = 'Opportunity'][0].Id;
        
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
        
        User testSM1 = new User();
        testSM1.FirstName = 'test';
        testSM1.LastName = 'SM1';
        testSM1.Forecast_Role__c = 'SM1';
        testSM1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Username = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Alias = 'testSM1';
        testSM1.CommunityNickname = 'testSM1';
        testSM1.TimeZoneSidKey = 'GMT';
        testSM1.LocaleSidKey = 'en_US';
        testSM1.EmailEncodingKey = 'UTF-8';
        testSM1.LanguageLocaleKey = 'en_US';
        testSM1.ProfileId = profileID;
        testSM1.ManagerId = testEVP.Id;
        insert testSM1;
        
        User testSM2 = new User();
        testSM2.FirstName = 'test';
        testSM2.LastName = 'SM2';
        testSM2.Forecast_Role__c = 'SM2';
        testSM1.Forecast_Role__c = 'SM2';
        testSM2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM2.Username = 'testSM2@catalinamarketing.com.testuser';
        testSM2.Alias = 'testSM2';
        testSM2.CommunityNickname = 'testSM2';
        testSM2.TimeZoneSidKey = 'GMT';
        testSM2.LocaleSidKey = 'en_US';
        testSM2.EmailEncodingKey = 'UTF-8';
        testSM2.LanguageLocaleKey = 'en_US';
        testSM2.ProfileId = profileID;
        testSM2.ManagerId = testSM1.Id;
        insert testSM2;
        
        User testSR1 = new User();
        testSR1.FirstName = 'test';
        testSR1.LastName = 'SR1';
        testSR1.Forecast_Role__c = 'SR1';
        testSM1.Forecast_Role__c = 'SR1';
        testSR1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR1.Username = 'testSR1@catalinamarketing.com.testuser';
        testSR1.Alias = 'testSR1';
        testSR1.CommunityNickname = 'testSR1';
        testSR1.TimeZoneSidKey = 'GMT';
        testSR1.LocaleSidKey = 'en_US';
        testSR1.EmailEncodingKey = 'UTF-8';
        testSR1.LanguageLocaleKey = 'en_US';
        testSR1.ProfileId = profileID;
        testSR1.ManagerId = testSM2.Id;
        insert testSR1;
        
        User testSR2 = new User();
        testSR2.FirstName = 'test';
        testSR2.LastName = 'SR2';
        testSR2.Forecast_Role__c = 'SR2';
        testSR2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR2.Username = 'testSR2@catalinamarketing.com.testuser';
        testSR2.Alias = 'testSR2';
        testSR2.CommunityNickname = 'testSR2';
        testSR2.TimeZoneSidKey = 'GMT';
        testSR2.LocaleSidKey = 'en_US';
        testSR2.EmailEncodingKey = 'UTF-8';
        testSR2.LanguageLocaleKey = 'en_US';
        testSR2.ProfileId = profileID;
        testSR2.ManagerId = testSR1.Id;
        insert testSR2;
        
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        
        Opportunity o = new Opportunity();
        o.OwnerId = testSR2.Id;
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
        
        Archive_Program__c p = new Archive_Program__c();
        p.Name = o.Name + ' Base';
        p.Ext_ID__c = '01234567890123456';
        p.Opportunity__c = o.Id;
        p.Delivery_Type__c = 'Base';
        p.Product_Type__c = 'Base Product Type1';
        p.Archive_Date__c = Date.today().addYears(-1).addDays(-1);
        insert p;
        
        Archive_Product_Type_Split__c apts = new Archive_Product_Type_Split__c();
        apts.Program__c = p.Id;
        apts.Product_Type__c = 'Base Product Type1';
        apts.Percent__c = 100;
        insert apts;
        
        Archive_Program_Forecast__c pf1 = new Archive_Program_Forecast__c();
        pf1.Program__c = p.Id;
        pf1.Ext_ID__c = '012345678901234567';
        pf1.Ad_Period__c = ap1.Id;
        pf1.Forecast_Amount__c = 1000;
        pf1.Archive_Date__c = Date.today().addYears(-1).addDays(-1);
        pf1.Actual_Amount__c = 1000;
        pf1.Active__c = false;
        insert pf1;
        
        Test.startTest();
        BatchUpdateSDPY u = new BatchUpdateSDPY('LIMIT 400');
        Database.executeBatch(u, 400);
        Test.stopTest();
    }
static testMethod void testBatchUpdateSDPY2COPY() {
        // TO DO: implement unit test
        Catalina_Forecast_Settings__c settings = getCatalinaForecastSettingsRecord();
        
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        List<Sales_Manager_1_Forecast__c> list1 = [SELECT ID FROM Sales_Manager_1_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 1000];
        delete list1;
        List<Sales_Manager_2_Forecast__c> list2 = [SELECT ID FROM Sales_Manager_2_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 1000];
        delete list2;
        List<Rep_1_Forecast__c> list3 = [SELECT ID FROM Rep_1_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 1000];
        delete list3;
        List<Rep_2_Forecast__c> list4 = [SELECT ID FROM Rep_2_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 1000];
        delete list4;
        List<SDPY_Sales_Manager_1_Forecast__c> list5 = [SELECT ID FROM SDPY_Sales_Manager_1_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 1000];
        delete list5;
        List<SDPY_Sales_Manager_2_Forecast__c> list6 = [SELECT ID FROM SDPY_Sales_Manager_2_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 1000];
        delete list6;
        List<SDPY_Rep_1_Forecast__c> list7 = [SELECT ID FROM SDPY_Rep_1_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 1000];
        delete list7;
        List<SDPY_Rep_2_Forecast__c> list8 = [SELECT ID FROM SDPY_Rep_2_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 1000];
        delete list8;
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
        String rtID = [SELECT ID FROM RecordType Where Name = 'Contract' and SOBJECTTYPE = 'Opportunity'][0].Id;
        
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
        
        User testSM1 = new User();
        testSM1.FirstName = 'test';
        testSM1.LastName = 'SM1';
        testSM1.Forecast_Role__c = 'SM1';
        testSM1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Username = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Alias = 'testSM1';
        testSM1.CommunityNickname = 'testSM1';
        testSM1.TimeZoneSidKey = 'GMT';
        testSM1.LocaleSidKey = 'en_US';
        testSM1.EmailEncodingKey = 'UTF-8';
        testSM1.LanguageLocaleKey = 'en_US';
        testSM1.ProfileId = profileID;
        testSM1.ManagerId = testEVP.Id;
        insert testSM1;
        
        User testSM2 = new User();
        testSM2.FirstName = 'test';
        testSM2.LastName = 'SM2';
        testSM2.Forecast_Role__c = 'SM2';
        testSM1.Forecast_Role__c = 'SM2';
        testSM2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM2.Username = 'testSM2@catalinamarketing.com.testuser';
        testSM2.Alias = 'testSM2';
        testSM2.CommunityNickname = 'testSM2';
        testSM2.TimeZoneSidKey = 'GMT';
        testSM2.LocaleSidKey = 'en_US';
        testSM2.EmailEncodingKey = 'UTF-8';
        testSM2.LanguageLocaleKey = 'en_US';
        testSM2.ProfileId = profileID;
        testSM2.ManagerId = testSM1.Id;
        insert testSM2;
        
        User testSR1 = new User();
        testSR1.FirstName = 'test';
        testSR1.LastName = 'SR1';
        testSR1.Forecast_Role__c = 'SR1';
        testSM1.Forecast_Role__c = 'SR1';
        testSR1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR1.Username = 'testSR1@catalinamarketing.com.testuser';
        testSR1.Alias = 'testSR1';
        testSR1.CommunityNickname = 'testSR1';
        testSR1.TimeZoneSidKey = 'GMT';
        testSR1.LocaleSidKey = 'en_US';
        testSR1.EmailEncodingKey = 'UTF-8';
        testSR1.LanguageLocaleKey = 'en_US';
        testSR1.ProfileId = profileID;
        testSR1.ManagerId = testSM2.Id;
        insert testSR1;
        
        User testSR2 = new User();
        testSR2.FirstName = 'test';
        testSR2.LastName = 'SR2';
        testSR2.Forecast_Role__c = 'SR2';
        testSR2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR2.Username = 'testSR2@catalinamarketing.com.testuser';
        testSR2.Alias = 'testSR2';
        testSR2.CommunityNickname = 'testSR2';
        testSR2.TimeZoneSidKey = 'GMT';
        testSR2.LocaleSidKey = 'en_US';
        testSR2.EmailEncodingKey = 'UTF-8';
        testSR2.LanguageLocaleKey = 'en_US';
        testSR2.ProfileId = profileID;
        testSR2.ManagerId = testSR1.Id;
        insert testSR2;
        
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        
        Opportunity o = new Opportunity();
        o.OwnerId = testSR2.Id;
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
        
        Archive_Program__c p = new Archive_Program__c();
        p.Name = o.Name + ' Base';
        p.Ext_ID__c = '01234567890123456';
        p.Opportunity__c = o.Id;
        p.Delivery_Type__c = 'Base';
        p.Product_Type__c = 'Base Product Type1';
        p.Archive_Date__c = Date.today().addYears(-1).addDays(-1);
        insert p;
        
        Archive_Product_Type_Split__c apts = new Archive_Product_Type_Split__c();
        apts.Program__c = p.Id;
        apts.Product_Type__c = 'Base Product Type1';
        apts.Percent__c = 100;
        insert apts;
        
        Archive_Program_Forecast__c pf1 = new Archive_Program_Forecast__c();
        pf1.Program__c = p.Id;
        pf1.Ext_ID__c = '012345678901234567';
        pf1.Ad_Period__c = ap1.Id;
        pf1.Forecast_Amount__c = 1000;
        pf1.Archive_Date__c = Date.today().addYears(-1).addDays(-1);
        pf1.Actual_Amount__c = 1000;
        pf1.Active__c = false;
        insert pf1;
        
        Test.startTest();
        BatchUpdateSDPYCOPY u = new BatchUpdateSDPYCOPY('LIMIT 400');
        Database.executeBatch(u, 400);
        Test.stopTest();
    }    
    static testMethod void testBatchCalculateBestGuess() {
        // TO DO: implement unit test
        Catalina_Forecast_Settings__c settings = getCatalinaForecastSettingsRecord();
        
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
        String rtID = [SELECT ID FROM RecordType Where Name = 'Contract' and SOBJECTTYPE = 'Opportunity'][0].Id;
        String rtID2 = [SELECT ID FROM RecordType Where Name = 'Proposal' and SOBJECTTYPE = 'Opportunity'][0].Id;
        String accountRTID = [SELECT ID FROM RecordType Where Name = 'Manufacturing' and SOBJECTTYPE = 'Account'][0].Id;
        String accountRTIDRetail = [SELECT ID FROM RecordType Where Name = 'Retail' and SOBJECTTYPE = 'Account'][0].Id;
        String progrtID = [SELECT ID FROM RecordType Where Name = 'Contract' and SOBJECTTYPE = 'Program__c'][0].Id;
        String progrtID2 = [SELECT ID FROM RecordType Where Name = 'Proposal' and SOBJECTTYPE = 'Program__c'][0].Id;
        
        User testEVP = new User(FirstName = 'test', LastName = 'EVP', Forecast_Role__c = 'EVP', Email = 'testEVP@catalinamarketing.com.testuser', 
        Username = 'testEVP@catalinamarketing.com.testuser', Alias = 'testEVP', CommunityNickname = 'testEVP', TimeZoneSidKey = 'GMT', LocaleSidKey = 'en_US', 
        EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', ProfileId = profileID);
        insert testEVP;
        
        User testSM1 = new User(FirstName = 'test',ManagerId = testEVP.Id,LanguageLocaleKey = 'en_US',ProfileId = profileID,LastName = 'SM1', 
        Forecast_Role__c = 'SM1',Email = 'testSM1@catalinamarketing.com.testuser',Username = 'testSM1@catalinamarketing.com.testuser',Alias = 'testSM1',
        CommunityNickname = 'testSM1',TimeZoneSidKey = 'GMT',LocaleSidKey = 'en_US',EmailEncodingKey = 'UTF-8');
        insert testSM1;
        
        User testSM2 = new User( FirstName = 'test', LastName = 'SM2', Forecast_Role__c = 'SM2', Email = 'testSM1@catalinamarketing.com.testuser', 
        Username = 'testSM2@catalinamarketing.com.testuser', Alias = 'testSM2', CommunityNickname = 'testSM2', TimeZoneSidKey = 'GMT', LocaleSidKey = 'en_US', 
        EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', ProfileId = profileID, ManagerId = testSM1.Id);
        insert testSM2;
        
        User testSR1 = new User(FirstName = 'test',LastName = 'SR1',Forecast_Role__c = 'SR1',Email = 'testSM1@catalinamarketing.com.testuser',
        Username = 'testSR1@catalinamarketing.com.testuser',Alias = 'testSR1',CommunityNickname = 'testSR1',TimeZoneSidKey = 'GMT',
        LocaleSidKey = 'en_US',EmailEncodingKey = 'UTF-8',LanguageLocaleKey = 'en_US',ProfileId = profileID,ManagerId = testSM2.Id);
        insert testSR1;
        
        User testSR2 = new User( FirstName = 'test', LastName = 'SR2', Forecast_Role__c = 'SR2', Email = 'testSM1@catalinamarketing.com.testuser', 
        Username = 'testSR2@catalinamarketing.com.testuser', Alias = 'testSR2', CommunityNickname = 'testSR2', TimeZoneSidKey = 'GMT', LocaleSidKey = 'en_US', 
        EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', ProfileId = profileID, ManagerId = testSR1.Id);
        insert testSR2;
        
        Account a = new Account(Name = 'Test Account', RecordTypeId = accountRTID);
        insert a;
        
        Opportunity o = new Opportunity( OwnerId = testSR2.Id, AccountId = a.Id, RecordTypeId = rtID, Name = 'Test oppty', StageName = 'Presented', CloseDate = Date.today());
        insert o;
        
        Opportunity o2 = new Opportunity( OwnerId = testSR2.Id, AccountId = a.Id, RecordTypeId = rtID, Name = 'Test oppty', StageName = 'Presented', CloseDate = Date.today());
        insert o2;
        
        Ad_Period__c ap1 = new Ad_Period__c(Name = 'C2_CY2012_test', Start_Date__c = Date.valueOf('2012-01-23'), End_Date__c = Date.valueOf('2012-02-19'), Type__c = 'Manufacturing');
        insert ap1;
        
        Ad_Period__c ap2 = new Ad_Period__c(Name = 'C3_CY2012_test', Start_Date__c = Date.valueOf('2012-01-23'), End_Date__c = Date.valueOf('2012-02-19'), Type__c = 'Manufacturing');
        insert ap2;
        
        Ad_Period__c ap3 = new Ad_Period__c( Name = 'C4_CY2012_test', Start_Date__c = Date.valueOf('2012-03-23'), End_Date__c = Date.valueOf('2012-04-19'), Type__c = 'Manufacturing');
        insert ap3;
        
        List<Program__c> progList = new List<Program__c>();
        
        Program__c p = new Program__c(Name = o.Name + ' Base', Opportunity__c = o.Id, RecordTypeId = progrtID, Delivery_Type__c = baseType, Product_Type__c = 'Base Product Type1', 
        Start_Cycle__c = ap1.Id, End_Cycle__c = ap2.Id);
        progList.add(p);
        
        Program__c p2 = new Program__c(Name = o2.Name + ' Base', Opportunity__c = o2.Id, RecordTypeId = progrtID2, Delivery_Type__c = mobileType, Product_Type__c = 'Base Product Type1', 
        Start_Cycle__c = ap1.Id, End_Cycle__c = ap2.Id);
        progList.add(p2);
        
        Program__c p3 = new Program__c(Name = o.Name + ' Base', Opportunity__c = o.Id, RecordTypeId = progrtID, Delivery_Type__c = digitalType, Product_Type__c = 'Base Product Type1', 
        Start_Cycle__c = ap1.Id, End_Cycle__c = ap2.Id);
        progList.add(p3);
        
        Program__c p4 = new Program__c(Name = o2.Name + ' Base', Opportunity__c = o2.Id, RecordTypeId = progrtID2, Delivery_Type__c = displayType, Product_Type__c = 'Base Product Type1', 
        Start_Cycle__c = ap1.Id, End_Cycle__c = ap2.Id);
        progList.add(p4);
        
        insert progList;
        
        List<Program_Forecast__c> pfList = new List<Program_Forecast__c>();
        
        Program_Forecast__c pf1 = new Program_Forecast__c(Program__c = p.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000);
        pfList.add(pf1);
        
        Program_Forecast__c pf4 = new Program_Forecast__c(Program__c = p.Id, Ad_Period__c = ap3.Id, Forecast_Amount__c = 1000, Active__c = false);
        pfList.add(pf4);
        
        Program_Forecast__c pf6 = new Program_Forecast__c(Program__c = p.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000, Active__c = false, Previous_Quarter_Actual__c = null, 
        Next_Quarter_Actual__c = 700);
        pfList.add(pf6);
        
        Program_Forecast__c pf3 = new Program_Forecast__c(Program__c = p.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000, Active__c = false);
        pfList.add(pf3);
        
        Program_Forecast__c pf2 = new Program_Forecast__c(Program__c = p.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000, Active__c = true);
        pfList.add(pf2);
        
        Program_Forecast__c pf5 = new Program_Forecast__c(Program__c = p.Id, Ad_Period__c = ap3.Id, Forecast_Amount__c = 1000, Active__c = true);
        pfList.add(pf5);
        
        Program_Forecast__c pf1b = new Program_Forecast__c(Program__c = p2.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000);
        pfList.add(pf1b);
        
        Program_Forecast__c pf4b = new Program_Forecast__c(Program__c = p2.Id, Ad_Period__c = ap3.Id, Forecast_Amount__c = 1000, Active__c = false);
        pfList.add(pf4b);
        
        Program_Forecast__c pf6b = new Program_Forecast__c(Program__c = p2.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000, Active__c = false, 
        Previous_Quarter_Actual__c = null, Next_Quarter_Actual__c = 700);
        pfList.add(pf6b);
        
        Program_Forecast__c pf3b = new Program_Forecast__c(Program__c = p2.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000, Active__c = false);
        pfList.add(pf3b);
        
        Program_Forecast__c pf2b = new Program_Forecast__c(Program__c = p2.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000, Active__c = true);
        pfList.add(pf2b);
        
        Program_Forecast__c pf5b = new Program_Forecast__c(Program__c = p2.Id, Ad_Period__c = ap3.Id, Forecast_Amount__c = 1000, Active__c = true);
        pfList.add(pf5b);
        
        Program_Forecast__c pf1d = new Program_Forecast__c(Program__c = p3.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000);
        pfList.add(pf1d);
        
        Program_Forecast__c pf4d = new Program_Forecast__c(Program__c = p3.Id, Ad_Period__c = ap3.Id, Forecast_Amount__c = 1000, Active__c = false);
        pfList.add(pf4d);
        
        Program_Forecast__c pf6d = new Program_Forecast__c(Program__c = p3.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000, Active__c = false, 
        Previous_Quarter_Actual__c = null, Next_Quarter_Actual__c = 700);
        pfList.add(pf6d);
        
        Program_Forecast__c pf3d = new Program_Forecast__c(Program__c = p3.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000, Active__c = false);
        pfList.add(pf3d);
        
        Program_Forecast__c pf2d = new Program_Forecast__c(Program__c = p3.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000, Active__c = true);
        pfList.add(pf2d);
        
        Program_Forecast__c pf5d = new Program_Forecast__c(Program__c = p3.Id, Ad_Period__c = ap3.Id, Forecast_Amount__c = 1000, Active__c = true);
        pfList.add(pf5d);
        
        Program_Forecast__c pf1a = new Program_Forecast__c(Program__c = p4.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000);
        pfList.add(pf1a);
        
        Program_Forecast__c pf4a = new Program_Forecast__c(Program__c = p4.Id, Ad_Period__c = ap3.Id, Forecast_Amount__c = 1000, Active__c = false);
        pfList.add(pf4a);
        
        Program_Forecast__c pf6a = new Program_Forecast__c(Program__c = p4.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000, Active__c = false, 
        Previous_Quarter_Actual__c = null, Next_Quarter_Actual__c = 700);
        pfList.add(pf6a);
        
        Program_Forecast__c pf3a = new Program_Forecast__c(Program__c = p4.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000, Active__c = false);
        pfList.add(pf3a);
        
        Program_Forecast__c pf2a = new Program_Forecast__c(Program__c = p4.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000, Active__c = true);
        pfList.add(pf2a);
        
        Program_Forecast__c pf5a = new Program_Forecast__c(Program__c = p4.Id, Ad_Period__c = ap3.Id, Forecast_Amount__c = 1000, Active__c = true);
        pfList.add(pf5a);
        
        Program_Forecast__c pf7 = new Program_Forecast__c(Program__c = p.Id, Ad_Period__c = ap2.Id, Forecast_Amount__c = 1000, Active__c = true);
        pfList.add(pf7);
        
        Program_Forecast__c pf7b = new Program_Forecast__c(Program__c = p2.Id, Ad_Period__c = ap2.Id, Forecast_Amount__c = 1000, Active__c = true);
        pfList.add(pf7b);
        
        Program_Forecast__c pf7d = new Program_Forecast__c(Program__c = p3.Id, Ad_Period__c = ap2.Id, Forecast_Amount__c = 1000, Active__c = true);
        pfList.add(pf7d);
        
        Program_Forecast__c pf7a = new Program_Forecast__c(Program__c = p4.Id, Ad_Period__c = ap2.Id, Forecast_Amount__c = 1000, Active__c = true);
        pfList.add(pf7a);
        
        Program_Forecast__c pf8 = new Program_Forecast__c(Program__c = p.Id, Ad_Period__c = ap3.Id, Forecast_Amount__c = 1000, Active__c = false, 
        Previous_Quarter_Actual__c = 200, Next_Quarter_Actual__c = 200);
        pfList.add(pf8);
        
        Program_Forecast__c pf8b = new Program_Forecast__c(Program__c = p2.Id, Ad_Period__c = ap3.Id, Forecast_Amount__c = 1000, Active__c = false, 
        Previous_Quarter_Actual__c = 200, Next_Quarter_Actual__c = 200);
        pfList.add(pf8b);
        
        Program_Forecast__c pf8c = new Program_Forecast__c(Program__c = p3.Id, Ad_Period__c = ap3.Id, Forecast_Amount__c = 1000, Active__c = false, 
        Previous_Quarter_Actual__c = 200, Next_Quarter_Actual__c = 200);
        pfList.add(pf8c);
        
        Program_Forecast__c pf8d = new Program_Forecast__c(Program__c = p4.Id, Ad_Period__c = ap3.Id, Forecast_Amount__c = 1000, Active__c = false, 
        Previous_Quarter_Actual__c = 200, Next_Quarter_Actual__c = 200);
        pfList.add(pf8d);
        
        insert pfList;
        
        Sales_Rep_Best_Guess__c srbg = new Sales_Rep_Best_Guess__c(OwnerId = testSR2.Id, Quarter__c = 'Q12012');
        insert srbg;
        
        Test.startTest();
        BatchCalculateBestGuess u = new BatchCalculateBestGuess('LIMIT 300');
        Database.executeBatch(u, 400);
        Test.stopTest();
    }
    
    static testMethod void testBatchCalculateBestGuessCOPY() {
        // TO DO: implement unit test
        Catalina_Forecast_Settings__c settings = getCatalinaForecastSettingsRecord();
        
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
        String rtID = [SELECT ID FROM RecordType Where Name = 'Contract' and SOBJECTTYPE = 'Opportunity'][0].Id;
        String rtID2 = [SELECT ID FROM RecordType Where Name = 'Proposal' and SOBJECTTYPE = 'Opportunity'][0].Id;
        String accountRTID = [SELECT ID FROM RecordType Where Name = 'Manufacturing' and SOBJECTTYPE = 'Account'][0].Id;
        String accountRTIDRetail = [SELECT ID FROM RecordType Where Name = 'Retail' and SOBJECTTYPE = 'Account'][0].Id;
        String progrtID = [SELECT ID FROM RecordType Where Name = 'Contract' and SOBJECTTYPE = 'Program__c'][0].Id;
        String progrtID2 = [SELECT ID FROM RecordType Where Name = 'Proposal' and SOBJECTTYPE = 'Program__c'][0].Id;
        
        User testEVP = new User(FirstName = 'test', LastName = 'EVP', Forecast_Role__c = 'EVP', Email = 'testEVP@catalinamarketing.com.testuser', 
        Username = 'testEVP@catalinamarketing.com.testuser', Alias = 'testEVP', CommunityNickname = 'testEVP', TimeZoneSidKey = 'GMT', LocaleSidKey = 'en_US', 
        EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', ProfileId = profileID);
        insert testEVP;
        
        User testSM1 = new User(FirstName = 'test',ManagerId = testEVP.Id,LanguageLocaleKey = 'en_US',ProfileId = profileID,LastName = 'SM1', 
        Forecast_Role__c = 'SM1',Email = 'testSM1@catalinamarketing.com.testuser',Username = 'testSM1@catalinamarketing.com.testuser',Alias = 'testSM1',
        CommunityNickname = 'testSM1',TimeZoneSidKey = 'GMT',LocaleSidKey = 'en_US',EmailEncodingKey = 'UTF-8');
        insert testSM1;
        
        User testSM2 = new User( FirstName = 'test', LastName = 'SM2', Forecast_Role__c = 'SM2', Email = 'testSM1@catalinamarketing.com.testuser', 
        Username = 'testSM2@catalinamarketing.com.testuser', Alias = 'testSM2', CommunityNickname = 'testSM2', TimeZoneSidKey = 'GMT', LocaleSidKey = 'en_US', 
        EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', ProfileId = profileID, ManagerId = testSM1.Id);
        insert testSM2;
        
        User testSR1 = new User(FirstName = 'test',LastName = 'SR1',Forecast_Role__c = 'SR1',Email = 'testSM1@catalinamarketing.com.testuser',
        Username = 'testSR1@catalinamarketing.com.testuser',Alias = 'testSR1',CommunityNickname = 'testSR1',TimeZoneSidKey = 'GMT',
        LocaleSidKey = 'en_US',EmailEncodingKey = 'UTF-8',LanguageLocaleKey = 'en_US',ProfileId = profileID,ManagerId = testSM2.Id);
        insert testSR1;
        
        User testSR2 = new User( FirstName = 'test', LastName = 'SR2', Forecast_Role__c = 'SR2', Email = 'testSM1@catalinamarketing.com.testuser', 
        Username = 'testSR2@catalinamarketing.com.testuser', Alias = 'testSR2', CommunityNickname = 'testSR2', TimeZoneSidKey = 'GMT', LocaleSidKey = 'en_US', 
        EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', ProfileId = profileID, ManagerId = testSR1.Id);
        insert testSR2;
        
        Account a = new Account(Name = 'Test Account', RecordTypeId = accountRTID);
        insert a;
        
        Opportunity o = new Opportunity( OwnerId = testSR2.Id, AccountId = a.Id, RecordTypeId = rtID, Name = 'Test oppty', StageName = 'Presented', CloseDate = Date.today());
        insert o;
        
        Opportunity o2 = new Opportunity( OwnerId = testSR2.Id, AccountId = a.Id, RecordTypeId = rtID, Name = 'Test oppty', StageName = 'Presented', CloseDate = Date.today());
        insert o2;
        
        Ad_Period__c ap1 = new Ad_Period__c(Name = 'C2_CY2012_test', Start_Date__c = Date.valueOf('2012-01-23'), End_Date__c = Date.valueOf('2012-02-19'), Type__c = 'Manufacturing');
        insert ap1;
        
        Ad_Period__c ap2 = new Ad_Period__c(Name = 'C3_CY2012_test', Start_Date__c = Date.valueOf('2012-01-23'), End_Date__c = Date.valueOf('2012-02-19'), Type__c = 'Manufacturing');
        insert ap2;
        
        Ad_Period__c ap3 = new Ad_Period__c( Name = 'C4_CY2012_test', Start_Date__c = Date.valueOf('2012-03-23'), End_Date__c = Date.valueOf('2012-04-19'), Type__c = 'Manufacturing');
        insert ap3;
        
        List<Program__c> progList = new List<Program__c>();
        
        Program__c p = new Program__c(Name = o.Name + ' Base', Opportunity__c = o.Id, RecordTypeId = progrtID, Delivery_Type__c = baseType, Product_Type__c = 'Base Product Type1', 
        Start_Cycle__c = ap1.Id, End_Cycle__c = ap2.Id);
        progList.add(p);
        
        Program__c p2 = new Program__c(Name = o2.Name + ' Base', Opportunity__c = o2.Id, RecordTypeId = progrtID2, Delivery_Type__c = mobileType, Product_Type__c = 'Base Product Type1', 
        Start_Cycle__c = ap1.Id, End_Cycle__c = ap2.Id);
        progList.add(p2);
        
        Program__c p3 = new Program__c(Name = o.Name + ' Base', Opportunity__c = o.Id, RecordTypeId = progrtID, Delivery_Type__c = digitalType, Product_Type__c = 'Base Product Type1', 
        Start_Cycle__c = ap1.Id, End_Cycle__c = ap2.Id);
        progList.add(p3);
        
        Program__c p4 = new Program__c(Name = o2.Name + ' Base', Opportunity__c = o2.Id, RecordTypeId = progrtID2, Delivery_Type__c = displayType, Product_Type__c = 'Base Product Type1', 
        Start_Cycle__c = ap1.Id, End_Cycle__c = ap2.Id);
        progList.add(p4);
        
        insert progList;
        
        List<Program_Forecast__c> pfList = new List<Program_Forecast__c>();
        
        Program_Forecast__c pf1 = new Program_Forecast__c(Program__c = p.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000);
        pfList.add(pf1);
        
        Program_Forecast__c pf4 = new Program_Forecast__c(Program__c = p.Id, Ad_Period__c = ap3.Id, Forecast_Amount__c = 1000, Active__c = false);
        pfList.add(pf4);
        
        Program_Forecast__c pf6 = new Program_Forecast__c(Program__c = p.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000, Active__c = false, Previous_Quarter_Actual__c = null, 
        Next_Quarter_Actual__c = 700);
        pfList.add(pf6);
        
        Program_Forecast__c pf3 = new Program_Forecast__c(Program__c = p.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000, Active__c = false);
        pfList.add(pf3);
        
        Program_Forecast__c pf2 = new Program_Forecast__c(Program__c = p.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000, Active__c = true);
        pfList.add(pf2);
        
        Program_Forecast__c pf5 = new Program_Forecast__c(Program__c = p.Id, Ad_Period__c = ap3.Id, Forecast_Amount__c = 1000, Active__c = true);
        pfList.add(pf5);
        
        Program_Forecast__c pf1b = new Program_Forecast__c(Program__c = p2.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000);
        pfList.add(pf1b);
        
        Program_Forecast__c pf4b = new Program_Forecast__c(Program__c = p2.Id, Ad_Period__c = ap3.Id, Forecast_Amount__c = 1000, Active__c = false);
        pfList.add(pf4b);
        
        Program_Forecast__c pf6b = new Program_Forecast__c(Program__c = p2.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000, Active__c = false, 
        Previous_Quarter_Actual__c = null, Next_Quarter_Actual__c = 700);
        pfList.add(pf6b);
        
        Program_Forecast__c pf3b = new Program_Forecast__c(Program__c = p2.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000, Active__c = false);
        pfList.add(pf3b);
        
        Program_Forecast__c pf2b = new Program_Forecast__c(Program__c = p2.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000, Active__c = true);
        pfList.add(pf2b);
        
        Program_Forecast__c pf5b = new Program_Forecast__c(Program__c = p2.Id, Ad_Period__c = ap3.Id, Forecast_Amount__c = 1000, Active__c = true);
        pfList.add(pf5b);
        
        Program_Forecast__c pf1d = new Program_Forecast__c(Program__c = p3.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000);
        pfList.add(pf1d);
        
        Program_Forecast__c pf4d = new Program_Forecast__c(Program__c = p3.Id, Ad_Period__c = ap3.Id, Forecast_Amount__c = 1000, Active__c = false);
        pfList.add(pf4d);
        
        Program_Forecast__c pf6d = new Program_Forecast__c(Program__c = p3.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000, Active__c = false, 
        Previous_Quarter_Actual__c = null, Next_Quarter_Actual__c = 700);
        pfList.add(pf6d);
        
        Program_Forecast__c pf3d = new Program_Forecast__c(Program__c = p3.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000, Active__c = false);
        pfList.add(pf3d);
        
        Program_Forecast__c pf2d = new Program_Forecast__c(Program__c = p3.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000, Active__c = true);
        pfList.add(pf2d);
        
        Program_Forecast__c pf5d = new Program_Forecast__c(Program__c = p3.Id, Ad_Period__c = ap3.Id, Forecast_Amount__c = 1000, Active__c = true);
        pfList.add(pf5d);
        
        Program_Forecast__c pf1a = new Program_Forecast__c(Program__c = p4.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000);
        pfList.add(pf1a);
        
        Program_Forecast__c pf4a = new Program_Forecast__c(Program__c = p4.Id, Ad_Period__c = ap3.Id, Forecast_Amount__c = 1000, Active__c = false);
        pfList.add(pf4a);
        
        Program_Forecast__c pf6a = new Program_Forecast__c(Program__c = p4.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000, Active__c = false, 
        Previous_Quarter_Actual__c = null, Next_Quarter_Actual__c = 700);
        pfList.add(pf6a);
        
        Program_Forecast__c pf3a = new Program_Forecast__c(Program__c = p4.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000, Active__c = false);
        pfList.add(pf3a);
        
        Program_Forecast__c pf2a = new Program_Forecast__c(Program__c = p4.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000, Active__c = true);
        pfList.add(pf2a);
        
        Program_Forecast__c pf5a = new Program_Forecast__c(Program__c = p4.Id, Ad_Period__c = ap3.Id, Forecast_Amount__c = 1000, Active__c = true);
        pfList.add(pf5a);
        
        Program_Forecast__c pf7 = new Program_Forecast__c(Program__c = p.Id, Ad_Period__c = ap2.Id, Forecast_Amount__c = 1000, Active__c = true);
        pfList.add(pf7);
        
        Program_Forecast__c pf7b = new Program_Forecast__c(Program__c = p2.Id, Ad_Period__c = ap2.Id, Forecast_Amount__c = 1000, Active__c = true);
        pfList.add(pf7b);
        
        Program_Forecast__c pf7d = new Program_Forecast__c(Program__c = p3.Id, Ad_Period__c = ap2.Id, Forecast_Amount__c = 1000, Active__c = true);
        pfList.add(pf7d);
        
        Program_Forecast__c pf7a = new Program_Forecast__c(Program__c = p4.Id, Ad_Period__c = ap2.Id, Forecast_Amount__c = 1000, Active__c = true);
        pfList.add(pf7a);
        
        Program_Forecast__c pf8 = new Program_Forecast__c(Program__c = p.Id, Ad_Period__c = ap3.Id, Forecast_Amount__c = 1000, Active__c = false, 
        Previous_Quarter_Actual__c = 200, Next_Quarter_Actual__c = 200);
        pfList.add(pf8);
        
        Program_Forecast__c pf8b = new Program_Forecast__c(Program__c = p2.Id, Ad_Period__c = ap3.Id, Forecast_Amount__c = 1000, Active__c = false, 
        Previous_Quarter_Actual__c = 200, Next_Quarter_Actual__c = 200);
        pfList.add(pf8b);
        
        Program_Forecast__c pf8c = new Program_Forecast__c(Program__c = p3.Id, Ad_Period__c = ap3.Id, Forecast_Amount__c = 1000, Active__c = false, 
        Previous_Quarter_Actual__c = 200, Next_Quarter_Actual__c = 200);
        pfList.add(pf8c);
        
        Program_Forecast__c pf8d = new Program_Forecast__c(Program__c = p4.Id, Ad_Period__c = ap3.Id, Forecast_Amount__c = 1000, Active__c = false, 
        Previous_Quarter_Actual__c = 200, Next_Quarter_Actual__c = 200);
        pfList.add(pf8d);
        
        insert pfList;
        
        Sales_Rep_Best_Guess__c srbg = new Sales_Rep_Best_Guess__c(OwnerId = testSR2.Id, Quarter__c = 'Q12012');
        insert srbg;
        
        Test.startTest();
        BatchCalculateBestGuessCOPY u = new BatchCalculateBestGuessCOPY('LIMIT 300');
        Database.executeBatch(u, 400);
        Test.stopTest();
    }

    static testMethod void testBatchAssociateFY() {
        // TO DO: implement unit test
        Catalina_Forecast_Settings__c settings = getCatalinaForecastSettingsRecord();
        
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
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
        
        User testSM1 = new User();
        testSM1.FirstName = 'test';
        testSM1.LastName = 'SM1';
        testSM1.Forecast_Role__c = 'SM1';
        testSM1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Username = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Alias = 'testSM1';
        testSM1.CommunityNickname = 'testSM1';
        testSM1.TimeZoneSidKey = 'GMT';
        testSM1.LocaleSidKey = 'en_US';
        testSM1.EmailEncodingKey = 'UTF-8';
        testSM1.LanguageLocaleKey = 'en_US';
        testSM1.ProfileId = profileID;
        testSM1.ManagerId = testEVP.Id;
        insert testSM1;
        
        User testSM2 = new User();
        testSM2.FirstName = 'test';
        testSM2.LastName = 'SM2';
        testSM2.Forecast_Role__c = 'SM2';
        testSM1.Forecast_Role__c = 'SM2';
        testSM2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM2.Username = 'testSM2@catalinamarketing.com.testuser';
        testSM2.Alias = 'testSM2';
        testSM2.CommunityNickname = 'testSM2';
        testSM2.TimeZoneSidKey = 'GMT';
        testSM2.LocaleSidKey = 'en_US';
        testSM2.EmailEncodingKey = 'UTF-8';
        testSM2.LanguageLocaleKey = 'en_US';
        testSM2.ProfileId = profileID;
        testSM2.ManagerId = testSM1.Id;
        insert testSM2;
        
        User testSR1 = new User();
        testSR1.FirstName = 'test';
        testSR1.LastName = 'SR1';
        testSR1.Forecast_Role__c = 'SR1';
        testSM1.Forecast_Role__c = 'SR1';
        testSR1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR1.Username = 'testSR1@catalinamarketing.com.testuser';
        testSR1.Alias = 'testSR1';
        testSR1.CommunityNickname = 'testSR1';
        testSR1.TimeZoneSidKey = 'GMT';
        testSR1.LocaleSidKey = 'en_US';
        testSR1.EmailEncodingKey = 'UTF-8';
        testSR1.LanguageLocaleKey = 'en_US';
        testSR1.ProfileId = profileID;
        testSR1.ManagerId = testSM2.Id;
        insert testSR1;
        
        User testSR2 = new User();
        testSR2.FirstName = 'test';
        testSR2.LastName = 'SR2';
        testSR2.Forecast_Role__c = 'SR2';
        testSR2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR2.Username = 'testSR2@catalinamarketing.com.testuser';
        testSR2.Alias = 'testSR2';
        testSR2.CommunityNickname = 'testSR2';
        testSR2.TimeZoneSidKey = 'GMT';
        testSR2.LocaleSidKey = 'en_US';
        testSR2.EmailEncodingKey = 'UTF-8';
        testSR2.LanguageLocaleKey = 'en_US';
        testSR2.ProfileId = profileID;
        testSR2.ManagerId = testSR1.Id;
        insert testSR2;
        
        Account a = new Account();
        a.Name = 'Test Account';
        a.RecordTypeId = accountRTID;
        insert a;
               
        Sales_Manager_1_Forecast__c sm1 = new Sales_Manager_1_Forecast__c();
        sm1.OwnerId = testSM1.Id;
        sm1.Quarter__c = 'Q2012';
        sm1.Manager__c = testEVP.Id;
        sm1.Account_Type__c = 'Manufacturing';
        sm1.Delivery_Type__c = 'Digital O&O';
        sm1.Account__c = a.Id;
        insert sm1;

        Sales_Manager_2_Forecast__c sm2a = new Sales_Manager_2_Forecast__c();
        sm2a.OwnerId = testSM2.Id;
        sm2a.Quarter__c = 'Q22012';
        sm2a.Manager__c = testEVP.Id;
        sm2a.Account_Type__c = 'Manufacturing';
        sm2a.Delivery_Type__c = 'Digital O&O';
        sm2a.Account__c = a.Id;
        sm2a.Manager_Forecast__c = sm1.Id;
        insert sm2a;

        Sales_Manager_1_Forecast__c sm2 = new Sales_Manager_1_Forecast__c();
        sm2.OwnerId = testSM1.Id;
        sm2.Quarter__c = 'Q22012';
        sm2.Manager__c = testEVP.Id;
        sm2.Account_Type__c = 'Retail';
        sm2.Delivery_Type__c = 'Digital O&O';
        sm2.Account__c = a.Id;
        insert sm2;

        Sales_Manager_1_Forecast__c sm3 = new Sales_Manager_1_Forecast__c();
        sm3.OwnerId = testSM1.Id;
        sm3.Quarter__c = 'Q22012';
        sm3.Manager__c = testEVP.Id;
        sm3.Account_Type__c = 'Retail';
        sm3.Delivery_Type__c = 'Mobile';
        sm3.Account__c = a.Id;
        insert sm3;
                
        Sales_Manager_1_FY_Total__c sm1fy = new Sales_Manager_1_FY_Total__c();
        sm1fy.OwnerId = testSM1.Id;
        sm1fy.Quarter__c = 'Q22012';
        sm1fy.Account__c = a.Id;
        insert sm1fy;
        
        Sales_Manager_2_FY_Total__c sm2fy = new Sales_Manager_2_FY_Total__c();
        sm2fy.Owner__c = testSM2.Id;
        sm2fy.Quarter__c = 'Q22012';
        sm2fy.Account__c = a.Id;
        sm2fy.Manager_FY_Total__c = sm1fy.Id;
        insert sm2fy;
        
        Test.startTest();
        BatchAssociateFY u = new BatchAssociateFY('LIMIT 400');
        Database.executeBatch(u, 400);
        Test.stopTest();
    }
    
    static testMethod void testBatchAssociateRepFY() {
        // TO DO: implement unit test
        Catalina_Forecast_Settings__c settings = getCatalinaForecastSettingsRecord();
        
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
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
        
        User testSM1 = new User();
        testSM1.FirstName = 'test';
        testSM1.LastName = 'SM1';
        testSM1.Forecast_Role__c = 'SM1';
        testSM1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Username = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Alias = 'testSM1';
        testSM1.CommunityNickname = 'testSM1';
        testSM1.TimeZoneSidKey = 'GMT';
        testSM1.LocaleSidKey = 'en_US';
        testSM1.EmailEncodingKey = 'UTF-8';
        testSM1.LanguageLocaleKey = 'en_US';
        testSM1.ProfileId = profileID;
        testSM1.ManagerId = testEVP.Id;
        insert testSM1;
        
        User testSM2 = new User();
        testSM2.FirstName = 'test';
        testSM2.LastName = 'SM2';
        testSM2.Forecast_Role__c = 'SM2';
        testSM1.Forecast_Role__c = 'SM2';
        testSM2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM2.Username = 'testSM2@catalinamarketing.com.testuser';
        testSM2.Alias = 'testSM2';
        testSM2.CommunityNickname = 'testSM2';
        testSM2.TimeZoneSidKey = 'GMT';
        testSM2.LocaleSidKey = 'en_US';
        testSM2.EmailEncodingKey = 'UTF-8';
        testSM2.LanguageLocaleKey = 'en_US';
        testSM2.ProfileId = profileID;
        testSM2.ManagerId = testSM1.Id;
        insert testSM2;
        
        User testSR1 = new User();
        testSR1.FirstName = 'test';
        testSR1.LastName = 'SR1';
        testSR1.Forecast_Role__c = 'SR1';
        testSM1.Forecast_Role__c = 'SR1';
        testSR1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR1.Username = 'testSR1@catalinamarketing.com.testuser';
        testSR1.Alias = 'testSR1';
        testSR1.CommunityNickname = 'testSR1';
        testSR1.TimeZoneSidKey = 'GMT';
        testSR1.LocaleSidKey = 'en_US';
        testSR1.EmailEncodingKey = 'UTF-8';
        testSR1.LanguageLocaleKey = 'en_US';
        testSR1.ProfileId = profileID;
        testSR1.ManagerId = testSM2.Id;
        insert testSR1;
        
        User testSR2 = new User();
        testSR2.FirstName = 'test';
        testSR2.LastName = 'SR2';
        testSR2.Forecast_Role__c = 'SR2';
        testSR2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR2.Username = 'testSR2@catalinamarketing.com.testuser';
        testSR2.Alias = 'testSR2';
        testSR2.CommunityNickname = 'testSR2';
        testSR2.TimeZoneSidKey = 'GMT';
        testSR2.LocaleSidKey = 'en_US';
        testSR2.EmailEncodingKey = 'UTF-8';
        testSR2.LanguageLocaleKey = 'en_US';
        testSR2.ProfileId = profileID;
        testSR2.ManagerId = testSR1.Id;
        insert testSR2;
        
        Account a = new Account();
        a.Name = 'Test Account';
        a.RecordTypeId = accountRTID;
        insert a;
               
        Sales_Manager_1_Forecast__c sm1 = new Sales_Manager_1_Forecast__c();
        sm1.OwnerId = testSM1.Id;
        sm1.Quarter__c = 'Q2012';
        sm1.Manager__c = testEVP.Id;
        sm1.Account_Type__c = 'Manufacturing';
        sm1.Delivery_Type__c = 'Digital O&O';
        sm1.Account__c = a.Id;
        insert sm1;

        Sales_Manager_2_Forecast__c sm2a = new Sales_Manager_2_Forecast__c();
        sm2a.OwnerId = testSM2.Id;
        sm2a.Quarter__c = 'Q22012';
        sm2a.Manager__c = testEVP.Id;
        sm2a.Account_Type__c = 'Manufacturing';
        sm2a.Delivery_Type__c = 'Digital O&O';
        sm2a.Account__c = a.Id;
        sm2a.Manager_Forecast__c = sm1.Id;
        insert sm2a;

        Sales_Manager_1_Forecast__c sm2 = new Sales_Manager_1_Forecast__c();
        sm2.OwnerId = testSM1.Id;
        sm2.Quarter__c = 'Q22012';
        sm2.Manager__c = testEVP.Id;
        sm2.Account_Type__c = 'Retail';
        sm2.Delivery_Type__c = 'Digital O&O';
        sm2.Account__c = a.Id;
        insert sm2;

        Sales_Manager_1_Forecast__c sm3 = new Sales_Manager_1_Forecast__c();
        sm3.OwnerId = testSM1.Id;
        sm3.Quarter__c = 'Q22012';
        sm3.Manager__c = testEVP.Id;
        sm3.Account_Type__c = 'Retail';
        sm3.Delivery_Type__c = 'Mobile';
        sm3.Account__c = a.Id;
        insert sm3;
                
        Sales_Manager_1_FY_Total__c sm1fy = new Sales_Manager_1_FY_Total__c();
        sm1fy.OwnerId = testSM1.Id;
        sm1fy.Quarter__c = 'Q22012';
        sm1fy.Account__c = a.Id;
        insert sm1fy;
        
        Sales_Manager_2_FY_Total__c sm2fy = new Sales_Manager_2_FY_Total__c();
        sm2fy.Owner__c = testSM2.Id;
        sm2fy.Quarter__c = 'Q22012';
        sm2fy.Account__c = a.Id;
        sm2fy.Manager_FY_Total__c = sm1fy.Id;
        insert sm2fy;
        
        Rep_1_FY_Total__c rep1fy = new Rep_1_FY_Total__c();
        rep1fy.Owner__c = testSR1.Id;
        rep1fy.Quarter__c = 'Q22012';
        rep1fy.Account__c = a.Id;
        rep1fy.Manager_FY_Total__c = sm2fy.Id;
        insert rep1fy;
        
        Rep_2_FY_Total__c rep2fy = new Rep_2_FY_Total__c();
        rep2fy.Owner__c = testSR2.Id;
        rep2fy.Quarter__c = 'Q22012';
        rep2fy.Account__c = a.Id;
        rep2fy.Manager_FY_Total__c = rep1fy.Id;
        insert rep2fy;
        
        Test.startTest();
        BatchAssociateRepFY u = new BatchAssociateRepFY('LIMIT 400');
        Database.executeBatch(u, 400);
        Test.stopTest();
    }
    
    static testMethod void testBatchAssociateFBFF() {
        // TO DO: implement unit test
        
        Catalina_Forecast_Settings__c settings = getCatalinaForecastSettingsRecord();
        
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
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
        
        Finance_Budget__c fb = new Finance_Budget__c();
        fb.EVP__c = testEVP.Id;
        fb.Quarter__c = 'Q22012';
        fb.Manufacturing_Base_Budget__c = 1;
        fb.Manufacturing_Digital_O_O_Budget__c = 1;
        fb.Manufacturing_Mobile_Budget__c = 1;
        fb.Manufacturing_Display_Budget__c = 1;
        fb.Retail_Base_Budget__c = 1;
        fb.Retail_Digital_O_O_Budget__c = 1;
        fb.Retail_Mobile_Budget__c = 1;
        fb.Retail_Display_Budget__c = 1;
        insert fb;
        
        Finance_Forecast__c ff = new Finance_Forecast__c();
        ff.EVP__c = testEVP.Id;
        ff.Quarter__c = 'Q22012';
        ff.Manufacturing_Base_Forecast__c = 1;
        ff.Manufacturing_Digital_O_O_Forecast__c = 1;
        ff.Manufacturing_Mobile_Forecast__c = 1;
        ff.Manufacturing_Display_Forecast__c = 1;
        ff.Retail_Base_Forecast__c = 1;
        ff.Retail_Digital_O_O_Forecast__c = 1;
        ff.Retail_Mobile_Forecast__c = 1;
        ff.Retail_Display_Forecast__c = 1;
        insert ff;

        Account a = new Account();
        a.Name = 'Test Account';
        a.RecordTypeId = accountRTID;
        insert a;
        
        Sales_Manager_1_Forecast__c sm1 = new Sales_Manager_1_Forecast__c();
        sm1.OwnerId = testEVP.Id;
        sm1.Quarter__c = 'Q22012';
        sm1.Manager__c = testEVP.Id;
        sm1.Account_Type__c = 'Retail';
        sm1.Delivery_Type__c = 'Audience Network';
        sm1.Account__c = a.Id;
        insert sm1;
        
        Sales_Manager_1_Forecast__c sm1b = new Sales_Manager_1_Forecast__c();
        sm1b.OwnerId = testEVP.Id;
        sm1b.Quarter__c = 'Q22012';
        sm1b.Manager__c = testEVP.Id;
        sm1b.Account_Type__c = 'Manufacturing';
        sm1b.Delivery_Type__c = 'Base';
        sm1b.Account__c = a.Id;
        insert sm1b;         
    
                
        Test.startTest();
        BatchAssociateFBFF u = new BatchAssociateFBFF();
        Database.executeBatch(u, 400);
        Test.stopTest();
    }
    
    static testMethod void testBatchAssociateFYTotal1() {
        // TO DO: implement unit test
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
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
        
        User testSM1 = new User();
        testSM1.FirstName = 'test';
        testSM1.LastName = 'SM1';
        testSM1.Forecast_Role__c = 'SM1';
        testSM1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Username = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Alias = 'testSM1';
        testSM1.CommunityNickname = 'testSM1';
        testSM1.TimeZoneSidKey = 'GMT';
        testSM1.LocaleSidKey = 'en_US';
        testSM1.EmailEncodingKey = 'UTF-8';
        testSM1.LanguageLocaleKey = 'en_US';
        testSM1.ProfileId = profileID;
        testSM1.ManagerId = testEVP.Id;
        insert testSM1;
        
        User testSM2 = new User();
        testSM2.FirstName = 'test';
        testSM2.LastName = 'SM2';
        testSM2.Forecast_Role__c = 'SM2';
        testSM1.Forecast_Role__c = 'SM2';
        testSM2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM2.Username = 'testSM2@catalinamarketing.com.testuser';
        testSM2.Alias = 'testSM2';
        testSM2.CommunityNickname = 'testSM2';
        testSM2.TimeZoneSidKey = 'GMT';
        testSM2.LocaleSidKey = 'en_US';
        testSM2.EmailEncodingKey = 'UTF-8';
        testSM2.LanguageLocaleKey = 'en_US';
        testSM2.ProfileId = profileID;
        testSM2.ManagerId = testSM1.Id;
        insert testSM2;
        
        User testSR1 = new User();
        testSR1.FirstName = 'test';
        testSR1.LastName = 'SR1';
        testSR1.Forecast_Role__c = 'SR1';
        testSM1.Forecast_Role__c = 'SR1';
        testSR1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR1.Username = 'testSR1@catalinamarketing.com.testuser';
        testSR1.Alias = 'testSR1';
        testSR1.CommunityNickname = 'testSR1';
        testSR1.TimeZoneSidKey = 'GMT';
        testSR1.LocaleSidKey = 'en_US';
        testSR1.EmailEncodingKey = 'UTF-8';
        testSR1.LanguageLocaleKey = 'en_US';
        testSR1.ProfileId = profileID;
        testSR1.ManagerId = testSM2.Id;
        insert testSR1;
        
        User testSR2 = new User();
        testSR2.FirstName = 'test';
        testSR2.LastName = 'SR2';
        testSR2.Forecast_Role__c = 'SR2';
        testSR2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR2.Username = 'testSR2@catalinamarketing.com.testuser';
        testSR2.Alias = 'testSR2';
        testSR2.CommunityNickname = 'testSR2';
        testSR2.TimeZoneSidKey = 'GMT';
        testSR2.LocaleSidKey = 'en_US';
        testSR2.EmailEncodingKey = 'UTF-8';
        testSR2.LanguageLocaleKey = 'en_US';
        testSR2.ProfileId = profileID;
        testSR2.ManagerId = testSR1.Id;
        insert testSR2;
        
        Account a = new Account();
        a.Name = 'Test Account';
        a.RecordTypeId = accountRTID;
        insert a;
        
        Sales_Manager_1_FY_Total__c sm1 = new Sales_Manager_1_FY_Total__c();
        sm1.OwnerId = testSM1.Id;
        sm1.Account__c = a.Id;
        sm1.Quarter__c = 'Q12013';
        insert sm1;
        
        Sales_Manager_2_FY_Total__c sm2 = new Sales_Manager_2_FY_Total__c();
        sm2.Owner__c = testSM2.Id;
        sm2.Account__c = a.Id;
        sm2.Quarter__c = 'Q12013';
        sm2.Manager_FY_Total__c = sm1.Id;
        insert sm2;
        
        Rep_1_FY_Total__c rep1 = new Rep_1_FY_Total__c();
        rep1.Owner__c = testSR1.Id;
        rep1.Account__c = a.Id;
        rep1.Quarter__c = 'Q12013';
        rep1.Manager_FY_Total__c = sm2.Id;
        insert rep1;
        
        Rep_2_FY_Total__c rep2 = new Rep_2_FY_Total__c();
        rep2.Owner__c = testSR2.Id;
        rep2.Account__c = a.Id;
        rep2.Quarter__c = 'Q12013';
        rep2.Manager_FY_Total__c = rep1.Id;
        insert rep2;
        
        Sales_Rep_Best_Guess__c newSRBG = new Sales_Rep_Best_Guess__c();
        newSRBG.OwnerId = testSM2.Id;
        newSRBG.Quarter__c = 'Q12013';
        insert newSRBG;
        
        Test.startTest();
        BatchBestGuessFYTotal1 u = new BatchBestGuessFYTotal1('LIMIT 400');
        Database.executeBatch(u, 400);
        Test.stopTest();
    }
    
    static testMethod void testBatchAssociateFYTotal1COPY() {
        // TO DO: implement unit test
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
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
        
        User testSM1 = new User();
        testSM1.FirstName = 'test';
        testSM1.LastName = 'SM1';
        testSM1.Forecast_Role__c = 'SM1';
        testSM1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Username = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Alias = 'testSM1';
        testSM1.CommunityNickname = 'testSM1';
        testSM1.TimeZoneSidKey = 'GMT';
        testSM1.LocaleSidKey = 'en_US';
        testSM1.EmailEncodingKey = 'UTF-8';
        testSM1.LanguageLocaleKey = 'en_US';
        testSM1.ProfileId = profileID;
        testSM1.ManagerId = testEVP.Id;
        insert testSM1;
        
        User testSM2 = new User();
        testSM2.FirstName = 'test';
        testSM2.LastName = 'SM2';
        testSM2.Forecast_Role__c = 'SM2';
        testSM1.Forecast_Role__c = 'SM2';
        testSM2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM2.Username = 'testSM2@catalinamarketing.com.testuser';
        testSM2.Alias = 'testSM2';
        testSM2.CommunityNickname = 'testSM2';
        testSM2.TimeZoneSidKey = 'GMT';
        testSM2.LocaleSidKey = 'en_US';
        testSM2.EmailEncodingKey = 'UTF-8';
        testSM2.LanguageLocaleKey = 'en_US';
        testSM2.ProfileId = profileID;
        testSM2.ManagerId = testSM1.Id;
        insert testSM2;
        
        User testSR1 = new User();
        testSR1.FirstName = 'test';
        testSR1.LastName = 'SR1';
        testSR1.Forecast_Role__c = 'SR1';
        testSM1.Forecast_Role__c = 'SR1';
        testSR1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR1.Username = 'testSR1@catalinamarketing.com.testuser';
        testSR1.Alias = 'testSR1';
        testSR1.CommunityNickname = 'testSR1';
        testSR1.TimeZoneSidKey = 'GMT';
        testSR1.LocaleSidKey = 'en_US';
        testSR1.EmailEncodingKey = 'UTF-8';
        testSR1.LanguageLocaleKey = 'en_US';
        testSR1.ProfileId = profileID;
        testSR1.ManagerId = testSM2.Id;
        insert testSR1;
        
        User testSR2 = new User();
        testSR2.FirstName = 'test';
        testSR2.LastName = 'SR2';
        testSR2.Forecast_Role__c = 'SR2';
        testSR2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR2.Username = 'testSR2@catalinamarketing.com.testuser';
        testSR2.Alias = 'testSR2';
        testSR2.CommunityNickname = 'testSR2';
        testSR2.TimeZoneSidKey = 'GMT';
        testSR2.LocaleSidKey = 'en_US';
        testSR2.EmailEncodingKey = 'UTF-8';
        testSR2.LanguageLocaleKey = 'en_US';
        testSR2.ProfileId = profileID;
        testSR2.ManagerId = testSR1.Id;
        insert testSR2;
        
        Account a = new Account();
        a.Name = 'Test Account';
        a.RecordTypeId = accountRTID;
        insert a;
        
        Sales_Manager_1_FY_Total__c sm1 = new Sales_Manager_1_FY_Total__c();
        sm1.OwnerId = testSM1.Id;
        sm1.Account__c = a.Id;
        sm1.Quarter__c = 'Q12013';
        insert sm1;
        
        Sales_Manager_2_FY_Total__c sm2 = new Sales_Manager_2_FY_Total__c();
        sm2.Owner__c = testSM2.Id;
        sm2.Account__c = a.Id;
        sm2.Quarter__c = 'Q12013';
        sm2.Manager_FY_Total__c = sm1.Id;
        insert sm2;
        
        Rep_1_FY_Total__c rep1 = new Rep_1_FY_Total__c();
        rep1.Owner__c = testSR1.Id;
        rep1.Account__c = a.Id;
        rep1.Quarter__c = 'Q12013';
        rep1.Manager_FY_Total__c = sm2.Id;
        insert rep1;
        
        Rep_2_FY_Total__c rep2 = new Rep_2_FY_Total__c();
        rep2.Owner__c = testSR2.Id;
        rep2.Account__c = a.Id;
        rep2.Quarter__c = 'Q12013';
        rep2.Manager_FY_Total__c = rep1.Id;
        insert rep2;
        
        Sales_Rep_Best_Guess__c newSRBG = new Sales_Rep_Best_Guess__c();
        newSRBG.OwnerId = testSM2.Id;
        newSRBG.Quarter__c = 'Q12013';
        insert newSRBG;
        
        Test.startTest();
        BatchBestGuessFYTotal1COPY u = new BatchBestGuessFYTotal1COPY('LIMIT 400');
        Database.executeBatch(u, 400);
        Test.stopTest();
    }

    static testMethod void testBatchAssociateFYTotal2() {
        // TO DO: implement unit test
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
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
        
        User testSM1 = new User();
        testSM1.FirstName = 'test';
        testSM1.LastName = 'SM1';
        testSM1.Forecast_Role__c = 'SM1';
        testSM1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Username = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Alias = 'testSM1';
        testSM1.CommunityNickname = 'testSM1';
        testSM1.TimeZoneSidKey = 'GMT';
        testSM1.LocaleSidKey = 'en_US';
        testSM1.EmailEncodingKey = 'UTF-8';
        testSM1.LanguageLocaleKey = 'en_US';
        testSM1.ProfileId = profileID;
        testSM1.ManagerId = testEVP.Id;
        insert testSM1;
        
        User testSM2 = new User();
        testSM2.FirstName = 'test';
        testSM2.LastName = 'SM2';
        testSM2.Forecast_Role__c = 'SM2';
        testSM1.Forecast_Role__c = 'SM2';
        testSM2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM2.Username = 'testSM2@catalinamarketing.com.testuser';
        testSM2.Alias = 'testSM2';
        testSM2.CommunityNickname = 'testSM2';
        testSM2.TimeZoneSidKey = 'GMT';
        testSM2.LocaleSidKey = 'en_US';
        testSM2.EmailEncodingKey = 'UTF-8';
        testSM2.LanguageLocaleKey = 'en_US';
        testSM2.ProfileId = profileID;
        testSM2.ManagerId = testSM1.Id;
        insert testSM2;
        
        User testSR1 = new User();
        testSR1.FirstName = 'test';
        testSR1.LastName = 'SR1';
        testSR1.Forecast_Role__c = 'SR1';
        testSM1.Forecast_Role__c = 'SR1';
        testSR1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR1.Username = 'testSR1@catalinamarketing.com.testuser';
        testSR1.Alias = 'testSR1';
        testSR1.CommunityNickname = 'testSR1';
        testSR1.TimeZoneSidKey = 'GMT';
        testSR1.LocaleSidKey = 'en_US';
        testSR1.EmailEncodingKey = 'UTF-8';
        testSR1.LanguageLocaleKey = 'en_US';
        testSR1.ProfileId = profileID;
        testSR1.ManagerId = testSM2.Id;
        insert testSR1;
        
        User testSR2 = new User();
        testSR2.FirstName = 'test';
        testSR2.LastName = 'SR2';
        testSR2.Forecast_Role__c = 'SR2';
        testSR2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR2.Username = 'testSR2@catalinamarketing.com.testuser';
        testSR2.Alias = 'testSR2';
        testSR2.CommunityNickname = 'testSR2';
        testSR2.TimeZoneSidKey = 'GMT';
        testSR2.LocaleSidKey = 'en_US';
        testSR2.EmailEncodingKey = 'UTF-8';
        testSR2.LanguageLocaleKey = 'en_US';
        testSR2.ProfileId = profileID;
        testSR2.ManagerId = testSR1.Id;
        insert testSR2;
        
        Account a = new Account();
        a.Name = 'Test Account';
        a.RecordTypeId = accountRTID;
        insert a;
        
        Sales_Manager_1_FY_Total__c sm1 = new Sales_Manager_1_FY_Total__c();
        sm1.OwnerId = testSM1.Id;
        sm1.Account__c = a.Id;
        sm1.Quarter__c = 'Q12013';
        insert sm1;
        
        Sales_Manager_2_FY_Total__c sm2 = new Sales_Manager_2_FY_Total__c();
        sm2.Owner__c = testSM2.Id;
        sm2.Account__c = a.Id;
        sm2.Quarter__c = 'Q12013';
        sm2.Manager_FY_Total__c = sm1.Id;
        insert sm2;
        
        Rep_1_FY_Total__c rep1 = new Rep_1_FY_Total__c();
        rep1.Owner__c = testSR1.Id;
        rep1.Account__c = a.Id;
        rep1.Quarter__c = 'Q12013';
        rep1.Manager_FY_Total__c = sm2.Id;
        insert rep1;
        
        Rep_2_FY_Total__c rep2 = new Rep_2_FY_Total__c();
        rep2.Owner__c = testSR2.Id;
        rep2.Account__c = a.Id;
        rep2.Quarter__c = 'Q12013';
        rep2.Manager_FY_Total__c = rep1.Id;
        insert rep2;
        
        Sales_Rep_Best_Guess__c newSRBG = new Sales_Rep_Best_Guess__c();
        newSRBG.OwnerId = testSR2.Id;
        newSRBG.Quarter__c = 'Q12013';
        insert newSRBG;
        
        Test.startTest();
        BatchBestGuessFYTotal2 u = new BatchBestGuessFYTotal2('LIMIT 400');
        Database.executeBatch(u, 400);
        Test.stopTest();
    }

    static testMethod void testBatchAssociateFYTotal2COPY() {
        // TO DO: implement unit test
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
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
        
        User testSM1 = new User();
        testSM1.FirstName = 'test';
        testSM1.LastName = 'SM1';
        testSM1.Forecast_Role__c = 'SM1';
        testSM1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Username = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Alias = 'testSM1';
        testSM1.CommunityNickname = 'testSM1';
        testSM1.TimeZoneSidKey = 'GMT';
        testSM1.LocaleSidKey = 'en_US';
        testSM1.EmailEncodingKey = 'UTF-8';
        testSM1.LanguageLocaleKey = 'en_US';
        testSM1.ProfileId = profileID;
        testSM1.ManagerId = testEVP.Id;
        insert testSM1;
        
        User testSM2 = new User();
        testSM2.FirstName = 'test';
        testSM2.LastName = 'SM2';
        testSM2.Forecast_Role__c = 'SM2';
        testSM1.Forecast_Role__c = 'SM2';
        testSM2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM2.Username = 'testSM2@catalinamarketing.com.testuser';
        testSM2.Alias = 'testSM2';
        testSM2.CommunityNickname = 'testSM2';
        testSM2.TimeZoneSidKey = 'GMT';
        testSM2.LocaleSidKey = 'en_US';
        testSM2.EmailEncodingKey = 'UTF-8';
        testSM2.LanguageLocaleKey = 'en_US';
        testSM2.ProfileId = profileID;
        testSM2.ManagerId = testSM1.Id;
        insert testSM2;
        
        User testSR1 = new User();
        testSR1.FirstName = 'test';
        testSR1.LastName = 'SR1';
        testSR1.Forecast_Role__c = 'SR1';
        testSM1.Forecast_Role__c = 'SR1';
        testSR1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR1.Username = 'testSR1@catalinamarketing.com.testuser';
        testSR1.Alias = 'testSR1';
        testSR1.CommunityNickname = 'testSR1';
        testSR1.TimeZoneSidKey = 'GMT';
        testSR1.LocaleSidKey = 'en_US';
        testSR1.EmailEncodingKey = 'UTF-8';
        testSR1.LanguageLocaleKey = 'en_US';
        testSR1.ProfileId = profileID;
        testSR1.ManagerId = testSM2.Id;
        insert testSR1;
        
        User testSR2 = new User();
        testSR2.FirstName = 'test';
        testSR2.LastName = 'SR2';
        testSR2.Forecast_Role__c = 'SR2';
        testSR2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR2.Username = 'testSR2@catalinamarketing.com.testuser';
        testSR2.Alias = 'testSR2';
        testSR2.CommunityNickname = 'testSR2';
        testSR2.TimeZoneSidKey = 'GMT';
        testSR2.LocaleSidKey = 'en_US';
        testSR2.EmailEncodingKey = 'UTF-8';
        testSR2.LanguageLocaleKey = 'en_US';
        testSR2.ProfileId = profileID;
        testSR2.ManagerId = testSR1.Id;
        insert testSR2;
        
        Account a = new Account();
        a.Name = 'Test Account';
        a.RecordTypeId = accountRTID;
        insert a;
        
        Sales_Manager_1_FY_Total__c sm1 = new Sales_Manager_1_FY_Total__c();
        sm1.OwnerId = testSM1.Id;
        sm1.Account__c = a.Id;
        sm1.Quarter__c = 'Q12013';
        insert sm1;
        
        Sales_Manager_2_FY_Total__c sm2 = new Sales_Manager_2_FY_Total__c();
        sm2.Owner__c = testSM2.Id;
        sm2.Account__c = a.Id;
        sm2.Quarter__c = 'Q12013';
        sm2.Manager_FY_Total__c = sm1.Id;
        insert sm2;
        
        Rep_1_FY_Total__c rep1 = new Rep_1_FY_Total__c();
        rep1.Owner__c = testSR1.Id;
        rep1.Account__c = a.Id;
        rep1.Quarter__c = 'Q12013';
        rep1.Manager_FY_Total__c = sm2.Id;
        insert rep1;
        
        Rep_2_FY_Total__c rep2 = new Rep_2_FY_Total__c();
        rep2.Owner__c = testSR2.Id;
        rep2.Account__c = a.Id;
        rep2.Quarter__c = 'Q12013';
        rep2.Manager_FY_Total__c = rep1.Id;
        insert rep2;
        
        Sales_Rep_Best_Guess__c newSRBG = new Sales_Rep_Best_Guess__c();
        newSRBG.OwnerId = testSR2.Id;
        newSRBG.Quarter__c = 'Q12013';
        insert newSRBG;
        
        Test.startTest();
        BatchBestGuessFYTotal2COPY u = new BatchBestGuessFYTotal2COPY('LIMIT 400');
        Database.executeBatch(u, 400);
        Test.stopTest();
    }    
    static testMethod void testBatchArchiveForecast() {
        // TO DO: implement unit test
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
        String rtID = [SELECT ID FROM RecordType Where Name = 'Contract' and SOBJECTTYPE = 'Opportunity'][0].Id;
        String accountRTID = [SELECT ID FROM RecordType Where Name = 'Manufacturing' and SOBJECTTYPE = 'Account'][0].Id;

        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
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
        
        User testSM1 = new User();
        testSM1.FirstName = 'test';
        testSM1.LastName = 'SM1';
        testSM1.Forecast_Role__c = 'SM1';
        testSM1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Username = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Alias = 'testSM1';
        testSM1.CommunityNickname = 'testSM1';
        testSM1.TimeZoneSidKey = 'GMT';
        testSM1.LocaleSidKey = 'en_US';
        testSM1.EmailEncodingKey = 'UTF-8';
        testSM1.LanguageLocaleKey = 'en_US';
        testSM1.ProfileId = profileID;
        testSM1.ManagerId = testEVP.Id;
        insert testSM1;
        
        User testSM2 = new User();
        testSM2.FirstName = 'test';
        testSM2.LastName = 'SM2';
        testSM2.Forecast_Role__c = 'SM2';
        testSM1.Forecast_Role__c = 'SM2';
        testSM2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM2.Username = 'testSM2@catalinamarketing.com.testuser';
        testSM2.Alias = 'testSM2';
        testSM2.CommunityNickname = 'testSM2';
        testSM2.TimeZoneSidKey = 'GMT';
        testSM2.LocaleSidKey = 'en_US';
        testSM2.EmailEncodingKey = 'UTF-8';
        testSM2.LanguageLocaleKey = 'en_US';
        testSM2.ProfileId = profileID;
        testSM2.ManagerId = testSM1.Id;
        insert testSM2;
        
        User testSR1 = new User();
        testSR1.FirstName = 'test';
        testSR1.LastName = 'SR1';
        testSR1.Forecast_Role__c = 'SR1';
        testSM1.Forecast_Role__c = 'SR1';
        testSR1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR1.Username = 'testSR1@catalinamarketing.com.testuser';
        testSR1.Alias = 'testSR1';
        testSR1.CommunityNickname = 'testSR1';
        testSR1.TimeZoneSidKey = 'GMT';
        testSR1.LocaleSidKey = 'en_US';
        testSR1.EmailEncodingKey = 'UTF-8';
        testSR1.LanguageLocaleKey = 'en_US';
        testSR1.ProfileId = profileID;
        testSR1.ManagerId = testSM2.Id;
        insert testSR1;
        
        User testSR2 = new User();
        testSR2.FirstName = 'test';
        testSR2.LastName = 'SR2';
        testSR2.Forecast_Role__c = 'SR2';
        testSR2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR2.Username = 'testSR2@catalinamarketing.com.testuser';
        testSR2.Alias = 'testSR2';
        testSR2.CommunityNickname = 'testSR2';
        testSR2.TimeZoneSidKey = 'GMT';
        testSR2.LocaleSidKey = 'en_US';
        testSR2.EmailEncodingKey = 'UTF-8';
        testSR2.LanguageLocaleKey = 'en_US';
        testSR2.ProfileId = profileID;
        testSR2.ManagerId = testSR1.Id;
        insert testSR2;
        
        Account a = new Account();
        a.Name = 'Test Account';
        a.RecordTypeId = accountRTID;
        insert a;
        
        Opportunity o = new Opportunity();
        o.OwnerId = testSR2.Id;
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
        pf1.Ad_Period__c = ap1.Id;
        pf1.Forecast_Amount__c = 1000;
        pf1.Active__c = true;
        insert pf1;
        
        Archive_Program__c oldArchive = new Archive_Program__c();
        oldArchive.Archive_Date__c = Date.today().addDays(-20);
        oldArchive.Opportunity__c = o.Id;
        oldArchive.Ext_ID__c = 'testEXTID54321';
        insert oldArchive;
        
        Test.startTest();
        BatchArchiveForecast u = new BatchArchiveForecast('LIMIT 400');
        Database.executeBatch(u, 400);
        Test.stopTest();
    }
    
    static testMethod void testBatchArchiveForecast2() {
        // TO DO: implement unit test
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
        String rtID = [SELECT ID FROM RecordType Where Name = 'Contract' and SOBJECTTYPE = 'Opportunity'][0].Id;
        String accountRTID = [SELECT ID FROM RecordType Where Name = 'Manufacturing' and SOBJECTTYPE = 'Account'][0].Id;
        
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
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
        
        User testSM1 = new User();
        testSM1.FirstName = 'test';
        testSM1.LastName = 'SM1';
        testSM1.Forecast_Role__c = 'SM1';
        testSM1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Username = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Alias = 'testSM1';
        testSM1.CommunityNickname = 'testSM1';
        testSM1.TimeZoneSidKey = 'GMT';
        testSM1.LocaleSidKey = 'en_US';
        testSM1.EmailEncodingKey = 'UTF-8';
        testSM1.LanguageLocaleKey = 'en_US';
        testSM1.ProfileId = profileID;
        testSM1.ManagerId = testEVP.Id;
        insert testSM1;
        
        User testSM2 = new User();
        testSM2.FirstName = 'test';
        testSM2.LastName = 'SM2';
        testSM2.Forecast_Role__c = 'SM2';
        testSM1.Forecast_Role__c = 'SM2';
        testSM2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM2.Username = 'testSM2@catalinamarketing.com.testuser';
        testSM2.Alias = 'testSM2';
        testSM2.CommunityNickname = 'testSM2';
        testSM2.TimeZoneSidKey = 'GMT';
        testSM2.LocaleSidKey = 'en_US';
        testSM2.EmailEncodingKey = 'UTF-8';
        testSM2.LanguageLocaleKey = 'en_US';
        testSM2.ProfileId = profileID;
        testSM2.ManagerId = testSM1.Id;
        insert testSM2;
        
        User testSR1 = new User();
        testSR1.FirstName = 'test';
        testSR1.LastName = 'SR1';
        testSR1.Forecast_Role__c = 'SR1';
        testSM1.Forecast_Role__c = 'SR1';
        testSR1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR1.Username = 'testSR1@catalinamarketing.com.testuser';
        testSR1.Alias = 'testSR1';
        testSR1.CommunityNickname = 'testSR1';
        testSR1.TimeZoneSidKey = 'GMT';
        testSR1.LocaleSidKey = 'en_US';
        testSR1.EmailEncodingKey = 'UTF-8';
        testSR1.LanguageLocaleKey = 'en_US';
        testSR1.ProfileId = profileID;
        testSR1.ManagerId = testSM2.Id;
        insert testSR1;
        
        User testSR2 = new User();
        testSR2.FirstName = 'test';
        testSR2.LastName = 'SR2';
        testSR2.Forecast_Role__c = 'SR2';
        testSR2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR2.Username = 'testSR2@catalinamarketing.com.testuser';
        testSR2.Alias = 'testSR2';
        testSR2.CommunityNickname = 'testSR2';
        testSR2.TimeZoneSidKey = 'GMT';
        testSR2.LocaleSidKey = 'en_US';
        testSR2.EmailEncodingKey = 'UTF-8';
        testSR2.LanguageLocaleKey = 'en_US';
        testSR2.ProfileId = profileID;
        testSR2.ManagerId = testSR1.Id;
        insert testSR2;
        
        Account a = new Account();
        a.Name = 'Test Account';
        a.RecordTypeId = accountRTID;
        insert a;
        
        Opportunity o = new Opportunity();
        o.OwnerId = testSR2.Id;
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
        pf1.Ad_Period__c = ap1.Id;
        pf1.Forecast_Amount__c = 1000;
        pf1.Active__c = true;
        insert pf1;
        
        Archive_Program__c oldArchive = new Archive_Program__c();
        oldArchive.Archive_Date__c = Date.today().addDays(-5);
        oldArchive.Opportunity__c = o.Id;
        oldArchive.Ext_ID__c = 'testEXTID54321';
        insert oldArchive;
        
        List<Archive_Program__c> listAP = [SELECT ID FROM ARCHIVE_PROGRAM__C];
        system.assert(listAP.size() == 1);
    }
    /*
    static testMethod void testBatchCreateAccountForecast1() {
        // TO DO: implement unit test
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
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
        
        User testSM1 = new User();
        testSM1.FirstName = 'test';
        testSM1.LastName = 'SM1';
        testSM1.Forecast_Role__c = 'SM1';
        testSM1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Username = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Alias = 'testSM1';
        testSM1.CommunityNickname = 'testSM1';
        testSM1.TimeZoneSidKey = 'GMT';
        testSM1.LocaleSidKey = 'en_US';
        testSM1.EmailEncodingKey = 'UTF-8';
        testSM1.LanguageLocaleKey = 'en_US';
        testSM1.ProfileId = profileID;
        testSM1.ManagerId = testEVP.Id;
        insert testSM1;
        
        User testSM2 = new User();
        testSM2.FirstName = 'test';
        testSM2.LastName = 'SM2';
        testSM2.Forecast_Role__c = 'SM2';
        testSM1.Forecast_Role__c = 'SM2';
        testSM2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM2.Username = 'testSM2@catalinamarketing.com.testuser';
        testSM2.Alias = 'testSM2';
        testSM2.CommunityNickname = 'testSM2';
        testSM2.TimeZoneSidKey = 'GMT';
        testSM2.LocaleSidKey = 'en_US';
        testSM2.EmailEncodingKey = 'UTF-8';
        testSM2.LanguageLocaleKey = 'en_US';
        testSM2.ProfileId = profileID;
        testSM2.ManagerId = testSM1.Id;
        insert testSM2;
        
        User testSR1 = new User();
        testSR1.FirstName = 'test';
        testSR1.LastName = 'SR1';
        testSR1.Forecast_Role__c = 'SR1';
        testSM1.Forecast_Role__c = 'SR1';
        testSR1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR1.Username = 'testSR1@catalinamarketing.com.testuser';
        testSR1.Alias = 'testSR1';
        testSR1.CommunityNickname = 'testSR1';
        testSR1.TimeZoneSidKey = 'GMT';
        testSR1.LocaleSidKey = 'en_US';
        testSR1.EmailEncodingKey = 'UTF-8';
        testSR1.LanguageLocaleKey = 'en_US';
        testSR1.ProfileId = profileID;
        testSR1.ManagerId = testSM2.Id;
        insert testSR1;
        
        User testSR2 = new User();
        testSR2.FirstName = 'test';
        testSR2.LastName = 'SR2';
        testSR2.Forecast_Role__c = 'SR2';
        testSR2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR2.Username = 'testSR2@catalinamarketing.com.testuser';
        testSR2.Alias = 'testSR2';
        testSR2.CommunityNickname = 'testSR2';
        testSR2.TimeZoneSidKey = 'GMT';
        testSR2.LocaleSidKey = 'en_US';
        testSR2.EmailEncodingKey = 'UTF-8';
        testSR2.LanguageLocaleKey = 'en_US';
        testSR2.ProfileId = profileID;
        testSR2.ManagerId = testSR1.Id;
        insert testSR2;
        
        Account a = new Account();
        a.Name = 'Test Account';
        a.RecordTypeId = accountRTID;
        insert a;
        
        Opportunity o = new Opportunity();
        o.OwnerId = testSR2.Id;
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
        
        Ad_Period__c ap3 = new Ad_Period__c();
        ap3.Name = 'C1_CY2012_test';
        ap3.Start_Date__c = Date.valueOf('2012-12-23');
        ap3.End_Date__c = Date.valueOf('2012-01-19');
        ap3.Type__c = 'Manufacturing';
        insert ap3;
        
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
        pf1.Ad_Period__c = ap1.Id;
        pf1.Forecast_Amount__c = 1000;
        insert pf1;
        
        Program_Forecast__c pf2 = new Program_Forecast__c();
        pf2.Program__c = p.Id;
        pf2.Ad_Period__c = ap3.Id;
        pf2.Forecast_Amount__c = 1000;
        pf2.Active__c = false;
        insert pf2;
        
        Test.startTest();
        BatchCreateAccountForecast u = new BatchCreateAccountForecast();
       // Database.executeBatch(u, 400);
        Test.stopTest();
    }
    */
    
    
    static testMethod void testBatchFYTotal1() {
        // TO DO: implement unit test
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
        String rtID = [SELECT ID FROM RecordType Where Name = 'Contract' and SOBJECTTYPE = 'Opportunity'][0].Id;
        String accountRTID = [SELECT ID FROM RecordType Where Name = 'Manufacturing' and SOBJECTTYPE = 'Account'][0].Id;
        
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
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
        
        User testSM1 = new User();
        testSM1.FirstName = 'test';
        testSM1.LastName = 'SM1';
        testSM1.Forecast_Role__c = 'SM1';
        testSM1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Username = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Alias = 'testSM1';
        testSM1.CommunityNickname = 'testSM1';
        testSM1.TimeZoneSidKey = 'GMT';
        testSM1.LocaleSidKey = 'en_US';
        testSM1.EmailEncodingKey = 'UTF-8';
        testSM1.LanguageLocaleKey = 'en_US';
        testSM1.ProfileId = profileID;
        testSM1.ManagerId = testEVP.Id;
        insert testSM1;
        
        User testSM2 = new User();
        testSM2.FirstName = 'test';
        testSM2.LastName = 'SM2';
        testSM2.Forecast_Role__c = 'SM2';
        testSM1.Forecast_Role__c = 'SM2';
        testSM2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM2.Username = 'testSM2@catalinamarketing.com.testuser';
        testSM2.Alias = 'testSM2';
        testSM2.CommunityNickname = 'testSM2';
        testSM2.TimeZoneSidKey = 'GMT';
        testSM2.LocaleSidKey = 'en_US';
        testSM2.EmailEncodingKey = 'UTF-8';
        testSM2.LanguageLocaleKey = 'en_US';
        testSM2.ProfileId = profileID;
        testSM2.ManagerId = testSM1.Id;
        insert testSM2;
        
        User testSR1 = new User();
        testSR1.FirstName = 'test';
        testSR1.LastName = 'SR1';
        testSR1.Forecast_Role__c = 'SR1';
        testSM1.Forecast_Role__c = 'SR1';
        testSR1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR1.Username = 'testSR1@catalinamarketing.com.testuser';
        testSR1.Alias = 'testSR1';
        testSR1.CommunityNickname = 'testSR1';
        testSR1.TimeZoneSidKey = 'GMT';
        testSR1.LocaleSidKey = 'en_US';
        testSR1.EmailEncodingKey = 'UTF-8';
        testSR1.LanguageLocaleKey = 'en_US';
        testSR1.ProfileId = profileID;
        testSR1.ManagerId = testSM2.Id;
        insert testSR1;
        
        User testSR2 = new User();
        testSR2.FirstName = 'test';
        testSR2.LastName = 'SR2';
        testSR2.Forecast_Role__c = 'SR2';
        testSR2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR2.Username = 'testSR2@catalinamarketing.com.testuser';
        testSR2.Alias = 'testSR2';
        testSR2.CommunityNickname = 'testSR2';
        testSR2.TimeZoneSidKey = 'GMT';
        testSR2.LocaleSidKey = 'en_US';
        testSR2.EmailEncodingKey = 'UTF-8';
        testSR2.LanguageLocaleKey = 'en_US';
        testSR2.ProfileId = profileID;
        testSR2.ManagerId = testSR1.Id;
        insert testSR2;
        
        Account a = new Account();
        a.Name = 'Test Account';
        a.RecordTypeId = accountRTID;
        insert a;
        
        Opportunity o = new Opportunity();
        o.OwnerId = testSR2.Id;
        o.AccountId = a.Id;
        o.RecordTypeId = rtID;
        o.Name = 'Test oppty';
        o.StageName = 'Presented';
        o.CloseDate = Date.today();
        insert o;
        
        Ad_Period__c ap1 = new Ad_Period__c();
        ap1.Name = 'C2_CY2011_test';
        ap1.Start_Date__c = Date.valueOf('2011-03-23');
        ap1.End_Date__c = Date.valueOf('2011-04-19');
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
        pf1.Ad_Period__c = ap1.Id;
        pf1.Forecast_Amount__c = 1000;
        insert pf1;
        Test.startTest();
        BatchFYTotal u = new BatchFYTotal('2012', 'LIMIT 400');
        Database.executeBatch(u, 400);
        Test.stopTest();
    }

    static testMethod void testBatchFYTotal1COPY() {
        // TO DO: implement unit test
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
        String rtID = [SELECT ID FROM RecordType Where Name = 'Contract' and SOBJECTTYPE = 'Opportunity'][0].Id;
        String accountRTID = [SELECT ID FROM RecordType Where Name = 'Manufacturing' and SOBJECTTYPE = 'Account'][0].Id;
        
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
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
        
        User testSM1 = new User();
        testSM1.FirstName = 'test';
        testSM1.LastName = 'SM1';
        testSM1.Forecast_Role__c = 'SM1';
        testSM1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Username = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Alias = 'testSM1';
        testSM1.CommunityNickname = 'testSM1';
        testSM1.TimeZoneSidKey = 'GMT';
        testSM1.LocaleSidKey = 'en_US';
        testSM1.EmailEncodingKey = 'UTF-8';
        testSM1.LanguageLocaleKey = 'en_US';
        testSM1.ProfileId = profileID;
        testSM1.ManagerId = testEVP.Id;
        insert testSM1;
        
        User testSM2 = new User();
        testSM2.FirstName = 'test';
        testSM2.LastName = 'SM2';
        testSM2.Forecast_Role__c = 'SM2';
        testSM1.Forecast_Role__c = 'SM2';
        testSM2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM2.Username = 'testSM2@catalinamarketing.com.testuser';
        testSM2.Alias = 'testSM2';
        testSM2.CommunityNickname = 'testSM2';
        testSM2.TimeZoneSidKey = 'GMT';
        testSM2.LocaleSidKey = 'en_US';
        testSM2.EmailEncodingKey = 'UTF-8';
        testSM2.LanguageLocaleKey = 'en_US';
        testSM2.ProfileId = profileID;
        testSM2.ManagerId = testSM1.Id;
        insert testSM2;
        
        User testSR1 = new User();
        testSR1.FirstName = 'test';
        testSR1.LastName = 'SR1';
        testSR1.Forecast_Role__c = 'SR1';
        testSM1.Forecast_Role__c = 'SR1';
        testSR1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR1.Username = 'testSR1@catalinamarketing.com.testuser';
        testSR1.Alias = 'testSR1';
        testSR1.CommunityNickname = 'testSR1';
        testSR1.TimeZoneSidKey = 'GMT';
        testSR1.LocaleSidKey = 'en_US';
        testSR1.EmailEncodingKey = 'UTF-8';
        testSR1.LanguageLocaleKey = 'en_US';
        testSR1.ProfileId = profileID;
        testSR1.ManagerId = testSM2.Id;
        insert testSR1;
        
        User testSR2 = new User();
        testSR2.FirstName = 'test';
        testSR2.LastName = 'SR2';
        testSR2.Forecast_Role__c = 'SR2';
        testSR2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR2.Username = 'testSR2@catalinamarketing.com.testuser';
        testSR2.Alias = 'testSR2';
        testSR2.CommunityNickname = 'testSR2';
        testSR2.TimeZoneSidKey = 'GMT';
        testSR2.LocaleSidKey = 'en_US';
        testSR2.EmailEncodingKey = 'UTF-8';
        testSR2.LanguageLocaleKey = 'en_US';
        testSR2.ProfileId = profileID;
        testSR2.ManagerId = testSR1.Id;
        insert testSR2;
        
        Account a = new Account();
        a.Name = 'Test Account';
        a.RecordTypeId = accountRTID;
        insert a;
        
        Opportunity o = new Opportunity();
        o.OwnerId = testSR2.Id;
        o.AccountId = a.Id;
        o.RecordTypeId = rtID;
        o.Name = 'Test oppty';
        o.StageName = 'Presented';
        o.CloseDate = Date.today();
        insert o;
        
        Ad_Period__c ap1 = new Ad_Period__c();
        ap1.Name = 'C2_CY2011_test';
        ap1.Start_Date__c = Date.valueOf('2011-03-23');
        ap1.End_Date__c = Date.valueOf('2011-04-19');
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
        pf1.Ad_Period__c = ap1.Id;
        pf1.Forecast_Amount__c = 1000;
        insert pf1;
        Test.startTest();
        BatchFYTotalCOPY u = new BatchFYTotalCOPY('2012', 'LIMIT 400');
        Database.executeBatch(u, 400);
        Test.stopTest();
    }
    
    static testMethod void testPFNotFound() {
        // TO DO: implement unit test
        List<Sales_Manager_1_Forecast__c> list1 = [SELECT ID FROM Sales_Manager_1_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 2000];
        delete list1;
        List<Sales_Manager_2_Forecast__c> list2 = [SELECT ID FROM Sales_Manager_2_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 2000];
        delete list2;
        List<Rep_1_Forecast__c> list3 = [SELECT ID FROM Rep_1_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 2000];
        delete list3;
        List<Rep_2_Forecast__c> list4 = [SELECT ID FROM Rep_2_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 2000];
        delete list4;
        
        Catalina_Forecast_Settings__c settings = getCatalinaForecastSettingsRecord();
        
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
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
        
        User testSM1 = new User();
        testSM1.FirstName = 'test';
        testSM1.LastName = 'SM1';
        testSM1.Forecast_Role__c = 'SM1';
        testSM1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Username = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Alias = 'testSM1';
        testSM1.CommunityNickname = 'testSM1';
        testSM1.TimeZoneSidKey = 'GMT';
        testSM1.LocaleSidKey = 'en_US';
        testSM1.EmailEncodingKey = 'UTF-8';
        testSM1.LanguageLocaleKey = 'en_US';
        testSM1.ProfileId = profileID;
        testSM1.ManagerId = testEVP.Id;
        insert testSM1;
        
        User testcoop = new User();
        testcoop.FirstName = 'test';
        testcoop.LastName = 'coop';
        //testcoop.Forecast_Role__c = 'coop';
        testcoop.Email = 'testcoop@catalinamarketing.com.testuser';
        testcoop.Username = 'testcoop@catalinamarketing.com.testuser';
        testcoop.Alias = 'testcoop';
        testcoop.CommunityNickname = 'testcoop';
        testcoop.TimeZoneSidKey = 'GMT';
        testcoop.LocaleSidKey = 'en_US';
        testcoop.EmailEncodingKey = 'UTF-8';
        testcoop.LanguageLocaleKey = 'en_US';
        testcoop.ProfileId = profileID;
        //testcoop.ManagerId = testEVP.Id;
        insert testcoop;
        
        User testSM2 = new User();
        testSM2.FirstName = 'test';
        testSM2.LastName = 'SM2';
        testSM2.Forecast_Role__c = 'SM2';
        testSM2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM2.Username = 'testSM2@catalinamarketing.com.testuser';
        testSM2.Alias = 'testSM2';
        testSM2.CommunityNickname = 'testSM2';
        testSM2.TimeZoneSidKey = 'GMT';
        testSM2.LocaleSidKey = 'en_US';
        testSM2.EmailEncodingKey = 'UTF-8';
        testSM2.LanguageLocaleKey = 'en_US';
        testSM2.ProfileId = profileID;
        testSM2.ManagerId = testSM1.Id;
        insert testSM2;
        
        User testSR1 = new User();
        testSR1.FirstName = 'test';
        testSR1.LastName = 'SR1';
        testSR1.Forecast_Role__c = 'SR1';
        testSM1.Forecast_Role__c = 'SR1';
        testSR1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR1.Username = 'testSR1@catalinamarketing.com.testuser';
        testSR1.Alias = 'testSR1';
        testSR1.CommunityNickname = 'testSR1';
        testSR1.TimeZoneSidKey = 'GMT';
        testSR1.LocaleSidKey = 'en_US';
        testSR1.EmailEncodingKey = 'UTF-8';
        testSR1.LanguageLocaleKey = 'en_US';
        testSR1.ProfileId = profileID;
        //testSR1.ManagerId = testSM2.Id;
        testSR1.Forecast_Role_Override__c = true;
        insert testSR1;
        
        User testSR2 = new User();
        testSR2.FirstName = 'test';
        testSR2.LastName = 'SR2';
        testSR2.Forecast_Role__c = 'SR2';
        testSR2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR2.Username = 'testSR2@catalinamarketing.com.testuser';
        testSR2.Alias = 'testSR2';
        testSR2.CommunityNickname = 'testSR2';
        testSR2.TimeZoneSidKey = 'GMT';
        testSR2.LocaleSidKey = 'en_US';
        testSR2.EmailEncodingKey = 'UTF-8';
        testSR2.LanguageLocaleKey = 'en_US';
        testSR2.ProfileId = profileID;
        testSR2.ManagerId = testSR1.Id;
        insert testSR2;
        
        Account a = new Account();
        a.Name = 'Test Account';
        a.RecordTypeId = accountRTID;
        insert a;
        
        Opportunity o = new Opportunity();
        o.OwnerId = testSR1.Id;
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
        pf1.Ad_Period__c = ap1.Id;
        pf1.Forecast_Amount__c = 1000;
        pf1.Active__c = true;
        insert pf1;
        /*
        Opportunity o2 = new Opportunity();
        o2.OwnerId = testSR1.Id;
        o2.AccountId = a.Id;
        o2.RecordTypeId = rtID;
        o2.Name = 'Test oppty';
        o2.StageName = 'Presented';
        o2.CloseDate = Date.today();
        insert o2;
        
        Ad_Period__c ap3 = new Ad_Period__c();
        ap3.Name = 'C1_CY2012_test';
        ap3.Start_Date__c = Date.valueOf('2012-12-23');
        ap3.End_Date__c = Date.valueOf('2012-01-19');
        ap3.Type__c = 'Manufacturing';
        insert ap3;
        
        Program__c p2 = new Program__c();
        p2.Name = o.Name + ' Base';
        p2.Opportunity__c = o2.Id;
        p2.Delivery_Type__c = 'Base';
        p2.Product_Type__c = 'Base Product Type1';
        p2.Start_Cycle__c = ap3.Id;
        p2.End_Cycle__c = ap2.Id;
        insert p2;
        
        Program_Forecast__c pf2 = new Program_Forecast__c();
        pf2.Program__c = p.Id;
        pf2.Ad_Period__c = ap3.Id;
        pf2.Forecast_Amount__c = 1000;
        pf2.Actual_Amount__c = 1000;
        pf2.Previous_Quarter_Actual__c = 200;
        pf2.Next_Quarter_Actual__c = 800;
        pf2.Active__c = false;
        insert pf2;
        */
        Test.startTest();
        BatchCreateRepForecast u = new BatchCreateRepForecast('LIMIT 400');
        Database.executeBatch(u, 400);
        Test.stopTest();
    }
    
    static testMethod void testProgramPTS() {
        // TO DO: implement unit test
        List<Sales_Manager_1_Forecast__c> list1 = [SELECT ID FROM Sales_Manager_1_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 2000];
        delete list1;
        List<Sales_Manager_2_Forecast__c> list2 = [SELECT ID FROM Sales_Manager_2_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 2000];
        delete list2;
        List<Rep_1_Forecast__c> list3 = [SELECT ID FROM Rep_1_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 2000];
        delete list3;
        List<Rep_2_Forecast__c> list4 = [SELECT ID FROM Rep_2_Forecast__c ORDER BY CREATEDDATE ASC LIMIT 2000];
        delete list4;
        
        Catalina_Forecast_Settings__c settings = getCatalinaForecastSettingsRecord();
        
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
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
        
        User testSM1 = new User();
        testSM1.FirstName = 'test';
        testSM1.LastName = 'SM1';
        testSM1.Forecast_Role__c = 'SM1';
        testSM1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Username = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Alias = 'testSM1';
        testSM1.CommunityNickname = 'testSM1';
        testSM1.TimeZoneSidKey = 'GMT';
        testSM1.LocaleSidKey = 'en_US';
        testSM1.EmailEncodingKey = 'UTF-8';
        testSM1.LanguageLocaleKey = 'en_US';
        testSM1.ProfileId = profileID;
        testSM1.ManagerId = testEVP.Id;
        insert testSM1;
        
        User testcoop = new User();
        testcoop.FirstName = 'test';
        testcoop.LastName = 'coop';
        //testcoop.Forecast_Role__c = 'coop';
        testcoop.Email = 'testcoop@catalinamarketing.com.testuser';
        testcoop.Username = 'testcoop@catalinamarketing.com.testuser';
        testcoop.Alias = 'testcoop';
        testcoop.CommunityNickname = 'testcoop';
        testcoop.TimeZoneSidKey = 'GMT';
        testcoop.LocaleSidKey = 'en_US';
        testcoop.EmailEncodingKey = 'UTF-8';
        testcoop.LanguageLocaleKey = 'en_US';
        testcoop.ProfileId = profileID;
        //testcoop.ManagerId = testEVP.Id;
        insert testcoop;
        
        User testSM2 = new User();
        testSM2.FirstName = 'test';
        testSM2.LastName = 'SM2';
        testSM2.Forecast_Role__c = 'SM2';
        testSM2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM2.Username = 'testSM2@catalinamarketing.com.testuser';
        testSM2.Alias = 'testSM2';
        testSM2.CommunityNickname = 'testSM2';
        testSM2.TimeZoneSidKey = 'GMT';
        testSM2.LocaleSidKey = 'en_US';
        testSM2.EmailEncodingKey = 'UTF-8';
        testSM2.LanguageLocaleKey = 'en_US';
        testSM2.ProfileId = profileID;
        testSM2.ManagerId = testSM1.Id;
        insert testSM2;
        
        User testSR1 = new User();
        testSR1.FirstName = 'test';
        testSR1.LastName = 'SR1';
        testSR1.Forecast_Role__c = 'SR1';
        testSM1.Forecast_Role__c = 'SR1';
        testSR1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR1.Username = 'testSR1@catalinamarketing.com.testuser';
        testSR1.Alias = 'testSR1';
        testSR1.CommunityNickname = 'testSR1';
        testSR1.TimeZoneSidKey = 'GMT';
        testSR1.LocaleSidKey = 'en_US';
        testSR1.EmailEncodingKey = 'UTF-8';
        testSR1.LanguageLocaleKey = 'en_US';
        testSR1.ProfileId = profileID;
        testSR1.ManagerId = testSM2.Id;
        testSR1.Forecast_Role_Override__c = false;
        insert testSR1;
        
        User testSR2 = new User();
        testSR2.FirstName = 'test';
        testSR2.LastName = 'SR2';
        testSR2.Forecast_Role__c = 'SR2';
        testSR2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR2.Username = 'testSR2@catalinamarketing.com.testuser';
        testSR2.Alias = 'testSR2';
        testSR2.CommunityNickname = 'testSR2';
        testSR2.TimeZoneSidKey = 'GMT';
        testSR2.LocaleSidKey = 'en_US';
        testSR2.EmailEncodingKey = 'UTF-8';
        testSR2.LanguageLocaleKey = 'en_US';
        testSR2.ProfileId = profileID;
        testSR2.ManagerId = testSR1.Id;
        insert testSR2;
        
        Account a = new Account();
        a.Name = 'Test Account';
        a.RecordTypeId = accountRTID;
        insert a;
        
        Opportunity o = new Opportunity();
        o.OwnerId = testSR1.Id;
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
        
        Product_Type_Split__c pts = [SELECT ID, PERCENT__C FROM PRODUCT_TYPE_SPLIT__C WHERE PROGRAM__C =: p.id][0];
        pts.Percent__c = 60;
        update pts;
        
        Product_Type_Split__c pts1 = new Product_Type_Split__c();
        pts1.Program__c = p.Id;
        pts1.Product_Type__c = 'PTS 2';
        pts1.Percent__c = 15;
        insert pts1;
        
        Program_Forecast__c pf1 = new Program_Forecast__c();
        pf1.Program__c = p.Id;
        pf1.Ad_Period__c = ap1.Id;
        pf1.Forecast_Amount__c = 1000;
        pf1.Active__c = true;
        insert pf1;
        /*
        Opportunity o2 = new Opportunity();
        o2.OwnerId = testSR1.Id;
        o2.AccountId = a.Id;
        o2.RecordTypeId = rtID;
        o2.Name = 'Test oppty';
        o2.StageName = 'Presented';
        o2.CloseDate = Date.today();
        insert o2;
        
        Ad_Period__c ap3 = new Ad_Period__c();
        ap3.Name = 'C1_CY2012_test';
        ap3.Start_Date__c = Date.valueOf('2012-12-23');
        ap3.End_Date__c = Date.valueOf('2012-01-19');
        ap3.Type__c = 'Manufacturing';
        insert ap3;
        
        Program__c p2 = new Program__c();
        p2.Name = o.Name + ' Base';
        p2.Opportunity__c = o2.Id;
        p2.Delivery_Type__c = 'Base';
        p2.Product_Type__c = 'Base Product Type1';
        p2.Start_Cycle__c = ap3.Id;
        p2.End_Cycle__c = ap2.Id;
        insert p2;
        
        Program_Forecast__c pf2 = new Program_Forecast__c();
        pf2.Program__c = p.Id;
        pf2.Ad_Period__c = ap3.Id;
        pf2.Forecast_Amount__c = 1000;
        pf2.Actual_Amount__c = 1000;
        pf2.Previous_Quarter_Actual__c = 200;
        pf2.Next_Quarter_Actual__c = 800;
        pf2.Active__c = false;
        insert pf2;
        */
        Test.startTest();
        BatchCreateRepForecast u = new BatchCreateRepForecast('LIMIT 400');
        Database.executeBatch(u, 400);
        Test.stopTest();
    }
  
    static testMethod void testBatchNotifyPFE() {
        Catalina_Forecast_Settings__c settings = getCatalinaForecastSettingsRecord();
        
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        List<Program_Forecast_Exception__c> pfeList = new List<Program_Forecast_Exception__c>();
        
        Program_Forecast_Exception__c pfe1 = new Program_Forecast_Exception__c();
        pfe1.Reason__c = 'reason 1';
        pfeList.add(pfe1);
        
        Program_Forecast_Exception__c pfe2 = new Program_Forecast_Exception__c();
        pfe2.Reason__c = 'reason 2';
        pfeList.add(pfe2);
        
        Program_Forecast_Exception__c pfe3 = new Program_Forecast_Exception__c();
        pfe3.Reason__c = 'reason 1';
        pfeList.add(pfe3);
        
        Program_Forecast_Exception__c pfe4 = new Program_Forecast_Exception__c();
        pfe4.Reason__c = 'reason 4';
        pfeList.add(pfe4);
        
        insert pfeList;
        
        BatchNotifyPFE u = new BatchNotifyPFE();
        Test.startTest();
        Database.executeBatch(u);
        Test.stopTest();
    }
    /*
    static testMethod void testBatchOverwritePastBG(){
        
        Sales_Rep_Best_Guess__c srbg = new Sales_Rep_Best_Guess__c();
        srbg.Quarter_End_Date__c = Date.Today().addDays(-1);
        insert srbg;
        
        Manager_Best_Guess__c mbg = new Manager_Best_Guess__c();
        mbg.Quarter_End_Date__c = Date.Today().addDays(-1);
        insert mbg;
        
        BatchOverwritePastBG u = new BatchOverwritePastBG();
        Test.startTest();
        Database.executeBatch(u);
        Test.stopTest();
        
    }
    */
    static testMethod void testBatchRealignSalesRepBG(){
        
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
        String rtID = [SELECT ID FROM RecordType Where Name = 'Contract' and SOBJECTTYPE = 'Opportunity'][0].Id;
        String accountRTID = [SELECT ID FROM RecordType Where Name = 'Manufacturing' and SOBJECTTYPE = 'Account'][0].Id;
        
        User testSM2 = new User();
        testSM2.FirstName = 'test';
        testSM2.LastName = 'SM2';
        testSM2.Forecast_Role__c = 'SM2';
        testSM2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM2.Username = 'testSM2@catalinamarketing.com.testuser';
        testSM2.Alias = 'testSM2';
        testSM2.CommunityNickname = 'testSM2';
        testSM2.TimeZoneSidKey = 'GMT';
        testSM2.LocaleSidKey = 'en_US';
        testSM2.EmailEncodingKey = 'UTF-8';
        testSM2.LanguageLocaleKey = 'en_US';
        testSM2.ProfileId = profileID;
        insert testSM2;
        
        User testSR1 = new User();
        testSR1.FirstName = 'test';
        testSR1.LastName = 'SR1';
        testSR1.Forecast_Role__c = 'SR1';
        testSR1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR1.Username = 'testSR1@catalinamarketing.com.testuser';
        testSR1.Alias = 'testSR1';
        testSR1.CommunityNickname = 'testSR1';
        testSR1.TimeZoneSidKey = 'GMT';
        testSR1.LocaleSidKey = 'en_US';
        testSR1.EmailEncodingKey = 'UTF-8';
        testSR1.LanguageLocaleKey = 'en_US';
        testSR1.ProfileId = profileID;
        testSR1.ManagerId = testSM2.Id;
        insert testSR1;
        
        User testSR2 = new User();
        testSR2.FirstName = 'test';
        testSR2.LastName = 'SR2';
        testSR2.Forecast_Role__c = 'SR2';
        testSR2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR2.Username = 'testSR2@catalinamarketing.com.testuser';
        testSR2.Alias = 'testSR2';
        testSR2.CommunityNickname = 'testSR2';
        testSR2.TimeZoneSidKey = 'GMT';
        testSR2.LocaleSidKey = 'en_US';
        testSR2.EmailEncodingKey = 'UTF-8';
        testSR2.LanguageLocaleKey = 'en_US';
        testSR2.ProfileId = profileID;
        testSR2.ManagerId = testSR1.Id;
        insert testSR2;
        
        Sales_Rep_Best_Guess__c srbg = new Sales_Rep_Best_Guess__c();
        srbg.OwnerId = testSR1.Id;
        srbg.Manager__c = testSR2.Id;
        insert srbg;
        
        BatchRealignSalesRepBestGuess u = new BatchRealignSalesRepBestGuess();
        Test.startTest();
        Database.executeBatch(u);
        Test.stopTest();
        
    }   
    
    static testMethod void testBatchRealignManagerBG(){
        
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
        String rtID = [SELECT ID FROM RecordType Where Name = 'Contract' and SOBJECTTYPE = 'Opportunity'][0].Id;
        String accountRTID = [SELECT ID FROM RecordType Where Name = 'Manufacturing' and SOBJECTTYPE = 'Account'][0].Id;
        
        User testSM2 = new User();
        testSM2.FirstName = 'test';
        testSM2.LastName = 'SM2';
        testSM2.Forecast_Role__c = 'SM2';
        testSM2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM2.Username = 'testSM2@catalinamarketing.com.testuser';
        testSM2.Alias = 'testSM2';
        testSM2.CommunityNickname = 'testSM2';
        testSM2.TimeZoneSidKey = 'GMT';
        testSM2.LocaleSidKey = 'en_US';
        testSM2.EmailEncodingKey = 'UTF-8';
        testSM2.LanguageLocaleKey = 'en_US';
        testSM2.ProfileId = profileID;
        insert testSM2;
        
        User testSR1 = new User();
        testSR1.FirstName = 'test';
        testSR1.LastName = 'SR1';
        testSR1.Forecast_Role__c = 'SR1';
        testSR1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR1.Username = 'testSR1@catalinamarketing.com.testuser';
        testSR1.Alias = 'testSR1';
        testSR1.CommunityNickname = 'testSR1';
        testSR1.TimeZoneSidKey = 'GMT';
        testSR1.LocaleSidKey = 'en_US';
        testSR1.EmailEncodingKey = 'UTF-8';
        testSR1.LanguageLocaleKey = 'en_US';
        testSR1.ProfileId = profileID;
        testSR1.ManagerId = testSM2.Id;
        insert testSR1;
        
        User testSR2 = new User();
        testSR2.FirstName = 'test';
        testSR2.LastName = 'SR2';
        testSR2.Forecast_Role__c = 'SR2';
        testSR2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR2.Username = 'testSR2@catalinamarketing.com.testuser';
        testSR2.Alias = 'testSR2';
        testSR2.CommunityNickname = 'testSR2';
        testSR2.TimeZoneSidKey = 'GMT';
        testSR2.LocaleSidKey = 'en_US';
        testSR2.EmailEncodingKey = 'UTF-8';
        testSR2.LanguageLocaleKey = 'en_US';
        testSR2.ProfileId = profileID;
        testSR2.ManagerId = testSR1.Id;
        insert testSR2;
        
        Manager_Best_Guess__c mbg = new Manager_Best_Guess__c();
        mbg.OwnerId = testSR1.Id;
        mbg.Manager__c = testSR2.Id;
        insert mbg;
        
        BatchRealignManagerBestGuess u = new BatchRealignManagerBestGuess();
        Test.startTest();
        Database.executeBatch(u);
        String sch = '0 0 23 * * ?'; 
        system.schedule('BatchDeactivateProgramForecasts', sch, u);
        Test.stopTest();
        
    }   
    
  static testMethod void testCustomAccountLookUpController() {
      ApexPages.currentPage().getParameters().put('acc', 'te');
      CustomAccountLookUpController la = new CustomAccountLookUpController();
  }
  
  static testMethod void testRecalculateBestGuess() {
        
        Catalina_Forecast_Settings__c settings = getCatalinaForecastSettingsRecord();
        
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
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
        
        User testSM1 = new User();
        testSM1.FirstName = 'test';
        testSM1.LastName = 'SM1';
        testSM1.Forecast_Role__c = 'SM1';
        testSM1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Username = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Alias = 'testSM1';
        testSM1.CommunityNickname = 'testSM1';
        testSM1.TimeZoneSidKey = 'GMT';
        testSM1.LocaleSidKey = 'en_US';
        testSM1.EmailEncodingKey = 'UTF-8';
        testSM1.LanguageLocaleKey = 'en_US';
        testSM1.ProfileId = profileID;
        testSM1.ManagerId = testEVP.Id;
        insert testSM1;
        
        User testSM2 = new User();
        testSM2.FirstName = 'test';
        testSM2.LastName = 'SM2';
        testSM2.Forecast_Role__c = 'SM2';
        testSM1.Forecast_Role__c = 'SM2';
        testSM2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM2.Username = 'testSM2@catalinamarketing.com.testuser';
        testSM2.Alias = 'testSM2';
        testSM2.CommunityNickname = 'testSM2';
        testSM2.TimeZoneSidKey = 'GMT';
        testSM2.LocaleSidKey = 'en_US';
        testSM2.EmailEncodingKey = 'UTF-8';
        testSM2.LanguageLocaleKey = 'en_US';
        testSM2.ProfileId = profileID;
        testSM2.ManagerId = testSM1.Id;
        insert testSM2;
        
        User testSR1 = new User();
        testSR1.FirstName = 'test';
        testSR1.LastName = 'SR1';
        testSR1.Forecast_Role__c = 'SR1';
        testSM1.Forecast_Role__c = 'SR1';
        testSR1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR1.Username = 'testSR1@catalinamarketing.com.testuser';
        testSR1.Alias = 'testSR1';
        testSR1.CommunityNickname = 'testSR1';
        testSR1.TimeZoneSidKey = 'GMT';
        testSR1.LocaleSidKey = 'en_US';
        testSR1.EmailEncodingKey = 'UTF-8';
        testSR1.LanguageLocaleKey = 'en_US';
        testSR1.ProfileId = profileID;
        testSR1.ManagerId = testSM2.Id;
        insert testSR1;
        
        User testSR2 = new User();
        testSR2.FirstName = 'test';
        testSR2.LastName = 'SR2';
        testSR2.Forecast_Role__c = 'SR2';
        testSR2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR2.Username = 'testSR2@catalinamarketing.com.testuser';
        testSR2.Alias = 'testSR2';
        testSR2.CommunityNickname = 'testSR2';
        testSR2.TimeZoneSidKey = 'GMT';
        testSR2.LocaleSidKey = 'en_US';
        testSR2.EmailEncodingKey = 'UTF-8';
        testSR2.LanguageLocaleKey = 'en_US';
        testSR2.ProfileId = profileID;
        testSR2.ManagerId = testSR1.Id;
        insert testSR2;
        
        Manager_Best_Guess__c mbg = new Manager_Best_Guess__c();
        mbg.OwnerId = testEVP.Id;
        insert mbg;
        
        Manager_Best_Guess__c mbg1 = new Manager_Best_Guess__c();
        mbg1.OwnerId = testSM1.Id;
        mbg1.Manager_Best_Guess__c = mbg.Id;
        mbg1.Manager__c = testEVP.Id;
        mbg1.Use_Override__c = true;
        mbg1.Override_Team_Manu_Base_High__c = 1;
        insert mbg1;
        
        Manager_Best_Guess__c mbg1b = new Manager_Best_Guess__c();
        mbg1b.OwnerId = testSM1.Id;
        mbg1b.Manager_Best_Guess__c = mbg.Id;
        mbg1b.Manager__c = testEVP.Id;
        mbg1b.Use_Override__c = false;
        insert mbg1b;
        
        Manager_Best_Guess__c mbg2 = new Manager_Best_Guess__c();
        mbg2.Manager_Best_Guess__c = mbg1.Id;
        mbg2.OwnerId = testSM2.Id;
        mbg2.Manager__c = testSM1.Id;
        mbg2.Override_Team_Manu_Audience_Best_Guess__c = 100000;
        mbg2.Use_Override__c = true;
        mbg2.Override_Team_Manu_Base_High__c = 1;
        insert mbg2;
        
        Manager_Best_Guess__c mbg2b = new Manager_Best_Guess__c();
        mbg2b.Manager_Best_Guess__c = mbg1.Id;
        mbg2b.OwnerId = testSM2.Id;
        mbg2b.Manager__c = testSM1.Id;
        mbg2b.Use_Override__c = false;
        insert mbg2b;
        
        Manager_Best_Guess__c mbg3 = new Manager_Best_Guess__c();
        mbg3.Manager_Best_Guess__c = mbg2.Id;
        mbg3.OwnerId = testSR1.Id;
        mbg3.Manager__c = testSM2.Id;
        mbg3.Override_Team_Manu_Audience_Low__c = 100000;
        mbg3.Use_Override__c = true;
        mbg3.Override_Team_Manu_Base_High__c = 1;
        insert mbg3;
        
        Manager_Best_Guess__c mbg3b = new Manager_Best_Guess__c();
        mbg3b.Manager_Best_Guess__c = mbg2.Id;
        mbg3b.OwnerId = testSR1.Id;
        mbg3b.Manager__c = testSM2.Id;
        mbg3b.Use_Override__c = false;
        insert mbg3b;
        
        Manager_Best_Guess__c mbg4 = new Manager_Best_Guess__c();
        mbg4.Manager_Best_Guess__c = mbg3.Id;
        mbg4.OwnerId = testSR2.Id;
        mbg4.Manager__c = testSR1.Id;
        mbg4.Override_Team_Manu_Audience_Low__c = 100000;
        mbg4.Use_Override__c = true;
        mbg4.Override_Team_Manu_Base_High__c = 1;
        insert mbg4;
        
        Manager_Best_Guess__c mbg4b = new Manager_Best_Guess__c();
        mbg4b.Manager_Best_Guess__c = mbg3.Id;
        mbg4b.OwnerId = testSR2.Id;
        mbg4b.Manager__c = testSR1.Id;
        mbg4b.Use_Override__c = false;
        insert mbg4b;
        
        Sales_Rep_Best_Guess__c srbg1 = new Sales_Rep_Best_Guess__c();
        srbg1.Manager_Best_Guess__c = mbg4.Id;
        srbg1.OwnerId = testSR2.Id;
        srbg1.Manager__c = testSR2.Id;
        srbg1.Retail_Digital_Best_Guess__c = 29;
        insert srbg1;
        
        Test.startTest();
        BatchRecalculateBestGuess u = new BatchRecalculateBestGuess('');
        Database.executeBatch(u);
        Test.stopTest();
        
    }

     static testMethod void testBatchCreateProgramAmount() {
        
        Catalina_Forecast_Settings__c settings = getCatalinaForecastSettingsRecord();
        
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
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
        
        User testSM1 = new User();
        testSM1.FirstName = 'test';
        testSM1.LastName = 'SM1';
        testSM1.Forecast_Role__c = 'SM1';
        testSM1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Username = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Alias = 'testSM1';
        testSM1.CommunityNickname = 'testSM1';
        testSM1.TimeZoneSidKey = 'GMT';
        testSM1.LocaleSidKey = 'en_US';
        testSM1.EmailEncodingKey = 'UTF-8';
        testSM1.LanguageLocaleKey = 'en_US';
        testSM1.ProfileId = profileID;
        testSM1.ManagerId = testEVP.Id;
        insert testSM1;
        
        User testSM2 = new User();
        testSM2.FirstName = 'test';
        testSM2.LastName = 'SM2';
        testSM2.Forecast_Role__c = 'SM2';
        testSM1.Forecast_Role__c = 'SM2';
        testSM2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM2.Username = 'testSM2@catalinamarketing.com.testuser';
        testSM2.Alias = 'testSM2';
        testSM2.CommunityNickname = 'testSM2';
        testSM2.TimeZoneSidKey = 'GMT';
        testSM2.LocaleSidKey = 'en_US';
        testSM2.EmailEncodingKey = 'UTF-8';
        testSM2.LanguageLocaleKey = 'en_US';
        testSM2.ProfileId = profileID;
        testSM2.ManagerId = testSM1.Id;
        insert testSM2;
        
        User testSR1 = new User();
        testSR1.FirstName = 'test';
        testSR1.LastName = 'SR1';
        testSR1.Forecast_Role__c = 'SR1';
        testSM1.Forecast_Role__c = 'SR1';
        testSR1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR1.Username = 'testSR1@catalinamarketing.com.testuser';
        testSR1.Alias = 'testSR1';
        testSR1.CommunityNickname = 'testSR1';
        testSR1.TimeZoneSidKey = 'GMT';
        testSR1.LocaleSidKey = 'en_US';
        testSR1.EmailEncodingKey = 'UTF-8';
        testSR1.LanguageLocaleKey = 'en_US';
        testSR1.ProfileId = profileID;
        testSR1.ManagerId = testSM2.Id;
        insert testSR1;
        
        User testSR2 = new User();
        testSR2.FirstName = 'test';
        testSR2.LastName = 'SR2';
        testSR2.Forecast_Role__c = 'SR2';
        testSR2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR2.Username = 'testSR2@catalinamarketing.com.testuser';
        testSR2.Alias = 'testSR2';
        testSR2.CommunityNickname = 'testSR2';
        testSR2.TimeZoneSidKey = 'GMT';
        testSR2.LocaleSidKey = 'en_US';
        testSR2.EmailEncodingKey = 'UTF-8';
        testSR2.LanguageLocaleKey = 'en_US';
        testSR2.ProfileId = profileID;
        testSR2.ManagerId = testSR1.Id;
        insert testSR2;
        
        Account a = new Account();
        a.Name = 'Test Account';
        a.RecordTypeId = accountRTID;
        insert a;
        
        Opportunity o = new Opportunity();
        o.OwnerId = testSR2.Id;
        o.AccountId = a.Id;
        o.RecordTypeId = rtID;
        o.Name = 'Test oppty';
        o.StageName = 'Presented';
        o.CloseDate = Date.today();
        insert o;
        
        Ad_Period__c ap1 = new Ad_Period__c();
        ap1.Name = 'C2_CY2012_test';
        ap1.Start_Date__c = Date.valueOf('2012-03-23');
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
        pf1.Ad_Period__c = ap1.Id;
        pf1.Forecast_Amount__c = 1000;
        pf1.Active__c = true;
        insert pf1;
        
        PROGRAM_AMOUNT__C pa = new PROGRAM_AMOUNT__C();
        pa.Program__c = p.Id;
        //pa.QUARTER__C = 
        insert pa;
        /*
        Opportunity o2 = new Opportunity();
        o2.OwnerId = testSR1.Id;
        o2.AccountId = a.Id;
        o2.RecordTypeId = rtID;
        o2.Name = 'Test oppty';
        o2.StageName = 'Presented';
        o2.CloseDate = Date.today();
        insert o2;
        
        Ad_Period__c ap3 = new Ad_Period__c();
        ap3.Name = 'C1_CY2012_test';
        ap3.Start_Date__c = Date.valueOf('2012-12-23');
        ap3.End_Date__c = Date.valueOf('2012-01-19');
        ap3.Type__c = 'Manufacturing';
        insert ap3;
        
        Program__c p2 = new Program__c();
        p2.Name = o.Name + ' Base';
        p2.Opportunity__c = o2.Id;
        p2.Delivery_Type__c = 'Base';
        p2.Product_Type__c = 'Base Product Type1';
        p2.Start_Cycle__c = ap3.Id;
        p2.End_Cycle__c = ap2.Id;
        insert p2;
        
        Program_Forecast__c pf2 = new Program_Forecast__c();
        pf2.Program__c = p.Id;
        pf2.Ad_Period__c = ap3.Id;
        pf2.Forecast_Amount__c = 1000;
        pf2.Actual_Amount__c = 1000;
        pf2.Previous_Quarter_Actual__c = 200;
        pf2.Next_Quarter_Actual__c = 800;
        pf2.Active__c = false;
        insert pf2;
        */
        Test.startTest();
        BatchCreateProgramAmount u = new BatchCreateProgramAmount('LIMIT 400');
        Database.executeBatch(u, 400);
        Test.stopTest();
    }  

    static testMethod void testBatchCreateProgramAmountCOPY() {
        
        Catalina_Forecast_Settings__c settings = getCatalinaForecastSettingsRecord();
        
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
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
        
        User testSM1 = new User();
        testSM1.FirstName = 'test';
        testSM1.LastName = 'SM1';
        testSM1.Forecast_Role__c = 'SM1';
        testSM1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Username = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Alias = 'testSM1';
        testSM1.CommunityNickname = 'testSM1';
        testSM1.TimeZoneSidKey = 'GMT';
        testSM1.LocaleSidKey = 'en_US';
        testSM1.EmailEncodingKey = 'UTF-8';
        testSM1.LanguageLocaleKey = 'en_US';
        testSM1.ProfileId = profileID;
        testSM1.ManagerId = testEVP.Id;
        insert testSM1;
        
        User testSM2 = new User();
        testSM2.FirstName = 'test';
        testSM2.LastName = 'SM2';
        testSM2.Forecast_Role__c = 'SM2';
        testSM1.Forecast_Role__c = 'SM2';
        testSM2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM2.Username = 'testSM2@catalinamarketing.com.testuser';
        testSM2.Alias = 'testSM2';
        testSM2.CommunityNickname = 'testSM2';
        testSM2.TimeZoneSidKey = 'GMT';
        testSM2.LocaleSidKey = 'en_US';
        testSM2.EmailEncodingKey = 'UTF-8';
        testSM2.LanguageLocaleKey = 'en_US';
        testSM2.ProfileId = profileID;
        testSM2.ManagerId = testSM1.Id;
        insert testSM2;
        
        User testSR1 = new User();
        testSR1.FirstName = 'test';
        testSR1.LastName = 'SR1';
        testSR1.Forecast_Role__c = 'SR1';
        testSM1.Forecast_Role__c = 'SR1';
        testSR1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR1.Username = 'testSR1@catalinamarketing.com.testuser';
        testSR1.Alias = 'testSR1';
        testSR1.CommunityNickname = 'testSR1';
        testSR1.TimeZoneSidKey = 'GMT';
        testSR1.LocaleSidKey = 'en_US';
        testSR1.EmailEncodingKey = 'UTF-8';
        testSR1.LanguageLocaleKey = 'en_US';
        testSR1.ProfileId = profileID;
        testSR1.ManagerId = testSM2.Id;
        insert testSR1;
        
        User testSR2 = new User();
        testSR2.FirstName = 'test';
        testSR2.LastName = 'SR2';
        testSR2.Forecast_Role__c = 'SR2';
        testSR2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR2.Username = 'testSR2@catalinamarketing.com.testuser';
        testSR2.Alias = 'testSR2';
        testSR2.CommunityNickname = 'testSR2';
        testSR2.TimeZoneSidKey = 'GMT';
        testSR2.LocaleSidKey = 'en_US';
        testSR2.EmailEncodingKey = 'UTF-8';
        testSR2.LanguageLocaleKey = 'en_US';
        testSR2.ProfileId = profileID;
        testSR2.ManagerId = testSR1.Id;
        insert testSR2;
        
        Account a = new Account();
        a.Name = 'Test Account';
        a.RecordTypeId = accountRTID;
        insert a;
        
        Opportunity o = new Opportunity();
        o.OwnerId = testSR2.Id;
        o.AccountId = a.Id;
        o.RecordTypeId = rtID;
        o.Name = 'Test oppty';
        o.StageName = 'Presented';
        o.CloseDate = Date.today();
        insert o;
        
        Ad_Period__c ap1 = new Ad_Period__c();
        ap1.Name = 'C2_CY2012_test';
        ap1.Start_Date__c = Date.valueOf('2012-03-23');
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
        pf1.Ad_Period__c = ap1.Id;
        pf1.Forecast_Amount__c = 1000;
        pf1.Active__c = true;
        insert pf1;
        
        PROGRAM_AMOUNT__C pa = new PROGRAM_AMOUNT__C();
        pa.Program__c = p.Id;
        //pa.QUARTER__C = 
        insert pa;
        /*
        Opportunity o2 = new Opportunity();
        o2.OwnerId = testSR1.Id;
        o2.AccountId = a.Id;
        o2.RecordTypeId = rtID;
        o2.Name = 'Test oppty';
        o2.StageName = 'Presented';
        o2.CloseDate = Date.today();
        insert o2;
        
        Ad_Period__c ap3 = new Ad_Period__c();
        ap3.Name = 'C1_CY2012_test';
        ap3.Start_Date__c = Date.valueOf('2012-12-23');
        ap3.End_Date__c = Date.valueOf('2012-01-19');
        ap3.Type__c = 'Manufacturing';
        insert ap3;
        
        Program__c p2 = new Program__c();
        p2.Name = o.Name + ' Base';
        p2.Opportunity__c = o2.Id;
        p2.Delivery_Type__c = 'Base';
        p2.Product_Type__c = 'Base Product Type1';
        p2.Start_Cycle__c = ap3.Id;
        p2.End_Cycle__c = ap2.Id;
        insert p2;
        
        Program_Forecast__c pf2 = new Program_Forecast__c();
        pf2.Program__c = p.Id;
        pf2.Ad_Period__c = ap3.Id;
        pf2.Forecast_Amount__c = 1000;
        pf2.Actual_Amount__c = 1000;
        pf2.Previous_Quarter_Actual__c = 200;
        pf2.Next_Quarter_Actual__c = 800;
        pf2.Active__c = false;
        insert pf2;
        */
        Test.startTest();
        BatchCreateProgramAmountCOPY u = new BatchCreateProgramAmountCOPY('LIMIT 400');
        Database.executeBatch(u, 400);
        Test.stopTest();
    }  
        
    static testMethod void testBatchSalesManager1ForecastRecycleBin() {
        // TO DO: implement unit test
        Sales_Manager_1_Forecast__c sm1 = new Sales_Manager_1_Forecast__c();
        insert sm1;
        delete sm1;
        
        Test.startTest();
        BatchSalesManager1ForecastRecycleBin u = new BatchSalesManager1ForecastRecycleBin();
        Database.executeBatch(u, 400);
        Test.stopTest();
    }
    
    static testMethod void testBatchSDPYSalesManager1RecycleBin() {
        // TO DO: implement unit test
        SDPY_Sales_Manager_1_Forecast__c sm1 = new SDPY_Sales_Manager_1_Forecast__c();
        insert sm1;
        delete sm1;
        
        Test.startTest();
        BatchSDPYSalesManager1RecycleBin u = new BatchSDPYSalesManager1RecycleBin();
        Database.executeBatch(u, 400);
        Test.stopTest();
    } 
    
    static testMethod void testBatchProgForecastExceptionRecycleBin() {
        // TO DO: implement unit test
        Program_Forecast_Exception__c sm1 = new Program_Forecast_Exception__c();
        insert sm1;
        delete sm1;
        
        Test.startTest();
        BatchProgForecastExceptionRecycleBin u = new BatchProgForecastExceptionRecycleBin();
        Database.executeBatch(u, 400);
        Test.stopTest();
    }
    
    static testMethod void testBatchProgAmountRecycleBin() {
        // TO DO: implement unit test
        Catalina_Forecast_Settings__c settings = getCatalinaForecastSettingsRecord();
        
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
        String rtID = [SELECT ID FROM RecordType Where Name = 'Contract' and SOBJECTTYPE = 'Opportunity'][0].Id;
        String accountRTID = [SELECT ID FROM RecordType Where Name = 'Manufacturing' and SOBJECTTYPE = 'Account'][0].Id;
        
        Account a = new Account();
        a.Name = 'Test';
        insert a;
        
        Opportunity o = new Opportunity();
        o.CloseDate = Date.Today();
        o.StageName = 'Closed Won';
        o.AccountId = a.Id;
        o.Name = 'Test opp';
        insert o;
        
        Program__c p = new Program__c();
        p.Opportunity__c = o.Id;
        p.Name = 'Test Program';
        insert p;
        
        Program_Amount__c pa = new Program_Amount__c();
        pa.Program__c = p.Id;
        insert pa;
        delete pa;
        
        Test.startTest();
        BatchProgAmountRecycleBin u = new BatchProgAmountRecycleBin();
        Database.executeBatch(u, 400);
        Test.stopTest();
    }
    
    static testMethod void testBatchSalesManager2ForecastRecycleBin() {
        // TO DO: implement unit test
        Sales_Manager_2_Forecast__c sm1 = new Sales_Manager_2_Forecast__c();
        insert sm1;
        delete sm1;
        Test.startTest();
        BatchSalesManager2ForecastRecycleBin u = new BatchSalesManager2ForecastRecycleBin();
        Database.executeBatch(u, 400);
        Test.stopTest();
    }
    
    static testMethod void testBatchRep1ForecastRecycleBin() {
        // TO DO: implement unit test
        Rep_1_Forecast__c sm1 = new Rep_1_Forecast__c();
        insert sm1;
        delete sm1;
        Test.startTest();
        BatchRep1ForecastRecycleBin u = new BatchRep1ForecastRecycleBin();
        Database.executeBatch(u, 400);
        Test.stopTest();
    }
    
    static testMethod void testBatchRep2ForecastRecycleBin() {
        // TO DO: implement unit test
        Rep_2_Forecast__c sm1 = new Rep_2_Forecast__c();
        insert sm1;
        delete sm1;
        Test.startTest();
        BatchRep2ForecastRecycleBin u = new BatchRep2ForecastRecycleBin();
        Database.executeBatch(u, 400);
        Test.stopTest();
    }
    
    static testMethod void testBatchSalesManager1FYTotalRecycleBin() {
        // TO DO: implement unit test
        Sales_Manager_1_FY_Total__c sm1 = new Sales_Manager_1_FY_Total__c();
        insert sm1;
        delete sm1;
        
        Test.startTest();
        BatchSalesManager1FYTotalRecycleBin u = new BatchSalesManager1FYTotalRecycleBin();
        Database.executeBatch(u, 400);
        Test.stopTest();
    }
    
    static testMethod void testBatchDeactivatePFEUsers() {
        // TO DO: implement unit test
        Catalina_Forecast_Settings__c settings = getCatalinaForecastSettingsRecord();
                
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
        String rtID = [SELECT ID FROM RecordType Where Name = 'Contract' and SOBJECTTYPE = 'Opportunity'][0].Id;
        String accountRTID = [SELECT ID FROM RecordType Where Name = 'Manufacturing' and SOBJECTTYPE = 'Account'][0].Id;
        
        Account a = new Account();
        a.Name = 'Test Account';
        a.RecordTypeId = accountRTID;
        insert a;
     
        User testEVP = [Select id from User where Id = :UserInfo.getUserId()];
   
        List<Program_Forecast_Exception__c> pfeList = new List<Program_Forecast_Exception__c>();
        
        Program_Forecast_Exception__c pfe1 = new Program_Forecast_Exception__c();
        pfe1.Reason__c = 'reason 1';
        pfe1.Account__c = a.Id;
        pfeList.add(pfe1);
        
        Program_Forecast_Exception__c pfe2 = new Program_Forecast_Exception__c();
        pfe2.Reason__c = 'reason 2';
        pfe1.Account__c = a.Id;
        pfeList.add(pfe2);
        
        insert pfeList;
        
        Test.startTest();
        BatchDeactivatePFEUsers u = new BatchDeactivatePFEUsers();
        Database.executeBatch(u, 400);
        Test.stopTest();
    }
    
    static testMethod void testBatchHuffmasterAssociateMBG() {
        // TO DO: implement unit test
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
        String rtID = [SELECT ID FROM RecordType Where Name = 'Contract' and SOBJECTTYPE = 'Opportunity'][0].Id;
        String accountRTID = [SELECT ID FROM RecordType Where Name = 'Manufacturing' and SOBJECTTYPE = 'Account'][0].Id;
        User thisUser = [Select Id from User where Id = :UserInfo.getUserId()];
        User testEVP;
        System.runAs ( thisUser ) {
        
        UserRole r = new UserRole(name = 'EVP');
        insert r;
        testEVP = new User();
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
        testEVP.UserRoleId = r.Id;
        insert testEVP;
        
        User testSM1 = new User();
        testSM1.FirstName = 'test';
        testSM1.LastName = 'SM1';
        testSM1.Forecast_Role__c = 'SM1';
        testSM1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Username = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Alias = 'testSM1';
        testSM1.CommunityNickname = 'testSM1';
        testSM1.TimeZoneSidKey = 'GMT';
        testSM1.LocaleSidKey = 'en_US';
        testSM1.EmailEncodingKey = 'UTF-8';
        testSM1.LanguageLocaleKey = 'en_US';
        testSM1.ProfileId = profileID;
        testSM1.ManagerId = testEVP.Id;
        insert testSM1;
        
        Catalina_Forecast_Settings__c settings = getCatalinaForecastSettingsRecord();
        
        Account a = new Account();
        a.Name = 'Test Account';
        a.RecordTypeId = accountRTID;
        insert a;
        
        Manager_Best_Guess__c newMBG = new Manager_Best_Guess__c();
        newMBG.OwnerId = testEVP.Id;
        newMBG.Quarter__c = 'Q12012';
        insert newMBG;
        
        Sales_Manager_1_Forecast__c sm1 = new Sales_Manager_1_Forecast__c();
        sm1.OwnerId = testSM1.Id;
        sm1.Quarter__c = 'Q12012';
        sm1.Manager__c = testEVP.Id;
        sm1.Account_Type__c = 'Manufacturing';
        sm1.Delivery_Type__c = 'Digital O&O';
        sm1.Account__c = a.Id;
        insert sm1;
        }
        System.runAs(testEVP) {
        Test.startTest();
        BatchHuffmasterAssociateMBG u = new BatchHuffmasterAssociateMBG();
        Database.executeBatch(u, 400);
        Test.stopTest();
        }
    }  
    
    static testMethod void testBatchActivateOppOwners() {
        // TO DO: implement unit test
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
        String rtID = [SELECT ID FROM RecordType Where Name = 'Contract' and SOBJECTTYPE = 'Opportunity'][0].Id;
        String accountRTID = [SELECT ID FROM RecordType Where Name = 'Manufacturing' and SOBJECTTYPE = 'Account'][0].Id;
        
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        Catalina_Forecast_Settings__c settings = getCatalinaForecastSettingsRecord();
    
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
    
        Test.startTest();
        BatchActivateOppOwners u = new BatchActivateOppOwners();
        Database.executeBatch(u, 400);
        Test.stopTest();
    }
    
    static testMethod void testBatchLogInactiveOwner() {
        // TO DO: implement unit test
        Catalina_Forecast_Settings__c settings = getCatalinaForecastSettingsRecord();
                
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
        String rtID = [SELECT ID FROM RecordType Where Name = 'Contract' and SOBJECTTYPE = 'Opportunity'][0].Id;
        String accountRTID = [SELECT ID FROM RecordType Where Name = 'Manufacturing' and SOBJECTTYPE = 'Account'][0].Id;
        User usr = [Select id from User where Id = :UserInfo.getUserId()];
        Account a = new Account();
        a.Name = 'Test Account';
        a.RecordTypeId = accountRTID;
        insert a;
        
        Opportunity o = new Opportunity(Name = 'test', AccountID = a.ID, CloseDate = date.Today().addDays(1), Amount = 1, OwnerId = usr.id, StageName = 'Closed Won', CurrencyIsoCode = 'USD');
     
        Test.startTest();
        BatchLogInactiveOwner u = new BatchLogInactiveOwner();
        Database.executeBatch(u, 400);
        Test.stopTest();
    }
    
    static testMethod void testBatchCalculateBestGuess1() {
        // TO DO: implement unit test
        Catalina_Forecast_Settings__c settings = getCatalinaForecastSettingsRecord();
        
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
        String rtID = [SELECT ID FROM RecordType Where Name = 'Contract' and SOBJECTTYPE = 'Opportunity'][0].Id;
        String rtID2 = [SELECT ID FROM RecordType Where Name = 'Proposal' and SOBJECTTYPE = 'Opportunity'][0].Id;
        String accountRTID = [SELECT ID FROM RecordType Where Name = 'Manufacturing' and SOBJECTTYPE = 'Account'][0].Id;
        String accountRTIDRetail = [SELECT ID FROM RecordType Where Name = 'Retail' and SOBJECTTYPE = 'Account'][0].Id;
        String progrtID = [SELECT ID FROM RecordType Where Name = 'Contract' and SOBJECTTYPE = 'Program__c'][0].Id;
        String progrtID2 = [SELECT ID FROM RecordType Where Name = 'Proposal' and SOBJECTTYPE = 'Program__c'][0].Id;
        
        User testEVP = new User(FirstName = 'test', LastName = 'EVP', Forecast_Role__c = 'EVP', Email = 'testEVP@catalinamarketing.com.testuser', 
        Username = 'testEVP@catalinamarketing.com.testuser', Alias = 'testEVP', CommunityNickname = 'testEVP', TimeZoneSidKey = 'GMT', LocaleSidKey = 'en_US', 
        EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', ProfileId = profileID);
        insert testEVP;
        
        User testSM1 = new User(FirstName = 'test',ManagerId = testEVP.Id,LanguageLocaleKey = 'en_US',ProfileId = profileID,LastName = 'SM1', 
        Forecast_Role__c = 'SM1',Email = 'testSM1@catalinamarketing.com.testuser',Username = 'testSM1@catalinamarketing.com.testuser',Alias = 'testSM1',
        CommunityNickname = 'testSM1',TimeZoneSidKey = 'GMT',LocaleSidKey = 'en_US',EmailEncodingKey = 'UTF-8');
        insert testSM1;
        
        User testSM2 = new User( FirstName = 'test', LastName = 'SM2', Forecast_Role__c = 'SM2', Email = 'testSM1@catalinamarketing.com.testuser', 
        Username = 'testSM2@catalinamarketing.com.testuser', Alias = 'testSM2', CommunityNickname = 'testSM2', TimeZoneSidKey = 'GMT', LocaleSidKey = 'en_US', 
        EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', ProfileId = profileID, ManagerId = testSM1.Id);
        insert testSM2;
        
        User testSR1 = new User(FirstName = 'test',LastName = 'SR1',Forecast_Role__c = 'SR1',Email = 'testSM1@catalinamarketing.com.testuser',
        Username = 'testSR1@catalinamarketing.com.testuser',Alias = 'testSR1',CommunityNickname = 'testSR1',TimeZoneSidKey = 'GMT',
        LocaleSidKey = 'en_US',EmailEncodingKey = 'UTF-8',LanguageLocaleKey = 'en_US',ProfileId = profileID,ManagerId = testSM2.Id);
        insert testSR1;
        
        User testSR2 = new User( FirstName = 'test', LastName = 'SR2', Forecast_Role__c = 'SR2', Email = 'testSM1@catalinamarketing.com.testuser', 
        Username = 'testSR2@catalinamarketing.com.testuser', Alias = 'testSR2', CommunityNickname = 'testSR2', TimeZoneSidKey = 'GMT', LocaleSidKey = 'en_US', 
        EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', ProfileId = profileID, ManagerId = testSR1.Id);
        insert testSR2;
        
        Account a = new Account(Name = 'Test Account', RecordTypeId = accountRTIDRetail);
        insert a;
        
        Opportunity o = new Opportunity( OwnerId = testSR2.Id, AccountId = a.Id, RecordTypeId = rtID2, Name = 'Test oppty', StageName = 'Presented', CloseDate = Date.today());
        insert o;
        
        Opportunity o2 = new Opportunity( OwnerId = testSR2.Id, AccountId = a.Id, RecordTypeId = rtID2, Name = 'Test oppty', StageName = 'Presented', CloseDate = Date.today());
        insert o2;
        
        Ad_Period__c ap1 = new Ad_Period__c(Name = 'C2_CY2012_test', Start_Date__c = Date.valueOf('2012-01-23'), End_Date__c = Date.valueOf('2012-02-19'), Type__c = 'Retail');
        insert ap1;
        
        Ad_Period__c ap2 = new Ad_Period__c(Name = 'C3_CY2012_test', Start_Date__c = Date.valueOf('2012-01-23'), End_Date__c = Date.valueOf('2012-02-19'), Type__c = 'Retail');
        insert ap2;
        
        Ad_Period__c ap3 = new Ad_Period__c( Name = 'C4_CY2012_test', Start_Date__c = Date.valueOf('2012-03-23'), End_Date__c = Date.valueOf('2012-04-19'), Type__c = 'Manufacturing');
        insert ap3;
        
        List<Program__c> progList = new List<Program__c>();
        
        Program__c p = new Program__c(Name = o.Name + ' Base', Opportunity__c = o.Id, RecordTypeId = progrtID, Delivery_Type__c = baseType, Product_Type__c = 'Base Product Type1', 
        Start_Cycle__c = ap1.Id, End_Cycle__c = ap2.Id);
        progList.add(p);
        
        Program__c p2 = new Program__c(Name = o2.Name + ' Base', Opportunity__c = o2.Id, RecordTypeId = progrtID2, Delivery_Type__c = mobileType, Product_Type__c = 'Base Product Type1', 
        Start_Cycle__c = ap1.Id, End_Cycle__c = ap2.Id);
        progList.add(p2);
        
        Program__c p3 = new Program__c(Name = o.Name + ' Base', Opportunity__c = o.Id, RecordTypeId = progrtID, Delivery_Type__c = digitalType, Product_Type__c = 'Base Product Type1', 
        Start_Cycle__c = ap1.Id, End_Cycle__c = ap2.Id);
        progList.add(p3);
        
        Program__c p4 = new Program__c(Name = o2.Name + ' Base', Opportunity__c = o2.Id, RecordTypeId = progrtID2, Delivery_Type__c = displayType, Product_Type__c = 'Base Product Type1', 
        Start_Cycle__c = ap1.Id, End_Cycle__c = ap2.Id);
        progList.add(p4);
        
        insert progList;
        
        List<Program_Forecast__c> pfList = new List<Program_Forecast__c>();
        
        Program_Forecast__c pf1 = new Program_Forecast__c(Program__c = p.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000);
        pfList.add(pf1);
        
        Program_Forecast__c pf4 = new Program_Forecast__c(Program__c = p.Id, Ad_Period__c = ap3.Id, Forecast_Amount__c = 1000, Active__c = false);
        pfList.add(pf4);
        
        Program_Forecast__c pf6 = new Program_Forecast__c(Program__c = p.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000, Active__c = false, Previous_Quarter_Actual__c = null, 
        Next_Quarter_Actual__c = 700);
        pfList.add(pf6);
        
        Program_Forecast__c pf3 = new Program_Forecast__c(Program__c = p.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000, Active__c = false);
        pfList.add(pf3);
        
        Program_Forecast__c pf2 = new Program_Forecast__c(Program__c = p.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000, Active__c = true);
        pfList.add(pf2);
        
        Program_Forecast__c pf5 = new Program_Forecast__c(Program__c = p.Id, Ad_Period__c = ap3.Id, Forecast_Amount__c = 1000, Active__c = true);
        pfList.add(pf5);
        
        Program_Forecast__c pf1b = new Program_Forecast__c(Program__c = p2.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000);
        pfList.add(pf1b);
        
        Program_Forecast__c pf4b = new Program_Forecast__c(Program__c = p2.Id, Ad_Period__c = ap3.Id, Forecast_Amount__c = 1000, Active__c = false);
        pfList.add(pf4b);
        
        Program_Forecast__c pf6b = new Program_Forecast__c(Program__c = p2.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000, Active__c = false, 
        Previous_Quarter_Actual__c = null, Next_Quarter_Actual__c = 700);
        pfList.add(pf6b);
        
        Program_Forecast__c pf3b = new Program_Forecast__c(Program__c = p2.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000, Active__c = false);
        pfList.add(pf3b);
        
        Program_Forecast__c pf2b = new Program_Forecast__c(Program__c = p2.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000, Active__c = true);
        pfList.add(pf2b);
        
        Program_Forecast__c pf5b = new Program_Forecast__c(Program__c = p2.Id, Ad_Period__c = ap3.Id, Forecast_Amount__c = 1000, Active__c = true);
        pfList.add(pf5b);
        
        Program_Forecast__c pf1d = new Program_Forecast__c(Program__c = p3.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000);
        pfList.add(pf1d);
        
        Program_Forecast__c pf4d = new Program_Forecast__c(Program__c = p3.Id, Ad_Period__c = ap3.Id, Forecast_Amount__c = 1000, Active__c = false);
        pfList.add(pf4d);
        
        Program_Forecast__c pf6d = new Program_Forecast__c(Program__c = p3.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000, Active__c = false, 
        Previous_Quarter_Actual__c = null, Next_Quarter_Actual__c = 700);
        pfList.add(pf6d);
        
        Program_Forecast__c pf3d = new Program_Forecast__c(Program__c = p3.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000, Active__c = false);
        pfList.add(pf3d);
        
        Program_Forecast__c pf2d = new Program_Forecast__c(Program__c = p3.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000, Active__c = true);
        pfList.add(pf2d);
        
        Program_Forecast__c pf5d = new Program_Forecast__c(Program__c = p3.Id, Ad_Period__c = ap3.Id, Forecast_Amount__c = 1000, Active__c = true);
        pfList.add(pf5d);
        
        Program_Forecast__c pf1a = new Program_Forecast__c(Program__c = p4.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000);
        pfList.add(pf1a);
        
        Program_Forecast__c pf4a = new Program_Forecast__c(Program__c = p4.Id, Ad_Period__c = ap3.Id, Forecast_Amount__c = 1000, Active__c = false);
        pfList.add(pf4a);
        
        Program_Forecast__c pf6a = new Program_Forecast__c(Program__c = p4.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000, Active__c = false, 
        Previous_Quarter_Actual__c = null, Next_Quarter_Actual__c = 700);
        pfList.add(pf6a);
        
        Program_Forecast__c pf3a = new Program_Forecast__c(Program__c = p4.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000, Active__c = false);
        pfList.add(pf3a);
        
        Program_Forecast__c pf2a = new Program_Forecast__c(Program__c = p4.Id, Ad_Period__c = ap1.Id, Forecast_Amount__c = 1000, Active__c = true);
        pfList.add(pf2a);
        
        Program_Forecast__c pf5a = new Program_Forecast__c(Program__c = p4.Id, Ad_Period__c = ap3.Id, Forecast_Amount__c = 1000, Active__c = true);
        pfList.add(pf5a);
        
        Program_Forecast__c pf7 = new Program_Forecast__c(Program__c = p.Id, Ad_Period__c = ap2.Id, Forecast_Amount__c = 1000, Active__c = true);
        pfList.add(pf7);
        
        Program_Forecast__c pf7b = new Program_Forecast__c(Program__c = p2.Id, Ad_Period__c = ap2.Id, Forecast_Amount__c = 1000, Active__c = true);
        pfList.add(pf7b);
        
        Program_Forecast__c pf7d = new Program_Forecast__c(Program__c = p3.Id, Ad_Period__c = ap2.Id, Forecast_Amount__c = 1000, Active__c = true);
        pfList.add(pf7d);
        
        Program_Forecast__c pf7a = new Program_Forecast__c(Program__c = p4.Id, Ad_Period__c = ap2.Id, Forecast_Amount__c = 1000, Active__c = true);
        pfList.add(pf7a);
        
        Program_Forecast__c pf8 = new Program_Forecast__c(Program__c = p.Id, Ad_Period__c = ap3.Id, Forecast_Amount__c = 1000, Active__c = false, 
        Previous_Quarter_Actual__c = 200, Next_Quarter_Actual__c = 200);
        pfList.add(pf8);
        
        Program_Forecast__c pf8b = new Program_Forecast__c(Program__c = p2.Id, Ad_Period__c = ap3.Id, Forecast_Amount__c = 1000, Active__c = false, 
        Previous_Quarter_Actual__c = 200, Next_Quarter_Actual__c = 200);
        pfList.add(pf8b);
        
        Program_Forecast__c pf8c = new Program_Forecast__c(Program__c = p3.Id, Ad_Period__c = ap3.Id, Forecast_Amount__c = 1000, Active__c = false, 
        Previous_Quarter_Actual__c = 200, Next_Quarter_Actual__c = 200);
        pfList.add(pf8c);
        
        Program_Forecast__c pf8d = new Program_Forecast__c(Program__c = p4.Id, Ad_Period__c = ap3.Id, Forecast_Amount__c = 1000, Active__c = false, 
        Previous_Quarter_Actual__c = 200, Next_Quarter_Actual__c = 200);
        pfList.add(pf8d);
        
        insert pfList;
        
        Sales_Rep_Best_Guess__c srbg = new Sales_Rep_Best_Guess__c(OwnerId = testSR2.Id, Quarter__c = 'Q12012');
        insert srbg;
        
        Test.startTest();
        BatchCalculateBestGuess u = new BatchCalculateBestGuess('LIMIT 300');
        Database.executeBatch(u, 400);
        Test.stopTest();
    }
    
    private static Catalina_Forecast_Settings__c getCatalinaForecastSettingsRecord(){
        Catalina_Forecast_Settings__c settings = new Catalina_Forecast_Settings__c();
        settings.Base_Delivery_Type__c = baseType;
        settings.Digital_Delivery_Type__c = digitalType;
        settings.Display_Delivery_Type__c = displayType;
        settings.Mobile_Delivery_Type__c = mobileType;
        settings.Manufacturing_Account_Type__c = manufacturingType;
        settings.Retail_Account_Type__c = retailType;
        settings.Coop_String__c = coopType;
        settings.Rep_1_String__c = SR1Type;
        settings.Rep_2_String__c = SR2Type;
        settings.SM_1_String__c = SM1Type;
        settings.SM_2_String__c = SM2Type;
        settings.PFE_Email__c = pfeEmail;
        settings.Name = settingsName;
        insert settings;
        return settings;
    }
}