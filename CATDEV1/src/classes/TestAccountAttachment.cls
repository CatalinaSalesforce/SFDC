@isTest
private class TestAccountAttachment {

    static testmethod void testAccountAttachment(){ 
        AccountAttachment at = new AccountAttachment ();
        at.getContacts();
        at.showMore();
    }


    static testmethod void testAccountBigBetAttachment(){ 
        AccountBigBetAttachment at = new AccountBigBetAttachment ();
        at.getContacts();
        at.showMore();
    }
    
       static testmethod void testPlatinumBetLatestAttachmentController(){ 
        PlatinumBetLatestAttachmentController pt = new PlatinumBetLatestAttachmentController ();
        pt.showMore();
    } 
    
}