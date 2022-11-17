trigger FFE_ContactTrigger on Contact (before insert, before update,after insert,after update) {

    boolean flag=(BypassTrigger__c.getInstance('FFE_ContactTrigger')!=null ?BypassTrigger__c.getInstance('FFE_ContactTrigger').Bypass__c :false);
    if(flag){ system.debug('flag===='+flag);return;}
    
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        FFE_ContactTriggerHandler.formatFieldValue(Trigger.New);
    }

    if(Trigger.IsUpdate && Trigger.IsBefore) {
        //TODO: call send email API heree, with bulkyfication
        System.debug('Trigger.New ---'+Trigger.New);
        system.debug('trigger.oldMap----'+Trigger.OldMap);
        Id studentRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Student').getRecordTypeId();
        Id donorRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Donor').getRecordTypeId();
        
        for(contact conRec:Trigger.New){
            if(conRec.recordTypeId == studentRecordTypeId){
                system.debug(conRec.Facilitator_Name__c+'-----'+Trigger.oldMap.get(conRec.Id).Facilitator_Name__c);
                system.debug('----'+conRec.Internal_Status__c);
                if(conRec.Facilitator_Name__c != null && conRec.Facilitator_Name__c != Trigger.oldMap.get(conRec.Id).Facilitator_Name__c && (conRec.Internal_Status__c == 'Facilitator Matched' || conRec.Internal_Status__c == 'Facilitator_Matched') && conRec.Internal_Status__c != Trigger.oldMap.get(conRec.Id).Internal_Status__c){
                   system.debug('All conditions---------');
                    FFE_ContactTriggerHandler.sendStudentApplicationAsAttachment(conRec.Id,conRec.FirstName,conRec.LastName,conRec.FFE_ID__c,conRec.Email);
               Constants.Email_sent_to_Student_On_Facilitator_Matched=true;
                }
            }
        }
        
        //if(Trigger.New.size() == 1 && Trigger.New[0].recordTypeId == studentRecordTypeId && Trigger.new[0].Internal_Status__c != Trigger.old[0].Internal_Status__c && Trigger.old[0].Internal_Status__c == 'Eligible' && Trigger.new[0].Internal_Status__c == 'Selected')  -- Sumit Gaurav
      /*  if(!Constants.Email_sent_to_Student_On_Facilitator_Matched && Trigger.New.size() == 1 && Trigger.New[0].recordTypeId == studentRecordTypeId && Trigger.new[0].Facilitator_Name__c != Trigger.old[0].Facilitator_Name__c && Trigger.new[0].Facilitator_Name__c != null && Trigger.new[0].Internal_Status__c == 'Facilitator Matched' && Trigger.new[0].Email!=null)
        {
            FFE_ContactTriggerHandler.sendStudentApplicationAsAttachment(Trigger.New[0].Id,Trigger.New[0].FirstName,Trigger.New[0].LastName,Trigger.New[0].FFE_ID__c,Trigger.New[0].Email);
            Constants.Email_sent_to_Student_On_Facilitator_Matched=true;
        } */
        List<Id> listDonorRecordIds = new List<Id>();
            for(Contact objCon: Trigger.New){
            if(objCon.recordTypeId == donorRecordTypeId){
                listDonorRecordIds.add(objCon.id);
            }
        }
        //Added static var check to avoid recurssion -- Sumit Gaurav -- 26-June-2020
        if(!Constants.EightyG_Reciept_sent_to_Donor && listDonorRecordIds != null && listDonorRecordIds.size()>0 && !System.isBatch() && !System.isFuture()){
            Constants.EightyG_Reciept_sent_to_Donor=true;
            FFE_ContactTriggerHandler.afterUpdate_Send80GForm(listDonorRecordIds);
        }
    }
    if(Trigger.isAfter && Trigger.isInsert){
        Id studentRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Student').getRecordTypeId();
        Id donorRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Donor').getRecordTypeId();
        Contact objContact = Trigger.New[0];
        //Changed condition for sending Email to student with facilator details and documents when facilator is matched or changed -- Sumit Gaurav -- 09-June-2020        
        //When student is referred by facilator -- Sumit Gaurav
        if(!Constants.Email_sent_to_Student_On_Facilitator_Matched && Trigger.New.size() == 1 && objContact.recordTypeId == studentRecordTypeId &&  Trigger.new[0].Internal_Status__c == 'Facilitator Matched' && Trigger.new[0].Email!=null && Trigger.new[0].Facilitator_Name__c != null)
        {
            FFE_ContactTriggerHandler.sendStudentApplicationAsAttachment(objContact.Id,objContact.FirstName,objContact.LastName,objContact.FFE_ID__c,objContact.Email);
            Constants.Email_sent_to_Student_On_Facilitator_Matched=true;
        }

       
    }
    if(Trigger.isAfter && Trigger.isUpdate){
        Id mentorRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Mentor').getRecordTypeId();
        system.debug('WelcomeMentorEmail_Helper.runOnce--'+WelcomeMentorEmail_Helper.runOnce);
        if(WelcomeMentorEmail_Helper.runOnce == false){
            Map<id,contact> mentorList = New Map<id,contact>();
            for(contact con:Trigger.New){
                if(con.Is_Mentor__c == true && con.Is_Mentor__c != Trigger.oldMap.get(con.Id).Is_Mentor__c && con.RecordTypeId == mentorRecordTypeId){
                    mentorList.put(con.id,con);
                }
            }
            if(mentorList.size() >0)
                WelcomeMentorEmail_Helper.sendWelcomeEmailNotificationToMentor(mentorList);
        }
    }
}