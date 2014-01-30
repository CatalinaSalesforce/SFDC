/*
@Name           : C62ReportChartsController 
@Author         : customersuccess@cloud62.com
@Date           : 12/04/2013
@Description    : Controller for ReportCharts vf page
*/
public class C62ReportChartsController{
    //variables
    public String selVP{get;set;}
    public String congId{get;set;}
    public String ownerId{get;set;}
    public String selRecType{get;set;}    
    public String strReport1{get;set;}
    public String strReport2{get;set;}
    public Opportunity opp{get;set;}
    public ReportChartIds__c setting;
    public Boolean displayCharts{get;set;}
    public List<ChartWrapper> dcChartWrapperList{get;set;}
    public List<ChartWrapper> avgChartWrapperList{get;set;}
    
    /*
    @Name :C62ReportChartsController
    @Description :Constructor
    */
    public C62ReportChartsController(){
        //initialize the variables
        displayCharts = false;
        opp = new Opportunity();
        
        //default the start close date and end close date
        opp.Start_Date__c = date.newInstance(System.today().year(),1,1);
        opp.End_Date__c = date.newInstance(System.today().year(),12,31);
        
        //get the custom setting data
        setting = ReportChartIds__c.getInstance('Default');
    }
    
    /*
    @Name :getRecordTypes
    @Description :returns the record type options
    */
    public List<SelectOption> getRecordTypes(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--None--'));
        options.add(new SelectOption('Contract', 'Contract'));
        options.add(new SelectOption('Proposal', 'Proposal'));
        options.add(new SelectOption('Recovery', 'Recovery'));
        options.add(new SelectOption('Renewal', 'Renewal'));
        return options;
    }
    
    /*
    @Name :getVP
    @Description :returns the VP options
    */
    public List<SelectOption> getVP(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--None--'));
        options.add(new SelectOption('Jennifer Burke', 'Jennifer Burke'));
        options.add(new SelectOption('Lisa Gosselin', 'Lisa Gosselin'));
        options.add(new SelectOption('Sharon Glass', 'Sharon Glass'));
        return options;
    }
    
    /*
    @Name :getAccountsList
    @Description :Returns the list of conglomerate account names for the FlexBox to use
    */
    public String getAccountsList(){
        List<Account> lstAccs = [SELECT Id, Name 
                                 FROM Account 
                                 WHERE RecordType.Name IN ('Retail','Manufacturing') 
                                 AND Type = 'Conglomerate' 
                                 ORDER BY Name ASC];
        FlexItemSource fis = new FlexItemSource();
        List<FlexItem> lstFL = new list<FlexItem>();
        for(Account acc : lstAccs){
            FlexItem fl = new FlexItem();
            fl.id = acc.Id;
            fl.name = acc.Name;
            lstFL.add(fl);
        }
        fis.results = lstFL;
        return JSON.serialize(fis);
    }
    
    /*
    @Name :getOwnersList
    @Description :Returns the list of user names for the FlexBox to use
    */
    public String getOwnersList(){
        List<User> lstUsrs = [SELECT Id, Name 
                                 FROM User 
                                 WHERE IsActive = True 
                                 AND Forecast_Role__c != null 
                                 AND Country__c = 'USA'
                                 ORDER BY Name ASC];
        FlexItemSource fis = new FlexItemSource();
        List<FlexItem> lstFL = new list<FlexItem>();
        for(User u : lstUsrs){
            FlexItem fl = new FlexItem();
            fl.id = u.Id;
            fl.name = u.Name;
            lstFL.add(fl);
        }
        fis.results = lstFL;
        return JSON.serialize(fis);
    }
    
    /*
    @Name :send
    @Description :display the report charts
    */
    public PageReference send(){
        avgChartWrapperList = new List<ChartWrapper>();
        dcChartWrapperList = new List<ChartWrapper>();
        displayCharts = false;
        strReport1 = '';
        strReport2 = '';
        
        //validate if end close date is less than start close date
        if(opp.Start_Date__c > opp.End_Date__c){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'End Close Date can\'t be less than Start Close Date.'));
            return null; 
        }
        
        //validate if difference between end close date and start close date is 1 year
        if(opp.Start_Date__c.daysBetween(opp.End_Date__c)>366){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select a range of one year only.'));
            return null;            
        }
        
        //format the dates
        DateTime stRange = datetime.newInstance(opp.Start_Date__c.year(), opp.Start_Date__c.month(), opp.Start_Date__c.day());
        DateTime etRange = datetime.newInstance(opp.End_Date__c.year(), opp.End_Date__c.month(), opp.End_Date__c.day());
        String startCD = stRange.format('yyyy-MM-dd');
        String endCD = etRange.format('yyyy-MM-dd');
        
        //prepare the query string for program records to calculate the chart data
        String progQuery = 'SELECT Delivery_Type__c,Program_Amount__c, Opportunity__r.Age__c, Opportunity__c, Opportunity__r.IsWon FROM Program__c';
        progQuery +=' WHERE Opportunity__r.Account.RecordType.Name IN (\'Manufacturing\',\'Retail\')';        
        progQuery +=' AND Opportunity__r.CloseDate >= '+startCD+' AND Opportunity__r.CloseDate<= '+endCD;
        
        if(congId != null && congId != ''){
            progQuery +=' AND Opportunity__r.Account.ParentId =\''+congId+'\'';
        }
        
        if(ownerId != null && ownerId != ''){
            progQuery +=' AND Opportunity__r.OwnerId =\''+ownerId+'\'';
        }
        
        if(selRecType != null && selRecType != ''){
            progQuery +=' AND Opportunity__r.RecordType.Name =\''+selRecType+'\'';
        }else{
            progQuery +=' AND Opportunity__r.RecordType.Name IN (\'Contract\',\'Proposal\',\'Recovery\',\'Renewal\')';
        }
        
        if(selVP != null && selVP != ''){
            progQuery +=' AND Opportunity__r.Sales_Manager_1__r.Name =\''+selVP+'\'';
        }
        
        progQuery +=' AND (NOT(Opportunity__r.IsWon = False AND Opportunity__r.IsClosed = True)) ';
        progQuery +=' AND (NOT(Opportunity__r.STAGENAME IN (\'Closed Won Addendum\',\'CLOSED ERROR\'))) ';
        
        //query the program data
        List<Program__c> progList = Database.query(progQuery);
        
        //prepare a map of Delivery Type as key and list of program as a value
        Map<String,List<Program__c>> progMap = new Map<String,List<Program__c>>();
        //prepare a map of Delivery Type as key and map of age as a value
        Map<String,Map<Id,Decimal>> ageMap = new Map<String,Map<Id,Decimal>>();
        for(Program__c p : progList){
            if(!progMap.containsKey(p.Delivery_Type__c))
                progMap.put(p.Delivery_Type__c,new List<Program__c>());
            progMap.get(p.Delivery_Type__c).add(p);
            
            if(!ageMap.containsKey(p.Delivery_Type__c))
                ageMap.put(p.Delivery_Type__c,new Map<Id,Decimal>());
            ageMap.get(p.Delivery_Type__c).put(p.Opportunity__c, p.Opportunity__r.Age__c);
        }
        
        //calculate the chart calculation
        for(String s : progMap.keySet()){
            Decimal wonOpp = 0;
            Decimal totalOpp = 0;
            Decimal winRate = 0;
            Decimal amount = 0;
            Decimal age = 0;
            
            for(Program__c p : progMap.get(s)){
                if(p.Opportunity__r.IsWon==TRUE){
                    //won opportunities
                    wonOpp++;
                }
                
                //amount calculation
                if(p.Program_Amount__c != null){
                    amount += p.Program_Amount__c;
                }
                
                //total opportunities
                totalOpp++; 
            }
            
            //do age sum;
            for(Decimal d : ageMap.get(s).values()){
                age += d;
            }
            
            //win rate calculation
            if(wonOpp>0){
                winRate = (wonOpp*100)/totalOpp;
            }
            
            if(totalOpp==0){
                winRate = 100;
            }
            
            amount = (amount/Decimal.valueOf(progMap.get(s).size())).setScale(2);
            age = (age/Decimal.valueOf(ageMap.get(s).size())).setScale(2);

            //prepare the wrapper list
            ChartWrapper wrapper = new ChartWrapper();  
            wrapper.delType = s;
            wrapper.amt = amount;
            wrapper.age = age;
            wrapper.winRate = winRate.setScale(2);
            avgChartWrapperList.add(wrapper);  
        }

        //prepare the query string for Opportunity data to calculate the Amount, Age, Percentage of RecordType Total and Win Rate charts data
        String oppQuery = 'Select Amount,Age__c,IsWon,Catalina_Business_Unit__c FROM Opportunity WHERE Account.RecordType.Name IN (\'Manufacturing\',\'Retail\')';
        oppQuery +=' AND CloseDate >= '+startCD+' AND CloseDate<= '+endCD;
        
        if(congId != null && congId != ''){
            oppQuery +=' AND Account.ParentId =\''+congId+'\'';
        }
        
        if(ownerId != null && ownerId != ''){
            oppQuery +=' AND OwnerId =\''+ownerId+'\'';
        }
        
        if(selRecType != null && selRecType != ''){
            oppQuery +=' AND RecordType.Name =\''+selRecType+'\'';
        }else{
            oppQuery +=' AND RecordType.Name IN (\'Contract\',\'Proposal\',\'Recovery\',\'Renewal\')';
        }
        
        if(selVP != null && selVP != ''){
            progQuery +=' AND Sales_Manager_1__r.Name =\''+selVP+'\'';
        }
        
        oppQuery +=' AND (NOT(IsWon = False AND IsClosed = True)) ';
        oppQuery +=' AND (NOT(STAGENAME IN (\'Closed Won Addendum\',\'CLOSED ERROR\'))) ';
        
        //query the opportunity data
        List<Opportunity> oppList = Database.query(oppQuery);
        
        //prepare a map of Catalina_Business_Unit__c as key and list of opps as values
        Map<String,List<Opportunity>> oppMap = new Map<String,List<Opportunity>>();
        for(Opportunity o : oppList){
            String s = '';
            if(o.Catalina_Business_Unit__c != null && o.Catalina_Business_Unit__c != ''){
                s = o.Catalina_Business_Unit__c;
            }
            if(!oppMap.containsKey(s))
                oppMap.put(s,new List<Opportunity>());
            oppMap.get(s).add(o);
        }
        
        //calculate the charts data
        for(String dckey : oppMap.keySet()){
            Decimal sumAmt = 0;
            Decimal oppAge = 0;
            Decimal wonOpp = 0;
            Decimal totalOpp = 0;
            Decimal winRate = 0;
            
            for(Opportunity o : oppMap.get(dckey)){
                //amount calculation
                if(o.Amount!=null) sumAmt += o.Amount;
                
                //age calculation
                oppAge += o.Age__c;
                
                if(o.IsWon==TRUE){
                    //won opportunities
                    wonOpp++;
                }
                
                //total opportunities
                totalOpp++;
            }
            
            //win rate calculation
            if(wonOpp>0){
                winRate = (wonOpp*100)/totalOpp;
            }
            
            if(totalOpp==0){
                winRate = 100;
            }
            
            //prepare the wrapper list
            ChartWrapper wrapper = new ChartWrapper();  
            wrapper.delType = dckey;
            wrapper.amt = sumAmt.setScale(2);
            wrapper.age = (oppAge/Decimal.valueOf(oppMap.get(dckey).size())).setScale(2);
            wrapper.winRate = winRate.setScale(2);
            
            //-----change from bar chart to pie chart display-------//
            //wrapper.recTypeTotal = ((Decimal.valueOf(oppMap.get(dckey).size())*100)/Decimal.valueOf(oppList.size())).setScale(2);
            wrapper.recTypeTotal = (Decimal.valueOf(oppMap.get(dckey).size())).setScale(0);
            
            dcChartWrapperList.add(wrapper); 
        }
        
        //prepare the report links from custom setting
        if(setting.Report_1_ID__c!=null){
            strReport1 = '/'+setting.Report_1_ID__c;
        }
        
        if(setting.Report_2_ID__c!=null){
            strReport2 = '/'+setting.Report_2_ID__c;
        }
        
        //set the displayCharts flag to true
        displayCharts = true;
        return null;    
    }
    
    /*
    @Name :ChartWrapper
    @Description :wrapper class for google charts
    */
    public class ChartWrapper{  
        public String delType{get;set;}           
        public Decimal age{get;set;}
        public Decimal amt{get;set;}
        public Decimal winRate{get;set;}
        public Decimal recTypeTotal{get;set;}
    }
    
    /*
    @Name :ChartWrapper
    @Description :wrapper class to represent flexbox item that will be used in JSON for the flexboxes
    */
    public class FlexItem{
        public String id {get;set;}
        public String name {get;set;}
    }
    
    /*
    @Name :ChartWrapper
    @Description :wrapper class to represent flexbox source
    */
    public class FlexItemSource{
        public List<FlexItem> results {get;set;}
    }
}