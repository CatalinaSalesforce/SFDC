/*
@Name           :       MyForecastActualFranceController
@Author         :
@Date           :   
@Description    :       Controller for MyForecastJSonPage.
                        Fetching records from Ad Period, Opportunity, Program and Program Forecast based on the filters.
                        Creting JSon string from fetched data.
*/
public with sharing class MyForecastActualFranceController {
    final static String q1Start = '-01-01';
    final static String q2Start = '-04-01';
    final static String q3Start = '-07-01';
    final static String q4Start = '-10-01';
    final static String q1End = '-03-31';
    final static String q2End = '-06-30';
    final static String q3End = '-09-30';
    final static String q4End = '-12-31';
    
    public String jSonString{get;set;}
    public List<Opportunity> opportunityList;
    public List<Program__c> programList;
    public List<Ad_Period__c> adPeriodList{get;set;}
    public List<RecordType> rtList;
    public List<OpportunityModel> opportunityModelList;
    public Map<integer,String> monthMap;
    public Map<String,integer> indexMap;
    public Date currentDate;
    public string rType;
    public String stage;
    public String accountName;
    public string oppUser;
    public String opportunityId;
    public date adPeriodStartDate;
    public string programStatus;
    public string quarter;
    public String year;
    public decimal progAmt;
    public String cycle;
    //Cloud62 5/31/2012 - Added oppty name string to filter on
    public String oppName;
    public String currencySymbol{get;set;}
    public String variance;
    public String proposalNumber;
    //Constructor definition 
    //Cloud62 5/31/2012 - Added String oppNameArg to also filter by Opportunity name
    public MyForecastActualFranceController(String opportunityIdArg, String cDate, String rTypeArg, String stageArg, String accountNameArg, String oppUserArg, String progStatusArg, decimal progAmtArg, String qtrArg, date adPeriodStartDateArg, String oppNameArg, String yearArg, String cycleArg, String varianceArg, String proposalNumberArg){
        opportunityId = opportunityIdArg;
        rType = rTypeArg;
        stage = stageArg;
        accountName = accountNameArg;
        oppUser = oppUserArg;
        programStatus = progStatusArg;
        progAmt = progAmtArg;
        quarter = qtrArg;
        year = yearArg;
        cycle = cycleArg;
        variance = varianceArg;
        proposalNumber = proposalNumberArg;
        if(oppNameArg != null){
            oppName = '%' + oppNameArg + '%';
        } else {
            oppName = '%';
        }

        if(cDate != null){
            currentDate = Date.valueOf(cDate);
        }else{
            currentDate = System.today();
        }
        adPeriodStartDate = adPeriodStartDateArg;
        rtList = [SELECT id from RecordType Where SObjectType = 'Account' AND Name =: rType LIMIT 1];
        opportunityModelList = new List<OpportunityModel>();
        getAdPeriods();
        getOpportunities();
        createJSonString();
    }
    
    public MyForecastActualFranceController(String opportunityIdArg, String cDate, String rTypeArg, String stageArg, String accountNameArg, String oppUserArg, String progStatusArg, decimal progAmtArg, String qtrArg, date adPeriodStartDateArg, String oppNameArg, String yearArg){
        this (opportunityIdArg, cDate, rTypeArg, stageArg, accountNameArg, oppUserArg, progStatusArg, progAmtArg, qtrArg, adPeriodStartDateArg, oppNameArg, yearArg, null, null, null);
    }
    
    //Method to get all Ad Periods of the program forecast from start date to next 6 months
    public void getAdPeriods(){
        /*
        adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                        WHERE (Start_Date__c >=: adPeriodStartDate OR 
                        (End_Date__c >=: system.today().addMonths(-1) AND Start_Date__c <: system.today().addMonths(-1))) AND 
                        Type__c =: rType 
                        Order by Start_Date__c LIMIT 7];
        */
        adPeriodList = [SELECT id, Name, Start_Date__c, End_Date__c FROM Ad_Period__c 
                        WHERE Start_Date__c >=: adPeriodStartDate AND 
                        Type__c =: rType AND
                        Name Not in ('11-Feb','12-Feb','12-Jan','12-Jul','12-Jun','12-May','2011-2','2011-5','2011-7','2012-1','2012-2','2012-4','2012-6','2012-7') 
                        Order by Start_Date__c LIMIT 12];
    }
    
    //Method for getting opportunities based on the filters
    public PageReference getOpportunities(){
        //getting all users manage by selected user
        set<Id> userIds = new set<Id>();
        if(oppUser != null && oppUser.trim().length() > 0){
            List<User> cUsers = [Select id from User WHERE Name =: oppUser LIMIT 1];
            if(cUsers.size() > 0){
                List<User> userList = [SELECT id from User WHERE id =: cUsers.get(0).Id];
                if(userList != null){
                    for(User u : userList){
                        userIds.add(u.Id);
                    }
                }
            }
        }
        
        string query = 'SELECT id FROM Program__c Where ID != NULL ';
        String pStatus = programStatus;
        if(programStatus == 'Active'){
            query += 'And Status__c = \'Active\' ';
        }else if(programStatus == 'Inactive with Overages'){
            query += 'And Status__c != \'Active\' AND Variance__c > 0 ';
        }else if(programStatus == 'Inactive with Shortfall'){
            query += 'And Status__c != \'Active\' AND Variance__c < 0 ';
        }
        if(progAmt > 0){ 
            query += 'AND Program_Amount__c >=: progAmt ';  
        }
        
        if(variance=='Positive'){
            query += 'AND Variance__c >= 0 ';
        } else if (variance=='Negative'){
            query += 'AND Variance__c < 0 ';
        }
        
        //below added by Warren for Year and Quarter filter
        if (rType == 'Manufacturing' || rType == 'Retail'){
            if (year != 'All' && year != null){
                if (quarter.contains('All') || quarter == '[]'){
                    query += ' AND End_Cycle__r.End_Date__c > ' + year + q1Start + ' ';
                    query += ' And Start_Cycle__r.Start_Date__c < ' + year + q4End + ' ';
                } else {
                    quarter = quarter.substring(1, quarter.length() - 1);
                    List<String> quarterList = quarter.split(',');
                    query += ' AND( ';
                    boolean multiQ = false;
                    for (String x : quarterList){
                        x = x.trim();
                        if (multiQ){
                            query += ' OR ';
                        } else {
                            multiQ = true;
                        }
                        if (x == 'Q1'){
                            query += ' (End_Cycle__r.End_Date__c > ' + year + q1Start + ' ';
                            query += ' And Start_Cycle__r.Start_Date__c < ' + year + q1End + ')';
                        } else if (x == 'Q2'){
                            query += ' (End_Cycle__r.End_Date__c > ' + year + q2Start + ' ';
                            query += ' And Start_Cycle__r.Start_Date__c < ' + year + q2End + ') ';
                        } else if (x == 'Q3'){
                            query += ' (End_Cycle__r.End_Date__c > ' + year + q3Start + ' ';
                            query += ' And Start_Cycle__r.Start_Date__c < ' + year + q3End + ') ';
                        } else if (x == 'Q4'){
                            query += ' (End_Cycle__r.End_Date__c > ' + year + q4Start + ' ';
                            query += ' And Start_Cycle__r.Start_Date__c < ' + year + q4End + ') ';
                        }
                    }
                    query += ' )';
                }
            }
            else if((quarter.contains('Q1') || quarter.contains('Q2') || quarter.contains('Q3') || quarter.contains('Q4')) && quarter.contains('All') == false)
            {
                
                year = String.valueof(Date.today().year());
                quarter = quarter.substring(1, quarter.length() - 1);
                    List<String> quarterList = quarter.split(',');
                    query += ' AND( ';
                    boolean multiQ = false;
                    for (String x : quarterList){
                        x = x.trim();
                        if (multiQ){
                            query += ' OR ';
                        } else {
                            multiQ = true;
                        }
                        if (x == 'Q1'){
                            query += ' (End_Cycle__r.End_Date__c > ' + year + q1Start + ' ';
                            query += ' And Start_Cycle__r.Start_Date__c < ' + year + q1End + ')';
                        } else if (x == 'Q2'){
                            query += ' (End_Cycle__r.End_Date__c > ' + year + q2Start + ' ';
                            query += ' And Start_Cycle__r.Start_Date__c < ' + year + q2End + ') ';
                        } else if (x == 'Q3'){
                            query += ' (End_Cycle__r.End_Date__c > ' + year + q3Start + ' ';
                            query += ' And Start_Cycle__r.Start_Date__c < ' + year + q3End + ') ';
                        } else if (x == 'Q4'){
                            query += ' (End_Cycle__r.End_Date__c > ' + year + q4Start + ' ';
                            query += ' And Start_Cycle__r.Start_Date__c < ' + year + q4End + ') ';
                        }
                    }
                    query += ' )';
            }
        } else /* change added by c62 if (rType == 'Manufacturing France') */ {
            if (year != 'All' && year != null){
                if (cycle.contains('All') || cycle == '[]'){
                    query += ' AND End_Cycle__r.End_Date__c > ' + year + q1Start + ' ';
                    query += ' And Start_Cycle__r.Start_Date__c < ' + year + q4End + ' ';
                    system.debug('query if>>'+query);
                } else {
                    system.debug('query if>>'+query);
                    List<Ad_Period__c> adList = [SELECT ID, NAME, START_DATE__C, END_DATE__C
                        FROM AD_PERIOD__C WHERE TYPE__C =: rType];
                    Map<String, Map<String, Ad_Period__c>> adMap = new Map<String, Map<String, Ad_Period__c>>(); 
                    for (Ad_Period__c ap : adList){
                        String tempyear;
                        String tempcycle;
                        if(rType=='Manufacturing Germany'){
                            tempyear = ap.Name.substring(ap.Name.length() - 8, ap.Name.length()-4);
                            tempcycle = ap.Name.substring(ap.Name.indexOf('_C', 0) + 1, ap.Name.indexOf('_C', 0) + 3)+'-'+ap.Name.substring(ap.Name.length() - 3, ap.Name.length());
                        } else {
                            tempyear = ap.Name.substring(ap.Name.length() - 4, ap.Name.length());
                            tempcycle = ap.Name.substring(ap.Name.indexOf('_C', 0) + 1, ap.Name.indexOf('_C', 0) + 3);
                        }
                        if (!adMap.containsKey(tempyear)){
                            adMap.put(tempyear, new Map<String, Ad_Period__c>());
                        }
                        if (!adMap.get(tempyear).containsKey(tempcycle)){
                            adMap.get(tempyear).put(tempcycle, ap);
                        }
                    }
                    cycle = cycle.substring(1, cycle.length() - 1);
                    system.debug('cycle>>'+cycle);
                    List<String> cycleList = cycle.split(',');
                    query += ' AND( ';
                    boolean multiQ = false;
                    system.debug('cycleList>>'+cycleList);
                    for (String x : cycleList){
                        x = x.trim();
                        if (multiQ){
                            query += ' OR ';
                        } else {
                            multiQ = true;
                        }
                        Ad_Period__c thisAP = adMap.get(year).get(x);
                        system.debug('thisAP>>'+thisAP);
                        Date startD = thisAP.Start_Date__c;
                        Date endD = thisAP.End_Date__c;
                        query += ' (End_Cycle__r.End_Date__c > ' + startD.year() + '-' + (startD.month() < 10 ? '0' + String.valueOf(startD.month()) : String.valueOf(startD.month())) + '-' + (startD.day() < 10 ? '0' + String.valueOf(startD.day()) : String.valueOf(startD.day())) + ' ';
                        query += ' And Start_Cycle__r.Start_Date__c < ' + endD.year() + '-' + (endD.month() < 10 ? '0' + String.valueOf(endD.month()) : String.valueOf(endD.month())) + '-' + (endD.day() < 10 ? '0' + String.valueOf(endD.day()) : String.valueOf(endD.day())) + ')';
                    }
                    query += ' )';
                }
            }
        }
        
        query += 'AND Opportunity__r.Account.RecordTypeId =\''+rtList.get(0).id+'\' ';
        //Account filter
        if(accountName != null && accountName.trim().length() > 0){
            String accName = '%'+accountName+'%';
            List<Account> acc = [SELECT id, Name from Account WHERE Name Like : accName];
            List<string> accIds = new List<String>();
            for(Account ac : acc){
                accIds.add(ac.Id);
            }
            if(acc != null && acc.size() > 0){
                //query += 'AND Account.Id =\''+acc[0].Id+'\' ';
                query += 'AND Opportunity__r.Account.Id in : accIds ';
            }else{
                return null;
            }
        }
        //Stage filter
        String rid;
/*        if(stage == 'All'){
            //All
        }else if(stage == 'Proposal' || stage == 'Contract'){
            RecordType rt = [SELECT id, name from RecordType Where SObjectType = 'Opportunity' AND Name =: stage Limit 1];
            if(rt != null){
                rid = rt.Id;
                if(stage == 'Proposal'){
                    query += ' AND (Opportunity__r.RecordType.Name Like \'%Proposal%\' ) ';
                }else if(stage == 'Contract'){
                    query += ' AND Opportunity__r.RecordType.Name Like \'%Contract%\' ';
                }
            }
        }
*/        
        //change added on 06-24-2013 to display only contract data
        query += ' AND Opportunity__r.RecordType.Name Like \'%Contract%\' ';
        
        if(userIds.size() > 0 && userIds != null){
            query += ' AND Opportunity__r.OwnerId in : userIds ';
        }
        
        if(opportunityId != null && opportunityId.trim().length() > 0){
            //query = 'SELECT id, (Select id From Programs__r) FROM Opportunity WHERE Id =\''+opportunityId+'\' ';
            query += ' AND Opportunity__r.Id =\''+opportunityId+'\' ';
        }
        if (oppName != null){
            query += ' AND Opportunity__r.Name Like \'' +oppName+ '\' ';
        }
        
        if(proposalNumber != null && proposalNumber.trim().length()>0){
            query += ' AND Opportunity__r.Proposal_Number__c =\''+proposalNumber+'\' ';
        }
        
        //change made on 06-25-2013 to filter reporting opportunities
        query += ' AND Opportunity__r.For_Reporting__c = False ';
        
        query += ' LIMIT 300';
        system.debug('query>>'+query);
        programList = database.query(query);
        
        set<Id> programIds = new set<Id>();
        
        for(Program__c p : programList)
        {
            programIds.add(p.id);
        }
                 
        programList = new List<Program__c>();
        
        /*
        string query = 'SELECT id, (Select id From Programs__r ';
        Boolean whereFlag = true;
        String pStatus = programStatus;
        if(programStatus == 'Active'){
            query += 'Where Status__c = \'Active\' ';
        }else if(programStatus == 'Inactive with Overages'){
            query += 'Where Status__c != \'Active\' AND Variance__c > 0 ';
        }else if(programStatus == 'Inactive with Shortfall'){
            query += 'Where Status__c != \'Active\' AND Variance__c < 0 ';
        }else{
            whereFlag = false;
        }
        
        if(progAmt > 0){
            if(whereFlag){
                query += 'AND Program_Amount__c >=: progAmt ';
            }else{
                query += 'WHERE Program_Amount__c >=: progAmt ';
            }
        }
        //below added by Warren for Year and Quarter filter
        if (year != 'All' && year != null){
            if (!whereflag){
                query += ' WHERE ID != NULL ';
                whereflag = true;

            }
            if (quarter.contains('All') || quarter == '[]'){
                query += ' AND End_Cycle__r.End_Date__c > ' + year + q1Start + ' ';
                query += ' And Start_Cycle__r.Start_Date__c < ' + year + q4End + ' ';
            } else {
                quarter = quarter.substring(1, quarter.length() - 1);
                List<String> quarterList = quarter.split(',');
                query += ' AND( ';
                boolean multiQ = false;
                for (String x : quarterList){
                    x = x.trim();
                    if (multiQ){
                        query += ' OR ';

                    } else {
                        multiQ = true;

                    }
                    if (x == 'Q1'){
                        query += ' (End_Cycle__r.End_Date__c > ' + year + q1Start + ' ';
                        query += ' And Start_Cycle__r.Start_Date__c < ' + year + q1End + ')';
                    } else if (x == 'Q2'){
                        query += ' (End_Cycle__r.End_Date__c > ' + year + q2Start + ' ';
                        query += ' And Start_Cycle__r.Start_Date__c < ' + year + q2End + ') ';
                    } else if (x == 'Q3'){
                        query += ' (End_Cycle__r.End_Date__c > ' + year + q3Start + ' ';
                        query += ' And Start_Cycle__r.Start_Date__c < ' + year + q3End + ') ';
                    } else if (x == 'Q4'){
                        query += ' (End_Cycle__r.End_Date__c > ' + year + q4Start + ' ';
                        query += ' And Start_Cycle__r.Start_Date__c < ' + year + q4End + ') ';


                    }
                }
                query += ' )';

            }
        }
        
        
        query += ') FROM Opportunity WHERE Account.RecordTypeId =\''+rtList.get(0).id+'\' ';
        //Account filter
        if(accountName != null && accountName.trim().length() > 0){
            String accName = '%'+accountName+'%';
            List<Account> acc = [SELECT id, Name from Account WHERE Name Like : accName];
            List<string> accIds = new List<String>();
            for(Account ac : acc){
                accIds.add(ac.Id);
            }
            if(acc != null && acc.size() > 0){
                //query += 'AND Account.Id =\''+acc[0].Id+'\' ';
                query += 'AND Account.Id in : accIds ';
            }else{
                return null;
            }
        }
        //Stage filter
        String rid;
        if(stage == 'All'){
            //All
        }else if(stage == 'Proposal' || stage == 'Contract'){
            RecordType rt = [SELECT id, name from RecordType Where SObjectType = 'Opportunity' AND Name =: stage Limit 1];
            if(rt != null){
                rid = rt.Id;
                if(stage == 'Proposal'){

                    query += ' AND (RecordType.Name Like \'%Proposal%\' ) ';
                }else if(stage == 'Contract'){

                    query += ' AND RecordType.Name Like \'%Contract%\' ';
                }
            }
        }
        /*
        if(quarter.contains('All') == false){
            boolean andFlag = false;
            if(quarter.contains('Q1')){
                query += ' AND (Q1__c = \'Y\' ';
                andFlag = true;
            }
            if(quarter.contains('Q2')){
                if(andFlag){
                    query += ' OR Q2__c = \'Y\' ';
                }else{
                    query += ' AND (Q2__c = \'Y\' ';
                }
                andFlag = true;
            }
            if(quarter.contains('Q3')){
                if(andFlag){
                    query += ' OR Q3__c = \'Y\' ';
                }else{
                    query += ' AND (Q3__c = \'Y\' ';
                }
                andFlag = true;
            }
            if(quarter.contains('Q4')){
                if(andFlag){
                    query += ' OR Q4__c = \'Y\' ';
                }else{
                    query += ' AND (Q4__c = \'Y\' ';
                }
                andFlag = true;
            }
            if(andFlag){
                query += ') ';
            }
        }
        */
        
        /*
        if(stage == 'Proposal'){
            query += ' AND StageName != \'Closed Won\' ';
        }else if(stage == 'Contract'){
            query += ' AND StageName = \'Closed Won\' ';
        }else{
            //All
        }

        
        //Owner filter
        if(userIds.size() > 0 && userIds != null){
            query += ' AND OwnerId in : userIds ';
        }
        
        //Opportunity filter (If page opened from the Opportunity detail page)
        if(opportunityId != null && opportunityId.trim().length() > 0){
            //query = 'SELECT id, (Select id From Programs__r) FROM Opportunity WHERE Id =\''+opportunityId+'\' ';
            query += ' AND Id =\''+opportunityId+'\' ';
        }
        if (oppName != null){
            query += ' AND Name Like \'' +oppName+ '\' ';
        }
        query += ' LIMIT 300';
        opportunityList = database.query(query);
        */
        
        //if(opportunityList == null || opportunityList.size() == 0){
        //    return null;

        //}
        //Getting all child programs of opportunity      

       
        if(programIds == null || programIds.size() == 0){
            return null;
        }
        //Getting all programs and child program forecast
        if(rType == 'Manufacturing'){
            programList = [SELECT id, Name, Delivery_Type__c, Program_Amount__c, Variance__c, Weighted_Forecast_Amount__c, 
                            Opportunity__r.Id, Opportunity__r.Name, Opportunity__r.Probability, Opportunity__r.Account.Name, Opportunity__r.CATS_External_ID__c, Opportunity__r.StageName, 
                            (Select Actual_Amount__c, Forecast_Amount__c, Ad_Period__r.Name, Ad_Period__r.Start_Date__c, Ad_Period__r.End_Date__c From Program_Forecasts__r 
                                WHERE Ad_Period__r.Start_Date__c >=: adPeriodStartDate //OR
                                //(Ad_Period__r.End_Date__c >: System.today().addDays(-28) AND Ad_Period__r.Start_Date__c <: System.today().addDays(-28)) 
                                 order by Ad_Period__r.Start_Date__c LIMIT 7)
                            FROM Program__c 
                            WHERE id in : programIds 
                            //Cloud62 5/31/2012 - Added filter to skip if oppty is closed lost
                            //Cloud62 5/31/2012 - Added Oppty name filter
                            AND Opportunity__r.StageName NOT IN ('Closed Lost', 'Closed Error')
                            AND Opportunity__r.Name LIKE :oppName];
        }else if(rType == 'retail'){
            programList = [SELECT id, Name, Delivery_Type__c, Program_Amount__c, Variance__c, Weighted_Forecast_Amount__c, 
                            Opportunity__r.Id, Opportunity__r.Name, Opportunity__r.Probability, Opportunity__r.Account.Name, Opportunity__r.CATS_External_ID__c, Opportunity__r.StageName, 
                            (Select Actual_Amount__c, Forecast_Amount__c, Ad_Period__r.Name, Ad_Period__r.Start_Date__c, Ad_Period__r.End_Date__c From Program_Forecasts__r 
                                WHERE Ad_Period__r.Start_Date__c >=: adPeriodStartDate //OR
                                //(Ad_Period__r.End_Date__c >: System.today().addMonths(-1) AND Ad_Period__r.Start_Date__c <: System.today().addMonths(-1)) 
                                 order by Ad_Period__r.Start_Date__c LIMIT 7)
                            FROM Program__c 
                            WHERE id in : programIds 
                            //Cloud62 5/31/2012 - Added filter to skip if oppty is closed lost
                            //Cloud62 5/31/2012 - Added Oppty name filter
                            AND Opportunity__r.StageName NOT IN ('Closed Lost', 'Closed Error')
                            AND Opportunity__r.Name LIKE :oppName];
        }else /* change added by c62 if(rType == 'Manufacturing France')*/  {
            programList = [SELECT id, Name, Delivery_Type__c, Program_Amount__c, Variance__c, Weighted_Forecast_Amount__c, 
                            Opportunity__r.Id, Opportunity__r.Name, Opportunity__r.Probability, Opportunity__r.Account.Name, Opportunity__r.CATS_External_ID__c, Opportunity__r.StageName, 
                            (Select Actual_Amount__c, Forecast_Amount__c, Ad_Period__r.Name, Ad_Period__r.Start_Date__c, Ad_Period__r.End_Date__c From Program_Forecasts__r 
                                WHERE Ad_Period__r.Start_Date__c >=: adPeriodStartDate //OR
                                //(Ad_Period__r.End_Date__c >: System.today().addMonths(-1) AND Ad_Period__r.Start_Date__c <: System.today().addMonths(-1)) 
                                 order by Ad_Period__r.Start_Date__c LIMIT 12)
                            FROM Program__c 
                            WHERE id in : programIds 
                            //Cloud62 5/31/2012 - Added filter to skip if oppty is closed lost
                            //Cloud62 5/31/2012 - Added Oppty name filter
                            AND Opportunity__r.StageName NOT IN ('Closed Lost', 'Closed Error')
                            AND Opportunity__r.Name LIKE :oppName];
        }
        
        if(programList.size()>0){
            currencySymbol = programList[0].CurrencyISOcode;
            if(currencySymbol == 'EUR'){
                currencySymbol = '€';
                } else {
                    currencySymbol = '$';    
            }
        }
        
        Map<Id,Map<String,Map<Program__c,String>>> opportunityMap = new Map<Id,Map<String,Map<Program__c,String>>>();
        for(Program__c pr : programList){
            String accName = pr.Opportunity__r.Account.Name;
            //change made on 30/5/13 to display only name for Germany
            //String oppName = pr.Opportunity__r.Name+'-'+pr.Opportunity__r.Probability;
            String oppName = pr.Opportunity__r.Name;
            if(rType != 'Manufacturing Germany'){
                oppName += '-'+pr.Opportunity__r.Probability;
            }
            //end
            Id oppId = pr.Opportunity__r.Id;
            String progName;
            //change added on 14/6/2013 to display program name without Delivery Type for Germany only.
            /*if(pr.Delivery_Type__c != null){
                progName = pr.Name+'-'+pr.Delivery_Type__c;
            }else{
                progName = pr.Name;
            }
            */
            progName = pr.Name;
            if(pr.Delivery_Type__c != null && rType != 'Manufacturing Germany'){
                progName = pr.Name+'-'+pr.Delivery_Type__c;
            }
            //end change
            
            Map<String,Map<Program__c,String>> oppProgMap = opportunityMap.get(oppId);
            if(oppProgMap == null){
                oppProgMap = new Map<String,Map<Program__c,String>>();
                Map<Program__c,String> pMap = new Map<Program__c,String>();
                pMap.put(pr,progName);
                oppProgMap.put(oppName,pMap);
            }else{
                Map<Program__c,String> programMap = oppProgMap.get(oppName);
                if(programMap == null){
                    programMap = new Map<Program__c,String>();
                }
                programMap.put(pr,progName);
                oppProgMap.put(oppName,programMap); 
            }
            opportunityMap.put(oppId,oppProgMap);
        }
        for(Id opId : opportunityMap.keyset()){
            Map<String,Map<Program__c,String>> oppProgMap = opportunityMap.get(opId);
            for(String oppNm : oppProgMap.keyset()){
                OpportunityModel oppModel = new OpportunityModel();
                oppModel.opportunityName = oppNm;
                oppModel.oppId = opId;
                Map<Program__c,String> pMap = oppProgMap.get(oppNm);
                if(pMap != null){
                    for(Program__c pnm : pMap.keyset()){
                        ProgramModel pModel = new ProgramModel();
                        pModel.programName = pMap.get(pnm);
                        Program__c program = pnm;
                        if(program.Program_Amount__c != null){
                            pModel.programAmount = program.Program_Amount__c;
                        }else{
                            pModel.programAmount = 0;
                        }
                        pModel.variance = program.Variance__c;
                        pModel.programId = program.Id;
                        if (rType == 'Manufacturing France' || rType == 'Manufacturing Italy' || rType == 'Manufacturing Germany'){
                            pModel.weightedForecast = 0;
                        } else {
                            pModel.weightedForecast = program.Weighted_Forecast_Amount__c;
                        }
                        if(program.Opportunity__r.CATS_External_ID__c != null){
                            pModel.catsExternalId = program.Opportunity__r.CATS_External_ID__c;
                        }
                        pModel.oppStage = program.Opportunity__r.StageName;
                        integer index = 0;
                        indexMap = new Map<String,integer>();
                        //adding forecast months for all months to be shown with forecast amount 0
                        for(Ad_Period__c adPeriod : adPeriodList){
                            pModel.forecastMonths.add(new ForecastModel(adPeriod.Name));
                            indexMap.put(adPeriod.Name,index++);
                        }
                        //Overright the forecast values for months whose Program forecast found.
                        for(Program_Forecast__c prFor : program.Program_Forecasts__r){
                            if(indexMap.get(prFor.Ad_Period__r.Name) != null){
                                //edited by Warren Mar 5, 2012 to accept null forecast amount
                                //Warren Jan 8 2013, always show Actual_Amount__c
                                pModel.forecastMonths[indexMap.get(prFor.Ad_Period__r.Name)].forecastAmount = (prFor.Actual_Amount__c == null ? 0 : prFor.Actual_Amount__c);
                                pModel.forecastMonths[indexMap.get(prFor.Ad_Period__r.Name)].actualAmount = (prFor.Actual_Amount__c == null ? 0 : prFor.Actual_Amount__c);
                                pModel.forecastMonths[indexMap.get(prFor.Ad_Period__r.Name)].startDate = prFor.Ad_Period__r.Start_Date__c;
                                pModel.forecastMonths[indexMap.get(prFor.Ad_Period__r.Name)].endDate = prFor.Ad_Period__r.End_Date__c;
                            }
                        }
                        oppModel.programList.add(pModel);
                    }
                }
                opportunityModelList.add(oppModel);
            }
        }
        
        return null;
    }
    
    //Method to create JSon String
    public void createJSonString(){
        jSonString = '[';
        integer rowId = 0;
        
        for(OpportunityModel om : opportunityModelList){
            //change made on 30/5/13 to display only name for Germany
            /*
            String oppName = om.opportunityName.replaceAll('"','')+'%';
            for(ProgramModel pm : om.programList){
                 oppName += ' '+currencySymbol+ pm.programAmount;
            }
            */
            String oppName = om.opportunityName.replaceAll('"','');
            if(rType != 'Manufacturing Germany'){
                oppName += '%';
                for(ProgramModel pm : om.programList){
                    oppName += ' '+currencySymbol+ pm.programAmount;
                }
            }
            //end  
            for(ProgramModel pm : om.programList){
                //jSonString += '{"id": '+(++rowId)+',"ProgId":"'+pm.programId+'","opportunity":"'+om.opportunityName.replaceAll('"','')+'% $'+pm.programAmount+'",';
                jSonString += '{"id": '+(++rowId)+',"ProgId":"'+pm.programId+'","opportunity":"'+oppName+'",';
                jSonString += '"ProgramName":"<a href=/'+pm.programId+' target=_blank>'+pm.programName.replaceAll('"','')+'</a>",';
                jSonString += '"progUrl":"/'+pm.programId+'",';
                //Sending Weighted forecast in case of Proposal, CATS_Externam_Id in case of Contract
                if(stage == 'Proposal'){
                    jSonString += '"WeightedForecast":"'+pm.weightedForecast+'",';
                }else if(stage == 'Contract'){
                    jSonString += '"WeightedForecast":"'+pm.catsExternalId+'",';
                }else{
                    if(pm.oppStage != 'Closed Won')
                        jSonString += '"WeightedForecast":"'+pm.weightedForecast+'",';
                    else if(pm.oppStage == 'Closed Won')
                        jSonString += '"WeightedForecast":"'+pm.catsExternalId+'",';
                }
                jSonString += '"ProgramAmount":"'+ pm.programAmount +'","Variance":"'+ pm.variance +'", ';
                for(ForecastModel fm : pm.forecastMonths){
                    //Added by Cloud62 06/07/2013 to fix - This was requested by the Italy team to increase readability
                    if(rType == 'Manufacturing Italy'){
                        fm.month = fm.month.subString(6); //do substring work here - change from IT_AP_C#_YYYY to C#_YYYY subString(6)
                    }
                    if(fm.endDate != null && fm.endDate < system.today()){//showing actual amount For past cycles 
                        jSonString += '"'+fm.month+'":"'+fm.actualAmount+'",';
                    }else{ //showing Forecast amount For future cycle
                        jSonString += '"'+fm.month+'":"'+fm.forecastAmount+'",';
                    }
                }
                jSonString = jSonString.subString(0,jSonString.length()-1);
                jSonString += '},';
            }
        }
        
        jSonString = jSonString.subString(0,jSonString.length()-1);
        jSonString += ']';
    }
    
    public class OpportunityModel{
        public String oppId{get;set;}
        public String opportunityName{get;set;}
        public List<ProgramModel> programList{get;set;}
        public OpportunityModel(){
            programList = new List<ProgramModel>();
        }
    }
    public class ProgramModel{
        public String programId{get;set;}
        public String programName{get;set;}
        public decimal weightedForecast{get;set;}
        public decimal programAmount{get;set;}
        public string catsExternalId{get;set;} 
        public decimal variance{get;set;}
        public string oppStage;
        public List<ForecastModel> forecastMonths{get;set;}
        public ProgramModel(){
            forecastMonths = new List<ForecastModel>();
            weightedForecast = 0;
            catsExternalId = 'None';
            programAmount = 0;
            variance = 0;
        }
    }
    public class ForecastModel{
        public String month{get;set;}
        public decimal forecastAmount{get;set;}
        public decimal actualAmount{get;set;}
        public date startDate;
        public date endDate;
        public ForecastModel(String mnth){
            month = mnth;
            forecastAmount = 0;
            actualAmount = 0;
        }
        public ForecastModel(){}
    }
}