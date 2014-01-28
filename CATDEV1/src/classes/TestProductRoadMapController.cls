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
private class TestProductRoadMapController {

    static testMethod void myUnitTest() {
        List<RecordType> lstRTs = [SELECT Id,Name FROM RecordType WHERE sObjectType = 'Task'];
        Product__c newProd = new Product__c();
        newProd.Health__c = 'Red';
        newProd.Admin_Start_Date__c = Date.today().addDays(-30);
        newProd.Admin_End_Date__c = Date.today().addDays(30);
        newProd.Category__c = 'Test';
        newProd.Name = 'Test Product';
        insert newProd;
        
        Project__c proj = new Project__c();
        insert proj;
        
        Product_Project__c newPP = new Product_Project__c();
        newPP.Product__c = newProd.Id;
        newPP.Project__c = proj.Id;
        insert newPP;
        
        List<Task> lstTasks = new List<Task>();
        Task projTask = new Task();
        for(RecordType rt : lstRTs){
            if(rt.Name == 'Project'){
                projTask.RecordTypeId = rt.Id;
            }
        }
        projTask.WhatID = proj.Id;
        projTask.Start_Date__c = Date.today().addDays(-30);
        projTask.End_Date__c = Date.today().addDays(20);
        projTask.Health__c = 'Red';
        projTask.Description = 'task1';
        projTask.Subject = 'Call';
        lstTasks.add(projTask);
        
        Task task1 = new Task();
        for(RecordType rt : lstRTs){
            if(rt.Name == 'Product'){
                projTask.RecordTypeId = rt.Id;
            }
        }
        task1.WhatID = newProd.Id;
        task1.Start_Date__c = Date.today().addDays(-30);
        task1.End_Date__c = Date.today();
        task1.Health__c = 'Red';
        task1.Description = 'task1';
        task1.Subject = 'Call';
        lstTasks.add(task1);
        
        Task task2 = new Task();
        task2.WhatID = newProd.Id;
        task2.Start_Date__c = Date.today();
        task2.End_Date__c = Date.today().addDays(30);
        task2.Health__c = 'Green';
        task2.Description = 'task2';
        task2.Subject = 'Call';
        lstTasks.add(task2);
        insert lstTasks;
        
        Feature__c feature = new Feature__c();
        feature.Feature__c = 'Feature info';
        feature.Priority__c = 'Critical';
        feature.Status__c = 'Pilot';
        insert feature;
        
        Release__c rel1 = new Release__c();
        //rel1.Application__c = app.Id;
        rel1.Applications__c = 'My App';
        rel1.Name = 'Release 1';
        rel1.Start_Date__c = Date.today().addDays(-5);
        rel1.End_Date__c = Date.today().addDays(100);
        rel1.Health__c = 'Green';
        rel1.Initiative__c = '';
        rel1.Release__c = 'Release Info';
        insert rel1;
        
        Release_Feature__c relFeat = new Release_Feature__c();
        relFeat.Feature__c = feature.Id;
        relFeat.Release__c = rel1.Id;
        insert relFeat;
        
        Project_Release__c proRel = new Project_Release__c();
        proRel.Project__c = proj.Id;
        proRel.Release__c = rel1.Id;
        insert proRel;
        
        Product_Feature_Link__c productFeature = new Product_Feature_Link__c();
        productFeature.Feature__c = feature.Id;
        productFeature.Product__c = newProd.Id;
        insert productFeature;
        
        PageReference pageRef = Page.ProductRoadMap;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController ctl = new ApexPages.StandardController(newProd);
        ProductRoadMapController PRM = new ProductRoadMapController(ctl);
    }
}