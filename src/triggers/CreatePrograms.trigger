/*
@Name            : CreatePrograms
@Author          : Dru@cloud62.com
@Date            : March 19, 2011
@Description     : Creates a program for every value in Catalina_Business_Unit__c when a Proposal type Oppty's Probability goes past 50%
*/
trigger CreatePrograms on Opportunity (after insert, after update) {
    final static String digitalType = 'Digital O&O';
    //Variables
    Map<Id, List<Program__c>> mapOpptyPrograms = new Map<Id, List<Program__c>>();
    Set<Id> setOppIds = new set<Id>();
    List<Opportunity> lstOpps = new List<Opportunity>();
    
    //Get the opptys for this trigger
    for(Opportunity opp : trigger.new){
        if (Trigger.isUpdate){
            if (opp.Catalina_Business_Unit__c != Trigger.oldMap.get(opp.Id).Catalina_Business_Unit__c) setOppIds.add(opp.Id);
        } else if (Trigger.isInsert){
            if (opp.Catalina_Business_Unit__c != null) setOppIds.add(opp.Id);
        }
    }
    if (setOppIds.size() > 0){
        lstOpps = [SELECT Id, Name, Catalina_Business_Unit__c, Start_Date__c, AccountId, Description
                        , End_Date__c, Product_Type__c, Amount, OwnerId, RecordType.Name, RecordTypeId,
                        CurrencyIsoCode
                    FROM Opportunity 
                    WHERE Id IN :setOppIds];
        
        //Create the map of opptys and thier existing programs
        for (Program__c pro : [Select Id, Delivery_Type__c, Opportunity__c From Program__c Where Opportunity__c IN :lstOpps Order By Delivery_Type__c]){
            if (!mapOpptyPrograms.containsKey(pro.Opportunity__c)){
                mapOpptyPrograms.put(pro.Opportunity__c, new List<Program__c>());
            }
            mapOpptyPrograms.get(pro.Opportunity__c).add(pro);
        }
        
        //Create a Program for every Opportunities catalina business unit that doesn't already exist
        List<Program__c> lstInsertPrograms = new List<Program__c>();
        Boolean bolExists;
        for(Opportunity opp : lstOpps){
            if (opp.Catalina_Business_Unit__c != null && opp.RecordType.Name != 'Contract'){
                List<String> businessUnits = opp.Catalina_Business_Unit__c.split(';');
                for(String strBusinessUnit : businessUnits){
                    bolExists = false;
                    //If the oppty doesn't have a program with that business unit, create one
                    if(mapOpptyPrograms.get(opp.Id) != null){
                       for(Program__c proExist :  mapOpptyPrograms.get(opp.Id)){
                           if(proExist.Delivery_Type__c == strBusinessUnit){
                               bolExists = true;
                           }
                       }
                    }
                    if(!bolExists){
                        Program__c pro = new Program__c();
                        String tempName = opp.Name + ' - ' + strBusinessUnit;
                        system.debug(Logginglevel.WARN, 'Name Length: ' + tempName.length());
                        if (tempName.length() > 79){
                            pro.Name = tempName.substring(0,79);
                        }else {
                            pro.Name = tempName;
                        }
                        
                        pro.Opportunity__c = opp.Id;
                        pro.Delivery_Type__c = strBusinessUnit;
                        pro.Start_Date__c = opp.Start_Date__c;
                        //pro.Account__c = opp.AccountId;
                        pro.Description__c = opp.Description;
                        pro.End_Date__c = opp.End_Date__c;
                        pro.Product_Type__c = opp.Product_Type__c;
                        if (opp.Amount != null){
                            pro.Program_Amount__c = opp.Amount/businessUnits.size();
                        }
                        if (pro.Delivery_Type__c == digitalType){
                            pro.Number_of_Offers__c = 1;
                        } else {
                            pro.Number_of_Offers__c = 0;
                        }
                        pro.Owner__c = opp.OwnerId;
                        pro.CurrencyIsoCode = opp.CurrencyIsoCode;
                       // system.debug('Added program: ' + pro.Name);
                        lstInsertPrograms.add(pro);
                    }
                }
            }
        }
        
        insert lstInsertPrograms;
    }
}