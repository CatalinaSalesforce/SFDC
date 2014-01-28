global class BatchCreateBestGuess implements Database.Batchable<sObject>, Schedulable{
	
	//List<String> Quarters = new List<String>{'Q1', 'Q2', 'Q3', 'Q4'};
	final static String q1Start = '-01-01';
    final static String q2Start = '-04-01';
    final static String q3Start = '-07-01';
    final static String q4Start = '-10-01';
    final static String q1End = '-03-31';
    final static String q2End = '-06-30';
    final static String q3End = '-09-30';
    final static String q4End = '-12-31';
	
	String query;
	String quarter;
	Set<Id> managerList;
	Set<Id> sellingList;
	Set<Id> activeList;
	Map<Id, Id> userManagerMap;
	Map<Id, Id> managerMBGmap;
	Map<Id, String> userNameMap;
	Map<Id, String> userForecastRoleMap;
	List<Manager_Best_Guess__c> insertMBG;
	List<Sales_Rep_Best_Guess__c> insertSRBG;
	
	public BatchCreateBestGuess(String x){
		quarter = x;
	}
	
	public BatchCreateBestGuess(){
		quarter = '';
	}
	
	//method that gets the query used for this batch
    global Database.querylocator start(Database.BatchableContext BC){
        query = 'SELECT ID, Name FROM USER LIMIT 1';
        if (quarter == '') query = '';
        system.debug('***query = ' + query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(SchedulableContext ctx) {
        BatchCreateBestGuess batch1 = new BatchCreateBestGuess(quarter);
        ID batchprocessid = Database.executeBatch(batch1);
	}
    
    //method that makes up the body of the batch process    
    global void execute(Database.BatchableContext NC, List<sObject> scope){
    	
    	activeList = new Set<Id>();
    	managerList = new Set<ID>();
    	sellingList = new Set<ID>();
    	userManagerMap = new Map<Id, Id>();
    	userForecastRoleMap = new Map<Id, String>();
    	managerMBGMap = new Map<Id, Id>();
    	userNameMap = new Map<Id, String>();
    	insertSRBG = new List<Sales_Rep_Best_Guess__c>();
    	insertMBG = new List<Manager_Best_Guess__c>();
    	
    	for (User a : [SELECT Id, Name, IsActive From User]){
    		If (a.IsActive == true) activeList.add(a.Id);
    		userNameMap.put(a.Id, a.Name);
    	}
    	
    	List<User> users = [SELECT Id, Name, ManagerId, Forecast_Role__c, Does_Sell__c From User Where Forecast_Role__c != null And IsActive = true];
    	for (User a : users){
    		if (activeList.contains(a.ManagerId)){
	    		if (a.ManagerId != null){
	    			managerList.add(a.ManagerId);
	    			userManagerMap.put(a.Id, a.ManagerId);
	    			userForecastRoleMap.put(a.Id, a.Forecast_Role__c);
	    		}
	    		if (a.Does_Sell__c == true) sellingList.add(a.Id);
    		}
    	}
    	
    	for (String x : managerList){
			Manager_Best_Guess__c a = new Manager_Best_Guess__c();
			a.OwnerId = x;
			a.Quarter__c = quarter;
			a.Quarter_Start_Date__c = Date.valueOf(getStartQuarter(quarter));
			a.Quarter_End_Date__c = Date.valueOf(getEndQuarter(quarter));
			a.Forecast_Role__c = userForecastRoleMap.get(x);
			a.Name = userNameMap.get(x) + ' - ' + quarter;
			if (userManagerMap.containsKey(x)) a.Manager__c = userManagerMap.get(x);
			insertMBG.add(a);
    	}
    	
    	insert insertMBG;
    	
    	List<Manager_Best_Guess__c> managerMBG = [Select Id, OwnerId, Manager__c
    		From Manager_Best_Guess__c Where OwnerId In: managerList And Quarter__c =:quarter];
    		
    	for (Manager_Best_Guess__c a : managerMBG){
    		if (!managerMBGMap.containsKey(a.OwnerId)) managerMBGMap.put(a.OwnerId, a.Id);
    	}
    	
    	List<Manager_Best_Guess__c> newMBG = [SELECT Id, OwnerId, Manager__c, Manager_Best_Guess__c 
    		From Manager_Best_Guess__c Where Manager__c != null AND Manager_Best_Guess__c = null AND Quarter__c =: quarter];
    	system.debug('***before setting update managers');
    	for (Manager_Best_Guess__c a : newMBG){
    		if (managerMBGmap.containsKey(a.Manager__c)) a.Manager_Best_Guess__c = managerMBGMap.get(a.Manager__c); 
    	}
    	
    	update newMBG;
    	
    	for (String x : sellingList){
			Sales_Rep_Best_Guess__c a = new Sales_Rep_Best_Guess__c();
			a.OwnerId = x;
			a.Quarter__c = quarter;
			a.Quarter_Start_Date__c = Date.valueOf(getStartQuarter(quarter));
			a.Quarter_End_Date__c = Date.valueOf(getEndQuarter(quarter));
			a.Name = userNameMap.get(x) + ' - ' + quarter;
			if (managerList.contains(x)){
				a.Manager__c = x;
				a.Manager_Best_Guess__c = managerMBGMap.get(x);
			} else if (userManagerMap.containsKey(x)){
				a.Manager__c = userManagerMap.get(x);
				a.Manager_Best_Guess__c = managerMBGMap.get(userManagerMap.get(x));
			}
			insertSRBG.add(a);
    	}
    	
    	insert insertSRBG;
    	
    }
    
    //method that runs after the execute() method
    global void finish(Database.BatchableContext BC){
    	
        System.debug(LoggingLevel.WARN,'Temp_Delete_DeleteSM1Forecast');
        //Build the system time of now + 20 seconds to schedule the batch apex.
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        if (quarter == 'Q12012'){
	        BatchCreateBestGuess acctBatch2Sched = new BatchCreateBestGuess('Q22012');
	        //Schedule the next job, and give it the system time so name is unique
	        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
        } else if (quarter == 'Q22012'){
	        BatchCreateBestGuess acctBatch2Sched = new BatchCreateBestGuess('Q32012');
	        //Schedule the next job, and give it the system time so name is unique
	        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
        } else if (quarter == 'Q32012'){
	        BatchCreateBestGuess acctBatch2Sched = new BatchCreateBestGuess('Q42012');
	        //Schedule the next job, and give it the system time so name is unique
	        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
        } else if (quarter == 'Q42012'){
	        BatchCreateBestGuess acctBatch2Sched = new BatchCreateBestGuess('Q12013');
	        //Schedule the next job, and give it the system time so name is unique
	        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
        } else if (quarter == 'Q12013'){
	        BatchCreateBestGuess acctBatch2Sched = new BatchCreateBestGuess('Q22013');
	        //Schedule the next job, and give it the system time so name is unique
	        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
        } else if (quarter == 'Q22013'){
	        BatchCreateBestGuess acctBatch2Sched = new BatchCreateBestGuess('Q32013');
	        //Schedule the next job, and give it the system time so name is unique
	        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
        } else if (quarter == 'Q32013'){
	        BatchCreateBestGuess acctBatch2Sched = new BatchCreateBestGuess('Q42013');
	        //Schedule the next job, and give it the system time so name is unique
	        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
        } else if (quarter == 'Q42013'){
	        BatchUpdateSDPY acctBatch2Sched = new BatchUpdateSDPY();
	        //Schedule the next job, and give it the system time so name is unique
	        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
	        
        }
        
    }
    
    /*
    Method that accepts a string that represents a Quarter and returns the first day of that quarter
    param - String that represents a quarter in the form 'QQYYYY' e.g. 'Q12012'
    return - The String representation of the first day of that quarter in the form 'YYYY-MM-DD' e.g. '2012-01-01'
    */
    private String getStartQuarter(String x){
        String result = x.substring(2);
        String quarter = x.substring(0,2);
        if (quarter == 'Q1'){
            result += q1Start; 
        } else if (quarter == 'Q2'){
            result += q2Start;
        } else if (quarter == 'Q3'){
            result += q3Start;
        } else {
            result += q4Start;
        } 
        return result;
    }
    
    
    /*
    Method that accepts a string that represents a Quarter and returns the last day of that quarter
    param - String that represents a quarter in the form 'QQYYYY' e.g. 'Q12012'
    return - The String representation of the first day of that quarter in the form 'YYYY-MM-DD' e.g. '2012-03-31'
    */
    private String getEndQuarter(String x){
        
        String result = x.substring(2);
        
        String quarter = x.substring(0,2);
        
        if (quarter == 'Q1'){
            result += q1End; 
        } else if (quarter == 'Q2'){
            result += q2End;
        } else if (quarter == 'Q3'){
            result += q3End;
        } else {
            result += q4End;
        }
        return result;
    }

}