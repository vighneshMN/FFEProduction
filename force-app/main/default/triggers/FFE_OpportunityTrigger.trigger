trigger FFE_OpportunityTrigger on Opportunity (after insert, after update, after Delete) {
    Id ID_opportunityDonationRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Donation').getRecordTypeId();
    List<Id> listOppIds = new List<Id>();
    List<Id> listPaymentOrderIds = new List<Id>();
    if(Trigger.isAfter && Trigger.isInsert){
        listOppIds = new List<Id>();
        for(Opportunity objOpp: Trigger.New)
        {
            if(objOpp.recordTypeId == ID_opportunityDonationRecordType)
            {
                listOppIds.add(objOpp.Id);
            }
        }
        if(listOppIds != null && listOppIds.size() > 0)
            FFE_OpportunityTriggerHandler.updateDonationType(listOppIds);
    }
    if(Trigger.isAfter && Trigger.isUpdate){
        FFE_OpportunityTriggerHandler.updateTotalDonations(Trigger.NewMap, Trigger.OldMap);
        listPaymentOrderIds = new List<Id>();
        for(Opportunity objOpp: Trigger.New)
        {
            if(objOpp.recordTypeId == ID_opportunityDonationRecordType)
            {
                if(Trigger.oldmap.get(objOpp.id).StageName != Trigger.newmap.get(objOpp.id).StageName && Trigger.newmap.get(objOpp.id).StageName == 'Posted') {
                    listPaymentOrderIds.add(objOpp.Payment_Order__c);
                }
                
            }
        }
        if(listPaymentOrderIds != null && listPaymentOrderIds.size() > 0)
            FFE_OpportunityTriggerHandler.updatePaymentOrderDonationStage(listPaymentOrderIds);
    }
    
    if(Trigger.isDelete && Trigger.isAfter){
        system.debug('after delete');
        FFE_OpportunityTriggerHandler.updateTotalDonationsAfterDelete(Trigger.New, Trigger.OldMap);
    }
}