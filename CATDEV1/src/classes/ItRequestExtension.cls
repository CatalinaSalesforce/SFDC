/*
@Name            : ItRequestExtension
@Author          : Satoshi Haga
@Date            : Aug 8, 2013
@Description     : Extension class for It request management
@version         : 08/08/2013 First Creation
*/
public with sharing class ItRequestExtension {


	public String strObjectName { get; set; }

	//2013.10.02 Satoshi Haga Adding history data Start
	//History
    public String id;
    public list<cHistories> histories;
	//2013.10.02 Satoshi Haga Adding history data End


	/** public valiable. these are called from each visualforce page */
	public List<KeyValue> datalist{ get; set; }
	public IT_Project_Request__c itReq { get; set; }
	public List<String> fileLst { get; set; }
	public String imageUrl { get; set; }

	/**
	 * Constructor
	 * @param stdController this is gotten by salesforce standard framwwork when accessing each page.
	 */
	public ItRequestExtension(ApexPages.StandardController stdController) {

		strObjectName = stdController.getRecord().getSObjectType().getDescribe().getName();

		//2013.10.02 Satoshi Haga Adding history data Start
		//History
		id = apexpages.currentPage().getParameters().get('Id');
		//2013.10.02 Satoshi Haga Adding history data End


		ItProjectRequestDao dao = new ItProjectRequestDao('ItRequestExtension');
		itReq = (IT_Project_Request__c)dao.getAllColumnData(stdController.getRecord().ID);

		//Check the authority by user info.
		Id currentUserId = UserInfo.getUserId();

		JapanUserTableDao userDao = new JapanUserTableDao('JapanPublicExtension');

		Map<String, String> param1 = new Map<String, String>();
		param1.put('SalesforceID__c', '' + currentUserId);

		JapanUserTable__c user = ((List<JapanUserTable__c>)userDao.getValue(param1)).get(0);

		if(itReq == null){
			return;
		}

		if(user != null && user.CheckAuthorityForITReq__c == true){
			//This user have authority to change the status of this project
			itReq.CheckFlg__c = true;
		}

		//Reset Comment
		itReq.MailTo__c = null;
		itReq.MailToBoss__c = null;
		itReq.MailToName__c = null;

		//Set file list
		datalist = new List<KeyValue>();
		datalist.add(new KeyValue('1',itReq.Document1__c));
		datalist.add(new KeyValue('2',itReq.Document2__c));
		datalist.add(new KeyValue('3',itReq.Document3__c));
		datalist.add(new KeyValue('4',itReq.Document4__c));
		datalist.add(new KeyValue('5',itReq.Document5__c));
		datalist.add(new KeyValue('6',itReq.Document6__c));
		datalist.add(new KeyValue('7',itReq.Document7__c));
		datalist.add(new KeyValue('8',itReq.Document8__c));
		datalist.add(new KeyValue('9',itReq.Document9__c));
		datalist.add(new KeyValue('10',itReq.Document10__c));

		//Set Image Url by calling JapanConstantsDao
		String strAlartId = '';
		Map<String,String> param = new Map<String,String>();
		param.put('TypeA__c', 'ItRequestManagement');
		param.put('TypeB__c', 'ArrowImage');

		JapanConstantsDao constDao = new JapanConstantsDao('ItRequestExtension');

		List<JapanConstants__c> listConst = (List<JapanConstants__c>)constDao.getValue(param);
		if(listConst == null || listConst.size() == 0){
			imageUrl = '';
			return;
		}


		JapanConstants__c imageConst = ((List<JapanConstants__c>)constDao.getValue(param)).get(0);

		if(imageConst != null){
			imageUrl = imageConst.Value__c;
		}else{
			imageUrl = '';
		}

    }


	/**
	* Approval Request Method.
	* This method subimit the approval request related with each object
	*  @return PageReference  null value is returend. Therefore, page is moved to the reference page of the same object.
	*/
    public PageReference apply() {
        Id id = ApexPages.currentPage().getParameters().get('id');

        Approval.ProcessSubmitRequest request =  new Approval.ProcessSubmitRequest();
        request.setObjectId(id);
        Approval.ProcessResult result;
        try {
            result = Approval.process(request);
        } catch (System.DmlException e) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, '承認プロセスに該当するレコードではありませんでした．'));
			return null;
        }

		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, '申請に成功しました。'));

        return null;
    }


	/**
	* Local Class.
	*
	*/
	public class KeyValue{

		public String key{ get; set; }
		public String value{ get; set; }

		/** Constructor */
		public KeyValue(String key, String value){
			this.key = key;
			this.value = value;
		}
	}


//2013.10.02 Satoshi Haga Adding history data Start
	/**
	*  Getter Method for history.
	*  @param list<cHistories>  history list
	*/
	public list<cHistories> getHistories() {
        list<cHistories> list_ch = new list<cHistories>();
        list<IT_Project_Request__History> Histories = new list<IT_Project_Request__History>();
        Map<String, String> fieldNames = new Map<String, String>();

        Histories = [
            Select ParentId, OldValue, NewValue, IsDeleted, Id, Field, CreatedDate, CreatedById, CreatedBy.Name
            From IT_Project_Request__History
            where ParentId = :id order by CreatedDate desc Limit 1000];

        // Get Label Name
        Map<String, Schema.SObjectField> fmap = Schema.SObjectType.IT_Project_Request__c.fields.getMap();
        for(Schema.sObjectField f : fmap.values()) {
            fieldNames.put(f.getDescribe().getName(),f.getDescribe().getLabel());
        }

        for(IT_Project_Request__History obj:Histories){
            list_ch.add(getSubHistories(obj, fieldNames));
        }

        return list_ch;
    }

	/**
	*  Hisotyr DTO inner class.
	*/
	public class cHistories {
        public String theDate {get; set;}
        public String who {get; set;}
        public String action {get; set;}
    }

	/**
	*  Formatter method.
	*  @return strValue  unformatted message
	*/
	public String getParseValue(String strValue){
		String fromText = '';

		if(strValue == null || ''.equals(strValue)){
			return 'NULL';
		}

		try{
			fromText = Date.valueOf(strValue).format();
		}catch(Exception e){
			fromText = String.valueOf(strValue);
		}
		return fromText;
	}

	/**
	*  Converting method from history object to display message.
	*  @param obj  		  history object
	*  @param fieldNames  key-value store that have the list of column
	*/
	public cHistories getSubHistories(IT_Project_Request__History obj, Map<String, String> fieldNames){

			list<cHistories> list_ch = new list<cHistories>();

            cHistories ch = new cHistories();

            ch.theDate = String.valueOf(obj.createddate);

            ch.who = obj.createdby.name;

            if (String.valueOf(obj.Field) == 'created') {

                ch.action = '作成しました。';

            }else if (String.valueOf(obj.Field) != 'locked' && String.valueOf(obj.Field) != 'unlocked'){

                String fromText = getParseValue(String.valueOf(obj.OldValue));
                String toText = getParseValue(String.valueOf(obj.NewValue));

				if('NULL'.equals(fromText) && 'NULL'.equals(toText)){
					ch.action = '<b>' + fieldNames.get(String.valueOf(obj.Field)) + '</b>は　変更されました。';
				}else{
					ch.action = '<b>' + fieldNames.get(String.valueOf(obj.Field)) + '</b>は　' + fromText + 'から　' + toText  + 'に　変更されました。';
				}


          }

		return ch;
	}

//2013.10.02 Satoshi Haga Adding history data End



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


		//Testing
		IT_Project_Request__c req = new IT_Project_Request__c();
		//プロジェクト名
		req.ProjectName__c = 'aaaaaa';
		//優先度
		req.Priority__c = '低';
		//依頼内容
		req.RequestDescription__c = 'bbbbb';
		//理由
		req.ReasonDecription__c = 'cccc';
		//ベネフィット
		req.BenefitDescription__c = 'dddd';
		//希望納期
		req.RequestDate__c = date.today();
		//関連ドキュメント1
		req.Document1__c = 'ffff';
		//関連ドキュメント2
		req.Document2__c = 'gggg';
		//関連ドキュメント3
		req.Document3__c = 'hhhh';
		//関連ドキュメント4
		req.Document4__c = 'iiii';
		//関連ドキュメント5
		req.Document5__c = 'jjjj';
		//関連ドキュメント6
		req.Document6__c = 'kkkk';
		//関連ドキュメント7
		req.Document7__c = 'llll';
		//関連ドキュメント8
		req.Document8__c = 'mmmm';
		//関連ドキュメント9
		req.Document9__c = 'nnnn';
		//関連ドキュメント10
		req.Document10__c = 'oooo';

		//Insert test record
		insert req;

		//Re-load
		ItProjectRequestDao dao = new ItProjectRequestDao('Test');
		IT_Project_Request__c itReq = ((List<IT_Project_Request__c>)dao.getAllColumnData()).get(0);

    	ApexPages.StandardController stdController = new ApexPages.StandardController(itReq);
    	ItRequestExtension extCon = new ItRequestExtension(stdController);
    	extCon.apply();

		System.assert('IT_Project_Request__c'.equals(extCon.strObjectName));
		System.assert(itReq.Comment__c == null);

		//Test for ItProjectRequestTrrigerHandler
		itReq.Comment__c = 'Test Comment';
		itReq.RequestDate__c =itReq.RequestDate__c.addDays(1);
		itReq.RequestDescription__c ='変更後の依頼内容';
		String beforeHistory = itReq.ChangeHistory__c;
		update itReq;

		//Test for change-history
		extCon.id = itReq.Id;
		extCon.getHistories();
		System.assert(itReq.RequestDescription__c == '変更後の依頼内容');


		IT_Project_Request__History obj = new IT_Project_Request__History();


		obj = new IT_Project_Request__History();
		cHistories ret = extCon.getSubHistories(obj, new Map<String, String>());
		System.assert(ret.action.indexOf('変更されました') >= 0);

		String strValue = null;
		String strRet = extCon.getParseValue(strValue);
		System.assert(strRet.indexOf('NULL') >= 0);

		strValue = '2011/10/10';
		strRet = extCon.getParseValue(strValue);
		System.assert(strRet.indexOf('2011/10/10') >= 0);

		strValue = 'ABC';
		strRet = extCon.getParseValue(strValue);
		System.assert(strRet.indexOf('ABC') >= 0);


    }

}