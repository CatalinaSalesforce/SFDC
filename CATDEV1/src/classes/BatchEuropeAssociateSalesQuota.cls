/*
@Name            : BatchEuropeAssociateSalesQuota  
@Author          : customersuccess@cloud62.com
@Date            : December 17th, 2012
@Description     : Associate all France_Sales_Quota_Input__c records for reporting
*/
global class BatchEuropeAssociateSalesQuota implements Database.Batchable<sObject>, Schedulable{
    
    //default Account ID if one could not be found for a user.  This should never have to be used
    private final static String DEFAULT_ACC = '001F000000pXIbx';
    
    String query;
    String limit1;
        
    
    public BatchEuropeAssociateSalesQuota(String x){
        limit1 = x;
    }
    
    public BatchEuropeAssociateSalesQuota(){
        limit1 = '';
    }
    
    //method that gets the query used for this batch
    global Database.querylocator start(Database.BatchableContext BC){
        query = 'SELECT ID, NAME, Ad_Period__c, Amount__c, Delivery_Type__c, OWNERID, '
            + ' Ad_Period__r.Start_Date__c '
            + ' FROM France_Sales_Quota_Input__c '
            + ' WHERE OWNER.ISACTIVE = TRUE '
            //+ ' WHERE AD_PERIOD__R.TYPE__C = \'Manufacturing France\' '
            + ' ORDER BY Ownerid '+ limit1;
        return Database.getQueryLocator(query);
    }
    
    global void execute(SchedulableContext ctx) {
        BatchEuropeAssociateSalesQuota batch1 = new BatchEuropeAssociateSalesQuota();
        ID batchprocessid = Database.executeBatch(batch1,10);
    }
    
    //method that makes up the body of the batch process
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        List<France_Sales_Quota_Input__c> scopeList = (List<France_Sales_Quota_Input__c>)scope;
        Set<Id> usedIDs = new set<Id>();
        Set<Id> cycleIDs = new Set<Id>();
        Set<Id> ownerIDs = new Set<Id>();
        Set<String> delChannels = new Set<String>();
        List<Program_Cycle_Amount__c> updateAmounts = new List<Program_Cycle_Amount__c>(); 
        Map<Id, List<Program_Cycle_Amount__c>> oppMap = new Map<Id, List<Program_Cycle_Amount__c>>();
        List<France_Sales_Quota_Input__c> unfoundQuotas = new List<France_Sales_Quota_Input__c>();
        //populate maps for accounts ppl own for quota opps we may need to create
        for (France_Sales_Quota_Input__c f : scopeList){
            cycleIDs.add(f.Ad_Period__c);
            ownerIDs.add(f.OwnerId);
            delChannels.add(f.Delivery_Type__c);
        }
        
        //get Map of sales people and their accounts
        Map<Id, Id> accOwnerMaps = new Map<Id, Id>();
        for (Account a : [SELECT ID, OWNERID FROM ACCOUNT WHERE OWNERID IN: ownerIds AND TYPE = 'CUSTOMER' LIMIT 5000 ]){
            if (!accOwnerMaps.containsKey(a.OwnerId)){
                accOwnerMaps.put(a.OwnerId, a.Id);
            }
        }
        
        //get PCA records that will be used for association
        List<Program_Cycle_Amount__c> progList = [SELECT ID, NAME, PROGRAM__R.OPPORTUNITY__R.ACCOUNTID,
            PROGRAM__R.DELIVERY_TYPE__C, Cycle__r.Quarter__c, Salesperson_Quota__c, Cycle__r.Name,
            PROGRAM__R.OPPORTUNITY__R.OWNERID, Program__r.Opportunity__r.Start_Date__c
            FROM PROGRAM_CYCLE_AMOUNT__C
            WHERE CYCLE__C IN :cycleIDs
            AND PROGRAM__R.OPPORTUNITY__R.OWNERID IN: ownerIDs
            AND PROGRAM__R.DELIVERY_TYPE__C IN: delChannels
            AND PROGRAM__R.OPPORTUNITY__R.START_DATE__C != NULL ];
        for (Program_Cycle_Amount__c p : progList){
            if (!oppMap.containsKey(p.Program__r.Opportunity__r.OWNERID)){
                oppMap.put(p.Program__r.Opportunity__r.OwnerId, new List<Program_Cycle_Amount__c>());
            }
            oppMap.get(p.Program__r.Opportunity__r.OwnerId).add(p);
            system.debug('***program deltype: ' + p.Program__r.Delivery_Type__c + ', cyclename: ' + p.Cycle__r.Name);
        }
        
        //for all scope records, associate to a PCA record or add to list of records to be created
        for (France_Sales_Quota_Input__c f : scopeList){
            Boolean isFound = false;
            if (oppMap.containsKey(f.OwnerId)){
                for (Program_Cycle_Amount__c p : oppMap.get(f.OwnerId)){
                    if (p.Program__r.Opportunity__r.OwnerId == f.OwnerId
                        && p.Program__r.Delivery_Type__c == f.Delivery_Type__c
                        && p.Cycle__c == f.Ad_Period__c
                        && !usedIDs.contains(p.Id)
                        && p.Program__r.Opportunity__r.Start_Date__c.year() == f.Ad_Period__r.Start_Date__c.year())
                    {
                        p.Salesperson_Quota__c = f.Id;
                        updateAmounts.add(p);
                        isFound = true;
                        usedIDs.add(p.Id);
                        break;
                    }
                }
            }
            if (!isFound){
                system.debug('***not represented: ' + f);
                unfoundQuotas.add(f);
            }
        }
        //5-31-2013 Create the dummy Opptys, Programs, and Program Cycle Amounts
        Map<Id,Opportunity> qiOppMap = new Map<Id,Opportunity>();
        for(France_Sales_Quota_Input__c f : unfoundQuotas){
            Opportunity newOpp = new Opportunity();
            newOpp.For_Reporting__c=true;
            newOpp.Name='Sales Quota Opp - '+f.Name;
            newOpp.StageName='Closed Won';
            newOpp.CloseDate=f.Ad_Period__r.Start_Date__c;
            newOpp.Start_Date__c=f.Ad_Period__r.Start_Date__c;
            if (accOwnerMaps.containsKey(f.OwnerId)){
                newOpp.AccountId=accOwnerMaps.get(f.OwnerId);
            } else {
                newOpp.AccountId = DEFAULT_ACC;
            }
            newOpp.CurrencyISOCode='EUR';
            newOpp.Catalina_Business_Unit__c=f.Delivery_Type__c;
            newOpp.OwnerId = f.OwnerId;
            qiOppMap.put(f.id,newOpp);
        }
        insert qiOppMap.values();
        
        Map<Id,Program__c> qiProgMap = new Map<Id,Program__c>();
        for(France_Sales_Quota_Input__c f : unfoundQuotas){
            Program__c newProg = new Program__c();
            newProg.Name='Quota Program - '+f.Name;
            newProg.Opportunity__c=qiOppMap.get(f.Id).Id;
            newProg.CurrencyISOCode='EUR';
            newProg.Delivery_Type__c=f.Delivery_Type__c;
            qiProgMap.put(f.id,newProg);
        }
        insert qiProgMap.values();
        
        List<Program_Cycle_Amount__c> lstPCA = new List<Program_Cycle_Amount__c>();
        for(France_Sales_Quota_Input__c f : unfoundQuotas){
            Program_Cycle_Amount__c newPCA = new Program_Cycle_Amount__c();
            newPCA.Cycle__c=f.Ad_Period__c;
            newPCA.Name='Quota Cycle Amount - '+f.Name;
            newPCA.Program__c=qiProgMap.get(f.Id).Id;
            newPCA.Salesperson_Quota__c=f.Id;
            newPCA.CurrencyISOCode='EUR';
            lstPCA.add(newPCA);
        }
        insert lstPCA;
        
        update updateAmounts;
    }
    
    //method that runs after the execute() method
    global void finish(Database.BatchableContext BC){
        System.debug(LoggingLevel.WARN,'Temp_Delete_DeleteSM1Forecast');
        //Build the system time of now + 20 seconds to schedule the batch apex.
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        //BatchDeleteManagerBestGuess acctBatch2Sched = new BatchDeleteManagerBestGuess();
        BatchEuropeAggregateSDPY acctBatch2Sched = new BatchEuropeAggregateSDPY();
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
        BatchGovernorLimitUtility.updateBatchRun();
    }

}