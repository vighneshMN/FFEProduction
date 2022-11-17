import { api, LightningElement, wire, track } from 'lwc';
import { getRecord, getRecordNotifyChange, getFieldValue } from 'lightning/uiRecordApi';
import ContactId from '@salesforce/schema/Contact.Id';
import getFiscalYears from '@salesforce/apex/SendDeclarationFormBatch.getFiscalYearsLWC';
import initiateDeclarationBatch from '@salesforce/apex/SendDeclarationFormBatch.initiateDeclarationBatchLWC';
export default class FEE_Contact_DeclarationFormLWC extends LightningElement {
    @api recordId;
    @track val='';
    @track fYear;//='';
    @track error;
    @track contactId;
    @track FYYears;// = [];
    @wire(getRecord, {recordId : '$recordId', fields : [ContactId]})
    contact({error, data}){
        console.log('record id....' + this.recordId);
        console.log(data);
        if(data){
            this.template.querySelector('c-ffe-popup-lwc').addEventListener("ok", e=> this.handleOk(), false);          
            
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
                console.log(data);
                this.FYYears = data; 
                let options = [];
                 
                for (var key in data) {
                    // Here key will have index of list of records starting from 0,1,2,....
                    options.push({ label: data[key], value: data[key] });
 
                    
                }
                this.fYear = options;
                 
            } catch (error) {
                console.error('check error here', error);
            }
        } else if (error) {
            console.error('check error here', error);
        }
 
    }
   /* get FYear(){   
    getFiscalYears()
		.then(result => {result.forEach(opt => { 
            const option = {
                label: opt,
                value: opt
            };
            //console.log('opt'+opt);
            this.FYYears = [ ...this.FYYears, option];
           
        });
			//this.FYYear = result;
			this.error = undefined;
		})/*
		.catch((error) => {
            console.log(error);
            return null;
        });
        return this.FYYears;
    }*/

    handleChange(event) {
        this.val = event.detail.value;
        console.log(this.val);
     }
     handleSend(event){
         console.log('contactId'+this.contactId)
         console.log('year'+this.val)
        initiateDeclarationBatch({donorId : this.contactId, fiscalYear : this.val})
        .then((result) => {        
            console.log('in wire method');
        })
        .catch((error) => {
            console.log(error);
            
        });
     }

}