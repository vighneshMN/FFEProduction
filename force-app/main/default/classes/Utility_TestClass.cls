@isTest public class Utility_TestClass {
    @testSetup public static void allTestData(){
        Account acc = new Account();
        acc.Name = 'Util';
        insert acc;
        Contact con = new Contact();
        con.FirstName = 'Aakash';
        con.LastName = 'Jain';
        con.Email = 'aakashh2510jain@gmail.com';
        con.AccountId = acc.Id;
        insert con;
        
        Blob b = Blob.valueOf('Test Data');
        
        Attachment attachment = new Attachment();
        attachment.ParentId = con.Id;
        attachment.Name = 'Test Attachment for Parent';
        attachment.Body = b;
        insert(attachment);
        
    }
    @isTest public static void getPicklistValues_Test(){
        Utility.getPicklistValues('Contact','Salutation');
        Utility.generateRandomString();
    }
    @isTest public static void temporaryDonorLoginURL_Test(){
        String ffeId = [Select FFE_ID__c From Contact ].FFE_ID__c;
        
        Utility.temporaryDonorLoginURL(ffeId, 'aakashh2510jain@gmail.com', 'Donor');
        Utility.temporaryDonorLoginURL(ffeId, 'aakashh2510jain@gmail.com', 'Mentee');
        Utility.temporaryDonorLoginURL(ffeId, ' ', 'Donor');
    }
    @isTest public static void sendEmailWithTemplateThroughCustomButton_Test(){
        String targetRecordId = [Select Id From Contact ].Id;
        String WhatId = [Select Id from Account].Id;
        List<OrgWideEmailAddress> owa =[select id,displayName,Address from OrgWideEmailAddress where displayName=:System.label.Foundation_For_Excellence Limit 1];
        
        
        EmailTemplate validEmailTemplate = new EmailTemplate();
        validEmailTemplate.isActive = true;
        validEmailTemplate.Name = 'name';
        validEmailTemplate.DeveloperName = 'unique_name';
        validEmailTemplate.TemplateType = 'text';
        validEmailTemplate.FolderId = UserInfo.getUserId();
        insert validEmailTemplate;
        
        String[] emailAddress=new String[]{'aakash.jain@utiilitarianlab.com','Shubham.kumar@utilitarianlab.com'}; 
            Attachment att = [Select Id,ParentId,Name,Body from Attachment limit 1];            
        
        Utility.sendEmailWithTemplateThroughCustomButton(targetRecordId, validEmailTemplate.Id, WhatId);
        Utility.sendEmailWithTemplateBulk(targetRecordId, validEmailTemplate.Id);
        Utility.sendEmailWithTemplate(targetRecordId, validEmailTemplate.Id);
        Utility.sendMailWithTemplateforBusinessAccountUtilization(validEmailTemplate.Id, targetRecordId, WhatID, emailAddress, owa);
        Utility.sendMailWithTemplate(validEmailTemplate.Id, targetRecordId, WhatID, emailAddress);
        Utility.uploadAttachment('Test Data', att.Name, att.ParentId, att.Id);
        Utility.uploadAttachment('Test Data', att.Name, att.ParentId, null);
        Utility.getStates('India');
        Utility.getStates(null);
        Utility.getExamBoards();
    }
    
    @isTest public static void sendMail_Test(){
        List<string> emailList = new List<string> {'akash.jain@utilitarianlab.com','shubham.kuma@utilitarianlab.com'};
            Utility.sendMail('Test subject', 'Test htmlbody', emailList);
        
        user usr = new user();
        usr.Email = 'aakash2510jain@gmail.com';
        //insert usr;
        
        group gp1 = new group();
        gp1.Name = 'Techies';
        insert gp1;
        
        group gp = new group();
        gp.Name = 'Developers';
        insert gp;
        
        groupmember grpMem = new groupmember();
        grpMem.UserOrGroupId = gp.Id;
        grpMem.GroupId = gp1.Id;
        insert grpMem;
        Utility.getGroupUsers('Techies');
        
        Contact con = new Contact();
        
        Utility.checkIfNull(null);
        Utility.checkIfNull(con);
        Utility.checkIsNull(con);
        Utility.checkIsNull(null);
        Utility.checkIsOne(1);
        Utility.checkIsOne(2);
        Utility.getSystemDetails();
        Utility.getTrainingDetails();
        Utility.getSmsDetails();
        Utility.getUSDtoINRConvertedAmt(10);
        Utility.PastTenFinancialYear();
        Utility.financialYear();
        Utility.getPrevFinancialYear();
    } 
    @isTest public static void getCurrentDonor_Student_Mapping_Test(){
        Donor_Application_Mapping__c dnrAppMApping = new Donor_Application_Mapping__c();
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////        
    }
    @isTest public static void InsertSMSStatus_Test(){
        Utility.InsertSMSStatus('TestEndPointUrl', 'TestMessageBody', '1234567891', 'POST', 'testResponseBody', 201, 'Success');
        Utility.getCountryList();
        
    }
    @isTest public static void checkIFSCCode_Test(){
        //Methods defined as TestMethod do not support Web service callouts
       // Utility.checkIFSCCode('XYZ00123');
       // Utility.ifscCodeResponse('XYZ00123', True);
    
    }
    @isTest public static void getPicklistValuesforBranch_Test(){
        
        Utility.getPicklistValuesforBranch('Contact', 'Branch_Stream__c');
        Utility.getPicklistValuesforBranchEngMetch('Contact', 'Branch_Stream__c');
        Utility.returnNextCurrentYear('1st Year','BPharm');
        Utility.returnNextCurrentYear('2nd Year','BPharm');
        Utility.returnNextCurrentYear('3rd Year','BPharm');
        Utility.returnNextCurrentYear('4th Year','BPharm');
        
        Utility.returnNextCurrentYear('Year I, Sem 1','MBBS');
        Utility.returnNextCurrentYear('Year II, Sem 3','MBBS');
        Utility.returnNextCurrentYear('Year II, Sem 5','MBBS');
        Utility.returnNextCurrentYear('Year III (Part 1), Sem 7','MBBS');
        Utility.returnNextCurrentYear('Year III (Part 2), Sem 9','MBBS');
        
        Utility.returnNextCurrentYear('1st Year','Law');
        Utility.returnNextCurrentYear('2nd Year','Law');
        Utility.returnNextCurrentYear('3rd Year','Law');
        Utility.returnNextCurrentYear('4th Year','Law');
        Utility.returnNextCurrentYear('5th Year','Law');
        
        Utility.getCorrectData('Law', '1st Year', '2020', 2020);
        
        Utility.sessionEndYear('2020');
        Utility.testCoverage();
    }
    
}