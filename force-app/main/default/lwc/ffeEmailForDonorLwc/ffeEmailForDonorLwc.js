import { LightningElement, api, wire } from 'lwc';
import currentTenFinancialYearexcludingThisLwc from '@salesforce/apex/NotifyStudentHelper.currentTenFinancialYearexcludingThisLwc';
import emailNotificationForUsDonorLwc from '@salesforce/apex/WebServiceButtonHelper.emailNotificationForUsDonorLwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

export default class FfeEmailForDonorLwc extends  NavigationMixin(LightningElement) {
    @api selectedcontacts;
    showSpinner = false;
    showError = false;
    financialYearOptions = [];
    financialYearSelected = [];
    emailIds;
    emailSubject;
    emailMessage;
    errormessage;
    showSuccess = false;
    successMessage ;
    
    // renderedCallback(){
    //     console.log('Rendered callback called');
    //     console.log(this.selectedcontacts);

    // }

    @wire (currentTenFinancialYearexcludingThisLwc)
    wiredFyear({error, data}){
        if(data){
            console.log('Data ' , data);
            for(const valueObject of data){
                this.financialYearOptions = [...this.financialYearOptions,{value: valueObject,label: valueObject}];
            }
            // if(this.financialYearOptions.length > 0){
            //     this.financialYearSelected = this.financialYearOptions[0].label;
            // }
        }else if(error){
            console.log('Error in get year ', error);
            
        }
    }

    handleYearChange(event){
        console.log('Year change called ');
        this.financialYearSelected = event.detail;
        console.log(event.detail);
    }

    handleSendClick(event){
        this.showError = false;
        this.errormessage = '';
        this.showSpinner = true;
        console.log('Handle click called ');
        if(this.emailIds == '' || this.emailIds == undefined || this.emailIds == null){
            console.log('Email ids empty');
            this.errormessage = 'Email is Required';
            this.showError = true;
            this.showSpinner = false;
            return;
        }
        if(this.emailMessage == '' || this.emailMessage == undefined || this.emailMessage == null){
            this.showError = true;
            this.errormessage = 'Email Message is Required';
            this.showSpinner = false;
            return;
        }
        if(this.emailSubject == '' || this.emailSubject == undefined || this.emailSubject == null){
            this.showError = true;
            this.errormessage = 'Email subject is Required';
            this.showSpinner = false;
            return;
        }
        if(this.financialYearSelected == '' || this.financialYearSelected == undefined || this.financialYearSelected == null){
            this.showError = true;
            this.errormessage = 'Please Select atleast one Financial Year';
            this.showSpinner = false;
            return;
        }
        console.log(this.financialYearSelected);
        emailNotificationForUsDonorLwc({financialyear : this.financialYearSelected, emailIds : this.emailIds, EmailMsg :this.emailMessage, subjectval : this.emailSubject})
        .then(response =>{
            console.log('Success from apex');
            console.log(response);
            this.showSpinner = false;
            if(response == 'Email sent successfully.') {
                console.log('Navigate to list view');
                this.showSuccess = true;
            }else{
                this.errormessage = response;
                this.showError = true;
            }
        })
        .catch(error =>{
            console.log('Error ', error);
            this.showSpinner = false;
        })
    }

    handleEmailIdChange(event){
        this.emailIds = event.detail.value;
    }

    handleEmailSubjectChange(event){
        this.emailSubject = event.detail.value;
    }

    handleEmailMessageChange(event){
        this.emailMessage = event.detail.value;
    }
}