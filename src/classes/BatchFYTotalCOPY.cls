/*
@Name           :       BatchFYTotalCOPY
@Author         :       Warren
@Date           :       Feb 6 2012
@Description    :       Batch class designed to:
                            a.) Create forecasts and the necessary master forecasts if they do not already exist
                            a.) Create SDPY forecasts for each object and link those forecasts to the current forecast objects
                            b.) Update the amounts for each forecast
*/

global class BatchFYTotalCOPY implements Database.Batchable<sObject>, Schedulable{

    //declare static variables
    final static String q1Start = '-01-01';
    final static String q2Start = '-04-01';
    final static String q3Start = '-07-01';
    final static String q4Start = '-10-01';
    final static String q1End = '-03-31';
    final static String q2End = '-06-30';
    final static String q3End = '-09-30';
    final static String q4End = '-12-31';
    final static String defaultSettingsName = 'Default';
    
    //declare variables
    String year;
    String limit1;
    String query;
    List<Rep_2_FY_Total__c> insertRep2;
    List<Rep_1_FY_Total__c> insertRep1;
    List<Sales_Manager_2_FY_Total__c> insertSM2;
    List<Sales_Manager_1_FY_Total__c> insertSM1;
    List<Program__c> programs;
    List<Rep_2_FY_Total__c> rep2;
    List<Rep_1_FY_Total__c> rep1;
    List<Sales_Manager_2_FY_Total__c> sm2;
    List<Sales_Manager_1_FY_Total__c> sm1;
    List<Program_Forecast__c> pF;
    List<User> Rep2Managers;
    List<User> Rep1Managers;
    List<User> SM2Managers;
    List<User> SM1Managers;
    
    //custom settings variables
    Catalina_Forecast_Settings__c settings;
    String rep2Type;
    String rep1Type;
    String SM2Type;
    String SM1Type;
    String baseType;
    String digitalType;
    String audienceType;
    String mobileType;
    Set<ID> accountList;
    
    public BatchFYTotalCOPY(String x){
        year = x;
        limit1 = '';
    }
    
    public BatchFYTotalCOPY(String x, String y){
        year = x;
        limit1 = y;
    }
    
    //method that gets the query used for this batch
    global Database.querylocator start(Database.BatchableContext BC){
        BatchGovernorLimitUtility.insertBatchRun('BatchFYTotalCOPY');       
    
        if (year != null){
            query = 'SELECT ID, Name, Program__r.Opportunity__r.Account.Id, Program__r.Opportunity__r.OwnerId From Program_Forecast__c ' +
            ' Where  (Ad_Period__r.Quarter__c LIKE \'%' + year + '\' OR (Ad_Period__r.Quarter__c = \'Q4' + (Integer.valueOf(year) - 1) + '\' AND Ad_Period__r.Is_Split__c = \'true\')) '
            + ' AND (PROGRAM__R.OPPORTUNITY__R.RECORDTYPE.NAME = \'CONTRACT\' OR PROGRAM__R.OPPORTUNITY__R.RECORDTYPE.NAME = \'PROPOSAL\' OR PROGRAM__R.OPPORTUNITY__R.RECORDTYPE.NAME = \'RECOVERY\' OR PROGRAM__R.OPPORTUNITY__R.RECORDTYPE.NAME = \'RENEWAL\') '
            + ' ORDER BY Program__r.Opportunity__r.Account.Id, Program__r.Opportunity__c ' + limit1;
        }
        system.debug('***query = ' + query);
        //query = 'SELECT ID, FirstName, LastName,  UserRole.Name, ManagerId FROM USER WHERE UserRole.Name Like \'SR2%\' And ManagerID  != NULL';
        return Database.getQueryLocator(query);
    }

    global void execute(SchedulableContext ctx) {
        BatchFYTotalCOPY batch1 = new BatchFYTotalCOPY(year);
        ID batchprocessid = Database.executeBatch(batch1);
    }     
    
    //method that makes up the body of the batch process    
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        Datetime currentTime = System.now();
        system.debug('***start: ' + system.now());
        List<Program_Forecast__c> pfScope = (List<Program_Forecast__c>)scope;
        settings = Catalina_Forecast_Settings__c.getInstance(defaultSettingsName);
        rep2Type = settings.Rep_2_String__c;
        rep1Type = settings.Rep_1_String__c;
        SM2Type = settings.SM_2_String__c;
        SM1Type = settings.SM_1_String__c;
        String coopType = settings.Coop_String__c;
        baseType = settings.Base_Delivery_Type__c;
        digitalType = settings.Digital_Delivery_Type__c;
        audienceType = settings.Display_Delivery_Type__c;
        mobileType = settings.Mobile_Delivery_Type__c;
        //create lists to store the objects to insert/update
        clearInsertLists();

        accountList = new Set<ID>();
        for (Program_Forecast__c a: pfScope){
            accountList.add(a.Program__r.Opportunity__r.Account.Id);
        }
        
        refreshForecasts();
        User coopUser;
        List<User> temp1 = [SELECT ID FROM USER WHERE FORECAST_ROLE__C =: coopType];
        if (temp1.size() > 0){
            coopUser = temp1.get(0);
        }
        //get Sales Rep 2s that need to be created or should already exist
        Rep2Managers = [SELECT ID, FirstName, LastName,  UserRole.Name, ManagerId FROM USER WHERE Forecast_Role__c =:rep2Type And ManagerID  != NULL];
        //get Sales Rep 1s that need to be created or should already exist
        Rep1Managers = [SELECT ID, FirstName, LastName,  UserRole.Name, ManagerId FROM USER WHERE Forecast_Role__c =:rep1Type And ManagerID  != NULL];
        //get Sales Manager 2s that need to be created or should already exist
        SM2Managers = [SELECT ID, FirstName, LastName,  UserRole.Name, ManagerId FROM USER WHERE Forecast_Role__c =:SM2Type And ManagerID  != NULL];
        //get Sales Manager 1s that need to be created or should already exist
        SM1Managers = [SELECT ID, FirstName, LastName,  UserRole.Name, ManagerId FROM USER WHERE Forecast_Role__c =:SM1Type OR Forecast_Role__c =:coopType];
        //Start process to create Sales Rep 2 Forecasts and all non-existent parents
        Set<ID>userIDList = new Set<ID>();
        for (User s : Rep2Managers){
            userIDList.add(s.Id);
        }
        Set<ID>pfList = new Set<ID>();
        for (Program_Forecast__c a: pfScope){
            pfList.add(a.Id);
        }
        pF = [SELECT Actual_Amount__c, Program__r.Product_Type__c, Program__r.Opportunity__r.Account.Id, Ad_Period__r.Quarter__c, Ad_Period__r.Is_Split__c, Weighted_Forecast_Amount__c, Previous_Quarter_Amount__c, Oppty_Probability__c, Next_Quarter_Amount__c, Forecast_Amount__c, Program__r.Opportunity__r.OwnerId, Program__r.Delivery_Type__c, Program__r.Opportunity__r.Account.RecordType.Name,  Weighted_Previous_Quarter_Forecast__c, Weighted_Next_Quarter_Forecast__c, Previous_Quarter_Ratio__c,Previous_Quarter_Actual__c, Next_Quarter_Ratio__c, Next_Quarter_Actual__c FROM Program_Forecast__c WHERE Program__r.Opportunity__r.OwnerId IN :userIDList And Id IN :pfList ORDER BY Program__r.Opportunity__r.OwnerId, Ad_Period__r.Quarter__c];
        //get unique combinations of reps and quarters that we will need to create forecasts for
        Set<String> uniquePairs = new Set<String>();
        for (Program_Forecast__c a : pf){
            if (a.Ad_Period__r.Is_Split__c == 'true'){
                //edited march 12
                if (getNextQuarter(a.Ad_Period__r.Quarter__c).substring(2) == year){
                    if (!uniquePairs.contains(a.Program__r.Opportunity__r.OwnerId + '-'+ getNextQuarter(a.Ad_Period__r.Quarter__c) + '-' +a.Program__r.Opportunity__r.Account.Id)){
                        uniquePairs.add(a.Program__r.Opportunity__r.OwnerId + '-'+ getNextQuarter(a.Ad_Period__r.Quarter__c) + '-' +a.Program__r.Opportunity__r.Account.Id);
                    }           
                }
                //added Nov 13 to eliminate cross year duplicates
                if (a.Ad_Period__r.Quarter__c.substring(2) == year){
                    if (!uniquePairs.contains(a.Program__r.Opportunity__r.OwnerId + '-'+ a.Ad_Period__r.Quarter__c + '-' +a.Program__r.Opportunity__r.Account.Id)){
                    uniquePairs.add(a.Program__r.Opportunity__r.OwnerId + '-'+ a.Ad_Period__r.Quarter__c + '-' +a.Program__r.Opportunity__r.Account.Id);
                    }
                }
            } else {
                if (!uniquePairs.contains(a.Program__r.Opportunity__r.OwnerId + '-'+ a.Ad_Period__r.Quarter__c + '-' +a.Program__r.Opportunity__r.Account.Id)){
                uniquePairs.add(a.Program__r.Opportunity__r.OwnerId + '-'+ a.Ad_Period__r.Quarter__c + '-' +a.Program__r.Opportunity__r.Account.Id);
                }
            }
            
        }
        system.debug('***before insert SDPYSM1: ' + system.now());
        //create Sales Manager 1 Forecasts that don't already exist
        refreshForecasts();
        clearInsertLists();
        for(string x : uniquePairs){
            createRep2Forecast(x);
        }
        insert insertSM1;
        system.debug('***after insert SM1: ' + system.now());
        //requery and create Sales Manager 2 Forecasts that don't already exist
        refreshForecasts();
        clearInsertLists();
        for(string x : uniquePairs){
            createRep2Forecast(x);
        }
        insert insertSM2;
        system.debug('***after insert SM2: ' + system.now());
        //requery and create Sales Rep 1 Forecasts that don't already exist
        refreshForecasts();
        clearInsertLists();
        for(string x : uniquePairs){
            createRep2Forecast(x);
        }
        insert insertRep1;
        system.debug('***after insert Rep1: ' + system.now());
        //requery and create Sales Rep 2 Forecasts that don't already exist
        refreshForecasts();
        clearInsertLists();
        for(string x : uniquePairs){
            createRep2Forecast(x);
        }
        insert insertRep2;
        system.debug('***after insert Rep2: ' + system.now());
        //requery and get list for forecast amount updates
        refreshForecasts();
        clearInsertLists();
        system.debug('***' + uniquePairs.size());
        system.debug('***' + rep2Type);
        updateForecasts(uniquePairs, rep2Type);
        update insertRep2;
        system.debug('***after Rep2 updates: ' + system.now());
        
        
        //Repeat process to create Sales Rep 1 Forecasts and all non-existent parents
        clearInsertLists();
        uniquePairs = new Set<String>();
        userIDList = new Set<ID>();
        for (User s : Rep1Managers){
            userIDList.add(s.Id);
        }
        pF = [SELECT Actual_Amount__c, Program__r.Product_Type__c, Program__r.Opportunity__r.Account.Id, Ad_Period__r.Quarter__c, Ad_Period__r.Is_Split__c, Weighted_Forecast_Amount__c, Previous_Quarter_Amount__c, Oppty_Probability__c, Next_Quarter_Amount__c, Forecast_Amount__c, Program__r.Opportunity__r.OwnerId, Program__r.Delivery_Type__c, Program__r.Opportunity__r.Account.RecordType.Name,  Weighted_Previous_Quarter_Forecast__c, Weighted_Next_Quarter_Forecast__c, Previous_Quarter_Ratio__c,Previous_Quarter_Actual__c, Next_Quarter_Ratio__c, Next_Quarter_Actual__c FROM Program_Forecast__c WHERE Program__r.Opportunity__r.OwnerId IN :userIDList And Id IN :pfList ORDER BY Program__r.Opportunity__r.OwnerId, Ad_Period__r.Quarter__c];
        for (Program_Forecast__c a : pf){
            if (a.Ad_Period__r.Is_Split__c == 'true'){
                //edited march 12
                if (getNextQuarter(a.Ad_Period__r.Quarter__c).substring(2) == year){
                    if (!uniquePairs.contains(a.Program__r.Opportunity__r.OwnerId + '-'+ getNextQuarter(a.Ad_Period__r.Quarter__c) + '-' +a.Program__r.Opportunity__r.Account.Id)){
                        uniquePairs.add(a.Program__r.Opportunity__r.OwnerId + '-'+ getNextQuarter(a.Ad_Period__r.Quarter__c) + '-' +a.Program__r.Opportunity__r.Account.Id);
                    }           
                }
                //added Nov 13 to eliminate cross year duplicates
                if (a.Ad_Period__r.Quarter__c.substring(2) == year){
                    if (!uniquePairs.contains(a.Program__r.Opportunity__r.OwnerId + '-'+ a.Ad_Period__r.Quarter__c + '-' +a.Program__r.Opportunity__r.Account.Id)){
                    uniquePairs.add(a.Program__r.Opportunity__r.OwnerId + '-'+ a.Ad_Period__r.Quarter__c + '-' +a.Program__r.Opportunity__r.Account.Id);
                    }
                }
            } else {
                if (!uniquePairs.contains(a.Program__r.Opportunity__r.OwnerId + '-'+ a.Ad_Period__r.Quarter__c + '-' +a.Program__r.Opportunity__r.Account.Id)){
                uniquePairs.add(a.Program__r.Opportunity__r.OwnerId + '-'+ a.Ad_Period__r.Quarter__c + '-' +a.Program__r.Opportunity__r.Account.Id);
                }
            }
            
        }
        
        //create Sales Manager 1 Forecasts that don't already exist
        refreshForecasts();
        clearInsertLists();
        for(string x : uniquePairs){
            createRep1Forecast(x);
        }
        insert insertSM1;
        //requery and create Sales Manager 2 Forecasts that don't already exist
        refreshForecasts();
        clearInsertLists();
        for(string x : uniquePairs){
            createRep1Forecast(x);
        }
        insert insertSM2;
        //requery and create Sales Rep 1 Forecasts that don't already exist
        refreshForecasts();
        clearInsertLists();
        for(string x : uniquePairs){
            createRep1Forecast(x);
        }
        insert insertRep1;
        //requery and get list for forecast amount updates
        refreshForecasts();
        clearInsertLists();
        updateForecasts(uniquePairs, rep1Type);
        update insertRep1;
        
        
        //Repeat process to create Sales Manager 2 Forecasts and all non-existent parents
        clearInsertLists();
        uniquePairs = new Set<String>();
        userIDList = new Set<ID>();
        for (User s : SM2Managers){
            userIDList.add(s.Id);
        }
        pF = [SELECT Actual_Amount__c, Program__r.Product_Type__c, Program__r.Opportunity__r.Account.Id, Ad_Period__r.Quarter__c, Ad_Period__r.Is_Split__c, Weighted_Forecast_Amount__c, Previous_Quarter_Amount__c, Oppty_Probability__c, Next_Quarter_Amount__c, Forecast_Amount__c, Program__r.Opportunity__r.OwnerId, Program__r.Delivery_Type__c, Program__r.Opportunity__r.Account.RecordType.Name,  Weighted_Previous_Quarter_Forecast__c, Weighted_Next_Quarter_Forecast__c, Previous_Quarter_Ratio__c,Previous_Quarter_Actual__c, Next_Quarter_Ratio__c, Next_Quarter_Actual__c FROM Program_Forecast__c WHERE Program__r.Opportunity__r.OwnerId IN :userIDList And Id IN :pfList ORDER BY Program__r.Opportunity__r.OwnerId, Ad_Period__r.Quarter__c];
        for (Program_Forecast__c a : pf){
            if (a.Ad_Period__r.Is_Split__c == 'true'){
                //edited march 12
                if (getNextQuarter(a.Ad_Period__r.Quarter__c).substring(2) == year){
                    if (!uniquePairs.contains(a.Program__r.Opportunity__r.OwnerId + '-'+ getNextQuarter(a.Ad_Period__r.Quarter__c) + '-' +a.Program__r.Opportunity__r.Account.Id)){
                        uniquePairs.add(a.Program__r.Opportunity__r.OwnerId + '-'+ getNextQuarter(a.Ad_Period__r.Quarter__c) + '-' +a.Program__r.Opportunity__r.Account.Id);
                    }           
                }
                //added Nov 13 to eliminate cross year duplicates
                if (a.Ad_Period__r.Quarter__c.substring(2) == year){
                    if (!uniquePairs.contains(a.Program__r.Opportunity__r.OwnerId + '-'+ a.Ad_Period__r.Quarter__c + '-' +a.Program__r.Opportunity__r.Account.Id)){
                    uniquePairs.add(a.Program__r.Opportunity__r.OwnerId + '-'+ a.Ad_Period__r.Quarter__c + '-' +a.Program__r.Opportunity__r.Account.Id);
                    }
                }
            } else {
                if (!uniquePairs.contains(a.Program__r.Opportunity__r.OwnerId + '-'+ a.Ad_Period__r.Quarter__c + '-' +a.Program__r.Opportunity__r.Account.Id)){
                uniquePairs.add(a.Program__r.Opportunity__r.OwnerId + '-'+ a.Ad_Period__r.Quarter__c + '-' +a.Program__r.Opportunity__r.Account.Id);
                }
            }
            
        }
        
        //create Sales Manager 1 Forecasts that don't already exist
        refreshForecasts();
        clearInsertLists();
        for(string x : uniquePairs){
            createSM2Forecast(x);
        }
        insert insertSM1;
        //requery and create Sales Manager 2 Forecasts that don't already exist
        refreshForecasts();
        clearInsertLists();
        for(string x : uniquePairs){
            createSM2Forecast(x);
        }
        insert insertSM2;
        //requery and get list for forecast amount updates
        refreshForecasts();
        clearInsertLists();
        updateForecasts(uniquePairs, SM2Type);
        update insertSM2;
        
        
        //Repeat process to create Sales Manager 1 Forecasts and all non-existent parents
        clearInsertLists();
        uniquePairs = new Set<String>();
        userIDList = new Set<ID>();
        for (User s : SM1Managers){
            userIDList.add(s.Id);
        }
        pF = [SELECT Actual_Amount__c, Program__r.Product_Type__c, Program__r.Opportunity__r.Account.Id, Ad_Period__r.Quarter__c, Ad_Period__r.Is_Split__c, Weighted_Forecast_Amount__c, Previous_Quarter_Amount__c, Oppty_Probability__c, Next_Quarter_Amount__c, Forecast_Amount__c, Program__r.Opportunity__r.OwnerId, Program__r.Delivery_Type__c, Program__r.Opportunity__r.Account.RecordType.Name,  Weighted_Previous_Quarter_Forecast__c, Weighted_Next_Quarter_Forecast__c, Previous_Quarter_Ratio__c,Previous_Quarter_Actual__c, Next_Quarter_Ratio__c, Next_Quarter_Actual__c FROM Program_Forecast__c WHERE Program__r.Opportunity__r.OwnerId IN :userIDList And Id IN :pfList ORDER BY Program__r.Opportunity__r.OwnerId, Ad_Period__r.Quarter__c];
        for (Program_Forecast__c a : pf){
            if (a.Ad_Period__r.Is_Split__c == 'true'){
                //edited march 12
                if (getNextQuarter(a.Ad_Period__r.Quarter__c).substring(2) == year){
                    if (!uniquePairs.contains(a.Program__r.Opportunity__r.OwnerId + '-'+ getNextQuarter(a.Ad_Period__r.Quarter__c) + '-' +a.Program__r.Opportunity__r.Account.Id)){
                        uniquePairs.add(a.Program__r.Opportunity__r.OwnerId + '-'+ getNextQuarter(a.Ad_Period__r.Quarter__c) + '-' +a.Program__r.Opportunity__r.Account.Id);
                    }           
                }
                //added Nov 13 to eliminate cross year duplicates
                if (a.Ad_Period__r.Quarter__c.substring(2) == year){
                    if (!uniquePairs.contains(a.Program__r.Opportunity__r.OwnerId + '-'+ a.Ad_Period__r.Quarter__c + '-' +a.Program__r.Opportunity__r.Account.Id)){
                    uniquePairs.add(a.Program__r.Opportunity__r.OwnerId + '-'+ a.Ad_Period__r.Quarter__c + '-' +a.Program__r.Opportunity__r.Account.Id);
                    }
                }
            } else {
                if (!uniquePairs.contains(a.Program__r.Opportunity__r.OwnerId + '-'+ a.Ad_Period__r.Quarter__c + '-' +a.Program__r.Opportunity__r.Account.Id)){
                uniquePairs.add(a.Program__r.Opportunity__r.OwnerId + '-'+ a.Ad_Period__r.Quarter__c + '-' +a.Program__r.Opportunity__r.Account.Id);
                }
            }
            
        }
        
        //create Sales Manager 1 Forecasts that don't already exist
        refreshForecasts();
        clearInsertLists();
        for(string x : uniquePairs){
            createSM1Forecast(x);
        }
        insert insertSM1;
        //requery and get list for forecast amount updates
        refreshForecasts();
        clearInsertLists();
        updateForecasts(uniquePairs, SM1Type);
        update insertSM1;
        
        /*start collecting left over */
        clearInsertLists();
        uniquePairs = new Set<String>();
        userIDList = new Set<ID>();
        for (User s : SM1Managers){
            userIDList.add(s.Id);
        }
        for (User s : SM2Managers){
            userIDList.add(s.Id);
        }
        for (User s : Rep1Managers){
            userIDList.add(s.Id);
        }
        for (User s : Rep2Managers){
            userIDList.add(s.Id);
        }
        pF = [SELECT Active__c, Program__r.RecordType.Name, Actual_Amount__c, Program__r.Product_Type__c, Program__r.Opportunity__r.Account.Id, Ad_Period__r.Quarter__c, Ad_Period__r.Is_Split__c, Weighted_Forecast_Amount__c, Previous_Quarter_Amount__c, Oppty_Probability__c, Next_Quarter_Amount__c, Forecast_Amount__c, Program__r.Opportunity__r.OwnerId, Program__r.Delivery_Type__c, Program__r.Opportunity__r.Account.RecordType.Name,  Weighted_Previous_Quarter_Forecast__c, Weighted_Next_Quarter_Forecast__c, Previous_Quarter_Ratio__c,Previous_Quarter_Actual__c, Next_Quarter_Ratio__c, Next_Quarter_Actual__c FROM Program_Forecast__c WHERE Program__r.Opportunity__r.OwnerId Not IN :userIDList And Id IN :pfList ORDER BY Program__r.Opportunity__r.OwnerId, Ad_Period__r.Quarter__c];
        uniquePairs = new Set<String>();
        if (coopUser != null){
            for (Program_Forecast__c a : pf){
                if (a.Ad_Period__r.Is_Split__c == 'true'){
                    //edited march 12
                    if (getNextQuarter(a.Ad_Period__r.Quarter__c).substring(2) == year){
                        if (!uniquePairs.contains(coopUser.Id  + '-'+ getNextQuarter(a.Ad_Period__r.Quarter__c) + '-' +a.Program__r.Opportunity__r.Account.Id)){
                            uniquePairs.add(coopUser.Id  + '-'+ getNextQuarter(a.Ad_Period__r.Quarter__c) + '-' +a.Program__r.Opportunity__r.Account.Id);
                        }           
                    }
                    //added Nov 13 to eliminate cross year duplicates
                    if (a.Ad_Period__r.Quarter__c.substring(2) == year){
                        if (!uniquePairs.contains(coopUser.Id  + '-'+ a.Ad_Period__r.Quarter__c + '-' +a.Program__r.Opportunity__r.Account.Id)){
                        uniquePairs.add(coopUser.Id  + '-'+ a.Ad_Period__r.Quarter__c + '-' +a.Program__r.Opportunity__r.Account.Id);
                        }
                    }
                } else {
                    if (!uniquePairs.contains(coopUser.Id  + '-'+ a.Ad_Period__r.Quarter__c + '-' +a.Program__r.Opportunity__r.Account.Id)){
                    uniquePairs.add(coopUser.Id  + '-'+ a.Ad_Period__r.Quarter__c + '-' +a.Program__r.Opportunity__r.Account.Id);
                    }
                }
                
            }
        }
        //create Sales Manager 1 Forecasts that don't already exist
        refreshForecasts();
        clearInsertLists();
        for(string x : uniquePairs){
            createSM1Forecast(x);
        }
        insert insertSM1;
        //requery and get list for forecast amount updates
        refreshForecasts();
        clearInsertLists();
        updateCoopForecasts(uniquePairs);
        update insertSM1;
        
        /* end collecting leftover */
        BatchGovernorLimitUtility.calcualteLimits(Limits.getCpuTime(), Limits.getDMLRows(), Limits.getDMLStatements(), Limits.getHeapSize(), Limits.getQueries(), Limits.getQueryRows(), Limits.getScriptStatements(), scope, currentTime, System.now());
        system.debug('***end: ' + system.now());
        
    }
    
    
    //method that runs after the execute() method
    global void finish(Database.BatchableContext BC){                  
    
        System.debug(LoggingLevel.WARN,'Temp_Delete_DeleteSM1Forecast');
        //Build the system time of now + 20 seconds to schedule the batch apex.
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        String year0 = String.valueOf(Date.today().year());
        String year1 = String.valueOf(Date.today().year() - 1);
        String year2 = String.valueOf(Date.today().year() - 2);
        if (year == year0){
            BatchFYTotalCOPY acctBatch2Sched = new BatchFYTotalCOPY(year1);
            //Schedule the next job, and give it the system time so name is unique
            System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
        } else if (year == year1){
            BatchFYTotalCOPY acctBatch2Sched = new BatchFYTotalCOPY(year2);
            //Schedule the next job, and give it the system time so name is unique
            System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
        } else if (year == year2){
            //BatchCreateBestGuess acctBatch2Sched = new BatchCreateBestGuess('Q12012');
            BatchUpdateSDPYCOPY acctBatch2Sched = new BatchUpdateSDPYCOPY();
            //Schedule the next job, and give it the system time so name is unique
            System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
        }
        BatchGovernorLimitUtility.updateBatchRun();
    }
    
    
    /*
    Method that accepts a string consisting of a userID and a Quarter, returns the Rep_2_Forecast__c that was created or found
    param - String that represents the User and Quarter in the form 005F0000001wYSzIAM-Q12012
    return - the Rep_2_Forecast__c that represents the forecast for a given User over a given period
    */
    private Rep_2_FY_Total__c createRep2Forecast(String x){
        Rep_2_FY_Total__c result;
        String userID = x.substring(0, x.indexOf('-'));
        x = x.substring(x.indexOf('-') + 1);
        String quarterID = x.substring(0, x.indexOf('-'));
        x = x.substring(x.indexOf('-') + 1);
        String accountID = x;
        
        boolean found = false;
        for (Rep_2_FY_Total__c a : rep2){
            if(a.Owner__c == userID && a.Quarter__c == quarterID && a.Account__c == accountID){
                found = true;
                result = a;
                break;
            }
        }
        
        if(!found){
            String fullName = '';
            String managerID = '';
            for(User re2: Rep2Managers){
                if (re2.Id == userID){
                    fullName = re2.FirstName + ' ' + re2.LastName;
                    managerID = re2.ManagerId;
                    break;
                }
            }
            if (managerID != ''){
                Rep_1_FY_Total__c rep1a = createRep1Forecast(managerID + '-' + quarterID + '-' + accountID);
                if (rep1a != null){
                    Rep_2_FY_Total__c a = new Rep_2_FY_Total__c();
                    a.Owner__c = userID;
                    a.Quarter__c = quarterID;
                    a.Account__c = accountID;
                    a.Manager_FY_Total__c = rep1a.Id;
                    a.Manager__c = rep1a.Owner__c;
                    a.Name = fullName + ' - ' + quarterID + ' - ' + accountID;
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
    private Rep_1_FY_Total__c createRep1Forecast(String x){
        Rep_1_FY_Total__c result;
        String userID = x.substring(0, x.indexOf('-'));
        x = x.substring(x.indexOf('-') + 1);
        String quarterID = x.substring(0, x.indexOf('-'));
        x = x.substring(x.indexOf('-') + 1);
        String accountID = x;
        boolean found = false;
        for (Rep_1_FY_Total__c a : rep1){
            if(a.Owner__c == userID && a.Quarter__c == quarterID && a.Account__c == accountID){
                found = true;
                result = a;
                break;
            }
        }
        if(!found){
            String fullName = '';
            String managerID = '';
            for(User re1: Rep1Managers){
                if (re1.Id == userID){
                    fullName = re1.FirstName + ' ' + re1.LastName;
                    managerID = re1.ManagerId;
                    break;
                }
            }
            if (managerID != ''){
                Sales_Manager_2_FY_Total__c sm2a = createSM2Forecast(managerID + '-' + quarterID + '-' + accountID);
                if (sm2a != null){
                    Rep_1_FY_Total__c a = new Rep_1_FY_Total__c();
                    a.Owner__c = userID;
                    a.Quarter__c = quarterID;
                    a.Account__c = accountID;
                    a.Manager_FY_Total__c = sm2a.Id;
                    a.Manager__c = sm2a.Owner__c;
                    a.Name = fullName + ' - ' + quarterID + ' - ' + accountID;
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
    private Sales_Manager_2_FY_Total__c createSM2Forecast(String x){
        Sales_Manager_2_FY_Total__c result;
        String userID = x.substring(0, x.indexOf('-'));
        x = x.substring(x.indexOf('-') + 1);
        String quarterID = x.substring(0, x.indexOf('-'));
        x = x.substring(x.indexOf('-') + 1);
        String accountID = x;
        boolean found = false;
        for (Sales_Manager_2_FY_Total__c a : sm2){
            if(a.Owner__c == userID && a.Quarter__c == quarterID && a.Account__c == accountID){
                found = true;
                result = a;
                break;
            }
        }
        if(!found){
            String fullName = '';
            String managerID = '';
            for(User sm2: SM2Managers){
                if (sm2.Id == userID){
                    fullName = sm2.FirstName + ' ' + sm2.LastName;
                    managerID = sm2.ManagerId;
                    break;
                }
            }
            if (managerID != ''){
                Sales_Manager_1_FY_Total__c sm1a = createSM1Forecast(managerID + '-' + quarterID + '-' + accountID);
                if (sm1a != null){
                    Sales_Manager_2_FY_Total__c a = new Sales_Manager_2_FY_Total__c();
                    a.Owner__c = userID;
                    a.Quarter__c = quarterID;
                    a.Account__c = accountID;
                    a.Manager_FY_Total__c = sm1a.Id;
                    a.Name = fullName + ' - ' + quarterID + ' - ' + accountID;
                    a.Manager__c = sm1a.OwnerId;
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
    private Sales_Manager_1_FY_Total__c createSM1Forecast(String x){
        Sales_Manager_1_FY_Total__c result;
        String userID = x.substring(0, x.indexOf('-'));
        x = x.substring(x.indexOf('-') + 1);
        String quarterID = x.substring(0, x.indexOf('-'));
        x = x.substring(x.indexOf('-') + 1);
        String accountID = x;
        boolean found = false;
        for (Sales_Manager_1_FY_Total__c a : sm1){
            if(a.OwnerId == userID && a.Quarter__c == quarterID && a.Account__c == accountID){
                found = true;
                result = a;
                break;
            }
        }
        if(result == null){
            String fullName = '';
            String managerID = '';
            for(User sm1: SM1Managers){
                if (sm1.Id == userID){
                    fullName = sm1.FirstName + ' ' + sm1.LastName;
                    managerID = sm1.ManagerId;
                    break;
                }
            }
            Sales_Manager_1_FY_Total__c a = new Sales_Manager_1_FY_Total__c();
            a.OwnerId = userID;
            a.Quarter__c = quarterID;
            a.Account__c = accountID;
            //system.debug(Logginglevel.WARN, userID + ' - ' + accountID + ' - ' + managerID);
            a.Manager__c = managerID;
            a.Name = fullName + ' - ' + quarterID + ' - ' + accountID;
            insertSM1.add(a);
            SM1.add(a);
            result = a;
        }
        return result;
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
    Helper method that requeries each forecast object to get latest insert/updates
    */
    private void refreshForecasts(){
        
        rep2 = [Select r.Quarter__c, r.Owner__c, r.Name, r.Manager__c, r.Manager_FY_Total__c, r.Id, r.Digital_Actual__c, r.Display_Actual__c, r.Mobile_Actual__c, r.Base_Actual__c, r.Account__c From Rep_2_FY_Total__c r WHERE r.Account__c IN :accountList];
        rep1 = [Select r.Quarter__c, r.Owner__c, r.Name, r.Manager__c, r.Manager_FY_Total__c, r.Id, r.Digital_Actual__c, r.Display_Actual__c, r.Mobile_Actual__c, r.Base_Actual__c, r.Account__c From Rep_1_FY_Total__c r WHERE r.Account__c IN :accountList];
        sm2 = [Select r.Quarter__c, r.Owner__c, r.Name, r.Manager__c, r.Manager_FY_Total__c, r.Id, r.Digital_Actual__c, r.Display_Actual__c, r.Mobile_Actual__c, r.Base_Actual__c, r.Account__c From Sales_Manager_2_FY_Total__c r WHERE r.Account__c IN :accountList];
        sm1 = [Select r.Quarter__c, r.OwnerId, r.Name, r.Manager__c, r.Id, r.Digital_Actual__c, r.Base_Actual__c, r.Display_Actual__c, r.Mobile_Actual__c, r.Account__c From Sales_Manager_1_FY_Total__c r WHERE r.Account__c IN :accountList];
        
    }
    
    
    /*
    Helper method that clears the insert lists of each type of forecast
    */
    private void clearInsertLists(){
        insertRep2 = new List<Rep_2_FY_Total__c>();
        insertRep1 = new List<Rep_1_FY_Total__c>();
        insertSM2 = new List<Sales_Manager_2_FY_Total__c>();
        insertSM1 = new List<Sales_Manager_1_FY_Total__c>();
    }
    
    
    /*
    Method that takes a Set<String> containing forecasts to update and updates them
    param uniquePairs - a set of unique strings in the form 005F0000001wYSzIAM-Q12012, each string represents a forecast to be updated
    return - none, stores values in the appropriate list to be updated
    */
    private void updateForecasts(Set<String> uniquePairs, String forecastType){
        for (string x : uniquePairs){
            String fullString = x;
            String userID = x.substring(0, x.indexOf('-'));
            x = x.substring(x.indexOf('-') + 1);
            String quarterID = x.substring(0, x.indexOf('-'));
            x = x.substring(x.indexOf('-') + 1);
            String accountID = x;
            double baseActual = 0.0;
            double digitalActual = 0.0;
            double displayActual = 0.0;
            double mobileActual = 0.0;
            //for each Program Forecast, increment the appropriate record(s)
            for (Program_Forecast__c pf1 : pF){
                if (pf1.Program__r.Opportunity__r.OwnerId == userID && pf1.Ad_Period__r.Quarter__c == quarterID && pf1.Program__r.Opportunity__r.Account.Id == accountID){
                    system.debug('***break1');
                    if (pf1.Ad_Period__r.Is_Split__c == 'true'){
                        //manufacturing digital
                        if (pf1.Program__r.Delivery_Type__c == digitalType){
                            //if split forecasts not entered
                            if ((Double.valueOf(pf1.Previous_Quarter_Amount__c) == 0 && Double.valueOf(pf1.Next_Quarter_Amount__c) == 0) || Double.valueOf(pf1.Previous_Quarter_Amount__c) == null){
                                if (Double.valueOf(pf1.Previous_Quarter_Actual__c) == null && Double.valueOf(pf1.Next_Quarter_Actual__c) != null){
                                    digitalActual += (Double.valueOf(pf1.Actual_Amount__c) - Double.valueOf(pf1.Next_Quarter_Actual__c));
                                } else {
                                    digitalActual += (Double.valueOf(pf1.Previous_Quarter_Actual__c) == null ? (Double.valueOf(pf1.Actual_Amount__c) == null? 0 : Double.valueOf(pf1.Actual_Amount__c)) * pf1.Previous_Quarter_Ratio__c/100 : Double.valueOf(pf1.Previous_Quarter_Actual__c));
                                }
                            }
                            //if split forecasts entered
                            else{
                                if (Double.valueOf(pf1.Previous_Quarter_Actual__c) == null && Double.valueOf(pf1.Next_Quarter_Actual__c) != null){
                                    digitalActual += (Double.valueOf(pf1.Actual_Amount__c) - Double.valueOf(pf1.Next_Quarter_Actual__c));
                                } else {
                                    digitalActual += (Double.valueOf(pf1.Previous_Quarter_Actual__c) == null ? (Double.valueOf(pf1.Actual_Amount__c) == null? 0 : Double.valueOf(pf1.Actual_Amount__c)) * pf1.Previous_Quarter_Ratio__c/100 : Double.valueOf(pf1.Previous_Quarter_Actual__c));
                                }
                            }    
                        }
                        //base
                        else if (pf1.Program__r.Delivery_Type__c == baseType){
                            if ((Double.valueOf(pf1.Previous_Quarter_Amount__c) == 0 && Double.valueOf(pf1.Next_Quarter_Amount__c) == 0) || Double.valueOf(pf1.Previous_Quarter_Amount__c) == null){
                                if (Double.valueOf(pf1.Previous_Quarter_Actual__c) == null && Double.valueOf(pf1.Next_Quarter_Actual__c) != null){
                                    baseActual += (Double.valueOf(pf1.Actual_Amount__c) - Double.valueOf(pf1.Next_Quarter_Actual__c));
                                } else {
                                    baseActual += (Double.valueOf(pf1.Previous_Quarter_Actual__c) == null ? (Double.valueOf(pf1.Actual_Amount__c) == null? 0 : Double.valueOf(pf1.Actual_Amount__c)) * pf1.Previous_Quarter_Ratio__c/100 : Double.valueOf(pf1.Previous_Quarter_Actual__c));
                                }
                            }
                            //if split forecasts entered
                            else{
                                if (Double.valueOf(pf1.Previous_Quarter_Actual__c) == null && Double.valueOf(pf1.Next_Quarter_Actual__c) != null){
                                    baseActual += (Double.valueOf(pf1.Actual_Amount__c) - Double.valueOf(pf1.Next_Quarter_Actual__c));
                                } else {
                                    baseActual += (Double.valueOf(pf1.Previous_Quarter_Actual__c) == null ? (Double.valueOf(pf1.Actual_Amount__c) == null? 0 : Double.valueOf(pf1.Actual_Amount__c)) * pf1.Previous_Quarter_Ratio__c/100 : Double.valueOf(pf1.Previous_Quarter_Actual__c));
                                }
                            }
                        }
                        //display
                        else if (pf1.Program__r.Delivery_Type__c == audienceType){
                            if ((Double.valueOf(pf1.Previous_Quarter_Amount__c) == 0 && Double.valueOf(pf1.Next_Quarter_Amount__c) == 0) || Double.valueOf(pf1.Previous_Quarter_Amount__c) == null){
                                if (Double.valueOf(pf1.Previous_Quarter_Actual__c) == null && Double.valueOf(pf1.Next_Quarter_Actual__c) != null){
                                    displayActual += (Double.valueOf(pf1.Actual_Amount__c) - Double.valueOf(pf1.Next_Quarter_Actual__c));
                                } else {
                                    displayActual += (Double.valueOf(pf1.Previous_Quarter_Actual__c) == null ? (Double.valueOf(pf1.Actual_Amount__c) == null? 0 : Double.valueOf(pf1.Actual_Amount__c)) * pf1.Previous_Quarter_Ratio__c/100 : Double.valueOf(pf1.Previous_Quarter_Actual__c));
                                }
                            }
                            //if split forecasts entered
                            else{
                                if (Double.valueOf(pf1.Previous_Quarter_Actual__c) == null && Double.valueOf(pf1.Next_Quarter_Actual__c) != null){
                                    displayActual += (Double.valueOf(pf1.Actual_Amount__c) - Double.valueOf(pf1.Next_Quarter_Actual__c));
                                } else {
                                    displayActual += (Double.valueOf(pf1.Previous_Quarter_Actual__c) == null ? (Double.valueOf(pf1.Actual_Amount__c) == null? 0 : Double.valueOf(pf1.Actual_Amount__c)) * pf1.Previous_Quarter_Ratio__c/100 : Double.valueOf(pf1.Previous_Quarter_Actual__c));
                                }
                            }
                        }
                        //mobile
                        else if (pf1.Program__r.Delivery_Type__c == mobileType){
                            if ((Double.valueOf(pf1.Previous_Quarter_Amount__c) == 0 && Double.valueOf(pf1.Next_Quarter_Amount__c) == 0) || Double.valueOf(pf1.Previous_Quarter_Amount__c) == null){
                                if (Double.valueOf(pf1.Previous_Quarter_Actual__c) == null && Double.valueOf(pf1.Next_Quarter_Actual__c) != null){
                                    mobileActual += (Double.valueOf(pf1.Actual_Amount__c) - Double.valueOf(pf1.Next_Quarter_Actual__c));
                                } else {
                                    mobileActual += (Double.valueOf(pf1.Previous_Quarter_Actual__c) == null ? (Double.valueOf(pf1.Actual_Amount__c) == null? 0 : Double.valueOf(pf1.Actual_Amount__c)) * pf1.Previous_Quarter_Ratio__c/100 : Double.valueOf(pf1.Previous_Quarter_Actual__c));
                                }
                            }
                            //if split forecasts entered
                            else{
                                if (Double.valueOf(pf1.Previous_Quarter_Actual__c) == null && Double.valueOf(pf1.Next_Quarter_Actual__c) != null){
                                    mobileActual += (Double.valueOf(pf1.Actual_Amount__c) - Double.valueOf(pf1.Next_Quarter_Actual__c));
                                } else {
                                    mobileActual += (Double.valueOf(pf1.Previous_Quarter_Actual__c) == null ? (Double.valueOf(pf1.Actual_Amount__c) == null? 0 : Double.valueOf(pf1.Actual_Amount__c)) * pf1.Previous_Quarter_Ratio__c/100 : Double.valueOf(pf1.Previous_Quarter_Actual__c));
                                }
                            }
                        }
                    }
                    else {
                        //digital
                        if (pf1.Program__r.Delivery_Type__c == digitalType){
                            digitalActual += (Double.valueOf(pf1.Actual_Amount__c) == null? 0 : Double.valueOf(pf1.Actual_Amount__c));   
                        }
                        //base
                        else if (pf1.Program__r.Delivery_Type__c == baseType){
                            baseActual += (Double.valueOf(pf1.Actual_Amount__c) == null? 0 : Double.valueOf(pf1.Actual_Amount__c));
                        }
                        //display
                        else if (pf1.Program__r.Delivery_Type__c == audienceType){
                            displayActual += (Double.valueOf(pf1.Actual_Amount__c) == null? 0 : Double.valueOf(pf1.Actual_Amount__c));
                        }
                        //mobile
                        else if (pf1.Program__r.Delivery_Type__c == mobileType){
                            mobileActual += (Double.valueOf(pf1.Actual_Amount__c) == null? 0 : Double.valueOf(pf1.Actual_Amount__c));
                        }
                    }
                }
                //if from a split forecast and we take next quarter amount
                //edited march 12
                else if (pf1.Ad_Period__r.Is_Split__c == 'true' && pf1.Program__r.Opportunity__r.OwnerId == userID && getNextQuarter(pf1.Ad_Period__r.Quarter__c) == quarterID && pf1.Program__r.Opportunity__r.Account.Id == accountID){
                    //manufacturing digital
                    system.debug('***break2');
                    if (pf1.Program__r.Delivery_Type__c == digitalType){
                        if ((Double.valueOf(pf1.Previous_Quarter_Amount__c) == 0 && Double.valueOf(pf1.Next_Quarter_Amount__c) == 0) || Double.valueOf(pf1.Next_Quarter_Amount__c) == null){
                            if (Double.valueOf(pf1.Next_Quarter_Actual__c) == null && Double.valueOf(pf1.Previous_Quarter_Actual__c) != null){
                                digitalActual += (Double.valueOf(pf1.Actual_Amount__c) - Double.valueOf(pf1.Previous_Quarter_Actual__c));
                            } else {
                                digitalActual += (Double.valueOf(pf1.Next_Quarter_Actual__c) == null ? (Double.valueOf(pf1.Actual_Amount__c) == null? 0 : Double.valueOf(pf1.Actual_Amount__c)) * pf1.Next_Quarter_Ratio__c/100 : Double.valueOf(pf1.Next_Quarter_Actual__c));
                            }
                        }
                        else{
                            if (Double.valueOf(pf1.Next_Quarter_Actual__c) == null && Double.valueOf(pf1.Previous_Quarter_Actual__c) != null){
                                digitalActual += (Double.valueOf(pf1.Actual_Amount__c) - Double.valueOf(pf1.Previous_Quarter_Actual__c));
                            } else {
                                digitalActual += (Double.valueOf(pf1.Next_Quarter_Actual__c) == null ? (Double.valueOf(pf1.Actual_Amount__c) == null? 0 : Double.valueOf(pf1.Actual_Amount__c)) * pf1.Next_Quarter_Ratio__c/100 : Double.valueOf(pf1.Next_Quarter_Actual__c));
                            }
                        }
                    //base
                    } else if (pf1.Program__r.Delivery_Type__c == baseType){
                        if ((Double.valueOf(pf1.Previous_Quarter_Amount__c) == 0 && Double.valueOf(pf1.Next_Quarter_Amount__c) == 0) || Double.valueOf(pf1.Next_Quarter_Amount__c) == null){
                            if (Double.valueOf(pf1.Next_Quarter_Actual__c) == null && Double.valueOf(pf1.Previous_Quarter_Actual__c) != null){
                                baseActual += (Double.valueOf(pf1.Actual_Amount__c) - Double.valueOf(pf1.Previous_Quarter_Actual__c));
                            } else {
                                baseActual += (Double.valueOf(pf1.Next_Quarter_Actual__c) == null ? (Double.valueOf(pf1.Actual_Amount__c) == null? 0 : Double.valueOf(pf1.Actual_Amount__c)) * pf1.Next_Quarter_Ratio__c/100 : Double.valueOf(pf1.Next_Quarter_Actual__c));
                            }
                        }
                        else{
                            if (Double.valueOf(pf1.Next_Quarter_Actual__c) == null && Double.valueOf(pf1.Previous_Quarter_Actual__c) != null){
                                baseActual += (Double.valueOf(pf1.Actual_Amount__c) - Double.valueOf(pf1.Previous_Quarter_Actual__c));
                            } else {
                                baseActual += (Double.valueOf(pf1.Next_Quarter_Actual__c) == null ? (Double.valueOf(pf1.Actual_Amount__c) == null? 0 : Double.valueOf(pf1.Actual_Amount__c)) * pf1.Next_Quarter_Ratio__c/100 : Double.valueOf(pf1.Next_Quarter_Actual__c));
                            }
                        }
                    } else if (pf1.Program__r.Delivery_Type__c == audienceType){
                        if ((Double.valueOf(pf1.Previous_Quarter_Amount__c) == 0 && Double.valueOf(pf1.Next_Quarter_Amount__c) == 0) || Double.valueOf(pf1.Next_Quarter_Amount__c) == null){
                            if (Double.valueOf(pf1.Next_Quarter_Actual__c) == null && Double.valueOf(pf1.Previous_Quarter_Actual__c) != null){
                                displayActual += (Double.valueOf(pf1.Actual_Amount__c) - Double.valueOf(pf1.Previous_Quarter_Actual__c));
                            } else {
                                displayActual += (Double.valueOf(pf1.Next_Quarter_Actual__c) == null ? (Double.valueOf(pf1.Actual_Amount__c) == null? 0 : Double.valueOf(pf1.Actual_Amount__c)) * pf1.Next_Quarter_Ratio__c/100 : Double.valueOf(pf1.Next_Quarter_Actual__c));
                            }
                        }
                        else{
                            if (Double.valueOf(pf1.Next_Quarter_Actual__c) == null && Double.valueOf(pf1.Previous_Quarter_Actual__c) != null){
                                displayActual += (Double.valueOf(pf1.Actual_Amount__c) - Double.valueOf(pf1.Previous_Quarter_Actual__c));
                            } else {
                                displayActual += (Double.valueOf(pf1.Next_Quarter_Actual__c) == null ? (Double.valueOf(pf1.Actual_Amount__c) == null? 0 : Double.valueOf(pf1.Actual_Amount__c)) * pf1.Next_Quarter_Ratio__c/100 : Double.valueOf(pf1.Next_Quarter_Actual__c));
                            }
                        }
                    } else if (pf1.Program__r.Delivery_Type__c == mobileType){
                        if ((Double.valueOf(pf1.Previous_Quarter_Amount__c) == 0 && Double.valueOf(pf1.Next_Quarter_Amount__c) == 0) || Double.valueOf(pf1.Next_Quarter_Amount__c) == null){
                            if (Double.valueOf(pf1.Next_Quarter_Actual__c) == null && Double.valueOf(pf1.Previous_Quarter_Actual__c) != null){
                                mobileActual += (Double.valueOf(pf1.Actual_Amount__c) - Double.valueOf(pf1.Previous_Quarter_Actual__c));
                            } else {
                                mobileActual += (Double.valueOf(pf1.Next_Quarter_Actual__c) == null ? (Double.valueOf(pf1.Actual_Amount__c) == null? 0 : Double.valueOf(pf1.Actual_Amount__c)) * pf1.Next_Quarter_Ratio__c/100 : Double.valueOf(pf1.Next_Quarter_Actual__c));
                            }
                        }
                        else{
                            if (Double.valueOf(pf1.Next_Quarter_Actual__c) == null && Double.valueOf(pf1.Previous_Quarter_Actual__c) != null){
                                mobileActual += (Double.valueOf(pf1.Actual_Amount__c) - Double.valueOf(pf1.Previous_Quarter_Actual__c));
                            } else {
                                mobileActual += (Double.valueOf(pf1.Next_Quarter_Actual__c) == null ? (Double.valueOf(pf1.Actual_Amount__c) == null? 0 : Double.valueOf(pf1.Actual_Amount__c)) * pf1.Next_Quarter_Ratio__c/100 : Double.valueOf(pf1.Next_Quarter_Actual__c));
                            }
                        }
                    }
                }
            }
            if (forecastType == rep1Type){
                Rep_1_FY_Total__c thisForecast = createRep1Forecast(fullString);
                if (thisForecast != null){
                    thisForecast.Base_Actual__c += baseActual;
                    thisForecast.Digital_Actual__c += digitalActual;
                    if (Double.valueOf(thisforecast.Display_Actual__c) == null) thisForecast.Display_Actual__c = 0;
                    if (Double.valueOf(thisforecast.Mobile_Actual__c) == null) thisForecast.Mobile_Actual__c = 0;
                    thisForecast.Display_Actual__c += displayActual;
                    thisForecast.Mobile_Actual__c += mobileActual;
                    insertRep1.add(thisForecast);
                }
            }else if (forecastType == rep2Type){
                Rep_2_FY_Total__c thisForecast = createRep2Forecast(fullString);
                if (thisForecast!= null){
                    thisForecast.Base_Actual__c += baseActual;
                    thisForecast.Digital_Actual__c += digitalActual;
                    if (Double.valueOf(thisforecast.Display_Actual__c) == null) thisForecast.Display_Actual__c = 0;
                    if (Double.valueOf(thisforecast.Mobile_Actual__c) == null) thisForecast.Mobile_Actual__c = 0;
                    thisForecast.Display_Actual__c += displayActual;
                    thisForecast.Mobile_Actual__c += mobileActual;
                    insertRep2.add(thisForecast);
                }
            }else if (forecastType == SM1Type){
                Sales_Manager_1_FY_Total__c thisForecast = createSM1Forecast(fullString);
                if (thisForecast!= null){
                    thisForecast.Base_Actual__c += baseActual;
                    thisForecast.Digital_Actual__c += digitalActual;
                    if (Double.valueOf(thisforecast.Display_Actual__c) == null) thisForecast.Display_Actual__c = 0;
                    if (Double.valueOf(thisforecast.Mobile_Actual__c) == null) thisForecast.Mobile_Actual__c = 0;
                    thisForecast.Display_Actual__c += displayActual;
                    thisForecast.Mobile_Actual__c += mobileActual;
                    insertSM1.add(thisForecast);
                }
            }else if (forecastType == SM2Type){
                Sales_Manager_2_FY_Total__c thisForecast = createSM2Forecast(fullString);
                if (thisForecast!= null){
                    thisForecast.Base_Actual__c += baseActual;
                    thisForecast.Digital_Actual__c += digitalActual;
                    if (Double.valueOf(thisforecast.Display_Actual__c) == null) thisForecast.Display_Actual__c = 0;
                    if (Double.valueOf(thisforecast.Mobile_Actual__c) == null) thisForecast.Mobile_Actual__c = 0;
                    thisForecast.Display_Actual__c += displayActual;
                    thisForecast.Mobile_Actual__c += mobileActual;
                    insertSM2.add(thisForecast);
                }
            }
        }
    }
    
    /*
    Method that takes a Set<String> containing forecasts to update and updates them
    param uniquePairs - a set of unique strings in the form 005F0000001wYSzIAM-Q12012, each string represents a forecast to be updated
    return - none, stores values in the appropriate list to be updated
    */
    private void updateCoopForecasts(Set<String> uniquePairs){
        for (string x : uniquePairs){
            String fullString = x;
            String userID = x.substring(0, x.indexOf('-'));
            x = x.substring(x.indexOf('-') + 1);
            String quarterID = x.substring(0, x.indexOf('-'));
            x = x.substring(x.indexOf('-') + 1);
            String accountID = x;
            double baseActual = 0.0;
            double digitalActual = 0.0;
            double displayActual = 0.0;
            double mobileActual = 0.0;
            //for each Program Forecast, increment the appropriate record(s)
            for (Program_Forecast__c pf1 : pF){
                if (/*pf1.Program__r.Opportunity__r.OwnerId == userID &&*/ pf1.Ad_Period__r.Quarter__c == quarterID && pf1.Program__r.Opportunity__r.Account.Id == accountID){
                    system.debug('***break1');
                    if (pf1.Ad_Period__r.Is_Split__c == 'true'){
                        //manufacturing digital
                        if (pf1.Program__r.Delivery_Type__c == digitalType){
                            //if split forecasts not entered
                            if ((Double.valueOf(pf1.Previous_Quarter_Amount__c) == 0 && Double.valueOf(pf1.Next_Quarter_Amount__c) == 0) || Double.valueOf(pf1.Previous_Quarter_Amount__c) == null){
                                if (Double.valueOf(pf1.Previous_Quarter_Actual__c) == null && Double.valueOf(pf1.Next_Quarter_Actual__c) != null){
                                    digitalActual += (Double.valueOf(pf1.Actual_Amount__c) - Double.valueOf(pf1.Next_Quarter_Actual__c));
                                } else {
                                    digitalActual += (Double.valueOf(pf1.Previous_Quarter_Actual__c) == null ? (Double.valueOf(pf1.Actual_Amount__c) == null? 0 : Double.valueOf(pf1.Actual_Amount__c)) * pf1.Previous_Quarter_Ratio__c/100 : Double.valueOf(pf1.Previous_Quarter_Actual__c));
                                }
                            }
                            //if split forecasts entered
                            else{
                                if (Double.valueOf(pf1.Previous_Quarter_Actual__c) == null && Double.valueOf(pf1.Next_Quarter_Actual__c) != null){
                                    digitalActual += (Double.valueOf(pf1.Actual_Amount__c) - Double.valueOf(pf1.Next_Quarter_Actual__c));
                                } else {
                                    digitalActual += (Double.valueOf(pf1.Previous_Quarter_Actual__c) == null ? (Double.valueOf(pf1.Actual_Amount__c) == null? 0 : Double.valueOf(pf1.Actual_Amount__c)) * pf1.Previous_Quarter_Ratio__c/100 : Double.valueOf(pf1.Previous_Quarter_Actual__c));
                                }
                            }    
                        }
                        //base
                        else if (pf1.Program__r.Delivery_Type__c == baseType){
                            if ((Double.valueOf(pf1.Previous_Quarter_Amount__c) == 0 && Double.valueOf(pf1.Next_Quarter_Amount__c) == 0) || Double.valueOf(pf1.Previous_Quarter_Amount__c) == null){
                                if (Double.valueOf(pf1.Previous_Quarter_Actual__c) == null && Double.valueOf(pf1.Next_Quarter_Actual__c) != null){
                                    baseActual += (Double.valueOf(pf1.Actual_Amount__c) - Double.valueOf(pf1.Next_Quarter_Actual__c));
                                } else {
                                    baseActual += (Double.valueOf(pf1.Previous_Quarter_Actual__c) == null ? (Double.valueOf(pf1.Actual_Amount__c) == null? 0 : Double.valueOf(pf1.Actual_Amount__c)) * pf1.Previous_Quarter_Ratio__c/100 : Double.valueOf(pf1.Previous_Quarter_Actual__c));
                                }
                            }
                            //if split forecasts entered
                            else{
                                if (Double.valueOf(pf1.Previous_Quarter_Actual__c) == null && Double.valueOf(pf1.Next_Quarter_Actual__c) != null){
                                    baseActual += (Double.valueOf(pf1.Actual_Amount__c) - Double.valueOf(pf1.Next_Quarter_Actual__c));
                                } else {
                                    baseActual += (Double.valueOf(pf1.Previous_Quarter_Actual__c) == null ? (Double.valueOf(pf1.Actual_Amount__c) == null? 0 : Double.valueOf(pf1.Actual_Amount__c)) * pf1.Previous_Quarter_Ratio__c/100 : Double.valueOf(pf1.Previous_Quarter_Actual__c));
                                }
                            }
                        }
                        //display
                        else if (pf1.Program__r.Delivery_Type__c == audienceType){
                            if ((Double.valueOf(pf1.Previous_Quarter_Amount__c) == 0 && Double.valueOf(pf1.Next_Quarter_Amount__c) == 0) || Double.valueOf(pf1.Previous_Quarter_Amount__c) == null){
                                if (Double.valueOf(pf1.Previous_Quarter_Actual__c) == null && Double.valueOf(pf1.Next_Quarter_Actual__c) != null){
                                    displayActual += (Double.valueOf(pf1.Actual_Amount__c) - Double.valueOf(pf1.Next_Quarter_Actual__c));
                                } else {
                                    displayActual += (Double.valueOf(pf1.Previous_Quarter_Actual__c) == null ? (Double.valueOf(pf1.Actual_Amount__c) == null? 0 : Double.valueOf(pf1.Actual_Amount__c)) * pf1.Previous_Quarter_Ratio__c/100 : Double.valueOf(pf1.Previous_Quarter_Actual__c));
                                }
                            }
                            //if split forecasts entered
                            else{
                                if (Double.valueOf(pf1.Previous_Quarter_Actual__c) == null && Double.valueOf(pf1.Next_Quarter_Actual__c) != null){
                                    displayActual += (Double.valueOf(pf1.Actual_Amount__c) - Double.valueOf(pf1.Next_Quarter_Actual__c));
                                } else {
                                    displayActual += (Double.valueOf(pf1.Previous_Quarter_Actual__c) == null ? (Double.valueOf(pf1.Actual_Amount__c) == null? 0 : Double.valueOf(pf1.Actual_Amount__c)) * pf1.Previous_Quarter_Ratio__c/100 : Double.valueOf(pf1.Previous_Quarter_Actual__c));
                                }
                            }
                        }
                        //mobile
                        else if (pf1.Program__r.Delivery_Type__c == mobileType){
                            if ((Double.valueOf(pf1.Previous_Quarter_Amount__c) == 0 && Double.valueOf(pf1.Next_Quarter_Amount__c) == 0) || Double.valueOf(pf1.Previous_Quarter_Amount__c) == null){
                                if (Double.valueOf(pf1.Previous_Quarter_Actual__c) == null && Double.valueOf(pf1.Next_Quarter_Actual__c) != null){
                                    mobileActual += (Double.valueOf(pf1.Actual_Amount__c) - Double.valueOf(pf1.Next_Quarter_Actual__c));
                                } else {
                                    mobileActual += (Double.valueOf(pf1.Previous_Quarter_Actual__c) == null ? (Double.valueOf(pf1.Actual_Amount__c) == null? 0 : Double.valueOf(pf1.Actual_Amount__c)) * pf1.Previous_Quarter_Ratio__c/100 : Double.valueOf(pf1.Previous_Quarter_Actual__c));
                                }
                            }
                            //if split forecasts entered
                            else{
                                if (Double.valueOf(pf1.Previous_Quarter_Actual__c) == null && Double.valueOf(pf1.Next_Quarter_Actual__c) != null){
                                    mobileActual += (Double.valueOf(pf1.Actual_Amount__c) - Double.valueOf(pf1.Next_Quarter_Actual__c));
                                } else {
                                    mobileActual += (Double.valueOf(pf1.Previous_Quarter_Actual__c) == null ? (Double.valueOf(pf1.Actual_Amount__c) == null? 0 : Double.valueOf(pf1.Actual_Amount__c)) * pf1.Previous_Quarter_Ratio__c/100 : Double.valueOf(pf1.Previous_Quarter_Actual__c));
                                }
                            }
                        }
                    }
                    else {
                        //digital
                        if (pf1.Program__r.Delivery_Type__c == digitalType){
                            digitalActual += (Double.valueOf(pf1.Actual_Amount__c) == null? 0 : Double.valueOf(pf1.Actual_Amount__c));   
                        }
                        //base
                        else if (pf1.Program__r.Delivery_Type__c == baseType){
                            baseActual += (Double.valueOf(pf1.Actual_Amount__c) == null? 0 : Double.valueOf(pf1.Actual_Amount__c));
                        }
                        //display
                        else if (pf1.Program__r.Delivery_Type__c == audienceType){
                            displayActual += (Double.valueOf(pf1.Actual_Amount__c) == null? 0 : Double.valueOf(pf1.Actual_Amount__c));
                        }
                        //mobile
                        else if (pf1.Program__r.Delivery_Type__c == mobileType){
                            mobileActual += (Double.valueOf(pf1.Actual_Amount__c) == null? 0 : Double.valueOf(pf1.Actual_Amount__c));
                        }
                    }
                }
                //if from a split forecast and we take next quarter amount
                //edited march 12
                //comment out userID clause by Warren May 16,2012
                else if (pf1.Ad_Period__r.Is_Split__c == 'true' /*&& pf1.Program__r.Opportunity__r.OwnerId == userID */ && getNextQuarter(pf1.Ad_Period__r.Quarter__c) == quarterID && pf1.Program__r.Opportunity__r.Account.Id == accountID){
                    //manufacturing digital
                    system.debug('***break2');
                    if (pf1.Program__r.Delivery_Type__c == digitalType){
                        if ((Double.valueOf(pf1.Previous_Quarter_Amount__c) == 0 && Double.valueOf(pf1.Next_Quarter_Amount__c) == 0) || Double.valueOf(pf1.Next_Quarter_Amount__c) == null){
                            if (Double.valueOf(pf1.Next_Quarter_Actual__c) == null && Double.valueOf(pf1.Previous_Quarter_Actual__c) != null){
                                digitalActual += (Double.valueOf(pf1.Actual_Amount__c) - Double.valueOf(pf1.Previous_Quarter_Actual__c));
                            } else {
                                digitalActual += (Double.valueOf(pf1.Next_Quarter_Actual__c) == null ? (Double.valueOf(pf1.Actual_Amount__c) == null? 0 : Double.valueOf(pf1.Actual_Amount__c)) * pf1.Next_Quarter_Ratio__c/100 : Double.valueOf(pf1.Next_Quarter_Actual__c));
                            }
                        }
                        else{
                            if (Double.valueOf(pf1.Next_Quarter_Actual__c) == null && Double.valueOf(pf1.Previous_Quarter_Actual__c) != null){
                                digitalActual += (Double.valueOf(pf1.Actual_Amount__c) - Double.valueOf(pf1.Previous_Quarter_Actual__c));
                            } else {
                                digitalActual += (Double.valueOf(pf1.Next_Quarter_Actual__c) == null ? (Double.valueOf(pf1.Actual_Amount__c) == null? 0 : Double.valueOf(pf1.Actual_Amount__c)) * pf1.Next_Quarter_Ratio__c/100 : Double.valueOf(pf1.Next_Quarter_Actual__c));
                            }
                        }
                    //base
                    } else if (pf1.Program__r.Delivery_Type__c == baseType){
                        if ((Double.valueOf(pf1.Previous_Quarter_Amount__c) == 0 && Double.valueOf(pf1.Next_Quarter_Amount__c) == 0) || Double.valueOf(pf1.Next_Quarter_Amount__c) == null){
                            if (Double.valueOf(pf1.Next_Quarter_Actual__c) == null && Double.valueOf(pf1.Previous_Quarter_Actual__c) != null){
                                baseActual += (Double.valueOf(pf1.Actual_Amount__c) - Double.valueOf(pf1.Previous_Quarter_Actual__c));
                            } else {
                                baseActual += (Double.valueOf(pf1.Next_Quarter_Actual__c) == null ? (Double.valueOf(pf1.Actual_Amount__c) == null? 0 : Double.valueOf(pf1.Actual_Amount__c)) * pf1.Next_Quarter_Ratio__c/100 : Double.valueOf(pf1.Next_Quarter_Actual__c));
                            }
                        }
                        else{
                            if (Double.valueOf(pf1.Next_Quarter_Actual__c) == null && Double.valueOf(pf1.Previous_Quarter_Actual__c) != null){
                                baseActual += (Double.valueOf(pf1.Actual_Amount__c) - Double.valueOf(pf1.Previous_Quarter_Actual__c));
                            } else {
                                baseActual += (Double.valueOf(pf1.Next_Quarter_Actual__c) == null ? (Double.valueOf(pf1.Actual_Amount__c) == null? 0 : Double.valueOf(pf1.Actual_Amount__c)) * pf1.Next_Quarter_Ratio__c/100 : Double.valueOf(pf1.Next_Quarter_Actual__c));
                            }
                        }
                    } else if (pf1.Program__r.Delivery_Type__c == audienceType){
                        if ((Double.valueOf(pf1.Previous_Quarter_Amount__c) == 0 && Double.valueOf(pf1.Next_Quarter_Amount__c) == 0) || Double.valueOf(pf1.Next_Quarter_Amount__c) == null){
                            if (Double.valueOf(pf1.Next_Quarter_Actual__c) == null && Double.valueOf(pf1.Previous_Quarter_Actual__c) != null){
                                displayActual += (Double.valueOf(pf1.Actual_Amount__c) - Double.valueOf(pf1.Previous_Quarter_Actual__c));
                            } else {
                                displayActual += (Double.valueOf(pf1.Next_Quarter_Actual__c) == null ? (Double.valueOf(pf1.Actual_Amount__c) == null? 0 : Double.valueOf(pf1.Actual_Amount__c)) * pf1.Next_Quarter_Ratio__c/100 : Double.valueOf(pf1.Next_Quarter_Actual__c));
                            }
                        }
                        else{
                            if (Double.valueOf(pf1.Next_Quarter_Actual__c) == null && Double.valueOf(pf1.Previous_Quarter_Actual__c) != null){
                                displayActual += (Double.valueOf(pf1.Actual_Amount__c) - Double.valueOf(pf1.Previous_Quarter_Actual__c));
                            } else {
                                displayActual += (Double.valueOf(pf1.Next_Quarter_Actual__c) == null ? (Double.valueOf(pf1.Actual_Amount__c) == null? 0 : Double.valueOf(pf1.Actual_Amount__c)) * pf1.Next_Quarter_Ratio__c/100 : Double.valueOf(pf1.Next_Quarter_Actual__c));
                            }
                        }
                    } else if (pf1.Program__r.Delivery_Type__c == mobileType){
                        if ((Double.valueOf(pf1.Previous_Quarter_Amount__c) == 0 && Double.valueOf(pf1.Next_Quarter_Amount__c) == 0) || Double.valueOf(pf1.Next_Quarter_Amount__c) == null){
                            if (pf1.Next_Quarter_Actual__c == null && pf1.Previous_Quarter_Actual__c != null){
                                mobileActual += (pf1.Actual_Amount__c - pf1.Previous_Quarter_Actual__c);
                            } else {
                                mobileActual += (Double.valueOf(pf1.Next_Quarter_Actual__c) == null ? (Double.valueOf(pf1.Actual_Amount__c) == null? 0 : Double.valueOf(pf1.Actual_Amount__c)) * pf1.Next_Quarter_Ratio__c/100 : Double.valueOf(pf1.Next_Quarter_Actual__c));
                            }
                        }
                        else{
                            if (Double.valueOf(pf1.Next_Quarter_Actual__c) == null && Double.valueOf(pf1.Previous_Quarter_Actual__c) != null){
                                mobileActual += (Double.valueOf(pf1.Actual_Amount__c) - Double.valueOf(pf1.Previous_Quarter_Actual__c));
                            } else {
                                mobileActual += (Double.valueOf(pf1.Next_Quarter_Actual__c) == null ? (Double.valueOf(pf1.Actual_Amount__c) == null? 0 : Double.valueOf(pf1.Actual_Amount__c)) * pf1.Next_Quarter_Ratio__c/100 : Double.valueOf(pf1.Next_Quarter_Actual__c));
                            }
                        }
                    }
                }
            }
            Sales_Manager_1_FY_Total__c thisForecast = createSM1Forecast(fullString);
            if (thisForecast!= null){
                thisForecast.Base_Actual__c += baseActual;
                thisForecast.Digital_Actual__c += digitalActual;
                if (Double.valueOf(thisforecast.Display_Actual__c) == null) thisForecast.Display_Actual__c = 0;
                if (Double.valueOf(thisforecast.Mobile_Actual__c) == null) thisForecast.Mobile_Actual__c = 0;
                thisForecast.Display_Actual__c += displayActual;
                thisForecast.Mobile_Actual__c += mobileActual;
                insertSM1.add(thisForecast);
            }
        }
    }
}