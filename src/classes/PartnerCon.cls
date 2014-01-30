public class PartnerCon {

 public List<Account> pRecords { get; set; }    
 public Id MoreRecordId {get; set; }
 public Account MoreRecord {get; set;} 
 public String rangedate {get; set;}
    Date candDate=System.today();
    
 public  Date candDate1{
 get{
 if(rangedate==null){ rangedate='0';}
 Date tempdate = candDate.addDays(-Integer.valueOf(rangedate));
 
 return tempdate;
 }
 set;
 }

 
    public ApexPages.StandardSetController contactSet {
        
        get {
            if(contactSet == null && rangeDate == null) {
                contactSet = new         
                ApexPages.StandardSetController(Database.getQueryLocator(
                
                [Select Next_Contact_Range__c, Last_Contact_Date__c, Next_Contact_Date__c, Owner.Name, Owner.Title, Area_Of_Partnership__c, lastmodifieddate, id, Lead1__r.Name, Lead1__r.Title, Lead2__r.Name, Lead2__r.Title, Lead3__r.Name, Lead3__r.Title, Lead4__r.Name, Lead4__r.Title, partnership_stage__c, Name,NDA__c,Catalina_Leads__c, Lead1f__c, Lead2f__c, Lead3f__c, Lead4f__c,Partnership_Scope__c,Last_Action_Taken__c,Updates_Next_Steps__c, Style__c,
                (Select id, Name, Title, Email, Phone From Contacts ORDER BY LastModifiedDate ASC LIMIT 1)         
             From Account t WHERE RecordType.Name = 'Partner'// ORDER BY LastModifiedDate ASC - not recognizing in jQuery, no need to cause query to run longer if it doesn't work//
             ]));
            contactSet.setPageSize(1000);
            }
            else if(contactSet == null && rangeDate != null) {
                contactSet = new         
                ApexPages.StandardSetController(Database.getQueryLocator(
                
                [Select Last_Contact_Date__c, Next_Contact_Date__c, Owner.Name, Owner.Title, Area_Of_Partnership__c, lastmodifieddate, id, Lead1__r.Name, Lead1__r.Title, Lead2__r.Name, Lead2__r.Title, Lead3__r.Name, Lead3__r.Title, Lead4__r.Name, Lead4__r.Title, partnership_stage__c, Name,NDA__c,Catalina_Leads__c, Lead1f__c, Lead2f__c, Lead3f__c, Lead4f__c,Partnership_Scope__c,Last_Action_Taken__c,Updates_Next_Steps__c, Style__c,
                (Select id, Name, Title, Email, Phone From Contacts ORDER BY LastModifiedDate ASC LIMIT 1)         
             From Account t WHERE RecordType.Name = 'Partner' AND Next_Contact_Date__c >= :candDate1 // ORDER BY LastModifiedDate ASC - not recognizing in jQuery, no need to cause query to run longer if it doesn't work//
             ]));
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
        pRecords =  
            [Select Area_Of_Partnership__c, lastmodifieddate, Owner.Name, Owner.Title, Lead1__r.Name, Lead1__r.Title, Lead2__r.Name, Lead2__r.Title, Lead3__r.Name, Lead3__r.Title, Lead4__r.Name, Lead4__r.Title, style__c, id, partnership_stage__c, Name,NDA__c,Catalina_Leads__c, Lead1f__c, Lead2f__c, Lead3f__c, Lead4f__c,Partnership_Scope__c,Last_Action_Taken__c,Updates_Next_Steps__c, 
                (Select id, Name, Title, Email, Phone From Contacts ORDER BY LastModifiedDate ASC LIMIT 1)         
             From Account t WHERE RecordType.Name = 'Partner' // Order By LastModifiedDate ASC //
             ];
    }

    public PageReference showMore()
    {
        MoreRecord = new Map<Id, Account>(PRecords).get(MoreRecordId);
        return null;
    }
    
}