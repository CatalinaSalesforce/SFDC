public with sharing class Utility {
	
	
	public enum DeliveryChanel{BuyerVision,Base,Digital}
	
	

    public static String calendarMonth(integer month){
   
     IF(month==1){
     return 'JANUARY'; 
     }ELSE 
     IF(month==2){
     return 'FEBRUARY';
     }ELSE 
     IF(month==3){
     return 'MARCH';
     }ELSE 
     IF(month==4){
     return 'APRIL';
     }ELSE 
     IF(month==5){
     return 'MAY';
     }ELSE 
     IF(month==6){
     return 'JUNE';
     }ELSE 
     IF(month==7){
     return 'JULY';
     }ELSE 
     IF(month==8){
     return 'AUGUST';
     }ELSE 
     IF(month==9){
     return 'SEPTEMBER';
     }ELSE 
     IF(month==10){
     return 'OCTOBER';
     }ELSE 
     IF(month==11){
     return 'NOVEMBER';
     }ELSE 
     IF(month==12){
     return 'DECEMBER';
     }
     return null;
    }
}