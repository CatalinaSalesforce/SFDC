/*
@Name           :       GetAdPeriodController
@Author         :
@Date           :   
@Description    :       Controller for MyForecastPage
                        Used to get Ad_Period__c of forecast months to create headings of the JQGrid
2013-01-29 - add code to factor in delay
*/
public with sharing class GetAdPeriodController{
    final static Date US_Cycle_Start_Date = Date.newInstance(system.today().year()-1,12,27);
    final static Date Japan_Cycle_Start_Date = Date.newInstance(system.today().year()-1,12,26);
        
    public Opportunity opp{get;set;}
    public Date currentDate;
    public String cDate{get;set;}
    public String rType{get;set;}
    public String stage{get;set;}
    public string accountName{get;set;}
    public String oppUser{get;set;}
    public String adPeriodNames{get;set;}
    public List<Ad_Period__c> adPeriodList{get;set;} 
    public boolean doRefresh{set;get;}
    public boolean noMoreAdPeriods{get;set;}
    public boolean noPre{get;set;}
    public boolean isEditable{get;set;}
    public boolean isFirstcolEditable{get;set;}
    public string opportunityId{get;set;}
    public String jSonString{get;set;}
    public String jsonTosave{get;set;}
    public String cDateString{get;set;}
    public string recType{get;set;}
    public boolean dataFound{get;set;}
    public date lastAdPeriodStartDate;
    public date firstAdPeriodStartDate;
    public date currAdPeriod;
    public string navigation{get;set;}
    public String year{get;set;}
    public String variance{get;set;}
    public String country{get;set;}
    public String pageName{get;set;}    
    public string progAmt{get;set;}
    public decimal programAmount;
    public String ProgramStatus{get;set;}
    public String quarter{get;set;}
    public String cycle{get;set;}
    public boolean showProgramFilter{get;set;}
    public boolean notShowProgramFilter{get;set;}
    public String oppName {get;set;}
    public String proposalNumber {get;set;}
    public String specialistId {get;set;}
    public String currencySymbol {get;set;}
    public String contractNumber {get;set;}
    public Boolean contractProposalFlag {get;set;}
    
    public GetAdPeriodController(){    
        dataFound = true;
        variance = 'All';
        ProgramStatus = 'All';
        quarter = '[All]';
        isEditable = true;
        isFirstcolEditable = false;
        showProgramFilter = true;
        contractProposalFlag = true;
        notShowProgramFilter = false;
        pageName = 'My Forecast Page';
        opportunityId = ApexPages.currentPage().getParameters().get('Id');
        String rtId = ApexPages.currentPage().getParameters().get('rId');
        opp = new Opportunity();
        if(cDate == null){
            currentDate = System.today();
        }
        if(rType == null){
            List<Profile> profiles = [SELECT ID, NAME FROM PROFILE];
            Set<Id> franceProfiles = new Set<Id>();
            Set<Id> italyProfiles = new Set<Id>();
            Set<Id> germanyProfiles = new Set<Id>();
            Set<Id> adminProfiles = new Set<Id>();
            Set<Id> japanProfiles = new Set<Id>();
            for (Profile p : profiles){
            if (p.Name.contains('France')){
                franceProfiles.add(p.Id);
            } else if (p.Name.contains('Italy')){
                italyProfiles.add(p.Id);
            } else if (p.Name.contains('Germany')){
                germanyProfiles.add(p.Id);
            } else if (p.Name.contains('Admin')){
                adminProfiles.add(p.Id);
            } else if (p.Name.contains('Japan')){
                japanProfiles.add(p.Id);
            }
            }
            if (franceProfiles.contains(UserInfo.getProfileId())){
                rType = 'Manufacturing France';
                pageName = 'Mes closings';
                showProgramFilter = false;
                contractProposalFlag = false;
                notShowProgramFilter = true;
            } else if (italyProfiles.contains(UserInfo.getProfileId())){
                rType = 'Manufacturing Italy';
                pageName = 'My Forecasts';
                showProgramFilter = false;
                notShowProgramFilter = true;
            } else if (germanyProfiles.contains(UserInfo.getProfileId())){
                rType = 'Manufacturing Germany';
                showProgramFilter = false;
                notShowProgramFilter = true;
            } else if (japanProfiles.contains(UserInfo.getProfileId())){
                rType = 'Manufacturing Japan';
                pageName = System.Label.ForecastPageName; // change to japan label
            } else {
                rType = 'Manufacturing';
            }
            if (opportunityId != null){
                rType = [SELECT ID, ACCOUNT.RECORDTYPE.NAME FROM OPPORTUNITY WHERE ID =: opportunityId][0].Account.RecordType.Name;
            }
        }
        if(rtId != null){
            RecordType rt = [SELECT Name from RecordType WHERE id =: rtId LIMIT 1];
            rType = rt.Name;
        }
        if(opportunityId != null){
            Opportunity opp = [select Account.RecordTypeId from Opportunity Where id =: opportunityId limit 1];
            RecordType rt = [SELECT Name from RecordType WHERE id =: opp.Account.RecordTypeId LIMIT 1];
            if(rt.Name == 'Manufacturing France'){
                rType = 'Manufacturing France';
            } 
            if(rt.Name == 'Manufacturing Germany'){
                rType = 'Manufacturing Germany';
            }
            if(rt.Name == 'Manufacturing Italy'){
                rType = 'Manufacturing Italy';
            }
            if(rt.Name == 'メーカー'){
                rType = 'Manufacturing Japan';
            }
            if(rt.Name == 'リテール'){
                rType = 'Retail Japan';
            } 
        }
        if(stage == null)
            {        
            if(rType == 'Manufacturing France'){
                stage='Contract';
            }
            else
            {
                stage='All';
            }
        }
        navigation = 'none';
        getAdPeriodNames();
        doRefresh = false;
        if(dataFound)
            loadGrid();
        else{
            ApexPages.Message message = new ApexPages.Message(ApexPages.Severity.INFO, 'No Data Found!');
            ApexPages.addMessage(message);
        }        
        if (year == null){
            year = 'All';
        }
        setCountryCode();
    }
    
    public pageReference refresh(){        
        dataFound = true;
        //Reset the filters and load grid

        if(navigation == 'reset'){
            isFirstcolEditable = false;
            progAmt = null;
            programAmount = 0;
            opportunityId = '';
            opp.OwnerId = null;
            lastAdPeriodStartDate = null;
            currentDate = system.today();
            List<Profile> profiles = [SELECT ID, NAME FROM PROFILE];
            Set<Id> franceProfiles = new Set<Id>();
            Set<Id> italyProfiles = new Set<Id>();
            Set<Id> germanyProfiles = new Set<Id>();
            Set<Id> adminProfiles = new Set<Id>();
            Set<Id> japanProfiles = new Set<Id>();
            for (Profile p : profiles){
            if (p.Name.contains('France')){
                franceProfiles.add(p.Id);
            } else if (p.Name.contains('Italy')){
                italyProfiles.add(p.Id);
            } else if (p.Name.contains('Germany')){
                germanyProfiles.add(p.Id);
            } else if (p.Name.contains('Admin')){
                adminProfiles.add(p.Id);
            } else if (p.Name.contains('Japan')){
                japanProfiles.add(p.Id);
            }
            }
            if (franceProfiles.contains(UserInfo.getProfileId())){
                rType = 'Manufacturing France';
            } else if (italyProfiles.contains(UserInfo.getProfileId())){
                rType = 'Manufacturing Italy';
            } else if (germanyProfiles.contains(UserInfo.getProfileId())){
                rType = 'Manufacturing Germany';
            } else if (japanProfiles.contains(UserInfo.getProfileId())){
                rType = 'Manufacturing Japan'; 
            } else {
                rType = 'Manufacturing';
            }
            
            if(rType == 'Manufacturing France')
            {
                stage = 'Contract';
            }
            else
            {
                stage = 'All';
            }
            setShowProgramFilter();
            accountName = '';
            oppUser = '';
            programStatus = 'All';
            quarter = '[All]';
            getAdPeriodNames();
            doRefresh=true;
            loadGrid();
            return null;
        }
        if(progAmt != null && progAmt.trim() != ''){
            try{
                programAmount = Decimal.valueOf(progAmt.trim());
            }catch(Exception e){
                dataFound = false;
                ApexPages.Message message = new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid Value for Program Amount!');
                ApexPages.addMessage(message);
                return null;
            }
        }else{
            programAmount = 0;
        }
        noPre = false;
        if(cDate != null && cDate != ''){
            currentDate = Date.valueOf(cDate);
        }
        isFirstcolEditable = true;
        if(currentDate <= system.today()){
            isFirstcolEditable = false;
        }
        isEditable = true;
        if(currentDate < System.today()){
            isEditable = false;
        }
        if(rType == 'Retail' && currentDate < System.today().addMonths(-7)){
            noPre = true;
            currentDate = System.today();
            isFirstcolEditable = false;
            isEditable = true;
        }else if(rType == 'Manufacturing' && currentDate < System.today().addDays(-(28*7))){
            noPre = true;
            currentDate = System.today();
            isFirstcolEditable = false;
            isEditable = true;
        }else if(rType == 'Retail Japan' && currentDate < System.today().addMonths(-7)){
            noPre = true;
            currentDate = System.today();
            isFirstcolEditable = false;
            isEditable = true;
        }else if(rType == 'Manufacturing Japan' && currentDate < System.today().addDays(-(28*7))){
            noPre = true;
            currentDate = System.today();
            isFirstcolEditable = false;
            isEditable = true;
        }

        getAdPeriodNames();
        doRefresh=true;
        loadGrid();
        return null;
    }
    
    public void getAdPeriodNames(){
        Date currentYearSD = Date.newInstance(system.today().year(),1,1);
        noMoreAdPeriods = false;
        if(lastAdPeriodStartDate == null || noPre == true || navigation =='search'){ // Loading ad periods on search or first time grid loads
            isFirstcolEditable = false;
            if(rType == 'Retail'){
                adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                                WHERE //(End_Date__c >=: System.today() OR 
                                //(End_Date__c >=: system.today().addMonths(-1) AND Start_Date__c <=: system.today().addMonths(-1))) AND 
                                (Start_Date__c>=: currentYearSD) AND 
                                Type__c =: rType 
                                AND Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7') 
                                Order by Start_Date__c ASC LIMIT 12];
            }else if(rType == 'Manufacturing'){
                adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                                WHERE (Start_Date__c>=: US_Cycle_Start_Date) AND 
                                Type__c =: rType 
                                AND Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7') 
                                Order by Start_Date__c ASC LIMIT 13];
            }else if(rType == 'Manufacturing France'){
                Stage = 'Contract';
                if (year == null || year == 'All'){
                adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                                WHERE //(End_Date__c >=: System.today() OR 
                                //(End_Date__c >=: system.today().addDays(-70) AND Start_Date__c <=: system.today().addDays(-70))) AND 
                                (Start_Date__c>=: currentYearSD) AND 
                                Type__c =: rType 
                                AND Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7') 
                                Order by Start_Date__c ASC LIMIT 12];
                } else {
                    adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                                WHERE Start_Date__c >=: Date.valueOf(year + '-01-01') AND 
                                Type__c =: rType 
                                AND Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7') 
                                Order by Start_Date__c ASC LIMIT 12];
                }            
            }else if(rType == 'Manufacturing Italy'){
                if (year == null || year == 'All'){
                adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                                WHERE //(End_Date__c >=: System.today() OR 
                                //(End_Date__c >=: system.today().addDays(-70) AND Start_Date__c <=: system.today().addDays(-70))) AND 
                                (Start_Date__c>=: currentYearSD) AND 
                                Type__c =: rType 
                                AND Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7') 
                                Order by Start_Date__c ASC LIMIT 12];
                } else {
                    adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                                WHERE Start_Date__c >=: Date.valueOf(year + '-01-01') AND 
                                Type__c =: rType 
                                AND Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7') 
                                Order by Start_Date__c ASC LIMIT 12];
                }                            
            }else if(rType == 'Manufacturing Germany'){
                if (year == null || year == 'All'){
                    adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                                WHERE //(End_Date__c >=: System.today() OR 
                                //(End_Date__c >=: system.today().addDays(-70) AND Start_Date__c <=: system.today().addDays(-70))) AND 
                                (Start_Date__c>=: currentYearSD) AND 
                                Type__c =: rType 
                                AND Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7') 
                                Order by Start_Date__c ASC LIMIT 12];
                } else {
                    adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                                WHERE Start_Date__c >=: Date.valueOf(year + '-01-01') AND 
                                Type__c =: rType 
                                AND Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7') 
                                Order by Start_Date__c ASC LIMIT 12];
                }                           
            }else if(rType == 'Retail Japan'){
                adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                                WHERE //(End_Date__c >=: System.today() OR (End_Date__c >=: system.today().addMonths(-1) AND Start_Date__c <=: system.today().addMonths(-1))) AND 
                                Start_Date__c >=: Japan_Cycle_Start_Date AND
                                Type__c =: rType 
                                AND Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7') 
                                Order by Start_Date__c LIMIT 12];
            }else if(rType == 'Manufacturing Japan'){
                adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                                WHERE //(End_Date__c >=: System.today() OR (End_Date__c >=: system.today().addDays(-28) AND Start_Date__c <=: system.today().addDays(-28))) AND 
                                Start_Date__c >=: Japan_Cycle_Start_Date AND
                                Type__c =: rType 
                                AND Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7') 
                                Order by Start_Date__c LIMIT 12];
            }
        }else if(lastAdPeriodStartDate != null && navigation == 'next'){ // Loading next cycle ad periods
            if(rType == 'Manufacturing'){
                adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                            WHERE Start_Date__c >: lastAdPeriodStartDate AND 
                            Type__c =: rType AND 
                            Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7') 
                            Order by Start_Date__c ASC LIMIT 13];
            } else{
                adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                            WHERE Start_Date__c >: lastAdPeriodStartDate AND 
                            Type__c =: rType AND 
                            Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7') 
                            Order by Start_Date__c ASC LIMIT 12];
            }
            if((rType != 'Manufacturing' && adPeriodList.size()<12) || (rType == 'Manufacturing' && adPeriodList.size()<13)){
                noMoreAdPeriods = true;
            }            
        }else if(firstAdPeriodStartDate != null && navigation == 'pre'){ // loading previous cycle ad periods
            List<Ad_Period__c> adPeriods;
            if(rType == 'Manufacturing'){
                adPeriods = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                                WHERE Start_Date__c <: firstAdPeriodStartDate AND 
                                Type__c =: rType AND 
                                Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7') 
                                Order by Start_Date__c desc LIMIT 13];
            } else{            
                adPeriods = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                                WHERE Start_Date__c <: firstAdPeriodStartDate AND 
                                Type__c =: rType AND  
                                Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7')
                                Order by Start_Date__c desc LIMIT 12];
            }
            adPeriodList = new List<Ad_Period__c>();
            if(adPeriods.size() == 12){
                for(integer i = adPeriods.size()-1 ; i >= adPeriods.size()-12 ; i--){
                    adPeriodList.add(adPeriods[i]);
                }
            }
            if(adPeriods.size() == 13){
                for(integer i = adPeriods.size()-1 ; i >= adPeriods.size()-13 ; i--){
                    adPeriodList.add(adPeriods[i]);
                }
            }
            if((rType != 'Manufacturing' && adPeriodList.size()<12) || (rType == 'Manufacturing' && adPeriodList.size()<13)){
                noPre = true;
            }
        }else if(navigation == 'none' && firstAdPeriodStartDate != null){ // Refreshing grid data after save
            system.debug('firstAdPeriodStartDate here'+firstAdPeriodStartDate);
            if(rType == 'Retail' && firstAdPeriodStartDate == system.today().addMonths(-1)){ // If saving Retail data on begining page
                    adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                                    WHERE (Start_Date__c >=: firstAdPeriodStartDate OR 
                                    (End_Date__c >=: system.today().addMonths(-1) AND Start_Date__c <=: system.today().addMonths(-1))) AND 
                                    Type__c =: rType 
                                    AND Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7')
                                    Order by Start_Date__c ASC LIMIT 12];
           }else if (rType == 'Manufacturing' && firstAdPeriodStartDate == system.today().addDays(-28)){// If saving Manufacturing data on begining page
                    //system.debug('firstAdPeriodStartDate here'+firstAdPeriodStartDate);
                    adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                                    WHERE (Start_Date__c >=: firstAdPeriodStartDate OR 
                                    (End_Date__c >=: system.today().addDays(-28) AND Start_Date__c <=: system.today().addDays(-28))) AND 
                                    Type__c =: rType 
                                    AND Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7')
                                    Order by Start_Date__c ASC LIMIT 13];
           }else if (rType == 'Manufacturing France' && firstAdPeriodStartDate == system.today().addDays(-70)){// If saving Manufacturing data on begining page
                    adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                                    WHERE (Start_Date__c >=: firstAdPeriodStartDate OR 
                                    (End_Date__c >=: system.today().addDays(-70) AND Start_Date__c <=: system.today().addDays(-70))) AND 
                                    Type__c =: rType 
                                    AND Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7')
                                    Order by Start_Date__c ASC LIMIT 12];                     
           }else if (rType == 'Manufacturing Italy' && firstAdPeriodStartDate == system.today().addDays(-70)){// If saving Manufacturing data on begining page
                    adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                                    WHERE (Start_Date__c >=: firstAdPeriodStartDate OR 
                                    (End_Date__c >=: system.today().addDays(-70) AND Start_Date__c <=: system.today().addDays(-70))) AND 
                                    Type__c =: rType 
                                    AND Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7')
                                    Order by Start_Date__c ASC LIMIT 12];                     
           }else if (rType == 'Manufacturing Germany' && firstAdPeriodStartDate == system.today().addDays(-70)){// If saving Manufacturing data on begining page
                    adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                                    WHERE (Start_Date__c >=: firstAdPeriodStartDate OR 
                                    (End_Date__c >=: system.today().addDays(-70) AND Start_Date__c <=: system.today().addDays(-70))) AND 
                                    Type__c =: rType 
                                    AND Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7')
                                    Order by Start_Date__c ASC LIMIT 12];                     
           }else if(rType == 'Retail Japan' && firstAdPeriodStartDate == system.today().addMonths(-1)){ // If saving Retail data on begining page
                    adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                                    WHERE (Start_Date__c >=: firstAdPeriodStartDate OR 
                                    (End_Date__c >=: system.today().addMonths(-1) AND Start_Date__c <=: system.today().addMonths(-1))) AND 
                                    Type__c =: rType 
                                    AND Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7')
                                    Order by Start_Date__c LIMIT 12];
           }else if (rType == 'Manufacturing Japan' && firstAdPeriodStartDate == system.today().addDays(-28)){// If saving Manufacturing data on begining page
                    adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                                    WHERE (Start_Date__c >=: firstAdPeriodStartDate OR 
                                    (End_Date__c >=: system.today().addDays(-28) AND Start_Date__c <=: system.today().addDays(-28))) AND 
                                    Type__c =: rType 
                                    AND Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7')
                                    Order by Start_Date__c LIMIT 12];
           }else{// if saving data on other than begining page
                if (rType == 'Manufacturing'){
                    adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                                WHERE Start_Date__c >=: firstAdPeriodStartDate AND 
                                Type__c =: rType AND 
                                Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7')
                                Order by Start_Date__c ASC LIMIT 13];
                } else{
                    adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                                WHERE Start_Date__c >=: firstAdPeriodStartDate AND 
                                Type__c =: rType AND 
                                Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7')
                                Order by Start_Date__c ASC LIMIT 12];
                }
            }
        }
        
        adPeriodNames = '';

        if((rType != 'Manufacturing' && adPeriodList.size()<12) || (rType == 'Manufacturing' && adPeriodList.size()<13)){
            //noMoreAdPeriods = true;
            currentDate = system.today();
            
            if(currentDate <= system.today()){
                isFirstcolEditable = false;
            }
            
            if(rType == 'Retail'){
                adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                                WHERE //(End_Date__c >=: System.today() OR 
                                //(End_Date__c >=: system.today().addMonths(-1) AND Start_Date__c <=: system.today().addMonths(-1))) AND 
                                (Start_Date__c>=: currentYearSD) AND 
                                Type__c =: rType AND
                                Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7') 
                                Order by Start_Date__c ASC LIMIT 12];
            }else if(rType == 'Manufacturing'){
                adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                                WHERE //(End_Date__c >=: System.today() OR 
                                //(End_Date__c >=: system.today().addDays(-28) AND Start_Date__c <=: system.today().addDays(-28))) AND 
                                (Start_Date__c>=: US_Cycle_Start_Date) AND
                                Type__c =: rType AND
                                Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7') 
                                Order by Start_Date__c ASC LIMIT 13];
            }else if(rType == 'Manufacturing France'){
                    adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                                WHERE //(End_Date__c >=: System.today() OR 
                                //(End_Date__c >=: system.today().addDays(-70) AND Start_Date__c <=: system.today().addDays(-70))) AND 
                                (Start_Date__c>=: currentYearSD) AND 
                                Type__c =: rType AND
                                Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7') 
                                Order by Start_Date__c ASC LIMIT 12];
            }else if(rType == 'Manufacturing Italy'){
                    adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                                WHERE //(End_Date__c >=: System.today() OR 
                                //(End_Date__c >=: system.today().addDays(-70) AND Start_Date__c <=: system.today().addDays(-70))) AND 
                                (Start_Date__c>=: currentYearSD) AND 
                                Type__c =: rType AND
                                Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7') 
                                Order by Start_Date__c ASC LIMIT 12];
            }else if(rType == 'Manufacturing Germany'){
                    adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                                WHERE //(End_Date__c >=: System.today() OR 
                                //(End_Date__c >=: system.today().addDays(-70) AND Start_Date__c <=: system.today().addDays(-70))) AND 
                                (Start_Date__c>=: currentYearSD) AND 
                                Type__c =: rType AND
                                Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7') 
                                Order by Start_Date__c ASC LIMIT 12];
            }else if(rType == 'Retail Japan'){
                adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                                WHERE //(End_Date__c >=: System.today() OR (End_Date__c >=: system.today().addMonths(-1) AND Start_Date__c <=: system.today().addMonths(-1))) AND 
                                (Start_Date__c>=: Japan_Cycle_Start_Date) AND 
                                Type__c =: rType AND
                                Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7') 
                                Order by Start_Date__c LIMIT 12];
            }else if(rType == 'Manufacturing Japan'){
                adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                                WHERE //(End_Date__c >=: System.today() OR (End_Date__c >=: system.today().addDays(-28) AND Start_Date__c <=: system.today().addDays(-28))) AND 
                                (Start_Date__c>=: Japan_Cycle_Start_Date) AND 
                                Type__c =: rType AND
                                Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7') 
                                Order by Start_Date__c LIMIT 12];
            }
        }
        
        if(adPeriodList.size() == 0){
            dataFound = false;
        }else{
            firstAdPeriodStartDate = adPeriodList[0].Start_Date__c;
            lastAdPeriodStartDate = adPeriodList[adPeriodList.size()-1].Start_Date__c;
            
            for(Ad_Period__c ad : adPeriodList){
                //Added by Cloud62 5/31/2013 - This was requested by the Italy team to increase readability
                if(rType == 'Manufacturing Italy'){
                    adPeriodNames += ad.Name.subString(6)+','; //do substring work here - change from IT_AP_C#_YYYY to C#_YYYY subString(6)
                }else{
                    adPeriodNames += ad.Name+',';
                }
            }
            adPeriodNames = adPeriodNames.subString(0,adPeriodNames.length()-1);
        }
    }
    
    public void loadGrid(){
        dataFound = true;
        cDate = String.valueOf(currentDate);
        MyForecastPageController myForPg = new MyForecastPageController(opportunityId, cDate, rType, stage, accountName, oppUser, programStatus, programAmount, quarter, firstAdPeriodStartDate, oppName, year, cycle, SpecialistID, variance, proposalNumber,contractNumber);
        jSonString = myforPg.jSonString;
        currencySymbol = myforPg.currencySymbol;
        if(jSonString.length() <=1){
            dataFound = false;
            ApexPages.Message message = new ApexPages.Message(ApexPages.Severity.INFO, 'No Records Found!');
            ApexPages.addMessage(message);
        }
    }
    
    public void saveJSon(){
        saveGridDataController saveGrid = new saveGridDataController(jsonToSave,cDateString,recType,firstAdPeriodStartDate);
    }
    
    public List<SelectOption> getAccounttypes(){
        List<Profile> profiles = [SELECT ID, NAME FROM PROFILE];
        Set<Id> franceProfiles = new Set<Id>();
        Set<Id> germanyProfiles = new Set<Id>();
        Set<Id> italyProfiles = new Set<Id>();
        Set<Id> adminProfiles = new Set<Id>();
        Set<Id> japanProfiles = new Set<Id>();
        for (Profile p : profiles){
            if (p.Name.contains('France')){
                franceProfiles.add(p.Id);
            } else if (p.Name.contains('Admin')){
                adminProfiles.add(p.Id);
            } else if (p.Name.contains('Germany')){
                germanyProfiles.add(p.Id);
            }else if (p.Name.contains('Italy')){
                italyProfiles.add(p.Id);
            }else if (p.Name.contains('Japan')){
                japanProfiles.add(p.Id);
            }
        }
        List<SelectOption> options = new List<SelectOption>();
        if (franceProfiles.contains(UserInfo.getProfileId())){
            options.add(new SelectOption('Manufacturing France', 'Manufacturing France'));
        }else if (adminProfiles.contains(UserInfo.getProfileId())){
            options.add(new SelectOption('Manufacturing Italy', 'Manufacturing Italy'));
            options.add(new SelectOption('Manufacturing Germany', 'Manufacturing Germany'));
            options.add(new SelectOption('Manufacturing France', 'Manufacturing France'));
            options.add(new SelectOption('Manufacturing Japan', 'Manufacturing Japan'));           
            options.add(new SelectOption('Retail Japan', 'Retail Japan'));
            options.add(new SelectOption('Manufacturing', 'Manufacturing'));
            options.add(new SelectOption('Retail', 'Retail'));
        }else if (germanyProfiles.contains(UserInfo.getProfileId())){
            options.add(new SelectOption('Manufacturing Germany', 'Manufacturing Germany'));
        }else if (italyProfiles.contains(UserInfo.getProfileId())){
            options.add(new SelectOption('Manufacturing Italy', 'Manufacturing Italy'));
        }else if (japanProfiles.contains(UserInfo.getProfileId())){
            options.add(new SelectOption('Manufacturing Japan', system.label.manufacturer));           
            options.add(new SelectOption('Retail Japan', system.label.retail));
        }else{
            options.add(new SelectOption('Manufacturing', 'Manufacturing'));
            options.add(new SelectOption('Retail', 'Retail'));
        }
        return options;
    }
    
    public List<SelectOption> getQuarters(){
        List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('All', 'All'));
            options.add(new SelectOption('Q1', 'Q1'));
            options.add(new SelectOption('Q2', 'Q2'));
            options.add(new SelectOption('Q3', 'Q3'));
            options.add(new SelectOption('Q4', 'Q4'));
        return options;
    }
    
    public List<SelectOption> getSpecialist(){
        /*
                @Full Query being built with options noted
                @This is a full list of specialists tied to any program with optional
                filtering added for account type or record type

                select specialist__r.name,
                        specialist__r.id
                from Program__c
                where specialist__c != null
                AND account_type__c = 'Manufacturing/Retail'    (Optional)
                AND recordType.name = 'Proposal/Contract'       (Optional)
                group By specialist__r.name, specialist__r.id
                order By specialist__r.name
        */
                        
        String soqlQuery = 'select specialist__r.name specName, ' 
                           +'specialist__r.id specId '
                           +'from Program__c '
                           +'where specialist__c != null ';
        //account_type__c (Optional)
        if(rType == 'Manufacturing'){
            soqlQuery = soqlQuery +'AND account_type__c = \'Manufacturing\' ';
        }else if(rType == 'Retail'){
            soqlQuery = soqlQuery +'AND account_type__c = \'Retail\' ';
        }
        //recordType.name (Optional)
        if(stage == 'Proposal'){
            soqlQuery = soqlQuery +'AND recordType.name = \'Proposal\' ';
        }else if(stage == 'Contract'){
            soqlQuery = soqlQuery +'AND recordType.name = \'Contract\' ';
        }
        soqlQuery = soqlQuery 
                        +'group By specialist__r.name, specialist__r.id '
                                        +'order By specialist__r.name';
        
        List<aggregateResult> specList = Database.query(soqlQuery);
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('All', 'All'));
        
        for(aggregateResult s:specList){
            string name = (string)s.get('specName');
            string specID = string.valueof((id)s.get('specId'));
            options.add(new SelectOption(specID ,name));
        }

        return options;
    }
    
    public List<SelectOption> getCycles(){
        List<SelectOption> options = new List<SelectOption>();
        if(rtype == 'Manufacturing France'){
            options.add(new SelectOption('All', 'All'));
            options.add(new SelectOption('C1', 'C1'));
            options.add(new SelectOption('C2', 'C2'));
            options.add(new SelectOption('C3', 'C3'));
            options.add(new SelectOption('C4', 'C4'));
            options.add(new SelectOption('C5', 'C5'));
        }else if (rtype == 'Manufacturing Italy'){
            options.add(new SelectOption('All', 'All'));
            options.add(new SelectOption('C1', 'C1'));
            options.add(new SelectOption('C2', 'C2'));
            options.add(new SelectOption('C3', 'C3'));
            options.add(new SelectOption('C4', 'C4'));
            options.add(new SelectOption('C5', 'C5'));
            options.add(new SelectOption('C6', 'C6'));            
        }else if (rtype == 'Manufacturing Germany'){
            options.add(new SelectOption('All', 'All'));
            options.add(new SelectOption('C1-Jan', 'C1-Jan'));
            options.add(new SelectOption('C1-Feb', 'C1-Feb'));
            options.add(new SelectOption('C2-Mar', 'C2-Mar'));
            options.add(new SelectOption('C2-Apr', 'C2-Apr'));
            options.add(new SelectOption('C3-May', 'C3-May'));
            options.add(new SelectOption('C3-Jun', 'C3-Jun'));
            options.add(new SelectOption('C4-Jul', 'C4-Jul'));
            options.add(new SelectOption('C4-Aug', 'C4-Aug'));
            options.add(new SelectOption('C5-Sep', 'C5-Sep'));
            options.add(new SelectOption('C5-Oct', 'C5-Oct'));
            options.add(new SelectOption('C6-Nov', 'C6-Nov'));
            options.add(new SelectOption('C6-Dec', 'C6-Dec'));
        }
        return options;
    }
    
    public List<SelectOption> getYears(){
        List<SelectOption> options = new List<SelectOption>();
        Integer year = Date.today().year();
        options.add(new SelectOption('All','All'));
        options.add(new SelectOption(String.valueOf(year-2),String.valueOf(year-2)));
        options.add(new SelectOption(String.valueOf(year-1),String.valueOf(year-1)));
        options.add(new SelectOption(String.valueOf(year),String.valueOf(year)));
        options.add(new SelectOption(String.valueOf(year+1),String.valueOf(year+1)));
        options.add(new SelectOption(String.valueOf(year+2),String.valueOf(year+2)));
        return options;
    }
    
    public List<SelectOption> getVariances(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('All','All'));
        options.add(new SelectOption('Positive','Positive'));
        options.add(new SelectOption('Negative','Negative'));
        return options;
    }
    
    public void setCountryCode(){
        List<Profile> profiles = [SELECT ID, NAME FROM PROFILE];
            Set<Id> franceProfiles = new Set<Id>();
            Set<Id> italyProfiles = new Set<Id>();
            Set<Id> germanyProfiles = new Set<Id>();
            Set<Id> adminProfiles = new Set<Id>();
            Set<Id> japanProfiles = new Set<Id>();
            for (Profile p : profiles){
            if (p.Name.contains('France')){
                franceProfiles.add(p.Id);
            } else if (p.Name.contains('Italy')){
                italyProfiles.add(p.Id);
            } else if (p.Name.contains('Germany')){
                germanyProfiles.add(p.Id);
            } else if (p.Name.contains('Admin')){
                adminProfiles.add(p.Id);
            } else if (p.Name.contains('Japan')){
                japanProfiles.add(p.Id);
            }
            }
            if (franceProfiles.contains(UserInfo.getProfileId())){
                country = 'FR'; 
            } else if (italyProfiles.contains(UserInfo.getProfileId())){
                country = 'IT'; 
            } else if (germanyProfiles.contains(UserInfo.getProfileId())){
                country = 'GER'; 
            } else if (japanProfiles.contains(UserInfo.getProfileId())){
                country = 'JP'; 
            }else {
                country = 'US';
            }
    }
    
    public void setShowProgramFilter(){
        if (rType == 'Manufacturing France'
        || rType == 'Manufacturing Germany'
        || rType == 'Manufacturing Italy'){
            showProgramFilter = false;
            notShowProgramFilter = true;
        } else {
            showProgramFilter = true;
            notShowProgramFilter = false;
        }
        if (rType == 'Manufacturing France'){
            contractProposalFlag = false;
        } else {
            contractProposalFlag = true;
        }
    } 
    
    //Robert: function to get the proper opportunity name for france or non france
    public String getOppyString(String Name, String Items){    
        String returnString;
    
        if(rtype == 'Manufacturing France'){        
            returnString = '<b>' + Name + '</b>';
        
        } else{        
            returnString = '<b>' + Name + ' - ' + Items + ' Item(s)</b>';        
        }
        return returnString;
    }
}