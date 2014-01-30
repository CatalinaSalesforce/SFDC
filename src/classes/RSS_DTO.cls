public with sharing class RSS_DTO{
    public Boolean checked{get;set;}
    public StoreInfo__c rss{get;set;}
    
    //検索結果のランキング
    public Integer rank{get;set;}
  
    public RSS_DTO(){
      checked = false;
      rss = new StoreInfo__c();
    }
    
    @isTest(SeeAllData=true)
    public static void unitTest() {
      RSS_DTO dto = new RSS_DTO();
      System.assert(dto.checked == false);
      System.assert(dto.rss != null);
    }
    
}