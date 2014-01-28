/*
@Name            : TEMP_BatchCreateSDPYSnapshot 
@Author          : customersuccess@cloud62.com
@Date            : December 17th, 2012
@Description     : Batch class to create SDPY snapshots for all of Europe
*/
global class TEMP_BatchCreateSDPYSnapshot implements Database.Batchable<sObject>, Schedulable{
    
    final static String EUR = 'EUR';
    
    String query;
    String limit1;
    Date closeDate;
    Map<Id, Ad_Period__c> cycleMap;
    
    public TEMP_BatchCreateSDPYSnapshot(Integer year, Integer month, Integer day){
        closeDate = Date.newInstance(year, month, day);
    }
    
    public TEMP_BatchCreateSDPYSnapshot(){
        limit1 = '';
    }
    
    //method that gets the query used for this batch
    global Database.querylocator start(Database.BatchableContext BC){
        if (closeDate != null){
        	query = 'SELECT ID, (SELECT ID, NAME, AD_PERIOD__C, ACTUAL_AMOUNT__C, AD_PERIOD__R.END_DATE__C, External_ID__c, Active__c, Forecast_Amount__c, Next_Quarter_Amount__c, Previous_Quarter_Amount__c '
        		+ ' FROM PROGRAM_FORECASTS__R), '
        		+ ' DELIVERY_TYPE__C, Name, Account_Type__c, Brand__c, Description__c, End_Cycle__c, End_Date__c, Incentive_Kicker__c, Initiative__c, Number_of_Offers__c, Opportunity__c, Product_Type__c, Program_Amount__c, Start_Cycle__c, Start_Date__c, Status__c, External_ID__c,'
        		+ ' OPPORTUNITY__R.CLOSEDATE, RecordType.Name '
        		+ ' FROM PROGRAM__C '
        		+ ' WHERE OPPORTUNITY__R.CLOSEDATE < ' + closeDate.year() + '-'  + (closeDate.month() < 10 ? '0' + String.valueOf(closeDate.month()) : String.valueOf(closeDate.month())) + '-' + (closeDate.day() < 10 ? '0' + String.valueOf(closeDate.day()) : String.valueOf(closeDate.day()))
        		+ ' AND OPPORTUNITY__R.RECORDTYPE.NAME IN (\'Contract Germany\',\'Contract France\',\'Contract Italy\') AND OPPORTUNITY__R.FOR_REPORTING__C = FALSE ';
        } else {
        	query = 'SELECT ID FROM USER WHERE ID = NULL ';
        }
        return Database.getQueryLocator(query);
    }
    
    global void execute(SchedulableContext ctx) {
        TEMP_BatchCreateSDPYSnapshot batch1 = new TEMP_BatchCreateSDPYSnapshot();
        ID batchprocessid = Database.executeBatch(batch1);
    } 
    
    //method that makes up the body of the batch process
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        List<Program__c> scopeList = (List<Program__c>)scope;
        List<Archive_Program__c> insertAP = new List<Archive_Program__c>();
        List<Archive_Program_Forecast__c> insertAPF = new List<Archive_Program_Forecast__c>(); 
        cycleMap = new Map<Id, Ad_Period__c>();
        for (Ad_Period__c ap : [SELECT ID, NAME, END_DATE__C FROM AD_PERIOD__C]){
        	cycleMap.put(ap.Id, ap);
        }
        Map<Id, Id> apMap = new Map<Id, Id>();
        for (Program__c prog: scopeList){
        	Archive_Program__c newAP = createAP(prog);
        	insertAP.add(newAP);
        }
        insert insertAP;
        for (Archive_Program__c ap : insertAP){
        	apMap.put(ap.Original_ID__c, ap.Id);
        }
        
        for (Program__c prog: scopeList){
        	for (Program_Forecast__c pf : 	prog.Program_Forecasts__r){
        		Archive_Program_Forecast__c newAPF = createAPF(pf, apMap.get(prog.Id));
        		insertAPF.add(newAPF);
        	}
        }
        insert insertAPF;
    }
    
    //method that runs after the execute() method
    global void finish(Database.BatchableContext BC){

    }
    
    public Archive_Program__c createAP(Program__c x){
    	Archive_Program__c newAP = new Archive_Program__c();
        newAP.Name = x.Name;
        newAP.Original_ID__c = x.Id;
        //newAP.Account__c = x.Account__c;
        newAP.Account_Type__c = x.Account_Type__c;
        newAP.Archive_Date__c = closeDate;
        newAP.Brand__c = x.Brand__c;
        //newAP.Contract_Commitment_Type__c = x.Contract_Commitment_Type__c;
        newAP.Delivery_Type__c = x.Delivery_Type__c;
        newAP.Description__c = x.Description__c;
        newAP.End_Cycle__c = x.End_Cycle__c;
        newAP.End_Date__c = x.End_Date__c;
        //newAP.Incentive_Kicker__c = x.Incentive_Kicker__c;
        newAP.Initiative__c = x.Initiative__c;
        //newAP.Number_of_Offers__c = x.Number_of_Offers__c;
        newAP.Opportunity__c = x.Opportunity__c;
        //newAP.Owner__c = x.Owner__c;
        newAP.Product_Type__c = x.Product_Type__c;
        newAP.Program_Amount__c = x.Program_Amount__c;
        newAP.Start_Cycle__c = x.Start_Cycle__c;
        newAP.Start_Date__c = x.Start_Date__c;
        newAP.Status__c = x.Status__c;
        newAP.CurrencyIsoCode = EUR;
        //newAP.Unique_ID__c = x.Unique_ID__c;
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
            //newAP.RecordTypeId = contractAPRT;
            system.debug('***new contract');
        } else if (x.RecordType.Name == 'Proposal'){
            //newAP.RecordTypeId = proposalAPRT;
            system.debug('***new proposal');
        }
    	return newAP;
    }
    
    private Archive_Program_Forecast__c createAPF(Program_Forecast__c x, String parentID){
        Archive_Program_Forecast__c newAPF = new Archive_Program_Forecast__c();
        newAPF.Name = x.Name;
        newAPF.Actual_Amount__c = x.Actual_Amount__c;
        newAPF.Ad_Period__c = x.Ad_Period__c;
        newAPF.Archive_Date__c = closeDate;
        newAPF.Program__c = parentID;
        newAPF.Forecast_Amount__c = x.Forecast_Amount__c;
        newAPF.Next_Quarter_Amount__c = x.Next_Quarter_Amount__c;
        newAPF.Previous_Quarter_Amount__c = x.Previous_Quarter_Amount__c;
        newAPF.CurrencyIsoCode = EUR;
        /*newAPF.Start_Date__c = x.Start_Date__c;
        newAPF.End_Date__c = x.End_Date__c;*/
        newAPF.Program_Forecast__c = x.Id;
        //system.debug('***close date - 1: ' + closeDate.addYears(-1));
        system.debug('***End Date: ' + cycleMap.get(x.Ad_Period__c).End_Date__c);
        //system.debug('***result: ' + closeDate.addYears(-1) > cycleMap.get(x.Ad_Period__c).End_Date__c);
        if (closeDate > cycleMap.get(x.Ad_Period__c).End_Date__c){
        	newAPF.Active__c = false;
        } else {
        	newAPF.Active__c = true;
        }
        Datetime sysTime = System.now();
        String chron_exp = '' + sysTime.millisecond() + sysTime.second() + sysTime.minute() + sysTime.hour() + sysTime.day() + sysTime.month() + sysTime.year() + x.Id;
        newAPF.Ext_ID__c = parentID + chron_exp;
        return newAPF;
    }

}