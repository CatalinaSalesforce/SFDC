/*
@Name            : TestBatchUpdateBestGuessCls
@Author          : customersuccess@cloud62.com
@Date            : September 18th, 2013
@Description     : Test the BatchUpdateManagerBestGuessBooked & BatchUpdateBestGuessBooked
*/
@isTest
private class TestBatchUpdateBestGuessCls{
    
    /*
    @Name :testBatchUpdateManagerBestGuessBooked
    @Description : test functionality for BatchUpdateManagerBestGuessBooked Class.
    */
    static testMethod void testBatchUpdateManagerBestGuessBooked() {
        //Testing variables
        List<Manager_Best_Guess__c> man = getManGuess();
        Test.startTest();
        BatchUpdateManagerBestGuessBooked obj = new BatchUpdateManagerBestGuessBooked();
        BatchUpdateManagerBestGuessBooked u = new BatchUpdateManagerBestGuessBooked('LIMIT 5');
        Database.executeBatch(u, 400);
        String sch = '0 0 23 * * ?'; 
        system.schedule('BatchUpdateManagerBestGuessBooked', sch, u); 
        Test.stopTest();
    }
    
    /*
    @Name :testBatchUpdateBestGuessBooked
    @Description : test functionality for BatchUpdateBestGuessBooked Class.
    */
    static testMethod void testBatchUpdateBestGuessBooked() {
        //Testing variables
        List<Sales_Rep_Best_Guess__c> rep = getRepGuess();
        Test.startTest();
        BatchUpdateBestGuessBooked obj = new BatchUpdateBestGuessBooked();
        BatchUpdateBestGuessBooked u = new BatchUpdateBestGuessBooked('LIMIT 5');
        Database.executeBatch(u, 400);
        String sch = '0 0 23 * * ?'; 
        system.schedule('BatchUpdateBestGuessBooked', sch, u); 
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
    
    //Methods to generate test objects
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
        rep2.Quarter__c = 'Q3'+String.valueOf(System.Today().addYears(-1).year());
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
        rep3.Quarter__c = 'Q4'+String.valueOf(System.Today().addYears(1).year());
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
        Sales_Rep_Best_Guess__c rep4 = new Sales_Rep_Best_Guess__c();
        rep4.Quarter__c = 'Q3'+String.valueOf(System.Today().year());
        rep4.Manufacturing_Base_Best_Guess__c = 10;
        rep4.Manufacturing_Digital_Best_Guess__c = 10;
        rep4.Manufacturing_Audience_Best_Guess__c = 10;
        rep4.Manufacturing_Mobile_Best_Guess__c = 10;
        rep4.Retail_Base_Best_Guess__c = 10;
        rep4.Retail_Digital_Best_Guess__c = 10;
        rep4.Retail_Audience_Best_Guess__c = 10;
        rep4.Retail_Mobile_Best_Guess__c = 10;
        rep4.Actual_Amount__c = 20;
        rep4.Forecast_Contract__c = 20;
        rep4.ownerId = UserInfo.getUserId();
        repList.add(rep4);
        Sales_Rep_Best_Guess__c rep5 = new Sales_Rep_Best_Guess__c();
        rep5.Quarter__c = 'Q4'+String.valueOf(System.Today().year());
        rep5.Manufacturing_Base_Best_Guess__c = 10;
        rep5.Manufacturing_Digital_Best_Guess__c = 10;
        rep5.Manufacturing_Audience_Best_Guess__c = 10;
        rep5.Manufacturing_Mobile_Best_Guess__c = 10;
        rep5.Retail_Base_Best_Guess__c = 10;
        rep5.Retail_Digital_Best_Guess__c = 10;
        rep5.Retail_Audience_Best_Guess__c = 10;
        rep5.Retail_Mobile_Best_Guess__c = 10;
        rep5.Actual_Amount__c = 20;
        rep5.Forecast_Contract__c = 20;
        rep5.ownerId = UserInfo.getUserId();
        repList.add(rep5);
        insert repList;
        return repList;
    }
}