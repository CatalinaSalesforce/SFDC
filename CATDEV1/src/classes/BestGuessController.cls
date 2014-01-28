/*
@Name           : BestGuessController
@Author         : customersuccess@cloud62.com
@Date           : 5/15/2012
@Description    : Controller for BestGuess
*/
public with sharing class BestGuessController{
    //Variables
    public String selectedAccId {get;set;}
    public String gstrManufacturer {get;set;}
    public String gstrRetail {get;set;}
    public String gstrSave {get;set;}
    public Sales_Rep_Best_Guess__c gsrbgUserHolder {get;set;}
    public String gstrGuessId {get;set;}
    public Boolean isManBestGuess {get;set;}
    public String gstrUserId {get;set;}
    public String gstrTeamMemberId {get;set;}
    public String gstrType {get;set;}
    public Boolean selectType {get;set;}
    public String gstrSectionType {get;set;}
    public Boolean isManufacturer {get;set;}
    public Boolean isGridManBestGuess {get;set;}
    public Boolean isGridManufacturer {get;set;}
    public Boolean hideTable {get;set;}
    public String deliveryType {get;set;}
    public Boolean teamMemberIsMan {get;set;}
    public Set<Id> lstUserIds {get;set;}
    public String strManFields {get;set;}
    public String strRepFields {get;set;}
    public Boolean showHistorical {get;set;}
    public Boolean showTeamMembers {get;set;}
    public Boolean showTotal {get;set;}
    public String bestGuessType{get;set;}
    public String congAccount{get; set;}
    public String childAccount{get; set;}
    public Set<Id> t25Conglomerate {get;set;}
    public Integer currentYear;
    public Decimal team_Previous_Year_Actual{get;set;}
    public Decimal total_L{get;set;}
    public Decimal override_Total_L{get;set;}
    public Decimal total_BG{get;set;}
    public Decimal override_Total_BG{get;set;}
    public Decimal total_H{get;set;}
    public Decimal override_Total_H{get;set;}
    public Boolean q1Edit {get;set;}
    public Boolean q2Edit {get;set;}
    public Boolean q3Edit {get;set;}
    public Boolean q4Edit {get;set;}
    public String selDeliveryChannel{get;set;}    
    public List<bestGuessRow> bestGuessList {get;set;}    
    public Decimal sumBestGuess {get;set;}
    public Decimal sumHistBestGuess {get;set;}
    public Decimal sumDiffBestGuess {get;set;}
    public Decimal sumBookedAmount {get;set;}
    public Decimal sumHistBookedAmount {get;set;}
    public Decimal sumDiffBookedAmount {get;set;}
    public List<Manager_Best_Guess__c> gmbgList;
    public List<Sales_Rep_Best_Guess__c> gsrbgList;
    public List<BestGuessRevenueUtil.DeliveryChannelWrapper> delChannelWrapperLst{get;set;}
    public Decimal q1Booked{get;set;}
    public Decimal q2Booked{get;set;}
    public Decimal q3Booked{get;set;}
    public Decimal q4Booked{get;set;}
    public Decimal q1BookedWgt{get;set;}
    public Decimal q2BookedWgt{get;set;}
    public Decimal q3BookedWgt{get;set;}
    public Decimal q4BookedWgt{get;set;}
    public Decimal q1BookedFull{get;set;}
    public Decimal q2BookedFull{get;set;}
    public Decimal q3BookedFull{get;set;}
    public Decimal q4BookedFull{get;set;}
    public Decimal bookedTotal{get;set;}
    public Decimal bookedWgtTotal{get;set;}
    public Decimal bookedFullTotal{get;set;}
        
    //Constructor
    public BestGuessController(){
        bestGuessType = 'user';
        gsrbgUserHolder = new Sales_Rep_Best_Guess__c();
        selectType = false;
        gstrSectionType = 'Manufacturer';
        isManufacturer = true;
        isGridManufacturer = true;
        isGridManBestGuess = true;
        hideTable = true;
        showHistorical = false;
        showTeamMembers = true;
        showTotal = true;
        currentYear = System.Today().year();
        gstrGuessId = String.valueOf(currentYear);
        //Set the grid to display the most recent best guess for the current user
        gmbgList = new List<Manager_Best_Guess__c>();
        gsrbgList = new List<Sales_Rep_Best_Guess__c>();
        setInitialGuessRecord();
        lstUserIds = new Set<id>();
        bestGuessList = new List<bestGuessRow>();
        t25Conglomerate = new Set<Id>();
        if(isManBestGuess == null){
            isManBestGuess = false;
        }
        if(isManBestGuess){
            gstrType = 'Manager';
        } else {
            gstrType = 'Sales Rep';
        }
        selDeliveryChannel='Total';
        searchRevenue();
    }
    
    //Create the strings to populate the manager best guess grid
    public void createDataStringsFromManagerGuess(){
        Map<String,Decimal> manManuRetailMap = new Map<String,Decimal>();
        for(Manager_Best_Guess__c mbg : gmbgList){
            if(mbg.Quarter__c != null && mbg.Quarter__c.startsWith('Q1')){
                q1Edit = mbg.Is_Past__c;
                if(mbg.Team_Manufacturing_Base_Best_Guess__c != null){
                    manManuRetailMap.put('Q1TeamManuBase',mbg.Team_Manufacturing_Base_Best_Guess__c);
                }
                if(mbg.Team_Manufacturing_Digital_Best_Guess__c != null){
                    manManuRetailMap.put('Q1TeamManuDigital',mbg.Team_Manufacturing_Digital_Best_Guess__c);
                }
                if(mbg.Team_Manufacturing_Audience_Best_Guess__c != null){
                    manManuRetailMap.put('Q1TeamManuAudience',mbg.Team_Manufacturing_Audience_Best_Guess__c);
                }
                if(mbg.Team_Manufacturing_Mobile_Best_Guess__c != null){
                    manManuRetailMap.put('Q1TeamManuMobile',mbg.Team_Manufacturing_Mobile_Best_Guess__c);
                }
                if(mbg.Team_Retail_Base_Best_Guess__c != null){
                    manManuRetailMap.put('Q1TeamRetailBase',mbg.Team_Retail_Base_Best_Guess__c);
                }
                if(mbg.Team_Retail_Digital_Best_Guess__c != null){
                    manManuRetailMap.put('Q1TeamRetailDigital',mbg.Team_Retail_Digital_Best_Guess__c);
                }
                if(mbg.Team_Retail_Audience_Best_Guess__c != null){
                    manManuRetailMap.put('Q1TeamRetailAudience',mbg.Team_Retail_Audience_Best_Guess__c);
                }
                if(mbg.Team_Retail_Mobile_Best_Guess__c != null){
                    manManuRetailMap.put('Q1TeamRetailMobile',mbg.Team_Retail_Mobile_Best_Guess__c);
                }
                if(mbg.Override_Team_Manu_Base_Best_Guess__c != null){
                    manManuRetailMap.put('Q1ManuBase',mbg.Override_Team_Manu_Base_Best_Guess__c);
                }
                if(mbg.Override_Team_Manu_Digital_Best_Guess__c != null){
                    manManuRetailMap.put('Q1ManuDigital',mbg.Override_Team_Manu_Digital_Best_Guess__c);
                }
                if(mbg.Override_Team_Manu_Audience_Best_Guess__c != null){
                    manManuRetailMap.put('Q1ManuAudience',mbg.Override_Team_Manu_Audience_Best_Guess__c);
                }
                if(mbg.Override_Team_Manu_Mobile_Best_Guess__c != null){
                    manManuRetailMap.put('Q1ManuMobile',mbg.Override_Team_Manu_Mobile_Best_Guess__c);
                }
                if(mbg.Override_Team_Retail_Base_Best_Guess__c != null){
                    manManuRetailMap.put('Q1RetailBase',mbg.Override_Team_Retail_Base_Best_Guess__c);
                }
                if(mbg.Override_Team_Retail_Digital_Best_Guess__c != null){
                    manManuRetailMap.put('Q1RetailDigital',mbg.Override_Team_Retail_Digital_Best_Guess__c);
                }
                if(mbg.Override_Team_Retail_Audience_Best_Guess__c != null){
                    manManuRetailMap.put('Q1RetailAudience',mbg.Override_Team_Retail_Audience_Best_Guess__c);
                }
                if(mbg.Override_Team_Retail_Mobile_Best_Guess__c != null){
                    manManuRetailMap.put('Q1RetailMobile',mbg.Override_Team_Retail_Mobile_Best_Guess__c);
                }
            }
            if(mbg.Quarter__c != null && mbg.Quarter__c.startsWith('Q2')){
                q2Edit = mbg.Is_Past__c;
                if(mbg.Team_Manufacturing_Base_Best_Guess__c != null){
                    manManuRetailMap.put('Q2TeamManuBase',mbg.Team_Manufacturing_Base_Best_Guess__c);
                }
                if(mbg.Team_Manufacturing_Digital_Best_Guess__c != null){
                    manManuRetailMap.put('Q2TeamManuDigital',mbg.Team_Manufacturing_Digital_Best_Guess__c);
                }
                if(mbg.Team_Manufacturing_Audience_Best_Guess__c != null){
                    manManuRetailMap.put('Q2TeamManuAudience',mbg.Team_Manufacturing_Audience_Best_Guess__c);
                }
                if(mbg.Team_Manufacturing_Mobile_Best_Guess__c != null){
                    manManuRetailMap.put('Q2TeamManuMobile',mbg.Team_Manufacturing_Mobile_Best_Guess__c);
                }
                if(mbg.Team_Retail_Base_Best_Guess__c != null){
                    manManuRetailMap.put('Q2TeamRetailBase',mbg.Team_Retail_Base_Best_Guess__c);
                }
                if(mbg.Team_Retail_Digital_Best_Guess__c != null){
                    manManuRetailMap.put('Q2TeamRetailDigital',mbg.Team_Retail_Digital_Best_Guess__c);
                }
                if(mbg.Team_Retail_Audience_Best_Guess__c != null){
                    manManuRetailMap.put('Q2TeamRetailAudience',mbg.Team_Retail_Audience_Best_Guess__c);
                }
                if(mbg.Team_Retail_Mobile_Best_Guess__c != null){
                    manManuRetailMap.put('Q2TeamRetailMobile',mbg.Team_Retail_Mobile_Best_Guess__c);
                }
                if(mbg.Override_Team_Manu_Base_Best_Guess__c != null){
                    manManuRetailMap.put('Q2ManuBase',mbg.Override_Team_Manu_Base_Best_Guess__c);
                }
                if(mbg.Override_Team_Manu_Digital_Best_Guess__c != null){
                    manManuRetailMap.put('Q2ManuDigital',mbg.Override_Team_Manu_Digital_Best_Guess__c);
                }
                if(mbg.Override_Team_Manu_Audience_Best_Guess__c != null){
                    manManuRetailMap.put('Q2ManuAudience',mbg.Override_Team_Manu_Audience_Best_Guess__c);
                }
                if(mbg.Override_Team_Manu_Mobile_Best_Guess__c != null){
                    manManuRetailMap.put('Q2ManuMobile',mbg.Override_Team_Manu_Mobile_Best_Guess__c);
                }
                if(mbg.Override_Team_Retail_Base_Best_Guess__c != null){
                    manManuRetailMap.put('Q2RetailBase',mbg.Override_Team_Retail_Base_Best_Guess__c);
                }
                if(mbg.Override_Team_Retail_Digital_Best_Guess__c != null){
                    manManuRetailMap.put('Q2RetailDigital',mbg.Override_Team_Retail_Digital_Best_Guess__c);
                }
                if(mbg.Override_Team_Retail_Audience_Best_Guess__c != null){
                    manManuRetailMap.put('Q2RetailAudience',mbg.Override_Team_Retail_Audience_Best_Guess__c);
                }
                if(mbg.Override_Team_Retail_Mobile_Best_Guess__c != null){
                    manManuRetailMap.put('Q2RetailMobile',mbg.Override_Team_Retail_Mobile_Best_Guess__c);
                }
            }
            if(mbg.Quarter__c != null && mbg.Quarter__c.startsWith('Q3')){
                q3Edit = mbg.Is_Past__c;
                if(mbg.Team_Manufacturing_Base_Best_Guess__c != null){
                    manManuRetailMap.put('Q3TeamManuBase',mbg.Team_Manufacturing_Base_Best_Guess__c);
                }
                if(mbg.Team_Manufacturing_Digital_Best_Guess__c != null){
                    manManuRetailMap.put('Q3TeamManuDigital',mbg.Team_Manufacturing_Digital_Best_Guess__c);
                }
                if(mbg.Team_Manufacturing_Audience_Best_Guess__c != null){
                    manManuRetailMap.put('Q3TeamManuAudience',mbg.Team_Manufacturing_Audience_Best_Guess__c);
                }
                if(mbg.Team_Manufacturing_Mobile_Best_Guess__c != null){
                    manManuRetailMap.put('Q3TeamManuMobile',mbg.Team_Manufacturing_Mobile_Best_Guess__c);
                }
                if(mbg.Team_Retail_Base_Best_Guess__c != null){
                    manManuRetailMap.put('Q3TeamRetailBase',mbg.Team_Retail_Base_Best_Guess__c);
                }
                if(mbg.Team_Retail_Digital_Best_Guess__c != null){
                    manManuRetailMap.put('Q3TeamRetailDigital',mbg.Team_Retail_Digital_Best_Guess__c);
                }
                if(mbg.Team_Retail_Audience_Best_Guess__c != null){
                    manManuRetailMap.put('Q3TeamRetailAudience',mbg.Team_Retail_Audience_Best_Guess__c);
                }
                if(mbg.Team_Retail_Mobile_Best_Guess__c != null){
                    manManuRetailMap.put('Q3TeamRetailMobile',mbg.Team_Retail_Mobile_Best_Guess__c);
                }
                if(mbg.Override_Team_Manu_Base_Best_Guess__c != null){
                    manManuRetailMap.put('Q3ManuBase',mbg.Override_Team_Manu_Base_Best_Guess__c);
                }
                if(mbg.Override_Team_Manu_Digital_Best_Guess__c != null){
                    manManuRetailMap.put('Q3ManuDigital',mbg.Override_Team_Manu_Digital_Best_Guess__c);
                }
                if(mbg.Override_Team_Manu_Audience_Best_Guess__c != null){
                    manManuRetailMap.put('Q3ManuAudience',mbg.Override_Team_Manu_Audience_Best_Guess__c);
                }
                if(mbg.Override_Team_Manu_Mobile_Best_Guess__c != null){
                    manManuRetailMap.put('Q3ManuMobile',mbg.Override_Team_Manu_Mobile_Best_Guess__c);
                }
                if(mbg.Override_Team_Retail_Base_Best_Guess__c != null){
                    manManuRetailMap.put('Q3RetailBase',mbg.Override_Team_Retail_Base_Best_Guess__c);
                }
                if(mbg.Override_Team_Retail_Digital_Best_Guess__c != null){
                    manManuRetailMap.put('Q3RetailDigital',mbg.Override_Team_Retail_Digital_Best_Guess__c);
                }
                if(mbg.Override_Team_Retail_Audience_Best_Guess__c != null){
                    manManuRetailMap.put('Q3RetailAudience',mbg.Override_Team_Retail_Audience_Best_Guess__c);
                }
                if(mbg.Override_Team_Retail_Mobile_Best_Guess__c != null){
                    manManuRetailMap.put('Q3RetailMobile',mbg.Override_Team_Retail_Mobile_Best_Guess__c);
                }
            }
            if(mbg.Quarter__c != null && mbg.Quarter__c.startsWith('Q4')){
                q4Edit = mbg.Is_Past__c;
                if(mbg.Team_Manufacturing_Base_Best_Guess__c != null){
                    manManuRetailMap.put('Q4TeamManuBase',mbg.Team_Manufacturing_Base_Best_Guess__c);
                }
                if(mbg.Team_Manufacturing_Digital_Best_Guess__c != null){
                    manManuRetailMap.put('Q4TeamManuDigital',mbg.Team_Manufacturing_Digital_Best_Guess__c);
                }
                if(mbg.Team_Manufacturing_Audience_Best_Guess__c != null){
                    manManuRetailMap.put('Q4TeamManuAudience',mbg.Team_Manufacturing_Audience_Best_Guess__c);
                }
                if(mbg.Team_Manufacturing_Mobile_Best_Guess__c != null){
                    manManuRetailMap.put('Q4TeamManuMobile',mbg.Team_Manufacturing_Mobile_Best_Guess__c);
                }
                if(mbg.Team_Retail_Base_Best_Guess__c != null){
                    manManuRetailMap.put('Q4TeamRetailBase',mbg.Team_Retail_Base_Best_Guess__c);
                }
                if(mbg.Team_Retail_Digital_Best_Guess__c != null){
                    manManuRetailMap.put('Q4TeamRetailDigital',mbg.Team_Retail_Digital_Best_Guess__c);
                }
                if(mbg.Team_Retail_Audience_Best_Guess__c != null){
                    manManuRetailMap.put('Q4TeamRetailAudience',mbg.Team_Retail_Audience_Best_Guess__c);
                }
                if(mbg.Team_Retail_Mobile_Best_Guess__c != null){
                    manManuRetailMap.put('Q4TeamRetailMobile',mbg.Team_Retail_Mobile_Best_Guess__c);
                }
                if(mbg.Override_Team_Manu_Base_Best_Guess__c != null){
                    manManuRetailMap.put('Q4ManuBase',mbg.Override_Team_Manu_Base_Best_Guess__c);
                }
                if(mbg.Override_Team_Manu_Digital_Best_Guess__c != null){
                    manManuRetailMap.put('Q4ManuDigital',mbg.Override_Team_Manu_Digital_Best_Guess__c);
                }
                if(mbg.Override_Team_Manu_Audience_Best_Guess__c != null){
                    manManuRetailMap.put('Q4ManuAudience',mbg.Override_Team_Manu_Audience_Best_Guess__c);
                }
                if(mbg.Override_Team_Manu_Mobile_Best_Guess__c != null){
                    manManuRetailMap.put('Q4ManuMobile',mbg.Override_Team_Manu_Mobile_Best_Guess__c);
                }
                if(mbg.Override_Team_Retail_Base_Best_Guess__c != null){
                    manManuRetailMap.put('Q4RetailBase',mbg.Override_Team_Retail_Base_Best_Guess__c);
                }
                if(mbg.Override_Team_Retail_Digital_Best_Guess__c != null){
                    manManuRetailMap.put('Q4RetailDigital',mbg.Override_Team_Retail_Digital_Best_Guess__c);
                }
                if(mbg.Override_Team_Retail_Audience_Best_Guess__c != null){
                    manManuRetailMap.put('Q4RetailAudience',mbg.Override_Team_Retail_Audience_Best_Guess__c);
                }
                if(mbg.Override_Team_Retail_Mobile_Best_Guess__c != null){
                    manManuRetailMap.put('Q4RetailMobile',mbg.Override_Team_Retail_Mobile_Best_Guess__c);
                }
            }
        }        
        //String for Manufacturer grid  
        gstrManufacturer = '[{rowName:"Base"';
        if(manManuRetailMap.get('Q1TeamManuBase')!=null)gstrManufacturer += ',teamQ1:"' + manManuRetailMap.get('Q1TeamManuBase') + '"';
        if(manManuRetailMap.get('Q2TeamManuBase')!=null)gstrManufacturer += ',teamQ2:"' + manManuRetailMap.get('Q2TeamManuBase') + '"';
        if(manManuRetailMap.get('Q3TeamManuBase')!=null)gstrManufacturer += ',teamQ3:"' + manManuRetailMap.get('Q3TeamManuBase') + '"';
        if(manManuRetailMap.get('Q4TeamManuBase')!=null)gstrManufacturer += ',teamQ4:"' + manManuRetailMap.get('Q4TeamManuBase') + '"';
        if(manManuRetailMap.get('Q1ManuBase')!=null)gstrManufacturer += ',q1:"' + manManuRetailMap.get('Q1ManuBase') + '"';
        if(manManuRetailMap.get('Q2ManuBase')!=null)gstrManufacturer += ',q2:"' + manManuRetailMap.get('Q2ManuBase') + '"';
        if(manManuRetailMap.get('Q3ManuBase')!=null)gstrManufacturer += ',q3:"' + manManuRetailMap.get('Q3ManuBase') + '"';
        if(manManuRetailMap.get('Q4ManuBase')!=null)gstrManufacturer += ',q4:"' + manManuRetailMap.get('Q4ManuBase') + '"';
        gstrManufacturer += '},';                            
        gstrManufacturer += '{rowName:"Digital - O&O"';
        if(manManuRetailMap.get('Q1TeamManuDigital')!=null)gstrManufacturer += ',teamQ1:"' + manManuRetailMap.get('Q1TeamManuDigital') + '"';
        if(manManuRetailMap.get('Q2TeamManuDigital')!=null)gstrManufacturer += ',teamQ2:"' + manManuRetailMap.get('Q2TeamManuDigital') + '"';
        if(manManuRetailMap.get('Q3TeamManuDigital')!=null)gstrManufacturer += ',teamQ3:"' + manManuRetailMap.get('Q3TeamManuDigital') + '"';
        if(manManuRetailMap.get('Q4TeamManuDigital')!=null)gstrManufacturer += ',teamQ4:"' + manManuRetailMap.get('Q4TeamManuDigital') + '"';
        if(manManuRetailMap.get('Q1ManuDigital')!=null)gstrManufacturer += ',q1:"' + manManuRetailMap.get('Q1ManuDigital') + '"';
        if(manManuRetailMap.get('Q2ManuDigital')!=null)gstrManufacturer += ',q2:"' + manManuRetailMap.get('Q2ManuDigital') + '"';
        if(manManuRetailMap.get('Q3ManuDigital')!=null)gstrManufacturer += ',q3:"' + manManuRetailMap.get('Q3ManuDigital') + '"';
        if(manManuRetailMap.get('Q4ManuDigital')!=null)gstrManufacturer += ',q4:"' + manManuRetailMap.get('Q4ManuDigital') + '"';
        gstrManufacturer += '},';        
        gstrManufacturer += '{rowName:"Audience Network"';
        if(manManuRetailMap.get('Q1TeamManuAudience')!=null)gstrManufacturer += ',teamQ1:"' + manManuRetailMap.get('Q1TeamManuAudience') + '"';
        if(manManuRetailMap.get('Q2TeamManuAudience')!=null)gstrManufacturer += ',teamQ2:"' + manManuRetailMap.get('Q2TeamManuAudience') + '"';
        if(manManuRetailMap.get('Q3TeamManuAudience')!=null)gstrManufacturer += ',teamQ3:"' + manManuRetailMap.get('Q3TeamManuAudience') + '"';
        if(manManuRetailMap.get('Q4TeamManuAudience')!=null)gstrManufacturer += ',teamQ4:"' + manManuRetailMap.get('Q4TeamManuAudience') + '"';
        if(manManuRetailMap.get('Q1ManuAudience')!=null)gstrManufacturer += ',q1:"' + manManuRetailMap.get('Q1ManuAudience') + '"';
        if(manManuRetailMap.get('Q2ManuAudience')!=null)gstrManufacturer += ',q2:"' + manManuRetailMap.get('Q2ManuAudience') + '"';
        if(manManuRetailMap.get('Q3ManuAudience')!=null)gstrManufacturer += ',q3:"' + manManuRetailMap.get('Q3ManuAudience') + '"';
        if(manManuRetailMap.get('Q4ManuAudience')!=null)gstrManufacturer += ',q4:"' + manManuRetailMap.get('Q4ManuAudience') + '"';
        gstrManufacturer += '},';                              
        gstrManufacturer += '{rowName:"Mobile"';
        if(manManuRetailMap.get('Q1TeamManuMobile')!=null)gstrManufacturer += ',teamQ1:"' + manManuRetailMap.get('Q1TeamManuMobile') + '"';
        if(manManuRetailMap.get('Q2TeamManuMobile')!=null)gstrManufacturer += ',teamQ2:"' + manManuRetailMap.get('Q2TeamManuMobile') + '"';
        if(manManuRetailMap.get('Q3TeamManuMobile')!=null)gstrManufacturer += ',teamQ3:"' + manManuRetailMap.get('Q3TeamManuMobile') + '"';
        if(manManuRetailMap.get('Q4TeamManuMobile')!=null)gstrManufacturer += ',teamQ4:"' + manManuRetailMap.get('Q4TeamManuMobile') + '"';
        if(manManuRetailMap.get('Q1ManuMobile')!=null)gstrManufacturer += ',q1:"' + manManuRetailMap.get('Q1ManuMobile') + '"';
        if(manManuRetailMap.get('Q2ManuMobile')!=null)gstrManufacturer += ',q2:"' + manManuRetailMap.get('Q2ManuMobile') + '"';
        if(manManuRetailMap.get('Q3ManuMobile')!=null)gstrManufacturer += ',q3:"' + manManuRetailMap.get('Q3ManuMobile') + '"';
        if(manManuRetailMap.get('Q4ManuMobile')!=null)gstrManufacturer += ',q4:"' + manManuRetailMap.get('Q4ManuMobile') + '"';
        gstrManufacturer += '}]';
        
        //String for Retail grid  
        gstrRetail = '[{rowName:"Base"';
        if(manManuRetailMap.get('Q1TeamRetailBase')!=null)gstrRetail += ',teamQ1:"' + manManuRetailMap.get('Q1TeamRetailBase') + '"';
        if(manManuRetailMap.get('Q2TeamRetailBase')!=null)gstrRetail += ',teamQ2:"' + manManuRetailMap.get('Q2TeamRetailBase') + '"';
        if(manManuRetailMap.get('Q3TeamRetailBase')!=null)gstrRetail += ',teamQ3:"' + manManuRetailMap.get('Q3TeamRetailBase') + '"';
        if(manManuRetailMap.get('Q4TeamRetailBase')!=null)gstrRetail += ',teamQ4:"' + manManuRetailMap.get('Q4TeamRetailBase') + '"';
        if(manManuRetailMap.get('Q1RetailBase')!=null)gstrRetail += ',q1:"' + manManuRetailMap.get('Q1RetailBase') + '"';
        if(manManuRetailMap.get('Q2RetailBase')!=null)gstrRetail += ',q2:"' + manManuRetailMap.get('Q2RetailBase') + '"';
        if(manManuRetailMap.get('Q3RetailBase')!=null)gstrRetail += ',q3:"' + manManuRetailMap.get('Q3RetailBase') + '"';
        if(manManuRetailMap.get('Q4RetailBase')!=null)gstrRetail += ',q4:"' + manManuRetailMap.get('Q4RetailBase') + '"';
        gstrRetail += '},';                            
        gstrRetail += '{rowName:"Digital - O&O"';
        if(manManuRetailMap.get('Q1TeamRetailDigital')!=null)gstrRetail += ',teamQ1:"' + manManuRetailMap.get('Q1TeamRetailDigital') + '"';
        if(manManuRetailMap.get('Q2TeamRetailDigital')!=null)gstrRetail += ',teamQ2:"' + manManuRetailMap.get('Q2TeamRetailDigital') + '"';
        if(manManuRetailMap.get('Q3TeamRetailDigital')!=null)gstrRetail += ',teamQ3:"' + manManuRetailMap.get('Q3TeamRetailDigital') + '"';
        if(manManuRetailMap.get('Q4TeamRetailDigital')!=null)gstrRetail += ',teamQ4:"' + manManuRetailMap.get('Q4TeamRetailDigital') + '"';
        if(manManuRetailMap.get('Q1RetailDigital')!=null)gstrRetail += ',q1:"' + manManuRetailMap.get('Q1RetailDigital') + '"';
        if(manManuRetailMap.get('Q2RetailDigital')!=null)gstrRetail += ',q2:"' + manManuRetailMap.get('Q2RetailDigital') + '"';
        if(manManuRetailMap.get('Q3RetailDigital')!=null)gstrRetail += ',q3:"' + manManuRetailMap.get('Q3RetailDigital') + '"';
        if(manManuRetailMap.get('Q4RetailDigital')!=null)gstrRetail += ',q4:"' + manManuRetailMap.get('Q4RetailDigital') + '"';
        gstrRetail += '},';        
        gstrRetail += '{rowName:"Audience Network"';
        if(manManuRetailMap.get('Q1TeamRetailAudience')!=null)gstrRetail += ',teamQ1:"' + manManuRetailMap.get('Q1TeamRetailAudience') + '"';
        if(manManuRetailMap.get('Q2TeamRetailAudience')!=null)gstrRetail += ',teamQ2:"' + manManuRetailMap.get('Q2TeamRetailAudience') + '"';
        if(manManuRetailMap.get('Q3TeamRetailAudience')!=null)gstrRetail += ',teamQ3:"' + manManuRetailMap.get('Q3TeamRetailAudience') + '"';
        if(manManuRetailMap.get('Q4TeamRetailAudience')!=null)gstrRetail += ',teamQ4:"' + manManuRetailMap.get('Q4TeamRetailAudience') + '"';
        if(manManuRetailMap.get('Q1RetailAudience')!=null)gstrRetail += ',q1:"' + manManuRetailMap.get('Q1RetailAudience') + '"';
        if(manManuRetailMap.get('Q2RetailAudience')!=null)gstrRetail += ',q2:"' + manManuRetailMap.get('Q2RetailAudience') + '"';
        if(manManuRetailMap.get('Q3RetailAudience')!=null)gstrRetail += ',q3:"' + manManuRetailMap.get('Q3RetailAudience') + '"';
        if(manManuRetailMap.get('Q4RetailAudience')!=null)gstrRetail += ',q4:"' + manManuRetailMap.get('Q4RetailAudience') + '"';
        gstrRetail += '},';                              
        gstrRetail += '{rowName:"Mobile"';
        if(manManuRetailMap.get('Q1TeamRetailMobile')!=null)gstrRetail += ',teamQ1:"' + manManuRetailMap.get('Q1TeamRetailMobile') + '"';
        if(manManuRetailMap.get('Q2TeamRetailMobile')!=null)gstrRetail += ',teamQ2:"' + manManuRetailMap.get('Q2TeamRetailMobile') + '"';
        if(manManuRetailMap.get('Q3TeamRetailMobile')!=null)gstrRetail += ',teamQ3:"' + manManuRetailMap.get('Q3TeamRetailMobile') + '"';
        if(manManuRetailMap.get('Q4TeamRetailMobile')!=null)gstrRetail += ',teamQ4:"' + manManuRetailMap.get('Q4TeamRetailMobile') + '"';
        if(manManuRetailMap.get('Q1RetailMobile')!=null)gstrRetail += ',q1:"' + manManuRetailMap.get('Q1RetailMobile') + '"';
        if(manManuRetailMap.get('Q2RetailMobile')!=null)gstrRetail += ',q2:"' + manManuRetailMap.get('Q2RetailMobile') + '"';
        if(manManuRetailMap.get('Q3RetailMobile')!=null)gstrRetail += ',q3:"' + manManuRetailMap.get('Q3RetailMobile') + '"';
        if(manManuRetailMap.get('Q4RetailMobile')!=null)gstrRetail += ',q4:"' + manManuRetailMap.get('Q4RetailMobile') + '"';
        gstrRetail += '}]';
    }
    
    //Create the strings to populate the grid for Rep
    public void createDataStringsFromRepGuess(){
        Map<String,Decimal> repManuRetailMap = new Map<String,Decimal>();
        for(Sales_Rep_Best_Guess__c sbg : gsrbgList){
            if(sbg.Quarter__c != null && sbg.Quarter__c.startsWith('Q1')){
                q1Edit = sbg.Is_Past__c;
                if(sbg.Manufacturing_Base_Best_Guess__c != null){
                    repManuRetailMap.put('Q1ManuBase',sbg.Manufacturing_Base_Best_Guess__c);
                }
                if(sbg.Manufacturing_Digital_Best_Guess__c != null){
                    repManuRetailMap.put('Q1ManuDigital',sbg.Manufacturing_Digital_Best_Guess__c);
                }
                if(sbg.Manufacturing_Audience_Best_Guess__c != null){
                    repManuRetailMap.put('Q1ManuAudience',sbg.Manufacturing_Audience_Best_Guess__c);
                }
                if(sbg.Manufacturing_Mobile_Best_Guess__c != null){
                    repManuRetailMap.put('Q1ManuMobile',sbg.Manufacturing_Mobile_Best_Guess__c);
                }
                if(sbg.Retail_Base_Best_Guess__c != null){
                    repManuRetailMap.put('Q1RetailBase',sbg.Retail_Base_Best_Guess__c);
                }
                if(sbg.Retail_Digital_Best_Guess__c != null){
                    repManuRetailMap.put('Q1RetailDigital',sbg.Retail_Digital_Best_Guess__c);
                }
                if(sbg.Retail_Audience_Best_Guess__c != null){
                    repManuRetailMap.put('Q1RetailAudience',sbg.Retail_Audience_Best_Guess__c);
                }
                if(sbg.Retail_Mobile_Best_Guess__c != null){
                    repManuRetailMap.put('Q1RetailMobile',sbg.Retail_Mobile_Best_Guess__c);
                }
            }
            if(sbg.Quarter__c != null && sbg.Quarter__c.startsWith('Q2')){
                q2Edit = sbg.Is_Past__c;
                if(sbg.Manufacturing_Base_Best_Guess__c != null){
                    repManuRetailMap.put('Q2ManuBase',sbg.Manufacturing_Base_Best_Guess__c);
                }
                if(sbg.Manufacturing_Digital_Best_Guess__c != null){
                    repManuRetailMap.put('Q2ManuDigital',sbg.Manufacturing_Digital_Best_Guess__c);
                }
                if(sbg.Manufacturing_Audience_Best_Guess__c != null){
                    repManuRetailMap.put('Q2ManuAudience',sbg.Manufacturing_Audience_Best_Guess__c);
                }
                if(sbg.Manufacturing_Mobile_Best_Guess__c != null){
                    repManuRetailMap.put('Q2ManuMobile',sbg.Manufacturing_Mobile_Best_Guess__c);
                }
                if(sbg.Retail_Base_Best_Guess__c != null){
                    repManuRetailMap.put('Q2RetailBase',sbg.Retail_Base_Best_Guess__c);
                }
                if(sbg.Retail_Digital_Best_Guess__c != null){
                    repManuRetailMap.put('Q2RetailDigital',sbg.Retail_Digital_Best_Guess__c);
                }
                if(sbg.Retail_Audience_Best_Guess__c != null){
                    repManuRetailMap.put('Q2RetailAudience',sbg.Retail_Audience_Best_Guess__c);
                }
                if(sbg.Retail_Mobile_Best_Guess__c != null){
                    repManuRetailMap.put('Q2RetailMobile',sbg.Retail_Mobile_Best_Guess__c);
                }
            }
            if(sbg.Quarter__c != null && sbg.Quarter__c.startsWith('Q3')){
                q3Edit = sbg.Is_Past__c;
                if(sbg.Manufacturing_Base_Best_Guess__c != null){
                    repManuRetailMap.put('Q3ManuBase',sbg.Manufacturing_Base_Best_Guess__c);
                }
                if(sbg.Manufacturing_Digital_Best_Guess__c != null){
                    repManuRetailMap.put('Q3ManuDigital',sbg.Manufacturing_Digital_Best_Guess__c);
                }
                if(sbg.Manufacturing_Audience_Best_Guess__c != null){
                    repManuRetailMap.put('Q3ManuAudience',sbg.Manufacturing_Audience_Best_Guess__c);
                }
                if(sbg.Manufacturing_Mobile_Best_Guess__c != null){
                    repManuRetailMap.put('Q3ManuMobile',sbg.Manufacturing_Mobile_Best_Guess__c);
                }
                if(sbg.Retail_Base_Best_Guess__c != null){
                    repManuRetailMap.put('Q3RetailBase',sbg.Retail_Base_Best_Guess__c);
                }
                if(sbg.Retail_Digital_Best_Guess__c != null){
                    repManuRetailMap.put('Q3RetailDigital',sbg.Retail_Digital_Best_Guess__c);
                }
                if(sbg.Retail_Audience_Best_Guess__c != null){
                    repManuRetailMap.put('Q3RetailAudience',sbg.Retail_Audience_Best_Guess__c);
                }
                if(sbg.Retail_Mobile_Best_Guess__c != null){
                    repManuRetailMap.put('Q3RetailMobile',sbg.Retail_Mobile_Best_Guess__c);
                }
            }
            if(sbg.Quarter__c != null && sbg.Quarter__c.startsWith('Q4')){
                q4Edit = sbg.Is_Past__c;
                if(sbg.Manufacturing_Base_Best_Guess__c != null){
                    repManuRetailMap.put('Q4ManuBase',sbg.Manufacturing_Base_Best_Guess__c);
                }
                if(sbg.Manufacturing_Digital_Best_Guess__c != null){
                    repManuRetailMap.put('Q4ManuDigital',sbg.Manufacturing_Digital_Best_Guess__c);
                }
                if(sbg.Manufacturing_Audience_Best_Guess__c != null){
                    repManuRetailMap.put('Q4ManuAudience',sbg.Manufacturing_Audience_Best_Guess__c);
                }
                if(sbg.Manufacturing_Mobile_Best_Guess__c != null){
                    repManuRetailMap.put('Q4ManuMobile',sbg.Manufacturing_Mobile_Best_Guess__c);
                }
                if(sbg.Retail_Base_Best_Guess__c != null){
                    repManuRetailMap.put('Q4RetailBase',sbg.Retail_Base_Best_Guess__c);
                }
                if(sbg.Retail_Digital_Best_Guess__c != null){
                    repManuRetailMap.put('Q4RetailDigital',sbg.Retail_Digital_Best_Guess__c);
                }
                if(sbg.Retail_Audience_Best_Guess__c != null){
                    repManuRetailMap.put('Q4RetailAudience',sbg.Retail_Audience_Best_Guess__c);
                }
                if(sbg.Retail_Mobile_Best_Guess__c != null){
                    repManuRetailMap.put('Q4RetailMobile',sbg.Retail_Mobile_Best_Guess__c);
                }
            }
        }
        //String for Manufacturer grid  
        gstrManufacturer = '[{rowName:"Base"';
        if(repManuRetailMap.get('Q1ManuBase')!=null)gstrManufacturer += ',teamQ1:"' + repManuRetailMap.get('Q1ManuBase') + '"';
        if(repManuRetailMap.get('Q2ManuBase')!=null)gstrManufacturer += ',teamQ2:"' + repManuRetailMap.get('Q2ManuBase') + '"';
        if(repManuRetailMap.get('Q3ManuBase')!=null)gstrManufacturer += ',teamQ3:"' + repManuRetailMap.get('Q3ManuBase') + '"';
        if(repManuRetailMap.get('Q4ManuBase')!=null)gstrManufacturer += ',teamQ4:"' + repManuRetailMap.get('Q4ManuBase') + '"';
        gstrManufacturer += '},';                            
        gstrManufacturer += '{rowName:"Digital - O&O"';
        if(repManuRetailMap.get('Q1ManuDigital')!=null)gstrManufacturer += ',teamQ1:"' + repManuRetailMap.get('Q1ManuDigital') + '"';
        if(repManuRetailMap.get('Q2ManuDigital')!=null)gstrManufacturer += ',teamQ2:"' + repManuRetailMap.get('Q2ManuDigital') + '"';
        if(repManuRetailMap.get('Q3ManuDigital')!=null)gstrManufacturer += ',teamQ3:"' + repManuRetailMap.get('Q3ManuDigital') + '"';
        if(repManuRetailMap.get('Q4ManuDigital')!=null)gstrManufacturer += ',teamQ4:"' + repManuRetailMap.get('Q4ManuDigital') + '"';
        gstrManufacturer += '},';        
        gstrManufacturer += '{rowName:"Audience Network"';
        if(repManuRetailMap.get('Q1ManuAudience')!=null)gstrManufacturer += ',teamQ1:"' + repManuRetailMap.get('Q1ManuAudience') + '"';
        if(repManuRetailMap.get('Q2ManuAudience')!=null)gstrManufacturer += ',teamQ2:"' + repManuRetailMap.get('Q2ManuAudience') + '"';
        if(repManuRetailMap.get('Q3ManuAudience')!=null)gstrManufacturer += ',teamQ3:"' + repManuRetailMap.get('Q3ManuAudience') + '"';
        if(repManuRetailMap.get('Q4ManuAudience')!=null)gstrManufacturer += ',teamQ4:"' + repManuRetailMap.get('Q4ManuAudience') + '"';
        gstrManufacturer += '},';                              
        gstrManufacturer += '{rowName:"Mobile"';
        if(repManuRetailMap.get('Q1ManuMobile')!=null)gstrManufacturer += ',teamQ1:"' + repManuRetailMap.get('Q1ManuMobile') + '"';
        if(repManuRetailMap.get('Q2ManuMobile')!=null)gstrManufacturer += ',teamQ2:"' + repManuRetailMap.get('Q2ManuMobile') + '"';
        if(repManuRetailMap.get('Q3ManuMobile')!=null)gstrManufacturer += ',teamQ3:"' + repManuRetailMap.get('Q3ManuMobile') + '"';
        if(repManuRetailMap.get('Q4ManuMobile')!=null)gstrManufacturer += ',teamQ4:"' + repManuRetailMap.get('Q4ManuMobile') + '"';
        gstrManufacturer += '}]';   
        //String for Retail grid  
        gstrRetail = '[{rowName:"Base"';
        if(repManuRetailMap.get('Q1RetailBase')!=null)gstrRetail += ',teamQ1:"' + repManuRetailMap.get('Q1RetailBase') + '"';
        if(repManuRetailMap.get('Q2RetailBase')!=null)gstrRetail += ',teamQ2:"' + repManuRetailMap.get('Q2RetailBase') + '"';
        if(repManuRetailMap.get('Q3RetailBase')!=null)gstrRetail += ',teamQ3:"' + repManuRetailMap.get('Q3RetailBase') + '"';
        if(repManuRetailMap.get('Q4RetailBase')!=null)gstrRetail += ',teamQ4:"' + repManuRetailMap.get('Q4RetailBase') + '"';
        gstrRetail += '},';                            
        gstrRetail += '{rowName:"Digital - O&O"';
        if(repManuRetailMap.get('Q1RetailDigital')!=null)gstrRetail += ',teamQ1:"' + repManuRetailMap.get('Q1RetailDigital') + '"';
        if(repManuRetailMap.get('Q2RetailDigital')!=null)gstrRetail += ',teamQ2:"' + repManuRetailMap.get('Q2RetailDigital') + '"';
        if(repManuRetailMap.get('Q3RetailDigital')!=null)gstrRetail += ',teamQ3:"' + repManuRetailMap.get('Q3RetailDigital') + '"';
        if(repManuRetailMap.get('Q4RetailDigital')!=null)gstrRetail += ',teamQ4:"' + repManuRetailMap.get('Q4RetailDigital') + '"';
        gstrRetail += '},';        
        gstrRetail += '{rowName:"Audience Network"';
        if(repManuRetailMap.get('Q1RetailAudience')!=null)gstrRetail += ',teamQ1:"' + repManuRetailMap.get('Q1RetailAudience') + '"';
        if(repManuRetailMap.get('Q2RetailAudience')!=null)gstrRetail += ',teamQ2:"' + repManuRetailMap.get('Q2RetailAudience') + '"';
        if(repManuRetailMap.get('Q3RetailAudience')!=null)gstrRetail += ',teamQ3:"' + repManuRetailMap.get('Q3RetailAudience') + '"';
        if(repManuRetailMap.get('Q4RetailAudience')!=null)gstrRetail += ',teamQ4:"' + repManuRetailMap.get('Q4RetailAudience') + '"';
        gstrRetail += '},';                              
        gstrRetail += '{rowName:"Mobile"';
        if(repManuRetailMap.get('Q1RetailMobile')!=null)gstrRetail += ',teamQ1:"' + repManuRetailMap.get('Q1RetailMobile') + '"';
        if(repManuRetailMap.get('Q2RetailMobile')!=null)gstrRetail += ',teamQ2:"' + repManuRetailMap.get('Q2RetailMobile') + '"';
        if(repManuRetailMap.get('Q3RetailMobile')!=null)gstrRetail += ',teamQ3:"' + repManuRetailMap.get('Q3RetailMobile') + '"';
        if(repManuRetailMap.get('Q4RetailMobile')!=null)gstrRetail += ',teamQ4:"' + repManuRetailMap.get('Q4RetailMobile') + '"';
        gstrRetail += '}]';
    }

    //Set the type based on the user selected
    public PageReference setType(){
        if(gstrUserId != null){
            List<Manager_Best_Guess__c> lstMan = [SELECT Id, Name FROM Manager_Best_Guess__c WHERE OwnerId = :gstrUserId LIMIT 1];
            List<Sales_Rep_Best_Guess__c> lstRep = [SELECT Id, Name FROM Sales_Rep_Best_Guess__c WHERE OwnerId = :gstrUserId LIMIT 1];
            if(lstMan.size() > 0 && lstRep.size() > 0){
                selectType = true;
            } else if(lstMan.size() > 0){
                selectType = false;
                isManBestGuess = true;
            } else {
                selectType = false;
                isManBestGuess = false;
            }
        }
        if(gstrUserId == null || gstrUserId == '' || gstrUserId == 'null'){
            PageReference pr = new PageReference('/apex/BestGuess');
            pr.setRedirect(true);
            return pr;
        } else {
            return null;
        }
        
    }
    
    //Set the section type
    public void setSectionType(){
        if(gstrSectionType == 'Manufacturer'){
            isManufacturer = true;
        } else {
            isManufacturer = false;
        }
        isGridManufacturer = isManufacturer;
    }
    
    //Set the boolean when the type is changed
    public void setIsManBestGuess(){
        if(gstrType == 'Manager'){
            isManBestGuess = true;
            gstrManufacturer = '';
            gstrRetail = '';
            showTeamMembers = true;
        } else {
            isManBestGuess = false;
            gstrManufacturer = '';
            gstrRetail = '';
            showTeamMembers = false;
        }
    }
    
    //Get the types
    public List<SelectOption> getTypes(){
        List<SelectOption> lstReturn = new List<SelectOption>();
        lstReturn.add(new SelectOption('Manager',System.Label.Manager));
        lstReturn.add(new SelectOption('Sales Rep',System.Label.Sales_Rep));
        return lstReturn;
    }
    
    //Get the selection types
    public List<SelectOption> getSectionTypes(){
        List<Profile> profiles = [SELECT ID, NAME FROM PROFILE];
        Set<Id> adminProfiles = new Set<Id>();
        Set<Id> japanProfiles = new Set<Id>();
        for (Profile p : profiles){
            if (p.Name.contains('Admin')){
                adminProfiles.add(p.Id);
            } else if (p.Name.contains('Japan')){
                japanProfiles.add(p.Id);
            }
        }
        List<SelectOption> lstReturn = new List<SelectOption>();
        if (adminProfiles.contains(UserInfo.getProfileId())){
            //lstReturn.add(new SelectOption('Manufacturer','Manufacturer'));
            //lstReturn.add(new SelectOption('Retail','Retail'));
            //edit by Warren to have options be in line with English Code
            lstReturn.add(new SelectOption('Manufacturer', system.label.manufacturer));           
            lstReturn.add(new SelectOption('Retail', system.label.retail));            
        }else if (japanProfiles.contains(UserInfo.getProfileId())){
            lstReturn.add(new SelectOption('Manufacturer', system.label.manufacturer));           
            lstReturn.add(new SelectOption('Retail', system.label.retail));
        }else{
            lstReturn.add(new SelectOption('Manufacturer','Manufacturer'));
            lstReturn.add(new SelectOption('Retail','Retail'));
        } 
        return lstReturn;
    }
    
    //Get the delivery types
    public List<SelectOption> getDeliveryTypes(){
        List<SelectOption> lstReturn = new List<SelectOption>();
        lstReturn.add(new SelectOption('Total', 'Total'));
        lstReturn.add(new SelectOption('Base', 'Base'));
        lstReturn.add(new SelectOption('Digital', 'Digital'));
        lstReturn.add(new SelectOption('Audience Network', 'Audience Network'));
        lstReturn.add(new SelectOption('Mobile', 'Mobile'));
        return lstReturn;
    }
    
    //Get all of the Owners for the Manager and Sales Rep Best Guesses the current user has access to
    public List<SelectOption> getUsers(){
        List<Manager_Best_Guess__c> lstMan = [SELECT Id, OwnerId FROM Manager_Best_Guess__c];
        List<Sales_Rep_Best_Guess__c> lstRep = [SELECT Id, OwnerId FROM Sales_Rep_Best_Guess__c];
        Set<Id> setUserIds = new Set<Id>();
        for(Manager_Best_Guess__c man : lstMan){
            setUserIds.add(man.OwnerId);
        }
        for(Sales_Rep_Best_Guess__c rep : lstRep){
            setUserIds.add(rep.OwnerId);
        }
        List<SelectOption> lstReturn = new List<SelectOption>();
        List<User> lstGetUsers = [SELECT Id, Name FROM User WHERE Id IN :setUserIds Order By Name ASC];        
        lstReturn.add(new SelectOption('null','--None--'));
        for(User use : lstGetUsers){
            lstReturn.add(new SelectOption(use.Id, use.Name));
        }
        return lstReturn;
    } 
    
    //Save the updated values in the grid
    public void saveBestGuess(){
        if(gstrSave != null){
            String[] sarrSave = gstrSave.split(':');
            if(isGridManBestGuess){
                for(Manager_Best_Guess__c mbg : gmbgList){
                    if(isGridManufacturer){
                        if(mbg.Quarter__c != null && mbg.Quarter__c.startsWith('Q1')){
                            try{mbg.Override_Team_Manu_Base_Best_Guess__c = Decimal.valueOf(sarrSave[8]);}catch(Exception e){}
                            try{mbg.Override_Team_Manu_Digital_Best_Guess__c = Decimal.valueOf(sarrSave[24]);}catch(Exception e){}
                            try{mbg.Override_Team_Manu_Audience_Best_Guess__c = Decimal.valueOf(sarrSave[40]);}catch(Exception e){}
                            try{mbg.Override_Team_Manu_Mobile_Best_Guess__c = Decimal.valueOf(sarrSave[56]);}catch(Exception e){}
                        }   
                        if(mbg.Quarter__c != null && mbg.Quarter__c.startsWith('Q2')){
                            try{mbg.Override_Team_Manu_Base_Best_Guess__c = Decimal.valueOf(sarrSave[10]);}catch(Exception e){}
                            try{mbg.Override_Team_Manu_Digital_Best_Guess__c = Decimal.valueOf(sarrSave[26]);}catch(Exception e){}
                            try{mbg.Override_Team_Manu_Audience_Best_Guess__c = Decimal.valueOf(sarrSave[42]);}catch(Exception e){}
                            try{mbg.Override_Team_Manu_Mobile_Best_Guess__c = Decimal.valueOf(sarrSave[58]);}catch(Exception e){}
                        }
                        if(mbg.Quarter__c != null && mbg.Quarter__c.startsWith('Q3')){
                            try{mbg.Override_Team_Manu_Base_Best_Guess__c = Decimal.valueOf(sarrSave[12]);}catch(Exception e){}
                            try{mbg.Override_Team_Manu_Digital_Best_Guess__c = Decimal.valueOf(sarrSave[28]);}catch(Exception e){}
                            try{mbg.Override_Team_Manu_Audience_Best_Guess__c = Decimal.valueOf(sarrSave[44]);}catch(Exception e){}
                            try{mbg.Override_Team_Manu_Mobile_Best_Guess__c = Decimal.valueOf(sarrSave[60]);}catch(Exception e){}
                        }
                        if(mbg.Quarter__c != null && mbg.Quarter__c.startsWith('Q4')){
                            try{mbg.Override_Team_Manu_Base_Best_Guess__c = Decimal.valueOf(sarrSave[14]);}catch(Exception e){}
                            try{mbg.Override_Team_Manu_Digital_Best_Guess__c = Decimal.valueOf(sarrSave[30]);}catch(Exception e){}
                            try{mbg.Override_Team_Manu_Audience_Best_Guess__c = Decimal.valueOf(sarrSave[46]);}catch(Exception e){}
                            try{mbg.Override_Team_Manu_Mobile_Best_Guess__c = Decimal.valueOf(sarrSave[62]);}catch(Exception e){}
                        }
                    } else {
                        if(mbg.Quarter__c != null && mbg.Quarter__c.startsWith('Q1')){
                            try{mbg.Override_Team_Retail_Base_Best_Guess__c = Decimal.valueOf(sarrSave[9]);}catch(Exception e){}
                            try{mbg.Override_Team_Retail_Digital_Best_Guess__c = Decimal.valueOf(sarrSave[25]);}catch(Exception e){}
                            try{mbg.Override_Team_Retail_Audience_Best_Guess__c = Decimal.valueOf(sarrSave[41]);}catch(Exception e){}
                            try{mbg.Override_Team_Retail_Mobile_Best_Guess__c = Decimal.valueOf(sarrSave[57]);}catch(Exception e){}
                        }
                        if(mbg.Quarter__c != null && mbg.Quarter__c.startsWith('Q2')){
                            try{mbg.Override_Team_Retail_Base_Best_Guess__c = Decimal.valueOf(sarrSave[11]);}catch(Exception e){}
                            try{mbg.Override_Team_Retail_Digital_Best_Guess__c = Decimal.valueOf(sarrSave[27]);}catch(Exception e){}
                            try{mbg.Override_Team_Retail_Audience_Best_Guess__c = Decimal.valueOf(sarrSave[43]);}catch(Exception e){}
                            try{mbg.Override_Team_Retail_Mobile_Best_Guess__c = Decimal.valueOf(sarrSave[59]);}catch(Exception e){}
                        }
                        if(mbg.Quarter__c != null && mbg.Quarter__c.startsWith('Q3')){
                            try{mbg.Override_Team_Retail_Base_Best_Guess__c = Decimal.valueOf(sarrSave[13]);}catch(Exception e){}
                            try{mbg.Override_Team_Retail_Digital_Best_Guess__c = Decimal.valueOf(sarrSave[29]);}catch(Exception e){}
                            try{mbg.Override_Team_Retail_Audience_Best_Guess__c = Decimal.valueOf(sarrSave[45]);}catch(Exception e){}
                            try{mbg.Override_Team_Retail_Mobile_Best_Guess__c = Decimal.valueOf(sarrSave[61]);}catch(Exception e){}
                        }
                        if(mbg.Quarter__c != null && mbg.Quarter__c.startsWith('Q4')){
                            try{mbg.Override_Team_Retail_Base_Best_Guess__c = Decimal.valueOf(sarrSave[15]);}catch(Exception e){}
                            try{mbg.Override_Team_Retail_Digital_Best_Guess__c = Decimal.valueOf(sarrSave[31]);}catch(Exception e){}
                            try{mbg.Override_Team_Retail_Audience_Best_Guess__c = Decimal.valueOf(sarrSave[47]);}catch(Exception e){}
                            try{mbg.Override_Team_Retail_Mobile_Best_Guess__c = Decimal.valueOf(sarrSave[63]);}catch(Exception e){}
                        }
                    }
                }
                update gmbgList;
            } else {
                for(Sales_Rep_Best_Guess__c sbg : gsrbgList){
                    if(isGridManufacturer){
                        if(sbg.Quarter__c != null && sbg.Quarter__c.startsWith('Q1')){
                            try{sbg.Manufacturing_Base_Best_Guess__c = Decimal.valueOf(sarrSave[0]);}catch(Exception e){}
                            try{sbg.Manufacturing_Digital_Best_Guess__c = Decimal.valueOf(sarrSave[16]);}catch(Exception e){}
                            try{sbg.Manufacturing_Audience_Best_Guess__c = Decimal.valueOf(sarrSave[32]);}catch(Exception e){}
                            try{sbg.Manufacturing_Mobile_Best_Guess__c = Decimal.valueOf(sarrSave[48]);}catch(Exception e){}
                        }
                        if(sbg.Quarter__c != null && sbg.Quarter__c.startsWith('Q2')){
                            try{sbg.Manufacturing_Base_Best_Guess__c = Decimal.valueOf(sarrSave[2]);}catch(Exception e){}
                            try{sbg.Manufacturing_Digital_Best_Guess__c = Decimal.valueOf(sarrSave[18]);}catch(Exception e){}
                            try{sbg.Manufacturing_Audience_Best_Guess__c = Decimal.valueOf(sarrSave[34]);}catch(Exception e){}
                            try{sbg.Manufacturing_Mobile_Best_Guess__c = Decimal.valueOf(sarrSave[50]);}catch(Exception e){}
                        }
                        if(sbg.Quarter__c != null && sbg.Quarter__c.startsWith('Q3')){
                            try{sbg.Manufacturing_Base_Best_Guess__c = Decimal.valueOf(sarrSave[4]);}catch(Exception e){}
                            try{sbg.Manufacturing_Digital_Best_Guess__c = Decimal.valueOf(sarrSave[20]);}catch(Exception e){}
                            try{sbg.Manufacturing_Audience_Best_Guess__c = Decimal.valueOf(sarrSave[36]);}catch(Exception e){}
                            try{sbg.Manufacturing_Mobile_Best_Guess__c = Decimal.valueOf(sarrSave[52]);}catch(Exception e){}
                        }
                        if(sbg.Quarter__c != null && sbg.Quarter__c.startsWith('Q4')){
                            try{sbg.Manufacturing_Base_Best_Guess__c = Decimal.valueOf(sarrSave[6]);}catch(Exception e){}
                            try{sbg.Manufacturing_Digital_Best_Guess__c = Decimal.valueOf(sarrSave[22]);}catch(Exception e){}
                            try{sbg.Manufacturing_Audience_Best_Guess__c = Decimal.valueOf(sarrSave[38]);}catch(Exception e){}
                            try{sbg.Manufacturing_Mobile_Best_Guess__c = Decimal.valueOf(sarrSave[54]);}catch(Exception e){}
                        }
                    } else {
                        if(sbg.Quarter__c != null && sbg.Quarter__c.startsWith('Q1')){
                            try{sbg.Retail_Base_Best_Guess__c = Decimal.valueOf(sarrSave[1]);}catch(Exception e){}
                            try{sbg.Retail_Digital_Best_Guess__c = Decimal.valueOf(sarrSave[17]);}catch(Exception e){}
                            try{sbg.Retail_Audience_Best_Guess__c = Decimal.valueOf(sarrSave[33]);}catch(Exception e){}
                            try{sbg.Retail_Mobile_Best_Guess__c = Decimal.valueOf(sarrSave[49]);}catch(Exception e){}
                        }
                        if(sbg.Quarter__c != null && sbg.Quarter__c.startsWith('Q2')){
                            try{sbg.Retail_Base_Best_Guess__c = Decimal.valueOf(sarrSave[3]);}catch(Exception e){}
                            try{sbg.Retail_Digital_Best_Guess__c = Decimal.valueOf(sarrSave[19]);}catch(Exception e){}
                            try{sbg.Retail_Audience_Best_Guess__c = Decimal.valueOf(sarrSave[35]);}catch(Exception e){}
                            try{sbg.Retail_Mobile_Best_Guess__c = Decimal.valueOf(sarrSave[51]);}catch(Exception e){}
                        }
                        if(sbg.Quarter__c != null && sbg.Quarter__c.startsWith('Q3')){
                            try{sbg.Retail_Base_Best_Guess__c = Decimal.valueOf(sarrSave[5]);}catch(Exception e){}
                            try{sbg.Retail_Digital_Best_Guess__c = Decimal.valueOf(sarrSave[21]);}catch(Exception e){}
                            try{sbg.Retail_Audience_Best_Guess__c = Decimal.valueOf(sarrSave[37]);}catch(Exception e){}
                            try{sbg.Retail_Mobile_Best_Guess__c = Decimal.valueOf(sarrSave[53]);}catch(Exception e){}
                        }
                        if(sbg.Quarter__c != null && sbg.Quarter__c.startsWith('Q4')){
                            try{sbg.Retail_Base_Best_Guess__c = Decimal.valueOf(sarrSave[7]);}catch(Exception e){}
                            try{sbg.Retail_Digital_Best_Guess__c = Decimal.valueOf(sarrSave[23]);}catch(Exception e){}
                            try{sbg.Retail_Audience_Best_Guess__c = Decimal.valueOf(sarrSave[39]);}catch(Exception e){}
                            try{sbg.Retail_Mobile_Best_Guess__c = Decimal.valueOf(sarrSave[55]);}catch(Exception e){}
                        }
                    }
                }
                update gsrbgList;
            }
            reloadData();
            setBestGuessRecord();
        }
    }
    
    //Reset the search fields
    public void resetSearch(){
        gsrbgUserHolder = new Sales_Rep_Best_Guess__c();
        gstrUserId = 'null';
        gstrGuessId = String.valueOf(currentYear);
        selectType = false;
        hideTable = true;
    }
    
    //displays the previous, current and next year
    public List<SelectOption> getYears(){
        List<SelectOption> lstReturn = new List<SelectOption>();
        lstReturn.add(new SelectOption(String.valueOf(currentYear-1), String.valueOf(currentYear-1)));
        lstReturn.add(new SelectOption(String.valueOf(currentYear), String.valueOf(currentYear)));
        lstReturn.add(new SelectOption(String.valueOf(currentYear+1), String.valueOf(currentYear+1)));
        lstReturn.add(new SelectOption(String.valueOf(currentYear+2), String.valueOf(currentYear+2)));
        return lstReturn;
    }
    
    //Reload the data after a save, without factoring in the search criteria
    public void reloadData(){
        //Set the data strings based on the id
        if(isManBestGuess){
           createDataStringsFromManagerGuess();
        } else {
            createDataStringsFromRepGuess();
        } 
    }
    
    //Set the best guess record to use
    public void setBestGuessRecord(){
        selDeliveryChannel='Total';
        q1Edit = False;
        q2Edit = False;
        q3Edit = False;
        q4Edit = False;
        team_Previous_Year_Actual=0;
        total_L=0;
        override_Total_L=0;
        total_BG=0;
        override_Total_BG=0;
        total_H=0;
        override_Total_H=0;     
        bestGuessList.clear();
        lstUserIds.clear();
        resetTotal();
        deliveryType = 'Total';
        gmbgList = new List<Manager_Best_Guess__c>();
        gsrbgList = new List<Sales_Rep_Best_Guess__c>();
        //Set the data strings based on the id
        if(isManBestGuess){
            List<Schema.SObjectField> lstManFields = getFields('Manager_Best_Guess__c');
            strManFields = '';
            for(Integer i = 0; i < lstManFields.size(); i++){
                if(i == lstManFields.size() - 1){
                    strManFields += lstManFields.get(i).getDescribe().LocalName;
                } else {
                    strManFields += lstManFields.get(i).getDescribe().LocalName + ',';
                }
            } 
            String strManQuery = 'Select ' + strManFields + ' FROM Manager_Best_Guess__c WHERE OwnerId=\''+gstrUserId+'\' AND Year__c=\''+gstrGuessId+'\'';
            gmbgList = Database.query(strManQuery);
            searchRevenue();
            for(Manager_Best_Guess__c m : gmbgList){
                if(m.Team_Previous_Year_Actual__c!=null)team_Previous_Year_Actual+=m.Team_Previous_Year_Actual__c;
                if(isGridManufacturer){
                    if(m.Override_Team_Manu_Base_Best_Guess__c != null)override_Total_BG+=m.Override_Team_Manu_Base_Best_Guess__c;
                    if(m.Override_Team_Manu_Digital_Best_Guess__c != null)override_Total_BG+=m.Override_Team_Manu_Digital_Best_Guess__c;
                    if(m.Override_Team_Manu_Audience_Best_Guess__c != null)override_Total_BG+=m.Override_Team_Manu_Audience_Best_Guess__c;
                    if(m.Override_Team_Manu_Mobile_Best_Guess__c != null)override_Total_BG+=m.Override_Team_Manu_Mobile_Best_Guess__c;
                    
                    if(m.Team_Mfg_Mobile_High_Formula__c != null)override_Total_H+=m.Team_Mfg_Mobile_High_Formula__c;
                    if(m.Team_Mfg_Base_High_Formula__c != null)override_Total_H+=m.Team_Mfg_Base_High_Formula__c;
                    if(m.Team_Mfg_Digital_High_Formula__c != null)override_Total_H+=m.Team_Mfg_Digital_High_Formula__c;
                    if(m.Team_Mfg_Audience_High_Formula__c != null)override_Total_H+=m.Team_Mfg_Audience_High_Formula__c;
                    
                    if(m.Team_Mfg_Mobile_Low_Formula__c != null)override_Total_L+=m.Team_Mfg_Mobile_Low_Formula__c;
                    if(m.Team_Mfg_Base_Low_Formula__c != null)override_Total_L+=m.Team_Mfg_Base_Low_Formula__c;
                    if(m.Team_Mfg_Digital_Low_Formula__c != null)override_Total_L+=m.Team_Mfg_Digital_Low_Formula__c;
                    if(m.Team_Mfg_Audience_Low_Formula__c != null)override_Total_L+=m.Team_Mfg_Audience_Low_Formula__c;
                    
                    if(m.Team_Manufacturing_Base_Best_Guess__c != null)total_BG+=m.Team_Manufacturing_Base_Best_Guess__c;
                    if(m.Team_Manufacturing_Digital_Best_Guess__c != null)total_BG+=m.Team_Manufacturing_Digital_Best_Guess__c;
                    if(m.Team_Manufacturing_Audience_Best_Guess__c != null)total_BG+=m.Team_Manufacturing_Audience_Best_Guess__c;
                    if(m.Team_Manufacturing_Mobile_Best_Guess__c != null)total_BG+=m.Team_Manufacturing_Mobile_Best_Guess__c;
                    
                    if(m.Team_Manufacturing_Base_High__c != null)total_H+=m.Team_Manufacturing_Base_High__c;
                    if(m.Team_Manufacturing_Digital_High__c != null)total_H+=m.Team_Manufacturing_Digital_High__c;
                    if(m.Team_Manufacturing_Audience_High__c != null)total_H+=m.Team_Manufacturing_Audience_High__c;
                    if(m.Team_Manufacturing_Mobile_High__c != null)total_H+=m.Team_Manufacturing_Mobile_High__c;
                    
                    if(m.Team_Manufacturing_Base_Low__c != null)total_L+=m.Team_Manufacturing_Base_Low__c;
                    if(m.Team_Manufacturing_Digital_Low__c != null)total_L+=m.Team_Manufacturing_Digital_Low__c;
                    if(m.Team_Manufacturing_Audience_Low__c != null)total_L+=m.Team_Manufacturing_Audience_Low__c;
                    if(m.Team_Manufacturing_Mobile_Low__c != null)total_L+=m.Team_Manufacturing_Mobile_Low__c;                
                } else {
                    if(m.Override_Team_Retail_Base_Best_Guess__c != null)override_Total_BG+=m.Override_Team_Retail_Base_Best_Guess__c;
                    if(m.Override_Team_Retail_Digital_Best_Guess__c != null)override_Total_BG+=m.Override_Team_Retail_Digital_Best_Guess__c;
                    if(m.Override_Team_Retail_Audience_Best_Guess__c != null)override_Total_BG+=m.Override_Team_Retail_Audience_Best_Guess__c;
                    if(m.Override_Team_Retail_Mobile_Best_Guess__c != null)override_Total_BG+=m.Override_Team_Retail_Mobile_Best_Guess__c;
                    
                    if(m.Team_Retail_Mobile_High_Formula__c != null)override_Total_H+=m.Team_Retail_Mobile_High_Formula__c;
                    if(m.Team_Retail_Base_High_Formula__c != null)override_Total_H+=m.Team_Retail_Base_High_Formula__c;
                    if(m.Team_Retail_Digital_High_Formula__c != null)override_Total_H+=m.Team_Retail_Digital_High_Formula__c;
                    if(m.Team_Retail_Audience_High_Formula__c != null)override_Total_H+=m.Team_Retail_Audience_High_Formula__c;
                    
                    if(m.Team_Retail_Mobile_Low_Formula__c != null)override_Total_L+=m.Team_Retail_Mobile_Low_Formula__c;
                    if(m.Team_Retail_Base_Low_Formula__c != null)override_Total_L+=m.Team_Retail_Base_Low_Formula__c;
                    if(m.Team_Retail_Digital_Low_Formula__c != null)override_Total_L+=m.Team_Retail_Digital_Low_Formula__c;
                    if(m.Team_Retail_Audience_Low_Formula__c != null)override_Total_L+=m.Team_Retail_Audience_Low_Formula__c;
                    
                    if(m.Team_Retail_Base_Best_Guess__c != null)total_BG+=m.Team_Retail_Base_Best_Guess__c;
                    if(m.Team_Retail_Digital_Best_Guess__c != null)total_BG+=m.Team_Retail_Digital_Best_Guess__c;
                    if(m.Team_Retail_Audience_Best_Guess__c != null)total_BG+=m.Team_Retail_Audience_Best_Guess__c;
                    if(m.Team_Retail_Mobile_Best_Guess__c != null)total_BG+=m.Team_Retail_Mobile_Best_Guess__c;
                    
                    if(m.Team_Retail_Base_High__c != null)total_H+=m.Team_Retail_Base_High__c;
                    if(m.Team_Retail_Digital_High__c != null)total_H+=m.Team_Retail_Digital_High__c;
                    if(m.Team_Retail_Audience_High__c != null)total_H+=m.Team_Retail_Audience_High__c;
                    if(m.Team_Retail_Mobile_High__c != null)total_H+=m.Team_Retail_Mobile_High__c;
                    
                    if(m.Team_Retail_Base_Low__c != null)total_L+=m.Team_Retail_Base_Low__c;
                    if(m.Team_Retail_Digital_Low__c != null)total_L+=m.Team_Retail_Digital_Low__c;
                    if(m.Team_Retail_Audience_Low__c != null)total_L+=m.Team_Retail_Audience_Low__c;
                    if(m.Team_Retail_Mobile_Low__c != null)total_L+=m.Team_Retail_Mobile_Low__c;
                }
            }
            isGridManufacturer = isManufacturer;
            isGridManBestGuess = true;
            hideTable = false;
            showHistorical = true;
            createDataStringsFromManagerGuess();
            //populate TeamMemberList
            Map<User, Id> mapTeamMember = new Map<User, Id>();
            Set<Id> setTeamMemberId = new Set<Id>(); //Team Members for given Manager
            Set<Id> setUserIds = new Set<Id>(); //All users with Best Guess
            List<Manager_Best_Guess__c> lstMan = [SELECT Id, OwnerId FROM Manager_Best_Guess__c];
            List<Sales_Rep_Best_Guess__c> lstRep = [SELECT Id, OwnerId FROM Sales_Rep_Best_Guess__c];
            for(Manager_Best_Guess__c man : lstMan){
                setUserIds.add(man.OwnerId);
            }
            for(Sales_Rep_Best_Guess__c rep : lstRep){
                setUserIds.add(rep.OwnerId);
            }
            if(gstrUserId != null){
                setTeamMemberId.add(gstrUserId);
            }
            List<User> lstTeamMember = [select Id, managerId from User where isActive = true];// where managerId =: gstrUserId];
            for(User u : lstTeamMember){
                mapTeamMember.put(u, u.Id);
            }
            //Adds users belonging to current user's team
            for(User u : lstTeamMember){        
                if(u.managerId == gstrUserId){
                    setTeamMemberId.add(mapTeamMember.get(u));
                }
            }
            List<SelectOption> lstReturn = new List<SelectOption>();
            List<User> lstUsers = [SELECT Id, Name, Does_Sell__c
                                           FROM User  
                                           WHERE Id IN :setUserIds AND Id IN :setTeamMemberId  
                                           Order By Name ASC 
                                           LIMIT 999];
            for(User use : lstUsers){
                lstUserIds.add(use.Id);
            }
            //Show all teammembers
            setTableForManager();
        } else {
            HBGBatchInterval__c hbgSetting = HBGBatchInterval__c.getInstance('LastDate');
            String tDate = String.valueOf(hbgSetting.Last_Run_Date__c);
            tDate = tDate.substring(0,10);
            List<Schema.SObjectField> lstRepFields = getFields('Sales_Rep_Best_Guess__c');
            strRepFields = '';
            for(Integer i = 0; i < lstRepFields.size(); i++){
                if(i == lstRepFields.size() - 1){
                    strRepFields += lstRepFields.get(i).getDescribe().LocalName;
                } else {
                    strRepFields += lstRepFields.get(i).getDescribe().LocalName + ',';
                }
            }
            String strRepQuery = 'Select ' + strRepFields + ' FROM Sales_Rep_Best_Guess__c WHERE OwnerId=\''+gstrUserId+'\' AND Year__c=\''+gstrGuessId+'\'';
            gsrbgList = Database.query(strRepQuery);
            searchRevenue();
            for(Sales_Rep_Best_Guess__c s : gsrbgList){
                if(s.Previous_Year_Actual__c!=null)team_Previous_Year_Actual+=s.Previous_Year_Actual__c;
                if(isGridManufacturer){
                    if(s.Manufacturing_Base_Best_Guess__c != null)total_BG+=s.Manufacturing_Base_Best_Guess__c;
                    if(s.Manufacturing_Digital_Best_Guess__c != null)total_BG+=s.Manufacturing_Digital_Best_Guess__c;
                    if(s.Manufacturing_Audience_Best_Guess__c != null)total_BG+=s.Manufacturing_Audience_Best_Guess__c;
                    if(s.Manufacturing_Mobile_Best_Guess__c != null)total_BG+=s.Manufacturing_Mobile_Best_Guess__c;
                    
                    if(s.Mfg_Mobile_High_Formula__c != null)total_H+=s.Mfg_Mobile_High_Formula__c;
                    if(s.Mfg_Base_High_Formula__c != null)total_H+=s.Mfg_Base_High_Formula__c;
                    if(s.Mfg_Digital_High_Formula__c != null)total_H+=s.Mfg_Digital_High_Formula__c;
                    if(s.Mfg_Audience_High_Formula__c != null)total_H+=s.Mfg_Audience_High_Formula__c;
                    
                    if(s.Mfg_Mobile_Low_Formula__c != null)total_L+=s.Mfg_Mobile_Low_Formula__c;
                    if(s.Mfg_Base_Low_Formula__c != null)total_L+=s.Mfg_Base_Low_Formula__c;
                    if(s.Mfg_Digital_Low_Formula__c != null)total_L+=s.Mfg_Digital_Low_Formula__c;
                    if(s.Mfg_Audience_Low_Formula__c != null)total_L+=s.Mfg_Audience_Low_Formula__c;
                } else {
                    if(s.Retail_Base_Best_Guess__c != null)total_BG+=s.Retail_Base_Best_Guess__c;
                    if(s.Retail_Digital_Best_Guess__c != null)total_BG+=s.Retail_Digital_Best_Guess__c;
                    if(s.Retail_Audience_Best_Guess__c != null)total_BG+=s.Retail_Audience_Best_Guess__c;
                    if(s.Retail_Mobile_Best_Guess__c != null)total_BG+=s.Retail_Mobile_Best_Guess__c;
                    
                    if(s.Retail_Mobile_High_Formula__c != null)total_H+=s.Retail_Mobile_High_Formula__c;
                    if(s.Retail_Base_High_Formula__c != null)total_H+=s.Retail_Base_High_Formula__c;
                    if(s.Retail_Digital_High_Formula__c != null)total_H+=s.Retail_Digital_High_Formula__c;
                    if(s.Retail_Audience_High_Formula__c != null)total_H+=s.Retail_Audience_High_Formula__c;
                    
                    if(s.Retail_Mobile_Low_Formula__c != null)total_L+=s.Retail_Mobile_Low_Formula__c;
                    if(s.Retail_Base_Low_Formula__c != null)total_L+=s.Retail_Base_Low_Formula__c;
                    if(s.Retail_Digital_Low_Formula__c != null)total_L+=s.Retail_Digital_Low_Formula__c;
                    if(s.Retail_Audience_Low_Formula__c != null)total_L+=s.Retail_Audience_Low_Formula__c;
                }
            }
            isGridManufacturer = isManufacturer;
            isGridManBestGuess = false;
            hideTable = false;
            showHistorical = true;
            createDataStringsFromRepGuess();           
            String strHistRepQuery = 'Select Archive_Date__c, ' + strRepFields + ' FROM Historical_Sales_Rep_Best_Guess__c WHERE OwnerId = \'' + gstrUserId 
                                     + '\' AND Year__c = \'' + gstrGuessId + '\'' + ' AND Archive_Date__C = ' + tDate + ' ORDER BY CREATEDDATE DESC LIMIT 4';     
            List<Historical_Sales_Rep_Best_Guess__c> query1 = Database.query(strHistRepQuery);
            Map<String,Historical_Sales_Rep_Best_Guess__c> histMap = new Map<String,Historical_Sales_Rep_Best_Guess__c>();
            for(Historical_Sales_Rep_Best_Guess__c h : query1){
                histMap.put(h.Name,h);
            }
            List<Historical_Sales_Rep_Best_Guess__c> insertHist = new List<Historical_Sales_Rep_Best_Guess__c>();
            if (query1.size() != 4){
                for(Sales_Rep_Best_Guess__c gsrbg : gsrbgList){
                    if(!histMap.containsKey(gsrbg.Name)){
                        Historical_Sales_Rep_Best_Guess__c hsbg = new Historical_Sales_Rep_Best_Guess__c();
                        hsbg.Archive_Date__c = Date.valueOf(tDate);
                        hsbg.Name = gsrbg.Name;
                        hsbg.Actual_Amount__c = gsrbg.Actual_Amount__c;
                        hsbg.OwnerId = gsrbg.OwnerId;
                        hsbg.Booked_Actual__c = gsrbg.Booked_Actual__c;
                        hsbg.Booked_Full_Proposal__c = gsrbg.Booked_Full_Proposal__c;
                        hsbg.Booked_Proposal__c = gsrbg.Booked_Proposal__c;
                        hsbg.Comments__c = gsrbg.Comments__c;
                        hsbg.Forecast_Contract__c = gsrbg.Forecast_Contract__c;
                        hsbg.Forecast_Proposal__c = gsrbg.Forecast_Proposal__c;
                        hsbg.Is_Manager__c = gsrbg.Is_Manager__c;
                        hsbg.IsMyTeam__c = gsrbg.IsMyTeam__c;
                        hsbg.Last_Entered_Date__c = gsrbg.Last_Entered_Date__c;
                        hsbg.Last_Entered_User__c = gsrbg.Last_Entered_User__c;
                        hsbg.M_A_Actual_Amount__c = gsrbg.M_A_Actual_Amount__c;
                        hsbg.M_A_Forecast_Contract__c = gsrbg.M_A_Forecast_Contract__c;
                        hsbg.M_A_Forecast_Proposal__c = gsrbg.M_A_Forecast_Proposal__c;
                        hsbg.Manager__c = gsrbg.Manager__c;
                        hsbg.Manager_1__c = gsrbg.Manager_1__c;
                        hsbg.Manager_2__c = gsrbg.Manager_2__c;
                        hsbg.Manager_3__c = gsrbg.Manager_3__c;
                        hsbg.Manager_Best_Guess__c = gsrbg.Manager_Best_Guess__c;
                        hsbg.M_A_Weighted_Forecast_Proposal__c = gsrbg.M_A_Weighted_Forecast_Proposal__c;
                        hsbg.M_B_Actual_Amount__c = gsrbg.M_B_Actual_Amount__c;
                        hsbg.M_B_Forecast_Contract__c = gsrbg.M_B_Forecast_Contract__c;
                        hsbg.M_B_Forecast_Proposal__c = gsrbg.M_B_Forecast_Proposal__c;
                        hsbg.M_B_Weighted_Forecast_Proposal__c = gsrbg.M_B_Weighted_Forecast_Proposal__c;
                        hsbg.M_D_Actual_Amount__c = gsrbg.M_D_Actual_Amount__c;
                        hsbg.M_D_Forecast_Contract__c = gsrbg.M_D_Forecast_Contract__c;
                        hsbg.M_D_Forecast_Proposal__c = gsrbg.M_D_Forecast_Proposal__c;
                        hsbg.M_D_Weighted_Forecast_Proposal__c = gsrbg.M_D_Weighted_Forecast_Proposal__c;
                        hsbg.Manufacturing_Audience_Best_Guess__c = gsrbg.Manufacturing_Audience_Best_Guess__c;
                        hsbg.M_A_Booked_Full_Proposal__c = gsrbg.M_A_Booked_Full_Proposal__c;
                        hsbg.M_A_Booked_Proposal__c = gsrbg.M_A_Booked_Proposal__c;
                        hsbg.M_A_Booked_Actual__c = gsrbg.M_A_Booked_Actual__c;
                        hsbg.Manufacturing_Audience_High__c = gsrbg.Manufacturing_Audience_High__c;
                        hsbg.Manufacturing_Audience_Low__c = gsrbg.Manufacturing_Audience_Low__c;
                        hsbg.Manufacturing_Base_Best_Guess__c = gsrbg.Manufacturing_Base_Best_Guess__c;
                        hsbg.M_B_Booked_Full_Proposal__c = gsrbg.M_B_Booked_Full_Proposal__c;
                        hsbg.M_B_Booked_Proposal__c = gsrbg.M_B_Booked_Proposal__c;
                        hsbg.M_B_Booked_Actual__c = gsrbg.M_B_Booked_Actual__c;
                        hsbg.Manufacturing_Base_High__c = gsrbg.Manufacturing_Base_High__c;
                        hsbg.Manufacturing_Base_Low__c = gsrbg.Manufacturing_Base_Low__c;
                        hsbg.Manufacturing_Digital_Best_Guess__c = gsrbg.Manufacturing_Digital_Best_Guess__c;
                        hsbg.M_D_Booked_Full_Proposal__c = gsrbg.M_D_Booked_Full_Proposal__c;
                        hsbg.M_D_Booked_Proposal__c = gsrbg.M_D_Booked_Proposal__c;
                        hsbg.M_D_Booked_Actual__c = gsrbg.M_D_Booked_Actual__c;
                        hsbg.Manufacturing_Digital_High__c = gsrbg.Manufacturing_Digital_High__c;
                        hsbg.Manufacturing_Digital_Low__c = gsrbg.Manufacturing_Digital_Low__c;
                        hsbg.Manufacturing_Mobile_Best_Guess__c = gsrbg.Manufacturing_Mobile_Best_Guess__c;
                        hsbg.M_M_Booked_Full_Proposal__c = gsrbg.M_M_Booked_Full_Proposal__c;
                        hsbg.M_M_Booked_Proposal__c = gsrbg.M_M_Booked_Proposal__c;
                        hsbg.M_M_Booked_Actual__c = gsrbg.M_M_Booked_Actual__c;
                        hsbg.Manufacturing_Mobile_High__c = gsrbg.Manufacturing_Mobile_High__c;
                        hsbg.Manufacturing_Mobile_Low__c = gsrbg.Manufacturing_Mobile_Low__c;
                        hsbg.M_M_Actual_Amount__c = gsrbg.M_M_Actual_Amount__c;
                        hsbg.M_M_Forecast_Contract__c = gsrbg.M_M_Forecast_Contract__c;
                        hsbg.M_M_Forecast_Proposal__c = gsrbg.M_M_Forecast_Proposal__c;
                        hsbg.M_M_Weighted_Forecast_Proposal__c = gsrbg.M_M_Weighted_Forecast_Proposal__c;
                        hsbg.Previous_Year_Actual__c = gsrbg.Previous_Year_Actual__c;
                        hsbg.Quarter__c = gsrbg.Quarter__c;
                        hsbg.Quarter_End_Date__c = gsrbg.Quarter_End_Date__c;
                        hsbg.Quarter_Start_Date__c = gsrbg.Quarter_Start_Date__c;
                        hsbg.Quota__c = gsrbg.Quota__c;
                        hsbg.R_A_Actual_Amount__c = gsrbg.R_A_Actual_Amount__c;
                        hsbg.R_A_Forecast_Contract__c = gsrbg.R_A_Forecast_Contract__c;
                        hsbg.R_A_Forecast_Proposal__c = gsrbg.R_A_Forecast_Proposal__c;
                        hsbg.R_A_Weighted_Forecast_Proposal__c = gsrbg.R_A_Weighted_Forecast_Proposal__c;
                        hsbg.R_B_Actual_Amount__c = gsrbg.R_B_Actual_Amount__c;
                        hsbg.R_B_Forecast_Contract__c = gsrbg.R_B_Forecast_Contract__c;
                        hsbg.R_B_Forecast_Proposal__c = gsrbg.R_B_Forecast_Proposal__c;
                        hsbg.R_B_Weighted_Forecast_Proposal__c = gsrbg.R_B_Weighted_Forecast_Proposal__c;
                        hsbg.R_D_Actual_Amount__c = gsrbg.R_D_Actual_Amount__c;
                        hsbg.R_D_Forecast_Contract__c = gsrbg.R_D_Forecast_Contract__c;
                        hsbg.R_D_Forecast_Proposal__c = gsrbg.R_D_Forecast_Proposal__c;
                        hsbg.R_D_Weighted_Forecast_Proposal__c = gsrbg.R_D_Weighted_Forecast_Proposal__c;
                        hsbg.Retail_Audience_Best_Guess__c = gsrbg.Retail_Audience_Best_Guess__c;
                        hsbg.R_A_Booked_Proposal__c = gsrbg.R_A_Booked_Proposal__c;
                        hsbg.R_A_Booked_Actual__c = gsrbg.R_A_Booked_Actual__c;
                        hsbg.Retail_Audience_High__c = gsrbg.Retail_Audience_High__c;
                        hsbg.Retail_Audience_Low__c = gsrbg.Retail_Audience_Low__c;
                        hsbg.Retail_Base_Best_Guess__c = gsrbg.Retail_Base_Best_Guess__c;
                        hsbg.R_B_Booked_Full_Proposal__c = gsrbg.R_B_Booked_Full_Proposal__c;
                        hsbg.R_B_Booked_Proposal__c = gsrbg.R_B_Booked_Proposal__c;
                        hsbg.R_B_Booked_Actual__c = gsrbg.R_B_Booked_Actual__c;
                        hsbg.Retail_Base_High__c = gsrbg.Retail_Base_High__c;
                        hsbg.Retail_Base_Low__c = gsrbg.Retail_Base_Low__c;
                        hsbg.Retail_Digital_Best_Guess__c = gsrbg.Retail_Digital_Best_Guess__c;
                        hsbg.R_D_Booked_Proposal__c = gsrbg.R_D_Booked_Proposal__c;
                        hsbg.R_D_Booked_Actual__c = gsrbg.R_D_Booked_Actual__c;
                        hsbg.Retail_Digital_High__c = gsrbg.Retail_Digital_High__c;
                        hsbg.Retail_Digital_Low__c = gsrbg.Retail_Digital_Low__c;
                        hsbg.Retail_Mobile_Best_Guess__c = gsrbg.Retail_Mobile_Best_Guess__c;
                        hsbg.R_M_Booked_Full_Proposal__c = gsrbg.R_M_Booked_Full_Proposal__c;
                        hsbg.R_M_Booked_Proposal__c = gsrbg.R_M_Booked_Proposal__c;
                        hsbg.R_M_Booked_Actual__c = gsrbg.R_M_Booked_Actual__c;
                        hsbg.Retail_Mobile_High__c = gsrbg.Retail_Mobile_High__c;
                        hsbg.Retail_Mobile_Low__c = gsrbg.Retail_Mobile_Low__c;
                        hsbg.R_M_Actual_Amount__c = gsrbg.R_M_Actual_Amount__c;
                        hsbg.R_M_Forecast_Contract__c = gsrbg.R_M_Forecast_Contract__c;
                        hsbg.R_M_Forecast_Proposal__c = gsrbg.R_M_Forecast_Proposal__c;
                        hsbg.R_M_Weighted_Forecast_Proposal__c = gsrbg.R_M_Weighted_Forecast_Proposal__c;
                        hsbg.R_A_Booked_Full_Proposal__c = gsrbg.R_A_Booked_Full_Proposal__c;
                        hsbg.R_D_Booked_Full_Proposal__c = gsrbg.R_D_Booked_Full_Proposal__c;
                        hsbg.Total_BG__c = gsrbg.Total_BG__c;
                        hsbg.Total_H__c = gsrbg.Total_H__c;
                        hsbg.Total_L__c = gsrbg.Total_L__c;
                        hsbg.Weighted_Forecast_Proposal__c = gsrbg.Weighted_Forecast_Proposal__c;
                        hsbg.Year__c = gsrbg.Year__c;
                        insertHist.add(hsbg);
                    }               
                }
                try{
                    if(insertHist.size()>0){
                        insert insertHist;
                    }
                } catch (Exception e){}
                for(Historical_Sales_Rep_Best_Guess__c h : insertHist){
                    histMap.put(h.Name,h);
                }
            }
            User tempUser = [Select Id, Name From User where Id = :gstrUserId limit 1];             
            bestGuessRow bgr = new bestGuessRow();              
            bgr.name = tempUser.Name; 
            bgr.bestGuess = 0; 
            bgr.bookedAmount = 0;  
            bgr.histBestGuess = 0;
            bgr.histBookedAmount = 0; 
            bgr.teamSRBGList = new List<Sales_Rep_Best_Guess__c>();
            bgr.histSRBGList = new List<Historical_Sales_Rep_Best_Guess__c>();
            bgr.teamSRBGList = gsrbgList;
            bgr.histSRBGList = histMap.values();          
            for(Sales_Rep_Best_Guess__c s : gsrbgList){
                if(s.Total_BG__c!=null){
                    bgr.bestGuess += s.Total_BG__c;
                }
                if(s.Booked_Actual__c!=null){
                    bgr.bookedAmount += s.Booked_Actual__c;
                }
            }
            for(Historical_Sales_Rep_Best_Guess__c h : histMap.values()){
                if(h.Total_BG__c!=null){
                    bgr.histBestGuess += h.Total_BG__c;
                }
                if(h.Booked_Actual__c!=null){
                    bgr.histBookedAmount += h.Booked_Actual__c;
                }
            }
            bgr.BGDifference = bgr.bestGuess - bgr.histBestGuess;
            bgr.bookedDifference = bgr.bookedAmount - bgr.histBookedAmount;
            bestGuessList.add(bgr);
            showTeamMembers = false;
            teamMemberIsMan = false;
        }  
        //Set the team member default
        gstrTeamMemberId = 'All' + gstrUserId;
    }
    
    //Set the most recent best guesses
    public void setInitialGuessRecord(){
        //Query for all of the fields
        List<Schema.SObjectField> lstManFields = getFields('Manager_Best_Guess__c');
        List<Schema.SObjectField> lstRepFields = getFields('Sales_Rep_Best_Guess__c');
        strManFields = '';
        for(Integer i = 0; i < lstManFields.size(); i++){
            if(i == lstManFields.size() - 1){
                strManFields += lstManFields.get(i).getDescribe().LocalName;
            } else {
                strManFields += lstManFields.get(i).getDescribe().LocalName + ',';
            }
        }
        strRepFields = '';
        for(Integer i = 0; i < lstRepFields.size(); i++){
            if(i == lstRepFields.size() - 1){
                strRepFields += lstRepFields.get(i).getDescribe().LocalName;
            } else {
                strRepFields += lstRepFields.get(i).getDescribe().LocalName + ',';
            }
        }
        String strManQuery = 'Select ' + strManFields + ' FROM Manager_Best_Guess__c WHERE OwnerId = \'' + UserInfo.getUserId() + '\' AND Year__c = \'' + gstrGuessId + '\'' +' Order By Quarter_Start_Date__c DESC';
        String strRepQuery = 'Select ' + strRepFields + ' FROM Sales_Rep_Best_Guess__c WHERE OwnerId = \'' + UserInfo.getUserId() + '\' AND Year__c = \'' + gstrGuessId + '\'' +' Order By Quarter_Start_Date__c DESC';
        List<Manager_Best_Guess__c> lstMan = Database.query(strManQuery);
        List<Sales_Rep_Best_Guess__c> lstRep = Database.query(strRepQuery);
        if(lstMan.size() > 0){
            gmbgList = lstMan;
            isManBestGuess = true;
            isGridManBestGuess = true;
            createDataStringsFromManagerGuess();
        }
        if(lstRep.size() > 0){
            gsrbgList = lstRep;
            isManBestGuess = false;
            isGridManBestGuess = false;
            createDataStringsFromRepGuess(); 
        }
        if(gmbgList.size() > 0 && gsrbgList.size() > 0){
            isManBestGuess = true;
            isGridManBestGuess = true;
            createDataStringsFromManagerGuess(); 
            selectType = true;
        }
    }
    
    //Returns the list of fields for a given object
    public static List<Schema.SObjectField> getFields(String strSObjectName) {
        SObjectType sot = Schema.getGlobalDescribe().get(strSObjectName);
        if (sot == null) return null;   
        List<Schema.SObjectField> fields = sot.getDescribe().fields.getMap().values();
        return fields;
    }

    public Boolean getShowTableMan() {   
        return isGridManufacturer &&!hideTable;
    }
    
    public Boolean getShowTableRetail() {    
        return !isGridManufacturer;
    }
    
    //method to display team member
    public void setTypeTeam(){
        bestGuessList.clear();
        if(gstrTeamMemberId.substring(0, 3) == 'All'){
            setTableForManager();    
        } else {
            resetTotal();
            bestGuessRow bgr = new bestGuessRow();
            bgr.bestGuess = 0;
            bgr.histBestGuess = 0;
            bgr.bookedAmount = 0;
            bgr.histBookedAmount = 0;
            //Set up Historical Best Guess for given user and quarter
            if(gstrGuessId != null && gstrGuessId != ''){
                HBGBatchInterval__c hbgSetting = HBGBatchInterval__c.getInstance('LastDate');    
                String tDate = String.valueOf(hbgSetting.Last_Run_Date__c);
                tDate = tDate.substring(0,10);                
                Map<Id, User> mapBestGuessUser = new Map<Id, User>([Select Id, Name From User where Id IN :lstUserIds]);
                bgr.name = mapBestGuessUser.get(gstrTeamMemberId).Name;
                String strManQuery = 'Select ' + strManFields + ' FROM Manager_Best_Guess__c WHERE OwnerId = \'' + gstrTeamMemberId 
                                     + '\' AND Year__c = \'' + gstrGuessId + '\'';
                String strHistManQuery = 'Select Archive_Date__c, ' + strManFields + ' FROM Historical_Manager_Best_Guess__c WHERE OwnerId = \'' + gstrTeamMemberId 
                                         + '\' AND Year__c = \'' + gstrGuessId + '\'' + ' AND Archive_Date__C = ' + tDate;
                List<Manager_Best_Guess__c> lstMBG = Database.query(strManQuery);
                List<Historical_Manager_Best_Guess__c> lstHistMBG = Database.query(strHistManQuery);
                if(lstMBG.size() > 0) {
                    teamMemberIsMan = true;
                } else {
                    teamMemberIsMan = false;
                }
                String strRepQuery = 'Select ' + strRepFields + ' FROM Sales_Rep_Best_Guess__c WHERE OwnerId = \'' + gstrTeamMemberId 
                                     + '\' AND Year__c = \'' + gstrGuessId + '\'';
                String strHistRepQuery = 'Select Archive_Date__c, ' + strRepFields + ' FROM Historical_Sales_Rep_Best_Guess__c WHERE OwnerId = \'' + gstrTeamMemberId 
                                             + '\' AND Year__c = \'' + gstrGuessId + '\'' + ' AND Archive_Date__C = ' + tDate;
                List<Sales_Rep_Best_Guess__c> lstSRBG = Database.query(strRepQuery);
                List<Historical_Sales_Rep_Best_Guess__c> lstHistSRBG = Database.query(strHistRepQuery);                
                //make sure the table shows the right bg
                if(((isManBestGuess && lstSRBG.size()==0 && lstHistSRBG.size()==0) || teamMemberIsMan) && !((gstrTeamMemberId==gstrUserId) && lstSRBG.size() > 0 && lstHistSRBG.size() > 0)){
                    teamMemberIsMan = true;
                    //Input for Best Guess Table
                    bgr.teamMBGList = new List<Manager_Best_Guess__c>();
                    bgr.histMBGList = new List<Historical_Manager_Best_Guess__c>();
                    bgr.teamMBGList = lstMBG;
                    bgr.histMBGList = lstHistMBG;
                    Decimal mbgTBG = 0;
                    Decimal hmbgTBG = 0;
                    for(Manager_Best_Guess__c teamMBG : bgr.teamMBGList){
                        if(teamMBG.Total_BG_Override__c != null) bgr.bestGuess += teamMBG.Total_BG_Override__c;
                        if(teamMBG.Team_Booked_Actual__c != null) bgr.bookedAmount += teamMBG.Team_Booked_Actual__c;
                        if(teamMBG.Total_BG__c != null) mbgTBG += teamMBG.Total_BG__c;
                        
                    }
                    for(Historical_Manager_Best_Guess__c histMBG : bgr.histMBGList){
                        if(histMBG.Total_BG_Override__c != null) bgr.histBestGuess += histMBG.Total_BG_Override__c;
                        if(histMBG.Team_Booked_Actual__c != null) bgr.histBookedAmount += histMBG.Team_Booked_Actual__c;
                        if(histMBG.Total_BG__c != null) hmbgTBG += histMBG.Total_BG__c;
                    }
                    bgr.BGDifference = mbgTBG - hmbgTBG;
                    bgr.bookedDifference = bgr.bookedAmount - bgr.histBookedAmount;
                } else{
                    teamMemberIsMan = false;
                    bgr.teamSRBGList = new List<Sales_Rep_Best_Guess__c>();
                    bgr.histSRBGList = new List<Historical_Sales_Rep_Best_Guess__c>();
                    bgr.teamSRBGList = lstSRBG;
                    bgr.histSRBGList = lstHistSRBG;
                    for(Sales_Rep_Best_Guess__c teamSRBG : bgr.teamSRBGList){
                        if(teamSRBG.Total_BG__c != null) bgr.bestGuess += teamSRBG.Total_BG__c;
                        if(teamSRBG.Booked_Actual__c != null) bgr.bookedAmount += teamSRBG.Booked_Actual__c;
                    }
                    for(Historical_Sales_Rep_Best_Guess__c histSRBG : bgr.histSRBGList){
                        if(histSRBG.Total_BG__c != null) bgr.histBestGuess += histSRBG.Total_BG__c;
                        if(histSRBG.Booked_Actual__c != null) bgr.histBookedAmount += histSRBG.Booked_Actual__c;
                    }
                    bgr.BGDifference = bgr.bestGuess - bgr.histBestGuess;
                    bgr.bookedDifference = bgr.bookedAmount - bgr.histBookedAmount;
                }
                bestGuessList.add(bgr);
                deliveryType = 'Total';
            }
        }
    }
    
    //method to display Delivery Type field on page
    public void  setDeliveryTypes(){
        sumBestGuess = 0;
        sumHistBestGuess = 0;
        sumDiffBestGuess = 0;
        sumBookedAmount = 0;
        sumHistBookedAmount = 0;
        sumDiffBookedAmount = 0;
        for(bestGuessRow b : bestGuessList){
            b.bestGuess = 0;
            b.histBestGuess = 0;
            b.bookedAmount = 0;
            b.histBookedAmount = 0;
            //calculate numbers for HBG table
            if(deliveryType =='Total'){
                if(b.teamMBGList != null && b.teamMBGList.size()>0){
                    for(Manager_Best_Guess__c teamMBG : b.teamMBGList){
                        if(teamMBG.Total_BG_Override__c != null) b.bestGuess += teamMBG.Total_BG_Override__c;
                        if(teamMBG.Team_Booked_Actual__c != null) b.bookedAmount += teamMBG.Team_Booked_Actual__c;
                    }
                    for(Historical_Manager_Best_Guess__c histMBG : b.histMBGList){
                        if(histMBG.Total_BG_Override__c != null) b.histBestGuess += histMBG.Total_BG_Override__c;
                        if(histMBG.Team_Booked_Actual__c != null) b.histBookedAmount += histMBG.Team_Booked_Actual__c;
                    }
                } else if(b.teamSRBGList != null && b.teamSRBGList.size()>0){
                    for(Sales_Rep_Best_Guess__c teamSRBG : b.teamSRBGList){
                        if(teamSRBG.Total_BG__c != null) b.bestGuess += teamSRBG.Total_BG__c;
                        if(teamSRBG.Booked_Actual__c != null) b.bookedAmount += teamSRBG.Booked_Actual__c;
                    }
                    for(Historical_Sales_Rep_Best_Guess__c histSRBG : b.histSRBGList){
                        if(histSRBG.Total_BG__c != null) b.histBestGuess += histSRBG.Total_BG__c;
                        if(histSRBG.Booked_Actual__c != null) b.histBookedAmount += histSRBG.Booked_Actual__c;
                    }
                }
            } else if(deliveryType == 'Base'){
                if(b.teamMBGList != null && b.teamMBGList.size()>0){
                    for(Manager_Best_Guess__c teamMBG : b.teamMBGList){
                        if(teamMBG.Override_Team_Manu_Base_Best_Guess__c != null) b.bestGuess += teamMBG.Override_Team_Manu_Base_Best_Guess__c;
                        if(teamMBG.Override_Team_Retail_Base_Best_Guess__c != null) b.bestGuess += teamMBG.Override_Team_Retail_Base_Best_Guess__c;
                        if(teamMBG.Team_M_B_Booked_Actual__c != null) b.bookedAmount += teamMBG.Team_M_B_Booked_Actual__c;
                        if(teamMBG.Team_R_B_Booked_Actual__c != null) b.bookedAmount += teamMBG.Team_R_B_Booked_Actual__c;
                    }
                    for(Historical_Manager_Best_Guess__c histMBG : b.histMBGList){
                        if(histMBG.Override_Team_Manu_Base_Best_Guess__c != null) b.histBestGuess += histMBG.Override_Team_Manu_Base_Best_Guess__c;
                        if(histMBG.Override_Team_Retail_Base_Best_Guess__c != null) b.histBestGuess += histMBG.Override_Team_Retail_Base_Best_Guess__c;
                        if(histMBG.Team_M_B_Booked_Actual__c != null) b.histBookedAmount += histMBG.Team_M_B_Booked_Actual__c;
                        if(histMBG.Team_R_B_Booked_Actual__c != null) b.histBookedAmount += histMBG.Team_R_B_Booked_Actual__c;
                    }
                } else if(b.teamSRBGList != null && b.teamSRBGList.size()>0){
                    for(Sales_Rep_Best_Guess__c teamSRBG : b.teamSRBGList){
                        if(teamSRBG.Manufacturing_Base_Best_Guess__c != null) b.bestGuess += teamSRBG.Manufacturing_Base_Best_Guess__c;
                        if(teamSRBG.Retail_Base_Best_Guess__c != null) b.bestGuess += teamSRBG.Retail_Base_Best_Guess__c;
                        if(teamSRBG.M_B_Booked_Actual__c != null) b.bookedAmount += teamSRBG.M_B_Booked_Actual__c;
                        if(teamSRBG.R_B_Booked_Actual__c != null) b.bookedAmount += teamSRBG.R_B_Booked_Actual__c;
                    }
                    for(Historical_Sales_Rep_Best_Guess__c histSRBG : b.histSRBGList){
                        if(histSRBG.Manufacturing_Base_Best_Guess__c != null) b.histBestGuess += histSRBG.Manufacturing_Base_Best_Guess__c;
                        if(histSRBG.Retail_Base_Best_Guess__c != null) b.histBestGuess += histSRBG.Retail_Base_Best_Guess__c;
                        if(histSRBG.M_B_Booked_Actual__c != null) b.histBookedAmount += histSRBG.M_B_Booked_Actual__c;
                        if(histSRBG.R_B_Booked_Actual__c != null) b.histBookedAmount += histSRBG.R_B_Booked_Actual__c;
                    }
                }
            } else if(deliveryType == 'Digital'){
                if(b.teamMBGList != null && b.teamMBGList.size()>0){
                    for(Manager_Best_Guess__c teamMBG : b.teamMBGList){
                        if(teamMBG.Override_Team_Manu_Digital_Best_Guess__c != null) b.bestGuess += teamMBG.Override_Team_Manu_Digital_Best_Guess__c;
                        if(teamMBG.Override_Team_Retail_Digital_Best_Guess__c != null) b.bestGuess += teamMBG.Override_Team_Retail_Digital_Best_Guess__c;
                        if(teamMBG.Team_M_D_Booked_Actual__c != null) b.bookedAmount += teamMBG.Team_M_D_Booked_Actual__c;
                        if(teamMBG.Team_R_D_Booked_Actual__c != null) b.bookedAmount += teamMBG.Team_R_D_Booked_Actual__c;
                    }
                    for(Historical_Manager_Best_Guess__c histMBG : b.histMBGList){
                        if(histMBG.Override_Team_Manu_Digital_Best_Guess__c != null) b.histBestGuess += histMBG.Override_Team_Manu_Digital_Best_Guess__c;
                        if(histMBG.Override_Team_Retail_Digital_Best_Guess__c != null) b.histBestGuess += histMBG.Override_Team_Retail_Digital_Best_Guess__c;
                        if(histMBG.Team_M_D_Booked_Actual__c != null) b.histBookedAmount += histMBG.Team_M_D_Booked_Actual__c;
                        if(histMBG.Team_R_D_Booked_Actual__c != null) b.histBookedAmount += histMBG.Team_R_D_Booked_Actual__c;
                    }
                } else if(b.teamSRBGList != null && b.teamSRBGList.size()>0){
                    for(Sales_Rep_Best_Guess__c teamSRBG : b.teamSRBGList){
                        if(teamSRBG.Manufacturing_Digital_Best_Guess__c != null) b.bestGuess += teamSRBG.Manufacturing_Digital_Best_Guess__c;
                        if(teamSRBG.Retail_Digital_Best_Guess__c != null) b.bestGuess += teamSRBG.Retail_Digital_Best_Guess__c;
                        if(teamSRBG.M_D_Booked_Actual__c != null) b.bookedAmount += teamSRBG.M_D_Booked_Actual__c;
                        if(teamSRBG.R_D_Booked_Actual__c != null) b.bookedAmount += teamSRBG.R_D_Booked_Actual__c;
                    }
                    for(Historical_Sales_Rep_Best_Guess__c histSRBG : b.histSRBGList){
                        if(histSRBG.Manufacturing_Digital_Best_Guess__c != null) b.histBestGuess += histSRBG.Manufacturing_Digital_Best_Guess__c;
                        if(histSRBG.Retail_Digital_Best_Guess__c != null) b.histBestGuess += histSRBG.Retail_Digital_Best_Guess__c;
                        if(histSRBG.M_D_Booked_Actual__c != null) b.histBookedAmount += histSRBG.M_D_Booked_Actual__c;
                        if(histSRBG.R_D_Booked_Actual__c != null) b.histBookedAmount += histSRBG.R_D_Booked_Actual__c;
                    }
                }       
            } else if(deliveryType == 'Audience Network'){
                if(b.teamMBGList != null && b.teamMBGList.size()>0){
                    for(Manager_Best_Guess__c teamMBG : b.teamMBGList){
                        if(teamMBG.Override_Team_Manu_Audience_Best_Guess__c != null) b.bestGuess += teamMBG.Override_Team_Manu_Audience_Best_Guess__c;
                        if(teamMBG.Override_Team_Retail_Audience_Best_Guess__c != null) b.bestGuess += teamMBG.Override_Team_Retail_Audience_Best_Guess__c;
                        if(teamMBG.Team_M_A_Booked_Actual__c != null) b.bookedAmount += teamMBG.Team_M_A_Booked_Actual__c;
                        if(teamMBG.Team_R_A_Booked_Actual__c != null) b.bookedAmount += teamMBG.Team_R_A_Booked_Actual__c;
                    }
                    for(Historical_Manager_Best_Guess__c histMBG : b.histMBGList){
                        if(histMBG.Override_Team_Manu_Audience_Best_Guess__c != null) b.histBestGuess += histMBG.Override_Team_Manu_Audience_Best_Guess__c;
                        if(histMBG.Override_Team_Retail_Audience_Best_Guess__c != null) b.histBestGuess += histMBG.Override_Team_Retail_Audience_Best_Guess__c;
                        if(histMBG.Team_M_A_Booked_Actual__c != null) b.histBookedAmount += histMBG.Team_M_A_Booked_Actual__c;
                        if(histMBG.Team_R_A_Booked_Actual__c != null) b.histBookedAmount += histMBG.Team_R_A_Booked_Actual__c;
                    }
                } else if(b.teamSRBGList != null && b.teamSRBGList.size()>0){
                    for(Sales_Rep_Best_Guess__c teamSRBG : b.teamSRBGList){
                        if(teamSRBG.Manufacturing_Audience_Best_Guess__c != null) b.bestGuess += teamSRBG.Manufacturing_Audience_Best_Guess__c;
                        if(teamSRBG.Retail_Audience_Best_Guess__c != null) b.bestGuess += teamSRBG.Retail_Audience_Best_Guess__c;
                        if(teamSRBG.M_A_Booked_Actual__c != null) b.bookedAmount += teamSRBG.M_A_Booked_Actual__c;
                        if(teamSRBG.R_A_Booked_Actual__c != null) b.bookedAmount += teamSRBG.R_A_Booked_Actual__c;
                    }
                    for(Historical_Sales_Rep_Best_Guess__c histSRBG : b.histSRBGList){
                        if(histSRBG.Manufacturing_Audience_Best_Guess__c != null) b.histBestGuess += histSRBG.Manufacturing_Audience_Best_Guess__c;
                        if(histSRBG.Retail_Audience_Best_Guess__c != null) b.histBestGuess += histSRBG.Retail_Audience_Best_Guess__c;
                        if(histSRBG.M_A_Booked_Actual__c != null) b.histBookedAmount += histSRBG.M_A_Booked_Actual__c;
                        if(histSRBG.R_A_Booked_Actual__c != null) b.histBookedAmount += histSRBG.R_A_Booked_Actual__c;
                    }
                }
            } else if(deliveryType == 'Mobile') {
                if(b.teamMBGList != null && b.teamMBGList.size()>0){
                    for(Manager_Best_Guess__c teamMBG : b.teamMBGList){
                        if(teamMBG.Override_Team_Manu_Mobile_Best_Guess__c != null) b.bestGuess += teamMBG.Override_Team_Manu_Mobile_Best_Guess__c;
                        if(teamMBG.Override_Team_Retail_Mobile_Best_Guess__c != null) b.bestGuess += teamMBG.Override_Team_Retail_Mobile_Best_Guess__c;
                        if(teamMBG.Team_M_M_Booked_Actual__c != null) b.bookedAmount += teamMBG.Team_M_M_Booked_Actual__c;
                        if(teamMBG.Team_R_M_Booked_Actual__c != null) b.bookedAmount += teamMBG.Team_R_M_Booked_Actual__c;
                    }
                    for(Historical_Manager_Best_Guess__c histMBG : b.histMBGList){
                        if(histMBG.Override_Team_Manu_Mobile_Best_Guess__c != null) b.histBestGuess += histMBG.Override_Team_Manu_Mobile_Best_Guess__c;
                        if(histMBG.Override_Team_Retail_Mobile_Best_Guess__c != null) b.histBestGuess += histMBG.Override_Team_Retail_Mobile_Best_Guess__c;
                        if(histMBG.Team_M_M_Booked_Actual__c != null) b.histBookedAmount += histMBG.Team_M_M_Booked_Actual__c;
                        if(histMBG.Team_R_M_Booked_Actual__c != null) b.histBookedAmount += histMBG.Team_R_M_Booked_Actual__c;
                    }
                } else if(b.teamSRBGList != null && b.teamSRBGList.size()>0){
                    for(Sales_Rep_Best_Guess__c teamSRBG : b.teamSRBGList){
                        if(teamSRBG.Manufacturing_Mobile_Best_Guess__c != null) b.bestGuess += teamSRBG.Manufacturing_Mobile_Best_Guess__c;
                        if(teamSRBG.Retail_Mobile_Best_Guess__c != null) b.bestGuess += teamSRBG.Retail_Mobile_Best_Guess__c;
                        if(teamSRBG.M_M_Booked_Actual__c != null) b.bookedAmount += teamSRBG.M_M_Booked_Actual__c;
                        if(teamSRBG.R_M_Booked_Actual__c != null) b.bookedAmount += teamSRBG.R_M_Booked_Actual__c;
                    }
                    for(Historical_Sales_Rep_Best_Guess__c histSRBG : b.histSRBGList){
                        if(histSRBG.Manufacturing_Mobile_Best_Guess__c != null) b.histBestGuess += histSRBG.Manufacturing_Mobile_Best_Guess__c;
                        if(histSRBG.Retail_Mobile_Best_Guess__c != null) b.histBestGuess += histSRBG.Retail_Mobile_Best_Guess__c;
                        if(histSRBG.M_M_Booked_Actual__c != null) b.histBookedAmount += histSRBG.M_M_Booked_Actual__c;
                        if(histSRBG.R_M_Booked_Actual__c != null) b.histBookedAmount += histSRBG.R_M_Booked_Actual__c;
                    }
                }
            }
            b.BGDifference = b.bestGuess - b.histBestGuess;
            b.bookedDifference = b.bookedAmount - b.histBookedAmount;
            sumBestGuess += b.bestGuess;
            sumHistBestGuess += b.histBestGuess;
            sumDiffBestGuess += b.BGDifference;
            sumBookedAmount += b.bookedAmount;
            sumHistBookedAmount += b.histBookedAmount;
            sumDiffBookedAmount += b.bookedDifference;
        }
    }
    
    //options in team member list
    public List<SelectOption> getTeam(){
        Boolean checkList;
        checkList = false;
        Map<User, Id> mapTeamMember = new Map<User, Id>();
        //Set to dump in all the team members
        Set<Id> setTeamMemberId = new Set<Id>();
        Set<Id> setUserIds = new Set<Id>();
        List<Manager_Best_Guess__c> lstMan = [SELECT Id, OwnerId FROM Manager_Best_Guess__c];
        List<Sales_Rep_Best_Guess__c> lstRep = [SELECT Id, OwnerId FROM Sales_Rep_Best_Guess__c];        
        //add all the users that have BG
        for(Manager_Best_Guess__c man : lstMan){
            setUserIds.add(man.OwnerId);
        }
        for(Sales_Rep_Best_Guess__c rep : lstRep){
            setUserIds.add(rep.OwnerId);
        }        
        //returns the user with gstrUserId (User selected in dropdown list of the Best Guess page)
        if(gstrUserId != null){
            setTeamMemberId.add(gstrUserId);
        }
        List<User> lstTeamMember = [select Id, managerId from User where isActive = true];// where managerId =: gstrUserId]        
        for(User u : lstTeamMember){
            mapTeamMember.put(u, u.Id);
        }        
        Set<Id> temp = new Set<Id>();
        //Adds users belonging to current user's team
        for(User u : lstTeamMember){        
            if(u.managerId == gstrUserId){
               setTeamMemberId.add(mapTeamMember.get(u));
           }
        }
        List<SelectOption> lstReturn = new List<SelectOption>();
        List<User> lstUsers = [SELECT Id, Name, Does_Sell__c
                                    FROM User  
                                    WHERE Id IN :setUserIds AND Id IN :setTeamMemberId  
                                    Order By Name ASC 
                                    LIMIT 999];
        for(User use : lstUsers){
            lstUserIds.add(use.Id);
        }
        if(isManBestGuess){
            lstReturn.add(new SelectOption('All' + gstrUserId, '--All--'));
        } 
        for(User use : lstUsers){
            if((use.Id != gstrUserId || use.Does_Sell__c == true) && isManBestGuess){
                lstReturn.add(new SelectOption(use.Id, use.Name));
            } else if(use.id == gstruserId) {
                lstReturn.add(new SelectOption(use.Id, use.Name));
            }
        }                
        if(lstReturn.size() > 1) {
            showTotal = true;
        } else {
            showTotal = false;
        }        
        for(SelectOption s : lstReturn ) {
            if(s.getValue() == gstrTeamMemberId){
                checkList = true;
            }
        }
        if(!checkList) {
            lstReturn.add(new SelectOption(gstrTeamMemberId,'Temporary Value'));
             //gstrTeamMemberId = lstReturn[0].getValue();
        }
        return lstReturn;
    }
    
    //reset method
    public void resetTotal(){
        sumBestGuess = null;
        sumHistBestGuess = null;
        sumDiffBestGuess = null;
        sumBookedAmount = null;
        sumHistBookedAmount = null;
        sumDiffBookedAmount = null;
    }
    
    //method to display manager table
    public void setTableForManager(){
        resetTotal();
        sumBestGuess = 0;
        sumHistBestGuess = 0;
        sumDiffBestGuess = 0;
        sumBookedAmount = 0;
        sumHistBookedAmount = 0;
        sumDiffBookedAmount = 0;
        //set to store OwnerIds for Manager Best Guess. If contained in the set, Sales Rep BG is not displayed 
        Set<Id> managerIds = new Set<Id>();        
        HBGBatchInterval__c hbgSetting = HBGBatchInterval__c.getInstance('LastDate');
        String tDate = String.valueOf(hbgSetting.Last_Run_Date__c);
        tDate = tDate.substring(0,10);        
        String strManQuery = 'Select ' + strManFields + ' FROM Manager_Best_Guess__c WHERE OwnerId IN :lstUserIds ' 
                                     + ' AND Year__c = \'' + gstrGuessId + '\'';
        String strHistManQuery = 'Select Archive_Date__c, ' + strManFields + ' FROM Historical_Manager_Best_Guess__c WHERE OwnerId IN :lstUserIds ' 
                                     + ' AND Year__c = \'' + gstrGuessId + '\'' + ' AND Archive_Date__C = ' + tDate;      
        List<Manager_Best_Guess__c> lstMBG = Database.query(strManQuery);
        List<Historical_Manager_Best_Guess__c> lstHistMBG = Database.query(strHistManQuery);           
        Map<Id, User> mapBestGuessUser = new Map<Id, User>([Select Id, Name From User where Id IN :lstUserIds]);
        Map<Id, List<Manager_Best_Guess__c>> mapManBestGuess = new Map<Id, List<Manager_Best_Guess__c>>();
        Map<Id, List<Historical_Manager_Best_Guess__c>> mapHistManBestGuess = new Map<Id, List<Historical_Manager_Best_Guess__c>>();
        Map<String,Map<String,Historical_Manager_Best_Guess__c>> tempHistMap = new Map<String,Map<String,Historical_Manager_Best_Guess__c>>();
        List<Historical_Manager_Best_Guess__c> insertHmbg = new List<Historical_Manager_Best_Guess__c>();
        for(Historical_Manager_Best_Guess__c h : lstHistMBG) {
            if(!mapHistManBestGuess.containsKey(h.OwnerId)){
                List<Historical_Manager_Best_Guess__c> tempLst = new List<Historical_Manager_Best_Guess__c>();
                tempLst.add(h);
                mapHistManBestGuess.put(h.OwnerId, tempLst);
                Map<String,Historical_Manager_Best_Guess__c> tmp = new Map<String,Historical_Manager_Best_Guess__c>();
                tmp.put(h.Name,h);
                tempHistMap.put(h.OwnerId,tmp);
            }else{
                mapHistManBestGuess.get(h.OwnerId).add(h);
                tempHistMap.get(h.OwnerId).put(h.name,h);
            }
        }
        for(Manager_Best_Guess__c m : lstMBG) {
            if(!mapManBestGuess.containsKey(m.OwnerId)){
                List<Manager_Best_Guess__c> tempLst = new List<Manager_Best_Guess__c>();
                tempLst.add(m);
                mapManBestGuess.put(m.OwnerId, tempLst);
            }else{
                mapManBestGuess.get(m.OwnerId).add(m);
            }
        }
        for(String mOwnerID : mapManBestGuess.KeySet()) {  
            if(mOwnerID != gstrUserId){
                managerIds.add(mOwnerId);            
                bestGuessRow bgr = new bestGuessRow();
                insertHmbg = new List<Historical_Manager_Best_Guess__c>();
                for(Manager_Best_Guess__c a : mapManBestGuess.get(mOwnerID)){
                    if(!tempHistMap.containsKey(mOwnerID) || (tempHistMap.get(mOwnerID)!=null && !tempHistMap.get(mOwnerID).containsKey(a.Name))){
                        Historical_Manager_Best_Guess__c hmbg = new Historical_Manager_Best_Guess__c();
                        hmbg.Archive_Date__c = Date.valueOf(tDate);
                        hmbg.Name = a.Name;
                        hmbg.OwnerId = a.OwnerId;
                        hmbg.Comments__c = a.Comments__c;
                        hmbg.Forecast_Role__c = a.Forecast_Role__c;
                        hmbg.Is_Manager__c = a.Is_Manager__c;
                        hmbg.Last_Entered_Date__c = a.Last_Entered_Date__c;
                        hmbg.Last_Entered_User__c = a.Last_Entered_User__c;
                        hmbg.Manager__c = a.Manager__c;
                        hmbg.Manager_Best_Guess__c = a.Manager_Best_Guess__c;
                        hmbg.Override_Team_Manu_Audience_Best_Guess__c = a.Override_Team_Manu_Audience_Best_Guess__c;
                        hmbg.Team_Manufacturing_Audience_Best_Guess__c = a.Team_Manufacturing_Audience_Best_Guess__c;
                        hmbg.Team_M_A_Booked_Full_Proposal__c = a.Team_M_A_Booked_Full_Proposal__c;
                        hmbg.Team_M_A_Booked_Proposal__c = a.Team_M_A_Booked_Proposal__c;
                        hmbg.Team_M_A_Booked_Actual__c = a.Team_M_A_Booked_Actual__c;
                        hmbg.Override_Team_Manu_Audience_High__c = a.Override_Team_Manu_Audience_High__c;
                        hmbg.Team_Manufacturing_Audience_High__c = a.Team_Manufacturing_Audience_High__c;
                        hmbg.Override_Team_Manu_Audience_Low__c = a.Override_Team_Manu_Audience_Low__c;
                        hmbg.Team_Manufacturing_Audience_Low__c = a.Team_Manufacturing_Audience_Low__c;
                        hmbg.Override_Team_Manu_Base_Best_Guess__c = a.Override_Team_Manu_Base_Best_Guess__c;
                        hmbg.Team_Manufacturing_Base_Best_Guess__c = a.Team_Manufacturing_Base_Best_Guess__c;
                        hmbg.Team_M_B_Booked_Full_Proposal__c = a.Team_M_B_Booked_Full_Proposal__c;
                        hmbg.Team_M_B_Booked_Proposal__c = a.Team_M_B_Booked_Proposal__c;
                        hmbg.Team_M_B_Booked_Actual__c = a.Team_M_B_Booked_Actual__c;
                        hmbg.Override_Team_Manu_Base_High__c = a.Override_Team_Manu_Base_High__c;
                        hmbg.Team_Manufacturing_Base_High__c = a.Team_Manufacturing_Base_High__c;
                        hmbg.Override_Team_Manu_Base_Low__c = a.Override_Team_Manu_Base_Low__c;
                        hmbg.Team_Manufacturing_Base_Low__c = a.Team_Manufacturing_Base_Low__c;
                        hmbg.Override_Team_Manu_Digital_Best_Guess__c = a.Override_Team_Manu_Digital_Best_Guess__c;
                        hmbg.Team_Manufacturing_Digital_Best_Guess__c = a.Team_Manufacturing_Digital_Best_Guess__c;
                        hmbg.Team_M_D_Booked_Full_Proposal__c = a.Team_M_D_Booked_Full_Proposal__c;
                        hmbg.Team_M_D_Booked_Proposal__c = a.Team_M_D_Booked_Proposal__c;
                        hmbg.Team_M_D_Booked_Actual__c = a.Team_M_D_Booked_Actual__c;
                        hmbg.Override_Team_Manu_Digital_High__c = a.Override_Team_Manu_Digital_High__c;
                        hmbg.Team_Manufacturing_Digital_High__c = a.Team_Manufacturing_Digital_High__c;
                        hmbg.Team_Manufacturing_Digital_Low__c = a.Team_Manufacturing_Digital_Low__c;
                        hmbg.Override_Team_Manu_Digital_Low__c = a.Override_Team_Manu_Digital_Low__c;
                        hmbg.Override_Team_Manu_Mobile_Best_Guess__c = a.Override_Team_Manu_Mobile_Best_Guess__c;
                        hmbg.Team_Manufacturing_Mobile_Best_Guess__c = a.Team_Manufacturing_Mobile_Best_Guess__c;
                        hmbg.Team_M_M_Booked_Full_Proposal__c = a.Team_M_M_Booked_Full_Proposal__c;
                        hmbg.Team_M_M_Booked_Proposal__c = a.Team_M_M_Booked_Proposal__c;
                        hmbg.Team_M_M_Booked_Actual__c = a.Team_M_M_Booked_Actual__c;
                        hmbg.Override_Team_Manu_Mobile_High__c = a.Override_Team_Manu_Mobile_High__c;
                        hmbg.Team_Manufacturing_Mobile_High__c = a.Team_Manufacturing_Mobile_High__c;
                        hmbg.Override_Team_Manu_Mobile_Low__c = a.Override_Team_Manu_Mobile_Low__c;
                        hmbg.Team_Manufacturing_Mobile_Low__c = a.Team_Manufacturing_Mobile_Low__c;
                        hmbg.Quarter__c = a.Quarter__c;
                        hmbg.Quarter_End_Date__c = a.Quarter_End_Date__c;
                        hmbg.Quarter_Start_Date__c = a.Quarter_Start_Date__c;
                        hmbg.Override_Team_Retail_Audience_Best_Guess__c = a.Override_Team_Retail_Audience_Best_Guess__c;
                        hmbg.Team_Retail_Audience_Best_Guess__c = a.Team_Retail_Audience_Best_Guess__c;
                        hmbg.Team_R_A_Booked_Proposal__c = a.Team_R_A_Booked_Proposal__c;
                        hmbg.Team_R_A_Booked_Actual__c = a.Team_R_A_Booked_Actual__c;
                        hmbg.Override_Team_Retail_Audience_High__c = a.Override_Team_Retail_Audience_High__c;
                        hmbg.Team_Retail_Audience_High__c = a.Team_Retail_Audience_High__c;
                        hmbg.Override_Team_Retail_Audience_Low__c = a.Override_Team_Retail_Audience_Low__c;
                        hmbg.Team_Retail_Audience_Low__c = a.Team_Retail_Audience_Low__c;
                        hmbg.Override_Team_Retail_Base_Best_Guess__c = a.Override_Team_Retail_Base_Best_Guess__c;
                        hmbg.Team_Retail_Base_Best_Guess__c = a.Team_Retail_Base_Best_Guess__c;
                        hmbg.Team_R_B_Booked_Full_Proposal__c = a.Team_R_B_Booked_Full_Proposal__c;
                        hmbg.Team_R_B_Booked_Proposal__c = a.Team_R_B_Booked_Proposal__c;
                        hmbg.Team_R_B_Booked_Actual__c = a.Team_R_B_Booked_Actual__c;
                        hmbg.Override_Team_Retail_Base_High__c = a.Override_Team_Retail_Base_High__c;
                        hmbg.Team_Retail_Base_High__c = a.Team_Retail_Base_High__c;
                        hmbg.Override_Team_Retail_Base_Low__c = a.Override_Team_Retail_Base_Low__c;
                        hmbg.Team_Retail_Base_Low__c = a.Team_Retail_Base_Low__c;
                        hmbg.Override_Team_Retail_Digital_Best_Guess__c = a.Override_Team_Retail_Digital_Best_Guess__c;
                        hmbg.Team_Retail_Digital_Best_Guess__c = a.Team_Retail_Digital_Best_Guess__c;
                        hmbg.Team_R_D_Booked_Proposal__c = a.Team_R_D_Booked_Proposal__c;
                        hmbg.Team_R_D_Booked_Actual__c = a.Team_R_D_Booked_Actual__c;
                        hmbg.Override_Team_Retail_Digital_High__c = a.Override_Team_Retail_Digital_High__c;
                        hmbg.Team_Retail_Digital_High__c = a.Team_Retail_Digital_High__c;
                        hmbg.Override_Team_Retail_Digital_Low__c = a.Override_Team_Retail_Digital_Low__c;
                        hmbg.Team_Retail_Digital_Low__c = a.Team_Retail_Digital_Low__c;
                        hmbg.Override_Team_Retail_Mobile_Best_Guess__c = a.Override_Team_Retail_Mobile_Best_Guess__c;
                        hmbg.Team_Retail_Mobile_Best_Guess__c = a.Team_Retail_Mobile_Best_Guess__c;
                        hmbg.Team_R_M_Booked_Full_Proposal__c = a.Team_R_M_Booked_Full_Proposal__c;
                        hmbg.Team_R_M_Booked_Proposal__c = a.Team_R_M_Booked_Proposal__c;
                        hmbg.Team_R_M_Booked_Actual__c = a.Team_R_M_Booked_Actual__c;
                        hmbg.Override_Team_Retail_Mobile_High__c = a.Override_Team_Retail_Mobile_High__c;
                        hmbg.Team_Retail_Mobile_High__c = a.Team_Retail_Mobile_High__c;
                        hmbg.Override_Team_Retail_Mobile_Low__c = a.Override_Team_Retail_Mobile_Low__c;
                        hmbg.Team_Retail_Mobile_Low__c = a.Team_Retail_Mobile_Low__c;
                        hmbg.Team_R_A_Booked_Full_Proposal__c = a.Team_R_A_Booked_Full_Proposal__c;
                        hmbg.Team_R_D_Booked_Full_Proposal__c = a.Team_R_D_Booked_Full_Proposal__c;
                        hmbg.Same_as_Owner__c = a.Same_as_Owner__c;
                        hmbg.Support_User__c = a.Support_User__c;
                        hmbg.Team_Booked_Actual__c = a.Team_Booked_Actual__c;
                        hmbg.Team_Booked_Full_Proposal__c = a.Team_Booked_Full_Proposal__c;
                        hmbg.Team_Booked_Proposal__c = a.Team_Booked_Proposal__c;
                        hmbg.Team_Previous_Year_Actual__c = a.Team_Previous_Year_Actual__c;
                        hmbg.Team_Quota__c = a.Team_Quota__c;
                        hmbg.Total_BG__c = a.Total_BG__c;
                        hmbg.Total_BG_Override__c = a.Total_BG_Override__c;
                        hmbg.Total_H_Override__c = a.Total_H_Override__c;
                        hmbg.Total_H__c = a.Total_H__c;
                        hmbg.Total_L_Override__c = a.Total_L_Override__c;
                        hmbg.Total_L__c = a.Total_L__c;
                        hmbg.Use_Override__c = a.Use_Override__c;
                        hmbg.Year__c = a.Year__c;
                        insertHmbg.add(hmbg);
                    }   
                } 
                if(insertHmbg.size()>0){
                    try{
                        insert insertHmbg;
                        for(Historical_Manager_Best_Guess__c h : insertHmbg) {
                            if(!mapHistManBestGuess.containsKey(h.OwnerId)){
                                List<Historical_Manager_Best_Guess__c> tmp = new List<Historical_Manager_Best_Guess__c>();
                                tmp.add(h);
                                mapHistManBestGuess.put(h.OwnerId,tmp);
                            }else{
                                mapHistManBestGuess.get(h.OwnerId).add(h);
                            }
                        }
                    } catch (Exception e){}
                }
                bgr.name = mapBestGuessUser.get(mOwnerId).Name;
                bgr.teamMBGList = new List<Manager_Best_Guess__c>();
                bgr.histMBGList = new List<Historical_Manager_Best_Guess__c>();
                bgr.teamMBGList = mapManBestGuess.get(mOwnerID);
                bgr.histMBGList = mapHistManBestGuess.get(mOwnerID);
                bgr.bestGuess = 0;
                bgr.bookedAmount = 0;
                bgr.histBestGuess  = 0;
                bgr.histBookedAmount = 0;
                for(Manager_Best_Guess__c m : bgr.teamMBGList){
                    if(m.Total_BG_Override__c!=null){
                        bgr.bestGuess += m.Total_BG_Override__c;
                    }
                    if(m.Team_Booked_Actual__c!=null){
                        bgr.bookedAmount += m.Team_Booked_Actual__c;
                    }
                }
                for(Historical_Manager_Best_Guess__c h : bgr.histMBGList){
                    if(h.Total_BG_Override__c!=null){
                        bgr.histBestGuess += h.Total_BG_Override__c;
                    }
                    if(h.Team_Booked_Actual__c!=null){
                        bgr.histBookedAmount += h.Team_Booked_Actual__c;
                    }
                } 
                bgr.BGDifference = bgr.bestGuess - bgr.histBestGuess;
                bgr.bookedDifference = bgr.bookedAmount - bgr.histBookedAmount;
                bestGuessList.add(bgr);         
                sumBestGuess += bgr.bestGuess;
                sumHistBestGuess += bgr.histBestGuess;
                sumDiffBestGuess += bgr.BGDifference;
                sumBookedAmount += bgr.bookedAmount;
                sumHistBookedAmount += bgr.histBookedAmount;
                sumDiffBookedAmount += bgr.bookedDifference;            
            }
        }    
        String strRepQuery = 'Select ' + strRepFields + ' FROM Sales_Rep_Best_Guess__c WHERE OwnerId IN :lstUserIds'
                                     + ' AND Year__c = \'' + gstrGuessId + '\'';
        String strHistRepQuery = 'Select Archive_Date__c, ' + strRepFields + ' FROM Historical_Sales_Rep_Best_Guess__c WHERE OwnerId IN :lstUserIds' 
                                     + ' AND Year__c = \'' + gstrGuessId + '\'' + ' AND Archive_Date__C = ' + tDate;       
        List<Sales_Rep_Best_Guess__c> lstSRBG = Database.query(strRepQuery);
        List<Historical_Sales_Rep_Best_Guess__c> lstHistSRBG = Database.query(strHistRepQuery);    
        Map<Id, List<Sales_Rep_Best_Guess__c>> mapRepBestGuess = new Map<Id, List<Sales_Rep_Best_Guess__c>>();
        Map<Id, List<Historical_Sales_Rep_Best_Guess__c>> mapHistRepBestGuess = new Map<Id, List<Historical_Sales_Rep_Best_Guess__c>>();
        Map<String,Map<String,Historical_Sales_Rep_Best_Guess__c>> tempHistRepMap = new Map<String,Map<String,Historical_Sales_Rep_Best_Guess__c>>();
        List<Historical_Sales_Rep_Best_Guess__c> insertHsbg = new List<Historical_Sales_Rep_Best_Guess__c>();
        for(Historical_Sales_Rep_Best_Guess__c h : lstHistSRBG) {
            if(!mapHistRepBestGuess.containsKey(h.OwnerId)){
                List<Historical_Sales_Rep_Best_Guess__c> tempLst = new List<Historical_Sales_Rep_Best_Guess__c>();
                tempLst.add(h);
                mapHistRepBestGuess.put(h.OwnerId, tempLst);
                Map<String,Historical_Sales_Rep_Best_Guess__c> tmp = new Map<String,Historical_Sales_Rep_Best_Guess__c>();
                tmp.put(h.Name,h);
                tempHistRepMap.put(h.OwnerId,tmp);
            }else{
                mapHistRepBestGuess.get(h.OwnerId).add(h);
                tempHistRepMap.get(h.OwnerId).put(h.name,h);
            }
        }
        for(Sales_Rep_Best_Guess__c s : lstSRBG) {
            if(!mapRepBestGuess.containsKey(s.OwnerId)){
                List<Sales_Rep_Best_Guess__c> tempLst = new List<Sales_Rep_Best_Guess__c>();
                tempLst.add(s);
                mapRepBestGuess.put(s.OwnerId, tempLst);
            }else{
                mapRepBestGuess.get(s.OwnerId).add(s);
            }
        }
        for(String mOwnerID : mapRepBestGuess.KeySet()) { 
            if(!managerIds.contains(mOwnerId)){
                bestGuessRow bgr = new bestGuessRow();
                insertHsbg = new List<Historical_Sales_Rep_Best_Guess__c>();
                for(Sales_Rep_Best_Guess__c m : mapRepBestGuess.get(mOwnerID)){
                    if(!tempHistRepMap.containsKey(mOwnerID) || (tempHistRepMap.get(mOwnerID)!=null && !tempHistRepMap.get(mOwnerID).containsKey(m.Name))){
                        Historical_Sales_Rep_Best_Guess__c hsbg = new Historical_Sales_Rep_Best_Guess__c();
                        hsbg.Archive_Date__c = Date.valueOf(tDate);
                        hsbg.Name = m.Name;
                        hsbg.Actual_Amount__c = m.Actual_Amount__c;
                        hsbg.OwnerId = m.OwnerId;
                        hsbg.Booked_Actual__c = m.Booked_Actual__c;
                        hsbg.Booked_Full_Proposal__c = m.Booked_Full_Proposal__c;
                        hsbg.Booked_Proposal__c = m.Booked_Proposal__c;
                        hsbg.Comments__c = m.Comments__c;
                        hsbg.Forecast_Contract__c = m.Forecast_Contract__c;
                        hsbg.Forecast_Proposal__c = m.Forecast_Proposal__c;
                        hsbg.Is_Manager__c = m.Is_Manager__c;
                        hsbg.IsMyTeam__c = m.IsMyTeam__c;
                        hsbg.Last_Entered_Date__c = m.Last_Entered_Date__c;
                        hsbg.Last_Entered_User__c = m.Last_Entered_User__c;
                        hsbg.M_A_Actual_Amount__c = m.M_A_Actual_Amount__c;
                        hsbg.M_A_Forecast_Contract__c = m.M_A_Forecast_Contract__c;
                        hsbg.M_A_Forecast_Proposal__c = m.M_A_Forecast_Proposal__c;
                        hsbg.Manager__c = m.Manager__c;
                        hsbg.Manager_1__c = m.Manager_1__c;
                        hsbg.Manager_2__c = m.Manager_2__c;
                        hsbg.Manager_3__c = m.Manager_3__c;
                        hsbg.Manager_Best_Guess__c = m.Manager_Best_Guess__c;
                        hsbg.M_A_Weighted_Forecast_Proposal__c = m.M_A_Weighted_Forecast_Proposal__c;
                        hsbg.M_B_Actual_Amount__c = m.M_B_Actual_Amount__c;
                        hsbg.M_B_Forecast_Contract__c = m.M_B_Forecast_Contract__c;
                        hsbg.M_B_Forecast_Proposal__c = m.M_B_Forecast_Proposal__c;
                        hsbg.M_B_Weighted_Forecast_Proposal__c = m.M_B_Weighted_Forecast_Proposal__c;
                        hsbg.M_D_Actual_Amount__c = m.M_D_Actual_Amount__c;
                        hsbg.M_D_Forecast_Contract__c = m.M_D_Forecast_Contract__c;
                        hsbg.M_D_Forecast_Proposal__c = m.M_D_Forecast_Proposal__c;
                        hsbg.M_D_Weighted_Forecast_Proposal__c = m.M_D_Weighted_Forecast_Proposal__c;
                        hsbg.Manufacturing_Audience_Best_Guess__c = m.Manufacturing_Audience_Best_Guess__c;
                        hsbg.M_A_Booked_Full_Proposal__c = m.M_A_Booked_Full_Proposal__c;
                        hsbg.M_A_Booked_Proposal__c = m.M_A_Booked_Proposal__c;
                        hsbg.M_A_Booked_Actual__c = m.M_A_Booked_Actual__c;
                        hsbg.Manufacturing_Audience_High__c = m.Manufacturing_Audience_High__c;
                        hsbg.Manufacturing_Audience_Low__c = m.Manufacturing_Audience_Low__c;
                        hsbg.Manufacturing_Base_Best_Guess__c = m.Manufacturing_Base_Best_Guess__c;
                        hsbg.M_B_Booked_Full_Proposal__c = m.M_B_Booked_Full_Proposal__c;
                        hsbg.M_B_Booked_Proposal__c = m.M_B_Booked_Proposal__c;
                        hsbg.M_B_Booked_Actual__c = m.M_B_Booked_Actual__c;
                        hsbg.Manufacturing_Base_High__c = m.Manufacturing_Base_High__c;
                        hsbg.Manufacturing_Base_Low__c = m.Manufacturing_Base_Low__c;
                        hsbg.Manufacturing_Digital_Best_Guess__c = m.Manufacturing_Digital_Best_Guess__c;
                        hsbg.M_D_Booked_Full_Proposal__c = m.M_D_Booked_Full_Proposal__c;
                        hsbg.M_D_Booked_Proposal__c = m.M_D_Booked_Proposal__c;
                        hsbg.M_D_Booked_Actual__c = m.M_D_Booked_Actual__c;
                        hsbg.Manufacturing_Digital_High__c = m.Manufacturing_Digital_High__c;
                        hsbg.Manufacturing_Digital_Low__c = m.Manufacturing_Digital_Low__c;
                        hsbg.Manufacturing_Mobile_Best_Guess__c = m.Manufacturing_Mobile_Best_Guess__c;
                        hsbg.M_M_Booked_Full_Proposal__c = m.M_M_Booked_Full_Proposal__c;
                        hsbg.M_M_Booked_Proposal__c = m.M_M_Booked_Proposal__c;
                        hsbg.M_M_Booked_Actual__c = m.M_M_Booked_Actual__c;
                        hsbg.Manufacturing_Mobile_High__c = m.Manufacturing_Mobile_High__c;
                        hsbg.Manufacturing_Mobile_Low__c = m.Manufacturing_Mobile_Low__c;
                        hsbg.M_M_Actual_Amount__c = m.M_M_Actual_Amount__c;
                        hsbg.M_M_Forecast_Contract__c = m.M_M_Forecast_Contract__c;
                        hsbg.M_M_Forecast_Proposal__c = m.M_M_Forecast_Proposal__c;
                        hsbg.M_M_Weighted_Forecast_Proposal__c = m.M_M_Weighted_Forecast_Proposal__c;
                        hsbg.Previous_Year_Actual__c = m.Previous_Year_Actual__c;
                        hsbg.Quarter__c = m.Quarter__c;
                        hsbg.Quarter_End_Date__c = m.Quarter_End_Date__c;
                        hsbg.Quarter_Start_Date__c = m.Quarter_Start_Date__c;
                        hsbg.Quota__c = m.Quota__c;
                        hsbg.R_A_Actual_Amount__c = m.R_A_Actual_Amount__c;
                        hsbg.R_A_Forecast_Contract__c = m.R_A_Forecast_Contract__c;
                        hsbg.R_A_Forecast_Proposal__c = m.R_A_Forecast_Proposal__c;
                        hsbg.R_A_Weighted_Forecast_Proposal__c = m.R_A_Weighted_Forecast_Proposal__c;
                        hsbg.R_B_Actual_Amount__c = m.R_B_Actual_Amount__c;
                        hsbg.R_B_Forecast_Contract__c = m.R_B_Forecast_Contract__c;
                        hsbg.R_B_Forecast_Proposal__c = m.R_B_Forecast_Proposal__c;
                        hsbg.R_B_Weighted_Forecast_Proposal__c = m.R_B_Weighted_Forecast_Proposal__c;
                        hsbg.R_D_Actual_Amount__c = m.R_D_Actual_Amount__c;
                        hsbg.R_D_Forecast_Contract__c = m.R_D_Forecast_Contract__c;
                        hsbg.R_D_Forecast_Proposal__c = m.R_D_Forecast_Proposal__c;
                        hsbg.R_D_Weighted_Forecast_Proposal__c = m.R_D_Weighted_Forecast_Proposal__c;
                        hsbg.Retail_Audience_Best_Guess__c = m.Retail_Audience_Best_Guess__c;
                        hsbg.R_A_Booked_Proposal__c = m.R_A_Booked_Proposal__c;
                        hsbg.R_A_Booked_Actual__c = m.R_A_Booked_Actual__c;
                        hsbg.Retail_Audience_High__c = m.Retail_Audience_High__c;
                        hsbg.Retail_Audience_Low__c = m.Retail_Audience_Low__c;
                        hsbg.Retail_Base_Best_Guess__c = m.Retail_Base_Best_Guess__c;
                        hsbg.R_B_Booked_Full_Proposal__c = m.R_B_Booked_Full_Proposal__c;
                        hsbg.R_B_Booked_Proposal__c = m.R_B_Booked_Proposal__c;
                        hsbg.R_B_Booked_Actual__c = m.R_B_Booked_Actual__c;
                        hsbg.Retail_Base_High__c = m.Retail_Base_High__c;
                        hsbg.Retail_Base_Low__c = m.Retail_Base_Low__c;
                        hsbg.Retail_Digital_Best_Guess__c = m.Retail_Digital_Best_Guess__c;
                        hsbg.R_D_Booked_Proposal__c = m.R_D_Booked_Proposal__c;
                        hsbg.R_D_Booked_Actual__c = m.R_D_Booked_Actual__c;
                        hsbg.Retail_Digital_High__c = m.Retail_Digital_High__c;
                        hsbg.Retail_Digital_Low__c = m.Retail_Digital_Low__c;
                        hsbg.Retail_Mobile_Best_Guess__c = m.Retail_Mobile_Best_Guess__c;
                        hsbg.R_M_Booked_Full_Proposal__c = m.R_M_Booked_Full_Proposal__c;
                        hsbg.R_M_Booked_Proposal__c = m.R_M_Booked_Proposal__c;
                        hsbg.R_M_Booked_Actual__c = m.R_M_Booked_Actual__c;
                        hsbg.Retail_Mobile_High__c = m.Retail_Mobile_High__c;
                        hsbg.Retail_Mobile_Low__c = m.Retail_Mobile_Low__c;
                        hsbg.R_M_Actual_Amount__c = m.R_M_Actual_Amount__c;
                        hsbg.R_M_Forecast_Contract__c = m.R_M_Forecast_Contract__c;
                        hsbg.R_M_Forecast_Proposal__c = m.R_M_Forecast_Proposal__c;
                        hsbg.R_M_Weighted_Forecast_Proposal__c = m.R_M_Weighted_Forecast_Proposal__c;
                        hsbg.R_A_Booked_Full_Proposal__c = m.R_A_Booked_Full_Proposal__c;
                        hsbg.R_D_Booked_Full_Proposal__c = m.R_D_Booked_Full_Proposal__c;
                        hsbg.Total_BG__c = m.Total_BG__c;
                        hsbg.Total_H__c = m.Total_H__c;
                        hsbg.Total_L__c = m.Total_L__c;
                        hsbg.Weighted_Forecast_Proposal__c = m.Weighted_Forecast_Proposal__c;
                        hsbg.Year__c = m.Year__c;
                        insertHsbg.add(hsbg);
                    }   
                } 
                if(insertHsbg.size()>0){
                    try{
                        insert insertHsbg;
                        for(Historical_Sales_Rep_Best_Guess__c h : insertHsbg) {
                            if(!mapHistRepBestGuess.containsKey(h.OwnerId)){
                                List<Historical_Sales_Rep_Best_Guess__c> tmp = new List<Historical_Sales_Rep_Best_Guess__c>();
                                tmp.add(h);
                                mapHistRepBestGuess.put(h.OwnerId,tmp);
                            }else{
                                mapHistRepBestGuess.get(h.OwnerId).add(h);
                            }
                        }
                    } catch (Exception e){}
                }
                bgr.name =  mapBestGuessUser.get(mOwnerId).Name;        
                bgr.teamSRBGList = new List<Sales_Rep_Best_Guess__c>();
                bgr.histSRBGList = new List<Historical_Sales_Rep_Best_Guess__c>();        
                bgr.teamSRBGList = mapRepBestGuess.get(mOwnerID);
                bgr.histSRBGList = mapHistRepBestGuess.get(mOwnerID);               
                bgr.bestGuess = 0;
                bgr.bookedAmount = 0;
                bgr.histBestGuess  = 0;
                bgr.histBookedAmount = 0;
                for(Sales_Rep_Best_Guess__c m : bgr.teamSRBGList){
                    if(m.Total_BG__c!=null){
                        bgr.bestGuess += m.Total_BG__c;
                    }
                    if(m.Booked_Actual__c!=null){
                        bgr.bookedAmount += m.Booked_Actual__c;
                    }
                }
                for(Historical_Sales_Rep_Best_Guess__c h : bgr.histSRBGList){
                    if(h.Total_BG__c!=null){
                        bgr.histBestGuess += h.Total_BG__c;
                    }
                    if(h.Booked_Actual__c!=null){
                        bgr.histBookedAmount += h.Booked_Actual__c;
                    }
                } 
                bgr.BGDifference = bgr.bestGuess - bgr.histBestGuess;
                bgr.bookedDifference = bgr.bookedAmount - bgr.histBookedAmount;
                bestGuessList.add(bgr);        
                sumBestGuess += bgr.bestGuess;
                sumHistBestGuess += bgr.histBestGuess;
                sumDiffBestGuess += bgr.BGDifference;
                sumBookedAmount += bgr.bookedAmount;
                sumHistBookedAmount += bgr.histBookedAmount;
                sumDiffBookedAmount += bgr.bookedDifference;
            }
        }
        bestGuessList.sort();
    }
    
    public boolean getRenderSelect(){    
        List<Profile> profiles = [SELECT ID, NAME FROM PROFILE];
        Set<Id> japanProfiles = new Set<Id>();
        for (Profile p : profiles){
            if (p.Name.contains('Japan')){
                japanProfiles.add(p.Id);
            }         
        }
        if(japanProfiles.contains(UserInfo.getProfileId())){
            return false;
        }
        else{
            return true;
        }    
    }
    
    //decide user best guess or account best guess
    public List<SelectOption> getBestGuessTypes(){
        List<SelectOption> lstReturn = new List<SelectOption>();
        lstReturn.add(new SelectOption('user','User Best Guess'));
        lstReturn.add(new SelectOption('account','Account Best Guess'));
        return lstReturn;
    }
    
    //refresh
    public PageReference refresh(){
        return null;
    }
    
    //Go button. redirect user to account
    public PageReference openBestGuess(){
        if(childAccount != 'All' && childAccount!=null){
             return new PageReference('/apex/AccountBestGuessSummary?scontrolCaching=1&id='+childAccount);        
        }else if(childAccount == 'All' && (congAccount !='All' && congAccount !=null)){
            return new PageReference('/apex/AccountBestGuessSummary?scontrolCaching=1&id='+congAccount);  
        }
       return null;
    }     
   
    //method to display account list.
    public List<SelectOption> getConglomerateAccounts(){
        t25Conglomerate.clear();
        t25Conglomerate.addAll(getTopConglomerates());
        List<SelectOption> accountReturn = new List<SelectOption>();
        List<Account> acc = [SELECT id, Name FROM Account WHERE ID IN : t25Conglomerate];
        accountReturn.add(new SelectOption('All','All'));
        for(Account account : acc){
            accountReturn.add(new SelectOption(account.Id, account.Name));
        }
        return accountReturn;
    }    
    
    //method to clear cbg list or set child account variable value.
    public void conglomerateAccountBestGuess(){
    }
    
    public Set<Id> getTopConglomerates(){
      set<Id> topConglomerate = new Set<Id>();
      for( Client_Rating_Setting_Obj__c  a : [select id,Account__c from Client_Rating_Setting_Obj__c]){
         topConglomerate.add(a.Account__c);
        }        
        return topConglomerate; 
    }
    
    //method to display Child account list.
    public List<SelectOption> getChildAccounts(){
        List<SelectOption> accountReturn = new List<SelectOption>();
        accountReturn.clear();
        if(congAccount == 'All' || congAccount == null){
            List<Account> childAccountList = [select id, Name from Account where Type !=:'Conglomerate' and parent.id in : t25Conglomerate and (RecordType.Name='Manufacturing' OR RecordType.Name='Retail') and OwnerID != '005F0000001vlDv' order by Name LIMIT 999];
            for(Account account : childAccountList){
                accountReturn.add(new SelectOption(account.Id, account.Name));
            }
        }else if(congAccount!=null && congAccount!='All'){
            List<Account> childAccountList = [select id, Name from Account where ParentID = :congAccount and OwnerID != '005F0000001vlDv' and OwnerID != '005F0000001vlDv' order by Name LIMIT 998];
            // Get the list of BG Summaries
            list<Conglomerate_Account_Best_Guess_Summary__c> CABGR =
                new list<Conglomerate_Account_Best_Guess_Summary__c>();
            CABGR = [   SELECT Id
                        FROM Conglomerate_Account_Best_Guess_Summary__c
                        WHERE Account__c = :congAccount];
            //If there are any then show the All Option in the list    
            if(CABGR.size() > 0){
                //add this to the list if the person that is accessing the listhas access to the conglomerate best guesses.
                accountReturn.add(new SelectOption('All','All'));
            }
            for(Account account : childAccountList){
                accountReturn.add(new SelectOption(account.Id, account.Name));
            }
        }
        return accountReturn;
    }
    
    //method to display Conglomerate Account Best Guess table.
    public List<Conglomerate_Account_Best_Guess_Summary__c> getConglomerateAccount(){
        List<Conglomerate_Account_Best_Guess_Summary__c> cbg = new List<Conglomerate_Account_Best_Guess_Summary__c>();
        cbg.clear();
        if((childAccount == 'All' || childAccount ==null) && (congAccount == null || congAccount == 'All')){
            if(cbg!=null)cbg.clear();
            List<ID> allsearchAccountList = new List<ID>();
            List<Account> childAccountList = [select id, Name from Account where Type !=:'Conglomerate' and (RecordType.Name='Manufacturing' OR RecordType.Name='Retail') and OwnerID != '005F0000001vlDv' order by Name LIMIT 999];
            for(Account a:childAccountList){
                allsearchAccountList.add(a.Id);
            }                        
            cbg = [select 
                    Id, Delivery_Channel__c,  Name, Booked_Q1__c, Booked_Q2__c, Booked_Q3__c,
                    Booked_Q4__c, Account__c, Year__c, Q1__c, Q2__c, Q3__c, Q4__c,Booked_Wgt_Q1__c,
                    Booked_Wgt_Q2__c,Booked_Wgt_Q3__c, Booked_Wgt_Q4__c,Booked_Full_Q1__c,
                    Booked_Full_Q2__c,Booked_Full_Q3__c,Booked_Full_Q4__c 
                    from Conglomerate_Account_Best_Guess_Summary__c 
                    where Account__c IN : allsearchAccountList  order by Delivery_Channel__c,Year__c asc limit 1000];
            }else if(congAccount != 'All' && (childAccount == 'All' || childAccount == null)){
                if(cbg!=null)cbg.clear();
                List<ID> accID = new List<ID>();
                accID.add(congAccount);
                List<account> congChildAccounts = [select Id from Account where ParentId =:congAccount];
                for(Account acct : congChildAccounts){
                    accID.add(acct.id);
                }
                cbg = [select 
                        Id, Delivery_Channel__c,  Name, Booked_Q1__c, Booked_Q2__c, Booked_Q3__c, 
                        Booked_Q4__c, Account__c, Year__c, Q1__c, Q2__c, Q3__c, Q4__c,Booked_Wgt_Q1__c,
                        Booked_Wgt_Q2__c,Booked_Wgt_Q3__c, Booked_Wgt_Q4__c,Booked_Full_Q1__c,
                        Booked_Full_Q2__c,Booked_Full_Q3__c,Booked_Full_Q4__c 
                        from Conglomerate_Account_Best_Guess_Summary__c 
                        where Account__c IN : accID order by Delivery_Channel__c,Year__c asc limit 1000];
            }else if( childAccount != 'All' && childAccount != null){
                if(cbg!=null)cbg.clear();
                cbg = [select 
                        Id, Delivery_Channel__c,  Name, Booked_Q1__c, Booked_Q2__c, Booked_Q3__c, 
                        Booked_Q4__c, Account__c, Year__c, Q1__c, Q2__c, Q3__c, Q4__c,Booked_Wgt_Q1__c,
                        Booked_Wgt_Q2__c,Booked_Wgt_Q3__c, Booked_Wgt_Q4__c,Booked_Full_Q1__c,
                        Booked_Full_Q2__c,Booked_Full_Q3__c,Booked_Full_Q4__c 
                        from Conglomerate_Account_Best_Guess_Summary__c 
                        where Account__c = : childAccount order by Delivery_Channel__c,Year__c asc limit 1000];
            }else{
                if(cbg!=null)cbg.clear();
            }
        return cbg;
    }
    
    //copy best guess to account best guess summary
    public PageReference copyAccBGS(){
        Map<String,Account_Best_Guess_Summary__c> accBGSMap = new Map<String,Account_Best_Guess_Summary__c>();
        for(Account_Best_Guess_Summary__c accBGS : [SELECT ID,Name,Account__c,Delivery_Channel__c,Q1__c,Q2__c,Q3__c,Q4__c,Year__c 
                                FROM Account_Best_Guess_Summary__c WHERE Account__c=:selectedAccId AND Year__c =:gstrGuessId]){
            if(accBGS.Delivery_Channel__c != null && !accBGSMap.containsKey(accBGS.Delivery_Channel__c)){
                accBGSMap.put(accBGS.Delivery_Channel__c,accBGS);
            }
        }
        if(gstrSave != null && selectedAccId != null && selectedAccId.startsWith('001')){
            List<Account_Best_Guess_Summary__c> upsertAccBGS = new List<Account_Best_Guess_Summary__c>();
            String[] sarrSave = gstrSave.split(':');
            if(!isGridManBestGuess){
                if(isGridManufacturer){
                    if(accBGSMap != null && accBGSMap.containsKey('Base')){
                        Account_Best_Guess_Summary__c accBGS = accBGSMap.get('Base');
                        if(!q1Edit){try{accBGS.Q1__c = Decimal.valueOf(sarrSave[0]);}catch(Exception e){}}
                        if(!q2Edit){try{accBGS.Q2__c = Decimal.valueOf(sarrSave[2]);}catch(Exception e){}}
                        if(!q3Edit){try{accBGS.Q3__c = Decimal.valueOf(sarrSave[4]);}catch(Exception e){}}
                        if(!q4Edit){try{accBGS.Q4__c = Decimal.valueOf(sarrSave[6]);}catch(Exception e){}}
                        upsertAccBGS.add(accBGS);
                    }else{
                        Account_Best_Guess_Summary__c accBGS = new Account_Best_Guess_Summary__c();
                        accBGS.Delivery_Channel__c = 'Base';
                        accBGS.Year__c = gstrGuessId;
                        accBGS.Account__c = selectedAccId;
                        if(!q1Edit){try{accBGS.Q1__c = Decimal.valueOf(sarrSave[0]);}catch(Exception e){}}
                        if(!q2Edit){try{accBGS.Q2__c = Decimal.valueOf(sarrSave[2]);}catch(Exception e){}}
                        if(!q3Edit){try{accBGS.Q3__c = Decimal.valueOf(sarrSave[4]);}catch(Exception e){}}
                        if(!q4Edit){try{accBGS.Q4__c = Decimal.valueOf(sarrSave[6]);}catch(Exception e){}}
                        upsertAccBGS.add(accBGS);
                    }
                    if(accBGSMap != null && accBGSMap.containsKey('Digital O&O')){
                        Account_Best_Guess_Summary__c accBGS = accBGSMap.get('Digital O&O');
                        if(!q1Edit){try{accBGS.Q1__c = Decimal.valueOf(sarrSave[16]);}catch(Exception e){}}
                        if(!q2Edit){try{accBGS.Q2__c = Decimal.valueOf(sarrSave[18]);}catch(Exception e){}}
                        if(!q3Edit){try{accBGS.Q3__c = Decimal.valueOf(sarrSave[20]);}catch(Exception e){}}
                        if(!q4Edit){try{accBGS.Q4__c = Decimal.valueOf(sarrSave[22]);}catch(Exception e){}}
                        upsertAccBGS.add(accBGS);
                    }else{
                        Account_Best_Guess_Summary__c accBGS = new Account_Best_Guess_Summary__c();
                        accBGS.Delivery_Channel__c = 'Digital O&O';
                        accBGS.Year__c = gstrGuessId;
                        accBGS.Account__c = selectedAccId;
                        if(!q1Edit){try{accBGS.Q1__c = Decimal.valueOf(sarrSave[16]);}catch(Exception e){}}
                        if(!q2Edit){try{accBGS.Q2__c = Decimal.valueOf(sarrSave[18]);}catch(Exception e){}}
                        if(!q3Edit){try{accBGS.Q3__c = Decimal.valueOf(sarrSave[20]);}catch(Exception e){}}
                        if(!q4Edit){try{accBGS.Q4__c = Decimal.valueOf(sarrSave[22]);}catch(Exception e){}}
                        upsertAccBGS.add(accBGS);
                    }
                    if(accBGSMap != null && accBGSMap.containsKey('Audience Network')){
                        Account_Best_Guess_Summary__c accBGS = accBGSMap.get('Audience Network');
                        if(!q1Edit){try{accBGS.Q1__c = Decimal.valueOf(sarrSave[32]);}catch(Exception e){}}
                        if(!q2Edit){try{accBGS.Q2__c = Decimal.valueOf(sarrSave[34]);}catch(Exception e){}}
                        if(!q3Edit){try{accBGS.Q3__c = Decimal.valueOf(sarrSave[36]);}catch(Exception e){}}
                        if(!q4Edit){try{accBGS.Q4__c = Decimal.valueOf(sarrSave[38]);}catch(Exception e){}}
                        upsertAccBGS.add(accBGS);
                    }else{
                        Account_Best_Guess_Summary__c accBGS = new Account_Best_Guess_Summary__c();
                        accBGS.Delivery_Channel__c = 'Audience Network';
                        accBGS.Year__c = gstrGuessId;
                        accBGS.Account__c = selectedAccId;
                        if(!q1Edit){try{accBGS.Q1__c = Decimal.valueOf(sarrSave[32]);}catch(Exception e){}}
                        if(!q2Edit){try{accBGS.Q2__c = Decimal.valueOf(sarrSave[34]);}catch(Exception e){}}
                        if(!q3Edit){try{accBGS.Q3__c = Decimal.valueOf(sarrSave[36]);}catch(Exception e){}}
                        if(!q4Edit){try{accBGS.Q4__c = Decimal.valueOf(sarrSave[38]);}catch(Exception e){}}
                        upsertAccBGS.add(accBGS);
                    }
                    if(accBGSMap != null && accBGSMap.containsKey('Mobile')){
                        Account_Best_Guess_Summary__c accBGS = accBGSMap.get('Mobile');
                        if(!q1Edit){try{accBGS.Q1__c = Decimal.valueOf(sarrSave[48]);}catch(Exception e){}}
                        if(!q2Edit){try{accBGS.Q2__c = Decimal.valueOf(sarrSave[50]);}catch(Exception e){}}
                        if(!q3Edit){try{accBGS.Q3__c = Decimal.valueOf(sarrSave[52]);}catch(Exception e){}}
                        if(!q4Edit){try{accBGS.Q4__c = Decimal.valueOf(sarrSave[54]);}catch(Exception e){}}
                        upsertAccBGS.add(accBGS);
                    }else{
                        Account_Best_Guess_Summary__c accBGS = new Account_Best_Guess_Summary__c();
                        accBGS.Delivery_Channel__c = 'Mobile';
                        accBGS.Year__c = gstrGuessId;
                        accBGS.Account__c = selectedAccId;
                        if(!q1Edit){try{accBGS.Q1__c = Decimal.valueOf(sarrSave[48]);}catch(Exception e){}}
                        if(!q2Edit){try{accBGS.Q2__c = Decimal.valueOf(sarrSave[50]);}catch(Exception e){}}
                        if(!q3Edit){try{accBGS.Q3__c = Decimal.valueOf(sarrSave[52]);}catch(Exception e){}}
                        if(!q4Edit){try{accBGS.Q4__c = Decimal.valueOf(sarrSave[54]);}catch(Exception e){}}
                        upsertAccBGS.add(accBGS);
                    }
                } else {
                    if(accBGSMap != null && accBGSMap.containsKey('Base')){
                        Account_Best_Guess_Summary__c accBGS = accBGSMap.get('Base');
                        if(!q1Edit){try{accBGS.Q1__c = Decimal.valueOf(sarrSave[1]);}catch(Exception e){}}
                        if(!q2Edit){try{accBGS.Q2__c = Decimal.valueOf(sarrSave[3]);}catch(Exception e){}}
                        if(!q3Edit){try{accBGS.Q3__c = Decimal.valueOf(sarrSave[5]);}catch(Exception e){}}
                        if(!q4Edit){try{accBGS.Q4__c = Decimal.valueOf(sarrSave[7]);}catch(Exception e){}}
                        upsertAccBGS.add(accBGS);
                    }else{
                        Account_Best_Guess_Summary__c accBGS = new Account_Best_Guess_Summary__c();
                        accBGS.Delivery_Channel__c = 'Base';
                        accBGS.Year__c = gstrGuessId;
                        accBGS.Account__c = selectedAccId;
                        if(!q1Edit){try{accBGS.Q1__c = Decimal.valueOf(sarrSave[1]);}catch(Exception e){}}
                        if(!q2Edit){try{accBGS.Q2__c = Decimal.valueOf(sarrSave[3]);}catch(Exception e){}}
                        if(!q3Edit){try{accBGS.Q3__c = Decimal.valueOf(sarrSave[5]);}catch(Exception e){}}
                        if(!q4Edit){try{accBGS.Q4__c = Decimal.valueOf(sarrSave[7]);}catch(Exception e){}}
                        upsertAccBGS.add(accBGS);
                    }
                    if(accBGSMap != null && accBGSMap.containsKey('Digital O&O')){
                        Account_Best_Guess_Summary__c accBGS = accBGSMap.get('Digital O&O');
                        if(!q1Edit){try{accBGS.Q1__c = Decimal.valueOf(sarrSave[17]);}catch(Exception e){}}
                        if(!q2Edit){try{accBGS.Q2__c = Decimal.valueOf(sarrSave[19]);}catch(Exception e){}}
                        if(!q3Edit){try{accBGS.Q3__c = Decimal.valueOf(sarrSave[21]);}catch(Exception e){}}
                        if(!q4Edit){try{accBGS.Q4__c = Decimal.valueOf(sarrSave[23]);}catch(Exception e){}}
                        upsertAccBGS.add(accBGS);
                    }else{
                        Account_Best_Guess_Summary__c accBGS = new Account_Best_Guess_Summary__c();
                        accBGS.Delivery_Channel__c = 'Digital O&O';
                        accBGS.Year__c = gstrGuessId;
                        accBGS.Account__c = selectedAccId;
                        if(!q1Edit){try{accBGS.Q1__c = Decimal.valueOf(sarrSave[17]);}catch(Exception e){}}
                        if(!q2Edit){try{accBGS.Q2__c = Decimal.valueOf(sarrSave[19]);}catch(Exception e){}}
                        if(!q3Edit){try{accBGS.Q3__c = Decimal.valueOf(sarrSave[21]);}catch(Exception e){}}
                        if(!q4Edit){try{accBGS.Q4__c = Decimal.valueOf(sarrSave[23]);}catch(Exception e){}}
                        upsertAccBGS.add(accBGS);
                    }
                    if(accBGSMap != null && accBGSMap.containsKey('Audience Network')){
                        Account_Best_Guess_Summary__c accBGS = accBGSMap.get('Audience Network');
                        if(!q1Edit){try{accBGS.Q1__c = Decimal.valueOf(sarrSave[33]);}catch(Exception e){}}
                        if(!q2Edit){try{accBGS.Q2__c = Decimal.valueOf(sarrSave[35]);}catch(Exception e){}}
                        if(!q3Edit){try{accBGS.Q3__c = Decimal.valueOf(sarrSave[37]);}catch(Exception e){}}
                        if(!q4Edit){try{accBGS.Q4__c = Decimal.valueOf(sarrSave[39]);}catch(Exception e){}}
                        upsertAccBGS.add(accBGS);
                    }else{
                        Account_Best_Guess_Summary__c accBGS = new Account_Best_Guess_Summary__c();
                        accBGS.Delivery_Channel__c = 'Audience Network';
                        accBGS.Year__c = gstrGuessId;
                        accBGS.Account__c = selectedAccId;
                        if(!q1Edit){try{accBGS.Q1__c = Decimal.valueOf(sarrSave[33]);}catch(Exception e){}}
                        if(!q2Edit){try{accBGS.Q2__c = Decimal.valueOf(sarrSave[35]);}catch(Exception e){}}
                        if(!q3Edit){try{accBGS.Q3__c = Decimal.valueOf(sarrSave[37]);}catch(Exception e){}}
                        if(!q4Edit){try{accBGS.Q4__c = Decimal.valueOf(sarrSave[39]);}catch(Exception e){}}
                        upsertAccBGS.add(accBGS);
                    }
                    if(accBGSMap != null && accBGSMap.containsKey('Mobile')){
                        Account_Best_Guess_Summary__c accBGS = accBGSMap.get('Mobile');
                        if(!q1Edit){try{accBGS.Q1__c = Decimal.valueOf(sarrSave[49]);}catch(Exception e){}}
                        if(!q2Edit){try{accBGS.Q2__c = Decimal.valueOf(sarrSave[51]);}catch(Exception e){}}
                        if(!q3Edit){try{accBGS.Q3__c = Decimal.valueOf(sarrSave[53]);}catch(Exception e){}}
                        if(!q4Edit){try{accBGS.Q4__c = Decimal.valueOf(sarrSave[55]);}catch(Exception e){}}
                        upsertAccBGS.add(accBGS);
                    }else{
                        Account_Best_Guess_Summary__c accBGS = new Account_Best_Guess_Summary__c();
                        accBGS.Delivery_Channel__c = 'Mobile';
                        accBGS.Year__c = gstrGuessId;
                        accBGS.Account__c = selectedAccId;
                        if(!q1Edit){try{accBGS.Q1__c = Decimal.valueOf(sarrSave[49]);}catch(Exception e){}}
                        if(!q2Edit){try{accBGS.Q2__c = Decimal.valueOf(sarrSave[51]);}catch(Exception e){}}
                        if(!q3Edit){try{accBGS.Q3__c = Decimal.valueOf(sarrSave[53]);}catch(Exception e){}}
                        if(!q4Edit){try{accBGS.Q4__c = Decimal.valueOf(sarrSave[55]);}catch(Exception e){}}
                        upsertAccBGS.add(accBGS);
                    }
                }
            }
            if(upsertAccBGS.size()>0){
                upsert upsertAccBGS;
            }
        }
        return null;
    }
    
    //Returns the list of Accounts for the FlexBox to use
    public String getAccountsList(){
        List<Account> lstAccs;
        if(gstrSectionType=='Manufacturer'){
            lstAccs = [SELECT Id,Name FROM Account Where RecordType.Name='Manufacturing' AND Type !='Conglomerate' ORDER BY Name asc];
        } else if(gstrSectionType=='Retail'){
            lstAccs = [SELECT Id,Name FROM Account Where RecordType.Name='Retail' AND Type !='Conglomerate' ORDER BY Name asc];
        }
        FlexItemSource fis = new FlexItemSource();
        List<FlexItem> lstFL = new list<FlexItem>();
        for(Account acc : lstAccs){
            FlexItem fl = new FlexItem();
            fl.id = acc.id;
            fl.name = acc.Name;
            lstFL.add(fl);
        }
        fis.results = lstFL;
        return JSON.serialize(fis);
    }
    
    //method to display delivery channel field on page
    public List<SelectOption> getDeliveryChannel(){
        List<SelectOption> lstReturn = new List<SelectOption>();
        lstReturn.add(new SelectOption('Total', 'Total'));
        lstReturn.add(new SelectOption('All', 'All'));
        lstReturn.add(new SelectOption('Base', 'Base'));
        lstReturn.add(new SelectOption('Digital', 'Digital'));
        lstReturn.add(new SelectOption('Audience Network', 'Audience Network'));
        lstReturn.add(new SelectOption('Mobile', 'Mobile'));
        return lstReturn;
    }
    
    //search revenue based on year and delivery channel
    public PageReference searchRevenue(){
        delChannelWrapperLst = new List<BestGuessRevenueUtil.DeliveryChannelWrapper>();
        q1Booked = 0;
        q2Booked = 0;
        q3Booked = 0;
        q4Booked = 0;
        q1BookedWgt = 0;
        q2BookedWgt = 0;
        q3BookedWgt = 0;
        q4BookedWgt = 0;
        q1BookedFull = 0;
        q2BookedFull = 0;
        q3BookedFull = 0;
        q4BookedFull = 0;
        bookedTotal = 0;
        bookedWgtTotal = 0;
        bookedFullTotal = 0;
        if(isManBestGuess){
            if(isGridManufacturer){
                delChannelWrapperLst = BestGuessRevenueUtil.getMBGManufacturerWrapper(gmbgList);
                for(BestGuessRevenueUtil.DeliveryChannelWrapper dw : delChannelWrapperLst){
                    if(selDeliveryChannel != '' && selDeliveryChannel != null && selDeliveryChannel != 'All' 
                                && selDeliveryChannel != 'Total' && dw.dChannel == selDeliveryChannel){
                        q1Booked += dw.bookedQ1;
                        q2Booked += dw.bookedQ2;
                        q3Booked += dw.bookedQ3;
                        q4Booked += dw.bookedQ4;
                        q1BookedWgt += dw.bookedWgtQ1;
                        q2BookedWgt += dw.bookedWgtQ2;
                        q3BookedWgt += dw.bookedWgtQ3;
                        q4BookedWgt += dw.bookedWgtQ4;
                        q1BookedFull += dw.bookedFullQ1;
                        q2BookedFull += dw.bookedFullQ2;
                        q3BookedFull += dw.bookedFullQ3;
                        q4BookedFull += dw.bookedFullQ4;
                        bookedTotal += dw.bookedTotal;
                        bookedWgtTotal += dw.bookedWgtTotal;
                        bookedFullTotal += dw.bookedFullTotal;
                    }
                    if(selDeliveryChannel != '' && selDeliveryChannel != null && (selDeliveryChannel == 'Total' 
                                || selDeliveryChannel == 'All')){
                        q1Booked += dw.bookedQ1;
                        q2Booked += dw.bookedQ2;
                        q3Booked += dw.bookedQ3;
                        q4Booked += dw.bookedQ4;
                        q1BookedWgt += dw.bookedWgtQ1;
                        q2BookedWgt += dw.bookedWgtQ2;
                        q3BookedWgt += dw.bookedWgtQ3;
                        q4BookedWgt += dw.bookedWgtQ4;
                        q1BookedFull += dw.bookedFullQ1;
                        q2BookedFull += dw.bookedFullQ2;
                        q3BookedFull += dw.bookedFullQ3;
                        q4BookedFull += dw.bookedFullQ4;
                        bookedTotal += dw.bookedTotal;
                        bookedWgtTotal += dw.bookedWgtTotal;
                        bookedFullTotal += dw.bookedFullTotal;
                    }
                }
            }else{
                delChannelWrapperLst = BestGuessRevenueUtil.getMBGRetailWrapper(gmbgList);
                for(BestGuessRevenueUtil.DeliveryChannelWrapper dw : delChannelWrapperLst){
                    if(selDeliveryChannel != '' && selDeliveryChannel != null && selDeliveryChannel != 'All' 
                                && selDeliveryChannel != 'Total' && dw.dChannel == selDeliveryChannel){
                        q1Booked += dw.bookedQ1;
                        q2Booked += dw.bookedQ2;
                        q3Booked += dw.bookedQ3;
                        q4Booked += dw.bookedQ4;
                        q1BookedWgt += dw.bookedWgtQ1;
                        q2BookedWgt += dw.bookedWgtQ2;
                        q3BookedWgt += dw.bookedWgtQ3;
                        q4BookedWgt += dw.bookedWgtQ4;
                        q1BookedFull += dw.bookedFullQ1;
                        q2BookedFull += dw.bookedFullQ2;
                        q3BookedFull += dw.bookedFullQ3;
                        q4BookedFull += dw.bookedFullQ4;
                        bookedTotal += dw.bookedTotal;
                        bookedWgtTotal += dw.bookedWgtTotal;
                        bookedFullTotal += dw.bookedFullTotal;
                    }
                    if(selDeliveryChannel != '' && selDeliveryChannel != null && (selDeliveryChannel == 'Total' 
                                || selDeliveryChannel == 'All')){
                        q1Booked += dw.bookedQ1;
                        q2Booked += dw.bookedQ2;
                        q3Booked += dw.bookedQ3;
                        q4Booked += dw.bookedQ4;
                        q1BookedWgt += dw.bookedWgtQ1;
                        q2BookedWgt += dw.bookedWgtQ2;
                        q3BookedWgt += dw.bookedWgtQ3;
                        q4BookedWgt += dw.bookedWgtQ4;
                        q1BookedFull += dw.bookedFullQ1;
                        q2BookedFull += dw.bookedFullQ2;
                        q3BookedFull += dw.bookedFullQ3;
                        q4BookedFull += dw.bookedFullQ4;
                        bookedTotal += dw.bookedTotal;
                        bookedWgtTotal += dw.bookedWgtTotal;
                        bookedFullTotal += dw.bookedFullTotal;
                    }
                }
            }
        }else{
            if(isGridManufacturer){
                delChannelWrapperLst = BestGuessRevenueUtil.getSRBGManufacturerWrapper(gsrbgList);
                for(BestGuessRevenueUtil.DeliveryChannelWrapper dw : delChannelWrapperLst){
                    if(selDeliveryChannel != '' && selDeliveryChannel != null && selDeliveryChannel != 'All' 
                                && selDeliveryChannel != 'Total' && dw.dChannel == selDeliveryChannel){
                        q1Booked += dw.bookedQ1;
                        q2Booked += dw.bookedQ2;
                        q3Booked += dw.bookedQ3;
                        q4Booked += dw.bookedQ4;
                        q1BookedWgt += dw.bookedWgtQ1;
                        q2BookedWgt += dw.bookedWgtQ2;
                        q3BookedWgt += dw.bookedWgtQ3;
                        q4BookedWgt += dw.bookedWgtQ4;
                        q1BookedFull += dw.bookedFullQ1;
                        q2BookedFull += dw.bookedFullQ2;
                        q3BookedFull += dw.bookedFullQ3;
                        q4BookedFull += dw.bookedFullQ4;
                        bookedTotal += dw.bookedTotal;
                        bookedWgtTotal += dw.bookedWgtTotal;
                        bookedFullTotal += dw.bookedFullTotal;
                    }
                    if(selDeliveryChannel != '' && selDeliveryChannel != null && (selDeliveryChannel == 'Total' 
                                || selDeliveryChannel == 'All')){
                        q1Booked += dw.bookedQ1;
                        q2Booked += dw.bookedQ2;
                        q3Booked += dw.bookedQ3;
                        q4Booked += dw.bookedQ4;
                        q1BookedWgt += dw.bookedWgtQ1;
                        q2BookedWgt += dw.bookedWgtQ2;
                        q3BookedWgt += dw.bookedWgtQ3;
                        q4BookedWgt += dw.bookedWgtQ4;
                        q1BookedFull += dw.bookedFullQ1;
                        q2BookedFull += dw.bookedFullQ2;
                        q3BookedFull += dw.bookedFullQ3;
                        q4BookedFull += dw.bookedFullQ4;
                        bookedTotal += dw.bookedTotal;
                        bookedWgtTotal += dw.bookedWgtTotal;
                        bookedFullTotal += dw.bookedFullTotal;
                    }
                }
            }else{
                delChannelWrapperLst = BestGuessRevenueUtil.getSRBGRetailWrapper(gsrbgList);
                for(BestGuessRevenueUtil.DeliveryChannelWrapper dw : delChannelWrapperLst){
                    if(selDeliveryChannel != '' && selDeliveryChannel != null && selDeliveryChannel != 'All' 
                                && selDeliveryChannel != 'Total' && dw.dChannel == selDeliveryChannel){
                        q1Booked += dw.bookedQ1;
                        q2Booked += dw.bookedQ2;
                        q3Booked += dw.bookedQ3;
                        q4Booked += dw.bookedQ4;
                        q1BookedWgt += dw.bookedWgtQ1;
                        q2BookedWgt += dw.bookedWgtQ2;
                        q3BookedWgt += dw.bookedWgtQ3;
                        q4BookedWgt += dw.bookedWgtQ4;
                        q1BookedFull += dw.bookedFullQ1;
                        q2BookedFull += dw.bookedFullQ2;
                        q3BookedFull += dw.bookedFullQ3;
                        q4BookedFull += dw.bookedFullQ4;
                        bookedTotal += dw.bookedTotal;
                        bookedWgtTotal += dw.bookedWgtTotal;
                        bookedFullTotal += dw.bookedFullTotal;
                    }
                    if(selDeliveryChannel != '' && selDeliveryChannel != null && (selDeliveryChannel == 'Total' 
                                || selDeliveryChannel == 'All')){
                        q1Booked += dw.bookedQ1;
                        q2Booked += dw.bookedQ2;
                        q3Booked += dw.bookedQ3;
                        q4Booked += dw.bookedQ4;
                        q1BookedWgt += dw.bookedWgtQ1;
                        q2BookedWgt += dw.bookedWgtQ2;
                        q3BookedWgt += dw.bookedWgtQ3;
                        q4BookedWgt += dw.bookedWgtQ4;
                        q1BookedFull += dw.bookedFullQ1;
                        q2BookedFull += dw.bookedFullQ2;
                        q3BookedFull += dw.bookedFullQ3;
                        q4BookedFull += dw.bookedFullQ4;
                        bookedTotal += dw.bookedTotal;
                        bookedWgtTotal += dw.bookedWgtTotal;
                        bookedFullTotal += dw.bookedFullTotal;
                    }
                }
            }
        }
        return null;
    }
    
    //Class to represent flexbox item that will be used in JSON for the flexboxes
    public class FlexItem{
        public String id {get;set;}
        public String name {get;set;}
    }
    
    //Class to represent flexbox source
    public class FlexItemSource{
        public List<FlexItem> results {get;set;}
    }           
}