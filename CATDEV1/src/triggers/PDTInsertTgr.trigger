trigger PDTInsertTgr on PDT__c (before insert) {
    
    For(PDT__c pdt:Trigger.new){
    
        pdt.Legacy_Created_By__c = UserInfo.getUserId();
        
    }
    
}