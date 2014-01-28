/**********************************************************
*  WireringIssueTrigger
*  ワイヤリング障害管理のトリガークラス
*  version： 1.0
*  作成： Satoshi Haga
***********************************************************/
trigger WireringIssueTrigger on WireringIssueManagement__c (before update, after update) {

  WireringIssueTriggerHandler handler = new WireringIssueTriggerHandler();
    if(Trigger.isUpdate && Trigger.isBefore){
    //更新前トリガー
        handler.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.newMap);
    }else if(Trigger.isUpdate && Trigger.isAfter){
    //更新後トリガー
        handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.newMap);
    }

}