public class CustomAccountLookUpController {
	public String inputAcc{get;set;}
	public List<Account> accountList{get;set;}
	public CustomAccountLookUpController(){
		inputAcc = ApexPages.currentPage().getParameters().get('acc');
		searchAccount();
	}
	public void searchAccount(){
		System.debug('####'+inputAcc);
		String query;
		if(inputAcc != null && inputAcc.trim().length() > 0){
			query = 'SELECT id, Name from Account WHERE Name like \'%' + inputAcc + '%\' ';
		}else{
			query = 'SELECT id, Name from Account';
		}
		accountList = database.query(query);
	}
}