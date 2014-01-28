public with sharing class DE_Estimator_Controller{
    @TestVisible
    private final DE_Estimator__c        estimator;
    public List<DE_Estimate__c>          estimatesList{get;set;}
    public Id                            delEstimateId {get; set;}
    
    
    public DE_Estimator_Controller(ApexPages.StandardController stdController) {
        estimator = (DE_Estimator__c)stdController.getRecord();
        
        // If the estimator exists already, populate the estimates list to contain its estimates.
        try {
            estimatesList = [SELECT id,Redemptions__c,Distribution_Cost__c,Redemption_Cost__c,Program_Cost__c,Units_Moved__c, CPUM__c,     
                             Estimator__c,Total_Est_Loads_Over_Program_Duration__c,Total_Est_Prints_Over_Program_Duration__c,OfferTypePrintOrL2C__c From DE_Estimate__c where Estimator__c = :estimator.id ];
        } 
        catch (exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR , 'No Estimates found'));
        }             
    }
    
    
    public void VFUpdatePrintOffType(){    
    
        // Called from VF page - Control Printable checkbox behavior on other features.    
        if(estimator.OffType_Printable__c){        
            // If Printable checkbox is chosen on the new/edit page, disable customize options. 
            estimator.IsOfferCustomized__c = false;
            estimator.Cust_Offer_Type__c = '';
            
            if(!estimator.OffType_L2C__c){
                if(estimator.Distribution_Cost_Per_Load__c != NULL)
                    estimator.Distribution_Cost_Per_Load__c = 0;     
                if(estimator.L2C_Estimated_Redemption__c != NULL)
                    estimator.L2C_Estimated_Redemption__c = 0;
                if(estimator.L2C_Handling_Fee__c != NULL)
                    estimator.L2C_Handling_Fee__c = 0;   
            }
        }
        else{ // If Printable checkbox is unchecked, set the Printable pricing values to zero if they have already been set, ie called from edit. 
            if(estimator.Distribution_Cost_Per_Print__c != NULL)
                estimator.Distribution_Cost_Per_Print__c = 0;     
            if(estimator.Estimated_Redemption__c != NULL)
                estimator.Estimated_Redemption__c = 0;
            if(estimator.Handling_Fee__c != NULL)
                estimator.Handling_Fee__c = 0;                 
            estimator.AddOns__c = '';
            estimator.Add_SetUp_Fees__c = false;
        }
        
        System.debug('Estimator was switched on - ' + estimator.OffType_Printable__c);
        System.debug('Custom offer type status is - ' + estimator.IsOfferCustomized__c);
    }
    
    public void VFUpdateL2COffType(){    
        
        // Called from VF page - Control L2C checkbox behavior on other features.
        if(estimator.OffType_L2C__c){   
            // If L2C checkbox is chosen on the new/edit page, disable customize options. 
            estimator.IsOfferCustomized__c = false;
            estimator.Cust_Offer_Type__c = '';
            
            if(!estimator.OffType_Printable__c){
                if(estimator.Distribution_Cost_Per_Print__c != NULL)
                    estimator.Distribution_Cost_Per_Print__c = 0;     
                if(estimator.Estimated_Redemption__c != NULL)
                    estimator.Estimated_Redemption__c = 0;
                if(estimator.Handling_Fee__c != NULL)
                    estimator.Handling_Fee__c = 0;                 
                estimator.AddOns__c = '';
                estimator.Add_SetUp_Fees__c = false;
            }
        }
        else{ // If L2C checkbox is unchecked, set the L2C pricing values to zero if they have already been set, ie called from edit. 
            if(estimator.Distribution_Cost_Per_Load__c != NULL)
                estimator.Distribution_Cost_Per_Load__c = 0; 
            if(estimator.L2C_Estimated_Redemption__c != NULL)
                estimator.L2C_Estimated_Redemption__c = 0;
            if(estimator.L2C_Handling_Fee__c != NULL)
                estimator.L2C_Handling_Fee__c = 0; 
        }
    }
    
    public void VFUpdateCustOffType(){
    
        // Called from VF page - If customize button is pressed, disable Printable and L2C Checkboxes.
        estimator.OffType_Printable__c = false;
        estimator.OffType_L2C__c = false;        
        estimator.IsOfferCustomized__c = true;
        
        // Also set Printable and L2C pricing to zero if they already contained values. 
        if(estimator.Distribution_Cost_Per_Print__c != NULL)
            estimator.Distribution_Cost_Per_Print__c = 0;  
        if(estimator.Estimated_Redemption__c != NULL)
            estimator.Estimated_Redemption__c = 0;  
        if(estimator.Handling_Fee__c != NULL)
            estimator.Handling_Fee__c = 0;  
        if(estimator.Distribution_Cost_Per_Load__c != NULL)
            estimator.Distribution_Cost_Per_Load__c = 0;    
        if(estimator.L2C_Estimated_Redemption__c != NULL)
            estimator.L2C_Estimated_Redemption__c = 0;
        if(estimator.L2C_Handling_Fee__c != NULL)
            estimator.L2C_Handling_Fee__c = 0; 
        estimator.AddOns__c = '';  
        estimator.Add_SetUp_Fees__c = false;      
    }
        
    public void VFUpdateCustPrintOrL2C(){
     
        // Called from VF page - When user selects a customized offerType. 
        if((estimator.IsOfferCustomized__c) && (estimator.Cust_Offer_Type__c != NULL)){
            if(estimator.Cust_Offer_Type__c.contains('Printable') == false){
                if(estimator.Distribution_Cost_Per_Print__c != NULL)
                    estimator.Distribution_Cost_Per_Print__c = 0;  
                if(estimator.Estimated_Redemption__c != NULL)
                    estimator.Estimated_Redemption__c = 0;  
                if(estimator.Handling_Fee__c != NULL)
                    estimator.Handling_Fee__c = 0;                  
                estimator.AddOns__c = '';      
                estimator.Add_SetUp_Fees__c = false;     
            }
            if(estimator.Cust_Offer_Type__c.contains('Load to Card') == false){
                if(estimator.Distribution_Cost_Per_Load__c != NULL)
                    estimator.Distribution_Cost_Per_Load__c = 0;    
                if(estimator.L2C_Estimated_Redemption__c != NULL)
                    estimator.L2C_Estimated_Redemption__c = 0;
                if(estimator.L2C_Handling_Fee__c != NULL)
                    estimator.L2C_Handling_Fee__c = 0; 
            }
        }    
    }
    
    public void VFUpdateVideoAddOns(){   
        if(estimator.AddOns__c == NULL)
            estimator.Add_Setup_Fees__c = false;
        else{
           if(estimator.AddOns__c.contains('Rewards') == false)
               estimator.Add_Setup_Fees__c = false;
        }
    }
       
    public void VFUpdateCopyValue(){
        // Called from VF page - When user enters Distribution cost per print in UI, copy that value into Distribution cost per load. 
        if((estimator.OffType_L2C__c) || ((estimator.IsOfferCustomized__c) && estimator.Cust_Offer_Type__c.contains('Load to Card')))
            estimator.Distribution_Cost_Per_Load__c = estimator.Distribution_Cost_Per_Print__c;
    }       
   
    public void VFUpdateFillProducts(){
        // Called from VF page - Fill Category Details on the UI on entering Category Number. 
        fillProducts(this.estimator);
    }
    
    public boolean fillProducts(DE_Estimator__c estObj) {
        
        // Get the category/product details from Product2 object and populate it in the estimator.    
        Product2 prod;
        
        try{
            if(estObj.Category__c != NULL){
                prod = [SELECT Id,ProductCode,Name,Units_Per_Trip_Average__c, Average_Brand_Penetration__c, 
                  Units_Per_Store_Per_Week__c,Household_Penetration__c From Product2 where Id = :estObj.Category__c]; 
            }
            else{
                prod = [SELECT Id,ProductCode,Name,Units_Per_Trip_Average__c, Average_Brand_Penetration__c, 
                  Units_Per_Store_Per_Week__c,Household_Penetration__c From Product2 where ProductCode = :String.ValueOf(estObj.Promoted_Category_Number__c)]; 
            }
        }
        catch (exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR , 'Please enter a valid Category Number.'));
            this.estimator.Category_Description__c = '**** INVALID CATEGORY! ****';
            estObj.Category_Units_Per_Trip__c = 0;
            estObj.Brand_Penetration_A__c = 0;
            estObj.Category_UPSPW__c = 0;
            estObj.Household_Penetration__c = 0;
            return false;
        }        
               
        //update the current record
        if(prod.ProductCode != NULL)
            estObj.Promoted_Category_Number__c = Decimal.valueof(prod.ProductCode);
        estObj.Category_Description__c = prod.Name;
        estObj.Category_Units_Per_Trip__c = prod.Units_Per_Trip_Average__c;
        estObj.Brand_Penetration_A__c = prod.Average_Brand_Penetration__c;
        estObj.Category_UPSPW__c = prod.Units_Per_Store_Per_Week__c;
        estObj.Household_Penetration__c = prod.Household_Penetration__c;        
        
        return true;
    }
    
    public boolean ExistsTrafficProjForDate(){
    
        // Check if there exists any Traffic Projections for the date entered, else return false. 
        Integer      iCount = 0;
        String       strPrintable = 'Printable';
        String       strL2C = 'Load to Card';
        List<String> stringList = new List<String>();
        
        if(estimator.OffType_Printable__c){
            stringList.Add('National less Target.com');
            stringList.Add('Target.com only');
        }
        if(estimator.OffType_L2C__c)
            stringList.Add('Total L2C');
        if(estimator.IsOfferCustomized__c && (estimator.Cust_Offer_Type__c!=NULL)){     
                                 
               string[] custofftypeList = estimator.Cust_Offer_Type__c.split(';',0);  
               for(string offer:custofftypeList){
                   if(offer.contains(strPrintable))
                       stringList.add(offer.substring(strPrintable.length() + 3)); //string is of the type 'Printable - name'
                   else if(offer.contains(strL2C))
                       stringList.add(offer.substring(strL2C.length() + 3)); //string is of the type 'Load to Card - name'
               }
        }
        
        iCount = [SELECT count() from DE_Traffic_Projections__c where (Projection_Month__c <= :estimator.Calendar_Month__c and Projection_Month__c > :estimator.Calendar_Month__c.addMonths(-1)) AND Offer_Type__c IN :stringList]; 
        
        if((!stringList.IsEmpty()) && (iCount == 0)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR , 'Please enter a valid Program Date.'));
            return false;
        }
        
        return true;
    }
          
    public void SelectAndCreateEstimates(DE_Estimator__c estObj){
    
        // Create Estimates based on user input. Printable, L2C or read from string if multiple customized offer types selected. 
           if(estObj.OffType_Printable__c){
               createEstimate(estObj,'Printable - National');
           }
           
           if(estObj.OffType_L2C__c){
               createEstimate(estObj,'Load to Card - Total L2C');
           }
           
           if(estObj.IsOfferCustomized__c && (estObj.Cust_Offer_Type__c!=NULL)){               
               string[] offerTypes = estObj.Cust_Offer_Type__c.split(';',0);  
               
               for(string offer: offerTypes) 
                    createEstimate(estObj,offer);              
           }
    }
    
    public void createEstimate(DE_Estimator__c estObj,string offerType) {                     
             
       // Do the calculations for all the fields based on the offer type and then create an estimate for each
       // offer type, populate each estimate with the final costs and insert the estimate.
       
       Decimal                      dDiscountFactor = 0;
       Decimal                      dPurchaseReqFactor = 0;
       Decimal                      dOverallAdjustmentFactor = 0;
       Decimal                      dBrandPenetrationB = 0;
       Decimal                      dEstimatedBrandPenetration = 0;
       Decimal                      dEstimatedDailyPrintsOrLoads = 0;
       Decimal                      dEstimatedMonthlyPrintsOrLoads = 0;
       Decimal                      dEstimatedMonthlyPrintOrLoadRate = 0;
       Decimal                      dCNUniqueVisitors = 0;
       Decimal                      dTargetUniqueVisitors = 0;
       Decimal                      dL2CUniqueVisitors  = 0;
       string                       strPrintable = 'Printable';
       string                       strL2C = 'Load to Card';
       String                       strOfferL2C;
       DE_Estimate__c               estimate;
       DE_Traffic_Projections__c    tp;
       DE_Traffic_Projections__c    tpTgt;
              
       dDiscountFactor = (estObj.Offer_Value__c/(estObj.Purchase_Requirement__c * estObj.Avg_Retail_Price__c))/0.2;
          
       if((estObj.Category_Units_Per_Trip__c/estObj.Purchase_Requirement__c)>1.2)
            dPurchaseReqFactor = 1.2;
       else
            dPurchaseReqFactor = estObj.Category_Units_Per_Trip__c/estObj.Purchase_Requirement__c;
            
       dOverallAdjustmentFactor = (dDiscountFactor + dPurchaseReqFactor)/2;         
               
       // Create the estimate object and populate it with the estimate details.           
       estimate = new DE_Estimate__c();
       estimate.OfferTypePrintOrL2C__c = offerType;
       estimate.Estimator__c = estObj.id;
            
       if(offerType.contains(strPrintable)){   
            //dBrandPenetrationB = estObj.UPSPW_Promoted_Brand__c/estObj.Category_UPSPW__c * 100;
            dBrandPenetrationB = math.min((estObj.UPSPW_Promoted_Brand__c/estObj.Category_UPSPW__c),1) * estObj.Household_Penetration__c;                    
            dEstimatedBrandPenetration = (estObj.Brand_Penetration_A__c + dBrandPenetrationB)/2;
            dEstimatedMonthlyPrintOrLoadRate = dEstimatedBrandPenetration * dOverallAdjustmentFactor;
            
            // Get the Unique visitors value from the Traffic Projections object database. 
            try{
                tp = [SELECT Unique_Visitors__c,Projection_Month__c,Offer_Type__c  From DE_Traffic_Projections__c  where 
                            (Projection_Month__c <= :estObj.Calendar_Month__c and Projection_Month__c > :estObj.Calendar_Month__c.addMonths(-1)) and Offer_Type__c = 'National less Target.com'];
                tpTgt = [SELECT Unique_Visitors__c,Projection_Month__c,Offer_Type__c  From DE_Traffic_Projections__c  where 
                             (Projection_Month__c <= :estObj.Calendar_Month__c and Projection_Month__c > :estObj.Calendar_Month__c.addMonths(-1)) and Offer_Type__c = 'Target.com only'];            
            }
            catch(Exception ex){
                return;
            }
            dCNUniqueVisitors = tp.Unique_Visitors__c;
            dTargetUniqueVisitors =  tpTgt.Unique_Visitors__c;
            
            if(offerType.contains('National less Target.com'))
                dEstimatedMonthlyPrintsOrLoads = dCNUniqueVisitors * (dEstimatedMonthlyPrintOrLoadRate/100);
            else if(offerType.contains('Target.com only'))
                dEstimatedMonthlyPrintsOrLoads = dTargetUniqueVisitors * (dEstimatedMonthlyPrintOrLoadRate/100) *0.62;
            else
                dEstimatedMonthlyPrintsOrLoads = (dCNUniqueVisitors * (dEstimatedMonthlyPrintOrLoadRate/100)) + (dTargetUniqueVisitors * (dEstimatedMonthlyPrintOrLoadRate/100) *0.62);            

            dEstimatedDailyPrintsOrLoads = dEstimatedMonthlyPrintsOrLoads /30;            
            estimate.Total_Est_Prints_Over_Program_Duration__c = estObj.Program_Duration__c * dEstimatedDailyPrintsOrLoads;
            estimate.Redemptions__c = estimate.Total_Est_Prints_Over_Program_Duration__c * (estObj.Estimated_Redemption__c/100);
            estimate.Distribution_Cost__c = estimate.Total_Est_Prints_Over_Program_Duration__c * estObj.Distribution_Cost_Per_Print__c;                                
            estimate.Redemption_Cost__c = estimate.Redemptions__c * (estObj.Offer_Value__c + estObj.Handling_Fee__c );
            estimate.Program_Cost__c = estimate.Distribution_Cost__c + estimate.Redemption_Cost__c; 
            
            if(estObj.Add_SetUp_Fees__c && (!offerType.contains('Target.com only')))
                estimate.Program_Cost__c = estimate.Program_Cost__c + 5000;
            
        }
        
        else if(offerType.contains(strL2C)){
            dBrandPenetrationB = math.min((estObj.UPSPW_Promoted_Brand__c/estObj.Category_UPSPW__c),1) * estObj.Household_Penetration__c;                    
            dEstimatedBrandPenetration = (estObj.Brand_Penetration_A__c + dBrandPenetrationB)/2;
            dEstimatedMonthlyPrintOrLoadRate = dEstimatedBrandPenetration * dOverallAdjustmentFactor * 2;
            strOfferL2C = offerType.substring(strL2C.length() + 3);  // string is of the format - 'Load to Card - name'          
            // Get the Unique visitors value from the Traffic Projections object database. 
            try{
                tp = [SELECT Unique_Visitors__c,Projection_Month__c,Offer_Type__c  From DE_Traffic_Projections__c  where 
                  (Projection_Month__c <= :estObj.Calendar_Month__c and Projection_Month__c > :estObj.Calendar_Month__c.addMonths(-1)) and Offer_Type__c = :strOfferL2C];
            }
            catch(Exception ex){
                return;
            }
            dL2CUniqueVisitors = tp.Unique_Visitors__c;            
            //dEstimatedMonthlyPrintsOrLoads = (dL2CUniqueVisitors * 0.33) * (dEstimatedMonthlyPrintOrLoadRate/100);
            dEstimatedMonthlyPrintsOrLoads = dL2CUniqueVisitors * (dEstimatedMonthlyPrintOrLoadRate/100);
            dEstimatedDailyPrintsOrLoads = dEstimatedMonthlyPrintsOrLoads /30;
            estimate.Total_Est_Loads_Over_Program_Duration__c = estObj.Program_Duration__c * dEstimatedDailyPrintsOrLoads;
            estimate.Redemptions__c = estimate.Total_Est_Loads_Over_Program_Duration__c * (estObj.L2C_Estimated_Redemption__c/100);
            estimate.Distribution_Cost__c = estimate.Total_Est_Loads_Over_Program_Duration__c * estObj.Distribution_Cost_Per_Load__c;                                
            estimate.Redemption_Cost__c = estimate.Redemptions__c * (estObj.Offer_Value__c + estObj.L2C_Handling_Fee__c );       
            estimate.Program_Cost__c = estimate.Distribution_Cost__c + estimate.Redemption_Cost__c;      
        }
        else
            return;
              
        estimate.Units_Moved__c = estimate.Redemptions__c * estObj.Purchase_Requirement__c;
        estimate.CPUM__c = estimate.Program_Cost__c/estimate.Units_Moved__c;
                
        insert estimate;  
    }     
    
    public PageReference deleteEstimate(){   
    
        // Called from VF Page - Delete an individual offer type estimate from the estimator detail view. 
        DE_Estimate__c este;
        
        // Variable delEstimateId is populated by VF when the delete button is pressed. 
        if(delEstimateId != NULL){        
            try{
                este = [SELECT id,Estimator__c,Estimator__r.OffType_Printable__c,Estimator__r.OffType_L2C__c,Estimator__r.Cust_Offer_Type__c,OfferTypePrintOrL2C__c,Estimator__r.AddOns__c,Estimator__r.Add_Setup_Fees__c From DE_Estimate__c where id = :delEstimateId ];
            }
            catch(Exception ex){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO , 'No Estimate found'));
                return NULL;
            }        
            
            // Not Needed(EstimatesList will anyway repopulate when you load the page) - Remove the deleted estimated from the estimatesList. 
            /*DE_Estimate__c    toberemEst;
            for (Integer i=0; i<estimatesList.size();i++) {
                toberemEst = estimatesList.get(i);               
                if(toberemEst.id == este.id){          
                    estimatesList.remove(i);
                    break;
                }
            }*/    
            
            // If all Printable estimates are deleted, set the Printable pricing fields and Addons to zero/null.
            if(este.OfferTypePrintOrL2C__c == 'Printable - National'){
                este.Estimator__r.OffType_Printable__c = false;
                este.Estimator__r.AddOns__c = '';
                este.Estimator__r.Add_SetUp_Fees__c = false;   
                este.Estimator__r.Distribution_Cost_Per_Print__c = 0;     
                este.Estimator__r.Estimated_Redemption__c = 0;
                este.Estimator__r.Handling_Fee__c = 0; 
            }
            
            else if(este.OfferTypePrintOrL2C__c == 'Load to Card - Total L2C'){
                este.Estimator__r.OffType_L2C__c = false;
                este.Estimator__r.Distribution_Cost_Per_Load__c = 0;     
                este.Estimator__r.L2C_Estimated_Redemption__c = 0;
                este.Estimator__r.L2C_Handling_Fee__c = 0;                 
            }
            
            else if(este.Estimator__r.Cust_Offer_Type__c.contains(este.OfferTypePrintOrL2C__c))  {    
                este.Estimator__r.Cust_Offer_Type__c = este.Estimator__r.Cust_Offer_Type__c.replace(este.OfferTypePrintOrL2C__c,'');            
                if(este.Estimator__r.Cust_Offer_Type__c.contains('Printable') == false) {
                    este.Estimator__r.AddOns__c = '';   
                    este.Estimator__r.Add_SetUp_Fees__c = false;                    
                    este.Estimator__r.Distribution_Cost_Per_Print__c = 0;     
                    este.Estimator__r.Estimated_Redemption__c = 0;
                    este.Estimator__r.Handling_Fee__c = 0; 
                    }
                if(este.Estimator__r.Cust_Offer_Type__c.contains('Load to Card') == false) {
                    este.Estimator__r.Distribution_Cost_Per_Load__c = 0;     
                    este.Estimator__r.L2C_Estimated_Redemption__c = 0;
                    este.Estimator__r.L2C_Handling_Fee__c = 0; 
                    }
            }
            
            // Update the estimator to reflect the deleted estimate details.
            try{
                upsert este.Estimator__r;
            }
            catch(DmlException ex){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Cannot delete Estimate. At least one Offer type has to be selected.'));
                return null;
            }
            
            // Go ahead and delete the estimate from the database.
            delete este;  
        } 
        
        PageReference estimatesPage =new PageReference('/'+ estimator.id);
        estimatesPage.setRedirect(true);
        return estimatesPage;
    }
    
      
    public void deleteEstimates(){
   
        // Delete all Estimates - Called during editing an estimator. 
        List<DE_estimate__c> estimates = [SELECT id From DE_Estimate__c where Estimator__c = :estimator.id ];
        for(DE_estimate__c e:estimates)
            delete e;
    }
    
    public PageReference save(){
    
        //Override the save functionality to include edit/clone related features. 
        boolean           bClone = false;
        DE_Estimator__c   theEst;
        PageReference     estimatesPage;
        String            url = ApexPages.currentPage().getUrl();

        // Check the url to determine if the save is called for a clone. 
        if(url.contains('clone=1')){    // If so clone the estimator. Deep clone is set to true, so the child estimates are also cloned.
            bClone = true;
            theEst = estimator.clone(false, true);
        } 
        else // Else called from new or edit, hence retain the original estimator. 
            theEst = estimator;       
          
          
        // If category number or Traffic Projections for the date entered are not found in the database, return to display error values on the UI.  
        if((!fillProducts(theEst)) || (!ExistsTrafficProjForDate())) 
            return null;  
            
        // Create name - If name is not entered, create it by appending the brand name and date.
        // Save the name into a field called OldEstimatorName to check if changed during another edit/clone save.   
               
  
        if(theEst.name == theEst.Old_Estimator_Name__c)
            theEst.name = theEst.Promoted_Brand_Name__c + '-' + theEst.Calendar_Month__c.month() + '-' + theEst.Calendar_Month__c.year(); 
        theEst.Old_Estimator_Name__c = theEst.name;    

        // Update the estimator with the changes, this also runs the validation rules.          
        try{
            upsert theEst;    
        }
        catch(DmlException ex){
           ApexPages.addMessages(ex); //This will display error messages due to validation rules.
           return null;
        }        
       
        // If called from Edit, delete the current estimates. 
        if((estimator.id != NULL) && (!bClone))
            deleteEstimates();           
        
        // Run the estimator to calculate new estimates. 
        try{
            selectAndCreateEstimates(theEst);  
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR ,'An unexpected Error has occured. Please enter the missing values and try again.')); 
            return null;
        }
        
        // Display the Estimator detail page.              
        estimatesPage = new PageReference('/'+ theEst.id);
        estimatesPage.setRedirect(true);         
        return estimatesPage;
   }    
   
 
 
}