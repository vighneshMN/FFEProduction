/*
* @Purpose      :  Controller for Generate 80G Form Button Quick Action.
* @Author       :  Sarang Kulkarni
* @CreatedDate  :  15-07-2021
*/
public class ffePaymentGenerate80GForm_CTRL {
    
    @AuraEnabled(cacheable=true)
    public static String getDonationsLwc(String paymentId){
        system.debug('paymentId : ' + paymentId);
        List<Opportunity> donationsList = new List<Opportunity>();
        donationsList = [SELECT id,StageName from Opportunity where Payment_Order__c =: paymentId];
        if(donationsList.isEmpty()){
            return 'There is no Donation related to this Payment.';
        }else{
            Boolean isPostedOpportunityAvailable = false;
            for(Opportunity Opp : donationsList){
                if(Opp.StageName == 'Posted'){
                    isPostedOpportunityAvailable = true;
                    break;
                }
            }
            if(isPostedOpportunityAvailable){
                return 'Donation is available.';
            }else{
                return 'Please make sure all donation for this order is in "Posted" stage.';
            }
        } 
    }
    
    @AuraEnabled
    public static List<string> getBase64encoded(String paymentId){
        List<String> fileBase64encodedLst = new list<String>();
        try {
            PageReference pdfPage = Page.TaxExemptionForm;
            pdfPage.getParameters().put('id',paymentId);
            Blob pdfBlob ;
            if(Test.isRunningTest()){
                pdfBlob = Blob.valueOf('Unit Test');
            }else{
                pdfBlob = pdfPage.getContent();
            }
            String base64Pdf = EncodingUtil.base64Encode(pdfBlob);
            fileBase64encodedLst.add(base64Pdf);
        	return fileBase64encodedLst;
        } catch (Exception e) {
            System.debug('Exception ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }

        
    }
}