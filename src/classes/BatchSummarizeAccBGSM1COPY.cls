global class BatchSummarizeAccBGSM1COPY implements Database.Batchable<sObject>, Schedulable{
    
    String query;
    String limit1;
    List<Account_Best_Guess_Summary__c> accBGList;
    List<Conglomerate_Account_Best_Guess_Summary__c> congBGList;
    Map<Id, Map<Id, Map<String, Map<String, Account_Best_Guess_Summary__c>>>> accMap;
    Map<Id, Map<Id, Map<String, Map<String, Conglomerate_Account_Best_Guess_Summary__c>>>> congMap;
    Set<Id> accId;
    Map<Id, Account> accParentMap;
    Set<Id> congId;
            
    public BatchSummarizeAccBGSM1COPY(String x){
        limit1 = x;
    }
    
    public BatchSummarizeAccBGSM1COPY(){
        limit1 = '';
    }
    
    global Database.querylocator start(Database.BatchableContext BC){
        BatchGovernorLimitUtility.insertBatchRun('BatchCalculateAccountBG');
                
        query = 'SELECT ID, ACCOUNT__C, OWNERID, BOOKED_AMOUNT__C, WEIGHTED_FORECAST_PROPOSAL__C, '
        + ' FORECAST_PROPOSAL__C, YEAR__C, QUARTER__C, DELIVERY_TYPE__C '
        + ' FROM SALES_MANAGER_1_FORECAST__C '
        + ' WHERE BOOKED_AMOUNT__C != 0 OR WEIGHTED_FORECAST_PROPOSAL__C != 0 OR FORECAST_PROPOSAL__C != 0 '
        + limit1;
        return Database.getQueryLocator(query);
    }
    
    global void execute(SchedulableContext ctx) {
        BatchSummarizeAccBGSM1COPY batch1 = new BatchSummarizeAccBGSM1COPY();
        ID batchprocessid = Database.executeBatch(batch1);
    } 
    
    global void execute(Database.BatchableContext NC, List<sObject> scope){
    	List<Sales_Manager_1_Forecast__c> scope1 = (List<Sales_Manager_1_Forecast__c>)scope;
    	accId = new Set<Id>();
    	congID = new Set<Id>();
    	accParentMap = new Map<Id, Account>();
    	Map<Id, Account> masterAccMap = new Map<Id, Account>();
    	for (Account a : [SELECT ID, OWNERID, NAME FROM ACCOUNT]){
    		masterAccMap.put(a.Id, a);
    	}
    	List<Account_Best_Guess_Summary__c> insertABGS = new List<Account_Best_Guess_Summary__c>();
    	List<Conglomerate_Account_Best_Guess_Summary__c> insertCBGS = new List<Conglomerate_Account_Best_Guess_Summary__c>();
    	for (Sales_Manager_1_Forecast__c forecast : scope1){
    		accId.add(forecast.Account__c);
    	}
    	
    	
    	
    	for (Account a : [SELECT ID, PARENTID FROM ACCOUNT WHERE ID IN :accId]){
    		congID.add(a.ParentID);
    		if (a.ParentID != null) accParentMap.put(a.Id, masterAccMap.get(a.ParentID));
    	}
    	
    	
    	
    	populateMap();
    	
    	//populate conglomerates
    	for (Sales_Manager_1_Forecast__c forecast : scope1){
    		if (accParentMap.containsKey(forecast.Account__c)){
	        	String congID = accParentMap.get(forecast.Account__c).Id;
	        	String ownerID = accParentMap.get(forecast.Account__c).OwnerId;
	        	if (!congMap.containsKey(ownerID)){
	        		congMap.put(ownerID, new Map<Id, Map<String, Map<String, Conglomerate_Account_Best_Guess_Summary__c>>>());
	        	}
	        	if (!congMap.get(ownerID).containsKey(congID)){
	        		congMap.get(ownerID).put(congID, new Map<String, Map<String, Conglomerate_Account_Best_Guess_Summary__c>>());
	        	}
	        	if (!congMap.get(ownerID).get(congID).containsKey(forecast.Year__c)){
	        		congMap.get(ownerID).get(congID).put(forecast.Year__c, new Map<String, Conglomerate_Account_Best_Guess_Summary__c>());
	        	}
	        	if (!congMap.get(ownerID).get(congID).get(forecast.Year__c).containsKey(forecast.Delivery_Type__c)){
	        		Conglomerate_Account_Best_Guess_Summary__c newCBGS = createCBGS(ownerID, congID, forecast.Year__c, forecast.Delivery_Type__c);
	        		insertCBGS.add(newCBGS);
	        		congMap.get(ownerID).get(congID).get(forecast.Year__c).put(forecast.Delivery_Type__c, newCBGS);
	        	}
    		}
        }
        
        insert insertCBGS;
        
        populateMap();
        
        for (Sales_Manager_1_Forecast__c forecast : scope1){
        	if (!accMap.containsKey(forecast.OwnerId)){
        		accMap.put(forecast.OwnerId, new Map<Id, Map<String, Map<String, Account_Best_Guess_Summary__c>>>());
        	}
        	if (!accMap.get(forecast.OwnerId).containsKey(forecast.Account__c)){
        		accMap.get(forecast.OwnerId).put(forecast.Account__c, new Map<String, Map<String, Account_Best_Guess_Summary__c>>());
        	}
        	if (!accMap.get(forecast.OwnerId).get(forecast.Account__c).containsKey(forecast.Year__c)){
	        		accMap.get(forecast.OwnerId).get(forecast.Account__c).put(forecast.Year__c, new Map<String, Account_Best_Guess_Summary__c>());
	        	}
	        	if (!accMap.get(forecast.OwnerId).get(forecast.Account__c).get(forecast.Year__c).containsKey(forecast.Delivery_Type__c)){
	        		Account_Best_Guess_Summary__c newABGS = createABGS(forecast.OwnerId, forecast.Account__c, forecast.Year__c, forecast.Delivery_Type__c);
	        		insertABGS.add(newABGS);
	        		accMap.get(forecast.OwnerId).get(forecast.Account__c).get(forecast.Year__c).put(forecast.Delivery_Type__c, newABGS);
	        	}
        }
        
        insert insertABGS;
        
        populateMap();
        
        for (Sales_Manager_1_Forecast__c forecast : scope1){
        	Account_Best_Guess_Summary__c abgs = accMap.get(forecast.OwnerId).get(forecast.Account__c).get(forecast.Year__c).get(forecast.Delivery_Type__c);
        	if (forecast.Quarter__c.contains('Q1')){
        		abgs.Booked_Q1__c += Double.valueOf(forecast.Booked_Amount__c);
        		abgs.Wgt_Proposal_Q1__c += Double.valueOf(forecast.Weighted_Forecast_Proposal__c);
        		abgs.Full_Proposal_Q1__c += Double.valueOf(forecast.Forecast_Proposal__c);	
        	} else if (forecast.Quarter__c.contains('Q2')){
        		abgs.Booked_Q2__c += Double.valueOf(forecast.Booked_Amount__c);
        		abgs.Wgt_Proposal_Q2__c += Double.valueOf(forecast.Weighted_Forecast_Proposal__c);
        		abgs.Full_Proposal_Q2__c += Double.valueOf(forecast.Forecast_Proposal__c);	
        	} else if (forecast.Quarter__c.contains('Q3')){
        		abgs.Booked_Q3__c += Double.valueOf(forecast.Booked_Amount__c);
        		abgs.Wgt_Proposal_Q3__c += Double.valueOf(forecast.Weighted_Forecast_Proposal__c);
        		abgs.Full_Proposal_Q3__c += Double.valueOf(forecast.Forecast_Proposal__c);	
        	} else if (forecast.Quarter__c.contains('Q4')){
        		abgs.Booked_Q4__c += Double.valueOf(forecast.Booked_Amount__c);
        		abgs.Wgt_Proposal_Q4__c += Double.valueOf(forecast.Weighted_Forecast_Proposal__c);
        		abgs.Full_Proposal_Q4__c += Double.valueOf(forecast.Forecast_Proposal__c);	
        	}
        }
        
        update accBGList;
    }
    
    global void finish(Database.BatchableContext BC){
    	System.debug(LoggingLevel.WARN,'Temp_Delete_DeleteSM1Forecast');
        //Build the system time of now + 20 seconds to schedule the batch apex.
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        //BatchDeleteManagerBestGuess acctBatch2Sched = new BatchDeleteManagerBestGuess();
        BatchAssociateCongBG acctBatch2Sched = new BatchAssociateCongBG();
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
    }
    
    private Account_Best_Guess_Summary__c createABGS(String owner, String accID, String year, String delChannel){
    	Account_Best_Guess_Summary__c newABGS = new Account_Best_Guess_Summary__c();
    	if (accParentMap.containsKey(accID)){
    		Account a = accParentMap.get(accID);
    		newABGS.Conglomerate_Account_Best_Guess_Summary__c = congMap.get(a.OwnerId).get(a.Id).get(year).get(delChannel).Id;
    	}
    	newABGS.OwnerId = owner;
    	newABGS.Account__c = accID;
    	newABGS.Year__c = year;
    	newABGS.Delivery_Channel__c = delChannel;
    	newABGS.Booked_Q1__c = 0;
    	newABGS.Booked_Q2__c = 0;
    	newABGS.Booked_Q3__c = 0;
    	newABGS.Booked_Q4__c = 0;
    	newABGS.Full_Proposal_Q1__c = 0;
    	newABGS.Full_Proposal_Q2__c = 0;
    	newABGS.Full_Proposal_Q3__c = 0;
    	newABGS.Full_Proposal_Q4__c = 0;
    	newABGS.Wgt_Proposal_Q1__c = 0;
    	newABGS.Wgt_Proposal_Q2__c = 0;
    	newABGS.Wgt_Proposal_Q3__c = 0;
    	newABGS.Wgt_Proposal_Q4__c = 0;
    	newABGS.Q1__c = 0;
    	newABGS.Q2__c = 0;
    	newABGS.Q3__c = 0;
    	newABGS.Q4__c = 0;
    	return newABGS;
    }
    
    private Conglomerate_Account_Best_Guess_Summary__c createCBGS(String owner, String accID, String year, String delChannel){
    	Conglomerate_Account_Best_Guess_Summary__c newABGS = new Conglomerate_Account_Best_Guess_Summary__c();
    	newABGS.OwnerId = owner;
    	newABGS.Account__c = accID;
    	newABGS.Year__c = year;
    	newABGS.Delivery_Channel__c = delChannel;
    	newABGS.Booked_Q1__c = 0;
    	newABGS.Booked_Q2__c = 0;
    	newABGS.Booked_Q3__c = 0;
    	newABGS.Booked_Q4__c = 0;
    	newABGS.Full_Proposal_Q1__c = 0;
    	newABGS.Full_Proposal_Q2__c = 0;
    	newABGS.Full_Proposal_Q3__c = 0;
    	newABGS.Full_Proposal_Q4__c = 0;
    	newABGS.Wgt_Proposal_Q1__c = 0;
    	newABGS.Wgt_Proposal_Q2__c = 0;
    	newABGS.Wgt_Proposal_Q3__c = 0;
    	newABGS.Wgt_Proposal_Q4__c = 0;
    	newABGS.Q1__c = 0;
    	newABGS.Q2__c = 0;
    	newABGS.Q3__c = 0;
    	newABGS.Q4__c = 0;
    	return newABGS;
    }
    
    private void populateMap(){
    	accBGList = [Select Account__r.ID, OwnerID, Year__c, Delivery_Channel__c,
              Booked_Q1__c, Booked_Q2__c, Booked_Q3__c, Booked_Q4__c,
              Full_Proposal_Q1__c, Full_Proposal_Q2__c, Full_Proposal_Q3__c, Full_Proposal_Q4__c,
              Q1__c, Q2__c, Q3__c, Q4__c,
              Wgt_Proposal_Q1__c, Wgt_Proposal_Q2__c, Wgt_Proposal_Q3__c, Wgt_Proposal_Q4__c
              From Account_Best_Guess_Summary__c 
              Where Account__c in: accID];
        
        congBGList = [Select Account__r.ID, OwnerID, Year__c, Delivery_Channel__c,
              Booked_Q1__c, Booked_Q2__c, Booked_Q3__c, Booked_Q4__c,
              Full_Proposal_Q1__c, Full_Proposal_Q2__c, Full_Proposal_Q3__c, Full_Proposal_Q4__c,
              Q1__c, Q2__c, Q3__c, Q4__c,
              Wgt_Proposal_Q1__c, Wgt_Proposal_Q2__c, Wgt_Proposal_Q3__c, Wgt_Proposal_Q4__c
              From Conglomerate_Account_Best_Guess_Summary__c 
              Where Account__c in: congID];
        
        //Map is User: Account: Year
        accMap = new Map<Id, Map<Id, Map<String, Map<String, Account_Best_Guess_Summary__c>>>>();
        for (Account_Best_Guess_Summary__c accBG : accBGList){
        	if (!accMap.containsKey(accBG.OwnerId)){
        		accMap.put(accBG.OwnerId, new Map<Id, Map<String, Map<String, Account_Best_Guess_Summary__c>>>());
        	}
        	if (!accMap.get(accBG.OwnerId).containsKey(accBG.Account__c)){
        		accMap.get(accBG.OwnerId).put(accBG.Account__c, new Map<String, Map<String, Account_Best_Guess_Summary__c>>());
        	}
        	if (!accMap.get(accBG.OwnerId).get(accBG.Account__c).containsKey(accBG.Year__c)){
        		accMap.get(accBG.OwnerId).get(accBG.Account__c).put(accBG.Year__c, new Map<String, Account_Best_Guess_Summary__c>());
        	}
        	if (!accMap.get(accBG.OwnerId).get(accBG.Account__c).get(accBG.Year__c).containsKey(accBG.Delivery_Channel__c)){
        		accMap.get(accBG.OwnerId).get(accBG.Account__c).get(accBG.Year__c).put(accBG.Delivery_Channel__c, accBG);
        	}
        }
        
        congMap = new Map<Id, Map<Id, Map<String, Map<String, Conglomerate_Account_Best_Guess_Summary__c>>>>();
        for (Conglomerate_Account_Best_Guess_Summary__c accBG : congBGList){
        	if (!congMap.containsKey(accBG.OwnerId)){
        		congMap.put(accBG.OwnerId, new Map<Id, Map<String, Map<String, Conglomerate_Account_Best_Guess_Summary__c>>>());
        	}
        	if (!congMap.get(accBG.OwnerId).containsKey(accBG.Account__c)){
        		congMap.get(accBG.OwnerId).put(accBG.Account__c, new Map<String, Map<String, Conglomerate_Account_Best_Guess_Summary__c>>());
        	}
        	if (!congMap.get(accBG.OwnerId).get(accBG.Account__c).containsKey(accBG.Year__c)){
        		congMap.get(accBG.OwnerId).get(accBG.Account__c).put(accBG.Year__c, new Map<String, Conglomerate_Account_Best_Guess_Summary__c>());
        	}
        	if (!congMap.get(accBG.OwnerId).get(accBG.Account__c).get(accBG.Year__c).containsKey(accBG.Delivery_Channel__c)){
        		congMap.get(accBG.OwnerId).get(accBG.Account__c).get(accBG.Year__c).put(accBG.Delivery_Channel__c, accBG);
        	}
        }
    }

}