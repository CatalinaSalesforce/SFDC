public class MainDTO{
  
  //セッションに格納したい情報
  
  public String info1{get;set;}
  public String info2{get;set;}
  public String info3{get;set;}
  
  @isTest(SeeAllData=true)
  public static void unitTest() {
    MainDTO dto = new MainDTO();
    dto.info1 = '☆☆☆1☆☆☆';
    dto.info2 = '☆☆☆2☆☆☆';
    dto.info3 = '☆☆☆3☆☆☆';
    
    System.assert('☆☆☆1☆☆☆'.equals(dto.info1));
    System.assert('☆☆☆2☆☆☆'.equals(dto.info2));
    System.assert('☆☆☆3☆☆☆'.equals(dto.info3));
    
  }
  
}