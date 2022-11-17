import { LightningElement,api,wire } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getRecordDetails from '@salesforce/apex/StudentCgpaForm_Controller.getRecordDetails';
import sendCgpaFormApp from '@salesforce/apex/StudentCgpaForm_Controller.sendCgpaFormApplicationLWC';

export default class SendCgpaFormNew extends LightningElement {

    @api recordId;
    applicationRec;

    @wire(getRecordDetails,{appId : '$recordId'})
    recordDetails({data,error}){
       if(data){
           this.applicationRec = data;
           this.sendcgpaForm();
           console.log('RecordId', this.applicationRec);
           console.log('Data',data);
           
   
       }else{
           console.log("Error",error,"Error12312");
       }
    }

    closePopup(){
        this.dispatchEvent(new CloseActionScreenEvent());
     }

     showToast(titl,mesg,varint){
        this.dispatchEvent(
            new ShowToastEvent({
                title: titl,
                message: mesg,
                variant: varint
            })
        );
     }

     sendcgpaForm(){
        console.log('ThirdPartycalled');
        sendCgpaFormApp({targetRecordId : this.applicationRec.Id})
                  .then((result) => {   
                    this.showToast('Success','Link sent successfully','success'); 
                    console.log(result);  
                        this.closePopup();
                  })
                  .catch((error) => {
                      this.showToast('Error',error,'error');
                     console.log(error);
                     this.closePopup();
                  });
                 
          }
}