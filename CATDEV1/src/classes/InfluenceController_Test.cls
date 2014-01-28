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
private class InfluenceController_Test {

     public static testmethod void runICTest() {
        influencecontroller ic = new influencecontroller();
        ic.isTest = true;
        ic.getSnapshots();
        ic.getDepartments();
        ic.calcDepartments();
        ic.changeDept();
        
        ic.sendInfluence();     
        
        // New Inf parent
        Influence_Parent__c ip = new Influence_Parent__c( active__c = true,  maximum_concurrent_batches__c = 5, track_influence_reports__c = true, start_time__c = datetime.now().addMonths(-12), end_time__c = datetime.now() );
        insert ip;
        
        ic = new influencecontroller();
        ic.ipID = ip.id;
        ic.calcDepartments();
        
        if( ic.getDepartments().size() > 1 ) {
            ic.dept = ic.getDepartments().get(1).getLabel();
            ic.changeDept();
        }
        
        system.assertNotEquals( '', ic.updated );
        
        ic.sendInfluence();
        
        Influence_Tracker__c it = [select id from Influence_Tracker__c where success__c = false and influence_snapshot__c = :ip.id and user__c = :userinfo.getuserid() ];
        
        system.assertNotEquals( null, it.id );
        
        // New inf
        Influence__c inf = new Influence__c( influence_parent__c = ip.id, user__c = userinfo.getuserid(), pc_rank__c = 1, cc_rank__c = 1,
            pr_rank__c = 1, cr_rank__c = 1, f_rank__c = 1, ranking__c = 1, aip_rank__c = 1, acd_rank__c = 1, likes_received_rank__c = 1 );
        insert inf;
        
        ic = new influencecontroller();
        
        ic.sendInfluence();
        
        it = [select id from Influence_Tracker__c where success__c = true and influence_snapshot__c = :ip.id and user__c = :userinfo.getuserid() ];
        
        system.assertNotEquals( null, it.id );
    }
}