/*
@Name            : AfterInsertTrg 
@Author          : customersuccess@cloud62.com
@Date            : December 12, 2012
@Description     : Creates shell tasks to be filled out
*/
trigger AfterInsertTrg on Product__c (after insert) {
    //create the shell tasks
    RecordType rt = [SELECT Id,Name FROM RecordType WHERE Name = 'Product' AND SObjectType = 'Task'];
    List<Task> lstTasks = new List<Task>();
    for(Product__c prod : Trigger.new){
        lstTasks.add(new Task(Subject = 'Develop Business Case',WhatId =  prod.Id,RecordTypeId = rt.Id,Start_Date__c = Date.Today(),End_Date__c = Date.Today().addDays(7)));
        lstTasks.add(new Task(Subject = 'Receive Business Case Approval',WhatId =  prod.Id,RecordTypeId = rt.Id,Start_Date__c = Date.Today(),End_Date__c = Date.Today().addDays(7)));
        lstTasks.add(new Task(Subject = 'Approve Budget',WhatId =  prod.Id,RecordTypeId = rt.Id,Start_Date__c = Date.Today(),End_Date__c = Date.Today().addDays(7)));
        lstTasks.add(new Task(Subject = 'Develop Marketing Plan',WhatId =  prod.Id,RecordTypeId = rt.Id,Start_Date__c = Date.Today(),End_Date__c = Date.Today().addDays(7)));
        lstTasks.add(new Task(Subject = 'Develop and Test Product',WhatId =  prod.Id,RecordTypeId = rt.Id,Start_Date__c = Date.Today(),End_Date__c = Date.Today().addDays(7)));
        lstTasks.add(new Task(Subject = 'Develop Operations Plan',WhatId =  prod.Id,RecordTypeId = rt.Id,Start_Date__c = Date.Today(),End_Date__c = Date.Today().addDays(7)));
        lstTasks.add(new Task(Subject = 'Develop Marketing Collateral',WhatId =  prod.Id,RecordTypeId = rt.Id,Start_Date__c = Date.Today(),End_Date__c = Date.Today().addDays(7)));
        lstTasks.add(new Task(Subject = 'Develop Sales Collateral',WhatId =  prod.Id,RecordTypeId = rt.Id,Start_Date__c = Date.Today(),End_Date__c = Date.Today().addDays(7)));
        lstTasks.add(new Task(Subject = 'Legal Review',WhatId =  prod.Id,RecordTypeId = rt.Id,Start_Date__c = Date.Today(),End_Date__c = Date.Today().addDays(7)));
        lstTasks.add(new Task(Subject = 'Develop Sales Compensation Plan',WhatId =  prod.Id,RecordTypeId = rt.Id,Start_Date__c = Date.Today(),End_Date__c = Date.Today().addDays(7)));
        lstTasks.add(new Task(Subject = 'Conduct Ops/Sales Training',WhatId =  prod.Id,RecordTypeId = rt.Id,Start_Date__c = Date.Today(),End_Date__c = Date.Today().addDays(7)));
        lstTasks.add(new Task(Subject = 'Generate Operational Reports',WhatId =  prod.Id,RecordTypeId = rt.Id,Start_Date__c = Date.Today(),End_Date__c = Date.Today().addDays(7)));
        }
    insert lstTasks;
}