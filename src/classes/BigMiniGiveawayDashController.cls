public class BigMiniGiveawayDashController {

  

//MFG Leaderboards//
public List<Opportunity> larcon = new List<Opportunity>();
public List<Opportunity> mfgmultilead = new List<Opportunity>();
public List<Program__c> mfgbvlead = new List<Program__c>();
public List<Opportunity> mfgclilead = new List<Opportunity>();
public List<Opportunity> mfglqlead = new List<Opportunity>();
public List<Opportunity> mfgmulead = new List<Opportunity>();
public List<Opportunity> mfglulead = new List<Opportunity>();
public List<Program__c> mfgmldr = new List<Program__c>();
//MFG Running//
public List<Opportunity> larconrun = new List<Opportunity>();
public List<Opportunity> mfgmultirun = new List<Opportunity>();
public List<Program__c> mfgbvrun = new List<Program__c>();
public List<Program__c> mfgmrun= new List<Program__c>();
public List<Opportunity> mfgclirun = new List<Opportunity>();
public List<Opportunity> mfglqrun = new List<Opportunity>();
public List<Opportunity> mfglurun = new List<Opportunity>();
public List<Opportunity> mfgmurun = new List<Opportunity>();
//RTL Leaderboards//
public List<Opportunity> rtllarcon = new List<Opportunity>();
public List<Opportunity> rtlmultilead = new List<Opportunity>();
public List<Program__c> rtlbvlead = new List<Program__c>();
public List<Opportunity> rtlcvclead = new List<Opportunity>();
public List<Opportunity> mfgliquid = new List<Opportunity>();
public List<Opportunity> rtlmobilelead = new List<Opportunity>();
//RTL Running//
public List<Opportunity> rtllarconrun = new List<Opportunity>();
public List<Opportunity> rtlmultirun = new List<Opportunity>();
public List<Program__c> rtlbvrun = new List<Program__c>();
public List<Opportunity> rtlcvcrun = new List<Opportunity>();
public List<Opportunity> rtlclirun = new List<Opportunity>();
public List<Opportunity> rtlmobilerun = new List<Opportunity>();
public List<Opportunity> mfglrlead  = new List<Opportunity>();
public List<Opportunity> mfglrRun = new List<Opportunity>();

//MFG LargestContractSigned//
public List<Opportunity> getLargestContractsSigned() {
            larcon = [SELECT Owner.SmallPhotoUrl, Catalina_Business_Unit__c, Owner.Name, Owner.FirstName,Owner.LastName, Name, Total_Amount__c  from Opportunity
            where StageName = 'Closed Won' 
            AND Total_Amount__c != 0
            AND Type = 'New' 
            AND Related_Contract__c = null
            AND Parent_Contract__c = null
            AND CloseDate >= 2013-07-01 AND CloseDate <= 2013-11-30 
            AND Account.RecordType.Name = 'Manufacturing'
            AND RecordType.Name = 'Contract'
            ORDER BY Total_Amount__c DESC LIMIT 10];
        return larcon;
    }
    
//MFG MultiChannel Leaderboard//
public List<Opportunity> getMultiContracts() {
            mfgmultilead = [SELECT Owner.SmallPhotoUrl, Catalina_Business_Unit__c, Owner.Name, Owner.FirstName, Owner.LastName, Name, Total_Amount__c  from Opportunity
            where 
            Catalina_Business_Unit__c INCLUDES ( 'Base;Digital O&O;Audience Network', 'Base;Mobile;Digital O&O','Digital O&O;Mobile;Audience Network', 'Base;Digital O&O', 'Base;Mobile', 'Base;Audience Network', 'Audience Network;Mobile') 
            AND Catalina_Business_Unit__c <> null 
            AND StageName = 'Closed Won' 
            AND Type = 'New' 
            AND CloseDate >= 2013-07-01 AND CloseDate <= 2013-11-30
            AND Parent_Contract__c = null 
            AND Related_Contract__c = null           
            AND Account.RecordType.Name = 'Manufacturing'
                        AND RecordType.Name = 'Contract'
            ORDER BY Total_Amount__c DESC LIMIT 10];
        return mfgmultilead;
        }
   


//MFG Untargeted LTC Leaderboard//            
public List<Opportunity> getMFGLQContracts() {
            mfglqlead = [SELECT Number_of_Liquid_offers__c, Owner.SmallPhotoUrl, Catalina_Business_Unit__c, Owner.Name, Owner.FirstName,Owner.LastName, Name, Total_Amount__c  from Opportunity
            where Qualifies_for_Liquid_Offers__c = true 
            AND StageName = 'Closed Won' 
            AND Type = 'New' 
            AND Parent_Contract__c = null 
            AND Related_Contract__c = null
            AND Number_of_Liquid_offers__c != null
            AND CloseDate >= 2013-07-01 AND CloseDate <= 2013-11-30 
            AND Account.RecordType.Name = 'Manufacturing'
            AND RecordType.Name = 'Contract'            
            ORDER BY Number_of_Liquid_offers__c DESC LIMIT 10];
        return mfglqlead;
    }
    
  // MFG Most untargeted LTC sold Leaderboard//
  public List<Opportunity> getMFGMUContracts() {
            mfgmulead = [SELECT Number_of_Liquid_offers__c, Owner.SmallPhotoUrl, Catalina_Business_Unit__c, Owner.Name, Owner.FirstName,Owner.LastName, Name, Total_Amount__c  from Opportunity
            where Qualifies_for_Liquid_Offers__c = true 
            AND StageName = 'Closed Won' 
            AND Type = 'New' 
            AND Parent_Contract__c = null 
            AND Related_Contract__c = null
            AND Number_of_Liquid_offers__c != null
            AND CloseDate >= 2013-07-01 AND CloseDate <= 2013-11-30 
            AND Account.RecordType.Name = 'Manufacturing'
            AND RecordType.Name = 'Contract'            
            ORDER BY Number_of_Liquid_offers__c DESC LIMIT 10];
        return mfgmulead;
    }
    
       
  // MFG Largest untargeted LTC sold Leaderboard//
  public List<Opportunity> getMFGLUContracts() {
            mfglulead = [SELECT Number_of_Liquid_offers__c, Owner.SmallPhotoUrl, Catalina_Business_Unit__c, Owner.Name, Owner.FirstName,Owner.LastName, Name, Total_Amount__c  from Opportunity
            where Qualifies_for_Liquid_Offers__c = true AND 
            StageName = 'Closed Won' 
            AND Type = 'New' 
            AND Parent_Contract__c = null 
            AND Related_Contract__c = null
            AND Number_of_Liquid_offers__c != null
            AND CloseDate >= 2013-07-01 AND CloseDate <= 2013-11-30 
            AND Account.RecordType.Name = 'Manufacturing'
            AND RecordType.Name = 'Contract'            
            ORDER BY Total_Amount__c DESC LIMIT 10];
        return mfglulead;
    }
    
    // Loyalty rewards contracts Leader board
      public List<Opportunity> getMFGLRContracts() {
        mfglrlead = [SELECT Total_Forecast_Amount__c, Number_of_Liquid_offers__c, Owner.SmallPhotoUrl, Catalina_Business_Unit__c, Owner.Name, Owner.FirstName,Owner.LastName, Name, Total_Amount__c from Opportunity
            where Qualifies_for_Loyalty_Rewards__c = true 
            AND StageName = 'Closed Won' 
            AND Type = 'New' 
            AND Parent_Contract__c = null
            AND Related_Contract__c = null
            AND CloseDate >= 2013-07-01 AND CloseDate <= 2013-11-30
            AND Account.RecordType.Name = 'Manufacturing'
            AND RecordType.Name = 'Contract'            
            ORDER BY Total_Amount__c DESC LIMIT 10];
        return mfglrlead;
    }

//MFG LargestContractRunning// 
public List<Opportunity> getLargestContractsRunning() {       
            larconrun = [SELECT Owner.SmallPhotoUrl, Catalina_Business_Unit__c, Owner.Name, Owner.FirstName,Owner.LastName, Name, Total_Forecast_Amount__c from Opportunity
            where StageName NOT IN ('Closed Won','Closed Won Addendum','Closed Won Renewal','Closed Error','Closed Lost') 
            AND Type = 'New' 
            AND Parent_Contract__c = null 
            AND Related_Contract__c = null
            AND CloseDate >= 2013-07-01 AND CloseDate <= 2013-11-30 
            AND Account.RecordType.Name = 'Manufacturing'
            AND RecordType.Name = 'Proposal'
            ORDER BY Total_Forecast_Amount__c DESC LIMIT 10];
        return larconrun;
    }
      
//MFG MultiChannel In the Running//
public List<Opportunity> getMFGMultiRunning() {
            mfgmultirun = [SELECT Owner.SmallPhotoUrl, Catalina_Business_Unit__c, Owner.Name, Owner.FirstName,Owner.LastName, Name, Total_Forecast_Amount__c  from Opportunity
            where 
            Catalina_Business_Unit__c INCLUDES ( 'Base;Digital O&O;Audience Network', 'Base;Mobile;Digital O&O','Digital O&O;Mobile;Audience Network', 'Base;Digital O&O', 'Base;Mobile', 'Base;Audience Network', 'Audience Network;Mobile') 
            AND Catalina_Business_Unit__c <> null 
            AND StageName NOT IN ('Closed Won','Closed Won Addendum','Closed Won Renewal','Closed Error','Closed Lost') 
            AND Type = 'New' AND CloseDate >= 2013-07-01 AND CloseDate <= 2013-11-30
            AND Parent_Contract__c = null 
            AND Related_Contract__c = null
            AND Account.RecordType.Name = 'Manufacturing'
            AND RecordType.Name = 'Proposal'
            ORDER BY Total_Forecast_Amount__c DESC LIMIT 10];
        return mfgmultirun;
    } 



//@Depricated
//MFG Untargeted LTC In the Running//
public List<Opportunity> getMFGLQRunning() {
            mfglqrun = [SELECT Number_of_Liquid_offers__c , Owner.SmallPhotoUrl, Catalina_Business_Unit__c, Owner.Name, Owner.FirstName,Owner.LastName, Name, Total_Forecast_Amount__c  from Opportunity
            where Qualifies_for_Liquid_Offers__c = true 
            AND StageName NOT IN ('Closed Won','Closed Won Addendum','Closed Won Renewal','Closed Error','Closed Lost') 
            AND Type = 'New' 
            AND Parent_Contract__c = null 
            AND Related_Contract__c = null
            AND CloseDate >= 2013-07-01 AND CloseDate <= 2013-11-30 
            AND Number_of_Liquid_offers__c != null
            AND Account.RecordType.Name = 'Manufacturing'
            AND RecordType.Name = 'Proposal'
            ORDER BY Number_of_Liquid_offers__c DESC LIMIT 10];
        return mfglqrun;
    }  
    
    //MFG Untargeted LTC In the Running//
public List<Opportunity> getMFGLURunning() {
            mfglurun = [SELECT Number_of_Liquid_offers__c , Owner.SmallPhotoUrl, Catalina_Business_Unit__c, Owner.Name, Owner.FirstName,Owner.LastName, Name, Total_Forecast_Amount__c  from Opportunity
            where Qualifies_for_Liquid_Offers__c = true AND 
            StageName NOT IN ('Closed Won','Closed Won Addendum','Closed Won Renewal','Closed Error','Closed Lost') 
            AND Type = 'New' 
            AND Parent_Contract__c = null 
            AND Related_Contract__c = null
            AND CloseDate >= 2013-07-01 AND CloseDate <= 2013-11-30 
            AND Number_of_Liquid_offers__c != null
            AND Account.RecordType.Name = 'Manufacturing'
            AND RecordType.Name = 'Proposal'
            ORDER BY Total_Forecast_Amount__c  DESC LIMIT 10];
        return mfglurun;
    }  
    
        
    //MFG MOST Untargeted LTC In the Running//
public List<Opportunity> getMFGMURunning() {
            mfgmurun = [SELECT Number_of_Liquid_offers__c , Owner.SmallPhotoUrl, Catalina_Business_Unit__c, Owner.Name, Owner.FirstName,Owner.LastName, Name, Total_Forecast_Amount__c  from Opportunity
            where Qualifies_for_Liquid_Offers__c = true AND 
            StageName NOT IN ('Closed Won','Closed Won Addendum','Closed Won Renewal','Closed Error','Closed Lost') 
            AND Type = 'New' 
            AND Parent_Contract__c = null 
            AND Related_Contract__c = null
            AND CloseDate >= 2013-07-01 AND CloseDate <= 2013-11-30 
            AND Number_of_Liquid_offers__c != null
            AND Account.RecordType.Name = 'Manufacturing'
            AND RecordType.Name = 'Proposal'
            ORDER BY Number_of_Liquid_offers__c DESC LIMIT 10];
        return mfgmurun;
    }  
    
   // Loyalty rewards contracts In the Running
         public List<Opportunity> getMFGLRRunning() {
        mfglrRun = [SELECT Total_Forecast_Amount__c, Number_of_Liquid_offers__c, Owner.Id , Owner.SmallPhotoUrl, Catalina_Business_Unit__c, Owner.Name, Owner.FirstName,Owner.LastName, Name, Total_Amount__c  from Opportunity
            where Qualifies_for_Loyalty_Rewards__c = true 
            AND StageName NOT IN ('Closed Won','Closed Won Addendum','Closed Won Renewal','Closed Error','Closed Lost') 
            AND Total_Forecast_Amount__c != 0
            AND Type = 'New' 
            AND Parent_Contract__c = null
            AND Related_Contract__c = null
            AND CloseDate >= 2013-07-01 AND CloseDate <= 2013-11-30
            AND Account.RecordType.Name = 'Manufacturing'
            AND RecordType.Name = 'Proposal'            
            ORDER BY Total_Forecast_Amount__c  DESC LIMIT 10];
        return mfglrRun;
    }
            
//RTL LargestContractSigned//
public List<Opportunity> getRTLLargestContractsSigned() {        
            rtllarcon = [SELECT Owner.SmallPhotoUrl, Catalina_Business_Unit__c, Owner.Name, Owner.FirstName,Owner.LastName, Name, Total_Amount__c  from Opportunity
            where StageName = 'Closed Won' 
            AND Total_Amount__c != 0
            AND Type = 'New' 
            AND Parent_Contract__c = null 
            AND Related_Contract__c = null
            AND CloseDate >= 2013-07-01 AND CloseDate <= 2013-11-30 
            AND Account.RecordType.Name = 'Retail'
            AND RecordType.Name = 'Contract'
            ORDER BY Total_Amount__c DESC LIMIT 10];
        return rtllarcon;
    }

//RTL MultiChannel Leaderboard//
public List<Opportunity> getRTLMultiContracts() {
            rtlmultilead = [SELECT Owner.SmallPhotoUrl, Catalina_Business_Unit__c, Owner.Name, Owner.FirstName,Owner.LastName, Name, Total_Amount__c  from Opportunity
            where 
            Catalina_Business_Unit__c INCLUDES ( 'Base;Digital O&O;Audience Network', 'Base;Mobile;Digital O&O','Digital O&O;Mobile;Audience Network', 'Base;Digital O&O', 'Base;Mobile', 'Base;Audience Network', 'Audience Network;Mobile') 
            AND Catalina_Business_Unit__c <> null 
            AND StageName = 'Closed Won' 
            AND Type = 'New' AND CloseDate >= 2013-07-01 AND CloseDate <= 2013-11-30 
            AND Parent_Contract__c = null 
            AND Related_Contract__c = null
            AND Account.RecordType.Name = 'Retail'
            AND RecordType.Name = 'Contract'
            ORDER BY Total_Amount__c DESC LIMIT 10];
        return rtlmultilead;
        }

//RTL BuyerVision Leaderboard//
public List<Program__c> getRTLBVContracts() {
            rtlbvlead = [SELECT Opportunity__r.Owner.SmallPhotoUrl, Delivery_Type__c, Opportunity__r.Owner.Name, Opportunity__r.Owner.FirstName,Opportunity__r.Owner.LastName, Name, Total_Amount__c  from Program__c
            where Delivery_Type__c = 'Audience Network'
            AND Total_Amount__c > 49999 
            AND Opportunity__r.StageName = 'Closed Won' 
            AND Opportunity__r.Type = 'New' 
            AND Opportunity__r.Parent_Contract__c = null 
            AND Opportunity__r.Related_Contract__c = null
            AND Opportunity__r.CloseDate >= 2013-07-01 AND Opportunity__r.CloseDate <= 2013-11-30 
            AND Opportunity__r.Account.RecordType.Name = 'Retail'
            AND Opportunity__r.RecordType.Name = 'Contract'
            ORDER BY Total_Amount__c DESC LIMIT 10];
        return rtlbvlead;
    }    

//RTL CVC Leaderboard//
public List<Opportunity> getRTLCVCContracts() {
            rtlcvclead = [SELECT Owner.SmallPhotoUrl, Catalina_Business_Unit__c, Owner.Name, Owner.FirstName,Owner.LastName, Name, Total_Amount__c  from Opportunity
            where Qualifies_for_CVC__c = true 
            AND StageName = 'Closed Won' 
            AND Type = 'New' 
            AND Parent_Contract__c = null 
            AND Related_Contract__c = null
            AND CloseDate >= 2013-07-01 AND CloseDate <= 2013-11-30
            AND Account.RecordType.Name = 'Retail'
            AND RecordType.Name = 'Contract'
            ORDER BY Total_Amount__c DESC LIMIT 10];
        return rtlcvclead;
    }

//MFG Number of Liquid Offers Leaderboard RTLCLIContracts//
public List<Opportunity> getMFGLiquidOffer() {
            mfgliquid = [SELECT Owner.SmallPhotoUrl, Number_of_Liquid__c, Catalina_Business_Unit__c, Owner.Name, Owner.FirstName,Owner.LastName, Name, Total_Amount__c  from Opportunity
            where StageName = 'Closed Won' 
            AND Type = 'New' 
            AND Parent_Contract__c = null 
            AND Number_of_Liquid__c > 0
            AND Related_Contract__c = null
            AND CloseDate >= 2013-09-30 AND CloseDate <= 2013-12-29 
            AND Account.RecordType.Name = 'Manufacturing'
            AND RecordType.Name = 'Contract'
            ORDER BY Number_of_Liquid__c DESC LIMIT 10];
        return mfgliquid;
    }
    
//MFG Number of Liquid Offers Running RTLCLIContracts//
public List<Opportunity> getMFGLiquidOfferRun() {
            mfgliquid = [SELECT Owner.SmallPhotoUrl, Number_of_Liquid__c, Catalina_Business_Unit__c, Owner.Name, Owner.FirstName,Owner.LastName, Name, Total_Amount__c  from Opportunity
            where StageName NOT IN ('Closed Won','Closed Won Addendum','Closed Won Renewal','Closed Error','Closed Lost') 
            AND Type = 'New' 
            AND Parent_Contract__c = null 
            AND Related_Contract__c = null
            AND CloseDate >= 2013-09-30 AND CloseDate <= 2013-12-29 
            AND Account.RecordType.Name = 'Manufacturing'
            AND RecordType.Name = 'Proposal'
            AND Number_of_Liquid__c > 0
            ORDER BY Number_of_Liquid__c DESC LIMIT 10];
        return mfgliquid;
    }

//RTL Mobile Leaderboard//
public List<Opportunity> getRTLMobileContracts() {
            rtlmobilelead = [SELECT Owner.SmallPhotoUrl, Catalina_Business_Unit__c, Owner.Name, Owner.FirstName,Owner.LastName, Name, CloseDate  from Opportunity
            where Mobile_Commerce_Pilot__c = true 
            AND StageName = 'Closed Won' 
            AND Type = 'New' 
            AND Parent_Contract__c = null 
            AND Related_Contract__c = null
            AND CloseDate >= 2013-07-01 AND CloseDate <= 2013-11-30 
            AND Account.RecordType.Name = 'Retail'
            AND RecordType.Name = 'Contract'
            ORDER BY CloseDate DESC LIMIT 10];
        return rtlmobilelead;
    }    
        
//RTL LargestContractRunning//        
public List<Opportunity> getRTLLargestContractsRunning() {        
            rtllarconrun = [SELECT Owner.SmallPhotoUrl, Catalina_Business_Unit__c, Owner.Name, Owner.FirstName,Owner.LastName, Name, Total_Forecast_Amount__c from Opportunity
            where StageName NOT IN ('Closed Won','Closed Won Addendum','Closed Won Renewal','Closed Error','Closed Lost') 
            AND Type = 'New' 
            AND Parent_Contract__c = null 
            AND Related_Contract__c = null
            AND CloseDate >= 2013-07-01 AND CloseDate <= 2013-11-30
            AND Account.RecordType.Name = 'Retail'
            AND RecordType.Name = 'Proposal'
            ORDER BY Total_Forecast_Amount__c DESC LIMIT 10];
        return rtllarconrun;
    }    

//RTL MultiChannel In the Running//
public List<Opportunity> getRTLMultiRunning() {
            rtlmultirun = [SELECT Owner.SmallPhotoUrl, Catalina_Business_Unit__c, Owner.Name, Owner.FirstName,Owner.LastName, Name, Total_Forecast_Amount__c  from Opportunity
            where 
            Catalina_Business_Unit__c INCLUDES ( 'Base;Digital O&O;Audience Network', 'Base;Mobile;Digital O&O','Digital O&O;Mobile;Audience Network', 'Base;Digital O&O', 'Base;Mobile', 'Base;Audience Network', 'Audience Network;Mobile') 
            AND Catalina_Business_Unit__c <> null 
            AND StageName NOT IN ('Closed Won','Closed Won Addendum','Closed Won Renewal','Closed Error','Closed Lost') 
            AND Type = 'New' AND CloseDate >= 2013-07-01 AND CloseDate <= 2013-11-30
            AND Parent_Contract__c = null 
            AND Related_Contract__c = null
            AND Account.RecordType.Name = 'Retail'
            AND RecordType.Name = 'Proposal'
            ORDER BY Total_Forecast_Amount__c DESC LIMIT 10];
        return rtlmultirun;
    }    

//RTL BuyerVision In the Running//
public List<Program__c> getRTLBVRunning() {
            rtlbvrun = [SELECT Opportunity__r.Owner.SmallPhotoUrl, Delivery_Type__c, Opportunity__r.Owner.Name, Opportunity__r.Owner.FirstName,Opportunity__r.Owner.LastName, Name, Total_Amount__c  from Program__c
            where Delivery_Type__c = 'Audience Network' 
            AND Total_Amount__c > 49999 
            AND Opportunity__r.StageName NOT IN ('Closed Won','Closed Won Addendum','Closed Won Renewal','Closed Error','Closed Lost') 
            AND Opportunity__r.Type = 'New'
            AND Opportunity__r.Related_Contract__c = null 
            AND Opportunity__r.Parent_Contract__c = null 
            AND Opportunity__r.CloseDate >= 2013-07-01 AND Opportunity__r.CloseDate <= 2013-11-30
            AND Opportunity__r.Account.RecordType.Name = 'Retail'
            AND Opportunity__r.RecordType.Name = 'Proposal'
            ORDER BY Total_Amount__c DESC LIMIT 10];
        return rtlbvrun;
    } 

//RTL CVC In the Running//
public List<Opportunity> getRTLCVCRunning() {
            rtlcvcrun = [SELECT Owner.SmallPhotoUrl, Catalina_Business_Unit__c, Owner.Name, Owner.FirstName,Owner.LastName, Name, Total_Forecast_Amount__c  from Opportunity
            where Qualifies_for_CVC__c = true 
            AND StageName NOT IN ('Closed Won','Closed Won Addendum','Closed Won Renewal','Closed Error','Closed Lost') 
            AND Type = 'New' 
            AND Related_Contract__c = null
            AND Parent_Contract__c = null 
            AND CloseDate >= 2013-07-01 AND CloseDate <= 2013-11-30 
            AND Account.RecordType.Name = 'Retail'
            AND RecordType.Name = 'Proposal'
            ORDER BY Total_Forecast_Amount__c DESC LIMIT 10];
        return rtlcvcrun;
    }  
/*
//RTL CLI In the Running//
public List<Opportunity> getRTLCLIRunning() {
            rtlclirun = [SELECT Owner.SmallPhotoUrl, Catalina_Business_Unit__c, Owner.Name, Owner.FirstName,Owner.LastName, Name, Total_Forecast_Amount__c  from Opportunity
            where Qualifies_for_CLI__c = true 
            AND StageName NOT IN ('Closed Won','Closed Won Addendum','Closed Won Renewal','Closed Error','Closed Lost') 
            AND Type = 'New' 
            AND Parent_Contract__c = null 
            AND CloseDate >= 2013-07-01 AND CloseDate <= 2013-11-30 
            AND Account.RecordType.Name = 'Retail'
            AND RecordType.Name = 'Proposal'
            ORDER BY Total_Forecast_Amount__c DESC LIMIT 10];
        return rtlclirun;
    }  
*/
//RTL Mobile In the Running//
public List<Opportunity> getRTLMobileRunning() {
            rtlmobilerun = [SELECT Owner.SmallPhotoUrl, Catalina_Business_Unit__c, Owner.Name, Owner.FirstName,Owner.LastName, Name, Probability, StageName, Total_Forecast_Amount__c from Opportunity
            where Mobile_Commerce_Pilot__c = true 
            AND StageName NOT IN ('Closed Won','Closed Won Addendum','Closed Won Renewal','Closed Error','Closed Lost') 
            AND Type = 'New' 
            AND Related_Contract__c = null
            AND Parent_Contract__c = null 
            AND CloseDate >= 2013-07-01 AND CloseDate <= 2013-11-30 
            AND Account.RecordType.Name = 'Retail'
            AND RecordType.Name = 'Proposal'
            ORDER BY Probability DESC LIMIT 10];
        return rtlmobilerun;
    }  
//MFG Mobile Leaderboard//
public List<Program__c> getMFGMobileLdr() {
            mfgmldr = [SELECT Opportunity__r.Owner.SmallPhotoUrl, Delivery_Type__c, Opportunity__r.Owner.Name, Opportunity__r.Name, Opportunity__r.Owner.FirstName,Opportunity__r.Owner.LastName, Name, Total_Amount__c  from Program__c
            where Delivery_Type__c = 'Mobile'
            AND Opportunity__r.StageName = 'Closed Won' 
            AND Opportunity__r.Type = 'New' 
            AND Opportunity__r.Parent_Contract__c = null 
            AND Opportunity__r.Related_Contract__c = null
            AND Opportunity__r.CloseDate >= 2013-09-30 AND Opportunity__r.CloseDate <= 2013-12-29 
            AND Opportunity__r.Account.RecordType.Name = 'Manufacturing'
            AND Opportunity__r.RecordType.Name = 'Contract'
            ORDER BY Total_Amount__c DESC LIMIT 10];
        return mfgmldr ;
    } 

//MFG Mobile Running//     
public List<Program__c> getMFGMobileRun() {        
            mfgmrun = [SELECT Opportunity__r.Owner.SmallPhotoUrl, Delivery_Type__c, Opportunity__r.Owner.Name, Opportunity__r.Name, Opportunity__r.Owner.FirstName,Opportunity__r.Owner.LastName, Name, Total_Amount__c  from Program__c
            where Opportunity__r.StageName NOT IN ('Closed Won','Closed Won Addendum','Closed Won Renewal','Closed Error','Closed Lost') 
            AND Delivery_Type__c = 'Mobile'
            AND Opportunity__r.Type = 'New' 
            AND Opportunity__r.Parent_Contract__c = null 
            AND Opportunity__r.Related_Contract__c = null
            AND Opportunity__r.CloseDate >= 2013-09-30 AND Opportunity__r.CloseDate <= 2013-12-29 
            AND Opportunity__r.Account.RecordType.Name = 'Manufacturing'
            AND Opportunity__r.RecordType.Name = 'Proposal'
            ORDER BY Total_Amount__c DESC LIMIT 10];
        return mfgmrun;
    }    
}