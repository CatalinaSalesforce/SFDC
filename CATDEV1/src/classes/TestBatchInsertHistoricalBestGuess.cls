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
public class TestBatchInsertHistoricalBestGuess {

    static testMethod void TestBatchInsertHistoricalBestGuess() {
        
        Manager_Best_Guess__c mbg = new Manager_Best_Guess__c();
        insert mbg;
        
        HBGBatchInterval__c hbgSetting = new HBGBatchInterval__c();
        hbgSetting.Name = 'LastDate';
        hbgSetting.Last_Run_Date__c = date.newinstance(2012, 8, 24);
        insert hbgSetting;
        
        Test.startTest();
        BatchInsertHistoricalBestGuess obj = new BatchInsertHistoricalBestGuess ('LIMIT 200');
        BatchInsertHistoricalBestGuess obj1 = new BatchInsertHistoricalBestGuess ();
        Database.executeBatch(obj, 200);
        Test.stopTest();
    
    }
     static testMethod void TestBatchInsertHistoricalSRBestGuess() {
        
        Sales_Rep_Best_Guess__c mbg = new Sales_Rep_Best_Guess__c();
        insert mbg;
        
        HBGBatchInterval__c hbgSetting = new HBGBatchInterval__c();
        hbgSetting.Name = 'LastDate';
        hbgSetting.SR_Last_Run_Date__c = Date.newInstance(2012, 8, 24);
        insert hbgSetting;
        
        Test.startTest();
        BatchInsertHistoricalSRBestGuess obj = new BatchInsertHistoricalSRBestGuess ('LIMIT 200');
        BatchInsertHistoricalSRBestGuess obj1 = new BatchInsertHistoricalSRBestGuess ();
        Database.executeBatch(obj, 200);
        Test.stopTest();
    
    }
}