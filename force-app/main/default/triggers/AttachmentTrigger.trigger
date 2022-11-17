trigger AttachmentTrigger on Attachment (after insert, after update, after delete, after undelete) {
    
    if(Trigger.IsInsert && Trigger.IsAfter){
        system.debug('after insert trigger');
        AttachmentTriggerHelper.afterInsertOfAttachment(Trigger.new);
        AttachmentTriggerHelper.countAttachments(Trigger.new, Trigger.old);
        
    }
    
    if(trigger.isafter) {
        system.debug('after triggger');
        if(trigger.isDelete || trigger.isUndelete || trigger.isUpdate ){            
            
                AttachmentTriggerHelper.countAttachments(Trigger.new, Trigger.old); 
        } 
    }
    if(trigger.isafter && trigger.isDelete) {
        AttachmentTriggerHelper.deletedAttachments(Trigger.new, Trigger.old); 
    }
    
}