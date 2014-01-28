/*
@Name            : BatchCreateAccountBG 
@Author          : customersuccess@cloud62.com
@Date            : December 17th, 2012
@Description     : Batch Proccess to create Accounbt Best Guesses
@Update			: Feb 22, 2013 Added a fix to Correct ownership when Conglomerate
					ownership is changed.  

*/
global class BatchCreateAccountBG implements Database.Batchable<sObject>, Schedulable{
    
    String query;
    String limit1;
    
    public BatchCreateAccountBG(){
        limit1 = '';
    }
    
    //method that gets the query used for this batch
    global Database.querylocator start(Database.BatchableContext BC){
        BatchGovernorLimitUtility.insertBatchRun('BatchCreateAccountBG');
    
        query = 'SELECT ID, ACCOUNT__C,Account__r.ParentID,'
        + 'BOOKED_Q1__C, BOOKED_Q2__C, BOOKED_Q3__C, BOOKED_Q4__C, '
        + 'FULL_PROPOSAL_Q1__C, FULL_PROPOSAL_Q2__C, FULL_PROPOSAL_Q3__C, FULL_PROPOSAL_Q4__C, '
        + 'WGT_PROPOSAL_Q1__C, WGT_PROPOSAL_Q2__C, WGT_PROPOSAL_Q3__C, WGT_PROPOSAL_Q4__C '
        + 'FROM ACCOUNT_BEST_GUESS_SUMMARY__C ' 
        //+ 'WHERE OWNERID = \'005A0000001NCjb\' '
        + limit1; 
        return Database.getQueryLocator(query);
    }
    
    global void execute(SchedulableContext ctx) {
        BatchCreateAccountBG batch1 = new BatchCreateAccountBG();
        ID batchprocessid = Database.executeBatch(batch1);
    }
    
    //method that makes up the body of the batch process    
    global void execute(Database.BatchableContext NC, List<sObject> scope){
       
        
        
        Datetime currentTime = System.now();
        
        List<Account_Best_Guess_Summary__c> scopeList = (List<Account_Best_Guess_Summary__c>)scope;
        //new code\/ @Update			: Feb 22, 2013
        set<id> accountSet = new set<id>();
        for(Account_Best_Guess_Summary__c BGScope : scopeList){
           	accountSet.add(BGScope.account__r.ParentID);          
        }
       	List<Conglomerate_Account_Best_Guess_Summary__c> CongAccts = 
            [	SELECT ID, Name, Account__c, Account__r.OwnerID, OwnerID
           		FROM Conglomerate_Account_Best_Guess_Summary__c
              	WHERE Account__c in :accountSet];
            
        for(Conglomerate_Account_Best_Guess_Summary__c Summary :CongAccts){
			Summary.OwnerId = Summary.Account__r.OwnerID;     
        }
        update CongAccts;
        //new code^@Update			: Feb 22, 2013
        
        for (Account_Best_Guess_Summary__c bg : scopeList){
            bg.Booked_Q1__c = 0;
            bg.Booked_Q2__c = 0;
            bg.Booked_Q3__c = 0;
            bg.Booked_Q4__c = 0;
            bg.Full_Proposal_Q1__c = 0;
            bg.Full_Proposal_Q2__c = 0;
            bg.Full_Proposal_Q3__c = 0;
            bg.Full_Proposal_Q4__c = 0;
            bg.Wgt_Proposal_Q1__c = 0;
            bg.Wgt_Proposal_Q2__c = 0;
            bg.Wgt_Proposal_Q3__c = 0;
            bg.Wgt_Proposal_Q4__c = 0;
        }
        
        update scopeList; 
        
        BatchGovernorLimitUtility.calcualteLimits(Limits.getCpuTime(), Limits.getDMLRows(), Limits.getDMLStatements(), Limits.getHeapSize(), Limits.getQueries(), Limits.getQueryRows(), Limits.getScriptStatements(), scope, currentTime, System.now());
    }
    
    //method that runs after the execute() method
    global void finish(Database.BatchableContext BC){
    	/*TODO: schedule new class that will summarize account BG Booked info*/
        System.debug(LoggingLevel.WARN,'Temp_Delete_DeleteSM1Forecast');
        //Build the system time of now + 20 seconds to schedule the batch apex.
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        //BatchDeleteManagerBestGuess acctBatch2Sched = new BatchDeleteManagerBestGuess();
        BatchSummarizeAccountBG acctBatch2Sched = new BatchSummarizeAccountBG();
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
        BatchGovernorLimitUtility.updateBatchRun();
    }
}