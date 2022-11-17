Global class StudentbankDetails_Controller {
    
    
    public string studentDetails {get;set;}
    public Boolean isError 		{get;set;}
    public application__c application {get;set;}
    static final String DEFAULT_FILE_NAME = 'Copy of First Sheet of Bank Pass Book or Cancelled Cheque';
    static final String FILE_NAME_FORMAT = '_Copy_of_First_Sheet_of_Bank_Pass_Book_or_Cancelled_Cheque_FY';
    static final String ERROR_MSG = 'Something went wrong';
    static final String EMAIL_SUCCESS = 'SUCCESS';
    static final String PASSBOOK_DETAILS_TEMPLATE_NAME = 'Student_Passbook_Details';
    
    
    public string accountType {get;set;}
    
    public StudentbankDetails_Controller() {
        isError = false;
        accountType = JSON.serialize(picklist_values('Contact','Type_Of_Bank_Account__c' ));
        String studentId = Apexpages.currentpage().getparameters().get('id');
        if(!String.isBlank(studentId) && (studentId instanceOf Id)) {
            studentDetails = JSON.serialize([select Name,FFE_ID__c,id,Active_Application_ID__c,Bank_Account_Holder_s_Name__c,X11_character_IFSC_Code_of_the_Branch__c,Full_Bank_Account_No_With_all_digits__c,Is_IFSC_Code_Verified__c,Bank_Name__c,Bank_State__c,Bank_City__c,Type_Of_Bank_Account__c,Branch_Address__c,Bank_Pincode__c,Bank_Branch_Phone_No__c,Other_Type_Bank_Account__c,(select name,id,Application_Type__c,Application_Stage__c from Applications__r) from contact where Id =:studentId]);
            if(studentDetails != null) {
                
            }
        }else {
            isError = true;
        }
    }
    
    @RemoteAction
    public static void updateStudentDetails(contact conRec) {
        try{
            system.debug(conRec);
            update conRec;
        }catch(exception e){
            system.debug('line---'+e.getLineNumber()+'-----'+e.getMessage());
        }
        
    }
    
    
    public static Attachment getAttachment(String attId) {
        list<Attachment> attachments = [SELECT Id, Body
                                        FROM Attachment 
                                        WHERE Id =: attId];
        if(attachments.isEmpty()) {
            Attachment a = new Attachment();
            return a;
        } else {
            return attachments[0];
        }
    }
    
    @RemoteAction
    public static string doUploadAttachment(String appId, String attachmentBody, String attachmentName, String attachmentId) {
        try{
             system.debug('appId.length()---'+appId.length());
            if(!String.isBlank(appId) && attachmentBody != null) {

                Attachment att = New Attachment();
                String newBody = '';
                if(!string.isBlank(attachmentId)){
                    att = getAttachment(attachmentId); 
                    if(att.Body != null) {
                        newBody = EncodingUtil.base64Encode(att.Body);
                    }
                }else{
                    list<Attachment> AttList = [select name,id,parentId,Body from Attachment where name = 'Copy of First Sheet of Bank Pass Book or Cancelled Cheque.Pdf' AND ParentId =:appId];
                    
                    if(AttList.size() > 0){
                        system.debug('inside if pert:::');
                        att.Id  = AttList[0].Id;
                        att.Name = 'Copy of First Sheet of Bank Pass Book or Cancelled Cheque.Pdf';
                        att.ContentType = 'application/pdf';
                        att.Description = 'Uploaded for Scholar';
                    }else{
                        system.debug('inside else pert:::');
                        att.Name = 'Copy of First Sheet of Bank Pass Book or Cancelled Cheque.Pdf';
                        att.parentId = appId;
                        att.ContentType = 'application/pdf';
                        att.Description = 'Uploaded for Scholar';
                    }
                    
                }
                
                
                system.debug('att----'+att);
                
                newBody += attachmentBody;
                att.Body = EncodingUtil.base64Decode(newBody);
                if(attachmentId == null) {
                    system.debug('attachmentId--- null');
                    
                }
                upsert att;
                return att.Id; 
            } 
            return null;
        }catch(exception e){
            system.debug('line---'+e.getLineNumber()+'----'+e.getMessage());
            system.debug('line---'+e.getLineNumber()+'----'+e.getStackTraceString());
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
    
    @RemoteAction
    public static string ifscCodeResponse(String code,String studentId){
        String str; 
        boolean boolInternalCall = false;
        try{ 
            str = Utility.ifscCodeResponse(code,boolInternalCall);
            //update new Contact(Id=studentId,Is_IFSC_Code_Verified__c =boolFlag);
        }
        catch(Exception objException){
            HandleBusinessException.captureError('StudentbankDetails_Controller', 'ifscCodeResponse', objException);
            str = '';
        }
        return str;
    }
    
    
    
    @Testvisible private static string sendEmail(string targetRecordId, String templateId){
        try{
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<OrgWideEmailAddress> owa = new List<OrgWideEmailAddress>();
            try{
                owa =[select id,displayName,Address from OrgWideEmailAddress where displayName=:System.label.Foundation_For_Excellence Limit 1];
                system.debug('owa---'+owa);
                if(owa.size()>0)
                    mail.setOrgWideEmailAddressId(owa[0].id);
                else
                    mail.setSenderDisplayName(Constants.FFE_NAME);
            }
            catch(Exception e){
            }
            system.debug('0031e000005AfZT----'+targetRecordId);
            mail.setTargetObjectId(targetRecordId); 
            mail.setTemplateId(templateId); 
            mail.setSaveAsActivity(false);
            //mail.setWhatId('0031e000005AfZT');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
            return EMAIL_SUCCESS;
        }catch(Exception ex){
            system.debug('message'+ex.getMessage());
            system.debug('line num'+ex.getLineNumber());
            return ERROR_MSG;
        }
    }
    
    Webservice static String sendBankDetailEmail(string targetRecordId){
        
        try{
            EmailTemplate emailTemplate;
            emailTemplate = [SELECT id FROM EmailTemplate WHERE Developername = :PASSBOOK_DETAILS_TEMPLATE_NAME];  
            system.debug('emailTemplate--'+emailTemplate);
            if(emailTemplate != null) {
                if(sendEmail(targetRecordId,emailTemplate.id) == EMAIL_SUCCESS) {
                    
                    return EMAIL_SUCCESS;
                }
            }
            
        }catch(Exception e) {
            System.debug('--- Error message: '+e.getMessage());
        }
        return null;
    }

    @AuraEnabled
    public static String sendBankDetailEmailLWC(string targetRecordId){
        return sendBankDetailEmail(targetRecordId);
    }

    @AuraEnabled(Cacheable=true)
    public static contact getRecordDetails(string contactId){
      return [select name,id from contact where id = :contactId];
    }
    
}