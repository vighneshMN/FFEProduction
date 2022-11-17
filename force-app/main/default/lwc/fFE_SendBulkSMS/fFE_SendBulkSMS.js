import { LightningElement,api,track } from 'lwc';
import sendSMSDuringEvent from '@salesforce/apex/WebServiceButtonHelper.sendSMSDuringEvent';

export default class FFE_SendBulkSMS extends LightningElement {
    
    smsMessage='';
    errormessage='';
    resultString='';
    @api selectedcontacts;
   
    handlemessageChange(event){
        this.smsMessage = event.detail.value;
    }

    validate(){
       this.errormessage = '';
       console.log('this.errormessage'+this.errormessage);
       console.log('this.selectedcontactslength'+this.selectedcontacts.length);
        console.log('this.smsMessage'+this.smsMessage);
        if(this.smsMessage.length===0){
            this.errormessage = 'Message is required';
        } else if(this.selectedcontacts.length<10){
            this.errormessage = 'Please select atleast one record';
        }
        console.log('this.errormessagelength'+this.errormessage.length);
    }

    handleClick(){
        this.validate();
        
        if(this.errormessage.length===0){
            sendSMSDuringEvent({ ContactNumberID:this.selectedcontacts,messageForEvent:this.smsMessage })
            .then((result) => {
                this.resultString = result;
                console.log(this.resultString);
                alert(this.resultString);
               
            })
            .catch((error) => {
                 this.resultString = undefined;
                 alert(this.resultString);
            });
        }else{
            alert(this.errormessage);
        }
    }

}