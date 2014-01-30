trigger NewIdeaPostToChatter on Idea (after insert) {

    User theUser;     
    try{
         theUser = [Select Id from User where username='salesforceadmin@catalinamarketing.com' LIMIT 1];
    }
    catch(Exception ex){
        System.debug('Username not found');
    }
   
    for (Idea newIdea : Trigger.new) {
    
    if(newIdea.Status == 'Submitted'){
           FeedItem post = new FeedItem();
           post.ParentId = newIdea.CreatedById; 
           post.Body = 'Your Idea - \'' + newIdea.Title + '\' has been submitted for review!';  
           if((theUser != NULL) && (theUser.Id != NULL))
               post.CreatedById = theUser.Id;         
           insert post;
       }
       
    try{
        IdeaTracker__c newIdeaTracker = new  IdeaTracker__c();
        newIdeaTracker.Master_Idea__c = newIdea.Id;
        newIdeaTracker.Description__c = newIdea.Body;
        newIdeaTracker.Status__c = newIdea.Status;
        newIdeaTracker.Categories__c = newIdea.Categories;
        newIdeaTracker.Total_Votes__c = newIdea.VoteTotal;
        insert newIdeaTracker;  
    }
    catch(Exception ex){
        System.debug('Could not create Idea Tracker record.');
    }
       
   } 
}