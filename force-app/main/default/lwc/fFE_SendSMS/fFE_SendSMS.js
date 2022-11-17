import { LightningElement,api,track } from 'lwc';
import sendmobileSMS from '@salesforce/apex/CustomizeEmails.sendmobileSMS';

export default class FFE_SendSMS extends LightningElement {
    mobileNumber='';
    smsMessage='';
    errormessage='';
    resultString='';
    handleChange(event){
        this.mobileNumber = event.detail.value ;
    }

    handlemessageChange(event){
        this.smsMessage = event.detail.value;
    }

    validate(){
       this.errormessage = '';
       console.log('this.errormessage'+this.errormessage);
       console.log('this.mobileNumber'+this.mobileNumber);
       console.log('this.smsMessage'+this.smsMessage);
       if(this.mobileNumber.length===0 && this.smsMessage.length===0){
            this.errormessage = 'Mobile No and SMS are Required';
       }
       else if(this.mobileNumber.length===0){
            this.errormessage = 'Mobile No is Required';
        }else if(this.smsMessage.length===0){
            this.errormessage = 'Message is required';
        }
        console.log('this.errormessage'+this.errormessage);
    }

    handleClick(){
        this.validate();
        
        if(this.errormessage.length===0){
            sendmobileSMS({ phone: this.mobileNumber,Msg:this.smsMessage })
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