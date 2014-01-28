public class OppEditRedirect{

    public OppEditRedirect(ApexPages.StandardController controller) {

    }

String opp = ApexPages.currentPage().getParameters().get('id');

public PageReference redirect() {
String url='/'+ ApexPages.currentPage().getParameters().get('id') + '/' + 'e?retURL=' + ApexPages.currentPage().getParameters().get('id') + '&nooverride=1';
Opportunity opprt = [SELECT Name,RecordType.Name FROM Opportunity WHERE id = :ApexPages.currentPage().getParameters().get('Id') LIMIT 1];
  if ('Contract'.equals(opprt.RecordType.Name) || 'Proposal'.equals(opprt.RecordType.name) || 'Renewal'.equals(opprt.RecordType.Name) || 'Recovery'.equals(opprt.RecordType.Name)) 
      {
       PageReference oppUSView =  Page.OppEditLayout;
       oppUSView.setRedirect(true);
       oppUSView.getParameters().put('id', opp);
       return oppUSView;
      } 
      else {
          PageReference page=new PageReference(url);
          page.setRedirect(true);
          return page;
      }
   }
}