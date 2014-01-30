/**

Author: Matt
Email: matt@cloud62.com
Purpose: Will test the ProgramFieldUpdates trigger, specifically the changes made
regarding Programs with Program.Start_Cycle__c == null

more functionality to come.

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
private class TestProgramFieldUpdatesTrigger {

    static testMethod void myUnitTest() {
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;

		String accountRTID = [SELECT ID FROM RecordType Where Name = 'Manufacturing' and SOBJECTTYPE = 'Account'][0].Id;
		String accountRTID2 = [select ID from RecordType where name = 'Retail' and SOBJECTTYPE = 'Account'][0].Id;
		
        Account a = new Account();
        a.Name = 'test 1234';
        a.RecordTypeId = accountRTID;
        
        insert a;
        
        Account a2 = new Account();
        a2.Name = 'retail test';
        a2.RecordTypeId = accountRTID2;
        
        Opportunity o = new Opportunity();
        o.Name = 'test oppty';
        o.StageName = 'Qualification';
        o.CloseDate = Date.Today();
        o.AccountId = a.Id;
        insert o;
        
        Opportunity o2 = new Opportunity();
        o2.Name = 'test opp2';
        o2.StageName = 'Qualification';
        o2.CloseDate = date.Today();
        o2.AccountId = a2.Id;
       
        Ad_Period__c ap = new Ad_Period__c();
        ap.Name = 'Ad Period 1';
        ap.Start_Date__c = date.Today();
        ap.End_Date__c = date.today().addDays(30);
        ap.Type__c = 'Manufacturing';
        insert ap;
        
        Ad_Period__c ap2 = new Ad_Period__c();
        ap.Name = 'Ad Period 2';
        ap.Start_Date__c = date.Today();
        ap.End_Date__c = date.today().addDays(30);
        ap.Type__c = 'Manufacturing';
        insert ap2;
        
        Program__c p = new Program__c();
        p.Name = 'test prog';
        p.Opportunity__c = o.Id;
        p.Account_Type__c = 'Manufacturing';
        p.Start_Date__c = date.Today();
        p.End_Date__c = date.today().addDays(30);
        
        Program__c p2 = new Program__c();
        p2.Name = 'testprog2';
        p2.Opportunity__c = o2.Id;
        p2.Account_Type__c = 'Retail';
        p2.Start_Date__c = date.Today();
        p2.End_Date__c = date.today().addDays(30);
        
        
        //begin main purpose of Matt writing this test:
        p.Start_Cycle__c = ap.Id;
        system.debug('p.End_Cycle__c before=' + p.End_Cycle__c);
        system.debug('ap2id =' + ap2.Id);
        
       // p.End_Cycle__c = ap2.Id;
        	insert p;
        p.Start_Cycle__c = null;
        update p; 

     
        
        p = [select Id, Start_Cycle__c from Program__c where Id =: p.Id][0];
        system.assert(p.Start_Cycle__c != null);
      //  system.assert(p.End_Cycle__c == ap2.Id);
      
      
      
    }
}