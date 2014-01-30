/*
@Name            : QuestionFormProductionTriggerHandler
@Author          : Satoshi Haga
@Date            : Aug 16, 2013
@Description     : Trigger execution apex class for PDT__c
@version         : 08/16/2013 First Creation
*/
public with sharing class QuestionFormProductionTriggerHandler {

	/**
	 * Trigger execution method. This is triggered before updation.
	 * @param old the list of old record
	 * @param updated the list of new record
	 * @param programMap the mapping file of new record
	 */
	public void OnBeforeUpdate(PDT__c[] old, PDT__c[] updated, Map<ID, PDT__c> programMap){

		PDT__c newQuestion = updated[0];
		PDT__c oldQuestion = old[0];

		//Validation Check
		if(!isValid(oldQuestion, newQuestion)){
			//Invalid. Return here
			return;
		}

    }


	/**
	 * Validation method
	 * @param old the list of old record
	 * @return true : paarameter is valid	false : parameter is invalid
	 */
	public Boolean isValid(PDT__c old, PDT__c updated){


		//Redoing is not allowed.
		if(
			('ＯＫ'.equals(old.PDT_CH__c) || 'ＮＧ（修正依頼を再度出します'.equals(old.PDT_CH__c))
		    && !old.PDT_CH__c.equals(updated.PDT_CH__c) ){

			updated.PDT_CH__c.addError('「プロダクションの修正確認」の再設定は出来ません');
			updated.addError('「プロダクションの修正確認」の再設定は出来ません');

			return false;
		}

		//It is not allowed to change "programer_Comment__c" after re-accepting by production team
		if(
			('ＯＫ'.equals(old.PDT_CH__c) || 'ＮＧ（修正依頼を再度出します'.equals(old.PDT_CH__c))
			&& old.PG_Comment__c != null
			&& !old.PG_Comment__c.equals(updated.PG_Comment__c) ){

			updated.PG_Comment__c.addError('PDTが修正確認を行った後に、「プログラム担当者 対応コメント」を変更する事は出来ません。');
			updated.addError('PDTが修正確認を行った後に、「プログラム担当者 対応コメント」を変更する事は出来ません。');

			return false;
		}

		//Return valid
		return true;

	}

	@isTest(SeeAllData=true)
	public static void unitTest() {

		QuestionFormProductionTriggerHandler handler = new QuestionFormProductionTriggerHandler();

		PDT__c pdtOld = new PDT__c();
		PDT__c pdtNew = new PDT__c();
		pdtOld.PDT_CH__c = 'ＯＫ';
		pdtNew.PDT_CH__c = 'ＮＧ（修正依頼を再度出します';
		//Redoing is not allowed.
		System.assert(handler.isValid(pdtOld, pdtNew) == false);

		pdtOld.PDT_CH__c = 'ＯＫ';
		pdtNew.PDT_CH__c = 'ＯＫ';

		pdtOld.PG_Comment__c = 'A';
		pdtNew.PG_Comment__c = 'B';

		//It is not allowed to change "programer_Comment__c" after re-accepting by production team
		System.assert(handler.isValid(pdtOld, pdtNew) == false);

		List<PDT__c> listPdt = [select Id,Ball_Status__c,CreatedById,CreatedDate,CurrencyIsoCode,FULL2__c,Field1__c,IsDeleted,Japan_ID__c,Keikanissuu__c,LastActivityDate,LastModifiedById,LastModifiedDate,Legacy_Created_By__c,Legacy_Last_Modified_By__c,Name,Opportunity_Name__c,Order_Date_PDT__c,Order_Fin__c,PASS2__c,PDT_CH__c,PDT_incharge__c,PG_Check__c,PG_Comment__c,PGconf__c,PlanSheet__c,RANK__c,SystemModstamp,Type_PDT__c,brand_PDT__c,contractDB_No__c,cycleDB__c,plansheet_name2__c,programmer__c,projectname_PDT__c from PDT__c];

		PDT__c pdt = (PDT__c)listPdt.get(0);

		//Confirm that normal object is changed with no problem now.
		update pdt;
	}


}