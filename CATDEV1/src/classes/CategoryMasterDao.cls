/*
@Name            : CategoryMasterDao
@Author          : Satoshi Haga
@Date            : July 1, 2013
@Description     : Data Access Class for CategoryMaster__c
@version         : 11/10/2013 First Creation
*/
public class CategoryMasterDao extends JapanDao{

  /**
   * Constructor
   * @param strFunctionalName functional name for logging
   */
  public CategoryMasterDao(String strFunctionalName){
    super(strFunctionalName, new CategoryMaster__c().getSObjectType());
  }

  /**
   * Test method
   */
  @isTest(SeeAllData=false)
  public static void unitTest() {
  	CategoryMasterDao cateDao = new CategoryMasterDao('Testing');
	System.assert('CategoryMaster__c'.indexOf(cateDao.strTableName) >= 0);
  }


}