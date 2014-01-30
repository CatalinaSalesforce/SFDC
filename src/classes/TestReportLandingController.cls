@isTest
public class TestReportLandingController {
        
    static testmethod void testmethod1(){
        
        PageReference pageRef = Page.ReportLandingPage;
        Test.setCurrentPage(pageRef);
        
        ReportLandingController rlc = new ReportLandingController();
        List<ReportLandingSetting__c> rls = [select QuotaManagementId__c,AccManagementId__c,AccManagementDetailedId__c,ForecastingId__c,PeopleManagementId__c,ExecutiveReportId__c,SalesDashboardId__c,Executive_AdminDashboardId__c,RenewalsFolderName__c,RetiredReportFolderName__c,DashboardReportFolderName__c,AdminReportFolderName__c from ReportLandingSetting__c where name = 'DisplayReportIds'];
        if(rls.size() == 0 ){
            ReportLandingSetting__c rlSetting = new ReportLandingSetting__c();  
            rlSetting.Name =   'DisplayReportIds';
            rlSetting.ExecutiveReportId__c = [select Id from Report where name='MFG $25K Contract Min'][0].Id;
            rlSetting.QuotaManagementId__c = [select Id from Report where name='MFR Booked Revenue' limit 1][0].Id;
        }
        List<ReportLandingSetting__c> rls1 = [select QuotaManagementId__c,AccManagementId__c,AccManagementDetailedId__c,ForecastingId__c,PeopleManagementId__c,ExecutiveReportId__c,SalesDashboardId__c,Executive_AdminDashboardId__c,RenewalsFolderName__c,RetiredReportFolderName__c,DashboardReportFolderName__c,AdminReportFolderName__c from ReportLandingSetting__c where name = 'DisplayUserRole'];
       if(rls1.size() ==0){
        ReportLandingSetting__c rlSetting2 = new ReportLandingSetting__c();  
        rlSetting2.Name =   'DisplayUserRole';
        rlSetting2.SalesUserRoles__c    = 'SR1,SR2,SR3';
        rlSetting2.ExecutiveUserRoles__c = 'SM1,SM2,EVP';
        rlSetting2.AdminUserRoles__c = 'IT_Administration,System Administrator';
        insert rlSetting2;
       }
            
        rlc.reporttype = 'fav';
        rlc.redirectToBack();
        rlc.goToReportDashboardDisplay();
        rlc.displayReportsDashBoard();
    
    }
    
    static testmethod void testmethod2(){
               
        PageReference pageRef = Page.ReportLandingPage;
        Test.setCurrentPage(pageRef);
        
        ReportLandingController rlc = new ReportLandingController();
         List<ReportLandingSetting__c> rls = [select QuotaManagementId__c,AccManagementId__c,AccManagementDetailedId__c,ForecastingId__c,PeopleManagementId__c,ExecutiveReportId__c,SalesDashboardId__c,Executive_AdminDashboardId__c,RenewalsFolderName__c,RetiredReportFolderName__c,DashboardReportFolderName__c,AdminReportFolderName__c from ReportLandingSetting__c where name = 'DisplayReportIds'];
        if(rls.size() ==0){
            ReportLandingSetting__c rlSetting = new ReportLandingSetting__c();  
            rlSetting.Name =   'DisplayReportIds';
            rlSetting.ExecutiveReportId__c = [select Id from Report where name='MFG $25K Contract Min'][0].Id;
            rlSetting.QuotaManagementId__c = [select Id from Report where name='MFR Booked Revenue' limit 1][0].Id;
        }
        List<ReportLandingSetting__c> rls1 = [select QuotaManagementId__c,AccManagementId__c,AccManagementDetailedId__c,ForecastingId__c,PeopleManagementId__c,ExecutiveReportId__c,SalesDashboardId__c,Executive_AdminDashboardId__c,RenewalsFolderName__c,RetiredReportFolderName__c,DashboardReportFolderName__c,AdminReportFolderName__c from ReportLandingSetting__c where name = 'DisplayUserRole'];
       if(rls1.size() ==0){
        ReportLandingSetting__c rlSetting2 = new ReportLandingSetting__c();  
        rlSetting2.Name =   'DisplayUserRole';
        rlSetting2.SalesUserRoles__c    = 'SR1,SR2,SR3';
        rlSetting2.ExecutiveUserRoles__c = 'SM1,SM2,EVP';
        rlSetting2.AdminUserRoles__c = 'IT_Administration,System Administrator';
        insert rlSetting2;
       }               
        rlc.reporttype = 'Quota';
        rlc.redirectToBack();
        rlc.displayReportsDashBoard();
    
    }
    
    static testmethod void testmethod3(){
               
        PageReference pageRef = Page.ReportLandingPage;
        Test.setCurrentPage(pageRef);
        
        ReportLandingController rlc = new ReportLandingController();
         List<ReportLandingSetting__c> rls = [select QuotaManagementId__c,AccManagementId__c,AccManagementDetailedId__c,ForecastingId__c,PeopleManagementId__c,ExecutiveReportId__c,SalesDashboardId__c,Executive_AdminDashboardId__c,RenewalsFolderName__c,RetiredReportFolderName__c,DashboardReportFolderName__c,AdminReportFolderName__c from ReportLandingSetting__c where name = 'DisplayReportIds'];
        if(rls.size() ==0){
            ReportLandingSetting__c rlSetting = new ReportLandingSetting__c();  
            rlSetting.Name =   'DisplayReportIds';
            rlSetting.ExecutiveReportId__c = [select Id from Report where name='MFG $25K Contract Min'][0].Id;
            rlSetting.QuotaManagementId__c = [select Id from Report where name='MFR Booked Revenue' limit 1][0].Id;
        }
        List<ReportLandingSetting__c> rls1 = [select QuotaManagementId__c,AccManagementId__c,AccManagementDetailedId__c,ForecastingId__c,PeopleManagementId__c,ExecutiveReportId__c,SalesDashboardId__c,Executive_AdminDashboardId__c,RenewalsFolderName__c,RetiredReportFolderName__c,DashboardReportFolderName__c,AdminReportFolderName__c from ReportLandingSetting__c where name = 'DisplayUserRole'];
       if(rls1.size() ==0){
        ReportLandingSetting__c rlSetting2 = new ReportLandingSetting__c();  
        rlSetting2.Name =   'DisplayUserRole';
        rlSetting2.SalesUserRoles__c    = 'SR1,SR2,SR3';
        rlSetting2.ExecutiveUserRoles__c = 'SM1,SM2,EVP';
        rlSetting2.AdminUserRoles__c = 'IT_Administration,System Administrator';
        insert rlSetting2;
       }               
        rlc.reporttype = 'AccManagement';
        rlc.redirectToBack();
        rlc.displayReportsDashBoard();
    
    }
    
    static testmethod void testmethod4(){
               
        PageReference pageRef = Page.ReportLandingPage;
        Test.setCurrentPage(pageRef);
        
        ReportLandingController rlc = new ReportLandingController();
          List<ReportLandingSetting__c> rls = [select QuotaManagementId__c,AccManagementId__c,AccManagementDetailedId__c,ForecastingId__c,PeopleManagementId__c,ExecutiveReportId__c,SalesDashboardId__c,Executive_AdminDashboardId__c,RenewalsFolderName__c,RetiredReportFolderName__c,DashboardReportFolderName__c,AdminReportFolderName__c from ReportLandingSetting__c where name = 'DisplayReportIds'];
        if(rls.size() ==0){
            ReportLandingSetting__c rlSetting = new ReportLandingSetting__c();  
            rlSetting.Name =   'DisplayReportIds';
            rlSetting.ExecutiveReportId__c = [select Id from Report where name='MFG $25K Contract Min'][0].Id;
            rlSetting.QuotaManagementId__c = [select Id from Report where name='MFR Booked Revenue' limit 1][0].Id;
        }
        List<ReportLandingSetting__c> rls1 = [select QuotaManagementId__c,AccManagementId__c,AccManagementDetailedId__c,ForecastingId__c,PeopleManagementId__c,ExecutiveReportId__c,SalesDashboardId__c,Executive_AdminDashboardId__c,RenewalsFolderName__c,RetiredReportFolderName__c,DashboardReportFolderName__c,AdminReportFolderName__c from ReportLandingSetting__c where name = 'DisplayUserRole'];
       if(rls1.size() ==0){
        ReportLandingSetting__c rlSetting2 = new ReportLandingSetting__c();  
        rlSetting2.Name =   'DisplayUserRole';
        rlSetting2.SalesUserRoles__c    = 'SR1,SR2,SR3';
        rlSetting2.ExecutiveUserRoles__c = 'SM1,SM2,EVP';
        rlSetting2.AdminUserRoles__c = 'IT_Administration,System Administrator';
        insert rlSetting2;
       }              
        rlc.reporttype = 'AccManagementDetailed';
        rlc.redirectToBack();
        rlc.displayReportsDashBoard();
    
    }
    
    static testmethod void testmethod5(){
               
        PageReference pageRef = Page.ReportLandingPage;
        Test.setCurrentPage(pageRef);
        
        ReportLandingController rlc = new ReportLandingController();
         List<ReportLandingSetting__c> rls = [select QuotaManagementId__c,AccManagementId__c,AccManagementDetailedId__c,ForecastingId__c,PeopleManagementId__c,ExecutiveReportId__c,SalesDashboardId__c,Executive_AdminDashboardId__c,RenewalsFolderName__c,RetiredReportFolderName__c,DashboardReportFolderName__c,AdminReportFolderName__c from ReportLandingSetting__c where name = 'DisplayReportIds'];
        if(rls.size() ==0){
            ReportLandingSetting__c rlSetting = new ReportLandingSetting__c();  
            rlSetting.Name =   'DisplayReportIds';
            rlSetting.ExecutiveReportId__c = [select Id from Report where name='MFG $25K Contract Min'][0].Id;
            rlSetting.QuotaManagementId__c = [select Id from Report where name='MFR Booked Revenue' limit 1][0].Id;
            rlSetting.AccManagementDetailedId__c = [select Id from Report where name='Threshold Report' limit 1][0].Id;
        }
        List<ReportLandingSetting__c> rls1 = [select QuotaManagementId__c,AccManagementId__c,AccManagementDetailedId__c,ForecastingId__c,PeopleManagementId__c,ExecutiveReportId__c,SalesDashboardId__c,Executive_AdminDashboardId__c,RenewalsFolderName__c,RetiredReportFolderName__c,DashboardReportFolderName__c,AdminReportFolderName__c from ReportLandingSetting__c where name = 'DisplayUserRole'];
       if(rls1.size() ==0){
        ReportLandingSetting__c rlSetting2 = new ReportLandingSetting__c();  
        rlSetting2.Name =   'DisplayUserRole';
        rlSetting2.SalesUserRoles__c    = 'SR1,SR2,SR3';
        rlSetting2.ExecutiveUserRoles__c = 'SM1,SM2,EVP';
        rlSetting2.AdminUserRoles__c = 'IT_Administration,System Administrator';
        insert rlSetting2;
       }               
        rlc.reporttype = 'Forecasting';
        rlc.redirectToBack();
        rlc.displayReportsDashBoard();
    
    }
    
    static testmethod void testmethod6(){
               
        PageReference pageRef = Page.ReportLandingPage;
        Test.setCurrentPage(pageRef);
        
        ReportLandingController rlc = new ReportLandingController();
          List<ReportLandingSetting__c> rls = [select QuotaManagementId__c,AccManagementId__c,AccManagementDetailedId__c,ForecastingId__c,PeopleManagementId__c,ExecutiveReportId__c,SalesDashboardId__c,Executive_AdminDashboardId__c,RenewalsFolderName__c,RetiredReportFolderName__c,DashboardReportFolderName__c,AdminReportFolderName__c from ReportLandingSetting__c where name = 'DisplayReportIds'];
        if(rls.size() ==0){
            ReportLandingSetting__c rlSetting = new ReportLandingSetting__c();  
            rlSetting.Name =   'DisplayReportIds';
            rlSetting.ExecutiveReportId__c = [select Id from Report where name='MFG $25K Contract Min'][0].Id;
            rlSetting.QuotaManagementId__c = [select Id from Report where name='MFR Booked Revenue' limit 1][0].Id;
            rlSetting.AccManagementDetailedId__c = [select Id from Report where name='Threshold Report' limit 1][0].Id;
        }
        List<ReportLandingSetting__c> rls1 = [select QuotaManagementId__c,AccManagementId__c,AccManagementDetailedId__c,ForecastingId__c,PeopleManagementId__c,ExecutiveReportId__c,SalesDashboardId__c,Executive_AdminDashboardId__c,RenewalsFolderName__c,RetiredReportFolderName__c,DashboardReportFolderName__c,AdminReportFolderName__c from ReportLandingSetting__c where name = 'DisplayUserRole'];
       if(rls1.size() ==0){
        ReportLandingSetting__c rlSetting2 = new ReportLandingSetting__c();  
        rlSetting2.Name =   'DisplayUserRole';
        rlSetting2.SalesUserRoles__c    = 'SR1,SR2,SR3';
        rlSetting2.ExecutiveUserRoles__c = 'SM1,SM2,EVP';
        rlSetting2.AdminUserRoles__c = 'IT_Administration,System Administrator';
        insert rlSetting2;
       }              
        rlc.reporttype = 'PeopleManagement';
        rlc.redirectToBack();
        rlc.displayReportsDashBoard();
    
    }
    
    static testmethod void testmethod7(){
               
        PageReference pageRef = Page.ReportLandingPage;
        Test.setCurrentPage(pageRef);
        
        ReportLandingController rlc = new ReportLandingController();
           List<ReportLandingSetting__c> rls = [select QuotaManagementId__c,AccManagementId__c,AccManagementDetailedId__c,ForecastingId__c,PeopleManagementId__c,ExecutiveReportId__c,SalesDashboardId__c,Executive_AdminDashboardId__c,RenewalsFolderName__c,RetiredReportFolderName__c,DashboardReportFolderName__c,AdminReportFolderName__c from ReportLandingSetting__c where name = 'DisplayReportIds'];
        if(rls.size() ==0){
            ReportLandingSetting__c rlSetting = new ReportLandingSetting__c();  
            rlSetting.Name =   'DisplayReportIds';
            rlSetting.ExecutiveReportId__c = [select Id from Report where name='MFG $25K Contract Min'][0].Id;
            rlSetting.QuotaManagementId__c = [select Id from Report where name='MFR Booked Revenue' limit 1][0].Id;
            rlSetting.AccManagementDetailedId__c = [select Id from Report where name='Threshold Report' limit 1][0].Id;
        }
        List<ReportLandingSetting__c> rls1 = [select QuotaManagementId__c,AccManagementId__c,AccManagementDetailedId__c,ForecastingId__c,PeopleManagementId__c,ExecutiveReportId__c,SalesDashboardId__c,Executive_AdminDashboardId__c,RenewalsFolderName__c,RetiredReportFolderName__c,DashboardReportFolderName__c,AdminReportFolderName__c from ReportLandingSetting__c where name = 'DisplayUserRole'];
       if(rls1.size() ==0){
        ReportLandingSetting__c rlSetting2 = new ReportLandingSetting__c();  
        rlSetting2.Name =   'DisplayUserRole';
        rlSetting2.SalesUserRoles__c    = 'SR1,SR2,SR3';
        rlSetting2.ExecutiveUserRoles__c = 'SM1,SM2,EVP';
        rlSetting2.AdminUserRoles__c = 'IT_Administration,System Administrator';
        insert rlSetting2;
       }             
        rlc.reporttype = 'Executive';
        rlc.redirectToBack();
        rlc.displayReportsDashBoard();
    
    }
    
    static testmethod void testmethod8(){
               
        PageReference pageRef = Page.ReportLandingPage;
        Test.setCurrentPage(pageRef);
        
        ReportLandingController rlc = new ReportLandingController();
           List<ReportLandingSetting__c> rls = [select QuotaManagementId__c,AccManagementId__c,AccManagementDetailedId__c,ForecastingId__c,PeopleManagementId__c,ExecutiveReportId__c,SalesDashboardId__c,Executive_AdminDashboardId__c,RenewalsFolderName__c,RetiredReportFolderName__c,DashboardReportFolderName__c,AdminReportFolderName__c from ReportLandingSetting__c where name = 'DisplayReportIds'];
        if(rls.size() ==0){
            ReportLandingSetting__c rlSetting = new ReportLandingSetting__c();  
            rlSetting.Name =   'DisplayReportIds';
            rlSetting.ExecutiveReportId__c = [select Id from Report where name='MFG $25K Contract Min'][0].Id;
            rlSetting.QuotaManagementId__c = [select Id from Report where name='MFR Booked Revenue' limit 1][0].Id;
            rlSetting.AccManagementDetailedId__c = [select Id from Report where name='Threshold Report' limit 1][0].Id;
        }
        List<ReportLandingSetting__c> rls1 = [select QuotaManagementId__c,AccManagementId__c,AccManagementDetailedId__c,ForecastingId__c,PeopleManagementId__c,ExecutiveReportId__c,SalesDashboardId__c,Executive_AdminDashboardId__c,RenewalsFolderName__c,RetiredReportFolderName__c,DashboardReportFolderName__c,AdminReportFolderName__c from ReportLandingSetting__c where name = 'DisplayUserRole'];
       if(rls1.size() ==0){
        ReportLandingSetting__c rlSetting2 = new ReportLandingSetting__c();  
        rlSetting2.Name =   'DisplayUserRole';
        rlSetting2.SalesUserRoles__c    = 'SR1,SR2,SR3';
        rlSetting2.ExecutiveUserRoles__c = 'SM1,SM2,EVP';
        rlSetting2.AdminUserRoles__c = 'IT_Administration,System Administrator';
        insert rlSetting2;
       }             
        rlc.reporttype = 'Renewals';
        rlc.redirectToBack();
        rlc.displayReportsDashBoard();
    
    }
    
    static testmethod void testmethod9(){
               
        PageReference pageRef = Page.ReportLandingPage;
        Test.setCurrentPage(pageRef);
        
        ReportLandingController rlc = new ReportLandingController();
          List<ReportLandingSetting__c> rls = [select QuotaManagementId__c,AccManagementId__c,AccManagementDetailedId__c,ForecastingId__c,PeopleManagementId__c,ExecutiveReportId__c,SalesDashboardId__c,Executive_AdminDashboardId__c,RenewalsFolderName__c,RetiredReportFolderName__c,DashboardReportFolderName__c,AdminReportFolderName__c from ReportLandingSetting__c where name = 'DisplayReportIds'];
        if(rls.size() ==0){
            ReportLandingSetting__c rlSetting = new ReportLandingSetting__c();  
            rlSetting.Name =   'DisplayReportIds';
            rlSetting.ExecutiveReportId__c = [select Id from Report where name='MFG $25K Contract Min'][0].Id;
            rlSetting.QuotaManagementId__c = [select Id from Report where name='MFR Booked Revenue' limit 1][0].Id;
            rlSetting.AccManagementDetailedId__c = [select Id from Report where name='Threshold Report' limit 1][0].Id;
        }
        List<ReportLandingSetting__c> rls1 = [select QuotaManagementId__c,AccManagementId__c,AccManagementDetailedId__c,ForecastingId__c,PeopleManagementId__c,ExecutiveReportId__c,SalesDashboardId__c,Executive_AdminDashboardId__c,RenewalsFolderName__c,RetiredReportFolderName__c,DashboardReportFolderName__c,AdminReportFolderName__c from ReportLandingSetting__c where name = 'DisplayUserRole'];
       if(rls1.size() ==0){
        ReportLandingSetting__c rlSetting2 = new ReportLandingSetting__c();  
        rlSetting2.Name =   'DisplayUserRole';
        rlSetting2.SalesUserRoles__c    = 'SR1,SR2,SR3';
        rlSetting2.ExecutiveUserRoles__c = 'SM1,SM2,EVP';
        rlSetting2.AdminUserRoles__c = 'IT_Administration,System Administrator';
        insert rlSetting2;
       }              
        rlc.reporttype = 'RetiredReport';
        rlc.redirectToBack();
        rlc.displayReportsDashBoard();
    
    }
    
    static testmethod void testmethod10(){
               
        PageReference pageRef = Page.ReportLandingPage;
        Test.setCurrentPage(pageRef);
        
        ReportLandingController rlc = new ReportLandingController();
          List<ReportLandingSetting__c> rls = [select QuotaManagementId__c,AccManagementId__c,AccManagementDetailedId__c,ForecastingId__c,PeopleManagementId__c,ExecutiveReportId__c,SalesDashboardId__c,Executive_AdminDashboardId__c,RenewalsFolderName__c,RetiredReportFolderName__c,DashboardReportFolderName__c,AdminReportFolderName__c from ReportLandingSetting__c where name = 'DisplayReportIds'];
        if(rls.size() ==0){
            ReportLandingSetting__c rlSetting = new ReportLandingSetting__c();  
            rlSetting.Name =   'DisplayReportIds';
            rlSetting.ExecutiveReportId__c = [select Id from Report where name='MFG $25K Contract Min'][0].Id;
            rlSetting.QuotaManagementId__c = [select Id from Report where name='MFR Booked Revenue' limit 1][0].Id;
            rlSetting.AccManagementDetailedId__c = [select Id from Report where name='Threshold Report' limit 1][0].Id;
        }
        List<ReportLandingSetting__c> rls1 = [select QuotaManagementId__c,AccManagementId__c,AccManagementDetailedId__c,ForecastingId__c,PeopleManagementId__c,ExecutiveReportId__c,SalesDashboardId__c,Executive_AdminDashboardId__c,RenewalsFolderName__c,RetiredReportFolderName__c,DashboardReportFolderName__c,AdminReportFolderName__c from ReportLandingSetting__c where name = 'DisplayUserRole'];
       if(rls1.size() ==0){
        ReportLandingSetting__c rlSetting2 = new ReportLandingSetting__c();  
        rlSetting2.Name =   'DisplayUserRole';
        rlSetting2.SalesUserRoles__c    = 'SR1,SR2,SR3';
        rlSetting2.ExecutiveUserRoles__c = 'SM1,SM2,EVP';
        rlSetting2.AdminUserRoles__c = 'IT_Administration,System Administrator';
        insert rlSetting2;
       }              
        rlc.reporttype = 'DashboardReport';
        rlc.redirectToBack();
        rlc.displayReportsDashBoard();
    
    }
    
    static testmethod void testmethod11(){
               
        PageReference pageRef = Page.ReportLandingPage;
        Test.setCurrentPage(pageRef);
        
        ReportLandingController rlc = new ReportLandingController();
          List<ReportLandingSetting__c> rls = [select QuotaManagementId__c,AccManagementId__c,AccManagementDetailedId__c,ForecastingId__c,PeopleManagementId__c,ExecutiveReportId__c,SalesDashboardId__c,Executive_AdminDashboardId__c,RenewalsFolderName__c,RetiredReportFolderName__c,DashboardReportFolderName__c,AdminReportFolderName__c from ReportLandingSetting__c where name = 'DisplayReportIds'];
        if(rls.size() ==0){
            ReportLandingSetting__c rlSetting = new ReportLandingSetting__c();  
            rlSetting.Name =   'DisplayReportIds';
            rlSetting.ExecutiveReportId__c = [select Id from Report where name='MFG $25K Contract Min'][0].Id;
            rlSetting.QuotaManagementId__c = [select Id from Report where name='MFR Booked Revenue' limit 1][0].Id;
            rlSetting.AccManagementDetailedId__c = [select Id from Report where name='Threshold Report' limit 1][0].Id;
        }
        List<ReportLandingSetting__c> rls1 = [select QuotaManagementId__c,AccManagementId__c,AccManagementDetailedId__c,ForecastingId__c,PeopleManagementId__c,ExecutiveReportId__c,SalesDashboardId__c,Executive_AdminDashboardId__c,RenewalsFolderName__c,RetiredReportFolderName__c,DashboardReportFolderName__c,AdminReportFolderName__c from ReportLandingSetting__c where name = 'DisplayUserRole'];
       if(rls1.size() ==0){
        ReportLandingSetting__c rlSetting2 = new ReportLandingSetting__c();  
        rlSetting2.Name =   'DisplayUserRole';
        rlSetting2.SalesUserRoles__c    = 'SR1,SR2,SR3';
        rlSetting2.ExecutiveUserRoles__c = 'SM1,SM2,EVP';
        rlSetting2.AdminUserRoles__c = 'IT_Administration,System Administrator';
        insert rlSetting2;
       }              
        rlc.reporttype = 'AdminReport';
        rlc.redirectToBack();
        rlc.displayReportsDashBoard();
    
    }
    
    static testmethod void testmethod12(){
               
        PageReference pageRef = Page.ReportLandingPage;
        Test.setCurrentPage(pageRef);
        
        ReportLandingController rlc = new ReportLandingController();
         List<ReportLandingSetting__c> rls = [select QuotaManagementId__c,AccManagementId__c,AccManagementDetailedId__c,ForecastingId__c,PeopleManagementId__c,ExecutiveReportId__c,SalesDashboardId__c,Executive_AdminDashboardId__c,RenewalsFolderName__c,RetiredReportFolderName__c,DashboardReportFolderName__c,AdminReportFolderName__c from ReportLandingSetting__c where name = 'DisplayReportIds'];
        if(rls.size() ==0){
            ReportLandingSetting__c rlSetting = new ReportLandingSetting__c();  
            rlSetting.Name =   'DisplayReportIds';
            rlSetting.ExecutiveReportId__c = [select Id from Report where name='MFG $25K Contract Min'][0].Id;
            rlSetting.QuotaManagementId__c = [select Id from Report where name='MFR Booked Revenue' limit 1][0].Id;
            rlSetting.AccManagementDetailedId__c = [select Id from Report where name='Threshold Report' limit 1][0].Id;
        }
        List<ReportLandingSetting__c> rls1 = [select QuotaManagementId__c,AccManagementId__c,AccManagementDetailedId__c,ForecastingId__c,PeopleManagementId__c,ExecutiveReportId__c,SalesDashboardId__c,Executive_AdminDashboardId__c,RenewalsFolderName__c,RetiredReportFolderName__c,DashboardReportFolderName__c,AdminReportFolderName__c from ReportLandingSetting__c where name = 'DisplayUserRole'];
       if(rls1.size() ==0){
        ReportLandingSetting__c rlSetting2 = new ReportLandingSetting__c();  
        rlSetting2.Name =   'DisplayUserRole';
        rlSetting2.SalesUserRoles__c    = 'SR1,SR2,SR3';
        rlSetting2.ExecutiveUserRoles__c = 'SM1,SM2,EVP';
        rlSetting2.AdminUserRoles__c = 'IT_Administration,System Administrator';
        insert rlSetting2;
       }               
        rlc.reporttype = 'salesDashboard';
        rlc.salesLandingIcons = true;
        rlc.redirectToBack();
        rlc.displayReportsDashBoard();
    
    }
    
    static testmethod void testmethod13(){
               
        PageReference pageRef = Page.ReportLandingPage;
        Test.setCurrentPage(pageRef);
        
        ReportLandingController rlc = new ReportLandingController();
         List<ReportLandingSetting__c> rls = [select QuotaManagementId__c,AccManagementId__c,AccManagementDetailedId__c,ForecastingId__c,PeopleManagementId__c,ExecutiveReportId__c,SalesDashboardId__c,Executive_AdminDashboardId__c,RenewalsFolderName__c,RetiredReportFolderName__c,DashboardReportFolderName__c,AdminReportFolderName__c from ReportLandingSetting__c where name = 'DisplayReportIds'];
        if(rls.size() ==0){
            ReportLandingSetting__c rlSetting = new ReportLandingSetting__c();  
            rlSetting.Name =   'DisplayReportIds';
            rlSetting.ExecutiveReportId__c = [select Id from Report where name='MFG $25K Contract Min'][0].Id;
            rlSetting.QuotaManagementId__c = [select Id from Report where name='MFR Booked Revenue' limit 1][0].Id;
            rlSetting.AccManagementDetailedId__c = [select Id from Report where name='Threshold Report' limit 1][0].Id;
        }
        List<ReportLandingSetting__c> rls1 = [select QuotaManagementId__c,AccManagementId__c,AccManagementDetailedId__c,ForecastingId__c,PeopleManagementId__c,ExecutiveReportId__c,SalesDashboardId__c,Executive_AdminDashboardId__c,RenewalsFolderName__c,RetiredReportFolderName__c,DashboardReportFolderName__c,AdminReportFolderName__c from ReportLandingSetting__c where name = 'DisplayUserRole'];
       if(rls1.size() ==0){
        ReportLandingSetting__c rlSetting2 = new ReportLandingSetting__c();  
        rlSetting2.Name =   'DisplayUserRole';
        rlSetting2.SalesUserRoles__c    = 'SR1,SR2,SR3';
        rlSetting2.ExecutiveUserRoles__c = 'SM1,SM2,EVP';
        rlSetting2.AdminUserRoles__c = 'IT_Administration,System Administrator';
        insert rlSetting2;
       }               
        rlc.reporttype = 'salesDashboard';
        rlc.redirectToBack();
        rlc.displayReportsDashBoard();
        rlc.reportTracking();
        rlc.dashboardTracking();
    
    }
    
    /*
    @Name :testBatchDeleteReportLandingPageTrackers
    @Description : test code for BatchDeleteReportLandingPageTrackers
    */
    public testmethod static void testBatchDeleteReportLandingPageTrackers(){
        Report_Landing_Page_Tracker__c rlt = new Report_Landing_Page_Tracker__c(User__c=UserInfo.getUserId());
        insert rlt;
        Test.startTest();
        BatchDeleteReportLandingPageTrackers obj = new BatchDeleteReportLandingPageTrackers('200');
        Database.executeBatch(obj, 200);
        //BatchDeleteReportLandingPageTrackers obj1 = new BatchDeleteReportLandingPageTrackers('0');
        //Database.executeBatch(obj1, 200);
        String sch = '0 0 23 * * ?'; 
        System.schedule('BatchDeleteReportLandingPageTrackers', sch, obj);  
        Test.stopTest();   
    } 

    
}