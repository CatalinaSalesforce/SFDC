/*
@Name            : ClientMasterExtension
@Author          : Satoshi Haga
@Date            : Sep 14, 2013
@Description     : Extension class for visualforce pages of ClientMaster__c
@version         : 09/14/2013 First Creation
*/
public class ClientMasterExtension {

	/** public valiable. these are called from each visualforce page */
	public ClientMaster__c client { get; set; }

	/**
	 * Constructor
	 * @param stdController this is gotten by salesforce standard framwwork when accessing each page.
	 */
	public ClientMasterExtension(ApexPages.StandardController stdController) {

		ClientMasterDao dao = new ClientMasterDao('ClientMasterExtension');
	    client = (ClientMaster__c)dao.getAllColumnData(stdController.getRecord().ID);
	}


  /**
   * Test method
   */
  @isTest(SeeAllData=false)
    public static void unitTest() {

	  /** ClientMaster__c */
	  ClientMaster__c testClient = new ClientMaster__c();
	  testClient.Name = 'Test Client';
	  testClient.ClientNumber__c = '99999';
	  testClient.ClientName__c = 'TestClientName';
	  insert testClient;
	  testClient = ((List<ClientMaster__c>)(new ClientMasterDao('Testing').getAllColumnData())).get(0);


      ApexPages.StandardController clientController = new ApexPages.StandardController(testClient);
      ClientMasterExtension extClient = new ClientMasterExtension(clientController);
      System.assert('99999'.equals(extClient.client.ClientNumber__c));


    }


}