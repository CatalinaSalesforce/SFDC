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
private class TestGanttGeneratorController {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        Product__c newProd = new Product__c();
        newProd.Health__c = 'Red';
        newProd.Admin_Start_Date__c = Date.today().addDays(-30);
        newProd.Admin_End_Date__c = Date.today().addDays(30);
        newProd.Category__c = 'Test';
        newProd.Name = 'Test Product';
        insert newProd;
        
        Product_Task__c task1 = new Product_Task__c();
        task1.Product__c = newProd.Id;
        task1.Start_Date__c = Date.today().addDays(-30);
        task1.End_Date__c = Date.today();
        task1.Health__c = 'Red';
        task1.Task__c = 'task1';
        insert task1;
        
        Product_Task__c task2 = new Product_Task__c();
        task2.Product__c = newProd.Id;
        task2.Start_Date__c = Date.today();
        task2.End_Date__c = Date.today().addDays(30);
        task2.Health__c = 'Green';
        task2.Task__c = 'task2';
        insert task2;
        
        GanttGeneratorController GGC = new GanttGeneratorController();
        GGC.prodId = newProd.Id;
        GGC.createChartItems();
        GGC.getProdOptions();
        
        PageReference pageRef = Page.GanttGeneratorDetailView;
        Test.setCurrentPage(pageRef);
        Test.startTest();
        ApexPages.StandardController ctl = new ApexPages.StandardController(newProd);
        ApexPages.currentPage().getParameters().put('Id', newProd.Id);
        GanttGeneratorDetailViewController GGDV = new GanttGeneratorDetailViewController(ctl);
        GGDV.createChartItems();
        Test.stopTest();
        
    }
}