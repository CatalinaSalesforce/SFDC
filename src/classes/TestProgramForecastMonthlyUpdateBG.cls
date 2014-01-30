@isTest
public class TestProgramForecastMonthlyUpdateBG{
      
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
    
  static testMethod void testProgramForecastMonthlyUpdateBG() {
        // TO DO: implement unit test
        Catalina_Forecast_Settings__c settings = getCatalinaForecastSettingsRecord();
        
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
        String rtID = [SELECT ID FROM RecordType Where Name = 'Contract' and SOBJECTTYPE = 'Opportunity'][0].Id;
        String rtID2 = [SELECT ID FROM RecordType Where Name = 'Proposal' and SOBJECTTYPE = 'Opportunity'][0].Id;
        String accountRTID = [SELECT ID FROM RecordType Where Name = 'Manufacturing' and SOBJECTTYPE = 'Account'][0].Id;
        String accountRTIDRetail = [SELECT ID FROM RecordType Where Name = 'Retail' and SOBJECTTYPE = 'Account'][0].Id;
        String progrtID = [SELECT ID FROM RecordType Where Name = 'Contract' and SOBJECTTYPE = 'Program__c'][0].Id;
        String progrtID2 = [SELECT ID FROM RecordType Where Name = 'Proposal' and SOBJECTTYPE = 'Program__c'][0].Id;
        User testEVP;
        User testSM1;
        User testSM2;
        User testSR1;
        User testSR2;
        System.runAs(new User (Id = UserInfo.getUserId())){
        	
	        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
	        settings1.Renewal_Window_Size__c = 14;
	        settings1.Percent_Goal__c = 0;
	        insert settings1;
	        
	        Ad_Period_days__c APSETTING1 = new Ad_Period_days__c();
	        APSETTING1.Name = 'US';
	        APSETTING1.Number_Of_Days__c = 28;
	        insert APSETTING1;
	        
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
	        insert testEVP;
	        
	        testSM1 = new User();
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
	        
	        testSM2 = new User();
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
	        
	        testSR1 = new User();
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
	        
	        testSR2 = new User();
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
        }
        
        Account cong = new Account(Name = 'Test Conglomerate', RecordTypeId = accountRTIDRetail);
        insert cong;
        
        Account a = new Account(Name = 'Test Account', RecordTypeId = accountRTIDRetail, ParentId = cong.Id);
        insert a;
        
        Opportunity o = new Opportunity( OwnerId = testSR2.Id, AccountId = a.Id, RecordTypeId = rtID, Name = 'Test oppty', StageName = 'Presented', CloseDate = Date.today());
        insert o;
        
        Opportunity o2 = new Opportunity( OwnerId = testSR2.Id, AccountId = a.Id, RecordTypeId = rtID2, Name = 'Test oppty', StageName = 'Presented', CloseDate = Date.today());
        insert o2;
        
        Ad_Period__c ap1 = new Ad_Period__c(Name = 'C2_CY2013_test', Start_Date__c = Date.valueOf('2013-01-23'), End_Date__c = Date.valueOf('2013-02-19'), Type__c = 'Retail', External_Id__c = 'C2_CY2012_test', Month1__c = Date.valueOf('2013-01-01'), Month1_Days__c = 14);
        insert ap1;
        
        Ad_Period__c ap2 = new Ad_Period__c(Name = 'C3_CY2013_test', Start_Date__c = Date.valueOf('2013-04-23'), End_Date__c = Date.valueOf('2013-05-19'), Type__c = 'Retail', External_Id__c = 'C3_CY2012_test', Month1__c = Date.valueOf('2013-04-01'), Month1_Days__c = 14);
        insert ap2;
        
        Ad_Period__c ap3 = new Ad_Period__c( Name = 'C4_CY2013_test', Start_Date__c = Date.valueOf('2013-06-23'), End_Date__c = Date.valueOf('2013-07-19'), Type__c = 'Retail', External_Id__c = 'C4_CY2012_test', Month1__c = Date.valueOf('2013-06-01'), Month1_Days__c = 20);
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
        
        Account_Best_Guess_Summary__c abgs = new Account_Best_Guess_Summary__c(OwnerId = testSR2.Id, Year__c = '2013', Delivery_Channel__c = 'Base', Account__c = a.Id);
        insert abgs;
        
        Sales_Rep_Best_Guess__c srbg = new Sales_Rep_Best_Guess__c(OwnerId = testSR2.Id, Quarter__c = 'Q12013');
        insert srbg;
        
        Test.startTest();
        insert pfList;
        
        for (Program_Forecast__c thisPF : pfList){
        	thisPF.Forecast_Amount__c = 1592234;
        	thisPF.Actual_Amount__c = 52123491;
        }
        update pfList;
        Test.stopTest();
    }
    static testMethod void testProgramForecastMonthlyUpdateBG24() {
        // TO DO: implement unit test
        Catalina_Forecast_Settings__c settings = getCatalinaForecastSettingsRecord();
        
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
        String rtID = [SELECT ID FROM RecordType Where Name = 'Contract' and SOBJECTTYPE = 'Opportunity'][0].Id;
        String rtID2 = [SELECT ID FROM RecordType Where Name = 'Proposal' and SOBJECTTYPE = 'Opportunity'][0].Id;
        String accountRTID = [SELECT ID FROM RecordType Where Name = 'Manufacturing' and SOBJECTTYPE = 'Account'][0].Id;
        String accountRTIDRetail = [SELECT ID FROM RecordType Where Name = 'Retail' and SOBJECTTYPE = 'Account'][0].Id;
        String progrtID = [SELECT ID FROM RecordType Where Name = 'Contract' and SOBJECTTYPE = 'Program__c'][0].Id;
        String progrtID2 = [SELECT ID FROM RecordType Where Name = 'Proposal' and SOBJECTTYPE = 'Program__c'][0].Id;
        User testEVP;
        User testSM1;
        User testSM2;
        User testSR1;
        User testSR2;
        System.runAs(new User (Id = UserInfo.getUserId())){
        	
	        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
	        settings1.Renewal_Window_Size__c = 14;
	        settings1.Percent_Goal__c = 0;
	        insert settings1;
	        
	        Ad_Period_days__c APSETTING1 = new Ad_Period_days__c();
	        APSETTING1.Name = 'US';
	        APSETTING1.Number_Of_Days__c = 28;
	        insert APSETTING1;
	        
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
	        insert testEVP;
	        
	        testSM1 = new User();
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
	        
	        testSM2 = new User();
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
	        
	        testSR1 = new User();
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
	        
	        testSR2 = new User();
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
        }
        
        Account cong = new Account(Name = 'Test Conglomerate', RecordTypeId = accountRTID);
        insert cong;
        
        Account a = new Account(Name = 'Test Account', RecordTypeId = accountRTID, ParentId = cong.Id);
        insert a;
        
        Opportunity o = new Opportunity( OwnerId = testSR2.Id, AccountId = a.Id, RecordTypeId = rtID2, Name = 'Test oppty', StageName = 'Presented', CloseDate = Date.today());
        insert o;
        
        Opportunity o2 = new Opportunity( OwnerId = testSR2.Id, AccountId = a.Id, RecordTypeId = rtID, Name = 'Test oppty', StageName = 'Presented', CloseDate = Date.today());
        insert o2;
        
        Ad_Period__c ap1 = new Ad_Period__c(Name = 'C2_CY2013_test', Start_Date__c = Date.valueOf('2013-01-23'), End_Date__c = Date.valueOf('2013-02-19'), Type__c = 'Manufacturing', External_Id__c = 'C2_CY2012_test', Month1__c = Date.valueOf('2013-01-01'), Month1_Days__c = 14);
        insert ap1;
        
        Ad_Period__c ap2 = new Ad_Period__c(Name = 'C3_CY2013_test', Start_Date__c = Date.valueOf('2013-04-23'), End_Date__c = Date.valueOf('2013-05-19'), Type__c = 'Manufacturing', External_Id__c = 'C3_CY2012_test', Month1__c = Date.valueOf('2013-04-01'), Month1_Days__c = 14);
        insert ap2;
        
        Ad_Period__c ap3 = new Ad_Period__c( Name = 'C4_CY2013_test', Start_Date__c = Date.valueOf('2013-06-23'), End_Date__c = Date.valueOf('2013-07-19'), Type__c = 'Manufacturing', External_Id__c = 'C4_CY2012_test', Month1__c = Date.valueOf('2013-06-01'), Month1_Days__c = 20);
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
        
        Account_Best_Guess_Summary__c abgs = new Account_Best_Guess_Summary__c(OwnerId = testSR2.Id, Year__c = '2013', Delivery_Channel__c = 'Base', Account__c = a.Id);
        insert abgs;
        
        Sales_Rep_Best_Guess__c srbg = new Sales_Rep_Best_Guess__c(OwnerId = testSR2.Id, Quarter__c = 'Q12013');
        insert srbg;
        
        Test.startTest();
        insert pfList;
        for (Program_Forecast__c thisPF : pfList){
        	thisPF.Forecast_Amount__c = 1592234;
        	thisPF.Actual_Amount__c = 52123491;
        }
        update pfList;
        Test.stopTest();
    }
    
    static testMethod void testProgramForecastMonthlyUpdateBG3() {
        // TO DO: implement unit test
        Catalina_Forecast_Settings__c settings = getCatalinaForecastSettingsRecord();
        
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
        String rtID = [SELECT ID FROM RecordType Where Name = 'Contract' and SOBJECTTYPE = 'Opportunity'][0].Id;
        String rtID2 = [SELECT ID FROM RecordType Where Name = 'Proposal' and SOBJECTTYPE = 'Opportunity'][0].Id;
        String accountRTID = [SELECT ID FROM RecordType Where Name = 'Manufacturing' and SOBJECTTYPE = 'Account'][0].Id;
        String accountRTIDRetail = [SELECT ID FROM RecordType Where Name = 'Retail' and SOBJECTTYPE = 'Account'][0].Id;
        String progrtID = [SELECT ID FROM RecordType Where Name = 'Contract' and SOBJECTTYPE = 'Program__c'][0].Id;
        String progrtID2 = [SELECT ID FROM RecordType Where Name = 'Proposal' and SOBJECTTYPE = 'Program__c'][0].Id;
        User testEVP;
        User testSM1;
        User testSM2;
        User testSR1;
        User testSR2;
        System.runAs(new User (Id = UserInfo.getUserId())){
        	
	        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
	        settings1.Renewal_Window_Size__c = 14;
	        settings1.Percent_Goal__c = 0;
	        insert settings1;
	        
	        Ad_Period_days__c APSETTING1 = new Ad_Period_days__c();
	        APSETTING1.Name = 'US';
	        APSETTING1.Number_Of_Days__c = 28;
	        insert APSETTING1;
	        
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
	        insert testEVP;
	        
	        testSM1 = new User();
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
	        
	        testSM2 = new User();
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
	        
	        testSR1 = new User();
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
	        
	        testSR2 = new User();
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
        }
        
        Account cong = new Account(Name = 'Test Conglomerate', RecordTypeId = accountRTIDRetail);
        insert cong;
        
        Account a = new Account(Name = 'Test Account', RecordTypeId = accountRTIDRetail, ParentId = cong.Id);
        insert a;
        
        Opportunity o = new Opportunity( OwnerId = testSR2.Id, AccountId = a.Id, RecordTypeId = rtID2, Name = 'Test oppty', StageName = 'Presented', CloseDate = Date.today());
        insert o;
        
        Opportunity o2 = new Opportunity( OwnerId = testSR2.Id, AccountId = a.Id, RecordTypeId = rtID, Name = 'Test oppty', StageName = 'Presented', CloseDate = Date.today());
        insert o2;
        
        Ad_Period__c ap1 = new Ad_Period__c(Name = 'C2_CY2013_test', Start_Date__c = Date.valueOf('2013-01-23'), End_Date__c = Date.valueOf('2013-02-19'), Type__c = 'Retail', External_Id__c = 'C2_CY2012_test', Month1__c = Date.valueOf('2013-01-01'), Month1_Days__c = 14);
        insert ap1;
        
        Ad_Period__c ap2 = new Ad_Period__c(Name = 'C3_CY2013_test', Start_Date__c = Date.valueOf('2013-04-23'), End_Date__c = Date.valueOf('2013-05-19'), Type__c = 'Retail', External_Id__c = 'C3_CY2012_test', Month1__c = Date.valueOf('2013-04-01'), Month1_Days__c = 14);
        insert ap2;
        
        Ad_Period__c ap3 = new Ad_Period__c( Name = 'C4_CY2013_test', Start_Date__c = Date.valueOf('2013-06-23'), End_Date__c = Date.valueOf('2013-07-19'), Type__c = 'Retail', External_Id__c = 'C4_CY2012_test', Month1__c = Date.valueOf('2013-06-01'), Month1_Days__c = 20);
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
        
        Account_Best_Guess_Summary__c abgs = new Account_Best_Guess_Summary__c(OwnerId = testSR2.Id, Year__c = '2013', Delivery_Channel__c = 'Base', Account__c = a.Id);
        insert abgs;
        
        Sales_Rep_Best_Guess__c srbg = new Sales_Rep_Best_Guess__c(OwnerId = testSR2.Id, Quarter__c = 'Q12013');
        insert srbg;
        
        Test.startTest();
        insert pfList;
        
        for (Program_Forecast__c thisPF : pfList){
        	thisPF.Forecast_Amount__c = 1592234;
        	thisPF.Actual_Amount__c = 52123491;
        }
        update pfList;
        Test.stopTest();
    }
    
        
    static testMethod void testProgramForecastMonthlyUpdateBG2() {
        // TO DO: implement unit test
        Catalina_Forecast_Settings__c settings = getCatalinaForecastSettingsRecord();
        
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
        String rtID = [SELECT ID FROM RecordType Where Name = 'Contract' and SOBJECTTYPE = 'Opportunity'][0].Id;
        String rtID2 = [SELECT ID FROM RecordType Where Name = 'Proposal' and SOBJECTTYPE = 'Opportunity'][0].Id;
        String accountRTID = [SELECT ID FROM RecordType Where Name = 'Manufacturing' and SOBJECTTYPE = 'Account'][0].Id;
        String accountRTIDRetail = [SELECT ID FROM RecordType Where Name = 'Retail' and SOBJECTTYPE = 'Account'][0].Id;
        String progrtID = [SELECT ID FROM RecordType Where Name = 'Contract' and SOBJECTTYPE = 'Program__c'][0].Id;
        String progrtID2 = [SELECT ID FROM RecordType Where Name = 'Proposal' and SOBJECTTYPE = 'Program__c'][0].Id;
        User testEVP;
        User testSM1;
        User testSM2;
        User testSR1;
        User testSR2;
        System.runAs(new User (Id = UserInfo.getUserId())){
        	
	        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
	        settings1.Renewal_Window_Size__c = 14;
	        settings1.Percent_Goal__c = 0;
	        insert settings1;
	        
	        Ad_Period_days__c APSETTING1 = new Ad_Period_days__c();
	        APSETTING1.Name = 'US';
	        APSETTING1.Number_Of_Days__c = 28;
	        insert APSETTING1;
	        
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
	        insert testEVP;
	        
	        testSM1 = new User();
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
	        
	        testSM2 = new User();
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
	        
	        testSR1 = new User();
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
	        
	        testSR2 = new User();
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
        }
        
        Account cong = new Account(Name = 'Test Conglomerate', RecordTypeId = accountRTID);
        insert cong;
        
        Account a = new Account(Name = 'Test Account', RecordTypeId = accountRTID, ParentId = cong.Id);
        insert a;
        
        Opportunity o = new Opportunity( OwnerId = testSR2.Id, AccountId = a.Id, RecordTypeId = rtID, Name = 'Test oppty', StageName = 'Presented', CloseDate = Date.today());
        insert o;
        
        Opportunity o2 = new Opportunity( OwnerId = testSR2.Id, AccountId = a.Id, RecordTypeId = rtID2, Name = 'Test oppty', StageName = 'Presented', CloseDate = Date.today());
        insert o2;
        
        Ad_Period__c ap1 = new Ad_Period__c(Name = 'C2_CY2013_test', Start_Date__c = Date.valueOf('2013-01-23'), End_Date__c = Date.valueOf('2013-02-19'), Type__c = 'Manufacturing', External_Id__c = 'C2_CY2012_test', Month1__c = Date.valueOf('2013-01-01'), Month1_Days__c = 14);
        insert ap1;
        
        Ad_Period__c ap2 = new Ad_Period__c(Name = 'C3_CY2013_test', Start_Date__c = Date.valueOf('2013-04-23'), End_Date__c = Date.valueOf('2013-05-19'), Type__c = 'Manufacturing', External_Id__c = 'C3_CY2012_test', Month1__c = Date.valueOf('2013-04-01'), Month1_Days__c = 14);
        insert ap2;
        
        Ad_Period__c ap3 = new Ad_Period__c( Name = 'C4_CY2013_test', Start_Date__c = Date.valueOf('2013-06-23'), End_Date__c = Date.valueOf('2013-07-19'), Type__c = 'Manufacturing', External_Id__c = 'C4_CY2012_test', Month1__c = Date.valueOf('2013-06-01'), Month1_Days__c = 20);
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
        
        Account_Best_Guess_Summary__c abgs = new Account_Best_Guess_Summary__c(OwnerId = testSR2.Id, Year__c = '2013', Delivery_Channel__c = 'Base', Account__c = a.Id);
        insert abgs;
        
        Sales_Rep_Best_Guess__c srbg = new Sales_Rep_Best_Guess__c(OwnerId = testSR2.Id, Quarter__c = 'Q12013');
        insert srbg;
        
        Test.startTest();
        insert pfList;
        for (Program_Forecast__c thisPF : pfList){
        	thisPF.Forecast_Amount__c = 1592234;
        	thisPF.Actual_Amount__c = 52123491;
        }
        update pfList;
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