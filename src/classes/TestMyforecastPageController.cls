/*
    Test class for MyForecastPageController
*/
public class TestMyforecastPageController {
	private static final String settingsName = 'Default';
	private static final String sysAdmin = 'System Administrator';
    private static final String baseType = 'Base';
    private static final String digitalType = 'Digital O&O';
    private static final String displayType = 'Audience Network';
    private static final String mobileType = 'Mobile';
    private static final String manufacturingType = 'Manufacturing';
    private static final String retailType = 'Retail';
    private static final String coopType = 'coop';
    private static final String SR1Type = 'SR1';
    private static final String SR2Type = 'SR2';
    private static final String SM1Type = 'SM1';
    private static final String SM2Type = 'SM2';
    private static final String pfeEmail = 'fakeemail@myfakeemailplay.com.fake';
    private static final Integer settingsWindow = 0;
    private static final Integer settingsPercent = 12;
	
    @isTest
    public static void myUnitTest() {
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        Ad_Period__c ap=new Ad_Period__c();
        ap.Name='12-Jan';
        ap.Start_Date__c = date.newInstance(system.today().year(), system.today().month(), 1);
        ap.End_Date__c = date.newInstance(system.today().year(), system.today().month(), 30);
        ap.Type__c='Retail';       
        insert ap;
        
        Account ac=new Account();
        ac.Name='test1';
        insert ac;    
           
        RecordType rt = [SELECT id, name from RecordType Where SObjectType = 'Opportunity' AND Name = 'Proposal' Limit 1];
        
        Opportunity op=new Opportunity();
        op.Name='test2';
        op.AccountId=ac.Id;
        op.CloseDate=system.today();
        op.StageName='Qualification';
        op.RecordTypeId = rt.Id;
        op.Q1__c = 'Y';
        op.Q2__c = 'Y';
        op.Q3__c = 'Y';
        op.Q4__c = 'Y';
        insert op;
        
        Program__c pro = new Program__c();
        pro.Opportunity__c = op.Id;
        pro.Name = 'test';
        pro.Delivery_Type__c = 'Base';
        pro.Program_Amount__c = 100;
        insert pro;
        
        Program__c pro1 = new Program__c();
        pro1.Opportunity__c = op.Id;
        pro1.Name = 'test2';
        pro1.Program_Amount__c = 100;
        pro1.Delivery_Type__c = '';
        insert pro1;
        
        Program_Forecast__c proFor = new Program_Forecast__c();
        proFor.Ad_Period__c = ap.Id;
        proFor.Program__c = pro.Id;
        proFor.Forecast_Amount__c = 100;
        proFor.Actual_Amount__c = 500;
        insert profor;
        
        string cDate = String.valueOf(system.today());
        Date startDate = date.newInstance(system.today().year(), system.today().month(), 1);
        MyForecastPageController MFPC = new MyForecastPageController(op.id,cDate,'Retail','Proposal',ac.Name,'','All',50,'[Q1,Q2,Q3,Q4]',startDate, null,null);
        
        rt = [SELECT id, name from RecordType Where SObjectType = 'Opportunity' AND Name = 'Contract' Limit 1];
        op.StageName = 'Closed Won';
        op.RecordTypeId = rt.Id;
        update op;
        
        String cdt;
        MFPC = new MyForecastPageController(op.id,cdt,'Retail','Contract',ac.Name,'','All', 50, '[Q1,Q2,Q3,Q4]', startDate, null, null);
    }
    
    @isTest
    public static void testFranceActualController() {
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        Ad_Period__c ap=new Ad_Period__c();
        ap.Name='12-Jan';
        ap.Start_Date__c = date.newInstance(system.today().year(), system.today().month(), 1);
        ap.End_Date__c = date.newInstance(system.today().year(), system.today().month(), 30);
        ap.Type__c='Retail';       
        insert ap;
        
        Account ac=new Account();
        ac.Name='test1';
        insert ac;    
           
        RecordType rt = [SELECT id, name from RecordType Where SObjectType = 'Opportunity' AND Name = 'Proposal' Limit 1];
        
        Opportunity op=new Opportunity();
        op.Name='test2';
        op.AccountId=ac.Id;
        op.CloseDate=system.today();
        op.StageName='Qualification';
        op.RecordTypeId = rt.Id;
        op.Q1__c = 'Y';
        op.Q2__c = 'Y';
        op.Q3__c = 'Y';
        op.Q4__c = 'Y';
        insert op;
        
        Program__c pro = new Program__c();
        pro.Opportunity__c = op.Id;
        pro.Name = 'test';
        pro.Delivery_Type__c = 'Base';
        pro.Program_Amount__c = 100;
        insert pro;
        
        Program__c pro1 = new Program__c();
        pro1.Opportunity__c = op.Id;
        pro1.Name = 'test2';
        pro1.Program_Amount__c = 100;
        pro1.Delivery_Type__c = '';
        insert pro1;
        
        Program_Forecast__c proFor = new Program_Forecast__c();
        proFor.Ad_Period__c = ap.Id;
        proFor.Program__c = pro.Id;
        proFor.Forecast_Amount__c = 100;
        proFor.Actual_Amount__c = 500;
        insert profor;
        
        string cDate = String.valueOf(system.today());
        Date startDate = date.newInstance(system.today().year(), system.today().month(), 1);
        MyForecastActualFranceController MFPC = new MyForecastActualFranceController(op.id,cDate,'Retail','Proposal',ac.Name,'','All',50,'[Q1,Q2,Q3,Q4]',startDate, null,null);
        
        rt = [SELECT id, name from RecordType Where SObjectType = 'Opportunity' AND Name = 'Contract' Limit 1];
        op.StageName = 'Closed Won';
        op.RecordTypeId = rt.Id;
        update op;
        
        String cdt;
        MFPC = new MyForecastActualFranceController(op.id,cdt,'Retail','Contract',ac.Name,'','All', 50, '[Q1,Q2,Q3,Q4]', startDate, null, null);
    }
    
    @isTest
    public static void myUnitTest3() {
    	Catalina_Forecast_Settings__c settingsNew = getCatalinaForecastSettingsRecord();
    	RecordType accRT = [SELECT id, name from RecordType Where SObjectType = 'Account' AND Name = 'Manufacturing' Limit 1];
    	
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        Ad_Period__c ap=new Ad_Period__c();
        ap.Name='12-Jan';
        ap.Start_Date__c = date.newInstance(system.today().year(), system.today().month(), 1);
        ap.End_Date__c = date.newInstance(system.today().year(), system.today().month(), 30);
        ap.Type__c='Manufacturing';       
        insert ap;
        
        Account ac=new Account();
        ac.Name='test1';
        ac.RecordTypeId = accRT.Id;
        insert ac;    
           
        RecordType rt = [SELECT id, name from RecordType Where SObjectType = 'Opportunity' AND Name = 'Proposal' Limit 1];
        
        Opportunity op=new Opportunity();
        op.Name='test2';
        op.AccountId=ac.Id;
        op.CloseDate=system.today();
        op.StageName='Qualification';
        op.RecordTypeId = rt.Id;
        op.Q1__c = 'Y';
        op.Q2__c = 'Y';
        op.Q3__c = 'Y';
        op.Q4__c = 'Y';
        insert op;
        
        Program__c pro = new Program__c();
        pro.Opportunity__c = op.Id;
        pro.Name = 'test';
        pro.Delivery_Type__c = digitalType;
        pro.Program_Amount__c = 100;
        pro.Start_Date__c = date.newInstance(system.today().year(), system.today().month(), 1);
        pro.End_Date__c = date.newInstance(system.today().year(), system.today().month(), 30);
        insert pro;
        
        Program__c pro1 = new Program__c();
        pro1.Opportunity__c = op.Id;
        pro1.Name = 'test2';
        pro1.Program_Amount__c = 100;
        pro1.Delivery_Type__c = baseType;
        pro1.Start_Date__c = date.newInstance(system.today().year(), system.today().month(), 1);
        pro1.End_Date__c = date.newInstance(system.today().year(), system.today().month(), 30);
        insert pro1;
        
        Program_Forecast__c proFor = new Program_Forecast__c();
        proFor.Ad_Period__c = ap.Id;
        proFor.Program__c = pro.Id;
        proFor.Forecast_Amount__c = 100;
        proFor.Actual_Amount__c = 500;
        insert profor;
        
        string cDate = String.valueOf(system.today());
        Date startDate = date.newInstance(system.today().year(), system.today().month(), 1);
        MyForecastPageController MFPC = new MyForecastPageController(op.id,cDate,'Manufacturing','Proposal',ac.Name,'','All',50,'[Q1,Q2,Q3,Q4]',startDate, null,null);

    }
    
    @isTest
    public static void myUnitTest4() {
    	Catalina_Forecast_Settings__c settingsNew = getCatalinaForecastSettingsRecord();
    	RecordType accRT = [SELECT id, name from RecordType Where SObjectType = 'Account' AND Name = 'Manufacturing' Limit 1];
    	
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        List<Ad_Period__c> insertList = new List<Ad_Period__c>();
        
        for(Integer i = 0; i < 13; i++){
	        Ad_Period__c ap=new Ad_Period__c();
	        ap.Name='C1_' + i;
	        ap.Start_Date__c = date.newInstance(system.today().year(), system.today().month(), 1);
	        ap.End_Date__c = date.newInstance(system.today().year(), system.today().month(), 30);
	        ap.Type__c='Manufacturing';       
	        insertList.add(ap);
        }
        
        insert insertList;
        
        Account ac=new Account();
        ac.Name='test1';
        ac.RecordTypeId = accRT.Id;
        insert ac;    
           
        RecordType rt = [SELECT id, name from RecordType Where SObjectType = 'Opportunity' AND Name = 'Contract' Limit 1];
        
        Opportunity op=new Opportunity();
        op.Name='test2';
        op.AccountId=ac.Id;
        op.CloseDate=system.today();
        op.StageName='Closed Won';
        op.RecordTypeId = rt.Id;
        op.Q1__c = 'Y';
        op.Q2__c = 'Y';
        op.Q3__c = 'Y';
        op.Q4__c = 'Y';
        insert op;
        
        Program__c pro = new Program__c();
        pro.Opportunity__c = op.Id;
        pro.Name = 'test';
        pro.Delivery_Type__c = displayType;
        pro.Program_Amount__c = 100;
        pro.Start_Date__c = date.newInstance(system.today().year(), system.today().month(), 1);
        pro.End_Date__c = date.newInstance(system.today().year(), system.today().month(), 30);
        insert pro;
        
        Program__c pro1 = new Program__c();
        pro1.Opportunity__c = op.Id;
        pro1.Name = 'test2';
        pro1.Program_Amount__c = 100;
        pro1.Delivery_Type__c = baseType;
        pro1.Start_Date__c = date.newInstance(system.today().year(), system.today().month(), 1);
        pro1.End_Date__c = date.newInstance(system.today().year(), system.today().month(), 30);
        insert pro1;
        
        Program_Forecast__c proFor = new Program_Forecast__c();
        proFor.Ad_Period__c = insertList[0].Id;
        proFor.Program__c = pro.Id;
        proFor.Forecast_Amount__c = 100;
        proFor.Actual_Amount__c = 500;
        insert profor;
        
        string cDate = String.valueOf(system.today());
        Date startDate = date.newInstance(system.today().year(), system.today().month(), 1);
        
        String cdt;
        MyForecastPageController MFPC = new MyForecastPageController(op.id,cdt,'Manufacturing','Contract',ac.Name,'','All', 50, '[Q1,Q2,Q3,Q4]', startDate, null, null);
        //MFPC1 = new MyForecastPageController(op.id,cdt,'Manufacturing France','Contract',ac.Name,'','All', null, '[Q1,Q2,Q3,Q4]', startDate, null, null, 
                                    //null, null, null, null,null);
    }
    
    @isTest
    public static void myUnitTest5() {
    	Catalina_Forecast_Settings__c settingsNew = getCatalinaForecastSettingsRecord();
    	RecordType accRT = [SELECT id, name from RecordType Where SObjectType = 'Account' AND Name = 'Manufacturing France' Limit 1];
    	
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        List<Ad_Period__c> insertList = new List<Ad_Period__c>();
        
        for(Integer i = 1; i <= 5; i++){
	        Ad_Period__c ap=new Ad_Period__c();
	        ap.Name='FR_C' + i + '_' + String.valueOf(Date.today().year());
	        ap.Start_Date__c = date.newInstance(system.today().year(), system.today().month(), 1);
	        ap.End_Date__c = date.newInstance(system.today().year(), system.today().month(), 30);
	        ap.Type__c='Manufacturing France';       
	        insertList.add(ap);
        }
        
        for(Integer i = 1; i <= 5; i++){
	        Ad_Period__c ap=new Ad_Period__c();
	        ap.Name='FR_C' + i + '_' + String.valueOf(Date.today().year() + 1);
	        ap.Start_Date__c = date.newInstance(system.today().year() + 1, system.today().month(), 1);
	        ap.End_Date__c = date.newInstance(system.today().year() + 1, system.today().month(), 30);
	        ap.Type__c='Manufacturing France';       
	        insertList.add(ap);
        }
        
        for(Integer i = 1; i <= 5; i++){
	        Ad_Period__c ap=new Ad_Period__c();
	        ap.Name='FR_C' + i + '_' + String.valueOf(Date.today().year() + 2);
	        ap.Start_Date__c = date.newInstance(system.today().year() + 2, system.today().month(), 1);
	        ap.End_Date__c = date.newInstance(system.today().year() + 2, system.today().month(), 30);
	        ap.Type__c='Manufacturing France';       
	        insertList.add(ap);
        }
        
        insert insertList;
        
        Account ac=new Account();
        ac.Name='test1';
        ac.RecordTypeId = accRT.Id;
        insert ac;    
           
        RecordType rt = [SELECT id, name from RecordType Where SObjectType = 'Opportunity' AND Name = 'Contract' Limit 1];
        
        Opportunity op=new Opportunity();
        op.Name='test2';
        op.AccountId=ac.Id;
        op.CloseDate=system.today();
        op.StageName='Closed Won';
        op.RecordTypeId = rt.Id;
        op.Q1__c = 'Y';
        op.Q2__c = 'Y';
        op.Q3__c = 'Y';
        op.Q4__c = 'Y';
        insert op;
        
        Program__c pro = new Program__c();
        pro.Opportunity__c = op.Id;
        pro.Name = 'test';
        pro.Delivery_Type__c = displayType;
        pro.Program_Amount__c = 100;
        pro.Start_Date__c = date.newInstance(system.today().year(), system.today().month(), 1);
        pro.End_Date__c = date.newInstance(system.today().year(), system.today().month(), 30);
        insert pro;
        
        Program__c pro1 = new Program__c();
        pro1.Opportunity__c = op.Id;
        pro1.Name = 'test2';
        pro1.Program_Amount__c = 100;
        pro1.Delivery_Type__c = baseType;
        pro1.Start_Date__c = date.newInstance(system.today().year(), system.today().month(), 1);
        pro1.End_Date__c = date.newInstance(system.today().year(), system.today().month(), 30);
        insert pro1;
        
        Program_Forecast__c proFor = new Program_Forecast__c();
        proFor.Ad_Period__c = insertList[0].Id;
        proFor.Program__c = pro.Id;
        proFor.Forecast_Amount__c = 100;
        proFor.Actual_Amount__c = 500;
        insert profor;
        
        string cDate = String.valueOf(system.today());
        Date startDate = date.newInstance(system.today().year(), system.today().month(), 1);
        
        String cdt;
        MyForecastPageController MFPC = new MyForecastPageController(op.id,cdt,'Manufacturing France','Contract',ac.Name,'','All', 50, '[Q1,Q2,Q3,Q4]', startDate, null, '2013', '[C1]', null,null,null,null);
        //MFPC1 = new MyForecastPageController(op.id,cdt,'Manufacturing France','Contract',ac.Name,'','All', null, '[Q1,Q2,Q3,Q4]', startDate, null, null, 
                                    //null, null, null, null,null);
    }
    
    @isTest
    public static void myUnitTest6() {
    	Catalina_Forecast_Settings__c settingsNew = getCatalinaForecastSettingsRecord();
    	RecordType accRT = [SELECT id, name from RecordType Where SObjectType = 'Account' AND Name = 'Manufacturing' Limit 1];
    	
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        List<Ad_Period__c> insertList = new List<Ad_Period__c>();
        
        for(Integer i = 0; i < 13; i++){
	        Ad_Period__c ap=new Ad_Period__c();
	        ap.Name='C1_' + i;
	        ap.Start_Date__c = date.newInstance(system.today().year(), system.today().month(), 1);
	        ap.End_Date__c = date.newInstance(system.today().year(), system.today().month(), 30);
	        ap.Type__c='Manufacturing';       
	        insertList.add(ap);
        }
        
        insert insertList;
        
        Account ac=new Account();
        ac.Name='test1';
        ac.RecordTypeId = accRT.Id;
        insert ac;    
           
        RecordType rt = [SELECT id, name from RecordType Where SObjectType = 'Opportunity' AND Name = 'Contract' Limit 1];
        
        Opportunity op=new Opportunity();
        op.Name='test2';
        op.AccountId=ac.Id;
        op.CloseDate=system.today();
        op.StageName='Closed Won';
        op.RecordTypeId = rt.Id;
        op.Q1__c = 'Y';
        op.Q2__c = 'Y';
        op.Q3__c = 'Y';
        op.Q4__c = 'Y';
        insert op;
        
        Program__c pro = new Program__c();
        pro.Opportunity__c = op.Id;
        pro.Name = 'test';
        pro.Delivery_Type__c = displayType;
        pro.Program_Amount__c = 100;
        pro.Start_Date__c = date.newInstance(system.today().year(), system.today().month(), 1);
        pro.End_Date__c = date.newInstance(system.today().year(), system.today().month(), 30);
        insert pro;
        
        Program__c pro1 = new Program__c();
        pro1.Opportunity__c = op.Id;
        pro1.Name = 'test2';
        pro1.Program_Amount__c = 100;
        pro1.Delivery_Type__c = baseType;
        pro1.Start_Date__c = date.newInstance(system.today().year(), system.today().month(), 1);
        pro1.End_Date__c = date.newInstance(system.today().year(), system.today().month(), 30);
        insert pro1;
        
        Program_Forecast__c proFor = new Program_Forecast__c();
        proFor.Ad_Period__c = insertList[0].Id;
        proFor.Program__c = pro.Id;
        proFor.Forecast_Amount__c = 100;
        proFor.Actual_Amount__c = 500;
        insert profor;
        
        string cDate = String.valueOf(system.today());
        Date startDate = date.newInstance(system.today().year(), system.today().month(), 1);
        
        String cdt;
        MyForecastPageController MFPC = new MyForecastPageController(op.id,cdt,'Manufacturing','Contract',ac.Name,'','2013', 50, '[Q1,Q2,Q3,Q4]', startDate, null, null);
        //MFPC1 = new MyForecastPageController(op.id,cdt,'Manufacturing France','Contract',ac.Name,'','All', null, '[Q1,Q2,Q3,Q4]', startDate, null, null, 
                                    //null, null, null, null,null);
    }
    
    @isTest
    public static void myUnitTest7() {
    	Catalina_Forecast_Settings__c settingsNew = getCatalinaForecastSettingsRecord();
    	RecordType accRT = [SELECT id, name from RecordType Where SObjectType = 'Account' AND Name = 'メーカー' Limit 1];
    	
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        List<Ad_Period__c> insertList = new List<Ad_Period__c>();
        
        for(Integer i = 0; i < 13; i++){
	        Ad_Period__c ap=new Ad_Period__c();
	        ap.Name='C1_' + i;
	        ap.Start_Date__c = date.newInstance(system.today().year(), system.today().month(), 1);
	        ap.End_Date__c = date.newInstance(system.today().year(), system.today().month(), 30);
	        ap.Type__c='Manufacturing Japan';       
	        insertList.add(ap);
        }
        
        insert insertList;
        
        Account ac=new Account();
        ac.Name='test1';
        ac.RecordTypeId = accRT.Id;
        insert ac;    
           
        RecordType rt = [SELECT id, name from RecordType Where SObjectType = 'Opportunity' AND Name = 'Contract' Limit 1];
        
        Opportunity op=new Opportunity();
        op.Name='test2';
        op.AccountId=ac.Id;
        op.CloseDate=system.today();
        op.StageName='Closed Won';
        op.RecordTypeId = rt.Id;
        op.Q1__c = 'Y';
        op.Q2__c = 'Y';
        op.Q3__c = 'Y';
        op.Q4__c = 'Y';
        insert op;
        
        Program__c pro = new Program__c();
        pro.Opportunity__c = op.Id;
        pro.Name = 'test';
        pro.Delivery_Type__c = displayType;
        pro.Program_Amount__c = 100;
        pro.Start_Date__c = date.newInstance(system.today().year(), system.today().month(), 1);
        pro.End_Date__c = date.newInstance(system.today().year(), system.today().month(), 30);
        insert pro;
        
        Program__c pro1 = new Program__c();
        pro1.Opportunity__c = op.Id;
        pro1.Name = 'test2';
        pro1.Program_Amount__c = 100;
        pro1.Delivery_Type__c = baseType;
        pro1.Start_Date__c = date.newInstance(system.today().year(), system.today().month(), 1);
        pro1.End_Date__c = date.newInstance(system.today().year(), system.today().month(), 30);
        insert pro1;
        
        Program_Forecast__c proFor = new Program_Forecast__c();
        proFor.Ad_Period__c = insertList[0].Id;
        proFor.Program__c = pro.Id;
        proFor.Forecast_Amount__c = 100;
        proFor.Actual_Amount__c = 500;
        insert profor;
        
        string cDate = String.valueOf(system.today());
        Date startDate = date.newInstance(system.today().year(), system.today().month(), 1);
        
        String cdt;
        MyForecastPageController MFPC = new MyForecastPageController(op.id,cdt,'Manufacturing Japan','Contract',ac.Name,'','All', 50, '[Q1,Q2,Q3,Q4]', startDate, null, null);
        //MFPC1 = new MyForecastPageController(op.id,cdt,'Manufacturing France','Contract',ac.Name,'','All', null, '[Q1,Q2,Q3,Q4]', startDate, null, null, 
                                    //null, null, null, null,null);
        MFPC = new MyForecastPageController(op.id,cdt,'Retail Japan','Contract',ac.Name,'','All', 50, '[Q1,Q2,Q3,Q4]', startDate, null, null);
    }
    
    @isTest
    public static void myUnitTest8() {
    	Catalina_Forecast_Settings__c settingsNew = getCatalinaForecastSettingsRecord();
    	RecordType accRT = [SELECT id, name from RecordType Where SObjectType = 'Account' AND Name = 'Manufacturing Italy' Limit 1];
    	
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        List<Ad_Period__c> insertList = new List<Ad_Period__c>();
        
        for(Integer i = 1; i <= 5; i++){
	        Ad_Period__c ap=new Ad_Period__c();
	        ap.Name='FR_C' + i + '_' + String.valueOf(Date.today().year());
	        ap.Start_Date__c = date.newInstance(system.today().year(), system.today().month(), 1);
	        ap.End_Date__c = date.newInstance(system.today().year(), system.today().month(), 30);
	        ap.Type__c='Manufacturing Italy';       
	        insertList.add(ap);
        }
        
        for(Integer i = 1; i <= 5; i++){
	        Ad_Period__c ap=new Ad_Period__c();
	        ap.Name='FR_C' + i + '_' + String.valueOf(Date.today().year() + 1);
	        ap.Start_Date__c = date.newInstance(system.today().year() + 1, system.today().month(), 1);
	        ap.End_Date__c = date.newInstance(system.today().year() + 1, system.today().month(), 30);
	        ap.Type__c='Manufacturing Italy';       
	        insertList.add(ap);
        }
        
        for(Integer i = 1; i <= 5; i++){
	        Ad_Period__c ap=new Ad_Period__c();
	        ap.Name='FR_C' + i + '_' + String.valueOf(Date.today().year() + 2);
	        ap.Start_Date__c = date.newInstance(system.today().year() + 2, system.today().month(), 1);
	        ap.End_Date__c = date.newInstance(system.today().year() + 2, system.today().month(), 30);
	        ap.Type__c='Manufacturing Italy';       
	        insertList.add(ap);
        }
        
        insert insertList;
        
        Account ac=new Account();
        ac.Name='test1';
        ac.RecordTypeId = accRT.Id;
        insert ac;    
           
        RecordType rt = [SELECT id, name from RecordType Where SObjectType = 'Opportunity' AND Name = 'Contract' Limit 1];
        
        Opportunity op=new Opportunity();
        op.Name='test2';
        op.AccountId=ac.Id;
        op.CloseDate=system.today();
        op.StageName='Closed Won';
        op.RecordTypeId = rt.Id;
        op.Q1__c = 'Y';
        op.Q2__c = 'Y';
        op.Q3__c = 'Y';
        op.Q4__c = 'Y';
        insert op;
        
        Program__c pro = new Program__c();
        pro.Opportunity__c = op.Id;
        pro.Name = 'test';
        pro.Delivery_Type__c = displayType;
        pro.Program_Amount__c = 100;
        pro.Start_Date__c = date.newInstance(system.today().year(), system.today().month(), 1);
        pro.End_Date__c = date.newInstance(system.today().year(), system.today().month(), 30);
        insert pro;
        
        Program__c pro1 = new Program__c();
        pro1.Opportunity__c = op.Id;
        pro1.Name = 'test2';
        pro1.Program_Amount__c = 100;
        pro1.Delivery_Type__c = baseType;
        pro1.Start_Date__c = date.newInstance(system.today().year(), system.today().month(), 1);
        pro1.End_Date__c = date.newInstance(system.today().year(), system.today().month(), 30);
        insert pro1;
        
        Program_Forecast__c proFor = new Program_Forecast__c();
        proFor.Ad_Period__c = insertList[0].Id;
        proFor.Program__c = pro.Id;
        proFor.Forecast_Amount__c = 100;
        proFor.Actual_Amount__c = 500;
        insert profor;
        
        string cDate = String.valueOf(system.today());
        Date startDate = date.newInstance(system.today().year(), system.today().month(), 1);
        
        String cdt;
        MyForecastPageController MFPC = new MyForecastPageController(op.id,cdt,'Manufacturing Italy','Contract',ac.Name,'','All', 50, '[Q1,Q2,Q3,Q4]', startDate, null, '2013', '[C1]', null,null,null,null);
        //MFPC1 = new MyForecastPageController(op.id,cdt,'Manufacturing France','Contract',ac.Name,'','All', null, '[Q1,Q2,Q3,Q4]', startDate, null, null, 
                                    //null, null, null, null,null);
    }
    
    @isTest
    public static void myUnitTest9() {
    	Catalina_Forecast_Settings__c settingsNew = getCatalinaForecastSettingsRecord();
    	RecordType accRT = [SELECT id, name from RecordType Where SObjectType = 'Account' AND Name = 'Manufacturing Germany' Limit 1];
    	
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        List<Ad_Period__c> insertList = new List<Ad_Period__c>();
        
        
        Ad_Period__c ap=new Ad_Period__c();
        ap.Name='GM_C1_2013_Jan';
        ap.Start_Date__c = date.newInstance(system.today().year(), system.today().month(), 1);
        ap.End_Date__c = date.newInstance(system.today().year(), system.today().month(), 30);
        ap.Type__c='Manufacturing Germany';       
        insertList.add(ap);
		
		Ad_Period__c ap2=new Ad_Period__c();
        ap2.Name='GM_C1_2013_Feb';
        ap2.Start_Date__c = date.newInstance(system.today().year(), system.today().month(), 1);
        ap2.End_Date__c = date.newInstance(system.today().year(), system.today().month(), 30);
        ap2.Type__c='Manufacturing Germany';       
        insertList.add(ap2);
        
        Ad_Period__c ap3=new Ad_Period__c();
        ap3.Name='GM_C2_2013_Mar';
        ap3.Start_Date__c = date.newInstance(system.today().year(), system.today().month(), 1);
        ap3.End_Date__c = date.newInstance(system.today().year(), system.today().month(), 30);
        ap3.Type__c='Manufacturing Germany';       
        insertList.add(ap3);
        
        Ad_Period__c ap4=new Ad_Period__c();
        ap4.Name='GM_C2_2013_Apr';
        ap4.Start_Date__c = date.newInstance(system.today().year(), system.today().month(), 1);
        ap4.End_Date__c = date.newInstance(system.today().year(), system.today().month(), 30);
        ap4.Type__c='Manufacturing Germany';       
        insertList.add(ap4);
        
        Ad_Period__c ap5=new Ad_Period__c();
        ap5.Name='GM_C3_2013_May';
        ap5.Start_Date__c = date.newInstance(system.today().year(), system.today().month(), 1);
        ap5.End_Date__c = date.newInstance(system.today().year(), system.today().month(), 30);
        ap5.Type__c='Manufacturing Germany';       
        insertList.add(ap5);
        
        Ad_Period__c ap6=new Ad_Period__c();
        ap6.Name='GM_C3_2013_Jun';
        ap6.Start_Date__c = date.newInstance(system.today().year(), system.today().month(), 1);
        ap6.End_Date__c = date.newInstance(system.today().year(), system.today().month(), 30);
        ap6.Type__c='Manufacturing Germany';       
        insertList.add(ap6);
        
        Ad_Period__c ap7=new Ad_Period__c();
        ap7.Name='GM_C4_2013_Jul';
        ap7.Start_Date__c = date.newInstance(system.today().year(), system.today().month(), 1);
        ap7.End_Date__c = date.newInstance(system.today().year(), system.today().month(), 30);
        ap7.Type__c='Manufacturing Germany';       
        insertList.add(ap7);
        
        Ad_Period__c ap8=new Ad_Period__c();
        ap8.Name='GM_C4_2013_Aug';
        ap8.Start_Date__c = date.newInstance(system.today().year(), system.today().month(), 1);
        ap8.End_Date__c = date.newInstance(system.today().year(), system.today().month(), 30);
        ap8.Type__c='Manufacturing Germany';       
        insertList.add(ap8);
        
        Ad_Period__c ap9=new Ad_Period__c();
        ap9.Name='GM_C5_2013_Sep';
        ap9.Start_Date__c = date.newInstance(system.today().year(), system.today().month(), 1);
        ap9.End_Date__c = date.newInstance(system.today().year(), system.today().month(), 30);
        ap9.Type__c='Manufacturing Germany';       
        insertList.add(ap9);
        
        Ad_Period__c ap10=new Ad_Period__c();
        ap10.Name='GM_C5_2013_Oct';
        ap10.Start_Date__c = date.newInstance(system.today().year(), system.today().month(), 1);
        ap10.End_Date__c = date.newInstance(system.today().year(), system.today().month(), 30);
        ap10.Type__c='Manufacturing Germany';       
        insertList.add(ap10);
        
        Ad_Period__c ap11=new Ad_Period__c();
        ap11.Name='GM_C6_2013_Nov';
        ap11.Start_Date__c = date.newInstance(system.today().year(), system.today().month(), 1);
        ap11.End_Date__c = date.newInstance(system.today().year(), system.today().month(), 30);
        ap11.Type__c='Manufacturing Germany';       
        insertList.add(ap11);
        
        Ad_Period__c ap12=new Ad_Period__c();
        ap12.Name='GM_C6_2013_Dec';
        ap12.Start_Date__c = date.newInstance(system.today().year(), system.today().month(), 1);
        ap12.End_Date__c = date.newInstance(system.today().year(), system.today().month(), 30);
        ap12.Type__c='Manufacturing Germany';       
        insertList.add(ap12);
        
        Ad_Period__c ap13=new Ad_Period__c();
        ap13.Name='GM_C1_2014_Jan';
        ap13.Start_Date__c = date.newInstance(system.today().year(), system.today().month(), 1);
        ap13.End_Date__c = date.newInstance(system.today().year(), system.today().month(), 30);
        ap13.Type__c='Manufacturing Germany';       
        insertList.add(ap13);
        
        Ad_Period__c ap14=new Ad_Period__c();
        ap14.Name='GM_C1_2014_Feb';
        ap14.Start_Date__c = date.newInstance(system.today().year(), system.today().month(), 1);
        ap14.End_Date__c = date.newInstance(system.today().year(), system.today().month(), 30);
        ap14.Type__c='Manufacturing Germany';       
        insertList.add(ap14);
        
        insert insertList;
        
        Account ac=new Account();
        ac.Name='test1';
        ac.RecordTypeId = accRT.Id;
        insert ac;    
           
        RecordType rt = [SELECT id, name from RecordType Where SObjectType = 'Opportunity' AND Name = 'Contract' Limit 1];
        
        Opportunity op=new Opportunity();
        op.Name='test2';
        op.AccountId=ac.Id;
        op.CloseDate=system.today();
        op.StageName='Closed Won';
        op.RecordTypeId = rt.Id;
        op.Q1__c = 'Y';
        op.Q2__c = 'Y';
        op.Q3__c = 'Y';
        op.Q4__c = 'Y';
        insert op;
        
        Program__c pro = new Program__c();
        pro.Opportunity__c = op.Id;
        pro.Name = 'test';
        pro.Delivery_Type__c = displayType;
        pro.Program_Amount__c = 100;
        pro.Start_Date__c = date.newInstance(system.today().year(), system.today().month(), 1);
        pro.End_Date__c = date.newInstance(system.today().year(), system.today().month(), 30);
        insert pro;
        
        Program__c pro1 = new Program__c();
        pro1.Opportunity__c = op.Id;
        pro1.Name = 'test2';
        pro1.Program_Amount__c = 100;
        pro1.Delivery_Type__c = baseType;
        pro1.Start_Date__c = date.newInstance(system.today().year(), system.today().month(), 1);
        pro1.End_Date__c = date.newInstance(system.today().year(), system.today().month(), 30);
        insert pro1;
        
        Program_Forecast__c proFor = new Program_Forecast__c();
        proFor.Ad_Period__c = insertList[0].Id;
        proFor.Program__c = pro.Id;
        proFor.Forecast_Amount__c = 100;
        proFor.Actual_Amount__c = 500;
        insert profor;
        
        string cDate = String.valueOf(system.today());
        Date startDate = date.newInstance(system.today().year(), system.today().month(), 1);
        
        String cdt;
        MyForecastPageController MFPC = new MyForecastPageController(op.id,cdt,'Manufacturing Germany','Contract',ac.Name,'','All', 50, '[Q1,Q2,Q3,Q4]', startDate, null, '2013', '[C1-Jan]', null,null,null,null);
        //MFPC1 = new MyForecastPageController(op.id,cdt,'Manufacturing France','Contract',ac.Name,'','All', null, '[Q1,Q2,Q3,Q4]', startDate, null, null, 
                                    //null, null, null, null,null);
    }
    
    private static Catalina_Forecast_Settings__c getCatalinaForecastSettingsRecord(){
        Catalina_Forecast_Settings__c settings = new Catalina_Forecast_Settings__c();
        settings.Base_Delivery_Type__c = baseType;
        settings.Digital_Delivery_Type__c = digitalType;
        settings.Display_Delivery_Type__c = displayType;
        settings.Mobile_Delivery_Type__c = mobileType;
        settings.Manufacturing_Account_Type__c = manufacturingType;
        settings.Retail_Account_Type__c = retailType;
        settings.Coop_String__c = coopType;
        settings.Rep_1_String__c = SR1Type;
        settings.Rep_2_String__c = SR2Type;
        settings.SM_1_String__c = SM1Type;
        settings.SM_2_String__c = SM2Type;
        settings.PFE_Email__c = pfeEmail;
        settings.Forecast_to_Actual_AudienceNetwork__c = 11;
        settings.Forecast_to_Actual_Transition__c = 2;
        settings.Name = settingsName;
        insert settings;
        return settings;
    }
}