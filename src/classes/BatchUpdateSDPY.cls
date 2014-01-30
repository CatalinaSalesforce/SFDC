/*
Dec 8 , 2012 - changed from days 30 to 25 to avoid too many soql rows
*/
global class BatchUpdateSDPY implements Database.Batchable<sObject>, Schedulable{
    
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
    
    String query;
    String limit1;
    Set<ID> accountList;
    Catalina_Forecast_Settings__c settings;
    String rep2Type;
    String rep1Type;
    String SM2Type;
    String SM1Type;
    Map<Id, User> Rep2Map;
    Map<Id, User> Rep1Map;
    Map<Id, User> SM2Map;
    Map<Id, User> SM1Map;
    List<User> Rep2Managers;
    List<User> Rep1Managers;
    List<User> SM2Managers;
    List<User> SM1Managers;
    List<Rep_2_Forecast__c> rep2;
    List<Rep_1_Forecast__c> rep1;
    List<Sales_Manager_2_Forecast__c> sm2;
    List<Sales_Manager_1_Forecast__c> sm1;
    List<SDPY_Rep_2_Forecast__c> sdpyRep2;
    List<SDPY_Rep_1_Forecast__c> sdpyRep1;
    List<SDPY_Sales_Manager_2_Forecast__c> sdpySM2;
    List<SDPY_Sales_Manager_1_Forecast__c> sdpySM1;
    List<Rep_2_Forecast__c> insertRep2;
    List<Rep_1_Forecast__c> insertRep1;
    List<Sales_Manager_2_Forecast__c> insertSM2;
    List<Sales_Manager_1_Forecast__c> insertSM1;
    List<SDPY_Rep_2_Forecast__c> insertSDPYRep2;
    List<SDPY_Rep_1_Forecast__c> insertSDPYRep1;
    List<SDPY_Sales_Manager_2_Forecast__c> insertSDPYSM2;
    List<SDPY_Sales_Manager_1_Forecast__c> insertSDPYSM1;
    List<Archive_Program_Forecast__c> pF;
    Set<String> uniquePairs;
    
    public BatchUpdateSDPY(String x){
        limit1 = x;
    }
    
    public BatchUpdateSDPY(){
        limit1 = '';
    }
    
    /*
    The start method is responsible for determining what Archive Date will be used for SDPY calculations
    It will take the closest date before and after, compare the 2, and select the closest one (tie goes to before)
    */
    global Database.querylocator start(Database.BatchableContext BC){
        BatchGovernorLimitUtility.insertBatchRun('BatchUpdateSDPY');
        Integer minDays = 1000;
        Date archiveDate = Date.Today();
        
        Date lastyear = Date.Today().addYears(-1);
        //changed by Warren to 25
        Date lastyear1 = lastyear.addDays(25);
        Date lastyear2 = lastyear.addDays(-25);
         
        //edit by Warren to only look at US archives
        AggregateResult ar = [Select Max(Archive_Date__c) Expr1 From Archive_Program__c Where Archive_Date__c <= :lastyear and Archive_Date__c >= :lastyear2 AND RECORDTYPE.NAME = 'CONTRACT'];
        AggregateResult ar2 = [Select Min(Archive_Date__c) Expr2 From Archive_Program__c Where Archive_Date__c >= :lastyear and Archive_Date__c <= :lastyear1 AND RECORDTYPE.NAME = 'CONTRACT'];
         
            Date nearestBefore = (Date)ar.get('Expr1');
            Date nearestAfter = (Date)ar2.get('Expr2');
            
            if (nearestBefore != null && nearestAfter != null){
                Integer numDaysBefore = nearestBefore.daysBetween(lastyear);
                Integer numDaysAfter = lastyear.daysBetween(nearestAfter);
                // archiveDate stores the nearest date from one year ago 
                if(numDaysBefore > numDaysAfter) 
                {
                    archiveDate = nearestAfter;
                }
                else
                {
                    archiveDate = nearestBefore;
                }
            } else if (nearestBefore == null && nearestAfter != null){
                archiveDate = nearestAfter;
            } else if (nearestAfter == null && nearestBefore != null){
                archiveDate = nearestBefore;
            } else {
                archiveDate = Date.valueOf('2000-01-01');
            }
            
            /*
            System.debug('***after date: ' +  nearestBefore + numDaysBefore);
            System.debug('***before date: ' + nearestAfter + numDaysAfter);
            System.debug('***arc_date: ' + archiveDate);*/
            
            //if a suitable date could not be found, plug in a dummy date to prevent NPE
            if (archiveDate == null) archiveDate = Date.valueOf('2000-01-01');
        
        query = 'SELECT Program__r.Product_Type__c, Program__r.Opportunity__r.Account.Id, Ad_Period__r.Quarter__c, Ad_Period__r.Is_Split__c, Weighted_Forecast_Amount__c, ' +
            'Previous_Quarter_Amount__c, Oppty_Probability__c, Next_Quarter_Amount__c, Forecast_Amount__c, Program__r.Opportunity__r.OwnerId, ' + 
            'Program__r.Delivery_Type__c, Program__r.Opportunity__r.Account.RecordType.Name,  Weighted_Previous_Quarter_Forecast__c, Actual_Amount__c, ' + 
            'Weighted_Next_Quarter_Forecast__c, Previous_Quarter_Ratio__c,Previous_Quarter_Actual__c, Next_Quarter_Ratio__c, Next_Quarter_Actual__c, ' + 
            'F_Actual_Amount__c, F_Next_Quarter_Actual__c, F_Previous_Quarter_Actual__c ' + 
            'FROM Archive_Program_Forecast__c  ' + 
            'WHERE Archive_Date__c = ' + archiveDate.year() + '-' + (archiveDate.month() < 10 ? '0' + String.valueOf(archiveDate.month()) : String.valueOf(archiveDate.month())) + '-' + (archiveDate.day() < 10 ? '0' + String.valueOf(archiveDate.day()) : String.valueOf(archiveDate.day())) +
            'and(NOT(Program__r.Opportunity__r.IsWon = False and Program__r.Opportunity__r.IsClosed = True)) '  +
            //added by Warren to only include US archive Programs
            ' AND (PROGRAM__R.RECORDTYPE.NAME =\'CONTRACT\' OR PROGRAM__R.RECORDTYPE.NAME =\'PROPOSAL\') ' +      
            ///*temp remove this*/' AND Program__r.Opportunity__r.Account.Id IN (\'001Z0000006gTBXIA2\', \'001Z0000006gTHgIAM\') ' +
            ' ORDER BY Program__r.Opportunity__r.Account.Id, Program__r.Opportunity__c ' + limit1;
        system.debug('***query: ' + query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(SchedulableContext ctx) {
        BatchUpdateSDPY batch1 = new BatchUpdateSDPY();
        ID batchprocessid = Database.executeBatch(batch1);
    }
    
    //method that makes up the body of the batch process
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        Datetime currentTime = System.now();
        system.debug('***start: ' + getNextQuarter('Q42011') + ' - ' + getNY('Q42011'));
        system.debug('***start: ' + system.now());
        settings = Catalina_Forecast_Settings__c.getInstance(defaultSettingsName);
        rep2Type = settings.Rep_2_String__c;
        rep1Type = settings.Rep_1_String__c;
        SM2Type = settings.SM_2_String__c;
        SM1Type = settings.SM_1_String__c;
        String coopType = settings.Coop_String__c;
        Rep2Map = new Map<Id, User>();
        Rep1Map = new Map<Id, User>();
        SM2Map = new Map<Id, User>();
        SM1Map = new Map<Id, User>();
        Set<Id> missingPTSList = new Set<Id>();
        User coopUser;
        List<User> temp1 = [SELECT ID FROM USER WHERE FORECAST_ROLE__C =: coopType];
        if (temp1.size() > 0){
            coopUser = temp1.get(0);
        }
        //get Sales Rep 2s that need to be created or should already exist
        Rep2Managers = [SELECT ID, FirstName, LastName,  UserRole.Name, ManagerId FROM USER WHERE Forecast_Role__c =:rep2Type And ManagerID  != NULL];
        for (User a : Rep2Managers){
            rep2Map.put(a.Id, a);
        }
        //get Sales Rep 1s that need to be created or should already exist
        Rep1Managers = [SELECT ID, FirstName, LastName,  UserRole.Name, ManagerId FROM USER WHERE Forecast_Role__c =:rep1Type And ManagerID  != NULL];
        for (User a : Rep1Managers){
            rep1Map.put(a.Id, a);
        }
        //get Sales Manager 2s that need to be created or should already exist
        SM2Managers = [SELECT ID, FirstName, LastName,  UserRole.Name, ManagerId FROM USER WHERE Forecast_Role__c =:SM2Type And ManagerID  != NULL];
        for (User a : SM2Managers){
            SM2Map.put(a.Id, a);
        }
        //get Sales Manager 1s that need to be created or should already exist
        SM1Managers = [SELECT ID, FirstName, LastName,  UserRole.Name, ManagerId FROM USER WHERE (Forecast_Role__c =:SM1Type OR Forecast_Role__c =:coopType) And IsActive = true];
        for (User a : SM1Managers){
            SM1Map.put(a.Id, a);
        }
        List<Archive_Program_Forecast__c> pfScope = (List<Archive_Program_Forecast__c>)scope;
        Map<Id, Map<String, Double>> ptsMAP = new Map<Id, Map<String, Double>>();
        accountList = new Set<ID>();
        Set<ID> pfList = new Set<ID>();
        Set<ID> programList = new Set<Id>();
        Set<ID>userIDList = new Set<ID>();
        uniquePairs = new Set<String>();
        for (Archive_Program_Forecast__c a : pfScope){
            accountList.add(a.Program__r.Opportunity__r.Account.Id);
            pfList.add(a.Id);
            programList.add(a.Program__c);
        }
        
        for (Archive_Product_Type_Split__c a : [SELECT Id, Program__c, Product_Type__c, Percent__c From Archive_Product_Type_Split__c Where Program__c IN : programList]){
            if (!ptsMap.containsKey(a.Program__c)){
                ptsMap.put(a.Program__c, new Map<String, Double>());
            }
            ptsMap.get(a.Program__c).put(a.Product_Type__c, a.Percent__c);
            system.debug('***add to map: ' + a.Program__c + ' - ' + a.Product_Type__c + ' %'+ a.Percent__c);
        }
        
        List<Archive_Product_Type_Split__c> insertPTS = new List<Archive_Product_Type_Split__c>();
        for (String x : programList){
            if (!ptsMap.containsKey(x)){
                missingPTSList.add(x);
            }
        }
        
        List<Archive_Program__c> missingPrograms = [Select Id, Product_Type__c From Archive_Program__c Where Id IN : missingPTSList];
        
        for (Archive_Program__c a : missingPrograms){
            if (a.Product_Type__c == null){
                a.Product_Type__c = 'NA';
            }
            //split the multi-select picklist values into an array
            String[] productTypes = a.Product_Type__c.split(';');
            for (String product : productTypes){
                //create a new Product Type Split for each selection
                Archive_Product_Type_Split__c x = new Archive_Product_Type_Split__c();
                x.Program__c = a.Id;
                x.Product_Type__c = product;
                x.Percent__c = (100.00/productTypes.size()).setScale(2);
                system.debug('*** assigning percent: ' + x.Percent__c);
                insertPTS.add(x);
                if (!ptsMap.containsKey(a.Id)){
                    ptsMap.put(a.Id, new Map<String, Double>());
                }
                ptsMap.get(a.Id).put(x.Product_Type__c, x.Percent__c);
            }
        }
        
        update missingPrograms;
        insert insertPTS;
        
/*********************Rep 2**************************/
        userIDList = new Set<ID>();
        for (User s : Rep2Managers){
            userIDList.add(s.Id);
        }
        pfList = new Set<ID>();
        for (Archive_Program_Forecast__c a: pfScope){
            pfList.add(a.Id);
        }
        pF = [SELECT Active__c, Program__r.RecordType.Name, Actual_Amount__c, Program__r.Product_Type__c, Program__r.Opportunity__r.Account.Id, Ad_Period__r.Quarter__c, Ad_Period__r.Is_Split__c, Weighted_Forecast_Amount__c, Previous_Quarter_Amount__c, Oppty_Probability__c, Next_Quarter_Amount__c, Forecast_Amount__c, Program__r.Opportunity__r.OwnerId, Program__r.Delivery_Type__c, Program__r.Opportunity__r.Account.RecordType.Name,  Weighted_Previous_Quarter_Forecast__c, Weighted_Next_Quarter_Forecast__c, Previous_Quarter_Ratio__c,Previous_Quarter_Actual__c, Next_Quarter_Ratio__c, Next_Quarter_Actual__c FROM Archive_Program_Forecast__c WHERE Program__r.Opportunity__r.OwnerId IN :userIDList And Id IN :pfList ORDER BY Program__r.Opportunity__r.OwnerId, Ad_Period__r.Quarter__c];
        //get unique combinations of reps and quarters that we will need to create forecasts for
        getUniquePairs(pf);
        
        system.debug('***before insert SDPYSM1: ' + system.now());
        refreshForecasts();
        clearInsertLists();
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
        refreshForecasts();
        clearInsertLists();

/*********************Rep 1**************************/
        
        clearInsertLists();
        uniquePairs = new Set<String>();
        userIDList = new Set<ID>();
        for (User s : Rep1Managers){
            userIDList.add(s.Id);
        }
        pF = [SELECT Active__c, Program__r.RecordType.Name, Actual_Amount__c, Program__r.Product_Type__c, Program__r.Opportunity__r.Account.Id, Ad_Period__r.Quarter__c, Ad_Period__r.Is_Split__c, Weighted_Forecast_Amount__c, Previous_Quarter_Amount__c, Oppty_Probability__c, Next_Quarter_Amount__c, Forecast_Amount__c, Program__r.Opportunity__r.OwnerId, Program__r.Delivery_Type__c, Program__r.Opportunity__r.Account.RecordType.Name,  Weighted_Previous_Quarter_Forecast__c, Weighted_Next_Quarter_Forecast__c, Previous_Quarter_Ratio__c,Previous_Quarter_Actual__c, Next_Quarter_Ratio__c, Next_Quarter_Actual__c, F_Actual_Amount__c, F_Next_Quarter_Actual__c, F_Previous_Quarter_Actual__c  FROM Archive_Program_Forecast__c WHERE Program__r.Opportunity__r.OwnerId IN :userIDList And Id IN :pfList ORDER BY Program__r.Opportunity__r.OwnerId, Ad_Period__r.Quarter__c];
        //get unique combinations of reps and quarters that we will need to create forecasts for
        getUniquePairs(pf);
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
        refreshForecasts();
        clearInsertLists();
        for(string x : uniquePairs){
            createRep1Forecast(x);
        }
        insert insertRep1;
        //requery and get list for forecast amount updates
        refreshForecasts();
        clearInsertLists();

        
/*********************SM 2**************************/
        clearInsertLists();
        uniquePairs = new Set<String>();
        userIDList = new Set<ID>();
        for (User s : SM2Managers){
            userIDList.add(s.Id);
        }
        pF = [SELECT Active__c, Program__r.RecordType.Name, Actual_Amount__c, Program__r.Product_Type__c, Program__r.Opportunity__r.Account.Id, Ad_Period__r.Quarter__c, Ad_Period__r.Is_Split__c, Weighted_Forecast_Amount__c, Previous_Quarter_Amount__c, Oppty_Probability__c, Next_Quarter_Amount__c, Forecast_Amount__c, Program__r.Opportunity__r.OwnerId, Program__r.Delivery_Type__c, Program__r.Opportunity__r.Account.RecordType.Name,  Weighted_Previous_Quarter_Forecast__c, Weighted_Next_Quarter_Forecast__c, Previous_Quarter_Ratio__c,Previous_Quarter_Actual__c, Next_Quarter_Ratio__c, Next_Quarter_Actual__c, F_Actual_Amount__c, F_Next_Quarter_Actual__c, F_Previous_Quarter_Actual__c  FROM Archive_Program_Forecast__c WHERE Program__r.Opportunity__r.OwnerId IN :userIDList And Id IN :pfList ORDER BY Program__r.Opportunity__r.OwnerId, Ad_Period__r.Quarter__c];
        //get unique combinations of reps and quarters that we will need to create forecasts for
        getUniquePairs(pf);
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
        sm1 = [Select r.SDPY_Forecast__c, r.Quarter__c, r.Quarter_Start_Date__c, r.Quarter_End_Date__c, r.Product_Type__c, r.OwnerId, r.Name, r.Manager__c, r.Manager_Forecast__c, r.Id, r.Forecast_Proposal__c, r.Weighted_Forecast_Proposal__c, r.Forecast_Contract__c, r.Delivery_Type__c, r.Actual_Amount__c, r.Account__c, r.Account_Type__c From Sales_Manager_1_Forecast__c r WHERE r.Account__c IN :accountList];
        clearInsertLists();
        for(string x : uniquePairs){
            createSM2Forecast(x);
        }
        insert insertSM2;
        //requery and get list for forecast amount updates
        sm2 = [Select r.SDPY_Forecast__c, r.Quarter__c, r.Quarter_Start_Date__c, r.Quarter_End_Date__c, r.Product_Type__c, r.OwnerId, r.Name, r.Manager__c, r.Manager_Forecast__c, r.Id, r.Forecast_Proposal__c, r.Weighted_Forecast_Proposal__c, r.Forecast_Contract__c, r.Delivery_Type__c, r.Actual_Amount__c, r.Account__c, r.Account_Type__c From Sales_Manager_2_Forecast__c r WHERE r.Account__c IN :accountList];
        clearInsertLists();


/*********************SM 1**************************/
        clearInsertLists();
        uniquePairs = new Set<String>();
        userIDList = new Set<ID>();
        for (User s : SM1Managers){
            userIDList.add(s.Id);
        }
        pF = [SELECT Active__c, Program__r.RecordType.Name, Actual_Amount__c, Program__r.Product_Type__c, Program__r.Opportunity__r.Account.Id, Ad_Period__r.Quarter__c, Ad_Period__r.Is_Split__c, Weighted_Forecast_Amount__c, Previous_Quarter_Amount__c, Oppty_Probability__c, Next_Quarter_Amount__c, Forecast_Amount__c, Program__r.Opportunity__r.OwnerId, Program__r.Delivery_Type__c, Program__r.Opportunity__r.Account.RecordType.Name,  Weighted_Previous_Quarter_Forecast__c, Weighted_Next_Quarter_Forecast__c, Previous_Quarter_Ratio__c,Previous_Quarter_Actual__c, Next_Quarter_Ratio__c, Next_Quarter_Actual__c, F_Actual_Amount__c, F_Next_Quarter_Actual__c, F_Previous_Quarter_Actual__c  FROM Archive_Program_Forecast__c WHERE Program__r.Opportunity__r.OwnerId IN :userIDList And Id IN :pfList ORDER BY Program__r.Opportunity__r.OwnerId, Ad_Period__r.Quarter__c];
        //get unique combinations of reps and quarters that we will need to create forecasts for
        getUniquePairs(pf);
        //create Sales Manager 1 Forecasts that don't already exist
        for(string x : uniquePairs){
            createSM1Forecast(x);
        }
        insert insertSDPYSM1;
        //create Sales Manager 1 Forecasts that don't already exist
        sdpySM1 = [Select  r.Quarter__c, r.Quarter_Start_Date__c, r.Quarter_End_Date__c, r.Product_Type__c, r.OwnerId, r.Name, r.Manager__c, r.Manager_Forecast__c, r.Id, r.Forecast_Proposal__c, r.Weighted_Forecast_Proposal__c, r.Forecast_Contract__c, r.Delivery_Type__c, r.Actual_Amount__c, r.Account__c, r.Account_Type__c From SDPY_Sales_Manager_1_Forecast__c r WHERE r.Account__c IN :accountList];
        clearInsertLists();
        for(string x : uniquePairs){
            createSM1Forecast(x);
        }
        insert insertSM1;
        //requery and get list for forecast amount updates
        sm1 = [Select r.SDPY_Forecast__c, r.Quarter__c, r.Quarter_Start_Date__c, r.Quarter_End_Date__c, r.Product_Type__c, r.OwnerId, r.Name, r.Manager__c, r.Manager_Forecast__c, r.Id, r.Forecast_Proposal__c, r.Weighted_Forecast_Proposal__c, r.Forecast_Contract__c, r.Delivery_Type__c, r.Actual_Amount__c, r.Account__c, r.Account_Type__c From Sales_Manager_1_Forecast__c r WHERE r.Account__c IN :accountList];
        clearInsertLists();

/*********************Updates**************************/

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
        pF = [SELECT Active__c, Program__r.RecordType.Name, Actual_Amount__c, Program__r.Product_Type__c, Program__r.Opportunity__r.Account.Id, Ad_Period__r.Quarter__c, Ad_Period__r.Is_Split__c, Weighted_Forecast_Amount__c, Previous_Quarter_Amount__c, Oppty_Probability__c, Next_Quarter_Amount__c, Forecast_Amount__c, Program__r.Opportunity__r.OwnerId, Program__r.Delivery_Type__c, Program__r.Opportunity__r.Account.RecordType.Name,  Weighted_Previous_Quarter_Forecast__c, Weighted_Next_Quarter_Forecast__c, Previous_Quarter_Ratio__c,Previous_Quarter_Actual__c, Next_Quarter_Ratio__c, Next_Quarter_Actual__c, F_Actual_Amount__c, F_Next_Quarter_Actual__c, F_Previous_Quarter_Actual__c  FROM Archive_Program_Forecast__c WHERE Program__r.Opportunity__r.OwnerId Not IN :userIDList And Id IN :pfList ORDER BY Program__r.Opportunity__r.OwnerId, Ad_Period__r.Quarter__c];
        uniquePairs = new Set<String>();
        if (coopUser != null){
                for (Archive_Program_Forecast__c a : pf){
                if (a.Program__r.Product_Type__c == null){
                    if (!uniquePairs.contains(coopUser.Id + '-'+ getNY(a.Ad_Period__r.Quarter__c) + '-' +a.Program__r.Opportunity__r.Account.Id + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + '')){
                    uniquePairs.add(coopUser.Id + '-'+ getNY(a.Ad_Period__r.Quarter__c) + '-' +a.Program__r.Opportunity__r.Account.Id  + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + '');
                    }
                    if (a.Ad_Period__r.Is_Split__c == 'true'){
                        if (!uniquePairs.contains(coopUser.Id + '-'+ getNY(getNextQuarter(a.Ad_Period__r.Quarter__c)) + '-' +a.Program__r.Opportunity__r.Account.Id  + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + '')){
                            uniquePairs.add(coopUser.Id + '-'+ getNY(getNextQuarter(a.Ad_Period__r.Quarter__c)) + '-' +a.Program__r.Opportunity__r.Account.Id  + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + '');
                        }           
                    }   
                } else {
                    for (String x : a.Program__r.Product_Type__c.split(';')){
                        if (!uniquePairs.contains(coopUser.Id + '-'+ getNY(a.Ad_Period__r.Quarter__c) + '-' +a.Program__r.Opportunity__r.Account.Id + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + x)){
                        uniquePairs.add(coopUser.Id + '-'+ getNY(a.Ad_Period__r.Quarter__c) + '-' +a.Program__r.Opportunity__r.Account.Id  + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + x);
                        }
                        if (a.Ad_Period__r.Is_Split__c == 'true'){
                            if (!uniquePairs.contains(coopUser.Id + '-'+ getNY(getNextQuarter(a.Ad_Period__r.Quarter__c)) + '-' +a.Program__r.Opportunity__r.Account.Id  + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + x)){
                                uniquePairs.add(coopUser.Id + '-'+ getNY(getNextQuarter(a.Ad_Period__r.Quarter__c)) + '-' +a.Program__r.Opportunity__r.Account.Id  + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + x);
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
        sdpySM1 = [Select  r.Quarter__c, r.Quarter_Start_Date__c, r.Quarter_End_Date__c, r.Product_Type__c, r.OwnerId, r.Name, r.Manager__c, r.Manager_Forecast__c, r.Id, r.Forecast_Proposal__c, r.Weighted_Forecast_Proposal__c, r.Forecast_Contract__c, r.Delivery_Type__c, r.Actual_Amount__c, r.Account__c, r.Account_Type__c From SDPY_Sales_Manager_1_Forecast__c r WHERE r.Account__c IN :accountList];
        clearInsertLists();
        for(string x : uniquePairs){
            createSM1Forecast(x);
        }
        insert insertSM1;
        
        pf = [SELECT Program__r.RecordType.Name, Program__r.Opportunity__r.Account.Id, Ad_Period__r.Quarter__c, Ad_Period__r.Is_Split__c, Weighted_Forecast_Amount__c,
            Previous_Quarter_Amount__c, Oppty_Probability__c, Next_Quarter_Amount__c, Forecast_Amount__c, Program__r.Opportunity__r.OwnerId, 
            Program__r.Delivery_Type__c, Program__r.Opportunity__r.Account.RecordType.Name,  Weighted_Previous_Quarter_Forecast__c, Program__r.Product_Type__c,
            Weighted_Next_Quarter_Forecast__c, Active__c, Previous_Quarter_Ratio__c,Previous_Quarter_Actual__c, Next_Quarter_Ratio__c, Next_Quarter_Actual__c, Actual_Amount__c
            , F_Actual_Amount__c, F_Next_Quarter_Actual__c, F_Previous_Quarter_Actual__c 
            FROM Archive_Program_Forecast__c WHERE Id IN :pfList And Program__r.Opportunity__r.OwnerId Not IN :userIDList];
        
        if (coopUser != null){
            for (Archive_Program_Forecast__c a : pf){
                for (SDPY_Sales_Manager_1_Forecast__c forecast: sdpySM1){
                    if (forecast.Weighted_Forecast_Proposal__c == null) forecast.Weighted_Forecast_Proposal__c = 0;
                    if (forecast.Actual_Amount__c == null) forecast.Actual_Amount__c = 0;
                    if (forecast.Forecast_Proposal__c == null) forecast.Forecast_Proposal__c = 0;
                    if (forecast.Forecast_Contract__c == null) forecast.Forecast_Contract__c = 0;
                    if(ptsMAP.get(a.Program__c).containsKey(forecast.Product_Type__c)){
                        if (forecast.Account__c == a.Program__r.Opportunity__r.Account.Id && forecast.OwnerId == coopUser.Id && forecast.Account_Type__c == a.Program__r.Opportunity__r.Account.RecordType.Name && forecast.Quarter__c == a.Ad_Period__r.Quarter__c && forecast.Delivery_Type__c == a.Program__r.Delivery_Type__c){
                            //system.debug('***found');
                        if (a.Ad_Period__r.Is_Split__c == 'true'){
                            if ((a.Previous_Quarter_Amount__c == 0 && a.Next_Quarter_Amount__c == 0) || a.Previous_Quarter_Amount__c == null){
                                if (a.Active__c == false){
                                    if (a.F_Previous_Quarter_Actual__c == null && a.F_Next_Quarter_Actual__c != null){
                                        forecast.Actual_Amount__c += (a.F_Actual_Amount__c - a.F_Next_Quarter_Actual__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    } else {
                                        forecast.Actual_Amount__c += (a.F_Previous_Quarter_Actual__c == null ? (a.F_Actual_Amount__c == null? 0 : a.F_Actual_Amount__c) * a.Previous_Quarter_Ratio__c/100 : a.F_Previous_Quarter_Actual__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    }
                                } else {
                                    if (a.Program__r.RecordType.Name == 'Contract'){
                                        forecast.Forecast_Contract__c += a.Forecast_Amount__c/2 * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    } else {
                                        forecast.Forecast_Proposal__c += a.Forecast_Amount__c/2 * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                        forecast.Weighted_Forecast_Proposal__c += (a.Weighted_Forecast_Amount__c == null ? 0: a.Weighted_Forecast_Amount__c)/2 * (ptsMAP.get(a.Program__c) == null? 0 : (ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) == null ? 0 : ptsMAP.get(a.Program__c).get(forecast.Product_Type__c))) / 100;
                                    }
                                }
                            }
                            //if split forecasts entered
                            else{
                                if (a.Active__c == false){
                                    if (a.F_Previous_Quarter_Actual__c == null && a.F_Next_Quarter_Actual__c != null){
                                        forecast.Actual_Amount__c += (a.F_Actual_Amount__c - a.F_Next_Quarter_Actual__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    } else {
                                        forecast.Actual_Amount__c += (a.F_Previous_Quarter_Actual__c == null ? (a.F_Actual_Amount__c == null? 0 : a.F_Actual_Amount__c) * a.Previous_Quarter_Ratio__c/100 : a.F_Previous_Quarter_Actual__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    }
                                } else {
                                    if (a.Program__r.RecordType.Name == 'Contract'){
                                        forecast.Forecast_Contract__c += a.Previous_Quarter_Amount__c * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    } else {
                                        forecast.Forecast_Proposal__c += a.Previous_Quarter_Amount__c * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                        forecast.Weighted_Forecast_Proposal__c+= (a.Weighted_Previous_Quarter_Forecast__c == null ? 0 : a.Weighted_Previous_Quarter_Forecast__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    }
                                }
                            } 
                        } else {
                            if (a.Active__c == false){
                                forecast.Actual_Amount__c+= (a.F_Actual_Amount__c == null? 0 : a.F_Actual_Amount__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                            } else {
                                if (a.Program__r.RecordType.Name == 'Contract'){
                                    forecast.Forecast_Contract__c += a.Forecast_Amount__c * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                } else {
                                    forecast.Forecast_Proposal__c += a.Forecast_Amount__c * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    forecast.Weighted_Forecast_Proposal__c+= (a.Weighted_Forecast_Amount__c == null ? 0 : a.Weighted_Forecast_Amount__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                }
                            }
                        }
                        //break;
                    } else if (a.Ad_Period__r.Is_Split__c == 'true' && forecast.Account__c == a.Program__r.Opportunity__r.Account.Id && forecast.OwnerId == a.Program__r.Opportunity__r.OwnerId && forecast.Account_Type__c == a.Program__r.Opportunity__r.Account.RecordType.Name && forecast.Quarter__c == getNextQuarter(a.Ad_Period__r.Quarter__c) && forecast.Product_Type__c == a.Program__r.Product_Type__c && forecast.Delivery_Type__c == a.Program__r.Delivery_Type__c){
                        //system.debug('***SM2 year split ' + getNextQuarter(a.Ad_Period__r.Quarter__c) + ' - ' + a.F_Next_Quarter_Actual__c + ' - ' + a.Next_Quarter_Amount__c);
                        if ((a.Previous_Quarter_Amount__c == 0 && a.Next_Quarter_Amount__c == 0) || a.Next_Quarter_Amount__c == null){
                           if (a.Active__c == false){
                                if (a.F_Next_Quarter_Actual__c == null && a.F_Previous_Quarter_Actual__c != null){
                                    forecast.Actual_Amount__c += (a.F_Actual_Amount__c - a.F_Previous_Quarter_Actual__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                } else {
                                    forecast.Actual_Amount__c += (a.F_Next_Quarter_Actual__c == null ? (a.F_Actual_Amount__c == null? 0 : a.F_Actual_Amount__c) * a.Next_Quarter_Ratio__c/100 : a.F_Next_Quarter_Actual__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                }
                           } else {
                                if (a.Program__r.RecordType.Name == 'Contract'){
                                    forecast.Forecast_Contract__c += a.Forecast_Amount__c/2 * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                } else {
                                    forecast.Forecast_Proposal__c += a.Forecast_Amount__c/2 * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    forecast.Weighted_Forecast_Proposal__c += (a.Weighted_Forecast_Amount__c == null ? 0: a.Weighted_Forecast_Amount__c) * (ptsMAP.get(a.Program__c) == null? 0 : (ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) == null ? 0 : ptsMAP.get(a.Program__c).get(forecast.Product_Type__c))) / 100;
                                }
                           }
                        }
                        //if split forecasts entered
                        else{
                            if (a.Active__c == false){
                                if (a.F_Next_Quarter_Actual__c == null && a.F_Previous_Quarter_Actual__c != null){
                                    forecast.Actual_Amount__c += (a.F_Actual_Amount__c - a.F_Previous_Quarter_Actual__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                } else {
                                    forecast.Actual_Amount__c += (a.F_Next_Quarter_Actual__c == null ? (a.F_Actual_Amount__c == null? 0 : a.F_Actual_Amount__c) * a.Next_Quarter_Ratio__c/100 : a.F_Next_Quarter_Actual__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                }
                            } else {
                                if (a.Program__r.RecordType.Name == 'Contract'){
                                    forecast.Forecast_Contract__c += a.Next_Quarter_Amount__c * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                } else {
                                    forecast.Forecast_Proposal__c += a.Next_Quarter_Amount__c * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    forecast.Weighted_Forecast_Proposal__c+= (a.Weighted_Next_Quarter_Forecast__c == null ? 0 : a.Weighted_Next_Quarter_Forecast__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                }
                            }
                        } 
                        //break;
                    }
                }
            }
        }
        }
        update sdpySM1;
        sdpySM1 = [Select  r.Quarter__c, r.Quarter_Start_Date__c, r.Quarter_End_Date__c, r.Product_Type__c, r.OwnerId, r.Name, r.Manager__c, r.Manager_Forecast__c, r.Id, r.Forecast_Proposal__c, r.Weighted_Forecast_Proposal__c, r.Forecast_Contract__c, r.Delivery_Type__c, r.Actual_Amount__c, r.Account__c, r.Account_Type__c From SDPY_Sales_Manager_1_Forecast__c r WHERE r.Account__c IN :accountList];
        
/*********************Updates**************************/
        //update SDPY Rep 2
        Set<ID> userList = new Set<ID>();
        for (SDPY_Rep_2_Forecast__c a : sdpyRep2){
            userList.add(a.Owner__c);
        }
        List<Archive_Program_Forecast__c> pf = [SELECT Program__r.RecordType.Name, Program__r.Opportunity__r.Account.Id, Ad_Period__r.Quarter__c, Ad_Period__r.Is_Split__c, Weighted_Forecast_Amount__c,
            Previous_Quarter_Amount__c, Oppty_Probability__c, Next_Quarter_Amount__c, Forecast_Amount__c, Program__r.Opportunity__r.OwnerId, 
            Program__r.Delivery_Type__c, Program__r.Opportunity__r.Account.RecordType.Name,  Weighted_Previous_Quarter_Forecast__c, Program__r.Product_Type__c,
            Weighted_Next_Quarter_Forecast__c, Active__c, Previous_Quarter_Ratio__c,Previous_Quarter_Actual__c, Next_Quarter_Ratio__c, Next_Quarter_Actual__c, Actual_Amount__c, F_Actual_Amount__c, F_Next_Quarter_Actual__c, F_Previous_Quarter_Actual__c 
            FROM Archive_Program_Forecast__c WHERE Id IN :pfList And Program__r.Opportunity__r.OwnerId IN :userList];
        
        for (Archive_Program_Forecast__c a : pf){
            for (SDPY_Rep_2_Forecast__c forecast: sdpyRep2){
                if (forecast.Weighted_Forecast_Proposal__c == null) forecast.Weighted_Forecast_Proposal__c = 0;
                if (forecast.Actual_Amount__c == null) forecast.Actual_Amount__c = 0;
                if (forecast.Forecast_Proposal__c == null) forecast.Forecast_Proposal__c = 0;
                if (forecast.Forecast_Contract__c == null) forecast.Forecast_Contract__c = 0;
                if(ptsMAP.get(a.Program__c).containsKey(forecast.Product_Type__c)){
                    if (forecast.Account__c == a.Program__r.Opportunity__r.Account.Id && forecast.Owner__c == a.Program__r.Opportunity__r.OwnerId && forecast.Account_Type__c == a.Program__r.Opportunity__r.Account.RecordType.Name && forecast.Quarter__c == a.Ad_Period__r.Quarter__c && forecast.Delivery_Type__c == a.Program__r.Delivery_Type__c){
                        //system.debug('***found');
                        if (a.Ad_Period__r.Is_Split__c == 'true'){
                            if ((a.Previous_Quarter_Amount__c == 0 && a.Next_Quarter_Amount__c == 0) || a.Previous_Quarter_Amount__c == null){
                                if (a.Active__c == false){
                                    if (a.F_Previous_Quarter_Actual__c == null && a.F_Next_Quarter_Actual__c != null){
                                        forecast.Actual_Amount__c += (a.F_Actual_Amount__c - a.F_Next_Quarter_Actual__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    } else {
                                        forecast.Actual_Amount__c += (a.F_Previous_Quarter_Actual__c == null ? (a.F_Actual_Amount__c == null? 0 : a.F_Actual_Amount__c) * a.Previous_Quarter_Ratio__c/100 : a.F_Previous_Quarter_Actual__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    }
                                } else {
                                    if (a.Program__r.RecordType.Name == 'Contract'){
                                        forecast.Forecast_Contract__c += a.Forecast_Amount__c/2 * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    } else {
                                        forecast.Forecast_Proposal__c += a.Forecast_Amount__c/2 * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                        forecast.Weighted_Forecast_Proposal__c += (a.Weighted_Forecast_Amount__c == null ? 0: a.Weighted_Forecast_Amount__c)/2 * (ptsMAP.get(a.Program__c) == null? 0 : (ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) == null ? 0 : ptsMAP.get(a.Program__c).get(forecast.Product_Type__c))) / 100;
                                    }
                                }
                            }
                            //if split forecasts entered
                            else{
                                if (a.Active__c == false){
                                    if (a.F_Previous_Quarter_Actual__c == null && a.F_Next_Quarter_Actual__c != null){
                                        forecast.Actual_Amount__c += (a.F_Actual_Amount__c - a.F_Next_Quarter_Actual__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    } else {
                                        forecast.Actual_Amount__c += (a.F_Previous_Quarter_Actual__c == null ? (a.F_Actual_Amount__c == null? 0 : a.F_Actual_Amount__c) * a.Previous_Quarter_Ratio__c/100 : a.F_Previous_Quarter_Actual__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    }
                                } else {
                                    if (a.Program__r.RecordType.Name == 'Contract'){
                                        forecast.Forecast_Contract__c += a.Previous_Quarter_Amount__c * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    } else {
                                        forecast.Forecast_Proposal__c += a.Previous_Quarter_Amount__c * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100; 
                                        forecast.Weighted_Forecast_Proposal__c+= (a.Weighted_Previous_Quarter_Forecast__c == null ? 0 : a.Weighted_Previous_Quarter_Forecast__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    }
                                }
                            } 
                        } else {
                            if (a.Active__c == false){
                                forecast.Actual_Amount__c+= (a.F_Actual_Amount__c == null? 0 : a.F_Actual_Amount__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                            } else {
                                if (a.Program__r.RecordType.Name == 'Contract'){
                                    forecast.Forecast_Contract__c += a.Forecast_Amount__c * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                } else {
                                    forecast.Forecast_Proposal__c += a.Forecast_Amount__c * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    forecast.Weighted_Forecast_Proposal__c+= (a.Weighted_Forecast_Amount__c == null ? 0 : a.Weighted_Forecast_Amount__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                }
                            }
                        }
                        //break;
                    } else if (a.Ad_Period__r.Is_Split__c == 'true' && forecast.Account__c == a.Program__r.Opportunity__r.Account.Id && forecast.Owner__c == a.Program__r.Opportunity__r.OwnerId && forecast.Account_Type__c == a.Program__r.Opportunity__r.Account.RecordType.Name && forecast.Quarter__c == getNextQuarter(a.Ad_Period__r.Quarter__c) && forecast.Product_Type__c == a.Program__r.Product_Type__c && forecast.Delivery_Type__c == a.Program__r.Delivery_Type__c){
                        //system.debug('***SM2 year split ' + getNextQuarter(a.Ad_Period__r.Quarter__c) + ' - ' + a.F_Next_Quarter_Actual__c + ' - ' + a.Next_Quarter_Amount__c);
                        if ((a.Previous_Quarter_Amount__c == 0 && a.Next_Quarter_Amount__c == 0) || a.Next_Quarter_Amount__c == null){
                           if (a.Active__c == false){
                                if (a.F_Next_Quarter_Actual__c == null && a.F_Previous_Quarter_Actual__c != null){
                                    forecast.Actual_Amount__c += (a.F_Actual_Amount__c - a.F_Previous_Quarter_Actual__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                } else {
                                    forecast.Actual_Amount__c += (a.F_Next_Quarter_Actual__c == null ? (a.F_Actual_Amount__c == null? 0 : a.F_Actual_Amount__c) * a.Next_Quarter_Ratio__c/100 : a.F_Next_Quarter_Actual__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                }
                           } else {
                                if (a.Program__r.RecordType.Name == 'Contract'){
                                    forecast.Forecast_Contract__c += a.Forecast_Amount__c/2 * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                } else {
                                    forecast.Forecast_Proposal__c += a.Forecast_Amount__c/2 * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    forecast.Weighted_Forecast_Proposal__c += (a.Weighted_Forecast_Amount__c == null ? 0: a.Weighted_Forecast_Amount__c) * (ptsMAP.get(a.Program__c) == null? 0 : (ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) == null ? 0 : ptsMAP.get(a.Program__c).get(forecast.Product_Type__c))) / 100;
                                }
                           }
                        }
                        //if split forecasts entered
                        else{
                            if (a.Active__c == false){
                                if (a.F_Next_Quarter_Actual__c == null && a.F_Previous_Quarter_Actual__c != null){
                                    forecast.Actual_Amount__c += (a.F_Actual_Amount__c - a.F_Previous_Quarter_Actual__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                } else {
                                    forecast.Actual_Amount__c += (a.F_Next_Quarter_Actual__c == null ? (a.F_Actual_Amount__c == null? 0 : a.F_Actual_Amount__c) * a.Next_Quarter_Ratio__c/100 : a.F_Next_Quarter_Actual__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                }
                            } else {
                                if (a.Program__r.RecordType.Name == 'Contract'){
                                    forecast.Forecast_Contract__c += a.Next_Quarter_Amount__c * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                } else {
                                    forecast.Forecast_Proposal__c += a.Next_Quarter_Amount__c * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    forecast.Weighted_Forecast_Proposal__c+= (a.Weighted_Next_Quarter_Forecast__c == null ? 0 : a.Weighted_Next_Quarter_Forecast__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                }
                            }
                        } 
                        //break;
                    }
                }
            }
        }
        update sdpyRep2;
        
        
        //update SDPY Rep 1
        userList = new Set<ID>();
        for (SDPY_Rep_1_Forecast__c a : sdpyRep1){
            userList.add(a.Owner__c);
        }
        pf = [SELECT Program__r.RecordType.Name, Program__r.Opportunity__r.Account.Id, Ad_Period__r.Quarter__c, Ad_Period__r.Is_Split__c, Weighted_Forecast_Amount__c,
            Previous_Quarter_Amount__c, Oppty_Probability__c, Next_Quarter_Amount__c, Forecast_Amount__c, Program__r.Opportunity__r.OwnerId, 
            Program__r.Delivery_Type__c, Program__r.Opportunity__r.Account.RecordType.Name,  Weighted_Previous_Quarter_Forecast__c, Program__r.Product_Type__c,
            Weighted_Next_Quarter_Forecast__c, Active__c, Previous_Quarter_Ratio__c,Previous_Quarter_Actual__c, Next_Quarter_Ratio__c, Next_Quarter_Actual__c, Actual_Amount__c, F_Actual_Amount__c, F_Next_Quarter_Actual__c, F_Previous_Quarter_Actual__c 
            FROM Archive_Program_Forecast__c WHERE Id IN :pfList And Program__r.Opportunity__r.OwnerId IN :userList];
        
        for (Archive_Program_Forecast__c a : pf){
            for (SDPY_Rep_1_Forecast__c forecast: sdpyRep1){
                if (forecast.Weighted_Forecast_Proposal__c == null) forecast.Weighted_Forecast_Proposal__c = 0;
                if (forecast.Actual_Amount__c == null) forecast.Actual_Amount__c = 0;
                if (forecast.Forecast_Proposal__c == null) forecast.Forecast_Proposal__c = 0;
                if (forecast.Forecast_Contract__c == null) forecast.Forecast_Contract__c = 0;
                if(ptsMAP.get(a.Program__c).containsKey(forecast.Product_Type__c)){
                    if (forecast.Account__c == a.Program__r.Opportunity__r.Account.Id && forecast.Owner__c == a.Program__r.Opportunity__r.OwnerId && forecast.Account_Type__c == a.Program__r.Opportunity__r.Account.RecordType.Name && forecast.Quarter__c == a.Ad_Period__r.Quarter__c && forecast.Delivery_Type__c == a.Program__r.Delivery_Type__c){
                        //system.debug('***found');
                        if (a.Ad_Period__r.Is_Split__c == 'true'){
                            if ((a.Previous_Quarter_Amount__c == 0 && a.Next_Quarter_Amount__c == 0) || a.Previous_Quarter_Amount__c == null){
                                if (a.Active__c == false){
                                    if (a.F_Previous_Quarter_Actual__c == null && a.F_Next_Quarter_Actual__c != null){
                                        forecast.Actual_Amount__c += (a.F_Actual_Amount__c - a.F_Next_Quarter_Actual__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    } else {
                                        forecast.Actual_Amount__c += (a.F_Previous_Quarter_Actual__c == null ? (a.F_Actual_Amount__c == null? 0 : a.F_Actual_Amount__c) * a.Previous_Quarter_Ratio__c/100 : a.F_Previous_Quarter_Actual__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    }
                                } else {
                                    if (a.Program__r.RecordType.Name == 'Contract'){
                                        forecast.Forecast_Contract__c += a.Forecast_Amount__c/2 * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    } else {
                                        forecast.Forecast_Proposal__c += a.Forecast_Amount__c/2 * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                        forecast.Weighted_Forecast_Proposal__c += (a.Weighted_Forecast_Amount__c == null ? 0: a.Weighted_Forecast_Amount__c)/2 * (ptsMAP.get(a.Program__c) == null? 0 : (ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) == null ? 0 : ptsMAP.get(a.Program__c).get(forecast.Product_Type__c))) / 100;
                                    }
                                }
                            }
                            //if split forecasts entered
                            else{
                                if (a.Active__c == false){
                                    if (a.F_Previous_Quarter_Actual__c == null && a.F_Next_Quarter_Actual__c != null){
                                        forecast.Actual_Amount__c += (a.F_Actual_Amount__c - a.F_Next_Quarter_Actual__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    } else {
                                        forecast.Actual_Amount__c += (a.F_Previous_Quarter_Actual__c == null ? (a.F_Actual_Amount__c == null? 0 : a.F_Actual_Amount__c) * a.Previous_Quarter_Ratio__c/100 : a.F_Previous_Quarter_Actual__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    }
                                } else {
                                    if (a.Program__r.RecordType.Name == 'Contract'){
                                        forecast.Forecast_Contract__c += a.Previous_Quarter_Amount__c * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    } else {
                                        forecast.Forecast_Proposal__c += a.Previous_Quarter_Amount__c * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                        forecast.Weighted_Forecast_Proposal__c+= (a.Weighted_Previous_Quarter_Forecast__c == null ? 0 : a.Weighted_Previous_Quarter_Forecast__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    }
                                }
                            } 
                        } else {
                            if (a.Active__c == false){
                                forecast.Actual_Amount__c+= (a.F_Actual_Amount__c == null? 0 : a.F_Actual_Amount__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                            } else {
                                if (a.Program__r.RecordType.Name == 'Contract'){
                                    forecast.Forecast_Contract__c += a.Forecast_Amount__c * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                } else {
                                    forecast.Forecast_Proposal__c += a.Forecast_Amount__c * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    forecast.Weighted_Forecast_Proposal__c+= (a.Weighted_Forecast_Amount__c == null ? 0 : a.Weighted_Forecast_Amount__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                }
                            }
                        }
                        //break;
                    } else if (a.Ad_Period__r.Is_Split__c == 'true' && forecast.Account__c == a.Program__r.Opportunity__r.Account.Id && forecast.Owner__c == a.Program__r.Opportunity__r.OwnerId && forecast.Account_Type__c == a.Program__r.Opportunity__r.Account.RecordType.Name && forecast.Quarter__c == getNextQuarter(a.Ad_Period__r.Quarter__c) && forecast.Product_Type__c == a.Program__r.Product_Type__c && forecast.Delivery_Type__c == a.Program__r.Delivery_Type__c){
                        //system.debug('***SM2 year split ' + getNextQuarter(a.Ad_Period__r.Quarter__c) + ' - ' + a.F_Next_Quarter_Actual__c + ' - ' + a.Next_Quarter_Amount__c);
                        if ((a.Previous_Quarter_Amount__c == 0 && a.Next_Quarter_Amount__c == 0) || a.Next_Quarter_Amount__c == null){
                           if (a.Active__c == false){
                                if (a.F_Next_Quarter_Actual__c == null && a.F_Previous_Quarter_Actual__c != null){
                                    forecast.Actual_Amount__c += (a.F_Actual_Amount__c - a.F_Previous_Quarter_Actual__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                } else {
                                    forecast.Actual_Amount__c += (a.F_Next_Quarter_Actual__c == null ? (a.F_Actual_Amount__c == null? 0 : a.F_Actual_Amount__c) * a.Next_Quarter_Ratio__c/100 : a.F_Next_Quarter_Actual__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                }
                           } else {
                                if (a.Program__r.RecordType.Name == 'Contract'){
                                    forecast.Forecast_Contract__c += a.Forecast_Amount__c/2 * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                } else {
                                    forecast.Forecast_Proposal__c += a.Forecast_Amount__c/2 * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    forecast.Weighted_Forecast_Proposal__c += (a.Weighted_Forecast_Amount__c == null ? 0: a.Weighted_Forecast_Amount__c) * (ptsMAP.get(a.Program__c) == null? 0 : (ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) == null ? 0 : ptsMAP.get(a.Program__c).get(forecast.Product_Type__c))) / 100;
                                }
                           }
                        }
                        //if split forecasts entered
                        else{
                            if (a.Active__c == false){
                                if (a.F_Next_Quarter_Actual__c == null && a.F_Previous_Quarter_Actual__c != null){
                                    forecast.Actual_Amount__c += (a.F_Actual_Amount__c - a.F_Previous_Quarter_Actual__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                } else {
                                    forecast.Actual_Amount__c += (a.F_Next_Quarter_Actual__c == null ? (a.F_Actual_Amount__c == null? 0 : a.F_Actual_Amount__c) * a.Next_Quarter_Ratio__c/100 : a.F_Next_Quarter_Actual__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                }
                            } else {
                                if (a.Program__r.RecordType.Name == 'Contract'){
                                    forecast.Forecast_Contract__c += a.Next_Quarter_Amount__c * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                } else {
                                    forecast.Forecast_Proposal__c += a.Next_Quarter_Amount__c * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    forecast.Weighted_Forecast_Proposal__c+= (a.Weighted_Next_Quarter_Forecast__c == null ? 0 : a.Weighted_Next_Quarter_Forecast__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                }
                            }
                        } 
                        //break;
                    }
                }
            }
        }
        update sdpyRep1;
        
        
        //update SDPY SM2
        userList = new Set<ID>();
        for (SDPY_Sales_Manager_2_Forecast__c a : sdpySM2){
            userList.add(a.Owner__c);
        }
       pf = [SELECT Program__r.RecordType.Name, Program__r.Opportunity__r.Account.Id, Ad_Period__r.Quarter__c, Ad_Period__r.Is_Split__c, Weighted_Forecast_Amount__c,
            Previous_Quarter_Amount__c, Oppty_Probability__c, Next_Quarter_Amount__c, Forecast_Amount__c, Program__r.Opportunity__r.OwnerId, 
            Program__r.Delivery_Type__c, Program__r.Opportunity__r.Account.RecordType.Name,  Weighted_Previous_Quarter_Forecast__c, Program__r.Product_Type__c,
            Weighted_Next_Quarter_Forecast__c, Active__c, Previous_Quarter_Ratio__c,Previous_Quarter_Actual__c, Next_Quarter_Ratio__c, Next_Quarter_Actual__c, Actual_Amount__c, F_Actual_Amount__c, F_Next_Quarter_Actual__c, F_Previous_Quarter_Actual__c 
            FROM Archive_Program_Forecast__c WHERE Id IN :pfList And Program__r.Opportunity__r.OwnerId IN :userList];
        
        for (Archive_Program_Forecast__c a : pf){
            for (SDPY_Sales_Manager_2_Forecast__c forecast: sdpySM2){
                if (forecast.Weighted_Forecast_Proposal__c == null) forecast.Weighted_Forecast_Proposal__c = 0;
                if (forecast.Actual_Amount__c == null) forecast.Actual_Amount__c = 0;
                if (forecast.Forecast_Proposal__c == null) forecast.Forecast_Proposal__c = 0;
                if (forecast.Forecast_Contract__c == null) forecast.Forecast_Contract__c = 0;
                if(ptsMAP.get(a.Program__c).containsKey(forecast.Product_Type__c)){
                    if (forecast.Account__c == a.Program__r.Opportunity__r.Account.Id && forecast.Owner__c == a.Program__r.Opportunity__r.OwnerId && forecast.Account_Type__c == a.Program__r.Opportunity__r.Account.RecordType.Name && forecast.Quarter__c == a.Ad_Period__r.Quarter__c && forecast.Delivery_Type__c == a.Program__r.Delivery_Type__c){
                        //system.debug('***found');
                        //system.debug('***found');
                        if (a.Ad_Period__r.Is_Split__c == 'true'){
                            if ((a.Previous_Quarter_Amount__c == 0 && a.Next_Quarter_Amount__c == 0) || a.Previous_Quarter_Amount__c == null){
                                if (a.Active__c == false){
                                    if (a.F_Previous_Quarter_Actual__c == null && a.F_Next_Quarter_Actual__c != null){
                                        forecast.Actual_Amount__c += (a.F_Actual_Amount__c - a.F_Next_Quarter_Actual__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    } else {
                                        forecast.Actual_Amount__c += (a.F_Previous_Quarter_Actual__c == null ? (a.F_Actual_Amount__c == null? 0 : a.F_Actual_Amount__c) * a.Previous_Quarter_Ratio__c/100 : a.F_Previous_Quarter_Actual__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    }
                                } else {
                                    if (a.Program__r.RecordType.Name == 'Contract'){
                                        forecast.Forecast_Contract__c += a.Forecast_Amount__c/2 * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    } else {
                                        forecast.Forecast_Proposal__c += a.Forecast_Amount__c/2 * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                        forecast.Weighted_Forecast_Proposal__c += (a.Weighted_Forecast_Amount__c == null ? 0: a.Weighted_Forecast_Amount__c)/2 * (ptsMAP.get(a.Program__c) == null? 0 : (ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) == null ? 0 : ptsMAP.get(a.Program__c).get(forecast.Product_Type__c))) / 100;
                                    }
                                }
                            }
                            //if split forecasts entered
                            else{
                                if (a.Active__c == false){
                                    if (a.F_Previous_Quarter_Actual__c == null && a.F_Next_Quarter_Actual__c != null){
                                        forecast.Actual_Amount__c += (a.F_Actual_Amount__c - a.F_Next_Quarter_Actual__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    } else {
                                        forecast.Actual_Amount__c += (a.F_Previous_Quarter_Actual__c == null ? (a.F_Actual_Amount__c == null? 0 : a.F_Actual_Amount__c) * a.Previous_Quarter_Ratio__c/100 : a.F_Previous_Quarter_Actual__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    }
                                } else {
                                    if (a.Program__r.RecordType.Name == 'Contract'){
                                        forecast.Forecast_Contract__c += a.Previous_Quarter_Amount__c * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    } else {
                                        forecast.Forecast_Proposal__c += a.Previous_Quarter_Amount__c * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                        forecast.Weighted_Forecast_Proposal__c+= (a.Weighted_Previous_Quarter_Forecast__c == null ? 0 : a.Weighted_Previous_Quarter_Forecast__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    }
                                }
                            } 
                        } else {
                            if (a.Active__c == false){
                                forecast.Actual_Amount__c+= (a.F_Actual_Amount__c == null? 0 : a.F_Actual_Amount__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                            } else {
                                if (a.Program__r.RecordType.Name == 'Contract'){
                                    forecast.Forecast_Contract__c += a.Forecast_Amount__c * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                } else {
                                    forecast.Forecast_Proposal__c += a.Forecast_Amount__c * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    forecast.Weighted_Forecast_Proposal__c+= (a.Weighted_Forecast_Amount__c == null ? 0 : a.Weighted_Forecast_Amount__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                }
                            }
                        }
                        //break;
                    } else if (a.Ad_Period__r.Is_Split__c == 'true' && forecast.Account__c == a.Program__r.Opportunity__r.Account.Id && forecast.Owner__c == a.Program__r.Opportunity__r.OwnerId && forecast.Account_Type__c == a.Program__r.Opportunity__r.Account.RecordType.Name && forecast.Quarter__c == getNextQuarter(a.Ad_Period__r.Quarter__c) && forecast.Product_Type__c == a.Program__r.Product_Type__c && forecast.Delivery_Type__c == a.Program__r.Delivery_Type__c){
                        //system.debug('***SM2 year split ' + getNextQuarter(a.Ad_Period__r.Quarter__c) + ' - ' + a.F_Next_Quarter_Actual__c + ' - ' + a.Next_Quarter_Amount__c);
                        if ((a.Previous_Quarter_Amount__c == 0 && a.Next_Quarter_Amount__c == 0) || a.Next_Quarter_Amount__c == null){
                           if (a.Active__c == false){
                                if (a.F_Next_Quarter_Actual__c == null && a.F_Previous_Quarter_Actual__c != null){
                                    forecast.Actual_Amount__c += (a.F_Actual_Amount__c - a.F_Previous_Quarter_Actual__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                } else {
                                    forecast.Actual_Amount__c += (a.F_Next_Quarter_Actual__c == null ? (a.F_Actual_Amount__c == null? 0 : a.F_Actual_Amount__c) * a.Next_Quarter_Ratio__c/100 : a.F_Next_Quarter_Actual__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                }
                           } else {
                                if (a.Program__r.RecordType.Name == 'Contract'){
                                    forecast.Forecast_Contract__c += a.Forecast_Amount__c/2 * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                } else {
                                    forecast.Forecast_Proposal__c += a.Forecast_Amount__c/2 * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    forecast.Weighted_Forecast_Proposal__c += (a.Weighted_Forecast_Amount__c == null ? 0: a.Weighted_Forecast_Amount__c) * (ptsMAP.get(a.Program__c) == null? 0 : (ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) == null ? 0 : ptsMAP.get(a.Program__c).get(forecast.Product_Type__c))) / 100;
                                }
                           }
                        }
                        //if split forecasts entered
                        else{
                            if (a.Active__c == false){
                                if (a.F_Next_Quarter_Actual__c == null && a.F_Previous_Quarter_Actual__c != null){
                                    forecast.Actual_Amount__c += (a.F_Actual_Amount__c - a.F_Previous_Quarter_Actual__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                } else {
                                    forecast.Actual_Amount__c += (a.F_Next_Quarter_Actual__c == null ? (a.F_Actual_Amount__c == null? 0 : a.F_Actual_Amount__c) * a.Next_Quarter_Ratio__c/100 : a.F_Next_Quarter_Actual__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                }
                            } else {
                                if (a.Program__r.RecordType.Name == 'Contract'){
                                    forecast.Forecast_Contract__c += a.Next_Quarter_Amount__c * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                } else {
                                    forecast.Forecast_Proposal__c += a.Next_Quarter_Amount__c * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    forecast.Weighted_Forecast_Proposal__c+= (a.Weighted_Next_Quarter_Forecast__c == null ? 0 : a.Weighted_Next_Quarter_Forecast__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                }
                            }
                        } 
                        //break;
                    }
                }
            }
        }
        update sdpySM2;
        
        
        //update SDPY SM2
        userList = new Set<ID>();
        for (SDPY_Sales_Manager_1_Forecast__c a : sdpySM1){
            userList.add(a.OwnerId);
        }
        pf = [SELECT Program__r.RecordType.Name, Program__r.Opportunity__r.Account.Id, Ad_Period__r.Quarter__c, Ad_Period__r.Is_Split__c, Weighted_Forecast_Amount__c,
            Previous_Quarter_Amount__c, Oppty_Probability__c, Next_Quarter_Amount__c, Forecast_Amount__c, Program__r.Opportunity__r.OwnerId, 
            Program__r.Delivery_Type__c, Program__r.Opportunity__r.Account.RecordType.Name,  Weighted_Previous_Quarter_Forecast__c, Program__r.Product_Type__c,
            Weighted_Next_Quarter_Forecast__c, Active__c, Previous_Quarter_Ratio__c,Previous_Quarter_Actual__c, Next_Quarter_Ratio__c, Next_Quarter_Actual__c, Actual_Amount__c, F_Actual_Amount__c, F_Next_Quarter_Actual__c, F_Previous_Quarter_Actual__c 
            FROM Archive_Program_Forecast__c WHERE Id IN :pfList And Program__r.Opportunity__r.OwnerId IN :userList];
        
        for (Archive_Program_Forecast__c a : pf){
            for (SDPY_Sales_Manager_1_Forecast__c forecast: sdpySM1){
                if (forecast.Weighted_Forecast_Proposal__c == null) forecast.Weighted_Forecast_Proposal__c = 0;
                if (forecast.Actual_Amount__c == null) forecast.Actual_Amount__c = 0;
                if (forecast.Forecast_Proposal__c == null) forecast.Forecast_Proposal__c = 0;
                if (forecast.Forecast_Contract__c == null) forecast.Forecast_Contract__c = 0;
                if(ptsMAP.get(a.Program__c).containsKey(forecast.Product_Type__c)){
                    if (forecast.Account__c == a.Program__r.Opportunity__r.Account.Id && forecast.OwnerId == a.Program__r.Opportunity__r.OwnerId && forecast.Account_Type__c == a.Program__r.Opportunity__r.Account.RecordType.Name && forecast.Quarter__c == a.Ad_Period__r.Quarter__c && forecast.Delivery_Type__c == a.Program__r.Delivery_Type__c){
                        //system.debug('***found');
                        if (a.Ad_Period__r.Is_Split__c == 'true'){
                            if ((a.Previous_Quarter_Amount__c == 0 && a.Next_Quarter_Amount__c == 0) || a.Previous_Quarter_Amount__c == null){
                                if (a.Active__c == false){
                                    if (a.F_Previous_Quarter_Actual__c == null && a.F_Next_Quarter_Actual__c != null){
                                        forecast.Actual_Amount__c += (a.F_Actual_Amount__c - a.F_Next_Quarter_Actual__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    } else {
                                        forecast.Actual_Amount__c += (a.F_Previous_Quarter_Actual__c == null ? (a.F_Actual_Amount__c == null? 0 : a.F_Actual_Amount__c) * a.Previous_Quarter_Ratio__c/100 : a.F_Previous_Quarter_Actual__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    }
                                } else {
                                    if (a.Program__r.RecordType.Name == 'Contract'){
                                        forecast.Forecast_Contract__c += a.Forecast_Amount__c/2 * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    } else {
                                        forecast.Forecast_Proposal__c += a.Forecast_Amount__c/2 * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                        forecast.Weighted_Forecast_Proposal__c += (a.Weighted_Forecast_Amount__c == null ? 0: a.Weighted_Forecast_Amount__c)/2 * (ptsMAP.get(a.Program__c) == null? 0 : (ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) == null ? 0 : ptsMAP.get(a.Program__c).get(forecast.Product_Type__c))) / 100;
                                    }
                                }
                            }
                            //if split forecasts entered
                            else{
                                if (a.Active__c == false){
                                    if (a.F_Previous_Quarter_Actual__c == null && a.F_Next_Quarter_Actual__c != null){
                                        forecast.Actual_Amount__c += (a.F_Actual_Amount__c - a.F_Next_Quarter_Actual__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    } else {
                                        forecast.Actual_Amount__c += (a.F_Previous_Quarter_Actual__c == null ? (a.F_Actual_Amount__c == null? 0 : a.F_Actual_Amount__c) * a.Previous_Quarter_Ratio__c/100 : a.F_Previous_Quarter_Actual__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    }
                                } else {
                                    if (a.Program__r.RecordType.Name == 'Contract'){
                                        forecast.Forecast_Contract__c += a.Previous_Quarter_Amount__c * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    } else {
                                        forecast.Forecast_Proposal__c += a.Previous_Quarter_Amount__c * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                        forecast.Weighted_Forecast_Proposal__c+= (a.Weighted_Previous_Quarter_Forecast__c == null ? 0 : a.Weighted_Previous_Quarter_Forecast__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    }
                                }
                            } 
                        } else {
                            if (a.Active__c == false){
                                forecast.Actual_Amount__c+= (a.F_Actual_Amount__c == null? 0 : a.F_Actual_Amount__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                            } else {
                                if (a.Program__r.RecordType.Name == 'Contract'){
                                    forecast.Forecast_Contract__c += a.Forecast_Amount__c * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                } else {
                                    forecast.Forecast_Proposal__c += a.Forecast_Amount__c * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    forecast.Weighted_Forecast_Proposal__c+= (a.Weighted_Forecast_Amount__c == null ? 0 : a.Weighted_Forecast_Amount__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                }
                            }
                        }
                        //break;
                    } else if (a.Ad_Period__r.Is_Split__c == 'true' && forecast.Account__c == a.Program__r.Opportunity__r.Account.Id && forecast.OwnerId == a.Program__r.Opportunity__r.OwnerId && forecast.Account_Type__c == a.Program__r.Opportunity__r.Account.RecordType.Name && forecast.Quarter__c == getNextQuarter(a.Ad_Period__r.Quarter__c) && forecast.Product_Type__c == a.Program__r.Product_Type__c && forecast.Delivery_Type__c == a.Program__r.Delivery_Type__c){
                        //system.debug('***SM2 year split ' + getNextQuarter(a.Ad_Period__r.Quarter__c) + ' - ' + a.F_Next_Quarter_Actual__c + ' - ' + a.Next_Quarter_Amount__c);
                        if ((a.Previous_Quarter_Amount__c == 0 && a.Next_Quarter_Amount__c == 0) || a.Next_Quarter_Amount__c == null){
                           if (a.Active__c == false){
                                if (a.F_Next_Quarter_Actual__c == null && a.F_Previous_Quarter_Actual__c != null){
                                    forecast.Actual_Amount__c += (a.F_Actual_Amount__c - a.F_Previous_Quarter_Actual__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                } else {
                                    forecast.Actual_Amount__c += (a.F_Next_Quarter_Actual__c == null ? (a.F_Actual_Amount__c == null? 0 : a.F_Actual_Amount__c) * a.Next_Quarter_Ratio__c/100 : a.F_Next_Quarter_Actual__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                }
                           } else {
                                if (a.Program__r.RecordType.Name == 'Contract'){
                                    forecast.Forecast_Contract__c += a.Forecast_Amount__c/2 * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                } else {
                                    forecast.Forecast_Proposal__c += a.Forecast_Amount__c/2 * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    forecast.Weighted_Forecast_Proposal__c += (a.Weighted_Forecast_Amount__c == null ? 0: a.Weighted_Forecast_Amount__c) * (ptsMAP.get(a.Program__c) == null? 0 : (ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) == null ? 0 : ptsMAP.get(a.Program__c).get(forecast.Product_Type__c))) / 100;
                                }
                           }
                        }
                        //if split forecasts entered
                        else{
                            if (a.Active__c == false){
                                if (a.F_Next_Quarter_Actual__c == null && a.F_Previous_Quarter_Actual__c != null){
                                    forecast.Actual_Amount__c += (a.F_Actual_Amount__c - a.F_Previous_Quarter_Actual__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                } else {
                                    forecast.Actual_Amount__c += (a.F_Next_Quarter_Actual__c == null ? (a.F_Actual_Amount__c == null? 0 : a.F_Actual_Amount__c) * a.Next_Quarter_Ratio__c/100 : a.F_Next_Quarter_Actual__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                }
                            } else {
                                if (a.Program__r.RecordType.Name == 'Contract'){
                                    forecast.Forecast_Contract__c += a.Next_Quarter_Amount__c * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                } else {
                                    forecast.Forecast_Proposal__c += a.Next_Quarter_Amount__c * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                    forecast.Weighted_Forecast_Proposal__c+= (a.Weighted_Next_Quarter_Forecast__c == null ? 0 : a.Weighted_Next_Quarter_Forecast__c) * ptsMAP.get(a.Program__c).get(forecast.Product_Type__c) / 100;
                                }
                            }
                        } 
                        //break;
                    }
                }
            }
        }
        update sdpySM1;
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
        BatchCalculateBestGuess acctBatch2Sched = new BatchCalculateBestGuess();
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
                    a.Weighted_Forecast_Proposal__c = 0;
                    a.Forecast_Contract__c = 0;
                    a.Forecast_Proposal__c = 0;
                    a.Actual_Amount__c = 0;
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
        
        rep2 = [Select r.SDPY_Forecast__c, r.Quarter__c, r.Quarter_Start_Date__c, r.Quarter_End_Date__c, r.Product_Type__c, r.OwnerId, r.Name, r.Manager__c, r.Manager_Forecast__c, r.Id, r.Forecast_Proposal__c, r.Weighted_Forecast_Proposal__c, r.Forecast_Contract__c, r.Delivery_Type__c, r.Actual_Amount__c, r.Account__c, r.Account_Type__c From Rep_2_Forecast__c r WHERE r.Account__c IN :accountList];
        rep1 = [Select r.SDPY_Forecast__c, r.Quarter__c, r.Quarter_Start_Date__c, r.Quarter_End_Date__c, r.Product_Type__c, r.OwnerId, r.Name, r.Manager__c, r.Manager_Forecast__c, r.Id, r.Forecast_Proposal__c, r.Weighted_Forecast_Proposal__c, r.Forecast_Contract__c, r.Delivery_Type__c, r.Actual_Amount__c, r.Account__c, r.Account_Type__c From Rep_1_Forecast__c r WHERE r.Account__c IN :accountList];
        sm2 = [Select r.SDPY_Forecast__c, r.Quarter__c, r.Quarter_Start_Date__c, r.Quarter_End_Date__c, r.Product_Type__c, r.OwnerId, r.Name, r.Manager__c, r.Manager_Forecast__c, r.Id, r.Forecast_Proposal__c, r.Weighted_Forecast_Proposal__c, r.Forecast_Contract__c, r.Delivery_Type__c, r.Actual_Amount__c, r.Account__c, r.Account_Type__c From Sales_Manager_2_Forecast__c r WHERE r.Account__c IN :accountList];
        sm1 = [Select r.SDPY_Forecast__c, r.Quarter__c, r.Quarter_Start_Date__c, r.Quarter_End_Date__c, r.Product_Type__c, r.OwnerId, r.Name, r.Manager__c, r.Manager_Forecast__c, r.Id, r.Forecast_Proposal__c, r.Weighted_Forecast_Proposal__c, r.Forecast_Contract__c, r.Delivery_Type__c, r.Actual_Amount__c, r.Account__c, r.Account_Type__c From Sales_Manager_1_Forecast__c r WHERE r.Account__c IN :accountList];
        sdpyRep2 = [Select  r.Quarter__c, r.Quarter_Start_Date__c, r.Quarter_End_Date__c, r.Product_Type__c, r.Owner__c, r.Name, r.Manager__c, r.Manager_Forecast__c, r.Id, r.Forecast_Proposal__c, r.Weighted_Forecast_Proposal__c, r.Forecast_Contract__c, r.Delivery_Type__c, r.Actual_Amount__c, r.Account__c, r.Account_Type__c From SDPY_Rep_2_Forecast__c r WHERE r.Account__c IN :accountList AND r.Manager_Forecast__r.Manager_Forecast__r.Manager_Forecast__r.OwnerId != null];
        sdpyRep1 = [Select  r.Quarter__c, r.Quarter_Start_Date__c, r.Quarter_End_Date__c, r.Product_Type__c, r.Owner__c, r.Name, r.Manager__c, r.Manager_Forecast__c, r.Id, r.Forecast_Proposal__c, r.Weighted_Forecast_Proposal__c, r.Forecast_Contract__c, r.Delivery_Type__c, r.Actual_Amount__c, r.Account__c, r.Account_Type__c From SDPY_Rep_1_Forecast__c r WHERE r.Account__c IN :accountList AND r.Manager_Forecast__r.Manager_Forecast__r.OwnerId != null];
        sdpySM2 = [Select  r.Quarter__c, r.Quarter_Start_Date__c, r.Quarter_End_Date__c, r.Product_Type__c, r.Owner__c, r.Name, r.Manager__c, r.Manager_Forecast__c, r.Id, r.Forecast_Proposal__c, r.Weighted_Forecast_Proposal__c, r.Forecast_Contract__c, r.Delivery_Type__c, r.Actual_Amount__c, r.Account__c, r.Account_Type__c From SDPY_Sales_Manager_2_Forecast__c r WHERE r.Account__c IN :accountList AND r.Manager_Forecast__r.OwnerId != null];
        sdpySM1 = [Select  r.Quarter__c, r.Quarter_Start_Date__c, r.Quarter_End_Date__c, r.Product_Type__c, r.OwnerId, r.Name, r.Manager__c, r.Manager_Forecast__c, r.Id, r.Forecast_Proposal__c, r.Weighted_Forecast_Proposal__c, r.Forecast_Contract__c, r.Delivery_Type__c, r.Actual_Amount__c, r.Account__c, r.Account_Type__c From SDPY_Sales_Manager_1_Forecast__c r WHERE r.Account__c IN :accountList];
        
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
    
    private void getUniquePairs(List<Archive_Program_Forecast__c> pF12){
        
        for (Archive_Program_Forecast__c a : pF12){
            if (a.Program__r.Product_Type__c == null){
                if (!uniquePairs.contains(a.Program__r.Opportunity__r.OwnerId + '-'+ getNY(a.Ad_Period__r.Quarter__c) + '-' +a.Program__r.Opportunity__r.Account.Id + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + '')){
                uniquePairs.add(a.Program__r.Opportunity__r.OwnerId + '-'+ getNY(a.Ad_Period__r.Quarter__c) + '-' +a.Program__r.Opportunity__r.Account.Id  + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + '');
                }
                if (a.Ad_Period__r.Is_Split__c == 'true'){
                    if (!uniquePairs.contains(a.Program__r.Opportunity__r.OwnerId + '-'+ getNY(getNextQuarter(a.Ad_Period__r.Quarter__c)) + '-' +a.Program__r.Opportunity__r.Account.Id  + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + '')){
                        uniquePairs.add(a.Program__r.Opportunity__r.OwnerId + '-'+ getNY(getNextQuarter(a.Ad_Period__r.Quarter__c)) + '-' +a.Program__r.Opportunity__r.Account.Id  + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + '');
                    }           
                }   
            } else {
                for (String x : a.Program__r.Product_Type__c.split(';')){
                    if (!uniquePairs.contains(a.Program__r.Opportunity__r.OwnerId + '-'+ getNY(a.Ad_Period__r.Quarter__c) + '-' +a.Program__r.Opportunity__r.Account.Id + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + x)){
                    uniquePairs.add(a.Program__r.Opportunity__r.OwnerId + '-'+ getNY(a.Ad_Period__r.Quarter__c) + '-' +a.Program__r.Opportunity__r.Account.Id  + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + x);
                    }
                    if (a.Ad_Period__r.Is_Split__c == 'true'){
                        if (!uniquePairs.contains(a.Program__r.Opportunity__r.OwnerId + '-'+ getNY(getNextQuarter(a.Ad_Period__r.Quarter__c)) + '-' +a.Program__r.Opportunity__r.Account.Id  + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + x)){
                            uniquePairs.add(a.Program__r.Opportunity__r.OwnerId + '-'+ getNY(getNextQuarter(a.Ad_Period__r.Quarter__c)) + '-' +a.Program__r.Opportunity__r.Account.Id  + '-' + a.Program__r.Opportunity__r.Account.RecordType.Name + '-' + a.Program__r.Delivery_Type__c + '-' + x);
                        }           
                    }
                }
            }
        }
        
    }

}