@isTest
public class FFEBalanceTransferHandlerTest {
    
    public static string createGAURecords(){
        String recordTypeDonor = [Select Id,Name from RecordType where Name='Donor'].Id;
        Contact destinationDonor = new Contact();
        destinationDonor.LastName = 'Test';
        destinationDonor.FirstName = 'Test';
        destinationDonor.RecordTypeId = recordTypeDonor;
        insert destinationDonor;
        Donor_Balance__c donorBalance = new Donor_Balance__c();
        donorBalance.Donor_Name__c = destinationDonor.Id;
        donorBalance.Current_Balance__c = 50000;
        insert donorBalance;
        
        Contact sourceDonor = new Contact();
        sourceDonor.LastName = 'Test';
        sourceDonor.FirstName = 'Test';
        sourceDonor.RecordTypeId = recordTypeDonor;
        insert sourceDonor;
        Donor_Balance__c sourcedonorBalance = new Donor_Balance__c();
        sourcedonorBalance.Donor_Name__c = sourceDonor.Id;
        sourcedonorBalance.Current_Balance__c = 20000;
        insert sourcedonorBalance;
        Business_Account__c ba = new Business_Account__c();
        ba.Name = 'GAC';
        ba.Account_No__c = '12345';
        insert ba;
        Donation_Program__c dp = new Donation_Program__c();
        dp.Name = 'Program';
        insert dp;
        npsp__General_Accounting_Unit__c GA = new npsp__General_Accounting_Unit__c();
        GA.Name = 'Test Unit';
        GA.Business_Account__c = ba.Id;
        GA.Program__c = dp.Id;
        insert GA;
        
        GAU_Balance_Transfer__c gbt = new GAU_Balance_Transfer__c();
        gbt.Destination_donor__c = destinationDonor.id;
        gbt.Destination_Donor_Balance__c = donorBalance.id;
        gbt.Source_donor__c = sourceDonor.Id;
        gbt.Donor_Balance__c = sourcedonorBalance.Id;
        gbt.Destination_GAU__c = GA.Id;
        insert gbt;
        
        return gbt.Id;
    }
    
    static testMethod void runNegativeTests(){
        GAU_Balance_Transfer__c gbt = FFEBalanceTransferHandler.getBalanceTransfer('AA12212312321');
        string recordId = createGAURecords();
        string message = FFEBalanceTransferHandler.updateGBT(recordId, 1234567890);
    }
    
    static testMethod void runPositiveTests(){
        string recordId = createGAURecords();
        GAU_Balance_Transfer__c gbt = FFEBalanceTransferHandler.getBalanceTransfer(recordId);
        string message = FFEBalanceTransferHandler.updateGBT(recordId, 5000);
        string result = FFEBalanceTransferHandler.refundAmount(gbt.Source_GAU__c, gbt.Destination_donor__c, 
                                                               gbt.Destination_Donor_Balance__c, 5000, gbt.Donor_Balance__c, 1000);
    }

}