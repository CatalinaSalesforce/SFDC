/*
@Name            : BatchEuropeCreateShellOpp 
@Author          : customersuccess@cloud62.com
@Date            : July 30, 2013
@Description     : Create shell opportunities to force the display of months on reports
					that are grouped by opportunity date fields

*/
global class BatchEuropeCreateShellOpp implements Database.Batchable<sObject>, Schedulable{
    
    public static final String COUNTRY_CODES = '(\'DE\',\'IT\')';
    
    String query;
    String limit1;
    String DECycle;
    String ITCycle;
    Integer year;
    String countryCode;
    
    public BatchEuropeCreateShellOpp(){
        year = Date.today().year();
        limit1 = '';
    }
    
    //method that gets the query used for this batch
    global Database.querylocator start(Database.BatchableContext BC){
        BatchGovernorLimitUtility.insertBatchRun('BatchEuropeCreateShellOpp');
    
        query = 'SELECT ID, NAME, Country__c FROM USER WHERE COUNTRY__C IN ' + COUNTRY_CODES
        + ' AND ID IN (SELECT OWNERID FROM ACCOUNT ) AND ISACTIVE = TRUE ' + limit1;
        return Database.getQueryLocator(query);
    }
    
    global void execute(SchedulableContext ctx) {
        BatchEuropeCreateShellOpp batch1 = new BatchEuropeCreateShellOpp();
        ID batchprocessid = Database.executeBatch(batch1,1);
    }
    
    //method that makes up the body of the batch process    
    global void execute(Database.BatchableContext NC, List<sObject> scope){
	    List<User> scopeList = (List<User>)scope;
	    Set<Id> OwnerIds = new Set<Id>();
	    for (User u : scopeList){
			OwnerIds.add(u.Id);
			countryCode = u.Country__c;
	    }
       
       //get Map of sales people and their accounts
        Map<Id, Id> accOwnerMaps = new Map<Id, Id>();
        for (Account a : [SELECT ID, OWNERID FROM ACCOUNT WHERE OWNERID IN: ownerIds AND TYPE != 'CONGLOMERATE' LIMIT 5000 ]){
            if (!accOwnerMaps.containsKey(a.OwnerId)){
                accOwnerMaps.put(a.OwnerId, a.Id);
            }
        }
        
        //populate cycleIDs
        List<Ad_Period__c> cycleList = [SELECT ID, NAME, TYPE__C FROM AD_PERIOD__C
        	WHERE START_DATE__C >=: Date.newInstance(year, 1, 1)
        	AND START_DATE__C <=: Date.newInstance(year, 12, 31)];
        for (Ad_Period__c ap : cycleList){
        	if (ap.Type__c == 'Manufacturing Germany' && DECycle == null) DECycle = ap.Id;
        	if (ap.Type__c == 'Manufacturing Italy' && ITCycle == null) ITCycle = ap.Id;
        	if (DECycle != null && ITCycle != null) break;
        }
        
        Map<String, Opportunity> oppMap = new Map<String, Opportunity>();
        List<Date> dateList = createDates();
        for (User u : scopeList){
			for (Date d : dateList){
				oppMap.put(u.Id + String.valueOf(d),createOpp(u, d, accOwnerMaps.get(u.Id)));
			}
		}
		
		insert oppMap.values();
		
		List<Program__c> insertProgs = new List<Program__c>();
		for (Opportunity o : oppMap.values()){
			if (countryCode == 'IT'){
				insertProgs.add(createProgram(o, 'Base'));
				insertProgs.add(createProgram(o, 'Digital'));
			} else {
				insertProgs.add(createProgram(o, 'CMG'));
				insertProgs.add(createProgram(o, 'ACA'));
			}
		}
		insert insertProgs;
		
		List<Program_Cycle_Amount__c> insertPCA = new List<Program_Cycle_Amount__c>(); 
		for (Program__c p : insertProgs){
			insertPCA.add(createPCA(p));
		}
		insert insertPCA;
       
    }
    
    //method that runs after the execute() method
    global void finish(Database.BatchableContext BC){
    
        System.debug(LoggingLevel.WARN,'Temp_Delete_DeleteSM1Forecast');
        //Build the system time of now + 20 seconds to schedule the batch apex.
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        //BatchDeleteManagerBestGuess acctBatch2Sched = new BatchDeleteManagerBestGuess();
        BatchSummarizeAccBGSR2COPY acctBatch2Sched = new BatchSummarizeAccBGSR2COPY();
        //Schedule the next job, and give it the system time so name is unique
        //System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
        BatchGovernorLimitUtility.updateBatchRun();
    }
    
    private Opportunity createOpp(User u, Date d, String a){
		Opportunity newOpp = new Opportunity();
		newOpp.For_Reporting__c=true;
		newOpp.Name='Shell Opp - ' + getStringMonth(d);
		newOpp.StageName='Closed Won';
		newOpp.CloseDate = d;
		newOpp.Start_Date__c = d;
		if (newOpp.Start_Date__c < Date.newInstance(year, 1, 1)) newOpp.Start_Date__c = Date.newInstance(year, 1, 1);
		newOpp.AccountId=a;
		newOpp.CurrencyIsoCode = 'EUR';
		newOpp.OwnerId = u.Id;
		return newOpp;
    }
    
    /*
	Takes a date and returns a month in the MM format
	*/
    private String getStringMonth(Date d){
        String result;
        result = String.valueOf(d.year()) + '-';
        if (d.month() < 10){
            result += '0' + String.valueOf(d.month());
        } else {
            result += String.valueOf(d.month());
        }
        return result;
    }
    
    private List<Date> createDates(){
    	List<Date> returnList = new List<Date>();
    	returnList.add(Date.newInstance(year - 1, 9, 1));
    	returnList.add(Date.newInstance(year - 1, 10, 1));
    	returnList.add(Date.newInstance(year - 1, 11, 1));
    	returnList.add(Date.newInstance(year - 1, 12, 1));
    	returnList.add(Date.newInstance(year, 1, 1));
    	returnList.add(Date.newInstance(year, 2, 1));
    	returnList.add(Date.newInstance(year, 3, 1));
    	returnList.add(Date.newInstance(year, 4, 1));
    	returnList.add(Date.newInstance(year, 5, 1));
    	returnList.add(Date.newInstance(year, 6, 1));
    	returnList.add(Date.newInstance(year, 7, 1));
    	returnList.add(Date.newInstance(year, 8, 1));
    	returnList.add(Date.newInstance(year, 9, 1));
    	returnList.add(Date.newInstance(year, 10, 1));
    	returnList.add(Date.newInstance(year, 11, 1));
    	returnList.add(Date.newInstance(year, 12, 1));
    	return returnList;
    }
    
    private Program__c createProgram(Opportunity o, String delChan){
    	Program__c p = new Program__c();
    	p.Opportunity__c = o.Id;
    	p.Delivery_Type__c = delChan;
    	p.CurrencyIsoCode = 'EUR';
    	p.Program_Amount__c = 0;
    	return p;
    }
    
    private Program_Cycle_Amount__c createPCA (Program__c p){
    	Program_Cycle_Amount__c newPCA = new Program_Cycle_Amount__c();
    	newPCA.Program__c = p.Id;
    	String cycleID;
    	if (countryCode == 'IT'){
    		cycleID = ITCycle;
    	} else {
    		cycleID = DECycle;
    	}
    	newPCA.Cycle__c = cycleID;
    	newPCA.CurrencyIsoCode = 'EUR';
    	return newPCA;
    }
}