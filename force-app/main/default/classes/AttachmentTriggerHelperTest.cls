@isTest
public class AttachmentTriggerHelperTest {
    
    public static testmethod void validateAttachment(){
        Contact con=Utility_Test.insertNewDonorId('Gourab','Hazra');
        con.Has_Donated_First_Time_Donor__c=false;
        insert con;
        
        contact conRec = New contact();
        conRec.LastName = 'abc';
        Id devRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Student').getRecordTypeId();
        conRec.RecordTypeId = devRecordTypeId;
        insert conRec;
        Application__c applin = Utility_Test.insertNewApplication('','');
        applin.student__c = conRec.Id;
        insert applin; 
        
        Blob b = Blob.valueOf('Test Data');
        Attachment attachment = new Attachment();
    	attachment.ParentId = con.Id;
    	attachment.Name = 'Primary logo';
    	attachment.Body = b;
    	
    	insert attachment;
		list<string> attNameList = New list<string>();
        attNameList.add('Mark Sheet for Secondary School Certificate (10th) Board Examination.pdf');
        attNameList.add('Income Certificate, Salary Certificate, Pension Certificate or Income Tax Return or Other document, as applicable.pdf');
        attNameList.add('Applicant\'s Pledge of Future Support to FFE.pdf');
        attNameList.add('Copy of Aadhaar.pdf');
        attNameList.add('Mark Sheet for Higher Secondary (12th/PUC/Intermediate) Examination.pdf');
        attNameList.add('Entrance Test Marks & Rank Certificate.pdf');
        attNameList.add('Counselling, Admission or Seat Allotment Letter.pdf');
        attNameList.add('Bonafide Student Certificate showing status of enrolment in college, course/branch, year of study.pdf');
        attNameList.add('Statement of Estimated Expenses for the current academic year Issued by your College.pdf');
        attNameList.add('Expense Receipts for Actual Expenses incurred for current academic year(College Fee/Hostel & Mess/Transport/Books/Uniform).pdf');
        attNameList.add('Copy of First Sheet of Bank Pass Book or Cancelled Cheque.pdf');

        
        list<Attachment> attList = New List<Attachment>();
        for(string attn:attNameList){
            Attachment attachment1 = new Attachment();
            attachment1.ParentId = applin.Id;
            attachment1.Name = attn;
            attachment1.Body = b;
            attList.add(attachment1);
        }
        insert attList;
         Attachment att = [select name,id from Attachment limit 1 FOR UPDATE];
        delete att;    
    }
}