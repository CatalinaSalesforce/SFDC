global class BatchDeleteProgramForecastMonthly implements Database.Batchable<sObject> {
    
    private String query = 'select id from Program_Forecast_Monthly__c '; 
    private  List<ID> pfmId = new List<ID>(); 
    private String delete_snapshot ='';
    public string getQuery(){
      return query;
    } 
    
    global BatchDeleteProgramForecastMonthly(String snapshot){
        this.delete_snapshot = snapshot; 
     if(snapshot=='All'){
       this.query=query; 
     }else if(snapshot=='SDPY' || snapshot=='PY'){
       this.query+='where  is_SDPY__c=true';
     }else if(snapshot=='Retail'){
       this.query+='where Account_Type__c=\'Retail\'';
     }else if(snapshot=='Manufacturing'){
       this.query+='where Account_Type__c=\'Manufacturing\'';
     }
    }
    
    
    global Database.querylocator start(Database.BatchableContext BC){
  
    return Database.getQueryLocator(query);
   
   }
 
   global void execute(Database.BatchableContext BC, List<sObject> scope){
   
      List<Program_Forecast_Monthly__c> pfm_delete = new List<Program_Forecast_Monthly__c>();  
   
        for(sObject pfm: scope){
            Program_Forecast_Monthly__c p = (Program_Forecast_Monthly__c)pfm;
            
        pfm_delete.add(p);
         
        } 
    
        Delete pfm_delete; 
        DataBase.emptyRecycleBin(pfm_delete);
       
   }
   
   global void finish(Database.BatchableContext BC){
   
       if(delete_snapshot=='SDPY' || delete_snapshot == 'PY'){
            BOOMICallouts boomi = new BOOMICallouts('salesforce.development@catalinamarketing.com','Catalina123','catalina-LZ2IXU','c89647bd-4d0b-49e4-ab36-2bb453777e89'); 
            String ProcessName = 'CATS to Salesforce Load - NEW';
            boomi.invokeProcess('test');
       
       }
   }

    

}