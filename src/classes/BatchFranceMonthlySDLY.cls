/*
@Name           : BatchFranceMonthlySDLY
@Author         : customersuccess@cloud62.com
@Date           : 2012-12-14
@Description    : Class to populate France_Monthly_Stats__c records
Dec 14 - create SDPY fields and populate based on start year
*/
global class BatchFranceMonthlySDLY implements Database.Batchable<sObject>, Schedulable{

    final static String defaultSettingsName = 'Default';
    final static String EUR = 'EUR';
    
    String query;
    String limit1;
    Set<Id> accList;
    Map<String, Map<Id, Map<Id, Map<String, Map<String, France_Monthly_Stats__c>>>>> fmsMap;
    List<France_Monthly_Stats__c> FMS;
    Map<Id, User> SR2 = New Map<Id, User>();
    Map<Id, User> SR1 = New Map<Id, User>();
    Map<Id, User> SM2 = New Map<Id, User>();
    Map<Id, User> SM1 = New Map<Id, User>();
    String rep2Type;
    String rep1Type;
    String SM2Type;
    String SM1Type;
    String coopType;
    
    public BatchFranceMonthlySDLY (String x){
        limit1 = x;
    }
    
    public BatchFranceMonthlySDLY (){
        limit1 = '';
    }
    
    global void execute(SchedulableContext ctx) {
        BatchFranceMonthlySDLY batch1 = new BatchFranceMonthlySDLY();
        ID batchprocessid = Database.executeBatch(batch1);
    }
    
    global Database.querylocator start(Database.BatchableContext BC){
    
        Batch_Log__c batchLog = new Batch_Log__c();
        
        batchLog.Start_Time__c = datetime.now();
        
        batchLog.Class_Name__c = 'BatchFranceMonthlySDLY';
        
        insert batchLog;
        //code change Jan 4th Robert: added France Total Ammount to replace total ammount
        query = 'SELECT ID, CLOSEDATE, AMOUNT, ACTUAL_AMOUNT__C, RECORDTYPE.NAME, ACCOUNTID, OWNERID, Probability, Start_Date__c,  '
            + ' (SELECT DELIVERY_TYPE__C, France_Total_Amount__c , PROGRAM_AMOUNT__C, ID FROM PROGRAMS__R) '
            + ' FROM OPPORTUNITY '
            + ' WHERE RECORDTYPE.NAME = \'CONTRACT FRANCE\' OR RECORDTYPE.NAME = \'PROPOSAL FRANCE\' '
            + ' ORDER BY ACCOUNTID, OWNERID ' + limit1;
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
        
        accList = new Set<Id>();
        List<Opportunity> oppScope = (List<Opportunity>)scope;
        
        for (Opportunity o : oppScope){
            accList.add(o.AccountId);
        }
        
        FMS = requeryFMS();
            
        populateFMSMap();
        
        List<France_Monthly_Stats__c> insertFMS = new List<France_Monthly_Stats__c>();
        
        for (Opportunity o : oppScope){
            for (Program__c p : o.Programs__r){
                Date closeDate = o.CloseDate;
                String closeMonth = String.valueOf(closeDate.year()) + '-';
                if (closeDate.month() >= 10){
                    closeMonth += closeDate.month();
                } else {
                    closeMonth += '0' + closeDate.month();
                }
                if (!fmsMap.containsKey(closeMonth)){
                    fmsMap.put(closeMonth, new Map<Id, Map<Id, Map<String, Map<String, France_Monthly_Stats__c>>>>());
                }
                if (!fmsMap.get(closeMonth).containsKey(o.AccountId)){
                    fmsMap.get(closeMonth).put(o.AccountId, new Map<Id, Map<String, Map<String, France_Monthly_Stats__c>>>());
                }
                if (!fmsMap.get(closeMonth).get(o.AccountId).containsKey(o.OwnerId)){
                    fmsMap.get(closeMonth).get(o.AccountId).put(o.OwnerId, new Map<String, Map<String, France_Monthly_Stats__c>>());
                }
                if (!fmsMap.get(closeMonth).get(o.AccountId).get(o.OwnerId).containsKey(p.Delivery_Type__c)){
                    fmsMap.get(closeMonth).get(o.AccountId).get(o.OwnerId).put(p.Delivery_Type__c, new Map<String, France_Monthly_Stats__c>());
                }
                //2012-12-14 now store records by Start Year
                String startYear = String.valueOf(o.Start_Date__c.year());
                if (!fmsMap.get(closeMonth).get(o.AccountId).get(o.OwnerId).get(p.Delivery_Type__c).containsKey(startYear)){
                    France_Monthly_Stats__c newFMS = createNewFMS(o, p);
                    insertFMS.add(newFMS);
                    fmsMap.get(closeMonth).get(o.AccountId).get(o.OwnerId).get(p.Delivery_Type__c).put(startYear, newFMS);
                }
                
                //2012-12-14 now store records by Start Year
                startYear = String.valueOf(o.Start_Date__c.year() + 1);
                closeMonth = String.valueOf(closeDate.year() + 1) + '-';
                if (closeDate.month() >= 10){
                    closeMonth += closeDate.month();
                } else {
                    closeMonth += '0' + closeDate.month();
                }
                if (!fmsMap.containsKey(closeMonth)){
                    fmsMap.put(closeMonth, new Map<Id, Map<Id, Map<String, Map<String, France_Monthly_Stats__c>>>>());
                }
                if (!fmsMap.get(closeMonth).containsKey(o.AccountId)){
                    fmsMap.get(closeMonth).put(o.AccountId, new Map<Id, Map<String, Map<String, France_Monthly_Stats__c>>>());
                }
                if (!fmsMap.get(closeMonth).get(o.AccountId).containsKey(o.OwnerId)){
                    fmsMap.get(closeMonth).get(o.AccountId).put(o.OwnerId, new Map<String, Map<String, France_Monthly_Stats__c>>());
                }
                if (!fmsMap.get(closeMonth).get(o.AccountId).get(o.OwnerId).containsKey(p.Delivery_Type__c)){
                    fmsMap.get(closeMonth).get(o.AccountId).get(o.OwnerId).put(p.Delivery_Type__c, new Map<String, France_Monthly_Stats__c>());
                }
                //2012-12-14 now store records by Start Year
                if (!fmsMap.get(closeMonth).get(o.AccountId).get(o.OwnerId).get(p.Delivery_Type__c).containsKey(startYear)){
                    France_Monthly_Stats__c newFMS = createNewFMSNY(o, p);
                    insertFMS.add(newFMS);
                    fmsMap.get(closeMonth).get(o.AccountId).get(o.OwnerId).get(p.Delivery_Type__c).put(startYear, newFMS);
                }
            }
        }
        
        insert insertFMS;
        
        FMS = requeryFMS();
        
        populateFMSMap();
        
        for (Opportunity o : oppScope){
            for (Program__c p : o.Programs__r){
                String startYear = String.valueOf(o.Start_Date__c.year());
                Date closeDate = o.CloseDate;
                String closeMonth = String.valueOf(closeDate.year()) + '-';
                if (closeDate.month() >= 10){
                    closeMonth += String.valueOf(closeDate.month());
                } else {
                    closeMonth += '0' + closeDate.month();
                }
                France_Monthly_Stats__c f = fmsMap.get(closeMonth).get(o.AccountId).get(o.OwnerId).get(p.Delivery_Type__c).get(startYear);
                if (o.RecordType.Name == 'Contract France'){
                    //code change Jan 4th Robert: added France Total Ammount to replace total ammount
                    f.Booked__c += p.France_Total_Amount__c;
                } else if (o.RecordType.Name == 'Proposal France'){
                    f.Total_Proposal__c += (p.Program_Amount__c == null ? 0 : p.Program_Amount__c);
                    f.Weighted_Proposal__c += (p.Program_Amount__c == null ? 0 : p.Program_Amount__c) * o.Probability/100;
                }
                
                //2012-12-14 now store records by Start Year
                startYear = String.valueOf(o.Start_Date__c.year() + 1);
                closeMonth = String.valueOf(closeDate.year() + 1) + '-';
                if (closeDate.month() >= 10){
                    closeMonth += String.valueOf(closeDate.month());
                } else {
                    closeMonth += '0' + closeDate.month();
                }
                France_Monthly_Stats__c f1 = fmsMap.get(closeMonth).get(o.AccountId).get(o.OwnerId).get(p.Delivery_Type__c).get(startYear);
                if (o.RecordType.Name == 'Contract France'){
                    //code change Jan 4th Robert: added France Total Ammount to replace total ammount
                    f1.SDLY__c += p.France_Total_Amount__c;
                }
            }
        }
        
        update FMS;
    }
    
    global void finish(Database.BatchableContext BC){
        
        List<Batch_Log__c> batchLog = [select ID from Batch_Log__c where Class_Name__c = 'BatchFranceMonthlySDLY' AND Start_Time__c >: datetime.now().addDays(-1) ORDER BY Start_Time__c desc limit 1];
        
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
        BatchFranceDeleteAccountQuota acctBatch2Sched = new BatchFranceDeleteAccountQuota();
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
    }
    
    private France_Monthly_Stats__c createNewFMS(Opportunity o, Program__c p){
        France_Monthly_Stats__c f = new France_Monthly_Stats__c();
        f.CurrencyIsoCode = EUR;
        f.Year__c = String.valueOf(o.CloseDate.year());
        f.Delivery_Type__c = p.Delivery_Type__c;
        if (o.closeDate.month() >= 10){
            f.Month__c = String.valueOf(o.closeDate.month()); 
        } else {
            f.Month__c = '0' + o.closeDate.month();
        }
        f.Account__c = o.AccountId;
        f.OwnerId = o.OwnerId;
        f.Booked__c = 0;
        f.Weighted_Proposal__c = 0;
        f.Total_Proposal__c = 0;
        f.SDLY__c = 0;
        //2012-12-14 now store records by Start Year
        f.Start_Year__c = String.valueOf(o.Start_Date__c.year());
        
        if (SR2.containsKey(f.OwnerId)){
            f.SR2__c = f.OwnerId;
            f.SR1__c = SR2.get(f.OwnerId).ManagerId;
            if (f.SR1__c != null){
                if (SR1.containsKey(f.SR1__c)) f.SM2__c = SR1.get(f.SR1__c).ManagerId;
            }
            if (f.SM2__c != null){
                if (SM2.containsKey(f.SM2__c)) f.SM1__c = SM2.get(f.SM2__c).ManagerId;
            }
            if (f.SM1__c != null){
                if (SM1.containsKey(f.SM1__c)) f.EVP__c = SM1.get(f.SM1__c).ManagerId;
            }
        } else if (SR1.containsKey(f.OwnerId)){
            f.SR1__c = f.OwnerId;
            f.SM2__c = SR1.get(f.SR1__c).ManagerId;
            if (f.SM2__c != null){
                if (SM2.containsKey(f.SM2__c)) f.SM1__c = SM2.get(f.SM2__c).ManagerId;
            }
            if (f.SM1__c != null){
                if (SM1.containsKey(f.SM1__c)) f.EVP__c = SM1.get(f.SM1__c).ManagerId;
            }
        } else if (SM2.containsKey(f.OwnerId)){
            f.SM2__c = f.OwnerId;
            f.SM1__c = SM2.get(f.SM2__c).ManagerId;
            if (f.SM1__c != null){
                if (SM1.containsKey(f.SM1__c)) f.EVP__c = SM1.get(f.SM1__c).ManagerId;
            }
        } else if (SM1.containsKey(f.OwnerId)){
            f.SM1__c = f.OwnerId;
            f.EVP__c = SM1.get(f.SM1__c).ManagerId;
        }
        
        return f;
    }
    
    private France_Monthly_Stats__c createNewFMSNY(Opportunity o, Program__c p){
        France_Monthly_Stats__c f = new France_Monthly_Stats__c();
        f.CurrencyIsoCode = EUR;
        f.Year__c = String.valueOf(o.CloseDate.year() + 1);
        f.Delivery_Type__c = p.Delivery_Type__c;
        if (o.closeDate.month() >= 10){
            f.Month__c = String.valueOf(o.closeDate.month()); 
        } else {
            f.Month__c = '0' + o.closeDate.month();
        }
        f.Account__c = o.AccountId;
        f.OwnerId = o.OwnerId;
        f.Booked__c = 0;
        f.Weighted_Proposal__c = 0;
        f.Total_Proposal__c = 0;
        f.SDLY__c = 0;
        //2012-12-14 now store records by Start Year
        f.Start_Year__c = String.valueOf(o.Start_Date__c.year() + 1);
        
        if (SR2.containsKey(f.OwnerId)){
            f.SR2__c = f.OwnerId;
            f.SR1__c = SR2.get(f.OwnerId).ManagerId;
            if (f.SR1__c != null){
                if (SR1.containsKey(f.SR1__c)) f.SM2__c = SR1.get(f.SR1__c).ManagerId;
            }
            if (f.SM2__c != null){
                if (SM2.containsKey(f.SM2__c)) f.SM1__c = SM2.get(f.SM2__c).ManagerId;
            }
            if (f.SM1__c != null){
                if (SM1.containsKey(f.SM1__c)) f.EVP__c = SM1.get(f.SM1__c).ManagerId;
            }
        } else if (SR1.containsKey(f.OwnerId)){
            f.SR1__c = f.OwnerId;
            f.SM2__c = SR1.get(f.SR1__c).ManagerId;
            if (f.SM2__c != null){
                if (SM2.containsKey(f.SM2__c)) f.SM1__c = SM2.get(f.SM2__c).ManagerId;
            }
            if (f.SM1__c != null){
                if (SM1.containsKey(f.SM1__c)) f.EVP__c = SM1.get(f.SM1__c).ManagerId;
            }
        } else if (SM2.containsKey(f.OwnerId)){
            f.SM2__c = f.OwnerId;
            f.SM1__c = SM2.get(f.SM2__c).ManagerId;
            if (f.SM1__c != null){
                if (SM1.containsKey(f.SM1__c)) f.EVP__c = SM1.get(f.SM1__c).ManagerId;
            }
        } else if (SM1.containsKey(f.OwnerId)){
            f.SM1__c = f.OwnerId;
            f.EVP__c = SM1.get(f.SM1__c).ManagerId;
        }
        
        return f;
    }
    
    private List<France_Monthly_Stats__c> requeryFMS(){
        return [SELECT ID, OWNERID, ACCOUNT__C, BOOKED__C, WEIGHTED_PROPOSAL__C, Total_Proposal__c,
            SDLY__c, YEAR__C, MONTH__C, Delivery_Type__c, Start_Year__c
            from France_Monthly_Stats__c
            Where ACCOUNT__C IN :accList];
    }
    
    private void populateFMSMap(){
        fmsMap = new Map<String, Map<Id, Map<Id, Map<String, Map<String, France_Monthly_Stats__c>>>>>();
        for (France_Monthly_Stats__c f : FMS){
            if (!fmsMap.containsKey(f.Year__c + '-' + f.Month__c)){
                fmsMap.put(f.Year__c + '-' + f.Month__c, new Map<Id, Map<Id,  Map<String, Map<String, France_Monthly_Stats__c>>>>());
            }
            if (!fmsMap.get(f.Year__c + '-' + f.Month__c).containsKey(f.Account__c)){
                fmsMap.get(f.Year__c + '-' + f.Month__c).put(f.Account__c, new Map<Id,  Map<String, Map<String, France_Monthly_Stats__c>>>());
            }
            if (!fmsMap.get(f.Year__c + '-' + f.Month__c).get(f.Account__c).containsKey(f.OwnerId)){
                fmsMap.get(f.Year__c + '-' + f.Month__c).get(f.Account__c).put(f.OwnerId, new  Map<String, Map<String, France_Monthly_Stats__c>>());
            }
            if (!fmsMap.get(f.Year__c + '-' + f.Month__c).get(f.Account__c).get(f.OwnerId).containsKey(f.Delivery_Type__c)){
                fmsMap.get(f.Year__c + '-' + f.Month__c).get(f.Account__c).get(f.OwnerId).put(f.Delivery_Type__c, new Map<String, France_Monthly_Stats__c>());
            }
            //2012-12-14 now store records by Start Year
            if (!fmsMap.get(f.Year__c + '-' + f.Month__c).get(f.Account__c).get(f.OwnerId).get(f.Delivery_Type__c).containsKey(f.Start_Year__c)){
                fmsMap.get(f.Year__c + '-' + f.Month__c).get(f.Account__c).get(f.OwnerId).get(f.Delivery_Type__c).put(f.Start_Year__c, f);
            }
        }
    }

}