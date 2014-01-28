public class AccountBestGuessUtility {
	
	@future
	public static void linkConglomerates(String accId, String parentAccId, String year, String userID){
		List<Account_Best_Guess_Summary__c> absummaryList= [SELECT 
                            Id, Account__r.Name, Q1__c, Q2__c , Q3__c , Q4__c,Owner.Name, Owner__r.Name, Comments__c,Delivery_Channel__c, 
                            Year__c, Booked_Q1__c, Booked_Q2__c, Booked_Q3__c, Booked_Q4__c, a.Wgt_Proposal_Q4__c, 
                            a.Wgt_Proposal_Q3__c, a.Wgt_Proposal_Q2__c, a.Wgt_Proposal_Q1__c, a.Full_Proposal_Q4__c, 
                            a.Full_Proposal_Q3__c, a.Full_Proposal_Q2__c, a.Full_Proposal_Q1__c, a.Conglomerate_Account_Best_Guess_Summary__c, 
                            a.Booked_Wgt_Q4__c, a.Booked_Wgt_Q3__c, a.Booked_Wgt_Q2__c, Booked_Wgt_Q1__c , a.Booked_Full_Q4__c, 
                            a.Booked_Full_Q3__c, a.Booked_Full_Q2__c, a.Booked_Full_Q1__c, Account__r.ID, Account__r.Recordtype.Name 
                            FROM 
                                Account_Best_Guess_Summary__c a 
                            WHERE 
                                Account__c =: accId
                                and Year__c=:year
                                AND OWNERID =: userID
                            order by Owner.Name,Delivery_Channel__c asc];
         
		Map<String, Conglomerate_Account_Best_Guess_Summary__c> congMap = new Map<String, Conglomerate_Account_Best_Guess_Summary__c>();
		List<Conglomerate_Account_Best_Guess_Summary__c> congList = [SELECT
          	Id, Account__r.Name, Q1__c, Q2__c , Q3__c , Q4__c,Owner.Name, Delivery_Channel__c
          	FROM Conglomerate_Account_Best_Guess_Summary__c
          	WHERE 
                 Account__c = :parentAccId and Year__c=:year order by Owner.Name,Delivery_Channel__c asc];
		for (Conglomerate_Account_Best_Guess_Summary__c c : congList){
			congMap.put(c.Delivery_Channel__c, c);
		}
		
		Map<Id, Account> accMap = new Map<Id, Account>([SELECT ID, OWNERID FROM ACCOUNT]);
                 
		for (Account_Best_Guess_Summary__c abg : absummaryList){
			if (abg.Conglomerate_Account_Best_Guess_Summary__c == null){
				if (congMap.containsKey(abg.Delivery_Channel__c)){
					abg.Conglomerate_Account_Best_Guess_Summary__c = congMap.get(abg.Delivery_Channel__c).Id;
				} else {
					Conglomerate_Account_Best_Guess_Summary__c newCong = new Conglomerate_Account_Best_Guess_Summary__c();
		    		newCong.Account__c = parentAccId;
		    		newCong.Year__c = year;
		    		newCong.DELIVERY_CHANNEL__C = abg.Delivery_Channel__c;
		    		newCong.OwnerId = accMap.get(parentAccId).ownerId;
		    		insert newCong;
		    		abg.Conglomerate_Account_Best_Guess_Summary__c = newCong.Id;
				}
			}
		}
		
		update absummaryList;
	}

}