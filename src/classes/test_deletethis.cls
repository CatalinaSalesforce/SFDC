public class test_deletethis{
 public void invokeProcess(){
     String baseUrl = 'https://go.urbanairship.com';
     String username='cbI9fET2SgKFSQuSuzQ4uQ';
     string password='MutUHza3QHu12Cj6Ro2EvQ';
     HttpRequest req = new HttpRequest();

     req.setHeader('Accept', 'application/json');
     req.setEndpoint(baseUrl+'/api/apids/');
     req.setMethod('GET');
     
     // Specify the required user name and password to access the endpoint
     // As well as the header and header information
 
     Blob headerValue = Blob.valueOf(username + ':' + password);
     String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
     req.setHeader('Authorization', authorizationHeader);
     
     System.debug('header value '+ req.getHeader('Content-Type'));
     // Create a new http object to send the request object
     // A response object is generated as a result of the request  
  
     Http http = new Http();
     HTTPResponse res ;
       try{
      res = http.send(req);
       }catch(CalloutException ce){
         System.debug(ce.getMessage());
       }catch(Exception e){System.debug(e.getMessage());}
     System.debug(res.getBody());
   }
    
}