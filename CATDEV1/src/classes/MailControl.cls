/**********************************************************
*  MailControl
*  メール配信管理クラス
*  version： 1.0
*  作成： Satoshi Haga
***********************************************************/
public class MailControl {

  /** メンバ　 */
  // EMailオブジェクト
  private List<Messaging.Email> mailList = new List<Messaging.Email>();


  /**　単一メール配信用のコンストラクタ */
  public MailControl(Boolean flgAttached, Id recordId, String strSubject, String strMessage, String strReplyTo, String[] strtoAddress){

    // 単一メール
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        //　各種設定
        mail.setSubject(strSubject);
        mail.setPlainTextBody(strMessage);
        mail.setReplyTo(strReplyTo);
        mail.setToAddresses(strtoAddress);
        mail.setCharset('ISO-2022-JP');
        //Cloud62 editted mailing to use User's Name instead of No Reply

        //2013.08.07 S.HAGA Change display name according to Japan busiess practice START
        //mail.setSenderDisplayName(UserInfo.getFirstName()+' '+UserInfo.getLastName());
        mail.setSenderDisplayName(UserInfo.getLastName()+' '+UserInfo.getFirstName());
        //2013.08.07 S.HAGA Change display name according to Japan busiess practice END


    // 添付ファイル設定
    if(flgAttached){
          // レコードにひもずく添付ファイルを取得
          List<Attachment> atts = [select name, body from attachment where parentId = :recordId];

          // メールの添付ファイルを設定
          List<Messaging.Emailfileattachment> fas = new List<Messaging.Emailfileattachment>();

          for (Attachment att : atts){
              Messaging.Emailfileattachment fa = new Messaging.Emailfileattachment();
              fa.setFileName(att.name);
        fa.setBody(att.body);
        fas.add(fa);
          }

          if(!(fas.size() == 0)){
              mail.setFileAttachments(fas);
          }
    }

    //　メールリストに追加する。
    mailList.add(mail);

  }

  /** メール配信メソッド */
  public void sendMail(){

    Messaging.sendEmail(mailList);

  }



}