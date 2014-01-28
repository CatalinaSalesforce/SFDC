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
 * Author: Matt
 * Email: matt@cloud62.com
 */
@isTest
private class TestUpdateOpportunityDetails {

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
        insert o;
        
        Opportunity o2 = new Opportunity();
        o2.Name = 'test opp2';
        o2.StageName = 'Qualification';
        o2.CloseDate = date.Today();
        o2.AccountId = a2.Id;
        o2.IsMultiYear__c = false;
        insert o2;
        
        List<Ad_Period__c> lstap = new List<Ad_Period__c>();
        Ad_Period__c ap = new Ad_Period__c();
        ap.Name = 'Ad Period 1';
        ap.Start_Date__c = date.Today();
        ap.End_Date__c = date.parse('09/30/2012');
        ap.Type__c = 'Manufacturing';
        lstap.add(ap);
        
        Ad_Period__c ap2 = new Ad_Period__c();
        ap2.Name = 'Ad Period 2';
        ap2.Start_Date__c = date.Today();
        ap2.End_Date__c = date.parse('05/30/2012');
        ap2.Type__c = 'Manufacturing';
        lstap.add(ap2);
        
        Ad_Period__c ap3 = new Ad_Period__c();
        ap3.Name = 'C1_CY2011';
        ap3.External_ID__c = 'C1_CY2011';
        ap3.Start_Date__c = date.parse('12/31/2010');
        ap3.End_Date__c = date.parse('01/27/2011');
        ap.Type__c = 'Manufacturing';
        lstap.add(ap3);
        
        Ad_Period__c ap4 = new Ad_Period__c();
        ap4.Name = 'C1_CY2014';
        ap4.External_ID__c = 'C1_CY2014';
        ap4.Start_Date__c = date.parse('12/31/2013');
        ap4.End_Date__c = date.parse('01/27/2014');
        ap.Type__c = 'Manufacturing';
        lstap.add(ap4);
        insert lstap;
        
        Program__c prog = new Program__c();
        prog.Name = 'Program 2';
        Prog.Opportunity__c = o2.Id;
        
        insert prog;
        
        List<Program_Forecast__c> lstpf = new List<Program_Forecast__c>();
        
        //forecast with Ad_period not starting with C1
        Program_Forecast__c pf0 = new Program_Forecast__c();
        pf0.Ad_Period__c = ap.Id;
        pf0.Program__c = prog.Id;
        pf0.Forecast_Amount__c = 200;
 		lstpf.add(pf0);
        
        //forecast with NQA
        Program_Forecast__c pf = new Program_Forecast__c();
        pf.Ad_Period__c = ap4.Id;
        pf.Program__c = prog.Id;
        pf.Forecast_Amount__c = 200;
        pf.Previous_Quarter_Amount__c = 0;
        pf.Next_Quarter_Amount__c = 200;
 		lstpf.add(pf);
 		
 		//forecast with PQA
 		Program_Forecast__c pf3 = new Program_Forecast__c();
        pf3.Ad_Period__c = ap4.Id;
        pf3.Program__c = prog.Id;
        pf.Forecast_Amount__c = 1000;
        pf3.Previous_Quarter_Amount__c = 1000;
        pf3.Next_Quarter_Amount__c = 0;
 		lstpf.add(pf3);
 		
 		//actual with NQA
 		
 		Program_Forecast__c pf1 = new Program_Forecast__c();
        pf1.Ad_Period__c = ap3.Id;
        pf1.Program__c = prog.Id;
        pf1.Actual_Amount__c = 500;
        pf1.Previous_Quarter_Actual__c = 0;
        pf1.Next_Quarter_Actual__c = 500;
 		lstpf.add(pf1);
	
		//actual with PQA
		Program_Forecast__c pf2 = new Program_Forecast__c();
        pf2.Ad_Period__c = ap3.Id;
        pf2.Program__c = prog.Id;
        pf2.Actual_Amount__c = 500000;
        pf2.Previous_Quarter_Actual__c = 500000;
        pf2.Next_Quarter_Actual__c = 0;
 		lstpf.add(pf2);
 		
 		insert lstpf;
 		
 		update o2;
 		
 		system.debug('*_*_*_CY1' + ap3.Name);
 		
 		o2 = [SELECT ID, ISMULTIYEAR__C FROM OPPORTUNITY WHERE ID =: o2.Id];
 		
 		system.assert(o2.IsMultiYear__c == true);
	         
        // Program__r.Opportunity__c, Previous_Quarter_Amount__c, Next_Quarter_Amount__c,
         //Forecast_Amount__c, Actual_Amount__c, Previous_Quarter_Actual__c, Next_Quarter_Actual__c From Program_Forecast__c
       
        
        o.Catalina_Business_Unit__c = 'Base;Digital O&O';
        update o;
        List<Program__c> plist = ([select Id from Program__c p where p.Opportunity__c =: o.Id]);
        system.debug(plist.size());
        system.assert(plist.size() == 2); //there will now be 2 programs associated with Opportunity o
        o.Catalina_Business_Unit__C = 'Base'; // change catalina business unit without removing program first
        try{ update o; }catch(Exception e) {System.debug(e + ' caught');}
                system.assert(plist.size() == 2); //nothing happened. deletion prevented
        
        
        
        
    }
}