@isTest
private class TestPDTInsertTrg{
    static testMethod void myUnitTest() {
        
        User testUser = getUser();
        Product2 testProduct = getProduct();
        Account testAccount = getAccount(TestUser);
        Opportunity testOpportunity = getOpportunity(testUser, testAccount);
        ContractDB__c testContractDB = getContractDB(testUser, testOpportunity, testProduct);
        CycleDB__c testCycleDB = getCycleDB(testUser, testContractDB);
        createPDT(testUser, testCycleDB);
        
    }
    
    /*
    X-- user
    X-- account
    X-- opportunity

    contractDB__c
    cycleDB__c
    program_req__c
    PDT__c
    */
    
    /*
    @Name :createProgramReq
    @Description : Insert ProgramReq test data.
    */ 
    private static void createProgramReq(User u, CycleDB__c c){
        
        id programReqRTID = [select id from recordType where sObjectType = 'program_req__c'][0].id;
        
        Program_Req__c progReq = new Program_Req__c();
        progReq.cycle_name__c = c.id;
        progReq.send_req__c = false;
        progReq.recordtypeid = programReqRTID;
        
        insert progReq;
       
    }
    
    private static void createPDT(User u, CycleDB__c c){
        
        PDT__c p = new PDT__c();
        p.programmer__c = c.programmer__c;
        p.cycleDB__c = c.Id;
        
        insert p;
    }
    
    /*
    @Name :getContractDB
    @Description : Insert ContractDB test data.
    */
    private static contractDB__c getContractDB(User u, Opportunity o, product2 p){
             
        contractDB__c c = new contractDB__c();
        c.Name = 'Test contractDB';
        c.opportunity_cdb__c = o.id;
        c.products_cdb__c = p.id;
        c.Contract_sales_name__c = u.id;
        c.subject_brandname__c = 'test info';
        c.cancel_Reason__c = 'test info';

        insert c;
        return c;
    }
    
    /*
    @Name :getCycleDB
    @Description : Insert CycleDB test data.
    */
    private static cycleDB__c getCycleDB(User u, ContractDB__C c){
    
        id cycleDBRTID = [select id from recordType where sObjectType = 'cycleDB__c'][0].id;
        User u1 = [SELECT ID, NAME FROM USER WHERE ISACTIVE = TRUE AND PROFILE.NAME LIKE '%JAPAN%' LIMIT 1];
        
        cycleDB__c cycle = new cycleDB__c();
        cycle.name = '111';
        cycle.contractnumber_cycle__c =  c.id;
        cycle.recordtypeid = cycleDBRTID;
        cycle.programmer__c = u1.Id;
        
        insert cycle;
        return cycle;
    }
    
    
    /*
    @Name :getAccount
    @Description : Insert Product test data.
    */
    private static Product2 getProduct(){
    
        id productRTID = [select id from recordType where sObjectType = 'Product2' and DeveloperName Like '%Japan%'][0].id;
        
        Product2 p = new Product2();
        p.Name = 'Test Product';
        p.RecordTypeId = productRTID;
        insert p;
        return p;
    }
    
    /*
    @Name :getUserTestEVP
    @Description : Insert User test data.
    */
    private static User getUser(){
    
        id profileID = [select id from profile where name like '%Japan Administrator%'][0].id;
    
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
        testEVP.ProfileId = profileID;
        insert testEVP;
        return testEVP;
    }
    
    /*
    @Name :getAccount
    @Description : Insert Account test data.
    */
    private static Account getAccount(User u){
    
        id accountRTID = [select id from recordType where sObjectType = 'Account' and DeveloperName Like '%Japan%'][0].id;
    
        Account a = new Account();
        a.Name = 'Test Account';
        a.RecordTypeId = accountRTID;
        a.ownerID = u.id;
        insert a;
        return a;
    }
    
    /*
    @Name :getOpportunity
    @Description : Insert Opportunity test data.
    */
    private static Opportunity getOpportunity(User u, Account a){
        
        id opportunityRTID = [select id from recordType where sObjectType = 'Opportunity' and DeveloperName Like '%Japan%'][0].id;
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        Opportunity o = new Opportunity();
        o.OwnerId = u.id;
        o.AccountId = a.id;
        o.RecordTypeId = opportunityRTID;
        o.Name = 'Test oppty';
        o.StageName = 'Presented';
        o.CloseDate = Date.today();
        insert o;
        return o;
    }
        
    
}