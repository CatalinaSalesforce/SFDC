public class ProgramViewRedirect{

    public ProgramViewRedirect(ApexPages.StandardController controller) {

    }

String pro = ApexPages.currentPage().getParameters().get('id');

public PageReference redirect() {
String url='/'+ ApexPages.currentPage().getParameters().get('id') + '?nooverride=1';
Program__c prort = [SELECT Name,RecordType.Name FROM Program__c WHERE id = :ApexPages.currentPage().getParameters().get('Id') LIMIT 1];
  if ('Contract'.equals(prort.RecordType.Name) || 'Proposal'.equals(prort.RecordType.name) || 'Renewal'.equals(prort.RecordType.Name) || 'Recovery'.equals(prort.RecordType.Name)) 
      {
       PageReference ProgramViewLayout =  Page.ProgramViewLayout;
       ProgramViewLayout.setRedirect(true);
       ProgramViewLayout.getParameters().put('id', pro);
       return ProgramViewLayout;
      } 
      else {
          PageReference page=new PageReference(url);
          page.setRedirect(true);
          return page;
      }
   }
}