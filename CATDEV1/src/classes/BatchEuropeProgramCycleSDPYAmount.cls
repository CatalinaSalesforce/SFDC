/*
@Name           : BatchEuropeDeactivatePF
@Author         : customersuccess@cloud62.com
@Date           : 4/15/2013
@Description    : This class looks at all Program Forecasts for Europe and aggregates the totals by Program and Cycle for reporting
*/
global class BatchEuropeProgramCycleSDPYAmount implements Database.Batchable<sObject>, Schedulable{
    
    //declare variables
    String query;
    String limit1;
    
    public BatchEuropeProgramCycleSDPYAmount(String x){
        limit1 = x;
    }
    
    public BatchEuropeProgramCycleSDPYAmount(){
        limit1 = '';
    }
    
    global void execute(SchedulableContext ctx) {
        BatchEuropeProgramCycleSDPYAmount batch1 = new BatchEuropeProgramCycleSDPYAmount();
        ID batchprocessid = Database.executeBatch(batch1, 200);
    }
    
    global Database.querylocator start(Database.BatchableContext BC){
        Date archiveDate = Date.Today();
        
        Date lastyear = Date.Today().addYears(-1);
        //changed by Warren to 25
        Date lastyear1 = lastyear.addDays(25);
        Date lastyear2 = lastyear.addDays(-25);
         
        //get closest before and after dates to see which SDPY value to use
        AggregateResult ar = [Select Max(Archive_Date__c) Expr1 From Archive_Program__c Where Archive_Date__c <= :lastyear and Archive_Date__c >= :lastyear2 AND
            (OPPORTUNITY__R.RECORDTYPE.NAME = 'CONTRACT FRANCE' OR OPPORTUNITY__R.RECORDTYPE.NAME = 'PROPOSAL FRANCE' 
             OR OPPORTUNITY__R.RECORDTYPE.NAME = 'CONTRACT GERMANY' OR OPPORTUNITY__R.RECORDTYPE.NAME = 'PROPOSAL GERMANY' 
             OR OPPORTUNITY__R.RECORDTYPE.NAME = 'CONTRACT ITALY' OR OPPORTUNITY__R.RECORDTYPE.NAME = 'PROPOSAL ITALY')];
        
        AggregateResult ar2 = [Select Min(Archive_Date__c) Expr2 From Archive_Program__c Where Archive_Date__c >= :lastyear and Archive_Date__c <= :lastyear1
            AND (OPPORTUNITY__R.RECORDTYPE.NAME = 'CONTRACT FRANCE' OR OPPORTUNITY__R.RECORDTYPE.NAME = 'PROPOSAL FRANCE' 
                 OR OPPORTUNITY__R.RECORDTYPE.NAME = 'CONTRACT GERMANY' OR OPPORTUNITY__R.RECORDTYPE.NAME = 'PROPOSAL GERMANY' 
                 OR OPPORTUNITY__R.RECORDTYPE.NAME = 'CONTRACT ITALY' OR OPPORTUNITY__R.RECORDTYPE.NAME = 'PROPOSAL ITALY')];
         
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
        
        //get all archive program forecasts where the archive data is the nearest from today last year   
        query = 'SELECT Active__c, Program__r.RecordType.Name, Actual_Amount__c, Program__r.Product_Type__c, Program__r.Opportunity__r.Account.Id, Ad_Period__r.Is_Split__c, Weighted_Forecast_Amount__c, Oppty_Probability__c, Forecast_Amount__c, Program__r.Opportunity__r.OwnerId, Program__r.Delivery_Type__c, Program__r.Opportunity__r.Account.RecordType.Name,'
        + 'Program__r.Account_Type__c, '
        + 'Program__r.Opportunity__r.RecordType.Name, Program__r.Opportunity__c '
        + ' From Archive_Program_Forecast__c '
        + ' Where PROGRAM__R.OPPORTUNITY__R.ISDELETED = FALSE AND PROGRAM__R.OPPORTUNITY__R.ACCOUNTID != NULL '
        + ' AND Archive_Date__c = ' + archiveDate.year() + '-' + (archiveDate.month() < 10 ? '0' + String.valueOf(archiveDate.month()) : String.valueOf(archiveDate.month())) + '-' + (archiveDate.day() < 10 ? '0' + String.valueOf(archiveDate.day()) : String.valueOf(archiveDate.day()))
        + ' AND PROGRAM__R.OPPORTUNITY__R.RECORDTYPE.NAME IN (\'CONTRACT FRANCE\',\'PROPOSAL FRANCE\',\'CONTRACT GERMANY\',\'PROPOSAL GERMANY\',\'CONTRACT ITALY\',\'PROPOSAL ITALY\',\'RENEWALS ITALY\',\'RENEWALS FRANCE\',\'RENEWALS GERMANY\') '
        + ' ORDER BY Program__r.Opportunity__r.OwnerId, Program__c, Ad_Period__c ' + limit1;
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        List<Archive_Program_Forecast__c> pfScope = (List<Archive_Program_Forecast__c>)scope;
        Set<Id> progList = new Set<Id>();
        Set<Id> oppList = new Set<Id>();
        Map<String, String> archiveMap = new Map<String,String>();
        Map<Id, Map<String, Id>> oppProgMap = new Map<Id, Map<String, Id>>();
        for (Archive_Program_Forecast__c pf : pfScope){
            oppList.add(pf.Program__r.Opportunity__c);
        }
        
        //put current programs in a map
        for (Program__c prog : [SELECT ID, OPPORTUNITY__C, DELIVERY_TYPE__C
                FROM PROGRAM__C WHERE OPPORTUNITY__C IN : oppList])
        {
            if (!oppProgMap.containsKey(prog.Opportunity__c)){
                oppProgMap.put(prog.Opportunity__c, new Map<String, Id>());
            }
            if (!oppProgMap.get(prog.Opportunity__c).containsKey(prog.Delivery_Type__c)){
                oppProgMap.get(prog.Opportunity__c).put(prog.Delivery_Type__c, prog.Id);
            }
        }
        
        //put the archive programs in a map with programs for easy retrieval later
        for (Archive_Program_Forecast__c pf : pfScope){
            if (!archiveMap.containsKey(pf.Program__c)){
                if (oppProgMap.containsKey(pf.Program__r.Opportunity__c)){
                    if (oppProgMap.get(pf.Program__r.Opportunity__c).containsKey(pf.Program__r.Delivery_Type__c)){
                        archiveMap.put(pf.Program__c, oppProgMap.get(pf.Program__r.Opportunity__c).get(pf.Program__r.Delivery_Type__c));
                    }
                }
            }
            if (archiveMap.containsKey(pf.Program__c)) progList.add(archiveMap.get(pf.Program__c));
        }
        
        //get the records that were already created and put it into a map
        List<Program_Cycle_SDPY_Amount__c> insertPA = new List<Program_Cycle_SDPY_Amount__c>();
        List<Program_Cycle_SDPY_Amount__c> currentPA = [SELECT ID, NAME, PROGRAM__C, ACTUAL_AMOUNT__C, 
                                                        FORECAST_CONTRACT__C, FORECAST_PROPOSAL__C, Cycle__c
                                                        FROM Program_Cycle_SDPY_Amount__c
                                                        WHERE PROGRAM__C IN :progList];
        Map<Id, Map<String, Program_Cycle_SDPY_Amount__c>> paMap = new Map<Id, Map<String, Program_Cycle_SDPY_Amount__c>>();
        for (Program_Cycle_SDPY_Amount__c pa : currentPA){
            if (!paMap.containsKey(pa.Program__c)){
                paMap.put(pa.Program__c, new Map<String, Program_Cycle_SDPY_Amount__c>());
            }
            if (!paMap.get(pa.Program__c).containsKey(pa.Cycle__c)){
                paMap.get(pa.Program__c).put(pa.Cycle__c, pa);
            }

        }
        
        //look at the scope records, create new PCSA records if necessary and insert
        for (Archive_Program_Forecast__c pf : pfScope){
            String currentProgram  = archiveMap.get(pf.Program__c);
            if (currentProgram != null){
                if (!paMap.containsKey(currentProgram)){
                    paMap.put(currentProgram, new Map<String, Program_Cycle_SDPY_Amount__c>());
                }
                if (!paMap.get(currentProgram).containsKey(pf.Ad_Period__c)){
                    Program_Cycle_SDPY_Amount__c newPA = createPA(currentProgram, string.valueof(pf.Ad_Period__c));
                    insertPA.add(newPA);
                    paMap.get(currentProgram).put(pf.Ad_Period__c, newPA);
                }
            }
        }
        
        insert insertPA;
        
        //requery the PCSA records and put in map for incrementing
        currentPA = [SELECT ID, NAME, PROGRAM__C, ACTUAL_AMOUNT__C, FORECAST_CONTRACT__C, 
                     FORECAST_PROPOSAL__C, Cycle__c
                     FROM Program_Cycle_SDPY_Amount__c
                     WHERE PROGRAM__C IN :progList];
        paMap = new Map<Id, Map<String, Program_Cycle_SDPY_Amount__c>>();
        
        for (Program_Cycle_SDPY_Amount__c pa : currentPA){
            if (pa.Actual_Amount__c == null) pa.Actual_Amount__c = 0;
            if (pa.Forecast_Contract__c == null) pa.Forecast_Contract__c = 0;
            if (pa.Forecast_Proposal__c == null) pa.Forecast_Proposal__c = 0;
            if (!paMap.containsKey(pa.Program__c)){
                paMap.put(pa.Program__c, new Map<String, Program_Cycle_SDPY_Amount__c>());
            }
            if (!paMap.get(pa.Program__c).containsKey(pa.Cycle__c)){
                paMap.get(pa.Program__c).put(pa.Cycle__c, pa);
            }
        } 
        
        //take all scope records and increment the PCSA records
        for (Archive_Program_Forecast__c pf : pfScope){
            String currentProgram  = archiveMap.get(pf.Program__c);
            if (paMap.containsKey(currentProgram)){
                if (paMap.get(currentProgram).containsKey(pf.Ad_Period__c)){
                    Program_Cycle_SDPY_Amount__c tempPA = paMap.get(currentProgram).get(pf.Ad_Period__c);
                    if (pf.Active__c == false){
                        tempPA.Actual_Amount__c += (pf.Actual_Amount__c == null ? 0 : pf.Actual_Amount__c);
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
        BatchEuropeProgramCycleAmount acctBatch2Sched = new BatchEuropeProgramCycleAmount();
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
    }
    
    /*
    create a Program Cycle Amount record for a given cycle and program
    */
    private Program_Cycle_SDPY_Amount__c createPA(String progID, String cycleID){
        Program_Cycle_SDPY_Amount__c newPA = new Program_Cycle_SDPY_Amount__c();
        newPA.Program__c = progID;
        newPA.Cycle__c = cycleID;
        newPA.CurrencyIsoCode = 'EUR';
        return newPA;
    }
}