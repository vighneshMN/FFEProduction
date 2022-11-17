import { LightningElement,api,track } from 'lwc';
import sendEmailMessages from '@salesforce/apex/CustomizeEmails.sendEmailMessages';

export default class FFE_SendEmail extends LightningElement {
    emailAddress='';
    emailMessage='';
    errormessage='';
    resultString='';
    handleChange(event){
        this.emailAddress = event.detail.value ;
    }

    handlemessageChange(event){
        this.emailMessage = event.detail.value;
    }

    validate(){
       this.errormessage = '';
       console.log('this.errormessage'+this.errormessage);
       console.log('this.emailAddress'+this.emailAddress);
       console.log('this.smsMessage'+this.emailMessage);
       if(this.emailAddress.length===0 && this.emailMessage.length===0){
            this.errormessage = 'Email Id and Message are Required';
       }
       else if(this.emailAddress.length===0){
            this.errormessage = 'Email Id is Required';
        }else if(this.emailMessage.length===0){
            this.errormessage = 'Email Message is required';
        }
        console.log('this.errormessage'+this.errormessage);
    }

    handleClick(){
        this.validate();
        
        if(this.errormessage.length===0){
            sendEmailMessages({ emailid: this.emailAddress,Msg:this.emailMessage })
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