trigger UpdateManagerBestGuess on Manager_Best_Guess__c (after update) {
    
    Set<Id> toUpdate = new Set<Id>();
    Map<Id, List<Manager_Best_Guess__c>> mbgMap = new Map<Id, List<Manager_Best_Guess__c>>();
    Map<Id, List<Sales_Rep_Best_Guess__c>> repBGMap = new Map<Id, List<Sales_Rep_Best_Guess__c>>();
    Map<Id, Manager_Best_Guess__c> newValues = new Map<Id, Manager_Best_Guess__c>(); 
    
    system.debug('***get parent IDs that need updating, set overrides, and store in map');
    for (Manager_Best_Guess__c a : Trigger.new){
        if (a.Manager_Best_Guess__c != null){
            toUpdate.add(a.Manager_Best_Guess__c);
        }
    }
 
    system.debug('***get parent records that need updating');
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
        From Manager_Best_Guess__c m
        Where Id In :toUpdate];
        
    for (Manager_Best_Guess__c a : parent){
        if (a.Team_M_A_Booked_Actual__c == null) a.Team_M_A_Booked_Actual__c = 0; 
        if (a.Team_M_A_Booked_Full_Proposal__c == null) a.Team_M_A_Booked_Full_Proposal__c = 0; 
        if (a.Team_M_A_Booked_Proposal__c == null) a.Team_M_A_Booked_Proposal__c = 0;
        if (a.Team_M_B_Booked_Actual__c == null) a.Team_M_B_Booked_Actual__c = 0; 
        if (a.Team_M_B_Booked_Full_Proposal__c == null) a.Team_M_B_Booked_Full_Proposal__c = 0; 
        if (a.Team_M_B_Booked_Proposal__c == null) a.Team_M_B_Booked_Proposal__c = 0;
        if (a.Team_M_D_Booked_Actual__c == null) a.Team_M_D_Booked_Actual__c = 0; 
        if (a.Team_M_D_Booked_Full_Proposal__c == null) a.Team_M_D_Booked_Full_Proposal__c = 0; 
        if (a.Team_M_D_Booked_Proposal__c == null) a.Team_M_D_Booked_Proposal__c = 0;
        if (a.Team_M_M_Booked_Actual__c == null) a.Team_M_M_Booked_Actual__c = 0; 
        if (a.Team_M_M_Booked_Full_Proposal__c == null) a.Team_M_M_Booked_Full_Proposal__c = 0; 
        if (a.Team_M_M_Booked_Proposal__c == null) a.Team_M_M_Booked_Proposal__c = 0;
        if (a.Team_R_A_Booked_Actual__c == null) a.Team_R_A_Booked_Actual__c = 0; 
        if (a.Team_R_A_Booked_Full_Proposal__c == null) a.Team_R_A_Booked_Full_Proposal__c = 0; 
        if (a.Team_R_A_Booked_Proposal__c == null) a.Team_R_A_Booked_Proposal__c = 0;
        if (a.Team_R_B_Booked_Actual__c == null) a.Team_R_B_Booked_Actual__c = 0; 
        if (a.Team_R_B_Booked_Full_Proposal__c == null) a.Team_R_B_Booked_Full_Proposal__c = 0; 
        if (a.Team_R_B_Booked_Proposal__c == null) a.Team_R_B_Booked_Proposal__c = 0;
        if (a.Team_R_D_Booked_Actual__c == null) a.Team_R_D_Booked_Actual__c = 0; 
        if (a.Team_R_D_Booked_Full_Proposal__c == null) a.Team_R_D_Booked_Full_Proposal__c = 0; 
        if (a.Team_R_D_Booked_Proposal__c == null) a.Team_R_D_Booked_Proposal__c = 0;
        if (a.Team_R_M_Booked_Actual__c == null) a.Team_R_M_Booked_Actual__c = 0; 
        if (a.Team_R_M_Booked_Full_Proposal__c == null) a.Team_R_M_Booked_Full_Proposal__c = 0; 
        if (a.Team_R_M_Booked_Proposal__c == null) a.Team_R_M_Booked_Proposal__c = 0;
        
        if (a.Team_Manufacturing_Audience_Best_Guess__c == null) a.Team_Manufacturing_Audience_Best_Guess__c = 0;
        if (a.Team_Manufacturing_Audience_High__c == null) a.Team_Manufacturing_Audience_High__c = 0;
        if (a.Team_Manufacturing_Audience_Low__c == null) a.Team_Manufacturing_Audience_Low__c = 0;
        if (a.Team_Manufacturing_Mobile_Best_Guess__c == null) a.Team_Manufacturing_Mobile_Best_Guess__c = 0;
        if (a.Team_Manufacturing_Mobile_High__c == null) a.Team_Manufacturing_Mobile_High__c = 0;
        if (a.Team_Manufacturing_Mobile_Low__c == null) a.Team_Manufacturing_Mobile_Low__c = 0;
        if (a.Team_Retail_Audience_Best_Guess__c == null) a.Team_Retail_Audience_Best_Guess__c = 0;
        if (a.Team_Retail_Audience_High__c == null) a.Team_Retail_Audience_High__c = 0;
        if (a.Team_Retail_Audience_Low__c == null) a.Team_Retail_Audience_Low__c = 0;
        if (a.Team_Retail_Mobile_Best_Guess__c == null) a.Team_Retail_Mobile_Best_Guess__c = 0;
        if (a.Team_Retail_Mobile_High__c == null) a.Team_Retail_Mobile_High__c = 0;
        if (a.Team_Retail_Mobile_Low__c == null) a.Team_Retail_Mobile_Low__c = 0;
        for (Manager_Best_Guess__c child : Trigger.new){
            if (child.Manager_Best_Guess__c == a.Id){
                a.Team_Booked_Actual__c += (child.Team_Booked_Actual__c == null ? 0 : child.Team_Booked_Actual__c) - (Trigger.oldMap.get(child.Id).Team_Booked_Actual__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Booked_Actual__c);
                a.Team_Booked_Proposal__c += (child.Team_Booked_Proposal__c == null ? 0 : child.Team_Booked_Proposal__c) - (Trigger.oldMap.get(child.Id).Team_Booked_Proposal__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Booked_Proposal__c);
                a.Team_Booked_Full_Proposal__c += (child.Team_Booked_Full_Proposal__c == null ? 0 : child.Team_Booked_Full_Proposal__c) - (Trigger.oldMap.get(child.Id).Team_Booked_Full_Proposal__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Booked_Full_Proposal__c);
                //a.Team_Quota__c += (child.Team_Quota__c == null ? 0 : child.Team_Quota__c) - (Trigger.oldMap.get(child.Id).Team_Quota__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Quota__c);
                a.Team_Previous_Year_Actual__c += (child.Team_Previous_Year_Actual__c == null ? 0 : child.Team_Previous_Year_Actual__c) - (Trigger.oldMap.get(child.Id).Team_Previous_Year_Actual__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Previous_Year_Actual__c);
                //Add red roll ups here
                a.Team_M_A_Booked_Actual__c += (child.Team_M_A_Booked_Actual__c == null ? 0 : child.Team_M_A_Booked_Actual__c) - (Trigger.oldMap.get(child.Id).Team_M_A_Booked_Actual__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_M_A_Booked_Actual__c);
                a.Team_M_A_Booked_Full_Proposal__c += (child.Team_M_A_Booked_Full_Proposal__c == null ? 0 : child.Team_M_A_Booked_Full_Proposal__c) - (Trigger.oldMap.get(child.Id).Team_M_A_Booked_Full_Proposal__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_M_A_Booked_Full_Proposal__c);
                a.Team_M_A_Booked_Proposal__c += (child.Team_M_A_Booked_Proposal__c == null ? 0 : child.Team_M_A_Booked_Proposal__c) - (Trigger.oldMap.get(child.Id).Team_M_A_Booked_Proposal__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_M_A_Booked_Proposal__c);
                a.Team_M_B_Booked_Actual__c += (child.Team_M_B_Booked_Actual__c == null ? 0 : child.Team_M_B_Booked_Actual__c) - (Trigger.oldMap.get(child.Id).Team_M_B_Booked_Actual__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_M_B_Booked_Actual__c);
                a.Team_M_B_Booked_Full_Proposal__c += (child.Team_M_B_Booked_Full_Proposal__c == null ? 0 : child.Team_M_B_Booked_Full_Proposal__c) - (Trigger.oldMap.get(child.Id).Team_M_B_Booked_Full_Proposal__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_M_B_Booked_Full_Proposal__c);                
                a.Team_M_B_Booked_Proposal__c += (child.Team_M_B_Booked_Proposal__c == null ? 0 : child.Team_M_B_Booked_Proposal__c) - (Trigger.oldMap.get(child.Id).Team_M_B_Booked_Proposal__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_M_B_Booked_Proposal__c);
                a.Team_M_D_Booked_Actual__c += (child.Team_M_D_Booked_Actual__c == null ? 0 : child.Team_M_D_Booked_Actual__c) - (Trigger.oldMap.get(child.Id).Team_M_D_Booked_Actual__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_M_D_Booked_Actual__c);
                a.Team_M_D_Booked_Full_Proposal__c += (child.Team_M_D_Booked_Full_Proposal__c == null ? 0 : child.Team_M_D_Booked_Full_Proposal__c) - (Trigger.oldMap.get(child.Id).Team_M_D_Booked_Full_Proposal__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_M_D_Booked_Full_Proposal__c);
                a.Team_M_D_Booked_Proposal__c += (child.Team_M_D_Booked_Proposal__c == null ? 0 : child.Team_M_D_Booked_Proposal__c) - (Trigger.oldMap.get(child.Id).Team_M_D_Booked_Proposal__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_M_D_Booked_Proposal__c);
                a.Team_M_M_Booked_Actual__c += (child.Team_M_M_Booked_Actual__c == null ? 0 : child.Team_M_M_Booked_Actual__c) - (Trigger.oldMap.get(child.Id).Team_M_M_Booked_Actual__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_M_M_Booked_Actual__c);
                a.Team_M_M_Booked_Full_Proposal__c += (child.Team_M_M_Booked_Full_Proposal__c == null ? 0 : child.Team_M_M_Booked_Full_Proposal__c) - (Trigger.oldMap.get(child.Id).Team_M_M_Booked_Full_Proposal__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_M_M_Booked_Full_Proposal__c);
                a.Team_M_M_Booked_Proposal__c += (child.Team_M_M_Booked_Proposal__c == null ? 0 : child.Team_M_M_Booked_Proposal__c) - (Trigger.oldMap.get(child.Id).Team_M_M_Booked_Proposal__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_M_M_Booked_Proposal__c);
                a.Team_R_A_Booked_Actual__c += (child.Team_R_A_Booked_Actual__c == null ? 0 : child.Team_R_A_Booked_Actual__c) - (Trigger.oldMap.get(child.Id).Team_R_A_Booked_Actual__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_R_A_Booked_Actual__c);
                a.Team_R_A_Booked_Full_Proposal__c += (child.Team_R_A_Booked_Full_Proposal__c == null ? 0 : child.Team_R_A_Booked_Full_Proposal__c) - (Trigger.oldMap.get(child.Id).Team_R_A_Booked_Full_Proposal__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_R_A_Booked_Full_Proposal__c);
                a.Team_R_A_Booked_Proposal__c += (child.Team_R_A_Booked_Proposal__c == null ? 0 : child.Team_R_A_Booked_Proposal__c) - (Trigger.oldMap.get(child.Id).Team_R_A_Booked_Proposal__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_R_A_Booked_Proposal__c);                
                a.Team_R_B_Booked_Actual__c += (child.Team_R_B_Booked_Actual__c == null ? 0 : child.Team_R_B_Booked_Actual__c) - (Trigger.oldMap.get(child.Id).Team_R_B_Booked_Actual__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_R_B_Booked_Actual__c);
                a.Team_R_B_Booked_Full_Proposal__c += (child.Team_R_B_Booked_Full_Proposal__c == null ? 0 : child.Team_R_B_Booked_Full_Proposal__c) - (Trigger.oldMap.get(child.Id).Team_R_B_Booked_Full_Proposal__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_R_B_Booked_Full_Proposal__c);
                a.Team_R_B_Booked_Proposal__c += (child.Team_R_B_Booked_Proposal__c == null ? 0 : child.Team_R_B_Booked_Proposal__c) - (Trigger.oldMap.get(child.Id).Team_R_B_Booked_Proposal__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_R_B_Booked_Proposal__c);
                a.Team_R_D_Booked_Actual__c += (child.Team_R_D_Booked_Actual__c == null ? 0 : child.Team_R_D_Booked_Actual__c) - (Trigger.oldMap.get(child.Id).Team_R_D_Booked_Actual__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_R_D_Booked_Actual__c);
                a.Team_R_D_Booked_Full_Proposal__c += (child.Team_R_D_Booked_Full_Proposal__c == null ? 0 : child.Team_R_D_Booked_Full_Proposal__c) - (Trigger.oldMap.get(child.Id).Team_R_D_Booked_Full_Proposal__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_R_D_Booked_Full_Proposal__c);
                a.Team_R_D_Booked_Proposal__c += (child.Team_R_D_Booked_Proposal__c == null ? 0 : child.Team_R_D_Booked_Proposal__c) - (Trigger.oldMap.get(child.Id).Team_R_D_Booked_Proposal__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_R_D_Booked_Proposal__c);
                a.Team_R_M_Booked_Actual__c += (child.Team_R_M_Booked_Actual__c == null ? 0 : child.Team_R_M_Booked_Actual__c) - (Trigger.oldMap.get(child.Id).Team_R_M_Booked_Actual__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_R_M_Booked_Actual__c);
                a.Team_R_M_Booked_Full_Proposal__c += (child.Team_R_M_Booked_Full_Proposal__c == null ? 0 : child.Team_R_M_Booked_Full_Proposal__c) - (Trigger.oldMap.get(child.Id).Team_R_M_Booked_Full_Proposal__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_R_M_Booked_Full_Proposal__c);
                a.Team_R_M_Booked_Proposal__c += (child.Team_R_M_Booked_Proposal__c == null ? 0 : child.Team_R_M_Booked_Proposal__c) - (Trigger.oldMap.get(child.Id).Team_R_M_Booked_Proposal__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_R_M_Booked_Proposal__c);
                
                
                //must compare appropriate values
                if (child.Use_Override__c && Trigger.oldMap.get(child.Id).Use_Override__c){
                    a.Team_Manufacturing_Base_Best_Guess__c += (child.Override_Team_Manu_Base_Best_Guess__c == null ? 0 : child.Override_Team_Manu_Base_Best_Guess__c) - (Trigger.oldMap.get(child.Id).Override_Team_Manu_Base_Best_Guess__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Manu_Base_Best_Guess__c);
                    a.Team_Manufacturing_Base_High__c += (child.Override_Team_Manu_Base_High__c == null ? 0 : child.Override_Team_Manu_Base_High__c) - (Trigger.oldMap.get(child.Id).Override_Team_Manu_Base_High__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Manu_Base_High__c);
                    a.Team_Manufacturing_Base_Low__c += (child.Override_Team_Manu_Base_Low__c == null ? 0 : child.Override_Team_Manu_Base_Low__c) - (Trigger.oldMap.get(child.Id).Override_Team_Manu_Base_Low__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Manu_Base_Low__c);
                    a.Team_Manufacturing_Digital_Best_Guess__c += (child.Override_Team_Manu_Digital_Best_Guess__c == null ? 0 : child.Override_Team_Manu_Digital_Best_Guess__c) - (Trigger.oldMap.get(child.Id).Override_Team_Manu_Digital_Best_Guess__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Manu_Digital_Best_Guess__c);
                    a.Team_Manufacturing_Digital_High__c += (child.Override_Team_Manu_Digital_High__c == null ? 0 : child.Override_Team_Manu_Digital_High__c) - (Trigger.oldMap.get(child.Id).Override_Team_Manu_Digital_High__c  == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Manu_Digital_High__c );
                    a.Team_Manufacturing_Digital_Low__c += (child.Override_Team_Manu_Digital_Low__c == null ? 0 : child.Override_Team_Manu_Digital_Low__c) - (Trigger.oldMap.get(child.Id).Override_Team_Manu_Digital_Low__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Manu_Digital_Low__c);
                    a.Team_Retail_Base_Best_Guess__c += (child.Override_Team_Retail_Base_Best_Guess__c == null ? 0 : child.Override_Team_Retail_Base_Best_Guess__c) - (Trigger.oldMap.get(child.Id).Override_Team_Retail_Base_Best_Guess__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Retail_Base_Best_Guess__c);
                    a.Team_Retail_Base_High__c += (child.Override_Team_Retail_Base_High__c == null ? 0 : child.Override_Team_Retail_Base_High__c) - (Trigger.oldMap.get(child.Id).Override_Team_Retail_Base_High__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Retail_Base_High__c);
                    a.Team_Retail_Base_Low__c += (child.Override_Team_Retail_Base_Low__c == null ? 0 : child.Override_Team_Retail_Base_Low__c) - (Trigger.oldMap.get(child.Id).Override_Team_Retail_Base_Low__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Retail_Base_Low__c);
                    a.Team_Retail_Digital_Best_Guess__c += (child.Override_Team_Retail_Digital_Best_Guess__c == null ? 0 : child.Override_Team_Retail_Digital_Best_Guess__c) - (Trigger.oldMap.get(child.Id).Override_Team_Retail_Digital_Best_Guess__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Retail_Digital_Best_Guess__c);
                    a.Team_Retail_Digital_High__c += (child.Override_Team_Retail_Digital_High__c == null ? 0 : child.Override_Team_Retail_Digital_High__c ) - (Trigger.oldMap.get(child.Id).Override_Team_Retail_Digital_High__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Retail_Digital_High__c);
                    a.Team_Retail_Digital_Low__c += (child.Override_Team_Retail_Digital_Low__c == null ? 0 : child.Override_Team_Retail_Digital_Low__c) - (Trigger.oldMap.get(child.Id).Override_Team_Retail_Digital_Low__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Retail_Digital_Low__c);
                    //Add blue roll ups here
                    
                    a.Team_Manufacturing_Audience_Best_Guess__c += (child.Override_Team_Manu_Audience_Best_Guess__c == null ? 0 : child.Override_Team_Manu_Audience_Best_Guess__c) - (Trigger.oldMap.get(child.Id).Override_Team_Manu_Audience_Best_Guess__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Manu_Audience_Best_Guess__c);
                    a.Team_Manufacturing_Audience_High__c += (child.Override_Team_Manu_Audience_High__c == null ? 0 : child.Override_Team_Manu_Audience_High__c) - (Trigger.oldMap.get(child.Id).Override_Team_Manu_Audience_High__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Manu_Audience_High__c);
                    a.Team_Manufacturing_Audience_Low__c += (child.Override_Team_Manu_Audience_Low__c == null ? 0 : child.Override_Team_Manu_Audience_Low__c) - (Trigger.oldMap.get(child.Id).Override_Team_Manu_Audience_Low__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Manu_Audience_Low__c);
                    a.Team_Manufacturing_Mobile_Best_Guess__c += (child.Override_Team_Manu_Mobile_Best_Guess__c == null ? 0 : child.Override_Team_Manu_Mobile_Best_Guess__c) - (Trigger.oldMap.get(child.Id).Override_Team_Manu_Mobile_Best_Guess__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Manu_Mobile_Best_Guess__c);
                    a.Team_Manufacturing_Mobile_High__c += (child.Override_Team_Manu_Mobile_High__c == null ? 0 : child.Override_Team_Manu_Mobile_High__c) - (Trigger.oldMap.get(child.Id).Override_Team_Manu_Mobile_High__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Manu_Mobile_High__c);
                    a.Team_Manufacturing_Mobile_Low__c += (child.Override_Team_Manu_Mobile_Low__c== null ? 0 : child.Override_Team_Manu_Mobile_Low__c) - (Trigger.oldMap.get(child.Id).Override_Team_Manu_Mobile_Low__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Manu_Mobile_Low__c);
                    a.Team_Retail_Audience_Best_Guess__c += (child.Override_Team_Retail_Audience_Best_Guess__c == null ? 0 : child.Override_Team_Retail_Audience_Best_Guess__c) - (Trigger.oldMap.get(child.Id).Override_Team_Retail_Audience_Best_Guess__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Retail_Audience_Best_Guess__c);
                    a.Team_Retail_Audience_High__c += (child.Override_Team_Retail_Audience_High__c == null ? 0 : child.Override_Team_Retail_Audience_High__c) - (Trigger.oldMap.get(child.Id).Override_Team_Retail_Audience_High__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Retail_Audience_High__c);
                    a.Team_Retail_Audience_Low__c += (child.Override_Team_Retail_Audience_Low__c == null ? 0 : child.Override_Team_Retail_Audience_Low__c) - (Trigger.oldMap.get(child.Id).Override_Team_Retail_Audience_Low__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Retail_Audience_Low__c);
                    a.Team_Retail_Mobile_Best_Guess__c += (child.Override_Team_Retail_Mobile_Best_Guess__c == null ? 0 : child.Override_Team_Retail_Mobile_Best_Guess__c) - (Trigger.oldMap.get(child.Id).Override_Team_Retail_Mobile_Best_Guess__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Retail_Mobile_Best_Guess__c);
                    a.Team_Retail_Mobile_High__c += (child.Override_Team_Retail_Mobile_High__c == null ? 0 : child.Override_Team_Retail_Mobile_High__c) - (Trigger.oldMap.get(child.Id).Override_Team_Retail_Mobile_High__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Retail_Mobile_High__c);
                    a.Team_Retail_Mobile_Low__c += (child.Override_Team_Retail_Mobile_Low__c == null ? 0 : child.Override_Team_Retail_Mobile_Low__c) - (Trigger.oldMap.get(child.Id).Override_Team_Retail_Mobile_Low__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Retail_Mobile_Low__c);
                    
                
                } else if (child.Use_Override__c && Trigger.oldMap.get(child.Id).Use_Override__c == false){
                    a.Team_Manufacturing_Base_Best_Guess__c += (child.Override_Team_Manu_Base_Best_Guess__c == null ? 0 : child.Override_Team_Manu_Base_Best_Guess__c) - (Trigger.oldMap.get(child.Id).Team_Manufacturing_Base_Best_Guess__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Manufacturing_Base_Best_Guess__c);
                    a.Team_Manufacturing_Base_High__c += (child.Override_Team_Manu_Base_High__c == null ? 0 : child.Override_Team_Manu_Base_High__c) - (Trigger.oldMap.get(child.Id).Team_Manufacturing_Base_High__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Manufacturing_Base_High__c);
                    a.Team_Manufacturing_Base_Low__c += (child.Override_Team_Manu_Base_Low__c == null ? 0 : child.Override_Team_Manu_Base_Low__c) - (Trigger.oldMap.get(child.Id).Team_Manufacturing_Base_Low__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Manufacturing_Base_Low__c);
                    a.Team_Manufacturing_Digital_Best_Guess__c += (child.Override_Team_Manu_Digital_Best_Guess__c == null ? 0 : child.Override_Team_Manu_Digital_Best_Guess__c) - (Trigger.oldMap.get(child.Id).Team_Manufacturing_Digital_Best_Guess__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Manufacturing_Digital_Best_Guess__c);
                    a.Team_Manufacturing_Digital_High__c += (child.Override_Team_Manu_Digital_High__c == null ? 0 : child.Override_Team_Manu_Digital_High__c) - (Trigger.oldMap.get(child.Id).Team_Manufacturing_Digital_High__c  == null ? 0 : Trigger.oldMap.get(child.Id).Team_Manufacturing_Digital_High__c );
                    a.Team_Manufacturing_Digital_Low__c += (child.Override_Team_Manu_Digital_Low__c == null ? 0 : child.Override_Team_Manu_Digital_Low__c) - (Trigger.oldMap.get(child.Id).Team_Manufacturing_Digital_Low__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Manufacturing_Digital_Low__c);
                    a.Team_Retail_Base_Best_Guess__c += (child.Override_Team_Retail_Base_Best_Guess__c == null ? 0 : child.Override_Team_Retail_Base_Best_Guess__c) - (Trigger.oldMap.get(child.Id).Team_Retail_Base_Best_Guess__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Retail_Base_Best_Guess__c);
                    a.Team_Retail_Base_High__c += (child.Override_Team_Retail_Base_High__c == null ? 0 : child.Override_Team_Retail_Base_High__c) - (Trigger.oldMap.get(child.Id).Team_Retail_Base_High__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Retail_Base_High__c);
                    a.Team_Retail_Base_Low__c += (child.Override_Team_Retail_Base_Low__c == null ? 0 : child.Override_Team_Retail_Base_Low__c) - (Trigger.oldMap.get(child.Id).Team_Retail_Base_Low__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Retail_Base_Low__c);
                    a.Team_Retail_Digital_Best_Guess__c += (child.Override_Team_Retail_Digital_Best_Guess__c == null ? 0 : child.Override_Team_Retail_Digital_Best_Guess__c) - (Trigger.oldMap.get(child.Id).Team_Retail_Digital_Best_Guess__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Retail_Digital_Best_Guess__c);
                    a.Team_Retail_Digital_High__c += (child.Override_Team_Retail_Digital_High__c == null ? 0 : child.Override_Team_Retail_Digital_High__c ) - (Trigger.oldMap.get(child.Id).Team_Retail_Digital_High__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Retail_Digital_High__c);
                    a.Team_Retail_Digital_Low__c += (child.Override_Team_Retail_Digital_Low__c == null ? 0 : child.Override_Team_Retail_Digital_Low__c) - (Trigger.oldMap.get(child.Id).Team_Retail_Digital_Low__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Retail_Digital_Low__c);
                    //Add blue roll ups here
                    
                    a.Team_Manufacturing_Audience_Best_Guess__c += (child.Override_Team_Manu_Audience_Best_Guess__c == null ? 0 : child.Override_Team_Manu_Audience_Best_Guess__c) - (Trigger.oldMap.get(child.Id).Team_Manufacturing_Audience_Best_Guess__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Manufacturing_Audience_Best_Guess__c);
                    a.Team_Manufacturing_Audience_High__c += (child.Override_Team_Manu_Audience_High__c == null ? 0 : child.Override_Team_Manu_Audience_High__c) - (Trigger.oldMap.get(child.Id).Team_Manufacturing_Audience_High__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Manufacturing_Audience_High__c);
                    a.Team_Manufacturing_Audience_Low__c += (child.Override_Team_Manu_Audience_Low__c == null ? 0 : child.Override_Team_Manu_Audience_Low__c) - (Trigger.oldMap.get(child.Id).Team_Manufacturing_Audience_Low__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Manufacturing_Audience_Low__c);
                    a.Team_Manufacturing_Mobile_Best_Guess__c += (child.Override_Team_Manu_Mobile_Best_Guess__c == null ? 0 : child.Override_Team_Manu_Mobile_Best_Guess__c) - (Trigger.oldMap.get(child.Id).Team_Manufacturing_Mobile_Best_Guess__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Manufacturing_Mobile_Best_Guess__c);
                    a.Team_Manufacturing_Mobile_High__c += (child.Override_Team_Manu_Mobile_High__c == null ? 0 : child.Override_Team_Manu_Mobile_High__c) - (Trigger.oldMap.get(child.Id).Team_Manufacturing_Mobile_High__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Manufacturing_Mobile_High__c);
                    a.Team_Manufacturing_Mobile_Low__c += (child.Override_Team_Manu_Mobile_Low__c== null ? 0 : child.Override_Team_Manu_Mobile_Low__c) - (Trigger.oldMap.get(child.Id).Team_Manufacturing_Mobile_Low__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Manufacturing_Mobile_Low__c);
                    a.Team_Retail_Audience_Best_Guess__c += (child.Override_Team_Retail_Audience_Best_Guess__c == null ? 0 : child.Override_Team_Retail_Audience_Best_Guess__c) - (Trigger.oldMap.get(child.Id).Team_Retail_Audience_Best_Guess__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Retail_Audience_Best_Guess__c);
                    a.Team_Retail_Audience_High__c += (child.Override_Team_Retail_Audience_High__c == null ? 0 : child.Override_Team_Retail_Audience_High__c) - (Trigger.oldMap.get(child.Id).Team_Retail_Audience_High__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Retail_Audience_High__c);
                    a.Team_Retail_Audience_Low__c += (child.Override_Team_Retail_Audience_Low__c == null ? 0 : child.Override_Team_Retail_Audience_Low__c) - (Trigger.oldMap.get(child.Id).Team_Retail_Audience_Low__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Retail_Audience_Low__c);
                    a.Team_Retail_Mobile_Best_Guess__c += (child.Override_Team_Retail_Mobile_Best_Guess__c == null ? 0 : child.Override_Team_Retail_Mobile_Best_Guess__c) - (Trigger.oldMap.get(child.Id).Team_Retail_Mobile_Best_Guess__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Retail_Mobile_Best_Guess__c);
                    a.Team_Retail_Mobile_High__c += (child.Override_Team_Retail_Mobile_High__c == null ? 0 : child.Override_Team_Retail_Mobile_High__c) - (Trigger.oldMap.get(child.Id).Team_Retail_Mobile_High__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Retail_Mobile_High__c);
                    a.Team_Retail_Mobile_Low__c += (child.Override_Team_Retail_Mobile_Low__c == null ? 0 : child.Override_Team_Retail_Mobile_Low__c) - (Trigger.oldMap.get(child.Id).Team_Retail_Mobile_Low__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Retail_Mobile_Low__c);
                    
                
                } else if (child.Use_Override__c == false && Trigger.oldMap.get(child.Id).Use_Override__c == true){
                    a.Team_Manufacturing_Base_Best_Guess__c += (child.Team_Manufacturing_Base_Best_Guess__c == null ? 0 : child.Team_Manufacturing_Base_Best_Guess__c) - (Trigger.oldMap.get(child.Id).Override_Team_Manu_Base_Best_Guess__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Manu_Base_Best_Guess__c);
                    a.Team_Manufacturing_Base_High__c += (child.Team_Manufacturing_Base_High__c == null ? 0 : child.Team_Manufacturing_Base_High__c) - (Trigger.oldMap.get(child.Id).Override_Team_Manu_Base_High__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Manu_Base_High__c);
                    a.Team_Manufacturing_Base_Low__c += (child.Team_Manufacturing_Base_Low__c == null ? 0 : child.Team_Manufacturing_Base_Low__c) - (Trigger.oldMap.get(child.Id).Override_Team_Manu_Base_Low__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Manu_Base_Low__c);
                    a.Team_Manufacturing_Digital_Best_Guess__c += (child.Team_Manufacturing_Digital_Best_Guess__c == null ? 0 : child.Team_Manufacturing_Digital_Best_Guess__c) - (Trigger.oldMap.get(child.Id).Override_Team_Manu_Digital_Best_Guess__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Manu_Digital_Best_Guess__c);
                    a.Team_Manufacturing_Digital_High__c += (child.Team_Manufacturing_Digital_High__c == null ? 0 : child.Team_Manufacturing_Digital_High__c) - (Trigger.oldMap.get(child.Id).Override_Team_Manu_Digital_High__c  == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Manu_Digital_High__c );
                    a.Team_Manufacturing_Digital_Low__c += (child.Team_Manufacturing_Digital_Low__c == null ? 0 : child.Team_Manufacturing_Digital_Low__c) - (Trigger.oldMap.get(child.Id).Override_Team_Manu_Digital_Low__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Manu_Digital_Low__c);
                    a.Team_Retail_Base_Best_Guess__c += (child.Team_Retail_Base_Best_Guess__c == null ? 0 : child.Team_Retail_Base_Best_Guess__c) - (Trigger.oldMap.get(child.Id).Override_Team_Retail_Base_Best_Guess__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Retail_Base_Best_Guess__c);
                    a.Team_Retail_Base_High__c += (child.Team_Retail_Base_High__c == null ? 0 : child.Team_Retail_Base_High__c) - (Trigger.oldMap.get(child.Id).Override_Team_Retail_Base_High__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Retail_Base_High__c);
                    a.Team_Retail_Base_Low__c += (child.Team_Retail_Base_Low__c == null ? 0 : child.Team_Retail_Base_Low__c) - (Trigger.oldMap.get(child.Id).Override_Team_Retail_Base_Low__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Retail_Base_Low__c);
                    a.Team_Retail_Digital_Best_Guess__c += (child.Team_Retail_Digital_Best_Guess__c == null ? 0 : child.Team_Retail_Digital_Best_Guess__c) - (Trigger.oldMap.get(child.Id).Override_Team_Retail_Digital_Best_Guess__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Retail_Digital_Best_Guess__c);
                    a.Team_Retail_Digital_High__c += (child.Team_Retail_Digital_High__c == null ? 0 : child.Team_Retail_Digital_High__c ) - (Trigger.oldMap.get(child.Id).Override_Team_Retail_Digital_High__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Retail_Digital_High__c);
                    a.Team_Retail_Digital_Low__c += (child.Team_Retail_Digital_Low__c == null ? 0 : child.Team_Retail_Digital_Low__c) - (Trigger.oldMap.get(child.Id).Override_Team_Retail_Digital_Low__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Retail_Digital_Low__c);
                    //Add blue roll ups here
                    
                    a.Team_Manufacturing_Audience_Best_Guess__c += (child.Team_Manufacturing_Audience_Best_Guess__c == null ? 0 : child.Team_Manufacturing_Audience_Best_Guess__c) - (Trigger.oldMap.get(child.Id).Override_Team_Manu_Audience_Best_Guess__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Manu_Audience_Best_Guess__c);
                    a.Team_Manufacturing_Audience_High__c += (child.Team_Manufacturing_Audience_High__c == null ? 0 : child.Team_Manufacturing_Audience_High__c) - (Trigger.oldMap.get(child.Id).Override_Team_Manu_Audience_High__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Manu_Audience_High__c);
                    a.Team_Manufacturing_Audience_Low__c += (child.Team_Manufacturing_Audience_Low__c == null ? 0 : child.Team_Manufacturing_Audience_Low__c) - (Trigger.oldMap.get(child.Id).Override_Team_Manu_Audience_Low__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Manu_Audience_Low__c);
                    a.Team_Manufacturing_Mobile_Best_Guess__c += (child.Team_Manufacturing_Mobile_Best_Guess__c == null ? 0 : child.Team_Manufacturing_Mobile_Best_Guess__c) - (Trigger.oldMap.get(child.Id).Override_Team_Manu_Mobile_Best_Guess__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Manu_Mobile_Best_Guess__c);
                    a.Team_Manufacturing_Mobile_High__c += (child.Team_Manufacturing_Mobile_High__c == null ? 0 : child.Team_Manufacturing_Mobile_High__c) - (Trigger.oldMap.get(child.Id).Override_Team_Manu_Mobile_High__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Manu_Mobile_High__c);
                    a.Team_Manufacturing_Mobile_Low__c += (child.Team_Manufacturing_Mobile_Low__c == null ? 0 : child.Team_Manufacturing_Mobile_Low__c) - (Trigger.oldMap.get(child.Id).Override_Team_Manu_Mobile_Low__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Manu_Mobile_Low__c);
                    a.Team_Retail_Audience_Best_Guess__c += (child.Team_Retail_Audience_Best_Guess__c == null ? 0 : child.Team_Retail_Audience_Best_Guess__c) - (Trigger.oldMap.get(child.Id).Override_Team_Retail_Audience_Best_Guess__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Retail_Audience_Best_Guess__c);
                    a.Team_Retail_Audience_High__c += (child.Team_Retail_Audience_High__c == null ? 0 : child.Team_Retail_Audience_High__c) - (Trigger.oldMap.get(child.Id).Override_Team_Retail_Audience_High__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Retail_Audience_High__c);
                    a.Team_Retail_Audience_Low__c += (child.Team_Retail_Audience_Low__c == null ? 0 : child.Team_Retail_Audience_Low__c) - (Trigger.oldMap.get(child.Id).Override_Team_Retail_Audience_Low__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Retail_Audience_Low__c);
                    a.Team_Retail_Mobile_Best_Guess__c += (child.Team_Retail_Mobile_Best_Guess__c == null ? 0 : child.Team_Retail_Mobile_Best_Guess__c) - (Trigger.oldMap.get(child.Id).Override_Team_Retail_Mobile_Best_Guess__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Retail_Mobile_Best_Guess__c);
                    a.Team_Retail_Mobile_High__c += (child.Team_Retail_Mobile_High__c == null ? 0 : child.Team_Retail_Mobile_High__c) - (Trigger.oldMap.get(child.Id).Override_Team_Retail_Mobile_High__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Retail_Mobile_High__c);
                    a.Team_Retail_Mobile_Low__c += (child.Team_Retail_Mobile_Low__c == null ? 0 : child.Team_Retail_Mobile_Low__c) - (Trigger.oldMap.get(child.Id).Override_Team_Retail_Mobile_Low__c == null ? 0 : Trigger.oldMap.get(child.Id).Override_Team_Retail_Mobile_Low__c);
                
                } else if (child.Use_Override__c == false && Trigger.oldMap.get(child.Id).Use_Override__c == false){
                    a.Team_Manufacturing_Base_Best_Guess__c += (child.Team_Manufacturing_Base_Best_Guess__c == null ? 0 : child.Team_Manufacturing_Base_Best_Guess__c) - (Trigger.oldMap.get(child.Id).Team_Manufacturing_Base_Best_Guess__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Manufacturing_Base_Best_Guess__c);
                    a.Team_Manufacturing_Base_High__c += (child.Team_Manufacturing_Base_High__c == null ? 0 : child.Team_Manufacturing_Base_High__c) - (Trigger.oldMap.get(child.Id).Team_Manufacturing_Base_High__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Manufacturing_Base_High__c);
                    a.Team_Manufacturing_Base_Low__c += (child.Team_Manufacturing_Base_Low__c == null ? 0 : child.Team_Manufacturing_Base_Low__c) - (Trigger.oldMap.get(child.Id).Team_Manufacturing_Base_Low__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Manufacturing_Base_Low__c);
                    a.Team_Manufacturing_Digital_Best_Guess__c += (child.Team_Manufacturing_Digital_Best_Guess__c == null ? 0 : child.Team_Manufacturing_Digital_Best_Guess__c) - (Trigger.oldMap.get(child.Id).Team_Manufacturing_Digital_Best_Guess__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Manufacturing_Digital_Best_Guess__c);
                    a.Team_Manufacturing_Digital_High__c += (child.Team_Manufacturing_Digital_High__c == null ? 0 : child.Team_Manufacturing_Digital_High__c) - (Trigger.oldMap.get(child.Id).Team_Manufacturing_Digital_High__c  == null ? 0 : Trigger.oldMap.get(child.Id).Team_Manufacturing_Digital_High__c );
                    a.Team_Manufacturing_Digital_Low__c += (child.Team_Manufacturing_Digital_Low__c == null ? 0 : child.Team_Manufacturing_Digital_Low__c) - (Trigger.oldMap.get(child.Id).Team_Manufacturing_Digital_Low__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Manufacturing_Digital_Low__c);
                    a.Team_Retail_Base_Best_Guess__c += (child.Team_Retail_Base_Best_Guess__c == null ? 0 : child.Team_Retail_Base_Best_Guess__c) - (Trigger.oldMap.get(child.Id).Team_Retail_Base_Best_Guess__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Retail_Base_Best_Guess__c);
                    a.Team_Retail_Base_High__c += (child.Team_Retail_Base_High__c == null ? 0 : child.Team_Retail_Base_High__c) - (Trigger.oldMap.get(child.Id).Team_Retail_Base_High__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Retail_Base_High__c);
                    a.Team_Retail_Base_Low__c += (child.Team_Retail_Base_Low__c == null ? 0 : child.Team_Retail_Base_Low__c) - (Trigger.oldMap.get(child.Id).Team_Retail_Base_Low__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Retail_Base_Low__c);
                    a.Team_Retail_Digital_Best_Guess__c += (child.Team_Retail_Digital_Best_Guess__c == null ? 0 : child.Team_Retail_Digital_Best_Guess__c) - (Trigger.oldMap.get(child.Id).Team_Retail_Digital_Best_Guess__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Retail_Digital_Best_Guess__c);
                    a.Team_Retail_Digital_High__c += (child.Team_Retail_Digital_High__c == null ? 0 : child.Team_Retail_Digital_High__c ) - (Trigger.oldMap.get(child.Id).Team_Retail_Digital_High__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Retail_Digital_High__c);
                    a.Team_Retail_Digital_Low__c += (child.Team_Retail_Digital_Low__c == null ? 0 : child.Team_Retail_Digital_Low__c) - (Trigger.oldMap.get(child.Id).Team_Retail_Digital_Low__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Retail_Digital_Low__c);
                    //Add blue roll ups here
                    
                    a.Team_Manufacturing_Audience_Best_Guess__c += (child.Team_Manufacturing_Audience_Best_Guess__c == null ? 0 : child.Team_Manufacturing_Audience_Best_Guess__c) - (Trigger.oldMap.get(child.Id).Team_Manufacturing_Audience_Best_Guess__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Manufacturing_Audience_Best_Guess__c);
                    a.Team_Manufacturing_Audience_High__c += (child.Team_Manufacturing_Audience_High__c == null ? 0 : child.Team_Manufacturing_Audience_High__c) - (Trigger.oldMap.get(child.Id).Team_Manufacturing_Audience_High__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Manufacturing_Audience_High__c);
                    a.Team_Manufacturing_Audience_Low__c += (child.Team_Manufacturing_Audience_Low__c == null ? 0 : child.Team_Manufacturing_Audience_Low__c) - (Trigger.oldMap.get(child.Id).Team_Manufacturing_Audience_Low__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Manufacturing_Audience_Low__c);
                    a.Team_Manufacturing_Mobile_Best_Guess__c += (child.Team_Manufacturing_Mobile_Best_Guess__c == null ? 0 : child.Team_Manufacturing_Mobile_Best_Guess__c) - (Trigger.oldMap.get(child.Id).Team_Manufacturing_Mobile_Best_Guess__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Manufacturing_Mobile_Best_Guess__c);
                    a.Team_Manufacturing_Mobile_High__c += (child.Team_Manufacturing_Mobile_High__c == null ? 0 : child.Team_Manufacturing_Mobile_High__c) - (Trigger.oldMap.get(child.Id).Team_Manufacturing_Mobile_High__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Manufacturing_Mobile_High__c);
                    a.Team_Manufacturing_Mobile_Low__c += (child.Team_Manufacturing_Mobile_Low__c == null ? 0 : child.Team_Manufacturing_Mobile_Low__c) - (Trigger.oldMap.get(child.Id).Team_Manufacturing_Mobile_Low__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Manufacturing_Mobile_Low__c);
                    a.Team_Retail_Audience_Best_Guess__c += (child.Team_Retail_Audience_Best_Guess__c == null ? 0 : child.Team_Retail_Audience_Best_Guess__c) - (Trigger.oldMap.get(child.Id).Team_Retail_Audience_Best_Guess__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Retail_Audience_Best_Guess__c);
                    a.Team_Retail_Audience_High__c += (child.Team_Retail_Audience_High__c == null ? 0 : child.Team_Retail_Audience_High__c) - (Trigger.oldMap.get(child.Id).Team_Retail_Audience_High__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Retail_Audience_High__c);
                    a.Team_Retail_Audience_Low__c += (child.Team_Retail_Audience_Low__c == null ? 0 : child.Team_Retail_Audience_Low__c) - (Trigger.oldMap.get(child.Id).Team_Retail_Audience_Low__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Retail_Audience_Low__c);
                    a.Team_Retail_Mobile_Best_Guess__c += (child.Team_Retail_Mobile_Best_Guess__c == null ? 0 : child.Team_Retail_Mobile_Best_Guess__c) - (Trigger.oldMap.get(child.Id).Team_Retail_Mobile_Best_Guess__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Retail_Mobile_Best_Guess__c);
                    a.Team_Retail_Mobile_High__c += (child.Team_Retail_Mobile_High__c == null ? 0 : child.Team_Retail_Mobile_High__c) - (Trigger.oldMap.get(child.Id).Team_Retail_Mobile_High__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Retail_Mobile_High__c);
                    a.Team_Retail_Mobile_Low__c += (child.Team_Retail_Mobile_Low__c == null ? 0 : child.Team_Retail_Mobile_Low__c) - (Trigger.oldMap.get(child.Id).Team_Retail_Mobile_Low__c == null ? 0 : Trigger.oldMap.get(child.Id).Team_Retail_Mobile_Low__c);

                    
                }
            }
        }
    }
    
    system.debug('***before update call');
    update parent;

}