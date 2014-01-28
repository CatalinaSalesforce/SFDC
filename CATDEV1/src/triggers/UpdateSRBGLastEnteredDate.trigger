trigger UpdateSRBGLastEnteredDate on Sales_Rep_Best_Guess__c (before update) {
	
	String x = [SELECT ID FROM PROFILE WHERE NAME = 'System Administrator'][0].Id;
	
	for (Sales_Rep_Best_Guess__c a : Trigger.new){
		if (UserInfo.getProfileId() != x){
			a.Last_Entered_Date__c = Date.Today();
			a.Last_Entered_User__c = UserInfo.getUserId();			
		}
	}

}