/*
@Name            : ItProjectRequestTrrigerHandler
@Author          : Satoshi Haga
@Date            : July 19, 2013
@Description     : Trigger execution apex class for IT_Project_Request__c
@version         : 08/01/2013 First Creation
*/
public with sharing class ItProjectRequestTrrigerHandler {

	private static String IT_MANAGER = '陳建志';
	private static String IT_DIRECTOR = '富樫有博';

	private static String ADDING_MESSAGE;


	/**
	 * Constructor. ADDING_MESSAGE is changed by system-time and user information.
	 *
	 * @param newReqs the list of new record
	 */
	public ItProjectRequestTrrigerHandler(){

		//Get informatoin from JapanUserTable__c
		Id currentUserId = UserInfo.getUserId();

		Map<String, String> param1 = new Map<String, String>();
		param1.put('SalesforceID__c', '' + currentUserId);

		JapanUserTableDao userDao = new JapanUserTableDao('ItProjectRequestTrrigerHandler');
		JapanUserTable__c user = ((List<JapanUserTable__c>)userDao.getValue(param1)).get(0);

		String strUserName;
		if (user != null && user.UserName__c != null){

			 strUserName = user.UserName__c;
		}else{
			strUserName = 'Unknowun User';
		}

		//Get System date as 'yyyy/mm/dd'
		String strDateYYYYMMDD = date.today().format();

		//Set message header
		ADDING_MESSAGE = '--------------------' + strDateYYYYMMDD + '  :  ' +  strUserName + + ' Wrote   --------------------\n\n';


	}

	/**
	 * Trigger execution method. This is triggered before insertion.
	 *
	 * @param newReqs the list of new record
	 */
	public void OnBeforeInsert(IT_Project_Request__c[] newReqs){

		//Get Manager ID and Department Manager ID from custom user table.
		//ItProjectRequestDao proDao = ItProjectRequestDao();
		IT_Project_Request__c req = newReqs[0];

		//CUstom validate check
		if(!isValid(req)){
			return ;
		}

		//Set ProjectName__c to Name
		req.Name =req.ProjectName__c;


		Id currentUserId = UserInfo.getUserId();

		JapanUserTableDao userDao = new JapanUserTableDao('ItProjectRequestTrrigerHandler');

		Map<String, String> param1 = new Map<String, String>();
		param1.put('SalesforceID__c', '' + currentUserId);

		JapanUserTable__c user = ((List<JapanUserTable__c>)userDao.getValue(param1)).get(0);

		Integer intApprover = 0;

		//Set Manager ID to 2nd approver
		if(user != null && user.ManagerSalesforceID__c != null && user.ManagerSalesforceID__c != user.DepartmentManagerSalesforceID__c){

			//Set Approver
			req.Approver02__c = user.ManagerSalesforceID__c;
			req.ApprovalChain1__c = user.ManagerSalesforceID__c;
			intApprover++;

			param1.put('SalesforceID__c', '' + user.ManagerSalesforceID__c);

			user = ((List<JapanUserTable__c>)userDao.getValue(param1)).get(0);

			//Set Manager ID to 3nd approver
			if(user != null && user.ManagerSalesforceID__c != null && user.ManagerSalesforceID__c != user.DepartmentManagerSalesforceID__c){

				//Set Approver
				req.Approver03__c = user.ManagerSalesforceID__c;
				req.ApprovalChain2__c = user.ManagerSalesforceID__c;
				intApprover++;

				param1.put('SalesforceID__c', '' + user.ManagerSalesforceID__c);

				user = ((List<JapanUserTable__c>)userDao.getValue(param1)).get(0);

				//Set Manager ID to 4nd approver
				if(user != null && user.ManagerSalesforceID__c != null && user.ManagerSalesforceID__c != user.DepartmentManagerSalesforceID__c){

					//Set Approver
					req.Approver04__c = user.ManagerSalesforceID__c;
					req.ApprovalChain3__c = user.ManagerSalesforceID__c;
					intApprover++;
				}

			}

		}



		//Set Department Manager ID to 7nd approver
		if(user != null && user.DepartmentManagerSalesforceID__c != null){
			req.Approver07__c = user.DepartmentManagerSalesforceID__c;

			//Change item according to the number of approver
			if(intApprover == 1){
				req.ApprovalChain2__c = user.DepartmentManagerSalesforceID__c;
			}else if (intApprover == 2){
				req.ApprovalChain3__c = user.DepartmentManagerSalesforceID__c;
			}else if (intApprover == 3){
				req.ApprovalChain4__c = user.DepartmentManagerSalesforceID__c;
			}
		}

		//Set IT manager to Approver09
		Map<String, String> param2 = new Map<String, String>();
		param2.put('UserName__c', IT_MANAGER);

		JapanUserTable__c itManager = ((List<JapanUserTable__c>)userDao.getValue(param2)).get(0);
		if(itManager != null && itManager.SalesforceID__c != null){
			req.Approver09__c = itManager.SalesforceID__c;
		}

		//Set IT director to Approver10
		Map<String, String> param3 = new Map<String, String>();
		param3.put('UserName__c', IT_DIRECTOR);

		JapanUserTable__c itDirector = ((List<JapanUserTable__c>)userDao.getValue(param3)).get(0);
		if(itDirector != null && itDirector.SalesforceID__c != null){
			req.Approver10__c = itDirector.SalesforceID__c;
		}

		//Set owner to requester
 		req.Requester__c = currentUserId;

		//Set approver06 to answerer
 		req.Answerer__c = req.Approver06__c;

	}


	/**
	 * Trigger execution method. This is triggered before updation.
	 * @param old the list of old record
	 * @param updated the list of new record
	 * @param programMap the mapping file of new record
	 */
	public void OnBeforeUpdate(IT_Project_Request__c[] old, IT_Project_Request__c[] updated, Map<ID, IT_Project_Request__c> programMap){

		IT_Project_Request__c newReq = updated[0];
		IT_Project_Request__c oldReq = old[0];

		//CUstom validate check
		if(!isValid(newReq)){
			return ;
		}

		//Check if Comment__c is updated or not
		if(newReq.Comment__c != null ){

			//Save this comment into EmailMessage__c for alert email
			newReq.EmailMessage__c = newReq.Comment__c;

			//Add new message to message history, and clear this new message
			if(newReq.ChangeHistory__c == null) newReq.ChangeHistory__c = '';

			newReq.ChangeHistory__c = ADDING_MESSAGE + newReq.Comment__c + '\n' + newReq.ChangeHistory__c;
			newReq.Comment__c = null;

		}

    }

	/**
	 * Custom valildate check
	 * @param newRec new record.
	 * @return true success  false validation error
	 */
	public Boolean isValid(IT_Project_Request__c newRec){

		Boolean retFlg = true;

		//Priority__c
		if(newRec.Priority__c == null){
			newRec.addError('優先度: 値を入力してください');
			newRec.Priority__c.addError('優先度: 値を入力してください');
			retFlg = false;
		}

		//RequestDescription__c
		if(newRec.RequestDescription__c == null){
			newRec.addError('依頼内容: 値を入力してください');
			newRec.RequestDescription__c.addError('依頼内容: 値を入力してください');
			retFlg = false;
		}

		//ReasonDecription__c
		if(newRec.ReasonDecription__c == null){
			newRec.addError('理由: 値を入力してください');
			newRec.ReasonDecription__c.addError('理由: 値を入力してください');
			retFlg = false;
		}

		//BenefitDescription__c
		if(newRec.BenefitDescription__c == null){
			newRec.addError('ベネフィット: 値を入力してください');
			newRec.BenefitDescription__c.addError('ベネフィット: 値を入力してください');
			retFlg = false;
		}

		return retFlg;

	}

	/**
	 * Test method
	 */
	@isTest(SeeAllData=false)
    public static void unitTest() {

		//Prepare for testing

		/** Preparetion for Testing */
    	JapanConstants__c constJ = new JapanConstants__c();
    	constJ.TypeA__c = 'ItRequestManagement';
    	constJ.TypeB__c = 'ArrowImage';
    	constJ.Value__c = '015K00000009qwY';
    	insert constJ;


		JapanUserTable__c user = new JapanUserTable__c();

		List<User> departmentManager = [select id,Name,Username from User where Name  like '%上野%'];

		user.UserName__c = '上野';
		user.SalesforceID__c = departmentManager.get(0).Id;
		user.ManagerSalesforceID__c = null;
		user.DepartmentManagerSalesforceID__c = departmentManager.get(0).Id;
		user.CheckAuthorityForITReq__c = false;
		//Department Manager
		insert user;


		user = new JapanUserTable__c();

		List<User> maanager = [select id,Name,Username from User where Name  like '%岩永%'];

		user.UserName__c = '岩永';
		user.SalesforceID__c = maanager.get(0).Id;
		user.ManagerSalesforceID__c = departmentManager.get(0).Id;
		user.DepartmentManagerSalesforceID__c = departmentManager.get(0).Id;
		user.CheckAuthorityForITReq__c = false;
		//Manager
		insert user;


		user = new JapanUserTable__c();

		List<User> normalUser = [select id,Name,Username from User where Name  like '%南部%'];

		user.UserName__c = '南部';
		user.SalesforceID__c = normalUser.get(0).Id;
		user.ManagerSalesforceID__c = maanager.get(0).Id;
		user.DepartmentManagerSalesforceID__c = departmentManager.get(0).Id;
		user.CheckAuthorityForITReq__c = false;
		//Normail User
		insert user;


		user = new JapanUserTable__c();

		List<User> itDirector = [select id,Name,Username from User where Name  like '%富樫%'];

		user.UserName__c = '富樫有博';
		user.SalesforceID__c = itDirector.get(0).Id;
		user.ManagerSalesforceID__c = null;
		user.DepartmentManagerSalesforceID__c = itDirector.get(0).Id;
		user.CheckAuthorityForITReq__c = false;
		//IT Director
		insert user;


		user = new JapanUserTable__c();

		List<User> itManager = [select id,Name,Username from User where Name  like '%陳%'];

		user.UserName__c = '陳建志';
		user.SalesforceID__c = itManager.get(0).Id;
		user.ManagerSalesforceID__c = itDirector.get(0).Id;
		user.DepartmentManagerSalesforceID__c = itDirector.get(0).Id;
		user.CheckAuthorityForITReq__c = false;
		//IT Manager
		insert user;



		user = new JapanUserTable__c();

		user.UserName__c = 'Test User';
		user.SalesforceID__c = UserInfo.getUserId();
		user.ManagerSalesforceID__c = maanager.get(0).Id;
		user.DepartmentManagerSalesforceID__c = departmentManager.get(0).Id;
		user.CheckAuthorityForITReq__c = false;
		//Test user
		insert user;


    	//Test the method "isValid". ItRequestExtension.unitTest covers other method.
		ItProjectRequestTrrigerHandler handle = new ItProjectRequestTrrigerHandler();

		IT_Project_Request__c req = new IT_Project_Request__c();
		Boolean retFlg = handle.isValid(req);

		System.assert(retFlg == false);


    }




}