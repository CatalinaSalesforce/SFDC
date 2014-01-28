/*
@Name           : EuropeReportLandingController
@Author         : customersuccess@cloud62.com
@Date           : 12/06/2013
@Description    : Controller for displaying dashboards for Europe users.
*/
public with sharing class EuropeReportLandingController{

    //variables
    public User usr;
    public String reporttype{get; set;}
    public Boolean isFranceUser{get;set;}
    public Boolean isItalyUser{get;set;}
    public Boolean isGermanyUser{get;set;}
    public List<ReportAndDashboardWrapper> wrapperSD{get;set;}
    public List<ReportAndDashboardWrapper> wrapperManD{get;set;}
    public List<ReportAndDashboardWrapper> wrapperPacD{get;set;}
    public List<ReportAndDashboardWrapper> wrapperRD{get;set;}
    public List<ReportAndDashboardWrapper> wrapperSMD{get;set;}
    public List<ReportAndDashboardWrapper> wrapperDRD{get;set;}
    public List<ReportAndDashboardWrapper> wrapperMyFav{get;set;}
    public EuropeReportLandingSetting__c setting;
    
    /*
    @Name   :EuropeReportLandingController
    @Description :Constructor
    */
    public EuropeReportLandingController(){
        // query the current logged in user
        usr = [Select Id, Profile.Name From User Where Id=:Userinfo.getUserId()];
        displayReportsDashBoard();
   
    }
    
    /*
    @Name   :goToReportDashboardDisplay
    @Description :redirect to dashboard
    */
    public PageReference goToReportDashboardDisplay(){
        String dashboardId = '';
        //check for the clicked icon
        if(reporttype == 'MyFav'){
            if(setting != null && setting.My_Favorite_Folder_Ids__c != null){
                dashboardId = setting.My_Favorite_Folder_Ids__c;
            }
        } else if(reporttype == 'FSD'){
            if(setting != null && setting.Sales_Dashboard_Ids__c != null){
                dashboardId = setting.Sales_Dashboard_Ids__c;
            }
        } else if(reporttype == 'FDR'){
            if(setting != null && setting.Manufacturing_Dashboard_Ids__c != null){
                dashboardId = setting.Manufacturing_Dashboard_Ids__c;
            }
        } else if(reporttype == 'FMD'){
            if(setting != null && setting.Manager_Dashboard_Ids__c != null){
                dashboardId = setting.Manager_Dashboard_Ids__c;
            }
        } else if(reporttype == 'FRD'){
            if(setting != null && setting.Renewals_Dashboard_Ids__c != null){
                dashboardId = setting.Renewals_Dashboard_Ids__c;
            }
        } else if(reporttype == 'FSMD'){
            if(setting != null && setting.Service_Marque_Dashboard_Ids__c != null){
                dashboardId = setting.Service_Marque_Dashboard_Ids__c;
            }
        }else if(reporttype == 'Pacing'){
            if(setting != null && setting.Pacing_Dashboard_Ids__c != null){
                dashboardId = setting.Pacing_Dashboard_Ids__c;
            }
        } else if(reporttype == 'ISD'){
            if(setting != null && setting.Sales_Dashboard_Ids__c != null){
                dashboardId = setting.Sales_Dashboard_Ids__c;
            }
        } else if(reporttype == 'IMFD'){
            if(setting != null && setting.Manufacturing_Dashboard_Ids__c != null){
                dashboardId = setting.Manufacturing_Dashboard_Ids__c;
            }
        } else if(reporttype == 'IRD'){
            if(setting != null && setting.Renewals_Dashboard_Ids__c != null){
                dashboardId = setting.Renewals_Dashboard_Ids__c;
            }
        } else if(reporttype == 'GSD'){
            if(setting != null && setting.Sales_Dashboard_Ids__c != null){
                dashboardId = setting.Sales_Dashboard_Ids__c;
            }
        } else if(reporttype == 'GMFD'){
            if(setting != null && setting.Manufacturing_Dashboard_Ids__c != null){
                dashboardId = setting.Manufacturing_Dashboard_Ids__c;
            }
        } else if(reporttype == 'GRD'){
            if(setting != null && setting.Renewals_Dashboard_Ids__c != null){
                dashboardId = setting.Renewals_Dashboard_Ids__c;
            }
        }
        
        PageReference p = new PageReference('/'+dashboardId);        
        p.setRedirect(true);
        return p;
    }
    
    /*
    @Name   :displayReportsDashBoard
    @Description :method to display dashboard icons based on the user profile and get the appropriate custom setting. 
    */
    public void displayReportsDashBoard(){   
        List<String> reportSDIds = new List<String>();
        List<String> reportManDIds = new List<String>();
        List<String> reportMfdDIds = new List<String>();
        List<String> reportRDIds = new List<String>();
        List<String> reportSMDIds = new List<String>();
        List<String> reportPacIds = new List<String>();
        
        wrapperSD = new List<ReportAndDashboardWrapper>();
        wrapperManD = new List<ReportAndDashboardWrapper>();
        wrapperPacD = new List<ReportAndDashboardWrapper>();
        wrapperRD = new List<ReportAndDashboardWrapper>();
        wrapperSMD = new List<ReportAndDashboardWrapper>();
        wrapperDRD = new List<ReportAndDashboardWrapper>();
        wrapperMyFav = new List<ReportAndDashboardWrapper>();
        
        List<Report> reportMyFav = [Select Id, Name From Report Where Ownerid =: Userinfo.getUserId() Limit 5];
        for(Report r : reportMyFav){
             ReportAndDashboardWrapper wrapper = new ReportAndDashboardWrapper(r.Id,r.Name);
             wrapperMyFav.add(wrapper);
        }
             
        if(usr.Profile.Name.contains('France') || usr.Profile.Name.contains('Admin')){
            isFranceUser = true;
            setting = EuropeReportLandingSetting__c.getInstance('FranceReports');
            
            if(setting != null && setting.Sales_Dashboard_Report_Ids__c != null){
                reportSDIds = setting.Sales_Dashboard_Report_Ids__c.split(',');
            }
            
            List<Report> reportSD = [Select Id, Name From Report Where Id IN : reportSDIds];
            List<Dashboard> dashSD = [Select Id, Title From Dashboard Where Id IN : reportSDIds];
            
            for(Report r : reportSD){
                ReportAndDashboardWrapper wrapper = new ReportAndDashboardWrapper(r.Id,r.Name);
                wrapperSD.add(wrapper);
            }
            
            for(Dashboard d : dashSD){
                ReportAndDashboardWrapper wrapper = new ReportAndDashboardWrapper(d.Id,d.Title);
                wrapperSD.add(wrapper);
            }
            
            if(setting != null && setting.Manager_Dashboard_Report_Ids__c != null){
                reportManDIds = setting.Manager_Dashboard_Report_Ids__c.split(',');
            }
            
            List<Report> reportManD = [Select Id, Name From Report Where Id IN : reportManDIds];
            List<Dashboard> dashManD = [Select Id, Title From Dashboard Where Id IN : reportManDIds];
            
            for(Report r : reportManD){
                ReportAndDashboardWrapper wrapper = new ReportAndDashboardWrapper(r.Id,r.Name);
                wrapperManD.add(wrapper);
            }
            
            for(Dashboard d : dashManD){
                ReportAndDashboardWrapper wrapper = new ReportAndDashboardWrapper(d.Id,d.Title);
                wrapperManD.add(wrapper);
            }
            
            if(setting != null && setting.Manufacturing_Dashboard_Report_Ids__c != null){
                reportMfdDIds = setting.Manufacturing_Dashboard_Report_Ids__c.split(',');
            }
            
            List<Report> reportDRD = [Select Id, Name From Report Where Id IN : reportMfdDIds];
            List<Dashboard> dashDRD = [Select Id, Title From Dashboard Where Id IN : reportMfdDIds];
            
            for(Report r : reportDRD){
                ReportAndDashboardWrapper wrapper = new ReportAndDashboardWrapper(r.Id,r.Name);
                wrapperDRD.add(wrapper);
            }
            
            for(Dashboard d : dashDRD){
                ReportAndDashboardWrapper wrapper = new ReportAndDashboardWrapper(d.Id,d.Title);
                wrapperDRD.add(wrapper);
            }
            
            if(setting != null && setting.Renewals_Dashboard_Report_Ids__c != null){
                reportRDIds = setting.Renewals_Dashboard_Report_Ids__c.split(',');
            }
            
            List<Report> reportRD = [Select Id, Name From Report Where Id IN : reportRDIds];
            List<Dashboard> dashRD = [Select Id, Title From Dashboard Where Id IN : reportRDIds];
            
            for(Report r : reportRD){
                ReportAndDashboardWrapper wrapper = new ReportAndDashboardWrapper(r.Id,r.Name);
                wrapperRD.add(wrapper);
            }
            
            for(Dashboard d : dashRD){
                ReportAndDashboardWrapper wrapper = new ReportAndDashboardWrapper(d.Id,d.Title);
                wrapperRD.add(wrapper);
            }
            
            if(setting != null && setting.Service_Marque_Dashboard_Report_Ids__c != null){
                reportSMDIds = setting.Service_Marque_Dashboard_Report_Ids__c.split(',');
            }
            
            List<Report> reportSMD = [Select Id, Name From Report Where Id IN : reportSMDIds];
            List<Dashboard> dashSMD = [Select Id, Title From Dashboard Where Id IN : reportSMDIds];
            
            for(Report r : reportSMD){
                ReportAndDashboardWrapper wrapper = new ReportAndDashboardWrapper(r.Id,r.Name);
                wrapperSMD.add(wrapper);
            }
            
            for(Dashboard d : dashSMD){
                ReportAndDashboardWrapper wrapper = new ReportAndDashboardWrapper(d.Id,d.Title);
                wrapperSMD.add(wrapper);
            }
            
            if(setting != null && setting.Pacing_Dashboard_Report_Ids__c != null){
                reportPacIds = setting.Pacing_Dashboard_Report_Ids__c.split(',');
            }
            
            List<Report> reportPacD = [Select Id, Name From Report Where Id IN : reportPacIds];
            List<Dashboard> dashPacD = [Select Id, Title From Dashboard Where Id IN : reportPacIds];
            
            for(Report r : reportPacD){
                ReportAndDashboardWrapper wrapper = new ReportAndDashboardWrapper(r.Id,r.Name);
                wrapperPacD.add(wrapper);
            }
            
            for(Dashboard d : dashPacD){
                ReportAndDashboardWrapper wrapper = new ReportAndDashboardWrapper(d.Id,d.Title);
                wrapperPacD.add(wrapper);
            }
        } else if(usr.Profile.Name.contains('Italy')){
            isItalyUser = true;
            setting = EuropeReportLandingSetting__c.getInstance('ItalyReports');
            
            if(setting != null && setting.Sales_Dashboard_Report_Ids__c != null){
                reportSDIds = setting.Sales_Dashboard_Report_Ids__c.split(',');
            }
            
            List<Report> reportSD = [Select Id, Name From Report Where Id IN : reportSDIds];
            List<Dashboard> dashSD = [Select Id, Title From Dashboard Where Id IN : reportSDIds];
            
            for(Report r : reportSD){
                ReportAndDashboardWrapper wrapper = new ReportAndDashboardWrapper(r.Id,r.Name);
                wrapperSD.add(wrapper);
            }
            
            for(Dashboard d : dashSD){
                ReportAndDashboardWrapper wrapper = new ReportAndDashboardWrapper(d.Id,d.Title);
                wrapperSD.add(wrapper);
            }
            
            if(setting != null && setting.Manufacturing_Dashboard_Report_Ids__c != null){
                reportMfdDIds = setting.Manufacturing_Dashboard_Report_Ids__c.split(',');
            }
            
            List<Report> reportDRD = [Select Id, Name From Report Where Id IN : reportMfdDIds];
            List<Dashboard> dashDRD = [Select Id, Title From Dashboard Where Id IN : reportMfdDIds];
            
            for(Report r : reportDRD){
                ReportAndDashboardWrapper wrapper = new ReportAndDashboardWrapper(r.Id,r.Name);
                wrapperDRD.add(wrapper);
            }
            
            for(Dashboard d : dashDRD){
                ReportAndDashboardWrapper wrapper = new ReportAndDashboardWrapper(d.Id,d.Title);
                wrapperDRD.add(wrapper);
            }
            
            if(setting != null && setting.Renewals_Dashboard_Report_Ids__c != null){
                reportRDIds = setting.Renewals_Dashboard_Report_Ids__c.split(',');
            }
            
            List<Report> reportRD = [Select Id, Name From Report Where Id IN : reportRDIds];
            List<Dashboard> dashRD = [Select Id, Title From Dashboard Where Id IN : reportRDIds];
            
            for(Report r : reportRD){
                ReportAndDashboardWrapper wrapper = new ReportAndDashboardWrapper(r.Id,r.Name);
                wrapperRD.add(wrapper);
            }
            
            for(Dashboard d : dashRD){
                ReportAndDashboardWrapper wrapper = new ReportAndDashboardWrapper(d.Id,d.Title);
                wrapperRD.add(wrapper);
            }
        } else if(usr.Profile.Name.contains('Germany')){
            isGermanyUser = true;
            setting = EuropeReportLandingSetting__c.getInstance('GermanyReports');
            
            if(setting != null && setting.Sales_Dashboard_Report_Ids__c != null){
                reportSDIds = setting.Sales_Dashboard_Report_Ids__c.split(',');
            }
            
            List<Report> reportSD = [Select Id, Name From Report Where Id IN : reportSDIds];
            List<Dashboard> dashSD = [Select Id, Title From Dashboard Where Id IN : reportSDIds];
            
            for(Report r : reportSD){
                ReportAndDashboardWrapper wrapper = new ReportAndDashboardWrapper(r.Id,r.Name);
                wrapperSD.add(wrapper);
            }
            
            for(Dashboard d : dashSD){
                ReportAndDashboardWrapper wrapper = new ReportAndDashboardWrapper(d.Id,d.Title);
                wrapperSD.add(wrapper);
            }
            
            if(setting != null && setting.Manufacturing_Dashboard_Report_Ids__c != null){
                reportMfdDIds = setting.Manufacturing_Dashboard_Report_Ids__c.split(',');
            }
            
            List<Report> reportDRD = [Select Id, Name From Report Where Id IN : reportMfdDIds];
            List<Dashboard> dashDRD = [Select Id, Title From Dashboard Where Id IN : reportMfdDIds];
            
            for(Report r : reportDRD){
                ReportAndDashboardWrapper wrapper = new ReportAndDashboardWrapper(r.Id,r.Name);
                wrapperDRD.add(wrapper);
            }
            
            for(Dashboard d : dashDRD){
                ReportAndDashboardWrapper wrapper = new ReportAndDashboardWrapper(d.Id,d.Title);
                wrapperDRD.add(wrapper);
            }
            
            if(setting != null && setting.Renewals_Dashboard_Report_Ids__c != null){
                reportRDIds = setting.Renewals_Dashboard_Report_Ids__c.split(',');
            }
            
            List<Report> reportRD = [Select Id, Name From Report Where Id IN : reportRDIds];
            List<Dashboard> dashRD = [Select Id, Title From Dashboard Where Id IN : reportRDIds];
            
            for(Report r : reportRD){
                ReportAndDashboardWrapper wrapper = new ReportAndDashboardWrapper(r.Id,r.Name);
                wrapperRD.add(wrapper);
            }
            
            for(Dashboard d : dashRD){
                ReportAndDashboardWrapper wrapper = new ReportAndDashboardWrapper(d.Id,d.Title);
                wrapperRD.add(wrapper);
            }
        }
    }
    
    public class ReportAndDashboardWrapper{
        public String id{get;set;}
        public String name{get;set;}
        
        public ReportAndDashboardWrapper(String recordId, String recordName){
            this.id = recordId;
            this.name = recordName;
        }    
    }
    
}