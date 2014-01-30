public with sharing class OppCategoryController {
	
	public MultiSelect mCatSelect {get;set;}
	public String relatedContractRequired {get;set;}
	public Opportunity opp {get;set;}
	private String id;
	Set<Id> catSet;
	
	public oppCategoryController(ApexPages.StandardController sc){
		id = sc.getId();
	}
	
	public PageReference init(){
		String RecoveryID = [SELECT ID FROM RECORDTYPE WHERE NAME = 'Recovery' And SObjectType = 'Opportunity'][0].Id;
		String RenewalID = [SELECT ID FROM RECORDTYPE WHERE NAME = 'Renewal' And SObjectType = 'Opportunity'][0].Id;
		
		this.opp = [SELECT ID, NAME, RecordTypeId, At_Risk_Categories__c, CloseDate, Catalina_Business_Unit__c, 
			StageName, AccountID, Prior_Year_Amount__c, Related_Contract__c, Amount, Probability, Renewal_Comments__c, 
			OwnerId, Opportunity_Owner_Manager__c, Category_Total_Amount__c, Renewal_Rights_Expiry_Date__c, 
			Previous_Year_Amount__c, Renewal_Goal_Amount__c, CATS_External_ID__c,
			At_Risk_Comments__c, Best_Guess__c
			FROM OPPORTUNITY WHERE ID =: id][0];
		if (opp.RecordTypeId != RenewalID && opp.RecordTypeId != RecoveryID){
			return sendToStandardEditPage();
		} else {
			if (opp.RecordTypeId == RenewalID){
				relatedContractRequired = 'true';
			} else if (opp.RecordTypeId == RecoveryID){
				relatedContractRequired = 'false';
			}
			loadPage();
			return null;
		}
	}
	
	private void loadPage(){
		catSet = new Set<Id>();
		List<Opportunity_Category__c> oppCat = [SELECT CATEGORY__C FROM OPPORTUNITY_CATEGORY__C 
			WHERE OPPORTUNITY__C =: id];
		for (Opportunity_Category__c a : oppCat){
			catSet.add(a.Category__c);
		}
		List<Product2> catList = [SELECT ID, NAME FROM PRODUCT2 WHERE ID IN: catSet];
		Set<String> setAllCats = new Set<String>();
		Set<String> setSelectedCats = new Set<String>();
		for (Product2 x : catList){
			setAllcats.add(x.Name);
		}
		if (opp.At_Risk_Categories__c != null){
			for (String str : opp.At_Risk_Categories__c.split(';')){
				setSelectedCats.add(str);
			}
			setAllCats.removeAll(setSelectedCats);
		}
		mCatSelect = new Multiselect(setAllCats, setSelectedCats);
	}
	
	public PageReference sendToStandardEditPage(){
		system.debug('***redirecting');
		PageReference editPage = new PageReference('/' + id + '/e' );
		editPage.getParameters().put('nooverride','1');
		editPage.getParameters().put('retURL',id);
		editPage.setRedirect(true);
		return editPage;
	}
	
	public PageReference save(){
		List<OpportunityStage> oppStages = [Select o.MasterLabel, o.Id, o.DefaultProbability From OpportunityStage o];
		Map<String, Double> oppStageMap = new Map<String, Double>();
		for (OpportunityStage o : oppStages){
			oppStageMap.put(o.MasterLabel, o.DefaultProbability);
		}
		String cats = '';
		for (String str : mCatSelect.rightvalues){
			cats += str + ';';
		}
		if (cats == ''){
			cats = null;
		} else {
			cats = cats.substring(0, cats.length() - 1);
		}
		
		opp.At_Risk_Categories__c = cats;
		opp.Probability = oppStageMap.get(opp.StageName);
		try{
			update opp;
			return new PageReference('/'+ opp.Id);
		} catch (DmlException e){
			system.debug(LoggingLevel.Error, 'Error: ' + e.getMessage());
			return null;
		}
	}

}