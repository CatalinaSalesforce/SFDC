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
@Name : TestEuropeBatchProcess
@Author : customersuccess@cloud62.com
@Date : 06-25-2013
@Description : Test Europe Batch Classes functionality.
*/
@isTest
private class TestEuropeBatchProcess{
    
    /*
    @Name :testBatchEuropeDeactivatePF
    @Description : Test BatchEuropeDeactivatePF.
    */
    static testMethod void testBatchEuropeDeactivatePF() {
        // TO DO: implement unit test
        Renewal_Settings__c settings1 = getRenewalSettingsRecord();
        User testEVP = getUserTestEVP();
        User testSM1 = getUserTestSM1(testEVP.ID);
        User testSM2 = getUserTestSM2(testSM1.ID);
        User testSR1 = getUserTestSR1(testSM2.ID);
        User testSR2 = getUserTestSR2(testSR1.ID);
        
        Account a = getAccount();
        Opportunity o = getOpportunity(testSR2.ID,a.ID);
        Ad_Period__c ap1 = getAp1();
        Ad_Period__c ap2 = getAp2();
        Ad_Period__c ap3 = getAp3();
        Program__c p = getProgram(o.Name,o.ID,ap1.ID,ap2.ID);
        Program__c p1 = getProgram(o.Name,o.ID,ap1.ID,ap2.ID);
        Product_Type_Split__c pts = new Product_Type_Split__c(Program__c=p.ID,Product_Type__c='NA',Percent__c=100);
        insert pts;
        
        List<Program_Forecast__c> pf = new List<Program_Forecast__c>();
        Program_Forecast__c pf1 = new Program_Forecast__c(Program__c = p.Id,Ad_Period__c = ap1.Id,Forecast_Amount__c = 1000);
        Program_Forecast__c pf2 = new Program_Forecast__c(Program__c = p.Id,Ad_Period__c = ap3.Id,Forecast_Amount__c = 1000,Active__c = false);
        pf.add(pf1);
        pf.add(pf2);
        insert pf;
        
        Program_FY_Amount__c pFYAmount = new Program_FY_Amount__c(Actual_Amount__c = 150000,Is_This_Year__c = true,Program__c = p.Id);
        insert pFYAmount;
        Program_Amount__c pa = new Program_Amount__c(Program__c = p.Id);
        insert pa;
        Program_SDPY_Amount__c psAmount = new Program_SDPY_Amount__c(Name = 'Test',QUARTER__C = 'Q12012',Program__c = p.ID);
        insert psAmount;
        
        Test.startTest();
        BatchEuropeDeactivatePF obj = new BatchEuropeDeactivatePF();
        BatchEuropeDeactivatePF u = new BatchEuropeDeactivatePF('LIMIT 5');
        Database.executeBatch(u, 400);
        String sch = '0 0 23 * * ?'; 
        system.schedule('BatchEuropeDeactivatePF', sch, u); 
        System.assertEquals(True, [select Active__c from Program_Forecast__c][0].Active__c);
        Test.stopTest();
    }
    
    /*
    @Name :testBatchEuropeDeleteProgramCycleAmount
    @Description : Test BatchEuropeDeleteProgramCycleAmount class.
    */
    static testMethod void testBatchEuropeDeleteProgramCycleAmount() {
        // TO DO: implement unit test
        Renewal_Settings__c settings1 = getRenewalSettingsRecord();
        User testEVP = getUserTestEVP();
        User testSM1 = getUserTestSM1(testEVP.ID);
        User testSM2 = getUserTestSM2(testSM1.ID);
        User testSR1 = getUserTestSR1(testSM2.ID);
        User testSR2 = getUserTestSR2(testSR1.ID);
        
        Account a = getAccount();
        Opportunity o = getOpportunity(testSR2.ID,a.ID);
        Ad_Period__c ap1 = getAp1();
        Ad_Period__c ap2 = getAp2();
        Program__c p = getProgram(o.Name,o.ID,ap1.ID,ap2.ID);
        Program_Cycle_Amount__c pca = new Program_Cycle_Amount__c(Name='Test',Program__c=p.ID);
        insert pca;
        Program_Cycle_FY_Amount__c pcfy = new Program_Cycle_FY_Amount__c(Name='Test',Program__c=p.ID);
        insert pcfy;
        Test.startTest();
        BatchEuropeDeleteProgramCycleAmount obj = new BatchEuropeDeleteProgramCycleAmount();
        BatchEuropeDeleteProgramCycleAmount u = new BatchEuropeDeleteProgramCycleAmount('LIMIT 5');
        Database.executeBatch(u, 400);
        String sch = '0 0 23 * * ?'; 
        system.schedule('BatchEuropeDeleteProgramCycleAmount', sch, u); 
        Test.stopTest();
    }
    
    /*
    @Name :testBatchEuropeDeleteProgramCycleSDPYAmount
    @Description : Test BatchEuropeDeleteProgramCycleSDPYAmount class.
    */
    static testMethod void testBatchEuropeDeleteProgramCycleSDPYAmount() {
        // TO DO: implement unit test
        Renewal_Settings__c settings1 = getRenewalSettingsRecord();
        User testEVP = getUserTestEVP();
        User testSM1 = getUserTestSM1(testEVP.ID);
        User testSM2 = getUserTestSM2(testSM1.ID);
        User testSR1 = getUserTestSR1(testSM2.ID);
        User testSR2 = getUserTestSR2(testSR1.ID);
        
        Account a = getAccount();
        Opportunity o = getOpportunity(testSR2.ID,a.ID);
        Ad_Period__c ap1 = getAp1();
        Ad_Period__c ap2 = getAp2();
        Program__c p = getProgram(o.Name,o.ID,ap1.ID,ap2.ID);
        Program_Cycle_SDPY_Amount__c pcSDPY = new Program_Cycle_SDPY_Amount__c(Name='Test',Program__c=p.ID);
        insert pcSDPY;
        Test.startTest();
        BatchEuropeDeleteProgramCycleSDPYAmount obj = new BatchEuropeDeleteProgramCycleSDPYAmount();
        BatchEuropeDeleteProgramCycleSDPYAmount u = new BatchEuropeDeleteProgramCycleSDPYAmount('LIMIT 5');
        Database.executeBatch(u, 400);
        String sch = '0 0 23 * * ?'; 
        system.schedule('BatchEuropeDeleteProgramCycleSDPYAmount', sch, u); 
        Test.stopTest();
    }

    /*
    @Name :testBatchEuropeProgramCycleFYAmount
    @Description : Test BatchEuropeProgramCycleFYAmount.
    */
    static testMethod void testBatchEuropeProgramCycleFYAmount() {
        // TO DO: implement unit test
        Renewal_Settings__c settings1 = getRenewalSettingsRecord();
        User testEVP = getUserTestEVP();
        User testSM1 = getUserTestSM1(testEVP.ID);
        User testSM2 = getUserTestSM2(testSM1.ID);
        User testSR1 = getUserTestSR1(testSM2.ID);
        User testSR2 = getUserTestSR2(testSR1.ID);
        
        Account a = getAccount();
        Opportunity o = getOpportunity(testSR2.ID,a.ID);
        Ad_Period__c ap1 = getAp1();
        Ad_Period__c ap2 = getAp2();
        Ad_Period__c ap3 = getAp3();
        Program__c p = getProgram(o.Name,o.ID,ap1.ID,ap2.ID);
        Product_Type_Split__c pts = new Product_Type_Split__c(Program__c=p.ID,Product_Type__c='NA',Percent__c=100);
        insert pts;
        
        List<Program_Forecast__c> pf = new List<Program_Forecast__c>();
        Program_Forecast__c pf1 = new Program_Forecast__c(Program__c = p.Id,Ad_Period__c = ap1.Id,Forecast_Amount__c = 1000);
        Program_Forecast__c pf2 = new Program_Forecast__c(Program__c = p.Id,Ad_Period__c = ap3.Id,Forecast_Amount__c = 1000,Active__c = false);
        pf.add(pf1);
        pf.add(pf2);
        insert pf;
        
        Program_Cycle_FY_Amount__c pcfy = new Program_Cycle_FY_Amount__c(Name='Test',Program__c=p.ID);
        insert pcfy;
        
        Test.startTest();
        BatchEuropeProgramCycleFYAmount obj = new BatchEuropeProgramCycleFYAmount();
        BatchEuropeProgramCycleFYAmount u = new BatchEuropeProgramCycleFYAmount(' LIMIT 5');
        Database.executeBatch(u, 400);
        String sch = '0 0 23 * * ?'; 
        system.schedule('BatchEuropeProgramCycleFYAmount', sch, u); 
        Test.stopTest();
    }

    /*
    @Name :testBatchEuropeProgramCycleSDPYAmount
    @Description : Test BatchEuropeProgramCycleSDPYAmount.
    */
    static testMethod void testBatchEuropeProgramCycleSDPYAmount() {
        // TO DO: implement unit test
        Renewal_Settings__c settings1 = getRenewalSettingsRecord();
        User testEVP = getUserTestEVP();
        User testSM1 = getUserTestSM1(testEVP.ID);
        User testSM2 = getUserTestSM2(testSM1.ID);
        User testSR1 = getUserTestSR1(testSM2.ID);
        User testSR2 = getUserTestSR2(testSR1.ID);
        
        Account a = getAccount();
        Opportunity o = getOpportunity(testSR2.ID,a.ID);
        Ad_Period__c ap1 = getAp1();
        Ad_Period__c ap2 = getAp2();
        Ad_Period__c ap3 = getAp3();
        Program__c p = getProgram(o.Name,o.ID,ap1.ID,ap2.ID);
        
        Program_Forecast__c pForecast = new Program_Forecast__c(Active__c = True,Actual_Amount__c = 1877702,Ad_Period__c = ap1.Id,
                    Program__c = p.Id,Previous_Quarter_Amount__c = 50000,Next_Quarter_Amount__c = 1300000,Forecast_Amount__c = 120000,
                    Previous_Quarter_Actual__c = 49000,Next_Quarter_Actual__c = 1350000);
        insert pForecast;
        
        Program_SDPY_Amount__c psAmount = new Program_SDPY_Amount__c(Name = 'Test',Program__c = p.ID);
        insert psAmount;
        
        Archive_Program__c aProgram = new Archive_Program__c(Name = o.Name + ' Base',Ext_ID__c = '01234567890123456',
                        Opportunity__c = o.Id,Delivery_Type__c = 'Base',Product_Type__c = 'Base Product Type1',
                        Archive_Date__c = Date.today().addYears(-1).addDays(1));
        insert aProgram;
        
        Archive_Program_Forecast__c pf1 = new Archive_Program_Forecast__c(Program__c = aProgram.Id,Ext_ID__c = '012345678901234567',
                        Ad_Period__c = ap1.Id,Forecast_Amount__c = 1000,Archive_Date__c = Date.today().addYears(-1).addDays(1),
                        Actual_Amount__c = 1000,Active__c = false);
        insert pf1;
        
        Archive_Program_Forecast__c pf2 = new Archive_Program_Forecast__c(Program__c = aProgram.Id,Ext_ID__c = '012345678901234587',
                        Forecast_Amount__c = 1000,Ad_Period__c = ap2.Id,Archive_Date__c = Date.today().addYears(-1).addDays(1),
                        Actual_Amount__c = 1000,Active__c = false);
        insert pf2;
        
        Test.startTest();
        BatchEuropeProgramCycleSDPYAmount obj = new BatchEuropeProgramCycleSDPYAmount();
        BatchEuropeProgramCycleSDPYAmount u = new BatchEuropeProgramCycleSDPYAmount('LIMIT 5');
        Database.executeBatch(u, 400);
        String sch = '0 0 23 * * ?'; 
        system.schedule('BatchEuropeProgramCycleSDPYAmount', sch, u); 
        Test.stopTest();
    }
    /*
    @Name :testBatchEuropeAssociateProgramCycleFY
    @Description : Test BatchEuropeAssociateProgramCycleFY .
    */
    static testMethod void testBatchEuropeAssociateProgramCycleFY() {
        // TO DO: implement unit test
        Renewal_Settings__c settings1 = getRenewalSettingsRecord();
        User testEVP = getUserTestEVP();
        User testSM1 = getUserTestSM1(testEVP.ID);
        User testSM2 = getUserTestSM2(testSM1.ID);
        User testSR1 = getUserTestSR1(testSM2.ID);
        User testSR2 = getUserTestSR2(testSR1.ID);
        
        Account a = getAccount();
        Opportunity o = getOpportunity(testSR2.ID,a.ID);
        Ad_Period__c ap1 = getAp1();
        Ad_Period__c ap2 = getAp2();
        Ad_Period__c ap3 = getAp3();
        Program__c p = getProgram(o.Name,o.ID,ap1.ID,ap2.ID);
        
        Program_Forecast__c pForecast = new Program_Forecast__c(Active__c = True,Actual_Amount__c = 1877702,Ad_Period__c = ap1.Id,
                    Program__c = p.Id,Previous_Quarter_Amount__c = 50000,Next_Quarter_Amount__c = 1300000,Forecast_Amount__c = 120000,
                    Previous_Quarter_Actual__c = 49000,Next_Quarter_Actual__c = 1350000);
        insert pForecast;
        
        Program_SDPY_Amount__c psAmount = new Program_SDPY_Amount__c(Name = 'Test',Program__c = p.ID);
        insert psAmount;
        
        Archive_Program__c aProgram = new Archive_Program__c(Name = o.Name + ' Base',Ext_ID__c = '01234567890123456',
                        Opportunity__c = o.Id,Delivery_Type__c = 'Base',Product_Type__c = 'Base Product Type1',
                        Archive_Date__c = Date.today().addYears(-1).addDays(1));
        insert aProgram;
        
        Archive_Program_Forecast__c pf1 = new Archive_Program_Forecast__c(Program__c = aProgram.Id,Ext_ID__c = '012345678901234567',
                        Ad_Period__c = ap1.Id,Forecast_Amount__c = 1000,Archive_Date__c = Date.today().addYears(-1).addDays(1),
                        Actual_Amount__c = 1000,Active__c = false);
        insert pf1;
        
        Archive_Program_Forecast__c pf2 = new Archive_Program_Forecast__c(Program__c = aProgram.Id,Ext_ID__c = '012345678901234587',
                        Forecast_Amount__c = 1000,Ad_Period__c = ap2.Id,Archive_Date__c = Date.today().addYears(-1).addDays(1),
                        Actual_Amount__c = 1000,Active__c = false);
        insert pf2;
        Program_Cycle_Amount__c pca = new Program_Cycle_Amount__c(Name='Test',Program__c=p.ID,Cycle__c=ap3.ID);
        insert pca;
        Program_Cycle_FY_Amount__c pcfy = new Program_Cycle_FY_Amount__c(Name='Test',Program__c=p.ID,Cycle__c=ap1.ID);
        insert pcfy;
        Program_Cycle_SDPY_Amount__c pcSDPY = new Program_Cycle_SDPY_Amount__c(Name='Test',Program__c=p.ID,Cycle__c=ap1.ID);
        insert pcSDPY;
        
        Test.startTest();
        BatchEuropeAssociateProgramCycleFY obj = new BatchEuropeAssociateProgramCycleFY();
        BatchEuropeAssociateProgramCycleFY u = new BatchEuropeAssociateProgramCycleFY('LIMIT 5');
        BatchEuropeAssociateProgramCycleSDPY u1 = new BatchEuropeAssociateProgramCycleSDPY('LIMIT 5');
        Database.executeBatch(u, 400);
        String sch = '0 0 23 * * ?'; 
        system.schedule('BatchEuropeAssociateProgramCycleFY', sch, u); 
        Test.stopTest();
    }

    /*
    @Name :testBatchEuropeAssociateAccountQuota
    @Description : Test BatchEuropeAssociateAccountQuota class.
    */
    static testMethod void testBatchEuropeAssociateAccountQuota() {
        // TO DO: implement unit test
        Renewal_Settings__c settings1 = getRenewalSettingsRecord();
        User testEVP = getUserTestEVP();
        User testSM1 = getUserTestSM1(testEVP.ID);
        User testSM2 = getUserTestSM2(testSM1.ID);
        User testSR1 = getUserTestSR1(testSM2.ID);
        User testSR2 = getUserTestSR2(testSR1.ID);
        List<RecordType> accRTList = [SELECT ID FROM RecordType Where Name = 'Manufacturing France' and SOBJECTTYPE = 'Account'];
        Account a = new Account(Name = 'Test Account');
        if(accRTList != null && accRTList.size()>0){
            a.RecordTypeId = accRTList[0].ID;
        }
        insert a;
        Opportunity o = getOpportunity(testSR2.ID,a.ID);
        
        France_Account_Quota_Input__c faqi = new France_Account_Quota_Input__c(Account__c = a.Id,Year__c = String.valueOf(Date.today().year()),
                            Delivery_Type__c = 'Base',Amount__c = 100);
        insert faqi;
        
        Ad_Period__c ap1 = new Ad_Period__c(Name = 'GM_C2_2013_Mar',Start_Date__c = Date.valueOf('2012-03-23'),
                        End_Date__c = Date.valueOf('2012-05-19'),Type__c = 'Manufacturing France');
        insert ap1;
        Ad_Period__c ap2 = new Ad_Period__c(Name = 'GM_C4_2013_Jul',Start_Date__c = Date.valueOf('2012-01-23'),
                        End_Date__c = Date.valueOf('2012-02-19'),Type__c = 'Manufacturing France');
        insert ap2;
        Ad_Period__c ap3 = new Ad_Period__c(Name = 'GM_C2_2014_Mar',Start_Date__c = Date.valueOf('2012-12-23'),
                        End_Date__c = Date.valueOf('2012-01-19'),Type__c = 'Manufacturing Germany');
        insert ap3;
        Program__c p = getProgram(o.Name,o.ID,ap1.ID,ap2.ID);
        Program_Cycle_Amount__c pca = new Program_Cycle_Amount__c(Name='Test',Program__c=p.ID,Cycle__c=ap3.ID);
        insert pca;
        
        Test.startTest();
        BatchEuropeAssociateAccountQuota obj = new BatchEuropeAssociateAccountQuota();
        BatchEuropeAssociateAccountQuota u = new BatchEuropeAssociateAccountQuota('LIMIT 5');
        Database.executeBatch(u, 400);
        String sch = '0 0 23 * * ?'; 
        system.schedule('BatchEuropeAssociateAccountQuota', sch, u); 
        Test.stopTest();
    }
    
    /*
    @Name :testBatchEuropeAssociateSalesQuota
    @Description : Test BatchEuropeAssociateSalesQuota class.
    */
    static testMethod void testBatchEuropeAssociateSalesQuota() {
        // TO DO: implement unit test
        Renewal_Settings__c settings1 = getRenewalSettingsRecord();
        User testEVP = getUserTestEVP();
        User testSM1 = getUserTestSM1(testEVP.ID);
        User testSM2 = getUserTestSM2(testSM1.ID);
        User testSR1 = getUserTestSR1(testSM2.ID);
        User testSR2 = getUserTestSR2(testSR1.ID);
        List<RecordType> accRTList = [SELECT ID FROM RecordType Where Name = 'Manufacturing France' and SOBJECTTYPE = 'Account'];
        Account a = new Account(Name = 'Test Account');
        if(accRTList != null && accRTList.size()>0){
            a.RecordTypeId = accRTList[0].ID;
        }
        insert a;
        Opportunity o = getOpportunity(testSR2.ID,a.ID);
        
        France_Account_Quota_Input__c faqi = new France_Account_Quota_Input__c(Account__c = a.Id,Year__c = String.valueOf(Date.today().year()),
                            Delivery_Type__c = 'Base',Amount__c = 100);
        insert faqi;
        
        Ad_Period__c ap1 = new Ad_Period__c(Name = 'GM_C2_2013_Mar',Start_Date__c = Date.valueOf('2012-03-23'),
                        End_Date__c = Date.valueOf('2012-05-19'),Type__c = 'Manufacturing France');
        insert ap1;
        Ad_Period__c ap2 = new Ad_Period__c(Name = 'GM_C4_2013_Jul',Start_Date__c = Date.valueOf('2012-01-23'),
                        End_Date__c = Date.valueOf('2012-02-19'),Type__c = 'Manufacturing France');
        insert ap2;
        Ad_Period__c ap3 = new Ad_Period__c(Name = 'GM_C2_2014_Mar',Start_Date__c = Date.valueOf('2012-12-23'),
                        End_Date__c = Date.valueOf('2012-01-19'),Type__c = 'Manufacturing Germany');
        insert ap3;
        Program__c p = getProgram(o.Name,o.ID,ap1.ID,ap2.ID);
        
        France_Sales_Quota_Input__c fsqi = new France_Sales_Quota_Input__c(OWNERID = testSM1.Id,AD_PERIOD__C = ap1.Id,AMOUNT__C = 100,
                            Delivery_Type__c = 'Overprint');
        insert fsqi;
        
        Program_Cycle_Amount__c pca = new Program_Cycle_Amount__c(Name='Test',Program__c=p.ID,Cycle__c=ap3.ID);
        insert pca;
        
        Test.startTest();
        BatchEuropeAssociateSalesQuota obj = new BatchEuropeAssociateSalesQuota();
        BatchEuropeAssociateSalesQuota u = new BatchEuropeAssociateSalesQuota('LIMIT 5');
        Database.executeBatch(u, 400);
        String sch = '0 0 23 * * ?'; 
        system.schedule('BatchEuropeAssociateSalesQuota', sch, u); 
        Test.stopTest();
    }
    
    /*
    @Name :testBatchFranceMonthlyOpportunitySnapshot
    @Description : Test BatchFranceMonthlyOpportunitySnapshot class.
    */
    static testMethod void testBatchFranceMonthlyOpportunitySnapshot() {
        // TO DO: implement unit test
        Renewal_Settings__c settings1 = getRenewalSettingsRecord();
        User testEVP = getUserTestEVP();
        User testSM1 = getUserTestSM1(testEVP.ID);
        User testSM2 = getUserTestSM2(testSM1.ID);
        User testSR1 = getUserTestSR1(testSM2.ID);
        User testSR2 = getUserTestSR2(testSR1.ID);
        List<RecordType> accRTList = [SELECT ID FROM RecordType Where Name = 'Manufacturing France' and SOBJECTTYPE = 'Account'];
        Account a = new Account(Name = 'Test Account');
        if(accRTList != null && accRTList.size()>0){
            a.RecordTypeId = accRTList[0].ID;
        }
        insert a;
        List<RecordType> oppRTList = [SELECT ID FROM RecordType Where Name = 'Contract France' and SOBJECTTYPE = 'Opportunity'];
        Opportunity o = new Opportunity(OwnerId = testSR2.ID,AccountId = a.ID,Name = 'Test oppty',
                        StageName = 'Presented',CloseDate = Date.today().addDays(-27),FOR_REPORTING__C=False);
        if(oppRTList != null && oppRTList.size()>0){
            o.RecordTypeId = oppRTList[0].ID;
        }
        insert o;
        Boolean allOpps = False;
        Test.startTest();
        BatchFranceMonthlyOpportunitySnapshot obj = new BatchFranceMonthlyOpportunitySnapshot();
        BatchFranceMonthlyOpportunitySnapshot u = new BatchFranceMonthlyOpportunitySnapshot('LIMIT 5');
        BatchFranceMonthlyOpportunitySnapshot ub = new BatchFranceMonthlyOpportunitySnapshot(allOpps);
        Database.executeBatch(u, 400);
        String sch = '0 0 23 * * ?'; 
        system.schedule('BatchFranceMonthlyOpportunitySnapshot', sch, u); 
        Test.stopTest();
    }
    
    /*
    @Name :testTEMP_BatchCreateSDPYSnapshot
    @Description : Test TEMP_BatchCreateSDPYSnapshot.
    */
    static testMethod void testTEMP_BatchCreateSDPYSnapshot() {
        // TO DO: implement unit test
        Renewal_Settings__c settings1 = getRenewalSettingsRecord();
        User testEVP = getUserTestEVP();
        User testSM1 = getUserTestSM1(testEVP.ID);
        User testSM2 = getUserTestSM2(testSM1.ID);
        User testSR1 = getUserTestSR1(testSM2.ID);
        User testSR2 = getUserTestSR2(testSR1.ID);
        
        Account a = getAccount();
        List<RecordType> oppRTList = [SELECT ID FROM RecordType Where Name = 'Contract France' and SOBJECTTYPE = 'Opportunity'];
        Opportunity o = new Opportunity(OwnerId = testSR2.ID,AccountId = a.ID,Name = 'Test oppty',
                        StageName = 'Presented',CloseDate = Date.today().addDays(-27),FOR_REPORTING__C=False);
        if(oppRTList != null && oppRTList.size()>0){
            o.RecordTypeId = oppRTList[0].ID;
        }
        insert o;
        Ad_Period__c ap1 = getAp1();
        Ad_Period__c ap2 = getAp2();
        Ad_Period__c ap3 = getAp3();
        Program__c p = getProgram(o.Name,o.ID,ap1.ID,ap2.ID);
        Product_Type_Split__c pts = new Product_Type_Split__c(Program__c=p.ID,Product_Type__c='NA',Percent__c=100);
        insert pts;
        
        List<Program_Forecast__c> pf = new List<Program_Forecast__c>();
        Program_Forecast__c pf1 = new Program_Forecast__c(Program__c = p.Id,Ad_Period__c = ap1.Id,Forecast_Amount__c = 1000);
        Program_Forecast__c pf2 = new Program_Forecast__c(Program__c = p.Id,Ad_Period__c = ap3.Id,Forecast_Amount__c = 1000,Active__c = false);
        pf.add(pf1);
        pf.add(pf2);
        insert pf;
        
        Program_FY_Amount__c pFYAmount = new Program_FY_Amount__c(Actual_Amount__c = 150000,Is_This_Year__c = true,Program__c = p.Id);
        insert pFYAmount;
        Program_Amount__c pa = new Program_Amount__c(Program__c = p.Id);
        insert pa;
        Program_SDPY_Amount__c psAmount = new Program_SDPY_Amount__c(Name = 'Test',QUARTER__C = 'Q12012',Program__c = p.ID);
        insert psAmount;
        Integer year = Date.Today().year();
        Integer month = Date.Today().month();
        Integer day = Date.Today().day();
        Test.startTest();
        TEMP_BatchCreateSDPYSnapshot obj = new TEMP_BatchCreateSDPYSnapshot();
        TEMP_BatchCreateSDPYSnapshot u = new TEMP_BatchCreateSDPYSnapshot(year,month,day);
        Database.executeBatch(u, 400);
        String sch = '0 0 23 * * ?'; 
        system.schedule('TEMP_BatchCreateSDPYSnapshot', sch, u);
        Test.stopTest();
    }
    
    /*
    @Name :testBatchEuropeAggregateSDPY
    @Description : Test BatchEuropeAggregateSDPY class.
    */
    static testMethod void testBatchEuropeAggregateSDPY() {
        // TO DO: implement unit test
        Renewal_Settings__c settings1 = getRenewalSettingsRecord();
        User testEVP = getUserTestEVP();
        User testSM1 = getUserTestSM1(testEVP.ID);
        User testSM2 = getUserTestSM2(testSM1.ID);
        User testSR1 = getUserTestSR1(testSM2.ID);
        User testSR2 = getUserTestSR2(testSR1.ID);
        List<RecordType> accRTList = [SELECT ID FROM RecordType Where Name = 'Manufacturing France' and SOBJECTTYPE = 'Account'];
        Account a = new Account(Name = 'Test Account');
        if(accRTList != null && accRTList.size()>0){
            a.RecordTypeId = accRTList[0].ID;
        }
        insert a;
        Opportunity o = getOpportunity(testSR2.ID,a.ID);
        
        France_Account_Quota_Input__c faqi = new France_Account_Quota_Input__c(Account__c = a.Id,Year__c = String.valueOf(Date.today().year()),
                            Delivery_Type__c = 'Base',Amount__c = 100);
        insert faqi;
        
        Ad_Period__c ap1 = new Ad_Period__c(Name = 'GM_C2_2014_Mar',Start_Date__c = Date.valueOf('2012-03-23'),
                        End_Date__c = Date.valueOf('2012-05-19'),Type__c = 'Manufacturing France');
        insert ap1;
        Ad_Period__c ap2 = new Ad_Period__c(Name = 'GM_C4_2014_Jul',Start_Date__c = Date.valueOf('2012-01-23'),
                        End_Date__c = Date.valueOf('2012-02-19'),Type__c = 'Manufacturing France');
        insert ap2;
        Ad_Period__c ap3 = new Ad_Period__c(Name = 'GM_C2_2015_Mar',Start_Date__c = Date.valueOf('2012-12-23'),
                        End_Date__c = Date.valueOf('2012-01-19'),Type__c = 'Manufacturing Germany');
        insert ap3;
        Program__c p = getProgram(o.Name,o.ID,ap1.ID,ap2.ID);
        
        France_Sales_Quota_Input__c fsqi = new France_Sales_Quota_Input__c(OWNERID = testSM1.Id,AD_PERIOD__C = ap1.Id,AMOUNT__C = 100,
                            Delivery_Type__c = 'Overprint');
        insert fsqi;
        
        Program_Cycle_Amount__c pca = new Program_Cycle_Amount__c(Name='Test',Program__c=p.ID,Cycle__c=ap3.ID);
        insert pca;
        
        Test.startTest();
        BatchEuropeAggregateSDPY obj = new BatchEuropeAggregateSDPY();
        BatchEuropeAggregateSDPY u = new BatchEuropeAggregateSDPY('LIMIT 5');
        Database.executeBatch(u, 400);
        String sch = '0 0 23 * * ?'; 
        system.schedule('BatchEuropeAggregateSDPY', sch, u); 
        Test.stopTest();
    }
    
    /*
    @Name :testBatchEuropeArchiveForecast
    @Description : Test BatchEuropeArchiveForecast class.
    */
    static testMethod void testBatchGermanyArchiveForecast() {
        // TO DO: implement unit test
        Renewal_Settings__c settings1 = getRenewalSettingsRecord();        
        User testEVP = getUserTestEVP();
        User testSM1 = getUserTestSM1(testEVP.ID);
        User testSM2 = getUserTestSM2(testSM1.ID);
        User testSR1 = getUserTestSR1(testSM2.ID);
        User testSR2 = getUserTestSR2(testSR1.ID);
        
        Account a = getAccount();
        Opportunity o = getOpportunity2(testSR2.ID,a.ID);
        Ad_Period__c ap1 = getAp1();
        Ad_Period__c ap2 = getAp2();
        Ad_Period__c ap3 = getAp3();
        Program__c p = getProgram(o.Name,o.ID,ap1.ID,ap2.ID);
        
        Program_Forecast__c pf1 = new Program_Forecast__c(Program__c = p.Id,Ad_Period__c = ap1.Id,Forecast_Amount__c = 1000,Active__c = true);
        insert pf1;
        Archive_Program__c oldArchive = new Archive_Program__c(Archive_Date__c = Date.today().addDays(-20),Opportunity__c = o.Id,Ext_ID__c = 'testEXTID54321');
        insert oldArchive;
        
        Test.startTest();
        BatchGermanyArchiveForecast batch = new BatchGermanyArchiveForecast();
        BatchGermanyArchiveForecast u = new BatchGermanyArchiveForecast('LIMIT 400');
        Database.executeBatch(u, 400);
        Test.stopTest();
    }
    
    /*
    @Name :testBatchEuropeArchiveForecast
    @Description : Test BatchEuropeArchiveForecast class.
    */
    static testMethod void testBatchEuropeArchiveForecast2() {
        // TO DO: implement unit test
        Renewal_Settings__c settings1 = getRenewalSettingsRecord();        
        User testEVP = getUserTestEVP();
        User testSM1 = getUserTestSM1(testEVP.ID);
        User testSM2 = getUserTestSM2(testSM1.ID);
        User testSR1 = getUserTestSR1(testSM2.ID);
        User testSR2 = getUserTestSR2(testSR1.ID);
        
        Account a = getAccount();
        Opportunity o = getOpportunity(testSR2.ID,a.ID);
        Ad_Period__c ap1 = getAp1();
        Ad_Period__c ap2 = getAp2();
        Ad_Period__c ap3 = getAp3();
        Program__c p = getProgram(o.Name,o.ID,ap1.ID,ap2.ID);
        
        Program_Forecast__c pf1 = new Program_Forecast__c(Program__c = p.Id,Ad_Period__c = ap1.Id,Forecast_Amount__c = 1000,Active__c = true);
        insert pf1;
        Archive_Program__c oldArchive = new Archive_Program__c(Archive_Date__c = Date.today().addDays(-20),Opportunity__c = o.Id,Ext_ID__c = 'testEXTID54321');
        insert oldArchive;
        
        Test.startTest();
        BatchEuropeArchiveForecast batch = new BatchEuropeArchiveForecast();
        BatchEuropeArchiveForecast u = new BatchEuropeArchiveForecast('LIMIT 400');
        Database.executeBatch(u, 400);
        Test.stopTest();
    }
    
    /*
    @Name :getUserTestEVP
    @Description : Insert User test data.
    */
    private static User getUserTestEVP(){
        List<Profile> profileID = [Select ID From Profile Where Name =: 'System Administrator' Limit 1];
        User testEVP = new User();
        testEVP.FirstName = 'test';
        testEVP.LastName = 'EVP';
        testEVP.Forecast_Role__c = 'coop';
        testEVP.Email = 'testEVP@catalinamarketing.com.testuser';
        testEVP.Username = 'testEVP@catalinamarketing.com.testuser';
        testEVP.Alias = 'testEVP';
        testEVP.CommunityNickname = 'testEVP';
        testEVP.TimeZoneSidKey = 'GMT';
        testEVP.LocaleSidKey = 'en_US';
        testEVP.EmailEncodingKey = 'UTF-8';
        testEVP.LanguageLocaleKey = 'en_US';
        if(profileID != null && profileID.size()>0){
            testEVP.ProfileId = profileID[0].ID;
        }
        insert testEVP;
        return testEVP;
    }
    
    /*
    @Name :getUserTestSM1
    @Description : Insert User test data.
    */
    private static User getUserTestSM1(ID testEVP){
        List<Profile> profileID = [Select ID From Profile Where Name =: 'System Administrator' Limit 1];
        User testSM1 = new User();
        testSM1.FirstName = 'test';
        testSM1.LastName = 'SM1';
        testSM1.Forecast_Role__c = 'SM1';
        testSM1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Username = 'testSM1@catalinamarketing.com.testuser';
        testSM1.Alias = 'testSM1';
        testSM1.CommunityNickname = 'testSM1';
        testSM1.TimeZoneSidKey = 'GMT';
        testSM1.LocaleSidKey = 'en_US';
        testSM1.EmailEncodingKey = 'UTF-8';
        testSM1.LanguageLocaleKey = 'en_US';
        if(profileID != null && profileID.size()>0){
            testSM1.ProfileId = profileID[0].ID;
        }
        testSM1.ManagerId = testEVP;
        insert testSM1;
        return testSM1;
    }
    
    /*
    @Name :getUserTestSM2
    @Description : Insert User test data.
    */
    private static User getUserTestSM2(ID testSM1){
        List<Profile> profileID = [Select ID From Profile Where Name =: 'System Administrator' Limit 1];
        User testSM2 = new User();
        testSM2.FirstName = 'test';
        testSM2.LastName = 'SM2';
        testSM2.Forecast_Role__c = 'SM2';
        testSM2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM2.Username = 'testSM2@catalinamarketing.com.testuser';
        testSM2.Alias = 'testSM2';
        testSM2.CommunityNickname = 'testSM2';
        testSM2.TimeZoneSidKey = 'GMT';
        testSM2.LocaleSidKey = 'en_US';
        testSM2.EmailEncodingKey = 'UTF-8';
        testSM2.LanguageLocaleKey = 'en_US';
        if(profileID != null && profileID.size()>0){
            testSM2.ProfileId = profileID[0].ID;
        }
        testSM2.ManagerId = testSM1;
        insert testSM2;
        return testSM2;
    }
    
    /*
    @Name :getUserTestSR1
    @Description : Insert User test data.
    */
    private static User getUserTestSR1(ID testSM2){
        List<Profile> profileID = [Select ID From Profile Where Name =: 'System Administrator' Limit 1];
        User testSR1 = new User();
        testSR1.FirstName = 'test';
        testSR1.LastName = 'SR1';
        testSR1.Forecast_Role__c = 'SR1';
        testSR1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR1.Username = 'testSR1@catalinamarketing.com.testuser';
        testSR1.Alias = 'testSR1';
        testSR1.CommunityNickname = 'testSR1';
        testSR1.TimeZoneSidKey = 'GMT';
        testSR1.LocaleSidKey = 'en_US';
        testSR1.EmailEncodingKey = 'UTF-8';
        testSR1.LanguageLocaleKey = 'en_US';
        if(profileID != null && profileID.size()>0){
            testSR1.ProfileId = profileID[0].ID;
        }
        testSR1.ManagerId = testSM2;
        insert testSR1;
        return testSR1;
    }
    
    /*
    @Name :getUserTestSR2
    @Description : Insert User test data.
    */
    private static User getUserTestSR2(ID testSR1){
        List<Profile> profileID = [Select ID From Profile Where Name =: 'System Administrator' Limit 1];
        User testSR2 = new User();
        testSR2.FirstName = 'test';
        testSR2.LastName = 'SR2';
        testSR2.Forecast_Role__c = 'SR2';
        testSR2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR2.Username = 'testSR2@catalinamarketing.com.testuser';
        testSR2.Alias = 'testSR2';
        testSR2.CommunityNickname = 'testSR2';
        testSR2.TimeZoneSidKey = 'GMT';
        testSR2.LocaleSidKey = 'en_US';
        testSR2.EmailEncodingKey = 'UTF-8';
        testSR2.LanguageLocaleKey = 'en_US';
        if(profileID != null && profileID.size()>0){
            testSR2.ProfileId = profileID[0].ID;
        }
        testSR2.ManagerId = testSR1;
        insert testSR2;
        return testSR2;
    }
    
    /*
    @Name :getAccount
    @Description : Insert Account test data.
    */
    private static Account getAccount(){
        List<RecordType> accountRTID = [SELECT ID FROM RecordType Where Name = 'Manufacturing Germany' and SOBJECTTYPE = 'Account'];
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
    private static Opportunity getOpportunity2(ID testSR2,ID a){
        List<RecordType> rtID = [SELECT ID FROM RecordType Where Name = 'Contract Germany' and SOBJECTTYPE = 'Opportunity'];
        Opportunity o = new Opportunity();
        o.OwnerId = testSR2;
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
    @Name :getOpportunity2
    @Description : Insert Opportunity test data.
    */
    private static Opportunity getOpportunity(ID testSR2,ID a){
        List<RecordType> rtID = [SELECT ID FROM RecordType Where Name = 'Contract France' and SOBJECTTYPE = 'Opportunity'];
        Opportunity o = new Opportunity();
        o.OwnerId = testSR2;
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
    private static Ad_Period__c getAp1(){
        Ad_Period__c ap1 = new Ad_Period__c();
        ap1.Name = 'GM_C2_2013_Mar';
        ap1.Start_Date__c = Date.valueOf('2012-03-23');
        ap1.End_Date__c = Date.valueOf('2012-05-19');
        ap1.Type__c = 'Manufacturing Germany';
        insert ap1;
        return ap1;
    }
    
    /*
    @Name :getAp2
    @Description : Insert Ad_Period__c test data.
    */
    private static Ad_Period__c getAp2(){
        Ad_Period__c ap2 = new Ad_Period__c();
        ap2.Name = 'GM_C4_2013_Jul';
        ap2.Start_Date__c = Date.valueOf('2012-01-23');
        ap2.End_Date__c = Date.valueOf('2012-02-19');
        ap2.Type__c = 'Manufacturing Germany';
        insert ap2;
        return ap2;
    }
    
    /*
    @Name :getAp3
    @Description : Insert Ad_Period__c test data.
    */
    private static Ad_Period__c getAp3(){
        Ad_Period__c ap3 = new Ad_Period__c();
        ap3.Name = 'GM_C2_2014_Mar';
        ap3.Start_Date__c = Date.valueOf('2012-12-23');
        ap3.End_Date__c = Date.valueOf('2012-01-19');
        ap3.Type__c = 'Manufacturing Germany';
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
        p.Account_Type__c = 'Manufacturing Germany';
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
}