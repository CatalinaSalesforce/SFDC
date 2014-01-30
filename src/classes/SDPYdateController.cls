public class SDPYdateController {

/*
Dec 8 , 2012 - changed from 30 to 25 to avoid too many soql rows
*/


//Date SDPYdate;
//public String sdpyDate {get; set;}
//public String sdpyyear {get; set;}


public String sdpyDate{
get{
 return  getSdpyDate(sdpyDate);
}
set{
  sdpyDate = value; 
}
}


public String getSdpyDate(String year){

      Integer minDays = 1000;
      Date lastyear = Date.newinstance(Integer.valueOf(year),Date.Today().month(), Date.Today().day());
      //changed by Warren to 25 to avoid too many SOQL rows
      Date lastyear1 = lastyear.addDays(20);
      Date lastyear2 = lastyear.addDays(-20);
      
      Date archiveDate = Date.Today();
      AggregateResult ar;
      AggregateResult ar2;
      if (Test.isRunningTest()){
      ar = [Select Max(Archive_Date__c) Expr1 From Archive_Program__c Where Archive_Date__c <= :lastyear and Archive_Date__c >= :lastyear2];
        ar2 = [Select Min(Archive_Date__c) Expr2 From Archive_Program__c Where Archive_Date__c >= :lastyear and Archive_Date__c <= :lastyear1];
      } else {
        ar = [Select Max(Archive_Date__c) Expr1 From Archive_Program__c Where Archive_Date__c <= :lastyear and Archive_Date__c >= :lastyear2
            AND OPPORTUNITY__R.ACCOUNTID IN ('001F000000mCmOg','001F000000mCmfX','001F000000ni5Pn','001F000000mCmbL')];
      ar2 = [Select Min(Archive_Date__c) Expr2 From Archive_Program__c Where Archive_Date__c >= :lastyear and Archive_Date__c <= :lastyear1
            AND OPPORTUNITY__R.ACCOUNTID IN ('001F000000mCmOg','001F000000mCmfX','001F000000ni5Pn','001F000000mCmbL')];
      }

     Date nearestBefore = (Date)ar.get('Expr1');
      Date nearestAfter = (Date)ar2.get('Expr2');

     
      if( nearestBefore != null && nearestAfter != null){
      Integer numDaysBefore =  nearestBefore.daysBetween(lastyear);
      Integer numDaysAfter = lastyear.daysBetween(nearestAfter);   
            // archiveDate stores the nearest date from one year ago 
      if(numDaysBefore > numDaysAfter) {
            archiveDate = nearestAfter;
      }
      else {
                archiveDate = nearestBefore;
      }
      
   
      return  String.valueOf(archiveDate);
      } else if( nearestBefore != null && nearestAfter == null){
         
          return String.valueOf(nearestBefore);
         
       } else if( nearestBefore == null && nearestAfter != null){
         
          return String.valueOf(nearestAfter);
         
       } else{
      
         return 'SDPY date not found';
      
        }
     
     
}


}