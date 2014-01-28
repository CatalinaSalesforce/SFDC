/*
@Name            : ChainInfoDao
@Author          : Satoshi Haga
@Date            : Oct 1, 2013
@Description     : Data Access Class for ChainInfo__c
@version         : 10/01/2013 First Creation
*/
public class ChainInfoDao extends JapanDao{

	/**
	 * Constructor
	 * @param strFunctionalName functional name for logging
	 */
	public ChainInfoDao(String strFunctionalName){
		super(strFunctionalName, new ChainInfo__c().getSObjectType());
	}


	/**
	 * Test method
	 */
	@isTest(SeeAllData=false)
    public static void unitTest() {
    	System.assert('ChainInfo__c'.equals(new ChainInfoDao('Test').strTableName));
    }

}