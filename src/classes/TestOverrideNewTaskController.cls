/*
@Name            : TestOverrideNewTaskController
@Author          : customersuccess@cloud62.com
@Date            : Februrary 16, 2013
@Description     : Code coverage for OverrideNewTaskController
@Revision History   : 
*/
@isTest
public class TestOverrideNewTaskController{
    /*
    @Name   :getFields
    @Description :Tests the OverrideNewTaskController class
    */
    public static testMethod void testOverrideNewTaskController(){
        Product__c prod = new Product__c();
        insert prod;
        Task tsk = new Task();
        tsk.WhatId = prod.Id;
        tsk.Subject = 'Testing';
        insert tsk;
        ApexPages.StandardController sc = new ApexPages.StandardController(tsk);
        OverrideNewTaskCls ont = new OverrideNewTaskCls(sc);
        PageReference pg = ont.createNoRT();
        System.assert(pg.getUrl().contains('nooverride'),'Page was not not overridden.');
    }
}