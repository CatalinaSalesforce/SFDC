/*
This test had way to much going on with trigger being called so it was set to API to 23 to be able to use opportunities that are already created to test the trigger
Robert
*/

@isTest
private class TestUpdateProgramsToMaster
{

     static testMethod void myUnitTest()
     {
        
        List<Opportunity> childOpportunityList = [select id, StageName, Parent_Contract__r.id, Catalina_Business_Unit__c, Parent_Contract__r.Catalina_Business_Unit__c from Opportunity where Type = 'Addendum' and StageName != 'Closed Won Addendum'];       
        List<Program_Forecast__c> allChildForecastList = [select id, Program__r.Opportunity__r.id from Program_Forecast__c where Program__r.Opportunity__c in: childOpportunityList];
        
        Set<ID> childOpportunitySet = new set<ID>();
        
        for(Program_Forecast__c p : allChildForecastList)
        {
            if(childOpportunitySet.contains(p.Program__r.Opportunity__r.id))
            {
                childOpportunitySet.add(p.Program__r.Opportunity__r.id);
            }           
        }
        
        if(allChildForecastList.size() != 0 && childOpportunitySet.size() != null)
        {           
            Opportunity childOpportunity = null;    
            for(Opportunity o : childOpportunityList)
            {            
                if(o.Catalina_Business_Unit__c != o.Parent_Contract__r.Catalina_Business_Unit__c && childOpportunitySet.contains(o.id))
                {                
                    childOpportunity = o;                                        
                    break;                                       
                }            
            }  
            if(childOpportunity != null)
            {                   
                childOpportunity.StageName = 'Closed Won Addendum';
                
                update childOpportunity;
                
                List<Program_Forecast__c> childForecasts = [select program__r.Delivery_type__c, AD_Period__c from Program_Forecast__c where Program__r.Opportunity__r.id =: childOpportunity.id];  
                List<Program_Forecast__c> parentForecasts = [select program__r.Delivery_type__c, AD_Period__c from Program_Forecast__c where Program__r.Opportunity__r.id =: childOpportunity.Parent_Contract__r.id];                                           
                
                System.debug('cpf Size: ' + childForecasts.Size());
                System.debug('ppf Size: ' + parentForecasts.Size());
                
                boolean error;
                for(program_Forecast__c cpf : childForecasts)
                {
                    error = true;
                    for(program_Forecast__c ppf : parentForecasts)
                    {
                        System.debug('cpf Delivery: ' + cpf.program__r.Delivery_type__c);
                        System.debug('ppf Delivery: ' + ppf.program__r.Delivery_type__c);
                        System.debug('cpf AD Period: ' + cpf.AD_Period__c);
                        System.debug('ppf AD Period: ' + ppf.AD_Period__c);
                        if(cpf.program__r.Delivery_type__c == ppf.program__r.Delivery_type__c && cpf.AD_Period__c == ppf.AD_Period__c)
                        {
                        error = false;                       
                        break;
                        }                        
                    }
                    if(error = true)
                    {                        
                        break;
                    }
                }                
                System.assert(error == false);                                                                   
            }
        }
        
        
        /*
        List<Program_Forecast__c> ForecastWithNull = [select Program__r.id from Program_Forecast__c where Program__r.Opportunity__r.Type = 'Addendum' and (Forecast_Amount__c = null or Previous_Quarter_Amount__c = null or Next_Quarter_Amount__c = null) and Program__r.Opportunity__r.StageName != 'Closed Won Addendum'];

        
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        String accountRTID = [SELECT ID FROM RecordType Where Name = 'Manufacturing' and SOBJECTTYPE = 'Account'][0].Id;
        
        Account a = new Account();
        a.Name = 'testAccount';
        a.RecordTypeId = accountRTID;
        insert a;            
        
        //List<Opportunity> insertOpps = new List<Opportunity>();
        
        Opportunity o = new Opportunity();
        o.Name = 'testParentOpportunity';
        o.StageName = 'Idea';
        o.Type = 'New';
        o.CloseDate = Date.Today();
        //o.Product_Type__c = 'NA';
        //o.CATS_External_ID__c = 'TEST123456';
        o.Catalina_Business_Unit__c = 'Base';
        o.AccountId = a.Id;        
        
        //insertOpps.add(o);
        
        insert o;      
        //o = [select ID from Opportunity where Name = 'testParentOpportunity'];
        
        Opportunity o2 = new Opportunity();
        o2.Name = 'testChildOpportunity';
        o2.StageName = 'Idea';
        o2.Type = 'Addendum';
        o2.CloseDate = Date.Today();
        //o2.Product_Type__c = 'NA';
        o2.Catalina_Business_Unit__c = 'Base;Mobile';
        o2.AccountId = a.Id;
        o2.Parent_Contract__c = o.Id;
        
        insert o2;
        //insertOpps.add(o2);
        //insert insertOpps;
        
        Ad_Period__c ap = new Ad_Period__c();
        ap.Name = 'Ad Period';
        ap.Start_Date__c = date.Today();
        ap.End_Date__c = date.Today() + 30;
        ap.Type__c = 'Manufacturing';
        insert ap;
        
        //o2 = [select ID, StageName from Opportunity where Name = 'testChildOpportunity']; 
          
        List<Program__c> childPrograms = [select ID from Program__c where Opportunity__c =: o2.id];
        Program__c parentProgram = [select ID from Program__c where Opportunity__c =: o.id];
                
        List<Program_Forecast__c> forecastToInsert = new List<Program_Forecast__c>(); 
        
        Program_Forecast__c pf;    
        
        for(Program__c p : childPrograms) 
        {
        
           pf = new Program_Forecast__c(Program__c = p.id);
           pf.Ad_Period__c = ap.id;
           pf.Forecast_Amount__c = -1000000;
           pf.Previous_Quarter_Amount__c = 1000000;
           pf.Next_Quarter_Amount__c = null;
           forecastToInsert.add(pf);
        
        }
                                       
        pf = new Program_Forecast__c(Program__c = parentProgram.id);
        pf.Ad_Period__c = ap.id;
        pf.Forecast_Amount__c = 0;
        pf.Previous_Quarter_Amount__c = null;
        pf.Next_Quarter_Amount__c = 1000000;
        forecastToInsert.add(pf);
        
        // Test.startTest();
        
        insert forecastToInsert;
        
        o2.StageName = 'Closed Won Addendum';
        update o2;
        
        List<Program_Forecast__c> parentProgramForecast = [select ID, Program__r.Delivery_Type__c, Forecast_Amount__c, Previous_Quarter_Amount__c, Next_Quarter_Amount__c from Program_Forecast__C Where Program__r.Opportunity__c =: o.id];
        
        for(Program_Forecast__c ppf : parentProgramForecast)
        {
        
            if(ppf.Program__r.Delivery_Type__c == 'Base')
            {
                
                System.assert(ppf.Forecast_Amount__c == -1000000 && ppf.Previous_Quarter_Amount__c == 1000000 && ppf.Next_Quarter_Amount__c == 1000000);
            
            }
            else if(ppf.Program__r.Delivery_Type__c == 'Mobile')
            {
            
                System.assert(ppf.Forecast_Amount__c == -1000000 && ppf.Previous_Quarter_Amount__c == 1000000 && ppf.Next_Quarter_Amount__c == null);
            
            }           
        
        }               
        
        //Test.stopTest();
        */
     }
 
}