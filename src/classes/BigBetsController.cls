/*
@Name           : BigBetsController
@Author         : customersuccess@cloud62.com
@Date           : 2/17/2012
@Description    : Controller for BigBests
Apr 5 2013 - replace client_segment__c with status__c
*/
public with sharing class BigBetsController{
    //VF Search variables
    public Account searchAcc {get;set;}
    transient  public String strCongAccs {get;set;}
    public String strCustomerType {get;set;}
    public String strYear {get;set;}
    public String strDeliveryChannel {get;set;}
    public String strTimePeriod {get;set;}
    public String strClientSegment {get;set;}
    public List<String> lstDelChan {get;set;}
    public List<String> lstTP {get;set;}
    public Set<String> setCongAccNames {get;set;}
    private List<Account> lstCongAccs {get;set;}
    private List<String> lstQuarter {get;set;}
    private List<String> lstAccRTs {get;set;}
    Map<String,ID> accMap;
    public String strGrid1Report {get;set;}
    public String strGrid5Report {get;set;}
    public String strGrid8Report {get;set;}
    public Boolean showHideColumn {get;set;}
    public Boolean autoPopulateUsr{get;set;}
    
    //Rendering variables
    public Boolean showTableBlock {get;set;}
    public Boolean showGrid1 {get;set;}
    public Boolean showGrid2 {get;set;}
    public Boolean showGrid3 {get;set;}
    public Boolean showGrid4 {get;set;}
    public Boolean showGrid5 {get;set;}
    public Boolean showGrid6 {get;set;}
    public Boolean showGrid7 {get;set;}
    public Boolean showGrid8 {get;set;}
    public Boolean showReport1Link {get;set;}
    public Boolean showReport5Link {get;set;}
    public Boolean showReport8Link {get;set;}
    
    //Table JSON
    public String strJSONGrid1 {get;set;}
    public String strJSONGrid2 {get;set;}
    public String strJSONGrid3 {get;set;}
    public String strJSONGrid4 {get;set;}
    public String strJSONGrid5 {get;set;}
    public String strJSONGrid6 {get;set;}
    public String strJSONGrid7 {get;set;}
    public String strJSONGrid8 {get;set;}
    Map<String,String> tmpSM1FC = new Map<String,String>();
    public String forecastRole{get;set;}
    public String gridCaption{get;set;}

    //grid display boolean variables
    public Boolean fbsrGrid {get;set;}
    public Boolean abgsGrid {get;set;}
    public Boolean pycrmbGrid {get;set;}
    public Boolean accPlanGrid {get;set;}
    public Boolean conGrid {get;set;}
    public Boolean bvdsGrid {get;set;}
    public Boolean oppGrid {get;set;}
    public Boolean top10OppGrid {get;set;}    
    /*
    @Name   :BigBetsController
    @Description :Constructor that initializes class variables
    */
    public BigBetsController(){
        try{
            fbsrGrid = true;
            abgsGrid = true;
            showHideColumn = false;
            autoPopulateUsr = false;
            searchAcc = new Account();
            strCustomerType = 'Manufacturing';
            strClientSegment = 'Platinum';
            forecastRole = '';
            
            List<Account> tmplstCongAccs = [SELECT Id,Name 
                            FROM Account 
                            WHERE Type = 'Conglomerate' 
                            AND RecordType.Name IN ('Manufacturing','Retail')
                            Order By Name ASC];
            
            Set<String> setCongAccNamestmp = new Set<String>();
            for(Account acc : tmplstCongAccs){
              setCongAccNamestmp.add(acc.Name);
          }
          
          User usr = [Select Id, Forecast_Role__c, Highest_User__c From User Where id=:userInfo.getUserId()];
          if(usr.Forecast_Role__c!=null){
            forecastRole = usr.Forecast_Role__c;
          }
          if(usr.Highest_User__c!=null && usr.Highest_User__c!=''){
            List<User> highUsr = [Select Id, Forecast_Role__c, Highest_User__c From User Where id=:usr.Highest_User__c];
            if(highUsr.size()>0 && highUsr[0].Forecast_Role__c!=null){
              forecastRole = highUsr[0].Forecast_Role__c;
            }
          }          
            getUsrForecastRoleObj(setCongAccNamestmp);
            getCongAccs();
            showTableBlock = false;
            strYear = String.valueOf(Date.Today().Year());
            BigBets_Setting__c customSetting = BigBets_Setting__c.getInstance('BigBetsAutopopulateUser');
            List<String> userNameList = new List<String>();
            Set<String> userNameSet = new Set<String>();
            if(customSetting!=null && customSetting.Autopopulate_Users__c!=null){
              userNameList = customSetting.Autopopulate_Users__c.split(',');
              userNameSet.addAll(userNameList);
            } 
              //displaying only default 2 grids 
              if(userNameSet.contains(UserInfo.getUserName())){
                //fbsrGrid = true;
                //abgsGrid = true;
                //pycrmbGrid = true;
                //accPlanGrid = true;
                //conGrid = true;
                //bvdsGrid = true;
                //oppGrid = true;
                //top10OppGrid = true;              
                strDeliveryChannel = 'Base';
                strTimePeriod = 'Q1';                
                search();
                if(forecastRole == 'SR1'){
                  getGrid1And3SR1Data();
                } else if(forecastRole == 'SR2'){
                  getGrid1And3SR2Data();
                } else if(forecastRole == 'SM2'){
                  getGrid1And3SM2Data();
                } else {
                  getGrid1And3SM1Data();
                }
                getGrid2Data();
                //getGrid4Data();
                //getGrid5Data();
                //getGrid6Data();
                //getGrid7Data();
                //getGrid8Data();
                autoPopulateUsr = true;
              }else{
                strDeliveryChannel = 'Base';
                strTimePeriod = 'Q1';  
                search();
                if(forecastRole == 'SR1'){
                  getGrid1And3SR1Data();
                } else if(forecastRole == 'SR2'){
                  getGrid1And3SR2Data();
                } else if(forecastRole == 'SM2'){
                  getGrid1And3SM2Data();
                } else {
                  getGrid1And3SM1Data();
                }
                getGrid2Data();
              }
        } catch (Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        }
    }
    
    /*
    @Name   :getUsrForecastRoleObj
    @Description :Decides which object need to use based on user forecast role
    */
    public void getUsrForecastRoleObj(Set<String> setCongAccNamestmp){
      List<String> lstYears = new List<String>();
      lstYears.add(String.valueOf(Date.Today().addYears(-1).Year()));
        lstYears.add(String.valueOf(Date.Today().Year()));
      if(forecastRole == 'SR1'){
          List<Rep_1_Forecast__c> lstSR1Frcst = [SELECT Id,Year__c,Conglomerate__c 
                                                      FROM Rep_1_Forecast__c 
                                                      WHERE Conglomerate__c IN :setCongAccNamestmp 
                                                      AND Year__c IN :lstYears];
             for(Rep_1_Forecast__c s : lstSR1Frcst){
               tmpSM1FC.put(s.Conglomerate__c,s.id);
             }
         }else if(forecastRole == 'SR2'){
           List<Rep_2_Forecast__c> lstSR2Frcst = [SELECT Id,Year__c,Conglomerate__c 
                                                      FROM Rep_2_Forecast__c 
                                                      WHERE Conglomerate__c IN :setCongAccNamestmp 
                                                      AND Year__c IN :lstYears];
             for(Rep_2_Forecast__c s : lstSR2Frcst){
               tmpSM1FC.put(s.Conglomerate__c,s.id);
             }
         }else if(forecastRole == 'SM2'){
           List<Sales_Manager_2_Forecast__c > lstSM2Frcst = [SELECT Id,Year__c,Conglomerate__c 
                                                      FROM Sales_Manager_2_Forecast__c  
                                                      WHERE Conglomerate__c IN :setCongAccNamestmp 
                                                      AND Year__c IN :lstYears];
             for(Sales_Manager_2_Forecast__c  s : lstSM2Frcst){
               tmpSM1FC.put(s.Conglomerate__c,s.id);
             }
         }else{          
             List<Sales_Manager_1_Forecast__c> lstSM1Frcst = [SELECT Id,Year__c,Conglomerate__c 
                                                      FROM Sales_Manager_1_Forecast__c 
                                                      WHERE Conglomerate__c IN :setCongAccNamestmp 
                                                      AND Year__c IN :lstYears];
             for(Sales_Manager_1_Forecast__c s : lstSM1Frcst){
               tmpSM1FC.put(s.Conglomerate__c,s.id);
             }
         }
  }
    
    /*
    @Name   :getCongAccs
    @Description :Sets the string array for the Conglomorate Account Name field
    */
    public void getCongAccs(){
        strCongAccs = '[';
        lstAccRTs = strCustomerType.split(',');
        setCongAccNames = new Set<String>();
        if(strClientSegment == 'All'){
            lstCongAccs = [SELECT Id,Name 
                            FROM Account 
                            WHERE Type = 'Conglomerate' 
                            AND RecordType.Name IN :lstAccRTs
                            /*AND status__c !=null */
                            Order By Name ASC];
        }else if(strClientSegment == 'Other'){
            lstCongAccs = [SELECT Id,Name 
                            FROM Account 
                            WHERE Type = 'Conglomerate' 
                            AND RecordType.Name IN :lstAccRTs
                            AND Status__c != 'Platinum' and Status__c != 'Gold' 
                            /*AND status__c !=null */
                            Order By Name ASC]; 
        }else{
            lstCongAccs = [SELECT Id,Name 
                            FROM Account 
                            WHERE Type = 'Conglomerate' 
                            AND RecordType.Name IN :lstAccRTs
                            AND status__c = :strClientSegment 
                            Order By Name ASC]; 
        }
        
        for(Account acc : lstCongAccs){
            if(tmpSM1FC.containsKey(acc.name)){
              setCongAccNames.add(acc.Name);
            }
        }

        List<String> lstCongAccNames = new List<String>(setCongAccNames);
        lstCongAccNames.sort();
        for(Integer i = 0; i < lstCongAccNames.size(); i++){
            String strAccName = lstCongAccNames.get(i);
            if(i == 0){
                strCongAccs += '"' + strAccName + '"';
            } else {
                strCongAccs += ',"' + strAccName + '"';
            }
        } 
        strCongAccs += ']';                     
    }
    
    /*
    @Name   :GridItem
    @Description :Wrapper class for grid items
    */
    public class GridItem{
        public String strAccName {get;set;}
        public Decimal decBookedRev {get;set;}
        public Decimal decSDPYRev {get;set;}
        public Decimal decBestGuess {get;set;}
        public Decimal decDiff {get;set;}
        public Decimal pyCatalinaRev {get;set;}
        public Decimal pyMarketingBudget {get;set;}
        public Decimal share {get;set;}
        public String bigBets {get;set;}
        public String accountPlan {get;set;}
        public String digitalSpecialist {get;set;}
        public Decimal amount {get;set;}
        public String stage {get;set;}
        public String oppName {get;set;}
        public String attchId {get;set;}
        public List<Contact> lstContacts {get;set;}
        public Integer numContacts {get;set;}
        public String sortAccName {get;set;}
        public String sortOppName {get;set;}
        public String buyerVsnSpecialiat {get;set;}
        
        public GridItem(String strAccName,Decimal decBookedRev,Decimal decSDPYRev,Decimal decBestGuess,Decimal decDiff,
                        Decimal pyCatalinaRev,Decimal pyMarketingBudget,Decimal share,String bigBets,String accountPlan,
                        String digitalSpecialist,Decimal amount,String stage,String oppName,String attchId){
            
            this.strAccName = strAccName;
            this.decBookedRev = decBookedRev;
            this.decSDPYRev = decSDPYRev;
            this.decBestGuess = decBestGuess;
            this.decDiff = decDiff;
            this.pyCatalinaRev = pyCatalinaRev;
            this.pyMarketingBudget = pyMarketingBudget;
            this.share = share;
            this.bigBets = bigBets;
            this.accountPlan = accountPlan;
            this.digitalSpecialist = digitalSpecialist;
            this.amount = amount;
            this.stage = stage;
            this.oppName = oppName;
            this.attchId = attchId;
        }
        
    }
    
    /*
    @Name   :search
    @Description :Gathers the data for each table
    */
    public void search(){
        showTableBlock = true;
        if(lstCongAccs != null){            
            setCongAccNames = new Set<String>();
            accMap = new Map<String,ID>();
            if(searchAcc.Name != null){
                showHideColumn = true;
                List<Account> lstAcc = new List<Account>(); 
                if(strClientSegment == 'All'){
                    lstAcc = [Select Id,Name From Account Where Name=:searchAcc.Name AND Type='Conglomerate' AND RecordType.Name IN :lstAccRTs Limit 1];
                }else if(strClientSegment == 'Other'){
                    lstAcc = [Select Id,Name From Account Where Name=:searchAcc.Name AND Type='Conglomerate' AND RecordType.Name IN :lstAccRTs AND Status__c != 'Platinum' and Status__c != 'Gold' Limit 1]; 
                }else{
                    lstAcc = [Select Id,Name From Account Where Name=:searchAcc.Name AND Type='Conglomerate' AND RecordType.Name IN :lstAccRTs AND status__c = :strClientSegment Limit 1];  
                }
                
                if(lstAcc.size()>0){
                    setCongAccNames.add(searchAcc.Name);
                    accMap.put(lstAcc[0].Name,lstAcc[0].Id);
                }
            } else {
                showHideColumn = false;
                for(Account acc : lstCongAccs){
                    setCongAccNames.add(acc.Name);
                    accMap.put(acc.Name,acc.Id);
                }
            } 
        }
        if(setCongAccNames != null){
            lstDelChan = strDeliveryChannel.split(',');
            lstTP = strTimePeriod.split(',');
            lstQuarter = new List<String>();
            for(String str : lstTP){
                str += strYear;
                lstQuarter.add(str);
            }
            
            String timePeriodYear = '';
            for(String s : lstQuarter){
                timePeriodYear += s+',';
            }
            timePeriodYear = timePeriodYear.subString(0,timePeriodYear.length()-1);
            //BigBets_Setting__c setting1 = BigBets_Setting__c.getInstance('Bigbet AccountContacts-No Acc');
            //BigBets_Setting__c setting2 = BigBets_Setting__c.getInstance('Bigbets AccountContacts');
            BigBets_Setting__c setting3 = BigBets_Setting__c.getInstance('Bigbets Digital Specialist');
            BigBets_Setting__c setting4 = BigBets_Setting__c.getInstance('Bigbets Digital Specialist No Acc');
            BigBets_Setting__c setting5 = BigBets_Setting__c.getInstance('Bigbets Sales Manager 1 Forecast');
            BigBets_Setting__c setting6 = BigBets_Setting__c.getInstance('BigbetsSalesManager1ForecastNoAcc');
            BigBets_Setting__c setting7 = BigBets_Setting__c.getInstance('Bigbets Sales Manager 2 Forecast');
            BigBets_Setting__c setting8 = BigBets_Setting__c.getInstance('BigbetsSalesManager2ForecastNoAcc');
            BigBets_Setting__c setting9 = BigBets_Setting__c.getInstance('Bigbets Sales Rep 1 Forecast');
            BigBets_Setting__c setting10 = BigBets_Setting__c.getInstance('BigbetsSalesRep1ForecastNoAcc');
            BigBets_Setting__c setting11 = BigBets_Setting__c.getInstance('Bigbets Sales Rep 2 Forecast');
            BigBets_Setting__c setting12 = BigBets_Setting__c.getInstance('BigbetsSalesRep2ForecastNoAcc');
            String grid1ReportId = '';
            //String grid5ReportId = '';
            String grid8ReportId = '';
            String clientSegmentReoprt = '';
            if(strClientSegment == 'All'){
              clientSegmentReoprt = 'Platinum,Gold,Silver,""';
            }else if(strClientSegment == 'Other'){
              clientSegmentReoprt = 'Silver,""';
            }else{
              clientSegmentReoprt = strClientSegment;
            }
            
            if(searchAcc.Name != null){
              if(forecastRole == 'SR1'){
                if(setting9!=null && setting9.Report_Id__c!=null){grid1ReportId = setting9.Report_Id__c;}  
              }else if(forecastRole == 'SR2'){
                if(setting11!=null && setting11.Report_Id__c!=null){grid1ReportId = setting11.Report_Id__c;}  
              }else if(forecastRole == 'SM2'){
                if(setting7!=null && setting7.Report_Id__c!=null){grid1ReportId = setting7.Report_Id__c;}  
              } else{
                if(setting5!=null && setting5.Report_Id__c!=null){grid1ReportId = setting5.Report_Id__c;}
              }                
                //if(setting2!=null && setting2.Report_Id__c!=null){grid5ReportId = setting2.Report_Id__c;}
                if(setting3!=null && setting3.Report_Id__c!=null){grid8ReportId = setting3.Report_Id__c;}
                strGrid1Report='/'+grid1ReportId+'?pv0='+searchAcc.Name+'&pv1='+strYear+'&pv2='+strDeliveryChannel.replaceAll('&','%26')+'&pv3='+timePeriodYear+'&pv4='+strCustomerType+'&pv5='+clientSegmentReoprt;
                //strGrid5Report='/'+grid5ReportId+'?pv0='+searchAcc.Name+'&pv1='+strClientSegment;
                strGrid8Report='/'+grid8ReportId+'?pv0='+clientSegmentReoprt+'&pv1='+searchAcc.Name;
            } else{
              if(forecastRole == 'SR1'){
                if(setting10!=null && setting10.Report_Id__c!=null){grid1ReportId = setting10.Report_Id__c;}  
              }else if(forecastRole == 'SR2'){
                if(setting12!=null && setting12.Report_Id__c!=null){grid1ReportId = setting12.Report_Id__c;}  
              }else if(forecastRole == 'SM2'){
                if(setting8!=null && setting8.Report_Id__c!=null){grid1ReportId = setting8.Report_Id__c;}  
              } else{
                if(setting6!=null && setting6.Report_Id__c!=null){grid1ReportId = setting6.Report_Id__c;}
              }
                //if(setting1!=null && setting1.Report_Id__c!=null){grid5ReportId = setting1.Report_Id__c;}
                if(setting4!=null && setting4.Report_Id__c!=null){grid8ReportId = setting4.Report_Id__c;}
                strGrid1Report='/'+grid1ReportId+'?pv0='+strYear+'&pv1='+strDeliveryChannel.replaceAll('&','%26')+'&pv2='+timePeriodYear+'&pv3='+strCustomerType+'&pv4='+clientSegmentReoprt;
                //strGrid5Report='/'+grid5ReportId+'?pv0='+strClientSegment;
                strGrid8Report='/'+grid8ReportId+'?pv0='+clientSegmentReoprt;
            }
            
            showGrid1 = false;
            showGrid2 = false;
            showGrid3 = false;
            showGrid4 = false;
            showGrid5 = false;
            showGrid6 = false;
            showGrid7 = false;
            showGrid8 = false;
            showReport1Link = false;
            showReport5Link = false;
            showReport8Link = false;
        }
    }
    
    /*
    @Name   :getGrid1And3SM1Data
    @Description :Method to prepare data for grid1 and grid3 on vf page
    */
    public PageReference getGrid1And3SM1Data(){
      //  if(!fbsrGrid && !pycrmbGrid){
      //      return null;
      //   } 
        List<Sales_Manager_1_Forecast__c> lstSM1Fs;
        List<Account_Media_Spending__c> lstAMS;
        String pyStrYear = String.ValueOf(Integer.ValueOf(strYear)-1);
        if(strClientSegment == 'All'){
            lstSM1Fs = [SELECT Id,Conglomerate__c, 
                      Total_Booked_Amount__c,SDPY_Total_Booked_Amount__c,FY_Total__c 
                      FROM Sales_Manager_1_Forecast__c 
                      WHERE Conglomerate__c IN :setCongAccNames 
                      AND Year__c = :strYear 
                      AND Delivery_Type__c IN :lstDelChan 
                      AND Quarter__c IN :lstQuarter 
                      AND Account_Type__c IN :lstAccRTs]; 
            lstAMS = [SELECT Id,Name,Year__c,  
                      Account__c,Amount__c, Account__r.Name 
                      FROM Account_Media_Spending__c 
                      WHERE Account__r.Name IN :setCongAccNames 
                      AND Year__c = :pyStrYear 
                      AND Account__r.RecordType.Name IN :lstAccRTs]; 
        } else if(strClientSegment == 'Other'){
            lstSM1Fs = [SELECT Id,Conglomerate__c, 
                      Total_Booked_Amount__c,SDPY_Total_Booked_Amount__c,FY_Total__c 
                      FROM Sales_Manager_1_Forecast__c 
                      WHERE Conglomerate__c IN :setCongAccNames 
                      AND Year__c = :strYear 
                      AND Delivery_Type__c IN :lstDelChan 
                      AND Quarter__c IN :lstQuarter 
                      AND Account_Type__c IN :lstAccRTs 
                      AND Account_Segmentation__c != 'Platinum' AND Account_Segmentation__c != 'Gold'];
            lstAMS = [SELECT Id,Name,Year__c,  
                      Account__c,Amount__c, Account__r.Name 
                      FROM Account_Media_Spending__c 
                      WHERE Account__r.Name IN :setCongAccNames 
                      AND Year__c = :pyStrYear 
                      AND Account__r.RecordType.Name IN :lstAccRTs 
                      AND Account__r.Status__c != 'Platinum' AND Account__r.Status__c != 'Gold'];
        } else {
            lstSM1Fs = [SELECT Id,Conglomerate__c, 
                      Total_Booked_Amount__c,SDPY_Total_Booked_Amount__c,FY_Total__c 
                      FROM Sales_Manager_1_Forecast__c 
                      WHERE Conglomerate__c IN :setCongAccNames 
                      AND Year__c = :strYear 
                      AND Delivery_Type__c IN :lstDelChan 
                      AND Quarter__c IN :lstQuarter 
                      AND Account_Type__c IN :lstAccRTs 
                      AND Account_Segmentation__c = :strClientSegment ];
            lstAMS = [SELECT Id,Name,Year__c,  
                      Account__c,Amount__c, Account__r.Name 
                      FROM Account_Media_Spending__c 
                      WHERE Account__r.Name IN :setCongAccNames 
                      AND Year__c = :pyStrYear 
                      AND Account__r.RecordType.Name IN :lstAccRTs 
                      AND Account__r.Status__c = :strClientSegment ];
        }

        Map<String,List<Sales_Manager_1_Forecast__c>> mapSM1Fs = new Map<String,List<Sales_Manager_1_Forecast__c>>();
        for(Sales_Manager_1_Forecast__c sm1f : lstSM1Fs){
            if(mapSM1Fs.get(sm1f.Conglomerate__c) == null){
                List<Sales_Manager_1_Forecast__c> lst = new List<Sales_Manager_1_Forecast__c>();
                lst.add(sm1f);
                mapSM1Fs.put(sm1f.Conglomerate__c,lst);
            } else {
                mapSM1Fs.get(sm1f.Conglomerate__c).add(sm1f);
            }
        }
        List<GridItem> lstGrid1 = new List<GridItem>();
        List<GridItem> lstGrid3 = new List<GridItem>();
        for(String strAccName : setCongAccNames){
            GridItem gItem = new GridItem('',0,0,0,0,0,0,0,'','','',0,'','','');
            GridItem gi2 = new GridItem('',0,0,0,0,0,0,0,'','','',0,'','','');
            gItem.strAccName = '<a href=/'+accMap.get(strAccName)+' target=_blank><U>'+strAccName.replaceAll('"','')+'</U></a>';
            gItem.sortAccName = strAccName;
            gi2.strAccName = '<a href=/'+accMap.get(strAccName)+' target=_blank><U>'+strAccName.replaceAll('"','')+'</U></a>';
            gi2.sortAccName = strAccName;
            if(mapSM1Fs.get(strAccName) != null){
                for(Sales_Manager_1_Forecast__c sm1f : mapSM1Fs.get(strAccName)){
                    if(sm1f.Total_Booked_Amount__c != null){
                        gItem.decBookedRev += sm1f.Total_Booked_Amount__c;
                    }
                    if(sm1f.SDPY_Total_Booked_Amount__c != null){
                        gItem.decSDPYRev += sm1f.SDPY_Total_Booked_Amount__c;
                    }
                    if(sm1f.FY_Total__c != null){
                        gi2.pyCatalinaRev += sm1f.FY_Total__c;
                    }
                }
            }

            gItem.decDiff = gItem.decBookedRev - gItem.decSDPYRev;
            if(gItem.decBookedRev>0 || gItem.decSDPYRev>0){       
                lstGrid1.add(gItem);
                showReport1Link =true;
            }
            for(Account_Media_Spending__c ams : lstAMS){
                if(ams.Account__r.Name==strAccName){
                    gi2.pyMarketingBudget = ams.Amount__c;
                    break;    
                }
            }
            if(gi2.pyMarketingBudget>0){
               gi2.share = (gi2.pyCatalinaRev/gi2.pyMarketingBudget)*100;
            } else {
                gi2.share = 0;
            }
            if(gi2.pyCatalinaRev>0 || gi2.pyMarketingBudget>0){
                lstGrid3.add(gi2);
            }
        }
        strJSONGrid1 = JSON.serialize(lstGrid1);
        lstGrid1 = new List<GridItem>();
        strJSONGrid3 = JSON.serialize(lstGrid3);
        lstGrid3 = new List<GridItem>();
        showGrid1 = true;
        showGrid3 = true;
        gridCaption = 'Sales Manager 1 Forecast';
        return null;
    }
    
    /*
    @Name   :getGrid1And3SM2Data
    @Description :Method to prepare data for grid1 and grid3 on vf page
    */
    public PageReference getGrid1And3SM2Data(){
    //    if(!fbsrGrid && !pycrmbGrid){
    //        return null;
    //     } 
    
        List<Sales_Manager_2_Forecast__c> lstSM2Fs;
        List<Account_Media_Spending__c> lstAMS;
        String pyStrYear = String.ValueOf(Integer.ValueOf(strYear)-1);
        if(strClientSegment == 'All'){
            lstSM2Fs = [SELECT Id,Conglomerate__c, 
                      Total_Booked_Amount__c,SDPY_Total_Booked_Amount__c,FY_Total__c 
                      FROM Sales_Manager_2_Forecast__c 
                      WHERE Conglomerate__c IN :setCongAccNames 
                      AND Year__c = :strYear 
                      AND Delivery_Type__c IN :lstDelChan 
                      AND Quarter__c IN :lstQuarter 
                      AND Account_Type__c IN :lstAccRTs]; 
            lstAMS = [SELECT Id,Name,Year__c,  
                      Account__c,Amount__c, Account__r.Name 
                      FROM Account_Media_Spending__c 
                      WHERE Account__r.Name IN :setCongAccNames 
                      AND Year__c = :pyStrYear 
                      AND Account__r.RecordType.Name IN :lstAccRTs]; 
        } else if(strClientSegment == 'Other'){
            lstSM2Fs = [SELECT Id,Conglomerate__c, 
                      Total_Booked_Amount__c,SDPY_Total_Booked_Amount__c,FY_Total__c 
                      FROM Sales_Manager_2_Forecast__c 
                      WHERE Conglomerate__c IN :setCongAccNames 
                      AND Year__c = :strYear 
                      AND Delivery_Type__c IN :lstDelChan 
                      AND Quarter__c IN :lstQuarter 
                      AND Account_Type__c IN :lstAccRTs 
                      AND Account_Segmentation__c != 'Platinum' AND Account_Segmentation__c != 'Gold'];
            lstAMS = [SELECT Id,Name,Year__c,  
                      Account__c,Amount__c, Account__r.Name 
                      FROM Account_Media_Spending__c 
                      WHERE Account__r.Name IN :setCongAccNames 
                      AND Year__c = :pyStrYear 
                      AND Account__r.RecordType.Name IN :lstAccRTs 
                      AND Account__r.Status__c != 'Platinum' AND Account__r.Status__c != 'Gold'];
        } else {
            lstSM2Fs = [SELECT Id,Conglomerate__c, 
                      Total_Booked_Amount__c,SDPY_Total_Booked_Amount__c,FY_Total__c 
                      FROM Sales_Manager_2_Forecast__c 
                      WHERE Conglomerate__c IN :setCongAccNames 
                      AND Year__c = :strYear 
                      AND Delivery_Type__c IN :lstDelChan 
                      AND Quarter__c IN :lstQuarter 
                      AND Account_Type__c IN :lstAccRTs 
                      AND Account_Segmentation__c = :strClientSegment ];
            lstAMS = [SELECT Id,Name,Year__c,  
                      Account__c,Amount__c, Account__r.Name 
                      FROM Account_Media_Spending__c 
                      WHERE Account__r.Name IN :setCongAccNames 
                      AND Year__c = :pyStrYear 
                      AND Account__r.RecordType.Name IN :lstAccRTs 
                      AND Account__r.Status__c = :strClientSegment ];
        }

        Map<String,List<Sales_Manager_2_Forecast__c>> mapSM2Fs = new Map<String,List<Sales_Manager_2_Forecast__c>>();
        for(Sales_Manager_2_Forecast__c sm2f : lstSM2Fs){
            if(mapSM2Fs.get(sm2f.Conglomerate__c) == null){
                List<Sales_Manager_2_Forecast__c> lst = new List<Sales_Manager_2_Forecast__c>();
                lst.add(sm2f);
                mapSM2Fs.put(sm2f.Conglomerate__c,lst);
            } else {
                mapSM2Fs.get(sm2f.Conglomerate__c).add(sm2f);
            }
        }
        List<GridItem> lstGrid1 = new List<GridItem>();
        List<GridItem> lstGrid3 = new List<GridItem>();
        for(String strAccName : setCongAccNames){
            GridItem gItem = new GridItem('',0,0,0,0,0,0,0,'','','',0,'','','');
            GridItem gi2 = new GridItem('',0,0,0,0,0,0,0,'','','',0,'','','');
            gItem.strAccName = '<a href=/'+accMap.get(strAccName)+' target=_blank><U>'+strAccName.replaceAll('"','')+'</U></a>';
            gItem.sortAccName = strAccName;
            gi2.strAccName = '<a href=/'+accMap.get(strAccName)+' target=_blank><U>'+strAccName.replaceAll('"','')+'</U></a>';
            gi2.sortAccName = strAccName;
            if(mapSM2Fs.get(strAccName) != null){
                for(Sales_Manager_2_Forecast__c sm2f : mapSM2Fs.get(strAccName)){
                    if(sm2f.Total_Booked_Amount__c != null){
                        gItem.decBookedRev += sm2f.Total_Booked_Amount__c;
                    }
                    if(sm2f.SDPY_Total_Booked_Amount__c != null){
                        gItem.decSDPYRev += sm2f.SDPY_Total_Booked_Amount__c;
                    }
                    if(sm2f.FY_Total__c != null){
                        gi2.pyCatalinaRev += sm2f.FY_Total__c;
                    }
                }
            }
            gItem.decDiff = gItem.decBookedRev - gItem.decSDPYRev;
            if(gItem.decBookedRev>0 || gItem.decSDPYRev>0){       
                lstGrid1.add(gItem);
                showReport1Link =true;
            }
            for(Account_Media_Spending__c ams : lstAMS){
                if(ams.Account__r.Name==strAccName){
                    gi2.pyMarketingBudget = ams.Amount__c;
                    break;    
                }
            }
            if(gi2.pyMarketingBudget>0){
               gi2.share = (gi2.pyCatalinaRev/gi2.pyMarketingBudget)*100;
            } else {
                gi2.share = 0;
            }
            if(gi2.pyCatalinaRev>0 || gi2.pyMarketingBudget>0){
                lstGrid3.add(gi2);
            }
        }
        strJSONGrid1 = JSON.serialize(lstGrid1);
        lstGrid1 = new List<GridItem>();
        strJSONGrid3 = JSON.serialize(lstGrid3);
        lstGrid3 = new List<GridItem>();
        showGrid1 = true;
        showGrid3 = true;
        gridCaption = 'Sales Manager 2 Forecast';
        return null;
    }
    
    /*
    @Name   :getGrid1And3SR1Data
    @Description :Method to prepare data for grid1 and grid3 on vf page
    */
    public PageReference getGrid1And3SR1Data(){
     //   if(!fbsrGrid && !pycrmbGrid){
     //       return null;
     //    } 
    
        List<Rep_1_Forecast__c> lstSR1Fs;
        List<Account_Media_Spending__c> lstAMS;
        String pyStrYear = String.ValueOf(Integer.ValueOf(strYear)-1);
        if(strClientSegment == 'All'){
            lstSR1Fs = [SELECT Id,Conglomerate__c, 
                      Total_Booked_Amount__c,SDPY_Total_Booked_Amount__c,FY_Total__c 
                      FROM Rep_1_Forecast__c 
                      WHERE Conglomerate__c IN :setCongAccNames 
                      AND Year__c = :strYear 
                      AND Delivery_Type__c IN :lstDelChan 
                      AND Quarter__c IN :lstQuarter 
                      AND Account_Type__c IN :lstAccRTs]; 
            lstAMS = [SELECT Id,Name,Year__c,  
                      Account__c,Amount__c, Account__r.Name 
                      FROM Account_Media_Spending__c 
                      WHERE Account__r.Name IN :setCongAccNames 
                      AND Year__c = :pyStrYear 
                      AND Account__r.RecordType.Name IN :lstAccRTs]; 
        } else if(strClientSegment == 'Other'){
            lstSR1Fs = [SELECT Id,Conglomerate__c, 
                      Total_Booked_Amount__c,SDPY_Total_Booked_Amount__c,FY_Total__c 
                      FROM Rep_1_Forecast__c 
                      WHERE Conglomerate__c IN :setCongAccNames 
                      AND Year__c = :strYear 
                      AND Delivery_Type__c IN :lstDelChan 
                      AND Quarter__c IN :lstQuarter 
                      AND Account_Type__c IN :lstAccRTs 
                      AND Account_Segmentation__c != 'Platinum' AND Account_Segmentation__c != 'Gold'];
            lstAMS = [SELECT Id,Name,Year__c,  
                      Account__c,Amount__c, Account__r.Name 
                      FROM Account_Media_Spending__c 
                      WHERE Account__r.Name IN :setCongAccNames 
                      AND Year__c = :pyStrYear 
                      AND Account__r.RecordType.Name IN :lstAccRTs 
                      AND Account__r.Status__c != 'Platinum' AND Account__r.Status__c != 'Gold'];
        } else {
            lstSR1Fs = [SELECT Id,Conglomerate__c, 
                      Total_Booked_Amount__c,SDPY_Total_Booked_Amount__c,FY_Total__c 
                      FROM Rep_1_Forecast__c 
                      WHERE Conglomerate__c IN :setCongAccNames 
                      AND Year__c = :strYear 
                      AND Delivery_Type__c IN :lstDelChan 
                      AND Quarter__c IN :lstQuarter 
                      AND Account_Type__c IN :lstAccRTs 
                      AND Account_Segmentation__c = :strClientSegment ];
            lstAMS = [SELECT Id,Name,Year__c,  
                      Account__c,Amount__c, Account__r.Name 
                      FROM Account_Media_Spending__c 
                      WHERE Account__r.Name IN :setCongAccNames 
                      AND Year__c = :pyStrYear 
                      AND Account__r.RecordType.Name IN :lstAccRTs 
                      AND Account__r.Status__c = :strClientSegment ];
        }

        Map<String,List<Rep_1_Forecast__c>> mapSR1Fs = new Map<String,List<Rep_1_Forecast__c>>();
        for(Rep_1_Forecast__c sr1f : lstSR1Fs){
            if(mapSR1Fs.get(sr1f.Conglomerate__c) == null){
                List<Rep_1_Forecast__c> lst = new List<Rep_1_Forecast__c>();
                lst.add(sr1f);
                mapSR1Fs.put(sr1f.Conglomerate__c,lst);
            } else {
                mapSR1Fs.get(sr1f.Conglomerate__c).add(sr1f);
            }
        }
        List<GridItem> lstGrid1 = new List<GridItem>();
        List<GridItem> lstGrid3 = new List<GridItem>();
        for(String strAccName : setCongAccNames){
            GridItem gItem = new GridItem('',0,0,0,0,0,0,0,'','','',0,'','','');
            GridItem gi2 = new GridItem('',0,0,0,0,0,0,0,'','','',0,'','','');
            gItem.strAccName = '<a href=/'+accMap.get(strAccName)+' target=_blank><U>'+strAccName.replaceAll('"','')+'</U></a>';
            gItem.sortAccName = strAccName;
            gi2.strAccName = '<a href=/'+accMap.get(strAccName)+' target=_blank><U>'+strAccName.replaceAll('"','')+'</U></a>';
            gi2.sortAccName = strAccName;
            if(mapSR1Fs.get(strAccName) != null){
                for(Rep_1_Forecast__c sr1f : mapSR1Fs.get(strAccName)){
                    if(sr1f.Total_Booked_Amount__c != null){
                        gItem.decBookedRev += sr1f.Total_Booked_Amount__c;
                    }
                    if(sr1f.SDPY_Total_Booked_Amount__c != null){
                        gItem.decSDPYRev += sr1f.SDPY_Total_Booked_Amount__c;
                    }
                    if(sr1f.FY_Total__c != null){
                        gi2.pyCatalinaRev += sr1f.FY_Total__c;
                    }
                }
            }
            gItem.decDiff = gItem.decBookedRev - gItem.decSDPYRev;
            if(gItem.decBookedRev>0 || gItem.decSDPYRev>0){       
                lstGrid1.add(gItem);
                showReport1Link =true;
            }
            for(Account_Media_Spending__c ams : lstAMS){
                if(ams.Account__r.Name==strAccName){
                    gi2.pyMarketingBudget = ams.Amount__c;
                    break;    
                }
            }
            if(gi2.pyMarketingBudget>0){
               gi2.share = (gi2.pyCatalinaRev/gi2.pyMarketingBudget)*100;
            } else {
                gi2.share = 0;
            }
            if(gi2.pyCatalinaRev>0 || gi2.pyMarketingBudget>0){
                lstGrid3.add(gi2);
            }
        }
        strJSONGrid1 = JSON.serialize(lstGrid1);
        lstGrid1 = new List<GridItem>();
        strJSONGrid3 = JSON.serialize(lstGrid3);
        lstGrid3 = new List<GridItem>();
        showGrid1 = true;
        showGrid3 = true;
        gridCaption = 'Sales Rep 1 Forecast';
        return null;
    }
    
    /*
    @Name   :getGrid1And3SR2Data
    @Description :Method to prepare data for grid1 and grid3 on vf page
    */
    public PageReference getGrid1And3SR2Data(){
    //    if(!fbsrGrid && !pycrmbGrid){
    //        return null;
    //     } 

        List<Rep_2_Forecast__c> lstSR2Fs;
        List<Account_Media_Spending__c> lstAMS;
        String pyStrYear = String.ValueOf(Integer.ValueOf(strYear)-1);
        if(strClientSegment == 'All'){
            lstSR2Fs = [SELECT Id,Conglomerate__c, 
                      Booked_Amount__c,SDPY_Booked_Amount__c,FY_Total__c 
                      FROM Rep_2_Forecast__c 
                      WHERE Conglomerate__c IN :setCongAccNames 
                      AND Year__c = :strYear 
                      AND Delivery_Type__c IN :lstDelChan 
                      AND Quarter__c IN :lstQuarter 
                      AND Account_Type__c IN :lstAccRTs]; 
            lstAMS = [SELECT Id,Name,Year__c,  
                      Account__c,Amount__c, Account__r.Name 
                      FROM Account_Media_Spending__c 
                      WHERE Account__r.Name IN :setCongAccNames 
                      AND Year__c = :pyStrYear 
                      AND Account__r.RecordType.Name IN :lstAccRTs]; 
        } else if(strClientSegment == 'Other'){
            lstSR2Fs = [SELECT Id,Conglomerate__c, 
                      Booked_Amount__c,SDPY_Booked_Amount__c,FY_Total__c 
                      FROM Rep_2_Forecast__c 
                      WHERE Conglomerate__c IN :setCongAccNames 
                      AND Year__c = :strYear 
                      AND Delivery_Type__c IN :lstDelChan 
                      AND Quarter__c IN :lstQuarter 
                      AND Account_Type__c IN :lstAccRTs 
                      AND Account_Segmentation__c != 'Platinum' AND Account_Segmentation__c != 'Gold'];
            lstAMS = [SELECT Id,Name,Year__c,  
                      Account__c,Amount__c, Account__r.Name 
                      FROM Account_Media_Spending__c 
                      WHERE Account__r.Name IN :setCongAccNames 
                      AND Year__c = :pyStrYear 
                      AND Account__r.RecordType.Name IN :lstAccRTs 
                      AND Account__r.Status__c != 'Platinum' AND Account__r.Status__c != 'Gold'];
        } else {
            lstSR2Fs = [SELECT Id,Conglomerate__c, 
                      Booked_Amount__c,SDPY_Booked_Amount__c,FY_Total__c 
                      FROM Rep_2_Forecast__c 
                      WHERE Conglomerate__c IN :setCongAccNames 
                      AND Year__c = :strYear 
                      AND Delivery_Type__c IN :lstDelChan 
                      AND Quarter__c IN :lstQuarter 
                      AND Account_Type__c IN :lstAccRTs 
                      AND Account_Segmentation__c = :strClientSegment ];
            lstAMS = [SELECT Id,Name,Year__c,  
                      Account__c,Amount__c, Account__r.Name 
                      FROM Account_Media_Spending__c 
                      WHERE Account__r.Name IN :setCongAccNames 
                      AND Year__c = :pyStrYear 
                      AND Account__r.RecordType.Name IN :lstAccRTs 
                      AND Account__r.Status__c = :strClientSegment ];
        }

        Map<String,List<Rep_2_Forecast__c>> mapSR2Fs = new Map<String,List<Rep_2_Forecast__c>>();
        for(Rep_2_Forecast__c sr2f : lstSR2Fs){
            if(mapSR2Fs.get(sr2f.Conglomerate__c) == null){
                List<Rep_2_Forecast__c> lst = new List<Rep_2_Forecast__c>();
                lst.add(sr2f);
                mapSR2Fs.put(sr2f.Conglomerate__c,lst);
            } else {
                mapSR2Fs.get(sr2f.Conglomerate__c).add(sr2f);
            }
        }
        List<GridItem> lstGrid1 = new List<GridItem>();
        List<GridItem> lstGrid3 = new List<GridItem>();
        for(String strAccName : setCongAccNames){
            GridItem gItem = new GridItem('',0,0,0,0,0,0,0,'','','',0,'','','');
            GridItem gi2 = new GridItem('',0,0,0,0,0,0,0,'','','',0,'','','');
            gItem.strAccName = '<a href=/'+accMap.get(strAccName)+' target=_blank><U>'+strAccName.replaceAll('"','')+'</U></a>';
            gItem.sortAccName = strAccName;
            gi2.strAccName = '<a href=/'+accMap.get(strAccName)+' target=_blank><U>'+strAccName.replaceAll('"','')+'</U></a>';
            gi2.sortAccName = strAccName;
            if(mapSR2Fs.get(strAccName) != null){
                for(Rep_2_Forecast__c sr2f : mapSR2Fs.get(strAccName)){
                    if(sr2f.Booked_Amount__c != null){
                        gItem.decBookedRev += sr2f.Booked_Amount__c;
                    }
                    if(sr2f.SDPY_Booked_Amount__c != null){
                        gItem.decSDPYRev += sr2f.SDPY_Booked_Amount__c;
                    }
                    if(sr2f.FY_Total__c != null){
                        gi2.pyCatalinaRev += sr2f.FY_Total__c;
                    }
                }
            }
            gItem.decDiff = gItem.decBookedRev - gItem.decSDPYRev;
            if(gItem.decBookedRev>0 || gItem.decSDPYRev>0){       
                lstGrid1.add(gItem);
                showReport1Link =true;
            }
            for(Account_Media_Spending__c ams : lstAMS){
                if(ams.Account__r.Name==strAccName){
                    gi2.pyMarketingBudget = ams.Amount__c;
                    break;    
                }
            }
            if(gi2.pyMarketingBudget>0){
               gi2.share = (gi2.pyCatalinaRev/gi2.pyMarketingBudget)*100;
            } else {
                gi2.share = 0;
            }
            if(gi2.pyCatalinaRev>0 || gi2.pyMarketingBudget>0){
                lstGrid3.add(gi2);
            }
        }
        strJSONGrid1 = JSON.serialize(lstGrid1);
        lstGrid1 = new List<GridItem>();
        strJSONGrid3 = JSON.serialize(lstGrid3);
        lstGrid3 = new List<GridItem>();
        showGrid1 = true;
        showGrid3 = true;
        gridCaption = 'Sales Rep 2 Forecast';
        return null;
    }
    
    /*
    @Name   :getGrid2Data
    @Description :Method to prepare data for grid2 on vf page
    */
    public PageReference getGrid2Data(){
   //     if(!abgsGrid){
   //         return null;
   //      } 
        
        List<Account> lstCongCABGSs = [SELECT Id,Name,
                          (SELECT Id,Account__c,Q1__c,Q2__c,Q3__c,Q4__c,
                              Booked_Q1__c,Booked_Q2__c,Booked_Q3__c,Booked_Q4__c 
                              FROM Conglomerate_Account_BestGuess_Summaries__r 
                              WHERE Year__c = :strYear 
                              AND Delivery_Channel__c IN :lstDelChan) 
                         FROM Account 
                         WHERE Name IN :setCongAccNames 
                         AND Type = 'Conglomerate' 
                         AND RecordType.Name IN :lstAccRTs];
               
        List<GridItem> lstGrid2 = new List<GridItem>();
        for(Account acc : lstCongCABGSs){
            GridItem gi = new GridItem('',0,0,0,0,0,0,0,'','','',0,'','','');
            gi.strAccName = '<a href=/'+acc.Id+' target=_blank><U>'+acc.Name.replaceAll('"','')+'</U></a>';
            gi.sortAccName = acc.Name;
            for(Conglomerate_Account_Best_Guess_Summary__c cong : acc.Conglomerate_Account_BestGuess_Summaries__r){
                if(strTimePeriod=='Q1'){
                    if(cong.Q1__c!= null){
                        gi.decBestGuess += cong.Q1__c;
                    }
                    if(cong.Booked_Q1__c!= null){
                        gi.decBookedRev += cong.Booked_Q1__c;
                    }
                } else if(strTimePeriod=='Q2'){
                    if(cong.Q2__c!= null){
                        gi.decBestGuess += cong.Q2__c;
                    }
                    if(cong.Booked_Q2__c!= null){
                        gi.decBookedRev += cong.Booked_Q2__c;
                    }
                } else if(strTimePeriod=='Q3'){
                    if(cong.Q3__c!= null){
                        gi.decBestGuess += cong.Q3__c;
                    }
                    if(cong.Booked_Q3__c!= null){
                        gi.decBookedRev += cong.Booked_Q3__c;
                    }
                } else if(strTimePeriod=='Q4'){
                    if(cong.Q4__c!= null){
                        gi.decBestGuess += cong.Q4__c;
                    }
                    if(cong.Booked_Q4__c!= null){
                        gi.decBookedRev += cong.Booked_Q4__c;
                    }
                } else{
                    if(cong.Q1__c!= null){gi.decBestGuess += cong.Q1__c;}
                    if(cong.Q2__c!= null){gi.decBestGuess += cong.Q2__c;}
                    if(cong.Q3__c!= null){gi.decBestGuess += cong.Q3__c;}
                    if(cong.Q4__c!= null){gi.decBestGuess += cong.Q4__c;}
                    if(cong.Booked_Q1__c!= null){gi.decBookedRev += cong.Booked_Q1__c;}
                    if(cong.Booked_Q2__c!= null){gi.decBookedRev += cong.Booked_Q2__c;}
                    if(cong.Booked_Q3__c!= null){gi.decBookedRev += cong.Booked_Q3__c;}
                    if(cong.Booked_Q4__c!= null){gi.decBookedRev += cong.Booked_Q4__c;}    
                }
            }
            gi.decDiff = gi.decBestGuess - gi.decBookedRev;
            if(gi.decBestGuess>0 || gi.decBookedRev>0){
                lstGrid2.add(gi);
            }
        }
        
        Map<String,GridItem> mapGrid2DeDupe = new Map<String,GridItem>();
        for(GridItem gi : lstGrid2){
            if(mapGrid2DeDupe.get(gi.strAccName) == null){
                mapGrid2DeDupe.put(gi.strAccName,gi);
            } else {
                GridItem mapGI = mapGrid2DeDupe.get(gi.strAccName);
                mapGI.decBestGuess += gi.decBestGuess;
                mapGI.decBookedRev += gi.decBookedRev;
                mapGI.decDiff += gi.decDiff;
            }
        }
       
        strJSONGrid2 = JSON.serialize(mapGrid2DeDupe.values());
        lstGrid2 = new List<GridItem>();
        showGrid2 = true;
        return null;  
    }
    
    /*
    @Name   :getGrid4Data
    @Description :Method to prepare data for grid4 on vf page
    */
    public PageReference getGrid4Data(){
      //  if(!accPlanGrid){return null;}
        Map<String,String> accPlanMap = new Map<String,String>();
        List<Account> chldAcc = [Select Id, Name, Parent.Name From Account Where ParentId IN :accMap.values()];
        for(Account a : chldAcc){
            accPlanMap.put(a.Id,a.Parent.Name);
        }
        List<Attachment> lstAttch = [SELECT Id,ParentId,
                      Name, Parent.Name  
                      FROM Attachment 
                      WHERE ParentId IN :accMap.values()  
                      AND (Name LIKE 'Big Bet%' OR Name LIKE 'big bet%' OR Name LIKE 'bigbet%' OR Name LIKE 'BigBet%') 
                      Order By LastModifiedDate desc];
        List<Attachment> lstAttch2 = [SELECT Id,ParentId,
                      Name, Parent.Name  
                      FROM Attachment 
                      WHERE ParentId IN :chldAcc  
                      AND (Name LIKE 'Account Plan%' OR Name LIKE 'account plan%' OR Name LIKE 'accountplan%' OR Name LIKE 'AccountPlan%')  
                      Order By LastModifiedDate desc];
        List<GridItem> lstGrid4 = new List<GridItem>();
        for(String strAccName : setCongAccNames){
            GridItem gi = new GridItem('',0,0,0,0,0,0,0,'','','',0,'','','');
            gi.strAccName = '<a href=/'+accMap.get(strAccName)+' target=_blank><U>'+strAccName.replaceAll('"','')+'</U></a>';
            gi.sortAccName = strAccName;
            for(Attachment a : lstAttch){
                String attName = a.Name.toLowerCase();                
                if(a.Parent.Name == strAccName){
                    if(attName!= null && !gi.bigBets.contains(a.Name) && (attName.startsWith('big bet') || attName.startsWith('bigbet')) && a.Name.contains(strYear)){
                        gi.attchId = a.Id;
                        gi.bigBets += '<a href=/servlet/servlet.FileDownload?file='+a.Id+' target=_blank><U>'+a.Name.replaceAll('"','')+'</U></a><br />';
                    }
                }
            }
            for(Attachment a : lstAttch2){
                String attName = a.Name.toLowerCase();                
                if(accPlanMap.get(a.ParentId) == strAccName){
                    if(attName!= null && !gi.accountPlan.contains(a.Name) && (attName.startsWith('account plan') || attName.startsWith('accountplan')) && a.Name.contains(strYear)){
                        gi.attchId = a.Id;
                        gi.accountPlan += '<a href=/servlet/servlet.FileDownload?file='+a.Id+' target=_blank><U>'+a.Name.replaceAll('"','')+'</U></a><br />';
                    }
                }
            }
            lstGrid4.add(gi);
        }
        strJSONGrid4 = JSON.serialize(lstGrid4);
        lstGrid4 = new List<GridItem>();
        showGrid4 = true;
        return null;   
    }
    
    /*
    @Name   :getGrid5Data
    @Description :Method to prepare data for grid5 on vf page
    */
    public PageReference getGrid5Data(){
      //  if(!conGrid){return null;}
        List<GridItem> lstGrid5 = new List<GridItem>();
        //Set<String> setChildAccountIds = new Set<String>();
        List<Contact> lstContacts = [SELECT Id, Name, Title, Email, Account.Name, AccountId   
                                     FROM Contact 
                                     WHERE AccountId IN :accMap.values() AND Account.Type='Conglomerate'];
        Map<ID,Account> lstChildAccounts = new Map<ID, Account>([SELECT Id, Name, ParentId, Parent.Name    
                                     FROM Account 
                                     WHERE Account.ParentId IN :accMap.values() AND Account.Type!='Conglomerate']);
  /*      for(Account a : lstChildAccounts){
            setChildAccountIds.add(a.Id);    
        }
*/
        List<Contact> lstChildAccContacts = [SELECT Id, Name, Title, Email, Account.Name, AccountId, 
                                     Account.ParentId, Account.Parent.Name    
                                     FROM Contact 
                                     WHERE Account.Id IN :lstChildAccounts.keyset() AND Account.Type!='Conglomerate'];        
        Map<String,List<Contact>> mapAccContacts = new Map<String,List<Contact>>();
        for(Contact con : lstContacts){
            if(mapAccContacts.get(con.Account.Name) == null){
                List<Contact> lstCon = new List<Contact>();
                lstCon.add(con);
                mapAccContacts.put(con.Account.Name,lstCon);
            } else {
                mapAcccontacts.get(con.Account.Name).add(con);
            }
        }
        for(Contact con : lstChildAccContacts){
            if(mapAccContacts.get(con.Account.Parent.Name) == null){
                List<Contact> lstCon = new List<Contact>();
                lstCon.add(con);
                mapAccContacts.put(con.Account.Parent.Name,lstCon);
            } else {
                mapAcccontacts.get(con.Account.Parent.Name).add(con);
            }
        }
        Integer i=1;
        for(String strAccName : setCongAccNames){
                GridItem gi = new GridItem('',0,0,0,0,0,0,0,'','','',0,'','','');
                gi.strAccName = '<a href=/'+accMap.get(strAccName)+' target=_blank><u>'+strAccName.replaceAll('"','')+'</u></a>';
                gi.sortAccName = strAccName;
                if(mapAccContacts.get(strAccName) != null){
                    gi.lstContacts = mapAccContacts.get(strAccName);
                    gi.numContacts = gi.lstContacts.size();
                } else {
                    gi.lstContacts = new List<Contact>();
                    gi.numContacts = 0;
                }
                //show only those accounts which has Contacts associated
                if(gi.numContacts > 0 && i<=250){
                    lstGrid5.add(gi);
                    i++;
                }
                if(lstGrid5.size()>0){
                    showReport5Link = true;
                }
                
         
        }
        strJSONGrid5 = JSON.serialize(lstGrid5); 
        //lstGrid5 = new List<GridItem>();
        showGrid5 = true; 
        return null;
    }
    
    /*
    @Name   :getGrid6Data
    @Description :Method to prepare data for grid6 on vf page
    */
    public PageReference getGrid6Data(){
       // if(!top10OppGrid){return null;}
        List<Opportunity> lstTopTenOpps = new List<Opportunity>();
        Date minQuarterRange;
        Date maxQuarterRange;
        if(strTimePeriod=='Q1'){
            minQuarterRange = date.newinstance(Integer.valueOf(strYear), 1, 1);
            maxQuarterRange = date.newinstance(Integer.valueOf(strYear), 3, 31);
        } else if(strTimePeriod=='Q2'){
            minQuarterRange = date.newinstance(Integer.valueOf(strYear), 4, 1);
            maxQuarterRange = date.newinstance(Integer.valueOf(strYear), 6, 31);
        } else if(strTimePeriod=='Q3'){
            minQuarterRange = date.newinstance(Integer.valueOf(strYear), 7, 1);
            maxQuarterRange = date.newinstance(Integer.valueOf(strYear), 9, 31);
        } else if(strTimePeriod=='Q4'){
            minQuarterRange = date.newinstance(Integer.valueOf(strYear), 10, 1);
            maxQuarterRange = date.newinstance(Integer.valueOf(strYear), 12, 31);
        } else{
            minQuarterRange = date.newinstance(Integer.valueOf(strYear), 1, 1);
            maxQuarterRange = date.newinstance(Integer.valueOf(strYear), 12, 31);
        }
        if(searchAcc.Name=='' || searchAcc.Name==null){
            if(strClientSegment == 'All'){
                lstTopTenOpps = [SELECT Id,Name,
                        Amount,StageName,Account.Name  
                        FROM Opportunity 
                        WHERE /*Account.Status__c!=null AND Account.Status__c !='' and*/ Account.RecordType.Name IN :lstAccRTs  
                        AND StageName!='Closed Won' AND StageName!='Closed Won Renewal' 
                        AND StageName!='Closed Lost' AND StageName!='Closed Won Addendum' 
                        AND StageName!='Closed Error' AND StageName!='Closée +' 
                        AND StageName!='Closée -' AND Amount!=null 
                        AND ((Start_Date__c >= :minQuarterRange AND Start_Date__c <= :maxQuarterRange) 
                            OR (End_Date__c >= :minQuarterRange AND End_Date__c <= :maxQuarterRange) 
                            OR (Start_Date__c < :minQuarterRange AND End_Date__c > :maxQuarterRange)) 
                        ORDER BY Amount Desc LIMIT 10];
            }else if(strClientSegment == 'Other'){
                lstTopTenOpps = [SELECT Id,Name,
                        Amount,StageName,Account.Name  
                        FROM Opportunity 
                        WHERE /*Account.Status__c !=null and*/ Account.Status__c != 'Platinum' and Account.Status__c != 'Gold' 
                        AND Account.RecordType.Name IN :lstAccRTs  
                        AND StageName!='Closed Won' AND StageName!='Closed Won Renewal' 
                        AND StageName!='Closed Lost' AND StageName!='Closed Won Addendum' 
                        AND StageName!='Closed Error' AND StageName!='Closée +' 
                        AND StageName!='Closée -' AND Amount!=null 
                        AND ((Start_Date__c >= :minQuarterRange AND Start_Date__c <= :maxQuarterRange) 
                            OR (End_Date__c >= :minQuarterRange AND End_Date__c <= :maxQuarterRange) 
                            OR (Start_Date__c < :minQuarterRange AND End_Date__c > :maxQuarterRange)) 
                        ORDER BY Amount Desc LIMIT 10];
            } else {
                lstTopTenOpps = [SELECT Id,Name,
                        Amount,StageName,Account.Name  
                        FROM Opportunity 
                        WHERE Account.status__c = :strClientSegment AND Account.RecordType.Name IN :lstAccRTs  
                        AND StageName!='Closed Won' AND StageName!='Closed Won Renewal' 
                        AND StageName!='Closed Lost' AND StageName!='Closed Won Addendum' 
                        AND StageName!='Closed Error' AND StageName!='Closée +' 
                        AND StageName!='Closée -' AND Amount!=null 
                        AND ((Start_Date__c >= :minQuarterRange AND Start_Date__c <= :maxQuarterRange) 
                            OR (End_Date__c >= :minQuarterRange AND End_Date__c <= :maxQuarterRange) 
                            OR (Start_Date__c < :minQuarterRange AND End_Date__c > :maxQuarterRange)) 
                        ORDER BY Amount Desc LIMIT 10];
            }
        } else {
            List<Account> lstChildAccs;
            if(searchAcc.Name != null){
                lstChildAccs = [SELECT Id,Name 
                                FROM Account 
                                WHERE ParentId = :accMap.values() 
                                AND Type!='Conglomerate'];
            }else{            
                lstChildAccs = [SELECT Id,Name 
                                FROM Account 
                                WHERE ParentId IN :accMap.values()  
                                AND Type!='Conglomerate'];
            }
            lstTopTenOpps = [SELECT Id,Name,
                        Amount,StageName,Account.Name   
                        FROM Opportunity 
                        WHERE AccountId IN: lstChildAccs 
                        AND StageName!='Closed Won' AND StageName!='Closed Won Renewal' 
                        AND StageName!='Closed Lost' AND StageName!='Closed Won Addendum' 
                        AND StageName!='Closed Error' AND StageName!='Closée +' 
                        AND StageName!='Closée -' AND Amount!=null 
                        AND ((Start_Date__c >= :minQuarterRange AND Start_Date__c <= :maxQuarterRange) 
                            OR (End_Date__c >= :minQuarterRange AND End_Date__c <= :maxQuarterRange) 
                            OR (Start_Date__c < :minQuarterRange AND End_Date__c > :maxQuarterRange)) 
                        AND RecordType.Name IN ('Contract','Proposal','Recovery','Renewal') 
                        ORDER BY Amount Desc LIMIT 10];
        }
        List<GridItem> lstGrid6 = new List<GridItem>();
        for(Opportunity o : lstTopTenOpps){
            GridItem gi = new GridItem('',0,0,0,0,0,0,0,'','','',0,'','','');
            gi.oppName = '<a href=/'+o.Id+' target=_blank><U>'+o.Name.replaceAll('"','')+'</U></a>';
            gi.attchId = o.Name;
            gi.sortOppName = o.Name;
            if(o.Account.Name != null){
                gi.strAccName = '<a href=/'+o.Account.Id+' target=_blank><U>'+o.Account.Name.replaceAll('"','')+'</U></a>';
                gi.sortAccName = o.Account.Name;
            }
            if(o.Amount != null){
                gi.amount = o.Amount;
            }
            if(o.StageName != null){
                gi.stage = o.StageName;
            }
            lstGrid6.add(gi);
        }
        strJSONGrid6 = JSON.serialize(lstGrid6);  
        lstGrid6 = new List<GridItem>(); 
        showGrid6 = true; 
        return null;
    }
    
    /*
    @Name   :getGrid7Data
    @Description :Method to prepare data for grid7 on vf page
    */
    public PageReference getGrid7Data(){
      //  if(!oppGrid){return null;}
        List<Account> lstChildAccs;
        Date minQuarterRange;
        Date maxQuarterRange;
        if(strTimePeriod=='Q1'){
            minQuarterRange = date.newinstance(Integer.valueOf(strYear), 1, 1);
            maxQuarterRange = date.newinstance(Integer.valueOf(strYear), 3, 31);
        } else if(strTimePeriod=='Q2'){
            minQuarterRange = date.newinstance(Integer.valueOf(strYear), 4, 1);
            maxQuarterRange = date.newinstance(Integer.valueOf(strYear), 6, 31);
        } else if(strTimePeriod=='Q3'){
            minQuarterRange = date.newinstance(Integer.valueOf(strYear), 7, 1);
            maxQuarterRange = date.newinstance(Integer.valueOf(strYear), 9, 31);
        } else if(strTimePeriod=='Q4'){
            minQuarterRange = date.newinstance(Integer.valueOf(strYear), 10, 1);
            maxQuarterRange = date.newinstance(Integer.valueOf(strYear), 12, 31);
        } else{
            minQuarterRange = date.newinstance(Integer.valueOf(strYear), 1, 1);
            maxQuarterRange = date.newinstance(Integer.valueOf(strYear), 12, 31);
        }
        if(searchAcc.Name != null){
            lstChildAccs = [SELECT Id,Name 
                            FROM Account 
                            WHERE ParentId = :accMap.values() 
                            AND Type!='Conglomerate'];
        }else{            
            lstChildAccs = [SELECT Id,Name 
                            FROM Account 
                            WHERE ParentId IN :accMap.values() 
                            AND Type!='Conglomerate'];
        }
        AggregateResult[] groupedResults = [SELECT StageName,SUM(Amount)   
                            FROM Opportunity 
                            WHERE AccountId IN :lstChildAccs 
                            AND (IsClosed = false OR (IsClosed = true AND IsWon = true))  
                            AND ((Start_Date__c >= :minQuarterRange AND Start_Date__c <= :maxQuarterRange) 
                            OR (End_Date__c >= :minQuarterRange AND End_Date__c <= :maxQuarterRange) 
                            OR (Start_Date__c < :minQuarterRange AND End_Date__c > :maxQuarterRange))  
                            AND RecordType.Name IN ('Contract','Proposal','Recovery','Renewal')  
                            GROUP BY StageName];
        List<GridItem> lstGrid7 = new List<GridItem>();
        for(AggregateResult ar : groupedResults){
            GridItem gi = new GridItem('',0,0,0,0,0,0,0,'','','',0,'','','');
            if(searchAcc.Name != null){
                gi.strAccName = searchAcc.Name;
                gi.strAccName = '<a href=/'+accMap.get(searchAcc.Name)+' target=_blank><U>'+searchAcc.Name.replaceAll('"','')+'</U></a>';
            } else{
                gi.strAccName = strClientSegment+' - '+strCustomerType;
            }
            if(ar.get('StageName')!=null){
                gi.stage = (String) ar.get('StageName');
            }
            if(ar.get('expr0')!=null){                         
                gi.amount = (Decimal) ar.get('expr0'); 
            }             
            lstGrid7.add(gi);
        }
        strJSONGrid7 = JSON.serialize(lstGrid7); 
        lstGrid7 = new List<GridItem>();
        showGrid7 = true;
        return null;   
    } 
    
    /*
    @Name   :getGrid8Data
    @Description :Method to prepare data for grid8 on vf page
    */
    public PageReference getGrid8Data(){
      //  if(!bvdsGrid){return null;}
        List<AccountTeamMember> lstATMs = [SELECT Id,UserId,User.Name, 
                   AccountId,Account.Name,TeamMemberRole   
                   FROM AccountTeamMember 
                   WHERE AccountId IN :accMap.values()   
                   AND Account.Type='Conglomerate'  
                   AND (TeamMemberRole='Digital Specialist' 
                   OR TeamMemberRole='BuyerVision Specialist')]; 
        List<GridItem> lstGrid8 = new List<GridItem>();
        for(String strAccName : setCongAccNames){
            GridItem gi = new GridItem('',0,0,0,0,0,0,0,'','','',0,'','','');
            gi.strAccName = '<a href=/'+accMap.get(strAccName)+' target=_blank><U>'+strAccName.replaceAll('"','')+'</U></a>';
            gi.sortAccName = strAccName;
            for(AccountTeamMember a : lstATMs){
                if(a.Account.Name == strAccName){
                    if(a.User.Name!= null && a.TeamMemberRole=='Digital Specialist'){
                        gi.digitalSpecialist = a.User.Name;
                        if(gi.buyerVsnSpecialiat!=null && gi.buyerVsnSpecialiat!=''){
                            break;
                        }
                    }
                    if(a.User.Name!= null && a.TeamMemberRole=='BuyerVision Specialist'){
                        gi.buyerVsnSpecialiat = a.User.Name;
                        if(gi.digitalSpecialist!=null && gi.digitalSpecialist!=''){
                            break;
                        }
                    }
                }
            }
            if((gi.digitalSpecialist!=null && gi.digitalSpecialist!='') || (gi.buyerVsnSpecialiat!=null && gi.buyerVsnSpecialiat!='')){
                lstGrid8.add(gi);
                showReport8Link = true;
            }
        }
        strJSONGrid8 = JSON.serialize(lstGrid8);
        lstGrid8 = new List<GridItem>();
        showGrid8 = true;
        return null;   
    }
}