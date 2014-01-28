/*
@Name            : McluDao
@Author          : Satoshi Haga
@Date            : July 1, 2013
@Description     : Data Access Class for MCLU__c
@version         : 07/01/2013 First Creation
*/
public class McluDao extends JapanDao{

  /**
   * Constructor
   * @param strFunctionalName functional name for logging
   */
  public McluDao(String strFunctionalName){
    super(strFunctionalName, new MCLU__c().getSObjectType());
  }

  /**
   * Searching function. Retrun the ld list of Award, which is parent custom object for MCLU__c
   * @param criteria criteria for searching
   * @return List<ID>  the ld list of Award
   */
  public List<ID> getIdList(PlanSearchCriteria__c criteria){

    //Return Object
    List<MCLU__c> retObj = null;
    String joinString = ' where ';

    //Get Data from Award__c directly
    String strSQL = getSqlStatement(criteria);

    //Execute SOQL
    System.debug('@@@Japan Log@@@JapanDao called@@@ function=' + strFunctionalName + '@@@ Execute Query Start');
    System.debug('@@@Japan Log@@@JapanDao called@@@ query=' + strSQL);
    retObj = (List<MCLU__c>)database.query(strSQL);
    System.debug('@@@Japan Log@@@JapanDao called@@@ function=' + strFunctionalName + '@@@ Execute Query End');

    //ID一覧を取得し、返却
    List<ID> listID = new List<ID>();
    for(MCLU__c mclu : retObj){
       listID.add(mclu.AwardNB__c);
    }

    return listID;
  }

  /**
   * Searching function. Retrun the list of Image Dto
   * @param criteria criteria for searching
   * @return List<ID>  the list of Image Dto
   */
  public List<JapanImageDto>  getImageDto(PlanSearchCriteria__c criteria){

    //Check if there are any need to also search in Award
    Boolean awardFlg = false;
    List<ID> alistID = null;

    if(criteria.Client__c != null
       || criteria.Sales__c != null
       || criteria.Category__c != null
       || (criteria.SearchDateMM__c != null && criteria.SearchDateDD__c != null && criteria.SearchDateYYYY__c != null)
       || criteria.KikakuText__c != null
       || criteria.GoodsText__c != null
       || criteria.AwardFrom__c != null
       || criteria.AwardTo__c != null
       || criteria.checkSpecial__c == true
       || criteria.CheckMessage__c == true
       || criteria.CheckCard__c == true
       || criteria.CheckYobiken__c  == true
       || criteria.CheckPop__c == true
       || criteria.Check__c == true
       || criteria.CheckMax__c == true
       || criteria.CheckTime__c == true){

      AwardDao aDao = new AwardDao('McluDao');
      alistID = aDao.getIdListForImage(criteria);

      if(alistID == null || alistID.size() == 0){
        //There is no need to search in Award

        return new List<JapanImageDto>();
       }

      //There is need to search in Award
      awardFlg = true;
    }

    String joinString = ' where ';

    //Get Data from Award__c directly
    String strSQL = getSqlStatement(criteria);
    if(strSQL != null && strSQL.toUpperCase().indexOf('WHERE') >= 0){
      joinString = ' AND ';
    }
    //Seach in Award
    if(awardFlg == true){
      strSQL = strSQL + joinString + 'AwardNB__c IN :alistID';
    }


    //Execute SOQL
    System.debug('@@@Japan Log@@@JapanDao called@@@ function=' + strFunctionalName + '@@@ Execute Query Start');
    System.debug('@@@Japan Log@@@JapanDao called@@@ query=' + strSQL);
    List<MCLU__c> retObj = (List<MCLU__c>)database.query(strSQL);
    System.debug('@@@Japan Log@@@JapanDao called@@@ function=' + strFunctionalName + '@@@ Execute Query End');

    //Pick id list from the above result. And return it.
    Map<Integer, String> criMap = new Map<Integer, String> ();
    List<JapanImageDto> listImage = new List<JapanImageDto>();

    Integer cnt = 1;
    Integer cntImage = 0;

    JapanImageDto dto = new JapanImageDto();
    for(MCLU__c ret : retObj){
      if(ret.ImageNumber__c != null
         && !criMap.containsKey((Integer)ret.ImageNumber__c)){

        String strImageDesc = JapanUtil.getImage(ret);

        if(cnt == 1){dto = new JapanImageDto();}

        dto.createSub(cnt, ret.ImageID__c, strImageDesc, String.valueOf(((Integer)ret.ImageNumber__c)));

        cnt++;

        if(cnt == 5){
          cnt = 1;
          listImage.add(dto);
        }

        criMap.put((Integer)ret.ImageNumber__c, strImageDesc);

        cntImage++;
      }
    }

    if(cnt != 1){
      listImage.add(dto);
    }

    //Meaage for Image count
    ApexPages.Message message = new ApexPages.Message( ApexPages.severity.INFO, '検索結果は'+ cntImage + '件です。');
    ApexPages.addMessage(message);

    return listImage;
  }

  /**
   * Create the sql statement
   * @param criteria criteria for searching
   * @return String  sql statement
   */
  public String getSqlStatement(PlanSearchCriteria__c criteria){

    String joinString = ' where ';

    //Get Data from Award__c directly
    String strSQL = 'select ' + getAllColumnString() + ' from ' + strTableName;
    //sql statement
    //Image Number
    if(criteria.ImageNumber__c != null){
      strSQL = strSQL + joinString + 'ImageNumber__c = ' + criteria.ImageNumber__c;
      joinString = ' AND ';
    }

    //Mclu(From)
    if(criteria.McluFrom__c != null){
      strSQL = strSQL + joinString + 'NumMCLU__c >=  ' + criteria.McluFrom__c;
      joinString = ' AND ';
    }

    //Mclu(To)
    if(criteria.McluTo__c != null){
      strSQL = strSQL + joinString + 'NumMCLU__c <=  ' + criteria.McluTo__c;
      joinString = ' AND ';
    }

    //Clu(From)
    if(criteria.CluFrom__c != null){
      strSQL = strSQL + joinString + 'CluNB__c >=  ' + criteria.CluFrom__c;
      joinString = ' AND ';
    }

    //Clu(To)
    if(criteria.CluTo__c != null){
      strSQL = strSQL + joinString + 'CluNB__c <=  ' + criteria.CluTo__c;
      joinString = ' AND ';
    }


    //Clu Number
    if(criteria.CouponBarcode__c != null){
      strSQL = strSQL + joinString + 'CluNB__c =  ' + criteria.CouponBarcode__c.substring(5,9);
      joinString = ' AND ';
    }

    //Trigger Number(From)
    if(criteria.TriggerNumFrom__c != null){
      strSQL = strSQL + joinString + 'MinQty__c >=  ' + criteria.TriggerNumFrom__c;
      joinString = ' AND ';
    }

    //Trigger Number(To)
    if(criteria.TriggerNumTo__c != null){
      strSQL = strSQL + joinString + 'MinQty__c <=  ' + criteria.TriggerNumTo__c;
      joinString = ' AND ';
    }

    //Order Amount (From)
    if(criteria.OrderAmountFrom__c != null){
      strSQL = strSQL + joinString + 'OrderAmount__c >=  ' + criteria.OrderAmountFrom__c;
      joinString = ' AND ';
    }

    //Order Amont (To)
    if(criteria.OrderAmountTo__c != null){
      strSQL = strSQL + joinString + 'OrderAmount__c <=  ' + criteria.OrderAmountTo__c;
      joinString = ' AND ';
    }

    //Trigger Amount(From)
    if(criteria.TriggerAmountFrom__c != null){
      strSQL = strSQL + joinString + 'TriggerAmount__c >=  ' + criteria.TriggerAmountFrom__c;
      joinString = ' AND ';
    }

    //Trigger Amount(To)
    if(criteria.TriggerAmountTo__c != null){
      strSQL = strSQL + joinString + 'TriggerAmount__c <=  ' + criteria.TriggerAmountTo__c;
      joinString = ' AND ';
    }

    //Alternative print
    if(criteria.CheckMainAlt__c == true){
         strSQL = strSQL + joinString + 'Main__c = true';
         joinString = ' AND ';
    }

    //Unlimited
    if(criteria.CheckUnlimited__c == true){
         strSQL = strSQL + joinString + 'UL__c = true';
         joinString = ' AND ';
    }

    //Max printing
    if(criteria.CheckMax__c == true){
         strSQL = strSQL + joinString + 'MaxPrint__c != NULL';
         joinString = ' AND ';
    }

    //Time Limitation
    if(criteria.CheckTime__c == true){
         strSQL = strSQL + joinString + ' (StartTime__c != NULL OR EndTime__c != NULL) ';
         joinString = ' AND ';
    }

    //Redeem Quantity
    if(criteria.MiniRedeem__c != null){
      strSQL = strSQL + joinString + 'CouponValue__c >=  ' + criteria.MiniRedeem__c;
      joinString = ' AND ';
    }

    if(criteria.MaxRedeem__c != null){
      strSQL = strSQL + joinString + 'CouponValue__c <=  ' + criteria.MaxRedeem__c;
      joinString = ' AND ';
    }

    if('「あり」のみ'.equals(criteria.sltRedeem__c)){
      strSQL = strSQL + joinString + 'CouponValue__c > 0 ';
      joinString = ' AND ';
    }

    if('「なし」のみ'.equals(criteria.sltRedeem__c)){
      strSQL = strSQL + joinString + 'CouponValue__c = 0 ';
      joinString = ' AND ';
    }

    //Program Type
    if(criteria.chkMFG__c == true || criteria.chkRTL__c == true || criteria.chkCNJP__c == true){
      if(!' where '.equals(joinString)){
        joinString = ' AND ( ';
      }else{
        joinString = ' WHERE ( ';
      }
      if(criteria.chkMFG__c == true ){
        strSQL = strSQL + joinString + 'CouponTypeB__c = \'2\' ';
        joinString = ' OR ';
      }
      if(criteria.chkRTL__c == true ){
        strSQL = strSQL + joinString + 'CouponTypeB__c = \'3\' ';
        joinString = ' OR ';
      }
      if(criteria.chkCNJP__c == true ){
        strSQL = strSQL + joinString + 'CouponTypeB__c = \'4\' ';
        joinString = ' OR ';
      }
      if(' AND ( '.equals(joinString) || ' OR '.equals(joinString)){
        strSQL = strSQL + ' ) ';
      }
    }


    //return sql statement
    return strSQL;
  }


  /**
   * <This is difference from local repository>>
   */


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

      McluDao dao = new McluDao('unitTest');

      /** getIdList */
      PlanSearchCriteria__c criteria = new PlanSearchCriteria__c();
      List<MCLU__c> mList = [select id from MCLU__c];
    criteria.chkMFG__c = true;
    criteria.chkRTL__c = true;
    criteria.chkCNJP__c = true;

      List<ID> idList = dao.getIdList(criteria);
    System.assert(mList.size() == idList.size());

    /** getImageDto */
    List<JapanImageDto> listImageDto = dao.getImageDto(criteria);
    System.assert(listImageDto.size() == 0);

    criteria.AwardFrom__c = 167335;
    criteria.AwardTo__c = 167335;
    criteria.chkMFG__c = true;
    criteria.chkRTL__c = true;
    criteria.chkCNJP__c = true;
    criteria.MiniRedeem__c = 1000;
    criteria.MaxRedeem__c = 100;
    criteria.sltRedeem__c = 'あり';
    listImageDto = dao.getImageDto(criteria);
    System.assert(listImageDto.size() == 0);

    criteria = new PlanSearchCriteria__c();
    criteria.AwardFrom__c = 99999;
    criteria.AwardTo__c = 99999;
    criteria.chkMFG__c = true;
    criteria.chkRTL__c = true;
    criteria.chkCNJP__c = true;
    criteria.MiniRedeem__c = 1000;
    criteria.MaxRedeem__c = 100;
    criteria.sltRedeem__c = 'あり';
    listImageDto = dao.getImageDto(criteria);
    System.assert(listImageDto.size() == 0);

    /** getSqlStatement */
    criteria = new PlanSearchCriteria__c();
    criteria.chkMFG__c = true;
    criteria.chkRTL__c = true;
    criteria.chkCNJP__c = true;
    String strSQL = dao.getSqlStatement(criteria);

    System.assert(strSQL.indexOf('ImageNumber__c') < 0);
    System.assert(strSQL.indexOf('NumMCLU__c >=') < 0);
    System.assert(strSQL.indexOf('NumMCLU__c <=') < 0);
    System.assert(strSQL.indexOf('CluNB__c >=') < 0);
    System.assert(strSQL.indexOf('CluNB__c <=') < 0);
    System.assert(strSQL.indexOf('CluNB__c =') < 0);
    System.assert(strSQL.indexOf('MinQty__c >=') < 0);
    System.assert(strSQL.indexOf('MinQty__c <=') < 0);
    System.assert(strSQL.indexOf('OrderAmount__c >=') < 0);
    System.assert(strSQL.indexOf('OrderAmount__c <=') < 0);
    System.assert(strSQL.indexOf('TriggerAmount__c >=') < 0);
    System.assert(strSQL.indexOf('TriggerAmount__c <=') < 0);
    System.assert(strSQL.indexOf('Main__c = true') < 0);
    System.assert(strSQL.indexOf('UL__c = true') < 0);
    System.assert(strSQL.indexOf('MaxPrint__c != NULL') < 0);
    System.assert(strSQL.indexOf('(StartTime__c != NULL OR EndTime__c != NULL)') < 0);

    criteria.chkMFG__c = true;
    criteria.chkRTL__c = true;
    criteria.chkCNJP__c = true;
    criteria.ImageNumber__c = 10000;
    criteria.McluFrom__c = 10000;
    criteria.McluTo__c = 10000;
    criteria.CluFrom__c = 10000;
    criteria.CluTo__c = 10000;
    criteria.CouponBarcode__c = '9820999999999';
    criteria.TriggerNumFrom__c   = 1;
    criteria.TriggerNumTo__c   = 1;
    criteria.OrderAmountFrom__c = 1;
    criteria.OrderAmountTo__c = 10000;
    criteria.TriggerAmountFrom__c = 10000;
    criteria.TriggerAmountTo__c = 10000;
    criteria.CheckMainAlt__c = true;
    criteria.CheckUnlimited__c = true;
    criteria.CheckMax__c = true;
    criteria.CheckTime__c = true;


    strSQL = dao.getSqlStatement(criteria);

    System.assert(strSQL.indexOf('ImageNumber__c') >= 0);
    System.assert(strSQL.indexOf('NumMCLU__c >=') >= 0);
    System.assert(strSQL.indexOf('NumMCLU__c <=') >= 0);
    System.assert(strSQL.indexOf('CluNB__c >=') >= 0);
    System.assert(strSQL.indexOf('CluNB__c <=') >= 0);
    System.assert(strSQL.indexOf('CluNB__c =') >= 0);
    System.assert(strSQL.indexOf('MinQty__c >=') >= 0);
    System.assert(strSQL.indexOf('MinQty__c <=') >= 0);
    System.assert(strSQL.indexOf('OrderAmount__c >=') >= 0);
    System.assert(strSQL.indexOf('OrderAmount__c <=') >= 0);
    System.assert(strSQL.indexOf('TriggerAmount__c >=') >= 0);
    System.assert(strSQL.indexOf('TriggerAmount__c <=') >= 0);
    System.assert(strSQL.indexOf('Main__c = true') >= 0);
    System.assert(strSQL.indexOf('UL__c = true') >= 0);
    System.assert(strSQL.indexOf('MaxPrint__c != NULL') >= 0);
    System.assert(strSQL.indexOf('(StartTime__c != NULL OR EndTime__c != NULL)') >= 0);

    /** Delete Work Data */
    List<JapanConstants__c>   listJapanConstantsW = [select id from JapanConstants__c];
    delete listJapanConstantsW;

    List<ContractCycle__c>     listContractCycleW   =   [select id from ContractCycle__c];
    delete listContractCycleW;

    List<Award__c>         listAwardW =       [select id from Award__c];
    delete listAwardW;

    List<MCLU__c>         listMCLUW =       [select id from MCLU__c];
    delete listMCLUW;

    List<ClientMaster__c>     listClientMasterW =   [select id from ClientMaster__c];
    delete listClientMasterW;

    List<SalesMaeter__c>     listSalesMaeterW =   [select id from SalesMaeter__c];
    delete listSalesMaeterW;

    List<CategoryMaster__c>   listCategoryMasterW = [select id from CategoryMaster__c];
    delete listCategoryMasterW;



    }


}