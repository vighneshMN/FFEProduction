import { LightningElement,api, wire } from 'lwc';
import {getRecord} from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import DONOR_ID_FIELD from '@salesforce/schema/Donor_Balance__c.Donor_Name__c';
import GAU_NAME_ID_FIELD from '@salesforce/schema/Donor_Balance__c.GAU_Name__c';
import CURRENT_BALANCE_FIELD from '@salesforce/schema/Donor_Balance__c.Current_Balance__c';
import SHORT_COMMENTS_FIELD from '@salesforce/schema/Donor_Balance__c.Short_Comments__c';
import FCRA_Duplicate_Err_Msg from '@salesforce/label/c.FCRA_Duplicate_Err_Msg';
import Fund_Transfer_error_message from '@salesforce/label/c.Fund_Transfer_error_message';
import zero_amount_balance_error_message from '@salesforce/label/c.zero_amount_balance_error_message';
import Amount_Entry_as_Zero from '@salesforce/label/c.Amount_Entry_as_Zero';
import destinationDonorDetailsLwc from '@salesforce/apex/DonorFundTransfer.destinationDonorDetailsLwc';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class FfeTransferFundLwc extends LightningElement {
    @api recordId;
    objectApiName = 'Donor_Balance__c';
    donorField = DONOR_ID_FIELD;
    gauField = GAU_NAME_ID_FIELD;
    currentBalance = CURRENT_BALANCE_FIELD;
    shortComments = SHORT_COMMENTS_FIELD;
    destGau;
    destDonor;
    destTransferAmount = 0;
    sourceShortComments;
    showSpinner = false;

    @wire(getRecord,{recordId:'$recordId',fields:[CURRENT_BALANCE_FIELD,GAU_NAME_ID_FIELD,DONOR_ID_FIELD]})
    sourceDonorBalance;

    handleGauChange(event){
        console.log('Handle gau change called');
        console.log(event.target.value);
        console.log(this.sourceDonorBalance.data.fields.GAU_Name__c.value);
        this.destGau = event.target.value;
    }

    handleDonorChange(event){
        this.destDonor = event.target.value;
    }

    handleTransferClick(){
        this.showSpinner = true;
        if(this.sourceShortComments == '' || this.sourceShortComments == undefined || this.sourceShortComments == null){
            const event = new ShowToastEvent({
                title: 'Error',
                message: 'Please enter new Short comments',
                variant: 'error',
            });
            this.dispatchEvent(event);
            this.showSpinner = false;
            return;
        }else if(this.destDonor == '' || this.destDonor == undefined || this.destDonor == null){
            const event = new ShowToastEvent({
                title: 'Error',
                message: 'Please select Donor',
                variant: 'error',
            });
            this.dispatchEvent(event);
            this.showSpinner = false;
            return;
        }else if(this.destGau == '' || this.destGau == undefined || this.destGau == null){
            const event = new ShowToastEvent({
                title: 'Error',
                message: 'Please select Business Account',
                variant: 'error',
            });
            this.dispatchEvent(event);
            this.showSpinner = false;
            return;
        }else if(this.destTransferAmount == '' || this.destTransferAmount == undefined || this.destTransferAmount == null){
            const event = new ShowToastEvent({
                title: 'Error',
                message: 'Please enter transfer amount',
                variant: 'error',
            });
            this.dispatchEvent(event);
            this.showSpinner = false;
            return;
        }
        if(this.destGau == this.sourceDonorBalance.data.fields.GAU_Name__c.value){
            if(this.destDonor == this.sourceDonorBalance.data.fields.Donor_Name__c.value){
                const event = new ShowToastEvent({
                    title: 'Error',
                    message: Fund_Transfer_error_message,
                    variant: 'error',
                });
                this.dispatchEvent(event);
                this.showSpinner = false;
                return;
            }else{
                if(this.sourceDonorBalance.data.fields.Current_Balance__c.value == 0 || this.destTransferAmount == 0){
                   if(this.sourceDonorBalance.data.fields.Current_Balance__c.value == 0){
                        const event = new ShowToastEvent({
                            title: 'Error',
                            message: zero_amount_balance_error_message,
                            variant: 'error',
                        });
                        this.dispatchEvent(event);
                        this.showSpinner = false;
                        return;
                   }else{
                        const event = new ShowToastEvent({
                            title: 'Error',
                            message: Amount_Entry_as_Zero,
                            variant: 'error',
                        });
                        this.dispatchEvent(event);
                        this.showSpinner = false;
                        return;
                   } 
                }else{
                    if(this.destTransferAmount > this.sourceDonorBalance.data.fields.Current_Balance__c.value){
                        const event = new ShowToastEvent({
                            title: 'Error',
                            message: 'Amount shoulde be less than or equal to Rs.'+this.sourceDonorBalance.data.fields.Current_Balance__c.value+'.',
                            variant: 'error',
                        });
                        this.dispatchEvent(event);
                        this.showSpinner = false;
                        return        
                    }else{
                        console.log('Hit apex');
                        let sourceDonorBalance = {Id:this.recordId,Short_Comments__c:this.sourceShortComments,Current_Balance__c:this.sourceDonorBalance.data.fields.Current_Balance__c.value,Donor_Name__c :this.sourceDonorBalance.data.fields.Donor_Name__c.value,GAU_Name__c:this.sourceDonorBalance.data.fields.GAU_Name__c.value};
                        let destDonorBalance = {Donor_Name__c:this.destDonor,GAU_Name__c:this.destGau,Current_Balance__c:this.destTransferAmount};
                        destinationDonorDetailsLwc({sourceDonorBalance:sourceDonorBalance,destDonorBalance:destDonorBalance})
                        .then(result =>{
                            this.showSpinner = false;
                            console.log('Success ', result);
                            const event = new ShowToastEvent({
                                title: 'Success',
                                message: result,
                                variant: 'success',
                            });
                            this.dispatchEvent(event);
                            //this.dispatchEvent(new CloseActionScreenEvent());
                            this.dispatchEvent(new CustomEvent('recordChange'));

                        }).catch(error =>{
                            console.log('Error ' , error);
                            this.showSpinner = false;
                        })

                    }                   
                }
            }
            
        }else{
            const event = new ShowToastEvent({
                title: 'Error',
                message: FCRA_Duplicate_Err_Msg,
                variant: 'error',
            });
            this.dispatchEvent(event);
            this.showSpinner = false;
            return;
        }

    }

    handleTransferAmountChange(event){
        console.log('Handle amount change called');
        console.log(event.detail.value);
        this.destTransferAmount = event.detail.value;
    }

    handleCommentChange(event){
        this.sourceShortComments = event.detail.value;
    }
}