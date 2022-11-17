@isTest
public class StudentCgpaForm_Controller_Test {

        static testmethod void getStudentCgpaDetails(){
            contact student = new contact();
            student.FirstName = 'Test';
            student.LastName = 'Student';
            student.Email = 'student@gmail.com';
            student.Current_year__c = '2nd Year';
            student.Course__c = 'BE/B.Tech';
            student.Login_Hash_Code__c = '12345566778';
            insert student;
            
            Application__c appLication = New Application__c();
            appLication.Student__c = student.Id;
            insert appLication;
            
            contact donor = New contact();
            donor.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Donor').getRecordTypeId();
            donor.FirstName = 'Test';
            donor.LastName = 'Donor';
            donor.Email = 'donor@gmail.com';
            insert donor;
            
            Donor_Application_Mapping__c donorMapping = New Donor_Application_Mapping__c();
            donorMapping.Application__c = appLication.Id;
            donorMapping.Donor__c = donor.Id;
            donorMapping.Student__c = student.Id;
            insert donorMapping;
            
            
            list<string> fildApiNameList = New list<string>{'Semester1__c','Semester2__c','Semester3__c','Semester4__c','Semester5__c','Semester6__c','Semester7__c','Semester8__c','Semester9__c','Semester10__c','MBBS_Year_1__c','MBBS_Year_2__c','MBBS_Year_3_Part_1__c','MBBS_Year_3_Part_2__c'};
                list<StudentCgpaForm_Controller.CgpaFormData_wrap> cgpaFormDataList = new list<StudentCgpaForm_Controller.CgpaFormData_wrap>();
                for(string fildApiName:fildApiNameList){
                    StudentCgpaForm_Controller.CgpaFormData_wrap cgpaFormData = new StudentCgpaForm_Controller.CgpaFormData_wrap();
                    cgpaFormData.label = fildApiName;
                    cgpaFormData.apiName = fildApiName;
                    cgpaFormData.finalAnswer = '20';  
                    cgpaFormDataList.add(cgpaFormData);
                }
           
            StudentCgpaForm_Controller.StudentCgpaForm_wrap StudentCgpaForm = new StudentCgpaForm_Controller.StudentCgpaForm_wrap();
            StudentCgpaForm.conRec = student;
            StudentCgpaForm.dataWrapper = cgpaFormDataList;
            StudentCgpaForm_Controller.getStudentDetails(student.Login_Hash_Code__c);
            StudentCgpaForm_Controller.submitCgpaData(cgpaFormDataList, student.Id);
            StudentCgpaForm_Controller.sendCgpaFormDonor(donor.Id);
            StudentCgpaForm_Controller.sendCgpaFormApplication(appLication.Id);
        }
}