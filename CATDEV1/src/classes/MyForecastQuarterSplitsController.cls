/*
@Name           :       MyForecastQuarterSplitsController
@Author         :
@Date           :       9 Jan 2012
@Description    :       Controller for MyForecastQuarterSplits.
                        Fetching Manufacturing records from Opportunity, Program and Program Forecast associated with a SPLIT Ad Period.
                        Creting JSon string from fetched data.
                        Parsing JSON for Saving updated data.
*/
public with sharing class MyForecastQuarterSplitsController {
    public Opportunity opp{get;set;}
    public String jSonString{get;set;}
    public string jsonToSave{get;set;}
    public String colModels{get;set;}
    public String colHeads{get;set;}
    set<Id> programIds;
    public transient List<Program__c> programList;
    public transient Map<String,Map<String,Program__c>> opportunityMap;
    public boolean dataFound{get;set;}
    public String stage{get;set;}
    public String quarter{get;set;}
    
    //Variables for save work
    public set<Id> progForIds;
    public Map<String,ProgramForecastModel> programForecastModelMap = new Map<String,ProgramForecastModel>();
    public List<ProgramForecastModel> programForecastModelList;
    
    //Constructor definition
    public MyForecastQuarterSplitsController(){
        opp = new Opportunity();
        //if(stage == null){
            stage = 'Proposal';
        //}
        //if(quarter == null){
            quarter = '[All]';
        //}
        search();
    }
    
    //Method for search button, refreshing grid data
    public void search(){
        System.debug('#### Account='+opp.AccountId);
        System.debug('#### Owner='+opp.OwnerId);
        
        System.debug('#### stage='+stage);
        System.debug('#### Quarter selected ='+quarter);
        getSplitsData();
        if(dataFound){
            createJSONString();
        }else{
            jSonString = '[opportunity]';
        }
        if(jSonString.length() < 20){
            dataFound = false;
        }
        System.debug('#### JSON String created='+jSonString);
        System.debug('#### Split data found ='+dataFound);
    }
    
    //Method getting filtered data associated with Split Ad Periods
    public PageReference getSplitsData(){
        dataFound = true;
        //Warren moved this line here Mar 5 2012
        opportunityMap = new Map<String,Map<String,Program__c>>();
        RecordType rt = [SELECT id from RecordType Where SObjectType = 'Account' AND Name = 'Manufacturing' LIMIT 1];
        String query = 'SELECT id, (Select id From Programs__r) FROM Opportunity WHERE Account.RecordTypeId =\''+rt.id+'\' ';
        if(opp.OwnerId != null){
            query += 'AND OwnerId =\''+ opp.OwnerId +'\' ';
        }
        if(opp.AccountId != null){
            query += 'AND AccountId =\''+ opp.AccountId +'\' ';
        }
        if(stage == 'Proposal'){
            query += 'AND StageName != \'Closed Won\' ';
        }else if(stage == 'Contract'){
            query += 'AND StageName = \'Closed Won\' ';
        }
        
        if(quarter.contains('All') == false){
            boolean andFlag = false;
            if(quarter.contains('Q1 / Q2')){
                query += ' AND ((Q1__c = \'Y\' AND Q2__c = \'Y\') ';
                andFlag = true;
            }
            if(quarter.contains('Q2 / Q3')){
                if(andFlag){
                    query += ' OR (Q2__c = \'Y\' AND Q3__c = \'Y\') ';
                }else{
                    query += ' AND ((Q2__c = \'Y\' AND Q3__c = \'Y\') ';
                }
                andFlag = true;
            }
            if(quarter.contains('Q3 / Q4')){
                if(andFlag){
                    query += ' OR (Q3__c = \'Y\' AND Q4__c = \'Y\') ';
                }else{
                    query += ' AND ((Q3__c = \'Y\' AND Q4__c = \'Y\') ';
                }
                andFlag = true;
            }
            if(quarter.contains('Q4 / Q1')){
                if(andFlag){
                    query += ' OR (Q4__c = \'Y\' AND Q1__c = \'Y\') ';
                }else{
                    query += ' AND ((Q4__c = \'Y\' AND Q1__c = \'Y\') ';
                }
                andFlag = true;
            }
            if(andFlag){
                query += ') ';
            }
        }
        
        query += ' LIMIT 300';
        System.debug(Logginglevel.ERROR ,'#### Query created='+query);
        //Getting parent opportunities with Account.RecordType = manufacturing
        List<Opportunity> oppList = database.query(query);
        system.debug('@@@@ opp found = '+oppList.size());
        if(oppList == null || oppList.size() == 0){
            dataFound = false;
            return null;
        }
        //Getting all child programs of opportunities
        programIds = new set<Id>();
        for(Opportunity opp : oppList){
            system.debug('@@@@ Programs = '+opp.Programs__r.size());
            for(Program__c pr : opp.Programs__r){
                programIds.add(pr.id);
            }
        }
        system.debug('@@@@@ programIds size = '+programIds.size());
        if(programIds == null || programIds.size() == 0){
            dataFound = false;
            return null;
        }
        //Getting Programs and Manufacturing Split Program Forecasts
        programList = [SELECT id, Name, Delivery_Type__c, 
                       Opportunity__r.Id, Opportunity__r.Name, Opportunity__r.Probability, 
                       Opportunity__r.Account.Name, Opportunity__r.StageName, Opportunity__r.Amount, Opportunity__r.CloseDate, 
                       (Select Name, Forecast_Amount__c, Previous_Quarter_Amount__c, Next_Quarter_Amount__c, Ad_Period__r.Name From Program_Forecasts__r 
                       WHERE Ad_Period__r.Is_Split__c = 'true' AND Active__c = true /*AND Ad_Period__r.Type__c = 'Manufacturing'*/ //commented out by Warren March 5 2012
                       Order by Ad_Period__r.Start_Date__c) 
                       FROM Program__c WHERE id in : programIds];
                       
        //Grouping data Opportunity wise and Program wise
        //Warren moved this line up to beginning of method Mar 5, 2012
        //opportunityMap = new Map<String,Map<String,Program__c>>();
        for(Program__c pr : programList){
        	system.debug('RSR: '+pr.Program_Forecasts__r.size());
        	system.debug('RSR Programs: '+pr.Id);
            String oppName = pr.Opportunity__r.Name+'-'+pr.Opportunity__r.Probability+'%';
            String progName;
            if(pr.Delivery_Type__c != null){
                progName = pr.Name+'-'+pr.Delivery_Type__c;
            }else{
                progName = pr.Name;
            }
            Map<String,Program__c> programMap = opportunityMap.get(oppName);
            if(programMap == null){
                programMap = new Map<String,Program__c>();
            }   
            programMap.put(progName,pr);
            opportunityMap.put(oppName,programMap);
        }
        return null;
    }
    
    //Method creating JSON string to show on jqgrid
    public void createJSONString(){
        jSonString = '{"opportunities":[';
        integer rowNo = 0;
        //edited by Warren Mar 5, 2012 to stop null pointer exception
        //if (opportunityMap != null){
        for(String oppName : opportunityMap.keyset()){
            system.debug('@@@@ opportunity = '+oppName);
            boolean flag = false;
            boolean proForExist = false;
            string rowId;
            integer subRowNo = 0;
            Map<String,Program__c> programMap = opportunityMap.get(oppName);
            system.debug('@@@@ Program map = '+programMap);
            if(programMap != null){
                for(String progName : programMap.keyset()){
                    Program__c program = programMap.get(progName);
                    if(program.Program_Forecasts__r != null && program.Program_Forecasts__r.size() > 0){
                        proForExist = true;
                        if(!flag){
                            string oppType = 'None';
                            if(program.Opportunity__r.StageName == 'Closed Won'){
                                oppType = 'Contract';
                            }else{
                                oppType = 'Proposal';
                            }
                            decimal oppAmount = 0;
                            if(program.Opportunity__r.Amount != null){
                                oppAmount = program.Opportunity__r.Amount;
                            }
                            String closedate = String.valueOf(program.Opportunity__r.CloseDate).subString(0,10);
                            rowId = 'm'+(++rowNo);
                            jSonString += '{"id": "'+rowId+'","opportunity":"'+oppName.replaceAll('"','')+'","type":"'+oppType+'","amount":"'+oppAmount+'","closedate":"'+closedate+'","prob":"'+program.Opportunity__r.Probability+'%",';
                            jSonString += '"progForecasts":[';
                            flag = true;
                        }
                        
                        for(Program_Forecast__c proFor : program.Program_Forecasts__r){
                            string subRowId = rowId+'_s'+(++subRowNo);
                            String proForName;
                            if(program.Delivery_Type__c != null){
                                proForName = program.Name+'-'+program.Delivery_Type__c+' # '+proFor.Ad_Period__r.Name;
                            }else{
                                proForName = program.Name+' # '+proFor.Ad_Period__r.Name;
                            }
                            decimal preAmt = 0;
                            decimal nxtAmt = 0;
                            decimal progForAmount = 0;
                            if(proFor.Previous_Quarter_Amount__c != null){
                                preAmt = proFor.Previous_Quarter_Amount__c.Round();
                            }
                            if(proFor.Next_Quarter_Amount__c != null){
                                nxtAmt = proFor.Next_Quarter_Amount__c.Round();
                            }
                            if(proFor.Forecast_Amount__c != null){
                                progForAmount = proFor.Forecast_Amount__c;
                            }
                            //jSonString += '{"id":"'+subRowId+'","progforecastid":"'+proFor.Id+'","programname":"'+proForName.replaceAll('"','')+'","progamount":"'+progForAmount+'","preqtramt":"'+preAmt+'","nextqtramt":"'+nxtAmt+'"},';
                            jSonString += '{"id":"'+subRowId+'","progforecastid":"'+proFor.Id+'","programname":"<a href=/'+program.Id+' target=_blank>'+proForName.replaceAll('"','')+'</a>","progamount":"'+progForAmount+'","preqtramt":"'+preAmt+'","nextqtramt":"'+nxtAmt+'"},';
                        }
                    }
                }
                if(proForExist){
                    jSonString = jSonString.subString(0,jSonString.length()-1);
                    jSonString += ']},';
                }
            }
        }
        //end bracket added by Warren March 5, 2012
        //}
        jSonString = jSonString.subString(0,jSonString.length()-1);
        jSonString += ']}';
        if(jSonString == '{"opportunities":]}'){
	    	jSonString = '[opportunity]';
	    	dataFound = false;
        }
    }
    
    //Method parsing JSON String and saving data to database
    public void saveData(){
        System.debug('#### JSON TO SAVE= '+jsonToSave);
        progForIds = new set<Id>();
        programForecastModelMap = new Map<String,ProgramForecastModel>();
        JSONObject jobj = new JSONObject(jsonToSave);
        list<JSONObject.value> vs = jobj.getValue('programForecast').values;
        for(JSONObject.value vv : vs){
            progForIds.add(vv.obj.getString('progforecastid'));
            ProgramForecastModel proForModel = new ProgramForecastModel();
            proForModel.programForecastId = vv.obj.getString('progforecastid');
            proForModel.preQuarterAmount = vv.obj.getString('preqtramt');
            proForModel.nextQuarterAmount = vv.obj.getString('nextqtramt');
            programForecastModelMap.put(proForModel.programForecastId,proForModel);
        }
        
        if(progForIds != null && progForIds.size() > 0){
            List<Program_Forecast__c> programForecastList = [SELECT id, Previous_Quarter_Amount__c, Next_Quarter_Amount__c 
                                                             FROM Program_Forecast__c WHERE id in : progForIds];
            for(Program_Forecast__c proFor : programForecastList){
                ProgramForecastModel proForModel = programForecastModelMap.get(proFor.Id);
                proFor.Previous_Quarter_Amount__c = decimal.valueOf(proForModel.preQuarterAmount);
                proFor.Next_Quarter_Amount__c = decimal.valueOf(proForModel.nextQuarterAmount);
            }
            upsert programForecastList;
            System.debug('#### Records updated= '+programForecastList.size()+'====>'+programForecastList);
            search();
        }
    }
    
    public class ProgramForecastModel{
        public String programForecastId;
        public String preQuarterAmount;
        public String nextQuarterAmount;
    }
}