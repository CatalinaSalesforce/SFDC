@isTest
public class Test_UpsertUser{    
    
    // test method for UserUpdateMoveOpps_Trigger trigger
    static testMethod void UserUpdateMoveOpps_Trigger(){
         // TO DO: implement unit test
        String profileID = [Select ID From Profile Where Name =: 'System Administrator' Limit 1][0].Id;
        
        // Create email setting to send email to.
        Admin_Email_Settings__c emailSettings = new Admin_Email_Settings__c();
        emailSettings.Name = 'Default';
        emailSettings.Email_Alert_Address__c = 'salesforceadmin@catalinamarketing.com';
        emailSettings.Email_Alert_For_Sales_User_Added__c = 'salesforceadmin@catalinamarketing.com';
        insert emailSettings;
       
      
        //Insert new user with no forecast role or manager.      
        User u1 = new User();
        u1.Firstname = 'Test';
        u1.LastName = 'User1';
        u1.Username = 'testuser11@unqemail.com';
        u1.Email = 'testuser11@unqemail.com';
        u1.Alias = 'tUsr1uq';
        u1.CommunityNickname = 'tUsr1uq';
        u1.TimeZoneSidKey = 'GMT';
        u1.LocaleSidKey = 'en_US';
        u1.EmailEncodingKey = 'UTF-8';
        u1.LanguageLocaleKey = 'en_US';
        u1.ProfileId = profileID;
        u1.isActive = true;
        insert u1;
        
        //Insert new user with forecast role and no manager.      
        User u2 = new User();
        u2.Firstname = 'Test';
        u2.LastName = 'User2';
        u2.Username = 'testuser22@unqemail.com';
        u2.Email = 'testuser22@unqemail.com';
        u2.Alias = 'tUsr2uq';
        u2.CommunityNickname = 'tUsr2uq';
        u2.TimeZoneSidKey = 'GMT';
        u2.LocaleSidKey = 'en_US';
        u2.EmailEncodingKey = 'UTF-8';
        u2.LanguageLocaleKey = 'en_US';
        u2.ProfileId = profileID;
        u2.isActive = true;
        u2.Forecast_Role__c = 'SR2';
        insert u2;
        
         //Insert new user with forecast role SM1.      
        User uSR1 = new User();
        uSR1.Firstname = 'Test';
        uSR1.LastName = 'UserSR1';
        uSR1.Username = 'testusersr1@unqemail.com';
        uSR1.Email = 'testusersr1@unqemail.com';
        uSR1.Alias = 'tUsruq1';
        uSR1.CommunityNickname = 'tUsruq1';
        uSR1.TimeZoneSidKey = 'GMT';
        uSR1.LocaleSidKey = 'en_US';
        uSR1.EmailEncodingKey = 'UTF-8';
        uSR1.LanguageLocaleKey = 'en_US';
        uSR1.ProfileId = profileID;
        uSR1.isActive = true;
        uSR1.Forecast_Role__c = 'SR1';
        insert uSR1;
        
         //Insert new user with forecast role and manager.      
        User ManagerUser = [Select id,name from User where Forecast_Role__c = 'SR1' Limit 1];
        User u3 = new User();
        u3.Firstname = 'Test';
        u3.LastName = 'User3';
        u3.Username = 'testuser33@unqemail.com';
        u3.Email = 'testuser33@unqemail.com';
        u3.Alias = 'tUsr3uq';
        u3.CommunityNickname = 'tUsr3uq';
        u3.TimeZoneSidKey = 'GMT';
        u3.LocaleSidKey = 'en_US';
        u3.EmailEncodingKey = 'UTF-8';
        u3.LanguageLocaleKey = 'en_US';
        u3.ProfileId = profileID;
        u3.isActive = true;
        u3.Forecast_Role__c = 'SR2';
        u3.ManagerId = ManagerUser.Id;
        insert u3;
        
        u3.Forecast_Role__c = '';
        u3.ManagerId = null;
        update u3;
        
        u3.Forecast_Role__c = 'SR2';
        u3.ManagerId = ManagerUser.Id;
        update u3;
        
        // Test Bulk Update.
        List<User> testUsersList = new List<User>();
        for(integer i=100; i<300; i++) {
            String str = String.ValueOf(i) + 'uq';
            testUsersList.add(new User(Firstname = 'Test', LastName = 'User' + str,Username = 'testuser' + str + '@unqemail.com',Email = 'testuser' + str + '@unqemail.com',Alias = 'tu' + str,CommunityNickname = 'tu' + str,TimeZoneSidKey = 'GMT',LocaleSidKey = 'en_US',EmailEncodingKey = 'UTF-8',LanguageLocaleKey = 'en_US',ProfileId = profileID,Forecast_Role__c = 'SR2',ManagerId = ManagerUser.Id));
        }
        insert testUsersList;
         
    }
    
}