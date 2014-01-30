/*
@Name            : BatchBestGuessFYTotal2 
@Author          : customersuccess@cloud62.com
@Date            : December 17th, 2012
@Description     : This class will take the appropriate FY Total records and total them up for the BG records
*/
global class BatchBestGuessFYTotal2 implements Database.Batchable<sObject>, Schedulable{
    
    String query;
    String limit1;
    
    public BatchBestGuessFYTotal2(String x){
        limit1 = x;
    }
    
    public BatchBestGuessFYTotal2(){
        limit1 = '';
    }
    
    global Database.querylocator start(Database.BatchableContext BC){
        BatchGovernorLimitUtility.insertBatchRun('BatchBestGuessFYTotal2');
        query = 'SELECT ID, Name, OWNER__c, QUARTER__C, My_Total_Actual__c, Total_Actual__c, '
            +'(Select ID, Owner__c, Quarter__c, Total_Actual__c From Rep_2_FY_Totals__r) From Rep_1_FY_Total__c Order By Name '
            + limit1;
        return Database.getQueryLocator(query);
    }
    
    global void execute(SchedulableContext ctx) {
        BatchBestGuessFYTotal2 batch1 = new BatchBestGuessFYTotal2();
        ID batchprocessid = Database.executeBatch(batch1);
    }
    
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        Datetime currentTime = System.now();
        List<Rep_1_FY_Total__c> sm1 = (List<Rep_1_FY_Total__c>)scope;
        Set<Id> userList = new Set<Id>();
        Map<String, List<Rep_1_FY_Total__c>> sm1Map = new Map<String, List<Rep_1_FY_Total__c>>();
        Map<String, List<Rep_2_FY_Total__c>> sm2Map = new Map<String, List<Rep_2_FY_Total__c>>();
        
        //store the scope records in a map for easy retrieval later
        for (Rep_1_FY_Total__c a : sm1){
            String key = a.Owner__c + '-' + a.Quarter__c;
            if (!sm1Map.containsKey(key)){
                system.debug('***pf: ' + key);
                sm1Map.put(key, new List<Rep_1_FY_Total__c>());
            }
            sm1Map.get(key).add(a);
            
            userList.add(a.Owner__c);
            
            for (Rep_2_FY_Total__c b : a.Rep_2_FY_Totals__r){
                String key2 = b.Owner__c + '-' + b.Quarter__c;
                if (!sm2Map.containsKey(key2)){
                    system.debug('***pf2: ' + key2);
                    sm2Map.put(key2, new List<Rep_2_FY_Total__c>());
                }
                sm2Map.get(key2).add(b);
                
                userList.add(b.Owner__c);
            }
            
        }
        
        //total up the FY Total records in this scope for the appropriate SRBG records
        List<Sales_Rep_Best_Guess__c> insertSRBG = new List<Sales_Rep_Best_Guess__c>();
        for (Sales_Rep_Best_Guess__c a : [Select Id, Name, Previous_Year_Actual__c, Quarter__c, Actual_Amount__c, Forecast_Contract__c, Forecast_Proposal__c, Weighted_Forecast_Proposal__c, OwnerId From Sales_Rep_Best_Guess__c Where OwnerId IN :userList]){
            String key = a.OwnerId + '-' + getPY(a.Quarter__c);
            boolean toUpdate = false;
            if (sm1Map.containsKey(key)){
                if (a.Previous_Year_Actual__c == null) a.Previous_Year_Actual__c = 0;
                for (Rep_1_FY_Total__c sm : sm1Map.get(key)){
                    a.Previous_Year_Actual__c += sm.My_Total_Actual__c;
                } 
                toUpdate = true;
            }
            if (sm2Map.containsKey(key)){
                if (a.Previous_Year_Actual__c == null) a.Previous_Year_Actual__c = 0;
                for (Rep_2_FY_Total__c sm2 : sm2Map.get(key)){
                    a.Previous_Year_Actual__c += sm2.Total_Actual__c;
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
        BatchHuffmasterAssociateMBG acctBatch2Sched = new BatchHuffmasterAssociateMBG();
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