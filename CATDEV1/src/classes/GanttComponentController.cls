/*
@Name           : GanttComponentController
@Author         : customersuccess@cloud62.com
@Date           : 4/22/2013
@Description    : Controller for GanttComponent
*/
public with sharing class GanttComponentController{
    //Variables
    public String strDataType {get;set;}
    public String strPBSTitle {get;set;}
    public String strMasterValue {get;set{
                                    strMasterValue = value;
                                    init();}
                                 }
    
    public List<Task> lstTasks {get;set;}
    public List<Task> lstSubTasks {get;set;}
    public Map<String,Task> mapSubTasks {get;set;}
    public Map<String,List<Task>> mapParentTasks {get;set;}
    public String strId {get;set;}
    public Id rId {get;set;}
    public String strObjName {get;set;}
    public String strJsonGantt {get;set;}
    public String strSave{get;set;}
    
    public String strJSON {get;set;}
    public String strJSONSave {get;set;}
    public Map<Id,Task> mapTasks {get;set;}
    
    
    public GanttComponentController(){
        //Use IE9 compatability due to errors in ie10 rendering
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=9');
    }
    
    public class JSONTask{
        public String id;
        public String subject;
        public String recordId;
        public Integer level;
        public String status;
        public Long startTime;
        public Integer duration;
        public Long endTime;
        public Boolean startIsMilestone;
        public Boolean endIsMilestone;
        public String assignedTo;
        public String depends;
    }
    
    public class JSON2Apex{
        public List<JSONTask> tasks;
        public Integer selectedRow;
        public List<String> deletedTaskIds;
        public Boolean canWrite;
        public Boolean canWriteOnParent;
    }
    
    public void init(){
        if(strMasterValue != null && strDataType != null){
            strId = strMasterValue;
            if(strDataType == 'Product' || strDataType == 'Project'){
                initProdProj();
            } else if(strDataType == 'ProductRoadmap'){
                initProdRM();
            }
        } else {
            JSON2Apex jsa = new JSON2Apex();
            jsa.tasks = new List<JSONTask>();
            strJSON = JSON.serialize(jsa);
            strJSON = strJSON.replaceAll('startTime','start');
            strJSON = strJSON.replaceAll('endTime','end');
        }
    }
    
    public void initProdProj(){
        if(strDataType == 'Product'){
            mapTasks = new Map<Id,Task>([SELECT Id, Health__c, Start_Date__c, End_Date__c, Description, OwnerID, Owner.Name, Subject, WhatId   
                         FROM Task WHERE RecordType.Name = 'Product' 
                         and whatId = :strId 
                         order by Start_Date__c ASC]);
        } else if(strDataType == 'Project'){
            mapTasks = new Map<Id,Task>([SELECT Id, Health__c, Start_Date__c, End_Date__c, Description, OwnerID, Owner.Name, Subject, WhatId  
                         FROM Task WHERE RecordType.Name = 'Project' 
                         and whatId = :strId and Start_Date__c!=null and End_Date__c!=null 
                         order by Start_Date__c ASC]);
        }
        Set<Id> setPorC = new Set<Id>();
        Map<Id,List<Id>> mapParentChilds = new Map<Id,List<Id>>();
        List<Task_Relationship__c> lstPCTRs = [SELECT Id,Child_Task_ID__c,Parent_Task_ID__c 
                                                FROM Task_Relationship__c 
                                                WHERE RecordType.Name = 'Parent Child' 
                                                AND Parent_Task_ID__c IN :mapTasks.keySet() 
                                                AND Child_Task_ID__c IN :mapTasks.keySet()];
        for(Task_Relationship__c tr : lstPCTRs){
            setPorC.add(tr.Child_Task_ID__c);
            setPorC.add(tr.Parent_Task_ID__c);
            if(mapParentChilds.get(tr.Parent_Task_ID__c) == null){
                List<Id> lstIds = new List<Id>();
                lstIds.add(tr.Child_Task_ID__c);
                mapParentChilds.put(tr.Parent_Task_ID__c,lstIds);
            } else {
                mapParentChilds.get(tr.Parent_Task_ID__c).add(tr.Child_Task_ID__c);
            }
        }
        for(Id pId : mapParentChilds.keySet()){
            List<Id> lstSortIds = mapParentChilds.get(pId);
            for(Integer i = 0; i < lstSortIds.size() - 1;i++){
                for(Integer j = i + 1; j < lstSortIds.size();j++){
                    if(mapTasks.get(lstSortIds.get(i)).Start_Date__c < mapTasks.get(lstSortIds.get(j)).Start_Date__c){
                        Id tempId = lstSortIds.get(i);
                        lstSortIds.set(i,lstSortIds.get(j));
                        lstSortIds.set(j,tempId);
                    }
                }
            }
        }
        Map<Id,List<Id>> mapDependants = new Map<Id,List<Id>>();
        List<Task_Relationship__c> lstDepTRs = [SELECT Id,Child_Task_ID__c,Parent_Task_ID__c 
                                                FROM Task_Relationship__c 
                                                WHERE RecordType.Name = 'Dependancy' 
                                                AND Child_Task_ID__c IN :mapTasks.keySet() 
                                                AND Parent_Task_ID__c IN :mapTasks.keySet()];
        for(Task_Relationship__c tr : lstDepTRs){
            if(mapDependants.get(tr.Child_Task_ID__c) == null){
                List<Id> lstIds = new List<Id>();
                lstIds.add(tr.Parent_Task_ID__c);
                mapDependants.put(tr.Child_Task_ID__c,lstIds);
            } else {
                mapDependants.get(tr.Child_Task_ID__c).add(tr.Parent_Task_ID__c);
            }
        }
        JSON2Apex jsa = new JSON2Apex();
        jsa.tasks = new List<JSONTask>();
        jsa.selectedRow = 0;
        jsa.canWrite = true;
        jsa.canWriteOnParent = true;
        Integer intId = 1;
        Map<Id,String> mapIdPosition = new Map<Id,String>();
        Map<String,JSONTask> mapPositionTask = new Map<String,JSONTask>();
        List<Task> lstSortedTasks = mapTasks.values();
        for(Integer i = 0; i < lstSortedTasks.size() - 1;i++){
            for(Integer j = i + 1; j < lstSortedTasks.size();j++){
                if(lstSortedTasks.get(i).Start_Date__c < lstSortedTasks.get(j).Start_Date__c){
                    Task tempTsk = lstSortedTasks.get(i);
                    lstSortedTasks.set(i,lstSortedTasks.get(j));
                    lstSortedTasks.set(j,tempTsk);
                }
            }
        }
        for(Task tsk : lstSortedTasks){
            if(mapParentChilds.get(tsk.Id) != null){
                JSONTask jst = new JSONTask();
                jst.id = tsk.id;
                jst.subject = tsk.Subject;
                if(jst.subject != null) jst.subject = jst.subject.escapeHtml4();
                jst.recordId = tsk.id;
                jst.level = 1;
                if(tsk.Health__c == 'Green'){
                    jst.status = 'GREEN';
                } else if(tsk.Health__c == 'Yellow'){
                    jst.status = 'YELLOW';
                } else if(tsk.Health__c == 'Red'){
                    jst.status = 'RED';
                } else {
                    jst.status = 'NONE';
                }
                jst.startTime = DateTime.newInstanceGmt(tsk.Start_Date__c,Time.newInstance(0,0,0,0)).getTime();
                jst.endTime = DateTime.newInstanceGmt(tsk.End_Date__c,Time.newInstance(0,0,0,0)).getTime();
                jst.duration = daysBetweenHoliday(tsk.Start_Date__c,tsk.End_Date__c);
                jst.startIsMilestone = false;
                jst.endIsMilestone = false;
                jst.assignedTo = tsk.Owner.Name;
                jsa.tasks.add(jst);
                mapIdPosition.put(tsk.Id,String.valueOf(intId));
                mapPositionTask.put(String.valueOf(intId),jst);
                intId++;
                for(Id childId : mapParentChilds.get(tsk.Id)){
                    Task tskChild = mapTasks.get(childId);
                    if(tskChild != null){
                        JSONTask jstChild = new JSONTask();
                        jstChild.id = tskChild.id;
                        jstChild.subject = tskChild.Subject;
                        if(jstChild.subject != null) jstChild.subject = jstChild.subject.escapeHtml4();
                        jstChild.recordId = tskChild.id;
                        jstChild.level = 2;
                        if(tskChild.Health__c == 'Green'){
                            jstChild.status = 'GREEN';
                        } else if(tskChild.Health__c == 'Yellow'){
                            jstChild.status = 'YELLOW';
                        } else if(tskChild.Health__c == 'Red'){
                            jstChild.status = 'RED';
                        } else {
                            jstChild.status = 'NONE';
                        }
                        jstChild.startTime = DateTime.newInstanceGmt(tskChild.Start_Date__c,Time.newInstance(0,0,0,0)).getTime();
                        jstChild.endTime = DateTime.newInstanceGmt(tskChild.End_Date__c,Time.newInstance(0,0,0,0)).getTime();
                        jstChild.duration = daysBetweenHoliday(tskChild.Start_Date__c,tskChild.End_Date__c);
                        jstChild.startIsMilestone = false;
                        jstChild.endIsMilestone = false;
                        jstChild.assignedTo = tskChild.Owner.Name;
                        jsa.tasks.add(jstChild);
                        mapIdPosition.put(tskChild.Id,String.valueOf(intId));
                        mapPositionTask.put(String.valueOf(intId),jstChild);
                        intId++;
                    }
                }
            } else if(!setPorC.contains(tsk.Id)){
                JSONTask jst = new JSONTask();
                jst.id = tsk.id;
                jst.subject = tsk.Subject;
                if(jst.subject != null) jst.subject = jst.subject.escapeHtml4();
                jst.recordId = tsk.id;
                jst.level = 1;
                if(tsk.Health__c == 'Green'){
                    jst.status = 'GREEN';
                } else if(tsk.Health__c == 'Yellow'){
                    jst.status = 'YELLOW';
                } else if(tsk.Health__c == 'Red'){
                    jst.status = 'RED';
                } else {
                    jst.status = 'NONE';
                }
                if(tsk.Start_Date__c != null){
                    jst.startTime = DateTime.newInstanceGmt(tsk.Start_Date__c,Time.newInstance(0,0,0,0)).getTime();
                } else {
                    jst.startTime = DateTime.newInstanceGmt(Date.Today(),Time.newInstance(0,0,0,0)).getTime();
                }
                if(tsk.End_Date__c != null){
                    jst.endTime = DateTime.newInstanceGmt(tsk.End_Date__c,Time.newInstance(0,0,0,0)).getTime();
                } else {
                    jst.endTime = DateTime.newInstanceGmt(Date.Today(),Time.newInstance(0,0,0,0)).getTime();
                }
                jst.duration = daysBetweenHoliday(tsk.Start_Date__c,tsk.End_Date__c);
                jst.startIsMilestone = false;
                jst.endIsMilestone = false;
                jst.assignedTo = tsk.Owner.Name;
                jsa.tasks.add(jst);
                mapIdPosition.put(tsk.Id,String.valueOf(intId));
                mapPositionTask.put(String.valueOf(intId),jst);
                intId++;
            }
        }
        //Set up the dependancies, they are set up in the json by position in the list
        for(Id dependantId : mapDependants.keySet()){
            JSONTask jstDependant = mapPositionTask.get(mapIdPosition.get(dependantId));
            String strDependancies = '';
            for(Id independantId : mapDependants.get(dependantId)){
                if(strDependancies == ''){
                    strDependancies = String.valueOf(mapIdPosition.get(independantId));
                } else {
                    strDependancies += ',' + mapIdPosition.get(independantId);
                }
            }
            jstDependant.depends = strDependancies;
        }
        
        strJSON = JSON.serialize(jsa);
        strJSON = strJSON.replaceAll('startTime','start');
        strJSON = strJSON.replaceAll('endTime','end');
    }
    
    //Initialize the chart items for the Product Roadmap page
    public void initProdRM(){
        JSON2Apex jsa = new JSON2Apex();
        jsa.tasks = new List<JSONTask>();
        jsa.selectedRow = 0;
        jsa.canWrite = false;
        jsa.canWriteOnParent = false;
        if(strMasterValue != null){
             List<Product__c> lstProds = [SELECT Id, Name,Internal_External__c,Health__c, 
                                            Commercialization_Level__c,Ship_Date__c,Start_Date__c,Dev_Complete_Date__c,
                                                (SELECT Id, Project__c,Project__r.Start_Date__c,Project__r.Target_Finish__c,Project__r.Name,Project__r.Health__c 
                                                    FROM Product_Projects__r 
                                                    ORDER BY Project__r.Start_Date__c ASC)  
                                            from Product__c 
                                            where Product_Family__c=:strMasterValue 
                                            Order by Internal_External__c,Commercialization_Level__c];
                                            
            Integer intCount = 0;
            for(Product__c prod : lstProds){
                JSONTask jst = new JSONTask();
                jst.id = String.valueOf(intCount++);
                jst.subject = prod.Name;
                if(jst.subject != null) jst.subject = jst.subject.escapeHtml4();
                jst.recordId = prod.id;
                jst.level = 1;
                if(prod.Health__c == 'Green'){
                    jst.status = 'GREEN';
                } else if(prod.Health__c == 'Yellow'){
                    jst.status = 'YELLOW';
                } else if(prod.Health__c == 'Red'){
                    jst.status = 'RED';
                } else {
                    jst.status = 'NONE';
                }
                if(prod.Start_Date__c != null){
                    jst.startTime = DateTime.newInstanceGmt(prod.Start_Date__c,Time.newInstance(0,0,0,0)).getTime();
                } else {
                    jst.startTime = DateTime.newInstanceGmt(Date.Today(),Time.newInstance(0,0,0,0)).getTime();
                }
                if(prod.Start_Date__c != null && prod.Ship_Date__c != null)
                    jst.duration = daysBetweenHoliday(prod.Start_Date__c,prod.Ship_Date__c);
                jst.startIsMilestone = false;
                jst.endIsMilestone = false;
                jsa.tasks.add(jst);
                
                //Display the projects for the product by start date
                for(Product_Project__c pp : prod.Product_Projects__r){
                    JSONTask jst1 = new JSONTask();
                    jst1.id = String.valueOf(intCount++);
                    jst1.subject = pp.Project__r.Name;
                    if(jst1.subject != null) jst1.subject = jst1.subject.escapeHtml4();
                    jst1.recordId = pp.Project__c;
                    jst1.level = 2;
                    if(pp.Project__r.Health__c == 'Green'){
                        jst1.status = 'GREEN';
                    } else if(pp.Project__r.Health__c == 'Yellow'){
                        jst1.status = 'YELLOW';
                    } else if(pp.Project__r.Health__c == 'Red'){
                        jst1.status = 'RED';
                    } else {
                        jst1.status = 'NONE';
                    }
                    if(pp.Project__r.Start_Date__c != null){
                        jst1.startTime = DateTime.newInstanceGmt(pp.Project__r.Start_Date__c,Time.newInstance(0,0,0,0)).getTime(); 
                    } else {
                        jst1.startTime = DateTime.newInstanceGmt(Date.Today(),Time.newInstance(0,0,0,0)).getTime(); 
                    }
                    if(pp.Project__r.Start_Date__c != null && pp.Project__r.Target_Finish__c != null)
                    jst1.duration = daysBetweenHoliday(pp.Project__r.Start_Date__c,pp.Project__r.Target_Finish__c);
                    jst1.startIsMilestone = false;
                    jst1.endIsMilestone = false;
                    jsa.tasks.add(jst1); 
                }
            }
        }
        strJSON = JSON.serialize(jsa);
        strJSON = strJSON.replaceAll('startTime','start');
        strJSON = strJSON.replaceAll('endTime','end');
    }
    
    //The grid calculates the end date based on the duration and skips holidays and weekends when calculating the duration
    //See file i18nJs.js for isHoliday javascript method
    private Integer daysBetweenHoliday(Date dtStart, Date dtEnd){
        Integer intDays = 0;
        Set<Date> setDateHolidays = new Set<Date>();
        setDateHolidays.add(Date.newInstance(2010,4,5));
        setDateHolidays.add(Date.newInstance(2010,10,19));
        setDateHolidays.add(Date.newInstance(2010,5,15));
        setDateHolidays.add(Date.newInstance(2011,4,4));
        Set<String> setMDHolidays = new Set<String>();
        setMDHolidays.add('1_1');
        setMDHolidays.add('4_25');
        setMDHolidays.add('8_15');
        setMDHolidays.add('11_1');
        setMDHolidays.add('12_25');
        setMDHolidays.add('12_26');
        setMDHolidays.add('6_2');
        setMDHolidays.add('12_8');
        setMDHolidays.add('5_1');
        Date dtMonday = Date.newInstance(1900,1,1);
        if(dtStart != null && dtEnd != null && dtStart < dtEnd){
            while(dtStart <= dtEnd){
                String md = dtStart.month() + '_' + dtStart.day();
                Integer weekday = Math.mod(dtMonday.daysBetween(dtStart), 7);
                if(!setDateHolidays.contains(dtStart) && !setMDHolidays.contains(md) && 
                    weekday != 5 && weekday != 6){
                    intDays++;
                }
                dtStart = dtStart.addDays(1);
            }
        }
        return intDays;
    }
    
    public PageReference newTask(){
        return new PageReference('/00T/e?CF00NZ0000000eFod=testing&what_id='+strId+'&retURL='+strId+'&RecordType='+rID);
    }
      
    //Return the map of 3 character id prefixes to the sObject api name for that prefix
    private static Map<String,String> getPrefixMap(){
        //Get a map of the prefixes to tell the object based on the id
        Map<String,String> mapPrefix = new Map<String,String>();
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
        Set<String> keyPrefixSet = gd.keySet();
        for(String sObj : keyPrefixSet){
           Schema.DescribeSObjectResult r =  gd.get(sObj).getDescribe();
           String tempName = r.getName();
           String tempPrefix = r.getKeyPrefix();
           mapPrefix.put(tempPrefix,tempName);
        }
        return mapPrefix;
    }
    
    public PageReference saveTasks(){
        System.debug('strJSONSave = ' + strJSONSave);
        strJSONSave = strJSONSave.replaceAll('\"end\"','\"endTime\"');
        strJSONSave = strJSONSave.replaceAll('\"start\"','\"startTime\"');
        JSON2Apex jsa = (JSON2Apex) JSON.deserialize(strJSONSave,JSON2Apex.class);
        System.debug('jsasave = ' + jsa);
        List<Task> lstUpsertTasks = new List<Task>();
        Integer intPos = 1;
        Map<Integer,Task> mapPosTasks = new Map<Integer,Task>();
        Map<Integer,JSONTask> mapPOSJSONT = new Map<Integer,JSONTask>();
        RecordType rtProduct = [SELECT Id,Name FROM RecordType WHERE Name = 'Product' AND sObjectType = 'Task'];
        RecordType rtProject = [SELECT Id,Name FROM RecordType WHERE Name = 'Project' AND sObjectType = 'Task'];
        //Delete the tasks in the delete list
        Set<Id> setTaskDeletes = new Set<Id>();
        for(String strId : jsa.deletedTaskIds){
            setTaskDeletes.add(strId);
        }
        delete new List<Task>([SELECT Id FROM Task WHERE Id IN :setTaskDeletes]);
        //Convert all of the JSONTasks to sf tasks
        for(JSONTask jst : jsa.tasks){
            //Use the existing task from the map when it was loaded and update it or create a new one
            Task tsk;
            if(mapTasks.get(jst.recordId) != null){
                tsk = mapTasks.get(jst.recordId);
            } else {
                tsk = new Task();
                tsk.WhatId = strMasterValue;
            }
            //Set the record type
            if(strDataType == 'Product'){
                tsk.RecordTypeId = rtProduct.Id;
            } else if(strDataType == 'Project'){
                tsk.RecordTypeId = rtProject.Id;
            }
            //Set the health color
            if(jst.status == 'GREEN' || jst.status == 'STATUS_ACTIVE'){
                tsk.Health__c = 'Green';
            } else if(jst.status == 'YELLOW'){
                tsk.Health__c = 'Yellow';
            } else if(jst.status == 'RED'){
                tsk.Health__c = 'Red';
            } else {
                tsk.Health__c = null;
            }
            tsk.Subject = jst.subject;
            DateTime dtStart = DateTime.newInstance(jst.startTime);
            DateTime dtEnd = DateTime.newInstance(jst.endTime);
            tsk.Start_Date__c = Date.newInstance(dtStart.year(),dtStart.month(),dtStart.day());
            tsk.End_Date__c = Date.newInstance(dtEnd.year(),dtEnd.month(),dtEnd.day());
            lstUpsertTasks.add(tsk);
            mapPosTasks.put(intPos,tsk);
            mapPosJSONT.put(intPos,jst);
            intPos++;
            System.debug(jst);
            System.debug(tsk);
        }
        //Save the tasks so we can use the id's for the relationships
        for(Task t : lstUpsertTasks)
        system.debug(t);
        upsert lstUpsertTasks;
        //Get the maps of parent childs and dependants
        Map<Id,Set<Id>> mapParentChild = new Map<Id,Set<Id>>();
        Map<Id,Set<Id>> mapDependants = new Map<Id,Set<Id>>();
        for(Integer pos : mapPosJSONT.keySet()){
            JSONTask jst = mapPosJSONT.get(pos);
            Task tsk = mapPosTasks.get(pos);
            if(jst.depends != null && jst.depends != ''){
                Set<Id> setIds = new Set<Id>();
                for(String strPos : jst.depends.split(',')){
                    setIds.add(mapPosTasks.get(Integer.valueOf(strPos)).Id);
                }
                mapDependants.put(tsk.Id,setIds);
            }
            if(jst.level == 1){
                Set<Id> setIds = new Set<Id>();
                Integer next = pos + 1;
                Boolean bolEnd = false;
                while(next <= mapPosJSONT.size() && !bolEnd){
                    if(mapPosJSONT.get(next) != null && mapPosJSONT.get(next).level > 1){
                        setIds.add(mapPosTasks.get(next).Id);
                    } else {
                        bolEnd = true;
                    }
                    next++;
                }
                if(setIds.size() > 0){
                    mapParentChild.put(tsk.Id,setIds);
                }
            }
        }
        //Create the realtionship if it doesn't exist already
        System.debug('mapparentchild = ' + mapParentChild);
        System.debug('mapDependants = ' + mapDependants);
        List<Task_Relationship__c> setTRInsert = new List<Task_Relationship__c>();
        List<Task_Relationship__c> setTRDelete = new List<Task_Relationship__c>();
        Map<Id,Task> mapExistObjTasks = new Map<Id,Task>([SELECT Id, WhatId FROM Task WHERE WhatId = :strId]);
        List<Task_Relationship__c> lstPCExist = [SELECT Id, Child_Task_ID__c, Parent_Task_ID__c 
                                                    FROM Task_Relationship__c 
                                                    WHERE Parent_Task_ID__c IN :mapExistObjTasks.keySet() 
                                                    AND RecordType.Name = 'Parent Child'];
        Map<Id,Set<Id>> mapPCExist = new Map<Id,Set<Id>>();
        for(Task_Relationship__c tr : lstPCExist){
            if(mapPCExist.get(tr.Parent_Task_ID__c) == null){
                Set<Id> setIds = new Set<Id>();
                setIds.add(tr.Child_Task_ID__c);
                mapPCExist.put(tr.Parent_Task_ID__c,setIds);
            } else {
                mapPCExist.get(tr.Parent_Task_ID__c).add(tr.Child_Task_ID__c);
            }
        }
        List<Task_Relationship__c> lstDepExist = [SELECT Id, Child_Task_ID__c, Parent_Task_ID__c 
                                                    FROM Task_Relationship__c 
                                                    WHERE Child_Task_ID__c IN :mapExistObjTasks.keySet() 
                                                    AND RecordType.Name = 'Dependancy'];
        Map<Id,Set<Id>> mapDepExist = new Map<Id,Set<Id>>();
        for(Task_Relationship__c tr : lstDepExist){
            if(mapDepExist.get(tr.Child_Task_ID__c) == null){
                Set<Id> setIds = new Set<Id>();
                setIds.add(tr.Parent_Task_ID__c);
                mapDepExist.put(tr.Child_Task_ID__c,setIds);
            } else {
                mapDepExist.get(tr.Child_Task_ID__c).add(tr.Parent_Task_ID__c);
            }
        }
        RecordType rtPC = [SELECT Id, Name 
                            FROM RecordType 
                            WHERE Name = 'Parent Child'];
        RecordType rtDep = [SELECT Id, Name 
                            FROM RecordType 
                            WHERE Name = 'Dependancy'];                    
        //System.debug('mapPCExist = ' + mapPCExist);
        for(Id pId : mapParentChild.keySet()){
            if(mapPCExist.get(pId) != null){
                for(Id cId : mapParentChild.get(pId)){
                    if(!mapPCExist.get(pId).contains(cId)){ 
                        Task_Relationship__c tr = new Task_Relationship__c();
                        tr.Child_Task_ID__c = cId;
                        tr.Parent_Task_ID__c = pId;
                        tr.RecordTypeId = rtPC.Id;
                        setTRInsert.add(tr);
                    }
                }
            } else {
                for(Id cId : mapParentChild.get(pId)){
                    Task_Relationship__c tr = new Task_Relationship__c();
                    tr.Child_Task_ID__c = cId;
                    tr.Parent_Task_ID__c = pId;
                    tr.RecordTypeId = rtPC.Id;
                    setTRInsert.add(tr);
                }
            }
        }
        System.debug('mapDepExist = ' + mapDepExist);
        for(Id cId : mapDependants.keySet()){
            System.debug('does exist1 = ' + mapDepExist.get(cId));
            if(mapDepExist.get(cId) != null){
                for(Id pId : mapDependants.get(cId)){
                    System.debug('does exist2 = ' + !mapDepExist.get(cId).contains(pId));
                    if(!mapDepExist.get(cId).contains(pId)){
                        Task_Relationship__c tr = new Task_Relationship__c();
                        tr.Child_Task_ID__c = cId;
                        tr.Parent_Task_ID__c = pId;
                        tr.RecordTypeId = rtDep.Id;
                        setTRInsert.add(tr);
                    }
                }
            } else {
                for(Id pId : mapDependants.get(cId)){
                    System.debug('does exist3');
                    Task_Relationship__c tr = new Task_Relationship__c();
                    tr.Child_Task_ID__c = cId;
                    tr.Parent_Task_ID__c = pId;
                    tr.RecordTypeId = rtDep.Id;
                    setTRInsert.add(tr);
                }
            }
        }
        //Delete the relationships that do not exist anymore
        for(Task_Relationship__c trPCExist : lstPCExist){
            if(mapParentChild.keySet().contains(trPCExist.Parent_Task_ID__c) 
                && !mapParentChild.get(trPCExist.Parent_Task_ID__c).contains(trPCExist.Child_Task_ID__c))
            {
                setTRDelete.add(trPCExist);    
            } else if(!mapParentChild.keySet().contains(trPCExist.Parent_Task_ID__c)){
                setTRDelete.add(trPCExist);
            }
        }
        System.debug('lstdepexist = ' + lstDepExist);
        System.debug('mapdendants = ' + mapDependants);
        for(Task_Relationship__c trDepExist : lstDepExist){
            System.debug('deletecheck = ' + trDepExist.Child_Task_ID__c + ' : ' + trDepExist.Parent_Task_ID__c);
            if(mapDependants.keySet().contains(trDepExist.Child_Task_ID__c) 
                && !mapDependants.get(trDepExist.Child_Task_ID__c).contains(trDepExist.Parent_Task_ID__c))
            {
                setTRDelete.add(trDepExist);
            } else if(!mapDependants.keySet().contains(trDepExist.Child_Task_ID__c)){
                setTRDelete.add(trDepExist);
            }
        }
        insert new List<Task_Relationship__c>(setTrInsert);
        delete new List<Task_Relationship__c>(setTrDelete);
        return null;
    }
    
    /*public PageReference saveTasks(){
        try{          
            if(strSave != null){
                List<Task> taskUpdateList = new List<Task>();
                String[] splitString = strSave.split('}');
                List<String> parentId = new List<String>();
                Integer i = 0;
                for (String s : splitString){ 
                    system.debug('splitString>>'+s);                    
                    for(Task t : lstTasks){
                        if(s.contains(t.id)){                        
                            String[] splitStr = s.split(',');
                            for (String str : splitStr){
                                if(str.startsWith('"name"')){
                                    t.Subject=str.subString(str.indexOf('"name":')+8,str.length()-1);
                                }
                                if(str.startsWith('"start"')){
                                    Double strtDate = Double.ValueOf(str.subString(str.indexOf('"start":')+8,str.length()))/1000;
                                    DateTime dt = DateTime.newInstance(1970,1,1,0,0,0).addSeconds(strtDate.intValue());
                                    t.Start_Date__c=dt.date();
                                }
                                if(str.startsWith('"end"')){
                                    Double endDate = Double.ValueOf(str.subString(str.indexOf('"end":')+6,str.length()))/1000;
                                    DateTime dt = DateTime.newInstance(1970,1,1,0,0,0).addSeconds(endDate.intValue());
                                    t.End_Date__c=dt.date();
                                }    
                            }
                            taskUpdateList.add(t);
                            parentId.add(t.Id);
                        }
                    }
                    if(s.contains('tmp_13')){
                        Task tsk = new Task();                        
                        String[] splitStr = s.split(',');
                        for (String str : splitStr){
                            system.debug('str>>'+str);
                            if(str.startsWith('"name"')){
                                tsk.Subject=str.subString(str.indexOf('"name":')+8,str.length()-1);
                                parentId.add(tsk.Subject+String.valueof(i));
                            }
                            if(str.startsWith('"start"')){
                                Double strtDate = Double.ValueOf(str.subString(str.indexOf('"start":')+8,str.length()))/1000;
                                DateTime dt = DateTime.newInstance(1970,1,1,0,0,0).addSeconds(strtDate.intValue());
                                tsk.Start_Date__c=dt.date();
                            }
                            if(str.startsWith('"end"')){
                                Double endDate = Double.ValueOf(str.subString(str.indexOf('"end":')+6,str.length()))/1000;
                                DateTime dt = DateTime.newInstance(1970,1,1,0,0,0).addSeconds(endDate.intValue());
                                tsk.End_Date__c=dt.date();
                            }  
                            tsk.RecordTypeId=rID;  
                            tsk.WhatId=strId;
                            for(Integer j=0; j<parentId.size(); j++){
                                if(parentId[j]==tsk.Subject+String.valueof(i)){
                                    tsk.TaskRelationshipParentId__c = parentId[j-1];    
                                }
                            }
                            //tsk.TaskRelationshipParentId__c = parentId; 
                            system.debug('parentId>'+parentId); 
                        }
                        //if(tsk.Subject!=null || tsk.Subject!=''){
                            taskUpdateList.add(tsk);
                        //}
                    }
                }
                upsert taskUpdateList;
                system.debug('taskUpdateList>'+taskUpdateList);
                List<Task_Relationship__c> tRelList = new List<Task_Relationship__c>();
                for(Task t : taskUpdateList){
                    if(t.TaskRelationshipParentId__c!=null){
                        Task_Relationship__c tr = new Task_Relationship__c();
                        tr.Child_Task_ID__c = t.Id;
                        tr.Parent_Task_ID__c = t.TaskRelationshipParentId__c;
                        tRelList.add(tr);
                    }
                }
                upsert tRelList;
            }
        }
        catch(Exception e){}
        return null;  
    }*/
    
    public PageReference doNothing(){
        return null;
    }
}