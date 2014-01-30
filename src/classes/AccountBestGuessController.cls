/*
@Name           : AccountBestGuessController
@Author         : customersuccess@cloud62.com
@Date           : 5/30/2012
@Description    : Controller for BestGuess
*/
public with sharing class AccountBestGuessController{
    //Variables
    public String gstrManufacturer {get;set;}
    public String gstrRetail {get;set;}
    public String gstrSave {get;set;}
    public String gstrGuessId {get;set;}
    public String gstrUserId {get;set;}
    public String gstrSectionType {get;set;}
    public Boolean isManufacturer {get;set;}
    public String gstrAccountId {get;set;}
    public Account_Best_Guess__c gabg {get;set;}
    public Boolean displayData {get;set;}
    
    //Constructor
    public AccountBestGuessController(){
        gstrSectionType = 'Manufacturer';
        isManufacturer = true;
        displayData = false;
    }
    
    //Create the strings to populate the grids
    private void createDataStringsFromAccountGuess(){
        //String for Manufacturer grid  
        gstrManufacturer = '[{rowName:"Base"';
        if(gabg.Manufacturing_Base_Low__c != null){gstrManufacturer += ',low:"' + gabg.Manufacturing_Base_Low__c + '"';}
        if(gabg.Manufacturing_Base_Best_Guess__c != null){gstrManufacturer += ',bestGuess:"' + gabg.Manufacturing_Base_Best_Guess__c + '"';}
        if(gabg.Manufacturing_Base_High__c != null){gstrManufacturer += ',high:"' + gabg.Manufacturing_Base_High__c + '"';}
        gstrManufacturer += '},';
                            
        gstrManufacturer += '{rowName:"Digital - O&O"';
        if(gabg.Manufacturing_Digital_Low__c != null){gstrManufacturer += ',low:"' + gabg.Manufacturing_Digital_Low__c + '"';}
        if(gabg.Manufacturing_Digital_Best_Guess__c != null){gstrManufacturer += ',bestGuess:"' + gabg.Manufacturing_Digital_Best_Guess__c + '"';}
        if(gabg.Manufacturing_Digital_High__c != null){gstrManufacturer += ',high:"' + gabg.Manufacturing_Digital_High__c + '"';}
        gstrManufacturer += '},';
        
        gstrManufacturer += '{rowName:"Audience Network"';
        if(gabg.Manufacturing_Audience_Low__c != null){gstrManufacturer += ',low:"' + gabg.Manufacturing_Audience_Low__c + '"';}
        if(gabg.Manufacturing_Audience_Best_Guess__c != null){gstrManufacturer += ',bestGuess:"' + gabg.Manufacturing_Audience_Best_Guess__c + '"';}
        if(gabg.Manufacturing_Audience_High__c != null){gstrManufacturer += ',high:"' + gabg.Manufacturing_Audience_High__c + '"';}
        gstrManufacturer += '},';   
                            
        gstrManufacturer += '{rowName:"Mobile"';
        if(gabg.Manufacturing_Mobile_Low__c != null){gstrManufacturer += ',low:"' + gabg.Manufacturing_Mobile_Low__c + '"';}
        if(gabg.Manufacturing_Mobile_Best_Guess__c != null){gstrManufacturer  += ',bestGuess:"' + gabg.Manufacturing_Mobile_Best_Guess__c + '"';}
        if(gabg.Manufacturing_Mobile_High__c != null){gstrManufacturer += ',high:"' + gabg.Manufacturing_Mobile_High__c + '"';}
        gstrManufacturer += '}]';  
        
        //String for Retail grid  
        gstrRetail = '[{rowName:"Base"';
        if(gabg.Retail_Base_Low__c != null){gstrRetail += ',low:"' + gabg.Retail_Base_Low__c + '"';}
        if(gabg.Retail_Base_Best_Guess__c != null){gstrRetail += ',bestGuess:"' + gabg.Retail_Base_Best_Guess__c + '"';}
        if(gabg.Retail_Base_High__c != null){gstrRetail += ',high:"' + gabg.Retail_Base_High__c + '"';}
        gstrRetail += '},';
                            
        gstrRetail += '{rowName:"Digital - O&O"';
        if(gabg.Retail_Digital_Low__c != null){gstrRetail += ',low:"' + gabg.Retail_Digital_Low__c + '"';}
        if(gabg.Retail_Digital_Best_Guess__c != null){gstrRetail += ',bestGuess:"' + gabg.Retail_Digital_Best_Guess__c + '"';}
        if(gabg.Retail_Digital_High__c != null){gstrRetail += ',high:"' + gabg.Retail_Digital_High__c + '"';}
        gstrRetail += '},';
        
        gstrRetail += '{rowName:"Audience Network"';
        if(gabg.Retail_Audience_Low__c != null){gstrRetail += ',low:"' + gabg.Retail_Audience_Low__c + '"';}
        if(gabg.Retail_Audience_Best_Guess__c != null){gstrRetail += ',bestGuess:"' + gabg.Retail_Audience_Best_Guess__c + '"';}
        if(gabg.Retail_Audience_High__c != null){gstrRetail += ',high:"' + gabg.Retail_Audience_High__c + '"';}
        gstrRetail += '},';   
                            
        gstrRetail += '{rowName:"Mobile"';
        if(gabg.Retail_Mobile_Low__c != null){gstrRetail += ',low:"' + gabg.Retail_Mobile_Low__c + '"';}
        if(gabg.Retail_Mobile_Best_Guess__c != null){gstrRetail += ',bestGuess:"' + gabg.Retail_Mobile_Best_Guess__c + '"';}
        if(gabg.Retail_Mobile_High__c != null){gstrRetail += ',high:"' + gabg.Retail_Mobile_High__c + '"';}
        gstrRetail += '}]';
    }
    
    //Set the section type
    public void setSectionType(){
        if(gstrSectionType == 'Manufacturer'){
            isManufacturer = true;
        } else {
            isManufacturer = false;
        }
    }
    
    //Get the selection types
    public List<SelectOption> getSectionTypes(){
        List<SelectOption> lstReturn = new List<SelectOption>();
        lstReturn.add(new SelectOption('Manufacturer','Manufacturer'));
        lstReturn.add(new SelectOption('Retail','Retail'));
        return lstReturn;
    }
    
    //Get all of the Accounts for the Account best guesses the current user has access to
    public List<SelectOption> getAccounts(){
        List<Account_Best_Guess__c> lstAbg = [SELECT Id, Name, Account__c FROM Account_Best_Guess__c];
        Set<Id> setAccIds = new Set<Id>();
        for(Account_Best_Guess__c abg : lstAbg){
            setAccIds.add(abg.Account__c);
        }
        List<SelectOption> lstReturn = new List<SelectOption>();
        List<Account> lstAcc = [SELECT Id, Name  
                                    FROM Account
                                    WHERE Id IN :setAccIds
                                    Order By Name ASC 
                                    LIMIT 999];
        
        lstReturn.add(new SelectOption('null','--None--'));
        for(Account acc : lstAcc){
            lstReturn.add(new SelectOption(acc.Id, acc.Name));
        }
        return lstReturn;
    } 
    
    //Save the updated values in the grid
    public void saveBestGuess(){
        if(gstrSave != null){
            String[] sarrSave = gstrSave.split(':');
            //Set the values based on the indexes
            if(gstrSectionType == 'Manufacturer'){
                gabg.Manufacturing_Audience_Best_Guess__c = Decimal.valueOf(sarrSave[14]);
                gabg.Manufacturing_Audience_High__c = Decimal.valueOf(sarrSave[16]);
                gabg.Manufacturing_Audience_Low__c = Decimal.valueOf(sarrSave[12]);
                gabg.Manufacturing_Base_Best_Guess__c = Decimal.valueOf(sarrSave[2]);
                gabg.Manufacturing_Base_High__c = Decimal.valueOf(sarrSave[4]);
                gabg.Manufacturing_Base_Low__c = Decimal.valueOf(sarrSave[0]);
                gabg.Manufacturing_Digital_Best_Guess__c = Decimal.valueOf(sarrSave[8]);
                gabg.Manufacturing_Digital_High__c = Decimal.valueOf(sarrSave[10]);
                gabg.Manufacturing_Digital_Low__c = Decimal.valueOf(sarrSave[6]);
                gabg.Manufacturing_Mobile_Best_Guess__c = Decimal.valueOf(sarrSave[20]);
                gabg.Manufacturing_Mobile_High__c = Decimal.valueOf(sarrSave[22]);
                gabg.Manufacturing_Mobile_Low__c = Decimal.valueOf(sarrSave[18]);
            } else {
                gabg.Retail_Audience_Best_Guess__c = Decimal.valueOf(sarrSave[15]);
                gabg.Retail_Audience_High__c = Decimal.valueOf(sarrSave[17]);
                gabg.Retail_Audience_Low__c = Decimal.valueOf(sarrSave[13]);
                gabg.Retail_Base_Best_Guess__c = Decimal.valueOf(sarrSave[3]);
                gabg.Retail_Base_High__c = Decimal.valueOf(sarrSave[5]);
                gabg.Retail_Base_Low__c = Decimal.valueOf(sarrSave[1]);
                gabg.Retail_Digital_Best_Guess__c = Decimal.valueOf(sarrSave[9]);
                gabg.Retail_Digital_High__c = Decimal.valueOf(sarrSave[11]);
                gabg.Retail_Digital_Low__c = Decimal.valueOf(sarrSave[7]);
                gabg.Retail_Mobile_Best_Guess__c = Decimal.valueOf(sarrSave[21]);
                gabg.Retail_Mobile_High__c = Decimal.valueOf(sarrSave[23]);
                gabg.Retail_Mobile_Low__c = Decimal.valueOf(sarrSave[19]);
            }
            update gabg;
            setBestGuessRecord();
        }
    }
    
    //Reset the search fields
    public void resetSearch(){
        gstrUserId = 'null';
        gstrGuessId = 'null';
        gstrSectionType = 'Manufacturer';
        displayData = false;
    }
    
    //Get the quarters for the selected account
    public List<SelectOption> getQuarters(){
        List<SelectOption> lstReturn = new List<SelectOption>();
        
        List<Account_Best_Guess__c> lstAbg = [SELECT Id, Name, Quarter__c  
                                                        FROM Account_Best_Guess__c 
                                                        WHERE Account__c = :gstrAccountId 
                                                        Order By Quarter_Start_Date__c ASC];
        
        lstReturn.add(new SelectOption('null','--None--'));
        for(Account_Best_Guess__c abg : lstAbg){
            if(abg.Quarter__c != null){
                lstReturn.add(new SelectOption(abg.id, abg.Quarter__c));
            }
        }
        return lstReturn;
    }
    
    //Set the best guess record to use
    public void setBestGuessRecord(){
        if(gstrGuessId != 'null'){
           List<Schema.SObjectField> lstFields = getFields('Account_Best_Guess__c');
           String strAbgFields = '';
           for(Integer i = 0; i < lstFields.size(); i++){
               if(i == lstFields.size() - 1){
                   strAbgFields += lstFields.get(i).getDescribe().LocalName;
               } else {
                   strAbgFields += lstFields.get(i).getDescribe().LocalName + ',';
               }
           } 
           String strQuery = 'Select ' + strAbgFields + ' FROM Account_Best_Guess__c WHERE Id = \'' + gstrGuessId + '\'';
           gabg = Database.query(strQuery);
           createDataStringsFromAccountGuess();
           displayData = true;
        } 
    }
    
    //Returns the list of fields for a given object
    public static List<Schema.SObjectField> getFields(String strSObjectName) {
        SObjectType sot = Schema.getGlobalDescribe().get(strSObjectName);
        if (sot == null) return null;
   
        List<Schema.SObjectField> fields = sot.getDescribe().fields.getMap().values();
        return fields;
    }
}