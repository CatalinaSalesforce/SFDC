/*
@Name            : WireringIssueManagementDao
@Author          : Satoshi Haga
@Date            : Oct 1, 2013
@Description     : Data Access Class for WireringIssueManagement__c
@version         : 10/01/2013 First Creation
*/
public class WireringIssueManagementDao extends JapanDao{

	/**
	 * Constructor
	 * @param strFunctionalName functional name for logging
	 */
	public WireringIssueManagementDao(String strFunctionalName){
		super(strFunctionalName, new WireringIssueManagement__c().getSObjectType());
	}

	/**
	 * Test method
	 */
	@isTest(SeeAllData=false)
    public static void unitTest() {
    	System.assert('WireringIssueManagement__c'.equals(new WireringIssueManagementDao('Test').strTableName));
    }


}