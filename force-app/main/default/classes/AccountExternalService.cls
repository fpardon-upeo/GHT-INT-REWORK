/**
@Description: Service Class that handles the data synchronization between Salesforce and external systems (Business Central, Eurotracs and the GHT Portal.

@Change Log:
Date        Developer        Description
----------  --------------   --------------------------------------------------------------------
12/10/2023  Frederik Pardon  Created

@Dependencies:
    AccountExternalMapper,
    Callout,
    CalloutHandler,
    BusinessCentralAccount,
    EurotracsResponse,
    PortalAccount,
    ET_Token,
    PortalToken,
    Sync_Log__c

@Test Classes:

*/

public class AccountExternalService {

    /**-------------------------------------VARIABLES-------------------------------------**/
    /**
     * @description Variables used to store the sync results. These variables are used in the logSyncResults method.
     * The logSyncResults method is called after the sync methods are called. The logSyncResults method will log the sync results in the Sync_Log__c object.
    */

    public static String recordId;
    public static String bcStatusCode;
    public static String etStatusCode;
    public static String pStatusCode;
    public static String bcStatusMessage;
    public static String etStatusMessage;
    public static String pStatusMessage;
    public static String bcRequestBody;
    public static String etRequestBody;
    public static String pRequestBody;
    public static String bcResponseBody;
    public static String etResponseBody;
    public static String pResponseBody;
    public static Boolean hasBCResponse = false;
    public static Boolean hasETResponse = false;
    public static Boolean hasPResponse = false;
    public static Boolean hasBadResponse = false;
    public static String badResponse;

    /**-------------------------------------HANDLERS-------------------------------------**/

    /**
     * @param accounts - List of accounts to be synchronized with the external system.
     * @description This method can be called from a trigger or a batch class. It is used to synchronize a list of accounts with the external system.
     * It's not used for now, but it can be used in the future if needed.
     */

    public static void accountHandler(List<Account> accounts){


        Boolean isSandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;

        String environmentType = isSandbox == true ? 'UAT' : 'Production';

        for(Account acc : accounts){
            accountRequest(acc.Id, 'Update', acc.Legal_Entities__c, environmentType);
        }
    }

    /**
     * @param accountId - Id of the account to be synchronized with the external system.
     * @param operation - Operation to be performed on the external system. (Create, Update). For now only Update is used.
     * @param legalEntity - Legal entity of the account to be synchronized with the external system. Used to retrieve the correct CMDT
     * @param environmentType - Type of environment. (Production, UAT)
     * @description This method is called from the AccountUpdateInvocable class. It is used to synchronize a single account with the external system.
     * It will first gets the correct CMDT record based on the legal entity and environment type. Then it will get the account with all the needed fields.
     * Then it will map the Business Central values from the custom object and set them in the account. After that it will call the sync methods for the external systems.
     * It will also update the account with the last sync date and time.
     * Lastly it will log the sync results in the Sync_Log__c object.
     *
    */

    @Future(callout=true)
    public static void accountRequest(String accountId, String operation, String legalEntity, String environmentType){

        recordId = accountId;

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

        //Get the account with all the needed fields
        Account acc = AccountExternalMapper.getAccountById(accountId);

        //Get the Business Central values from the custom object and set them in the account
        acc = AccountExternalMapper.prepareAccount(acc, legalEntity);

        Datetime lastBCSync;
        Datetime lastETSync;
        Datetime lastPSync;

        System.debug('acc.Payment_Term__c: ' + acc.Payment_Terms__c);

        if(acc.BC_Id__c != null){
            lastBCSync = syncBusinessCentralCustomer(acc, configRecord.Company__c, operation);
        }

        if(acc.Eurotracs_Id__c != null && (bcStatusCode == '200' || bcStatusCode == '201')){
            lastETSync = syncEtracsCustomer(acc, configRecord.Eurotracs_Instance__c, operation);
        }

        if(acc.Portal_Id__c != null && (bcStatusCode == '200' || bcStatusCode == '201') && (etStatusCode == '200' || etStatusCode == '201')){
            lastPSync = syncPortalCustomer(acc.Id, operation, legalEntity);
        }

        Account accToUpdate = new Account(Update_External_Customer__c =false, Id = acc.Id, Last_BC_Sync__c = lastBCSync, Last_Eurotracs_Sync__c = lastETSync, Last_Portal_Sync__c = lastPSync);
        update accToUpdate;
        logSyncResults();

    }

    /**-------------------------------------SYNC Logic-------------------------------------**/

    /**
     * @param accountId - Id of the account to be synchronized with the external system.
     * @param operation - Operation to be performed on the external system. (Create, Update). For now only Update is used.
     * @param legalEntity - Legal entity of the account to be synchronized with the external system. Used to set the correct legal entity in the account.
     * @return Datetime - Returns the current date and time if the sync was successful. Returns null if the sync failed.
     * @description This method is used to synchronize a single account with the GHT Portal. It will first get the account with all the needed fields.
     * Then it will map the Portal values from the custom object and set them in the account. After that it will call the sync methods for the external systems.
     *
     *
    */

    public static Datetime syncPortalCustomer(String accountId, String operation, String legalEntity){

        Account acc = AccountExternalMapper.getAccountForPortalById(accountId);
        Integer companyId = 0;
        if(legalEntity == 'Gheeraert Transport' ){
            acc.Legal_Entities__c ='0' ;
        } else {
            acc.Legal_Entities__c = '446';
        }

        String pAJson = AccountExternalMapper.mapAccountToPortal(acc);
        String portalToken = getPortalToken();

        Callout callout = new Callout();
        String calloutEndpoint = 'callout:Portal/api/Customer/';
        Map<String, String> headers = new Map<String, String>();
        headers.put('Authorization', 'Bearer ' + portalToken);
        headers.put('Content-Type', 'application/json');

        if(operation == 'Update'){
            calloutEndpoint = calloutEndpoint + acc.Portal_Id__c;
            callout = Callout.preparePutCallout(calloutEndpoint, pAJson, headers);
        } else {
            calloutEndpoint = calloutEndpoint + '0';
            callout = Callout.preparePostCallout(calloutEndpoint, pAJson, headers);
        }

        CalloutHandler calloutHandler = new CalloutHandler();
        HttpResponse res = calloutHandler.makeCallout(callout);

        pStatusCode = String.valueOf(res.getStatusCode());
        pStatusMessage = res.getStatus();
        pRequestBody = pAJson;
        pResponseBody = res.getBody();
        hasPResponse = true;

        if(res.getStatusCode() == 200 || res.getStatusCode() == 201){
            PortalAccount paAccount = PortalAccount.parse(res.getBody());
            return System.now();
        } else {
            hasBadResponse = true;
            badResponse = res.getBody();
            return null;
        }
    }

    /**
    * @param acc - Account to be synchronized with the external system.
     * @param environment - Environment of the external system. (Production, UAT)
     * @param operation - Operation to be performed on the external system. (Create, Update). For now only Update is used.
     * @return Datetime - Returns the current date and time if the sync was successful. Returns null if the sync failed.
     * @description This method is used to synchronize a single account with Eurotracs. It will first get the account with all the needed fields.
     * Then it will map the Eurotracs values from the custom object and set them in the account. After that it will call the sync methods for the external systems.
     *
    */

    public static Datetime syncEtracsCustomer(Account acc, String environment, String operation){

        String etAccountJson = AccountExternalMapper.mapAccountToEurotracs(acc);

        String accessToken = getETracsToken();
        String calloutEndpoint;
        Map<String, String> headers = new Map<String, String>();
        Callout callout = new Callout();


        if(operation == 'Update'){
            calloutEndpoint = 'callout:ETGTR/api/Customer/UpdateCustomers';
            headers.put('Authorization', 'Bearer ' + accessToken);
            headers.put('Content-Type', 'application/json');
            headers.put('Accept', '*/*');
            headers.put('Accept-Encoding', 'gzip, deflate, br');
            headers.put('Connection', 'keep-alive');
            callout = Callout.preparePutCallout(calloutEndpoint, etAccountJson, headers);

            CalloutHandler calloutHandler = new CalloutHandler();
            HttpResponse res = calloutHandler.makeCallout(callout);
        }

        CalloutHandler calloutHandler = new CalloutHandler();
        HttpResponse res = calloutHandler.makeCallout(callout);

        etStatusCode = String.valueOf(res.getStatusCode());
        etStatusMessage = res.getStatus();
        etRequestBody = etAccountJson;
        etResponseBody = res.getBody();
        hasETResponse = true;
        System.debug('res: ' + res);
        System.debug('res.getBody(): ' + res.getBody());
        System.debug('res.getStatusCode(): ' + res.getStatusCode());


        EurotracsResponse etResponse = new EurotracsResponse();
        if(res.getStatusCode() == 200 || res.getStatusCode() == 201){
            try {
                etResponse = EurotracsResponse.parse(res.getBody());
            } catch (Exception e){
                System.debug('caught exception: ' + e.getMessage());
                hasBadResponse = true;
                badResponse = res.getBody();
                return null;
            }
            System.debug('etResponse: ' + etResponse);
            return System.now();
        } else {
            hasBadResponse = true;
            badResponse = res.getBody();
            return null;
        }

    }

    /**
     * @param acc - Account to be synchronized with the external system.
     * @param companyId - Id of the company in Business Central.
     * @param operation - Operation to be performed on the external system. (Create, Update). For now only Update is used.
     * @return Datetime - Returns the current date and time if the sync was successful. Returns null if the sync failed.
     * @description This method is used to synchronize a single account with Business Central. It will first get the account with all the needed fields.
     * Then it will map the Business Central values from the custom object and set them in the account. After that it will call the sync methods for the external systems.
     *
     */

    public static Datetime syncBusinessCentralCustomer(Account acc, String companyId, String operation){

        System.debug('operation: ' + operation);

        String bcAccountJson = AccountExternalMapper.mapAccountToBusinessCentral(acc);
        String calloutEndpoint;
        if(operation == 'Create'){
            System.debug('operation is Create');
            calloutEndpoint = 'callout:Dynamics_BC' + '/ODataV4/Company(\'' + companyId + '\')/CustomersGT';
        } else {
            System.debug('operation is Update');
            calloutEndpoint = 'callout:Dynamics_BC' + '/ODataV4/Company(\'' + companyId + '\')/CustomersGT(' + acc.BC_Id__c + ')';
        }

        Callout callout = new Callout();

        if(operation == 'Update'){

            Map<String, String> headers = new Map<String, String>();
            headers.put('If-Match', '*');
            headers.put('Content-Type', 'application/json');
            headers.put('Accept', 'application/json');
            callout = Callout.preparePatchCallout(calloutEndpoint, bcAccountJson, headers);

        }

        CalloutHandler calloutHandler = new CalloutHandler();
        HttpResponse res = calloutHandler.makeCallout(callout);

        bcStatusCode = String.valueOf(res.getStatusCode());
        bcStatusMessage = res.getStatus();
        bcRequestBody = bcAccountJson;
        bcResponseBody = res.getBody();
        hasBCResponse = true;

        if(res.getStatusCode() == 200 || res.getStatusCode() == 201){
            BusinessCentralAccount bcAccountResponse = BusinessCentralAccount.parse(res.getBody());
            return System.now();
        } else {
            hasBadResponse = true;
            badResponse = res.getBody();
            return null;
        }
    }

    /**-------------------------------------HELPERS-------------------------------------**/

    /**
     * @description This method is used to log the sync results in the Sync_Log__c object.
     */

    public static void logSyncResults(){

        List<Sync_Log__c> logs = new List<Sync_Log__c>();

        if(hasBCResponse){
            Sync_Log__c bcLog = new Sync_Log__c(
                    Status_Code__c = bcStatusCode,
                    Status_Message__c = bcStatusMessage,
                    Request_Body__c = bcRequestBody,
                    Response_Body__c = bcResponseBody,
                    Target__c = 'Business Central',
                    Record_Id__c = recordId
            );
            logs.add(bcLog);
        }

        if(hasETResponse){
            Sync_Log__c etLog = new Sync_Log__c(
                    Status_Code__c = etStatusCode,
                    Status_Message__c = etStatusMessage,
                    Request_Body__c = etRequestBody,
                    Response_Body__c = etResponseBody,
                    Target__c = 'Eurotracs',
                    Record_Id__c = recordId
            );
            logs.add(etLog);
        }

        if(hasPResponse){
            Sync_Log__c pLog = new Sync_Log__c(
                    Status_Code__c = pStatusCode,
                    Status_Message__c = pStatusMessage,
                    Request_Body__c = pRequestBody,
                    Response_Body__c = pResponseBody,
                    Target__c = 'Portal',
                    Record_Id__c = recordId
            );
            logs.add(pLog);
        }

        if(hasBadResponse == true){
            Sync_Log__c badLog = new Sync_Log__c(
                    Status_Code__c = 'ERROR',
                    Status_Message__c = 'Bad Request',
                    Request_Body__c = badResponse,
                    Response_Body__c = badResponse,
                    Target__c = 'Bad Request',
                    Record_Id__c = recordId
            );
            logs.add(badLog);
        }

        insert logs;

    }

    /**
     * @description This method is used to get the access token for the Eurotracs API. It uses the credentials stored in a Named Credential.
     * @return String - Returns the access token.
     */

    public static String getETracsToken(){

        String endpoint = 'callout:ETGTR'+'/token';

        System.debug('endpoint: ' + endpoint);

        //Create the request
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setBody('grant_type=password&username={!$Credential.ETGTR.username}&password={!$Credential.ETGTR.password}');
        req.setTimeout(60000);

        //Send the request
        Http http = new Http();
        HttpResponse res = http.send(req);

        ET_Token token = ET_Token.parse(res.getBody());
        System.debug('token: ' + token);
        return token.access_token;
    }

    /**
     * @description This method is used to get the access token for the GHT Portal API. It uses the credentials stored in a Named Credential.
     * @return String - Returns the access token.
     */

    public static String getPortalToken(){

        String endpoint = 'callout:Portal'+'/token';

        System.debug('endpoint: ' + endpoint);

        //Create the request
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setBody('grant_type=password&username={!$Credential.Portal.username}&password={!$Credential.Portal.password}');

        //Send the request
        Http http = new Http();
        HttpResponse res = http.send(req);

        //parse the access_token from the response
        PortalToken token = PortalToken.parse(res.getBody());
        String access_token = token.access_token;
        return access_token;
    }


}