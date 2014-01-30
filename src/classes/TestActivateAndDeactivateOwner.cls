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
public class TestActivateAndDeactivateOwner{
    
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
    private static final String settingsName = 'Default';
    
    
    // test method for BatchActivateOppOwner class
    static testMethod void BatchActivateOppOwner(){
         // TO DO: implement unit test
        String profileID = [Select ID From Profile Where Name =: 'System Administrator' Limit 1][0].Id;
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
        
        User u = new User();
        u.Firstname = 'test';
        u.LastName = 'TestUser';
        u.Username = 'testuser321@email.com';
        u.Email = 'testuser321@email.com';
        u.Alias = 'tUser';
        u.CommunityNickname = 'tUser123';
        u.TimeZoneSidKey = 'GMT';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.ProfileId = profileID;
        u.isActive = true;
        insert u;
        
        Account a = new Account();
        a.Name = 'Test Account';
        a.RecordTypeId = accountRTID;
        insert a;
        
        Opportunity o = new Opportunity();
        o.OwnerId = u.Id;
        o.AccountId = a.Id;
        o.RecordTypeId = rtID;
        o.Name = 'Test oppty';
        o.StageName = 'Idea';
        o.CloseDate = Date.today();
        insert o;
        
        Test.startTest();
        BatchActivateOppOwners batch = new BatchActivateOppOwners();
        String sch = '0 0 23 * * ?'; 
        system.schedule('testBatchOppowner', sch, batch);
        Database.executeBatch(batch, 400);
        Test.stopTest();
                
    }
    
    // test method for BatchLogInactiveOwner class
    static testMethod void BatchLogInactiveOwner(){
         // TO DO: implement unit test
        String profileID = [Select ID From Profile Where Name =: 'System Administrator' Limit 1][0].Id;
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
        
        User u = new User();
        u.Firstname = 'test';
        u.LastName = 'TestUser';
        u.Username = 'testuser321@email.com';
        u.Email = 'testuser321@email.com';
        u.Alias = 'tUser';
        u.CommunityNickname = 'tUser123';
        u.TimeZoneSidKey = 'GMT';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.ProfileId = profileID;
        u.isActive = true;
        insert u;
        
        Account a = new Account();
        a.Name = 'Test Account';
        a.RecordTypeId = accountRTID;
        insert a;
        
        Opportunity o = new Opportunity();
        o.OwnerId = u.Id;
        o.AccountId = a.Id;
        o.RecordTypeId = rtID;
        o.Name = 'Test oppty';
        o.StageName = 'Idea';
        o.CloseDate = Date.today();
        insert o;

        Test.startTest();
        BatchLogInactiveOwner batch = new BatchLogInactiveOwner();
        String sch = '0 0 23 * * ?'; 
        system.schedule('testBatchLogInactiveowner', sch, batch);
        Database.executeBatch(batch, 400);
        Test.stopTest();
                
    }
    
    // test method for BatchDeactivatePFEUsers class
    static testMethod void BatchDeactivatePFEUsers(){
         // TO DO: implement unit test
        String profileID = [Select ID From Profile Where Name =: 'System Administrator' Limit 1][0].Id;
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
        
        User u = new User();
        u.Firstname = 'test';
        u.LastName = 'TestUser';
        u.Username = 'testuser321@email.com';
        u.Email = 'testuser321@email.com';
        u.Alias = 'tUser';
        u.CommunityNickname = 'tUser123';
        u.TimeZoneSidKey = 'GMT';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.ProfileId = profileID;
        u.isActive = true;
        insert u;
        
        Account a = new Account();
        a.Name = 'Test Account';
        a.RecordTypeId = accountRTID;
        insert a;
        
        Opportunity o = new Opportunity();
        o.OwnerId = u.Id;
        o.AccountId = a.Id;
        o.RecordTypeId = rtID;
        o.Name = 'Test oppty';
        o.StageName = 'Idea';
        o.CloseDate = Date.today();
        insert o;
        
        Test.startTest();
        BatchDeactivatePFEUsers batch = new BatchDeactivatePFEUsers();
        String sch = '0 0 23 * * ?'; 
        system.schedule('testBatchDeactivePFEUsers', sch, batch);
        Database.executeBatch(batch, 400);
        Test.stopTest();
                
    }
    
    // test method for UserUpdateMoveOpps_Trigger trigger
    static testMethod void UserUpdateMoveOpps_Trigger(){
         // TO DO: implement unit test
        String profileID = [Select ID From Profile Where Name =: 'System Administrator' Limit 1][0].Id;
      
        User u = new User();
        u.Firstname = 'test';
        u.LastName = 'TestUser';
        u.Username = 'testuser321@email.com';
        u.Email = 'testuser321@email.com';
        u.Alias = 'tUser';
        u.CommunityNickname = 'tUser123';
        u.TimeZoneSidKey = 'GMT';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.ProfileId = profileID;
        u.isActive = true;
        insert u;
        
        u.isActive = false;
        update u;
         
    }
    
}