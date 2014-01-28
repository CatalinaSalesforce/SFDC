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
private class TestSummarizeAccBG {
    
     static testMethod void testBatchSummarizeAccBGSR2() {
         // TO DO: implement unit test
         Account a = getParentAccountRecord();
         Account child = getChildAccountRecord();
         
         REP_2_FORECAST__C rf = new REP_2_FORECAST__C();
         rf.WEIGHTED_FORECAST_PROPOSAL__C = 1000;
         rf.Account__c = child.Id;
         rf.Quarter__c = 'Q12012';
         insert rf;
         
         Test.startTest();
         BatchSummarizeAccBGSR2 u = new BatchSummarizeAccBGSR2('Limit 1');
         Database.executeBatch(u, 400);
         Test.stopTest();        
     }
     
     static testMethod void testBatchSummarizeAccBGSR1() {
         // TO DO: implement unit test
         Account a = getParentAccountRecord();
         Account child = getChildAccountRecord();
         
         REP_1_FORECAST__C rf = new REP_1_FORECAST__C();
         rf.WEIGHTED_FORECAST_PROPOSAL__C = 1000;
         rf.Account__c = child.Id;
         rf.Quarter__c = 'Q12012';
         insert rf;
         
         Test.startTest();
         BatchSummarizeAccBGSR1 u = new BatchSummarizeAccBGSR1('Limit 1');
         Database.executeBatch(u, 400);
         Test.stopTest();        
     }
     
     static testMethod void testBatchSummarizeAccBGSM2() {
         // TO DO: implement unit test
         Account a = getParentAccountRecord();
         Account child = getChildAccountRecord();
         
         SALES_MANAGER_2_FORECAST__C rf = new SALES_MANAGER_2_FORECAST__C();
         rf.WEIGHTED_FORECAST_PROPOSAL__C = 1000;
         rf.Account__c = child.Id;
         rf.Quarter__c = 'Q12012';
         insert rf;
         
         Test.startTest();
         BatchSummarizeAccBGSM2 u = new BatchSummarizeAccBGSM2('Limit 1');
         Database.executeBatch(u, 400);
         Test.stopTest();        
     }
     
     static testMethod void testBatchSummarizeAccBGSM1() {
         // TO DO: implement unit test
         Account a = getParentAccountRecord();
         Account child = getChildAccountRecord();
         
         SALES_MANAGER_1_FORECAST__C rf = new SALES_MANAGER_1_FORECAST__C();
         rf.WEIGHTED_FORECAST_PROPOSAL__C = 1000;
         rf.Account__c = child.Id;
         rf.Quarter__c = 'Q12012';
         insert rf;
         
         Test.startTest();
         BatchSummarizeAccBGSM1 u = new BatchSummarizeAccBGSM1('Limit 1');
         Database.executeBatch(u, 400);
         Test.stopTest();        
     }
     
     static testMethod void testBatchCreateAccountBG() {
        // TO DO: implement unit test
        Account a = getParentAccountRecord();
        
        ACCOUNT_BEST_GUESS_SUMMARY__C abg = new ACCOUNT_BEST_GUESS_SUMMARY__C();
        abg.Account__c = a.Id;
        insert abg;
        
        Test.startTest();
        BatchCreateAccountBG u = new BatchCreateAccountBG();
        Database.executeBatch(u, 400);
        Test.stopTest();
    }
     
     private static Account getParentAccountRecord(){
         Account a = new Account();
         a.Name = 'Test Account';
         a.Type = 'Conglomerate';
         a.Create_Best_Guess__c = true;
         insert a;
         return a;
     }
     
     private static Account getChildAccountRecord(){
         Account parent = getParentAccountRecord();
         Account a = new Account();
         a.Name = 'Child Acc';
         a.ParentId = parent.Id;
         insert a;
         return a;
     }
     
     static testMethod void testBatchSummarizeAccBGSR2COPY() {
         // TO DO: implement unit test
         Account a = getParentAccountRecord();
         Account child = getChildAccountRecord();
         
         REP_2_FORECAST__C rf = new REP_2_FORECAST__C();
         rf.WEIGHTED_FORECAST_PROPOSAL__C = 1000;
         rf.Account__c = child.Id;
         rf.Quarter__c = 'Q12012';
         insert rf;
         
         Test.startTest();
         BatchSummarizeAccBGSR2COPY u = new BatchSummarizeAccBGSR2COPY('Limit 1');
         Database.executeBatch(u, 400);
         Test.stopTest();        
     }
     
     static testMethod void testBatchSummarizeAccBGSR1COPY() {
         // TO DO: implement unit test
         Account a = getParentAccountRecord();
         Account child = getChildAccountRecord();
         
         REP_1_FORECAST__C rf = new REP_1_FORECAST__C();
         rf.WEIGHTED_FORECAST_PROPOSAL__C = 1000;
         rf.Account__c = child.Id;
         rf.Quarter__c = 'Q12012';
         insert rf;
         
         Test.startTest();
         BatchSummarizeAccBGSR1COPY u = new BatchSummarizeAccBGSR1COPY('Limit 1');
         Database.executeBatch(u, 400);
         Test.stopTest();        
     }
     
     static testMethod void testBatchSummarizeAccBGSM2COPY() {
         // TO DO: implement unit test
         Account a = getParentAccountRecord();
         Account child = getChildAccountRecord();
         
         SALES_MANAGER_2_FORECAST__C rf = new SALES_MANAGER_2_FORECAST__C();
         rf.WEIGHTED_FORECAST_PROPOSAL__C = 1000;
         rf.Account__c = child.Id;
         rf.Quarter__c = 'Q12012';
         insert rf;
         
         Test.startTest();
         BatchSummarizeAccBGSM2COPY u = new BatchSummarizeAccBGSM2COPY('Limit 1');
         Database.executeBatch(u, 400);
         Test.stopTest();        
     }
     
     static testMethod void testBatchSummarizeAccBGSM1COPY() {
         // TO DO: implement unit test
         Account a = getParentAccountRecord();
         Account child = getChildAccountRecord();
         
         SALES_MANAGER_1_FORECAST__C rf = new SALES_MANAGER_1_FORECAST__C();
         rf.WEIGHTED_FORECAST_PROPOSAL__C = 1000;
         rf.Account__c = child.Id;
         rf.Quarter__c = 'Q12012';
         insert rf;
         
         Test.startTest();
         BatchSummarizeAccBGSM1COPY u = new BatchSummarizeAccBGSM1COPY('Limit 1');
         Database.executeBatch(u, 400);
         Test.stopTest();        
     }
    
}