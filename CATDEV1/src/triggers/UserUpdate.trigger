/*
Write a trigger on update user to verify that the user's manager has a forecast role above their own
-"coop" user forecast role should be considered the same as "SM1" for this task
-create an override checkbox field that when true does not validate
-on error, block update and display error message


Author: Matt
Email: matt@cloud62.com

*/

trigger UserUpdate on User (before update) {

	final static String defaultSettingsName = 'Default';
	
	Catalina_Forecast_Settings__c settings = Catalina_Forecast_Settings__c.getInstance(defaultSettingsName);
	if (settings != null){
	    String rep2Type = settings.Rep_2_String__c;
	    String rep1Type = settings.Rep_1_String__c;
	    String SM2Type = settings.SM_2_String__c;
	    String SM1Type = settings.SM_1_String__c;
	    String coopType = settings.Coop_String__c;
		
		List<User> users = [select Id, Forecast_Role__c, Forecast_Role_Override__c, ManagerId from User];
		Map<Id, User> userMap = new Map<Id, User>();
		User tmpManager;
		for(User u : users){
			userMap.put(u.Id, u);
		}
	
	
		for (User u : trigger.new){
			if(u.Forecast_Role__c != null && u.Forecast_Role_Override__c == false ){
				if(u.ManagerId != null){
					//get user from map that has the manager id
					tmpManager = userMap.get(u.ManagerId);
					system.debug(tmpManager);
					if(u.Forecast_Role__c == rep2Type){
						if(tmpManager.Forecast_Role__c == rep1Type){
							//allow update
						} else{
							u.addError('This SR2 user has a manager who does not have a SR1 role.');
						}
					} else if (u.Forecast_Role__c == rep1Type){
						if(tmpManager.Forecast_Role__c == SM2Type){
							//allow update
						} else{
							u.addError('This SR1 user has a manager who does not have a SM2 role.');
						}
					} else if (u.Forecast_Role__c == SM2Type){
						if(tmpManager.Forecast_Role__c == SM1Type || tmpManager.Forecast_Role__c == coopType){
							//allow update
						} else{
							u.addError('This SM2 user has a manager who does not have a SM1 or coop role.');					}
					} else if (u.Forecast_Role__c == SM1Type || u.Forecast_Role__c == coopType){
						if(tmpManager.Forecast_Role__c == 'EVP'){
							//allow update
						} else{
							u.addError('This SM1 or coop user has a manager who does not have a EVP role.');
						}
					} else if (u.Forecast_Role__c == 'EVP'){
						//already checked for null managers at the top so do nothing			
					} else {
				 		u.addError('Invalid role.');
					}
				} else {
					//user does not have a manager
					u.addError('Please define a manager.');
				}	
			} else {
				// user does not have forecast role or override checked
				if(u.Forecast_Role_Override__c){
					//do nothing	
				} else {
					if (userMap.containsKey(u.ManagerId)){ //added by Warren to solve NPE
						tmpManager = userMap.get(u.ManagerId);
						if(tmpManager.Forecast_Role__c != null){
							u.addError('This user must have a forecast role if their manager has a forecast role.');
						}
					}
				}
			}
	
		}

	}

}