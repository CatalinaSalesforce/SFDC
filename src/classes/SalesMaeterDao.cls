/*
@Name            : SalesMaeterDao
@Author          : Satoshi Haga
@Date            : July 1, 2013
@Description     : Data Access Class for SalesMaeter__c
@version         : 08/01/2013 First Creation
*/
public class SalesMaeterDao extends JapanDao{

  /**
   * Constructor
   * @param strFunctionalName functional name for logging
   */
  public SalesMaeterDao(String strFunctionalName){
    super(strFunctionalName, new SalesMaeter__c().getSObjectType());
  }

  /**
   * Test method
   */
  @isTest(SeeAllData=false)
  public static void unitTest() {
  	SalesMaeterDao dao = new SalesMaeterDao('Testing');
	System.assert('SalesMaeter__c'.indexOf(dao.strTableName) >= 0);
  }



}