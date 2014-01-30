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
public class TestGetAdPeriodControllerFranceActual  {

    static testMethod void GetAdPeriodControllerFranceActual () {
                
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        String rtID = [SELECT ID FROM RecordType Where Name = 'Contract' and SOBJECTTYPE = 'Opportunity'][0].Id;
        String accountRTID = [SELECT ID FROM RecordType Where Name = 'Manufacturing' and SOBJECTTYPE = 'Account'][0].Id;
        
        List<Ad_Period__c> lstAdPeriod = new List<Ad_Period__c>();
        Ad_Period__c ap=new Ad_Period__c();
        ap.Name='Jan-2012';
        ap.Start_Date__c = date.newInstance(system.today().year(), system.today().month(), 1);
        ap.End_Date__c = date.newInstance(system.today().year(), system.today().month(), 30);
        ap.Type__c='Manufacturing';
        lstAdPeriod.add(ap);
        
        Ad_Period__c ap1 = new Ad_Period__c();
        ap1.Name = 'FEB-2012';
        ap1.Start_Date__c = date.newInstance(system.today().year(), system.today().month()+1, 1);
        ap1.End_Date__c = date.newInstance(system.today().year(), system.today().month()+1, 30);
        ap1.Type__c='Manufacturing';       
        lstAdPeriod.add(ap1);
        
        Ad_Period__c ap2 = new Ad_Period__c();
        ap2.Name = 'MAR-2012';
        ap2.Start_Date__c = date.newInstance(system.today().year(), system.today().month()+2, 1);
        ap2.End_Date__c = date.newInstance(system.today().year(), system.today().month()+2, 30);
        ap2.Type__c='Manufacturing';       
        lstAdPeriod.add(ap2);
        
        Ad_Period__c ap3 = new Ad_Period__c();
        ap3.Name = 'APR-2012';
        ap3.Start_Date__c = date.newInstance(system.today().year(), system.today().month()+3, 1);
        ap3.End_Date__c = date.newInstance(system.today().year(), system.today().month()+3, 30);
        ap3.Type__c='Manufacturing';       
        lstAdPeriod.add(ap3);
        
        Ad_Period__c ap4 = new Ad_Period__c();
        ap4.Name = 'MAY-2012';
        ap4.Start_Date__c = date.newInstance(system.today().year(), system.today().month()+4, 1);
        ap4.End_Date__c = date.newInstance(system.today().year(), system.today().month()+4, 30);
        ap4.Type__c='Manufacturing';       
        lstAdPeriod.add(ap4);
        
        Ad_Period__c ap5 = new Ad_Period__c();
        ap5.Name = 'JUN-2012';
        ap5.Start_Date__c = date.newInstance(system.today().year(), system.today().month()+5, 1);
        ap5.End_Date__c = date.newInstance(system.today().year(), system.today().month()+5, 30);
        ap5.Type__c='Manufacturing';       
        lstAdPeriod.add(ap5);
        
        Ad_Period__c ap6 = new Ad_Period__c();
        ap6.Name = 'JUL-2012';
        ap6.Start_Date__c = date.newInstance(system.today().year(), system.today().month()+6, 1);
        ap6.End_Date__c = date.newInstance(system.today().year(), system.today().month()+6, 30);
        ap6.Type__c='Manufacturing';       
        lstAdPeriod.add(ap6);
        
        insert lstAdPeriod;
  
        Account ac=new Account();
        ac.Name='test1';
        ac.RecordTypeId = accountRTID;
        insert ac;    
           
        Opportunity op=new Opportunity();
        op.Name='test2';
        op.AccountId=ac.Id;
        op.RecordTypeId = rtID;
        op.CloseDate=system.today();
        op.StageName='Qualification';
        insert op;
        
        ApexPages.currentPage().getParameters().put('Id',op.Id);       
        
        GetAdPeriodControllerFranceActual gap=new GetAdPeriodControllerFranceActual();
        
        gap.noPre = false;
        gap.cDate=string.valueOf(system.today());
        gap.currentDate=system.today()-1;
        gap.navigation = 'reset';
        gap.refresh();
        gap.getAdPeriodNames();
        gap.loadGrid();        
       
        RecordType rt = [SELECT id from RecordType WHERE Name='Retail' AND SObjectType = 'Account' LIMIT 1];
        ApexPages.currentPage().getParameters().put('rId',rt.Id);
        
        Account ac1=new Account();
        ac1.Name='test11';
        insert ac1;    
           
        Opportunity op1=new Opportunity();
        op1.Name='test2';
        op1.AccountId=ac.Id;
        op1.CloseDate=system.today();
        op1.StageName='Qualification';
        insert op1;        
        
        gap=new GetAdPeriodControllerFranceActual();
        gap.noPre = true;
        gap.cDate=string.valueOf(system.today().adddays(-1));       
        gap.refresh();
        gap.getAdPeriodNames();
        gap.loadGrid();
        
        Program__c pro = new Program__c();
        pro.Opportunity__c = op1.Id;
        pro.Name = 'test';
        pro.Delivery_Type__c = 'Base';
        insert pro;
        
        gap.jsonToSave = '{"programs":[{"ProgId":"'+ pro.Id +'","forecast1":"0.00","forecast2":"100.00","forecast3":"100.00","forecast4":"100.00","forecast5":"100.00","forecast6":"100.00","forecast7":"100.00"}]}';
        gap.cDateString = String.valueOf(system.today());
        gap.recType = 'Retail';
        gap.firstAdPeriodStartDate = System.today();
        gap.saveJson();
        gap.getAccounttypes();
        gap.getQuarters();
        gap.getYears();
        
    
    }
}