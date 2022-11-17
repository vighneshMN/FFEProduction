public class MentorDetailPageController {
    
    public String baseURL {get;set;}
    public String selfAssesmentResponseString {get;set;}
    public string corpPicklistValues {get;set;}
    public string languagePicklistValues {get;set;}
    public string genderPicklistValues {get;set;}
    
    public MentorDetailPageController(){
        string menteeId = ApexPages.currentPage().getParameters().get('MenteeId');
        system.debug('menteeId--------'+menteeId);
        baseURL = Constants.MENTOR_MENTEE_SITE_URL ; 
        System.debug('baseURL'+baseURL);
        onPageLoadData pageLoadInstance = new onPageLoadData();
        
        List<Self_Assessment_Template__c> selfAssessmentQuestions = [SELECT Name,CreatedDate,LastActivityDate,LastModifiedById,(select name,id,Question__c,Type__c,Values__c from Self_Assessment_Questions__r) FROM Self_Assessment_Template__c];
        system.debug('selfAssessmentQuestions'+selfAssessmentQuestions);
        List<QuestionTemplateWrap> questionTempList = new List<QuestionTemplateWrap>();
        
        Map<Id,Self_Assessment_Response__c> allSelfAssessmentRes = new Map<Id,Self_Assessment_Response__c>();
        
        for(Self_Assessment_Response__c resp :[Select id,Name,Answer_Number__c,Self_Assessment_Question__c,FinalAnswer__c from Self_Assessment_Response__c where Mentee__c =:menteeId ]){  
            allSelfAssessmentRes.put(resp.Self_Assessment_Question__c,resp);
        }
        system.debug('allSelfAssessmentRes-------------'+allSelfAssessmentRes);
        for(Self_Assessment_Template__c tempRec:selfAssessmentQuestions){
            QuestionTemplateWrap questionTemp = new QuestionTemplateWrap();
            questionTemp.templateQuestion = tempRec.Name;
            List<QuestionWrap> QuestionWrapList = new List<QuestionWrap>();
            for(Self_Assessment_Question__c eachQuestion:tempRec.Self_Assessment_Questions__r){
                QuestionWrap quesWrap = new QuestionWrap();
                quesWrap.questionRec = eachQuestion;
                if(allSelfAssessmentRes.containsKey(eachQuestion.Id)){
                    quesWrap.questionRes = allSelfAssessmentRes.get(eachQuestion.Id);
                    quesWrap.questionRec.FinalAnswer__c =   String.valueOf(allSelfAssessmentRes.get(eachQuestion.Id).FinalAnswer__c);
                }
                
                if(eachQuestion.Type__c=='Picklist'){
                    quesWrap.optionList = eachQuestion.Values__c.split(',');
                }
                QuestionWrapList.add(quesWrap);
            }
            questionTemp.allQuestions = QuestionWrapList;
            questionTempList.add(questionTemp);
        }
        pageLoadInstance.selfAssessmentQuestions = questionTempList;
        selfAssesmentResponseString = JSON.serialize(pageLoadInstance);
        corpPicklistValues = JSON.serialize(picklist_values('Contact','Corporate__c'));
        languagePicklistValues = JSON.serialize(picklist_values('Contact','Spoken_Languages__c'));
        genderPicklistValues = JSON.serialize(picklist_values('Contact','Gender__c'));
        
    }
    
    
    public static string registerMentorFromGoogle(string Fname, string Lname, string email, string password){
        
        contact con = new contact(Id = checkIfContactExists(email));
        con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_Mentor).getRecordTypeId();
        
        con.FirstName = Fname ;
        if(!String.isBlank(Lname)){
        	con.LastName = Lname;            
        }
        else if(!String.isBlank(Fname)){
        	con.LastName = Fname;            
        }
        else if(!String.isBlank(email)){
            String[] arrLName = email.contains('@') ? email.split('@') : new String[]{email};
            con.LastName = arrLName[0];
        }else{
            con.LastName = 'Mentor';
        }
        con.password__c = password ;
        con.Login_Hash_Code__c = Utility.generateRandomString();
        con.Last_Hash_Code_Updated__c = System.now();
        con.Email = email;
        //con.Is_Mentor__c = True;
        upsert con;
        system.debug('conRec ====>'+con);
        return con.Login_Hash_Code__c;
    }
    public static string registerMentorFromFacebook(string name,string email, string password){
        
        String Firstname = name.substring(0,name.indexOf(' '));
        String Lastname = name.substring(name.indexOf(' ')+1);
        
        contact con = new contact(Id = checkIfContactExists(email));
        con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_Mentor).getRecordTypeId();
        con.LastName = name;
        con.password__c = password ;
        con.Login_Hash_Code__c = Utility.generateRandomString();
        con.Last_Hash_Code_Updated__c = System.now();
        con.Email = email;
        upsert Con;
        system.debug('conRec ====>'+con);
        return con.Login_Hash_Code__c;
    }
    
    private static Id checkIfContactExists(String emailId) {
        if(!String.isBlank(emailId)){
            string RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_Mentor).getRecordTypeId();
            List<Contact> contactList = [SELECT Id FROM Contact WHERE email = :emailId AND RecordTypeId = :RecordTypeId ORDER BY LastModifiedDate DESC LIMIT 1];
            if(!contactList.isEmpty())
                return contactList[0].Id;
        }
        return null;
    }
    
    @RemoteAction
    public static contact getMentorDetails(string mentorId){
        /*  contact mentorDetail = [select firstname,lastname,name,id,is_Mentor__c,Location__c,Profile_Pic_Attachment_Id__c,Linkedin_Profile_Link__c,Profile_Picture__c,Languages_Known__c,Language_Known__c,Language__c,Gender__c,Email,mailingStreet, mailingCity, mailingState, mailingPostalCode, mailingCountry,Company_Name__c,Professional_Designation__c,Phone,Area_of_Specialization__c,College_Name__r.Name,Spoken_Languages__c,Years_of_Work_Experience__c from contact where recordtype.name = 'Mentor' AND Id =:mentorId];  */
        contact mentorDetail = [select firstname,lastname,name,id,is_Mentor__c,Opting_for_mentorship__c,Corporate__c,Mentor_College_Name__c,Designation__c,Location__c,Profile_Pic_Attachment_Id__c,Linkedin_Profile_Link__c,Profile_Picture__c,Languages_Known__c,Language_Known__c,Language__c,Gender__c,Email,mailingStreet, mailingCity, mailingState, mailingPostalCode, mailingCountry,Company_Name__c,Professional_Designation__c,Phone,Area_of_Specialization__c,College_Name__r.Name,Spoken_Languages__c,Years_of_Work_Experience__c from contact where Is_Mentor__c = True AND Login_Hash_Code__c =:mentorId];
        return mentorDetail;        
    }
    
    @RemoteAction
    public static list<Mentor_Mentee_Association__c> getMenteeDetails(string mentorId){
        String currentFy =  Utility.financialYear();
        /*  list<contact> menteeDetail = [select firstname,lastname,name,id,is_Mentor__c,Language__c,Location__c,Languages_Known__c,Gender__c,Email,mailingStreet, mailingCity, mailingState, mailingPostalCode, mailingCountry from contact where recordtype.name = 'Mentee'];  */
        List<string> corseToExcludeList = New List<string>{'BPharm','Law'};
        list<Mentor_Mentee_Association__c > MentorMenteeAssociationList = [select name,id,mentee_del__c,mentee_del__r.Name,mentee_del__r.firstname,mentee_del__r.lastname,mentee_del__r.Id,mentee_del__r.Language__c,mentee_del__r.Location__c,mentee_del__r.Language_Known__c,
        mentee_del__r.Gender__c,mentee_del__r.Modules__c ,mentee_del__r.Email,mentee_del__r.mailingStreet ,mentee_del__r.mailingCity, mentee_del__r.Profile_Pic_Attachment_Id__c ,mentee_del__r.mailingState,mentee_del__r.mailingPostalCode,mentee_del__r.mailingCountry,mentee_del__r.Profile_Picture__c,Modules__c,(select name,id,Status__c,Date__c,Agenda__c,Description__c,End_time__c,Time__c from Sessions__r) from Mentor_Mentee_Association__c where Mentor__r.Login_Hash_Code__c =: mentorId and( Mentorship_FY__c =:currentFy OR Mentee_Course__c=:corseToExcludeList )]; 
        return MentorMenteeAssociationList;        
    }
    
    
    
    @RemoteAction
    public static void mentorSignOut(string mentorId){
        update new contact(Id = mentorId,Login_Hash_Code__c = '' );
    }
    
    @RemoteAction
    public static void mentorMenteeAssociationCompleted(string mmaId){
        update new Mentor_Mentee_Association__c(Id = mmaId,Status__c = 'Completed' );  
    }
    
    @RemoteAction 
    public static void updateMentorDetails(contact mentorRecord,list<string> selectedlanguage){
        mentorRecord.Spoken_Languages__c = String.join(selectedlanguage, ';');
        update mentorRecord;
    }
    
    @RemoteAction
    public static string getHelpDoc(){
        string helpDocId = [select name,id from document where name ='Mentor User Guide'].Id;
        if(helpDocId != null){
            return helpDocId;
        }else{
            return null;
        }
    }
    
    @RemoteAction
    public static List<pragrammeWithAttachment> getProgramDetails(){
        try{
            List<pragrammeWithAttachment> listToBeReturned = new List<pragrammeWithAttachment>();
            
            for(Program__c programmeRec: [SELECT CreatedDate,Name,Skills__c,Image_URL__c, (SELECT Id, Name FROM Attachments ORDER by CreatedDate ASC) FROM Program__c]){
                System.debug('programmeRec'+programmeRec.Attachments.size());
                if(!programmeRec.Attachments.isEmpty()){
                    list<Attachment> attList = new list<Attachment>();
                    for(Attachment att:programmeRec.Attachments){
                        attList.add(att);
                    }
                    listToBeReturned.add(new pragrammeWithAttachment(programmeRec,attList));  //programmeRec.Attachments.Id
                }else{
                    listToBeReturned.add(new pragrammeWithAttachment(programmeRec,null));
                }
                
            }
            System.debug('listToBeReturned'+listToBeReturned);
            return listToBeReturned;
        }catch(Exception e){
            System.debug('listToBeReturned'+e.getLineNumber()+' AT '+e.getMessage());
            return null;
        }
        
    }
    
    @RemoteAction
    Public static contact getMenteeProfileDetails(string contactId){
        system.debug('contactId========>'+contactId);
        Contact menteeRec = [SELECT id, FirstName, LastName, phone, FFE_ID__c, Spoken_Languages__c, Email, College_Name__r.Name, College_Location__c, Branch_Stream__c, Modules__c,What_are_your_top_two_career_goals__c,hobbies_and_interests__c,
                             MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Branch_Other__c,College_City__c,College_Name__c,College_Other__c,
                             College_State__c,Type__c,Course__c,Entrance_Exam_Maximum_Marks__c,Entrance_Exam_Taken_In_Year__c,
                             Gender__c,English_Written_Score_post__c,English_Spoken_Score_post__c,CTC__c,Designation__c,Company_Name__c,Location__c,Other__c,Placement_Info__c,Semester9__c,Semester10__c,Has_Mentor__c  FROM Contact WHERE  Id =:contactId];//Added KYC_Verified__c,Is_IFSC_Code_Verified__c,Other_Type_Bank_Account__c in query fields -- Sumit Gaurav -- 23-June-2020
        
        return menteeRec; 
        
    }
    
    @RemoteAction
    Public Static list<Session__c> getAllSessions(string mentorMenteeAssociationId){
        
        list<Session__c> listOfSession = [select name, id, Agenda__c, Date__c, Description__c, Meeting_Link__c, Mentor_Mentee_Association__c,Status__c,Feedback_Status__c,End_time__c, Time__c, Mentor_Mentee_Association__r.Total_Mentoring_Hours__c, Mentor_Mentee_Association__r.Duration_of_Sessions_Attended__c, (select name,id,Description__c,Mentor_Rating__c,Mentee_Rating__c,Feedback_given_by__c from Feedbacks__r), (SELECT Id, Name FROM Attachments) from Session__c where Mentor_Mentee_Association__c =:mentorMenteeAssociationId ORDER BY Date__c DESC];
        return listOfSession;
    }
    @RemoteAction
    public static List<Contact> getMentorProfile(String mentorID){
        return [SELECT Id,Profile_Pic_Attachment_Id__c from Contact where Id=:mentorID];
    }
    
    @RemoteAction 
    Public Static list<string> getModulePicklist(string mentorMenteeAssociationId){
      /*  Mentor_Mentee_Association__c mmaRec = [select name,id,Modules__c from Mentor_Mentee_Association__c where id =:mentorMenteeAssociationId];
        system.debug('-------'+mmaRec.Modules__c);
        List<String> moduleList = mmaRec.Modules__c.split(';');
        system.debug('lstAlpha=='+moduleList.size());  */

        String objectName = 'Mentor_Mentee_Association__c';
        String fieldName ='Modules__c';
        list<string> moduleList = New list<string>();
        Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            System.debug(pickListVal.getLabel() +' '+pickListVal.getValue());
            moduleList.add(pickListVal.getLabel());

        }   
        
        return moduleList;
    }
    
    @RemoteAction
    Public static void createNewSession(string sessionDate, integer startHour, integer startMin, integer endHour, integer endMin,string agenda,string sessionDescription,string mmAssociation, string MeetingLink){
        String[] arrTest = sessionDate.split('T');
        string[] dateArray = arrTest[0].split('-');
        
        Integer year = Integer.valueOf(dateArray[0]);
        Integer month = Integer.valueOf(dateArray[1]);
        Integer day = Integer.valueOf(dateArray[2]);
        date newDate = date.newInstance(year, month, day);
        system.debug(newDate);
        
        system.debug('sessionDate===>'+startHour+'==='+startMin+'==='+endHour+'=='+endMin);
        Session__c session = new Session__c();
        session.Time__c = Time.newInstance(startHour, startMin, 0, 0);
        session.Date__c = newDate;
        session.End_time__c = Time.newInstance(endHour, endMin, 0, 0);
        session.Description__c = sessionDescription;
        session.Agenda__c = agenda;
        session.Module__c = agenda;
        session.Status__c = 'Created';
        session.Mentor_Mentee_Association__c = mmAssociation;
        session.Meeting_Link__c = MeetingLink;
        
        insert session;
    }
    
    @RemoteAction 
    Public static void updateSession(string sessionDate, integer startHour, integer startMin, integer endHour, integer endMin,string sessionId){
        String[] arrTest = sessionDate.split('T');
        string[] dateArray = arrTest[0].split('-');
        
        Integer year = Integer.valueOf(dateArray[0]);
        Integer month = Integer.valueOf(dateArray[1]);
        Integer day = Integer.valueOf(dateArray[2]);
        date newDate = date.newInstance(year, month, day);
        system.debug(newDate);
        system.debug('sessionDate===>'+startHour+'==='+startMin+'==='+endHour+'=='+endMin+'=='+sessionId);  
        update new session__c(Id = sessionId, Date__c  = newDate, Time__c = Time.newInstance(startHour, startMin, 0, 0), End_time__c = Time.newInstance(endHour, endMin, 0, 0));
    }  
    
    
    @RemoteAction
    public static void markSessionAsCompleted(Session__c session){
        system.debug('session==>'+session);
        try{
            update session;   
        }catch(exception e){
            system.debug('get lineNumber==>'+e.getLineNumber()+'getMessage==>'+e.getMessage());  
        }
        
    }
    
    @RemoteAction
    public static void submitFeedBack(string sessionId, string feedBackDescription,string mentorRating){
        system.debug('sessionId==>'+sessionId+'sessionFeedback==>'+feedBackDescription);  
        Feedback__c mentorFeedback = new Feedback__c();
        mentorFeedback.Session__c = sessionId;
        mentorFeedback.Description__c = feedBackDescription;
        mentorFeedback.Feedback_given_by__c = 'MENTOR';
        mentorFeedback.Mentor_Rating__c = mentorRating;
        insert mentorFeedback;
    }
    
    @RemoteAction
    public static String doUploadProfilePic(String mentorId, String attachmentBody, String attachmentName) {
        system.debug('sessionId==>'+mentorId+'attachmentBody==>'+attachmentBody+'attachmentName==>'+attachmentName);
        if(mentorId != null && attachmentBody != null) {
            Attachment att = new Attachment();
            String newBody = '';
            newBody += attachmentBody;
            att.Body = EncodingUtil.base64Decode(newBody);
            att.Name = attachmentName;
            att.parentId = mentorId;
            
            insert att;
            
            update new Contact(Id = mentorId,Profile_Pic_Attachment_Id__c = att.Id );
            return att.Id; 
        }
        return null;
    }
    
    public static String[] picklist_values(String object_name, String field_name)
    {
        String[] values = new String[]{};
            String[] types = new String[]{object_name};
                Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        for(Schema.DescribeSobjectResult res : results)
        {
            for (Schema.PicklistEntry entry : res.fields.getMap().get(field_name).getDescribe().getPicklistValues())
            {
                if (entry.isActive()) {values.add(entry.getValue());}
            }
        }
        
        system.debug('values'+values);
        return values;
    }
    
    public String getDocumentBaseURL(){
        String sfUrl=URL.getSalesforceBaseUrl().getHost();
        
        //String baseURL = 'https://'+sfUrl;
        list<site_url__c> siteUrl = site_url__c.getall().values();
        system.debug(siteUrl[0].Name);
        string baseURL = siteUrl[0].Name;
        String domainNameSubstring = baseURL.substringBefore('.');
        return domainNameSubstring + '--c.documentforce.com';
    }
    
    //Auth here
    public PageReference checkUserAuth(){
        return MentorMenteeAuthHelper.checkUserAuth(Apexpages.currentPage().getParameters().get('id'));
    }
    
    
    class pragrammeWithAttachment{
        public Program__c programmeRec;
        public list<Attachment> attId;
        
        public pragrammeWithAttachment(Program__c programmeRec,list<Attachment> attId){
            this.programmeRec = programmeRec;
            this.attId = attId;
        }
    }
    class onPageLoadData{
        List<QuestionTemplateWrap> selfAssessmentQuestions{get;set;}
        
        List<Program__c> allProgrammes{get;set;}
    }
    class QuestionTemplateWrap{
        public string templateQuestion{get;set;}
        public List<QuestionWrap> allQuestions{get;set;}
    }
    class QuestionWrap{
        public Self_Assessment_Question__c questionRec{get;set;}
        public Self_Assessment_Response__c questionRes{get;set;}
        public List<String> optionList{get;set;}
    }
}