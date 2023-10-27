/**
 * Created by Frederik on 3/06/2023.
 */

public without sharing class QuoteAcceptController {

    @AuraEnabled
    public static Quote getQuote(String recordId) {
        System.debug('QuoteAcceptController.getQuote()');
        system.debug('recordId: ' + recordId);
        Quote quote = [SELECT Id, Name, Status, ExpirationDate, Public_Document_URL__c FROM Quote where Id = :recordId];
        return quote;
    }

    @AuraEnabled
    public static Boolean acceptQuote(String quoteId, Boolean accepted, Boolean declined, String comments, String email, boolean termsAccepted, Boolean transportAccepted, Boolean paymentTermsAccepted) {
        System.debug('QuoteAcceptController.acceptQuote()');
        system.debug('recordId: ' + quoteId);
        System.debug('accepted: ' + accepted);
        System.debug('declined: ' + declined);
        System.debug('comments: ' + comments);
        System.debug('email: ' + email);
        Quote quote = [SELECT Id, Name, Status, ExpirationDate, Public_Document_URL__c FROM Quote where Id = :quoteId];
        if (accepted) {
            quote.Status = 'Accepted';
        } else if (declined) {
            quote.Status = 'Denied';
        }
        quote.Customer_Remarks__c = comments;
        quote.Accepted_By_Email__c = email;
        quote.Accepted_Date_Time__c = System.now();
        quote.Acceptance_terms_and_conditions__c = termsAccepted;
        quote.Acceptance_transport__c = transportAccepted;
        quote.Acceptance_Payment__c = paymentTermsAccepted;
        update quote;
        return true;
    }

}