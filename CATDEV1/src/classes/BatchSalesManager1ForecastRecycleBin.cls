/*###################################### 
#Contoller Name: BatchSalesManager1ForecastRecycleBin
#Created Date: 21-11-12 
#Questions: customersuccess@cloud62.com
#LastModified Date: 21-11-12 
#Description: Empty Recycle Bin 
#www.cloud62.com
######################################## 
*/
global class BatchSalesManager1ForecastRecycleBin implements Database.Batchable<sObject>, Schedulable{
    
    //variables
    String query;
    
    //start method
    global Database.querylocator start(Database.BatchableContext BC){
        BatchGovernorLimitUtility.insertBatchRun('BatchActivateOppOwners');
        query = 'Select Id from Sales_Manager_1_Forecast__c where isdeleted=true ALL ROWS';
        return Database.getQueryLocator(query);
    }
    
    //schedulable execute method
    global void execute(SchedulableContext ctx) {
        BatchSalesManager1ForecastRecycleBin batch1 = new BatchSalesManager1ForecastRecycleBin();
        ID batchprocessid = Database.executeBatch(batch1);
    }
    
    //Batchable execute method
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        Datetime currentTime = System.now();
        Database.emptyRecycleBin(scope);
        BatchGovernorLimitUtility.calcualteLimits(Limits.getCpuTime(), Limits.getDMLRows(), Limits.getDMLStatements(), Limits.getHeapSize(), Limits.getQueries(), Limits.getQueryRows(), Limits.getScriptStatements(), scope, currentTime, System.now());    

/*    
        for(List<SDPY_Sales_Manager_1_Forecast__c> sdpyList : [SELECT ID FROM SDPY_Sales_Manager_1_Forecast__c where isdeleted=true Limit 2000 ALL ROWS]){
         if(sdpyList.size()>0){
            Database.emptyRecycleBin(sdpyList);
        }       
        
        }

        
        for(List<Program_Forecast_Exception__c> pfExceptionList : [SELECT ID FROM PROGRAM_FORECAST_EXCEPTION__C where isdeleted=true Limit 2000 ALL ROWS]){
            if(pfExceptionList.size()>0){
                Database.emptyRecycleBin(pfExceptionList);
            }
        }
        
        for(List<Program_Amount__c> paList : [SELECT ID FROM PROGRAM_AMOUNT__C where isdeleted=true Limit 2000 ALL ROWS]){
        if(paList.size()>0){
            Database.emptyRecycleBin(paList);
        }
        }
        
        List<Sales_Manager_2_Forecast__c> smfList = [SELECT ID FROM Sales_Manager_2_Forecast__c where isdeleted=true Limit 2000 ALL ROWS];
        if(smfList.size()>0){
            Database.emptyRecycleBin(smfList);
        }
        
        List<Rep_1_Forecast__c> rf1List = [SELECT ID FROM Rep_1_Forecast__c where isdeleted=true Limit 2000 ALL ROWS];
        if(rf1List.size()>0){
            Database.emptyRecycleBin(rf1List);
        }
        
        List<Rep_2_Forecast__c> rf2List = [SELECT ID FROM Rep_2_Forecast__c where isdeleted=true Limit 2000 ALL ROWS];
        if(rf2List.size()>0){
            Database.emptyRecycleBin(rf2List);
        }
        
        List<Sales_Manager_1_FY_Total__c> sm1List = [SELECT ID FROM Sales_Manager_1_FY_Total__c where isdeleted=true Limit 2000 ALL ROWS];
        if(sm1List.size()>0){
            Database.emptyRecycleBin(sm1List);
        }
*/

    }
    
    //finish method
    global void finish(Database.BatchableContext BC){
         //Build the system time of now + 20 seconds to schedule the batch apex.
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        BatchSDPYSalesManager1RecycleBin binBatch2Sched = new BatchSDPYSalesManager1RecycleBin();
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('BatchSDPYSalesManager1RecycleBin' + sysTime.getTime(),chron_exp,binBatch2Sched);
        BatchGovernorLimitUtility.updateBatchRun();
    }

}