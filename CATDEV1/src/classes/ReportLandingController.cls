public with sharing class ReportLandingController {
    
    // variables
    public User u;
    public string uRole;
    public string uProfile;
    public Boolean salesLandingIcons{get; set;}
    public Boolean executiveLandingIcons{get; set;}
    public Boolean adminLandingIcons{get; set;} 
    public List<Report> report{get; set;}
    public List<Dashboard> dashboards{get; set;}
    public Boolean isfavReport{get; set;}
    public Boolean isdashboard{get; set;}
    public List<String> ReportIDs {get; set;}
    public string reporttype{get; set;}
    private List<String> AdminUser ;
    private List<String> ExecutiveUser ;
    private List<String> SalesUser ;
    
    // constructor
    public ReportLandingController(){
        try{
            // query the current user logged in
            u = [select id, Highest_User__c, Forecast_Role__c,Profile.Name from user where id=:userinfo.getuserid()];
            uRole = u.Forecast_Role__c;
            uProfile = u.Profile.Name;
  
            // get the custom settings
            ReportLandingSetting__c rls = [select Public_Group_Access_Name__c,AdminUserRoles__c, ExecutiveUserRoles__c, SalesUserRoles__c from ReportLandingSetting__c where name = 'DisplayUserRole'];

            if (rls.AdminUserRoles__c != null && rls.AdminUserRoles__c != ''){
                AdminUser = rls.AdminUserRoles__c.split(',') ;
            }
            if (rls.ExecutiveUserRoles__c != null && rls.ExecutiveUserRoles__c != ''){
                ExecutiveUser = rls.ExecutiveUserRoles__c.split(',') ;
            }
            if (rls.SalesUserRoles__c != null && rls.SalesUserRoles__c != ''){
                SalesUser = rls.SalesUserRoles__c.split(',') ;
            }

         
            for(String u : AdminUser){
                if(uProfile.equals(u)){
                    adminLandingIcons = true;
                    break;
                }
            }
            if( uRole !=null && uRole != ''){
                    for(String su : SalesUser){
                        if(uRole.equals(su)){
                             salesLandingIcons = true;
                             break;
                        }
                    }
                    if( uRole !='' && uRole!=null){
                        for(String eu :ExecutiveUser){
                            if(uRole.equals(eu)){
                                executiveLandingIcons = true;
                                break;
                            }   
                        }
                    }
            }
            else
            {               
                
                List<GroupMember> areGroupMember = [SELECT UserOrGroupId FROM GROUPMEMBER WHERE GROUP.NAME =: rls.Public_Group_Access_Name__c and UserOrGroupId =: u.id];
                
                if(areGroupMember.size() > 0)
                {                
                    executiveLandingIcons = true;                  
                }             
            
            }
        }
         catch (Exception ex) {
            ApexPages.addMessages(ex);
         }
         isfavReport = false;
         isdashboard = false; 
        reportType = ApexPages.currentPage().getParameters().get('reportType');
        if(reportType !=null && reportType != ''){
            displayReportsDashBoard();
        }        
         
    }
    
    // method to return back page
    public PageReference redirectToBack(){
        isfavReport = false;
        isdashboard = false;
        PageReference p = new PageReference('/apex/ReportLandingPage');
        p.setRedirect(true);
        return p;
    } 

    // move to report/dashboard display page
    public PageReference goToReportDashboardDisplay(){
        isfavReport = false;
        isdashboard = false;
        PageReference p = new PageReference('/apex/ReportLandingPageGrid?reporttype='+reporttype);
        
        p.setRedirect(true);
        return p;
    }  
     
    private List<User> getUserDetail(ID uId){
        List<User> uList= [select Highest_User__c, Forecast_Role__c,Profile.Name from user where id=:uId];
        return uList;
    }
        
    // method to display reports and dashboards  
    public void displayReportsDashBoard(){
        u = [select Highest_User__c, Forecast_Role__c,Profile.Name from user where id=:userinfo.getuserid()];
        uRole = u.Forecast_Role__c;
        uProfile = u.Profile.Name;
        
        report = new List<Report>();
        dashboards = new List<Dashboard>();
        
        // get the custom settings
        ReportLandingSetting__c rls = [select AccountManagementSM1Report__c, AccountManagementSM2Report__c, AccountManagementEVPReport__c, AccountManagementSR1Report__c, AccountManagementSR2Report__c, QuotaManagementId__c,AccManagementId__c,AccManagementDetailedId__c,ForecastingId__c,PeopleManagementId__c,ExecutiveReportId__c,SalesDashboardId__c,Executive_AdminDashboardId__c,RenewalsFolderName__c,RetiredReportFolderName__c,DashboardReportFolderName__c,AdminReportFolderName__c, GapEVPReport__c, GapSM1Report__c, GapSM2Report__c, GapSR1Report__c, GapSR2Report__c from ReportLandingSetting__c where name = 'DisplayReportIds'];
        
        ReportLandingSetting__c rlsRoles = [select AdminUserRoles__c, ExecutiveUserRoles__c, SalesUserRoles__c from ReportLandingSetting__c where name = 'DisplayUserRole'];
            if (rlsRoles.AdminUserRoles__c != null && rlsRoles.AdminUserRoles__c != ''){
                AdminUser = rlsRoles.AdminUserRoles__c.split(',') ;
            }
            Boolean isAdmin = false;
            for(String u : AdminUser){
                if(uProfile.equals(u)){
                    isAdmin = true;
                    break;
                }
            }
        
        if(reporttype == 'fav'){
            isfavReport = true;
            report = [select id, name, description from report where ownerid =: userinfo.getuserid()];
        }
        else if(reporttype == 'Quota'){
            isfavReport = true;
            if (rls.QuotaManagementId__c != null && rls.QuotaManagementId__c != ''){
                ReportIDs = rls.QuotaManagementId__c.split(',') ;
                report = [select id, name, description from report where id =: ReportIDs ORDER BY Name DESC];
            }
        }
        else if(reporttype == 'AccManagement'){
            isfavReport = true;
            if(u.Highest_User__c!=null && u.Highest_User__c!=''){
                List<User> highestUsers = getUserDetail(u.Highest_User__c);
                if(highestUsers.size()>0){
                    String highestuRole = highestUsers[0].Forecast_Role__c;
                    if(highestuRole!='' && highestuRole!=null){
                        uRole=highestuRole;
                       }
                }
            }
            
            if (rls.AccountManagementSM1Report__c != null && rls.AccountManagementSM1Report__c != '' && (uRole == 'SM1' || isAdmin)){
                ReportIDs = rls.AccountManagementSM1Report__c.split(',') ;
                report = [select id, name, description from report where id =: ReportIDs ORDER BY Name DESC];
            }
            if (rls.AccountManagementEVPReport__c != null && rls.AccountManagementEVPReport__c != '' && (uRole == 'EVP' || uRole == 'CEO')){
                ReportIDs = rls.AccountManagementEVPReport__c.split(',') ;
                report = [select id, name, description from report where id =: ReportIDs ORDER BY Name DESC];
            }
            if (rls.AccountManagementSM2Report__c != null && rls.AccountManagementSM2Report__c != '' && uRole == 'SM2'){
                ReportIDs = rls.AccountManagementSM2Report__c.split(',') ;
                report = [select id, name, description from report where id =: ReportIDs ORDER BY Name DESC];
            }
            if (rls.AccountManagementSR1Report__c != null && rls.AccountManagementSR1Report__c != '' && uRole == 'SR1'){
                ReportIDs = rls.AccountManagementSR1Report__c.split(',') ;
                report = [select id, name, description from report where id =: ReportIDs ORDER BY Name DESC];
            }
            if (rls.AccountManagementSR2Report__c != null && rls.AccountManagementSR2Report__c != '' && uRole == 'SR2'){
                ReportIDs = rls.AccountManagementSR2Report__c.split(',') ;
                report = [select id, name, description from report where id =: ReportIDs ORDER BY Name DESC];
            }
            

        }
        else if(reporttype == 'GapManagement'){
            isfavReport = true;
            if(u.Highest_User__c!=null && u.Highest_User__c!=''){
                List<User> highestUsers = getUserDetail(u.Highest_User__c);
                if(highestUsers.size()>0){
                    String highestuRole = highestUsers[0].Forecast_Role__c;
                    if(highestuRole!='' && highestuRole!=null){
                        uRole=highestuRole;
                       }
                }
            }
            
            if (rls.GapSM1Report__c != null && rls.GapSM1Report__c != '' && (uRole == 'SM1' || isAdmin)){
                ReportIDs = rls.GapSM1Report__c.split(',') ;
                report = [select id, name, description from report where id =: ReportIDs ORDER BY Name DESC];
            }
            if (rls.GapEVPReport__c != null && rls.GapEVPReport__c != '' && (uRole == 'EVP' || uRole == 'CEO')){
                ReportIDs = rls.GapEVPReport__c.split(',') ;
                report = [select id, name, description from report where id =: ReportIDs ORDER BY Name DESC];
            }
            if (rls.GapSM2Report__c != null && rls.GapSM2Report__c != '' && uRole == 'SM2'){
                ReportIDs = rls.GapSM2Report__c.split(',') ;
                report = [select id, name, description from report where id =: ReportIDs ORDER BY Name DESC];
            }
            if (rls.GapSR1Report__c != null && rls.GapSR1Report__c != '' && uRole == 'SR1'){
                ReportIDs = rls.GapSR1Report__c.split(',') ;
                report = [select id, name, description from report where id =: ReportIDs ORDER BY Name DESC];
            }
            if (rls.GapSR2Report__c != null && rls.GapSR2Report__c != '' && uRole == 'SR2'){
                ReportIDs = rls.GapSR2Report__c.split(',') ;
                report = [select id, name, description from report where id =: ReportIDs ORDER BY Name DESC];
            }
            

        }

        else if(reporttype == 'AccManagementDetailed'){
            isfavReport = true;
            if (rls.AccManagementDetailedId__c != null && rls.AccManagementDetailedId__c != ''){
                ReportIDs = rls.AccManagementDetailedId__c.split(',') ;
                report = [select id, name, description from report where id =: ReportIDs ORDER BY Name DESC];
            }    
        }
        else if(reporttype == 'Forecasting'){
            isfavReport = true;
            if (rls.ForecastingId__c != null && rls.ForecastingId__c != ''){
                ReportIDs = rls.ForecastingId__c.split(',') ;
                report = [select id, name, description from report where id =: ReportIDs ORDER BY Name DESC];
            }
        }
        else if(reporttype == 'PeopleManagement'){
            isfavReport = true;
            if (rls.PeopleManagementId__c != null && rls.PeopleManagementId__c != ''){
                ReportIDs = rls.PeopleManagementId__c.split(',') ;
                report = [select id, name, description from report where id =: ReportIDs ORDER BY Name DESC];
            }
        }
        else if(reporttype == 'Executive'){
            isfavReport = true;
            if (rls.ExecutiveReportId__c != null && rls.ExecutiveReportId__c != ''){
                ReportIDs = rls.ExecutiveReportId__c.split(',') ;
                report = [select id, name, description from report where id =: ReportIDs ORDER BY Name DESC];
            }
        }
        else if(reporttype == 'Renewals'){
            isfavReport = true;
            if (rls.RenewalsFolderName__c != null && rls.RenewalsFolderName__c != ''){
                ReportIDs = rls.RenewalsFolderName__c.split(',') ;
                List<Folder> fids = [Select Id From Folder f where Name = : ReportIDs ];
                if(fids.size()>0){
                    report = [select id, name, description from report where OwnerId IN : fids ORDER BY Name DESC];
                 }
            }
        }
        else if(reporttype == 'RetiredReport'){
            isfavReport = true;
            if (rls.RetiredReportFolderName__c != null && rls.RetiredReportFolderName__c != ''){
                ReportIDs = rls.RetiredReportFolderName__c.split(',') ;
                List<Folder> fids = [Select Id From Folder f where Name = : ReportIDs ];
                if(fids.size()>0){
                    report = [select id, name, description from report where OwnerId IN : fids ORDER BY Name DESC];
                }
            }
        }
        else if(reporttype == 'DashboardReport'){
            isfavReport = true;
            if (rls.DashboardReportFolderName__c != null && rls.DashboardReportFolderName__c != ''){
                ReportIDs = rls.DashboardReportFolderName__c.split(',') ;
                List<Folder> fids = [Select Id From Folder f where Name = : ReportIDs ];
                if(fids.size()>0){
                    report = [select id, name, description from report where OwnerId IN : fids ORDER BY Name DESC];
                 }
            }
        }
        else if(reporttype == 'AdminReport'){
            isfavReport = true;
            if (rls.AdminReportFolderName__c != null && rls.AdminReportFolderName__c != ''){
                ReportIDs = rls.AdminReportFolderName__c.split(',') ;
                List<Folder> fids = [Select Id From Folder f where Name = : ReportIDs ];
                if(fids.size()>0){
                    report = [select id, name, description from report where OwnerId IN : fids ORDER BY Name DESC];
                }
            }
        }
        else if(reporttype == 'salesDashboard'){
            if(salesLandingIcons == true){
                isdashboard = true;
                if (rls.SalesDashboardId__c != null && rls.SalesDashboardId__c != ''){
                    ReportIDs = rls.SalesDashboardId__c.split(',') ;
                    dashboards = [select id, Title, Description from Dashboard where id =: ReportIDs ORDER BY Title DESC];
                }
            }
            else if(executiveLandingIcons == true || adminLandingIcons == true){
                 isdashboard = true;
                 if (rls.Executive_AdminDashboardId__c != null && rls.Executive_AdminDashboardId__c != ''){
                     ReportIDs = rls.Executive_AdminDashboardId__c.split(',') ;
                     dashboards = [select id, Title, Description from Dashboard where id =: ReportIDs ORDER BY Title DESC];
                 }
            }    
        
        }
        if(report.size() <= 0 && reporttype != 'salesDashboard'){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO,'No Reports found');
            ApexPages.addMessage(msg);
        }else if(reporttype == 'salesDashboard' && dashboards.size() <=0){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO,'No Dashboard found');
            ApexPages.addMessage(msg);
        }
    }
    
    // report tracking
    public PageReference reportTracking(){
        String reportId = ApexPages.currentPage().getParameters().get('reportId');
        String reportName = ApexPages.currentPage().getParameters().get('reportName');
        if(reportId!=null && reportName!=null){
            Report_Landing_Page_Tracker__c rlpt = new Report_Landing_Page_Tracker__c(ReportId__c=reportId,Report_Name__c=reportName,User__c=UserInfo.getUserId(),Execution_Time__c=System.now());
            insert rlpt;
        }
        return null;
    }
    
    // dashboard tracking
    public PageReference dashboardTracking(){
        String dashboardId = ApexPages.currentPage().getParameters().get('dashboardId');
        String dashboardName = ApexPages.currentPage().getParameters().get('dashboardName');
        if(dashboardId!=null && dashboardName!=null){
            Report_Landing_Page_Tracker__c rlpt = new Report_Landing_Page_Tracker__c(DashboardId__c=dashboardId,Dashboard_Name__c=dashboardName,User__c=UserInfo.getUserId(),Execution_Time__c=System.now());
            insert rlpt;
        }
        return null;
    }
}