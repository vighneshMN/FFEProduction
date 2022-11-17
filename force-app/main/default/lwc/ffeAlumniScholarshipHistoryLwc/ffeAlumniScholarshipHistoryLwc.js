import { LightningElement,api,wire,track } from 'lwc';
import { getRecord,getFieldValue } from 'lightning/uiRecordApi';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import ISALUMNI from '@salesforce/schema/Contact.Is_Active_Alumni__c';

export default class FfeAlumniScholarshipHistoryLwc extends NavigationMixin(LightningElement) {

    @api recordId;
    /*isAlumni = false;

    @track applicationColumns = [
        { label: 'Application No', fieldName: 'LinkName', type: 'url', typeAttributes: { label: { fieldName: 'Name' }, target: '_top' } },
        { label: 'Internal Status', fieldName: 'Internal_Status__c', type: 'text' },
        { label: 'Course', fieldName: 'Course_Name__c', type: 'text' },
        { label: 'Record Type', fieldName: 'RecordType_Name', type: 'text' },
        // { label: 'Application Stage', fieldName: 'Application_Stage__c', type: 'text' },
        // { label: 'Internal Apvd. Amount', fieldName: 'Scholarship_Amount__c', type: 'currency' },
        // { label: 'Amount Funded', fieldName: 'Amount_Funded__c', type: 'currency' },
        // { label: 'Application Type', fieldName: 'Application_Type__c', type: 'text' },
        // { label: 'Year in which studying', fieldName: 'Year__c', type: 'text' },
        
        // { label: 'Financial Year', fieldName: 'RPT_Financial_Year__c', type: 'text' },
        // { label: 'Existing Application ID', fieldName: 'Existing_Application_ID__c', type: 'text' }
    ]

    @track donorApplicationColumns = [
        { label: 'Donor Application Mapping Name', fieldName: 'LinkName', type: 'url', typeAttributes: { label: { fieldName: 'Name' }, target: '_top' } },        
               
    ]
    // @track studentTrainingColumns = [
    //     { label: 'Student Training Name', fieldName: 'Name', type: 'text' },
    //     { label: 'Student Training Type', fieldName: 'Training_Code__r_Training_Type__c', type: 'text' },
    //     { label: 'Student Training Name', fieldName: 'Training_Code__r_Name', type: 'text' },
    // ]

    @track donationColumns = [
        // { label: 'Donation Name', fieldName: 'Name', type: 'text' },
        { label: 'Donation Name', fieldName: 'LinkName', type: 'url', typeAttributes: { label: { fieldName: 'Name' }, target: '_top' } },
        { label: 'Amount', fieldName: 'Amount', type: 'currency' },
        { label: 'Amount (USD)', fieldName: 'Amount_USD__c', type: 'number' },
        { label: 'Donation Program', fieldName: 'Donation_Program__c', type: 'text' },
        { label: 'Stage', fieldName: 'StageName', type: 'text' },
        { label: 'Type', fieldName: 'Type', type: 'text' },
        { label: 'Created Date', fieldName: 'CreatedDate', type: 'date' },
        { label: 'Payment Order', fieldName: 'Payment_Order__c', type: 'text' },
        { label: 'Close Date', fieldName: 'CloseDate', type: 'date' },
    ]*/

    @wire(getRecord, {recordId : '$recordId', fields : [ISALUMNI]})
    contactrec({error, data}){
        if(data){
            console.log(data);
            this.isAlumni = getFieldValue(data, ISALUMNI);
            console.log(this.isAlumni);
            if(this.isAlumni === false){
                const evt = new ShowToastEvent({
                    title: 'Note',
                    message: 'This feature pertains to only Alumni category',
                    variant: 'warning',
                });
                this.dispatchEvent(evt);
                this.dispatchEvent(new CloseActionScreenEvent());
            }
            else {
                this[NavigationMixin.GenerateUrl]({
                    type: 'standard__webPage',
                    attributes: {
                        url: '/apex/StudentDetailPage?id='+this.recordId
                    }
                }).then(url => { 
                    this.dispatchEvent(new CloseActionScreenEvent());
                    window.open(url);
                });
            }
        }
        else{
            console.log(error);
        }
    }
    
}