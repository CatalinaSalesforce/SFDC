trigger AfterInsertOpportunity on Opportunity (after insert, after update) {
	
	Boolean hasNewContract = false;
	Set<Id> oppCatInsert = new Set<Id>();
	Set<Id> oppCatDelete = new Set<Id>();
	
	system.debug('***Trigger.new.size: ' + Trigger.new.size());
	for (Opportunity o : Trigger.new){
		if (Trigger.isInsert){
			if (o.Related_Contract__c != null){
				hasNewContract = true;
				oppCatInsert.add(o.Related_Contract__c);
	    	}
		} else if (Trigger.isUpdate){
			if (o.Related_Contract__c != Trigger.oldMap.get(o.Id).Related_Contract__c){
				hasNewContract = true;
				oppCatInsert.add(o.Related_Contract__c);
				oppCatDelete.add(o.Id);
			} else if (o.StageName.contains('Closed Won')){
				oppCatDelete.add(o.Id);
			}
		}
	}
	
	if (oppCatDelete.size() > 0){
		List<Opportunity_Category__c> oppCatList = [SELECT ID, OPPORTUNITY__C, CATEGORY__C, CATEGORY__R.CATS_EXTERNAL_ID__C FROM OPPORTUNITY_CATEGORY__C
								WHERE OPPORTUNITY__C IN : oppCatDelete AND Opportunity_Category_External_Id__c = null];
		delete oppCatList;
	}
	
	if (hasNewContract){
		List<Opportunity_Category__c> insertOppCat = new List<Opportunity_Category__c>();
		List<Opportunity_Category__c> oppCatList = [SELECT ID, OPPORTUNITY__C, CATEGORY__C, CATEGORY__R.CATS_EXTERNAL_ID__C FROM OPPORTUNITY_CATEGORY__C WHERE OPPORTUNITY__C IN : oppCatInsert];
		for (Opportunity o: Trigger.new){
			for (Opportunity_Category__c oc : oppCatList){
				if (o.Related_Contract__c == oc.Opportunity__c){
					Opportunity_Category__c newOC = new Opportunity_Category__c();
					newOC.Opportunity__c = o.Id;
					newOC.Category__c = oc.Category__c;
					insertOppCat.add(newOC);
				}
			}
		}
		
		if (insertOppCat.size() > 0){
			insert insertOppCat;
		}
	}
	
	if (Trigger.isUpdate){
		Set<Id> oppEXTList = new Set<Id>();
		Map<Id, String> oppExtIDMap = new Map<Id, String>();
		//String contractRTID = [SELECT ID FROM RecordType Where Name = 'Contract' and SOBJECTTYPE = 'Opportunity'][0].Id;
		
		for (Opportunity o : Trigger.new){
			Opportunity newOpp = o;
			Opportunity oldOpp = Trigger.oldMap.get(o.Id);
			if (oldOpp.CATS_External_ID__c != newOpp.CATS_External_ID__c ){
				
				/*
			    if (newOpp.Type=='New'){
			        newOpp.StageName='Closed Won';
			    }
			    if (newOpp.Type=='Renewal'){
			        newOpp.StageName='Closed Won Renewal';
			    }
			    else if (newOpp.Type=='Addendum'){
			        newOpp.StageName='Closed Won Addendum';
			        newOpp.Probability=0;
			    }
			    newOpp.RecordTypeId = contractRTID;
			    newOpp.To_Be_Updated__c = true;*/
			    oppExtIDMap.put(o.Id, o.CATS_External_ID__c);
			    
			    oppEXTList.add(o.Id);
			}
		}
		if (oppEXTList.size() > 0){
			List<Program__c> programsEXT = [Select id,External_ID__c,Delivery_Type__c, Opportunity__c from Program__c p where p.Opportunity__c IN :oppEXTList];
		    for(Program__c program:programsEXT){
		        program.External_ID__c = oppExtIDMap.get(program.Opportunity__c)+program.Delivery_Type__c ;
		    }
		    update programsEXT;
		    
		    List<Program_Forecast__c> pfsEXT = [SELECT ID FROM PROGRAM_FORECAST__C WHERE Program__r.Opportunity__c IN : oppEXTList];
		    update pfsEXT;
		}
	}

}