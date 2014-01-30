Global class DeleteSDPYDaily implements Schedulable{
    
     global void execute(SchedulableContext ctx) {
        BatchDeleteProgramForecastMonthly batch1 = new BatchDeleteProgramForecastMonthly('SDPY');
        ID batchprocessid = Database.executeBatch(batch1);
    }

}