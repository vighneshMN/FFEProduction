import { LightningElement,track,api,wire } from 'lwc';
import getFilteredStudentsLwc from '@salesforce/apex/DN_DonorAllocation_CTRL.getFilteredStudentsLwc';
// import searchAccounts from '@salesforce/apex/DN_DonorAllocation_CTRL.searchAccount';

const actions = [
    { label: 'Match Donors', name: 'match_donors' }
    
];

const columnList = [
    {label: 'Student Name', fieldName: 'Student_name__c'},
    // {label: 'Student Id', fieldName: 'FFE_ID__c'},
    {label: 'Student Id', fieldName: 'Student__c', type: 'url',typeAttributes:{ label: { fieldName: 'FFE_ID__c' }, target: '_blank' }},
    {label: 'Gender', fieldName: 'Gender__c'},
    {label: 'Family Income', fieldName: 'Annual_Family_Income__c'},
    {label: 'Location', fieldName: 'Location__c'},
    {label: 'Course', fieldName: 'Course__c'},
    {label: 'Appvd. Schr. Amt', fieldName: 'ScholarshipAmount__c'},
    {
        type: 'action',
        typeAttributes: { rowActions: actions },
    }, 
];



export default class FfeSearchStudentResults extends LightningElement {

    @track studentFilter ;
    @track donorId = '';

    @track accountList;
    @track columnList = columnList;

    @track displayStudentLst = [] ;

    noResult;

    @api 
    searchStudents(studentFilter){
        console.log('Api method search students called');
        this.studentFilter = studentFilter;
        console.log(studentFilter.studentState);
        this.displayStudentLst = [] ; //Clear the list first
        getFilteredStudentsLwc({searchFilter : this.studentFilter,
                                DonorId : this.donorId})
        .then(result =>{
            console.log('Result ',result);
            this.displayStudentLst = [] ; //Clear the list first
            result.forEach(student =>{
                let displayStudent ={};
                displayStudent.Id = student.Id;
                displayStudent.Student__c = '/lightning/r/Contact/' + student.Student__c +'/view';
                displayStudent.Student_Param__c = student.Student__c;
                displayStudent.Student_name__c = student.Student__r.Name;
                displayStudent.FFE_ID__c = student.Student__r.FFE_ID__c;
                displayStudent.Gender__c = student.Student__r.Gender__c;
                displayStudent.Annual_Family_Income__c = student.Student__r.Annual_Family_Income__c;
                displayStudent.Location__c = student.Student__r.College_Name__r.College_State__c;
                displayStudent.Course__c = student.Student__r.Course__c;
                displayStudent.ScholarshipAmount__c = student.Student__r.ScholarshipAmount__c;
                this.displayStudentLst = [...this.displayStudentLst,displayStudent];
            })
            this.dispatchEvent(new CustomEvent('hideloading'));
            if(this.displayStudentLst.length > 0 ){
                this.noResult = false;
            }else{
                this.noResult = true;
            }
        })
        .catch(error =>{
            console.log('Error in search students ' , error);
            this.dispatchEvent(new CustomEvent('hideloading'));
        })   
    }

    // @wire(getFilteredStudentsLwc ,{searchFilter : '$studentFilter',
    //                                 DonorId     : '$donorId'})
    // wiredFilteredStudents(result){
    //     console.log('wiredFilteredStudents');
    //     if(result.data){
    //         this.displayStudentLst = [] ; //Clear the list first
    //         console.log(result.data);
    //         result.data.forEach(student =>{
    //             let displayStudent ={};
    //             displayStudent.Id = student.Id;
    //             displayStudent.Student__c = student.Student__c;
    //             displayStudent.Student_name__c = student.Student__r.Name;
    //             displayStudent.FFE_ID__c = student.Student__r.FFE_ID__c;
    //             displayStudent.Gender__c = student.Student__r.Gender__c;
    //             displayStudent.Annual_Family_Income__c = student.Student__r.Annual_Family_Income__c;
    //             displayStudent.Location__c = student.Student__r.College_Name__r.College_State__c;
    //             displayStudent.Course__c = student.Student__r.Course__c;
    //             displayStudent.ScholarshipAmount__c = student.Student__r.ScholarshipAmount__c;
    //             this.displayStudentLst = [...this.displayStudentLst,displayStudent];
    //         })
    //         console.log('displayStudentLst   ' , this.displayStudentLst); 
    //     }else if(result.error){
    //         console.log('Error  ' , result.error);
    //     }
    //     this.dispatchEvent(new CustomEvent('hideloading'));
    // }

    // findAccountResult(event) {
    //     const accName = 'test';

    //     if(accName) {
    //         searchAccounts ( {accName}) 
    //         .then(result => {
    //             this.accountList = result;
    //             this.noRecordsFound = false;
    //         })
    //     } else {
    //         this.accountList = undefined;
    //         this.noRecordsFound = true;
    //     }
    // }

    get showDataTable(){
        return this.displayStudentLst.length > 0 ;
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'match_donors':
                console.log('Match Donor action called');
                console.log(row.Id);
                console.log(row.Student_name__c);
                console.log(row.FFE_ID__c);
                //fire custom event which will show the modal and set the selected student
                this.dispatchEvent(new CustomEvent('showmodal',{ detail: row }));
                break;
            default:
        }
    }

    @api
    resetSearchStudentResults(event){
        //this.studentFilter = {};
        this.displayStudentLst = [];
        this.noResult = '';
    }

    get showNoResult(){
        if(this.noResult === true){
            return true;
        }
        else{
            return false;
        }
    }

}