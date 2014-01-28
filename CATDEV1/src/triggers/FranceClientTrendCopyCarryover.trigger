trigger FranceClientTrendCopyCarryover on France_Client_Trend__c (after insert, after update) {

	Set<Id> fctSet = new Set<Id>();
	Map<Id, France_Client_Trend__c> childFCTMap = new Map<Id, France_Client_Trend__c>();
	
	for (France_Client_Trend__c a : Trigger.new){
		fctset.add(a.Id);
		childFCTMap.put(a.Id, a);
	}
	
	List<France_Client_Trend__c> fctList = [SELECT ID, CARRYOVER__C, BOOKED__C, Last_Month__c FROM France_Client_Trend__c
		WHERE Last_Month__c IN : fctSet];
	
	List<France_Client_Trend__c> updateFCT = new List<France_Client_Trend__c>();
	
	for (France_Client_Trend__c a : fctList){
		//if (a.Carryover__c != a.Booked__c + childFCTMap.get(a.Last_Month__c).Carryover__c){
			a.Carryover__c = a.Booked__c + childFCTMap.get(a.Last_Month__c).Carryover__c;
			updateFCT.add(a);
		//}
	}
	
	update fctList;

}