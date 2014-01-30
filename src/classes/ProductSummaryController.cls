/*###################################### 
#Contoller Name: ProductSummaryController
#Created Date: 10-22-12 
#Questions: customersuccess@cloud62.com
#LastModified Date: 10-22-12 
#Description: Display all the Products 
#www.cloud62.com
######################################## 
*/
public with sharing class ProductSummaryController {
    
    //variables
    public Product__c products{get; set;}  
    public String selectCountry{get;set;}
    public List<Product__c> productFilterList{get; set;}
    public String sortField {get; set;}
    public String previousSortField {get; set;}
    public String sortOrder {get;set;}
    
    public ProductSummaryController(ApexPages.StandardController controller) {
        this.products = (Product__c)controller.getRecord();        
        productFilterList = [select Id, Name, Product_Family__c, Country__c, Executive_Sponsor__c, OwnerId, Category__c from Product__c limit 50];
    }
       
    // get the Geography or Country picklist values
    public List<SelectOption> getCountryOptions(){
        List<SelectOption> lstReturn = new List<SelectOption>();
        lstReturn.add(new SelectOption('--None--','--None--'));
        Schema.DescribeFieldResult f = Schema.sObjectType.Product__c.fields.Country__c;
        for(Schema.PicklistEntry p :f.getPicklistValues()){
            lstReturn.add(new SelectOption(p.getValue(),p.getLabel()));
        }
        return lstReturn;
   }
    
    //search the product based on the criteria
    public PageReference searchProduct(){
        sortField = '';        
        String query = 'select Id, Name, Product_Family__c, Country__c, Executive_Sponsor__c, OwnerId, Category__c from Product__c where ';
        query = buildQuery(query);
        productFilterList = Database.query(query);
        if(productFilterList.size()==0){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Info,'There is no record found. Please refine your search criteria.'));
            return null;
        }
        return null;
    }
    
    //reset all the fields values
    public pageReference reset(){
        products = new Product__c();
        selectCountry = '--None--';
        productFilterList = [select Id, Name, Product_Family__c, Country__c, Executive_Sponsor__c, OwnerId, Category__c from Product__c limit 50];
        return null;    
    }
    
    //build dynamic querystring (SOQL)
    private String buildQuery(String query){
        if(products.Name!=null){
            query = query + ' Name LIKE \'%' +products.Name+ '%\'' + ' AND';            
        }
        if(products.Product_Family__c!=null){
            query = query + ' Product_Family__c =\'' +products.Product_Family__c+ '\'' + ' AND';            
        }
        if(selectCountry!=null && selectCountry!='--None--'){
            query = query + ' Country__c INCLUDES(\'' +selectCountry+'\')' + ' AND';            
        }
        if(products.Executive_Sponsor__c!=null){
            query = query + ' Executive_Sponsor__c =\'' +products.Executive_Sponsor__c+'\'' + ' AND';            
        }
        if(products.OwnerId!=null){
            query = query + ' OwnerId =\'' +products.OwnerId+'\'' + ' AND';            
        }
        if(products.Category__c!=null){
            query = query + ' Category__c =\'' +products.Category__c+'\'' + ' AND';            
        }
        //remove last AND operator
        query = query .substring(0, query.length()-3);
        query = query +' LIMIT 50';
        system.debug('query??'+query);
        return query;
    }
    
    //sorting
    public void doSort(){
        String order = 'asc';
        
        /*This checks to see if the same header was click two times in a row, if so 
        it switches the order.*/
        if(previousSortField == sortField){
            order = 'desc';
            previousSortField = null;
        }else{
            previousSortField = sortField;
        }
        sortOrder = order;
        //To sort the table we simply need to use this one line, nice!
        system.debug('sort field>'+ sortField);
        system.debug('display list>'+ productFilterList);
        system.debug('display order>'+ order);
        ProductSort.sortList(productFilterList,sortField,order);
        system.debug('sort field>>'+ sortField);
        system.debug('display list>>'+ productFilterList);
        system.debug('display order>>'+ order);
    }
    
}