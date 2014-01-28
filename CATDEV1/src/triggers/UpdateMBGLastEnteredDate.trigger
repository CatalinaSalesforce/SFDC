trigger UpdateMBGLastEnteredDate on Manager_Best_Guess__c (before update) {
	
	String x = [SELECT ID FROM PROFILE WHERE NAME = 'System Administrator'][0].Id;
	
	for (Manager_Best_Guess__c a : Trigger.new){
		if (UserInfo.getProfileId() != x){
			a.Last_Entered_Date__c = Date.Today();	
			a.Last_Entered_User__c = UserInfo.getUserId();	
		}
		if(
			(a.Override_Team_Manu_Base_Best_Guess__c == 0|| a.Override_Team_Manu_Base_Best_Guess__c == null)
			&& (a.Override_Team_Manu_Base_High__c == 0|| a.Override_Team_Manu_Base_High__c == null)
			&& (a.Override_Team_Manu_Base_Low__c == 0|| a.Override_Team_Manu_Base_Low__c == null)
			&& (a.Override_Team_Manu_Digital_Best_Guess__c == 0|| a.Override_Team_Manu_Digital_Best_Guess__c == null)
			&& (a.Override_Team_Manu_Digital_High__c == 0|| a.Override_Team_Manu_Digital_High__c == null)
			&& (a.Override_Team_Manu_Digital_Low__c == 0|| a.Override_Team_Manu_Digital_Low__c == null)
			&& (a.Override_Team_Retail_Base_Best_Guess__c == 0|| a.Override_Team_Retail_Base_Best_Guess__c == null)
			&& (a.Override_Team_Retail_Base_High__c == 0|| a.Override_Team_Retail_Base_High__c == null)
			&& (a.Override_Team_Retail_Base_Low__c == 0|| a.Override_Team_Retail_Base_Low__c == null)
			&& (a.Override_Team_Retail_Digital_Best_Guess__c	 == 0|| a.Override_Team_Retail_Digital_Best_Guess__c	 == null)
			&& (a.Override_Team_Retail_Digital_High__c == 0|| a.Override_Team_Retail_Digital_High__c == null)
			&& (a.Override_Team_Retail_Digital_Low__c == 0|| a.Override_Team_Retail_Digital_Low__c == null)
			&& (a.Override_Team_Manu_Audience_Best_Guess__c == 0|| a.Override_Team_Manu_Audience_Best_Guess__c == null)
			&& (a.Override_Team_Manu_Audience_High__c == 0|| a.Override_Team_Manu_Audience_High__c == null)
			&& (a.Override_Team_Manu_Audience_Low__c == 0|| a.Override_Team_Manu_Audience_Low__c == null)
			&& (a.Override_Team_Manu_Mobile_Best_Guess__c == 0|| a.Override_Team_Manu_Mobile_Best_Guess__c == null)
			&& (a.Override_Team_Manu_Mobile_High__c == 0|| a.Override_Team_Manu_Mobile_High__c == null)
			&& (a.Override_Team_Manu_Mobile_Low__c == 0|| a.Override_Team_Manu_Mobile_Low__c == null)
			&& (a.Override_Team_Retail_Audience_Best_Guess__c == 0|| a.Override_Team_Retail_Audience_Best_Guess__c == null)
			&& (a.Override_Team_Retail_Audience_High__c == 0|| a.Override_Team_Retail_Audience_High__c == null)
			&& (a.Override_Team_Retail_Audience_Low__c == 0|| a.Override_Team_Retail_Audience_Low__c == null)
			&& (a.Override_Team_Retail_Mobile_Best_Guess__c	 == 0|| a.Override_Team_Retail_Mobile_Best_Guess__c	 == null)
			&& (a.Override_Team_Retail_Mobile_High__c == 0|| a.Override_Team_Retail_Mobile_High__c == null)
			&& (a.Override_Team_Retail_Mobile_Low__c == 0|| a.Override_Team_Retail_Mobile_Low__c == null)
			){
				a.Use_Override__c = false;
			} else {
				a.Use_Override__c = true;
			}
	}

}