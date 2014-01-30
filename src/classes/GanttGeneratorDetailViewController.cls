/*
@Name           : GanttGeneratorDetailViewController
@Author         : customersuccess@cloud62.com
@Date           : 9/24/2012
@Description    : Controller for GanttGeneratorDetailView
@Revision Hisotry: Shakti. 01/11/2013. Made code changes to reference the Task object instead of Product Task custom object
                    Product Task custom object is deprecated
2-9-2013 customersuccess@cloud62.com: Modified to use Product__c or Project__c based on the Id
*/
public with sharing class GanttGeneratorDetailViewController{
    //Variables
    public List<Task> lstTasks {get;set;}
    public String strId {get;set;}
    public List<ChartItem> lstChartItems {get;set;}
    public Id rId {get;set;}
    public String strObjName {get;set;}
    
    //Constructor
    public GanttGeneratorDetailViewController(ApexPages.StandardController controller){
        strId = ApexPages.currentPage().getParameters().get('Id');
        lstTasks = new List<Task>();
        if(strId.length() == 15 || strId.length() == 18){
            String objName = getPrefixMap().get(strId.subString(0,3));
            sObject so;
            RecordType rType;
            if(objName == 'Product__c'){
                lstTasks = [SELECT Id, Health__c, Start_Date__c, End_Date__c, Description, OwnerID, Owner.Name, Subject 
                             FROM Task WHERE RecordType.Name = 'Product' 
                             and whatId = :strId 
                             order by Start_Date__c ASC];
                rType = [select id from RecordType where Name =:'Product' and IsActive = true and SobjectType =: 'Task' Limit 1];
                so = Database.query('SELECT Id,Name FROM Product__c WHERE Id = \'' + strId + '\'');
            } else if(objName == 'Project__c'){
                lstTasks = [SELECT Id, Health__c, Start_Date__c, End_Date__c, Description, OwnerID, Owner.Name, Subject 
                             FROM Task WHERE RecordType.Name = 'Project' 
                             and whatId = :strId 
                             order by Start_Date__c ASC];
                rType = [select id from RecordType where Name =:'Project' and IsActive = true and SobjectType =: 'Task' Limit 1];
                so = Database.query('SELECT Id,Name FROM Project__c WHERE Id = \'' + strId + '\'');
            }
            strObjName = String.valueOf(so.get('Name'));
            rID = rType.ID;
        }
        createChartItems();
    }
    
    public PageReference newTask(){
        return new PageReference('/00T/e?CF00NZ0000000eFod='+strObjName+'&what_id='+strId+'&retURL='+strId+'&RecordType='+rID);
    }
    
    public class ChartItem{
        /*
        TaskItem(pID, pName, pStart, pEnd, pColor, pLink, pMile, pRes, pComp, pGroup, pParent, pOpen, pDepend)
        0 pID: (required) is a unique ID used to identify each row for parent functions and for setting dom id for hiding/showing
        1 pName: (required) is the task Label
        2 pStart: (required) the task start date, can enter empty date ('') for groups. You can also enter specific time (2/10/2008 12:00) for additional percision or half days.
        3 pEnd: (required) the task end date, can enter empty date ('') for groups
        4 pColor: (required) the html color for this task; e.g. '00ff00'
        5 pLink: (optional) any http link navigated to when task bar is clicked.
        6 pMile:(optional) represent a milestone
        7 pRes: (optional) resource name
        8 pComp: (required) completion percent
        9 pGroup: (optional) indicates whether this is a group(parent) - 0=NOT Parent; 1=IS Parent
        10 pParent: (required) identifies a parent pID, this causes this task to be a child of identified task
        11 pOpen: can be initially set to close folder when chart is first drawn
        12 pDepend: optional list of id's this task is dependent on ... line drawn from dependent to this item
        13 pCaption: optional caption that will be added after task bar if CaptionType set to "Caption"
        14 pHealth: optional String with header value of Health
        *You should be able to add items to the chart in realtime via javascript and issuing "g.Draw()" command.
        */
        public String pID {get;set;}
        public String pName {get;set;}
        public String pStart {get;set;}
        public String pEnd {get;set;}
        public String pColor {get;set;}
        public String pLink {get;set;}
        public Integer pMile {get;set;}
        public String pRes {get;set;}
        public Decimal pComp {get;set;}
        public Integer pGroup {get;set;}
        public Integer pParent {get;set;}
        public Integer pOpen {get;set;}
        public String pDepend {get;set;}
        public String pCaption {get;set;}
        public String pHealth {get;set;}
    }
    
    public void createChartItems(){
        if(lstTasks.size() > 0){
            lstChartItems = new List<ChartItem>();
            Integer i = 0;
            for(Task pTask : lstTasks){
                ChartItem chi = new ChartItem();
                chi.pID = String.valueOf(i);
                i++;
                chi.pName = pTask.Subject;
                if(pTask.Start_Date__c != null){
                    chi.pStart = pTask.Start_Date__c.Month() + '/' + pTask.Start_Date__c.Day() + '/' + pTask.Start_Date__c.Year();
                } else {
                    chi.pStart = null;
                }
                if(pTask.End_Date__c != null){
                    chi.pEnd = pTask.End_Date__c.Month() + '/' + pTask.End_Date__c.Day() + '/' + pTask.End_Date__c.Year();
                } else {
                    chi.pEnd = null;
                }
                chi.pColor = 'ff0000';
                chi.pLink = '/'+pTask.Id;
                chi.pMile = 0;
                chi.pRes = pTask.Owner.Name;
                chi.pComp = 0;
                chi.pGroup = 0;
                chi.pParent = 0;
                chi.pOpen = 0;
                chi.pDepend = '';
                chi.pCaption = '';
                chi.pHealth = pTask.Health__c;
                lstChartItems.add(chi);
            }
        }
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
}