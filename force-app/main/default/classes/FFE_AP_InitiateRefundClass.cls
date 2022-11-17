public with sharing class FFE_AP_InitiateRefundClass {
    @AuraEnabled(cacheable=true)
    public static list<Refund__c> getRefundDetails(Id recordId) {
        System.debug('recordId>>'+recordId);
        return [
            SELECT Id, Name
            FROM Refund__c
            WHERE Application__c = :recordId
        ];
    }
    @AuraEnabled
    public static list<Application__c> getApplicationDetails(Id recordId) {
        System.debug('recordId>>'+recordId);
        return [
            SELECT Id, Name, Internal_Status__c, Application_Stage__c
            FROM Application__c
            WHERE Id = :recordId
        ];
    } 
    @AuraEnabled
    public static list<Refund__c> processRecords(Id recordId) {
        Refund__c refRec = new Refund__c();
        Application__c appRec  = new Application__c();
        appRec = [
            SELECT Id, Name, Internal_Status__c, Application_Stage__c, Student__c
            FROM Application__c
            WHERE Id = :recordId
        ];

        appRec.Internal_Status__c = 'Refund Initiated';
        update appRec;

        System.debug('st>>'+appRec.Student__c);
        refRec.Application__c = recordId;
        refRec.Student__c = appRec.Student__c;
        insert refRec;
        System.debug('refRec>>'+refRec);
        return [
            SELECT Id, Name, Student__c, Application__c
            FROM Refund__c
            WHERE Id = :refRec.Id
        ];
    }     
}