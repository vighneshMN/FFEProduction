import { LightningElement,api,wire } from 'lwc';
import getDonationsList from '@salesforce/apex/ffePaymentGenerate80GForm_CTRL.getDonationsLwc';
import getBase64encoded from '@salesforce/apex/ffePaymentGenerate80GForm_CTRL.getBase64encoded';
import { CloseActionScreenEvent } from 'lightning/actions';
import send80GForm from '@salesforce/apex/SendITCertificate.send80GFormLwc';

export default class FfeSend80GForm extends LightningElement {
    @api recordId;
    isTaxExemptionFormVisible = false;

    @wire(getDonationsList, {paymentId : '$recordId'})
    donationAvailability({error, data}){
        if(data){
            if(data != 'Donation is available.'){
                this.template.querySelector('c-ffe-popup-lwc').addEventListener("ok", e=> this.handleOk(), false);
                this.template.querySelector('c-ffe-popup-lwc').showPopup (data, 'Generate 80G Form', 'OK', '');
            }else{
                this.isTaxExemptionFormVisible = true;
            }
        }else{
            console.log('error while getting donation details' + error);
        }
    }

    handleOk (){
        //getRecordNotifyChange([{recordId: this.recordId}]);
        this.dispatchEvent(new CloseActionScreenEvent());
    }
    handleContinue (){
        send80GForm({paymentId: this.recordId})
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
            console.log ('Error');
            console.log(error);
        })
    }
}