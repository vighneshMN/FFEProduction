import { api, LightningElement, wire, track } from 'lwc';
import { getRecord, getRecordNotifyChange, getFieldValue } from 'lightning/uiRecordApi';
import { CloseActionScreenEvent } from 'lightning/actions';
import STUDENTID from '@salesforce/schema/Application__c.Student__c';
import DONORID from '@salesforce/schema/Application__c.DonorID__c';
import sendDeclarationForm from '@salesforce/apex/DeclarationFormController.sendDeclarationEmailLWC';

//const FIELDS = ['Application__c.Student__c'];

export default class FEE_AP_DeclarationFormLWC extends LightningElement {
    @api recordId;
    @track messageToShow;
    @track isModalOpen;
    @track studentId;
    @track donorId;


    @wire(getRecord, {recordId : '$recordId', fields : [STUDENTID,DONORID]})
    application({error, data}){
        console.log('record id' + this.recordId);
        console.log(data);
        if(data){
            this.template.querySelector('c-ffe-popup-lwc').addEventListener("ok", e=> this.handleOk(), false);          
            //console.log('getting student id' + data.Fields.Student__c.value);
            this.studentId = getFieldValue(data, STUDENTID);
            this.donorId = getFieldValue(data,DONORID);
            console.log(this.studentId);            
            this.sendDeclaration();
        }
        else{
            console.log('error while getting student id' + error);
        }
    }    

    sendDeclaration(){
       sendDeclarationForm({targetRecordId : this.studentId, whatId : this.recordId, donorUId : this.donorId})
            .then((result) => {        
                console.log('in wire method');
                this.onSuccessfulKYC (); 
            })
            .catch((error) => {
                console.log(error);
                this.onFailedKYC();
            });
            
    }

    onSuccessfulKYC (){
        this.template.querySelector('c-ffe-popup-lwc').showPopup ('Declaration form sent successfully', 'Declaration Form', 'OK', ''); 
    }

    onFailedKYC (){
        this.template.querySelector('c-ffe-popup-lwc').showPopup ('Couldn\'t send Declaration form.', 'Declaration Form', 'OK', ''); 
    }

    handleOk() {
        getRecordNotifyChange([{recordId: this.recordId}]);
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}

/*

if(result === 'SUCCESS'){
                this.messageToShow = 'Declaration from Sent successfully';
                console.log('got success');
            }
            else{
                this.messageToShow = 'Couldn\'t send Declaration form';
                console.log('not got success');
            }*/