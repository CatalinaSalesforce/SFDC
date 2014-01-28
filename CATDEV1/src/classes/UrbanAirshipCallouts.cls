public class UrbanAirshipCallouts{
    // Include try catch blocks.
    public static final String baseurl = 'https://go.urbanairship.com';
    private static string userName=''; 
    private static string password='';
    private  HttpRequest request = new HttpRequest();
  
    
    public map<String,list<String>> alias_tags; 
    
    public UrbanAirshipCallouts(String uName, String pswrd ){
        
        
     Blob headerValue = Blob.valueOf(uName + ':' + pswrd);
     String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
     this.request.setHeader('Authorization', authorizationHeader);
        
    
    }
    
    public static void  authenticate(String pUName, String pswrd){
      
    
    }
    
    // Device identifiers like device_tokens, PINS, APIDS
    public Map<String,String> getDeviceInformation(String identifiers){
        
        List<DeviceInfo> dInfoList = new List<DeviceInfo>();
        Map<String,String>  alias_token = new Map<String,String>();
        alias_tags= new  map<String,list<String>>();
        List<String> nullAliases; 
        
        String endPoint = ''; 
        
        if(identifiers.toLowerCase()=='device_tokens'){
            endPoint = baseurl + '/api/device_tokens/';
        
        }else if(identifiers.toLowerCase()=='apids'){
           
            endPoint = baseurl + '/api/apids/';  
            
        }else {
           
           //@Todo throw exception if endpoint is not valid. 
        }
        
        request.setEndpoint(endPoint);
        request.setHeader('Accept','application/json');
        request.setMethod('GET');
      
         HttpResponse response;
        try{
          response = getHttpResponse(request);
        }catch(CalloutException ce){
            System.debug(ce.getMessage());
        }catch(Exception e){
            
            System.debug('exception'+e.getMessage());
        }
        System.debug('response is '+ response);
    
        JSONParser parser;
        try{
            
            parser = JSON.createParser(response.getBody());
            
        
        }catch(JSONException je){
          System.debug(je.getMessage());
        }catch(exception e){
          System.debug(e.getMessage());
        }
       
        
      // JSONToken.
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.START_ARRAY)) {
                 System.debug('start array '+parser.getCurrentToken()); 
                while(parser.nextToken()!=null){
                    if(parser.getCurrentToken()==JSONToken.START_OBJECT){
                      
                        DeviceInfo info = (DeviceInfo)parser.readValueAs(DeviceInfo.class);
                        
                        dInfoList.add(info);
                        
                        parser.skipChildren();
                    }
                }
               
              
            } 
             
        }
             
        for(DeviceInfo di: dInfoList){
          System.debug('di '+ di.Device_token);
          System.debug('apids'+di.apid);
          System.debug('alias '+ di.alias);
          System.debug('tags list '+ di.tags);
            if(endPoint.contains('/api/device_tokens/')){
               if(di.alias != null || di.alias !=''){
                  alias_token.put(di.alias, di.device_token);
                  System.debug('alias=> dt '+ alias_token);
                  alias_tags.put(di.alias, di.tags);
                  }else{
                   nullAliases.add(di.device_token);
                  }
             }else if(endPoint.contains('/api/apids/')){
            
                if(di.alias != null || di.alias !=''){
                  alias_token.put(di.alias,di.apid);
                  System.debug('alias=> apids '+ alias_token);
                  alias_tags.put(di.alias, di.tags);
 
                }else{
                   nullAliases.add(di.device_token);
                  }
               
            }
           
            
       }
           
 
        return alias_token;
    }
    
    public  HttpResponse deleteTags(String tagname){
        
      String endpoint = baseurl + '/api/tags/'+tagname; 
        
      request.setEndpoint(endpoint);
      request.setMethod('DELETE');
     
        
        HttpResponse response;
        try{
          response = getHttpResponse(request);
        }catch(Exception e){
            
            System.debug('exception'+e);
        }
        
        System.debug('response is '+ response);
        
        return response; 
        
        
    }
    
    public Httpresponse createTag(String tagname, String jsonbody){ 
        //request.setBody(String body);
        
       /* String body = '{';
        
        if(deviceToken != null){
            body = body + ' "device_tokens":'+ Json.serialize(deviceToken);
        }
        if(devicepins!=null){
            body=body + '"device_pins":' + Json.serialize(devicePins);
                }
        if(apids!=null){
            body=body+ '"apids":'+Json.serialize(devicePins);
                }
        body=body+ '}';
*/
        
        request.setHeader('Content-Type', 'application/json');
        request.setMethod('POST');
        request.setEndpoint(baseurl+'/api/tags/'+tagname);
        request.setBody(jsonbody);
        System.debug('end point'+request.getEndpoint()+' json'+ jsonbody);
        HttpResponse res = getHttpResponse(request);
        
       System.debug('response is'+ res.getBody() );
        if(jsonbody=='{}'){res.setStatusCode(400);}
        return res; 
    
    }
    
        public String createTagBody(List<string> aliases){
      //  List<String> aliasList = new list<String>();
        Map<String,String> aliasTokens = new Map<String,String>();
           
        Map<String,String> aliasApids = new Map<String,String>();
        List<String> deviceTokens = new List<String>();
        List<String> apids = new List<String>();
        
            aliasTokens =  getDeviceInformation('device_tokens');
            aliasApids = getDeviceInformation('apids');
        String tagBody = '{'; 
     
        if(aliasTokens != null){
            if(aliasTokens.size()>0){
                
               
                for(String s: aliases){
                  
                    if(aliasTokens.containsKey(s)){
                    
                      deviceTokens.add(aliasTokens.get(s));
                        
                       
                    }
                }
            }
        }
        
        System.debug('deviceTokens size' + deviceTokens.size());
        
        if(aliasApids != null){
            if(aliasApids.size()>0){
                
                for(String s: aliases){
                    
                    if(aliasApids.containsKey(s)){
                    
                       apids.add(aliasApids.get(s));
                        
                    }
                }
            }        
        }
        System.debug('Apids size'+ apids.size());
       // this part is for constructing json String for tag body, if tokens increase in future use Json Seriliaze object. 
        
        if(deviceTokens.size()>0){
            tagBody = tagBody+ '"device_tokens":{ "add":[';
            integer i = 1; 
            for(String s: deviceTokens){
            
               tagBody = tagBody + '"'+ s + '"' ;
                if(i!=deviceTokens.size()){
                  tagBody = tagBody + ','; 
                }
                System.debug('tag body at iteration '+ i + tagbody);
                i++;
            }
            tagBody = tagBody + ']}';
           
        
        }
         System.debug('deviceToken Json body is' + tagBody);
        if(deviceTokens.size()>0 && apids.size()>0){
        
          tagBody = tagBody+ ',';
        }
        
        
        if(apids.size()>0){
            tagBody =tagBody + '"apids":{ "add":[';
            integer i = 1; 
            for(String s: apids){
            
               tagBody = tagBody + '"'+ s + '"' ;
                if(i!=apids.size()){
                  tagBody = tagBody + ','; 
                }
            }
            tagBody = tagBody + ']}';
            System.debug('apids Json body is' + tagBody);
        
        }
        tagBody = tagBody + '}';
           // if(deviceTokens.size()==0 && apids.size()==0){tagBody=null;}
    return tagBody; 
    }
    
    public List<String> getTagsList(){
         
        List<String> tagsList = new List<String>();
         
        request.setHeader('Content-Type', 'application/json');
        request.setMethod('GET');
        request.setEndpoint(baseurl+'/api/tags/');
        HttpResponse res = getHttpResponse(request);
        
         JSONParser parser;
        try{
            
            parser = JSON.createParser(res.getBody());
            
        
        }catch(JSONException je){
          System.debug(je.getMessage());
        }catch(exception e){
          System.debug(e.getMessage());
        }
        
         while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.START_ARRAY)) {
                
                while (parser.nextToken() != null && parser.getCurrentToken() !=JSONToken.END_ARRAY) {
                
               
                     tagsList.add(parser.getText());
                     System.debug('tag is'+ parser.getText());
                 
                }
              
            } 
             
        }
        
       System.debug('response is'+ res.getBody() );
        return null; 
    }
    
    // this method returns SHA-256 hash value. 
    public static String gethashedValue(String inputString){
    
        String shacoded = EncodingUtil.convertToHex(Crypto.generateDigest('SHA-256', Blob.valueOf(inputString)));
        system.debug(' sha-256 coded value is '+ shacoded);
        return shacoded;
    }
    
    //HttpResponse object
    public HttpResponse getHttpResponse(HttpRequest req){
    
     Http http = new Http();
     HTTPResponse res;
        try{
        res = http.send(req);
            } catch(CalloutException ce){
               System.debug('failed '+ ce.getStackTraceString());
            }catch(Exception e){
               System.debug(e.getMessage());
            }
        System.debug('Response body '+res.getBody());
        
        return res; 
        
    }
    
    private class DeviceInfo{
       private String device_token;
       private string apid; 
       private string alias;
       private Boolean active;
      // private List<Tag> tags; 
       private List<String> tags;
        
        private DeviceInfo(String pdeviceT,String pApid, Boolean pActive, String pAlias, list<String> ptagsList){
            
            device_token = pdeviceT; 
            apid = pApid; 
            alias = pAlias; 
            active = pActive; 
            tags = ptagslist;
           
            }
  
    }
    
    public class TagsBody{
       
       public List<String> add;
       public List<String> remove;
       
        public TagsBody(List<String> pAddIds, list<String> pRemove){
            if(pAddIds!=null){
             add = pAddIds; 
            }
            if(pRemove!=null){
            remove = pRemove;
            }
         }
        
       
    }
    

}