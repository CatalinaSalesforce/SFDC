/*
@Name           : TestProgram
@Author         : customersuccess@cloud62.com
@Date           : 5/25/2012
@Description    : Test methods for MultiSelect and ProgramController

2012-12-20 - Anjana - Changed brands to be a single drop down(Brand__c) instead of multi picklist(Brands_List__c).
*/
@isTest
public class TestProgram{
    //Test the MultiSelect Class
    static testMethod void testMultiSelect(){
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        //Variables
        MultiSelect msel = new MultiSelect(new Set<String>{'1','2','3'},new Set<String>{'4','5','6'});
        msel.leftselected = new List<String>{'2'};
        //Assert that the sides have been populated
        System.assertEquals(msel.leftvalues.size(),3,'Left side sizes don\'t match should be 3');
        System.assertEquals(msel.rightvalues.size(),3,'Right side sizes don\'t match should be 3');
        msel.selectclick();
        //Assert that there are now 2 on the left and 4 on the right
        System.assertEquals(msel.leftvalues.size(),2,'Left side sizes don\'t match should be 2');
        System.assertEquals(msel.rightvalues.size(),4,'Right side sizes don\'t match should be 4');
        //Assert that the number of options match the size of the list
        System.assertEquals(msel.getUnSelectedValues().size(),2,'Left side sizes don\'t match should be 3');
        System.assertEquals(msel.getSelectedValues().size(),4,'Right side sizes don\'t match should be 3');
        msel.rightselected = new List<String>{'4'};
        msel.unselectclick();
        //Assert that there are now 3 on the left and 4 on the right
        System.assertEquals(msel.leftvalues.size(),3,'Left side sizes don\'t match should be 3');
        System.assertEquals(msel.rightvalues.size(),3,'Right side sizes don\'t match should be 3');
    }
    
    //Test the ProgramController Class
    static testMethod void testProgramController(){
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        //Testing variables
        RecordType rt = [SELECT Id, Name FROM RecordType WHERE Name = 'Manufacturing' AND SobjectType = 'Account' LIMIT 1];
        Account accParent = getAcc();
        accParent.Type = 'Conglomerate';
        accParent.RecordTypeId = rt.Id;
        insert accParent;
        Brand__c brand = getBrand(accParent.Id);
        insert brand;
        Division__c div = getDivision(accParent.Id);
        insert div;
        Account acc = getAcc();
        acc.ParentId = accParent.Id;
        insert acc;
        Opportunity opp = getOpp(acc.Id);
        insert opp;
        Program__c prog = getProg(opp.Id);
        //prog.Brands_List__c = brand.Name;
        prog.Brand__c = brand.Name;
        insert prog;
        generateAdPeriods(rt.Name);
        //Set up the VF page
        PageReference pref = Page.Edit_Program;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('id',prog.Id);
        ApexPages.Standardcontroller ctl = new ApexPages.Standardcontroller(prog);
        ProgramController progC = new ProgramController(ctl);
        //Assert that there are 2 ad periods in the dropdown
        System.assertEquals(2,progC.getPeriods().size(),'Wrong number of Ad Periods in dropdown, should be 2');        
        //Assert that there are 2 division in the dropdown
        System.debug('Brands are - ' + progC.getBrands());
        System.assertEquals(2,progC.getBrands().size(),'Wrong number of Brands in the dropdown, should be 2');
        //Assert that there are 2 division in the dropdown
        System.assertEquals(2,progC.getDivisions().size(),'Wrong number of Divisions in the dropdown, should be 2');
        String strBefore = progC.progIn.Name;
        progC.progIn.Name = 'NameChange';
        progC.save();
        //Assert that the name changed
        Program__c progAssert = [SELECT Id, Name FROM Program__c WHERE Id = :prog.Id];
        System.assertNotEquals(progAssert.Name,strBefore,'The names should not match');
        //This is to test the error catching of the Save function
        progC.progIn.RecordTypeId = rt.Id;
        //progC.mBrandSelect.rightvalues = new Set<String>();
        progC.strBrand = '--None--';
        progC.strDivision = '--None--';
        progC.strStartCycle = '--None--';
        progC.strEndCycle = '--None--';
        progC.save();
    }
    
    //Methods to generate test objects
    private static void generateAdPeriods(String strType){
        List<Ad_Period__c> lst = new List<Ad_Period__c>();
        Ad_Period__c ad1 = new Ad_Period__c();
        ad1.Start_Date__c = Date.Today();
        ad1.End_Date__c = Date.Today().addMonths(1);
        ad1.Type__c = strType;
        lst.add(ad1);
        Ad_Period__c ad2 = new Ad_Period__c();
        ad2.Start_Date__c = Date.Today().addMonths(1);
        ad2.End_Date__c = Date.Today().addMonths(2);
        ad2.Type__c = strType;
        lst.add(ad2);
        insert lst;
    }
    
    private static Account getAcc(){
        Account acc = new Account();
        acc.Name = 'TestingAccount';
        return acc;
    }
    
    private static Opportunity getOpp(Id accId){
        Opportunity opp = new Opportunity();
        opp.AccountId = accId;
        opp.StageName = 'Idea';
        opp.CloseDate = Date.Today();
        opp.Name = 'TestingOpportunity';
        return opp;
    }
    
    private static Program__c getProg(Id oppId){
        Program__c prog = new Program__c();
        prog.Opportunity__c = oppId;
        return prog;
    }
    
    private static Brand__c getBrand(Id accId){
        Brand__c b = new Brand__c();
        b.Account__c = accId;
        b.Name = 'TestingBrand';
        return b;
    }
    
    private static Division__c getDivision(Id accId){
        Division__c d = new Division__c();
        d.Account__c = accId;
        d.Name = 'TestingDivision';
        return d;
    }
}