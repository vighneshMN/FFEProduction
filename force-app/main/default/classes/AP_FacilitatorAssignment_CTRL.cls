/*
* @Purpose      :  FacilitatorAssignment_CTRL class.
* @Author       :  Supriya Chakrapani
* @CreatedDate  :  22-03-2017
*/

public class AP_FacilitatorAssignment_CTRL{
    public string listOfStates          {get;set;}
    public string verificationType      {get;set;}
    
   public AP_FacilitatorAssignment_CTRL(){
        listOfStates          = JSON.serializePretty(Utility.getStates(Constants.COUNTRY_IND));
       	verificationType      =	JSON.serializePretty(picklist_values('Contact','Verification_type__c')); 
    }
    
    @RemoteAction
    public static string getCities(string currentState){
        return JSON.serializePretty(AP_FacilitatorAssignment_helper.getAllCities(currentState));
    }
    
    @RemoteAction
    public static String getStudentDetails(String state,String city,String addressType){
        return JSON.serializePretty(AP_FacilitatorAssignment_Helper.getStudentDetails(state,city,addressType));
        
    }
    
    @RemoteAction
    public static String getFacilitatorDetails(String state,String city){
        return JSON.serializePretty(AP_FacilitatorAssignment_Helper.getFacilitatorDetails(state,city));
        
    }
    
    @RemoteAction
    public static String createFacilitatorMapping(List<facilitatorStudentWrapper> facilitatorStudentList, string selVerificationType){
        return AP_FacilitatorAssignment_Helper.createFacilitatorMapping(facilitatorStudentList, selVerificationType);
    }
@AuraEnabled
    public static String createFacilitatorMappingLwc(String studentId,String selVerificationType, String facilitatorId){
        List<AP_FacilitatorAssignment_CTRL.facilitatorStudentWrapper> facilitatorStudentList = new List<AP_FacilitatorAssignment_CTRL.facilitatorStudentWrapper>();
        AP_FacilitatorAssignment_CTRL.facilitatorStudentWrapper temp = new AP_FacilitatorAssignment_CTRL.facilitatorStudentWrapper();
        temp.studentId = studentId;
        temp.facilitatorId = facilitatorId;
        facilitatorStudentList.add(temp);
        //string selVerificationType = '';
        //AP_FacilitatorAssignment_helpercreateFacilitatorMapping(facilitatorStudentList);
        return AP_FacilitatorAssignment_Helper.createFacilitatorMapping(facilitatorStudentList,selVerificationType);
    }

 @AuraEnabled(cacheable=true)
    public static List<Contact> getFacilitatorDetailsLwc(String state,String city){
        return AP_FacilitatorAssignment_Helper.getFacilitatorDetails(state,city);
        
    }
    @AuraEnabled(cacheable=true)
    public static List<State_Master__mdt> getStatesLwc(){
        
        return Utility.getStates(Constants.COUNTRY_IND);
    }
    
    @AuraEnabled
    public static List<State_City_Master__c> getCitiesLwc(string currentState){
        system.debug('currentState : ' + currentState);
        return AP_FacilitatorAssignment_helper.getAllCities(currentState);
    }
    
    @AuraEnabled
    public static List<String> getVerificationType (){
        return picklist_values('Contact','Verification_type__c');
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Contact> getStudentDetailsLwc(String state,String city,String addressType){
        return AP_FacilitatorAssignment_Helper.getStudentDetails(state,city,addressType);
        
    }

    
    public static String[] picklist_values(String object_name, String field_name)
    {
        String[] values = new String[]{};
            String[] types = new String[]{object_name};
                Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        for(Schema.DescribeSobjectResult res : results)
        {
            for (Schema.PicklistEntry entry : res.fields.getMap().get(field_name).getDescribe().getPicklistValues())
            {
                if (entry.isActive()) {values.add(entry.getValue());}
            }
        }
        
        system.debug('values'+values);
        return values;
    }
    
    //Wrapper for passing student and facilitator Id
    public class facilitatorStudentWrapper {
        public String studentId;
        public String facilitatorId;
        
        public facilitatorStudentWrapper(){
            studentId  = '';
            facilitatorId= '';
        }
    }
}