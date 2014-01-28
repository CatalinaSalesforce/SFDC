/*
@Name           : ProductRoadMapByFamilyController
@Author         : customersuccess@cloud62.com
@Date           : 10/23/2012
@Description    : Display Product and Tasks Roadmap by Family
@Revision Hisotry: Shakti. 01/11/2013. Made code changes to reference the Task object instead of Product Task custom object
                    Product Task custom object is deprecated
                   Shakti. 1/17/2013. Removed Application__c custom object reference. Application__c object is deprecated.
*/
public with sharing class ProductRoadMapByFamilyController {
    public String prodFamily {get;set;} 
    public List<Product__c> products;
    public List<ProductWrapper> productsWrapperList{get;set;}
    public String firstQtrLbl{get;set;}
    public String secQtrLbl{get;set;}
    public String thirdQtrLbl{get;set;}
    public String forthQtrLbl{get;set;}
    public String fifthQtrLbl{get;set;}
    public String sixthQtrLbl{get;set;}
    public Integer firstQtrYear{get;set;}
    public Integer secQtrYear{get;set;}
    public Integer thirdQtrYear{get;set;}
    public Integer forthQtrYear{get;set;}
    public Integer fifthQtrYear{get;set;}
    public Integer sixthQtrYear{get;set;}    
    public Date quarterStartDate{get;set;}
    //release chart
    public List<ChartItem> releaseChartItems {get;set;}
    public List<Release__c> pReleases {get;set;}
    
     public ProductRoadMapByFamilyController(){
        calculateQuarterStartDate();
        system.debug('show quarterStartDate?'+quarterStartDate);
        //calculate quarters
        calcualteQuarters();
        //productReportByFamily();  
     }

    public ProductRoadMapByFamilyController(ApexPages.StandardController controller){
        calculateQuarterStartDate();
        system.debug('show quarterStartDate?'+quarterStartDate);
        //calculate quarters
        calcualteQuarters();
        //productReportByFamily();  
    }
         
    public void calcualteQuarters(){
        Date d = System.today();
        firstQtrLbl = 'Q'+getQuarterMonth(d.month())+'-'+d.year();
        firstQtrYear = d.year();
        d = d.addMonths(3);
        secQtrLbl = 'Q'+getQuarterMonth(d.month())+'-'+d.year();
        secQtrYear = d.year();
        d = d.addMonths(3);
        thirdQtrLbl = 'Q'+getQuarterMonth(d.month())+'-'+d.year();
        thirdQtrYear = d.year();
        d = d.addMonths(3);
        forthQtrLbl = 'Q'+getQuarterMonth(d.month())+'-'+d.year();
        forthQtrYear = d.year();
        d = d.addMonths(3);
        fifthQtrLbl = 'Q'+getQuarterMonth(d.month())+'-'+d.year();
        fifthQtrYear = d.year();
        d = d.addMonths(3);
        sixthQtrLbl = 'Q'+getQuarterMonth(d.month())+'-'+d.year();
        sixthQtrYear = d.year();
    }
    
    public Integer getQuarterMonth(Integer q){
        Integer m = 0;
        if(q == 1 || q == 2 || q == 3){
            m = 1;
        }else if(q == 4 || q == 5 || q == 6){
            m = 2;
        }else if(q == 7 || q == 8 || q == 9){
            m = 3;
        }else if(q == 10 || q == 11 || q == 12){
            m = 4;
        }
        
        return m;
    }
         
     public void productReportByFamily(){
        productsWrapperList = new List<ProductWrapper>();
        List<String> productsList = new List<String>();
        for(Product__c p: getProducts()){
            //if a Product don't have any task associated, don't show that Product
            if(p.Tasks.size()>0){
                Boolean flag = false;
                for(Task pt: p.Tasks){
                    if(pt.End_Date__c >= quarterStartDate){
                        flag = true;
                    }
                }
                if(flag){
                    productsWrapperList.add(new ProductWrapper(p, quarterStartDate));
                    productsList.add(p.Id);
                }   
            }
        }
        releaseChartItems = new List<ChartItem>();
        if(productsList.size()>0){
            system.debug('Product list??'+productsList);
            createReleaseChartItems(productsList);
        }
     }   

    public List<Product__c> getProducts(){
        return [SELECT Id, Name,Country__c, Executive_Sponsor__r.Name, OwnerId, Owner.Name, (select Id, Start_Date__c, End_Date__c, Subject FROM Tasks order by Start_Date__c) from Product__c where Product_Family__c=:prodFamily];
    }
    
         
    public List<SelectOption> getProdFamilyOptions(){
        List<SelectOption> lstReturn = new List<SelectOption>();
        lstReturn.add(new SelectOption('--None--','--None--'));
        Schema.DescribeFieldResult f = Schema.sObjectType.Product__c.fields.Product_Family__c;
        for(Schema.PicklistEntry p :f.getPicklistValues()){
            lstReturn.add(new SelectOption(p.getValue(),p.getLabel()));
        }
        return lstReturn;
    }
    
    public void calculateQuarterStartDate(){
            Date d = system.today();
            Integer m = 0;
            if(d.month() == 1 || d.month() == 2 || d.month() == 3){
                m = 1;
                quarterStartDate = Date.newInstance(d.Year(), 1, 1);
            }else if(d.month() == 4 || d.month() == 5 || d.month() == 6){
                m = 2;
                quarterStartDate = Date.newInstance(d.Year(), 4, 1);
            }else if(d.month() == 7 || d.month() == 8 || d.month() == 9){
                m = 3;
                quarterStartDate = Date.newInstance(d.Year(), 7, 1);
            }else if(d.month() == 10 || d.month() == 11 || d.month() == 12){
                quarterStartDate = Date.newInstance(d.Year(), 10, 1);
                m = 4;
            }
        }    
 
    public class ProductWrapper{
        public Product__c prod{get;set;}
        public String prodName{get;set;}
        public String country{get;set;}
        public String exe{get;set;}
        public String owner{get;set;}
        public String firstQtrtask{get;set;}
        public String secondQtrtask{get;set;}
        public String thirdQtrtask{get;set;}
        public String forthQtrtask{get;set;}
        public String fifthQtrtask{get;set;}
        public String sixthQtrtask{get;set;}
        public Date quarterStartDate{get;set;}
        
        public ProductWrapper(Product__c p, Date qsDate){
            this.prod = p;
            this.prodName = p.Name;
            this.country = p.Country__c;
            this.exe = p.Executive_Sponsor__r.Name;
            this.owner = p.Owner.Name;
            this.quarterStartDate  = qsDate;
            firstQtrtask = '';
            secondQtrtask = '';
            thirdQtrtask = '';
            forthQtrtask = '';
            fifthQtrtask = '';
            sixthQtrtask = '';
            calculateQtrTask();
            cleanCommas();
        }
        
        public void cleanCommas(){
            if(firstQtrtask.length()>0 && firstQtrtask.endsWith(',')){
                firstQtrtask = firstQtrtask.substring(0, firstQtrtask.length()-1);
            }
            if(secondQtrtask.length()>0 && secondQtrtask.endsWith(',')){
                secondQtrtask = secondQtrtask.substring(0, secondQtrtask.length()-1);
            }
            if(thirdQtrtask.length()>0 && thirdQtrtask.endsWith(',')){
                thirdQtrtask = thirdQtrtask.substring(0, thirdQtrtask.length()-1);
            }
            if(forthQtrtask.length()>0 && forthQtrtask.endsWith(',')){
                forthQtrtask = forthQtrtask.substring(0, forthQtrtask.length()-1);
            }
            if(fifthQtrtask.length()>0 && fifthQtrtask.endsWith(',')){
                fifthQtrtask = fifthQtrtask.substring(0, fifthQtrtask.length()-1);
            }
            if(sixthQtrtask.length()>0 && sixthQtrtask.endsWith(',')){
                sixthQtrtask = sixthQtrtask.substring(0, sixthQtrtask.length()-1);
            }
        }
        
        
        public void calculateQtrTask(){
            for(Task pt: prod.Tasks){
                system.debug('show quarterStartDate?'+quarterStartDate);
                Date qDate  = quarterStartDate;
                if(pt.Start_Date__c!=null && (pt.Start_Date__c >= qDate || pt.End_Date__c >= qDate)){
                    integer ptaskMonth = pt.Start_Date__c.month();
                    integer ptaskYear = pt.Start_Date__c.year();
                    //if((pt.End_Date__c >= qDate && pt.End_Date__c < qDate.addMonths(3)) || (pt.Start_Date__c >= qDate && pt.Start_Date__c < qDate.addMonths(3))){
                    if(pt.End_Date__c >= qDate && pt.Start_Date__c < qDate.addMonths(3)){
                        firstQtrtask = firstQtrtask+pt.Subject+',';
                    }
                    system.debug('print date ?'+qDate);
                    qDate = qDate.addMonths(3);
                    //if(pt.End_Date__c >= qDate && pt.End_Date__c < qDate.addMonths(3) || (pt.Start_Date__c >= qDate && pt.Start_Date__c < qDate.addMonths(3))){
                    if(pt.End_Date__c >= qDate && pt.Start_Date__c < qDate.addMonths(3)){
                        secondQtrtask = secondQtrtask+pt.Subject+',';
                    }
                    qDate = qDate.addMonths(3);
                    //if(pt.End_Date__c >= qDate && pt.End_Date__c < qDate.addMonths(3) || (pt.Start_Date__c >= qDate && pt.Start_Date__c < qDate.addMonths(3))){
                    if(pt.End_Date__c >= qDate && pt.Start_Date__c < qDate.addMonths(3)){
                        thirdQtrtask = thirdQtrtask+pt.Subject+',';
                    }                                       
                    qDate = qDate.addMonths(3);
                    //if(pt.End_Date__c >= qDate && pt.End_Date__c < qDate.addMonths(3) || (pt.Start_Date__c >= qDate && pt.Start_Date__c < qDate.addMonths(3))){
                    if(pt.End_Date__c >= qDate && pt.Start_Date__c < qDate.addMonths(3)){
                        forthQtrtask = forthQtrtask+pt.Subject+',';
                    }                   
                    qDate = qDate.addMonths(3);
                    //if(pt.End_Date__c >= qDate && pt.End_Date__c < qDate.addMonths(3) || (pt.Start_Date__c >= qDate && pt.Start_Date__c < qDate.addMonths(3))){
                    if(pt.End_Date__c >= qDate && pt.Start_Date__c < qDate.addMonths(3)){
                        fifthQtrtask = fifthQtrtask+pt.Subject+',';
                    }                   
                    qDate = qDate.addMonths(3);
                    //if(pt.End_Date__c >= qDate && pt.End_Date__c < qDate.addMonths(3) || (pt.Start_Date__c >= qDate && pt.Start_Date__c < qDate.addMonths(3))){
                    if(pt.End_Date__c >= qDate && pt.Start_Date__c < qDate.addMonths(3)){
                        sixthQtrtask = sixthQtrtask+pt.Subject+',';
                    }                   
                }
            }
        }
    }
    
     public void createReleaseChartItems(List<String> productsId){
            getProductReleases(productsId);
            
            releaseChartItems = new List<ChartItem>();
            Integer i = 0;
            system.debug('display release list please?'+pReleases);
            for(Release__c pRel : pReleases){
                ChartItem chi = new ChartItem();
                chi.pID = String.valueOf(i);
                chi.pName = pRel.Name;
                chi.pStart = pRel.Start_Date__c.Month() + '/' + pRel.Start_Date__c.Day() + '/' + pRel.Start_Date__c.Year();
                chi.pEnd = pRel.End_Date__c.Month() + '/' + pRel.End_Date__c.Day() + '/' + pRel.End_Date__c.Year();
                chi.pColor = 'ff0000';
                chi.pLink = '/'+pRel.Id;
                chi.pMile = 0;
                chi.pRes = pRel.Owner.Name; 
                chi.pComp = 0; 
                chi.pGroup = 0;
                chi.pParent = 0;
                chi.pOpen = 0;
                chi.pDepend = '';
                chi.pCaption = '';
                chi.pHealth = pRel.Health__c;
                /*if(pRel.Application__r.Name != null){
                    chi.pApplication = pRel.Application__r.Name;
                } else {
                    chi.pApplication = '';
                }*/
                if(pRel.Applications__c != null){
                    chi.pApplication = pRel.Applications__c;
                } else {
                    chi.pApplication = '';
                }
                releaseChartItems.add(chi);
                i++;
            }
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
        public String pApplication {get;set;}
    }
    
    
    public void getProductReleases(List<String> productsId){
        List<Product_Feature_Link__c> pfList = queryProductFeatures(productsId);
        List<String> featureIDList = new List<String>();
        for(Product_Feature_Link__c pf: pfList){
            featureIDList.add(pf.Feature__c);
        }
        
        List<Release_Feature__c> rfList = queryReleaseFeatures(featureIDList);
        List<String> releaseIDList = new List<String>();
        for(Release_Feature__c rf: rfList){
            releaseIDList.add(rf.Release__c);
        }
        
        pReleases = queryRelease(releaseIDList);
    }
    
    public List<Release_Feature__c> queryReleaseFeatures(List<String> featuresIds){
        return [select Id, Name, Release__c from Release_Feature__c where Feature__c IN :featuresIds];
    }

    public List<Release__c> queryRelease(List<String> releaseIds){
        return [select Id, Applications__c, Name, Start_Date__c, End_Date__c, Health__c, Status__c, Initiative__c, Release__c, OwnerId, Owner.Name from Release__c where ID IN :releaseIds and End_Date__c > :system.today()];
    }
            
    public List<Product_Feature_Link__c> queryProductFeatures(List<String> productsId){
        return [select Id, Name, Product__c, Feature__c, Feature__r.Name  from Product_Feature_Link__c where Product__c IN :productsId];
    }
                    
}