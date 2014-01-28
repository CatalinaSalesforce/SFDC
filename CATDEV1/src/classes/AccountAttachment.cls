public class AccountAttachment {
 public List<Account> Records { get; set; }    
 public Id MoreRecordId {get; set; }
 public Account MoreRecord {get; set;} 
    public ApexPages.StandardSetController contactSet {
        
        get {
            if(contactSet == null) {
                contactSet = new         
                ApexPages.StandardSetController(Database.getQueryLocator(
                
                [Select Name, Parent.Name,
                (Select Id, Name, LastModifiedDate
                 From Attachments WHERE Name LIKE 'Account Plan%' 
                 Order By LastModifiedDate DESC)         
             From Account WHERE Status__c = 'Platinum' 
             Order By Parent.Name ASC]));
            contactSet.setPageSize(1000);
            }
            return contactSet;
        }
        set;
    }

    public List<Account> getContacts() {
         return (List<Account>) contactSet.getRecords();
    }
    {
        Records =  
            [Select Name, Parent.Name,
                (Select Id, Name, LastModifiedDate
                 From Attachments WHERE Name LIKE 'Account Plan%' 
                 Order By LastModifiedDate DESC)         
             From Account t WHERE Status__c ='Platinum' Order By Parent.Name ASC]; 
    }

    public PageReference showMore()
    {
        MoreRecord = new Map<Id, Account>(Records).get(MoreRecordId);
        return null;
    }
    
}