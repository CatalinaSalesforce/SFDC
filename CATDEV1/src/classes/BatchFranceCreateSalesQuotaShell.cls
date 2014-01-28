/*
@Name           : BatchFranceSalespersonQuota
@Author         : customersuccess@cloud62.com
@Date           : 2012-12-14
@Description    : Class to create France_Salesperson_Quota__c shell records
Dec 14 - create SDPY fields and populate based on start year
Mar 6 2013 - do not create records for inactive users
*/
global class BatchFranceCreateSalesQuotaShell implements Database.Batchable<sObject>, Schedulable{
    
    final static String defaultSettingsName = 'Default';
    final static String EUR = 'EUR';
    
    String query;
    String limit1;
    Map<Id, User> SR2 = New Map<Id, User>();
    Map<Id, User> SR1 = New Map<Id, User>();
    Map<Id, User> SM2 = New Map<Id, User>();
    Map<Id, User> SM1 = New Map<Id, User>();
    String rep2Type;
    String rep1Type;
    String SM2Type;
    String SM1Type;
    String coopType;
    
    public BatchFranceCreateSalesQuotaShell (String x){
        limit1 = x;
    }
    
    public BatchFranceCreateSalesQuotaShell (){
        limit1 = '';
    }
    
    global void execute(SchedulableContext ctx) {
        BatchFranceCreateSalesQuotaShell batch1 = new BatchFranceCreateSalesQuotaShell();
        ID batchprocessid = Database.executeBatch(batch1, 200);
    }
    
    global Database.querylocator start(Database.BatchableContext BC){
    
        Batch_Log__c batchLog = new Batch_Log__c();
        
        batchLog.Start_Time__c = datetime.now();
        
        batchLog.Class_Name__c = 'BatchFranceCreateSalesQuotaShell';
        
        insert batchLog;
    
        query = 'SELECT ID, OWNERID, AD_PERIOD__C, Ad_Period__r.Start_Date__c, AMOUNT__C, Delivery_Type__c '
            + 'FROM France_Sales_Quota_Input__c '
            //added by Warren Mar 6 2013
            + 'WHERE OWNERID IN (SELECT ID FROM USER WHERE ISACTIVE = TRUE) '
            + limit1;
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        List<France_Sales_Quota_Input__c> scope1 = (List<France_Sales_Quota_Input__c>)scope;
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
        
        List<France_Salesperson_Quota__c> insertFSQ = new List<France_Salesperson_Quota__c>();
        
        for (France_Sales_Quota_Input__c fsqi : scope1){
            France_Salesperson_Quota__c fsq = new France_Salesperson_Quota__c();
            fsq.CurrencyIsoCode = EUR;
            fsq.Delivery_Type__c = fsqi.Delivery_Type__c;
            fsq.OwnerId = fsqi.OwnerId;
            fsq.Ad_Period__c = fsqi.Ad_Period__c;
            fsq.Quota__c = fsqi.Amount__c;
            fsq.Booked__c = 0;
            fsq.SDLY__c = 0;
            fsq.SDPY__c = 0;
            fsq.Weighted_Proposal__c = 0;
            fsq.Overprint__c = 0;
            //2012-12-14 now store records by Start Year
            fsq.Start_Year__c = String.valueOf(fsqi.Ad_Period__r.Start_Date__c.year());
            
            if (SR2.containsKey(fsq.OwnerId)){
                fsq.SR2__c = fsq.OwnerId;
                fsq.SR1__c = SR2.get(fsq.OwnerId).ManagerId;
                if (fsq.SR1__c != null){
                    if (SR1.containsKey(fsq.SR1__c)) fsq.SM2__c = SR1.get(fsq.SR1__c).ManagerId;
                }
                if (fsq.SM2__c != null){
                    if (SM2.containsKey(fsq.SM2__c)) fsq.SM1__c = SM2.get(fsq.SM2__c).ManagerId;
                }
                if (fsq.SM1__c != null){
                    if (SM1.containsKey(fsq.SM1__c)) fsq.EVP__c = SM1.get(fsq.SM1__c).ManagerId;
                }
            } else if (SR1.containsKey(fsq.OwnerId)){
                fsq.SR1__c = fsq.OwnerId;
                fsq.SM2__c = SR1.get(fsq.SR1__c).ManagerId;
                if (fsq.SM2__c != null){
                    if (SM2.containsKey(fsq.SM2__c)) fsq.SM1__c = SM2.get(fsq.SM2__c).ManagerId;
                }
                if (fsq.SM1__c != null){
                    if (SM1.containsKey(fsq.SM1__c)) fsq.EVP__c = SM1.get(fsq.SM1__c).ManagerId;
                }
            } else if (SM2.containsKey(fsq.OwnerId)){
                fsq.SM2__c = fsq.OwnerId;
                fsq.SM1__c = SM2.get(fsq.SM2__c).ManagerId;
                if (fsq.SM1__c != null){
                    if (SM1.containsKey(fsq.SM1__c)) fsq.EVP__c = SM1.get(fsq.SM1__c).ManagerId;
                }
            } else if (SM1.containsKey(fsq.OwnerId)){
                fsq.SM1__c = fsq.OwnerId;
                fsq.EVP__c = SM1.get(fsq.SM1__c).ManagerId;
            }
            insertFSQ.add(fsq);
        }
        
        insert insertFSQ;
    }
    
    global void finish(Database.BatchableContext BC){
        
        List<Batch_Log__c> batchLog = [select ID from Batch_Log__c where Class_Name__c = 'BatchFranceCreateSalesQuotaShell' AND Start_Time__c >: datetime.now().addDays(-1) ORDER BY Start_Time__c desc limit 1];
        
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
        BatchFranceSalespersonQuota acctBatch2Sched = new BatchFranceSalespersonQuota();
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
    }

}