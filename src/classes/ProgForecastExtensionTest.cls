@isTest()
public class ProgForecastExtensionTest{

    
    public static testMethod void unitTest(){
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        Account acc = new Account(Name='test acc');
        insert acc;
        Opportunity oppTest = new Opportunity(Name='testOpp', AccountId=acc.Id,CloseDate=System.today(),StageName='Closed Won');
        insert oppTest;
        Ad_Period__c adPeriod = new Ad_Period__c(Name = 'JULY_FY2012',Type__c='Retail');
        upsert adPeriod;
        Ad_Period__c adPeriod1 = new Ad_Period__c(Name = 'SEPT_FY2012',Type__c='Retail');
        upsert adPeriod;
        Program__c pro = new Program__c(Name='testPro',Account_Type__c='Retail',Start_Cycle__c=adPeriod.Id,End_Cycle__c=adPeriod1.Id,Program_Amount__c=100,Opportunity__c=oppTest.Id);
        insert pro;
        Program_Forecast__c proFor = new Program_Forecast__c(Forecast_Amount__c=100,Program__c=pro.Id,Ad_Period__c=adPeriod.Id);
        insert proFor;
        ApexPages.StandardController sc = new ApexPages.StandardController(proFor);
        ProgForecastExtension proForExt = new ProgForecastExtension(sc);
        proForExt.jumpToMyforecast();
    }
}