/*
@Name            : ClientMasterDao
@Author          : Satoshi Haga
@Date            : July 1, 2013
@Description     : Data Access Class for ClientMaster__c
@version         : 08/20/2013 First Creation
*/
public class ClientMasterDao extends JapanDao{

  /**
   * Constructor
   * @param strFunctionalName functional name for logging
   */
  public ClientMasterDao(String strFunctionalName){
    super(strFunctionalName, new ClientMaster__c().getSObjectType());
  }


  /**
   * Get client list from responsible name.
   * @param strResponsible   responsible name.
   */
  public List<String> getClientList(String strResponsible){

    //Get client number list for Jpaan user table
    JapanUserTableDao userDao = new JapanUserTableDao('ClientMasterDao');
    List<String> userList = userDao.getClientList(strResponsible);

    //Convert from client number to ID
    List<String> listID = new List<String>();

    for(String clientNumber : userList){
      Map<String,String> param = new  Map<String,String>();
      param.put('ClientNumber__c',clientNumber);
      ClientMaster__c cli = ((List<ClientMaster__c>)getValue(param)).get(0);

      listID.add(((String)cli.ID).substring(0,15));
    }

    //Return list
    return listID;

  }

  /**
   * Test method
   */
  @isTest(SeeAllData=false)
    public static void unitTest() {
      ClientMasterDao dao = new ClientMasterDao('Testing');
      System.assert('ClientMaster__c'.equals(dao.strTableName));


    JapanUserTable__c testUser = new JapanUserTable__c();
      testUser.UserName__c = 'Test User';
      testUser.Client1__c = 2431;
      testUser.Client2__c = 2431;
      testUser.Client3__c = 2431;
      testUser.Client4__c = 2431;
      testUser.Client5__c = 2431;
      testUser.Client6__c = 2431;
      testUser.Client7__c = 2431;
      testUser.Client8__c = 2431;
      testUser.Client9__c = 2431;
      testUser.Client10__c = 2431;
      insert testUser;

    ClientMaster__c testClient = new ClientMaster__c();
    testClient.Name = 'Test Client';
    testClient.ClientName__c = 'Test Client';
    testClient.ClientNumber__c = '2431';
    insert testClient;


      List<String> listClient = dao.getClientList('Test User');
      System.assert(listClient.size() == 10);


    }


}