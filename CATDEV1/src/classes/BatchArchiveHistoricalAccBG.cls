/*
@Name            : BatchArchiveHistoricalAccBG
@Author          : customersuccess@cloud62.com
@Date            : December 17th, 2012
@Description     : Batch Proccess to archive Historical Account Best Guess
*/
global class BatchArchiveHistoricalAccBG implements Database.Batchable<sObject>, Schedulable{
    
    String query;
    String limit1;
    HBGBatchInterval__c hbgSetting = HBGBatchInterval__c.getInstance('LastDate');
    Map<Id, Map<String, Map<String, Historic_Conglomerate_Best_Guess_Summary__c>>> parentMap;
    Map<Id, Id> accParentMap;
            
    public BatchArchiveHistoricalAccBG(String x){
        limit1 = x;
    }
    
    public BatchArchiveHistoricalAccBG(){
        limit1 = '';
    }
    
    global Database.querylocator start(Database.BatchableContext BC){
        BatchGovernorLimitUtility.insertBatchRun('BatchArchiveHistoricalAccBG');
                
        Integer intervalDays = Integer.valueOf(hbgSetting.Account_BG_Interval__c);
        
        AggregateResult ar = [Select Max(Archive_Date__c) Expr1 From Historical_Account_Best_Guess_Summary__c
            Where Archive_Date__c <= :Date.today() and Archive_Date__c >= :Date.today().addDays(-50)];
            
        Date nearestBefore = (Date)ar.get('Expr1');
        
        if (nearestBefore != null){
            if (nearestBefore.daysBetween(Date.today()) > intervalDays){
            
                query = 'SELECT ID, Account__c, Comments__c, Year__c, Conglomerate_Account_Best_Guess_Summary__c, '
                + ' Booked_Full_Q1__c, Booked_Full_Q2__c, Booked_Full_Q3__c, Booked_Full_Q4__c, '
                + ' Booked_Wgt_Q1__c, Booked_Wgt_Q2__c, Booked_Wgt_Q3__c, Booked_Wgt_Q4__c, '
                + ' Booked_Q1__c, Booked_Q2__c, Booked_Q3__c, Booked_Q4__c, '
                + ' Full_Proposal_Q1__c, Full_Proposal_Q2__c, Full_Proposal_Q3__c, Full_Proposal_Q4__c, '
                + ' Wgt_Proposal_Q1__c, Wgt_Proposal_Q2__c, Wgt_Proposal_Q3__c, Wgt_Proposal_Q4__c, '
                + ' Q1__c, Q2__c, Q3__c, Q4__c, OwnerId, Delivery_Channel__c '
                + ' FROM ACCOUNT_BEST_GUESS_SUMMARY__C'
                + limit1;
            }
        } else {
            query = 'SELECT ID, Account__c, Comments__c, Year__c, Conglomerate_Account_Best_Guess_Summary__c, '
                + ' Booked_Full_Q1__c, Booked_Full_Q2__c, Booked_Full_Q3__c, Booked_Full_Q4__c, '
                + ' Booked_Wgt_Q1__c, Booked_Wgt_Q2__c, Booked_Wgt_Q3__c, Booked_Wgt_Q4__c, '
                + ' Booked_Q1__c, Booked_Q2__c, Booked_Q3__c, Booked_Q4__c, '
                + ' Full_Proposal_Q1__c, Full_Proposal_Q2__c, Full_Proposal_Q3__c, Full_Proposal_Q4__c, '
                + ' Wgt_Proposal_Q1__c, Wgt_Proposal_Q2__c, Wgt_Proposal_Q3__c, Wgt_Proposal_Q4__c, '
                + ' Q1__c, Q2__c, Q3__c, Q4__c, OwnerId, Delivery_Channel__c '
                + ' FROM ACCOUNT_BEST_GUESS_SUMMARY__C'
                + limit1;
        }
        if (query == null || query == ''){
            query = 'SELECT ID FROM USER WHERE ID = NULL AND ID != NULL ';
        }
        return Database.getQueryLocator(query);
               
        
    }
    
    global void execute(SchedulableContext ctx) {
        BatchArchiveHistoricalAccBG batch1 = new BatchArchiveHistoricalAccBG();
        ID batchprocessid = Database.executeBatch(batch1);
    } 
    
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        Datetime currentTime = System.now();
        List<Account_Best_Guess_Summary__c> bgScope = (List<Account_Best_Guess_Summary__c>)scope;
        List<Historical_Account_Best_Guess_Summary__c> insertHABGS = new List<Historical_Account_Best_Guess_Summary__c>();
        
        List<Historic_Conglomerate_Best_Guess_Summary__c> parentList = [SELECT ID, Account__c, Year__c, OwnerId, Delivery_Channel__c
                FROM Historic_Conglomerate_Best_Guess_Summary__c
                WHERE ARCHIVE_DATE__C =: Date.today()];
        parentMap = new Map<Id, Map<String, Map<String, Historic_Conglomerate_Best_Guess_Summary__c>>>();       
        for (Historic_Conglomerate_Best_Guess_Summary__c parent: parentList){
            if (!parentMap.containsKey(parent.Account__c)){
                parentMap.put(parent.Account__c, new Map<String, Map<String, Historic_Conglomerate_Best_Guess_Summary__c>>());
            }
            if (!parentMap.get(parent.Account__c).containsKey(parent.Year__c)){
                parentMap.get(parent.Account__c).put(parent.Year__c, new Map<String, Historic_Conglomerate_Best_Guess_Summary__c>());
            }
            if (!parentMap.get(parent.Account__c).get(parent.Year__c).containsKey(parent.Delivery_Channel__c)){
                parentMap.get(parent.Account__c).get(parent.Year__c).put(parent.Delivery_Channel__c, parent);
            }
        }
        
        accParentMap = new Map<Id, Id>();
        for (Account a : [SELECT ID, PARENTID FROM ACCOUNT]){
            if (a.ParentID != null) accParentMap.put(a.Id, a.ParentID);
        }
         
        for (Account_Best_Guess_Summary__c abg : bgScope){
            Historical_Account_Best_Guess_Summary__c newHABGS = new Historical_Account_Best_Guess_Summary__c();
            newHABGS.OwnerId = abg.OwnerId;
            newHABGS.Year__c = abg.Year__c;
            newHABGS.Account__c = abg.Account__c;
            newHABGS.Comments__c = abg.Comments__c;
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
            newHABGS.Historic_Conglomerate_Best_Guess_Summary__c = getCong(newHABGS);
            insertHABGS.add(newHABGS);
        } 
        Database.Insert(insertHABGS);
        BatchGovernorLimitUtility.calcualteLimits(Limits.getCpuTime(), Limits.getDMLRows(), Limits.getDMLStatements(), Limits.getHeapSize(), Limits.getQueries(), Limits.getQueryRows(), Limits.getScriptStatements(), scope, currentTime, System.now());    
    }
    
    global void finish(Database.BatchableContext BC){
        BatchGovernorLimitUtility.updateBatchRun();
    }
    
    private String getCong(Historical_Account_Best_Guess_Summary__c child){
        String returnRecord = null;
        String accId = accParentMap.get(child.Account__c);
        if (accId!= null){
            if (parentMap.containsKey(accId)){
                if (parentMap.get(accId).containsKey(child.Year__c)){
                    if (parentMap.get(accId).get(child.Year__c).containsKey(child.Delivery_Channel__c)){
                        returnRecord = parentMap.get(accId).get(child.Year__c).get(child.Delivery_Channel__c).Id;
                    }
                }
            }
        }
        return returnRecord;
    }

}