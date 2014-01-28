public class SVC_SubmitCaseController {
  
    public String strCaseId     { get; set; }
    public String strError      { get; set; }
    private final Case webCase  { get; set; }
    
    public SVC_SubmitCaseController() {
        webCase = new Case(Status = 'New', Origin = 'Web', ConsumerCase__c = true);
    }  
        
    public void parseCaseParams(){
         
        // Parse the parameters and fill it into the newly created case.
        try{        
             webCase.Web_First_Name__c = ApexPages.currentPage().getParameters().get('Fname');
             webCase.Web_Last_Name__c = ApexPages.currentPage().getParameters().get('Lname');
             webCase.SuppliedName = webCase.Web_First_Name__c + ' ' + webCase.Web_Last_Name__c;     
             webCase.SuppliedEmail = ApexPages.currentPage().getParameters().get('email');  
             webCase.SuppliedPhone = ApexPages.currentPage().getParameters().get('phone');
             webCase.Secondary_Email__c = ApexPages.currentPage().getParameters().get('SecondaryEmail');              
             webCase.Subject = ApexPages.currentPage().getParameters().get('subject');
             webCase.Description = ApexPages.currentPage().getParameters().get('Description');
             webCase.Reason = ApexPages.currentPage().getParameters().get('reason'); 
             
             webCase.User_Browser__c = ApexPages.currentPage().getParameters().get('UserBrowserName');
             webCase.User_Browser_Version__c = ApexPages.currentPage().getParameters().get('UserBrowserVersion');
             webCase.User_Operating_System__c = ApexPages.currentPage().getParameters().get('UserOS'); 
             webCase.User_Agent__c = ApexPages.currentPage().getParameters().get('UserAgent'); 
             webCase.Model_of_Printer__c = ApexPages.currentPage().getParameters().get('PrinterModel'); 
             webCase.Brand_of_Printer__c = ApexPages.currentPage().getParameters().get('PrinterBrand');              
             webCase.Consumer_IP_Address__c = ApexPages.currentPage().getParameters().get('ConsumerIPAddress'); 
             webCase.Support_Site_Referring_URL__c = ApexPages.currentPage().getParameters().get('SupportSiteReferringURL');
                           
             webCase.Store__c = ApexPages.currentPage().getParameters().get('retailer_id');
             webCase.Store_State__c = ApexPages.currentPage().getParameters().get('StoreState');
             webCase.Chain__c = ApexPages.currentPage().getParameters().get('chain_id');   
             webCase.Store_Name__c = ApexPages.currentPage().getParameters().get('StoreName'); 
             webCase.Store_Address__c = ApexPages.currentPage().getParameters().get('StoreAddr');    
             webCase.Store_Address2__c = ApexPages.currentPage().getParameters().get('StoreAddr2');
             webCase.Store_City__c = ApexPages.currentPage().getParameters().get('StoreCity');
             webCase.Store_Zip_Postal_Code__c = ApexPages.currentPage().getParameters().get('StoreZip');
             webCase.Store_Country__c = ApexPages.currentPage().getParameters().get('StoreCountry');
             webCase.Store_Phone_Number__c = ApexPages.currentPage().getParameters().get('StorePhoneNo');
             
             webCase.No_Of_Coupons_expected_for_this_Offer__c = ApexPages.currentPage().getParameters().get('NoOfCouponsExpected');
             webCase.Total_Amount_Coupon_Offer_Expected__c = ApexPages.currentPage().getParameters().get('TotalDollarAmtCpExpctd');
             webCase.Description_of_Coupon_Offer__c = ApexPages.currentPage().getParameters().get('DescOfCpOffer');
             webCase.Name_Of_Promotion__c = ApexPages.currentPage().getParameters().get('PromotionName');
             webCase.Loyalty_Card_Number__c = ApexPages.currentPage().getParameters().get('LoyaltyCardNo');             
                
             webCase.Row_Of_Numbers__c = ApexPages.currentPage().getParameters().get('RowOfNumbers');
             webCase.Non_Consumer_POC__c = ApexPages.currentPage().getParameters().get('NonConsumerPOC'); 
             webCase.Consumer_Address__c = ApexPages.currentPage().getParameters().get('ConsumerAddr');    
             webCase.Consumer_Address2__c = ApexPages.currentPage().getParameters().get('ConsumerAddr2');
             webCase.Consumer_City__c = ApexPages.currentPage().getParameters().get('ConsumerCity');
             webCase.Consumer_State__c = ApexPages.currentPage().getParameters().get('ConsumerState');
             webCase.Consumer_Zip_Postal_Code__c = ApexPages.currentPage().getParameters().get('ConsumerZip');
             webCase.Consumer_Country__c = ApexPages.currentPage().getParameters().get('ConsumerCountry');
             
             webCase.File_Upload_Path__c = ApexPages.currentPage().getParameters().get('FileUploadPath');   
             webCase.Store_Prospect_Name__c = ApexPages.currentPage().getParameters().get('StoreProspectName');
             webCase.Store_Prospect_Zip__c = ApexPages.currentPage().getParameters().get('StoreProspectZip');             
             webCase.Cookie_Source__c = ApexPages.currentPage().getParameters().get('source');  
             webCase.Cookie_Medium__c = ApexPages.currentPage().getParameters().get('medium'); 
             webCase.Cookie_Term__c = ApexPages.currentPage().getParameters().get('term'); 
             webCase.Cookie_Content__c = ApexPages.currentPage().getParameters().get('content'); 
             webCase.Cookie_Campaign__c = ApexPages.currentPage().getParameters().get('campaign'); 
             webCase.Cookie_Gclid__c = ApexPages.currentPage().getParameters().get('gclid'); 
             webCase.Address_Validation_Status__c = ApexPages.currentPage().getParameters().get('addrValidationStatus'); 
                          
             webCase.Favorite_Brands__c = ApexPages.currentPage().getParameters().get('FavBrands');
    
             webCase.Program__c = ApexPages.currentPage().getParameters().get('Program');
             webCase.Custom_Program_Name__c = ApexPages.currentPage().getParameters().get('CustomProgramName');
             webCase.Flagged_IP_Address__c = ApexPages.currentPage().getParameters().get('FlaggedIPAddress');
         }
         catch(Exception ex){
             strError += 'Invalid values ';
         } 
    }     
    
    public void parseCaseRecordType(){
        try{
            String strRecType = ApexPages.currentPage().getParameters().get('recordtype');
            if((strRecType != NULL) && (strRecType.Length() > 0)){
                RecordType rt = [select Id,Name from RecordType where Name = :strRecType and SobjectType = 'Case' LIMIT 1];
                webCase.RecordTypeId = rt.Id;
                                
                // If Case is submitted on behalf of retailer, set the status to escalated.
                if(strRecType == 'Retailer')
                    webCase.Status = 'Escalated';
            }              
        }
        catch(Exception ex){
            strError += 'Invalid Record Type ';
        } 
    }
    
    public void parseCaseDateTime(){
        try{
             string strTemp = ApexPages.currentPage().getParameters().get('TransactionDateTime');
             if((strTemp != NULL) && (strTemp.Length() > 0))
                 webCase.Date_Time_of_Transaction__c = DateTime.parse(ApexPages.currentPage().getParameters().get('TransactionDateTime'));             
        }
        catch(Exception ex){
            strError += 'Invalid Transaction Date Time Format ';
        }     
    }    
    
    public void setFlaggedIP(){
        try{
             string consumerIP = ApexPages.currentPage().getParameters().get('ConsumerIPAddress');
             Flagged_IP_Address__c flaggedIP = [SELECT id, name from Flagged_IP_Address__c WHERE name = :consumerIP];
             if((consumerIP != NULL) && (consumerIP.Length() > 0))
                 webCase.Flagged_IP_Address__c = flaggedIP.Id;             
        }
        catch(Exception ex){
            strError += 'Error setting Flagged IP ';
        }     
    }    

    
    public void parseCaseTotalAmtTransaction(){
        try{       
             string strTemp = ApexPages.currentPage().getParameters().get('TotalAmtTransaction');    
             if((strTemp != NULL) && (strTemp.Length() > 0))
                 webCase.Total_Amount_Of_Your_Connections__c = Decimal.valueOf(ApexPages.currentPage().getParameters().get('TotalAmtTransaction'));
        }
        catch(Exception ex){
            strError += 'Invalid Total Amount of Transaction ';
        }
    }
    
    public PageReference createCase() {
    
        Account personAcct;
        Case    dmlCase;     
        integer iCount = 0;       
        
        // Parse case params.          
        parseCaseParams();
        parseCaseRecordType();
        parseCaseDateTime();
        parseCaseTotalAmtTransaction();
                          
        
        try{
            //Fetching the assignment rules on case
            AssignmentRule AR = new AssignmentRule();
            AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
            
            //Creating the DMLOptions for "Assign using active assignment rules" checkbox
            Database.DMLOptions dmlOpts = new Database.DMLOptions();
            dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
         
             webCase.setOptions(dmlOpts);
        }
        catch(Exception ex){
            System.debug('No assignment rule to assign.');
        }
        
         //Insert the case and retrieve it from the Database to get the generated Case Number.         
         try{     
            
             insert webCase;             
             dmlCase = [Select id,CaseNumber from Case where Id = :webCase.Id LIMIT 1];
             
             // Create a person Account from the case.
             iCount = [Select count() from Account where personEmail = : webCase.SuppliedEmail];
             if(iCount == 0){
                 personAcct = new Account();            
                 personAcct.recordTypeId = [Select Id From RecordType where Name = 'Consumer' and sObjectType = 'Account' LIMIT 1].Id;  
                 personAcct.personEmail = webCase.SuppliedEmail;  
                 personAcct.FirstName = webCase.Web_First_Name__c;
                 if(webCase.Web_Last_Name__c != '')
                     personAcct.LastName = webCase.Web_Last_Name__c;    
                 else
                     personAcct.LastName = webCase.Web_First_Name__c;      
                 insert personAcct;                  
             }
             else
                 personAcct = [Select Id,personContactId from Account where personEmail = : webCase.SuppliedEmail Limit 1];
             
             //Attach account details to the Case.
             webCase.AccountId = personAcct.Id;
             
             //Attach contact details to the case.
             Contact personCt = [Select Id,Name,FirstName, LastName, Phone, Email from Contact where AccountId = :personAcct.Id Limit 1];
             webCase.Contact = personCt;
             webCase.ContactId = personCt.Id;
             update webCase;
         }
         catch(Exception ex){
             if(dmlCase == NULL) 
                 strError += 'Could not create case';
             else
                 strError += 'Error creating and linking Person Accounts';   
         }        
                 
         if(dmlCase !=NULL)  {
             strCaseId = dmlCase.CaseNumber;             
             System.debug('Case id is - ' + dmlCase.CaseNumber + '  Error is ' + strError );
         }    
              
         // Redirect to the modified URL.    
         PageReference pageRef = Page.SVC_WebToCaseSubmitPage;
         pageRef.setRedirect(false);
         return pageRef;
    }    
 
}