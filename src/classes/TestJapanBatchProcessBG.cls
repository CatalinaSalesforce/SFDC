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
private class TestJapanBatchProcessBG {

    private static final String accountRTID = [SELECT ID FROM RecordType Where Name = 'Manufacturing' and SOBJECTTYPE = 'Account'][0].Id;
    private static final String rtID = [SELECT ID FROM RecordType Where Name = 'CONTRACT JAPAN' and SOBJECTTYPE = 'Opportunity'][0].Id;
    private static final String profileID = [Select ID From Profile Where Name =: 'Japan Administrator' Limit 1][0].Id;
    private static final String srbgRTID = [SELECT ID FROM RecordType Where Name = 'Japan' and SOBJECTTYPE = 'Sales_Rep_Best_Guess__c'][0].Id;
    private static final String mbgRTID = [SELECT ID FROM RecordType Where Name = 'Japan' and SOBJECTTYPE = 'Manager_Best_Guess__c'][0].Id;
    
    static testMethod void testBatchJapanDeleteSalesRepBestGuess() {
        // TO DO: implement unit test\
        // TO DO: implement unit test
        Catalina_Forecast_Settings__c settings = getCatalinaForecastSettingsRecord();
        Renewal_Settings__c settings1 = getRenewalSettingsRecord();        
        User testEVP = getUserTestEVP();
        User testSM1 = getUserTestSM1(testEVP.ID);
        User testSM2 = getUserTestSM2(testSM1.ID);
        User testSR1 = getUserTestSR1(testSM2.ID);
        User testSR2 = getUserTestSR2(testSR1.ID);
        
        Manager_Best_Guess__c mbg = new Manager_Best_Guess__c();
        mbg.OwnerId = testEVP.Id;
        mbg.Quarter__c = 'Q12012';
        mbg.RecordTypeId = mbgRTID;
        insert mbg;
        
        Manager_Best_Guess__c mbg1 = new Manager_Best_Guess__c();
        mbg1.OwnerId = testSM1.Id;
        mbg1.Manager_Best_Guess__c = mbg.Id;
        mbg1.Manager__c = testEVP.Id;
        mbg1.Use_Override__c = true;
        mbg1.Override_Team_Manu_Base_High__c = 1;
        mbg1.Quarter__c = 'Q22012';
        mbg1.RecordTypeId = mbgRTID;
        insert mbg1;
        
        Manager_Best_Guess__c mbg1b = new Manager_Best_Guess__c();
        mbg1b.OwnerId = testSM1.Id;
        mbg1b.Manager_Best_Guess__c = mbg.Id;
        mbg1b.Manager__c = testEVP.Id;
        mbg1b.Use_Override__c = true;
        mbg1b.Quarter__c = 'Q32012';
        mbg1b.RecordTypeId = mbgRTID;
        insert mbg1b;
        
        Manager_Best_Guess__c mbg2 = new Manager_Best_Guess__c();
        mbg2.Manager_Best_Guess__c = mbg1.Id;
        mbg2.OwnerId = testSM2.Id;
        mbg2.Manager__c = testSM1.Id;
        mbg2.Override_Team_Manu_Audience_Best_Guess__c = 100000;
        mbg2.Use_Override__c = true;
        mbg2.Override_Team_Manu_Base_High__c = 1;
        mbg2.Quarter__c = 'Q42012';
        mbg2.RecordTypeId = mbgRTID;
        insert mbg2;
        
        Manager_Best_Guess__c mbg2b = new Manager_Best_Guess__c();
        mbg2b.Manager_Best_Guess__c = mbg1.Id;
        mbg2b.OwnerId = testSM2.Id;
        mbg2b.Manager__c = testSM1.Id;
        mbg2b.Use_Override__c = true;
        mbg2b.Quarter__c = 'Q12012';
        mbg2b.RecordTypeId = mbgRTID;
        insert mbg2b;
        
        Manager_Best_Guess__c mbg3 = new Manager_Best_Guess__c();
        mbg3.Manager_Best_Guess__c = mbg2.Id;
        mbg3.OwnerId = testSR1.Id;
        mbg3.Manager__c = testSM2.Id;
        mbg3.Override_Team_Manu_Audience_Low__c = 100000;
        mbg3.Use_Override__c = true;
        mbg3.Override_Team_Manu_Base_High__c = 1;
        mbg3.Quarter__c = 'Q22012';
        mbg3.RecordTypeId = mbgRTID;
        insert mbg3;
        
        Manager_Best_Guess__c mbg3b = new Manager_Best_Guess__c();
        mbg3b.Manager_Best_Guess__c = mbg2.Id;
        mbg3b.OwnerId = testSR1.Id;
        mbg3b.Manager__c = testSM2.Id;
        mbg3b.Use_Override__c = true;
        mbg3b.Quarter__c = 'Q32012';
        mbg3b.RecordTypeId = mbgRTID;
        insert mbg3b;
        
        Manager_Best_Guess__c mbg4 = new Manager_Best_Guess__c();
        mbg4.Manager_Best_Guess__c = mbg3.Id;
        mbg4.OwnerId = testSR2.Id;
        mbg4.Manager__c = testSR1.Id;
        mbg4.Override_Team_Manu_Audience_Low__c = 100000;
        mbg4.Use_Override__c = true;
        mbg4.Override_Team_Manu_Base_High__c = 1;
        mbg4.Quarter__c = 'Q42012';
        mbg4.RecordTypeId = mbgRTID;
        insert mbg4;
        
        Manager_Best_Guess__c mbg4b = new Manager_Best_Guess__c();
        mbg4b.Manager_Best_Guess__c = mbg3.Id;
        mbg4b.OwnerId = testSR2.Id;
        mbg4b.Manager__c = testSR1.Id;
        mbg4b.Use_Override__c = true;
        mbg4b.Quarter__c = 'Q12012';
        mbg4b.RecordTypeId = mbgRTID;
        insert mbg4b;
        
        Sales_Rep_Best_Guess__c srbg1 = new Sales_Rep_Best_Guess__c();
        srbg1.Manager_Best_Guess__c = mbg.Id;
        srbg1.OwnerId = testSR2.Id;
        srbg1.Manager__c = testSR2.Id;
        srbg1.Retail_Digital_Best_Guess__c = 29;
        srbg1.Quarter__c = 'Q12012';
        srbg1.RecordTypeId = srbgRTID;
        insert srbg1;
        
        Test.startTest();
        BatchJapanDeleteSalesRepBestGuess u = new BatchJapanDeleteSalesRepBestGuess('2012');
        Database.executeBatch(u, 400);
        String sch = '0 0 23 * * ?'; 
        system.schedule('BatchJapanRecalculateBestGuess', sch, u);
        Test.stopTest();
    }
    
    static testMethod void testBatchJapanRealignSalesRepBestGuess() {
        // TO DO: implement unit test\
        // TO DO: implement unit test
        Catalina_Forecast_Settings__c settings = getCatalinaForecastSettingsRecord();
        Renewal_Settings__c settings1 = getRenewalSettingsRecord();        
        User testEVP = getUserTestEVP();
        User testSM1 = getUserTestSM1(testEVP.ID);
        User testSM2 = getUserTestSM2(testSM1.ID);
        User testSR1 = getUserTestSR1(testSM2.ID);
        User testSR2 = getUserTestSR2(testSR1.ID);
        
        Manager_Best_Guess__c mbg = new Manager_Best_Guess__c();
        mbg.OwnerId = testEVP.Id;
        mbg.Quarter__c = 'Q12012';
        mbg.RecordTypeId = mbgRTID;
        insert mbg;
        
        Manager_Best_Guess__c mbg1 = new Manager_Best_Guess__c();
        mbg1.OwnerId = testSM1.Id;
        mbg1.Manager_Best_Guess__c = mbg.Id;
        mbg1.Manager__c = testEVP.Id;
        mbg1.Use_Override__c = true;
        mbg1.Override_Team_Manu_Base_High__c = 1;
        mbg1.Quarter__c = 'Q22012';
        mbg1.RecordTypeId = mbgRTID;
        insert mbg1;
        
        Manager_Best_Guess__c mbg1b = new Manager_Best_Guess__c();
        mbg1b.OwnerId = testSM1.Id;
        mbg1b.Manager_Best_Guess__c = mbg.Id;
        mbg1b.Manager__c = testEVP.Id;
        mbg1b.Use_Override__c = true;
        mbg1b.Quarter__c = 'Q32012';
        mbg1b.RecordTypeId = mbgRTID;
        insert mbg1b;
        
        Manager_Best_Guess__c mbg2 = new Manager_Best_Guess__c();
        mbg2.Manager_Best_Guess__c = mbg1.Id;
        mbg2.OwnerId = testSM2.Id;
        mbg2.Manager__c = testSM1.Id;
        mbg2.Override_Team_Manu_Audience_Best_Guess__c = 100000;
        mbg2.Use_Override__c = true;
        mbg2.Override_Team_Manu_Base_High__c = 1;
        mbg2.Quarter__c = 'Q42012';
        mbg2.RecordTypeId = mbgRTID;
        insert mbg2;
        
        Manager_Best_Guess__c mbg2b = new Manager_Best_Guess__c();
        mbg2b.Manager_Best_Guess__c = mbg1.Id;
        mbg2b.OwnerId = testSM2.Id;
        mbg2b.Manager__c = testSM1.Id;
        mbg2b.Use_Override__c = true;
        mbg2b.Quarter__c = 'Q12012';
        mbg2b.RecordTypeId = mbgRTID;
        insert mbg2b;
        
        Manager_Best_Guess__c mbg3 = new Manager_Best_Guess__c();
        mbg3.Manager_Best_Guess__c = mbg2.Id;
        mbg3.OwnerId = testSR1.Id;
        mbg3.Manager__c = testSM2.Id;
        mbg3.Override_Team_Manu_Audience_Low__c = 100000;
        mbg3.Use_Override__c = true;
        mbg3.Override_Team_Manu_Base_High__c = 1;
        mbg3.Quarter__c = 'Q22012';
        mbg3.RecordTypeId = mbgRTID;
        insert mbg3;
        
        Manager_Best_Guess__c mbg3b = new Manager_Best_Guess__c();
        mbg3b.Manager_Best_Guess__c = mbg2.Id;
        mbg3b.OwnerId = testSR1.Id;
        mbg3b.Manager__c = testSM2.Id;
        mbg3b.Use_Override__c = true;
        mbg3b.Quarter__c = 'Q32012';
        mbg3b.RecordTypeId = mbgRTID;
        insert mbg3b;
        
        Manager_Best_Guess__c mbg4 = new Manager_Best_Guess__c();
        mbg4.Manager_Best_Guess__c = mbg3.Id;
        mbg4.OwnerId = testSR2.Id;
        mbg4.Manager__c = testSR1.Id;
        mbg4.Override_Team_Manu_Audience_Low__c = 100000;
        mbg4.Use_Override__c = true;
        mbg4.Override_Team_Manu_Base_High__c = 1;
        mbg4.Quarter__c = 'Q42012';
        mbg4.RecordTypeId = mbgRTID;
        insert mbg4;
        
        Manager_Best_Guess__c mbg4b = new Manager_Best_Guess__c();
        mbg4b.Manager_Best_Guess__c = mbg3.Id;
        mbg4b.OwnerId = testSR2.Id;
        mbg4b.Manager__c = testSR1.Id;
        mbg4b.Use_Override__c = true;
        mbg4b.Quarter__c = 'Q12012';
        mbg4b.RecordTypeId = mbgRTID;
        insert mbg4b;
        
        Sales_Rep_Best_Guess__c srbg1 = new Sales_Rep_Best_Guess__c();
        srbg1.Manager_Best_Guess__c = mbg4B.Id;
        srbg1.OwnerId = testSR2.Id;
        srbg1.Manager__c = testSM1.Id;
        srbg1.Retail_Digital_Best_Guess__c = 29;
        srbg1.Quarter__c = 'Q12012';
        srbg1.RecordTypeId = srbgRTID;
        insert srbg1;
        
        Test.startTest();
        BatchJapanRealignSalesRepBestGuess u = new BatchJapanRealignSalesRepBestGuess();
        Database.executeBatch(u, 400);
        String sch = '0 0 23 * * ?'; 
        system.schedule('BatchJapanRecalculateBestGuess', sch, u);
        Test.stopTest();
    }
    
    static testMethod void testBatchJapanRealignManagerBestGuess() {
        // TO DO: implement unit test\
        // TO DO: implement unit test
        Catalina_Forecast_Settings__c settings = getCatalinaForecastSettingsRecord();
        Renewal_Settings__c settings1 = getRenewalSettingsRecord();        
        User testEVP = getUserTestEVP();
        User testSM1 = getUserTestSM1(testEVP.ID);
        User testSM2 = getUserTestSM2(testSM1.ID);
        User testSR1 = getUserTestSR1(testSM2.ID);
        User testSR2 = getUserTestSR2(testSR1.ID);
        
        Manager_Best_Guess__c mbg = new Manager_Best_Guess__c();
        mbg.OwnerId = testEVP.Id;
        mbg.Quarter__c = 'Q12012';
        mbg.RecordTypeId = mbgRTID;
        insert mbg;
        
        Manager_Best_Guess__c mbg1 = new Manager_Best_Guess__c();
        mbg1.OwnerId = testSM1.Id;
        mbg1.Manager_Best_Guess__c = mbg.Id;
        mbg1.Manager__c = testEVP.Id;
        mbg1.Use_Override__c = true;
        mbg1.Override_Team_Manu_Base_High__c = 1;
        mbg1.Quarter__c = 'Q22012';
        mbg1.RecordTypeId = mbgRTID;
        insert mbg1;
        
        Manager_Best_Guess__c mbg1b = new Manager_Best_Guess__c();
        mbg1b.OwnerId = testSM1.Id;
        mbg1b.Manager_Best_Guess__c = mbg.Id;
        mbg1b.Manager__c = testEVP.Id;
        mbg1b.Use_Override__c = true;
        mbg1b.Quarter__c = 'Q32012';
        mbg1b.RecordTypeId = mbgRTID;
        insert mbg1b;
        
        Manager_Best_Guess__c mbg2 = new Manager_Best_Guess__c();
        mbg2.Manager_Best_Guess__c = mbg1.Id;
        mbg2.OwnerId = testSM2.Id;
        mbg2.Manager__c = testSM1.Id;
        mbg2.Override_Team_Manu_Audience_Best_Guess__c = 100000;
        mbg2.Use_Override__c = true;
        mbg2.Override_Team_Manu_Base_High__c = 1;
        mbg2.Quarter__c = 'Q42012';
        mbg2.RecordTypeId = mbgRTID;
        insert mbg2;
        
        Manager_Best_Guess__c mbg2b = new Manager_Best_Guess__c();
        mbg2b.Manager_Best_Guess__c = mbg1.Id;
        mbg2b.OwnerId = testSM2.Id;
        mbg2b.Manager__c = testSM1.Id;
        mbg2b.Use_Override__c = true;
        mbg2b.Quarter__c = 'Q12012';
        mbg2b.RecordTypeId = mbgRTID;
        insert mbg2b;
        
        Manager_Best_Guess__c mbg3 = new Manager_Best_Guess__c();
        mbg3.Manager_Best_Guess__c = mbg2.Id;
        mbg3.OwnerId = testSR1.Id;
        mbg3.Manager__c = testSM2.Id;
        mbg3.Override_Team_Manu_Audience_Low__c = 100000;
        mbg3.Use_Override__c = true;
        mbg3.Override_Team_Manu_Base_High__c = 1;
        mbg3.Quarter__c = 'Q22012';
        mbg3.RecordTypeId = mbgRTID;
        insert mbg3;
        
        Manager_Best_Guess__c mbg3b = new Manager_Best_Guess__c();
        mbg3b.Manager_Best_Guess__c = mbg2.Id;
        mbg3b.OwnerId = testSR1.Id;
        mbg3b.Manager__c = testSM2.Id;
        mbg3b.Use_Override__c = true;
        mbg3b.Quarter__c = 'Q32012';
        mbg3b.RecordTypeId = mbgRTID;
        insert mbg3b;
        
        Manager_Best_Guess__c mbg4 = new Manager_Best_Guess__c();
        mbg4.Manager_Best_Guess__c = mbg3.Id;
        mbg4.OwnerId = testSR2.Id;
        mbg4.Manager__c = testSR1.Id;
        mbg4.Override_Team_Manu_Audience_Low__c = 100000;
        mbg4.Use_Override__c = true;
        mbg4.Override_Team_Manu_Base_High__c = 1;
        mbg4.Quarter__c = 'Q42012';
        mbg4.RecordTypeId = mbgRTID;
        insert mbg4;
        
        Manager_Best_Guess__c mbg4b = new Manager_Best_Guess__c();
        mbg4b.Manager_Best_Guess__c = mbg3.Id;
        mbg4b.OwnerId = testSR2.Id;
        mbg4b.Manager__c = testSR1.Id;
        mbg4b.Use_Override__c = true;
        mbg4b.Quarter__c = 'Q12012';
        mbg4b.RecordTypeId = mbgRTID;
        insert mbg4b;
        
        Sales_Rep_Best_Guess__c srbg1 = new Sales_Rep_Best_Guess__c();
        srbg1.Manager_Best_Guess__c = mbg4B.Id;
        srbg1.OwnerId = testSR2.Id;
        srbg1.Manager__c = testSM1.Id;
        srbg1.Retail_Digital_Best_Guess__c = 29;
        srbg1.Quarter__c = 'Q12012';
        srbg1.RecordTypeId = srbgRTID;
        insert srbg1;
        
        Test.startTest();
        BatchJapanRealignManagerBestGuess u = new BatchJapanRealignManagerBestGuess();
        Database.executeBatch(u, 400);
        String sch = '0 0 23 * * ?'; 
        system.schedule('BatchJapanRecalculateBestGuess', sch, u);
        Test.stopTest();
    }
    
    static testMethod void testBatchJapanCreateBestGuess() {
        // TO DO: implement unit test\
        // TO DO: implement unit test
        Catalina_Forecast_Settings__c settings = getCatalinaForecastSettingsRecord();
        Renewal_Settings__c settings1 = getRenewalSettingsRecord();        
        User testEVP = getUserTestEVP();
        User testSM1 = getUserTestSM1(testEVP.ID);
        User testSM2 = getUserTestSM2(testSM1.ID);
        User testSR1 = getUserTestSR1(testSM2.ID);
        User testSR2 = getUserTestSR2(testSR1.ID);
        
        Test.startTest();
        BatchJapanCreateBGShell u = new BatchJapanCreateBGShell();
        Database.executeBatch(u, 400);
        String sch = '0 0 23 * * ?'; 
        system.schedule('BatchJapanRecalculateBestGuess', sch, u);
        Test.stopTest();
    }
    
    static testMethod void testBatchJapanCalculateBestGuess() {
        // TO DO: implement unit test\
        // TO DO: implement unit test
        Catalina_Forecast_Settings__c settings = getCatalinaForecastSettingsRecord();
        Renewal_Settings__c settings1 = getRenewalSettingsRecord();        
        User testEVP = getUserTestEVP();
        User testSM1 = getUserTestSM1(testEVP.ID);
        User testSM2 = getUserTestSM2(testSM1.ID);
        User testSR1 = getUserTestSR1(testSM2.ID);
        User testSR2 = getUserTestSR2(testSR1.ID);
        
        Account a = getAccount();
        Opportunity o = getOpportunity(testSR2.ID,a.ID);
        Ad_Period__c ap1 = getAp1();
        Ad_Period__c ap2 = getAp2();
        Ad_Period__c ap3 = getAp3();
        Program__c p = getProgram(o.Name,o.ID,ap1.ID,ap2.ID);
        
        Program_Forecast__c pForecast = new Program_Forecast__c();
        pForecast.Active__c = True;
        pForecast.Actual_Amount__c = 1877702;
        pForecast.Ad_Period__c = ap1.Id;
        pForecast.Program__c = p.Id;
        pForecast.Previous_Quarter_Amount__c = 50000;
        pForecast.Next_Quarter_Amount__c = 1300000;
        pForecast.Forecast_Amount__c = 120000;
        pForecast.Previous_Quarter_Actual__c = 49000;
        pForecast.Next_Quarter_Actual__c = 1350000;
        insert pForecast;
        
        Manager_Best_Guess__c mbg = new Manager_Best_Guess__c();
        mbg.OwnerId = testEVP.Id;
        mbg.Quarter__c = 'Q12012';
        mbg.RecordTypeId = mbgRTID;
        insert mbg;
        
        Manager_Best_Guess__c mbg1 = new Manager_Best_Guess__c();
        mbg1.OwnerId = testSM1.Id;
        mbg1.Manager_Best_Guess__c = mbg.Id;
        mbg1.Manager__c = testEVP.Id;
        mbg1.Use_Override__c = true;
        mbg1.Override_Team_Manu_Base_High__c = 1;
        mbg1.Quarter__c = 'Q22012';
        mbg1.RecordTypeId = mbgRTID;
        insert mbg1;
        
        Manager_Best_Guess__c mbg1b = new Manager_Best_Guess__c();
        mbg1b.OwnerId = testSM1.Id;
        mbg1b.Manager_Best_Guess__c = mbg.Id;
        mbg1b.Manager__c = testEVP.Id;
        mbg1b.Use_Override__c = true;
        mbg1b.Quarter__c = 'Q32012';
        mbg1b.RecordTypeId = mbgRTID;
        insert mbg1b;
        
        Manager_Best_Guess__c mbg2 = new Manager_Best_Guess__c();
        mbg2.Manager_Best_Guess__c = mbg1.Id;
        mbg2.OwnerId = testSM2.Id;
        mbg2.Manager__c = testSM1.Id;
        mbg2.Override_Team_Manu_Audience_Best_Guess__c = 100000;
        mbg2.Use_Override__c = true;
        mbg2.Override_Team_Manu_Base_High__c = 1;
        mbg2.Quarter__c = 'Q42012';
        mbg2.RecordTypeId = mbgRTID;
        insert mbg2;
        
        Manager_Best_Guess__c mbg2b = new Manager_Best_Guess__c();
        mbg2b.Manager_Best_Guess__c = mbg1.Id;
        mbg2b.OwnerId = testSM2.Id;
        mbg2b.Manager__c = testSM1.Id;
        mbg2b.Use_Override__c = true;
        mbg2b.Quarter__c = 'Q12012';
        mbg2b.RecordTypeId = mbgRTID;
        insert mbg2b;
        
        Manager_Best_Guess__c mbg3 = new Manager_Best_Guess__c();
        mbg3.Manager_Best_Guess__c = mbg2.Id;
        mbg3.OwnerId = testSR1.Id;
        mbg3.Manager__c = testSM2.Id;
        mbg3.Override_Team_Manu_Audience_Low__c = 100000;
        mbg3.Use_Override__c = true;
        mbg3.Override_Team_Manu_Base_High__c = 1;
        mbg3.Quarter__c = 'Q22012';
        mbg3.RecordTypeId = mbgRTID;
        insert mbg3;
        
        Manager_Best_Guess__c mbg3b = new Manager_Best_Guess__c();
        mbg3b.Manager_Best_Guess__c = mbg2.Id;
        mbg3b.OwnerId = testSR1.Id;
        mbg3b.Manager__c = testSM2.Id;
        mbg3b.Use_Override__c = true;
        mbg3b.Quarter__c = 'Q32012';
        mbg3b.RecordTypeId = mbgRTID;
        insert mbg3b;
        
        Manager_Best_Guess__c mbg4 = new Manager_Best_Guess__c();
        mbg4.Manager_Best_Guess__c = mbg3.Id;
        mbg4.OwnerId = testSR2.Id;
        mbg4.Manager__c = testSR1.Id;
        mbg4.Override_Team_Manu_Audience_Low__c = 100000;
        mbg4.Use_Override__c = true;
        mbg4.Override_Team_Manu_Base_High__c = 1;
        mbg4.Quarter__c = 'Q42012';
        mbg4.RecordTypeId = mbgRTID;
        insert mbg4;
        
        Manager_Best_Guess__c mbg4b = new Manager_Best_Guess__c();
        mbg4b.Manager_Best_Guess__c = mbg3.Id;
        mbg4b.OwnerId = testSR2.Id;
        mbg4b.Manager__c = testSR1.Id;
        mbg4b.Use_Override__c = true;
        mbg4b.Quarter__c = 'Q12012';
        mbg4b.RecordTypeId = mbgRTID;
        insert mbg4b;
        
        Sales_Rep_Best_Guess__c srbg1 = new Sales_Rep_Best_Guess__c();
        srbg1.Manager_Best_Guess__c = mbg4B.Id;
        srbg1.OwnerId = testSR2.Id;
        srbg1.Manager__c = testSM1.Id;
        srbg1.Retail_Digital_Best_Guess__c = 29;
        srbg1.Quarter__c = 'Q12012';
        srbg1.RecordTypeId = srbgRTID;
        insert srbg1;
        
        Test.startTest();
        BatchJapanCalculateBestGuess u = new BatchJapanCalculateBestGuess();
        Database.executeBatch(u, 400);
        String sch = '0 0 23 * * ?'; 
        system.schedule('BatchJapanRecalculateBestGuess', sch, u);
        Test.stopTest();
    }
    
    /*
    @Name :getCatalinaForecastSettingsRecord
    @Description : Insert Catalina_Forecast_Settings__c test data.
    */
    private static Catalina_Forecast_Settings__c getCatalinaForecastSettingsRecord(){
        Catalina_Forecast_Settings__c settings = new Catalina_Forecast_Settings__c();
        settings.Base_Delivery_Type__c = 'Base';
        settings.Digital_Delivery_Type__c = 'Digital O&O';
        settings.Display_Delivery_Type__c = 'Audience Network';
        settings.Mobile_Delivery_Type__c = 'Mobile';
        settings.Manufacturing_Account_Type__c = 'Manufacturing';
        settings.Retail_Account_Type__c = 'Retail';
        settings.Coop_String__c = 'coop';
        settings.Rep_1_String__c = 'SR1';
        settings.Rep_2_String__c = 'SR2';
        settings.SM_1_String__c = 'SM1';
        settings.SM_2_String__c = 'SM2';
        settings.PFE_Email__c = 'fakeemail@myfakeemailplay.com.fake';
        settings.Name = 'Default';
        insert settings;
        return settings;
    }
    
    /*
    @Name :getUserTestEVP
    @Description : Insert User test data.
    */
    private static User getUserTestEVP(){
        User testEVP = new User();
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
        testEVP.Country__c = 'Japan';
        insert testEVP;
        return testEVP;
    }
    
    /*
    @Name :getUserTestSM1
    @Description : Insert User test data.
    */
    private static User getUserTestSM1(ID testEVP){
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
        testSM1.ManagerId = testEVP;
        testSM1.Country__c = 'Japan';
        insert testSM1;
        return testSM1;
    }
    
    /*
    @Name :getUserTestSM2
    @Description : Insert User test data.
    */
    private static User getUserTestSM2(ID testSM1){
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
        testSM2.ManagerId = testSM1;
        testSM2.Country__c = 'Japan';
        insert testSM2;
        return testSM2;
    }
    
    /*
    @Name :getUserTestSR1
    @Description : Insert User test data.
    */
    private static User getUserTestSR1(ID testSM2){
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
        testSR1.ManagerId = testSM2;
        testSR1.Country__c = 'Japan';
        testSR1.Does_Sell__c = true;
        insert testSR1;
        return testSR1;
    }
    
    /*
    @Name :getUserTestSR2
    @Description : Insert User test data.
    */
    private static User getUserTestSR2(ID testSR1){
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
        testSR2.ManagerId = testSR1;
        testSR2.Country__c = 'Japan';
        testSR2.Does_Sell__c = true;
        insert testSR2;
        return testSR2;
    }
    
    /*
    @Name :getAccount
    @Description : Insert Account test data.
    */
    private static Account getAccount(){
        Account a = new Account();
        a.Name = 'Test Account';
        a.RecordTypeId = accountRTID;
        insert a;
        return a;
    }
    
    /*
    @Name :getOpportunity
    @Description : Insert Opportunity test data.
    */
    private static Opportunity getOpportunity(ID testSR2,ID a){
        Opportunity o = new Opportunity();
        o.OwnerId = testSR2;
        o.AccountId = a;
        o.RecordTypeId = rtID;
        o.Name = 'Test oppty';
        o.StageName = 'Presented';
        o.CloseDate = Date.today();
        insert o;
        return o;
    }
    
    /*
    @Name :getAp1
    @Description : Insert Ad_Period__c test data.
    */
    private static Ad_Period__c getAp1(){
        Ad_Period__c ap1 = new Ad_Period__c();
        ap1.Name = 'C2_CY2012_test';
        ap1.Start_Date__c = Date.valueOf('2012-03-23');
        ap1.End_Date__c = Date.valueOf('2012-05-19');
        ap1.Type__c = 'Manufacturing';
        insert ap1;
        return ap1;
    }
    
    /*
    @Name :getAp2
    @Description : Insert Ad_Period__c test data.
    */
    private static Ad_Period__c getAp2(){
        Ad_Period__c ap2 = new Ad_Period__c();
        ap2.Name = 'C3_CY2012_test';
        ap2.Start_Date__c = Date.valueOf('2012-01-23');
        ap2.End_Date__c = Date.valueOf('2012-02-19');
        ap2.Type__c = 'Manufacturing';
        insert ap2;
        return ap2;
    }
    
    /*
    @Name :getAp3
    @Description : Insert Ad_Period__c test data.
    */
    private static Ad_Period__c getAp3(){
        Ad_Period__c ap3 = new Ad_Period__c();
        ap3.Name = 'C1_CY2012_test';
        ap3.Start_Date__c = Date.valueOf('2012-12-23');
        ap3.End_Date__c = Date.valueOf('2012-01-19');
        ap3.Type__c = 'Manufacturing';
        insert ap3;
        return ap3;
    }
    
    /*
    @Name :getProgram
    @Description : Insert Program__c test data.
    */
    private static Program__c getProgram(String oName,Id o,Id ap1,Id ap2){
        Program__c p = new Program__c();
        p.Name = oName + ' Base';
        p.Opportunity__c = o;
        p.Delivery_Type__c = 'Base';
        p.Product_Type__c = 'Base Product Type1';
        p.Start_Cycle__c = ap1;
        p.End_Cycle__c = ap2;
        insert p;
        return p;
    }
    
    /*
    @Name :getRenewalSettingsRecord
    @Description : Insert getRenewalSettingsRecord test data.
    */
    private static Renewal_Settings__c getRenewalSettingsRecord(){
        Renewal_Settings__c settings = Renewal_Settings__c.getOrgDefaults();
        settings.Renewal_Window_Size__c = 14;
        settings.Percent_Goal__c = 0;
        insert settings;
        return settings;
    }
}