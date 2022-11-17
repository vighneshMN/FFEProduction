public class SendEmailNotification {
    // method will accept map of contact id and email template name
    public static void sendEmailToIndividuals(set<Id> conId, String emailTempName) { //Map<id, String> emailTempMap
        try{
            system.debug('emailTempName'+emailTempName);
            system.debug('conId'+conId);
            list<Contact> contactRec = [select name,id,FirstName,Email,Phone,Employer_Name__c,Is_Mentor__c,Designation__c,is_Mentee__c,RecordTypeId,Location__c,College_Name__c,College_Location__c,Branch_Stream__c from Contact where Id in :conId];
            system.debug('contactRec==>'+contactRec);            
            EmailTemplate et=[Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where Name =: emailTempName];
            System.debug('et.Id==>'+et.Id);
            system.debug('et==>'+et);
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            
            for (Contact contact : contactRec) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                       
                List<String> recipients = new List<String>();
                recipients.add(contact.Email);
                system.debug('recipients------'+recipients);
                mail.setToAddresses(recipients);
                mail.setSenderDisplayName('FFE Mentoring Team');
                
                String subject = et.Subject;
                system.debug('subject==>'+subject);
                String htmlBody = et.HtmlValue;
                if(contact.is_Mentee__c == true){
                    if( contact.Name != null){
                        htmlBody = htmlBody.replace('{!Mentee.Name}', contact.Name);
                    }
                    if( contact.Phone != null){
                        htmlBody = htmlBody.replace('{!Mentee.Phone}', contact.Phone); 
                    }
                    if( contact.Email != null){
                        htmlBody = htmlBody.replace('{!Mentee.Email}', contact.Email);
                    }
                    if( contact.College_Name__c != null){
                        htmlBody = htmlBody.replace('{!Mentee.College}', contact.College_Name__c);
                    }
                    if( contact.College_Location__c != null){
                        htmlBody = htmlBody.replace('{!Mentee.CollegeLocation}', contact.College_Location__c);
                    }
                    if( contact.Branch_Stream__c != null){
                        htmlBody = htmlBody.replace('{!Mentee.BranchOfStudy}', contact.Branch_Stream__c);
                    }
                }
               else if(contact.Is_Mentor__c == True){
                    if( contact.Name != null){
                        htmlBody = htmlBody.replace('{!Mentor.Name}', contact.name); 
                    }
                    if( contact.Phone != null){
                        htmlBody = htmlBody.replace('{!Mentor.Phone}', contact.Phone); 
                    }
                    if( contact.Email != null){
                        htmlBody = htmlBody.replace('{!Mentor.Email}', contact.Email); 
                    }
                    if( contact.Employer_Name__c != null){
                        htmlBody = htmlBody.replace('{!Mentor.EmployerName}', contact.Employer_Name__c); 
                    }
                    if( contact.Location__c != null){
                        htmlBody = htmlBody.replace('{!Mentor.Designation}', contact.Designation__c);
                    }
                    if( contact.Location__c != null){
                        htmlBody = htmlBody.replace('{!Mentor.Location}', contact.Location__c);         
                    }
                    
                }
               
                system.debug('htmlBody==>'+htmlBody);
                mail.setSubject(subject);
                mail.setHtmlBody(htmlBody);
                
                mails.add(mail);
            }
            System.debug('mails==>'+mails);
            system.debug('mails.size()==>'+mails.size());
            Messaging.sendEmail(mails);
        }catch(Exception e){
            System.debug('Error Line==>'+e.getLineNumber()+'Error Message==>'+e.getMessage());
        }
        
    }
}