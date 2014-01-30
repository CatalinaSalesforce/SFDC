/*###################################### 
#Contoller Name: BatchGovernorLimitUtility
#Created Date: 20-11-12 
#Questions: customersuccess@cloud62.com
#LastModified Date: 20-11-12 
#Description: Utility to log the Batch Run and Governor Limit History object 
#www.cloud62.com
######################################## 
*/
public with sharing class BatchGovernorLimitUtility{
    
    //variables
    public static Batch_Run__c br;
    public static Integer limitThersold = 0;
    
    //constructor
    public BatchGovernorLimitUtility(){
    
    }
    
    //method to insert Batch Run object
    public static void insertBatchRun(String className){
        br = new Batch_Run__c();
        br.Batch_Class__c = className;
        br.Start_Time__c = System.now();
        
        insert br;
    }
    
    //method to get custom setting
    public static void getlimitThersold(){
         BatchGovernerLimitThreshold__c glt = BatchGovernerLimitThreshold__c.getInstance('Governer Threshold Limit');
         if(glt!=null){
             limitThersold = Integer.ValueOf(glt.ThresholdLimit__c);
         }
    }
    
    //method to update Batch Run with End Time
    public static void updateBatchRun(){
        List<Batch_Run__c> bRun = [select Id from Batch_Run__c order by CreatedDate Desc Limit 1];
        if(bRun.size()>0){
            bRun[0].End_Time__c = System.now();
            
            update bRun[0];
        }
    } 
    
    //method to insert Governer Limit History object
    public static void insertGovernorLimitHistory(List<Governor_Limit_History__c> govLimitHistoryList){
        List<Governor_Limit_History__c> govLimitHistoryInsertList = new List<Governor_Limit_History__c>();
        List<Batch_Run__c> bRun = [select Id from Batch_Run__c order by CreatedDate Desc Limit 1];
        if(bRun.size()>0){
            for(Governor_Limit_History__c glh : govLimitHistoryList){
                glh.Batch_Run__c = bRun[0].Id;
                govLimitHistoryInsertList.add(glh);
            }
        }
        
        insert govLimitHistoryInsertList;
    }
    
    //method to calculate goverenor limits based on threshold limit
    public static void calcualteLimits(Integer cpuTimeLimit, Integer dMLRowsLimit, Integer dMLStatementsLimit, Integer heapSize, Integer queries, Integer queryRows, Integer scriptStatement, List<sObject> scope, Datetime startTime, Datetime endTime){
        getlimitThersold();
        List<Governor_Limit_History__c> govLimitHistoryInsertList = new List<Governor_Limit_History__c>();
        Integer cpuTime = (cpuTimeLimit*100)/Limits.getLimitCpuTime();
        Integer dMLRows = (dMLRowsLimit*100)/Limits.getLimitDMLRows();
        Integer dMLStatements = (dMLStatementsLimit*100)/Limits.getLimitDMLStatements();
        Integer heap = (heapSize*100)/Limits.getLimitHeapSize();
        Integer query = (queries*100)/Limits.getLimitQueries();
        Integer queryRow = (queryRows*100)/Limits.getLimitQueryRows();
        Integer script = (scriptStatement*100)/Limits.getLimitScriptStatements();
        System.debug('cpuTime>>'+cpuTime);
        System.debug('dMLRows>>'+dMLRows);
        System.debug('dMLStatements>>'+dMLStatements);
        System.debug('heap>>'+heap);
        System.debug('query>>'+query);
        System.debug('queryRow>>'+queryRow);
        System.debug('script>>'+script);
        String ids = '';
        for(Sobject s: scope){
            ids = ids+s.Id+',';
        }
        ids = ids.substring(0, ids.length()-1);
        system.debug('idsList>>'+ids);
        if(cpuTime >= limitThersold){
            Governor_Limit_History__c cpuGovLimitHistory = new Governor_Limit_History__c(Limit__c = String.ValueOf(Limits.getLimitCpuTime()), Value__c = String.ValueOf(cpuTimeLimit), Type__c = 'Cpu Time', Threshold__c = limitThersold, Start_Time__c = startTime, End_Time__c = endTime, Processed_IDs__c = ids );
            govLimitHistoryInsertList.add(cpuGovLimitHistory);
        }
        if(dMLRows >= limitThersold){
            Governor_Limit_History__c dmlRowGovLimitHistory = new Governor_Limit_History__c(Limit__c = String.ValueOf(Limits.getLimitDMLRows()), Value__c = String.ValueOf(dMLRowsLimit), Type__c = 'DML Rows', Threshold__c = limitThersold, Start_Time__c = startTime, End_Time__c = endTime, Processed_IDs__c = ids);
            govLimitHistoryInsertList.add(dmlRowGovLimitHistory);
        }
        if(dMLStatements >= limitThersold){
            Governor_Limit_History__c dmlStatGovLimitHistory = new Governor_Limit_History__c(Limit__c = String.ValueOf(Limits.getLimitDMLStatements()), Value__c = String.ValueOf(dMLStatementsLimit), Type__c = 'DML Statements', Threshold__c = limitThersold, Start_Time__c = startTime, End_Time__c = endTime, Processed_IDs__c = ids);
            govLimitHistoryInsertList.add(dmlStatGovLimitHistory);
        }
        if(heap >= limitThersold){
            Governor_Limit_History__c heapGovLimitHistory = new Governor_Limit_History__c(Limit__c = String.ValueOf(Limits.getLimitHeapSize()), Value__c = String.ValueOf(heapSize), Type__c = 'Heap Size', Threshold__c = limitThersold, Start_Time__c = startTime, End_Time__c = endTime, Processed_IDs__c = ids);
            govLimitHistoryInsertList.add(heapGovLimitHistory);
        }
        if(query >= limitThersold){
            Governor_Limit_History__c queriesGovLimitHistory = new Governor_Limit_History__c(Limit__c = String.ValueOf(Limits.getLimitQueries()), Value__c = String.ValueOf(queries), Type__c = 'SOQL Queries', Threshold__c = limitThersold, Start_Time__c = startTime, End_Time__c = endTime, Processed_IDs__c = ids);
            govLimitHistoryInsertList.add(queriesGovLimitHistory);
        }
        if(queryRow >= limitThersold){
            Governor_Limit_History__c queryRowGovLimitHistory = new Governor_Limit_History__c(Limit__c = String.ValueOf(Limits.getLimitQueryRows()), Value__c = String.ValueOf(queryRows), Type__c = 'Query Rows', Threshold__c = limitThersold, Start_Time__c = startTime, End_Time__c = endTime, Processed_IDs__c = ids);
            govLimitHistoryInsertList.add(queryRowGovLimitHistory);
        }
        if(script >= limitThersold){
            Governor_Limit_History__c scriptGovLimitHistory = new Governor_Limit_History__c(Limit__c = String.ValueOf(Limits.getLimitScriptStatements()), Value__c = String.ValueOf(scriptStatement), Type__c = 'Script Statements', Threshold__c = limitThersold, Start_Time__c = startTime, End_Time__c = endTime, Processed_IDs__c = ids);
            govLimitHistoryInsertList.add(scriptGovLimitHistory);
        }
        if(govLimitHistoryInsertList.size()>0){
            insertGovernorLimitHistory(govLimitHistoryInsertList);
        }
    
    }   

}