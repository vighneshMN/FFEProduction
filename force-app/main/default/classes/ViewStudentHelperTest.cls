@isTest
Public Class ViewStudentHelperTest {
    
    @isTest
    public static void initMethodTest(){
        System.debug('Test method ');
        ViewStudentHelper.initMethod();
        ViewStudentHelper.getGauNames();
        ViewStudentHelper.getfinancilaYearDetails();
        ViewStudentHelper helpr = new ViewStudentHelper();
    }

    public static Contact createDonor(String lastname){
        
        id donorRecordType   = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_DONOR).getRecordTypeId();
        
        Contact con  = new Contact();
        con.LastName = lastname;
        con.RecordTypeId = donorRecordType;
        return con;
    }
    
    @isTest
    public static void getStudentDataTest(){
        Donation_Program__c dp  = Utility_Test.createDonationProgram('Test','Medical');
        insert dp;
        npsp__General_Accounting_Unit__c gau =Utility_Test.createGAU('Test',dp.id);
        insert gau;
         Contact conDonor = Utility_Test.insertNewDonorId('Test','Donor');
        conDonor.Email ='testdonor@mailinator.com';
        conDonor.MobilePhone = '8888888';
        insert conDonor;
         Contact ct         = Utility_Test.insertNewStudentRec('sample','sample1','1234567897','sample@gmail.com','3456789321','','sample1@gmail.com',80,100,'Karnataka Common Entrance Test (CET)','2016');
            ct.MailingState    = 'Karnataka';
            ct.MailingCity     = 'Bangalore';
            
            insert ct;            
            
         Contact conStudent = Utility_Test.insertSingleStudent('Test','Student');
        conStudent.MailingState = 'Karnataka';
        conStudent.Course__c = 'BE/B.Tech';
        //conStudent.College_Name__c = cm.Id;
        conStudent.Email = 'Teststud@mailinator.com';
        conStudent.MobilePhone = '777777778888';
        conStudent.Financial_year__c = '2017-18';
        insert conStudent;
        
        Application__c ap = Utility_Test.insertNewApplication('Selected','Submitted');
        ap.Student__c = conStudent.Id;
        ap.DM_Financial_Year__c = '2017-18';
        insert ap;
        
        Business_Account__c  ba = new Business_Account__c();
        ba.Name = 'AXIS Bank';
        insert ba;
        
        Business_Account_Utilization__c bau = new Business_Account_Utilization__c();
        bau.Application__c = ap.Id;
        insert bau;
        
        Fund_Utilization__c fu = new Fund_Utilization__c();
        fu.Donor__c = conDonor.Id;
        fu.Application__c = ap.Id;
        fu.General_Accounting_Unit__c = gau.Id;
        fu.Business_Account_Utilization__c = bau.Id;
        insert fu;
        ViewStudentHelper.getStudentData( ap.DM_Financial_Year__c,'Test',conDonor.id);
    }

    @isTest
    public static void getBase64encodedTest(){
        String jsonstr = '[{"donorId":"0039D00000CWVieQAH","financialYearSelected":"2021-22","donatedAmt":null,"scholarshipamt":null,"AttachmentLink":"0039D00000CWKbJQAX"}]';
        ViewStudentHelper.getBase64encoded(jsonstr);
    }
}