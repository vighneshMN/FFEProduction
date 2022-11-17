@isTest
public class FFE_DonorAllocation_Test {
    @isTest static void FFE_DonorAllocation(){
        string donorRtypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_DONOR).getRecordTypeId(); 
        List<Contact> conList = new List<Contact>();
        Contact con = new Contact();
        con.MailingCountry = System.Label.Country_New_Zealand;
        con.MailingState = 'Auckland';
        con.LastName = 'Test';
        con.RecordTypeId = donorRtypeId;
        conList.add(con);
        insert conList;
        List<string> pgm ;
        List<string> states =  new List<string>();
        states.add(con.MailingState);
        
        Contact student = Utility_Test.insertSingleStudent('jay','b');   
        insert student;    
            
		Application__c app = new Application__c(Student__c=student.id,Amount_Requested__c=10000);
        insert app;
        
        Test.startTest();
        FFE_DN_Donor_AllocationClass.getCountryValues();
        FFE_DN_Donor_AllocationClass.getCourseValues();
        FFE_DN_Donor_AllocationClass.getGenderListValuesLwc();
        FFE_DN_Donor_AllocationClass.getSateValues('India');
        FFE_DN_Donor_AllocationClass.getStudentCourseYearPicklistValuesLwc();
        FFE_DN_Donor_AllocationClass.getBranchListValuesLwc();
        FFE_DN_Donor_AllocationClass.getInstCityOptions();
        FFE_DN_Donor_AllocationClass.getInstData();
        FFE_DN_Donor_AllocationClass.getClzRatingValuesLwc();
        FFE_DN_Donor_AllocationClass.getDonorDonationProgramValues();
        FFE_DN_Donor_AllocationClass.getStdPrio();
        FFE_DN_Donor_AllocationClass.getSchlrAmount();
        FFE_DN_Donor_AllocationClass.searchDonor(System.Label.Country_New_Zealand, states,pgm , true, '');
        FFE_DN_Donor_AllocationClass.searchDonor(System.Label.Country_New_Zealand, states,pgm , true, '12345');
        FFE_DN_Donor_AllocationClass.ApplicationDonorMappingWrapper wrap = 
            						new FFE_DN_Donor_AllocationClass.ApplicationDonorMappingWrapper();
        wrap.appId = app.Id;
        wrap.donorRemark = 'Donation';
        wrap.fundingAmount = 10000;
        FFE_DN_Donor_AllocationClass.ApplicationDonorMappingWrapper wrap1 = 
            						new FFE_DN_Donor_AllocationClass.ApplicationDonorMappingWrapper();
        wrap1.appId = app.Id;
        wrap1.donorRemark = 'Donation';
        wrap1.fundingAmount = null;
        List<FFE_DN_Donor_AllocationClass.ApplicationDonorMappingWrapper> wrapList = 
            		new List<FFE_DN_Donor_AllocationClass.ApplicationDonorMappingWrapper>();
        wrapList.add(wrap);
        wrapList.add(wrap1);
        FFE_DN_Donor_AllocationClass.createDonorStudentMapping(student.id, wrapList);
        Test.stopTest();
    }

}