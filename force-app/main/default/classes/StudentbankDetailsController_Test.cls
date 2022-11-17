@istest
public class StudentbankDetailsController_Test {

    public static testmethod void studentBankVerification(){
        Contact student = Utility_Test.insertNewStudentRec('ABC','ZYX','8898898899','studenttest@gmail.com','7829488975','studenttest@gmail.com','studenttestfb@gmail.com',70,90,'cet','2016');
        insert student;
        Attachment attach=new Attachment();    
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=student.id;
        insert attach; 
        StudentbankDetails_Controller sbCtlr = New StudentbankDetails_Controller();
        StudentbankDetails_Controller.updateStudentDetails(student);
        StudentbankDetails_Controller.getAttachment(attach.Id);
        StudentbankDetails_Controller.getAttachment('');
        StudentbankDetails_Controller.doUploadAttachment(student.Id, 'attachmentName', 'attachmentName', '');
        StudentbankDetails_Controller.doUploadAttachment('', 'attachmentName', 'attachmentName', '');
        StudentbankDetails_Controller.ifscCodeResponse(student.id,'CNRB0000469');
        StudentbankDetails_Controller.sendBankDetailEmail(student.id);
        StudentbankDetails_Controller.sendEmail(student.id,'');
    }
}