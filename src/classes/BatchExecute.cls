public class BatchExecute{


public static void startBatchProcess(List<Batch_Run__c> batchesToStart) {
    
   ID batchprocessid;
   
   //For each batch initiate corresponding batch job based on batch name. Update status in batch Run record
   //to 'In Progress' and update the Id of the batch job
   for (Batch_Run__c br: batchesToStart) {
   
   System.debug('Batches are*******'+ br.Batch_Class__c);
    
     try {
      if(br.Status__c=='Start'){  
        if(br.Batch_Class__c == 'BatchNotifyPFE') {
           BatchNotifyPFE  BatchApex = new BatchNotifyPFE();
            batchprocessid = Database.executeBatch(BatchApex, 200);
            setInProgress(br, batchprocessid);
            
                
        } 
        if(br.Batch_Class__c == 'BatchDeactivateProgramForecasts') {
           BatchDeactivateProgramForecasts  BatchApex = new BatchDeactivateProgramForecasts();
            batchprocessid = Database.executeBatch(BatchApex, 200);
            setInProgress(br, batchprocessid);
        } 
      }
        }
         catch(Exception e) {
           // If an exception occurs, log the error message. and end the process
            
            if (batchProcessId != null) {
                    System.abortJob(batchprocessid);
            }
      }
    }
   
}

private static void setInProgress(Batch_Run__c br,Id batchprocessid){
         br.status__c = 'In Progress';
      //  br.job_Id__c = batchprocessid;
}

public static void endBatchProcess (String batchName) {
    
      //Get the open batch control record related to the batch name
     
     List<Batch_Run__c> br = [ select Status__c from Batch_Run__c 
        where Batch_Class__c =: batchName 
        and status__c = 'In Progress'];
   
    
}

}