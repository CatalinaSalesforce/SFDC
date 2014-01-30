/*
@Name            : JanrequestDao
@Author          : Satoshi Haga
@Date            : Oct 10, 2013
@Description     : Data Access Class for JAN_CHANGE__c
@version         : 10/10/2013 First Creation
*/
public class JanrequestDao extends JapanDao{

	/**
	 * Constructor
	 * @param strFunctionalName functional name for logging
	 */
	public JanrequestDao(String strFunctionalName){
		super(strFunctionalName, new JAN_CHANGE__c().getSObjectType());
	}


	/**
	 * Test method
	 */
	@isTest(SeeAllData=false)
    public static void unitTest() {
    	System.assert('JAN_CHANGE__c'.equals(new JanrequestDao('Test').strTableName));
    }

}