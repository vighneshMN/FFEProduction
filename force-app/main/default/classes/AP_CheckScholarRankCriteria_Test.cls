/*
* Purpose: Test class for AP_CheckScholarRankCriteria Class
*/
@isTest
private class AP_CheckScholarRankCriteria_Test {
    
    public static void createStudent(String lastName,Decimal xIIth,Decimal maximumMarks,String entranceName,String x12th_Year_Passed,Decimal annualIncome,Integer rank,String course){
        
        Contact con = Utility_Test.insertNewStudentRec('ABC',lastName,null,null,null,null,null,xIIth,maximumMarks,entranceName,x12th_Year_Passed);
        con.Annual_Family_Income__c = annualIncome;
        con.Entrance_Test_Rank__c = rank;
        con.Course__c = course;
        con.Entrance_Exam_Taken_In_Year__c='2022';
        con.JEE_Advance_All_India_Rank__c=40;
        con.JEE_Main_CRL_Rank__c=40;
        insert con;
        AP_CheckScholarRankCriteria.ValidationRankCriteria(con);
    }
    
    public static testmethod void studentCriteria(){
        User auser = Utility_Test.createUser('ZXYSpoo099@gmail.com');
        System.runAs(auser){
            test.startTest();
            insert new Scholarship_Criteria__c(HS_Year_of_Passing_Less_than__c = 1, Max_Annual_Family_Income__c = 180000, Min_12th_Percentage__c = 70);
            createStudent('XYZ',300,400,'Karnataka Common Entrance Test (CET)','2022',160000,200,'BE/B.Tech');
            createStudent('XYZ',0,400,'Karnataka Common Entrance Test (CET)','2021',160000,1000,'M.Tech');
            //createStudent('XYZ',300,400,'Karnataka Common Entrance Test (CET)','2021',160000,100,'MBBS');
            createStudent('YEZ',300,400,'Karnataka Common Entrance Test (CET)','2021',190000,100,'MBBS');
            createStudent('YTZ',300,400,'Karnataka Common Entrance Test (CET)','2013',190000,100,'MBBS');
            createStudent('TZ',300,300,'Karnataka Common Entrance Test (CET)','2020',160000,10,'BE/B.Tech');
            createStudent('TRZ',300,400,'Karnataka Common Entrance Test (CET)','2021',160000,200,'BE/B.Tech'); 
            test.stopTest();
        }        
    }
    
    public static testmethod void studentCriteria2(){
        User auser = Utility_Test.createUser('ZXYSpoo099@gmail.com');
        System.runAs(auser){
            test.startTest();
            
            insert new Scholarship_Criteria__c(HS_Year_of_Passing_Less_than__c = 1, Max_Annual_Family_Income__c = 180000, Min_12th_Percentage__c = 70);
            
            createStudent('TRZ',300,400,'Karnataka Common Entrance Test (CET)','2022',160000,200,System.Label.StudentCourseBPharm);
            createStudent('TRZ',300,400,'Karnataka Common Entrance Test (CET)','2022',160000,200,System.Label.StudentCourseBALLB);
            createStudent('TRZ',300,400,'JEE (Main)','2022',160000,0,System.Label.StudentCourseBTech);
            createStudent('TRZ',300,400,'JEE (Advanced)','2022',160000,0,System.Label.StudentCourseBTech);
            createStudent('TRZ',400,400,'JEE (Advanced)','2022',160000,0,System.Label.StudentCourseBTech);
            Contact con1 = Utility_Test.insertNewStudentRec('dummy','Student','121321312','test@test.com','323233232',null,null,400,400,'Karnataka Common Entrance Test (CET)','2021');
            con1.Annual_Family_Income__c = 160;
            con1.Entrance_Test_Rank__c   = 1;
            con1.Course__c 			= 'BE/B.Tech';
            con1.Branch_Stream__c       = 'Computer Science';
            con1.X12th_Year_Passed__c  = '2022';
            con1.Entrance_Exam_Taken_In_Year__c = '2022';
            insert con1;
            test.stopTest();
        } 
        
    }
    
    @isTest static void Testmy(){
        test.startTest();
        AP_CheckScholarRankCriteria.mytest();
        test.stopTest();
    }
}