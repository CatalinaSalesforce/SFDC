/*
@Name           : BatchEuropeAssociateProgramCycleSDPY
@Author         : customersuccess@cloud62.com
@Date           : 4/15/2013
@Description    : Associate all Program Cycle SDPY AMount records to a Program Cycle Amount record for reporting
*/
global class BatchEuropeAssociateProgramCycleSDPY implements Database.Batchable<sObject>, Schedulable{
    
    //declare variables
    String query;
    String limit1;
    
    public BatchEuropeAssociateProgramCycleSDPY(String x){
        limit1 = x;
    }
    
    public BatchEuropeAssociateProgramCycleSDPY(){
        limit1 = '';
    }
    
    global void execute(SchedulableContext ctx) {
        BatchEuropeAssociateProgramCycleSDPY batch1 = new BatchEuropeAssociateProgramCycleSDPY();
        ID batchprocessid = Database.executeBatch(batch1, 200);
    }
    
    global Database.querylocator start(Database.BatchableContext BC){

        query = 'SELECT ID, NAME, Cycle_Name__c, PROGRAM__C, cycle__r.type__c ' 
            + 'FROM Program_Cycle_SDPY_Amount__c '
            + limit1;
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        List<Program_Cycle_SDPY_Amount__c> pfScope = (List<Program_Cycle_SDPY_Amount__c>)scope;
        Set<Id> progList = new Set<Id>();
        for (Program_Cycle_SDPY_Amount__c pf : pfScope){
            progList.add(pf.Program__c);
        }
        List<Program_Cycle_Amount__c> insertPA = new List<Program_Cycle_Amount__c>();
        
        //get Program Cycle Amounts that already exist
        List<Program_Cycle_Amount__c> currentPA = [SELECT ID, NAME, PROGRAM__C, ACTUAL_AMOUNT__C, FORECAST_CONTRACT__C,
            FORECAST_PROPOSAL__C, Cycle_Name__c
            FROM Program_Cycle_Amount__c
            WHERE PROGRAM__C IN :progList];
            
        //Put existing records in a map 
        Map<Id, Map<String, Program_Cycle_Amount__c>> paMap = new Map<Id, Map<String, Program_Cycle_Amount__c>>();
        for (Program_Cycle_Amount__c pa : currentPA){
            if (!paMap.containsKey(pa.Program__c)){
                paMap.put(pa.Program__c, new Map<String, Program_Cycle_Amount__c>());
            }

            if (!paMap.get(pa.Program__c).containsKey(pa.Cycle_Name__c)){
                paMap.get(pa.Program__c).put(pa.Cycle_Name__c, pa);
            }
   
        } 
        
        //put cycles in a map to be used later on when figuring out next cycles
        List<Ad_Period__c> adPeriods = [Select ID, Name
                                        From Ad_Period__c];
		Map<String, ID> adMap = new Map<String, ID>();
        for(Ad_Period__c ad : adPeriods){
            if (!adMap.containsKey(ad.name)){
                adMap.put(ad.name, ad.id); 
            }
        }
        
        //for each SDPY record, insert a PCA record if an appropriate record for association doesnt already exist
        for (Program_Cycle_SDPY_Amount__c pf : pfScope){
            if (!paMap.containsKey(pf.Program__c)){
                paMap.put(pf.Program__c, new Map<String, Program_Cycle_Amount__c>());
            }         
            String nextCycle = getNY(pf.Cycle_name__c, pf.cycle__r.type__c);
            if (!paMap.get(pf.Program__c).containsKey(nextCycle)){
                Program_Cycle_Amount__c newPA = createPA(pf.Program__c, string.valueOf(adMap.get(nextCycle)));
               insertPA.add(newPA);
                paMap.get(pf.Program__c).put(nextCycle, newPA);
            }
        }
        insert insertPA;
        
        //requery PCA records after insert
        currentPA = [SELECT ID, NAME, PROGRAM__C, ACTUAL_AMOUNT__C, FORECAST_CONTRACT__C,
            FORECAST_PROPOSAL__C, Cycle_Name__c
            FROM Program_Cycle_Amount__c
            WHERE PROGRAM__C IN :progList];
        paMap = new Map<Id, Map<String, Program_Cycle_Amount__c>>();
        for (Program_Cycle_Amount__c pa : currentPA){
            if (!paMap.containsKey(pa.Program__c)){
                paMap.put(pa.Program__c, new Map<String, Program_Cycle_Amount__c>());
            }

            if (!paMap.get(pa.Program__c).containsKey(pa.Cycle_Name__c)){
                paMap.get(pa.Program__c).put(pa.Cycle_Name__c, pa);
            }

        }
        
        //total up records
        for (Program_Cycle_SDPY_Amount__c pf : pfScope){
            string nyCycle = getNY(pf.Cycle_Name__c, pf.cycle__r.type__c);
            Program_Cycle_Amount__c pa = paMap.get(pf.Program__c).get(nyCycle);
            pa.Program_Cycle_SDPY_Amount__c = pf.Id;
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
        BatchEuropeAssociateAccountQuota acctBatch2Sched = new BatchEuropeAssociateAccountQuota();
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
    }
    
    /*
    create a Program Cycle Amount record for a given cycle and program
    */
	private Program_Cycle_Amount__c createPA(String progID, string cycleID){
        Program_Cycle_Amount__c newPA = new Program_Cycle_Amount__c();
        newPA.cycle__c = cycleID;
        newPA.Program__c = progID;
        newPA.CurrencyIsoCode = 'EUR';
        return newPA;
    }
    
    
    /*
    Method that accepts a string that represents a Cycle and returns the same cycle NEXT year
	param  - string that represents the cycle in XX_CC_YYYY_MMM  GM_C1_2012_Jan
	return - string that represents the cycle in XX_CC_YYYY_MMM  GM_C1_2013_Jan
    */
    
	private String getNY(String x, string cycleType){
        string returnString = 'x';
        if(cycleType == 'Manufacturing Germany'){
            system.debug('@@@ Breaking Code    '+ x);
            String head = x.substring(0,8); //		GM_C1_20
            Integer year = Integer.valueOf(x.substring(8,10)); //	(11,12,13,14,15)
            String tail = x.substring(10,14); //	_Jan
            year++;
            system.debug('@@@ Returning Code    '+ head + String.valueOf(year) + tail);
            returnString =  head + String.valueOf(year) + tail; 
        }
        if(cycleType == 'Manufacturing France'){
            system.debug('@@@ Breaking Code    '+ x);
            String head = x.substring(0,8); //		FR_C1_20
            Integer year = Integer.valueOf(x.substring(8,10)); //	(11,12,13,14,15)
            year++;
            system.debug('@@@ Returning Code    '+ head + String.valueOf(year));
            returnString =  head + String.valueOf(year); 
        }
        if(cycleType == 'Manufacturing Italy'){
            system.debug('@@@ Breaking Code    '+ x);
            String head = x.substring(0,11); //		FR_AP_C1_20
            Integer year = Integer.valueOf(x.substring(11,13)); //	(11,12,13,14,15)
            year++;
            system.debug('@@@ Returning Code    '+ head + String.valueOf(year));
            returnString =  head + String.valueOf(year); 
        }
        return returnString;
    }
}