/*
 * @purpose	: This wrapper class is used on ffeStudentAllocationPopup component 
 * 			  to collect input parameters
 */
public class FFE_DonorFilterWrapper {
    
    @AuraEnabled
    public string countryName{get; set;}

    @AuraEnabled
    public List<String> locations{get; set;}

    @AuraEnabled
    public List<String> gaus{get; set;}

    //public boolean isDonorBalance; to be checked    
	//public String ffeUID; to be checked

}