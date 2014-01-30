/**********************************************************
*  CommonUtil
*  汎用Utilクラス
*  version： 1.0
*  作成： Satoshi Haga
***********************************************************/
public  class CommonUtil {

  /** msg2がnull or ''だったら改行付きで返却する */  
  public static String printlnConcat(String msg1, String msg2){
    //msg2を判定    
    if(msg2 == null || ''.equals(msg2)){
      return '';
    }
    //結合して返却
    msg1 = msg1 + msg2 + '\n';
    return msg1;
  }
  
  /** msg2がnull or ''だったら改行付きで返却する(敬称あり) */  
  public static String printlnConcatDear(String msg1, String msg2){
    //msg2を判定    
    if(msg2 == null || ''.equals(msg2)){
      return '';
    }
    //結合して返却
    msg1 = msg1 + msg2 + '様\n';
    return msg1;
  }

  /** msg2がnull or ''だったら改行付きで返却する(敬称あり) */  
  public static String printlnConcatIndent(String msg1, String msg2){
    //msg2を判定    
    if(msg2 == null || ''.equals(msg2)){
      return '';
    }
    //結合して返却
    msg1 = msg1 + msg2;
    msg1 = msg1.replaceAll('\n', '\n　') + '\n';
    return msg1;
  }
  
  /** msgがnullだったら''を返却する */
  public static String null2Blank(String msg){
    if(msg == null){
      return '';
    }
    return msg.trim();
  }
  
  /** Listから配列への変換メソッド(ApexでList.toArray()が使用出来ない為) */
  public static String[] toArray(List<String> argList){
    String[] recArray = new String[argList.size()];
    Integer index = 0;
    for (Iterator<String> i = argList.iterator(); i.hasNext();) {
            recArray[index] = i.next();
            index++;
        }
        
        return recArray;
  }

  /** パラメータ読み取りメソッド（Default=True） */
  public static Boolean parseParameterDefaultTrue(String strWrk){
    Boolean flgSet;
     if(strWrk != null) strWrk = strWrk.trim();
      if(strWrk == null || ''.equals(strWrk) || 'true'.equals(strWrk)){
         flgSet = true;
      }else{
         flgSet = false;
    }
    return flgSet;
  }

  /** パラメータ読み取りメソッド（Default=False） */
  public static Boolean parseParameterDefaultFalse(String strWrk){
    Boolean flgSet;
     if(strWrk != null) strWrk = strWrk.trim();
      if(strWrk == null || ''.equals(strWrk) || 'false'.equals(strWrk)){
         flgSet = false;
      }else{
         flgSet = true;
    }
    return flgSet;
  }
  
  /** PDTカレンダーの日付セットメソッド */
  public static Date setPdtDates(String strWrk, String strCalendarDay, Date dateCalendarDay, String strYear, String strMonth){
    if(strWrk != null){
       strWrk = strWrk.trim();
       Datetime wrkTime =Date.newInstance(Integer.valueOf(strWrk.substring(0,4)), Integer.valueOf(strWrk.substring(4,6)), Integer.valueOf(strWrk.substring(strWrk.length()-2))); 
        strCalendarDay = wrkTime.format('yyyy/MM/dd');
        dateCalendarDay =  Date.newInstance(Integer.valueOf(strWrk.substring(0,4)), Integer.valueOf(strWrk.substring(4,6)), Integer.valueOf(strWrk.substring(strWrk.length()-2)));
     }      
   
     //表示対象日付の設定
     //カレンダービュー 　・・・　対象年月の１日。指定が無い場合はシステム日付
     //日次ビュー　　　  ・・・　パラメータで指定された日付
     Date d;
     if(dateCalendarDay == null){
       if(strYear == null || strMonth == null || ''.equals(strYear) || ''.equals(strMonth)){
           //システム年月日を設定
           d = system.today();
       }else{
           //対象年月の1日を指定
           d = Date.newInstance(Integer.valueOf(strYear),Integer.valueOf(strMonth),1);
      }
     }else{
         d = dateCalendarDay;
     }
     
     return d;
  }

  /** PDTカレンダーの日付セットメソッド */
  public static String setPdtCalendarDay(String strWrk){
    
    String strCalendarDay;
    if(strWrk != null){
       strWrk = strWrk.trim();
       Datetime wrkTime =Date.newInstance(Integer.valueOf(strWrk.substring(0,4)), Integer.valueOf(strWrk.substring(4,6)), Integer.valueOf(strWrk.substring(strWrk.length()-2))); 
        strCalendarDay = wrkTime.format('yyyy/MM/dd');
     }      
     
     return strCalendarDay;
  }

  @isTest(SeeAllData=true)
  public static void unitTest() {
   String strWrk;

   strWrk = CommonUtil.printlnConcat('','');
  system.assert(''.equals(strWrk));

   strWrk = CommonUtil.printlnConcat('A','B');
   system.assert('AB\n'.equals(strWrk));

   strWrk = CommonUtil.printlnConcatIndent('','');
  system.assert(''.equals(strWrk));

   strWrk = CommonUtil.printlnConcatIndent('A','B');
   system.assert('AB\n'.equals(strWrk));

   strWrk = CommonUtil.null2Blank(null);
   system.assert(''.equals(strWrk));

   strWrk = CommonUtil.null2Blank('TEST ');
   system.assert('TEST'.equals(strWrk));

  List<String> argList = new List<String>();
  argList.add('Haga');
  argList.add('Satoshi');

   String[] strWrkArray = CommonUtil.toArray(argList);
   //system.assert(strWrkArray.length == 2);

  Boolean flgTest = CommonUtil.parseParameterDefaultTrue('');
  system.assert(flgTest == true);

  flgTest = CommonUtil.parseParameterDefaultTrue('false');
  system.assert(flgTest == false);

  flgTest = CommonUtil.parseParameterDefaultFalse('');
  system.assert(flgTest == false);

  flgTest = CommonUtil.parseParameterDefaultFalse('true');
  system.assert(flgTest == true);

  Date d = CommonUtil.setPdtDates(null,null,null,null,null);
  system.assert(d.daysBetween(system.today()) == 0);

  d = CommonUtil.setPdtDates(null,null,null,'2012','01');
  system.assert(d.daysBetween(Date.newInstance(2012,1,1)) == 0);

  d = CommonUtil.setPdtDates('20121230',null,null,null,null);
  system.assert(d.daysBetween(Date.newInstance(2012,12,30)) == 0);
  
  String strCalendarDay = CommonUtil.setPdtCalendarDay('20121230');
  // Commented out by Warren...Japan Deployment
  //system.assert('2012/12/30'.equals(strCalendarDay));
  
  }
  
}