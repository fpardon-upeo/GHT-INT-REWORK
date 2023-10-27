/**
 * Created by Frederik on 31/05/2023.
 */

/**
 * Created by fpardon on 02/09/2022.
 */

@IsTest
public with sharing class TrendsTopServiceTest {

    public static Account createTestData(){

        Account a = new Account();
        a.Name = 'TrendsTopServiceTest';
        a.VAT_Number__c = '0772697644';
        return a;

    }

    @IsTest
    public static void testService(){

        SingleRequestMock fakeSearch = new SingleRequestMock(
                200,
                'Complete',
                '{'+
                        '  \"header\": {'+
                        '    \"apiVersion\": \"v1\",'+
                        '    \"creationDateTime\": \"02/09/2022 12:54:59\",'+
                        '    \"requestID\": \"e6b0b8f8-6772-404d-925c-6bdac7387632\",'+
                        '    \"path\": \"/v1/BE/enterprises/search?enterpriseNumber=BE 0628.927.412&page=1&nbElements=50&lng=en\"'+
                        '  },'+
                        '  \"content\": {'+
                        '    \"information\": {'+
                        '      \"totalCount\": 1,'+
                        '      \"currentCount\": 1,'+
                        '      \"currentPage\": 1,'+
                        '      \"maxPage\": 1,'+
                        '      \"fromOffset\": 0,'+
                        '      \"toOffset\": 0'+
                        '    },'+
                        '    \"enterprises\": ['+
                        '      {'+
                        '        \"name\": \"TrendsTopServiceTest\",'+
                        '        \"status\": \"A\",'+
                        '        \"enterpriseNumber\": \"0772697644\",'+
                        '        \"address\": {'+
                        '          \"street\": \"Rue aux Laines\",'+
                        '          \"houseNumber\": \"68-72\",'+
                        '          \"postalCode\": \"1000\",'+
                        '          \"locality\": \"Bruxelles\",'+
                        '          \"country\": {'+
                        '            \"code\": \"BE\",'+
                        '            \"label\": \"Belgique\"'+
                        '          }'+
                        '        },'+
                        '        \"meta\": {'+
                        '          \"availableModulesPath\": \"/v1/BE/enterprises/0772697644\"'+
                        '        }'+
                        '      }'+
                        '    ]'+
                        '  }'+
                        '}',
                null);

        SingleRequestMock fakeCreditAdvice = new SingleRequestMock(
                200,
                'Complete',
                '{'+
                        '    \"header\": {'+
                        '        \"apiVersion\": \"v1\",'+
                        '        \"creationDateTime\": \"02/09/2022 13:40:16\",'+
                        '        \"requestID\": \"fda27f87-b384-4168-8cc0-b93ea51da747\",'+
                        '        \"path\": \"/v1/BE/enterprises/0772697644/creditAdvice-1.0\",'+
                        '        \"requestedModules\": ['+
                        '            \"creditAdvice-1.0\"'+
                        '        ],'+
                        '        \"deliveredModules\": ['+
                        '            \"creditAdvice-1.0\"'+
                        '        ]'+
                        '    },'+
                        '    \"content\": {'+
                        '        \"enterprise\": {'+
                        '            \"creditAdvice\": {'+
                        '                \"moduleVersion\": \"1.0\",'+
                        '                \"amount\": 10783.37,'+
                        '                \"currency\": \"EUR\",'+
                        '                \"downPayment\": {'+
                        '                    \"label\": \"We detected no risks in the funding of the commercial cycle. TBI doesn\'t advise to apply any down payment policy for your transactions with this company\",'+
                        '                    \"sentiment\": \"POSITIVE\"'+
                        '                }'+
                        '            }'+
                        '        }'+
                        '    }'+
                        '}',
                null);

        SingleRequestMock fakeContactInfo = new SingleRequestMock(
                200,
                'Complete',
                '{'+
                        '    \"header\": {'+
                        '        \"apiVersion\": \"v1\",'+
                        '        \"creationDateTime\": \"04/09/2022 10:01:47\",'+
                        '        \"requestID\": \"2e2b02e8-40ed-4536-ac4a-1567850466fa\",'+
                        '        \"path\": \"/v1/BE/enterprises/0687850358/contactInfo-1.0\",'+
                        '        \"requestedModules\": ['+
                        '            \"contactInfo-1.0\"'+
                        '        ],'+
                        '        \"deliveredModules\": ['+
                        '            \"contactInfo-1.0\"'+
                        '        ]'+
                        '    },'+
                        '    \"content\": {'+
                        '        \"enterprise\": {'+
                        '            \"contactInfo\": {'+
                        '                \"moduleVersion\": \"1.0\",'+
                        '                \"phone\": \"02/737.51.95\",'+
                        '                \"phoneDNCMFlag\": false,'+
                        '                \"mobile\": \"0475/281.310\",'+
                        '                \"mobileDNCMFlag\": false,'+
                        '                \"email\": \"lancor@lancor.com\",'+
                        '                \"website\": \"http://www.emfea.be\",'+
                        '                \"facebook\": \"https://www.facebook.com/InkConsultingBelgium/\",'+
                        '                \"linkedin\": \"https://www.linkedin.com/company/inkconsulting/\"'+
                        '            }'+
                        '        }'+
                        '    }'+
                        '}',
                null);

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String, HttpCalloutMock>();
        endpoint2TestResp.put('callout:Trends_Top/BE/enterprises/search?enterpriseNumber=0772697644&page=1&nbElements=50&lng=en', fakeSearch);
        endpoint2TestResp.put('callout:Trends_Top/BE/enterprises/search?enterpriseNumber=0772697644&name=TrendsTopServiceTest&page=1&nbElements=50&lng=en', fakeSearch);
        endpoint2TestResp.put('callout:Trends_Top/BE/enterprises/search?name=TrendsTopServiceTest&page=1&nbElements=50&lng=en', fakeSearch);
        endpoint2TestResp.put('callout:Trends_Top' +'/BE/enterprises/0772697644/creditAdvice-1.0', fakeCreditAdvice);
        endpoint2TestResp.put('callout:Trends_Top' +'/BE/enterprises/0772697644/contactInfo-1.0', fakeContactInfo);

        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        test.startTest();

        Account a = createTestData();
        TrendsTopService.searchCompanyByName(a.Name);
        TrendsTopService.searchCompanyByVAT(a.VAT_Number__c);
        TrendsTopService.searchCompanyByNameAndVat(a.Name, a.VAT_Number__c);
        TrendsTopService.getCreditAdvice(a.VAT_Number__c);
        TrendsTopService.getContactInfo(a.VAT_Number__c);

        test.stopTest();


    }

}