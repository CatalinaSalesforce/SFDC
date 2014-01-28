trigger ProgramForecastMonthlyFindBG on Program_forecast_Monthly__c (before insert, before update) {

    Boolean executeTrigger = true;
    if (Best_Guess_Settings__c.getOrgDefaults() != null){
        Best_Guess_Settings__c BGSettings = Best_Guess_Settings__c.getOrgDefaults();
        if (UserInfo.getUserId() == BGSettings.IntegrationUserId__c && BGSettings.Batch_Use_Trigger__c == false){
            executeTrigger = false;
        }
    }
    
    if (executeTrigger){
        Set<Id> userSet = new Set<Id>();
        Set<Id> progSet = new Set<Id>();
        Set<Id> accountSet = new Set<Id>();
        Map<Id,Program__c> progMap = new Map<Id, Program__c>();
        Map<Id, Map<String, Sales_Rep_Best_Guess__c>> bgMap = new Map<Id, Map<String, Sales_Rep_Best_Guess__c>>();
        Map<Id, Map<Id, Map<String, Map<String, Account_Best_Guess_Summary__c>>>> abgsMap = new Map<Id, Map<Id, Map<String, Map<String, Account_Best_Guess_Summary__c>>>>();
        
        for (Program_Forecast_Monthly__c pf : Trigger.new){
            progSet.add(pf.Program__c);
            if (pf.Actual_Amount__c == null) pf.Actual_Amount__c = 0;
            if (pf.Forecast_Amount__c == null) pf.Forecast_Amount__c = 0;
        }
         
        for (Program__c p : [SELECT OPPORTUNITY__R.OWNERID, OPPORTUNITY__R.ACCOUNTID, Delivery_Type__c
            FROM PROGRAM__C
            WHERE ID IN: progSet]){
            userSet.add(p.Opportunity__r.OwnerId);
            progMap.put(p.Id, p);
            accountSet.add(p.Opportunity__r.AccountId);
        }
        
        for (Sales_Rep_Best_Guess__c srbg : [SELECT ID, NAME, OwnerId, Quarter__c
            FROM SALES_REP_BEST_GUESS__C
            WHERE OWNERID IN: userSet])
        {
            if (!bgMap.containsKey(srbg.OwnerId)){
                bgMap.put(srbg.OwnerId, new Map<String, Sales_Rep_Best_Guess__c>());
            }
            bgMap.get(srbg.OwnerId).put(srbg.Quarter__c, srbg);
        }
        
        for (Account_Best_Guess_Summary__c accBG : [SELECT ID, NAME, OWNERID, ACCOUNT__C, YEAR__C, DELIVERY_CHANNEL__C
            FROM ACCOUNT_BEST_GUESS_SUMMARY__C
            WHERE ACCOUNT__c IN: accountSet
            AND OWNERID IN: userSet])
        {
            if (!abgsMap.containsKey(accBG.OwnerId)){
                abgsMap.put(accBG.OwnerId, new Map<Id, Map<String, Map<String, Account_Best_Guess_Summary__c>>>());
            }
            if (!abgsMap.get(accBG.OwnerId).containsKey(accBG.Account__c)){
                abgsMap.get(accBG.OwnerId).put(accBG.Account__c, new Map<String, Map<String, Account_Best_Guess_Summary__c>>());
            }
            if (!abgsMap.get(accBG.OwnerId).get(accBG.Account__c).containsKey(accBG.Year__c)){
                abgsMap.get(accBG.OwnerId).get(accBG.Account__c).put(accBG.Year__c, new Map<String, Account_Best_Guess_Summary__c>());
            }
            if (!abgsMap.get(accBG.OwnerId).get(accBG.Account__c).get(accBG.Year__c).containsKey(accBG.Delivery_Channel__c)){
                abgsMap.get(accBG.OwnerId).get(accBG.Account__c).get(accBG.Year__c).put(accBG.Delivery_Channel__c, accBG);
            }
        }
        
        for (Program_Forecast_Monthly__c pf : Trigger.new){
            
            if (progMap.containsKey(pf.Program__c)){
                String tmpOwnerId = progMap.get(pf.Program__c).Opportunity__r.OwnerId;
                Program__c tmpProg = progMap.get(pf.Program__c);
                if (pf.Forecast_Month__c != null){
                    String tmpYear = String.valueOf(pf.Forecast_Month__c.year());
                    String tmpQuarter;
                    String tmpAcc = tmpProg.Opportunity__r.AccountId;
                    String tmpDelType = tmpProg.Delivery_Type__c;
                    //get SRBG
                    if (pf.Forecast_Month__c.month() == 1 || pf.Forecast_Month__c.month() == 2 || pf.Forecast_Month__c.month() == 3){
                        tmpQuarter = 'Q1' + tmpYear;
                    } else if (pf.Forecast_Month__c.month() == 4 || pf.Forecast_Month__c.month() == 5 || pf.Forecast_Month__c.month() == 6){
                        tmpQuarter = 'Q2' + tmpYear;
                    } else if (pf.Forecast_Month__c.month() == 7 || pf.Forecast_Month__c.month() == 8 || pf.Forecast_Month__c.month() == 9){
                        tmpQuarter = 'Q3' + tmpYear;
                    } else if (pf.Forecast_Month__c.month() == 10 || pf.Forecast_Month__c.month() == 11 || pf.Forecast_Month__c.month() == 12){
                        tmpQuarter = 'Q4' + tmpYear;
                    }
                    if (tmpQuarter != null){
                        if (bgMap.containsKey(tmpOwnerId)){
                            if (bgMap.get(tmpOwnerId).containsKey(tmpQuarter)){
                                pf.Sales_Rep_Best_Guess__c = bgMap.get(tmpOwnerId).get(tmpQuarter).Id;
                            }
                        }
                    }
                    
                    //get abgs
                    if (abgsMap.containsKey(tmpOwnerId)){
                        if (abgsMap.get(tmpOwnerId).containsKey(tmpAcc)){
                            if (abgsMap.get(tmpOwnerId).get(tmpAcc).containsKey(tmpYear)){
                                if (abgsMap.get(tmpOwnerId).get(tmpAcc).get(tmpYear).containsKey(tmpDelType)){
                                    pf.Account_Best_Guess_Summary__c = abgsMap.get(tmpOwnerId).get(tmpAcc).get(tmpYear).get(tmpDelType).Id;
                                }
                            }
                        }
                    }
                } else {
                    system.debug(LoggingLevel.ERROR,'***this Program Forecast Monthly record does not have a forecast month: ' + pf.Id);
                }   
            }
            
        }
        
        //begin SDPY/FY record associations
        List<Program_Forecast_Monthly__c> pfmInsert = new List<Program_Forecast_Monthly__c>();
        Map<Program_Forecast_Monthly__c, Program_Forecast_Monthly__c> pfmMap = new Map<Program_Forecast_Monthly__c, Program_Forecast_Monthly__c>();
        for (Program_Forecast_Monthly__c pfm : Trigger.new){
            if (/*pfm.SDPY_Record__c == null &&*/ pfm.Actual_Amount__c > 0 && pfm.Is_SDPY__c == false && pfm.Forecast_Month__c != null){
                Program_forecast_Monthly__c newPFM = new Program_forecast_Monthly__c();
                newPFM.Program_Forecast__c = pfm.Program_Forecast__c;
                newPFM.Active__c = false; 
                newPFM.PY_Booked__c = pfm.Actual_Amount__c;
                //pfm.Ad_Period__c = f.Ad_Period__c;
                if (pfm.Cats_External_Id__c == null || pfm.Cats_External_Id__c == ''){
                    newPFM.Cats_External_Id__c = pfm.External_Id__c + '_SDPY';
                } else {
                    newPFM.Cats_External_Id__c = pfm.Cats_External_Id__c + '_SDPY';
                }
                System.debug('SDPY Cats_External_Id__c = '+ newpfm.Cats_External_id__c);
                newPFM.Program__c = pfm.Program__c;
                newPFM.External_id__c = pfm.External_Id__c + '_SDPY';
                newPFM.Forecast_Month__c = pfm.Forecast_Month__c.addYears(1);
                newPFM.Is_SDPY__c = true;
                pfmInsert.add(newPFM);
                pfmMap.put(pfm, newPFM); 
            }
        }
        
        upsert pfmInsert Cats_External_Id__c;
        
        for (Program_Forecast_Monthly__c pfm : Trigger.new){
            if (pfmMap.containsKey(pfm))pfm.SDPY_Record__c = pfmMap.get(pfm).Id; 
        }
    
    }
}