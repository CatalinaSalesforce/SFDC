trigger ProgramForecastMonthlyUpdateBG on Program_forecast_Monthly__c (after insert, after update) {
    
    final static String defaultSettingsName = 'Default';
    Boolean executeTrigger = true;
    if (Best_Guess_Settings__c.getOrgDefaults() != null){
        Best_Guess_Settings__c BGSettings = Best_Guess_Settings__c.getOrgDefaults();
        if (UserInfo.getUserId() == BGSettings.IntegrationUserId__c /*&& BGSettings.Batch_Use_Trigger__c == false*/){
            executeTrigger = false;
        }
    }
    
    if (executeTrigger){
    
        Catalina_Forecast_Settings__c settings = Catalina_Forecast_Settings__c.getInstance(defaultSettingsName);
        String baseType = '';
        String digitalType = '';
        String audienceType = '';
        String mobileType = '';
        String manufacturingType = '';
        String retailType = '';
        
        if (settings != null) {
            baseType = settings.Base_Delivery_Type__c;
            digitalType = settings.Digital_Delivery_Type__c;
            audienceType = settings.Display_Delivery_Type__c;
            mobileType = settings.Mobile_Delivery_Type__c;
            manufacturingType = settings.Manufacturing_Account_Type__c;
            retailType = settings.Retail_Account_Type__c;
        }
        
        Set<Id> srbgSet = new Set<Id>();
        Set<Id> abgsSet = new Set<Id>();
        for (Program_forecast_Monthly__c pf : Trigger.new){
            srbgSet.add(pf.Sales_Rep_Best_Guess__c);
            abgsSet.add(pf.Account_Best_Guess_Summary__c);
        }
        
        Map<Id, Sales_Rep_Best_Guess__c> srbgMap = new Map<Id, Sales_Rep_Best_Guess__c>();
        List<Sales_Rep_Best_Guess__c> updateSRBG = [SELECT Id, Name, Quarter__c, Actual_Amount__c, Forecast_Contract__c, Forecast_Proposal__c, Weighted_Forecast_Proposal__c, OwnerId,
            M_A_Actual_Amount__c, M_A_Forecast_Contract__c, M_A_Forecast_Proposal__c, M_A_Weighted_Forecast_Proposal__c,
            M_B_Actual_Amount__c, M_B_Forecast_Contract__c, M_B_Forecast_Proposal__c, M_B_Weighted_Forecast_Proposal__c,
            M_D_Actual_Amount__c, M_D_Forecast_Contract__c, M_D_Forecast_Proposal__c, M_D_Weighted_Forecast_Proposal__c,
            M_M_Actual_Amount__c, M_M_Forecast_Contract__c, M_M_Forecast_Proposal__c, M_M_Weighted_Forecast_Proposal__c,
            R_A_Actual_Amount__c, R_A_Forecast_Contract__c, R_A_Forecast_Proposal__c, R_A_Weighted_Forecast_Proposal__c,
            R_B_Actual_Amount__c, R_B_Forecast_Contract__c, R_B_Forecast_Proposal__c, R_B_Weighted_Forecast_Proposal__c,
            R_D_Actual_Amount__c, R_D_Forecast_Contract__c, R_D_Forecast_Proposal__c, R_D_Weighted_Forecast_Proposal__c,
            R_M_Actual_Amount__c, R_M_Forecast_Contract__c, R_M_Forecast_Proposal__c, R_M_Weighted_Forecast_Proposal__c
             From Sales_Rep_Best_Guess__c
            WHERE ID IN: srbgSet];
        for (Sales_Rep_Best_Guess__c srbg : updateSRBG){
            srbgMap.put(srbg.Id, srbg);
        }
        
        Map<Id, Account_Best_Guess_Summary__c> abgsMap = new Map<Id, Account_Best_Guess_Summary__c>();
        List<Account_Best_Guess_Summary__c> updateABGS = [Select Account__r.ID, OwnerID, Year__c, Delivery_Channel__c,
            Booked_Q1__c, Booked_Q2__c, Booked_Q3__c, Booked_Q4__c,
            Full_Proposal_Q1__c, Full_Proposal_Q2__c, Full_Proposal_Q3__c, Full_Proposal_Q4__c,
            Q1__c, Q2__c, Q3__c, Q4__c,
            Wgt_Proposal_Q1__c, Wgt_Proposal_Q2__c, Wgt_Proposal_Q3__c, Wgt_Proposal_Q4__c
            FROM Account_Best_Guess_Summary__c
            WHERE ID IN: abgsSet];
        for (Account_Best_Guess_Summary__c abgs : updateABGS){
            abgsMap.put(abgs.Id, abgs);
        }
        
        for (Program_forecast_Monthly__c pf : Trigger.new){
            if (pf.Is_SDPY__c == false){
                Sales_Rep_Best_Guess__c srbg = srbgMap.get(pf.Sales_Rep_Best_Guess__c);
                if (srbg != null){
                    if (srbg.M_B_Actual_Amount__c == null) srbg.M_B_Actual_Amount__c = 0;
                    if (srbg.M_B_Forecast_Contract__c == null) srbg.M_B_Forecast_Contract__c = 0;
                    if (srbg.M_B_Forecast_Proposal__c == null) srbg.M_B_Forecast_Proposal__c = 0;
                    if (srbg.M_A_Actual_Amount__c == null) srbg.M_A_Actual_Amount__c = 0;
                    if (srbg.M_A_Forecast_Contract__c == null) srbg.M_A_Forecast_Contract__c = 0;
                    if (srbg.M_A_Forecast_Proposal__c == null) srbg.M_A_Forecast_Proposal__c = 0;
                    if (srbg.M_D_Actual_Amount__c == null) srbg.M_D_Actual_Amount__c = 0;
                    if (srbg.M_D_Forecast_Contract__c == null) srbg.M_D_Forecast_Contract__c = 0;
                    if (srbg.M_D_Forecast_Proposal__c == null) srbg.M_D_Forecast_Proposal__c = 0;
                    if (srbg.M_M_Actual_Amount__c == null) srbg.M_M_Actual_Amount__c = 0;
                    if (srbg.M_M_Forecast_Contract__c == null) srbg.M_M_Forecast_Contract__c = 0;
                    if (srbg.M_M_Forecast_Proposal__c == null) srbg.M_M_Forecast_Proposal__c = 0;
                    if (srbg.R_B_Actual_Amount__c == null) srbg.R_B_Actual_Amount__c = 0;
                    if (srbg.R_B_Forecast_Contract__c == null) srbg.R_B_Forecast_Contract__c = 0;
                    if (srbg.R_B_Forecast_Proposal__c == null) srbg.R_B_Forecast_Proposal__c = 0;
                    if (srbg.R_A_Actual_Amount__c == null) srbg.R_A_Actual_Amount__c = 0;
                    if (srbg.R_A_Forecast_Contract__c == null) srbg.R_A_Forecast_Contract__c = 0;
                    if (srbg.R_A_Forecast_Proposal__c == null) srbg.R_A_Forecast_Proposal__c = 0;
                    if (srbg.R_D_Actual_Amount__c == null) srbg.R_D_Actual_Amount__c = 0;
                    if (srbg.R_D_Forecast_Contract__c == null) srbg.R_D_Forecast_Contract__c = 0;
                    if (srbg.R_D_Forecast_Proposal__c == null) srbg.R_D_Forecast_Proposal__c = 0;
                    if (srbg.R_M_Actual_Amount__c == null) srbg.R_M_Actual_Amount__c = 0;
                    if (srbg.R_M_Forecast_Contract__c == null) srbg.R_M_Forecast_Contract__c = 0;
                    if (srbg.R_M_Forecast_Proposal__c == null) srbg.R_M_Forecast_Proposal__c = 0;
                    Double newForecastAmt = (pf.Forecast_Amount__c == null ? 0 : pf.Forecast_Amount__c);
                    Double weightedForecastAmt = (pf.Weighted_Forecast_Amount__c == null ? 0 : pf.Weighted_Forecast_Amount__c);
                    Double newActualAmt = (pf.Actual_Amount__c == null ? 0 : pf.Actual_Amount__c);
                    Double newBookedAmt = (pf.Booked_Amount__c == null ? 0 : pf.Booked_Amount__c);
                    if (Trigger.isUpdate){
                        Double oldForecastAmt = (Trigger.oldMap.get(pf.Id).Forecast_Amount__c == null ? 0 : Trigger.oldMap.get(pf.Id).Forecast_Amount__c);
                        Double oldActualAmt = (Trigger.oldMap.get(pf.Id).Actual_Amount__c == null ? 0 : Trigger.oldMap.get(pf.Id).Actual_Amount__c);
                        Double oldWeightedForecastAmt = (Trigger.oldMap.get(pf.Id).Weighted_Forecast_Amount__c == null ? 0 : Trigger.oldMap.get(pf.Id).Weighted_Forecast_Amount__c);
                        system.debug(LoggingLevel.ERROR,'***newForecastAmt: ' + newForecastAmt + ', oldForecastAmt: ' + oldForecastAmt);
                        if (pf.Opportunity_Record_Type__c == 'Contract'){
                            if (!pf.Active__c){
                                srbg.Actual_Amount__c += (newActualAmt - oldActualAmt);
                            } else {
                                srbg.Forecast_Contract__c += (newForecastAmt - oldForecastAmt);
                            }
                            if (pf.Account_Type__c == manufacturingType){
                                if (pf.Delivery_Channel__c == baseType){
                                    if (!pf.Active__c){
                                        srbg.M_B_Actual_Amount__c += (newActualAmt - oldActualAmt);
                                    } else {
                                        srbg.M_B_Forecast_Contract__c += (newForecastAmt - oldForecastAmt);
                                    }
                                } else if (pf.Delivery_Channel__c == digitalType){
                                    if (!pf.Active__c){
                                        srbg.M_D_Actual_Amount__c += (newActualAmt - oldActualAmt);
                                    } else {
                                        srbg.M_D_Forecast_Contract__c += (newForecastAmt - oldForecastAmt);
                                    }
                                } else if (pf.Delivery_Channel__c == mobileType){
                                    if (!pf.Active__c){
                                        srbg.M_M_Actual_Amount__c += (newActualAmt - oldActualAmt);
                                    } else {
                                        srbg.M_M_Forecast_Contract__c += (newForecastAmt - oldForecastAmt);
                                    }
                                } else if (pf.Delivery_Channel__c == audienceType){
                                    if (!pf.Active__c){
                                        srbg.M_A_Actual_Amount__c += (newActualAmt - oldActualAmt);
                                    } else {
                                        srbg.M_A_Forecast_Contract__c += (newForecastAmt - oldForecastAmt);
                                    }
                                }
                            } else if (pf.Account_Type__c == retailType){
                                if (pf.Delivery_Channel__c == baseType){
                                    if (!pf.Active__c){
                                        srbg.R_B_Actual_Amount__c += (newActualAmt - oldActualAmt);
                                    } else {
                                        srbg.R_B_Forecast_Contract__c += (newForecastAmt - oldForecastAmt);
                                    }
                                } else if (pf.Delivery_Channel__c == digitalType){
                                    if (!pf.Active__c){
                                        srbg.R_D_Actual_Amount__c += (newActualAmt - oldActualAmt);
                                    } else {
                                        srbg.R_D_Forecast_Contract__c += (newForecastAmt - oldForecastAmt);
                                    }
                                } else if (pf.Delivery_Channel__c == mobileType){
                                    if (!pf.Active__c){
                                        srbg.R_M_Actual_Amount__c += (newActualAmt - oldActualAmt);
                                    } else {
                                        srbg.R_M_Forecast_Contract__c += (newForecastAmt - oldForecastAmt);
                                    }
                                } else if (pf.Delivery_Channel__c == audienceType){
                                    if (!pf.Active__c){
                                        srbg.R_A_Actual_Amount__c += (newActualAmt - oldActualAmt);
                                    } else {
                                        srbg.R_A_Forecast_Contract__c += (newForecastAmt - oldForecastAmt);
                                    }
                                }
                            }
                        } else {
                            srbg.Forecast_Proposal__c += (newForecastAmt - oldForecastAmt);
                            srbg.Weighted_Forecast_Proposal__c += (weightedForecastAmt - oldWeightedForecastAmt);
                            if (pf.Account_Type__c == manufacturingType){
                                if (pf.Delivery_Channel__c == baseType){
                                    srbg.M_B_Forecast_Proposal__c += (newForecastAmt - oldForecastAmt);
                                    srbg.M_B_Weighted_Forecast_Proposal__c += (weightedForecastAmt - oldWeightedForecastAmt);
                                } else if (pf.Delivery_Channel__c == digitalType){
                                    srbg.M_D_Forecast_Proposal__c += (newForecastAmt - oldForecastAmt);
                                    srbg.M_D_Weighted_Forecast_Proposal__c += (weightedForecastAmt - oldWeightedForecastAmt);
                                } else if (pf.Delivery_Channel__c == mobileType){
                                    srbg.M_M_Forecast_Proposal__c += (newForecastAmt - oldForecastAmt);
                                    srbg.M_M_Weighted_Forecast_Proposal__c += (weightedForecastAmt - oldWeightedForecastAmt);
                                } else if (pf.Delivery_Channel__c == audienceType){
                                    srbg.M_A_Forecast_Proposal__c += (newForecastAmt - oldForecastAmt);
                                    srbg.M_A_Weighted_Forecast_Proposal__c += (weightedForecastAmt - oldWeightedForecastAmt);
                                }
                            } else if (pf.Account_Type__c == retailType){
                                if (pf.Delivery_Channel__c == baseType){
                                    srbg.R_B_Forecast_Proposal__c += (newForecastAmt - oldForecastAmt);
                                    srbg.R_B_Weighted_Forecast_Proposal__c += (weightedForecastAmt - oldWeightedForecastAmt);
                                } else if (pf.Delivery_Channel__c == digitalType){
                                    srbg.R_D_Forecast_Proposal__c += (newForecastAmt - oldForecastAmt);
                                    srbg.R_D_Weighted_Forecast_Proposal__c += (weightedForecastAmt - oldWeightedForecastAmt);
                                } else if (pf.Delivery_Channel__c == mobileType){
                                    srbg.R_M_Forecast_Proposal__c += (newForecastAmt - oldForecastAmt);
                                    srbg.R_M_Weighted_Forecast_Proposal__c += (weightedForecastAmt - oldWeightedForecastAmt);
                                } else if (pf.Delivery_Channel__c == audienceType){
                                    srbg.R_A_Forecast_Proposal__c += (newForecastAmt - oldForecastAmt);
                                    srbg.R_A_Weighted_Forecast_Proposal__c += (weightedForecastAmt - oldWeightedForecastAmt);
                                }
                            }
                        }
                    } else if (Trigger.isInsert){
                        if (pf.Opportunity_Record_Type__c == 'Contract'){
                            srbg.Actual_Amount__c += newActualAmt;
                            srbg.Forecast_Contract__c += newForecastAmt;
                            if (pf.Account_Type__c == manufacturingType){
                                if (pf.Delivery_Channel__c == baseType){
                                    if (!pf.Active__c){
                                        srbg.M_B_Actual_Amount__c += newActualAmt;
                                    } else {
                                        srbg.M_B_Forecast_Contract__c += newForecastAmt;
                                    }
                                } else if (pf.Delivery_Channel__c == digitalType){
                                    if (!pf.Active__c){
                                        srbg.M_D_Actual_Amount__c += newActualAmt;
                                    } else {
                                        srbg.M_D_Forecast_Contract__c += newForecastAmt;
                                    }
                                } else if (pf.Delivery_Channel__c == mobileType){
                                    if (!pf.Active__c){
                                        srbg.M_M_Actual_Amount__c += newActualAmt;
                                    } else {
                                        srbg.M_M_Forecast_Contract__c += newForecastAmt;
                                    }
                                } else if (pf.Delivery_Channel__c == audienceType){
                                    if (!pf.Active__c){
                                        srbg.M_A_Actual_Amount__c += newActualAmt;
                                    } else {
                                        srbg.M_A_Forecast_Contract__c += newForecastAmt;
                                    }
                                }
                            } else if (pf.Account_Type__c == retailType){
                                if (pf.Delivery_Channel__c == baseType){
                                    if (!pf.Active__c){
                                        srbg.R_B_Actual_Amount__c += newActualAmt;
                                    } else {
                                        srbg.R_B_Forecast_Contract__c += newForecastAmt;
                                    }
                                } else if (pf.Delivery_Channel__c == digitalType){
                                    if (!pf.Active__c){
                                        srbg.R_D_Actual_Amount__c += newActualAmt;
                                    } else {
                                        srbg.R_D_Forecast_Contract__c += newForecastAmt;
                                    }
                                } else if (pf.Delivery_Channel__c == mobileType){
                                    if (!pf.Active__c){
                                        srbg.R_M_Actual_Amount__c += newActualAmt;
                                    } else {
                                        srbg.R_M_Forecast_Contract__c += newForecastAmt;
                                    }
                                } else if (pf.Delivery_Channel__c == audienceType){
                                    if (!pf.Active__c){
                                        srbg.R_A_Actual_Amount__c += newActualAmt;
                                    } else {
                                        srbg.R_A_Forecast_Contract__c += newForecastAmt;
                                    }
                                }
                            }
                        } else {
                            srbg.Forecast_Proposal__c += newForecastAmt;
                            srbg.Weighted_Forecast_Proposal__c += weightedForecastAmt;
                            if (pf.Account_Type__c == manufacturingType){
                                if (pf.Delivery_Channel__c == baseType){
                                    srbg.M_B_Forecast_Proposal__c += newForecastAmt;
                                    srbg.M_B_Weighted_Forecast_Proposal__c += weightedForecastAmt;
                                } else if (pf.Delivery_Channel__c == digitalType){
                                    srbg.M_D_Forecast_Proposal__c += newForecastAmt;
                                    srbg.M_D_Weighted_Forecast_Proposal__c += weightedForecastAmt;
                                } else if (pf.Delivery_Channel__c == mobileType){
                                    srbg.M_M_Forecast_Proposal__c += newForecastAmt;
                                    srbg.M_M_Weighted_Forecast_Proposal__c += weightedForecastAmt;
                                } else if (pf.Delivery_Channel__c == audienceType){
                                    srbg.M_A_Forecast_Proposal__c += newForecastAmt;
                                    srbg.M_A_Weighted_Forecast_Proposal__c += weightedForecastAmt;
                                }
                            } else if (pf.Account_Type__c == retailType){
                                if (pf.Delivery_Channel__c == baseType){
                                    srbg.R_B_Forecast_Proposal__c += newForecastAmt;
                                    srbg.R_B_Weighted_Forecast_Proposal__c += weightedForecastAmt;
                                } else if (pf.Delivery_Channel__c == digitalType){
                                    srbg.R_D_Forecast_Proposal__c += newForecastAmt;
                                    srbg.R_D_Weighted_Forecast_Proposal__c += weightedForecastAmt;
                                } else if (pf.Delivery_Channel__c == mobileType){
                                    srbg.R_M_Forecast_Proposal__c += newForecastAmt;
                                    srbg.R_M_Weighted_Forecast_Proposal__c += weightedForecastAmt;
                                } else if (pf.Delivery_Channel__c == audienceType){
                                    srbg.R_A_Forecast_Proposal__c += newForecastAmt;
                                    srbg.R_A_Weighted_Forecast_Proposal__c += weightedForecastAmt;
                                }
                            }
                        }
                    }
                }
                
                //being processing of ABGS
                Account_Best_Guess_Summary__c abgs = abgsMap.get(pf.Account_Best_Guess_Summary__c);
                if (abgs!= null){
                    if (abgs.Booked_Q1__c == null)abgs.Booked_Q1__c = 0;
                    if (abgs.Booked_Q2__c == null)abgs.Booked_Q2__c = 0;
                    if (abgs.Booked_Q3__c == null)abgs.Booked_Q3__c = 0;
                    if (abgs.Booked_Q4__c == null)abgs.Booked_Q4__c = 0;
                    if (abgs.Full_Proposal_Q1__c == null)abgs.Full_Proposal_Q1__c = 0;
                    if (abgs.Full_Proposal_Q2__c == null)abgs.Full_Proposal_Q2__c = 0;
                    if (abgs.Full_Proposal_Q3__c == null)abgs.Full_Proposal_Q3__c = 0;
                    if (abgs.Full_Proposal_Q4__c == null)abgs.Full_Proposal_Q4__c = 0;
                    if (abgs.Wgt_Proposal_Q1__c == null)abgs.Wgt_Proposal_Q1__c = 0;
                    if (abgs.Wgt_Proposal_Q2__c == null)abgs.Wgt_Proposal_Q2__c = 0;
                    if (abgs.Wgt_Proposal_Q3__c == null)abgs.Wgt_Proposal_Q3__c = 0;
                    if (abgs.Wgt_Proposal_Q4__c == null)abgs.Wgt_Proposal_Q4__c = 0;
                    Double newForecastAmt = (pf.Forecast_Amount__c == null ? 0 : pf.Forecast_Amount__c);
                    Double newWeightedAmt = (pf.Weighted_Forecast_Amount__c == null ? 0 : pf.Weighted_Forecast_Amount__c);
                    Double newBookedAmt = (pf.Booked_Amount__c == null ? 0 : pf.Booked_Amount__c);
                    if (Trigger.isUpdate){
                        Double oldForecastAmt = (Trigger.oldMap.get(pf.Id).Forecast_Amount__c == null ? 0 : Trigger.oldMap.get(pf.Id).Forecast_Amount__c);
                        Double oldWeightedAmt = (Trigger.oldMap.get(pf.Id).Weighted_Forecast_Amount__c == null ? 0 : Trigger.oldMap.get(pf.Id).Weighted_Forecast_Amount__c);
                        Double oldBookedAmt = (Trigger.oldMap.get(pf.Id).Booked_Amount__c == null ? 0 : Trigger.oldMap.get(pf.Id).Booked_Amount__c);
                        if (pf.Opportunity_Record_Type__c == 'Contract'){
                            if (pf.Forecast_Quarter__c.contains('Q1')){
                                abgs.Booked_Q1__c+= (newBookedAmt - oldBookedAmt);
                            } else if (pf.Forecast_Quarter__c.contains('Q2')){
                                abgs.Booked_Q2__c+= (newBookedAmt - oldBookedAmt);
                            } else if (pf.Forecast_Quarter__c.contains('Q3')){
                                abgs.Booked_Q3__c+= (newBookedAmt - oldBookedAmt);
                            } else if (pf.Forecast_Quarter__c.contains('Q4')){
                                abgs.Booked_Q4__c+= (newBookedAmt - oldBookedAmt);
                            }
                        } else {
                            if (pf.Forecast_Quarter__c.contains('Q1')){
                                abgs.Full_Proposal_Q1__c+= (newForecastAmt - oldForecastAmt);
                                abgs.Wgt_Proposal_Q1__c+= (newWeightedAmt - newWeightedAmt);
                            } else if (pf.Forecast_Quarter__c.contains('Q2')){
                                abgs.Full_Proposal_Q2__c+= (newForecastAmt - oldForecastAmt);
                                abgs.Wgt_Proposal_Q2__c+= (newWeightedAmt - newWeightedAmt);
                            } else if (pf.Forecast_Quarter__c.contains('Q3')){
                                abgs.Full_Proposal_Q3__c+= (newForecastAmt - oldForecastAmt);
                                abgs.Wgt_Proposal_Q3__c+= (newWeightedAmt - newWeightedAmt);
                            } else if (pf.Forecast_Quarter__c.contains('Q4')){
                                abgs.Full_Proposal_Q4__c+= (newForecastAmt - oldForecastAmt);
                                abgs.Wgt_Proposal_Q4__c+= (newWeightedAmt - newWeightedAmt);
                            }
                        }
                    } else if (Trigger.isInsert){
                        if (pf.Opportunity_Record_Type__c == 'Contract'){
                            if (pf.Forecast_Quarter__c.contains('Q1')){
                                abgs.Booked_Q1__c+= newBookedAmt;
                            } else if (pf.Forecast_Quarter__c.contains('Q2')){
                                abgs.Booked_Q2__c+= newBookedAmt;
                            } else if (pf.Forecast_Quarter__c.contains('Q3')){
                                abgs.Booked_Q3__c+= newBookedAmt;
                            } else if (pf.Forecast_Quarter__c.contains('Q4')){
                                abgs.Booked_Q4__c+= newBookedAmt;
                            }
                        } else {
                            if (pf.Forecast_Quarter__c.contains('Q1')){
                                abgs.Full_Proposal_Q1__c+= newForecastAmt;
                                abgs.Wgt_Proposal_Q1__c+= newWeightedAmt;
                            } else if (pf.Forecast_Quarter__c.contains('Q2')){
                                abgs.Full_Proposal_Q2__c+= newForecastAmt;
                                abgs.Wgt_Proposal_Q2__c+= newWeightedAmt;
                            } else if (pf.Forecast_Quarter__c.contains('Q3')){
                                abgs.Full_Proposal_Q3__c+= newForecastAmt;
                                abgs.Wgt_Proposal_Q3__c+= newWeightedAmt;
                            } else if (pf.Forecast_Quarter__c.contains('Q4')){
                                abgs.Full_Proposal_Q4__c+= newForecastAmt;
                                abgs.Wgt_Proposal_Q4__c+= newWeightedAmt;
                            }
                        }
                    }
                }
            }
        }
        
        update updateSRBG;
        update updateABGS;
    
    }
}