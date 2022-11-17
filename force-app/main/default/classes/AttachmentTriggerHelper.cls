/*@Author: Jayanth B
* Use: This class is used to display donor logos in record pages
*/
public class AttachmentTriggerHelper {
    
    public static void afterInsertOfAttachment(List<Attachment> attchmentList){
        try{
            Map<String,String> donorAttachmentForLogos  = new Map<String,String>();
            Map<String,String> primaryLogo              = new Map<String,String>();
            Map<String,String> secondaryLogo            = new Map<String,String>();
            
            for(Attachment attch : attchmentList){
                donorAttachmentForLogos.put(attch.ParentId,attch.id);
                
                String attachmentName = '';
                if(attch.Name.contains(system.label.Primary_logo)){
                    attachmentName = system.label.Primary_logo;
                }else if(attch.Name.contains(system.label.Secondary_Logo)){
                    attachmentName = system.label.Secondary_Logo;
                }else{
                    attachmentName = attch.Name;
                }
                
                if(attachmentName == system.label.Primary_logo){
                    primaryLogo.put(attch.ParentId+attachmentName,attch.id);   
                }
                
                if(attachmentName == system.label.Secondary_Logo){
                    secondaryLogo.put(attch.ParentId+attachmentName,attch.id);
                }
            }
            
            List<Contact> conList = [Select id,Primary_Donor_logo_attachment_Id__c,Secondary_Donor_logo_attachment_id__c from Contact where id=:donorAttachmentForLogos.keyset()];
            List<contact> updateAttachmentsIds = new List<contact>();
            
            for(Contact con : conList){
                if(con.Primary_Donor_logo_attachment_Id__c == null)
                    con.Primary_Donor_logo_attachment_Id__c = primaryLogo.get(con.id+system.label.Primary_logo);
                if(con.Secondary_Donor_logo_attachment_id__c == null)
                    con.Secondary_Donor_logo_attachment_id__c = secondaryLogo.get(con.id+system.label.Secondary_Logo);
                updateAttachmentsIds.add(con);
            }
            
            if(!updateAttachmentsIds.isEmpty()){
                update updateAttachmentsIds;
            }
        }Catch(Exception e){
            HandleBusinessException.captureError('AttachmentTriggerHelper', 'afterInsertOfAttachment', e);
            
        }
    }
    
    public static void countAttachments(list<Attachment> attList, list<Attachment> oldAttList){
        try{
        system.debug('@@@@@@@@@@@@'+attList);
        system.debug('@@@@@@@@@@@@--------oldAttList------'+oldAttList);
        set<id> attids = new set<id>();
        system.debug('sucsssssssssssssssssssssssssssssssssssssssssssssssss');
        if(oldAttList != null && !trigger.isupdate){
            for(Attachment att:oldAttList){
                system.debug('Parrrrrrrrrrrrrr  del list'+att);
                if(att.ParentId != null){
                    attids.add(att.ParentId); 
                }
            }       
            
        }
        if(attList != null){
            for(Attachment att:attList){
                system.debug('Parrrrrrrrrrrrrr'+att.ParentId);
                if(att.ParentId != null){
                    system.debug('par not null');
                    system.debug('par app');
                    
                    attids.add(att.ParentId); 
                }
            }            
        }
        system.debug('@@@@@@@@@@@@'+attids);
            if(attids != null){
                list<Application__c> queryOnAppListToUpdate = [SELECT Id,Number_of_Attachments__c, (SELECT Id, Name FROM Attachments) FROM Application__c where id IN: attids];
                system.debug('111111111111111111'+queryOnAppListToUpdate);
                for(Application__c app:queryOnAppListToUpdate){
                    app.Number_of_Attachments__c = app.Attachments.size();  
                   if(app.Attachments.size() > 0){
                        for(Attachment att:app.Attachments){
                           // app.Uploaded_Attachments__c = att.Name;
                           system.debug('attachment name -----'+att.Name);
                            if(att.Name == 'Income Certificate, Salary Certificate, Pension Certificate or Income Tax Return or Other document, as applicable.pdf')
                                app.Income_Certificate__c = True;
                            
                            if(att.name == 'Applicant\'s Pledge of Future Support to FFE.pdf')
                                app.Applicant_s_Pledge__c = True;
                            
                            if(att.name == 'Letter of Thanks to Donors' || att.name == 'Letter of Thanks to Donors.docx')
                               app.Letter_of_Thanks_to_Donors__c = True; 
                            
                            if(att.name == 'Parent\'s or Guardian\'s Declaration.pdf')
                                app.Parent_s_Declaration__c = True;
                            
                            if(att.name == 'Copy of First Sheet of Bank Pass Book or Cancelled Cheque.pdf')
                                app.Copy_of_First_Sheet_of_Bank__c = True;
                            
                            if(att.name == 'Receipts for Actual Expenses incurred for current year(College Fee/Hostel & Mess/Transport/Books/Uniform).pdf' || att.Name =='Expense Receipts for Actual Expenses incurred for current academic year(College Fee/Hostel & Mess/Transport/Books/Uniform).pdf')
                               app.Receipts_for_Actual_Expenses__c = True; 
                            	
                            if(att.name == 'Bonafide Student Certificate showing status of enrolment in college, course/branch, year of study.pdf' || att.name == 'Bonafide Student Certificate showing status of enrolment in college, course/branch, year of study.pdf')
                                app.Bonafide_Student_Certificate__c = True;
                           
                            if(att.name == 'Copy of Aadhaar.pdf')
                                app.Copy_of_Aadhaar__c = True;
                            
                            if(att.name == 'Oath, Pledge and Declaration Form signed by you and your parent/guardian.pdf')
                                app.Oath_Pledge_and_Declaration_Form__c = True;
                            
                            if(att.name == 'Odd Semester Mark Sheet of the previous year.pdf')
                                app.Odd_Semester_Mark_Sheet__c = True;
                            
                            if(att.name == 'Even Semester Mark Sheet of the previous academic year.pdf')
                                app.Even_Semester_Mark_Sheet__c = True;
                            if(att.name == 'Statement of Estimated Expenses issued by your college for the current academic year.pdf')
                                app.Statement_of_Estimated_issued__c = True;
                           	if(att.name == 'Mark Sheet for Secondary School Certificate (10th) Board Examination.pdf')
                                app.Mark_Sheet__c = True;
                            if(att.name == 'Mark Sheet for Higher Secondary (12th/PUC/Intermediate) Examination.pdf')
                                app.Mark_Sheet_for_Higher_Secondary__c = True;
                            if(att.name == 'Entrance Test Marks & Rank Certificate.pdf')
                                app.Entrance_Test_Marks__c = True;
                            if(att.name == 'Counselling, Admission or Seat Allotment Letter.pdf')
                                app.Counselling_Admission__c = True;
                            if(att.name == 'Statement of Estimated Expenses for the current academic year Issued by your College.pdf')
                                app.Statement_of_Estimated__c = True;

                        
                    
                }
                
                
                
                   }
                }
                update queryOnAppListToUpdate;    
            }
        }Catch(Exception e){
            System.debug('@@@@@@@@'+e.getMessage()+' AT '+e.getLineNumber()+ 'STACKTRACE'+e.getStackTraceString());
                         
        }
        
    }
    public static void deletedAttachments(list<Attachment> attList, list<Attachment> oldAttList){
        system.debug('inside after delete -------');
        Map<string,string> attNameXParentId = New Map<string,string>();
        Map<String, Set<String>> parentIdXattNameSet = new Map<String, Set<String>>(); 
        list<Application__c> appToUpdate = New list<Application__c>();
        if(!oldAttList.isEmpty()){
            system.debug('oldAttList not ------------- empty');
            map<string,string> AttNameXFieldName = New map<string,string>();
            list<Student_Attachment_Names__c> studentAttNameList = Student_Attachment_Names__c.getall().values();
            list<string> attNames = New List<string>();
            for(Student_Attachment_Names__c att:studentAttNameList){
                attNames.add(att.Attachment_Name__c);
            }
            for(Attachment att:oldAttList){
                if(attNames.contains(att.Name)){
                    if(parentIdXattNameSet.containsKey(att.ParentId)){
                        set<string> setToBeAdded = parentIdXattNameSet.get(att.ParentId);
                        setToBeAdded.add(att.Name);
                        parentIdXattNameSet.put(att.ParentId, setToBeAdded);
                    }
                    else{
                        parentIdXattNameSet.put(att.ParentId,new Set<String>{ att.Name } );
                    }
                }
                

              /*  if(att.ParentId != null){
                    attNameXParentId.put(att.Name,att.ParentId);                    
                } */
            }
            system.debug('parentIdXattNameSet::'+parentIdXattNameSet);
            system.debug('attNameXParentId----'+attNameXParentId);
            system.debug('attNameXParentId----'+attNameXParentId.values());
            for(Student_Attachment_Names__c attchmnt:studentAttNameList){
                AttNameXFieldName.put(attchmnt.Attachment_Name__c,attchmnt.Name);
            }
			system.debug('AttNameXFieldName---'+AttNameXFieldName);
         
            system.debug('parentIdXattNameSet---'+parentIdXattNameSet);
            for(string idValue : parentIdXattNameSet.keyset()){
                Application__c attmnt = New Application__c();
                system.debug('idValue------'+idValue);
                attmnt.put('Id',idValue);
                for(String fileName : parentIdXattNameSet.get(idValue)){
                    system.debug('fileName---'+fileName);
                    if(AttNameXFieldName.containsKey(fileName)){
                        system.debug('AttNameXFieldName.get(key)-----'+AttNameXFieldName.get(fileName));
                        attmnt.put(AttNameXFieldName.get(fileName),False);
                           
                    }
                }
                system.debug('attmnt----'+attmnt);
                appToUpdate.add(attmnt);
                
            }
            system.debug('appToUpdate----'+appToUpdate);
            if(!appToUpdate.isEmpty())
     			update appToUpdate;   
    }
    }
}