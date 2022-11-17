import { LightningElement,api,wire } from 'lwc';
import getDonationsList from '@salesforce/apex/ffePaymentGenerate80GForm_CTRL.getDonationsLwc';
import getBase64encoded from '@salesforce/apex/ffePaymentGenerate80GForm_CTRL.getBase64encoded';
import { CloseActionScreenEvent } from 'lightning/actions';
import { loadScript } from 'lightning/platformResourceLoader';
import downloadjs from '@salesforce/resourceUrl/DownloadJs';

export default class FfeGenerate80GForm extends LightningElement {
    @api recordId;
    downloadjsInitialized = false;
    isTaxExemptionFormVisible = false;
    renderedCallback(){
        if(this.downloadjsInitialized){
            return;
        }
        this.downloadjsInitialized = true;
        loadScript(this, downloadjs)
        .then(() => console.log('Loaded download.js'))
        .catch(error => console.log(error));
    }
    @wire(getDonationsList, {paymentId : '$recordId'})
    donationAvailability({error, data}){
        if(data){
            console.log (data); 
            if(data != 'Donation is available.'){
                this.template.querySelector('c-ffe-popup-lwc').addEventListener("ok", e=> this.handleOk(), false);
                this.template.querySelector('c-ffe-popup-lwc').showPopup (data, 'Generate 80G Form', 'OK', '');
            }else{
                console.log ('else'); 
                this.isTaxExemptionFormVisible = true;
                getBase64encoded({paymentId : this.recordId})
                .then(result =>{
                    console.log ('result:: ' + result);
                    this.showSpinner = false;
                    for(let i = 0 ;i < result.length; i++){
                        var strFile = "data:application/pdf;base64,"+result[i];
                        download(strFile,'TaxExemptionForm', "application/pdf");
                    }
                    this.handleOk();
                })
                .catch(error =>{
                    console.log('Error  ', error);
                    this.showSpinner = false;
                })
            }
        }else{
            console.log('error while getting donation details' + error);
        }
    }

    handleOk (){
        //getRecordNotifyChange([{recordId: this.recordId}]);
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}