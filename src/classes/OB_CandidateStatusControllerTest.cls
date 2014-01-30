@isTest()
public class OB_CandidateStatusControllerTest{
    static string        selectFields = 'id,Address_1__c,Address_2__c,Bonus_Level__c,Business_Unit__c,City__c,DD_Account_Number__c,Bank_Name__c,DD_Account_Type__c,DD_Routing_Number__c,EM_Address_1__c,EM_Address_2__c,EM_Cell_Phone__c,EM_City__c,EM_Home_Phone__c,EM_Name__c,EM_Relationship__c,EM_State__c,EM_Work_Phone__c,EM_Zip__c,Email__c,Ethnicity__c,First_Name__c,Gender__c,Last_Name__c,Marital_Status__c,Middle_Name__c,Name_as_in_SSN_Card__c,Nickname__c,Passcode__c,Phone_No_H__c,Phone_No_M__c,Date_of_Birth__c,SSN__c,State__c,Vet_Status__c,W4_Additional_Amount__c,W4_Claim_Exemption__c,W4_Marital_Status__c,W4_Number_of_Witholdings__c,W4_Initials__c,Zip__c';     

    
      static testMethod void testOB_CandidateTriggers () {
        //Setup dummy data
        Candidate__c candidate = new Candidate__c();
        candidate.Email__c = 'test@example.com';
        candidate.Last_Name__c = 'last';
        candidate.SSN__c='123123';
        candidate.First_Name__c = 'first';
        datetime t = System.now();
        candidate.Start_Date__c = Date.newInstance(t.year(),t.month(),t.day()); 
        
        test.startTest();
        insert candidate;
        Candidate_Status__c       candidateStatus = new Candidate_Status__c();   
        candidate = Database.query('Select '+ selectFields  + ' from Candidate__c where  Email__c=\''+candidate.Email__c+'\'');  
        candidateStatus.Candidate__c = candidate.id; 
        candidateStatus.Initial_Confidentiality_Agreement__c ='ASD';
        candidateStatus.Initial_Ethics_Form__c = 'ASD';      
        candidateStatus.Initial_Assurance_Form__c = 'ASD';     
        candidateStatus.Initial_Associate_Handbook__c = 'ASD';        
        insert candidateStatus;         

        candidateStatus.Initial_Confidentiality_Agreement__c ='ASDF';
        candidateStatus.Initial_Ethics_Form__c = 'ASDF';      
        candidateStatus.Initial_Assurance_Form__c = 'ASDF';     
        candidateStatus.Initial_Associate_Handbook__c = 'ASDF';        
        update candidateStatus;
        test.stopTest();
    }    
    
  static testMethod void testOB_CandidateStatusControllerWithLogin () {
        //Setup dummy data
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
        Candidate_Status__c       candidateStatus = new Candidate_Status__c();   
                 
        candidate = Database.query('Select ' +selectFields + ' from Candidate__c where  Email__c=\''+candidate.Email__c+'\'');  
        candidateStatus.Candidate__c = candidate.id; 

        Cookie loginCookie =new Cookie('loginCookie',candidate.id+'',null,-1,false);        
        ApexPages.currentPage().setCookies(new Cookie[]{ loginCookie });
        
        // Instantiate a new controller with all parameters in the page
        OB_CandidateStatusController controller = new OB_CandidateStatusController (new ApexPages.StandardController(candidate));
       
        System.assertEquals(controller.step1().getUrl(), Page.OB_Step1.getUrl());        
        System.assertEquals(controller.step2().getUrl(), Page.OB_Step2.getUrl());        
        candidateStatus.Initial_Confidentiality_Agreement__c ='ASD';
      //  controller.saveCandidateStatus();
        System.assertEquals(controller.step3().getUrl(), Page.OB_Step3.getUrl());  
        candidateStatus.Initial_Ethics_Form__c = 'ASD';      
    //    controller.saveCandidateStatus();
        System.assertEquals(controller.step4().getUrl(), Page.OB_Step4.getUrl());   
        candidateStatus.Initial_Assurance_Form__c = 'ASD';     
   //     controller.saveCandidateStatus();
        System.assertEquals(controller.step5().getUrl(), Page.OB_Step5.getUrl());
        candidateStatus.Initial_Associate_Handbook__c = 'ASD';        
        controller.saveCandidateStatus();
        System.assertEquals(controller.step6().getUrl(), Page.OB_Step6.getUrl());        
        System.assertEquals(controller.finalsubmit().getUrl(), Page.OB_Confirmation.getUrl());        
         
        controller.savePdf(ApexPages.currentPage(), 'asd') ;
    }    
    


}