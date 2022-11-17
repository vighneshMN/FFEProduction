import { LightningElement, api, wire, track  } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { updateRecord } from 'lightning/uiRecordApi';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import ALTERNATEEMAIL_FIELD from '@salesforce/schema/Contact.Alumni_Email__c';
import ID_FIELD from '@salesforce/schema/Contact.Id';
import { CloseActionScreenEvent } from 'lightning/actions';

const FIELDS = ['Contact.Email', 'Contact.Alumni_Email__c'];
export default class FFEConfirmAlumni extends LightningElement {
    contact;
    @track showDialog = true;
    @track displayMessage = '';
    @api recordId;
    @track conEmail='';
    @track alternateEmail='';

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredRecord({ error, data }) {
        if (error) {
            console.log('error'+error);
            let message = 'Unknown error';
            if (Array.isArray(error.body)) {
                message = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                message = error.body.message;
            }
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error loading contact',
                    message,
                    variant: 'error',
                }),
            );
        } else if (data) {
            console.log('data'+JSON.stringify(data));
            this.contact = data;
            this.conEmail = this.contact.fields.Email.value;
            console.log('this.conEmail'+this.conEmail);
            this.alternateEmail = this.contact.fields.Alumni_Email__c.value;
            if(this.conEmail==this.alternateEmail){
                this.showDialog = false;
            }
            console.log('this.alternateEmail'+this.alternateEmail);
        }
    }
/*
    @wire(getContactEmails,{recordId:'$recordId'})
    wiredContacts({ error, data }) {
        if (data) {
            
            console.log('data' + data);
            
            for(i=0;i<data.length;i++){
                 this.conEmail =  data[i].Email;
                 this.alternateEmail = data[i].Alumni_Email__c;
             }
            this.error = undefined;
            this.showparent = true;
           
        } else if (error) {
            console.log('error' + error);
            this.error = error;
            this.Objects = undefined;
            this.showparent = false;
        }
    }
*/
        handleCancel(event){
            this.dispatchEvent(new CloseActionScreenEvent());
        }

    handleConfirm(event){
        const fields = {};
        fields[ID_FIELD.fieldApiName] = this.recordId;
        fields[EMAIL_FIELD.fieldApiName] = this.alternateEmail;
       
        const recordInput = { fields };

        updateRecord(recordInput)
                .then(() => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Contact updated',
                            variant: 'success'
                        })
                    );
                  
                })
                this.dispatchEvent(new CloseActionScreenEvent());    
            
    }
    
}