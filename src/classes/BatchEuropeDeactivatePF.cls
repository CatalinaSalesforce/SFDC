/*
@Name           : BatchEuropeDeactivatePF
@Author         : customersuccess@cloud62.com
@Date           : 4/15/2013
@Description    : This class goes through all the Progam Forecasts and sets the status to Active or Inactive based on the run date (today)
                  It also creates Product Type Splits when the Product Type is specified at the Program level. If none is specified (NA) it sets the Product Type split to 100%
*/

global class BatchEuropeDeactivatePF implements Database.Batchable<sObject>, Schedulable{
    
    String query;
    String limit1;
    //Set<ID> accountList;
    Set<ID> programList;
    Map<Id, Map<String, Double>> ptsMAP;

    public BatchEuropeDeactivatePF (String x){
        limit1 = x;
    }
    
    public BatchEuropeDeactivatePF (){
        limit1 = '';
    }
    
    global void execute(SchedulableContext ctx) {
        BatchEuropeDeactivatePF batch1 = new BatchEuropeDeactivatePF();
        ID batchprocessid = Database.executeBatch(batch1);
    }
    
    //method that gets the query used for this batch
    global Database.querylocator start(Database.BatchableContext BC){
        query = 'Select Id, Ad_Period__r.End_Date__c, Active__c, Program__r.Id, Program__r.Opportunity__r.Id ' +
            ' From Program_Forecast__c ' 
            + 'WHERE PROGRAM__R.OPPORTUNITY__R.ACCOUNTID <> NULL '
            + ' AND (PROGRAM__R.OPPORTUNITY__R.RECORDTYPE.NAME = \'CONTRACT FRANCE\' OR PROGRAM__R.OPPORTUNITY__R.RECORDTYPE.NAME = \'PROPOSAL FRANCE\' '
            + ' OR PROGRAM__R.OPPORTUNITY__R.RECORDTYPE.NAME = \'CONTRACT GERMANY\' OR PROGRAM__R.OPPORTUNITY__R.RECORDTYPE.NAME = \'PROPOSAL GERMANY\' '
            + ' OR PROGRAM__R.OPPORTUNITY__R.RECORDTYPE.NAME = \'CONTRACT ITALY\' OR PROGRAM__R.OPPORTUNITY__R.RECORDTYPE.NAME = \'PROPOSAL ITALY\') '
            + limit1;
        return Database.getQueryLocator(query);
    }
    
    //method that makes up the body of the batch process
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        List<Program_Forecast__c> pfScope = (List<Program_Forecast__c>)scope;
        
        //set PFs to Active or Inactive by Ad Period End Date
        for (Program_Forecast__c a : pfScope){
            if (a.Ad_Period__r.End_Date__c + 2 <= Date.Today()){
                a.Active__c = false;
                system.debug('***deactivate - ' + a.Id + ', Program: ' + a.Program__r.Id + ', Oppty: ' + a.Program__r.Opportunity__r);
            } else {
                a.Active__c = true;
                system.debug('***activate - ' + a.Id + ', Program: ' + a.Program__r.Id + ', Oppty: ' + a.Program__r.Opportunity__r);
            }
        }
        update pfScope;
        
        //insert product type splits where they are missing
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
    }
    
    //method that runs after the execute() method
    global void finish(Database.BatchableContext BC){            
        System.debug(LoggingLevel.WARN,'Temp_Delete_DeleteSM1Forecast');
        //Build the system time of now + 20 seconds to schedule the batch apex.
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        BatchEuropeDeleteReportingOpps acctBatch2Sched = new BatchEuropeDeleteReportingOpps();
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
    }
}