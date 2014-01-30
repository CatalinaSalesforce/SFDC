public with sharing class PartnerAcctMgtController{
    
    class PartnerAccountContact{
        public Id     AccountId{get;set;}
        public string AccountName{get;set;}
        public string AccountNDA{get;set;}
        public string AccountCatalinaLead1{get;set;}
        public string AccountCatalinaLead2{get;set;}
        public string AccountCatalinaLead3{get;set;}
        public string AccountCatalinaLead4{get;set;}
        public string Partnership_Stage{get;set;}
        public string ContactsList{get;set;}
        public string Partnership_Scope{get;set;}
        public string LastContactInfo{get;set;}
        public string Updates_Next_Steps{get;set;}
        
        public PartnerAccountContact(){
           ContactsList = '';
        }    
    }
        
    private PartnerAccountContact           theAccountContact;
    private List<Account>                   PartnerAccountsList{get;set;}
    private List<Contact>                   PartnerContactsList{get;set;}
    public  List<PartnerAccountContact>     PACList{get;set;}
    public  List<User>                      AccountCatalinaLead1{get;set;}
    
    public PartnerAcctMgtController() {
                
        // Get the list of accounts and then its related contacts and build the account-contact object list.
        try {
           
            PACList = new List<PartnerAccountContact>();            
            
            RecordType rt = [Select Id from RecordType where Name = 'Partner' and SobjectType = 'Account' LIMIT 1];
            
            PartnerAccountsList = [SELECT id, partnership_stage__c, Name,NDA__c,Catalina_Leads__c, Lead1f__c, Lead2f__c, Lead3f__c, Lead4f__c,Partnership_Scope__c,Last_Action_Taken__c,Updates_Next_Steps__c From Account where RecordTypeId = :rt.Id ORDER BY NDA__c DESC NULLS LAST];
            
            for(Account acct : PartnerAccountsList){            
                theAccountContact = new PartnerAccountContact();
                theAccountContact.AccountId = acct.Id;
                theAccountContact.AccountName = acct.Name;
                theAccountContact.AccountNDA = acct.NDA__c;
                theAccountContact.AccountCatalinaLead1 = String.valueOf(acct.Lead1f__c);
                theAccountContact.AccountCatalinaLead2 = String.valueOf(acct.Lead2f__c);
                theAccountContact.AccountCatalinaLead3 = String.valueOf(acct.Lead3f__c);
                theAccountContact.AccountCatalinaLead4 = String.valueOf(acct.Lead4f__c);         
                theAccountContact.Partnership_Stage = acct.Partnership_Stage__c;        
                PartnerContactsList = [SELECT id,Name,Title,Email,Phone From Contact where AccountId = :acct.Id ]; 
                for(Contact ct:PartnerContactsList){
                    theAccountContact.ContactsList += ct.Name;
                    if(ct.Title != NULL)
                        theAccountContact.ContactsList += '<br/>' + ct.Title;
                    if(ct.Email != NULL)
                        theAccountContact.ContactsList += '<br/>' + ct.Email;
                    if(ct.Phone != NULL)
                        theAccountContact.ContactsList += '<br/>' + ct.Phone;
                    theAccountContact.ContactsList += '<br/><br/>';
                }
                theAccountContact.Partnership_Scope = lineBreaks(acct.Partnership_Scope__c);
                theAccountContact.LastContactInfo = lineBreaks(acct.Last_Action_Taken__c);
                theAccountContact.Updates_Next_Steps = lineBreaks(acct.Updates_Next_Steps__c);                
                PACList.add(theAccountContact);
            }           
        } 
        catch (exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR , 'Loading Accounts failed'));
        }             
    }
     
    public string lineBreaks(string inText)
    {
       if (inText == null)
           return '';
       else
           return inText.replaceAll('\n','\n<br/>');
    }
    
    public PageReference GeneratePDF(){
    
        PageReference newPage = Page.PartnerAccountMgtReportPdf;
        //newPage.setRedirect(true);
        return newPage;
    }
}