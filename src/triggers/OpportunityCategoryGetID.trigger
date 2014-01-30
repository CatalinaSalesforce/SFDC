trigger OpportunityCategoryGetID on Opportunity_Category__c (before insert) {
	
	Set<String> productExtIDs = new Set<String>();
	Set<String> opptyExtIDs = new Set<String>();
	Map<String, Id> productMap = new Map<String, Id>();
	Map<String, Id> opptyMap = new Map<String, Id>();
	for (Opportunity_Category__c a : Trigger.new){
		if (a.Category_External_ID__c != null) productExtIDs.add(a.Category_External_ID__c);
		if (a.Opportunity_External_ID__c != null) opptyExtIDs.add(a.Opportunity_External_ID__c);
	}
	
	List<Product2> productList = [SELECT ID, CATS_External_ID__c FROM PRODUCT2 WHERE CATS_External_ID__c IN: productExtIDs];
	for (Product2 a : productList){
		productMap.put(a.CATS_External_ID__c, a.Id);
	}
	
	List<Opportunity> opptyList = [SELECT ID, CATS_External_ID__c FROM OPPORTUNITY WHERE CATS_External_ID__c IN: opptyExtIDs];
	for (Opportunity a : opptyList){
		opptyMap.put(a.CATS_External_ID__c, a.Id);
	}
	
	for (Opportunity_Category__c o : Trigger.new){
		system.debug(LoggingLevel.WARN, '***Category: ' + o.Category__c);
		system.debug(LoggingLevel.WARN, '***Opportunity: ' + o.Opportunity__c);
		if (o.Category__c == null) o.Category__c = productMap.get(o.Category_External_ID__c);
		if (o.Opportunity__c == null) o.Opportunity__c = opptyMap.get(o.Opportunity_External_ID__c);
		if (o.Opportunity__c == null || o.Category__c == null){
			o.addError('Could not find Category or Opportunity External Id');
		}
	}

}