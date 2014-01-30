/*
@Name            : BatchUpdateBestGuessBooked 
@Author          : customersuccess@cloud62.com
@Date            : September 17th, 2013
@Description     : Batch Process to update Best Guess with Booked Info
*/
global class BatchUpdateBestGuessBooked implements Database.Batchable<sObject>, Schedulable{
    
    final static String defaultSettingsName = 'Default';
    
    String query;
    String limit1;
    
    public BatchUpdateBestGuessBooked(String limitParam){
        limit1 = limitParam;
    }
    
    public BatchUpdateBestGuessBooked(){
        limit1 = '';
    }
    
    //method that gets the query used for this batch
    global Database.querylocator start(Database.BatchableContext BC){
        query = 'SELECT ID, OWNERID, QUARTER__C, Manager__c, Manager_Best_Guess__c, '
            + ' Manufacturing_Base_Best_Guess__c, Manufacturing_Base_High__c, Manufacturing_Base_Low__c, '
            + ' Manufacturing_Digital_Best_Guess__c, Manufacturing_Digital_High__c, Manufacturing_Digital_Low__c, '
            + ' Manufacturing_Audience_Best_Guess__c, Manufacturing_Audience_High__c, Manufacturing_Audience_Low__c, '
            + ' Manufacturing_Mobile_Best_Guess__c, Manufacturing_Mobile_High__c, Manufacturing_Mobile_Low__c, '
            + ' Retail_Base_Best_Guess__c, Retail_Base_High__c, Retail_Base_Low__c, '
            + ' Retail_Digital_Best_Guess__c, Retail_Digital_High__c, Retail_Digital_Low__c, '
            + ' Retail_Audience_Best_Guess__c, Retail_Audience_High__c, Retail_Audience_Low__c, '
            + ' Retail_Mobile_Best_Guess__c, Retail_Mobile_High__c, Retail_Mobile_Low__c, '
            + ' M_A_Booked_Actual__c, M_B_Booked_Actual__c, M_D_Booked_Actual__c, M_M_Booked_Actual__c, '
            + ' R_A_Booked_Actual__c, R_B_Booked_Actual__c, R_D_Booked_Actual__c, R_M_Booked_Actual__c '
            + 'From Sales_Rep_Best_Guess__c ' + limit1;
        system.debug(LoggingLevel.ERROR, '***QUERY: ' + query);
        return Database.getQueryLocator(query);
    }
    
    //Jan 24, 2013 - set batch size to 50 to avoid soql exception
    global void execute(SchedulableContext ctx) {
        BatchUpdateBestGuessBooked batch1 = new BatchUpdateBestGuessBooked();
        ID batchprocessid = Database.executeBatch(batch1, 50);
    }
    
    //method that makes up the body of the batch process
    global void execute(Database.BatchableContext NC, List<sObject> scope){
    	//set all SRBG amounts to 0, this will roll up the chain
        List<Sales_Rep_Best_Guess__c> scopeSRBG = (List<Sales_Rep_Best_Guess__c>)scope;
        
        for (Sales_Rep_Best_Guess__c a : scopeSRBG){
        	if (isPastQuarter(a.Quarter__c)){
        		a.Manufacturing_Audience_Best_Guess__c = a.M_A_Booked_Actual__c;
        		a.Manufacturing_Base_Best_Guess__c = a.M_B_Booked_Actual__c;
        		a.Manufacturing_Digital_Best_Guess__c = a.M_D_Booked_Actual__c;
        		a.Manufacturing_Mobile_Best_Guess__c = a.M_M_Booked_Actual__c;
        		a.Retail_Audience_Best_Guess__c = a.R_A_Booked_Actual__c;
        		a.Retail_Base_Best_Guess__c = a.R_B_Booked_Actual__c;
        		a.Retail_Digital_Best_Guess__c = a.R_D_Booked_Actual__c;
        		a.Retail_Mobile_Best_Guess__c = a.R_M_Booked_Actual__c;
        	}
        }
        
        update scopeSRBG;
    }
    
    //method that runs after the execute() method
    global void finish(Database.BatchableContext BC){
        System.debug(LoggingLevel.WARN,'Temp_Delete_DeleteSM1Forecast');
        //Build the system time of now + 20 seconds to schedule the batch apex.
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        BatchUpdateManagerBestGuessBooked acctBatch2Sched = new BatchUpdateManagerBestGuessBooked();
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
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