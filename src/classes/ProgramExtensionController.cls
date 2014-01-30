public class ProgramExtensionController{
    Program__c program;
    public ProgramExtensionController(ApexPages.StandardController sc){
        program = (Program__c)sc.getRecord();
        System.debug('@@@@ Program Id = '+program.Id);
        if(program.Id != null){
            program = [select id, Opportunity__r.Id from Program__c where id =: program.Id limit 1];
        }
    }
    public PageReference jumpToMyforecast(){
        PageReference pg;
        if(program.Id != null && program.Opportunity__r.Id != null){
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
        adPeriod.start_Date__c = System.today().addDays(-10);
        adPeriod.End_Date__c = System.today().addDays(18);
        upsert adPeriod;
        Ad_Period__c adPeriod1 = new Ad_Period__c(Name = 'SEPT_FY2012',Type__c='Retail');
        adPeriod1.start_Date__c = System.today().addDays(-10);
        adPeriod1.End_Date__c = System.today().addDays(18);
        upsert adPeriod;
        Program__c pro = new Program__c(Name='testPro',Account_Type__c='Retail',Start_Cycle__c=adPeriod.Id,End_Cycle__c=adPeriod1.Id,Program_Amount__c=100,Opportunity__c=oppTest.Id);
        insert pro;
        ApexPages.StandardController sc = new ApexPages.StandardController(pro);
        ProgramExtensionController proExtCtrl = new ProgramExtensionController(sc);
        proExtCtrl.jumpToMyforecast();
    }
}