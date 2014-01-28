/*
@Name            : BatchItalyCategoryOverlapNotification
@Author          : customersuccess@cloud62.com
@Date            : 
@Description     : Email Italy managers about category overlap
*/
global class BatchItalyCategoryOverlapNotification implements Database.Batchable<sObject>, Schedulable, Database.Stateful{
    String query;
    List<Opportunity_Category__c> conflictCategory = new List<Opportunity_Category__c>();
    Map<Program__c, List<Opportunity_Category__c>> m = new Map<Program__c, List<Opportunity_Category__c>>();
    Map<ID, Program__c> cyclesMap = new Map<ID, Program__c>();
    Map<String, String> cyclesCategoryMap = new Map<String, String>();
    List<Program__c> allProgram = new List<Program__c>();
    String emailBody = '';
    //constructor
    public BatchItalyCategoryOverlapNotification(){
        
    }
    
    global Database.querylocator start(Database.BatchableContext BC){
                  
        //query = 'Select ID, (select id from Opportunity_Category__r), (select id, Opportunity__c from Programs__r) from Opportunity where ( Catalina_Business_Unit__c = \'Base\' OR Catalina_Business_Unit__c = \'Overprint\') AND( RECORDTYPE.NAME = \'CONTRACT FRANCE\' OR RECORDTYPE.NAME = \'PROPOSAL FRANCE\') Order by LastmodifiedDate desc';
        query = 'Select ID, Name, Amount, Owner.Name, StageName, CreatedDate, '
         + '(select id, Opportunity__c, Opportunity__r.Owner.Name, Opportunity__r.StageName, Opportunity__r.CreatedDate, Opportunity__r.Amount , Category__c, Name, Opportunity__r.Name, Category__r.Name from Opportunity_Category__r), '
         + '(select id, Name, Opportunity__c, Delivery_Type__c, Start_Cycle__c, End_Cycle__c, Start_Cycle__r.Name, End_Cycle__r.Name, Start_Cycle__r.Start_Date__c, Start_Cycle__r.End_Date__c, End_Cycle__r.Start_Date__c, End_Cycle__r.End_Date__c '
         + ' from Programs__r '
         + ' where (Delivery_Type__c=\'Base\' OR Delivery_Type__c = \'Overprint\') '
         + ' and (Start_Cycle__c !=null and End_Cycle__c !=null) and Start_Cycle__r.End_Date__c > ' + Date.today().year() + '-' + (Date.today().month() < 10 ? '0' + String.valueOf(Date.today().month()) : String.valueOf(Date.today().month()))+ + '-' + (Date.today().day() < 10 ? '0' + String.valueOf(Date.today().day()) : String.valueOf(Date.today().day())) + ' ) ' 
         + ' from Opportunity where ( RECORDTYPE.NAME IN (\'Contract Italy\',\'Proposal Italy\',\'Renewals Italy\')) '
         + ' Order by LastmodifiedDate desc';
        system.debug(LoggingLevel.ERROR, '***query: ' + query);
        return Database.getQueryLocator(query);
  }
  
  
  global void execute(Database.BatchableContext NC, List<sObject> scope){
        //Map<ID, Program__c> cyclesMap = new Map<ID, Program__c>();
        Map<ID, ID> cyclesTEMPMap = new Map<ID, ID>();
        List<Opportunity> oppList = (List<Opportunity>)scope;
        //list of the new and current overalps
        List<Category_Overlap__c> overlapsToInsert = new List<Category_Overlap__c>();
        List<Category_Overlap__c> oldOverlaps = [select Opportunity_Category__c, Opportunity_Category_Two__c from Category_Overlap__c];
        //Map of category ID's that overlap
        Map<ID,Set<ID>> oldCategoryIDs = new Map<ID,Set<ID>>();
        
        //map the current ID's out
        if(oldOverlaps.Size() > 0)
        {
            for(Category_Overlap__c c : oldOverlaps)
            {          
                if(!oldCategoryIDs.containsKey(c.Opportunity_Category__c))
                {
                    oldCategoryIDs.put(c.Opportunity_Category__c, new Set<ID>());
                }  
                oldCategoryIDs.get(c.Opportunity_Category__c).add(c.Opportunity_Category_Two__c);                          
            }
        }
        
        
        for(Opportunity o : oppList){
            for(Program__c p : o.Programs__r){
                m.put(p, o.Opportunity_Category__r);
                allProgram.add(p);
            }
        }
        
    for(integer x=0;x<allProgram.size();x++){
        List<Opportunity_Category__c> preOppCategoryList = m.get(allProgram[x]);
        system.debug('allProgram1>>'+allProgram[x].Name);
        for(integer j=0;j<allProgram.size();j++){
            List<Opportunity_Category__c> nextcategoryList = m.get(allProgram[j]);
            //if(allProgram[x].Opportunity__c != allProgram[j].Opportunity__c && ((allProgram[x].Start_Cycle__r.Start_Date__c >= allProgram[j].Start_Cycle__r.End_Date__c && allProgram[x].End_Cycle__r.End_Date__c <= allProgram[j].End_Cycle__r.Start_Date__c)  ||(allProgram[x].Start_Cycle__c == allProgram[j].Start_Cycle__c || allProgram[x].End_Cycle__c == allProgram[j].End_Cycle__c))){
            if(allProgram[x].Opportunity__c != allProgram[j].Opportunity__c && ((allProgram[x].End_Cycle__r.End_Date__c >= allProgram[j].Start_Cycle__r.Start_Date__c && allProgram[x].Start_Cycle__r.Start_Date__c <= allProgram[j].End_Cycle__r.End_Date__c && (allProgram[x].End_Cycle__r.End_Date__c <= allProgram[j].End_Cycle__r.End_Date__c || allProgram[x].End_Cycle__r.End_Date__c >= allProgram[j].End_Cycle__r.End_Date__c))  ||(allProgram[x].Start_Cycle__c == allProgram[j].Start_Cycle__c || allProgram[x].End_Cycle__c == allProgram[j].End_Cycle__c))){
                for(Opportunity_Category__c preC :preOppCategoryList){
                    for(Opportunity_Category__c nextC :nextcategoryList){
                        String key = preC.Id+''+allProgram[x].Id;
                        if(preC.Category__c == nextC.Category__c && preC.Opportunity__c != nextC.Opportunity__c){
                            if(!cyclesCategoryMap.containsKey(key)){
                                cyclesMap.put(allProgram[x].Id, allProgram[x]);
                                cyclesCategoryMap.put(key, key);
                                conflictCategory.add(preC);
                                //check if the found overlap is in the current system if not email it out and add it to be inserted
                                if(oldCategoryIDs.size() > 0)
                                {
                                    if(!oldCategoryIDs.containsKey(preC.ID))
                                    {
                                        addEmailContent(preC, allProgram[x]);
                                        overlapsToInsert.add(new Category_Overlap__c(Opportunity_Category__c = PreC.id, Opportunity_Category_Two__c = Nextc.ID));
                                    }
                                    else if(!oldCategoryIDs.get(preC.ID).contains( nextc.ID))
                                    {                                    
                                        addEmailContent(preC, allProgram[x]);
                                        overlapsToInsert.add(new Category_Overlap__c(Opportunity_Category__c = PreC.id, Opportunity_Category_Two__c = Nextc.ID));
                                    }
                                }
                                else
                                {
                                
                                    addEmailContent(preC, allProgram[x]);
                                    overlapsToInsert.add(new Category_Overlap__c(Opportunity_Category__c = PreC.id, Opportunity_Category_Two__c = Nextc.ID));
                                
                                }
                            }
                            /*if(!cyclesMap.containsKey(allProgram[j].Id)){
                                cyclesMap.put(allProgram[j].Id, allProgram[j]);
                                conflictCategory.add(nextC);
                                addEmailContent(nextC, allProgram[j]);
                            }*/
                        }
                    }
                }
            }
        }
    }
    insert(overlapsToInsert);
 }
  
 
    private void addEmailContent(Opportunity_Category__c o, Program__c p){
        emailBody =  emailBody+'<tr><td>'+o.Opportunity__r.Name+'</td><td>'+o.Category__r.Name+'</td><td>' +o.Opportunity__r.Owner.Name + '</td><td>' + o.Opportunity__r.StageName + '</td><td>' + o.Opportunity__r.CreatedDate.Year() + '-' + o.Opportunity__r.CreatedDate.Month() + - + o.Opportunity__r.CreatedDate.Day() + '</td><td>'+p.Start_Cycle__r.Name+'</td><td>'+p.End_Cycle__r.Name+'</td><td>' + o.Opportunity__r.Amount + '</td></tr>';
    }  
    
    global void finish(Database.BatchableContext BC){              
    
        //if(conflictCategory.size() > 0){
            //sendEmail(conflictCategory, cyclesMap);
        //}     
        string bodyContent  = '<html>' + '<h4>'+'Hello :'+'</h4>'+ 'Overlaped Categories are'+ '<br/>'+'<br/>' +'<body align="center">'+'<table border="1" align="left">' + '<th><u>Opportunity Name</u></th>' + '<th><u>Category</u></th>'+'<th><u>Opportunity Owner</u></th>'+'<th><u>Stage</u></th>'+ '<th><u>Create Date</u></th>'+ '<th><u>Start Cycle</u></th>'+ '<th><u>End Cycle</u></th>'+ '<th><u>Amount</u></th>';
        bodyContent = bodyContent+emailBody+'</table></body></html>';   
            if(conflictCategory.size() > 0){
                sendEmail(bodyContent);
            }               
    }
    
    private void sendEmail(String eBody){
        List<String> emailAddresses = getEmailAddress();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(emailAddresses);
        mail.setSubject('Italy Category Overlap');
        string bodyContent = '<html>' + '<h4>'+'Hello :'+'</h4>'+ 'Overlaped Categories are'+ '<br/>'+'<br/>' +'<body align="center">'+'<table border="1" align="left">' + '<th><u>Opportunity Name</u></th>' + '<th><u>Opportunity Category</u></th>'+ '<th><u>Category</u></th>'+ '<th><u>Opportunity Owner</u></th>'+ '<th><u>Start Cycle</u></th>'+ '<th><u>End Cycle</u></th>';//'<tr align="center">' + '</tr>' + '<td>'+'li.subject__c'+'</td>' + '</table>' + '</body>' + '</html>';
        mail.setHtmlBody(eBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    } 
    
        
    private List<String> getEmailAddress(){
        // get the email addresses from custom settings
        France_Category_Overlap_NotificationList__c rls = [select Email_Addresses__c from France_Category_Overlap_NotificationList__c where name = 'ItalyCatOverlapNotification'];
        if (rls != null){
            return rls.Email_Addresses__c.split(';') ;
        }
        else {
            return null;
        }
    }
    
    //schedule the class
    global void execute(SchedulableContext ctx) {
        BatchItalyCategoryOverlapNotification batch1 = new BatchItalyCategoryOverlapNotification();
        ID batchprocessid = Database.executeBatch(batch1, 200);
    }
       
}