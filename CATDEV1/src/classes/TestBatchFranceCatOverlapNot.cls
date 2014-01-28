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
public class TestBatchFranceCatOverlapNot {

    //edited by Warren Mar 23 2013 to insert lists instead of individual records
    static testMethod void BatchFranceCategoryOverlapNotification() {
        
        Integer todayDate = Date.today().day();
        France_Category_Overlap_NotificationList__c fs = new France_Category_Overlap_NotificationList__c();
        fs.name='FranceCatOverlapNotification';
        fs.Email_Addresses__c='warren@cloud62.com;Stephanie.Lapp@catalinamarketing.com;raj@cloud62.com;benedicte.enrici@catalinamarketing.com';
        fs.Store_Proposal_Day__c=todayDate;
        insert fs;
        
        String accRTID = [SELECT ID FROM RecordType Where Name = 'Manufacturing' and SOBJECTTYPE = 'Account'][0].Id;
        String rtID = [SELECT ID FROM RecordType Where Name = 'CONTRACT FRANCE' and SOBJECTTYPE = 'Opportunity'][0].Id;
        
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        Account acc = new Account();
        acc.Name = 'test1';
        acc.RecordTypeId = accRTID;
        acc.Type = 'Other';
        insert acc;
        
        List<Opportunity> insertOpps = new List<Opportunity>();
        List<Program__c> insertProgram = new List<Program__c>();
        List<Opportunity_Category__c> insertOC = new List<Opportunity_Category__c>();
        
        Opportunity o = new Opportunity();
        o.AccountId = acc.Id;
        o.RecordTypeId = rtID;
        o.Name = 'Test oppty';
        o.StageName = 'Presented';
        o.CloseDate = Date.valueOf('2012-12-23');
        insertOpps.add(o);
        
        
        Opportunity o2 = new Opportunity();
        o2.AccountId = acc.Id;
        o2.RecordTypeId = rtID;
        o2.Name = 'Test oppty2';
        o2.StageName = 'Presented';
        o2.CloseDate = Date.valueOf('2012-12-23');
        insertOpps.add(o2);
        insert insertOpps;
        
        Ad_Period__c ap1 = new Ad_Period__c();
        ap1.Name = 'FR_C1_2013';
        ap1.Start_Date__c = Date.valueOf('2013-08-06');
        ap1.End_Date__c = Date.valueOf('2013-10-14');
        ap1.Type__c = 'Manufacturing';
        insert ap1;
        
        Ad_Period__c ap2 = new Ad_Period__c();
        ap2.Name = 'FR_C1_2012';
        ap2.Start_Date__c = Date.valueOf('2013-08-08');
        ap2.End_Date__c = Date.valueOf('2013-11-14');
        ap2.Type__c = 'Manufacturing';
        insert ap2;
        
        Program__c pro = new Program__c();
        pro.Opportunity__c = o.Id;
        pro.Name = 'test';
        pro.Delivery_Type__c = 'Base';
        pro.Account_Type__c = 'Manufacturing';
        pro.Start_Date__c = Date.valueOf('2011-08-23');
        pro.End_Date__c = Date.valueOf('2012-02-19');
        pro.Start_Cycle__c = ap1.Id;
        Pro.End_Cycle__c = ap1.Id;
        insertProgram.add(pro);
        
        
        Program__c pro2 = new Program__c();
        pro2.Opportunity__c = o2.Id;
        pro2.Name = 'test2';
        pro2.Delivery_Type__c = 'Overprint';
        pro2.Account_Type__c = 'Manufacturing';
        pro2.Program_Amount__c = 100;
        pro2.Start_Cycle__c = ap2.Id;
        Pro2.End_Cycle__c = ap2.Id;
        insertProgram.add(pro2);
        
        Program__c pro3 = new Program__c();
        pro3.Opportunity__c = o.Id;
        pro3.Name = 'test3';
        pro3.Delivery_Type__c = 'Overprint';
        pro3.Account_Type__c = 'Manufacturing';
        pro3.Program_Amount__c = 100;
        pro3.Start_Cycle__c = ap2.Id;
        Pro3.End_Cycle__c = ap2.Id;
        insertProgram.add(pro3);
        insert insertProgram;
        
        Product2 p = new Product2();
        p.Name = 'TestProduct';
        p.IsActive = True;
        insert p;
        
        Product2 p2 = new Product2();
        p2.Name = 'TestProduct';
        p2.IsActive = True;
        insert p2;
        
        
        Opportunity_Category__c oc = new Opportunity_Category__c();
        oc.Opportunity__c = o.Id;
        oc.Category__c = p.Id;
        oc.Amount__c = 100;
        insertOC.add(oc);
        
        Opportunity_Category__c oc2 = new Opportunity_Category__c();
        oc2.Opportunity__c = o2.Id;
        oc2.Category__c = p2.Id;
        oc2.Amount__c = 100;
        insertOC.add(oc2);
        
        Opportunity_Category__c oc3 = new Opportunity_Category__c();
        oc3.Opportunity__c = o.Id;
        oc3.Category__c = p2.Id;
        oc3.Amount__c = 100;
        insertOC.add(oc3);
        insert insertOC;
        
        Category_Overlap__c co1 = new Category_Overlap__c(Opportunity_Category__c=oc.ID,Opportunity_Category_Two__c=oc2.ID);
        Category_Overlap__c co2 = new Category_Overlap__c(Opportunity_Category__c=oc.ID,Opportunity_Category_Two__c=oc3.ID);
        List<Category_Overlap__c> insertCo = new List<Category_Overlap__c>();
        insertCo.add(co2);
        insertCo.add(co1);
        insert insertCo;
        
        Test.startTest();
        BatchFranceCategoryOverlapNotification obj = new BatchFranceCategoryOverlapNotification();
        String sch = '0 0 23 * * ?'; 
        system.schedule('BatchFranceCategoryOverlapNotification', sch, obj);
        Database.executeBatch(obj, 200);
        Test.stopTest();
    
    }
    
}