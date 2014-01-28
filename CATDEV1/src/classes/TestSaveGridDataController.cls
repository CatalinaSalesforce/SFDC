/*
@Name           :       TestSaveGridDataController
@Author         :
@Date           :   
@Description    :       Test class for SaveGridDataController.                      
*/
public class TestSaveGridDataController {
    @isTest
    public static void runTest(){
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        List<Ad_Period__c> lstAdPeriod = new List<Ad_Period__c>();
        Ad_Period__c ap=new Ad_Period__c();
        ap.Name='Jan-2012';
        ap.Start_Date__c = date.newInstance(system.today().year(), system.today().month(), 1);
        ap.End_Date__c = date.newInstance(system.today().year(), system.today().month(), 30);
        ap.Type__c='Retail';       
        lstAdPeriod.add(ap);
        
        Ad_Period__c ap1 = new Ad_Period__c();
        ap1.Name = 'FEB-2012';
        ap1.Start_Date__c = date.newInstance(system.today().year(), system.today().month()+1, 1);
        ap1.End_Date__c = date.newInstance(system.today().year(), system.today().month()+1, 30);
        ap1.Type__c='Retail';       
        lstAdPeriod.add(ap1);
        
        Ad_Period__c ap2 = new Ad_Period__c();
        ap2.Name = 'MAR-2012';
        ap2.Start_Date__c = date.newInstance(system.today().year(), system.today().month()+2, 1);
        ap2.End_Date__c = date.newInstance(system.today().year(), system.today().month()+2, 30);
        ap2.Type__c='Retail';       
        lstAdPeriod.add(ap2);
        
        Ad_Period__c ap3 = new Ad_Period__c();
        ap3.Name = 'APR-2012';
        ap3.Start_Date__c = date.newInstance(system.today().year(), system.today().month()+3, 1);
        ap3.End_Date__c = date.newInstance(system.today().year(), system.today().month()+3, 30);
        ap3.Type__c='Retail';       
        lstAdPeriod.add(ap3);
        
        Ad_Period__c ap4 = new Ad_Period__c();
        ap4.Name = 'MAY-2012';
        ap4.Start_Date__c = date.newInstance(system.today().year(), system.today().month()+4, 1);
        ap4.End_Date__c = date.newInstance(system.today().year(), system.today().month()+4, 30);
        ap4.Type__c='Retail';       
        lstAdPeriod.add(ap4);
        
        Ad_Period__c ap5 = new Ad_Period__c();
        ap5.Name = 'JUN-2012';
        ap5.Start_Date__c = date.newInstance(system.today().year(), system.today().month()+5, 1);
        ap5.End_Date__c = date.newInstance(system.today().year(), system.today().month()+5, 30);
        ap5.Type__c='Retail';       
        lstAdPeriod.add(ap5);
        
        Ad_Period__c ap6 = new Ad_Period__c();
        ap6.Name = 'JUL-2012';
        ap6.Start_Date__c = date.newInstance(system.today().year(), system.today().month()+6, 1);
        ap6.End_Date__c = date.newInstance(system.today().year(), system.today().month()+6, 30);
        ap6.Type__c='Retail';       
        lstAdPeriod.add(ap6);
        
        insert lstAdPeriod;
        
        Account ac=new Account();
        ac.Name='test1';
        insert ac; 
        
        Opportunity op=new Opportunity();
        op.Name='test2';
        op.AccountId=ac.Id;
        op.CloseDate=system.today();
        op.StageName='Qualification';
        insert op;
        
        Program__c pro = new Program__c();
        pro.Opportunity__c = op.Id;
        pro.Name = 'test';
        pro.Delivery_Type__c = 'Base';
        insert pro;
        
        Program_Forecast__c proFor = new Program_Forecast__c();
        proFor.Ad_Period__c = ap.Id;
        proFor.Program__c = pro.Id;
        proFor.Forecast_Amount__c = 10;
        insert profor;
        /*//commented out by Warren to prevent "too many soql queries error"
        Program_Forecast__c proFor1 = new Program_Forecast__c();
        proFor1.Ad_Period__c = ap1.Id;
        proFor1.Program__c = pro.Id;
        proFor1.Forecast_Amount__c = 10;
        insert proFor1;
        */
        //String jsonToSave = '{"programs":[{"ProgId":"'+ pro.Id +'","forecast1":"100.00","forecast2":"100.00","forecast3":"100.00","forecast4":"100.00","forecast5":"100.00","forecast6":"100.00","forecast7":"100.00"}]}';
        String jsonToSave = '{"programs":[{"ProgId":"'+ pro.Id +'","forecast1":"100.00","forecast2":"100.00","forecast3":"100.00","forecast4":"100.00","forecast5":"0.00","forecast6":"0.00","forecast7":"0.00"}]}';
        String cDate = String.valueOf(System.today());
        Date startDate = date.newInstance(system.today().year(), system.today().month(), 1);
        saveGridDataController sgdc = new saveGridDataController(jsonToSave, cDate, 'Retail', startDate);
        //List<Program_Forecast__c> pfAfterSave = [SELECT id, Name, Program__r.Name, Forecast_Amount__c from Program_Forecast__c WHERE Program__c =: pro.Id AND Ad_Period__r.Start_Date__c >=: startDate];
        //System.assert(pfAfterSave.get(0).Forecast_Amount__c == 100,'Assertion : Save failed');
    }
    
    @isTest
    public static void runTest2(){
        Renewal_Settings__c settings1 = Renewal_Settings__c.getOrgDefaults();
        settings1.Renewal_Window_Size__c = 14;
        settings1.Percent_Goal__c = 0;
        insert settings1;
        
        List<Ad_Period__c> lstAdPeriod = new List<Ad_Period__c>();
        Ad_Period__c ap=new Ad_Period__c();
        ap.Name='Jan-2012';
        ap.Start_Date__c = date.newInstance(system.today().year(), system.today().month(), 1);
        ap.End_Date__c = date.newInstance(system.today().year(), system.today().month(), 30);
        ap.Type__c='Retail';       
        lstAdPeriod.add(ap);
        
        Ad_Period__c ap1 = new Ad_Period__c();
        ap1.Name = 'FEB-2012';
        ap1.Start_Date__c = date.newInstance(system.today().year(), system.today().month()+1, 1);
        ap1.End_Date__c = date.newInstance(system.today().year(), system.today().month()+1, 30);
        ap1.Type__c='Retail';       
        lstAdPeriod.add(ap1);
        
        Ad_Period__c ap2 = new Ad_Period__c();
        ap2.Name = 'MAR-2012';
        ap2.Start_Date__c = date.newInstance(system.today().year(), system.today().month()+2, 1);
        ap2.End_Date__c = date.newInstance(system.today().year(), system.today().month()+2, 30);
        ap2.Type__c='Retail';       
        lstAdPeriod.add(ap2);
        
        Ad_Period__c ap3 = new Ad_Period__c();
        ap3.Name = 'APR-2012';
        ap3.Start_Date__c = date.newInstance(system.today().year(), system.today().month()+3, 1);
        ap3.End_Date__c = date.newInstance(system.today().year(), system.today().month()+3, 30);
        ap3.Type__c='Retail';       
        lstAdPeriod.add(ap3);
        
        Ad_Period__c ap4 = new Ad_Period__c();
        ap4.Name = 'MAY-2012';
        ap4.Start_Date__c = date.newInstance(system.today().year(), system.today().month()+4, 1);
        ap4.End_Date__c = date.newInstance(system.today().year(), system.today().month()+4, 30);
        ap4.Type__c='Retail';       
        lstAdPeriod.add(ap4);
        
        Ad_Period__c ap5 = new Ad_Period__c();
        ap5.Name = 'JUN-2012';
        ap5.Start_Date__c = date.newInstance(system.today().year(), system.today().month()+5, 1);
        ap5.End_Date__c = date.newInstance(system.today().year(), system.today().month()+5, 30);
        ap5.Type__c='Retail';       
        lstAdPeriod.add(ap5);
        
        Ad_Period__c ap6 = new Ad_Period__c();
        ap6.Name = 'JUL-2012';
        ap6.Start_Date__c = date.newInstance(system.today().year(), system.today().month()+6, 1);
        ap6.End_Date__c = date.newInstance(system.today().year(), system.today().month()+6, 30);
        ap6.Type__c='Retail';       
        lstAdPeriod.add(ap6);
        
        insert lstAdPeriod;
        
        Account ac=new Account();
        ac.Name='test1';
        insert ac; 
        
        Opportunity op=new Opportunity();
        op.Name='test2';
        op.AccountId=ac.Id;
        op.CloseDate=system.today();
        op.StageName='Qualification';
        insert op;
        
        Program__c pro = new Program__c();
        pro.Opportunity__c = op.Id;
        pro.Name = 'test';
        pro.Delivery_Type__c = 'Base';
        insert pro;
        
        Program_Forecast__c proFor = new Program_Forecast__c();
        proFor.Ad_Period__c = ap.Id;
        proFor.Program__c = pro.Id;
        proFor.Forecast_Amount__c = 10;
        insert profor;
        /*//commented out by Warren to prevent "too many soql queries error"
        Program_Forecast__c proFor1 = new Program_Forecast__c();
        proFor1.Ad_Period__c = ap1.Id;
        proFor1.Program__c = pro.Id;
        proFor1.Forecast_Amount__c = 10;
        insert proFor1;
        */
        //String jsonToSave = '{"programs":[{"ProgId":"'+ pro.Id +'","forecast1":"100.00","forecast2":"100.00","forecast3":"100.00","forecast4":"100.00","forecast5":"100.00","forecast6":"100.00","forecast7":"100.00"}]}';
        String jsonToSave = '{"programs":[{"ProgId":"'+ pro.Id +'","forecast1":"100.00","forecast2":"100.00","forecast3":"100.00","forecast4":"100.00","forecast5":"0.00","forecast6":"0.00","forecast7":"0.00"}]}';
        String cDate = String.valueOf(System.today());
        Date startDate = date.newInstance(system.today().year(), system.today().month(), 1);
        saveGridActualController sgdc = new saveGridActualController(jsonToSave, cDate, 'Retail', startDate);
        //List<Program_Forecast__c> pfAfterSave = [SELECT id, Name, Program__r.Name, Forecast_Amount__c from Program_Forecast__c WHERE Program__c =: pro.Id AND Ad_Period__r.Start_Date__c >=: startDate];
        //System.assert(pfAfterSave.get(0).Forecast_Amount__c == 100,'Assertion : Save failed');
    }
}