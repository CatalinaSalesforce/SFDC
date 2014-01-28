public class ProgramEditRedirect{

    public ProgramEditRedirect(ApexPages.StandardController controller) {

    }

String pro = ApexPages.currentPage().getParameters().get('id');

public PageReference redirect() {
String url='/'+ ApexPages.currentPage().getParameters().get('id') + '?nooverride=1';
Program__c prort = [SELECT Name,RecordType.Name FROM Program__c WHERE id = :ApexPages.currentPage().getParameters().get('Id') LIMIT 1];
  if ('Contract'.equals(prort.RecordType.Name) || 'Proposal'.equals(prort.RecordType.name) || 'Renewal'.equals(prort.RecordType.Name) || 'Recovery'.equals(prort.RecordType.Name)) 
      {
       PageReference ProgramEditLayout =  Page.ProgramEditLayout;
       ProgramEditLayout.setRedirect(true);
       ProgramEditLayout.getParameters().put('id', pro);
       return ProgramEditLayout;
      } 
      else {
       PageReference Edit_Program =  Page.Edit_Program;
       Edit_Program.setRedirect(true);
       Edit_Program.getParameters().put('id', pro);
       return Edit_Program;
      } 
   }
}