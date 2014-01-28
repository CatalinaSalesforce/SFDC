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
private class TestProductTrackerCls {
    //test method for ProductTrackerCls class.
    private static testmethod void testProjectTask(){
        //get the test record
        Project__c project = getProjectRecord();
        Task ptask = getProjectTaskRecord(project.Id);
        Task pCRTask = getChangeRequestTaskRecord(project.Id);
        Product_Tracker_Setting__c pts = getCustomSettingRecord();
        Test.startTest();
        //set the ProjectTasks visual force page reference 
        PageReference pageRef = Page.ProjectTasks;
        Test.setCurrentPageReference(pageRef);
        ApexPages.StandardController ctl = new ApexPages.StandardController(project);
        ProductTrackerCls pt = new ProductTrackerCls(ctl);
        ProductTrackerCls pTracker = new ProductTrackerCls();
        pt.obj = 'Task';
        pt.recordType = 'Project';
        pt.objNameParam = 'Task';
        pt.recTypeNameParam = 'Project';
        pt.objectId = project.Id;
        pt.conditionField = 'WhatId';
        pt.getFieldsFromCustomSetting();
        pt.dataList = null;
        List<ProductTrackerCls.DataDisplayWrapper> tmpList = pt.dataList;
        //Assertion
        System.assertEquals(tmpList.size(), 1);
        pt.viewRecord();
        pt.editRecord();
        pt.newRecords();
        pt.objNameParam = 'Note';
        pt.newRecords();
        pt.objNameParam = 'Attachment';
        pt.newRecords();
        pt.recordType = 'Change Request';
        pt.getFieldsFromCustomSetting();
        pt.recordType = 'Product';
        pt.getFieldsFromCustomSetting();
        pt.recordType = 'Action Item';
        pt.getFieldsFromCustomSetting();
        pt.delId = ptask.ID;
        pt.obj = 'Task';
        pt.delRecord();
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=project.id;
        insert attach;
        pt.delId = attach.ID;
        pt.editId = attach.ID;
        pt.editNoteAttachRecord();
        pt.delNoteAttachRecord();
        Test.stopTest();
    }

    //test method for ProductTrackerCls class.
    private static testmethod void testFeatureTask(){
        //get the test record
        Feature__c ft = getFeatureRecord();
        Product__c prod =getProductRecord();
        Product_Feature_Link__c pf = getProductFeatureRecord(ft.Id,prod.Id);
        Product_Tracker_Setting__c pts = getCustomSettingRecord();
        Test.startTest();
        //set the Product_Tracker_Features visual force page reference 
        PageReference pageRef = Page.Product_Tracker_Features;
        Test.setCurrentPageReference(pageRef);
        ApexPages.StandardController ctl = new ApexPages.StandardController(ft);
        ProductTrackerCls pt = new ProductTrackerCls(ctl);
        ProductTrackerCls pTracker = new ProductTrackerCls();
        pt.objectId = ft.Id;
        pt.prodReleaseFeatureNameParam = ft.Name;
        pt.obj = 'Product_Feature_Link__c';
        pt.objNameParam = 'Product_Feature_Link__c';
        pt.conditionField = 'Feature__c';
        pt.getFieldsFromCustomSetting();
        pt.dataList = null;
        List<ProductTrackerCls.DataDisplayWrapper> tmpList = pt.dataList;
        //Assertion
        System.assertEquals(tmpList.size(), 1);
        pt.newRecords();
        Test.stopTest();
    }
    
    //prepare the test Project record
    private static Project__c getProjectRecord(){
        Project__c project = new Project__c(Name = 'Mobile Systems Architecture & Integration');
        insert project;
        return project;
    }

    //prepare the test Product Tracker Setting record
    private static Product_Tracker_Setting__c getCustomSettingRecord(){
        Product_Tracker_Setting__c pts = new Product_Tracker_Setting__c();
        pts.Name = 'Default';
        pts.NoRT_Task__c = 'Subject~Subject;Related To~WhatId;Due Date~ActivityDate;Status~Status;Priority~Priority;Assigned To~OwnerId';
        pts.Product_Task__c = 'Subject~Subject;Related To~WhatId;Due Date~ActivityDate;Status~Status;Priority~Priority;Assigned To~OwnerId';
        pts.Project_Task__c = 'Subject~Subject;Related To~WhatId;Due Date~ActivityDate;Status~Status;Priority~Priority;Assigned To~OwnerId';
        pts.Project_Change_Request_Task__c = 'Subject~Subject;Related To~WhatId;Due Date~ActivityDate;Status~Status;Priority~Priority;Assigned To~OwnerId';
        pts.Product_Action_Item_Task__c = 'Subject~Subject;Related To~WhatId;Due Date~ActivityDate;Status~Status;Priority~Priority;Assigned To~OwnerId';
        pts.Product_Features__c = 'Product~Product__c;Phase~Product__r.Phase__c;Objectives~Product__r.Objectives__c;Status~Product__r.Status__c;Health~Product__r.Health__c';
        pts.Releases_Features__c = 'Release~Release__c;Start Date~Release__r.Start_Date__c;End Date~Release__r.End_Date__c;Status~Release__r.Status__c;Health~Release__r.Health__c;Initiative~Release__r.Initiative__c';
        pts.Project_Releases__c = 'Release Name~Release__c;Start Date~Release__r.Start_Date__c;End Date~Release__r.End_Date__c;Status~Release__r.Status__c;Health~Release__r.Health__c';
        pts.Product_Project__c = 'Project~Project__c;Start Date~Project__r.Start_Date__c;Baseline Finish~Project__r.Baseline_Finish__c;Target Finish~Project__r.Target_Finish__c;Status~Project__r.Status__c';
        pts.Project_Product__c = 'Product~Product__c;Objectives~Product__r.Objectives__c;Status~Product__r.Status__c;Health~Product__r.Health__c';
        insert pts;
        return pts;
    }
    
    //prepare the test Task record
    private static Task getProjectTaskRecord(Id pro){
        RecordType rType = [select ID,Name from RecordType where SobjectType='Task' and Name='Project'];
        Task tsk = new Task();
        tsk.WhatID = pro;
        tsk.ActivityDate = system.today();
        tsk.RecordTypeId = rType.Id;
        tsk.Subject = 'Call';
        insert tsk;
        return tsk;
    }
    
    //prepare the test Task record
    private static Task getChangeRequestTaskRecord(Id pro){
        RecordType rType = [select ID,Name from RecordType where SobjectType='Task' and Name='Change Request'];
        Task tsk = new Task();
        tsk.WhatID = pro;
        tsk.ActivityDate = system.today();
        tsk.RecordTypeId = rType.Id;
        tsk.Subject = 'Call';
        insert tsk;
        return tsk;
    }
    
    //prepare the test Feature record
    private static Feature__c getFeatureRecord(){
        Feature__c ft = new Feature__c(Name = 'Email - TPM');
        insert ft;
        return ft;
    }
    
    //prepare the test Product record
    private static Product__c getProductRecord(){
        Product__c prod = new Product__c(Name = 'Advertising');
        insert prod;
        return prod;
    }
    
    //prepare the test Product Feature Link record
    private static Product_Feature_Link__c getProductFeatureRecord(Id ft,Id prod){
        Product_Feature_Link__c pf = new Product_Feature_Link__c();
        pf.Feature__c = ft;
        pf.Product__c = prod;
        insert pf;
        return pf;
    }
}