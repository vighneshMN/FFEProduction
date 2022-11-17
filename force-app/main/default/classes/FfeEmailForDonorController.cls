public Class FfeEmailForDonorController {
    public List<Contact> contacts {get;private set;}
    
    public FfeEmailForDonorController(ApexPages.StandardSetController stdSetController){
        // Returns all selected records
        contacts = (List<Contact>) stdSetController.getSelected();
        System.debug('Selected contact size ' + contacts.size());
        System.debug(contacts);
    }

}