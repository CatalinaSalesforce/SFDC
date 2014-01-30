public class ProgForecastExtension {
    Program_Forecast__c programForecast;
    public ProgForecastExtension(ApexPages.StandardController sc){
        programForecast = (Program_Forecast__c)sc.getRecord();
        System.debug('@@@@ Program Forecast Id = '+programForecast.Id);
        if(programForecast.Id != null){
            programForecast = [select id, Program__c from Program_Forecast__c where id =: programForecast.Id limit 1];
        }
        system.debug('@@@@ Program = '+programForecast.Program__c);
    }
    public PageReference jumpToMyforecast(){
        PageReference pg;
        if(programForecast.Id != null && programForecast.Program__c != null){
            Program__c program = [select id, Opportunity__r.Id from Program__c where id =: programForecast.Program__c limit 1];
            pg = new PageReference('/apex/MyForecastPage?Id='+program.Opportunity__r.Id);
        }else{
            pg = new PageReference('/apex/MyForecastPage');
        }
        return pg;
    }
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