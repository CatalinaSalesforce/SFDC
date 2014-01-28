trigger ProgramForecastMonthly on Program_Forecast__c (After insert, After update, Before Delete) {
    
    ProgramForecastMonthly_TriggerMethods pfmMethods = new ProgramForecastMonthly_TriggerMethods();
    List<Program_Forecast_Monthly__c> pfmonthlylist = new List<Program_Forecast_Monthly__c>();
    //@Todo: Skip this trigger for Integration User.
    if(Trigger.isAfter){
    if(trigger.isInsert || trigger.isUpdate){
        
           pfmMethods.createProgramForecastMonthly(trigger.newMap.keySet());
    }
    }
    if(trigger.isBefore){
    if(trigger.isDelete){
        
        pfmMethods.deleteProgramForecastMonthly(trigger.OldMap.KeySet()); 
    
    }
    }

}