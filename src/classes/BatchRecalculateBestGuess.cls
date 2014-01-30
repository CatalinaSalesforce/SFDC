/*
@Name            : BatchRecalculateBestGuess 
@Author          : customersuccess@cloud62.com
@Date            : December 17th, 2012
@Description     : Batch Proccess to Recalculate all of the high/low/best guess numbers
Oct 9 2013 - change the next scheduled class as part of redesign process
*/
global class BatchRecalculateBestGuess implements Database.Batchable<sObject>, Schedulable{
    
    final static String defaultSettingsName = 'Default';
    
    String query;
    Catalina_Forecast_Settings__c settings;
    String rep2Type;
    String rep1Type;
    String SM2Type;
    String SM1Type;
    String coopType;
    String yearInput;
    
    //constructor receives a String parameter in the form of a year.
    //This class must run once for every ear that requires recalculation
    public BatchRecalculateBestGuess(String yearParam){
        yearInput = yearParam;
    }
    
    global void execute(SchedulableContext ctx) {
        BatchRecalculateBestGuess batch1 = new BatchRecalculateBestGuess(yearInput);
        ID batchprocessid = Database.executeBatch(batch1);
    }
    
    global Database.querylocator start(Database.BatchableContext BC){
        BatchGovernorLimitUtility.insertBatchRun('BatchRecalculateBestGuess');
        query = 'SELECT ID FROM USER LIMIT 1';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        Datetime currentTime = System.now();
        
        //get forecast settings and separate users into buckets by Forecast role
        settings = Catalina_Forecast_Settings__c.getInstance(defaultSettingsName);
        List <Manager_Best_Guess__c> updateMBG = new List<Manager_Best_Guess__c>();
        rep2Type = settings.Rep_2_String__c;
        rep1Type = settings.Rep_1_String__c;
        SM2Type = settings.SM_2_String__c;
        SM1Type = settings.SM_1_String__c;
        coopType = settings.Coop_String__c;
        Set<Id> rep2Users = new Set<Id>();
        Set<Id> rep1Users = new Set<Id>();
        Set<Id> sm2Users = new Set<Id>();
        Set<Id> sm1Users = new Set<Id>();
        List<User> userList = [SELECT ID, Forecast_Role__c FROM User Where Forecast_Role__c != null];
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
        
        //get all of the SRBG records of this year.  These records determine which records up the chain
        //we will also be recalculating
        List<Sales_Rep_Best_Guess__c> srbgList = [SELECT ID, OWNERID, QUARTER__C, Manager__c, Manager_Best_Guess__c,
            Manufacturing_Base_Best_Guess__c, Manufacturing_Base_High__c, Manufacturing_Base_Low__c,
            Manufacturing_Digital_Best_Guess__c, Manufacturing_Digital_High__c, Manufacturing_Digital_Low__c,
            Manufacturing_Audience_Best_Guess__c, Manufacturing_Audience_High__c, Manufacturing_Audience_Low__c,
            Manufacturing_Mobile_Best_Guess__c, Manufacturing_Mobile_High__c, Manufacturing_Mobile_Low__c,
            Retail_Base_Best_Guess__c, Retail_Base_High__c, Retail_Base_Low__c,
            Retail_Digital_Best_Guess__c, Retail_Digital_High__c, Retail_Digital_Low__c,
            Retail_Audience_Best_Guess__c, Retail_Audience_High__c, Retail_Audience_Low__c,
            Retail_Mobile_Best_Guess__c, Retail_Mobile_High__c, Retail_Mobile_Low__c
            From Sales_Rep_Best_Guess__c WHERE YEAR__C =: yearInput];
        
        List<Manager_Best_Guess__c> mbgList = [Select m.Team_Retail_Digital_Low__c, m.Team_Retail_Digital_High__c, m.Team_Retail_Digital_Best_Guess__c, 
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
        m.Team_Retail_Mobile_Best_Guess__c, m.Team_Retail_Mobile_High__c, m.Team_Retail_Mobile_Low__c, 
        m.Override_Team_Retail_Mobile_Low__c, m.Override_Team_Retail_Mobile_High__c, m.Override_Team_Retail_Mobile_Best_Guess__c,
        m.Override_Team_Retail_Digital_Low__c, m.Override_Team_Retail_Digital_High__c, m.Override_Team_Retail_Digital_Best_Guess__c,
        m.Override_Team_Retail_Base_Low__c, m.Override_Team_Retail_Base_High__c, m.Override_Team_Retail_Base_Best_Guess__c,
        m.Override_Team_Retail_Audience_Low__c, m.Override_Team_Retail_Audience_High__c, m.Override_Team_Retail_Audience_Best_Guess__c,
        m.Override_Team_Manu_Mobile_Low__c, m.Override_Team_Manu_Mobile_High__c, m.Override_Team_Manu_Mobile_Best_Guess__c,
        m.Override_Team_Manu_Digital_Low__c, m.Override_Team_Manu_Digital_High__c, m.Override_Team_Manu_Digital_Best_Guess__c,
        m.Override_Team_Manu_Base_Low__c, m.Override_Team_Manu_Base_High__c, m.Override_Team_Manu_Base_Best_Guess__c,
        m.Override_Team_Manu_Audience_Low__c, m.Override_Team_Manu_Audience_High__c, m.Override_Team_Manu_Audience_Best_Guess__c,
        Use_Override__c
        From Manager_Best_Guess__c m WHERE m.YEAR__C =: yearInput];
        
        List<Manager_Best_Guess__c> mbgChild = [Select m.Team_Retail_Digital_Low__c, m.Team_Retail_Digital_High__c, m.Team_Retail_Digital_Best_Guess__c, 
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
        m.Team_Retail_Mobile_Best_Guess__c, m.Team_Retail_Mobile_High__c, m.Team_Retail_Mobile_Low__c, 
        m.Override_Team_Retail_Mobile_Low__c, m.Override_Team_Retail_Mobile_High__c, m.Override_Team_Retail_Mobile_Best_Guess__c,
        m.Override_Team_Retail_Digital_Low__c, m.Override_Team_Retail_Digital_High__c, m.Override_Team_Retail_Digital_Best_Guess__c,
        m.Override_Team_Retail_Base_Low__c, m.Override_Team_Retail_Base_High__c, m.Override_Team_Retail_Base_Best_Guess__c,
        m.Override_Team_Retail_Audience_Low__c, m.Override_Team_Retail_Audience_High__c, m.Override_Team_Retail_Audience_Best_Guess__c,
        m.Override_Team_Manu_Mobile_Low__c, m.Override_Team_Manu_Mobile_High__c, m.Override_Team_Manu_Mobile_Best_Guess__c,
        m.Override_Team_Manu_Digital_Low__c, m.Override_Team_Manu_Digital_High__c, m.Override_Team_Manu_Digital_Best_Guess__c,
        m.Override_Team_Manu_Base_Low__c, m.Override_Team_Manu_Base_High__c, m.Override_Team_Manu_Base_Best_Guess__c,
        m.Override_Team_Manu_Audience_Low__c, m.Override_Team_Manu_Audience_High__c, m.Override_Team_Manu_Audience_Best_Guess__c,
        Use_Override__c
        From Manager_Best_Guess__c m WHERE m.YEAR__C =: yearInput];

        //for each of the MBG records where the owner is a SR2, each field by looking at all of the child MBG and SRBGs
        for (Manager_Best_Guess__c mbg : mbgList){
            if (rep2Users.contains(mbg.OwnerId)){
                double MABG = 0;
                double MAL = 0;
                double MAH = 0;
                double MBBG = 0;
                double MBL = 0;
                double MBH = 0;
                double MDBG = 0;
                double MDL = 0;
                double MDH = 0;
                double MMBG = 0;
                double MML = 0;
                double MMH = 0;
                double RABG = 0;
                double RAL = 0;
                double RAH = 0;
                double RBBG = 0;
                double RBL = 0;
                double RBH = 0;
                double RDBG = 0;
                double RDL = 0;
                double RDH = 0;
                double RMBG = 0;
                double RML = 0;
                double RMH = 0;
                for (Sales_Rep_Best_Guess__c srbg : srbgList){
                    if (mbg.Id == srbg.Manager_Best_Guess__c){
                        MABG += (srbg.Manufacturing_Audience_Best_Guess__c == null ? 0 : srbg.Manufacturing_Audience_Best_Guess__c);
                        MAH += (srbg.Manufacturing_Audience_High__c == null ? 0 : srbg.Manufacturing_Audience_High__c);
                        MAL += (srbg.Manufacturing_Audience_Low__c == null ? 0 : srbg.Manufacturing_Audience_Low__c);
                        MBBG += (srbg.Manufacturing_Base_Best_Guess__c == null ? 0 : srbg.Manufacturing_Base_Best_Guess__c);
                        MBH += (srbg.Manufacturing_Base_High__c == null ? 0 : srbg.Manufacturing_Base_High__c);
                        MBL += (srbg.Manufacturing_Base_Low__c == null ? 0 : srbg.Manufacturing_Base_Low__c);
                        MDBG += (srbg.Manufacturing_Digital_Best_Guess__c == null ? 0 : srbg.Manufacturing_Digital_Best_Guess__c);
                        MDH += (srbg.Manufacturing_Digital_High__c == null ? 0 : srbg.Manufacturing_Digital_High__c);
                        MDL += (srbg.Manufacturing_Digital_Low__c == null ? 0 : srbg.Manufacturing_Digital_Low__c);
                        MMBG += (srbg.Manufacturing_Mobile_Best_Guess__c == null ? 0 : srbg.Manufacturing_Mobile_Best_Guess__c);
                        MMH += (srbg.Manufacturing_Mobile_High__c == null ? 0 : srbg.Manufacturing_Mobile_High__c);
                        MML += (srbg.Manufacturing_Mobile_Low__c == null ? 0 : srbg.Manufacturing_Mobile_Low__c);
                        
                        RABG += (srbg.Retail_Audience_Best_Guess__c == null ? 0 : srbg.Retail_Audience_Best_Guess__c);
                        RAH += (srbg.Retail_Audience_High__c == null ? 0 : srbg.Retail_Audience_High__c);
                        RAL += (srbg.Retail_Audience_Low__c == null ? 0 : srbg.Retail_Audience_Low__c);
                        RBBG += (srbg.Retail_Base_Best_Guess__c == null ? 0 : srbg.Retail_Base_Best_Guess__c);
                        RBH += (srbg.Retail_Base_High__c == null ? 0 : srbg.Retail_Base_High__c);
                        RBL += (srbg.Retail_Base_Low__c == null ? 0 : srbg.Retail_Base_Low__c);
                        RDBG += (srbg.Retail_Digital_Best_Guess__c == null ? 0 : srbg.Retail_Digital_Best_Guess__c);
                        RDH += (srbg.Retail_Digital_High__c == null ? 0 : srbg.Retail_Digital_High__c);
                        RDL += (srbg.Retail_Digital_Low__c == null ? 0 : srbg.Retail_Digital_Low__c);
                        RMBG += (srbg.Retail_Mobile_Best_Guess__c == null ? 0 : srbg.Retail_Mobile_Best_Guess__c);
                        RMH += (srbg.Retail_Mobile_High__c == null ? 0 : srbg.Retail_Mobile_High__c);
                        RML += (srbg.Retail_Mobile_Low__c == null ? 0 : srbg.Retail_Mobile_Low__c);
                    }
                }
                
                for (Manager_Best_Guess__c child : mbgChild){
                    if (mbg.Id == child.Manager_Best_Guess__c){
                        if (child.Use_Override__c == true){
                            MABG += (child.Override_Team_Manu_Audience_Best_Guess__c == null ? 0 : child.Override_Team_Manu_Audience_Best_Guess__c);
                            MAH += (child.Override_Team_Manu_Audience_High__c == null ? 0 : child.Override_Team_Manu_Audience_High__c);
                            MAL += (child.Override_Team_Manu_Audience_Low__c == null ? 0 : child.Override_Team_Manu_Audience_Low__c);
                            MBBG += (child.Override_Team_Manu_Base_Best_Guess__c == null ? 0 : child.Override_Team_Manu_Base_Best_Guess__c);
                            MBH += (child.Override_Team_Manu_Base_High__c == null ? 0 : child.Override_Team_Manu_Base_High__c);
                            MBL += (child.Override_Team_Manu_Base_Low__c == null ? 0 : child.Override_Team_Manu_Base_Low__c);
                            MDBG += (child.Override_Team_Manu_Digital_Best_Guess__c == null ? 0 : child.Override_Team_Manu_Digital_Best_Guess__c);
                            MDH += (child.Override_Team_Manu_Digital_High__c == null ? 0 : child.Override_Team_Manu_Digital_High__c);
                            MDL += (child.Override_Team_Manu_Digital_Low__c == null ? 0 : child.Override_Team_Manu_Digital_Low__c);
                            MMBG += (child.Override_Team_Manu_Mobile_Best_Guess__c == null ? 0 : child.Override_Team_Manu_Mobile_Best_Guess__c);
                            MMH += (child.Override_Team_Manu_Mobile_High__c == null ? 0 : child.Override_Team_Manu_Mobile_High__c);
                            MML += (child.Override_Team_Manu_Mobile_Low__c == null ? 0 : child.Override_Team_Manu_Mobile_Low__c);
                            
                            RABG += (child.Override_Team_Retail_Audience_Best_Guess__c == null ? 0 : child.Override_Team_Retail_Audience_Best_Guess__c);
                            RAH += (child.Override_Team_Retail_Audience_High__c == null ? 0 : child.Override_Team_Retail_Audience_High__c);
                            RAL += (child.Override_Team_Retail_Audience_Low__c == null ? 0 : child.Override_Team_Retail_Audience_Low__c);
                            RBBG += (child.Override_Team_Retail_Base_Best_Guess__c == null ? 0 : child.Override_Team_Retail_Base_Best_Guess__c);
                            RBH += (child.Override_Team_Retail_Base_High__c == null ? 0 : child.Override_Team_Retail_Base_High__c);
                            RBL += (child.Override_Team_Retail_Base_Low__c == null ? 0 : child.Override_Team_Retail_Base_Low__c);
                            RDBG += (child.Override_Team_Retail_Digital_Best_Guess__c == null ? 0 : child.Override_Team_Retail_Digital_Best_Guess__c);
                            RDH += (child.Override_Team_Retail_Digital_High__c == null ? 0 : child.Override_Team_Retail_Digital_High__c);
                            RDL += (child.Override_Team_Retail_Digital_Low__c == null ? 0 : child.Override_Team_Retail_Digital_Low__c);
                            RMBG += (child.Override_Team_Retail_Mobile_Best_Guess__c == null ? 0 : child.Override_Team_Retail_Mobile_Best_Guess__c);
                            RMH += (child.Override_Team_Retail_Mobile_High__c == null ? 0 : child.Override_Team_Retail_Mobile_High__c);
                            RML += (child.Override_Team_Retail_Mobile_Low__c == null ? 0 : child.Override_Team_Retail_Mobile_Low__c);
                        } else {
                            MABG += child.Team_Manufacturing_Audience_Best_Guess__c;
                            MAH += child.Team_Manufacturing_Audience_High__c;
                            MAL += child.Team_Manufacturing_Audience_Low__c;
                            MBBG += child.Team_Manufacturing_Base_Best_Guess__c;
                            MBH += child.Team_Manufacturing_Base_High__c;
                            MBL += child.Team_Manufacturing_Base_Low__c;
                            MDBG += child.Team_Manufacturing_Digital_Best_Guess__c;
                            MDH += child.Team_Manufacturing_Digital_High__c;
                            MDL += child.Team_Manufacturing_Digital_Low__c;
                            MMBG += child.Team_Manufacturing_Mobile_Best_Guess__c;
                            MMH += child.Team_Manufacturing_Mobile_High__c;
                            MML += child.Team_Manufacturing_Mobile_Low__c;
                            
                            RABG += child.Team_Retail_Audience_Best_Guess__c;
                            RAH += child.Team_Retail_Audience_High__c;
                            RAL += child.Team_Retail_Audience_Low__c;
                            RBBG += child.Team_Retail_Base_Best_Guess__c;
                            RBH += child.Team_Retail_Base_High__c;
                            RBL += child.Team_Retail_Base_Low__c;
                            RDBG += child.Team_Retail_Digital_Best_Guess__c;
                            RDH += child.Team_Retail_Digital_High__c;
                            RDL += child.Team_Retail_Digital_Low__c;
                            RMBG += child.Team_Retail_Mobile_Best_Guess__c;
                            RMH += child.Team_Retail_Mobile_High__c;
                            RML += child.Team_Retail_Mobile_Low__c;
                        }
                    }
                }
                mbg.Team_Manufacturing_Audience_Best_Guess__c = MABG;
                mbg.Team_Manufacturing_Audience_High__c = MAH;
                mbg.Team_Manufacturing_Audience_Low__c = MAL;
                mbg.Team_Manufacturing_Base_Best_Guess__c = MBBG;
                mbg.Team_Manufacturing_Base_High__c = MBH;
                mbg.Team_Manufacturing_Base_Low__c = MBL;
                mbg.Team_Manufacturing_Digital_Best_Guess__c = MDBG;
                mbg.Team_Manufacturing_Digital_High__c = MDH;
                mbg.Team_Manufacturing_Digital_Low__c = MDL;
                mbg.Team_Manufacturing_Mobile_Best_Guess__c = MMBG;
                mbg.Team_Manufacturing_Mobile_High__c = MMH;
                mbg.Team_Manufacturing_Mobile_Low__c = MML;
                
                mbg.Team_Retail_Audience_Best_Guess__c = RABG;
                mbg.Team_Retail_Audience_High__c = RAH;
                mbg.Team_Retail_Audience_Low__c = RAL;
                mbg.Team_Retail_Base_Best_Guess__c = RBBG;
                mbg.Team_Retail_Base_High__c = RBH;
                mbg.Team_Retail_Base_Low__c = RBL;
                mbg.Team_Retail_Digital_Best_Guess__c = RDBG;
                mbg.Team_Retail_Digital_High__c = RDH;
                mbg.Team_Retail_Digital_Low__c = RDL;
                mbg.Team_Retail_Mobile_Best_Guess__c = RMBG;
                mbg.Team_Retail_Mobile_High__c = RMH;
                mbg.Team_Retail_Mobile_Low__c = RML;
                updateMBG.add(mbg);
            }
            
        }
        
        update updateMBG;
        updateMBG = new List<Manager_Best_Guess__c>();
        
        //rep 1
        
        srbgList = [SELECT ID, OWNERID, QUARTER__C, Manager__c, Manager_Best_Guess__c,
            Manufacturing_Base_Best_Guess__c, Manufacturing_Base_High__c, Manufacturing_Base_Low__c,
            Manufacturing_Digital_Best_Guess__c, Manufacturing_Digital_High__c, Manufacturing_Digital_Low__c,
            Manufacturing_Audience_Best_Guess__c, Manufacturing_Audience_High__c, Manufacturing_Audience_Low__c,
            Manufacturing_Mobile_Best_Guess__c, Manufacturing_Mobile_High__c, Manufacturing_Mobile_Low__c,
            Retail_Base_Best_Guess__c, Retail_Base_High__c, Retail_Base_Low__c,
            Retail_Digital_Best_Guess__c, Retail_Digital_High__c, Retail_Digital_Low__c,
            Retail_Audience_Best_Guess__c, Retail_Audience_High__c, Retail_Audience_Low__c,
            Retail_Mobile_Best_Guess__c, Retail_Mobile_High__c, Retail_Mobile_Low__c
            From Sales_Rep_Best_Guess__c WHERE YEAR__C =: yearInput];
        
        mbgList = [Select m.Team_Retail_Digital_Low__c, m.Team_Retail_Digital_High__c, m.Team_Retail_Digital_Best_Guess__c, 
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
        m.Team_Retail_Mobile_Best_Guess__c, m.Team_Retail_Mobile_High__c, m.Team_Retail_Mobile_Low__c, 
        m.Override_Team_Retail_Mobile_Low__c, m.Override_Team_Retail_Mobile_High__c, m.Override_Team_Retail_Mobile_Best_Guess__c,
        m.Override_Team_Retail_Digital_Low__c, m.Override_Team_Retail_Digital_High__c, m.Override_Team_Retail_Digital_Best_Guess__c,
        m.Override_Team_Retail_Base_Low__c, m.Override_Team_Retail_Base_High__c, m.Override_Team_Retail_Base_Best_Guess__c,
        m.Override_Team_Retail_Audience_Low__c, m.Override_Team_Retail_Audience_High__c, m.Override_Team_Retail_Audience_Best_Guess__c,
        m.Override_Team_Manu_Mobile_Low__c, m.Override_Team_Manu_Mobile_High__c, m.Override_Team_Manu_Mobile_Best_Guess__c,
        m.Override_Team_Manu_Digital_Low__c, m.Override_Team_Manu_Digital_High__c, m.Override_Team_Manu_Digital_Best_Guess__c,
        m.Override_Team_Manu_Base_Low__c, m.Override_Team_Manu_Base_High__c, m.Override_Team_Manu_Base_Best_Guess__c,
        m.Override_Team_Manu_Audience_Low__c, m.Override_Team_Manu_Audience_High__c, m.Override_Team_Manu_Audience_Best_Guess__c,
        Use_Override__c
        From Manager_Best_Guess__c m WHERE m.YEAR__C =: yearInput];
        
        mbgChild = [Select m.Team_Retail_Digital_Low__c, m.Team_Retail_Digital_High__c, m.Team_Retail_Digital_Best_Guess__c, 
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
        m.Team_Retail_Mobile_Best_Guess__c, m.Team_Retail_Mobile_High__c, m.Team_Retail_Mobile_Low__c, 
        m.Override_Team_Retail_Mobile_Low__c, m.Override_Team_Retail_Mobile_High__c, m.Override_Team_Retail_Mobile_Best_Guess__c,
        m.Override_Team_Retail_Digital_Low__c, m.Override_Team_Retail_Digital_High__c, m.Override_Team_Retail_Digital_Best_Guess__c,
        m.Override_Team_Retail_Base_Low__c, m.Override_Team_Retail_Base_High__c, m.Override_Team_Retail_Base_Best_Guess__c,
        m.Override_Team_Retail_Audience_Low__c, m.Override_Team_Retail_Audience_High__c, m.Override_Team_Retail_Audience_Best_Guess__c,
        m.Override_Team_Manu_Mobile_Low__c, m.Override_Team_Manu_Mobile_High__c, m.Override_Team_Manu_Mobile_Best_Guess__c,
        m.Override_Team_Manu_Digital_Low__c, m.Override_Team_Manu_Digital_High__c, m.Override_Team_Manu_Digital_Best_Guess__c,
        m.Override_Team_Manu_Base_Low__c, m.Override_Team_Manu_Base_High__c, m.Override_Team_Manu_Base_Best_Guess__c,
        m.Override_Team_Manu_Audience_Low__c, m.Override_Team_Manu_Audience_High__c, m.Override_Team_Manu_Audience_Best_Guess__c,
        Use_Override__c
        From Manager_Best_Guess__c m WHERE m.YEAR__C =: yearInput];

        //for each of the MBG records where the owner is a SR1, each field by looking at all of the child MBG and SRBGs
        for (Manager_Best_Guess__c mbg : mbgList){
            if (rep1Users.contains(mbg.OwnerId)){
                double MABG = 0;
                double MAL = 0;
                double MAH = 0;
                double MBBG = 0;
                double MBL = 0;
                double MBH = 0;
                double MDBG = 0;
                double MDL = 0;
                double MDH = 0;
                double MMBG = 0;
                double MML = 0;
                double MMH = 0;
                double RABG = 0;
                double RAL = 0;
                double RAH = 0;
                double RBBG = 0;
                double RBL = 0;
                double RBH = 0;
                double RDBG = 0;
                double RDL = 0;
                double RDH = 0;
                double RMBG = 0;
                double RML = 0;
                double RMH = 0;
                for (Sales_Rep_Best_Guess__c srbg : srbgList){
                    if (mbg.Id == srbg.Manager_Best_Guess__c){
                        MABG += (srbg.Manufacturing_Audience_Best_Guess__c == null ? 0 : srbg.Manufacturing_Audience_Best_Guess__c);
                        MAH += (srbg.Manufacturing_Audience_High__c == null ? 0 : srbg.Manufacturing_Audience_High__c);
                        MAL += (srbg.Manufacturing_Audience_Low__c == null ? 0 : srbg.Manufacturing_Audience_Low__c);
                        MBBG += (srbg.Manufacturing_Base_Best_Guess__c == null ? 0 : srbg.Manufacturing_Base_Best_Guess__c);
                        MBH += (srbg.Manufacturing_Base_High__c == null ? 0 : srbg.Manufacturing_Base_High__c);
                        MBL += (srbg.Manufacturing_Base_Low__c == null ? 0 : srbg.Manufacturing_Base_Low__c);
                        MDBG += (srbg.Manufacturing_Digital_Best_Guess__c == null ? 0 : srbg.Manufacturing_Digital_Best_Guess__c);
                        MDH += (srbg.Manufacturing_Digital_High__c == null ? 0 : srbg.Manufacturing_Digital_High__c);
                        MDL += (srbg.Manufacturing_Digital_Low__c == null ? 0 : srbg.Manufacturing_Digital_Low__c);
                        MMBG += (srbg.Manufacturing_Mobile_Best_Guess__c == null ? 0 : srbg.Manufacturing_Mobile_Best_Guess__c);
                        MMH += (srbg.Manufacturing_Mobile_High__c == null ? 0 : srbg.Manufacturing_Mobile_High__c);
                        MML += (srbg.Manufacturing_Mobile_Low__c == null ? 0 : srbg.Manufacturing_Mobile_Low__c);
                        
                        RABG += (srbg.Retail_Audience_Best_Guess__c == null ? 0 : srbg.Retail_Audience_Best_Guess__c);
                        RAH += (srbg.Retail_Audience_High__c == null ? 0 : srbg.Retail_Audience_High__c);
                        RAL += (srbg.Retail_Audience_Low__c == null ? 0 : srbg.Retail_Audience_Low__c);
                        RBBG += (srbg.Retail_Base_Best_Guess__c == null ? 0 : srbg.Retail_Base_Best_Guess__c);
                        RBH += (srbg.Retail_Base_High__c == null ? 0 : srbg.Retail_Base_High__c);
                        RBL += (srbg.Retail_Base_Low__c == null ? 0 : srbg.Retail_Base_Low__c);
                        RDBG += (srbg.Retail_Digital_Best_Guess__c == null ? 0 : srbg.Retail_Digital_Best_Guess__c);
                        RDH += (srbg.Retail_Digital_High__c == null ? 0 : srbg.Retail_Digital_High__c);
                        RDL += (srbg.Retail_Digital_Low__c == null ? 0 : srbg.Retail_Digital_Low__c);
                        RMBG += (srbg.Retail_Mobile_Best_Guess__c == null ? 0 : srbg.Retail_Mobile_Best_Guess__c);
                        RMH += (srbg.Retail_Mobile_High__c == null ? 0 : srbg.Retail_Mobile_High__c);
                        RML += (srbg.Retail_Mobile_Low__c == null ? 0 : srbg.Retail_Mobile_Low__c);
                    }
                }
                
                for (Manager_Best_Guess__c child : mbgChild){
                    if (mbg.Id == child.Manager_Best_Guess__c){
                        if (child.Use_Override__c == true){
                            MABG += (child.Override_Team_Manu_Audience_Best_Guess__c == null ? 0 : child.Override_Team_Manu_Audience_Best_Guess__c);
                            MAH += (child.Override_Team_Manu_Audience_High__c == null ? 0 : child.Override_Team_Manu_Audience_High__c);
                            MAL += (child.Override_Team_Manu_Audience_Low__c == null ? 0 : child.Override_Team_Manu_Audience_Low__c);
                            MBBG += (child.Override_Team_Manu_Base_Best_Guess__c == null ? 0 : child.Override_Team_Manu_Base_Best_Guess__c);
                            MBH += (child.Override_Team_Manu_Base_High__c == null ? 0 : child.Override_Team_Manu_Base_High__c);
                            MBL += (child.Override_Team_Manu_Base_Low__c == null ? 0 : child.Override_Team_Manu_Base_Low__c);
                            MDBG += (child.Override_Team_Manu_Digital_Best_Guess__c == null ? 0 : child.Override_Team_Manu_Digital_Best_Guess__c);
                            MDH += (child.Override_Team_Manu_Digital_High__c == null ? 0 : child.Override_Team_Manu_Digital_High__c);
                            MDL += (child.Override_Team_Manu_Digital_Low__c == null ? 0 : child.Override_Team_Manu_Digital_Low__c);
                            MMBG += (child.Override_Team_Manu_Mobile_Best_Guess__c == null ? 0 : child.Override_Team_Manu_Mobile_Best_Guess__c);
                            MMH += (child.Override_Team_Manu_Mobile_High__c == null ? 0 : child.Override_Team_Manu_Mobile_High__c);
                            MML += (child.Override_Team_Manu_Mobile_Low__c == null ? 0 : child.Override_Team_Manu_Mobile_Low__c);
                            
                            RABG += (child.Override_Team_Retail_Audience_Best_Guess__c == null ? 0 : child.Override_Team_Retail_Audience_Best_Guess__c);
                            RAH += (child.Override_Team_Retail_Audience_High__c == null ? 0 : child.Override_Team_Retail_Audience_High__c);
                            RAL += (child.Override_Team_Retail_Audience_Low__c == null ? 0 : child.Override_Team_Retail_Audience_Low__c);
                            RBBG += (child.Override_Team_Retail_Base_Best_Guess__c == null ? 0 : child.Override_Team_Retail_Base_Best_Guess__c);
                            RBH += (child.Override_Team_Retail_Base_High__c == null ? 0 : child.Override_Team_Retail_Base_High__c);
                            RBL += (child.Override_Team_Retail_Base_Low__c == null ? 0 : child.Override_Team_Retail_Base_Low__c);
                            RDBG += (child.Override_Team_Retail_Digital_Best_Guess__c == null ? 0 : child.Override_Team_Retail_Digital_Best_Guess__c);
                            RDH += (child.Override_Team_Retail_Digital_High__c == null ? 0 : child.Override_Team_Retail_Digital_High__c);
                            RDL += (child.Override_Team_Retail_Digital_Low__c == null ? 0 : child.Override_Team_Retail_Digital_Low__c);
                            RMBG += (child.Override_Team_Retail_Mobile_Best_Guess__c == null ? 0 : child.Override_Team_Retail_Mobile_Best_Guess__c);
                            RMH += (child.Override_Team_Retail_Mobile_High__c == null ? 0 : child.Override_Team_Retail_Mobile_High__c);
                            RML += (child.Override_Team_Retail_Mobile_Low__c == null ? 0 : child.Override_Team_Retail_Mobile_Low__c);
                        } else {
                            MABG += child.Team_Manufacturing_Audience_Best_Guess__c;
                            MAH += child.Team_Manufacturing_Audience_High__c;
                            MAL += child.Team_Manufacturing_Audience_Low__c;
                            MBBG += child.Team_Manufacturing_Base_Best_Guess__c;
                            MBH += child.Team_Manufacturing_Base_High__c;
                            MBL += child.Team_Manufacturing_Base_Low__c;
                            MDBG += child.Team_Manufacturing_Digital_Best_Guess__c;
                            MDH += child.Team_Manufacturing_Digital_High__c;
                            MDL += child.Team_Manufacturing_Digital_Low__c;
                            MMBG += child.Team_Manufacturing_Mobile_Best_Guess__c;
                            MMH += child.Team_Manufacturing_Mobile_High__c;
                            MML += child.Team_Manufacturing_Mobile_Low__c;
                            
                            RABG += child.Team_Retail_Audience_Best_Guess__c;
                            RAH += child.Team_Retail_Audience_High__c;
                            RAL += child.Team_Retail_Audience_Low__c;
                            RBBG += child.Team_Retail_Base_Best_Guess__c;
                            RBH += child.Team_Retail_Base_High__c;
                            RBL += child.Team_Retail_Base_Low__c;
                            RDBG += child.Team_Retail_Digital_Best_Guess__c;
                            RDH += child.Team_Retail_Digital_High__c;
                            RDL += child.Team_Retail_Digital_Low__c;
                            RMBG += child.Team_Retail_Mobile_Best_Guess__c;
                            RMH += child.Team_Retail_Mobile_High__c;
                            RML += child.Team_Retail_Mobile_Low__c;
                        }
                    }
                }
                mbg.Team_Manufacturing_Audience_Best_Guess__c = MABG;
                mbg.Team_Manufacturing_Audience_High__c = MAH;
                mbg.Team_Manufacturing_Audience_Low__c = MAL;
                mbg.Team_Manufacturing_Base_Best_Guess__c = MBBG;
                mbg.Team_Manufacturing_Base_High__c = MBH;
                mbg.Team_Manufacturing_Base_Low__c = MBL;
                mbg.Team_Manufacturing_Digital_Best_Guess__c = MDBG;
                mbg.Team_Manufacturing_Digital_High__c = MDH;
                mbg.Team_Manufacturing_Digital_Low__c = MDL;
                mbg.Team_Manufacturing_Mobile_Best_Guess__c = MMBG;
                mbg.Team_Manufacturing_Mobile_High__c = MMH;
                mbg.Team_Manufacturing_Mobile_Low__c = MML;
                
                mbg.Team_Retail_Audience_Best_Guess__c = RABG;
                mbg.Team_Retail_Audience_High__c = RAH;
                mbg.Team_Retail_Audience_Low__c = RAL;
                mbg.Team_Retail_Base_Best_Guess__c = RBBG;
                mbg.Team_Retail_Base_High__c = RBH;
                mbg.Team_Retail_Base_Low__c = RBL;
                mbg.Team_Retail_Digital_Best_Guess__c = RDBG;
                mbg.Team_Retail_Digital_High__c = RDH;
                mbg.Team_Retail_Digital_Low__c = RDL;
                mbg.Team_Retail_Mobile_Best_Guess__c = RMBG;
                mbg.Team_Retail_Mobile_High__c = RMH;
                mbg.Team_Retail_Mobile_Low__c = RML;
                updateMBG.add(mbg);
            }
            
        }
        
        update updateMBG;
        updateMBG = new List<Manager_Best_Guess__c>();
        
        //sm2
        
        srbgList = [SELECT ID, OWNERID, QUARTER__C, Manager__c, Manager_Best_Guess__c,
            Manufacturing_Base_Best_Guess__c, Manufacturing_Base_High__c, Manufacturing_Base_Low__c,
            Manufacturing_Digital_Best_Guess__c, Manufacturing_Digital_High__c, Manufacturing_Digital_Low__c,
            Manufacturing_Audience_Best_Guess__c, Manufacturing_Audience_High__c, Manufacturing_Audience_Low__c,
            Manufacturing_Mobile_Best_Guess__c, Manufacturing_Mobile_High__c, Manufacturing_Mobile_Low__c,
            Retail_Base_Best_Guess__c, Retail_Base_High__c, Retail_Base_Low__c,
            Retail_Digital_Best_Guess__c, Retail_Digital_High__c, Retail_Digital_Low__c,
            Retail_Audience_Best_Guess__c, Retail_Audience_High__c, Retail_Audience_Low__c,
            Retail_Mobile_Best_Guess__c, Retail_Mobile_High__c, Retail_Mobile_Low__c
            From Sales_Rep_Best_Guess__c WHERE YEAR__C =: yearInput];
        
        mbgList = [Select m.Team_Retail_Digital_Low__c, m.Team_Retail_Digital_High__c, m.Team_Retail_Digital_Best_Guess__c, 
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
        m.Team_Retail_Mobile_Best_Guess__c, m.Team_Retail_Mobile_High__c, m.Team_Retail_Mobile_Low__c, 
        m.Override_Team_Retail_Mobile_Low__c, m.Override_Team_Retail_Mobile_High__c, m.Override_Team_Retail_Mobile_Best_Guess__c,
        m.Override_Team_Retail_Digital_Low__c, m.Override_Team_Retail_Digital_High__c, m.Override_Team_Retail_Digital_Best_Guess__c,
        m.Override_Team_Retail_Base_Low__c, m.Override_Team_Retail_Base_High__c, m.Override_Team_Retail_Base_Best_Guess__c,
        m.Override_Team_Retail_Audience_Low__c, m.Override_Team_Retail_Audience_High__c, m.Override_Team_Retail_Audience_Best_Guess__c,
        m.Override_Team_Manu_Mobile_Low__c, m.Override_Team_Manu_Mobile_High__c, m.Override_Team_Manu_Mobile_Best_Guess__c,
        m.Override_Team_Manu_Digital_Low__c, m.Override_Team_Manu_Digital_High__c, m.Override_Team_Manu_Digital_Best_Guess__c,
        m.Override_Team_Manu_Base_Low__c, m.Override_Team_Manu_Base_High__c, m.Override_Team_Manu_Base_Best_Guess__c,
        m.Override_Team_Manu_Audience_Low__c, m.Override_Team_Manu_Audience_High__c, m.Override_Team_Manu_Audience_Best_Guess__c,
        Use_Override__c
        From Manager_Best_Guess__c m WHERE m.YEAR__C =: yearInput];
        
        mbgChild = [Select m.Team_Retail_Digital_Low__c, m.Team_Retail_Digital_High__c, m.Team_Retail_Digital_Best_Guess__c, 
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
        m.Team_Retail_Mobile_Best_Guess__c, m.Team_Retail_Mobile_High__c, m.Team_Retail_Mobile_Low__c, 
        m.Override_Team_Retail_Mobile_Low__c, m.Override_Team_Retail_Mobile_High__c, m.Override_Team_Retail_Mobile_Best_Guess__c,
        m.Override_Team_Retail_Digital_Low__c, m.Override_Team_Retail_Digital_High__c, m.Override_Team_Retail_Digital_Best_Guess__c,
        m.Override_Team_Retail_Base_Low__c, m.Override_Team_Retail_Base_High__c, m.Override_Team_Retail_Base_Best_Guess__c,
        m.Override_Team_Retail_Audience_Low__c, m.Override_Team_Retail_Audience_High__c, m.Override_Team_Retail_Audience_Best_Guess__c,
        m.Override_Team_Manu_Mobile_Low__c, m.Override_Team_Manu_Mobile_High__c, m.Override_Team_Manu_Mobile_Best_Guess__c,
        m.Override_Team_Manu_Digital_Low__c, m.Override_Team_Manu_Digital_High__c, m.Override_Team_Manu_Digital_Best_Guess__c,
        m.Override_Team_Manu_Base_Low__c, m.Override_Team_Manu_Base_High__c, m.Override_Team_Manu_Base_Best_Guess__c,
        m.Override_Team_Manu_Audience_Low__c, m.Override_Team_Manu_Audience_High__c, m.Override_Team_Manu_Audience_Best_Guess__c,
        Use_Override__c
        From Manager_Best_Guess__c m WHERE m.YEAR__C =: yearInput];

        //for each of the MBG records where the owner is a SM2, each field by looking at all of the child MBG and SRBGs
        for (Manager_Best_Guess__c mbg : mbgList){
            if (sm2Users.contains(mbg.OwnerId)){
                double MABG = 0;
                double MAL = 0;
                double MAH = 0;
                double MBBG = 0;
                double MBL = 0;
                double MBH = 0;
                double MDBG = 0;
                double MDL = 0;
                double MDH = 0;
                double MMBG = 0;
                double MML = 0;
                double MMH = 0;
                double RABG = 0;
                double RAL = 0;
                double RAH = 0;
                double RBBG = 0;
                double RBL = 0;
                double RBH = 0;
                double RDBG = 0;
                double RDL = 0;
                double RDH = 0;
                double RMBG = 0;
                double RML = 0;
                double RMH = 0;
                for (Sales_Rep_Best_Guess__c srbg : srbgList){
                    if (mbg.Id == srbg.Manager_Best_Guess__c){
                        MABG += (srbg.Manufacturing_Audience_Best_Guess__c == null ? 0 : srbg.Manufacturing_Audience_Best_Guess__c);
                        MAH += (srbg.Manufacturing_Audience_High__c == null ? 0 : srbg.Manufacturing_Audience_High__c);
                        MAL += (srbg.Manufacturing_Audience_Low__c == null ? 0 : srbg.Manufacturing_Audience_Low__c);
                        MBBG += (srbg.Manufacturing_Base_Best_Guess__c == null ? 0 : srbg.Manufacturing_Base_Best_Guess__c);
                        MBH += (srbg.Manufacturing_Base_High__c == null ? 0 : srbg.Manufacturing_Base_High__c);
                        MBL += (srbg.Manufacturing_Base_Low__c == null ? 0 : srbg.Manufacturing_Base_Low__c);
                        MDBG += (srbg.Manufacturing_Digital_Best_Guess__c == null ? 0 : srbg.Manufacturing_Digital_Best_Guess__c);
                        MDH += (srbg.Manufacturing_Digital_High__c == null ? 0 : srbg.Manufacturing_Digital_High__c);
                        MDL += (srbg.Manufacturing_Digital_Low__c == null ? 0 : srbg.Manufacturing_Digital_Low__c);
                        MMBG += (srbg.Manufacturing_Mobile_Best_Guess__c == null ? 0 : srbg.Manufacturing_Mobile_Best_Guess__c);
                        MMH += (srbg.Manufacturing_Mobile_High__c == null ? 0 : srbg.Manufacturing_Mobile_High__c);
                        MML += (srbg.Manufacturing_Mobile_Low__c == null ? 0 : srbg.Manufacturing_Mobile_Low__c);
                        
                        RABG += (srbg.Retail_Audience_Best_Guess__c == null ? 0 : srbg.Retail_Audience_Best_Guess__c);
                        RAH += (srbg.Retail_Audience_High__c == null ? 0 : srbg.Retail_Audience_High__c);
                        RAL += (srbg.Retail_Audience_Low__c == null ? 0 : srbg.Retail_Audience_Low__c);
                        RBBG += (srbg.Retail_Base_Best_Guess__c == null ? 0 : srbg.Retail_Base_Best_Guess__c);
                        RBH += (srbg.Retail_Base_High__c == null ? 0 : srbg.Retail_Base_High__c);
                        RBL += (srbg.Retail_Base_Low__c == null ? 0 : srbg.Retail_Base_Low__c);
                        RDBG += (srbg.Retail_Digital_Best_Guess__c == null ? 0 : srbg.Retail_Digital_Best_Guess__c);
                        RDH += (srbg.Retail_Digital_High__c == null ? 0 : srbg.Retail_Digital_High__c);
                        RDL += (srbg.Retail_Digital_Low__c == null ? 0 : srbg.Retail_Digital_Low__c);
                        RMBG += (srbg.Retail_Mobile_Best_Guess__c == null ? 0 : srbg.Retail_Mobile_Best_Guess__c);
                        RMH += (srbg.Retail_Mobile_High__c == null ? 0 : srbg.Retail_Mobile_High__c);
                        RML += (srbg.Retail_Mobile_Low__c == null ? 0 : srbg.Retail_Mobile_Low__c);
                    }
                }
                
                for (Manager_Best_Guess__c child : mbgChild){
                    if (mbg.Id == child.Manager_Best_Guess__c){
                        if (child.Use_Override__c == true){
                            MABG += (child.Override_Team_Manu_Audience_Best_Guess__c == null ? 0 : child.Override_Team_Manu_Audience_Best_Guess__c);
                            MAH += (child.Override_Team_Manu_Audience_High__c == null ? 0 : child.Override_Team_Manu_Audience_High__c);
                            MAL += (child.Override_Team_Manu_Audience_Low__c == null ? 0 : child.Override_Team_Manu_Audience_Low__c);
                            MBBG += (child.Override_Team_Manu_Base_Best_Guess__c == null ? 0 : child.Override_Team_Manu_Base_Best_Guess__c);
                            MBH += (child.Override_Team_Manu_Base_High__c == null ? 0 : child.Override_Team_Manu_Base_High__c);
                            MBL += (child.Override_Team_Manu_Base_Low__c == null ? 0 : child.Override_Team_Manu_Base_Low__c);
                            MDBG += (child.Override_Team_Manu_Digital_Best_Guess__c == null ? 0 : child.Override_Team_Manu_Digital_Best_Guess__c);
                            MDH += (child.Override_Team_Manu_Digital_High__c == null ? 0 : child.Override_Team_Manu_Digital_High__c);
                            MDL += (child.Override_Team_Manu_Digital_Low__c == null ? 0 : child.Override_Team_Manu_Digital_Low__c);
                            MMBG += (child.Override_Team_Manu_Mobile_Best_Guess__c == null ? 0 : child.Override_Team_Manu_Mobile_Best_Guess__c);
                            MMH += (child.Override_Team_Manu_Mobile_High__c == null ? 0 : child.Override_Team_Manu_Mobile_High__c);
                            MML += (child.Override_Team_Manu_Mobile_Low__c == null ? 0 : child.Override_Team_Manu_Mobile_Low__c);
                            
                            RABG += (child.Override_Team_Retail_Audience_Best_Guess__c == null ? 0 : child.Override_Team_Retail_Audience_Best_Guess__c);
                            RAH += (child.Override_Team_Retail_Audience_High__c == null ? 0 : child.Override_Team_Retail_Audience_High__c);
                            RAL += (child.Override_Team_Retail_Audience_Low__c == null ? 0 : child.Override_Team_Retail_Audience_Low__c);
                            RBBG += (child.Override_Team_Retail_Base_Best_Guess__c == null ? 0 : child.Override_Team_Retail_Base_Best_Guess__c);
                            RBH += (child.Override_Team_Retail_Base_High__c == null ? 0 : child.Override_Team_Retail_Base_High__c);
                            RBL += (child.Override_Team_Retail_Base_Low__c == null ? 0 : child.Override_Team_Retail_Base_Low__c);
                            RDBG += (child.Override_Team_Retail_Digital_Best_Guess__c == null ? 0 : child.Override_Team_Retail_Digital_Best_Guess__c);
                            RDH += (child.Override_Team_Retail_Digital_High__c == null ? 0 : child.Override_Team_Retail_Digital_High__c);
                            RDL += (child.Override_Team_Retail_Digital_Low__c == null ? 0 : child.Override_Team_Retail_Digital_Low__c);
                            RMBG += (child.Override_Team_Retail_Mobile_Best_Guess__c == null ? 0 : child.Override_Team_Retail_Mobile_Best_Guess__c);
                            RMH += (child.Override_Team_Retail_Mobile_High__c == null ? 0 : child.Override_Team_Retail_Mobile_High__c);
                            RML += (child.Override_Team_Retail_Mobile_Low__c == null ? 0 : child.Override_Team_Retail_Mobile_Low__c);
                        } else {
                            MABG += child.Team_Manufacturing_Audience_Best_Guess__c;
                            MAH += child.Team_Manufacturing_Audience_High__c;
                            MAL += child.Team_Manufacturing_Audience_Low__c;
                            MBBG += child.Team_Manufacturing_Base_Best_Guess__c;
                            MBH += child.Team_Manufacturing_Base_High__c;
                            MBL += child.Team_Manufacturing_Base_Low__c;
                            MDBG += child.Team_Manufacturing_Digital_Best_Guess__c;
                            MDH += child.Team_Manufacturing_Digital_High__c;
                            MDL += child.Team_Manufacturing_Digital_Low__c;
                            MMBG += child.Team_Manufacturing_Mobile_Best_Guess__c;
                            MMH += child.Team_Manufacturing_Mobile_High__c;
                            MML += child.Team_Manufacturing_Mobile_Low__c;
                            
                            RABG += child.Team_Retail_Audience_Best_Guess__c;
                            RAH += child.Team_Retail_Audience_High__c;
                            RAL += child.Team_Retail_Audience_Low__c;
                            RBBG += child.Team_Retail_Base_Best_Guess__c;
                            RBH += child.Team_Retail_Base_High__c;
                            RBL += child.Team_Retail_Base_Low__c;
                            RDBG += child.Team_Retail_Digital_Best_Guess__c;
                            RDH += child.Team_Retail_Digital_High__c;
                            RDL += child.Team_Retail_Digital_Low__c;
                            RMBG += child.Team_Retail_Mobile_Best_Guess__c;
                            RMH += child.Team_Retail_Mobile_High__c;
                            RML += child.Team_Retail_Mobile_Low__c;
                        }
                    }
                }
                mbg.Team_Manufacturing_Audience_Best_Guess__c = MABG;
                mbg.Team_Manufacturing_Audience_High__c = MAH;
                mbg.Team_Manufacturing_Audience_Low__c = MAL;
                mbg.Team_Manufacturing_Base_Best_Guess__c = MBBG;
                mbg.Team_Manufacturing_Base_High__c = MBH;
                mbg.Team_Manufacturing_Base_Low__c = MBL;
                mbg.Team_Manufacturing_Digital_Best_Guess__c = MDBG;
                mbg.Team_Manufacturing_Digital_High__c = MDH;
                mbg.Team_Manufacturing_Digital_Low__c = MDL;
                mbg.Team_Manufacturing_Mobile_Best_Guess__c = MMBG;
                mbg.Team_Manufacturing_Mobile_High__c = MMH;
                mbg.Team_Manufacturing_Mobile_Low__c = MML;
                
                mbg.Team_Retail_Audience_Best_Guess__c = RABG;
                mbg.Team_Retail_Audience_High__c = RAH;
                mbg.Team_Retail_Audience_Low__c = RAL;
                mbg.Team_Retail_Base_Best_Guess__c = RBBG;
                mbg.Team_Retail_Base_High__c = RBH;
                mbg.Team_Retail_Base_Low__c = RBL;
                mbg.Team_Retail_Digital_Best_Guess__c = RDBG;
                mbg.Team_Retail_Digital_High__c = RDH;
                mbg.Team_Retail_Digital_Low__c = RDL;
                mbg.Team_Retail_Mobile_Best_Guess__c = RMBG;
                mbg.Team_Retail_Mobile_High__c = RMH;
                mbg.Team_Retail_Mobile_Low__c = RML;
                updateMBG.add(mbg);
            }
        }
        
        update mbgList;
        updateMBG = new List<Manager_Best_Guess__c>();
        //sm1
        
        srbgList = [SELECT ID, OWNERID, QUARTER__C, Manager__c, Manager_Best_Guess__c,
            Manufacturing_Base_Best_Guess__c, Manufacturing_Base_High__c, Manufacturing_Base_Low__c,
            Manufacturing_Digital_Best_Guess__c, Manufacturing_Digital_High__c, Manufacturing_Digital_Low__c,
            Manufacturing_Audience_Best_Guess__c, Manufacturing_Audience_High__c, Manufacturing_Audience_Low__c,
            Manufacturing_Mobile_Best_Guess__c, Manufacturing_Mobile_High__c, Manufacturing_Mobile_Low__c,
            Retail_Base_Best_Guess__c, Retail_Base_High__c, Retail_Base_Low__c,
            Retail_Digital_Best_Guess__c, Retail_Digital_High__c, Retail_Digital_Low__c,
            Retail_Audience_Best_Guess__c, Retail_Audience_High__c, Retail_Audience_Low__c,
            Retail_Mobile_Best_Guess__c, Retail_Mobile_High__c, Retail_Mobile_Low__c
            From Sales_Rep_Best_Guess__c WHERE YEAR__C =: yearInput];
        
        mbgList = [Select m.Team_Retail_Digital_Low__c, m.Team_Retail_Digital_High__c, m.Team_Retail_Digital_Best_Guess__c, 
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
        m.Team_Retail_Mobile_Best_Guess__c, m.Team_Retail_Mobile_High__c, m.Team_Retail_Mobile_Low__c, 
        m.Override_Team_Retail_Mobile_Low__c, m.Override_Team_Retail_Mobile_High__c, m.Override_Team_Retail_Mobile_Best_Guess__c,
        m.Override_Team_Retail_Digital_Low__c, m.Override_Team_Retail_Digital_High__c, m.Override_Team_Retail_Digital_Best_Guess__c,
        m.Override_Team_Retail_Base_Low__c, m.Override_Team_Retail_Base_High__c, m.Override_Team_Retail_Base_Best_Guess__c,
        m.Override_Team_Retail_Audience_Low__c, m.Override_Team_Retail_Audience_High__c, m.Override_Team_Retail_Audience_Best_Guess__c,
        m.Override_Team_Manu_Mobile_Low__c, m.Override_Team_Manu_Mobile_High__c, m.Override_Team_Manu_Mobile_Best_Guess__c,
        m.Override_Team_Manu_Digital_Low__c, m.Override_Team_Manu_Digital_High__c, m.Override_Team_Manu_Digital_Best_Guess__c,
        m.Override_Team_Manu_Base_Low__c, m.Override_Team_Manu_Base_High__c, m.Override_Team_Manu_Base_Best_Guess__c,
        m.Override_Team_Manu_Audience_Low__c, m.Override_Team_Manu_Audience_High__c, m.Override_Team_Manu_Audience_Best_Guess__c,
        Use_Override__c
        From Manager_Best_Guess__c m WHERE m.YEAR__C =: yearInput];
        
        mbgChild = [Select m.Team_Retail_Digital_Low__c, m.Team_Retail_Digital_High__c, m.Team_Retail_Digital_Best_Guess__c, 
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
        m.Team_Retail_Mobile_Best_Guess__c, m.Team_Retail_Mobile_High__c, m.Team_Retail_Mobile_Low__c, 
        m.Override_Team_Retail_Mobile_Low__c, m.Override_Team_Retail_Mobile_High__c, m.Override_Team_Retail_Mobile_Best_Guess__c,
        m.Override_Team_Retail_Digital_Low__c, m.Override_Team_Retail_Digital_High__c, m.Override_Team_Retail_Digital_Best_Guess__c,
        m.Override_Team_Retail_Base_Low__c, m.Override_Team_Retail_Base_High__c, m.Override_Team_Retail_Base_Best_Guess__c,
        m.Override_Team_Retail_Audience_Low__c, m.Override_Team_Retail_Audience_High__c, m.Override_Team_Retail_Audience_Best_Guess__c,
        m.Override_Team_Manu_Mobile_Low__c, m.Override_Team_Manu_Mobile_High__c, m.Override_Team_Manu_Mobile_Best_Guess__c,
        m.Override_Team_Manu_Digital_Low__c, m.Override_Team_Manu_Digital_High__c, m.Override_Team_Manu_Digital_Best_Guess__c,
        m.Override_Team_Manu_Base_Low__c, m.Override_Team_Manu_Base_High__c, m.Override_Team_Manu_Base_Best_Guess__c,
        m.Override_Team_Manu_Audience_Low__c, m.Override_Team_Manu_Audience_High__c, m.Override_Team_Manu_Audience_Best_Guess__c,
        Use_Override__c
        From Manager_Best_Guess__c m WHERE m.YEAR__C =: yearInput];
        
        Set<Id> evpList = new Set<Id>();
        
        //for each of the MBG records where the owner is a SM1, each field by looking at all of the child MBG and SRBGs
        for (Manager_Best_Guess__c mbg : mbgList){
            if (sm1Users.contains(mbg.OwnerId)){
                if (mbg.Manager_Best_Guess__c != null) evpList.add(mbg.Manager_Best_Guess__c);
                double MABG = 0;
                double MAL = 0;
                double MAH = 0;
                double MBBG = 0;
                double MBL = 0;
                double MBH = 0;
                double MDBG = 0;
                double MDL = 0;
                double MDH = 0;
                double MMBG = 0;
                double MML = 0;
                double MMH = 0;
                double RABG = 0;
                double RAL = 0;
                double RAH = 0;
                double RBBG = 0;
                double RBL = 0;
                double RBH = 0;
                double RDBG = 0;
                double RDL = 0;
                double RDH = 0;
                double RMBG = 0;
                double RML = 0;
                double RMH = 0;
                for (Sales_Rep_Best_Guess__c srbg : srbgList){
                    if (mbg.Id == srbg.Manager_Best_Guess__c){
                        MABG += (srbg.Manufacturing_Audience_Best_Guess__c == null ? 0 : srbg.Manufacturing_Audience_Best_Guess__c);
                        MAH += (srbg.Manufacturing_Audience_High__c == null ? 0 : srbg.Manufacturing_Audience_High__c);
                        MAL += (srbg.Manufacturing_Audience_Low__c == null ? 0 : srbg.Manufacturing_Audience_Low__c);
                        MBBG += (srbg.Manufacturing_Base_Best_Guess__c == null ? 0 : srbg.Manufacturing_Base_Best_Guess__c);
                        MBH += (srbg.Manufacturing_Base_High__c == null ? 0 : srbg.Manufacturing_Base_High__c);
                        MBL += (srbg.Manufacturing_Base_Low__c == null ? 0 : srbg.Manufacturing_Base_Low__c);
                        MDBG += (srbg.Manufacturing_Digital_Best_Guess__c == null ? 0 : srbg.Manufacturing_Digital_Best_Guess__c);
                        MDH += (srbg.Manufacturing_Digital_High__c == null ? 0 : srbg.Manufacturing_Digital_High__c);
                        MDL += (srbg.Manufacturing_Digital_Low__c == null ? 0 : srbg.Manufacturing_Digital_Low__c);
                        MMBG += (srbg.Manufacturing_Mobile_Best_Guess__c == null ? 0 : srbg.Manufacturing_Mobile_Best_Guess__c);
                        MMH += (srbg.Manufacturing_Mobile_High__c == null ? 0 : srbg.Manufacturing_Mobile_High__c);
                        MML += (srbg.Manufacturing_Mobile_Low__c == null ? 0 : srbg.Manufacturing_Mobile_Low__c);
                        
                        RABG += (srbg.Retail_Audience_Best_Guess__c == null ? 0 : srbg.Retail_Audience_Best_Guess__c);
                        RAH += (srbg.Retail_Audience_High__c == null ? 0 : srbg.Retail_Audience_High__c);
                        RAL += (srbg.Retail_Audience_Low__c == null ? 0 : srbg.Retail_Audience_Low__c);
                        RBBG += (srbg.Retail_Base_Best_Guess__c == null ? 0 : srbg.Retail_Base_Best_Guess__c);
                        RBH += (srbg.Retail_Base_High__c == null ? 0 : srbg.Retail_Base_High__c);
                        RBL += (srbg.Retail_Base_Low__c == null ? 0 : srbg.Retail_Base_Low__c);
                        RDBG += (srbg.Retail_Digital_Best_Guess__c == null ? 0 : srbg.Retail_Digital_Best_Guess__c);
                        RDH += (srbg.Retail_Digital_High__c == null ? 0 : srbg.Retail_Digital_High__c);
                        RDL += (srbg.Retail_Digital_Low__c == null ? 0 : srbg.Retail_Digital_Low__c);
                        RMBG += (srbg.Retail_Mobile_Best_Guess__c == null ? 0 : srbg.Retail_Mobile_Best_Guess__c);
                        RMH += (srbg.Retail_Mobile_High__c == null ? 0 : srbg.Retail_Mobile_High__c);
                        RML += (srbg.Retail_Mobile_Low__c == null ? 0 : srbg.Retail_Mobile_Low__c);
                    }
                }
                
                for (Manager_Best_Guess__c child : mbgChild){
                    if (mbg.Id == child.Manager_Best_Guess__c){
                        if (child.Use_Override__c == true){
                            MABG += (child.Override_Team_Manu_Audience_Best_Guess__c == null ? 0 : child.Override_Team_Manu_Audience_Best_Guess__c);
                            MAH += (child.Override_Team_Manu_Audience_High__c == null ? 0 : child.Override_Team_Manu_Audience_High__c);
                            MAL += (child.Override_Team_Manu_Audience_Low__c == null ? 0 : child.Override_Team_Manu_Audience_Low__c);
                            MBBG += (child.Override_Team_Manu_Base_Best_Guess__c == null ? 0 : child.Override_Team_Manu_Base_Best_Guess__c);
                            MBH += (child.Override_Team_Manu_Base_High__c == null ? 0 : child.Override_Team_Manu_Base_High__c);
                            MBL += (child.Override_Team_Manu_Base_Low__c == null ? 0 : child.Override_Team_Manu_Base_Low__c);
                            MDBG += (child.Override_Team_Manu_Digital_Best_Guess__c == null ? 0 : child.Override_Team_Manu_Digital_Best_Guess__c);
                            MDH += (child.Override_Team_Manu_Digital_High__c == null ? 0 : child.Override_Team_Manu_Digital_High__c);
                            MDL += (child.Override_Team_Manu_Digital_Low__c == null ? 0 : child.Override_Team_Manu_Digital_Low__c);
                            MMBG += (child.Override_Team_Manu_Mobile_Best_Guess__c == null ? 0 : child.Override_Team_Manu_Mobile_Best_Guess__c);
                            MMH += (child.Override_Team_Manu_Mobile_High__c == null ? 0 : child.Override_Team_Manu_Mobile_High__c);
                            MML += (child.Override_Team_Manu_Mobile_Low__c == null ? 0 : child.Override_Team_Manu_Mobile_Low__c);
                            
                            RABG += (child.Override_Team_Retail_Audience_Best_Guess__c == null ? 0 : child.Override_Team_Retail_Audience_Best_Guess__c);
                            RAH += (child.Override_Team_Retail_Audience_High__c == null ? 0 : child.Override_Team_Retail_Audience_High__c);
                            RAL += (child.Override_Team_Retail_Audience_Low__c == null ? 0 : child.Override_Team_Retail_Audience_Low__c);
                            RBBG += (child.Override_Team_Retail_Base_Best_Guess__c == null ? 0 : child.Override_Team_Retail_Base_Best_Guess__c);
                            RBH += (child.Override_Team_Retail_Base_High__c == null ? 0 : child.Override_Team_Retail_Base_High__c);
                            RBL += (child.Override_Team_Retail_Base_Low__c == null ? 0 : child.Override_Team_Retail_Base_Low__c);
                            RDBG += (child.Override_Team_Retail_Digital_Best_Guess__c == null ? 0 : child.Override_Team_Retail_Digital_Best_Guess__c);
                            RDH += (child.Override_Team_Retail_Digital_High__c == null ? 0 : child.Override_Team_Retail_Digital_High__c);
                            RDL += (child.Override_Team_Retail_Digital_Low__c == null ? 0 : child.Override_Team_Retail_Digital_Low__c);
                            RMBG += (child.Override_Team_Retail_Mobile_Best_Guess__c == null ? 0 : child.Override_Team_Retail_Mobile_Best_Guess__c);
                            RMH += (child.Override_Team_Retail_Mobile_High__c == null ? 0 : child.Override_Team_Retail_Mobile_High__c);
                            RML += (child.Override_Team_Retail_Mobile_Low__c == null ? 0 : child.Override_Team_Retail_Mobile_Low__c);
                        } else {
                            MABG += child.Team_Manufacturing_Audience_Best_Guess__c;
                            MAH += child.Team_Manufacturing_Audience_High__c;
                            MAL += child.Team_Manufacturing_Audience_Low__c;
                            MBBG += child.Team_Manufacturing_Base_Best_Guess__c;
                            MBH += child.Team_Manufacturing_Base_High__c;
                            MBL += child.Team_Manufacturing_Base_Low__c;
                            MDBG += child.Team_Manufacturing_Digital_Best_Guess__c;
                            MDH += child.Team_Manufacturing_Digital_High__c;
                            MDL += child.Team_Manufacturing_Digital_Low__c;
                            MMBG += child.Team_Manufacturing_Mobile_Best_Guess__c;
                            MMH += child.Team_Manufacturing_Mobile_High__c;
                            MML += child.Team_Manufacturing_Mobile_Low__c;
                            
                            RABG += child.Team_Retail_Audience_Best_Guess__c;
                            RAH += child.Team_Retail_Audience_High__c;
                            RAL += child.Team_Retail_Audience_Low__c;
                            RBBG += child.Team_Retail_Base_Best_Guess__c;
                            RBH += child.Team_Retail_Base_High__c;
                            RBL += child.Team_Retail_Base_Low__c;
                            RDBG += child.Team_Retail_Digital_Best_Guess__c;
                            RDH += child.Team_Retail_Digital_High__c;
                            RDL += child.Team_Retail_Digital_Low__c;
                            RMBG += child.Team_Retail_Mobile_Best_Guess__c;
                            RMH += child.Team_Retail_Mobile_High__c;
                            RML += child.Team_Retail_Mobile_Low__c;
                        }
                    }
                }
                mbg.Team_Manufacturing_Audience_Best_Guess__c = MABG;
                mbg.Team_Manufacturing_Audience_High__c = MAH;
                mbg.Team_Manufacturing_Audience_Low__c = MAL;
                mbg.Team_Manufacturing_Base_Best_Guess__c = MBBG;
                mbg.Team_Manufacturing_Base_High__c = MBH;
                mbg.Team_Manufacturing_Base_Low__c = MBL;
                mbg.Team_Manufacturing_Digital_Best_Guess__c = MDBG;
                mbg.Team_Manufacturing_Digital_High__c = MDH;
                mbg.Team_Manufacturing_Digital_Low__c = MDL;
                mbg.Team_Manufacturing_Mobile_Best_Guess__c = MMBG;
                mbg.Team_Manufacturing_Mobile_High__c = MMH;
                mbg.Team_Manufacturing_Mobile_Low__c = MML;
                
                mbg.Team_Retail_Audience_Best_Guess__c = RABG;
                mbg.Team_Retail_Audience_High__c = RAH;
                mbg.Team_Retail_Audience_Low__c = RAL;
                mbg.Team_Retail_Base_Best_Guess__c = RBBG;
                mbg.Team_Retail_Base_High__c = RBH;
                mbg.Team_Retail_Base_Low__c = RBL;
                mbg.Team_Retail_Digital_Best_Guess__c = RDBG;
                mbg.Team_Retail_Digital_High__c = RDH;
                mbg.Team_Retail_Digital_Low__c = RDL;
                mbg.Team_Retail_Mobile_Best_Guess__c = RMBG;
                mbg.Team_Retail_Mobile_High__c = RMH;
                mbg.Team_Retail_Mobile_Low__c = RML;
                updateMBG.add(mbg);
            }
        }
        
        update mbgList;
        updateMBG = new List<Manager_Best_Guess__c>();
        
        //call rollupMBG() to calculate the remaining higher BG levels
        if (evpList.size() > 0){
            Set<Id> newMBGSet = evpList;
            while (newMBGSet.size() > 0){
                Set<Id> tempSet = rollupMBG(newMBGSet);
                newMBGSet = tempSet;
            }
            
        }
        BatchGovernorLimitUtility.calcualteLimits(Limits.getCpuTime(), Limits.getDMLRows(), Limits.getDMLStatements(), Limits.getHeapSize(), Limits.getQueries(), Limits.getQueryRows(), Limits.getScriptStatements(), scope, currentTime, System.now());
            
    }
    
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
            BatchRecalculateBestGuess acctBatch2Sched = new BatchRecalculateBestGuess(year2);
            //Schedule the next job, and give it the system time so name is unique
            System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
        } else if (yearInput == String.valueOf(Date.today().year())){
            String year2 = String.valueOf(Date.today().year() + 1);
            BatchRecalculateBestGuess acctBatch2Sched = new BatchRecalculateBestGuess(year2);
            //Schedule the next job, and give it the system time so name is unique
            System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
        } else {
            //changed at April 14, 2013 to avoid salesforce error Warren
            //BatchCreateProgramAmount acctBatch2Sched = new BatchCreateProgramAmount();
            //BatchCreateRepForecast acctBatch2Sched = new BatchCreateRepForecast();
            //BatchCreateProgramAmountCOPY acctBatch2Sched = new BatchCreateProgramAmountCOPY();
            BatchCalculateBestGuessPFM acctBatch2Sched = new BatchCalculateBestGuessPFM();
            //Schedule the next job, and give it the system time so name is unique
            System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
        }
        BatchGovernorLimitUtility.updateBatchRun();
    }
    
    /*
    @Name:          rollupMBG
    @Description:   accepts a set of IDs representing the BG records to be recalculated
                    returns a set of IDs of other BG records to be recalculated
                        -specifically the records that the parameter records roll in to
    */
    private Set<Id> rollupMBG(Set<Id> mbgSet1){
        List<Manager_Best_Guess__c> mbgList = [Select m.Team_Retail_Digital_Low__c, m.Team_Retail_Digital_High__c, m.Team_Retail_Digital_Best_Guess__c, 
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
        m.Team_Retail_Mobile_Best_Guess__c, m.Team_Retail_Mobile_High__c, m.Team_Retail_Mobile_Low__c,
        m.Override_Team_Retail_Mobile_Low__c, m.Override_Team_Retail_Mobile_High__c, m.Override_Team_Retail_Mobile_Best_Guess__c,
        m.Override_Team_Retail_Digital_Low__c, m.Override_Team_Retail_Digital_High__c, m.Override_Team_Retail_Digital_Best_Guess__c,
        m.Override_Team_Retail_Base_Low__c, m.Override_Team_Retail_Base_High__c, m.Override_Team_Retail_Base_Best_Guess__c,
        m.Override_Team_Retail_Audience_Low__c, m.Override_Team_Retail_Audience_High__c, m.Override_Team_Retail_Audience_Best_Guess__c,
        m.Override_Team_Manu_Mobile_Low__c, m.Override_Team_Manu_Mobile_High__c, m.Override_Team_Manu_Mobile_Best_Guess__c,
        m.Override_Team_Manu_Digital_Low__c, m.Override_Team_Manu_Digital_High__c, m.Override_Team_Manu_Digital_Best_Guess__c,
        m.Override_Team_Manu_Base_Low__c, m.Override_Team_Manu_Base_High__c, m.Override_Team_Manu_Base_Best_Guess__c,
        m.Override_Team_Manu_Audience_Low__c, m.Override_Team_Manu_Audience_High__c, m.Override_Team_Manu_Audience_Best_Guess__c,
        Use_Override__c
        From Manager_Best_Guess__c m
        Where Id In :mbgSet1 AND m.YEAR__C =: yearInput];
        
        List<Sales_Rep_Best_Guess__c> srbgList = [SELECT ID, OWNERID, QUARTER__C, Manager__c, Manager_Best_Guess__c,
            Manufacturing_Base_Best_Guess__c, Manufacturing_Base_High__c, Manufacturing_Base_Low__c,
            Manufacturing_Digital_Best_Guess__c, Manufacturing_Digital_High__c, Manufacturing_Digital_Low__c,
            Manufacturing_Audience_Best_Guess__c, Manufacturing_Audience_High__c, Manufacturing_Audience_Low__c,
            Manufacturing_Mobile_Best_Guess__c, Manufacturing_Mobile_High__c, Manufacturing_Mobile_Low__c,
            Retail_Base_Best_Guess__c, Retail_Base_High__c, Retail_Base_Low__c,
            Retail_Digital_Best_Guess__c, Retail_Digital_High__c, Retail_Digital_Low__c,
            Retail_Audience_Best_Guess__c, Retail_Audience_High__c, Retail_Audience_Low__c,
            Retail_Mobile_Best_Guess__c, Retail_Mobile_High__c, Retail_Mobile_Low__c
            From Sales_Rep_Best_Guess__c WHERE YEAR__C =: yearInput];
        
        List<Manager_Best_Guess__c> mbgChild = [Select m.Team_Retail_Digital_Low__c, m.Team_Retail_Digital_High__c, m.Team_Retail_Digital_Best_Guess__c, 
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
        m.Team_Retail_Mobile_Best_Guess__c, m.Team_Retail_Mobile_High__c, m.Team_Retail_Mobile_Low__c,
        m.Override_Team_Retail_Mobile_Low__c, m.Override_Team_Retail_Mobile_High__c, m.Override_Team_Retail_Mobile_Best_Guess__c,
        m.Override_Team_Retail_Digital_Low__c, m.Override_Team_Retail_Digital_High__c, m.Override_Team_Retail_Digital_Best_Guess__c,
        m.Override_Team_Retail_Base_Low__c, m.Override_Team_Retail_Base_High__c, m.Override_Team_Retail_Base_Best_Guess__c,
        m.Override_Team_Retail_Audience_Low__c, m.Override_Team_Retail_Audience_High__c, m.Override_Team_Retail_Audience_Best_Guess__c,
        m.Override_Team_Manu_Mobile_Low__c, m.Override_Team_Manu_Mobile_High__c, m.Override_Team_Manu_Mobile_Best_Guess__c,
        m.Override_Team_Manu_Digital_Low__c, m.Override_Team_Manu_Digital_High__c, m.Override_Team_Manu_Digital_Best_Guess__c,
        m.Override_Team_Manu_Base_Low__c, m.Override_Team_Manu_Base_High__c, m.Override_Team_Manu_Base_Best_Guess__c,
        m.Override_Team_Manu_Audience_Low__c, m.Override_Team_Manu_Audience_High__c, m.Override_Team_Manu_Audience_Best_Guess__c,
        Use_Override__c
        From Manager_Best_Guess__c m WHERE m.YEAR__C =: yearInput];
        
        Set<Id> mbgSet = new Set<Id>();
        
        for (Manager_Best_Guess__c mbg : mbgList){
            if (mbg.Manager_Best_Guess__c != null) mbgSet.add(mbg.Manager_Best_Guess__c);
            double MABG = 0;
            double MAL = 0;
            double MAH = 0;
            double MBBG = 0;
            double MBL = 0;
            double MBH = 0;
            double MDBG = 0;
            double MDL = 0;
            double MDH = 0;
            double MMBG = 0;
            double MML = 0;
            double MMH = 0;
            double RABG = 0;
            double RAL = 0;
            double RAH = 0;
            double RBBG = 0;
            double RBL = 0;
            double RBH = 0;
            double RDBG = 0;
            double RDL = 0;
            double RDH = 0;
            double RMBG = 0;
            double RML = 0;
            double RMH = 0;
            for (Sales_Rep_Best_Guess__c srbg : srbgList){
                    if (mbg.Id == srbg.Manager_Best_Guess__c){
                        MABG += (srbg.Manufacturing_Audience_Best_Guess__c == null ? 0 : srbg.Manufacturing_Audience_Best_Guess__c);
                        MAH += (srbg.Manufacturing_Audience_High__c == null ? 0 : srbg.Manufacturing_Audience_High__c);
                        MAL += (srbg.Manufacturing_Audience_Low__c == null ? 0 : srbg.Manufacturing_Audience_Low__c);
                        MBBG += (srbg.Manufacturing_Base_Best_Guess__c == null ? 0 : srbg.Manufacturing_Base_Best_Guess__c);
                        MBH += (srbg.Manufacturing_Base_High__c == null ? 0 : srbg.Manufacturing_Base_High__c);
                        MBL += (srbg.Manufacturing_Base_Low__c == null ? 0 : srbg.Manufacturing_Base_Low__c);
                        MDBG += (srbg.Manufacturing_Digital_Best_Guess__c == null ? 0 : srbg.Manufacturing_Digital_Best_Guess__c);
                        MDH += (srbg.Manufacturing_Digital_High__c == null ? 0 : srbg.Manufacturing_Digital_High__c);
                        MDL += (srbg.Manufacturing_Digital_Low__c == null ? 0 : srbg.Manufacturing_Digital_Low__c);
                        MMBG += (srbg.Manufacturing_Mobile_Best_Guess__c == null ? 0 : srbg.Manufacturing_Mobile_Best_Guess__c);
                        MMH += (srbg.Manufacturing_Mobile_High__c == null ? 0 : srbg.Manufacturing_Mobile_High__c);
                        MML += (srbg.Manufacturing_Mobile_Low__c == null ? 0 : srbg.Manufacturing_Mobile_Low__c);
                        
                        RABG += (srbg.Retail_Audience_Best_Guess__c == null ? 0 : srbg.Retail_Audience_Best_Guess__c);
                        RAH += (srbg.Retail_Audience_High__c == null ? 0 : srbg.Retail_Audience_High__c);
                        RAL += (srbg.Retail_Audience_Low__c == null ? 0 : srbg.Retail_Audience_Low__c);
                        RBBG += (srbg.Retail_Base_Best_Guess__c == null ? 0 : srbg.Retail_Base_Best_Guess__c);
                        RBH += (srbg.Retail_Base_High__c == null ? 0 : srbg.Retail_Base_High__c);
                        RBL += (srbg.Retail_Base_Low__c == null ? 0 : srbg.Retail_Base_Low__c);
                        RDBG += (srbg.Retail_Digital_Best_Guess__c == null ? 0 : srbg.Retail_Digital_Best_Guess__c);
                        RDH += (srbg.Retail_Digital_High__c == null ? 0 : srbg.Retail_Digital_High__c);
                        RDL += (srbg.Retail_Digital_Low__c == null ? 0 : srbg.Retail_Digital_Low__c);
                        RMBG += (srbg.Retail_Mobile_Best_Guess__c == null ? 0 : srbg.Retail_Mobile_Best_Guess__c);
                        RMH += (srbg.Retail_Mobile_High__c == null ? 0 : srbg.Retail_Mobile_High__c);
                        RML += (srbg.Retail_Mobile_Low__c == null ? 0 : srbg.Retail_Mobile_Low__c);
                    }
                }
            
            for (Manager_Best_Guess__c child : mbgChild){
                if (mbg.Id == child.Manager_Best_Guess__c){
                    if (child.Use_Override__c == true){
                        MABG += (child.Override_Team_Manu_Audience_Best_Guess__c == null ? 0 : child.Override_Team_Manu_Audience_Best_Guess__c);
                        MAH += (child.Override_Team_Manu_Audience_High__c == null ? 0 : child.Override_Team_Manu_Audience_High__c);
                        MAL += (child.Override_Team_Manu_Audience_Low__c == null ? 0 : child.Override_Team_Manu_Audience_Low__c);
                        MBBG += (child.Override_Team_Manu_Base_Best_Guess__c == null ? 0 : child.Override_Team_Manu_Base_Best_Guess__c);
                        MBH += (child.Override_Team_Manu_Base_High__c == null ? 0 : child.Override_Team_Manu_Base_High__c);
                        MBL += (child.Override_Team_Manu_Base_Low__c == null ? 0 : child.Override_Team_Manu_Base_Low__c);
                        MDBG += (child.Override_Team_Manu_Digital_Best_Guess__c == null ? 0 : child.Override_Team_Manu_Digital_Best_Guess__c);
                        MDH += (child.Override_Team_Manu_Digital_High__c == null ? 0 : child.Override_Team_Manu_Digital_High__c);
                        MDL += (child.Override_Team_Manu_Digital_Low__c == null ? 0 : child.Override_Team_Manu_Digital_Low__c);
                        MMBG += (child.Override_Team_Manu_Mobile_Best_Guess__c == null ? 0 : child.Override_Team_Manu_Mobile_Best_Guess__c);
                        MMH += (child.Override_Team_Manu_Mobile_High__c == null ? 0 : child.Override_Team_Manu_Mobile_High__c);
                        MML += (child.Override_Team_Manu_Mobile_Low__c == null ? 0 : child.Override_Team_Manu_Mobile_Low__c);
                        
                        RABG += (child.Override_Team_Retail_Audience_Best_Guess__c == null ? 0 : child.Override_Team_Retail_Audience_Best_Guess__c);
                        RAH += (child.Override_Team_Retail_Audience_High__c == null ? 0 : child.Override_Team_Retail_Audience_High__c);
                        RAL += (child.Override_Team_Retail_Audience_Low__c == null ? 0 : child.Override_Team_Retail_Audience_Low__c);
                        RBBG += (child.Override_Team_Retail_Base_Best_Guess__c == null ? 0 : child.Override_Team_Retail_Base_Best_Guess__c);
                        RBH += (child.Override_Team_Retail_Base_High__c == null ? 0 : child.Override_Team_Retail_Base_High__c);
                        RBL += (child.Override_Team_Retail_Base_Low__c == null ? 0 : child.Override_Team_Retail_Base_Low__c);
                        RDBG += (child.Override_Team_Retail_Digital_Best_Guess__c == null ? 0 : child.Override_Team_Retail_Digital_Best_Guess__c);
                        RDH += (child.Override_Team_Retail_Digital_High__c == null ? 0 : child.Override_Team_Retail_Digital_High__c);
                        RDL += (child.Override_Team_Retail_Digital_Low__c == null ? 0 : child.Override_Team_Retail_Digital_Low__c);
                        RMBG += (child.Override_Team_Retail_Mobile_Best_Guess__c == null ? 0 : child.Override_Team_Retail_Mobile_Best_Guess__c);
                        RMH += (child.Override_Team_Retail_Mobile_High__c == null ? 0 : child.Override_Team_Retail_Mobile_High__c);
                        RML += (child.Override_Team_Retail_Mobile_Low__c == null ? 0 : child.Override_Team_Retail_Mobile_Low__c);
                    } else {
                        MABG += child.Team_Manufacturing_Audience_Best_Guess__c;
                        MAH += child.Team_Manufacturing_Audience_High__c;
                        MAL += child.Team_Manufacturing_Audience_Low__c;
                        MBBG += child.Team_Manufacturing_Base_Best_Guess__c;
                        MBH += child.Team_Manufacturing_Base_High__c;
                        MBL += child.Team_Manufacturing_Base_Low__c;
                        MDBG += child.Team_Manufacturing_Digital_Best_Guess__c;
                        MDH += child.Team_Manufacturing_Digital_High__c;
                        MDL += child.Team_Manufacturing_Digital_Low__c;
                        MMBG += child.Team_Manufacturing_Mobile_Best_Guess__c;
                        MMH += child.Team_Manufacturing_Mobile_High__c;
                        MML += child.Team_Manufacturing_Mobile_Low__c;
                        
                        RABG += child.Team_Retail_Audience_Best_Guess__c;
                        RAH += child.Team_Retail_Audience_High__c;
                        RAL += child.Team_Retail_Audience_Low__c;
                        RBBG += child.Team_Retail_Base_Best_Guess__c;
                        RBH += child.Team_Retail_Base_High__c;
                        RBL += child.Team_Retail_Base_Low__c;
                        RDBG += child.Team_Retail_Digital_Best_Guess__c;
                        RDH += child.Team_Retail_Digital_High__c;
                        RDL += child.Team_Retail_Digital_Low__c;
                        RMBG += child.Team_Retail_Mobile_Best_Guess__c;
                        RMH += child.Team_Retail_Mobile_High__c;
                        RML += child.Team_Retail_Mobile_Low__c;
                    }
                }
            }
            mbg.Team_Manufacturing_Audience_Best_Guess__c = MABG;
            mbg.Team_Manufacturing_Audience_High__c = MAH;
            mbg.Team_Manufacturing_Audience_Low__c = MAL;
            mbg.Team_Manufacturing_Base_Best_Guess__c = MBBG;
            mbg.Team_Manufacturing_Base_High__c = MBH;
            mbg.Team_Manufacturing_Base_Low__c = MBL;
            mbg.Team_Manufacturing_Digital_Best_Guess__c = MDBG;
            mbg.Team_Manufacturing_Digital_High__c = MDH;
            mbg.Team_Manufacturing_Digital_Low__c = MDL;
            mbg.Team_Manufacturing_Mobile_Best_Guess__c = MMBG;
            mbg.Team_Manufacturing_Mobile_High__c = MMH;
            mbg.Team_Manufacturing_Mobile_Low__c = MML;
            
            mbg.Team_Retail_Audience_Best_Guess__c = RABG;
            mbg.Team_Retail_Audience_High__c = RAH;
            mbg.Team_Retail_Audience_Low__c = RAL;
            mbg.Team_Retail_Base_Best_Guess__c = RBBG;
            mbg.Team_Retail_Base_High__c = RBH;
            mbg.Team_Retail_Base_Low__c = RBL;
            mbg.Team_Retail_Digital_Best_Guess__c = RDBG;
            mbg.Team_Retail_Digital_High__c = RDH;
            mbg.Team_Retail_Digital_Low__c = RDL;
            mbg.Team_Retail_Mobile_Best_Guess__c = RMBG;
            mbg.Team_Retail_Mobile_High__c = RMH;
            mbg.Team_Retail_Mobile_Low__c = RML;
        }
        
        update mbgList;
        
        return mbgSet;
        
    }

}