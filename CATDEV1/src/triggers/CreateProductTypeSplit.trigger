/*
Trigger to create and update Product Type Splits based on Programs.
Behavior:
1. When a new Program is made, Product Type Splits are created and the percentage is shared evenly
2. When a record is updated, removed picklist values will have their respective Product Type Split removed and added picklist values
	will result in new records with 0 as the percentage.
	
Author: Warren
Email: warren@cloud62.com
*/
trigger CreateProductTypeSplit on Program__c (after insert, before update) {
	
	//if transaction is an insert
	if (Trigger.isInsert){
		List<Product_Type_Split__c> insertPTS = new List<Product_Type_Split__c>();
		
		for (Program__c a : trigger.new){
			if (a.Product_Type__c != null){
				//split the multi-select picklist values into an array
				String[] productTypes = a.Product_Type__c.split(';');
				for (String product : productTypes){
					//create a new Product Type Split for each selection
					Product_Type_Split__c x = new Product_Type_Split__c();
					x.Program__c = a.Id;
					x.Product_Type__c = product;
					x.Percent__c = (100.00/productTypes.size()).setScale(2);
					system.debug('*** assigning percent: ' + x.Percent__c);
					insertPTS.add(x);
				}
			}
		}
		
		insert insertPTS;
	}
	//if transaction is an update
	else if (Trigger.isUpdate){
		boolean changedPTS = false;
		for (Program__c p : Trigger.new){
			if (p.Product_Type__c != Trigger.oldMap.get(p.Id).Product_Type__c){
				changedPTS = true;
			}
		}
		if (changedPTS){
			//declare variables
			List<Product_Type_Split__c> insertPTS = new List<Product_Type_Split__c>();
			List<Product_Type_Split__c> deletePTS = new List<Product_Type_Split__c>();
			Set<Id> programList = new Set<Id>();
			Map<Id, Map<String, Product_Type_Split__c>> ptsMap = new Map<Id, Map<String, Product_Type_Split__c>>();
			
			//get list of programd updated
			for (Program__c a : Trigger.new){
				programList.add(a.Id);
			}
			
			//create map of Programs and their Product Type Splits
			for (Product_Type_Split__c a : [Select ID, Program__c, Product_Type__c From Product_Type_Split__c Where Program__c IN :programList]){
				if (!ptsMap.containsKey(a.Program__c)){
					ptsMap.put(a.Program__c, new Map<String, Product_Type_Split__c>());
				}
				ptsMap.get(a.Program__c).put(a.Product_Type__c, a);
			}
			
			for (Program__c a : Trigger.new){
				Set<String> newTypes = new Set<String>();
				Set<String> oldTypes = new Set<String>();
				String[] productTypes;
				
				//get the new picklist values
				if (a.Product_Type__c != null){
					productTypes = a.Product_Type__c.split(';');
					for (String product : productTypes){
						newTypes.add(product);
					}
				}
				
				//get the old picklist values
				if (trigger.oldMap.get(a.Id).Product_Type__c != null){
					productTypes = trigger.oldMap.get(a.Id).Product_Type__c.split(';');
					for (String product : productTypes){
						oldTypes.add(product);
					}
				}
				
				//find the picklist values that were removed and delete the records
				for (String x : oldTypes){
					if (!newTypes.contains(x)){
						if (ptsMap.containsKey(a.Id)){
							if (ptsMap.get(a.Id).get(x) != null){
								deletePTS.add(ptsMap.get(a.Id).get(x));
							}
						}
					}
				}
				
				Boolean carryover = false;
				for (String x : newTypes){
					if (oldTypes.contains(x)){
						carryover = true;
					}
				}
				//find the picklist values that were added and create new records
				if (ptsMap.containsKey(a.Id) && carryover){
					for (String x : newTypes){
						if (!oldTypes.contains(x)){
							Product_Type_Split__c y = new Product_Type_Split__c();
							y.Program__c = a.Id;
							y.Product_Type__c = x;
							y.Percent__c = 0.00;
							insertPTS.add(y);
						}
					}
				} else {
					for (String x : newTypes){
						if (!oldTypes.contains(x)){
							Product_Type_Split__c y = new Product_Type_Split__c();
							y.Program__c = a.Id;
							y.Product_Type__c = x;
							y.Percent__c = (100.00/newTypes.size()).setScale(2);
							insertPTS.add(y);
						}
					}
				}
				
				
			}
			
			insert insertPTS;
			delete deletePTS;
		}
	}

}