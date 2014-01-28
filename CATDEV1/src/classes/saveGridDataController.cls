/*
@Name           :       saveGridDataController
@Author         :
@Date           :   
@Description    :       Controller for SaveGridData Page.
                        Parsing XML and saving the data get from MyForecastPage (JQGrid).
@Revision History  : 2012-12-04 Cloud62: Added check at line 143 to exclude
            non-US records from last month condition
*/
global class saveGridDataController {
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
    public saveGridDataController(String jsonString, String currDate, String recType, date startAdPeriod){
        currentDate = System.today();
        jsonToParse = jsonString;
        String cDate = currDate;
        rType = recType;
        currentDate = Date.valueOf(cDate);
        adPeriodStartDate = startAdPeriod;
        getAdPeriods();
        parseMe();
        saveData();
    }
    //Method for Getting AdPeiods of all Program forecast from Start date to next 6 months
    public void getAdPeriods(){
        if(rType == 'Manufacturing'){
            adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c, Is_Split__c, Days_In_Cycle__c FROM Ad_Period__c 
                            WHERE Start_Date__c >=: adPeriodStartDate AND 
                            Type__c =: rType AND  
                            Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7')
                            Order by Start_Date__c LIMIT 13];
        } else{
            adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c, Is_Split__c, Days_In_Cycle__c FROM Ad_Period__c 
                            WHERE Start_Date__c >=: adPeriodStartDate AND 
                            Type__c =: rType AND  
                            Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7')
                            Order by Start_Date__c LIMIT 12];
        }
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
            if(proModel.forecastMonths.size() >= 13 && rType == 'Manufacturing'){
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
                if (proModel.forecastMonths.size() >= 13)proModel.forecastMonths[12].forecastAmount = vv.obj.getString('forecast13');
            } else if(proModel.forecastMonths.size() >= 12){
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
            
            for(ForecastModel fm : proModel.forecastMonths){
                proModel.monthMap.put(fm.adPeriod,fm.forecastAmount);
            }
            proModelList.add(proModel);
        }
    }
    
    //Method for saving data get from JQGrid
    public void saveData(){
        List<Program_Forecast__c> programForecastList = new List<Program_Forecast__c>();
        //added by Warren to ensure only make changes to records you have access to
        Map<Id, Boolean> accessMap = new Map<Id, Boolean>();
        List<Id> progListId = new List<Id>();
        system.debug('***UserId' + UserInfo.getUserId());
        system.debug('***BEGIN SHOWING PROGIDS');	
        for (String x : progIds){
        	system.debug('***program: ' + x);
        	progListId.add(x);
        }
        system.debug('***SELECT RecordId, HasEditAccess FROM UserRecordAccess WHERE UserId = ' + UserInfo.getUserId() + ' AND RecordId IN ' + progListId);	
        for (UserRecordAccess u : [SELECT RecordId, HasEditAccess FROM UserRecordAccess
			WHERE UserId =: UserInfo.getUserId() AND RecordId IN: progListId]){
			accessMap.put(u.RecordId, u.HasEditAccess);
			system.debug('***u.RecordId: ' + u.RecordId);		
		}
		Map<id,Program__c> programMap = new Map<id,Program__c>();
        if(rType == 'retail'){
            programMap = new Map<id,Program__c>([SELECT id, Name, 
                                                    (SELECT Active__c, Program__r.Opportunity__r.Id, Forecast_Amount__c, Previous_Quarter_Amount__c, Next_Quarter_Amount__c, Ad_Period__r.Id, Ad_Period__r.Start_Date__c, Ad_Period__r.End_Date__c From Program_Forecasts__r
                                                     WHERE Ad_Period__r.Start_Date__c >=: adPeriodStartDate //OR
                                                    //(Ad_Period__r.End_Date__c >: System.today().addMonths(-1) AND Ad_Period__r.Start_Date__c <: System.today().addMonths(-1)) 
                                                    order by Ad_Period__r.Start_Date__c LIMIT 12)
                                                    from Program__c WHERE id in : progIds]);
        }else if(rType == 'Manufacturing'){
            programMap = new Map<id,Program__c>([SELECT id, Name, 
                                                    (SELECT Active__c, Program__r.Opportunity__r.Id, Forecast_Amount__c, Previous_Quarter_Amount__c, Next_Quarter_Amount__c, Ad_Period__r.Id, Ad_Period__r.Start_Date__c, Ad_Period__r.End_Date__c From Program_Forecasts__r
                                                     WHERE Ad_Period__r.Start_Date__c >=: adPeriodStartDate //OR
                                                    //(Ad_Period__r.End_Date__c >: System.today().addDays(-28) AND Ad_Period__r.Start_Date__c <: System.today().addDays(-28)) 
                                                    order by Ad_Period__r.Start_Date__c LIMIT 13)
                                                    from Program__c WHERE id in : progIds]);
        }else if(rType == 'Manufacturing France'){
            programMap = new Map<id,Program__c>([SELECT id, Name, 
                                                    (SELECT Active__c, Program__r.Opportunity__r.Id, Forecast_Amount__c, Previous_Quarter_Amount__c, Next_Quarter_Amount__c, Ad_Period__r.Id, Ad_Period__r.Start_Date__c, Ad_Period__r.End_Date__c From Program_Forecasts__r
                                                     WHERE Ad_Period__r.Start_Date__c >=: adPeriodStartDate //OR
                                                    //(Ad_Period__r.End_Date__c >: System.today().addDays(-28) AND Ad_Period__r.Start_Date__c <: System.today().addDays(-28)) 
                                                    order by Ad_Period__r.Start_Date__c LIMIT 12)
                                                    from Program__c WHERE id in : progIds]);
        }else if(rType == 'Manufacturing Italy'){
            programMap = new Map<id,Program__c>([SELECT id, Name, 
                                                    (SELECT Active__c, Program__r.Opportunity__r.Id, Forecast_Amount__c, Previous_Quarter_Amount__c, Next_Quarter_Amount__c, Ad_Period__r.Id, Ad_Period__r.Start_Date__c, Ad_Period__r.End_Date__c From Program_Forecasts__r
                                                     WHERE Ad_Period__r.Start_Date__c >=: adPeriodStartDate //OR
                                                    //(Ad_Period__r.End_Date__c >: System.today().addDays(-28) AND Ad_Period__r.Start_Date__c <: System.today().addDays(-28)) 
                                                    order by Ad_Period__r.Start_Date__c LIMIT 12)
                                                    from Program__c WHERE id in : progIds]);
        }else if(rType == 'Manufacturing Germany'){
            programMap = new Map<id,Program__c>([SELECT id, Name, 
                                                    (SELECT Active__c, Program__r.Opportunity__r.Id, Forecast_Amount__c, Previous_Quarter_Amount__c, Next_Quarter_Amount__c, Ad_Period__r.Id, Ad_Period__r.Start_Date__c, Ad_Period__r.End_Date__c From Program_Forecasts__r
                                                     WHERE Ad_Period__r.Start_Date__c >=: adPeriodStartDate //OR
                                                    //(Ad_Period__r.End_Date__c >: System.today().addDays(-28) AND Ad_Period__r.Start_Date__c <: System.today().addDays(-28)) 
                                                    order by Ad_Period__r.Start_Date__c LIMIT 12)
                                                    from Program__c WHERE id in : progIds]);
        }if(rType == 'Retail Japan'){
            programMap = new Map<id,Program__c>([SELECT id, Name, 
                                                    (SELECT Active__c, Program__r.Opportunity__r.Id, Forecast_Amount__c, Previous_Quarter_Amount__c, Next_Quarter_Amount__c, Ad_Period__r.Id, Ad_Period__r.Start_Date__c, Ad_Period__r.End_Date__c From Program_Forecasts__r
                                                     WHERE Ad_Period__r.Start_Date__c >=: adPeriodStartDate //OR
                                                    //(Ad_Period__r.End_Date__c >: System.today().addMonths(-1) AND Ad_Period__r.Start_Date__c <: System.today().addMonths(-1)) 
                                                    order by Ad_Period__r.Start_Date__c LIMIT 12)
                                                    from Program__c WHERE id in : progIds]);
        }else if(rType == 'Manufacturing Japan'){
            programMap = new Map<id,Program__c>([SELECT id, Name, 
                                                    (SELECT Active__c, Program__r.Opportunity__r.Id, Forecast_Amount__c, Previous_Quarter_Amount__c, Next_Quarter_Amount__c, Ad_Period__r.Id, Ad_Period__r.Start_Date__c, Ad_Period__r.End_Date__c From Program_Forecasts__r
                                                     WHERE Ad_Period__r.Start_Date__c >=: adPeriodStartDate //OR
                                                    //(Ad_Period__r.End_Date__c >: System.today().addDays(-28) AND Ad_Period__r.Start_Date__c <: System.today().addDays(-28)) 
                                                    order by Ad_Period__r.Start_Date__c LIMIT 12)
                                                    from Program__c WHERE id in : progIds]);
        }
        
        for(ProgramModel pModel : proModelList){
            Program__c program = programMap.get(pModel.programId);
            system.debug('***programId: ' + program.Id);
            if(program != null){
            	if (accessMap.get(pModel.programId) == true){
	                for(Ad_Period__c adPeriod : pModel.monthMap.keySet()){
	                    boolean found = false;
	                    for(Program_Forecast__c proFor : program.Program_Forecasts__r){
	                        //Check for last month (not to update)
	                        //edited by Warren Dec 4, 2012, limiting this check to only US Ad Periods
	                        //Note - there is only 1 "Retail" record type, both upper and lower case
	                        //"r" have been added for security reasons
	                         if(adPeriod.Id == proFor.Ad_Period__r.Id
	                          && proFor.Active__c ==false
	                          && (rType == 'Manufacturing' || rType == 'retail' || rType == 'Retail'))
	                        {
	                            found = true;
	                            break;
	                        }
	                        if(adPeriod.Id == proFor.Ad_Period__r.Id){
	                            String valueStr = pModel.monthMap.get(adPeriod);
	                            decimal value = 0;
	                            if(valueStr != '' && valueStr != null){
	                                value = decimal.valueOf(valueStr);
	                            }
	                            proFor.Forecast_Amount__c = value;
	                            if(adPeriod.Is_Split__c == 'true'){
	                                integer nxtQtrDays = adPeriod.End_Date__c.day();
	                                decimal preQtrDays = adPeriod.Days_In_Cycle__c - nxtQtrDays;
	                                proFor.Previous_Quarter_Amount__c = preQtrDays / adPeriod.Days_In_Cycle__c * value;
	                                proFor.Next_Quarter_Amount__c = value - proFor.Previous_Quarter_Amount__c;
	                            }
	                            if(rType == 'Manufacturing France' || rType == 'Manufacturing Italy' || rType == 'Manufacturing Germany'){
	                                proFor.CurrencyIsoCode = 'EUR';
	                            } else if(rType == 'Retail Japan' || rType == 'Manufacturing Japan'){
	                                proFor.CurrencyIsoCode = 'JPY';
	                            }
	                            programForecastList.add(proFor);
	                            found = true;
	                            break;
	                        }
	                    }
	                    if(!found){
	                        String valueStr = pModel.monthMap.get(adPeriod);
	                        decimal value = 0;
	                        if(valueStr != '' && valueStr != null){
	                            value = decimal.valueOf(valueStr);
	                        }
	                        if(value > 0){
	                            Program_Forecast__c newPF = new Program_Forecast__c();
	                            if(rType == 'Manufacturing France' || rType == 'Manufacturing Italy' || rType == 'Manufacturing Germany'){
	                                newPF.CurrencyIsoCode = 'EUR';
	                            }
	                            newPF.Program__c = pModel.programId;
	                            newPf.Forecast_Amount__c = value;
	                            
	                            newPf.Ad_Period__c = adPeriod.Id;
	                            if(adPeriod.Is_Split__c == 'true'){
	                                integer nxtQtrDays = adPeriod.End_Date__c.day();
	                                decimal preQtrDays = adPeriod.Days_In_Cycle__c - nxtQtrDays;
	                                newPf.Previous_Quarter_Amount__c = preQtrDays / adPeriod.Days_In_Cycle__c * value;
	                                newPf.Next_Quarter_Amount__c = value - newPf.Previous_Quarter_Amount__c;
	                            }
	                            programForecastList.add(newPf);
	                        }
	                    }
	                }
            	}
            }
        }
        if(programForecastList.size() > 0){
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
}