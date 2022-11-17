import { LightningElement,api,wire } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getRecordDetails from '@salesforce/apex/StudentCgpaForm_Controller.getRecordDetails';

import sendCgpaFormApplicationLWC from '@salesforce/apex/StudentCgpaForm_Controller.sendCgpaFormApplicationLWC';


export default class SendCGPAFormLWC extends LightningElement {
    @api recordId;
    applicationRec;

    @wire(getRecordDetails,{appId : '$recordId'})
    recordDetails({data,error}){
       if(data){
           this.applicationRec = data;
           console.log('RecordId', this.applicationRec);
           console.log('Data',data);
           this.sendcgpaForm();
   
       }else{
           console.log("Error",error);
       }
    }

    closePopup(){
        this.dispatchEvent(new CloseActionScreenEvent());
     }

     showToast(title,message,variant){
        this.dispatchEvent(
            new ShowToastEvent({
                title: this.title,
                message: this.message,
                variant: this.variant
            })
        );
     }

     sendcgpaForm(){
        console.log('ThirdPartycalled');
        sendCgpaFormApplicationLWC({targetRecordId : this.applicationRec.Id})
                  .then((result) => {   
                    console.log(result);  
                    this.showToast('Success','Link sent successfully','success'); 
                        this.closePopup();
                  })
                  .catch((error) => {
                      this.showToast('Error',error,'error');
                     console.log(error);
                     this.closePopup();
                  });
                 
          }
}