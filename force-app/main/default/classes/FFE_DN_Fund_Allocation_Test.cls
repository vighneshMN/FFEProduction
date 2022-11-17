@isTest
public class FFE_DN_Fund_Allocation_Test {
    public static testmethod void testMethod1(){
        
        test.startTest();
        User auser = Utility_Test.createUser('ZXYSpoo099@test.com');
        System.runAs(auser){
            
            Contact donor  = Utility_Test.insertNewDonorId('ABC','XYZ');
            insert donor;
            
            Contact studentCon  = Utility_Test.insertSingleStudent('WER','BRO');
            insert studentCon;
            
            ID studentRecordType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId();
            ID studentRecType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_FACILITAtOR).getRecordTypeId();
            Contact student = Utility_Test.insertNewStudentRec('ABC','ZYX','8898898899','studenttest@gmail.com','7829488975','studenttest@gmail.com','studenttestfb@gmail.com',70,90,'cet','2016');
            student.Internal_Status__c =Constants.AWAITING_FUND_STATUS;
            student.RecordTypeId = studentRecordType;
            insert student;
            Contact student1 = Utility_Test.insertNewStudentRec('ABC','ZYX','8898898899','studenttest@gmail.com','7829488975','studenttest@gmail.com','studenttestfb@gmail.com',70,90,'cet','2016');
            student1.Internal_Status__c =Constants.ALL_UNMAPPED_STUDENT;
            student1.RecordTypeId = studentRecType;
            insert student1;
            List<contact> conList = new List<Contact>();
            conList.add(student);
            conList.add(student1);
            
            Donation_Program__c dp = Utility_Test.createDonationProgram('Engineering','Engineering');
            insert dp;
            npsp__General_Accounting_Unit__c ga = Utility_Test.createGAU('ASP - Engineering',dp.Id);
            insert ga;
            
            Donor_Balance__c donorbalance = Utility_Test.createDonorBalance(donor.id,ga.id);
            insert donorbalance;
            
            String addAppRecordType     = Schema.SObjectType.Application__c.getRecordTypeInfosByName().get(Constants.ADDITIONAL_APPLICATION).getRecordTypeId();
            String addAppRecType     = Schema.SObjectType.Application__c.getRecordTypeInfosByName().get(Constants.ADDITIONAL_APPLICATION).getRecordTypeId();
            Application__c app = Utility_Test.insertNewApplication('Selected', 'Submitted');
            app.RecordTypeId = addAppRecordType;
            app.Student__c=studentCon.id;
            insert app;
            Application__c app1 = Utility_Test.insertNewApplication('Selected', 'Submitted');
            app1.RecordTypeId = addAppRecType;
            app1.Student__c=student.id;
            insert app1;
            
            List <string> rType = new List<string>();
            rType.add(addAppRecordType);
            rType.add(addAppRecType);
            
            FFE_DN_Fund_AllocationClass.FundDisburseWrapperLwc fw = new FFE_DN_Fund_AllocationClass.FundDisburseWrapperLwc();
            fw.student             = studentCon;
            fw.appln               = app;
            fw.amtFunded           = new List<FFE_DN_Fund_AllocationClass.fundedAmtByGAU>();
            FFE_DN_Fund_AllocationClass.fundedAmtByGAU check = new FFE_DN_Fund_AllocationClass.fundedAmtByGAU();
            check.donorbalance = donorbalance;
            check.extraFunds = '10000';
            fw.amtFunded.add(check);
           // fw.donorBalanceIds     = dnList;
            List<string> amt = new List<string>();
            amt.add('100');
            System.debug(fw.amtFunded[0].donorbalance);
            Donor_Application_Mapping__c dam = new Donor_Application_Mapping__c();
            dam.Student__c = studentCon.id;
            dam.Donor_Remark__c ='testing';
            dam.Funding_amount__c = 20;
            dam.Application__c =app.id;
            dam.Donor__c = donor.id;
            insert dam;
            
            FFE_DN_Fund_AllocationClass.getApplicationType();
            FFE_DN_Fund_AllocationClass.getGauOptions(); 
            FFE_DN_Fund_AllocationClass.doFundDisburment(studentCon.id, app.id, amt , '1000');
            FFE_DN_Fund_AllocationClass.getMultiDonor(app.id);
            FFE_DN_Fund_AllocationClass.getAllAwaitingStudents(rType);
            FFE_DN_Fund_AllocationClass.getAllAwaitingStudents(new List<id>());
          	FFE_DN_Fund_AllocationClass.getAllStudents_multiDonor(student1.Internal_Status__c, rType);
            FFE_DN_Fund_AllocationClass.getAdditionalExpnsAppln(app1.RecordTypeId, studentRecordType);
            FFE_DN_Fund_AllocationClass.getAllAwaitingStudents(rType);
            FFE_DN_Fund_AllocationClass.getStudentswithApplication(rType, studentRecType);
            FFE_DN_Fund_AllocationClass.getAllMappedStudents(rType);
            FFE_DN_Fund_AllocationClass.getAllMappedStudents(new List<id>());
            FFE_DN_Fund_AllocationClass.getAllUnMappedStudents(rType);
            FFE_DN_Fund_AllocationClass.getAwatingingApplications(rType,conList);
            FFE_DN_Fund_AllocationClass.getStudentswithApplication(rType, studentRecordType);
            FFE_DN_Fund_AllocationClass.getDonorStudentMapping(app.id);
            FFE_DN_Fund_AllocationClass.getGAUWiseDonorBalance (ga.Id, 'Individual');
            FFE_DN_Fund_AllocationClass.disburseAllFund(fw);
        }
    }

}