/*
@Name            : InsertProgramForecastExternalId
@Author          : customersuccess@cloud62.com
@Date            : May 8, 2012
@Description     : Trigger to add External ID to Program Forecast
test class in TestCreateProductTypeSplitTrigger.testPFCreation()
2012-12-21 - add auto sync function with CATS
2013-01-15 - removed code for auto sync function
2013-05-31 - add code to populate Is_Last_Year__c
2013-07-03 - added check to only update external ids when none has been provided
*/

trigger InsertProgramForecastExternalId on Program_Forecast__c (before insert, before update) {
    
    Set<Id> progList = new Set<Id>();
    Set<Id> adPeriodList = new Set<Id>();
    Map<Id, Map<Id, Program_Forecast__c>> progCyclesMap = new Map<Id, Map<Id, Program_Forecast__c>>(); 
    
    for (Program_Forecast__c a : Trigger.new){
        progList.add(a.Program__c);
        adPeriodList.add(a.Ad_Period__c);
    }
    
    Map<Id, Ad_Period__c> adPeriodsMap = new Map<Id, Ad_Period__c>([Select Id, Start_Date__c, End_Date__c, Name From Ad_Period__c Where Id IN : adPeriodList]);
    //List<Program__c> progs = [SELECT ID, EXTERNAL_ID__C FROM PROGRAM__C WHERE ID IN :progList];
    Map<Id, Program__c> progMap = new Map<Id, Program__c>([SELECT ID, EXTERNAL_ID__C, AUTO_SYNC_WITH_CATS__C
            FROM PROGRAM__C WHERE ID IN :progList]);
    
    for (Program_Forecast__c a : Trigger.new){
        //system.debug('***p.external_id__c: ' + a.Program__r.External_Id__c);
        if (progMap.containsKey(a.Program__c)){
            if (progMap.get(a.Program__c).External_Id__c != null){
                //Warren Cloud 62 July 3 2013 do not update if external ID already provided
                if (a.External_ID__c == null){
                    a.External_ID__c = progMap.get(a.Program__c).External_Id__c + adPeriodsMap.get(a.Ad_Period__c).Name; 
                }
            }
        }
        
        //May 31 2013, code for CME for to mark Is_Last_Year__c box
		if (a.Actual_Amount__c != null){
			if (a.Ad_Period__c != null){
				if (AdPeriodsMap.containsKey(a.Ad_Period__c)){
					if (adPeriodsMap.get(a.Ad_Period__c).Start_Date__c != null){
						if (AdPeriodsMap.get(a.Ad_Period__c).Start_Date__c.year() == Date.today().addYears(-1).year()
							&& a.Actual_Amount__c > 0){
							a.Is_Last_Year__c = true;
						}
					}
				}
			}
		}
    }

}