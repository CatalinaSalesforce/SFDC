public class PDTMonth {

    //設定日、コンストラクタで設定する
    public Day thisDay;

    //日次カレンダー用のリスト
    public List<program_req__c> allProgList = new List<program_req__c>();

    private List<Week> weeks;
    public Date firstDate;
    public Date endDate;
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
    public PDTMonth( Date value ,Boolean flgTomorrow,Boolean flgComplete,Boolean flgMyComment,Boolean flgCalendarView) {
        weeks = new List<Week>();
        firstDate = value.toStartOfMonth();
        endDate = value.addMonths(1).addDays(-1);
        upperLeft = firstDate.toStartOfWeek();
        Date tmp = upperLeft;

        //2013.02.05 S.HAGA START
        //以前の月の未処理も対象
        upperLeft = Date.newInstance(2013,01,25);
        //2013.02.05 S.HAGA END

        //2013.02.05 S.HAGA START
        //以前の月の未処理も対象
        Date fromDate = Date.newInstance(2013,01,25);
        //2013.02.05 S.HAGA END


        for (Integer i = 0; i < 6; i++) {
            Week w = new Week(i+1,tmp,value.month());
            this.weeks.add( w );
            tmp = tmp.addDays(7);
        }

        //OPSカレンダー
        List<OPS_DAILY_WORK__c> lstCal = [select id,Name,ActDate__c,SpecialDay__c, holiday__c ,SundayCheck__c , SaturdayCheck__c , HolidayCheck__c from OPS_DAILY_WORK__c where ActDate__c >= :upperLeft];


        //PDT依頼（未受理、明日以降、「△△までに」）
        List<program_req__c> lstPdt1 = new List<program_req__c>();
        lstPdt1 = [select brand__c,req_app__c,PDTName__c,CycleDBRecordTypeName__c, recordTypeName__c, PDT_Done2__c, WCheck1LastUpdateDate__c, programmer_PGM__c,id,Name,DB_Sent__c,DB_Sent_Rule__c, Prefix_Cycle__c ,manufacture__c , PDTLastName__c ,ReOrder1_del__c ,WCheck1__c, LastModifiedPerson__c, WCheck2__c, GeneFlag__c from program_req__c where CreatedDate > :fromDate and WCheck2__c = false and ((DB_Sent_Rule__c = '△△日 までに送信' and DB_Sent__c > today) or (CycleDBRecordTypeName__c = '≪ＲＴＬ≫新規作成' and PDT_Done2__c > today))];

        //PDT依頼（未受理、当日以前、upperleft以降、 「△△までに」）
        List<program_req__c> lstPdt2 = new List<program_req__c>();
        lstPdt2 = [select brand__c,req_app__c,PDTName__c,CycleDBRecordTypeName__c, recordTypeName__c, PDT_Done2__c, WCheck1LastUpdateDate__c, programmer_PGM__c,id,Name,DB_Sent__c,DB_Sent_Rule__c, Prefix_Cycle__c ,manufacture__c , PDTLastName__c ,ReOrder1_del__c ,WCheck1__c, LastModifiedPerson__c, WCheck2__c, GeneFlag__c from program_req__c where CreatedDate > :fromDate and WCheck2__c = false and ((DB_Sent_Rule__c = '△△日 までに送信' and DB_Sent__c <= today and DB_Sent__c > :upperLeft) or (CycleDBRecordTypeName__c = '≪ＲＴＬ≫新規作成' and PDT_Done2__c <= today and PDT_Done2__c > :upperLeft)) ];

        //PDT依頼（未受理、当日以前、upperleft以降の 「絶対△△日に」）
        List<program_req__c> lstPdt3 = new List<program_req__c>();
        lstPdt3 = [select brand__c,req_app__c,PDTName__c,CycleDBRecordTypeName__c, recordTypeName__c, PDT_Done2__c, WCheck1LastUpdateDate__c, programmer_PGM__c,id,Name,DB_Sent__c,DB_Sent_Rule__c, Prefix_Cycle__c ,manufacture__c , PDTLastName__c ,ReOrder1_del__c ,WCheck1__c, LastModifiedPerson__c, WCheck2__c, GeneFlag__c from program_req__c where CreatedDate > :fromDate and WCheck2__c = false and DB_Sent_Rule__c In ('絶対 本日に送信','絶対 △△日に送信')  and DB_Sent__c <= today and DB_Sent__c > :upperLeft ];

        //PDT依頼（受理済の、upperLeft以降）
        List<program_req__c> lstPdt4 = new List<program_req__c>();
        if(flgComplete || !flgCalendarView){
            lstPdt4 = [select brand__c,req_app__c,PDTName__c,CycleDBRecordTypeName__c, recordTypeName__c, PDT_Done2__c, WCheck1LastUpdateDate__c, programmer_PGM__c,id,Name,DB_Sent__c,DB_Sent_Rule__c, Prefix_Cycle__c ,manufacture__c , PDTLastName__c ,ReOrder1_del__c ,WCheck1__c, LastModifiedPerson__c, WCheck2__c, GeneFlag__c from program_req__c where CreatedDate > :fromDate and (WCheck2__c = true) and ((DB_Sent_Rule__c In ('絶対 本日に送信','絶対 △△日に送信','△△日 までに送信')  and DB_Sent__c > :upperLeft ) or (CycleDBRecordTypeName__c = '≪ＲＴＬ≫新規作成' and PDT_Done2__c > :upperLeft))];
        }

        //PDT依頼（未受理、明日以降の「絶対△△日に」）
        List<program_req__c> lstPdt5 = new List<program_req__c>();
        if(flgTomorrow || !flgCalendarView){
            lstPdt5 = [select brand__c,req_app__c,PDTName__c,CycleDBRecordTypeName__c, recordTypeName__c, PDT_Done2__c, WCheck1LastUpdateDate__c, programmer_PGM__c,id,Name,DB_Sent__c,DB_Sent_Rule__c, Prefix_Cycle__c ,manufacture__c , PDTLastName__c ,ReOrder1_del__c ,WCheck1__c, LastModifiedPerson__c, WCheck2__c, GeneFlag__c from program_req__c where CreatedDate > :fromDate and WCheck2__c = false and DB_Sent_Rule__c In ('絶対 本日に送信','絶対 △△日に送信') and DB_Sent__c > today];
        }


        //コメント(個人)
        List<WorkComment__c> lstMyComment = new List<WorkComment__c>();
        if(flgMyComment){
            lstMyComment = [select id,Name,Title__c,Share__c, Day__c from WorkComment__c where  Day__c >= :upperLeft ];
        }


        //Due Date
        List<DueDateCalendar__c> lstDue = [select id,Name,Day__c,RGB__c,CycleName__c,DueName__c,ALLMTG__c from DueDateCalendar__c where Day__c >= :upperLeft];

        //2013.02.04 RTL新規マージ対応 Start
        //RTL新規の場合、PDT対応完了予定日でDB送信希望日を上書きする
        for(program_req__c pdt : lstPdt1){
            if('≪ＲＴＬ≫新規作成'.equals(pdt.CycleDBRecordTypeName__c)){
                pdt.DB_Sent__c = pdt.PDT_Done2__c;
            }
        }
        for(program_req__c pdt : lstPdt2){
            if('≪ＲＴＬ≫新規作成'.equals(pdt.CycleDBRecordTypeName__c)){
                pdt.DB_Sent__c = pdt.PDT_Done2__c;
            }
        }
        for(program_req__c pdt : lstPdt4){
            if('≪ＲＴＬ≫新規作成'.equals(pdt.CycleDBRecordTypeName__c)){
                pdt.DB_Sent__c = pdt.PDT_Done2__c;
            }
        }
        //2013.02.04 RTL新規マージ対応 End


        for(Week week : weeks){
            for(Day day : week.days){

                //コンストラクタで設定した日付に適したdayをthisDayに設定
                if(day.theDate.daysBetween(value) == 0){
                    thisDay = day;
                }

                //日次カレンダーへ
                PageReference dailyPage = new PageReference('/apex/PDTCalendarPage');
                day.strUrl = dailyPage.getUrl();

                Datetime wrkDatetime = day.theDate;
                day.strUrl = '/apex/PDTCalendarPageDayViewpage' + '?CMJYear=' + getYearName() + '&CMJMonth=' + getMonthName() + '&MonthView=false&ViewDay=' + wrkDatetime.format('yyyyMMdd');

                //OPSカレンダー
                for(OPS_DAILY_WORK__c opsCal : lstCal){
                    if(day.theDate.daysBetween(opsCal.ActDate__c) == 0){
                        PageReference newPage = new PageReference('/' + opsCal.Id);

                        //土日祝の設定を行う
                        if(opsCal.SundayCheck__c == true){
                            day.sundayFlg = true;

                        }else if(opsCal.SaturdayCheck__c == true){
                            day.saturdayFlg = true;

                        }else if(opsCal.HolidayCheck__c == true){
                            day.holidayFlg = true;
                        }
                    }
                }

                //PDT依頼ループ（未受理、当日以前、upperleft以降の 「絶対△△日に」）
                for(program_req__c pdt : lstPdt3){
                    if(day.theDate.daysBetween(Date.today()) == 0 && Date.today().daysBetween(pdt.DB_Sent__c) <= 0 ){
                        Datetime dt;
                        dt = pdt.DB_Sent__c;
                        if(flgCalendarView == true){
                            if(day.lstAllPdtByDay.size()<5){
                                pdt.ReOrder1_del__c = '【絶対' + dt.format('yyyy/MM/dd','JST') + 'に】' + pdt.Prefix_Cycle__c + '(' + pdt.manufacture__c + + ')'+ pdt.PDTLastName__c + 'さん';
                                day.lstPdt3.add(pdt);
                                day.lstAllPdtByDay.add(pdt);
                            }
                            //件数をカウントアップ
                            day.lstAllPdtByDayForCount.add(pdt);

                        }else if (day.theDate.daysBetween(value) == 0){
                            pdt.ReOrder1_del__c = '【絶対' + dt.format('yyyy/MM/dd','JST') + 'に】';
                            allProgList.add(pdt);
                        }

                    }
                }

                //PDT依頼ループ（未受理、当日以前、upperleft以降、 「△△までに」）
                for(program_req__c pdt : lstPdt2){
                    if(day.theDate.daysBetween(Date.today()) == 0 && Date.today().daysBetween(pdt.DB_Sent__c) <= 0 ){
                        Datetime dt;
                        dt = pdt.DB_Sent__c;
                        if(flgCalendarView == true){
                            if(day.lstAllPdtByDay.size()<5){
                                pdt.ReOrder1_del__c = '【' + dt.format('yyyy/MM/dd','JST') + 'までに】' + pdt.Prefix_Cycle__c + '(' + pdt.manufacture__c + + ')'+ pdt.PDTLastName__c + 'さん';
                                day.lstPdt2.add(pdt);
                                day.lstAllPdtByDay.add(pdt);
                            }
                            //件数をカウントアップ
                            day.lstAllPdtByDayForCount.add(pdt);
                        }else if (day.theDate.daysBetween(value) == 0){
                            pdt.ReOrder1_del__c = '【' + dt.format('yyyy/MM/dd','JST') + 'までに】';
                            allProgList.add(pdt);
                        }

                    }
                }

                //PDT依頼（未受理、明日以降の「絶対△△日に」）
                for(program_req__c pdt : lstPdt5){
                    if(day.theDate.daysBetween(pdt.DB_Sent__c) == 0){
                        Datetime dt;
                        dt = pdt.DB_Sent__c;
                        if(flgCalendarView == true){
                            if(day.lstAllPdtByDay.size()<5){
                                pdt.ReOrder1_del__c = '【絶対' + dt.format('yyyy/MM/dd','JST') + 'に】' + pdt.Prefix_Cycle__c + '(' + pdt.manufacture__c + + ') '+ pdt.PDTLastName__c + 'さん';
                                day.lstPdt5.add(pdt);
                                day.lstAllPdtByDay.add(pdt);
                            }
                            //件数をカウントアップ
                            day.lstAllPdtByDayForCount.add(pdt);

                        }else if (day.theDate.daysBetween(value) == 0){
                            pdt.ReOrder1_del__c = '【絶対'+ dt.format('yyyy/MM/dd','JST') + 'に】';
                            allProgList.add(pdt);
                        }

                    }
                }

                //PDT依頼ループ（未受理、明日以降、「△△までに」）
                for(program_req__c pdt : lstPdt1){
                    if(day.theDate.daysBetween(Date.today()) == 0 && Date.today().daysBetween(pdt.DB_Sent__c) > 0 ){
                        Datetime dt;
                        dt = pdt.DB_Sent__c;
                        if(flgCalendarView == true){
                            if(day.lstAllPdtByDay.size()<5){
                                pdt.ReOrder1_del__c = '【' + dt.format('yyyy/MM/dd','JST') + 'までに】' + pdt.Prefix_Cycle__c + '(' + pdt.manufacture__c + + ')'+ pdt.PDTLastName__c + 'さん';
                                day.lstPdt1.add(pdt);
                                day.lstAllPdtByDay.add(pdt);
                            }
                            //件数をカウントアップ
                            day.lstAllPdtByDayForCount.add(pdt);
                        }else if (day.theDate.daysBetween(value) == 0){
                            pdt.ReOrder1_del__c = '【' + dt.format('yyyy/MM/dd','JST') + 'までに】';
                            allProgList.add(pdt);
                        }

                    }
                }

                //PDT依頼ループ（受理済の、upperLeft以降）
                for(program_req__c pdt : lstPdt4){
                    if(pdt.WCheck1LastUpdateDate__c != null && day.theDate.daysBetween(pdt.WCheck1LastUpdateDate__c) == 0){
                        if(flgCalendarView == true){
                            if(day.lstAllPdtByDay.size()<5){
                                pdt.ReOrder1_del__c = '【対応済】' + pdt.Prefix_Cycle__c + '(' + pdt.manufacture__c + + ') ' + pdt.PDTLastName__c + 'さん';
                                day.lstPdt4.add(pdt);
                                day.lstAllPdtByDay.add(pdt);
                            }
                            //件数をカウントアップ
                            day.lstAllPdtByDayForCount.add(pdt);

                        }else if (day.theDate.daysBetween(value) == 0){
                            pdt.ReOrder1_del__c = '【対応済】';
                            allProgList.add(pdt);
                        }

                    }
                }

                //個人コメント
                for(WorkComment__c comment : lstMyComment){
                    if(day.theDate.daysBetween(comment.Day__c) == 0){
                        day.lstMyComment.add(comment);
                    }
                }

                //Due Date
                for(DueDateCalendar__c due : lstDue){
                    if(day.theDate.daysBetween(due.Day__c) == 0){

                        if(due.ALLMTG__c == false){
                            due.DueName__c = '【Due】【' + String.valueOf(due.CycleName__c) + '】' + due.DueName__c ;
                        }else{
                            due.DueName__c = '【全社MTG】' + due.DueName__c ;
                        }

                        day.lstDue.add(due);
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

        //日次画面へのURL
        public String strUrl{set;get;}

        public String calCss{set;get;}
        public String calCloseCss{set;get;}

        //土日祝
        public Boolean sundayFlg{set;get;}
        public Boolean saturdayFlg{set;get;}
        public Boolean holidayFlg{set;get;}

        public Date         theDate{set;get;}
        public Integer      month{set;get;}
        public Integer      dayOfWeek{set;get;}
        public String       formatedDate{set;get;}

        private String      cssclass = 'calActive';
        public String       styleName = 'background-color: #ffffff';


        public Date         getDate() { return theDate; }
        public Integer      getDayOfMonth() { return theDate.day(); }
        public String       getDayOfMonth2() {

            if ( theDate.day() <= 9 )
                return '0'+theDate.day();
            return String.valueof( theDate.day());
        }
        public Integer getDayOfYear() { return theDate.dayOfYear(); }
        public Integer      getDayNumber() { return dayOfWeek; }
        public String       getCssname() {  return cssclass; }

        //表示するPDTリスト
        //PDT依頼（未受理、明日以降、「△△までに」）                   ※黄　#ffff66
        public List<program_req__c> lstPdt1{set;get;}
        //PDT依頼（未受理、当日以前、upperleft以降、 「△△までに」）      ※赤　#EF75BC
        public List<program_req__c> lstPdt2{set;get;}
        //PDT依頼（未受理、当日以前、upperleft以降の 「絶対△△日に」） ※赤　#EF75BC
        public List<program_req__c> lstPdt3{set;get;}
        //PDT依頼（受理済の、upperLeft以降）                           ※灰　#B2B2B2
        public List<program_req__c> lstPdt4{set;get;}
        //PDT依頼（未受理、明日以降の「絶対△△日に」）                  ※赤　#EF75BC
        public List<program_req__c> lstPdt5{set;get;}

        //件数チェック用、当該日のPDT依頼一覧
        public List<program_req__c> lstAllPdtByDay{set;get;}

        //件数チェック用、当該日のPDT依頼一覧
        public List<program_req__c> lstAllPdtByDayForCount{set;get;}



        //PDT依頼リスト
        //コメント
        public List<WorkComment__c> lstMyComment{set;get;}

        //DueDateカレンダー
        public List<DueDateCalendar__c> lstDue{set;get;}

        //コメントへの新規登録URL
        public String getCommentUrl(){
            return '/' + WorkComment__c.SObjectType.getDescribe().getKeyPrefix() + '/e';
        }

        public Day(Date value,Integer vmonth) {
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

            //土日祝をfalseで設定
            sundayFlg = false;
            saturdayFlg = false;
            holidayFlg = false;

            //PDTリストを初期化
            lstPdt1 = new List<program_req__c>();
            lstPdt2 = new List<program_req__c>();
            lstPdt3 = new List<program_req__c>();
            lstPdt4 = new List<program_req__c>();
            lstPdt5 = new List<program_req__c>();
            lstAllPdtByDay = new List<program_req__c>();
            lstAllPdtByDayForCount = new List<program_req__c>();


            //コメントを初期化
            lstMyComment = new List<WorkComment__c>();

            //Dueを初期化
            lstDue = new List<DueDateCalendar__c>();

        }

    }

    @isTest(SeeAllData=true)
    public static void unitTest2() {

    //日次表記、対象プログラムが6件以上の日
    Date testDate = Date.newInstance(2013, 2, 15);
    PDTMonth month = new PDTMonth(testDate,true,true,true,true);
    Day day = new Day(testDate, 1);
    system.assert(day.theDate.daysBetween(month.thisDay.theDate) == 0);

    //画面から実行されるメソッドをダミー実行
    month.getNextYearName();
    month.getPrevYearName();
    Integer intDays = month.getWeeks().get(1).getDays().size();
    system.assert(intDays == 7);

    month.getValidDateRange();

    system.assert(month.getWeeks().get(1).getDays().get(1).getDate() != null);
    system.assert(month.getWeeks().get(1).getDays().get(1).getDayOfMonth()  != null);
    system.assert(month.getWeeks().get(1).getDays().get(1).getDayOfMonth2()  != null);
    system.assert(month.getWeeks().get(1).getDays().get(1).getDayOfYear()  != null);
    system.assert(month.getWeeks().get(1).getDays().get(1).getDayNumber()  != null);

  }

}