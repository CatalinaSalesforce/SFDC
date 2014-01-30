/*
@Name            : BatchEuropeAggregateSDPY 
@Author          : customersuccess@cloud62.com
@Date            : June 1 2013
@Description     : This class takes all of the FY and SDPY Program Cycle Amount records and creates LY records on a matching
					Opportunity next year for reporting purposes
*/

global class BatchEuropeAggregateSDPY implements Database.Batchable<sObject>, Schedulable{
    
    String query;
    String limit1;
    Map<String, Map<String, List<Ad_Period__c>>> apMap;
    Map<String, ID> adMap;
    
    public BatchEuropeAggregateSDPY(String x){
        limit1 = x;
    }
    
    public BatchEuropeAggregateSDPY(){
        limit1 = '';
    }
    
    //method that gets the query used for this batch
    global Database.querylocator start(Database.BatchableContext BC){
        //get all programs and their FY and SDPY records for all of Europe
        query = 'SELECT ID, NAME, DELIVERY_TYPE__C, Opportunity__R.AccountId, Opportunity__r.CloseDate, '
            + ' Opportunity__R.Start_Date__c, Opportunity__R.Account.RecordType.Name, Opportunity__r.RecordTypeId, '
            + '     (SELECT ID, NAME, FY_Amount__c, SDPY_Amount__c, CYCLE__C, '
            + '     Program_Cycle_FY_Amount__r.Cycle__c, Program_Cycle_SDPY_Amount__r.Cycle__c '
            + '     FROM PROGRAM_CYCLE_AMOUNTS__R) '
            + ' FROM PROGRAM__C '
            + ' WHERE OPPORTUNITY__R.ACCOUNT.RECORDTYPE.NAME IN (\'MANUFACTURING FRANCE\',\'MANUFACTURING ITALY\',\'MANUFACTURING GERMANY\') '
            + ' AND OPPORTUNITY__R.FOR_REPORTING__C = FALSE '
            //+ ' AND OPPORTUNITY__C = \'006K0000006WaRd\' ' //USED WHEN I WANTED TO TEST A PARTICULAR OPPTY AS A USE CASE
            + limit1;
        return Database.getQueryLocator(query);
    }
    
    global void execute(SchedulableContext ctx) {
    	//must process in smaller batches due to large number of possibly opptys you might associate to
        BatchEuropeAggregateSDPY batch1 = new BatchEuropeAggregateSDPY();
        ID batchprocessid = Database.executeBatch(batch1,50);
    } 
    
    //method that makes up the body of the batch process
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        List<Program__c> scopeList = (List<Program__c>)scope;
        populateAdPeriodMap();
        //map key is Account --> close Month --> start month --> delivery channel --> cycle
        Map<Id, Map<String, Map<String, Map<String, Map<Id, Program_Cycle_Amount__c>>>>> oppMap = new Map<Id, Map<String, Map<String, Map<String, Map<Id, Program_Cycle_Amount__c>>>>>();
        Map<Id, Map<String, Map<String, Map<String, Id>>>> progIDMap = new Map<Id, Map<String, Map<String, Map<String, Id>>>>(); 
        Map<Id, Opportunity> insertOppMap = new Map<Id, Opportunity>();
        Map<Id, Program__c> insertProgMap = new Map<Id, Program__c>();
        List<Program_Cycle_Amount__c> insertPCA = new List<Program_Cycle_Amount__c>();
        List<Program__c> unfoundProgs = new List<Program__c>();
        Set<Id> accList = new Set<Id>();
        for (Program__c p : scopeList){
            accList.add(p.Opportunity__r.AccountId);
        }
        List<Program__c> currentOps = [SELECT ID, Opportunity__r.NAME, Opportunity__r.AccountId, Opportunity__r.CloseDate,
            Opportunity__c, Delivery_Type__c, Opportunity__r.For_Reporting__c, Opportunity__r.Start_Date__c,
                (SELECT ID, NAME, FY_Amount__c, SDPY_Amount__c, LY__C, SDPY__C, Cycle__c,
                Program_Cycle_FY_Amount__r.Cycle__c, Program_Cycle_SDPY_Amount__r.Cycle__c
                FROM PROGRAM_CYCLE_AMOUNTS__R)
            FROM Program__c
            WHERE Opportunity__r.ACCOUNTID IN: accList];
        //store current opportunities in the map: Account --> close Month --> start month --> delivery channel --> cycle
        for (Program__c p : currentOps){
            if (!oppMap.containsKey(p.Opportunity__r.AccountId)){
                oppMap.put(p.Opportunity__r.AccountId, new Map<String, Map<String, Map<String, Map<Id, Program_Cycle_Amount__c>>>>());
                progIDMap.put(p.Opportunity__r.AccountId, new Map<String, Map<String, Map<String, Id>>>());
            }
            if (!oppMap.get(p.Opportunity__r.AccountId).containsKey(getStringMonth(p.Opportunity__r.CloseDate))){
                oppMap.get(p.Opportunity__r.AccountId).put(getStringMonth(p.Opportunity__r.CloseDate), new Map<String, Map<String, Map<Id, Program_Cycle_Amount__c>>>());
                progIDMap.get(p.Opportunity__r.AccountId).put(getStringMonth(p.Opportunity__r.CloseDate), new Map<String, Map<String, Id>>());
            }
            Date startDate;
            if (p.Opportunity__r.Start_Date__c != null){
                startDate = p.Opportunity__r.Start_Date__c; 
            } else {
                startDate = p.Opportunity__r.CloseDate;
            }
            if (!oppMap.get(p.Opportunity__r.AccountId).get(getStringMonth(p.Opportunity__r.CloseDate)).containsKey(getStringMonth(startDate))){
                oppMap.get(p.Opportunity__r.AccountId).get(getStringMonth(p.Opportunity__r.CloseDate)).put(getStringMonth(startDate), new Map<String, Map<Id, Program_Cycle_Amount__c>>());
                progIDMap.get(p.Opportunity__r.AccountId).get(getStringMonth(p.Opportunity__r.CloseDate)).put(getStringMonth(startDate), new Map<String, Id>());
            }
            if (!oppMap.get(p.Opportunity__r.AccountId).get(getStringMonth(p.Opportunity__r.CloseDate)).get(getStringMonth(startDate)).containsKey(p.Delivery_Type__c)){
                oppMap.get(p.Opportunity__r.AccountId).get(getStringMonth(p.Opportunity__r.CloseDate)).get(getStringMonth(startDate)).put(p.Delivery_Type__c, new Map<Id, Program_Cycle_Amount__c>());
                progIDMap.get(p.Opportunity__r.AccountId).get(getStringMonth(p.Opportunity__r.CloseDate)).get(getStringMonth(startDate)).put(p.Delivery_Type__c, p.Id);
            }
            for (Program_Cycle_Amount__c pca : p.PROGRAM_CYCLE_AMOUNTS__R){
                if (!oppMap.get(p.Opportunity__r.AccountId).get(getStringMonth(p.Opportunity__r.CloseDate)).get(getStringMonth(startDate)).get(p.Delivery_Type__c).containsKey(pca.Cycle__c)){
                    oppMap.get(p.Opportunity__r.AccountId).get(getStringMonth(p.Opportunity__r.CloseDate)).get(getStringMonth(startDate)).get(p.Delivery_Type__c).put(pca.Cycle__c, pca);
                }
            }
        }
        system.debug(LoggingLevel.ERROR, '***before check scope');
        //check to see if scope opportunities have matching opps next year
        for (Program__c p : scopeList){
            Date startDate;
            if (p.Opportunity__r.Start_Date__c != null){
                startDate = p.Opportunity__r.Start_Date__c; 
            } else {
                startDate = p.Opportunity__r.CloseDate;
            }
            if (!oppMap.containsKey(p.Opportunity__r.AccountId)){
                oppMap.put(p.Opportunity__r.AccountId, new Map<String, Map<String, Map<String, Map<Id, Program_Cycle_Amount__c>>>>());
            }
            if (!oppMap.get(p.Opportunity__r.AccountId).containsKey(getStringMonth(p.Opportunity__r.CloseDate.addYears(1)))){
                oppMap.get(p.Opportunity__r.AccountId).put(getStringMonth(p.Opportunity__r.CloseDate.addYears(1)), new Map<String, Map<String, Map<Id, Program_Cycle_Amount__c>>>());
            }
            if (!oppMap.get(p.Opportunity__r.AccountId).get(getStringMonth(p.Opportunity__r.CloseDate.addYears(1))).containsKey(getStringMonth(startDate.addYears(1)))){
                oppMap.get(p.Opportunity__r.AccountId).get(getStringMonth(p.Opportunity__r.CloseDate.addYears(1))).put(getStringMonth(startDate.addYears(1)), new Map<String, Map<Id, Program_Cycle_Amount__c>>());
            }
            if (!oppMap.get(p.Opportunity__r.AccountId).get(getStringMonth(p.Opportunity__r.CloseDate.addYears(1))).get(getStringMonth(startDate.addYears(1))).containsKey(p.Delivery_Type__c)){
                unfoundProgs.add(p);
                oppMap.get(p.Opportunity__r.AccountId).get(getStringMonth(p.Opportunity__r.CloseDate.addYears(1))).get(getStringMonth(startDate.addYears(1))).put(p.Delivery_Type__c, new Map<Id, Program_Cycle_Amount__c>());
            } else {
                //check to see if a program exists for next year before adding to the list of records to create
                //if an opp exists, create new PCA
                if (progIDMap.containsKey(p.Opportunity__r.AccountId)){
                if (progIDMap.get(p.Opportunity__r.AccountId).containsKey(getStringMonth(p.Opportunity__r.CloseDate.addYears(1)))){
                if (progIDMap.get(p.Opportunity__r.AccountId).get(getStringMonth(p.Opportunity__r.CloseDate.addYears(1))).containsKey(getStringMonth(startDate.addYears(1)))){
                if (progIDMap.get(p.Opportunity__r.AccountId).get(getStringMonth(p.Opportunity__r.CloseDate.addYears(1))).get(getStringMonth(startDate.addYears(1))).containsKey(p.Delivery_Type__c)){
                    //next year program exists, make PCAs
                    String tmpType = p.Opportunity__r.Account.RecordType.Name;
                    String tmpYear;
                    if (p.Opportunity__r.Start_Date__c == null){
                        tmpYear = String.valueOf(p.Opportunity__r.CloseDate.addYears(1).year());
                    } else {
                        tmpYear = String.valueOf(p.Opportunity__r.Start_Date__c.addYears(1).year());    
                    }
                    if (apMap.containsKey(tmpType)){
                        if (apMap.get(tmpType).containsKey(tmpYear)){
                            for (Ad_Period__c a : apMap.get(tmpType).get(tmpYear)){
                                if (!oppMap.get(p.Opportunity__r.AccountId).get(getStringMonth(p.Opportunity__r.CloseDate.addYears(1))).get(getStringMonth(startDate.addYears(1))).get(p.Delivery_Type__c).containsKey(a.Id)){
                                    Program_Cycle_Amount__c newPCA = new Program_Cycle_Amount__c();
                                    newPCA.Cycle__c=a.Id;
                                    newPCA.Name='SDPY Cycle Amount ';
                                    newPCA.Program__c=progIDMap.get(p.Opportunity__r.AccountId).get(getStringMonth(p.Opportunity__r.CloseDate.addYears(1))).get(getStringMonth(startDate.addYears(1))).get(p.Delivery_Type__c);
                                    newPCA.CurrencyIsoCode = 'EUR';
                                    insertPCA.add(newPCA);
                                    oppMap.get(p.Opportunity__r.AccountId).get(getStringMonth(p.Opportunity__r.CloseDate.addYears(1))).get(getStringMonth(startDate.addYears(1))).get(p.Delivery_Type__c).put(a.Id,newPCA);
                                    system.debug(LoggingLevel.ERROR, '***making a new PCA for an existing Prog 1');
                                }
                            }
                        }
                    }
                    
                    if (p.Opportunity__r.Start_Date__c == null){
                        tmpYear = String.valueOf(p.Opportunity__r.CloseDate.addYears(2).year());
                    } else {
                        tmpYear = String.valueOf(p.Opportunity__r.Start_Date__c.addYears(2).year());    
                    }
        
                    if (apMap.containsKey(tmpType)){
                        if (apMap.get(tmpType).containsKey(tmpYear)){
                            for (Ad_Period__c a : apMap.get(tmpType).get(tmpYear)){
                                if (!oppMap.get(p.Opportunity__r.AccountId).get(getStringMonth(p.Opportunity__r.CloseDate.addYears(1))).get(getStringMonth(startDate.addYears(1))).get(p.Delivery_Type__c).containsKey(a.Id)){
                                    Program_Cycle_Amount__c newPCA = new Program_Cycle_Amount__c();
                                    newPCA.Cycle__c=a.Id;
                                    newPCA.Name='SDPY Cycle Amount ';
                                    newPCA.Program__c=progIDMap.get(p.Opportunity__r.AccountId).get(getStringMonth(p.Opportunity__r.CloseDate.addYears(1))).get(getStringMonth(startDate.addYears(1))).get(p.Delivery_Type__c);
                                    newPCA.CurrencyIsoCode = 'EUR';
                                    insertPCA.add(newPCA);
                                    oppMap.get(p.Opportunity__r.AccountId).get(getStringMonth(p.Opportunity__r.CloseDate.addYears(1))).get(getStringMonth(startDate.addYears(1))).get(p.Delivery_Type__c).put(a.Id,newPCA);
                                    system.debug(LoggingLevel.ERROR, '***making a new PCA for an existing Prog 2');
                                }
                            }
                        }
                    }
                }
                }
                }
                }
            }
        }
        system.debug(LoggingLevel.ERROR, '***before insert opps');
        //begin creating records that are required to fully represent SDPY data
        //create and insert opps
        for (Program__c p : unfoundProgs){
            Opportunity newOpp = new Opportunity();
            newOpp.For_Reporting__c=true;
            newOpp.Name='SDPY Opp - ' + getStringMonth(p.Opportunity__r.CloseDate);
            newOpp.StageName='Closed Won';
            newOpp.CloseDate=p.Opportunity__r.CloseDate.addYears(1);
            if (p.Opportunity__r.Start_Date__c == null) p.Opportunity__r.Start_Date__c = p.Opportunity__r.CloseDate;
            newOpp.Start_Date__c=p.Opportunity__r.Start_Date__c.addYears(1);
            newOpp.AccountId=p.Opportunity__r.AccountId;
            newOpp.RecordTypeId=p.Opportunity__r.RecordTypeId;
            newOpp.CurrencyIsoCode = 'EUR';
            insertOppMap.put(p.Id, newOpp);
        }
        insert insertOppMap.values();
        
        //create and insert progs
        system.debug(LoggingLevel.ERROR, '***before insert progs');
        for (Program__c p : unfoundProgs){
            insertProgMap.put(p.id,new Program__c(Name='SDPY Program - '+getStringMonth(p.Opportunity__r.CloseDate),Opportunity__c=insertOppMap.get(p.Id).Id,Delivery_Type__c=p.Delivery_Type__c,CurrencyIsoCode = 'EUR'));
        }
        insert insertProgMap.values();
        
        //create and insert PCA
        //we create PCAs for the next 2 years because opps can span that amount of time
        system.debug(LoggingLevel.ERROR, '***before insert PCA');
        for (Program__c p : unfoundProgs){
            //create PCAs for next year and the year after in case the cycle year is different from the close date year
            String tmpType = p.Opportunity__r.Account.RecordType.Name;
            String tmpYear = String.valueOf(p.Opportunity__r.Start_Date__c.addYears(1).year());
            if (apMap.containsKey(tmpType)){
                if (apMap.get(tmpType).containsKey(tmpYear)){
                    for (Ad_Period__c a : apMap.get(tmpType).get(tmpYear)){
                        insertPCA.add(new Program_Cycle_Amount__c(Cycle__c=a.Id,Name='SDPY Cycle Amount ',Program__c=insertProgMap.get(p.Id).Id,CurrencyIsoCode = 'EUR'));
                    }
                }
            }
            
            tmpYear = String.valueOf(p.Opportunity__r.Start_Date__c.addYears(2).year());
            if (apMap.containsKey(tmpType)){
                if (apMap.get(tmpType).containsKey(tmpYear)){
                    for (Ad_Period__c a : apMap.get(tmpType).get(tmpYear)){
                        insertPCA.add(new Program_Cycle_Amount__c(Cycle__c=a.Id,Name='SDPY Cycle Amount ',Program__c=insertProgMap.get(p.Id).Id,CurrencyIsoCode = 'EUR'));
                    }
                }
            }
        }
        insert insertPCA;
        
        system.debug(LoggingLevel.ERROR, '***before requery');
        //requery the records we just inserted so that we can increment
        oppMap = new Map<Id, Map<String, Map<String, Map<String, Map<Id, Program_Cycle_Amount__c>>>>>();
        currentOps = [SELECT ID, Opportunity__r.NAME, Opportunity__r.AccountId, Opportunity__r.CloseDate,
            Opportunity__c, Delivery_Type__c, Opportunity__r.For_Reporting__c, Opportunity__r.Start_Date__c,
                (SELECT ID, NAME, FY_Amount__c, SDPY_Amount__c, CYCLE__C, LY__C, SDPY__C,
                Program_Cycle_FY_Amount__r.Cycle__c, Program_Cycle_SDPY_Amount__r.Cycle__c
                FROM PROGRAM_CYCLE_AMOUNTS__R)
            FROM Program__c
            WHERE Opportunity__r.ACCOUNTID IN: accList];
        //store current opportunities
        for (Program__c p : currentOps){
            if (!oppMap.containsKey(p.Opportunity__r.AccountId)){
                oppMap.put(p.Opportunity__r.AccountId, new Map<String, Map<String, Map<String, Map<Id, Program_Cycle_Amount__c>>>>());
            }
            if (!oppMap.get(p.Opportunity__r.AccountId).containsKey(getStringMonth(p.Opportunity__r.CloseDate))){
                oppMap.get(p.Opportunity__r.AccountId).put(getStringMonth(p.Opportunity__r.CloseDate), new Map<String, Map<String, Map<Id, Program_Cycle_Amount__c>>>());
            }
            Date startDate;
            if (p.Opportunity__r.Start_Date__c != null){
                startDate = p.Opportunity__r.Start_Date__c; 
            } else {
                startDate = p.Opportunity__r.CloseDate;
            }
            if (!oppMap.get(p.Opportunity__r.AccountId).get(getStringMonth(p.Opportunity__r.CloseDate)).containsKey(getStringMonth(startDate))){
                oppMap.get(p.Opportunity__r.AccountId).get(getStringMonth(p.Opportunity__r.CloseDate)).put(getStringMonth(startDate), new Map<String, Map<Id, Program_Cycle_Amount__c>>());
            }
            if (!oppMap.get(p.Opportunity__r.AccountId).get(getStringMonth(p.Opportunity__r.CloseDate)).get(getStringMonth(startDate)).containsKey(p.Delivery_Type__c)){
                oppMap.get(p.Opportunity__r.AccountId).get(getStringMonth(p.Opportunity__r.CloseDate)).get(getStringMonth(startDate)).put(p.Delivery_Type__c, new Map<Id, Program_Cycle_Amount__c>());
            }
            for (Program_Cycle_Amount__c pca : p.PROGRAM_CYCLE_AMOUNTS__R){
                if (!oppMap.get(p.Opportunity__r.AccountId).get(getStringMonth(p.Opportunity__r.CloseDate)).get(getStringMonth(startDate)).get(p.Delivery_Type__c).containsKey(pca.Cycle__c)){
                    oppMap.get(p.Opportunity__r.AccountId).get(getStringMonth(p.Opportunity__r.CloseDate)).get(getStringMonth(startDate)).get(p.Delivery_Type__c).put(pca.Cycle__c, pca);
                }
            }
        }
        
        system.debug(LoggingLevel.ERROR, '***before update PCA');
        //increment LY and SDPY numbers accordingly
        Map<Id, Program_Cycle_Amount__c> updatePCAs = new Map<Id, Program_Cycle_Amount__c>(); 
        for (Program__c p : scopeList){
            Date startDate;
            if (p.Opportunity__r.Start_Date__c != null){
                startDate = p.Opportunity__r.Start_Date__c; 
            } else {
                startDate = p.Opportunity__r.CloseDate;
            }
            for (Program_Cycle_Amount__c pca : p.PROGRAM_CYCLE_AMOUNTS__R){
                if (pca.FY_Amount__c != null || pca.SDPY_Amount__c != null){
                    if (oppMap.containsKey(p.Opportunity__r.AccountId)){
                        if (oppMap.get(p.Opportunity__r.AccountId).containsKey(getStringMonth(p.Opportunity__r.CloseDate.addYears(1)))){
                            if (oppMap.get(p.Opportunity__r.AccountId).get(getStringMonth(p.Opportunity__r.CloseDate.addYears(1))).containsKey(getStringMonth(startDate.addYears(1)))){
                                if (oppMap.get(p.Opportunity__r.AccountId).get(getStringMonth(p.Opportunity__r.CloseDate.addYears(1))).get(getStringMonth(startDate.addYears(1))).containsKey(p.Delivery_Type__c)){
                                    if (oppMap.get(p.Opportunity__r.AccountId).get(getStringMonth(p.Opportunity__r.CloseDate.addYears(1))).get(getStringMonth(startDate.addYears(1))).get(p.Delivery_Type__c).containsKey(pca.Cycle__c)){
                                        system.debug(LoggingLevel.ERROR, '***found: ' + pca.Id);
                                        Program_Cycle_Amount__c tempPCA = oppMap.get(p.Opportunity__r.AccountId).get(getStringMonth(p.Opportunity__r.CloseDate.addYears(1))).get(getStringMonth(startDate.addYears(1))).get(p.Delivery_Type__c).get(pca.Cycle__c);
                                        if (tempPCA.LY__c == null) tempPCA.LY__c = 0;
                                        if (tempPCA.SDPY__c == null) tempPCA.SDPY__c = 0;
                                        if (pca.FY_Amount__c != null) tempPCA.LY__c += pca.FY_Amount__c;
                                        if (pca.SDPY_Amount__c != null) tempPCA.SDPY__c += pca.SDPY_Amount__c;
                                        if (!updatePCAs.containsKey(tempPCA.Id)){
                                            updatePCAs.put(tempPCA.Id, tempPCA);
                                        } else {
                                            updatePCAs.remove(tempPCA.Id);
                                            updatePCAs.put(tempPCA.Id, tempPCA);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        update updatePCAs.values();
        
    }
    
    //method that runs after the execute() method
    global void finish(Database.BatchableContext BC){
        System.debug(LoggingLevel.WARN,'Temp_Delete_DeleteSM1Forecast');
        //Build the system time of now + 20 seconds to schedule the batch apex.
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        BatchEuropeCreateShellOpp acctBatch2Sched = new BatchEuropeCreateShellOpp();
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
        BatchGovernorLimitUtility.updateBatchRun();
    }
    
    /*
	Takes a date and returns a month in the MM format
	*/
    private String getStringMonth(Date d){
        String result;
        result = String.valueOf(d.year()) + '-';
        if (d.month() < 10){
            result += '0' + String.valueOf(d.month());
        } else {
            result += String.valueOf(d.month());
        }
        return result;
    }
    
    /*
	Takes all Europe cycles and puts in a map for processing
	*/
    private void populateAdPeriodMap(){
        List<Ad_Period__c> APs = [SELECT ID, NAME, START_DATE__C, Type__c
            FROM AD_PERIOD__C
            WHERE TYPE__C IN ('Manufacturing France','Manufacturing Germany','Manufacturing Italy')];
        adMap = new Map<String, ID>();
        apMap = new Map<String, Map<String, List<Ad_Period__c>>>();
        for (Ad_Period__c a : APs){
            if (!apMap.containsKey(a.Type__c)){
                apMap.put(a.Type__c, new Map<String, List<Ad_Period__c>>());
            }
            String tmpYear = String.valueOf(a.Start_Date__c.year());
            if (!apMap.get(a.Type__c).containsKey(tmpYear)){
                apMap.get(a.Type__c).put(tmpYear, new List<Ad_Period__c>());
            }
            apMap.get(a.Type__c).get(tmpYear).add(a);
            if (!adMap.containsKey(a.name)){
                adMap.put(a.name, a.id); 
            }
        }
    }

}