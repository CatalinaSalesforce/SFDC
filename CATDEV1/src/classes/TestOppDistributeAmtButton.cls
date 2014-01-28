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
 /*
@Name : TestOppDistributeAmtButton
@Author : customersuccess@cloud62.com
@Date : 07-19-2013
@Description : Test OppDistributeAmtButton class functionality.
*/
@isTest
private class TestOppDistributeAmtButton{

    /*
    @Name :oppDistributeAmtButtonTest
    @Description : Test OppDistributeAmtButton class.
    */
    static testMethod void oppDistributeAmtButtonTest() {
        // TO DO: implement unit test
        Renewal_Settings__c settings1 = getRenewalSettingsRecord();
        Catalina_Forecast_Settings__c setting = getCatalinaForecastSettingsRecord();
        Account a = getAccount('Retail');
        Opportunity o = getOpportunity(a.ID);
        Ad_Period__c ap1 = getAp1('Retail');
        Ad_Period__c ap2 = getAp2('Retail');
        Ad_Period__c ap3 = getAp3('Retail');
        Program__c p = getProgram(o.Name,o.ID,ap1.ID,ap2.ID);
        Program__c p1 = getProgram(o.Name,o.ID,ap1.ID,ap2.ID);
        List<Program_Forecast__c> pf = new List<Program_Forecast__c>();
        Program_Forecast__c pf1 = new Program_Forecast__c(Program__c = p.Id,Ad_Period__c = ap1.Id,Forecast_Amount__c = 1000);
        Program_Forecast__c pf2 = new Program_Forecast__c(Program__c = p.Id,Ad_Period__c = ap3.Id,Forecast_Amount__c = 1000,Active__c = false);
        pf.add(pf1);
        pf.add(pf2);
        //insert pf;
        
        Test.startTest();
        ApexPages.StandardController ctl = new ApexPages.StandardController(o);
        OppDistributeAmtButton oppDis = new OppDistributeAmtButton(ctl);
        oppDis.forecastReplaceCheck();
        oppDis.distributeAmounts();
        oppDis.returnToProgram();
        Test.stopTest();
    }
    
    /*
    @Name :oppDisAmtButtonTest
    @Description : Test OppDistributeAmtButton class.
    */
    static testMethod void oppDisAmtButtonTest() {
        // TO DO: implement unit test
        Renewal_Settings__c settings1 = getRenewalSettingsRecord();
        Catalina_Forecast_Settings__c setting = getCatalinaForecastSettingsRecord();
        Account a = getAccount('Retail');
        Opportunity o = getOpportunity(a.ID);
        Ad_Period__c ap1 = getAp1('Retail');
        Ad_Period__c ap2 = getAp2('Retail');
        Ad_Period__c ap3 = getAp3('Retail');
        Program__c p2 = getProgram1(o.Name,o.ID,ap2.ID,ap3.ID,'Retail');
        Program__c p3 = getProgram1(o.Name,o.ID,ap2.ID,ap3.ID,'Retail');
        List<Program_Forecast__c> pf = new List<Program_Forecast__c>();
        Program_Forecast__c pf1 = new Program_Forecast__c(Program__c = p2.Id,Ad_Period__c = ap1.Id,Forecast_Amount__c = 1000);
        Program_Forecast__c pf2 = new Program_Forecast__c(Program__c = p3.Id,Ad_Period__c = ap3.Id,Forecast_Amount__c = 1000,Active__c = false);
        pf.add(pf1);
        pf.add(pf2);
        insert pf;
        
        Test.startTest();
        ApexPages.StandardController ctl = new ApexPages.StandardController(o);
        OppDistributeAmtButton oppDis = new OppDistributeAmtButton(ctl);
        oppDis.forecastReplaceCheck();
        oppDis.distributeAmounts();
        oppDis.returnToProgram();
        Test.stopTest();
    }
    
    /*
    @Name :oppDisAmtButton1Test
    @Description : Test OppDistributeAmtButton class.
    */
    static testMethod void oppDisAmtButton1Test() {
        // TO DO: implement unit test
        Renewal_Settings__c settings1 = getRenewalSettingsRecord();
        Catalina_Forecast_Settings__c setting = getCatalinaForecastSettingsRecord();
        Account a = getAccount('Manufacturing Germany');
        Opportunity o = getOpportunity(a.ID);
        Ad_Period__c ap1 = getAp1('Manufacturing Germany');
        Ad_Period__c ap2 = getAp2('Manufacturing Germany');
        Ad_Period__c ap3 = getAp3('Manufacturing Germany');
        Program__c p2 = getProgram1(o.Name,o.ID,ap2.ID,ap3.ID,'Manufacturing Germany');
        Program__c p3 = getProgram1(o.Name,o.ID,ap2.ID,ap3.ID,'Manufacturing Germany');
        List<Program_Forecast__c> pf = new List<Program_Forecast__c>();
        Program_Forecast__c pf1 = new Program_Forecast__c(Program__c = p2.Id,Ad_Period__c = ap1.Id,Forecast_Amount__c = 1000);
        Program_Forecast__c pf2 = new Program_Forecast__c(Program__c = p3.Id,Ad_Period__c = ap3.Id,Forecast_Amount__c = 1000,Active__c = false);
        pf.add(pf1);
        pf.add(pf2);
        insert pf;
        
        Test.startTest();
        ApexPages.StandardController ctl = new ApexPages.StandardController(o);
        OppDistributeAmtButton oppDis = new OppDistributeAmtButton(ctl);
        oppDis.forecastReplaceCheck();
        oppDis.distributeAmounts();
        oppDis.returnToProgram();
        Test.stopTest();
    }
    
    /*
    @Name :getAccount
    @Description : Insert Account test data.
    */
    private static Account getAccount(String rtype){
        List<RecordType> accountRTID = [SELECT ID FROM RecordType Where Name = :rtype and SOBJECTTYPE = 'Account'];
        Account a = new Account();
        a.Name = 'Test Account';
        if(accountRTID != null && accountRTID.size()>0){
            a.RecordTypeId = accountRTID[0].ID;
        }
        insert a;
        return a;
    }
    
    /*
    @Name :getOpportunity
    @Description : Insert Opportunity test data.
    */
    private static Opportunity getOpportunity(ID a){
        List<RecordType> rtID = [SELECT ID FROM RecordType Where Name = 'Contract Germany' and SOBJECTTYPE = 'Opportunity'];
        Opportunity o = new Opportunity();
        o.Start_Date__c = system.today().addYears(-1);
        o.AccountId = a;
        if(rtID != null && rtID.size()>0){
            o.RecordTypeId = rtID[0].ID;
        }
        o.Name = 'Test oppty';
        o.StageName = 'Presented';
        o.CloseDate = Date.today();
        insert o;
        return o;
    }
    
     /*
    @Name :getAp1
    @Description : Insert Ad_Period__c test data.
    */
    private static Ad_Period__c getAp1(String type){
        Ad_Period__c ap1 = new Ad_Period__c();
        ap1.Name = 'GM_C2_2013_Mar';
        ap1.Start_Date__c = Date.valueOf('2012-03-23');
        ap1.End_Date__c = Date.valueOf('2012-05-19');
        ap1.Type__c = type;
        insert ap1;
        return ap1;
    }
    
    /*
    @Name :getAp2
    @Description : Insert Ad_Period__c test data.
    */
    private static Ad_Period__c getAp2(String type){
        Ad_Period__c ap2 = new Ad_Period__c();
        ap2.Name = 'GM_C4_2013_Jul';
        ap2.Start_Date__c = Date.valueOf('2012-01-23');
        ap2.End_Date__c = Date.valueOf('2012-02-19');
        ap2.Type__c = type;
        insert ap2;
        return ap2;
    }
    
    /*
    @Name :getAp3
    @Description : Insert Ad_Period__c test data.
    */
    private static Ad_Period__c getAp3(String type){
        Ad_Period__c ap3 = new Ad_Period__c();
        ap3.Name = 'GM_C2_2014_Mar';
        ap3.Start_Date__c = Date.valueOf('2012-12-23');
        ap3.End_Date__c = Date.valueOf('2012-01-19');
        ap3.Type__c = type;
        insert ap3;
        return ap3;
    }
    
    /*
    @Name :getProgram
    @Description : Insert Program__c test data.
    */
    private static Program__c getProgram(String oName,Id o,Id ap1,Id ap2){
        Program__c p = new Program__c();
        p.Name = oName + ' Base';
        p.Opportunity__c = o;
        p.Delivery_Type__c = 'Base';
        //p.Account_Type__c = 'Manufacturing Germany';
        p.Account_Type__c = 'Retail';
        p.Product_Type__c = 'Base Product Type1';
        //p.Start_Cycle__c = ap1;
        //p.End_Cycle__c = ap2;
        insert p;
        return p;
    }
    
    /*
    @Name :getProgram1
    @Description : Insert Program__c test data.
    */
    private static Program__c getProgram1(String oName,Id o,Id ap1,Id ap2,String type){
        Program__c p = new Program__c();
        p.Name = oName + ' Base';
        p.Opportunity__c = o;
        p.Delivery_Type__c = 'Base';
        p.Account_Type__c = type;
        p.Product_Type__c = 'Base Product Type1';
        p.Start_Cycle__c = ap1;
        p.End_Cycle__c = ap2;
        insert p;
        return p;
    }
    
    /*
    @Name :getRenewalSettingsRecord
    @Description : Insert getRenewalSettingsRecord test data.
    */
    private static Renewal_Settings__c getRenewalSettingsRecord(){
        Renewal_Settings__c settings = Renewal_Settings__c.getOrgDefaults();
        settings.Renewal_Window_Size__c = 14;
        settings.Percent_Goal__c = 0;
        insert settings;
        return settings;
    }
    
    /*
    @Name :getCatalinaForecastSettingsRecord
    @Description : Insert Catalina_Forecast_Settings__c test data.
    */
    private static Catalina_Forecast_Settings__c getCatalinaForecastSettingsRecord(){
        Catalina_Forecast_Settings__c settings = new Catalina_Forecast_Settings__c();
        settings.Base_Delivery_Type__c = 'Base';
        settings.Digital_Delivery_Type__c = 'Digital O&O';
        settings.Display_Delivery_Type__c = 'Audience Network';
        settings.Mobile_Delivery_Type__c = 'Mobile';
        settings.Manufacturing_Account_Type__c = 'Manufacturing';
        settings.Retail_Account_Type__c = 'Retail';
        settings.Coop_String__c = 'coop';
        settings.Rep_1_String__c = 'SR1';
        settings.Rep_2_String__c = 'SR2';
        settings.SM_1_String__c = 'SM1';
        settings.SM_2_String__c = 'SM2';
        settings.Name = 'Default';
        settings.Forecast_to_Actual_Transition__c = 2;
        insert settings;
        return settings;
    }
}