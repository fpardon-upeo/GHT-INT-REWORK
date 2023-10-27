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
 * Created: 11/10/2023
 * Last Updated: 11/10/2023
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

public class AccountExternalMapper {

    /**
     * Helper method to get the account by the id
     *
     * @param accountId The Id of the account
     *
     * @return acc The account
     */

    public static Account getAccountById(String accountId) {
        Account acc = [SELECT Id,
                Credit_Limit__c,
                BC_Id__c,
                Eurotracs_Id__c,
                Eurotracs_GDI_Id__c,
                Legal_Entities__c,
                Portal_Id__c,
                Type,
                Active__c,
                Blocked__c,
                Customer_Number__c,
                Company_VAT_Group__c,
                Company_Posting_Group__c,
                Company_Customer_Posting_Group__c,
                Name,
                BillingStreet,
                BillingCity,
                BillingPostalCode,
                CurrencyIsoCode,
                BillingCountryCode,
                ShippingStreet,
                ShippingCity,
                ShippingPostalCode,
                ShippingCountryCode,
                Payment_Terms__c,
                Payment_Method__c,
                VAT_Number__c,
                Phone,
                Email__c,
                Invoicing_Email__c,
                Invoicing_Alias__c,
                ADR_Allowed__c,
                Customer_POD__c,
                Loading_To_TMS__c,
                Tax_Area__c
        FROM Account
        WHERE Id = :accountId];
        System.debug('acc: ' + acc);
        return acc;
    }

    public static Account getAccountForPortalById(String accountId){

        Account acc = [SELECT Id,
                Credit_Limit__c,
                BC_Id__c,
                Eurotracs_Id__c,
                Eurotracs_GDI_Id__c,
                Legal_Entities__c,
                Portal_Id__c,
                Type,
                Active__c,
                Blocked__c,
                Customer_Number__c,
                Company_VAT_Group__c,
                Company_Posting_Group__c,
                Company_Customer_Posting_Group__c,
                Name,
                Description,
                BillingStreet,
                BillingCity,
                BillingPostalCode,
                CurrencyIsoCode,
                BillingCountryCode,
                ShippingStreet,
                ShippingCity,
                ShippingPostalCode,
                ShippingCountryCode,
                Payment_Terms__c,
                Payment_Method__c,
                VAT_Number__c,
                Phone,
                Email__c,
                Invoicing_Email__c,
                Invoicing_Alias__c,
                ADR_Allowed__c,
                Customer_POD__c,
                Loading_To_TMS__c,
                New_Order_Status_in_Portal__c,
                Allow_Neutral_Pickup_Address__c,
                Plan_Depot__c,
                Tax_Area__c FROM Account WHERE Id = :accountId];
        return acc;
    }

    /**
     * Helper method that get the Business Central values needed for syncing the Account.
     *
     * @param acc The Account sObject that needs to be synced
     * @param legalEntity The legal entity of the account
     *
     * @return acc The account with the Business Central values
     */

    public static Account prepareAccount(Account acc, String legalEntity){

        if(legalEntity == 'Gheeraert Distribution'){
            acc.Eurotracs_Id__c = acc.Eurotracs_GDI_Id__c;
        }

        if(acc.Payment_Terms__c != null){
            List<Business_Central_Config__c> paymentTerms = [SELECT Id, BC_Id__c, Name, Code__c, Display_Name__c FROM Business_Central_Config__c WHERE Table__c = 'paymentTerms' and Code__c = :acc.Payment_Terms__c];
            acc.Payment_Terms__c = paymentTerms[0].BC_Id__c;
        }

        if(acc.Tax_Area__c != null){
            List<Business_Central_Config__c> taxAreas = [SELECT Id, BC_Id__c, Name, Code__c, Display_Name__c FROM Business_Central_Config__c WHERE Table__c = 'taxAreas' and Code__c = :acc.Tax_Area__c];
            acc.Tax_Area__c = taxAreas[0].BC_Id__c;
        }

        if(acc.Payment_Method__c != null){
            List<Business_Central_Config__c> paymentMethods = [SELECT Id, BC_Id__c, Name, Code__c, Display_Name__c FROM Business_Central_Config__c WHERE Table__c = 'paymentMethods' and Code__c = :acc.Payment_Method__c];
            acc.Payment_Method__c = paymentMethods[0].BC_Id__c;
            System.debug('paymentMethods[0].BC_Id__c: ' + paymentMethods[0].BC_Id__c);
        }

        return acc;
    }

    /**
     * Transforms the Account to a Business Central Account and returns the JSON string.
     *
     * @param acc the Account that needs to be transformed
     *
     * @return bcAccountJson The JSON string of the Business Central Account
     */

    public static String mapAccountToBusinessCentral(Account acc){

        BusinessCentralAccount bcAccount = new BusinessCentralAccount();
        bcAccount.displayName = acc.Name;
        bcAccount.type = 'Company';
        bcAccount.id = acc.BC_Id__c != null ? acc.BC_Id__c : null;
        bcAccount.addressLine1 = acc.BillingStreet;
        bcAccount.city = acc.BillingCity;
        bcAccount.postalCode = acc.BillingPostalCode;
        bcAccount.country = acc.BillingCountryCode;
        bcAccount.currencyCode = acc.CurrencyIsoCode;
        bcAccount.phoneNumber = acc.Phone;
        bcAccount.email = acc.Email__c;
        bcAccount.taxLiable = true;
        bcAccount.creditLimit = acc.Credit_Limit__c != null ? (Integer) acc.Credit_Limit__c : 0;
        bcAccount.taxRegistrationNumber = acc.VAT_Number__c;
        bcAccount.genBusPostingGroup = acc.Company_Posting_Group__c;
        bcAccount.vatBusPostingGroup = acc.Company_VAT_Group__c;
        bcAccount.custPostingGroup = acc.Company_Customer_Posting_Group__c;
        bcAccount.blocked = acc.Blocked__c == true ? 'All' : '';
        bcAccount.taxAreaId = acc.Tax_Area__c != null ? acc.Tax_Area__c : null;
        bcAccount.paymentTermsId = acc.Payment_Terms__c != null ? acc.Payment_Terms__c : null;
        bcAccount.paymentMethodId = acc.Payment_Method__c != null ? acc.Payment_Method__c : null;
        bcAccount.number_x = acc.Customer_Number__c;

        String bcAccountJson = JSON.serialize(bcAccount, true);
        bcAccountJson = bcAccountJson.replace('number_x', 'number');
        System.debug('bcAccountJson: ' + bcAccountJson);

        return bcAccountJson;
    }

    public static String mapAccountToEurotracs(Account acc){

        Map<String, String> postingCodesMap = new Map<String, String>();
        List<Business_Central_Config__c> configs = [SELECT Id, BC_Id__c, Name, Code__c, Display_Name__c FROM Business_Central_Config__c WHERE Table__c = 'etCustomer'];
        for(Business_Central_Config__c config : configs){
            postingCodesMap.put(config.Display_Name__c, config.Code__c);
        }

        EurotracsAccount etAccount = new EurotracsAccount();
        List<EurotracsAccount> etAccounts = new List<EurotracsAccount>();
        etAccount.CustomerName = acc.Name;
        etAccount.CustomerID = acc.Eurotracs_Id__c != null ? acc.Eurotracs_Id__c : null;
        etAccount.type = 'Company';
        etAccount.Active = acc.Active__c;
        etAccount.IsBlocked = acc.Blocked__c;
        etAccount.Street1 = acc.ShippingStreet;
        etAccount.CityName = acc.ShippingCity;
        etAccount.PostCode = acc.ShippingPostalCode;
        etAccount.CountryCode = acc.ShippingCountryCode;
        etAccount.PostAddressStreet1 = acc.BillingStreet;
        etAccount.PostAddressCityName = acc.BillingCity;
        etAccount.PostAddressPostCode = acc.BillingPostalCode;
        etAccount.PostAddressCountry = acc.BillingCountryCode;
        etAccount.Telephone1 = acc.Phone;
        etAccount.Email1 = acc.Email__c;
        etAccount.EmailInvoice = acc.Invoicing_Email__c;
        etAccount.VATNumber = acc.VAT_Number__c;
        etAccount.Currency_x = acc.CurrencyIsoCode;
        etAccount.CompanyVATGroup = acc.Company_VAT_Group__c != null ? postingCodesMap.get(acc.Company_VAT_Group__c) : null;
        etAccount.CompanyPostingGroup = acc.Company_Posting_Group__c != null ? postingCodesMap.get(acc.Company_Posting_Group__c) : null;
        etAccount.CompanyCustomerPostingGroup = acc.Company_Customer_Posting_Group__c;
        etAccount.PaymentTermName = acc.Payment_Terms__c;
        etAccount.SearchCode = acc.Portal_Id__c;
        etAccount.CreditMaxValue = acc.Credit_Limit__c != null ? (Integer) acc.Credit_Limit__c : 0;
        etAccount.InvoicingAlias = acc.Customer_Number__c;
        etAccounts.add(etAccount);

        String etAccountJson = JSON.serialize(etAccounts, true);
        etAccountJson = etAccountJson.replace('Currency_x', 'Currency');
        System.debug('etAccountJson: ' + etAccountJson);
        return etAccountJson;

    }

    public static String mapAccountToPortal(Account acc){

        List<String> userRoles = new List<String>();
        userRoles.add('Distribution');

        System.debug('New Order Status in Portal = ' +acc.New_Order_Status_in_Portal__c);

        PortalAccount pA = new PortalAccount();
        pA.CustomerName = acc.Name;
        pA.CustomerID = acc.Portal_Id__c != null ? Integer.valueOf(acc.Portal_Id__c) : null;
        pA.CustomerStreet = acc.ShippingStreet;
        pA.CustomerCity = acc.ShippingCity;
        pA.CustomerPC = acc.ShippingPostalCode;
        pA.CustomerCountry = acc.ShippingCountryCode;
        pA.CustomerPhone = acc.Phone;
        pA.CustomerEmail = acc.Email__c;
        pA.UserEmail = acc.Email__c;
        pA.UserRoles = userRoles;
        pA.CustomerVAT = acc.VAT_Number__c;
        pA.CustomerComment = acc.Description;
        pA.CustomerStatusID = acc.New_Order_Status_in_Portal__c != null ? Integer.valueOf(acc.New_Order_Status_in_Portal__c) : null;
        pA.IsActive = String.valueOf(acc.Active__c);
        pA.InternalCompanyID = acc.Plan_Depot__c != null ? Integer.valueOf(acc.Plan_Depot__c) : null;
        pA.AllowNeutral = acc.Allow_Neutral_Pickup_Address__c != null ? Integer.valueOf(acc.Allow_Neutral_Pickup_Address__c) : null;
        pA.ADRAllowed = acc.ADR_Allowed__c;
        pA.CustomerPOD = acc.Customer_POD__c;
        pA.ExtensionEDI = '';
        pA.loadingToTMS = acc.Loading_To_TMS__c;
        pA.PlanDepotID = acc.Plan_Depot__c != null ? Integer.valueOf(acc.Plan_Depot__c) : null;

        String pAJson = JSON.serialize(pA, true);
        System.debug('pAJson: ' + pAJson);
        return pAJson;
    }

}