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
private class TestAccountBestGuessSummary{
   
    /*//test method for AccountBestGuessSummaryRollUpController class.
    private static testmethod void TestAccountBestGuessSummaryRollUpController(){
        //get the user record to avoid NPE from AssignAccountOwner trigger
        User u = getUserRecord();
        //get the account record
        Account acc = getAccountRecord();
        //get the conlomerate record
        Conglomerate_Account_Best_Guess_Summary__c cbg = getConglomerateAccountBestGuess(acc.ID);
        //assertions
        System.assertEquals(null, [SELECT Q1__c FROM Conglomerate_Account_Best_Guess_Summary__c WHERE Id = :cbg.Id].Q1__c);
        System.assertEquals(null, [SELECT Q2__c FROM Conglomerate_Account_Best_Guess_Summary__c WHERE Id = :cbg.Id].Q2__c);
        System.assertEquals(null, [SELECT Q3__c FROM Conglomerate_Account_Best_Guess_Summary__c WHERE Id = :cbg.Id].Q3__c);
        //get the account best guess summary record
        Account_Best_Guess_Summary__c abgs = getAccountBestGuessSummary(acc.ID, cbg.ID);
        //assertions
        System.assertEquals(100, [SELECT Q1__c FROM Conglomerate_Account_Best_Guess_Summary__c WHERE Id = :cbg.Id].Q1__c);
        System.assertNotEquals(100, [SELECT Q2__c FROM Conglomerate_Account_Best_Guess_Summary__c WHERE Id = :cbg.Id].Q2__c);
        System.assertEquals(300, [SELECT Q3__c FROM Conglomerate_Account_Best_Guess_Summary__c WHERE Id = :cbg.Id].Q3__c);
        //run the test now
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.standardController(acc);
        AccountBestGuessSummaryRollUpController abg = new AccountBestGuessSummaryRollUpController(sc);
        Test.stopTest();
        //stop the test now
    }*/
   
    //test method for AccountBestGuessSummaryController class.
    private static testmethod void TestAccountBestGuessSummaryController(){
        //get the user record to avoid NPE from AssignAccountOwner trigger
        User u = getUserRecord();
        //get the account record
        Account acc = getAccountRecord();
        //get the conlomerate record
        Conglomerate_Account_Best_Guess_Summary__c cbg = getConglomerateAccountBestGuess(acc.ID);
        //get the account best guess summary record
        Account_Best_Guess_Summary__c abgs = getAccountBestGuessSummary(acc.ID, cbg.ID);
        //get the historical account best guess summary record
        Historical_Account_Best_Guess_Summary__c hbgs = getHistoricalAccountBestGuess(acc.ID);
        //run the test now
        Test.startTest();
        //create a standard controller
        ApexPages.StandardController sc = new ApexPages.standardController(acc);
        //set the current page parameter
        ApexPages.currentPage().getParameters().put('id', acc.Id);
        AccountBestGuessSummaryController abg = new AccountBestGuessSummaryController(sc);
        //assertions
        System.assertEquals('Total', abg.selected);
        System.assertEquals('2012', [SELECT Year__c FROM Account_Best_Guess_Summary__c WHERE Id = :abgs.Id].Year__c);
        System.assertEquals(0, [SELECT count() FROM Account_Best_Guess_Summary__c WHERE Id = :abgs.Id and Delivery_Channel__c=:abg.selected]);
        abg.getManCommentField();
        abg.getCommentsList();
        abg.saveBestGuess();
        //change the delivery channel to base
        abg.selected = 'Base';
        //assertions
        System.assertEquals('Base', abg.selected);
        System.assertEquals('Base', [SELECT Delivery_Channel__c FROM Account_Best_Guess_Summary__c WHERE Id = :abgs.Id].Delivery_Channel__c);
        System.assertEquals('2012', [SELECT Year__c FROM Account_Best_Guess_Summary__c WHERE Id = :abgs.Id].Year__c);
        abg.getDeliveryChannel();
        abg.search();
        System.assertEquals(1, [SELECT count() FROM Account_Best_Guess_Summary__c WHERE Id = :abgs.Id and Delivery_Channel__c=:abg.selected]);
        Test.stopTest();
        //stop the test now
    }
    
    //test method for AccountBestGuessSummaryController class to cover msgDisplay method code
    private static testmethod void TestAccountBestGuessSummaryControllerMsgDisplay(){
        //get the user record to avoid NPE from AssignAccountOwner trigger
        User u = getUserRecord();
        //get the account record
        Account acc = getAccountRecord2();
        //run the test now
        Test.startTest();
        //create a standard controller
        ApexPages.StandardController sc = new ApexPages.standardController(acc);
        //set the current page parameters
        ApexPages.currentPage().getParameters().put('id', acc.Id);
        AccountBestGuessSummaryController abg = new AccountBestGuessSummaryController(sc);
        //assertions
        System.assertEquals(0, [SELECT count() FROM Account_Best_Guess_Summary__c]);
        abg.getCommentsList();
        abg.saveBestGuess();
        abg.search();
        Test.stopTest();
        //stop the test now
    }
    
    //test method for AccountBestGuessSummaryController class to cover code where delivery channel is not All.
    private static testmethod void TestAccountBestGuessSummaryControllerChannel(){
        //get the user record to avoid NPE from AssignAccountOwner trigger
        User u = getUserRecord();
        //get the account record
        Account acc = getAccountRecord2();
        //get the conlomerate record
        Conglomerate_Account_Best_Guess_Summary__c cbg = getConglomerateAccountBestGuess(acc.ID);
        //get the account best guess summary record
        Account_Best_Guess_Summary__c abgs = getAccountBestGuessSummary(acc.ID, cbg.ID);
        //get the historical account best guess summary record
        Historical_Account_Best_Guess_Summary__c hbgs = getHistoricalAccountBestGuess(acc.ID);
        //run the test now
        Test.startTest();
        //create a standard controller
        ApexPages.StandardController sc = new ApexPages.standardController(acc);
        //set the current page parameters
        ApexPages.currentPage().getParameters().put('id', acc.Id);
        AccountBestGuessSummaryController abg = new AccountBestGuessSummaryController(sc);
        abg.getCommentsList();
        //assertions
        System.assertEquals('Total', abg.selected);
        System.assertEquals('Base', [SELECT Delivery_Channel__c FROM Account_Best_Guess_Summary__c WHERE Id = :abgs.Id].Delivery_Channel__c);
        System.assertEquals('2012', [SELECT Year__c FROM Account_Best_Guess_Summary__c WHERE Id = :abgs.Id].Year__c);
        abg.selected = 'Base';
        System.assertEquals('Base', abg.selected);
        abg.search();
        System.assertEquals(1, [SELECT count() FROM Account_Best_Guess_Summary__c WHERE Id = :abgs.Id and Delivery_Channel__c=:abg.selected]);
        abg.saveBestGuess();
        Test.stopTest();
    }
    
    //prepare the test conglomerate account record
    private static Account getAccountRecord(){
        Account acc = new Account(Name = 'TestCase', Type = 'Conglomerate', OwnerId=UserInfo.getUserId());
        insert acc;
        return acc;
    }
    
    //prepare the test Conglomerate Account Best Guess Summary record
    private static Conglomerate_Account_Best_Guess_Summary__c getConglomerateAccountBestGuess(id accID){
        Conglomerate_Account_Best_Guess_Summary__c cbg = new Conglomerate_Account_Best_Guess_Summary__c(Account__c = accID, Year__c = '2012');
        insert cbg;
        return cbg;
    }
    
    //prepare the test Account Best Guess Summary record
    private static Account_Best_Guess_Summary__c getAccountBestGuessSummary(id accID, id cbgID){
        Account_Best_Guess_Summary__c abgs = new Account_Best_Guess_Summary__c(Account__c = accID,Conglomerate_Account_Best_Guess_Summary__c = cbgID, 
        Year__c = '2012',Q1__c = 100,Q2__c = 200,Q3__c = 300,Q4__c = 400,Booked_Q1__c = 22,Booked_Q2__c = 11,Booked_Q3__c  = 12,Booked_Q4__c  = 23, 
        Full_Proposal_Q1__c = 45,Full_Proposal_Q2__c = 46,Full_Proposal_Q3__c = 30,Full_Proposal_Q4__c = 50,Wgt_Proposal_Q1__c = 23,
        Wgt_Proposal_Q2__c = 90,Wgt_Proposal_Q3__c = 24,Wgt_Proposal_Q4__c = 60,Delivery_Channel__c = 'Base');
        insert abgs;
        return abgs;
    }
    
    //prepare the test Historical Account Best Guess Summary record
    private static Historical_Account_Best_Guess_Summary__c getHistoricalAccountBestGuess(id accID){
        Historical_Account_Best_Guess_Summary__c hbgs = new Historical_Account_Best_Guess_Summary__c(Account__c = accID,Year__c = '2012', 
        Q1__c = 100,Q2__c = 100,Q3__c = 50,Q4__c = 50,Booked_Q1__c = 22,Booked_Q2__c = 11,Booked_Q3__c  = 12,Booked_Q4__c  = 23,
        Delivery_Channel__c = 'Base');
        insert hbgs;
        return hbgs;
    }
    
    //prepare the test non conglomerate account record
    private static Account getAccountRecord2(){
        Account acc = new Account(Name = 'TestCase', OwnerId=UserInfo.getUserId());
        insert acc;
        return acc;
    }
    
    //prepare the user record to avoid NPE exception from AssignAccountOwner trigger. 
    private static User getUserRecord(){
        User test = new User();
        test.FirstName = 'test';
        test.LastName = 'usr';
        test.Forecast_Role__c = 'usr';
        test.Email = 'testusr@catalinamarketing.com.testuser';
        test.Username = 'testusr@catalinamarketing.com.testuser';
        test.Alias = 'testusr';
        test.CommunityNickname = 'testusr';
        test.TimeZoneSidKey = 'GMT';
        test.LocaleSidKey = 'en_US';
        test.EmailEncodingKey = 'UTF-8';
        test.LanguageLocaleKey = 'en_US';
        test.ExtID__c = 'jegasti';
        test.ProfileId = [Select ID From Profile Where Name =: 'System Administrator' Limit 1][0].Id;
        insert test;
        return test;
    }   
}