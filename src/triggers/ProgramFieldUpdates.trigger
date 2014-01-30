/* This trigger updates the Program record type to match the Opportunity Recordtype
*
*  In addition, the Program Retail_Manufacturing field is set based on the Account record type
June 24 2013 - add in processing for other CME countries, setting the right RT
*/

trigger ProgramFieldUpdates on Program__c (before insert, before update) {
    
    //populate the Program record type
    final String contractRT = 'Program_Contract';
    final String proposalRT = 'Program_Proposal';
    final String proposalFRT =  'Proposal_France';
    final String contractFRT =  'Contract_France';
    final String proposalJPT =  'Proposal_Japan';
    final String contractJPT =  'Contract_Japan';
    //add CME strings june 24 2013
    final String contractGER =  'Contract_Germany';
    final String proposalGER =  'Proposal_Germany';
    final String contractITA =  'Contract_Italy';
    final String proposalITA =  'Proposal_Italy';
    
    String contractId;
    String proposalId;
    String proposalFId;
    STring contractFId;
    String proposalJId;
    STring contractJId;
    String proposalGId;
    String contractGId;
    String proposalIId;
    String contractIId;
    
    List<RecordType> rtList = [Select Id, DeveloperName From RecordType Where SObjectType = 'Program__c'];
    for (RecordType a : rtList){
        if (a.DeveloperName == contractRT) contractID = a.Id;
        if (a.DeveloperName == proposalRT) proposalID = a.Id;
        if (a.DeveloperName == contractFRT) contractFID = a.Id;
        if (a.DeveloperName == proposalFRT) proposalFID = a.Id;
        if (a.DeveloperName == contractJPT) contractJId = a.id;
        if (a.DeveloperName == proposalJPT) proposalJId = a.id;
        if (a.DeveloperName == contractGER) contractGId = a.id;
        if (a.DeveloperName == proposalGER) proposalGId = a.id;
        if (a.DeveloperName == contractITA) contractIId = a.id;
        if (a.DeveloperName == proposalITA) proposalIId = a.id;
    } 
    Map<Id, String> opptyMap = new Map<Id, String>();
    Map<Id, String> opptyAccMap = new Map<Id, String>();
    Set<Id> opptys = new Set<Id>();
    Set<Id> accountIds = new Set<Id>();
    Set<Id> adPeriodIds = new Set<Id>();
    Map<Id, String> accountMap = new Map<Id, String>();
    Map<Id, Ad_Period__c> adPeriodsMap = new Map<Id, Ad_Period__c>();
    Set<Ad_Period__c> adPeriodsSet = new Set<Ad_Period__c>();
        
    for (Program__c x : Trigger.New){
        opptys.add(x.Opportunity__c);system.debug('***'+x.Start_Cycle__c + x.Start_Date__c);
        accountIds.add(x.Opportunity__r.AccountId);
        if (x.Start_Cycle__c != null){
            adPeriodIds.add(x.Start_Cycle__c);
        }
        
        if (x.End_Cycle__c != null){
            adPeriodIds.add(x.End_Cycle__c);
        }
    }
    
    for (Opportunity x : [Select Id, AccountId, RecordType.Name From Opportunity Where Id IN : opptys]){
        opptyMap.put(x.Id, x.RecordType.Name);
        opptyAccMap.put(x.Id, x.AccountId);
    }
    
    for (Account x : [Select Id, RecordType.Name From Account Where Id IN (SELECT ACCOUNTID FROM OPPORTUNITY WHERE ID IN :opptys)]){
        accountMap.put(x.Id, x.RecordType.Name);
    }
                                                                                    
    List<Ad_Period__c> adList = [Select Id, Start_Date__c, End_Date__c, Type__c, Name from Ad_Period__c];
    adPeriodsMap = new Map<Id, Ad_Period__c>();
    adPeriodsSet = new Set<Ad_Period__c>();
    for (Ad_Period__c ad1 : adList){
        adPeriodsMap.put(ad1.Id, ad1);
        adPeriodsSet.add(ad1);
    }
    
    for (Program__c x : Trigger.New){
        system.debug('***oppty RT: ' + x.Opportunity__c + ' ' + x.Start_Cycle__c + ' '+ x.Start_Date__c);
        system.debug('***Acc RT: ' + accountMap.get(opptyAccMap.get(x.Opportunity__c)));
        
        if (opptyMap.get(x.Opportunity__c) == 'Contract'){
            x.RecordTypeId = contractId;
        } else if (opptyMap.get(x.Opportunity__c) == 'Contract France'){
            x.RecordTypeId = contractFId;
        } else if (opptyMap.get(x.Opportunity__c) == 'Proposal France' || opptyMap.get(x.Opportunity__c) == 'Renewals France'){
            x.RecordTypeId = proposalFId;
        } else if (opptyMap.get(x.Opportunity__c) == 'Proposal Japan'){
            x.RecordTypeId = proposalJId;
        } else if (opptyMap.get(x.Opportunity__c) == 'Contract Japan'){
            x.RecordTypeId = contractJId;
        //add processing of CME RTs
        } else if (opptyMap.get(x.Opportunity__c) == 'Contract Germany'){
            x.RecordTypeId = contractGId;
        } else if (opptyMap.get(x.Opportunity__c) == 'Proposal Germany' || opptyMap.get(x.Opportunity__c) == 'Renewals Germany'){
            x.RecordTypeId = proposalGId;
        } else if (opptyMap.get(x.Opportunity__c) == 'Contract Italy'){
            x.RecordTypeId = contractIId;
        } else if (opptyMap.get(x.Opportunity__c) == 'Proposal Italy' || opptyMap.get(x.Opportunity__c) == 'Renewals Italy'){
            x.RecordTypeId = proposalIId;
        } else {
            x.RecordTypeId = proposalId;
        }
        
        //populate the retail manufacturing field on the Program based on Account
        if (accountMap.get(opptyAccMap.get(x.Opportunity__c)) == 'Retail'){
            x.Account_Type__c = 'Retail';
        } else if(accountMap.get(opptyAccMap.get(x.Opportunity__c)) == 'Manufacturing'){
            x.Account_Type__c = 'Manufacturing';
        } else if(accountMap.get(opptyAccMap.get(x.Opportunity__c)) == 'Manufacturing France'){
            x.Account_Type__c = 'Manufacturing France';
        }
        //added by Warren Mar 10, 2013
        else if(accountMap.get(opptyAccMap.get(x.Opportunity__c)) == System.label.Manufacturer){
            x.Account_Type__c = 'Manufacturing Japan';
        } else if(accountMap.get(opptyAccMap.get(x.Opportunity__c)) == System.label.retail){
            x.Account_Type__c = 'Retail Japan';
        }
        //added by Warren June 24, 2013 for CME
        else if(accountMap.get(opptyAccMap.get(x.Opportunity__c)) == 'Manufacturing Germany'){
            x.Account_Type__c = 'Manufacturing Germany';
        } else if(accountMap.get(opptyAccMap.get(x.Opportunity__c)) == 'Manufacturing Italy'){
            x.Account_Type__c = 'Manufacturing Italy';
        }
        
        //make sure the start date and end date on the Program are in sync with the start and end cycles chosen
        if (x.Start_Cycle__c != null && x.Start_Date__c == null){
            Ad_Period__c a = adPeriodsMap.get(x.Start_Cycle__c);system.debug('startcycle!=null && startdate==null');
           if (a != null){
               x.Start_Date__c = a.Start_Date__c;
           }
        }
        
        if (x.End_Cycle__c != null  && x.End_Date__c == null){
           Ad_Period__c a = adPeriodsMap.get(x.End_Cycle__c);
           if (a != null){
               x.End_Date__c = a.End_Date__c;
           }
        }
            // take care of the records that ended up with start dates, but no start cycles
       // Added by Matt to handle programs with Start_Cycle__c or End_Cycle__c == null
       // and locate appropriate start or end cycle based on Start_Date__c or End_Date__c
        if(x.Start_Cycle__c == null){
            for(Ad_Period__c ap : adPeriodsSet){
                if(ap.Type__c == x.Account_Type__c && ap.Start_Date__c <= x.Start_Date__c && x.Start_Date__c <= ap.End_Date__c ){
                    x.Start_Cycle__c = ap.Id;
                }
            }
        }
        if(x.End_Cycle__c == null){
            for(Ad_Period__c ap : adPeriodsSet){
                if(ap.Type__c == x.Account_Type__c && ap.Start_Date__c <= x.End_Date__c && x.End_Date__c <= ap.End_Date__c){
                        x.End_Cycle__c = ap.Id;
                 }
            }
        }

            system.debug('***FINAL PROGRAM START_CYCLE__C: ' + x.Start_Cycle__c);
            system.debug('***FINAL PROGRAM START_Date__C: ' + x.Start_Date__c);
    }

    //always make sure that the start date and end date are the same as the start cycle and end cycle
    
    
    
}