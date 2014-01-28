/*
@Name           : BestGuessController
@Author         : customersuccess@cloud62.com
@Date           : 11/26/2012
@Description    : Take snapshot of BG
*/
global class BatchInsertHistoricalSRBestGuess implements Database.Batchable<sObject>, Schedulable{
    
    String query;
    String limit1;
    List<Historical_Sales_Rep_Best_Guess__c> insertsbg;
    HBGBatchInterval__c hbgSetting = HBGBatchInterval__c.getInstance('LastDate');
    
    public BatchInsertHistoricalSRBestGuess(String x){
        limit1 = x;
    }
    
    public BatchInsertHistoricalSRBestGuess(){
        limit1 = '';
    }
    
    //method that gets the query used for this batch
    global Database.querylocator start(Database.BatchableContext BC){
        

        SObjectType sot = Schema.getGlobalDescribe().get('Sales_Rep_Best_Guess__c');
        if (sot == null) return null;
    
        List<Schema.SObjectField> lstRepFields = sot.getDescribe().fields.getMap().values();
        String strRepFields = '';
        for(Integer i = 0; i < lstRepFields.size(); i++){
            if(i == lstRepFields.size() - 1){
                strRepFields += lstRepFields.get(i).getDescribe().LocalName;
            } else {
                strRepFields += lstRepFields.get(i).getDescribe().LocalName + ',';
            }
        } 
        query = 'Select ' + strRepFields + ' FROM Sales_Rep_Best_Guess__c '
            + ' WHERE OWNERID IN (SELECT ID FROM USER WHERE ISACTIVE = TRUE) ';
        system.debug(LoggingLevel.ERROR, '***hbgSetting' + hbgSetting);
        system.debug(LoggingLevel.ERROR, '***hbgSetting' + hbgSetting.SR_Last_Run_Date__c);
        //the batch will run only if 14 or more days has passsed since the last run
        if(hbgSetting.SR_Last_Run_Date__c.daysBetween(Date.today()) < 10){ 
            system.debug('*&*Batch not running : ' + hbgSetting.SR_Last_Run_Date__c.daysBetween(date.today()));
            query = 'SELECT ID FROM USER WHERE ID = NULL AND ID != NULL';
        }
        else {
            system.debug('*&*Batch running : ' + hbgSetting.SR_Last_Run_Date__c.daysBetween(date.today()));
            hbgSetting.SR_Last_Run_Date__c = Date.today();
            update hbgSetting;
        }   
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(SchedulableContext ctx) {
        BatchInsertHistoricalSRBestGuess batch1 = new BatchInsertHistoricalSRBestGuess();
        ID batchprocessid = Database.executeBatch(batch1);
    }
    
    //method that makes up the body of the batch process    
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        List<User> users = [SELECT ID, NAME, MANAGERID FROM USER];
        /*Map<Id, Id> userManagerMap = new Map<Id, Id>();
        for (User a : users){
            if (a.ManagerId != null){
                userManagerMap.put(a.Id, a.ManagerId);
            }
        }
        //Map<String, Sales_Rep_Best_Guess> mbgMap = new Map<String, Sales_Rep_Best_Guess>();
        */
        //Query to fetch Manager Best Guess records
        List<Sales_Rep_Best_Guess__c> sbg = scope;
        
        insertsbg = new List<Historical_Sales_Rep_Best_Guess__c>();
        
        for (Sales_Rep_Best_Guess__c a : sbg){
            //mbgMap.put(a.OwnerId + '-' + a.Quarter__c, a);
            Historical_Sales_Rep_Best_Guess__c hsbg = new Historical_Sales_Rep_Best_Guess__c();
            hsbg.Archive_Date__c = (Date)system.today();
            hsbg.Name = a.Name;
            hsbg.Actual_Amount__c = a.Actual_Amount__c;
            hsbg.OwnerId = a.OwnerId;
            hsbg.Booked_Actual__c = a.Booked_Actual__c;
            hsbg.Booked_Full_Proposal__c = a.Booked_Full_Proposal__c;
            hsbg.Booked_Proposal__c = a.Booked_Proposal__c;
            hsbg.Comments__c = a.Comments__c;
            hsbg.Forecast_Contract__c = a.Forecast_Contract__c;
            hsbg.Forecast_Proposal__c = a.Forecast_Proposal__c;
            hsbg.Is_Manager__c = a.Is_Manager__c;
            hsbg.IsMyTeam__c = a.IsMyTeam__c;
            hsbg.Last_Entered_Date__c = a.Last_Entered_Date__c;
            hsbg.Last_Entered_User__c = a.Last_Entered_User__c;
            hsbg.M_A_Actual_Amount__c = a.M_A_Actual_Amount__c;
            hsbg.M_A_Forecast_Contract__c = a.M_A_Forecast_Contract__c;
            hsbg.M_A_Forecast_Proposal__c = a.M_A_Forecast_Proposal__c;
            hsbg.Manager__c = a.Manager__c;
            hsbg.Manager_1__c = a.Manager_1__c;
            hsbg.Manager_2__c = a.Manager_2__c;
            hsbg.Manager_3__c = a.Manager_3__c;
            /*hsbg.Manager_4__c = a.Manager_4__c;
            hsbg.Manager_5__c = a.Manager_5__c;
            hsbg.Manager_6__c = a.Manager_6__c;
            hsbg.Manager_7__c = a.Manager_7__c;
            hsbg.Manager_8__c = a.Manager_8__c;*/
            hsbg.Manager_Best_Guess__c = a.Manager_Best_Guess__c;
            hsbg.M_A_Weighted_Forecast_Proposal__c = a.M_A_Weighted_Forecast_Proposal__c;
            hsbg.M_B_Actual_Amount__c = a.M_B_Actual_Amount__c;
            hsbg.M_B_Forecast_Contract__c = a.M_B_Forecast_Contract__c;
            hsbg.M_B_Forecast_Proposal__c = a.M_B_Forecast_Proposal__c;
            hsbg.M_B_Weighted_Forecast_Proposal__c = a.M_B_Weighted_Forecast_Proposal__c;
            hsbg.M_D_Actual_Amount__c = a.M_D_Actual_Amount__c;
            hsbg.M_D_Forecast_Contract__c = a.M_D_Forecast_Contract__c;
            hsbg.M_D_Forecast_Proposal__c = a.M_D_Forecast_Proposal__c;
            hsbg.M_D_Weighted_Forecast_Proposal__c = a.M_D_Weighted_Forecast_Proposal__c;
            hsbg.Manufacturing_Audience_Best_Guess__c = a.Manufacturing_Audience_Best_Guess__c;
            hsbg.M_A_Booked_Full_Proposal__c = a.M_A_Booked_Full_Proposal__c;
            hsbg.M_A_Booked_Proposal__c = a.M_A_Booked_Proposal__c;
            hsbg.M_A_Booked_Actual__c = a.M_A_Booked_Actual__c;
            hsbg.Manufacturing_Audience_High__c = a.Manufacturing_Audience_High__c;
            hsbg.Manufacturing_Audience_Low__c = a.Manufacturing_Audience_Low__c;
            hsbg.Manufacturing_Base_Best_Guess__c = a.Manufacturing_Base_Best_Guess__c;
            hsbg.M_B_Booked_Full_Proposal__c = a.M_B_Booked_Full_Proposal__c;
            hsbg.M_B_Booked_Proposal__c = a.M_B_Booked_Proposal__c;
            hsbg.M_B_Booked_Actual__c = a.M_B_Booked_Actual__c;
            hsbg.Manufacturing_Base_High__c = a.Manufacturing_Base_High__c;
            hsbg.Manufacturing_Base_Low__c = a.Manufacturing_Base_Low__c;
            hsbg.Manufacturing_Digital_Best_Guess__c = a.Manufacturing_Digital_Best_Guess__c;
            hsbg.M_D_Booked_Full_Proposal__c = a.M_D_Booked_Full_Proposal__c;
            hsbg.M_D_Booked_Proposal__c = a.M_D_Booked_Proposal__c;
            hsbg.M_D_Booked_Actual__c = a.M_D_Booked_Actual__c;
            hsbg.Manufacturing_Digital_High__c = a.Manufacturing_Digital_High__c;
            hsbg.Manufacturing_Digital_Low__c = a.Manufacturing_Digital_Low__c;
            hsbg.Manufacturing_Mobile_Best_Guess__c = a.Manufacturing_Mobile_Best_Guess__c;
            hsbg.M_M_Booked_Full_Proposal__c = a.M_M_Booked_Full_Proposal__c;
            hsbg.M_M_Booked_Proposal__c = a.M_M_Booked_Proposal__c;
            hsbg.M_M_Booked_Actual__c = a.M_M_Booked_Actual__c;
            hsbg.Manufacturing_Mobile_High__c = a.Manufacturing_Mobile_High__c;
            hsbg.Manufacturing_Mobile_Low__c = a.Manufacturing_Mobile_Low__c;
            hsbg.M_M_Actual_Amount__c = a.M_M_Actual_Amount__c;
            hsbg.M_M_Forecast_Contract__c = a.M_M_Forecast_Contract__c;
            hsbg.M_M_Forecast_Proposal__c = a.M_M_Forecast_Proposal__c;
            hsbg.M_M_Weighted_Forecast_Proposal__c = a.M_M_Weighted_Forecast_Proposal__c;
            hsbg.Previous_Year_Actual__c = a.Previous_Year_Actual__c;
            hsbg.Quarter__c = a.Quarter__c;
            hsbg.Quarter_End_Date__c = a.Quarter_End_Date__c;
            hsbg.Quarter_Start_Date__c = a.Quarter_Start_Date__c;
            hsbg.Quota__c = a.Quota__c;
            hsbg.R_A_Actual_Amount__c = a.R_A_Actual_Amount__c;
            hsbg.R_A_Forecast_Contract__c = a.R_A_Forecast_Contract__c;
            hsbg.R_A_Forecast_Proposal__c = a.R_A_Forecast_Proposal__c;
            hsbg.R_A_Weighted_Forecast_Proposal__c = a.R_A_Weighted_Forecast_Proposal__c;
            hsbg.R_B_Actual_Amount__c = a.R_B_Actual_Amount__c;
            hsbg.R_B_Forecast_Contract__c = a.R_B_Forecast_Contract__c;
            hsbg.R_B_Forecast_Proposal__c = a.R_B_Forecast_Proposal__c;
            hsbg.R_B_Weighted_Forecast_Proposal__c = a.R_B_Weighted_Forecast_Proposal__c;
            hsbg.R_D_Actual_Amount__c = a.R_D_Actual_Amount__c;
            hsbg.R_D_Forecast_Contract__c = a.R_D_Forecast_Contract__c;
            hsbg.R_D_Forecast_Proposal__c = a.R_D_Forecast_Proposal__c;
            hsbg.R_D_Weighted_Forecast_Proposal__c = a.R_D_Weighted_Forecast_Proposal__c;
            hsbg.Retail_Audience_Best_Guess__c = a.Retail_Audience_Best_Guess__c;
            hsbg.R_A_Booked_Proposal__c = a.R_A_Booked_Proposal__c;
            hsbg.R_A_Booked_Actual__c = a.R_A_Booked_Actual__c;
            hsbg.Retail_Audience_High__c = a.Retail_Audience_High__c;
            hsbg.Retail_Audience_Low__c = a.Retail_Audience_Low__c;
            hsbg.Retail_Base_Best_Guess__c = a.Retail_Base_Best_Guess__c;
            hsbg.R_B_Booked_Full_Proposal__c = a.R_B_Booked_Full_Proposal__c;
            hsbg.R_B_Booked_Proposal__c = a.R_B_Booked_Proposal__c;
            hsbg.R_B_Booked_Actual__c = a.R_B_Booked_Actual__c;
            hsbg.Retail_Base_High__c = a.Retail_Base_High__c;
            hsbg.Retail_Base_Low__c = a.Retail_Base_Low__c;
            hsbg.Retail_Digital_Best_Guess__c = a.Retail_Digital_Best_Guess__c;
            hsbg.R_D_Booked_Proposal__c = a.R_D_Booked_Proposal__c;
            hsbg.R_D_Booked_Actual__c = a.R_D_Booked_Actual__c;
            hsbg.Retail_Digital_High__c = a.Retail_Digital_High__c;
            hsbg.Retail_Digital_Low__c = a.Retail_Digital_Low__c;
            hsbg.Retail_Mobile_Best_Guess__c = a.Retail_Mobile_Best_Guess__c;
            hsbg.R_M_Booked_Full_Proposal__c = a.R_M_Booked_Full_Proposal__c;
            hsbg.R_M_Booked_Proposal__c = a.R_M_Booked_Proposal__c;
            hsbg.R_M_Booked_Actual__c = a.R_M_Booked_Actual__c;
            hsbg.Retail_Mobile_High__c = a.Retail_Mobile_High__c;
            hsbg.Retail_Mobile_Low__c = a.Retail_Mobile_Low__c;
            hsbg.R_M_Actual_Amount__c = a.R_M_Actual_Amount__c;
            hsbg.R_M_Forecast_Contract__c = a.R_M_Forecast_Contract__c;
            hsbg.R_M_Forecast_Proposal__c = a.R_M_Forecast_Proposal__c;
            hsbg.R_M_Weighted_Forecast_Proposal__c = a.R_M_Weighted_Forecast_Proposal__c;
            hsbg.R_A_Booked_Full_Proposal__c = a.R_A_Booked_Full_Proposal__c;
            hsbg.R_D_Booked_Full_Proposal__c = a.R_D_Booked_Full_Proposal__c;
            hsbg.Total_BG__c = a.Total_BG__c;
            hsbg.Total_H__c = a.Total_H__c;
            hsbg.Total_L__c = a.Total_L__c;
            hsbg.Weighted_Forecast_Proposal__c = a.Weighted_Forecast_Proposal__c;
            hsbg.Year__c = a.Year__c;
            
            /*added for testing
            hsbg.Total_BG__c /= 3;
            if(hsbg.Manufacturing_Base_Best_Guess__c == null) hsbg.Manufacturing_Base_Best_Guess__c =0;
            hsbg.Manufacturing_Base_Best_Guess__c /=3;
            if(hsbg.Retail_Base_Best_Guess__c == null) hsbg.Retail_Base_Best_Guess__c =0;
            hsbg.Retail_Base_Best_Guess__c /=3;
            if(hsbg.Manufacturing_Digital_Best_Guess__c == null) hsbg.Manufacturing_Digital_Best_Guess__c =0; 
            hsbg.Manufacturing_Digital_Best_Guess__c /=3;
            if(hsbg.Retail_Digital_Best_Guess__c == null) hsbg.Retail_Digital_Best_Guess__c =0;
            hsbg.Retail_Digital_Best_Guess__c /=3;
            if(hsbg.Manufacturing_Audience_Best_Guess__c == null) hsbg.Manufacturing_Audience_Best_Guess__c =0; 
            hsbg.Manufacturing_Audience_Best_Guess__c /=3;
             if(hsbg.Retail_Audience_Best_Guess__c == null) hsbg.Retail_Audience_Best_Guess__c =0;
            hsbg.Retail_Audience_Best_Guess__c /=3;
            if(hsbg.Manufacturing_Mobile_Best_Guess__c == null) hsbg.Manufacturing_Mobile_Best_Guess__c =0; 
            hsbg.Manufacturing_Mobile_Best_Guess__c /=3;
            if(hsbg.Retail_Mobile_Best_Guess__c == null) hsbg.Retail_Mobile_Best_Guess__c =0; 
            hsbg.Retail_Mobile_Best_Guess__c /=3;
            
            hsbg.Booked_Actual__c =hsbg.Booked_Actual__c /= 4;
            hsbg.M_B_Booked_Actual__c /= 4;
            hsbg.R_B_Booked_Actual__c /= 4;
            hsbg.M_D_Booked_Actual__c /= 4;
            hsbg.R_D_Booked_Actual__c /= 4;
            hsbg.M_A_Booked_Actual__c /= 4;
            hsbg.R_A_Booked_Actual__c /= 4;
            hsbg.M_M_Booked_Actual__c /= 4;
            hsbg.R_M_Booked_Actual__c /= 4;
            */
            insertsbg.add(hsbg);
        }
        insert insertsbg;
    }
    
    //method that runs after the execute() method
    global void finish(Database.BatchableContext BC){
        
    }

}