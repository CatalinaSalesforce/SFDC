/*
@Name            : OppDistributeAmtButton
@Author          : matt@cloud62.com
@Date            : July 3 2013
@Description     : Class for the distribute amounts button on Opportunity page
@Revision History:

*/
public with sharing class OppDistributeAmtButton{
	final static Integer DEFAULT_ACTIVE_DELAY = 2;
	final static String FORECAST_SETTING_NAME = 'Default';
	final static String EUR = 'EUR';
    //Variables
    public Opportunity oppIn {get;set;}
	public String response {get;set;}
	public Boolean forecastReplaceCheckResult {get; set;}
	public Boolean nullAdPeriod {get; set;}
	public Boolean nullAmountCheckResult{get; set;}
	Map<Id,Ad_Period__c> adPeriodsMap;
    //Constructor
    public OppDistributeAmtButton(ApexPages.StandardController sc){
      //progIn = sc.getRecord();

        oppIn = [select Id, Name, Amount, Start_Cycle__c, End_Cycle__c, Start_Date__c, End_Date__c
                    FROM Opportunity WHERE Id = :sc.getId()];
            
    }
    public void nullAmountCheck(){
    	if(oppIn.Amount == null){
    		nullAmountCheckResult = true;
    	} else {
    		nullAmountCheckResult = false;
    	}
    }
    
    public void forecastReplaceCheck(){ //determines if the javascript confirm box will be displayed or not. i.e. is there a possibility that any program forecasts will be modified?
    	List<Program_Forecast__c> programForecastList = new List<Program_Forecast__c>([select Id, Start_Date__c, End_Date__c,
    								Program__c, Ad_Period__c, Name, Active__c,
    								Next_Quarter_Amount__c, Previous_Quarter_Amount__c from Program_Forecast__c where Program__r.Opportunity__c =: oppIn.Id]);
		nullCycleCheck();
		nullAmountCheck();
    	if(programForecastList.size() > 0 ){
    		//will have to change some program values so set boolean
    		forecastReplaceCheckResult= true;
    	} else {
    		forecastReplaceCheckResult = false;
    	}

    }

    public void nullCycleCheck(){//checks and prevents the button from running if there are null ad periods
    	if(oppIn == null){
	    	nullAdPeriod = true;
	    } else {
	 		if(oppIn == null || oppIn.Start_Cycle__c == null || oppIn.End_Cycle__c == null ){
	    		nullAdPeriod = true;
	    	} else {
	    		nullAdPeriod = false;
	    	}
    	}

    }


    public PageReference distributeAmounts(){
    	List<Program__c> progList = [SELECT Id, Name, RecordTypeId, CurrencyISOCode,
                    Account_Type__c, Actual_Amount__c,
                    Contract_Commitment_Type__c, Delivery_Type__c, Description__c, End_Cycle__c, End_Date__c, External_ID__c,
                    Forecast_Amount__c, Incentive_Kicker__c, Initiative__c, Number_of_Offers__c,
                    Opportunity__c, Oppty_Probability__c, Owner__c, Product_Type__c, Program_Amount__c,
                    Start_Cycle__c,  Start_Date__c, Status__c, Total_Amount__c, Unique_ID__c, Variance__c, Weighted_Forecast_Amount__c,
                    Start_Cycle__r.Start_Date__c, End_Cycle__r.End_Date__c FROM PROGRAM__C WHERE OPPORTUNITY__C =: oppIn.Id];
    	for (Program__c progIn : progList) {
	    	//calculate time between two dates  / ad periods.
	    	Date startDate;
	    	Date endDate;
	    	Set<Ad_Period__c> adPeriodsSet;
	    	List<Ad_Period__c> adPeriodList = new List<Ad_Period__c>(); //list of adPeriods to make programs for
	    	List<Ad_Period__c> manuAdPeriods;
	    	List<Program_Forecast__c> programForecastList = new List<Program_Forecast__c>();
	    	List<Program_Forecast__c> insertForecastList = new List<Program_Forecast__c>(); // list of program forecasts to insert i.e. the ones that are not found
	    	List<Program_Forecast__c> updateForecastList = new List<Program_Forecast__c>(); //list of forecasts to update
	    	List<Ad_Period__c> workingAdPeriodList = new List<Ad_Period__c>(); //list of adperiods that are within the specified range
	    	adPeriodsSet = new Set<Ad_Period__c>([Select Id, Start_Date__c, End_Date__c, Type__c, Is_Split__c, Name from Ad_Period__c]);
	    	manuAdPeriods = new List<Ad_Period__c>([Select Id, Start_Date__c, End_Date__c, Type__c, Is_Split__c, Days_In_Cycle__c,
	    			Name from Ad_Period__c where Type__c =: progIn.Account_Type__c order by Start_Date__c asc]);
	    	List<Ad_Period__c> retailAdPeriods = new List<Ad_Period__c>([Select Id, Start_Date__c, End_Date__c, Type__c, Days_In_Cycle__c,
	    			 Is_Split__c, Name from Ad_Period__c where Type__c = 'Retail' order by Start_Date__c asc]);
	    	adPeriodsMap = new Map<Id,Ad_Period__c>();
	
	    	for(Ad_Period__c ap : adPeriodsSet){
	    		adPeriodsMap.put(ap.Id, ap);
	    	}
	    	
	    	Integer activeDelay = DEFAULT_ACTIVE_DELAY;
	      	//assign the custom setting provided value if it exists
	        Catalina_Forecast_Settings__c setting = Catalina_Forecast_Settings__c.getInstance(FORECAST_SETTING_NAME);
	        if(!(setting == null)){
	            if(!(setting.Forecast_to_Actual_Transition__c == null)){
	                activeDelay = (Integer)setting.Forecast_to_Actual_Transition__c;
	            }
	        }
	
	    	if(progIn.Program_Amount__c == null)
	    		progIn.Program_Amount__c = 0;
	    	//get forecasts that go with this program
	
	    	programForecastList = new List<Program_Forecast__c>([select Id, Start_Date__c, End_Date__c, Active__c,
	    			Next_Quarter_Amount__c, Previous_Quarter_Amount__c, Program__c, Ad_Period__c, Name, Forecast_Amount__c from Program_Forecast__c where Program__c =: progIn.Id]);
	    	system.debug(programForecastList.size() + ' forecasts exist');
	    	// forecast that will be inserted/
	    	//response ='<br> Start Date: '+ progIn.Start_Date__c + '   End Date: ' + progIn.End_Date__c+'<br><br>Start Cycle: '
	    	//	+ adPeriodsMap.get(progIn.Start_Cycle__c) + '<br>End Cycle: '+ adPeriodsMap.get(progIn.End_Cycle__c)+'<br><br><br><br>';
	    	/*
	    	startDate = progIn.Start_Date__c;
	    	endDate = progIn.End_Date__c;
	    	Replaced so the button will function off of cycles, rather than dates..
	    	*/
	
	    	 if(progIn.Start_Cycle__c == null || progIn.End_Cycle__c == null){
				PageReference pageRef = new PageReference('/' + ApexPages.currentPage().getParameters().get('id'));
	       		pageRef.setRedirect(true);
	       		return pageRef;
		    } else {
		    	startDate = adPeriodsMap.get(progIn.Start_Cycle__c).Start_Date__c;
	
	
		    	system.debug('using start date '+startDate);
		    	endDate = adPeriodsMap.get(progIn.End_Cycle__c).End_Date__c;
				system.debug('using end date '+endDate);
		    	Integer cyclesBetween;
		    	Integer tempIndex = 0;
		       	Boolean found;
	
		    	//cyclesBetween = progIn.Start_Date__c.monthsBetween(progIn.End_Date__c);//for finding out how many programs to create
		    	cyclesBetween = startDate.monthsBetween(endDate);
		    	if(progIn.Start_Cycle__c == progIn.End_Cycle__c && progIn.Account_Type__c == 'Manufacturing'){
	
		    	} else {
		    		cyclesBetween++; //trying to add one to cyclesBetween to fix.
		    	}
		    	
		    	Integer activeCycles = 0;
		    	for (Ad_Period__c ap : retailAdPeriods){
		    		if (ap.Start_Date__c >= progIn.Start_Cycle__r.Start_Date__c
		    		&& ap.End_Date__c <= progIn.End_Cycle__r.End_Date__c
			    	&& ap.End_Date__c + activeDelay > Date.today())
			    	{
			    		activeCycles++;
			    	}
		    	}
		    	
		    	system.debug(cyclesBetween+ ' cycles between' + startDate +'  &  ' + EndDate);
		    	//this method wlil work for retail dates because all cycles have the same start date. the add month
		    	//part messes it up for manufacturing cycles though.
		    	if(progIn.Account_Type__c == 'Retail'){
			    	for(Integer i = 0; i < cyclesBetween; i++){
			    		for(Ad_Period__c ap : adPeriodsSet){// find ad periods that are within the start & end dates
			       			if(ap.Type__c == progIn.Account_Type__c && ap.Start_Date__c <= startDate && startDate <= ap.End_Date__c ){
			       				adPeriodList.add(ap);//add these ad periods to a list that we will use later
			       				//response+= ' ' + i+ap + '<br>';
			       			}
			    		}
			    		startDate = startDate.addMonths(1); //add a month to start date and continue;
			    	}
			    	//response += cyclesBetween + ' cycles between '+ progIn.Start_Date__c + ',' + progIn.End_Date__c+'\n';
			    	//get forecasts associated with this program.
			    	for(Ad_Period__C ap : adPeriodList){// find which forecasts match up with ad period range and which ones do not exist
			    		////response += ap.Name + '<br>';
			    		system.debug(adPeriodList.size() + ' d period list size');
			    		found = false;
		    			for(Program_Forecast__c pf : programForecastList){
		    				if(pf.Ad_Period__C == ap.Id){
		    					//response += '<br>found forecast in list for ' + ap.Name;
		    					//found a forecast for the corresponding ad period
		    					found = true;
		    					//Warren Jan 15th 2013, add code to only change active Program Forecasts
		    					if (pf.Active__c == true){
		    						Double tempAmt = 0;
		    						if (activeCycles != 0){
		    							tempAmt = (progIn.Program_Amount__c - progIn.Actual_Amount__c) / activeCycles;
		    						}
			    					if(pf.Forecast_Amount__c == tempAmt){
			    						//ForecastAmount already = divided program amount so don't do anything.
			    					} else {
			    						pf.Forecast_Amount__c = tempAmt; // set forecast actuals to correct value;
			    						updateForecastList.add(pf);			//should be forecast_amount_c
			    					}
		    					}
		    					break;
		    				}
		    			}
		    			if(!found){
		    					//response += '<br> will need to create a forecast for ' + ap.Name;
		    					//create a new programforecast and add to list
		    					insertForecastList.add(createProgramForecast(progIn, ap, activeCycles));
		    			}
			    	}
		    	} else {
		    		//things to do if type = manufacturing - workaround for strange start dates in manufacturing
		       		for(Ad_Period__c ap : manuAdPeriods){
		       			if(ap.Start_Date__c <= startDate && startDate <= ap.End_Date__c ){
		       				//response += ' found StartDate @ Index: ' + tempIndex+'<br>';
		       				break;
		       			}
		       			tempIndex++;
		       		}
		       		/*
		    		for(Integer i = 0; i < cyclesBetween; i++){
		    			system.debug('tempIndex: '+ tempIndex + '   cyclesBetween: ' + cyclesBetween + ' i: ' + i + 'manuAdPeriods.size='+manuAdPeriods.size());
		    			//response+= manuAdPeriods.get(tempIndex+i)+'<br>';
		    			try{ // workaround fix for testclass issues of not having a list of adperiods that is exactly like real list of adperiods
		    				manuAdPeriods.get(tempIndex+i);
		    			} catch(Exception e){
		    				tempIndex--;
		    			} finally {
		    				workingAdPeriodList.add(manuAdPeriods.get(tempIndex+i));
	
		    			}
		    		}
		    		*/
		    		Integer i = 0;
		    		activeCycles = 0;
		    		Boolean finish = false;
		    		while (!finish){
		    			if (manuAdPeriods.size() > tempIndex + i){
			    			Ad_Period__c ap = manuAdPeriods.get(tempIndex + i);
			    			if (ap.Start_Date__c <= endDate && startDate <= ap.End_Date__c){
				    			workingAdPeriodList.add(ap);
				    			i++;
				    			if (ap.End_Date__c + activeDelay > Date.today()) activeCycles++;
			    			} else {
			    				finish = true;
			    			}
		    			} else {
		    				finish = true;
		    			}
		    		}
		    		//response+='<br> workingAdPeriodList size: '+workingAdPeriodList.size();
		    		for(Ad_Period__c ap : workingAdPeriodList){ //see if there is at least a forecast for every adperiod within the range
		    			system.debug(workingAdPeriodList.size() + ' working ad period list size');
		    			found = false;
		    			for(Program_Forecast__c pf : programForecastList){
		    				if(pf.Ad_Period__C == ap.Id){
		    					//response += '<br>found forecast in list for ' + ap.Name;
		    					found = true;
		    					//Warren Jan 7 2012, removing if statement so that PFs are always updated
		    					//if(pf.Forecast_Amount__c == progIn.Program_Amount__c / i){
		    						//ForecastAmount already = divided program amount so don't do anything.
		    					//} else {
		    					//Warren Jan 15th 2013, add code to only change active Program Forecasts
		    					if (pf.Active__c == true){
		    						if (activeCycles != 0){
		    							pf.Forecast_Amount__c = (progIn.Program_Amount__c - progIn.Actual_Amount__c) / activeCycles; // set forecast actuals to correct value;
		    						} else {
		    							pf.Forecast_Amount__c = 0;
		    						}
		    						if (ap.Is_Split__c == 'true'){
			    						Double nextRatio = Double.valueOf((Double)ap.End_Date__c.day()/28.0);
							    		Double prevRatio = 1 - nextRatio;
							    		pf.Next_Quarter_Amount__c = pf.Forecast_Amount__c * nextRatio;
							    		pf.Previous_Quarter_Amount__c = pf.Forecast_Amount__c * prevRatio;
		    						}
		    						updateForecastList.add(pf);
		    					}
		    					//}
		    					break;
		    				}
		    			}
		    			if(!found){
		    					//response += '<br> will need to create a forecast for ' + ap.Name;
		    					//create a new programforecast
		    					insertForecastList.add(createProgramForecast(progIn, ap, i));
		    			}
		    		}
		    	}
		    	//system.debug(//response);
		    	//response+='<br>' + programForecastList.size() + ' program forecasts found';
		    	insert insertForecastList;
		    	update updateForecastList;
		    	//response += '<br><br><br>Forecasts Inserted: ' + insertForecastList.size() + '<br>' + 'Forecasts Updated: ' + updateForecastList.size();
		    	
	    	}
    	}
    	PageReference pageRef = new PageReference('/' + ApexPages.currentPage().getParameters().get('id'));
        pageRef.setRedirect(true);
        return pageRef;
    }
    public static Program_Forecast__c createProgramForecast(Program__c progC, Ad_Period__c adPeriodC, Integer cyclesBetweenC ){
		Program_Forecast__c insertProgramForecast = new Program_Forecast__c();
    	insertProgramForecast.Ad_Period__c = adPeriodC.Id;
    	insertProgramForecast.Start_Date__c = adPeriodC.Start_Date__c;
    	insertProgramForecast.End_Date__c = adPeriodC.End_Date__c;
    	insertProgramForecast.Program__c = progC.Id;
    	insertProgramForecast.CurrencyIsoCode = progC.CurrencyISOCode;
    	Double tempAmt = 0;
    	if (cyclesBetweenC != 0){
    		tempAmt = (progC.Program_Amount__c - progC.Actual_Amount__c) / cyclesBetweenC;
    	}
    	insertProgramForecast.Forecast_Amount__c = tempAmt; // compute forecast amount based on program actual amt
    	//added by Warren Jan 15 2013
    	Integer activeDelay = DEFAULT_ACTIVE_DELAY;
      	//assign the custom setting provided value if it exists
        Catalina_Forecast_Settings__c setting = Catalina_Forecast_Settings__c.getInstance(FORECAST_SETTING_NAME);
        if(!(setting == null)){
            if(!(setting.Forecast_to_Actual_Transition__c == null)){
                activeDelay = (Integer)setting.Forecast_to_Actual_Transition__c;
            }
        }
    	if (adPeriodC.End_Date__c + activeDelay <= Date.Today()){
    		insertProgramForecast.Active__c = false;
    		insertProgramForecast.Forecast_Amount__c = 0;
    	} else {
    		insertProgramForecast.Active__c = true;
    	}
    	//added by Warren Jan 7, 2013 to automatically populate splits
    	if (adPeriodC.Is_Split__c == 'true'){
    		Double nextRatio = Double.valueOf((Double)adPeriodC.End_Date__c.day()/(adPeriodC.Days_In_Cycle__c == null? 0 : adPeriodC.Days_In_Cycle__c));
    		Double prevRatio = 1 - nextRatio;
    		insertProgramForecast.Next_Quarter_Amount__c = insertProgramForecast.Forecast_Amount__c * nextRatio;
    		insertProgramForecast.Previous_Quarter_Amount__c = insertProgramForecast.Forecast_Amount__c * prevRatio;
    	}
    	
    	return insertProgramForecast;
    }

    public PageReference returnToProgram(){ // returns to program if cancel is clicked
    	PageReference pageRef = new PageReference('/' + ApexPages.currentPage().getParameters().get('id'));
        pageRef.setRedirect(true);
        return pageRef;
    }


}