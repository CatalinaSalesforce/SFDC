public without sharing class TestUtility {
	
	/*
	Use this method to create Conglomerate for test data. 
	
	@Type : Retail or manufacturing Conglomerate. To be more specific RecordType of Account,
	
	*/
	public Account createConglomerate(String rType){
		 
	 Account ac = new Account(); 
	 ac.Name = 'Test_Conglomerate';
	 ac.Type = 'Conglomerate';
	 ac.RecordTypeId= getRecordTypeId(rType);
	 return  ac;
	}
	public Account createClient(String rType){
	  Account ac = new Account();
	  ac.Name = 'Test_Account';
	  ac.Type = 'Customer';
	  ac.recordTypeId = getRecordTypeId(rType);
	  
	  return ac;
	}
	
	public Opportunity createOpportunity(String rType){
	  
	  Opportunity op = new Opportunity();
	  op.recordTypeId = getRecordTypeId(rType);
	  op.Name = 'Test_Opportunity';
	  
	  return null;
	}
    	
	/*
	Use this method to create Opportunities for test data. Interger parameter passed to this method determines number of opportunities to create. 
	*/
   public void createOpportunities(Integer numOpp){
   	
   	
   
   }
	
	public void createProgramForecast(Integer numPF){
	 List<Program_Forecast__c> pfInsert = new List<Program_Forecast__c>();
	  for(integer i=0;i<=numPF; i++){
	     Program_Forecast__c pf = new Program_Forecast__c();
	  }
	}
	
	public id  getRecordTypeId(string rTypeName){
            
        RecordType rtype = [select id from RecordType where Name=:rTypename];
        return rtype.id; 	
	}
    
       
    public static Catalina_Forecast_Settings__c getCatalinaForecastSettingsRecord(){

    String baseType = 'Base';
    String digitalType = 'Digital O&O';
    String displayType = 'Audience Network';
    String mobileType = 'Mobile';
    String manufacturingType = 'Manufacturing';
    String retailType = 'Retail';
    String coopType = 'coop';
    String SR1Type = 'SR1';
    String SR2Type = 'SR2';
    String SM1Type = 'SM1';
    String SM2Type = 'SM2';
    String pfeEmail = 'fakeemail@myfakeemailplay.com.fake';
    String settingsName = 'Default';
        
        
        Catalina_Forecast_Settings__c settings = new Catalina_Forecast_Settings__c();
        settings.Base_Delivery_Type__c = baseType;
        settings.Digital_Delivery_Type__c = digitalType;
        settings.Display_Delivery_Type__c = displayType;
        settings.Mobile_Delivery_Type__c = mobileType;
        settings.Manufacturing_Account_Type__c = manufacturingType;
        settings.Retail_Account_Type__c = retailType;
        settings.Coop_String__c = coopType;
        settings.Rep_1_String__c = SR1Type;
        settings.Rep_2_String__c = SR2Type;
        settings.SM_1_String__c = SM1Type;
        settings.SM_2_String__c = SM2Type;
        settings.PFE_Email__c = pfeEmail;
        settings.Name = settingsName;
        insert settings;
        return settings;
    }

}