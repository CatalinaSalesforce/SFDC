public without sharing class OverRidePAController {

   
  public OverRidePAController() {
  
  
   
    }
  public list<Program__c> programsList{get;set;}


  public id oppId{
    
    get{

    return apexpages.currentpage().getparameters().get('oppId');  
     }
    
   
    set;
    }
    
    public list<program__c> getPrograms(){

    programsList = [select id, name, Delivery_Type__c,Actual_Amount__c,Program_Amount__c,Forecast_Amount__c,Total_Amount__c,Variance__c,External_Id__c from program__c where Delivery_Type__c != null and Opportunity__c = : oppId limit 100];
   
    return programsList;
    }
    
    public opportunity getOpportunity{
      
      get{

    
     
       return [select id, Amount from Opportunity where id=:oppId];
  
      }
      private set;
    }
    
    public PageReference Save(){
    
   
    Decimal prgAmt=0;
    
    for(Program__c p: ProgramsList){
    
    if(p.Program_Amount__c != null){
       prgAmt += p.Program_Amount__c; 
      }
    }
    if(prgAmt == getOpportunity.Amount){
    
     update programsList;
     
    return  new PageReference('javascript:top.window.close();'); 
    }else{
    
      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Sum of Program Amounts not equal to opportunity Amount')); 
      
       return null;
    }
   
    } 
    

}