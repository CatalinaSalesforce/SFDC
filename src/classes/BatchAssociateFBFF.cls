/*
@Name           :       BatchAssociateFBFF
@Author         :       Warren
@Date           :       Feb 22 2012
@Description    :       Batch class designed to:
                            - associate Finance Budget and Finance Forecast records with Sales Manager 1 Forecast records for report viewing
                            - this class will associate each FB and FF record with 8 Sales Manager 1 Forecast records, 1 for each combination
                                of delivery type and account type
                            
*/
global class BatchAssociateFBFF implements Database.Batchable<sObject>, Schedulable{
    
    final static String defaultSettingsName = 'Default';
    Catalina_Forecast_Settings__c settings;
    String baseType;
    String digitalType;
    String audienceType;
    String mobileType;
    String manufacturingType;
    String retailType;
    
    global Database.querylocator start(Database.BatchableContext BC){
        BatchGovernorLimitUtility.insertBatchRun('BatchAssociateFBFF');
        String query = 'Select ID From User Limit 1';
        return Database.getQueryLocator(query);
    }
    
    global void execute(SchedulableContext ctx) {
        BatchAssociateFBFF batch1 = new BatchAssociateFBFF();
        ID batchprocessid = Database.executeBatch(batch1);
    }
    
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        Datetime currentTime = System.now();
        //get settings info
        settings = Catalina_Forecast_Settings__c.getInstance(defaultSettingsName);
        baseType = settings.Base_Delivery_Type__c;
        digitalType = settings.Digital_Delivery_Type__c;
        audienceType = settings.Display_Delivery_Type__c;
        mobileType = settings.Mobile_Delivery_Type__c;
        manufacturingType = settings.Manufacturing_Account_Type__c;
        retailType = settings.Retail_Account_Type__c;
        
        //get as many sm1 forecasting records as possible so we can associate
        List<Sales_Manager_1_Forecast__c> sm1 = [Select Id, OwnerId, Quarter__c, Account_Type__c, Manager__c, Delivery_Type__c, Finance_Budget__c, Finance_Forecast__c From Sales_Manager_1_Forecast__c Order By OwnerId, Account__c LIMIT 49000];
        Set<String> quarters = new Set<String>();
        Set<Id> EVPList = new Set<Id>();
        
        //map out the budget and forecast records so that we can associate it easier
        Map<String, ID> fbMap = new Map<String, Id>();
        for (Finance_Budget__c a : [SELECT Id, Quarter__c, EVP__c From Finance_Budget__c LIMIT 100]){
            fbMap.put(a.EVP__c+'-'+a.Quarter__c, a.Id);
            if (!quarters.contains(a.Quarter__c))quarters.add(a.Quarter__c);
            if (!EVPList.contains(a.EVP__c))EVPList.add(a.EVP__c);
        }
        Map<String, ID> ffMap = new Map<String, Id>();
        for (Finance_Forecast__c a : [SELECT Id, Quarter__c, EVP__c From Finance_Forecast__c LIMIT 100]){
            ffMap.put(a.EVP__c+'-'+a.Quarter__c, a.Id);
        }
        
        List<Sales_Manager_1_Forecast__c> updateSM1 = new List<Sales_Manager_1_Forecast__c>();
        
        //for each record budget and forecast record, loop through the SM1 objects to find 1 we can associate to
        system.debug(Logginglevel.WARN, EVPList.size());
        for (String evp : EVPList){
            for (String thisQuarter : quarters){
                Boolean m1 = false;
                Boolean m2 = false;
                Boolean m3 = false;
                Boolean m4 = false;
                Boolean r1 = false;
                Boolean r2 = false;
                Boolean r3 = false;
                Boolean r4 = false;
                system.debug('***thisquarter: ' + thisQuarter + ' - ' + evp);
                for (Sales_Manager_1_Forecast__c a : sm1){
                    if (a.Quarter__c == thisQuarter && a.Manager__c == evp){
                        //system.debug('***found this quarter');
                        if (!m1){
                            if (a.Account_Type__c == 'Manufacturing' && a.Delivery_Type__c == baseType && a.Manager__c == evp){
                                updateSM1.add(a);
                                m1 = true;
                                system.debug('***found m1');
                            }
                        }
                        if (!m2){
                            if (a.Account_Type__c == 'Manufacturing' && a.Delivery_Type__c == digitalType && a.Manager__c == evp){
                                updateSM1.add(a);
                                m2 = true;
                                system.debug('***found m2');
                            }
                        }
                        if (!m3){
                            if (a.Account_Type__c == 'Manufacturing' && a.Delivery_Type__c == audienceType && a.Manager__c == evp){
                                updateSM1.add(a);
                                m3 = true;
                                system.debug('***found m3');
                            }
                        }
                        if (!m4){
                            if (a.Account_Type__c == 'Manufacturing' && a.Delivery_Type__c == mobileType && a.Manager__c == evp){
                                updateSM1.add(a);
                                m4 = true;
                                system.debug('***found m4');
                            }
                        }
                        if (!r1){
                            if (a.Account_Type__c == 'Retail' && a.Delivery_Type__c == baseType && a.Manager__c == evp){
                                updateSM1.add(a);
                                r1 = true;
                                system.debug('***found r1');
                            }
                        }
                        if (!r2){
                            if (a.Account_Type__c == 'Retail' && a.Delivery_Type__c == digitalType && a.Manager__c == evp){
                                updateSM1.add(a);
                                r2 = true;
                                system.debug('***found r2');
                            }
                        }
                        if (!r3){
                            if (a.Account_Type__c == 'Retail' && a.Delivery_Type__c == audienceType && a.Manager__c == evp){
                                updateSM1.add(a);
                                r3 = true;
                                system.debug('***found r3');
                            }
                        }
                        if (!r4){
                            if (a.Account_Type__c == 'Retail' && a.Delivery_Type__c == mobileType && a.Manager__c == evp){
                                updateSM1.add(a);
                                r4 = true;
                                system.debug('***found r4');
                            }
                        }
                    }
                    
                    if (m1 && m2 && m3 && m4 && r1 && r2 && r3 && r4) break;
                }
            }
        }
        
        for (Sales_Manager_1_Forecast__c a : updateSM1){
            a.Finance_Budget__c = fbMap.get(a.Manager__c+'-'+a.Quarter__c);
            a.Finance_Forecast__c = ffMap.get(a.Manager__c+'-'+a.Quarter__c);
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
        BatchBestGuessFYTotal1COPY acctBatch2Sched = new BatchBestGuessFYTotal1COPY();
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
        BatchGovernorLimitUtility.updateBatchRun();
    }

}