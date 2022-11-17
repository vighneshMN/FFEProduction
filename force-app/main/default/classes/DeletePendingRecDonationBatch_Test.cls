@isTest
public class DeletePendingRecDonationBatch_Test {
    
    
    @testSetup static void insertTestData() {
        Contact conRec = New Contact ();
        conRec.LastName = 'test';
        conRec.email = 'test24@gmail.com';
        conRec.phone = '9834932324';
        insert conRec;
        contact conRecData = [select name,id,AccountId from contact where email ='test24@gmail.com' limit 1];
		date closeDate = date.today();
        List<opportunity> oppList = New List<opportunity>();
        npe03__Recurring_Donation__c recDon = New npe03__Recurring_Donation__c();
        recDon.Name = 'Test';
        recDon.npe03__Amount__c = 20000;
        recDon.npe03__Date_Established__c = date.today();
        recDon.npe03__Installment_Period__c = 'Yearly';
        recDon.npe03__Organization__c = conRecData.AccountId;
        insert recDon;
        Opportunity opp1 = New Opportunity();
        opp1.npsp__Primary_Contact__c = conRec.Id;
        opp1.Name = 'Test';
        opp1.StageName = 'Posted';
        opp1.closeDate = closeDate.addMonths(-1);
        opp1.npe03__Recurring_Donation__c = recDon.Id;
        oppList.add(opp1);
        insert oppList;
    }
    
    public static testMethod void testschedule() {
        
        Test.StartTest();
        DeletePendingRecDonationBatch sh1 = new DeletePendingRecDonationBatch();
        
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test Territory Check', sch, sh1); 
        Test.stopTest(); 
    }
}