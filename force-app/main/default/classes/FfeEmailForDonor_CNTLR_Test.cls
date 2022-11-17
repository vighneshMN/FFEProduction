@isTest
public class FfeEmailForDonor_CNTLR_Test {
    @isTest
    static void FfeEmailForDonorTest(){
        Contact con = new Contact();
        con.LastName = 'test';
        List<Contact> conList = new List<Contact>();
        conList.add(con);
        Test.startTest();
        Test.setCurrentPage(Page.FFE_Email_For_Donor);
        ApexPages.StandardSetController contrlr = new ApexPages.StandardSetController(conList);
        FfeEmailForDonorController controller = new FfeEmailForDonorController(contrlr);
        Test.stopTest();
    }

}