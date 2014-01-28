public class ProgramSearchDto {

    /** Update Flg */
    public Boolean checked{get;set;}
    /** Data */
    public ContractCycle__c result{get;set;}

    /** Ranking No */
    public Integer rank{get;set;}

    /** Constructor */
    public ProgramSearchDto(){

      checked = false;
      result = new ContractCycle__c();
    }


  	/**
   	* Test method
   	*/
  	@isTest(SeeAllData=false)
    public static void unitTest() {
    	ProgramSearchDto dto = new ProgramSearchDto();
    	System.assert(dto.result != null);
    }

}