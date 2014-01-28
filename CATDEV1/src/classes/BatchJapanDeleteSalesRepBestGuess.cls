/*
@Name            : BatchJapanDeleteSalesRepBestGuess 
@Author          : customersuccess@cloud62.com
@Date            : December 17th, 2012
@Description     : Sets all best guess records to 0 so that we can recalculate it
Jan 24 2013 - change batch size to 50 to avoid soql exception
*/
global class BatchJapanDeleteSalesRepBestGuess implements Database.Batchable<sObject>, Schedulable{
    
    final static String defaultSettingsName = 'Default';
    
    String query;
    String limit1;
    String yearInput;
    
    public BatchJapanDeleteSalesRepBestGuess (String yearParam){
        yearInput = yearParam;
    }
    
    public BatchJapanDeleteSalesRepBestGuess (){
        limit1 = '';
        yearInput = String.valueOf(Date.today().year() - 1);
    }
    
    //method that gets the query used for this batch
    global Database.querylocator start(Database.BatchableContext BC){
        //query = 'SELECT ID, NAME FROM ACCOUNT LIMIT 200';
        //query = 'Select Id From Sales_Manager_1_Quota__c';
        BatchGovernorLimitUtility.insertBatchRun('BatchJapanDeleteSalesRepBestGuess');
        query = 'Select Id From Sales_Rep_Best_Guess__c WHERE YEAR__C = \'' + yearInput + '\'  And Recordtype.Name = \'Japan\'';
        system.debug(LoggingLevel.ERROR, '***QUERY: ' + query);
        return Database.getQueryLocator(query);
    }
    
    //Jan 24, 2013 - set batch size to 50 to avoid soql exception
    global void execute(SchedulableContext ctx) {
        BatchJapanDeleteSalesRepBestGuess batch1 = new BatchJapanDeleteSalesRepBestGuess(yearInput);
        ID batchprocessid = Database.executeBatch(batch1, 50);
    }
    
    //method that makes up the body of the batch process
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        Datetime currentTime = System.now();
        /* //old execute
        delete scope;
        */
        
        //get forecast settings, and bucket users by Forecast Role
        Catalina_Forecast_Settings__c settings = Catalina_Forecast_Settings__c.getInstance(defaultSettingsName);
        String rep2Type = settings.Rep_2_String__c;
        String rep1Type = settings.Rep_1_String__c;
        String SM2Type = settings.SM_2_String__c;
        String SM1Type = settings.SM_1_String__c;
        String coopType = settings.Coop_String__c;
        
        Set<Id> rep2Users = new Set<Id>();
        Set<Id> rep1Users = new Set<Id>();
        Set<Id> sm2Users = new Set<Id>();
        Set<Id> sm1Users = new Set<Id>();
        List<User> userList = [SELECT ID, Forecast_Role__c FROM User Where Forecast_Role__c != null and Profile.Name Like 'Japan%'];
        for (User a : userList){
            if (a.Forecast_Role__c == rep2Type){
                rep2Users.add(a.Id);
            } else if (a.Forecast_Role__c == rep1Type){
                rep1Users.add(a.Id);
            } else if (a.Forecast_Role__c == sm2Type){
                sm2Users.add(a.Id);
            } else if (a.Forecast_Role__c == sm1Type || a.Forecast_Role__c == coopType){
                sm1Users.add(a.Id);
            } 
        }
        
        //set all SRBG amounts to 0, this will roll up the chain
        List<Sales_Rep_Best_Guess__c> scopeSRBG = (List<Sales_Rep_Best_Guess__c>)scope;
        
        for (Sales_Rep_Best_Guess__c a : scopeSRBG){
            a.Actual_Amount__c = 0;
            a.Forecast_Contract__c = 0;
            a.Forecast_Proposal__c = 0;
            a.Weighted_forecast_Proposal__c = 0;
            a.Previous_Year_Actual__c = 0;
            a.M_A_Actual_Amount__c = 0;
            a.M_A_Forecast_Contract__c = 0;
            a.M_A_Forecast_Proposal__c = 0;
            a.M_A_Weighted_Forecast_Proposal__c = 0;
            a.M_B_Actual_Amount__c = 0;
            a.M_B_Forecast_Contract__c = 0;
            a.M_B_Forecast_Proposal__c = 0;
            a.M_B_Weighted_Forecast_Proposal__c = 0;
            a.M_D_Actual_Amount__c = 0;
            a.M_D_Forecast_Contract__c = 0;
            a.M_D_Forecast_Proposal__c = 0;
            a.M_D_Weighted_Forecast_Proposal__c = 0;
            a.M_M_Actual_Amount__c = 0;
            a.M_M_Forecast_Contract__c = 0;
            a.M_M_Forecast_Proposal__c = 0;
            a.M_M_Weighted_Forecast_Proposal__c = 0;
            a.R_A_Actual_Amount__c = 0;
            a.R_A_Forecast_Contract__c = 0;
            a.R_A_Forecast_Proposal__c = 0;
            a.R_A_Weighted_Forecast_Proposal__c = 0;
            a.R_B_Actual_Amount__c = 0;
            a.R_B_Forecast_Contract__c = 0;
            a.R_B_Forecast_Proposal__c = 0;
            a.R_B_Weighted_Forecast_Proposal__c = 0;
            a.R_D_Actual_Amount__c = 0;
            a.R_D_Forecast_Contract__c = 0;
            a.R_D_Forecast_Proposal__c = 0;
            a.R_D_Weighted_Forecast_Proposal__c = 0;
            a.R_M_Actual_Amount__c = 0;
            a.R_M_Forecast_Contract__c = 0;
            a.R_M_Forecast_Proposal__c = 0;
            a.R_M_Weighted_Forecast_Proposal__c = 0;
        }
        
        update scopeSRBG;
        
        //set all SR1 MBG records to 0, this will roll up the chain
        List<Manager_Best_Guess__c> parent = [Select m.Team_Retail_Digital_Low__c, m.Team_Retail_Digital_High__c, m.Team_Retail_Digital_Best_Guess__c, 
        m.Team_Retail_Base_Low__c, m.Team_Retail_Base_High__c, m.Team_Retail_Base_Best_Guess__c, m.Team_Quota__c, m.Team_Manufacturing_Digital_Low__c, 
        m.Team_Manufacturing_Digital_High__c, m.Team_Manufacturing_Digital_Best_Guess__c, m.Team_Manufacturing_Base_Low__c, m.Team_Manufacturing_Base_High__c, 
        m.Team_Manufacturing_Base_Best_Guess__c, m.Team_Booked_Proposal__c, m.Team_Booked_Actual__c, m.OwnerId, m.Name, m.Manager_Best_Guess__c, m.Id,
        m.Team_Previous_Year_Actual__c, m.Team_Booked_Full_Proposal__c,
        m.Team_M_A_Booked_Actual__c, m.Team_M_A_Booked_Full_Proposal__c, m.Team_M_A_Booked_Proposal__c,
        m.Team_M_B_Booked_Actual__c, m.Team_M_B_Booked_Full_Proposal__c, m.Team_M_B_Booked_Proposal__c,
        m.Team_M_D_Booked_Actual__c, m.Team_M_D_Booked_Full_Proposal__c, m.Team_M_D_Booked_Proposal__c,
        m.Team_M_M_Booked_Actual__c, m.Team_M_M_Booked_Full_Proposal__c, m.Team_M_M_Booked_Proposal__c,
        m.Team_R_A_Booked_Actual__c, m.Team_R_A_Booked_Full_Proposal__c, m.Team_R_A_Booked_Proposal__c,
        m.Team_R_B_Booked_Actual__c, m.Team_R_B_Booked_Full_Proposal__c, m.Team_R_B_Booked_Proposal__c,
        m.Team_R_D_Booked_Actual__c, m.Team_R_D_Booked_Full_Proposal__c, m.Team_R_D_Booked_Proposal__c,
        m.Team_R_M_Booked_Actual__c, m.Team_R_M_Booked_Full_Proposal__c, m.Team_R_M_Booked_Proposal__c,
        m.Team_Manufacturing_Audience_Best_Guess__c, m.Team_Manufacturing_Audience_High__c, m.Team_Manufacturing_Audience_Low__c,
        m.Team_Manufacturing_Mobile_Best_Guess__c, m.Team_Manufacturing_Mobile_High__c, m.Team_Manufacturing_Mobile_Low__c,
        m.Team_Retail_Audience_Best_Guess__c, m.Team_Retail_Audience_High__c, m.Team_Retail_Audience_Low__c,
        m.Team_Retail_Mobile_Best_Guess__c, m.Team_Retail_Mobile_High__c, m.Team_Retail_Mobile_Low__c
        From Manager_Best_Guess__c m where OwnerId IN :rep1Users AND YEAR__C =: yearInput];
        
        for (Manager_Best_Guess__c a : parent){
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
        
        update parent;
        
        //set all SM2 MBG records to 0
        parent = [Select m.Team_Retail_Digital_Low__c, m.Team_Retail_Digital_High__c, m.Team_Retail_Digital_Best_Guess__c, 
        m.Team_Retail_Base_Low__c, m.Team_Retail_Base_High__c, m.Team_Retail_Base_Best_Guess__c, m.Team_Quota__c, m.Team_Manufacturing_Digital_Low__c, 
        m.Team_Manufacturing_Digital_High__c, m.Team_Manufacturing_Digital_Best_Guess__c, m.Team_Manufacturing_Base_Low__c, m.Team_Manufacturing_Base_High__c, 
        m.Team_Manufacturing_Base_Best_Guess__c, m.Team_Booked_Proposal__c, m.Team_Booked_Actual__c, m.OwnerId, m.Name, m.Manager_Best_Guess__c, m.Id,
        m.Team_Previous_Year_Actual__c, m.Team_Booked_Full_Proposal__c,
        m.Team_M_A_Booked_Actual__c, m.Team_M_A_Booked_Full_Proposal__c, m.Team_M_A_Booked_Proposal__c,
        m.Team_M_B_Booked_Actual__c, m.Team_M_B_Booked_Full_Proposal__c, m.Team_M_B_Booked_Proposal__c,
        m.Team_M_D_Booked_Actual__c, m.Team_M_D_Booked_Full_Proposal__c, m.Team_M_D_Booked_Proposal__c,
        m.Team_M_M_Booked_Actual__c, m.Team_M_M_Booked_Full_Proposal__c, m.Team_M_M_Booked_Proposal__c,
        m.Team_R_A_Booked_Actual__c, m.Team_R_A_Booked_Full_Proposal__c, m.Team_R_A_Booked_Proposal__c,
        m.Team_R_B_Booked_Actual__c, m.Team_R_B_Booked_Full_Proposal__c, m.Team_R_B_Booked_Proposal__c,
        m.Team_R_D_Booked_Actual__c, m.Team_R_D_Booked_Full_Proposal__c, m.Team_R_D_Booked_Proposal__c,
        m.Team_R_M_Booked_Actual__c, m.Team_R_M_Booked_Full_Proposal__c, m.Team_R_M_Booked_Proposal__c,
        m.Team_Manufacturing_Audience_Best_Guess__c, m.Team_Manufacturing_Audience_High__c, m.Team_Manufacturing_Audience_Low__c,
        m.Team_Manufacturing_Mobile_Best_Guess__c, m.Team_Manufacturing_Mobile_High__c, m.Team_Manufacturing_Mobile_Low__c,
        m.Team_Retail_Audience_Best_Guess__c, m.Team_Retail_Audience_High__c, m.Team_Retail_Audience_Low__c,
        m.Team_Retail_Mobile_Best_Guess__c, m.Team_Retail_Mobile_High__c, m.Team_Retail_Mobile_Low__c
        From Manager_Best_Guess__c m where OwnerId IN :sm2Users  AND YEAR__C =: yearInput];
        
        for (Manager_Best_Guess__c a : parent){
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
        
        update parent;
        
        //set all SM1 MBG records to 0
        parent = [Select m.Team_Retail_Digital_Low__c, m.Team_Retail_Digital_High__c, m.Team_Retail_Digital_Best_Guess__c, 
        m.Team_Retail_Base_Low__c, m.Team_Retail_Base_High__c, m.Team_Retail_Base_Best_Guess__c, m.Team_Quota__c, m.Team_Manufacturing_Digital_Low__c, 
        m.Team_Manufacturing_Digital_High__c, m.Team_Manufacturing_Digital_Best_Guess__c, m.Team_Manufacturing_Base_Low__c, m.Team_Manufacturing_Base_High__c, 
        m.Team_Manufacturing_Base_Best_Guess__c, m.Team_Booked_Proposal__c, m.Team_Booked_Actual__c, m.OwnerId, m.Name, m.Manager_Best_Guess__c, m.Id,
        m.Team_Previous_Year_Actual__c, m.Team_Booked_Full_Proposal__c,
        m.Team_M_A_Booked_Actual__c, m.Team_M_A_Booked_Full_Proposal__c, m.Team_M_A_Booked_Proposal__c,
        m.Team_M_B_Booked_Actual__c, m.Team_M_B_Booked_Full_Proposal__c, m.Team_M_B_Booked_Proposal__c,
        m.Team_M_D_Booked_Actual__c, m.Team_M_D_Booked_Full_Proposal__c, m.Team_M_D_Booked_Proposal__c,
        m.Team_M_M_Booked_Actual__c, m.Team_M_M_Booked_Full_Proposal__c, m.Team_M_M_Booked_Proposal__c,
        m.Team_R_A_Booked_Actual__c, m.Team_R_A_Booked_Full_Proposal__c, m.Team_R_A_Booked_Proposal__c,
        m.Team_R_B_Booked_Actual__c, m.Team_R_B_Booked_Full_Proposal__c, m.Team_R_B_Booked_Proposal__c,
        m.Team_R_D_Booked_Actual__c, m.Team_R_D_Booked_Full_Proposal__c, m.Team_R_D_Booked_Proposal__c,
        m.Team_R_M_Booked_Actual__c, m.Team_R_M_Booked_Full_Proposal__c, m.Team_R_M_Booked_Proposal__c,
        m.Team_Manufacturing_Audience_Best_Guess__c, m.Team_Manufacturing_Audience_High__c, m.Team_Manufacturing_Audience_Low__c,
        m.Team_Manufacturing_Mobile_Best_Guess__c, m.Team_Manufacturing_Mobile_High__c, m.Team_Manufacturing_Mobile_Low__c,
        m.Team_Retail_Audience_Best_Guess__c, m.Team_Retail_Audience_High__c, m.Team_Retail_Audience_Low__c,
        m.Team_Retail_Mobile_Best_Guess__c, m.Team_Retail_Mobile_High__c, m.Team_Retail_Mobile_Low__c
        From Manager_Best_Guess__c m where OwnerId IN :sm1Users  AND YEAR__C =: yearInput];
        
        for (Manager_Best_Guess__c a : parent){
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
        
        update parent;
        
        //set all records MBG records to 0 three times for the 3 levels above SM1
        parent = [Select m.Team_Retail_Digital_Low__c, m.Team_Retail_Digital_High__c, m.Team_Retail_Digital_Best_Guess__c, 
        m.Team_Retail_Base_Low__c, m.Team_Retail_Base_High__c, m.Team_Retail_Base_Best_Guess__c, m.Team_Quota__c, m.Team_Manufacturing_Digital_Low__c, 
        m.Team_Manufacturing_Digital_High__c, m.Team_Manufacturing_Digital_Best_Guess__c, m.Team_Manufacturing_Base_Low__c, m.Team_Manufacturing_Base_High__c, 
        m.Team_Manufacturing_Base_Best_Guess__c, m.Team_Booked_Proposal__c, m.Team_Booked_Actual__c, m.OwnerId, m.Name, m.Manager_Best_Guess__c, m.Id,
        m.Team_Previous_Year_Actual__c, m.Team_Booked_Full_Proposal__c,
        m.Team_M_A_Booked_Actual__c, m.Team_M_A_Booked_Full_Proposal__c, m.Team_M_A_Booked_Proposal__c,
        m.Team_M_B_Booked_Actual__c, m.Team_M_B_Booked_Full_Proposal__c, m.Team_M_B_Booked_Proposal__c,
        m.Team_M_D_Booked_Actual__c, m.Team_M_D_Booked_Full_Proposal__c, m.Team_M_D_Booked_Proposal__c,
        m.Team_M_M_Booked_Actual__c, m.Team_M_M_Booked_Full_Proposal__c, m.Team_M_M_Booked_Proposal__c,
        m.Team_R_A_Booked_Actual__c, m.Team_R_A_Booked_Full_Proposal__c, m.Team_R_A_Booked_Proposal__c,
        m.Team_R_B_Booked_Actual__c, m.Team_R_B_Booked_Full_Proposal__c, m.Team_R_B_Booked_Proposal__c,
        m.Team_R_D_Booked_Actual__c, m.Team_R_D_Booked_Full_Proposal__c, m.Team_R_D_Booked_Proposal__c,
        m.Team_R_M_Booked_Actual__c, m.Team_R_M_Booked_Full_Proposal__c, m.Team_R_M_Booked_Proposal__c,
        m.Team_Manufacturing_Audience_Best_Guess__c, m.Team_Manufacturing_Audience_High__c, m.Team_Manufacturing_Audience_Low__c,
        m.Team_Manufacturing_Mobile_Best_Guess__c, m.Team_Manufacturing_Mobile_High__c, m.Team_Manufacturing_Mobile_Low__c,
        m.Team_Retail_Audience_Best_Guess__c, m.Team_Retail_Audience_High__c, m.Team_Retail_Audience_Low__c,
        m.Team_Retail_Mobile_Best_Guess__c, m.Team_Retail_Mobile_High__c, m.Team_Retail_Mobile_Low__c
        From Manager_Best_Guess__c m  WHERE YEAR__C =: yearInput And Recordtype.Name = 'Japan'];
        
        for (Manager_Best_Guess__c a : parent){
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
        
        update parent;
        update parent;
        update parent;
        BatchGovernorLimitUtility.calcualteLimits(Limits.getCpuTime(), Limits.getDMLRows(), Limits.getDMLStatements(), Limits.getHeapSize(), Limits.getQueries(), Limits.getQueryRows(), Limits.getScriptStatements(), scope, currentTime, System.now());
    }
    
    //method that runs after the execute() method
    global void finish(Database.BatchableContext BC){
    
        System.debug(LoggingLevel.WARN,'Temp_Delete_DeleteSM1Forecast');
        //Build the system time of now + 20 seconds to schedule the batch apex.
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        //the if branch below makes sure that the class will run 3 times
        //the first time around, the yearParam of last year should be passed
        //we pass the 2 following users each time through, then the next class at the end
        if (yearInput == String.valueOf(Date.today().year() - 1)){
          String year2 = String.valueOf(Date.today().year());
          BatchJapanDeleteSalesRepBestGuess acctBatch2Sched = new BatchJapanDeleteSalesRepBestGuess(year2);
          //Schedule the next job, and give it the system time so name is unique
          System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
        } else if (yearInput == String.valueOf(Date.today().year())){
          String year2 = String.valueOf(Date.today().year() + 1);
          BatchJapanDeleteSalesRepBestGuess acctBatch2Sched = new BatchJapanDeleteSalesRepBestGuess(year2);
          //Schedule the next job, and give it the system time so name is unique
          System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
        } else {
          String year2 = String.valueOf(Date.today().year() - 1);
          BatchJapanRecalculateBestGuess acctBatch2Sched = new BatchJapanRecalculateBestGuess(year2);
          //Schedule the next job, and give it the system time so name is unique
          System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
        }
        BatchGovernorLimitUtility.updateBatchRun();
        
    }

}