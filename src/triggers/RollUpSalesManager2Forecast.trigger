trigger RollUpSalesManager2Forecast on Sales_Manager_2_Forecast__c (after update) {
	
	Set<Id> updateList = new Set<Id>();
	Map<Id, Sales_Manager_1_Forecast__c> updateMap = new Map<Id, Sales_Manager_1_Forecast__c>(); 
	
	for (Sales_Manager_2_Forecast__c a : Trigger.new){
		updateList.add(a.Manager_Forecast__c);
	}
	
	List<Sales_Manager_1_Forecast__c> updateForecast = [Select Id, Team_Actual_Amount_Trg__c, Team_Forecast_Proposal_Trg__c, Team_Forecast_Contract_Trg__c,
										Team_Weighted_Forecast_Proposal_Trg__c From Sales_Manager_1_Forecast__c Where Id IN :updateList];
										
	for (Sales_Manager_1_Forecast__c a : updateForecast){
		updateMap.put(a.Id, a);
	}
	
	for (Sales_Manager_2_Forecast__c a : Trigger.new){
		Sales_Manager_1_Forecast__c parent = updateMap.get(a.Manager_Forecast__c);
		if (Trigger.isInsert){
			parent.Team_Actual_Amount_Trg__c += a.Total_Actual_Amount__c;
			parent.Team_Forecast_Contract_Trg__c += a.Total_Forecast_Contract__c;
			parent.Team_Forecast_Proposal_Trg__c += a.Total_Forecast_Proposal__c;
			parent.Team_Weighted_Forecast_Proposal_Trg__c += a.Total_Weighted_Forecast_Proposal__c;
		} else if (Trigger.isUpdate){
			parent.Team_Actual_Amount_Trg__c += (a.Total_Actual_Amount__c - Trigger.oldMap.get(a.Id).Total_Actual_Amount__c);
			parent.Team_Forecast_Contract_Trg__c += (a.Total_Forecast_Contract__c - Trigger.oldMap.get(a.Id).Total_Forecast_Contract__c);
			parent.Team_Forecast_Proposal_Trg__c += (a.Total_Forecast_Proposal__c - Trigger.oldMap.get(a.Id).Total_Forecast_Proposal__c);
			parent.Team_Weighted_Forecast_Proposal_Trg__c += (a.Total_Weighted_Forecast_Proposal__c - Trigger.oldMap.get(a.Id).Total_Weighted_Forecast_Proposal__c);
		}
	}
	
	update updateForecast;

}