public with sharing class PartnerAcctSearchController {
  public String Range {get; set;}
  // the soql without the order and limit
  private String soql {get;set;}
  // the collection of contacts to display
  public String contactRange{get;set;}
  public List<Account> acct {get;set;}
  // the current sort direction. defaults to asc
  public String sortDir {
    get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
    set;
  }
 
  // the current field to sort by. defaults to last name
  public String sortField {
    get  { if (sortField == null) {sortField = 'Name'; } return sortField;  }
    set;
  }
 
  // format the soql for display on the visualforce page
  public String debugSoql {
    get { return soql + ' order by ' + sortField + ' ' + sortDir; }
    set;
  }
 
  // init the controller and display some sample data when the page loads
  public PartnerAcctSearchController() {
    soql = 'select (select Id, Account.Style__c, IsPersonAccount, Name, Email, Title, Phone FROM Contacts ORDER BY LastModifiedDate LIMIT 1), style__c, concept_score__c, Partnership_Scope__c , Updates_Next_Steps__c, owner.name, partnership_stage__c, name, last_contact_date__c, next_contact_date__c, Area_Of_Partnership__c from Account where partner_account__c = true and Partner_Account_Inactive__c = false';
    runQuery();
  }
 
  // toggles the sorting of query from asc<-->desc
  public void toggleSort() {
    // simply toggle the direction
    sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
    // run the query again
    runQuery();
  }
 
  // runs the actual query
  public void runQuery() {
 
    try {
      acct = Database.query(soql + ' order by ' + sortField + ' ' + sortDir);
    } catch (Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'));
    }
 
  }
 
  // runs the search with parameters passed via Javascript
  public PageReference runSearch() {
 
    String ownerName = Apexpages.currentPage().getParameters().get('ownerName');
    String stageName = Apexpages.currentPage().getParameters().get('stagename');
    String accountName = Apexpages.currentPage().getParameters().get('accountName');
    String conceptScore = Apexpages.currentPage().getParameters().get('conceptScore');
    String areaName = Apexpages.currentPage().getParameters().get('areaName');
    String dateRange = Apexpages.currentPage().getParameters().get('dateRange');
 
    soql = 'select (select Id, Name, Account.Style__c, Email, Title, Phone FROM Contacts ORDER BY LastModifiedDate LIMIT 1), style__c, Concept_Score__c, Partnership_Scope__c , Updates_Next_Steps__c, owner.name, partnership_stage__c, last_contact_date__c, next_contact_date__c, Area_Of_Partnership__c, name from account where partner_account__c = true and Partner_Account_Inactive__c = false';
    if (!ownerName.equals(''))
      soql += ' and owner.name LIKE \''+String.escapeSingleQuotes(ownerName)+'%\'';
    if (!stageName.equals(''))
      soql += ' and partnership_stage__c = \''+String.valueOf(stageName)+'\'';
    if (!accountName.equals(''))
      soql += ' and name LIKE \''+String.escapeSingleQuotes(accountName)+'%\'';  
    if (!conceptScore.equals(''))
      soql += ' and Concept_Score__c >= '+ String.valueOf(conceptScore);  
    //if (!dateRange.equals(''))
      //soql += ' and '  + String.valueOf(dateRange);
    if (contactRange != null)
      soql += ' and '  + String.valueOf(contactRange );
    if (!areaName.equals(''))
      soql += ' and Area_of_Partnership__c INCLUDES (\''+areaName+'\')'; 
    // run the query again
    runQuery();
 
    return null;
  }

  // use apex describe to build the picklist values
  public List<String> stageName{
    get {
      if (stageName == null) {
 
        stageName = new List<String>();
        Schema.DescribeFieldResult field = Account.partnership_stage__c.getDescribe();
 
        for (Schema.PicklistEntry f : field.getPicklistValues())
          stageName.add(f.getLabel());
 
      }
      return stageName;          
    }
    set;
  }

  public List<String> areaName{
    get {
      if (areaName == null) {
 
       areaName = new List<String>();
        Schema.DescribeFieldResult field = Account.Area_Of_Partnership__c.getDescribe();
 
        for (Schema.PicklistEntry f : field.getPicklistValues())
          areaName.add(f.getLabel());
 
      }
      return areaName;          
    }
    set;
  }
    
  public List<SelectOption> getdateRange() {
    List<SelectOption> dateRange = new List<SelectOption>();
    dateRange.add(new SelectOption('(next_contact_date__c <> null OR next_contact_date__c = null)',''));
    dateRange.add(new SelectOption('(next_contact_date__c >= next_n_days:30)','Next 30 Days'));
    dateRange.add(new SelectOption('(next_contact_date__c >= next_n_days:60)','Next 60 Days')); 
    dateRange.add(new SelectOption('(next_contact_date__c >= next_n_days:90)','Next 90 Days'));
    dateRange.add(new SelectOption('(next_contact_date__c >= next_n_days:365)','Next 1 Year'));
    
    Range = dateRange[2].getValue();
    
    return dateRange;
}

}