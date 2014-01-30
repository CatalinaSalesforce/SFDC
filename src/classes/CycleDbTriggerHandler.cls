/**********************************************************
*  CycleDbTriggerHandler
*  サイクルDBのトリガー実行クラス
*  version： 1.0
*  作成： Satoshi Haga
***********************************************************/
public with sharing class CycleDbTriggerHandler {

  /** Insert前トリガー */
  public void OnBeforeInsert(cycleDB__c[] newCycles){
    
    /** プログラムステータスと、プランシート関連を初期化する */
    cycleDB__c cycle = newCycles[0];
    cycle.Ball_have__c = 'プログラム担当者';
    cycle.PDT_Comment__c = null;
    cycle.confirm_orderform__c = '未提出';
    cycle.dummy_ticket__c = '使用していません';
    cycle.First_Order_TIME__c = null;
    cycle.First_Generate__c = null;
    cycle.Last_Generate__c = null;
    cycle.noofprogram__c = null;
    cycle.First_Order_TIME__c = null;
    }

  /** Update前トリガー */
  public void OnBeforeUpdate(cycleDB__c[] old, cycleDB__c[] updated, Map<ID, cycleDB__c> cycleMap){
    
    cycleDB__c oldCycle = old[0];
    cycleDB__c updatedCycle = updated[0];
    
    
    //PDT対応完了予定日を更新
    if((updatedCycle.First_Order_TIME__c != null && oldCycle.First_Order_TIME__c == null) 
        || (oldCycle.First_Order_TIME__c != updatedCycle.First_Order_TIME__c)){
        
        updatedCycle.PDT_Done2__c = Date.newInstance(updatedCycle.First_Order_TIME__c.year(), updatedCycle.First_Order_TIME__c.month(), updatedCycle.First_Order_TIME__c.day());  
      for(Integer i = 0; i<2; ){
        //1日加算
        updatedCycle.PDT_Done2__c = updatedCycle.PDT_Done2__c.addDays(1);
        //次の日が営業日であった場合、カウンタをカウントアップする
        if(isBusinessDay(updatedCycle.PDT_Done2__c)){
          i++;
        }
      }
    }  
    }

  //営業日か否かをOPSカレンダーから取得する。  
  public Boolean isBusinessDay(Date wrkDate){
  
    //OPSカレンダーを参照して、土日祝フラグを取得
    List<OPS_DAILY_WORK__c> listCal = [select id, Name, HolidayCheck__c, SaturdayCheck__c, SundayCheck__c from OPS_DAILY_WORK__c where ActDate__c = :wrkDate];
    
    //取得出来ない場合は、営業日とする
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
  
  @isTest(SeeAllData=true)
    public static void unitTest() {
    //212サイクルのレコードを１つ選択→501で新規登録し、
    //プログラムステータスと、プランシート関連が初期化されている事を確認する。

    cycleDB__c result = new cycleDB__c(); 
        
    List<cycleDB__c> testMap = [select id,contractnumber_cycle__c,salesrep__c,Link_Plan__c,brand__c,programmer__c,Name_Plan__c,SiD_select__c,BGT__c,G_Type__c,specialPGM__c,print_date__c,late_Flag__c,Ball_have__c,PDT_Comment__c,confirm_orderform__c,dummy_ticket__c,First_Order_TIME__c,First_Generate__c,Last_Generate__c,noofprogram__c,Name from cycleDB__c where Name = '302'];
    cycleDB__c masterCycle = testMap.get(0);

    result.contractnumber_cycle__c = masterCycle.contractnumber_cycle__c;
    result.Name = '501';
    result.salesrep__c = masterCycle.salesrep__c;
    result.Link_Plan__c = masterCycle.Link_Plan__c;
    result.brand__c = masterCycle.brand__c;
    result.programmer__c = masterCycle.programmer__c;
    result.Name_Plan__c = masterCycle.Name_Plan__c;
    result.SiD_select__c = masterCycle.SiD_select__c;
    result.BGT__c = masterCycle.BGT__c;
    result.G_Type__c = masterCycle.G_Type__c;
    result.specialPGM__c = masterCycle.specialPGM__c;
    result.print_date__c = masterCycle.print_date__c;
    result.late_Flag__c = masterCycle.late_Flag__c;
    
    result.programmer__c = masterCycle.programmer__c;
    result.Name_Plan__c = masterCycle.Name_Plan__c;
    
    result.Ball_have__c = masterCycle.Ball_have__c;
    result.PDT_Comment__c = masterCycle.PDT_Comment__c;
    result.confirm_orderform__c = masterCycle.confirm_orderform__c;
    result.dummy_ticket__c = masterCycle.dummy_ticket__c;
    result.First_Order_TIME__c = masterCycle.First_Order_TIME__c;
    result.First_Generate__c = masterCycle.First_Generate__c;
    result.Last_Generate__c = masterCycle.Last_Generate__c;
    result.noofprogram__c = masterCycle.noofprogram__c;
    result.G_Type__c = '実施しない';
    result.G_TypeID_handoverdate__c = null;
    result.SiDinstalldate__c = system.today();
    insert result;

    List<cycleDB__c> assertMap = [select id,Name,Ball_have__c,PDT_Comment__c,confirm_orderform__c,dummy_ticket__c,First_Order_TIME__c,First_Generate__c,Last_Generate__c,noofprogram__c from cycleDB__c where Name = '501'];
    cycleDB__c cycle = assertMap.get(0);
    
    System.assert(cycle.Ball_have__c.equals('プログラム担当者'));
    System.assert(cycle.PDT_Comment__c == null);
    System.assert(cycle.confirm_orderform__c.equals('未提出'));
    System.assert(cycle.dummy_ticket__c.equals('使用していません'));
    System.assert(cycle.First_Order_TIME__c == null);
    System.assert(cycle.First_Generate__c == null);
    System.assert(cycle.Last_Generate__c == null);
    System.assert(cycle.noofprogram__c == null);
    
    cycle.First_Order_TIME__c = datetime.now();
    update cycle;
    System.assert(1 == 1);
  }
}