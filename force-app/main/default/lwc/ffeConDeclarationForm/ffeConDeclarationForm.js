import { api, LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord, getRecordNotifyChange, getFieldValue } from 'lightning/uiRecordApi';
import { CloseActionScreenEvent } from 'lightning/actions';
import ContactId from '@salesforce/schema/Contact.Id';
import getFiscalYears from '@salesforce/apex/SendDeclarationFormBatch.getFiscalYearsLWC';
import initiateDeclarationBatch from '@salesforce/apex/SendDeclarationFormBatch.initiateDeclarationBatchLWC';
export default class FfeConDeclarationForm extends LightningElement {
    @api recordId;
    @track val='';
    @track fYear;//='';
    @track error;
    isModalOpen = true; 
    @track contactId;
    options = []; 
    @track FYYears;// = [];
    @wire(getRecord, {recordId : '$recordId', fields : [ContactId]})
    contact({error, data}){
        console.log('record id....' + this.recordId);
        console.log(data);
        if(data){ 
            this.contactId = getFieldValue(data, ContactId);
            console.log(this.contactId); 
        }
        else{
            console.log('error while getting con id' + error);
        }
    } 
    @wire(getFiscalYears, {})
    WiredFYears({ error, data }) {
 
        if (data) {
            try {
                this.FYYears = data; 
                               
                for (var key in data) {
                    // Here key will have index of list of records starting from 0,1,2,....
                    this.options.push({ label: data[key], value: data[key] });
                }
                this.fYear = this.options;
                
            } catch (error) {
                console.error('check error here', error);
            }
        } else if (error) {
            console.error('check error here', error);
        }
 
    }

    onSuccessfulInitiation (result){
        this.template.querySelector('c-ffe-popup-lwc').addEventListener("ok", e=> this.handleOk(), false);  
        this.template.querySelector('c-ffe-popup-lwc').showPopup (result, 'Declaration Form', 'OK', ''); 
    }

    onFailedInitiation (){
        this.template.querySelector('c-ffe-popup-lwc').addEventListener("ok", e=> this.handleOk(), false);  
        this.template.querySelector('c-ffe-popup-lwc').showPopup ('Couldn\'t send Declaration form.', 'Declaration Form', 'OK', ''); 
    }

    handleChange(event) {
        this.val = event.target.value;
        console.log(event.target.value);
     }
     handleSend(event){
         console.log('contactId'+this.contactId)
         console.log('year'+this.val)
         if(this.val === ''){
             const select = this.template.querySelector('[data-id="sell"]');
             this.val= select.value;
         }
        initiateDeclarationBatch({donorId : this.contactId, fiscalYear : this.val})
        .then((result) => {        
            console.log('in wire method'+result);
            this.onSuccessfulInitiation (result); 
        })
        .catch((error) => {
            console.log(error);            
            this.onFailedInitiation();
        });         
        this.isModalOpen = false;
     }
     handleOk() {
        getRecordNotifyChange([{recordId: this.contactId}]);
        this.dispatchEvent(new CloseActionScreenEvent());
    }

}