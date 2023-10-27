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
 * Created: 12/10/2023
 * Last Updated: 12/10/2023
 *
 * Unit tests:
 *
 * Change log:
 * -----------------------------------------------------------------------------------------------
*/
/**
@Description: Test class for AccountExternalService

@Change Log:
Date        Developer       Description
----------  --------------  --------------------------------------------------------------------
12/10/2023  Frederik        Created test class

*/

@IsTest
public with sharing class AccountExternalServiceTest {

    @TestSetup
    static void setup() {
        String tabbedInput =
                '_  BC_Id__c  Code__c Table__c\n' +
                        '[Business_Central_Config__c]  12bd2d1a-2330-ed11-97e8-000d3aac7d5b  BNKCONVDOM  paymentMethods\n' +
                        '[Business_Central_Config__c]  29bd2d1a-2330-ed11-97e8-000d3aac7d5b  CONTANT  paymentMethods\n' +
                        '[Business_Central_Config__c]  00932620-2330-ed11-97e8-000d3aac7d5b  BINNENL  taxAreas\n' +
                        '[Business_Central_Config__c]  03932620-2330-ed11-97e8-000d3aac7d5b  IMPVERL  taxAreas\n' +
                        '[Business_Central_Config__c]  9ab92c37-2230-ed11-97e8-000d3aac7d5b  LM+60D  paymentTerms\n' +
                        '[Business_Central_Config__c]  1fbd2d1a-2330-ed11-97e8-000d3aac7d5b  BNKCONVINT  paymentMethods\n' +
                        '[Business_Central_Config__c]  02932620-2330-ed11-97e8-000d3aac7d5b  IMPEXP  taxAreas\n' +
                        '[Business_Central_Config__c]  da451dd4-7992-ed11-bff5-0022489e1b27  12DAGEN  paymentTerms\n' +
                        '[Business_Central_Config__c]  7a84b1f8-2030-ed11-97e8-000d3aac7d5b  PAYPAL  paymentMethods\n' +
                        '[Business_Central_Config__c]  4abd2d1a-2330-ed11-97e8-000d3aac7d5b  MASTERCARD  paymentMethods\n' +
                        '[Business_Central_Config__c]  97b92c37-2230-ed11-97e8-000d3aac7d5b  CONTANT  paymentTerms\n' +
                        '[Business_Central_Config__c]  95b92c37-2230-ed11-97e8-000d3aac7d5b  60D  paymentTerms\n' +
                        '[Business_Central_Config__c]  93b92c37-2230-ed11-97e8-000d3aac7d5b  1M(8D)  paymentTerms\n' +
                        '[Business_Central_Config__c]  04932620-2330-ed11-97e8-000d3aac7d5b  MC  taxAreas\n' +
                        '[Business_Central_Config__c]  01932620-2330-ed11-97e8-000d3aac7d5b  EU  taxAreas\n' +
                        '[Business_Central_Config__c]  96b92c37-2230-ed11-97e8-000d3aac7d5b  7DAGEN  paymentTerms\n' +
                        '[Business_Central_Config__c]  67bd2d1a-2330-ed11-97e8-000d3aac7d5b  REKENING  paymentMethods\n' +
                        '[Business_Central_Config__c]  fc396657-5971-ed11-8c34-6045bd9d6031  LM+90D  paymentTerms\n' +
                        '[Business_Central_Config__c]  64cc51cc-ae70-ed11-8c34-6045bd9d6083  CHEQUE  paymentMethods\n' +
                        '[Business_Central_Config__c]  e0d89a9b-ae70-ed11-8c34-6045bd9d6083  COMP  paymentMethods\n' +
                        '[Business_Central_Config__c]  9bb92c37-2230-ed11-97e8-000d3aac7d5b  REMBOURS  paymentTerms\n' +
                        '[Business_Central_Config__c]  febc2d1a-2330-ed11-97e8-000d3aac7d5b  BANK  paymentMethods\n' +
                        '[Business_Central_Config__c]  91b92c37-2230-ed11-97e8-000d3aac7d5b  15DAGEN  paymentTerms\n' +
                        '[Business_Central_Config__c]  92b92c37-2230-ed11-97e8-000d3aac7d5b  1M  paymentTerms\n' +
                        '[Business_Central_Config__c]  34bd2d1a-2330-ed11-97e8-000d3aac7d5b  DOM  paymentMethods\n' +
                        '[Business_Central_Config__c]  98b92c37-2230-ed11-97e8-000d3aac7d5b  LM  paymentTerms\n' +
                        '[Business_Central_Config__c]  99b92c37-2230-ed11-97e8-000d3aac7d5b  LM+30D  paymentTerms\n' +
                        '[Business_Central_Config__c]  3fbd2d1a-2330-ed11-97e8-000d3aac7d5b  KAS  paymentMethods\n' +
                        '[Business_Central_Config__c]  94b92c37-2230-ed11-97e8-000d3aac7d5b  30D  paymentTerms\n' +
                        '[Business_Central_Config__c]  70bd2d1a-2330-ed11-97e8-000d3aac7d5b  WORLDPAY  paymentMethods\n' +
                        '[Business_Central_Config__c]  5abd2d1a-2330-ed11-97e8-000d3aac7d5b  PIN  paymentMethods';

        List<Business_Central_Config__c> configsToInsert = new List<Business_Central_Config__c>();

        String[] lines = tabbedInput.split('\n');
        String[] headers = lines[0].split('\\s+');

        for (Integer i = 1; i < lines.size(); i++) {
            String[] values = lines[i].split('\\s+');
            if (values.size() == headers.size()) {
                Business_Central_Config__c config = new Business_Central_Config__c();
                config.BC_Id__c = values[1];
                config.Code__c = values[2];
                config.Table__c = values[3];

                configsToInsert.add(config);
            }
        }

        // Insert the records
        insert configsToInsert;
    }

    @IsTest
    static void testUpdateBCAccount() {

        Boolean isSandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
        String environmentType = isSandbox == true ? 'UAT' : 'Production';
        System.debug('environmentType: ' + environmentType);

        Azure_Config__mdt configRecord = [SELECT
                Id,
                Eurotracs_Instance__c,
                Eurotracs_Environment__c,
                Operation__c,
                Company__c,
                Legal_Entity__c
        FROM Azure_Config__mdt
        WHERE Legal_Entity__c = 'Gheeraert Transport'
        and Eurotracs_Environment__c = :environmentType
        and Operation__c = 'update'];

        String companyId = configRecord.Company__c;

        Account acc = getAccount();
        acc.BC_Id__c = '41eece24-d068-ee11-8def-000d3a65cca3';

        insert acc;

        SingleRequestMock mock = new SingleRequestMock(200, 'OK', mockBCBody(), null);
        String endPoint = 'callout:Dynamics_BC' + '/ODataV4/Company(\'' + companyId + '\')/CustomersGT(' + acc.BC_Id__c + ')';

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put(endPoint, mock);
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        List<AccountUpdateInvocable.AccountUpdate> accs = new List<AccountUpdateInvocable.AccountUpdate>();
        AccountUpdateInvocable.AccountUpdate accUpdate = new AccountUpdateInvocable.AccountUpdate();
        accUpdate.account = acc;
        accs.add(accUpdate);

        Test.startTest();
        AccountUpdateInvocable.updateAccount(accs);
        Test.stopTest();

        Account updatedAcc = [SELECT Id, BC_Id__c, Last_BC_Sync__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(acc.BC_Id__c, updatedAcc.BC_Id__c);
        System.assertNotEquals(acc.Last_BC_Sync__c, updatedAcc.Last_BC_Sync__c);

    }

    @IsTest
    static void testUpdateETAccount(){

        Boolean isSandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
        String environmentType = isSandbox == true ? 'UAT' : 'Production';
        System.debug('environmentType: ' + environmentType);

        Account acc = getAccount();
        acc.Eurotracs_Id__c = '242916';

        insert acc;


        String endPoint = 'callout:ETGTR/api/Customer/UpdateCustomers';
        String tokenEndpoint = 'callout:ETGTR'+'/token';
        String etTokenBody = '{"access_token": "test"}';

        SingleRequestMock mock = new SingleRequestMock(200, 'OK', mockETBody(), null);
        SingleRequestMock mockToken = new SingleRequestMock(200, 'OK', etTokenBody, null);


        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put(endPoint, mock);
        endpoint2TestResp.put(tokenEndpoint, mockToken);
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        List<AccountUpdateInvocable.AccountUpdate> accs = new List<AccountUpdateInvocable.AccountUpdate>();
        AccountUpdateInvocable.AccountUpdate accUpdate = new AccountUpdateInvocable.AccountUpdate();
        accUpdate.account = acc;
        accs.add(accUpdate);

        Test.startTest();
        AccountUpdateInvocable.updateAccount(accs);
        Test.stopTest();

        Account updatedAcc = [SELECT Id, Eurotracs_Id__c, Last_Eurotracs_Sync__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(acc.Eurotracs_Id__c, updatedAcc.Eurotracs_Id__c);
        System.assertNotEquals(acc.Last_Eurotracs_Sync__c, updatedAcc.Last_Eurotracs_Sync__c);
    }

    @IsTest
    static void testUpdatePortalAccount() {

        Boolean isSandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
        String environmentType = isSandbox == true ? 'UAT' : 'Production';
        System.debug('environmentType: ' + environmentType);

        Account acc = getAccount();
        acc.Portal_Id__c = '2157';
        insert acc;

        String endPoint = 'callout:Portal/api/Customer/2157';
        String tokenEndpoint = 'callout:Portal'+'/token';

        String tokenBody = '{"access_token": "test"}';

        SingleRequestMock mock = new SingleRequestMock(200, 'OK', mockPortalBody(), null);
        SingleRequestMock mockToken = new SingleRequestMock(200, 'OK', tokenBody, null);

        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put(endPoint, mock);
        endpoint2TestResp.put(tokenEndpoint, mockToken);
        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        List<AccountUpdateInvocable.AccountUpdate> accs = new List<AccountUpdateInvocable.AccountUpdate>();
        AccountUpdateInvocable.AccountUpdate accUpdate = new AccountUpdateInvocable.AccountUpdate();
        accUpdate.account = acc;
        accs.add(accUpdate);

        Test.startTest();
        AccountUpdateInvocable.updateAccount(accs);
        Test.stopTest();

        Account updatedAcc = [SELECT Id, Portal_Id__c, Last_Portal_Sync__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(acc.Portal_Id__c, updatedAcc.Portal_Id__c);
        System.assertNotEquals(acc.Last_Portal_Sync__c, updatedAcc.Last_Portal_Sync__c);

    }

    @IsTest
    static Account getAccount(){
        Account acc = new Account();
        acc.Name = 'Loaded x Limited 2';
        acc.Legal_Entities__c = 'Gheeraert Transport';
        acc.Payment_Terms__c = 'CONTANT';
        acc.Payment_Method__c = 'BANK';
        acc.VAT_Number__c = 'BE 0480.501.178';
        acc.BillingStreet = 'Nijverheidslei 147';
        acc.BillingPostalCode = '2180';
        acc.BillingCity = 'Ekeren';
        acc.BillingCountryCode = 'BE';
        acc.Phone = '+3236051208';
        acc.Email__c = 'test@test.com';
        acc.Website = 'www.test.com';
        acc.Last_BC_Sync__c = Date.today()-1;
        acc.Last_Eurotracs_Sync__c = Date.today()-1;
        acc.Last_Portal_Sync__c = Date.today()-1;

        return acc;


    }

    @IsTest
    static String mockBCBody() {
    return
        '{'+
        '    "id": "41eece24-d068-ee11-8def-000d3a65cca3",'+
        '    "number": "0016565",'+
        '    "displayName": "Loaded x Limited 2",'+
        '    "type": "Company",'+
        '    "addressLine1": "Nijverheidslei 147",'+
        '    "addressLine2": "",'+
        '    "city": "Ekeren",'+
        '    "state": "",'+
        '    "country": "BE",'+
        '    "postalCode": "2180",'+
        '    "phoneNumber": "+3236051208",'+
        '    "email": "general@pardonder.com",'+
        '    "website": "",'+
        '    "salespersonCode": "",'+
        '    "balanceDue": 0,'+
        '    "creditLimit": 15000,'+
        '    "taxLiable": true,'+
        '    "taxAreaId": "00932620-2330-ed11-97e8-000d3aac7d5b",'+
        '    "taxAreaDisplayName": "Klanten/leveranciers (binnenland)",'+
        '    "taxRegistrationNumber": "BE 0480.501.178",'+
        '    "currencyId": "00000000-0000-0000-0000-000000000000",'+
        '    "currencyCode": "EUR",'+
        '    "paymentTermsId": "94b92c37-2230-ed11-97e8-000d3aac7d5b",'+
        '    "shipmentMethodId": "00000000-0000-0000-0000-000000000000",'+
        '    "paymentMethodId": "febc2d1a-2330-ed11-97e8-000d3aac7d5b",'+
        '    "blocked": " ",'+
        '    "genBusPostingGroup": "BINNENL",'+
        '    "vatBusPostingGroup": "BINNENL",'+
        '    "custPostingGroup": "ALGEMEEN",'+
        '    "lastModifiedDateTime": "2023-10-12T08:10:16.227Z",'+
        '    "Date_Filter": "",'+
        '    "Global_Dimension_1_Filter": "",'+
        '    "Global_Dimension_2_Filter": "",'+
        '    "Currency_Filter": ""'+
        '}';
    }

    @IsTest
    static String mockETBody() {
        return
        '{'+
                '    "HasErrors": false,'+
                '    "HasWarnings": false,'+
                '    "Data": ['+
                '        {'+
                '            "CustomerID": 242916,'+
                '            "CustomerName": "Loaded x Limited 2",'+
                '            "CustomerName2": null,'+
                '            "HasErrors": false,'+
                '            "HasWarnings": false,'+
                '            "ResponseMessages": ['+
                '            ]'+
                '        }'+
                '    ]'+
                '}';
    }

    @IsTest
    static String mockPortalBody(){
        return
        '{'+
                '    "CustomerID": 2157,'+
                '    "CustomerName": "SAINT MEDARD",'+
                '    "CustomerVAT": "BE0451.994.066",'+
                '    "CustomerStreet": "ZONING DE LA VOIE CUIVREE 7***",'+
                '    "CustomerCountry": "BE",'+
                '    "CustomerPC": "2180",'+
                '    "CustomerCity": "Ekeren",'+
                '    "CustomerPhone": "",'+
                '    "CustomerEmail": "frederik.pardon@gmail.com",'+
                '    "CustomerInvoiceEmail": null,'+
                '    "CustomerInvoicePhone": null,'+
                '    "CustomerComment": "",'+
                '    "CustomerDivision": null,'+
                '    "CustomerStatusID": 10,'+
                '    "IsActive": true,'+
                '    "InternalCompanyID": 5,'+
                '    "PlanDepotID": 5,'+
                '    "AllowNeutral": 0,'+
                '    "TimeSlot": "",'+
                '    "KeepDateEDI": null,'+
                '    "OpeningHoursToTMS": null,'+
                '    "LoadingToTMS": true,'+
                '    "PlanDepot": {'+
                '        "DepotID": 5,'+
                '        "Code": "LOPPEM",'+
                '        "Address": null,'+
                '        "InternalCompanyID": 0,'+
                '        "External": false,'+
                '        "Zones": null'+
                '    },'+
                '    "CustomerPOD": true,'+
                '    "ExtensionEDI": " ",'+
                '    "ADRAllowed": false'+
                '}';
    }


}