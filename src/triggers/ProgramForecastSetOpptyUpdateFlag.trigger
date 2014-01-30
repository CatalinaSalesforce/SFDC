trigger ProgramForecastSetOpptyUpdateFlag on Program_Forecast__c (after insert, after update, after delete) {
	
	Set<Id> opptyList = new Set<Id>();
	
	if (Trigger.isDelete){
		for(Program_Forecast__c a : Trigger.old){
			opptyList.add(a.Program__r.Opportunity__c);
		}
		
	}else {
		for(Program_Forecast__c a : Trigger.new){
			opptyList.add(a.Program__r.Opportunity__c);
		}
	}
	
	List<Opportunity> toUpdate = [SELECT Id, To_Be_Updated__c From Opportunity Where Id IN: opptyList];
	
	for (Opportunity o : toUpdate){
		o.To_Be_Updated__c = true;
	}
	
	update toUpdate;

}