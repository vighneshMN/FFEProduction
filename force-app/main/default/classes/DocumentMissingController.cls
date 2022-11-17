public Without Sharing class DocumentMissingController {     
    @AuraEnabled
    public static List<String> getPiklistValues(Id appId) {
        List<Renewal_Form_Attachments__mdt> rList;
        List<PrelimForm_Attachment__mdt> pList;
        Integer flag =0;
        Application__c appRecord = [Select Id,Application_Type__c from Application__c where Id=:appId];
        if(appRecord.Application_Type__c=='New')
        {
           pList =[Select Id,Attachment_Name__c from PrelimForm_Attachment__mdt];
            system.debug('pList'+pList);
            system.debug('pList size'+pList.size());
            flag =1;
        }
        else
        {
            rList =[Select Id,Attachment_Name__c from Renewal_Form_Attachments__mdt];
             system.debug('rList'+rList);
             system.debug('rList size'+rList.size());
        }
        List<String> plValues= new List<String>();
        if(appRecord.Application_Type__c=='New')
        {
            for(Integer i =0;i<pList.size();i++)
            {
                plValues.add(pList[i].Attachment_Name__c);
                system.debug('plValues'+plValues);
            }
        }
        else
        {
            for(Integer i =0;i<rList.size();i++)
            {
                plValues.add(rList[i].Attachment_Name__c);
            }
        }         
        return plValues;
    }
    @AuraEnabled
    public static Integer doStuff(List<String> docList,String content,Id appId)
    {
        
        Integer flag =0;
       
        Application__c appRecord = [Select Id,Application_Stage__c,Student__c,Internal_Status__c,Comment_s_for_Student__c,External_Status__c from Application__c where Id=:appId];
        Contact con =[Select MobilePhone from Contact where Id=:appRecord.Student__c];
        if(appRecord.Application_Stage__c!= 'Closed'){
		if(appRecord.Internal_Status__c!= 'Ready for Disbursement'){
		if(appRecord.Internal_Status__c!= 'Ineligible') {
		if(appRecord.Internal_Status__c!= 'Eligible'){
		if(appRecord.Internal_Status__c!= 'Rejected by Facilitator'){
		if(appRecord.Internal_Status__c!= 'Rejected_by_Facilitator'){
		
            String docMissingString = '';
			for(String temp : docList){
    		docMissingString+= temp + '\n' ;
			}
        appRecord.Comment_s_for_Student__c = 'Document Name(s) :'+'\n'+ docMissingString +'\n'+'Remarks: '+content; 
        appRecord.External_Status__c = 'Document Missing';
		appRecord.Internal_Status__c = 'Incomplete';
            system.debug(appRecord.Comment_s_for_Student__c);
            update appRecord;
            flag=1;
            WebServiceButtonHelper.sendEmailWithTemplateThroughCustomButton(appRecord.Student__c, appId);
            WebServiceButtonHelper.send_SMS(con.MobilePhone);
        }
            
        }
        }
        }
        }
        }    
    
            return flag;
    }
}