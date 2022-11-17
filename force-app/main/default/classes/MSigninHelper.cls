public class MSigninHelper {
    @RemoteAction
    public static String checkStudentDetails(String Id,String Password,String type){
        
        try{
            String returnMessage = '';
            if(type == 'Mentor'){
                system.debug('Id'+Id);
                String passwordFromDB =[select id,name,password__c from Contact where name=:Id and password__c != null].password__c;
                
                if(passwordFromDB.length() != 0){
                    if(passwordFromDB == Password){
                        returnMessage = 'Congratulations!!You are Logged in as Mentor';
                    }else{
                        returnMessage = 'Sorry!!The Password You entered is wrong!!';
                    }
                }else{
                    returnMessage = 'Sorry!!You are Not registered as Mentor!!';
                }
            }
            else{
                String passwordFromDB =[select id,name,password__c from Contact where name=:Id].password__c;
                if(passwordFromDB.length() != 0){
                    if(passwordFromDB == Password){
                        returnMessage = 'Congratulations!!You are Logged in as Mentee';
                    }else{
                        returnMessage = 'Sorry!!The Password You entered is wrong!!';
                    }
                }else{
                    returnMessage = 'Sorry!!You are Not registered as Mentee!!';
                }
            }
            return returnMessage;
        }
        catch(exception ex){
            System.debug('error.message====>'+ex.getMessage()+'error.getLineNumber===>'+ex.getLineNumber());
            return 'Sorry!!You are Not registered!!';
        }
    }  
    
    @RemoteAction
    public static string menteeLogin(String emailId,String password){
        try{
           /* if(emailId.length() != 0 && ffeuid.length() != 0){
                string checkForMentee = [select name,id,email,FFE_ID__c from contact where email=:emailId AND password__c =:ffeuid AND is_Mentee__c = true].id;
                if(checkForMentee.length() != 0){
                   // return  temporaryMenteeLoginURL(checkForMentee, 'Mentee');
                    contact mentee = new Contact(Id = checkForMentee, Login_Hash_Code__c = Utility.generateRandomString(), Last_Hash_Code_Updated__c = System.now() );
                    
                    update mentee;
                    return mentee.Login_Hash_Code__c;
                }else{
                    return null;
                }              
            }  
            return 'Please enter valid Login Id';  */
            list<contact> checkForMentee = new list<contact>();
            if(emailId.length() != 0 && password.length() != 0){
                checkForMentee = [select name,id,email,password__c from contact where email=:emailId AND is_Mentee__c = True limit 1];  //AND password__c=:password AND
                system.debug(checkForMentee);
                if(checkForMentee != null && !checkForMentee.isEmpty()){
                    if(checkForMentee[0].password__c == password){
                        contact mentor = new Contact(Id = checkForMentee[0].Id, Login_Hash_Code__c = Utility.generateRandomString(), Last_Hash_Code_Updated__c = System.now());
                        
                        update mentor;
                        return mentor.Login_Hash_Code__c;
                    }
                    else{
                            return 'wpassword';
                    }
                }else{
                    return 'nomentee';
                } 

            }
            return 'entervalidcred';
        }catch(exception e){
            system.debug('getLineNumber==='+e.getLineNumber()+'getErroeMessage======'+e.getMessage());
            return e.getMessage();
        }

    }
    
    @RemoteAction
    public static string mentorLogin(String emailId,String password){
        try{
            list<contact> checkForMentor = new list<contact>();
            if(emailId.length() != 0 && password.length() != 0){
                checkForMentor = [select name,id,email,password__c from contact where email=:emailId AND is_Mentor__c = True AND RecordType.DeveloperName = 'Mentor' limit 1];  //AND password__c=:password AND
                system.debug(checkForMentor);
                if(checkForMentor != null && !checkForMentor.isEmpty()){
                    
                   // return  temporaryMenteeLoginURL(checkForMentor, 'Mentor');
                    
                if(checkForMentor[0].password__c == password){
                contact mentor = new Contact(Id = checkForMentor[0].Id, Login_Hash_Code__c = Utility.generateRandomString(), Last_Hash_Code_Updated__c = System.now() );
                
                update mentor;
                return mentor.Login_Hash_Code__c;
                }else{
                    return 'wpassword';
                }
                
                }else{
                    return 'nomentor';
                }  
                
            }
            return 'Please enter valid Login Id';
        }catch(exception e){
            system.debug('getLineNumber==='+e.getLineNumber()+'getErroeMessage======'+e.getMessage());
            return e.getMessage();
        }

    }
    
    @RemoteAction
    public static string menteeRegistration(String menteeId, String menteeEmail){
        try{
            List<Contact> conList = [Select Id,FirstName,LastName,FFE_ID__c,is_Mentee__c,Email,Phone,Aadhar_number__c,What_are_your_top_two_career_goals__c,Gender__c,
                                     Spoken_Languages__c,College_Name__c,College_Location__c,Branch_Stream__c,Modules__c,Login_Hash_Code__c from Contact Where FFE_ID__c =:menteeId AND Email =:menteeEmail ];
            system.debug('conList==>'+conList);
            if(conList.size() !=0){
                if(conList[0].is_Mentee__c == True){
                    return 'alreadyRegistered';
                }  else{
                    	return temporaryMenteeLoginURL(conList[0].id,'MenteeRegistration');
                }  
            }
            else if(conList.size() == 0){
                return null;
            }
            return null;
        }
        catch(exception e){
            system.debug('LineNumber==>'+e.getLineNumber()+'ErrorMessage=====>'+e.getMessage());
            return null;
        }
        
    }
    
    @RemoteAction
    public static string mentorRegistration(String mentorId, String mentorEmail){
        try{
            Id MentorRectypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Mentor').getRecordTypeId();

            List<Contact> conList = [Select Id,FirstName,LastName,FFE_ID__c,Email,Phone,Aadhar_number__c,Gender__c,
                                     Spoken_Languages__c,College_Name__c,College_Location__c,Branch_Stream__c,Modules__c,Login_Hash_Code__c,RecordTypeId,is_Mentor__c from Contact Where Email =:mentorEmail AND RecordTypeId =:MentorRectypeId];
            
            if(conList.size() !=0){
              /*  conList[0].password__c = mentorId;
                update conList[0];
                return temporaryMenteeLoginURL(conList[0].id,'mentorRegistrationURL');   */
                if(conList[0].is_Mentor__c == FALSE){
                    string hashCode = Utility.generateRandomString();
                    conList[0].Login_Hash_Code__c = hashCode;
                    conList[0].Last_Hash_Code_Updated__c   = System.now();
                    conList[0].password__c = mentorId;
                    update conList[0];
                    return hashCode;
                }
                return 'regesterd';
            }
            else if(conList.size() == 0){
                string hashCode = Utility.generateRandomString();
                String[] startArr = mentorEmail.split('@');
                contact mentorRec = new contact();
                mentorRec.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_Mentor).getRecordTypeId();
                mentorRec.Email = mentorEmail;
                mentorRec.LastName = startArr[0];
                mentorRec.password__c = mentorId;
                mentorRec.Login_Hash_Code__c = hashCode;
                mentorRec.Last_Hash_Code_Updated__c   = System.now();
                insert mentorRec;
               // return temporaryMenteeLoginURL(mentorRec.id,'mentorRegistrationURL');
               return hashCode;
            }
            return null;
        }
        catch(exception e){
            system.debug('LineNumber==>'+e.getLineNumber()+'ErrorMessage=====>'+e.getMessage());
            return null;
        }
        
    }
    
    @RemoteAction
    public static string generateLoginURL(String ffeId,String types){
        return Utility.temporaryDonorLoginURL(ffeId, null,types);
    }
    
    @RemoteAction
    public static string generateLoginURLForEmail(String emailId,String types){
        return Utility.temporaryDonorLoginURL(null, emailId,types);
    }
    @RemoteAction
    public static string passwordReset( String emailId){
        try{
            List<Contact> conList = [Select Id,FirstName,LastName,FFE_ID__c,is_Mentee__c,Email,Phone,Aadhar_number__c,What_are_your_top_two_career_goals__c,Gender__c,
                                     Spoken_Languages__c,College_Name__c,College_Location__c,Is_Mentor__c,Branch_Stream__c,Modules__c,Login_Hash_Code__c from Contact Where Email =:emailId ];
            if(conList.size() !=0){
                if(conList[0].is_Mentee__c == True){
                    return temporaryMenteeLoginURL(conList[0].id,'MentorshipResetPassword');
                }  if(conList[0].is_Mentor__c == True){
                    return temporaryMenteeLoginURL(conList[0].id,'MentorshipResetPassword');
                } 
            }
            else if(conList.size() == 0){
                return null;
            }
            return null;
        }
        catch(exception e){
            system.debug('LineNumber==>'+e.getLineNumber()+'ErrorMessage=====>'+e.getMessage());
            return null;
        }
        
    }
    
    
    public static string temporaryMenteeLoginURL(String contactId, string type){
        try{
           
            list<contact> contacts = [select name,id,Login_Hash_Code__c,Last_Hash_Code_Updated__c from contact where id =:contactId];
            
            if(contacts.size() > 0){
                contacts[0].Login_Hash_Code__c          = Utility.generateRandomString();
                contacts[0].Last_Hash_Code_Updated__c   = System.now();
                update contacts; 
                EmailTemplate et    =  new EmailTemplate();
                if(type == 'MenteeRegistration'){
                    et = [SELECT id FROM EmailTemplate WHERE developerName = 'menteeRegistrationURL'];
                    
                }else if(type == 'Mentee'){
                    et = [SELECT id FROM EmailTemplate WHERE developerName = 'MenteeLoginURl'];
                }
                else if(type == 'mentorRegistrationURL'){
                    et = [SELECT id FROM EmailTemplate WHERE developerName = 'mentorRegistrationURL'];
                }
                else if(type == 'MentorshipResetPassword'){
                    et = [SELECT id FROM EmailTemplate WHERE developerName = 'mentorshipForgotPassword'];
                    
                }
                    
                return Utility.sendEmailWithTemplate(contacts[0].Id, et.Id);
            }else{
                return Constants.NO_USER_FOUND;
            }            
        }catch(Exception ex){
            system.debug('e==='+ex);
            HandleBusinessException.captureError('Signin', 'temporaryDonorLoginURL', ex);
            return Constants.ERROR_MSG;
        }
    }
}