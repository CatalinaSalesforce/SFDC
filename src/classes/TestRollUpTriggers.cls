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
private class TestRollUpTriggers {
    
    static testMethod void myUnitTest2() {
        String profileID = [Select ID From Profile Limit 1][0].Id;
        
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
        
        Sales_Manager_1_Forecast__c newSM1 = new Sales_Manager_1_Forecast__c();
        newSM1.ownerId = testSM1.Id;
        insert newSM1;
        
        Sales_Manager_2_Forecast__c newSM2 = new Sales_Manager_2_Forecast__c();
        newSM2.Manager_Forecast__c = newSM1.Id;
        insert newSM2;
        
        Rep_1_Forecast__c newR1 = new Rep_1_Forecast__c();
        newR1.Manager_Forecast__c = newSM2.Id;
        insert newR1;
        
        Rep_2_Forecast__c newR2 = new Rep_2_Forecast__c();
        newR2.Manager_Forecast__c = newR1.Id;
        newR2.Actual_Amount__c = 1000;
        newR2.Forecast_Contract__c = 1000;
        newR2.Forecast_Proposal__c = 1000;
        newR2.Weighted_Forecast_Proposal__c = 1000;
        insert newR2;
        
        Rep_2_Forecast__c newR2b = new Rep_2_Forecast__c();
        newR2b.Manager_Forecast__c = newR1.Id;
        newR2b.Actual_Amount__c = 1000;
        newR2b.Forecast_Contract__c = 1000;
        newR2b.Forecast_Proposal__c = 1000;
        newR2b.Weighted_Forecast_Proposal__c = 1000;
        insert newR2b;
        
        newR2b.Actual_Amount__c = 500;
        newR2b.Forecast_Contract__c = 500;
        newR2b.Forecast_Proposal__c = 500;
        newR2b.Weighted_Forecast_Proposal__c = 500;
        
        newR2.Actual_Amount__c = 10000;
        newR2.Forecast_Contract__c = 10000;
        newR2.Forecast_Proposal__c = 10000;
        newR2.Weighted_Forecast_Proposal__c = 10000;
        List<Rep_2_Forecast__c> tempList = new List<Rep_2_Forecast__c>();
        tempList.add(newR2);
        tempList.add(newR2b); 
        update tempList;
        
        Rep_1_Forecast__c newR1c = [Select Id, Team_Actual_Amount_Trg__c, Team_Forecast_Contract_Trg__c, Team_Forecast_Proposal_Trg__c, Team_Weighted_Forecast_Proposal_Trg__c From Rep_1_Forecast__c Where Id =: newR1.Id][0];
        system.debug('***R1 Team Actual: ' + newR1c.Team_Actual_Amount_Trg__c);
        system.debug('***R1 Team Actual: ' + newR1c.Team_Forecast_Contract_Trg__c);
        system.debug('***R1 Team Actual: ' + newR1c.Team_Forecast_Proposal_Trg__c);
        system.debug('***R1 Team Actual: ' + newR1c.Team_Weighted_Forecast_Proposal_Trg__c);
        
        Sales_Manager_2_Forecast__c newSM2c = [Select Id, Team_Actual_Amount_Trg__c, Team_Forecast_Contract_Trg__c, Team_Forecast_Proposal_Trg__c, Team_Weighted_Forecast_Proposal_Trg__c From Sales_Manager_2_Forecast__c Where Id =: newSM2.Id][0];
        system.debug('***SM2 Team Actual: ' + newSM2c.Team_Actual_Amount_Trg__c);
        system.debug('***SM2 Team Actual: ' + newSM2c.Team_Forecast_Contract_Trg__c);
        system.debug('***SM2 Team Actual: ' + newSM2c.Team_Forecast_Proposal_Trg__c);
        system.debug('***SM2 Team Actual: ' + newSM2c.Team_Weighted_Forecast_Proposal_Trg__c);
        
        Sales_Manager_1_Forecast__c newSM1c = [Select Id, Team_Actual_Amount_Trg__c, Team_Forecast_Contract_Trg__c, Team_Forecast_Proposal_Trg__c, Team_Weighted_Forecast_Proposal_Trg__c From Sales_Manager_1_Forecast__c Where Id =: newSM1.Id][0];
        system.debug('***SM1 Team Actual: ' + newSM1c.Team_Actual_Amount_Trg__c);
        system.debug('***SM1 Team Actual: ' + newSM1c.Team_Forecast_Contract_Trg__c);
        system.debug('***SM1 Team Actual: ' + newSM1c.Team_Forecast_Proposal_Trg__c);
        system.debug('***SM1 Team Actual: ' + newSM1c.Team_Weighted_Forecast_Proposal_Trg__c);
    }
    
}