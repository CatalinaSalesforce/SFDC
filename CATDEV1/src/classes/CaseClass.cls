// CaseClass, Contains Apex Code used in Case Object
// "SendToFulFillment" Boolean (for sending Case to Fulfillment)
// CreatedBy: JBettio 09/06/11
// LastModified: JBettio 09/07/11 9:30 AM

global class CaseClass {
    
    webservice static Boolean SendToFulfillment (Id csId)
    {
        Case cs = [SELECT Id, Subject, Status, OwnerId FROM Case Where Id = :csId];          
        
        //Update case owner to fulfillment queue. 
        try{
            Group ffGroup = [SELECT Id FROM Group Where Type = 'Queue' and Name = 'Fulfillment Queue' Limit 1];
            cs.OwnerId = ffGroup.Id;
            cs.Status = 'In Progress';
            cs.Sent_To_Fulfillment__c = true;
            
            //Create comment and link to the case. 
            CaseComment cc = new CaseComment();
            cc.ParentId = cs.Id;
            cc.CommentBody = 'Sent to Fulfillment.';            
            insert cc; 
            
            update cs; 
        }
        catch(Exception ex){
            System.debug('Cannot update queue.');
        }       

        {
            Case cscon=[Select contact.id from case where id = :csid limit 1];
            EmailTemplate et=[Select id from EmailTemplate where name=:'Sent for Fulfillment'];
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setWhatId(cs.id);
            mail.setTargetObjectId(cscon.contact.id);
            mail.setorgWideEmailAddressId('0D2F0000000PC9e');
            mail.setTemplateId(et.id);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
                 
        return true;
        } 
}