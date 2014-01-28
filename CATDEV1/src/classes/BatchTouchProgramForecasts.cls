/*
@Description: This batch is to touch/tickle  all the Program forecast records in order to trigger create Program forecast monthly records.
*/
Global class BatchTouchProgramForecasts implements Database.Batchable<sObject> {
	private String query = 'select id from Program_Forecast__c where CurrencyIsoCode=\'USD\' and Ad_period__r.Type__c in (\'Manufacturing\',\'Retail\')'; 
	private  List<ID> pfId = new List<ID>(); 
    public list<id> errorIds= new list<id>();
	public string getQuery(){
	  return query;
	}
	public BatchTouchProgramForecasts (List<Program_Forecast__c>  programForecasts){
		
	  
	  for(Program_Forecast__c pf: programForecasts){
	    pfId.add(pf.Id);
	    
	  }
	  query += 'AND ID in :pfId';
	  
	}
	
	public BatchTouchProgramForecasts(){
	
	this.query = query; 
	}

   global Database.querylocator start(Database.BatchableContext BC){
    String pQuery = getQuery();
    return Database.getQueryLocator(pQuery);
   
   }
 
   global void execute(Database.BatchableContext BC, List<sObject> scope){
   	
   	  Update scope; 
       
    /*       try{
           
          Update scope; 
           
       } catch(System.DmlException e){
            for(sObject s: scope)
  	         {   
  	    	  Program_Forecast__c t = (Program_Forecast__c) s;
              errorIds.add(t.id);
             }
              SendEmail se = new SendEmail(); 
             se.attachAsCSV(errorIds); 
       }
       */
   }
   
   global void finish(Database.BatchableContext BC){}


}