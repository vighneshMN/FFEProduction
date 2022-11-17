@isTest
public class DonorDetail_ControllerTest {
    public Static testmethod void TestForDonarDetail(){
                Id studentRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Student').getRecordTypeId();
        Contact con = new Contact();
        con.LastName = 'Vignesh Naik';
        con.RecordTypeId = studentRecordTypeId;
        insert con;
        system.debug('con---'+con.Id);
        
        Id devRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Donor').getRecordTypeId();
        Contact con1 = new Contact();
        con1.LastName = 'Vignesh Naik 1';
        con1.RecordTypeId = devRecordTypeId;
        insert con1;
        system.debug('con1---'+con1.Id);

        String donorConID = con1.Id;
        Application__c app1 = new Application__c();
        app1.Student__c = con.Id;
        insert app1;
        String StudentId = app1.Student__c;
  
        Donor_Application_Mapping__c don = new Donor_Application_Mapping__c();
        don.Student__c = con.Id;
        don.Application__c = app1.Id;
        don.Donor__c = con1.Id;
        insert don; 
 
        test.startTest();
       
            DonorDetails_Controller.getDonorDetais(app1.Id);     
       // DonorDetails_Controller.getDonorDetais(con.Id); 
      
        test.stopTest();
        
        
    }
    
}