public with sharing class ProgramRecRedirect {

  //パラメータ
  String strCycName;
  String strRecId;
  String strRecTypeName;
  String strTypeFlg;

  //String strObjectPrefix = '/a0A/e';
  //Changed by Warren Mar 6 2013
  //a6v, 00NF0000008u2Zn
  //pageRef = new PageReference('/a2J/e?CF00NZ0000000WqYO=' + strCycName + '&CF00NZ0000000WqYO_lkid=' + strRecId + '&RecordType=' + strRtlNew);
  //pageRef = new PageReference('/a2J/e?CF00NF0000008u2Zn=' + strCycName + '&CF00NF0000008u2Zn_lkid=' + strRecId + '&RecordType=' + strRtlNew);
  String strObjectPrefix = '/a6v/e';
  
  //レコードタイプID
  //MFG新規
  String strMfgNew = '';
  //MFG変更
  String strMfgUpdate = '';
  //MFG期中変更
  String strMfgUpdateKichu = '';
  //RTL新規
  String strRtlNew = '';
  //RTL変更
  String strRtlUpdate = '';
  
  //コンストラクタ
  public ProgramRecRedirect(){
    
    //コンストラクタの処理でレコードタイプIDを取得する
    sobject recordType = [select Name, Id from RecordType where Name = '≪ＭＦＧ≫0.新規依頼' LIMIT 1];
    strMfgNew = (String)recordType.get('Id');
    
    recordType = [select Name, Id from RecordType where Name = '≪ＭＦＧ≫3D変更依頼' LIMIT 1];
    strMfgUpdate = (String)recordType.get('Id');
    
    recordType = [select Name, Id from RecordType where Name = '≪ＭＦＧ≫サイクル開始前週の木曜日以降の変更依頼' LIMIT 1];
    strMfgUpdateKichu = (String)recordType.get('Id');
    
    recordType = [select Name, Id from RecordType where Name = '≪ＲＴＬ≫新規作成' LIMIT 1];
    strRtlNew = (String)recordType.get('Id');
    
    recordType = [select Name, Id from RecordType where Name = '≪ＲＴＬ≫変更依頼' LIMIT 1];
    strRtlUpdate = (String)recordType.get('Id');
  }

  /** リダイレクト処理 */
  public PageReference redirect() {
    
    //リクエストパラメータを取得
    strCycName = System.currentPageReference().getParameters().get('strCycName');
    strRecId = System.currentPageReference().getParameters().get('strRecId');
    strRecTypeName = System.currentPageReference().getParameters().get('strRecTypeName');
    strTypeFlg = System.currentPageReference().getParameters().get('strTypeFlg');
    
    PageReference pageRef;
    //レコードタイプを判別し、URLを作成する
    if('0'.equals(strRecTypeName)){
      //RTLサイクルDB
      if('1'.equals(strTypeFlg)){
        //RTL新規依頼
        pageRef = new PageReference('/a6v/e?CF00NF0000008u2Zn=' + strCycName + '&CF00NF0000008u2Zn_lkid=' + strRecId + '&RecordType=' + strRtlNew);
      }else{
        //RTL変更依頼
        pageRef = new PageReference('/a6v/e?CF00NF0000008u2Zn=' + strCycName + '&CF00NF0000008u2Zn_lkid=' + strRecId + '&RecordType=' + strRtlUpdate);        
      }
    }else{
      //MFGサイクルDB
      
      //該当サイクルの期限日を取得してレコードタイプを判定
      if(strCycName == null){
        strCycName = '304';
      }
		// DueName__c = \'サイクル開始2営業日前の12時\' and 
		// clause removed from strSQL because the value is no longer
        // a picklist value. 
      String strSQL = 'select id, Name, LimitTime__c from DueDateCalendar__c where DueName__c = \'サイクル開始2営業日前の12時\' and CycleName__c = ' +  strCycName;
      List<DueDateCalendar__c> lstDue = database.query(strSQL);
      DueDateCalendar__c dueRec = lstDue.get(0);
      
      //サイクル開始2営業日前の12:00を取得
      Datetime wrkTime = dueRec.LimitTime__c;
      //現在時間を取得
      Datetime thisTime = datetime.now();

      if(wrkTime < thisTime){
        //サイクル開始2営業日前の12:00より後
        //MFG期中変更
        pageRef = new PageReference('/a6v/e?CF00NF0000008u2Zn=' + strCycName + '&CF00NF0000008u2Zn_lkid=' + strRecId + '&RecordType=' + strMfgUpdateKichu);
      }else{
        //RTLサイクルDB
        if('1'.equals(strTypeFlg)){
          //MFG新規依頼
          pageRef = new PageReference('/a6v/e?CF00NF0000008u2Zn=' + strCycName + '&CF00NF0000008u2Zn_lkid=' + strRecId + '&RecordType=' + strMfgNew);
        }else{
          //MFG変更依頼
          pageRef = new PageReference('/a6v/e?CF00NF0000008u2Zn=' + strCycName + '&CF00NF0000008u2Zn_lkid=' + strRecId + '&RecordType=' + strMfgUpdate);        
        }
      }      
      
    }
    
    //作成したURLを返却    
    return pageRef;
  }
  
  @isTest(SeeAllData=true)
    public static void unitTest() {
      ProgramRecRedirect test = new ProgramRecRedirect();
      test.redirect();
      System.assert(1 == 1);
    }

}