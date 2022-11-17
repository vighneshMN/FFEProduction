public with sharing class FFE_DN_Donor_AllocationClass {
    @AuraEnabled(cacheable=true)
    public static List<CountryMapping__mdt> getCountryValues(){
        
        return Utility.getCountryList();
    }
    @AuraEnabled()
    public static List<State_Master__mdt> getSateValues(string currentCountry){
        System.debug('st>>'+Utility.getStates(currentCountry));
        return Utility.getStates(currentCountry);
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getStudentCourseYearPicklistValuesLwc(){
        try {
            return Utility.getPicklistValues(Constants.CONTACT_SOBJECT,Constants.STUDENT_COURSE);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getGenderListValuesLwc(){
        try {
            List<String> genderList = new List<String>();
            genderList = Utility.getPicklistValues(Constants.CONTACT_SOBJECT,Constants.SCHOLAR_GENDER);
            System.debug('genderList>>'+genderList);
            return genderList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getBranchListValuesLwc(){
        try {
            return Utility.getPicklistValues(Constants.CONTACT_SOBJECT,Constants.SCHOLAR_BRANCH_FIELD);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getInstData(){
        try {
            return Utility.getPicklistValues(Constants.CONTACT_SOBJECT,Constants.SCHOLAR_BRANCH_FIELD);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getInstCityOptions(){
        try {
            return Utility.getPicklistValues(Constants.CONTACT_SOBJECT,Constants.SCHOLAR_BRANCH_FIELD);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getCourseValues(){
        try {
            return Utility.getPicklistValues(Constants.CONTACT_SOBJECT,Constants.SCHOLAR_BRANCH_FIELD);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getSchlrAmount(){
        try {
            return Utility.getPicklistValues(Constants.CONTACT_SOBJECT,Constants.SCHOLAR_BRANCH_FIELD);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getStdPrio(){
        try {
            return Utility.getPicklistValues(Constants.CONTACT_SOBJECT,Constants.SCHOLAR_BRANCH_FIELD);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getClzRatingValuesLwc(){
        try {
            return Utility.getPicklistValues(Constants.COLLEGEMASTER_SOBJECT,Constants.COLLEGEMASTER_STUDENTCLZRATING);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled()
    public static List<Donation_Program__c> getDonorDonationProgramValues(){
        String currencyType;
        return [Select id,Name,only_1_frequency__c,Description__c,Program__c,Display_for_Scholar__c
        from Donation_Program__c 
        order by Portal_display_Order__c asc]; 
        
    }

    @AuraEnabled()
    public static List<Contact> searchDonor(String countryName,list<String> stateName, 
                                            list<String> progName, Boolean isDonorBal, String donorFfuiid ){
        String sObjquery= '';
        string donorRtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_DONOR).getRecordTypeId(); 
        List<Contact> donorList = new List<Contact> ();
        string country = '';
        if(countryName == System.Label.Country_New_Zealand){
            country     = 'New Zealand'; //   System.Label.Country_Withoutspace_New_Zealand
        }else if(countryName == System.Label.Country_Bosnia_and_Herzegovina){
            country     = 'Bosnia and Herzegovina';   // System.Label.Country_Withoutspace_Bosnia_and_Herzegovina
        }else if(countryName == System.Label.Country_Hong_Kong){
            country     = 'Hong Kong';   // System.Label.Country_Withoutspace_Hong_Kong 
        }else{
            country     = countryName;    
        }
        System.debug('value>>'+donorRtypeId +'<>'+ stateName +'<>'+ country);
        if(donorFfuiid == '' && stateName.size() > 0){
            if(isDonorBal){
                sObjquery   = 'Select id,FFE_ID__c,Name,Email,Phone,MobilePhone,Current_Balance__c,Blocked_Funds__c,DN_Special_Request_Comments__c,'+
                    'MailingCity,MailingState from Contact where RecordTypeId =: donorRtypeId AND MailingState IN :stateName '+
                    'AND MailingCountry=:country';
                
            }else{
                sObjquery = 'Select id,FFE_ID__c,Name,Email,Phone,MobilePhone,Current_Balance__c,Blocked_Funds__c,DN_Special_Request_Comments__c,'+
                    'MailingCity,MailingState from Contact where RecordTypeId =: donorRtypeId AND MailingState IN :stateName AND MailingCountry=:country';                               
                
            }
            sObjquery = sObjquery + ' Order By Name';
        }else if(donorFfuiid != ''){
            String donorName = '%'+donorFfuiid+'%';
            sObjquery   = 'Select id,FFE_ID__c,Name,Email,Phone,MobilePhone,Current_Balance__c,Blocked_Funds__c,DN_Special_Request_Comments__c,'+
            'MailingCity,MailingState from Contact where RecordTypeId =: donorRtypeId and Name LIKE: donorName';
            sObjquery = sObjquery + ' Order By Name';
        }
        System.debug('sObjquery>>'+sObjquery);
        donorList = Database.query(sObjquery);
        System.debug('donorList>>'+donorList);
        return donorList;
    }

    @AuraEnabled()
    public static String createDonorStudentMapping(String donorId, List<ApplicationDonorMappingWrapper> appDonorMappingWrp){
        System.debug('appDonorMappingWrp>>'+appDonorMappingWrp);
        Set<String> lstApplicationIds = new Set<String>();
        Map<String,Integer> fundingAmtMap = new Map<String,Integer>();
        Map<String,String> donorRemarksMap = new Map<String,String>();
        
        for(ApplicationDonorMappingWrapper adm : appDonorMappingWrp){
            lstApplicationIds.add(adm.appId);
            if(adm.fundingAmount != null){
                fundingAmtMap.put(adm.appId,Integer.valueOf(adm.fundingAmount));
            }else{
                fundingAmtMap.put(adm.appId,0);    
            }    
            donorRemarksMap.put(adm.appId,adm.donorRemark);
        }
        SavePoint sp = Database.setSavepoint();
        try{
            List<Donor_Application_Mapping__c> lstDonorStudentsApplication =new List<Donor_Application_Mapping__c>();
            List<Application__c> ApplicationInfo = [Select id,IsMapped__c,Student__c,Donor_Remarks__c,Student__r.Donor_Name__c,Amount_Funded__c from Application__c where id in:lstApplicationIds];
            Donor_Application_Mapping__c  donorStudentMapping ;
            List<Application__c> updateAppList = new List<Application__c>();
            if(!lstApplicationIds.isEmpty()){
                for(Application__c str:ApplicationInfo){
                    lstDonorStudentsApplication.add(new Donor_Application_Mapping__c(Application__c=str.id,Donor__c=donorId,Student__c = str.Student__c,Funding_amount__c=fundingAmtMap.get(str.Id),Donor_Remark__c=donorRemarksMap.get(str.Id)));
                    str.IsMapped__c                 = true;                                    
                    updateAppList.add(str);
                }
            }
            system.debug('updateAppList:::::::'+updateAppList);
            system.debug('lstDonorStudentsApplication:::::::'+lstDonorStudentsApplication);
            
            // Insert new Donor-Application Mapping
            if(!lstDonorStudentsApplication.isEmpty()) insert lstDonorStudentsApplication;
            update updateAppList;
            return Constants.MAPPING_SUCCESS_MSG;
        }catch(Exception e){
            Database.rollback(sp);
            HandleBusinessException.captureError('DN_DonorAllocation_Helper', 'createDonorStudentMapping', e);            
            return Constants.ERROR_MSG;
        }
        
        
    }

    public class ApplicationDonorMappingWrapper{
        @AuraEnabled
        public  String donorRemark {get;set;}
        @AuraEnabled
        public  Integer fundingAmount {get;set;}
        @AuraEnabled
        public Id appId {get;set;}
    }    
}