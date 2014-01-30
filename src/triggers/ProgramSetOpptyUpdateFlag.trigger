/*
@Name            : ProgramForecastSetOpptyUpdateFlag
@Author          : customersuccess@cloud62.com
@Date            : May 8, 2012
@Description     : Trigger to add External ID to Program Forecast
2013-01-15 - edit auto sync function to recalculate after every update based on prog amt - actual amt
2013-07-03 - add null check to avoid NPE line 136
*/
trigger ProgramSetOpptyUpdateFlag on Program__c (after insert, after update, after delete) {
    if(ProgramSetOpptyUpdateFlagTempCls.DONOTEXECUTE_FLAG){
       return;
   }
    ProgramSetOpptyUpdateFlagTempCls.DONOTEXECUTE_FLAG = true;
    final static String FORECAST_SETTING_NAME = 'Default';
    Map<Id, List<Program__c>> oppProgMap = new Map<Id, List<Program__c>>(); 
    Set<Id> franceRTs = new Set<Id>();
    For (RecordType r : [SELECT ID FROM RecordType Where Name LIKE '%France%' and SOBJECTTYPE = 'Program__c']){
        franceRTs.add(r.Id);
    }
    
    Set<Id> opptyList = new Set<Id>();
    if (Trigger.isDelete){
        for(Program__c a : Trigger.old){
            opptyList.add(a.Opportunity__c);
        }
        
    }else {
/*      
        for(Program__c a : Trigger.new){
                opptyList.add(a.Opportunity__c);
            }
*/
// Nikhil: Commented the above for loop and replaced with this instead.
        for(Integer i=0; i< Trigger.new.size();i++){
            Program__c newProgram = Trigger.new[i];
            if (Trigger.isUpdate){
                Program__c oldProgram = Trigger.old[i];
                if (newProgram.External_ID__c == oldProgram.External_ID__c){
                    opptyList.add(newProgram.Opportunity__c);               
                } else {
                    // This will exclude the setting of o.To_Be_Updated__c and will be handled from the 
                    //ProposalToContract trigger.
                }
            } else {
                opptyList.add(newProgram.Opportunity__c);
            }
            /*Warren July 7 2013 to keep CATS Programs in sync with Opportunity.CatalinaBusinessUnit*/
            if (!oppProgMap.containsKey(newProgram.Opportunity__c)){
                oppProgMap.put(newProgram.Opportunity__c, new List<Program__c>());
            }
            oppProgMap.get(newProgram.Opportunity__c).add(newProgram);
        }
    }
    
    List<Opportunity> toUpdate = [SELECT Id, Catalina_Business_Unit__c, To_Be_Updated__c From Opportunity Where Id IN: opptyList];
    for (Opportunity o : toUpdate){
        o.To_Be_Updated__c = true;
        /*Warren July 7 2013 to keep CATS Programs in sync with Opportunity.CatalinaBusinessUnit*/
        if (Trigger.isInsert){
            if (oppProgMap.containsKey(o.Id)){
                String cbu = o.Catalina_Business_Unit__c;
                if (cbu == null) cbu = '';
                for (Program__c p : oppProgMap.get(o.Id)){
                    String delType;
                    if (p.Delivery_Type__c == null){
                        delType = '';
                    } else {
                        delType = p.Delivery_Type__c;
                    }
                    if (!cbu.contains(delType)){
                        if (cbu == null || cbu ==  ''){
                            cbu = delType;
                        } else {
                            cbu += ';' + delType;
                        }
                    }
                }
                o.Catalina_Business_Unit__c = cbu;
            }
        }
    }
    
    update toUpdate;
    
    /*
    * Section added by Warren to accomodate France changing Program Amounts
    */
    if (Trigger.isUpdate){
        Set<Id> newProgAmtOpps = new Set<Id>();
        Map<Id, Decimal> progAmtMap = new Map<Id, Decimal>();
        for (Program__c p : Trigger.new){
            if (p.Program_Amount__c != Trigger.oldMap.get(p.Id).Program_Amount__c && franceRTs.contains(p.RecordTypeId)){
                newProgAmtOpps.add(p.Opportunity__c);
                progAmtMap.put(p.Id, p.Program_Amount__c);
            }
        }
        
        List<Opportunity> newProgOpps = [SELECT ID, AMOUNT, (SELECT ID, PROGRAM_AMOUNT__C FROM PROGRAMS__R) 
            FROM OPPORTUNITY
            WHERE ID IN: newProgAmtOpps];
        List<Program__c> updateProgs = new List<Program__c>();
        
        for (Opportunity o : newProgOpps){
            Decimal oppAmt = (o.Amount == null ? 0 : o.Amount);
            Decimal takenProgAmts = 0;
            Integer progCount = 0;
            for (Program__c p : o.Programs__r){
                if (progAmtMap.containsKey(p.Id)){
                     takenProgAmts += progAmtMap.get(p.Id);
                } else {
                    progCount++;
                }
            }
            oppAmt = oppAmt - takenProgAmts;
            for (Program__c p : o.Programs__r){
                if (!progAmtMap.containsKey(p.Id)){
                    p.Program_Amount__c = oppAmt/progCount;
                    updateProgs.add(p);
                }
            }
        }
        
        update updateProgs;
    }
    
    /*
    * End Section added by Warren to accomodate France changing Program Amounts
    */
    
    /*
    * Section added by Warren to accomodate Start Date on Opportunity
    * Removed by Warren on July 3rd because this logic is no longer relevant.
        Start Dates should NEVER be modified when a program changes its start and end cycle
    *//*
    Set<Id> startDateOpps = new Set<Id>();
    
    if (Trigger.isInsert || Trigger.isUpdate){
        for (Program__c p : Trigger.new){
            if (Trigger.isInsert){
                if (p.Start_Cycle__c != null){
                    startDateOpps.add(p.Opportunity__c);
                }
            } else if (Trigger.isUpdate){
                if (p.Start_Cycle__c != Trigger.oldMap.get(p.Id).Start_Cycle__c){
                    startDateOpps.add(p.Opportunity__c);    
                }
            }
        }
    }
    
    if (startDateOpps.size() > 0){
    
        Map<Id, Ad_Period__c> apMap = new Map<Id, Ad_Period__c>();
        List<Ad_Period__c> apList = [SELECT ID, START_DATE__C FROM AD_PERIOD__C];
        for (Ad_Period__c ap : apList){
            apMap.put(ap.Id, ap);
        }
        
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
        List<Opportunity> dateOpps = [SELECT ID, START_DATE__C FROM OPPORTUNITY WHERE ID IN: startDateOpps];
        for (Opportunity o : dateOpps){
            oppMap.put(o.Id, o);
        }
        
        for (Program__c p : Trigger.new){
            if (oppMap.containsKey(p.Opportunity__c)){
                Opportunity o = oppMap.get(p.Opportunity__c);
                if (apMap.containsKey(p.Start_Cycle__c)){
                    if (o.Start_Date__c == null){
                        o.Start_Date__c = apMap.get(p.Start_Cycle__c).Start_Date__c;
                    } else if (o.Start_Date__c > apMap.get(p.Start_Cycle__c).Start_Date__c){
                        o.Start_Date__c = apMap.get(p.Start_Cycle__c).Start_Date__c;
                    }
                }
            }
        }
        
        update dateOpps;
    
    }*/
    
    //2012-12-21 if auto sync is set, recalibrate all PFs
    if (Trigger.isUpdate){
        Integer activeDelay = 2;
        //assign the custom setting provided value if it exists
        Catalina_Forecast_Settings__c setting = Catalina_Forecast_Settings__c.getInstance(FORECAST_SETTING_NAME);
        if(!(setting == null)){
            if(!(setting.Forecast_to_Actual_Transition__c == null)){
                activeDelay = (Integer)setting.Forecast_to_Actual_Transition__c;
            }
        }
        Set<Id> progSyncSet = new Set<Id>();
        List<Program_Forecast__c> upsertPF = new List<Program_Forecast__c>();
        for (Program__c p : Trigger.new){
            if (p.Auto_Sync_With_CATS__c == true
                /*&& Trigger.oldMap.get(p.Id).Auto_Sync_With_CATS__c != p.Auto_Sync_With_CATS__c*/)
            {
                progSyncSet.add(p.Id);
            }
        }
        
        Map<Id, Map<Id, Program_Forecast__c>> progPFMap = new Map<Id, Map<Id, Program_Forecast__c>>(); 
        List<Program_Forecast__c> pfList = [SELECT ID, ACTUAL_AMOUNT__C, FORECAST_AMOUNT__C,
            NEXT_QUARTER_AMOUNT__C, PREVIOUS_QUARTER_AMOUNT__C, AD_PERIOD__C, PROGRAM__C
            FROM PROGRAM_FORECAST__C
            WHERE PROGRAM__C IN :progSyncSet];
        for (Program_Forecast__c pf : pfList){
            if (!progPFMap.containsKey(pf.Program__c)){
                progPFMap.put(pf.Program__c, new Map<Id, Program_Forecast__c>());
            }
            if (!progPFMap.get(pf.Program__c).containsKey(pf.Ad_Period__c)){
                progPFMap.get(pf.Program__c).put(pf.Ad_Period__c, pf);
            }
        }
        
        List<Ad_Period__c> adPeriods = [SELECT ID, NAME, START_DATE__C, END_DATE__C, TYPE__C, Is_Split__c, Days_In_Cycle__c
            FROM AD_PERIOD__C
            WHERE TYPE__C = 'RETAIL' OR TYPE__C = 'MANUFACTURING'];
        Map<Id, Ad_Period__c> adPeriodMap = new Map<Id, Ad_Period__c>(adPeriods);
        
        for (Program__c p : Trigger.new){
            if (p.Start_Cycle__c != null && p.End_Cycle__c != null && p.Auto_Sync_With_Cats__c == true){
                Date startDate = adPeriodMap.get(p.Start_Cycle__c).Start_Date__c;
                Date endDate = adPeriodMap.get(p.End_Cycle__c).End_Date__c;
                Integer activeCycles = 0;
                for (Ad_Period__c ap : adPeriods){
                    system.debug(LoggingLevel.ERROR, '***ap: ' + ap.Name + ', startDate: ' + startDate);
                    system.debug(LoggingLevel.ERROR, '***endDate: ' + endDate);
                    system.debug(LoggingLevel.ERROR, '***p.acctType: ' + p.Account_Type__c + ', ap.Type: ' + ap.Type__c );
                    if (ap.Start_Date__c >= startDate
                    && ap.End_Date__c <= endDate
                    && ap.End_Date__c + activeDelay > Date.today()
                    && ap.Type__c == p.Account_Type__c)
                    {
                        activeCycles++;
                    }
                }
                if (p.Auto_Sync_With_CATS__c == true){
                    
                    Decimal newForecast = 0.0;
                    if (activeCycles != 0){
                        //added by Robert to remedy null pointer Jan 30 2013
                        if(p.Program_Amount__c == null){
                            newForecast = p.Actual_Amount__c / activeCycles;
                        }
                        else{
                            newForecast = (p.Program_Amount__c - p.Actual_Amount__c) / activeCycles;
                        }
                        
                    }
                    for (Ad_Period__c ap : adPeriods){
                    if (ap.Start_Date__c >= startDate
                    && ap.End_Date__c <= endDate
                    && ap.End_Date__c + activeDelay > Date.today()
                    && ap.Type__c == p.Account_Type__c)
                        {
                            if (!progPFMap.containsKey(p.Id)){
                                progPFMap.put(p.Id, new Map<Id, Program_Forecast__c>());    
                            }
                            
                            if (progPFMap.get(p.Id).containsKey(ap.Id)){
                                Boolean updated = false;
                                Program_Forecast__c tempPF = progPFMap.get(p.Id).get(ap.Id);
                                if (tempPF.Forecast_Amount__c != newForecast){
                                    updated = true;
                                    tempPF.Forecast_Amount__c = newForecast;
                                }
                                if (ap.Is_Split__c == 'true'){
                                    Double nextRatio = Double.valueOf((Double)ap.End_Date__c.day()/28.0);
                                    Double prevRatio = 1 - nextRatio;
                                    if (tempPF.Next_Quarter_Amount__c != tempPF.Forecast_Amount__c * nextRatio
                                        || tempPF.Previous_Quarter_Amount__c != tempPF.Forecast_Amount__c * prevRatio){
                                        updated = true;
                                        tempPF.Next_Quarter_Amount__c = tempPF.Forecast_Amount__c * nextRatio;
                                        tempPF.Previous_Quarter_Amount__c = tempPF.Forecast_Amount__c * prevRatio;
                                    }
                                }
                                if (updated) upsertPF.add(tempPF);
                            } else {
                                upsertPF.add(ProgramDistributeAmtButton.createProgramForecast(p, ap, activeCycles));
                            }
                        }
                    }
                }
            }
        }
        if (upsertPF.size() > 0) upsert upsertPF;
    }

}