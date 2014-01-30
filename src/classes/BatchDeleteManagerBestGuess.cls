global class BatchDeleteManagerBestGuess implements Database.Batchable<sObject>, Schedulable{
    
    String query;
    String limit1;
    
    public BatchDeleteManagerBestGuess(String x){
    	limit1 = x;
    }
    
    public BatchDeleteManagerBestGuess(){
    	limit1 = '';
    }
    
    //method that gets the query used for this batch
    global Database.querylocator start(Database.BatchableContext BC){
        Best_Guess_Settings__c settings1 = Best_Guess_Settings__c.getOrgDefaults(); 
        settings1.Skip_Trigger__c = true;
        upsert settings1;
        
        query = 'Select Id From Manager_Best_Guess__c ' + limit1;
        return Database.getQueryLocator(query);
    }
    
    global void execute(SchedulableContext ctx) {
        BatchDeleteManagerBestGuess batch1 = new BatchDeleteManagerBestGuess();
        ID batchprocessid = Database.executeBatch(batch1);
    }
    
    //method that makes up the body of the batch process
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        List<Manager_Best_Guess__c> scopeMBG = (List<Manager_Best_Guess__c>)scope;
        for (Manager_Best_Guess__c a : scopeMBG){
            a.Team_Previous_Year_Actual__c = 0;
            a.Team_M_A_Booked_Actual__c = 0;
            a.Team_M_A_Booked_Full_Proposal__c = 0;
            a.Team_M_A_Booked_Proposal__c  = 0;
            a.Team_M_B_Booked_Actual__c  = 0;
            a.Team_M_B_Booked_Full_Proposal__c  = 0;                
            a.Team_M_B_Booked_Proposal__c  = 0;
            a.Team_M_D_Booked_Actual__c  = 0;
            a.Team_M_D_Booked_Full_Proposal__c  = 0;
            a.Team_M_D_Booked_Proposal__c  = 0;
            a.Team_M_M_Booked_Actual__c  = 0;
            a.Team_M_M_Booked_Full_Proposal__c  = 0;
            a.Team_M_M_Booked_Proposal__c  = 0;
            a.Team_R_A_Booked_Actual__c  = 0;
            a.Team_R_A_Booked_Full_Proposal__c  = 0;
            a.Team_R_A_Booked_Proposal__c  = 0;                
            a.Team_R_B_Booked_Actual__c  = 0;
            a.Team_R_B_Booked_Full_Proposal__c  = 0;
            a.Team_R_B_Booked_Proposal__c  = 0;
            a.Team_R_D_Booked_Actual__c  = 0;
            a.Team_R_D_Booked_Full_Proposal__c  = 0;
            a.Team_R_D_Booked_Proposal__c  = 0;
            a.Team_R_M_Booked_Actual__c  = 0;
            a.Team_R_M_Booked_Full_Proposal__c  = 0;
            a.Team_R_M_Booked_Proposal__c  = 0;
            a.Team_Booked_Actual__c = 0;
            a.Team_Booked_Full_Proposal__c = 0;
            a.Team_Booked_Proposal__c = 0;
        }
        
        update scopeMBG;
    }
    
    //method that runs after the execute() method
    global void finish(Database.BatchableContext BC){
        System.debug(LoggingLevel.WARN,'Temp_Delete_DeleteSM1Forecast');
        Best_Guess_Settings__c settings1 = Best_Guess_Settings__c.getOrgDefaults(); 
        settings1.Skip_Trigger__c = false;
        update settings1;
        
        //Build the system time of now + 20 seconds to schedule the batch apex.
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        BatchRecalculateBestGuess acctBatch2Sched = new BatchRecalculateBestGuess(String.valueOf(Date.today().year() - 1));
        //BatchCalculateBestGuessPFM acctBatch2Sched = new BatchCalculateBestGuessPFM();
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
    }

}