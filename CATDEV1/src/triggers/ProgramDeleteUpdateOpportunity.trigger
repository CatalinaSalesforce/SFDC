/*
Update Opportunity.Catalina_Business_Unit__c after program delete

Author: Matt
Email: matt@cloud62.com
*/
trigger ProgramDeleteUpdateOpportunity on Program__c (after delete) {
    Set<Id> opptyIds = new Set <Id>();
    String tempString;
    List<String> splitCBU;
    Opportunity o;
    for ( Program__c p: Trigger.old){
       system.debug('PDUO'+p.Name + p.Delivery_Type__c);
        opptyIds.add(p.Opportunity__c);
    }
	Map<Id, Opportunity> opptys = new Map<Id, Opportunity >([ select id, Catalina_Business_Unit__c from Opportunity where id in :opptyIds]);
	system.debug(opptys.size() + ' items in opptysMap');

	for(Program__c p : Trigger.old){
		o = opptys.get(p.Opportunity__c);
		 if (o.Catalina_Business_Unit__c != null && o.Catalina_Business_Unit__c.contains(p.Delivery_Type__c)){
            system.debug('going to remove ' + p.Delivery_Type__c);
			splitCBU = o.Catalina_Business_Unit__c.split( ';' );
            system.debug('splitcbu size before: ' +splitCBU.size());
            for (Integer i = 0; i < splitCBU.size(); i++){
                   if (splitCBU.get(i) == p.Delivery_Type__c){
                         system.debug('removing ' +splitCBU.get(i));
                        splitCBU.remove(i);
                        
                  }
                  
            }
            system.debug('splitcbusize after' +splitCBU.size());
            if(splitCBU.size() == 0){
            	o.Catalina_Business_Unit__c = '';
            }else if (splitCBU.size() == 1){
                  o.Catalina_Business_Unit__c = splitCBU.get(0);
                   system.debug('new business unit value ' + o.Catalina_Business_Unit__c);
            } else {
                  tempString = splitCBU.get(0) + ';';
                  for(Integer i = 1; i < splitCBU.size(); i++){
                  	tempString += splitCBU.get(i) + ';';
                  	system.debug('['+i+']'+tempString);
                  }
                   //remove last semicolon? terrible hack
                  tempString = tempString.substring(0,tempString.length());
                   
                  o.Catalina_Business_Unit__c = tempString;
                  system.debug(o.Catalina_Business_Unit__c);
            }
            update o;
			
		}
	}

}