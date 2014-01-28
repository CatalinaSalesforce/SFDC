/*
@Name           :       BatchAssociateCongBG
@Author         :       customersuccess@cloud62.com
@Date           :       Feb 11 2013
@Description    :       Batch class designed to:
                            - associate Conglomerate Account BG records to SM1 records for reporting

@Modified		:		March 12, 2013 
						Method added to return the SM1 User that the records should be associated to.  
*/
global class BatchAssociateCongBG implements Database.Batchable<sObject>, Schedulable{
    
    Set<String> yearSet;
    List<User> CongBGOwners;
    
    global Database.querylocator start(Database.BatchableContext BC){
        BatchGovernorLimitUtility.insertBatchRun('BatchAssociateCongBG');
        yearSet = new Set<String>();
        yearSet.add(String.valueOf(Date.today().year() - 1));
        yearSet.add(String.valueOf(Date.today().year()));
        yearSet.add(String.valueOf(Date.today().year() + 1));
        String years = '(';
        years += '\'' + String.valueOf(Date.today().year() - 1) + '\', ';
        years += '\'' + String.valueOf(Date.today().year()) + '\', ';
        years += '\'' + String.valueOf(Date.today().year() + 1) + '\') ';
        String query = 'SELECT ID, NAME, ACCOUNT__C, DELIVERY_CHANNEL__C, YEAR__C, OWNERID '
        	+ 'FROM Conglomerate_Account_Best_Guess_Summary__c '
        	+ 'WHERE YEAR__C IN ' + years + 
        	+ 'ORDER BY ACCOUNT__C ';
        return Database.getQueryLocator(query);
    }
    
    global void execute(SchedulableContext ctx) {
        BatchAssociateCongBG batch1 = new BatchAssociateCongBG();
        ID batchprocessid = Database.executeBatch(batch1);
    }
    /*
	@Name 			: getSM1Manager
	@Description	: This Method is designed to return the ID of the SM1 User in the heirarchy
						above the owner of the record.  If the owner of the record is an SM1 then
						their ID is returned.  
	@Dependencies 	: List CongBGOwners
	*/
    private ID getSM1Manager(Id x){
        for(user u : CongBGOwners){
            if(u.id == x){
                if(u.forecast_role__c == 'SM1'){
                   		x = u.id;
                       	break;      
                }else if(u.manager.forecast_role__c == 'SM1'){
                        x = u.manager.id;
                       	break;         
                }else if(u.manager.manager.forecast_role__c == 'SM1'){
                        x = u.manager.manager.id;
                       	break;
                } 
            }
        }
        return x;
    }
    
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        Datetime currentTime = System.now();
        Set<Id> acctSet = new Set<Id>();
        Map<Id, List<Conglomerate_Account_Best_Guess_Summary__c>> congBGMap = 
            new Map<Id, List<Conglomerate_Account_Best_Guess_Summary__c>>(); 
        List<Sales_Manager_1_Forecast__c> updateSM1 = new List<Sales_Manager_1_Forecast__c>();
        List<Conglomerate_Account_Best_Guess_Summary__c> scopeBG = 
            (List<Conglomerate_Account_Best_Guess_Summary__c>)scope;
        // added to get the correct SM1        
        Set<id> OwnerSet = new Set<id>();
        
        
        //put scope records in a map
        for (Conglomerate_Account_Best_Guess_Summary__c bg : scopeBG){
            
            
            
        	if (!congBGMap.containsKey(bg.Account__c)){
        		congBGMap.put(bg.Account__c, new List<Conglomerate_Account_Best_Guess_Summary__c>());
        	}
        	congBGMap.get(bg.Account__c).add(bg);
        	acctSet.add(bg.Account__c);
            //added to get the correct SM1
			OwnerSet.add(bg.OwnerId);
        }
        
        //get the information from the users to confirm their SM1
        CongBGOwners = [Select ID, 
                        	forecast_role__c, 
                        	manager.ID, 
                        	manager.forecast_role__c, 
                        	manager.manager.ID, 
                        	manager.manager.forecast_role__c
                        FROM User
                        WHERE ID in: OwnerSet];
        //get SM1 records for association
        List<Sales_Manager_1_Forecast__c> sm1List = [SELECT ID, 
                                                         NAME, 
                                                         Conglomerate_Best_Guess__c, 
                                                         Year__c, 
                                                         Account__c, 
                                                         ACCOUNT__R.PARENTID, 
                                                         DELIVERY_TYPE__C, 
                                                         QUARTER__C,
                                                     	 OWNERID
                                                     FROM SALES_MANAGER_1_FORECAST__C
                                                     WHERE ACCOUNT__R.PARENTID IN: acctSet
                                                     //AND YEAR__C IN: yearSet
                                                     ORDER BY OWNERID
                                                     LIMIT 40000];
        Map<Id, List<Sales_Manager_1_Forecast__c>> sm1Map = new Map<Id, List<Sales_Manager_1_Forecast__c>>(); 
        for (Sales_Manager_1_Forecast__c sm1 : sm1List){
        	if (!sm1Map.containsKey(sm1.Account__r.ParentId)){
        		system.debug(LoggingLevel.ERROR, '***adding: ' + sm1.Account__r.ParentId);
        		sm1Map.put(sm1.Account__r.ParentId, new List<Sales_Manager_1_Forecast__c>());
        	}
        	sm1Map.get(sm1.Account__r.ParentId).add(sm1);
        }
        //set so that SM1 records are not repeated
        Set<Id> usedSM1s = new Set<Id>();
        
        //populate associations
        for (String congID : congBGMap.keyset()){
        	for (Conglomerate_Account_Best_Guess_Summary__c thisBG : congBGMap.get(congID)){
        		Boolean Q1 = false;
        		Boolean Q2 = false;
        		Boolean Q3 = false;
        		Boolean Q4 = false;
        		if (sm1Map.containsKey(congId)){
	        		for (Sales_Manager_1_Forecast__c sm1: sm1Map.get(congID)){
	        			if (!usedSM1s.contains(sm1.Id) 
                            && !Q1 
                            && thisBG.Delivery_Channel__c == sm1.Delivery_Type__c 
                            && sm1.Quarter__c == 'Q1' + thisBG.Year__c
                            && sm1.OwnerId == getSM1Manager(thisBG.OwnerId) ){
	        				sm1.Conglomerate_Best_Guess__c = thisBG.Id;
	        				updateSM1.add(sm1);
	        				usedSM1s.add(sm1.Id);
	        				Q1 = true;
	        			} else if (!usedSM1s.contains(sm1.Id) 
                                   && !Q2 
                                   && thisBG.Delivery_Channel__c == sm1.Delivery_Type__c 
                                   && sm1.Quarter__c == 'Q2' + thisBG.Year__c
                                   && sm1.OwnerId == getSM1Manager(thisBG.OwnerId) ){
	        				sm1.Conglomerate_Best_Guess__c = thisBG.Id;
	        				updateSM1.add(sm1);
	        				usedSM1s.add(sm1.Id);
	        				Q2 = true;
	        			} else if (!usedSM1s.contains(sm1.Id) 
                                   && !Q3 
                                   && thisBG.Delivery_Channel__c == sm1.Delivery_Type__c 
                                   && sm1.Quarter__c == 'Q3' + thisBG.Year__c
                                   && sm1.OwnerId == getSM1Manager(thisBG.OwnerId) ){ 
	        				sm1.Conglomerate_Best_Guess__c = thisBG.Id;
	        				updateSM1.add(sm1);
	        				usedSM1s.add(sm1.Id);
	        				Q3 = true;
	        			} else if (!usedSM1s.contains(sm1.Id) 
                                   && !Q4 
                                   && thisBG.Delivery_Channel__c == sm1.Delivery_Type__c 
                                   && sm1.Quarter__c == 'Q4' + thisBG.Year__c
                                   && sm1.OwnerId == getSM1Manager(thisBG.OwnerId) ){
	        				sm1.Conglomerate_Best_Guess__c = thisBG.Id;
	        				updateSM1.add(sm1);
	        				usedSM1s.add(sm1.Id);
	        				Q4 = true;
	        			}
	        			if (Q1 && Q2 && Q3 && Q4) break;
	        		}
        		} else {
        			system.debug(LoggingLevel.ERROR, '***CONGID NOT FOUND: ' + congID);
        		}
        	}
        }
        
        update updateSM1;
        BatchGovernorLimitUtility.calcualteLimits(Limits.getCpuTime(), 
                                                  Limits.getDMLRows(),
                                                  Limits.getDMLStatements(), 
                                                  Limits.getHeapSize(), 
                                                  Limits.getQueries(), 
                                                  Limits.getQueryRows(), 
                                                  Limits.getScriptStatements(), 
                                                  scope, 
                                                  currentTime, 
                                                  System.now());
    }
    
    global void finish(Database.BatchableContext BC){
        
        System.debug(LoggingLevel.WARN,'Temp_Delete_DeleteSM1Forecast');
        //Build the system time of now + 20 seconds to schedule the batch apex.
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() 
                        + ' ' + sysTime.minute() 
                        + ' ' + sysTime.hour() 
                        + ' ' + sysTime.day() 
                        + ' ' + sysTime.month() 
                        + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        BatchBestGuessFYTotal1 acctBatch2Sched = new BatchBestGuessFYTotal1();
        //Schedule the next job, and give it the system time so name is unique
        //System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
        BatchGovernorLimitUtility.updateBatchRun();
        
        BatchAssociateCongBGSM2 u = new BatchAssociateCongBGSM2();
		Database.executeBatch(u);
    }

}