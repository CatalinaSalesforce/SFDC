/*
@Name            : StoreInfoDao
@Author          : Satoshi Haga
@Date            : Oct 1, 2013
@Description     : Data Access Class for StoreInfo__c
@version         : 10/01/2013 First Creation
*/
public class StoreInfoDao extends JapanDao{

	/**
	 * Constructor
	 * @param strFunctionalName functional name for logging
	 */
	public StoreInfoDao(String strFunctionalName){
		super(strFunctionalName, new StoreInfo__c().getSObjectType());
	}

	/**
	 * Test method
	 */
	@isTest(SeeAllData=false)
    public static void unitTest() {
    	System.assert('StoreInfo__c'.equals(new StoreInfoDao('Test').strTableName));
    }

}