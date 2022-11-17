@isTest
public class ffePaymentGenerate80GForm_Test {
    @isTest
    static void ffePaymentGenerateTest(){
        User testUser = Utility_Test.createUser('pdfgenerate@testuser.com');
        System.runAs(testUser){
            
            Contact donor   = Utility_Test.insertNewContact('dummy', 'donor', '12121212', 'sample@donor.com', '12321232', 'sample@donor.com', 'sample@donor.com'); 
            insert donor;
            
            Payment_Order__c dummyOrder = Utility_Test.createPaymentOrder(donor.Id,'OrderNo');
            dummyOrder.Order_Amount__c  = 20000;
            insert dummyOrder;
            
            opportunity op = new Opportunity();
            op.ContactId = donor.id;
            op.StageName='Posted';
            op.Payment_Order__c = dummyOrder.id;
            op.CloseDate = date.today();
            op.Name = 'test1';
            insert op;
            
            Test.startTest();
            ffePaymentGenerate80GForm_CTRL.getBase64encoded(dummyOrder.id);
            ffePaymentGenerate80GForm_CTRL.getDonationsLwc(dummyOrder.id);
            Test.stopTest();
            
        }
    }

}