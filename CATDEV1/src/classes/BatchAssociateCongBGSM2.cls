/*
@Name           :       BatchAssociateCongBGSM2
@Author         :       customersuccess@cloud62.com
@Date           :       Feb 19 2013
@Description    :       Batch class designed to:
                            - associate Conglomerate Account BG records to SM2 records for reporting
*/
global class BatchAssociateCongBGSM2 implements Database.Batchable<sObject>, Schedulable{
    
    Set<String> yearSet;
    Map<Id, User> userMap;
    
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
        String query = 'SELECT ID, NAME, ACCOUNT__C, DELIVERY_CHANNEL__C, YEAR__C, OwnerId '
        	+ 'FROM Conglomerate_Account_Best_Guess_Summary__c '
        	+ 'WHERE YEAR__C IN ' + years + 
           	+ 'AND OWNERID IN (SELECT ID FROM USER WHERE FORECAST_ROLE__C IN(\'SM2\', \'SR1\', \'SR2\')) '
        	+ 'ORDER BY ACCOUNT__C ';
        return Database.getQueryLocator(query);
    }
    
    global void execute(SchedulableContext ctx) {
        BatchAssociateCongBG batch1 = new BatchAssociateCongBG();
        ID batchprocessid = Database.executeBatch(batch1);
    }
    
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        Datetime currentTime = System.now();
        //populate user Map
        userMap = new Map<Id, User>();
        for (User u: [SELECT ID, NAME, FORECAST_ROLE__C, MANAGERID 
                      FROM USER 
                      WHERE FORECAST_ROLE__C != NULL]){
        	userMap.put(u.Id, u);
        }
        
        Set<Id> acctSet = new Set<Id>();
        Map<Id, List<Conglomerate_Account_Best_Guess_Summary__c>> congBGMap = 
            new Map<Id, List<Conglomerate_Account_Best_Guess_Summary__c>>(); 
        List<Sales_Manager_2_Forecast__c> updateSM2 = new List<Sales_Manager_2_Forecast__c>();
        List<Conglomerate_Account_Best_Guess_Summary__c> scopeBG = 
            (List<Conglomerate_Account_Best_Guess_Summary__c>)scope;
        
        //put scope records in a map
        for (Conglomerate_Account_Best_Guess_Summary__c bg : scopeBG){
        	if (!congBGMap.containsKey(bg.Account__c)){
        		congBGMap.put(bg.Account__c, new List<Conglomerate_Account_Best_Guess_Summary__c>());
        	}
        	congBGMap.get(bg.Account__c).add(bg);
        	acctSet.add(bg.Account__c);
        }
        //get SM2 records for association
        List<Sales_Manager_2_Forecast__c> sm2List = [	SELECT ID, 
                                                             NAME, 
                                                             Conglomerate_Best_Guess__c,
                                                             Year__c, 
                                                             Account__c, 
                                                             ACCOUNT__R.PARENTID, 
                                                             DELIVERY_TYPE__C, 
                                                             QUARTER__C, 
                                                             Ownerid
        												FROM SALES_MANAGER_2_FORECAST__C
                                                     	WHERE ACCOUNT__R.PARENTID IN: acctSet
                                                     	//AND YEAR__C IN: yearSet
                                                     	ORDER BY OWNERID
                                                     	LIMIT 40000];
        Map<Id, List<Sales_Manager_2_Forecast__c>> sm2Map = new Map<Id, List<Sales_Manager_2_Forecast__c>>(); 
        for (Sales_Manager_2_Forecast__c sm2 : sm2List){
        	if (!sm2Map.containsKey(sm2.Account__r.ParentId)){
        		system.debug(LoggingLevel.ERROR, '***adding: ' + sm2.Account__r.ParentId);
        		sm2Map.put(sm2.Account__r.ParentId, new List<Sales_Manager_2_Forecast__c>());
        	}
        	sm2Map.get(sm2.Account__r.ParentId).add(sm2);
        }
        //set so that SM2 records are not repeated
        Set<Id> usedSM2s = new Set<Id>();
        
        //populate associations
        for (String congID : congBGMap.keyset()){
        	for (Conglomerate_Account_Best_Guess_Summary__c thisBG : congBGMap.get(congID)){
        		Boolean Q1 = false;
        		Boolean Q2 = false;
        		Boolean Q3 = false;
        		Boolean Q4 = false;
        		if (sm2Map.containsKey(congId)){
	        		for (Sales_Manager_2_Forecast__c sm2: sm2Map.get(congID)){
	        			if (!usedSM2s.contains(sm2.Id) 
                            && !Q1 
                            && thisBG.Delivery_Channel__c == sm2.Delivery_Type__c
	        				&& sm2.Quarter__c == 'Q1' + thisBG.Year__c 
                            && sm2.OwnerId == getRightUserId(thisBG.OwnerId)){
	        				sm2.Conglomerate_Best_Guess__c = thisBG.Id;
	        				updateSM2.add(sm2);
	        				usedSM2s.add(sm2.Id);
	        				Q1 = true;
	        			} else if (!usedSM2s.contains(sm2.Id) 
                                   && !Q2 
                                   && thisBG.Delivery_Channel__c == sm2.Delivery_Type__c 
                                   && sm2.Quarter__c == 'Q2' + thisBG.Year__c 
                                   && sm2.OwnerId == getRightUserId(thisBG.OwnerId)){
	        				sm2.Conglomerate_Best_Guess__c = thisBG.Id;
	        				updateSM2.add(sm2);
	        				usedSM2s.add(sm2.Id);
	        				Q2 = true;
	        			} else if (!usedSM2s.contains(sm2.Id) 
                                   && !Q3 
                                   && thisBG.Delivery_Channel__c == sm2.Delivery_Type__c 
                                   && sm2.Quarter__c == 'Q3' + thisBG.Year__c 
                                   && sm2.OwnerId == getRightUserId(thisBG.OwnerId)){
	        				sm2.Conglomerate_Best_Guess__c = thisBG.Id;
	        				updateSM2.add(sm2);
	        				usedSM2s.add(sm2.Id);
	        				Q3 = true;
	        			} else if (!usedSM2s.contains(sm2.Id) 
                                   && !Q4 
                                   && thisBG.Delivery_Channel__c == sm2.Delivery_Type__c 
                                   && sm2.Quarter__c == 'Q4' + thisBG.Year__c 
                                   && sm2.OwnerId == getRightUserId(thisBG.OwnerId)){
	        				sm2.Conglomerate_Best_Guess__c = thisBG.Id;
	        				updateSM2.add(sm2);
	        				usedSM2s.add(sm2.Id);
	        				Q4 = true;
	        			}
	        			if (Q1 && Q2 && Q3 && Q4) break;
	        		}
        		} else {
        			system.debug(LoggingLevel.ERROR, '***CONGID NOT FOUND: ' + congID);
        		}
        	}
        }
        
        update updateSM2;
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
        
        System.debug(LoggingLevel.WARN,'Temp_Delete_DeleteSM2Forecast');
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
        
        BatchAssociateAccountBGSR1 u = new BatchAssociateAccountBGSR1();
		Database.executeBatch(u);
    }
    
    private String getRightUserId(String x){
    	String returnValue = null;
    	User u;
    	if (userMap.containsKey(x)){
    		u = userMap.get(x);
    		if (u.Forecast_Role__c == 'SM2'){
    			returnValue = u.Id;
    		}else if (u.Forecast_Role__c == 'SR1'){
    			if (userMap.containsKey(u.ManagerId)){
    				returnValue = u.ManagerId;
    			}
    		} else {
    			if (userMap.containsKey(u.ManagerId)){
    				User tempUser = userMap.get(u.ManagerId);
    				if (userMap.containsKey(tempUser.ManagerId)){
    					returnValue = tempUser.ManagerId;
    				}
    			}
    		}
    	}
    	
    	return returnValue;
    }

}