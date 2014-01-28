/*
@Name            : BatchCalculateBestGuess
@Author          : customersuccess@cloud62.com
@Date            : December 17th, 2012
@Description     : Batch Proccess to Calculate Best Guess
2013-02-05 - include errors for last year
*/
global class BatchCalculateBestGuess implements Database.Batchable<sObject>, Schedulable{
    
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
    
    public BatchCalculateBestGuess(String x){
        limit1 = x;
    }
    
    public BatchCalculateBestGuess(){
        limit1 = '';
    }
    
    global Database.querylocator start(Database.BatchableContext BC){
         BatchGovernorLimitUtility.insertBatchRun('BatchCalculateBestGuess');
        Batch_Log__c batchLog = new Batch_Log__c();
        
        batchLog.Start_Time__c = datetime.now();
        
        batchLog.Class_Name__c = 'BatchCalculateBestGuess';
        
        insert batchLog;
    
        query = 'SELECT Program__r.RecordType.Name, Actual_Amount__c, Program__r.Product_Type__c, ' + 
            'Program__r.Opportunity__r.Account.Id, Ad_Period__r.Quarter__c, Ad_Period__r.Is_Split__c, Weighted_Forecast_Amount__c, ' + 
            'Previous_Quarter_Amount__c, Oppty_Probability__c, Next_Quarter_Amount__c, Forecast_Amount__c, ' + 
            'Program__r.Opportunity__r.OwnerId, Program__r.Delivery_Type__c, Program__r.Opportunity__r.Account.RecordType.Name,  ' + 
            'Weighted_Previous_Quarter_Forecast__c, Weighted_Next_Quarter_Forecast__c, Previous_Quarter_Ratio__c, ' + 
            'Previous_Quarter_Actual__c, Active__c, Next_Quarter_Ratio__c, Next_Quarter_Actual__c ' + 
            'FROM Program_Forecast__c ' + 
            //'WHERE ' + 
            ' WHERE (PROGRAM__R.OPPORTUNITY__R.RECORDTYPE.NAME = \'CONTRACT\' OR PROGRAM__R.OPPORTUNITY__R.RECORDTYPE.NAME = \'PROPOSAL\' OR PROGRAM__R.OPPORTUNITY__R.RECORDTYPE.NAME = \'RECOVERY\' OR PROGRAM__R.OPPORTUNITY__R.RECORDTYPE.NAME = \'RENEWAL\') and (NOT(Program__r.Opportunity__r.IsWon = False and Program__r.Opportunity__r.IsClosed = True)) ' + 
            'ORDER BY Program__r.Opportunity__r.OwnerId,  Ad_Period__r.Quarter__c ' +
            limit1; 
        return Database.getQueryLocator(query);
    }
    
    global void execute(SchedulableContext ctx) {
        BatchCalculateBestGuess batch1 = new BatchCalculateBestGuess();
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
        String year1 = String.valueOf(Date.today().year());
        String year2 = String.valueOf(Date.today().year() + 1);
        //2013-02-13 add last year
    	String yearM1 = String.valueOf(Date.today().year() - 1);
        
        //store valid Forecast Users in a set and the coop userId for later use
        Set<Id> forecastUserSet = new Set<Id>();
        String coopId;
        List<User> forecastUserRoleUsers = [SELECT ID, Forecast_Role__c FROM USER WHERE FORECAST_ROLE__C != NULL];
        for (User a : forecastUserRoleUsers){
            forecastUserSet.add(a.Id);
            if (a.Forecast_Role__c == coopType) coopId = a.Id;
        }
        
        List<Program_Forecast__c> pfScope = (List<Program_Forecast__c>)scope;
        Map<String, List<Program_Forecast__c>> pfMap = new Map<String, List<Program_Forecast__c>>();
        Set<Id> userList = new Set<Id>();
        
        
        //separate Program forecasts into lists stored in a map for retrieval later when adding up totals
        for (Program_Forecast__c a : pfScope){
            String key;
            if (forecastUserSet.contains(a.Program__r.Opportunity__r.OwnerId)){
                key = a.Program__r.Opportunity__r.OwnerId + '-' + a.Ad_Period__r.Quarter__c;
            } else {
                key = coopId + '-' + a.Ad_Period__r.Quarter__c;
            }
            if (!pfMap.containsKey(key)){
                system.debug('***pf: ' + key);
                pfMap.put(key, new List<Program_Forecast__c>());
            }
            pfMap.get(key).add(a);
            
            if (a.Ad_Period__r.Is_Split__c == 'true'){
                String key1;
                if (forecastUserSet.contains(a.Program__r.Opportunity__r.OwnerId)){
                    key1 = a.Program__r.Opportunity__r.OwnerId + '-' + getNextQuarter(a.Ad_Period__r.Quarter__c);
                } else {
                    key1 = coopId + '-' + getNextQuarter(a.Ad_Period__r.Quarter__c);
                } 
                if (!pfMap.containsKey(key1)){
                    pfMap.put(key1, new List<Program_Forecast__c>());
                }
                pfMap.get(key1).add(a);
            }
            
            userList.add(a.Program__r.Opportunity__r.OwnerId);
            
        }
        
        if (coopID != null) userList.add(coopId);
        
        List<Program_Forecast_Exception__c> insertPFE = new List<Program_Forecast_Exception__c>();
        Set<Id> pfFound = new Set<Id>();
        
        //query all appropriate SRBG records so that we can add up their program Forecast amounts
        List<Sales_Rep_Best_Guess__c> insertSRBG = new List<Sales_Rep_Best_Guess__c>();
        for (Sales_Rep_Best_Guess__c a : [Select Id, Name, Quarter__c, Actual_Amount__c, Forecast_Contract__c, Forecast_Proposal__c, Weighted_Forecast_Proposal__c, OwnerId,
                    M_A_Actual_Amount__c, M_A_Forecast_Contract__c, M_A_Forecast_Proposal__c, M_A_Weighted_Forecast_Proposal__c,
                    M_B_Actual_Amount__c, M_B_Forecast_Contract__c, M_B_Forecast_Proposal__c, M_B_Weighted_Forecast_Proposal__c,
                    M_D_Actual_Amount__c, M_D_Forecast_Contract__c, M_D_Forecast_Proposal__c, M_D_Weighted_Forecast_Proposal__c,
                    M_M_Actual_Amount__c, M_M_Forecast_Contract__c, M_M_Forecast_Proposal__c, M_M_Weighted_Forecast_Proposal__c,
                    R_A_Actual_Amount__c, R_A_Forecast_Contract__c, R_A_Forecast_Proposal__c, R_A_Weighted_Forecast_Proposal__c,
                    R_B_Actual_Amount__c, R_B_Forecast_Contract__c, R_B_Forecast_Proposal__c, R_B_Weighted_Forecast_Proposal__c,
                    R_D_Actual_Amount__c, R_D_Forecast_Contract__c, R_D_Forecast_Proposal__c, R_D_Weighted_Forecast_Proposal__c,
                    R_M_Actual_Amount__c, R_M_Forecast_Contract__c, R_M_Forecast_Proposal__c, R_M_Weighted_Forecast_Proposal__c
                     From Sales_Rep_Best_Guess__c Where OwnerId IN :userList]){
            String key = a.OwnerId + '-' + a.Quarter__c;
            //set all values to 0 if they are null for any reason to avoid NPE
            if (a.M_A_Actual_Amount__c == null) a.M_A_Actual_Amount__c = 0;
            if (a.M_A_Forecast_Contract__c == null) a.M_A_Forecast_Contract__c = 0;
            if (a.M_A_Forecast_Proposal__c == null) a.M_A_Forecast_Proposal__c = 0;
            if (a.M_A_Weighted_Forecast_Proposal__c == null) a.M_A_Weighted_Forecast_Proposal__c = 0;
            if (a.M_B_Actual_Amount__c == null) a.M_B_Actual_Amount__c = 0;
            if (a.M_B_Forecast_Contract__c == null) a.M_B_Forecast_Contract__c = 0;
            if (a.M_B_Forecast_Proposal__c == null) a.M_B_Forecast_Proposal__c = 0;
            if (a.M_B_Weighted_Forecast_Proposal__c == null) a.M_B_Weighted_Forecast_Proposal__c = 0;
            if (a.M_D_Actual_Amount__c == null) a.M_D_Actual_Amount__c = 0;
            if (a.M_D_Forecast_Contract__c == null) a.M_D_Forecast_Contract__c = 0;
            if (a.M_D_Forecast_Proposal__c == null) a.M_D_Forecast_Proposal__c = 0;
            if (a.M_D_Weighted_Forecast_Proposal__c == null) a.M_D_Weighted_Forecast_Proposal__c = 0;
            if (a.M_M_Actual_Amount__c == null) a.M_M_Actual_Amount__c = 0;
            if (a.M_M_Forecast_Contract__c == null) a.M_M_Forecast_Contract__c = 0;
            if (a.M_M_Forecast_Proposal__c == null) a.M_M_Forecast_Proposal__c = 0;
            if (a.M_M_Weighted_Forecast_Proposal__c == null) a.M_M_Weighted_Forecast_Proposal__c = 0;
            if (a.R_A_Actual_Amount__c == null) a.R_A_Actual_Amount__c = 0;
            if (a.R_A_Forecast_Contract__c == null) a.R_A_Forecast_Contract__c = 0;
            if (a.R_A_Forecast_Proposal__c == null) a.R_A_Forecast_Proposal__c = 0;
            if (a.R_A_Weighted_Forecast_Proposal__c == null) a.R_A_Weighted_Forecast_Proposal__c = 0;
            if (a.R_B_Actual_Amount__c == null) a.R_B_Actual_Amount__c = 0;
            if (a.R_B_Forecast_Contract__c == null) a.R_B_Forecast_Contract__c = 0;
            if (a.R_B_Forecast_Proposal__c == null) a.R_B_Forecast_Proposal__c = 0;
            if (a.R_B_Weighted_Forecast_Proposal__c == null) a.R_B_Weighted_Forecast_Proposal__c = 0;
            if (a.R_D_Actual_Amount__c == null) a.R_D_Actual_Amount__c = 0;
            if (a.R_D_Forecast_Contract__c == null) a.R_D_Forecast_Contract__c = 0;
            if (a.R_D_Forecast_Proposal__c == null) a.R_D_Forecast_Proposal__c = 0;
            if (a.R_D_Weighted_Forecast_Proposal__c == null) a.R_D_Weighted_Forecast_Proposal__c = 0;
            if (a.R_M_Actual_Amount__c == null) a.R_M_Actual_Amount__c = 0;
            if (a.R_M_Forecast_Contract__c == null) a.R_M_Forecast_Contract__c = 0;
            if (a.R_M_Forecast_Proposal__c == null) a.R_M_Forecast_Proposal__c = 0;
            if (a.R_M_Weighted_Forecast_Proposal__c == null) a.R_M_Weighted_Forecast_Proposal__c = 0;
            //find the list of Program Forecasts that will affect this SRBG record
            //increment the appropriate field as necessary
            if (pfMap.containsKey(key)){
                for (Program_Forecast__c pf1 : pfMap.get(key)){
                    pfFound.add(pf1.Id);
                    if (pf1.Ad_Period__r.Is_Split__c == 'false'){
                        if (pf1.Active__c == false){
                            if (pf1.Previous_Quarter_Actual__c == null && pf1.Next_Quarter_Actual__c != null){
                                a.Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Next_Quarter_Actual__c);
                                if (pf1.Program__r.Opportunity__r.Account.RecordType.Name == manufacturingType){
                                    if (pf1.Program__r.Delivery_Type__c == audienceType){
                                        a.M_A_Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Next_Quarter_Actual__c);
                                    } else if (pf1.Program__r.Delivery_Type__c == baseType){
                                        a.M_B_Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Next_Quarter_Actual__c);
                                    } else if (pf1.Program__r.Delivery_Type__c == digitalType){
                                        a.M_D_Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Next_Quarter_Actual__c);
                                    } else if (pf1.Program__r.Delivery_Type__c == mobileType){
                                        a.M_M_Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Next_Quarter_Actual__c);
                                    }
                                } else if (pf1.Program__r.Opportunity__r.Account.RecordType.Name == retailType){
                                    if (pf1.Program__r.Delivery_Type__c == audienceType){
                                        a.R_A_Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Next_Quarter_Actual__c);
                                    } else if (pf1.Program__r.Delivery_Type__c == baseType){
                                        a.R_B_Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Next_Quarter_Actual__c);
                                    } else if (pf1.Program__r.Delivery_Type__c == digitalType){
                                        a.R_D_Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Next_Quarter_Actual__c);
                                    } else if (pf1.Program__r.Delivery_Type__c == mobileType){
                                        a.R_M_Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Next_Quarter_Actual__c);
                                    }
                                }
                            } else {
                                a.Actual_Amount__c += (pf1.Previous_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Previous_Quarter_Ratio__c/100 : pf1.Previous_Quarter_Actual__c);
                                if (pf1.Program__r.Opportunity__r.Account.RecordType.Name == manufacturingType){
                                    if (pf1.Program__r.Delivery_Type__c == audienceType){
                                        a.M_A_Actual_Amount__c += (pf1.Previous_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Previous_Quarter_Ratio__c/100 : pf1.Previous_Quarter_Actual__c);
                                    } else if (pf1.Program__r.Delivery_Type__c == baseType){
                                        a.M_B_Actual_Amount__c += (pf1.Previous_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Previous_Quarter_Ratio__c/100 : pf1.Previous_Quarter_Actual__c);
                                    } else if (pf1.Program__r.Delivery_Type__c == digitalType){
                                        a.M_D_Actual_Amount__c += (pf1.Previous_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Previous_Quarter_Ratio__c/100 : pf1.Previous_Quarter_Actual__c);
                                    } else if (pf1.Program__r.Delivery_Type__c == mobileType){
                                        a.M_M_Actual_Amount__c += (pf1.Previous_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Previous_Quarter_Ratio__c/100 : pf1.Previous_Quarter_Actual__c);
                                    }
                                } else if (pf1.Program__r.Opportunity__r.Account.RecordType.Name == retailType){
                                    if (pf1.Program__r.Delivery_Type__c == audienceType){
                                        a.R_A_Actual_Amount__c += (pf1.Previous_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Previous_Quarter_Ratio__c/100 : pf1.Previous_Quarter_Actual__c);
                                    } else if (pf1.Program__r.Delivery_Type__c == baseType){
                                        a.R_B_Actual_Amount__c += (pf1.Previous_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Previous_Quarter_Ratio__c/100 : pf1.Previous_Quarter_Actual__c);
                                    } else if (pf1.Program__r.Delivery_Type__c == digitalType){
                                        a.R_D_Actual_Amount__c += (pf1.Previous_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Previous_Quarter_Ratio__c/100 : pf1.Previous_Quarter_Actual__c);
                                    } else if (pf1.Program__r.Delivery_Type__c == mobileType){
                                        a.R_M_Actual_Amount__c += (pf1.Previous_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Previous_Quarter_Ratio__c/100 : pf1.Previous_Quarter_Actual__c);
                                    }
                                }
                            }
                        } else {
                            if (pf1.Program__r.RecordType.Name == 'Contract'){
                                a.Forecast_Contract__c += pf1.Forecast_Amount__c;
                                if (pf1.Program__r.Opportunity__r.Account.RecordType.Name == manufacturingType){
                                    if (pf1.Program__r.Delivery_Type__c == audienceType){
                                        a.M_A_Forecast_Contract__c += pf1.Forecast_Amount__c;
                                    } else if (pf1.Program__r.Delivery_Type__c == baseType){
                                        a.M_B_Forecast_Contract__c += pf1.Forecast_Amount__c;
                                    } else if (pf1.Program__r.Delivery_Type__c == digitalType){
                                        a.M_D_Forecast_Contract__c += pf1.Forecast_Amount__c;
                                    } else if (pf1.Program__r.Delivery_Type__c == mobileType){
                                        a.M_M_Forecast_Contract__c += pf1.Forecast_Amount__c;
                                    }
                                } else if (pf1.Program__r.Opportunity__r.Account.RecordType.Name == retailType){
                                    if (pf1.Program__r.Delivery_Type__c == audienceType){
                                        a.R_A_Forecast_Contract__c += pf1.Forecast_Amount__c;
                                    } else if (pf1.Program__r.Delivery_Type__c == baseType){
                                        a.R_B_Forecast_Contract__c += pf1.Forecast_Amount__c;
                                    } else if (pf1.Program__r.Delivery_Type__c == digitalType){
                                        a.R_D_Forecast_Contract__c += pf1.Forecast_Amount__c;
                                    } else if (pf1.Program__r.Delivery_Type__c == mobileType){
                                        a.R_M_Forecast_Contract__c += pf1.Forecast_Amount__c;
                                    }
                                }
                            } else {
                                a.Forecast_Proposal__c += pf1.Forecast_Amount__c;
                                a.Weighted_Forecast_Proposal__c += pf1.Weighted_Forecast_Amount__c;
                                if (pf1.Program__r.Opportunity__r.Account.RecordType.Name == manufacturingType){
                                    if (pf1.Program__r.Delivery_Type__c == audienceType){
                                        a.M_A_Forecast_Proposal__c += pf1.Forecast_Amount__c;
                                        a.M_A_Weighted_Forecast_Proposal__c += pf1.Weighted_Forecast_Amount__c;
                                    } else if (pf1.Program__r.Delivery_Type__c == baseType){
                                        a.M_B_Forecast_Proposal__c += pf1.Forecast_Amount__c;
                                        a.M_B_Weighted_Forecast_Proposal__c += pf1.Weighted_Forecast_Amount__c;
                                    } else if (pf1.Program__r.Delivery_Type__c == digitalType){
                                        a.M_D_Forecast_Proposal__c += pf1.Forecast_Amount__c;
                                        a.M_D_Weighted_Forecast_Proposal__c += pf1.Weighted_Forecast_Amount__c;
                                    } else if (pf1.Program__r.Delivery_Type__c == mobileType){
                                        a.M_M_Forecast_Proposal__c += pf1.Forecast_Amount__c;
                                        a.M_M_Weighted_Forecast_Proposal__c += pf1.Weighted_Forecast_Amount__c;
                                    }
                                } else if (pf1.Program__r.Opportunity__r.Account.RecordType.Name == retailType){
                                    if (pf1.Program__r.Delivery_Type__c == audienceType){
                                        a.R_A_Forecast_Proposal__c += pf1.Forecast_Amount__c;
                                        a.R_A_Weighted_Forecast_Proposal__c += pf1.Weighted_Forecast_Amount__c;
                                    } else if (pf1.Program__r.Delivery_Type__c == baseType){
                                        a.R_B_Forecast_Proposal__c += pf1.Forecast_Amount__c;
                                        a.R_B_Weighted_Forecast_Proposal__c += pf1.Weighted_Forecast_Amount__c;
                                    } else if (pf1.Program__r.Delivery_Type__c == digitalType){
                                        a.R_D_Forecast_Proposal__c += pf1.Forecast_Amount__c;
                                        a.R_D_Weighted_Forecast_Proposal__c += pf1.Weighted_Forecast_Amount__c;
                                    } else if (pf1.Program__r.Delivery_Type__c == mobileType){
                                        a.R_M_Forecast_Proposal__c += pf1.Forecast_Amount__c;
                                        a.R_M_Weighted_Forecast_Proposal__c += pf1.Weighted_Forecast_Amount__c;
                                    }
                                }
                            }
                        }
                    } else {
                        if (a.Quarter__c == pf1.Ad_Period__r.Quarter__c){
                            if ((pf1.Previous_Quarter_Amount__c == 0 && pf1.Next_Quarter_Amount__c == 0) || pf1.Previous_Quarter_Amount__c == null){
                                if (pf1.Active__c == false){
                                    if (pf1.Previous_Quarter_Actual__c == null && pf1.Next_Quarter_Actual__c != null){
                                        a.Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Next_Quarter_Actual__c);
                                        if (pf1.Program__r.Opportunity__r.Account.RecordType.Name == manufacturingType){
                                            if (pf1.Program__r.Delivery_Type__c == audienceType){
                                                a.M_A_Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Next_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == baseType){
                                                a.M_B_Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Next_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == digitalType){
                                                a.M_D_Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Next_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == mobileType){
                                                a.M_M_Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Next_Quarter_Actual__c);
                                            }
                                        } else if (pf1.Program__r.Opportunity__r.Account.RecordType.Name == retailType){
                                            if (pf1.Program__r.Delivery_Type__c == audienceType){
                                                a.R_A_Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Next_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == baseType){
                                                a.R_B_Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Next_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == digitalType){
                                                a.R_D_Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Next_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == mobileType){
                                                a.R_M_Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Next_Quarter_Actual__c);
                                            }
                                        }
                                    } else {
                                        a.Actual_Amount__c += (pf1.Previous_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Previous_Quarter_Ratio__c/100 : pf1.Previous_Quarter_Actual__c);
                                        if (pf1.Program__r.Opportunity__r.Account.RecordType.Name == manufacturingType){
                                            if (pf1.Program__r.Delivery_Type__c == audienceType){
                                                a.M_A_Actual_Amount__c += (pf1.Previous_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Previous_Quarter_Ratio__c/100 : pf1.Previous_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == baseType){
                                                a.M_B_Actual_Amount__c += (pf1.Previous_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Previous_Quarter_Ratio__c/100 : pf1.Previous_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == digitalType){
                                                a.M_D_Actual_Amount__c += (pf1.Previous_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Previous_Quarter_Ratio__c/100 : pf1.Previous_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == mobileType){
                                                a.M_M_Actual_Amount__c += (pf1.Previous_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Previous_Quarter_Ratio__c/100 : pf1.Previous_Quarter_Actual__c);
                                            }
                                        } else if (pf1.Program__r.Opportunity__r.Account.RecordType.Name == retailType){
                                            if (pf1.Program__r.Delivery_Type__c == audienceType){
                                                a.R_A_Actual_Amount__c += (pf1.Previous_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Previous_Quarter_Ratio__c/100 : pf1.Previous_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == baseType){
                                                a.R_B_Actual_Amount__c += (pf1.Previous_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Previous_Quarter_Ratio__c/100 : pf1.Previous_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == digitalType){
                                                a.R_D_Actual_Amount__c += (pf1.Previous_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Previous_Quarter_Ratio__c/100 : pf1.Previous_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == mobileType){
                                                a.R_M_Actual_Amount__c += (pf1.Previous_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Previous_Quarter_Ratio__c/100 : pf1.Previous_Quarter_Actual__c);
                                            }
                                        }
                                    }
                                } else {
                                    if (pf1.Program__r.RecordType.Name == 'Contract'){
                                        a.Forecast_Contract__c += pf1.Forecast_Amount__c*pf1.Previous_Quarter_Ratio__c/100;
                                        if (pf1.Program__r.Opportunity__r.Account.RecordType.Name == manufacturingType){
                                            if (pf1.Program__r.Delivery_Type__c == audienceType){
                                                a.M_A_Forecast_Contract__c += pf1.Forecast_Amount__c*pf1.Previous_Quarter_Ratio__c/100;
                                            } else if (pf1.Program__r.Delivery_Type__c == baseType){
                                                a.M_B_Forecast_Contract__c += pf1.Forecast_Amount__c*pf1.Previous_Quarter_Ratio__c/100;
                                            } else if (pf1.Program__r.Delivery_Type__c == digitalType){
                                                a.M_D_Forecast_Contract__c += pf1.Forecast_Amount__c*pf1.Previous_Quarter_Ratio__c/100;
                                            } else if (pf1.Program__r.Delivery_Type__c == mobileType){
                                                a.M_M_Forecast_Contract__c += pf1.Forecast_Amount__c*pf1.Previous_Quarter_Ratio__c/100;
                                            }
                                        } else if (pf1.Program__r.Opportunity__r.Account.RecordType.Name == retailType){
                                            if (pf1.Program__r.Delivery_Type__c == audienceType){
                                                a.R_A_Forecast_Contract__c += pf1.Forecast_Amount__c*pf1.Previous_Quarter_Ratio__c/100;
                                            } else if (pf1.Program__r.Delivery_Type__c == baseType){
                                                a.R_B_Forecast_Contract__c += pf1.Forecast_Amount__c*pf1.Previous_Quarter_Ratio__c/100;
                                            } else if (pf1.Program__r.Delivery_Type__c == digitalType){
                                                a.R_D_Forecast_Contract__c += pf1.Forecast_Amount__c*pf1.Previous_Quarter_Ratio__c/100;
                                            } else if (pf1.Program__r.Delivery_Type__c == mobileType){
                                                a.R_M_Forecast_Contract__c += pf1.Forecast_Amount__c*pf1.Previous_Quarter_Ratio__c/100;
                                            }
                                        }
                                    } else {
                                        a.Forecast_Proposal__c += pf1.Forecast_Amount__c*pf1.Previous_Quarter_Ratio__c/100;
                                        a.Weighted_Forecast_Proposal__c += pf1.Weighted_Forecast_Amount__c*pf1.Previous_Quarter_Ratio__c/100;
                                        if (pf1.Program__r.Opportunity__r.Account.RecordType.Name == manufacturingType){
                                            if (pf1.Program__r.Delivery_Type__c == audienceType){
                                                a.M_A_Forecast_Proposal__c += pf1.Forecast_Amount__c*pf1.Previous_Quarter_Ratio__c/100;
                                                a.M_A_Weighted_Forecast_Proposal__c += pf1.Weighted_Forecast_Amount__c*pf1.Previous_Quarter_Ratio__c/100;
                                            } else if (pf1.Program__r.Delivery_Type__c == baseType){
                                                a.M_B_Forecast_Proposal__c += pf1.Forecast_Amount__c*pf1.Previous_Quarter_Ratio__c/100;
                                                a.M_B_Weighted_Forecast_Proposal__c += pf1.Weighted_Forecast_Amount__c*pf1.Previous_Quarter_Ratio__c/100;
                                            } else if (pf1.Program__r.Delivery_Type__c == digitalType){
                                                a.M_D_Forecast_Proposal__c += pf1.Forecast_Amount__c*pf1.Previous_Quarter_Ratio__c/100;
                                                a.M_D_Weighted_Forecast_Proposal__c += pf1.Weighted_Forecast_Amount__c*pf1.Previous_Quarter_Ratio__c/100;
                                            } else if (pf1.Program__r.Delivery_Type__c == mobileType){
                                                a.M_M_Forecast_Proposal__c += pf1.Forecast_Amount__c*pf1.Previous_Quarter_Ratio__c/100;
                                                a.M_M_Weighted_Forecast_Proposal__c += pf1.Weighted_Forecast_Amount__c*pf1.Previous_Quarter_Ratio__c/100;
                                            }
                                        } else if (pf1.Program__r.Opportunity__r.Account.RecordType.Name == retailType){
                                            if (pf1.Program__r.Delivery_Type__c == audienceType){
                                                a.R_A_Forecast_Proposal__c += pf1.Forecast_Amount__c*pf1.Previous_Quarter_Ratio__c/100;
                                                a.R_A_Weighted_Forecast_Proposal__c += pf1.Weighted_Forecast_Amount__c*pf1.Previous_Quarter_Ratio__c/100;
                                            } else if (pf1.Program__r.Delivery_Type__c == baseType){
                                                a.R_B_Forecast_Proposal__c += pf1.Forecast_Amount__c*pf1.Previous_Quarter_Ratio__c/100;
                                                a.R_B_Weighted_Forecast_Proposal__c += pf1.Weighted_Forecast_Amount__c*pf1.Previous_Quarter_Ratio__c/100;
                                            } else if (pf1.Program__r.Delivery_Type__c == digitalType){
                                                a.R_D_Forecast_Proposal__c += pf1.Forecast_Amount__c*pf1.Previous_Quarter_Ratio__c/100;
                                                a.R_D_Weighted_Forecast_Proposal__c += pf1.Weighted_Forecast_Amount__c*pf1.Previous_Quarter_Ratio__c/100;
                                            } else if (pf1.Program__r.Delivery_Type__c == mobileType){
                                                a.R_M_Forecast_Proposal__c += pf1.Forecast_Amount__c*pf1.Previous_Quarter_Ratio__c/100;
                                                a.R_M_Weighted_Forecast_Proposal__c += pf1.Weighted_Forecast_Amount__c*pf1.Previous_Quarter_Ratio__c/100;
                                            }
                                        }
                                    }
                                }
                            }
                            //if split forecasts entered
                            else{
                                if (pf1.Active__c == false){
                                    if (pf1.Previous_Quarter_Actual__c == null && pf1.Next_Quarter_Actual__c != null){
                                        a.Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Next_Quarter_Actual__c);
                                        if (pf1.Program__r.Opportunity__r.Account.RecordType.Name == manufacturingType){
                                            if (pf1.Program__r.Delivery_Type__c == audienceType){
                                                a.M_A_Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Next_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == baseType){
                                                a.M_B_Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Next_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == digitalType){
                                                a.M_D_Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Next_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == mobileType){
                                                a.M_M_Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Next_Quarter_Actual__c);
                                            }
                                        } else if (pf1.Program__r.Opportunity__r.Account.RecordType.Name == retailType){
                                            if (pf1.Program__r.Delivery_Type__c == audienceType){
                                                a.R_A_Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Next_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == baseType){
                                                a.R_B_Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Next_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == digitalType){
                                                a.R_D_Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Next_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == mobileType){
                                                a.R_M_Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Next_Quarter_Actual__c);
                                            }
                                        }
                                    } else {
                                        a.Actual_Amount__c += (pf1.Previous_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Previous_Quarter_Ratio__c/100 : pf1.Previous_Quarter_Actual__c);
                                        if (pf1.Program__r.Opportunity__r.Account.RecordType.Name == manufacturingType){
                                            if (pf1.Program__r.Delivery_Type__c == audienceType){
                                                a.M_A_Actual_Amount__c += (pf1.Previous_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Previous_Quarter_Ratio__c/100 : pf1.Previous_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == baseType){
                                                a.M_B_Actual_Amount__c += (pf1.Previous_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Previous_Quarter_Ratio__c/100 : pf1.Previous_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == digitalType){
                                                a.M_D_Actual_Amount__c += (pf1.Previous_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Previous_Quarter_Ratio__c/100 : pf1.Previous_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == mobileType){
                                                a.M_M_Actual_Amount__c += (pf1.Previous_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Previous_Quarter_Ratio__c/100 : pf1.Previous_Quarter_Actual__c);
                                            }
                                        } else if (pf1.Program__r.Opportunity__r.Account.RecordType.Name == retailType){
                                            if (pf1.Program__r.Delivery_Type__c == audienceType){
                                                a.R_A_Actual_Amount__c += (pf1.Previous_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Previous_Quarter_Ratio__c/100 : pf1.Previous_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == baseType){
                                                a.R_B_Actual_Amount__c += (pf1.Previous_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Previous_Quarter_Ratio__c/100 : pf1.Previous_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == digitalType){
                                                a.R_D_Actual_Amount__c += (pf1.Previous_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Previous_Quarter_Ratio__c/100 : pf1.Previous_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == mobileType){
                                                a.R_M_Actual_Amount__c += (pf1.Previous_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Previous_Quarter_Ratio__c/100 : pf1.Previous_Quarter_Actual__c);
                                            }
                                        }
                                        
                                    }
                                } else {
                                    if (pf1.Program__r.RecordType.Name == 'Contract'){
                                        a.Forecast_Contract__c += pf1.Previous_Quarter_Amount__c;
                                        if (pf1.Program__r.Opportunity__r.Account.RecordType.Name == manufacturingType){
                                            if (pf1.Program__r.Delivery_Type__c == audienceType){
                                                a.M_A_Forecast_Contract__c += pf1.Previous_Quarter_Amount__c;
                                            } else if (pf1.Program__r.Delivery_Type__c == baseType){
                                                a.M_B_Forecast_Contract__c += pf1.Previous_Quarter_Amount__c;
                                            } else if (pf1.Program__r.Delivery_Type__c == digitalType){
                                                a.M_D_Forecast_Contract__c += pf1.Previous_Quarter_Amount__c;
                                            } else if (pf1.Program__r.Delivery_Type__c == mobileType){
                                                a.M_M_Forecast_Contract__c += pf1.Previous_Quarter_Amount__c;
                                            }
                                        } else if (pf1.Program__r.Opportunity__r.Account.RecordType.Name == retailType){
                                            if (pf1.Program__r.Delivery_Type__c == audienceType){
                                                a.R_A_Forecast_Contract__c += pf1.Previous_Quarter_Amount__c;
                                            } else if (pf1.Program__r.Delivery_Type__c == baseType){
                                                a.R_B_Forecast_Contract__c += pf1.Previous_Quarter_Amount__c;
                                            } else if (pf1.Program__r.Delivery_Type__c == digitalType){
                                                a.R_D_Forecast_Contract__c += pf1.Previous_Quarter_Amount__c;
                                            } else if (pf1.Program__r.Delivery_Type__c == mobileType){
                                                a.R_M_Forecast_Contract__c += pf1.Previous_Quarter_Amount__c;
                                            }
                                        }
                                    } else {
                                        a.Forecast_Proposal__c += pf1.Previous_Quarter_Amount__c;
                                        a.Weighted_Forecast_Proposal__c += pf1.Weighted_Previous_Quarter_Forecast__c;
                                        if (pf1.Program__r.Opportunity__r.Account.RecordType.Name == manufacturingType){
                                            if (pf1.Program__r.Delivery_Type__c == audienceType){
                                                a.M_A_Forecast_Proposal__c += pf1.Previous_Quarter_Amount__c;
                                                a.M_A_Weighted_Forecast_Proposal__c += pf1.Weighted_Previous_Quarter_Forecast__c;
                                            } else if (pf1.Program__r.Delivery_Type__c == baseType){
                                                a.M_B_Forecast_Proposal__c += pf1.Previous_Quarter_Amount__c;
                                                a.M_B_Weighted_Forecast_Proposal__c += pf1.Weighted_Previous_Quarter_Forecast__c;
                                            } else if (pf1.Program__r.Delivery_Type__c == digitalType){
                                                a.M_D_Forecast_Proposal__c += pf1.Previous_Quarter_Amount__c;
                                                a.M_D_Weighted_Forecast_Proposal__c += pf1.Weighted_Previous_Quarter_Forecast__c;
                                            } else if (pf1.Program__r.Delivery_Type__c == mobileType){
                                                a.M_M_Forecast_Proposal__c += pf1.Previous_Quarter_Amount__c;
                                                a.M_M_Weighted_Forecast_Proposal__c += pf1.Weighted_Previous_Quarter_Forecast__c;
                                            }
                                        } else if (pf1.Program__r.Opportunity__r.Account.RecordType.Name == retailType){
                                            if (pf1.Program__r.Delivery_Type__c == audienceType){
                                                a.R_A_Forecast_Proposal__c += pf1.Previous_Quarter_Amount__c;
                                                a.R_A_Weighted_Forecast_Proposal__c += pf1.Weighted_Previous_Quarter_Forecast__c;
                                            } else if (pf1.Program__r.Delivery_Type__c == baseType){
                                                a.R_B_Forecast_Proposal__c += pf1.Previous_Quarter_Amount__c;
                                                a.R_B_Weighted_Forecast_Proposal__c += pf1.Weighted_Previous_Quarter_Forecast__c;
                                            } else if (pf1.Program__r.Delivery_Type__c == digitalType){
                                                a.R_D_Forecast_Proposal__c += pf1.Previous_Quarter_Amount__c;
                                                a.R_D_Weighted_Forecast_Proposal__c += pf1.Weighted_Previous_Quarter_Forecast__c;
                                            } else if (pf1.Program__r.Delivery_Type__c == mobileType){
                                                a.R_M_Forecast_Proposal__c += pf1.Previous_Quarter_Amount__c;
                                                a.R_M_Weighted_Forecast_Proposal__c += pf1.Weighted_Previous_Quarter_Forecast__c;
                                            }
                                        }
                                    }
                                }
                            } 
                        } else {
                            if ((pf1.Previous_Quarter_Amount__c == 0 && pf1.Next_Quarter_Amount__c == 0) || pf1.Next_Quarter_Amount__c == null){
                                if (pf1.Active__c == false){
                                    if (pf1.Next_Quarter_Actual__c == null && pf1.Previous_Quarter_Actual__c != null){
                                        a.Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Previous_Quarter_Actual__c);
                                        if (pf1.Program__r.Opportunity__r.Account.RecordType.Name == manufacturingType){
                                            if (pf1.Program__r.Delivery_Type__c == audienceType){
                                                a.M_A_Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Previous_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == baseType){
                                                a.M_B_Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Previous_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == digitalType){
                                                a.M_D_Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Previous_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == mobileType){
                                                a.M_M_Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Previous_Quarter_Actual__c);
                                            }
                                        } else if (pf1.Program__r.Opportunity__r.Account.RecordType.Name == retailType){
                                            if (pf1.Program__r.Delivery_Type__c == audienceType){
                                                a.R_A_Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Previous_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == baseType){
                                                a.R_B_Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Previous_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == digitalType){
                                                a.R_D_Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Previous_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == mobileType){
                                                a.R_M_Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Previous_Quarter_Actual__c);
                                            }
                                        }
                                    } else {
                                        a.Actual_Amount__c += (pf1.Next_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Next_Quarter_Ratio__c/100 : pf1.Next_Quarter_Actual__c);
                                        if (pf1.Program__r.Opportunity__r.Account.RecordType.Name == manufacturingType){
                                            if (pf1.Program__r.Delivery_Type__c == audienceType){
                                                a.M_A_Actual_Amount__c += (pf1.Next_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Next_Quarter_Ratio__c/100 : pf1.Next_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == baseType){
                                                a.M_B_Actual_Amount__c += (pf1.Next_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Next_Quarter_Ratio__c/100 : pf1.Next_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == digitalType){
                                                a.M_D_Actual_Amount__c += (pf1.Next_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Next_Quarter_Ratio__c/100 : pf1.Next_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == mobileType){
                                                a.M_M_Actual_Amount__c += (pf1.Next_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Next_Quarter_Ratio__c/100 : pf1.Next_Quarter_Actual__c);
                                            }
                                        } else if (pf1.Program__r.Opportunity__r.Account.RecordType.Name == retailType){
                                            if (pf1.Program__r.Delivery_Type__c == audienceType){
                                                a.R_A_Actual_Amount__c += (pf1.Next_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Next_Quarter_Ratio__c/100 : pf1.Next_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == baseType){
                                                a.R_B_Actual_Amount__c += (pf1.Next_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Next_Quarter_Ratio__c/100 : pf1.Next_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == digitalType){
                                                a.R_D_Actual_Amount__c += (pf1.Next_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Next_Quarter_Ratio__c/100 : pf1.Next_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == mobileType){
                                                a.R_M_Actual_Amount__c += (pf1.Next_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Next_Quarter_Ratio__c/100 : pf1.Next_Quarter_Actual__c);
                                            }
                                        }
                                    }
                                } else {
                                    if (pf1.Program__r.RecordType.Name == 'Contract'){
                                        a.Forecast_Contract__c += pf1.Forecast_Amount__c*pf1.Next_Quarter_Ratio__c/100;
                                        if (pf1.Program__r.Opportunity__r.Account.RecordType.Name == manufacturingType){
                                            if (pf1.Program__r.Delivery_Type__c == audienceType){
                                                a.M_A_Forecast_Contract__c += pf1.Forecast_Amount__c*pf1.Next_Quarter_Ratio__c/100;
                                            } else if (pf1.Program__r.Delivery_Type__c == baseType){
                                                a.M_B_Forecast_Contract__c += pf1.Forecast_Amount__c*pf1.Next_Quarter_Ratio__c/100;
                                            } else if (pf1.Program__r.Delivery_Type__c == digitalType){
                                                a.M_D_Forecast_Contract__c += pf1.Forecast_Amount__c*pf1.Next_Quarter_Ratio__c/100;
                                            } else if (pf1.Program__r.Delivery_Type__c == mobileType){
                                                a.M_M_Forecast_Contract__c += pf1.Forecast_Amount__c*pf1.Next_Quarter_Ratio__c/100;
                                            }
                                        } else if (pf1.Program__r.Opportunity__r.Account.RecordType.Name == retailType){
                                            if (pf1.Program__r.Delivery_Type__c == audienceType){
                                                a.R_A_Forecast_Contract__c += pf1.Forecast_Amount__c*pf1.Next_Quarter_Ratio__c/100;
                                            } else if (pf1.Program__r.Delivery_Type__c == baseType){
                                                a.R_B_Forecast_Contract__c += pf1.Forecast_Amount__c*pf1.Next_Quarter_Ratio__c/100;
                                            } else if (pf1.Program__r.Delivery_Type__c == digitalType){
                                                a.R_D_Forecast_Contract__c += pf1.Forecast_Amount__c*pf1.Next_Quarter_Ratio__c/100;
                                            } else if (pf1.Program__r.Delivery_Type__c == mobileType){
                                                a.R_M_Forecast_Contract__c += pf1.Forecast_Amount__c*pf1.Next_Quarter_Ratio__c/100;
                                            }
                                        }
                                    } else {
                                        a.Forecast_Proposal__c += pf1.Forecast_Amount__c*pf1.Next_Quarter_Ratio__c/100;
                                        a.Weighted_Forecast_Proposal__c += pf1.Weighted_Forecast_Amount__c*pf1.Next_Quarter_Ratio__c/100;
                                        if (pf1.Program__r.Opportunity__r.Account.RecordType.Name == manufacturingType){
                                            if (pf1.Program__r.Delivery_Type__c == audienceType){
                                                a.M_A_Forecast_Proposal__c += pf1.Forecast_Amount__c*pf1.Next_Quarter_Ratio__c/100;
                                                a.M_A_Weighted_Forecast_Proposal__c += pf1.Weighted_Forecast_Amount__c*pf1.Next_Quarter_Ratio__c/100;
                                            } else if (pf1.Program__r.Delivery_Type__c == baseType){
                                                a.M_B_Forecast_Proposal__c += pf1.Forecast_Amount__c*pf1.Next_Quarter_Ratio__c/100;
                                                a.M_B_Weighted_Forecast_Proposal__c += pf1.Weighted_Forecast_Amount__c*pf1.Next_Quarter_Ratio__c/100;
                                            } else if (pf1.Program__r.Delivery_Type__c == digitalType){
                                                a.M_D_Forecast_Proposal__c += pf1.Forecast_Amount__c*pf1.Next_Quarter_Ratio__c/100;
                                                a.M_D_Weighted_Forecast_Proposal__c += pf1.Weighted_Forecast_Amount__c*pf1.Next_Quarter_Ratio__c/100;
                                            } else if (pf1.Program__r.Delivery_Type__c == mobileType){
                                                a.M_M_Forecast_Proposal__c += pf1.Forecast_Amount__c*pf1.Next_Quarter_Ratio__c/100;
                                                a.M_M_Weighted_Forecast_Proposal__c += pf1.Weighted_Forecast_Amount__c*pf1.Next_Quarter_Ratio__c/100;
                                            }
                                        } else if (pf1.Program__r.Opportunity__r.Account.RecordType.Name == retailType){
                                            if (pf1.Program__r.Delivery_Type__c == audienceType){
                                                a.R_A_Forecast_Proposal__c += pf1.Forecast_Amount__c*pf1.Next_Quarter_Ratio__c/100;
                                                a.R_A_Weighted_Forecast_Proposal__c += pf1.Weighted_Forecast_Amount__c*pf1.Next_Quarter_Ratio__c/100;
                                            } else if (pf1.Program__r.Delivery_Type__c == baseType){
                                                a.R_B_Forecast_Proposal__c += pf1.Forecast_Amount__c*pf1.Next_Quarter_Ratio__c/100;
                                                a.R_B_Weighted_Forecast_Proposal__c += pf1.Weighted_Forecast_Amount__c*pf1.Next_Quarter_Ratio__c/100;
                                            } else if (pf1.Program__r.Delivery_Type__c == digitalType){
                                                a.R_D_Forecast_Proposal__c += pf1.Forecast_Amount__c*pf1.Next_Quarter_Ratio__c/100;
                                                a.R_D_Weighted_Forecast_Proposal__c += pf1.Weighted_Forecast_Amount__c*pf1.Next_Quarter_Ratio__c/100;
                                            } else if (pf1.Program__r.Delivery_Type__c == mobileType){
                                                a.R_M_Forecast_Proposal__c += pf1.Forecast_Amount__c*pf1.Next_Quarter_Ratio__c/100;
                                                a.R_M_Weighted_Forecast_Proposal__c += pf1.Weighted_Forecast_Amount__c*pf1.Next_Quarter_Ratio__c/100;
                                            }
                                        }
                                    }
                                }
                            }
                            //if split forecasts entered
                            else{
                                if (pf1.Active__c == false){
                                    if (pf1.Next_Quarter_Actual__c == null && pf1.Previous_Quarter_Actual__c != null){
                                        a.Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Previous_Quarter_Actual__c);
                                        if (pf1.Program__r.Opportunity__r.Account.RecordType.Name == manufacturingType){
                                            if (pf1.Program__r.Delivery_Type__c == audienceType){
                                                a.M_A_Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Previous_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == baseType){
                                                a.M_B_Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Previous_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == digitalType){
                                                a.M_D_Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Previous_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == mobileType){
                                                a.M_M_Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Previous_Quarter_Actual__c);
                                            }
                                        } else if (pf1.Program__r.Opportunity__r.Account.RecordType.Name == retailType){
                                            if (pf1.Program__r.Delivery_Type__c == audienceType){
                                                a.R_A_Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Previous_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == baseType){
                                                a.R_B_Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Previous_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == digitalType){
                                                a.R_D_Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Previous_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == mobileType){
                                                a.R_M_Actual_Amount__c += (pf1.Actual_Amount__c - pf1.Previous_Quarter_Actual__c);
                                            }
                                        }
                                    } else {
                                        a.Actual_Amount__c += (pf1.Next_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Next_Quarter_Ratio__c/100 : pf1.Next_Quarter_Actual__c);
                                        if (pf1.Program__r.Opportunity__r.Account.RecordType.Name == manufacturingType){
                                            if (pf1.Program__r.Delivery_Type__c == audienceType){
                                                a.M_A_Actual_Amount__c += (pf1.Next_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Next_Quarter_Ratio__c/100 : pf1.Next_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == baseType){
                                                a.M_B_Actual_Amount__c += (pf1.Next_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Next_Quarter_Ratio__c/100 : pf1.Next_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == digitalType){
                                                a.M_D_Actual_Amount__c += (pf1.Next_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Next_Quarter_Ratio__c/100 : pf1.Next_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == mobileType){
                                                a.M_M_Actual_Amount__c += (pf1.Next_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Next_Quarter_Ratio__c/100 : pf1.Next_Quarter_Actual__c);
                                            }
                                        } else if (pf1.Program__r.Opportunity__r.Account.RecordType.Name == retailType){
                                            if (pf1.Program__r.Delivery_Type__c == audienceType){
                                                a.R_A_Actual_Amount__c += (pf1.Next_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Next_Quarter_Ratio__c/100 : pf1.Next_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == baseType){
                                                a.R_B_Actual_Amount__c += (pf1.Next_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Next_Quarter_Ratio__c/100 : pf1.Next_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == digitalType){
                                                a.R_D_Actual_Amount__c += (pf1.Next_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Next_Quarter_Ratio__c/100 : pf1.Next_Quarter_Actual__c);
                                            } else if (pf1.Program__r.Delivery_Type__c == mobileType){
                                                a.R_M_Actual_Amount__c += (pf1.Next_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Next_Quarter_Ratio__c/100 : pf1.Next_Quarter_Actual__c);
                                            }
                                        }
                                    }
                                } else {
                                    if (pf1.Program__r.RecordType.Name == 'Contract'){
                                        a.Forecast_Contract__c += pf1.Next_Quarter_Amount__c;
                                        if (pf1.Program__r.Opportunity__r.Account.RecordType.Name == manufacturingType){
                                            if (pf1.Program__r.Delivery_Type__c == audienceType){
                                                a.M_A_Forecast_Contract__c += pf1.Next_Quarter_Amount__c;
                                            } else if (pf1.Program__r.Delivery_Type__c == baseType){
                                                a.M_B_Forecast_Contract__c += pf1.Next_Quarter_Amount__c;
                                            } else if (pf1.Program__r.Delivery_Type__c == digitalType){
                                                a.M_D_Forecast_Contract__c += pf1.Next_Quarter_Amount__c;
                                            } else if (pf1.Program__r.Delivery_Type__c == mobileType){
                                                a.M_M_Forecast_Contract__c += pf1.Next_Quarter_Amount__c;
                                            }
                                        } else if (pf1.Program__r.Opportunity__r.Account.RecordType.Name == retailType){
                                            if (pf1.Program__r.Delivery_Type__c == audienceType){
                                                a.R_A_Forecast_Contract__c += pf1.Next_Quarter_Amount__c;
                                            } else if (pf1.Program__r.Delivery_Type__c == baseType){
                                                a.R_B_Forecast_Contract__c += pf1.Next_Quarter_Amount__c;
                                            } else if (pf1.Program__r.Delivery_Type__c == digitalType){
                                                a.R_D_Forecast_Contract__c += pf1.Next_Quarter_Amount__c;
                                            } else if (pf1.Program__r.Delivery_Type__c == mobileType){
                                                a.R_M_Forecast_Contract__c += pf1.Next_Quarter_Amount__c;
                                            }
                                        }
                                    } else {
                                        a.Forecast_Proposal__c += pf1.Next_Quarter_Amount__c;
                                        a.Weighted_Forecast_Proposal__c += pf1.Weighted_Next_Quarter_Forecast__c;
                                        if (pf1.Program__r.Opportunity__r.Account.RecordType.Name == manufacturingType){
                                            if (pf1.Program__r.Delivery_Type__c == audienceType){
                                                a.M_A_Forecast_Proposal__c += pf1.Next_Quarter_Amount__c;
                                                a.M_A_Weighted_Forecast_Proposal__c += pf1.Weighted_Next_Quarter_Forecast__c;
                                            } else if (pf1.Program__r.Delivery_Type__c == baseType){
                                                a.M_B_Forecast_Proposal__c += pf1.Next_Quarter_Amount__c;
                                                a.M_B_Weighted_Forecast_Proposal__c += pf1.Weighted_Next_Quarter_Forecast__c;
                                            } else if (pf1.Program__r.Delivery_Type__c == digitalType){
                                                a.M_D_Forecast_Proposal__c += pf1.Next_Quarter_Amount__c;
                                                a.M_D_Weighted_Forecast_Proposal__c += pf1.Weighted_Next_Quarter_Forecast__c;
                                            } else if (pf1.Program__r.Delivery_Type__c == mobileType){
                                                a.M_M_Forecast_Proposal__c += pf1.Next_Quarter_Amount__c;
                                                a.M_M_Weighted_Forecast_Proposal__c += pf1.Weighted_Next_Quarter_Forecast__c;
                                            }
                                        } else if (pf1.Program__r.Opportunity__r.Account.RecordType.Name == retailType){
                                            if (pf1.Program__r.Delivery_Type__c == audienceType){
                                                a.R_A_Forecast_Proposal__c += pf1.Next_Quarter_Amount__c;
                                                a.R_A_Weighted_Forecast_Proposal__c += pf1.Weighted_Next_Quarter_Forecast__c;
                                            } else if (pf1.Program__r.Delivery_Type__c == baseType){
                                                a.R_B_Forecast_Proposal__c += pf1.Next_Quarter_Amount__c;
                                                a.R_B_Weighted_Forecast_Proposal__c += pf1.Weighted_Next_Quarter_Forecast__c;
                                            } else if (pf1.Program__r.Delivery_Type__c == digitalType){
                                                a.R_D_Forecast_Proposal__c += pf1.Next_Quarter_Amount__c;
                                                a.R_D_Weighted_Forecast_Proposal__c += pf1.Weighted_Next_Quarter_Forecast__c;
                                            } else if (pf1.Program__r.Delivery_Type__c == mobileType){
                                                a.R_M_Forecast_Proposal__c += pf1.Next_Quarter_Amount__c;
                                                a.R_M_Weighted_Forecast_Proposal__c += pf1.Weighted_Next_Quarter_Forecast__c;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                insertSRBG.add(a);
            }
        }
        
        update insertSRBG;
        
        //store all records that did not have a BG record to increment as an exception
        for (Program_Forecast__c a : pfScope){
            if (!pfFound.contains(a.Id)){
                if (a.Ad_Period__r.Quarter__c.contains(year2) || a.Ad_Period__r.Quarter__c.contains(year1)
                //add logic to include last year
                || a.Ad_Period__r.Quarter__c.contains(yearM1)){
                    Program_Forecast_Exception__c pfe = new Program_Forecast_Exception__c();
                    pfe.Program_Forecast__c = a.Id;
                    pfe.Reason__c = 'not found - BG';
                    insertPFE.add(pfe);
                }
            }
        }
        
        insert insertPFE;
        BatchGovernorLimitUtility.calcualteLimits(Limits.getCpuTime(), Limits.getDMLRows(), Limits.getDMLStatements(), Limits.getHeapSize(), Limits.getQueries(), Limits.getQueryRows(), Limits.getScriptStatements(), scope, currentTime, System.now());
    }
    
    global void finish(Database.BatchableContext BC){
        
       List<Batch_Log__c> batchLog = [select ID from Batch_Log__c where Class_Name__c = 'BatchCalculateBestGuess' AND Start_Time__c >: datetime.now().addDays(-1) ORDER BY Start_Time__c desc limit 1];
        
        if(batchLog.size() == 1)
        {
        
        batchLog[0].Finish_Time__c = datetime.now();
        
        batchLog[0].Successful__c = true;
        
        update batchLog[0];
        
        }
    
        System.debug(LoggingLevel.WARN,'Temp_Delete_DeleteSM1Forecast');
        //Build the system time of now + 20 seconds to schedule the batch apex.
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        BatchAssociateFY acctBatch2Sched = new BatchAssociateFY();
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

}