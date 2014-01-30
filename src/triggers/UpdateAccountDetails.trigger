trigger UpdateAccountDetails on Account (before insert, before update) {
    
    final static String defaultSettingsName = 'Default';
    
    String rep2Type;
    String rep1Type;
    String SM2Type;
    String SM1Type;
    String coopType;
    String cbuName;
    Map<Id, User> SR2 = New Map<Id, User>();
    Map<Id, User> SR1 = New Map<Id, User>();
    Map<Id, User> SM2 = New Map<Id, User>();
    Map<Id, User> SM1 = New Map<Id, User>();
    
    Catalina_Forecast_Settings__c settings = Catalina_Forecast_Settings__c.getInstance(defaultSettingsName);
    if (settings != null){
        rep2Type = settings.Rep_2_String__c;
        rep1Type = settings.Rep_1_String__c;
        SM2Type = settings.SM_2_String__c;
        SM1Type = settings.SM_1_String__c;
        coopType = settings.Coop_String__c;
    }
    
    List<User> users = [SELECT Id, Forecast_Role__c, ManagerId From User Where Forecast_Role__c != NULL And ManagerID  != NULL ];
    //Mar 14 2013
    for (User u : users){
        Boolean isForecasting = false;
        if (u.Forecast_Role__c == rep2Type){
            SR2.put(u.Id, u);
            isForecasting = true;
        } else if (u.Forecast_Role__c == rep1Type){
            SR1.put(u.Id, u);
            isForecasting = true;
        } if (u.Forecast_Role__c == SM2Type){
            SM2.put(u.Id, u);
            isForecasting = true;
        } else if (u.Forecast_Role__c == SM1Type || u.Forecast_Role__c == coopType){
            SM1.put(u.Id, u);
            isForecasting = true;
        }
    }
        
        
    
    for(Account e : trigger.new){ 
        e.Sales_Rep_2__c = null;
        e.Sales_Rep_1__c = null;
        e.Sales_Manager_2__c = null;
        e.Sales_Manager_1__c = null;
        e.EVP__c = null;
        
        if (SR2.containsKey(e.OwnerId)){
            e.Sales_Rep_2__c = e.OwnerId;
            e.Sales_Rep_1__c = SR2.get(e.OwnerId).ManagerId;
            if (e.Sales_Rep_1__c != null){
                if (SR1.containsKey(e.Sales_Rep_1__c)){
                    e.Sales_Manager_2__c = SR1.get(e.Sales_Rep_1__c).ManagerId;
                } else {
                    e.Sales_Manager_2__c = e.Sales_Rep_1__c;
                }
            }
            if (e.Sales_Manager_2__c != null){
                if (SM2.containsKey(e.Sales_Manager_2__c)){
                    e.Sales_Manager_1__c = SM2.get(e.Sales_Manager_2__c).ManagerId;
                } else {
                    e.Sales_Manager_1__c = e.Sales_Manager_2__c;
                }
            }
            if (e.Sales_Manager_1__c != null){
                if (SM1.containsKey(e.Sales_Manager_1__c)){
                    e.EVP__c = SM1.get(e.Sales_Manager_1__c).ManagerId;
                } else {
                    e.EVP__c = e.Sales_Manager_1__c;
                }
            }
        } else if (SR1.containsKey(e.OwnerId)){
            e.Sales_Rep_1__c = e.OwnerId;
            e.Sales_Manager_2__c = SR1.get(e.Sales_Rep_1__c).ManagerId;
            if (e.Sales_Manager_2__c != null){
                if (SM2.containsKey(e.Sales_Manager_2__c)){
                    e.Sales_Manager_1__c = SM2.get(e.Sales_Manager_2__c).ManagerId;
                } else {
                    e.Sales_Manager_1__c = e.Sales_Manager_2__c;
                }
            }
            if (e.Sales_Manager_1__c != null){
                if (SM1.containsKey(e.Sales_Manager_1__c)){
                    e.EVP__c = SM1.get(e.Sales_Manager_1__c).ManagerId;
                } else {
                    e.EVP__c = e.Sales_Manager_1__c;
                }
            }
        } else if (SM2.containsKey(e.OwnerId)){
            e.Sales_Manager_2__c = e.OwnerId;
            e.Sales_Manager_1__c = SM2.get(e.Sales_Manager_2__c).ManagerId;
            if (e.Sales_Manager_1__c != null){
                if (SM1.containsKey(e.Sales_Manager_1__c)){
                    e.EVP__c = SM1.get(e.Sales_Manager_1__c).ManagerId;
                } else {
                    e.EVP__c = e.Sales_Manager_1__c;
                }
            }
        } else if (SM1.containsKey(e.OwnerId)){
            e.Sales_Manager_1__c = e.OwnerId;
            e.EVP__c = SM1.get(e.Sales_Manager_1__c).ManagerId;
        }
    } 
}