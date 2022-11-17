@isTest
public class FFE_AP_IntiateRefundTest {
    @isTest
    static void RefundTest(){
        Test.startTest();
        Contact student = Utility_Test.insertNewStudentRec('ABC','ZYX','8898898899','studenttest@gmail.com','7829488975','studenttest@gmail.com','studenttestfb@gmail.com',70,90,'cet','2016');
        insert student;
        Application__c app = Utility_Test.insertNewApplication('Selected','Submitted');
        app.Student__c = student.id;
        insert app;
        FFE_AP_InitiateRefundClass.getApplicationDetails(app.id);
        FFE_AP_InitiateRefundClass.getRefundDetails(app.id);
        FFE_AP_InitiateRefundClass.processRecords(app.id);
        Test.stopTest();
    }

}