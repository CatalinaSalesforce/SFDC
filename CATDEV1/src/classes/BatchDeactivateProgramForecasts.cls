/*
@Name           :       BatchDeactivateProgramForecasts
@Author         :       Warren
@Date           :       Jan 6 2012
@Description    :       Batch class designed to:
                            a.) Set Program Forecasts to active/inactive
Oct 9 2013 - change what class is scheduled next as a part of the redesign
*/

global class BatchDeactivateProgramForecasts implements Database.Batchable<sObject>, Schedulable{
    
    Final String FORECAST_SETTING_NAME = 'Default';
    String query;
    String limit1;
    //Set<ID> accountList;
    Set<ID> programList;
    Map<Id, Map<String, Double>> ptsMAP;

    public BatchDeactivateProgramForecasts (String x){
        limit1 = x;
    }
    
    public BatchDeactivateProgramForecasts (){
        limit1 = '';
    }
    
    global void execute(SchedulableContext ctx) {
        BatchDeactivateProgramForecasts batch1 = new BatchDeactivateProgramForecasts();
        ID batchprocessid = Database.executeBatch(batch1);
    }
    
    //method that gets the query used for this batch
    global Database.querylocator start(Database.BatchableContext BC){
        BatchGovernorLimitUtility.insertBatchRun('BatchDeactivateProgramForecasts');   
        
        Best_Guess_Settings__c BGSettings = Best_Guess_Settings__c.getOrgDefaults();
		BGSettings.Batch_Use_Trigger__c = true;
		upsert BGSettings;     
    
        query = 'Select Id, Ad_Period__r.End_Date__c, Active__c, Program__r.Id, Program__r.Opportunity__r.Id, ' 
            + ' Program__r.Opportunity__r.Catalina_Business_Unit__c, Program__r.Delivery_Type__c'
            + ' From Program_Forecast__c ' 
            + ' WHERE PROGRAM__R.OPPORTUNITY__R.ACCOUNTID <> NULL '
            + ' AND (PROGRAM__R.OPPORTUNITY__R.RECORDTYPE.NAME = \'CONTRACT\' OR PROGRAM__R.OPPORTUNITY__R.RECORDTYPE.NAME = \'PROPOSAL\' OR PROGRAM__R.OPPORTUNITY__R.RECORDTYPE.NAME = \'RECOVERY\' OR PROGRAM__R.OPPORTUNITY__R.RECORDTYPE.NAME = \'RENEWAL\') '
            + limit1;
        return Database.getQueryLocator(query);
    }
    
    //method that makes up the body of the batch process
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        Datetime currentTime = System.now();
        Date     ForecastToActualTransitionDate;
       

        //12-04-2012 - use the number of days past enddate on ad period from custom setting to set active
        //set the default value to 2
        integer ForecastToActualTransition = 2;
        // this is only for Audience network Forecast to actual transition gap
        integer FATransition_AudienceNetwork = 2;
        
        //assign the custom setting provided value if it exists
        Catalina_Forecast_Settings__c setting = Catalina_Forecast_Settings__c.getInstance(FORECAST_SETTING_NAME);
      
      
        if(!(setting == null)){
            if(!(setting.Forecast_to_Actual_Transition__c == null)){
                ForecastToActualTransition = (integer)setting.Forecast_to_Actual_Transition__c;
            }
            if(setting.Forecast_to_Actual_AudienceNetwork__c!= null){
                FATransition_AudienceNetwork = (Integer)setting.Forecast_to_Actual_AudienceNetwork__c;
            }
        }
        
        //compare each Program Forecast Ad Period to the predetermined lag time and update
        List<Program_Forecast__c> pfScope = (List<Program_Forecast__c>)scope;
        
        for (Program_Forecast__c a : pfScope){
        
        System.debug('Delivery Channnel is ************' + a.Program__r.Opportunity__r.Catalina_Business_Unit__c);
       
        
        Date AdEndDate = a.Ad_Period__r.End_Date__c;
 
        if(a.Program__r.Delivery_Type__c=='Audience Network' /*&& AdEndDate != Date.newInstance(2013,12,1)*/){
         
            ForecastToActualTransitionDate = AdEndDate.addMonths(1).toStartOfMonth().addDays(FATransition_AudienceNetwork);
            System.debug(AdEndDate.addMonths(1).toStartOfMonth().addDays(FATransition_AudienceNetwork));
        
        
        }else{
        
           ForecastToActualTransitionDate = a.Ad_Period__r.End_Date__c + ForecastToActualTransition;
        
        }
        if (ForecastToActualTransitionDate <= Date.Today()){
                a.Active__c = false;
                system.debug('***deactivate - ' + a.Id + ', Program: ' + a.Program__r.Id + ', Oppty: ' + a.Program__r.Opportunity__r);
            } else {
                a.Active__c = true;
                system.debug('***activate - ' + a.Id + ', Program: ' + a.Program__r.Id + ', Oppty: ' + a.Program__r.Opportunity__r);
            }
        }
        update pfScope;
        /*
        //check to see if Programs are missing Product Types, assign default "NA" for later in batch process
        Set<Id> missingPTSList = new Set<Id>();
        programList = new Set<Id>();
        ptsMAP = new Map<Id, Map<String, Double>>();
        for (Program_Forecast__c a: pfScope){
            //accountList.add(a.Program__r.Opportunity__r.Account.Id);
            programList.add(a.Program__c);
        }
        
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
*/
     BatchGovernorLimitUtility.calcualteLimits(Limits.getCpuTime(), Limits.getDMLRows(), Limits.getDMLStatements(), Limits.getHeapSize(), Limits.getQueries(), Limits.getQueryRows(), Limits.getScriptStatements(), scope, currentTime, System.now());
    }
    
    //method that runs after the execute() method
    global void finish(Database.BatchableContext BC){                    
        System.debug(LoggingLevel.WARN,'Scheduling BatchCreateBGShell');
        Best_Guess_Settings__c BGSettings = Best_Guess_Settings__c.getOrgDefaults();
		BGSettings.Batch_Use_Trigger__c = false;
		upsert BGSettings;
       //Build the system time of now + 20 seconds to schedule the batch apex.
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        BatchCreateBGShell acctBatch2Sched = new BatchCreateBGShell(); 
        /* by Ajith 10/24*/
        //Schedule the next job, and give it the system time so name is unique
        sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        BatchCreateAccountBG acctBatch2Sched2 = new BatchCreateAccountBG();
        
        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
        System.schedule('acctBatch2Job2' + sysTime.getTime(),chron_exp,acctBatch2Sched2);
        
        BatchGovernorLimitUtility.updateBatchRun();
      
    }

}