/** This trigger prevents a user from deleteing a Program if the associated Opportunity has a 
*   Catalina Business Unit value setup for the program
*
*/
trigger PreventProgramDeletion on Program__c (before delete) {
   //Modified to prevent the deletion of Programs with Record Type 'contract'
   
    /*
    Set<Id> opptyIds = new Set<Id>();
    for (Program__c p: Trigger.old){
        opptyIds.add(p.Opportunity__c);
    }
    
    Map<Id,Opportunity> opptys = new Map<Id, Opportunity>([select id, Catalina_Business_Unit__c from Opportunity where id in :opptyIds]);
    
    for (Program__c p: Trigger.old){
        Opportunity o = opptys.get(p.Opportunity__c);
        if (o.Catalina_Business_Unit__c != null && o.Catalina_Business_Unit__c.contains(p.Delivery_Type__c)){
            p.addError('Hey! Sorry, but you cant delete a Program since the Opportunity still has a Catalina Business Unit: ' + p.Delivery_Type__c);
        }
    }
  */  
	Set<Id> rtIds = new Set<Id>();
	RecordType rtype;
	for(Program__c p : Trigger.old){
		rtIds.add(p.RecordTypeId);
	}
	Map<Id, RecordType> rtMap = new Map<Id, RecordType>([select Id, Name from RecordType where Id in :rtIds]);

	for(Program__c p : Trigger.old){
		rtype = rtMap.get(p.RecordTypeId);
		if(rtype.Name == 'Contract'){
			p.addError('You cannot delete programs with a Record Type of \'Contract\'');
		}
	}

}