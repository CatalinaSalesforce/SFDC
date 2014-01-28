@isTest(SeeAllData=true)
private class TestAccountTrigger{

    static testMethod void myTest() {
    // TO DO: implement before insert trigger              
        Catalina_Forecast_Settings__c setting = Catalina_Forecast_Settings__c.getInstance('Default');
        System.assertNotEquals(setting , NULL);
        System.assertNotEquals(setting.Default_Account_Owner_ExtId__c, NULL);
        System.assertNotEquals(setting.Integration_User_Id__c , NULL);

        Id intUserId = setting.Integration_User_Id__c ;
        
        User intUser = [ select Id from User where Id = :intUserId  ];  
        System.runAs ( intUser ) {  
             
            
            Account acctMfg = new Account();
            acctMfg.name = 'Test Mfg Account';
            RecordType rtMfg = [select Id,Name from RecordType where Name = 'Manufacturing' and SobjectType = 'Account' LIMIT 1];
            acctMfg.RecordTypeId = rtMfg.Id;
            insert acctMfg;
            
            Account acctRtl = new Account();
            acctRtl.name = 'Test Rtl Account';
            RecordType rtRtl = [select Id,Name from RecordType where Name = 'Retail' and SobjectType = 'Account' LIMIT 1];
            acctRtl.RecordTypeId = rtRtl.Id;
            insert acctRtl;
            
            Account acct = new Account();
            acct.name = 'Test General Account';
            RecordType rt = [select Id,Name from RecordType where Name = 'Manufacturing France' and SobjectType = 'Account' LIMIT 1];
            acct.RecordTypeId = rt.Id;
            insert acct;
            
            User testuser = [SELECT Id from User where ExtID__c = :setting.Default_Account_Owner_ExtId__c Limit 1];
            
            Account testacct = [Select id,ownerId from Account Where name = 'Test Mfg Account' Limit 1];
            System.assertEquals(testuser.Id, testacct.ownerId);
            
            testacct = [Select id,ownerId from Account Where name = 'Test Rtl Account' Limit 1];
            System.assertEquals(testuser.Id, testacct.ownerId);
            
            testacct = [Select id,ownerId from Account Where name = 'Test General Account' Limit 1];
            System.assertNotEquals(testuser.Id, testacct.ownerId);
        }
    }
}