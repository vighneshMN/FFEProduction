@isTest
public class FFE_AP_RejectAppn_Test {
    @isTest
    static void getDetailsTest(){
        contact con = Utility_Test.insertSingleStudent('Aditya','Kamat');
        insert con;
        Application__c newApp     =  new Application__c();
        newApp.Internal_Status__c     = 'Disbursed';
        newApp.Application_Type__c    = Constants.APPLICATIONTYPE_NEW;
        newApp.Application_Stage__c   = Constants.APP_STAGE_OPEN;
       // newApp.Course_Name__c = 'B'
		newApp.student__c =  con.id;
		insert newApp;
        test.startTest();
        FFE_AP_RejectApplicationClass.getApplicationDetails(newApp.id);
        FFE_AP_RejectApplicationClass.processRecords(newApp.id);
        test.stopTest();
        
    }

}