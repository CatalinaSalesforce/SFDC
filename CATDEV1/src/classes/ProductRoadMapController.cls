/*
@Name           : ProductRoadMapController
@Author         : customersuccess@cloud62.com
@Date           : 11/2/2012
@Description    : Display Product and Tasks Roadmap
@Revision Hisotry: Shakti. 01/11/2013. Made code changes to reference the Task object instead of Product Task custom object
                    Product Task custom object is deprecated
                   Shakti. 1/17/2013. Removed Application__c custom object reference. Application__c object is deprecated.
                   Customersuccess@cloud62.com 2-11-2013: Modified to support Projects and Project Tasks and Project Releases
*/
public with sharing class ProductRoadMapController {
    public Product__c prod {get;set;}
    public List<ProjectChartItem> lstProjectItems {get;set;}
    public List<ChartItem> lstProdCItems {get;set;}
    public String strFeatures {get;set;}
    
    //Constructor
    public ProductRoadMapController(ApexPages.StandardController controller){
        prod = (Product__c) controller.getRecord();
        String query = 'SELECT Owner.Name,' + getFields('Task') + 
                       ' FROM Task' +
                       ' WHERE End_Date__c >= TODAY AND WhatId = \'' + prod.Id + '\' AND RecordType.Name = \'Product\'' +
                       ' Order By Start_Date__c asc';
        List<Task> pTasks = Database.query(query);
        lstProdCItems = getChartItems(pTasks);
        createFeatureString();
        createProjectChartItems();
    }
    
    public class ProjectChartItem{
        public Project__c project {get;set;}
        public List<ChartItem> lstTaskCIs {get;set;}
        public List<ChartItem> lstReleaseCIs {get;set;}
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
        15 pApplication: optional String with header value of Application
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
        public String pApplication {get;set;}
    }
    
    public List<ChartItem> getChartItems(List<Task> pTasks){
        List<ChartItem> lstReturn = new List<ChartItem>();
        Integer i = 0;
        for(Task pTask : pTasks){
            ChartItem chi = new ChartItem();
            chi.pID = String.valueOf(i);
            chi.pName = pTask.Subject;
            if(pTask.Start_Date__c != null && pTask.End_Date__c != null){
                chi.pStart = pTask.Start_Date__c.Month() + '/' + pTask.Start_Date__c.Day() + '/' + pTask.Start_Date__c.Year();
            }
            if(pTask.End_Date__c != null){
                chi.pEnd = pTask.End_Date__c.Month() + '/' + pTask.End_Date__c.Day() + '/' + pTask.End_Date__c.Year();
            }
            chi.pColor = '00008B';
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
            lstReturn.add(chi);
            i++;
        }
        return lstReturn;
    }  
    
    public List<ChartItem> getChartItems(List<Release__c> pTasks){
        List<ChartItem> lstReturn = new List<ChartItem>();
        Integer i = 0;
        for(Release__c pTask : pTasks){
            ChartItem chi = new ChartItem();
            chi.pID = String.valueOf(i);
            chi.pName = pTask.Name;
            if(pTask.Start_Date__c != null && pTask.End_Date__c != null){
                chi.pStart = pTask.Start_Date__c.Month() + '/' + pTask.Start_Date__c.Day() + '/' + pTask.Start_Date__c.Year();
            }
            if(pTask.End_Date__c != null){
                chi.pEnd = pTask.End_Date__c.Month() + '/' + pTask.End_Date__c.Day() + '/' + pTask.End_Date__c.Year();
            }
            chi.pColor = '00008B';
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
            lstReturn.add(chi);
            i++;
        }
        return lstReturn;
    }  
    
    public void createFeatureString(){
        List<Product_Feature_Link__c> lstPFLs = Database.query('SELECT Feature__r.Name,' + getFields('Product_Feature_Link__c') + ' FROM Product_Feature_Link__c WHERE Product__c = \'' + prod.Id + '\'');
        strFeatures = '';
        for(Product_Feature_Link__c pfl : lstPFLs){
            strFeatures += '<a href="/' + pfl.Feature__c + '">' + pfl.Feature__r.Name + '</a></br>';
        }
    }
    
    public void createProjectChartItems(){
        List<Product_Project__c> lstPP = Database.query('SELECT ' + getFields('Product_Project__c') + ' FROM Product_Project__c WHERE Product__c = \'' + prod.Id + '\'');
        String strProjIds = '';
        for(Integer i = 0; i < lstPP.size(); i++){
            if(i == 0){
                strProjIds += '\'' + lstPP.get(i).Project__c + '\'';
            } else {
                strProjIds += ',\'' + lstPP.get(i).Project__c + '\'';
            }
        }
        if(strProjIds.length() > 0){
            String query = 'SELECT ' + getFields('Project__c') + 
            ',(SELECT Owner.Name,' + getFields('Task') + ' FROM Tasks WHERE RecordType.Name = \'Project\' AND End_Date__c >= TODAY)' +
            ',(SELECT ' + getFields('Project_Release__c') + ' FROM Project_Releases__r)' +
            ' FROM Project__c' +
            ' WHERE Id IN (' + strProjIds + ')';
            List<Project__c> lstProjs = Database.query(query);
            String strRelIds = '';
            for(Project__c proj : lstProjs){
                for(Integer i = 0; i < proj.Project_Releases__r.size(); i++){
                    if(strRelIds.length() == 0){
                        strRelIds += '\'' + proj.Project_Releases__r.get(i).Release__c + '\'';
                    } else {
                        strRelIds += ',\'' + proj.Project_Releases__r.get(i).Release__c + '\'';
                    }
                    System.debug(strRelIds);
                }
            }
            Map<Id,Release__c> mapRels = new Map<Id,Release__c>();
            if(strRelIds.length() > 0){
                String relsQuery = 'SELECT Owner.Name,' + getFields('Release__c') + ' FROM Release__c WHERE Id IN (' + strRelIds + ')';
                System.debug(relsQuery + '\n' + strRelIds);
                List<Release__c> lstRels = Database.query(relsQuery);
                mapRels = new Map<Id,Release__c>(lstRels);
            }
            lstProjectItems = new List<ProjectChartItem>();
            for(Project__c proj : lstProjs){
                ProjectChartItem pci = new ProjectChartItem();
                pci.project = proj;
                pci.lstTaskCIs = getChartItems(proj.Tasks);
                List<Release__c> lstReleases = new List<Release__c>();
                for(Project_Release__c pr : proj.Project_Releases__r){
                    if(mapRels.get(pr.Release__c) != null){
                        lstReleases.add(mapRels.get(pr.Release__c));
                    }
                }
                pci.lstReleaseCIs = getChartItems(lstReleases);
                lstProjectItems.add(pci);
            }
        }
    }
    
    //Returns the list of fields for a given object as comma seperated string
    public static String getFields(String strSObjectName) {
        SObjectType sot = Schema.getGlobalDescribe().get(strSObjectName);
        if (sot == null) return null;
        List<Schema.SObjectField> lstFields = sot.getDescribe().fields.getMap().values();
        String strReturn = '';
        for(Integer i = 0; i < lstFields.size(); i++){
           if(i == lstFields.size() - 1){
               strReturn += lstFields.get(i).getDescribe().LocalName;
           } else {
               strReturn += lstFields.get(i).getDescribe().LocalName + ',';
           }
        } 
        return strReturn;
    }
}