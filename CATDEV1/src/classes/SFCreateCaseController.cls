public class SFCreateCaseController {

    public SFCreateCaseController() {
        c = new Case();
    }      
    
    public Case c { get; set; }
    
    public String acctNum { get; set; }

    public ID id = ApexPages.CurrentPage().getParameters().get('id');    
    
    public PageReference submitTicket() {
            try {
        RecordType rt = [select Id from RecordType where Name = 'SF Case' and SobjectType = 'Case' limit 1];     
        Group ffGroup = [SELECT Id FROM Group Where Type = 'Queue' and Name = 'SF Case Queue' Limit 1];
        c.OwnerId = ffGroup.Id;
        c.Status = 'New';
        c.RecordTypeId = rt.Id;
        c.Submitted_by__c = UserInfo.getUserId();  
                 
                insert c;
                            
                Id = c.Id;
                
                PageReference pageRef = new PageReference('/apex/submitted');                
                String myId =  ApexPages.currentPage().getParameters().get('c.Id');
                pageRef.getParameters().put('id', c.Id);
                pageRef.setRedirect(true);
                return pageRef;
             
            } catch (Exception e) {
                ApexPages.addMessages(e);
                return null;
            }
        }
}