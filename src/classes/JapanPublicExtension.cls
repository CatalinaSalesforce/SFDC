/*
@Name            : JapanPublicExtension
@Author          : Satoshi Haga
@Date            : July 1, 2013
@Description     : Common Extension class for visualforce pages of Japan
@version         : 07/01/2013 First Creation
*/
public class JapanPublicExtension {

  /** public valiable. these are called from each visualforce page */
  public ContractCycle__c conCyc { get; set; }

  //public Award__c award { get; set; }
  public List<Award__c> aList { get; set; }
  public List<AwardWithMclu> amList { get; set; }
  public List<ContractCycleImage__c> imageList { get; set; }

  public String strComment{ get; set; }

  public String strObjectName = 'ContractCycle__c';
  /**
   * Constructor
   * @param stdController this is gotten by salesforce standard framwwork when accessing each page.
   */
  public JapanPublicExtension(ApexPages.StandardController stdController) {

    ContractCycleDao dao = new ContractCycleDao('JapanPublicExtension');
      conCyc = (ContractCycle__c)dao.getAllColumnData(stdController.getRecord().ID);

    AwardDao aDao = new AwardDao('JapanPublicExtension');
      aList = (List<Award__c>)aDao.getReferencedListWithOrderKey('PlansheetPrefix__c', stdController.getRecord().ID, 'Name');
      amList = new List<AwardWithMclu>();
      for(Award__c award : aList){
        amList.add(new AwardWithMclu(award));
      }

      ContractCycleImageDao cDao = new ContractCycleImageDao('JapanPublicExtension');
      imageList = (List<ContractCycleImage__c>)cDao.getReferencedListWithOrderKey('ContractCycle__c', stdController.getRecord().ID, 'Name');

    //Exception Message
    if(conCyc.SpecialProgramFlag__c == true){
      ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.WARNING, '特別企画です。特別企画リストを参照してください。'));
    }

    // Format
    Datetime wrkTime = conCyc.PrintStartDate__c;
    if(conCyc.PrintStartDate__c != null){
      conCyc.strPrintStartDate__c = wrkTime.format('yyyy/MM/dd');
    }

    wrkTime = conCyc.PrintStopDate__c;
    if(conCyc.PrintStopDate__c != null){
      conCyc.strPrintStopDate__c = wrkTime.format('yyyy/MM/dd');
    }

    wrkTime = conCyc.ExpireDate__c;
    if(conCyc.ExpireDate__c != null){
      conCyc.strExpireDate__c = wrkTime.format('yyyy/MM/dd');
    }

    //Responsible of this program
    for(AwardWithMclu awardWithMclu : amList){
      awardWithMclu.award.strYobiken__c = JapanUtil.convertBooleanString( awardWithMclu.award.Yobiken__c, '○', '×');
      awardWithMclu.award.strSid__c = JapanUtil.convertBooleanString(awardWithMclu.award.Sid__c, '○', '×');
      awardWithMclu.award.strPop__c = JapanUtil.convertBooleanString( awardWithMclu.award.Pop__c, '○', '×');
        awardWithMclu.award.strChirashi__c = JapanUtil.convertBooleanString( awardWithMclu.award.Chirashi__c, '○', '×');
          awardWithMclu.award.StrMessageCoupon__c = JapanUtil.convertBooleanString( awardWithMclu.award.MessageCoupon__c, '○', '×');
          awardWithMclu.award.StrBlind__c = JapanUtil.convertBooleanString( awardWithMclu.award.Blind__c, '○', '×');

          awardWithMclu.award.strMain__c = JapanUtil.convertBooleanString( awardWithMclu.award.chkMain__c, '○', '×');
          awardWithMclu.award.strUnlimited__c = JapanUtil.convertBooleanString( awardWithMclu.award.chkUnlimited__c, '○', '×');
          awardWithMclu.award.strLimit__c = JapanUtil.convertBooleanString( awardWithMclu.award.chkLimit__c, '○', '×');
          awardWithMclu.award.strTime__c = JapanUtil.convertBooleanString( awardWithMclu.award.chkTime__c, '○', '×');

          awardWithMclu.award.strPrintStartDate__c = JapanUtil.convertBooleanString( awardWithMclu.award.PrintStartDate__c, 'yyyy/MM/dd');
          awardWithMclu.award.strPrintStopDate__c = JapanUtil.convertBooleanString( awardWithMclu.award.PrintStopDate__c, 'yyyy/MM/dd');
          awardWithMclu.award.strExpireDate__c = JapanUtil.convertBooleanString( awardWithMclu.award.ExpireDate__c, 'yyyy/MM/dd');

      //Exception Image
      String strAlartId = '';
      Map<String,String> param = new Map<String,String>();
      param.put('TypeA__c', 'ExceptionWarningMessage');

      if(awardWithMclu.award.ExceptionOther__c == true){
             param.put('TypeB__c', 'Alert1');
      }

      //Serch Image Id from Constant Table
      if(awardWithMclu.award.ExceptionActiveNo__c == true){
        JapanConstantsDao constDao = new JapanConstantsDao('ProgramSearchUtil');
        List<JapanConstants__c> listWarningId = (List<JapanConstants__c>)constDao.getValue(param);
        for(JapanConstants__c idWarning : listWarningId){
          awardWithMclu.award.ExceptionImageStr__c = '/servlet/servlet.FileDownload?file=' + idWarning.Value__c;
        }
      }

      //対象MCLUの一覧を抽出
      McluDao mDao = new McluDao('JapanPublicExtension');
        awardWithMclu.mList = (List<MCLU__c>)mDao.getReferencedListWithOrderKey('AwardNB__c', awardWithMclu.award.ID, 'Name');

        awardWithMclu.award.MCLU_CLU__c = '';
        for(MCLU__c mclu : awardWithMclu.mList){
          awardWithMclu.award.MCLU_CLU__c += mclu.Name + '(' + mclu.CluNB__c + ')、';
        }

    }

    }


  /** Inner Class  */
  public class AwardWithMclu {
    public Award__c award { get; set; }
    public List<MCLU__c> mList { get; set; }

    /** Constructor */
    public AwardWithMclu(Award__c paward) {
      award = paward;
    }
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


      award.ExceptionActiveNo__c  = true;
      award.ExceptionImage__c   = true;
      award.ExceptionOther__c   = true;
      update award;

      conCyc.ExceptionActiveNo__c = true;
      conCyc.ExceptionImage__c   = true;
      conCyc.ExceptionOther__c   = true;
      conCyc.SpecialProgramFlag__c  =  true;
      conCyc.PrintStartDate__c   = date.newInstance(2012, 1, 1);
      conCyc.PrintStopDate__c = date.newInstance(2012, 1, 1);
      conCyc.ExpireDate__c = date.newInstance(2012, 1, 1);
      update conCyc;

      ApexPages.StandardController conCycController = new ApexPages.StandardController(conCyc);
      JapanPublicExtension extConCyc = new JapanPublicExtension(conCycController);
      System.assert('ContractCycle__c'.equals(extConCyc.strObjectName));


      award.ExceptionActiveNo__c  = true;
      award.ExceptionImage__c   = true;
      award.ExceptionOther__c   = false;
      update award;

      conCyc.ExceptionActiveNo__c = false;
      conCyc.ExceptionImage__c   = false;
      conCyc.ExceptionOther__c   = false;
      conCyc.PrintStartDate__c   = date.newInstance(2012, 1, 1);
      conCyc.PrintStopDate__c = date.newInstance(2012, 1, 1);
      conCyc.ExpireDate__c = date.newInstance(2012, 1, 1);
      update conCyc;
      conCycController = new ApexPages.StandardController(conCyc);
      extConCyc = new JapanPublicExtension(conCycController);
      System.assert('ContractCycle__c'.equals(extConCyc.strObjectName));


      award.ExceptionActiveNo__c  = true;
      award.ExceptionImage__c   = false;
      award.ExceptionOther__c   = true;
      update award;
      conCycController = new ApexPages.StandardController(conCyc);
      extConCyc = new JapanPublicExtension(conCycController);
      System.assert('ContractCycle__c'.equals(extConCyc.strObjectName));



      award.ExceptionActiveNo__c  = true;
      award.ExceptionImage__c   = false;
      award.ExceptionOther__c   = false;
      update award;
      conCycController = new ApexPages.StandardController(conCyc);
      extConCyc = new JapanPublicExtension(conCycController);
      System.assert('ContractCycle__c'.equals(extConCyc.strObjectName));



      award.ExceptionActiveNo__c  = false;
      award.ExceptionImage__c   = true;
      award.ExceptionOther__c   = true;
      update award;
      conCycController = new ApexPages.StandardController(conCyc);
      extConCyc = new JapanPublicExtension(conCycController);
      System.assert('ContractCycle__c'.equals(extConCyc.strObjectName));



      award.ExceptionActiveNo__c  = false;
      award.ExceptionImage__c   = true;
      award.ExceptionOther__c   = false;
      update award;
      conCycController = new ApexPages.StandardController(conCyc);
      extConCyc = new JapanPublicExtension(conCycController);
      System.assert('ContractCycle__c'.equals(extConCyc.strObjectName));



      award.ExceptionActiveNo__c  = false;
      award.ExceptionImage__c   = false;
      award.ExceptionOther__c   = true;
      update award;
      conCycController = new ApexPages.StandardController(conCyc);
      extConCyc = new JapanPublicExtension(conCycController);
      System.assert('ContractCycle__c'.equals(extConCyc.strObjectName));



      award.ExceptionActiveNo__c  = false;
      award.ExceptionImage__c   = false;
      award.ExceptionOther__c   = false;
      update award;
      AwardWithMclu awardWithMclu = new AwardWithMclu(award);
      conCycController = new ApexPages.StandardController(conCyc);
      extConCyc = new JapanPublicExtension(conCycController);
      System.assert('ContractCycle__c'.equals(extConCyc.strObjectName));



    }


}