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
 
 Author: Matt
 Email: matt@cloud62.com

 */
@isTest
private class TestUserUpdate {
	
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
    
    static testMethod void myUnitTest() {
        // TO DO: implement unit test
      //  List<User> updateList = new List<User>();
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
      
      /*Rep_2_String__c;
	    String rep1Type = settings.Rep_1_String__c;
	    String SM2Type = settings.SM_2_String__c;
	    String SM1Type = settings.SM_1_String__c;
	    String coopType = settings.Coop_String__c;
		*/
      
      
        Profile p = [SELECT Id FROM Profile][0];
        
		User user1 = new User(Forecast_Role__c='SR2',Alias = 'newUser', Email='newuser@testorg.com',
		EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
		LocaleSidKey='en_US', ProfileId=p.Id,
		TimeZoneSidKey='America/Los_Angeles', UserName='newuser@testorg.comc62full');
        user1.Forecast_Role__C = 'SR2';
        User user2 = new User(Alias = 'newUser', Email='newuser@testorg.com',
		EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
		LocaleSidKey='en_US', ProfileId=p.Id,
		TimeZoneSidKey='America/Los_Angeles', UserName='newu1ser@testorg.comc62full');
        user2.Forecast_Role__c = 'SR1';
        
        User user3 = new User(Alias = 'newUser', Email='newuser@testorg.com',
		EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
		LocaleSidKey='en_US', ProfileId=p.Id,
		TimeZoneSidKey='America/Los_Angeles', UserName='new23user@testorg.comc62full');
        user3.Forecast_Role__c = 'SM2';
        
        User user4 = new User(Alias = 'newUser', Email='newuser@testorg.com',
		EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
		LocaleSidKey='en_US', ProfileId=p.Id,
		TimeZoneSidKey='America/Los_Angeles', UserName='newuser@t44estorg.comc62full');
        user4.Forecast_Role__c = 'SM1';
        
        User user5 = new User(Alias = 'newUser', Email='newuser@testorg.com',
		EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
		LocaleSidKey='en_US', ProfileId=p.Id,
		TimeZoneSidKey='America/Los_Angeles', UserName='newuser55@testorg.comc62full');
        user5.Forecast_role__C = 'coop';
        
        User user6 = new User(Alias = 'newUser', Email='newuser@testorg.com',
		EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
		LocaleSidKey='en_US', ProfileId=p.Id,
		TimeZoneSidKey='America/Los_Angeles', UserName='newuser125@testorg.comc62full');
        user6.Forecast_Role__c = 'EVP';
        
        User user7 = new User(Alias = 'newUser', Email='newuser@testorg.com',
		EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
		LocaleSidKey='en_US', ProfileId=p.Id,
		TimeZoneSidKey='America/Los_Angeles', UserName='newus43er@testorg.comc62full');
        user7.Forecast_Role__c = 'SR1';
        
        User manager1 = new User(Alias = 'newUser', Email='newuser@testorg.com',
		EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
		LocaleSidKey='en_US', ProfileId=p.Id,
		TimeZoneSidKey='America/Los_Angeles', UserName='newuser@te21storg.comc62full');
        manager1.Forecast_Role__c = 'SR1';
        User manager2 = new User(Alias = 'newUser', Email='newuser@testorg.com',
		EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
		LocaleSidKey='en_US', ProfileId=p.Id,
		TimeZoneSidKey='America/Los_Angeles', UserName='newuser@testo32rg.comc62full');
        manager2.Forecast_Role__c = 'SM2';
        
        User manager3 = new User(Alias = 'newUser', Email='newuser@testorg.com',
		EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
		LocaleSidKey='en_US', ProfileId=p.Id,
		TimeZoneSidKey='America/Los_Angeles', UserName='newuser@te42storg.comc62full');
        manager3.Forecast_Role__c = 'SM1';
        
        User manager4 = new User(Alias = 'newUser', Email='newuser@testorg.com',
		EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
		LocaleSidKey='en_US', ProfileId=p.Id,
		TimeZoneSidKey='America/Los_Angeles', UserName='newuser@tes2323torg.comc62full');
        manager4.Forecast_Role__c = 'EVP';
        
		User manager5 = new User(Alias = 'newUser', Email='newuser@testorg.com',
		EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
		LocaleSidKey='en_US', ProfileId=p.Id,
		TimeZoneSidKey='America/Los_Angeles', UserName='newuser@t52estorg.comc62full');
		manager5.Forecast_Role__c = 'EVP';
		User manager6 = new User(Alias = 'newUser', Email='newuser@testorg.com',
		EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
		LocaleSidKey='en_US', ProfileId=p.Id,
		TimeZoneSidKey='America/Los_Angeles', UserName='newuser@test34org.comc62full');
		manager6.Forecast_Role__c = 'EVP';
		User manager7 = new User(Alias = 'newUser', Email='newuser@testorg.com',
		EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
		LocaleSidKey='en_US', ProfileId=p.Id,
		TimeZoneSidKey='America/Los_Angeles', UserName='newuser@testfadf34org.comc62full');
		manager7.Forecast_Role_Override__c = true;
		manager7.Forecast_Role__c = 'coop';
		        
		        
        insert user1;
        insert user2;
        insert user3;
        insert user4;
        insert user5;
        insert user6;
        insert user7;
        
        insert manager1;
        insert manager2;
        insert manager3;        
        insert manager4;
        insert manager5;
        insert manager6;
        insert manager7;
        
        user1.ManagerId = (manager1.Id);
        user2.ManagerId = (manager2.Id);
        user3.ManagerId = (manager7.Id);
        user4.ManagerId = (manager4.Id);
        user5.ManagerId = (manager5.Id);
        user6.ManagerId = (manager6.Id);
        user7.ManagerId = (manager2.Id);
        
        update user1;
        update user2;
        update user3;
        update user4;
        update user5;
        update user6;
        update user7;
        
        manager1.ManagerId = manager2.Id;
        manager2.ManagerId = manager3.Id;
        manager3.ManagerId = manager4.Id;
        manager4.ManagerId = manager5.Id;
        manager5.ManagerId = manager6.Id;
        manager6.ManagerId = manager7.Id;
        
        update manager1;
        update manager2;
        update manager3;
        update manager4;
        update manager5;
        update manager6;
        update manager7;
        
        //test override button
        user1.Forecast_Role_Override__c = true;
  //      update user1;
        //make mismatch on purpose
        user1.ManagerId = (manager4.Id);
        update user1;
    
        //make one where user doesn't have a forecast role
       // user1.Forecast_Role_Override__c == false;
        user1.Forecast_Role_Override__c = false;
        user1.Forecast_Role__c = null;
        try{
        update user1;
        }catch(Exception e){
        	//blah
        }
        //invalid role
        user1.Forecast_Role__c = 'what';
        try{
        update user1;
        }catch(Exception e){
        	//blah
        }
        user3.ManagerId = manager1.Id;
        user2.ManagerId = manager4.Id;
        try{
        	update user3;
        	
        }catch(Exception e){}
        try{ update user4;}catch(Exception e){}
        user1.ManagerId = manager4.Id;
        try{update user1;}catch(Exception e){}
        user7.ManagerId = manager4.Id;
        try{update user7;}catch(Exception e){}
        user1.ManagerId = null;
        try{update user1;}catch(Exception e){}
        manager3.ManagerId = manager1.Id;
        try{update manager3;}catch(Exception e){}
        user1.Forecast_Role__c = 'SR2';
    	user1.ManagerId = manager4.Id;
    	try{update user1;}catch(Exception e){}
    }
    
    //test AsyncCall class
    static testMethod void myUnitTest2() {
    	String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
        String rtID = [SELECT ID FROM RecordType Where Name = 'Contract' and SOBJECTTYPE = 'Opportunity'][0].Id;
        String accountRTID = [SELECT ID FROM RecordType Where Name = 'Manufacturing' and SOBJECTTYPE = 'Account'][0].Id;
        
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
        
        Set<Id> opps = new Set<Id>();
        opps.add(o.Id);
        
        Test.startTest();
        AsyncCall.updateOpps(opps);
        Test.stopTest();
    }
    
}