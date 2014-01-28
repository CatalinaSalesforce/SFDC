trigger UserHierarchyUpdateSendEmail on User (after update, after insert) {

    List<String> toAddresses;
    List<Id> NewUsersList                 = new List<Id>();
    List<Id> ManagerIds                   = new List<Id>();    
    Map<Id,string> UserIdManagerNameMap   = new Map<Id,string>();  
    String strEmailBody                   = 'New Sales User(s) Details are - \n\n'; 
    
    // Get the list of Manager Ids for all users in the update call.
    List<User> UsersWithManager = [select id, name,ManagerId from User where Id IN :Trigger.newMap.keySet()];
    for (User u: UsersWithManager) {
        if(u.ManagerId != NULL)
            ManagerIds.add(u.ManagerId);
    }
    
    // Create a map of Id-Name mappings for all managers of users who are in the update call. 
    List<User> ManagerList = [SELECT Id, Name FROM User WHERE Id in :ManagerIds];
    for (User uManager : ManagerList) 
        UserIdManagerNameMap.put(uManager.Id, uManager.Name);
       
    for (User u : Trigger.new){
        if ((Trigger.IsUpdate && (Trigger.oldMap.get(u.Id).Forecast_Role__c == NULL && u.Forecast_Role__c != NULL)) ||
            (Trigger.IsInsert && u.Forecast_Role__c != NULL)){
            NewUsersList.add(u.Id);
            String sManagerName = UserIdManagerNameMap.get(u.ManagerId);
            strEmailBody +=  'Name                - ' + u.FirstName + ' ' + u.LastName + '\nManager          - ' + sManagerName + '\nForecast Role - ' + u.Forecast_Role__c + '\n\n';            
        }
    }
   
    strEmailBody += 'Thank you,\nSFDC Team';
       
    if (NewUsersList.size() > 0){          
        //Send Email with list of deactivated users. 
        Messaging.reserveSingleEmailCapacity(1);      // Reserve email capacity.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();            
        
        Admin_Email_Settings__c emailSettings = Admin_Email_Settings__c.getValues('Default');
        if(emailSettings != NULL){         
            if (emailSettings.Email_Alert_For_Sales_User_Added__c != null)
                toAddresses = emailSettings.Email_Alert_For_Sales_User_Added__c.split(';');       
            mail.setToAddresses(toAddresses);      
            mail.setSubject('New Sales User Added in Salesforce');  // Specify the subject line for your email address.    
            mail.setPlainTextBody(strEmailBody);  // Specify the subject line for your email address.              
            try{
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
            catch(Exception ex){
                if(Trigger.new.size() == 1)
                    Trigger.new[0].addError('Email To CATS could not be sent for the sales user added. Please check email address.');
                System.debug('Mail could not be sent. Please check');
            }
        }
    }  
    
}