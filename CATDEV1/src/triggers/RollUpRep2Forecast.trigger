trigger RollUpRep2Forecast on Rep_2_Forecast__c (after update) {
	
	Set<Id> updateList = new Set<Id>();
	Map<Id, Rep_1_Forecast__c> updateMap = new Map<Id, Rep_1_Forecast__c>(); 
	
	for (Rep_2_Forecast__c a : Trigger.new){
		updateList.add(a.Manager_Forecast__c);
	}
	
	List<Rep_1_Forecast__c> updateForecast = [Select Id, Team_Actual_Amount_Trg__c, Team_Forecast_Proposal_Trg__c, Team_Forecast_Contract_Trg__c,
										Team_Weighted_Forecast_Proposal_Trg__c From Rep_1_Forecast__c Where Id IN :updateList];
										
	for (Rep_1_Forecast__c a : updateForecast){
		updateMap.put(a.Id, a);
	}
	
	for (Rep_2_Forecast__c a : Trigger.new){
		Rep_1_Forecast__c parent = updateMap.get(a.Manager_Forecast__c);
		if (Trigger.isInsert){
			parent.Team_Actual_Amount_Trg__c += a.Actual_Amount__c;
			parent.Team_Forecast_Contract_Trg__c += a.Forecast_Contract__c;
			parent.Team_Forecast_Proposal_Trg__c += a.Forecast_Proposal__c;
			parent.Team_Weighted_Forecast_Proposal_Trg__c += a.Weighted_Forecast_Proposal__c;
		} else if (Trigger.isUpdate){
			parent.Team_Actual_Amount_Trg__c += (a.Actual_Amount__c - Trigger.oldMap.get(a.Id).Actual_Amount__c);
			parent.Team_Forecast_Contract_Trg__c += (a.Forecast_Contract__c - Trigger.oldMap.get(a.Id).Forecast_Contract__c);
			parent.Team_Forecast_Proposal_Trg__c += (a.Forecast_Proposal__c - Trigger.oldMap.get(a.Id).Forecast_Proposal__c);
			parent.Team_Weighted_Forecast_Proposal_Trg__c += (a.Weighted_Forecast_Proposal__c - Trigger.oldMap.get(a.Id).Weighted_Forecast_Proposal__c);
		}
	}
	
	update updateForecast;

}