/**********************************************************
*  CycleDbTrigger
*  サイクルDBのトリガークラス
*  version： 1.0
*  作成： Satoshi Haga
***********************************************************/
trigger CycleDbTrigger on cycleDB__c (before insert, before update) {

    CycleDbTriggerHandler handler = new CycleDbTriggerHandler();
    
    if(Trigger.isInsert && Trigger.isBefore){
      /** Insert前 */
        handler.OnBeforeInsert(Trigger.new);
    }else if(Trigger.isUpdate && Trigger.isBefore){
      /** Update前 */
      handler.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.newMap);
    }

}