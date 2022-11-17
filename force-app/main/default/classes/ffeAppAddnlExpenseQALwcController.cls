public class ffeAppAddnlExpenseQALwcController {

    @AuraEnabled
    public static String insertAdditionalExpenseApp(Id AppId){
        Application__c parentApplication = [SELECT Id, 
                                            	Student__c,
                                            	IsMapped__c,
                                            	Course_Name__c,
                                            	Year__c
                                            	FROM Application__c
                                            	WHERE ID =: AppId];
        Application__c additionalExpenseApp = new Application__c();
        additionalExpenseApp.Parent_Application__c = AppId;
        additionalExpenseApp.Student__c = parentApplication.Student__c;
        additionalExpenseApp.IsMapped__c = parentApplication.IsMapped__c;
        additionalExpenseApp.Course_Name__c = parentApplication.Course_Name__c;
        additionalExpenseApp.Year__c = parentApplication.Year__c;
        additionalExpenseApp.RecordTypeId = Schema.SObjectType.Application__c.getRecordTypeInfosByName().get('Additional Expense').getRecordTypeId();
        
        try{
            insert additionalExpenseApp;
            return 'Success';
        }
        catch(Exception E){
            system.debug('Exception while inserting Additional Expense : ' + E);
            return 'Fail';
        }
    } 
}