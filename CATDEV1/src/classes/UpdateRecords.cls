global class UpdateRecords implements Database.Batchable<sObject>{
    String obj;
    String whereClause;
    
    public UpdateRecords(String t_obj, String t_whereClause){
        this.obj = t_obj;
        this.whereClause = t_whereClause;
    }
    
    //method that gets the query used for this batch
    global Database.querylocator start(Database.BatchableContext BC){
        String query = null;
        if (obj != null){
            query = 'Select id from ' + obj + ' ';
        }
        
        if (whereClause != null){
            System.debug('Where clause is ' + whereClause);    
            query += 'where ' + whereClause;
        }
        
        System.debug('Query is ' + query);
        
        return Database.getQueryLocator(query);
    }
    
    //method that makes up the body of the batch process
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        update scope;
    }
    
    //method that runs after the execute() method
    global void finish(Database.BatchableContext BC){
        
    }
}