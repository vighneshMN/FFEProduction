import { LightningElement, wire, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import GauNameDetailsLwc from '@salesforce/apex/NotifyStudentHelper.GauNameDetailsLwc';
import currentTenFinancialYearexcludingThisLwc from '@salesforce/apex/NotifyStudentHelper.currentTenFinancialYearexcludingThisLwc';
import sendNotify_NewLwc from '@salesforce/apex/NotifyStudentHelper.sendNotify_NewLwc';

export default class FfeNotifyStudentsLwc extends LightningElement {
    gauNamesOptions = [];
    gauNameSelected;
    financialYearOptions = [];
    financialYearSelected;
    sendEmail = false;
    sendSms = false;
    emailMessage;
    smsMessage;
    errorMessage;
    showSpinner = false;
    @api recordId;

    @wire(GauNameDetailsLwc)
    wiredGauNameList({error, data}){
        if(data){
            for(const valueObject of data){
                this.gauNamesOptions = [...this.gauNamesOptions,{value: valueObject,label: valueObject}];
            }
            if(this.gauNamesOptions.length > 0){
                this.gauNameSelected = this.gauNamesOptions[0].label;
            }
        }else if(error){
            console.log('Error in wired gau name ', error);
        }
    }

    @wire (currentTenFinancialYearexcludingThisLwc)
    wiredFyear({error, data}){
        if(data){
            console.log('Data ' , data);
            for(const valueObject of data){
                this.financialYearOptions = [...this.financialYearOptions,{value: valueObject,label: valueObject}];
            }
            if(this.financialYearOptions.length > 0){
                this.financialYearSelected = this.financialYearOptions[0].label;
            }
        }else if(error){
            console.log('Error in get year ', error);
            
        }
    }

    handleGauChange(event){
        this.gauNameSelected = event.detail.value;
    }

    handleYearChange(event){
        this.financialYearSelected = event.detail.value;
    }

    handleSendEmailChange(event){
        this.sendEmail = event.target.checked;
    }

    handleSendSmsChange(event){
        this.sendSms = event.target.checked;
    }

    handleEmailMessageChange(event){
        console.log('handleEmailMessageChange');
        this.emailMessage = event.detail.value;
    }

    handleSmsMessageChange(event){
        console.log('handleSmsMessageChange');
        this.smsMessage = event.detail.value;
    }

    handleSendClick(){
        this.showSpinner = true;
        this.errorMessage = '';
        console.log('Send clicked');
        console.log('Send email ',this.sendEmail);
        console.log('Send sms ',this.sendSms);
        console.log('Sms message ',this.smsMessage);
        console.log('email message ',this.emailMessage);
        if(this.gauNameSelected == null || this.gauNameSelected == '' || this.gauNameSelected == undefined || this.financialYearSelected == null
            || this.financialYearSelected == '' || this.financialYearSelected == undefined ){
                this.errorMessage = 'Please select both GAU and Financial Year';
                this.showSpinner = false;
                return;    
        }else if(this.sendEmail == false && this.sendSms == false){
            this.errorMessage = 'Please select at least one checkbox';
            this.showSpinner = false;
            return;
        }else if(this.sendEmail == true && (this.emailMessage == null || this.emailMessage == undefined || this.emailMessage == '')){
            this.errorMessage = 'Email Message is Required';
            this.showSpinner = false;
            return;
        }else if(this.sendSms == true && (this.smsMessage == null || this.smsMessage == undefined || this.smsMessage == '')){
            this.errorMessage = 'SMS Message is Required';
            this.showSpinner = false;
            return;
        }else{
            sendNotify_NewLwc({Fyear:this.financialYearSelected, gau:this.gauNameSelected, msg:this.emailMessage,
                               ContactId: this.recordId, smsMsg:this.smsMessage, smsCheckBoxValue:this.sendSms, emailCheckBoxValue:this.sendEmail})
            .then(result =>{
                console.log('Sendnotify success '+ result);
                if(result.includes("Successfully ")){
                    const evt = new ShowToastEvent({
                                    title: 'Success',
                                    message: result,
                                    variant: 'success'
                                });
                    this.dispatchEvent(evt);
                    this.dispatchEvent(new CloseActionScreenEvent());
                    this.showSpinner = false;            
                }else{
                    const evt = new ShowToastEvent({
                                    title: 'Error',
                                    message: result,
                                    variant: 'error'
                                });
                    this.dispatchEvent(evt);
                    this.showSpinner = false;    
                }
            })
            .catch(error =>{
                console.log('Error '+ error);
            })
        }
    }

    get showError(){
        return this.errorMessage ? true : false;
    }
}