/*
@Name           : BestGuessController
@Author         : customersuccess@cloud62.com
@Date           : 11/26/2012
@Description    : Take snapshot of BG
Nov 26 - Modify scope to only include active users
*/
global class BatchInsertHistoricalBestGuess implements Database.Batchable<sObject>, Schedulable{
    
    String query;
    String limit1;
    List<Historical_Manager_Best_Guess__c> inserthmbg;
    HBGBatchInterval__c hbgSetting = HBGBatchInterval__c.getInstance('LastDate');
    
    public BatchInsertHistoricalBestGuess(String x){
        limit1 = x;
    }
    
    public BatchInsertHistoricalBestGuess(){
        limit1 = '';
    }
    
    //method that gets the query used for this batch
    global Database.querylocator start(Database.BatchableContext BC){
        

        SObjectType sot = Schema.getGlobalDescribe().get('Manager_Best_Guess__c');
        if (sot == null) return null;
    
        List<Schema.SObjectField> lstManFields = sot.getDescribe().fields.getMap().values();
        String strManFields = '';
        for(Integer i = 0; i < lstManFields.size(); i++){
            if(i == lstManFields.size() - 1){
                strManFields += lstManFields.get(i).getDescribe().LocalName;
            } else {
                strManFields += lstManFields.get(i).getDescribe().LocalName + ',';
            }
        } 
        
        query = 'Select ' + strManFields + ' FROM Manager_Best_Guess__c '
        //added by Warren to only archive users who are active
        + ' WHERE OWNERID IN (SELECT ID FROM USER WHERE ISACTIVE = TRUE)';
        
        
        //the batch will run only if 14 or more days has passsed since the last run
        if(hbgSetting.Last_Run_Date__c.daysBetween(date.today()) < 10){
            system.debug('*&*Batch not running : ' + hbgSetting.Last_Run_Date__c.daysBetween(date.today()));
            query = 'SELECT ID FROM USER WHERE ID = NULL AND ID != NULL';
        }
        else {
            system.debug('*&*Batch running : ' + hbgSetting.Last_Run_Date__c.daysBetween(date.today()));
            hbgSetting.Last_Run_Date__c = date.today();
            update hbgSetting;
        }
        return Database.getQueryLocator(query);
    }
    
    global void execute(SchedulableContext ctx) {
        BatchInsertHistoricalBestGuess batch1 = new BatchInsertHistoricalBestGuess();
        ID batchprocessid = Database.executeBatch(batch1);
    }
    
    //method that makes up the body of the batch process    
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        List<User> users = [SELECT ID, NAME, MANAGERID FROM USER where isActive = true];
        /*
        Map<Id, Id> userManagerMap = new Map<Id, Id>();
        for (User a : users){
            if (a.ManagerId != null){
                userManagerMap.put(a.Id, a.ManagerId);
            }
        }
        //Map<String, Manager_Best_Guess__c> mbgMap = new Map<String, Manager_Best_Guess__c>();
        //mbgMap.put(a.OwnerId + '-' + a.Quarter__c, a);
        */
        
        //Query to fetch Manager Best Guess records
        List<Manager_Best_Guess__c> mbg = scope;
        
        inserthmbg = new List<Historical_Manager_Best_Guess__c>();
        
        for (Manager_Best_Guess__c a : mbg){
            Historical_Manager_Best_Guess__c hmbg = new Historical_Manager_Best_Guess__c();
            hmbg.Archive_Date__c = (Date)system.today();
            hmbg.Name = a.Name;
            hmbg.OwnerId = a.OwnerId;
            hmbg.Comments__c = a.Comments__c;
            hmbg.Forecast_Role__c = a.Forecast_Role__c;
            hmbg.Is_Manager__c = a.Is_Manager__c;
            hmbg.Last_Entered_Date__c = a.Last_Entered_Date__c;
            hmbg.Last_Entered_User__c = a.Last_Entered_User__c;
            hmbg.Manager__c = a.Manager__c;
            hmbg.Manager_Best_Guess__c = a.Manager_Best_Guess__c;
            hmbg.Override_Team_Manu_Audience_Best_Guess__c = a.Override_Team_Manu_Audience_Best_Guess__c;
            hmbg.Team_Manufacturing_Audience_Best_Guess__c = a.Team_Manufacturing_Audience_Best_Guess__c;
            hmbg.Team_M_A_Booked_Full_Proposal__c = a.Team_M_A_Booked_Full_Proposal__c;
            hmbg.Team_M_A_Booked_Proposal__c = a.Team_M_A_Booked_Proposal__c;
            hmbg.Team_M_A_Booked_Actual__c = a.Team_M_A_Booked_Actual__c;
            hmbg.Override_Team_Manu_Audience_High__c = a.Override_Team_Manu_Audience_High__c;
            hmbg.Team_Manufacturing_Audience_High__c = a.Team_Manufacturing_Audience_High__c;
            hmbg.Override_Team_Manu_Audience_Low__c = a.Override_Team_Manu_Audience_Low__c;
            hmbg.Team_Manufacturing_Audience_Low__c = a.Team_Manufacturing_Audience_Low__c;
            hmbg.Override_Team_Manu_Base_Best_Guess__c = a.Override_Team_Manu_Base_Best_Guess__c;
            hmbg.Team_Manufacturing_Base_Best_Guess__c = a.Team_Manufacturing_Base_Best_Guess__c;
            hmbg.Team_M_B_Booked_Full_Proposal__c = a.Team_M_B_Booked_Full_Proposal__c;
            hmbg.Team_M_B_Booked_Proposal__c = a.Team_M_B_Booked_Proposal__c;
            hmbg.Team_M_B_Booked_Actual__c = a.Team_M_B_Booked_Actual__c;
            hmbg.Override_Team_Manu_Base_High__c = a.Override_Team_Manu_Base_High__c;
            hmbg.Team_Manufacturing_Base_High__c = a.Team_Manufacturing_Base_High__c;
            hmbg.Override_Team_Manu_Base_Low__c = a.Override_Team_Manu_Base_Low__c;
            hmbg.Team_Manufacturing_Base_Low__c = a.Team_Manufacturing_Base_Low__c;
            hmbg.Override_Team_Manu_Digital_Best_Guess__c = a.Override_Team_Manu_Digital_Best_Guess__c;
            hmbg.Team_Manufacturing_Digital_Best_Guess__c = a.Team_Manufacturing_Digital_Best_Guess__c;
            hmbg.Team_M_D_Booked_Full_Proposal__c = a.Team_M_D_Booked_Full_Proposal__c;
            hmbg.Team_M_D_Booked_Proposal__c = a.Team_M_D_Booked_Proposal__c;
            hmbg.Team_M_D_Booked_Actual__c = a.Team_M_D_Booked_Actual__c;
            hmbg.Override_Team_Manu_Digital_High__c = a.Override_Team_Manu_Digital_High__c;
            hmbg.Team_Manufacturing_Digital_High__c = a.Team_Manufacturing_Digital_High__c;
            hmbg.Team_Manufacturing_Digital_Low__c = a.Team_Manufacturing_Digital_Low__c;
            hmbg.Override_Team_Manu_Digital_Low__c = a.Override_Team_Manu_Digital_Low__c;
            hmbg.Override_Team_Manu_Mobile_Best_Guess__c = a.Override_Team_Manu_Mobile_Best_Guess__c;
            hmbg.Team_Manufacturing_Mobile_Best_Guess__c = a.Team_Manufacturing_Mobile_Best_Guess__c;
            hmbg.Team_M_M_Booked_Full_Proposal__c = a.Team_M_M_Booked_Full_Proposal__c;
            hmbg.Team_M_M_Booked_Proposal__c = a.Team_M_M_Booked_Proposal__c;
            hmbg.Team_M_M_Booked_Actual__c = a.Team_M_M_Booked_Actual__c;
            hmbg.Override_Team_Manu_Mobile_High__c = a.Override_Team_Manu_Mobile_High__c;
            hmbg.Team_Manufacturing_Mobile_High__c = a.Team_Manufacturing_Mobile_High__c;
            hmbg.Override_Team_Manu_Mobile_Low__c = a.Override_Team_Manu_Mobile_Low__c;
            hmbg.Team_Manufacturing_Mobile_Low__c = a.Team_Manufacturing_Mobile_Low__c;
            hmbg.Quarter__c = a.Quarter__c;
            hmbg.Quarter_End_Date__c = a.Quarter_End_Date__c;
            hmbg.Quarter_Start_Date__c = a.Quarter_Start_Date__c;
            hmbg.Override_Team_Retail_Audience_Best_Guess__c = a.Override_Team_Retail_Audience_Best_Guess__c;
            hmbg.Team_Retail_Audience_Best_Guess__c = a.Team_Retail_Audience_Best_Guess__c;
            hmbg.Team_R_A_Booked_Proposal__c = a.Team_R_A_Booked_Proposal__c;
            hmbg.Team_R_A_Booked_Actual__c = a.Team_R_A_Booked_Actual__c;
            hmbg.Override_Team_Retail_Audience_High__c = a.Override_Team_Retail_Audience_High__c;
            hmbg.Team_Retail_Audience_High__c = a.Team_Retail_Audience_High__c;
            hmbg.Override_Team_Retail_Audience_Low__c = a.Override_Team_Retail_Audience_Low__c;
            hmbg.Team_Retail_Audience_Low__c = a.Team_Retail_Audience_Low__c;
            hmbg.Override_Team_Retail_Base_Best_Guess__c = a.Override_Team_Retail_Base_Best_Guess__c;
            hmbg.Team_Retail_Base_Best_Guess__c = a.Team_Retail_Base_Best_Guess__c;
            hmbg.Team_R_B_Booked_Full_Proposal__c = a.Team_R_B_Booked_Full_Proposal__c;
            hmbg.Team_R_B_Booked_Proposal__c = a.Team_R_B_Booked_Proposal__c;
            hmbg.Team_R_B_Booked_Actual__c = a.Team_R_B_Booked_Actual__c;
            hmbg.Override_Team_Retail_Base_High__c = a.Override_Team_Retail_Base_High__c;
            hmbg.Team_Retail_Base_High__c = a.Team_Retail_Base_High__c;
            hmbg.Override_Team_Retail_Base_Low__c = a.Override_Team_Retail_Base_Low__c;
            hmbg.Team_Retail_Base_Low__c = a.Team_Retail_Base_Low__c;
            hmbg.Override_Team_Retail_Digital_Best_Guess__c = a.Override_Team_Retail_Digital_Best_Guess__c;
            hmbg.Team_Retail_Digital_Best_Guess__c = a.Team_Retail_Digital_Best_Guess__c;
            hmbg.Team_R_D_Booked_Proposal__c = a.Team_R_D_Booked_Proposal__c;
            hmbg.Team_R_D_Booked_Actual__c = a.Team_R_D_Booked_Actual__c;
            hmbg.Override_Team_Retail_Digital_High__c = a.Override_Team_Retail_Digital_High__c;
            hmbg.Team_Retail_Digital_High__c = a.Team_Retail_Digital_High__c;
            hmbg.Override_Team_Retail_Digital_Low__c = a.Override_Team_Retail_Digital_Low__c;
            hmbg.Team_Retail_Digital_Low__c = a.Team_Retail_Digital_Low__c;
            hmbg.Override_Team_Retail_Mobile_Best_Guess__c = a.Override_Team_Retail_Mobile_Best_Guess__c;
            hmbg.Team_Retail_Mobile_Best_Guess__c = a.Team_Retail_Mobile_Best_Guess__c;
            hmbg.Team_R_M_Booked_Full_Proposal__c = a.Team_R_M_Booked_Full_Proposal__c;
            hmbg.Team_R_M_Booked_Proposal__c = a.Team_R_M_Booked_Proposal__c;
            hmbg.Team_R_M_Booked_Actual__c = a.Team_R_M_Booked_Actual__c;
            hmbg.Override_Team_Retail_Mobile_High__c = a.Override_Team_Retail_Mobile_High__c;
            hmbg.Team_Retail_Mobile_High__c = a.Team_Retail_Mobile_High__c;
            hmbg.Override_Team_Retail_Mobile_Low__c = a.Override_Team_Retail_Mobile_Low__c;
            hmbg.Team_Retail_Mobile_Low__c = a.Team_Retail_Mobile_Low__c;
            hmbg.Team_R_A_Booked_Full_Proposal__c = a.Team_R_A_Booked_Full_Proposal__c;
            hmbg.Team_R_D_Booked_Full_Proposal__c = a.Team_R_D_Booked_Full_Proposal__c;
            hmbg.Same_as_Owner__c = a.Same_as_Owner__c;
            hmbg.Support_User__c = a.Support_User__c;
            hmbg.Team_Booked_Actual__c = a.Team_Booked_Actual__c;
            hmbg.Team_Booked_Full_Proposal__c = a.Team_Booked_Full_Proposal__c;
            hmbg.Team_Booked_Proposal__c = a.Team_Booked_Proposal__c;
            hmbg.Team_Previous_Year_Actual__c = a.Team_Previous_Year_Actual__c;
            hmbg.Team_Quota__c = a.Team_Quota__c;
            hmbg.Total_BG__c = a.Total_BG__c;
            hmbg.Total_BG_Override__c = a.Total_BG_Override__c;
            hmbg.Total_H_Override__c = a.Total_H_Override__c;
            hmbg.Total_H__c = a.Total_H__c;
            hmbg.Total_L_Override__c = a.Total_L_Override__c;
            hmbg.Total_L__c = a.Total_L__c;
            hmbg.Use_Override__c = a.Use_Override__c;
            hmbg.Year__c = a.Year__c;
            /*added for testing
            hmbg.Total_BG__c /= 2;
            hmbg.Team_Manufacturing_Base_Best_Guess__c /=6;
            hmbg.Team_Retail_Base_Best_Guess__c /=6;
            hmbg.Team_Manufacturing_Digital_Best_Guess__c /=6;
            hmbg.Team_Retail_Digital_Best_Guess__c /=6;
            hmbg.Team_Manufacturing_Audience_Best_Guess__c /=6;
            hmbg.Team_Retail_Audience_Best_Guess__c /=6;
            hmbg.Team_Manufacturing_Digital_Best_Guess__c /=6;
            hmbg.Team_Manufacturing_Mobile_Best_Guess__c /=6;
            hmbg.Team_Retail_Mobile_Best_Guess__c /=6;
            
            
            hmbg.Team_Booked_Actual__c /= 7;
            
            hmbg.Team_M_B_Booked_Actual__c /= 7;
            hmbg.Team_R_B_Booked_Actual__c /= 7;
            hmbg.Team_M_D_Booked_Actual__c /= 7;
            hmbg.Team_R_D_Booked_Actual__c /= 7;
            hmbg.Team_M_A_Booked_Actual__c /= 7;
            hmbg.Team_R_A_Booked_Actual__c /= 7;
            hmbg.Team_M_M_Booked_Actual__c /= 7;
            hmbg.Team_R_M_Booked_Actual__c /= 7;
            */
            
            inserthmbg.add(hmbg);
        }
        insert inserthmbg;
    }
    
    //method that runs after the execute() method
    global void finish(Database.BatchableContext BC){
        System.debug(LoggingLevel.WARN,'Temp_Delete_DeleteSM1Forecast');
        //Build the system time of now + 20 seconds to schedule the batch apex.
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        BatchInsertHistoricalSRBestGuess acctBatch2Sched = new BatchInsertHistoricalSRBestGuess();
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
    }

}