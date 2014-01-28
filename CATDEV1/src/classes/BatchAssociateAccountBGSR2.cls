/*
@Name           :       BatchAssociateAccountBGSR2
@Author         :       customersuccess@cloud62.com
@Date           :       Feb 19 2013
@Description    :       Batch class designed to:
                            - associate Account BG records to SR2 records for reporting
*/
global class BatchAssociateAccountBGSR2 implements Database.Batchable<sObject>, Schedulable{
    
    Set<String> yearSet;
    
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
        	+ 'FROM Account_Best_Guess_Summary__c '
        	+ 'WHERE YEAR__C IN ' + years + 
           	+ 'AND OWNERID IN (SELECT ID FROM USER WHERE FORECAST_ROLE__C IN(\'SR2\')) '
        	+ 'ORDER BY ACCOUNT__C ';
        return Database.getQueryLocator(query);
    }
    
    global void execute(SchedulableContext ctx) {
        BatchAssociateCongBG batch1 = new BatchAssociateCongBG();
        ID batchprocessid = Database.executeBatch(batch1);
    }
    
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        Datetime currentTime = System.now();
        Set<Id> acctSet = new Set<Id>();
        Map<Id, List<Account_Best_Guess_Summary__c>> congBGMap = 
            new Map<Id, List<Account_Best_Guess_Summary__c>>(); 
        List<Rep_2_Forecast__c> updateSR2 = new List<Rep_2_Forecast__c>();
        List<Account_Best_Guess_Summary__c> scopeBG = 
            (List<Account_Best_Guess_Summary__c>)scope;
        
        //put scope records in a map
        for (Account_Best_Guess_Summary__c bg : scopeBG){
        	if (!congBGMap.containsKey(bg.Account__c)){
        		congBGMap.put(bg.Account__c, new List<Account_Best_Guess_Summary__c>());
        	}
        	congBGMap.get(bg.Account__c).add(bg);
        	acctSet.add(bg.Account__c);
        }
        //get SR2 records for association
        List<Rep_2_Forecast__c> SR2List = [	SELECT ID, 
                                           		NAME, 
                                           		Best_Guess__c, 
                                           		Year__c, 
        										Account__c, 
                                           		ACCOUNT__R.PARENTID, 
                                           		DELIVERY_TYPE__C, 
                                           		QUARTER__C, 
                                           		Ownerid
        									FROM Rep_2_Forecast__c
        									WHERE ACCOUNT__C IN: acctSet
        									//AND YEAR__C IN: yearSet
        									ORDER BY OWNERID
        									LIMIT 40000];
        Map<Id, List<Rep_2_Forecast__c>> SR2Map = new Map<Id, List<Rep_2_Forecast__c>>(); 
        for (Rep_2_Forecast__c SR2 : SR2List){
        	if (!SR2Map.containsKey(SR2.Account__c)){
        		system.debug(LoggingLevel.ERROR, '***adding: ' + SR2.Account__c);
        		SR2Map.put(SR2.Account__c, new List<Rep_2_Forecast__c>());
        	}
        	SR2Map.get(SR2.Account__c).add(SR2);
        }
        //set so that SR2 records are not repeated
        Set<Id> usedSR2s = new Set<Id>();
        
        //populate associations
        for (String congID : congBGMap.keyset()){
        	for (Account_Best_Guess_Summary__c thisBG : congBGMap.get(congID)){
        		Boolean Q1 = false;
        		Boolean Q2 = false;
        		Boolean Q3 = false;
        		Boolean Q4 = false;
        		if (SR2Map.containsKey(congId)){
	        		for (Rep_2_Forecast__c SR2: SR2Map.get(congID)){
	        			if (!usedSR2s.contains(SR2.Id) 
                            && !Q1 
                            && thisBG.Delivery_Channel__c == SR2.Delivery_Type__c	
                            && SR2.Quarter__c == 'Q1' + thisBG.Year__c  
                            && SR2.OwnerId == thisBG.OwnerId){
	        				SR2.Account_Best_Guess__c = thisBG.Id;
	        				updateSR2.add(SR2);
	        				usedSR2s.add(SR2.Id);
	        				Q1 = true;
	        			} else if (!usedSR2s.contains(SR2.Id) 
                                   && !Q2 
                                   && thisBG.Delivery_Channel__c == SR2.Delivery_Type__c 
                                   && SR2.Quarter__c == 'Q2' + thisBG.Year__c  
                                   && SR2.OwnerId == thisBG.OwnerId){
	        				SR2.Account_Best_Guess__c = thisBG.Id;
	        				updateSR2.add(SR2);
	        				usedSR2s.add(SR2.Id);
	        				Q2 = true;
	        			} else if (!usedSR2s.contains(SR2.Id) 
                                   && !Q3 
                                   && thisBG.Delivery_Channel__c == SR2.Delivery_Type__c 
                                   && SR2.Quarter__c == 'Q3' + thisBG.Year__c 
                                   && SR2.OwnerId == thisBG.OwnerId){
	        				SR2.Account_Best_Guess__c = thisBG.Id;
	        				updateSR2.add(SR2);
	        				usedSR2s.add(SR2.Id);
	        				Q3 = true;
                            
	        			} else if (!usedSR2s.contains(SR2.Id) 
                                   && !Q4 
                                   && thisBG.Delivery_Channel__c == SR2.Delivery_Type__c 
                                   && SR2.Quarter__c == 'Q4' + thisBG.Year__c 
                                   && SR2.OwnerId == thisBG.OwnerId){
	        				SR2.Account_Best_Guess__c = thisBG.Id;
	        				updateSR2.add(SR2);
	        				usedSR2s.add(SR2.Id);
	        				Q4 = true;
	        			}
	        			if (Q1 && Q2 && Q3 && Q4) break;
	        		}
        		} else {
        			system.debug(LoggingLevel.ERROR, '***CONGID NOT FOUND: ' + congID);
        		}
        	}
        }
        
        update updateSR2;
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
        
        System.debug(LoggingLevel.WARN,'Temp_Delete_DeleteSR2Forecast');
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
    }

}