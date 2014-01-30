/*
@Name            : BatchAssociateRepFY  
@Author          : customersuccess@cloud62.com
@Date            : December 17th, 2012
@Description     : Batch Proccess to Associate Rep FY's
*/
global class BatchAssociateRepFY  implements Database.Batchable<sObject>, Schedulable{
    
    final static String q1Start = '-01-01';
    final static String q2Start = '-04-01';
    final static String q3Start = '-07-01';
    final static String q4Start = '-10-01';
    final static String q1End = '-03-31';
    final static String q2End = '-06-30';
    final static String q3End = '-09-30';
    final static String q4End = '-12-31';
    final static String defaultSettingsName = 'Default';
    
    String query;
    String limit1;
    //custom settings variables
    Catalina_Forecast_Settings__c settings;
    String rep2Type;
    String rep1Type;
    String SM2Type;
    String SM1Type;
    String coopType;
    String baseType;
    String digitalType;
    String audienceType;
    String mobileType;
    
    List<Rep_2_Forecast__c> rep2;
    List<Rep_1_Forecast__c> rep1;
    List<Sales_Manager_2_Forecast__c> sm2;
    List<Sales_Manager_1_Forecast__c> sm1;
    Set<ID> accountList;
    Set<Id> userList;
    Set<ID> programList;
    Map<Id, User> Rep2Map;
    Map<Id, User> Rep1Map;
    Map<Id, User> SM2Map;
    Map<Id, User> SM1Map;
    Map<Id, User> userMap;
    List<Rep_2_Forecast__c> insertRep2;
    List<Rep_1_Forecast__c> insertRep1;
    List<Sales_Manager_2_Forecast__c> insertSM2;
    List<Sales_Manager_1_Forecast__c> insertSM1;
    List<User> Rep2Managers;
    List<User> Rep1Managers;
    List<User> SM2Managers;
    List<User> SM1Managers;
    
    public BatchAssociateRepFY(String x){
        limit1 = x;
    }
    
    public BatchAssociateRepFY(){
        limit1 = '';
    }
    
    global void execute(SchedulableContext ctx) {
        BatchAssociateRepFY batch1 = new BatchAssociateRepFY();
        //2013-02-13 Change batch size to 25
        ID batchprocessid = Database.executeBatch(batch1,25);
    }
    
    global Database.querylocator start(Database.BatchableContext BC){
        BatchGovernorLimitUtility.insertBatchRun('BatchAssociateRepFY');
        query = query = 'SELECT ID, Name, OWNER__c, Account__c, QUARTER__C, My_Total_Actual__c, Total_Actual__c, '
            +'(Select ID, Owner__c, Quarter__c, Account__c, Total_Actual__c From Rep_2_FY_Totals__r) From Rep_1_FY_Total__c Order By Owner__c, Account__c '
            + limit1;
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        Datetime currentTime = System.now();
        settings = Catalina_Forecast_Settings__c.getInstance(defaultSettingsName);
        rep2Type = settings.Rep_2_String__c;
        rep1Type = settings.Rep_1_String__c;
        SM2Type = settings.SM_2_String__c;
        SM1Type = settings.SM_1_String__c;
        coopType = settings.Coop_String__c;
        baseType = settings.Base_Delivery_Type__c;
        digitalType = settings.Digital_Delivery_Type__c;
        audienceType = settings.Display_Delivery_Type__c;
        mobileType = settings.Mobile_Delivery_Type__c;
        
        List<Rep_1_FY_Total__c> rep1Scope = (List<Rep_1_FY_Total__c>)scope;
        List<Rep_2_FY_Total__c> rep2Scope = new List<Rep_2_FY_Total__c>();
        Set<String> rep1Set = new Set<String>();
        Set<String> rep1SummaryStrings = new Set<String>();
        Set<String> rep2Set = new Set<String>();
        Set<String> rep2SummaryStrings = new Set<String>();
        accountList = new Set<Id>();
        userList = new Set<Id>();
        Rep2Map = new Map<Id, User>();
        Rep1Map = new Map<Id, User>();
        SM2Map = new Map<Id, User>();
        SM1Map = new Map<Id, User>();
        List<Rep_1_Forecast__c> updateRep1 = new List<Rep_1_Forecast__c>();
        List<Rep_2_Forecast__c> updateRep2 = new List<Rep_2_Forecast__c>();
        
        //bucket users by Forecast Role
        List<User> allUsers = [SELECT ID, Forecast_Role__c, FirstName, LastName,  UserRole.Name, ManagerId FROM USER WHERE Forecast_Role__c != NULL And ManagerID  != NULL];
        userMap = new Map<Id, User>();
        //get Sales Rep 2s that need to be created or should already exist
        Rep2Managers = new List<User>();
        for (User a : allUsers){
            userMap.put(a.Id, a);
            if (a.Forecast_Role__c == rep2Type){
                Rep2Managers.add(a);
                rep2Map.put(a.Id, a);
            }
        }
        //get Sales Rep 1s that need to be created or should already exist
        Rep1Managers = new List<User>();
        for (User a : allUsers){
            if (a.Forecast_Role__c == rep1Type){
                Rep1Managers.add(a);
                rep1Map.put(a.Id, a);
            }
        }
        //get Sales Manager 2s that need to be created or should already exist
        SM2Managers = new List<User>();
        for (User a : allUsers){
            if (a.Forecast_Role__c == SM2Type){
                SM2Managers.add(a);
                SM2Map.put(a.Id, a);
            }
        }
        //get Sales Manager 1s that need to be created or should already exist
        SM1Managers = new List<User>();
        for (User a : allUsers){
            if (a.Forecast_Role__c == SM1Type || a.Forecast_Role__c == coopType){
                SM1Managers.add(a);
                SM1Map.put(a.Id, a);
            }
        }
        
        //get a set of all records in this batch that we will need to associate
        for (Rep_1_FY_Total__c a : rep1Scope){
            String key = a.Owner__c + '-' + getNY(a.Quarter__c) + '-' + a.Account__c;
            rep1Set.add(key);
            userList.add(a.Owner__c);
            accountList.add(a.Account__c);
            
            for (Rep_2_FY_Total__c b : a.Rep_2_FY_Totals__r){
                String key2 = b.Owner__c + '-' + getNY(b.Quarter__c) + '-' + b.Account__c;
                rep2Set.add(key2);
                userList.add(b.Owner__c);
                accountList.add(b.Account__c);
                rep2Scope.add(b);
            }
            
        }
        
        for (String x : userList){
            getManager(x);
        }
        
        Map<Id, Account> accountMap = new Map<Id, Account>();
        for (Account a : [SELECT ID, RecordType.Name, RecordTypeId From Account Where Id IN :accountList]){
            accountMap.put(a.Id, a);
        }
        
        //for each unique set, construct a string for each delivery type as we will need to
        //associate a forecasting report object for each delivery type
        for (String x : rep2Set){
            String tempAcc = x.substring(x.indexOf('-') + 1);
            tempAcc = tempAcc.substring(tempAcc.indexOf('-') + 1);
            rep2SummaryStrings.add(x + '-' + accountMap.get(tempAcc).RecordType.Name + '-' + baseType + '-NA');
            rep2SummaryStrings.add(x + '-' + accountMap.get(tempAcc).RecordType.Name + '-' + digitalType + '-NA');
            rep2SummaryStrings.add(x + '-' + accountMap.get(tempAcc).RecordType.Name + '-' + audienceType + '-NA');
            rep2SummaryStrings.add(x + '-' + accountMap.get(tempAcc).RecordType.Name + '-' + mobileType + '-NA');
        }
        
        for (String x : rep1Set){
            String tempAcc = x.substring(x.indexOf('-') + 1);
            tempAcc = tempAcc.substring(tempAcc.indexOf('-') + 1);
            rep1SummaryStrings.add(x + '-' + accountMap.get(tempAcc).RecordType.Name + '-' + baseType + '-NA');
            rep1SummaryStrings.add(x + '-' + accountMap.get(tempAcc).RecordType.Name + '-' + digitalType + '-NA');
            rep1SummaryStrings.add(x + '-' + accountMap.get(tempAcc).RecordType.Name + '-' + audienceType + '-NA');
            rep1SummaryStrings.add(x + '-' + accountMap.get(tempAcc).RecordType.Name + '-' + mobileType + '-NA');
        }
        /*
        for (String x : rep1SummaryStrings){
            system.debug(LoggingLevel.Warn, '*** ' + x);
        }
        
        for (String x: accountList){
            system.debug(LoggingLevel.Warn, '*** ' + x);
        }
        for (Rep_1_Forecast__c a : rep1){
            system.debug(LoggingLevel.Warn, '***rep1 ' + a.Id);
        }*/
        //insert any records that are missing, must insert at the top level then work your way down
        refreshForecasts();
        clearInsertLists();
        for (String x : rep1SummaryStrings){
            createRep1Forecast(x);
        }
        insert insertSM1;
        refreshForecasts();
        clearInsertLists();
        for (String x : rep1SummaryStrings){
            createRep1Forecast(x);
        }
        insert insertSM2;
        refreshForecasts();
        clearInsertLists();
        for (String x : rep1SummaryStrings){
            createRep1Forecast(x);
        }
        insert insertRep1;
        
        refreshForecasts();
        clearInsertLists();
        for (String x : rep2SummaryStrings){
            createRep2Forecast(x);
        }
        insert insertSM1;
        refreshForecasts();
        clearInsertLists();
        for (String x : rep2SummaryStrings){
            createRep2Forecast(x);
        }
        insert insertSM2;
        refreshForecasts();
        clearInsertLists();
        for (String x : rep2SummaryStrings){
            createRep2Forecast(x);
        }
        insert insertRep1;
        refreshForecasts();
        clearInsertLists();
        for (String x : rep2SummaryStrings){
            createRep2Forecast(x);
        }
        insert insertRep2;
        
        Set<String> delTypes = new Set<String>();
        delTypes.add(baseType);
        delTypes.add(digitalType);
        delTypes.add(audienceType);
        delTypes.add(mobileType);
        
        //for each FY Total records, find the matching forecast record and create the association
        for (Rep_1_FY_Total__c a : rep1Scope){
            for (String delType: delTypes){
                Boolean found = false;
                for (Rep_1_Forecast__c b : rep1){
                    if (a.Owner__c == b.OwnerId && a.Account__c == b.Account__c && a.Quarter__c == getPY(b.Quarter__c) && delType == b.Delivery_Type__c){
                        b.Rep_1_FY_Total__c = a.Id;
                        updateRep1.add(b);
                        found = true;
                        break;
                    }
                }
                if (!found){
                    system.debug(LoggingLevel.ERROR, '***MISSED FY TOTAL: ' + a.Id);
                }
            }
        }
        
        for (Rep_2_FY_Total__c a : rep2Scope){
            for (String delType: delTypes){
                Boolean found = false;
                for (Rep_2_Forecast__c b : rep2){
                    if (a.Owner__c == b.OwnerId && a.Account__c == b.Account__c && a.Quarter__c == getPY(b.Quarter__c) && delType == b.Delivery_Type__c){
                        b.Rep_2_FY_Total__c = a.Id;
                        updateRep2.add(b);
                        found = true;
                        break;
                    }
                }
                if (!found){
                    system.debug(LoggingLevel.ERROR, '***MISSED FY TOTAL: ' + a.Id);
                }
            }
        }
        
        update updateRep1;
        update updateRep2;
        BatchGovernorLimitUtility.calcualteLimits(Limits.getCpuTime(), Limits.getDMLRows(), Limits.getDMLStatements(), Limits.getHeapSize(), Limits.getQueries(), Limits.getQueryRows(), Limits.getScriptStatements(), scope, currentTime, System.now());
        
    }
    
    global void finish(Database.BatchableContext BC){
        System.debug(LoggingLevel.WARN,'Temp_Delete_DeleteSM1Forecast');
        //Build the system time of now + 20 seconds to schedule the batch apex.
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        BatchAssociateFBFF acctBatch2Sched = new BatchAssociateFBFF();
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
        BatchGovernorLimitUtility.updateBatchRun();
    }
    
    /*
    Method that accepts a string consisting of a userID and a Quarter, returns the Rep_2_Forecast__c that was created or found
    param - String that represents the User and Quarter in the form 005F0000001wYSzIAM-Q12012
    return - the Rep_2_Forecast__c that represents the forecast for a given User over a given period
    */
    private Rep_2_Forecast__c createRep2Forecast(String x){
        Rep_2_Forecast__c result;
        String userID = x.substring(0, x.indexOf('-'));
        x = x.substring(x.indexOf('-') + 1);
        String quarterID = x.substring(0, x.indexOf('-'));
        x = x.substring(x.indexOf('-') + 1);
        String accountID = x.substring(0, x.indexOf('-'));
        x = x.substring(x.indexOf('-') + 1);
        String recordType = x.substring(0, x.indexOf('-'));
        x = x.substring(x.indexOf('-') + 1);
        String deliveryType = x.substring(0, x.indexOf('-'));
        x = x.substring(x.indexOf('-') + 1);
        String productType = x;
        
        boolean found = false;
        for (Rep_2_Forecast__c a : rep2){
            if(a.OwnerId == userID && a.Quarter__c == quarterID && a.Account__c == accountID && a.Account_Type__c == recordType && a.Delivery_Type__c == deliveryType && a.Product_Type__c == (productType == '' ? null : productType)){
                found = true;
                result = a;
                break;
            }
        }
        
        if(!found){
            if (rep2Map.containsKey(userID)){
                String fullName = rep2Map.get(userID).FirstName + ' ' + rep2Map.get(userID).LastName;
                String managerID = rep2Map.get(userID).ManagerId; 

                Rep_1_Forecast__c rep1a = createRep1Forecast(managerID + '-' + quarterID + '-' + accountID + '-' + recordType + '-' + deliveryType + '-' + productType);
                if (rep1a != null){
                    Rep_2_Forecast__c a = new Rep_2_Forecast__c();
                    a.OwnerId = userID;
                    a.Quarter__c = quarterID;
                    a.Account__c = accountID;
                    a.Account_Type__c = recordType;
                    a.Product_Type__c = productType;
                    a.Delivery_Type__c = deliveryType;
                    a.Quarter_Start_Date__c = Date.valueOf(getStartQuarter(quarterID));
                    a.Quarter_End_Date__c = Date.valueOf(getEndQuarter(quarterID));
                    a.Manager_Forecast__c = rep1a.Id;
                    a.Manager__c = rep1a.OwnerId;
                    a.Name = fullName + ' - ' + quarterID;
                    insertRep2.add(a);
                    rep2.add(a);
                    result = a;
                }
            }
        }
        return result;
    }
    
    
    /*
    Method that accepts a string consisting of a Sales Rep 2 userID and a Quarter, returns the Rep_1_Forecast__c that was created or found
    param - String that represents the Sales Rep 2 User and Quarter in the form 005F0000001wYSzIAM-Q12012
    return - the parent Rep_1_Forecast__c of the Rep_2_Forecast__c that represents the forecast for a given Sales Rep 2 User over a given period
    */
    private Rep_1_Forecast__c createRep1Forecast(String x){
        Rep_1_Forecast__c result;
        String userID = x.substring(0, x.indexOf('-'));
        x = x.substring(x.indexOf('-') + 1);
        String quarterID = x.substring(0, x.indexOf('-'));
        x = x.substring(x.indexOf('-') + 1);
        String accountID = x.substring(0, x.indexOf('-'));
        x = x.substring(x.indexOf('-') + 1);
        String recordType = x.substring(0, x.indexOf('-'));
        x = x.substring(x.indexOf('-') + 1);
        String deliveryType = x.substring(0, x.indexOf('-'));
        x = x.substring(x.indexOf('-') + 1);
        String productType = x;
        boolean found = false;
        /*system.debug(LoggingLevel.Warn, '***searching for:');
        system.debug(LoggingLevel.Warn, '*** ' + userID);
        system.debug(LoggingLevel.Warn, '*** ' + quarterID);
        system.debug(LoggingLevel.Warn, '*** ' + accountID);
        system.debug(LoggingLevel.Warn, '*** ' + recordType);
        system.debug(LoggingLevel.Warn, '*** ' + deliveryType);
        system.debug(LoggingLevel.Warn, '*** ' + productType);*/
        for (Rep_1_Forecast__c a : rep1){
            if(a.OwnerId == userID && a.Quarter__c == quarterID && a.Account__c == accountID && a.Account_Type__c == recordType && a.Delivery_Type__c == deliveryType && a.Product_Type__c == (productType == '' ? null : productType)){
                found = true;
                result = a;
                break;
            }
        }
        if(!found){
            if (rep1Map.containsKey(userID)){
                String fullName = rep1Map.get(userID).FirstName + ' ' + rep1Map.get(userID).LastName;
                String managerID = rep1Map.get(userID).ManagerId;
                Sales_Manager_2_Forecast__c sm2a = createSM2Forecast(managerID + '-' + quarterID + '-' + accountID + '-' + recordType + '-' + deliveryType + '-' + productType);
                if (sm2a != null){
                    Rep_1_Forecast__c a = new Rep_1_Forecast__c();
                    a.OwnerId = userID;
                    a.Quarter__c = quarterID;
                    a.Account__c = accountID;
                    a.Account_Type__c = recordType;
                    a.Product_Type__c = productType;
                    a.Delivery_Type__c = deliveryType;
                    a.Quarter_Start_Date__c = Date.valueOf(getStartQuarter(quarterID));
                    a.Quarter_End_Date__c = Date.valueOf(getEndQuarter(quarterID));
                    a.Manager_Forecast__c = sm2a.Id;
                    a.Manager__c = sm2a.OwnerId;
                    a.Name = fullName + ' - ' + quarterID;
                    insertRep1.add(a);
                    rep1.add(a);
                    result = a;
                }
            }
        }
        return result;
    }
    
    
    /*
    Method that accepts a string consisting of a Sales Rep 2 userID and a Quarter, returns the Sales_Manager_2_Forecast__c that was created or found
    param - String that represents the Sales Rep 2 User and Quarter in the form 005F0000001wYSzIAM-Q12012
    return - the parent Sales_Manager_2_Forecast__c of the Rep_2_Forecast__c that represents the forecast for a given Sales Rep 2 User over a given period
    */
    private Sales_Manager_2_Forecast__c createSM2Forecast(String x){
        Sales_Manager_2_Forecast__c result;
        String userID = x.substring(0, x.indexOf('-'));
        x = x.substring(x.indexOf('-') + 1);
        String quarterID = x.substring(0, x.indexOf('-'));
        x = x.substring(x.indexOf('-') + 1);
        String accountID = x.substring(0, x.indexOf('-'));
        x = x.substring(x.indexOf('-') + 1);
        String recordType = x.substring(0, x.indexOf('-'));
        x = x.substring(x.indexOf('-') + 1);
        String deliveryType = x.substring(0, x.indexOf('-'));
        x = x.substring(x.indexOf('-') + 1);
        String productType = x;
        boolean found = false;
        
        for (Sales_Manager_2_Forecast__c a : sm2){
            if(a.OwnerId == userID && a.Quarter__c == quarterID && a.Account__c == accountID && a.Account_Type__c == recordType && a.Delivery_Type__c == deliveryType && a.Product_Type__c == (productType == '' ? null : productType)){
                found = true;
                result = a;
                break;
            }
        }
        if(!found){
            if (SM2Map.containsKey(userID)){
                String fullName = SM2Map.get(userID).FirstName + ' ' + SM2Map.get(userID).LastName;
                String managerID = SM2Map.get(userID).ManagerId;
                Sales_Manager_1_Forecast__c sm1a = createSM1Forecast(managerID + '-' + quarterID + '-' + accountID + '-' + recordType + '-' + deliveryType + '-' + productType);
                if (sm1a != null){
                    Sales_Manager_2_Forecast__c a = new Sales_Manager_2_Forecast__c();
                    a.OwnerId = userID;
                    a.Quarter__c = quarterID;
                    a.Account__c = accountID;
                    a.Account_Type__c = recordType;
                    a.Product_Type__c = productType;
                    a.Delivery_Type__c = deliveryType;
                    a.Quarter_Start_Date__c = Date.valueOf(getStartQuarter(quarterID));
                    a.Quarter_End_Date__c = Date.valueOf(getEndQuarter(quarterID));
                    a.Manager_Forecast__c = sm1a.Id;
                    a.Manager__c = sm1a.OwnerId;
                    a.Name = fullName + ' - ' + quarterID;
                    insertSM2.add(a);
                    SM2.add(a);
                    result = a;
                }
            }
        }
        return result;
    }
    
    
    /*
    Method that accepts a string consisting of a Sales Rep 2 userID and a Quarter, returns the Sales_Manager_1_Forecast__c that was created or found
    param - String that represents the Sales Rep 2 User and Quarter in the form 005F0000001wYSzIAM-Q12012
    return - the parent Sales_Manager_1_Forecast__c of the Rep_2_Forecast__c that represents the forecast for a given Sales Rep 2 User over a given period
    */
    private Sales_Manager_1_Forecast__c createSM1Forecast(String x){
        Sales_Manager_1_Forecast__c result;
        String userID = x.substring(0, x.indexOf('-'));
        x = x.substring(x.indexOf('-') + 1);
        String quarterID = x.substring(0, x.indexOf('-'));
        x = x.substring(x.indexOf('-') + 1);
        String accountID = x.substring(0, x.indexOf('-'));
        x = x.substring(x.indexOf('-') + 1);
        String recordType = x.substring(0, x.indexOf('-'));
        x = x.substring(x.indexOf('-') + 1);
        String deliveryType = x.substring(0, x.indexOf('-'));
        x = x.substring(x.indexOf('-') + 1);
        String productType = x;
        boolean found = false;
        for (Sales_Manager_1_Forecast__c a : sm1){
            if(a.OwnerId == userID && a.Quarter__c == quarterID && a.Account__c == accountID && a.Account_Type__c == recordType && a.Delivery_Type__c == deliveryType && a.Product_Type__c == (productType == '' ? null : productType)){
                result = a;
                break;
            }
        }
        if(result == null){
            String fullName = SM1Map.get(userID).FirstName + ' ' + SM1Map.get(userID).LastName;
            String managerID = SM1Map.get(userID).ManagerId;
            Sales_Manager_1_Forecast__c a = new Sales_Manager_1_Forecast__c();
            a.OwnerId = userID;
            a.Quarter__c = quarterID;
            a.Account__c = accountID;
            a.Account_Type__c = recordType;
            a.Product_Type__c = productType;
            a.Delivery_Type__c = deliveryType;
            a.Manager__c = managerID;
            a.Quarter_Start_Date__c = Date.valueOf(getStartQuarter(quarterID));
            a.Quarter_End_Date__c = Date.valueOf(getEndQuarter(quarterID));
            a.Name = fullName + ' - ' + quarterID; 
            insertSM1.add(a);
            SM1.add(a);
            result = a;
        }
        return result;
    }
    
     /*
    Method that accepts a string that represents a Quarter and returns the same quarter last year
    param - String that represents a quarter in the form 'QQYYYY' e.g. 'Q12012'
    return - String that represents the next quarter in the form 'QQYYYY' e.g. 'Q22012'
    */
    private String getPY(String x){
        Integer q = Integer.valueOf(x.substring(1,2));
        Integer year = Integer.valueOf(x.substring(2));
        year--;
        return 'Q' + String.valueOf(q) + String.valueOf(year); 
    }
    
     /*
    Method that accepts a string that represents a Quarter and returns the same quarter NEXT year
    param - String that represents a quarter in the form 'QQYYYY' e.g. 'Q12012'
    return - String that represents the next quarter in the form 'QQYYYY' e.g. 'Q22013'
    */
    private String getNY(String x){
        Integer q = Integer.valueOf(x.substring(1,2));
        Integer year = Integer.valueOf(x.substring(2));
        year++;
        return 'Q' + String.valueOf(q) + String.valueOf(year); 
    }

    /*
    Method that accepts a string that represents a Quarter and returns the first day of that quarter
    param - String that represents a quarter in the form 'QQYYYY' e.g. 'Q12012'
    return - The String representation of the first day of that quarter in the form 'YYYY-MM-DD' e.g. '2012-01-01'
    */
    private String getStartQuarter(String x){
        String result = x.substring(2);
        String quarter = x.substring(0,2);
        if (quarter == 'Q1'){
            result += q1Start; 
        } else if (quarter == 'Q2'){
            result += q2Start;
        } else if (quarter == 'Q3'){
            result += q3Start;
        } else {
            result += q4Start;
        } 
        return result;
    }
    
    
    /*
    Method that accepts a string that represents a Quarter and returns the last day of that quarter
    param - String that represents a quarter in the form 'QQYYYY' e.g. 'Q12012'
    return - The String representation of the first day of that quarter in the form 'YYYY-MM-DD' e.g. '2012-03-31'
    */
    private String getEndQuarter(String x){
        
        String result = x.substring(2);
        
        String quarter = x.substring(0,2);
        
        if (quarter == 'Q1'){
            result += q1End; 
        } else if (quarter == 'Q2'){
            result += q2End;
        } else if (quarter == 'Q3'){
            result += q3End;
        } else {
            result += q4End;
        }
        return result;
    }
    
    /*
    Helper method that requeries each forecast object to get latest insert/updates
    */
    private void refreshForecasts(){
        
        rep2 = [Select r.Weighted_Forecast_Proposal__c, r.SDPY_Forecast__c, r.Quarter__c, r.Quarter_Start_Date__c, r.Quarter_End_Date__c, r.Product_Type__c, r.OwnerId, r.Name, r.Manager__c, r.Manager_Forecast__c, r.Id, r.Forecast_Proposal__c, r.Forecast_Contract__c, r.Delivery_Type__c, r.Actual_Amount__c, r.Account__c, r.Account_Type__c From Rep_2_Forecast__c r WHERE r.Account__c IN :accountList AND r.OwnerId IN :userList];
        rep1 = [Select r.Weighted_Forecast_Proposal__c, r.SDPY_Forecast__c, r.Quarter__c, r.Quarter_Start_Date__c, r.Quarter_End_Date__c, r.Product_Type__c, r.OwnerId, r.Name, r.Manager__c, r.Manager_Forecast__c, r.Id, r.Forecast_Proposal__c, r.Forecast_Contract__c, r.Delivery_Type__c, r.Actual_Amount__c, r.Account__c, r.Account_Type__c From Rep_1_Forecast__c r WHERE r.Account__c IN :accountList AND r.OwnerId IN :userList];
        sm2 = [Select r.Weighted_Forecast_Proposal__c, r.SDPY_Forecast__c, r.Quarter__c, r.Quarter_Start_Date__c, r.Quarter_End_Date__c, r.Product_Type__c, r.OwnerId, r.Name, r.Manager__c, r.Manager_Forecast__c, r.Id, r.Forecast_Proposal__c, r.Forecast_Contract__c, r.Delivery_Type__c, r.Actual_Amount__c, r.Account__c, r.Account_Type__c From Sales_Manager_2_Forecast__c r WHERE r.Account__c IN :accountList AND r.OwnerId IN :userList];
        sm1 = [Select r.Weighted_Forecast_Proposal__c, r.SDPY_Forecast__c, r.Quarter__c, r.Quarter_Start_Date__c, r.Quarter_End_Date__c, r.Product_Type__c, r.OwnerId, r.Name, r.Manager__c, r.Manager_Forecast__c, r.Id, r.Forecast_Proposal__c, r.Forecast_Contract__c, r.Delivery_Type__c, r.Actual_Amount__c, r.Account__c, r.Account_Type__c From Sales_Manager_1_Forecast__c r WHERE r.Account__c IN :accountList AND r.OwnerId IN :userList];
        
    }
    
    private void clearInsertLists(){
        insertRep2 = new List<Rep_2_Forecast__c>();
        insertRep1 = new List<Rep_1_Forecast__c>();
        insertSM2 = new List<Sales_Manager_2_Forecast__c>();
        insertSM1 = new List<Sales_Manager_1_Forecast__c>();
    }
    
    private String getManager(String x){
        String result;
        User a = userMap.get(x);
        if (a != null){
            result = a.ManagerId;
            if (a.ManagerId != null){
                userList.add(a.ManagerId);
                getManager(a.ManagerId);
            }
        }
        return result;
    }
    
}