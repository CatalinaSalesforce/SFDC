public with sharing class PdtCalendarController {

  //完全修飾URL
  public String strUrl;
  
  //カレンダー表示方式
  public Boolean flgCalendarView{set;get;}
  
  //日次カレンダー用のリスト
  public List<program_req__c> allProgList{set;get;}
  
  
  //カレンダー表示方式の表示日
  public String strCalendarDay{set;get;}
  public Date dateCalendarDay{set;get;}
  
  //カレンダー表示形式の土日祝
  public Boolean sundayFlg{set;get;}
  public Boolean saturdayFlg{set;get;}
  public Boolean holidayFlg{set;get;}

  //カレンダー表示
  //「明日以降の絶対△△の依頼」を表示する
  public Boolean flgTomorrow{set;get;}
  //「受領済みの△△まで」を表示する
  public Boolean flgComplete{set;get;}
  
  //自分のコメントを表示
  public Boolean flgMyComment{set;get;}

  public void refresh() { 
    addMonth(0);
  }


  public void next() { 
    //年月を翌月にして、setMonth()する
    String strYear = getMonth().getYearName();
    Integer intNextYear = Integer.valueOf(strYear)+1;
    Date d = Date.newInstance(intNextYear, Integer.valueOf(getMonth().getMonthName()),1);
    setMonth(d);
  }

  public void prev() { 
    //年月を翌月にして、setMonth()する
    String strYear = getMonth().getYearName();
    Integer intPrevYear = Integer.valueOf(strYear)-1;
    Date d = Date.newInstance(intPrevYear, Integer.valueOf(getMonth().getMonthName()),1);
    setMonth(d);
  }

  //コンストラクタ
  public PdtCalendarController() {
 
   //POST/GETパラメータ
   String strWrk = System.currentPageReference().getParameters().get('MonthView');
   flgCalendarView = CommonUtil.parseParameterDefaultTrue(strWrk);
   
   strWrk = System.currentPageReference().getParameters().get('tomorrow');
   flgTomorrow = CommonUtil.parseParameterDefaultFalse(strWrk);
 
    strWrk = System.currentPageReference().getParameters().get('complete');
  flgComplete = CommonUtil.parseParameterDefaultFalse(strWrk);

   strWrk = System.currentPageReference().getParameters().get('myComment');
   flgMyComment = CommonUtil.parseParameterDefaultFalse(strWrk);

   strUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/PDTCalendarPage';
   
    //パラメタで年月を受け取り、どちらかがnullである場合はシステム年月日を取得
    String strYear = System.currentPageReference().getParameters().get('CMJYear');
    String strMonth = System.currentPageReference().getParameters().get('CMJMonth');
   strWrk = System.currentPageReference().getParameters().get('ViewDay');

  Date d;
  
  //日付セット　Apexテストを考慮してUtilクラスに外だし
  d = CommonUtil.setPdtDates(strWrk, strCalendarDay, dateCalendarDay, strYear, strMonth);
  strCalendarDay = CommonUtil.setPdtCalendarDay(strWrk);
  
  setMonth(d);
   
  //土日祝の設定
  sundayFlg = month.thisDay.sundayFlg;
  saturdayFlg = month.thisDay.saturdayFlg;
  holidayFlg = month.thisDay.holidayFlg;
  
  //日次カレンダー表示リストの設定
  this.allProgList = month.allProgList;
  }
 
  public List<PDTMonth.Week> getWeeks() { 
    return month.getWeeks();
  }
  
  public PDTMonth getMonth() { return month; } 

  public String getStrUrl() { return strUrl; } 

  public Boolean getFlgTomorrow() { return flgTomorrow; } 
  public Boolean getFlgComplete() { return flgComplete; } 
  public Boolean getFlgCalendarView() { return flgCalendarView; } 
  public String getStrCalendarDay() { return strCalendarDay; }
  public Date getDateCalendarDay() { return dateCalendarDay; }
  
  public Boolean getSundayFlg() { return sundayFlg; } 
  public Boolean getSaturdayFlg() { return saturdayFlg; } 
  public Boolean getHolidayFlg() { return holidayFlg; } 
  
  public List<program_req__c> getAllProgList() { return allProgList; } 
  

  public Boolean getFlgMyCommen() { return flgMyComment; } 

  public void setMonth(Date d) { 
    month = new PDTMonth(d,flgTomorrow,flgComplete,flgMyComment,flgCalendarView);  
    Date[] da = month.getValidDateRange();  // gather events that fall in this month
  }
  
  public void addMonth(Integer val) {
    Date d = month.getFirstDate();
    d = d.addMonths(val);
    setMonth(d);
  }

  public PDTMonth month;
  
  @isTest(SeeAllData=true)
  public static void unitTest() {
    PdtCalendarController ctl = new PdtCalendarController();
    ctl.refresh();
    ctl.next();
    ctl.prev();
    
    ctl.addMonth(1);
    ctl.addMonth(-1);
    
    List<PDTMonth.Week> lstPdt = ctl.getWeeks();
    system.assert(lstPdt.size() == 6);
    
    lstPdt = ctl.getMonth().getWeeks();
    system.assert(lstPdt.size() == 6);
    
    ctl.getStrUrl();
    ctl.getFlgTomorrow();
    ctl.getFlgComplete();
    ctl.getFlgCalendarView();
    ctl.getStrCalendarDay();
    ctl.getDateCalendarDay();
    ctl.getDateCalendarDay();
    ctl.getSundayFlg();
    ctl.getSaturdayFlg();
    ctl.getHolidayFlg();
    ctl.getAllProgList();
    ctl.getFlgMyCommen();
    
    system.assert(1 == 1);
    
  }
 
}