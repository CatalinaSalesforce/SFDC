/*
@Name            : BatchHuffmasterAssociateMBG 
@Author          : customersuccess@cloud62.com
@Date            : December 17th, 2012
@Description     : This class associates EVP Best Guess records to SM1 forecasting records
                    for reporting

2/1/2013 - Edited class to include Audience and Mobile Delivery Channels in BU Pacing Dash.: JBettio
//2013-02-07 add code to include coop user to make association
*/
global class BatchHuffmasterAssociateMBG implements Database.Batchable<sObject>, Schedulable{
    
    final static String defaultSettingsName = 'Default';
    Catalina_Forecast_Settings__c settings;
    String baseType;
    String digitalType;
    String audienceType;
    String mobileType;
    String manufacturingType;
    String retailType;
    String query;
    
    global Database.querylocator start(Database.BatchableContext BC){
        BatchGovernorLimitUtility.insertBatchRun('BatchHuffmasterAssociateMBG');
        query = 'SELECT ID FROM USER LIMIT 1';
        return Database.getQueryLocator(query);
    }
    
    global void execute(SchedulableContext ctx) {
        BatchHuffmasterAssociateMBG batch1 = new BatchHuffmasterAssociateMBG();
        ID batchprocessid = Database.executeBatch(batch1);
    }
    
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        Datetime currentTime = System.now();
        settings = Catalina_Forecast_Settings__c.getInstance(defaultSettingsName);
        baseType = settings.Base_Delivery_Type__c;
        digitalType = settings.Digital_Delivery_Type__c;
        audienceType = settings.Display_Delivery_Type__c;
        mobileType = settings.Mobile_Delivery_Type__c;
        manufacturingType = settings.Manufacturing_Account_Type__c;
        retailType = settings.Retail_Account_Type__c;
        Set<Id> userList = new Set<Id>();
        Set<String> quarterList = new Set<String>();
        //store EVP MBG records in a map for easy retrieval
        Map<Id, List<Manager_Best_Guess__c>> evpMap = new Map<Id, List<Manager_Best_Guess__c>>(); 
        String year = '%' + Date.today().year() + '%';
        List<Manager_Best_Guess__c> EVPMBG = [SELECT ID, OwnerId, QUARTER__C, NAME, Override_Team_Manu_Base_Best_Guess__c, Override_Team_Manu_Digital_Best_Guess__c, 
        Override_Team_Manu_Audience_Best_Guess__c, Override_Team_Manu_Mobile_Best_Guess__c, Override_Team_Retail_Base_Best_Guess__c, Override_Team_Retail_Digital_Best_Guess__c, 
        Override_Team_Retail_Audience_Best_Guess__c, Override_Team_Retail_Mobile_Best_Guess__c  FROM MANAGER_BEST_GUESS__C WHERE OWNERID IN (SELECT ID FROM USER WHERE Forecast_Role__c = 'EVP' And Country__c = 'USA') And Quarter__c Like :year ORDER BY QUARTER__C];
        
        for (Manager_Best_Guess__c a : EVPMBG){
            if (!evpMap.containsKey(a.OwnerId)){
                evpMap.put(a.OwnerID, new List<Manager_Best_Guess__c>());
            }
            evpMap.get(a.OwnerId).add(a);
            userList.add(a.OwnerId);
            quarterList.add(a.Quarter__c);
        }
        system.debug(userList.size());
        
        //for each combinbation of retail/manu and base/digital, associate this records with a SM1 Forecasting record
        //so that formula fields can represent these values in aggregated reports
        List<Sales_Manager_1_Forecast__c> updateSM1 = new List<Sales_Manager_1_Forecast__c>();
        for (String evpID : userList){
            List<Sales_Manager_1_Forecast__c> sm1List = [SELECT ID, QUARTER__c, MANAGER__C, OWNERID, EVP_Manager_Best_Guess__c, Delivery_Type__c, Account_Type__c
                From Sales_Manager_1_Forecast__c Where Manager__c =:evpID And Quarter__c IN :quarterList Limit 10000];
            for (Manager_Best_Guess__c mbg : evpMap.get(evpID)){
                system.debug('***userID: ' + mbg.OwnerId + ', Quarter__c: ' + mbg.Quarter__c);
                boolean manuBase = false;
                boolean manuDigital = false;
                boolean manuAudience = false;
                boolean manuMobile = false;
                boolean retailBase = false;
                boolean retailDigital = false;
                boolean retailAudience = false;
                boolean retailMobile = false;
            
                for (Sales_Manager_1_Forecast__c a : sm1List){
                    if (!manubase && mbg.OwnerId == a.Manager__c && a.Quarter__c == mbg.Quarter__c && a.Delivery_Type__c == baseType && a.Account_Type__c == manufacturingType){
                        a.EVP_Manager_Best_Guess__c = mbg.Id;
                        manuBase = true;
                        updateSM1.add(a);
                    } else if (!manuDigital && mbg.OwnerId == a.Manager__c && a.Quarter__c == mbg.Quarter__c && a.Delivery_Type__c == digitalType && a.Account_Type__c == manufacturingType){
                        a.EVP_Manager_Best_Guess__c = mbg.Id;
                        manuDigital = true;
                        updateSM1.add(a);
                    } else if (!manuAudience && mbg.OwnerId == a.Manager__c && a.Quarter__c == mbg.Quarter__c && a.Delivery_Type__c == audienceType && a.Account_Type__c == manufacturingType){
                        a.EVP_Manager_Best_Guess__c = mbg.Id;
                        manuAudience = true;
                        updateSM1.add(a);  
                    } else if (!manuMobile && mbg.OwnerId == a.Manager__c && a.Quarter__c == mbg.Quarter__c && a.Delivery_Type__c == mobileType && a.Account_Type__c == manufacturingType){
                        a.EVP_Manager_Best_Guess__c = mbg.Id;
                        manuMobile = true;
                        updateSM1.add(a);                                               
                    } else if (!retailbase && mbg.OwnerId == a.Manager__c && a.Quarter__c == mbg.Quarter__c && a.Delivery_Type__c == baseType && a.Account_Type__c == retailType){
                        a.EVP_Manager_Best_Guess__c = mbg.Id;
                        retailBase = true;
                        updateSM1.add(a);
                    } else if (!retailDigital && mbg.OwnerId == a.Manager__c && a.Quarter__c == mbg.Quarter__c && a.Delivery_Type__c == digitalType && a.Account_Type__c == retailType){
                        a.EVP_Manager_Best_Guess__c = mbg.Id;
                        retailDigital = true;
                        updateSM1.add(a);
                    } else if (!retailAudience && mbg.OwnerId == a.Manager__c && a.Quarter__c == mbg.Quarter__c && a.Delivery_Type__c == audienceType && a.Account_Type__c == retailType){
                        a.EVP_Manager_Best_Guess__c = mbg.Id;
                        retailAudience = true;
                        updateSM1.add(a);    
                    } else if (!retailMobile && mbg.OwnerId == a.Manager__c && a.Quarter__c == mbg.Quarter__c && a.Delivery_Type__c == mobileType && a.Account_Type__c == retailType){
                        a.EVP_Manager_Best_Guess__c = mbg.Id;
                        retailMobile = true;
                        updateSM1.add(a);                                              
                    }
                    if (manuBase && manuDigital && manuAudience && manuMobile && retailBase && retailDigital && retailAudience && retailMobile) break;
                }
                if (!ManuBase) system.debug('***manuBase = false');
                if (!ManuDigital) system.debug('***manuDigital = false');
                if (!ManuAudience) system.debug('***manuAudience = false');
                if (!ManuMobile) system.debug('***manuMobile = false');                
                if (!RetailBase) system.debug('***RetailBase = false');
                if (!RetailDigital) system.debug('***RetailDigital = false');
                if (!RetailAudience) system.debug('***RetailAudience = false');
                if (!RetailMobile) system.debug('***RetailMobile = false');            }
        }
        
        //2013-02-07 add code to include coop user to make association
        Set<Id> userList1 = new Set<Id>();
        Set<String> quarterList1 = new Set<String>();
        //store EVP MBG records in a map for easy retrieval
        Map<Id, List<Manager_Best_Guess__c>> evpMap1 = new Map<Id, List<Manager_Best_Guess__c>>(); 
        List<Manager_Best_Guess__c> coopMBG = [SELECT ID, OwnerId, QUARTER__C, NAME, Override_Team_Manu_Base_Best_Guess__c, Override_Team_Manu_Digital_Best_Guess__c, 
        Override_Team_Manu_Audience_Best_Guess__c, Override_Team_Manu_Mobile_Best_Guess__c, Override_Team_Retail_Base_Best_Guess__c, Override_Team_Retail_Digital_Best_Guess__c, 
        Override_Team_Retail_Audience_Best_Guess__c, Override_Team_Retail_Mobile_Best_Guess__c  FROM MANAGER_BEST_GUESS__C WHERE OWNERID IN (SELECT ID FROM USER WHERE Forecast_Role__c = 'coop' And Country__c = 'USA') And Quarter__c Like :year ORDER BY QUARTER__C];
        
        for (Manager_Best_Guess__c a : coopMBG){
            if (!evpMap1.containsKey(a.OwnerId)){
                evpMap1.put(a.OwnerID, new List<Manager_Best_Guess__c>());
            }
            evpMap1.get(a.OwnerId).add(a);
            userList1.add(a.OwnerId);
            quarterList1.add(a.Quarter__c);
        }
        system.debug(userList1.size());
        
        //for each combinbation of retail/manu and base/digital, associate this records with a SM1 Forecasting record
        //so that formula fields can represent these values in aggregated reports
        for (String evpID : userList1){
            List<Sales_Manager_1_Forecast__c> sm1List = [SELECT ID, QUARTER__c, MANAGER__C, OWNERID, EVP_Manager_Best_Guess__c, Delivery_Type__c, Account_Type__c
                From Sales_Manager_1_Forecast__c Where OwnerId =:evpID And Quarter__c IN :quarterList Limit 10000];
            for (Manager_Best_Guess__c mbg : evpMap1.get(evpID)){
                system.debug('***userID: ' + mbg.OwnerId + ', Quarter__c: ' + mbg.Quarter__c);
                boolean manuBase = false;
                boolean manuDigital = false;
                boolean manuAudience = false;
                boolean manuMobile = false;
                boolean retailBase = false;
                boolean retailDigital = false;
                boolean retailAudience = false;
                boolean retailMobile = false;
            
                for (Sales_Manager_1_Forecast__c a : sm1List){
                    if (!manubase && mbg.OwnerId == a.OwnerId && a.Quarter__c == mbg.Quarter__c && a.Delivery_Type__c == baseType && a.Account_Type__c == manufacturingType){
                        a.EVP_Manager_Best_Guess__c = mbg.Id;
                        manuBase = true;
                        updateSM1.add(a);
                    } else if (!manuDigital && mbg.OwnerId == a.OwnerId && a.Quarter__c == mbg.Quarter__c && a.Delivery_Type__c == digitalType && a.Account_Type__c == manufacturingType){
                        a.EVP_Manager_Best_Guess__c = mbg.Id;
                        manuDigital = true;
                        updateSM1.add(a);
                    } else if (!manuAudience && mbg.OwnerId == a.OwnerId && a.Quarter__c == mbg.Quarter__c && a.Delivery_Type__c == audienceType && a.Account_Type__c == manufacturingType){
                        a.EVP_Manager_Best_Guess__c = mbg.Id;
                        manuAudience = true;
                        updateSM1.add(a);  
                    } else if (!manuMobile && mbg.OwnerId == a.OwnerId && a.Quarter__c == mbg.Quarter__c && a.Delivery_Type__c == mobileType && a.Account_Type__c == manufacturingType){
                        a.EVP_Manager_Best_Guess__c = mbg.Id;
                        manuMobile = true;
                        updateSM1.add(a);                                               
                    } else if (!retailbase && mbg.OwnerId == a.OwnerId && a.Quarter__c == mbg.Quarter__c && a.Delivery_Type__c == baseType && a.Account_Type__c == retailType){
                        a.EVP_Manager_Best_Guess__c = mbg.Id;
                        retailBase = true;
                        updateSM1.add(a);
                    } else if (!retailDigital && mbg.OwnerId == a.OwnerId && a.Quarter__c == mbg.Quarter__c && a.Delivery_Type__c == digitalType && a.Account_Type__c == retailType){
                        a.EVP_Manager_Best_Guess__c = mbg.Id;
                        retailDigital = true;
                        updateSM1.add(a);
                    } else if (!retailAudience && mbg.OwnerId == a.OwnerId && a.Quarter__c == mbg.Quarter__c && a.Delivery_Type__c == audienceType && a.Account_Type__c == retailType){
                        a.EVP_Manager_Best_Guess__c = mbg.Id;
                        retailAudience = true;
                        updateSM1.add(a);    
                    } else if (!retailMobile && mbg.OwnerId == a.OwnerId && a.Quarter__c == mbg.Quarter__c && a.Delivery_Type__c == mobileType && a.Account_Type__c == retailType){
                        a.EVP_Manager_Best_Guess__c = mbg.Id;
                        retailMobile = true;
                        updateSM1.add(a);                                              
                    }
                    if (manuBase && manuDigital && manuAudience && manuMobile && retailBase && retailDigital && retailAudience && retailMobile) break;
                }
                if (!ManuBase) system.debug('***manuBase = false');
                if (!ManuDigital) system.debug('***manuDigital = false');
                if (!ManuAudience) system.debug('***manuAudience = false');
                if (!ManuMobile) system.debug('***manuMobile = false');                
                if (!RetailBase) system.debug('***RetailBase = false');
                if (!RetailDigital) system.debug('***RetailDigital = false');
                if (!RetailAudience) system.debug('***RetailAudience = false');
                if (!RetailMobile) system.debug('***RetailMobile = false');            }
        }
        update updateSM1;
        BatchGovernorLimitUtility.calcualteLimits(Limits.getCpuTime(), Limits.getDMLRows(), Limits.getDMLStatements(), Limits.getHeapSize(), Limits.getQueries(), Limits.getQueryRows(), Limits.getScriptStatements(), scope, currentTime, System.now());
        
    }
    
    global void finish(Database.BatchableContext BC){
        System.debug(LoggingLevel.WARN,'Temp_Delete_DeleteSM1Forecast');
        //Build the system time of now + 20 seconds to schedule the batch apex.
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        BatchDeactivatePFEUsers acctBatch2Sched = new BatchDeactivatePFEUsers();
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
        BatchGovernorLimitUtility.updateBatchRun();
    }

}