global class StudentCgpaForm_Controller {
    
    
    @RemoteAction
    public static StudentCgpaForm_wrap getStudentDetails(string studentId){
        try{
            contact conRec = [select name,Id,Current_year__c,FFE_ID__c,Course__c,Semester1__c,Semester2__c,Semester3__c,Semester4__c,Semester5__c,Semester6__c,Semester7__c,Semester8__c,Semester9__c,Semester10__c,MBBS_Year_1__c,MBBS_Year_2__c,MBBS_Year_3_Part_1__c,MBBS_Year_3_Part_2__c from contact where Login_Hash_Code__c =:studentId ];
            system.debug(conRec.Current_year__c +'-------------'+conRec.Course__c);
            if(conRec.Current_year__c != null && conRec.Course__c != null ){
                string currentYear = conRec.Current_year__c ; 
                string course = conRec.Course__c ;
                CGPA_Collection_Data__mdt cgpaMetadata = [select label,Course__c,Current_Year__c,Field_API_Name__c from CGPA_Collection_Data__mdt where Current_Year__c =:currentYear AND Course__c =:course LIMIT 1];
                
                if(cgpaMetadata.Field_API_Name__c != null){
                    List<String> lstOfApiNames = cgpaMetadata.Field_API_Name__c.split(',');
                    
                    String type='Contact';
                    
                    Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                    Schema.SObjectType leadSchema = schemaMap.get(type);
                    Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
                    
                    StudentCgpaForm_wrap studentCgpadetails = New StudentCgpaForm_wrap ();
                    studentCgpadetails.conRec = conRec;
                    list<CgpaFormData_wrap> cgpaDataList = new list<CgpaFormData_wrap>();
                    for(string names:lstOfApiNames){
                        CgpaFormData_wrap cgpaData = new CgpaFormData_wrap();
                        cgpaData.label = string.valueof(fieldMap.get(names).getDescribe().getLabel());
                        cgpaData.apiName = names;
                        //cgpaData.finalAnswer = '';  
                        cgpaDataList.add(cgpaData);
                    }
                    studentCgpadetails.dataWrapper =  cgpaDataList;
                    Return studentCgpadetails;
                }
            }
        }catch(exception e){
            system.debug('eeee'+e.getLineNumber()+'exceptoion===='+e.getMessage());
        }
        
        
        return null;
    }
    
    @RemoteAction
    public static void submitCgpaData(list<CgpaFormData_wrap> cgpaDataToInsert, string conId){
        system.debug('CgpaFormData_wrap==>'+cgpaDataToInsert);
        contact con = new contact();
        con.Id = conId;
        con.Login_Hash_Code__c = '';
        for(CgpaFormData_wrap cgpaData:cgpaDataToInsert){
            if(cgpaData.apiName == 'Semester1__c'){
             	 if(cgpaData.finalAnswer != null ){
                    con.Semester1__c = decimal.valueOf(cgpaData.finalAnswer);
                }else{
                    con.Semester1__c = decimal.valueOf(cgpaData.finalAnswerPercentage);
                }   
            }
            if(cgpaData.apiName == 'Semester2__c'){
             	 if(cgpaData.finalAnswer != null ){
                    con.Semester2__c = decimal.valueOf(cgpaData.finalAnswer);
                }else{
                    con.Semester2__c = decimal.valueOf(cgpaData.finalAnswerPercentage);
                }   
            }
            if(cgpaData.apiName == 'Semester3__c'){
             	 if(cgpaData.finalAnswer != null ){
                    con.Semester3__c = decimal.valueOf(cgpaData.finalAnswer);
                }else{
                    con.Semester3__c = decimal.valueOf(cgpaData.finalAnswerPercentage);
                }   
            }
            if(cgpaData.apiName == 'Semester4__c'){
             	 if(cgpaData.finalAnswer != null ){
                    con.Semester4__c = decimal.valueOf(cgpaData.finalAnswer);
                }else{
                    con.Semester4__c = decimal.valueOf(cgpaData.finalAnswerPercentage);
                }   
            }
            if(cgpaData.apiName == 'Semester5__c'){
             	 if(cgpaData.finalAnswer != null ){
                    con.Semester5__c = decimal.valueOf(cgpaData.finalAnswer);
                }else{
                    con.Semester5__c = decimal.valueOf(cgpaData.finalAnswerPercentage);
                }   
            }
            if(cgpaData.apiName == 'Semester6__c'){
             	 if(cgpaData.finalAnswer != null ){
                    con.Semester6__c = decimal.valueOf(cgpaData.finalAnswer);
                }else{
                    con.Semester6__c = decimal.valueOf(cgpaData.finalAnswerPercentage);
                }   
            }
            if(cgpaData.apiName == 'Semester7__c'){
             	 if(cgpaData.finalAnswer != null ){
                    con.Semester7__c = decimal.valueOf(cgpaData.finalAnswer);
                }else{
                    con.Semester7__c = decimal.valueOf(cgpaData.finalAnswerPercentage);
                }   
            }
            if(cgpaData.apiName == 'Semester8__c'){
             	 if(cgpaData.finalAnswer != null ){
                    con.Semester8__c = decimal.valueOf(cgpaData.finalAnswer);
                }else{
                    con.Semester8__c = decimal.valueOf(cgpaData.finalAnswerPercentage);
                }   
            }
            if(cgpaData.apiName == 'Semester9__c'){
             	 if(cgpaData.finalAnswer != null ){
                    con.Semester9__c = decimal.valueOf(cgpaData.finalAnswer);
                }else{
                    con.Semester9__c = decimal.valueOf(cgpaData.finalAnswerPercentage);
                }   
            }
            if(cgpaData.apiName == 'Semester10__c'){
             	 if(cgpaData.finalAnswer != null ){
                    con.Semester1__c = decimal.valueOf(cgpaData.finalAnswer);
                }else{
                    con.Semester1__c = decimal.valueOf(cgpaData.finalAnswerPercentage);
                }   
            }
            if(cgpaData.apiName == 'MBBS_Year_1__c'){
             	 if(cgpaData.finalAnswer != null ){
                    con.MBBS_Year_1__c = decimal.valueOf(cgpaData.finalAnswer);
                }else{
                    con.MBBS_Year_1__c = decimal.valueOf(cgpaData.finalAnswerPercentage);
                }   
            }
            if(cgpaData.apiName == 'MBBS_Year_2__c'){
             	 if(cgpaData.finalAnswer != null ){
                    con.MBBS_Year_2__c = decimal.valueOf(cgpaData.finalAnswer);
                }else{
                    con.MBBS_Year_2__c = decimal.valueOf(cgpaData.finalAnswerPercentage);
                }   
            }
            if(cgpaData.apiName == 'MBBS_Year_3_Part_1__c'){
             	 if(cgpaData.finalAnswer != null ){
                    con.MBBS_Year_3_Part_1__c = decimal.valueOf(cgpaData.finalAnswer);
                }else{
                    con.MBBS_Year_3_Part_1__c = decimal.valueOf(cgpaData.finalAnswerPercentage);
                }   
            }
            if(cgpaData.apiName == 'MBBS_Year_3_Part_2__c'){
             	 if(cgpaData.finalAnswer != null ){
                    con.MBBS_Year_3_Part_2__c = decimal.valueOf(cgpaData.finalAnswer);
                }else{
                    con.MBBS_Year_3_Part_2__c = decimal.valueOf(cgpaData.finalAnswerPercentage);
                }   
            }

        }
        update con;
    }
    
    Webservice static string sendCgpaFormDonor (string conId){
        system.debug('conId-----'+conId);
        list<Donor_Application_Mapping__c> donorAppMappingList = [select name,Id,Student__c,Donor__c from Donor_Application_Mapping__c where Donor__c =:conId];
        set<Id> studentIdList = new set<Id>();
        for(Donor_Application_Mapping__c dam:donorAppMappingList){
            studentIdList.add(dam.Student__c);    
        }
        list<Contact> contactList = new list<Contact>();
        EmailTemplate emailTempRec = new EmailTemplate();
        if(!studentIdList.isEmpty())
        	contactList = [select name,id,FirstName,Email,Phone,Employer_Name__c,Is_Mentor__c,Designation__c,is_Mentee__c,RecordTypeId,Location__c,College_Name__c,College_Location__c,Branch_Stream__c from Contact where Id IN :studentIdList];
        emailTempRec=[Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where Name ='CGPACollectionTemplate'];
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        for (Contact contact : contactList) {
            contact.Login_Hash_Code__c = Utility.generateRandomString();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            List<String> recipients = new List<String>();
            recipients.add(contact.Email);
            system.debug('recipients------'+recipients);
            mail.setToAddresses(recipients);
            
            String subject = emailTempRec.Subject;
            system.debug('subject==>'+subject);
            String htmlBody = emailTempRec.HtmlValue;
                if( contact.Login_Hash_Code__c != null)
                 	htmlBody = htmlBody.replace('{!Contact.Login_Hash_Code__c}', Contact.Login_Hash_Code__c);   
                htmlBody = htmlBody.replace('{!Contact.Name}', contact.Name);
                
            
            
            
            system.debug('htmlBody==>'+htmlBody);
            mail.setSubject(subject);
            mail.setHtmlBody(htmlBody);
            
            mails.add(mail);
        }
        update contactList;
        System.debug('mails==>'+mails);
        system.debug('mails.size()==>'+mails.size());
        Messaging.sendEmail(mails);
        return 'success';
    }
    
    
    Webservice static string sendCgpaFormApplication (string appId){
        
        Application__c appRec = [select name,Id,student__c from Application__c where Id =: appId];
        if(appRec != null){
            contact contact = [select name,id,FirstName,Email,Phone,Employer_Name__c,Is_Mentor__c,Designation__c,is_Mentee__c,RecordTypeId,Location__c,College_Name__c,College_Location__c,Branch_Stream__c from Contact where Id =:appRec.student__c ];
            if(contact != null){
                contact.Login_Hash_Code__c = Utility.generateRandomString();
                update contact;
            }          
            EmailTemplate emailTempRec =[Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where Name ='CGPACollectionTemplate'];
         
        
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            // Set recipients to two contact IDs.
            // Replace IDs with valid record IDs in your org.
            message.toAddresses = new String[] {contact.Id};
                message.optOutPolicy = 'FILTER';
            message.subject = emailTempRec.Subject;
            String htmlBody = emailTempRec.HtmlValue;
            htmlBody = htmlBody.replace('{!Contact.Login_Hash_Code__c}', Contact.Login_Hash_Code__c);   
            htmlBody = htmlBody.replace('{!Contact.Name}', contact.Name);
            message.setHtmlBody(htmlBody);
            Messaging.SingleEmailMessage[] messages = 
                new List<Messaging.SingleEmailMessage> {message};
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            if (results[0].success) {
                System.debug('The email was sent successfully.');
                return 'successfully sent';
            } else {
                System.debug('The email failed to send: '
                             + results[0].errors[0].message);
                return 'Some Error';
            }

        }
        	
        return 'Error';
    }
    
    @AuraEnabled
    public static string sendCgpaFormApplicationLWC(string targetRecordId){
        return sendCgpaFormApplication(targetRecordId);
    }

    @AuraEnabled(cacheable=true) 
    public static Application__c getRecordDetails(string appId){
       return [select name,id from Application__c where id=:appId];
    }

    public class StudentCgpaForm_wrap{
        public contact conRec;
        // public map<string, string> apiNameXlabel;
        public list<CgpaFormData_wrap> dataWrapper ;
    }
    
    public class CgpaFormData_wrap{
        public string label;
        public string apiName;
        public string finalAnswer;
        public string finalAnswerPercentage;
    }
}