@isTest
public class DocumentMissingCntrlTest {
    @isTest
    static void getPiklistValuesTest()
    {
        Contact student = Utility_Test.insertSingleStudent('jayanth','b');  
       student.MobilePhone = '1234567890';
        insert student;
        Application__c app = new Application__c();
        app.Application_Type__c = 'New';
        app.Student__c = student.id;
        insert app;
        
        List<string> docs = new List<string>();
        docs.add('testDoc');
        string content = 'qwerty';
        
        Test.startTest();
        DocumentMissingController.getPiklistValues(app.Id);
        DocumentMissingController.doStuff(docs, content, app.Id);
        Test.stopTest();
    }

}