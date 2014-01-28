/*
@Name            : BatchUpdateManagerBestGuessBooked 
@Author          : customersuccess@cloud62.com
@Date            : September 17th, 2013
@Description     : Batch Process to update Best Guess with Booked Info
Oct 9 2013 - change next scheduled class as a part of the redesign process
*/
global class BatchUpdateManagerBestGuessBooked implements Database.Batchable<sObject>, Schedulable{
    
    final static String defaultSettingsName = 'Default';
    
    String query;
    String limit1;
    
    public BatchUpdateManagerBestGuessBooked(String limitParam){
        limit1 = limitParam;
    }
    
    public BatchUpdateManagerBestGuessBooked(){
        limit1 = '';
    }
    
    //method that gets the query used for this batch
    global Database.querylocator start(Database.BatchableContext BC){
        query = 'Select m.QUARTER__C, '
        	+ ' m.Team_Retail_Digital_Low__c, m.Team_Retail_Digital_High__c, m.Team_Retail_Digital_Best_Guess__c, ' 
	        + ' m.Team_Retail_Base_Low__c, m.Team_Retail_Base_High__c, m.Team_Retail_Base_Best_Guess__c, m.Team_Quota__c, m.Team_Manufacturing_Digital_Low__c,  '
	        + ' m.Team_Manufacturing_Digital_High__c, m.Team_Manufacturing_Digital_Best_Guess__c, m.Team_Manufacturing_Base_Low__c, m.Team_Manufacturing_Base_High__c, ' 
	        + ' m.Team_Manufacturing_Base_Best_Guess__c, m.Team_Booked_Proposal__c, m.Team_Booked_Actual__c, m.OwnerId, m.Name, m.Manager_Best_Guess__c, m.Id, '
	        + ' m.Team_Previous_Year_Actual__c, m.Team_Booked_Full_Proposal__c, '
	        + ' m.Team_M_A_Booked_Actual__c, m.Team_M_A_Booked_Full_Proposal__c, m.Team_M_A_Booked_Proposal__c, '
	        + ' m.Team_M_B_Booked_Actual__c, m.Team_M_B_Booked_Full_Proposal__c, m.Team_M_B_Booked_Proposal__c, '
	        + ' m.Team_M_D_Booked_Actual__c, m.Team_M_D_Booked_Full_Proposal__c, m.Team_M_D_Booked_Proposal__c, '
	        + ' m.Team_M_M_Booked_Actual__c, m.Team_M_M_Booked_Full_Proposal__c, m.Team_M_M_Booked_Proposal__c, '
	        + ' m.Team_R_A_Booked_Actual__c, m.Team_R_A_Booked_Full_Proposal__c, m.Team_R_A_Booked_Proposal__c, '
	        + ' m.Team_R_B_Booked_Actual__c, m.Team_R_B_Booked_Full_Proposal__c, m.Team_R_B_Booked_Proposal__c, '
	        + ' m.Team_R_D_Booked_Actual__c, m.Team_R_D_Booked_Full_Proposal__c, m.Team_R_D_Booked_Proposal__c, '
	        + ' m.Team_R_M_Booked_Actual__c, m.Team_R_M_Booked_Full_Proposal__c, m.Team_R_M_Booked_Proposal__c, '
	        + ' m.Team_Manufacturing_Audience_Best_Guess__c, m.Team_Manufacturing_Audience_High__c, m.Team_Manufacturing_Audience_Low__c, '
	        + ' m.Team_Manufacturing_Mobile_Best_Guess__c, m.Team_Manufacturing_Mobile_High__c, m.Team_Manufacturing_Mobile_Low__c, '
	        + ' m.Team_Retail_Audience_Best_Guess__c, m.Team_Retail_Audience_High__c, m.Team_Retail_Audience_Low__c, '
	        + ' m.Team_Retail_Mobile_Best_Guess__c, m.Team_Retail_Mobile_High__c, m.Team_Retail_Mobile_Low__c,  '
	        + ' m.Override_Team_Retail_Mobile_Low__c, m.Override_Team_Retail_Mobile_High__c, m.Override_Team_Retail_Mobile_Best_Guess__c, '
	        + ' m.Override_Team_Retail_Digital_Low__c, m.Override_Team_Retail_Digital_High__c, m.Override_Team_Retail_Digital_Best_Guess__c, '
	        + ' m.Override_Team_Retail_Base_Low__c, m.Override_Team_Retail_Base_High__c, m.Override_Team_Retail_Base_Best_Guess__c, '
	        + ' m.Override_Team_Retail_Audience_Low__c, m.Override_Team_Retail_Audience_High__c, m.Override_Team_Retail_Audience_Best_Guess__c, '
	        + ' m.Override_Team_Manu_Mobile_Low__c, m.Override_Team_Manu_Mobile_High__c, m.Override_Team_Manu_Mobile_Best_Guess__c, '
	        + ' m.Override_Team_Manu_Digital_Low__c, m.Override_Team_Manu_Digital_High__c, m.Override_Team_Manu_Digital_Best_Guess__c, '
	        + ' m.Override_Team_Manu_Base_Low__c, m.Override_Team_Manu_Base_High__c, m.Override_Team_Manu_Base_Best_Guess__c, '
	        + ' m.Override_Team_Manu_Audience_Low__c, m.Override_Team_Manu_Audience_High__c, m.Override_Team_Manu_Audience_Best_Guess__c, '
	        + ' m.Use_Override__c '
	        + ' From Manager_Best_Guess__c m ' + limit1;
        system.debug(LoggingLevel.ERROR, '***QUERY: ' + query);
        return Database.getQueryLocator(query);
    }
    
    //Jan 24, 2013 - set batch size to 50 to avoid soql exception
    global void execute(SchedulableContext ctx) {
        BatchUpdateManagerBestGuessBooked batch1 = new BatchUpdateManagerBestGuessBooked();
        ID batchprocessid = Database.executeBatch(batch1, 50);
    }
    
    //method that makes up the body of the batch process
    global void execute(Database.BatchableContext NC, List<sObject> scope){
    	//set all SRBG amounts to 0, this will roll up the chain
        List<Manager_Best_Guess__c> scopeMBG = (List<Manager_Best_Guess__c>)scope;
        
        for (Manager_Best_Guess__c a : scopeMBG){
        	if (isPastQuarter(a.Quarter__c)){
        		a.Override_Team_Manu_Audience_Best_Guess__c = a.Team_M_A_Booked_Actual__c;
        		a.Override_Team_Manu_Base_Best_Guess__c = a.Team_M_B_Booked_Actual__c;
        		a.Override_Team_Manu_Digital_Best_Guess__c = a.Team_M_D_Booked_Actual__c;
        		a.Override_Team_Manu_Mobile_Best_Guess__c = a.Team_M_M_Booked_Actual__c;
        		a.Override_Team_Retail_Audience_Best_Guess__c = a.Team_R_A_Booked_Actual__c;
        		a.Override_Team_Retail_Base_Best_Guess__c = a.Team_R_B_Booked_Actual__c;
        		a.Override_Team_Retail_Digital_Best_Guess__c = a.Team_R_D_Booked_Actual__c;
        		a.Override_Team_Retail_Mobile_Best_Guess__c = a.Team_R_M_Booked_Actual__c;
        	}
        }
        
        update scopeMBG;
    }
    
    //method that runs after the execute() method
    global void finish(Database.BatchableContext BC){
        System.debug(LoggingLevel.WARN,'Scheduling BatchCreateAccountBG');
        //Build the system time of now + 20 seconds to schedule the batch apex.
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        BatchCreateAccountBG acctBatch2Sched = new BatchCreateAccountBG();
        //Schedule the next job, and give it the system time so name is unique
        //System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
    }
    
    private Boolean isPastQuarter(String quarterParam){
    	Boolean result;
    	String quarter = quarterParam.subString(0,2);
    	Integer year = Integer.valueOf(quarterParam.subString(2, 6));
    	if (year < Date.today().year()){
    		result = true;
    	} else if ( year == Date.today().year()){
    		if (quarter == 'Q1' && Date.today().month() > 3){
    			result = true;
    		} else if (quarter == 'Q2' && Date.today().month() > 6){
    			result = true;
    		} else if (quarter == 'Q3' && Date.today().month() > 9){
    			result = true;
    		} else if (quarter == 'Q4' && Date.today().month() > 12){
    			//not possible
    			result = true;
    		} else {
    			result = false;
    		}
    		
    	} else {
    		result  = false;
    	}
    	return result;
    }

}