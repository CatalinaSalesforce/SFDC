@isTest
// test for the 'Populate Activity Fields' triggers
private class tstPopulateActivityFields {
    static testMethod void test() {
        // create dummy Event & Task
        Event e = new Event(ActivityDateTime=Date.Today(), Description='Test Event',
                            DurationInMinutes=10, Subject='Test Event', Type='Test Event'); 
        Task t = new Task(ActivityDate=Date.Today(), Description='Test Task',
                          Priority='Low', Status='Completed', Subject='Test Task',
                          Type='Test Task'); 
        insert e;
        insert t;

    }
}