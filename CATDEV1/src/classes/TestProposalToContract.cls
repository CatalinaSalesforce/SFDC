@isTest()
global class TestProposalToContract
{
    
    
    global static testMethod void testNew(){
    	String proposalID = [SELECT ID FROM RECORDTYPE WHERE Name = 'Proposal' and SOBJECTTYPE = 'Opportunity'][0].Id;
        Account a = init();
        Opportunity opp0 = new Opportunity();
        opp0.RecordTypeId = proposalId;
        opp0.Name = 'test oppty';
        opp0.StageName = 'Qualification';
        opp0.CloseDate = Date.Today();
        opp0.AccountId = a.Id;
        opp0.Product_Type__c = 'NA';
        opp0.Type='New' ;
        opp0.Catalina_Business_Unit__c='Base;Digital O&O';
        insert opp0;
        List<Program__c> programs0 = [Select id,External_ID__c,Delivery_Type__c from Program__c p where p.Opportunity__c=:opp0.id];
        for(Program__c program:programs0){
            Program_Forecast__c programfc = new Program_Forecast__c();
            programfc.Ad_Period__c=[Select a.Id From Ad_Period__c a limit 1].id;
            programfc.Program__c=program.id;
            insert programfc;
        }
        
        opp0.CATS_External_ID__c='catsid0';
        update opp0;
        Opportunity contract0 = [Select o.Id, o.CATS_External_ID__c, o.StageName, o.Probability From Opportunity o where o.id=:opp0.id];
        System.assertEquals('catsid0', contract0.CATS_External_ID__c, 'CATS_External_ID__c does not match');
        System.assertEquals('Closed Won', contract0.StageName, 'Stage does not match');
        System.assertEquals(100, contract0.Probability, 'Probability does not match');
        List<Program__c> programs = [Select id,External_ID__c,Delivery_Type__c from Program__c p where p.Opportunity__c=:contract0.id];
        System.debug('-----------------------------------------------');
        for(Program__c program:programs){
            List<Program_Forecast__c> programfcs = [Select id,External_ID__c,Ad_Period__r.Name from Program_Forecast__c p where p.Program__c=:program.id];
            for(Program_Forecast__c programfc:programfcs){
                System.assertEquals('catsid0'+program.Delivery_Type__c+programfc.Ad_Period__r.Name, programfc.External_ID__c, 'Program fc External_ID__c does not match');
            }
            System.debug(program.Delivery_Type__c);
            System.assertEquals('catsid0'+program.Delivery_Type__c, program.External_ID__c, 'Program External_ID__c does not match');
        }       
    }
    global static testMethod void testRenewal(){
    	String proposalID = [SELECT ID FROM RECORDTYPE WHERE Name = 'Proposal' and SOBJECTTYPE = 'Opportunity'][0].Id;
        Account a = init();
        Opportunity opp0 = new Opportunity();
        opp0.RecordTypeId = proposalId;
        opp0.Name = 'test oppty';
        opp0.StageName = 'Qualification';
        opp0.CloseDate = Date.Today();
        opp0.AccountId = a.Id;
        opp0.Product_Type__c = 'NA';
        opp0.Type='Renewal' ;
        opp0.Catalina_Business_Unit__c='Base;Digital O&O';
        insert opp0;


        List<Program__c> programs0 = [Select id,External_ID__c,Delivery_Type__c from Program__c p where p.Opportunity__c=:opp0.id];
        for(Program__c program:programs0){
            Program_Forecast__c programfc = new Program_Forecast__c();
            programfc.Ad_Period__c=[Select a.Id From Ad_Period__c a limit 1].id;
            programfc.Program__c=program.id;
            insert programfc;
        }
        
        opp0.CATS_External_ID__c='catsid0';
        update opp0;
        Opportunity contract0 = [Select o.Id, o.CATS_External_ID__c, o.StageName, o.Probability From Opportunity o where o.id=:opp0.id];
        System.assertEquals('catsid0', contract0.CATS_External_ID__c, 'CATS_External_ID__c does not match');
        System.assertEquals('Closed Won Renewal', contract0.StageName, 'Stage does not match');
        System.assertEquals(100, contract0.Probability, 'Probability does not match');
        List<Program__c> programs = [Select id,External_ID__c,Delivery_Type__c from Program__c p where p.Opportunity__c=:contract0.id];
        System.debug('-----------------------------------------------');
        for(Program__c program:programs){
            List<Program_Forecast__c> programfcs = [Select id,External_ID__c,Ad_Period__r.Name from Program_Forecast__c p where p.Program__c=:program.id];
            for(Program_Forecast__c programfc:programfcs){
                System.assertEquals('catsid0'+program.Delivery_Type__c+programfc.Ad_Period__r.Name, programfc.External_ID__c, 'Program fc External_ID__c does not match');
            }
            System.debug(program.Delivery_Type__c);
            System.assertEquals('catsid0'+program.Delivery_Type__c, program.External_ID__c, 'Program External_ID__c does not match');
        }       
    }
    /*
    global static testMethod void testAddedndum(){
    	
    	String proposalID = [SELECT ID FROM RECORDTYPE WHERE Name = 'Proposal' and SOBJECTTYPE = 'Opportunity'][0].Id;
        Account a = init();
        Opportunity opp = new Opportunity();
        opp.RecordTypeId = proposalId;
        opp.Name = 'test addendum parent oppty';
        opp.StageName = 'Contract';
        opp.CloseDate = Date.Today();
        opp.AccountId = a.Id;
        opp.Product_Type__c = 'NA';
        opp.Type='New' ;
        opp.Catalina_Business_Unit__c='Base;Digital O&O';
        insert opp;

        Opportunity opp0 = new Opportunity();
        opp0.RecordTypeId = proposalId;
        opp0.Name = 'test oppty';
        opp0.StageName = 'Qualification';
        opp0.CloseDate = Date.Today();
        opp0.AccountId = a.Id;
        opp0.Product_Type__c = 'NA';
        opp0.Type='Addendum' ;
        opp0.Parent_Contract__c=opp.id;
        opp0.Catalina_Business_Unit__c='Base;Digital O&O';
        insert opp0;
        List<Program__c> programs0 = [Select id,External_ID__c,Delivery_Type__c from Program__c p where p.Opportunity__c=:opp0.id];
        for(Program__c program:programs0){
            Program_Forecast__c programfc = new Program_Forecast__c();
            programfc.Ad_Period__c=[Select a.Id From Ad_Period__c a limit 1].id;
            programfc.Program__c=program.id;
            insert programfc;
        }
        
        opp0.CATS_External_ID__c='catsid0';
        update opp0;
        Opportunity contract0 = [Select o.Id, o.CATS_External_ID__c, o.StageName, o.Probability From Opportunity o where o.id=:opp0.id];
        System.assertEquals('catsid0', contract0.CATS_External_ID__c, 'CATS_External_ID__c does not match');
        System.assertEquals('Closed Won Addendum', contract0.StageName, 'Stage does not match');
        System.assertEquals(0, contract0.Probability, 'Probability does not match');
        List<Program__c> programs = [Select id,External_ID__c,Delivery_Type__c from Program__c p where p.Opportunity__c=:contract0.id];
        System.debug('-----------------------------------------------');
        for(Program__c program:programs){
            List<Program_Forecast__c> programfcs = [Select id,External_ID__c,Ad_Period__r.Name from Program_Forecast__c p where p.Program__c=:program.id];
            for(Program_Forecast__c programfc:programfcs){
                System.assertEquals('catsid0'+program.Delivery_Type__c+programfc.Ad_Period__r.Name, programfc.External_ID__c, 'Program fc External_ID__c does not match');
            }
            System.debug(program.Delivery_Type__c);
            System.assertEquals('catsid0'+program.Delivery_Type__c, program.External_ID__c, 'Program External_ID__c does not match');
        }       
    }*/

    static Account init(){
    	Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        List<Ad_Period__c> lstAdPeriod = new List<Ad_Period__c>();
        Ad_Period__c ap=new Ad_Period__c();
        ap.Name='Jan-2012';
        ap.Start_Date__c = date.newInstance(system.today().year(), system.today().month(), 1);
        ap.End_Date__c = date.newInstance(system.today().year(), system.today().month(), 30);
        ap.Type__c='Manufacturing';
        lstAdPeriod.add(ap);
        
        Ad_Period__c ap1 = new Ad_Period__c();
        ap1.Name = 'FEB-2012';
        ap1.Start_Date__c = date.newInstance(system.today().year(), system.today().month()+1, 1);
        ap1.End_Date__c = date.newInstance(system.today().year(), system.today().month()+1, 30);
        ap1.Type__c='Manufacturing';       
        lstAdPeriod.add(ap1);
                
        insert lstAdPeriod;
        
        String accountRTID = [SELECT ID FROM RecordType Where Name = 'Manufacturing' and SOBJECTTYPE = 'Account'][0].Id;
        String accountRTID2 = [select ID from RecordType where name = 'Retail' and SOBJECTTYPE = 'Account'][0].Id;
        Account a = new Account();
        a.Name = 'test 1234';
        a.RecordTypeId = accountRTID;
        a.CATS_External_ID__c ='CL8888BS1';
        insert a;
        return a;
    }

}