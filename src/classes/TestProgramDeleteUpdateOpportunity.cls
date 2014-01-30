/**
 *Test to test ProgramDeleteUpdateOpportunity.trigger
 *Author: Matt
 *Email: matt@cloud62.com
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
private class TestProgramDeleteUpdateOpportunity {

    static testMethod void myUnitTest() {
    	Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        // TO DO: implement unit test
        String accountRTID = [SELECT ID FROM RecordType Where Name = 'Manufacturing' and SOBJECTTYPE = 'Account'][0].Id;
		String accountRTID2 = [select ID from RecordType where name = 'Retail' and SOBJECTTYPE = 'Account'][0].Id;
		
        Account a = new Account();
        a.Name = 'test 1234';
        a.RecordTypeId = accountRTID;
        
        insert a;
        
        Account a2 = new Account();
        a2.Name = 'retail test';
        a2.RecordTypeId = accountRTID2;
        insert a2;
        
        Opportunity o = new Opportunity();
        o.Name = 'test oppty';
        o.StageName = 'Qualification';
        o.CloseDate = Date.Today();
        o.AccountId = a.Id;
        o.Product_Type__c = 'NA';
        o.Catalina_Business_Unit__c = '';
        insert o;
        
        
        Opportunity o2 = new Opportunity();
        o2.Name = 'test opp2';
        o2.StageName = 'Qualification';
        o2.CloseDate = date.Today();
        o2.AccountId = a2.Id;
        insert o2;
        
        Ad_Period__c ap = new Ad_Period__c();
        ap.Name = 'Ad Period 1';
        ap.Start_Date__c = date.Today();
        ap.End_Date__c = date.parse('05/30/2012');
        ap.Type__c = 'Manufacturing';
        insert ap;
        
        Ad_Period__c ap2 = new Ad_Period__c();
        ap.Name = 'Ad Period 2';
        ap.Start_Date__c = date.Today();
        ap.End_Date__c = date.parse('05/30/2012');
        ap.Type__c = 'Manufacturing';
        insert ap2;
        
        Program__c p = new Program__c();
        p.Name = 'test prog';
        p.Opportunity__c = o.Id;
        p.Account_Type__c = 'Manufacturing';
        p.Start_Date__c = date.Today();
        p.End_Date__c = date.parse('05/30/2012');
        p.Delivery_Type__c = 'Base';
        
        Program__c p2 = new Program__c();
        p2.Name = 'test prog';
        p2.Opportunity__c = o.Id;
        p2.Account_Type__c = 'Manufacturing';
        p2.Start_Date__c = date.Today();
        p2.End_Date__c = date.parse('05/30/2012');
        p2.Delivery_Type__c = 'Digital O&O';
        
        
        insert p;
        delete p;
        o.Catalina_Business_Unit__c = 'Base;Digital O&O;Mobile';
        update o;
        system.debug('***'+o.Catalina_Business_Unit__c);
        List<Program__c> programList = new List<Program__c>([select Id from Program__c p where p.Opportunity__c =: o.Id]);
        system.debug('listsize: '+programList.size());
        
   		Program__c prog = programList.get(0);
   		
   		delete prog;
       // delete p2;
        
    }
}