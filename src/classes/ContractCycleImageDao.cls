/** Dao class for ContractCycleImage__c */
public class ContractCycleImageDao extends JapanDao{

  /** Constructor. This is called from outer class */
  public ContractCycleImageDao(String strFunctionalName){
    super(strFunctionalName, new ContractCycleImage__c().getSObjectType());
  }

}