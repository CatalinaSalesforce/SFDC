trigger AssignAccountOwner on Account (before insert) {

    // Assign Jamie as the owner for all accounts that do not have an owner specified.
    
    // Get the Id for user - Jamie Egasti.
    User uDefaultAccOwner;
    User uIntUser;
    
    try{
    
        Catalina_Forecast_Settings__c setting = Catalina_Forecast_Settings__c.getInstance('Default');
        Id intUserId = NULL;
        if(setting != NULL){
            if(setting.Default_Account_Owner_ExtId__c != NULL){
                uDefaultAccOwner = [SELECT Id, Name from User where ExtID__c = :setting.Default_Account_Owner_ExtId__c LIMIT 1];
            }
            intUserId = setting.Integration_User_Id__c; 
        }    
        if(uDefaultAccOwner != NULL && intUserId != NULL){
        
            RecordType rtMfg = [select Id,Name from RecordType where Name = 'Manufacturing' and SobjectType = 'Account' LIMIT 1];
            RecordType rtRtl = [select Id,Name from RecordType where Name = 'Retail' and SobjectType = 'Account' LIMIT 1];
            
            // Assign this id for all accounts with empty owner.
            for (Account acct : Trigger.new){   
              if((acct.OwnerId == intUserId) && (acct.RecordTypeId == rtMfg.Id || acct.RecordTypeId == rtRtl.Id)){      
                System.debug('Inside if');
                acct.OwnerId = uDefaultAccOwner.Id;
              }
            }
        }
    }
    
    catch(Exception ex){    
        System.debug(ex.getStackTraceString());
        System.debug('Could not assign default account owner.');
    }
}