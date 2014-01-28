global class TEMP_EDIT implements Database.Batchable<sObject>{
    
    String query;
    
    global Database.querylocator start(Database.BatchableContext BC){
        /*
        Batch_Log__c batchLog = new Batch_Log__c();
        
        batchLog.Start_Time__c = datetime.now();
        
        batchLog.Class_Name__c = 'TEMP_EDIT';
        
        insert batchLog;
        
        
        Batch_Status__c batchStatus = new Batch_Status__c();
        
        batchStatus.Message__c = 'test batch insert';
        
        insert batchstatus;
        */
        
        query = 'SELECT ID, ACTUAL_AMOUNT__C, FORECAST_AMOUNT__C, AD_PERIOD__R.NAME, AD_PERIOD__C, '
            + ' Program__r.Opportunity__r.AccountId, Program__r.Opportunity__r.OwnerId, Active__c, '
            + ' PROGRAM__R.OPPORTUNITY__R.RECORDTYPE.NAME, Actual_Formula__c, '
            + ' Program__r.Delivery_Type__c, AD_PERIOD__R.START_DATE__C, AD_PERIOD__R.END_DATE__C '
            + ' FROM PROGRAM_FORECAST__C '
            + ' WHERE PROGRAM__R.OPPORTUNITY__R.RECORDTYPE.NAME = \'CONTRACT FRANCE\' OR PROGRAM__R.OPPORTUNITY__R.RECORDTYPE.NAME = \'PROPOSAL FRANCE\' '
            + ' ORDER BY PROGRAM__R.OPPORTUNITY__R.OWNERID ';
        //query = 'SELECT ID FROM  USER LIMIT 1';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        /*
        List<Program_Forecast__c> pfScope = (List<Program_Forecast__c>)scope;
        Set<Id> oppIDs = new Set<Id>();
        for (Program_Forecast__c pf : pfScope){
            oppIDs.add(pf.Program__r.Opportunity__c);
        }
        
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
        List<Opportunity> oppList = [SELECT ID, START_DATE__C FROM OPPORTUNITY WHERE ID IN: oppIDs];
        for (Opportunity o : oppList){
            oppMap.put(o.Id, o);
        }
        
        for (Program_Forecast__c pf : pfScope){
            Opportunity o = oppMap.get(pf.Program__r.Opportunity__c);
            if (o.Start_Date__c == null){
                o.Start_Date__c = pf.Ad_Period__r.Start_Date__c;
            } else if (o.Start_Date__c > pf.Ad_Period__r.Start_Date__c){
                o.Start_Date__c = pf.Ad_Period__r.Start_Date__c;
            }
        }
        
        update oppList;
        */
        
        Map<Id, Ad_Period__c> adMap = new Map<id, Ad_Period__c>();
        List<Ad_Period__c> adperiods = [SELECT ID, START_DATE__C, END_DATE__C FROM AD_PERIOD__C];
        for (Ad_Period__c ap : adperiods){
            adMap.put(ap.Id, ap);
        }
        
        List<Program_Forecast__c> pfScope = (List<Program_Forecast__c>)scope;
        Set<Id> progIDs = new Set<Id>();
        for (Program_Forecast__c pf : pfScope){
            progIDs.add(pf.Program__c);
        }
        
        Map<Id, Program__c> progMap = new Map<Id, Program__c>();
        List<Program__c> progList = [SELECT ID, START_DATE__C, End_Date__c, Start_Cycle__c, End_Cycle__c,
            Start_Cycle__r.Start_Date__c, End_Cycle__r.End_Date__c
            FROM Program__c WHERE ID IN: progIDs];
        for (Program__c o : progList){
            progMap.put(o.Id, o);
        }
        
        for (Program_Forecast__c pf : pfScope){
            Program__c o = progMap.get(pf.Program__c);
            if (o.Start_Cycle__c == null){
                o.Start_Cycle__c = pf.Ad_Period__c;
            } else if (adMap.get(o.Start_Cycle__c).Start_Date__c > pf.Ad_Period__r.Start_Date__c){
                o.Start_Cycle__c = pf.Ad_Period__c;
            }
            if (o.End_Cycle__c == null){
                o.End_Cycle__c = pf.Ad_Period__c;
            } else if (adMap.get(o.End_Cycle__c).End_Date__c < pf.Ad_Period__r.End_Date__c){
                o.End_Cycle__c = pf.Ad_Period__c;
            }
        }
        
        update progList;
        
    }
    
    global void finish(Database.BatchableContext BC){
        /*
        Batch_Log__c batchLog = [select ID from Batch_Log__c where Class_Name__c = 'TEMP_EDIT' AND Start_Time__c >: datetime.now().addDays(-1)];
        
        batchLog.Finish_Time__c = datetime.now();
        
        batchLog.Successful__c = true;
        
        update batchLog;
        */
        
    }

}