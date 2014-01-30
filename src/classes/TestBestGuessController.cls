/*
@Name           : TestBestGuessController
@Author         : customersuccess@cloud62.com
@Date           : 5/23/2012
@Description    : Test methods for BestGuessController
*/
@isTest
public class TestBestGuessController{
    static testMethod void testBestGuessController(){
        //Testing variables
        List<Manager_Best_Guess__c> man = getManGuess();
        List<Sales_Rep_Best_Guess__c> rep = getRepGuess();
        List<Historical_Manager_Best_Guess__c> histMan = getHistManGuess();
        List<Historical_Sales_Rep_Best_Guess__c> histRep = getHistRepGuess();
        
        Account a = getAccount('Manufacturing');
        Account retailAcc = getAccount('Retail');
        Account childAccount = getChildAccount(a.Id);
        Client_Rating_Setting_Obj__c crs = new Client_Rating_Setting_Obj__c();
        crs.Account__c = a.Id;
        insert crs;
        
        HBGBatchInterval__c hbgSetting = new HBGBatchInterval__c();
        hbgSetting.Name = 'LastDate';
        hbgSetting.Last_Run_Date__c = date.newinstance(2013, 4, 9);
        hbgSetting.SR_Last_Run_Date__c = date.newinstance(2013, 4, 9);
        insert hbgSetting;
        //Set up the VF page
        PageReference pref = Page.BestGuess;
        Test.setCurrentPage(pref);
        BestGuessController bgc = new BestGuessController();
        bgc.gstrGuessId = String.valueOf(System.Today().year());
        bgc.gstrUserId=UserINFO.getUserID();
        bgc.setBestGuessRecord();
        //Validate the select option lists
        List<SelectOption> lstUsers = bgc.getUsers();
        List<Manager_Best_Guess__c> lstMan;
        List<Sales_Rep_Best_Guess__c> lstRep;
        User use = [Select Id, Name FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs(use) {
            lstMan = [SELECT Id, OwnerId FROM Manager_Best_Guess__c];
            lstRep = [SELECT Id, OwnerId FROM Sales_Rep_Best_Guess__c];
        }
        
        Set<Id> setIds = new Set<Id>();
        for(Manager_Best_Guess__c mbg : lstMan){
            setIds.add(mbg.OwnerId);
        }
        for(Sales_Rep_Best_Guess__c srbg : lstRep){
            setIds.add(srbg.OwnerId);
        }
        Test.startTest();
        bgc.isManBestGuess = true;
        System.assertEquals(lstUsers.size(), setIds.size() + 1, '# of visible users is wrong, should be ' + lstUsers.size());
        bgc.gstrUserId = UserInfo.getUserId();
        bgc.getYears();
        bgc.getShowTableMan();
        bgc.getShowTableRetail();
        bgc.getRenderSelect();
        bgc.getBestGuessTypes();
        bgc.refresh();
        bgc.openBestGuess();
        bgc.getConglomerateAccounts();
        bgc.conglomerateAccountBestGuess();
        bgc.getTopConglomerates();
        bgc.getChildAccounts();
        bgc.getConglomerateAccount();
        bgc.congAccount = a.Id;
        bgc.getConglomerateAccount();
        bgc.childAccount = childAccount.Id;
        bgc.getConglomerateAccount();
        bgc.getChildAccounts();
        List<SelectOption> lstSection = bgc.getSectionTypes();
        //System.assertEquals(lstSection.size(),4,'Should be 4 section types');
        List<SelectOption> lstTypes = bgc.getTypes();
        System.assertEquals(lstTypes.size(),2,'Should be 2 types');
        List<SelectOption> lstDeliveryTypes =  bgc.getDeliveryTypes();
        System.assertEquals(lstDeliveryTypes.size(),5,'Should be 5 types');
        //Execute the methods of the controller
        bgc.gstrSave = '';
        for(Integer i = 0; i < 50; i++){
            if(i != 49){
                bgc.gstrSave += 0 + ':';
            } else {
                bgc.gstrSave += 0;
            }
        }
        bgc.gstrSectionType = 'Manufacturer';
        bgc.getAccountsList();
        bgc.selectedAccId = a.ID;
        bgc.isManBestGuess = true;
        bgc.gstrType = 'Manager';
        bgc.setIsManBestGuess();
        bgc.setType();
        bgc.setSectionType();
        bgc.setIsManBestGuess();
        bgc.setBestGuessRecord();
        bgc.isGridManufacturer = false;
        bgc.saveBestGuess();
        //bgc.getCommentField();
        //bgc.getManCommentField();
        bgc.gstrSectionType = 'Retail';
        bgc.getAccountsList();
        bgc.selectedAccId = retailAcc.ID;
        bgc.saveBestGuess();        
        bgc.gstrUserId = UserInfo.getUserId();
        bgc.getTeam();
        bgc.setTypeTeam();
        bgc.setDeliveryTypes();
        bgc.isManBestGuess = false;
        bgc.getTeam();
        bgc.setTypeTeam();
        bgc.setDeliveryTypes();
        bgc.deliveryType = 'Base';
        bgc.setDeliveryTypes();
        bgc.deliveryType = 'Digital';
        bgc.setDeliveryTypes();
        bgc.deliveryType = 'Audience Network';
        bgc.setDeliveryTypes();
        bgc.deliveryType = 'Mobile';
        bgc.setDeliveryTypes(); 
               
        bgc.gstrSectionType = 'Manufacturer';
        bgc.gstrType = 'Sales Rep';
        bgc.isManBestGuess = false;
        bgc.setType();
        bgc.setSectionType();
        bgc.setIsManBestGuess();
        bgc.getDeliveryChannel();
        bgc.setBestGuessRecord();
        bgc.selDeliveryChannel='Base';
        bgc.searchRevenue();
        bgc.saveBestGuess();
        bgc.getTeam();
        bgc.gstrTeamMemberId = UserInfo.getUserId();
        bgc.setTypeTeam();
        bgc.setDeliveryTypes();
        
        bgc.gstrSectionType = 'Retail';
        bgc.saveBestGuess();
        //bgc.getCommentField();
        //bgc.getManCommentField();
        bgc.setTypeTeam();
        bgc.setDeliveryTypes();
        bgc.deliveryType = 'Base';
        bgc.setDeliveryTypes();
        bgc.deliveryType = 'Digital';
        bgc.setDeliveryTypes();
        bgc.deliveryType = 'Audience Network';
        bgc.setDeliveryTypes();
        bgc.deliveryType = 'Mobile';
        bgc.setDeliveryTypes();        
        bgc.resetSearch();
        bgc.childAccount = childAccount.ID;
        bgc.openBestGuess();
        bgc.childAccount = 'All';
        bgc.congAccount = a.ID;
        bgc.openBestGuess();
        Test.stopTest();
    }
    
    static testMethod void testNoHistBestGuessController(){
        //Testing variables
        List<Manager_Best_Guess__c> man = getManGuess();
        List<Sales_Rep_Best_Guess__c> rep = getRepGuess();
        List<Historical_Manager_Best_Guess__c> histMan = null;
        List<Historical_Sales_Rep_Best_Guess__c> histRep = null;
        
        HBGBatchInterval__c hbgSetting = new HBGBatchInterval__c();
        hbgSetting.Name = 'LastDate';
        hbgSetting.Last_Run_Date__c = date.newinstance(2013, 4, 9);
        hbgSetting.SR_Last_Run_Date__c = date.newinstance(2013, 4, 9);
        insert hbgSetting;
        //Set up the VF page
        PageReference pref = Page.BestGuess;
        Test.setCurrentPage(pref);
        BestGuessController bgc = new BestGuessController();  
        Test.startTest();     
        bgc.isManBestGuess = true;
        bgc.gstrUserId = UserInfo.getUserId();
        //Execute the methods of the controller
        bgc.gstrSave = '';
        for(Integer i = 0; i < 50; i++){
            if(i != 49){
                bgc.gstrSave += 0 + ':';
            } else {
                bgc.gstrSave += 0;
            }
        }
        bgc.gstrSectionType = 'Manufacturer';
        bgc.isManBestGuess = true;
        bgc.gstrType = 'Manager';
        bgc.setIsManBestGuess();
        bgc.setType();
        bgc.setSectionType();
        bgc.setIsManBestGuess();
        bgc.setBestGuessRecord();
        bgc.saveBestGuess();
        
        bgc.gstrSectionType = 'Manufacturer';
        bgc.gstrType = 'Sales Rep';
        bgc.isManBestGuess = false;
        bgc.setType();
        bgc.setSectionType();
        bgc.setIsManBestGuess();
        bgc.setBestGuessRecord();
        bgc.saveBestGuess();
        bgc.getTeam();
        bgc.gstrTeamMemberId = UserInfo.getUserId();
        bgc.setTypeTeam();
        
        bgc.gstrSectionType = 'Retail';
        bgc.saveBestGuess();
        bgc.isGridManufacturer = false;
        bgc.selDeliveryChannel='Base';
        bgc.searchRevenue();
        bgc.saveBestGuess();
        bgc.resetSearch();
        
        bgc.gstrGuessId = String.valueOf(System.Today().year()-1);
        bgc.gstrSectionType = 'Manufacturer';
        bgc.isManBestGuess = true;
        bgc.selDeliveryChannel='Base';
        bgc.searchRevenue();
        bgc.gstrType = 'Manager';
        bgc.setIsManBestGuess();
        bgc.setType();
        bgc.setSectionType();
        bgc.setIsManBestGuess();
        bgc.gstrSectionType = 'Manufacturer';
        bgc.gstrType = 'Sales Rep';
        bgc.isManBestGuess = false;
        bgc.setType();
        bgc.setSectionType();
        bgc.setIsManBestGuess();
        Test.stopTest();
    }
    
    static testMethod void testBestGuessController2(){
        //Testing variables
        List<Manager_Best_Guess__c> man = getManGuess();
        HBGBatchInterval__c hbgSetting = new HBGBatchInterval__c();
        hbgSetting.Name = 'LastDate';
        hbgSetting.Last_Run_Date__c = date.newinstance(2013, 4, 9);
        hbgSetting.SR_Last_Run_Date__c = date.newinstance(2013, 4, 9);
        insert hbgSetting;
        //Set up the VF page
        PageReference pref = Page.BestGuess;
        Test.setCurrentPage(pref);
        BestGuessController bgc = new BestGuessController();  
        Test.startTest();     
        bgc.isManBestGuess = true;
        bgc.gstrUserId = UserInfo.getUserId();
        bgc.gstrSectionType = 'Manufacturer';
        bgc.isManBestGuess = true;
        bgc.gstrType = 'Manager';
        bgc.setIsManBestGuess();
        bgc.setType();
        bgc.setSectionType();
        bgc.setIsManBestGuess();
        bgc.setBestGuessRecord();
        bgc.setDeliveryTypes();
        //Execute the methods of the controller
        bgc.gstrSave = '';
        for(Integer i = 0; i < 50; i++){
            if(i != 49){
                bgc.gstrSave += 0 + ':';
            } else {
                bgc.gstrSave += 0;
            }
        }
        Account mngAcc = getAccount('Manufacturing');
        Account mngRetailAcc = getAccount('Retail');
        Account salesRepAcc = getAccount('Manufacturing');
        Account salesRepRetailAcc = getAccount('Retail');
        bgc.selectedAccId=mngAcc.ID;
        bgc.isGridManBestGuess=TRUE;
        bgc.isGridManufacturer=TRUE;
        bgc.copyAccBGS();
        bgc.copyAccBGS();
        bgc.isGridManufacturer=False;
        bgc.selDeliveryChannel='Base';
        bgc.searchRevenue();
        bgc.selectedAccId=mngRetailAcc.ID;
        bgc.copyAccBGS();
        bgc.copyAccBGS();
        bgc.selectedAccId=salesRepAcc.ID;
        bgc.isGridManBestGuess=False;
        bgc.isGridManufacturer=TRUE;
        bgc.copyAccBGS();
        bgc.copyAccBGS();
        bgc.isGridManufacturer=False;
        bgc.selectedAccId=salesRepRetailAcc.ID;
        bgc.copyAccBGS();
        bgc.copyAccBGS();
        Test.stopTest();
    }
    
    //Methods to generate test objects
    private static List<Manager_Best_Guess__c> getManGuess(){
        List<Manager_Best_Guess__c> manList = new List<Manager_Best_Guess__c>();
        Manager_Best_Guess__c man = new Manager_Best_Guess__c();
        man.Quarter__c = 'Q1'+String.valueOf(System.Today().year());
        man.Team_Manufacturing_Base_Best_Guess__c = 10;
        man.Team_Manufacturing_Digital_Best_Guess__c = 10;
        man.Team_Manufacturing_Audience_Best_Guess__c = 10;
        man.Team_Manufacturing_Mobile_Best_Guess__c = 10;
        man.Team_Retail_Base_Best_Guess__c = 10;
        man.Team_Retail_Digital_Best_Guess__c = 10;
        man.Team_Retail_Audience_Best_Guess__c = 10;
        man.Team_Retail_Mobile_Best_Guess__c = 10;
        man.Override_Team_Manu_Base_Best_Guess__c  = 20;
        manList.add(man);
        Manager_Best_Guess__c man1 = new Manager_Best_Guess__c();
        man1.Quarter__c = 'Q2'+String.valueOf(System.Today().year());
        man1.Team_Manufacturing_Base_Best_Guess__c = 10;
        man1.Team_Manufacturing_Digital_Best_Guess__c = 10;
        man1.Team_Manufacturing_Audience_Best_Guess__c = 10;
        man1.Team_Manufacturing_Mobile_Best_Guess__c = 10;
        man1.Team_Retail_Base_Best_Guess__c = 10;
        man1.Team_Retail_Digital_Best_Guess__c = 10;
        man1.Team_Retail_Audience_Best_Guess__c = 10;
        man1.Team_Retail_Mobile_Best_Guess__c = 10;
        man1.Override_Team_Manu_Base_Best_Guess__c  = 20;
        manList.add(man1);
        Manager_Best_Guess__c man2 = new Manager_Best_Guess__c();
        man2.Quarter__c = 'Q3'+String.valueOf(System.Today().year());
        man2.Team_Manufacturing_Base_Best_Guess__c = 10;
        man2.Team_Manufacturing_Digital_Best_Guess__c = 10;
        man2.Team_Manufacturing_Audience_Best_Guess__c = 10;
        man2.Team_Manufacturing_Mobile_Best_Guess__c = 10;
        man2.Team_Retail_Base_Best_Guess__c = 10;
        man2.Team_Retail_Digital_Best_Guess__c = 10;
        man2.Team_Retail_Audience_Best_Guess__c = 10;
        man2.Team_Retail_Mobile_Best_Guess__c = 10;
        man2.Override_Team_Manu_Base_Best_Guess__c  = 20;
        manList.add(man2);
        Manager_Best_Guess__c man3 = new Manager_Best_Guess__c();
        man3.Quarter__c = 'Q4'+String.valueOf(System.Today().year());
        man3.Team_Manufacturing_Base_Best_Guess__c = 10;
        man3.Team_Manufacturing_Digital_Best_Guess__c = 10;
        man3.Team_Manufacturing_Audience_Best_Guess__c = 10;
        man3.Team_Manufacturing_Mobile_Best_Guess__c = 10;
        man3.Team_Retail_Base_Best_Guess__c = 10;
        man3.Team_Retail_Digital_Best_Guess__c = 10;
        man3.Team_Retail_Audience_Best_Guess__c = 10;
        man3.Team_Retail_Mobile_Best_Guess__c = 10;
        man3.Override_Team_Manu_Base_Best_Guess__c  = 20;
        manList.add(man3);
        insert manList;
        return manList;
    }
    
    private static List<Sales_Rep_Best_Guess__c> getRepGuess(){
        List<Sales_Rep_Best_Guess__c> repList = new List<Sales_Rep_Best_Guess__c>();
        Sales_Rep_Best_Guess__c rep = new Sales_Rep_Best_Guess__c();
        rep.Quarter__c = 'Q1'+String.valueOf(System.Today().year());
        rep.Manufacturing_Base_Best_Guess__c = 10;
        rep.Manufacturing_Digital_Best_Guess__c = 10;
        rep.Manufacturing_Audience_Best_Guess__c = 10;
        rep.Manufacturing_Mobile_Best_Guess__c = 10;
        rep.Retail_Base_Best_Guess__c = 10;
        rep.Retail_Digital_Best_Guess__c = 10;
        rep.Retail_Audience_Best_Guess__c = 10;
        rep.Retail_Mobile_Best_Guess__c = 10;
        rep.Actual_Amount__c = 20;
        rep.Forecast_Contract__c = 20;
        rep.ownerId = UserInfo.getUserId();
        repList.add(rep);
        Sales_Rep_Best_Guess__c rep1 = new Sales_Rep_Best_Guess__c();
        rep1.Quarter__c = 'Q2'+String.valueOf(System.Today().year());
        rep1.Manufacturing_Base_Best_Guess__c = 10;
        rep1.Manufacturing_Digital_Best_Guess__c = 10;
        rep1.Manufacturing_Audience_Best_Guess__c = 10;
        rep1.Manufacturing_Mobile_Best_Guess__c = 10;
        rep1.Retail_Base_Best_Guess__c = 10;
        rep1.Retail_Digital_Best_Guess__c = 10;
        rep1.Retail_Audience_Best_Guess__c = 10;
        rep1.Retail_Mobile_Best_Guess__c = 10;
        rep1.Actual_Amount__c = 20;
        rep1.Forecast_Contract__c = 20;
        rep1.ownerId = UserInfo.getUserId();
        repList.add(rep1);
        Sales_Rep_Best_Guess__c rep2 = new Sales_Rep_Best_Guess__c();
        rep2.Quarter__c = 'Q3'+String.valueOf(System.Today().year());
        rep2.Manufacturing_Base_Best_Guess__c = 10;
        rep2.Manufacturing_Digital_Best_Guess__c = 10;
        rep2.Manufacturing_Audience_Best_Guess__c = 10;
        rep2.Manufacturing_Mobile_Best_Guess__c = 10;
        rep2.Retail_Base_Best_Guess__c = 10;
        rep2.Retail_Digital_Best_Guess__c = 10;
        rep2.Retail_Audience_Best_Guess__c = 10;
        rep2.Retail_Mobile_Best_Guess__c = 10;
        rep2.Actual_Amount__c = 20;
        rep2.Forecast_Contract__c = 20;
        rep2.ownerId = UserInfo.getUserId();
        repList.add(rep2);
        Sales_Rep_Best_Guess__c rep3 = new Sales_Rep_Best_Guess__c();
        rep3.Quarter__c = 'Q4'+String.valueOf(System.Today().year());
        rep3.Manufacturing_Base_Best_Guess__c = 10;
        rep3.Manufacturing_Digital_Best_Guess__c = 10;
        rep3.Manufacturing_Audience_Best_Guess__c = 10;
        rep3.Manufacturing_Mobile_Best_Guess__c = 10;
        rep3.Retail_Base_Best_Guess__c = 10;
        rep3.Retail_Digital_Best_Guess__c = 10;
        rep3.Retail_Audience_Best_Guess__c = 10;
        rep3.Retail_Mobile_Best_Guess__c = 10;
        rep3.Actual_Amount__c = 20;
        rep3.Forecast_Contract__c = 20;
        rep3.ownerId = UserInfo.getUserId();
        repList.add(rep3);
        insert repList;
        return repList;
    }
    private static List<Historical_Manager_Best_Guess__c> getHistManGuess(){
        List<Historical_Manager_Best_Guess__c> manList = new List<Historical_Manager_Best_Guess__c>();
        Historical_Manager_Best_Guess__c man = new Historical_Manager_Best_Guess__c();
        man.Quarter__c = 'Q1'+String.valueOf(System.Today().year());
        man.Archive_Date__c = Date.parse('09/4/2013');
        man.Team_Manufacturing_Base_Best_Guess__c = 10;
        man.Team_Manufacturing_Digital_Best_Guess__c = 10;
        man.Team_Manufacturing_Audience_Best_Guess__c = 10;
        man.Team_Manufacturing_Mobile_Best_Guess__c = 10;
        man.Team_Retail_Base_Best_Guess__c = 10;
        man.Team_Retail_Digital_Best_Guess__c = 10;
        man.Team_Retail_Audience_Best_Guess__c = 10;
        man.Team_Retail_Mobile_Best_Guess__c = 10;
        man.Total_BG__c = 80;
        man.Total_BG_Override__c = 240;
        man.Team_Booked_Actual__c = 40;
        man.Override_Team_Manu_Base_Best_Guess__c = 20;
        man.Override_Team_Retail_Base_Best_Guess__c = 20;
        man.Override_Team_Manu_Digital_Best_Guess__c = 10;
        man.Override_Team_Retail_Digital_Best_Guess__c =20;
        man.Override_Team_Manu_Audience_Best_Guess__c = 20;
        man.Override_Team_Retail_Audience_Best_Guess__c = 20;
        man.Override_Team_Manu_Mobile_Best_Guess__c=10;
        man.Override_Team_Retail_Mobile_Best_Guess__c = 20;
        manList.add(man);
        Historical_Manager_Best_Guess__c man1 = new Historical_Manager_Best_Guess__c();
        man1.Quarter__c = 'Q2'+String.valueOf(System.Today().year());
        man1.Archive_Date__c = Date.parse('09/4/2013');
        man1.Team_Manufacturing_Base_Best_Guess__c = 10;
        man1.Team_Manufacturing_Digital_Best_Guess__c = 10;
        man1.Team_Manufacturing_Audience_Best_Guess__c = 10;
        man1.Team_Manufacturing_Mobile_Best_Guess__c = 10;
        man1.Team_Retail_Base_Best_Guess__c = 10;
        man1.Team_Retail_Digital_Best_Guess__c = 10;
        man1.Team_Retail_Audience_Best_Guess__c = 10;
        man1.Team_Retail_Mobile_Best_Guess__c = 10;
        man1.Total_BG__c = 80;
        man1.Total_BG_Override__c = 240;
        man1.Team_Booked_Actual__c = 40;
        man1.Override_Team_Manu_Base_Best_Guess__c = 20;
        man1.Override_Team_Retail_Base_Best_Guess__c = 20;
        man1.Override_Team_Manu_Digital_Best_Guess__c = 10;
        man1.Override_Team_Retail_Digital_Best_Guess__c =20;
        man1.Override_Team_Manu_Audience_Best_Guess__c = 20;
        man1.Override_Team_Retail_Audience_Best_Guess__c = 20;
        man1.Override_Team_Manu_Mobile_Best_Guess__c=10;
        man1.Override_Team_Retail_Mobile_Best_Guess__c = 20;
        manList.add(man1);
        Historical_Manager_Best_Guess__c man2 = new Historical_Manager_Best_Guess__c();
        man2.Quarter__c = 'Q3'+String.valueOf(System.Today().year());
        man2.Archive_Date__c = Date.parse('09/4/2013');
        man2.Team_Manufacturing_Base_Best_Guess__c = 10;
        man2.Team_Manufacturing_Digital_Best_Guess__c = 10;
        man2.Team_Manufacturing_Audience_Best_Guess__c = 10;
        man2.Team_Manufacturing_Mobile_Best_Guess__c = 10;
        man2.Team_Retail_Base_Best_Guess__c = 10;
        man2.Team_Retail_Digital_Best_Guess__c = 10;
        man2.Team_Retail_Audience_Best_Guess__c = 10;
        man2.Team_Retail_Mobile_Best_Guess__c = 10;
        man2.Total_BG__c = 80;
        man2.Total_BG_Override__c = 240;
        man2.Team_Booked_Actual__c = 40;
        man2.Override_Team_Manu_Base_Best_Guess__c = 20;
        man2.Override_Team_Retail_Base_Best_Guess__c = 20;
        man2.Override_Team_Manu_Digital_Best_Guess__c = 10;
        man2.Override_Team_Retail_Digital_Best_Guess__c =20;
        man2.Override_Team_Manu_Audience_Best_Guess__c = 20;
        man2.Override_Team_Retail_Audience_Best_Guess__c = 20;
        man2.Override_Team_Manu_Mobile_Best_Guess__c=10;
        man2.Override_Team_Retail_Mobile_Best_Guess__c = 20;
        manList.add(man2);
        Historical_Manager_Best_Guess__c man3 = new Historical_Manager_Best_Guess__c();
        man3.Quarter__c = 'Q4'+String.valueOf(System.Today().year());
        man3.Archive_Date__c = Date.parse('09/4/2013');
        man3.Team_Manufacturing_Base_Best_Guess__c = 10;
        man3.Team_Manufacturing_Digital_Best_Guess__c = 10;
        man3.Team_Manufacturing_Audience_Best_Guess__c = 10;
        man3.Team_Manufacturing_Mobile_Best_Guess__c = 10;
        man3.Team_Retail_Base_Best_Guess__c = 10;
        man3.Team_Retail_Digital_Best_Guess__c = 10;
        man3.Team_Retail_Audience_Best_Guess__c = 10;
        man3.Team_Retail_Mobile_Best_Guess__c = 10;
        man3.Total_BG__c = 80;
        man3.Total_BG_Override__c = 240;
        man3.Team_Booked_Actual__c = 40;
        man3.Override_Team_Manu_Base_Best_Guess__c = 20;
        man3.Override_Team_Retail_Base_Best_Guess__c = 20;
        man3.Override_Team_Manu_Digital_Best_Guess__c = 10;
        man3.Override_Team_Retail_Digital_Best_Guess__c =20;
        man3.Override_Team_Manu_Audience_Best_Guess__c = 20;
        man3.Override_Team_Retail_Audience_Best_Guess__c = 20;
        man3.Override_Team_Manu_Mobile_Best_Guess__c=10;
        man3.Override_Team_Retail_Mobile_Best_Guess__c = 20;
        manList.add(man3);
        insert manList;
        return manList;
    }
    private static List<Historical_Sales_Rep_Best_Guess__c> getHistRepGuess(){
        List<Historical_Sales_Rep_Best_Guess__c> repList = new List<Historical_Sales_Rep_Best_Guess__c>();
        Historical_Sales_Rep_Best_Guess__c rep = new Historical_Sales_Rep_Best_Guess__c();
        rep.Quarter__c = 'Q1'+String.valueOf(System.Today().year());
        rep.Archive_Date__c = Date.parse('09/4/2013');
        rep.Manufacturing_Base_Best_Guess__c = 10;
        rep.Manufacturing_Digital_Best_Guess__c = 10;
        rep.Manufacturing_Audience_Best_Guess__c = 10;
        rep.Manufacturing_Mobile_Best_Guess__c = 10;
        rep.Retail_Base_Best_Guess__c = 10;
        rep.Retail_Digital_Best_Guess__c = 10;
        rep.Retail_Audience_Best_Guess__c = 10;
        rep.Retail_Mobile_Best_Guess__c = 10;
        rep.Total_BG__c = 80;
        rep.Booked_Actual__c = 40;
        repList.add(rep);
        Historical_Sales_Rep_Best_Guess__c rep1 = new Historical_Sales_Rep_Best_Guess__c();
        rep1.Quarter__c = 'Q2'+String.valueOf(System.Today().year());
        rep1.Archive_Date__c = Date.parse('09/4/2013');
        rep1.Manufacturing_Base_Best_Guess__c = 10;
        rep1.Manufacturing_Digital_Best_Guess__c = 10;
        rep1.Manufacturing_Audience_Best_Guess__c = 10;
        rep1.Manufacturing_Mobile_Best_Guess__c = 10;
        rep1.Retail_Base_Best_Guess__c = 10;
        rep1.Retail_Digital_Best_Guess__c = 10;
        rep1.Retail_Audience_Best_Guess__c = 10;
        rep1.Retail_Mobile_Best_Guess__c = 10;
        rep1.Total_BG__c = 80;
        rep1.Booked_Actual__c = 40;
        repList.add(rep1);
        Historical_Sales_Rep_Best_Guess__c rep2 = new Historical_Sales_Rep_Best_Guess__c();
        rep2.Quarter__c = 'Q3'+String.valueOf(System.Today().year());
        rep2.Archive_Date__c = Date.parse('09/4/2013');
        rep2.Manufacturing_Base_Best_Guess__c = 10;
        rep2.Manufacturing_Digital_Best_Guess__c = 10;
        rep2.Manufacturing_Audience_Best_Guess__c = 10;
        rep2.Manufacturing_Mobile_Best_Guess__c = 10;
        rep2.Retail_Base_Best_Guess__c = 10;
        rep2.Retail_Digital_Best_Guess__c = 10;
        rep2.Retail_Audience_Best_Guess__c = 10;
        rep2.Retail_Mobile_Best_Guess__c = 10;
        rep2.Total_BG__c = 80;
        rep2.Booked_Actual__c = 40;
        repList.add(rep2);
        Historical_Sales_Rep_Best_Guess__c rep3 = new Historical_Sales_Rep_Best_Guess__c();
        rep3.Quarter__c = 'Q4'+String.valueOf(System.Today().year());
        rep3.Archive_Date__c = Date.parse('09/4/2013');
        rep3.Manufacturing_Base_Best_Guess__c = 10;
        rep3.Manufacturing_Digital_Best_Guess__c = 10;
        rep3.Manufacturing_Audience_Best_Guess__c = 10;
        rep3.Manufacturing_Mobile_Best_Guess__c = 10;
        rep3.Retail_Base_Best_Guess__c = 10;
        rep3.Retail_Digital_Best_Guess__c = 10;
        rep3.Retail_Audience_Best_Guess__c = 10;
        rep3.Retail_Mobile_Best_Guess__c = 10;
        rep3.Total_BG__c = 80;
        rep3.Booked_Actual__c = 40;
        repList.add(rep3);
        insert repList;
        return repList;
    }
    
    /*
    @Name :getAccount
    @Description : prepare the test data for Account record.
    */
    private static Account getAccount(String rType){
        String rtID = [SELECT ID FROM RecordType Where Name =:rType and SOBJECTTYPE = 'Account'][0].Id;
        
        Account acc = new Account(Name = 'TestCase', Type = 'Conglomerate',RecordTypeID = rtID, 
                    OwnerId=UserInfo.getUserId(),Status__c='Platinum');
        insert acc;
        return acc;
    }
    
    /*
    @Name :getChildAccount
    @Description : prepare the test data for Child Account record.
    */
    private static Account getChildAccount(Id a){
        String rtID = [SELECT ID FROM RecordType Where Name = 'Manufacturing' and SOBJECTTYPE = 'Account'][0].Id;
        
        Account acc = new Account(Name='TestCase',Type='Other',PARENTID=a,RecordTypeID = rtID,
                        OwnerId=UserInfo.getUserId());
        insert acc;
        return acc;
    }
}