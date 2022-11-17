@isTest public class SMS_Service_Helper_Test {
    @isTest public static void sendBulkSMS_Test(){
        List<String> contactNumbers = new List<String> {'7042458620','9560635420'};
            
        SMS_Service_Helper.sendBulkSMS(contactNumbers, 'testTextMessage');
        SMS_Service_Helper.sendSingleSMSFromBatch('7042458620', 'testTextMessage');
        SMS_Service_Helper.InsertSMSStatus('TestEndPointUrl', 'TestMessageBody', '1234567891', 'POST', 'testResponseBody', 201, 'Success');
        SMS_Service_Helper.sendSingleSMS('7042458620', 'testTextMessage');
        SMS_Service_Helper.InsertSMSStatus('TestEndPointUrl', null, '1234567891', 'POST', 'testResponseBody', 201, 'Success');
        
    }
    /* static testmethod void testSendSingleSMS(){
        User dummyUser = Utility_Test.createUser('dummyUser@ffeTest.com');
        insert dummyUser;
        system.runAs(dummyUser){ 
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new httpCalloutMockImpExecption());
            SMS_Service_Helper.sendSingleSMSFromBatch('7042458620', 'testTextMessage');    
            Test.stopTest(); 
        }        
    }*/
}