/**
 * Created by Frederik on 5/06/2023.
 */

public with sharing class ContentDistributionController {

    public static void handleContentDistributionSync(Map<String, String> docIdsByVersionId){

        //Called by Trigger ContentVersion on After Insert
        //Checks for every ContentVersion if it has a ContentDistribution
        //If not, it creates a ContentDistribution
        //If yes, it updates the ContentDistribution with the new ContentVersionId

        //Get all ContentDistribution records for the ContentDocuments based on the docIdsByVersionId keyset

        system.debug('docIdsByVersionId: ' + docIdsByVersionId);

        List<ContentDistribution> contentDistributions = [SELECT Id, ContentDocumentId, ContentVersionId, ContentDownloadUrl, DistributionPublicUrl FROM ContentDistribution WHERE ContentDocumentId IN :docIdsByVersionId.keySet()];
        System.debug('ContentDistributions size: ' + contentDistributions.size());

        //Create a map of ContentDocumentId to ContentDistribution
        Map<Id, ContentDistribution> contentDistributionMap = new Map<Id, ContentDistribution>();
        for(ContentDistribution cd : contentDistributions){
            contentDistributionMap.put(cd.ContentDocumentId, cd);
        }

        System.debug('ContentDistributionMap size: ' + contentDistributionMap.size());

        //Create a map of ContentDocumentId to LinkedEntityId in which we will store only the ContentDocumentIds that are related to a Quote SObject
        Map<String, String> contentDocumentIdToLinkedEntityIdMap = new Map<String, String>();

        //Create a list of ContentDocumentLinks to query
        List<ContentDocumentLink> contentDocumentLinks = [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId IN :docIdsByVersionId.keySet()];

        System.debug('ContentDocumentLinks size: ' + contentDocumentLinks.size());

        //Loop through the ContentDocumentLinks and add the ContentDocumentId and LinkedEntityId to the map
        for(ContentDocumentLink cdl : contentDocumentLinks){
            System.debug('ContentDocumentLink: ' + cdl);
            System.debug('ContentDocumentLink LinkedEntityId: ' + cdl.LinkedEntityId);
            system.debug('cdl.LinkedEntityId.getSObjectType(): ' + cdl.LinkedEntityId.getSObjectType());
            if(cdl.LinkedEntityId.getSObjectType() == Quote.SObjectType) {
                contentDocumentIdToLinkedEntityIdMap.put(cdl.ContentDocumentId, cdl.LinkedEntityId);
            }
        }

        System.debug('contentDocumentIdToLinkedEntityIdMap: ' + contentDocumentIdToLinkedEntityIdMap);

        System.debug('ContentDocumentIdToLinkedEntityIdMap size: ' + contentDocumentIdToLinkedEntityIdMap.size());

        //Get all Quotes in the contentDocumentIdToLinkedEntityIdMap map values
        List<Quote> quotes = [SELECT Id, Name, ExpirationDate, Public_Document_URL__c FROM Quote WHERE Id IN :contentDocumentIdToLinkedEntityIdMap.values()];

        System.debug('Quotes size: ' + quotes.size());

        //Create a map of Quote Id to Quote
        Map<Id, Quote> quoteMap = new Map<Id, Quote>();
        for(Quote q : quotes){
            quoteMap.put(q.Id, q);
        }

        //Create a list of ContentDistribution records to insert
        List<ContentDistribution> contentDistributionsToInsert = new List<ContentDistribution>();

        //Create a list of ContentDistribution records to update
        List<ContentDistribution> contentDistributionsToUpdate = new List<ContentDistribution>();

        //Create a list of Quotes to update
        List<Quote> quotesToUpdate = new List<Quote>();

        //Loop through the ContentDocumentIds and check if there is a ContentDistribution for each

        for(String contentDocId : contentDocumentIdToLinkedEntityIdMap.keySet()){
            //If there is no ContentDistribution, create one
            if(!contentDistributionMap.containsKey(contentDocId)){
                System.debug('ContentDocumentId to create Distribution for: ' + contentDocId);
                System.debug('ContentVersionId to create Distribution for: ' + docIdsByVersionId.get(contentDocId));
                ContentDistribution cd = new ContentDistribution(
                        ContentVersionId = docIdsByVersionId.get(contentDocId),
                        Name = 'ContentDistribution for ' + quoteMap.get(contentDocumentIdToLinkedEntityIdMap.get(contentDocId)).Name,
                        PreferencesNotifyOnVisit = true,
                        PreferencesExpires = false,
                        PreferencesAllowViewInBrowser = true,
                        PreferencesAllowOriginalDownload = true);
                contentDistributionsToInsert.add(cd);
            }
            //If there is a ContentDistribution, update it
            else{
                System.debug('ContentDocumentId to update Distribution for: ' + contentDocId);
                ContentDistribution cd = contentDistributionMap.get(contentDocId);
                //cd.ContentVersionId = docIdsByVersionId.get(contentDocId);
                cd.PreferencesExpires = true;
                cd.ExpiryDate = quoteMap.get(contentDocumentIdToLinkedEntityIdMap.get(contentDocId)).ExpirationDate;
                contentDistributionsToUpdate.add(cd);
                //Update the Quote with the Public_Document_URL__c
                Quote q = quoteMap.get(contentDocumentIdToLinkedEntityIdMap.get(contentDocId));
                q.Public_Document_URL__c = cd.DistributionPublicUrl;
                quotesToUpdate.add(q);
            }
        }

        //Insert the ContentDistribution records
        if(contentDistributionsToInsert.size() > 0){
            insert contentDistributionsToInsert;
            List<ContentDistribution> cDisAfterInsert = [SELECT Id, ContentDocumentId, ContentVersionId, ContentDownloadUrl, DistributionPublicUrl FROM ContentDistribution WHERE ContentDocumentId IN :docIdsByVersionId.keySet()];
            for(ContentDistribution cd : cDisAfterInsert){
                System.debug('ContentDistribution after insert: ' + cd);
                Quote q = quoteMap.get(contentDocumentIdToLinkedEntityIdMap.get(cd.ContentDocumentId));
                q.Public_Document_URL__c = cd.DistributionPublicUrl;
                quotesToUpdate.add(q);
            }


        }

        //Update the ContentDistribution records
        if(contentDistributionsToUpdate.size() > 0){
            update contentDistributionsToUpdate;
        }

        //Update the Quotes
        if(quotesToUpdate.size() > 0){
            update quotesToUpdate;
        }

    }

}