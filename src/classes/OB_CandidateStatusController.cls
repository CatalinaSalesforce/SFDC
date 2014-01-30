public class OB_CandidateStatusController{

   Candidate__c                       candidate;
   Candidate_Status__c                candidateStatus;  
   boolean                            bSessionActive = false;
   static string        selectFields = 'id,Address_1__c,Address_2__c,Bonus_Level__c,Business_Unit__c,City__c,DD_Account_Number__c,Bank_Name__c,DD_Account_Type__c,DD_Routing_Number__c,EM_Address_1__c,EM_Address_2__c,EM_Cell_Phone__c,EM_City__c,EM_Home_Phone__c,EM_Name__c,EM_Relationship__c,EM_State__c,EM_Work_Phone__c,EM_Zip__c,Email__c,Ethnicity__c,First_Name__c,Gender__c,Last_Name__c,Marital_Status__c,Middle_Name__c,Name_as_in_SSN_Card__c,Nickname__c,Passcode__c,Phone_No_H__c,Phone_No_M__c,Date_of_Birth__c,SSN__c,State__c,Vet_Status__c,W4_Additional_Amount__c,W4_Claim_Exemption__c,W4_Marital_Status__c,W4_Number_of_Witholdings__c,W4_Initials__c,Zip__c';     

   public OB_CandidateStatusController(ApexPages.StandardController controller){    
       this.candidate=(Candidate__c)controller.getrecord();
      
        // Get logged in user email id from the cookie set during login.
        PageReference curPage      = ApexPages.currentPage();
        Cookie        loginCookie  = curPage.getCookies().get('loginCookie');
        string        strId        = loginCookie.getValue();
      
        // Query the database to get the candidate from the email id.
        candidate = Database.query('Select ' +selectFields + ' from Candidate__c where  id=\''+strId+'\'');           
        if(candidate==NULL){
            //TODO: redirect to login page.
        }
      
        // Query the database to get the candidate status of the candidate.
        Candidate_Status__c[] oCandidateStatus  = Database.query('Select id,Initial_Assurance_Form__c,Initial_Confidentiality_Agreement__c,Initial_Ethics_Form__c,Initial_Associate_Handbook__c from Candidate_Status__c where  Candidate__c=\''+candidate.Id+'\'');           
        if(oCandidateStatus.size()==0) {
            candidateStatus = new Candidate_Status__c(); 
            candidateStatus.Candidate__c = candidate.id;     
        }
        else               
            candidateStatus = oCandidateStatus[0]; 
        bSessionActive = true;
  }
    
   // Getter functions. 
   public boolean getbSessionActive(){
       return bSessionActive;
   } 
  
   public Candidate__c  getCandidate(){
        return candidate;
   } 
    
   public Candidate_Status__c  getCandidateStatus(){
        Candidate_Status__c[] oCandidateStatus  = Database.query('Select id,Initial_Assurance_Form__c,Initial_Confidentiality_Agreement__c,Initial_Ethics_Form__c,Initial_Associate_Handbook__c,Confidentiality_Sign_Date__c,Ethics_Sign_Date__c,Assurance_Sign_Date__c,Handbook_Sign_Date__c,ISComplete__c from Candidate_Status__c where  Candidate__c=\''+candidate.Id+'\'');           
      
        if(oCandidateStatus.size()==0) {
            candidateStatus = new Candidate_Status__c(); 
            candidateStatus.Candidate__c = candidate.id;     
        }
        else               
            candidateStatus = oCandidateStatus[0]; 
        return candidateStatus;
   } 

    private PageReference getPage(PageReference apage){
        Cookie loginCookie  = ApexPages.currentPage().getCookies().get('loginCookie');
        if (loginCookie==null){
            PageReference pageRef = Page.OB_Login;
            pageRef.getParameters().put('session', 'INACTIVE');
            return pageRef;
        } else {
            loginCookie = new Cookie('loginCookie', loginCookie.getValue(),null, 1800, true);
            apage.setCookies( new Cookie[]{ loginCookie } );
            return apage;
        }
        
    }
   
   // The next six methods are used to control navigation through     
   // the wizard. Each returns a reference to one of the six pages     
   // in the wizard. 
    
   public PageReference step1(){
        PageReference returnPage = getPage(Page.OB_Step1);
        if (returnPage.getUrl()==Page.OB_Step1.getUrl()){
            saveCandidate();
        }
        return returnPage;
   }

   public PageReference step2(){
        PageReference returnPage = getPage(Page.OB_Step2);
        if (returnPage.getUrl()==Page.OB_Step2.getUrl()){
            saveCandidate();
        }
        return returnPage;
   }

   public PageReference step3(){
        PageReference returnPage = getPage(Page.OB_Step3);
        if (returnPage.getUrl()==Page.OB_Step3.getUrl()){
            saveCandidate();
        }
        return returnPage;
   }
   
   public PageReference step4(){
        PageReference returnPage = getPage(Page.OB_Step4);
        if (returnPage.getUrl()==Page.OB_Step4.getUrl()){
            saveCandidate();
        }
        return returnPage;
   }   
   
   public PageReference step5(){
        PageReference returnPage = getPage(Page.OB_Step5);
        if (returnPage.getUrl()==Page.OB_Step5.getUrl()){
            saveCandidate();
        }
        return returnPage;
   }
    
   public PageReference step6(){
        PageReference returnPage = getPage(Page.OB_Step6);
        if (returnPage.getUrl()==Page.OB_Step6.getUrl()){
            saveCandidate();
        }
        return returnPage;
   }
   
   public string getICPDocument(){
   	 return candidate.Business_Unit__c+'/'+candidate.Bonus_Level__c.replaceAll('%', '').replaceAll(' ', '').replaceAll('-', '')+'.doc';
   }
    
   public PageReference finalSubmit(){ 
        PageReference returnPage = getPage(Page.OB_Confirmation);
        if (returnPage.getUrl()!=Page.OB_Confirmation.getUrl())
            return returnPage;
        saveCandidateStatus();    
        List<Attachment> a = [select id from attachment where parentid = :candidate.id];
        if(a.size() > 0){
            delete a;
        } 
        System.debug('Final Submit');
        PageReference aPage = Page.OB_DirectDeposit_PDF;
        aPage.getParameters().put('id',candidate.id);
        savePdf(aPage, 'DirectDeposit.pdf');
        aPage = Page.OB_NewHireInfo_pdf;
        aPage.getParameters().put('id',candidate.id);
        savePdf(aPage, 'NewHireInfo.pdf');
        aPage = Page.OB_W4_PDF;
        aPage.getParameters().put('id',candidate.id);
        savePdf(aPage, 'W4.pdf');
        candidateStatus.ISComplete__c = True;
        candidate.Passcode__c = 'XXX';
        saveCandidate();
        return returnPage;  
    }

   public void saveCandidate(){     
        update candidate;  
        Candidate_Status__c[] oCandidateStatus  = Database.query('Select id from Candidate_Status__c where  Candidate__c=\''+candidate.Id+'\'');           
        if(oCandidateStatus.size()==0) 
            insert candidateStatus;
        saveCandidateStatus();    
   }

   public void saveCandidateStatus(){     
        update candidateStatus;
   }

    public List<SelectOption> getVetStatus() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Yes','Yes')); 
        options.add(new SelectOption('No','No')); 
        return options; 
    }

 public void savePdf(PageReference pdf, string name) { 
    Attachment attach = new Attachment();
    Blob body; 
 //   try {
        body = pdf.getContent();
   // } 
  //  catch (VisualforceException e) {
  //      body = Blob.valueOf(e.getStackTraceString());
  //  }
    attach.Body = body;
    attach.Name = name;
    attach.IsPrivate = false;
    attach.ParentId = candidate.id;
    insert attach;
  }

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
        candidate = Database.query('Select ' +selectFields + ' from Candidate__c where  Email__c=\''+candidate.Email__c+'\'');  
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