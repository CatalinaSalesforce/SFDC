/*
@Name           :       GetAdPeriodController
@Author         :
@Date           :   
@Description    :       Controller for MyForecastPage
                        Used to get Ad_Period__c of forecast months to create headings of the JQGrid
*/
public with sharing class GetAdPeriodControllerFranceActual {
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
    public String country{get;set;}
    //Cloud62 5/23/2013 - Added pageName to display for different Record Types
    public String pageName{get;set;}
    
    public string progAmt{get;set;}
    public decimal programAmount;
    public String ProgramStatus{get;set;}
    public String quarter{get;set;}
    public String cycle{get;set;}
    //Cloud62 5/31/2012 - Added oppName to filter on
    public String oppName {get;set;}
    public String currencySymbol {get;set;}
    public Boolean edit1{get;set;}
    public Boolean edit2{get;set;}
    public Boolean edit3{get;set;}
    public Boolean edit4{get;set;}
    public Boolean edit5{get;set;}
    public Boolean edit6{get;set;}
    public Boolean edit7{get;set;}
    public Boolean edit8{get;set;}
    public Boolean edit9{get;set;}
    public Boolean edit10{get;set;}
    public Boolean edit11{get;set;}
    public Boolean edit12{get;set;}
    public Boolean past1{get;set;}
    public Boolean past2{get;set;}
    public Boolean past3{get;set;}
    public Boolean past4{get;set;}
    public Boolean past5{get;set;}
    public Boolean past6{get;set;}
    public Boolean past7{get;set;}
    public Boolean past8{get;set;}
    public Boolean past9{get;set;}
    public Boolean past10{get;set;}
    public Boolean past11{get;set;}
    public Boolean past12{get;set;}
    public List<String> germanyUsrLst;
    public Set<Id> adminProfilesIds;
    public String variance{get;set;}
    public String proposalNumber {get;set;}
    
    public GetAdPeriodControllerFranceActual(){
        dataFound = true;
        ProgramStatus = 'All';
        quarter = '[All]';
        isEditable = true;
        isFirstcolEditable = false;
        variance = 'All';
        pageName='My Actuals Page';
        opportunityId = ApexPages.currentPage().getParameters().get('Id');
        String rtId = ApexPages.currentPage().getParameters().get('rId');
        opp = new Opportunity();
        germanyUsrLst = new List<String>();
        MyActualsCustomSetting__c setting = MyActualsCustomSetting__c.getInstance('Default');
        if(!(setting == null)){
            if(!(setting.GermanyUserNames__c == null)){
                germanyUsrLst = setting.GermanyUserNames__c.split(',');
               
            }
             if(!(setting.GermanyUserNames2__c == null)){
             germanyUsrLst.addAll(setting.GermanyUserNames2__c.split(','));
             }
          
        }
        if(cDate == null){
            currentDate = System.today();
        }
        adminProfilesIds = new Set<Id>();
        if(rType == null){
            //change added by c62
            List<Profile> profiles = [SELECT ID, NAME FROM PROFILE];
            Set<Id> franceProfiles = new Set<Id>();
            Set<Id> italyProfiles = new Set<Id>();
            Set<Id> germanyProfiles = new Set<Id>();
            Set<Id> adminProfiles = new Set<Id>();
            for (Profile p : profiles){
            if (p.Name.contains('France')){
                franceProfiles.add(p.Id);
            } else if (p.Name.contains('Italy')){
                italyProfiles.add(p.Id);
            } else if (p.Name.contains('Germany')){
                germanyProfiles.add(p.Id);
            } else if (p.Name.contains('Admin')){
                adminProfilesIds.add(p.Id);
                adminProfiles.add(p.Id);
            }
            }
            if (franceProfiles.contains(UserInfo.getProfileId())){
                rType = 'Manufacturing France';
                pageName='Mon CA facture';
            } else if (italyProfiles.contains(UserInfo.getProfileId())){
                rType = 'Manufacturing Italy';
                pageName='My Actuals';
            } else if (germanyProfiles.contains(UserInfo.getProfileId())){
                rType = 'Manufacturing Germany';
                pageName='My Actuals';
            } else {
                rType = 'Manufacturing France';
                pageName='Mon CA facture';
            }
        }
        if(rtId != null){
            RecordType rt = [SELECT Name from RecordType WHERE id =: rtId LIMIT 1];
            rType = rt.Name;
        }
        if(opportunityId != null){
            Opportunity opp = [select Account.RecordTypeId from Opportunity Where id =: opportunityId limit 1];
            RecordType rt = [SELECT Name from RecordType WHERE id =: opp.Account.RecordTypeId LIMIT 1];
            
            //change added by c62
             if(rt.Name == 'Manufacturing France'){
                rType = 'Manufacturing France';
            } 
            if(rt.Name == 'Manufacturing Germany'){
                rType = 'Manufacturing Germany';
            }
            if(rt.Name == 'Manufacturing Italy'){
                rType = 'Manufacturing Italy';
            }
        }
        if(stage == null){
            stage='Contract';
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
    public List<Ad_Period__c> reverseList(List<Ad_Period__c> lst){
        List<Ad_Period__c> result;
        for(integer i=0; i< lst.size() / 2; i++)
        {
            Ad_Period__c temp= lst[i];
            lst[i] = lst[lst.size()-i-1];
            lst[lst.size()-i-1] = temp;
        }
        result = lst;
        return result;
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
            //change added by c62
            Set<Id> franceProfiles = new Set<Id>();
            Set<Id> italyProfiles = new Set<Id>();
            Set<Id> germanyProfiles = new Set<Id>();
            Set<Id> adminProfiles = new Set<Id>();
            for (Profile p : profiles){
            if (p.Name.contains('France')){
                franceProfiles.add(p.Id);
            } else if (p.Name.contains('Italy')){
                italyProfiles.add(p.Id);
            } else if (p.Name.contains('Germany')){
                germanyProfiles.add(p.Id);
            } else if (p.Name.contains('Admin')){
                adminProfiles.add(p.Id);
            }
            }
            if (franceProfiles.contains(UserInfo.getProfileId())){
                rType = 'Manufacturing France';
            } else if (italyProfiles.contains(UserInfo.getProfileId())){
                rType = 'Manufacturing Italy';
            } else if (germanyProfiles.contains(UserInfo.getProfileId())){
                rType = 'Manufacturing Germany';
            } else {
                rType = 'Manufacturing France';
            }
            
            stage = 'All';
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
        /*if(currentDate < System.today()){
            isEditable = false;
        }*/
        /*if(currentDate < System.today().addMonths(-7)){
            noPre = true;
            currentDate = System.today();
            isFirstcolEditable = false;
            isEditable = true;
        }*/
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
        }
        getAdPeriodNames();
        doRefresh=true;
        loadGrid();
        return null;
    }
    
    public void getAdPeriodNames(){
        edit1 = false;
        edit2 = false;
        edit3 = false;
        edit4 = false;
        edit5 = false;
        edit6 = false;
        edit7 = false;
        edit8 = false;
        edit9 = false;
        edit10 = false;
        edit11 = false;
        edit12 = false;
        past1 = false;
        past2 = false;
        past3 = false;
        past4 = false;
        past5 = false;
        past6 = false;
        past7 = false;
        past8 = false;
        past9 = false;
        past10 = false;
        past11 = false;
        past12 = false;
        system.debug('rTypeGet>>'+rType);
        noMoreAdPeriods = false;
        if(lastAdPeriodStartDate == null || noPre == true || navigation =='search'){ // Loading ad periods on search or first time grid loads
            isFirstcolEditable = false;
            Stage = 'Contract';
            /*if(rType == 'Retail'){
                adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                                WHERE (End_Date__c >=: System.today() OR 
                                (End_Date__c >=: system.today().addMonths(-1) AND Start_Date__c <=: system.today().addMonths(-1))) AND 
                                Type__c =: rType 
                                AND Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7') 
                                Order by Start_Date__c LIMIT 7];
            }else if(rType == 'Manufacturing'){
                adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                                WHERE (End_Date__c >=: System.today() OR 
                                (End_Date__c >=: system.today().addDays(-28) AND Start_Date__c <=: system.today().addDays(-28))) AND 
                                Type__c =: rType 
                                AND Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7') 
                                Order by Start_Date__c LIMIT 7];
            }else if(rType == 'Manufacturing France'){
                adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                                WHERE (Start_Date__c <=: System.today() OR 
                                (End_Date__c >=: system.today().addDays(28) AND Start_Date__c <=: system.today().addDays(28))) AND 
                                Type__c =: rType AND
                                (Start_Date__c >=: system.today().addDays((-60)*7)) AND
                                Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7') 
                                Order by End_Date__c LIMIT 7];
            }*/
            // rType is always 'Manufacturing France' for MyForecastActualFrance page
            Date currentYearSD = Date.newInstance(system.today().year(),1,1);
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
  /*          adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                                WHERE //End_Date__c <: system.today() AND  
                                Type__c =: rType AND 
                                (Start_Date__c>=: currentYearSD) AND 
                                Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7') 
                                Order by Start_Date__c ASC LIMIT 12];
  */  
            //adPeriodList = reverseList(adPeriodList);
                                
        }else if(lastAdPeriodStartDate != null && navigation == 'next'){ // Loading next cycle ad periods
            noMoreAdPeriods = true;
      /*      adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                            WHERE Start_Date__c >: lastAdPeriodStartDate AND 
                            Type__c =: rType AND 
                            Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7') 
                            Order by Start_Date__c ASC LIMIT 12];
       */    
        }else if(firstAdPeriodStartDate != null && navigation == 'pre'){ // loading previous cycle ad periods
            // Remove noPre and uncomment if want access to more than 6 months before
            noPre = true;
         /*List<Ad_Period__c> adPeriods = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                                            WHERE Start_Date__c <: firstAdPeriodStartDate AND 
                                            Type__c =: rType AND
                                            Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7')
                                            Order by Start_Date__c desc LIMIT 7];
            adPeriodList = new List<Ad_Period__c>();
            if(adPeriods.size() == 7){
                for(integer i = adPeriods.size()-1 ; i >= adPeriods.size()-7 ; i--){
                    adPeriodList.add(adPeriods[i]);
                }
            }*/
        }else if(navigation == 'none' && firstAdPeriodStartDate != null){ // Refreshing grid data after save
            if(rType == 'Retail' && firstAdPeriodStartDate == system.today().addMonths(-1)){ // If saving Retail data on begining page
                    adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                                    WHERE (Start_Date__c >=: firstAdPeriodStartDate OR 
                                    (End_Date__c >=: system.today().addMonths(-1) AND Start_Date__c <=: system.today().addMonths(-1))) AND 
                                    Type__c =: rType 
                                    AND Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7')
                                    Order by Start_Date__c LIMIT 7];
           }else if (rType == 'Manufacturing' && firstAdPeriodStartDate == system.today().addDays(-28)){// If saving Manufacturing data on begining page
                    adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                                    WHERE (Start_Date__c >=: firstAdPeriodStartDate OR 
                                    (End_Date__c >=: system.today().addDays(-28) AND Start_Date__c <=: system.today().addDays(-28))) AND 
                                    Type__c =: rType 
                                    AND Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7')
                                    Order by Start_Date__c LIMIT 7];
           }else if ((rType == 'Manufacturing France' || rType == 'Manufacturing Italy' || rType == 'Manufacturing Germany') && firstAdPeriodStartDate == system.today().addDays(-28)){// If saving Manufacturing data on begining page
                    adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                                    WHERE (Start_Date__c >=: firstAdPeriodStartDate OR 
                                    (End_Date__c >=: system.today().addDays(-28) AND Start_Date__c <=: system.today().addDays(-28))) AND 
                                    Type__c =: rType 
                                    AND Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7')
                                    Order by Start_Date__c LIMIT 12];
           }else{// if saving data on other than begining page
                adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                                WHERE Start_Date__c >=: firstAdPeriodStartDate AND 
                                Type__c =: rType AND 
                                Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7')
                                Order by Start_Date__c LIMIT 12];
            }
        }
        
        adPeriodNames = '';
        
        if(adPeriodList.size() < 7){
            noMoreAdPeriods = true;
            //currentDate = currentDate.addMonths(-6);
            currentDate = system.today();
            
            if(currentDate <= system.today()){
                isFirstcolEditable = false;
            }
            
            if(rType == 'Retail'){
                adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                                WHERE (End_Date__c >=: System.today() OR 
                                (End_Date__c >=: system.today().addMonths(-1) AND Start_Date__c <=: system.today().addMonths(-1))) AND 
                                Type__c =: rType AND
                                Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7') 
                                Order by Start_Date__c LIMIT 7];
            }else if(rType == 'Manufacturing'){
                adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                                WHERE (End_Date__c >=: System.today() OR 
                                (End_Date__c >=: system.today().addDays(-28) AND Start_Date__c <=: system.today().addDays(-28))) AND 
                                Type__c =: rType AND
                                Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7') 
                                Order by Start_Date__c LIMIT 7];
            }else if(rType == 'Manufacturing France' || rType == 'Manufacturing Italy' || rType == 'Manufacturing Germany'){
                adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                                WHERE (End_Date__c >=: System.today() OR 
                                (End_Date__c >=: system.today().addDays(-28) AND Start_Date__c <=: system.today().addDays(-28))) AND 
                                Type__c =: rType AND
                                Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7') 
                                Order by Start_Date__c LIMIT 12];
            }
        }
        if(adPeriodList.size() == 0){
            dataFound = false;
        }else{
            firstAdPeriodStartDate = adPeriodList[0].Start_Date__c;
            lastAdPeriodStartDate = adPeriodList[6].Start_Date__c;
            
            Date currentCycleDate = system.today();
            Integer i=1;
            Set<String> germanyUsrSet = new Set<String>();
            germanyUsrSet.addAll(germanyUsrLst);
            for(Ad_Period__c ad : adPeriodList){
                //Added by Cloud62 5/31/2013 - This was requested by the Italy team to increase readability
                if(rType == 'Manufacturing Italy'){
                    adPeriodNames += ad.Name.subString(6)+','; //do substring work here - change from IT_AP_C#_YYYY to C#_YYYY subString(6)
                }else{
                    adPeriodNames += ad.Name+',';
                }
                if(ad.Start_Date__c <= currentCycleDate && ad.End_Date__c >= currentCycleDate){
                    if(rType == 'Manufacturing Germany'){
                        if(i==1 && (germanyUsrSet.contains(UserInfo.getUserName()) || adminProfilesIds.contains(UserInfo.getProfileId()))){
                            edit1=true;
                        }else if(i==2 && (germanyUsrSet.contains(UserInfo.getUserName()) || adminProfilesIds.contains(UserInfo.getProfileId()))){
                            edit2=true;
                        }else if(i==3 && (germanyUsrSet.contains(UserInfo.getUserName()) || adminProfilesIds.contains(UserInfo.getProfileId()))){
                            edit3=true;
                         
                        }else if(i==4 && (germanyUsrSet.contains(UserInfo.getUserName()) || adminProfilesIds.contains(UserInfo.getProfileId()))){
                            edit4=true;
                        }else if(i==5 && (germanyUsrSet.contains(UserInfo.getUserName()) || adminProfilesIds.contains(UserInfo.getProfileId()))){
                            edit5=true;
                        }else if(i==6 && (germanyUsrSet.contains(UserInfo.getUserName()) || adminProfilesIds.contains(UserInfo.getProfileId()))){
                            edit6=true;
                        }else if(i==7 && (germanyUsrSet.contains(UserInfo.getUserName()) || adminProfilesIds.contains(UserInfo.getProfileId()))){
                            edit7=true;
                        }else if(i==8 && (germanyUsrSet.contains(UserInfo.getUserName()) || adminProfilesIds.contains(UserInfo.getProfileId()))){
                            edit8=true;
                        }else if(i==9 && (germanyUsrSet.contains(UserInfo.getUserName()) || adminProfilesIds.contains(UserInfo.getProfileId()))){
                            edit9=true;
                        }else if(i==10 && (germanyUsrSet.contains(UserInfo.getUserName()) || adminProfilesIds.contains(UserInfo.getProfileId()))){
                            edit10=true;
                        }else if(i==11 && (germanyUsrSet.contains(UserInfo.getUserName()) || adminProfilesIds.contains(UserInfo.getProfileId()))){
                            edit11=true;
                        }else if(i==12 && (germanyUsrSet.contains(UserInfo.getUserName()) || adminProfilesIds.contains(UserInfo.getProfileId()))){
                            edit12=true;
                        }
                    } else {
                        if(i==1){
                            edit1=true;
                        }else if(i==2){
                            edit2=true;
                        }else if(i==3){
                            edit3=true;
                        }else if(i==4){
                            edit4=true;
                        }else if(i==5){
                            edit5=true;
                        }else if(i==6){
                            edit6=true;
                        }else if(i==7){
                            edit7=true;
                        }else if(i==8){
                            edit8=true;
                        }else if(i==9){
                            edit9=true;
                        }else if(i==10){
                            edit10=true;
                        }else if(i==11){
                            edit11=true;
                        }else if(i==12){
                            edit12=true;
                        }
                    }
                }
                 //process past grayness
                if(i==1){
                    if (ad.End_Date__c < Date.today() && !edit1) past1 = true;
                }else if(i==2){
                    if (ad.End_Date__c < Date.today() && !edit2) past2 = true;
                }else if(i==3){
                    if (ad.End_Date__c < Date.today() && !edit3) past3 = true;
                }else if(i==4){
                    if (ad.End_Date__c < Date.today() && !edit4) past4 = true;
                }else if(i==5){
                    if (ad.End_Date__c < Date.today() && !edit5) past5 = true;
                }else if(i==6){
                    if (ad.End_Date__c < Date.today() && !edit6) past6 = true;
                }else if(i==7){
                    if (ad.End_Date__c < Date.today() && !edit7) past7 = true;
                }else if(i==8){
                    if (ad.End_Date__c < Date.today() && !edit8) past8 = true;
                }else if(i==9){
                    if (ad.End_Date__c < Date.today() && !edit9) past9 = true;
                }else if(i==10){
                   if (ad.End_Date__c < Date.today() && !edit10) past10 = true;
                }else if(i==11){
                    if (ad.End_Date__c < Date.today() && !edit11) past11 = true;
                }else if(i==12){
                    if (ad.End_Date__c < Date.today() && !edit12) past12 = true;
                }
                i++;
            }
            if(rType == 'Manufacturing Germany'){
          
                if(edit2){edit1=true;}
                if(edit3){edit1=true;edit2=true;}
                if(edit4){edit1=true;edit2=true;edit3=true;}
                if(edit5){edit1=true;edit2=true;edit3=true;edit4=true;}
                if(edit6){edit1=true;edit2=true;edit3=true;edit4=true;edit5=true;}
                if(edit7){edit2=true;edit3=true;edit4=true;edit5=true;edit6=true;}
                if(edit8){edit3=true;edit4=true;edit5=true;edit6=true;edit7=true;}
                if(edit9){edit4=true;edit5=true;edit6=true;edit7=true;edit8=true;}
                if(edit10){edit5=true;edit6=true;edit7=true;edit8=true;edit9=true;}
                if(edit11){edit6=true;edit7=true;edit8=true;edit9=true;edit10=true;}
                if(edit12){edit7=true;edit8=true;edit9=true;edit10=true;edit11=true;}
            }else{
                if(edit2){edit1=true;}
                if(edit3){edit2=true;}
                if(edit4){edit3=true;}
                if(edit5){edit4=true;}
                if(edit6){edit5=true;}
                if(edit7){edit6=true;}
                if(edit8){edit7=true;}
                if(edit9){edit8=true;}
                if(edit10){edit9=true;}
                if(edit11){edit10=true;}
                if(edit12){edit11=true;}
            }
            past1 = past1 && !edit1;
            past2 = past2 && !edit2;
            past3 = past3 && !edit3;
            past4 = past4 && !edit4;
            past5 = past5 && !edit5;
            past6 = past6 && !edit6;
            past7 = past7 && !edit7;
            past8 = past8 && !edit8;
            past9 = past9 && !edit9;
            past10 = past10 && !edit10;
            past11 = past11 && !edit11;
            past12 = past12 && !edit12;
            adPeriodNames = adPeriodNames.subString(0,adPeriodNames.length()-1);
        }
    }
    
    public void loadGrid(){
        dataFound = true;
        cDate = String.valueOf(currentDate);
        MyForecastActualFranceController myForPg = new MyForecastActualFranceController(opportunityId, cDate, rType, stage, accountName, oppUser, programStatus, programAmount, quarter, firstAdPeriodStartDate, oppName, year, cycle,  variance, proposalNumber);
        jSonString = myforPg.jSonString;
        currencySymbol = myforPg.currencySymbol;
        if(jSonString.length() <=1){
            dataFound = false;
            ApexPages.Message message = new ApexPages.Message(ApexPages.Severity.INFO, 'No Records Found!');
            ApexPages.addMessage(message);
        }
    }
    
    public void saveJSon(){
        saveGridActualController saveGrid = new saveGridActualController(jsonToSave,cDateString,recType,firstAdPeriodStartDate);
        
    }
    
    public List<SelectOption> getAccounttypes(){
        //change added by c62 to add record types
        List<Profile> profiles = [SELECT ID, NAME FROM PROFILE];
        Set<Id> franceProfiles = new Set<Id>();
        Set<Id> germanyProfiles = new Set<Id>();
        Set<Id> italyProfiles = new Set<Id>();
        Set<Id> adminProfiles = new Set<Id>();
        for (Profile p : profiles){
            if (p.Name.contains('France')){
                franceProfiles.add(p.Id);
            } else if (p.Name.contains('Admin')){
                adminProfiles.add(p.Id);
            } else if (p.Name.contains('Germany')){
                germanyProfiles.add(p.Id);
            }else if (p.Name.contains('Italy')){
                italyProfiles.add(p.Id);
            }
        }
        List<SelectOption> options = new List<SelectOption>();
        if (franceProfiles.contains(UserInfo.getProfileId())){
            options.add(new SelectOption('Manufacturing France', 'Manufacturing France'));
        }else if (adminProfiles.contains(UserInfo.getProfileId())){
            options.add(new SelectOption('Manufacturing Italy', 'Manufacturing Italy'));
            options.add(new SelectOption('Manufacturing Germany', 'Manufacturing Germany'));
            options.add(new SelectOption('Manufacturing France', 'Manufacturing France'));
        }else if (germanyProfiles.contains(UserInfo.getProfileId())){
            options.add(new SelectOption('Manufacturing Germany', 'Manufacturing Germany'));
        }else if (italyProfiles.contains(UserInfo.getProfileId())){
            options.add(new SelectOption('Manufacturing Italy', 'Manufacturing Italy'));
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
    
    public List<SelectOption> getVariances(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('All','All'));
        options.add(new SelectOption('Positive','Positive'));
        options.add(new SelectOption('Negative','Negative'));
        return options;
    }
    
    public List<SelectOption> getCycles(){
        List<SelectOption> options = new List<SelectOption>();
        //change added by c62
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
        //options.add(new SelectOption(String.valueOf(year+1),String.valueOf(year+1)));
        //options.add(new SelectOption(String.valueOf(year+2),String.valueOf(year+2)));
        return options;
    }
    
    public void setCountryCode(){
        //change added by c62
        List<Profile> profiles = [SELECT ID, NAME FROM PROFILE];
            Set<Id> franceProfiles = new Set<Id>();
            Set<Id> italyProfiles = new Set<Id>();
            Set<Id> germanyProfiles = new Set<Id>();
            Set<Id> adminProfiles = new Set<Id>();
            for (Profile p : profiles){
            if (p.Name.contains('France')){
                franceProfiles.add(p.Id);
            } else if (p.Name.contains('Italy')){
                italyProfiles.add(p.Id);
            } else if (p.Name.contains('Germany')){
                germanyProfiles.add(p.Id);
            } else if (p.Name.contains('Admin')){
                adminProfiles.add(p.Id);
            }
            }
            if (franceProfiles.contains(UserInfo.getProfileId())){
                country = 'FR'; 
            } else if (italyProfiles.contains(UserInfo.getProfileId())){
                country = 'IT'; 
            } else if (germanyProfiles.contains(UserInfo.getProfileId())){
                country = 'GER'; 
            } else {
                country = 'US';
            }
    }
    
}