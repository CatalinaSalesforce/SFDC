// CaseClass, Contains Apex Code used in Case Object
// VisualforcePage QuickAccess Layout (Enables a User to Quickly Edit Case Information on the fly, select and send email templates.
// CreatedBy: JBettio 09/18/11
// LastModified: JBettio 09/19/11 2:00 PM

global class CaseController {  
    private final Case cs;
   
        public CaseController(ApexPages.StandardController stdController){
        this.cs = (Case)stdController.getRecord();
        } 
   
    //String TemplateID
    public String TemplateId {public get; public set;}

    //List Folders
    public List<Folder> folder {get;set;}
        
    //List Email Templates located in Folders: Service Cloud Email Templates or My Personal Email Templates
    public List<selectOption> gettemplates() {
        //Pull Picklist Information
        List<selectOption> options = new List<selectOption>(); 
            options.add(new selectOption('', '- None -')); 
            for (EmailTemplate t : [SELECT Id, Name FROM EmailTemplate WHERE Folder.Name ='Service Cloud Email Templates' OR FolderId = :UserInfo.getUserId() ORDER BY Name]) { 
            options.add(new selectOption(t.id, t.Name)); 
            }
        //Return Picklist Options
        return options;
    }   
    
     webservice static Boolean UpdateContact (Id cId)
     {
         Case cs = [SELECT Id, Contact.Name, Contact.FirstName, Contact.LastName, ContactId FROM Case Where Id = :cId];
             try{
         Contact con = [SELECT Id, FirstName, LastName, Email, Phone, MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry FROM Contact
                        WHERE AccountId = :System.currentPageReference().getParameters().get('ContactId') LIMIT 1];
         	cs.Contact.FirstName = con.FirstName;
         
      update con;
      update cs;
      }
        catch(Exception ex){
        System.debug('Error updating contact.');
    }
    return true;
	}
}