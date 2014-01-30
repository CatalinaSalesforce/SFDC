/*
@Name           : ProductTrackerCls
@Author         : customersuccess@cloud62.com
@Date           : 01/17/2013
@Description    : Controller for displaying related list on product tracker objects
@Revision History

*/
public class ProductTrackerCls{

    //variables
    public String obj{get;set;}
    public String objectId{get;set;}
    public String recordType{get;set;}
    public String conditionField{get;set;}
    public Sobject s{get;set;}
    //map of api name and label
    //public Map<String,String> api_LabelMAP;   
    public List<String> fieldsList{get;set;}
    public String editId{get;set;}
    public String delId{get;set;}
    public String recordTypeId;
    public String objNameParam{get;set;}
    public String recTypeNameParam{get;set;}
    public String prodReleaseFeatureNameParam{get;set;}
    public List<String> fieldsLabel{get;set;}
    public List<String> fieldsName{get;set;}
    public List<FieldsTypeWrapper> fieldsTypeWrapperList{get;set;}
    
    /*
    @Name :ProductTrackerCls
    @Description :Default constructor used by component
    */
    public ProductTrackerCls(){
        //api_LabelMAP = new Map<String,String>();
    }

    /*
    @Name :ProductTrackerCls
    @Description :Standard controller constructor used by vf pages
    */
    public ProductTrackerCls(ApexPages.StandardController controller) {
         this.s = (Sobject) controller.getRecord();
         //api_LabelMAP = new Map<String,String>(); 

         getNotesAndAttachment();  

    }
    
    /*
    @Name :populateDisplayList
    @Description :Populate the dataList list for related list.
    */
    public void populateDisplayList(List<SObject> sObjList){
        for(Sobject s: sObjList){
            dataList.add(new DataDisplayWrapper(s));
        }
    }
    
    /*
    @Name :queryRecords
    @Description :Query the objects records
    */
    public List<SObject> queryRecords(String qry){
       List<SObject> sObjList = new List<sObject>();
      // try{
           sObjList = Database.query(qry);
     //   }catch(QueryException qex){
            //handle your exception here
     //   }catch(Exception ex){
            //handle your exception here
     //   }
        return sObjList;   
    }
    
    /*
    @Name :dataList
    @Description :dataList to use on VF page to disply the record values
    */
    public List<DataDisplayWrapper> dataList{
        get{
        if(dataList == null){
            String qry = 'Select '+getFieldsFromCustomSetting()+' From '+obj+' Where '+conditionField +' =\''+objectId+'\'';
            if(recordType != null && recordType != ''){
                qry = qry + ' AND RecordType.Name = \'' + recordType+ '\'';
            } else if(obj == 'Task'){
                //Only get the tasks that do not have a recordtype if the recordtype is unspecified
                qry = qry + ' AND RecordType.Name = \'Master\'';
            }
            system.debug('printing query>'+qry);
            //query the data
           List<SObject> sObjList = queryRecords(qry);
           dataList = new List<DataDisplayWrapper>();
            if(sObjList.size() > 0){
                populateDisplayList(sObjList);
            }
        }        
        return dataList;
        }
        public set;
    }
    
    /*
    @Name :getFieldsFromCustomSetting
    @Description :Get fields from custom settings
    */
    public String getFieldsFromCustomSetting(){
        fieldsTypeWrapperList = new List<FieldsTypeWrapper>();
        Product_Tracker_Setting__c setting = Product_Tracker_Setting__c.getInstance('Default');
        List<String> allFieldsList = new List<String>();
        if(recordType==null || recordType == ''){
            allFieldsList = setting.NoRT_Task__c.split(';');
        }
        if(recordType=='Product'){
            allFieldsList = setting.Product_Task__c.split(';');
        }
        if(recordType=='Project'){
            allFieldsList = setting.Project_Task__c.split(';');
        }
        if(recordType=='Change Request'){
            allFieldsList = setting.Project_Change_Request_Task__c.split(';');
        }
        if(recordType=='Action Item'){
            allFieldsList = setting.Product_Action_Item_Task__c.split(';');
        }
        if(recordType=='Product Risk'){
            allFieldsList = setting.Product_Risk__c.split(';');
        }
        if(recordType=='Project Risk'){
            allFieldsList = setting.Project_Risk__c.split(';');
        }        
        if(obj == 'Product_Feature_Link__c'){
            allFieldsList = setting.Product_Features__c.split(';');
        }
        if(obj == 'Release_Feature__c' && conditionField == 'Feature__c'){
            allFieldsList = setting.Features_Releases__c.split(';');
        }
        if(obj == 'Project_Release__c'){
            allFieldsList = setting.Project_Releases__c.split(';');
        }
        if(obj == 'Product_Project__c' && conditionField == 'Product__c'){
            allFieldsList = setting.Product_Project__c.split(';');
        }
        if(obj == 'Product_Project__c' && conditionField == 'Project__c'){
            allFieldsList = setting.Project_Product__c.split(';');
        }
        if(obj == 'Release_Feature__c' && conditionField == 'Release__c'){
            allFieldsList = setting.Releases_Features__c.split(';');
        }
                
        fieldsLabel = new List<String>();
        fieldsName = new List<String>();
        
        Schema.SObjectType objToken = Schema.getGlobalDescribe().get(obj);
        Schema.DescribeSObjectResult objDef = objToken.getDescribe();
        Map<String, Schema.SObjectField> fields = objDef.fields.getMap();
/*  
        Set<String> fieldSet = fields.keySet();
        List<String> fieldsSortedList = new List<String>();
        fieldsSortedList.addAll(fieldSet);
        //sort the list by asc order
        fieldsSortedList.sort();
*/      
        String referencefields = '';
        String referenceQryfields = '';
        //populate the map here to hold field labels and field names        
        for(String f: allFieldsList){
            if(f!=null){
                List<String> field = f.split('~');
                //api_LabelMAP.put(field[1], field[0]);
                fieldsLabel.add(field[0]);
                fieldsName.add(field[1]);
                //for(String s:fieldsName){  
                    Schema.SObjectField fieldToken = fields.get(field[1]);
                    system.debug('fieldToken>>'+s+'--'+fieldToken);
                    if(fieldToken!=null){
                        Schema.DescribeFieldResult selectedField = fieldToken.getDescribe();
                        System.debug(''+selectedField.getName());
                        if(selectedField.isFilterable()){ 
                            if(selectedField.getType().name() == 'REFERENCE'){
                                referencefields = selectedField.getRelationshipName()+'.Name';
                                referenceQryfields = referencefields+','+referenceQryfields; 
                            }
                        }
                        system.debug('referencefields>>'+referencefields);
                        FieldsTypeWrapper ftw = new FieldsTypeWrapper(selectedField.getName(),selectedField.getType().name(),referencefields);
                        fieldsTypeWrapperList.add(ftw);
                        referencefields = '';
                    }else{
                        FieldsTypeWrapper ftw = new FieldsTypeWrapper(field[1],'','');
                        fieldsTypeWrapperList.add(ftw); 
                    }
                //}
            }
        }
        system.debug('fieldsTypeWrapperList>>'+fieldsTypeWrapperList);
        String strReturn = '';
         for(String s : fieldsName){
              strReturn += s + ',';
          }
          
    /*      if (fieldsList == null) { 
                fieldsList = new List<String>();
                for(String s: api_LabelMAP.values()){
                    fieldsList.add(s);
                  }  
                
            } 
      */
        if(strReturn != null && strReturn.length() > 0){    
            strReturn = strReturn.substring(0, strReturn.length()-1);
            //String r = referencefields.substring(0, referencefields.length()-1);
            if(referenceQryfields!='' && referenceQryfields.length()>0){
                strReturn  = strReturn +' , '+ referenceQryfields.substring(0, referenceQryfields.length()-1);
            }
            
            system.debug('strReturn>>'+strReturn);
        }
        return strReturn;
    }
    
    /*
    @Name :DataDisplayWrapper
    @Description :Wrapper class
    */
    public class DataDisplayWrapper{
        public Sobject sobj{get;set;}
        
        public DataDisplayWrapper(Sobject s){
            this.sobj = s;
        }
    }
    
    /*
    @Name :FieldsTypeWrapper
    @Description :Wrapper class
    */
    public class FieldsTypeWrapper{
        public String apiName{get;set;}
        public String dataType{get;set;}
        public String referenceName{get;set;}
        
        public FieldsTypeWrapper(String apiName, String dataType, String referenceName){
            this.apiName = apiName;
            this.dataType = dataType;
            this.referenceName = referenceName;
        }
    }

    /*
    @Name :viewRecord
    @Description :Method to open the records
    */
    public PageReference viewRecord(){
        String recordID = apexpages.currentpage().getparameters().get('recordID');
        return new PageReference('/'+recordID);
    }
    
    /*
    @Name :editRecord
    @Description :Method to redirect to the edit page of record
    */
    public PageReference editRecord(){
        return new PageReference('/'+editId+'/e?retURL=%2F'+objectId);
    }
    
    /*
    @Name :delRecord
    @Description :Method to delete the records
    */
    public PageReference delRecord(){
        String q = 'Select Id From '+obj+' Where Id=\'' +delId+ '\'';
        s=Database.query(q);
        if(s!=null){
            //Database.Delete(s);
            delete s;
        }
        return new PageReference('/'+objectId);
    }
        
    /*
    @Name :newRecords
    @Description :Method to redirect to new page of record
    */
    public PageReference newRecords(){
        String id = ApexPages.currentPage().getParameters().get('id');
        if(objNameParam=='Task'){
            RecordType r =[Select Id From RecordType Where Name=:recTypeNameParam And SobjectType=:objNameParam];
            recordTypeId = r.Id;
            return new PageReference('/00T/e?what_id='+id+'&retURL=%2F'+id+'&RecordType='+recordTypeId+'&ent='+objNameParam);
        }else if(objNameParam=='Product_Feature_Link__c'){
            return new PageReference('/a27/e?CF00NF0000008WyzA_lkid='+id+'&CF00NF0000008WyzA='+prodReleaseFeatureNameParam.replace('&','')+'&retURL=%2F'+id);
        }else if(objNameParam=='Release_Feature__c'){
            return new PageReference('/a2B/e?CF00NF0000008WyzD_lkid='+id+'&CF00NF0000008WyzD='+prodReleaseFeatureNameParam.replace('&','')+'&retURL=%2F'+id);
        }else if(objNameParam=='Project_Release__c'){
            return new PageReference('/a2Q/e?CF00NF0000008XH4u_lkid='+id+'&retURL=%2F'+id+'&CF00NF0000008XH4u='+prodReleaseFeatureNameParam.replace('&',''));
            //return new PageReference('/a2c/e?CF00NZ0000000fUKr_lkid='+id+'&retURL=%2F'+id+'&CF00NZ0000000fUKr='+prodReleaseFeatureNameParam.replace('&',''));
        }else if(objNameParam=='Product_Project__c_Product__c'){
            return new PageReference('/a2P/e?CF00NF0000008XH4t_lkid='+id+'&CF00NF0000008XH4t='+prodReleaseFeatureNameParam.replace('&','')+'&retURL=%2F'+id);
            //return new PageReference('/a2a/e?CF00NZ0000000fU1C_lkid='+id+'&CF00NZ0000000fU1C='+prodReleaseFeatureNameParam.replace('&','')+'&retURL=%2F'+id);
        }else if(objNameParam=='Product_Project__c_Project__c'){
            return new PageReference('/a2P/e?CF00NF0000008XH4v_lkid='+id+'&CF00NF0000008XH4v='+prodReleaseFeatureNameParam.replace('&','')+'&retURL=%2F'+id);
            //return new PageReference('/a2a/e?CF00NZ0000000fU1L_lkid='+id+'&CF00NZ0000000fU1L='+prodReleaseFeatureNameParam.replace('&','')+'&retURL=%2F'+id);
        }else if(objNameParam=='Release_Feature__c_Release__c'){
            return new PageReference('/a2B/e?CF00NF0000008WyzG_lkid='+id+'&CF00NF0000008WyzG='+prodReleaseFeatureNameParam.replace('&','')+'&retURL=%2F'+id);
        }else if(objNameParam=='Note'){
            return new PageReference('/002/e?parent_id='+id+'&retURL=%2F'+id); 
        }else if(objNameParam=='Attachment'){
            return new PageReference('/p/attach/NoteAttach?pid='+id+'&parentname='+prodReleaseFeatureNameParam+'&retURL=%2F'+id); 
        }else{
            return null; 
        }
    }  
  
  //notes and attachments code
    public List<DisplayWrapper> dList{get;set;}


  
    public class DisplayWrapper{
        public String rName{get;set;}
        public String rID{get;set;}
        public String rType{get;set;}
        public DateTime rLMdate{get;set;}
        public String rCById{get;set;}
        public String rCByName{get;set;}
        
        public DisplayWrapper(String rName,String rID,String rType,DateTime rLMdate,String rOwnerId,String rOwnerName){
            this.rName = rName;
            this.rID = rID;
            this.rType = rType;
            this.rLMdate = rLMdate;
            this.rCById = rOwnerId;
            this.rCByName = rOwnerName;
            
        }      
    }

  public void getNotesAndAttachment(){
      dList = new List<DisplayWrapper>();
        if(s != null){
            for(Attachment am : [Select ParentId, Name, LastModifiedDate, Id, Description, CreatedById, CreatedBy.Name From Attachment WHERE ParentId =:ApexPages.currentPage().getParameters().get('id') order by LastModifiedDate desc]){
               DisplayWrapper dw = new DisplayWrapper(am.Name,am.ID,'Attachment',am.LastModifiedDate,am.CreatedById,am.CreatedBy.Name);
               dList.add(dw);
            }
            
            for(Note n : [Select Title, ParentId, LastModifiedDate, Id, CreatedById, CreatedBy.Name From Note WHERE ParentId =:ApexPages.currentPage().getParameters().get('id')  order by LastModifiedDate desc]){
                DisplayWrapper dw = new DisplayWrapper(n.Title,n.ID,'Note',n.LastModifiedDate,n.CreatedById,n.CreatedBy.Name);
                dList.add(dw);
            }
        }
    }
    
    /*
    @Name :editRecord
    @Description :Method to redirect to the edit page of record
    */
    public PageReference editNoteAttachRecord(){
        return new PageReference('/'+editId+'/e?retURL=%2F'+ApexPages.currentPage().getParameters().get('id'));
    }
    
    /*
    @Name :delRecord
    @Description :Method to delete the records
    */
    public PageReference delNoteAttachRecord(){
        String q = '';
        if(delId.Startswith('00P')){
            q = 'Select Id From Attachment Where Id=\'' +delId+ '\'';
        } else {
            q = 'Select Id From Note Where Id=\'' +delId+ '\'';
        }
        
        s=Database.query(q);
        if(s!=null){
            //Database.Delete(s);
            delete s;
        }
        return new PageReference('/'+ApexPages.currentPage().getParameters().get('id'));
    }    

}