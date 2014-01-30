/*
@Name           : TestAccountBestGuessController
@Author         : customersuccess@cloud62.com
@Date           : 5/30/2012
@Description    : Test methods for BestGuessController
*/
@isTest
public class TestAccountBestGuessController{
    static testMethod void testAccountBestGuessController(){
        //Testing variables
        Account acc = getAcc();
        Account_Best_Guess__c abg = getAccGuess(acc.Id);
        //Set up the VF page
        PageReference pref = Page.AccountBestGuess;
        Test.setCurrentPage(pref);
        AccountBestGuessController abgc = new AccountBestGuessController();
        //Validate the select option lists
        List<SelectOption> lstAccs = abgc.getAccounts();
        List<Account_Best_Guess__c> lstAbg;
        User use = [Select Id, Name FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs(use) {
            lstAbg = [SELECT Id, Account__c FROM Account_Best_Guess__c];
        }
        Set<Id> setIds = new Set<Id>();
        for(Account_Best_Guess__c abgTemp : lstAbg){
            setIds.add(abgTemp.Account__c);
        }
        System.assertEquals(lstAccs.size(), setIds.size() + 1, '# of visible accounts is wrong, should be ' + lstAccs.size());
        List<SelectOption> lstSection = abgc.getSectionTypes();
        System.assertEquals(lstSection.size(),2,'# of sections should be 2');
        abgc.gstrAccountId = acc.Id;
        List<SelectOption> lstQuarter = abgc.getQuarters();
        System.assertEquals(lstQuarter.size(), 2, '# of visible quarters is wrong, should be 2');
        abgc.resetSearch();
        //Execute the methods of the controller
        abgc.gstrSave = '';
        for(Integer i = 0; i < 50; i++){
            if(i != 49){
                abgc.gstrSave += 0 + ':';
            } else {
                abgc.gstrSave += 0;
            }
        }
        abgc.gstrGuessId = abg.Id;
        abgc.setBestGuessRecord();
        abgc.gstrSectionType = 'Manufacturer';
        abgc.setSectionType();
        abgc.saveBestGuess();
        abgc.gstrSectionType = 'Retail';
        abgc.setSectionType();
        abgc.saveBestGuess();
    }
    
    //Methods to generate test objects
    private static Account getAcc(){
        Account acc = new Account();
        acc.Name = 'TestAcc';
        insert acc;
        return acc;
    }
    
    private static Account_Best_Guess__c getAccGuess(Id accId){
        Account_Best_Guess__c abg = new Account_Best_Guess__c();
        abg.Quarter__c = '1234';
        abg.Account__c = accId;
        insert abg;
        return abg;
    }
}