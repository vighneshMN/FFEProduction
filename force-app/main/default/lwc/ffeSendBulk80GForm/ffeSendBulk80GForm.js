import { api, wire, LightningElement } from 'lwc';
import { getRecord, getRecordNotifyChange, getFieldValue } from 'lightning/uiRecordApi';
import { CloseActionScreenEvent } from 'lightning/actions';
import sendBulkForm from '@salesforce/apex/WebServiceButtonHelper.sendBulk80GFormLwc';
import OPPAMT from '@salesforce/schema/Opportunity.Amount';
import CONTOTALAMT from '@salesforce/schema/Opportunity.Contributors_Total_Amount__c';
import STAGENAME from '@salesforce/schema/Opportunity.StageName';

export default class FfeSendBulk80GForm extends LightningElement {
    @api recordId;
 
    @wire(getRecord, {recordId : '$recordId', fields : [OPPAMT, CONTOTALAMT, STAGENAME]})
    donation({error, data}){
        if(data){
            let oppAmt = getFieldValue(data, OPPAMT) == null ? 0 : getFieldValue(data, OPPAMT); 
            let amount = Math.trunc (oppAmt);
            let contAmount = getFieldValue(data, CONTOTALAMT); 
            if (amount == contAmount){
                let stageName = getFieldValue(data, STAGENAME);
                if (stageName == 'Posted'){
                    this.template.querySelector('c-ffe-popup-lwc').addEventListener("ok", e=> this.handleContinue(), false);
                    this.template.querySelector('c-ffe-popup-lwc').addEventListener("cancel", e=> this.handleOk(), false);
                    this.template.querySelector('c-ffe-popup-lwc').showPopup ('80G form will be sent to all Contributors. Please click continue to proceed.', 'Send 80G Form', 'Continue', 'Cancel'); 
                }
                else{
                    this.template.querySelector('c-ffe-popup-lwc').addEventListener("ok", e=> this.handleOk(), false);          
                    this.template.querySelector('c-ffe-popup-lwc').showPopup ('Please make sure donation is in "Posted" stage.', 'Send 80G Form', 'OK', '');     
                }
            }
            else{
                this.template.querySelector('c-ffe-popup-lwc').addEventListener("ok", e=> this.handleOk(), false);
                this.template.querySelector('c-ffe-popup-lwc').showPopup ('Total contributed amount should be equal to Donation amount.', 'Send 80G Form', 'OK', ''); 
            }
        }
        else{
            console.log('error while getting donation details' + error);
        }
    }

    handleOk (){
        //getRecordNotifyChange([{recordId: this.recordId}]);
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    handleContinue(){
       sendBulkForm({OpportuniytId: this.recordId})
        .then(result =>{
            if (result !=''){
                this.template.querySelector('c-ffe-popup-lwc').addEventListener("ok", e=> this.handleOk(), false); 
                this.template.querySelector('c-ffe-popup-lwc').showPopup (result, 'Send 80G Form', 'OK', '');
            }
            else{
                this.handleOk(); 
            }
        })
        .catch(error =>{
            this.showToast ('Error', 'Something went wrong.', 'error', 'dismissable');
        })
    }
}