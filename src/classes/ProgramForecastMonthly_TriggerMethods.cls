public class ProgramForecastMonthly_TriggerMethods{
    public List<Program_Forecast_Monthly__c> pfmonthlylist; 
    public void createProgramForecastMonthly(Set<id> programForecasts){
        
     //  Integer  usAdperiodDays = (Integer)Ad_Period_days__c.getValues('US').Number_of_Days__c;
       pfmonthlylist  = new List<Program_Forecast_Monthly__c>();
       
    /*   String query = 'select id,Name,Account_Type__c'
                       + 'Actual_Amount__c,External_id__c,Ad_Period__r.isSplit__c,Ad_Period__r.External_ID__c,Ad_Period__r.Is_Split__c,'
                       +'Forecast_Amount__c,Program__c, Ad_Period__r.Month1__c,Ad_Period__r.Month1_Days__c,Ad_Period__r.Month2__c,Ad_Period__r.Month2_Days__c'
                       +'from Program_forecast__c where id in : programForecasts and CurrencyISOcode=\'USD\''
                       + 'where Account_Type__c=\'Manufacturing\'';
       */
       // Filter only US records.
      List<Program_Forecast__c> pf = [select id,Name,Active__c,Previous_Quarter_Amount__c,Next_Quarter_Amount__c,Actual_Amount__c,Account_Type__c,External_id__c,Program__r.External_id__c,Ad_Period__r.Days_In_Cycle__c,Ad_Period__r.Type__c,Ad_Period__r.Start_Date__c,Ad_Period__r.External_ID__c,Ad_Period__r.Is_Split__c,Forecast_Amount__c,Program__c, Ad_Period__r.Month1__c,Ad_Period__r.Month1_Days__c,Ad_Period__r.Month2__c,Ad_Period__r.Month2_Days__c from Program_forecast__c where id in : programForecasts and CurrencyISOcode='USD'  ];
        
      //  List<program_Forecast__c> pf = Database.query(query);
      //Todo: when a record is created for the first time and Adperiod is updated with different Adperiod then we will end with extra adperiod. Better way is to invoke delete if adPeriod is changed. 
        
        for(Program_Forecast__c f: pf){
            /* 
            System.debug('Ad Period Month1 ' + f.Ad_Period__r.Month1__c);
            System.debug('Cylce is  ' + f.Ad_Period__r.External_id__c.split('_')[0]);
            System.debug('forecast amt'+ f.Forecast_Amount__c);
            */
            if(f.Account_Type__c=='Manufacturing'){
              if(f.Ad_Period__r.Month1__c != null && f.Ad_Period__r.Month1_Days__c !=0){
                Program_Forecast_Monthly__c pfm = new Program_Forecast_Monthly__c();
                pfm.Program_Forecast__c = f.Id;
                pfm.Active__c = f.Active__c; 
                //@Todo: Create a OverRide checkbox. 
                if(f.Ad_Period__r.is_Split__c=='true'){
                   pfm.Forecast_Amount__c = f.Previous_Quarter_Amount__c;
                }else{
                   pfm.Forecast_Amount__c = (f.Forecast_Amount__c ) * ((f.Ad_Period__r.Month1_Days__c)/f.Ad_Period__r.Days_In_Cycle__c); 
                } 
                pfm.Ad_Period__c = f.Ad_Period__c;
                
                pfm.Cats_External_Id__c = f.External_ID__c!=null?f.External_ID__c+Utility.calendarMonth(f.Ad_Period__r.Month1__c.Month())+'_FY'+f.Ad_Period__r.Month1__c.Year():'';
                System.debug('Cats_External_Id__c = '+ pfm.Cats_External_id__c);
                pfm.Program__c = f.Program__c;
                pfm.External_id__c = f.name + Utility.calendarMonth(f.Ad_Period__r.Month1__c.Month())+'_FY'+f.Ad_Period__r.Month1__c.Year();
                System.debug('External id is '+ pfm.External_id__c);
                pfm.Forecast_Month__c = f.Ad_Period__r.Month1__c;
                pfm.is_sdpy__c = false; 
                pfmonthlylist.add(pfm);
              }
                if(f.Ad_Period__r.Month2__c != null && f.Ad_Period__r.Month2_Days__c != 0){
                 Program_Forecast_Monthly__c pfm2 = new Program_Forecast_Monthly__c();
                 pfm2.Program_Forecast__c = f.Id;
                 pfm2.Active__c = f.Active__c;
                 if(f.Ad_Period__r.is_Split__c=='true'){
                     pfm2.Forecast_Amount__c = f.Next_Quarter_Amount__c;
                 }else{
                     pfm2.Forecast_Amount__c = (f.Forecast_Amount__c )* ((f.Ad_Period__r.Month2_Days__c)/f.Ad_Period__r.Days_In_Cycle__c); 
                 }
                 pfm2.Program__c = f.Program__c;
                 pfm2.Ad_Period__c = f.Ad_Period__c;
                 pfm2.Cats_External_id__c = f.External_ID__c!=null?f.External_ID__c+Utility.calendarMonth(f.Ad_Period__r.Month2__c.Month())+'_FY'+(f.Ad_Period__r.Month2__c).Year():'';
                 System.debug('Cats_External_Id__c = '+ pfm2.Cats_External_id__c);
                 pfm2.Forecast_Month__c = f.Ad_Period__r.Month2__c; 
                 pfm2.External_id__c = f.name+ Utility.calendarMonth((f.Ad_Period__r.Month2__c).Month())+'_FY'+(f.Ad_Period__r.Month2__c).Year();
                 pfm2.is_sdpy__c = false; 
                 System.debug('External id is '+ pfm2.External_id__c);
         
                 pfmonthlylist.add(pfm2);
                }
            }
            if(f.Account_Type__c=='Retail' && f.Ad_Period__r.Type__c =='Retail' ){
             
             
               Program_Forecast_Monthly__c Retail_pfm = new Program_Forecast_Monthly__c();
               Retail_pfm.Program_Forecast__c = f.Id; 
               Retail_pfm.Active__c = f.Active__c;
               Retail_pfm.External_id__c = f.name+f.Ad_Period__r.External_id__c;
               System.debug('External id is '+ Retail_pfm.External_id__c);
               Retail_pfm.Cats_External_id__c = f.External_ID__c!=null?f.External_Id__c:'';
               System.debug('Cats_External_Id__c = '+ Retail_pfm.Cats_External_id__c);
               Retail_pfm.Ad_Period__c = f.Ad_Period__c; 
               Retail_pfm.Program__c = f.Program__c;
               Retail_pfm.Forecast_Month__c = f.Ad_Period__r.START_DATE__C;
               Retail_pfm.Forecast_Amount__c = f.Forecast_Amount__c ;
               Retail_pfm.is_sdpy__c = false; 
               pfmonthlylist.add(Retail_pfm);
             
            }
            
        }
          upsert  pfmonthlylist External_id__c; 
    
    }
    
    
    
    
    public void deleteProgramForecastMonthly(set<id> programForecasts){
        list<String> pfNames = new List<String>();
        List<Program_Forecast__c> pf = [select id,Name,External_id__c,Ad_Period__r.External_ID__c,Ad_Period__r.Is_Split__c,Forecast_Amount__c,Program__c, Ad_Period__r.Month1__c,Ad_Period__r.Month1_Days__c,Ad_Period__r.Month2__c,Ad_Period__r.Month2_Days__c from Program_forecast__c where id in : programForecasts ];
        
        
        for(Program_Forecast__c f: pf){
          pfNames.add(f.Name+f.Ad_Period__r.Month1__c.Month()+f.Ad_Period__r.Month1__c.Year());
            if(f.Ad_Period__r.Month2__c!=null){
            
            pfNames.add(f.Name+(f.Ad_Period__r.Month2__c).Month()+(f.Ad_Period__r.Month2__c).Year());
            }
        }
        
        List<Program_Forecast_Monthly__c> pfm = [select id from Program_Forecast_Monthly__c where External_id__c in:pfNames];
        
        delete pfm; 
    
    }

}