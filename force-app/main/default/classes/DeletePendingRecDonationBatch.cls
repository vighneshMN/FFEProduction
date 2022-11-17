global class DeletePendingRecDonationBatch implements Schedulable {
    
    global void execute(SchedulableContext ctx){
        date oldOppDate = date.today();
     list<opportunity> oppListToDelete = New list<opportunity>();   
     list<opportunity> oppList= [select name,id,closeDate from opportunity where CloseDate <: date.today() AND Payment_Order__c = null AND npe03__Recurring_Donation__c != null];
        for(opportunity opp:oppList){
            if( opp.closeDate.month() == oldOppDate.month() - 1){
                oppListToDelete.add(opp);
            }
        }
        system.debug('oppListToDelete--'+oppListToDelete);
        system.debug('oppListToDelete--'+oppListToDelete.size());
        if(!oppListToDelete.isEmpty())
        	delete oppListToDelete;
    }
}