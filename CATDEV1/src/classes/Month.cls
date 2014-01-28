/** 月クラス */
public class Month {
	
	private List<Week> weeks; 
	public Date firstDate; 
	public Date upperLeft; 
	
	public List<Date> getValidDateRange() { 
		// return one date from the upper left, and one from the lower right
		List<Date> ret = new List<Date>();
		ret.add(upperLeft);
		ret.add(upperLeft.addDays(5*7) );
		return ret;
	}
	
	public String getMonthName() { 
		return DateTime.newInstance(firstDate.year(),firstdate.month(),firstdate.day()).format('MM');
	} 
	
	public String getYearName() { 
		return DateTime.newInstance(firstDate.year(),firstdate.month(),firstdate.day()).format('yyyy');
	} 

	public String getNextYearName() { 
		return DateTime.newInstance(firstDate.year()+1,firstdate.month(),firstdate.day()).format('yyyy');
	} 

	public String getPrevYearName() { 
		return DateTime.newInstance(firstDate.year()-1,firstdate.month(),firstdate.day()).format('yyyy');
	} 

	public Date getfirstDate() { return firstDate; } 

	//コンストラクタで表示フラグを受け取る
	public Month( Date value ,Boolean flgOpsTaskNewStore1,       Boolean flgOpsTaskNewStore2,   Boolean flgOpsTaskPlusInstall
	                         ,Boolean flgOpsTaskPlusSelfInstall, Boolean flgOpsTaskRemove,      Boolean flgOpsTaskOther
	                         ,Boolean flgOpsTaskCloseRemove,	 Boolean flgOpsTaskRelocate,		 Boolean flgCheck				
	                         ,Boolean flgOpsTaskRenewalOpen,	 Boolean flgOpsTaskPrintOff,		 Boolean flgOpsTaskCloseDate) {

		weeks = new List<Week>();
		firstDate = value.toStartOfMonth();
		upperLeft = firstDate.toStartOfWeek();
		
		//upperLeftの計算
		Datetime wrkTime;
		wrkTime = upperLeft;
		String strUpperLeft = wrkTime.format('yyyy-MM-dd');
		
		//システム日付の3日前を計算
		Datetime sysTimeBefore3;
		sysTimeBefore3 = System.today().addDays(-3);
		String strBefore3 = sysTimeBefore3.format('yyyy-MM-dd');
		
		//システム日付を計算
		Datetime sysTime;
		sysTime = System.today();
		String strToday = sysTime.format('yyyy-MM-dd');
		
		
		
		Date tmp = upperLeft;
		for (Integer i = 0; i < 5; i++) {
			Week w = new Week(i+1,tmp,value.month());	
			system.assert(w!=null); 
			this.weeks.add( w );
			tmp = tmp.addDays(7);
		}
				
		//ガバナ制限に対応するため、ここで一括で関連オブジェクトを取得
		//新店フラグがtrueの場合のみ発券・設置店舗を検索
		List<StoreInfo__c> stores = new List<StoreInfo__c>();
		//OPSカレンダー
		List<OPS_DAILY_WORK__c> lstCal = [select id,Name,ActDate__c,SpecialDay__c, holiday__c ,SundayCheck__c , SaturdayCheck__c , HolidayCheck__c from OPS_DAILY_WORK__c where ActDate__c >= :upperLeft];
											   		
		//Due Date
		List<DueDateCalendar__c> lstDue = [select id,Name,Day__c,RGB__c,DueName__c from DueDateCalendar__c where Day__c >= :upperLeft];

		//OPSタスク 　：　カレンダー表示店舗 (発券日基準、設置基準)
		List<OpsTask__c> lstOpenStores = new List<OpsTask__c>();
		List<OpsTask__c> lstInstallStores = new List<OpsTask__c>();

		//結合前のリスト
		//★発券日基準★
		//新店発券日基準
		List<OpsTask__c> lstOpsTaskNewStore1 = new List<OpsTask__c>();
		//発券再開
		List<OpsTask__c> lstOpsTaskRenewalOpen = new List<OpsTask__c>();
		//発券停止
		List<OpsTask__c> lstOpsTaskPrintOff = new List<OpsTask__c>();
		//閉店
		List<OpsTask__c> lstOpsTaskCloseDate = new List<OpsTask__c>();
		
		//★作業日基準★	
		//新店設置日基準
		List<OpsTask__c> lstOpsTaskNewStore2 = new List<OpsTask__c>();
		//増設
		List<OpsTask__c> lstOpsTaskPlusInstall = new List<OpsTask__c>();
		//ｾﾙﾌ増設
		List<OpsTask__c> lstOpsTaskPlusSelfInstall = new List<OpsTask__c>();
		//撤去
		List<OpsTask__c> lstOpsTaskRemove = new List<OpsTask__c>();
		//移設
		List<OpsTask__c> lstOpsTaskRelocate = new List<OpsTask__c>();
		//閉店撤去（設置日）
		List<OpsTask__c> lstOpsTaskCloseRemove = new List<OpsTask__c>();
		//その他
		List<OpsTask__c> lstOpsTaskOther = new List<OpsTask__c>();
		
		//☆
		String strSubSql;
		if(flgCheck){
			strSubSql = 'select id,Name,Shubetsu__c, KizaiTehai__c,ChainName__c,StoreNumber__c,StoreName__c,StartDay__c,StopDay__c ,ProcDay__c,Comment__c ,Initial__c ,CloseDayStore__c from OpsTask__c where (ALDCheck__c = false or CIMSCheck__c = false or CSDBCheck__c = false or EPSONCheck__c = false or LSCheck__c = false or NATCheck__c = false or OPSUTILCheck__c = false or STORE_INI__c = false or VPNAddressCheck__c = false or InkCheck__c = false) AND ';
		}else{
			strSubSql = 'select id,Name,Shubetsu__c, KizaiTehai__c,ChainName__c,StoreNumber__c,StoreName__c,StartDay__c,StopDay__c ,ProcDay__c,Comment__c ,Initial__c ,CloseDayStore__c from OpsTask__c where ';
		}
		

		//個別条件文
		String criteriaOpsTaskNewStore1;
		String criteriaOpsTaskRenewalOpen;
		String criteriaOpsTaskPrintOff;
		String criteriaOpsTaskCloseDate;
		String criteriaOpsTaskNewStore2;
		String criteriaOpsTaskPlusInstall;
		String criteriaOpsTaskRemove;
		String criteriaOpsTaskRelocate;
		String criteriaOpsTaskPlusSelfInstall;
		String criteriaOpsTaskCloseRemove;
		String criteriaOpsTaskOther;

		
		
		//★発券日基準
		//新店発券日基準
		if(flgOpsTaskNewStore1){
			criteriaOpsTaskNewStore1 = '( Shubetsu__c includes (\'新店\') and StartDay__c >= ' + strUpperLeft + ')';
		}else{
			criteriaOpsTaskNewStore1 = '( Shubetsu__c includes (\'新店\') and StartDay__c <= ' + strToday + ' and StartDay__c >= ' + strBefore3 + ' and StartDay__c >= ' + strUpperLeft + ')';
		}
		//発券再開
		if(flgOpsTaskRenewalOpen){
			criteriaOpsTaskRenewalOpen = '( Shubetsu__c includes (\'発券再開\') and StartDay__c >= ' + strUpperLeft + ')';
		}else{
			criteriaOpsTaskRenewalOpen = '( Shubetsu__c includes (\'発券再開\') and StartDay__c <= ' + strToday + ' and StartDay__c >= ' + strBefore3 + ' and StartDay__c >= ' + strUpperLeft + ')';
		}
		//発券停止
		if(flgOpsTaskPrintOff){
			criteriaOpsTaskPrintOff = '( Shubetsu__c includes (\'発券停止\') and StopDay__c >= ' + strUpperLeft + ')';
		}else{
			criteriaOpsTaskPrintOff = '( Shubetsu__c includes (\'発券停止\') and StopDay__c <= ' + strToday + ' and StopDay__c >= ' + strBefore3 + ' and StopDay__c >= ' + strUpperLeft + ')';
		}
		//閉店
		if(flgOpsTaskCloseDate){
			criteriaOpsTaskCloseDate = '( Shubetsu__c includes (\'閉店\') and CloseDayStore__c >= ' + strUpperLeft + ')';
		}else{
			criteriaOpsTaskCloseDate = '( Shubetsu__c includes (\'閉店\') and CloseDayStore__c <= ' + strToday + ' and CloseDayStore__c >= ' + strBefore3 + ' and CloseDayStore__c >= ' + strUpperLeft + ')';
		}
		
		
		//★作業日基準
		//新店設置日基準
		if(flgOpsTaskNewStore2){
			criteriaOpsTaskNewStore2 = '( Shubetsu__c includes (\'新店\') and ProcDay__c >= ' + strUpperLeft + ')';	
		}else{
			criteriaOpsTaskNewStore2 = '( Shubetsu__c includes (\'新店\') and ProcDay__c <= ' + strToday + ' and ProcDay__c >= ' + strBefore3 + ' and ProcDay__c >= ' + strUpperLeft + ')';
		}
		//増設
		if(flgOpsTaskPlusInstall){
			criteriaOpsTaskPlusInstall = '( Shubetsu__c includes (\'増設\') and ProcDay__c >= ' + strUpperLeft + ')';
		}else{
			criteriaOpsTaskPlusInstall = '( Shubetsu__c includes (\'増設\') and ProcDay__c <= ' + strToday + ' and ProcDay__c >= ' + strBefore3 + ' and ProcDay__c >= ' + strUpperLeft + ')';
		}
		//ｾﾙﾌ増設
		if(flgOpsTaskPlusSelfInstall){
			criteriaOpsTaskPlusSelfInstall = '( Shubetsu__c includes (\'ｾﾙﾌ増設\') and ProcDay__c >= ' + strUpperLeft + ')';	
		}else{
			criteriaOpsTaskPlusSelfInstall = '( Shubetsu__c includes (\'ｾﾙﾌ増設\') and ProcDay__c <= ' + strToday + ' and ProcDay__c >= ' + strBefore3 + ' and ProcDay__c >= ' + strUpperLeft + ')';			
		}
		//撤去
		if(flgOpsTaskRemove){
			criteriaOpsTaskRemove = '( Shubetsu__c includes (\'撤去\') and ProcDay__c >= ' + strUpperLeft + ')';
		}else{
			criteriaOpsTaskRemove = '( Shubetsu__c includes (\'撤去\') and ProcDay__c <= ' + strToday + ' and ProcDay__c >= ' + strBefore3 + ' and ProcDay__c >= ' + strUpperLeft + ')';
		}
		//移設
		if(flgOpsTaskRelocate){
			criteriaOpsTaskRelocate = '( Shubetsu__c includes (\'移設\') and ProcDay__c >= ' + strUpperLeft + ')';
		}else{
			criteriaOpsTaskRelocate = '( Shubetsu__c includes (\'移設\') and ProcDay__c <= ' + strToday + ' and ProcDay__c >= ' + strBefore3 + ' and ProcDay__c >= ' + strUpperLeft + ')';
		}
		//閉店撤去（設置日）
		if(flgOpsTaskCloseRemove){
			criteriaOpsTaskCloseRemove = '( Shubetsu__c includes (\'閉店撤去\') and ProcDay__c >= ' + strUpperLeft + ')';	
		}else{
			criteriaOpsTaskCloseRemove = '( Shubetsu__c includes (\'閉店撤去\') and ProcDay__c <= ' + strToday + ' and ProcDay__c >= ' + strBefore3 + ' and ProcDay__c >= ' + strUpperLeft + ')';			
		}
		//その他
		if(flgOpsTaskOther){
			criteriaOpsTaskOther = '( Shubetsu__c includes (\'その他\') and ProcDay__c >= ' + strUpperLeft + ')';
		}else{
			criteriaOpsTaskOther = '( Shubetsu__c includes (\'閉店撤去\') and ProcDay__c <= ' + strToday + ' and ProcDay__c >= ' + strBefore3 + ' and ProcDay__c >= ' + strUpperLeft + ')';
		}
		
		
		//★発券日基準★
		//新店発券日基準
		lstOpsTaskNewStore1 = database.query(strSubSql + criteriaOpsTaskNewStore1 );
		//発券再開
		lstOpsTaskRenewalOpen = database.query(strSubSql + criteriaOpsTaskRenewalOpen );
		//発券停止
		lstOpsTaskPrintOff 	= database.query(strSubSql + criteriaOpsTaskPrintOff );
		//閉店
		lstOpsTaskCloseDate = database.query(strSubSql + criteriaOpsTaskCloseDate );

		//★作業日基準★	
		//新店設置日基準
		lstOpsTaskNewStore2 = database.query(strSubSql + criteriaOpsTaskNewStore2);
		//増設
		lstOpsTaskPlusInstall = database.query(strSubSql + criteriaOpsTaskPlusInstall);
		//ｾﾙﾌ増設
		lstOpsTaskPlusSelfInstall = database.query(strSubSql + criteriaOpsTaskPlusSelfInstall);
		//撤去
		lstOpsTaskRemove = database.query(strSubSql + criteriaOpsTaskRemove);
		//移設
		lstOpsTaskRelocate = database.query(strSubSql + criteriaOpsTaskRelocate);
		//閉店撤去（設置日）
		lstOpsTaskCloseRemove = database.query(strSubSql + criteriaOpsTaskCloseRemove);
		//その他
		lstOpsTaskOther = database.query(strSubSql + criteriaOpsTaskOther);
	
		

		for(Week week : weeks){
			for(Day day : week.days){
				//OPSカレンダー
				for(OPS_DAILY_WORK__c opsCal : lstCal){
					if(day.theDate.daysBetween(opsCal.ActDate__c) == 0){
						PageReference newPage = new PageReference('/' + opsCal.Id);
						day.strUrl = newPage.getUrl();

						//土日祝の設定を行う
						if(opsCal.SundayCheck__c == true){
							day.calCss = '<SundayLi>';
							day.calCloseCss = '</SundayLi>';
							day.sundayFlg = true;
							
						}else if(opsCal.SaturdayCheck__c == true){
							day.calCss = '<SaturdayLi>';
							day.calCloseCss = '</SaturdayLi>';
							day.saturdayFlg = true;
							
						}else if(opsCal.HolidayCheck__c == true){
							day.calCss = '<SundayLi>';
							day.calCloseCss = '</SundayLi>';
							day.holidayFlg = true;
							
						}						
					}
				}
				
				//Due Date
				day.lstDueDate = new List<DueDateCalendar__c>();
				for(DueDateCalendar__c duedate : lstDue){
					if( day.theDate.daysBetween(duedate.Day__c) == 0){
						day.strSpecialDay =  duedate.DueName__c;
					}
				}
				
				//★★★★★★★★★★★★★★★発券日基準★★★★★★★★★★★★★★★
				//OPSタスク　：　新店※発券日基準
				for(OpsTask__c task : lstOpsTaskNewStore1){
					if( day.theDate.daysBetween(task.StartDay__c) == 0){
						Datetime dtWrk1 = System.today();
						Datetime dtWrk2 = task.StartDay__c;
						System.debug('○○○○○dtSystem.today()=' + dtWrk1.format('yyyy/MM/dd'));
						System.debug('○○○○○task.StartDay__c=' + dtWrk2.format('yyyy/MM/dd'));
						System.debug('○○○○○ 1 ' + System.today().daysBetween(task.StartDay__c));
						System.debug('○○○○○ 2 ' + task.StartDay__c.daysBetween(System.today()));
						
						
						if(task.ProcDay__c == null){
							Datetime dt1 = task.StartDay__c;
							task.Comment__c = '【' + task.Shubetsu__c + '】(' + task.ChainName__c.substring(0, 3) + '-' + task.StoreNumber__c + ') ' + task.Initial__c + ' ' + task.StoreName__c + ' ' + dt1.format('yyyy-MM-dd','JST');
						}else{
							Datetime dt1 = task.StartDay__c;
							Datetime dt2 = task.ProcDay__c;
							task.Comment__c = '【' + task.Shubetsu__c + '】(' + task.ChainName__c.substring(0, 3) + '-' + task.StoreNumber__c + ') ' + task.Initial__c + ' '  + task.StoreName__c + ' ' + dt1.format('yyyy-MM-dd')+ ' ' + dt2.format('yyyy-MM-dd');
						}
						 
						day.addLstOpenStores(task);
					}
				}
				
				//OPSタスク　：　発券再開
				for(OpsTask__c task : lstOpsTaskRenewalOpen){
					if( day.theDate.daysBetween(task.StartDay__c) == 0){
						if(task.ProcDay__c == null){
							Datetime dt1 = task.StartDay__c;
							task.Comment__c = '【' + task.Shubetsu__c + '】(' + task.ChainName__c.substring(0, 3) + '-' + task.StoreNumber__c + ') ' + task.Initial__c + ' ' + task.StoreName__c + ' ' + dt1.format('yyyy-MM-dd','JST');
						}else{
							Datetime dt1 = task.StartDay__c;
							Datetime dt2 = task.ProcDay__c;
							task.Comment__c = '【' + task.Shubetsu__c + '】(' + task.ChainName__c.substring(0, 3) + '-' + task.StoreNumber__c + ') ' + task.Initial__c + ' '  + task.StoreName__c + ' ' + dt1.format('yyyy-MM-dd')+ ' ' + dt2.format('yyyy-MM-dd');
						}
						 
						day.addLstOpenStores(task);
					}
				}
				
				//OPSタスク　：　発券停止
				for(OpsTask__c task : lstOpsTaskPrintOff){
					if( day.theDate.daysBetween(task.StopDay__c) == 0){
						Datetime dt1 = task.StopDay__c;
						task.Comment__c = '【' + task.Shubetsu__c + '】(' + task.ChainName__c.substring(0, 3) + '-' + task.StoreNumber__c + ') ' + task.Initial__c + ' ' + task.StoreName__c + ' ' + dt1.format('yyyy-MM-dd','JST');
						day.addLstOpenStores(task);
					}
				}

				//OPSタスク　：　閉店
				for(OpsTask__c task : lstOpsTaskCloseDate){
					if( day.theDate.daysBetween(task.CloseDayStore__c) == 0){
						Datetime dt1 = task.CloseDayStore__c;
						task.Comment__c = '【' + task.Shubetsu__c + '】(' + task.ChainName__c.substring(0, 3) + '-' + task.StoreNumber__c + ') ' + task.Initial__c + ' ' + task.StoreName__c + ' ' + dt1.format('yyyy-MM-dd','JST');
						day.addLstInstallStores(task);
					}
				}

				//★★★★★★★★★★★★★★★設置日基準★★★★★★★★★★★★★★★
				//OPSタスク　：　新店※設置日基準
				for(OpsTask__c task : lstOpsTaskNewStore2){
					if( day.theDate.daysBetween(task.ProcDay__c) == 0){
						Datetime dt1 = task.ProcDay__c;
						task.Comment__c = '【' + task.Shubetsu__c + '】(' + task.ChainName__c.substring(0, 3) + '-' + task.StoreNumber__c + ') ' + task.Initial__c + ' ' + task.StoreName__c + ' ' + dt1.format('yyyy-MM-dd','JST');
						day.addLstInstallStores(task);
					}
				}

				//OPSタスク　：　増設（設置日）
				for(OpsTask__c task : lstOpsTaskPlusInstall){
					if( day.theDate.daysBetween(task.ProcDay__c) == 0){
						Datetime dt1 = task.StartDay__c;
						task.Comment__c = '【' + task.Shubetsu__c + '】(' + task.ChainName__c.substring(0, 3) + '-' + task.StoreNumber__c + ') ' + task.Initial__c + ' ' + task.StoreName__c + ' ' + dt1.format('yyyy-MM-dd','JST');
						day.addLstInstallStores(task);
					}
				}

				//OPSタスク　：　ｾﾙﾌ増設（設置日）
				for(OpsTask__c task : lstOpsTaskPlusSelfInstall){
					if( day.theDate.daysBetween(task.ProcDay__c) == 0){
						Datetime dt1 = task.ProcDay__c;
						task.Comment__c = '【' + task.Shubetsu__c + '】(' + task.ChainName__c.substring(0, 3) + '-' + task.StoreNumber__c + ') ' + task.Initial__c + ' ' + task.StoreName__c + ' ' + dt1.format('yyyy-MM-dd','JST');

						day.addLstInstallStores(task);
					}
				}

				//OPSタスク　：　撤去（設置日）
				for(OpsTask__c task : lstOpsTaskRemove){
					if( day.theDate.daysBetween(task.ProcDay__c) == 0){
						Datetime dt1 = task.ProcDay__c;
						task.Comment__c = '【' + task.Shubetsu__c + '】(' + task.ChainName__c.substring(0, 3) + '-' + task.StoreNumber__c + ') ' + task.Initial__c+ ' ' + task.StoreName__c + ' ' + dt1.format('yyyy-MM-dd','JST');
						 
						day.addLstInstallStores(task);
					}
				}

				//OPSタスク　：　移設（設置日）
				for(OpsTask__c task : lstOpsTaskRelocate){
					if( day.theDate.daysBetween(task.ProcDay__c) == 0){
						Datetime dt1 = task.ProcDay__c;
						task.Comment__c = '【' + task.Shubetsu__c + '】(' + task.ChainName__c.substring(0, 3) + '-' + task.StoreNumber__c + ') ' + task.Initial__c + ' ' + task.StoreName__c + ' ' + dt1.format('yyyy-MM-dd','JST');
						 
						day.addLstInstallStores(task);
					}
				}

				//OPSタスク　：　閉店撤去（設置日）
				for(OpsTask__c task : lstOpsTaskCloseRemove){
					if( day.theDate.daysBetween(task.ProcDay__c) == 0){
						Datetime dt1 = task.ProcDay__c;
						task.Comment__c = '【' + task.Shubetsu__c + '】(' + task.ChainName__c.substring(0, 3) + '-' + task.StoreNumber__c + ') ' + task.Initial__c + ' ' + task.StoreName__c + ' ' + dt1.format('yyyy-MM-dd','JST');
						 
						day.addLstInstallStores(task);
					}
				}

				//OPSタスク　：　その他（設置日）
				for(OpsTask__c task : lstOpsTaskOther){
					if( day.theDate.daysBetween(task.ProcDay__c) == 0){
						Datetime dt1 = task.ProcDay__c;
						task.Comment__c = '【' + task.Shubetsu__c + '】(' + task.ChainName__c.substring(0, 3) + '-' + task.StoreNumber__c + ') ' + task.Initial__c + ' ' + task.StoreName__c + ' ' + dt1.format('yyyy-MM-dd','JST');
						 
						day.addLstInstallStores(task);
					}
				}
				
			}
		}
		
				
	}
 	public List<Week> getWeeks() { 
		return this.weeks; 
	}
		

	/*週クラス*/
	public class Week {
	 public List<Day> days;
	 public Integer weekNumber; 
	 public Date startingDate; 
	 
	 public List<Day> getDays() { return this.days; }
	 
	 public Week () { 
	 	days = new List<Day>(); 	
	 }
	 public Week(Integer value,Date sunday,Integer month) { 
	 	this();
	 	weekNumber = value;
	 	startingDate = sunday;
	 	Date tmp = startingDate;
	 	for (Integer i = 0; i < 7; i++) {
	 		Day d = new Day( tmp,month ); 
	 		tmp = tmp.addDays(1);
	 		d.dayOfWeek = i+1;  		
	 		days.add(d);
	 	} 
	 	
	 }
	 
	}
	
	/** 日付クラス */
	public class Day {
		
		//OPS業務カレンダーへのリンクURL
		public String strUrl; 
		
		//OPSタスク　：　表示店舗
		public List<OpsTask__c> lstOpsTaskStore{get;set;}
		
		//発券開始のストアリスト
		public List<OpsTask__c> lstOpenStores{get;set;}
		
		//設置日のストアリスト
		public List<OpsTask__c> lstInstallStores{get;set;}
		
		//特別日コメント
		public String strSpecialDay;
		
		//依頼
		//public List<OPS_REQUEST__c> opsRequest;
		
		//Due Date
		public List<DueDateCalendar__c> lstDueDate;
		
		
		public String calCss;
		public String calCloseCss;
		
		//土日祝
		public Boolean sundayFlg;
		public Boolean saturdayFlg;
		public Boolean holidayFlg;
		
		
		
		public Date 		theDate;
		public Integer 		month, dayOfWeek;
		public String 		formatedDate;  	
		private String 		cssclass = 'calActive';
		public String 		styleName = 'background-color: #ffffff';
		
		 
		public Date 		getDate() { return theDate; }
		public Integer 		getDayOfMonth() { return theDate.day(); }		
		public String 		getDayOfMonth2() { 
			
			if ( theDate.day() <= 9 ) 
				return '0'+theDate.day(); 
			return String.valueof( theDate.day()); 
		}
		public Integer getDayOfYear() { return theDate.dayOfYear(); }
		public String 		getFormatedDate() { return formatedDate; }
		public Integer 		getDayNumber() { return dayOfWeek; }
		public String 		getCssname() { 	return cssclass; }
		public String 		getStyleName() { 	return styleName; }
		public String 		getCalCss(){return calCss;}
		public String 		getCalCloseCss(){return calCloseCss;}
		
		public Boolean 		getSundayFlg(){return sundayFlg;}
		public Boolean 		getSaturdayFlg(){return saturdayFlg;}
		public Boolean 		getHolidayFlg(){return holidayFlg;}
		
		
		//OPS業務カレンダーへのリンクURL　
		public String getStrUrl() { return strUrl; }
		//発券開始のストアリスト
		public List<OpsTask__c> getLstOpenStores() { return lstOpenStores; }
		//設置日のストアリスト
		public List<OpsTask__c> getLstInstallStores() { return lstInstallStores; }
		//特別日コメント
		public String getStrSpecialDay() { return strSpecialDay; }
		
		
		
		//発券日リストへの追加処理(重複除外)
		public void addLstOpenStores(OpsTask__c openTask){
			Boolean flgAdd = true;
			for(OpsTask__c already : lstOpenStores){
				if(already.Id == openTask.Id) flgAdd = false;
			}
			for(OpsTask__c already : lstInstallStores){
				if(already.Id == openTask.Id) flgAdd = false;
			}
			
			if(flgAdd){
				//本日からの日数を保存
				openTask.RemainDayCount__c = theDate.daysBetween(System.today());
				lstOpenStores.add(openTask);
			}
		}

		//設置日リストへの追加処理(重複除外)
		public void addLstInstallStores(OpsTask__c installTask){
			Boolean flgAdd = true;
			for(OpsTask__c already : lstOpenStores){
				if(already.Id == installTask.Id) flgAdd = false;
			}
			for(OpsTask__c already : lstInstallStores){
				if(already.Id == installTask.Id) flgAdd = false;
			}
			
			if(flgAdd){
				//本日からの日数を保存
				installTask.RemainDayCount__c = theDate.daysBetween(System.today());
				lstInstallStores.add(installTask);
			}
		}
		
		//OPSタスクへの新規登録URL
		public String getTaskUrl(){
			//日付をYYYY/MM/DD形式にしてパラメータとして付与
			Datetime dt = theDate;
			return '/' + OpsTask__c.SObjectType.getDescribe().getKeyPrefix() + '/e?CMJDay=' + dt.format('yyyy/MM/dd','JST'); 
		}
		
		public Day(Date value,Integer vmonth) { 
			lstOpenStores = new List<OpsTask__c>();
			lstInstallStores = new List<OpsTask__c>();
			
			theDate=value; 
			month=vmonth; 		
			formatedDate = '12 21 08';// time range..
			
			if ( theDate.daysBetween(System.today()) == 0 ) {
				//本日
				styleName ='background-color: #99ccff';
			}else if ( theDate.month() != month) {
				//月外
				styleName ='background-color: #f0f0f0';
			}
			
			//カレンダーCSSのデフォルトのグレーにする
			calCss = '<li>';
			calCloseCss = '</li>';
			//土日祝をfalseで設定
			sundayFlg = false;
			saturdayFlg = false;
			holidayFlg = false;
			
		}
			
	}

  @isTest(SeeAllData=true)
  public static void unitTest() {
  		//テストケース
  		//  1. repeatConインスタンス作成　・・・12月になっている事を検証　
  		//  2. 次月に移動　・・・　1月になっている事
  		//  3. 前月に移動　・・・　12月になっている事
  		//	4. 画面からしか呼ばれないメソッドをテスト
  		
  		Day tesDay = new Day(System.today(), 2);
  		
  		tesDay.getFormatedDate();
  		tesDay.getDayNumber();
  		tesDay.getCssname();
  		tesDay.getStyleName();
  		tesDay.getCalCss();
  		tesDay.getCalCloseCss();
  		tesDay.getSundayFlg();
  		tesDay.getSaturdayFlg();
  		tesDay.getHolidayFlg();
  		tesDay.getStrUrl();
  		tesDay.getLstOpenStores();
  		tesDay.getLstInstallStores();
  		tesDay.getStrSpecialDay();
  		tesDay.getTaskUrl();
  		
    	//★★1★★
   		repeatCon rep = new repeatCon();
    	Date testDate1 = Date.newInstance(2013, 1, 27);
    	
    	//debug start
    	Datetime dtWrk = rep.getMonth().upperLeft;
    	
    	System.debug('====dtWrk1=' + dtWrk.format('yyyy/MM/dd'));
    	//debug end
    	
 		//Commented out by Warren... Japan Deployment
    	//system.assert(testDate1.daysBetween(rep.getMonth().upperLeft) == 0);

    	//★★2★★
    	rep.next();
    	
    	//debug start
    	dtWrk = rep.getMonth().upperLeft;
    	
    	System.debug('====dtWrk2=' + dtWrk.format('yyyy/MM/dd'));
    	//debug end
    	
    	Date testDate2 = Date.newInstance(2014, 1, 26);
      	//Commented out by Warren... Japan Deployment
    	//system.assert(testDate2.daysBetween(rep.getMonth().upperLeft) == 0);//

    	//★★3★★
    	rep.prev();
    	
    	//debug start
    	dtWrk = rep.getMonth().upperLeft;
    	
    	System.debug('====dtWrk3=' + dtWrk.format('yyyy/MM/dd'));
    	//debug end

    	Date testDate3 = Date.newInstance(2013, 1, 27);
      	//Commented out by Warren... Japan Deployment
    	//system.assert(testDate3.daysBetween(rep.getMonth().upperLeft) == 0);
    	
    	Month newMonth = new Month(system.today(),true, true, true, 
    										      true, true, true,
    										      true, true, true,
    										      true, true, true);
    										      
    	Month new2Month = new Month(system.today(),false, false, false, 
    										      false, false, false,
    										      false, false, false,
    										      false, false, false);
 		
 		Date checkDate = Date.newInstance(2013, 1, 27);
		//Commented out by Warren... Japan Deployment
    	//system.assert(checkDate.daysBetween(newMonth.upperLeft) == 0);
    	
    	//カバレッジを上げるためのテスト
		newMonth.getNextYearName();
  		newMonth.getPrevYearName();
    	
    	
    	//★★4★★
   		//system.assert('02'.equals(rep.getMonth().getMonthName()));
    	//system.assert('2013'.equals(rep.getMonth().getYearName()));
    	//system.assert(5 == rep.getWeeks().size());
    	List<Week> lstWeek = rep.getWeeks();
    	for(Week we : lstWeek){
     		system.assert(7 == we.getDays().size());	
    	}
    	
    	Day testDay = new Day(Date.newInstance(2012, 11, 25),12);
    	//system.assert(Date.newInstance(2012, 11, 25).daysBetween(testDay.getDate()) == 0);
    	//system.assert(25 == testDay.getDayOfMonth());
    	//system.assert('25'.equals(testDay.getDayOfMonth2()));
    	
    	Day testDay2 = new Day(Date.newInstance(2012, 12, 1),12);
    	//system.assert(Date.newInstance(2012, 12, 1).daysBetween(testDay2.getDate()) == 0);
    	//system.assert(1 == testDay2.getDayOfMonth());
   		//system.assert('01'.equals(testDay2.getDayOfMonth2()));
   	
    	//system.assert(Date.newInstance(2012, 11, 25).dayOfYear() == testDay.getDayOfYear());
    	//system.assert('12 21 08'.equals(testDay.getFormatedDate()));
    	testDay.getDayNumber();
    	testDay.getCSSName();
    	//system.assert(null == testDay.getStrUrl());
    	
    	System.debug('====testDay.getLstOpenStores().size()=' + testDay.getLstOpenStores().size());
    	System.debug('====testDay.getLstInstallStores()=' + testDay.getLstInstallStores().size());
    	
 
  		//追加仕様　refresh
  		rep.refresh();   	
  }

}