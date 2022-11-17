import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import { getRecord, getRecordNotifyChange } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { CloseActionScreenEvent } from 'lightning/actions';

import getApplicationDetails from '@salesforce/apex/FFE_AP_RejectApplicationClass.getApplicationDetails';
import processRecords from '@salesforce/apex/FFE_AP_RejectApplicationClass.processRecords';

export default class FFE_AP_RejectApplicationLWC extends NavigationMixin(LightningElement) {
    
    @api recordId;
    @api objectApiName;
    @track refundRec;
    @track error;
    appList;
    errors;
    processResult;
    recordPageUrl;
    //Boolean tracked variable to indicate if modal is open or not default value is false as modal is closed when page is loaded 
    @track isModalOpen = false;
      
      @wire(getApplicationDetails, { recordId: '$recordId' }) 
      refundsList({ error, data }) {
        if (data) {
            this.appRec = data;
            if(this.appRec != undefined){
                if(this.appRec[0].Internal_Status__c != 'Pending_Approval'){
                    if (this.appRec[0].External_Status__c != 'Approved') {
                        if(this.appRec[0].Application_Stage__c != 'Closed'
                        || this.appRec[0].Internal_Status__c != 'Rejected by FFE Staff'){
                            if(this.appRec[0].Internal_Status__c != 'Funded') {
                                this.openModal();
                            }else{
                                this.showNotification();
                            }
                        }else{
                            this.showNotification();
                        }
                    }
                }
            }else{
                this.verifyApplication();
            }

        } else if (error) {
            this.error = error;
        }
    }

    openModal() {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
        this.closeQuickAction();
    }
    processRecord() {
        processRecords({recordId: this.recordId })
        .then((result) => {
            this.processResult = result;
            this.error = undefined;
            this.isModalOpen = false;
            getRecordNotifyChange([{recordId: this.recordId}]);            
            this.closeQuickAction();
        })
        .catch((error) => {
            this.error = error;
            this.processResult = undefined;
        });
    }
    showNotification() {
        const evt = new ShowToastEvent({
            title: 'Warning!',
            message: 'Application is already Closed',
            variant: 'warning',
        });
        this.dispatchEvent(evt);
        this.closeQuickAction();
    }
    closeQuickAction() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

}