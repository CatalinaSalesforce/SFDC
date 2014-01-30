/*
@Name            : JapanUtil
@Author          : Satoshi Haga
@Date            : July 1, 2013
@Description     : Utility Class
@version         : 07/01/2013 First Creation
*/
public class JapanUtil {

  /*
     Function name. This is used for logging.
   */
  public String strFunctionalName;

  /**
   * Constructor
   * @param strFunctionalName functional name for logging
   */
  public JapanUtil(String strFunctionalName){
    this.strFunctionalName = strFunctionalName;
  }

  /**
   * Debugging function.
   * @param strDebug Debugging message.
   */
  public void debug(String strDebug){
    System.debug('@@@Japan Log@@@JapanUtil called@@@ function=' + strFunctionalName + '@@@ ' + strDebug);
  }




  /**
   * Debugging function.
   * @param strDebug Debugging message.
   */
  public static String convertBooleanString(Boolean src, String replyTrue, String replyFalse){
    if(src == true){
      return replyTrue;
    }else{
      return replyFalse;
    }
  }

  /**
   * Converting method from date to String.
   * @param src data source.
   * @param strFormat String Format. For example, 'yyyy-mm-dd'.
   */
  public static String convertBooleanString(Date src, String strFormat){
    Datetime wrk = src;
    return wrk.format(strFormat);
  }

  /**
   * Check if parameter date is business day or not.
   * It is defined on OPS_DAILY_WORK__c wheter this date is business-day or not.
   * @param wrkDate data source.
   * @param Boolean True : Business day. False : Not business day.
   */
  public Boolean isBusinessDay(Date wrkDate){

      //Get HolidayFlg from OPS_DAILY_WORK__c
      List<OPS_DAILY_WORK__c> listCal = [select id, Name, HolidayCheck__c, SaturdayCheck__c, SundayCheck__c from OPS_DAILY_WORK__c where ActDate__c = :wrkDate];

      //Defalt is Business
      if(listCal.size() == 0){
        return true;
      }

      OPS_DAILY_WORK__c recCal = listCal.get(0);

      //土日祝の場合は、falseを返却
      if(recCal.HolidayCheck__c == true || recCal.SaturdayCheck__c == true || recCal.SundayCheck__c == true){
        return false;
      }else{
        return true;
      }
  }

  //2013/09/02 Satoshi Haga Add Start
  /**
   * Return  next business day
   * @param  wrkDate data source.
   * @return next business date
   */
  public Date nextBusinessDay(Date wrkDate){

    wrkDate = wrkDate.addDays(1);

    //continue to loop by when next date is business date
    while(!isBusinessDay(wrkDate)){
      wrkDate = wrkDate.addDays(1);
    }

    //Return
    return wrkDate;
  }
  //2013/09/02 Satoshi Haga Add End

  /**
   * Check if parameter  is empty string or not. "Empty" means either null or ''.
   * @param pString data source.
   * @param Boolean True : empty string. False : string with some value
   */
  public static Boolean isBlank(String pString){
    return ((pString == null) || (pString.length() == 0));
  }

  /**
   * Separate string to list object
   * @param pString     data source.
   * @param List<String>   List of String
   */
  public static List<String> convertMultiPick(String pString){
    String[] aryMultiPick = pString.split(';');
    List<String> listStr = new List<String>();

    for(String strPickValue : aryMultiPick){
      listStr.add(strPickValue);
    }

    return listStr;
  }

  /**
   * Check if the two list have the same value
   * @param aList   Data source.
   * @param bList   Data source.
   * @param Boolean   True : these have the same value  Flase : these don't have the same value
   */
  public static Boolean checkSameValue(List<String> aList, List<String> bList){
    for(String strValueA : aList){
      for(String strValueB : bList){
        if(strValueA != null && strValueB != null){
          if(strValueA.trim().equals(strValueB.trim())){
            //Parameter 2 list have the same value
            return true;
          }
        }
      }
    }
    //Parameter 2 list don't have the same value
    return false;
  }


  /**
   * Create message string from Mclu object
   * @param mclu     Mclu Object
   * @param String   Message string
   */
  public static String getImage(MCLU__c mclu){
    String strRet = (String)mclu.ClientName__c + ' ～ ' + (String)mclu.CategName__c + ' ～ ' + (String)mclu.CouponOfferLineA__c + ' ～ ' + (Integer)mclu.ImageNumber__c;

    return strRet;
  }

  /**
   * Test method
   */
  @isTest(SeeAllData=true)
    public static void unitTest() {
      JapanUtil util = new JapanUtil('unitTest');
      util.debug('Test');
	  JapanUtil.convertBooleanString(date.newinstance(2013, 7, 1),'yyyy/MM/dd');
	  JapanUtil.convertBooleanString(util.nextBusinessDay(date.newinstance(2013, 6, 29)),'yyyy/MM/dd');


      System.assert('AnswerA'.equals(JapanUtil.convertBooleanString(true,'AnswerA','AnswerB')));
      System.assert('AnswerB'.equals(JapanUtil.convertBooleanString(false,'AnswerA','AnswerB')));
      System.assert(util.isBusinessDay(date.newinstance(2017, 7, 1)) == true);
      System.assert(util.isBusinessDay(date.newinstance(2013, 7, 1)) == true);
      System.assert(util.isBusinessDay(date.newinstance(2013, 6, 30)) == false);
      System.assert(JapanUtil.isBlank(null) == true);

      List<String> strList = JapanUtil.convertMultiPick('AAA;BBB;CCC');
      System.assert(strList.size() == 3);

      List<String> strListA = new List<String>();
      strListA.add('AnswerA');

      List<String> strListB = new List<String>();
      strListB.add('AnswerA');

      System.assert(JapanUtil.checkSameValue(strListA,strListB) == true);

      List<String> strListC = new List<String>();
      strListC.add('AnswerC');
      System.assert(JapanUtil.checkSameValue(strListA,strListC) == false);



    }


}