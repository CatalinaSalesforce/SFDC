/*
@Name            : ProgramRecTriggerHandler
@Author          : Satoshi Haga
@Date            : July 19, 2013
@Description     : Trigger execution apex class for program_req__c
@version         : 06/01/2012 First Creation
*/
public class ProgramRecTriggerHandler {

	/**
	 * Trigger execution method. This is triggered before insertion.
	 * @param newReqs the list of new record
	 */
	public void OnBeforeInsert(program_req__c[] newReqs){

		// set WCheck1LastUpdateDate__c to system date.
		program_req__c req = newReqs[0];
		req.WCheck1LastUpdateDate__c = system.today();

		// set record type name
		sobject recordType = [select Name, Id from RecordType where Id = :req.RecordTypeID__c LIMIT 1];
		req.recordTypeName__c = (String)recordType.get('Name');

		// 2013/07/19 Satoshi Haga Initialize program information Add Start
		//Initialize program information
		req.req_app__c = null;
		req.PDT_Role__c = null;
		req.req_ng_reason__c = null;
		req.RANK__c = null;
		req.WCheck1__c = false;
		req.WCheck2__c = false;
		req.LastModifiedPerson__c = null;
		req.Programer_revice__c = false;
		req.proguramer_Comment__c = null;
		req.PDT_C__c = null;
		// 2013/07/19 Satoshi Haga Initialize program information Add End

    }

	/**
	 * Trigger execution method. This is triggered before updation.
	 * @param old the list of old record
	 * @param updated the list of new record
	 * @param programMap the mapping file of new record
	 */
	public void OnBeforeUpdate(program_req__c[] old, program_req__c[] updated, Map<ID, program_req__c> programMap){

		program_req__c newReq = updated[0];
		program_req__c oldReq = old[0];

		//2013.08.16 Satoshi Haga Validation check Start
		//Validation Check
		if(!isValid(oldReq, newReq)){
			//Invalid. Return here
			return;
		}
		//2013.08.16 Satoshi Haga Validation check End

		//Check if WCheck1__c is u@dated or not
		if(newReq.WCheck2__c != oldReq.WCheck2__c ){

			//Update WCheck1LastUpdateDate__c
			newReq.WCheck1LastUpdateDate__c = system.today();

			//2013.03.10 S.Haga Add Start
			//Set next date when it is after PM
			Integer intNowTime = Integer.valueOf(datetime.now().format('HH'));
			if(intNowTime >= 16){
				newReq.WCheck1LastUpdateDate__c = newReq.WCheck1LastUpdateDate__c.addDays(1);
			}
			//2013.03.10 S.Haga Add End

			//Update LastModifiedPerson__c
			String userid = UserInfo.getUserId();
			List<User> lstUser = [Select Id, Name ,Username from User where Id = :userid];
			User lastModified =  lstUser.get(0);

			newReq.LastModifiedPerson__c = lastModified.Name;

		}

    }


	//2013.08.16 Satoshi Haga Validation method Start
	/**
	 * Validation method
	 * @param old the list of old record
	 * @return true : paarameter is valid	false : parameter is invalid
	 */
	public Boolean isValid(program_req__c old, program_req__c updated){

		//Redoing is not allowed.
		if(old.req_app__c != null && !old.req_app__c.equals(updated.req_app__c) ){

			updated.req_app__c.addError('受領・未受領の再設定は出来ません。');
			updated.addError('受領・未受領の再設定は出来ません。');

			return false;
		}

		if(('ＯＫ'.equals(old.PDT_C__c) || 'ＮＧ（修正依頼を出します）'.equals(old.PDT_C__c))
		    && !old.PDT_C__c.equals(updated.PDT_C__c) ){

			updated.PDT_C__c.addError('「プロダクションの修正確認」の再設定は出来ません');
			updated.addError('「プロダクションの修正確認」の再設定は出来ません');

			return false;
		}


		//It is not allowed to change detail after accepting by production team
		if(old.req_app__c != null){
		   if(old.req_detail__c == null){
		   		if(updated.req_detail__c != null && !''.equals(updated.req_detail__c.replace('\r\n', '').replace('\n', ''))){
					updated.req_detail__c.addError('PDTが受領/未受領を受け付けた後に、依頼内容詳細を変更する事は出来ません。');
					updated.addError('PDTが受領/未受領を受け付けた後に、依頼内容詳細を変更する事は出来ません。');
					return false;
		   	 	}

		   }else if(!old.req_detail__c.replace('\r\n', '').replace('\n', '').equals(updated.req_detail__c.replace('\r\n', '').replace('\n', ''))){
				updated.req_detail__c.addError('PDTが受領/未受領を受け付けた後に、依頼内容詳細を変更する事は出来ません。');
				updated.addError('PDTが受領/未受領を受け付けた後に、依頼内容詳細を変更する事は出来ません。');
				return false;
		   	}
		}

		//It is not allowed to change "programer_Comment__c" after re-accepting by production team
		if(
			('ＯＫ'.equals(old.PDT_C__c) || 'ＮＧ（修正依頼を出します）'.equals(old.PDT_C__c) )
			&& old.proguramer_Comment__c != null
			&& !old.proguramer_Comment__c.equals(updated.proguramer_Comment__c) ){

			updated.proguramer_Comment__c.addError('PDTが修正確認を行った後に、「プログラム担当者 修正内容詳細」を変更する事は出来ません。');
			updated.addError('PDTが修正確認を行った後に、「プログラム担当者 修正内容詳細」を変更する事は出来ません。');

			return false;
		}

		//Some fields should be empty when request is accepted by our client service
		if('受領'.equals(updated.req_app__c)
		   && (updated.req_ng_reason__c != null || updated.RANK__c != null || updated.Programer_revice__c == true || updated.proguramer_Comment__c != null || updated.PDT_C__c != null ) ){

			if(!''.equals(updated.req_ng_reason__c)
			   && updated.req_ng_reason__c != null){

				updated.req_ng_reason__c.addError('依頼受領が「受領」の場合、依頼未受領 理由　に内容を入力する事は出来ません。');
				updated.addError('依頼受領が「受領」の場合、未受領時の項目を編集する事は出来ません');

			}

			if(updated.RANK__c != null){

				updated.RANK__c.addError('依頼受領が「受領」の場合、クリティカルRANKを選択する事は出来ません。');
				updated.addError('依頼受領が「受領」の場合、未受領時の項目を編集する事は出来ません');

			}

			if(updated.Programer_revice__c == true){

				updated.Programer_revice__c.addError('依頼受領が「受領」の場合、プログラム担当者修正完了チェック　をチェックする事は出来ません。');
				updated.addError('依頼受領が「受領」の場合、未受領時の項目を編集する事は出来ません');

			}

			if(!''.equals(updated.proguramer_Comment__c)
			   && updated.proguramer_Comment__c != null){

				updated.proguramer_Comment__c.addError('依頼受領が「受領」の場合、プログラム担当者 修正内容詳細　に内容を入力する事は出来ません。');
				updated.addError('依頼受領が「受領」の場合、未受領時の項目を編集する事は出来ません');

			}

			if('ＯＫ'.equals(updated.PDT_C__c)
			   || 'ＮＧ（修正依頼を出します）'.equals(updated.PDT_C__c) ){

				updated.PDT_C__c.addError('依頼受領が「受領」の場合、プロダクションの修正確認　を編集する事は出来ません。');
				updated.addError('依頼受領が「受領」の場合、未受領時の項目を編集する事は出来ません');

			}


			return false;
		}


		//Return valid
		return true;
	}
    //2013.08.16 Satoshi Haga Validation method End

	@isTest(SeeAllData=true)
	public static void unitTest() {
		//Cycle Name, Iruka Flag, Order Description, Order detailed description
		program_req__c testReq = new program_req__c();

		//Cycle Name
		List<cycleDB__c> parents = [select id from cycleDB__c];
		testReq.cycle_name__c = parents.get(0).Id;
		//Iruka Flag
		testReq.To_IRUKA__c = '完了';
		//Order Description
		testReq.req_type1__c = '新規作成';
		//Order detailed description
		testReq.req_detail__c = 'サンプル内容詳細';

		//2013.07.21 S.HAGA ADD TEST CODE START
		testReq.req_app__c = '受領';

		List<User> listUser = [select id from User where Japan_Role__c = 'Production'];
		testReq.PDT_Role__c = (ID)listUser.get(0).Id;

		testReq.req_ng_reason__c = 'TestReq_ng_reason__c';
		testReq.RANK__c = '発券ロス';
		testReq.WCheck1__c = true;
		testReq.WCheck2__c = true;
		testReq.LastModifiedPerson__c = 'TestUesr';
		testReq.Programer_revice__c = true;
		testReq.proguramer_Comment__c = 'Testproguramer_Comment__c';
		testReq.PDT_C__c = 'OK';
		//2013.07.21 S.HAGA ADD TEST CODE END


		//Register this record into program_req__c
		insert testReq;

		//Get this record from program_req__c

		//2013.07.21 S.HAGA MODIFY TEST CODE START
		//List<program_req__c> resultReqs = [select id, WCheck1LastUpdateDate__c from program_req__c where Id =: testReq.Id];
		List<program_req__c> resultReqs = [select id, WCheck1LastUpdateDate__c,req_app__c,PDT_Role__c,req_ng_reason__c,RANK__c,WCheck1__c,WCheck2__c,LastModifiedPerson__c,Programer_revice__c,proguramer_Comment__c,PDT_C__c from program_req__c where Id =: testReq.Id];
		//2013.07.21 S.HAGA MODIFY TEST CODE END

		program_req__c resultReq = resultReqs.get(0);

		//2013.07.21 S.HAGA ADD TEST CODE START
		//Check if this data is intialized correctly or not
		System.assert(resultReq.req_app__c == null);
		System.assert(resultReq.PDT_Role__c == null);
		System.assert(resultReq.req_ng_reason__c == null);
		System.assert(resultReq.RANK__c == null);
		System.assert(resultReq.WCheck1__c == false);
		System.assert(resultReq.WCheck2__c == false);
		System.assert(resultReq.LastModifiedPerson__c == null);
		System.assert(resultReq.Programer_revice__c == false);
		System.assert(resultReq.proguramer_Comment__c == null);
		System.assert(resultReq.PDT_C__c == null);
		//2013.07.21 S.HAGA ADD TEST CODE END

		//Check if WCheck1LastUpdateDate__c is set to system date or not.
		system.assert(resultReq.WCheck1LastUpdateDate__c.daysBetween(system.today()) == 0);

		//更新日時を12月21日にする
		resultReq.WCheck1LastUpdateDate__c = Date.newInstance(2012,12,21);

		//Set WCheck1__c as checked, and commit this change
		resultReq.WCheck1__c = true;
		update resultReq;

		//Check if last updated date is today
		resultReqs = [select id, WCheck1LastUpdateDate__c from program_req__c where Id =: resultReq.Id];
		resultReq = resultReqs.get(0);


		//2013.08.16 Satoshi Haga Test Code Add Start
		ProgramRecTriggerHandler handler = new ProgramRecTriggerHandler();

		program_req__c newTestReq = new program_req__c();
		newTestReq.req_app__c = '受領';
		program_req__c oldTestReq = new program_req__c();
		oldTestReq.req_app__c = '未受領';


		System.assert(handler.isValid(oldTestReq, newTestReq) == false);



		newTestReq = new program_req__c();
		newTestReq.PDT_C__c = 'ＯＫ';
		oldTestReq = new program_req__c();
		oldTestReq.PDT_C__c = 'ＮＧ（修正依頼を出します）';

		System.assert(handler.isValid(oldTestReq, newTestReq) == false);



		oldTestReq = new program_req__c();
		oldTestReq.req_app__c = '未受領';
		oldTestReq.req_detail__c = '変更前の依頼内容';

		newTestReq = new program_req__c();
		newTestReq.req_app__c = '未受領';
		newTestReq.req_detail__c = '変更後の依頼内容';

		System.assert(handler.isValid(oldTestReq, newTestReq) == false);



		oldTestReq = new program_req__c();
		oldTestReq.PDT_C__c = 'ＯＫ';
		oldTestReq.proguramer_Comment__c = '変更前のコメント';

		newTestReq = new program_req__c();
		newTestReq.PDT_C__c = 'ＯＫ';
		newTestReq.proguramer_Comment__c = '変更後のコメント';

		System.assert(handler.isValid(oldTestReq, newTestReq) == false);



		newTestReq = new program_req__c();
		newTestReq.req_app__c = '受領';
		oldTestReq = new program_req__c();
		oldTestReq.req_app__c = '受領';

		newTestReq.req_ng_reason__c = 'AAA';
		newTestReq.RANK__c = '発券ロス';
		newTestReq.Programer_revice__c = true;
		newTestReq.proguramer_Comment__c = 'AAA';
		newTestReq.PDT_C__c = 'ＯＫ';

		System.assert(handler.isValid(oldTestReq, newTestReq) == false);



		//2013.08.16 Satoshi Haga Test Code Add End

	}

}