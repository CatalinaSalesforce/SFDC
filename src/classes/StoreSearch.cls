public with sharing class StoreSearch {

  /** 検索条件*/
  public RssSearch__c rss{get;set;}
    
  /** DTOクラスのリスト */
  public List<RSS_DTO> rsslist{get;set;}

    //初期処理
  public void init(){
    rss = new RssSearch__c();
    //added by Warren to resolve null eror
    rsslist = new List<RSS_DTO>();
  }

  public PageReference moveExcel() {
    StoreUtil util = new StoreUtil();
    for(RSS_DTO rssDto : rsslist){
      rssDto = util.convertDto(rssDto);
    }
    PageReference excelPage = Page.StorePage;
    
    return excelPage;
  }
  
  //新規画面に遷移 
  public PageReference createNew() {
    
    SObject sobj = new StoreInfo__c();
    String strObjName = sobj.getSObjectType().getDescribe().getKeyPrefix();
    PageReference newPage = new PageReference('/' + strObjName + '/e');
    return newPage;
  }

  public PageReference bulkUpdate() {
    StoreUtil util = new StoreUtil();
    List<StoreInfo__c> updatersslist = new List<StoreInfo__c>();
    for(RSS_DTO dto : rsslist){
      if(dto.checked){
        updatersslist.add(dto.rss);
      }
    }
    if(updatersslist.size() > 0){
      update updatersslist;
    }
  
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, updatersslist.size() + '件のデータの処理が完了しました。'));
      
    return null;
  }
  //検索条件、検索結果の両方のクリア
  public PageReference clear(){
    rss = new RssSearch__c();
    rsslist = new List<RSS_DTO>();
    return null;
  }

  //検索条件のみクリア
  public PageReference clearCriteria(){
    rss = new RssSearch__c();
    return null;
  }

  //検索結果のみのクリア
  public PageReference clearResult(){
    rsslist = new List<RSS_DTO>();
    return null;
  }

  public PageReference cancel(){
    search();
    return null;
  }

  /** 検索処理 */
  public PageReference search() {
    List<StoreInfo__c> searchResult = new List<StoreInfo__c>();
    rsslist = new List<RSS_DTO>();
  
    StoreUtil util = new StoreUtil();
    String query = util.getSearchString(rss,true, '800');
    searchResult = database.query(query);
    
    util.addMessage(searchResult.size(), 800, '検索条件で得られる結果が800件を超えています。800件目以降は表示されません。');
    util.updateRanking(rsslist, searchResult);

    return null;
  }
  
  /** CSV出力処理 */
  public PageReference outPutCsv() {
    List<StoreInfo__c> searchResult = new List<StoreInfo__c>();
    rsslist = new List<RSS_DTO>();
  
    StoreUtil util = new StoreUtil();
    String query = util.getSearchString(rss,false, '500');
    searchResult = database.query(query);
    util.addMessage(searchResult.size(), 500, '検索条件で得られる結果が500件を超えています。500件目以降は表示されません。');
    for(StoreInfo__c rss : searchResult){
      RSS_DTO temp = new RSS_DTO();
      temp.rss = rss;
      rsslist.add(util.convertDto(temp));
    } 
    PageReference pageRef = Page.StoreCsvPage;
    
    return pageRef;
  }
  
  /** テストメソッド */
  @isTest(SeeAllData=true)
    public static void unitTest() {
      //テストケース
      //　　　①イズミで検索⇒検索条件のみクリア⇒検索結果のみのクリア⇒検索条件、検索結果の両方のクリア
      //　　　②イズミで検索⇒全レコード更新⇒Excel出力
      //　　　③イズミでCSV出力
      //　　　④全件出力で1000件のメッセージを出力
      
      //★★★①★★★
      RssSearch__c criteria = new RssSearch__c();
      criteria.ChainList__c = '008　：　イズミ';
      
      //検索機能を初期化⇒イズミをセット⇒検索⇒独自に検索して件数比較
      StoreSearch strFunc = new StoreSearch();
      strFunc.init();
      strFunc.rss = criteria;
      strFunc.rsslist = new List<RSS_DTO>();
      strFunc.search();
      
      List<StoreInfo__c> testList = [select id, Name from StoreInfo__c where Chain__c In ('008　：　イズミ','')];
      System.debug('★★★strFunc.rsslist.size()' + strFunc.rsslist.size());
      System.debug('★★★testList.size()' + testList.size());
      System.assert(strFunc.rsslist.size() == testList.size());
      strFunc.cancel();
      System.assert(strFunc.rsslist.size() == testList.size());
      
      
      //クリア
      strFunc.clearCriteria();
      System.assert(strFunc.rss.ChainList__c == null);
      strFunc.clearResult();
      System.assert(strFunc.rsslist.size() == 0);
      strFunc.clear();
      System.assert(strFunc.rsslist.size() == 0 && strFunc.rsslist.size() == 0);
      
      
      //★★★②★★★
    //イズミで検索⇒更新フラグをセット⇒更新
      criteria = new RssSearch__c();
      criteria.ChainList__c = '008　：　イズミ';
      
      strFunc = new StoreSearch();
      strFunc.init();
      strFunc.rss = criteria;
      strFunc.rsslist = new List<RSS_DTO>();
      strFunc.search();
    for(RSS_DTO dto : strFunc.rsslist){
      dto.checked = true;
    }
    
      PageReference testPage = strFunc.bulkUpdate();
      System.assert(testPage == null);
      
      //Excel出力
      //testPage = strFunc.moveExcel();
      //System.assert(testPage.getUrl() == Page.StorePage.getUrl());
      
      //★★★③★★★
      criteria = new RssSearch__c();
      criteria.ChainList__c = '008　：　イズミ';
      
      strFunc = new StoreSearch();
      strFunc.init();
      strFunc.rss = criteria;
      strFunc.rsslist = new List<RSS_DTO>();
      /*testPage = strFunc.outPutCsv();
      System.assert(testPage.getUrl() == Page.StoreCsvPage.getUrl());

    testPage = strFunc.createNew();
    
    SObject sobj = new StoreInfo__c();
     String strObjName = sobj.getSObjectType().getDescribe().getKeyPrefix();
     PageReference newPage = new PageReference('/' + strObjName + '/e');
     
     System.assert(testPage.getUrl() == newPage.getUrl());*/
      
      //★★★④★★★
      criteria = new RssSearch__c();
      
      strFunc = new StoreSearch();
      strFunc.init();
      strFunc.rss = criteria;
      strFunc.rsslist = new List<RSS_DTO>();
      strFunc.search();
    }
    
  @isTest(SeeAllData=true)
    public static void unitTestStoreUtil() {
    //上記テストでカバー出来ない部分をテスト
    StoreUtil util = new StoreUtil();
    
      RSS_DTO dto = new RSS_DTO();
      dto.rss.InstallationDate__c =Date.newInstance(2012, 11, 25);
      dto.rss.StartDay__c =Date.newInstance(2012, 11, 25);
      dto.rss.Chain__c ='008　：　イズミ';
   
      dto = util.convertDto(dto);
      
      System.assert('2012/11/25'.equals(dto.rss.InstallationDate_Excel__c));
      System.assert('2012/11/25'.equals(dto.rss.StartDay_Excel__c));
      
      
      //全く検索条件を含まない場合はWhereさえ含まない
      RssSearch__c crt = new RssSearch__c();
      crt.ChainList__c = null;
      crt.PrefectureName__c = null;
      crt.Yago__c = null;
      crt.OldCahinCode__c = null;
      crt.OldShopName__c = null;
      crt.OldStoreNumber__c = null;
      crt.OldStoreName__c = null;
      crt.Liquor__c = null;
      crt.InstallationDate__c = null;
      crt.StoreNo__c = null;
      crt.StoreName__c = null;
      crt.OpenStatus__c = null;
      crt.chozai__c = null;
      crt.Company__c = null;
      crt.AEON_JIGYOBU__c = null;
      crt.FUJI_JIGYOBU__c = null;
      crt.Beisia_SC__c = null;
      crt.StartDay__c = null;
      
      String strSQL = util.getSearchString(crt, true, '800');
      System.debug('★★★★SQL=' + strSQL);
      System.debug('★★★★strSQL.indexOf(WHERE)=' + strSQL.indexOf('WHERE'));
      System.assert(strSQL.indexOf('WHERE') < 0);
      
      //全ての検索条件を含む場合はカラム名も含まれるはず
      crt = new RssSearch__c();
      crt.ChainList__c = '★';
      crt.PrefectureName__c = '★';
      crt.Yago__c = '★';
      crt.OldCahinCode__c = '★';
      crt.OldShopName__c = '★';
      crt.OldStoreNumber__c = '★';
      crt.OldStoreName__c = '★';
      crt.Liquor__c = '★';
      crt.InstallationDate__c = '★';
      crt.StoreNo__c = 999;
      crt.StoreName__c = '★';
      crt.OpenStatus__c = '★';
      crt.chozai__c = '★';
      crt.Company__c = '★';
      crt.AEON_JIGYOBU__c = '★';
      crt.FUJI_JIGYOBU__c = '★';
      crt.Beisia_SC__c = '★';
      crt.StartDay__c = '★';
      
      strSQL = util.getSearchString(crt, true, '800');
      System.assert(strSQL.indexOf('Chain') >= 0);
      System.assert(strSQL.indexOf('PrefectureName__c') >= 0);
      System.assert(strSQL.indexOf('Yago__c') >= 0);
      System.assert(strSQL.indexOf('OldCahinCode__c') >= 0);
      System.assert(strSQL.indexOf('OldShopName__c') >= 0);
      System.assert(strSQL.indexOf('OldStoreNumber__c') >= 0);
      System.assert(strSQL.indexOf('OldStoreName__c') >= 0);
      System.assert(strSQL.indexOf('Liquor__c') >= 0);
      System.assert(strSQL.indexOf('InstallationDate__c') >= 0);
      System.assert(strSQL.indexOf('StoreNo__c') >= 0);
      System.assert(strSQL.indexOf('StoreName__c') >= 0);
      System.assert(strSQL.indexOf('OpenStatus__c') >= 0);
      System.assert(strSQL.indexOf('chozai__c') >= 0);
      System.assert(strSQL.indexOf('Company__c') >= 0);
      System.assert(strSQL.indexOf('AEON_JIGYOBU__c') >= 0);
      System.assert(strSQL.indexOf('FUJI_JIGYOBU__c') >= 0);
      System.assert(strSQL.indexOf('Beisia_SC__c') >= 0);
      System.assert(strSQL.indexOf('StartDay__c') >= 0);
      
      
      
    }
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
}