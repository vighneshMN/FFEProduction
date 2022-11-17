import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import { CloseActionScreenEvent } from 'lightning/actions';
import { getRecord } from 'lightning/uiRecordApi';

import getRefundDetails from '@salesforce/apex/FFE_AP_InitiateRefundClass.getRefundDetails';
import getApplicationDetails from '@salesforce/apex/FFE_AP_InitiateRefundClass.getApplicationDetails';
import processRecords from '@salesforce/apex/FFE_AP_InitiateRefundClass.processRecords';

export default class FFE_AP_RejectApplicationLWC extends NavigationMixin(LightningElement) {
    
    @api recordId;
    @api objectApiName;
    @track refundRec;
    @track error;
    appList;
    errors;
    processResult;
    recordPageUrl;
    refundNewRecId;
    //Boolean tracked variable to indicate if modal is open or not default value is false as modal is closed when page is loaded 
    @track isModalOpen = false;
      
      @wire(getRefundDetails, { recordId: '$recordId' }) 
      refundsList({ error, data }) {
        if (data) {
            this.refundRec = data;
            if(this.refundRec.length != 0){
                this.showNotification();
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
        .then(result => {
            this.processResult = result;
            this.refundNewRecId = result[0].Id;
            this.error = undefined;
            this.navigateToRefundPage();         
        });
    }

    showNotification() {
        const evt = new ShowToastEvent({
            title: 'Warning!',
            message: 'Refund has been already Initiated',
            variant: 'warning',
        });
        this.dispatchEvent(evt);
        this.closeQuickAction();
    }

    navigateToRefundPage() {
        // View a custom object record.
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.refundNewRecId,
                actionName: 'view'
            }
        });
    }

    verifyApplication() {
        getApplicationDetails({recordId: this.recordId })
        .then((result) => {
            this.appList = result;
            this.error = undefined;
            if(this.appList[0].Internal_Status__c == "Disbursed" &&
            this.appList[0].Application_Stage__c == "Closed"){
                this.openModal();
            }else{
                const evt = new ShowToastEvent({
                    title: 'Warning!',
                    message: 'Refund can be initiated for disbursed application only.',
                    variant: 'warning',
                });
                this.dispatchEvent(evt);
                getRecordNotifyChange([{recordId: this.recordId}]);
                this.closeQuickAction();
            }
        })
        .catch((error) => {
            this.error = error;
            this.appList = undefined;
        });
    }
    closeQuickAction() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }    
}