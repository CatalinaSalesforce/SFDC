public with sharing class PlatinumBetLatestAttachmentController {

    public List<Account> Records { get; set; }

    public Id MoreRecordId {get; set; } 

    public Account MoreRecord {get; set;}

    public PlatinumBetLatestAttachmentController()
    {
        Records =  
            [Select Name, Parent.Name,
                (Select Id, Name, LastModifiedDate
                 From Attachments WHERE Name LIKE 'Big Bet%' 
                 Order By LastModifiedDate DESC)         
             From Account t WHERE Parent.CATS_External_ID__c IN ('CO10146BS1','CO10183BS1','CO10331BS1','CO10419BS1','CO10440BS1','CO10448BS1','CO10036BS1','CO10834BS1','CO10576BS1','CO10633BS1','CO10663BS1','CO10830BS1','CO10458BS2','CO10714BS1','CO11306BS2','CO10848BS2')             
             Order By Parent.Name];                  //Campbells,     Coca Cola    General Mills  JJ McNiel      Kellogg    Kimberly Clark    Kraft         NBTY          Nestle       Pepsico         P&G         Unilever       Kroger       Safeway         Target      Walgreens//
    }

    public PageReference showMore()
    {
        MoreRecord = new Map<Id, Account>(Records).get(MoreRecordId);
        return null;
    }
}