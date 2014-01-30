/*
@Name : TestBatchAssociateCongBG
@Author : customersuccess@cloud62.com
@Date : 02-12-2013
@Description : test functionality for BatchAssociateCongBG class.
*/
 @isTest
private class TestBatchAssociateCongBG {
    
    /*
    @Name :TestBatchAssociateCongBestGuess
    @Description : test functionality for BatchAssociateCongBG class.
    */
    static testmethod void TestBatchAssociateCongBestGuess(){
        Account a = getAccount();
        Account childAccount = getChildAccount(a.Id);
        User u = getUserSM2();
        Conglomerate_Account_Best_Guess_Summary__c cbg = getCongAccount(a.Id,u.ID);
        List<Sales_Manager_1_Forecast__c> sm1 = getSM1Forecast(childAccount.Id);
        Test.startTest();
        BatchAssociateCongBG obj = new BatchAssociateCongBG();
        Database.executeBatch(obj, 400);
        String sch = '0 0 23 * * ?'; 
        system.schedule('BatchAssociateCongBG', sch, obj);
        //System.assertEquals(cbg.ID, [select Conglomerate_Best_Guess__c FROM Sales_Manager_1_Forecast__c][1].Conglomerate_Best_Guess__c);
        Test.stopTest();
    }
    
    /*
    @Name :TestBatchAssociateCongBGSM2
    @Description : test functionality for BatchAssociateCongBGSM2 class.
    */
    static testmethod void TestBatchAssociateCongBGSM2(){
        Account a = getAccount();
        Account childAccount = getChildAccount(a.Id);
        User u = getUserSM2();
        Conglomerate_Account_Best_Guess_Summary__c cbg = getCongAccount(a.Id,u.ID);
        List<Sales_Manager_1_Forecast__c> sm1 = getSM1Forecast(childAccount.Id);
        List<Sales_Manager_2_Forecast__c> sm2 = getSM2Forecast(childAccount.Id,cbg.Id,u.Id,sm1);
        Test.startTest();
        BatchAssociateCongBGSM2 obj = new BatchAssociateCongBGSM2();
        Database.executeBatch(obj, 400);
        String sch = '0 0 23 * * ?'; 
        system.schedule('BatchAssociateCongBGSM2', sch, obj);
        System.assertEquals(cbg.ID, [select Conglomerate_Best_Guess__c FROM Sales_Manager_2_Forecast__c][1].Conglomerate_Best_Guess__c);
        Test.stopTest();
    }
    
    /*
    @Name :TestBatchAssociateCongBGSR1
    @Description : test functionality for BatchAssociateCongBGSR1 class.
    
    static testmethod void TestBatchAssociateCongBGSR1(){
        Account a = getAccount();
        Account childAccount = getChildAccount(a.Id);
        User u = getUserSR1();
        Conglomerate_Account_Best_Guess_Summary__c cbg = getCongAccount(a.Id,u.ID);
        List<Sales_Manager_1_Forecast__c> sm1 = getSM1Forecast(childAccount.Id);
        List<Sales_Manager_2_Forecast__c> sm2 = getSM2Forecast(childAccount.Id,cbg.Id,u.Id,sm1);
        List<Rep_1_Forecast__c> rp1 = getRep1Forecast(childAccount.Id,cbg.Id,u.Id,sm2);
        Test.startTest();
        BatchAssociateCongBGSR1 obj = new BatchAssociateCongBGSR1();
        Database.executeBatch(obj, 400);
        String sch = '0 0 23 * * ?'; 
        system.schedule('BatchAssociateCongBGSR1', sch, obj);
        System.assertEquals(cbg.ID, [select Conglomerate_Best_Guess__c FROM Rep_1_Forecast__c][1].Conglomerate_Best_Guess__c);
        Test.stopTest();
    }
    */
    /*
    @Name :TestBatchAssociateCongBGSR2
    @Description : test functionality for BatchAssociateCongBGSR2 class.
    
    static testmethod void TestBatchAssociateCongBGSR2(){
        Account a = getAccount();
        Account childAccount = getChildAccount(a.Id);
        User u = getUserSR2();
        Conglomerate_Account_Best_Guess_Summary__c cbg = getCongAccount(a.Id,u.ID);
        List<Sales_Manager_1_Forecast__c> sm1 = getSM1Forecast(childAccount.Id);
        List<Sales_Manager_2_Forecast__c> sm2 = getSM2Forecast(childAccount.Id,cbg.Id,u.Id,sm1);
        List<Rep_1_Forecast__c> rp1 = getRep1Forecast(childAccount.Id,cbg.Id,u.Id,sm2);
        List<Rep_2_Forecast__c> rp2 = getRep2Forecast(childAccount.Id,cbg.Id,u.Id,rp1);
        Test.startTest();
        BatchAssociateCongBGSR2 obj = new BatchAssociateCongBGSR2();
        Database.executeBatch(obj, 400);
        String sch = '0 0 23 * * ?'; 
        system.schedule('BatchAssociateCongBGSR2', sch, obj);
        System.assertEquals(cbg.ID, [select Conglomerate_Best_Guess__c FROM Rep_2_Forecast__c][1].Conglomerate_Best_Guess__c);
        Test.stopTest();
    }
    */
    /*
    @Name :TestBatchAssociateAccountBGSR1
    @Description : test functionality for BatchAssociateAccountBGSR1 class.
    */
    static testmethod void TestBatchAssociateAccountBGSR1(){
        Account a = getAccount();
        Account childAccount = getChildAccount(a.Id);
        User u = getUserSR1();
        Conglomerate_Account_Best_Guess_Summary__c cbg = getCongAccount(a.Id,u.ID);
        Account_Best_Guess_Summary__c abg =  getAccountBestGuess(a.Id,u.ID);
        List<Sales_Manager_1_Forecast__c> sm1 = getSM1Forecast(a.Id);
        List<Sales_Manager_2_Forecast__c> sm2 = getSM2Forecast(a.Id,cbg.Id,u.Id,sm1);
        List<Rep_1_Forecast__c> rp1 = getRep1Forecast(a.Id,cbg.Id,u.Id,sm2);
        Test.startTest();
        BatchAssociateAccountBGSR1 obj = new BatchAssociateAccountBGSR1();
        Database.executeBatch(obj, 400);
        String sch = '0 0 23 * * ?'; 
        system.schedule('BatchAssociateAccountBGSR1', sch, obj);
        System.assertEquals(cbg.ID, [select Conglomerate_Best_Guess__c FROM Rep_1_Forecast__c][1].Conglomerate_Best_Guess__c);
        Test.stopTest();
    }
    
    /*
    @Name :TestBatchAssociateAccountBGSR2
    @Description : test functionality for BatchAssociateAccountBGSR2 class.
    */
    static testmethod void TestBatchAssociateAccountBGSR2(){
        Account a = getAccount();
        Account childAccount = getChildAccount(a.Id);
        User u = getUserSR2();
        Conglomerate_Account_Best_Guess_Summary__c cbg = getCongAccount(a.Id,u.ID);
        Account_Best_Guess_Summary__c abg =  getAccountBestGuess(a.Id,u.ID);
        List<Sales_Manager_1_Forecast__c> sm1 = getSM1Forecast(a.Id);
        List<Sales_Manager_2_Forecast__c> sm2 = getSM2Forecast(a.Id,cbg.Id,u.Id,sm1);
        List<Rep_1_Forecast__c> rp1 = getRep1Forecast(a.Id,cbg.Id,u.Id,sm2);
        List<Rep_2_Forecast__c> rp2 = getRep2Forecast(a.Id,cbg.Id,u.Id,rp1);
        Test.startTest();
        BatchAssociateAccountBGSR2 obj = new BatchAssociateAccountBGSR2();
        Database.executeBatch(obj, 400);
        String sch = '0 0 23 * * ?'; 
        system.schedule('BatchAssociateAccountBGSR2', sch, obj);
        System.assertEquals(cbg.ID, [select Conglomerate_Best_Guess__c FROM Rep_2_Forecast__c][1].Conglomerate_Best_Guess__c);
        Test.stopTest();
    }
    
    /*
    @Name :getAccount
    @Description : prepare the test data for Account record.
    */
    private static Account getAccount(){
        Account acc = new Account(Name = 'TestCase', Type = 'Conglomerate', OwnerId=UserInfo.getUserId());
        insert acc;
        return acc;
    }
    
    /*
    @Name :getChildAccount
    @Description : prepare the test data for Child Account record.
    */
    private static Account getChildAccount(Id a){
        Account acc = new Account(Name='TestCase',Type='Conglomerate',PARENTID=a,OwnerId=UserInfo.getUserId());
        insert acc;
        return acc;
    }
    
    /*
    @Name :getCongAccount
    @Description : prepare the test data for Conglomerate_Account_Best_Guess_Summary__c record.
    */
    private static Conglomerate_Account_Best_Guess_Summary__c getCongAccount(Id a,ID u){
        Conglomerate_Account_Best_Guess_Summary__c cbg = new Conglomerate_Account_Best_Guess_Summary__c();
        cbg.Account__c = a;
        cbg.OwnerID = u;
        cbg.Year__c = '2012';
        cbg.Delivery_Channel__c = 'Base';
        insert cbg;
        return cbg;
    }
    
    /*
    @Name :getAccountBestGuess
    @Description : prepare the test data for Account_Best_Guess_Summary__c record.
    */
    private static Account_Best_Guess_Summary__c getAccountBestGuess(Id a,ID u){
        Account_Best_Guess_Summary__c cbg = new Account_Best_Guess_Summary__c();
        cbg.Account__c = a;
        cbg.OwnerID = u;
        cbg.Year__c = '2012';
        cbg.Delivery_Channel__c = 'Base';
        insert cbg;
        return cbg;
    }
    
    /*
    @Name :getSM1Forecast
    @Description : prepare the test data list for Sales_Manager_1_Forecast__c records.
    */
    private static List<Sales_Manager_1_Forecast__c> getSM1Forecast(Id childAccount){
        Sales_Manager_1_Forecast__c sm1 = new Sales_Manager_1_Forecast__c(NAME='Test',
            Account__c=childAccount,DELIVERY_TYPE__C='Base',QUARTER__C='Q12012');
        Sales_Manager_1_Forecast__c sm2 = new Sales_Manager_1_Forecast__c(NAME='Test',
            Account__c=childAccount,DELIVERY_TYPE__C='Base',QUARTER__C='Q22012');
        Sales_Manager_1_Forecast__c sm3 = new Sales_Manager_1_Forecast__c(NAME='Test',
            Account__c=childAccount,DELIVERY_TYPE__C='Base',QUARTER__C='Q32012');
        Sales_Manager_1_Forecast__c sm4 = new Sales_Manager_1_Forecast__c(NAME='Test',
            Account__c=childAccount,DELIVERY_TYPE__C='Base',QUARTER__C='Q42012');
        List<Sales_Manager_1_Forecast__c> sm1forcast = new List<Sales_Manager_1_Forecast__c>();
        sm1forcast.add(sm1);
        sm1forcast.add(sm2);
        sm1forcast.add(sm3);
        sm1forcast.add(sm4);
        insert sm1forcast;
        return sm1forcast;
    }
    
    /*
    @Name :getSM2Forecast
    @Description : prepare the test data list for Sales_Manager_2_Forecast__c records.
    */
    private static List<Sales_Manager_2_Forecast__c> getSM2Forecast(Id childAccount,Id cbg,Id u,List<Sales_Manager_1_Forecast__c> s){
        Sales_Manager_2_Forecast__c sm1 = new Sales_Manager_2_Forecast__c(NAME='Test',OwnerId = u,Manager_Forecast__c = s[0].Id,
            Account__c=childAccount,DELIVERY_TYPE__C='Base',QUARTER__C='Q12012',Conglomerate_Best_Guess__c = cbg);
        Sales_Manager_2_Forecast__c sm2 = new Sales_Manager_2_Forecast__c(NAME='Test',OwnerId = u,Manager_Forecast__c = s[1].Id,
            Account__c=childAccount,DELIVERY_TYPE__C='Base',QUARTER__C='Q22012',Conglomerate_Best_Guess__c = cbg);
        Sales_Manager_2_Forecast__c sm3 = new Sales_Manager_2_Forecast__c(NAME='Test',OwnerId = u,Manager_Forecast__c = s[2].Id,
            Account__c=childAccount,DELIVERY_TYPE__C='Base',QUARTER__C='Q32012',Conglomerate_Best_Guess__c = cbg);
        Sales_Manager_2_Forecast__c sm4 = new Sales_Manager_2_Forecast__c(NAME='Test',OwnerId = u,Manager_Forecast__c = s[3].Id,
            Account__c=childAccount,DELIVERY_TYPE__C='Base',QUARTER__C='Q42012',Conglomerate_Best_Guess__c = cbg);
        List<Sales_Manager_2_Forecast__c> sm2forcast = new List<Sales_Manager_2_Forecast__c>();
        sm2forcast.add(sm1);
        sm2forcast.add(sm2);
        sm2forcast.add(sm3);
        sm2forcast.add(sm4);
        insert sm2forcast;
        return sm2forcast;
    }
    
    /*
    @Name :getRep1Forecast
    @Description : prepare the test data list for Rep_1_Forecast__c records.
    */
    private static List<Rep_1_Forecast__c> getRep1Forecast(Id childAccount,Id cbg,Id u,List<Sales_Manager_2_Forecast__c> s){
        Rep_1_Forecast__c rp1 = new Rep_1_Forecast__c(NAME='Test',OwnerId = u,Manager_Forecast__c = s[0].Id,
            Account__c=childAccount,DELIVERY_TYPE__C='Base',QUARTER__C='Q12012',Conglomerate_Best_Guess__c = cbg);
        Rep_1_Forecast__c rp2 = new Rep_1_Forecast__c(NAME='Test',OwnerId = u,Manager_Forecast__c = s[1].Id,
            Account__c=childAccount,DELIVERY_TYPE__C='Base',QUARTER__C='Q22012',Conglomerate_Best_Guess__c = cbg);
        Rep_1_Forecast__c rp3 = new Rep_1_Forecast__c(NAME='Test',OwnerId = u,Manager_Forecast__c = s[2].Id,
            Account__c=childAccount,DELIVERY_TYPE__C='Base',QUARTER__C='Q32012',Conglomerate_Best_Guess__c = cbg);
        Rep_1_Forecast__c rp4 = new Rep_1_Forecast__c(NAME='Test',OwnerId = u,Manager_Forecast__c = s[3].Id,
            Account__c=childAccount,DELIVERY_TYPE__C='Base',QUARTER__C='Q42012',Conglomerate_Best_Guess__c = cbg);
        List<Rep_1_Forecast__c> rep1forcast = new List<Rep_1_Forecast__c>();
        rep1forcast.add(rp1);
        rep1forcast.add(rp2);
        rep1forcast.add(rp3);
        rep1forcast.add(rp4);
        insert rep1forcast;
        return rep1forcast;
    }
    
    /*
    @Name :getRep2Forecast
    @Description : prepare the test data list for Rep_2_Forecast__c records.
    */
    private static List<Rep_2_Forecast__c> getRep2Forecast(Id childAccount,Id cbg,Id u,List<Rep_1_Forecast__c> r){
        Rep_2_Forecast__c rp1 = new Rep_2_Forecast__c(NAME='Test',OwnerId = u,Manager_Forecast__c = r[0].Id,
            Account__c=childAccount,DELIVERY_TYPE__C='Base',QUARTER__C='Q12012',Conglomerate_Best_Guess__c = cbg);
        Rep_2_Forecast__c rp2 = new Rep_2_Forecast__c(NAME='Test',OwnerId = u,Manager_Forecast__c = r[1].Id,
            Account__c=childAccount,DELIVERY_TYPE__C='Base',QUARTER__C='Q22012',Conglomerate_Best_Guess__c = cbg);
        Rep_2_Forecast__c rp3 = new Rep_2_Forecast__c(NAME='Test',OwnerId = u,Manager_Forecast__c = r[2].Id,
            Account__c=childAccount,DELIVERY_TYPE__C='Base',QUARTER__C='Q32012',Conglomerate_Best_Guess__c = cbg);
        Rep_2_Forecast__c rp4 = new Rep_2_Forecast__c(NAME='Test',OwnerId = u,Manager_Forecast__c = r[3].Id,
            Account__c=childAccount,DELIVERY_TYPE__C='Base',QUARTER__C='Q42012',Conglomerate_Best_Guess__c = cbg);
        List<Rep_2_Forecast__c> rep2forcast = new List<Rep_2_Forecast__c>();
        rep2forcast.add(rp1);
        rep2forcast.add(rp2);
        rep2forcast.add(rp3);
        rep2forcast.add(rp4);
        insert rep2forcast;
        return rep2forcast;
    }
    
    /*
    @Name :getUserSM2
    @Description : prepare the test data for User record.
    */
    private static User getUserSM2(){
        String profileID = [Select ID From Profile Where Name =: 'System Administrator' Limit 1][0].Id;
        User testEVP = new User();
        testEVP.FirstName = 'test';
        testEVP.LastName = 'EVP';
        testEVP.Forecast_Role__c = 'SM2';
        testEVP.Email = 'testEVP@catalinamarketing.com.testuser';
        testEVP.Username = 'testEVP@catalinamarketing.com.testuser';
        testEVP.Alias = 'testEVP';
        testEVP.CommunityNickname = 'testEVP';
        testEVP.TimeZoneSidKey = 'GMT';
        testEVP.LocaleSidKey = 'en_US';
        testEVP.EmailEncodingKey = 'UTF-8';
        testEVP.LanguageLocaleKey = 'en_US';
        testEVP.ProfileId = profileID;
        insert testEVP;
        return testEVP;
    }
    
    /*
    @Name :getUserSR1
    @Description : prepare the test data for User record.
    */
    private static User getUserSR1(){
        String profileID = [Select ID From Profile Where Name =: 'System Administrator' Limit 1][0].Id;
        User testEVP = new User();
        testEVP.FirstName = 'test';
        testEVP.LastName = 'EVP';
        testEVP.Forecast_Role__c = 'SR1';
        testEVP.Email = 'testEVP@catalinamarketing.com.testuser';
        testEVP.Username = 'testEVP@catalinamarketing.com.testuser';
        testEVP.Alias = 'testEVP';
        testEVP.CommunityNickname = 'testEVP';
        testEVP.TimeZoneSidKey = 'GMT';
        testEVP.LocaleSidKey = 'en_US';
        testEVP.EmailEncodingKey = 'UTF-8';
        testEVP.LanguageLocaleKey = 'en_US';
        testEVP.ProfileId = profileID;
        insert testEVP;
        return testEVP;
    }
    
    /*
    @Name :getUserSR2
    @Description : prepare the test data for User record.
    */
    private static User getUserSR2(){
        String profileID = [Select ID From Profile Where Name =: 'System Administrator' Limit 1][0].Id;
        User testEVP = new User();
        testEVP.FirstName = 'test';
        testEVP.LastName = 'EVP';
        testEVP.Forecast_Role__c = 'SR2';
        testEVP.Email = 'testEVP@catalinamarketing.com.testuser';
        testEVP.Username = 'testEVP@catalinamarketing.com.testuser';
        testEVP.Alias = 'testEVP';
        testEVP.CommunityNickname = 'testEVP';
        testEVP.TimeZoneSidKey = 'GMT';
        testEVP.LocaleSidKey = 'en_US';
        testEVP.EmailEncodingKey = 'UTF-8';
        testEVP.LanguageLocaleKey = 'en_US';
        testEVP.ProfileId = profileID;
        insert testEVP;
        return testEVP;
    }
}