/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
public class TestBatchFranceClientTrend{
	
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
    private static final String settingsName = 'Default';
    private static final Integer settingsWindow = 0;
    private static final Integer settingsPercent = 12;

    static testMethod void BatchFranceClientTrend1() {
        
        String rtID = [SELECT ID FROM RecordType Where Name = 'CONTRACT FRANCE' and SOBJECTTYPE = 'Opportunity'][0].Id;
        
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
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
        settings.Name = settingsName;
        insert settings;
        
        Account acc = new Account();
        acc.Name = 'test1';
        insert acc;
        
        Opportunity o = new Opportunity();
        o.AccountId = acc.Id;
        o.RecordTypeId = rtID;
        o.Name = 'Test oppty';
        o.StageName = 'Presented';
        o.CloseDate = Date.today();
        insert o;
        
        Ad_Period__c ap1 = new Ad_Period__c();
        ap1.Name = 'FR_C1_2013';
        ap1.Start_Date__c = Date.valueOf('2012-01-23');
        ap1.End_Date__c = Date.valueOf('2012-02-19');
        ap1.Type__c = 'Manufacturing France';
        insert ap1;

        Program__c pro = new Program__c();
        pro.Opportunity__c = o.Id;
        pro.Name = 'test';
        pro.Delivery_Type__c = 'Base';
        pro.Program_Amount__c = 100;
        insert pro;
        
        Program_Forecast__c pf1 = new Program_Forecast__c();
        pf1.Program__c = pro.Id;
        pf1.Ad_Period__c = ap1.Id;
        pf1.ACTUAL_AMOUNT__C = 100;
        pf1.FORECAST_AMOUNT__C = 100;
        pf1.Active__c = False;
        insert pf1;      
        
        Test.startTest();
        BatchFranceClientTrend obj = new BatchFranceClientTrend ('LIMIT 200');
        BatchFranceClientTrend obj1 = new BatchFranceClientTrend ();
        Database.executeBatch(obj, 200);
        Test.stopTest();
    
    }
    
    static testMethod void BatchFranceClientTrend2() {
        
        String rtID = [SELECT ID FROM RecordType Where Name = 'PROPOSAL FRANCE' and SOBJECTTYPE = 'Opportunity'][0].Id;
        
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
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
        settings.Name = settingsName;
        insert settings;
        
        Account acc = new Account();
        acc.Name = 'test1';
        insert acc;
        
        Opportunity o = new Opportunity();
        o.AccountId = acc.Id;
        o.RecordTypeId = rtID;
        o.Name = 'Test oppty';
        o.StageName = 'Presented';
        o.CloseDate = Date.today();
        insert o;
        
        Ad_Period__c ap1 = new Ad_Period__c();
        ap1.Name = 'FR_C1_2013';
        ap1.Start_Date__c = Date.valueOf('2012-01-23');
        ap1.End_Date__c = Date.valueOf('2012-02-19');
        ap1.Type__c = 'Manufacturing France';
        insert ap1;
       
        Program__c pro = new Program__c();
        pro.Opportunity__c = o.Id;
        pro.Name = 'test';
        pro.Delivery_Type__c = 'Base';
        pro.Program_Amount__c = 100;
        insert pro;
        
        Program_Forecast__c pf1 = new Program_Forecast__c();
        pf1.Program__c = pro.Id;
        pf1.Ad_Period__c = ap1.Id;
        pf1.ACTUAL_AMOUNT__C = 100;
        pf1.FORECAST_AMOUNT__C = 100;
        pf1.Active__c = True;
        insert pf1;            
        
        Test.startTest();
        BatchFranceClientTrend obj = new BatchFranceClientTrend ('LIMIT 200');
        Database.executeBatch(obj, 200);
        Test.stopTest();
    
    }
    
    static testMethod void BatchFranceDeleteMonthlySDLY() {
        
        Test.startTest();
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        BatchFranceDeleteMonthlySDLY acctBatch2Sched = new BatchFranceDeleteMonthlySDLY();
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
        Test.stopTest();
    
    }
    
    static testMethod void BatchFranceDeleteClientTrend() {
        
        Test.startTest();
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        BatchFranceDeleteClientTrend acctBatch2Sched = new BatchFranceDeleteClientTrend();
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
        Database.executeBatch(acctBatch2Sched, 200);
        Test.stopTest();
    
    }
    
}