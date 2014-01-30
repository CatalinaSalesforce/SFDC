/*
@Name           :       BatchJapanArchiveForecast
@Author         :       Warren
@Date           :       Jan 20 2012
@Description    :       Batch class designed to:
                            - create a snapshot of the current program forecasts, and store this information for comparison later
                            - create programs and product type splits for all program forecasts
                            
*/

global class BatchJapanArchiveForecast implements Database.Batchable<sObject>, Schedulable{
    
    final static String contractRT = 'Archive_Program_Contract';
    final static String proposalRT = 'Archive_Program_Proposal';
    
    String query;
    String limit1;
    Set<ID> oppList;
    Set<ID> programList;
    List<Archive_Program__c> ap;
    List<Archive_Program_Forecast__c> apf;
    List<Archive_Product_Type_Split__c> apts;
    List<Archive_Program__c> insertAP;
    List<Archive_Product_Type_Split__c> insertAPTS;
    List<Archive_Program_Forecast__c> insertAPF;
    List<Program__c> programs;
    List<Product_Type_Split__c> pts;
    Map<Id, Id> programMap;
    Map<Id, Ad_Period__c> adPeriodsMap;
    String contractAPRT;
    String proposalAPRT;
    
    public BatchJapanArchiveForecast (String x){
        limit1 = x;
    }
    
    public BatchJapanArchiveForecast (){
        limit1 = '';
    }
    
    global void execute(SchedulableContext ctx) {
        BatchJapanArchiveForecast batch1 = new BatchJapanArchiveForecast();
        ID batchprocessid = Database.executeBatch(batch1);
    }
    
    //method that gets the query used for this batch
    global Database.querylocator start(Database.BatchableContext BC){
    
        
        AggregateResult ar = [Select Max(Archive_Date__c) Expr1 From Archive_Program__c Where Archive_Date__c <= :Date.Today() and Archive_Date__c >= :Date.today().addDays(-30) AND OPPORTUNITY__R.RECORDTYPE.NAME IN ('PROPOSAL JAPAN','CONTRACT JAPAN')]; 
        Date archiveDate = (Date)ar.get('Expr1');
        System.debug('***use date: ' +  archiveDate);
        
        if (archiveDate < Date.today().addDays(-8)){
            query = 'Select p.Weighted_Previous_Quarter_Forecast__c, p.Weighted_Next_Quarter_Forecast__c, p.Weighted_Forecast_Amount__c, ' + 
            'p.Program__c, p.Previous_Quarter_Ratio__c, p.Previous_Quarter_Amount__c, p.Previous_Quarter_Actual__c, p.Oppty_Probability__c, p.Program__r.RecordType.Name, ' +
            'p.Next_Quarter_Ratio__c, p.Next_Quarter_Amount__c, p.Next_Quarter_Actual__c, p.Name, p.Id, p.Ad_Period__c, p.Start_Date__c, p.End_Date__c, ' +
            'p.Actual_Amount__c, p.Program__r.Opportunity__c, p.Forecast_Amount__c, p.Program__r.Delivery_Type__c, p.External_ID__c, Active__c From Program_Forecast__c p ' +
            //'WHERE p.Program__r.Name Like \'Cloud62%\' ' +
            'WHERE (p.PROGRAM__R.OPPORTUNITY__R.RECORDTYPE.NAME = \'CONTRACT JAPAN\' OR p.PROGRAM__R.OPPORTUNITY__R.RECORDTYPE.NAME = \'PROPOSAL JAPAN\') ' + 
            'ORDER BY p.Program__r.Opportunity__r.Account.Id, p.Program__r.Opportunity__c, p.Program__c '
            + limit1;
        }
        else {
            query = 'SELECT ID FROM USER WHERE ID != NULL AND ID = NULL ';
            system.debug(LoggingLevel.Warn, '***Not running archive this week');
        }
        return Database.getQueryLocator(query);
    }
    
    //method that makes up the body of the batch process
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        
        contractAPRT = [SELECT Id From RecordType Where DeveloperName = :contractRT][0].Id;
        proposalAPRT = [SELECT Id From RecordType Where DeveloperName = :proposalRT][0].Id;
        system.debug('***contractID: ' + contractAPRT);
        system.debug('***proposalID: ' + proposalAPRT);
        adPeriodsMap = new Map<Id, Ad_Period__c>([Select Id, Start_Date__c, End_Date__c, Name From Ad_Period__c /*Where Id IN : adPeriodIds*/]);
        List<Program_Forecast__c> pfScope = (List<Program_Forecast__c>)scope;
        oppList = new Set<ID>();
        programList = new Set<ID>();
        for (Program_Forecast__c a : pfScope){
            oppList.add(a.Program__r.Opportunity__c);
            programList.add(a.Program__c);
        }
        refreshArchive();
        refreshInsertLists();
        
        Set<Id> existingPrograms = new Set<Id>();
        for (Archive_Program__c a : ap){
            existingPrograms.add(a.Original_ID__c);
        }
        pts = [Select Id, Program__c, Product_Type__c, Percent__c From Product_Type_Split__c Where Program__c IN : programList];
        programs = [Select p.Variance__c, p.Total_Amount__c, 
                        p.Program_Amount__c, p.Product_Type__c, p.Owner__c, p.Oppty_Probability__c, p.Opportunity__c, 
                        p.Number_of_Offers__c, p.Name, p.Initiative__c, p.Incentive_Kicker__c, p.Id, p.Account__c,
                        p.Forecast_Amount__c, p.Description__c, p.Delivery_Type__c, p.Contract_Commitment_Type__c, p.RecordType.Name,
                        p.Account_Type__c, p.End_Date__c, p.End_Cycle__c, p.Start_Date__c, p.Start_Cycle__c, p.Brand__c,
                        p.Status__c, p.Unique_ID__c, p.External_ID__c 
                    From Program__c p WHERE Id IN :programList];
        for (Program__c a : programs){
            createProgram(a);
        }
        insert insertAP;
        refreshArchive();
        
        programMap = new Map<Id, Id>();
        for (Archive_Program__c a : ap){
            if (!programMap.containsKey(a.Original_ID__c)){
                programMap.put(a.Original_ID__c, a.Id);
            }
        }
        
        for (Program_Forecast__c a : pfScope){
            createProgramForecast(a);
        }
        insert insertAPF;
        
        for (Product_Type_Split__c a : [Select Id, Program__c, Product_Type__c, Percent__c From Product_Type_Split__c Where Program__c IN : programList]){
            if (!existingPrograms.contains(a.Id)){
                createPTS(a);
            }
        }
        insert insertAPTS;
    }
    
    //method that runs after the execute() method
    global void finish(Database.BatchableContext BC){
        
    }
    
    private Archive_Program__c createProgram(Program__c x){
        Archive_Program__c result;
        boolean found = false;
        for (Archive_Program__c a : ap){
            if (a.Opportunity__c == x.Opportunity__c 
                && a.Delivery_Type__c == x.Delivery_Type__c 
                && a.Archive_Date__c == Date.Today()
                && a.RecordType.Name == x.RecordType.Name)
            {
                result = a;
                found = true;
                break;
            }
        }
        if (!found){
            Archive_Program__c newAP = new Archive_Program__c();
            newAP.Name = x.Name;
            newAP.Original_ID__c = x.Id;
            newAP.Account__c = x.Account__c;
            newAP.Account_Type__c = x.Account_Type__c;
            newAP.Archive_Date__c = Date.Today();
            newAP.Brand__c = x.Brand__c;
            newAP.Contract_Commitment_Type__c = x.Contract_Commitment_Type__c;
            newAP.Delivery_Type__c = x.Delivery_Type__c;
            newAP.Description__c = x.Description__c;
            newAP.End_Cycle__c = x.End_Cycle__c;
            newAP.End_Date__c = x.End_Date__c;
            newAP.Incentive_Kicker__c = x.Incentive_Kicker__c;
            newAP.Initiative__c = x.Initiative__c;
            newAP.Number_of_Offers__c = x.Number_of_Offers__c;
            newAP.Opportunity__c = x.Opportunity__c;
            newAP.Owner__c = x.Owner__c;
            newAP.Product_Type__c = x.Product_Type__c;
            newAP.Program_Amount__c = x.Program_Amount__c;
            newAP.Start_Cycle__c = x.Start_Cycle__c;
            newAP.Start_Date__c = x.Start_Date__c;
            newAP.Status__c = x.Status__c;
            newAP.Unique_ID__c = x.Unique_ID__c;
            Date archiveDate = Date.valueOf(newAP.Archive_Date__c);
            if (x.External_ID__c != null ){
                newAP.Ext_ID__c = x.External_ID__c + archiveDate.year() + '-' + (archiveDate.month() < 10 ? '0' + String.valueOf(archiveDate.month()) : String.valueOf(archiveDate.month())) + '-' + (archiveDate.day() < 10 ? '0' + String.valueOf(archiveDate.day()) : String.valueOf(archiveDate.day())) + '__' + x.Id;
            } else {
                Datetime sysTime = System.now();
                String chron_exp = '' + sysTime.millisecond() + sysTime.second() + sysTime.minute() + sysTime.hour() + sysTime.day() + sysTime.month() + sysTime.year() + '__' +  x.Id;
                newAP.Ext_ID__c = chron_exp;
            } 
            /* RIGHT HERE*///must add record type
            if (x.RecordType.Name == 'Contract'){
                newAP.RecordTypeId = contractAPRT;
                system.debug('***new contract');
            } else if (x.RecordType.Name == 'Proposal')
            {
                newAP.RecordTypeId = proposalAPRT;
                system.debug('***new proposal');
            }
            //else {system.debug('***new nothing: ' + x.RecordType.Name);}
            ap.add(newAP);
            insertAP.add(newAP);
            result = newAP;
            //system.debug('***new AP: ' + newAP.Name + ' ' + newAP.Delivery_Type__c + ' ' + newAP.Product_Type__c);
        }
        return result;
    }
    
    
    
    private Archive_Program_Forecast__c createProgramForecast(Program_Forecast__c x){
        Archive_Program_Forecast__c newAPF = new Archive_Program_Forecast__c();
        newAPF.Name = x.Name;
        newAPF.Actual_Amount__c = x.Actual_Amount__c;
        newAPF.Ad_Period__c = x.Ad_Period__c;
        newAPF.Archive_Date__c = Date.Today();
        newAPF.Forecast_Amount__c = x.Forecast_Amount__c;
        newAPF.Next_Quarter_Amount__c = x.Next_Quarter_Amount__c;
        newAPF.Previous_Quarter_Amount__c = x.Previous_Quarter_Amount__c;
        newAPF.Program__c = getArchiveProgram(x).Id;
        newAPF.Start_Date__c = x.Start_Date__c;
        newAPF.End_Date__c = x.End_Date__c;
        newAPF.Program_Forecast__c = x.Id;
        newAPF.Active__c = x.Active__c;
        Datetime sysTime = System.now();
        String chron_exp = '' + sysTime.millisecond() + sysTime.second() + sysTime.minute() + sysTime.hour() + sysTime.day() + sysTime.month() + sysTime.year() + x.Id;
        newAPF.Ext_ID__c = (getArchiveProgram(x).Ext_ID__c.indexOf('__') == -1 ? getArchiveProgram(x).Ext_ID__c : getArchiveProgram(x).Ext_ID__c.substring(0, getArchiveProgram(x).Ext_ID__c.indexOf('__'))) + adPeriodsMap.get(newAPF.Ad_Period__c).Name + '__' + x.Id;
        insertAPF.add(newAPF);
        return newAPF;
    }
    
    
    private Archive_Program__c getArchiveProgram(Program_Forecast__c x){
        Archive_Program__c result;
        for (Archive_Program__c a : ap){
            if (a.Opportunity__c == x.Program__r.Opportunity__c && a.Delivery_Type__c == x.Program__r.Delivery_Type__c){
                result = a;
                break;
            }
        }
        return result;
    }
    
    
    private Archive_Product_Type_Split__c createPTS(Product_Type_Split__c x){
        Archive_Product_Type_Split__c a = new Archive_Product_Type_Split__c();
        a.Program__c = programMap.get(x.Program__c);
        a.Product_Type__c = x.Product_Type__c;
        a.Percent__c = x.Percent__c;
        if (a.Program__c != null) insertAPTS.add(a);
        //system.debug('***new APTS: ' + a.Program__c + ' ' + a.Product_Type__c + ' ' + a.Percent__c);
        return a;
    }    
    
    private void refreshArchive(){
        ap = [Select a.Weighted_Forecast_Amount__c, a.Variance__c, a.Total_Amount__c, a.Program_Amount__c, Original_ID__c,
                a.Product_Type__c, a.Owner__c, a.Oppty_Probability__c, a.Opportunity__c, a.Number_of_Offers__c, a.Name, a.RecordType.Name, 
                a.Initiative__c, a.Incentive_Kicker__c, a.Id, a.Description__c, a.Delivery_Type__c, 
                a.Contract_Commitment_Type__c, a.Archive_Date__c, a.Actual_Amount__c, a.Account__c, a.Ext_Id__c 
              From Archive_Program__c a WHERE a.Opportunity__c IN :oppList  And Archive_Date__c = :Date.Today()];
        apf = [Select a.Weighted_Previous_Quarter_Forecast__c, a.Weighted_Next_Quarter_Forecast__c, 
                a.Weighted_Forecast_Amount__c, a.Program__c, a.Previous_Quarter_Ratio__c, a.Previous_Quarter_Amount__c, 
                a.Previous_Quarter_Actual__c, a.Oppty_Probability__c, a.Next_Quarter_Ratio__c, a.Next_Quarter_Amount__c, 
                a.Next_Quarter_Actual__c, a.Name, a.IsDeleted, a.Id, a.Forecast_Amount__c, a.Archive_Date__c, a.Ad_Period__c, 
                a.Actual_Amount__c, a.Ext_ID__c
               From Archive_Program_Forecast__c a WHERE a.Program__r.Opportunity__c IN :oppList And Archive_Date__c = :Date.Today()];
        apts = [Select Id, Name, Program__c, Product_Type__c, Percent__c From Archive_Product_Type_Split__c where Program__r.Opportunity__c IN : oppList];
    }
    
    private void refreshInsertLists(){
        insertAP = new List<Archive_Program__c>();
        insertAPF = new List<Archive_Program_Forecast__c>();
        insertAPTS = new List<Archive_Product_Type_Split__c>();
    }

}