trigger tgrPopulateActivityFields_Task on Task (before insert, before update) { 
    for(Task t : trigger.new){ 
        // write custom field "Activity Date"
        t.Activity_Date__c = t.ActivityDate;
    /*
        // write custom field "Start Date/Time"
        t.Start_Date_Time__c = t.ActivityDate;
        // write custom field "End Date/Time"
        t.End_Date_Time__c = t.ActivityDate;
        // write custom field "Type (as Text)"
        t.Type_as_Text__c = t.Type;
    */
    }
}