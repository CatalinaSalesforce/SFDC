/*2012-12-20 - Edit by Anjana - Changed brands to be a single drop down(Brand__c) instead of multi picklist(Brands_List__c).*/
@isTest
public class TestExecutiveSummaryController{
     static testMethod void TestExecutiveSummaryController(){
        
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
         
         RecordType retailRT = [select Id, Name from RecordType where name = 'Retail' and SobjectType = 'Account'];
         RecordType proposalRT = [select Id, Name from RecordType where name = 'Proposal' and SobjectType = 'Opportunity'];
         RecordType RetailerRT = [select Id, Name from RecordType where name = 'Retailer' and SobjectType = 'Contact'];
         RecordType proposalProgRT = [select Id, Name from RecordType where name = 'Proposal' and SobjectType = 'Program__c'];
         
         Account newCong = new Account(recordType = retailRT, Name = 'New Account Cong');
         insert newCong;
         
         Account newAccount = new Account(recordType = retailRT, Name = 'New Account Test', ParentId = newCong.Id);
         
         insert newAccount;
         
         ApexPages.StandardController ctl = new ApexPages.StandardController(newAccount);
         ApexPages.currentPage().getParameters().put('Id', newAccount.Id);
         ApexPages.currentPage().getParameters().put('sessionId', newAccount.Id);
         ApexPages.currentPage().getParameters().put('serverUrl', newAccount.Id);                
     
         list<Opportunity> OppyList = new list<Opportunity>();
         OppyList.add(New Opportunity(Name = 'Oppy 1', AccountID = newAccount.ID, CloseDate = date.Today().addDays(1), Amount = 1, recordType = proposalRT, Catalina_Business_Unit__c = 'Digital O&O', StageName = 'Idea'));
         OppyList.add(New Opportunity(Name = 'Oppy 2', AccountID = newAccount.ID, CloseDate = date.Today().addDays(1), Amount = 2, recordType = proposalRT, Catalina_Business_Unit__c = 'Digital O&O', StageName = 'Idea'));
         OppyList.add(New Opportunity(Name = 'Oppy 3', AccountID = newAccount.ID, CloseDate = date.Today().addDays(1), Amount = 3, recordType = proposalRT, Catalina_Business_Unit__c = 'Digital O&O', StageName = 'Idea'));
         OppyList.add(New Opportunity(Name = 'Oppy 4', AccountID = newAccount.ID, CloseDate = date.Today().addYears(2), Amount = 1, recordType = proposalRT, Catalina_Business_Unit__c = 'Audience Network', StageName = 'Idea'));
         OppyList.add(New Opportunity(Name = 'Oppy 5', AccountID = newAccount.ID, CloseDate = date.Today().addYears(2), Amount = 2, recordType = proposalRT, Catalina_Business_Unit__c = 'Audience Network', StageName = 'Idea'));
         OppyList.add(New Opportunity(Name = 'Oppy 6', AccountID = newAccount.ID, CloseDate = date.Today().addYears(2), Amount = 3, recordType = proposalRT, Catalina_Business_Unit__c = 'Audience Network', StageName = 'Idea'));   
         
         insert OppyList;
         
         list<CLIENT_REVENUE_SNAPSHOT__C> clientRevList = new list<CLIENT_REVENUE_SNAPSHOT__C>();
         clientRevList.add(new CLIENT_REVENUE_SNAPSHOT__C(CLIENT__C = newCong.Name, QUARTER__C = 'Q12012', Booked__c = 1, SDPY__c = 1, Forecast__c = 2, PY_Finish__c = 2));  
         clientRevList.add(new CLIENT_REVENUE_SNAPSHOT__C(CLIENT__C = newCong.Name, QUARTER__C = 'Q22012', Booked__c = 1, SDPY__c = 1, Forecast__c = 2, PY_Finish__c = 2));
         clientRevList.add(new CLIENT_REVENUE_SNAPSHOT__C(CLIENT__C = newCong.Name, QUARTER__C = 'Q32012', Booked__c = 1, SDPY__c = 1, Forecast__c = 2, PY_Finish__c = 2));
         clientRevList.add(new CLIENT_REVENUE_SNAPSHOT__C(CLIENT__C = newCong.Name, QUARTER__C = 'Q42012', Booked__c = 1, SDPY__c = 1, Forecast__c = 2, PY_Finish__c = 2));       
         
         insert clientRevList;
         
         list<SALES_MANAGER_1_FORECAST__C> managerForecastList = new list<SALES_MANAGER_1_FORECAST__C>();
         managerForecastList.add(new SALES_MANAGER_1_FORECAST__C(Account__c = newAccount.ID, QUARTER__C = 'Q12012', Actual_Amount__c = 1, Team_Actual_Amount_Trg__c = 1));
         managerForecastList.add(new SALES_MANAGER_1_FORECAST__C(Account__c = newAccount.ID, QUARTER__C = 'Q12012', Actual_Amount__c = 1, Team_Actual_Amount_Trg__c = 1));
         managerForecastList.add(new SALES_MANAGER_1_FORECAST__C(Account__c = newAccount.ID, QUARTER__C = 'Q22012', Actual_Amount__c = 1, Team_Actual_Amount_Trg__c = 1));
         managerForecastList.add(new SALES_MANAGER_1_FORECAST__C(Account__c = newAccount.ID, QUARTER__C = 'Q22012', Actual_Amount__c = 1, Team_Actual_Amount_Trg__c = 1));
         managerForecastList.add(new SALES_MANAGER_1_FORECAST__C(Account__c = newAccount.ID, QUARTER__C = 'Q32012', Actual_Amount__c = 1, Team_Actual_Amount_Trg__c = 1));
         managerForecastList.add(new SALES_MANAGER_1_FORECAST__C(Account__c = newAccount.ID, QUARTER__C = 'Q32012', Actual_Amount__c = 1, Team_Actual_Amount_Trg__c = 1));
         managerForecastList.add(new SALES_MANAGER_1_FORECAST__C(Account__c = newAccount.ID, QUARTER__C = 'Q42012', Actual_Amount__c = 1, Team_Actual_Amount_Trg__c = 1));
         managerForecastList.add(new SALES_MANAGER_1_FORECAST__C(Account__c = newAccount.ID, QUARTER__C = 'Q42012', Actual_Amount__c = 1, Team_Actual_Amount_Trg__c = 1));
         
         insert managerForecastList;
         
         Year_Revenue__c yearRev = new Year_Revenue__c(Account__c = newAccount.ID);
         
         insert yearRev;
         
         contact tempContact = new contact(AccountID = newAccount.ID, recordType = RetailerRT, LastName = 'Roobert');
         
         insert tempContact;
         
         Profile pfl = [select id from profile where name='Standard User'];

         User tempUser = new User(alias = 'u1', email='u1@testorg.com',emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',localesidkey='en_US', profileid = pfl.Id,  country='United States', CommunityNickname = 'u1',timezonesidkey='America/Los_Angeles', username='u1@testorg123cat.com');
         
         insert tempUser;
         
         event tempEvent = new event(WhoID = tempContact.ID, OwnerId = tempUser.ID, Subject = 'Subject', StartDateTime = datetime.now(), EndDateTime = datetime.now(), CurrencyIsoCode = 'USD');
         
         insert tempEvent;
         
         Program__c tempProg = new Program__c(recordType = proposalProgRT, Name = 'Program', Opportunity__c = OppyList[0].id, Account_Type__c = 'Retail', CurrencyIsoCode = 'USD', Brand__c = 'Coke Zero');
         
         insert tempProg;
         
         Program_Amount__c tempProgAmount = new Program_Amount__c(Program__c = tempProg.ID, CurrencyIsoCode = 'USD', QUARTER__C = 'Q42012', ACTUAL_AMOUNT__C = 1);
         
         insert tempProgAmount;
         
         Account_Brand_Revenue__c tempBrandRev = new Account_Brand_Revenue__c(account__c = newAccount.id, BRAND__C = 'Coke Zero', CURRENT_YEAR__C = 1.0, YEAR_M_1__C = 1.0, YEAR_M_2__C = 1.0, YEAR_M_3__C = 1.0, YEAR_M_4__C = 1.0, YEAR_P_1__C = 1.0);
         
         insert tempBrandRev;
         
         PageReference pageRef = Page.executiveSummary;
        Test.setCurrentPage(pageRef);
        Test.startTest();
        ApexPages.StandardController ctl1 = new ApexPages.StandardController(newCong);
        ApexPages.currentPage().getParameters().put('Id', newCong.Id);
        executiveSummaryController esc = new executiveSummaryController();
        esc.populateOpportunities();
        Test.stopTest();
         
     }
}