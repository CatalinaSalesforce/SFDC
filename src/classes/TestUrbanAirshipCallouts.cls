/* User name and passwrd are from test account 
            https://go.urbanairship.com/apps/
            username=Catalina123
            password=Catalina123
 
       */
@isTest
private class TestUrbanAirshipCallouts {

    static testMethod void testGetDeviceInfo() {
    	/*
             Each test Case might be using a different app on UrbanAirship. application details are below. 
              App key : 4eSdRIEmQYu-6uIfU1aCTw (username)
              App Master key: xRCLuCeXTdKROTRigeo-qA( like password)
        */
        
        /* Notes for test case: 
           Logged into above account and created a new Device token and attached alias to it. Response looks like below. All validations are done against it. if anything change on this
           diviceInfo test cases may fail. 
{
   "device_token": "FE66489F304DC75B8D6E8200DFF8A456E8DAEACEC428B427E9518741C92C6660",
   "last_registration": null,
   "tz": null,
   "tags":    [
      "unitTest1",
      "unitTest2"
   ],
   "alias": "Salesforce.Development@catalinamarketing.com",
   "quiettime":    {
      "start": null,
      "end": null
   },
   "active": true,
   "badge": 0
}

       */ 
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
    	UrbanAirshipCallouts ua = new UrbanAirshipCallouts('4eSdRIEmQYu-6uIfU1aCTw','xRCLuCeXTdKROTRigeo-qA');
    	
    	Map<String,String> aliases = ua.getdeviceinformation('device_tokens');//device_tokens
        System.assert(aliases.get('Salesforce.Development@catalinamarketing.com')=='FE66489F304DC75B8D6E8200DFF8A456E8DAEACEC428B427E9518741C92C6660');
        
        aliases.clear();
        aliases = ua.getDeviceInformation('apids');
        System.assert(aliases.get('Salesforce.Development@catalinamarketing.com')=='11111111-1111-1111-1111-111111111111');
        
   
    }
    
     static testMethod void testTagCreate(){
          Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         UrbanAirshipCallouts ua = new UrbanAirshipCallouts('4eSdRIEmQYu-6uIfU1aCTw','xRCLuCeXTdKROTRigeo-qA');
         ua.createTag('testTagCreateAndDelete' ,'{"device_tokens": { "add": [ "FE66489F304DC75B8D6E8200DFF8A456E8DAEACEC428B427E9518741C92C6660" ] } }' );
         
         Map<String,String> aliases = ua.getdeviceinformation('device_tokens');
         
         System.assert(aliases.get('Salesforce.Development@catalinamarketing.com') =='FE66489F304DC75B8D6E8200DFF8A456E8DAEACEC428B427E9518741C92C6660');
    
    
     }
    
    static testMethod void testTagDelete(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        UrbanAirshipCallouts ua = new UrbanAirshipCallouts('4eSdRIEmQYu-6uIfU1aCTw','xRCLuCeXTdKROTRigeo-qA');
        HttpResponse res =  ua.deleteTags('testTagCreateAndDelete'); 
        System.assert(res.getStatusCode()==200);
    
    }
    
    
//@isTest
public class MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    public HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        //System.assertEquals('http://api.salesforce.com/foo/bar', req.getEndpoint());
       // System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        
        String body ;
        if(req.getMethod()=='GET'){
        if(req.getEndpoint().contains('/api/device_tokens')){
          body='{"device_tokens":[{"device_token": "FE66489F304DC75B8D6E8200DFF8A456E8DAEACEC428B427E9518741C92C6660","active": true,"alias": "Salesforce.Development@catalinamarketing.com","tags":["unitTest1","unitTest2"]}],"device_tokens_count": 1,"active_device_tokens_count": 1}';
        }else if(req.getEndpoint().contains('/api/apids')){
          
            body='{"apids": [{"apid": "11111111-1111-1111-1111-111111111111","tags":["unitest_apid_tag", "unitest_apid_tag2"],' +
                   '"alias": "Salesforce.Development@catalinamarketing.com","active": true, "created": "2014-01-16 23:27:52", "c2dm_registration_id": null}]}';
        }
        }else if(req.getMethod()=='POST'){
            
             if(req.getEndpoint().contains('/api/tags')){
                res.setHeader('Content-Type', 'text/plain');
                body='<data contentType="text/plain" contentLength="7"><![CDATA[Created]]></data>';
            }
           
        
        } else if(req.getMethod()=='DELETE'){
            
             if(req.getEndpoint().contains('/api/tags')){
                res.setHeader('Content-Type', 'text/plain');
                body='<data contentType="text/plain" contentLength="7"><![CDATA[Deleted]]></data>';
            }  
        }
        res.setBody(body);
        res.setStatusCode(200);
        return res;
    }
}
    
    
}