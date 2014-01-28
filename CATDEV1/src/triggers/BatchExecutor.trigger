trigger BatchExecutor on Batch_Run__c (before insert, before update ) {

BatchExecute.startBatchProcess(trigger.new);
}