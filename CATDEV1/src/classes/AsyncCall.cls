public class AsyncCall {
	final static String defaultSettingsName = 'Default';
	@future
	public static void updateOpps(Set<Id> deactivatedUsers1){
		Catalina_Forecast_Settings__c settings = Catalina_Forecast_Settings__c.getInstance(defaultSettingsName);
		String coopType = settings.Coop_String__c;
		String coopId;
		Map<Id, Id> userManagerMap = new Map<Id, Id>();
		List<User> userList = [SELECT ID, MANAGERID, FORECAST_ROLE__C FROM USER];
		for (User u : userList){
			if (u.ManagerId != null){
				userManagerMap.put(u.Id, u.ManagerId);
			}
			if (u.Forecast_Role__c == coopType) coopId = u.Id;
		}
		List<Opportunity> opps = [SELECT ID, OWNERID, RecordType.Name FROM OPPORTUNITY
			WHERE OWNERID IN :deactivatedUsers1];
			
		for (Opportunity o : opps){
			if (o.RecordType.Name.contains('Contract')){
				if (userManagerMap.containsKey(o.OwnerId)){
					o.OwnerId = userManagerMap.get(o.OwnerId);
				}
			} else {
				o.OwnerId = coopId;
			}
		}
		
		update opps;
	}
	
	/*
	@future
	public static void insertPFE(Set<Id> userSet){
		List<Program_Forecast_Exception__c> insertPFE = new List<Program_Forecast_Exception__c>();
		for (String id : userSet){
			Program_Forecast_Exception__c newPFE = new Program_Forecast_Exception__c();
			newPFE.User__c = id;
			newPFE.Reason__c = 'Inactive User owns an Opportunity';
			insertPFE.add(newPFE);
		}
		
		insert insertPFE;
		
	}*/
}