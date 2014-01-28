// Jonathan Hersh - jhersh@salesforce.com - 12/2010
// FeedPost/FeedComment batch calculator

global class fpBatch implements Database.Batchable<sObject>, Database.Stateful {

    global String ipID;
    global Influence_Parent__c ip   { get; set; }
    global string objectType;
    global boolean failed;
    global Set<ID> exclude          { get; set; }
    global boolean isTest           { get; set; }
    global static string userPrefix = Schema.Sobjecttype.User.getKeyPrefix();
    
    global fpBatch() {
        isTest = false;
    }

    global Database.QueryLocator start(Database.BatchableContext BC){    
        try {
            ip = [select id, start_time__c, end_time__c from Influence_Parent__c where id = :ipID];
        } catch( Exception e ) {
            return null;
        }
        
        failed = false;
        string eList = '';
        
        if( exclude == null )
            exclude = new Set<ID> ();
        
        ID[] excludeIDs = new ID[] {};
        excludeIDs.addAll( exclude );   
            
        for( integer x = 0; x < excludeIDs.size(); x++ )
            eList += '\''+ excludeIDs.get(x) + '\'' + ( x < excludeIDs.size() - 1 ? ',' : '' );
            
        eList = '(' + eList + ')';
                        
        string q = 'select parentid, createdbyid, createddate, likecount, '+
            '(select createdbyid, createddate from FeedComments '+ 
            'where createddate >= '+ influenceBatcher.soqlDate( ip.start_time__c ) +' and createddate <= '+ influenceBatcher.soqlDate( ip.end_time__c ) +' '+
            ( !excludeIDs.isEmpty() ? 'and createdbyid NOT IN '+ eList : '' ) +' ) '+
            ' from '+ objectType +
            ' where type <> \'TrackedChange\' '+
            'and createddate >= '+ influenceBatcher.soqlDate( ip.start_time__c ) +' and createddate <= '+ influenceBatcher.soqlDate( ip.end_time__c ) +' '+
            ( !excludeIDs.isEmpty() ? 'and ( parentid NOT IN '+ eList +' and createdbyid NOT IN '+ eList + ' )' : '' ) +
            ' order by createddate desc, id desc '+ ( isTest ? 'limit 200' : '' );
        
        return Database.getQueryLocator(q);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){
        string[] userIDs = new string[] {};
        
        // Try to recover if something really wrong happens
        try {
            ip = [select id, start_time__c, end_time__c from Influence_Parent__c where id = :ipID];
        } catch( Exception e ) {
            return;
        }
        
        for( sObject s : scope ) {
            // Post parent and createdby
            userIDs.add( string.valueof( s.get('parentid') ) );
            userIDs.add( string.valueof( s.get('createdbyid') ) );
            
            // Comment createdby
            if( s.getSObjects('FeedComments') != null )
                for( FeedComment fc : s.getSObjects('FeedComments') )
                    userIDs.add( fc.createdbyid );
        }
        
        Map<ID,User> us = new Map<ID,User> ([select id from User where id IN :userIDs and isactive=true and 
            ( usertype='Standard' or usertype='CSNOnly' ) ]);
                
            // Get the influence records for these contacts
        Influence__c[] infs = [select id, user__c, posts_created__c, posts_received__c, comments_created__c, comments_received__c, latest_comment__c, days_with_comments__c, likes_received__c
                from Influence__c
                where user__c IN :us.keySet()
                and influence_parent__c = :ipID];
            
        Map<ID, Influence__c> infMap = new Map<ID, Influence__c> ();
        
        for( Influence__c inf : infs )
            infMap.put( inf.user__c, inf );
            
        for( sObject s : scope ) {
            string parent = string.valueof( s.get('parentid') );
            string createdby = string.valueof( s.get('createdbyid') );
            integer likes = integer.valueof( s.get('likecount') );
            
            // If this is a post on a user, that user receives credit for a post received IFF he didn't create it
            if( parent != createdby && parent.substring( 0, 3 ) == userPrefix ) {
                if( !infMap.containsKey( parent ) && us.containsKey( parent ) )
                    infMap.put( parent, new Influence__c( influence_parent__c = ipID, 
                        user__c = parent ) );
                
                Influence__c inf = infMap.get( parent );
                
                if( inf != null ) {    
                    inf.posts_received__c = ( inf.posts_received__c == null || inf.posts_received__c == 0 ? 1 : inf.posts_received__c + 1 );
                    infMap.put( parent, inf );
                }
            }
            
            // The creator of this post receives credit for a post created and any likes on that post
            if( !infMap.containsKey( createdby ) && us.containsKey( createdby ) )
                infMap.put( createdby, new Influence__c( influence_parent__c = ipID, user__c = createdby ) );
            
            Influence__c inf = infMap.get( createdby );
            
            if( inf != null ) {
                inf.posts_created__c = ( inf.posts_created__c == null || inf.posts_created__c == 0 ? 1 : inf.posts_created__c + 1 );
                inf.likes_received__c = ( inf.likes_received__c == null || inf.likes_received__c == 0 ? likes : inf.likes_received__c + likes );
                
                if( likes > 0 )
                    inf.days_with_comments__c = ( inf.days_with_comments__c == null || inf.days_with_comments__c == 0 ? 1 : inf.days_with_comments__c + 1 );
                        
                infMap.put( createdby, inf );
            }
            
            // Examine the comments on this post
            if( s.getSobjects('FeedComments') != null)
                for( FeedComment fc : s.getSObjects('FeedComments') ) {
                    string commentCreatedBy = fc.createdbyid;
                    
                    // The creator of this comment receives credit for a comment created
                    if( !infMap.containsKey( commentCreatedby ) && us.containsKey( commentCreatedby ) )
                        infMap.put( commentCreatedBy, new Influence__c( influence_parent__c = ipID, 
                            user__c = commentCreatedBy ) );
                    
                    inf = infMap.get( commentCreatedBy );
                    
                    if( inf != null ) {
                        inf.comments_created__c = ( inf.comments_created__c == null || inf.comments_created__c == 0 ? 1 : inf.comments_created__c + 1 );   
                        infMap.put( commentCreatedBy, inf );
                    }
                    
                    // The creator of the parent post receives credit for a comment received IFF he didn't create it
                    if( commentCreatedBy != createdby && us.containsKey( createdby ) ) {
                        if( !infMap.containsKey( createdby ) )
                            infMap.put( createdby, new Influence__c( influence_parent__c = ipID, 
                                user__c = createdby ) );
                    
                        inf = infMap.get( createdby );                      
                        
                        if( inf != null ) {
                            inf.comments_received__c = ( inf.comments_received__c == null || inf.comments_received__c == 0 ? 1 : inf.comments_received__c + 1 );  
                            infMap.put( createdby, inf );
                            
                            datetime dt = datetime.valueof( s.get('createddate') );
                            date d = date.newinstance( dt.year(), dt.month(), dt.day() );
                            
                            if( inf.latest_comment__c == null || d < inf.latest_comment__c ) {
                                inf.latest_comment__c = d;
                                inf.days_with_comments__c = ( inf.days_with_comments__c == null || inf.days_with_comments__c == 0 ? 1 : inf.days_with_comments__c + 1 );
                            }
                        }
                    }
                }
        }
        
        try {
            upsert infMap.values();
        } catch( Exception e ) {
            failed = true;
        }
    }

    global void finish(Database.BatchableContext BC) {}
    
}