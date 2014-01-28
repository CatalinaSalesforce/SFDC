/*
@Name           :       BatchCreateRepForecast
@Author         :       Warren
@Date           :       Jan 6 2012
@Description    :       Batch class designed to:
                            a.) Create forecasts and the necessary master forecasts if they do not already exist
                            a.) Create SDPY forecasts for each object and link those forecasts to the current forecast objects
                            b.) Update the amounts for each forecast
*/

global class BatchCreateRepForecast implements Database.Batchable<sObject>, Schedulable{

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
    String query;
    String limit1;
    Date archiveDate;
    List<Rep_2_Forecast__c> insertRep2;
    List<Rep_1_Forecast__c> insertRep1;
    List<Sales_Manager_2_Forecast__c> insertSM2;
    List<Sales_Manager_1_Forecast__c> insertSM1;
    List<SDPY_Rep_2_Forecast__c> insertSDPYRep2;
    List<SDPY_Rep_1_Forecast__c> insertSDPYRep1;
    List<SDPY_Sales_Manager_2_Forecast__c> insertSDPYSM2;
    List<SDPY_Sales_Manager_1_Forecast__c> insertSDPYSM1;
    List<Program__c> programs;
    List<Rep_2_Forecast__c> rep2;
    List<Rep_1_Forecast__c> rep1;
    List<Sales_Manager_2_Forecast__c> sm2;
    List<Sales_Manager_1_Forecast__c> sm1;
    List<SDPY_Rep_2_Forecast__c> sdpyRep2;
    List<SDPY_Rep_1_Forecast__c> sdpyRep1;
    List<SDPY_Sales_Manager_2_Forecast__c> sdpySM2;
    List<SDPY_Sales_Manager_1_Forecast__c> sdpySM1;
    List<Program_Forecast__c> pF;
    List<Archive_Program_Forecast__c>aPF;
    List<User> Rep2Managers;
    List<User> Rep1Managers;
    List<User> SM2Managers;
    List<User> SM1Managers;
    User coopUser;
    Map<Id, User> Rep2Map;
    Map<Id, User> Rep1Map;
    Map<Id, User> SM2Map;
    Map<Id, User> SM1Map;
    Set<Id> pfFound;
    Catalina_Forecast_Settings__c settings;
    String rep2Type;
    String rep1Type;
    String SM2Type;
    String SM1Type;
    String coopType;
    Set<ID> accountList;
    Set<ID> programList;
    Map<Id, Map<String, Double>> ptsMAP;
    Map<Id, double> ptsTotalMap;
    
    public BatchCreateRepForecast(String x){
        limit1 = x;
    }
    
    public BatchCreateRepForecast(){
        limit1 = '';
    }
    
    //method that gets the query used for this batch
    global Database.querylocator start(Database.BatchableContext BC){
        BatchGovernorLimitUtility.insertBatchRun('BatchCreateRepForecast');
       
        /*
        Date lastyear = Date.Today().addYears(-1);
        Date lastyear2 = lastyear.addDays(-45);
        system.debug('***last year: ' + lastyear);
        system.debug('***last year2: ' + lastyear2);
        AggregateResult ar = [Select Max(Archive_Date__c) Expr1 From Archive_Program__c Where Archive_Date__c <= :lastyear and Archive_Date__c >= :lastyear2]; 
        archiveDate = (Date)ar.get('Expr1');
        System.debug('***use date: ' +  archiveDate);*/
        query = 'SELECT Active__c, Program__r.RecordType.Name, Actual_Amount__c, Program__r.Product_Type__c, Program__r.Opportunity__r.Account.Id, Ad_Period__r.Quarter__c, Ad_Period__r.Is_Split__c, Weighted_Forecast_Amount__c, Previous_Quarter_Amount__c, Oppty_Probability__c, Next_Quarter_Amount__c, Forecast_Amount__c, Program__r.Opportunity__r.OwnerId, Program__r.Delivery_Type__c, Program__r.Opportunity__r.Account.RecordType.Name,  Weighted_Previous_Quarter_Forecast__c, Weighted_Next_Quarter_Forecast__c, Previous_Quarter_Ratio__c,'
        + 'Previous_Quarter_Actual__c, Next_Quarter_Ratio__c, Next_Quarter_Actual__c, Program__r.Account_Type__c '
        + ' From Program_Forecast__c ' /*Where Program__r.Product_Type__c != null '*/
       // + ' Where ID = \'a0SF0000006Z832\' '
        + ' WHERE (PROGRAM__R.OPPORTUNITY__R.RECORDTYPE.NAME = \'CONTRACT\' OR PROGRAM__R.OPPORTUNITY__R.RECORDTYPE.NAME = \'PROPOSAL\' OR PROGRAM__R.OPPORTUNITY__R.RECORDTYPE.NAME = \'RECOVERY\' OR PROGRAM__R.OPPORTUNITY__R.RECORDTYPE.NAME = \'RENEWAL\') and (NOT(Program__r.Opportunity__r.IsWon = False and Program__r.Opportunity__r.IsClosed = True)) '
        + ' ORDER BY Program__r.Opportunity__r.OwnerId, Program__r.Opportunity__r.Account.Id, Ad_Period__r.Quarter__c ' + limit1;
        return Database.getQueryLocator(query);
    }
    
    global void execute(SchedulableContext ctx) {
        BatchCreateRepForecast batch1 = new BatchCreateRepForecast();
        ID batchprocessid = Database.executeBatch(batch1, 50);
    }
    
    
    //method that makes up the body of the batch process    
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        Datetime currentTime = System.now();
        system.debug('***start: ' + system.now());
        List<Program_Forecast__c> pfScope = (List<Program_Forecast__c>)scope;
        programList = new Set<Id>();
        ptsMAP = new Map<Id, Map<String, Double>>();
        settings = Catalina_Forecast_Settings__c.getInstance(defaultSettingsName);
        rep2Type = settings.Rep_2_String__c;
        rep1Type = settings.Rep_1_String__c;
        SM2Type = settings.SM_2_String__c;
        SM1Type = settings.SM_1_String__c;
        coopType = settings.Coop_String__c;
        Rep2Map = new Map<Id, User>();
        Rep1Map = new Map<Id, User>();
        SM2Map = new Map<Id, User>();
        SM1Map = new Map<Id, User>();
        Set<Id> missingPTSList = new Set<Id>();
        List<Program_Forecast_Exception__c> pfeList = new List<Program_Forecast_Exception__c>();
        pfFound = new Set<Id>();
        ptsTotalMap = new Map<Id, Double>();
        //create lists to store the objects to insert/update
        clearInsertLists();
		
		//populate sets which will help to limit queries to only the records we will need
        accountList = new Set<ID>();
        for (Program_Forecast__c a: pfScope){
            accountList.add(a.Program__r.Opportunity__r.Account.Id);
            programList.add(a.Program__c);
        }
        
        //put all of the Product Type Splits in a map to see which Programs are missing and make sure they add up to 100%
        for (Product_Type_Split__c a : [SELECT Id, Program__c, Product_Type__c, Percent__c From Product_Type_Split__c Where Program__c IN : programList]){
            if (!ptsMap.containsKey(a.Program__c)){
                ptsMap.put(a.Program__c, new Map<String, Double>());
            }
            ptsMap.get(a.Program__c).put(a.Product_Type__c, a.Percent__c);
        }
        
        for (String x : programList){
            if (!ptsMap.containsKey(x)){
                missingPTSList.add(x);
            }
        }
        
        //if Product Type Splits are missing, set them to NA
        List<Program__c> missingPrograms = [Select Id, Product_Type__c From Program__c Where Id IN : missingPTSList];
        for (Program__c a : missingPrograms){
            if (a.Product_Type__c == null){
                a.Product_Type__c = 'NA';
            }
            //split the multi-select picklist values into an array
            String[] productTypes = a.Product_Type__c.split(';');
            for (String product : productTypes){
                //create a new Product Type Split for each selection
                Product_Type_Split__c x = new Product_Type_Split__c();
                x.Program__c = a.Id;
                x.Product_Type__c = product;
                x.Percent__c = (100.00/productTypes.size()).setScale(2);
                system.debug('*** assigning percent: ' + x.Percent__c);
                if (!ptsMap.containsKey(a.Id)){
                    ptsMap.put(a.Id, new Map<String, Double>());
                }
                ptsMap.get(a.Id).put(x.Product_Type__c, x.Percent__c);
                system.debug('***adding to ptsMap - ' + a.id + ' - ' + x.Product_Type__c + ': ' + x.Percent__c);
            }
        }
        
        update missingPrograms;
        
        //refresh PTS Map
        ptsMAP = new Map<Id, Map<String, Double>>();
        for (Product_Type_Split__c a : [SELECT Id, Program__c, Product_Type__c, Percent__c From Product_Type_Split__c Where Program__c IN : programList]){
            if (!ptsMap.containsKey(a.Program__c)){
                ptsMap.put(a.Program__c, new Map<String, Double>());
            }
            if (!ptsTotalMap.containsKey(a.Program__c)){
                ptsTotalMap.put(a.Program__c, 0.0);
            }
            ptsMap.get(a.Program__c).put(a.Product_Type__c, a.Percent__c);
            Double tempNum = ptsTotalMap.get(a.Program__c);
            tempNum += a.Percent__c;
            system.debug('***new Percent: ' + a.Program__c + ' - ' + tempNum);
            ptsTotalMap.remove(a.Program__c);
            ptsTotalMap.put(a.Program__c, tempNum);
            system.debug('***adding to ptsMap - ' + a.Program__c + ' - ' + a.Product_Type__c + ': ' + a.Percent__c);
        }
        
        //check which Programs and Accounts already have been recorded for errors so they are not repeat
        List<Program_Forecast_Exception__c> pfeProgs = [SELECT ID, PROGRAM__C, Account__c FROM PROGRAM_FORECAST_EXCEPTION__C
            WHERE (PROGRAM__C != NULL AND PROGRAM__C IN :programList) OR (ACCOUNT__C != NULL AND ACCOUNT__C IN :accountList)];
        Set<Id> errorProgs = new Set<Id>();
        Set<Id> errorAccs = new Set<Id>();
        Set<Id> insAccSet = new Set<Id>();
        for (Program_Forecast_Exception__c a : pfeProgs){
            if (a.Program__c != null) errorProgs.add(a.Program__c);
            if (a.Account__c != null) errorAccs.add(a.Account__c);
        }
        
        //if PTS != 100, record it so we can notify admins later on
        for (String x : programList){
            system.debug('***checking program: ' + x );
            if (ptsTotalMap.containsKey(x)){
                if (ptsTotalMap.get(x) != 100 && !errorProgs.contains(x)){
                    system.debug('***adding program: ' + x + ' - ' + ptsTotalMap.get(x));
                    Program_Forecast_Exception__c pfe = new Program_Forecast_Exception__c();
                    pfe.Program__c = x;
                    pfe.Reason__c = 'PTS Total != 100';
                    system.debug('***Program PTS error: ' + x);
                    pfeList.add(pfe);
                }
            }
        }
        
        //if a Program Account Type and the Opp Account Record Type do not match, record it
        for (Program_Forecast__c a : pfScope){
            if (a.Program__r.Opportunity__r.Account.RecordType.Name != a.Program__r.Account_Type__c){
                if (!insAccSet.contains(a.Program__r.Opportunity__r.AccountId)){
                    insAccset.add(a.Program__r.Opportunity__r.AccountId);
                    Program_Forecast_Exception__c pfe = new Program_Forecast_Exception__c();
                    pfe.Account__c = a.Program__r.Opportunity__r.AccountId;
                    pfe.Program__c = a.Program__c;
                    pfe.Reason__c = 'Mismatched Account RT and Program Account Type';
                    pfeList.add(pfe);
                }
            }
        }
        
        refreshForecasts();
        
        //bucket each user by forecast role
        List<User> temp1 = [SELECT ID FROM USER WHERE FORECAST_ROLE__C =: coopType];
        if (temp1.size() > 0){
            coopUser = temp1.get(0);
        }
        List<User> allUsers = [SELECT ID, Forecast_Role__c, FirstName, LastName,  UserRole.Name, ManagerId FROM USER WHERE Forecast_Role__c != NULL And ManagerID  != NULL];
        //get Sales Rep 2s that need to be created or should already exist
        Rep2Managers = new List<User>();
        for (User a : allUsers){
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
        //Start process to create Sales Rep 2 Forecasts and all non-existent parents
        Set<ID>userIDList = new Set<ID>();
        for (User s : Rep2Managers){
            userIDList.add(s.Id);
        }
        Set<ID>pfList = new Set<ID>();
        for (Program_Forecast__c a: pfScope){
            pfList.add(a.Id);
        }
        pf = new List<Program_Forecast__c>();
        for (Program_Forecast__c a : pfScope){
            if (userIDList.contains(a.Program__r.Opportunity__r.OwnerId)){
                pf.add(a);
            }
        }
        //get unique combinations of reps and quarters that we will need to create forecasts for
        Set<String> uniquePairs = new Set<String>();
        for (Program_Forecast__c a : pf){
            if (a.Program__r.Product_Type__c == null){
                if (!uniquePairs.contains(a.Program__r.Opportunity__r.OwnerId + '-'+ a.Ad_Period__r.Quarter__c + '-' +a.Program__r.Opportunity__r.Account.Id + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + '')){
                uniquePairs.add(a.Program__r.Opportunity__r.OwnerId + '-'+ a.Ad_Period__r.Quarter__c + '-' +a.Program__r.Opportunity__r.Account.Id  + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + '');
                }
                if (a.Ad_Period__r.Is_Split__c == 'true'){
                    if (!uniquePairs.contains(a.Program__r.Opportunity__r.OwnerId + '-'+ getNextQuarter(a.Ad_Period__r.Quarter__c) + '-' +a.Program__r.Opportunity__r.Account.Id  + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + '')){
                        uniquePairs.add(a.Program__r.Opportunity__r.OwnerId + '-'+ getNextQuarter(a.Ad_Period__r.Quarter__c) + '-' +a.Program__r.Opportunity__r.Account.Id  + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + '');
                    }           
                }   
            } else {
                for (String x : a.Program__r.Product_Type__c.split(';')){
                    if (!uniquePairs.contains(a.Program__r.Opportunity__r.OwnerId + '-'+ a.Ad_Period__r.Quarter__c + '-' +a.Program__r.Opportunity__r.Account.Id + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + x)){
                    uniquePairs.add(a.Program__r.Opportunity__r.OwnerId + '-'+ a.Ad_Period__r.Quarter__c + '-' +a.Program__r.Opportunity__r.Account.Id  + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + x);
                    }
                    if (a.Ad_Period__r.Is_Split__c == 'true'){
                        if (!uniquePairs.contains(a.Program__r.Opportunity__r.OwnerId + '-'+ getNextQuarter(a.Ad_Period__r.Quarter__c) + '-' +a.Program__r.Opportunity__r.Account.Id  + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + x)){
                            uniquePairs.add(a.Program__r.Opportunity__r.OwnerId + '-'+ getNextQuarter(a.Ad_Period__r.Quarter__c) + '-' +a.Program__r.Opportunity__r.Account.Id  + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + x);
                        }           
                    }
                }
            }
        }
        
        system.debug('***before insert SDPYSM1: ' + system.now());
        //create Sales Manager 1 Forecasts that don't already exist
        for(string x : uniquePairs){
            createRep2Forecast(x);
        }
        insert insertSDPYSM1;
        system.debug('***after insert SDPYSM1: ' + system.now());
        //requery and create Sales Manager 2 Forecasts that don't already exist
        refreshForecasts();
        clearInsertLists();
        for(string x : uniquePairs){
            createRep2Forecast(x);
        }
        insert insertSDPYSM2;
        system.debug('***after insert SDPYSM2: ' + system.now());
        //requery and create Sales Rep 1 Forecasts that don't already exist
        refreshForecasts();
        clearInsertLists();
        for(string x : uniquePairs){
            createRep2Forecast(x);
        }
        insert insertSDPYRep1;
        system.debug('***after insert SDPYRep1: ' + system.now());
        //requery and create Sales Rep 2 Forecasts that don't already exist
        refreshForecasts();
        clearInsertLists();
        for(string x : uniquePairs){
            createRep2Forecast(x);
        }
        insert insertSDPYRep2;
        system.debug('***after insert SDPYRep2: ' + system.now());
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
        rep2 = [Select r.Weighted_Forecast_Proposal__c, r.SDPY_Forecast__c, r.Quarter__c, r.Quarter_Start_Date__c, r.Quarter_End_Date__c, r.Product_Type__c, r.OwnerId, r.Name, r.Manager__c, r.Manager_Forecast__c, r.Id, r.Forecast_Proposal__c, r.Forecast_Contract__c, r.Delivery_Type__c, r.Actual_Amount__c, r.Account__c, r.Account_Type__c From Rep_2_Forecast__c r WHERE r.Account__c IN :accountList];
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
        pf = new List<Program_Forecast__c>();
        for (Program_Forecast__c a : pfScope){
            if (userIDList.contains(a.Program__r.Opportunity__r.OwnerId)){
                pf.add(a);
            }
        }
        //get unique combinations of reps and quarters that we will need to create forecasts for
        uniquePairs = new Set<String>();
        for (Program_Forecast__c a : pf){
            if (a.Program__r.Product_Type__c == null){
                if (!uniquePairs.contains(a.Program__r.Opportunity__r.OwnerId + '-'+ a.Ad_Period__r.Quarter__c + '-' +a.Program__r.Opportunity__r.Account.Id + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + '')){
                uniquePairs.add(a.Program__r.Opportunity__r.OwnerId + '-'+ a.Ad_Period__r.Quarter__c + '-' +a.Program__r.Opportunity__r.Account.Id  + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + '');
                }
                if (a.Ad_Period__r.Is_Split__c == 'true'){
                    if (!uniquePairs.contains(a.Program__r.Opportunity__r.OwnerId + '-'+ getNextQuarter(a.Ad_Period__r.Quarter__c) + '-' +a.Program__r.Opportunity__r.Account.Id  + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + '')){
                        uniquePairs.add(a.Program__r.Opportunity__r.OwnerId + '-'+ getNextQuarter(a.Ad_Period__r.Quarter__c) + '-' +a.Program__r.Opportunity__r.Account.Id  + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + '');
                    }           
                }   
            } else {
                for (String x : a.Program__r.Product_Type__c.split(';')){
                    if (!uniquePairs.contains(a.Program__r.Opportunity__r.OwnerId + '-'+ a.Ad_Period__r.Quarter__c + '-' +a.Program__r.Opportunity__r.Account.Id + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + x)){
                    uniquePairs.add(a.Program__r.Opportunity__r.OwnerId + '-'+ a.Ad_Period__r.Quarter__c + '-' +a.Program__r.Opportunity__r.Account.Id  + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + x);
                    }
                    if (a.Ad_Period__r.Is_Split__c == 'true'){
                        if (!uniquePairs.contains(a.Program__r.Opportunity__r.OwnerId + '-'+ getNextQuarter(a.Ad_Period__r.Quarter__c) + '-' +a.Program__r.Opportunity__r.Account.Id  + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + x)){
                            uniquePairs.add(a.Program__r.Opportunity__r.OwnerId + '-'+ getNextQuarter(a.Ad_Period__r.Quarter__c) + '-' +a.Program__r.Opportunity__r.Account.Id  + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + x);
                        }           
                    }
                }
            }
        }
        
        //create Sales Manager 1 Forecasts that don't already exist
        for(string x : uniquePairs){
            createRep1Forecast(x);
        }
        insert insertSDPYSM1;
        //requery and create Sales Manager 2 Forecasts that don't already exist
        refreshForecasts();
        clearInsertLists();
        for(string x : uniquePairs){
            createRep1Forecast(x);
        }
        insert insertSDPYSM2;
        //requery and create Sales Rep 1 Forecasts that don't already exist
        refreshForecasts();
        clearInsertLists();
        for(string x : uniquePairs){
            createRep1Forecast(x);
        }
        insert insertSDPYRep1;
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
        //Warren code change Nov 14
        sm2 = [Select r.Weighted_Forecast_Proposal__c, r.SDPY_Forecast__c, r.Quarter__c, r.Quarter_Start_Date__c, r.Quarter_End_Date__c, r.Product_Type__c, r.OwnerId, r.Name, r.Manager__c, r.Manager_Forecast__c, r.Id, r.Forecast_Proposal__c, r.Forecast_Contract__c, r.Delivery_Type__c, r.Actual_Amount__c, r.Account__c, r.Account_Type__c From Sales_Manager_2_Forecast__c r WHERE r.Account__c IN :accountList];
        rep1 = [Select r.Weighted_Forecast_Proposal__c, r.SDPY_Forecast__c, r.Quarter__c, r.Quarter_Start_Date__c, r.Quarter_End_Date__c, r.Product_Type__c, r.OwnerId, r.Name, r.Manager__c, r.Manager_Forecast__c, r.Id, r.Forecast_Proposal__c, r.Forecast_Contract__c, r.Delivery_Type__c, r.Actual_Amount__c, r.Account__c, r.Account_Type__c From Rep_1_Forecast__c r WHERE r.Account__c IN :accountList];
        //end Warren code change Nov 14
        clearInsertLists();
        for(string x : uniquePairs){
            createRep1Forecast(x);
        }
        insert insertRep1;
        //requery and get list for forecast amount updates
        rep1 = [Select r.Weighted_Forecast_Proposal__c, r.SDPY_Forecast__c, r.Quarter__c, r.Quarter_Start_Date__c, r.Quarter_End_Date__c, r.Product_Type__c, r.OwnerId, r.Name, r.Manager__c, r.Manager_Forecast__c, r.Id, r.Forecast_Proposal__c, r.Forecast_Contract__c, r.Delivery_Type__c, r.Actual_Amount__c, r.Account__c, r.Account_Type__c From Rep_1_Forecast__c r WHERE r.Account__c IN :accountList];
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
        pf = new List<Program_Forecast__c>();
        for (Program_Forecast__c a : pfScope){
            if (userIDList.contains(a.Program__r.Opportunity__r.OwnerId)){
                pf.add(a);
            }
        }
        //get unique combinations of reps and quarters that we will need to create forecasts for
        uniquePairs = new Set<String>();
        for (Program_Forecast__c a : pf){
            if (a.Program__r.Product_Type__c == null){
                if (!uniquePairs.contains(a.Program__r.Opportunity__r.OwnerId + '-'+ a.Ad_Period__r.Quarter__c + '-' +a.Program__r.Opportunity__r.Account.Id + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + '')){
                uniquePairs.add(a.Program__r.Opportunity__r.OwnerId + '-'+ a.Ad_Period__r.Quarter__c + '-' +a.Program__r.Opportunity__r.Account.Id  + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + '');
                }
                if (a.Ad_Period__r.Is_Split__c == 'true'){
                    if (!uniquePairs.contains(a.Program__r.Opportunity__r.OwnerId + '-'+ getNextQuarter(a.Ad_Period__r.Quarter__c) + '-' +a.Program__r.Opportunity__r.Account.Id  + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + '')){
                        uniquePairs.add(a.Program__r.Opportunity__r.OwnerId + '-'+ getNextQuarter(a.Ad_Period__r.Quarter__c) + '-' +a.Program__r.Opportunity__r.Account.Id  + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + '');
                    }           
                }   
            } else {
                for (String x : a.Program__r.Product_Type__c.split(';')){
                    if (!uniquePairs.contains(a.Program__r.Opportunity__r.OwnerId + '-'+ a.Ad_Period__r.Quarter__c + '-' +a.Program__r.Opportunity__r.Account.Id + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + x)){
                    uniquePairs.add(a.Program__r.Opportunity__r.OwnerId + '-'+ a.Ad_Period__r.Quarter__c + '-' +a.Program__r.Opportunity__r.Account.Id  + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + x);
                    }
                    if (a.Ad_Period__r.Is_Split__c == 'true'){
                        if (!uniquePairs.contains(a.Program__r.Opportunity__r.OwnerId + '-'+ getNextQuarter(a.Ad_Period__r.Quarter__c) + '-' +a.Program__r.Opportunity__r.Account.Id  + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + x)){
                            uniquePairs.add(a.Program__r.Opportunity__r.OwnerId + '-'+ getNextQuarter(a.Ad_Period__r.Quarter__c) + '-' +a.Program__r.Opportunity__r.Account.Id  + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + x);
                        }           
                    }
                }
            }
        }
        
        //create Sales Manager 1 Forecasts that don't already exist
        for(string x : uniquePairs){
            createSM2Forecast(x);
        }
        insert insertSDPYSM1;
        //requery and create Sales Manager 2 Forecasts that don't already exist
        refreshForecasts();
        clearInsertLists();
        for(string x : uniquePairs){
            createSM2Forecast(x);
        }
        insert insertSDPYSM2;
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
        sm2 = [Select r.Weighted_Forecast_Proposal__c, r.SDPY_Forecast__c, r.Quarter__c, r.Quarter_Start_Date__c, r.Quarter_End_Date__c, r.Product_Type__c, r.OwnerId, r.Name, r.Manager__c, r.Manager_Forecast__c, r.Id, r.Forecast_Proposal__c, r.Forecast_Contract__c, r.Delivery_Type__c, r.Actual_Amount__c, r.Account__c, r.Account_Type__c From Sales_Manager_2_Forecast__c r WHERE r.Account__c IN :accountList];
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
        pf = new List<Program_Forecast__c>();
        for (Program_Forecast__c a : pfScope){
            if (userIDList.contains(a.Program__r.Opportunity__r.OwnerId)){
                pf.add(a);
            }
        }
        //get unique combinations of reps and quarters that we will need to create forecasts for
        uniquePairs = new Set<String>();
        for (Program_Forecast__c a : pf){
            if (a.Program__r.Product_Type__c == null){
                if (!uniquePairs.contains(a.Program__r.Opportunity__r.OwnerId + '-'+ a.Ad_Period__r.Quarter__c + '-' +a.Program__r.Opportunity__r.Account.Id + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + '')){
                uniquePairs.add(a.Program__r.Opportunity__r.OwnerId + '-'+ a.Ad_Period__r.Quarter__c + '-' +a.Program__r.Opportunity__r.Account.Id  + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + '');
                }
                if (a.Ad_Period__r.Is_Split__c == 'true'){
                    if (!uniquePairs.contains(a.Program__r.Opportunity__r.OwnerId + '-'+ getNextQuarter(a.Ad_Period__r.Quarter__c) + '-' +a.Program__r.Opportunity__r.Account.Id  + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + '')){
                        uniquePairs.add(a.Program__r.Opportunity__r.OwnerId + '-'+ getNextQuarter(a.Ad_Period__r.Quarter__c) + '-' +a.Program__r.Opportunity__r.Account.Id  + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + '');
                    }           
                }   
            } else {
                for (String x : a.Program__r.Product_Type__c.split(';')){
                    if (!uniquePairs.contains(a.Program__r.Opportunity__r.OwnerId + '-'+ a.Ad_Period__r.Quarter__c + '-' +a.Program__r.Opportunity__r.Account.Id + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + x)){
                    uniquePairs.add(a.Program__r.Opportunity__r.OwnerId + '-'+ a.Ad_Period__r.Quarter__c + '-' +a.Program__r.Opportunity__r.Account.Id  + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + x);
                    }
                    if (a.Ad_Period__r.Is_Split__c == 'true'){
                        if (!uniquePairs.contains(a.Program__r.Opportunity__r.OwnerId + '-'+ getNextQuarter(a.Ad_Period__r.Quarter__c) + '-' +a.Program__r.Opportunity__r.Account.Id  + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + x)){
                            uniquePairs.add(a.Program__r.Opportunity__r.OwnerId + '-'+ getNextQuarter(a.Ad_Period__r.Quarter__c) + '-' +a.Program__r.Opportunity__r.Account.Id  + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + x);
                        }           
                    }
                }
            }
        }
        //create Sales Manager 1 Forecasts that don't already exist
        for(string x : uniquePairs){
            createSM1Forecast(x);
        }
        insert insertSDPYSM1;
        //create Sales Manager 1 Forecasts that don't already exist
        sdpySM1 = [Select  r.Quarter__c, r.Quarter_Start_Date__c, r.Quarter_End_Date__c, r.Product_Type__c, r.OwnerId, r.Name, r.Manager__c, r.Manager_Forecast__c, r.Id, r.Forecast_Proposal__c, r.Forecast_Contract__c, r.Delivery_Type__c, r.Actual_Amount__c, r.Account__c, r.Account_Type__c From SDPY_Sales_Manager_1_Forecast__c r WHERE r.Account__c IN :accountList];
        clearInsertLists();
        for(string x : uniquePairs){
            createSM1Forecast(x);
        }
        insert insertSM1;
        //requery and get list for forecast amount updates
        sm1 = [Select r.Weighted_Forecast_Proposal__c, r.SDPY_Forecast__c, r.Quarter__c, r.Quarter_Start_Date__c, r.Quarter_End_Date__c, r.Product_Type__c, r.OwnerId, r.Name, r.Manager__c, r.Manager_Forecast__c, r.Id, r.Forecast_Proposal__c, r.Forecast_Contract__c, r.Delivery_Type__c, r.Actual_Amount__c, r.Account__c, r.Account_Type__c From Sales_Manager_1_Forecast__c r WHERE r.Account__c IN :accountList];
        clearInsertLists();
        updateForecasts(uniquePairs, SM1Type);
        update insertSM1;
        
        /*
        the leftovers being collected here are the Program Forecasts that we could not increment a forecasting object
        record for, meaning that they do not have a forecast role, or someone above them in the manager hierarchy
        is not set up properly
        */
        system.debug(Logginglevel.WARN, '***collecting left overs');
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
        /* temp used to see all coop PFs
        for (Program_Forecast__c a : pF){
            Program_Forecast_Exception__c pfe = new Program_Forecast_Exception__c();
            pfe.Program_Forecast__c = a.Id;
            pfe.Reason__c = 'coop'; 
            pfeList.add(pfe);
        }*/
        uniquePairs = new Set<String>();
        if (coopUser != null){
            for (Program_Forecast__c a : pf){
                if (a.Program__r.Product_Type__c == null){
                    if (!uniquePairs.contains(coopUser.Id + '-'+ a.Ad_Period__r.Quarter__c + '-' +a.Program__r.Opportunity__r.Account.Id + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + '')){
                    uniquePairs.add(coopUser.Id + '-'+ a.Ad_Period__r.Quarter__c + '-' +a.Program__r.Opportunity__r.Account.Id  + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + '');
                    }
                    if (a.Ad_Period__r.Is_Split__c == 'true'){
                        if (!uniquePairs.contains(coopUser.Id + '-'+ getNextQuarter(a.Ad_Period__r.Quarter__c) + '-' +a.Program__r.Opportunity__r.Account.Id  + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + '')){
                            uniquePairs.add(coopUser.Id + '-'+ getNextQuarter(a.Ad_Period__r.Quarter__c) + '-' +a.Program__r.Opportunity__r.Account.Id  + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + '');
                        }           
                    }   
                } else {
                    for (String x : a.Program__r.Product_Type__c.split(';')){
                        if (!uniquePairs.contains(coopUser.Id + '-'+ a.Ad_Period__r.Quarter__c + '-' +a.Program__r.Opportunity__r.Account.Id + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + x)){
                        uniquePairs.add(coopUser.Id + '-'+ a.Ad_Period__r.Quarter__c + '-' +a.Program__r.Opportunity__r.Account.Id  + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + x);
                        }
                        if (a.Ad_Period__r.Is_Split__c == 'true'){
                            if (!uniquePairs.contains(coopUser.Id + '-'+ getNextQuarter(a.Ad_Period__r.Quarter__c) + '-' +a.Program__r.Opportunity__r.Account.Id  + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + x)){
                                uniquePairs.add(coopUser.Id + '-'+ getNextQuarter(a.Ad_Period__r.Quarter__c) + '-' +a.Program__r.Opportunity__r.Account.Id  + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + x);
                            }           
                        }
                    }
                }
            }
        }
        //create Sales Manager 1 Forecasts that don't already exist
        for(string x : uniquePairs){
            createSM1Forecast(x);
        }
        insert insertSDPYSM1;
        //create Sales Manager 1 Forecasts that don't already exist
        sdpySM1 = [Select  r.Quarter__c, r.Quarter_Start_Date__c, r.Quarter_End_Date__c, r.Product_Type__c, r.OwnerId, r.Name, r.Manager__c, r.Manager_Forecast__c, r.Id, r.Forecast_Proposal__c, r.Forecast_Contract__c, r.Delivery_Type__c, r.Actual_Amount__c, r.Account__c, r.Account_Type__c From SDPY_Sales_Manager_1_Forecast__c r WHERE r.Account__c IN :accountList];
        clearInsertLists();
        for(string x : uniquePairs){
            createSM1Forecast(x);
        }
        insert insertSM1;
        //requery and get list for forecast amount updates
        sm1 = [Select r.Weighted_Forecast_Proposal__c, r.SDPY_Forecast__c, r.Quarter__c, r.Quarter_Start_Date__c, r.Quarter_End_Date__c, r.Product_Type__c, r.OwnerId, r.Name, r.Manager__c, r.Manager_Forecast__c, r.Id, r.Forecast_Proposal__c, r.Forecast_Contract__c, r.Delivery_Type__c, r.Actual_Amount__c, r.Account__c, r.Account_Type__c From Sales_Manager_1_Forecast__c r WHERE r.Account__c IN :accountList];
        clearInsertLists();
        if (coopUser != null){
        updateCoopForecasts(uniquePairs);
        }
        update insertSM1;
        
        /* end collecting leftover */
        
        //record the leftovers who still did not get to increment a record somewhere
        for (Program_Forecast__c a : pfScope){
            if (!pfFound.contains(a.Id)){
                Program_Forecast_Exception__c pfe = new Program_Forecast_Exception__c();
                pfe.Program_Forecast__C = a.Id;
                pfe.Reason__c = 'not found';
                pfeList.add(pfe);
            }
        }
        
        insert pfeList;
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
        String year = String.valueOf(Date.today().year());
        BatchFYTotal acctBatch2Sched = new BatchFYTotal(year);
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
                SDPY_Rep_2_Forecast__c sdpy = createSDPYRep2(userID + '-' + getPY(quarterID) + '-' + accountID + '-' + recordType + '-' + deliveryType + '-' + productType);
                if (sdpy != null){
                    if (sdpy.Id != null){
                        Rep_1_Forecast__c rep1a = createRep1Forecast(managerID + '-' + quarterID + '-' + accountID + '-' + recordType + '-' + deliveryType + '-' + productType);
                        if (rep1a != null){
                            Rep_2_Forecast__c a = new Rep_2_Forecast__c();
                            a.OwnerId = userID;
                            a.Quarter__c = quarterID;
                            a.Account__c = accountID;
                            a.Account_Type__c = recordType;
                            a.SDPY_Forecast__c = sdpy.Id;
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
                SDPY_Rep_1_Forecast__c sdpy = createSDPYRep1(userID + '-' + getPY(quarterID) + '-' + accountID + '-' + recordType + '-' + deliveryType + '-' + productType);
                if (sdpy != null){
                    if (sdpy.Id != null){
                        Sales_Manager_2_Forecast__c sm2a = createSM2Forecast(managerID + '-' + quarterID + '-' + accountID + '-' + recordType + '-' + deliveryType + '-' + productType);
                        if (sm2a != null){
                            Rep_1_Forecast__c a = new Rep_1_Forecast__c();
                            a.OwnerId = userID;
                            a.Quarter__c = quarterID;
                            a.Account__c = accountID;
                            a.Account_Type__c = recordType;
                            a.SDPY_Forecast__c = sdpy.Id;
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
                SDPY_Sales_Manager_2_Forecast__c sdpy = createSDPYSM2(userID + '-' + getPY(quarterID) + '-' + accountID + '-' + recordType + '-' + deliveryType + '-' + productType);
                if (sdpy != null){
                    if (sdpy.Id != null){
                        Sales_Manager_1_Forecast__c sm1a = createSM1Forecast(managerID + '-' + quarterID + '-' + accountID + '-' + recordType + '-' + deliveryType + '-' + productType);
                        if (sm1a != null){
                            Sales_Manager_2_Forecast__c a = new Sales_Manager_2_Forecast__c();
                            a.OwnerId = userID;
                            a.Quarter__c = quarterID;
                            a.Account__c = accountID;
                            a.Account_Type__c = recordType;
                            a.SDPY_Forecast__c = sdpy.Id;
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
            SDPY_Sales_Manager_1_Forecast__c sdpy = createSDPYSM1(userID + '-' + getPY(quarterID) + '-' + accountID + '-' + recordType + '-' + deliveryType + '-' + productType);
            if (sdpy != null){
                if (sdpy.Id != null){
                    String fullName = SM1Map.get(userID).FirstName + ' ' + SM1Map.get(userID).LastName;
                    String managerID = SM1Map.get(userID).ManagerId;
                    Sales_Manager_1_Forecast__c a = new Sales_Manager_1_Forecast__c();
                    a.OwnerId = userID;
                    a.Quarter__c = quarterID;
                    a.Account__c = accountID;
                    a.Account_Type__c = recordType;
                    a.Product_Type__c = productType;
                    a.Delivery_Type__c = deliveryType;
                    a.SDPY_Forecast__c = sdpy.Id;
                    a.Manager__c = managerID;
                    a.Quarter_Start_Date__c = Date.valueOf(getStartQuarter(quarterID));
                    a.Quarter_End_Date__c = Date.valueOf(getEndQuarter(quarterID));
                    a.Name = fullName + ' - ' + quarterID; 
                    insertSM1.add(a);
                    SM1.add(a);
                    result = a;
                }
            }
        }
        return result;
    }
    
    
    
    /*
    Method that takes a string and creates the appropriate SDPY Rep 1 Forecast or returns the existing one
    param uniquePairs - a set of unique strings in the form 005F0000001wYSzIAM-Q12012-005F0000001wYSzIAM-Retail, each string represents a forecast to be updated
    return - the SDPY Rep 1 Forecast for the given User, Account, Quarter and Account Type
    */
    private SDPY_Rep_1_Forecast__c createSDPYRep1(String x){
        SDPY_Rep_1_Forecast__c result;
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
        for (SDPY_Rep_1_Forecast__c a : sdpyRep1){
            if(a.Owner__c == userID && a.Quarter__c == quarterID && a.Account__c == accountID && a.Account_Type__c == recordType && a.Delivery_Type__c == deliveryType && a.Product_Type__c == (productType == '' ? null : productType)){
                found = true;
                result = a;
                break;
            }
        }
        if (!found){
           if (rep1Map.containsKey(userID)){
                String fullName = rep1Map.get(userID).FirstName + ' ' + rep1Map.get(userID).LastName;
                String managerID = rep1Map.get(userID).ManagerId;
                SDPY_Sales_Manager_2_Forecast__c rep1a = createSDPYSM2(managerID + '-' + quarterID + '-' + accountID + '-' + recordType + '-' + deliveryType + '-' + productType);
                if (rep1a != null){
                    SDPY_Rep_1_Forecast__c a = new SDPY_Rep_1_Forecast__c();
                    a.Owner__c = userID;
                    a.Quarter__c = quarterID;
                    a.Account__c = accountID;
                    a.Account_Type__c = recordType;
                    a.Product_Type__c = productType;
                    a.Delivery_Type__c = deliveryType;
                    a.Quarter_Start_Date__c = Date.valueOf(getStartQuarter(quarterID));
                    a.Quarter_End_Date__c = Date.valueOf(getEndQuarter(quarterID));
                    a.Manager_Forecast__c = rep1a.Id;
                    a.Manager__c = rep1a.Owner__c;
                    a.Name = fullName + ' - ' + quarterID;
                    insertSDPYRep1.add(a);
                    sdpyRep1.add(a);
                    result = a;
                }   
            }
        }
        return result;
    }
    
    
    /*
    Method that takes a string and creates the appropriate SDPY Rep 2 Forecast or returns the existing one
    param uniquePairs - a set of unique strings in the form 005F0000001wYSzIAM-Q12012-005F0000001wYSzIAM-Retail, each string represents a forecast to be updated
    return - the SDPY Rep 2 Forecast for the given User, Account, Quarter and Account Type
    */
    private SDPY_Rep_2_Forecast__c createSDPYRep2(String x){
        SDPY_Rep_2_Forecast__c result;
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
        for (SDPY_Rep_2_Forecast__c a : sdpyRep2){
            if(a.Owner__c == userID && a.Quarter__c == quarterID && a.Account__c == accountID && a.Account_Type__c == recordType && a.Delivery_Type__c == deliveryType && a.Product_Type__c == (productType == '' ? null : productType)){
                found = true;
                result = a;
                break;
            }
        }
        if (!found){
            if (rep2Map.containsKey(userID)){
                String fullName = rep2Map.get(userID).FirstName + ' ' + rep2Map.get(userID).LastName;
                String managerID = rep2Map.get(userID).ManagerId; 
                SDPY_Rep_1_Forecast__c rep1a = createSDPYRep1(managerID + '-' + quarterID + '-' + accountID + '-' + recordType + '-' + deliveryType + '-' + productType);
                if (rep1a != null){
                    SDPY_Rep_2_Forecast__c a = new SDPY_Rep_2_Forecast__c();
                    a.Owner__c = userID;
                    a.Quarter__c = quarterID;
                    a.Account__c = accountID;
                    a.Account_Type__c = recordType;
                    a.Product_Type__c = productType;
                    a.Delivery_Type__c = deliveryType;
                    a.Quarter_Start_Date__c = Date.valueOf(getStartQuarter(quarterID));
                    a.Quarter_End_Date__c = Date.valueOf(getEndQuarter(quarterID));
                    a.Manager_Forecast__c = rep1a.Id;
                    a.Manager__c = rep1a.Owner__c;
                    a.Name = fullName + ' - ' + quarterID;
                    insertSDPYRep2.add(a);
                    sdpyRep2.add(a);
                    result = a;
                }   
            }
        }
        return result;
    }
    
    
    /*
    Method that takes a string and creates the appropriate SDPY Manager 2 Forecast or returns the existing one
    param uniquePairs - a set of unique strings in the form 005F0000001wYSzIAM-Q12012-005F0000001wYSzIAM-Retail, each string represents a forecast to be updated
    return - the SDPY Manager 2 Forecast for the given User, Account, Quarter and Account Type
    */
    private SDPY_Sales_Manager_2_Forecast__c createSDPYSM2(String x){
        SDPY_Sales_Manager_2_Forecast__c result;
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
        for (SDPY_Sales_Manager_2_Forecast__c a : sdpySM2){
            if(a.Owner__c == userID && a.Quarter__c == quarterID && a.Account__c == accountID && a.Account_Type__c == recordType && a.Delivery_Type__c == deliveryType && a.Product_Type__c == (productType == '' ? null : productType)){
                found = true;
                result = a;
                break;
            }
        }
        if (!found){
           if (SM2Map.containsKey(userID)){
                String fullName = SM2Map.get(userID).FirstName + ' ' + SM2Map.get(userID).LastName;
                String managerID = SM2Map.get(userID).ManagerId;
                SDPY_Sales_Manager_1_Forecast__c rep1a = createSDPYSM1(managerID + '-' + quarterID + '-' + accountID + '-' + recordType + '-' + deliveryType + '-' + productType);
                if (rep1a != null){
                    SDPY_Sales_Manager_2_Forecast__c a = new SDPY_Sales_Manager_2_Forecast__c();
                    a.Owner__c = userID;
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
                    //system.debug('***manager forecast: ' + rep1a.Id);
                    insertSDPYSM2.add(a);
                    sdpySM2.add(a);
                    result = a;
                }   
            }
        }
        return result;
    }
    
    
    
   /*
    Method that takes a string and creates the appropriate SDPY Manager 1 Forecast or returns the existing one
    param uniquePairs - a set of unique strings in the form 005F0000001wYSzIAM-Q12012-005F0000001wYSzIAM-Retail, each string represents a forecast to be updated
    return - the SDPY Manager 1 Forecast for the given User, Account, Quarter and Account Type
    */
    private SDPY_Sales_Manager_1_Forecast__c createSDPYSM1(String x){
        SDPY_Sales_Manager_1_Forecast__c result;
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
        for (SDPY_Sales_Manager_1_Forecast__c a : sdpySM1){
            if(a.OwnerId == userID && a.Quarter__c == quarterID && a.Account__c == accountID && a.Account_Type__c == recordType && a.Delivery_Type__c == deliveryType && a.Product_Type__c == (productType == '' ? null : productType)){
                found = true;
                result = a;
                break;
            }
        }
        if (!found){
             if (SM1Map.containsKey(userID)){
                String fullName = SM1Map.get(userID).FirstName + ' ' + SM1Map.get(userID).LastName;
                String managerID = SM1Map.get(userID).ManagerId;
                SDPY_Sales_Manager_1_Forecast__c a = new SDPY_Sales_Manager_1_Forecast__c();
                a.OwnerId = userID;
                a.Quarter__c = quarterID;
                a.Account__c = accountID;
                a.Account_Type__c = recordType;
                a.Product_Type__c = productType;
                a.Manager__c = managerID;
                a.Delivery_Type__c = deliveryType;
                a.Quarter_Start_Date__c = Date.valueOf(getStartQuarter(quarterID));
                a.Quarter_End_Date__c = Date.valueOf(getEndQuarter(quarterID));
                a.Name = fullName + ' - ' + quarterID;
                insertSDPYSM1.add(a);
                sdpySM1.add(a);
                result = a;   
            }
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
    Helper method that requeries each forecast object to get latest insert/updates
    */
    private void refreshForecasts(){
        
        rep2 = [Select r.Weighted_Forecast_Proposal__c, r.SDPY_Forecast__c, r.Quarter__c, r.Quarter_Start_Date__c, r.Quarter_End_Date__c, r.Product_Type__c, r.OwnerId, r.Name, r.Manager__c, r.Manager_Forecast__c, r.Id, r.Forecast_Proposal__c, r.Forecast_Contract__c, r.Delivery_Type__c, r.Actual_Amount__c, r.Account__c, r.Account_Type__c From Rep_2_Forecast__c r WHERE r.Account__c IN :accountList];
        rep1 = [Select r.Weighted_Forecast_Proposal__c, r.SDPY_Forecast__c, r.Quarter__c, r.Quarter_Start_Date__c, r.Quarter_End_Date__c, r.Product_Type__c, r.OwnerId, r.Name, r.Manager__c, r.Manager_Forecast__c, r.Id, r.Forecast_Proposal__c, r.Forecast_Contract__c, r.Delivery_Type__c, r.Actual_Amount__c, r.Account__c, r.Account_Type__c From Rep_1_Forecast__c r WHERE r.Account__c IN :accountList];
        sm2 = [Select r.Weighted_Forecast_Proposal__c, r.SDPY_Forecast__c, r.Quarter__c, r.Quarter_Start_Date__c, r.Quarter_End_Date__c, r.Product_Type__c, r.OwnerId, r.Name, r.Manager__c, r.Manager_Forecast__c, r.Id, r.Forecast_Proposal__c, r.Forecast_Contract__c, r.Delivery_Type__c, r.Actual_Amount__c, r.Account__c, r.Account_Type__c From Sales_Manager_2_Forecast__c r WHERE r.Account__c IN :accountList];
        sm1 = [Select r.Weighted_Forecast_Proposal__c, r.SDPY_Forecast__c, r.Quarter__c, r.Quarter_Start_Date__c, r.Quarter_End_Date__c, r.Product_Type__c, r.OwnerId, r.Name, r.Manager__c, r.Manager_Forecast__c, r.Id, r.Forecast_Proposal__c, r.Forecast_Contract__c, r.Delivery_Type__c, r.Actual_Amount__c, r.Account__c, r.Account_Type__c From Sales_Manager_1_Forecast__c r WHERE r.Account__c IN :accountList];
        sdpyRep2 = [Select  r.Quarter__c, r.Quarter_Start_Date__c, r.Quarter_End_Date__c, r.Product_Type__c, r.Owner__c, r.Name, r.Manager__c, r.Manager_Forecast__c, r.Id, r.Forecast_Proposal__c, r.Forecast_Contract__c, r.Delivery_Type__c, r.Actual_Amount__c, r.Account__c, r.Account_Type__c From SDPY_Rep_2_Forecast__c r WHERE r.Account__c IN :accountList];
        sdpyRep1 = [Select  r.Quarter__c, r.Quarter_Start_Date__c, r.Quarter_End_Date__c, r.Product_Type__c, r.Owner__c, r.Name, r.Manager__c, r.Manager_Forecast__c, r.Id, r.Forecast_Proposal__c, r.Forecast_Contract__c, r.Delivery_Type__c, r.Actual_Amount__c, r.Account__c, r.Account_Type__c From SDPY_Rep_1_Forecast__c r WHERE r.Account__c IN :accountList];
        sdpySM2 = [Select  r.Quarter__c, r.Quarter_Start_Date__c, r.Quarter_End_Date__c, r.Product_Type__c, r.Owner__c, r.Name, r.Manager__c, r.Manager_Forecast__c, r.Id, r.Forecast_Proposal__c, r.Forecast_Contract__c, r.Delivery_Type__c, r.Actual_Amount__c, r.Account__c, r.Account_Type__c From SDPY_Sales_Manager_2_Forecast__c r WHERE r.Account__c IN :accountList];
        sdpySM1 = [Select  r.Quarter__c, r.Quarter_Start_Date__c, r.Quarter_End_Date__c, r.Product_Type__c, r.OwnerId, r.Name, r.Manager__c, r.Manager_Forecast__c, r.Id, r.Forecast_Proposal__c, r.Forecast_Contract__c, r.Delivery_Type__c, r.Actual_Amount__c, r.Account__c, r.Account_Type__c From SDPY_Sales_Manager_1_Forecast__c r WHERE r.Account__c IN :accountList];
        
    }
    
    
    /*
    Helper method that clears the insert lists of each type of forecast
    */
    private void clearInsertLists(){
        insertRep2 = new List<Rep_2_Forecast__c>();
        insertRep1 = new List<Rep_1_Forecast__c>();
        insertSM2 = new List<Sales_Manager_2_Forecast__c>();
        insertSM1 = new List<Sales_Manager_1_Forecast__c>();
        insertSDPYRep2 = new List<SDPY_Rep_2_Forecast__c>();
        insertSDPYRep1 = new List<SDPY_Rep_1_Forecast__c>();
        insertSDPYSM2 = new List<SDPY_Sales_Manager_2_Forecast__c>();
        insertSDPYSM1 = new List<SDPY_Sales_Manager_1_Forecast__c>();
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
            String accountID = x.substring(0, x.indexOf('-'));
            x = x.substring(x.indexOf('-') + 1);
            String recordType = x.substring(0, x.indexOf('-'));
            x = x.substring(x.indexOf('-') + 1);
            String deliveryType = x.substring(0, x.indexOf('-'));
            x = x.substring(x.indexOf('-') + 1);
            String productType = x;
            String PY = getPY(quarterID);
            double actual = 0.0;
            double contract = 0.0;
            double proposal = 0.0;
            double weighted = 0.0;
            //system.debug('***loop to start');
            for (Program_Forecast__c pf1 : pF){
                //system.debug('***Percentage : ' + productType + ' - ' + ptsMAP.get(pf1.Program__c).get(productType));
                //system.debug('*** ' + pf1.Program__r.Product_Type__c + '-' + productType);
                //system.debug('*** ' + pf1.Ad_Period__r.Quarter__c);
                if (pf1.Program__r.Opportunity__r.OwnerId == userID && pf1.Ad_Period__r.Quarter__c == quarterID && pf1.Program__r.Opportunity__r.Account.Id == accountID && pf1.Program__r.Opportunity__r.Account.RecordType.Name == recordType && pf1.Program__r.Delivery_Type__c == deliveryType && (pf1.Program__r.Product_Type__c == null ? '' : pf1.Program__r.Product_Type__c).contains(productType)){
                    //system.debug('***break1');
                    pfFound.add(pf1.Id);
                    double prodSplitPercent = (ptsMAP.get(pf1.Program__c) == null ? 1.0 : (ptsMAP.get(pf1.Program__c).get(productType) == null ? 1.0 : ptsMAP.get(pf1.Program__c).get(productType)) / 100);
                    if (pf1.Ad_Period__r.Is_Split__c == 'true'){
                            //if split forecasts not entered
                            if ((pf1.Previous_Quarter_Amount__c == 0 && pf1.Next_Quarter_Amount__c == 0) || pf1.Previous_Quarter_Amount__c == null){
                                if (pf1.Active__c == false){
                                    if (pf1.Previous_Quarter_Actual__c == null && pf1.Next_Quarter_Actual__c != null){
                                        actual += (pf1.Actual_Amount__c - pf1.Next_Quarter_Actual__c) * prodSplitPercent;
                                    } else {
                                        actual += (pf1.Previous_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Previous_Quarter_Ratio__c/100 : pf1.Previous_Quarter_Actual__c) * prodSplitPercent;
                                    }
                                }
                                else if( pf1.Active__c == true){
                                    if (pf1.Program__r.RecordType.Name == 'Contract'){
                                        contract += (pf1.Forecast_Amount__c == null? 0 : pf1.Forecast_Amount__c) * pf1.Previous_Quarter_Ratio__c/100 * prodSplitPercent;
                                    } else {
                                        proposal += (pf1.Forecast_Amount__c == null? 0 : pf1.Forecast_Amount__c) * pf1.Previous_Quarter_Ratio__c/100 * prodSplitPercent;
                                        weighted += pf1.Weighted_Forecast_Amount__c * pf1.Previous_Quarter_Ratio__c/100 * prodSplitPercent;
                                    }
                                }
                            }
                            //if split forecasts entered
                            else{
                                if (pf1.Active__c == false){
                                    if (pf1.Previous_Quarter_Actual__c == null && pf1.Next_Quarter_Actual__c != null){
                                        actual += (pf1.Actual_Amount__c - pf1.Next_Quarter_Actual__c) * prodSplitPercent;
                                    } else {
                                        actual += (pf1.Previous_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Previous_Quarter_Ratio__c/100 : pf1.Previous_Quarter_Actual__c) * prodSplitPercent;
                                    }
                                } else if (pf1.Active__c == true){
                                    if (pf1.Program__r.RecordType.Name == 'Contract'){
                                        contract += pf1.Previous_Quarter_Amount__c * prodSplitPercent;
                                    } else {
                                        proposal += pf1.Previous_Quarter_Amount__c * prodSplitPercent;
                                        weighted += pf1.Weighted_Previous_Quarter_Forecast__c * prodSplitPercent;
                                    }
                                }
                            }    
                    }
                    else {
                        if (pf1.Active__c == false){
                            actual += (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * prodSplitPercent;
                        } else if (pf1.Active__c == true){
                            if (pf1.Program__r.RecordType.Name == 'Contract'){
                                contract += pf1.Forecast_Amount__c * prodSplitPercent;
                            } else {
                                proposal += pf1.Forecast_Amount__c * prodSplitPercent;
                                weighted += pf1.Weighted_Forecast_Amount__c * prodSplitPercent;
                            }
                        }
                    }
                }
                //if from a split forecast and we take next quarter amount
                else if (pf1.Ad_Period__r.Is_Split__c == 'true' && pf1.Program__r.Opportunity__r.OwnerId == userID && getNextQuarter(pf1.Ad_Period__r.Quarter__c) == quarterID && pf1.Program__r.Opportunity__r.Account.Id == accountID && pf1.Program__r.Opportunity__r.Account.RecordType.Name == recordType && pf1.Program__r.Delivery_Type__c == deliveryType && (pf1.Program__r.Product_Type__c == null ? '' : pf1.Program__r.Product_Type__c) == productType){
                  pfFound.add(pf1.Id);
                    double prodSplitPercent = (ptsMAP.get(pf1.Program__c) == null ? 1.0 : (ptsMAP.get(pf1.Program__c).get(productType) == null ? 1.0 : ptsMAP.get(pf1.Program__c).get(productType)) / 100);
                    if ((pf1.Previous_Quarter_Amount__c == 0 && pf1.Next_Quarter_Amount__c == 0) || pf1.Next_Quarter_Amount__c == null){
                        if (pf1.Active__c == false){
                            if (pf1.Next_Quarter_Actual__c == null && pf1.Previous_Quarter_Actual__c != null){
                                actual += (pf1.Actual_Amount__c - pf1.Previous_Quarter_Actual__c) * prodSplitPercent;
                            } else {
                                actual += (pf1.Next_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Next_Quarter_Ratio__c/100 : pf1.Next_Quarter_Actual__c) * prodSplitPercent;
                            }
                        } else if (pf1.Active__c == true){
                             if (pf1.Program__r.RecordType.Name == 'Contract'){
                                  contract += (pf1.Forecast_Amount__c == null? 0 : pf1.Forecast_Amount__c) * pf1.Next_Quarter_Ratio__c/100 * prodSplitPercent;
                              } else {
                                  proposal += (pf1.Forecast_Amount__c == null? 0 : pf1.Forecast_Amount__c) * pf1.Next_Quarter_Ratio__c/100 * prodSplitPercent;
                                  weighted += pf1.Weighted_Forecast_Amount__c * pf1.Next_Quarter_Ratio__c/100 * prodSplitPercent;
                              }
                        }
                    }
                    //if split forecasts entered
                    else{
                        if (pf1.Active__c == false){
                            if (pf1.Next_Quarter_Actual__c == null && pf1.Previous_Quarter_Actual__c != null){
                                actual += (pf1.Actual_Amount__c - pf1.Previous_Quarter_Actual__c) * prodSplitPercent;
                            } else {
                                actual += (pf1.Next_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Next_Quarter_Ratio__c/100 : pf1.Next_Quarter_Actual__c) * prodSplitPercent;
                            }
                        } else if (pf1.Active__c == true){
                            if (pf1.Program__r.RecordType.Name == 'Contract'){
                                contract += pf1.Next_Quarter_Amount__c * prodSplitPercent;
                            } else {
                                proposal += pf1.Next_Quarter_Amount__c * prodSplitPercent;
                                weighted += pf1.Weighted_Next_Quarter_Forecast__c * prodSplitPercent;
                            }
                        }
                    }
                }
            }
            //system.debug('***break3');
            system.debug('***actual: ' + actual);
            system.debug('***contract: ' + contract);
            system.debug('***proposal: ' + proposal);
            system.debug('***weighted proposal: ' + weighted);
            system.debug('***quarterID: ' + quarterID);
            if (forecastType == rep1Type){
                Rep_1_Forecast__c thisForecast = createRep1Forecast(fullString);
                //system.debug('***thisForecast: ' + thisForecast.Id);
                if (thisForecast != null){
                    if (thisForecast.Actual_Amount__c == null) thisForecast.Actual_Amount__c = 0;
                    if (thisForecast.Forecast_Contract__c == null) thisForecast.Forecast_Contract__c = 0;
                    if (thisForecast.Forecast_Proposal__c == null) thisForecast.Forecast_Proposal__c = 0;
                    if (thisForecast.Weighted_Forecast_Proposal__c == null) thisForecast.Weighted_Forecast_Proposal__c = 0;
                    thisForecast.Actual_Amount__c += actual;
                    thisForecast.Forecast_Contract__c += contract;
                    thisForecast.Forecast_Proposal__c += proposal;
                    thisForecast.Weighted_Forecast_Proposal__c += weighted;
                    insertRep1.add(thisForecast);
                }
            }else if (forecastType == rep2Type){
                Rep_2_Forecast__c thisForecast = createRep2Forecast(fullString);
                if (thisForecast!= null){
                    if (thisForecast.Actual_Amount__c == null) thisForecast.Actual_Amount__c = 0;
                    if (thisForecast.Forecast_Contract__c == null) thisForecast.Forecast_Contract__c = 0;
                    if (thisForecast.Forecast_Proposal__c == null) thisForecast.Forecast_Proposal__c = 0;
                    if (thisForecast.Weighted_Forecast_Proposal__c == null) thisForecast.Weighted_Forecast_Proposal__c = 0;
                    thisForecast.Actual_Amount__c += actual;
                    thisForecast.Forecast_Contract__c += contract;
                    thisForecast.Forecast_Proposal__c += proposal;
                    thisForecast.Weighted_Forecast_Proposal__c += weighted;
                    insertRep2.add(thisForecast);
                }
            }else if (forecastType == SM1Type){
                Sales_Manager_1_Forecast__c thisForecast = createSM1Forecast(fullString);
                if (thisForecast!= null){
                    if (thisForecast.Actual_Amount__c == null) thisForecast.Actual_Amount__c = 0;
                    if (thisForecast.Forecast_Contract__c == null) thisForecast.Forecast_Contract__c = 0;
                    if (thisForecast.Forecast_Proposal__c == null) thisForecast.Forecast_Proposal__c = 0;
                    if (thisForecast.Weighted_Forecast_Proposal__c == null) thisForecast.Weighted_Forecast_Proposal__c = 0;
                    thisForecast.Actual_Amount__c += actual;
                    thisForecast.Forecast_Contract__c += contract;
                    thisForecast.Forecast_Proposal__c += proposal;
                    thisForecast.Weighted_Forecast_Proposal__c += weighted;
                    insertSM1.add(thisForecast);
                }
            }else if (forecastType == SM2Type){
                Sales_Manager_2_Forecast__c thisForecast = createSM2Forecast(fullString);
                if (thisForecast!= null){
                    if (thisForecast.Actual_Amount__c == null) thisForecast.Actual_Amount__c = 0;
                    if (thisForecast.Forecast_Contract__c == null) thisForecast.Forecast_Contract__c = 0;
                    if (thisForecast.Forecast_Proposal__c == null) thisForecast.Forecast_Proposal__c = 0;
                    if (thisForecast.Weighted_Forecast_Proposal__c == null) thisForecast.Weighted_Forecast_Proposal__c = 0;
                    thisForecast.Actual_Amount__c += actual;
                    thisForecast.Forecast_Contract__c += contract;
                    thisForecast.Forecast_Proposal__c += proposal;
                    thisForecast.Weighted_Forecast_Proposal__c += weighted;
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
            String accountID = x.substring(0, x.indexOf('-'));
            x = x.substring(x.indexOf('-') + 1);
            String recordType = x.substring(0, x.indexOf('-'));
            x = x.substring(x.indexOf('-') + 1);
            String deliveryType = x.substring(0, x.indexOf('-'));
            x = x.substring(x.indexOf('-') + 1);
            String productType = x;
            String PY = getPY(quarterID);
            double actual = 0.0;
            double contract = 0.0;
            double proposal = 0.0;
            double weighted = 0.0;
            //system.debug('***loop to start');
            for (Program_Forecast__c pf1 : pF){
                //system.debug('***Percentage : ' + productType + ' - ' + ptsMAP.get(pf1.Program__c).get(productType));
                //system.debug('*** ' + pf1.Program__r.Product_Type__c + '-' + productType);
                //system.debug('*** ' + pf1.Ad_Period__r.Quarter__c);
                if (coopUser.Id == userID && pf1.Ad_Period__r.Quarter__c == quarterID && pf1.Program__r.Opportunity__r.Account.Id == accountID && pf1.Program__r.Opportunity__r.Account.RecordType.Name == recordType && pf1.Program__r.Delivery_Type__c == deliveryType && (pf1.Program__r.Product_Type__c == null ? '' : pf1.Program__r.Product_Type__c).contains(productType)){
                    //system.debug('***break1');
                    pfFound.add(pf1.Id);
                    double prodSplitPercent = (ptsMAP.get(pf1.Program__c) == null ? 1.0 : (ptsMAP.get(pf1.Program__c).get(productType) == null ? 1.0 : ptsMAP.get(pf1.Program__c).get(productType)) / 100);
                    if (pf1.Ad_Period__r.Is_Split__c == 'true'){
                            //if split forecasts not entered
                            if ((pf1.Previous_Quarter_Amount__c == 0 && pf1.Next_Quarter_Amount__c == 0) || pf1.Previous_Quarter_Amount__c == null){
                                if (pf1.Active__c == false){
                                    if (pf1.Previous_Quarter_Actual__c == null && pf1.Next_Quarter_Actual__c != null){
                                        actual += (pf1.Actual_Amount__c - pf1.Next_Quarter_Actual__c) * prodSplitPercent;
                                    } else {
                                        actual += (pf1.Previous_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Previous_Quarter_Ratio__c/100 : pf1.Previous_Quarter_Actual__c) * prodSplitPercent;
                                    }
                                }
                                else if( pf1.Active__c == true){
                                    if (pf1.Program__r.RecordType.Name == 'Contract'){
                                        contract += (pf1.Forecast_Amount__c == null? 0 : pf1.Forecast_Amount__c) * pf1.Previous_Quarter_Ratio__c/100 * prodSplitPercent;
                                    } else {
                                        proposal += (pf1.Forecast_Amount__c == null? 0 : pf1.Forecast_Amount__c) * pf1.Previous_Quarter_Ratio__c/100 * prodSplitPercent;
                                        weighted += pf1.Weighted_Forecast_Amount__c * pf1.Previous_Quarter_Ratio__c/100 * prodSplitPercent;
                                    }
                                }
                            }
                            //if split forecasts entered
                            else{
                                if (pf1.Active__c == false){
                                    if (pf1.Previous_Quarter_Actual__c == null && pf1.Next_Quarter_Actual__c != null){
                                        actual += (pf1.Actual_Amount__c - pf1.Next_Quarter_Actual__c) * prodSplitPercent;
                                    } else {
                                        actual += (pf1.Previous_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Previous_Quarter_Ratio__c/100 : pf1.Previous_Quarter_Actual__c) * prodSplitPercent;
                                    }
                                } else if (pf1.Active__c == true){
                                    if (pf1.Program__r.RecordType.Name == 'Contract'){
                                        contract += pf1.Previous_Quarter_Amount__c * prodSplitPercent;
                                    } else {
                                        proposal += pf1.Previous_Quarter_Amount__c * prodSplitPercent;
                                        weighted += pf1.Weighted_Previous_Quarter_Forecast__c * prodSplitPercent;
                                    }
                                }
                            }    
                    }
                    else {
                        if (pf1.Active__c == false){
                            actual += (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * prodSplitPercent;
                        } else if (pf1.Active__c == true){
                            if (pf1.Program__r.RecordType.Name == 'Contract'){
                                contract += pf1.Forecast_Amount__c * prodSplitPercent;
                            } else {
                                proposal += pf1.Forecast_Amount__c * prodSplitPercent;
                                weighted += pf1.Weighted_Forecast_Amount__c * prodSplitPercent;
                            }
                        }
                    }
                }
                //if from a split forecast and we take next quarter amount
                else if (pf1.Ad_Period__r.Is_Split__c == 'true' && coopUser.Id == userID && getNextQuarter(pf1.Ad_Period__r.Quarter__c) == quarterID && pf1.Program__r.Opportunity__r.Account.Id == accountID && pf1.Program__r.Opportunity__r.Account.RecordType.Name == recordType && pf1.Program__r.Delivery_Type__c == deliveryType && (pf1.Program__r.Product_Type__c == null ? '' : pf1.Program__r.Product_Type__c) == productType){
                  pfFound.add(pf1.Id);
                    double prodSplitPercent = (ptsMAP.get(pf1.Program__c) == null ? 1.0 : (ptsMAP.get(pf1.Program__c).get(productType) == null ? 1.0 : ptsMAP.get(pf1.Program__c).get(productType)) / 100);
                    if ((pf1.Previous_Quarter_Amount__c == 0 && pf1.Next_Quarter_Amount__c == 0) || pf1.Next_Quarter_Amount__c == null){
                        if (pf1.Active__c == false){
                            if (pf1.Next_Quarter_Actual__c == null && pf1.Previous_Quarter_Actual__c != null){
                                actual += (pf1.Actual_Amount__c - pf1.Previous_Quarter_Actual__c) * prodSplitPercent;
                            } else {
                                actual += (pf1.Next_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Next_Quarter_Ratio__c/100 : pf1.Next_Quarter_Actual__c) * prodSplitPercent;
                            }
                        } else if (pf1.Active__c == true){
                            if (pf1.Program__r.RecordType.Name == 'Contract'){
                                contract += (pf1.Forecast_Amount__c == null? 0 : pf1.Forecast_Amount__c) * pf1.Next_Quarter_Ratio__c/100 * prodSplitPercent;
                            } else {
                                proposal += (pf1.Forecast_Amount__c == null? 0 : pf1.Forecast_Amount__c) * pf1.Next_Quarter_Ratio__c/100 * prodSplitPercent;
                                weighted += pf1.Weighted_Forecast_Amount__c * pf1.Next_Quarter_Ratio__c/100 * prodSplitPercent;
                            }
                        }
                    }
                    //if split forecasts entered
                    else{
                        if (pf1.Active__c == false){
                            if (pf1.Next_Quarter_Actual__c == null && pf1.Previous_Quarter_Actual__c != null){
                                actual += (pf1.Actual_Amount__c - pf1.Previous_Quarter_Actual__c) * prodSplitPercent;
                            } else {
                                actual += (pf1.Next_Quarter_Actual__c == null ? (pf1.Actual_Amount__c == null? 0 : pf1.Actual_Amount__c) * pf1.Next_Quarter_Ratio__c/100 : pf1.Next_Quarter_Actual__c) * prodSplitPercent;
                            }
                        } else if (pf1.Active__c == true){
                            if (pf1.Program__r.RecordType.Name == 'Contract'){
                                contract += pf1.Next_Quarter_Amount__c * prodSplitPercent;
                            } else {
                                proposal += pf1.Next_Quarter_Amount__c * prodSplitPercent;
                                weighted += pf1.Weighted_Next_Quarter_Forecast__c * prodSplitPercent;
                            }
                        }
                    }
                }
            }
            //system.debug('***break3');
            system.debug('***actual: ' + actual);
            system.debug('***contract: ' + contract);
            system.debug('***proposal: ' + proposal);
            system.debug('***weighted proposal: ' + weighted);
            system.debug('***quarterID: ' + quarterID);
            Sales_Manager_1_Forecast__c thisForecast = createSM1Forecast(fullString);
            if (thisForecast!= null){
                if (thisForecast.Actual_Amount__c == null) thisForecast.Actual_Amount__c = 0;
                if (thisForecast.Forecast_Contract__c == null) thisForecast.Forecast_Contract__c = 0;
                if (thisForecast.Forecast_Proposal__c == null) thisForecast.Forecast_Proposal__c = 0;
                if (thisForecast.Weighted_Forecast_Proposal__c == null) thisForecast.Weighted_Forecast_Proposal__c = 0;
                thisForecast.Actual_Amount__c += actual;
                thisForecast.Forecast_Contract__c += contract;
                thisForecast.Forecast_Proposal__c += proposal;
                thisForecast.Weighted_Forecast_Proposal__c += weighted;
                insertSM1.add(thisForecast);
            }
        }
    }
    
}