/*

@Name           : AccountBestGuessRow
@Author         : customersuccess@cloud62.com
@Date           : 09/25/2012
@Description    : Class used in Historical Best Guess to compare values
*/
global class AccountBestGuessRow implements Comparable{
    //Variables
    public Historical_Account_Best_Guess_Summary__c histSRBG {get;set;}
    public String name {get;set;}
    public Decimal bestGuessQ1 {get;set;}
    public Decimal bestGuessQ2 {get;set;}
    public Decimal bestGuessQ3 {get;set;}
    public Decimal bestGuessQ4 {get;set;}
    public Decimal bestGuessQ1Change {get;set;}
    public Decimal bestGuessQ2Change {get;set;}
    public Decimal bestGuessQ3Change {get;set;}
    public Decimal bestGuessQ4Change {get;set;}        
    public Decimal bookedQ1 {get;set;}
    public Decimal bookedQ2 {get;set;}
    public Decimal bookedQ3 {get;set;}
    public Decimal bookedQ4 {get;set;} 
    public Decimal bookedQ1Change {get;set;}
    public Decimal bookedQ2Change {get;set;}
    public Decimal bookedQ3Change {get;set;}
    public Decimal bookedQ4Change {get;set;} 
    public Decimal bookedtotal {get;set;} 
    public Decimal bestGuesstotal {get;set;} 
    public Decimal bookedYearChange {get;set;}
    public Decimal bestGuessYearChange {get;set;} 
    public String owner {get;set;}               
        
    //Constructor
    public AccountBestGuessRow(){}
        //compareTo method
        global Integer compareTo(Object compareTo){
            AccountBestGuessRow compareToBG = (AccountBestGuessRow)compareTo;
            if(name<compareToBG.name) return 0;
            else return 1;
        }
}