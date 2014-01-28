/*
@Name            : ItProjectRequestTrriger
@Author          : Satoshi Haga
@Date            : July 19, 2013
@Description     : Apex trigger  for IT_Project_Request__c
@version         : 06/01/2012 First Creation
*/
trigger ItProjectRequestTrriger on IT_Project_Request__c (before insert, before update) {

  	//Initialize trigger execution class
    ItProjectRequestTrrigerHandler handler = new ItProjectRequestTrrigerHandler();

    //split for each triggered type
    if(Trigger.isInsert && Trigger.isBefore){


      //before insertion
      handler.OnBeforeInsert(Trigger.new);

    }else if(Trigger.isUpdate && Trigger.isBefore){
      //Before Update
        handler.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.newMap);
    }

}