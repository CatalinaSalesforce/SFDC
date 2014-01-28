@isTest(seeAllData=false)
public class SDPYdateController_Test{
    
   public static string year = String.valueOf(Date.Today().Year()-1);
  
    
    static testmethod void testGetSDPYdate(){
        
        SDPYdateController_Test test = new SDPYdateController_Test();
        test.testData();
    
        SDPYdateController sc = new SDPYdateController(); 
        sc.sdpyDate = year; 
        
        System.debug(sc.sdpyDate);
       // System.assertNotEquals(sc.sdpyDate,'SDPY date not found');
    
    
    }
    
     public void testData()
   {
       Date lastyear = Date.newinstance(Integer.valueOf(year),Date.Today().month(), Date.Today().day());
       Date lastyear1 = lastyear.addDays(20);
       Date lastyear2 = lastyear.addDays(-20);
     

         //opportunity opr = [select id from  opportunity limit 1];
         Archive_Program__c aprg = new Archive_Program__c();
          // aprg.Opportunity__c = opr.id;
           aprg.Name = 'test prgr';
           aprg.Ext_ID__c='Test';
           aprg.Archive_Date__c=lastyear.addDays(-10);
           
  
       // opportunity opr2 = [select id from  opportunity limit 1];
         Archive_Program__c aprg2 = new Archive_Program__c();
         //  aprg2.Opportunity__c = opr2.id;
           aprg2.Name = 'test prgr2';
           aprg2.Ext_ID__c='Test';
           aprg2.Archive_Date__c=lastyear.addDays(25);
           
      

    }
    

}