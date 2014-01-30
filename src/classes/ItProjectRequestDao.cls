/*
@Name            : ItProjectRequestDao
@Author          : Satoshi Haga
@Date            : July 29, 2013
@Description     : Data Access Class for IT_Project_Request__c
@version         : 07/29/2013 First Creation
*/
public class ItProjectRequestDao extends JapanDao{

	/**
	 * Constructor
	 * @param strFunctionalName functional name for logging
	 */
	public ItProjectRequestDao(String strFunctionalName){
		super(strFunctionalName, new IT_Project_Request__c().getSObjectType());
	}


}