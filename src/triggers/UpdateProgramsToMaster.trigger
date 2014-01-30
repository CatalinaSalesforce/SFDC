trigger UpdateProgramsToMaster on Opportunity (after update) 
{


    Set<ID> currentIDs = new Set<ID>();
    Set<ID> parentIDs =  new Set<ID>();
    Set<ID> forecastIDToUpdate = new Set<ID>();
    
    Map<ID, List<Program__c>> currentProgramMap = new Map<ID, List<Program__c>>();
    Map<ID, List<Program__c>> parentProgramMap = new Map<ID, List<Program__c>>();
    
    Map<ID, List<Program_Forecast__c>> currentProgramForecastMap = new Map<ID, List<Program_Forecast__c>>();
    Map<ID, List<Program_Forecast__c>> parentProgramForecastMap = new Map<ID, List<Program_Forecast__c>>();
    
    Map<ID, Opportunity> OpportunityParentMap = new Map<ID, Opportunity>();
    List<Opportunity> OppToUpdate = new List<Opportunity>();
    List<Opportunity> ParentOpportunity = new List<Opportunity>();
    List<Opportunity> childOpportunity = new List<Opportunity>();
    
    List<Program_Forecast__c> forecastsToDelete = new List<Program_Forecast__c>();
    List<Program_Forecast__c> forecastsToUpdate = new List<Program_Forecast__c>();
    List<Program_Forecast__c> forecastsToInsert = new List<Program_Forecast__c>();
    List<Program__c> programsToInsert = new List<Program__c>();
    
    List<Program__c> currentProgram = new List<Program__c>();
    List<Program__c> parentProgram = new List<Program__c>();
    List<Program_Forecast__c> currentProgramForcast = new List<Program_Forecast__c>();
    List<Program_Forecast__c> parentProgramForcast = new List<Program_Forecast__c>();
    
    for(Opportunity o : Trigger.new)
    {
    
        if((o.StageName != Trigger.oldMap.get(o.Id).StageName) && (o.StageName == 'Closed Won Addendum') && (o.Type == 'Addendum'))
        {           
            
            currentIDs.add(o.ID);            
            parentIDs.add(o.Parent_Contract__c);
                      
        }        
        
    }
    if(currentIDs.Size() > 0)
    {
        
        ParentOpportunity = [select ID, Catalina_Business_Unit__c from Opportunity where ID in: parentIDs];
        childOpportunity = [select ID, Parent_Contract__r.ID from Opportunity where ID in: currentIDs];
        
        currentProgram = [select ID, Name, Opportunity__c, Opportunity__r.Parent_Contract__r.ID, Opportunity__r.Parent_Contract__r.CATS_External_ID__c ,Opportunity__r.Owner.ID, Delivery_Type__c, Account_Type__c, Brand__c, /*Brands_List__c,*/ Contract_Commitment_Type__c, Description__c, Division__c, Division_List__c, End_Cycle__c, End_Date__c, Incentive_Kicker__c, Initiative__c, Number_of_Offers__c, Product_Type__c, Program_Amount__c, Start_Cycle__c, Start_Date__c, RecordType.Name, Owner__c from Program__c where Opportunity__c in: currentIDs];
        currentProgramForcast = [select ID, Name, program__r.ID, Active__c, Actual_Amount__c, Ad_Period__c, End_Date__c, External_ID__c, Forecast_Amount__c, France_External_ID__c, Next_Quarter_Actual__c, Next_Quarter_Amount__c, Previous_Quarter_Actual__c, Previous_Quarter_Amount__c, Start_Date__c  from Program_Forecast__c where Program__r.Opportunity__c in: currentIDs];
        
        parentProgram = [select ID, Opportunity__c, Delivery_Type__c from Program__c where Opportunity__c in: parentIDs];
        parentProgramForcast = [select ID, program__r.ID, Ad_Period__c, Forecast_Amount__c, Previous_Quarter_Amount__c, Next_Quarter_Amount__c from Program_Forecast__c where Program__r.Opportunity__c in: parentIDs];
         
        for(Opportunity o : childOpportunity)
        {
        
            for(Opportunity po : ParentOpportunity)
            {
            
                if(o.Parent_Contract__r.ID == po.ID)
                {
                    
                    OpportunityParentMap.put(o.ID, po);
                    
                    Break;
                    
                }
            
            }
        
        }
         
        for(Program__c p : currentProgram)
        {
        
            if(!currentProgramMap.containsKey(p.Opportunity__c))
            {
            
                currentProgramMap.put(p.Opportunity__c, new List<Program__c>());
            
            }
            
            currentProgramMap.get(p.Opportunity__c).add(p);
            
        }
        
        for(Program__c p : parentProgram)
        {
        
            if(!parentProgramMap.containsKey(p.Opportunity__c))
            {
            
                parentProgramMap.put(p.Opportunity__c, new List<Program__c>());
            
            }
            
            parentProgramMap.get(p.Opportunity__c).add(p);
            
        } 
    
        for(Program_Forecast__c pf : currentProgramForcast)
        {
        
            if(!currentProgramForecastMap.containsKey(pf.Program__c))
            {
            
                currentProgramForecastMap.put(pf.Program__c, new List<Program_Forecast__c>());
            
            }
            
            currentProgramForecastMap.get(pf.Program__c).add(pf);
            
        } 
    
        for(Program_Forecast__c pf : parentProgramForcast)
        {
        
            if(!parentProgramForecastMap.containsKey(pf.Program__c))
            {
            
                parentProgramForecastMap.put(pf.Program__c, new List<Program_Forecast__c>());
            
            }
            
            parentProgramForecastMap.get(pf.Program__c).add(pf);
            
        }    
        
        boolean hasProgram = false;
        
        boolean hasForecast = false;
        
        for(Opportunity o : Trigger.new)
        {
        
            if((o.StageName != Trigger.oldMap.get(o.ID).StageName) && (o.StageName == 'Closed Won Addendum') && (o.Type == 'Addendum'))
            {           
                if(currentProgramMap.containsKey(o.ID))
                {
                    for(Program__c cp : currentProgramMap.get(o.ID))
                    {
                    
                        hasProgram = false;
                        
                        Program__c newProgram = new Program__c();
            
                        Program_Forecast__c newForecast = new Program_Forecast__c();
                        if(parentProgramMap.containsKey(o.Parent_Contract__c))
                        {
                            for(Program__c pp : parentProgramMap.get(o.Parent_Contract__c))
                            {
                            
                                if(cp.Delivery_Type__c == pp.Delivery_Type__c)
                                {
                                
                                    hasProgram = true;                                              
                                    
                                    break;
                                    
                                }
                            
                            }
                        }
                        if(hasProgram == false)
                        {                    
                            
                            newProgram = new Program__c();
                            newProgram.Name = cp.Name;
                            newProgram.Account_Type__c = cp.Account_Type__c;
                            newProgram.Brand__c = cp.Brand__c;
                            //newProgram.Brands_List__c = cp.Brands_List__c;
                            newProgram.Contract_Commitment_Type__c = cp.Contract_Commitment_Type__c;
                            newProgram.Delivery_Type__c = cp.Delivery_Type__c;
                            newProgram.Description__c = cp.Description__c;
                            newProgram.Division__c = cp.Division__c;
                            newProgram.Division_List__c = cp.Division_List__c;
                            newProgram.End_Cycle__c = cp.End_Cycle__c;
                            newProgram.End_Date__c = cp.End_Date__c;
                            newProgram.Incentive_Kicker__c = cp.Incentive_Kicker__c;
                            newProgram.Initiative__c = cp.Initiative__c;
                            newProgram.Number_of_Offers__c = cp.Number_of_Offers__c;
                            newProgram.Product_Type__c = cp.Product_Type__c;
                            newProgram.Program_Amount__c = cp.Program_Amount__c;
                            newProgram.Start_Cycle__c = cp.Start_Cycle__c;
                            newProgram.Start_Date__c = cp.Start_Date__c;
                            newProgram.RecordType = cp.RecordType;
                            newProgram.Owner__c = cp.Opportunity__r.Owner.ID;
                            newProgram.Opportunity__c = cp.Opportunity__r.Parent_Contract__r.ID; 
                            newProgram.External_ID__c = cp.Opportunity__r.Parent_Contract__r.CATS_External_ID__c + cp.Delivery_Type__c;
                            
                            programsToInsert.add(newProgram); 
                            if(!parentProgramMap.containsKey(o.Parent_Contract__c))
                            {                        
                                parentProgramMap.put(o.parent_Contract__c, new List<Program__c>());                            
                            }
                            parentProgramMap.get(o.Parent_Contract__c).add(newProgram);                               
                            
                            if(OpportunityParentMap.containsKey(o.ID))
                            {
                            
                                System.debug('GotHere');
                                if(OpportunityParentMap.get(o.ID).Catalina_Business_Unit__c == Null)
                                {
                                
                                    OpportunityParentMap.get(o.ID).Catalina_Business_Unit__c = cp.Delivery_Type__c;
                                    OppToUpdate.add(OpportunityParentMap.get(o.ID));
                                    
                                }
                                else if(!(OpportunityParentMap.get(o.ID).Catalina_Business_Unit__c.Contains(cp.Delivery_Type__c)))
                                {
                                    System.debug('Opp delivery before: ' + OpportunityParentMap.get(o.ID).Catalina_Business_Unit__c);                                
                                    
                                    OpportunityParentMap.get(o.ID).Catalina_Business_Unit__c += ';' + cp.Delivery_Type__c;
                                    
                                    System.debug('Opp delivery before: ' + OpportunityParentMap.get(o.ID).Catalina_Business_Unit__c); 
                                    
                                    OppToUpdate.add(OpportunityParentMap.get(o.ID));
                                
                                }
                            
                            } 
                                                                
                        }          
                                                                          
                    }  
                }          
                             
            }
        
        }
        
        insert programsToInsert;
        
        parentProgram = [select ID, Opportunity__c, Delivery_Type__c from Program__c where Opportunity__c in: parentIDs];
        
        parentProgramMap = new Map<ID, List<Program__c>>();
        
        for(Program__c p : parentProgram)
        {
        
            if(!parentProgramMap.containsKey(p.Opportunity__c))
            {
            
                parentProgramMap.put(p.Opportunity__c, new List<Program__c>());
                
            }
            
            parentProgramMap.get(p.Opportunity__c).add(p);
            
        } 
        
        for(Opportunity o : Trigger.new)
        {
        
            if((o.StageName != Trigger.oldMap.get(o.ID).StageName) && (o.StageName == 'Closed Won Addendum') && (o.Type == 'Addendum'))
            {           
                Program_Forecast__c newForecast = new Program_Forecast__c();
                if(currentProgramMap.containsKey(o.ID))
                {
                    for(Program__c cp : currentProgramMap.get(o.ID))
                    {
                    
                        for(Program__c pp : parentProgramMap.get(o.Parent_Contract__c))
                        {
                        
                           if(cp.Delivery_Type__c == pp.Delivery_Type__c)
                           { 
                           
                               if(currentProgramForecastMap.containsKey(cp.id))
                               {
                                   for(Program_Forecast__c cpf : currentProgramForecastMap.get(cp.ID))
                                   {
                                       hasForecast = false;
                                       
                                       if(parentProgramForecastMap.containsKey(pp.id))
                                       {
                                           for(Program_Forecast__c ppf : parentProgramForecastMap.get(pp.ID))
                                           {
                                           
                                              if(cpf.Ad_Period__c == ppf.Ad_Period__c)
                                              { 
                                              
                                                  hasForecast = true;
                                                  
                                                  if(cpf.Forecast_Amount__c != null)
                                                  {
                                                      if(ppf.Forecast_Amount__c != null)
                                                      {
                                                          ppf.Forecast_Amount__c = ppf.Forecast_Amount__c + cpf.Forecast_Amount__c;
                                                      }
                                                      
                                                  }
                                                  if(cpf.Previous_Quarter_Amount__c != null)
                                                  {
                                                      if(ppf.Previous_Quarter_Amount__c != null)
                                                      {
                                                          ppf.Previous_Quarter_Amount__c = ppf.Previous_Quarter_Amount__c + cpf.Previous_Quarter_Amount__c;
                                                      }
                                                      
                                                  }
                                                  if(cpf.Next_Quarter_Amount__c != null)
                                                  {
                                                      if(ppf.Next_Quarter_Amount__c != null)
                                                      {
                                                          ppf.Next_Quarter_Amount__c = ppf.Next_Quarter_Amount__c + cpf.Next_Quarter_Amount__c;
                                                      }
                                                      
                                                  }
                                                 
                                                  forecastsToDelete.add(cpf);
                                                  
                                                  if(ppf.ID != null)
                                                  {
                                                  
                                                      forecastIDToUpdate.add(ppf.ID);
                                                  
                                                  }                                                                                                                                        
                                                 
                                                  break;  
                                              
                                              }
                                           
                                           }
                                           
                                       }
                                       
                                       if(hasForecast == false)
                                       {
                                            
                                            newForecast = new Program_Forecast__c();                                                                     
                                            newForecast.Active__c = cpf.Active__c;
                                            newForecast.Actual_Amount__c = cpf.Actual_Amount__c;
                                            newForecast.Ad_Period__c = cpf.Ad_Period__c;
                                            newForecast.End_Date__c = cpf.End_Date__c;
                                            //newForecast.External_ID__c = cpf.External_ID__c;
                                            newForecast.Forecast_Amount__c = cpf.Forecast_Amount__c;
                                            newForecast.France_External_ID__c = cpf.France_External_ID__c;
                                            newForecast.Next_Quarter_Actual__c = cpf.Next_Quarter_Actual__c;
                                            newForecast.Next_Quarter_Amount__c = cpf.Next_Quarter_Amount__c;
                                            newForecast.Previous_Quarter_Actual__c = cpf.Previous_Quarter_Actual__c;
                                            newForecast.Previous_Quarter_Amount__c = cpf.Previous_Quarter_Amount__c;
                                            newForecast.Start_Date__c = cpf.Start_Date__c;
                                            
                                            newForecast.Program__c = pp.ID;  
                                                                                                          
                                            forecastsToDelete.add(cpf);
                                            forecastsToInsert.add(newForecast);
                                            
                                            if(!parentProgramForecastMap.containsKey(pp.ID))
                                            {
                                            
                                                parentProgramForecastMap.put(pp.ID, new List<Program_Forecast__c>());
                                            
                                            }                                        
                                            
                                            parentProgramForecastMap.get(pp.ID).add(newForecast);   
                                             
                                       }
                                   
                                   }
                                   
                               }
                           
                           }
                        
                        }
                    
                    }
                }
                
            }
            
        }
    
    for(ID forecastID : forecastIDToUpdate)
    {         
    
        for(Program_Forecast__c ppf : parentProgramForcast)
        {
        
            if(ppf.ID == forecastID)
            {
            
                forecastsToUpdate.add(ppf);
            
            }
        
        }
    
    }

    
    system.debug(forecastsToInsert);
    system.debug(forecastsToUpdate);
       
    delete forecastsToDelete;
    insert forecastsToInsert;
    update forecastsToUpdate;
    update OppToUpdate;
    
    }

      
}