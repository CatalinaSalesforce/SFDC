@IsTest
public class TestUpdateFlaggedIP {
    public static testMethod void testUpdateFlaggedIP() {
        Account acct = new Account();
        acct.Name = 'Test Account';
        insert acct;
        
        Flagged_IP_Address__c flaggedIP = new Flagged_IP_Address__c();
        flaggedIP.Name = '127.0.0.1';
        insert flaggedIP;
        
        Case cs = new Case();
        cs.AccountId = acct.id;
        cs.Consumer_IP_Address__c = '127.0.0.1';
        cs.Flagged_IP_Address__c = flaggedIP.Id;
        insert cs;

        Case csTest = [select id, accountid, flagged_ip_address__c, consumer_ip_address__c from Case where Flagged_IP_Address__r.Name = :flaggedIP.Name];
            System.assert(csTest.Flagged_IP_Address__c==flaggedIP.Id);
            System.assert(csTest.Consumer_IP_Address__c==flaggedIP.Name);
            System.assert(csTest.AccountId==acct.id);
        }
}