import { LightningElement, } from 'lwc'; // wire, api
/*import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import sendDeclarationForm from '@salesforce/apex/DeclarationFormController.sendDeclarationEmail';
import STUDENTID from '@salesforce/schema/Application__c.Student__c';*/

export default class FFE_AP_SendDeclarationFormLWC extends LightningElement {
    /*@api recordId;
    @api messageToShow;

    @wire(getRecord, { recordId: '$recordId', fields: [STUDENTID]})
    application;

    get studentId() {
        return getFieldValue(this.application.data, STUDENTID);
    }

    @wire(sendDeclarationForm, { targetRecordId: '$studentId' , whatId : '$recordId'})
    response({error, data}){
        if(data){
            if(data === 'SUCCESS'){
                this.messageToShow = 'Declaration form sent successfully';
            }
            else{
                this.messageToShow = 'Couldn\'t send Declaration form';
            }
        }
        else{
            this.messageToShow = 'Couldn\'t send Declaration form';
        }
    }*/
}