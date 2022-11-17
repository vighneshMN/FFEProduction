/*
* @Purpose      :  AP_Student_Application_CTRL class.
* @Author       :  Supriya Chakrapani
* @CreatedDate  :  08-03-2017


*/ 

public class AP_Student_Application_CTRL{
    
    public string APGenderPickLstValues {get;set;}
    public string APtypePickLstValues 	{get;set;}
    public string mediumOfInstruction   {get;set;}
    public string listOfStates        	{get;set;}
    public string listOfExamBoards      {get;set;}
    public string studentCourse       	{get;set;}
    public string studentBranch       	{get;set;}
    public String studentLawBranch      {get;set;}
    public string occupationList       	{get;set;}
    public string sibilingList       	{get;set;}
    public string accomTypesList       	{get;set;}
    public string btechYearList       	{get;set;} 
    public string MtechYearList       	{get;set;} 
    public string MbbsYearList       	{get;set;}
    public string entranceTests			{get;set;}
    public boolean isPrelimAvailable    {get;set;}
    public string referedlist  			{get;set;}  
    public string refSubcategry  		{get;set;} 
    public string beneficiaryType  		{get;set;}  // ##
    public string refDonorSubcategry  	{get;set;}  
    public string socialMediaListString {get;set;}   
    public string sourceOfInfoReferedBy {get;set;} 


    @RemoteAction
    public static string validateFacilitator(Contact studentInfo){
        return AP_Student_Application_Helper.validateFacilitator(studentInfo);
    }
    
    @RemoteAction
    public static AP_Student_Application_helper.messageWrapper validateStudentInfo(Contact studentInfo){
        return AP_Student_Application_Helper.validateStudent(studentInfo);
    }
    
  
    @RemoteAction
    public static AP_Student_Application_CTRL.messageWrapper createStudentInSFDC(AP_Student_Application_CTRL.prelimWrapper plmwrp){
    	return AP_Student_Application_Helper.createStudentInSFDC(plmwrp);
    }
          
    @RemoteAction
    public static List<College_Master__c> searchCollege(String searchTerm,String course) {
        return AP_Student_Application_Helper.searchCollege(searchTerm, course);
        
    }
    
    
   /* public static string return_Login_Hashcode(Contact studentInfo){
        contact con = AP_Application_Helper.getScholarUserDetail(studentInfo.id);
        return con.Login_Hash_Code__c;
    }*/
    
    @RemoteAction
    public static string getCities(string currentState){
        return JSON.serializePretty(AP_Application_Helper.getAllCities(currentState));
    }
    @RemoteAction
    public static string getBoardMaxMarks(string examBoard){
        return JSON.serializePretty(AP_Application_Helper.getBoardMaxMarks(examBoard));
    } 
    @RemoteAction
    public static contact getReferedDonorDetail(string donorId){
        return [Select name,id,Show_Subcategory__c From Contact where Id = :donorId];
    }
    
    // // Controller for Getting Exams Based on the Course That we Selected

    @RemoteAction 
    public Static List<Entrance_Test__mdt> getExamDependingOnCourse(String courseName){
        return AP_Student_Application_Helper.getExamBasedOnCourseType(courseName);
    }

    
     public AP_Student_Application_CTRL(){
        
        APGenderPickLstValues = JSON.serializePretty(Utility.getPicklistValues(Constants.CONTACT_SOBJECT,Constants.SCHOLAR_GENDER)).trim();
        APtypePickLstValues   = JSON.serializePretty(Utility.getPicklistValues(Constants.CONTACT_SOBJECT,Constants.ACADEMIC_TYPE)).trim();
        listOfStates          = JSON.serializePretty(Utility.getStates(Constants.COUNTRY_IND));
        listOfExamBoards      = JSON.serializePretty(Utility.getExamBoards()).trim(); 
        System.debug('listOfExamBoards : '+listOfExamBoards);
        studentCourse         = JSON.serializePretty(Utility.getPicklistValues(Constants.CONTACT_SOBJECT,Constants.STUDENT_COURSE)).trim();
        studentBranch         = JSON.serializePretty(Utility.getPicklistValuesforBranchEngMetch(Constants.CONTACT_SOBJECT,Constants.SCHOLAR_BRANCH_FIELD)).trim();
       //added by sumit
         studentLawBranch         = JSON.serializePretty(Utility.getPicklistValuesforBranch(Constants.CONTACT_SOBJECT,Constants.SCHOLAR_BRANCH_FIELD)).trim();
         
    	occupationList		  = JSON.serializePretty(Utility.getPicklistValues(Constants.CONTACT_SOBJECT,Constants.OCCUPATION_TYPE)).trim();
        sibilingList		  = JSON.serializePretty(Utility.getPicklistValues(Constants.CONTACT_SOBJECT,Constants.SIBILINGNO)).trim();
        accomTypesList		  = JSON.serializePretty(Utility.getPicklistValues(Constants.CONTACT_SOBJECT,Constants.ACCOMODATION_TYPE)).trim();
         btechYearList		  = JSON.serializePretty(new List<String>{'1st Year','2nd Year','3rd Year','4th Year'});
        MtechYearList		  = JSON.serializePretty(new List<String>{'1st Year','2nd Year','3rd Year','4th Year','5th Year'});
        MbbsYearList      		= JSON.serializePretty(new List<String>{'Year I, Sem 1','Year II, Sem 3','Year II, Sem 5','Year III (Part 1), Sem 7','Year III (Part 2), Sem 9'});
        //MbbsYearList		  = JSON.serializePretty(new List<String>{'1st Year','2nd Year','3rd Year (Part 1)','3rd Year (Part 2)','4th Year','5th Year'});
     	mediumOfInstruction   = JSON.serializePretty(new List<String>{'English','Hindi','Kannada','Telugu','Tamil','Other'});
        entranceTests		  = JSON.serializePretty(AP_Student_Application_helper.getAllEntranceTestName());
        referedlist			  = JSON.serialize(utility.getPicklistValues('contact','Refered__c'));
        refSubcategry		  = JSON.serialize(utility.getPicklistValues('contact','Reffered_by_Subcategory__c'));
        beneficiaryType       = JSON.serialize(Utility.getPicklistValues('contact', 'Beneficiary_Type__c')); //###   

        refDonorSubcategry		= JSON.serialize(utility.getPicklistValues('contact','Referred_Category__c'));
        socialMediaListString = JSON.serialize(utility.getPicklistValues('Contact','Social_Media__c'));
        sourceOfInfoReferedBy = JSON.serialize(utility.getPicklistValues('Contact','Source_of_information_Referred_by__c'));

        isPrelimAvailable	  = AP_Student_Application_helper.displayPrelimApp();
     }
    
    public class prelimWrapper {
        public Contact scholar;
        public Application__c ScholarAppln;
        
        public prelimWrapper(){
            scholar			= new Contact();
            ScholarAppln	= new Application__c();
        }
    }
    
    public class messageWrapper {
        public string message;
        public string recordId;
        
        public messageWrapper(){
            message  = '';
            recordId= '';
        }
    }
}