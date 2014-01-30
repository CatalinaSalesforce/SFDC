/*
@Name           : BatchEuropeProgramCycleAmount
@Author         : customersuccess@cloud62.com
@Date           : 4/15/2013
@Description    : This class looks at all Program Forecasts for Europe and aggregates the totals by Program and Cycle for reporting
*/
global class BatchEuropeProgramCycleAmount implements Database.Batchable<sObject>, Schedulable{

    //declare variables
    String query;
    String limit1;
    
    public BatchEuropeProgramCycleAmount(String x){
        limit1 = x;
    }
    
    public BatchEuropeProgramCycleAmount(){
        limit1 = '';
    }
    
    global void execute(SchedulableContext ctx) {
        BatchEuropeProgramCycleAmount batch1 = new BatchEuropeProgramCycleAmount();
        ID batchprocessid = Database.executeBatch(batch1, 200);
    }
    
    global Database.querylocator start(Database.BatchableContext BC){

        query = 'SELECT Active__c, Program__r.RecordType.Name, Actual_Amount__c, Program__r.Product_Type__c, Program__r.Opportunity__r.Account.Id, Weighted_Forecast_Amount__c, Oppty_Probability__c, Forecast_Amount__c, Program__r.Opportunity__r.OwnerId, Program__r.Delivery_Type__c, Program__r.Opportunity__r.Account.RecordType.Name,'
        + 'Program__r.Account_Type__c, Ad_Period__c, Program__r.Opportunity__r.RecordType.Name, '
        + ' Actual_Formula__c '
        + ' From Program_Forecast__c '
        + ' Where PROGRAM__R.OPPORTUNITY__R.ISDELETED = FALSE AND PROGRAM__R.OPPORTUNITY__R.ACCOUNTID != NULL '
        + ' AND PROGRAM__R.OPPORTUNITY__R.RECORDTYPE.NAME IN (\'CONTRACT FRANCE\',\'PROPOSAL FRANCE\',\'CONTRACT GERMANY\',\'PROPOSAL GERMANY\',\'CONTRACT ITALY\',\'PROPOSAL ITALY\',\'RENEWALS ITALY\',\'RENEWALS FRANCE\',\'RENEWALS GERMANY\') '
        + ' ORDER BY Program__r.Opportunity__r.OwnerId, Program__c, Ad_Period__c ' + limit1;
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        List<Program_Forecast__c> pfScope = (List<Program_Forecast__c>)scope;
        Set<Id> progList = new Set<Id>();
        for (Program_Forecast__c pf : pfScope){
            progList.add(pf.Program__c);
        }
        List<Program_Cycle_Amount__c> insertPA = new List<Program_Cycle_Amount__c>();
        //get PCA records that already exist
        List<Program_Cycle_Amount__c> currentPA = [SELECT ID, NAME, PROGRAM__C, ACTUAL_AMOUNT__C, FORECAST_CONTRACT__C,
                                                    FORECAST_PROPOSAL__C, Cycle__c
                                                    FROM Program_Cycle_Amount__c
                                                    WHERE PROGRAM__C IN :progList];
        
        //put records into a map
        Map<Id, Map<String, Program_Cycle_Amount__c>> paMap = new Map<Id, Map<String, Program_Cycle_Amount__c>>();
        for (Program_Cycle_Amount__c pa : currentPA){
            if (!paMap.containsKey(pa.Program__c)){
                paMap.put(pa.Program__c, new Map<String, Program_Cycle_Amount__c>());
            }

            if (!paMap.get(pa.Program__c).containsKey(pa.Cycle__c)){
                paMap.get(pa.Program__c).put(pa.Cycle__c, pa);
            }

        } 
        
        //create records for PFs that are in scope and do not have a PCA record
        for (Program_Forecast__c pf : pfScope){
            if (!paMap.containsKey(pf.Program__c)){
                paMap.put(pf.Program__c, new Map<String, Program_Cycle_Amount__c>());
            }
            if (!paMap.get(pf.Program__c).containsKey(pf.Ad_Period__c)){
                Program_Cycle_Amount__c newPA = createPA(pf.Program__c, pf.Ad_Period__c);
                insertPA.add(newPA);
                paMap.get(pf.Program__c).put(pf.Ad_Period__c, newPA);
            }
        }
        
        insert insertPA;
        
        //requery and put values into a map
        currentPA = [SELECT ID, NAME, PROGRAM__C, ACTUAL_AMOUNT__C, FORECAST_CONTRACT__C,
            FORECAST_PROPOSAL__C, Cycle__c
            FROM Program_Cycle_Amount__c
            WHERE PROGRAM__C IN :progList];
        paMap = new Map<Id, Map<String, Program_Cycle_Amount__c>>();
        for (Program_Cycle_Amount__c pa : currentPA){
            if (pa.Actual_Amount__c == null) pa.Actual_Amount__c = 0;
            if (pa.Forecast_Contract__c == null) pa.Forecast_Contract__c = 0;
            if (pa.Forecast_Proposal__c == null) pa.Forecast_Proposal__c = 0;
            if (!paMap.containsKey(pa.Program__c)){
                paMap.put(pa.Program__c, new Map<String, Program_Cycle_Amount__c>());
            }

            if (!paMap.get(pa.Program__c).containsKey(pa.Cycle__c)){
                paMap.get(pa.Program__c).put(pa.Cycle__c, pa);
            }

        } 
        
        //increment PCA records
        for (Program_Forecast__c pf : pfScope){
                if (paMap.containsKey(pf.Program__c)){
                    if (paMap.get(pf.Program__c).containsKey(pf.Ad_Period__c)){
                        Program_Cycle_Amount__c tempPA = paMap.get(pf.Program__c).get(pf.Ad_Period__c);
                        if (pf.Active__c == false){
                            tempPA.Actual_Amount__c += (pf.Actual_Formula__c == null ? 0 : pf.Actual_Formula__c);
                        } else if (pf.Program__r.Opportunity__r.RecordType.Name.contains('Contract')){
                            tempPA.Forecast_Contract__c += (pf.Forecast_Amount__c == null? 0 : pf.Forecast_Amount__c); 
                        } else {
                            tempPA.Forecast_Proposal__c += (pf.Forecast_Amount__c == null? 0 : pf.Forecast_Amount__c); 
                        }
                    }
                }
            
        }
        
        update currentPA;
    }
    
    global void finish(Database.BatchableContext BC){
    
        System.debug(LoggingLevel.WARN,'Temp_Delete_DeleteSM1Forecast');
        //Build the system time of now + 20 seconds to schedule the batch apex.
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        BatchEuropeAssociateProgramCycleFY acctBatch2Sched = new BatchEuropeAssociateProgramCycleFY();
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
    }
    
    /*
    create a Program Cycle Amount record for a given cycle and program
    */
    private Program_Cycle_Amount__c createPA(String progID, String cycleID){
        Program_Cycle_Amount__c newPA = new Program_Cycle_Amount__c();
        newPA.Program__c = progID;
        newPA.Cycle__c = cycleID;
        newPA.CurrencyIsoCode = 'EUR';
        return newPA;
    }
}