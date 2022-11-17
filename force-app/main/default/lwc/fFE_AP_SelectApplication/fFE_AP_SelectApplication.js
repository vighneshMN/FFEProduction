import { LightningElement, api, track, wire } from 'lwc';
import { getRecord, updateRecord, getFieldValue } from 'lightning/uiRecordApi';
import { CloseActionScreenEvent } from 'lightning/actions';
import INTERNALSTATUS from '@salesforce/schema/Application__c.Internal_Status__c';
import EXTERNALSTATUS from '@salesforce/schema/Application__c.External_Status__c';
import APPLICATIONSTAGE from '@salesforce/schema/Application__c.Application_Stage__c';
import IDFIELD from '@salesforce/schema/Application__c.Id';

export default class FFE_AP_SelectApplication extends LightningElement {
    @api recordId;
    @track messageToShow;
    @track isModalOpen;
    @track internalStatus;
    @track externalStatus;

    @wire(getRecord, {recordId : '$recordId', fields : [INTERNALSTATUS, EXTERNALSTATUS]})
    application({error, data}){
        if(data){
            console.log(data);
            this.internalStatus = getFieldValue(data, INTERNALSTATUS);
            this.externalStatus = getFieldValue(data, EXTERNALSTATUS);
        }
        else{
            console.log(error);
        }
    } 
    
    handleCancel(event){
        this.isModalOpen = false;
        getRecordNotifyChange([{recordId: this.recordId}]);
        this.dispatchEvent(new CloseActionScreenEvent());
    }
    
    handleUpdate(){
        console.log('inside update method');
        const fields = {};
        fields[IDFIELD.fieldApiName] = this.recordId;
        fields[INTERNALSTATUS.fieldApiName] = 'Selected';
        fields[APPLICATIONSTAGE.fieldApiName] = 'Active';

        const recordInput = { fields };

        updateRecord(recordInput)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Application updated',
                        variant: 'success'
                    })
                );
                // Display fresh data in the form
                return refreshApex(this.application);
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error while updating record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}