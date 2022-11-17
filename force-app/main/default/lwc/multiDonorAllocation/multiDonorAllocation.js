import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class MultiDonorAllocation extends LightningElement {
    loader = false;
    showStudentPopUpModal = false;
    selectedStudent ;
    noResult ;
    searchStudent(event){
        //console.log('Search Student called');
        let studentFilter = event.detail;
       // console.log(studentFilter.genderList);
       // console.log(studentFilter.studentState);
        this.showLoader();
        const studentResult = this.template.querySelector('c-ffe-search-student-results');
        //searchResult.searchBoats(event.detail.boatTypeId);
        studentResult.searchStudents(studentFilter);
        
    }

    showLoader(){
        this.loader = true;
    }

    hideLoader(){
        this.loader = false;
    }

    showPopUpModal(){
        this.showStudentPopUpModal = true;
    }

    hidePopUpModal(){
        this.showStudentPopUpModal = false;
    }

    showStudentPopUpModalMethod(event){
        console.log('showStudentPopUpModalMethod  called');
        this.showPopUpModal();
        this.selectedStudent = event.detail;
        console.log('Selected Student Id', this.selectedStudent.Id);
        console.log('Selected Student ScholarshipAmount__c', this.selectedStudent.ScholarshipAmount__c);
    }

    resetPage(event){
        this.loader = false;
        this.showStudentPopUpModal = false;
        this.selectedStudent = {};
        //Reset the c-ffe-search-student-results as well
        const studentResult = this.template.querySelector('c-ffe-search-student-results');
        studentResult.resetSearchStudentResults();
        if(event.detail){
            console.log('Event. detail true insiede reset page');
            const evt = new ShowToastEvent({
                title: 'Success',
                message: event.detail,
                variant: 'success',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
        }
    }

}