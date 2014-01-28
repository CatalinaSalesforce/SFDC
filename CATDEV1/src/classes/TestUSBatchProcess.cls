/*
@Name : TestUSBatchProcess
@Author : customersuccess@cloud62.com
@Date : 
@Description : 
*/
@isTest
private class TestUSBatchProcess {
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
    
    
    /*
    @Name :testBatchHuffmasterAssociateMBG
    @Description : test functionality for BatchHuffmasterAssociateMBG.
    */
    static testMethod void testBatchHuffmasterAssociateMBG() {
        // TO DO: implement unit test
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
        String rtID = [SELECT ID FROM RecordType Where Name = 'Contract' and SOBJECTTYPE = 'Opportunity'][0].Id;
        String accountRTID = [SELECT ID FROM RecordType Where Name = 'Manufacturing' and SOBJECTTYPE = 'Account'][0].Id;
        String accountRTIDRetail = [SELECT ID FROM RecordType Where Name = 'Retail' and SOBJECTTYPE = 'Account'][0].Id;
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
        testEVP.Country__c = 'USA';
        testEVP.UserRoleId = r.Id;
        insert testEVP;
        
        User testSM1 = new User();
        testSM1.FirstName = 'test';
        testSM1.Country__c = 'USA';
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
        
        Account a1 = new Account();
        a1.Name = 'Test Account';
        a1.RecordTypeId = accountRTIDRetail;
        insert a1;
        
        Manager_Best_Guess__c newMBG = new Manager_Best_Guess__c();
        newMBG.OwnerId = testEVP.Id;
        newMBG.Quarter__c = 'Q12013';
        insert newMBG;
        
        List<Sales_Manager_1_Forecast__c> smRetail = getSM1FRecord(testSM1.ID,testEVP.Id,a1.ID,'Retail');
        List<Sales_Manager_1_Forecast__c> smManufacturing = getSM1FRecord(testSM1.ID,testEVP.Id,a1.ID,'Manufacturing');
        
        }
        System.runAs(testEVP) {
        Test.startTest();
        BatchHuffmasterAssociateMBG u = new BatchHuffmasterAssociateMBG();
        Database.executeBatch(u, 400);
        Test.stopTest();
        }
    } 
    
    /*
    @Name :testBatchHuffmasterAssociateMBG1
    @Description : test functionality for BatchHuffmasterAssociateMBG.
    */
    static testMethod void testBatchHuffmasterAssociateMBG1() {
        // TO DO: implement unit test
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
        String rtID = [SELECT ID FROM RecordType Where Name = 'Contract' and SOBJECTTYPE = 'Opportunity'][0].Id;
        String accountRTID = [SELECT ID FROM RecordType Where Name = 'Manufacturing' and SOBJECTTYPE = 'Account'][0].Id;
        String accountRTIDRetail = [SELECT ID FROM RecordType Where Name = 'Retail' and SOBJECTTYPE = 'Account'][0].Id;
        User thisUser = [Select Id from User where Id = :UserInfo.getUserId()];
        User testEVP;
        System.runAs ( thisUser ) {
        
        UserRole r = new UserRole(name = 'EVP');
        insert r;
        testEVP = new User();
        testEVP.FirstName = 'test';
        testEVP.LastName = 'EVP';
        testEVP.Forecast_Role__c = 'coop';
        testEVP.Email = 'testEVP@catalinamarketing.com.testuser';
        testEVP.Username = 'testEVP@catalinamarketing.com.testuser';
        testEVP.Alias = 'testEVP';
        testEVP.CommunityNickname = 'testEVP';
        testEVP.TimeZoneSidKey = 'GMT';
        testEVP.LocaleSidKey = 'en_US';
        testEVP.EmailEncodingKey = 'UTF-8';
        testEVP.LanguageLocaleKey = 'en_US';
        testEVP.ProfileId = profileID;
        testEVP.Country__c = 'USA';
        testEVP.UserRoleId = r.Id;
        insert testEVP;
        
        User testSM1 = new User();
        testSM1.FirstName = 'test';
        testSM1.Country__c = 'USA';
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
        
        Account a1 = new Account();
        a1.Name = 'Test Account';
        a1.RecordTypeId = accountRTIDRetail;
        insert a1;
        
        Manager_Best_Guess__c newMBG = new Manager_Best_Guess__c();
        newMBG.OwnerId = testEVP.Id;
        newMBG.Quarter__c = 'Q12013';
        insert newMBG;
        
        List<Sales_Manager_1_Forecast__c> smRetail = getSM1FRecord(testEVP.Id,testEVP.Id,a1.ID,'Retail');
        List<Sales_Manager_1_Forecast__c> smManufacturing = getSM1FRecord(testEVP.Id,testEVP.Id,a1.ID,'Manufacturing');
        
        }
        System.runAs(testEVP) {
        Test.startTest();
        BatchHuffmasterAssociateMBG u = new BatchHuffmasterAssociateMBG();
        Database.executeBatch(u, 400);
        String sch = '0 0 23 * * ?'; 
        system.schedule('BatchHuffmasterAssociateMBG', sch, u); 
        Test.stopTest();
        }
    }
    
    /*
    @Name :testBatchArchiveHistoricalAccBG
    @Description : test functionality for BatchArchiveHistoricalAccBG.
    */
    static testMethod void testBatchArchiveHistoricalAccBG() {
        // TO DO: implement unit test

        Catalina_Forecast_Settings__c settings = getCatalinaForecastSettingsRecord();
        HBGBatchInterval__c hl = new HBGBatchInterval__c(Name='LastDate',Account_BG_Interval__c=13);
        insert hl;
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        
        Account_Best_Guess_Summary__c abg = new Account_Best_Guess_Summary__c();
        abg.Account__c = a.Id;
        abg.Year__c = '2013';
        abg.Delivery_Channel__c='Base';
        insert abg;
        
        Historical_Account_Best_Guess_Summary__c habg = new Historical_Account_Best_Guess_Summary__c();
        habg.Account__c = a.Id;
        habg.Archive_Date__c=system.today().addMonths(-3);
        habg.Year__c = '2013';
        habg.Delivery_Channel__c='Base';
        insert habg;
        
        Test.startTest();
        BatchArchiveHistoricalAccBG u = new BatchArchiveHistoricalAccBG();
        Database.executeBatch(u, 400);
        String sch = '0 0 23 * * ?'; 
        system.schedule('BatchArchiveHistoricalAccBG', sch, u); 
        Test.stopTest();
        
    }
    
    /*
    @Name :testBatchArchiveHistoricalCongBG
    @Description : test functionality for BatchArchiveHistoricalCongBG.
    */
    static testMethod void testBatchArchiveHistoricalCongBG() {
        // TO DO: implement unit test

        Catalina_Forecast_Settings__c settings = getCatalinaForecastSettingsRecord();
        HBGBatchInterval__c hl = new HBGBatchInterval__c(Name='LastDate',Account_BG_Interval__c=13);
        insert hl;
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        
        Conglomerate_Account_Best_Guess_Summary__c abg = new Conglomerate_Account_Best_Guess_Summary__c();
        abg.Account__c = a.Id;
        abg.Year__c = '2013';
        abg.Delivery_Channel__c='Base';
        insert abg;
        
        Historic_Conglomerate_Best_Guess_Summary__c habg = new Historic_Conglomerate_Best_Guess_Summary__c();
        habg.Account__c = a.Id;
        habg.Archive_Date__c=system.today().addMonths(-3);
        habg.Year__c = '2013';
        habg.Delivery_Channel__c='Base';
        insert habg;
        
        Test.startTest();
        BatchArchiveHistoricalCongBG u = new BatchArchiveHistoricalCongBG();
        Database.executeBatch(u, 400);
        String sch = '0 0 23 * * ?'; 
        system.schedule('BatchArchiveHistoricalCongBG', sch, u); 
        Test.stopTest();
        
    }
    
    
    /*
    @Name :getSM1FRecord
    @Description : prepare the test data for Sales_Manager_1_Forecast__c.
    */
    private static List<Sales_Manager_1_Forecast__c> getSM1FRecord(String testSM1,String testEVP,String aID,String aType){
        Sales_Manager_1_Forecast__c smf1 = new Sales_Manager_1_Forecast__c(OwnerId = testSM1,Quarter__c = 'Q12013',
            Manager__c = testEVP,Account_Type__c = aType,Delivery_Type__c = 'Digital O&O',Account__c = aID);
        Sales_Manager_1_Forecast__c smf2 = new Sales_Manager_1_Forecast__c(OwnerId = testSM1,Quarter__c = 'Q12013',
            Manager__c = testEVP,Account_Type__c = aType,Delivery_Type__c = 'Base',Account__c = aID);
        Sales_Manager_1_Forecast__c smf3 = new Sales_Manager_1_Forecast__c(OwnerId = testSM1,Quarter__c = 'Q12013',
            Manager__c = testEVP,Account_Type__c = aType,Delivery_Type__c = 'Audience Network',Account__c = aID);
        Sales_Manager_1_Forecast__c smf4 = new Sales_Manager_1_Forecast__c(OwnerId = testSM1,Quarter__c = 'Q12013',
            Manager__c = testEVP,Account_Type__c = aType,Delivery_Type__c = 'Mobile',Account__c = aID);
        List<Sales_Manager_1_Forecast__c> sm = new List<Sales_Manager_1_Forecast__c>();
        sm.add(smf1);
        sm.add(smf2);
        sm.add(smf3);
        sm.add(smf4);
        insert sm;
        return sm;
    }
    
    /*
    @Name :getCatalinaForecastSettingsRecord
    @Description : prepare the test data for Catalina_Forecast_Settings__c.
    */
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