/*
@Name            : ProgramSearchController
@Author          : Satoshi Haga
@Date            : July 1, 2013
@Description     : Controller for the page "ProgramSearch"
@version         : 07/01/2013 First Creation
*/
public class ProgramSearchController {

  /** functinal name */
  public Static String strFunctionalName = 'ProgramSearch';

  /** criteria*/
  public PlanSearchCriteria__c programCriteria{get;set;}

  /** search Result */
  public List<ProgramSearchDto> resultList{get;set;}

  /** search Result(Image) */
  public List<JapanImageDto> resultListImage{get;set;}

  /**JSON String */
  public String strJson{get;set;}

  /** Util Class */
  private ProgramSearchUtil util ;

  /** ImageNumber */
  public String strImageNumber {get; set;}

  /** Http Parameter */
  public Map<String, String>  param ;

  /**
    initial method
  */
  public void init(){

    //initialize utility class
    util = new ProgramSearchUtil();

    //initialize criteria
    programCriteria = util.initCriteria();
    programCriteria.ResultFlg__c = true;

    //set HTTP parameter member valiable
    param = ApexPages.currentPage().getParameters();


  }

  /**
    Clear the criteria and result. This is called by the button "検索条件リセット"
  */
  public PageReference clear(){
    programCriteria = new PlanSearchCriteria__c();
    programCriteria.ResultFlg__c = true;
    resultList = new List<ProgramSearchDto>();
    return null;
  }


  /**
    Data search function. This is called by the button "検索"
  */
  public PageReference search() {
    try{

      //When it is from image link , the criteria is only image number
      if(strImageNumber != null && !''.equals(strImageNumber.trim())){
        programCriteria = new PlanSearchCriteria__c();
        programCriteria.ImageNumber__c = Integer.valueOf(strImageNumber);
        programCriteria.chkMFG__c = true;
        programCriteria.chkRTL__c = true;
        programCriteria.chkCNJP__c = true;
      }

      //Validation Check
      if(!util.isValid(programCriteria)){
        //Error
        return null;
      }

      resultList = util.search(programCriteria);

      //Re-Create Json String
      strJson = util.getJsonString(resultList);

      ApexPages.Message message = new ApexPages.Message( ApexPages.severity.INFO, '検索結果は'+ resultList.size() + '件です。');
      ApexPages.addMessage(message);

      //Set result type normal esarch
      programCriteria.ResultFlg__c = true;
      return null;
    }catch(System.LimitException se){
      ApexPages.Message message = new ApexPages.Message( ApexPages.severity.ERROR, '検索結果が多すぎます。検索条件を見直して下さい。');
           ApexPages.addMessage(message);
           return null;
    }catch(Exception e){
      ApexPages.Message message = new ApexPages.Message( ApexPages.severity.ERROR, 'エラーが発生しました。管理者に問い合わせてください。Error：' + e.getMessage());
           ApexPages.addMessage(message);
           return null;
    }
  }

  /**
    Data search function. This is called by the button "検索(画像一覧表示)"
  */
  public PageReference searchImage() {
    try{
      //Validation Check
      if(!util.isValid(programCriteria)){
        //Error
        return null;
      }

      resultListImage = util.searchForImage(programCriteria);

      //Set result type image list
      programCriteria.ResultFlg__c = false;
      return null;
    }catch(System.LimitException se){
      ApexPages.Message message = new ApexPages.Message( ApexPages.severity.ERROR, '検索結果が多すぎます。検索条件を見直して下さい。');
           ApexPages.addMessage(message);
           return null;
    }catch(Exception e){
      ApexPages.Message message = new ApexPages.Message( ApexPages.severity.ERROR, 'エラーが発生��ました。管理者に問い合わせてください。Error：' + e.getMessage());
           ApexPages.addMessage(message);
           return null;
    }
  }

  /**
    Data search function. This is called by the button "画像印刷"
  */
  public PageReference outputPdf() {

    PageReference pageRef = Page.ProgramImagePdf;
    return pageRef;
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

      ProgramSearchController controller = new ProgramSearchController();
      controller.init();

      controller.strImageNumber = '12345';
      controller.search();

      System.assert(controller.programCriteria.ImageNumber__c == 12345);

      controller.init();
      controller.programCriteria.CouponBarcode__c = '98209999999999';
      PageReference pr = controller.search();

      System.assert(pr == null);


      controller.init();
      controller.programCriteria.CouponBarcode__c = '9820123456789';
      pr = controller.search();

      System.assert(pr == null);

      pr = controller.clear();
      System.assert(pr == null);

      controller.init();
      controller.programCriteria.CouponBarcode__c = '9820123456789';
      pr = controller.searchImage();

      System.assert(pr == null);


      controller.init();
      controller.programCriteria.CouponBarcode__c = '9820123456789';
      pr = controller.outputPdf();

      System.assert(pr != null);

    }


}