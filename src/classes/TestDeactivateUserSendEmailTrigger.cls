@isTest
public class TestDeactivateUserSendEmailTrigger{  
        
        static testMethod void SendEmailTrigger(){
         // TO DO: implement unit test
        String profileID = [Select ID From Profile Where Name =: 'System Administrator' Limit 1][0].Id;
              
        User u = new User();
        u.Firstname = 'New';
        u.LastName = 'User Test';
        u.Username = 'NewUserTest@test.com';
        u.Email = 'NewUserTest@test.com';
        u.Alias = 'newuser';
        u.CommunityNickname = 'newuser';
        u.TimeZoneSidKey = 'GMT';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.ProfileId = profileID;
        u.isActive = true;
        insert u;
        
         
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];  
        System.runAs ( thisUser ) {  
            Admin_Email_Settings__c emailSettings = new Admin_Email_Settings__c();
            emailSettings.Name = 'Default';
            emailSettings.Email_Alert_Address__c = 'salesforceadmin@catalinamarketing.com';
            insert emailSettings;
        }
        
        u.isActive = false; 
        update u;
         
    }
    
}