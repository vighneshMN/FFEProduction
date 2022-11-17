@isTest public class MentorMenteeAuthHelper_Test {
    @isTest public static void getContactId_Test(){
        contact mentee = new Contact();
        
        mentee.FirstName = 'Aakash';
        mentee.LastName = 'Jain';
        mentee.is_Mentee__c = true;
        mentee.MailingCountry = 'India';
        mentee.Language_Known__c = 'English';
        mentee.MailingState = 'Karnataka';
        mentee.Corporate__c = 'Capgemini';
        mentee.Gender__c = 'Male';
        mentee.Login_Hash_Code__c = '12343214';
        mentee.Last_Hash_Code_Updated__c = system.today();
        insert mentee;
        
        MentorMenteeAuthHelper.checkUserAuth('12343214');
        MentorMenteeAuthHelper.checkUserAuth('');
        MentorMenteeAuthHelper.checkUserAuth(null);
    }
   
}