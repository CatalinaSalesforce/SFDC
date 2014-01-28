trigger tgrPopulateActivityFields_Event on Event (before insert, before update) { 
    for(Event e : trigger.new){ 
        // write custom field "Activity Date"
        if (e.StartDateTime != null) e.Activity_Date__c = Date.newInstance(e.StartDateTime.year(),e.StartDateTime.month(),e.StartDateTime.day());
        /*
        // write custom field "Start Date/Time"
        e.Start_Date_Time__c = e.StartDateTime;
        // write custom field "End Date/Time"
        e.End_Date_Time__c = e.EndDateTime;
        // write custom field "Type (as Text)"
        e.Type_as_Text__c = e.Type;
        */
    } 
}