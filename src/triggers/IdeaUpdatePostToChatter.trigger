trigger IdeaUpdatePostToChatter on Idea (after update) {

   User theUser;    
   string strEmailBody;
    
   try{
        theUser = [Select Id from User where username='salesforceadmin@catalinamarketing.com' LIMIT 1];
   }
   catch(Exception ex){
       System.debug('Username not found');
   }
   
   for (Idea newIdea : Trigger.new) {
   
       Idea oldIdea = Trigger.oldMap.get(newIdea.ID);
              
       if((newIdea.Status != oldIdea.Status) && ((newIdea.Status == 'Submitted') || (newIdea.Status == 'In Review') || (newIdea.Status == 'Promoted') || (newIdea.Status == 'Executed'))){
           FeedItem post = new FeedItem();
           post.ParentId = newIdea.CreatedById; 
           post.Body = 'Your Idea - \'' + newIdea.Title + '\' has changed Status from \'' + oldIdea.Status + '\' to ' + '\'' + newIdea.Status + '\'.';           
           if((theUser != NULL) && (theUser.Id != NULL))
               post.CreatedById = theUser.Id;
           insert post;
       }
       
       if(newIdea.NumComments > oldIdea.NumComments) {
           FeedItem post = new FeedItem();
           post.ParentId = newIdea.CreatedById; 
           post.Body = 'You have a new comment on your Idea - ' + newIdea.Title + '.' + '\nIdea details can be found at - ' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + newIdea.Id;
           if((theUser != NULL) && (theUser.Id != NULL))
               post.CreatedById = theUser.Id;
           insert post;
           
            //Send Email with list of deactivated users. 
            Messaging.reserveSingleEmailCapacity(1);      // Reserve email capacity.
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();            
            
            try{
                User theIdeaOwner = [Select Id,Email from User where Id =:newIdea.CreatedById LIMIT 1]; 
                
                IdeaComment theComment = [Select commentBody, CreatedById from IdeaComment where Id =: newIdea.LastCommentId LIMIT 1];
                User theCommentOwner = [Select Id,FirstName, LastName from User where Id =: theComment.CreatedById LIMIT 1];
                
                if(theIdeaOwner.Email != NULL){
                    String[] toAddresses = new String[] {theIdeaOwner.Email};         
                    mail.setToAddresses(toAddresses); 
                    
                    OrgWideEmailAddress owa = [select id from OrgWideEmailAddress where DisplayName = 'Catalina Innovation' LIMIT 1];      
                    mail.setOrgWideEmailAddressId(owa.Id);
                    mail.setSubject('New comment on your Idea - ' + newIdea.Title);  // Specify the subject line for your email.   
                                        
                    strEmailBody = 'You have a new comment on your idea posted by ' + theCommentOwner.FirstName + ' ' + theCommentOwner.LastName + ' :\n' + theComment.CommentBody + '\n\nIdea details can be found at - ' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + newIdea.Id + '\n\n' + 'Thank you,\nCatalina Innovation Team.';
                    mail.setPlainTextBody(strEmailBody);             
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
               }
            }
            catch(Exception ex){
               System.debug('User Id not found');
            }          
       }
       
       if((newIdea.Status != oldIdea.Status) || (newIdea.Body != oldIdea.Body) || (newIdea.Categories != oldIdea.Categories) || (newIdea.VoteTotal != oldIdea.VoteTotal)){
           try{
               IdeaTracker__c theIdeaTracker = [Select id,Name,Description__c,Status__c,Categories__c,Total_Votes__c FROM IdeaTracker__c where Master_Idea__c = :newIdea.Id LIMIT 1];
               if(theIdeaTracker != NULL) {
                   theIdeaTracker.Description__c = newIdea.Body;
                   theIdeaTracker.Status__c = newIdea.Status;
                   theIdeaTracker.Categories__c = newIdea.Categories;
                   theIdeaTracker.Total_Votes__c = newIdea.VoteTotal;
                   update theIdeaTracker ;  
               }
           }
           catch(Exception ex){
              System.debug('Could not update the Idea Tracker.');
           }
      }
   } 
}