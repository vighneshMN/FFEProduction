@isTest public class SendSMSNotification_Test {
    @TestSetup public static void allTestData(){
        Contact conMentee = new Contact();
        Contact conMentor = new Contact();
        Mentor_Mentee_Association__c mma = new Mentor_Mentee_Association__c();
        
        conMentee.FirstName = 'Aakash';
        conMentee.LastName = 'Jain';
        conMentee.is_Mentee__c = true;
        conMentee.Email = 'aakash.jain@utilitarianlab.com';
        conMentee.Phone = '7042458620';
        insert conMentee;
        conMentor.FirstName = 'Ajeet';
        conMentor.LastName = 'Kumar';
        conMentor.Is_Mentor__c = True;
        conMentor.Email = 'aakash.jain@utilitarianlab.com';
        conMentee.Phone = '7042458620';
        insert conMentor;
        
        mma.Mentor__c = conMentor.Id;
        mma.mentee_del__c = conMentee.Id;
        mma.Modules__c = 'Communication Skills';
        mma.Status__c = 'Requested';
        insert mma;
        
        Message_Template__c msgTempMentee = new Message_Template__c();
        msgTempMentee.Applicable_Status__c = 'Approved';
        msgTempMentee.Recipient_Type__c = 'Mentee';
        msgTempMentee.SMS_Body__c = 'Dear {!Mentee.Salutation} {!Mentee.Name},It is pleasure to introduce {!Mentor.Salutation}  {!Mentor.Name} as your mentor for the FFE-Mentorship Program. Please connect with your Mentor over a call and complete the Introduction session at the earliest.Hope you both will have a relishing & meaningful experience of one-one mentoring program.';
        insert msgTempMentee;
        
        Message_Template__c msgTempMentor = new Message_Template__c();
        msgTempMentor.Applicable_Status__c = 'Approved';
        msgTempMentor.Recipient_Type__c = 'Mentor';
        msgTempMentor.SMS_Body__c = 'Dear {!Mentor.Salutation} {!Mentor.Name},It is pleasure to introduce {!Mentee.Salutation} {!Mentee.Name} as your mentee for the FFE-Mentorship Program. We kindly request you to connect with your mentee over a call and complete the Introduction session at the earliest.Hope you both will have a relishing & meaningful experience of one-one mentoring program.Wish you all the best.FFE Team';
        insert msgTempMentor;
        
        
    }
    @isTest public static void sendSMSwhenStatusApproved(){
        test.startTest();
        String mmaId = [Select id from Mentor_Mentee_Association__c].Id;
        
        Mentor_Mentee_Association__c mmaRec = new Mentor_Mentee_Association__c();
        mmaRec.Id = mmaId;
        mmaRec.Status__c = 'Approved';
        update mmaRec;
        test.stopTest();
    }
    @isTest public static void sendSMSwhenStatusCompleted(){
        String mmaId = [Select id from Mentor_Mentee_Association__c].Id;
        
        Mentor_Mentee_Association__c mmaRec = new Mentor_Mentee_Association__c();
        mmaRec.Id = mmaId;
        mmaRec.Status__c = 'Completed';
        update mmaRec;
        
    }
}