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

public class ET_Account {

    public class Addresses {

        public Addresses(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        {
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    public class Contacts {
        public Integer ContactID {get;set;}
        public Object FirstName {get;set;}
        public String LastName {get;set;}
        public String Email1 {get;set;}
        public String Email2 {get;set;}
        public String Telephone1 {get;set;}
        public String Telephone2 {get;set;}
        public String Fax1 {get;set;}
        public String Fax2 {get;set;}
        public String Mobile1 {get;set;}
        public String Mobile2 {get;set;}
        public String Jobtitle {get;set;}
        public String IntegratorKey {get;set;}

        public Contacts(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'ContactID') {
                            ContactID = parser.getIntegerValue();
                        } else if (text == 'FirstName') {
                            FirstName = parser.getText();
                        } else if (text == 'LastName') {
                            LastName = parser.getText();
                        } else if (text == 'Email1') {
                            Email1 = parser.getText();
                        } else if (text == 'Email2') {
                            Email2 = parser.getText();
                        } else if (text == 'Telephone1') {
                            Telephone1 = parser.getText();
                        } else if (text == 'Telephone2') {
                            Telephone2 = parser.getText();
                        } else if (text == 'Fax1') {
                            Fax1 = parser.getText();
                        } else if (text == 'Fax2') {
                            Fax2 = parser.getText();
                        } else if (text == 'Mobile1') {
                            Mobile1 = parser.getText();
                        } else if (text == 'Mobile2') {
                            Mobile2 = parser.getText();
                        } else if (text == 'Jobtitle') {
                            Jobtitle = parser.getText();
                        } else if (text == 'IntegratorKey') {
                            IntegratorKey = parser.getText();
                        } else {
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    public Integer CustomerID {get;set;}
    public String PostAddressStreet1 {get;set;}
    public String PostAddressStreet2 {get;set;}
    public String PostAddressCityName {get;set;}
    public String PostAddressPostCode {get;set;}
    public String PostAddressCountry {get;set;}
    public String PostAddressDepartementName {get;set;}
    public String PaymentTermName {get;set;}
    public String InvoiceCustomerName {get;set;}
    public String CompanyVATGroup {get;set;}
    public String CompanyPostingGroup {get;set;}
    public List<Contacts> Contacts {get;set;}
    public List<Addresses> Addresses {get;set;}
    public List<Addresses> Units {get;set;}
    public List<Addresses> Products {get;set;}
    public List<Addresses> Instructions {get;set;}
    public List<Addresses> Materials {get;set;}
    public List<Addresses> Planningzones {get;set;}
    public List<Addresses> TransportTypes {get;set;}
    public List<Addresses> VehiclePricings {get;set;}
    public Boolean Active {get;set;}
    public String CustomerName {get;set;}
    public String CustomerName2 {get;set;}
    public String VATNumber {get;set;}
    public String IBAN {get;set;}
    public String BIC {get;set;}
    public Boolean IsBlocked {get;set;}
    public String BlockedDate {get;set;}
    public String BlockedReason {get;set;}
    public String Street1 {get;set;}
    public String Street2 {get;set;}
    public String CityName {get;set;}
    public String PostCode {get;set;}
    public String CountryCode {get;set;}
    public String DepartementName {get;set;}
    public String Fax1 {get;set;}
    public String Fax2 {get;set;}
    public String Email1 {get;set;}
    public String Email2 {get;set;}
    public String Mobile1 {get;set;}
    public String Mobile2 {get;set;}
    public String Telephone1 {get;set;}
    public String Telephone2 {get;set;}
    public Boolean Prospect {get;set;}
    public Boolean Suspect {get;set;}
    public String Remark {get;set;}
    public String EmailInvoice {get;set;}
    public String LanguageIsoCode {get;set;}
    public String Currency_Z {get;set;} // in json: Currency
    public String InvoicingAlias {get;set;}
    public String CreditValue {get;set;}
    public String CreditMaxValue {get;set;}
    public String Siret {get;set;}
    public String Siren {get;set;}
    public String SearchCode {get;set;}

    public ET_Account(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'CustomerID') {
                        CustomerID = parser.getIntegerValue();
                    } else if (text == 'PostAddressStreet1') {
                        PostAddressStreet1 = parser.getText();
                    } else if (text == 'PostAddressStreet2') {
                        PostAddressStreet2 = parser.getText();
                    } else if (text == 'PostAddressCityName') {
                        PostAddressCityName = parser.getText();
                    } else if (text == 'PostAddressPostCode') {
                        PostAddressPostCode = parser.getText();
                    } else if (text == 'PostAddressCountry') {
                        PostAddressCountry = parser.getText();
                    } else if (text == 'PostAddressDepartementName') {
                        PostAddressDepartementName = parser.getText();
                    } else if (text == 'PaymentTermName') {
                        PaymentTermName = parser.getText();
                    } else if (text == 'InvoiceCustomerName') {
                        InvoiceCustomerName = parser.getText();
                    } else if (text == 'CompanyVATGroup') {
                        CompanyVATGroup = parser.getText();
                    } else if (text == 'CompanyPostingGroup') {
                        CompanyPostingGroup = parser.getText();
                    } else if (text == 'Contacts') {
                        Contacts = arrayOfContacts(parser);
                    } else if (text == 'Addresses') {
                        Addresses = arrayOfAddresses(parser);
                    } else if (text == 'Units') {
                        Units = arrayOfAddresses(parser);
                    } else if (text == 'Products') {
                        Products = arrayOfAddresses(parser);
                    } else if (text == 'Instructions') {
                        Instructions = arrayOfAddresses(parser);
                    } else if (text == 'Materials') {
                        Materials = arrayOfAddresses(parser);
                    } else if (text == 'Planningzones') {
                        Planningzones = arrayOfAddresses(parser);
                    } else if (text == 'TransportTypes') {
                        TransportTypes = arrayOfAddresses(parser);
                    } else if (text == 'VehiclePricings') {
                        VehiclePricings = arrayOfAddresses(parser);
                    } else if (text == 'Active') {
                        Active = parser.getBooleanValue();
                    } else if (text == 'CustomerName') {
                        CustomerName = parser.getText();
                    } else if (text == 'CustomerName2') {
                        CustomerName2 = parser.getText();
                    } else if (text == 'VATNumber') {
                        VATNumber = parser.getText();
                    } else if (text == 'IBAN') {
                        IBAN = parser.getText();
                    } else if (text == 'BIC') {
                        BIC = parser.getText();
                    } else if (text == 'IsBlocked') {
                        IsBlocked = parser.getBooleanValue();
                    } else if (text == 'BlockedDate') {
                        BlockedDate = parser.getText();
                    } else if (text == 'BlockedReason') {
                        BlockedReason = parser.getText();
                    } else if (text == 'Street1') {
                        Street1 = parser.getText();
                    } else if (text == 'Street2') {
                        Street2 = parser.getText();
                    } else if (text == 'CityName') {
                        CityName = parser.getText();
                    } else if (text == 'PostCode') {
                        PostCode = parser.getText();
                    } else if (text == 'CountryCode') {
                        CountryCode = parser.getText();
                    } else if (text == 'DepartementName') {
                        DepartementName = parser.getText();
                    } else if (text == 'Fax1') {
                        Fax1 = parser.getText();
                    } else if (text == 'Fax2') {
                        Fax2 = parser.getText();
                    } else if (text == 'Email1') {
                        Email1 = parser.getText();
                    } else if (text == 'Email2') {
                        Email2 = parser.getText();
                    } else if (text == 'Mobile1') {
                        Mobile1 = parser.getText();
                    } else if (text == 'Mobile2') {
                        Mobile2 = parser.getText();
                    } else if (text == 'Telephone1') {
                        Telephone1 = parser.getText();
                    } else if (text == 'Telephone2') {
                        Telephone2 = parser.getText();
                    } else if (text == 'Prospect') {
                        Prospect = parser.getBooleanValue();
                    } else if (text == 'Suspect') {
                        Suspect = parser.getBooleanValue();
                    } else if (text == 'Remark') {
                        Remark = parser.getText();
                    } else if (text == 'EmailInvoice') {
                        EmailInvoice = parser.getText();
                    } else if (text == 'LanguageIsoCode') {
                        LanguageIsoCode = parser.getText();
                    } else if (text == 'Currency') {
                        Currency_Z = parser.getText();
                    } else if (text == 'InvoicingAlias') {
                        InvoicingAlias = parser.getText();
                    } else if (text == 'CreditValue') {
                        CreditValue = parser.getText();
                    } else if (text == 'CreditMaxValue') {
                        CreditMaxValue = parser.getText();
                    } else if (text == 'Siret') {
                        Siret = parser.getText();
                    } else if (text == 'Siren') {
                        Siren = parser.getText();
                    } else if (text == 'SearchCode') {
                        SearchCode = parser.getText();
                    } else {
                        consumeObject(parser);
                    }
                }
            }
        }
    }


    public static List<ET_Account> parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return arrayOfET_Account(parser);
    }

    public static void consumeObject(System.JSONParser parser) {
        Integer depth = 0;
        do {
            System.JSONToken curr = parser.getCurrentToken();
            if (curr == System.JSONToken.START_OBJECT ||
                    curr == System.JSONToken.START_ARRAY) {
                depth++;
            } else if (curr == System.JSONToken.END_OBJECT ||
                    curr == System.JSONToken.END_ARRAY) {
                depth--;
            }
        } while (depth > 0 && parser.nextToken() != null);
    }




    private static List<ET_Account> arrayOfET_Account(System.JSONParser p) {
        List<ET_Account> res = new List<ET_Account>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new ET_Account(p));
        }
        return res;
    }




    private static List<Contacts> arrayOfContacts(System.JSONParser p) {
        List<Contacts> res = new List<Contacts>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Contacts(p));
        }
        return res;
    }



    private static List<Addresses> arrayOfAddresses(System.JSONParser p) {
        List<Addresses> res = new List<Addresses>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Addresses(p));
        }
        return res;
    }



}