/*
@Name            : JapanUserTableDao
@Author          : Satoshi Haga
@Date            : July 1, 2013
@Description     : Data Access Class for JapanUserTable__c
@version         : 07/01/2013 First Creation
*/
public class JapanUserTableDao extends JapanDao{

  /**
   * Constructor
   * @param strFunctionalName functional name for logging
   */
  public JapanUserTableDao(String strFunctionalName){
    super(strFunctionalName, new JapanUserTable__c().getSObjectType());
  }


  /**
   * Get client list by responsible name
   * @param strUserName responsible name
   */

  public List<String> getClientList(String strUserName){

    //Get user info
    Map<String, String> mapUserName = new Map<String, String>();
    System.debug('strUserName='+strUserName);
    mapUserName.put('UserName__c', strUserName);
    JapanUserTable__c userJapan = ((List<JapanUserTable__c>)getValue(mapUserName)).get(0);

    //extract client information
    List<String> lstClient = new List<String>();

    if(userJapan.Client1__c != null) lstClient.add(String.valueOf(userJapan.Client1__c));
    if(userJapan.Client2__c != null) lstClient.add(String.valueOf(userJapan.Client2__c));
    if(userJapan.Client3__c != null) lstClient.add(String.valueOf(userJapan.Client3__c));
    if(userJapan.Client4__c != null) lstClient.add(String.valueOf(userJapan.Client4__c));
    if(userJapan.Client5__c != null) lstClient.add(String.valueOf(userJapan.Client5__c));
    if(userJapan.Client6__c != null) lstClient.add(String.valueOf(userJapan.Client6__c));
    if(userJapan.Client7__c != null) lstClient.add(String.valueOf(userJapan.Client7__c));
    if(userJapan.Client8__c != null) lstClient.add(String.valueOf(userJapan.Client8__c));
    if(userJapan.Client9__c != null) lstClient.add(String.valueOf(userJapan.Client9__c));
    if(userJapan.Client10__c != null) lstClient.add(String.valueOf(userJapan.Client10__c));

    return lstClient;

  }

  /**
   * Test method
   */
  @isTest(SeeAllData=false)
    public static void unitTest() {
      //Preparation for testing.

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

      JapanUserTableDao dao = new JapanUserTableDao('Test User');

      List<String> listClient = dao.getClientList('Test User');
      System.assert(listClient.size() == 10);
    }



}