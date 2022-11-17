@isTest
public class SendDeclarationForm_Test {

    
     @isTest static void testDeclarationFormBatch(){
       
             Contact student1 = Utility_Test.insertNewStudentRec('ABC','ZYX','8898898899','studenttest@gmail.com','7829488975','studenttest@gmail.com','studenttestfb@gmail.com',70,90,'cet','2016');
            insert student1;
		Application__c app1 = Utility_Test.insertNewApplication('Selected','Submitted');
        app1.Student__c = student1.id;
        app1.createddate = date.newInstance(2021, 02, 18);
        insert app1; 
        
        
        Contact student2 = Utility_Test.insertNewStudentRec('DEF','Z','8898898899','studenttest@gmail.com','7829488975','studenttest@gmail.com','studenttestfb@gmail.com',70,90,'cet','2016');
            insert student2;
		Application__c app2 = Utility_Test.insertNewApplication('Selected','Submitted');
        app2.Student__c = student2.id;
        app2.createddate = date.newInstance(2021, 02, 18);
        insert app2; 
        
        contact donorRec = Utility_Test.insertNewDonorId('dummy','donor');
		insert donorRec;
         
         Donor_Application_Mapping__c dMapping = new Donor_Application_Mapping__c();
         dMapping.Donor__c = donorRec.id;
         dMapping.Application__c = app1.id;
         dMapping.Student__c = student2.id;
         insert dMapping;
         
        set<id> setofAccId = new set<id>();
         setofAccId.add(app1.Id);
         setofAccId.add(app2.Id);
         system.debug('setofAccId===='+setofAccId);
        Test.startTest();
        SendDeclarationFormBatch c = new SendDeclarationFormBatch(setofAccId,True);
        Database.executeBatch(c);
         SendDeclarationFormBatch.initiateDeclarationBatchLWC(donorRec.id,'2021-22');
         SendDeclarationFormBatch.getFiscalYearsLWC();
        Test.stopTest();
        }
}