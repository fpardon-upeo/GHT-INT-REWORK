/**
 * Created by fpardon on 09/10/2023.
 */

public virtual class CalloutHandler {

    public virtual HttpResponse makeCallout(Callout callout) {
        // Execute the callout

        HttpRequest request = new HttpRequest();
        request.setEndpoint(callout.endpoint);
        request.setMethod(callout.method);
        if(callout.body != null) {
            request.setBody(callout.body);
        }
        // Parse the headers

        if(callout.timeout != null){
            request.setTimeout(Integer.valueOf(callout.timeout));
        }

        if(callout.headers != null) {
            request = parseHeaders(request, callout);
        }

        Http http = new Http();
        HttpResponse response = http.send(request);
        System.debug('response status: ' + response.getStatus());
        return response;
    }

    public virtual HttpRequest parseHeaders(HttpRequest request, Callout callout) {
        // Parse the headers
        for (String header : callout.headers.keySet()) {
            request.setHeader(header, callout.headers.get(header));
        }
        System.debug('Request: ' + request);
        return request;
    }


}