@isTest
public class TestBoomiCallouts{

    static testmethod void unitTest1(){
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
       BOOMICallouts boomi = new BoomiCallouts('salesforce.development@catalinamarketing.com','Catalina123','catalina-LZ2IXU','c89647bd-4d0b-49e4-ab36-2bb453777e89');
      HttpResponse res =  boomi.invokeProcess('UPSERT ACTUALS TO PFM');
       System.assertEquals(res.getBody(),'<ProcessExecuted/>');
      
    }



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
        
        String body ='' ;
        if(req.getMethod()=='POST'){
          body = '<ProcessExecuted/>';
        }
        res.setBody(body);
        res.setStatusCode(200);
        return res;
    }
}
}