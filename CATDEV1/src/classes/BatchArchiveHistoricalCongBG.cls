/*
@Name            : BatchArchiveHistoricalCongBG
@Author          : customersuccess@cloud62.com
@Date            : December 17th, 2012
@Description     : Batch Proccess to Archive Historical Conglomerate Best Guesses
*/
global class BatchArchiveHistoricalCongBG implements Database.Batchable<sObject>, Schedulable{
    
    String query;
    String limit1;
    HBGBatchInterval__c hbgSetting = HBGBatchInterval__c.getInstance('LastDate');
            
    public BatchArchiveHistoricalCongBG(String x){
        limit1 = x;
    }
    
    public BatchArchiveHistoricalCongBG(){
        limit1 = '';
    }
    
    global Database.querylocator start(Database.BatchableContext BC){
        BatchGovernorLimitUtility.insertBatchRun('BatchArchiveHistoricalCongBG');
                
        Integer intervalDays = Integer.valueOf(hbgSetting.Account_BG_Interval__c);
        
        AggregateResult ar = [Select Max(Archive_Date__c) Expr1 From Historic_Conglomerate_Best_Guess_Summary__c
            Where Archive_Date__c <= :Date.today() and Archive_Date__c >= :Date.today().addDays(-50)];
            
        Date nearestBefore = (Date)ar.get('Expr1');
        
        if (nearestBefore != null){
            if (nearestBefore.daysBetween(Date.today()) > intervalDays){
            
                query = 'SELECT ID, Account__c, Year__c, '
                + ' Booked_Full_Q1__c, Booked_Full_Q2__c, Booked_Full_Q3__c, Booked_Full_Q4__c, '
                + ' Booked_Wgt_Q1__c, Booked_Wgt_Q2__c, Booked_Wgt_Q3__c, Booked_Wgt_Q4__c, '
                + ' Booked_Q1__c, Booked_Q2__c, Booked_Q3__c, Booked_Q4__c, '
                + ' Full_Proposal_Q1__c, Full_Proposal_Q2__c, Full_Proposal_Q3__c, Full_Proposal_Q4__c, '
                + ' Wgt_Proposal_Q1__c, Wgt_Proposal_Q2__c, Wgt_Proposal_Q3__c, Wgt_Proposal_Q4__c, '
                + ' Q1__c, Q2__c, Q3__c, Q4__c, OwnerId, Delivery_Channel__c '
                + ' FROM CONGLOMERATE_ACCOUNT_BEST_GUESS_SUMMARY__C'
                + limit1;
            }
        } else {
            query = 'SELECT ID, Account__c, Year__c, '
                + ' Booked_Full_Q1__c, Booked_Full_Q2__c, Booked_Full_Q3__c, Booked_Full_Q4__c, '
                + ' Booked_Wgt_Q1__c, Booked_Wgt_Q2__c, Booked_Wgt_Q3__c, Booked_Wgt_Q4__c, '
                + ' Booked_Q1__c, Booked_Q2__c, Booked_Q3__c, Booked_Q4__c, '
                + ' Full_Proposal_Q1__c, Full_Proposal_Q2__c, Full_Proposal_Q3__c, Full_Proposal_Q4__c, '
                + ' Wgt_Proposal_Q1__c, Wgt_Proposal_Q2__c, Wgt_Proposal_Q3__c, Wgt_Proposal_Q4__c, '
                + ' Q1__c, Q2__c, Q3__c, Q4__c, OwnerId, Delivery_Channel__c '
                + ' FROM CONGLOMERATE_ACCOUNT_BEST_GUESS_SUMMARY__C'
                + limit1;
        }
        if (query == null || query == ''){
            query = 'SELECT ID FROM USER WHERE ID = NULL AND ID != NULL ';
        }
        return Database.getQueryLocator(query);
               
        
    }
    
    global void execute(SchedulableContext ctx) {
        BatchArchiveHistoricalCongBG batch1 = new BatchArchiveHistoricalCongBG();
        ID batchprocessid = Database.executeBatch(batch1);
    } 
    
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        Datetime currentTime = System.now();
        List<CONGLOMERATE_ACCOUNT_BEST_GUESS_SUMMARY__C> bgScope = (List<CONGLOMERATE_ACCOUNT_BEST_GUESS_SUMMARY__C>)scope;
        List<Historic_Conglomerate_Best_Guess_Summary__c> insertHABGS = new List<Historic_Conglomerate_Best_Guess_Summary__c>(); 
        for (CONGLOMERATE_ACCOUNT_BEST_GUESS_SUMMARY__C abg : bgScope){
            Historic_Conglomerate_Best_Guess_Summary__c newHABGS = new Historic_Conglomerate_Best_Guess_Summary__c();
            newHABGS.OwnerId = abg.OwnerId;
            newHABGS.Year__c = abg.Year__c;
            newHABGS.Account__c = abg.Account__c;
            newHABGS.Delivery_Channel__c = abg.Delivery_Channel__c;
            newHABGS.Booked_Full_Q1__c = abg.Booked_Full_Q1__c;
            newHABGS.Booked_Full_Q2__c = abg.Booked_Full_Q2__c;
            newHABGS.Booked_Full_Q3__c = abg.Booked_Full_Q3__c;
            newHABGS.Booked_Full_Q4__c = abg.Booked_Full_Q4__c;
            newHABGS.Booked_Wgt_Q1__c = abg.Booked_Wgt_Q1__c;
            newHABGS.Booked_Wgt_Q2__c = abg.Booked_Wgt_Q2__c;
            newHABGS.Booked_Wgt_Q3__c = abg.Booked_Wgt_Q3__c;
            newHABGS.Booked_Wgt_Q4__c = abg.Booked_Wgt_Q4__c;
            newHABGS.Booked_Q1__c = abg.Booked_Q1__c;
            newHABGS.Booked_Q2__c = abg.Booked_Q2__c;
            newHABGS.Booked_Q3__c = abg.Booked_Q3__c;
            newHABGS.Booked_Q4__c = abg.Booked_Q4__c;
            newHABGS.Q1__c = abg.Q1__c;
            newHABGS.Q2__c = abg.Q2__c;
            newHABGS.Q3__c = abg.Q3__c;
            newHABGS.Q4__c = abg.Q4__c;
            newHABGS.Full_Proposal_Q1__c = abg.Full_Proposal_Q1__c;
            newHABGS.Full_Proposal_Q2__c = abg.Full_Proposal_Q2__c;
            newHABGS.Full_Proposal_Q3__c = abg.Full_Proposal_Q3__c;
            newHABGS.Full_Proposal_Q4__c = abg.Full_Proposal_Q4__c;
            newHABGS.Wgt_Proposal_Q1__c = abg.Wgt_Proposal_Q1__c;
            newHABGS.Wgt_Proposal_Q2__c = abg.Wgt_Proposal_Q2__c;
            newHABGS.Wgt_Proposal_Q3__c = abg.Wgt_Proposal_Q3__c;
            newHABGS.Wgt_Proposal_Q4__c = abg.Wgt_Proposal_Q4__c;
            newHABGS.Archive_Date__c = Date.today();
            insertHABGS.add(newHABGS);
        } 
        Database.Insert(insertHABGS);
        BatchGovernorLimitUtility.calcualteLimits(Limits.getCpuTime(), Limits.getDMLRows(), Limits.getDMLStatements(), Limits.getHeapSize(), Limits.getQueries(), Limits.getQueryRows(), Limits.getScriptStatements(), scope, currentTime, System.now());    
    }
    
    global void finish(Database.BatchableContext BC){
        System.debug(LoggingLevel.WARN,'Temp_Delete_DeleteSM1Forecast');
        //Build the system time of now + 20 seconds to schedule the batch apex.
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        BatchArchiveHistoricalAccBG acctBatch2Sched = new BatchArchiveHistoricalAccBG();
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
        BatchGovernorLimitUtility.updateBatchRun();
    }

}