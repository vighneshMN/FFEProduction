/*
* @description : This controller is used for Student/Alumni/Facilitar Profile Page
* @Author      : Amritesh
* @createdDate : 22/03/2017
*/  
global class AP_Application_CTRL {
    
    public string currentUserId             {get;set;} 
    static String code;
    public string recordType                {get;set;}    
    public string APGenderPickLstValues     {get;set;}
    public string Error                     {get;set;}
    public string gemailId                   {get;set;} //Added this line to Mentor mentee signup / login 5/5/2021
    public string gFirstName                {get;set;} //Added this line to Mentor mentee signup / login 5/5/2021
    public string gLastName                 {get;set;} //Added this line to Mentor mentee signup / login 5/5/2021
    public string  FbId                     {get;set;}
    public string  name                     {get;set;}
    public string mediumOfInstruction       {get;set;} 
    public string APtypePickLstValues       {get;set;}
    public string listOfStates              {get;set;}
    public string studentCourse             {get;set;}
    public string typeOfBankAccounts        {get;set;}
    public string accomTypesList            {get;set;}
    
    public string studentBranch             {get;set;}
    public string studentLawBranch          {get;set;}
    public string occupationList            {get;set;} 
    public string btechYearList             {get;set;} 
    public string MtechYearList             {get;set;} 
    public string MbbsYearList              {get;set;}
    public string entranceTests             {get;set;}
    public string gradSystemList            {get;set;}
    public boolean isRenewalAvailable       {get;set;}
    public static string errMsg             {get;set;}
    public integer maxAttchmentSize         {get;set;}
    public string prelimFiles               {get;set;}
    public string renewalFiles              {get;set;}
    public string appSuccess                {get;set;}
    public string donorLogoDescription      {get;set;}
    public string placementOptions          {get;set;} 
    public String studentResumeUpload       {get;set;}
    public string finalYearMarksnoti        {get;set;}
    public string finalYearOddSem           {get;set;}
    public string finalYearEvenSem          {get;set;}
    public string currentFinancialYear      {get;set;}
    public string hasCodeUpdate 			{get;set;}
    public boolean isMentorExist			{get;set;}
    public string InternalStatus 			{get;set;}
    public string rejectReason	 			{get;set;}
        
    public AP_Application_CTRL(){
        initialize();
        
    }
    
    
    @RemoteAction
    public static string getStudentUserDetail(String studentId){
        return JSON.serializePretty(AP_Application_Helper.getScholarUserDetail(studentId));
    }
    
    @RemoteAction
    public static string registerMentorFromGoogle(string Fname,string Lname,string GmailID,string password){
        string mentorId = MentorDetailPageController.registerMentorFromGoogle( Fname, Lname, GmailID, password);
        return mentorId;
    }
    @RemoteAction
    public static string registerMentorFromFacebook(string name,string FbID,string password){
        string mentorId = MentorDetailPageController.registerMentorFromFacebook( name,FbID, password);
        return mentorId;
    }
    /* Update student profile*/
    @RemoteAction
    public static string updateStudentInSFDC(Contact studentInfo){
        return JSON.serializePretty(AP_Application_Helper.updateStudentInSFDC(studentInfo));
    }
    @RemoteAction
    public static string updateStudentInSFDC_TYS(Contact studentInfo){
        return JSON.serializePretty(AP_Application_Helper.updateStudentInSFDC_TYS(studentInfo));
    }
    
    /* get Facilitator details*/
    @RemoteAction
    public static string getFacilitatorUserDetail(String facilitatorId){
        return JSON.serializePretty(AP_Application_Helper.getFacilitatorUserDetail(facilitatorId));
    }
    
    /* Update facilitator profile*/
    @RemoteAction
    public static string updateFacilitatorInSFDC(Contact studentInfo){
        return JSON.serializePretty(AP_Application_Helper.updateFacilitatorInSFDC(studentInfo));
    }
    
    @RemoteAction
    public static string getFacilitatorStudents(String facilitatorId){
        Set<string> applicationInternalStatus = new Set<string>{'FACILITATOR MATCHED','FACILITATOR_MATCHED', 'ELIGIBLE', 'INELIGIBLE', 'SELECTED', 'REJECTED_BY_FACILITATOR', 'REJECTED BY FACILITATOR', 'REJECTED BY FFE STAFF', 'NOT INTERESTED'};
        Set<string> facilitatorMatched = new Set<string>{'FACILITATOR MATCHED','FACILITATOR_MATCHED'};
                
        FacStudentsWrapper returnWrapper = new FacStudentsWrapper();
        List<Contact> allFAContacts = AP_Application_Helper.getStudentAllotedToFac(facilitatorId);
        system.debug('allFAContacts--------'+allFAContacts);
        Map<Id,Contact> appXcontact = new Map<Id,Contact>();
        for(Contact con : allFAContacts) {
            if(con.Applications__r != null && !con.Applications__r.isEmpty()) {
                string internalStatus = con.Applications__r[0].Internal_Status__c;
                if(internalStatus != null){
                    internalStatus = internalStatus.toUpperCase();
                    if(con.IsPrelimProcessed__c && ( con.Display_on_facilitator_Profile__c || !applicationInternalStatus.contains(internalStatus))){
                        returnWrapper.completed.add(con);
                    }else if(!con.IsPrelimProcessed__c && facilitatorMatched.contains(internalStatus)) {
                        appXcontact.put(con.Applications__r[0].Id,con);
                    }
                }
            }
        }
        if(!appXcontact.isEmpty()) {
            system.debug('appXcontact-----------------'+appXcontact);
            for(Application__c app : [SELECT Id FROM Application__c WHERE Id IN :appXcontact.keyset() AND Student__c IN :appXcontact.values() AND (CreatedDate = THIS_FISCAL_YEAR OR Student__r.Display_on_facilitator_Profile__c = TRUE)]) {
                returnWrapper.toBeProcessed.add(appXcontact.get(app.Id));
            }
        }
        return JSON.serializePretty(returnWrapper);
    }
    
    /* Upload Profile Pic*/
    @RemoteAction
    public static string uploadProfilePic(String attachmentBody,string attachmentName,string attparentId,String attachmentId){
        return AP_Application_Helper.uploadProfilePic(attachmentBody,attachmentName,attparentId,attachmentId);
    }    
    
    /* View student profile*/
    @RemoteAction
    public static string viewStudentProfile(String studentId){
        return JSON.serializePretty(AP_Application_Helper.viewStudentProfile(studentId));
    }  
    
    /* Verify student */
    @RemoteAction
    public static string verifyStudent(Application__c studentInfo){
        return AP_Application_Helper.verifyStudent(studentInfo);
    }
    
    /* Reject student */
    @RemoteAction
    public static string rejectStudent(Application__c studentInfo){
        return AP_Application_Helper.rejectStudent(studentInfo);
    }
    
    /* Renew Application */
    @RemoteAction
    public static String renewApplication(RenewalWrapper rnwWrp){
        return AP_Application_Helper.renewApplication(rnwWrp);
    }
    
    @RemoteAction
    public static string uploadDoc(String attachmentBody,string attachmentName,string attparentId,String attachmentId,string description,string attachIdToDelete ){
        if(attachIdToDelete != null && attachIdToDelete != ''){
            try{
                delete [Select id from Attachment where id=:attachIdToDelete]; 
            }catch(Exception e){}            
        }
        return AP_Application_Helper.uploadAttachment(attachmentBody,attachmentName,attparentId,attachmentId,description);
    }
    
     @RemoteAction
    public static void updateDocMissing(String appId, String fileName) {
        AP_Application_Helper.updateDocMissing(appId, fileName);
    }
    
    @RemoteAction
    public static string uploadDoc_new(String expenseDet,String studentId,String certificateExpDate, String attachmentBody,string attachmentName,string attparentId,String attachmentId,string description,string attachIdToDelete ){
        if(attachIdToDelete != null && attachIdToDelete != ''){
            try{
                delete [Select id from Attachment where id=:attachIdToDelete]; 
            }catch(Exception e){}            
        }
        return AP_Application_Helper.uploadAttachment_new(expenseDet,studentId,certificateExpDate,attachmentBody,attachmentName,attparentId,attachmentId,description);
    }
    
    @RemoteAction
    public static List<College_Master__c> searchCollege(String searchTerm) {
        system.debug(AP_Student_Application_Helper.searchCollege(searchTerm,null));
        return AP_Student_Application_Helper.searchCollege(searchTerm,null);        
    }
   
    
    @RemoteAction
    public static string facilitatorInbutByStudent(Application__c applnRemarks) {
        return AP_Application_Helper.facilitatorInbutByStudent(applnRemarks);        
    }
    
    @RemoteAction
    public static string getAllAttachments(string parentId, String attachemntFor){
        return JSON.serializePretty(AP_Application_Helper.getAllAttachments(parentId,attachemntFor));
    }
    
    
    @RemoteAction
    public static string getCities(string currentState){
        return JSON.serializePretty(AP_Application_Helper.getAllCities(currentState));
    }
    @RemoteAction
    public static boolean checkIFSCCode(String code,String studentId){
        Boolean boolFlag;
        try{
            boolFlag = Utility.checkIFSCCode(code);
            //update new Contact(Id=studentId,Is_IFSC_Code_Verified__c =boolFlag);
        }
        catch(Exception objException){
            HandleBusinessException.captureError('AP_Application_CTRL', 'checkIFSCCode', objException);
            boolFlag = false;
        }
        return boolFlag;
    }
    
    @RemoteAction
    public static string ifscCodeResponse(String code,String studentId){
        String str; 
        boolean boolInternalCall = false;
        try{ 
            str = Utility.ifscCodeResponse(code,boolInternalCall);
            //update new Contact(Id=studentId,Is_IFSC_Code_Verified__c =boolFlag);
        }
        catch(Exception objException){
            HandleBusinessException.captureError('AP_Application_CTRL', 'ifscCodeResponse', objException);
            str = '';
        }
        return str;
    }
    @RemoteAction
    public static Application__c missingDocumentUplaoded(string appId){
        return AP_Application_Helper.documentUploaded(appId);
    }
    
    @RemoteAction
    public static string applicationExpenseUpdate(RenewalWrapper rnwWrp){
        return JSON.serializePretty(AP_Application_Helper.applicationExpenseUpdate(rnwWrp));
    }
    
    @RemoteAction
    public static string getAllTrainings(string course, string yearInWhichStudying,Integer aptitudeAnlyticalScore,Integer AptitudeLogicalScore,Integer EnglishSpokenScore,Integer EnglishWrittenScore,String studentID){
        return JSON.serializePretty(AP_Application_Helper.getAllTrainings(course,yearInWhichStudying,integer.valueof(aptitudeAnlyticalScore),integer.valueof(AptitudeLogicalScore),integer.valueof(EnglishSpokenScore),integer.valueof(EnglishWrittenScore),studentID));
    }
    
    @RemoteAction
    public static string getAccademicDetails(String course, String currentYear){
        return JSON.serializePretty(AP_Application_Helper.semesterData(AP_Application_Helper.getAcademicDetails(),course,currentYear));
        
    }
    
    @RemoteAction
    public static string submitPlacementInfo(PlacementWrp studentInformation){
        return JSON.serializePretty(AP_Application_Helper.submitPlacementInfo(studentInformation));
    }
    
    @RemoteAction
    public static string submitOtherInfo(String stdId,String otherText){
        return JSON.serializePretty(AP_Application_Helper.submitOtherInfo(stdId,otherText));
    }
    
    @RemoteAction
    public static void savePlacementInfo(String stdId,String placemntInfo){
        AP_Application_Helper.savePlacementInfo(stdId,placemntInfo);
    }
    
    @RemoteAction
    public static String submitFinalYearMarksDetails(Contact con){
        system.debug('con-----------'+con);
        return AP_Application_Helper.submitFinalYearMarksDetails(con);
    }
    
    public Boolean isMentorshipSite {get;set;}
    public Boolean isApplicationSite {get;set;}
    public PageReference redirectProfilePage(){
        isMentorshipSite 			= false;
        code                        = ApexPages.currentPage().getParameters().get('code');
        
        Cookie lkcode = ApexPages.currentPage().getCookies().get('googleCode');
        System.debug('COOKIE CODE');
        if(lkcode!=null){
            System.debug('lkcode'+lkcode.getValue());
        }
        System.debug('COOKIE CODE END');
        system.debug('ApexPages.currentPage().getParameters().get(m)------'+ApexPages.currentPage().getParameters().get('m'));
        isMentorshipSite            = ApexPages.currentPage().getParameters().get('m') == '1' ? true : false;
        isApplicationSite            = ApexPages.currentPage().getParameters().get('m') == '0' ? true : false;
        System.debug('ISMENTORSHIP 272---------'+isMentorshipSite);
        System.debug('isApplicatinSite 272---------'+isApplicationSite);
         Cookie cookiehashObj    = new Cookie('hashCodeLog', '', null, 0, false);
        Cookie cookieGoogleObj  = new Cookie('googleSessionId', '', null, 0, false);
        Cookie cookiePrlmObj  = new Cookie('cookieEncStudent', '', null, 0, false);
        
        Cookie cookieObj            = new Cookie('googleCode', code, null, 100, false);
        Cookie cookiefbObj      = new Cookie('fbSessionId', '', null, 0, false);
        Cookie cookieLoginTypeObj   = new Cookie('loginType', 'googleLogin', null, 86400, false);
        Cookie mSite 				= new Cookie('mentorSite',isMentorshipSite == true ? 'true' : 'false', null, 100, false);
        Cookie aSite 				= new Cookie('applicSite',isApplicationSite == true ? 'true' : 'false', null, 100, false);
        
        PageReference MyNewPage     = Page.redirectProfilePage;
        system.debug('code'+code);
        MyNewPage.setCookies(new Cookie[]{cookieObj, cookieLoginTypeObj, mSite, aSite, cookiehashObj, cookiefbObj, cookieGoogleObj, cookiePrlmObj});
        system.debug('MyNewPage'+MyNewPage);
        MyNewPage.setRedirect(true);
        return MyNewPage;
    }
    public PageReference redirectDonorPage(){
        code                        = ApexPages.currentPage().getParameters().get('code');
        Cookie cookieObj            = new Cookie('googleCode', code, null, 100, false);
        Cookie cookieLoginTypeObj   = new Cookie('loginType', 'googleLogin', null, 86400, false);
        PageReference MyNewPage     = Page.studentProfile;
        
        MyNewPage.setCookies(new Cookie[]{cookieObj, cookieLoginTypeObj});
        
        MyNewPage.setRedirect(true);
        return MyNewPage;
    }
    
    public PageReference redirectProfilePagefoFB() {
        isMentorshipSite 			= false;
        isApplicationSite			= false;
        system.debug('redirectProfilePagefoFB cookiessssssssssssss');
        system.debug('ApexPages.currentPage().getParameters().get(m)------'+ApexPages.currentPage().getParameters().get('m'));
        code                        = ApexPages.currentPage().getParameters().get('code');
        isMentorshipSite            = ApexPages.currentPage().getParameters().get('m') == '1' ? true : false;
        isApplicationSite            = ApexPages.currentPage().getParameters().get('m') == '0' ? true : false;
        Cookie cookieObj            = new Cookie('facebookCode', code, null, 100, false);
        Cookie cookieLoginTypeObj   = new Cookie('loginType', 'fbLogin', null, 86400, false);
        Cookie mSite 				= new Cookie('mentorSite',isMentorshipSite == true ? 'true' : 'false', null, 100, false);
        Cookie aSite 				= new Cookie('applicSite',isApplicationSite == true ? 'true' : 'false', null, 100, false);
        
         Cookie cookiehashObj    = new Cookie('hashCodeLog', '', null, 0, false);
        Cookie cookiefbObj      = new Cookie('fbSessionId', '', null, 0, false);
        Cookie cookieGoogleObj  = new Cookie('googleSessionId', '', null, 0, false);
        Cookie cookiePrlmObj  = new Cookie('cookieEncStudent', '', null, 0, false);
        system.debug('code'+code);
        system.debug('isMentorshipSite'+isMentorshipSite);
        PageReference MyNewPage     = Page.RedirectToFBProfilePage;
        
        MyNewPage.setCookies(new Cookie[]{cookieObj, cookieLoginTypeObj, mSite,aSite,cookiehashObj, cookiefbObj, cookieGoogleObj, cookiePrlmObj});
        
        MyNewPage.setRedirect(true);
        return MyNewPage;
    }
    
    /* 
* @purpose: Check Authorized user. If not redirect the user to login Page.
*/
    public PageReference checkUserAuth(){
        isMentorExist=false;
        
        system.debug('currentUserId----'+currentUserId);
        PageReference pg   = new PageReference('/'); 
        string encStudentId   = Apexpages.currentPage().getParameters().get('encStudentId');
        string hashCode     = Apexpages.currentPage().getParameters().get('d');  
        
        system.debug('hashCode===>'+hashCode + 'enc StudentId====>'+encStudentId);  
        system.debug('currentUserId----'+currentUserId);
        if(encStudentId != null){
            currentUserId          = DN_CCAvenue_Service.decryptString(encStudentId, DN_ServiceConstants.DN_ORDER_KEY);
            Cookie cookieEncStudent   = new Cookie('cookieEncStudent', currentUserId, null, 86400, false);
            ApexPages.currentPage().setCookies(new Cookie[]{cookieEncStudent});            
        }
        system.debug('currentUserId----'+currentUserId);
        if(hashCode != null){
            system.debug('hashcode not null');
            getContactId(hashCode);
            Cookie cookiehashCode   = new Cookie('hashCodeLog', currentUserId, null, 1800, false);
            ApexPages.currentPage().setCookies(new Cookie[]{cookiehashCode});
        }
        
        if(currentUserId == null){
            Cookie encStd = ApexPages.currentPage().getCookies().get('cookieEncStudent');
            system.debug('encStd==>'+encStd);
            if(encStd != null) currentUserId = encStd.getValue();
            if(currentUserId != null){
                system.debug('currentUserId not null');
                Cookie cookieEncDonor   = new Cookie('cookieEncStudent', currentUserId, null, 86400, false);
                ApexPages.currentPage().setCookies(new Cookie[]{cookieEncDonor}); 
            }            
        }
        System.debug('currentUserId-----'+currentUserId);
        
        if(currentUserId == null){
            System.debug('currentUserId-----'+currentUserId);
            Cookie chashcode = ApexPages.currentPage().getCookies().get('hashCodeLog');
            System.debug('chashcode-----'+currentUserId);
            if(chashcode != null) currentUserId    = chashcode.getValue();
            if(currentUserId != null){
                Cookie cookiehashCode   = new Cookie('hashCodeLog', currentUserId, null, 1800, false);
                ApexPages.currentPage().setCookies(new Cookie[]{cookiehashCode});
            }          
        }
        System.debug('currentUserId-----'+currentUserId);
        System.debug('currentUserId'+currentUserId);
        if(currentUserId == null || currentUserId==''){
            Cookie logType = ApexPages.currentPage().getCookies().get('loginType');
            system.debug('loginid::'+logType);
            if(logType != null){
                system.debug('logType.getValue() -----'+logType.getValue());
                if(logType.getValue()   == 'googleLogin'){
                    try{
                        recordType = '';
                        checkGoogleAuth();
                        system.debug('registrationFromGoogle');
                        System.debug(ApexPages.currentPage().getCookies());
                        if(ApexPages.currentPage().getCookies().get('mentorSite').getValue() == 'true') {
                            isMentorshipSite = true;
                            System.debug('google from mentorship');
                            return null;
                        }
							
                    }catch(Exception e){
                        
                        system.debug('pg'+pg);
                        return pg;
                    }
                }
                if(logType.getValue()   == 'fbLogin'){
                    try{
                        recordType = '';
                        system.debug('checkFacebookAuth----');
                        checkFacebookAuth();  
                        system.debug('recordType-----'+recordType);
                        system.debug('applicSite------'+ApexPages.currentPage().getCookies().get('applicSite').getValue());
                        if(ApexPages.currentPage().getCookies().get('mentorSite').getValue() == 'true') {
                            isMentorshipSite = true;
                            System.debug('facebook from mentorship');
                            return null;
                        }
                        if(ApexPages.currentPage().getCookies().get('applicSite').getValue() == 'true') {
                             isApplicationSite = true;
                            System.debug('facebook from Application');
                            return null;
                        }
                    }catch(Exception e){
                        system.debug('exception '+e.getMessage()+'line no '+e.getLineNumber());
                        return pg;
                    }
                }
                
            }else{
                return pg;
            }
        }
        
        // If current user is not an authorized user 
        // then redirect to login page
        if(currentUserId == null) return pg;
        
        return null;
    }
    public PageReference alreadyRegistered() {
        
        PageReference redirect = new PageReference(Constants.MENTOR_MENTEE_SITE_URL);
        redirect.setRedirect(true);
        return redirect;
    }
    // Get Current user emails by validating with Google APIs and check if 
    // logged in user's email exist in the system or not. 
    public void checkGoogleAuth(){
        String authCode ;   
        
        Cookie lkcode = ApexPages.currentPage().getCookies().get('googleCode');
        system.debug('checkFacebookAuth applicSite------'+ApexPages.currentPage().getCookies().get('applicSite').getValue());
        system.debug('checkFacebookAuth mentorSite------'+ApexPages.currentPage().getCookies().get('mentorSite').getValue());
		string isMentorSite = ApexPages.currentPage().getCookies().get('mentorSite').getValue();
        string isApplicSite = ApexPages.currentPage().getCookies().get('applicSite').getValue();
        if(lkcode != null){
            code = lkcode.getValue();
            Cookie cookiegObj   = new Cookie('googleCode', '', null, 100, false);
            ApexPages.currentPage().setCookies(new Cookie[]{cookiegObj});
        }
        if(String.isBlank(code)){
            Cookie gSessId = ApexPages.currentPage().getCookies().get('googleSessionId');
            if(gSessId != null){
                authCode = gSessId.getValue();
            }
        }
        if(!String.isBlank(code)){
            System.debug('---'+ApexPages.currentPage().getCookies().get('mentorSite').getValue());
            if(ApexPages.currentPage().getCookies().get('mentorSite').getValue() == 'true')
	            authCode = LoginAuthentication_Helper.getGoogleAuthCode(code,LoginAuthentication_Helper.MENTORSHIP_SITE);
            else
                authCode = LoginAuthentication_Helper.getGoogleAuthCode(code,LoginAuthentication_Helper.APPLICATION_SITE);
            //authCode = GoogleAuthService.getAccessToken(code);
            system.debug('AuthCode'+AuthCode);
        }
        if(!String.isBlank(authCode)){
            if(!authCode.equalsIgnoreCase(Constants.ERROR_MESSAGE)){
                GooglePublicDetailsClass.GoogleDetails gResp   = LoginAuthentication_Helper.getGoogleEmail(authCode);
                System.debug(gResp);
                if(gResp != null){
                    gFirstName = gResp.firstName;
                    gLastName = gResp.lastName;
                    system.debug('--- Fname'+gFirstName+'Lname'+gLastName);
                    gemailId = gResp.email;
                    if(!String.isBlank(gemailId)){
                        try{
                            Id conStdRecordTypeId      = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId();
                            system.debug('--- conStdRecordTypeId'+conStdRecordTypeId);
                            Id conFacRecordTypeId      = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_FACILITAtOR).getRecordTypeId();
                            system.debug('--- conFacRecordTypeId'+conFacRecordTypeId);
                            Id manRecordTypeId      = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_Mentor).getRecordTypeId();
                            system.debug('--- manRecordTypeId'+manRecordTypeId);
                            Contact[] currentUser;
                            //currentUser     = [Select id,Internal_Status__c,RecordTypeId,RecordType.developerName from Contact where (Email =:gemailId OR Google_login_ID__c =:gemailId) and (RecordTypeId=:conStdRecordTypeId OR RecordTypeId=:conFacRecordTypeId OR RecordTypeId=:manRecordTypeId)];
                            if(isMentorSite == 'true'){
                                currentUser     = [Select id,Internal_Status__c,RecordTypeId,Rejection_Reason__c,RecordType.developerName from Contact where (Email =:gemailId OR Facebook_login_ID__c =:gemailId) and (RecordTypeId=:manRecordTypeId OR RecordTypeId=:conStdRecordTypeId)]; 
                            }
                            if(isApplicSite == 'true'){
                                currentUser     = [Select id,Internal_Status__c,Rejection_Reason__c,RecordTypeId,RecordType.developerName from Contact where (Email =:gemailId OR Facebook_login_ID__c =:gemailId) and (RecordTypeId=:conStdRecordTypeId OR RecordTypeId=:conFacRecordTypeId)];
                            }
                            System.debug('--- user'+currentUser);
                            if (currentUser.size() > 0){
                                recordType              = currentUser[0].RecordType.developerName;
                                system.debug('--- recordType'+recordType);
                                if(recordType == label.FFE_DONOR_STUDENT){
                                    if(recordType == label.FFE_DONOR_STUDENT){
                                        Contact contact=new Contact();
                                        contact.Login_Hash_Code__c=Utility.generateRandomString();
                                        hasCodeUpdate=contact.Login_Hash_Code__c;
                                        contact.id=currentUser[0].id;
                                        update contact;
                                        System.debug('LOGIN HASHCODE===>'+contact.Login_Hash_Code__c);
                                    }
                                    
                                  /*  if((currentUser[0].Internal_Status__c != System.Label.ScholarshipInternalStatusIneligible)
                                       && (currentUser[0].Internal_Status__c != System.Label.ScholarshipInternalStatusEligible)){
                                           currentUserId           = currentUser[0].Id;   
                                       }   */
                                    currentUserId           = currentUser[0].Id;
                                    InternalStatus   		= currentUser[0].Internal_Status__c;
                                    if(currentUser[0].Internal_Status__c == System.Label.ScholarshipInternalStatusIneligible){
                                        rejectReason = currentUser[0].Rejection_Reason__c;
                                    }
                                }else if(recordType == Constants.FFE_Mentor){
                                    if(currentUser[0].Id != null){
                                        isMentorExist=true;
                                        System.debug('isMentorExist---->'+isMentorExist);
                                        system.debug('Record is already in the Database');
                                        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, 'error');
                                        Error = 'Record is already in the Database!! Do kindly login Through the Login Page';
                                        ApexPages.addMessage(msg);
                                        return ;
                                    }else{
                                        currentUserId           = currentUser[0].Id;  
                                    }
                                }
                                else if(recordType==Constants.FFE_Donor_Facilitator){
                                    Contact contact=new Contact();
                                    contact.Login_Hash_Code__c=Utility.generateRandomString();
                                    hasCodeUpdate=contact.Login_Hash_Code__c;
                                    contact.id=currentUser[0].id;
                                    update contact;
                                    System.debug('LOGIN HASHCODE===>'+contact.Login_Hash_Code__c);
                                     currentUserId           = currentUser[0].Id;  
                                    System.debug('Record already in database');
                                    
                                }
                                Cookie cookieObj1 = new Cookie('googleSessionId', authCode, null, 3600, false);
                                ApexPages.currentPage().setCookies(new Cookie[]{cookieObj1});
                                return ;
                            }
                            
                            else{
                                if(ApexPages.currentPage().getCookies().get('mentorSite').getValue()=='true'){
                                    recordType = 'Mentor';
                                    isMentorExist=false;
                                    system.debug('This record is not in the Database');
                                    /*Error = 'This record is not in the Database';
									ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, 'error');
                                    ApexPages.addMessage(msg);
                                    return ;    */
                                }
                                else{
                                isMentorExist=false;
                                recordType = '';
                                system.debug('This record is not in the Database');
                                Error = 'This record is not in the Database';
                                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, 'error');
                                ApexPages.addMessage(msg);
                                return ;
                                }
                            }
                            
                        }catch(Exception e){
                            HandleBusinessException.captureError('AP_Application_CTRL', 'checkGoogleAuth', e);
                            system.debug(e.getMessage()+'at'+e.getLineNumber());
                        }
                    }
                }
            }
        }
    }
    
    public void checkFacebookAuth(){
        isMentorExist=false;
        String authCode ;        
        Cookie lkcode = ApexPages.currentPage().getCookies().get('facebookCode');
        system.debug('checkFacebookAuth applicSite------'+ApexPages.currentPage().getCookies().get('applicSite').getValue());
        system.debug('checkFacebookAuth mentorSite------'+ApexPages.currentPage().getCookies().get('mentorSite').getValue());
		string isMentorSite = ApexPages.currentPage().getCookies().get('mentorSite').getValue();
        string isApplicSite = ApexPages.currentPage().getCookies().get('applicSite').getValue();
        if(lkcode != null){
            code = lkcode.getValue();
            Cookie cookiefObj   = new Cookie('facebookCode', '', null, 100, false);
            ApexPages.currentPage().setCookies(new Cookie[]{cookiefObj});
        }
        if(String.isBlank(code)){
            Cookie gSessId = ApexPages.currentPage().getCookies().get('fbSessionId');   
            if(gSessId != null){
                authCode = gSessId.getValue();
            }
        }
        system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@code'+code);
        if(!String.isBlank(code)){
            System.debug('---'+ApexPages.currentPage().getCookies().get('mentorSite').getValue());
            System.debug('---'+ApexPages.currentPage());
            if(ApexPages.currentPage().getCookies().get('mentorSite').getValue() == 'true'){
                system.debug('code'+code+'LoginAuthentication_Helper.APPLICATION_SITE'+LoginAuthentication_Helper.APPLICATION_SITE);
                authCode = LoginAuthentication_Helper.getFBAuthCode(code,LoginAuthentication_Helper.MENTORSHIP_SITE);
            }
            else{
                authCode = LoginAuthentication_Helper.getFBAuthCode(code,LoginAuthentication_Helper.APPLICATION_SITE);
                system.debug('AuthCode'+AuthCode);
            }   
        }

        if(!String.isBlank(authCode)){
            String fbEmail  = LoginAuthentication_Helper.getFacebookEmail(authcode);
            FbId            = fbEmail;
            name            = FacebookAuthHandler.name;
            system.debug(fbEmail);
            system.debug(name);
            if(!String.isBlank(fbEmail)){
                
                try{
                    Id conStdRecordTypeId      = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId();
                    system.debug('conStdRecordTypeId'+conStdRecordTypeId);
                    Id conFacRecordTypeId      = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_FACILITAtOR).getRecordTypeId();
                    system.debug('conFacRecordTypeId'+conFacRecordTypeId);
                    Id manRecordTypeId      = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_Mentor).getRecordTypeId();
                    system.debug('manRecordTypeId'+manRecordTypeId);
                    system.debug('fbEmail------'+fbEmail);
                    system.debug('currentUser isMentorshipSite---------'+isMentorshipSite);
                    system.debug('currentUser isApplicationSite---------'+isApplicationSite);
                    Contact[] currentUser;
                    //currentUser     = [Select id,Internal_Status__c,RecordTypeId,RecordType.developerName from Contact where (Email =:fbEmail OR Facebook_login_ID__c =:fbEmail) and (RecordTypeId=:conStdRecordTypeId OR RecordTypeId=:conFacRecordTypeId OR RecordTypeId=:manRecordTypeId)];
                    if(isMentorSite == 'true'){
                       currentUser     = [Select id,Internal_Status__c,RecordTypeId,RecordType.developerName from Contact where (Email =:fbEmail OR Facebook_login_ID__c =:fbEmail) and (RecordTypeId=:manRecordTypeId OR RecordTypeId=:conStdRecordTypeId)]; 
                    }
                    if(isApplicSite == 'true'){
                     	currentUser     = [Select id,Internal_Status__c,RecordTypeId,RecordType.developerName from Contact where (Email =:fbEmail OR Facebook_login_ID__c =:fbEmail) and (RecordTypeId=:conStdRecordTypeId OR RecordTypeId=:conFacRecordTypeId)];
                    }
                    
                    if (currentUser.size() > 0){
                        recordType              = currentUser[0].RecordType.developerName;
                        system.debug('recordType'+recordType);
                        if(recordType == label.FFE_DONOR_STUDENT){
                            System.debug('FBEMAIL  '+fbEmail);
                            Contact contact=new Contact();
                            contact.Login_Hash_Code__c=Utility.generateRandomString();
                            hasCodeUpdate=contact.Login_Hash_Code__c;
                            contact.id=currentUser[0].id;
                            update contact;
                            System.debug('LOGIN HASHCODE===>'+contact.Login_Hash_Code__c);
                        }
                        if(recordType == label.FFE_DONOR_STUDENT){
                           /* if((currentUser[0].Internal_Status__c != System.Label.ScholarshipInternalStatusIneligible)
                               && (currentUser[0].Internal_Status__c != System.Label.ScholarshipInternalStatusEligible)){
                                   currentUserId           = currentUser[0].Id; 
                                   
                               }    */
                            currentUserId           = currentUser[0].Id; 
                            if(currentUser[0].Internal_Status__c == System.Label.ScholarshipInternalStatusIneligible){
                            	rejectReason = currentUser[0].Rejection_Reason__c;
                            }
                        }else if(recordType == Constants.FFE_Mentor){
                            
                            if(currentUser[0].Id != null){
                                isMentorExist=true;
                                System.debug('isMentorExist---->'+isMentorExist);
                                system.debug('Record is already in the Database');
                                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, 'error');
                                Error = 'Record is already in the Database!! Do kindly login Through the Login Page';
                                ApexPages.addMessage(msg);
                                return ;
                            }else{
                                currentUserId           = currentUser[0].Id;  
                            }
                        }
                        else if(recordType==Constants.FFE_Donor_Facilitator){
                            Contact contact=new Contact();
                            contact.Login_Hash_Code__c=Utility.generateRandomString();
                            hasCodeUpdate=contact.Login_Hash_Code__c;
                            contact.id=currentUser[0].id;
                            update contact;
                            System.debug('LOGIN HASHCODE===>'+contact.Login_Hash_Code__c);
                            currentUserId           = currentUser[0].Id;  
                            System.debug('Record already in database');
                            
                        }
                        Cookie cookieObj1 = new Cookie('googleSessionId', authCode, null, 3600, false);
                        ApexPages.currentPage().setCookies(new Cookie[]{cookieObj1});
                        return ;
                    }else{
                        
                        System.debug('record Type'+recordType);
                        System.debug('isMentorShip'+isMentorshipSite);
                        if(ApexPages.currentPage().getCookies().get('mentorSite').getValue()=='true'){
                            recordType = 'Mentor';
                            isMentorExist=false;
                            System.debug('recordType'+recordType);
                            system.debug('This record is not in the Database');
                            /*Error = 'This record is not in the Database';
                            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, 'error');
                            ApexPages.addMessage(msg);
                            return ;    */
                        }
                        else{
                            isMentorExist=false;
                            recordType = '';
                            system.debug('This record is not in the Database');
                            Error = 'This record is not in the Database';
                            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, 'error');
                            ApexPages.addMessage(msg);
                            return ;
                        }
                        
                    }
                    
                }
                catch(Exception e){
                    HandleBusinessException.captureError('AP_Application_CTRL', 'checkFacebookAuth', e);
                    system.debug(e.getMessage());
                }
            }
        }
    }
    
    public PageReference logOutUser(){
        string hashCodeLog = ApexPages.currentPage().getCookies().get('hashCodeLog').getValue();
        system.debug('hashCodeLog--'+hashCodeLog);
      	List<contact> conRec = [select name,id,login_Hash_code__c from contact where Id =:hashCodeLog];
        if(conRec.size() >0
          
          
          
          ){
            conRec[0].login_Hash_code__c = '';
            update conRec[0];
        }
        Cookie cookiehashObj    = new Cookie('hashCodeLog', '', null, 0, false);
        Cookie cookiefbObj      = new Cookie('fbSessionId', '', null, 0, false);
        Cookie cookieGoogleObj  = new Cookie('googleSessionId', '', null, 0, false);
        Cookie cookiePrlmObj  = new Cookie('cookieEncStudent', '', null, 0, false);
        ApexPages.currentPage().setCookies(new Cookie[]{cookiehashObj, cookiefbObj, cookieGoogleObj,cookiePrlmObj});
        PageReference pg = new PageReference('/');
        pg.setRedirect(true);
        return pg;
    }
    
    @TestVisible private void getContactId(String hashCode){
        try{
            System.debug('--- hash '+hashCode);
            list<Contact> con      = [Select id,RecordTypeId,RecordType.developerName,Rejection_Reason__c,Internal_Status__c from Contact 
                                where Login_hash_Code__c =: hashCode 
                                AND (RecordType.developerName = :Constants.FFE_DONOR_STUDENT
                                     OR RecordType.developerName = :Constants.FFE_DONOR_FACILITAtOR)];
            if(con.size() > 0){
                recordType              = con[0].RecordType.developerName;
                
                if(recordType == Constants.FFE_DONOR_STUDENT){
                    system.debug('con[0].Internal_Status__c----'+con[0].Internal_Status__c);
                   /* if((con[0].Internal_Status__c != System.Label.ScholarshipInternalStatusIneligible)
                       && (con[0].Internal_Status__c != System.Label.ScholarshipInternalStatusEligible)){
                           currentUserId           = con[0].Id;   
                       }     */    
                    if(con[0].Internal_Status__c == System.Label.ScholarshipInternalStatusIneligible){
                        rejectReason = con[0].Rejection_Reason__c;
                    }
                    InternalStatus   		= con[0].Internal_Status__c;
                    currentUserId           = con[0].Id; 
                }else{
                    currentUserId           = con[0].Id;   
                } 
            }
            
            system.debug('--- currentUserId'+currentUserId);
        }catch(Exception e){HandleBusinessException.captureError('AP_Application_CTRL', 'getContactId', e);}
    }
    
    @TestVisible private void initialize(){
        APGenderPickLstValues  = JSON.serializePretty(Utility.getPicklistValues(Constants.CONTACT_SOBJECT,Constants.SCHOLAR_GENDER)).trim();
        APtypePickLstValues     = JSON.serializePretty(Utility.getPicklistValues(Constants.CONTACT_SOBJECT,Constants.ACADEMIC_TYPE)).trim();
        mediumOfInstruction     = JSON.serializePretty(new List<String>{'English','Hindi','Kannada','Telugu','Tamil','Other'});
        listOfStates            = JSON.serializePretty(Utility.getStates(Constants.COUNTRY_IND));
        studentCourse           = JSON.serializePretty(Utility.getPicklistValues(Constants.CONTACT_SOBJECT,Constants.STUDENT_COURSE)).trim();
        typeOfBankAccounts       = JSON.serializePretty(Utility.getPicklistValues(Constants.CONTACT_SOBJECT,Constants.STUDENT_BANK_ACCOUNT_TYPE)).trim();
        studentBranch           = JSON.serializePretty(Utility.getPicklistValuesforBranchEngMetch(Constants.CONTACT_SOBJECT,Constants.SCHOLAR_BRANCH_FIELD)).trim();
        
        studentLawBranch       = JSON.serializePretty(Utility.getPicklistValuesforBranch(Constants.CONTACT_SOBJECT,Constants.SCHOLAR_BRANCH_FIELD)).trim();
        occupationList        = JSON.serializePretty(Utility.getPicklistValues(Constants.CONTACT_SOBJECT,Constants.OCCUPATION_TYPE)).trim();
        btechYearList          = JSON.serializePretty(new List<String>{'1st Year','2nd Year','3rd Year','4th Year'});
        MtechYearList          = JSON.serializePretty(new List<String>{'1st Year','2nd Year','3rd Year','4th Year','5th Year'});
        MbbsYearList          = JSON.serializePretty(new List<String>{'Year I, Sem 1','Year II, Sem 3','Year II, Sem 5','Year III (Part 1), Sem 7','Year III (Part 2), Sem 9'});
        //MbbsYearList          = JSON.serializePretty(new List<String>{'1st Year','2nd Year','3rd Year (Part 1)','3rd Year (Part 2)','4th Year','5th Year'});
        entranceTests          = JSON.serializePretty(AP_Student_Application_helper.getAllEntranceTestName());  
        gradSystemList      = JSON.serializePretty(Utility.getPicklistValues(Constants.APPLICATION_SOBJECT,Constants.GRADING_SYSTEM_FIELD_API)).trim();
        isRenewalAvailable    = AP_Application_Helper.displayRenewalApp();
        errMsg          = Constants.ERROR_MSG;
        prelimFiles        = JSON.serializePretty(AP_Application_Helper.getPrelimFiles());
        renewalFiles      = JSON.serializePretty(AP_Application_Helper.getRenewalFiles());
        appSuccess        = Constants.APPLICATION_SUCESS_MSG;
        donorLogoDescription    = System.label.Donor_Logo_Description;
        placementOptions        = JSON.serializePretty(new List<String>{'Placed','Not Placed','Seeking Govt. Jobs','Seeking Entreprenuership','Higher Studies','Others'});
        studentResumeUpload     = system.label.Student_Resume_Upload;
        finalYearMarksnoti      = system.label.Final_year_marks_detail;
        finalYearOddSem         = 'Odd Semester Mark Sheet of Final year';
        finalYearEvenSem        = 'Even Semester Mark Sheet of Final year';
        currentFinancialYear    = Utility.financialYear();
        accomTypesList      = JSON.serializePretty(Utility.getPicklistValues(Constants.CONTACT_SOBJECT,Constants.ACCOMODATION_TYPE)).trim();
        try{
            maxAttchmentSize  = Integer.valueOf(Utility.getSystemDetails().Max_Attachment_Size__c)*1024;
        }catch(Exception ex){
            maxAttchmentSize  = 256000;
        }
    }
    public class RenewalWrapper {
        public Contact scholar;
        public Application__c ScholarAppln;
        
        public RenewalWrapper(){
            scholar         = new Contact();
            ScholarAppln    = new Application__c();
        }
    }
    
    //Wrapper for Facilitator students filtering
    public class FacStudentsWrapper {
        public List<Contact> toBeProcessed = new List<Contact> ();
        public List<Contact> completed = new List<Contact> ();
    }
}