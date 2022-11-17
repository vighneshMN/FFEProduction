public Class BAUController {
    public List<Business_Account_Utilization__c> baus {get;private set;}
    
    public BAUController(ApexPages.StandardSetController stdSetController){
        // Returns all selected records
        baus = (List<Business_Account_Utilization__c>) stdSetController.getSelected();
        System.debug('Selected contact size ' + baus.size());
        System.debug(baus);
    }

}