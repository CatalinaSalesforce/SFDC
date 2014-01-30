trigger UpdateFlaggedIP on Case (before insert) {
    List<String> FlaggedIP = new List<String>(); 
    
    for (Case a:Trigger.new){
        FlaggedIP.add(a.Consumer_IP_Address__c);
    }

    List <Flagged_IP_Address__c> FlaggedList = [Select ID, Name from Flagged_IP_Address__c where Name in :FlaggedIP];

    for (Integer i = 0; i <Trigger.new.size(); i++){
        if (FlaggedList.size() > 0 && Trigger.new[i].Consumer_IP_Address__c !=null){
                        for (Flagged_IP_Address__c f:FlaggedList){
        if (Trigger.new[i].Consumer_IP_Address__c == f.name){
                        Trigger.new[i].Flagged_IP_Address__c = f.ID;
                                }
                        }
        }
        else{
        Trigger.new[i].Flagged_IP_Address__c = null;
        }
        
    }
}