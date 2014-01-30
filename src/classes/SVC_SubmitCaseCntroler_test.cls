@isTest()
public with sharing class SVC_SubmitCaseCntroler_test {


   static testmethod void testCustomWebToCase(){
    
        
        PageReference webCasePage = Page.SVC_WebToCaseSubmitPage;
                
        webCasePage.getParameters().put('Fname','Tim');
        webCasePage.getParameters().put('Lname','Jones');
        webCasePage.getParameters().put('email','tim@jones.com');
        webCasePage.getParameters().put('secondaryemail','tim2@jones.com');
        webCasePage.getParameters().put('phone','3323444521');         
        webCasePage.getParameters().put('recordType','Consumer');    
        webCasePage.getParameters().put('ConsumerIPAddress','111.11.1111');
        webCasePage.getParameters().put('SupportSiteReferringURL','www.thinkgeek.com');   
        webCasePage.getParameters().put('subject','Cannot Print Coupon');
        webCasePage.getParameters().put('description','Coupon not displaying to print');
        webCasePage.getParameters().put('reason','Favorite store Found'); 
        
        webCasePage.getParameters().put('PrinterBrand','HP');
        webCasePage.getParameters().put('PrinterModel','POS2000');
        webCasePage.getParameters().put('UserBrowserName','Internet Explorer');
        webCasePage.getParameters().put('UserBrowserVersion','1.2');
        webCasePage.getParameters().put('UserOS','Windows 7');        
        webCasePage.getParameters().put('UserAgent','aaa1');         
        
        webCasePage.getParameters().put('retailer_id','1222');      
        webCasePage.getParameters().put('StoreState','FL'); 
        webCasePage.getParameters().put('chain_id','23242');        
        webCasePage.getParameters().put('StoreName','Shoprite');             
        webCasePage.getParameters().put('StoreAddr','12 main st');             
        webCasePage.getParameters().put('StoreAddr2','apt 122');
        webCasePage.getParameters().put('StoreCity','Clearwater');
        webCasePage.getParameters().put('StoreZip','33762');
        webCasePage.getParameters().put('StoreCountry','usa');
        webCasePage.getParameters().put('StorePhoneNo','324535435'); 
        
        webCasePage.getParameters().put('NoOfCouponsExpected','2');
        webCasePage.getParameters().put('TotalDollarAmtCpExpctd','5');  
        webCasePage.getParameters().put('DescOfCpOffer','Loyalty Card Rewards'); 
        webCasePage.getParameters().put('PromotionName','PromoName1');        
        webCasePage.getParameters().put('LoyaltyCardNo','1234');
        
        webCasePage.getParameters().put('TransactionDateTime','10/14/2011 11:46 AM');  
                  
        webCasePage.getParameters().put('RowOfNumbers','11111');
        webCasePage.getParameters().put('NonConsumerPOC','abc');                 
        webCasePage.getParameters().put('ConsumerAddr','232 deer st');             
        webCasePage.getParameters().put('ConsumerAddr2','apt 11');
        webCasePage.getParameters().put('ConsumerCity','tampa');
        webCasePage.getParameters().put('ConsumerState','FL');
        webCasePage.getParameters().put('ConsumerZip','33706');
        webCasePage.getParameters().put('ConsumerCountry','USA');
             
        webCasePage.getParameters().put('FileUploadPath','htttp://path');   
        webCasePage.getParameters().put('StoreProspectZip','234');
        webCasePage.getParameters().put('StoreProspectName','abc');
             
        webCasePage.getParameters().put('source','test');  
        webCasePage.getParameters().put('medium','test'); 
        webCasePage.getParameters().put('term','test');  
        webCasePage.getParameters().put('content','test'); 
        webCasePage.getParameters().put('campaign','test');  
        webCasePage.getParameters().put('gclid','test'); 
        webCasePage.getParameters().put('addrValidationStatus','Validated');         
        webCasePage.getParameters().put('TotalAmtTransaction','15'); 
        webCasePage.getParameters().put('FavBrands','abcd');      
        webCasePage.getParameters().put('Program','Other'); 
        webCasePage.getParameters().put('CustomProgramName','test'); 
        
        Test.setCurrentPageReference(webCasePage);                
        SVC_SubmitCaseController cc = new SVC_SubmitCaseController();  
        cc.createCase();
        
        Case thecase = [select Id,AccountId,ContactId,CaseNumber,Web_First_Name__c,Web_Last_Name__c,SuppliedName,SuppliedEmail,SuppliedPhone,Subject,Description,Reason,User_Browser__c,
                                User_Operating_System__c,User_Browser_Version__c,User_Agent__c, Store__c,Store_State__c,Chain__c,Store_Phone_Number__c,No_Of_Coupons_expected_for_this_Offer__c,
                                Total_Amount_Coupon_Offer_Expected__c,Description_of_Coupon_Offer__c,Name_Of_Promotion__c,Loyalty_Card_Number__c,Total_Amount_Of_Your_Connections__c,
                                Favorite_Brands__c, Store_Name__c,Store_Address__c,Store_Address2__c, Store_City__c, 
                                Store_Zip_Postal_Code__c,Store_Country__c,Date_Time_of_Transaction__c, Row_Of_Numbers__c, Non_Consumer_POC__c,Consumer_Address__c,
                                Consumer_Address2__c,Consumer_City__c,Consumer_State__c,Consumer_Country__c,Consumer_Zip_Postal_Code__c,File_Upload_Path__c,Store_Prospect_Zip__c,
                                Store_Prospect_Name__c,Cookie_Source__c,Cookie_Medium__c,Cookie_Term__c,Cookie_Content__c,Cookie_Campaign__c,Cookie_Gclid__c,
                                Address_Validation_Status__c,Program__c,Custom_Program_Name__c,Status,RecordTypeId from Case where SuppliedEmail='tim@jones.com' LIMIT 1];
                
        System.assert(theCase.Web_First_Name__c == 'Tim', 'Incorrect Values');
        System.assert(theCase.Web_Last_Name__c == 'Jones', 'Incorrect Values');
        System.assert(theCase.SuppliedName=='Tim Jones', 'Incorrect Values');
        System.assert(theCase.SuppliedEmail=='tim@jones.com', 'Incorrect Values');
        System.assert(theCase.SuppliedPhone =='3323444521', 'Incorrect Values');
        System.assert(theCase.Subject =='Cannot Print Coupon', 'Incorrect Values');
        System.assert(theCase.Description =='Coupon not displaying to print', 'Incorrect Values');
        System.assert(theCase.Reason =='Favorite Store Found', 'Incorrect Values');
        System.assert(theCase.Status =='New', 'Incorrect Values');
        //System.assert(theCase.RecordType == 'Consumer', 'Incorrect Values');
        
        System.assert(theCase.User_Browser__c =='Internet Explorer', 'Incorrect Values');
        System.assert(theCase.User_Browser_Version__c == '1.2', 'Incorrect Values');
        System.assert(theCase.User_Operating_System__c =='Windows 7', 'Incorrect Values');    
        System.assert(theCase.User_Agent__c =='aaa1', 'Incorrect Values');         
        
        System.assert(theCase.Store__c =='1222', 'Incorrect Values');
        System.assert(theCase.Store_State__c =='FL', 'Incorrect Values');
        System.assert(theCase.Chain__c =='23242', 'Incorrect Values');                  
        System.assert(theCase.Store_Name__c == 'Shoprite', 'Incorrect Values');            
        System.assert(theCase.Store_Address__c == '12 main st', 'Incorrect Values');             
        System.assert(theCase.Store_Address2__c == 'apt 122', 'Incorrect Values');
        System.assert(theCase.Store_City__c == 'Clearwater', 'Incorrect Values');
        System.assert(theCase.Store_Zip_Postal_Code__c == '33762', 'Incorrect Values');
        System.assert(theCase.Store_Country__c == 'usa', 'Incorrect Values');       
        System.assert(theCase.Store_Phone_Number__c =='324535435', 'Incorrect Values');
        
        System.assert(theCase.No_Of_Coupons_expected_for_this_Offer__c=='2', 'Incorrect Values');
        System.assert(theCase.Total_Amount_Coupon_Offer_Expected__c=='5', 'Incorrect Values');
        
        System.assert(theCase.Description_of_Coupon_Offer__c =='Loyalty Card Rewards', 'Incorrect Values');
        System.assert(theCase.Name_Of_Promotion__c =='PromoName1', 'Incorrect Values');
        System.assert(theCase.Loyalty_Card_Number__c =='1234', 'Incorrect Values');  
                 
        System.assert(theCase.Date_Time_of_Transaction__c ==DateTime.parse('10/14/2011 11:46 AM'), 'Incorrect Values');
        System.assert(theCase.Row_Of_Numbers__c =='11111', 'Incorrect Values');
        System.assert(theCase.Non_Consumer_POC__c =='abc', 'Incorrect Values');
        System.assert(theCase.Consumer_Address__c =='232 deer st', 'Incorrect Values');
        System.assert(theCase.Consumer_Address2__c =='apt 11', 'Incorrect Values');
        System.assert(theCase.Consumer_City__c =='tampa', 'Incorrect Values');
        System.assert(theCase.Consumer_State__c =='FL', 'Incorrect Values');
        System.assert(theCase.Consumer_Country__c =='USA', 'Incorrect Values');
        System.assert(theCase.Consumer_Zip_Postal_Code__c =='33706', 'Incorrect Values');
                     
        System.assert(theCase.File_Upload_Path__c =='htttp://path', 'Incorrect Values');
        System.assert(theCase.Store_Prospect_Zip__c =='234', 'Incorrect Values');
        System.assert(theCase.Store_Prospect_Name__c =='abc', 'Incorrect Values');     
       
        System.assert(theCase.Cookie_Source__c =='test', 'Incorrect Values');
        System.assert(theCase.Cookie_Medium__c =='test', 'Incorrect Values');
        System.assert(theCase.Cookie_Term__c =='test', 'Incorrect Values');
        System.assert(theCase.Cookie_Content__c =='test', 'Incorrect Values');
        System.assert(theCase.Cookie_Campaign__c =='test', 'Incorrect Values');
        System.assert(theCase.Cookie_Gclid__c =='test', 'Incorrect Values');
        System.assert(theCase.Address_Validation_Status__c =='Validated', 'Incorrect Values');
        
        System.assert(theCase.Total_Amount_Of_Your_Connections__c ==15, 'Incorrect Values');
        System.assert(theCase.Favorite_Brands__c=='abcd', 'Incorrect Values');        
        
        System.assert(theCase.Program__c == 'Other', 'Incorrect Values');
        System.assert(theCase.Custom_Program_Name__c =='test', 'Incorrect Values');
        
        System.assert(cc.strCaseId == theCase.CaseNumber, 'Case number not being populated');
        
        
        Account theAcct = [select Id,FirstName,LastName,personEmail from Account where personEmail='tim@jones.com' LIMIT 1];
        System.assert(theAcct.FirstName == 'Tim', 'Incorrect Values');
        System.assert(theAcct.LastName == 'Jones', 'Incorrect Values');
        System.assert(theAcct.personEmail == 'tim@jones.com', 'Incorrect Values');
       
        System.assert(theCase.AccountId==theAcct.Id, 'Account not assigned');
        
        Contact theContact = [select Id,FirstName,LastName from Contact where AccountId=:theAcct.Id LIMIT 1];
        System.assert(theCase.ContactId==theContact.Id, 'Contact not assigned');     
        
        
        PageReference anotherPage = Page.SVC_WebToCaseSubmitPage;
                
        anotherPage.getParameters().put('Fname','Tim');
        anotherPage.getParameters().put('Lname','');
        anotherPage.getParameters().put('email','tim@jones.com');
        anotherPage.getParameters().put('phone','3323444521'); 
        
        anotherPage.getParameters().put('subject','Cannot Print Coupon');
        anotherPage.getParameters().put('description','Coupon not displaying to print');
        anotherPage.getParameters().put('reason','Favorite store Found'); 
        anotherPage.getParameters().put('recordType','Retailer');
        
        anotherPage.getParameters().put('NoOfCouponsExpected','2');
        anotherPage.getParameters().put('TotalDollarAmtCpExpctd','5');
        anotherPage.getParameters().put('addrValidationStatus','Validated');         
        anotherPage.getParameters().put('TotalAmtTransaction','15'); 
        
        Test.setCurrentPageReference(anotherPage);                
        SVC_SubmitCaseController anothercc = new SVC_SubmitCaseController();  
        anothercc.createCase();
        
    }
}