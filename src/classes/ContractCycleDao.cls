/*
@Name            : ContractCycleDao
@Author          : Satoshi Haga
@Date            : July 1, 2013
@Description     : Data Access Class for ContractCycle__c
@version         : 07/01/2013 First Creation
*/
public class ContractCycleDao extends JapanDao{

  /**
   * Constructor
   * @param strFunctionalName functional name for logging
   */
  public ContractCycleDao(String strFunctionalName){
    super(strFunctionalName, new ContractCycle__c().getSObjectType());
  }

  /**
   * Searching function. Seach records by id, which is returned from AwardDao
   * @param criteria criteria for searching
   * @return List<ID>  the ld list of ConstarcCycle
   */
  public List<ContractCycle__c> searchForProgramSearch(PlanSearchCriteria__c criteria){


    //Pick ids from criteria by calling AwardDao
    AwardDao dao = new AwardDao('ContractCycleDao');
    List<ID> listId = dao.getIdList(criteria);
    List<ContractCycle__c> subRetObj = (List<ContractCycle__c>)getAllColumnData(listId);

    //Filter this result if card condition or VPIN condition is selected on program-search page
    return filterObject(subRetObj, criteria);
  }

  /**
   * Filter function. Filter by parametered criteria
   * @param source   target of filtering
   * @param criteria criteria for searching
   * @return List<ContractCycle__c>  the result after flitering
   */
  public List<ContractCycle__c> filterObject(List<ContractCycle__c>  source, PlanSearchCriteria__c criteria){

    List<ContractCycle__c> retObj = new List<ContractCycle__c>();
    for(ContractCycle__c conCyc : source){
      Boolean addFlg = true;
      if(criteria.chkVPIN__c == true && conCyc.chkVPIN__c == false){
        addFlg = false;
      }

      if(criteria.chkCOD__c == true && conCyc.chkCOD__c == false){
        addFlg = false;
      }

      if(criteria.chkBGT__c == true && conCyc.chkBGT__c == false){
        addFlg = false;
      }

      if(criteria.chkCustomG__c == true && conCyc.chkCustomG__c == false){
        addFlg = false;
      }

      if(addFlg == true){
        retObj.add(conCyc);
      }

    }

    //return the result
    return retObj;
  }

  /**
   * Test method
   */
  @isTest(SeeAllData=false)
    public static void unitTest() {

      ContractCycleDao dao = new ContractCycleDao('This is test');

      List<ContractCycle__c> result = dao.searchForProgramSearch(new PlanSearchCriteria__c());
      System.assert((result == null || result.size() == 0));

      List<ContractCycle__c>  source = new List<ContractCycle__c>();
      ContractCycle__c sourceCon = new ContractCycle__c();
      sourceCon.chkVPIN__c = false;
      sourceCon.chkCOD__c = false;
      sourceCon.chkBGT__c = false;
      sourceCon.chkCustomG__c = false;
      source.add(sourceCon);

      PlanSearchCriteria__c criteria = new PlanSearchCriteria__c();
      criteria.chkVPIN__c = true;
      criteria.chkCOD__c = true;
      criteria.chkBGT__c = true;
      criteria.chkCustomG__c = true;

      result = dao.filterObject(source,criteria);

    System.assert(result.size() == 0);

    }




}