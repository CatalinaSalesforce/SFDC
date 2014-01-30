/*
@Name            : ExecutiveSummaryController
@Author          : customersuccess@cloud62.com
@Date            : December 24th, 2012
@Description     : Controller to gather account information for conga merge
*/
Public Class ExecutiveSummaryController
{
    //variables
    public account currAccount{get;set;}
    public String sessionID;
    public String serverURL;
    public String accountID;
    public List<Contact> lstContacts{get;set;}
    public document orgChartDoc{get;set;}
    //default constructor
    Public ExecutiveSummaryController(){
        //get variables from the URL
        accountID = ApexPages.currentPage().getParameters().get('Id');
        sessionID = ApexPages.currentPage().getParameters().get('sessionId');
        serverURL = ApexPages.currentPage().getParameters().get('serverUrl');
        
        currAccount = [SELECT id, Name, parentID,
                              Long_Term_Opportunity_1__c, Long_Term_Opportunity_2__c, Long_Term_Opportunity_3__c, 
                              Short_Term_Opportunity_1__c, Short_Term_Opportunity_2__c, Short_Term_Opportunity_3__c, 
                              OnO_Opportunity_1__c, OnO_Opportunity_2__c, OnO_Opportunity_3__c,
                              Buver_Opportunity_1__c, Buver_Opportunity_2__c, Buver_Opportunity_3__c,
                              Q1_Booked__c, Q1_Forecast__c, Q1_Finish__c, Q1_SDPY__c,
                              Q2_Booked__c, Q2_Forecast__c, Q2_Finish__c, Q2_SDPY__c,
                              Q3_Booked__c, Q3_Forecast__c, Q3_Finish__c, Q3_SDPY__c,
                              Q4_Booked__c, Q4_Forecast__c, Q4_Finish__c, Q4_SDPY__c, Idea3__r.Contact__r.FirstName,
                              Idea3__r.Contact__r.LastName, Idea3__r.Contact__c, Idea3__c
                              //Year_Revenue__c, Year_1_Revenue__c, Year_2_Revenue__c, Year_3_Revenue__c, Year_4_Revenue__c
                       FROM Account 
                       WHERE id =: accountID];        
    }
    //main logic that links to a page, this page is only for updating values
    Public PageReference populateOpportunities(){ 
        //variables
        List<account> ChildAccounts = [SELECT ID FROM Account WHERE ParentID =: currAccount.ID];
        List<ID> ChildIDs = new List<ID>();
        //get the top three long term and the top three short term Opportunities for the current Account based on Amount
        if(ChildAccounts.Size() > 0){
            for(Account a : ChildAccounts){            
                ChildIDs.add(a.ID);            
            }            
            Opportunity FirstLongTermOpp = new Opportunity(amount = 0);
            Opportunity SecondLongTermOpp = new Opportunity(amount = 0);
            Opportunity ThirdLongTermOpp = new Opportunity(amount = 0);
            Opportunity FirstShortTermOpp = new Opportunity(amount = 0);
            Opportunity SecondShortTermOpp = new Opportunity(amount = 0);
            Opportunity ThirdShortTermOpp = new Opportunity(amount = 0);
            
            List<Opportunity> longTermOppList = [SELECT ID, CloseDate, Amount 
                                                 FROM Opportunity 
                                                 WHERE AccountID in: ChildIDs 
                                                 AND CloseDate >: Date.today()];
           
            if(longTermOppList.Size() > 0){
                for(Opportunity o : longTermOppList){             
                    if(o.CloseDate > Date.Today().addYears(1)){                   
                        if(o.amount > FirstLongTermOpp.amount){
                            ThirdLongTermOpp = SecondLongTermOpp;
                            SecondLongTermOpp = FirstLongTermOpp; 
                            FirstLongTermOpp = o;                                                             
                        }
                        else if(o.amount > SecondLongTermOpp.amount){
                            ThirdLongTermOpp = SecondLongTermOpp;
                            SecondLongTermOpp = o;                            
                        }
                        else if(o.amount > ThirdLongTermOpp.amount){
                            ThirdLongTermOpp = o;
                        }
                    
                    }
                    else{                    
                        if(o.amount > FirstShortTermOpp.amount){
                            ThirdShortTermOpp = SecondShortTermOpp;
                            SecondShortTermOpp = FirstShortTermOpp;
                            FirstShortTermOpp = o;                                       
                        }
                        else if(o.amount > SecondShortTermOpp.amount){
                            ThirdShortTermOpp = SecondShortTermOpp;
                            SecondShortTermOpp = o;
                        }
                        else if(o.amount > ThirdShortTermOpp.amount){
                            ThirdShortTermOpp = o;
                        }
                    
                    }
                
                }
                //get the top three Digital and Audiance Network Opportunities that belong to the current Account that closed dates are in the future and do nto ahve amounts of 0
                List<Opportunity> OnOTop3 = [SELECT ID 
                                             FROM Opportunity 
                                             WHERE closeDate >: Date.Today() 
                                             AND Catalina_Business_Unit__c includes ('Digital O&O')
                                             AND AccountID in: ChildIDs 
                                             ORDER BY closeDate ASC 
                                             LIMIT 3];
                List<Opportunity> BuverTop3 = [SELECT ID 
                                               FROM Opportunity 
                                               WHERE closeDate >: Date.Today() 
                                               AND Catalina_Business_Unit__c includes ('Audience Network') 
                                               AND AccountID in: ChildIDs
                                               ORDER BY closeDate ASC 
                                               LIMIT 3];
                
                if(FirstLongTermOpp.amount != 0){
                currAccount.Long_Term_Opportunity_1__c = FirstLongTermOpp.ID;
                }                
                if(SecondLongTermOpp.amount != 0){
                currAccount.Long_Term_Opportunity_2__c = SecondLongTermOpp.ID;
                }
                if(ThirdLongTermOpp.amount != 0){
                currAccount.Long_Term_Opportunity_3__c = ThirdLongTermOpp.ID;
                }
                if(FirstShortTermOpp.amount != 0){
                currAccount.Short_Term_Opportunity_1__c = FirstShortTermOpp.ID;
                }
                if(SecondShortTermOpp.amount != 0){
                currAccount.Short_Term_Opportunity_2__c = SecondShortTermOpp.ID;
                }
                if(ThirdShortTermOpp.amount != 0){
                currAccount.Short_Term_Opportunity_3__c = ThirdShortTermOpp.ID;
                }                
                if(OnOTop3.size() >= 1){          
                    currAccount.OnO_Opportunity_1__c = OnOTop3[0].ID;
                }
                if(OnOTop3.size() >= 2){
                currAccount.OnO_Opportunity_2__c = OnOTop3[1].ID;
                }
                if(OnOTop3.size() >= 3){
                currAccount.OnO_Opportunity_3__c = OnOTop3[2].ID;
                }
                if(BuverTop3.size() >= 1){
                currAccount.Buver_Opportunity_1__c = BuverTop3[0].ID;
                }
                if(BuverTop3.size() >= 2){
                currAccount.Buver_Opportunity_2__c = BuverTop3[1].ID;
                }
                if(BuverTop3.size() >= 3){
                currAccount.Buver_Opportunity_3__c = BuverTop3[2].ID;
                }
                                           
                
            }
            
        }
                               
        List<CLIENT_REVENUE_SNAPSHOT__C> crs = [SELECT ID, CLIENT__C, QUARTER__C, Booked__c, SDPY__c, Forecast__c, PY_Finish__c  
                                                FROM CLIENT_REVENUE_SNAPSHOT__C 
                                                WHERE CLIENT__C =: currAccount.Name 
                                                AND createddate >=: Date.Today() 
                                                ORDER BY createddate desc 
                                                LIMIT 4];               
        
        //Variables to hold account total values
        decimal totalBooked = 0.0;
        decimal totalForecast = 0.0;
        decimal totalSDPY = 0.0;
        decimal totalFinish = 0.0;
        //for all of the revenue snap shot add up the values by quarter
        if(crs.size() > 0){      
            for(CLIENT_REVENUE_SNAPSHOT__C c : crs){           
                if(c.Quarter__c.contains('Q1')){
                    currAccount.Q1_Booked__c = getFormattedCurrency(String.valueOf(c.Booked__c));
                    currAccount.Q1_Forecast__c = getFormattedCurrency(String.valueOf(c.Forecast__c));
                    currAccount.Q1_SDPY__c = getFormattedCurrency(String.valueOf(c.SDPY__c));
                    currAccount.Q1_Finish__c = getFormattedCurrency(String.valueOf(c.PY_Finish__c));
                }
                else if(c.Quarter__c.contains('Q2')){
                    currAccount.Q2_Booked__c = getFormattedCurrency(String.valueOf(c.Booked__c));
                    currAccount.Q2_Forecast__c = getFormattedCurrency(String.valueOf(c.Forecast__c));
                    currAccount.Q2_SDPY__c = getFormattedCurrency(String.valueOf(c.SDPY__c));
                    currAccount.Q2_Finish__c = getFormattedCurrency(String.valueOf(c.PY_Finish__c));
                }
                else if(c.Quarter__c.contains('Q3')){
                    currAccount.Q3_Booked__c = getFormattedCurrency(String.valueOf(c.Booked__c));
                    currAccount.Q3_Forecast__c = getFormattedCurrency(String.valueOf(c.Forecast__c));
                    currAccount.Q3_SDPY__c = getFormattedCurrency(String.valueOf(c.SDPY__c));
                    currAccount.Q3_Finish__c = getFormattedCurrency(String.valueOf(c.PY_Finish__c));
                }
                else if(c.Quarter__c.contains('Q4')){
                    currAccount.Q4_Booked__c = getFormattedCurrency(String.valueOf(c.Booked__c));
                    currAccount.Q4_Forecast__c = getFormattedCurrency(String.valueOf(c.Forecast__c));
                    currAccount.Q4_SDPY__c = getFormattedCurrency(String.valueOf(c.SDPY__c));
                    currAccount.Q4_Finish__c = getFormattedCurrency(String.valueOf(c.PY_Finish__c));
                }                
                totalBooked += c.Booked__c;
                totalForecast += c.Forecast__c;
                totalSDPY += c.SDPY__c;
                totalFinish += c.PY_Finish__c;
            }
            currAccount.Total_Booked__c = getFormattedCurrency(String.valueOf(totalBooked));
            currAccount.Total_Finish__c = getFormattedCurrency(String.valueOf(totalFinish));
            currAccount.Total_Forecast__c = getFormattedCurrency(String.valueOf(totalForecast));
            currAccount.Total_SDPY__c = getFormattedCurrency(String.valueOf(totalSDPY));
        }       
        Integer Year = Date.Today().Year();
        //get the total booked amount from the sales manager best guess for this account divided by quarter        
        List<AggregateResult> revenueList = [SELECT QUARTER__C Quarter, SUM(TOTAL_BOOKED_AMOUNT__C) Revenue 
                                             FROM SALES_MANAGER_1_FORECAST__C 
                                             WHERE CONGLOMERATE__C =: currAccount.Name 
                                             GROUP BY QUARTER__C 
                                             ORDER BY QUARTER__C];
        List<Year_Revenue__c> oldRev = [SELECT ID 
                                        FROM Year_Revenue__c 
                                        WHERE Account__c =: currAccount.ID];       
        //currAccount.Year_Revenue__c = 0;
        //currAccount.Year_1_Revenue__c = 0;
        //currAccount.Year_2_Revenue__c = 0;
        //currAccount.Year_3_Revenue__c = 0;
        //currAccount.Year_4_Revenue__c = 0;
        //make Year revenues for the accoutn based on the sales manager best guess booked amount
        List<Year_Revenue__c> yrs = new List<Year_Revenue__c>();
        Map<String, Year_Revenue__c> revMap = new Map<String, Year_Revenue__c>();        
        for(AggregateResult ar : revenueList){
            if(!revMap.ContainsKey(String.ValueOf(ar.get('Quarter')).Substring(2,6))){
                revMap.put(String.ValueOf(ar.get('Quarter')).Substring(2,6), new Year_Revenue__c());
                revMap.get(String.ValueOf(ar.get('Quarter')).Substring(2,6)).Year__c = String.ValueOf(ar.get('Quarter')).Substring(2,6);
                revMap.get(String.ValueOf(ar.get('Quarter')).Substring(2,6)).Account__c = currAccount.ID;
                revMap.get(String.ValueOf(ar.get('Quarter')).Substring(2,6)).Amount__c = Decimal.ValueOf(String.ValueOf(ar.get('Revenue')));
                yrs.add(revMap.get(String.ValueOf(ar.get('Quarter')).Substring(2,6)));
            }
            else{       
                revMap.get(String.ValueOf(ar.get('Quarter')).Substring(2,6)).Amount__c += Decimal.ValueOf(String.ValueOf(ar.get('Revenue'))); 
            }
        }
        //delete the old Year revenues and add the new ones
        delete oldRev;
        insert yrs;
        //update the account with new values for conga merge
        if (currAccount.Idea3__c != null){
        	if (currAccount.Idea3__r.Contact__c != null){
        		currAccount.Idea3_Contact__c = currAccount.Idea3__r.Contact__r.FirstName + ' ' + currAccount.Idea3__r.Contact__r.LastName;		
        	}
        }
        update(currAccount);
        //call a calss to set the brand revenues of the current Account
        AccountCalculations.getBrandRevenue(currAccount.ID);
        // get the current contacts on the account
        Set<ID> ContactIds = new SET<ID>();
        lstContacts = [SELECT Id, Number_Of_Meetings__c, Title, Name, reportsTo.Name 
                       FROM contact 
                       WHERE accountID in: ChildIDs 
                       OR accountID =: currAccount.ID];
        Map<ID, Contact> contactMap = new Map<ID, Contact>();
        for(Contact c : lstContacts){
            ContactIds.add(c.id);           
            c.Number_Of_Meetings__c = 0;
            contactMap.put(c.id, c);    
        }
        //get all of the events for the 
        List<Event> childEvents = [SELECT ID, WhoID 
                                   FROM Event 
                                   WHERE WhoID in: ContactIds];
        // set the number of meetings for the each contact
        for(Event e : childEvents){
            if(contactMap.containsKey(e.whoID)){       
                contactMap.get(e.whoID).Number_Of_Meetings__c += 1;
            }
        }       
        update(lstContacts);
        //get custom setting IDs
        Account_Plan__c customSetting = Account_Plan__c.getInstance('Default');
        String contactSetId = '';
        if (customSetting != null) contactSetId = customSetting.Contact_Set__c;
        String brandSetId = '';
        if (customSetting != null) brandSetId = customSetting.Brand_Set__c;
        String yearSetId = '';
        if (customSetting != null) yearSetId = customSetting.Year_Set__c;
        //link the page to conga merge
        PageReference pageRef = new PageReference('https://www.appextremes.com/apps/Conga/Composer.aspx'
            + '?sessionId=' + sessionID
            + '&serverUrl=' + serverURL
            + '&id=' + accountID
            //+ '&ReportID=00OZ0000000JdSz?pv0=' + currAccount.Name
            + '&QueryId=' //a1uZ00000003ZfF?pv0='  + accountID + ','
            + '[ContactSet]' + contactSetId + '?pv0='  + accountID + ','
            + '[BrandSet]' + brandSetId + '?pv0='  + accountID + ','
            + '[YearSet]' + yearSetId + '?pv0=' + accountID);
            
        pageRef.setRedirect(true);
        return pageRef;
        
    }
    //method to return string of formatted currency with no decimals
    private String getFormattedCurrency(String x){
        if (x.contains('.')){
            x = x.substring(0, x.indexOf('.'));
        }
        return '$' + parseNumbers(x);
        
    }
    //method to all but the last three cahracters in a a string 
    private String parseNumbers(String x){
        if (x.length() > 3){
            return parseNumbers(x.substring(0, x.length() - 3)) + ',' + x.substring(x.length() - 3);
        } else {
            return x;
        }
    }

}