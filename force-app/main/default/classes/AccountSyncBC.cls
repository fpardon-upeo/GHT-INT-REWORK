/**
 * @Version: 1.0
 * @Author: Frederik
 * @Copyright: 2021 Upeo Consulting
 * @Uses:
 *
 * -----------------------------------------------------------------------------------------------
 * Description: This class is used to sync accounts from Business Central to Salesforce. Theoretically
 * it should only run after mass updates in BC or when deploying to fresh environments.
 *
 * Because of this, this class is not optimized. It is not bulkified and should be treated as a throwaway
 * class. It's basically a one time use class.
 *
 *
 * Created: 23/05/2023
 * Last Updated: 23/05/2023
 *
 * Unit tests:
 *
 * Change log:
 * -----------------------------------------------------------------------------------------------
*/
/**
@Description:

@Change Log:

@Dependencies:

@Test Classes:

*/

public with sharing class AccountSyncBC {


    @Future(callout=true)
    public static void getAllAccountFinancials() {
        String url = 'https://api.businesscentral.dynamics.com/v2.0/c78ce9f9-94d2-46dd-afcf-c12e881cc810/Production/ODataV4/Company(\'GTR\')/CustomersGT?$expand=CustomersGTcustomerFinancialDetails';
        System.debug(url);
        HttpResponse res = doCallOut(url, 'GET');
        System.debug(res.getStatusCode());

        if(res.getStatusCode() == 200){

            List<Account> accounts = new List<Account>();

            AccountFinancialWrapper bcAccount = AccountFinancialWrapper.parse(res.getBody());
            System.debug('first record is: ' +bcAccount.value[0]);

            for(AccountFinancialWrapper.Value customer : bcAccount.value){

                Account acc = new Account();
                acc.Name = customer.displayName;
                //acc.Customer_Number__c = customer.number_Z;
                acc.BC_Id__c = customer.id;
                acc.BillingStreet = customer.addressLine1;
                acc.BillingCity = customer.city;
                acc.BillingPostalCode = customer.postalCode;
                acc.BillingCountryCode = customer.country;
                acc.VAT_Number__c = customer.taxRegistrationNumber;
                acc.Ext_Code__c = customer.number_Z;
                acc.Balance__c = Decimal.valueOf(customer.balanceDue);
                acc.Credit_Limit__c = Decimal.valueOf(customer.creditLimit);
                acc.Total_Sales__c = Decimal.valueOf(customer.CustomersGTcustomerFinancialDetails.totalSalesExcludingTax);
                acc.Overdue_Amounts__c = Decimal.valueOf(customer.CustomersGTcustomerFinancialDetails.overdueAmount);
                acc.Copy_Billing_Address_to_Shipping_Addres__c = false;
                accounts.add(acc);
            }

            Schema.SObjectField f = Account.BC_Id__c;

            List<Sync_Error__c> errors = new List<Sync_Error__c>();

            Database.UpsertResult[] results = Database.upsert(accounts, f, false);
            for(Integer i = 0; i < results.size(); i++) {
                if(!results[i].isSuccess()) {
                    Sync_Error__c syncError = new Sync_Error__c();
                    syncError.Error_Message__c = results[i].getErrors()[0].getStatusCode() + '-' +results[i].getErrors()[0].getMessage();
                    syncError.Record_Id__c = results[i].getId();
                    syncError.Type__c = 'Account Upsert';
                    syncError.Source__c = 'Business Central';
                    syncError.Target__c = 'Salesforce';
                    errors.add(syncError);
                }
            }

            insert errors;



        }
    }

    Public static HttpResponse doCallOut(String url, string method){

        String token = getToken();
        System.debug('token in doCallOut = ' + token);

        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        system.debug(req.getEndpoint());
        req.setMethod(method);
        req.setTimeout(120000);
        req.setHeader('Content-Length', '0');
        req.setHeader('Authorization', 'Bearer ' + token);
        req.setHeader('Accept', '*/*');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        return res;
    }

    Public static String getToken(){

        //Gets a Bearer token from the https://login.microsoftonline.com/c78ce9f9-94d2-46dd-afcf-c12e881cc810/oauth2/v2.0/token endpoint
        //The token is used to authenticate the call to the Business Central API

        String token = '';
        String clientId = '8e81689e-bbc9-44b8-a115-1370fde037c8';
        String clientSecret = 'RCW8Q~vST5z-1a0NUWHUO.MEixp5zU0FAR9k7cGp';
        String tokenUrl = 'https://login.microsoftonline.com/c78ce9f9-94d2-46dd-afcf-c12e881cc810/oauth2/v2.0/token';

        HttpRequest req = new HttpRequest();
        req.setEndpoint(tokenUrl);
        req.setMethod('POST');
        req.setTimeout(120000);
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setHeader('Content-Length', '0');
        req.setBody('grant_type=client_credentials&client_id=' + clientId + '&client_secret=' + clientSecret + '&scope=https%3A%2F%2Fapi.businesscentral.dynamics.com%2F.default');

        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        System.debug(res.getStatusCode());
        if(res.getStatusCode() == 200){
            //Parse the response body to get the token
            JSONParser parser = JSON.createParser(res.getBody());
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'access_token')) {
                    parser.nextToken();
                    token = parser.getText();
                }
            }
        }
        System.debug(token);
        return token;


    }



}