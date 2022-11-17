public with sharing class FFE_AP_RejectApplicationClass {

    @AuraEnabled(cacheable=true)
    public static list<Application__c> getApplicationDetails(Id recordId) {
        System.debug('recordId>>'+recordId);
        return [
            SELECT Id, Name, Internal_Status__c, Application_Stage__c
            FROM Application__c
            WHERE Id = :recordId
        ];
    } 
    @AuraEnabled
    public static Application__c processRecords(Id recordId) {
        
        Application__c appRec  = new Application__c();
        appRec = [
            SELECT Id, Name, Internal_Status__c, Application_Stage__c, Student__c
            FROM Application__c
            WHERE Id = :recordId
        ];

        appRec.Internal_Status__c = 'Rejected by FFE Staff';
        appRec.Application_Stage__c = 'Closed';
        update appRec;

        return appRec;
    }     
}