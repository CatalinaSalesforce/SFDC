trigger ProgramReqestTrigger on program_req__c (before update, before insert, after insert) {
  
  //トリガー実行クラス
    ProgramRecTriggerHandler handler = new ProgramRecTriggerHandler();
    
    //更新種類により分岐
    if(Trigger.isInsert && Trigger.isBefore){
      //Insert前トリガー
        handler.OnBeforeInsert(Trigger.new);
    }else if(Trigger.isUpdate && Trigger.isBefore){
      //Update後トリガー
        handler.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.newMap);
    }

}