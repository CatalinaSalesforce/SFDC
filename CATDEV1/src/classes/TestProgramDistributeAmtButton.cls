/**

@Name           :       TestProgramDistributeAmtButton
@Author         :       matt@cloud62.com
@Date           :       5/23/12
@Description    :       Test class for ProgramDistributeAmtButton.cls - the Distribute Program Amounts button
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
private class TestProgramDistributeAmtButton {
/*
    static testMethod void myUnitTest() {
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        // TO DO: implement unit test
        String accountRTID = [SELECT ID FROM RecordType Where Name = 'Manufacturing' and SOBJECTTYPE = 'Account'][0].Id;
        String accountRTID2 = [select ID from RecordType where Name = 'Retail' and SOBJECTTYPE = 'Account'][0].Id;

        Account a = new Account();
        a.Name = 'test 1234';
        a.RecordTypeId = accountRTID;
        List<Ad_Period__c> apList = new List<Ad_Period__c>();

        insert a;

        Account a2 = new Account();
        a2.Name = 'retail test';
        a2.RecordTypeId = accountRTID2;
        insert a2; //was missing, added by Warren

        List<Opportunity> oppList = new List<Opportunity>();

        Opportunity o = new Opportunity();
        o.Name = 'test oppty';
        o.StageName = 'Qualification';
        o.CloseDate = Date.Today();
        o.AccountId = a.Id;
        oppList.add(o);

        Opportunity o2 = new Opportunity();
        o2.Name = 'test opp2';
        o2.StageName = 'Qualification';
        o2.CloseDate = date.Today();
        o2.AccountId = a2.Id;
        oppList.add(o2);

        insert oppList;

        Ad_Period__c ap = new Ad_Period__c();
        ap.Name = 'Ad Period 1';
        ap.Start_Date__c = date.parse('05/01/2012');
        ap.End_Date__c = date.parse('05/30/2012');
        ap.Type__c = 'Manufacturing';
        apList.add(ap);

        Ad_Period__c ap3 = new Ad_Period__c();
        ap3.Name = 'Ad Period 1';
        ap3.Start_Date__c = date.parse('06/01/2012');
        ap3.End_Date__c = date.parse('06/30/2012');
        ap3.Type__c = 'Manufacturing';
        apList.add(ap3);

        Ad_Period__c ap4 = new Ad_Period__c();
        ap4.Name = 'Ad Period 1';
        ap4.Start_Date__c = date.parse('07/01/2012');
        ap4.End_Date__c = date.parse('07/30/2012');
        ap4.Type__c = 'Manufacturing';
        apList.add(ap4);


        Ad_Period__c ap5 = new Ad_Period__c();
        ap5.Name = 'Ad Period 1';
        ap5.Start_Date__c = date.parse('08/01/2012');
        ap5.End_Date__c = date.parse('08/30/2012');
        ap5.Type__c = 'Manufacturing';
        apList.add(ap5);

        Ad_Period__c ap2 = new Ad_Period__c();
        ap.Name = 'Ad Period 2';
        ap.Start_Date__c = date.parse('09/01/2012');
        ap.End_Date__c = date.parse('09/30/2012');
        ap.Type__c = 'Manufacturing';
        apList.add(ap2);

        Ad_Period__c apEnd = new Ad_Period__c();
        apEnd.Name = 'AdPeriod1Close';
        apEnd.Start_Date__c = date.parse('10/01/2012');
        apEnd.End_Date__c = date.parse('10/30/2012');
        apEnd.Type__c = 'Manufacturing';
        apList.add(apEnd);

        Ad_Period__c ap3End = new Ad_Period__c();
        ap3End.Name = 'AdPeriod1Close';
        ap3End.Start_Date__c = date.parse('10/03/2012');
        ap3End.End_Date__c = date.parse('10/15/2012');
        ap3End.Type__c = 'Manufacturing';
        apList.add(ap3End);

        Ad_Period__c ap2End = new Ad_Period__c();
        ap2End.Name = 'AdPeriod1Close';
        ap2End.Start_Date__c = date.parse('11/01/2012');
        ap2End.End_Date__c = date.parse('11/30/2012');
        ap2End.Type__c = 'Manufacturing';
        apList.add(ap2End);

        insert apList;

        List<Ad_Period__c> newAPList = new List<Ad_Period__c>();
        for(Ad_Period__c apc : apList){
            Ad_Period__c aptEnd = new Ad_Period__c();
            aptEnd.Name = apc.Name;
            aptEnd.Start_Date__c = apc.Start_Date__c;
            aptEnd.End_Date__c = apc.End_Date__c;
            aptEnd.Type__c = 'Retail';
            newAPList.add(aptEnd);
        }
        insert newAPList;


        Program__c p = new Program__c();
        p.Name = 'test prog';
        p.Opportunity__c = o2.Id;
        p.Account_Type__c = 'Retail';
        p.Program_Amount__c = 100000;
        p.Start_Date__c = date.parse('05/30/2012');
        p.End_Date__c = date.parse('10/30/2012');
       // p.End_Cycle__c = apEnd;
       // p.Start_Cycle__c
        List<Program__c> progList = new List<Program__c>();

        progList.add(p);

        Program__c p2 = new Program__c();
        p2.Name = 'testprog2';
        p2.Opportunity__c = o.Id;
        p2.Program_Amount__c = 100000;
        p2.Account_Type__c = 'Manufacturing';
        p2.Start_Date__c = date.parse('05/30/2012');
        p2.End_Date__c = date.parse('10/30/2012');
        progList.add(p2);



        insert progList;
        system.debug('p2s cycles: ' + p2.Start_Cycle__c + p2.End_Cycle__c);   //shows up as null in debuglog
        List<Program_Forecast__c> pfList = new List<Program_Forecast__c>();
        Program_Forecast__c pf = new Program_Forecast__c();
        pf.Program__c = p2.Id;
        pf.Ad_Period__c = ap2.Id; //added by Warren
        pfList.add(pf);
        system.debug(p2.Account_Type__c);

        Program_Forecast__c pf3 = new Program_Forecast__c();
        pf3.Program__c = p2.Id;
        pf3.Ad_Period__c = ap5.Id; //added by Warren
        pf3.Forecast_Amount__c = 3;
        pfList.add(pf3);

        Program_Forecast__c pf2 = new Program_Forecast__c();
        pf2.Program__c = p.Id;
        pf2.Ad_Period__c = newAPList.get(3).Id; //added by Warren
        pfList.add(pf2);
        system.debug(p.Account_Type__c);

        Program_Forecast__c pf4 = new Program_Forecast__c();
        pf4.Program__c = p.Id;
        pf4.Ad_Period__c = newAPList.get(2).Id; //added by Warren
        pf4.Forecast_Amount__c = 3;
        pfList.add(pf4);
        
        insert pfList;

        PageReference pageRef = Page.ProgramDistributeAmtButton;

        Test.setCurrentPageReference(pageRef);

        ApexPages.StandardController sc = new ApexPages.StandardController(p);
        ProgramDistributeAmtButton pdab = new ProgramDistributeAmtButton(sc);



        //update p;

        pdab.forecastReplaceCheck();
        pdab.distributeAmounts();

        pdab.forecastReplaceCheck();

        p2.Account_Type__c = 'Retail';
        update p2;
        //p2 = [SELECT ID, ACCOUNT_TYPE__C FROM PROGRAM__C WHERE ID =: p2.Id][0];
        system.debug('p2type = '+ p2.Account_Type__c);
        sc = new ApexPages.StandardController(p2);
        pdab = new ProgramDistributeAmtButton(sc);
        pdab.distributeAmounts();
        pdab.returnToProgram();


    }*/
    /*
    static testMethod void myUnitTest1() {
        // TO DO: implement unit test
        String accountRTID = [SELECT ID FROM RecordType Where Name = 'Manufacturing' and SOBJECTTYPE = 'Account'][0].Id;
        String accountRTID2 = [select ID from RecordType where Name = 'Retail' and SOBJECTTYPE = 'Account'][0].Id;

        Account a = new Account();
        a.Name = 'test 1234';
        a.RecordTypeId = accountRTID;
        List<Ad_Period__c> apList = new List<Ad_Period__c>();

        insert a;

        Account a2 = new Account();
        a2.Name = 'retail test';
        a2.RecordTypeId = accountRTID2;
        insert a2; //was missing, added by Warren

        List<Opportunity> oppList = new List<Opportunity>();

        Opportunity o = new Opportunity();
        o.Name = 'test oppty';
        o.StageName = 'Qualification';
        o.CloseDate = Date.Today();
        o.AccountId = a.Id;
        oppList.add(o);

        Opportunity o2 = new Opportunity();
        o2.Name = 'test opp2';
        o2.StageName = 'Qualification';
        o2.CloseDate = date.Today();
        o2.AccountId = a2.Id;
        oppList.add(o2);

        insert oppList;

        Ad_Period__c ap = new Ad_Period__c();
        ap.Name = 'Ad Period 1';
        ap.Start_Date__c = date.parse('05/01/2012');
        ap.End_Date__c = date.parse('05/30/2012');
        ap.Type__c = 'Manufacturing';
        apList.add(ap);

        Ad_Period__c ap3 = new Ad_Period__c();
        ap3.Name = 'Ad Period 1';
        ap3.Start_Date__c = date.parse('06/01/2012');
        ap3.End_Date__c = date.parse('06/30/2012');
        ap3.Type__c = 'Manufacturing';
        apList.add(ap3);

        Ad_Period__c ap4 = new Ad_Period__c();
        ap4.Name = 'Ad Period 1';
        ap4.Start_Date__c = date.parse('07/01/2012');
        ap4.End_Date__c = date.parse('07/30/2012');
        ap4.Type__c = 'Manufacturing';
        apList.add(ap4);


        Ad_Period__c ap5 = new Ad_Period__c();
        ap5.Name = 'Ad Period 1';
        ap5.Start_Date__c = date.parse('08/01/2012');
        ap5.End_Date__c = date.parse('08/30/2012');
        ap5.Type__c = 'Manufacturing';
        apList.add(ap5);

        Ad_Period__c ap2 = new Ad_Period__c();
        ap.Name = 'Ad Period 2';
        ap.Start_Date__c = date.parse('09/01/2012');
        ap.End_Date__c = date.parse('09/30/2012');
        ap.Type__c = 'Manufacturing';
        apList.add(ap2);

        Ad_Period__c apEnd = new Ad_Period__c();
        apEnd.Name = 'AdPeriod1Close';
        apEnd.Start_Date__c = date.parse('10/01/2012');
        apEnd.End_Date__c = date.parse('10/30/2012');
        apEnd.Type__c = 'Manufacturing';
        apList.add(apEnd);

        Ad_Period__c ap3End = new Ad_Period__c();
        ap3End.Name = 'AdPeriod1Close';
        ap3End.Start_Date__c = date.parse('10/03/2012');
        ap3End.End_Date__c = date.parse('10/15/2012');
        ap3End.Type__c = 'Manufacturing';
        apList.add(ap3End);

        Ad_Period__c ap2End = new Ad_Period__c();
        ap2End.Name = 'AdPeriod1Close';
        ap2End.Start_Date__c = date.parse('11/01/2012');
        ap2End.End_Date__c = date.parse('11/30/2012');
        ap2End.Type__c = 'Manufacturing';
        apList.add(ap2End);

        insert apList;

        List<Ad_Period__c> newAPList = new List<Ad_Period__c>();
        for(Ad_Period__c apc : apList){
            Ad_Period__c aptEnd = new Ad_Period__c();
            aptEnd.Name = apc.Name;
            aptEnd.Start_Date__c = apc.Start_Date__c;
            aptEnd.End_Date__c = apc.End_Date__c;
            aptEnd.Type__c = 'Retail';
            newAPList.add(aptEnd);
        }
        insert newAPList;


        Program__c p = new Program__c();
        p.Name = 'test prog';
        p.Opportunity__c = o2.Id;
        p.Account_Type__c = 'Retail';
        p.Program_Amount__c = 100000;
        p.Start_Date__c = date.parse('05/30/2012');
        p.End_Date__c = date.parse('10/30/2012');
        p.End_Cycle__c = newAPList.get(0).Id;
        p.Start_Cycle__c  = newAPList.get(5).Id;

        List<Program__c> progList = new List<Program__c>();

        progList.add(p);

        Program__c p2 = new Program__c();
        p2.Name = 'testprog2';
        p2.Opportunity__c = o.Id;
        p2.Program_Amount__c = 100000;
        p2.Account_Type__c = 'Manufacturing';
        p2.Start_Date__c = date.parse('05/30/2012');
        p2.End_Date__c = date.parse('10/30/2012');
        progList.add(p2);



        insert progList;

        List<Program_Forecast__c> pfList = new List<Program_Forecast__c>();
        Program_Forecast__c pf = new Program_Forecast__c();
        pf.Program__c = p2.Id;
        pf.Ad_Period__c = ap2.Id; //added by Warren
        pfList.add(pf);

        Program_Forecast__c pf3 = new Program_Forecast__c();
        pf3.Program__c = p2.Id;
        pf3.Ad_Period__c = ap5.Id; //added by Warren
        pf3.Forecast_Amount__c = 3;
        pfList.add(pf3);

        Program_Forecast__c pf2 = new Program_Forecast__c();
        pf2.Program__c = p.Id;
        pf2.Ad_Period__c = newAPList.get(3).Id; //added by Warren
        pfList.add(pf2);

        Program_Forecast__c pf4 = new Program_Forecast__c();
        pf4.Program__c = p.Id;
        pf4.Ad_Period__c = newAPList.get(2).Id; //added by Warren
        pf4.Forecast_Amount__c = 3;
        pfList.add(pf4);

        insert pfList;

        PageReference pageRef = Page.ProgramDistributeAmtButton;

        Test.setCurrentPageReference(pageRef);

        ApexPages.StandardController sc = new ApexPages.StandardController(p);
        ProgramDistributeAmtButton pdab = new ProgramDistributeAmtButton(sc);



        //update p;

        pdab.forecastReplaceCheck();
        pdab.distributeAmounts();

        pdab.forecastReplaceCheck();

        p2.Account_Type__c = 'Retail';
        update p2;
        //p2 = [SELECT ID, ACCOUNT_TYPE__C FROM PROGRAM__C WHERE ID =: p2.Id][0];
        system.debug('p2type = '+ p2.Account_Type__c);
        sc = new ApexPages.StandardController(p2);
        pdab = new ProgramDistributeAmtButton(sc);
        pdab.distributeAmounts();
        pdab.returnToProgram();


    }
    */
    
    static testMethod void test3(){
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        String accountRTID = [SELECT ID FROM RecordType Where Name = 'Manufacturing' and SOBJECTTYPE = 'Account'][0].Id;
        String accountRTID2 = [select ID from RecordType where Name = 'Retail' and SOBJECTTYPE = 'Account'][0].Id;

        Account manuAccount = new Account();
        manuAccount.Name = 'test 1234';
        manuAccount.RecordTypeId = accountRTID;
        List<Ad_Period__c> apList = new List<Ad_Period__c>();

        insert manuAccount;

        Account retailAccount = new Account();
        retailAccount.Name = 'retail test';
        retailAccount.RecordTypeId = accountRTID2;
        insert retailAccount; //was missing, added by Warren

        List<Opportunity> oppList = new List<Opportunity>();

        Opportunity o = new Opportunity();
        o.Name = 'test oppty';
        o.StageName = 'Qualification';
        o.CloseDate = Date.Today();
        o.AccountId = manuAccount.Id;
        oppList.add(o);

        Opportunity o2 = new Opportunity();
        o2.Name = 'test opp2';
        o2.StageName = 'Qualification';
        o2.CloseDate = date.Today();
        o2.AccountId = retailAccount.Id;
        oppList.add(o2);

        insert oppList;

        Ad_Period__c ap = new Ad_Period__c();
        ap.Name = 'Ad Period 1';
        ap.Start_Date__c = date.parse('05/01/2012');
        ap.End_Date__c = date.parse('05/30/2012');
        ap.Type__c = 'Manufacturing';
        apList.add(ap);

        Ad_Period__c ap1 = new Ad_Period__c();
        ap1.Name = 'Ad Period 1';
        ap1.Start_Date__c = date.parse('06/01/2012');
        ap1.End_Date__c = date.parse('06/30/2012');
        ap1.Type__c = 'Manufacturing';
        apList.add(ap1);

        Ad_Period__c ap2 = new Ad_Period__c();
        ap2.Name = 'Ad Period 2';
        ap2.Start_Date__c = date.parse('05/01/2012');
        ap2.End_Date__c = date.parse('05/30/2012');
        ap2.Type__c = 'Retail';
        apList.add(ap2);

        Ad_Period__c ap3 = new Ad_Period__c();
        ap3.Name = 'Ad Period 1';
        ap3.Start_Date__c = date.parse('06/01/2012');
        ap3.End_Date__c = date.parse('06/30/2012');
        ap3.Type__c = 'Retail';
        apList.add(ap3);

        insert apList;

        apList = [select Id from Ad_Period__c];
        Program__c p = new Program__c();
        p.Name = 'test prog';
        p.Opportunity__c = o.Id;
        p.Account_Type__c = 'Manufacturing';
        p.Program_Amount__c = 100000;
      //  p.Start_Date__c = date.parse('05/30/2012');
     //   p.End_Date__c = date.parse('06/30/2012');
        p.Start_Cycle__c = apList.get(0).Id;
        p.End_Cycle__c = apList.get(1).Id;
        List<Program__c> progList = new List<Program__c>();

        progList.add(p);

        Program__c p2 = new Program__c();
        p2.Name = 'test prog';
        p2.Opportunity__c = o2.Id;
        p2.Account_Type__c = 'Retail';
        p2.Program_Amount__c = 100000;
      //  p2.Start_Date__c = date.parse('05/30/2012');
       // p2.End_Date__c = date.parse('6/30/2012');

        p2.Start_Cycle__c = apList.get(2).Id;
        p2.End_Cycle__c = apList.get(3).Id;

        progList.add(p2);
        insert progList;
        system.debug('p2 cycle ids: ' + p2.Start_Cycle__c + p2.End_Cycle__c);  //shows up as not null in debug log

        List<Program_Forecast__c> pfList = new List<Program_Forecast__c>();
        Program_Forecast__c pf = new Program_Forecast__c();
        pf.Program__c = p.Id;
        pf.Ad_Period__c = p.Start_Cycle__c;
        pfList.add(pf);

        Program_Forecast__c pf2 = new Program_Forecast__c();
        pf2.Program__c = p2.Id;
        pf2.Ad_Period__c = p2.Start_Cycle__c;
        pfList.add(pf2);


        insert pfList;
        PageReference pageRef = Page.ProgramDistributeAmtButton;
        Test.setCurrentPageReference(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(p);
        ProgramDistributeAmtButton pdab = new ProgramDistributeAmtButton(sc);
        pdab.distributeAmounts();

    }
    
    static testMethod void test4(){
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        String accountRTID = [SELECT ID FROM RecordType Where Name = 'Manufacturing' and SOBJECTTYPE = 'Account'][0].Id;
        String accountRTID2 = [select ID from RecordType where Name = 'Retail' and SOBJECTTYPE = 'Account'][0].Id;

        Account manuAccount = new Account();
        manuAccount.Name = 'test 1234';
        manuAccount.RecordTypeId = accountRTID;
        List<Ad_Period__c> apList = new List<Ad_Period__c>();

        insert manuAccount;

        Account retailAccount = new Account();
        retailAccount.Name = 'retail test';
        retailAccount.RecordTypeId = accountRTID2;
        insert retailAccount; //was missing, added by Warren

        List<Opportunity> oppList = new List<Opportunity>();

        Opportunity o = new Opportunity();
        o.Name = 'test oppty';
        o.StageName = 'Qualification';
        o.CloseDate = Date.Today();
        o.AccountId = manuAccount.Id;
        oppList.add(o);

        Opportunity o2 = new Opportunity();
        o2.Name = 'test opp2';
        o2.StageName = 'Qualification';
        o2.CloseDate = date.Today();
        o2.AccountId = retailAccount.Id;
        oppList.add(o2);

        insert oppList;

        Ad_Period__c ap = new Ad_Period__c();
        ap.Name = 'Ad Period 1';
        ap.Start_Date__c = date.parse('05/01/2012');
        ap.End_Date__c = date.parse('05/30/2012');
        ap.Type__c = 'Manufacturing';
        apList.add(ap);

        Ad_Period__c ap1 = new Ad_Period__c();
        ap1.Name = 'Ad Period 1';
        ap1.Start_Date__c = date.parse('06/01/2012');
        ap1.End_Date__c = date.parse('06/30/2012');
        ap1.Type__c = 'Manufacturing';
        apList.add(ap1);

        Ad_Period__c ap2 = new Ad_Period__c();
        ap2.Name = 'Ad Period 2';
        ap2.Start_Date__c = date.parse('05/01/2012');
        ap2.End_Date__c = date.parse('05/30/2012');
        ap2.Type__c = 'Retail';
        apList.add(ap2);

        Ad_Period__c ap3 = new Ad_Period__c();
        ap3.Name = 'Ad Period 1';
        ap3.Start_Date__c = date.parse('06/01/2012');
        ap3.End_Date__c = date.parse('06/30/2012');
        ap3.Type__c = 'Retail';
        apList.add(ap3);

        insert apList;

        apList = [select Id from Ad_Period__c];
        Program__c p = new Program__c();
        p.Name = 'test prog';
        p.Opportunity__c = o.Id;
        p.Account_Type__c = 'Manufacturing';
        p.Program_Amount__c = 100000;
      //  p.Start_Date__c = date.parse('05/30/2012');
     //   p.End_Date__c = date.parse('06/30/2012');
        p.Start_Cycle__c = apList.get(0).Id;
        p.End_Cycle__c = apList.get(1).Id;
        List<Program__c> progList = new List<Program__c>();

        progList.add(p);

        Program__c p2 = new Program__c();
        p2.Name = 'test prog';
        p2.Opportunity__c = o2.Id;
        p2.Account_Type__c = 'Retail';
        p2.Program_Amount__c = 100000;
      //  p2.Start_Date__c = date.parse('05/30/2012');
       // p2.End_Date__c = date.parse('6/30/2012');

        p2.Start_Cycle__c = apList.get(2).Id;
        p2.End_Cycle__c = apList.get(3).Id;

        progList.add(p2);
        insert progList;
        system.debug('p2 cycle ids: ' + p2.Start_Cycle__c + p2.End_Cycle__c);  //shows up as not null in debug log

        List<Program_Forecast__c> pfList = new List<Program_Forecast__c>();
        Program_Forecast__c pf = new Program_Forecast__c();
        pf.Program__c = p.Id;
        pf.Ad_Period__c = p.Start_Cycle__c;
        pfList.add(pf);

        Program_Forecast__c pf2 = new Program_Forecast__c();
        pf2.Program__c = p2.Id;
        pf2.Ad_Period__c = p2.Start_Cycle__c;
        pfList.add(pf2);


        insert pfList;
        
        PageReference pageRef = Page.ProgramDistributeAmtButton;
        Test.setCurrentPageReference(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(p2);
        ProgramDistributeAmtButton pdab = new ProgramDistributeAmtButton(sc);
        pdab.distributeAmounts();

    }
}