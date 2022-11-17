public with sharing class FFEBalanceTransferHandler {
   
    @AuraEnabled(cacheable=true)
    public static GAU_Balance_Transfer__c  getBalanceTransfer(String GAUId){
        GAU_Balance_Transfer__c gbt;
      List<GAU_Balance_Transfer__c> balanceTrasferList = [Select Id,Transfered_Fund__c,Total_Allocation__c,Current_Balance__c,Refunded_Amount__c,
      Source_GAU__c,Destination_donor__c,Destination_Donor_Balance__c,Donor_Balance__c from GAU_Balance_Transfer__c where Id=:GAUId];
        if(balanceTrasferList.size()>0){
            gbt = balanceTrasferList[0];
        }else{
            gbt = null;
        }  
        return gbt;
    }

    @AuraEnabled(cacheable=true)
    public static string refundAmount(String sourceGauId,String destinationdonor,String destinationDonorBalance,Integer refundingAmount,String sourceDBln,Integer sourceDonorbalanceCurrentBlnc){
        string message;
        
        message =  WebServiceButtonHelper.refundAmount(sourceGauId,destinationdonor,destinationDonorBalance,refundingAmount,sourceDBln,sourceDonorbalanceCurrentBlnc);
        return message;
    }

    @AuraEnabled(cacheable=true)
    public static string updateGBT(string recordId,Integer transferedFund){
        List<GAU_Balance_Transfer__c> gbtList = new List<GAU_Balance_Transfer__c>();
        GAU_Balance_Transfer__c gbt = new GAU_Balance_Transfer__c();
        gbt.Id = recordId;
        gbt.isRefunded__c = TRUE;
        gbt.Refunded_Amount__c = transferedFund;
        gbtList.add(gbt);
        String message;
        Database.SaveResult[] srList = Database.update(gbtList, false);
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                message = 'Refund processed successfully';
            }else{
                for(Database.Error err : sr.getErrors()) {
                    message = err.getMessage();
                }
               
            }
        }
        return 'Success';
    }
}