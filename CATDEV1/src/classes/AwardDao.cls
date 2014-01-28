/*
@Name            : AwardDao
@Author          : Satoshi Haga
@Date            : July 1, 2013
@Description     : Data Access Class for Award__c
@version         : 07/01/2013 First Creation
*/
public class AwardDao extends JapanDao{

  /**
   * Constructor
   * @param strFunctionalName functional name for logging
   */
  public AwardDao(String strFunctionalName){
    super(strFunctionalName, new Award__c().getSObjectType());
  }

  /**
   * Searching function. Retrun the ld list of ConstarcCycle, which is parent custom object for Award__c
   * @param criteria criteria for searching
   * @return List<ID>  the ld list of ConstarcCycle
   */
  public List<ID> getIdList(PlanSearchCriteria__c criteria){

    //Check if there are any need to also search in Award
    Boolean mcluFlg = false;
    List<ID> listID = null;

    if(criteria.ImageNumber__c != null
       || criteria.McluFrom__c != null
       || criteria.McluTo__c != null
       || criteria.CluFrom__c != null
       || criteria.CluTo__c != null
       || criteria.CouponBarcode__c != null
       || criteria.TriggerNumFrom__c != null
       || criteria.TriggerNumTo__c != null
       || criteria.OrderAmountFrom__c != null
       || criteria.OrderAmountTo__c != null
       || criteria.TriggerAmountFrom__c != null
       || criteria.TriggerAmountTo__c != null
       || criteria.CheckMainAlt__c == true
       || criteria.CheckUnlimited__c == true
       || criteria.CheckMax__c == true
       || criteria.CheckTime__c == true
       || criteria.MiniRedeem__c != null
       || criteria.MaxRedeem__c != null
       || criteria.sltRedeem__c != null
       || (criteria.chkMFG__c == true || criteria.chkRTL__c == true || criteria.chkCNJP__c == true)){


         McluDao mDao = new McluDao('AwardDao');
         listID = mDao.getIdList(criteria);

         if(listID == null || listID.size() == 0){
           //Return empty set because there is no need to search in Award
           return new List<ID>();
         }

         //There is need to include mclu id list into sql statemant
         mcluFlg = true;
     }


    //Initialize the returned object
    List<Award__c> retObj = new List<Award__c>();

    String joinString = ' where ';
    String strSQL = getSqlStatement(criteria);
    if(strSQL != null && strSQL.toUpperCase().indexOf('WHERE') >= 0){
      joinString = ' AND ';
    }
    //Check if there is need to include the mclu id list into this statement
    if(mcluFlg == true){
      strSQL = strSQL + joinString + 'ID IN :listID';
    }

    //data binding
    ID pClientID;
    if(criteria.Client__c != null)       pClientID = criteria.Client__c;

    List<String> pClientList;
    if(criteria.Sales__c != null){
      SalesMaeterDao salesDao = new SalesMaeterDao('JapanUtil');
      pClientList = new ClientMasterDao('AwardDao').getClientList(((SalesMaeter__c)salesDao.getAllColumnData(criteria.Sales__c)).Name);
    }

    Date pSearchDay;
    if(criteria.SearchDateFrom__c != null)   pSearchDay = criteria.SearchDateFrom__c;
    Date pSearchToDay;
    if(criteria.SearchDateTo__c != null)   pSearchToDay = criteria.SearchDateTo__c;
    String pKikakuNam;
    if(criteria.KikakuText__c != null)    pKikakuNam = criteria.KikakuText__c;
    String pOfferLine;
    if(criteria.GoodsText__c != null)    pOfferLine = criteria.GoodsText__c;

    //Execute SOQL
    System.debug('@@@Japan Log@@@JapanDao called@@@ function=' + strFunctionalName + '@@@ Execute Query Start');
    System.debug('@@@Japan Log@@@JapanDao called@@@ query=' + strSQL);

    //Execute SOQL query with bind valiable 'pId'
    retObj = (List<Award__c>)database.query(strSQL);
    System.debug('@@@Japan Log@@@JapanDao called@@@ function=' + strFunctionalName + '@@@ Execute Query End');

    //Filter this result br chain criteria
    List<Award__c> retList = filterChain(retObj, criteria);

    if(retList == null || retList.size() == 0){
      return new List<ID>();
    }

    //Pick the ContractCycle id list from the above result
    List<ID> alistID = new List<ID>();
    for(Award__c award : retList){
       alistID.add(award.PlansheetPrefix__c);
    }

    //Return the Id list
    return alistID;

  }

  /**
   * Searching function. Retrun the ld list for image list
   * @param criteria criteria for searching
   * @return List<ID>  the ld list
   */
  public List<ID> getIdListForImage(PlanSearchCriteria__c criteria){
    //Return Object
    List<Award__c> retObj = null;
    //String joinString = ' where ';

    String joinString = ' where ';

    //Get Data from Award__c directly
    String strSQL = getSqlStatement(criteria);


    //data binding
    ID pClientID;
    if(criteria.Client__c != null)       pClientID = criteria.Client__c;
    ID pSalesID;
    if(criteria.Sales__c != null)       pSalesID = criteria.Sales__c;
    Date pSearchDay;
    if(criteria.SearchDateMM__c != null)   pSearchDay = Date.newInstance(Integer.valueOf(criteria.SearchDateYYYY__c), Integer.valueOf(criteria.SearchDateMM__c), Integer.valueOf(criteria.SearchDateDD__c));
    Date pSearchToDay;
    if(criteria.SearchDateToMM__c != null)   pSearchToDay = Date.newInstance(Integer.valueOf(criteria.SearchDateToYYYY__c), Integer.valueOf(criteria.SearchDateToMM__c), Integer.valueOf(criteria.SearchDateToDD__c));
    String pKikakuNam;
    if(criteria.KikakuText__c != null)    pKikakuNam = criteria.KikakuText__c;
    String pOfferLine;
    if(criteria.GoodsText__c != null)    pOfferLine = criteria.GoodsText__c;


    //Execute SOQL
    System.debug('@@@Japan Log@@@JapanDao called@@@ function=' + strFunctionalName + '@@@ Execute Query Start');
    System.debug('@@@Japan Log@@@JapanDao called@@@ query=' + strSQL);

    //Execute SOQL query with bind valiable 'pId'
    retObj = (List<Award__c>)database.query(strSQL);
    System.debug('@@@Japan Log@@@JapanDao called@@@ function=' + strFunctionalName + '@@@ Execute Query End');

    //Filter this result by chain sriteria
    List<Award__c> retList = filterChain(retObj, criteria);

    //Pick the award id list from the above result
    List<ID> alistID = new List<ID>();
    for(Award__c award : retList){
       alistID.add(award.ID);
    }

    return alistID;
  }

  /**
   * Create the sql statement
   * @param criteria criteria for searching
   * @return String  sql statement
   */
  public String getSqlStatement(PlanSearchCriteria__c criteria){
    //Return Object
    List<Award__c> retObj = new List<Award__c>();

    String joinString = ' where ';

    String strSQL = 'select ' + getAllColumnString() + ' from ' + strTableName;
    //sql statement
    //Client
    if(criteria.Client__c != null){
      strSQL = strSQL + joinString + 'Client__c = \'' + ((String)criteria.Client__c).substring(0,15) + '\'';
      joinString = ' AND ';
    }
    //AD
    //Get client list from  JapanUserTable
    if(criteria.Sales__c != null) {
      strSQL = strSQL + joinString + 'Client__c in  :pClientList ';
      joinString = ' AND ';
    }
    //Category
    if(criteria.Category__c != null) {
      strSQL = strSQL + joinString + 'CategNB__c =  \'' + ((String)criteria.Category__c).substring(0,15) + '\'';
      joinString = ' AND ';
    }

    //Print Date(From)
    if(criteria.SearchDateMM__c != null){
      strSQL = strSQL + joinString + ' MaxPrintStopDate__c >=  :pSearchDay '  ;
      joinString = ' AND ';
    }

    //Print Date(To)
    if(criteria.SearchDateToMM__c != null){
      strSQL = strSQL + joinString + ' MinPrintStartDate__c <=  :pSearchToDay '  ;
      joinString = ' AND ';
    }

    //Campaign Name
    if(criteria.KikakuText__c != null){
      strSQL = strSQL + joinString + 'KikakuName__c LIKE  \'%' + criteria.KikakuText__c + '%\'';
      joinString = ' AND ';
    }

    //Validation Item
    if(criteria.GoodsText__c != null){
      strSQL = strSQL + joinString + 'OfferLine__c LIKE  \'%' + criteria.GoodsText__c + '%\'';
      joinString = ' AND ';
    }

    //Award(From)
    if(criteria.AwardFrom__c != null){
      strSQL = strSQL + joinString + 'NumAward__c >=  ' + criteria.AwardFrom__c;
      joinString = ' AND ';
    }

    //Award(To)
    if(criteria.AwardTo__c != null){
      strSQL = strSQL + joinString + 'NumAward__c <=  ' + criteria.AwardTo__c;
      joinString = ' AND ';
    }

    //PrefixCycle
    if(criteria.PrefixCycle__c != null){
      strSQL = strSQL + joinString + 'PrefixCycle__c =  \'' + criteria.PrefixCycle__c + '\'';
      joinString = ' AND ';
    }

    //Special program
    if(criteria.checkSpecial__c == true){
         strSQL = strSQL + joinString + 'checkSpecial__c = true';
         joinString = ' AND ';
    }

    //Message Coupon
    if(criteria.CheckMessage__c == true){
         strSQL = strSQL + joinString + 'MessageCoupon__c = true';
         joinString = ' AND ';
    }

    //Card Program
    if(criteria.CheckCard__c == true){
         strSQL = strSQL + joinString + 'Sid__c = true';
         joinString = ' AND ';
    }

    //Backup Coupon
    if(criteria.CheckYobiken__c == true){
         strSQL = strSQL + joinString + 'Yobiken__c = true';
         joinString = ' AND ';
    }

    //Pop Message
    if(criteria.CheckPop__c == true){
         strSQL = strSQL + joinString + 'Pop__c = true';
         joinString = ' AND ';
    }

    //Campaign Catalog
    if(criteria.Check__c == true){
         strSQL = strSQL + joinString + 'Chirashi__c = true';
         joinString = ' AND ';
    }

    //Special Program
    if(criteria.SpecialProgramFlag__c == true){
         strSQL = strSQL + joinString + 'SpecialProgramFlag__c = true';
         joinString = ' AND ';
    }

    //Return
    return strSQL;
  }

  /**
   * Filter the result by chain criteria
   * @param listSource SQL result to be filtered
   * @param criteria criteria for searching
   * @return List<Award__c> the filtered result
   */
  public List<Award__c> filterChain(List<Award__c> listSource, PlanSearchCriteria__c criteria){

    List<Award__c> listResult = new List<Award__c>();

    if(listSource != null && listSource.size() > 0 && criteria.Chain__c != null){

      //Pick the chain list from the criteria
      List<String> criChainList = JapanUtil.convertMultiPick(criteria.Chain__c);

      for(Award__c award: listSource){
        if(award.strChainList__c != null){
          List<String> pChainList = JapanUtil.convertMultiPick(award.strChainList__c);
          if(JapanUtil.checkSameValue(pChainList, criChainList)){
            listResult.add(award);
          }
        }
      }
    }else{
      //Awward list is empty or chain is not selected on window
      listResult = listSource;
    }

    //return the filtered list
    return listResult;
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

    ContractCycle__c testRec = new ContractCycle__c();
    testRec.Name = 'WPI306';
    testRec.CHAIN__C = '1 : イオン;3 : イトーヨーカドー';
    testRec.CONTNB__C = 3174;
    testRec.CYCLE__C = 306;
    testRec.KIKAKUNAME__C = 'P&Gサンプル引き換えクーポン';
    testRec.PPP__C = 11.7;
    testRec.PRINTSTARTDATE__C = date.newInstance(2012,2,1);
    testRec.PRINTSTOPDATE__C = date.newInstance(2012,2,1);
    testRec.EXPIREDATE__C = date.newInstance(2012,2,1);
    testRec.EXCEPTIONIMAGE__C = false;
    testRec.EXCEPTIONACTIVENO__C = true;
    testRec.EXCEPTIONOTHER__C = false;
    testRec.SpecialProgramFlag__c = true;
    insert testRec;

    testRec = new ContractCycle__c();
    testRec.Name = 'YAO306';
    testRec.CHAIN__C = '1 : イオン;3 : イトーヨーカドー';
    testRec.CONTNB__C = 9901;
    testRec.CYCLE__C = 306;
    testRec.KIKAKUNAME__C = 'イオン小山SC　200円専門店飲食・食品値引券';
    testRec.PPP__C = 11.7;
    testRec.PRINTSTARTDATE__C = date.newInstance(2012,2,1);
    testRec.PRINTSTOPDATE__C = date.newInstance(2012,2,1);
    testRec.EXPIREDATE__C = date.newInstance(2012,2,1);
    testRec.EXCEPTIONIMAGE__C = true;
    testRec.EXCEPTIONACTIVENO__C = true;
    testRec.EXCEPTIONOTHER__C = true;
    testRec.SpecialProgramFlag__c = true;
    insert testRec;

    List<ContractCycle__c> listCont = [select id from ContractCycle__c] ;

    Award__c testAward = new Award__c();
    testAward.Name = '1000';
    testAward.PlansheetPrefix__c = listCont.get(0).Id;
    testAward.BLIND__C = false;
    testAward.CHIRASHI__C = false;
    testAward.CPNDESC__C = 'ゲロルシュタイナー 500ml';
    testAward.EXPIREDATE__C = date.newInstance(2013,7,21);
    testAward.KIKAKUNAME__C = 'ゲロルシュタイナー 500ml';
    testAward.MESSAGECOUPON__C = false;
    testAward.OFFERCOMMENT__C = 'ゲロルシュタイナー 500ml';
    testAward.OFFERLINE__C = 'ゲロルシュタイナー 500ml';
    testAward.POP__C = false;
    testAward.PRINTSTARTDATE__C = date.newInstance(2013,7,21);
    testAward.PRINTSTOPDATE__C = date.newInstance(2013,7,21);
    testAward.SID__C = false;
    testAward.TOKUBETSUKIKAKU__C = false;
    testAward.TRIGGERCLASS__C ='生理用品';
    testAward.VALUE__C = 50;
    testAward.YOBIKEN__C = false;
    testAward.CHECKSPECIAL__C = false;
    testAward.CHKLIMIT__C = false;
    testAward.CHKMAIN__C = false;

    testAward.CHKTIME__C = false;
    testAward.CHKUNLIMITED__C = false;
    testAward.STRCHAINLIST__C = '1 : イオン;7：Sローゼン';

    testAward.EXCEPTIONIMAGE__C = false;
    testAward.EXCEPTIONACTIVENO__C = false;
    testAward.EXCEPTIONOTHER__C = false;

    insert testAward;

    testAward = new Award__c();
    testAward.Name = '1000';
    testAward.PlansheetPrefix__c = listCont.get(1).Id;
    testAward.BLIND__C = false;
    testAward.CHIRASHI__C = false;
    testAward.CPNDESC__C = 'ゲロルシュタイナー 500ml';
    testAward.EXPIREDATE__C = date.newInstance(2013,7,21);
    testAward.KIKAKUNAME__C = 'ゲロルシュタイナー 500ml';
    testAward.MESSAGECOUPON__C = false;
    testAward.OFFERCOMMENT__C = 'ゲロルシュタイナー 500ml';
    testAward.OFFERLINE__C = 'ゲロルシュタイナー 500ml';
    testAward.POP__C = false;
    testAward.PRINTSTARTDATE__C = date.newInstance(2013,7,21);
    testAward.PRINTSTOPDATE__C = date.newInstance(2013,7,21);
    testAward.SID__C = false;
    testAward.TOKUBETSUKIKAKU__C = false;
    testAward.TRIGGERCLASS__C ='生理用品';
    testAward.VALUE__C = 50;
    testAward.CHECKSPECIAL__C = false;
    testAward.CHKLIMIT__C = false;
    testAward.CHKMAIN__C = false;

    testAward.CHKTIME__C = false;
    testAward.CHKUNLIMITED__C = false;
    testAward.STRCHAINLIST__C = '1 : イオン;7：Sローゼン';


    testAward.EXCEPTIONIMAGE__C = false;
    testAward.EXCEPTIONACTIVENO__C = false;
    testAward.EXCEPTIONOTHER__C = false;

    insert testAward;

    List<Award__c> listAward = [select id from Award__c] ;

    MCLU__c  testMclu = new MCLU__c();
    testMclu.AwardNB__c = listAward.get(0).Id;
    testMclu.Name = '1000';
    testMclu.ACTIVE__C = false;
    testMclu.BLIND__C = false;
    testMclu.CHANGE__C = '1835:大村';
    testMclu.CLUNB__C = 26697;
    testMclu.COUPONOFFERLINEA__C = '大村専門店企画_300円（1枚目）';
    testMclu.COUPONTYPEB__C = 'M';
    testMclu.COUPONVALUE__C = 0;
    testMclu.EXPIREDATE__C = date.newInstance(2013,7,21);
    testMclu.IMAGENUMBER__C = 100202;
    testMclu.MINAMT__C = 3000;
    testMclu.PRINTSTARTDATE__C = date.newInstance(2013,7,21);
    testMclu.PRINTSTOPDATE__C = date.newInstance(2013,7,21);
    testMclu.PRINTTIMING__C = '現計';
    testMclu.PRIORITY__C = 'M';
    testMclu.UL__C = false;
    testMclu.WHENTOPRINT__C = '現計';
    testMclu.EXCEPTIONIMAGE__C = false;
    testMclu.EXCEPTIONACTIVENO__C = false;
    testMclu.EXCEPTIONOTHER__C = false;
    insert testMclu;

    testMclu = new MCLU__c();
    testMclu.AwardNB__c = listAward.get(1).Id;
    testMclu.Name = '1000';
    testMclu.ACTIVE__C = false;
    testMclu.BLIND__C = false;
    testMclu.CHANGE__C = '1835:大��';
    testMclu.CLUNB__C = 26697;
    testMclu.COUPONOFFERLINEA__C = '大村専門店企画_300円（1枚目）';
    testMclu.COUPONTYPEB__C = 'M';
    testMclu.COUPONVALUE__C = 0;
    testMclu.EXPIREDATE__C = date.newInstance(2013,7,21);
    testMclu.IMAGENUMBER__C = 100202;
    testMclu.MINAMT__C = 3000;
    testMclu.PRINTSTARTDATE__C = date.newInstance(2013,7,21);
    testMclu.PRINTSTOPDATE__C = date.newInstance(2013,7,21);
    testMclu.PRINTTIMING__C = '現計';
    testMclu.PRIORITY__C = 'M';
    testMclu.UL__C = false;
    testMclu.WHENTOPRINT__C = '現計';
    testMclu.EXCEPTIONIMAGE__C = false;
    testMclu.EXCEPTIONACTIVENO__C = false;
    testMclu.EXCEPTIONOTHER__C = false;
    insert testMclu;


    ClientMaster__c testClient = new ClientMaster__c();
    testClient.Name = '2102';
    testClient.ClientName__c = 'CCCMC';
    testClient.ClientNumber__c = '2102';
    insert   testClient;

    SalesMaeter__c testSales = new SalesMaeter__c();
    testSales.Name = 'TestClient';
    insert   testSales;

    CategoryMaster__c testCategory = new CategoryMaster__c();
    testCategory.Name = '2102';
    testCategory.CategoryNumber__c = 'CCCMC';
    testCategory.CategName__c = '2102';
    insert   testCategory;

      AwardDao dao = new AwardDao('unitTest');

      /** getIdList */
      PlanSearchCriteria__c criteria = new PlanSearchCriteria__c();
    criteria.chkMFG__c = true;
    criteria.chkRTL__c = true;
    criteria.chkCNJP__c = true;
    criteria.McluFrom__c = 1;

      List<ID> aList = dao.getIdList(criteria);
    System.assert(aList.size() == 0);


    criteria = new PlanSearchCriteria__c();
    criteria.chkMFG__c = true;
    criteria.chkRTL__c = true;
    criteria.chkCNJP__c = true;
    criteria.McluTo__c = 1;

      aList = dao.getIdList(criteria);
    System.assert(aList.size() == 0);


    /** getIdListForImage */
    List<ID> listImage = dao.getIdListForImage(criteria);
    System.assert(listImage.size() > 0);

    /** getSqlStatement */
    criteria = new PlanSearchCriteria__c();
    criteria.chkMFG__c = true;
    criteria.chkRTL__c = true;
    criteria.chkCNJP__c = true;
    criteria.SpecialProgramFlag__c = true;
    String strSQL = dao.getSqlStatement(criteria);

    System.assert(strSQL.indexOf('Client__c') < 0);
    System.assert(strSQL.indexOf('SalesID__c') < 0);
    System.assert(strSQL.indexOf('CategNB__c') < 0);
    System.assert(strSQL.indexOf('MaxPrintStopDate__c') < 0);
    System.assert(strSQL.indexOf('MinPrintStartDate__c') < 0);
    System.assert(strSQL.indexOf('KikakuName__c') < 0);
    System.assert(strSQL.indexOf('OfferLine__c') < 0);
    System.assert(strSQL.indexOf('NumAward__c >=') < 0);
    System.assert(strSQL.indexOf('NumAward__c <=') < 0);
    System.assert(strSQL.indexOf('PrefixCycle__c =') < 0);
    System.assert(strSQL.indexOf('checkSpecial__c =') < 0);
    System.assert(strSQL.indexOf('MessageCoupon__c =') < 0);
    System.assert(strSQL.indexOf('Sid__c =') < 0);
    System.assert(strSQL.indexOf('Yobiken__c =') < 0);
    System.assert(strSQL.indexOf('Pop__c =') < 0);
    System.assert(strSQL.indexOf('Chirashi__c =') < 0);

    List<ClientMaster__c> listClient = [select Id from ClientMaster__c];
    criteria.Client__c = listClient.get(0).Id;

    List<SalesMaeter__c> listSales = [select Id from SalesMaeter__c];
    criteria.Sales__c = listSales.get(0).Id;

    List<CategoryMaster__c> listCategory = [select Id from CategoryMaster__c];
    criteria.Category__c = listCategory.get(0).Id;

    criteria.SearchDateYYYY__c = '2013';
    criteria.SearchDateMM__c = '01';
    criteria.SearchDateDD__c = '01';
    criteria.SearchDateToYYYY__c = '2013';
    criteria.SearchDateToMM__c = '01';
    criteria.SearchDateToDD__c = '01';
    criteria.KikakuText__c = 'Test';
    criteria.GoodsText__c = 'Test';
    criteria.AwardFrom__c = 10000;
    criteria.AwardTo__c = 10000;
    criteria.PrefixCycle__c   = 'ZZZ999';
    criteria.checkSpecial__c   = true;
    criteria.CheckMessage__c   = true;
    criteria.CheckCard__c     = true;
    criteria.CheckYobiken__c   = true;
    criteria.CheckPop__c     = true;
    criteria.Check__c       = true;


    strSQL = dao.getSqlStatement(criteria);

    System.assert(strSQL.indexOf('Client__c') >= 0);
    System.assert(strSQL.indexOf('CategNB__c') >= 0);
    System.assert(strSQL.indexOf('MaxPrintStopDate__c') >= 0);
    System.assert(strSQL.indexOf('MinPrintStartDate__c') >= 0);
    System.assert(strSQL.indexOf('KikakuName__c') >= 0);
    System.assert(strSQL.indexOf('OfferLine__c') >= 0);
    System.assert(strSQL.indexOf('NumAward__c >=') >= 0);
    System.assert(strSQL.indexOf('NumAward__c <=') >= 0);
    System.assert(strSQL.indexOf('PrefixCycle__c =') >= 0);
    System.assert(strSQL.indexOf('checkSpecial__c =') >= 0);
    System.assert(strSQL.indexOf('MessageCoupon__c =') >= 0);
    System.assert(strSQL.indexOf('Sid__c =') >= 0);
    System.assert(strSQL.indexOf('Yobiken__c =') >= 0);
    System.assert(strSQL.indexOf('Pop__c =') >= 0);
    System.assert(strSQL.indexOf('Chirashi__c =') >= 0);


    /** filterChain */
    List<Award__c> listAwards = dao.filterChain(new List<Award__c>(), new PlanSearchCriteria__c());
    System.assert(listAwards.size() == 0);

    Award__c award = new Award__c();
    award.strChainList__c = '1 : イオン;3 : イトーヨーカドー;4：イオンキミサワ;7：Sロ��ゼン';
    List<Award__c> lstA = new List<Award__c>();
    lstA.add(award);

    criteria = new PlanSearchCriteria__c();
    criteria.chkMFG__c = true;
    criteria.chkRTL__c = true;
    criteria.chkCNJP__c = true;
    criteria.Chain__c = '1 : イオン;3 : イトーヨーカドー;4：イオンキミサワ;7：Sローゼン';
    lstA = dao.filterChain(lstA, criteria);
    System.assert(lstA.size() == 1);

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