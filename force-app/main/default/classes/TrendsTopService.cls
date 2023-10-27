/**
 * Created by Frederik on 31/05/2023.
 */

/**
 * Created by fpardon on 02/09/2022.
 */

public with sharing class TrendsTopService {

    @AuraEnabled
    public static String searchCompanyByName(string enterpriseName){

        String url = 'callout:Trends_Top'+'/BE/enterprises/search?name='+enterpriseName+'&page=1&nbElements=50&lng=en';
        HttpResponse resp = callTrendsApi('GET', url);
        return resp.getBody();

    }

    @AuraEnabled
    public static String searchCompanyByVAT(string enterpriseNumber){

        String url = 'callout:Trends_Top'+'/BE/enterprises/search?enterpriseNumber='+enterpriseNumber+'&page=1&nbElements=50&lng=en';
        HttpResponse resp = callTrendsApi('GET', url);
        return resp.getBody();

    }

    @AuraEnabled
    public static String searchCompanyByNameAndVat(string enterpriseName, string enterpriseNumber){

        String url = 'callout:Trends_Top'+'/BE/enterprises/search?enterpriseNumber='+enterpriseNumber+'&name='+enterpriseName+'&page=1&nbElements=50&lng=en';
        HttpResponse resp = callTrendsApi('GET', url);
        return resp.getBody();

    }



    public static HttpResponse callTrendsApi(String method, string endpoint){

        HttpRequest req = new HttpRequest();
        req.setMethod(method);
        req.setEndpoint(endPoint);

        Http h = new Http();

        system.debug('request');
        system.debug(req.toString());
        system.debug(req.getBody());

        HttpResponse resp = h.send(req);
        system.debug(resp.getBody());

        return resp;
    }

    @AuraEnabled
    public static String getCreditAdvice(String enterpriseNumber){

        String url = 'callout:Trends_Top'+'/BE/enterprises/' + enterpriseNumber +'/creditAdvice-1.0';
        HttpResponse resp = callTrendsApi('GET', url);
        system.debug('resp = ' +resp.getBody());
        return resp.getBody();

    }

    @AuraEnabled
    public static String getContactInfo(String enterpriseNumber){

        String url = 'callout:Trends_Top'+'/BE/enterprises/' + enterpriseNumber +'/contactInfo-1.0';
        HttpResponse resp = callTrendsApi('GET', url);
        system.debug('resp = ' +resp.getBody());
        return resp.getBody();
    }

    @AuraEnabled
    public static void createTrendsTopDataRecord(String objectType, String recordId, String enterpriseNumber, String enterpriseName, Decimal creditAmount, String creditAdvice, String creditSentiment, String street, String zipCode, String city, String country){

        //Debug all input parameters
        system.debug('objectType = ' + objectType);
        system.debug('recordId = ' + recordId);
        system.debug('enterpriseNumber = ' + enterpriseNumber);
        system.debug('enterpriseName = ' + enterpriseName);
        system.debug('creditAmount = ' + creditAmount);
        system.debug('creditAdvice = ' + creditAdvice);
        system.debug('creditSentiment = ' + creditSentiment);
        system.debug('street = ' + street);
        system.debug('zipCode = ' + zipCode);
        system.debug('city = ' + city);
        system.debug('country = ' + country);


        Trends_Top_Data__c tt = new Trends_Top_Data__c();
        tt.Name = enterpriseName + ' - ' + System.now().format('yyyy-MM-dd HH:mm:ss');
        tt.Enterprise_Number__c = enterpriseNumber;
        tt.Name_In_Trends_Top__c = enterpriseName;
        tt.Credit_Advice__c = creditAdvice;
        tt.Credit_Sentiment__c = creditSentiment;
        tt.Credit_Amount__c = creditAmount;
        tt.Credit_Advice__c = creditAdvice;
        tt.Address__Street__s = street;
        tt.Address__PostalCode__s = zipCode;
        tt.Address__City__s = city;

        if(objectType == 'Account'){
            tt.Account__c = recordId;
        } else {
            tt.Lead__c = recordId;
        }

        insert tt;

    }

}