/*
@Name            : JapanConstantsDao
@Author          : Satoshi Haga
@Date            : July 1, 2013
@Description     : Data Access Class for JapanConstants__c
@version         : 07/01/2013 First Creation
*/
public class JapanConstantsDao extends JapanDao{

  /**
   * Constructor
   * @param strFunctionalName functional name for logging
   */
  public JapanConstantsDao(String strFunctionalName){
    super(strFunctionalName, new JapanConstants__c().getSObjectType());
  }

  /**
   * Test method
   */
  @isTest(SeeAllData=false)
    public static void unitTest() {

      /** Preparetion for Testing */
      JapanConstants__c constJ = new JapanConstants__c();
      constJ.TypeA__c = 'ExceptionWarningMessage';
      constJ.TypeB__c = 'Alert1';
      constJ.Value__c = '015K00000009qwY';
      insert constJ;

      constJ = new JapanConstants__c();
      constJ.TypeA__c = 'ExceptionWarningMessage';
      constJ.TypeB__c = 'Alert2';
      constJ.Value__c = '015K00000009qwd';
      insert constJ;

      constJ = new JapanConstants__c();
      constJ.TypeA__c = 'ExceptionWarningMessage';
      constJ.TypeB__c = 'Alert3';
      constJ.Value__c = '015K00000009qwi';
      insert constJ;

      constJ = new JapanConstants__c();
      constJ.TypeA__c = 'ExceptionWarningMessage';
      constJ.TypeB__c = 'Alert4';
      constJ.Value__c = '015K00000009qwn';
      insert constJ;

      constJ = new JapanConstants__c();
      constJ.TypeA__c = 'ExceptionWarningMessage';
      constJ.TypeB__c = 'Alert5';
      constJ.Value__c = '015K00000009qws';
      insert constJ;

      constJ = new JapanConstants__c();
      constJ.TypeA__c = 'ExceptionWarningMessage';
      constJ.TypeB__c = 'Alert6';
      constJ.Value__c = '015K00000009qwx';
      insert constJ;

      constJ = new JapanConstants__c();
      constJ.TypeA__c = 'ExceptionWarningMessage';
      constJ.TypeB__c = 'Alert7';
      constJ.Value__c = '015K00000009qx2';
      insert constJ;


      JapanConstantsDao dao = new JapanConstantsDao('unitTest');

      //Test for JapanDao.
      List<JapanConstants__c> cList1 = [select id from JapanConstants__c];
    List<JapanConstants__c> cList2 = (List<JapanConstants__c>)dao.execute('select id from JapanConstants__c');

    System.assert(cList1.size() == cList2.size());

    List<JapanConstants__c> cList3 = (List<JapanConstants__c>)dao.getAllColumnData('');
    System.assert(cList1.size() == cList3.size());

    List<JapanConstants__c> cList35 = (List<JapanConstants__c>)dao.getAllColumnData();
    System.assert(cList1.size() == cList35.size());


    List<JapanConstants__c> cList4 = (List<JapanConstants__c>)dao.getAllColumnData('TypeA__c = \'ExceptionWarningMessage\'');
    System.assert(cList4.size() == 7);

    List<ID> listId = new List<ID>();
    for(JapanConstants__c constant : cList4){
      listId.add(constant.id);
    }

    List<JapanConstants__c> cList5 = (List<JapanConstants__c>)dao.getAllColumnData(listId);
    System.assert(cList5.size() == 7);

    JapanConstants__c constt55 = (JapanConstants__c)dao.getAllColumnData(listId.get(0));
    System.assert(constt55.ID == listId.get(0));

    List<JapanConstants__c> cList6 = (List<JapanConstants__c>)dao.getReferencedList('ID',listId.get(0));
    System.assert(cList6.size() == 1);

    List<JapanConstants__c> cList7 = (List<JapanConstants__c>)dao.getReferencedListWithOrderKey('ID',listId.get(0), 'ID');
    System.assert(cList7.size() == 1);

    List<JapanConstants__c> cList8 = (List<JapanConstants__c>)dao.getReferencedListWithReverseOrderKey('ID',listId.get(0), 'ID');
    System.assert(cList8.size() == 1);

    Map<String, String> mapObj = new Map<String, String>();
    mapObj.put('TypeA__c', 'ExceptionWarningMessage');
    List<JapanConstants__c> cList9 =  (List<JapanConstants__c>)dao.getValue(mapObj);
    System.assert(cList9.size() == 7);

    }




}