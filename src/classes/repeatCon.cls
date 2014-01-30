public with sharing class repeatCon {

  //完全修飾URL
  public String strUrl;

  //カレンダー表示
  //OPSタスク　：　発券日基準
  public Boolean flgPrintBase{set;get;}
  //OPSタスク　：　設置日基準
  public Boolean flgInstallBase{set;get;}
  
  
  //OPSタスク　：　新店※発券日基準
  public Boolean flgOpsTaskNewStore1{set;get;}
  //OPSタスク　：　新店※設置日基準
  public Boolean flgOpsTaskNewStore2{set;get;}
  //OPSタスク　：　増設
  public Boolean flgOpsTaskPlusInstall{set;get;}
  //OPSタスク　：　ｾﾙﾌ増設
  public Boolean flgOpsTaskPlusSelfInstall{set;get;}
  //OPSタスク　：　撤去
  public Boolean flgOpsTaskRemove{set;get;}
  //OPSタスク　：　移設
  public Boolean flgOpsTaskRelocate{set;get;}
  //OPSタスク　：　閉店撤去
  public Boolean flgOpsTaskCloseRemove{set;get;}
  //OPSタスク　：　プリントオフ
  public Boolean flgOpsTaskPrintOff{set;get;}
  //OPSタスク　：　改装
  public Boolean flgOpsRefresh{set;get;}
  //OPSタスク　：　チェック済非表示
  public Boolean flgOpsCheck{set;get;}
  //OPSタスク　：　発券再開
  public Boolean flgOpsTaskRenewalOpen{set;get;}
  //OPSタスク　：　発券再開
  public Boolean flgOpsTaskCloseDate{set;get;}
  //OPSタスク　：　その他
  public Boolean flgOpsTaskOther{set;get;}
  
  public Boolean getFlgOpsTaskNewStore1() { return flgOpsTaskNewStore1; } 
  public Boolean getFlgOpsTaskNewStore2() { return flgOpsTaskNewStore2; } 
  public Boolean getFlgOpsTaskPlusInstall() { return flgOpsTaskPlusInstall; } 
  public Boolean getFlgOpsTaskPlusSelfInstall() { return flgOpsTaskPlusSelfInstall; } 
  public Boolean getFlgOpsTaskRemove() { return flgOpsTaskRemove; } 
  public Boolean getFlgOpsTaskOther() { return flgOpsTaskOther; } 

  public Boolean getFlgOpsTaskPrintOff() { return flgOpsTaskPrintOff; } 
  public Boolean getFlgOpsTaskRenewalOpen() { return flgOpsTaskRenewalOpen; } 
  public Boolean getFlgOpsTaskCloseDate() { return flgOpsTaskCloseDate; } 
  
  
  

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
  public repeatCon() {
  	
  	System.debug('☆☆☆☆☆Point　１　☆☆☆☆☆');
 
 	//POSTパラメータの結果を表示フラグに設定
 	String strWrk = System.currentPageReference().getParameters().get('PrintBase');
 	flgPrintBase = CommonUtil.parseParameterDefaultFalse(strWrk);
 	
 	strWrk = System.currentPageReference().getParameters().get('InstallBase');
 	flgInstallBase = CommonUtil.parseParameterDefaultFalse(strWrk);
 	 	
 	strWrk = System.currentPageReference().getParameters().get('OpsTaskNewStore1');
 	flgOpsTaskNewStore1 = CommonUtil.parseParameterDefaultTrue(strWrk);
 
    strWrk = System.currentPageReference().getParameters().get('OpsTaskNewStore2');
 	flgOpsTaskNewStore2 = CommonUtil.parseParameterDefaultFalse(strWrk);

    strWrk = System.currentPageReference().getParameters().get('OpsTaskPlusInstall');
 	flgOpsTaskPlusInstall = CommonUtil.parseParameterDefaultFalse(strWrk);

    strWrk = System.currentPageReference().getParameters().get('OpsTaskPlusSelfInstall');
 	flgOpsTaskPlusSelfInstall = CommonUtil.parseParameterDefaultFalse(strWrk);

    strWrk = System.currentPageReference().getParameters().get('OpsTaskRemove');
 	flgOpsTaskRemove = CommonUtil.parseParameterDefaultFalse(strWrk);

    strWrk = System.currentPageReference().getParameters().get('OpsTaskRelocate');
 	flgOpsTaskRelocate = CommonUtil.parseParameterDefaultFalse(strWrk);

    strWrk = System.currentPageReference().getParameters().get('OpsTaskOther');
 	flgOpsTaskOther = CommonUtil.parseParameterDefaultFalse(strWrk);

    strWrk = System.currentPageReference().getParameters().get('OpsCheck');
 	flgOpsCheck = CommonUtil.parseParameterDefaultFalse(strWrk);
   	
    strWrk = System.currentPageReference().getParameters().get('OpsTaskCloseRemove');
 	flgOpsTaskCloseRemove = CommonUtil.parseParameterDefaultFalse(strWrk);

    strWrk = System.currentPageReference().getParameters().get('RenewalOpen');
 	flgOpsTaskRenewalOpen = CommonUtil.parseParameterDefaultFalse(strWrk);

	//発券停止
    strWrk = System.currentPageReference().getParameters().get('PrintOff');
 	flgOpsTaskPrintOff = CommonUtil.parseParameterDefaultFalse(strWrk);


	//閉店
    strWrk = System.currentPageReference().getParameters().get('CloseDate');
 	flgOpsTaskCloseDate = CommonUtil.parseParameterDefaultFalse(strWrk);
 
 	strUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/calendarPage';
   
   //パラメタで年月を受け取り、どちらかがnullである場合はシステム年月日を取得
   String strYear = System.currentPageReference().getParameters().get('CMJYear');
   String strMonth = System.currentPageReference().getParameters().get('CMJMonth');
   
   Date d;
   if(strYear == null || strMonth == null || ''.equals(strYear) || ''.equals(strMonth)){
   		//システム年月日を設定
   		d = system.today();
   }else{
   		//対象年月の1日を指定
   		d = Date.newInstance(Integer.valueOf(strYear),Integer.valueOf(strMonth),1);
	}
	setMonth(d);
  }
 
  public List<Month.Week> getWeeks() { 
    return month.getWeeks();
  }
  
  public Month getMonth() { return month; } 
  
  public String getStrUrl() { return strUrl; } 
  
  

  private void setMonth(Date d) { 
  	
    month = new Month(d,flgOpsTaskNewStore1,flgOpsTaskNewStore2,flgOpsTaskPlusInstall,
						flgOpsTaskPlusSelfInstall,flgOpsTaskRemove,flgOpsTaskOther,
						flgOpsTaskCloseRemove,flgOpsTaskRelocate,flgOpsCheck,
						flgOpsTaskRenewalOpen,flgOpsTaskPrintOff,flgOpsTaskCloseDate);

    Date[] da = month.getValidDateRange();  // gather events that fall in this month
  }
  
  private void addMonth(Integer val) { 
    Date d = month.getFirstDate();
    d = d.addMonths(val);
    setMonth(d);
  }

  private Month month;
}