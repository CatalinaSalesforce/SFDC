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
public class TestBatchFranceMonthlySDLY {
	
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

    static testMethod void BatchFranceMonthlySDLY1() {
        
        String rtID = [SELECT ID FROM RecordType Where Name = 'CONTRACT FRANCE' and SOBJECTTYPE = 'Opportunity'][0].Id;
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
        
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
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
        settings.Name = settingsName;
        insert settings;
        
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
        
        Account acc = new Account();
        acc.Name = 'test1';
        insert acc;
        
        Opportunity o = new Opportunity();
        o.AccountId = acc.Id;
        o.RecordTypeId = rtID;
        o.Name = 'Test oppty';
        o.StageName = 'Presented';
        o.CloseDate = Date.today();
        o.OwnerId = testSR2.Id;
        o.Start_Date__c = Date.today().addYears(1);
        insert o;
        
        Ad_Period__c ap1 = new Ad_Period__c();
        ap1.Name = 'FR_C1_2013';
        ap1.Start_Date__c = Date.valueOf('2012-01-23');
        ap1.End_Date__c = Date.valueOf('2012-02-19');
        ap1.Type__c = 'Manufacturing France';
        insert ap1;

        Program__c pro = new Program__c();
        pro.Opportunity__c = o.Id;
        pro.Name = 'test';
        pro.Delivery_Type__c = 'Base';
        pro.Program_Amount__c = 100;
        insert pro;
        
        Program_Forecast__c pf1 = new Program_Forecast__c();
        pf1.Program__c = pro.Id;
        pf1.Ad_Period__c = ap1.Id;
        pf1.ACTUAL_AMOUNT__C = 100;
        pf1.FORECAST_AMOUNT__C = 100;
        pf1.Active__c = False;
        insert pf1;      
        
        Test.startTest();
        BatchFranceMonthlySDLY obj = new BatchFranceMonthlySDLY ('LIMIT 200');
        BatchFranceMonthlySDLY obj1 = new BatchFranceMonthlySDLY ();
        Database.executeBatch(obj, 200);
        Test.stopTest();
    
    }
    
    static testMethod void BatchFranceMonthlySDLY2() {
        
        String rtID = [SELECT ID FROM RecordType Where Name = 'CONTRACT FRANCE' and SOBJECTTYPE = 'Opportunity'][0].Id;
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
        
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
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
        settings.Name = settingsName;
        insert settings;
        
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
        
        Account acc = new Account();
        acc.Name = 'test1';
        insert acc;
        
        Opportunity o = new Opportunity();
        o.AccountId = acc.Id;
        o.RecordTypeId = rtID;
        o.Name = 'Test oppty';
        o.StageName = 'Presented';
        o.CloseDate = Date.today();
        O.OwnerId = testSR1.Id;
        o.Start_Date__c = Date.today().addYears(1);
        insert o;
        
        Ad_Period__c ap1 = new Ad_Period__c();
        ap1.Name = 'FR_C1_2013';
        ap1.Start_Date__c = Date.valueOf('2012-01-23');
        ap1.End_Date__c = Date.valueOf('2012-02-19');
        ap1.Type__c = 'Manufacturing France';
        insert ap1;
       
        Program__c pro = new Program__c();
        pro.Opportunity__c = o.Id;
        pro.Name = 'test';
        pro.Delivery_Type__c = 'Base';
        pro.Program_Amount__c = 100;
        insert pro;
        
        Program_Forecast__c pf1 = new Program_Forecast__c();
        pf1.Program__c = pro.Id;
        pf1.Ad_Period__c = ap1.Id;
        pf1.ACTUAL_AMOUNT__C = 100;
        pf1.FORECAST_AMOUNT__C = 100;
        pf1.Active__c = True;
        insert pf1;            
        
        Test.startTest();
        BatchFranceMonthlySDLY obj = new BatchFranceMonthlySDLY('LIMIT 200');
        Database.executeBatch(obj, 200);
        Test.stopTest();
    
    }
    
    static testMethod void BatchFranceMonthlySDLY3() {
        
        String rtID = [SELECT ID FROM RecordType Where Name = 'CONTRACT FRANCE' and SOBJECTTYPE = 'Opportunity'][0].Id;
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
        
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
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
        settings.Name = settingsName;
        insert settings;
        
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
        
        Account acc = new Account();
        acc.Name = 'test1';
        insert acc;
        
        Opportunity o = new Opportunity();
        o.AccountId = acc.Id;
        o.RecordTypeId = rtID;
        o.Name = 'Test oppty';
        o.StageName = 'Presented';
        o.CloseDate = Date.today().addMonths(-4);
        o.OwnerId = testSM2.Id;
        o.Start_Date__c = Date.today().addYears(1);
        insert o;
        
        Ad_Period__c ap1 = new Ad_Period__c();
        ap1.Name = 'FR_C1_2013';
        ap1.Start_Date__c = Date.valueOf('2012-01-23');
        ap1.End_Date__c = Date.valueOf('2012-02-19');
        ap1.Type__c = 'Manufacturing France';
        insert ap1;

        Program__c pro = new Program__c();
        pro.Opportunity__c = o.Id;
        pro.Name = 'test';
        pro.Delivery_Type__c = 'Base';
        pro.Program_Amount__c = 100;
        insert pro;
        
        Program_Forecast__c pf1 = new Program_Forecast__c();
        pf1.Program__c = pro.Id;
        pf1.Ad_Period__c = ap1.Id;
        pf1.ACTUAL_AMOUNT__C = 100;
        pf1.FORECAST_AMOUNT__C = 100;
        pf1.Active__c = False;
        insert pf1;      
        
        Test.startTest();
        BatchFranceMonthlySDLY obj = new BatchFranceMonthlySDLY ('LIMIT 200');
        BatchFranceMonthlySDLY obj1 = new BatchFranceMonthlySDLY ();
        Database.executeBatch(obj, 200);
        Test.stopTest();
    
    }
    
    static testMethod void BatchFranceMonthlySDLY4() {
        
        String rtID = [SELECT ID FROM RecordType Where Name = 'CONTRACT FRANCE' and SOBJECTTYPE = 'Opportunity'][0].Id;
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
        
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
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
        settings.Name = settingsName;
        insert settings;
        
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
        
        Account acc = new Account();
        acc.Name = 'test1';
        insert acc;
        
        Opportunity o = new Opportunity();
        o.AccountId = acc.Id;
        o.RecordTypeId = rtID;
        o.Name = 'Test oppty';
        o.StageName = 'Presented';
        o.CloseDate = Date.today().addMonths(-8);
        O.OwnerId = testSM1.Id;
        o.Start_Date__c = Date.today().addYears(1);
        insert o;
        
        Ad_Period__c ap1 = new Ad_Period__c();
        ap1.Name = 'FR_C1_2013';
        ap1.Start_Date__c = Date.valueOf('2012-01-23');
        ap1.End_Date__c = Date.valueOf('2012-02-19');
        ap1.Type__c = 'Manufacturing France';
        insert ap1;
       
        Program__c pro = new Program__c();
        pro.Opportunity__c = o.Id;
        pro.Name = 'test';
        pro.Delivery_Type__c = 'Base';
        pro.Program_Amount__c = 100;
        insert pro;
        
        Program_Forecast__c pf1 = new Program_Forecast__c();
        pf1.Program__c = pro.Id;
        pf1.Ad_Period__c = ap1.Id;
        pf1.ACTUAL_AMOUNT__C = 100;
        pf1.FORECAST_AMOUNT__C = 100;
        pf1.Active__c = True;
        insert pf1;            
        
        Test.startTest();
        BatchFranceMonthlySDLY obj = new BatchFranceMonthlySDLY('LIMIT 200');
        Database.executeBatch(obj, 200);
        Test.stopTest();
    
    }
}