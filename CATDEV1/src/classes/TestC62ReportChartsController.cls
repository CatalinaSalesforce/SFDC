/*
@Name           : TestC62ReportChartsController
@Author         : customersuccess@cloud62.com
@Date           : December 10, 2013
@Description    : Test code for C62ReportChartsController
*/
@isTest
private class TestC62ReportChartsController{
    
    /*
    @Name :C62ReportChartsControllerTest
    @Description :Test code for C62ReportChartsController
    */
    private static testmethod void C62ReportChartsControllerTest(){
        //get the test data
        Renewal_Settings__c rs = getRenewalSetting();
        ReportChartIds__c rc = getReportChartIds();
        Account parentAccount = getParentAccount();
        Account childAccount = getChildAccount(parentAccount);
        List<Opportunity> oppLst = getOppList(childAccount);
        List<Program__c> progLst = getProgList(oppLst);
        
        //Start Test
        Test.startTest();
        C62ReportChartsController rcc = new C62ReportChartsController();
        rcc.send();
        //assertion
        //system.assertequals(10000,rcc.avgChartWrapperList[0].amt);
        //set the filters now
        rcc.congId = parentAccount.Id;
        rcc.selRecType = 'Contract';
        rcc.getRecordTypes();
        rcc.send();
        //assertion
        //system.assertequals(0,rcc.dcChartWrapperList[0].age);
        //system.assertequals(2,rcc.dcChartWrapperList[0].recTypeTotal);
        rcc.opp.Start_Date__c = system.today().addYears(1);
        rcc.send();
        rcc.opp.End_Date__c = system.today().addYears(3);
        rcc.send();
        rcc.getVP();
        rcc.getAccountsList();
        rcc.getOwnersList();
        Test.stopTest();
        //Stop Test
    }
    
    /*
    @Name :getParentAccount
    @Description :Prepare the Conglomerate Parent Account test data.
    */
    private static Account getParentAccount(){
        List<RecordType> rtLst = [SELECT ID FROM RecordType Where Name = 'Manufacturing' and SOBJECTTYPE = 'Account'];
        Account acc = new Account(Name = 'Conglomerate Account', Type = 'Conglomerate', OwnerId=UserInfo.getUserId());
        if(rtLst.size()>0){
            acc.RecordTypeId = rtLst[0].Id;
        }
        insert acc;
        return acc;
    }
    
    /*
    @Name :getChildAccount
    @Description :Prepare the Child Account test data.
    */
    private static Account getChildAccount(Account a){
        List<RecordType> rtLst = [SELECT ID FROM RecordType Where Name = 'Manufacturing' and SOBJECTTYPE = 'Account'];
        Account acc = new Account(Name = 'Test Account', OwnerId=UserInfo.getUserId(),ParentId=a.ID);
        if(rtLst.size()>0){
            acc.RecordTypeId = rtLst[0].Id;
        }
        insert acc;
        return acc;
    }
    
    /*
    @Name :getOppList
    @Description :Prepare the Opportunity test data.
    */
    private static List<Opportunity> getOppList(Account a){
        List<RecordType> rtLst = [SELECT ID FROM RecordType Where Name = 'Contract' and SOBJECTTYPE = 'Opportunity'];
        List<Opportunity> oppLst = new List<Opportunity>();
        Opportunity o1 = new Opportunity(AccountId = a.Id,Name = 'Test oppty',StageName = 'Presented',
                        CloseDate = Date.today().addDays(10),Amount=20000, OwnerId=UserInfo.getUserId(),
                        Catalina_Business_Unit__c='Base');
        Opportunity o2 = new Opportunity(AccountId = a.Id,Name = 'Test oppty',StageName = 'Presented',
                        CloseDate = Date.today().addDays(10),Amount=20000, OwnerId=UserInfo.getUserId(),
                        Catalina_Business_Unit__c='Mobile');
        if(rtLst.size()>0){
            o1.RecordTypeId = rtLst[0].Id;
            o2.RecordTypeId = rtLst[0].Id;
        }
        oppLst.add(o1);
        oppLst.add(o2);
        insert oppLst;
        return oppLst;
    }
    
    /*
    @Name :getRenewalSetting
    @Description :Prepare the Renewal_Settings__c test data.
    */
    private static Renewal_Settings__c getRenewalSetting(){
        Renewal_Settings__c setting = new Renewal_Settings__c(Renewal_Window_Size__c = 14,Percent_Goal__c = 0);
        insert setting;
        return setting;
    }
    
    /*
    @Name :getRenewalSetting
    @Description :Prepare the ReportChartIds__c test data.
    */
    private static ReportChartIds__c getReportChartIds(){
        ReportChartIds__c setting = new ReportChartIds__c(Name='Default',Report_1_ID__c='Test',Report_2_ID__c='Test');
        insert setting;
        return setting;
    }
    
    /*
    @Name :getProgramList
    @Description :Prepare the Program__c test data.
    */
    private static List<Program__c> getProgList(List<Opportunity> o){
        List<Program__c> progLst = new List<Program__c>();
        Program__c p1 = new Program__c(Name = o[0].Name + ' Base',Opportunity__c = o[0].Id,Delivery_Type__c = 'Base',
                        Product_Type__c = 'Base Product Type',Program_Amount__c=10000);
        Program__c p2 = new Program__c(Name = o[0].Name + ' Mobile',Opportunity__c = o[0].Id,Delivery_Type__c = 'Mobile',
                        Product_Type__c = 'Mobile Product Type',Program_Amount__c=10000);
        Program__c p3 = new Program__c(Name = o[1].Name + ' Base',Opportunity__c = o[1].Id,Delivery_Type__c = 'Base',
                        Product_Type__c = 'Base Product Type',Program_Amount__c=10000);
        Program__c p4 = new Program__c(Name = o[1].Name + ' Mobile',Opportunity__c = o[1].Id,Delivery_Type__c = 'Mobile',
                        Product_Type__c = 'Mobile Product Type',Program_Amount__c=10000);
        progLst.add(p1);
        progLst.add(p2);
        progLst.add(p3);
        progLst.add(p4);
        insert progLst;
        return progLst;
    }
}