/**********************************************************
*  WireringIssueTriggerHandler
*  ワイヤリング障害管理のトリガー実行クラス
*  version： 1.0
*  作成： Satoshi Haga
*  Modified line 106 - JBettio 5/2/2013
***********************************************************/
public class WireringIssueTriggerHandler {

  /** 更新前トリガー */
    public void OnBeforeUpdate(WireringIssueManagement__c[] old, WireringIssueManagement__c[] updated, Map<ID, WireringIssueManagement__c> wireringMap){

    /** メールがチェックされていた場合はメール回数をカウントアップする */
    WireringIssueManagement__c oldRec = old[0];
    WireringIssueManagement__c newRec = updated[0];

	//2013.08.06 S.Haga  Add try-catch statement start

	//Validatin Check
	if(newRec.ChainName__c == null){
		newRec.addError('チェーンを選択して下さい');
		return ;
	}

	try{
	//2013.08.06 S.Haga  Add try-catch statement end

	    /**入力規則により、通常メールと進捗確認メールが同時にチェックされることは無い*/
	    if((oldRec.Mail__c == false && newRec.Mail__c == true)
	       || (oldRec.MailShintyoku__c == false && newRec.MailShintyoku__c == true) ){

	      newRec.MailCount__c++;
	    }

	    /** 名称を運用で規定する */
	    newRec.Name = '【' + String.valueOf(newRec.IssueDate__c) + '】　【' + newRec.ChainName__c.substring(6, newRec.ChainName__c.length()) + ' '+ newRec.StoreName__c + '】' ;


    //2013.08.06 S.Haga  Add try-catch statement start
    }catch(System.NullPointerException nullException){
		//This is when runtime-exception is occured.
		newRec.addError('チェーンを選択して下さい。\n' + nullException.getMessage());
	}catch(Exception e){
		newRec.addError('エラーが発生しました。管理者に問い合わせてください。\n' + e.getMessage());
	}
    //2013.08.06 S.Haga  Add try-catch statement end

    }

  /** 更新後トリガー */
    public void OnAfterUpdate(WireringIssueManagement__c[] old, WireringIssueManagement__c[] updated, Map<ID, WireringIssueManagement__c> wireringMap){

    //メール配信
    WireringIssueManagement__c oldRec = old[0];
    WireringIssueManagement__c newRec = updated[0];

	//2013.08.06 S.Haga  Add try-catch statement start
	try{
	//2013.08.06 S.Haga  Add try-catch statement end

    //通常のメール配信
    if(oldRec.Mail__c == false && newRec.Mail__c == true){
      sendMail(newRec,false);
    }

    //進捗確認メール配信
    if(oldRec.MailShintyoku__c == false && newRec.MailShintyoku__c == true){
      sendMail(newRec,true);
    }

    //2013.08.06 S.Haga  Add try-catch statement start
    }catch(Exception e){
		//This is when runtime-exception is occured.
		newRec.addError('エラーが発生致しました。管理者に問合せて下さい。\n' + e.getMessage());
	}
    //2013.08.06 S.Haga  Add try-catch statement end

    }

    /** メール送信メソッド */
    public void sendMail(WireringIssueManagement__c issueRec, Boolean retryFlg){
      //★★★メール本文★★★
      //メール宛名を取得
      String strMessage = '';
      if(issueRec.AtenaMailOverlay__c == null){
        strMessage =  issueRec.AtenaMail__c + '\n\n';
      }else{
        strMessage =  issueRec.AtenaMailOverlay__c + '\n\n';
      }

      strMessage = strMessage + 'カタリナマーケティングの' + Userinfo.getLastName() + ' です。\n\n';
      if(retryFlg){
        strMessage += '以前にご連絡させて頂いておりますレジクーポンプリンターのLAN環境不具合ですが、依然続いております。\n\n';
      }else{
        strMessage += '下記店舗にてレジクーポンプリンターのLAN環境不具合が確認しました。\n\n';
      }
      strMessage += '恐れ入りますが、修繕対応をご調整戴けますようよろしくお願い致します。\n\n';
      strMessage += '詳細は下記の通りです。\n\n';

      strMessage +=  '■緊急性　：　高い\n';
      strMessage =  strMessage + '■店番　：　' + issueRec.StoreNumber__c + '\n';
      strMessage =  strMessage + '■店舗名　：　' + issueRec.StoreName__c + '\n';
      strMessage +=  CommonUtil.printlnConcat('■店舗窓口　：　', issueRec.StoreMadoguchi__c);
      strMessage +=  CommonUtil.printlnConcat('■店舗窓口直通　：　', issueRec.StoreMadoguchiTel__c);
      strMessage +=  CommonUtil.printlnConcat('■修理費用負担承認　：　', issueRec.RepairApprove__c);

      //2013.08.06 S.Haga  Remoce title from client name  start
      //strMessage +=  CommonUtil.printlnConcatDear('■修理費用承認担当者　：　', issueRec.RepairInCharge__c);
      //strMessage +=  CommonUtil.printlnConcatDear('■修理費用承認者連絡先　：　', issueRec.RepairTel__c);
      strMessage +=  CommonUtil.printlnConcat('■修理費用承認担当者　：　', issueRec.RepairInCharge__c);
      strMessage +=  CommonUtil.printlnConcat('■修理費用承認者連絡先　：　', issueRec.RepairTel__c);
      //2013.08.06 S.Haga  Remoce title from client name  end

      strMessage =  strMessage + '■店舗電話番号　：　' + issueRec.StoreTelNo__c + '\n';
      strMessage =  strMessage + '■障害確認日　：　' + String.valueOf(issueRec.IssueDate__c) + '\n';

      //2013/09/20 Satoshi Haga Regi# is added Start
      strMessage +=  CommonUtil.printlnConcatIndent('■障害レジ番号　：　', issueRec.RegiNo__c);
      //2013/09/20 Satoshi Haga Regi# is added End


      //2012.12.01 S.Haga HUB情報はStoreから取得したように変更　Start
      //strMessage +=  CommonUtil.printlnConcat('■HUB情報　：　\n', issueRec.HUB__c);
      List<StoreInfo__c> storeList = [select Id,Name,HUB__c from StoreInfo__c where Id = :issueRec.Store__c];

      if(storeList != null && storeList.size() > 0){
      	StoreInfo__c store = storeList.get(0);
      	strMessage +=  CommonUtil.printlnConcatIndent('■HUB情報　：　\n', store.HUB__c);
      }

      //2012.12.01 S.Haga HUB情報はStoreから取得したように変更　End


      strMessage +=  CommonUtil.printlnConcatIndent('■障害内容　：　\n', issueRec.IssueDetail__c);
      strMessage +=  CommonUtil.printlnConcatIndent('■作業指示　：　\n', issueRec.SagyouShiji__c);
      strMessage +=  CommonUtil.printlnConcat('■貸出機材　：　', issueRec.KashidashiKizai__c);
      strMessage +=  CommonUtil.printlnConcatIndent('■その他連絡事項　：　\n', issueRec.Other__c);

      strMessage += '\n以上です。\n';
      strMessage += '宜しくお願い致します。\n\n\n';
      strMessage += 'カタリナマーケティングジャパン 株式会社\n';
      strMessage += 'オペレーションズサポートグループ\n';
      strMessage = strMessage + Userinfo.getLastName() + ' ' + Userinfo.getFirstName() + '\n';
      strMessage += '住所：　〒105-0001　東京都港区虎ノ門2-2-1　JTビル 14階\n';
      strMessage += '電話番号：　(03)3568-4194 　 FAX： (03)5545-3615\n';

      //Editted by Cloud62 to use email instead of user name
      strMessage = strMessage + '電子メール: ' + Userinfo.getUserEmail();

    //★★★メール件名★★★
    String strSubject = '【ワイヤリング障害対応依頼】　' +  issueRec.Name.substring(0,issueRec.Name.length()-1) + '店様】';

    //★★★返信アドレス★★★
    //Edited 5/2/13, changed from .getUserName to .getUserEmail
    String strReplyTo = Userinfo.getUserEmail();

    //★★★送信アドレス★★★
    List<String> lsttoAddress = new List<String>();
    //直接指定アドレス
    if(!''.equals(CommonUtil.null2Blank(issueRec.Address1__c))) lsttoAddress.add(issueRec.Address1__c);
    if(!''.equals(CommonUtil.null2Blank(issueRec.Address2__c))) lsttoAddress.add(issueRec.Address2__c);
    if(!''.equals(CommonUtil.null2Blank(issueRec.Address3__c))) lsttoAddress.add(issueRec.Address3__c);
    if(!''.equals(CommonUtil.null2Blank(issueRec.Address4__c))) lsttoAddress.add(issueRec.Address4__c);
    if(!''.equals(CommonUtil.null2Blank(issueRec.Address5__c))) lsttoAddress.add(issueRec.Address5__c);
    if(!''.equals(CommonUtil.null2Blank(issueRec.Address6__c))) lsttoAddress.add(issueRec.Address6__c);
    if(!''.equals(CommonUtil.null2Blank(issueRec.Address7__c))) lsttoAddress.add(issueRec.Address7__c);
    if(!''.equals(CommonUtil.null2Blank(issueRec.Address8__c))) lsttoAddress.add(issueRec.Address8__c);
    if(!''.equals(CommonUtil.null2Blank(issueRec.Address9__c))) lsttoAddress.add(issueRec.Address9__c);
    if(!''.equals(CommonUtil.null2Blank(issueRec.Address10__c))) lsttoAddress.add(issueRec.Address10__c);

	//2013.08.06 S.Haga  Remoce title from client name  start

    if(!''.equals(CommonUtil.null2Blank(issueRec.Address11__c))) lsttoAddress.add(issueRec.Address11__c);
    if(!''.equals(CommonUtil.null2Blank(issueRec.Address12__c))) lsttoAddress.add(issueRec.Address12__c);
    if(!''.equals(CommonUtil.null2Blank(issueRec.Address13__c))) lsttoAddress.add(issueRec.Address13__c);
    if(!''.equals(CommonUtil.null2Blank(issueRec.Address14__c))) lsttoAddress.add(issueRec.Address14__c);
    if(!''.equals(CommonUtil.null2Blank(issueRec.Address15__c))) lsttoAddress.add(issueRec.Address15__c);
    if(!''.equals(CommonUtil.null2Blank(issueRec.Address16__c))) lsttoAddress.add(issueRec.Address16__c);
    if(!''.equals(CommonUtil.null2Blank(issueRec.Address17__c))) lsttoAddress.add(issueRec.Address17__c);
    if(!''.equals(CommonUtil.null2Blank(issueRec.Address18__c))) lsttoAddress.add(issueRec.Address18__c);
    if(!''.equals(CommonUtil.null2Blank(issueRec.Address19__c))) lsttoAddress.add(issueRec.Address19__c);
    if(!''.equals(CommonUtil.null2Blank(issueRec.Address20__c))) lsttoAddress.add(issueRec.Address20__c);


	//2013.08.06 S.Haga  Remoce title from client name  end


    //チェーン担当者
    if(!''.equals(CommonUtil.null2Blank(issueRec.AD__c))) lsttoAddress.add(issueRec.AD__c);
    if(!''.equals(CommonUtil.null2Blank(issueRec.AS1__c))) lsttoAddress.add(issueRec.AS1__c);
    if(!''.equals(CommonUtil.null2Blank(issueRec.AS2__c))) lsttoAddress.add(issueRec.AS2__c);
    if(!''.equals(CommonUtil.null2Blank(issueRec.AS3__c))) lsttoAddress.add(issueRec.AS3__c);

    //配列変換
    String[] strtoAddress = CommonUtil.toArray(lsttoAddress);

    //設定した情報を元にメール配信管理インスタンスを作成
    MailControl ctl = new MailControl(true, issueRec.Id, strSubject, strMessage, strReplyTo, strtoAddress);

    //メール配信
    ctl.sendMail();

    }


  @isTest(SeeAllData=true)
  public static void unitTest() {

     //テストデータ準備
    //List<WireringIssueManagement__c> testMap = [select Store__c,StoreMadoguchi__c,StoreMadoguchiTel__c,RepairApprove__c,RepairInCharge__c,RepairTel__c,HUB__c,IssueDetail__c,SagyouShiji__c,KashidashiKizai__c,Other__c,AtenaMailOverlay__c,Mail__c ,MailShintyoku__c,Id,Name,MailCount__c from WireringIssueManagement__c ];
    List<WireringIssueManagement__c> testMap = (List<WireringIssueManagement__c>)new WireringIssueManagementDao('Test').getAllColumnData();

    WireringIssueManagement__c testRec = testMap.get(0);
    //全項目をリセット
    //testRec.StoreMadoguchi__c = null;
    //testRec.StoreMadoguchiTel__c = null;
    //testRec.RepairApprove__c = null;
    //testRec.RepairInCharge__c = null;
    //testRec.RepairTel__c = null;
    //testRec.IssueDetail__c = null;
    //testRec.SagyouShiji__c = null;
    //testRec.KashidashiKizai__c = null;
    //testRec.Other__c = null;
    //testRec.AtenaMailOverlay__c = null; //宛名は通常
    //testRec.Mail__c = false;
    //testRec.MailShintyoku__c = false;

    testRec.Name ='AAA';
    update testRec;

    Id recId = testRec.Id;
    Decimal intMailCount = testRec.MailCount__c;

    //テスト項目１：Nameリセットしても、Nameが自動設定されるか
    //List<WireringIssueManagement__c> resultMap = [select id, Name,Mail__c,MailShintyoku__c,IssueDate__c,ChainName__c,StoreName__c from WireringIssueManagement__c where id = :recId];
    WireringIssueManagement__c resultRec = (WireringIssueManagement__c)new WireringIssueManagementDao('Test').getAllColumnData(recId);

    //System.assert (resultMap != null);

    //WireringIssueManagement__c resultRec = resultMap.get(0);
    System.assert (resultRec.Name.equals('【' + String.valueOf(resultRec.IssueDate__c) + '】　【' + resultRec.ChainName__c.substring(6, resultRec.ChainName__c.length()) + ' '+ resultRec.StoreName__c + '】') );


	//通常メールをオンにして更新
	//resultRec.Mail__c = true;
	resultRec.MailShintyoku__c = false;
	update resultRec;

	resultRec = (WireringIssueManagement__c)new WireringIssueManagementDao('Test').getAllColumnData(recId);
	resultRec.Mail__c = true;
	update resultRec;

	resultRec = (WireringIssueManagement__c)new WireringIssueManagementDao('Test').getAllColumnData(recId);
	resultRec.Mail__c = false;
	update resultRec;

	resultRec = (WireringIssueManagement__c)new WireringIssueManagementDao('Test').getAllColumnData(recId);
	resultRec.MailShintyoku__c = true;
	update resultRec;


	//テスト項目２：メール回数が１つ増えているかどうかを検証
	//resultMap = [select id, Name,Mail__c,MailShintyoku__c,IssueDate__c,ChainName__c,StoreName__c,MailCount__c from WireringIssueManagement__c where id = :recId];
	resultRec = (WireringIssueManagement__c)new WireringIssueManagementDao('Test').getAllColumnData(recId);

    //System.assert (resultMap != null);

    //resultRec = resultMap.get(0);
    System.assert(intMailCount < resultRec.MailCount__c);


     //テストデータ準備
    //List<WireringIssueManagement__c> testMap2 = [select Store__c,StoreMadoguchi__c,StoreMadoguchiTel__c,RepairApprove__c,RepairInCharge__c,RepairTel__c,HUB__c,IssueDetail__c,SagyouShiji__c,KashidashiKizai__c,Other__c,AtenaMailOverlay__c,Mail__c ,MailShintyoku__c,Id,Name,MailCount__c from WireringIssueManagement__c];
    List<WireringIssueManagement__c> testMap2 = (List<WireringIssueManagement__c>)new WireringIssueManagementDao('Test').getAllColumnData();

    WireringIssueManagement__c testRec2 = testMap2.get(0);
    //全項目をリセット
    testRec2.StoreMadoguchi__c = '店舗窓口';
    testRec2.StoreMadoguchiTel__c = '店舗窓口直通';
    testRec2.RepairApprove__c = '未';
    testRec2.RepairInCharge__c = '修理費用承認担当者';
    testRec2.RepairTel__c = '修理費用承認者連絡先';
    testRec2.IssueDetail__c = '障害内容';
    testRec2.SagyouShiji__c = '作業指示';
    testRec2.KashidashiKizai__c = 'あり';
    testRec2.Other__c = 'その他連絡事項';
    testRec2.AtenaMailOverlay__c = 'メールの宛名（上書き用）'; //宛名は通常
    testRec2.Mail__c = false;
    testRec2.MailShintyoku__c = false;
    update testRec2;


    //紐づくチェーンを取得
    //List<StoreInfo__c> wrkStoreList2 = [select Id,Name,ChainRef__c from StoreInfo__c where Id = :testRec2.Store__c];
    StoreInfo__c wrkStore2 = (StoreInfo__c)new StoreInfoDao('Test').getAllColumnData(testRec2.Store__c);

    //StoreInfo__c wrkStore2 = wrkStoreList2.get(0);

    //List<ChainInfo__c> wrkChainList2 = [select Id,Name from ChainInfo__c where Id = :wrkStore2.ChainRef__c];
    ChainInfo__c wrkChain2 = (ChainInfo__c)new ChainInfoDao('Test').getAllColumnData(wrkStore2.ChainRef__c);

    //ChainInfo__c wrkChain2 = wrkChainList2.get(0);



    //直接指定アドレス・チェーン担当者をリセット
    wrkChain2.Address1__c = 'haga@catmktg.co.jp';
    wrkChain2.Address2__c = 'haga@catmktg.co.jp';
    wrkChain2.Address3__c = 'haga@catmktg.co.jp';
    wrkChain2.Address4__c = 'haga@catmktg.co.jp';
    wrkChain2.Address5__c = 'haga@catmktg.co.jp';
    wrkChain2.Address6__c = 'haga@catmktg.co.jp';
    wrkChain2.Address7__c = 'haga@catmktg.co.jp';
    wrkChain2.Address8__c = 'haga@catmktg.co.jp';
    wrkChain2.Address9__c = 'haga@catmktg.co.jp';
    wrkChain2.Address10__c = 'haga@catmktg.co.jp';
    wrkChain2.Address11__c = 'haga@catmktg.co.jp';
    wrkChain2.Address12__c = 'haga@catmktg.co.jp';
    wrkChain2.Address13__c = 'haga@catmktg.co.jp';
    wrkChain2.Address14__c = 'haga@catmktg.co.jp';
    wrkChain2.Address15__c = 'haga@catmktg.co.jp';
    wrkChain2.Address16__c = 'haga@catmktg.co.jp';
    wrkChain2.Address17__c = 'haga@catmktg.co.jp';
    wrkChain2.Address18__c = 'haga@catmktg.co.jp';
    wrkChain2.Address19__c = 'haga@catmktg.co.jp';
    wrkChain2.Address20__c = 'haga@catmktg.co.jp';


    List<User> userList = [SELECT Id FROM User];
    User wrkUser = userList.get(0);
    wrkChain2.AS1__c = wrkUser.Id;
    wrkChain2.AS2__c = wrkUser.Id;
    wrkChain2.AS3__c = wrkUser.Id;
    update wrkChain2;


	//通常メールをオフ、進捗確認メールをオンにして更新
	intMailCount = resultRec.MailCount__c;
	resultRec.Mail__c = false;
	resultRec.MailShintyoku__c = true;
	update resultRec;

	resultRec = (WireringIssueManagement__c)new WireringIssueManagementDao('Test').getAllColumnData(recId);

    System.assert(intMailCount < resultRec.MailCount__c);

    }


}