/**
 * An apex page controller that exposes the site login functionality for Candidates
 */
global class OB_CandidateLoginController {
    global String username {get; set;}
    global String password {get; set;}

    global PageReference login() {
        Candidate__c candidate = null;
        
        if(password == 'XXX'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Your login has expired. Please contact our HR admin.'));
            return null;
        }       
        
        try{
            candidate = Database.query('Select id from Candidate__c where Email__c=\''+username+'\'' + 'and Passcode__c=\''+password+'\'');   
        }
        catch (Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid username or password'));
            return null;
        }
        Cookie loginCookie = new Cookie('loginCookie', candidate.id,null, 1800, true);
        PageReference destPage = Page.OB_Welcome;
        destPage.setCookies( new Cookie[]{ loginCookie } );
        return destPage;
     }
    
    
    global static testMethod void testCandidateLoginController () {
        Candidate__c candidate = new Candidate__c();
        candidate.Email__c = 'test@example.com';
        candidate.Last_Name__c = 'last';
        candidate.SSN__c='123123';
        candidate.First_Name__c = 'first';
        datetime t = System.now();
        candidate.Start_Date__c = Date.newInstance(t.year(),t.month(),t.day()); 

        test.startTest();
        insert candidate;
        test.stopTest();
        System.debug(candidate.Email__c);
        System.debug(candidate.Passcode__c);
        System.debug(candidate.id);
        
        candidate  = [select id, Email__c, Passcode__c from candidate__c where id  =
                       :candidate.id];
        OB_CandidateLoginController controller = new OB_CandidateLoginController ();
        controller.username = candidate.Email__c;
        controller.password = candidate.Passcode__c; 
        PageReference rpage =    controller.login();       
        System.assertEquals(rpage.getUrl(),Page.OB_Welcome.getUrl());     
        System.assertEquals(rpage.getCookies().get('loginCookie').getValue(),candidate.id);     
        controller.password = 'XXX'; 
        rpage =    controller.login();       
        System.assertEquals(rpage,null);     
        controller.password = ''; 
        rpage =    controller.login();       
        System.assertEquals(rpage,null);     
    }    
}