public  class StoreUtil {

  /** CSV出力の為の項目付与関数 */
  public RSS_DTO convertDto(RSS_DTO dto){
    datetime tempTime;
    Integer wrkLength = 0;
    
    if (dto.rss.InstallationDate__c != null){
      tempTime = dto.rss.InstallationDate__c;
      dto.rss.InstallationDate_Excel__c = tempTime.format('yyyy/MM/dd', 'JST');
    }
    //発券開始日
    if (dto.rss.StartDay__c != null){
      tempTime = dto.rss.StartDay__c;
      dto.rss.StartDay_Excel__c = tempTime.format('yyyy/MM/dd', 'JST');
    }
    //チェーン番号_Excel用
    dto.rss.Chain_Excel__c = dto.rss.Chain__c.substring(0, 3);
    //チェーン名称_Exel用
    dto.rss.ChainName_Excel__c = dto.rss.Chain__c.substring(dto.rss.Chain_Excel__c.length()+3, dto.rss.Chain__c.length());
    //返却
    return dto;
  }
  
  /** 検索条件からSQLを取得する */
  public String getSearchString(RssSearch__c rss, Boolean flgColumn, String clmLimit){
    
    String query;
    if(flgColumn == true){
      query = 'SELECT OpenStatus__c  , Chain__c , StoreNo__c , StoreName__c , Yago__c , PrefectureName__c , OldShopName__c , Liquor__c , StartDay__c , InstallationDate__c FROM StoreInfo__c';  
    }else{
      //Field名を取得
      Map<String,Schema.SObjectField> fieldMap = StoreInfo__c.sObjectType.getDescribe().fields.getMap();
      List<Schema.SObjectField> fieldList = fieldMap.values();
      String selectFields ='';
      for(Integer i =0; i< fieldList.size();i++){
        Schema.SObjectField field = fieldList.get(i);
        if(i==0){
          selectFields += field.getDescribe().getName() + ' ';
        }else{
          selectFields += ', ' + field.getDescribe().getName(); 
        }
      }
  
      //検索SOQLの作成
      query='SELECT ' + selectFields + ' FROM StoreInfo__c';
    }    
    
    
    String joinString = ' WHERE ';

    //チェーン(複数選択)
    if (rss.ChainList__c != null && rss.ChainList__c != ''){
      String[] chainAry = rss.ChainList__c.split(';');
      String strIn = '(';
      
      for(String strChain: chainAry){
        strIn += '\''  + strChain+ '\',';
      }
      strIn += '\'\')';
      
      query += joinString + ' Chain__c In '  + strIn;
      joinString = ' AND ';
    }

    //都道府県名(複数選択)
    if (rss.PrefectureName__c != null && rss.PrefectureName__c != ''){
      String[] prefAry = rss.PrefectureName__c.split(';');
      
      String strIn = '(';
      
      for(String strPref: prefAry){
        strIn += '\''  + strPref+ '\',';
      }
      strIn += '\'\')';
      
      query += joinString + ' PrefectureName__c In '  + strIn;
      joinString = ' AND ';
    }

    //屋号
    if (rss.Yago__c != null && rss.Yago__c != ''){
      query += joinString + ' Yago__c = \'' + rss.Yago__c + '\'';
      joinString = ' AND ';
    }

    //旧チェーン
    if (rss.OldCahinCode__c != null && rss.OldCahinCode__c != ''){
      query += joinString + ' OldCahinCode__c = \'' + rss.OldCahinCode__c + '\'';
      joinString = ' AND ';
    }

    //旧屋号
    if (rss.OldShopName__c != null && rss.OldShopName__c != ''){
      query += joinString + ' OldShopName__c LIKE \'' + '%' + rss.OldShopName__c + '%' + '\'';
      joinString = ' AND ';
    }

    //旧店舗番号
    if (rss.OldStoreNumber__c != null && rss.OldStoreNumber__c != ''){
      query += joinString + ' OldStoreNumber__c LIKE \'' + '%' + rss.OldStoreNumber__c + '%' + '\'';
      joinString = ' AND ';
    }

    //旧店舗名称
    if (rss.OldStoreName__c != null && rss.OldStoreName__c != ''){
      query += joinString + ' OldStoreName__c LIKE \'' + '%' + rss.OldStoreName__c + '%' + '\'';
      joinString = ' AND ';
    }

    //酒販免許
    if (rss.Liquor__c != null && rss.Liquor__c != ''){
      query += joinString + ' Liquor__c = \'' + rss.Liquor__c + '\'';
      joinString = ' AND ';
    }

    //設置日
    if (rss.InstallationDate__c != null ){
      String strCriteria = rss.InstallationDate__c.substring(0,1);
      query += joinString + ' InstallationDate__c = ' + rss.InstallationDate__c ;
      joinString = ' AND ';
    }

    //店舗番号
    if (rss.StoreNo__c != null){
      query += joinString + ' StoreNo__c = ' + rss.StoreNo__c;
      joinString = ' AND ';
    }

    //店舗名称
    if (rss.StoreName__c != null && rss.StoreName__c != ''){
      query += joinString + ' StoreName__c LIKE \'' + '%' + rss.StoreName__c + '%' + '\'';
      joinString = ' AND ';
    }

    
    //開店ステータス
    if (rss.OpenStatus__c != null && rss.OpenStatus__c != ''){
      query += joinString + ' OpenStatus__c = \'' + rss.OpenStatus__c + '\'';
      joinString = ' AND ';
    }
    
    //調剤 
    if (rss.chozai__c != null && rss.chozai__c != ''){
      query += joinString + ' chozai__c = \''+ rss.chozai__c + '\'';
      joinString = ' AND ';
    }
    //(イオン)カンパニー
    if (rss.Company__c != null && rss.Company__c != ''){
      query += joinString + ' Company__c = \''+ rss.Company__c + '\'';
      joinString = ' AND ';
    }
    //(イオン)事業部
    if (rss.AEON_JIGYOBU__c != null && rss.AEON_JIGYOBU__c != ''){
      query += joinString + ' AEON_JIGYOBU__c = \''  + rss.AEON_JIGYOBU__c + '\'';
      joinString = ' AND ';
    }
    //(フジ)事業部
    if (rss.FUJI_JIGYOBU__c != null && rss.FUJI_JIGYOBU__c != ''){
      query += joinString + ' FUJI_JIGYOBU__c = \'' + rss.FUJI_JIGYOBU__c  + '\'';
      joinString = ' AND ';
    }

    if (rss.Beisia_SC__c != null && rss.Beisia_SC__c != ''){
      query += joinString + ' Beisia_SC__c = \'' + rss.Beisia_SC__c + '\'';
      joinString = ' AND ';
    }

    if (rss.StartDay__c != null){
      
      //等号・不等号の判定
      String strCriteria = rss.StartDay__c.substring(0,1);
      query += joinString + ' StartDay__c = ' + rss.StartDay__c;
      joinString = ' AND ';
      
    }

    query += ' ORDER BY Chain__c,StoreNo__c ';

    query += ' LIMIT ' + clmLimit;
    
    //SQL分を返却
    return query;
  }
  
  public void addMessage(Integer recCount, Integer limitCount, String strMessage){
    if(recCount >= limitCount){
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, strMessage));
    }
  }
  
  
  public void updateRanking(List<RSS_DTO> rsslist, List<StoreInfo__c> searchResult){
    Integer cnt = 1;
    for(StoreInfo__c rss : searchResult){
      RSS_DTO temp = new RSS_DTO();
      temp.rss = rss;
      
      //検索結果のランキング
      temp.rank = cnt;
      cnt++;
      
      rsslist.add(temp);
    } 

  }

}