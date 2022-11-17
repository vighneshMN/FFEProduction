import { api, wire, track, LightningElement } from 'lwc';
import { getRecord, getRecordNotifyChange, getFieldValue } from 'lightning/uiRecordApi';
import { CloseActionScreenEvent } from 'lightning/actions';
import ISKYCVERIFIED from '@salesforce/schema/Contact.KYC_Verified__c';
import ACTIVEAPPLICATION from '@salesforce/schema/Contact.Active_Application_ID__c';
import verifyKYC from '@salesforce/apex/FFE_KYC_Verification.verifyKYCLWC';


export default class FEE_CON_KYCVerifiedLWC extends LightningElement {
    @api recordId;
    @track isKYCVerified;
    @track activeApplication; 

    @wire(getRecord, {recordId : '$recordId', fields : [ISKYCVERIFIED, ACTIVEAPPLICATION]})
    student({error, data}){
        console.log('record id' + this.recordId);
        console.log(data);
        if(data){ 
            this.template.querySelector('c-ffe-popup-lwc').addEventListener("ok", e=> this.handleOk(), false);          
            //console.log('getting student id' + data.Fields.Student__c.value);
            this.isKYCVerified = getFieldValue(data, ISKYCVERIFIED);
            this.activeApplication = getFieldValue(data, ACTIVEAPPLICATION);
            if (this.isKYCVerified){
                this.handleKYCVerified ();
                return; 
            }
            if (this.activeApplication != null && this.activeApplication != '')
            {
                verifyKYC({contactId : this.recordId})
                    .then((result) => {        
                        this.onSuccessfulKYC (); 
                
                    })
                    .catch((error) => {
                        this.onFailedKYC(); 
                    });

            }
            else{
                this.handleNoActiveApp (); 
            }  
        }
        else{
            console.log('error while getting student id' + error);
        }
    }

    onSuccessfulKYC (){
        this.template.querySelector('c-ffe-popup-lwc').showPopup ('KYC Verified', 'KYC Verification', 'OK', ''); 
    }

    onFailedKYC (){
        this.template.querySelector('c-ffe-popup-lwc').showPopup ('Opps!! Something went wrong.', 'KYC Verification', 'OK', ''); 
    }

    handleNoActiveApp (){
        this.template.querySelector('c-ffe-popup-lwc').showPopup ('There is no active application for this student', 'KYC Verification', 'OK', '');
    }
    
    handleKYCVerified (){
        this.template.querySelector('c-ffe-popup-lwc').showPopup ('KYC is already verified', 'KYC Verification', 'OK', '');
    }

    handleOk (){
        getRecordNotifyChange([{recordId: this.recordId}]);
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}