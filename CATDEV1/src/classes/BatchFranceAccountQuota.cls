/*
@Name           : BatchFranceAccountQuota
@Author         : customersuccess@cloud62.com
@Date           : 2012-12-14
@Description    : Class to populate France_Account_Quota__c
Dec 14 - create SDPY fields and populate based on start year
Mar 27 2013 - comment out quota population
*/
global class BatchFranceAccountQuota implements Database.Batchable<sObject>, Schedulable{

    final static String defaultSettingsName = 'Default';
    final static String EUR = 'EUR';
    
    String query;
    String limit1;
    Set<Id> accList;
    List<France_Account_Quota__c> FSQ;
    Map<Id, Map<String, Map<String, Map<String, France_Account_Quota__c>>>> fsqMap;
    Map<Id, Map<String, Map<String, France_Account_Quota_Input__c>>> quotaMap;
    Map<Id, User> SR2 = New Map<Id, User>();
    Map<Id, User> SR1 = New Map<Id, User>();
    Map<Id, User> SM2 = New Map<Id, User>();
    Map<Id, User> SM1 = New Map<Id, User>();
    String rep2Type;
    String rep1Type;
    String SM2Type;
    String SM1Type;
    String coopType;
    
    public BatchFranceAccountQuota (String x){
        limit1 = x;
    }
    
    public BatchFranceAccountQuota (){
        limit1 = '';
    }
    
    global void execute(SchedulableContext ctx) {
        BatchFranceAccountQuota batch1 = new BatchFranceAccountQuota();
        ID batchprocessid = Database.executeBatch(batch1, 200);
    }
    
    global Database.querylocator start(Database.BatchableContext BC){
    
        Batch_Log__c batchLog = new Batch_Log__c();
        
        batchLog.Start_Time__c = datetime.now();
        
        batchLog.Class_Name__c = 'BatchFranceAccountQuota';
        
        insert batchLog;
    
        query = 'SELECT ID, ACTUAL_AMOUNT__C, FORECAST_AMOUNT__C, AD_PERIOD__R.NAME, AD_PERIOD__r.Start_Date__c, '
            + ' Program__r.Opportunity__r.AccountId, Program__r.Opportunity__r.OwnerId, Active__c, '
            + ' PROGRAM__R.OPPORTUNITY__R.RECORDTYPE.NAME, Actual_Formula__c, PROGRAM__R.OPPORTUNITY__R.Start_Date__c, '
            + ' Program__r.Delivery_Type__c, Program__r.Opportunity__r.Account.OwnerId, PROGRAM__R.OPPORTUNITY__R.CLOSEDATE '
            + ' FROM PROGRAM_FORECAST__C '
            + ' WHERE PROGRAM__R.OPPORTUNITY__R.RECORDTYPE.NAME = \'CONTRACT FRANCE\' OR PROGRAM__R.OPPORTUNITY__R.RECORDTYPE.NAME = \'PROPOSAL FRANCE\' '
            + ' ORDER BY PROGRAM__R.OPPORTUNITY__R.OWNERID ' + limit1;
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        Catalina_Forecast_Settings__c settings = Catalina_Forecast_Settings__c.getInstance(defaultSettingsName);
        if (settings != null){
            rep2Type = settings.Rep_2_String__c;
            rep1Type = settings.Rep_1_String__c;
            SM2Type = settings.SM_2_String__c;
            SM1Type = settings.SM_1_String__c;
            coopType = settings.Coop_String__c;
        }
        List<User> users = [SELECT Id, Forecast_Role__c, ManagerId From User Where Forecast_Role__c != NULL And ManagerID  != NULL ];
        for (User u : users){
            if (u.Forecast_Role__c.contains(rep2Type)){
                SR2.put(u.Id, u);
            } else if (u.Forecast_Role__c.contains(rep1Type)){
                SR1.put(u.Id, u);
            } if (u.Forecast_Role__c.contains(SM2Type)){
                SM2.put(u.Id, u);
            } else if (u.Forecast_Role__c.contains(SM1Type) || u.Forecast_Role__c.contains(coopType)){
                SM1.put(u.Id, u);
            }
        }
        
        List<Program_Forecast__c> pfScope = (List<Program_Forecast__c>)scope;
        accList = new Set<Id>();
        for (Program_Forecast__c pf : pfScope){
            accList.add(pf.Program__r.Opportunity__r.AccountId);
        }
        
        quotaMap = new Map<Id, Map<String, Map<String, France_Account_Quota_Input__c>>>();
        
        List<France_Account_Quota_Input__c> FSQI = [SELECT ID, OWNERID, Year__c, Account__c, AMOUNT__C, Delivery_Type__c
            FROM France_Account_Quota_Input__c Where Account__c IN :accList];
            
        for (France_Account_Quota_Input__c a : FSQI){
            if (!quotaMap.containsKey(a.Account__c)){
                quotaMap.put(a.Account__c, new Map<String, Map<String, France_Account_Quota_Input__c>>());
            }
            if (!quotaMap.get(a.Account__c).containsKey(a.Year__c)){
                quotaMap.get(a.Account__c).put(a.Year__c, new Map<String, France_Account_Quota_Input__c>());
            }
            if (!quotaMap.get(a.Account__c).get(a.Year__c).containsKey(a.Delivery_Type__c)){
                quotaMap.get(a.Account__c).get(a.Year__c).put(a.Delivery_Type__c, a);
            }
        }
        
        populateFSQMap();
        
        List<France_Account_Quota__c> insertFSQ = new List<France_Account_Quota__c>();
        
        for (Program_Forecast__c pf : pfScope){
        	String startYear = String.valueOf(pf.Program__r.Opportunity__r.Start_Date__c.year());
            if (!fsqMap.containsKey(pf.Program__r.Opportunity__r.AccountId)){
                fsqMap.put(pf.Program__r.Opportunity__r.AccountId, new Map<String, Map<String, Map<String, France_Account_Quota__c>>>());
            }
            if (!fsqMap.get(pf.Program__r.Opportunity__r.AccountId).containsKey(String.valueOf(pf.Ad_Period__r.Start_Date__c.year()))){
                fsqMap.get(pf.Program__r.Opportunity__r.AccountId).put(String.valueOf(pf.Ad_Period__r.Start_Date__c.year()), new Map<String, Map<String, France_Account_Quota__c>>());
            }
            if (!fsqMap.get(pf.Program__r.Opportunity__r.AccountId).get(String.valueOf(pf.Ad_Period__r.Start_Date__c.year())).containsKey(pf.Program__r.Delivery_Type__c)){
            	fsqMap.get(pf.Program__r.Opportunity__r.AccountId).get(String.valueOf(pf.Ad_Period__r.Start_Date__c.year())).put(pf.Program__r.Delivery_Type__c, new Map<String, France_Account_Quota__c>());
            }
            if (!fsqMap.get(pf.Program__r.Opportunity__r.AccountId).get(String.valueOf(pf.Ad_Period__r.Start_Date__c.year())).get(pf.Program__r.Delivery_Type__c).containsKey(startYear)){
                France_Account_Quota__c newFSQ = createFSQ(pf, startYear);
                insertFSQ.add(newFSQ);
                fsqMap.get(pf.Program__r.Opportunity__r.AccountId).get(String.valueOf(pf.Ad_Period__r.Start_Date__c.year())).get(pf.Program__r.Delivery_Type__c).put(startYear, newFSQ);
            }
            //next year
            startYear = String.valueOf(pf.Program__r.Opportunity__r.Start_Date__c.year() + 1);
            if (!fsqMap.get(pf.Program__r.Opportunity__r.AccountId).containsKey(String.valueOf(pf.Ad_Period__r.Start_Date__c.year() + 1))){
                fsqMap.get(pf.Program__r.Opportunity__r.AccountId).put(String.valueOf(pf.Ad_Period__r.Start_Date__c.year() + 1), new Map<String, Map<String, France_Account_Quota__c>>());
            }
            if (!fsqMap.get(pf.Program__r.Opportunity__r.AccountId).get(String.valueOf(pf.Ad_Period__r.Start_Date__c.year() + 1)).containsKey(pf.Program__r.Delivery_Type__c)){
            	fsqMap.get(pf.Program__r.Opportunity__r.AccountId).get(String.valueOf(pf.Ad_Period__r.Start_Date__c.year() + 1)).put(pf.Program__r.Delivery_Type__c, new Map<String, France_Account_Quota__c>());
            }
            if (!fsqMap.get(pf.Program__r.Opportunity__r.AccountId).get(String.valueOf(pf.Ad_Period__r.Start_Date__c.year() + 1)).get(pf.Program__r.Delivery_Type__c).containsKey(startYear)){
                France_Account_Quota__c newFSQ = createFSQ(pf, String.valueOf(pf.Ad_Period__r.Start_Date__c.year() + 1), startYear);
                insertFSQ.add(newFSQ);
                fsqMap.get(pf.Program__r.Opportunity__r.AccountId).get(String.valueOf(pf.Ad_Period__r.Start_Date__c.year() + 1)).get(pf.Program__r.Delivery_Type__c).put(startYear, newFSQ);
            }
            
        }
        
        insert insertFSQ;
        
        populateFSQMap();
        
        for (Program_Forecast__c pf: pfScope){
        	String startYear = String.valueOf(pf.Program__r.Opportunity__r.Start_Date__c.year());
            system.debug(LoggingLevel.ERROR, '***pf: ' + pf.Program__r.Opportunity__r.AccountId + '-' + pf.Ad_Period__r.Name + '-' + pf.Program__r.Delivery_Type__c);
            France_Account_Quota__c fsq = fsqMap.get(pf.Program__r.Opportunity__r.AccountId).get(String.valueOf(pf.Ad_Period__r.Start_Date__c.year())).get(pf.Program__r.Delivery_Type__c).get(startYear);
            //system.debug(LoggingLevel.Error, '***RT: ' + pf.Program__r.Opportunity__r.RecordType.Name);
            if (pf.Program__r.Opportunity__r.RecordType.Name.contains('Contract')){
                //system.debug(LoggingLevel.Error, '***isContract');
                if (pf.Active__c == false){
                    system.debug(LoggingLevel.Error, '***FSQ Booked before: ' + fsq.Booked__c);
                    system.debug(LoggingLevel.Error, '***Actual Formula: ' + pf.Actual_Formula__c);
                    fsq.Booked__c += pf.Actual_Formula__c;
                    system.debug(LoggingLevel.Error, '***FSQ Booked after: ' + fsq.Booked__c);
                } else {
                    if (pf.Program__r.Delivery_Type__c == 'Overprint'){
                        fsq.Overprint__c += (pf.Forecast_Amount__c == null? 0 : pf.Forecast_Amount__c);
                    } else {
                        fsq.Booked__c += (pf.Forecast_Amount__c == null ? 0 : pf.Forecast_Amount__c);
                    }
                }
            } else {
                if (pf.Active__c == true){
                    system.debug(LoggingLevel.ERROR, '***weighted prop: ' + fsq);
                    system.debug(LoggingLevel.ERROR, '***weighted prop: ' + fsq.Weighted_Proposal__c);
                    fsq.Weighted_Proposal__c += (pf.Forecast_Amount__c == null ? 0 : pf.Forecast_Amount__c);
                }
            }
			
			//2012-12-14 now store records by Start Year
			startYear = String.valueOf(pf.Program__r.Opportunity__r.Start_Date__c.year() + 1);
            if (fsqMap.get(pf.Program__r.Opportunity__r.AccountId).containsKey(String.valueOf(pf.Ad_Period__r.Start_Date__c.year() + 1))){
                if (fsqMap.get(pf.Program__r.Opportunity__r.AccountId).get(String.valueOf(pf.Ad_Period__r.Start_Date__c.year() + 1)).containsKey(pf.Program__r.Delivery_Type__c)){
                	if (fsqMap.get(pf.Program__r.Opportunity__r.AccountId).get(String.valueOf(pf.Ad_Period__r.Start_Date__c.year() + 1)).get(pf.Program__r.Delivery_Type__c).containsKey(startYear) && pf.Program__r.Opportunity__r.RecordType.Name.contains('Contract')){
	                    France_Account_Quota__c fsq1 = fsqMap.get(pf.Program__r.Opportunity__r.AccountId).get(String.valueOf(pf.Ad_Period__r.Start_Date__c.year() + 1)).get(pf.Program__r.Delivery_Type__c).get(startYear);
	                    fsq1.SDLY__c += pf.Actual_Formula__c;
	                    //added by Warren for SDPY fix
	                    if (fsq1.SDPY__c == null) fsq1.SDPY__c = 0;
	                    if (pf.Program__r.Opportunity__r.CloseDate <= Date.today().addYears(-1)) fsq1.SDPY__c += pf.Actual_Formula__c;
                	}
                } 
            }
        }
        
        for (France_Account_Quota__c fq : FSQ){
            system.debug(LoggingLevel.Error, '***FSQ Booked: ' + fq.Booked__c);
        }
        update FSQ;
        
    }
    
    global void finish(Database.BatchableContext BC){
        
        List<Batch_Log__c> batchLog = [select ID from Batch_Log__c where Class_Name__c = 'BatchFranceAccountQuota' AND Start_Time__c >: datetime.now().addDays(-1) ORDER BY Start_Time__c desc limit 1];
        
        if(batchLog.size() == 1)
        {
        
        batchLog[0].Finish_Time__c = datetime.now();
        
        batchLog[0].Successful__c = true;
        
        update batchLog[0];
        
        }
    
        System.debug(LoggingLevel.WARN,'Temp_Delete_DeleteSM1Forecast');
        //Build the system time of now + 20 seconds to schedule the batch apex.
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        BatchFranceDeleteSalespersonQuota acctBatch2Sched = new BatchFranceDeleteSalespersonQuota();
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
    }
    
    private France_Account_Quota__c createFSQ(Program_Forecast__c pf, String startYear){
        France_Account_Quota__c fsq = new France_Account_Quota__c();
        fsq.CurrencyIsoCode = EUR;
        fsq.Delivery_Type__c = pf.Program__r.Delivery_Type__c;
        fsq.Account__c = pf.Program__r.Opportunity__r.AccountId;
        fsq.Year__c = String.valueOf(pf.Ad_Period__r.Start_Date__c.year());
        //2012-12-14 now store records by Start Year
        fsq.Start_Year__c = startYear;
        /* commented out by Warren, BatchFranceCreateAccountQuotaShell creates quotas already
        if (quotaMap.containsKey(pf.Program__r.Opportunity__r.AccountId)){
            if (quotaMap.get(pf.Program__r.Opportunity__r.AccountId).containsKey(String.valueOf(pf.Ad_Period__r.Start_Date__c.year()))){
                if (quotaMap.get(pf.Program__r.Opportunity__r.AccountId).get(String.valueOf(pf.Ad_Period__r.Start_Date__c.year())).containsKey(pf.Program__r.Delivery_Type__c)){
                    fsq.Quota__c = quotaMap.get(pf.Program__r.Opportunity__r.AccountId).get(String.valueOf(pf.Ad_Period__r.Start_Date__c.year())).get(pf.Program__r.Delivery_Type__c).Amount__c;
                } else {
                    fsq.Quota__c = 0;   
                }
            } else {
                fsq.Quota__c = 0;
            }
        } else {
            fsq.Quota__c = 0;
        }*/
        fsq.Booked__c = 0;
        fsq.SDLY__c = 0;
        fsq.SDPY__c = 0;
        fsq.Weighted_Proposal__c = 0;
        fsq.Overprint__c = 0;
        fsq.Account_Owner__c = pf.Program__r.Opportunity__r.Account.OwnerId;
        
        if (SR2.containsKey(fsq.Account_Owner__c)){
            fsq.SR2__c = fsq.Account_Owner__c;
            fsq.SR1__c = SR2.get(fsq.Account_Owner__c).ManagerId;
            if (fsq.SR1__c != null){
                if (SR1.containsKey(fsq.SR1__c)) fsq.SM2__c = SR1.get(fsq.SR1__c).ManagerId;
            }
            if (fsq.SM2__c != null){
                if (SM2.containsKey(fsq.SM2__c)) fsq.SM1__c = SM2.get(fsq.SM2__c).ManagerId;
            }
            if (fsq.SM1__c != null){
                if (SM1.containsKey(fsq.SM1__c)) fsq.EVP__c = SM1.get(fsq.SM1__c).ManagerId;
            }
        } else if (SR1.containsKey(fsq.Account_Owner__c)){
            fsq.SR1__c = fsq.Account_Owner__c;
            fsq.SM2__c = SR1.get(fsq.SR1__c).ManagerId;
            if (fsq.SM2__c != null){
                if (SM2.containsKey(fsq.SM2__c)) fsq.SM1__c = SM2.get(fsq.SM2__c).ManagerId;
            }
            if (fsq.SM1__c != null){
                if (SM1.containsKey(fsq.SM1__c)) fsq.EVP__c = SM1.get(fsq.SM1__c).ManagerId;
            }
        } else if (SM2.containsKey(fsq.Account_Owner__c)){
            fsq.SM2__c = fsq.Account_Owner__c;
            fsq.SM1__c = SM2.get(fsq.SM2__c).ManagerId;
            if (fsq.SM1__c != null){
                if (SM1.containsKey(fsq.SM1__c)) fsq.EVP__c = SM1.get(fsq.SM1__c).ManagerId;
            }
        } else if (SM1.containsKey(fsq.Account_Owner__c)){
            fsq.SM1__c = fsq.Account_Owner__c;
            fsq.EVP__c = SM1.get(fsq.SM1__c).ManagerId;
        }
        
        return fsq;
    }
    
    private France_Account_Quota__c createFSQ(Program_Forecast__c pf, String year, String startYear){
        France_Account_Quota__c fsq = new France_Account_Quota__c();
        fsq.CurrencyIsoCode = EUR;
        fsq.Delivery_Type__c = pf.Program__r.Delivery_Type__c;
        fsq.Account__c = pf.Program__r.Opportunity__r.AccountId;
        fsq.Year__c = year;
        //2012-12-14 now store records by Start Year
        fsq.Start_Year__c = startYear;
        /* commented out by Warren, BatchFranceCreateAccountQuotaShell creates quotas already
        if (quotaMap.containsKey(pf.Program__r.Opportunity__r.AccountId)){
            if (quotaMap.get(pf.Program__r.Opportunity__r.AccountId).containsKey(year)){
                if (quotaMap.get(pf.Program__r.Opportunity__r.AccountId).get(year).containsKey(pf.Program__r.Delivery_Type__c)){
                    fsq.Quota__c = quotaMap.get(pf.Program__r.Opportunity__r.AccountId).get(year).get(pf.Program__r.Delivery_Type__c).Amount__c;
                } else {
                    fsq.Quota__c = 0;   
                }
            } else {
                fsq.Quota__c = 0;
            }
        } else {
            fsq.Quota__c = 0;
        }*/
        fsq.Booked__c = 0;
        fsq.SDLY__c = 0;
        fsq.SDPY__c = 0;
        fsq.Weighted_Proposal__c = 0;
        fsq.Overprint__c = 0;
        fsq.Account_Owner__c = pf.Program__r.Opportunity__r.Account.OwnerId;
        
        if (SR2.containsKey(fsq.Account_Owner__c)){
            fsq.SR2__c = fsq.Account_Owner__c;
            fsq.SR1__c = SR2.get(fsq.Account_Owner__c).ManagerId;
            if (fsq.SR1__c != null){
                if (SR1.containsKey(fsq.SR1__c)) fsq.SM2__c = SR1.get(fsq.SR1__c).ManagerId;
            }
            if (fsq.SM2__c != null){
                if (SM2.containsKey(fsq.SM2__c)) fsq.SM1__c = SM2.get(fsq.SM2__c).ManagerId;
            }
            if (fsq.SM1__c != null){
                if (SM1.containsKey(fsq.SM1__c)) fsq.EVP__c = SM1.get(fsq.SM1__c).ManagerId;
            }
        } else if (SR1.containsKey(fsq.Account_Owner__c)){
            fsq.SR1__c = fsq.Account_Owner__c;
            fsq.SM2__c = SR1.get(fsq.SR1__c).ManagerId;
            if (fsq.SM2__c != null){
                if (SM2.containsKey(fsq.SM2__c)) fsq.SM1__c = SM2.get(fsq.SM2__c).ManagerId;
            }
            if (fsq.SM1__c != null){
                if (SM1.containsKey(fsq.SM1__c)) fsq.EVP__c = SM1.get(fsq.SM1__c).ManagerId;
            }
        } else if (SM2.containsKey(fsq.Account_Owner__c)){
            fsq.SM2__c = fsq.Account_Owner__c;
            fsq.SM1__c = SM2.get(fsq.SM2__c).ManagerId;
            if (fsq.SM1__c != null){
                if (SM1.containsKey(fsq.SM1__c)) fsq.EVP__c = SM1.get(fsq.SM1__c).ManagerId;
            }
        } else if (SM1.containsKey(fsq.Account_Owner__c)){
            fsq.SM1__c = fsq.Account_Owner__c;
            fsq.EVP__c = SM1.get(fsq.SM1__c).ManagerId;
        }
        return fsq;
    }
    
    private void populateFSQMap(){
        fsqMap = new Map<Id, Map<String, Map<String, Map<String, France_Account_Quota__c>>>>();
        
        FSQ = [SELECT ID,Year__c, Booked__c, Delivery_Type__c, Account__c, Start_Year__c, 
            Quota__c, SDLY__c, Weighted_Proposal__c, Overprint__c, SDPY__C
            From France_Account_Quota__c
            Where Account__c IN :accList];
        
        for (France_Account_Quota__c a : FSQ){
            if (!fsqMap.containsKey(a.Account__c)){
                fsqMap.put(a.Account__c, new Map<String, Map<String, Map<String, France_Account_Quota__c>>>());
            }
            if (!fsqMap.get(a.Account__c).containsKey(a.Year__c)){
                fsqMap.get(a.Account__c).put(a.Year__c, new Map<String, Map<String, France_Account_Quota__c>>());
            }
            if (!fsqMap.get(a.Account__c).get(a.Year__c).containsKey(a.Delivery_Type__c)){
                fsqMap.get(a.Account__c).get(a.Year__c).put(a.Delivery_Type__c, new Map<String, France_Account_Quota__c>());
            }
            //2012-12-14 now store records by Start Year
            if (!fsqMap.get(a.Account__c).get(a.Year__c).get(a.Delivery_Type__c).containsKey(a.Start_Year__c)){
            	fsqMap.get(a.Account__c).get(a.Year__c).get(a.Delivery_Type__c).put(a.Start_Year__c, a);
            }
        }
    }

}