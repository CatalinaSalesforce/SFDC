/*###################################### 
#trigger Name: RollupAccountBestGuess
#Created Date: 11-22-12 
#Questions: customersuccess@cloud62.com
#LastModified Date: 11-22-12 
#Description: calculate the sum of Q1__c,Q2__c,Q3__c,Q4__c. 
#www.cloud62.com
######################################## 
*/

trigger RollupAccountBestGuess on Account_Best_Guess_Summary__c (after insert,after update, after delete) {
    //this list contains the ID Account_Best_Guess_Summary__c 
    List<ID> accBestGuessIDs = new List<ID>();
    
    //if user delete any Account_Best_Guess_Summary__c
    if(Trigger.isDelete){
         for(Account_Best_Guess_Summary__c aBGSummary : Trigger.Old){
             accBestGuessIDs.add(aBGSummary.Conglomerate_Account_Best_Guess_Summary__c); //keep the Id of Account_Best_Guess_Summary__c 
        }
    }else{//if user insert or update any Account_Best_Guess_Summary__c 
        for(Account_Best_Guess_Summary__c aBGSummary : Trigger.New){
            accBestGuessIDs.add(aBGSummary.Conglomerate_Account_Best_Guess_Summary__c); //keep the Id of Account_Best_Guess_Summary__c 
        }
    }
    
    List<Conglomerate_Account_Best_Guess_Summary__c> updateConglomerateAccountBestGuessSummary = new List<Conglomerate_Account_Best_Guess_Summary__c>();
    
    //now calulate the Total of Q1__c,Q2__c,Q3__c,Q4__c
    for(Conglomerate_Account_Best_Guess_Summary__c cABGsummary : [select Id, Q1__c, Q2__c, Q3__c, Q4__c, Booked_Q1__c, Booked_Q2__c, Booked_Q3__c, Booked_Q4__c, Full_Proposal_Q1__c, Full_Proposal_Q2__c, Full_Proposal_Q3__c, Full_Proposal_Q4__c, Wgt_Proposal_Q1__c, Wgt_Proposal_Q2__c, Wgt_Proposal_Q3__c, Wgt_Proposal_Q4__c, 
        (SELECT Id, Q1__c, Q2__c, Q3__c, Q4__c, Booked_Q1__c, Booked_Q2__c, Booked_Q3__c, Booked_Q4__c, Full_Proposal_Q1__c, Full_Proposal_Q2__c, Full_Proposal_Q3__c, Full_Proposal_Q4__c, Wgt_Proposal_Q1__c, Wgt_Proposal_Q2__c, Wgt_Proposal_Q3__c, Wgt_Proposal_Q4__c FROM Account_Best_Guess_Summaries__r) from Conglomerate_Account_Best_Guess_Summary__c where ID IN : accBestGuessIDs]){
        Decimal q1 = 0;
        Decimal q2 = 0;
        Decimal q3 = 0;
        Decimal q4 = 0;
        Decimal bookedQ1 = 0;
        Decimal bookedQ2 = 0;
        Decimal bookedQ3 = 0;
        Decimal bookedQ4 = 0;
        Decimal fullProposalQ1 = 0;
        Decimal fullProposalQ2 = 0;
        Decimal fullProposalQ3 = 0;
        Decimal fullProposalQ4 = 0;
        Decimal wgtProposalQ1 = 0;
        Decimal wgtProposalQ2 = 0;
        Decimal wgtProposalQ3 = 0;
        Decimal wgtProposalQ4 = 0;
        for(Account_Best_Guess_Summary__c aBGS : cABGsummary.Account_Best_Guess_Summaries__r){
            Decimal aQ1 = 0;
            Decimal aQ2 = 0;
            Decimal aQ3 = 0;
            Decimal aQ4 = 0;
            Decimal aBookedQ1 = 0;
            Decimal aBookedQ2 = 0;
            Decimal aBookedQ3 = 0;
            Decimal aBookedQ4 = 0;
            Decimal aFullProposalQ1 = 0;
            Decimal aFullProposalQ2 = 0;
            Decimal aFullProposalQ3 = 0;
            Decimal aFullProposalQ4 = 0;
            Decimal aWgtProposalQ1 = 0;
            Decimal aWgtProposalQ2 = 0;
            Decimal aWgtProposalQ3 = 0;
            Decimal aWgtProposalQ4 = 0;
            if(aBGS.Q1__c!= null){
                aQ1 = aBGS.Q1__c;
            }
            if(aBGS.Q2__c != null){
                aQ2 = aBGS.Q2__c;
            }
            if(aBGS.Q3__c != null){
                aQ3 = aBGS.Q3__c;
            }
            if(aBGS.Q4__c != null){
                aQ4 = aBGS.Q4__c;
            }
            if(aBGS.Booked_Q1__c!= null){
                aBookedQ1 = aBGS.Booked_Q1__c;
            }
            if(aBGS.Booked_Q2__c!= null){
                aBookedQ2 = aBGS.Booked_Q2__c;
            }
            if(aBGS.Booked_Q3__c!= null){
                aBookedQ3 = aBGS.Booked_Q3__c;
            }
            if(aBGS.Booked_Q4__c!= null){
                aBookedQ4 = aBGS.Booked_Q4__c;
            }
            if(aBGS.Full_Proposal_Q1__c!= null){
                aFullProposalQ1 = aBGS.Full_Proposal_Q1__c;
            }
            if(aBGS.Full_Proposal_Q2__c!= null){
                aFullProposalQ2 = aBGS.Full_Proposal_Q2__c;
            }
            if(aBGS.Full_Proposal_Q3__c!= null){
                aFullProposalQ3 = aBGS.Full_Proposal_Q3__c;
            }
            if(aBGS.Full_Proposal_Q4__c!= null){
                aFullProposalQ4 = aBGS.Full_Proposal_Q4__c;
            }
            if(aBGS.Wgt_Proposal_Q1__c!= null){
                aWgtProposalQ1 = aBGS.Wgt_Proposal_Q1__c;
            }
            if(aBGS.Wgt_Proposal_Q2__c!= null){
                aWgtProposalQ2 = aBGS.Wgt_Proposal_Q2__c;
            }
            if(aBGS.Wgt_Proposal_Q3__c!= null){
                aWgtProposalQ3 = aBGS.Wgt_Proposal_Q3__c;
            }
            if(aBGS.Wgt_Proposal_Q4__c!= null){
                aWgtProposalQ4 = aBGS.Wgt_Proposal_Q4__c;
            }
            q1 = q1 + aQ1;
            q2 = q2 + aQ2;
            q3 = q3 + aQ3;
            q4 = q4 + aQ4;
            bookedQ1 = bookedQ1 + aBookedQ1;
            bookedQ2 = bookedQ2 + aBookedQ2;
            bookedQ3 = bookedQ3 + aBookedQ3;
            bookedQ4 = bookedQ4 + aBookedQ4;
            fullProposalQ1 = fullProposalQ1 + aFullProposalQ1;
            fullProposalQ2 = fullProposalQ2 + aFullProposalQ2;
            fullProposalQ3 = fullProposalQ3 + aFullProposalQ3;
            fullProposalQ4 = fullProposalQ4 + aFullProposalQ4;
            wgtProposalQ1 = wgtProposalQ1 + aWgtProposalQ1;
            wgtProposalQ2 = wgtProposalQ2 + aWgtProposalQ2;
            wgtProposalQ3 = wgtProposalQ3 + aWgtProposalQ3;
            wgtProposalQ4 = wgtProposalQ4 + aWgtProposalQ4;
        }
        cABGsummary.Q1__c = q1;
        cABGsummary.Q2__c = q2;
        cABGsummary.Q3__c = q3;
        cABGsummary.Q4__c = q4;
        cABGsummary.Booked_Q1__c = bookedQ1;
        cABGsummary.Booked_Q2__c = bookedQ2;
        cABGsummary.Booked_Q3__c = bookedQ3;
        cABGsummary.Booked_Q4__c = bookedQ4;
        cABGsummary.Full_Proposal_Q1__c = fullProposalQ1;
        cABGsummary.Full_Proposal_Q2__c = fullProposalQ2;
        cABGsummary.Full_Proposal_Q3__c = fullProposalQ3;
        cABGsummary.Full_Proposal_Q4__c = fullProposalQ4;
        cABGsummary.Wgt_Proposal_Q1__c = wgtProposalQ1;
        cABGsummary.Wgt_Proposal_Q2__c = wgtProposalQ2;
        cABGsummary.Wgt_Proposal_Q3__c = wgtProposalQ3;
        cABGsummary.Wgt_Proposal_Q4__c = wgtProposalQ4;
        updateConglomerateAccountBestGuessSummary.add(cABGsummary);
    }
    
    update updateConglomerateAccountBestGuessSummary;
    
}