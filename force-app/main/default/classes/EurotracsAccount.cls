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
 * Created: 10/10/2023
 * Last Updated: 10/10/2023
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

public class EurotracsAccount {
    public String CustomerName;
    public String CustomerID;
    public String type;
    public Boolean Active;
    public Boolean IsBlocked;
    public String Street1;
    public String CityName;
    public String CountryCode;
    public String PostCode;
    public String Telephone1;
    public String Email1;
    public String EmailInvoice;
    public String VATNumber;
    public String Currency_x;
    public String CompanyVATGroup;
    public String CompanyPostingGroup;
    public String CompanyCustomerPostingGroup;
    public String PaymentTermName;
    public String SearchCode;
    public Integer CreditMaxValue;
    public String InvoicingAlias;
    public String PostAddressStreet1;
    public String PostAddressCityName;
    public String PostAddressCountry;
    public String PostAddressPostCode;

    public static EurotracsAccount parse(String json) {
        return (EurotracsAccount) System.JSON.deserialize(json, EurotracsAccount.class);
    }



}