public  class DocumentUploadLwc {
    @AuraEnabled
    public static List<DocRecordLwc> getDocRecordClsWrapper(String conId){
        System.debug('Con id ' + conId);
        Contact con = [select id,name,Letter_of_Thanks_to_Donors__c,Oath_Pledge_and_Declaration_Form_signed__c,Odd_Semester_Mark_Sheet_of_the_previous__c,Even_Semester_Mark_Sheet_of_the_previous__c,Entrance_Test_Marks_Rank_Certificate__c,Parents_or_Guardians_Declaration__c,PUC_12th_Marks_Sheet__c,Bonafide_Student_Certificate__c,Admission_or_Seat_Allotment_Letter__c,Copy_of_First_Sheet_of_Bank_Pass_Book__c,Income_Salary_Certificate__c,Statement_of_Estimated_Expenses_for_FY__c,Receipts_for_Actual_Expenses__c, Applicant_s_Pledge_of_Future_Support__c,Marks_Sheet_for_10th_Standard__c from contact where id =:conId ];
        List<DocRecordLwc> docWrapperRecordList = new List<DocRecordLwc>();
        List<String> docList= new List<String>();
        docList.add('Mark Sheet for Secondary School Certificate (10th) Board Examination');
        docList.add('Mark Sheet for Higher Secondary (12th/PUC/Intermediate) Examination');
        docList.add('Entrance Test Marks & Rank Certificate');
        docList.add('Counselling, Admission or Seat Allotment Letter');
        docList.add('Income Certificate, Salary Certificate, Pension Certificate or Income Tax Return or Other document, as applicable');
        docList.add('Bonafide Student Certificate showing status of enrolment in college, course/branch, year of study');
        docList.add('Receipts for Actual Expenses incurred for current year(College Fee/Hostel & Mess/Transport/Books/Uniform');
        docList.add('Statement of Estimated Expenses for the current academic year Issued by your College');
        docList.add('Copy of First Sheet of Bank Pass Book or Cancelled Cheque');
        docList.add('Applicants Pledge of Future Support to FFE');
        docList.add('Parent or Guardians Declaration');
        docList.add('Even Semester Mark Sheet of the previous academic year');
        docList.add('Odd Semester Mark Sheet of the previous year');
        //docList.add('Oath, Pledge and Declaration Form signed by you and your parent/guardian');
        //  docList.add('Letter of Thanks to Donors');
        Integer rownumber = 1 ;
        if(!docList.isEmpty()) {
            for(String acc: docList){
                DocRecordLwc arcls = new DocRecordLwc();
                if(acc.contains('Actual Expenses incurred for current')){
                    if(con.Receipts_for_Actual_Expenses__c == true){
                        arcls.isSelected =  true;
                    }else{
                        arcls.isSelected =  false;
                    }
                    arcls.docrelated = 'Prelim / Renewal';
                }
                if(acc.contains('Pledge of Future')){
                    if(con.Applicant_s_Pledge_of_Future_Support__c == true){
                       arcls.isSelected =  true;
                    }else{
                        arcls.isSelected =  false;
                    }
                    arcls.docrelated = 'Prelim / Renewal';
                }
                if(acc == 'Mark Sheet for Secondary School Certificate (10th) Board Examination'){
                    if(con.Marks_Sheet_for_10th_Standard__c == true){
                        arcls.isSelected =  true;
                    }else{
                        arcls.isSelected =  false;
                    }
                    arcls.docrelated = 'Prelim';
                }
                if(acc == 'Income Certificate, Salary Certificate, Pension Certificate or Income Tax Return or Other document, as applicable'){
                    if(con.Income_Salary_Certificate__c == true){
                        arcls.isSelected =  true;
                    }else{
                        arcls.isSelected =  false;
                    }
                    arcls.docrelated = 'Prelim';
                }
                if(acc.contains('Statement of Estimated Expenses')){
                    if(con.Statement_of_Estimated_Expenses_for_FY__c == true){
                        arcls.isSelected =  true;
                    }else{
                        arcls.isSelected =  false;
                    }
                    arcls.docrelated = 'Prelim / Renewal';
                }
                if(acc.contains('Copy of First Sheet')){
                    if(con.Copy_of_First_Sheet_of_Bank_Pass_Book__c == true){
                        arcls.isSelected =  true;
                    }else{
                        arcls.isSelected =  false;
                    }
                    arcls.docrelated = 'Prelim / Renewal';
                }
                if(acc == 'Counselling, Admission or Seat Allotment Letter'){
                    if(con.Admission_or_Seat_Allotment_Letter__c == true){
                        arcls.isSelected =  true;
                    }else{
                        arcls.isSelected =  false;
                    }
                    arcls.docrelated = 'Prelim';
                }
                if(acc.contains('Bonafide Student Certificate')){
                    if(con.Bonafide_Student_Certificate__c == true){
                        arcls.isSelected =  true;
                    }else{
                        arcls.isSelected =  false;
                    }
                    arcls.docrelated = 'Prelim / Renewal';
                }
                if(acc == 'Mark Sheet for Higher Secondary (12th/PUC/Intermediate) Examination'){
                    if(con.PUC_12th_Marks_Sheet__c == true){
                        arcls.isSelected =  true;
                    }else{
                        arcls.isSelected =  false;
                    }
                    arcls.docrelated = 'Prelim';
                }
                if(acc == 'Parent or Guardians Declaration'){
                    if(con.Parents_or_Guardians_Declaration__c == true){
                        arcls.isSelected =  true;
                    }else{
                        arcls.isSelected =  false;
                    }
                    arcls.docrelated = 'Prelim / Renewal';
                }
                if(acc.contains('Entrance Test Marks')){
                    if(con.Entrance_Test_Marks_Rank_Certificate__c == true){
                        arcls.isSelected =  true;
                    }else{
                        arcls.isSelected =  false;
                    }
                    arcls.docrelated = 'Prelim';
                }
                if(acc.contains('Even Semester Mark Sheet')){
                    if(con.Even_Semester_Mark_Sheet_of_the_previous__c == true){
                        arcls.isSelected =  true;
                    }else{
                        arcls.isSelected =  false;
                    }
                    arcls.docrelated = 'Renewal';
                }
                if(acc.contains('Odd Semester Mark Sheet')){
                    if(con.Odd_Semester_Mark_Sheet_of_the_previous__c == true){
                        arcls.isSelected =  true;
                    }else{
                        arcls.isSelected =  false;
                    }
                    arcls.docrelated = 'Renewal';
                }
                
                arcls.docObj = acc;
                arcls.rowNum = rownumber;
                docWrapperRecordList.add(arcls);
                rownumber ++;
                //isDisplay = True;
            } //end of for loop.

        } //end of if condition.
        return docWrapperRecordList;
    }

    @AuraEnabled
    public static string submit(List<DocRecordLwc> docRecordList, String conId){
        System.debug(docRecordList);
        Contact con = new Contact();
        con.Id = conId;
        for(DocRecordLwc rec : docRecordList){
            if(rec.docObj == 'Receipts for Actual Expenses incurred for current year(College Fee/Hostel & Mess/Transport/Books/Uniform'){
               con.Receipts_for_Actual_Expenses__c = rec.isSelected; 
            }else if(rec.docObj == 'Applicants Pledge of Future Support to FFE'){
                con.Applicant_s_Pledge_of_Future_Support__c = rec.isSelected; 
            }else if(rec.docObj == 'Mark Sheet for Secondary School Certificate (10th) Board Examination'){
                con.Marks_Sheet_for_10th_Standard__c = rec.isSelected; 
            }else if(rec.docObj == 'Income Certificate, Salary Certificate, Pension Certificate or Income Tax Return or Other document, as applicable'){
                con.Income_Salary_Certificate__c = rec.isSelected; 
            }else if(rec.docObj == 'Statement of Estimated Expenses for the current academic year Issued by your College'){
                con.Statement_of_Estimated_Expenses_for_FY__c = rec.isSelected; 
            }else if(rec.docObj == 'Copy of First Sheet of Bank Pass Book or Cancelled Cheque'){
                con.Copy_of_First_Sheet_of_Bank_Pass_Book__c = rec.isSelected; 
            }else if(rec.docObj == 'Counselling, Admission or Seat Allotment Letter'){
                con.Admission_or_Seat_Allotment_Letter__c = rec.isSelected; 
            }else if(rec.docObj == 'Bonafide Student Certificate showing status of enrolment in college, course/branch, year of study'){
                con.Bonafide_Student_Certificate__c = rec.isSelected; 
            }else if(rec.docObj == 'Mark Sheet for Higher Secondary (12th/PUC/Intermediate) Examination'){
                con.PUC_12th_Marks_Sheet__c = rec.isSelected; 
            }else if(rec.docObj == 'Parent or Guardians Declaration'){
                con.Parents_or_Guardians_Declaration__c = rec.isSelected; 
            }else if(rec.docObj == 'Entrance Test Marks & Rank Certificate'){
                con.Entrance_Test_Marks_Rank_Certificate__c = rec.isSelected; 
            }else if(rec.docObj == 'Even Semester Mark Sheet of the previous academic year'){
                con.Even_Semester_Mark_Sheet_of_the_previous__c = rec.isSelected; 
            }else if(rec.docObj == 'Odd Semester Mark Sheet of the previous year'){
                con.Odd_Semester_Mark_Sheet_of_the_previous__c = rec.isSelected; 
            }

        }
        update con;
        return 'List of Documents of scholars for Donor to View are now Selected!';
    }

    /* Wrapper class with checkbox and account object. 
      this is also  called as inner class 
    */
    public class DocRecordLwc{
        @AuraEnabled
        public boolean isSelected {get;set;}
        @AuraEnabled
        public String docrelated {get;set;}
        @AuraEnabled
        public String docObj {get;set;}
        @AuraEnabled
        public Integer rowNum{get;set;}
    }
}