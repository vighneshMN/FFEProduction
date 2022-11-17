@isTest
public class OptingForMentorship_Controller_Test {
    
    @isTest static void optingForMentorshipTest() {
        contact mentor = new contact();
        mentor.FirstName = 'Aakash';
        mentor.LastName = 'Jain';
        mentor.Spoken_Languages__c = 'English';
        mentor.Is_Mentor__c = true;
        
        Test.startTest();
        insert mentor;
        OptingForMentorship_Controller.optingForMentorship(mentor.Id);
        Test.stopTest();
    }
}