@isTest public class MentorAssociationTriggerHelper_Test {
    @isTest public static void getInstanceTest(){
        MentorAssociationTriggerHelper.getInstance();
    
    }
    @isTest public static void updateHourTest(){
         
        Program__c pr = new Program__c();
        pr.Name = 'Communication Skills';
        pr.Skills__c = 'Communication Skills';
        pr.Hours_Required__c = 15;
        insert pr;
        
        Program__c pr1 = new Program__c();
        pr1.Name = 'Problem Solving and Decision Making';
        pr1.Skills__c = 'Problem Solving and Decision Making';
        pr1.Hours_Required__c = 15;
        insert pr1;   
        List<Contact> conList = new List<Contact>();
        
        Contact conMentor = new Contact();
        conMentor.FirstName =  'Ajeet';
        conMentor.LastName =  'Kumar';
        Id devRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Mentor').getRecordTypeId();
        conMentor.RecordTypeId =  devRecordTypeId;
        conMentor.is_Mentor__c = True;
        conList.add(conMentor) ;
        
         Contact conMentor2 = new Contact();
        conMentor2.FirstName =  'Ajeet';
        conMentor2.LastName =  'Kumar2';
        conMentor2.RecordTypeId =  devRecordTypeId;
        conMentor2.is_Mentor__c = True;
        conMentor2.Corporate__c = 'ExxonMobil';
        conList.add(conMentor2) ;
        
        Contact conMentee = new Contact();
        conMentee.FirstName =  'Aakash';
        conMentee.LastName =  'Jain';
        conMentee.is_Mentee__c = true;
        conList.add(conMentee);
        
        insert conList;
        
        Mentor_Mentee_Association__c mma = new Mentor_Mentee_Association__c();
        mma.mentee_del__c = conMentee.Id;
        mma.Mentor__c = conMentor.Id;
        mma.Status__c = 'Approved';
        mma.Modules__c = 'Communication Skills';
        insert mma;
        
        
         Mentor_Mentee_Association__c mma1 = new Mentor_Mentee_Association__c();
        mma1.mentee_del__c = conMentee.Id;
        mma1.Status__c = 'Approved';
        mma1.Modules__c = 'Communication Skills';
        insert mma1;
        
         Mentor_Mentee_Association__c mma2 = new Mentor_Mentee_Association__c();
        mma2.mentee_del__c = conMentee.Id;
        mma2.Status__c = 'Approved';
        insert mma2;
        
        Mentor_Mentee_Association__c mmaToUpdate =[Select name,id,Modules__c from Mentor_Mentee_Association__c where Modules__c != null limit 1];
        system.debug('mmaToUpdate'+ mmaToUpdate);
        mmaToUpdate.Modules__c = 'Problem Solving and Decision Making;Communication Skills';
        mmaToUpdate.Mentor__c = conMentor2.Id;
        update mmaToUpdate;
        
        List<Mentor_Mentee_Association__c> newMmaList = new List<Mentor_Mentee_Association__c>();
        newMmaList.add(mma);
        
    }
    
}