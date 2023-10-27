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

public with sharing class Logger {

    public static void errorLogger(HttpResponse response, String target, String recordId, String type){

        Sync_Error__c error = new Sync_Error__c();
        error.Error_Message__c = response.getBody();
        error.Record_Id__c = recordId;
        error.Target__c = target;
        error.Type__c = type;
        error.Timestamp__c = Datetime.now();
        insert error;
    }

}