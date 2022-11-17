@isTest public class WelcomeMentorEmail_Helper_Test {
    @isTest public static void sendWelcomeEmailNotificationToMentorTest(){
        Id mentorRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Mentor').getRecordTypeId();
         Contact con = new Contact();
        con.FirstName = 'Aakash';
        con.LastName = 'test';
        con.RecordTypeId = mentorRecordTypeId;
        con.Is_Mentor__c = true;
        insert con;
        
        Contact Contact = new Contact();
        Contact.FirstName = 'Aakash';
        Contact.LastName = 'Jain';
        Contact.RecordTypeId = mentorRecordTypeId;
        insert Contact;
        List<contact> mentorRec = [select name,id from Contact where id=:Contact.Id];
        mentorRec[0].is_Mentor__c = true;
        update mentorRec[0];
        
        String conId = [Select Id from Contact limit 1].id;
        Contact con1 = new Contact();
        con1.Id = conId;
        con1.Is_Mentor__c = false;
        update con1;
        
        Contact con2 = new Contact();
        con2.Id = conId;
        con2.Is_Mentor__c = true;
        update con2;
        
        Contact con3 = new Contact();
        con3.Id = conId;
        con3.is_Mentee__c = true;
        update con3;
        
        
    }
    
}