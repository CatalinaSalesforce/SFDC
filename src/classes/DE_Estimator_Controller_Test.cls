@isTest()
public class DE_Estimator_Controller_Test{
    
      static testMethod void testDE_TestEstimator () {
   
        DE_Estimate__c  newEstimate;
        Id              delrecordId;
        List<DE_Estimate__c> newEstimateList;
        
        ApexPages.StandardController con = new ApexPages.StandardController(new DE_Estimator__c());
        test.startTest();
       
        DE_Estimator_Controller ext = new DE_Estimator_Controller(con);
        ext.estimator.Promoted_Brand_Name__c = 'Oatmeal';
        ext.estimator.Offer_Value__c = 0.50;        
        ext.estimator.Purchase_Requirement__c = 1;        
        ext.estimator.Program_Duration__c = 30;
        ext.estimator.UPSPW_Promoted_Brand__c = 49;
        ext.estimator.Avg_Retail_Price__c = 3;
        ext.estimator.Distribution_Cost_Per_Print__c = 0.08;
        ext.estimator.Distribution_Cost_Per_Load__c = 0.08;
        ext.estimator.Estimated_Redemption__c = 20;
        ext.estimator.L2C_Estimated_Redemption__c = 20;
        ext.estimator.Handling_Fee__c = 0.10;
        ext.estimator.L2C_Handling_Fee__c = 0.10;
        ext.estimator.OffType_Printable__c = true;  
        ext.estimator.OffType_L2C__c = true;      
        
        Product2 product = new Product2();
        product.Name = 'test product';
        product.Units_Per_Trip_Average__c = 1;
        product.Fragmentation_Factor__c =1;
        product.Average_Price__c =1;
        product.Units_Per_Store_Per_Week__c=1;
        product.Household_Penetration__c=1;
        product.ProductCode='101';
        insert product;
        
        ext.VFUpdateFillProducts();        
        
        DE_Traffic_Projections__c tp = new DE_Traffic_Projections__c();
        tp.Projection_Month__c=date.newinstance(2015, 2, 17);
        tp.Offer_Type__c = 'National less Target.com';
        tp.Unique_Visitors__c = 50000;
        insert tp;
                
        tp = new DE_Traffic_Projections__c();
        tp.Projection_Month__c=date.newinstance(2015, 2, 17);
        tp.Offer_Type__c = 'Target.com Only';
        tp.Unique_Visitors__c = 60000;
        insert tp;
        
        tp = new DE_Traffic_Projections__c();
        tp.Projection_Month__c=date.newinstance(2015, 2, 17);
        tp.Offer_Type__c = 'Total L2C';
        tp.Unique_Visitors__c = 4000;
        insert tp;
        
        tp = new DE_Traffic_Projections__c();
        tp.Projection_Month__c=date.newinstance(2015, 2, 17);
        tp.Offer_Type__c = 'Meijer';
        tp.Unique_Visitors__c = 3000;
        insert tp;       
        
        // Enter wrong category number and Date.
        ext.estimator.Promoted_Category_Number__c = 100;
        ext.estimator.Calendar_Month__c = date.newinstance(2014, 2, 17);
        ext.VFUpdateFillProducts();        
        ext.ExistsTrafficProjForDate();       
        
        
        
        ext.estimator.Calendar_Month__c = date.newinstance(2015, 2, 17);
        ext.estimator.Category__c = product.id;
        
        PageReference estPage = new PageReference('/'+ ext.estimator.id);
        estPage.setRedirect(true);
        Test.setCurrentPageReference(estPage);         
           
        ext.save();  
        
        delrecordId = ext.estimator.id;
        if(delrecordId != NULL){
            List<DE_Estimate__c> esteList = [SELECT id From DE_Estimate__c where Estimator__c = :delrecordId ];
            for(DE_Estimate__c delEst:esteList) {
                ext.delEstimateId = delEst.id;
                ext.deleteEstimate();
            }
        } 

        
        ext.VFUpdateCopyValue();
        ext.VFUpdatePrintOffType();
        ext.VFUpdateL2COffType();   
        
        ext.estimator.OffType_Printable__c = false;  
        ext.estimator.OffType_L2C__c = false;        
        ext.VFUpdatePrintOffType();
        ext.VFUpdateL2COffType();  
        
        ext.estimator.OffType_L2C__c = true; 
        ext.VFUpdateL2COffType(); 
        ext.estimator.OffType_L2C__c = false;
        ext.estimator.OffType_Printable__c = true;
        ext.VFUpdatePrintOffType();  
             
        ext.estimator.IsOfferCustomized__c = true;
        ext.VFUpdateCustOffType(); 
        ext.estimator.Cust_Offer_Type__c = 'Printable - National less Target.com';
        ext.VFUpdateCustPrintOrL2C();
        ext.estimator.Cust_Offer_Type__c = 'Load to Card - Giant Eagle'; 
        ext.VFUpdateCustPrintOrL2C();        
        
        ext.VFUpdateVideoAddOns();
        ext.estimator.AddOns__c = 'Video Rewards';
        ext.estimator.Add_SetUp_Fees__c = true;
        ext.VFUpdateVideoAddOns();
        
        ext.estimator.Purchase_Requirement__c = 2;     
        ext.estimator.Cust_Offer_Type__c = 'Printable - National less Target.com; Printable - Target.com only; Load to Card - Giant Eagle; Load to Card - Marsh; Load to Card - Meijer; Load to Card - Shoprite; Load to Card - Lowes Foods;';
        
        ext.estimator.Distribution_Cost_Per_Print__c = 0.08;
        ext.estimator.Distribution_Cost_Per_Load__c = 0.08;
        ext.estimator.Estimated_Redemption__c = 20;
        ext.estimator.L2C_Estimated_Redemption__c = 20;
        ext.estimator.Handling_Fee__c = 0.10;
        ext.estimator.L2C_Handling_Fee__c = 0;        
        
        ext.save();
        ext.estimator.L2C_Handling_Fee__c = 0.10;
        
        ext.save();
        
        delrecordId = ext.estimator.id;
            if(delrecordId != NULL){
            List<DE_Estimate__c> esteList = [SELECT id From DE_Estimate__c where Estimator__c = :delrecordId ];
            for(DE_Estimate__c delEst:esteList) {
                ext.delEstimateId = delEst.id;
                ext.deleteEstimate();
            }
        }  

        test.stopTest();         
   }  
   
    

}