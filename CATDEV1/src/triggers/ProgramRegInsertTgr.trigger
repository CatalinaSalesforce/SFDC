trigger ProgramRegInsertTgr on program_req__c (before insert) {
    
    For(program_req__c prog:Trigger.new){
    
        prog.Legacy_Created_By__c = UserInfo.getUserId();
        
    }
    
    
    
}