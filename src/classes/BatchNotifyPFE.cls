/*
@Name            : BatchNotifyPFE 
@Author          : customersuccess@cloud62.com
@Date            : December 17th, 2012
@Description     : This class sends out an email notice at the end of the batch process with a summary of
					issues that need to be resolved
*/
global class BatchNotifyPFE implements Database.Batchable<sObject>, Schedulable{

    final static String defaultSettingsName = 'Default';
    
    //custom settings variables
    Catalina_Forecast_Settings__c settings;
    String query;
    
    global Database.querylocator start(Database.BatchableContext BC){
        BatchGovernorLimitUtility.insertBatchRun('BatchNotifyPFE');
        query = 'Select ID, NAME, PROGRAM__C, PROGRAM_FORECAST__C, REASON__C From PROGRAM_FORECAST_EXCEPTION__C ';
        return Database.getQueryLocator(query);
    }
    
    global void execute(SchedulableContext ctx) {
        BatchNotifyPFE batch1 = new BatchNotifyPFE();
        ID batchprocessid = Database.executeBatch(batch1);
    }
    
    global void execute(Database.BatchableContext NC, List<sObject> scope){
        Datetime currentTime = System.now();
        List<Program_Forecast_Exception__c> pfeScope = (List<Program_Forecast_Exception__c>)scope;
        Set<String> reasonSet = new Set<String>();
        Map<String, Integer> reasonCount = new Map<String, Integer>();
        
        //if email settings have been provided, build the email and send it
        settings = Catalina_Forecast_Settings__c.getInstance(defaultSettingsName);
        if (settings.PFE_Email__c != null){
            List<String> toAddress = settings.PFE_Email__c.split(';');
            
            //group counts to provide a total of each reason
            for (Program_Forecast_Exception__c e : pfeScope){
                reasonSet.add(e.Reason__c);
                if (!reasonCount.containsKey(e.Reason__c)){
                    reasonCount.put(e.Reason__c, 0);
                }
                Integer tempInt = reasonCount.get(e.Reason__c);
                tempInt++;
                reasonCount.remove(e.Reason__c);
                reasonCount.put(e.Reason__c, tempInt);
            }
            
            List<Messaging.Singleemailmessage> emailsToSend = new List<Messaging.Singleemailmessage>();
            Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
            
            List<String> toAddy = new List<String>();
            
            String body = 'Catalina Batch Process Log:\r\n' +
            '----------------------------------------\r\n\r\n';
            for (String x : reasonSet){
                body += x + ' - ' + reasonCount.get(x) + ' Errors.\r\n';
            }
            body += '\r\n----------------------------------------\r\n\r\n' +
            'Thank You,\r\n' +
            'SFDC Team';
            
            system.debug(body);
            mail.setToAddresses(toAddress);
            mail.setSenderDisplayName('Catalina Batch Process');
            mail.setSubject('Catalina Batch Process Error Log');
            mail.setPlainTextBody(body);
            emailsToSend.add(mail);
            
            system.debug('***size: ' + emailsToSend.size());
            Messaging.Sendemailresult[] r = Messaging.sendEmail(emailsToSend);
        }
        BatchGovernorLimitUtility.calcualteLimits(Limits.getCpuTime(), Limits.getDMLRows(), Limits.getDMLStatements(), Limits.getHeapSize(), Limits.getQueries(), Limits.getQueryRows(), Limits.getScriptStatements(), scope, currentTime, System.now());
        
    }
    
    global void finish(Database.BatchableContext BC){
         //Build the system time of now + 20 seconds to schedule the batch apex.
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(20);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        BatchSalesManager1ForecastRecycleBin binBatch2Sched = new BatchSalesManager1ForecastRecycleBin();
        //Schedule the next job, and give it the system time so name is unique
        System.schedule('BatchSalesManager1ForecastRecycleBin' + sysTime.getTime(),chron_exp,binBatch2Sched);
        BatchGovernorLimitUtility.updateBatchRun();
    }

}