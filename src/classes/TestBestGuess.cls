/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestBestGuess {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Manager_Best_Guess__c a2 = new Manager_Best_Guess__c();
        insert a2;
        
        Manager_Best_Guess__c a = new Manager_Best_Guess__c();
        a.Manager_Best_Guess__c = a2.Id;
        insert a;
        
        Manager_Best_Guess__c b = new Manager_Best_Guess__c();
        b.Manager_Best_Guess__c = a.Id;
        insert b;
        
        Manager_Best_Guess__c c = new Manager_Best_Guess__c();
        c.Manager_Best_Guess__c = a.Id;
        insert c;
        
        Sales_Rep_Best_Guess__c d = new Sales_Rep_Best_Guess__c();
        d.Manager_Best_Guess__c = a.Id;
        insert d;
        
        d.Manufacturing_Base_Best_Guess__c = 2999;
        update d; 
        
        List<Manager_Best_Guess__c> list1 = new List<Manager_Best_Guess__c>();
        
        b.Team_Booked_Actual__c = 10.00;
        b.Override_Team_Manu_Base_Best_Guess__c = 1000;
        list1.add(b);
        
        c.Team_Booked_Actual__c = 15.00;
        c.Override_Team_Manu_Base_Best_Guess__c = 2000;
        list1.add(c);
        
        update list1;
        
        a2 = [SELECT ID, TEAM_BOOKED_ACTUAL__C, Team_Manufacturing_Base_Best_Guess__c FROM MANAGER_BEST_GUESS__C WHERE ID =: a2.Id][0];
        system.assert(a2.Team_Booked_Actual__c == 25);
        //system.debug('***value: ' + a2.Team_Manufacturing_Base_Best_Guess__c);
        system.assert(a2.Team_Manufacturing_Base_Best_Guess__c == 5999);
        
        a.Override_Team_Manu_Base_Best_Guess__c = 1;
        update a;
        
        a2 = [SELECT ID, TEAM_BOOKED_ACTUAL__C, Team_Manufacturing_Base_Best_Guess__c FROM MANAGER_BEST_GUESS__C WHERE ID =: a2.Id][0];
        //system.debug('***value: ' + a2.Team_Manufacturing_Base_Best_Guess__c);
        system.assert(a2.Team_Manufacturing_Base_Best_Guess__c == 1);
        
        a.Override_Team_Manu_Base_Best_Guess__c = null;
        update a;
        
        a2 = [SELECT ID, TEAM_BOOKED_ACTUAL__C, Team_Manufacturing_Base_Best_Guess__c FROM MANAGER_BEST_GUESS__C WHERE ID =: a2.Id][0];
        //system.debug('***value: ' + a2.Team_Manufacturing_Base_Best_Guess__c);
        system.assert(a2.Team_Manufacturing_Base_Best_Guess__c == 5999);
        
    }
    
    static testMethod void myUnitTest2() {
        // TO DO: implement unit test
        List<Manager_Best_Guess__c> list1 = [Select Id, Override_Team_Manu_Base_Best_Guess__c From Manager_Best_Guess__c Limit 5];
        for (Manager_Best_Guess__c a : list1){
            a.Override_Team_Manu_Base_Best_Guess__c  = 99999;
            a.Override_Team_Manu_Digital_Low__c  = 999999999;
            a.Team_Manufacturing_Base_Low__c  = 999999999;
        }
        update list1;
        
    }
    
    static testMethod void testSRBGRollup(){
    	Manager_Best_Guess__c mbg = new Manager_Best_Guess__c();
    	insert mbg;
    	
    	Sales_Rep_Best_Guess__c child = new Sales_Rep_Best_Guess__c();
    	child.Manager_Best_Guess__c = mbg.Id;
    	insert child;
    	
    	child.Actual_Amount__c = 1;
    	child.Weighted_Forecast_Proposal__c = 1;
    	child.Forecast_Proposal__c = 2;
    	child.Previous_Year_Actual__c = 1;
    	child.M_A_Actual_Amount__c = 1;
    	child.M_A_Forecast_Proposal__c = 1;
    	child.M_A_Weighted_Forecast_Proposal__c = 1;
		child.M_B_Actual_Amount__c = 1;
    	child.M_B_Forecast_Proposal__c = 1;
    	child.M_B_Weighted_Forecast_Proposal__c = 1;
		child.M_D_Actual_Amount__c = 1;
    	child.M_D_Forecast_Proposal__c = 1;
    	child.M_D_Weighted_Forecast_Proposal__c = 1;
		child.M_M_Actual_Amount__c = 1;
    	child.M_M_Forecast_Proposal__c = 1;
    	child.M_M_Weighted_Forecast_Proposal__c = 1;
		child.R_A_Actual_Amount__c = 1;
    	child.R_A_Forecast_Proposal__c = 1;
    	child.R_A_Weighted_Forecast_Proposal__c = 1;
		child.R_B_Actual_Amount__c = 1;
    	child.R_B_Forecast_Proposal__c = 1;
    	child.R_B_Weighted_Forecast_Proposal__c = 1;
		child.R_D_Actual_Amount__c = 1;
    	child.R_D_Forecast_Proposal__c = 1;
    	child.R_D_Weighted_Forecast_Proposal__c = 1;
		child.R_M_Actual_Amount__c = 1;
    	child.R_M_Forecast_Proposal__c = 1;
    	child.R_M_Weighted_Forecast_Proposal__c = 1;
    	child.Manufacturing_Base_Best_Guess__c = 1;
    	child.Manufacturing_Base_High__c = 1;
    	child.Manufacturing_Base_Low__c = 1;
		child.Manufacturing_Digital_Best_Guess__c = 1;
    	child.Manufacturing_Digital_High__c = 1;
    	child.Manufacturing_Digital_Low__c = 1;
		child.Manufacturing_Mobile_Best_Guess__c = 1;
    	child.Manufacturing_Mobile_High__c = 1;
    	child.Manufacturing_Mobile_Low__c = 1;
		child.Manufacturing_Audience_Best_Guess__c = 1;
    	child.Manufacturing_Audience_High__c = 1;
    	child.Manufacturing_Audience_Low__c = 1;
		child.Retail_Base_Best_Guess__c = 1;
    	child.Retail_Base_High__c = 1;
    	child.Retail_Base_Low__c = 1;
		child.Retail_Digital_Best_Guess__c = 1;
    	child.Retail_Digital_High__c = 1;
    	child.Retail_Digital_Low__c = 1;
		child.Retail_Mobile_Best_Guess__c = 1;
    	child.Retail_Mobile_High__c = 1;
    	child.Retail_Mobile_Low__c = 1;
		child.Retail_Audience_Best_Guess__c = 1;
    	child.Retail_Audience_High__c = 1;
    	child.Retail_Audience_Low__c = 1;
    	
    	update child;
    	
    	mbg = [Select m.Team_Retail_Digital_Low__c, m.Team_Retail_Digital_High__c, m.Team_Retail_Digital_Best_Guess__c, 
        m.Team_Retail_Base_Low__c, m.Team_Retail_Base_High__c, m.Team_Retail_Base_Best_Guess__c, m.Team_Quota__c, m.Team_Manufacturing_Digital_Low__c, 
        m.Team_Manufacturing_Digital_High__c, m.Team_Manufacturing_Digital_Best_Guess__c, m.Team_Manufacturing_Base_Low__c, m.Team_Manufacturing_Base_High__c, 
        m.Team_Manufacturing_Base_Best_Guess__c, m.Team_Booked_Proposal__c, m.Team_Booked_Actual__c, m.OwnerId, m.Name, m.Manager_Best_Guess__c, m.Id,
        m.Team_Previous_Year_Actual__c, m.Team_Booked_Full_Proposal__c,
        m.Team_M_A_Booked_Actual__c, m.Team_M_A_Booked_Full_Proposal__c, m.Team_M_A_Booked_Proposal__c,
        m.Team_M_B_Booked_Actual__c, m.Team_M_B_Booked_Full_Proposal__c, m.Team_M_B_Booked_Proposal__c,
        m.Team_M_D_Booked_Actual__c, m.Team_M_D_Booked_Full_Proposal__c, m.Team_M_D_Booked_Proposal__c,
        m.Team_M_M_Booked_Actual__c, m.Team_M_M_Booked_Full_Proposal__c, m.Team_M_M_Booked_Proposal__c,
        m.Team_R_A_Booked_Actual__c, m.Team_R_A_Booked_Full_Proposal__c, m.Team_R_A_Booked_Proposal__c,
        m.Team_R_B_Booked_Actual__c, m.Team_R_B_Booked_Full_Proposal__c, m.Team_R_B_Booked_Proposal__c,
        m.Team_R_D_Booked_Actual__c, m.Team_R_D_Booked_Full_Proposal__c, m.Team_R_D_Booked_Proposal__c,
        m.Team_R_M_Booked_Actual__c, m.Team_R_M_Booked_Full_Proposal__c, m.Team_R_M_Booked_Proposal__c,
        m.Team_Manufacturing_Audience_Best_Guess__c, m.Team_Manufacturing_Audience_High__c, m.Team_Manufacturing_Audience_Low__c,
        m.Team_Manufacturing_Mobile_Best_Guess__c, m.Team_Manufacturing_Mobile_High__c, m.Team_Manufacturing_Mobile_Low__c,
        m.Team_Retail_Audience_Best_Guess__c, m.Team_Retail_Audience_High__c, m.Team_Retail_Audience_Low__c,
        m.Team_Retail_Mobile_Best_Guess__c, m.Team_Retail_Mobile_High__c, m.Team_Retail_Mobile_Low__c
        From Manager_Best_Guess__c m WHERE M.id =: mbg.Id][0];
        
        system.assert(mbg.Team_Booked_Actual__c == 1);
        system.assert(mbg.Team_Booked_Proposal__c == 2);
        system.assert(mbg.Team_Booked_Full_Proposal__c == 3);
        system.assert(mbg.Team_Previous_Year_Actual__c == 1);
        system.assert(mbg.Team_M_A_Booked_Actual__c == 1);
        system.assert(mbg.Team_M_A_Booked_Full_Proposal__c == 2);
        system.assert(mbg.Team_M_A_Booked_Proposal__c == 2);                
        system.assert(mbg.Team_M_B_Booked_Actual__c == 1);
        system.assert(mbg.Team_M_B_Booked_Full_Proposal__c == 2);
        system.assert(mbg.Team_M_B_Booked_Proposal__c == 2);
        system.assert(mbg.Team_M_D_Booked_Actual__c == 1);
        system.assert(mbg.Team_M_D_Booked_Full_Proposal__c == 2);
        system.assert(mbg.Team_M_D_Booked_Proposal__c == 2);
        system.assert(mbg.Team_M_M_Booked_Actual__c == 1);                
        system.assert(mbg.Team_M_M_Booked_Full_Proposal__c == 2);
        system.assert(mbg.Team_M_M_Booked_Proposal__c == 2);
        system.assert(mbg.Team_R_A_Booked_Actual__c == 1);
        system.assert(mbg.Team_R_A_Booked_Full_Proposal__c == 2);
        system.assert(mbg.Team_R_A_Booked_Proposal__c == 2);
        system.assert(mbg.Team_R_B_Booked_Actual__c == 1);                
        system.assert(mbg.Team_R_B_Booked_Full_Proposal__c == 2);
        system.assert(mbg.Team_R_B_Booked_Proposal__c == 2);
        system.assert(mbg.Team_R_D_Booked_Actual__c == 1);
        system.assert(mbg.Team_R_D_Booked_Full_Proposal__c == 2);
        system.assert(mbg.Team_R_D_Booked_Proposal__c == 2);
        system.assert(mbg.Team_R_M_Booked_Actual__c == 1);
        system.assert(mbg.Team_R_M_Booked_Full_Proposal__c == 2);                
        system.assert(mbg.Team_R_M_Booked_Proposal__c == 2);
    	system.assert(mbg.Team_Manufacturing_Base_Best_Guess__c == 1);
        system.assert(mbg.Team_Manufacturing_Base_High__c == 1);
        system.assert(mbg.Team_Manufacturing_Base_Low__c == 1);
        system.assert(mbg.Team_Manufacturing_Digital_Best_Guess__c == 1);
        system.assert(mbg.Team_Manufacturing_Digital_High__c == 1);
        system.assert(mbg.Team_Manufacturing_Digital_Low__c == 1);
        system.assert(mbg.Team_Retail_Base_Best_Guess__c == 1);
        system.assert(mbg.Team_Retail_Base_High__c == 1);
        system.assert(mbg.Team_Retail_Base_Low__c == 1);
        system.assert(mbg.Team_Retail_Digital_Best_Guess__c == 1);
        system.assert(mbg.Team_Retail_Digital_High__c == 1);
        system.assert(mbg.Team_Retail_Digital_Low__c == 1);
        system.assert(mbg.Team_Manufacturing_Audience_Best_Guess__c == 1);
        system.assert(mbg.Team_Manufacturing_Audience_High__c == 1);
        system.assert(mbg.Team_Manufacturing_Audience_Low__c == 1);
        system.assert(mbg.Team_Manufacturing_Mobile_Best_Guess__c == 1);
        system.assert(mbg.Team_Manufacturing_Mobile_High__c == 1);
        system.assert(mbg.Team_Manufacturing_Mobile_Low__c == 1);
        system.assert(mbg.Team_Retail_Audience_Best_Guess__c == 1);
        system.assert(mbg.Team_Retail_Audience_High__c == 1);
        system.assert(mbg.Team_Retail_Audience_Low__c == 1);
        system.assert(mbg.Team_Retail_Mobile_Best_Guess__c == 1);
        system.assert(mbg.Team_Retail_Mobile_High__c == 1);
        system.assert(mbg.Team_Retail_Mobile_Low__c == 1);
        
    }
    
    static testMethod void testMBGRollup(){
    	Manager_Best_Guess__c mbg = new Manager_Best_Guess__c();
    	insert mbg;
    	
    	Manager_Best_Guess__c child = new Manager_Best_Guess__c();
    	child.Manager_Best_Guess__c = mbg.Id;
    	insert child;
    	
    	child.Team_Booked_Actual__c = 1;
    	child.Team_Booked_Proposal__c = 1;
    	child.Team_Booked_Full_Proposal__c = 1;
    	child.Team_Previous_Year_Actual__c = 1;
    	child.Team_M_A_Booked_Actual__c = 1;
    	child.Team_M_A_Booked_Full_Proposal__c = 1;
    	child.Team_M_A_Booked_Proposal__c = 1;
		child.Team_M_B_Booked_Actual__c = 1;
    	child.Team_M_B_Booked_Full_Proposal__c = 1;
    	child.Team_M_B_Booked_Proposal__c = 1;
		child.Team_M_D_Booked_Actual__c = 1;
    	child.Team_M_D_Booked_Full_Proposal__c = 1;
    	child.Team_M_D_Booked_Proposal__c = 1;
		child.Team_M_M_Booked_Actual__c = 1;
    	child.Team_M_M_Booked_Full_Proposal__c = 1;
    	child.Team_M_M_Booked_Proposal__c = 1;
		child.Team_R_A_Booked_Actual__c = 1;
    	child.Team_R_A_Booked_Full_Proposal__c = 1;
    	child.Team_R_A_Booked_Proposal__c = 1;
		child.Team_R_B_Booked_Actual__c = 1;
    	child.Team_R_B_Booked_Full_Proposal__c = 1;
    	child.Team_R_B_Booked_Proposal__c = 1;
		child.Team_R_D_Booked_Actual__c = 1;
    	child.Team_R_D_Booked_Full_Proposal__c = 1;
    	child.Team_R_D_Booked_Proposal__c = 1;
		child.Team_R_M_Booked_Actual__c = 1;
    	child.Team_R_M_Booked_Full_Proposal__c = 1;
    	child.Team_R_M_Booked_Proposal__c = 1;
    	child.Team_Manufacturing_Base_Best_Guess__c = 1;
    	child.Team_Manufacturing_Base_High__c = 1;
    	child.Team_Manufacturing_Base_Low__c = 1;
		child.Team_Manufacturing_Digital_Best_Guess__c = 1;
    	child.Team_Manufacturing_Digital_High__c = 1;
    	child.Team_Manufacturing_Digital_Low__c = 1;
		child.Team_Manufacturing_Mobile_Best_Guess__c = 1;
    	child.Team_Manufacturing_Mobile_High__c = 1;
    	child.Team_Manufacturing_Mobile_Low__c = 1;
		child.Team_Manufacturing_Audience_Best_Guess__c = 1;
    	child.Team_Manufacturing_Audience_High__c = 1;
    	child.Team_Manufacturing_Audience_Low__c = 1;
		child.Team_Retail_Base_Best_Guess__c = 1;
    	child.Team_Retail_Base_High__c = 1;
    	child.Team_Retail_Base_Low__c = 1;
		child.Team_Retail_Digital_Best_Guess__c = 1;
    	child.Team_Retail_Digital_High__c = 1;
    	child.Team_Retail_Digital_Low__c = 1;
		child.Team_Retail_Mobile_Best_Guess__c = 1;
    	child.Team_Retail_Mobile_High__c = 1;
    	child.Team_Retail_Mobile_Low__c = 1;
		child.Team_Retail_Audience_Best_Guess__c = 1;
    	child.Team_Retail_Audience_High__c = 1;
    	child.Team_Retail_Audience_Low__c = 1;
    	
    	update child;
    	
    	mbg = [Select m.Team_Retail_Digital_Low__c, m.Team_Retail_Digital_High__c, m.Team_Retail_Digital_Best_Guess__c, 
        m.Team_Retail_Base_Low__c, m.Team_Retail_Base_High__c, m.Team_Retail_Base_Best_Guess__c, m.Team_Quota__c, m.Team_Manufacturing_Digital_Low__c, 
        m.Team_Manufacturing_Digital_High__c, m.Team_Manufacturing_Digital_Best_Guess__c, m.Team_Manufacturing_Base_Low__c, m.Team_Manufacturing_Base_High__c, 
        m.Team_Manufacturing_Base_Best_Guess__c, m.Team_Booked_Proposal__c, m.Team_Booked_Actual__c, m.OwnerId, m.Name, m.Manager_Best_Guess__c, m.Id,
        m.Team_Previous_Year_Actual__c, m.Team_Booked_Full_Proposal__c,
        m.Team_M_A_Booked_Actual__c, m.Team_M_A_Booked_Full_Proposal__c, m.Team_M_A_Booked_Proposal__c,
        m.Team_M_B_Booked_Actual__c, m.Team_M_B_Booked_Full_Proposal__c, m.Team_M_B_Booked_Proposal__c,
        m.Team_M_D_Booked_Actual__c, m.Team_M_D_Booked_Full_Proposal__c, m.Team_M_D_Booked_Proposal__c,
        m.Team_M_M_Booked_Actual__c, m.Team_M_M_Booked_Full_Proposal__c, m.Team_M_M_Booked_Proposal__c,
        m.Team_R_A_Booked_Actual__c, m.Team_R_A_Booked_Full_Proposal__c, m.Team_R_A_Booked_Proposal__c,
        m.Team_R_B_Booked_Actual__c, m.Team_R_B_Booked_Full_Proposal__c, m.Team_R_B_Booked_Proposal__c,
        m.Team_R_D_Booked_Actual__c, m.Team_R_D_Booked_Full_Proposal__c, m.Team_R_D_Booked_Proposal__c,
        m.Team_R_M_Booked_Actual__c, m.Team_R_M_Booked_Full_Proposal__c, m.Team_R_M_Booked_Proposal__c,
        m.Team_Manufacturing_Audience_Best_Guess__c, m.Team_Manufacturing_Audience_High__c, m.Team_Manufacturing_Audience_Low__c,
        m.Team_Manufacturing_Mobile_Best_Guess__c, m.Team_Manufacturing_Mobile_High__c, m.Team_Manufacturing_Mobile_Low__c,
        m.Team_Retail_Audience_Best_Guess__c, m.Team_Retail_Audience_High__c, m.Team_Retail_Audience_Low__c,
        m.Team_Retail_Mobile_Best_Guess__c, m.Team_Retail_Mobile_High__c, m.Team_Retail_Mobile_Low__c
        From Manager_Best_Guess__c m WHERE M.id =: mbg.Id][0];
        
        system.assert(mbg.Team_Booked_Actual__c == 1);
        system.assert(mbg.Team_Booked_Proposal__c == 1);
        system.assert(mbg.Team_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_Previous_Year_Actual__c == 1);
        system.assert(mbg.Team_M_A_Booked_Actual__c == 1);
        system.assert(mbg.Team_M_A_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_M_A_Booked_Proposal__c == 1);                
        system.assert(mbg.Team_M_B_Booked_Actual__c == 1);
        system.assert(mbg.Team_M_B_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_M_B_Booked_Proposal__c == 1);
        system.assert(mbg.Team_M_D_Booked_Actual__c == 1);
        system.assert(mbg.Team_M_D_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_M_D_Booked_Proposal__c == 1);
        system.assert(mbg.Team_M_M_Booked_Actual__c == 1);                
        system.assert(mbg.Team_M_M_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_M_M_Booked_Proposal__c == 1);
        system.assert(mbg.Team_R_A_Booked_Actual__c == 1);
        system.assert(mbg.Team_R_A_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_R_A_Booked_Proposal__c == 1);
        system.assert(mbg.Team_R_B_Booked_Actual__c == 1);                
        system.assert(mbg.Team_R_B_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_R_B_Booked_Proposal__c == 1);
        system.assert(mbg.Team_R_D_Booked_Actual__c == 1);
        system.assert(mbg.Team_R_D_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_R_D_Booked_Proposal__c == 1);
        system.assert(mbg.Team_R_M_Booked_Actual__c == 1);
        system.assert(mbg.Team_R_M_Booked_Full_Proposal__c == 1);                
        system.assert(mbg.Team_R_M_Booked_Proposal__c == 1);
    	system.assert(mbg.Team_Manufacturing_Base_Best_Guess__c == 1);
        system.assert(mbg.Team_Manufacturing_Base_High__c == 1);
        system.assert(mbg.Team_Manufacturing_Base_Low__c == 1);
        system.assert(mbg.Team_Manufacturing_Digital_Best_Guess__c == 1);
        system.assert(mbg.Team_Manufacturing_Digital_High__c == 1);
        system.assert(mbg.Team_Manufacturing_Digital_Low__c == 1);
        system.assert(mbg.Team_Retail_Base_Best_Guess__c == 1);
        system.assert(mbg.Team_Retail_Base_High__c == 1);
        system.assert(mbg.Team_Retail_Base_Low__c == 1);
        system.assert(mbg.Team_Retail_Digital_Best_Guess__c == 1);
        system.assert(mbg.Team_Retail_Digital_High__c == 1);
        system.assert(mbg.Team_Retail_Digital_Low__c == 1);
        system.assert(mbg.Team_Manufacturing_Audience_Best_Guess__c == 1);
        system.assert(mbg.Team_Manufacturing_Audience_High__c == 1);
        system.assert(mbg.Team_Manufacturing_Audience_Low__c == 1);
        system.assert(mbg.Team_Manufacturing_Mobile_Best_Guess__c == 1);
        system.assert(mbg.Team_Manufacturing_Mobile_High__c == 1);
        system.assert(mbg.Team_Manufacturing_Mobile_Low__c == 1);
        system.assert(mbg.Team_Retail_Audience_Best_Guess__c == 1);
        system.assert(mbg.Team_Retail_Audience_High__c == 1);
        system.assert(mbg.Team_Retail_Audience_Low__c == 1);
        system.assert(mbg.Team_Retail_Mobile_Best_Guess__c == 1);
        system.assert(mbg.Team_Retail_Mobile_High__c == 1);
        system.assert(mbg.Team_Retail_Mobile_Low__c == 1);
        
        child.Team_Manufacturing_Base_Best_Guess__c = 3;
    	child.Team_Manufacturing_Base_High__c = 3;
    	child.Team_Manufacturing_Base_Low__c = 3;
		child.Team_Manufacturing_Digital_Best_Guess__c = 3;
    	child.Team_Manufacturing_Digital_High__c = 3;
    	child.Team_Manufacturing_Digital_Low__c = 3;
		child.Team_Manufacturing_Mobile_Best_Guess__c = 3;
    	child.Team_Manufacturing_Mobile_High__c = 3;
    	child.Team_Manufacturing_Mobile_Low__c = 3;
		child.Team_Manufacturing_Audience_Best_Guess__c = 3;
    	child.Team_Manufacturing_Audience_High__c = 3;
    	child.Team_Manufacturing_Audience_Low__c = 3;
		child.Team_Retail_Base_Best_Guess__c = 3;
    	child.Team_Retail_Base_High__c = 3;
    	child.Team_Retail_Base_Low__c = 3;
		child.Team_Retail_Digital_Best_Guess__c = 3;
    	child.Team_Retail_Digital_High__c = 3;
    	child.Team_Retail_Digital_Low__c = 3;
		child.Team_Retail_Mobile_Best_Guess__c = 3;
    	child.Team_Retail_Mobile_High__c = 3;
    	child.Team_Retail_Mobile_Low__c = 3;
		child.Team_Retail_Audience_Best_Guess__c = 3;
    	child.Team_Retail_Audience_High__c = 3;
    	child.Team_Retail_Audience_Low__c = 3;
    	update child;
    	
    	mbg = [Select m.Team_Retail_Digital_Low__c, m.Team_Retail_Digital_High__c, m.Team_Retail_Digital_Best_Guess__c, 
        m.Team_Retail_Base_Low__c, m.Team_Retail_Base_High__c, m.Team_Retail_Base_Best_Guess__c, m.Team_Quota__c, m.Team_Manufacturing_Digital_Low__c, 
        m.Team_Manufacturing_Digital_High__c, m.Team_Manufacturing_Digital_Best_Guess__c, m.Team_Manufacturing_Base_Low__c, m.Team_Manufacturing_Base_High__c, 
        m.Team_Manufacturing_Base_Best_Guess__c, m.Team_Booked_Proposal__c, m.Team_Booked_Actual__c, m.OwnerId, m.Name, m.Manager_Best_Guess__c, m.Id,
        m.Team_Previous_Year_Actual__c, m.Team_Booked_Full_Proposal__c,
        m.Team_M_A_Booked_Actual__c, m.Team_M_A_Booked_Full_Proposal__c, m.Team_M_A_Booked_Proposal__c,
        m.Team_M_B_Booked_Actual__c, m.Team_M_B_Booked_Full_Proposal__c, m.Team_M_B_Booked_Proposal__c,
        m.Team_M_D_Booked_Actual__c, m.Team_M_D_Booked_Full_Proposal__c, m.Team_M_D_Booked_Proposal__c,
        m.Team_M_M_Booked_Actual__c, m.Team_M_M_Booked_Full_Proposal__c, m.Team_M_M_Booked_Proposal__c,
        m.Team_R_A_Booked_Actual__c, m.Team_R_A_Booked_Full_Proposal__c, m.Team_R_A_Booked_Proposal__c,
        m.Team_R_B_Booked_Actual__c, m.Team_R_B_Booked_Full_Proposal__c, m.Team_R_B_Booked_Proposal__c,
        m.Team_R_D_Booked_Actual__c, m.Team_R_D_Booked_Full_Proposal__c, m.Team_R_D_Booked_Proposal__c,
        m.Team_R_M_Booked_Actual__c, m.Team_R_M_Booked_Full_Proposal__c, m.Team_R_M_Booked_Proposal__c,
        m.Team_Manufacturing_Audience_Best_Guess__c, m.Team_Manufacturing_Audience_High__c, m.Team_Manufacturing_Audience_Low__c,
        m.Team_Manufacturing_Mobile_Best_Guess__c, m.Team_Manufacturing_Mobile_High__c, m.Team_Manufacturing_Mobile_Low__c,
        m.Team_Retail_Audience_Best_Guess__c, m.Team_Retail_Audience_High__c, m.Team_Retail_Audience_Low__c,
        m.Team_Retail_Mobile_Best_Guess__c, m.Team_Retail_Mobile_High__c, m.Team_Retail_Mobile_Low__c
        From Manager_Best_Guess__c m WHERE M.id =: mbg.Id][0];
        
        system.assert(mbg.Team_Booked_Actual__c == 1);
        system.assert(mbg.Team_Booked_Proposal__c == 1);
        system.assert(mbg.Team_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_Previous_Year_Actual__c == 1);
        system.assert(mbg.Team_M_A_Booked_Actual__c == 1);
        system.assert(mbg.Team_M_A_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_M_A_Booked_Proposal__c == 1);                
        system.assert(mbg.Team_M_B_Booked_Actual__c == 1);
        system.assert(mbg.Team_M_B_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_M_B_Booked_Proposal__c == 1);
        system.assert(mbg.Team_M_D_Booked_Actual__c == 1);
        system.assert(mbg.Team_M_D_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_M_D_Booked_Proposal__c == 1);
        system.assert(mbg.Team_M_M_Booked_Actual__c == 1);                
        system.assert(mbg.Team_M_M_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_M_M_Booked_Proposal__c == 1);
        system.assert(mbg.Team_R_A_Booked_Actual__c == 1);
        system.assert(mbg.Team_R_A_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_R_A_Booked_Proposal__c == 1);
        system.assert(mbg.Team_R_B_Booked_Actual__c == 1);                
        system.assert(mbg.Team_R_B_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_R_B_Booked_Proposal__c == 1);
        system.assert(mbg.Team_R_D_Booked_Actual__c == 1);
        system.assert(mbg.Team_R_D_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_R_D_Booked_Proposal__c == 1);
        system.assert(mbg.Team_R_M_Booked_Actual__c == 1);
        system.assert(mbg.Team_R_M_Booked_Full_Proposal__c == 1);                
        system.assert(mbg.Team_R_M_Booked_Proposal__c == 1);
    	system.assert(mbg.Team_Manufacturing_Base_Best_Guess__c == 3);
        system.assert(mbg.Team_Manufacturing_Base_High__c == 3);
        system.assert(mbg.Team_Manufacturing_Base_Low__c == 3);
        system.assert(mbg.Team_Manufacturing_Digital_Best_Guess__c == 3);
        system.assert(mbg.Team_Manufacturing_Digital_High__c == 3);
        system.assert(mbg.Team_Manufacturing_Digital_Low__c == 3);
        system.assert(mbg.Team_Retail_Base_Best_Guess__c == 3);
        system.assert(mbg.Team_Retail_Base_High__c == 3);
        system.assert(mbg.Team_Retail_Base_Low__c == 3);
        system.assert(mbg.Team_Retail_Digital_Best_Guess__c == 3);
        system.assert(mbg.Team_Retail_Digital_High__c == 3);
        system.assert(mbg.Team_Retail_Digital_Low__c == 3);
        system.assert(mbg.Team_Manufacturing_Audience_Best_Guess__c == 3);
        system.assert(mbg.Team_Manufacturing_Audience_High__c == 3);
        system.assert(mbg.Team_Manufacturing_Audience_Low__c == 3);
        system.assert(mbg.Team_Manufacturing_Mobile_Best_Guess__c == 3);
        system.assert(mbg.Team_Manufacturing_Mobile_High__c == 3);
        system.assert(mbg.Team_Manufacturing_Mobile_Low__c == 3);
        system.assert(mbg.Team_Retail_Audience_Best_Guess__c == 3);
        system.assert(mbg.Team_Retail_Audience_High__c == 3);
        system.assert(mbg.Team_Retail_Audience_Low__c == 3);
        system.assert(mbg.Team_Retail_Mobile_Best_Guess__c == 3);
        system.assert(mbg.Team_Retail_Mobile_High__c == 3);
        system.assert(mbg.Team_Retail_Mobile_Low__c == 3);
        
        child.Override_Team_Manu_Base_Best_Guess__c = 2;
    	child.Override_Team_Manu_Base_High__c = 2;
    	child.Override_Team_Manu_Base_Low__c = 2;
		child.Override_Team_Manu_Digital_Best_Guess__c = 2;
    	child.Override_Team_Manu_Digital_High__c = 2;
    	child.Override_Team_Manu_Digital_Low__c = 2;
		child.Override_Team_Manu_Mobile_Best_Guess__c = 2;
    	child.Override_Team_Manu_Mobile_High__c = 2;
    	child.Override_Team_Manu_Mobile_Low__c = 2;
		child.Override_Team_Manu_Audience_Best_Guess__c = 2;
    	child.Override_Team_Manu_Audience_High__c = 2;
    	child.Override_Team_Manu_Audience_Low__c = 2;
		child.Override_Team_Retail_Base_Best_Guess__c = 2;
    	child.Override_Team_Retail_Base_High__c = 2;
    	child.Override_Team_Retail_Base_Low__c = 2;
		child.Override_Team_Retail_Digital_Best_Guess__c = 2;
    	child.Override_Team_Retail_Digital_High__c = 2;
    	child.Override_Team_Retail_Digital_Low__c = 2;
		child.Override_Team_Retail_Mobile_Best_Guess__c = 2;
    	child.Override_Team_Retail_Mobile_High__c = 2;
    	child.Override_Team_Retail_Mobile_Low__c = 2;
		child.Override_Team_Retail_Audience_Best_Guess__c = 2;
    	child.Override_Team_Retail_Audience_High__c = 2;
    	child.Override_Team_Retail_Audience_Low__c = 2;
    	update child;
        
        mbg = [Select m.Team_Retail_Digital_Low__c, m.Team_Retail_Digital_High__c, m.Team_Retail_Digital_Best_Guess__c, 
        m.Team_Retail_Base_Low__c, m.Team_Retail_Base_High__c, m.Team_Retail_Base_Best_Guess__c, m.Team_Quota__c, m.Team_Manufacturing_Digital_Low__c, 
        m.Team_Manufacturing_Digital_High__c, m.Team_Manufacturing_Digital_Best_Guess__c, m.Team_Manufacturing_Base_Low__c, m.Team_Manufacturing_Base_High__c, 
        m.Team_Manufacturing_Base_Best_Guess__c, m.Team_Booked_Proposal__c, m.Team_Booked_Actual__c, m.OwnerId, m.Name, m.Manager_Best_Guess__c, m.Id,
        m.Team_Previous_Year_Actual__c, m.Team_Booked_Full_Proposal__c,
        m.Team_M_A_Booked_Actual__c, m.Team_M_A_Booked_Full_Proposal__c, m.Team_M_A_Booked_Proposal__c,
        m.Team_M_B_Booked_Actual__c, m.Team_M_B_Booked_Full_Proposal__c, m.Team_M_B_Booked_Proposal__c,
        m.Team_M_D_Booked_Actual__c, m.Team_M_D_Booked_Full_Proposal__c, m.Team_M_D_Booked_Proposal__c,
        m.Team_M_M_Booked_Actual__c, m.Team_M_M_Booked_Full_Proposal__c, m.Team_M_M_Booked_Proposal__c,
        m.Team_R_A_Booked_Actual__c, m.Team_R_A_Booked_Full_Proposal__c, m.Team_R_A_Booked_Proposal__c,
        m.Team_R_B_Booked_Actual__c, m.Team_R_B_Booked_Full_Proposal__c, m.Team_R_B_Booked_Proposal__c,
        m.Team_R_D_Booked_Actual__c, m.Team_R_D_Booked_Full_Proposal__c, m.Team_R_D_Booked_Proposal__c,
        m.Team_R_M_Booked_Actual__c, m.Team_R_M_Booked_Full_Proposal__c, m.Team_R_M_Booked_Proposal__c,
        m.Team_Manufacturing_Audience_Best_Guess__c, m.Team_Manufacturing_Audience_High__c, m.Team_Manufacturing_Audience_Low__c,
        m.Team_Manufacturing_Mobile_Best_Guess__c, m.Team_Manufacturing_Mobile_High__c, m.Team_Manufacturing_Mobile_Low__c,
        m.Team_Retail_Audience_Best_Guess__c, m.Team_Retail_Audience_High__c, m.Team_Retail_Audience_Low__c,
        m.Team_Retail_Mobile_Best_Guess__c, m.Team_Retail_Mobile_High__c, m.Team_Retail_Mobile_Low__c
        From Manager_Best_Guess__c m WHERE M.id =: mbg.Id][0];
        
        system.assert(mbg.Team_Booked_Actual__c == 1);
        system.assert(mbg.Team_Booked_Proposal__c == 1);
        system.assert(mbg.Team_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_Previous_Year_Actual__c == 1);
        system.assert(mbg.Team_M_A_Booked_Actual__c == 1);
        system.assert(mbg.Team_M_A_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_M_A_Booked_Proposal__c == 1);                
        system.assert(mbg.Team_M_B_Booked_Actual__c == 1);
        system.assert(mbg.Team_M_B_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_M_B_Booked_Proposal__c == 1);
        system.assert(mbg.Team_M_D_Booked_Actual__c == 1);
        system.assert(mbg.Team_M_D_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_M_D_Booked_Proposal__c == 1);
        system.assert(mbg.Team_M_M_Booked_Actual__c == 1);                
        system.assert(mbg.Team_M_M_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_M_M_Booked_Proposal__c == 1);
        system.assert(mbg.Team_R_A_Booked_Actual__c == 1);
        system.assert(mbg.Team_R_A_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_R_A_Booked_Proposal__c == 1);
        system.assert(mbg.Team_R_B_Booked_Actual__c == 1);                
        system.assert(mbg.Team_R_B_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_R_B_Booked_Proposal__c == 1);
        system.assert(mbg.Team_R_D_Booked_Actual__c == 1);
        system.assert(mbg.Team_R_D_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_R_D_Booked_Proposal__c == 1);
        system.assert(mbg.Team_R_M_Booked_Actual__c == 1);
        system.assert(mbg.Team_R_M_Booked_Full_Proposal__c == 1);                
        system.assert(mbg.Team_R_M_Booked_Proposal__c == 1);
    	system.assert(mbg.Team_Manufacturing_Base_Best_Guess__c == 2);
        system.assert(mbg.Team_Manufacturing_Base_High__c == 2);
        system.assert(mbg.Team_Manufacturing_Base_Low__c == 2);
        system.assert(mbg.Team_Manufacturing_Digital_Best_Guess__c == 2);
        system.assert(mbg.Team_Manufacturing_Digital_High__c == 2);
        system.assert(mbg.Team_Manufacturing_Digital_Low__c == 2);
        system.assert(mbg.Team_Retail_Base_Best_Guess__c == 2);
        system.assert(mbg.Team_Retail_Base_High__c == 2);
        system.assert(mbg.Team_Retail_Base_Low__c == 2);
        system.assert(mbg.Team_Retail_Digital_Best_Guess__c == 2);
        system.assert(mbg.Team_Retail_Digital_High__c == 2);
        system.assert(mbg.Team_Retail_Digital_Low__c == 2);
        system.assert(mbg.Team_Manufacturing_Audience_Best_Guess__c == 2);
        system.assert(mbg.Team_Manufacturing_Audience_High__c == 2);
        system.assert(mbg.Team_Manufacturing_Audience_Low__c == 2);
        system.assert(mbg.Team_Manufacturing_Mobile_Best_Guess__c == 2);
        system.assert(mbg.Team_Manufacturing_Mobile_High__c == 2);
        system.assert(mbg.Team_Manufacturing_Mobile_Low__c == 2);
        system.assert(mbg.Team_Retail_Audience_Best_Guess__c == 2);
        system.assert(mbg.Team_Retail_Audience_High__c == 2);
        system.assert(mbg.Team_Retail_Audience_Low__c == 2);
        system.assert(mbg.Team_Retail_Mobile_Best_Guess__c == 2);
        system.assert(mbg.Team_Retail_Mobile_High__c == 2);
        system.assert(mbg.Team_Retail_Mobile_Low__c == 2);
        
        child.Override_Team_Manu_Base_Best_Guess__c = 4;
    	child.Override_Team_Manu_Base_High__c = 4;
    	child.Override_Team_Manu_Base_Low__c = 4;
		child.Override_Team_Manu_Digital_Best_Guess__c = 4;
    	child.Override_Team_Manu_Digital_High__c = 4;
    	child.Override_Team_Manu_Digital_Low__c = 4;
		child.Override_Team_Manu_Mobile_Best_Guess__c = 4;
    	child.Override_Team_Manu_Mobile_High__c = 4;
    	child.Override_Team_Manu_Mobile_Low__c = 4;
		child.Override_Team_Manu_Audience_Best_Guess__c = 4;
    	child.Override_Team_Manu_Audience_High__c = 4;
    	child.Override_Team_Manu_Audience_Low__c = 4;
		child.Override_Team_Retail_Base_Best_Guess__c = 4;
    	child.Override_Team_Retail_Base_High__c = 4;
    	child.Override_Team_Retail_Base_Low__c = 4;
		child.Override_Team_Retail_Digital_Best_Guess__c = 4;
    	child.Override_Team_Retail_Digital_High__c = 4;
    	child.Override_Team_Retail_Digital_Low__c = 4;
		child.Override_Team_Retail_Mobile_Best_Guess__c = 4;
    	child.Override_Team_Retail_Mobile_High__c = 4;
    	child.Override_Team_Retail_Mobile_Low__c = 4;
		child.Override_Team_Retail_Audience_Best_Guess__c = 4;
    	child.Override_Team_Retail_Audience_High__c = 4;
    	child.Override_Team_Retail_Audience_Low__c = 4;
    	update child;
        
        mbg = [Select m.Team_Retail_Digital_Low__c, m.Team_Retail_Digital_High__c, m.Team_Retail_Digital_Best_Guess__c, 
        m.Team_Retail_Base_Low__c, m.Team_Retail_Base_High__c, m.Team_Retail_Base_Best_Guess__c, m.Team_Quota__c, m.Team_Manufacturing_Digital_Low__c, 
        m.Team_Manufacturing_Digital_High__c, m.Team_Manufacturing_Digital_Best_Guess__c, m.Team_Manufacturing_Base_Low__c, m.Team_Manufacturing_Base_High__c, 
        m.Team_Manufacturing_Base_Best_Guess__c, m.Team_Booked_Proposal__c, m.Team_Booked_Actual__c, m.OwnerId, m.Name, m.Manager_Best_Guess__c, m.Id,
        m.Team_Previous_Year_Actual__c, m.Team_Booked_Full_Proposal__c,
        m.Team_M_A_Booked_Actual__c, m.Team_M_A_Booked_Full_Proposal__c, m.Team_M_A_Booked_Proposal__c,
        m.Team_M_B_Booked_Actual__c, m.Team_M_B_Booked_Full_Proposal__c, m.Team_M_B_Booked_Proposal__c,
        m.Team_M_D_Booked_Actual__c, m.Team_M_D_Booked_Full_Proposal__c, m.Team_M_D_Booked_Proposal__c,
        m.Team_M_M_Booked_Actual__c, m.Team_M_M_Booked_Full_Proposal__c, m.Team_M_M_Booked_Proposal__c,
        m.Team_R_A_Booked_Actual__c, m.Team_R_A_Booked_Full_Proposal__c, m.Team_R_A_Booked_Proposal__c,
        m.Team_R_B_Booked_Actual__c, m.Team_R_B_Booked_Full_Proposal__c, m.Team_R_B_Booked_Proposal__c,
        m.Team_R_D_Booked_Actual__c, m.Team_R_D_Booked_Full_Proposal__c, m.Team_R_D_Booked_Proposal__c,
        m.Team_R_M_Booked_Actual__c, m.Team_R_M_Booked_Full_Proposal__c, m.Team_R_M_Booked_Proposal__c,
        m.Team_Manufacturing_Audience_Best_Guess__c, m.Team_Manufacturing_Audience_High__c, m.Team_Manufacturing_Audience_Low__c,
        m.Team_Manufacturing_Mobile_Best_Guess__c, m.Team_Manufacturing_Mobile_High__c, m.Team_Manufacturing_Mobile_Low__c,
        m.Team_Retail_Audience_Best_Guess__c, m.Team_Retail_Audience_High__c, m.Team_Retail_Audience_Low__c,
        m.Team_Retail_Mobile_Best_Guess__c, m.Team_Retail_Mobile_High__c, m.Team_Retail_Mobile_Low__c
        From Manager_Best_Guess__c m WHERE M.id =: mbg.Id][0];
        
        system.assert(mbg.Team_Booked_Actual__c == 1);
        system.assert(mbg.Team_Booked_Proposal__c == 1);
        system.assert(mbg.Team_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_Previous_Year_Actual__c == 1);
        system.assert(mbg.Team_M_A_Booked_Actual__c == 1);
        system.assert(mbg.Team_M_A_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_M_A_Booked_Proposal__c == 1);                
        system.assert(mbg.Team_M_B_Booked_Actual__c == 1);
        system.assert(mbg.Team_M_B_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_M_B_Booked_Proposal__c == 1);
        system.assert(mbg.Team_M_D_Booked_Actual__c == 1);
        system.assert(mbg.Team_M_D_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_M_D_Booked_Proposal__c == 1);
        system.assert(mbg.Team_M_M_Booked_Actual__c == 1);                
        system.assert(mbg.Team_M_M_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_M_M_Booked_Proposal__c == 1);
        system.assert(mbg.Team_R_A_Booked_Actual__c == 1);
        system.assert(mbg.Team_R_A_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_R_A_Booked_Proposal__c == 1);
        system.assert(mbg.Team_R_B_Booked_Actual__c == 1);                
        system.assert(mbg.Team_R_B_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_R_B_Booked_Proposal__c == 1);
        system.assert(mbg.Team_R_D_Booked_Actual__c == 1);
        system.assert(mbg.Team_R_D_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_R_D_Booked_Proposal__c == 1);
        system.assert(mbg.Team_R_M_Booked_Actual__c == 1);
        system.assert(mbg.Team_R_M_Booked_Full_Proposal__c == 1);                
        system.assert(mbg.Team_R_M_Booked_Proposal__c == 1);
    	system.assert(mbg.Team_Manufacturing_Base_Best_Guess__c == 4);
        system.assert(mbg.Team_Manufacturing_Base_High__c == 4);
        system.assert(mbg.Team_Manufacturing_Base_Low__c == 4);
        system.assert(mbg.Team_Manufacturing_Digital_Best_Guess__c == 4);
        system.assert(mbg.Team_Manufacturing_Digital_High__c == 4);
        system.assert(mbg.Team_Manufacturing_Digital_Low__c == 4);
        system.assert(mbg.Team_Retail_Base_Best_Guess__c == 4);
        system.assert(mbg.Team_Retail_Base_High__c == 4);
        system.assert(mbg.Team_Retail_Base_Low__c == 4);
        system.assert(mbg.Team_Retail_Digital_Best_Guess__c == 4);
        system.assert(mbg.Team_Retail_Digital_High__c == 4);
        system.assert(mbg.Team_Retail_Digital_Low__c == 4);
        system.assert(mbg.Team_Manufacturing_Audience_Best_Guess__c == 4);
        system.assert(mbg.Team_Manufacturing_Audience_High__c == 4);
        system.assert(mbg.Team_Manufacturing_Audience_Low__c == 4);
        system.assert(mbg.Team_Manufacturing_Mobile_Best_Guess__c == 4);
        system.assert(mbg.Team_Manufacturing_Mobile_High__c == 4);
        system.assert(mbg.Team_Manufacturing_Mobile_Low__c == 4);
        system.assert(mbg.Team_Retail_Audience_Best_Guess__c == 4);
        system.assert(mbg.Team_Retail_Audience_High__c == 4);
        system.assert(mbg.Team_Retail_Audience_Low__c == 4);
        system.assert(mbg.Team_Retail_Mobile_Best_Guess__c == 4);
        system.assert(mbg.Team_Retail_Mobile_High__c == 4);
        system.assert(mbg.Team_Retail_Mobile_Low__c == 4);
        
        child.Team_Manufacturing_Base_Best_Guess__c = 5;
    	child.Team_Manufacturing_Base_High__c = 5;
    	child.Team_Manufacturing_Base_Low__c = 5;
		child.Team_Manufacturing_Digital_Best_Guess__c = 5;
    	child.Team_Manufacturing_Digital_High__c = 5;
    	child.Team_Manufacturing_Digital_Low__c = 5;
		child.Team_Manufacturing_Mobile_Best_Guess__c = 5;
    	child.Team_Manufacturing_Mobile_High__c = 5;
    	child.Team_Manufacturing_Mobile_Low__c = 5;
		child.Team_Manufacturing_Audience_Best_Guess__c = 5;
    	child.Team_Manufacturing_Audience_High__c = 5;
    	child.Team_Manufacturing_Audience_Low__c = 5;
		child.Team_Retail_Base_Best_Guess__c = 5;
    	child.Team_Retail_Base_High__c = 5;
    	child.Team_Retail_Base_Low__c = 5;
		child.Team_Retail_Digital_Best_Guess__c = 5;
    	child.Team_Retail_Digital_High__c = 5;
    	child.Team_Retail_Digital_Low__c = 5;
		child.Team_Retail_Mobile_Best_Guess__c = 5;
    	child.Team_Retail_Mobile_High__c = 5;
    	child.Team_Retail_Mobile_Low__c = 5;
		child.Team_Retail_Audience_Best_Guess__c = 5;
    	child.Team_Retail_Audience_High__c = 5;
    	child.Team_Retail_Audience_Low__c = 5;
    	update child;
    	
    	mbg = [Select m.Team_Retail_Digital_Low__c, m.Team_Retail_Digital_High__c, m.Team_Retail_Digital_Best_Guess__c, 
        m.Team_Retail_Base_Low__c, m.Team_Retail_Base_High__c, m.Team_Retail_Base_Best_Guess__c, m.Team_Quota__c, m.Team_Manufacturing_Digital_Low__c, 
        m.Team_Manufacturing_Digital_High__c, m.Team_Manufacturing_Digital_Best_Guess__c, m.Team_Manufacturing_Base_Low__c, m.Team_Manufacturing_Base_High__c, 
        m.Team_Manufacturing_Base_Best_Guess__c, m.Team_Booked_Proposal__c, m.Team_Booked_Actual__c, m.OwnerId, m.Name, m.Manager_Best_Guess__c, m.Id,
        m.Team_Previous_Year_Actual__c, m.Team_Booked_Full_Proposal__c,
        m.Team_M_A_Booked_Actual__c, m.Team_M_A_Booked_Full_Proposal__c, m.Team_M_A_Booked_Proposal__c,
        m.Team_M_B_Booked_Actual__c, m.Team_M_B_Booked_Full_Proposal__c, m.Team_M_B_Booked_Proposal__c,
        m.Team_M_D_Booked_Actual__c, m.Team_M_D_Booked_Full_Proposal__c, m.Team_M_D_Booked_Proposal__c,
        m.Team_M_M_Booked_Actual__c, m.Team_M_M_Booked_Full_Proposal__c, m.Team_M_M_Booked_Proposal__c,
        m.Team_R_A_Booked_Actual__c, m.Team_R_A_Booked_Full_Proposal__c, m.Team_R_A_Booked_Proposal__c,
        m.Team_R_B_Booked_Actual__c, m.Team_R_B_Booked_Full_Proposal__c, m.Team_R_B_Booked_Proposal__c,
        m.Team_R_D_Booked_Actual__c, m.Team_R_D_Booked_Full_Proposal__c, m.Team_R_D_Booked_Proposal__c,
        m.Team_R_M_Booked_Actual__c, m.Team_R_M_Booked_Full_Proposal__c, m.Team_R_M_Booked_Proposal__c,
        m.Team_Manufacturing_Audience_Best_Guess__c, m.Team_Manufacturing_Audience_High__c, m.Team_Manufacturing_Audience_Low__c,
        m.Team_Manufacturing_Mobile_Best_Guess__c, m.Team_Manufacturing_Mobile_High__c, m.Team_Manufacturing_Mobile_Low__c,
        m.Team_Retail_Audience_Best_Guess__c, m.Team_Retail_Audience_High__c, m.Team_Retail_Audience_Low__c,
        m.Team_Retail_Mobile_Best_Guess__c, m.Team_Retail_Mobile_High__c, m.Team_Retail_Mobile_Low__c
        From Manager_Best_Guess__c m WHERE M.id =: mbg.Id][0];
        
        system.assert(mbg.Team_Booked_Actual__c == 1);
        system.assert(mbg.Team_Booked_Proposal__c == 1);
        system.assert(mbg.Team_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_Previous_Year_Actual__c == 1);
        system.assert(mbg.Team_M_A_Booked_Actual__c == 1);
        system.assert(mbg.Team_M_A_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_M_A_Booked_Proposal__c == 1);                
        system.assert(mbg.Team_M_B_Booked_Actual__c == 1);
        system.assert(mbg.Team_M_B_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_M_B_Booked_Proposal__c == 1);
        system.assert(mbg.Team_M_D_Booked_Actual__c == 1);
        system.assert(mbg.Team_M_D_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_M_D_Booked_Proposal__c == 1);
        system.assert(mbg.Team_M_M_Booked_Actual__c == 1);                
        system.assert(mbg.Team_M_M_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_M_M_Booked_Proposal__c == 1);
        system.assert(mbg.Team_R_A_Booked_Actual__c == 1);
        system.assert(mbg.Team_R_A_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_R_A_Booked_Proposal__c == 1);
        system.assert(mbg.Team_R_B_Booked_Actual__c == 1);                
        system.assert(mbg.Team_R_B_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_R_B_Booked_Proposal__c == 1);
        system.assert(mbg.Team_R_D_Booked_Actual__c == 1);
        system.assert(mbg.Team_R_D_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_R_D_Booked_Proposal__c == 1);
        system.assert(mbg.Team_R_M_Booked_Actual__c == 1);
        system.assert(mbg.Team_R_M_Booked_Full_Proposal__c == 1);                
        system.assert(mbg.Team_R_M_Booked_Proposal__c == 1);
    	system.assert(mbg.Team_Manufacturing_Base_Best_Guess__c == 4);
        system.assert(mbg.Team_Manufacturing_Base_High__c == 4);
        system.assert(mbg.Team_Manufacturing_Base_Low__c == 4);
        system.assert(mbg.Team_Manufacturing_Digital_Best_Guess__c == 4);
        system.assert(mbg.Team_Manufacturing_Digital_High__c == 4);
        system.assert(mbg.Team_Manufacturing_Digital_Low__c == 4);
        system.assert(mbg.Team_Retail_Base_Best_Guess__c == 4);
        system.assert(mbg.Team_Retail_Base_High__c == 4);
        system.assert(mbg.Team_Retail_Base_Low__c == 4);
        system.assert(mbg.Team_Retail_Digital_Best_Guess__c == 4);
        system.assert(mbg.Team_Retail_Digital_High__c == 4);
        system.assert(mbg.Team_Retail_Digital_Low__c == 4);
        system.assert(mbg.Team_Manufacturing_Audience_Best_Guess__c == 4);
        system.assert(mbg.Team_Manufacturing_Audience_High__c == 4);
        system.assert(mbg.Team_Manufacturing_Audience_Low__c == 4);
        system.assert(mbg.Team_Manufacturing_Mobile_Best_Guess__c == 4);
        system.assert(mbg.Team_Manufacturing_Mobile_High__c == 4);
        system.assert(mbg.Team_Manufacturing_Mobile_Low__c == 4);
        system.assert(mbg.Team_Retail_Audience_Best_Guess__c == 4);
        system.assert(mbg.Team_Retail_Audience_High__c == 4);
        system.assert(mbg.Team_Retail_Audience_Low__c == 4);
        system.assert(mbg.Team_Retail_Mobile_Best_Guess__c == 4);
        system.assert(mbg.Team_Retail_Mobile_High__c == 4);
        system.assert(mbg.Team_Retail_Mobile_Low__c == 4);
        
        child.Override_Team_Manu_Base_Best_Guess__c = 0;
    	child.Override_Team_Manu_Base_High__c = 0;
    	child.Override_Team_Manu_Base_Low__c = 0;
		child.Override_Team_Manu_Digital_Best_Guess__c = 0;
    	child.Override_Team_Manu_Digital_High__c = 0;
    	child.Override_Team_Manu_Digital_Low__c = 0;
		child.Override_Team_Manu_Mobile_Best_Guess__c = 0;
    	child.Override_Team_Manu_Mobile_High__c = 0;
    	child.Override_Team_Manu_Mobile_Low__c = 0;
		child.Override_Team_Manu_Audience_Best_Guess__c = 0;
    	child.Override_Team_Manu_Audience_High__c = 0;
    	child.Override_Team_Manu_Audience_Low__c = 0;
		child.Override_Team_Retail_Base_Best_Guess__c = 0;
    	child.Override_Team_Retail_Base_High__c = 0;
    	child.Override_Team_Retail_Base_Low__c = 0;
		child.Override_Team_Retail_Digital_Best_Guess__c = 0;
    	child.Override_Team_Retail_Digital_High__c = 0;
    	child.Override_Team_Retail_Digital_Low__c = 0;
		child.Override_Team_Retail_Mobile_Best_Guess__c = 0;
    	child.Override_Team_Retail_Mobile_High__c = 0;
    	child.Override_Team_Retail_Mobile_Low__c = 0;
		child.Override_Team_Retail_Audience_Best_Guess__c = 0;
    	child.Override_Team_Retail_Audience_High__c = 0;
    	child.Override_Team_Retail_Audience_Low__c = 0;
    	update child;
    	
    	mbg = [Select m.Team_Retail_Digital_Low__c, m.Team_Retail_Digital_High__c, m.Team_Retail_Digital_Best_Guess__c, 
        m.Team_Retail_Base_Low__c, m.Team_Retail_Base_High__c, m.Team_Retail_Base_Best_Guess__c, m.Team_Quota__c, m.Team_Manufacturing_Digital_Low__c, 
        m.Team_Manufacturing_Digital_High__c, m.Team_Manufacturing_Digital_Best_Guess__c, m.Team_Manufacturing_Base_Low__c, m.Team_Manufacturing_Base_High__c, 
        m.Team_Manufacturing_Base_Best_Guess__c, m.Team_Booked_Proposal__c, m.Team_Booked_Actual__c, m.OwnerId, m.Name, m.Manager_Best_Guess__c, m.Id,
        m.Team_Previous_Year_Actual__c, m.Team_Booked_Full_Proposal__c,
        m.Team_M_A_Booked_Actual__c, m.Team_M_A_Booked_Full_Proposal__c, m.Team_M_A_Booked_Proposal__c,
        m.Team_M_B_Booked_Actual__c, m.Team_M_B_Booked_Full_Proposal__c, m.Team_M_B_Booked_Proposal__c,
        m.Team_M_D_Booked_Actual__c, m.Team_M_D_Booked_Full_Proposal__c, m.Team_M_D_Booked_Proposal__c,
        m.Team_M_M_Booked_Actual__c, m.Team_M_M_Booked_Full_Proposal__c, m.Team_M_M_Booked_Proposal__c,
        m.Team_R_A_Booked_Actual__c, m.Team_R_A_Booked_Full_Proposal__c, m.Team_R_A_Booked_Proposal__c,
        m.Team_R_B_Booked_Actual__c, m.Team_R_B_Booked_Full_Proposal__c, m.Team_R_B_Booked_Proposal__c,
        m.Team_R_D_Booked_Actual__c, m.Team_R_D_Booked_Full_Proposal__c, m.Team_R_D_Booked_Proposal__c,
        m.Team_R_M_Booked_Actual__c, m.Team_R_M_Booked_Full_Proposal__c, m.Team_R_M_Booked_Proposal__c,
        m.Team_Manufacturing_Audience_Best_Guess__c, m.Team_Manufacturing_Audience_High__c, m.Team_Manufacturing_Audience_Low__c,
        m.Team_Manufacturing_Mobile_Best_Guess__c, m.Team_Manufacturing_Mobile_High__c, m.Team_Manufacturing_Mobile_Low__c,
        m.Team_Retail_Audience_Best_Guess__c, m.Team_Retail_Audience_High__c, m.Team_Retail_Audience_Low__c,
        m.Team_Retail_Mobile_Best_Guess__c, m.Team_Retail_Mobile_High__c, m.Team_Retail_Mobile_Low__c
        From Manager_Best_Guess__c m WHERE M.id =: mbg.Id][0];
        
        system.assert(mbg.Team_Booked_Actual__c == 1);
        system.assert(mbg.Team_Booked_Proposal__c == 1);
        system.assert(mbg.Team_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_Previous_Year_Actual__c == 1);
        system.assert(mbg.Team_M_A_Booked_Actual__c == 1);
        system.assert(mbg.Team_M_A_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_M_A_Booked_Proposal__c == 1);                
        system.assert(mbg.Team_M_B_Booked_Actual__c == 1);
        system.assert(mbg.Team_M_B_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_M_B_Booked_Proposal__c == 1);
        system.assert(mbg.Team_M_D_Booked_Actual__c == 1);
        system.assert(mbg.Team_M_D_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_M_D_Booked_Proposal__c == 1);
        system.assert(mbg.Team_M_M_Booked_Actual__c == 1);                
        system.assert(mbg.Team_M_M_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_M_M_Booked_Proposal__c == 1);
        system.assert(mbg.Team_R_A_Booked_Actual__c == 1);
        system.assert(mbg.Team_R_A_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_R_A_Booked_Proposal__c == 1);
        system.assert(mbg.Team_R_B_Booked_Actual__c == 1);                
        system.assert(mbg.Team_R_B_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_R_B_Booked_Proposal__c == 1);
        system.assert(mbg.Team_R_D_Booked_Actual__c == 1);
        system.assert(mbg.Team_R_D_Booked_Full_Proposal__c == 1);
        system.assert(mbg.Team_R_D_Booked_Proposal__c == 1);
        system.assert(mbg.Team_R_M_Booked_Actual__c == 1);
        system.assert(mbg.Team_R_M_Booked_Full_Proposal__c == 1);                
        system.assert(mbg.Team_R_M_Booked_Proposal__c == 1);
    	system.assert(mbg.Team_Manufacturing_Base_Best_Guess__c == 5);
        system.assert(mbg.Team_Manufacturing_Base_High__c == 5);
        system.assert(mbg.Team_Manufacturing_Base_Low__c == 5);
        system.assert(mbg.Team_Manufacturing_Digital_Best_Guess__c == 5);
        system.assert(mbg.Team_Manufacturing_Digital_High__c == 5);
        system.assert(mbg.Team_Manufacturing_Digital_Low__c == 5);
        system.assert(mbg.Team_Retail_Base_Best_Guess__c == 5);
        system.assert(mbg.Team_Retail_Base_High__c == 5);
        system.assert(mbg.Team_Retail_Base_Low__c == 5);
        system.assert(mbg.Team_Retail_Digital_Best_Guess__c == 5);
        system.assert(mbg.Team_Retail_Digital_High__c == 5);
        system.assert(mbg.Team_Retail_Digital_Low__c == 5);
        system.assert(mbg.Team_Manufacturing_Audience_Best_Guess__c == 5);
        system.assert(mbg.Team_Manufacturing_Audience_High__c == 5);
        system.assert(mbg.Team_Manufacturing_Audience_Low__c == 5);
        system.assert(mbg.Team_Manufacturing_Mobile_Best_Guess__c == 5);
        system.assert(mbg.Team_Manufacturing_Mobile_High__c == 5);
        system.assert(mbg.Team_Manufacturing_Mobile_Low__c == 5);
        system.assert(mbg.Team_Retail_Audience_Best_Guess__c == 5);
        system.assert(mbg.Team_Retail_Audience_High__c == 5);
        system.assert(mbg.Team_Retail_Audience_Low__c == 5);
        system.assert(mbg.Team_Retail_Mobile_Best_Guess__c == 5);
        system.assert(mbg.Team_Retail_Mobile_High__c == 5);
        system.assert(mbg.Team_Retail_Mobile_Low__c == 5);
    }
    
    static testMethod void testBGRow(){
    	Test.startTest();
    	bestGuessRow u = new bestGuessRow();
    	Test.stopTest();
    }
}