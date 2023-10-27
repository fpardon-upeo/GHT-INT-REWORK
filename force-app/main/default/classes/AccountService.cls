/**
 * This class contains two methods that facilitate data synchronization between Salesforce and external systems using Logic Apps.
 * The methods are marked with @Future(callout=true) to allow asynchronous callouts to the external systems, ensuring non-blocking execution.
 * The class serves as a bridge for integrating Salesforce with the Azure service and the GHT Azure Portal.
 *
 * Method: accountRequest
 * Description:
 * - This method sends the data from a specific Salesforce Account record to an Azure Logic App for further processing.
 * - It retrieves configuration details from the Azure_Config__mdt custom metadata type to build the Logic App callout URL.
 * - The Account record is fetched based on the provided accountId parameter.
 * - The method performs additional data transformations, such as mapping Payment Terms and Tax Area to their respective Business Central configurations.
 * - The transformed data is sent to the Logic App as a JSON payload through an HTTP POST request.
 *
 * Method: createPortalAccount
 * Description:
 * - This method is used for creating or updating portal accounts in an external system using a Logic App.
 * - It asynchronously sends data from the Salesforce Account object to the Logic App for further processing and integration with the portal.
 * - The method retrieves configuration details from the Azure_Config__mdt custom metadata type to construct the Logic App callout URL.
 * - The Account record is fetched based on the provided accountId parameter.
 * - Depending on the operation type ('Create' or 'Update'), the method sets the Portal_Id__c field to 0 or updates the Portal_URL__c field accordingly.
 * - Legal entity information is transformed into a format suitable for passing in the URL by replacing spaces with '%20'.
 * - The data is sent to the Logic App as a JSON payload through an HTTP POST request.
 *
 * Note: Both methods utilize the Apex HTTP class to interact with external systems and perform callouts.
 * The Azure_Config__mdt custom metadata type is used to store configurations required for integration.
 */

public with sharing class AccountService {

    /**
     * This method initiates a data synchronization process with an external system through a Logic App.
     * It asynchronously sends data from the Salesforce Account object to the Logic App for further processing and integration.
     * The method performs the following steps:
     *
     * 1. Queries the Azure_Config__mdt custom metadata type to retrieve configuration details for the data synchronization.
     * 2. Queries the Account object to retrieve the specific Account record identified by the accountId parameter.
     * 3. Maps data based on the legalEntity value. If legalEntity is 'Gheeraert Distribution', it maps Eurotracs_GDI_Id__c to Eurotracs_Id__c in the Account record.
     * 4. Queries the Business_Central_Config__c custom object to map specific fields in the Account record to Business Central IDs.
     * 5. Transforms the legalEntity field into a format suitable for passing in the URL by replacing spaces with '%20'.
     * 6. Constructs the callout URL to invoke the Logic App for data synchronization.
     * 7. Creates an HTTP POST request with the constructed URL and sends the Account record as JSON in the request body.
     * 8. Updates the Update_External_Customer__c field of the Account record to false after the data synchronization callout.
     *
     * The method is marked as @Future(callout=true) to run asynchronously, allowing it to perform callouts to external systems without blocking the current transaction.
     *
     * @param accountId      The ID of the Salesforce Account record to be synchronized with the external system.
     * @param operation      The type of operation to be performed in the external system (e.g., 'Create', 'Update').
     * @param legalEntity    The legal entity associated with the data to be synchronized.
     * @param environmentType The type of environment for data synchronization.
     */

    @Future(callout=true)
    public static void accountRequest(String accountId, String operation, String legalEntity, String environmentType, Boolean etOnly){

        Azure_Config__mdt configRecord = [SELECT
                Id,
                Eurotracs_Instance__c,
                Eurotracs_Environment__c,
                Operation__c,
                Company__c,
                Legal_Entity__c
        FROM Azure_Config__mdt
        WHERE Legal_Entity__c = :legalEntity
        and Eurotracs_Environment__c = :environmentType
        and Operation__c = :operation];

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

        //transform configRecord.Legal_Entity__c to a string that can be passed in the URL
        configRecord.Legal_Entity__c = configRecord.Legal_Entity__c.replace(' ', '%20');
        String url = 'callout:GHT_Azure' + '?api-version=2016-10-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=18OiUvraTDOF_37WIdSH9iweLHphoCf87mWJk3vh9a0' + '&legalEntity='+ configRecord.Legal_Entity__c +'&company=' + configRecord.Company__c + '&environment=' + configRecord.Eurotracs_Instance__c + '&environmentType=' + configRecord.Eurotracs_Environment__c + '&operation=' + operation + '&etOnly=' + etOnly;

        //Create a new HTTP request
        HttpRequest req = new HttpRequest();
        //Set the request method to POST
        req.setMethod('POST');
        //Set the request endpoint to the URL of the Logic App
        req.setEndpoint(url);
        //Set the request body to the account parameter
        req.setBody(JSON.serialize(acc));
        //Set the request content type to application/json
        req.setHeader('Content-Type', 'application/json');
        req.setTimeout(120000);

        //Send the request
        Http http = new Http();
        HttpResponse res = http.send(req);


    }

    /**
     * This method is used to create or update a portal account in an external system using a Logic App.
     * It asynchronously sends data from the Salesforce Account object to the Logic App for further processing and integration with the portal.
     * The method performs the following steps:
     *
     * 1. Queries the Azure_Config__mdt custom metadata type to retrieve configuration details for the data synchronization.
     * 2. Queries the Account object to retrieve the specific Account record identified by the accountId parameter.
     * 3. Based on the provided operation ('Create' or 'Update'), it either sets the Portal_Id__c field to 0 (for 'Create') or updates configRecord.Portal_URL__c with the value of acc.Portal_Id__c (for 'Update').
     * 4. Transforms the legalEntity field into a format suitable for passing in the URL by replacing spaces with '%20'.
     * 5. Sets the acc.Legal_Entities__c field based on the legalEntity value.
     * 6. Constructs the callout URL to invoke the Logic App for data synchronization with the portal.
     * 7. Creates an HTTP POST request with the constructed URL and sends the Account record as JSON in the request body.
     * 8. The method is marked as @Future(callout=true) to run asynchronously, allowing it to perform callouts to external systems without blocking the current transaction.
     *
     * @param accountId      The ID of the Salesforce Account record to be synchronized with the portal.
     * @param operation      The type of operation to be performed in the external system (e.g., 'Create', 'Update').
     * @param portalInstance The instance of the portal associated with the data synchronization.
     * @param legalEntity    The legal entity associated with the data to be synchronized.
     */

    public static void createPortalAccount(String accountId, String operation, String portalInstance, String legalEntity){

        Azure_Config__mdt configRecord = [SELECT Id, Portal_Token_URL__c, Legal_Entity__c, Operation__c, Portal_URL__c, Portal_Instance__c FROM Azure_Config__mdt WHERE Portal_Instance__c = :portalInstance and Operation__c = :operation LIMIT 1];

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
                New_Order_Status_in_Portal__c,
                Allow_Neutral_Pickup_Address__c,
                Plan_Depot__c,
                Tax_Area__c FROM Account WHERE Id = :accountId];
        System.debug('acc: ' + acc);

        if(operation == 'Create'){
            acc.Portal_Id__c = String.valueOf(0);
        } else if(operation == 'Update'){
            configRecord.Portal_URL__c = configRecord.Portal_URL__c  + acc.Portal_Id__c;
        }

        configRecord.Legal_Entity__c = legalEntity.replace(' ', '%20');
        Integer companyId = 0;
        if(legalEntity == 'Gheeraert Transport' ){
            acc.Legal_Entities__c ='0' ;
        } else {
            acc.Legal_Entities__c = '446';
        }

        String url = 'callout:GHT_Azure_Portal' + '?api-version=2016-10-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=uwZ-wvN6Hf3v3As9nHRtz_yUBlRuMHeUAC0xYOqKMVE' + '&legalEntity='+ configRecord.Legal_Entity__c +'&portalInstance=' + configRecord.Portal_Instance__c + '&operation=' + operation + '&url=' + configRecord.Portal_URL__c+'&companyId=' + companyId +'&tokenUrl='+configRecord.Portal_Token_URL__c;

        //Create a new HTTP request
        HttpRequest req = new HttpRequest();
        //Set the request method to POST
        req.setMethod('POST');
        //Set the request endpoint to the URL of the Logic App
        req.setEndpoint(url);
        //Set the request body to the account parameter
        req.setBody(JSON.serialize(acc));
        //Set the request content type to application/json
        req.setHeader('Content-Type', 'application/json');
        req.setTimeout(120000);

        //Send the request
        Http http = new Http();
        HttpResponse res = http.send(req);

    }

}