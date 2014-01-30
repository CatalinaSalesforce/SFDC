/*
@Name            : BatchSummarizeAccountBG
@Author          : customersuccess@cloud62.com
@Date            : October 9, 2013
@Description     : 
*/
global class BatchSummarizeAccountBG implements Database.Batchable<sObject>, Schedulable{
	
	final static String q1 = 'Q1';
    final static String q2 = 'Q2';
    final static String q3 = 'Q3';
    final static String q4 = 'Q4';
    
    String query;
    String limit1;
    final static String defaultSettingsName = 'Default';
    Catalina_Forecast_Settings__c settings;
    String baseType;
    String digitalType;
    String audienceType;
    String mobileType;
    String manufacturingType;
    String retailType;
    String coopType;
    Map<Id, Account> accParentMap;
    Set<Id> accountSet;
    Set<Id> congId;
    List<Account_Best_Guess_Summary__c> accBGList;
    List<Conglomerate_Account_Best_Guess_Summary__c> congBGList;
    Map<Id, Map<Id, Map<String, Map<String, Account_Best_Guess_Summary__c>>>> accMap;
    Map<Id, Map<Id, Map<String, Map<String, Conglomerate_Account_Best_Guess_Summary__c>>>> congMap;
    
    public BatchSummarizeAccountBG(String x){
        limit1 = x;
    }
    
    public BatchSummarizeAccountBG(){
        limit1 = '';
    }
    
    global Database.querylocator start(Database.BatchableContext BC){
        BatchGovernorLimitUtility.insertBatchRun('BatchSummarizeAccountBG');
        
        Best_Guess_Settings__c BGSettings = Best_Guess_Settings__c.getOrgDefaults();
		BGSettings.Batch_Use_Trigger__c = true;
		upsert BGSettings;
         
        Set<String> quarters = new Set<String>();
		String year1 = String.valueOf(Date.today().year());
	    String year2 = String.valueOf(Date.today().year() + 1);
	    String yearM1 = String.valueOf(Date.today().year() - 1);
        quarters.add(q1 + year1);
        quarters.add(q2 + year1);
        quarters.add(q3 + year1);
        quarters.add(q4 + year1);
        quarters.add(q1 + year2);
        quarters.add(q2 + year2);
        quarters.add(q3 + year2);
        quarters.add(q4 + year2);
        quarters.add(q1 + yearM1);
        quarters.add(q2 + yearM1);
        quarters.add(q3 + yearM1);
        quarters.add(q4 + yearM1);
    
        query = 'SELECT ID, NAME, Account_Type__c, Active__c, Actual_Amount__c, Booked_Amount__c, CurrencyIsoCode,Cycle__c,Delivery_Channel__c, External_Id__c, '
        + ' Forecast_Amount__c, Forecast_Month__c, Forecast_Quarter__c, Opportunity_Record_Type__c, Program__r.Opportunity__r.RecordType.Name, Oppty_Probability__c, Program__c, Weighted_Forecast_Amount__c, '
        + ' Program__r.Opportunity__r.AccountId, Program__r.Opportunity__r.OwnerId, Program__r.Delivery_Type__c, '
        + ' Program__r.Opportunity__r.Account.RecordType.Name '
        + ' FROM PROGRAM_FORECAST_MONTHLY__C '
        + ' WHERE IS_SDPY__C = FALSE '
        //+ ' AND PROGRAM__R.OPPORTUNITY__R.OWNER.ISACTIVE = TRUE '
        + ' AND FORECAST_QUARTER__C IN: quarters '
        + ' and (NOT(Program__r.Opportunity__r.IsWon = False and Program__r.Opportunity__r.IsClosed = True)) '
        //+ ' AND PROGRAM__R.OPPORTUNITY__R.OWNERID = \'005A0000001NCjb\' '
        //+ ' AND PROGRAM__R.OPPORTUNITY__R.ACCOUNTID = \'001F000000mCmOg\' '
        //+ ' AND FORECAST_QUARTER__C = \'Q12013\' '
        + ' ORDER BY PROGRAM__R.OPPORTUNITY__R.OWNERID, FORECAST_QUARTER__C '
        +   limit1;
        return Database.getQueryLocator(query);
    }
    
    global void execute(SchedulableContext ctx) {
        BatchSummarizeAccountBG batch1 = new BatchSummarizeAccountBG();
        ID batchprocessid = Database.executeBatch(batch1);
    } 
    
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        Datetime currentTime = System.now();
        settings = Catalina_Forecast_Settings__c.getInstance(defaultSettingsName);
        baseType = settings.Base_Delivery_Type__c;
        digitalType = settings.Digital_Delivery_Type__c;
        audienceType = settings.Display_Delivery_Type__c;
        mobileType = settings.Mobile_Delivery_Type__c;
        manufacturingType = settings.Manufacturing_Account_Type__c;
        retailType = settings.Retail_Account_Type__c;
        coopType = settings.Coop_String__c;
        String year1 = String.valueOf(Date.today().year());
        String year2 = String.valueOf(Date.today().year() + 1);
        //2013-02-13 add last year
        String yearM1 = String.valueOf(Date.today().year() - 1);
        congID = new Set<Id>();
        
        accParentMap = new Map<Id, Account>();
    	Map<Id, Account> masterAccMap = new Map<Id, Account>();
    	for (Account a : [SELECT ID, OWNERID, NAME FROM ACCOUNT WHERE RECORDTYPE.NAME IN ('MANUFACTURING','RETAIL')]){
    		masterAccMap.put(a.Id, a);
    	}
    	List<Account_Best_Guess_Summary__c> insertABGS = new List<Account_Best_Guess_Summary__c>();
    	List<Conglomerate_Account_Best_Guess_Summary__c> insertCBGS = new List<Conglomerate_Account_Best_Guess_Summary__c>();
    	
        List<Program_forecast_Monthly__c> scopePFM = (List<Program_forecast_Monthly__c>)scope;
        accountSet = new Set<Id>();
        for (Program_forecast_Monthly__c pfm : scopePFM){
        	accountSet.add(pfm.Program__r.Opportunity__r.AccountId);
        	system.debug(LoggingLevel.ERROR,'***pfmID: ' + pfm.Id + ', quarter: ' + pfm.Forecast_Quarter__c + ', Booked: ' + pfm.Booked_Amount__c);
        }
        
    	for (Account a : [SELECT ID, PARENTID FROM ACCOUNT WHERE ID IN :accountSet]){
    		congID.add(a.ParentID);
    		if (a.ParentID != null) accParentMap.put(a.Id, masterAccMap.get(a.ParentID));
    	}
        
        populateMap();
        
        //populate conglomerates
    	for (Program_forecast_Monthly__c pfm : scopePFM){
        	String accountID = pfm.Program__r.Opportunity__r.AccountId;
        	String year = String.valueOf(pfm.Forecast_Month__c.year());
        	String delType = pfm.Program__r.Delivery_Type__c;
    		if (accParentMap.containsKey(accountID)){
	        	String congID = accParentMap.get(accountID).Id;
	        	String ownerID = accParentMap.get(accountID).OwnerId;
	        	if (!congMap.containsKey(ownerID)){
	        		congMap.put(ownerID, new Map<Id, Map<String, Map<String, Conglomerate_Account_Best_Guess_Summary__c>>>());
	        	}
	        	if (!congMap.get(ownerID).containsKey(congID)){
	        		congMap.get(ownerID).put(congID, new Map<String, Map<String, Conglomerate_Account_Best_Guess_Summary__c>>());
	        	}
	        	if (!congMap.get(ownerID).get(congID).containsKey(year)){
	        		congMap.get(ownerID).get(congID).put(year, new Map<String, Conglomerate_Account_Best_Guess_Summary__c>());
	        	}
	        	if (!congMap.get(ownerID).get(congID).get(year).containsKey(delType)){
	        		Conglomerate_Account_Best_Guess_Summary__c newCBGS = createCBGS(ownerID, congID, year, delType);
	        		insertCBGS.add(newCBGS);
	        		congMap.get(ownerID).get(congID).get(year).put(delType, newCBGS);
	        	}
    		}
        }
        
        insert insertCBGS;
        
        populateMap();
        
        for (Program_forecast_Monthly__c pfm : scopePFM){
        	String accountID = pfm.Program__r.Opportunity__r.AccountId;
        	String ownerID = pfm.Program__r.Opportunity__r.OwnerId;
        	String year = String.valueOf(pfm.Forecast_Month__c.year());
        	String delType = pfm.Program__r.Delivery_Type__c;
        	String quarter = pfm.Forecast_Quarter__c;
        	String recordType = pfm.Opportunity_Record_Type__c;
        	Account_Best_Guess_Summary__c abgs;
        	if (!accMap.containsKey(ownerID)){
        		accMap.put(ownerID, new Map<Id, Map<String, Map<String, Account_Best_Guess_Summary__c>>>());
        	}
        	if (!accMap.get(ownerID).containsKey(accountID)){
        		accMap.get(ownerID).put(accountID, new Map<String, Map<String, Account_Best_Guess_Summary__c>>());
        	}
        	if (!accMap.get(ownerID).get(accountID).containsKey(year)){
        		accMap.get(ownerID).get(accountID).put(year, new Map<String, Account_Best_Guess_Summary__c>());
        	}
        	if (!accMap.get(ownerID).get(accountID).get(year).containsKey(delType)){
        		abgs = createABGS(ownerID, accountID, year, delType);
        		accMap.get(ownerID).get(accountID).get(year).put(delType, abgs);
        		accBGList.add(abgs);
        	} else {
        		abgs = accMap.get(ownerID).get(accountID).get(year).get(delType);
        	}
        	if (abgs.Booked_Q1__c == null) abgs.Booked_Q1__c = 0;
        	if (abgs.Wgt_Proposal_Q1__c == null) abgs.Wgt_Proposal_Q1__c = 0;
        	if (abgs.Full_Proposal_Q1__c == null) abgs.Full_Proposal_Q1__c = 0;
        	if (abgs.Booked_Q2__c == null) abgs.Booked_Q2__c = 0;
        	if (abgs.Wgt_Proposal_Q2__c == null) abgs.Wgt_Proposal_Q2__c = 0;
        	if (abgs.Full_Proposal_Q2__c == null) abgs.Full_Proposal_Q2__c = 0;
        	if (abgs.Booked_Q3__c == null) abgs.Booked_Q3__c = 0;
        	if (abgs.Wgt_Proposal_Q3__c == null) abgs.Wgt_Proposal_Q3__c = 0;
        	if (abgs.Full_Proposal_Q3__c == null) abgs.Full_Proposal_Q3__c = 0;
        	if (abgs.Booked_Q4__c == null) abgs.Booked_Q4__c = 0;
        	if (abgs.Wgt_Proposal_Q4__c == null) abgs.Wgt_Proposal_Q4__c = 0;
        	if (abgs.Full_Proposal_Q4__c == null) abgs.Full_Proposal_Q4__c = 0;
        	Double forecastAmt = (pfm.Forecast_Amount__c == null ? 0 : pfm.Forecast_Amount__c);
        	Double weightedForecastAmt = (pfm.Weighted_Forecast_Amount__c == null ? 0 : pfm.Weighted_Forecast_Amount__c);
        	Double bookedAmt = (pfm.Booked_Amount__c == null ? 0 : pfm.Booked_Amount__c);
        	if (quarter.contains('Q1')){
        		system.debug(LoggingLevel.ERROR,'***booked before: ' + abgs.Booked_Q1__c + ', booked: ' + bookedAmt);
        		abgs.Booked_Q1__c += bookedAmt;
        		system.debug(LoggingLevel.ERROR,'***booked after: ' + abgs.Booked_Q1__c);
        		if (recordType != 'Contract' && pfm.Active__c){
	        		abgs.Wgt_Proposal_Q1__c += weightedForecastAmt;
	        		abgs.Full_Proposal_Q1__c += forecastAmt;
        		}	
        	} else if (quarter.contains('Q2')){
        		abgs.Booked_Q2__c += bookedAmt;
        		if (recordType != 'Contract' && pfm.Active__c){
	        		abgs.Wgt_Proposal_Q2__c += weightedForecastAmt;
	        		abgs.Full_Proposal_Q2__c += forecastAmt;
        		}		
        	} else if (quarter.contains('Q3')){
        		abgs.Booked_Q3__c += bookedAmt;
        		if (recordType != 'Contract' && pfm.Active__c){
	        		abgs.Wgt_Proposal_Q3__c += weightedForecastAmt;
	        		abgs.Full_Proposal_Q3__c += forecastAmt;
        		}		
        	} else if (quarter.contains('Q4')){
        		abgs.Booked_Q4__c += bookedAmt;
        		if (recordType != 'Contract' && pfm.Active__c){
	        		abgs.Wgt_Proposal_Q4__c += weightedForecastAmt;
	        		abgs.Full_Proposal_Q4__c += forecastAmt;
        		}	
        	}
        }
        
        upsert accBGList;
    }
    
    global void finish(Database.BatchableContext BC){
    
        System.debug(LoggingLevel.WARN,'Scheduling BatchUpdateBestGuessBooked');
        Best_Guess_Settings__c BGSettings = Best_Guess_Settings__c.getOrgDefaults();
		BGSettings.Batch_Use_Trigger__c = false;
		upsert BGSettings;
        //Build the system time of now + 20 seconds to schedule the batch apex.
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        //BatchUpdateBestGuessBooked acctBatch2Sched = new BatchUpdateBestGuessBooked();
        //Schedule the next job, and give it the system time so name is unique
        //System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
        BatchGovernorLimitUtility.updateBatchRun();
    }
    
    /*
    Method that accepts a string that represents a Quarter and returns the next Quarter
    param - String that represents a quarter in the form 'QQYYYY' e.g. 'Q12012'
    return - String that represents the next quarter in the form 'QQYYYY' e.g. 'Q22012'
    */
    private String getNextQuarter(String x){
        Integer q = Integer.valueOf(x.substring(1,2));
        Integer year = Integer.valueOf(x.substring(2));
        if (q == 4){
            year++;
        }
        q = math.mod(q, 4) + 1;
        return 'Q' + String.valueOf(q) + String.valueOf(year); 
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
    
    private void populateMap(){
    	accBGList = [Select Account__r.ID, OwnerID, Year__c, Delivery_Channel__c,
              Booked_Q1__c, Booked_Q2__c, Booked_Q3__c, Booked_Q4__c,
              Full_Proposal_Q1__c, Full_Proposal_Q2__c, Full_Proposal_Q3__c, Full_Proposal_Q4__c,
              Q1__c, Q2__c, Q3__c, Q4__c,
              Wgt_Proposal_Q1__c, Wgt_Proposal_Q2__c, Wgt_Proposal_Q3__c, Wgt_Proposal_Q4__c
              From Account_Best_Guess_Summary__c 
              Where Account__c in: accountSet];
        
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

}