/*
Trigger to add details for Oppty used in threshold report.
The categories of details that need to be populated are:
1. Users in the hierarchy related to this oppty
2. Program Delivery Types
3. Related Ad Periods
    
Author: Warren
Email: warren@cloud62.com

2013-02-03 added lines to clear user hierarchy values
*/
trigger UpdateOpportunityDetails on Opportunity (before insert, before update) {
    
    final static String q1Start = '-01-01';
    final static String q2Start = '-04-01';
    final static String q3Start = '-07-01';
    final static String q4Start = '-10-01';
    final static String q1End = '-03-31';
    final static String q2End = '-06-30';
    final static String q3End = '-09-30';
    final static String q4End = '-12-31';
    final static Integer currentYear = Date.Today().year();
    final static String defaultSettingsName = 'Default';
    
    Map<Id, List<Program__c>> opptyProgramMap = new Map<Id, List<Program__c>>();
    Map<Id, Set<Program_Forecast__c>> opptyProgramForecastMap = new Map<Id, Set<Program_Forecast__c>>();
    Map<Id, Set<String>> opptyAdPeriodMap = new Map<Id, Set<String>>();
    Map<Id, Set<String>> opptyProductType = new Map<Id, Set<String>>();
    Map<Id, Set<String>> opptyQuarters = new Map<Id, Set<String>>();
    Map<Id, List<String>> opptyAdPeriodMapList = new Map<Id, List<String>>();
    Map<Id, List<Program_Forecast__c>> opptyProgramForecastMapList = new Map<Id, List<Program_Forecast__c>>();
    Map<Id, List<Opportunity_Category__c>> opptyCatMap = new Map<Id, List<Opportunity_Category__c>>(); 
    Set<Id> accList = new Set<ID>();
    Map<Id, User> userMap = new Map<Id, User>();
    Set<Id> oppList = new Set<Id>();
    Set<Id> oppListUpdate = new Set<Id>();
    Set<Id> ownerList = new Set<Id>();
    Map<Id, User> SR2 = New Map<Id, User>();
    Map<Id, User> SR1 = New Map<Id, User>();
    Map<Id, User> SM2 = New Map<Id, User>();
    Map<Id, User> SM1 = New Map<Id, User>();
    Set<Id> forecastingUser = new Set<Id>();
    Map<Id, RecordType> rtMap = new Map<Id, RecordType>();
    String rep2Type;
    String rep1Type;
    String SM2Type;
    String SM1Type;
    String coopType;
    String cbuName;
    String[] catalinaBusinessUnitStrings;
    Boolean catalinaBusinessUnitProgramDeliveryType;
    Boolean isMultiyear;
    
    //Mar 14 2013 - added by Warren to get RecordTypes
    for (RecordType r : [SELECT ID, NAME, DEVELOPERNAME FROM RECORDTYPE]){
        rtMap.put(r.Id, r);
    }
    
    //Map<Id, User> EVP = New Map<Id, User>();
    Catalina_Forecast_Settings__c settings = Catalina_Forecast_Settings__c.getInstance(defaultSettingsName);
    if (settings != null){
        rep2Type = settings.Rep_2_String__c;
        rep1Type = settings.Rep_1_String__c;
        SM2Type = settings.SM_2_String__c;
        SM1Type = settings.SM_1_String__c;
        coopType = settings.Coop_String__c;
    }
    
    for (Opportunity o : Trigger.new){
        o.Opportunity_Owner_Manager__c = null;
        oppList.add(o.Id);
        accList.add(o.AccountId);
        if (Trigger.isUpdate) oppListUpdate.add(o.Id);
        ownerList.add(o.OwnerId);
        o.To_Be_Updated__c = false;
    }
    
    if (oppList.size() > 0){
        List<User> users = [SELECT Id, Forecast_Role__c, ManagerId From User Where Forecast_Role__c != NULL And ManagerID  != NULL ];
        //Mar 14 2013
        for (User u : users){
            Boolean isForecasting = false;
            if (u.Forecast_Role__c == rep2Type){
                SR2.put(u.Id, u);
                isForecasting = true;
            } else if (u.Forecast_Role__c == rep1Type){
                SR1.put(u.Id, u);
                isForecasting = true;
            } if (u.Forecast_Role__c == SM2Type){
                SM2.put(u.Id, u);
                isForecasting = true;
            } else if (u.Forecast_Role__c == SM1Type || u.Forecast_Role__c == coopType){
                SM1.put(u.Id, u);
                isForecasting = true;
            }
        }
    }
    
    List<Program__c> programs = [Select Id, Delivery_Type__c, Brand__c, Opportunity__c, Product_Type__c, Start_Cycle__r.Start_Date__c From Program__c Where Opportunity__c IN: oppListUpdate Order By Delivery_Type__c];
    
    for (Program__c p : programs){
        if (!opptyProgramMap.containsKey(p.Opportunity__c)){
            opptyProgramMap.put(p.Opportunity__c, new List<Program__c>());
            opptyProductType.put(p.Opportunity__c, new Set<String>());
        }
        opptyProgramMap.get(p.Opportunity__c).add(p);
        if (p.Product_Type__c != null){
            for (String x : p.Product_Type__c.split(';')){
                opptyProductType.get(p.Opportunity__c).add(x);
            }
        }
        
    }
    
    List<Program_Forecast__c> pfs = [Select Id, Name, Ad_Period__r.Name, Ad_Period__r.Start_Date__c, Ad_Period__r.End_Date__c, Program__r.Opportunity__c, Previous_Quarter_Amount__c, Next_Quarter_Amount__c, Forecast_Amount__c, Actual_Amount__c, Previous_Quarter_Actual__c, Next_Quarter_Actual__c From Program_Forecast__c Where Program__r.Opportunity__c IN :oppListUpdate Order By Ad_Period__r.Start_Date__c ASC]; 
    
    for (Program_Forecast__c p : pfs){
        if (!opptyAdPeriodMap.containsKey(p.Program__r.Opportunity__c)){
            opptyAdPeriodMap.put(p.Program__r.Opportunity__c, new Set<String>());
            opptyAdPeriodMapList.put(p.Program__r.Opportunity__c, new List<String>());
        }
        if (!opptyAdPeriodMap.get(p.Program__r.Opportunity__c).contains(p.Ad_Period__r.Name)){
            opptyAdPeriodMap.get(p.Program__r.Opportunity__c).add(p.Ad_Period__r.Name);
            opptyAdPeriodMapList.get(p.Program__r.Opportunity__c).add(p.Ad_Period__r.Name);
        }
        
        if (!opptyQuarters.containsKey(p.Program__r.Opportunity__c)){
            opptyQuarters.put(p.Program__r.Opportunity__c, new Set<String>());
        }
        
        if (p.Ad_Period__r.Start_Date__c <= Date.valueOf(currentYear + q1End) && p.Ad_Period__r.End_Date__c >= Date.valueOf(currentYear + q1Start)){
            opptyQuarters.get(p.Program__r.Opportunity__c).add('Q1');
        }
        if (p.Ad_Period__r.Start_Date__c <= Date.valueOf(currentYear + q2End) && p.Ad_Period__r.End_Date__c >= Date.valueOf(currentYear + q2Start)){
            opptyQuarters.get(p.Program__r.Opportunity__c).add('Q2');
        }
        if (p.Ad_Period__r.Start_Date__c <= Date.valueOf(currentYear + q3End) && p.Ad_Period__r.End_Date__c >= Date.valueOf(currentYear + q3Start)){
            opptyQuarters.get(p.Program__r.Opportunity__c).add('Q3');
        }
        if (p.Ad_Period__r.Start_Date__c <= Date.valueOf(currentYear + q4End) && p.Ad_Period__r.End_Date__c >= Date.valueOf(currentYear + q4Start)){
            opptyQuarters.get(p.Program__r.Opportunity__c).add('Q4');
        }
        //Added by JB to populate a map<Id, List<Program_Forecast>>
        if (!opptyProgramForecastMap.containsKey(p.Program__r.Opportunity__c)){
            opptyProgramForecastMap.put(p.Program__r.Opportunity__c, new Set<Program_Forecast__c>());
            opptyProgramForecastMapList.put(p.Program__r.Opportunity__c, new List<Program_Forecast__c>());
        }
        if (!opptyProgramForecastMap.get(p.Program__r.Opportunity__c).contains(p)){
            opptyProgramForecastMap.get(p.Program__r.Opportunity__c).add(p);
            opptyProgramForecastMapList.get(p.Program__r.Opportunity__c).add(p);
        }
        
    }
    List<Opportunity_Category__c> oppCats = [SELECT ID, NAME, CATEGORY__C, OPPORTUNITY__C, CAT_NUMBER__C, CATEGORY_DESCRIPTION__C FROM OPPORTUNITY_CATEGORY__C WHERE OPPORTUNITY__C IN :oppList];
    for (Opportunity_Category__c cat : oppCats){
        if (!opptyCatMap.containsKey(cat.Opportunity__c)){
            opptyCatMap.put(cat.Opportunity__c, new List<Opportunity_Category__c>());
        }
        opptyCatMap.get(cat.Opportunity__c).add(cat);
    }
    
    for (Opportunity o : Trigger.new){
        String delType = '';
        //added by Warren for brands list on threshold report
        String brandText = '';
        if (opptyProgramMap.containsKey(o.Id)){
            Date startDate;
            for (Program__c p : opptyProgramMap.get(o.Id)){
                if (delType != '') deltype += ';';
                delType += p.Delivery_Type__c;
                if (p.Start_Cycle__c != null && o.Start_Date__c == null){
                    if (startDate == null){
                        startDate = p.Start_Cycle__r.Start_Date__c;
                    } else if (startDate > p.Start_Cycle__r.Start_date__c){
                        startDate = p.Start_Cycle__r.Start_Date__c;
                    }
                    
                    o.Start_Date__c = startDate;
                }
                if (p.Brand__c != null){
	                if (brandText != '') brandText += ';';
	                brandText += p.Brand__c;
                }
            }
        }
        if (brandText.length() > 255) brandText = brandText.substring(255);
        o.Brands__c = brandText;
        
        String progCycles = '';
        if (opptyAdPeriodMapList.containsKey(o.Id)){
            for (String x : opptyAdPeriodMapList.get(o.Id)){
                if (progCycles != '') progCycles += ', ';
                progCycles += x;
            }
        }
        
        String prodTypes = '';
        if (opptyProductType.containsKey(o.Id)){
            Set<String> types = new Set<String>();
            for (String x : opptyProductType.get(o.Id)){
                types.add(x);
            }
            for (String x : types){
                if (prodTypes != '') prodTypes += ';';
                prodTypes += x;
            }
        }
        //commented out by Dru on Mar 19th, no longer need to overwrite field
        //o.Catalina_Business_Unit__c = delType;
        
        String categories = '';
        if (opptyCatMap.containsKey(o.Id)){
            for (Opportunity_Category__c cat : opptyCatMap.get(o.Id)){
                if (categories != '') categories += ', ';
                categories += cat.Cat_Number__c + ' - ' + cat.Category_Description__c;
            }
        }
        o.Categories__c = categories;
        
        if (progCycles.length() <= 255){
            o.Program_Cycles__c = progCycles;
        } else {
            o.Program_Cycles__c = progCycles.substring(0, 250);    
        }
        if (prodTypes.length() <= 255){
            o.Product_Type__c = prodTypes;
        } else {
            o.Product_Type__c = prodTypes.substring(0, 250);    
        }
        
        //update Quarter fields fields
        o.Q1__c = '';
        o.Q2__c = '';
        o.Q3__c = '';
        o.Q4__c = '';
        o.Quarter_Filter__c = '';
        if (opptyQuarters.containsKey(o.Id)){
            Set<String> quarters = opptyQuarters.get(o.Id);
            if (quarters.contains('Q1')){
                o.Q1__c = 'Y';
            }
            if (quarters.contains('Q2')){
                o.Q2__c = 'Y';
            }
            if (quarters.contains('Q3')){
                o.Q3__c = 'Y';
            }
            if (quarters.contains('Q4')){
                o.Q4__c = 'Y';
            }
            for (String x : quarters){
                if (o.Quarter_Filter__c != '') o.Quarter_Filter__c += ',';
                o.Quarter_Filter__c += x; 
            }
        }
        
        //feb 3 2013, added to clear values
        o.Sales_Rep_2__c = null;
        o.Sales_Rep_1__c = null;
        o.Sales_Manager_2__c = null;
        o.Sales_Manager_1__c = null;
        o.EVP__c = null;
        //Mar 14 2013 - added by Warren - branch to handle Japan specific hierarchy and report requirements
        if (rtMap.get(o.RecordTypeId).DeveloperName.contains('Japan')){
            if (SR2.containsKey(o.OwnerId)){
                o.Sales_Rep_2__c = o.OwnerId;
                o.Sales_Rep_1__c = SR2.get(o.OwnerId).ManagerId;
                o.Opportunity_Owner_Manager__c = SR2.get(o.OwnerId).ManagerId;
                if (o.Sales_Rep_1__c != null){
                    if (SR1.containsKey(o.Sales_Rep_1__c)){
                        o.Sales_Manager_2__c = SR1.get(o.Sales_Rep_1__c).ManagerId;
                    } else {
                        o.Sales_Manager_2__c = o.Sales_Rep_1__c;
                    }
                }
                if (o.Sales_Manager_2__c != null){
                    if (SM2.containsKey(o.Sales_Manager_2__c)){
                        o.Sales_Manager_1__c = SM2.get(o.Sales_Manager_2__c).ManagerId;
                    } else {
                        o.Sales_Manager_1__c = o.Sales_Manager_2__c;
                    }
                }
                if (o.Sales_Manager_1__c != null){
                    if (SM1.containsKey(o.Sales_Manager_1__c)){
                        o.EVP__c = SM1.get(o.Sales_Manager_1__c).ManagerId;
                    } else {
                        o.EVP__c = o.Sales_Manager_1__c;
                    }
                }
            } else if (SR1.containsKey(o.OwnerId)){
                o.Sales_Rep_1__c = o.OwnerId;
                o.Sales_Manager_2__c = SR1.get(o.Sales_Rep_1__c).ManagerId;
                o.Opportunity_Owner_Manager__c = SR1.get(o.Sales_Rep_1__c).ManagerId;
                if (o.Sales_Manager_2__c != null){
                    if (SM2.containsKey(o.Sales_Manager_2__c)){
                        o.Sales_Manager_1__c = SM2.get(o.Sales_Manager_2__c).ManagerId;
                    } else {
                        o.Sales_Manager_1__c = o.Sales_Manager_2__c;
                    }
                }
                if (o.Sales_Manager_1__c != null){
                    if (SM1.containsKey(o.Sales_Manager_1__c)){
                        o.EVP__c = SM1.get(o.Sales_Manager_1__c).ManagerId;
                    } else {
                        o.EVP__c = o.Sales_Manager_1__c;
                    }
                }
            } else if (SM2.containsKey(o.OwnerId)){
                o.Sales_Manager_2__c = o.OwnerId;
                o.Sales_Manager_1__c = SM2.get(o.Sales_Manager_2__c).ManagerId;
                o.Opportunity_Owner_Manager__c = SM2.get(o.Sales_Manager_2__c).ManagerId;
                if (o.Sales_Manager_1__c != null){
                    if (SM1.containsKey(o.Sales_Manager_1__c)){
                        o.EVP__c = SM1.get(o.Sales_Manager_1__c).ManagerId;
                    } else {
                        o.EVP__c = o.Sales_Manager_1__c;
                    }
                }
            } else if (SM1.containsKey(o.OwnerId)){
                o.Sales_Manager_1__c = o.OwnerId;
                o.EVP__c = SM1.get(o.Sales_Manager_1__c).ManagerId;
                o.Opportunity_Owner_Manager__c = SM1.get(o.Sales_Manager_1__c).ManagerId;
            }
        } else {
            if (SR2.containsKey(o.OwnerId)){
                o.Sales_Rep_2__c = o.OwnerId;
                o.Sales_Rep_1__c = SR2.get(o.OwnerId).ManagerId;
                o.Opportunity_Owner_Manager__c = SR2.get(o.OwnerId).ManagerId;
                if (o.Sales_Rep_1__c != null){
                    if (SR1.containsKey(o.Sales_Rep_1__c)) o.Sales_Manager_2__c = SR1.get(o.Sales_Rep_1__c).ManagerId;
                }
                if (o.Sales_Manager_2__c != null){
                    if (SM2.containsKey(o.Sales_Manager_2__c)) o.Sales_Manager_1__c = SM2.get(o.Sales_Manager_2__c).ManagerId;
                }
                if (o.Sales_Manager_1__c != null){
                    if (SM1.containsKey(o.Sales_Manager_1__c)) o.EVP__c = SM1.get(o.Sales_Manager_1__c).ManagerId;
                }
            } else if (SR1.containsKey(o.OwnerId)){
                o.Sales_Rep_1__c = o.OwnerId;
                o.Sales_Manager_2__c = SR1.get(o.Sales_Rep_1__c).ManagerId;
                o.Opportunity_Owner_Manager__c = SR1.get(o.Sales_Rep_1__c).ManagerId;
                if (o.Sales_Manager_2__c != null){
                    if (SM2.containsKey(o.Sales_Manager_2__c)) o.Sales_Manager_1__c = SM2.get(o.Sales_Manager_2__c).ManagerId;
                }
                if (o.Sales_Manager_1__c != null){
                    if (SM1.containsKey(o.Sales_Manager_1__c)) o.EVP__c = SM1.get(o.Sales_Manager_1__c).ManagerId;
                }
            } else if (SM2.containsKey(o.OwnerId)){
                o.Sales_Manager_2__c = o.OwnerId;
                o.Sales_Manager_1__c = SM2.get(o.Sales_Manager_2__c).ManagerId;
                o.Opportunity_Owner_Manager__c = SM2.get(o.Sales_Manager_2__c).ManagerId;
                if (o.Sales_Manager_1__c != null){
                    if (SM1.containsKey(o.Sales_Manager_1__c)) o.EVP__c = SM1.get(o.Sales_Manager_1__c).ManagerId;
                }
            } else if (SM1.containsKey(o.OwnerId)){
                o.Sales_Manager_1__c = o.OwnerId;
                o.EVP__c = SM1.get(o.Sales_Manager_1__c).ManagerId;
                o.Opportunity_Owner_Manager__c = SM1.get(o.Sales_Manager_1__c).ManagerId;
            }
        }
    //Added by Matt to address Catalina Business Unit vs Program delivery type matching
    /*
    If a user removes a Catalina Business Unit where a Program already exists, throw error.
    so make sure that for each catalina business unit, there is a brogram with that delivery type
        */
        //map exists that is map(oppty, program)
        //find oppty by id, then you can get a list of programs.
        //for each program in opptymap.get(o.id)  
        //then do things on the corresponding programs
    }
    for(Opportunity o : Trigger.new){   
        system.debug(o.Catalina_Business_Unit__c);
        if(o.Catalina_Business_Unit__c == null){
            system.debug('null CBU: ' + o.Name);
        } else {
            if(Trigger.oldMap != null && Trigger.oldMap.containsKey(o.Id)){
                if(o.Catalina_Business_Unit__c != Trigger.oldMap.get(o.Id).Catalina_Business_Unit__c){
                     if (opptyProgramMap.containsKey(o.Id)){
                        if (o.Catalina_Business_Unit__c != null){
                            catalinaBusinessUnitStrings = o.Catalina_Business_Unit__c.Split(';');
                        } else {
                            catalinaBusinessUnitStrings = new String[]{''};
                        }
                        if(Trigger.oldMap.get(o.Id).Catalina_Business_Unit__c != null){ //if old value was null and oppty now has a cbu, don't do anything
                            for (Program__c p : opptyProgramMap.get(o.Id)){
                                catalinaBusinessUnitProgramDeliveryType = false;
                                for(String s : catalinaBusinessUnitStrings){
                                    if(s == p.Delivery_Type__c){
                                        catalinaBusinessUnitProgramDeliveryType = true;
                                        cbuName = s;
                                    }
                                }
                                if(!catalinaBusinessUnitProgramDeliveryType){
                                    o.addError(' To remove a Catalina Business Unit you must delete the corresponding Program.' );
                                }
                             }
                        } else {
                            //don't do anything - ok to go from null CBU to CBU with values
                        }
                     }
                 }
            }
        }
    }
    
    /*
    *   Adding in section for Nikhil to process External IDs
    */
    if (Trigger.isUpdate){
        //Set<Id> oppEXTList = new Set<Id>();
        //Map<Id, String> oppExtIDMap = new Map<Id, String>();
        
        boolean getConRT = false;
        for (Opportunity o : Trigger.new){
            Opportunity newOpp = o;
            Opportunity oldOpp = Trigger.oldMap.get(o.Id);
            if (oldOpp.CATS_External_ID__c != newOpp.CATS_External_ID__c ){
                
                getConRT = true;
            }
        }
        
        if (getConRT){
            String contractRTID = [SELECT ID FROM RecordType Where Name = 'Contract' and SOBJECTTYPE = 'Opportunity'][0].Id;
            for (Opportunity o : Trigger.new){
                Opportunity newOpp = o;
                Opportunity oldOpp = Trigger.oldMap.get(o.Id);
                if (oldOpp.CATS_External_ID__c != newOpp.CATS_External_ID__c ){
                    
                    
                    if (newOpp.Type=='New'){
                        newOpp.StageName='Closed Won';
                    }
                    if (newOpp.Type=='Renewal'){
                        newOpp.StageName='Closed Won Renewal';
                    }
                    else if (newOpp.Type=='Addendum'){
                        newOpp.StageName='Closed Won Addendum';
                        newOpp.Probability=0;
                    }
                    newOpp.RecordTypeId = contractRTID;
                    //newOpp.To_Be_Updated__c = true;
                    //oppExtIDMap.put(o.Id, o.CATS_External_ID__c);
                    
                    //oppEXTList.add(o.Id);
                    getConRT = true;
                }
            }
        }
        /*
        if (oppEXTList.size() > 0){
            List<Program__c> programsEXT = [Select id,External_ID__c,Delivery_Type__c, Opportunity__c from Program__c p where p.Opportunity__c IN :oppEXTList];
            for(Program__c program:programsEXT){
                program.External_ID__c = oppExtIDMap.get(program.Opportunity__c)+program.Delivery_Type__c ;
            }
            update programsEXT;
            
            List<Program_Forecast__c> pfsEXT = [SELECT ID FROM PROGRAM_FORECAST__C WHERE Program__r.Opportunity__c IN : oppEXTList];
            update pfsEXT;
        }*/
    }
    
    /*
    **Added by Warren to accomodate Renewals
    */
    
    Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
    //Double percent = 1 + settings1.Percent_Goal__c/100;
    Double percent = 0;
    Integer windowDays = settings1.Renewal_Window_Size__c.intValue();
    if (Trigger.isUpdate){
        for (Opportunity o : Trigger.new){
            system.debug('***' + o.RecordTypeId);
            system.debug('***' + o.Amount);
            system.debug('***' + Trigger.oldMap.get(o.Id).Amount);
            system.debug('***' + o.Last_Renewal_Amount_Change__c);
            if (o.Related_Contract__c != null && o.Amount != Trigger.oldMap.get(o.Id).Amount){
                if (o.Last_Renewal_Amount_Change__c == null){
                    o.Renewal_Amount_1__c = Trigger.oldMap.get(o.Id).Amount;
                    o.Renewal_Amount_2__c = Trigger.oldMap.get(o.Id).Renewal_Amount_1__c;
                    o.Renewal_Amount_3__c = Trigger.oldMap.get(o.Id).Renewal_Amount_2__c;
                    o.Last_Renewal_Amount_Change__c = Date.today();
                } else if (math.abs(Date.today().daysBetween(o.Last_Renewal_Amount_Change__c)) >= windowDays){
                    o.Renewal_Amount_1__c = Trigger.oldMap.get(o.Id).Amount;
                    o.Renewal_Amount_2__c = Trigger.oldMap.get(o.Id).Renewal_Amount_1__c;
                    o.Renewal_Amount_3__c = Trigger.oldMap.get(o.Id).Renewal_Amount_2__c;
                    o.Last_Renewal_Amount_Change__c = Date.today();
                    o.Historical_Renewal_Date_1__c = Trigger.oldMap.get(o.Id).Last_Renewal_Amount_Change__c;
                    o.Historical_Renewal_Date_2__c = Trigger.oldMap.get(o.Id).Historical_Renewal_Date_1__c;
                    o.Historical_Renewal_Date_3__c = Trigger.oldMap.get(o.Id).Historical_Renewal_Date_2__c; 
                }   
            }
        }
    } else if (Trigger.isInsert){
        for (Opportunity o : Trigger.new){
            if (o.Amount != null) o.Last_Renewal_Amount_Change__c = Date.today();
        }
    }
    
    /*
    Map<Id, Decimal> accGoalMap = new Map<Id, Decimal>();
    Map<Id, String> accRTMap = new Map<Id, String>();
    List<Account> accList1 = [SELECT ID, RENEWAL_GOAL_OVERRIDE__C, RecordType.Name FROM ACCOUNT WHERE Id IN: accList];
    for (Account a : accList1){
        if (a.Renewal_Goal_Override__c != null) accGoalMap.put(a.Id, 1 + a.RENEWAL_GOAL_OVERRIDE__C/100);
        accRTMap.put(a.Id, a.RecordType.Name);
    }*/
    
     //checks to see if renewal goal field should be overwritten or not
    for (Opportunity o : Trigger.new){
        if (Trigger.isInsert){
            if (o.Renewal_Goal_Amount__c == 0 || o.Renewal_Goal_Amount__c == null){
                o.Renewal_Goal_Amount__c = o.Renewal_Goal__c;
            }
        } else {
        //if (o.Previous_Year_Amount__c != null && o.Renewal_Goal_Amount__c == null){
            if (o.Renewal_Goal_Amount__c == Trigger.oldMap.get(o.Id).Renewal_Goal__c
                || o.Renewal_Goal_Amount__c == 0 || o.Renewal_Goal_Amount__c == null){
                    o.Renewal_Goal_Amount__c = o.Renewal_Goal__c;
                }
            //o.Account_Type__c = accRTMap.get(o.AccountId);
        //}
        }
    }
    
    for (Opportunity o : Trigger.new){
        if (Trigger.isInsert){
            if (o.Prior_Year_Amount__c == 0 || o.Prior_Year_Amount__c == null){
                o.Prior_Year_Amount__c = o.Previous_Year_Amount__c;
            }
        } else {
        //if (o.Previous_Year_Amount__c != null && o.Renewal_Goal_Amount__c == null){
            if (o.Prior_Year_Amount__c == Trigger.oldMap.get(o.Id).Previous_Year_Amount__c
                || o.Prior_Year_Amount__c == 0 || o.Prior_Year_Amount__c == null){
                    o.Prior_Year_Amount__c = o.Previous_Year_Amount__c;
                }
            //o.Account_Type__c = accRTMap.get(o.AccountId);
        //}
        }
    }
    
    /*
    **Added by JB to accomodate Multi-year renewal
    */
    
    for (Opportunity o : Trigger.new){
        Set<String> oppyear = new Set<String>();
        List<Program_Forecast__c> lstProgramForecast = opptyProgramForecastMapList.get(o.Id);
        if(lstProgramForecast != null ){
            for(Program_Forecast__c pf : lstProgramForecast ){
                String ad = pf.Ad_Period__r.Name;
                String year = ad.substring( ad.length() - 4, ad.length());  //takes substring to extract the year from the ad_period
                if(pf.Ad_Period__c != null && (pf.Forecast_Amount__c > 0 || pf.Actual_Amount__c > 0)) {
                    
                    //checks for C1 with possible split between years
                    if(ad.substring(0,3) == 'C1_'){
                        if(pf.Previous_Quarter_Amount__c > 0 || pf.Previous_Quarter_Actual__c > 0){
                            Integer i = Integer.valueOf(year);
                            i--;
                            year = String.valueOf(i);
                            oppyear.add(year);
system.debug('*_*_*_year PQA:' + year);
                        } 
                        if(pf.Next_Quarter_Amount__c > 0 || pf.Next_Quarter_Actual__c > 0){
                            
system.debug('*_*_*_year NQA:' + year);
                            oppyear.add(year);
                        }
                    } else {
system.debug('*_*_*_year Normal: ' + year);
                        oppyear.add(year);
                    }
                }
            }
        }
        if(oppyear.size() > 1) { 
             o.IsMultiyear__c = true;
        } else {
             o.IsMultiyear__c = false;
        }
    }
    
    /*coded added by Cloud62 for new Start and End cycle picklists.
	When a value is populated, populate the correct start and end date*/
    
    Boolean getAdPeriods = false;
    Map<String, Ad_Period__c> APMap = new Map<String, Ad_Period__c>();
    for (Opportunity o : Trigger.new){
	    if (Trigger.isInsert){
	    	If(o.Start_Cycle__c != null || o.End_Cycle__c != null){
	    		getAdPeriods = true;
	    	}
	    }
	   	else if (Trigger.isUpdate){
	   		if (o.Start_Cycle__c != Trigger.oldMap.get(o.Id).Start_Cycle__c || o.End_Cycle__c != Trigger.oldMap.get(o.Id).End_Cycle__c){
	   			getAdPeriods = true;	
	   		}
    	}
    }
    
    if (getAdPeriods){
		for (Ad_Period__c ap : [SELECT ID, NAME, START_DATE__C, END_DATE__C FROM AD_PERIOD__C]){
			APMap.put(ap.Name, ap);
		}
		
		for (Opportunity o : Trigger.new){
			String RTName = '';
		    if (rtMap.containsKey(o.RecordTypeId)){
		    	RTName = rtMap.get(o.RecordTypeId).Name;
		    }
		    if (RTName.contains('France') || RTName.contains('Italy') || RTName.contains('Germany')){
				if (Trigger.isInsert){
					if (o.Start_Cycle__c != null){
						if (APMap.containsKey(o.Start_Cycle__c)) o.Start_Date__c = APMap.get(o.Start_Cycle__c).Start_Date__c;
					}
					
					if (o.End_Cycle__c != null){
						if (APMap.containsKey(o.End_Cycle__c)) o.End_Date__c = APMap.get(o.End_Cycle__c).End_Date__c;
					}
				} else if (Trigger.isUpdate){
					if (o.Start_Cycle__c != Trigger.oldMap.get(o.Id).Start_Cycle__c){
						if (APMap.containsKey(o.Start_Cycle__c)){
							o.Start_Date__c = APMap.get(o.Start_Cycle__c).Start_Date__c;
						} else {
							o.Start_Date__c = null;
						}
					}
					
					if (o.End_Cycle__c != Trigger.oldMap.get(o.Id).End_Cycle__c){
						if (APMap.containsKey(o.End_Cycle__c)){
							o.End_Date__c = APMap.get(o.End_Cycle__c).End_Date__c;
						} else {
							o.End_Date__c = null;
						}
					}
				}
		    }
		}
	}
}