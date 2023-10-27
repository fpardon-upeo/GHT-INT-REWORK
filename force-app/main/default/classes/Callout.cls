/**
 * Created by fpardon on 09/10/2023.
 */

public class Callout {

    @AuraEnabled public String name;
    @AuraEnabled public String type;
    @AuraEnabled public String endpoint;
    @AuraEnabled public String body;
    @AuraEnabled public String method;
    @AuraEnabled public Map<String, String> headers;
    @AuraEnabled public String timeout;
    @AuraEnabled public String retry;

    public Callout preparePostCallout(String endpoint, String body, Map<String, String> headers){

        Callout callout = new Callout();
        callout.endpoint = 'callout:Odoo' + '/' + endpoint;
        callout.method = 'POST';
        callout.headers = headers;
        callout.body = body;
        return callout;
    }

    public Callout preparePatchCallout(String endpoint, String body, Map<String, String> headers){

        Callout callout = new Callout();
        callout.endpoint = endpoint;
        callout.method = 'PATCH';
        callout.headers = headers;
        callout.body = body;
        callout.timeout = '60000';
        return callout;
    }

    public Callout preparePutCallout(String endpoint, String body, Map<String, String> headers){

        Callout callout = new Callout();
        callout.endpoint = endpoint;
        callout.method = 'PUT';
        callout.headers = headers;
        callout.body = body;
        callout.timeout = '60000';
        return callout;
    }
}