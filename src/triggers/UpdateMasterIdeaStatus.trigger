trigger UpdateMasterIdeaStatus on IdeaTracker__c (after update) {

    for (IdeaTracker__c newIdeaTracker : Trigger.new) {       
           IdeaTracker__c oldIdeaTracker = Trigger.oldMap.get(newIdeaTracker.Id);
           if(newIdeaTracker.Status__c != oldIdeaTracker.Status__c){
           
               try{
                   Idea theIdea = [Select Id, Status from Idea where Id = :newIdeaTracker.Master_Idea__c LIMIT 1];
                   
                   if(theIdea != NULL) {
                       theIdea.Status = newIdeaTracker.Status__c;
                       update theIdea;
                   }
              }
              catch(Exception ex){
                  System.debug('Could not update Master Idea.' );
              }
               
           }    
    }
}