/*
@Name           : GanttGeneratorController
@Author         : customersuccess@cloud62.com
@Date           : 9/24/2012
@Description    : Controller for GanttGenerator
*/
public with sharing class GanttGeneratorController{
    //Variables
    public Map<Id,Product__c> mapProds {get;set;}
    public String prodId {get;set;}
    public List<ChartItem> lstChartItems {get;set;}
    
    //Constructor
    public GanttGeneratorController(){
        mapProds = new Map<Id,Product__c>([SELECT Id, Name, 
                    (SELECT Id, Health__c, Start_Date__c, End_Date__c, Task__c, Name, Owner__c, Owner__r.Name FROM Product_Tasks__r order by Start_Date__c ASC) 
                     FROM Product__c order by Name ASC]);
        prodId = ApexPages.currentPage().getParameters().get('prodId');
        createChartItems();
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
        if(prodId != null){
            lstChartItems = new List<ChartItem>();
            Integer i = 0;
            for(Product_Task__c pTask : mapProds.get(prodId).Product_Tasks__r){
                ChartItem chi = new ChartItem();
                chi.pID = String.valueOf(i);
                chi.pName = pTask.Name;
                chi.pStart = pTask.Start_Date__c.Month() + '/' + pTask.Start_Date__c.Day() + '/' + pTask.Start_Date__c.Year();
                chi.pEnd = pTask.End_Date__c.Month() + '/' + pTask.End_Date__c.Day() + '/' + pTask.End_Date__c.Year();
                chi.pColor = 'ff0000';
                chi.pLink = '';
                chi.pMile = 0;
                chi.pRes = pTask.Owner__r.Name;
                chi.pComp = 0;
                chi.pGroup = 0;
                chi.pParent = 0;
                chi.pOpen = 0;
                chi.pDepend = '';
                chi.pCaption = '';
                chi.pHealth = pTask.Health__c;
                lstChartItems.add(chi);
                i++;
            }
        }
    }
    
    public List<SelectOption> getProdOptions(){
        List<SelectOption> lstReturn = new List<SelectOption>();
        lstReturn.add(new SelectOption('--None--','--None--'));
        List<Product__c> lstProds = mapProds.values();
        lstProds.sort();
        for(Product__c p : lstProds){
            lstReturn.add(new SelectOption(p.Id,p.Name));
        }
        return lstReturn;
    }
}