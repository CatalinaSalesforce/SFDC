@isTest()
public with sharing class OrderingBatch_Test {
	
	  
    public static testmethod void testOrdering() {      
        // New Inf parent
        Influence_Parent__c ip = new Influence_Parent__c( active__c = true, start_time__c = datetime.now().addMonths(-6), end_time__c = datetime.now(), status__c = 'Sorting Data',  maximum_concurrent_batches__c = 5 );
        insert ip;
        
        // New inf
        Influence__c inf = new Influence__c( influence_parent__c = ip.id, user__c = userinfo.getuserid(), comments_created__c = 1, cc_rank__c = 0 );
        insert inf;
        
        // New user for us to follow
        Profile p = [select id from Profile where usertype='Standard' limit 1];
        User u = new User(alias = 'standt', email='influence@jhersh.demo', 
                        emailencodingkey='UTF-8', lastname='Testing1', firstname='Testing', languagelocalekey='en_US', 
                        localesidkey='en_US', profileid = p.Id, 
                        timezonesidkey='America/Los_Angeles', username='influence@jhersh.demo');        
        
        try {
            insert u;
            insert new Influence__c( influence_parent__c = ip.id, user__c = u.id, comments_created__c = 2, cc_rank__c = 0 );
        } catch( Exception e ) {
            return;
        }
        
        orderingBatch ob = new orderingBatch();
        ob.ipID = ip.id;
        ob.doUpdateParent = true;
        ob.sortField = 'comments_created__c';
        ob.rankField = 'cc_rank__c';
        ob.medianField = 'median_comments_created__c';

        Test.StartTest();
        ID batchprocessid = Database.executeBatch(ob);
        Test.StopTest();
    
        //System.assertEquals( 2, [select cc_rank__c from Influence__c where influence_parent__c = :ip.id and user__c = :userinfo.getuserid()].cc_rank__c ); 
    }

}