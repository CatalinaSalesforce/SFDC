/*
@Name            : JanRequestExtension
@Author          : Satoshi Haga
@Date            : Oct 15, 2013
@Description     : Extension class for JAN request management
@version         : 10/15/2013 First Creation
*/
public with sharing class JanRequestExtension {

	public ApexPages.StandardController stdController;

	public String strObjectName { get; set; }

    public String strId;
    public list<cHistories> histories;

	/**
	 * Constructor
	 * @param stdController this is gotten by salesforce standard framwwork when accessing each page.
	 */
	public JanRequestExtension(ApexPages.StandardController stdController) {

		strObjectName = stdController.getRecord().getSObjectType().getDescribe().getName();
		strId = apexpages.currentPage().getParameters().get('Id');

		this.stdController = stdController;

	}

	/**
	* Approval Request Method.
	* This method updates existing flag, "AttachedFile__c". Email is triggered by workflow-rule when this flag is updated.
	*  @return PageReference  null value is returned.
	*/
    public PageReference approvalRequest() {

		JanrequestDao dao = new JanrequestDao('JanRequestExtension');
		JAN_CHANGE__c jan = (JAN_CHANGE__c)dao.getAllColumnData(stdController.getRecord().ID);

		if(jan.AttachedFile__c == true){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'承認申請は既に行われています'));
			return null;
		}

		jan.AttachedFile__c = true;
		update jan;

		//Add success message
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'承認申請が正常に行われました'));

        return null;
    }

	/**
	*  Getter Method for history.
	*  @param list<cHistories>  history list
	*/
	public list<cHistories> getHistories() {
        list<cHistories> list_ch = new list<cHistories>();
        list<JAN_CHANGE__History> Histories = new list<JAN_CHANGE__History>();
        Map<String, String> fieldNames = new Map<String, String>();

        Histories = [
            Select ParentId, OldValue, NewValue, IsDeleted, Id, Field, CreatedDate, CreatedById, CreatedBy.Name
            From JAN_CHANGE__History
            where ParentId = :strId order by CreatedDate desc Limit 1000];

        // Get Label Name
        Map<String, Schema.SObjectField> fmap = Schema.SObjectType.JAN_CHANGE__c.fields.getMap();
        for(Schema.sObjectField f : fmap.values()) {
            fieldNames.put(f.getDescribe().getName(),f.getDescribe().getLabel());
        }

        for(JAN_CHANGE__History obj:Histories){
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
	public cHistories getSubHistories(JAN_CHANGE__History obj, Map<String, String> fieldNames){

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

	/**
	 * Test method
	 */
	@isTest(SeeAllData=true)
    public static void unitTest() {

		JanrequestDao dao = new JanrequestDao('Test');
		JAN_CHANGE__c jan = ((List<JAN_CHANGE__c>)dao.getAllColumnData()).get(0);

    	ApexPages.StandardController stdController = new ApexPages.StandardController(jan);
    	JanRequestExtension extCon = new JanRequestExtension(stdController);
    	extCon.approvalRequest();

		JAN_CHANGE__History obj = new JAN_CHANGE__History();


		obj = new JAN_CHANGE__History();
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