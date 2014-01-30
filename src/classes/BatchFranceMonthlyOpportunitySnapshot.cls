/*
@Name           : BatchFranceMonthlyOpportunitySnapshot
@Author         : customersuccess@cloud62.com
@Date           : 2012-12-14
@Description    : Class to populate France_Account_Quota__c
*/
global class BatchFranceMonthlyOpportunitySnapshot implements Database.Batchable<sObject>, Schedulable{

    final static String EUR = 'EUR';
    
    String query;
    String limit1;
    Boolean allOpps = false;
    
    public BatchFranceMonthlyOpportunitySnapshot (String x){
        limit1 = x;
    }
    
    public BatchFranceMonthlyOpportunitySnapshot (Boolean x){
        if (x == true) allOpps = true;
    }
    
    public BatchFranceMonthlyOpportunitySnapshot (){
        limit1 = '';
    }
    
    global void execute(SchedulableContext ctx) {
        BatchFranceMonthlyOpportunitySnapshot batch1 = new BatchFranceMonthlyOpportunitySnapshot();
        ID batchprocessid = Database.executeBatch(batch1, 200);
    }
    
    global Database.querylocator start(Database.BatchableContext BC){
    	 Set<Id> rtIDs = new Set<Id>();
	      for(RecordType r : [SELECT ID, NAME
	      FROM RECORDTYPE
	      WHERE SOBJECTTYPE = 'OPPORTUNITY'
	      AND NAME LIKE '%FRANCE%']){
	        rtIDs.add(r.Id);
	      }
		Integer year = 0;
		if (Date.Today().month() == 1){
			year = Date.today().year() - 1;
		} else {
			year = Date.today().year();
		}
		Integer month = Date.today().addMonths(-1).month();
		Integer beginDay = 1;
		Date beginMonth = Date.newInstance(year, month, beginDay);
		Date endMonth = beginMonth.addMonths(1).addDays(-1);
		String beginMonthString = String.valueOf(beginMonth);
		String endMonthString = String.valueOf(endMonth);
		
		system.debug('***beginMonth: ' + beginMonthString);
		system.debug('***endMonth: ' + endMonthString);
		
        query = 'SELECT ID, NAME, AMOUNT, CLOSEDATE, ExpectedRevenue FROM OPPORTUNITY '
        	+ ' WHERE RECORDTYPEID IN :rtIDs AND CLOSEDATE >= :beginMonth '
        	+ ' AND CLOSEDATE <= :endMonth '
        	+ ' AND FOR_REPORTING__C = FALSE ';
        	
        if (allOpps == true){
        	query = 'SELECT ID, NAME, AMOUNT, CLOSEDATE, ExpectedRevenue FROM OPPORTUNITY '
        	+ ' WHERE FOR_REPORTING__C = FALSE '
        	+ ' AND CLOSEDATE <= :endMonth '; 
        }
        system.debug('***query: ' + query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        List<Opportunity> scopeList = (List<Opportunity>)scope;
        Set<Id> oppIDs = new Set<Id>();
        List<Opportunity_Amount_Snapshot__c> insertOAS = new List<Opportunity_Amount_Snapshot__c>(); 
        for (Opportunity o : scopeList){
        	system.debug('***oppID: ' + o.Id);
        	Opportunity_Amount_Snapshot__c newOAS = new Opportunity_Amount_Snapshot__c();
        	newOAS.Opportunity__c = o.Id;
        	newOAS.Amount__c = o.Amount;
        	newOAS.Weighted_Amount__c = o.ExpectedRevenue;
        	newOAS.Archive_Date__c = Date.today();
        	newOAS.Most_Current__c = true;
        	newOAS.CurrencyISOCode = EUR;
        	insertOAS.add(newOAS);
        	
        	oppIDs.add(o.Id);
        }
        
        List<Opportunity_Amount_Snapshot__c> oldOASList = [SELECT ID, MOST_CURRENT__C
        	FROM Opportunity_Amount_Snapshot__c
        	WHERE OPPORTUNITY__C IN: oppIDs
        	AND MOST_CURRENT__C = TRUE];
        for (Opportunity_Amount_Snapshot__c o : oldOASList){
        	o.Most_Current__c = false;
        }
        
        update oldOASList;
        insert insertOAS;
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
}