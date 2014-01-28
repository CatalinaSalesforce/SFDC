public with sharing class saveGridActualController {
/*
@Name           :       saveGridDataController
@Author         :
@Date           :   
@Description    :       Controller for SaveGridData Page.
                        Parsing XML and saving the data get from MyForecastPage (JQGrid).
                        This is not used any more. The functionality has been added to SaveGridDataController. 
*/

    public String xmls{set;get;}
    public String jsonToParse{set;get;}
    public set<String> progIds;
    public List<ProgramModel> proModelList;
    public List<Ad_Period__c> adPeriodList;
    public integer month;
    public integer year;
    public String rType;
    public date currentDate;
    public Map<Id,ProgramModel> programModelMap;
    public List<Program__c> programs;
    public date adPeriodStartDate;
    //Constructor Defination
    public saveGridActualController(String jsonString, String currDate, String recType, date startAdPeriod){
        currentDate = System.today();
        System.debug('##### JSON arg = '+jsonString);
        jsonToParse = jsonString;
        String cDate = currDate;
        rType = recType;
        System.debug('##### Current date = '+cDate);
        System.debug('##### record type= '+rType);
        currentDate = Date.valueOf(cDate);
        adPeriodStartDate = startAdPeriod;
        System.debug('##### save : Starting ad period start date= '+adPeriodStartDate);
        getAdPeriods();
        parseMe();
        saveData();
    }
    //Method for Getting AdPeiods of all Program forecast from Start date to next 6 months
    public void getAdPeriods(){
        /*
        adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c, Is_Split__c, Days_In_Cycle__c FROM Ad_Period__c 
                            WHERE (Start_Date__c >=: adPeriodStartDate OR 
                            (End_Date__c >=: system.today().addMonths(-1) AND Start_Date__c <: system.today().addMonths(-1))) AND 
                            Type__c =: rType 
                            AND Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7')
                            Order by Start_Date__c LIMIT 7];
        */
        adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c, Is_Split__c, Days_In_Cycle__c FROM Ad_Period__c 
                            WHERE Start_Date__c >=: adPeriodStartDate AND 
                            Type__c =: rType AND  
                            Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7')
                            Order by Start_Date__c ASC LIMIT 12];
        system.debug('#### adperiodList size= '+adPeriodList);
    }
    
    public void parseMe(){
        progIds = new set<String>();
        proModelList = new List<ProgramModel>();
        JSONObject jobj = new JSONObject(jsonToParse);
        list<JSONObject.value> vs = jobj.getValue('programs').values;
        for(JSONObject.value vv : vs){
            ProgramModel proModel = new ProgramModel();
            progIds.add(vv.obj.getString('ProgId'));
            proModel.programId = vv.obj.getString('ProgId');
            for(Ad_Period__c adPeriod : adPeriodList){
                proModel.forecastMonths.add(new ForecastModel(adPeriod));
            }
            if(proModel.forecastMonths.size() >= 7){
                proModel.forecastMonths[0].forecastAmount = vv.obj.getString('forecast1');
                proModel.forecastMonths[1].forecastAmount = vv.obj.getString('forecast2');
                proModel.forecastMonths[2].forecastAmount = vv.obj.getString('forecast3');
                proModel.forecastMonths[3].forecastAmount = vv.obj.getString('forecast4');
                proModel.forecastMonths[4].forecastAmount = vv.obj.getString('forecast5');
                proModel.forecastMonths[5].forecastAmount = vv.obj.getString('forecast6');
                proModel.forecastMonths[6].forecastAmount = vv.obj.getString('forecast7');
                if (proModel.forecastMonths.size() >= 8)proModel.forecastMonths[7].forecastAmount = vv.obj.getString('forecast8');
                if (proModel.forecastMonths.size() >= 9)proModel.forecastMonths[8].forecastAmount = vv.obj.getString('forecast9');
                if (proModel.forecastMonths.size() >= 10)proModel.forecastMonths[9].forecastAmount = vv.obj.getString('forecast10');
                if (proModel.forecastMonths.size() >= 11)proModel.forecastMonths[10].forecastAmount = vv.obj.getString('forecast11');
                if (proModel.forecastMonths.size() >= 12)proModel.forecastMonths[11].forecastAmount = vv.obj.getString('forecast12');
            }
            
            System.debug('@@@ Program Id ===> ' + vv.obj.getString('ProgId'));
            System.debug('@@@ Forecast 1 ===> ' + vv.obj.getString('forecast1'));
            System.debug('@@@ Forecast 2 ===> ' + vv.obj.getString('forecast2'));
            System.debug('@@@ Forecast 3 ===> ' + vv.obj.getString('forecast3'));
            System.debug('@@@ Forecast 4 ===> ' + vv.obj.getString('forecast4'));
            System.debug('@@@ Forecast 5 ===> ' + vv.obj.getString('forecast5'));
            System.debug('@@@ Forecast 6 ===> ' + vv.obj.getString('forecast6'));
            System.debug('@@@ Forecast 7 ===> ' + vv.obj.getString('forecast7'));
            
            for(ForecastModel fm : proModel.forecastMonths){
                proModel.monthMap.put(fm.adPeriod,fm.forecastAmount);
            }
            proModelList.add(proModel);
        }
        /*for debug
        for(ProgramModel pm : proModelList){
            system.debug('%%%% pro id= '+pm.programId);
            for(ForecastModel fm : pm.forecastMonths){
                system.debug('%%%% month= '+fm.adPeriod);
                system.debug('%%%% amount= '+fm.forecastAmount);
            }
        }
        */
    }
    
    //Method for saving data get from JQGrid
    public void saveData(){
        system.debug('@@@ saveData called');
        List<Program_Forecast__c> programForecastList = new List<Program_Forecast__c>();
        
        Map<id,Program__c> programMap ;
        if(rType == 'retail'){
            programMap = new Map<id,Program__c>([SELECT id, Name, 
                                                    (SELECT Forecast_Amount__c, Previous_Quarter_Amount__c, Next_Quarter_Amount__c, Ad_Period__r.Id, Ad_Period__r.Start_Date__c, Ad_Period__r.End_Date__c From Program_Forecasts__r
                                                     WHERE Ad_Period__r.Start_Date__c >=: adPeriodStartDate //OR
                                                    //(Ad_Period__r.End_Date__c >: System.today().addMonths(-1) AND Ad_Period__r.Start_Date__c <: System.today().addMonths(-1)) 
                                                    order by Ad_Period__r.Start_Date__c LIMIT 7)
                                                    from Program__c WHERE id in : progIds]);
        }else if(rType == 'Manufacturing'){
            programMap = new Map<id,Program__c>([SELECT id, Name, 
                                                    (SELECT Forecast_Amount__c, Previous_Quarter_Amount__c, Next_Quarter_Amount__c, Ad_Period__r.Id, Ad_Period__r.Start_Date__c, Ad_Period__r.End_Date__c From Program_Forecasts__r
                                                     WHERE Ad_Period__r.Start_Date__c >=: adPeriodStartDate //OR
                                                    //(Ad_Period__r.End_Date__c >: System.today().addDays(-28) AND Ad_Period__r.Start_Date__c <: System.today().addDays(-28)) 
                                                    order by Ad_Period__r.Start_Date__c LIMIT 7)
                                                    from Program__c WHERE id in : progIds]);
        }else /* change added by c62 if(rType == 'Manufacturing France')*/{
            programMap = new Map<id,Program__c>([SELECT id, Name, 
                                                    (SELECT Forecast_Amount__c, Previous_Quarter_Amount__c, Next_Quarter_Amount__c, Ad_Period__r.Id, Ad_Period__r.Start_Date__c, Ad_Period__r.End_Date__c From Program_Forecasts__r
                                                     WHERE Ad_Period__r.Start_Date__c >=: adPeriodStartDate //OR
                                                    //(Ad_Period__r.End_Date__c >: System.today().addDays(-28) AND Ad_Period__r.Start_Date__c <: System.today().addDays(-28)) 
                                                    order by Ad_Period__r.Start_Date__c ASC LIMIT 12)
                                                    from Program__c WHERE id in : progIds]);
        }
        
        system.debug('@@@ Program map size='+programMap.size());
        
        for(ProgramModel pModel : proModelList){
            Program__c program = programMap.get(pModel.programId);
            if(program != null){
                for(Ad_Period__c adPeriod : pModel.monthMap.keySet()){
                    boolean found = false;
                    for(Program_Forecast__c proFor : program.Program_Forecasts__r){
                        if(adPeriod.Id == proFor.Ad_Period__r.Id){
                            String valueStr = pModel.monthMap.get(adPeriod);
                            decimal value = 0;
                            if(valueStr != ''){
                                value = decimal.valueOf(valueStr);
                            }
                            system.debug('@@@ Amount= '+value+' updated for ad period '+adPeriod.Name);
                            proFor.Actual_Amount__c = value;
                            proFor.Active__c = false;
                            if(adPeriod.Is_Split__c == 'true'){
                                integer nxtQtrDays = adPeriod.End_Date__c.day();
                                decimal preQtrDays = adPeriod.Days_In_Cycle__c - nxtQtrDays;
                                proFor.Previous_Quarter_Amount__c = preQtrDays / adPeriod.Days_In_Cycle__c * value;
                                proFor.Next_Quarter_Amount__c = value - proFor.Previous_Quarter_Amount__c;
                                System.debug('**** Prev qtr days = '+preQtrDays);
                                System.debug('**** Next qtr days = '+nxtQtrDays);
                                System.debug('**** Previous_Quarter_Amount__c = '+proFor.Previous_Quarter_Amount__c);
                                System.debug('**** Next_Quarter_Amount__c = '+proFor.Next_Quarter_Amount__c);
                            }
                            if(rType == 'Manufacturing France' || rType == 'Manufacturing Italy' || rType == 'Manufacturing Germany'){
                                proFor.CurrencyIsoCode = 'EUR';
                            }
                            programForecastList.add(proFor);
                            found = true;
                            break;
                        }
                    }
                    if(!found){
                        String valueStr = pModel.monthMap.get(adPeriod);
                        decimal value = 0;
                        if(valueStr != ''){
                            value = decimal.valueOf(valueStr);
                        }
                        if(value != 0){
                            Program_Forecast__c newPF = new Program_Forecast__c();
                            if(rType == 'Manufacturing France' || rType == 'Manufacturing Italy' || rType == 'Manufacturing Germany'){
                                newPF.CurrencyIsoCode = 'EUR';
                            }
                            newPF.Program__c = pModel.programId;
                            newPf.Actual_Amount__c = value;
                            newpf.Active__c = false;
                            newPf.Ad_Period__c = adPeriod.Id;
                            if(adPeriod.Is_Split__c == 'true'){
                                integer nxtQtrDays = adPeriod.End_Date__c.day();
                                decimal preQtrDays = adPeriod.Days_In_Cycle__c - nxtQtrDays;
                                newPf.Previous_Quarter_Amount__c = preQtrDays / adPeriod.Days_In_Cycle__c * value;
                                newPf.Next_Quarter_Amount__c = value - newPf.Previous_Quarter_Amount__c;
                                System.debug('**** Prev qtr days = '+preQtrDays);
                                System.debug('**** Next qtr days = '+nxtQtrDays);
                                System.debug('**** Previous_Quarter_Amount__c = '+newPf.Previous_Quarter_Amount__c);
                                System.debug('**** Next_Quarter_Amount__c = '+newPf.Next_Quarter_Amount__c);
                            }
                            System.debug('@@@ New program forecast created for '+adPeriod.Name);
                            programForecastList.add(newPf);
                        }
                    }
                }
            }
        }
        System.debug('@@@ update records='+programForecastList.size());
        if(programForecastList.size() > 0){
            System.debug('@@@ Records updated='+programForecastList);
            upsert programForecastList;
        }
        
    }
    public class ProgramModel{
        public String programId{get;set;}
        public Map<Ad_Period__c,string> monthMap;
        public List<ForecastModel> forecastMonths;
        public ProgramModel(){
            monthMap = new Map<Ad_Period__c,string>();
            forecastMonths = new List<ForecastModel>();
        }
    }
    public class ForecastModel{
        //public String adPeriod;
        public Ad_Period__c adPeriod;
        public string forecastAmount;
        public ForecastModel(Ad_Period__c adPeriodArg){
            adPeriod = adPeriodArg;
        }
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
}