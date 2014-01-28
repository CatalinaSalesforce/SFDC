/*
@Name            : BatchDeleteSalesRepBestGuess 
@Author          : customersuccess@cloud62.com
@Date            : December 17th, 2012
@Description     : Sets all best guess records to 0 so that we can recalculate it
Jan 24 2013 - change batch size to 50 to avoid soql exception
*/
global class BatchDeleteSalesRepBestGuess implements Database.Batchable<sObject>, Schedulable{
    
    final static String defaultSettingsName = 'Default';
    
    String query;
    String limit1;
    String yearInput;
    
    public BatchDeleteSalesRepBestGuess(String yearParam){
        yearInput = yearParam;
    }
    
    public BatchDeleteSalesRepBestGuess(){
        limit1 = '';
        yearInput = String.valueOf(Date.today().year() - 1);
    }
    
    //method that gets the query used for this batch
    global Database.querylocator start(Database.BatchableContext BC){
    	Best_Guess_Settings__c settings1 = Best_Guess_Settings__c.getOrgDefaults(); 
        settings1.Skip_Trigger__c = true;
        upsert settings1;
        
        BatchGovernorLimitUtility.insertBatchRun('BatchDeleteSalesRepBestGuess');
        query = 'Select Id From Sales_Rep_Best_Guess__c ';
        system.debug(LoggingLevel.ERROR, '***QUERY: ' + query);
        return Database.getQueryLocator(query);
    }
    
    //Jan 24, 2013 - set batch size to 50 to avoid soql exception
    global void execute(SchedulableContext ctx) {
        BatchDeleteSalesRepBestGuess batch1 = new BatchDeleteSalesRepBestGuess(yearInput);
        ID batchprocessid = Database.executeBatch(batch1, 50);
    }
    
    //method that makes up the body of the batch process
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        Datetime currentTime = System.now();
        /* //old execute
        delete scope;
        */
        
        //get forecast settings, and bucket users by Forecast Role
        Catalina_Forecast_Settings__c settings = Catalina_Forecast_Settings__c.getInstance(defaultSettingsName);
        String rep2Type = settings.Rep_2_String__c;
        String rep1Type = settings.Rep_1_String__c;
        String SM2Type = settings.SM_2_String__c;
        String SM1Type = settings.SM_1_String__c;
        String coopType = settings.Coop_String__c;
        
        Set<Id> rep2Users = new Set<Id>();
        Set<Id> rep1Users = new Set<Id>();
        Set<Id> sm2Users = new Set<Id>();
        Set<Id> sm1Users = new Set<Id>();
        List<User> userList = [SELECT ID, Forecast_Role__c FROM User Where Forecast_Role__c != null];
        for (User a : userList){
            if (a.Forecast_Role__c == rep2Type){
                rep2Users.add(a.Id);
            } else if (a.Forecast_Role__c == rep1Type){
                rep1Users.add(a.Id);
            } else if (a.Forecast_Role__c == sm2Type){
                sm2Users.add(a.Id);
            } else if (a.Forecast_Role__c == sm1Type || a.Forecast_Role__c == coopType){
                sm1Users.add(a.Id);
            } 
        }
        
        //set all SRBG amounts to 0, this will roll up the chain
        List<Sales_Rep_Best_Guess__c> scopeSRBG = (List<Sales_Rep_Best_Guess__c>)scope;
        
        for (Sales_Rep_Best_Guess__c a : scopeSRBG){
            a.Actual_Amount__c = 0;
            a.Forecast_Contract__c = 0;
            a.Forecast_Proposal__c = 0;
            a.Weighted_forecast_Proposal__c = 0;
            a.Previous_Year_Actual__c = 0;
            a.M_A_Actual_Amount__c = 0;
            a.M_A_Forecast_Contract__c = 0;
            a.M_A_Forecast_Proposal__c = 0;
            a.M_A_Weighted_Forecast_Proposal__c = 0;
            a.M_B_Actual_Amount__c = 0;
            a.M_B_Forecast_Contract__c = 0;
            a.M_B_Forecast_Proposal__c = 0;
            a.M_B_Weighted_Forecast_Proposal__c = 0;
            a.M_D_Actual_Amount__c = 0;
            a.M_D_Forecast_Contract__c = 0;
            a.M_D_Forecast_Proposal__c = 0;
            a.M_D_Weighted_Forecast_Proposal__c = 0;
            a.M_M_Actual_Amount__c = 0;
            a.M_M_Forecast_Contract__c = 0;
            a.M_M_Forecast_Proposal__c = 0;
            a.M_M_Weighted_Forecast_Proposal__c = 0;
            a.R_A_Actual_Amount__c = 0;
            a.R_A_Forecast_Contract__c = 0;
            a.R_A_Forecast_Proposal__c = 0;
            a.R_A_Weighted_Forecast_Proposal__c = 0;
            a.R_B_Actual_Amount__c = 0;
            a.R_B_Forecast_Contract__c = 0;
            a.R_B_Forecast_Proposal__c = 0;
            a.R_B_Weighted_Forecast_Proposal__c = 0;
            a.R_D_Actual_Amount__c = 0;
            a.R_D_Forecast_Contract__c = 0;
            a.R_D_Forecast_Proposal__c = 0;
            a.R_D_Weighted_Forecast_Proposal__c = 0;
            a.R_M_Actual_Amount__c = 0;
            a.R_M_Forecast_Contract__c = 0;
            a.R_M_Forecast_Proposal__c = 0;
            a.R_M_Weighted_Forecast_Proposal__c = 0;
        }
        
        update scopeSRBG;
        
        BatchGovernorLimitUtility.calcualteLimits(Limits.getCpuTime(), Limits.getDMLRows(), Limits.getDMLStatements(), Limits.getHeapSize(), Limits.getQueries(), Limits.getQueryRows(), Limits.getScriptStatements(), scope, currentTime, System.now());
    }
    
    //method that runs after the execute() method
    global void finish(Database.BatchableContext BC){
    	Best_Guess_Settings__c settings1 = Best_Guess_Settings__c.getOrgDefaults(); 
        settings1.Skip_Trigger__c = false;
        update settings1;
        
        System.debug(LoggingLevel.WARN,'Temp_Delete_DeleteSM1Forecast');
        //Build the system time of now + 20 seconds to schedule the batch apex.
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
    	BatchDeleteManagerBestGuess acctBatch2Sched = new BatchDeleteManagerBestGuess();
    	//Schedule the next job, and give it the system time so name is unique
    	System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
        BatchGovernorLimitUtility.updateBatchRun();
    }

}