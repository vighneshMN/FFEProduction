/*
* @Purpose		: This Wrapper class is used to hold filter criteria for searching Students.
* @Author		: Tejas
* @CreatedDate  : 07/06/2016 
*/
public class FFECollegeFilterWrapperLwc {
    // public FFECollegeFilterWrapperLwc() {

    // }
    @AuraEnabled    
    public List<string> studentState{get; set;}
    @AuraEnabled
    public List<string> collegStates{get; set;}
    @AuraEnabled
    public List<string> collegeCity{get; set;}
    @AuraEnabled
    public List<string> collegeName{get; set;}
    @AuraEnabled
    public List<string> Course{get; set;}
    @AuraEnabled
    public List<String> courseYear{get; set;}
    @AuraEnabled
    public List<string> genderList {get; set;}
    @AuraEnabled
    public List<string> branchList{get; set;}
    @AuraEnabled
    public List<string> collegeRating{get; set;}
    @AuraEnabled
    public String priorityList{get; set;}
    @AuraEnabled
    public String ScholarshipAmountList{get; set;}
    @AuraEnabled
    public double minIncome{get; set;}    
    @AuraEnabled
    public double maxIncome{get; set;}
    @AuraEnabled
    public String FFEUId{get; set;}    
}