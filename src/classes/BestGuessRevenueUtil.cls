/*
@Name           : BestGuessRevenueUtil
@Author         : customersuccess@cloud62.com
@Date           : 9/25/2013
@Description    : Controller used for BestGuessController
*/
public Class BestGuessRevenueUtil{
    
    public Static List<BestGuessRevenueUtil.DeliveryChannelWrapper> getMBGManufacturerWrapper(List<Manager_Best_Guess__c> gmbgList){
        Map<String, BestGuessRevenueUtil.DeliveryChannelWrapper> tempDChannelMAP = new Map<String, BestGuessRevenueUtil.DeliveryChannelWrapper>();
        tempDChannelMAP.put('Base', new DeliveryChannelWrapper(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Base'));
        tempDChannelMAP.put('Mobile', new DeliveryChannelWrapper(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Mobile'));
        tempDChannelMAP.put('Digital', new DeliveryChannelWrapper(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Digital'));
        tempDChannelMAP.put('Audience Network', new DeliveryChannelWrapper(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Audience Network'));
        for(Manager_Best_Guess__c mbg : gmbgList){
            if(mbg.Quarter__c != null && mbg.Quarter__c.startsWith('Q1')){
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperBase = tempDChannelMAP.get('Base');
                wrapperBase.bookedQ1 = wrapperBase.bookedQ1 + mbg.Team_M_B_Booked_Actual__c;
                wrapperBase.bookedTotal = wrapperBase.bookedTotal + mbg.Team_M_B_Booked_Actual__c;
                wrapperBase.bookedWgtQ1 = wrapperBase.bookedWgtQ1 + mbg.Team_M_B_Booked_Proposal__c;
                wrapperBase.bookedWgtTotal = wrapperBase.bookedWgtTotal + mbg.Team_M_B_Booked_Proposal__c;
                wrapperBase.bookedFullQ1 = wrapperBase.bookedFullQ1 + mbg.Team_M_B_Booked_Full_Proposal__c;
                wrapperBase.bookedFullTotal = wrapperBase.bookedFullTotal + mbg.Team_M_B_Booked_Full_Proposal__c;
                wrapperBase.dChannel = 'Base';
                tempDChannelMAP.put('Base', wrapperBase);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperMobile = tempDChannelMAP.get('Mobile');
                wrapperMobile.bookedQ1 = wrapperMobile.bookedQ1 + mbg.Team_M_M_Booked_Actual__c;
                wrapperMobile.bookedTotal = wrapperMobile.bookedTotal + mbg.Team_M_M_Booked_Actual__c;
                wrapperMobile.bookedWgtQ1 = wrapperMobile.bookedWgtQ1 + mbg.Team_M_M_Booked_Proposal__c;
                wrapperMobile.bookedWgtTotal = wrapperMobile.bookedWgtTotal + mbg.Team_M_M_Booked_Proposal__c;
                wrapperMobile.bookedFullQ1 = wrapperMobile.bookedFullQ1 + mbg.Team_M_M_Booked_Full_Proposal__c;
                wrapperMobile.bookedFullTotal = wrapperMobile.bookedFullTotal + mbg.Team_M_M_Booked_Full_Proposal__c;
                wrapperMobile.dChannel = 'Mobile';
                tempDChannelMAP.put('Mobile', wrapperMobile);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperDigital = tempDChannelMAP.get('Digital');
                wrapperDigital.bookedQ1 = wrapperDigital.bookedQ1 + mbg.Team_M_D_Booked_Actual__c;
                wrapperDigital.bookedTotal = wrapperDigital.bookedTotal + mbg.Team_M_D_Booked_Actual__c;
                wrapperDigital.bookedWgtQ1 = wrapperDigital.bookedWgtQ1 + mbg.Team_M_D_Booked_Proposal__c;
                wrapperDigital.bookedWgtTotal = wrapperDigital.bookedWgtTotal + mbg.Team_M_D_Booked_Proposal__c;
                wrapperDigital.bookedFullQ1 = wrapperDigital.bookedFullQ1 + mbg.Team_M_D_Booked_Full_Proposal__c;
                wrapperDigital.bookedFullTotal = wrapperDigital.bookedFullTotal + mbg.Team_M_D_Booked_Full_Proposal__c;
                wrapperDigital.dChannel = 'Digital';
                tempDChannelMAP.put('Digital', wrapperDigital);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperAudienceNetwork = tempDChannelMAP.get('Audience Network');
                wrapperAudienceNetwork.bookedQ1 = wrapperAudienceNetwork.bookedQ1 + mbg.Team_M_A_Booked_Actual__c;
                wrapperAudienceNetwork.bookedTotal = wrapperAudienceNetwork.bookedTotal + mbg.Team_M_A_Booked_Actual__c;
                wrapperAudienceNetwork.bookedWgtQ1 = wrapperAudienceNetwork.bookedWgtQ1 + mbg.Team_M_A_Booked_Proposal__c;
                wrapperAudienceNetwork.bookedWgtTotal = wrapperAudienceNetwork.bookedWgtTotal + mbg.Team_M_A_Booked_Proposal__c;
                wrapperAudienceNetwork.bookedFullQ1 = wrapperAudienceNetwork.bookedFullQ1 + mbg.Team_M_A_Booked_Full_Proposal__c;
                wrapperAudienceNetwork.bookedFullTotal = wrapperAudienceNetwork.bookedFullTotal + mbg.Team_M_A_Booked_Full_Proposal__c;
                wrapperAudienceNetwork.dChannel = 'Audience Network';
                tempDChannelMAP.put('Audience Network', wrapperAudienceNetwork);
            }
            if(mbg.Quarter__c != null && mbg.Quarter__c.startsWith('Q2')){
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperBase = tempDChannelMAP.get('Base');
                wrapperBase.bookedQ2 = wrapperBase.bookedQ2 + mbg.Team_M_B_Booked_Actual__c;
                wrapperBase.bookedTotal = wrapperBase.bookedTotal + mbg.Team_M_B_Booked_Actual__c;
                wrapperBase.bookedWgtQ2 = wrapperBase.bookedWgtQ2 + mbg.Team_M_B_Booked_Proposal__c;
                wrapperBase.bookedWgtTotal = wrapperBase.bookedWgtTotal + mbg.Team_M_B_Booked_Proposal__c;
                wrapperBase.bookedFullQ2 = wrapperBase.bookedFullQ2 + mbg.Team_M_B_Booked_Full_Proposal__c;
                wrapperBase.bookedFullTotal = wrapperBase.bookedFullTotal + mbg.Team_M_B_Booked_Full_Proposal__c;
                wrapperBase.dChannel = 'Base';
                tempDChannelMAP.put('Base', wrapperBase);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperMobile = tempDChannelMAP.get('Mobile');
                wrapperMobile.bookedQ2 = wrapperMobile.bookedQ2 + mbg.Team_M_M_Booked_Actual__c;
                wrapperMobile.bookedTotal = wrapperMobile.bookedTotal + mbg.Team_M_M_Booked_Actual__c;
                wrapperMobile.bookedWgtQ2 = wrapperMobile.bookedWgtQ2 + mbg.Team_M_M_Booked_Proposal__c;
                wrapperMobile.bookedWgtTotal = wrapperMobile.bookedWgtTotal + mbg.Team_M_M_Booked_Proposal__c;
                wrapperMobile.bookedFullQ2 = wrapperMobile.bookedFullQ2 + mbg.Team_M_M_Booked_Full_Proposal__c;
                wrapperMobile.bookedFullTotal = wrapperMobile.bookedFullTotal + mbg.Team_M_M_Booked_Full_Proposal__c;
                wrapperMobile.dChannel = 'Mobile';
                tempDChannelMAP.put('Mobile', wrapperMobile);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperDigital = tempDChannelMAP.get('Digital');
                wrapperDigital.bookedQ2 = wrapperDigital.bookedQ2 + mbg.Team_M_D_Booked_Actual__c;
                wrapperDigital.bookedTotal = wrapperDigital.bookedTotal + mbg.Team_M_D_Booked_Actual__c;
                wrapperDigital.bookedWgtQ2 = wrapperDigital.bookedWgtQ2 + mbg.Team_M_D_Booked_Proposal__c;
                wrapperDigital.bookedWgtTotal = wrapperDigital.bookedWgtTotal + mbg.Team_M_D_Booked_Proposal__c;
                wrapperDigital.bookedFullQ2 = wrapperDigital.bookedFullQ2 + mbg.Team_M_D_Booked_Full_Proposal__c;
                wrapperDigital.bookedFullTotal = wrapperDigital.bookedFullTotal + mbg.Team_M_D_Booked_Full_Proposal__c;
                wrapperDigital.dChannel = 'Digital';
                tempDChannelMAP.put('Digital', wrapperDigital);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperAudienceNetwork = tempDChannelMAP.get('Audience Network');
                wrapperAudienceNetwork.bookedQ2 = wrapperAudienceNetwork.bookedQ2 + mbg.Team_M_A_Booked_Actual__c;
                wrapperAudienceNetwork.bookedTotal = wrapperAudienceNetwork.bookedTotal + mbg.Team_M_A_Booked_Actual__c;
                wrapperAudienceNetwork.bookedWgtQ2 = wrapperAudienceNetwork.bookedWgtQ2 + mbg.Team_M_A_Booked_Proposal__c;
                wrapperAudienceNetwork.bookedWgtTotal = wrapperAudienceNetwork.bookedWgtTotal + mbg.Team_M_A_Booked_Proposal__c;
                wrapperAudienceNetwork.bookedFullQ2 = wrapperAudienceNetwork.bookedFullQ2 + mbg.Team_M_A_Booked_Full_Proposal__c;
                wrapperAudienceNetwork.bookedFullTotal = wrapperAudienceNetwork.bookedFullTotal + mbg.Team_M_A_Booked_Full_Proposal__c;
                wrapperAudienceNetwork.dChannel = 'Audience Network';
                tempDChannelMAP.put('Audience Network', wrapperAudienceNetwork);            
            }
            
            if(mbg.Quarter__c != null && mbg.Quarter__c.startsWith('Q3')){
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperBase = tempDChannelMAP.get('Base');
                wrapperBase.bookedQ3 = wrapperBase.bookedQ3 + mbg.Team_M_B_Booked_Actual__c;
                wrapperBase.bookedTotal = wrapperBase.bookedTotal + mbg.Team_M_B_Booked_Actual__c;
                wrapperBase.bookedWgtQ3 = wrapperBase.bookedWgtQ3 + mbg.Team_M_B_Booked_Proposal__c;
                wrapperBase.bookedWgtTotal = wrapperBase.bookedWgtTotal + mbg.Team_M_B_Booked_Proposal__c;
                wrapperBase.bookedFullQ3 = wrapperBase.bookedFullQ3 + mbg.Team_M_B_Booked_Full_Proposal__c;
                wrapperBase.bookedFullTotal = wrapperBase.bookedFullTotal + mbg.Team_M_B_Booked_Full_Proposal__c;
                wrapperBase.dChannel = 'Base';
                tempDChannelMAP.put('Base', wrapperBase);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperMobile = tempDChannelMAP.get('Mobile');
                wrapperMobile.bookedQ3 = wrapperMobile.bookedQ3 + mbg.Team_M_M_Booked_Actual__c;
                wrapperMobile.bookedTotal = wrapperMobile.bookedTotal + mbg.Team_M_M_Booked_Actual__c;
                wrapperMobile.bookedWgtQ3 = wrapperMobile.bookedWgtQ3 + mbg.Team_M_M_Booked_Proposal__c;
                wrapperMobile.bookedWgtTotal = wrapperMobile.bookedWgtTotal + mbg.Team_M_M_Booked_Proposal__c;
                wrapperMobile.bookedFullQ3 = wrapperMobile.bookedFullQ3 + mbg.Team_M_M_Booked_Full_Proposal__c;
                wrapperMobile.bookedFullTotal = wrapperMobile.bookedFullTotal + mbg.Team_M_M_Booked_Full_Proposal__c;
                wrapperMobile.dChannel = 'Mobile';
                tempDChannelMAP.put('Mobile', wrapperMobile);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperDigital = tempDChannelMAP.get('Digital');
                wrapperDigital.bookedQ3 = wrapperDigital.bookedQ3 + mbg.Team_M_D_Booked_Actual__c;
                wrapperDigital.bookedTotal = wrapperDigital.bookedTotal + mbg.Team_M_D_Booked_Actual__c;
                wrapperDigital.bookedWgtQ3 = wrapperDigital.bookedWgtQ3 + mbg.Team_M_D_Booked_Proposal__c;
                wrapperDigital.bookedWgtTotal = wrapperDigital.bookedWgtTotal + mbg.Team_M_D_Booked_Proposal__c;
                wrapperDigital.bookedFullQ3 = wrapperDigital.bookedFullQ3 + mbg.Team_M_D_Booked_Full_Proposal__c;
                wrapperDigital.bookedFullTotal = wrapperDigital.bookedFullTotal + mbg.Team_M_D_Booked_Full_Proposal__c;
                wrapperDigital.dChannel = 'Digital';
                tempDChannelMAP.put('Digital', wrapperDigital);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperAudienceNetwork = tempDChannelMAP.get('Audience Network');
                wrapperAudienceNetwork.bookedQ3 = wrapperAudienceNetwork.bookedQ3 + mbg.Team_M_A_Booked_Actual__c;
                wrapperAudienceNetwork.bookedTotal = wrapperAudienceNetwork.bookedTotal + mbg.Team_M_A_Booked_Actual__c;
                wrapperAudienceNetwork.bookedWgtQ3 = wrapperAudienceNetwork.bookedWgtQ3 + mbg.Team_M_A_Booked_Proposal__c;
                wrapperAudienceNetwork.bookedWgtTotal = wrapperAudienceNetwork.bookedWgtTotal + mbg.Team_M_A_Booked_Proposal__c;
                wrapperAudienceNetwork.bookedFullQ3 = wrapperAudienceNetwork.bookedFullQ3 + mbg.Team_M_A_Booked_Full_Proposal__c;
                wrapperAudienceNetwork.bookedFullTotal = wrapperAudienceNetwork.bookedFullTotal + mbg.Team_M_A_Booked_Full_Proposal__c;
                wrapperAudienceNetwork.dChannel = 'Audience Network';
                tempDChannelMAP.put('Audience Network', wrapperAudienceNetwork);
            }
            
            if(mbg.Quarter__c != null && mbg.Quarter__c.startsWith('Q4')){
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperBase = tempDChannelMAP.get('Base');
                wrapperBase.bookedQ4 = wrapperBase.bookedQ4 + mbg.Team_M_B_Booked_Actual__c;
                wrapperBase.bookedTotal = wrapperBase.bookedTotal + mbg.Team_M_B_Booked_Actual__c;
                wrapperBase.bookedWgtQ4 = wrapperBase.bookedWgtQ4 + mbg.Team_M_B_Booked_Proposal__c;
                wrapperBase.bookedWgtTotal = wrapperBase.bookedWgtTotal + mbg.Team_M_B_Booked_Proposal__c;
                wrapperBase.bookedFullQ4 = wrapperBase.bookedFullQ4 + mbg.Team_M_B_Booked_Full_Proposal__c;
                wrapperBase.bookedFullTotal = wrapperBase.bookedFullTotal + mbg.Team_M_B_Booked_Full_Proposal__c;
                wrapperBase.dChannel = 'Base';
                tempDChannelMAP.put('Base', wrapperBase);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperMobile = tempDChannelMAP.get('Mobile');
                wrapperMobile.bookedQ4 = wrapperMobile.bookedQ4 + mbg.Team_M_M_Booked_Actual__c;
                wrapperMobile.bookedTotal = wrapperMobile.bookedTotal + mbg.Team_M_M_Booked_Actual__c;
                wrapperMobile.bookedWgtQ4 = wrapperMobile.bookedWgtQ4 + mbg.Team_M_M_Booked_Proposal__c;
                wrapperMobile.bookedWgtTotal = wrapperMobile.bookedWgtTotal + mbg.Team_M_M_Booked_Proposal__c;
                wrapperMobile.bookedFullQ4 = wrapperMobile.bookedFullQ4 + mbg.Team_M_M_Booked_Full_Proposal__c;
                wrapperMobile.bookedFullTotal = wrapperMobile.bookedFullTotal + mbg.Team_M_M_Booked_Full_Proposal__c;
                wrapperMobile.dChannel = 'Mobile';
                tempDChannelMAP.put('Mobile', wrapperMobile);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperDigital = tempDChannelMAP.get('Digital');
                wrapperDigital.bookedQ4 = wrapperDigital.bookedQ4 + mbg.Team_M_D_Booked_Actual__c;
                wrapperDigital.bookedTotal = wrapperDigital.bookedTotal + mbg.Team_M_D_Booked_Actual__c;
                wrapperDigital.bookedWgtQ4 = wrapperDigital.bookedWgtQ4 + mbg.Team_M_D_Booked_Proposal__c;
                wrapperDigital.bookedWgtTotal = wrapperDigital.bookedWgtTotal + mbg.Team_M_D_Booked_Proposal__c;
                wrapperDigital.bookedFullQ4 = wrapperDigital.bookedFullQ4 + mbg.Team_M_D_Booked_Full_Proposal__c;
                wrapperDigital.bookedFullTotal = wrapperDigital.bookedFullTotal + mbg.Team_M_D_Booked_Full_Proposal__c;
                wrapperDigital.dChannel = 'Digital';
                tempDChannelMAP.put('Digital', wrapperDigital);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperAudienceNetwork = tempDChannelMAP.get('Audience Network');
                wrapperAudienceNetwork.bookedQ4 = wrapperAudienceNetwork.bookedQ4 + mbg.Team_M_A_Booked_Actual__c;
                wrapperAudienceNetwork.bookedTotal = wrapperAudienceNetwork.bookedTotal + mbg.Team_M_A_Booked_Actual__c;
                wrapperAudienceNetwork.bookedWgtQ4 = wrapperAudienceNetwork.bookedWgtQ4 + mbg.Team_M_A_Booked_Proposal__c;
                wrapperAudienceNetwork.bookedWgtTotal = wrapperAudienceNetwork.bookedWgtTotal + mbg.Team_M_A_Booked_Proposal__c;
                wrapperAudienceNetwork.bookedFullQ4 = wrapperAudienceNetwork.bookedFullQ4 + mbg.Team_M_A_Booked_Full_Proposal__c;
                wrapperAudienceNetwork.bookedFullTotal = wrapperAudienceNetwork.bookedFullTotal + mbg.Team_M_A_Booked_Full_Proposal__c;
                wrapperAudienceNetwork.dChannel = 'Audience Network';
                tempDChannelMAP.put('Audience Network', wrapperAudienceNetwork);   
            }
        }
        List<BestGuessRevenueUtil.DeliveryChannelWrapper> wrapperLst = tempDChannelMAP.values();
        return wrapperLst;
    }

    public Static List<BestGuessRevenueUtil.DeliveryChannelWrapper> getMBGRetailWrapper(List<Manager_Best_Guess__c> gmbgList){
        Map<String, BestGuessRevenueUtil.DeliveryChannelWrapper> tempDChannelMAP = new Map<String, BestGuessRevenueUtil.DeliveryChannelWrapper>();
        tempDChannelMAP.put('Base', new DeliveryChannelWrapper(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Base'));
        tempDChannelMAP.put('Mobile', new DeliveryChannelWrapper(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Mobile'));
        tempDChannelMAP.put('Digital', new DeliveryChannelWrapper(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Digital'));
        tempDChannelMAP.put('Audience Network', new DeliveryChannelWrapper(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Audience Network'));
        for(Manager_Best_Guess__c mbg : gmbgList){
            if(mbg.Quarter__c != null && mbg.Quarter__c.startsWith('Q1')){
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperBase = tempDChannelMAP.get('Base');
                wrapperBase.bookedQ1 = wrapperBase.bookedQ1 + mbg.Team_R_B_Booked_Actual__c;
                wrapperBase.bookedTotal = wrapperBase.bookedTotal + mbg.Team_R_B_Booked_Actual__c;
                wrapperBase.bookedWgtQ1 = wrapperBase.bookedWgtQ1 + mbg.Team_R_B_Booked_Proposal__c;
                wrapperBase.bookedWgtTotal = wrapperBase.bookedWgtTotal + mbg.Team_R_B_Booked_Proposal__c;
                wrapperBase.bookedFullQ1 = wrapperBase.bookedFullQ1 + mbg.Team_R_B_Booked_Full_Proposal__c;
                wrapperBase.bookedFullTotal = wrapperBase.bookedFullTotal + mbg.Team_R_B_Booked_Full_Proposal__c;
                wrapperBase.dChannel = 'Base';
                tempDChannelMAP.put('Base', wrapperBase);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperMobile = tempDChannelMAP.get('Mobile');
                wrapperMobile.bookedQ1 = wrapperMobile.bookedQ1 + mbg.Team_R_M_Booked_Actual__c;
                wrapperMobile.bookedTotal = wrapperMobile.bookedTotal + mbg.Team_R_M_Booked_Actual__c;
                wrapperMobile.bookedWgtQ1 = wrapperMobile.bookedWgtQ1 + mbg.Team_R_M_Booked_Proposal__c;
                wrapperMobile.bookedWgtTotal = wrapperMobile.bookedWgtTotal + mbg.Team_R_M_Booked_Proposal__c;
                wrapperMobile.bookedFullQ1 = wrapperMobile.bookedFullQ1 + mbg.Team_R_M_Booked_Full_Proposal__c;
                wrapperMobile.bookedFullTotal = wrapperMobile.bookedFullTotal + mbg.Team_R_M_Booked_Full_Proposal__c;
                wrapperMobile.dChannel = 'Mobile';
                tempDChannelMAP.put('Mobile', wrapperMobile);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperDigital = tempDChannelMAP.get('Digital');
                wrapperDigital.bookedQ1 = wrapperDigital.bookedQ1 + mbg.Team_R_D_Booked_Actual__c;
                wrapperDigital.bookedTotal = wrapperDigital.bookedTotal + mbg.Team_R_D_Booked_Actual__c;
                wrapperDigital.bookedWgtQ1 = wrapperDigital.bookedWgtQ1 + mbg.Team_R_D_Booked_Proposal__c;
                wrapperDigital.bookedWgtTotal = wrapperDigital.bookedWgtTotal + mbg.Team_R_D_Booked_Proposal__c;
                wrapperDigital.bookedFullQ1 = wrapperDigital.bookedFullQ1 + mbg.Team_R_D_Booked_Full_Proposal__c;
                wrapperDigital.bookedFullTotal = wrapperDigital.bookedFullTotal + mbg.Team_R_D_Booked_Full_Proposal__c;
                wrapperDigital.dChannel = 'Digital';
                tempDChannelMAP.put('Digital', wrapperDigital);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperAudienceNetwork = tempDChannelMAP.get('Audience Network');
                wrapperAudienceNetwork.bookedQ1 = wrapperAudienceNetwork.bookedQ1 + mbg.Team_R_A_Booked_Actual__c;
                wrapperAudienceNetwork.bookedTotal = wrapperAudienceNetwork.bookedTotal + mbg.Team_R_A_Booked_Actual__c;
                wrapperAudienceNetwork.bookedWgtQ1 = wrapperAudienceNetwork.bookedWgtQ1 + mbg.Team_R_A_Booked_Proposal__c;
                wrapperAudienceNetwork.bookedWgtTotal = wrapperAudienceNetwork.bookedWgtTotal + mbg.Team_R_A_Booked_Proposal__c;
                wrapperAudienceNetwork.bookedFullQ1 = wrapperAudienceNetwork.bookedFullQ1 + mbg.Team_R_A_Booked_Full_Proposal__c;
                wrapperAudienceNetwork.bookedFullTotal = wrapperAudienceNetwork.bookedFullTotal + mbg.Team_R_A_Booked_Full_Proposal__c;
                wrapperAudienceNetwork.dChannel = 'Audience Network';
                tempDChannelMAP.put('Audience Network', wrapperAudienceNetwork);
            }
            if(mbg.Quarter__c != null && mbg.Quarter__c.startsWith('Q2')){
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperBase = tempDChannelMAP.get('Base');
                wrapperBase.bookedQ2 = wrapperBase.bookedQ2 + mbg.Team_R_B_Booked_Actual__c;
                wrapperBase.bookedTotal = wrapperBase.bookedTotal + mbg.Team_R_B_Booked_Actual__c;
                wrapperBase.bookedWgtQ2 = wrapperBase.bookedWgtQ2 + mbg.Team_R_B_Booked_Proposal__c;
                wrapperBase.bookedWgtTotal = wrapperBase.bookedWgtTotal + mbg.Team_R_B_Booked_Proposal__c;
                wrapperBase.bookedFullQ2 = wrapperBase.bookedFullQ2 + mbg.Team_R_B_Booked_Full_Proposal__c;
                wrapperBase.bookedFullTotal = wrapperBase.bookedFullTotal + mbg.Team_R_B_Booked_Full_Proposal__c;
                wrapperBase.dChannel = 'Base';
                tempDChannelMAP.put('Base', wrapperBase);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperMobile = tempDChannelMAP.get('Mobile');
                wrapperMobile.bookedQ2 = wrapperMobile.bookedQ2 + mbg.Team_R_M_Booked_Actual__c;
                wrapperMobile.bookedTotal = wrapperMobile.bookedTotal + mbg.Team_R_M_Booked_Actual__c;
                wrapperMobile.bookedWgtQ2 = wrapperMobile.bookedWgtQ2 + mbg.Team_R_M_Booked_Proposal__c;
                wrapperMobile.bookedWgtTotal = wrapperMobile.bookedWgtTotal + mbg.Team_R_M_Booked_Proposal__c;
                wrapperMobile.bookedFullQ2 = wrapperMobile.bookedFullQ2 + mbg.Team_R_M_Booked_Full_Proposal__c;
                wrapperMobile.bookedFullTotal = wrapperMobile.bookedFullTotal + mbg.Team_R_M_Booked_Full_Proposal__c;
                wrapperMobile.dChannel = 'Mobile';
                tempDChannelMAP.put('Mobile', wrapperMobile);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperDigital = tempDChannelMAP.get('Digital');
                wrapperDigital.bookedQ2 = wrapperDigital.bookedQ2 + mbg.Team_R_D_Booked_Actual__c;
                wrapperDigital.bookedTotal = wrapperDigital.bookedTotal + mbg.Team_R_D_Booked_Actual__c;
                wrapperDigital.bookedWgtQ2 = wrapperDigital.bookedWgtQ2 + mbg.Team_R_D_Booked_Proposal__c;
                wrapperDigital.bookedWgtTotal = wrapperDigital.bookedWgtTotal + mbg.Team_R_D_Booked_Proposal__c;
                wrapperDigital.bookedFullQ2 = wrapperDigital.bookedFullQ2 + mbg.Team_R_D_Booked_Full_Proposal__c;
                wrapperDigital.bookedFullTotal = wrapperDigital.bookedFullTotal + mbg.Team_R_D_Booked_Full_Proposal__c;
                wrapperDigital.dChannel = 'Digital';
                tempDChannelMAP.put('Digital', wrapperDigital);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperAudienceNetwork = tempDChannelMAP.get('Audience Network');
                wrapperAudienceNetwork.bookedQ2 = wrapperAudienceNetwork.bookedQ2 + mbg.Team_R_A_Booked_Actual__c;
                wrapperAudienceNetwork.bookedTotal = wrapperAudienceNetwork.bookedTotal + mbg.Team_R_A_Booked_Actual__c;
                wrapperAudienceNetwork.bookedWgtQ2 = wrapperAudienceNetwork.bookedWgtQ2 + mbg.Team_R_A_Booked_Proposal__c;
                wrapperAudienceNetwork.bookedWgtTotal = wrapperAudienceNetwork.bookedWgtTotal + mbg.Team_R_A_Booked_Proposal__c;
                wrapperAudienceNetwork.bookedFullQ2 = wrapperAudienceNetwork.bookedFullQ2 + mbg.Team_R_A_Booked_Full_Proposal__c;
                wrapperAudienceNetwork.bookedFullTotal = wrapperAudienceNetwork.bookedFullTotal + mbg.Team_R_A_Booked_Full_Proposal__c;
                wrapperAudienceNetwork.dChannel = 'Audience Network';
                tempDChannelMAP.put('Audience Network', wrapperAudienceNetwork);            
            }
            
            if(mbg.Quarter__c != null && mbg.Quarter__c.startsWith('Q3')){
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperBase = tempDChannelMAP.get('Base');
                wrapperBase.bookedQ3 = wrapperBase.bookedQ3 + mbg.Team_R_B_Booked_Actual__c;
                wrapperBase.bookedTotal = wrapperBase.bookedTotal + mbg.Team_R_B_Booked_Actual__c;
                wrapperBase.bookedWgtQ3 = wrapperBase.bookedWgtQ3 + mbg.Team_R_B_Booked_Proposal__c;
                wrapperBase.bookedWgtTotal = wrapperBase.bookedWgtTotal + mbg.Team_R_B_Booked_Proposal__c;
                wrapperBase.bookedFullQ3 = wrapperBase.bookedFullQ3 + mbg.Team_R_B_Booked_Full_Proposal__c;
                wrapperBase.bookedFullTotal = wrapperBase.bookedFullTotal + mbg.Team_R_B_Booked_Full_Proposal__c;
                wrapperBase.dChannel = 'Base';
                tempDChannelMAP.put('Base', wrapperBase);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperMobile = tempDChannelMAP.get('Mobile');
                wrapperMobile.bookedQ3 = wrapperMobile.bookedQ3 + mbg.Team_R_M_Booked_Actual__c;
                wrapperMobile.bookedTotal = wrapperMobile.bookedTotal + mbg.Team_R_M_Booked_Actual__c;
                wrapperMobile.bookedWgtQ3 = wrapperMobile.bookedWgtQ3 + mbg.Team_R_M_Booked_Proposal__c;
                wrapperMobile.bookedWgtTotal = wrapperMobile.bookedWgtTotal + mbg.Team_R_M_Booked_Proposal__c;
                wrapperMobile.bookedFullQ3 = wrapperMobile.bookedFullQ3 + mbg.Team_R_M_Booked_Full_Proposal__c;
                wrapperMobile.bookedFullTotal = wrapperMobile.bookedFullTotal + mbg.Team_R_M_Booked_Full_Proposal__c;
                wrapperMobile.dChannel = 'Mobile';
                tempDChannelMAP.put('Mobile', wrapperMobile);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperDigital = tempDChannelMAP.get('Digital');
                wrapperDigital.bookedQ3 = wrapperDigital.bookedQ3 + mbg.Team_R_D_Booked_Actual__c;
                wrapperDigital.bookedTotal = wrapperDigital.bookedTotal + mbg.Team_R_D_Booked_Actual__c;
                wrapperDigital.bookedWgtQ3 = wrapperDigital.bookedWgtQ3 + mbg.Team_R_D_Booked_Proposal__c;
                wrapperDigital.bookedWgtTotal = wrapperDigital.bookedWgtTotal + mbg.Team_R_D_Booked_Proposal__c;
                wrapperDigital.bookedFullQ3 = wrapperDigital.bookedFullQ3 + mbg.Team_R_D_Booked_Full_Proposal__c;
                wrapperDigital.bookedFullTotal = wrapperDigital.bookedFullTotal + mbg.Team_R_D_Booked_Full_Proposal__c;
                wrapperDigital.dChannel = 'Digital';
                tempDChannelMAP.put('Digital', wrapperDigital);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperAudienceNetwork = tempDChannelMAP.get('Audience Network');
                wrapperAudienceNetwork.bookedQ3 = wrapperAudienceNetwork.bookedQ3 + mbg.Team_R_A_Booked_Actual__c;
                wrapperAudienceNetwork.bookedTotal = wrapperAudienceNetwork.bookedTotal + mbg.Team_R_A_Booked_Actual__c;
                wrapperAudienceNetwork.bookedWgtQ3 = wrapperAudienceNetwork.bookedWgtQ3 + mbg.Team_R_A_Booked_Proposal__c;
                wrapperAudienceNetwork.bookedWgtTotal = wrapperAudienceNetwork.bookedWgtTotal + mbg.Team_R_A_Booked_Proposal__c;
                wrapperAudienceNetwork.bookedFullQ3 = wrapperAudienceNetwork.bookedFullQ3 + mbg.Team_R_A_Booked_Full_Proposal__c;
                wrapperAudienceNetwork.bookedFullTotal = wrapperAudienceNetwork.bookedFullTotal + mbg.Team_R_A_Booked_Full_Proposal__c;
                wrapperAudienceNetwork.dChannel = 'Audience Network';
                tempDChannelMAP.put('Audience Network', wrapperAudienceNetwork);
            }
            
            if(mbg.Quarter__c != null && mbg.Quarter__c.startsWith('Q4')){
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperBase = tempDChannelMAP.get('Base');
                wrapperBase.bookedQ4 = wrapperBase.bookedQ4 + mbg.Team_R_B_Booked_Actual__c;
                wrapperBase.bookedTotal = wrapperBase.bookedTotal + mbg.Team_R_B_Booked_Actual__c;
                wrapperBase.bookedWgtQ4 = wrapperBase.bookedWgtQ4 + mbg.Team_R_B_Booked_Proposal__c;
                wrapperBase.bookedWgtTotal = wrapperBase.bookedWgtTotal + mbg.Team_R_B_Booked_Proposal__c;
                wrapperBase.bookedFullQ4 = wrapperBase.bookedFullQ4 + mbg.Team_R_B_Booked_Full_Proposal__c;
                wrapperBase.bookedFullTotal = wrapperBase.bookedFullTotal + mbg.Team_R_B_Booked_Full_Proposal__c;
                wrapperBase.dChannel = 'Base';
                tempDChannelMAP.put('Base', wrapperBase);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperMobile = tempDChannelMAP.get('Mobile');
                wrapperMobile.bookedQ4 = wrapperMobile.bookedQ4 + mbg.Team_R_M_Booked_Actual__c;
                wrapperMobile.bookedTotal = wrapperMobile.bookedTotal + mbg.Team_R_M_Booked_Actual__c;
                wrapperMobile.bookedWgtQ4 = wrapperMobile.bookedWgtQ4 + mbg.Team_R_M_Booked_Proposal__c;
                wrapperMobile.bookedWgtTotal = wrapperMobile.bookedWgtTotal + mbg.Team_R_M_Booked_Proposal__c;
                wrapperMobile.bookedFullQ4 = wrapperMobile.bookedFullQ4 + mbg.Team_R_M_Booked_Full_Proposal__c;
                wrapperMobile.bookedFullTotal = wrapperMobile.bookedFullTotal + mbg.Team_R_M_Booked_Full_Proposal__c;
                wrapperMobile.dChannel = 'Mobile';
                tempDChannelMAP.put('Mobile', wrapperMobile);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperDigital = tempDChannelMAP.get('Digital');
                wrapperDigital.bookedQ4 = wrapperDigital.bookedQ4 + mbg.Team_R_D_Booked_Actual__c;
                wrapperDigital.bookedTotal = wrapperDigital.bookedTotal + mbg.Team_R_D_Booked_Actual__c;
                wrapperDigital.bookedWgtQ4 = wrapperDigital.bookedWgtQ4 + mbg.Team_R_D_Booked_Proposal__c;
                wrapperDigital.bookedWgtTotal = wrapperDigital.bookedWgtTotal + mbg.Team_R_D_Booked_Proposal__c;
                wrapperDigital.bookedFullQ4 = wrapperDigital.bookedFullQ4 + mbg.Team_R_D_Booked_Full_Proposal__c;
                wrapperDigital.bookedFullTotal = wrapperDigital.bookedFullTotal + mbg.Team_R_D_Booked_Full_Proposal__c;
                wrapperDigital.dChannel = 'Digital';
                tempDChannelMAP.put('Digital', wrapperDigital);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperAudienceNetwork = tempDChannelMAP.get('Audience Network');
                wrapperAudienceNetwork.bookedQ4 = wrapperAudienceNetwork.bookedQ4 + mbg.Team_R_A_Booked_Actual__c;
                wrapperAudienceNetwork.bookedTotal = wrapperAudienceNetwork.bookedTotal + mbg.Team_R_A_Booked_Actual__c;
                wrapperAudienceNetwork.bookedWgtQ4 = wrapperAudienceNetwork.bookedWgtQ4 + mbg.Team_R_A_Booked_Proposal__c;
                wrapperAudienceNetwork.bookedWgtTotal = wrapperAudienceNetwork.bookedWgtTotal + mbg.Team_R_A_Booked_Proposal__c;
                wrapperAudienceNetwork.bookedFullQ4 = wrapperAudienceNetwork.bookedFullQ4 + mbg.Team_R_A_Booked_Full_Proposal__c;
                wrapperAudienceNetwork.bookedFullTotal = wrapperAudienceNetwork.bookedFullTotal + mbg.Team_R_A_Booked_Full_Proposal__c;
                wrapperAudienceNetwork.dChannel = 'Audience Network';
                tempDChannelMAP.put('Audience Network', wrapperAudienceNetwork);   
            }
        }
        List<BestGuessRevenueUtil.DeliveryChannelWrapper> wrapperLst = tempDChannelMAP.values();
        return wrapperLst;
    }
    
    public Static List<BestGuessRevenueUtil.DeliveryChannelWrapper> getSRBGManufacturerWrapper(List<Sales_Rep_Best_Guess__c> gsrbgList){
        Map<String, BestGuessRevenueUtil.DeliveryChannelWrapper> tempDChannelMAP = new Map<String, BestGuessRevenueUtil.DeliveryChannelWrapper>();
        tempDChannelMAP.put('Base', new DeliveryChannelWrapper(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Base'));
        tempDChannelMAP.put('Mobile', new DeliveryChannelWrapper(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Mobile'));
        tempDChannelMAP.put('Digital', new DeliveryChannelWrapper(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Digital'));
        tempDChannelMAP.put('Audience Network', new DeliveryChannelWrapper(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Audience Network'));
        for(Sales_Rep_Best_Guess__c sbg : gsrbgList){
            if(sbg.Quarter__c != null && sbg.Quarter__c.startsWith('Q1')){
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperBase = tempDChannelMAP.get('Base');
                wrapperBase.bookedQ1 = wrapperBase.bookedQ1 + sbg.M_B_Booked_Actual__c;
                wrapperBase.bookedTotal = wrapperBase.bookedTotal + sbg.M_B_Booked_Actual__c;
                wrapperBase.bookedWgtQ1 = wrapperBase.bookedWgtQ1 + sbg.M_B_Booked_Proposal__c;
                wrapperBase.bookedWgtTotal = wrapperBase.bookedWgtTotal + sbg.M_B_Booked_Proposal__c;
                wrapperBase.bookedFullQ1 = wrapperBase.bookedFullQ1 + sbg.M_B_Booked_Full_Proposal__c;
                wrapperBase.bookedFullTotal = wrapperBase.bookedFullTotal + sbg.M_B_Booked_Full_Proposal__c;
                wrapperBase.dChannel = 'Base';
                tempDChannelMAP.put('Base', wrapperBase);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperMobile = tempDChannelMAP.get('Mobile');
                wrapperMobile.bookedQ1 = wrapperMobile.bookedQ1 + sbg.M_M_Booked_Actual__c;
                wrapperMobile.bookedTotal = wrapperMobile.bookedTotal + sbg.M_M_Booked_Actual__c;
                wrapperMobile.bookedWgtQ1 = wrapperMobile.bookedWgtQ1 + sbg.M_M_Booked_Proposal__c;
                wrapperMobile.bookedWgtTotal = wrapperMobile.bookedWgtTotal + sbg.M_M_Booked_Proposal__c;
                wrapperMobile.bookedFullQ1 = wrapperMobile.bookedFullQ1 + sbg.M_M_Booked_Full_Proposal__c;
                wrapperMobile.bookedFullTotal = wrapperMobile.bookedFullTotal + sbg.M_M_Booked_Full_Proposal__c;
                wrapperMobile.dChannel = 'Mobile';
                tempDChannelMAP.put('Mobile', wrapperMobile);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperDigital = tempDChannelMAP.get('Digital');
                wrapperDigital.bookedQ1 = wrapperDigital.bookedQ1 + sbg.M_D_Booked_Actual__c;
                wrapperDigital.bookedTotal = wrapperDigital.bookedTotal + sbg.M_D_Booked_Actual__c;
                wrapperDigital.bookedWgtQ1 = wrapperDigital.bookedWgtQ1 + sbg.M_D_Booked_Proposal__c;
                wrapperDigital.bookedWgtTotal = wrapperDigital.bookedWgtTotal + sbg.M_D_Booked_Proposal__c;
                wrapperDigital.bookedFullQ1 = wrapperDigital.bookedFullQ1 + sbg.M_D_Booked_Full_Proposal__c;
                wrapperDigital.bookedFullTotal = wrapperDigital.bookedFullTotal + sbg.M_D_Booked_Full_Proposal__c;
                wrapperDigital.dChannel = 'Digital';
                tempDChannelMAP.put('Digital', wrapperDigital);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperAudienceNetwork = tempDChannelMAP.get('Audience Network');
                wrapperAudienceNetwork.bookedQ1 = wrapperAudienceNetwork.bookedQ1 + sbg.M_A_Booked_Actual__c;
                wrapperAudienceNetwork.bookedTotal = wrapperAudienceNetwork.bookedTotal + sbg.M_A_Booked_Actual__c;
                wrapperAudienceNetwork.bookedWgtQ1 = wrapperAudienceNetwork.bookedWgtQ1 + sbg.M_A_Booked_Proposal__c;
                wrapperAudienceNetwork.bookedWgtTotal = wrapperAudienceNetwork.bookedWgtTotal + sbg.M_A_Booked_Proposal__c;
                wrapperAudienceNetwork.bookedFullQ1 = wrapperAudienceNetwork.bookedFullQ1 + sbg.M_A_Booked_Full_Proposal__c;
                wrapperAudienceNetwork.bookedFullTotal = wrapperAudienceNetwork.bookedFullTotal + sbg.M_A_Booked_Full_Proposal__c;
                wrapperAudienceNetwork.dChannel = 'Audience Network';
                tempDChannelMAP.put('Audience Network', wrapperAudienceNetwork);
            }
            if(sbg.Quarter__c != null && sbg.Quarter__c.startsWith('Q2')){
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperBase = tempDChannelMAP.get('Base');
                wrapperBase.bookedQ2 = wrapperBase.bookedQ2 + sbg.M_B_Booked_Actual__c;
                wrapperBase.bookedTotal = wrapperBase.bookedTotal + sbg.M_B_Booked_Actual__c;
                wrapperBase.bookedWgtQ2 = wrapperBase.bookedWgtQ2 + sbg.M_B_Booked_Proposal__c;
                wrapperBase.bookedWgtTotal = wrapperBase.bookedWgtTotal + sbg.M_B_Booked_Proposal__c;
                wrapperBase.bookedFullQ2 = wrapperBase.bookedFullQ2 + sbg.M_B_Booked_Full_Proposal__c;
                wrapperBase.bookedFullTotal = wrapperBase.bookedFullTotal + sbg.M_B_Booked_Full_Proposal__c;
                wrapperBase.dChannel = 'Base';
                tempDChannelMAP.put('Base', wrapperBase);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperMobile = tempDChannelMAP.get('Mobile');
                wrapperMobile.bookedQ2 = wrapperMobile.bookedQ2 + sbg.M_M_Booked_Actual__c;
                wrapperMobile.bookedTotal = wrapperMobile.bookedTotal + sbg.M_M_Booked_Actual__c;
                wrapperMobile.bookedWgtQ2 = wrapperMobile.bookedWgtQ2 + sbg.M_M_Booked_Proposal__c;
                wrapperMobile.bookedWgtTotal = wrapperMobile.bookedWgtTotal + sbg.M_M_Booked_Proposal__c;
                wrapperMobile.bookedFullQ2 = wrapperMobile.bookedFullQ2 + sbg.M_M_Booked_Full_Proposal__c;
                wrapperMobile.bookedFullTotal = wrapperMobile.bookedFullTotal + sbg.M_M_Booked_Full_Proposal__c;
                wrapperMobile.dChannel = 'Mobile';
                tempDChannelMAP.put('Mobile', wrapperMobile);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperDigital = tempDChannelMAP.get('Digital');
                wrapperDigital.bookedQ2 = wrapperDigital.bookedQ2 + sbg.M_D_Booked_Actual__c;
                wrapperDigital.bookedTotal = wrapperDigital.bookedTotal + sbg.M_D_Booked_Actual__c;
                wrapperDigital.bookedWgtQ2 = wrapperDigital.bookedWgtQ2 + sbg.M_D_Booked_Proposal__c;
                wrapperDigital.bookedWgtTotal = wrapperDigital.bookedWgtTotal + sbg.M_D_Booked_Proposal__c;
                wrapperDigital.bookedFullQ2 = wrapperDigital.bookedFullQ2 + sbg.M_D_Booked_Full_Proposal__c;
                wrapperDigital.bookedFullTotal = wrapperDigital.bookedFullTotal + sbg.M_D_Booked_Full_Proposal__c;
                wrapperDigital.dChannel = 'Digital';
                tempDChannelMAP.put('Digital', wrapperDigital);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperAudienceNetwork = tempDChannelMAP.get('Audience Network');
                wrapperAudienceNetwork.bookedQ2 = wrapperAudienceNetwork.bookedQ2 + sbg.M_A_Booked_Actual__c;
                wrapperAudienceNetwork.bookedTotal = wrapperAudienceNetwork.bookedTotal + sbg.M_A_Booked_Actual__c;
                wrapperAudienceNetwork.bookedWgtQ2 = wrapperAudienceNetwork.bookedWgtQ2 + sbg.M_A_Booked_Proposal__c;
                wrapperAudienceNetwork.bookedWgtTotal = wrapperAudienceNetwork.bookedWgtTotal + sbg.M_A_Booked_Proposal__c;
                wrapperAudienceNetwork.bookedFullQ2 = wrapperAudienceNetwork.bookedFullQ2 + sbg.M_A_Booked_Full_Proposal__c;
                wrapperAudienceNetwork.bookedFullTotal = wrapperAudienceNetwork.bookedFullTotal + sbg.M_A_Booked_Full_Proposal__c;
                wrapperAudienceNetwork.dChannel = 'Audience Network';
                tempDChannelMAP.put('Audience Network', wrapperAudienceNetwork);            
            }
            
            if(sbg.Quarter__c != null && sbg.Quarter__c.startsWith('Q3')){
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperBase = tempDChannelMAP.get('Base');
                wrapperBase.bookedQ3 = wrapperBase.bookedQ3 + sbg.M_B_Booked_Actual__c;
                wrapperBase.bookedTotal = wrapperBase.bookedTotal + sbg.M_B_Booked_Actual__c;
                wrapperBase.bookedWgtQ3 = wrapperBase.bookedWgtQ3 + sbg.M_B_Booked_Proposal__c;
                wrapperBase.bookedWgtTotal = wrapperBase.bookedWgtTotal + sbg.M_B_Booked_Proposal__c;
                wrapperBase.bookedFullQ3 = wrapperBase.bookedFullQ3 + sbg.M_B_Booked_Full_Proposal__c;
                wrapperBase.bookedFullTotal = wrapperBase.bookedFullTotal + sbg.M_B_Booked_Full_Proposal__c;
                wrapperBase.dChannel = 'Base';
                tempDChannelMAP.put('Base', wrapperBase);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperMobile = tempDChannelMAP.get('Mobile');
                wrapperMobile.bookedQ3 = wrapperMobile.bookedQ3 + sbg.M_M_Booked_Actual__c;
                wrapperMobile.bookedTotal = wrapperMobile.bookedTotal + sbg.M_M_Booked_Actual__c;
                wrapperMobile.bookedWgtQ3 = wrapperMobile.bookedWgtQ3 + sbg.M_M_Booked_Proposal__c;
                wrapperMobile.bookedWgtTotal = wrapperMobile.bookedWgtTotal + sbg.M_M_Booked_Proposal__c;
                wrapperMobile.bookedFullQ3 = wrapperMobile.bookedFullQ3 + sbg.M_M_Booked_Full_Proposal__c;
                wrapperMobile.bookedFullTotal = wrapperMobile.bookedFullTotal + sbg.M_M_Booked_Full_Proposal__c;
                wrapperMobile.dChannel = 'Mobile';
                tempDChannelMAP.put('Mobile', wrapperMobile);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperDigital = tempDChannelMAP.get('Digital');
                wrapperDigital.bookedQ3 = wrapperDigital.bookedQ3 + sbg.M_D_Booked_Actual__c;
                wrapperDigital.bookedTotal = wrapperDigital.bookedTotal + sbg.M_D_Booked_Actual__c;
                wrapperDigital.bookedWgtQ3 = wrapperDigital.bookedWgtQ3 + sbg.M_D_Booked_Proposal__c;
                wrapperDigital.bookedWgtTotal = wrapperDigital.bookedWgtTotal + sbg.M_D_Booked_Proposal__c;
                wrapperDigital.bookedFullQ3 = wrapperDigital.bookedFullQ3 + sbg.M_D_Booked_Full_Proposal__c;
                wrapperDigital.bookedFullTotal = wrapperDigital.bookedFullTotal + sbg.M_D_Booked_Full_Proposal__c;
                wrapperDigital.dChannel = 'Digital';
                tempDChannelMAP.put('Digital', wrapperDigital);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperAudienceNetwork = tempDChannelMAP.get('Audience Network');
                wrapperAudienceNetwork.bookedQ3 = wrapperAudienceNetwork.bookedQ3 + sbg.M_A_Booked_Actual__c;
                wrapperAudienceNetwork.bookedTotal = wrapperAudienceNetwork.bookedTotal + sbg.M_A_Booked_Actual__c;
                wrapperAudienceNetwork.bookedWgtQ3 = wrapperAudienceNetwork.bookedWgtQ3 + sbg.M_A_Booked_Proposal__c;
                wrapperAudienceNetwork.bookedWgtTotal = wrapperAudienceNetwork.bookedWgtTotal + sbg.M_A_Booked_Proposal__c;
                wrapperAudienceNetwork.bookedFullQ3 = wrapperAudienceNetwork.bookedFullQ3 + sbg.M_A_Booked_Full_Proposal__c;
                wrapperAudienceNetwork.bookedFullTotal = wrapperAudienceNetwork.bookedFullTotal + sbg.M_A_Booked_Full_Proposal__c;
                wrapperAudienceNetwork.dChannel = 'Audience Network';
                tempDChannelMAP.put('Audience Network', wrapperAudienceNetwork);
            }
            
            if(sbg.Quarter__c != null && sbg.Quarter__c.startsWith('Q4')){
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperBase = tempDChannelMAP.get('Base');
                wrapperBase.bookedQ4 = wrapperBase.bookedQ4 + sbg.M_B_Booked_Actual__c;
                wrapperBase.bookedTotal = wrapperBase.bookedTotal + sbg.M_B_Booked_Actual__c;
                wrapperBase.bookedWgtQ4 = wrapperBase.bookedWgtQ4 + sbg.M_B_Booked_Proposal__c;
                wrapperBase.bookedWgtTotal = wrapperBase.bookedWgtTotal + sbg.M_B_Booked_Proposal__c;
                wrapperBase.bookedFullQ4 = wrapperBase.bookedFullQ4 + sbg.M_B_Booked_Full_Proposal__c;
                wrapperBase.bookedFullTotal = wrapperBase.bookedFullTotal + sbg.M_B_Booked_Full_Proposal__c;
                wrapperBase.dChannel = 'Base';
                tempDChannelMAP.put('Base', wrapperBase);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperMobile = tempDChannelMAP.get('Mobile');
                wrapperMobile.bookedQ4 = wrapperMobile.bookedQ4 + sbg.M_M_Booked_Actual__c;
                wrapperMobile.bookedTotal = wrapperMobile.bookedTotal + sbg.M_M_Booked_Actual__c;
                wrapperMobile.bookedWgtQ4 = wrapperMobile.bookedWgtQ4 + sbg.M_M_Booked_Proposal__c;
                wrapperMobile.bookedWgtTotal = wrapperMobile.bookedWgtTotal + sbg.M_M_Booked_Proposal__c;
                wrapperMobile.bookedFullQ4 = wrapperMobile.bookedFullQ4 + sbg.M_M_Booked_Full_Proposal__c;
                wrapperMobile.bookedFullTotal = wrapperMobile.bookedFullTotal + sbg.M_M_Booked_Full_Proposal__c;
                wrapperMobile.dChannel = 'Mobile';
                tempDChannelMAP.put('Mobile', wrapperMobile);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperDigital = tempDChannelMAP.get('Digital');
                wrapperDigital.bookedQ4 = wrapperDigital.bookedQ4 + sbg.M_D_Booked_Actual__c;
                wrapperDigital.bookedTotal = wrapperDigital.bookedTotal + sbg.M_D_Booked_Actual__c;
                wrapperDigital.bookedWgtQ4 = wrapperDigital.bookedWgtQ4 + sbg.M_D_Booked_Proposal__c;
                wrapperDigital.bookedWgtTotal = wrapperDigital.bookedWgtTotal + sbg.M_D_Booked_Proposal__c;
                wrapperDigital.bookedFullQ4 = wrapperDigital.bookedFullQ4 + sbg.M_D_Booked_Full_Proposal__c;
                wrapperDigital.bookedFullTotal = wrapperDigital.bookedFullTotal + sbg.M_D_Booked_Full_Proposal__c;
                wrapperDigital.dChannel = 'Digital';
                tempDChannelMAP.put('Digital', wrapperDigital);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperAudienceNetwork = tempDChannelMAP.get('Audience Network');
                wrapperAudienceNetwork.bookedQ4 = wrapperAudienceNetwork.bookedQ4 + sbg.M_A_Booked_Actual__c;
                wrapperAudienceNetwork.bookedTotal = wrapperAudienceNetwork.bookedTotal + sbg.M_A_Booked_Actual__c;
                wrapperAudienceNetwork.bookedWgtQ4 = wrapperAudienceNetwork.bookedWgtQ4 + sbg.M_A_Booked_Proposal__c;
                wrapperAudienceNetwork.bookedWgtTotal = wrapperAudienceNetwork.bookedWgtTotal + sbg.M_A_Booked_Proposal__c;
                wrapperAudienceNetwork.bookedFullQ4 = wrapperAudienceNetwork.bookedFullQ4 + sbg.M_A_Booked_Full_Proposal__c;
                wrapperAudienceNetwork.bookedFullTotal = wrapperAudienceNetwork.bookedFullTotal + sbg.M_A_Booked_Full_Proposal__c;
                wrapperAudienceNetwork.dChannel = 'Audience Network';
                tempDChannelMAP.put('Audience Network', wrapperAudienceNetwork);   
            }
        }
        List<BestGuessRevenueUtil.DeliveryChannelWrapper> wrapperLst = tempDChannelMAP.values();
        return wrapperLst;
    }
    
    public Static List<BestGuessRevenueUtil.DeliveryChannelWrapper> getSRBGRetailWrapper(List<Sales_Rep_Best_Guess__c> gsrbgList){
        Map<String, BestGuessRevenueUtil.DeliveryChannelWrapper> tempDChannelMAP = new Map<String, BestGuessRevenueUtil.DeliveryChannelWrapper>();
        tempDChannelMAP.put('Base', new DeliveryChannelWrapper(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Base'));
        tempDChannelMAP.put('Mobile', new DeliveryChannelWrapper(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Mobile'));
        tempDChannelMAP.put('Digital', new DeliveryChannelWrapper(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Digital'));
        tempDChannelMAP.put('Audience Network', new DeliveryChannelWrapper(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Audience Network'));
        for(Sales_Rep_Best_Guess__c sbg : gsrbgList){
            if(sbg.Quarter__c != null && sbg.Quarter__c.startsWith('Q1')){
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperBase = tempDChannelMAP.get('Base');
                wrapperBase.bookedQ1 = wrapperBase.bookedQ1 + sbg.R_B_Booked_Actual__c;
                wrapperBase.bookedTotal = wrapperBase.bookedTotal + sbg.R_B_Booked_Actual__c;
                wrapperBase.bookedWgtQ1 = wrapperBase.bookedWgtQ1 + sbg.R_B_Booked_Proposal__c;
                wrapperBase.bookedWgtTotal = wrapperBase.bookedWgtTotal + sbg.R_B_Booked_Proposal__c;
                wrapperBase.bookedFullQ1 = wrapperBase.bookedFullQ1 + sbg.R_B_Booked_Full_Proposal__c;
                wrapperBase.bookedFullTotal = wrapperBase.bookedFullTotal + sbg.R_B_Booked_Full_Proposal__c;
                wrapperBase.dChannel = 'Base';
                tempDChannelMAP.put('Base', wrapperBase);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperMobile = tempDChannelMAP.get('Mobile');
                wrapperMobile.bookedQ1 = wrapperMobile.bookedQ1 + sbg.R_M_Booked_Actual__c;
                wrapperMobile.bookedTotal = wrapperMobile.bookedTotal + sbg.R_M_Booked_Actual__c;
                wrapperMobile.bookedWgtQ1 = wrapperMobile.bookedWgtQ1 + sbg.R_M_Booked_Proposal__c;
                wrapperMobile.bookedWgtTotal = wrapperMobile.bookedWgtTotal + sbg.R_M_Booked_Proposal__c;
                wrapperMobile.bookedFullQ1 = wrapperMobile.bookedFullQ1 + sbg.R_M_Booked_Full_Proposal__c;
                wrapperMobile.bookedFullTotal = wrapperMobile.bookedFullTotal + sbg.R_M_Booked_Full_Proposal__c;
                wrapperMobile.dChannel = 'Mobile';
                tempDChannelMAP.put('Mobile', wrapperMobile);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperDigital = tempDChannelMAP.get('Digital');
                wrapperDigital.bookedQ1 = wrapperDigital.bookedQ1 + sbg.R_D_Booked_Actual__c;
                wrapperDigital.bookedTotal = wrapperDigital.bookedTotal + sbg.R_D_Booked_Actual__c;
                wrapperDigital.bookedWgtQ1 = wrapperDigital.bookedWgtQ1 + sbg.R_D_Booked_Proposal__c;
                wrapperDigital.bookedWgtTotal = wrapperDigital.bookedWgtTotal + sbg.R_D_Booked_Proposal__c;
                wrapperDigital.bookedFullQ1 = wrapperDigital.bookedFullQ1 + sbg.R_D_Booked_Full_Proposal__c;
                wrapperDigital.bookedFullTotal = wrapperDigital.bookedFullTotal + sbg.R_D_Booked_Full_Proposal__c;
                wrapperDigital.dChannel = 'Digital';
                tempDChannelMAP.put('Digital', wrapperDigital);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperAudienceNetwork = tempDChannelMAP.get('Audience Network');
                wrapperAudienceNetwork.bookedQ1 = wrapperAudienceNetwork.bookedQ1 + sbg.R_A_Booked_Actual__c;
                wrapperAudienceNetwork.bookedTotal = wrapperAudienceNetwork.bookedTotal + sbg.R_A_Booked_Actual__c;
                wrapperAudienceNetwork.bookedWgtQ1 = wrapperAudienceNetwork.bookedWgtQ1 + sbg.R_A_Booked_Proposal__c;
                wrapperAudienceNetwork.bookedWgtTotal = wrapperAudienceNetwork.bookedWgtTotal + sbg.R_A_Booked_Proposal__c;
                wrapperAudienceNetwork.bookedFullQ1 = wrapperAudienceNetwork.bookedFullQ1 + sbg.R_A_Booked_Full_Proposal__c;
                wrapperAudienceNetwork.bookedFullTotal = wrapperAudienceNetwork.bookedFullTotal + sbg.R_A_Booked_Full_Proposal__c;
                wrapperAudienceNetwork.dChannel = 'Audience Network';
                tempDChannelMAP.put('Audience Network', wrapperAudienceNetwork);
            }
            if(sbg.Quarter__c != null && sbg.Quarter__c.startsWith('Q2')){
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperBase = tempDChannelMAP.get('Base');
                wrapperBase.bookedQ2 = wrapperBase.bookedQ2 + sbg.R_B_Booked_Actual__c;
                wrapperBase.bookedTotal = wrapperBase.bookedTotal + sbg.R_B_Booked_Actual__c;
                wrapperBase.bookedWgtQ2 = wrapperBase.bookedWgtQ2 + sbg.R_B_Booked_Proposal__c;
                wrapperBase.bookedWgtTotal = wrapperBase.bookedWgtTotal + sbg.R_B_Booked_Proposal__c;
                wrapperBase.bookedFullQ2 = wrapperBase.bookedFullQ2 + sbg.R_B_Booked_Full_Proposal__c;
                wrapperBase.bookedFullTotal = wrapperBase.bookedFullTotal + sbg.R_B_Booked_Full_Proposal__c;
                wrapperBase.dChannel = 'Base';
                tempDChannelMAP.put('Base', wrapperBase);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperMobile = tempDChannelMAP.get('Mobile');
                wrapperMobile.bookedQ2 = wrapperMobile.bookedQ2 + sbg.R_M_Booked_Actual__c;
                wrapperMobile.bookedTotal = wrapperMobile.bookedTotal + sbg.R_M_Booked_Actual__c;
                wrapperMobile.bookedWgtQ2 = wrapperMobile.bookedWgtQ2 + sbg.R_M_Booked_Proposal__c;
                wrapperMobile.bookedWgtTotal = wrapperMobile.bookedWgtTotal + sbg.R_M_Booked_Proposal__c;
                wrapperMobile.bookedFullQ2 = wrapperMobile.bookedFullQ2 + sbg.R_M_Booked_Full_Proposal__c;
                wrapperMobile.bookedFullTotal = wrapperMobile.bookedFullTotal + sbg.R_M_Booked_Full_Proposal__c;
                wrapperMobile.dChannel = 'Mobile';
                tempDChannelMAP.put('Mobile', wrapperMobile);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperDigital = tempDChannelMAP.get('Digital');
                wrapperDigital.bookedQ2 = wrapperDigital.bookedQ2 + sbg.R_D_Booked_Actual__c;
                wrapperDigital.bookedTotal = wrapperDigital.bookedTotal + sbg.R_D_Booked_Actual__c;
                wrapperDigital.bookedWgtQ2 = wrapperDigital.bookedWgtQ2 + sbg.R_D_Booked_Proposal__c;
                wrapperDigital.bookedWgtTotal = wrapperDigital.bookedWgtTotal + sbg.R_D_Booked_Proposal__c;
                wrapperDigital.bookedFullQ2 = wrapperDigital.bookedFullQ2 + sbg.R_D_Booked_Full_Proposal__c;
                wrapperDigital.bookedFullTotal = wrapperDigital.bookedFullTotal + sbg.R_D_Booked_Full_Proposal__c;
                wrapperDigital.dChannel = 'Digital';
                tempDChannelMAP.put('Digital', wrapperDigital);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperAudienceNetwork = tempDChannelMAP.get('Audience Network');
                wrapperAudienceNetwork.bookedQ2 = wrapperAudienceNetwork.bookedQ2 + sbg.R_A_Booked_Actual__c;
                wrapperAudienceNetwork.bookedTotal = wrapperAudienceNetwork.bookedTotal + sbg.R_A_Booked_Actual__c;
                wrapperAudienceNetwork.bookedWgtQ2 = wrapperAudienceNetwork.bookedWgtQ2 + sbg.R_A_Booked_Proposal__c;
                wrapperAudienceNetwork.bookedWgtTotal = wrapperAudienceNetwork.bookedWgtTotal + sbg.R_A_Booked_Proposal__c;
                wrapperAudienceNetwork.bookedFullQ2 = wrapperAudienceNetwork.bookedFullQ2 + sbg.R_A_Booked_Full_Proposal__c;
                wrapperAudienceNetwork.bookedFullTotal = wrapperAudienceNetwork.bookedFullTotal + sbg.R_A_Booked_Full_Proposal__c;
                wrapperAudienceNetwork.dChannel = 'Audience Network';
                tempDChannelMAP.put('Audience Network', wrapperAudienceNetwork);            
            }
            
            if(sbg.Quarter__c != null && sbg.Quarter__c.startsWith('Q3')){
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperBase = tempDChannelMAP.get('Base');
                wrapperBase.bookedQ3 = wrapperBase.bookedQ3 + sbg.R_B_Booked_Actual__c;
                wrapperBase.bookedTotal = wrapperBase.bookedTotal + sbg.R_B_Booked_Actual__c;
                wrapperBase.bookedWgtQ3 = wrapperBase.bookedWgtQ3 + sbg.R_B_Booked_Proposal__c;
                wrapperBase.bookedWgtTotal = wrapperBase.bookedWgtTotal + sbg.R_B_Booked_Proposal__c;
                wrapperBase.bookedFullQ3 = wrapperBase.bookedFullQ3 + sbg.R_B_Booked_Full_Proposal__c;
                wrapperBase.bookedFullTotal = wrapperBase.bookedFullTotal + sbg.R_B_Booked_Full_Proposal__c;
                wrapperBase.dChannel = 'Base';
                tempDChannelMAP.put('Base', wrapperBase);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperMobile = tempDChannelMAP.get('Mobile');
                wrapperMobile.bookedQ3 = wrapperMobile.bookedQ3 + sbg.R_M_Booked_Actual__c;
                wrapperMobile.bookedTotal = wrapperMobile.bookedTotal + sbg.R_M_Booked_Actual__c;
                wrapperMobile.bookedWgtQ3 = wrapperMobile.bookedWgtQ3 + sbg.R_M_Booked_Proposal__c;
                wrapperMobile.bookedWgtTotal = wrapperMobile.bookedWgtTotal + sbg.R_M_Booked_Proposal__c;
                wrapperMobile.bookedFullQ3 = wrapperMobile.bookedFullQ3 + sbg.R_M_Booked_Full_Proposal__c;
                wrapperMobile.bookedFullTotal = wrapperMobile.bookedFullTotal + sbg.R_M_Booked_Full_Proposal__c;
                wrapperMobile.dChannel = 'Mobile';
                tempDChannelMAP.put('Mobile', wrapperMobile);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperDigital = tempDChannelMAP.get('Digital');
                wrapperDigital.bookedQ3 = wrapperDigital.bookedQ3 + sbg.R_D_Booked_Actual__c;
                wrapperDigital.bookedTotal = wrapperDigital.bookedTotal + sbg.R_D_Booked_Actual__c;
                wrapperDigital.bookedWgtQ3 = wrapperDigital.bookedWgtQ3 + sbg.R_D_Booked_Proposal__c;
                wrapperDigital.bookedWgtTotal = wrapperDigital.bookedWgtTotal + sbg.R_D_Booked_Proposal__c;
                wrapperDigital.bookedFullQ3 = wrapperDigital.bookedFullQ3 + sbg.R_D_Booked_Full_Proposal__c;
                wrapperDigital.bookedFullTotal = wrapperDigital.bookedFullTotal + sbg.R_D_Booked_Full_Proposal__c;
                wrapperDigital.dChannel = 'Digital';
                tempDChannelMAP.put('Digital', wrapperDigital);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperAudienceNetwork = tempDChannelMAP.get('Audience Network');
                wrapperAudienceNetwork.bookedQ3 = wrapperAudienceNetwork.bookedQ3 + sbg.R_A_Booked_Actual__c;
                wrapperAudienceNetwork.bookedTotal = wrapperAudienceNetwork.bookedTotal + sbg.R_A_Booked_Actual__c;
                wrapperAudienceNetwork.bookedWgtQ3 = wrapperAudienceNetwork.bookedWgtQ3 + sbg.R_A_Booked_Proposal__c;
                wrapperAudienceNetwork.bookedWgtTotal = wrapperAudienceNetwork.bookedWgtTotal + sbg.R_A_Booked_Proposal__c;
                wrapperAudienceNetwork.bookedFullQ3 = wrapperAudienceNetwork.bookedFullQ3 + sbg.R_A_Booked_Full_Proposal__c;
                wrapperAudienceNetwork.bookedFullTotal = wrapperAudienceNetwork.bookedFullTotal + sbg.R_A_Booked_Full_Proposal__c;
                wrapperAudienceNetwork.dChannel = 'Audience Network';
                tempDChannelMAP.put('Audience Network', wrapperAudienceNetwork);
            }
            
            if(sbg.Quarter__c != null && sbg.Quarter__c.startsWith('Q4')){
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperBase = tempDChannelMAP.get('Base');
                wrapperBase.bookedQ4 = wrapperBase.bookedQ4 + sbg.R_B_Booked_Actual__c;
                wrapperBase.bookedTotal = wrapperBase.bookedTotal + sbg.R_B_Booked_Actual__c;
                wrapperBase.bookedWgtQ4 = wrapperBase.bookedWgtQ4 + sbg.R_B_Booked_Proposal__c;
                wrapperBase.bookedWgtTotal = wrapperBase.bookedWgtTotal + sbg.R_B_Booked_Proposal__c;
                wrapperBase.bookedFullQ4 = wrapperBase.bookedFullQ4 + sbg.R_B_Booked_Full_Proposal__c;
                wrapperBase.bookedFullTotal = wrapperBase.bookedFullTotal + sbg.R_B_Booked_Full_Proposal__c;
                wrapperBase.dChannel = 'Base';
                tempDChannelMAP.put('Base', wrapperBase);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperMobile = tempDChannelMAP.get('Mobile');
                wrapperMobile.bookedQ4 = wrapperMobile.bookedQ4 + sbg.R_M_Booked_Actual__c;
                wrapperMobile.bookedTotal = wrapperMobile.bookedTotal + sbg.R_M_Booked_Actual__c;
                wrapperMobile.bookedWgtQ4 = wrapperMobile.bookedWgtQ4 + sbg.R_M_Booked_Proposal__c;
                wrapperMobile.bookedWgtTotal = wrapperMobile.bookedWgtTotal + sbg.R_M_Booked_Proposal__c;
                wrapperMobile.bookedFullQ4 = wrapperMobile.bookedFullQ4 + sbg.R_M_Booked_Full_Proposal__c;
                wrapperMobile.bookedFullTotal = wrapperMobile.bookedFullTotal + sbg.R_M_Booked_Full_Proposal__c;
                wrapperMobile.dChannel = 'Mobile';
                tempDChannelMAP.put('Mobile', wrapperMobile);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperDigital = tempDChannelMAP.get('Digital');
                wrapperDigital.bookedQ4 = wrapperDigital.bookedQ4 + sbg.R_D_Booked_Actual__c;
                wrapperDigital.bookedTotal = wrapperDigital.bookedTotal + sbg.R_D_Booked_Actual__c;
                wrapperDigital.bookedWgtQ4 = wrapperDigital.bookedWgtQ4 + sbg.R_D_Booked_Proposal__c;
                wrapperDigital.bookedWgtTotal = wrapperDigital.bookedWgtTotal + sbg.R_D_Booked_Proposal__c;
                wrapperDigital.bookedFullQ4 = wrapperDigital.bookedFullQ4 + sbg.R_D_Booked_Full_Proposal__c;
                wrapperDigital.bookedFullTotal = wrapperDigital.bookedFullTotal + sbg.R_D_Booked_Full_Proposal__c;
                wrapperDigital.dChannel = 'Digital';
                tempDChannelMAP.put('Digital', wrapperDigital);
                
                BestGuessRevenueUtil.DeliveryChannelWrapper wrapperAudienceNetwork = tempDChannelMAP.get('Audience Network');
                wrapperAudienceNetwork.bookedQ4 = wrapperAudienceNetwork.bookedQ4 + sbg.R_A_Booked_Actual__c;
                wrapperAudienceNetwork.bookedTotal = wrapperAudienceNetwork.bookedTotal + sbg.R_A_Booked_Actual__c;
                wrapperAudienceNetwork.bookedWgtQ4 = wrapperAudienceNetwork.bookedWgtQ4 + sbg.R_A_Booked_Proposal__c;
                wrapperAudienceNetwork.bookedWgtTotal = wrapperAudienceNetwork.bookedWgtTotal + sbg.R_A_Booked_Proposal__c;
                wrapperAudienceNetwork.bookedFullQ4 = wrapperAudienceNetwork.bookedFullQ4 + sbg.R_A_Booked_Full_Proposal__c;
                wrapperAudienceNetwork.bookedFullTotal = wrapperAudienceNetwork.bookedFullTotal + sbg.R_A_Booked_Full_Proposal__c;
                wrapperAudienceNetwork.dChannel = 'Audience Network';
                tempDChannelMAP.put('Audience Network', wrapperAudienceNetwork);   
            }
        }
        List<BestGuessRevenueUtil.DeliveryChannelWrapper> wrapperLst = tempDChannelMAP.values();
        return wrapperLst;
    }
    
    //wrapper class
    public Class DeliveryChannelWrapper{
        //wrapper class variables
        public Decimal bookedQ1{get;set;}
        public Decimal bookedQ2{get;set;}
        public Decimal bookedQ3{get;set;}
        public Decimal bookedQ4{get;set;}
        public Decimal bookedTotal{get;set;}
        public Decimal bookedWgtQ1{get;set;}
        public Decimal bookedWgtQ2{get;set;}
        public Decimal bookedWgtQ3{get;set;}
        public Decimal bookedWgtQ4{get;set;}
        public Decimal bookedWgtTotal{get;set;}
        public Decimal bookedFullQ1{get;set;}
        public Decimal bookedFullQ2{get;set;}
        public Decimal bookedFullQ3{get;set;}
        public Decimal bookedFullQ4{get;set;}
        public Decimal bookedFullTotal{get;set;}
        public String dChannel{get;set;}
        
        //wrapper class constructor
        public DeliveryChannelWrapper(Decimal bBQ1,Decimal bBQ2,Decimal bBQ3,Decimal bBQ4,Decimal bBT,Decimal bBWQ1,Decimal bBWQ2,Decimal bBWQ3,Decimal bBWQ4,Decimal bBWT,Decimal bBFQ1,Decimal bBFQ2,Decimal bBFQ3,Decimal bBFQ4,Decimal bBFT,String dc){
            this.bookedQ1 = bBQ1;
            this.bookedQ2 = bBQ2;
            this.bookedQ3 = bBQ3;
            this.bookedQ4 = bBQ4;
            this.bookedTotal = bBT;
            this.bookedWgtQ1 = bBWQ1;
            this.bookedWgtQ2 = bBWQ2;
            this.bookedWgtQ3 = bBWQ3;
            this.bookedWgtQ4 = bBWQ4;
            this.bookedWgtTotal = bBWT;
            this.bookedFullQ1 = bBFQ1;
            this.bookedFullQ2 = bBFQ2;
            this.bookedFullQ3 = bBFQ3;
            this.bookedFullQ4 = bBFQ4;
            this.bookedFullTotal = bBFT;
            this.dChannel = dc;
        }
    }
}