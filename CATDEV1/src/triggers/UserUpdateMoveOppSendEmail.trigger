trigger UserUpdateMoveOppSendEmail on User (after update) {
    
    Set<Id> deactivatedUsers = new Set<Id>();
    String strEmailBody = 'Users deactivated are : ';
    
    for (User u : Trigger.new){
        if (Trigger.oldMap.get(u.Id).isActive == true && u.isActive == false){
            deactivatedUsers.add(u.Id);
            strEmailBody += u.FirstName + ' ' + u.LastName + '(' + u.Forecast_Role__c + ') ';
        }
    }
    
    if (deactivatedUsers.size() > 0){
        List<User> oppOwners = [SELECT ID FROM USER WHERE ID IN (SELECT OWNERID FROM OPPORTUNITY) AND ID IN :deactivatedUsers];
        if (oppOwners.size() > 0){
            AsyncCall.updateOpps(deactivatedUsers);
        }
        
        //Send Email with list of deactivated users. 
        Messaging.reserveSingleEmailCapacity(1);      // Reserve email capacity.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();            
        
        Admin_Email_Settings__c emailSettings = Admin_Email_Settings__c.getValues('Default');
        if(emailSettings != NULL){        
            String[] toAddresses = new String[] {emailSettings.Email_alert_address__c};         
            mail.setToAddresses(toAddresses);      
            mail.setSubject('Deactivated Users in Salesforce');  // Specify the subject line for your email address.    
            mail.setPlainTextBody(strEmailBody);  // Specify the subject line for your email address.              
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }   
    
}