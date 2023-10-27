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

@isTest
public class ET_Account_Test {

    @IsTest
    // This test method should give 100% coverage
    static void testParse() {
        String json = '['+
                '    {'+
                '        \"CustomerID\": 242255,'+
                '        \"PostAddressStreet1\": null,'+
                '        \"PostAddressStreet2\": null,'+
                '        \"PostAddressCityName\": null,'+
                '        \"PostAddressPostCode\": null,'+
                '        \"PostAddressCountry\": null,'+
                '        \"PostAddressDepartementName\": null,'+
                '        \"PaymentTermName\": null,'+
                '        \"InvoiceCustomerName\": null,'+
                '        \"CompanyVATGroup\": \"Customer/supplier BE\",'+
                '        \"CompanyPostingGroup\": null,'+
                '        \"Contacts\": ['+
                '            {'+
                '                \"ContactID\": 294951,'+
                '                \"FirstName\": null,'+
                '                \"LastName\": \"MATERNE CONFILUX SA\",'+
                '                \"Email1\": \"ADMIN@FILLINGMACHINE.BE\",'+
                '                \"Email2\": null,'+
                '                \"Telephone1\": null,'+
                '                \"Telephone2\": null,'+
                '                \"Fax1\": null,'+
                '                \"Fax2\": null,'+
                '                \"Mobile1\": null,'+
                '                \"Mobile2\": null,'+
                '                \"Jobtitle\": null,'+
                '                \"IntegratorKey\": null'+
                '            }'+
                '        ],'+
                '        \"Addresses\": [],'+
                '        \"Units\": [],'+
                '        \"Products\": [],'+
                '        \"Instructions\": [],'+
                '        \"Materials\": [],'+
                '        \"Planningzones\": [],'+
                '        \"TransportTypes\": [],'+
                '        \"VehiclePricings\": [],'+
                '        \"Active\": true,'+
                '        \"CustomerName\": \"ALPACO\",'+
                '        \"CustomerName2\": null,'+
                '        \"VATNumber\": \"BE0405533046\",'+
                '        \"IBAN\": null,'+
                '        \"BIC\": null,'+
                '        \"IsBlocked\": false,'+
                '        \"BlockedDate\": null,'+
                '        \"BlockedReason\": null,'+
                '        \"Street1\": \"POLDERSTRAAT 15\",'+
                '        \"Street2\": null,'+
                '        \"CityName\": \"TIELT\",'+
                '        \"PostCode\": \"8700\",'+
                '        \"CountryCode\": \"BE\",'+
                '        \"DepartementName\": null,'+
                '        \"Fax1\": null,'+
                '        \"Fax2\": null,'+
                '        \"Email1\": \"admin@fillingmachine.be\",'+
                '        \"Email2\": null,'+
                '        \"Mobile1\": null,'+
                '        \"Mobile2\": null,'+
                '        \"Telephone1\": null,'+
                '        \"Telephone2\": null,'+
                '        \"Prospect\": false,'+
                '        \"Suspect\": false,'+
                '        \"Remark\": null,'+
                '        \"EmailInvoice\": \"admin@fillingmachine.be\",'+
                '        \"LanguageIsoCode\": null,'+
                '        \"Currency\": \"EUR\",'+
                '        \"InvoicingAlias\": \"102132\",'+
                '        \"CreditValue\": null,'+
                '        \"CreditMaxValue\": null,'+
                '        \"Siret\": \"0\",'+
                '        \"Siren\": \"0\",'+
                '        \"SearchCode\": \"2132\"'+
                '    }'+
                ']';
        List<ET_Account> r = ET_Account.parse(json);
        System.assert(r != null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        ET_Account.Addresses objAddresses = new ET_Account.Addresses(System.JSON.createParser(json));
        System.assert(objAddresses != null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        ET_Account.Contacts objContacts = new ET_Account.Contacts(System.JSON.createParser(json));
        System.assert(objContacts != null);
        System.assert(objContacts.ContactID == null);
        System.assert(objContacts.FirstName == null);
        System.assert(objContacts.LastName == null);
        System.assert(objContacts.Email1 == null);
        System.assert(objContacts.Email2 == null);
        System.assert(objContacts.Telephone1 == null);
        System.assert(objContacts.Telephone2 == null);
        System.assert(objContacts.Fax1 == null);
        System.assert(objContacts.Fax2 == null);
        System.assert(objContacts.Mobile1 == null);
        System.assert(objContacts.Mobile2 == null);
        System.assert(objContacts.Jobtitle == null);
        System.assert(objContacts.IntegratorKey == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        ET_Account objET_Account = new ET_Account(System.JSON.createParser(json));
        System.assert(objET_Account != null);
        System.assert(objET_Account.CustomerID == null);
        System.assert(objET_Account.PostAddressStreet1 == null);
        System.assert(objET_Account.PostAddressStreet2 == null);
        System.assert(objET_Account.PostAddressCityName == null);
        System.assert(objET_Account.PostAddressPostCode == null);
        System.assert(objET_Account.PostAddressCountry == null);
        System.assert(objET_Account.PostAddressDepartementName == null);
        System.assert(objET_Account.PaymentTermName == null);
        System.assert(objET_Account.InvoiceCustomerName == null);
        System.assert(objET_Account.CompanyVATGroup == null);
        System.assert(objET_Account.CompanyPostingGroup == null);
        System.assert(objET_Account.Contacts == null);
        System.assert(objET_Account.Addresses == null);
        System.assert(objET_Account.Units == null);
        System.assert(objET_Account.Products == null);
        System.assert(objET_Account.Instructions == null);
        System.assert(objET_Account.Materials == null);
        System.assert(objET_Account.Planningzones == null);
        System.assert(objET_Account.TransportTypes == null);
        System.assert(objET_Account.VehiclePricings == null);
        System.assert(objET_Account.Active == null);
        System.assert(objET_Account.CustomerName == null);
        System.assert(objET_Account.CustomerName2 == null);
        System.assert(objET_Account.VATNumber == null);
        System.assert(objET_Account.IBAN == null);
        System.assert(objET_Account.BIC == null);
        System.assert(objET_Account.IsBlocked == null);
        System.assert(objET_Account.BlockedDate == null);
        System.assert(objET_Account.BlockedReason == null);
        System.assert(objET_Account.Street1 == null);
        System.assert(objET_Account.Street2 == null);
        System.assert(objET_Account.CityName == null);
        System.assert(objET_Account.PostCode == null);
        System.assert(objET_Account.CountryCode == null);
        System.assert(objET_Account.DepartementName == null);
        System.assert(objET_Account.Fax1 == null);
        System.assert(objET_Account.Fax2 == null);
        System.assert(objET_Account.Email1 == null);
        System.assert(objET_Account.Email2 == null);
        System.assert(objET_Account.Mobile1 == null);
        System.assert(objET_Account.Mobile2 == null);
        System.assert(objET_Account.Telephone1 == null);
        System.assert(objET_Account.Telephone2 == null);
        System.assert(objET_Account.Prospect == null);
        System.assert(objET_Account.Suspect == null);
        System.assert(objET_Account.Remark == null);
        System.assert(objET_Account.EmailInvoice == null);
        System.assert(objET_Account.LanguageIsoCode == null);
        System.assert(objET_Account.Currency_Z == null);
        System.assert(objET_Account.InvoicingAlias == null);
        System.assert(objET_Account.CreditValue == null);
        System.assert(objET_Account.CreditMaxValue == null);
        System.assert(objET_Account.Siret == null);
        System.assert(objET_Account.Siren == null);
        System.assert(objET_Account.SearchCode == null);
    }
}