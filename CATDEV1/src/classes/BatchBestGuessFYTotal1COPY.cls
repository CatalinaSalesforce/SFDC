/*
@Name            : BatchBestGuessFYTotal1COPY 
@Author          : customersuccess@cloud62.com
@Date            : December 17th, 2012
@Description     : This class will take the appropriate FY Total records and total them up for the BG records
*/
global class BatchBestGuessFYTotal1COPY implements Database.Batchable<sObject>, Schedulable{
    
    String query;
    String limit1;
    
    public BatchBestGuessFYTotal1COPY(String x){
        limit1 = x;
    }
    
    public BatchBestGuessFYTotal1COPY(){
        limit1 = '';
    }
    
    global Database.querylocator start(Database.BatchableContext BC){
        BatchGovernorLimitUtility.insertBatchRun('BatchBestGuessFYTotal1COPY');
        query = 'SELECT ID, Name, OWNERID, QUARTER__C, ACCOUNT__C, My_Total_Actual__c, Total_Actual__c, '
            + '(Select ID, Owner__c, Quarter__c, My_Total_Actual__c, Total_Actual__c From Sales_Manager_2_FY_Totals__r) From Sales_Manager_1_FY_Total__c ' 
            /*+ 'Where Account__c = \'005A000000151E3\' And Quarter__c = \'Q12011\''*///Tony Bailey test
            + ' Order By Name '
            + limit1;
        return Database.getQueryLocator(query);
    }
    
    global void execute(SchedulableContext ctx) {
        BatchBestGuessFYTotal1COPY batch1 = new BatchBestGuessFYTotal1COPY();
        ID batchprocessid = Database.executeBatch(batch1);
    }
    
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        Datetime currentTime = System.now();
        List<Sales_Manager_1_FY_Total__c> sm1 = (List<Sales_Manager_1_FY_Total__c>)scope;
        Set<Id> userList = new Set<Id>();
        Set<Id> accountList = new Set<Id>();
        Map<String, List<Sales_Manager_1_FY_Total__c>> sm1Map = new Map<String, List<Sales_Manager_1_FY_Total__c>>();
        Map<String, List<Sales_Manager_2_FY_Total__c>> sm2Map = new Map<String, List<Sales_Manager_2_FY_Total__c>>();
        Map<Id, Id> accountParentMap = new Map<Id, Id>();
        
        //store the scope records in a map for easy retrieval later
        for (Sales_Manager_1_FY_Total__c a : sm1){
            String key = a.OwnerId + '-' + a.Quarter__c;
            if (!sm1Map.containsKey(key)){
                system.debug('***pf: ' + key);
                sm1Map.put(key, new List<Sales_Manager_1_FY_Total__c>());
            }
            sm1Map.get(key).add(a);
            
            userList.add(a.OwnerId);
            accountList.add(a.Account__c);
            
            for (Sales_Manager_2_FY_Total__c b : a.Sales_Manager_2_FY_Totals__r){
                String key2 = b.Owner__c + '-' + b.Quarter__c;
                if (!sm2Map.containsKey(key2)){
                    system.debug('***pf2: ' + key2);
                    sm2Map.put(key2, new List<Sales_Manager_2_FY_Total__c>());
                }
                sm2Map.get(key2).add(b);
                
                userList.add(b.Owner__c);
            }
            
        }
        
        //store account info for use later on
        List<Account> accs = [SELECT ID, PARENTID FROM ACCOUNT WHERE ID IN :accountList AND PARENTID != null];
        accountList = new Set<Id>();
        for (Account a : accs){
            accountParentMap.put(a.Id, a.ParentId);
            accountList.add(a.ParentId);
        }
        
        //calculate Account BG info by totaling up SM1 FY Total records
        List<Account_Best_Guess__c> accBG = [SELECT ID, ACCOUNT__C, QUARTER__C, PREVIOUS_YEAR_ACTUAL__C FROM ACCOUNT_BEST_GUESS__C WHERE ACCOUNT__C IN :accountList];
        for (Sales_Manager_1_FY_Total__c a : sm1){
            if (accountParentMap.containsKey(a.Account__c)){
                for (Account_Best_Guess__c abg : accBG){
                    if (abg.Account__c == accountParentMap.get(a.Account__c) && getPY(abg.Quarter__c) == a.Quarter__c){
                        abg.Previous_Year_Actual__c += Double.valueOf(a.Total_Actual__c);
                    }
                }
            }
        }
        update accBG;
        
        //total up the FY Total records in this scope for the appropriate SRBG records
        List<Sales_Rep_Best_Guess__c> insertSRBG = new List<Sales_Rep_Best_Guess__c>();
        for (Sales_Rep_Best_Guess__c a : [Select Id, Name, Previous_Year_Actual__c, Quarter__c, Actual_Amount__c, Forecast_Contract__c, Forecast_Proposal__c, Weighted_Forecast_Proposal__c, OwnerId From Sales_Rep_Best_Guess__c Where OwnerId IN :userList]){
            String key = a.OwnerId + '-' + getPY(a.Quarter__c);
            boolean toUpdate = false;
            if (sm1Map.containsKey(key)){
                if (Double.valueOf(a.Previous_Year_Actual__c) == null) a.Previous_Year_Actual__c = 0;
                for (Sales_Manager_1_FY_Total__c sm : sm1Map.get(key)){
                    a.Previous_Year_Actual__c += Double.valueOf(sm.My_Total_Actual__c);
                }
                toUpdate = true; 
            }
            if (sm2Map.containsKey(key)){
                if (Double.valueOf(a.Previous_Year_Actual__c) == null) a.Previous_Year_Actual__c = 0;
                for (Sales_Manager_2_FY_Total__c sm2 : sm2Map.get(key)){
                    a.Previous_Year_Actual__c += Double.valueOf(sm2.My_Total_Actual__c);
                }
                toUpdate = true; 
            }
            if (toUpdate) insertSRBG.add(a);
            
        }
        
        update insertSRBG;
        BatchGovernorLimitUtility.calcualteLimits(Limits.getCpuTime(), Limits.getDMLRows(), Limits.getDMLStatements(), Limits.getHeapSize(), Limits.getQueries(), Limits.getQueryRows(), Limits.getScriptStatements(), scope, currentTime, System.now());
        
    }
    
    global void finish(Database.BatchableContext BC){
        System.debug(LoggingLevel.WARN,'Temp_Delete_DeleteSM1Forecast');
        //Build the system time of now + 20 seconds to schedule the batch apex.
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        BatchBestGuessFYTotal2COPY acctBatch2Sched = new BatchBestGuessFYTotal2COPY();
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
        BatchGovernorLimitUtility.updateBatchRun();
    }
    
    /*
    Method that accepts a string that represents a Quarter and returns the same quarter last year
    param - String that represents a quarter in the form 'QQYYYY' e.g. 'Q12012'
    return - String that represents the next quarter in the form 'QQYYYY' e.g. 'Q22012'
    */
    private String getPY(String x){
        Integer q = Integer.valueOf(x.substring(1,2));
        Integer year = Integer.valueOf(x.substring(2));
        year--;
        return 'Q' + String.valueOf(q) + String.valueOf(year); 
    }

}