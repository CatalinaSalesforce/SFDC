public class OppHistory{  
    private final Opportunity opp;

    public OppHistory(ApexPages.StandardController stdController) {
        this.opp = (Opportunity)stdController.getRecord();
    }
    public List<OpportunityFieldHistory> opph = new List<OpportunityFieldHistory>();
    public List<OpportunityFieldHistory> getOppHis() {
            opph = [SELECT Id, IsDeleted, OpportunityId, CreatedById, CreatedBy.Name, CreatedDate, Field, OldValue, NewValue From OpportunityFieldHistory WHERE OpportunityId = :opp.id ORDER BY CreatedDate ASC];
        return opph;
    }
}