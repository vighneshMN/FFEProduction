import { LightningElement,wire,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import getStateCitiesList from '@salesforce/apex/AP_FacilitatorAssignment_CTRL.getCitiesLwc';
import getIndianStateList from '@salesforce/apex/AP_FacilitatorAssignment_CTRL.getStatesLwc';
import getStudentDetails from '@salesforce/apex/AP_FacilitatorAssignment_CTRL.getStudentDetailsLwc';
import getFacilitatorDetails from '@salesforce/apex/AP_FacilitatorAssignment_CTRL.getFacilitatorDetailsLwc';
import createFacilitatorMapping from '@salesforce/apex/AP_FacilitatorAssignment_CTRL.createFacilitatorMappingLwc';
import getVerificationTypes from '@salesforce/apex/AP_FacilitatorAssignment_CTRL.getVerificationType';


const actions = [
    { label: 'Match Facilitator', name: 'matchfacilitator' },
];
const columns = [
    { label: 'Student Name', fieldName: 'Name'},
    { label: 'Student ID', fieldName: 'recordLink', type: 'url',
    typeAttributes: { label: { fieldName: "FFE_ID__c" }, tooltip:"Student ID", target: "_blank" } },
    { label: 'Student Mobile No.', fieldName: 'MobilePhone', type: 'phone' },
    { label: 'Parent Mobile No.', fieldName: 'Parent_Mobile__c', type: 'phone' },
    { label: 'Student Location', fieldName: 'MailingCity'},
    { label: 'Referred by Facilitator', fieldName: 'Refered_by_Facilitator_Name__c' },
    /*{
        type: 'action',
        typeAttributes: { rowActions: actions },
    },*/
    {type: "button", typeAttributes: {  
        label: 'Match Facilitator',  
        name: 'matchfacilitator',  
        title: 'Match Facilitator',  
        disabled: false,  
        value: 'matchfacilitator',  
        iconPosition: 'left',  
        variant: 'brand'  
    }},
];

const facilitatorcolumns = [
    { label: 'Facilitator Name', fieldName: 'Name'},
    { label: 'Facilitator ID', fieldName: 'recordLink', type: 'url',
    typeAttributes: { label: { fieldName: "FFE_ID__c" }, tooltip:"Facilitator ID", target: "_blank" } },
    { label: 'Facilitator Street', fieldName: 'MailingStreet' },
    { label: 'Facilitator City', fieldName: 'MailingCity' },
    { label: 'Facilitator State', fieldName: 'MailingState'},
    { label: 'Facilitator PostalCode', fieldName: 'MailingPostalCode' },
    { label: 'Working Mode', fieldName: 'Working_Mode__c'},
    { label: 'Mobile No.', fieldName: 'MobilePhone'},
    { label: 'Facilitator Load', fieldName: 'Facilitator_Load__c'},
    /*{
        type: 'action',
        typeAttributes: { rowActions: actions },
    },*/
];
export default class FfeSearchFacilitatorFormLwc extends LightningElement {
    
    /*@track columns = [
        { label: 'Student Name', fieldName: 'Name' },
        { label: 'Student ID', fieldName: 'FFE_ID__c', type: 'url' },
        { label: 'Student Mobile No.', fieldName: 'MobilePhone', type: 'phone' },
        { label: 'Parent Mobile No.', fieldName: 'Parent_Mobile__c', type: 'phone' },
        { label: 'Student Location', fieldName: 'MailingCity'},
        { label: 'Referred by Facilitator', fieldName: 'Refered_by_Facilitator_Name__c' },
        {
            type: 'action',
            typeAttributes: { rowActions: actions },
        },
    ];*/
    @track facilitatorcolumns = facilitatorcolumns;
    @track listOffacilitators;
    @track facilitatorserror;
    @track columns = columns;
    @track listOfStudents;
    @track error;
    @track isModalOpen = false;
    items= [];
    listOfStates = [];
    listOfCities = [];
    listOfVerificationType = [];
    facilitatorStudent = [];
    countrySelected = 'India';
    stateSelected;
    citySelected;
    verificationSelected;
    studentSelected;
    facilitatorSelected;
    addressType = '';
    buttonLabel = '';
    showStudentTable = false;
    showFacilitatorTable = false;
    _title = 'Sample Title';
    message = 'Sample Message';
    variant = 'error';
    handleSearch(event){
        
        this.buttonLabel = event.target.label;
        console.log('State : ' + this.stateSelected);
        console.log('City : ' + this.citySelected);
        if(this.stateSelected == undefined || this.stateSelected == ''){
            this.template.querySelector('c-ffe-popup-lwc').showPopup ('Please select "State" filter to search.', '', 'OK', '');
        }else{
            if(this.citySelected == undefined || this.citySelected == null){
                this.citySelected = '';
            }
            if(this.buttonLabel == 'Search by Mailing Address'){
                this.addressType = 'Mailing';
            }else if(this.buttonLabel == 'Search by Current Address'){
                this.addressType = 'Current';
            }
            this.listOfStudents = [];
            getStudentDetails({ state: this.stateSelected, city: this.citySelected, addressType: this.addressType })
                .then((result) => {
                    var tempStudentList = [];
                    for (var i = 0; i < result.length; i++) {  
                        let tempRecord = Object.assign({}, result[i]); //cloning object  
                        tempRecord.recordLink = "/" + tempRecord.Id;  
                        tempStudentList.push(tempRecord);  
                    } 
                    
                    this.listOfStudents = tempStudentList;
                    
                    this.error = undefined;
                    this.showStudentTable = result.length > 0;
                })
                .catch((error) => {
                    this.error = error;
                    this.listOfStudents = undefined;
                });
                
        }
    }

    handleValueChange(event){
        console.log('event caught ',event.detail.value);
        this.stateSelected = event.detail.value;
        this.listOfCities = [{value: '--None--', label: '--None--'}];
        this.listOfVerificationType = [{value: '--None--', label: '--None--'}];
        getStateCitiesList({ currentState: event.detail.value })            
            .then((result) => {
                for(const valueObject of result){
                    this.listOfCities = [...this.listOfCities,{value: valueObject.City__c, label:valueObject.City__c}];
                }
                this.error = undefined;
            })
            .catch((error) => {
                this.error = error;
                this.listOfCities = undefined;
            });
        getVerificationTypes()
            .then((result) => {
                console.log (result); 
                //this.listOfVerificationType = result; 
                for(const valueObject of result){
                    this.listOfVerificationType = [...this.listOfVerificationType,{value: valueObject, label:valueObject}];
                }
                console.log (this.listOfVerificationType); 
                this.error = undefined;
            })
            .catch((error) => {
                this.error = error;
                this.listOfVerificationType = undefined;
            });
    }

    handleCityValueChange(event){
        console.log('event caught ',event.detail.value);
        this.citySelected = event.detail.value;
        
    }
    handleVerificationChange(event){
        console.log('event caught ',event.detail.value);
        this.verificationSelected = null;
        if (event.detail.value != '--None--'){
            this.verificationSelected = event.detail.value;
        }
    }

    handleCityValueChangeFromModal(event){
        console.log('event caught Modal : ',event.detail.value);
        this.citySelected = null;
        if (event.detail.value != '--None--'){
            this.citySelected = event.detail.value;
        }
        
        this.getFacilitatorDetailsJS();

    }

    

    @wire(getIndianStateList)
    wiredStateList({error, data}){
        if(data){
            //console.log('listOfStates: ' + JSON.stringify(data));
            for(const valueObject of data){
                //console.log('listOfStates: ' + valueObject.Label);
                this.listOfStates = [...this.listOfStates,{value: valueObject.Label, label:valueObject.Label}];
            }
            //console.log('listOfStates: ' + listOfStates);
        }else if(error){
            console.log('Error in the wired state list ',error);
        }
    }

    
    handleRowAction( event ) {
        this.isModalOpen = true;
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        this.studentSelected = event.detail.row;
        this.getFacilitatorDetailsJS();
    }
    getFacilitatorDetailsJS(){
        getFacilitatorDetails({ state: this.stateSelected, city: this.citySelected})
                .then((result) => {
                    console.log(result);
                    var tempFacilitatorList = [];
                    for (var i = 0; i < result.length; i++) {  
                        let tempRecord = Object.assign({}, result[i]); //cloning object  
                        tempRecord.recordLink = "/" + tempRecord.Id;  
                        tempFacilitatorList.push(tempRecord);  
                    } 
                    
                    this.listOffacilitators = tempFacilitatorList;
                    this.showFacilitatorTable = result.length > 0;
                    this.facilitatorserror = undefined;
                    
                })
                .catch((error) => {
                    this.facilitatorserror = error;
                    this.listOfStudents = undefined;
                    
                });
    }
    handleFacilitatorRowAction( event ){
        
        if(this.facilitatorSelected == undefined || this.stateSelected == ''){
            console.log('Select Facilitator');
            this._title = 'Select Facilitator';
            this.message = 'Please select Facilitator to create mapping.';
            this.showToast();
        }else{
            
            
            console.log('Mapping : ');
            console.log(this.facilitatorStudent);
            createFacilitatorMapping({ studentId: this.studentSelected.Id, selVerificationType: this.verificationSelected,  facilitatorId: this.facilitatorSelected[0].Id})
            .then((result) => {
                console.log('result'+result);
                this._title = 'Facilitator Mapping Completed';
                this.message = 'Facilitator has been mapped.';
                this.variant = 'success';
                this.showToast();
                this.isModalOpen = false;
            })
            .catch((error) => {
                //this.facilitatorserror = error;
                //this.listOfStudents = undefined;
                
            });
        }
        //this.facilitatorStudent.push({facilitatorId:this.selectedFacilitator.Id,studentId:this.selectedStudent.Id});
    }
    handleFacRowSelection(event){
        this.facilitatorSelected = event.detail.selectedRows;
    }
    openModal() {
        // to open modal set isModalOpen tarck value as true
        
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }
    submitDetails() {
        // to close modal set isModalOpen tarck value as false
        //Add your code to call apex method or do some processing
        this.isModalOpen = false;
    }
    showToast() {
        const event = new ShowToastEvent({
            title: this._title,
            message: this.message,
            variant: this.variant,
        });
        this.dispatchEvent(event);
    }
}