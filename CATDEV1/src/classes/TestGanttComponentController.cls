/*
@Name : TestGanttComponentController
@Author : customersuccess@cloud62.com
@Date : 05/21/2013
@Description : Test GanttComponentController class functionality.
*/
@isTest
private class TestGanttComponentController {

    /*
    @Name :testGanttComponentCtr
    @Description : Test GanttComponentController class functionality.
    */
    static testMethod void testGanttComponentCtr() {
        Product__c prod = getProduct();
        Project__c project = getProjectRecord();
        Product_Project__c pp = getProductProject(prod.ID,project.ID);
        List<Task> tskList = getTasks(prod.ID,'Product');
        System.debug(tskList);
        Task_Relationship__c tr1 = getTaskRelationship(tskList[0].ID, tskList[1].ID);
        //Task_Relationship__c tr2 = getTaskRelationship(tskList[1].ID, tskList[2].ID);
        Task_Relationship__c tr3 = getDependancyTaskRelationship(tskList[0].ID, tskList[2].ID);
        //Task_Relationship__c tr4 = getDependancyTaskRelationship(tskList[2].ID, tskList[0].ID);
        //Test.startTest();
        GanttComponentController gcc = new GanttComponentController();
        gcc.strMasterValue = prod.Id;
        gcc.strDataType = 'Product';
        gcc.init();
        System.debug(gcc.strJSON);
        gcc.newTask();
        gcc.doNothing();
        gcc.strJSONSave = gcc.strJSON;
        List<String> deltask = new List<String>();
        Task t = new Task(OwnerId = UserInfo.getUserId(),Subject='Test4',Status='Not Started',Priority='Normal',Health__c='Green',
                    Start_Date__c=System.Today().addyears(-1),End_Date__c=System.Today().addMonths(-15),Description='Test4',WhatId=prod.Id);
        insert t;
        deltask.add(t.ID);
        DateTime startTime = System.now().addDays(40);
        Long stime = startTime.getTime();
        DateTime endTime = System.now().addDays(-100);
        Long eTime = endTime.getTime();
        GanttComponentController.JSON2Apex jsa = new GanttComponentController.JSON2Apex();
        jsa = (GanttComponentController.JSON2Apex)JSON.deserialize(gcc.strJSONSave,GanttComponentController.JSON2Apex.class);
        jsa.deletedTaskIds = deltask;
        for(GanttComponentController.JSONTask jst : jsa.tasks){
            jst.startTime = stime;
            jst.endTime = eTime;
        }
        gcc.strJSONSave = JSON.serialize(jsa);
        gcc.saveTasks();
        //Test.stopTest();
    }
    
    /*
    @Name :testGanttComponentCtr1
    @Description : Test GanttComponentController class functionality.
    */
    static testMethod void testGanttComponentCtr1() {
        Product__c prod = getProduct();
        Project__c project = getProjectRecord();
        Product_Project__c pp = getProductProject(prod.ID,project.ID);
        List<Task> tskList = getTasks(project.ID,'Project');
        Task_Relationship__c tr1 = getTaskRelationship(tskList[0].ID, tskList[1].ID);
        Task_Relationship__c tr2 = getTaskRelationship(tskList[1].ID, tskList[2].ID);
        Task_Relationship__c tr3 = getDependancyTaskRelationship(tskList[1].ID, tskList[2].ID);
        Task_Relationship__c tr4 = getDependancyTaskRelationship(tskList[2].ID, tskList[0].ID);
        Test.startTest();
        GanttComponentController gcc = new GanttComponentController();
        gcc.strMasterValue = project.Id;
        gcc.strDataType = 'Project';
        gcc.init();
        gcc.newTask();
        gcc.doNothing();
        gcc.strMasterValue = prod.Product_Family__c;
        gcc.strDataType = 'ProductRoadmap';
        gcc.init();
        Test.stopTest();
    }
    
    /*
    @Name :getProduct
    @Description : prepare the test data for Product__c record.
    */
    private static Product__c getProduct(){
        Product__c newProd = new Product__c();
        newProd.Health__c = 'Red';
        newProd.Admin_Start_Date__c = Date.today().addDays(-30);
        newProd.Admin_End_Date__c = Date.today().addDays(30);
        newProd.Product_Family__c = 'Health';
        newProd.Category__c = 'Test';
        newProd.Name = 'Test Product';
        insert newProd;
        return newProd;
    }
    
    /*
    @Name :getProjectRecord
    @Description : prepare the test data for Project__c record.
    */
    private static Project__c getProjectRecord(){
        Project__c project = new Project__c(Name = 'Mobile Systems Architecture & Integration',Start_Date__c=Date.today().addDays(-30),
                Target_Finish__c=Date.today().addDays(30));
        insert project;
        return project;
    }
    
    /*
    @Name :getProductProject
    @Description : prepare the test data for Product_Project__c record.
    */
    private static Product_Project__c getProductProject(String prod,String proj){
        Product_Project__c pp = new Product_Project__c(Product__c=prod,Project__c=proj);
        insert pp;
        return pp;
    }
    
    /*
    @Name :getTasks
    @Description : prepare the test data for Task record.
    */
    private static List<Task> getTasks(String pID,String rName){
        List<RecordType> rType = [Select ID,Name FROM RecordType WHERE Name=:rName AND sObjectType='Task'];
        Task t = new Task(OwnerId = UserInfo.getUserId(),Subject='Test1',Status='Not Started',Priority='Normal',Health__c='Green',
                    Start_Date__c=System.Today().addyears(-1),End_Date__c=System.Today().addMonths(-10),Description='Test1',WhatId=pID);
        Task t1 = new Task(OwnerId = UserInfo.getUserId(),Subject='Test2',Status='Not Started',Priority='Normal',Health__c='Yellow',
                    Start_Date__c=System.Today().addMonths(-12),End_Date__c=System.Today().addMonths(-9),Description='Test2',WhatId=pID);
        Task t2 = new Task(OwnerId = UserInfo.getUserId(),Subject='Test3',Status='Not Started',Priority='Normal',Health__c='Red',
                    Start_Date__c=System.Today().addMonths(-11),End_Date__c=System.Today().addMonths(-8),Description='Test3',WhatId=pID);
        if(rType != null){
            t.RecordTypeID = rType[0].ID;
            t1.RecordTypeID = rType[0].ID;
            t2.RecordTypeID = rType[0].ID;
        }
        List<Task> tList = new List<Task>();
        tList.add(t);
        tList.add(t1);
        tList.add(t2);
        insert tList;
        return tList;
    }
    
    /*
    @Name :getTaskRelationship
    @Description : prepare the test data for Task_Relationship__c record.
    */
    private static Task_Relationship__c getTaskRelationship(String parentID, String childID){
        List<RecordType> rType = [Select ID,Name FROM RecordType WHERE Name='Parent Child' AND sObjectType='Task_Relationship__c'];
        Task_Relationship__c newTR = new Task_Relationship__c ();
        newTR.Child_Task_ID__c = childID;
        newTR.Parent_Task_ID__c = parentID;
        if(rType != null){
            newTR.RecordTypeID = rType[0].ID;
        }
        insert newTR;
        return newTR;
    }
    
    /*
    @Name :getDependancyTaskRelationship
    @Description : prepare the test data for Task_Relationship__c record.
    */
    private static Task_Relationship__c getDependancyTaskRelationship(String parentID, String childID){
        List<RecordType> rType = [Select ID,Name FROM RecordType WHERE Name='Dependancy' AND sObjectType='Task_Relationship__c'];
        Task_Relationship__c newTR = new Task_Relationship__c ();
        newTR.Child_Task_ID__c = childID;
        newTR.Parent_Task_ID__c = parentID;
        if(rType != null){
            newTR.RecordTypeID = rType[0].ID;
        }
        insert newTR;
        return newTR;
    }
}