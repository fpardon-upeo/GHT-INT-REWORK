/**
 * Created by fpardon on 01/08/2023.
 */

@IsTest
private class AccountSyncBCTest {
    @TestSetup
    static void setup() {
        String tabbedInput =
                // Paste the entire tabbed input here
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
    static void testGetAccountFinancials() {

        SingleRequestMock mockToken = new SingleRequestMock(
                200,
                'OK',
                getTokenJson(),
                null
        );

        SingleRequestMock mockFinancials = new SingleRequestMock(
                200,
                'OK',
                getFinancialJSON(),
                null
        );

        SingleRequestMock mockCustomer = new SingleRequestMock(
                200,
                'OK',
                getCustomerJSON(),
                null
        );

        String customerEndpoint =
                'https://api.businesscentral.dynamics.com/v2.0/c78ce9f9-94d2-46dd-afcf-c12e881cc810/Production/ODataV4/Company(\'GTR\')/CustomersGT';

        String financialEndpoint =
                'https://api.businesscentral.dynamics.com/v2.0/c78ce9f9-94d2-46dd-afcf-c12e881cc810/Production/ODataV4/Company(\'GTR\')/CustomersGT?$expand=CustomersGTcustomerFinancialDetails';


        Map<String, HttpCalloutMock> endpoint2TestResp = new Map<String,HttpCalloutMock>();
        endpoint2TestResp.put('https://login.microsoftonline.com/c78ce9f9-94d2-46dd-afcf-c12e881cc810/oauth2/v2.0/token', mockToken);
        endpoint2TestResp.put(financialEndpoint, mockFinancials);
        endpoint2TestResp.put(customerEndpoint, mockCustomer);

        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        Test.startTest();
        AccountSyncBC.getAllAccountFinancials();
        Test.stopTest();


    }

    @IsTest
    static String getFinancialJSON() {
        String json = '{'+
                '    \"@odata.context\": \"https://api.businesscentral.dynamics.com/v2.0/c78ce9f9-94d2-46dd-afcf-c12e881cc810/Production/ODataV4/$metadata#Company(\'GTR\')/CustomersGT\",'+
                '    \"value\": ['+
                '        {'+
                '            \"@odata.etag\": \"W/\\\"JzIwOzEzNTI5MDMzNjY2NDE0NjUzNDQxMTswMDsn\\\"\",'+
                '            \"id\": \"96dae0b5-28eb-ed11-8848-000d3a65b0ee\",'+
                '            \"number\": \"102278\",'+
                '            \"displayName\": \"RYMBU\",'+
                '            \"type\": \"Company\",'+
                '            \"addressLine1\": \"KLEINE DOORNSTRAAT 27\",'+
                '            \"addressLine2\": \"\",'+
                '            \"city\": \"WILRIJK (ANTWERPEN)\",'+
                '            \"state\": \"\",'+
                '            \"country\": \"BE\",'+
                '            \"postalCode\": \"2610\",'+
                '            \"phoneNumber\": \"\",'+
                '            \"email\": \"finance@rymbu.com\",'+
                '            \"website\": \"\",'+
                '            \"salespersonCode\": \"\",'+
                '            \"balanceDue\": 0,'+
                '            \"creditLimit\": 0,'+
                '            \"taxLiable\": true,'+
                '            \"taxAreaId\": \"00932620-2330-ed11-97e8-000d3aac7d5b\",'+
                '            \"taxAreaDisplayName\": \"Klanten/leveranciers (binnenland)\",'+
                '            \"taxRegistrationNumber\": \"BE0747825260\",'+
                '            \"currencyId\": \"00000000-0000-0000-0000-000000000000\",'+
                '            \"currencyCode\": \"EUR\",'+
                '            \"paymentTermsId\": \"99b92c37-2230-ed11-97e8-000d3aac7d5b\",'+
                '            \"shipmentMethodId\": \"00000000-0000-0000-0000-000000000000\",'+
                '            \"paymentMethodId\": \"00000000-0000-0000-0000-000000000000\",'+
                '            \"blocked\": \" \",'+
                '            \"genBusPostingGroup\": \"BINNENL\",'+
                '            \"vatBusPostingGroup\": \"BINNENL\",'+
                '            \"custPostingGroup\": \"ALGEMEEN\",'+
                '            \"lastModifiedDateTime\": \"2023-05-05T09:39:30.363Z\",'+
                '            \"Date_Filter\": \"\",'+
                '            \"Global_Dimension_1_Filter\": \"\",'+
                '            \"Global_Dimension_2_Filter\": \"\",'+
                '            \"Currency_Filter\": \"\",'+
                '            \"CustomersGTcustomerFinancialDetails\": {'+
                '                \"@odata.etag\": \"W/\\\"JzIwOzEzMzQ0MDU4NzE3Mjk3MzY0Mzc2MTswMDsn\\\"\",'+
                '                \"id\": \"96dae0b5-28eb-ed11-8848-000d3a65b0ee\",'+
                '                \"number\": \"102278\",'+
                '                \"balance\": 0,'+
                '                \"totalSalesExcludingTax\": 529.2,'+
                '                \"overdueAmount\": 0,'+
                '                \"Global_Dimension_1_Filter\": \"\",'+
                '                \"Global_Dimension_2_Filter\": \"\",'+
                '                \"Currency_Filter\": \"\",'+
                '                \"Date_Filter\": \"\'\'..08/17/23\"'+
                '            }'+
                '        },'+
                '        {'+
                '            \"@odata.etag\": \"W/\\\"JzE5Ozc4ODM5NjYwNzAyNzcwNDQ1ODcxOzAwOyc=\\\"\",'+
                '            \"id\": \"db572cb8-48eb-ed11-8848-000d3a65b0ee\",'+
                '            \"number\": \"102280\",'+
                '            \"displayName\": \"TBMA - BELGIÃ‹\",'+
                '            \"type\": \"Company\",'+
                '            \"addressLine1\": \"BARON VAN LOOLAAN 9\",'+
                '            \"addressLine2\": \"\",'+
                '            \"city\": \"ERTVELDE\",'+
                '            \"state\": \"\",'+
                '            \"country\": \"BE\",'+
                '            \"postalCode\": \"9940\",'+
                '            \"phoneNumber\": \"\",'+
                '            \"email\": \"accounting@tbma.be\",'+
                '            \"website\": \"\",'+
                '            \"salespersonCode\": \"\",'+
                '            \"balanceDue\": 0,'+
                '            \"creditLimit\": 0,'+
                '            \"taxLiable\": true,'+
                '            \"taxAreaId\": \"00932620-2330-ed11-97e8-000d3aac7d5b\",'+
                '            \"taxAreaDisplayName\": \"Klanten/leveranciers (binnenland)\",'+
                '            \"taxRegistrationNumber\": \"BE0472158188\",'+
                '            \"currencyId\": \"00000000-0000-0000-0000-000000000000\",'+
                '            \"currencyCode\": \"EUR\",'+
                '            \"paymentTermsId\": \"99b92c37-2230-ed11-97e8-000d3aac7d5b\",'+
                '            \"shipmentMethodId\": \"00000000-0000-0000-0000-000000000000\",'+
                '            \"paymentMethodId\": \"00000000-0000-0000-0000-000000000000\",'+
                '            \"blocked\": \" \",'+
                '            \"genBusPostingGroup\": \"BINNENL\",'+
                '            \"vatBusPostingGroup\": \"BINNENL\",'+
                '            \"custPostingGroup\": \"ALGEMEEN\",'+
                '            \"lastModifiedDateTime\": \"2023-05-05T13:28:34.907Z\",'+
                '            \"Date_Filter\": \"\",'+
                '            \"Global_Dimension_1_Filter\": \"\",'+
                '            \"Global_Dimension_2_Filter\": \"\",'+
                '            \"Currency_Filter\": \"\",'+
                '            \"CustomersGTcustomerFinancialDetails\": {'+
                '                \"@odata.etag\": \"W/\\\"JzE5OzExOTgyNDg2MzgyNDczNTE4OTkxOzAwOyc=\\\"\",'+
                '                \"id\": \"db572cb8-48eb-ed11-8848-000d3a65b0ee\",'+
                '                \"number\": \"102280\",'+
                '                \"balance\": 0,'+
                '                \"totalSalesExcludingTax\": 426,'+
                '                \"overdueAmount\": 0,'+
                '                \"Global_Dimension_1_Filter\": \"\",'+
                '                \"Global_Dimension_2_Filter\": \"\",'+
                '                \"Currency_Filter\": \"\",'+
                '                \"Date_Filter\": \"\'\'..08/17/23\"'+
                '            }'+
                '        },'+
                '        {'+
                '            \"@odata.etag\": \"W/\\\"JzIwOzE2NDMxNTEyMzc1MzkxMjI1MTU4MTswMDsn\\\"\",'+
                '            \"id\": \"91570ca2-e9dd-ed11-a7c7-000d3a65bdb0\",'+
                '            \"number\": \"102248\",'+
                '            \"displayName\": \"VM-TEGELS BV\",'+
                '            \"type\": \"Company\",'+
                '            \"addressLine1\": \"KANAALSTRAAT 10\",'+
                '            \"addressLine2\": \"\",'+
                '            \"city\": \"HERTSBERGE\",'+
                '            \"state\": \"\",'+
                '            \"country\": \"BE\",'+
                '            \"postalCode\": \"8020\",'+
                '            \"phoneNumber\": \"\",'+
                '            \"email\": \"invoices@vm-tegels.be\",'+
                '            \"website\": \"\",'+
                '            \"salespersonCode\": \"\",'+
                '            \"balanceDue\": 0,'+
                '            \"creditLimit\": 0,'+
                '            \"taxLiable\": true,'+
                '            \"taxAreaId\": \"00932620-2330-ed11-97e8-000d3aac7d5b\",'+
                '            \"taxAreaDisplayName\": \"Klanten/leveranciers (binnenland)\",'+
                '            \"taxRegistrationNumber\": \"BE0714940082\",'+
                '            \"currencyId\": \"00000000-0000-0000-0000-000000000000\",'+
                '            \"currencyCode\": \"EUR\",'+
                '            \"paymentTermsId\": \"99b92c37-2230-ed11-97e8-000d3aac7d5b\",'+
                '            \"shipmentMethodId\": \"00000000-0000-0000-0000-000000000000\",'+
                '            \"paymentMethodId\": \"00000000-0000-0000-0000-000000000000\",'+
                '            \"blocked\": \" \",'+
                '            \"genBusPostingGroup\": \"BINNENL\",'+
                '            \"vatBusPostingGroup\": \"BINNENL\",'+
                '            \"custPostingGroup\": \"ALGEMEEN\",'+
                '            \"lastModifiedDateTime\": \"2023-04-18T13:05:04.48Z\",'+
                '            \"Date_Filter\": \"\",'+
                '            \"Global_Dimension_1_Filter\": \"\",'+
                '            \"Global_Dimension_2_Filter\": \"\",'+
                '            \"Currency_Filter\": \"\",'+
                '            \"CustomersGTcustomerFinancialDetails\": {'+
                '                \"@odata.etag\": \"W/\\\"JzE4OzgwNDgxMjYxOTU2NTA2OTk2NDE7MDA7Jw==\\\"\",'+
                '                \"id\": \"91570ca2-e9dd-ed11-a7c7-000d3a65bdb0\",'+
                '                \"number\": \"102248\",'+
                '                \"balance\": 0,'+
                '                \"totalSalesExcludingTax\": 321.86,'+
                '                \"overdueAmount\": 0,'+
                '                \"Global_Dimension_1_Filter\": \"\",'+
                '                \"Global_Dimension_2_Filter\": \"\",'+
                '                \"Currency_Filter\": \"\",'+
                '                \"Date_Filter\": \"\'\'..08/17/23\"'+
                '            }'+
                '        },'+
                '        {'+
                '            \"@odata.etag\": \"W/\\\"JzIwOzE0NTYyNTUzMTE4NTEzMTA1NzkzMTswMDsn\\\"\",'+
                '            \"id\": \"f12d9cd6-8dde-ed11-a7c7-000d3a65bdb0\",'+
                '            \"number\": \"102250\",'+
                '            \"displayName\": \"WURTH BELUX\",'+
                '            \"type\": \"Company\",'+
                '            \"addressLine1\": \"EVERDONGENLAAN 29/A\",'+
                '            \"addressLine2\": \"\",'+
                '            \"city\": \"TURNHOUT\",'+
                '            \"state\": \"\",'+
                '            \"country\": \"BE\",'+
                '            \"postalCode\": \"2300\",'+
                '            \"phoneNumber\": \"\",'+
                '            \"email\": \"pierrot.cardyn@wurth.be; LBH@wurth.be\",'+
                '            \"website\": \"\",'+
                '            \"salespersonCode\": \"\",'+
                '            \"balanceDue\": 0,'+
                '            \"creditLimit\": 0,'+
                '            \"taxLiable\": true,'+
                '            \"taxAreaId\": \"00932620-2330-ed11-97e8-000d3aac7d5b\",'+
                '            \"taxAreaDisplayName\": \"Klanten/leveranciers (binnenland)\",'+
                '            \"taxRegistrationNumber\": \"BE0435180897\",'+
                '            \"currencyId\": \"00000000-0000-0000-0000-000000000000\",'+
                '            \"currencyCode\": \"EUR\",'+
                '            \"paymentTermsId\": \"99b92c37-2230-ed11-97e8-000d3aac7d5b\",'+
                '            \"shipmentMethodId\": \"00000000-0000-0000-0000-000000000000\",'+
                '            \"paymentMethodId\": \"00000000-0000-0000-0000-000000000000\",'+
                '            \"blocked\": \" \",'+
                '            \"genBusPostingGroup\": \"BINNENL\",'+
                '            \"vatBusPostingGroup\": \"BINNENL\",'+
                '            \"custPostingGroup\": \"ALGEMEEN\",'+
                '            \"lastModifiedDateTime\": \"2023-06-29T12:20:22.043Z\",'+
                '            \"Date_Filter\": \"\",'+
                '            \"Global_Dimension_1_Filter\": \"\",'+
                '            \"Global_Dimension_2_Filter\": \"\",'+
                '            \"Currency_Filter\": \"\",'+
                '            \"CustomersGTcustomerFinancialDetails\": {'+
                '                \"@odata.etag\": \"W/\\\"JzE5OzcxMDY3NTgxMTc2NzQwMDI4NDYxOzAwOyc=\\\"\",'+
                '                \"id\": \"f12d9cd6-8dde-ed11-a7c7-000d3a65bdb0\",'+
                '                \"number\": \"102250\",'+
                '                \"balance\": 0,'+
                '                \"totalSalesExcludingTax\": 425,'+
                '                \"overdueAmount\": 0,'+
                '                \"Global_Dimension_1_Filter\": \"\",'+
                '                \"Global_Dimension_2_Filter\": \"\",'+
                '                \"Currency_Filter\": \"\",'+
                '                \"Date_Filter\": \"\'\'..08/17/23\"'+
                '            }'+
                '        },'+
                '        {'+
                '            \"@odata.etag\": \"W/\\\"JzE5Ozk0OTY4OTUzNzkwMDk5NDkzODQxOzAwOyc=\\\"\",'+
                '            \"id\": \"2e8db7f0-99de-ed11-a7c7-000d3a65bdb0\",'+
                '            \"number\": \"102251\",'+
                '            \"displayName\": \"STET HEEMSKERK B.V.\",'+
                '            \"type\": \"Company\",'+
                '            \"addressLine1\": \"STRENGWEG 00003 C\",'+
                '            \"addressLine2\": \"\",'+
                '            \"city\": \"HEEMSKERK\",'+
                '            \"state\": \"\",'+
                '            \"country\": \"NL\",'+
                '            \"postalCode\": \"1969KP\",'+
                '            \"phoneNumber\": \"\",'+
                '            \"email\": \"factuur@stetheemskerk.nl\",'+
                '            \"website\": \"\",'+
                '            \"salespersonCode\": \"\",'+
                '            \"balanceDue\": 0,'+
                '            \"creditLimit\": 0,'+
                '            \"taxLiable\": true,'+
                '            \"taxAreaId\": \"00932620-2330-ed11-97e8-000d3aac7d5b\",'+
                '            \"taxAreaDisplayName\": \"Klanten/leveranciers (binnenland)\",'+
                '            \"taxRegistrationNumber\": \"NL008276067B01\",'+
                '            \"currencyId\": \"00000000-0000-0000-0000-000000000000\",'+
                '            \"currencyCode\": \"EUR\",'+
                '            \"paymentTermsId\": \"99b92c37-2230-ed11-97e8-000d3aac7d5b\",'+
                '            \"shipmentMethodId\": \"00000000-0000-0000-0000-000000000000\",'+
                '            \"paymentMethodId\": \"00000000-0000-0000-0000-000000000000\",'+
                '            \"blocked\": \" \",'+
                '            \"genBusPostingGroup\": \"BINNENL\",'+
                '            \"vatBusPostingGroup\": \"BINNENL\",'+
                '            \"custPostingGroup\": \"ALGEMEEN\",'+
                '            \"lastModifiedDateTime\": \"2023-04-19T10:07:09.17Z\",'+
                '            \"Date_Filter\": \"\",'+
                '            \"Global_Dimension_1_Filter\": \"\",'+
                '            \"Global_Dimension_2_Filter\": \"\",'+
                '            \"Currency_Filter\": \"\",'+
                '            \"CustomersGTcustomerFinancialDetails\": {'+
                '                \"@odata.etag\": \"W/\\\"JzE5Ozc3NjQ4NTYxMjg0NzgzNjUyNDIxOzAwOyc=\\\"\",'+
                '                \"id\": \"2e8db7f0-99de-ed11-a7c7-000d3a65bdb0\",'+
                '                \"number\": \"102251\",'+
                '                \"balance\": 0,'+
                '                \"totalSalesExcludingTax\": 350,'+
                '                \"overdueAmount\": 0,'+
                '                \"Global_Dimension_1_Filter\": \"\",'+
                '                \"Global_Dimension_2_Filter\": \"\",'+
                '                \"Currency_Filter\": \"\",'+
                '                \"Date_Filter\": \"\'\'..08/17/23\"'+
                '            }'+
                '        }'+
                '    ]'+
                '}';

        return json;
    }

    @IsTest
    static String getCustomerJson() {
        String json = '{'+
                '    \"@odata.context\": \"https://api.businesscentral.dynamics.com/v2.0/c78ce9f9-94d2-46dd-afcf-c12e881cc810/Production/ODataV4/$metadata#Company(\'GTR\')/CustomersGT\",'+
                '    \"value\": ['+
                '        {'+
                '            \"@odata.etag\": \"W/\\\"JzIwOzEzNTI5MDMzNjY2NDE0NjUzNDQxMTswMDsn\\\"\",'+
                '            \"id\": \"96dae0b5-28eb-ed11-8848-000d3a65b0ee\",'+
                '            \"number\": \"102278\",'+
                '            \"displayName\": \"RYMBU\",'+
                '            \"type\": \"Company\",'+
                '            \"addressLine1\": \"KLEINE DOORNSTRAAT 27\",'+
                '            \"addressLine2\": \"\",'+
                '            \"city\": \"WILRIJK (ANTWERPEN)\",'+
                '            \"state\": \"\",'+
                '            \"country\": \"BE\",'+
                '            \"postalCode\": \"2610\",'+
                '            \"phoneNumber\": \"\",'+
                '            \"email\": \"finance@rymbu.com\",'+
                '            \"website\": \"\",'+
                '            \"salespersonCode\": \"\",'+
                '            \"balanceDue\": 0,'+
                '            \"creditLimit\": 0,'+
                '            \"taxLiable\": true,'+
                '            \"taxAreaId\": \"00932620-2330-ed11-97e8-000d3aac7d5b\",'+
                '            \"taxAreaDisplayName\": \"Klanten/leveranciers (binnenland)\",'+
                '            \"taxRegistrationNumber\": \"BE0747825260\",'+
                '            \"currencyId\": \"00000000-0000-0000-0000-000000000000\",'+
                '            \"currencyCode\": \"EUR\",'+
                '            \"paymentTermsId\": \"99b92c37-2230-ed11-97e8-000d3aac7d5b\",'+
                '            \"shipmentMethodId\": \"00000000-0000-0000-0000-000000000000\",'+
                '            \"paymentMethodId\": \"00000000-0000-0000-0000-000000000000\",'+
                '            \"blocked\": \" \",'+
                '            \"genBusPostingGroup\": \"BINNENL\",'+
                '            \"vatBusPostingGroup\": \"BINNENL\",'+
                '            \"custPostingGroup\": \"ALGEMEEN\",'+
                '            \"lastModifiedDateTime\": \"2023-05-05T09:39:30.363Z\",'+
                '            \"Date_Filter\": \"\",'+
                '            \"Global_Dimension_1_Filter\": \"\",'+
                '            \"Global_Dimension_2_Filter\": \"\",'+
                '            \"Currency_Filter\": \"\"'+
                '        },'+
                '        {'+
                '            \"@odata.etag\": \"W/\\\"JzE5Ozc4ODM5NjYwNzAyNzcwNDQ1ODcxOzAwOyc=\\\"\",'+
                '            \"id\": \"db572cb8-48eb-ed11-8848-000d3a65b0ee\",'+
                '            \"number\": \"102280\",'+
                '            \"displayName\": \"TBMA - BELGIÃ‹\",'+
                '            \"type\": \"Company\",'+
                '            \"addressLine1\": \"BARON VAN LOOLAAN 9\",'+
                '            \"addressLine2\": \"\",'+
                '            \"city\": \"ERTVELDE\",'+
                '            \"state\": \"\",'+
                '            \"country\": \"BE\",'+
                '            \"postalCode\": \"9940\",'+
                '            \"phoneNumber\": \"\",'+
                '            \"email\": \"accounting@tbma.be\",'+
                '            \"website\": \"\",'+
                '            \"salespersonCode\": \"\",'+
                '            \"balanceDue\": 0,'+
                '            \"creditLimit\": 0,'+
                '            \"taxLiable\": true,'+
                '            \"taxAreaId\": \"00932620-2330-ed11-97e8-000d3aac7d5b\",'+
                '            \"taxAreaDisplayName\": \"Klanten/leveranciers (binnenland)\",'+
                '            \"taxRegistrationNumber\": \"BE0472158188\",'+
                '            \"currencyId\": \"00000000-0000-0000-0000-000000000000\",'+
                '            \"currencyCode\": \"EUR\",'+
                '            \"paymentTermsId\": \"99b92c37-2230-ed11-97e8-000d3aac7d5b\",'+
                '            \"shipmentMethodId\": \"00000000-0000-0000-0000-000000000000\",'+
                '            \"paymentMethodId\": \"00000000-0000-0000-0000-000000000000\",'+
                '            \"blocked\": \" \",'+
                '            \"genBusPostingGroup\": \"BINNENL\",'+
                '            \"vatBusPostingGroup\": \"BINNENL\",'+
                '            \"custPostingGroup\": \"ALGEMEEN\",'+
                '            \"lastModifiedDateTime\": \"2023-05-05T13:28:34.907Z\",'+
                '            \"Date_Filter\": \"\",'+
                '            \"Global_Dimension_1_Filter\": \"\",'+
                '            \"Global_Dimension_2_Filter\": \"\",'+
                '            \"Currency_Filter\": \"\"'+
                '        },'+
                '        {'+
                '            \"@odata.etag\": \"W/\\\"JzIwOzE2NDMxNTEyMzc1MzkxMjI1MTU4MTswMDsn\\\"\",'+
                '            \"id\": \"91570ca2-e9dd-ed11-a7c7-000d3a65bdb0\",'+
                '            \"number\": \"102248\",'+
                '            \"displayName\": \"VM-TEGELS BV\",'+
                '            \"type\": \"Company\",'+
                '            \"addressLine1\": \"KANAALSTRAAT 10\",'+
                '            \"addressLine2\": \"\",'+
                '            \"city\": \"HERTSBERGE\",'+
                '            \"state\": \"\",'+
                '            \"country\": \"BE\",'+
                '            \"postalCode\": \"8020\",'+
                '            \"phoneNumber\": \"\",'+
                '            \"email\": \"invoices@vm-tegels.be\",'+
                '            \"website\": \"\",'+
                '            \"salespersonCode\": \"\",'+
                '            \"balanceDue\": 0,'+
                '            \"creditLimit\": 0,'+
                '            \"taxLiable\": true,'+
                '            \"taxAreaId\": \"00932620-2330-ed11-97e8-000d3aac7d5b\",'+
                '            \"taxAreaDisplayName\": \"Klanten/leveranciers (binnenland)\",'+
                '            \"taxRegistrationNumber\": \"BE0714940082\",'+
                '            \"currencyId\": \"00000000-0000-0000-0000-000000000000\",'+
                '            \"currencyCode\": \"EUR\",'+
                '            \"paymentTermsId\": \"99b92c37-2230-ed11-97e8-000d3aac7d5b\",'+
                '            \"shipmentMethodId\": \"00000000-0000-0000-0000-000000000000\",'+
                '            \"paymentMethodId\": \"00000000-0000-0000-0000-000000000000\",'+
                '            \"blocked\": \" \",'+
                '            \"genBusPostingGroup\": \"BINNENL\",'+
                '            \"vatBusPostingGroup\": \"BINNENL\",'+
                '            \"custPostingGroup\": \"ALGEMEEN\",'+
                '            \"lastModifiedDateTime\": \"2023-04-18T13:05:04.48Z\",'+
                '            \"Date_Filter\": \"\",'+
                '            \"Global_Dimension_1_Filter\": \"\",'+
                '            \"Global_Dimension_2_Filter\": \"\",'+
                '            \"Currency_Filter\": \"\"'+
                '        },'+
                '        {'+
                '            \"@odata.etag\": \"W/\\\"JzIwOzE0NTYyNTUzMTE4NTEzMTA1NzkzMTswMDsn\\\"\",'+
                '            \"id\": \"f12d9cd6-8dde-ed11-a7c7-000d3a65bdb0\",'+
                '            \"number\": \"102250\",'+
                '            \"displayName\": \"WURTH BELUX\",'+
                '            \"type\": \"Company\",'+
                '            \"addressLine1\": \"EVERDONGENLAAN 29/A\",'+
                '            \"addressLine2\": \"\",'+
                '            \"city\": \"TURNHOUT\",'+
                '            \"state\": \"\",'+
                '            \"country\": \"BE\",'+
                '            \"postalCode\": \"2300\",'+
                '            \"phoneNumber\": \"\",'+
                '            \"email\": \"pierrot.cardyn@wurth.be; LBH@wurth.be\",'+
                '            \"website\": \"\",'+
                '            \"salespersonCode\": \"\",'+
                '            \"balanceDue\": 0,'+
                '            \"creditLimit\": 0,'+
                '            \"taxLiable\": true,'+
                '            \"taxAreaId\": \"00932620-2330-ed11-97e8-000d3aac7d5b\",'+
                '            \"taxAreaDisplayName\": \"Klanten/leveranciers (binnenland)\",'+
                '            \"taxRegistrationNumber\": \"BE0435180897\",'+
                '            \"currencyId\": \"00000000-0000-0000-0000-000000000000\",'+
                '            \"currencyCode\": \"EUR\",'+
                '            \"paymentTermsId\": \"99b92c37-2230-ed11-97e8-000d3aac7d5b\",'+
                '            \"shipmentMethodId\": \"00000000-0000-0000-0000-000000000000\",'+
                '            \"paymentMethodId\": \"00000000-0000-0000-0000-000000000000\",'+
                '            \"blocked\": \" \",'+
                '            \"genBusPostingGroup\": \"BINNENL\",'+
                '            \"vatBusPostingGroup\": \"BINNENL\",'+
                '            \"custPostingGroup\": \"ALGEMEEN\",'+
                '            \"lastModifiedDateTime\": \"2023-06-29T12:20:22.043Z\",'+
                '            \"Date_Filter\": \"\",'+
                '            \"Global_Dimension_1_Filter\": \"\",'+
                '            \"Global_Dimension_2_Filter\": \"\",'+
                '            \"Currency_Filter\": \"\"'+
                '        },'+
                '        {'+
                '            \"@odata.etag\": \"W/\\\"JzE5Ozk0OTY4OTUzNzkwMDk5NDkzODQxOzAwOyc=\\\"\",'+
                '            \"id\": \"2e8db7f0-99de-ed11-a7c7-000d3a65bdb0\",'+
                '            \"number\": \"102251\",'+
                '            \"displayName\": \"STET HEEMSKERK B.V.\",'+
                '            \"type\": \"Company\",'+
                '            \"addressLine1\": \"STRENGWEG 00003 C\",'+
                '            \"addressLine2\": \"\",'+
                '            \"city\": \"HEEMSKERK\",'+
                '            \"state\": \"\",'+
                '            \"country\": \"NL\",'+
                '            \"postalCode\": \"1969KP\",'+
                '            \"phoneNumber\": \"\",'+
                '            \"email\": \"factuur@stetheemskerk.nl\",'+
                '            \"website\": \"\",'+
                '            \"salespersonCode\": \"\",'+
                '            \"balanceDue\": 0,'+
                '            \"creditLimit\": 0,'+
                '            \"taxLiable\": true,'+
                '            \"taxAreaId\": \"00932620-2330-ed11-97e8-000d3aac7d5b\",'+
                '            \"taxAreaDisplayName\": \"Klanten/leveranciers (binnenland)\",'+
                '            \"taxRegistrationNumber\": \"NL008276067B01\",'+
                '            \"currencyId\": \"00000000-0000-0000-0000-000000000000\",'+
                '            \"currencyCode\": \"EUR\",'+
                '            \"paymentTermsId\": \"99b92c37-2230-ed11-97e8-000d3aac7d5b\",'+
                '            \"shipmentMethodId\": \"00000000-0000-0000-0000-000000000000\",'+
                '            \"paymentMethodId\": \"00000000-0000-0000-0000-000000000000\",'+
                '            \"blocked\": \" \",'+
                '            \"genBusPostingGroup\": \"BINNENL\",'+
                '            \"vatBusPostingGroup\": \"BINNENL\",'+
                '            \"custPostingGroup\": \"ALGEMEEN\",'+
                '            \"lastModifiedDateTime\": \"2023-04-19T10:07:09.17Z\",'+
                '            \"Date_Filter\": \"\",'+
                '            \"Global_Dimension_1_Filter\": \"\",'+
                '            \"Global_Dimension_2_Filter\": \"\",'+
                '            \"Currency_Filter\": \"\"'+
                '        }'+
                '    ]'+
                '}';
        return json;
    }

    @IsTest
    static String getTokenJson(){
        String json = '{\"token_type\":\"Bearer\",\"expires_in\":3599,\"ext_expires_in\":3599,\"access_token\":\"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6Ii1LSTNROW5OUjdiUm9meG1lWm9YcWJIWkdldyIsImtpZCI6Ii1LSTNROW5OUjdiUm9meG1lWm9YcWJIWkdldyJ9.eyJhdWQiOiJodHRwczovL2FwaS5idXNpbmVzc2NlbnRyYWwuZHluYW1pY3MuY29tIiwiaXNzIjoiaHR0cHM6Ly9zdHMud2luZG93cy5uZXQvYzc4Y2U5ZjktOTRkMi00NmRkLWFmY2YtYzEyZTg4MWNjODEwLyIsImlhdCI6MTY5MjMzOTA3MywibmJmIjoxNjkyMzM5MDczLCJleHAiOjE2OTIzNDI5NzMsImFpbyI6IkUyRmdZSGpEZW5kbWtjY3JGNS9ZeWFhSmpTcTdBUT09IiwiYXBwaWQiOiI4ZTgxNjg5ZS1iYmM5LTQ0YjgtYTExNS0xMzcwZmRlMDM3YzgiLCJhcHBpZGFjciI6IjEiLCJpZHAiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC9jNzhjZTlmOS05NGQyLTQ2ZGQtYWZjZi1jMTJlODgxY2M4MTAvIiwiaWR0eXAiOiJhcHAiLCJvaWQiOiJiNGY4MTJlYi1lZTkxLTQ4ZTMtOWM4Ny02NDdkNWEwYzk4OTkiLCJyaCI6IjAuQVVjQS1lbU14OUtVM1Vhdno4RXVpQnpJRUQzdmJabHNzMU5CaGdlbV9Ud0J1SjlIQUFBLiIsInJvbGVzIjpbIkFQSS5SZWFkV3JpdGUuQWxsIl0sInN1YiI6ImI0ZjgxMmViLWVlOTEtNDhlMy05Yzg3LTY0N2Q1YTBjOTg5OSIsInRpZCI6ImM3OGNlOWY5LTk0ZDItNDZkZC1hZmNmLWMxMmU4ODFjYzgxMCIsInV0aSI6Ik9xR2xtTXRqd1VHbThuZ0t1QlZOQUEiLCJ2ZXIiOiIxLjAifQ.CXBFtOiFJoy6pT25aroi2yWTSjDe72ekiqUjPz__Zbv9Kk8DgUhdmCLBgHgU-lLLw_56DVyaQdfQruCvs3QavVY1xbFjoYsyH194bf3spDc15BlVEjMfh_ZZpzbtxieELGajJF98H12YnsFR-BuEIyo5f9iVA1EsLisl_8sK-ACUkz7S7aZ0tTnrtKbZqlyIIw1wsNzeEbT9pFfsGXS9sXePN-5npUt7mm5lqUX8BKSbbm_i6PI_QPj9kL0M38L-cYO354T3tlwZd3lUNP8_0ftlJIt7_49HfiRnoobDpfHLwa_ABAYpi2okCYUsdgm4ZfYq9Zz4gfT7NmFkkAKEaA\"}';
        return json;
    }
}