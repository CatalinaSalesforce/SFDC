@isTest()
public with sharing class esBatch_Test {
	
	  public static testmethod void runESTest() {
        // New Inf parent
        Influence_Parent__c ip = new Influence_Parent__c( active__c = true,  maximum_concurrent_batches__c = 5, start_time__c = datetime.now().addMonths(-6), end_time__c = datetime.now() );
        insert ip;
        
        // New user for us to follow
        Profile p = [select id from Profile where usertype='Standard' limit 1];
        User u = new User(alias = 'standt', email='influence@jhersh.demo', 
                        emailencodingkey='UTF-8', lastname='Testing1', firstname='Testing', languagelocalekey='en_US', 
                        localesidkey='en_US', profileid = p.Id, 
                        timezonesidkey='America/Los_Angeles', username='influence@jhersh.demo');        
        
        try {
            insert u;
            insert new EntitySubscription( parentid = userinfo.getuserid(), subscriberid = u.id );
        } catch( Exception e ) {
            return;
        }
        
        esBatch eb = new esBatch();
        eb.isTest = true;
        eb.ipID = ip.id;
        eb.exclude = new Set<ID> { userinfo.getuserid() };

        Test.StartTest();
        ID batchprocessid = Database.executeBatch(eb);
        Test.StopTest();
    }

}