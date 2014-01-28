public class OppNewRedirect{

public OppNewRedirect(ApexPages.StandardController controller) {
}
    String opp = ApexPages.currentPage().getParameters().get('id');
    String rType = ApexPages.currentPage().getParameters().get('RecordType');
    String retURL = '/006/o';

public PageReference redirect() {
String url='/'+ApexPages.currentPage().getParameters().get('id');
RecordType opprt = [SELECT Name FROM RecordType WHERE id = :ApexPages.currentPage().getParameters().get('RecordType') LIMIT 1];
  if ('Contract'.equals(opprt.Name) || 'Proposal'.equals(opprt.name) || 'Renewal'.equals(opprt.Name) || 'Recovery'.equals(opprt.Name)) 
      {
       PageReference OppEditLayout =  Page.OppEditLayout;
       OppEditLayout.setRedirect(true);
       OppEditLayout.getParameters().put('id', opp);
       OppEditLayout.getParameters().put('RecordType', rType);
       OppEditLayout.getParameters().put('retURL',retURL);
       return OppEditLayout;
      } 
      else {
          PageReference page=new PageReference('/006/e?nooverride=1&retURL=/006/o');
          page.setRedirect(true);
          return page;
      }
   }
}