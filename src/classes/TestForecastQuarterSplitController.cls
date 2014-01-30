/*
@Name           :       TestForecastQuarterSplitController
@Author         :
@Date           :       12 Jan 2012
@Description    :       Test class for MyForecastQuarterSplitsController.
*/
public class TestForecastQuarterSplitController {
    @isTest
    public static void runTest(){
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        String accountRTID = [SELECT ID FROM RecordType Where Name = 'Manufacturing' and SOBJECTTYPE = 'Account'][0].Id;
        
        Account acc = new Account();
        acc.Name = 'acc';
        acc.RecordTypeId = accountRTID;
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'opp';
        opp.CloseDate = System.today();
        opp.Amount = 100;
        opp.AccountId = acc.Id;
        opp.StageName = 'Prospecting';
        insert opp;
        
        Program__c prog = new Program__c();
        prog.Name = 'Prog';
        prog.Opportunity__c = opp.Id;
        insert prog;
        
        Ad_Period__c adPeriod = new Ad_Period__c();
        adPeriod.Type__c = 'Manufacturing';
        adPeriod.Start_Date__c = date.newInstance(2011, 03, 01);
        adPeriod.End_Date__c = date.newInstance(2011, 04, 01);
        insert adPeriod;
        
        Program_Forecast__c proFor = new Program_Forecast__c();
        proFor.Ad_Period__c = adPeriod.Id;
        proFor.Program__c = prog.Id;
        proFor.Forecast_Amount__c = 100;
        profor.Previous_Quarter_Amount__c = 10;
        proFor.Next_Quarter_Amount__c = 10;
        insert proFor;
        
        MyForecastQuarterSplitsController myForQtr = new MyForecastQuarterSplitsController();
        myForQtr.opp.AccountId = acc.Id;
        myForQtr.opp.OwnerId = userInfo.getUserId();
        myForQtr.quarter = 'All';
        myForQtr.jsonToSave = '{"programForecast":[{"progforecastid":"'+proFor.Id+'","preqtramt":"100.00","nextqtramt":"100.00"},{"progforecastid":"a0HZ0000001R7zaMAC","preqtramt":"100.00","nextqtramt":"100.00"}]}';
        myForQtr.saveData();
        Program_Forecast__c pfAfterSave = [SELECT id, Previous_Quarter_Amount__c, Next_Quarter_Amount__c FROM Program_Forecast__c WHERE id =: proFor.Id];
        System.assert(proFor.Previous_Quarter_Amount__c != pfAfterSave.Previous_Quarter_Amount__c,'Save Failed');
        System.assert(proFor.Next_Quarter_Amount__c != pfAfterSave.Next_Quarter_Amount__c,'Save Failed');
    }
}