import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord, updateRecord, getFieldValue } from 'lightning/uiRecordApi';
import { CloseActionScreenEvent } from 'lightning/actions';
import INTERNALSTATUS from '@salesforce/schema/Application__c.Internal_Status__c';
import EXTERNALSTATUS from '@salesforce/schema/Application__c.External_Status__c';
import APPLICATIONSTAGE from '@salesforce/schema/Application__c.Application_Stage__c';
import IDFIELD from '@salesforce/schema/Application__c.Id';

export default class FFEAppSelectApplicationLwc extends LightningElement {
    @api recordId;
    @track internalStatus;
    @track externalStatus;

    @wire(getRecord, {recordId : '$recordId', fields : [INTERNALSTATUS, EXTERNALSTATUS]})
    application({error, data}){
        if(data){
            
            this.template.querySelector('c-ffe-popup-lwc').addEventListener("ok", e=> this.handleConfirm(), false);          
            this.template.querySelector('c-ffe-popup-lwc').addEventListener("cancel", e=> this.handleCancel(), false);  

            console.log(data);
            this.internalStatus = getFieldValue(data, INTERNALSTATUS);
            this.externalStatus = getFieldValue(data, EXTERNALSTATUS);   

            if(this.internalStatus != 'Selected' && this.internalStatus === 'Eligible')
                this.onSucess();
            else if(this.internalStatus === 'Selected')
                this.onSelectedStatus();
            else
                this.onOtherStatus();
                
        }
        else{
            console.log(error);
        }
    } 

    onSucess(){        
        console.log(this.template.querySelector('c-ffe-popup-lwc'));
        this.template.querySelector('c-ffe-popup-lwc').showPopup('Application will be set to "Selected". Do you want to continue ?', 'Selection Confirmation', 'Confirm', 'Cancel'); 
            
    }

    onSelectedStatus(){
        console.log(this.template.querySelector('c-ffe-popup-lwc'));
        this.template.querySelector('c-ffe-popup-lwc').showPopup('Application is already selected', 'Selection Message', '', 'Cancel'); 
    }
    onSelectedStatus(){
        console.log(this.template.querySelector('c-ffe-popup-lwc'));
        this.template.querySelector('c-ffe-popup-lwc').showPopup('Application is already selected', 'Selection Message', '', 'Cancel'); 
    }
    onOtherStatus(){
        this.template.querySelector('c-ffe-popup-lwc').showPopup('Status cannot be changed', 'Selection Message', '', 'Cancel'); 
    }

    handleConfirm(){
        
        const fields = {};
        fields[IDFIELD.fieldApiName] = this.recordId;
        fields[APPLICATIONSTAGE.fieldApiName] = 'Active';
        fields[INTERNALSTATUS.fieldApiName] = 'Selected';

        const recordInput = { fields };

        updateRecord(recordInput)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Application is selected!!!',
                        variant: 'success'
                    })
                );
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: 'Error Occured while updating record.',
                        variant: 'error'
                    })
                );
            });     
        this.dispatchEvent(new CloseActionScreenEvent());   
    }
    handleCancel(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}