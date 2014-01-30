trigger OB_Candidate_Status_Change on Candidate_Status__c (before update, before insert) {
	//Assign the context before and after the change into variables
	Candidate_Status__c newStatus = Trigger.new[0];
	System.debug('@@@@@@@@@@@@@@@@@'+newStatus.Initial_Confidentiality_Agreement__c);
	if ( Trigger.old != null){
		Candidate_Status__c oldStatus = Trigger.old[0];
		System.debug('@@@@@@@@@@@@@@@@@'+oldStatus.Initial_Confidentiality_Agreement__c);
		if (newStatus.Initial_Confidentiality_Agreement__c<>oldStatus.Initial_Confidentiality_Agreement__c){
			newStatus.Confidentiality_Sign_Date__c = Date.today();
		}
		if (newStatus.Initial_Ethics_Form__c<> oldStatus.Initial_Ethics_Form__c){
			newStatus.Ethics_Sign_Date__c = Date.today();
		}
		if (newStatus.Initial_Assurance_Form__c<> oldStatus.Initial_Assurance_Form__c){
			newStatus.Assurance_Sign_Date__c = Date.today();
		}
		if (newStatus.Initial_Associate_Handbook__c<> oldStatus.Initial_Associate_Handbook__c){
			newStatus.Handbook_Sign_Date__c = Date.today();
		}
	} else {
		if (newStatus.Initial_Confidentiality_Agreement__c<> null){
		  newStatus.Confidentiality_Sign_Date__c = Date.today();
		}
		if (newStatus.Initial_Ethics_Form__c<> null){
		  newStatus.Ethics_Sign_Date__c = Date.today();
		}
		if (newStatus.Initial_Assurance_Form__c<> null){
		  newStatus.Assurance_Sign_Date__c = Date.today();
		}
		if (newStatus.Initial_Associate_Handbook__c<> null){
		  newStatus.Handbook_Sign_Date__c = Date.today();
		}
	}
}