/**
 * @Version: 1.0
 * @Author: Frederik
 * @Copyright: 2021 Upeo Consulting
 * @Uses:
 *
 * -----------------------------------------------------------------------------------------------
 * Description:
 *
 *
 * Created: 24/05/2023
 * Last Updated: 24/05/2023
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

public with sharing class AccountSyncET {

    @future(callout=true)
    public static void getCustomers(){

        String url = 'https://etransapidemo2.eurotracs.com/api/Customer/GetCustomers';
        HttpResponse res = doCallOut(url, 'GET');
        List<Account> accounts = new List<Account>();
        List<Contact> contacts = new List<Contact>();

        if(res.getStatusCode() == 200) {

            List<ET_Account> etAccounts = ET_Account.parse(res.getBody());
            for (ET_Account etAccount : etAccounts) {
                Account acc = new Account();
                acc.Ext_Code__c = String.valueOf(etAccount.SearchCode);
                acc.Eurotracs_Id__c = String.valueOf(etAccount.customerId);
                acc.Active__c = etAccount.Active;
                acc.Name = etAccount.CustomerName;
                acc.VAT_Number__c = etAccount.VATNumber;
                acc.BillingStreet = etAccount.Street1;
                acc.BillingPostalCode = etAccount.PostCode;
                acc.BillingCity = etAccount.CityName;
                acc.BillingCountryCode = etAccount.CountryCode;
                acc.Email__c = etAccount.Email1;
                acc.Phone = (String) etAccount.Mobile1;
                acc.Type = etAccount.Prospect == true ? 'Prospect' : 'Customer';
                acc.Legal_Entities__c = 'Gheeraert Transport';
                acc.Invoicing_Alias__c = String.valueOf(etAccount.InvoicingAlias);
                accounts.add(acc);
                system.debug('etAccount : '+etAccount);
                system.debug('etAccount.Contacts : '+etAccount.Contacts);
            }

            Schema.SObjectField fAcc = Account.Ext_Code__c;

            Database.UpsertResult[] results = Database.upsert(accounts, fAcc, false);
        }


    }



    Public static HttpResponse doCallOut(String url, string method){

        HttpRequest tokenReq = new HttpRequest();
        tokenReq.setEndpoint('callout:GHT_ET_GTR'+'/token');
        tokenReq.setBody('username=salesforce%40gheeraert.be&password=vdzj01cG&grant_type=password');
        tokenReq.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        tokenReq.setMethod('POST');
        Http httpToken = new Http();
        HTTPResponse resToken = httpToken.send(tokenReq);
        String token = resToken.getBody();
        System.debug('token: '+token);

        //Expected response = {"access_token":"igXQnQhV3Mk1_gREA7Q6gdbZ0HiPX7UZf_IkctvP-9tSrjWvPOSIurqNfTp0NF2bB_--TCwzRmhGAFIT48iT0mfZd6tFyLhq9foqrR09diyTBPF0DVSoW7Gvuj2PYzv-ru82y3fvdllgimhLLzRo0hh7S8PTMy84jT6bikTwiF3QJ7nK1ivwtkOsVRtUnwJ5Cs8caURr_X1j_IFpmSMcewEMixmi1fVRYTnL2cmnV9IEj_wSefIRzDvJgik3jyV3nrf9uk1SEikwp7IgAHdytBw7cLTH4usy41J9crDLRgD81qyH7gG_iGVwDZoKlNotGaylTcacUSAcG2n-bF0iRSsngiW_PVADpCafdoObcpTvHWFV7FNGrKG5C5S5mpAInANT9R-VqKVHrSnUTH6cm8"}
        //Get the access token

        JSONParser parser = JSON.createParser(token);
        String access_token;
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'access_token')) {
                parser.nextToken();
                access_token = parser.getText();
            }
        }

        System.debug('access_token: '+access_token);



        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        system.debug(req.getEndpoint());
        req.setMethod(method);
        req.setTimeout(120000);
        req.setHeader('Content-Length', '0');
        req.setHeader('Authorization', 'Bearer '+access_token);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        return res;
    }



}