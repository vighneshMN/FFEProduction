@isTest
public class FFEBatch_CNTLR_Test {
    @isTest
    Static void FFEBatchTest(){
        List<Training_Master__c> masterList = new List<Training_Master__c>();
        Training_Master__c master = new Training_Master__c();
        master.Name = 'Test';
        Training_Master__c master1 = new Training_Master__c();
        master1.Name = 'Test1';
        masterList.add(master);
        masterList.add(master1);
        Test.startTest();
        Test.setCurrentPage(Page.FFE_TrainingBatch);
        ApexPages.StandardSetController con = new ApexPages.StandardSetController(masterList);
        FFEBatchController ctlr = new FFEBatchController(con);
        Test.stopTest();
    }

}