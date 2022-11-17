@istest
public class DocumentUploadLwcTest {
    
    @istest
    public static void getDocRecordClsWrapperTest(){

        Contact donor   = Utility_Test.insertNewContact('dummy', 'donor', '12121212', 'sample@donor.com', '12321232', 'sample@donor.com', 'sample@donor.com'); 
        insert donor; 
            
        donor.Receipts_for_Actual_Expenses__c = True;
        donor.Applicant_s_Pledge_of_Future_Support__c = True;
        donor.Marks_Sheet_for_10th_Standard__c = True;
        donor.Income_Salary_Certificate__c = True;
        donor.Admission_or_Seat_Allotment_Letter__c = True;
        donor.Bonafide_Student_Certificate__c = True;
        donor.PUC_12th_Marks_Sheet__c = True;
        donor.Parents_or_Guardians_Declaration__c = True;
            
        donor.Even_Semester_Mark_Sheet_of_the_previous__c = True;
        donor.Odd_Semester_Mark_Sheet_of_the_previous__c = True;
        donor.Oath_Pledge_and_Declaration_Form_signed__c = True;
            
        update donor;
        Test.startTest();
            DocumentUploadLwc.getDocRecordClsWrapper(donor.id);
        Test.stopTest();

    }

    @istest
    public static void submitTest(){
        Contact donor   = Utility_Test.insertNewContact('dummy', 'donor', '12121212', 'sample@donor.com', '12321232', 'sample@donor.com', 'sample@donor.com'); 
        insert donor; 

        List<DocumentUploadLwc.DocRecordLwc> docRecordList = new List<DocumentUploadLwc.DocRecordLwc>();

        DocumentUploadLwc.DocRecordLwc rec = new DocumentUploadLwc.DocRecordLwc();
        rec.docObj = 'Receipts for Actual Expenses incurred for current year(College Fee/Hostel & Mess/Transport/Books/Uniform';
        rec.isSelected = true;
        docRecordList.add(rec);

        DocumentUploadLwc.DocRecordLwc rec2 = new DocumentUploadLwc.DocRecordLwc();
        rec2.docObj = 'Applicants Pledge of Future Support to FFE';
        rec2.isSelected = true;
        docRecordList.add(rec2);

        DocumentUploadLwc.DocRecordLwc rec3 = new DocumentUploadLwc.DocRecordLwc();
        rec3.docObj = 'Mark Sheet for Secondary School Certificate (10th) Board Examination';
        rec3.isSelected = true;
        docRecordList.add(rec3);

        DocumentUploadLwc.DocRecordLwc rec4 = new DocumentUploadLwc.DocRecordLwc();
        rec4.docObj = 'Income Certificate, Salary Certificate, Pension Certificate or Income Tax Return or Other document, as applicable';
        rec4.isSelected = true;
        docRecordList.add(rec4);

        DocumentUploadLwc.DocRecordLwc rec5 = new DocumentUploadLwc.DocRecordLwc();
        rec5.docObj = 'Statement of Estimated Expenses for the current academic year Issued by your College';
        rec5.isSelected = true;
        docRecordList.add(rec5);

        DocumentUploadLwc.DocRecordLwc rec6 = new DocumentUploadLwc.DocRecordLwc();
        rec6.docObj = 'Copy of First Sheet of Bank Pass Book or Cancelled Cheque';
        rec6.isSelected = true;
        docRecordList.add(rec6);

        DocumentUploadLwc.DocRecordLwc rec7 = new DocumentUploadLwc.DocRecordLwc();
        rec7.docObj = 'Bonafide Student Certificate showing status of enrolment in college, course/branch, year of study';
        rec7.isSelected = true;
        docRecordList.add(rec7);

        DocumentUploadLwc.DocRecordLwc rec8 = new DocumentUploadLwc.DocRecordLwc();
        rec8.docObj = 'Parent or Guardians Declaration';
        rec8.isSelected = true;
        docRecordList.add(rec8);

        DocumentUploadLwc.DocRecordLwc rec9 = new DocumentUploadLwc.DocRecordLwc();
        rec9.docObj = 'Entrance Test Marks & Rank Certificate';
        rec9.isSelected = true;
        docRecordList.add(rec9);

        DocumentUploadLwc.DocRecordLwc rec10 = new DocumentUploadLwc.DocRecordLwc();
        rec10.docObj = 'Even Semester Mark Sheet of the previous academic year';
        rec10.isSelected = true;
        docRecordList.add(rec10);

        DocumentUploadLwc.DocRecordLwc rec11 = new DocumentUploadLwc.DocRecordLwc();
        rec11.docObj = 'Odd Semester Mark Sheet of the previous year';
        rec11.isSelected = true;
        docRecordList.add(rec11);

        Test.startTest();
            DocumentUploadLwc.submit(docRecordList,donor.id);
        Test.stopTest();

        Contact conrec = [Select Receipts_for_Actual_Expenses__c from contact where id = :donor.id];
        System.assertEquals(conrec.Receipts_for_Actual_Expenses__c , rec.isSelected); 
    }
}