@isTest()
public class fpBatch_Test {
	

public static testmethod void runFPTest() {     
        // New Inf parent
        Influence_Parent__c ip = new Influence_Parent__c( active__c = true, start_time__c = datetime.now().addMonths(-6), end_time__c = datetime.now(), maximum_concurrent_batches__c = 5 );
        insert ip;
        
        insert new FeedItem( body = 'testing', parentid = userinfo.getuserid() );
        
        // New user to do a post
        Profile p = [select id from Profile where usertype='Standard' limit 1];
        User u = new User(alias = 'standt', email='influence@jhersh.demo', 
                        emailencodingkey='UTF-8', lastname='Testing1', firstname='Testing', languagelocalekey='en_US', 
                        localesidkey='en_US', profileid = p.Id, 
                        timezonesidkey='America/Los_Angeles', username='influence@jhersh.demo');        
        
        try {
            insert u;
        } catch( Exception e ) {}
        
        FeedItem fp;
        
        fp = new FeedItem( parentid = userinfo.getuserid(), body = 'test post!' );  
        insert fp;
        
        try {
            insert new FeedComment( feeditemid = fp.id, commentbody = 'test comment!' );
        } catch( Exception e ) {
            return;
        }
        
        system.runAs( u ) {
            insert new FeedItem( parentid = u.id, body = 'Testing another post' );
            insert new FeedComment( feeditemid = fp.id, commentbody = 'another test comment!' );
            insert new FeedLike( feeditemid = fp.id );
        }
        
        fpBatch fb = new fpBatch();
        fb.isTest = true;
        fb.ipID = ip.id;
        fb.objecttype = 'UserFeed';
        fb.exclude = new Set<ID> { userinfo.getuserid() };
    
        Test.startTest();
        //ID batchprocessid = Database.executeBatch(fb);
        fb.execute( null, Database.query( fb.start(null).getQuery() ) );
        fb.finish( null );
        Test.stopTest();
    }	

}