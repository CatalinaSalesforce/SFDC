/*
@Name            : BatchCalculateBestGuessPFM
@Author          : customersuccess@cloud62.com
@Date            : Oct 10, 2013
@Description     : Batch Proccess to Calculate Best Guess
*/
global class BatchCalculateBestGuessPFM implements Database.Batchable<sObject>, Schedulable{
    
    final static String q1 = 'Q1';
    final static String q2 = 'Q2';
    final static String q3 = 'Q3';
    final static String q4 = 'Q4';
    
    String query;
    String limit1;
    final static String defaultSettingsName = 'Default';
    Catalina_Forecast_Settings__c settings;
    String baseType;
    String digitalType;
    String audienceType;
    String mobileType;
    String manufacturingType;
    String retailType;
    String coopType;
    Map<Id, Account> accParentMap;
    Set<Id> accountSet;
    Set<Id> congId;
    List<Sales_Rep_Best_Guess__c> srbgList;
    Map<Id, Map<String, Sales_Rep_Best_Guess__c>> srbgMap;
    Set<Id> userSet;
    
    public BatchCalculateBestGuessPFM(String x){
        limit1 = x;
    }
    
    public BatchCalculateBestGuessPFM(){
        limit1 = '';
    }
    
    global Database.querylocator start(Database.BatchableContext BC){
        BatchGovernorLimitUtility.insertBatchRun('BatchCalculateBestGuessPFM');
        
        Best_Guess_Settings__c BGSettings = Best_Guess_Settings__c.getOrgDefaults();
		BGSettings.Batch_Use_Trigger__c = true;
		upsert BGSettings;
         
        Set<String> quarters = new Set<String>();
        String year1 = String.valueOf(Date.today().year());
        String year2 = String.valueOf(Date.today().year() + 1);
        String yearM1 = String.valueOf(Date.today().year() - 1);
        quarters.add(q1 + year1);
        quarters.add(q2 + year1);
        quarters.add(q3 + year1);
        quarters.add(q4 + year1);
        quarters.add(q1 + year2);
        quarters.add(q2 + year2);
        quarters.add(q3 + year2);
        quarters.add(q4 + year2);
        quarters.add(q1 + yearM1);
        quarters.add(q2 + yearM1);
        quarters.add(q3 + yearM1);
        quarters.add(q4 + yearM1);
    
        query = 'SELECT ID, NAME, Account_Type__c, Active__c, Actual_Amount__c, Booked_Amount__c, CurrencyIsoCode,Cycle__c,Delivery_Channel__c, External_Id__c, '
        + ' Forecast_Amount__c, Forecast_Month__c, Forecast_Quarter__c, Opportunity_Record_Type__c, Program__r.Opportunity__r.RecordType.Name, Oppty_Probability__c, Program__c, Weighted_Forecast_Amount__c, '
        + ' Program__r.Opportunity__r.AccountId, Program__r.Opportunity__r.OwnerId, Program__r.Delivery_Type__c, '
        + ' Program__r.Opportunity__r.Account.RecordType.Name '
        + ' FROM PROGRAM_FORECAST_MONTHLY__C '
        //+ ' WHERE PROGRAM__R.OPPORTUNITY__R.OWNER.ISACTIVE = TRUE '
        + ' WHERE IS_SDPY__C = FALSE '
        + ' and (NOT(Program__r.Opportunity__r.IsWon = False and Program__r.Opportunity__r.IsClosed = True)) '
        + ' AND FORECAST_QUARTER__C IN: quarters '
        + ' ORDER BY PROGRAM__R.OPPORTUNITY__R.OWNERID, FORECAST_QUARTER__C '
        +   limit1; 
        return Database.getQueryLocator(query);
    }
    
    global void execute(SchedulableContext ctx) {
        BatchCalculateBestGuessPFM batch1 = new BatchCalculateBestGuessPFM();
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
        coopType = settings.Coop_String__c;
        
        List<Program_forecast_Monthly__c> scopePFM = (List<Program_forecast_Monthly__c>)scope;
        userSet = new Set<Id>();
        for (Program_forecast_Monthly__c pfm : scopePFM){
            userSet.add(pfm.Program__r.Opportunity__r.OwnerId);
        }
        
        populateMap();
        
        for (Program_forecast_Monthly__c pfm : scopePFM){
            String accountID = pfm.Program__r.Opportunity__r.AccountId;
            String accountType = pfm.Program__r.Opportunity__r.Account.RecordType.Name;
            String ownerID = pfm.Program__r.Opportunity__r.OwnerId;
            String year = String.valueOf(pfm.Forecast_Month__c.year());
            String delType = pfm.Program__r.Delivery_Type__c;
            String quarter = pfm.Forecast_Quarter__c;
            String recordType = pfm.Opportunity_Record_Type__c;
            Sales_Rep_Best_Guess__c a;
            if (srbgMap.containsKey(ownerID)){
                if (srbgMap.get(ownerID).containsKey(quarter)){
                    a = srbgMap.get(ownerID).get(quarter);
                    //set all values to 0 if they are null for any reason to avoid NPE
                    if (Double.valueOf(a.M_A_Actual_Amount__c) == null) a.M_A_Actual_Amount__c = 0;
                    if (Double.valueOf(a.M_A_Forecast_Contract__c) == null) a.M_A_Forecast_Contract__c = 0;
                    if (Double.valueOf(a.M_A_Forecast_Proposal__c) == null) a.M_A_Forecast_Proposal__c = 0;
                    if (Double.valueOf(a.M_A_Weighted_Forecast_Proposal__c) == null) a.M_A_Weighted_Forecast_Proposal__c = 0;
                    if (Double.valueOf(a.M_B_Actual_Amount__c) == null) a.M_B_Actual_Amount__c = 0;
                    if (Double.valueOf(a.M_B_Forecast_Contract__c) == null) a.M_B_Forecast_Contract__c = 0;
                    if (Double.valueOf(a.M_B_Forecast_Proposal__c) == null) a.M_B_Forecast_Proposal__c = 0;
                    if (Double.valueOf(a.M_B_Weighted_Forecast_Proposal__c) == null) a.M_B_Weighted_Forecast_Proposal__c = 0;
                    if (Double.valueOf(a.M_D_Actual_Amount__c) == null) a.M_D_Actual_Amount__c = 0;
                    if (Double.valueOf(a.M_D_Forecast_Contract__c) == null) a.M_D_Forecast_Contract__c = 0;
                    if (Double.valueOf(a.M_D_Forecast_Proposal__c) == null) a.M_D_Forecast_Proposal__c = 0;
                    if (Double.valueOf(a.M_D_Weighted_Forecast_Proposal__c) == null) a.M_D_Weighted_Forecast_Proposal__c = 0;
                    if (Double.valueOf(a.M_M_Actual_Amount__c) == null) a.M_M_Actual_Amount__c = 0;
                    if (Double.valueOf(a.M_M_Forecast_Contract__c) == null) a.M_M_Forecast_Contract__c = 0;
                    if (Double.valueOf(a.M_M_Forecast_Proposal__c) == null) a.M_M_Forecast_Proposal__c = 0;
                    if (Double.valueOf(a.M_M_Weighted_Forecast_Proposal__c) == null) a.M_M_Weighted_Forecast_Proposal__c = 0;
                    if (Double.valueOf(a.R_A_Actual_Amount__c) == null) a.R_A_Actual_Amount__c = 0;
                    if (Double.valueOf(a.R_A_Forecast_Contract__c) == null) a.R_A_Forecast_Contract__c = 0;
                    if (Double.valueOf(a.R_A_Forecast_Proposal__c) == null) a.R_A_Forecast_Proposal__c = 0;
                    if (Double.valueOf(a.R_A_Weighted_Forecast_Proposal__c) == null) a.R_A_Weighted_Forecast_Proposal__c = 0;
                    if (Double.valueOf(a.R_B_Actual_Amount__c) == null) a.R_B_Actual_Amount__c = 0;
                    if (Double.valueOf(a.R_B_Forecast_Contract__c) == null) a.R_B_Forecast_Contract__c = 0;
                    if (Double.valueOf(a.R_B_Forecast_Proposal__c) == null) a.R_B_Forecast_Proposal__c = 0;
                    if (Double.valueOf(a.R_B_Weighted_Forecast_Proposal__c) == null) a.R_B_Weighted_Forecast_Proposal__c = 0;
                    if (Double.valueOf(a.R_D_Actual_Amount__c) == null) a.R_D_Actual_Amount__c = 0;
                    if (Double.valueOf(a.R_D_Forecast_Contract__c) == null) a.R_D_Forecast_Contract__c = 0;
                    if (Double.valueOf(a.R_D_Forecast_Proposal__c) == null) a.R_D_Forecast_Proposal__c = 0;
                    if (Double.valueOf(a.R_D_Weighted_Forecast_Proposal__c) == null) a.R_D_Weighted_Forecast_Proposal__c = 0;
                    if (Double.valueOf(a.R_M_Actual_Amount__c) == null) a.R_M_Actual_Amount__c = 0;
                    if (Double.valueOf(a.R_M_Forecast_Contract__c) == null) a.R_M_Forecast_Contract__c = 0;
                    if (Double.valueOf(a.R_M_Forecast_Proposal__c) == null) a.R_M_Forecast_Proposal__c = 0;
                    if (Double.valueOf(a.R_M_Weighted_Forecast_Proposal__c) == null) a.R_M_Weighted_Forecast_Proposal__c = 0;
                    Double forecastAmt = (pfm.Forecast_Amount__c == null ? 0 : pfm.Forecast_Amount__c);
                    Double weightedForecastAmt = (pfm.Weighted_Forecast_Amount__c == null ? 0 : pfm.Weighted_Forecast_Amount__c);
                    Double bookedAmt = (pfm.Booked_Amount__c == null ? 0 : pfm.Booked_Amount__c);
                    Double actualAmt = (pfm.Actual_Amount__c == null ? 0 : pfm.Actual_Amount__c);
                    if (recordType == 'Contract'){
                    	if (!pfm.Active__c){
                    		a.Actual_Amount__c += actualAmt;
                    	} else {
                    		a.Forecast_Contract__c += forecastAmt;
                    	}
                        if (accountType == manufacturingType){
                            if (delType == audienceType){
                                if (!pfm.Active__c){
                                    a.M_A_Actual_Amount__c += actualAmt;
                                } else {
                                    a.M_A_Forecast_Contract__c += forecastAmt;
                                }
                            } else if (delType == baseType){
                                if (!pfm.Active__c){
                                    a.M_B_Actual_Amount__c += actualAmt;
                                } else {
                                    a.M_B_Forecast_Contract__c += forecastAmt;
                                }
                            } else if (delType == digitalType){
                                if (!pfm.Active__c){
                                    a.M_D_Actual_Amount__c += actualAmt;
                                } else { 
                                    a.M_D_Forecast_Contract__c += forecastAmt;
                                }
                            } else if (delType == mobileType){
                                if (!pfm.Active__c){
                                    a.M_M_Actual_Amount__c += actualAmt;
                                } else { 
                                    a.M_M_Forecast_Contract__c += forecastAmt;
                                }
                            }
                        } else if (accountType == retailType){
                            if (delType == audienceType){
                                if (!pfm.Active__c){
                                    a.R_A_Actual_Amount__c += actualAmt;
                                } else {
                                    a.R_A_Forecast_Contract__c += forecastAmt;
                                }
                            } else if (delType == baseType){
                                if (!pfm.Active__c){
                                    a.R_B_Actual_Amount__c += actualAmt;
                                } else {
                                    a.R_B_Forecast_Contract__c += forecastAmt;
                                }
                            } else if (delType == digitalType){
                                if (!pfm.Active__c){
                                    a.R_D_Actual_Amount__c += actualAmt;
                                } else {
                                    a.R_D_Forecast_Contract__c += forecastAmt;
                                }
                            } else if (delType == mobileType){
                                if (!pfm.Active__c){
                                    a.R_M_Actual_Amount__c += actualAmt;
                                } else {
                                    a.R_M_Forecast_Contract__c += forecastAmt;
                                }
                            }
                        }
                    } else {
                    	a.Forecast_Proposal__c += forecastAmt;
                        a.Weighted_Forecast_Proposal__c += weightedForecastAmt;
                        if (accountType == manufacturingType){
                            if (delType == audienceType){
                                if (pfm.Active__c){
                                    a.M_A_Forecast_Proposal__c += forecastAmt;
                                    a.M_A_Weighted_Forecast_Proposal__c += weightedForecastAmt;
                                }
                            } else if (delType == baseType){
                                if (pfm.Active__c){
                                    a.M_B_Forecast_Proposal__c += forecastAmt;
                                    a.M_B_Weighted_Forecast_Proposal__c += weightedForecastAmt;
                                }
                            } else if (delType == digitalType){
                                if (pfm.Active__c){
                                    a.M_D_Forecast_Proposal__c += forecastAmt;
                                    a.M_D_Weighted_Forecast_Proposal__c += weightedForecastAmt;
                                }
                            } else if (delType == mobileType){
                                if (pfm.Active__c){
                                    a.M_M_Forecast_Proposal__c += forecastAmt;
                                    a.M_M_Weighted_Forecast_Proposal__c += weightedForecastAmt;
                                }
                            }
                        } else if (accountType == retailType){
                            if (delType == audienceType){
                                if (pfm.Active__c){
                                    a.R_A_Forecast_Proposal__c += forecastAmt;
                                    a.R_A_Weighted_Forecast_Proposal__c += weightedForecastAmt;
                                }
                            } else if (delType == baseType){
                                if (pfm.Active__c){
                                    a.R_B_Forecast_Proposal__c += forecastAmt;
                                    a.R_B_Weighted_Forecast_Proposal__c += weightedForecastAmt;
                                }
                            } else if (delType == digitalType){
                                if (pfm.Active__c){
                                    a.R_D_Forecast_Proposal__c += forecastAmt;
                                    a.R_D_Weighted_Forecast_Proposal__c += weightedForecastAmt;
                                }
                            } else if (delType == mobileType){
                                if (pfm.Active__c){
                                    a.R_M_Forecast_Proposal__c += forecastAmt;
                                    a.R_M_Weighted_Forecast_Proposal__c += weightedForecastAmt;
                                }
                            }
                        }
                    }
                }
            }
            
        }
        
        update srbgList;
    }
    
    global void finish(Database.BatchableContext BC){
    
        System.debug(LoggingLevel.WARN,'Scheduling BatchUpdateBestGuessBooked');
        Best_Guess_Settings__c BGSettings = Best_Guess_Settings__c.getOrgDefaults();
		BGSettings.Batch_Use_Trigger__c = false;
		upsert BGSettings;
        //Build the system time of now + 20 seconds to schedule the batch apex.
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        BatchUpdateBestGuessBooked acctBatch2Sched = new BatchUpdateBestGuessBooked();
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
        BatchGovernorLimitUtility.updateBatchRun();
    }
    
    /*
    Method that accepts a string that represents a Quarter and returns the next Quarter
    param - String that represents a quarter in the form 'QQYYYY' e.g. 'Q12012'
    return - String that represents the next quarter in the form 'QQYYYY' e.g. 'Q22012'
    */
    private String getNextQuarter(String x){
        Integer q = Integer.valueOf(x.substring(1,2));
        Integer year = Integer.valueOf(x.substring(2));
        if (q == 4){
            year++;
        }
        q = math.mod(q, 4) + 1;
        return 'Q' + String.valueOf(q) + String.valueOf(year); 
    }
    
    private void populateMap(){
        srbgList = [Select Id, Name, Quarter__c, Actual_Amount__c, Forecast_Contract__c, Forecast_Proposal__c, Weighted_Forecast_Proposal__c, OwnerId,
                    M_A_Actual_Amount__c, M_A_Forecast_Contract__c, M_A_Forecast_Proposal__c, M_A_Weighted_Forecast_Proposal__c,
                    M_B_Actual_Amount__c, M_B_Forecast_Contract__c, M_B_Forecast_Proposal__c, M_B_Weighted_Forecast_Proposal__c,
                    M_D_Actual_Amount__c, M_D_Forecast_Contract__c, M_D_Forecast_Proposal__c, M_D_Weighted_Forecast_Proposal__c,
                    M_M_Actual_Amount__c, M_M_Forecast_Contract__c, M_M_Forecast_Proposal__c, M_M_Weighted_Forecast_Proposal__c,
                    R_A_Actual_Amount__c, R_A_Forecast_Contract__c, R_A_Forecast_Proposal__c, R_A_Weighted_Forecast_Proposal__c,
                    R_B_Actual_Amount__c, R_B_Forecast_Contract__c, R_B_Forecast_Proposal__c, R_B_Weighted_Forecast_Proposal__c,
                    R_D_Actual_Amount__c, R_D_Forecast_Contract__c, R_D_Forecast_Proposal__c, R_D_Weighted_Forecast_Proposal__c,
                    R_M_Actual_Amount__c, R_M_Forecast_Contract__c, R_M_Forecast_Proposal__c, R_M_Weighted_Forecast_Proposal__c
                     From Sales_Rep_Best_Guess__c Where OwnerId IN :userSet];
        
        //Map is User: Quarter
        srbgMap = new Map<Id, Map<String, Sales_Rep_Best_Guess__c>>();
        for (Sales_Rep_Best_Guess__c srbg : srbgList){
            if (!srbgMap.containsKey(srbg.OwnerId)){
                srbgMap.put(srbg.OwnerId, new Map<String, Sales_Rep_Best_Guess__c>());
            }
            if (!srbgMap.get(srbg.OwnerId).containsKey(srbg.Quarter__c)){
                srbgMap.get(srbg.OwnerId).put(srbg.Quarter__c, srbg);
            }
        }
    }
   
}