global class BatchFranceClientTrend implements Database.Batchable<sObject>, Schedulable{

    static String[] months = new String[]{'01','02','03','04','05','06','07','08','09','10','11','12'};
    final static String EUR = 'EUR';
    List<String> years;
    
    String query;
    String limit1;
    Set<Id> accList;
    Map<String, Map<Id, France_Client_Trend__c>> fctMap;
    List<France_Client_Trend__c> FCT;
    Map<Id, Map<String, List<France_Account_Quota_Input__c>>> quotaMap;
    
    public BatchFranceClientTrend (String x){
        limit1 = x;
    }
    
    public BatchFranceClientTrend (){
        limit1 = '';
    }
    
    global void execute(SchedulableContext ctx) {
        BatchFranceClientTrend batch1 = new BatchFranceClientTrend();
        ID batchprocessid = Database.executeBatch(batch1, 50);
    }
    
    global Database.querylocator start(Database.BatchableContext BC){
    
        Batch_Log__c batchLog = new Batch_Log__c();
        
        batchLog.Start_Time__c = datetime.now();
        
        batchLog.Class_Name__c = 'BatchFranceClientTrend';
        
        insert batchLog;
    
        query = 'SELECT ID, CLOSEDATE, AMOUNT, ACTUAL_AMOUNT__C, RECORDTYPE.NAME, ACCOUNTID, OWNERID, Probability '
            + ' FROM OPPORTUNITY '
            + ' WHERE RECORDTYPE.NAME = \'CONTRACT FRANCE\' OR RECORDTYPE.NAME = \'PROPOSAL FRANCE\' '
            + ' ORDER BY ACCOUNTID, OWNERID ' + limit1;
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        years = new List<String>();
        years.add(String.valueOf(Date.today().year()));
        years.add(String.valueOf(Date.today().year() - 1));
        years.add(String.valueOf(Date.today().year() - 2));
        years.add(String.valueOf(Date.today().year() - 3));
        years.add(String.valueOf(Date.today().year() + 1));
        
        accList = new Set<Id>();
        List<Opportunity> oppScope = (List<Opportunity>)scope;
        
        for (Opportunity o : oppScope){
            accList.add(o.AccountId);
        }
        
        quotaMap = new Map<Id, Map<String, List<France_Account_Quota_Input__c>>>();
        
        List<France_Account_Quota_Input__c> FSQI = [SELECT ID, OWNERID, Year__c, Account__c, AMOUNT__C, Delivery_Type__c
            FROM France_Account_Quota_Input__c Where Account__c IN :accList];
            
        for (France_Account_Quota_Input__c a : FSQI){
            if (!quotaMap.containsKey(a.Account__c)){
                quotaMap.put(a.Account__c, new Map<String, List<France_Account_Quota_Input__c>>());
            }
            if (!quotaMap.get(a.Account__c).containsKey(a.Year__c)){
                quotaMap.get(a.Account__c).put(a.Year__c, new List<France_Account_Quota_Input__c>());
            }
            quotaMap.get(a.Account__c).get(a.Year__c).add(a);
        }
        
        FCT = requeryFCT();
            
        populateFCTMap();
        
        List<France_Client_Trend__c> insertFCT = new List<France_Client_Trend__c>();
        
        for (String accID : accList){
            for (String year : years){
                for (String month : months){
                    String closeMonth = year + '-' + month;
                    if (!fctMap.containsKey(closeMonth)){
                        fctMap.put(closeMonth, new Map<Id, France_Client_Trend__c>());
                    }
                    if (!fctMap.get(closeMonth).containsKey(accID)){
                        fctMap.get(closeMonth).put(accID, null);
                    }
                    if (fctMap.get(closeMonth).get(accID) == null){
                        France_Client_Trend__c newFCT = createNewFCT(year, month, accID);
                        insertFCT.add(newFCT);
                        fctMap.get(closeMonth).remove(accID);
                        fctMap.get(closeMonth).put(accID, newFCT);
                    }
                }
            }
        }
        
        insert insertFCT;
        
        FCT = requeryFCT();
        
        populateFCTMap();
        
        for (France_Client_Trend__c f : FCT){
            if (f.Month__c != '01'){
                if (getLastMonth(f) != null) f.Last_Month__c = getLastMonth(f).Id;
            }
        }
        
        for (Opportunity o : oppScope){
            Date closeDate = o.CloseDate;
            String closeMonth = String.valueOf(closeDate.year()) + '-';
            if (closeDate.month() >= 10){
                closeMonth += String.valueOf(closeDate.month());
            } else {
                closeMonth += '0' + closeDate.month();
            }
            //added by Warren to catch opps that arent within scope
            if (fctMap.containsKey(closeMonth)){
            	if (fctMap.get(closeMonth).containsKey(o.AccountId)){
            		if (fctMap.get(closeMonth).get(o.AccountId) != null){
			            France_Client_Trend__c f = fctMap.get(closeMonth).get(o.AccountId);
			            if (o.RecordType.Name == 'Contract France'){
			                f.Booked__c += o.Actual_Amount__c;
			                //system.debug(LoggingLevel.ERROR, 'close Month: ' + closeMonth);
			                if (closeMonth.substring(closeMonth.length() - 2) == '01'){
			                    //if (f.Carryover__c == null) f.Carryover__c = 0;
			                    //system.debug(LoggingLevel.ERROR, 'actual before: ' + f.Carryover__c);
			                    //f.Carryover__c += o.Actual_Amount__c;
			                    //system.debug(LoggingLevel.ERROR, 'actual after: ' + f.Carryover__c);
			                    f.Carryover__c = f.Booked__c;
			                }
			            }
            		}
            	}
            }
            
        }
        
        update FCT;
    }
    
    global void finish(Database.BatchableContext BC){
        
        List<Batch_Log__c> batchLog = [select ID from Batch_Log__c where Class_Name__c = 'BatchFranceClientTrend' AND Start_Time__c >: datetime.now().addDays(-1) ORDER BY Start_Time__c desc limit 1];
        
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
        BatchFranceRollUpClientTrend acctBatch2Sched = new BatchFranceRollUpClientTrend();
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('acctBatch2Job' + sysTime.getTime(),chron_exp,acctBatch2Sched);
    }
    
    private France_Client_Trend__c createNewFCT(Opportunity o){
        France_Client_Trend__c f = new France_Client_Trend__c();
        f.CurrencyIsoCode = EUR;
        f.Year__c = String.valueOf(o.CloseDate.year());
        if (o.closeDate.month() >= 10){
            f.Month__c = String.valueOf(o.closeDate.month()); 
        } else {
            f.Month__c = '0' + o.closeDate.month();
        }
        f.Account__c = o.AccountId;
        f.Booked__c = 0;
        f.Carryover__c = 0;
        return f;
    }
    
    private France_Client_Trend__c createNewFCT(String year, String month, string accId){
        France_Client_Trend__c f = new France_Client_Trend__c();
        f.CurrencyIsoCode = EUR;
        f.Year__c = year;
        f.Month__c = month;
        f.Account__c = accID;
        f.Booked__c = 0;
        f.Carryover__c = 0;
        Decimal quotaAmt = 0;
        if (month == '01'){
            if (quotaMap.containsKey(accId)){
                if (quotaMap.get(accId).containsKey(year)){
                    for (France_Account_Quota_Input__c faqi : quotaMap.get(accId).get(year)){
                        quotaAmt += (faqi.Amount__c == null ? 0 : faqi.Amount__c);
                    }
                }
            }
        }
        f.Quota__c = quotaAmt;
        return f;
    }
    
    private List<France_Client_Trend__c> requeryFCT(){
        return [SELECT ID, ACCOUNT__C, BOOKED__C, YEAR__C, MONTH__C
            from France_Client_Trend__c 
            Where ACCOUNT__C IN :accList];
    }
    
    private void populateFCTMap(){
        fctMap = new Map<String, Map<Id, France_Client_Trend__c>>();
        for (France_Client_Trend__c f : FCT){
            if (!fctMap.containsKey(f.Year__c + '-' + f.Month__c)){
                fctMap.put(f.Year__c + '-' + f.Month__c, new Map<Id, France_Client_Trend__c>());
            }
            if (!fctMap.get(f.Year__c + '-' + f.Month__c).containsKey(f.Account__c)){
                fctMap.get(f.Year__c + '-' + f.Month__c).put(f.Account__c, f);
            }
        }
    }
    
    private France_Client_Trend__c getLastMonth(France_Client_Trend__c f){
        France_Client_Trend__c result = null;
        String closeMonth = f.Year__c + '-';
        if (f.Month__c != '11' && f.Month__c != '12'){
            closeMonth += '0' + String.valueOf(Integer.valueOf(f.Month__c) - 1);
        } else {
            closeMonth += String.valueOf(Integer.valueOf(f.Month__c) - 1);
            //system.debug(LoggingLevel.ERROR, '***month: ' + f.Month__c + ', closeMonth: ' + closeMonth);
        }
        if(fctMap.containsKey(closeMonth)){
            if (fctMap.get(closeMonth).containsKey(f.Account__c)){
                result = fctMap.get(closeMonth).get(f.Account__c);
            }
        }
        return result;
    }

}