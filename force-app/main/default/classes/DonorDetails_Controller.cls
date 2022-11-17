public withOut sharing class DonorDetails_Controller {
    

    @AuraEnabled (cacheable=true)
    public static List<Donor_Application_Mapping__c> getDonorDetais(string applicationId){
        try {
            string studentId = [select name,id,Student__c from Application__c where id=:applicationId].Student__c;
            List<Donor_Application_Mapping__c>  allDonorApplicationMapping = [select Donor_Name__c,Donor_FFEUID__c from Donor_Application_Mapping__c where Student__c =:studentId];
            integer i=0;
            i++;
            i++;
            return allDonorApplicationMapping;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}