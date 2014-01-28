/*
@Name           :       BatchUpdateArchiveProgramForecastRecords
@Author         :       customersuccess@cloud62.com
@Date           :       Aug 8 2013 b
@Description    :       Batch class to update Active__c on Archive_Program_forecast__c based on archive date
*/
global class BatchUpdateArchiveProgramForecastRecords implements Database.Batchable<sObject>, Schedulable{
    
    private static final String sysAdmin = 'System Administrator';
    private static final String baseType = 'Base';
    private static final String digitalType = 'Digital O&O';
    private static final String displayType = 'Audience Network';
    private static final String mobileType = 'Mobile';
    private static final String manufacturingType = 'Manufacturing';
    private static final String retailType = 'Retail';
    private static final String coopType = 'coop';
    private static final String SR1Type = 'SR1';
    private static final String SR2Type = 'SR2';
    private static final String SM1Type = 'SM1';
    private static final String SM2Type = 'SM2';
    private static final String pfeEmail = 'fakeemail@myfakeemailplay.com.fake';
    private static final String settingsName = 'Default';
    private static final Integer settingsWindow = 0;
    private static final Integer settingsPercent = 12;
    
    String query;
    String limit1;
    
    public BatchUpdateArchiveProgramForecastRecords(String x){
        limit1 = x;
    }
    
    public BatchUpdateArchiveProgramForecastRecords(){
        limit1 = '';
    }
    
    //method that gets the query used for this batch
    global Database.querylocator start(Database.BatchableContext BC){
        query = 'SELECT ID, ARCHIVE_DATE__C, AD_PERIOD__R.END_DATE__C, '
			+ ' ACTIVE__C '
			+ ' FROM ARCHIVE_PROGRAM_FORECAST__C '
			+ ' where Program__r.OPPORTUNITY__R.RECORDTYPE.NAME IN (\'CONTRACT\',\'PROPOSAL\',\'RENEWAL\',\'RECOVERY\') '
			//+ ' AND ID = \'a0LF0000007Bsx7\' '
			+ limit1;
        return Database.getQueryLocator(query);
    }
    
    global void execute(SchedulableContext ctx) {
        BatchUpdateArchiveProgramForecastRecords batch1 = new BatchUpdateArchiveProgramForecastRecords();
        ID batchprocessid = Database.executeBatch(batch1);
    } 
    
    //method that makes up the body of the batch process
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        List<Archive_Program_Forecast__c> scopeList = (List<Archive_Program_Forecast__c>)scope;
        for (Archive_Program_Forecast__c a : scopeList){
        	if (a.Ad_Period__r.End_Date__c + 2 < a.Archive_Date__c){
        		a.Active__c = false;
        	} else {
        		a.Active__c = true;
        	}
        	system.debug('***ID: ' + a.Id + ', Active__c: ' + a.Active__c);
        }
        update scopeList;
    }
    
    //method that runs after the execute() method
    global void finish(Database.BatchableContext BC){

    }
    
    @isTest
    public static void runTest(){
    	Catalina_Forecast_Settings__c settings = getCatalinaForecastSettingsRecord();
        
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        String profileID = [Select ID From Profile Where Name =: sysAdmin Limit 1][0].Id;
        String rtID = [SELECT ID FROM RecordType Where Name = 'Contract' and SOBJECTTYPE = 'Opportunity'][0].Id;
        
        User testEVP = new User();
        testEVP.FirstName = 'test';
        testEVP.LastName = 'EVP';
        testEVP.Forecast_Role__c = 'EVP';
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
        testSM1.ProfileId = profileID;
        testSM1.ManagerId = testEVP.Id;
        insert testSM1;
        
        User testSM2 = new User();
        testSM2.FirstName = 'test';
        testSM2.LastName = 'SM2';
        testSM2.Forecast_Role__c = 'SM2';
        testSM1.Forecast_Role__c = 'SM2';
        testSM2.Email = 'testSM1@catalinamarketing.com.testuser';
        testSM2.Username = 'testSM2@catalinamarketing.com.testuser';
        testSM2.Alias = 'testSM2';
        testSM2.CommunityNickname = 'testSM2';
        testSM2.TimeZoneSidKey = 'GMT';
        testSM2.LocaleSidKey = 'en_US';
        testSM2.EmailEncodingKey = 'UTF-8';
        testSM2.LanguageLocaleKey = 'en_US';
        testSM2.ProfileId = profileID;
        testSM2.ManagerId = testSM1.Id;
        insert testSM2;
        
        User testSR1 = new User();
        testSR1.FirstName = 'test';
        testSR1.LastName = 'SR1';
        testSR1.Forecast_Role__c = 'SR1';
        testSM1.Forecast_Role__c = 'SR1';
        testSR1.Email = 'testSM1@catalinamarketing.com.testuser';
        testSR1.Username = 'testSR1@catalinamarketing.com.testuser';
        testSR1.Alias = 'testSR1';
        testSR1.CommunityNickname = 'testSR1';
        testSR1.TimeZoneSidKey = 'GMT';
        testSR1.LocaleSidKey = 'en_US';
        testSR1.EmailEncodingKey = 'UTF-8';
        testSR1.LanguageLocaleKey = 'en_US';
        testSR1.ProfileId = profileID;
        testSR1.ManagerId = testSM2.Id;
        insert testSR1;
        
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
        testSR2.ProfileId = profileID;
        testSR2.ManagerId = testSR1.Id;
        insert testSR2;
        
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        
        Opportunity o = new Opportunity();
        o.OwnerId = testSR2.Id;
        o.AccountId = a.Id;
        o.RecordTypeId = rtID;
        o.Name = 'Test oppty';
        o.StageName = 'Presented';
        o.CloseDate = Date.today();
        insert o;
        
        Ad_Period__c ap1 = new Ad_Period__c();
        ap1.Name = 'C2_CY2012_test';
        ap1.Start_Date__c = Date.valueOf('2012-01-23');
        ap1.End_Date__c = Date.valueOf('2012-02-19');
        ap1.Type__c = 'Manufacturing';
        insert ap1;
        
        Ad_Period__c ap2 = new Ad_Period__c();
        ap2.Name = 'C3_CY2012_test';
        ap2.Start_Date__c = Date.valueOf('2012-01-23');
        ap2.End_Date__c = Date.valueOf('2012-02-19');
        ap2.Type__c = 'Manufacturing';
        insert ap2;
        
        Archive_Program__c p = new Archive_Program__c();
        p.Name = o.Name + ' Base';
        p.Ext_ID__c = '01234567890123456';
        p.Opportunity__c = o.Id;
        p.Delivery_Type__c = 'Base';
        p.Product_Type__c = 'Base Product Type1';
        p.Archive_Date__c = Date.today().addYears(-1).addDays(1);
        insert p;
        
        Archive_Product_Type_Split__c apts = new Archive_Product_Type_Split__c();
        apts.Program__c = p.Id;
        apts.Product_Type__c = 'Base Product Type1';
        apts.Percent__c = 100;
        insert apts;
        
        Archive_Program_Forecast__c pf1 = new Archive_Program_Forecast__c();
        pf1.Program__c = p.Id;
        pf1.Ext_ID__c = '012345678901234567';
        pf1.Ad_Period__c = ap1.Id;
        pf1.Forecast_Amount__c = 1000;
        pf1.Archive_Date__c = Date.today().addYears(-1).addDays(1);
        pf1.Actual_Amount__c = 1000;
        pf1.Active__c = false;
        insert pf1;
        
        Archive_Program_Forecast__c pf2 = new Archive_Program_Forecast__c();
        pf2.Program__c = p.Id;
        pf2.Ext_ID__c = '012345678901234567';
        pf2.Ad_Period__c = ap1.Id;
        pf2.Forecast_Amount__c = 1000;
        pf2.Archive_Date__c = Date.today().addYears(5).addDays(1);
        pf2.Actual_Amount__c = 1000;
        pf2.Active__c = false;
        insert pf2;
        
        Archive_Program_Forecast__c pf3 = new Archive_Program_Forecast__c();
        pf3.Program__c = p.Id;
        pf3.Ext_ID__c = '012345678901234567';
        pf3.Ad_Period__c = ap1.Id;
        pf3.Forecast_Amount__c = 1000;
        pf3.Archive_Date__c = Date.today().addYears(-10).addDays(1);
        pf3.Actual_Amount__c = 1000;
        pf3.Active__c = false;
        insert pf3;
        
        Test.startTest();
        BatchUpdateArchiveProgramForecastRecords u = new BatchUpdateArchiveProgramForecastRecords(' LIMIT 100');
        Database.executeBatch(u, 400);
        Test.stopTest();
    }
    
    private static Catalina_Forecast_Settings__c getCatalinaForecastSettingsRecord(){
        Catalina_Forecast_Settings__c settings = new Catalina_Forecast_Settings__c();
        settings.Base_Delivery_Type__c = baseType;
        settings.Digital_Delivery_Type__c = digitalType;
        settings.Display_Delivery_Type__c = displayType;
        settings.Mobile_Delivery_Type__c = mobileType;
        settings.Manufacturing_Account_Type__c = manufacturingType;
        settings.Retail_Account_Type__c = retailType;
        settings.Coop_String__c = coopType;
        settings.Rep_1_String__c = SR1Type;
        settings.Rep_2_String__c = SR2Type;
        settings.SM_1_String__c = SM1Type;
        settings.SM_2_String__c = SM2Type;
        settings.PFE_Email__c = pfeEmail;
        settings.Name = settingsName;
        insert settings;
        return settings;
    }

}