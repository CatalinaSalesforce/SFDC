@istest()
public class OB_CandidateLoginControllerTest{
    
  
   public static testMethod void testCandidateLoginController () {
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