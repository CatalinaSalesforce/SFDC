/*
@Name : TestBigBetsController
@Author : customersuccess@cloud62.com
@Date : 03-12-2013
@Description : test functionality for BigBetsController class.
*/
 @isTest
private class TestBigBetsController {
    
    /*
    @Name :TestBatchAssociateCongBestGuess
    @Description : test functionality for BigBetsController class.
    */
    static testmethod void testBigBetsCont(){
        
        //Get the test data.
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        BigBets_Setting__c setting2 = new BigBets_Setting__c();
        setting2 .Name='BigBetsAutopopulateUser';
        setting2 .Autopopulate_Users__c=userInfo.getUserName();
        insert setting2;

        Account a = getAccount();
        Account childAccount = getChildAccount(a.Id);
        List<Sales_Manager_1_Forecast__c> sm1 = getSM1Forecast(childAccount.Id);
        List<Conglomerate_Account_Best_Guess_Summary__c> cbg = getCongAccount(a.Id);
        Contact con = getContact(a.Id);
        Opportunity opp = getOpportunity(childAccount.Id);
        AccountTeamMember atm = getAccountTeamMember(a.Id);
        Attachment att = getAttachment(a.Id);
        
        //Run Test.
        Test.startTest();
        BigBetsController bb = new BigBetsController();
        bb.searchAcc.Name = 'TestCase';
        bb.strYear = '2012';
        bb.strDeliveryChannel = 'Base,Audience Network,Digital O&O,Mobile';
        bb.strTimePeriod = 'Q1,Q2,Q3,Q4';
        bb.strCustomerType = 'Manufacturing,Retail';
        bb.search();
        bb.getGrid1And3SM1Data();
        bb.getGrid1And3SM2Data();
        bb.getGrid1And3SR1Data();
        bb.getGrid1And3SR2Data();
        bb.strClientSegment = 'All';
        bb.getGrid1And3SM1Data();
        bb.getGrid1And3SM2Data();
        bb.getGrid1And3SR1Data();
        bb.getGrid1And3SR2Data();
        bb.strClientSegment = 'Other';
        bb.getGrid1And3SM1Data();
        bb.getGrid1And3SM2Data();
        bb.getGrid1And3SR1Data();        
        bb.getGrid1And3SR2Data();
        
        bb.getGrid2Data();
        bb.getGrid4Data();
        bb.getGrid5Data();
        bb.getGrid6Data();
        bb.getGrid7Data();
        bb.getGrid8Data();
        bb.strTimePeriod = 'Q1';
        bb.getGrid2Data();
        bb.getGrid6Data();
        bb.getGrid7Data();
        bb.strTimePeriod = 'Q2';
        bb.getGrid2Data();
        bb.getGrid6Data();
        bb.getGrid7Data();
        bb.strTimePeriod = 'Q3';
        bb.getGrid2Data();
        bb.getGrid6Data();
        bb.getGrid7Data();
        bb.strTimePeriod = 'Q4';
        bb.getGrid2Data();
        bb.getGrid6Data();
        bb.getGrid7Data();
        bb.searchAcc.Name = '';
        bb.getGrid6Data();
        bb.strClientSegment = 'All';
        bb.getGrid6Data();
        bb.strClientSegment = 'Other';
        bb.getGrid6Data();
        Test.stopTest();
    }
    
    /*
    @Name :getAccount
    @Description : prepare the test data for Account record.
    */
    private static Account getAccount(){
        String rtID = [SELECT ID FROM RecordType Where Name = 'Manufacturing' and SOBJECTTYPE = 'Account'][0].Id;
        
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
    
    /*
    @Name :getAccountTeamMember
    @Description : prepare the test data for AccountTeamMember record.
    */
    private static AccountTeamMember getAccountTeamMember(Id a){
        AccountTeamMember atm = new AccountTeamMember(AccountId=a,UserId = UserInfo.getUserId(),TeamMemberRole='Digital Specialist');
        insert atm;
        return atm;
    }
    
    /*
    @Name :getAttachment
    @Description : prepare the test data for Attachment record.
    */
    private static Attachment getAttachment(Id a){
        Attachment att = new Attachment(Name='bigbets2012',ParentId=a,Body = Blob.valueOf('Testing'));
        insert att;
        return att;
    }
    
    /*
    @Name :getContact
    @Description : prepare the test data for Contact record.
    */
    private static Contact getContact(Id a){
        Contact con = new Contact(FirstName='Lorrie',LastName='Journey',Title='Manager', Email='lorrie@test.com', 
                AccountId=a,Rating_Type__c='Vice President');
        insert con;
        return con;
    }
    
    
    /*
    @Name :getOpportunity 
    @Description : prepare the test data for Opportunity record.
    */
    private static Opportunity getOpportunity(Id a){
        Opportunity opp = new Opportunity(AccountId=a,Name='Test',CloseDate=System.Today(),Amount=20000,StageName='Idea',
                            Start_Date__c=System.Today().addmonths(-13),End_Date__c=System.Today().addmonths(-5));
        insert opp;
        return opp;
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
    @Name :getCongAccount
    @Description : prepare the test data for Conglomerate_Account_Best_Guess_Summary__c record.
    */
    private static List<Conglomerate_Account_Best_Guess_Summary__c> getCongAccount(Id a){
        Conglomerate_Account_Best_Guess_Summary__c cbg1 = new Conglomerate_Account_Best_Guess_Summary__c(Account__c = a,Year__c = '2012',
                Delivery_Channel__c = 'Base',Q1__c=2000,Q2__c=2000,Q3__c=2000,Q4__c=2000,Booked_Q1__c=2000,Booked_Q2__c=2000,Booked_Q3__c=2000,
                Booked_Q4__c=2000);
        Conglomerate_Account_Best_Guess_Summary__c cbg2 = new Conglomerate_Account_Best_Guess_Summary__c(Account__c = a,Year__c = '2012',
                Delivery_Channel__c = 'Base',Q1__c=2000,Q2__c=2000,Q3__c=2000,Q4__c=2000,Booked_Q1__c=2000,Booked_Q2__c=2000,Booked_Q3__c=2000,
                Booked_Q4__c=2000);
        Conglomerate_Account_Best_Guess_Summary__c cbg3 = new Conglomerate_Account_Best_Guess_Summary__c(Account__c = a,Year__c = '2012',
                Delivery_Channel__c = 'Base',Q1__c=2000,Q2__c=2000,Q3__c=2000,Q4__c=2000,Booked_Q1__c=2000,Booked_Q2__c=2000,Booked_Q3__c=2000,
                Booked_Q4__c=2000);
        Conglomerate_Account_Best_Guess_Summary__c cbg4 = new Conglomerate_Account_Best_Guess_Summary__c(Account__c = a,Year__c = '2012',
                Delivery_Channel__c = 'Base',Q1__c=2000,Q2__c=2000,Q3__c=2000,Q4__c=2000,Booked_Q1__c=2000,Booked_Q2__c=2000,Booked_Q3__c=2000,
                Booked_Q4__c=2000);
        
        List<Conglomerate_Account_Best_Guess_Summary__c> cbg = new List<Conglomerate_Account_Best_Guess_Summary__c>();
        cbg.add(cbg1);
        cbg.add(cbg2);
        cbg.add(cbg3);
        cbg.add(cbg4);
        insert cbg;
        return cbg;
    }
    
    
}