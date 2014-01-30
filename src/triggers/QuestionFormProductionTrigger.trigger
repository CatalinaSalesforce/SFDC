/*
@Name            : QuestionFormProductionTrigger
@Author          : Satoshi Haga
@Date            : Aug 16, 2013
@Description     : Trigger class for PDT__c
@version         : 08/16/2013 First Creation
*/
trigger QuestionFormProductionTrigger on PDT__c (before update) {

    //Create new Instance of trigger execution class
    QuestionFormProductionTriggerHandler handler = new QuestionFormProductionTriggerHandler();

    //Split by trigger type
    if(Trigger.isUpdate && Trigger.isBefore){
      	//Before Update
		handler.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.newMap);
    }

}