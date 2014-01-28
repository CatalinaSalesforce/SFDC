/*
@Name            : ProgramController
@Author          : customersuccess@cloud62.com
@Date            : May 8, 2012
@Description     : Controller for custom detail and edit page for Program__c
2012-12-21 - Warren Adding Auto Sync with Cats field, added error message
2012-12-20 - Anjana - Changed brands to be a single drop down(Brand__c) instead of multi picklist(Brands_List__c).
*/
public with sharing class ProgramController{
    //Variables
    public Program__c progIn {get;set;}
    public Account accProgIn {get;set;}
    public Account accProgInMaster {get;set;}
    public MultiSelect mBrandSelect {get;set;}
    public String strBrand {get;set;}
    public String strDivision {get;set;}
    public String strStartCycle {get;set;}
    public String strEndCycle {get;set;}
    public Boolean hideBrands {get;set;}
    String masterAccId;
    
    //Constructor
    public ProgramController(ApexPages.StandardController sc){
        progIn = [select Id, Specialist__c, Name, RecordTypeId, Auto_Sync_With_CATS__c, RecordType.developerName, 
                    Account_Type__c, Actual_Amount__c, Brand__c, RecordType.Name, 
                    Contract_Commitment_Type__c, Delivery_Type__c, Description__c, Division__c, 
                    Division_List__c, End_Cycle__c, End_Date__c, External_ID__c, Opportunity__r.AccountId,
                    Forecast_Amount__c, Incentive_Kicker__c, Initiative__c, Number_of_Offers__c, 
                    Opportunity__c, Oppty_Probability__c, Owner__c, Product_Type__c, Program_Amount__c, 
                    Start_Cycle__c,  Start_Date__c, Status__c, Total_Amount__c, Unique_ID__c, Variance__c, Weighted_Forecast_Amount__c,
                    Start_Cycle__r.Name, End_Cycle__r.Name 
                    FROM Program__c WHERE Id = :sc.getId()];
        
        //Get the account the program is tied to
        Program__c pTemp = [SELECT Id, Opportunity__r.AccountId FROM Program__c WHERE Id = :progIn.Id];
        accProgIn = [SELECT Id, Name, ParentId, RecordType.developerName, RecordType.Name FROM Account WHERE Id = :pTemp.Opportunity__r.AccountId];
        //Get the highest account in the hierarchy for the account the program is tied to 
        accProgInMaster = getHighestAccount(accProgIn);
        
        if (accProgInMaster.ParentId != null){
            masterAccId = accProgInMaster.ParentId;
        }
        else {
            masterAccId = accProgInMaster.Id;
        }
        hideBrands = false;
        system.debug(LoggingLevel.ERROR, '***' + accProgIn.RecordType.DeveloperName);
        if (accProgIn.RecordType.DeveloperName.contains('Japan')){
            hideBrands = true;
        }
        
        //Set the Start and End Cycle
        strStartCycle = progIn.Start_Cycle__c;
        strEndCycle = progIn.End_Cycle__c;
        //Set the Brands and Division
        strBrand = progIn.Brand__c;
        strDivision = progIn.Division_List__c;
        //Set up the multiselect
        /*Set<String> setAllBrands = new Set<String>();
        Set<String> setSelectedBrands = new Set<String>();
        if (progIn.RecordType.Name.contains('France')){
            for(Brand__c bran : [SELECT Id, Name, Account__c FROM Brand__c WHERE Account__c = :progIn.Opportunity__r.AccountId]){
                setAllBrands.add(bran.Name);
            }
        } else {
            for(Brand__c bran : [SELECT Id, Name, Account__c FROM Brand__c WHERE Account__c = :masterAccId]){
                setAllBrands.add(bran.Name);
            }   
        }
        if(progIn.Brands_List__c != null){
            for(String str : progIn.Brands_List__c.split(';')){
                setSelectedBrands.add(str);
            }
            setAllBrands.removeAll(setSelectedBrands);
        }
        mBrandSelect = new MultiSelect(setAllBrands,setSelectedBrands);*/
    }
    
    //Options for the Ad Periods (Start and End Cycles)
    public List<SelectOption> getPeriods(){
        
        String RTInput = accProgInMaster.RecordType.Name;
        if (accProgInMaster.RecordType.Name == 'メーカー'){
            RTInput = 'Manufacturing Japan';
        } else if (accProgInMaster.RecordType.Name == 'リテール'){
            RTInput = 'Retail Japan';
        }
        Boolean foundStart = false;
        Boolean foundEnd = false;
        List<SelectOption> opts = new List<SelectOption>();
        Date dtEndsIn = Date.newInstance(Date.Today().year(), Date.Today().month(), 1);
        Date dtEnd = Date.newInstance(Date.Today().year() + 2, 12, 31);
        List<Ad_Period__c> lstPeriods = [SELECT Id, Name, Type__c, Start_Date__c 
                                            FROM Ad_Period__c 
                                            WHERE End_Date__c >= :dtEndsIn AND Start_Date__c <= :dtEnd 
                                            AND Type__c = :RTInput
                                            ORDER BY Start_Date__c ASC];
        for(Ad_Period__c ad : lstPeriods){
            opts.add(new SelectOption(ad.Id,ad.Name));
            if (ad.Id == progIn.Start_Cycle__c) foundStart = true;
            if (ad.Id == progIn.End_Cycle__c) foundEnd = true;
        }
        if (!foundStart && progIn.Start_Cycle__c != null) opts.add(new SelectOption(progIn.Start_Cycle__c, progIn.Start_Cycle__r.Name));
        if (!foundEnd && progIn.End_Cycle__c != null) opts.add(new SelectOption(progIn.End_Cycle__c, progIn.End_Cycle__r.Name));
        
        return opts;
    }
    
    //Options for the Brands
    
    public List<SelectOption> getBrands(){

        List<Brand__c>     lstBrands;
        List<SelectOption> opts = new List<SelectOption>();
        opts.add(new SelectOption('--None--','--None--'));
         
        if (progIn.RecordType.Name.contains('France'))
            lstBrands = [SELECT Id, Name, Account__c FROM Brand__c WHERE Account__c = :progIn.Opportunity__r.AccountId];
        else
            lstBrands = [SELECT Id, Name, Account__c FROM Brand__c WHERE Account__c = :masterAccId];
            
        for(Brand__c brand : lstBrands){
            opts.add(new SelectOption(brand.Name,brand.Name));
        }
        return opts;
    }
    
    //Options for the Divisions
    public List<SelectOption> getDivisions(){
        List<SelectOption> opts = new List<SelectOption>();
        opts.add(new SelectOption('--None--','--None--'));
        List<Division__c> lstDivisions = [SELECT Id, Name, Account__c FROM Division__c WHERE Account__c = :masterAccId];
        for(Division__c div : lstDivisions){
            opts.add(new SelectOption(div.Name,div.Name));
        }
        return opts;
    }
    
    //Retrive the highest account in the hierarchy
    public Account getHighestAccount(Account accIn){
        if(accIn.ParentId != null){
            List<Account> accList = [SELECT Id, Name, ParentId, RecordType.Name FROM Account WHERE Id = :accIn.ParentId]; 
            if (accList.size() == 0){
                return accIn;
            } else {
                return getHighestAccount(accList[0]);   
            }
        } else {
            return accIn;
        }
    }
    
    //Custom Save
    public PageReference save(){
        //Save the Brands
        /*String brands = '';
        for(String str : mBrandSelect.rightvalues){
            brands += str + ';';
        }
        if(brands == ''){
            brands = null;
        } else {
            brands = brands.substring(0,brands.length()-1);
        }
        progIn.Brands_List__c = brands;*/
        
        //Save the Brand
        
        if(strBrand == '--None--'){
            progIn.Brand__c = null;
        } else {
            progIn.Brand__c = strBrand;
        }
        
        //Save the Division
        if(strDivision == '--None--'){
            progIn.Division_List__c = null;
        } else {
            progIn.Division_List__c = strDivision;
        }
        //Save the Start Cycle
        if(strStartCycle == '--None--'){
            progIn.Start_Cycle__c = null;
        } else {
            progIn.Start_Cycle__c = strStartCycle;
        }
        //Save the End Cycle
        if(strEndCycle == '--None--'){
            progIn.End_Cycle__c = null;
        } else {
            progIn.End_Cycle__c = strEndCycle;
        }
        try{
            update progIn;
            return new PageReference('/' + progIn.Id);
        } catch (DmlException e){
            system.debug(LoggingLevel.ERROR,'error message: ' + e.getMessage());
            //String friendlyMsg = e.getMessage().substring(e.getMessage().lastIndexOf(',') + 1);
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getDMLMessage(0)));
            return null;
        }
    } 
}