trigger CycleDBInsertTgr on cycleDB__c (before insert) {
    
    For(cycleDB__c cycle:Trigger.new){
    
        cycle.Legacy_Created_By__c = UserInfo.getUserId();
        
    }

}