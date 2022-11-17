import { LightningElement,api,wire } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import getRecordDetails from '@salesforce/apex/StudentbankDetails_Controller.getRecordDetails';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import sendBankDetail from '@salesforce/apex/StudentbankDetails_Controller.sendBankDetailEmailLWC';


export default class SendBankDetailNew extends LightningElement {
     @api recordId;
     contactRec;


 @wire(getRecordDetails,{contactId : '$recordId'})
 recordDetails({data,error}){
    if(data){
        this.contactRec = data;
        console.log('RecordId', this.contactRec);
        console.log('Data',data);
        this.sendBankDetailLink();

    }else{
        console.log("Error",error);
    }
 }



 closePopup(){
    this.dispatchEvent(new CloseActionScreenEvent());
 }



 showToast(titles,messages,variants){
    this.dispatchEvent(
        new ShowToastEvent({
            title: titles,
            message: messages,
            variant: variants
        })
    );
 }

     sendBankDetailLink(){
        console.log('ThirdPartycalled');
             sendBankDetail({targetRecordId : this.contactRec.Id})
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