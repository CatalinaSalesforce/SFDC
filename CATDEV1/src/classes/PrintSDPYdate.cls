/*
Dec 8 , 2012 - changed from 30 to 25 to avoid too many soql rows
*/
public class PrintSDPYdate{

//Date SDPYdate;
public String x {get; set;}

public PrintSDPYdate(){
      Integer minDays = 1000;
      Date lastyear = Date.Today().addYears(-1);
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
      Integer numDaysBefore = nearestBefore.daysBetween(lastyear);
      Integer numDaysAfter = lastyear.daysBetween(nearestAfter);   
            // archiveDate stores the nearest date from one year ago 
      if(numDaysBefore > numDaysAfter) {
            archiveDate = nearestAfter;
      }
      else {
                archiveDate = nearestBefore;
      }
      x = String.valueOf(archiveDate);
}
/* August 14, 2012 Modified by JB
public PrintSDPYdate(){
    Date lastyear = Date.Today().addYears(-1);
      Date lastyear2 = lastyear.addDays(-45);
      AggregateResult ar = [Select Max(Archive_Date__c) Expr1 From Archive_Program__c Where Archive_Date__c <= :lastyear and Archive_Date__c >= :lastyear2]; 
      Date SDPYdate = (Date)ar.get('Expr1');
      x = String.valueOf((Date)ar.get('Expr1'));
}*/
/*
public Date getSDPYdate() {
return SDPYdate;
}
public void setSDPYdate() {
      Date lastyear = Date.Today().addYears(-1);
      Date lastyear2 = lastyear.addDays(-45);
      AggregateResult ar = [Select Max(Archive_Date__c) Expr1 From Archive_Program__c Where Archive_Date__c <= :lastyear and Archive_Date__c >= :lastyear2]; 
      Date SDPYdate = (Date)ar.get('Expr1');
      //x = String.valueOf((Date)ar.get('Expr1'));
}*/
}