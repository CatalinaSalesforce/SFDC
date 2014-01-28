/*
@Name            : BatchEuropeAssociateAccountQuota  
@Author          : customersuccess@cloud62.com
@Date            : June 1 2013
@Description     : Class to associate France_Account_Quota_Input__c records to program cycle amount records for reporting
@Revision History: 5-31-2013 Added functionality to create dummy oppty's, programs, and program cycle amounts to attach quota inputs to the account
*/
global class BatchEuropeAssociateAccountQuota implements Database.Batchable<sObject>, Schedulable{
    
    String query;
    String limit1;
    
    public BatchEuropeAssociateAccountQuota(String x){
        limit1 = x;
    }
    
    public BatchEuropeAssociateAccountQuota(){
        limit1 = '';
    }
    
    //method that gets the query used for this batch
    global Database.querylocator start(Database.BatchableContext BC){
        query = 'SELECT ID, NAME, Year__c, Account__c, Account__r.RecordType.Name, Account__r.Type, Amount__c, Delivery_Type__c, OWNERID '
            + ' FROM FRANCE_ACCOUNT_QUOTA_INPUT__C '
            //+ ' WHERE ACCOUNT__R.RECORDTYPE.NAME = \'MANUFACTURING FRANCE\' '
            + ' ORDER BY ACCOUNT__C '+ limit1;
        return Database.getQueryLocator(query);
    }
    
    global void execute(SchedulableContext ctx) {
        BatchEuropeAssociateAccountQuota batch1 = new BatchEuropeAssociateAccountQuota();
        ID batchprocessid = Database.executeBatch(batch1,50);
    }
    
    //method that makes up the body of the batch process
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        List<France_Account_Quota_Input__c> scopeList = (List<France_Account_Quota_Input__c>)scope;
        Set<Id> accountIDs = new Set<Id>();
        Set<Id> ownerIDs = new Set<Id>();
        Set<String> delChannels = new Set<String>();
        Set<Program_Cycle_Amount__c> updateAmounts = new Set<Program_Cycle_Amount__c>(); 
        Map<Id, Program_Cycle_Amount__c> pcycleTempMap = new Map<Id, Program_Cycle_Amount__c>();
        Map<Id, Set<Program_Cycle_Amount__c>> oppMap = new Map<Id, Set<Program_Cycle_Amount__c>>();
        //5-31-2013 Added to store the list of quota inputs that are not represented
        List<France_Account_Quota_Input__c> unfoundQuotas = new List<France_Account_Quota_Input__c>();
        Set<Integer> quotaYears = new Set<Integer>();
        
        for (France_Account_Quota_Input__c f : scopeList){
            accountIDs.add(f.Account__c);
            ownerIDs.add(f.OwnerId);
            delChannels.add(f.Delivery_Type__c);
        }
        
        //get all Program Cycle Amount records that can be used for association and put in a map
        List<Program_Cycle_Amount__c> progList = [SELECT ID, NAME, PROGRAM__R.OPPORTUNITY__R.ACCOUNTID,
            PROGRAM__R.DELIVERY_TYPE__C, Cycle__r.Quarter__c, Account_Quota__c,
            PROGRAM__R.OPPORTUNITY__R.OWNERID, Program__r.Opportunity__r.Start_Date__c
            FROM PROGRAM_CYCLE_AMOUNT__C
            WHERE PROGRAM__R.OPPORTUNITY__R.ACCOUNTID IN :accountIDs
            //AND PROGRAM__R.OPPORTUNITY__R.OWNERID IN: ownerIDs
            AND PROGRAM__R.DELIVERY_TYPE__C IN: delChannels];
        for (Program_Cycle_Amount__c p : progList){
            if (!oppMap.containsKey(p.Program__r.Opportunity__r.AccountId)){
                oppMap.put(p.Program__r.Opportunity__r.AccountId, new Set<Program_Cycle_Amount__c>());
            }
            oppMap.get(p.Program__r.Opportunity__r.AccountId).add(p);
        }
        
        //make associations wherever possible, if not possible, add to list for oppty creation
        for (France_Account_Quota_Input__c f : scopeList){
            Boolean isFound = false;
            if (oppMap.containsKey(f.Account__c)){
                for (Program_Cycle_Amount__c p : oppMap.get(f.Account__c)){
                	if (p.Program__r.Opportunity__r.Start_Date__c != null){
	                    if (//p.Program__r.Opportunity__r.OwnerId == f.OwnerId &&
	                         p.Program__r.Delivery_Type__c == f.Delivery_Type__c
	                        && p.Cycle__r.Quarter__c.contains(f.Year__c)
	                        //code added by Warren to make sure Quotas goto the right year
	                        && String.valueOf(p.Program__r.Opportunity__r.Start_Date__c.year()) == f.Year__c)
	                    {
	                        p.Account_Quota__c = f.Id;
	                        if(!pcycleTempMap.containsKey(p.Id)){
	                            updateAmounts.add(p);
	                            pcycleTempMap.put(p.Id,p);
	                        }
	                        isFound = true;
	                        break;
	                    }
                	}
                }
            }
            if (!isFound){
                system.debug('***not represented: ' + f.Id);
                //5-31-2013 Add unfound items to map and add create the dummy opps
                if(f.Account__c != null && f.Account__r.Type != 'Conglomerate' && f.Year__c != null && f.Year__c.isNumeric()){
                    unfoundQuotas.add(f);
                    quotaYears.add(Integer.valueOf(f.Year__c));
                } 
            }
        }
        //5-31-2013 Create the dummy Opptys, Programs, and Program Cycle Amounts
        Map<Id,Opportunity> qiOppMap = new Map<Id,Opportunity>();
        for(France_Account_Quota_Input__c f : unfoundQuotas){
            qiOppMap.put(f.id,new Opportunity(For_Reporting__c=true,Name='Quota Opp - '+f.Name,Catalina_Business_Unit__c=f.Delivery_Type__c,StageName='Closed Won',CloseDate=Date.newInstance(Integer.valueOf(f.Year__c),1,1),Start_Date__c=Date.newInstance(Integer.valueOf(f.Year__c),1,1),AccountId=f.Account__c,CurrencyISOCode='EUR'));
        }
        insert qiOppMap.values();
        Map<Id,Program__c> qiProgMap = new Map<Id,Program__c>();
        for(France_Account_Quota_Input__c f : unfoundQuotas){
            qiProgMap.put(f.id,new Program__c(Name='Quota Program - '+f.Name,Opportunity__c=qiOppMap.get(f.Id).Id,CurrencyISOCode='EUR',Delivery_Type__c=f.Delivery_Type__c));
        }
        insert qiProgMap.values();
        Map<Integer,Ad_Period__c> yearPeriods = new Map<Integer,Ad_Period__c>();
        List<Ad_Period__c> lstPeriods = [SELECT Id,Type__c,Start_Date__c FROM Ad_Period__c WHERE CALENDAR_YEAR(Start_Date__c) IN :quotaYears];
        List<Program_Cycle_Amount__c> lstPCA = new List<Program_Cycle_Amount__c>();
        for(France_Account_Quota_Input__c f : unfoundQuotas){
            Ad_Period__c ap;
            for(Ad_Period__c apTemp : lstPeriods){
                if(apTemp.Type__c == f.Account__r.RecordType.Name && apTemp.Start_Date__c.year() == Integer.valueOf(f.Year__c)){
                    ap = apTemp;
                }
            }
            if(ap != null){ //Use existing ad periods
                lstPCA.add(new Program_Cycle_Amount__c(Cycle__c=ap.Id,Name='Quota Cycle Amount - '+f.Name,Program__c=qiProgMap.get(f.Id).Id,Account_Quota__c=f.Id,CurrencyISOCode='EUR'));
            }
        }
        insert lstPCA;
        
        update new List<Program_Cycle_Amount__c>(updateAmounts);
    }
    
    //method that runs after the execute() method
    global void finish(Database.BatchableContext BC){
        System.debug(LoggingLevel.WARN,'Temp_Delete_DeleteSM1Forecast');
        //Build the system time of now + 20 seconds to schedule the batch apex.
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        BatchEuropeAssociateSalesQuota acctBatch2Sched = new BatchEuropeAssociateSalesQuota();
        //BatchLogInactiveOwner acctBatch2Sched = new BatchLogInactiveOwner();
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
        BatchGovernorLimitUtility.updateBatchRun();
    }

}