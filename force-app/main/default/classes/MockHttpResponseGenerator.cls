/**
 * Created by Frederik on 31/05/2023.
 */

@IsTest
global class MockHttpResponseGenerator implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest req){

        System.assertEquals('http://example.com/example/test', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());

        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"example":"test"}');
        res.setStatusCode(200);
        system.debug(res);
        return res;

    }
}