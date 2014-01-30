public class BOOMICallouts{
   public static final string baseUrl='https://platform.boomi.com';
   private static String username='';
   private static string password='';
   private Static string accountId = '';
   private static string containerId = '';
    
    public BOOMICallouts(String uName, String pswrd,String account, String container){
    
        username=uname; 
        password = pswrd; 
        accountId = account; 
        containerId = container; 
    }
   
   public HttpResponse invokeProcess(String processName){
     HttpRequest req = new HttpRequest();
     req.setEndpoint(baseUrl);
     req.setMethod('POST');
      String endpoint = baseUrl + '/account/'+accountId+'/container/'+containerId+'/processes';
     req.setEndpoint(endpoint);
     
     // Specify the required user name and password to access the endpoint
     // As well as the header and header information
 
     Blob headerValue = Blob.valueOf(username + ':' + password);
     String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
     req.setHeader('Authorization', authorizationHeader);
       
     String body = '<ProcessExecution processName="'+processName+'"></ProcessExecution>';
     req.setBody(body);
     
     // Create a new http object to send the request object
     // A response object is generated as a result of the request  
  
     Http http = new Http();
     HTTPResponse res ;
       try{
      res = http.send(req);
       }catch(CalloutException ce){
         System.debug(ce.getMessage());
       }catch(Exception e){System.debug(e.getMessage());}
    // System.debug(res.getBody());
       
       return res; 
   }
    
   
}