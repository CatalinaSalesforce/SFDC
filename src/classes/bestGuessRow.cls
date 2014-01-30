/*

@Name           : bestGuessRow
@Author         : customersuccess@cloud62.com
@Date           : 09/25/2012
@Description    : Class used in Historical Best Guess to compare values
*/
global class bestGuessRow implements Comparable{
    //variables
    public Manager_Best_Guess__c teamMBG {get;set;}
    public Sales_Rep_Best_Guess__c teamSRBG {get;set;}
    public Historical_Manager_Best_Guess__c histMBG {get;set;}
    public Historical_Sales_Rep_Best_Guess__c histSRBG {get;set;}
    public List<Manager_Best_Guess__c> teamMBGList {get;set;}
    public List<Sales_Rep_Best_Guess__c> teamSRBGList {get;set;}
    public List<Historical_Manager_Best_Guess__c> histMBGList {get;set;}
    public List<Historical_Sales_Rep_Best_Guess__c> histSRBGList {get;set;}
    public String name {get;set;}
    public Decimal bestGuess {get;set;}
    public Decimal histBestGuess {get;set;}
    public Decimal BGDifference {get;set;}
    public Decimal bookedAmount {get;set;}
    public Decimal histBookedAmount {get;set;}
    public Decimal bookedDifference {get;set;}
    
    //constructor
    public bestGuessRow(){}
    //compareTo method
    global Integer compareTo(Object compareTo){
        bestGuessRow compareToBG = (bestGuessRow)compareTo;
        if(name<compareToBG.name) return 0;
        else return 1;
    }
}