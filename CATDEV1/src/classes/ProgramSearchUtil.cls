/*
@Name            : ProgramSearchUtil
@Author          : Satoshi Haga
@Date            : July 1, 2013
@Description     : Utility class for the page "ProgramSearch"
@version         : 07/01/2013 First Creation
*/
public class ProgramSearchUtil {

  /**
   * Search function
   * @param criteria criteria for searching
   * @return List<ProgramSearchDto>  result of query
   */
  public List<ProgramSearchDto> search(PlanSearchCriteria__c criteria) {

    // Get Plain result from database
    ContractCycleDao dao = new ContractCycleDao('ProgramSearchUtil');
    List<ContractCycle__c> resultDto = (List<ContractCycle__c>)dao.searchForProgramSearch(criteria);

    // assign this result to member valiable
    List<ProgramSearchDto> resultList = new List<ProgramSearchDto>();
    Integer cnt = 1;
    for(ContractCycle__c contractCycle : resultDto){
      ProgramSearchDto temp = new ProgramSearchDto();
      temp.result = contractCycle;

      // Format
      Datetime wrkTime = contractCycle.PrintStartDate__c;
      if(contractCycle.PrintStartDate__c != null){
        contractCycle.strPrintStartDate__c = wrkTime.format('yyyy/MM/dd');
      }

      wrkTime = contractCycle.PrintStopDate__c;
      if(contractCycle.PrintStopDate__c != null){
        contractCycle.strPrintStopDate__c = wrkTime.format('yyyy/MM/dd');
      }

      wrkTime = contractCycle.ExpireDate__c;
      if(contractCycle.ExpireDate__c != null){
        contractCycle.strExpireDate__c = wrkTime.format('yyyy/MM/dd');
      }

      //Format chain list
      List<String> listCHain = JapanUtil.convertMultiPick(contractCycle.Chain__c );
      Integer cntChain = 1;
      contractCycle.Chain__c = '';
      for(String strChain : listCHain){
        if(cntChain == 5){
          contractCycle.Chain__c = contractCycle.Chain__c + '<br/>';
          cntChain = 1;
        }
        contractCycle.Chain__c = contractCycle.Chain__c + ';' + strChain;
        cntChain++;
      }


      //Exception Image
      String strAlartId = '';
      Map<String,String> param = new Map<String,String>();
      param.put('TypeA__c', 'ExceptionWarningMessage');
      if(contractCycle.SpecialProgramFlag__c == true){
           param.put('TypeB__c', 'Alert1');
      }

      //Serch Image Id from Constant Table
      if(contractCycle.SpecialProgramFlag__c == true){
        JapanConstantsDao constDao = new JapanConstantsDao('ProgramSearchUtil');
        List<JapanConstants__c> listWarningId = (List<JapanConstants__c>)constDao.getValue(param);
        for(JapanConstants__c idWarning : listWarningId){
          contractCycle.ExceptionImageStr__c = idWarning.Value__c;
        }
      }

      temp.rank = cnt;
      cnt++;

      resultList.add(temp);
    }

    // return
    return resultList;
  }

  /**
   * Searching image  function
   * @param criteria criteria for searching
   * @return List<ProgramSearchDto>  result of query
   */
  public List<JapanImageDto> searchForImage(PlanSearchCriteria__c criteria) {

    McluDao mDao = new McluDao('ProgramSearchUtil');

    return mDao.getImageDto(criteria);
  }

  /**
    Validation check function.
    @param PlanSearchCriteria__c
    @return true : valid,  false : invalid
  */
  public Boolean isValid(PlanSearchCriteria__c programCriteria){

    //The length of Coupon Code must be 13
    if(programCriteria.CouponBarcode__c != null && programCriteria.CouponBarcode__c.length() != 13){
      ApexPages.Message message = new ApexPages.Message( ApexPages.severity.ERROR, 'クーポンバーコードは13桁で入力して下さい。。');
           ApexPages.addMessage(message);
           return false;
       }

       //Coupon type is not selected
    if(programCriteria.chkMFG__c == false && programCriteria.chkRTL__c == false && programCriteria.chkCNJP__c == false){
      ApexPages.Message message = new ApexPages.Message( ApexPages.severity.ERROR, 'クーポン種別が何も選択されていません');
           ApexPages.addMessage(message);
           return false;
       }

       //Valid
       return true;
  }

  /**
    Init criteria .
    @return PlanSearchCriteria__c
  */
  public PlanSearchCriteria__c initCriteria(){
    /**Set default value to criteria */
    PlanSearchCriteria__c programCriteria = new PlanSearchCriteria__c();

    programCriteria.SearchDateYYYY__c = Datetime.now().format('yyyy', 'JST');
    programCriteria.SearchDateMM__c = Datetime.now().format('MM', 'JST');
    programCriteria.SearchDateDD__c = Datetime.now().format('dd', 'JST');

    programCriteria.SearchDateToYYYY__c = Datetime.now().format('yyyy', 'JST');
    programCriteria.SearchDateToMM__c = Datetime.now().format('MM', 'JST');
    programCriteria.SearchDateToDD__c = Datetime.now().format('dd', 'JST');

    return programCriteria;
  }

  /**
    Create JsonString for grid of page .
    @param  List<JapanImageDto>
    @return String JsonString
  */
  public String getJsonString(List<ProgramSearchDto> resultList){

    String strJson = '[';
    for(ProgramSearchDto dto:resultList){
      ContractCycle__c conCyc = dto.result;

      //New Line
      conCyc.KikakuName__c = conCyc.KikakuName__c.replaceAll(';','<br/>');

      //JSonString for grid component
      strJson = strJson+ '{';
      if(conCyc.SpecialProgramFlag__c == true){
        //When it is with exception
        strJson = strJson+ 'Warning:"<img src=\'/servlet/servlet.FileDownload?file=' + conCyc.ExceptionImageStr__c + '\' width=\'60\' >",';
      }else{
        //When it is with no exception
        strJson = strJson+ 'Warning:"",';
      }

      if(conCyc.SpecialProgramFlag__c == true){
        strJson = strJson+ 'SpecialProgramLink:"<a href=\'/' + conCyc.SpecialProgramLink__c + '\' target=\'_blank\'>DownLoad</a>",';
      }else{
        strJson = strJson+ 'SpecialProgramLink:"",';
      }

      strJson = strJson+ 'Image:"<img src=\'/servlet/servlet.FileDownload?file=' + conCyc.ImageNumber__c + '\' width=\'450\' >",';
      strJson = strJson+ 'PrefixCycle:"<a href=\'/' + conCyc.Id + '\' target=\'_blank\'>' + conCyc.Name + '</a>",';
      strJson = strJson+ 'Client:"' + conCyc.ClientName__c + '",';
      strJson = strJson+ 'KikakuName:"' + conCyc.KikakuName__c + '",';
      strJson = strJson+ 'PrintStartDate:"' + conCyc.strPrintStartDate__c + '",';
      strJson = strJson+ 'PrintStopDate:"' + conCyc.strPrintStopDate__c + '",';
      strJson = strJson+ 'ExpireDate:"' + conCyc.strExpireDate__c + '",';
      strJson = strJson+ 'ChainList:"' + conCyc.Chain__c + '"';
      strJson = strJson+ '},';
    }

    if(strJson.length() > 1){
      strJson = strJson.substring(0,strJson.length()-1);
      strJson = strJson+ ']';
    }

    return strJson;
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

	   /** SalesMaeter__c */
	  SalesMaeter__c testSales = new SalesMaeter__c();
	  testSales.Name = 'Test Sales User';
	  insert testSales;
	  testSales = ((List<SalesMaeter__c>)(new SalesMaeterDao('Testing').getAllColumnData())).get(0);

	  /** ClientMaster__c */
	  ClientMaster__c testClient = new ClientMaster__c();
	  testClient.Name = 'Test Client';
	  testClient.ClientNumber__c = '99999';
	  testClient.ClientName__c = 'TestClientName';
	  insert testClient;
	  testClient = ((List<ClientMaster__c>)(new ClientMasterDao('Testing').getAllColumnData())).get(0);

	  /** CategoryMaster__c */
	  CategoryMaster__c testCategory = new CategoryMaster__c();
	  testCategory.Name = 'Test Category';
	  testCategory.CategoryNumber__c = '12345';
	  testCategory.CategName__c = 'Test CategoryName';
	  insert testCategory;
	  testCategory = ((List<CategoryMaster__c>)(new CategoryMasterDao('Testing').getAllColumnData())).get(0);

	  /** ContractCycle__c */
	  ContractCycle__c conCyc = new ContractCycle__c();
	  conCyc.Name = 'Test Contract';
	  conCyc.CategNB__c = testCategory.Id;
	  conCyc.ClientNB__c = testClient.Id;
	  conCyc.SalesNo__c = testSales.Id;

	  conCyc.PrintStartDate__c = date.today();
	  conCyc.PrintStopDate__c = date.today();
	  conCyc.ExpireDate__c = date.today();

	  conCyc.Chain__c = 'XXXX;YYYY;ZZZZ';
	  insert conCyc;
	  conCyc = ((List<ContractCycle__c>)(new ContractCycleDao('Testing').getAllColumnData())).get(0);

	  /** Award__c */
	  Award__c award = new Award__c();
	  award.Name = 'Test Award';
	  award.PlansheetPrefix__c = conCyc.Id;
	  award.Yobiken__c = true;
	  award.Sid__c = true;
	  award.Pop__c = true;
	  award.Chirashi__c = true;
	  award.MessageCoupon__c = true;
	  award.Blind__c = true;
	  award.chkMain__c = true;
	  award.chkUnlimited__c = true;
	  award.chkLimit__c = true;
	  award.chkTime__c = true;

	  award.PrintStartDate__c = date.today();
	  award.PrintStopDate__c = date.today();
	  award.ExpireDate__c = date.today();
	  insert award;
	  award = ((List<Award__c>)(new AwardDao('Testing').getAllColumnData())).get(0);

	  /** JapanConstants__c */
	  JapanConstants__c testConst = new JapanConstants__c();
	  testConst.TypeA__c = 'ChatterGroup';
	  testConst.TypeB__c = 'TokyoHelpdesk';
	  testConst.Value__c = '12345678';
	  insert testConst;

      ProgramSearchUtil util = new ProgramSearchUtil();

      PlanSearchCriteria__c criteria = new PlanSearchCriteria__c();
      criteria.chkMFG__c = true;
      criteria.chkRTL__c = true;
      criteria.chkCNJP__c = true;
      criteria.SpecialProgramFlag__c = false;

      List<ProgramSearchDto> listDto = util.search(criteria);

      criteria = new PlanSearchCriteria__c();
      criteria.chkMFG__c = true;
      criteria.chkRTL__c = true;
      criteria.chkCNJP__c = true;

      List<JapanImageDto> listImageDto = util.searchForImage(criteria);

      criteria = new PlanSearchCriteria__c();
      criteria.chkMFG__c = true;
      criteria.chkRTL__c = true;
      criteria.chkCNJP__c = true;
      criteria.CouponBarcode__c = '98201111222231';
      System.assert(util.isValid(criteria) == false);

      criteria = new PlanSearchCriteria__c();
      criteria.chkMFG__c = true;
      criteria.chkRTL__c = true;
      criteria.chkCNJP__c = true;
      criteria.SearchDateYYYY__c = '2013';
      criteria.SearchDateMM__c = '01';
      criteria.SearchDateDD__c = '30';
      System.assert(util.isValid(criteria) == true);

      criteria = new PlanSearchCriteria__c();
      criteria.chkMFG__c = false;
      criteria.chkRTL__c = false;
      criteria.chkCNJP__c = false;
      System.assert(util.isValid(criteria) == false);

      criteria = util.initCriteria();
      System.assert(criteria.SearchDateYYYY__c.equals(Datetime.now().format('yyyy', 'JST')));
      System.assert(criteria.SearchDateMM__c.equals(Datetime.now().format('MM', 'JST')));
      System.assert(criteria.SearchDateDD__c.equals(Datetime.now().format('dd', 'JST')));
      System.assert(criteria.SearchDateToYYYY__c.equals(Datetime.now().format('yyyy', 'JST')));
      System.assert(criteria.SearchDateToMM__c.equals(Datetime.now().format('MM', 'JST')));
      System.assert(criteria.SearchDateToDD__c.equals(Datetime.now().format('dd', 'JST')));

      String strJson = util.getJsonString(listDto);

      for(ProgramSearchDto dto:listDto){
        conCyc = dto.result;
        System.assert(strJson.indexOf(conCyc.Name) >= 0 );
      }

    }



}