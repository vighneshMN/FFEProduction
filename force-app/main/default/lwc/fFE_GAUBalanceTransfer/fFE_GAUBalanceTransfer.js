import { LightningElement, api, wire, track  } from 'lwc';
import getBalanceTransfer from '@salesforce/apex/FFEBalanceTransferHandler.getBalanceTransfer';
import refundAmount from '@salesforce/apex/FFEBalanceTransferHandler.refundAmount';
import updateGBT from '@salesforce/apex/FFEBalanceTransferHandler.updateGBT';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class FFE_GAUBalanceTransfer extends LightningElement {
    gbts;
    resultString;
    totalAmount=0;
    transferedFund=0;
    sourceCurrentBal=0 ;
    refundAmount=0;
    Source_GAU__c;
    Destination_donor__c;
    Destination_Donor_Balance__c;
    Donor_Balance__c;
    @track refund = false;
    @track displayMessage = '';
    @api recordId;
    
    retrievedRecordId = false;

    handleNo(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }
    handleYes(){
        
        refundAmount({ sourceGauId: this.recordId,destinationdonor:this.Destination_donor__c,destinationDonorBalance:this.Destination_Donor_Balance__c,
            refundingAmount:this.transferedFund,sourceDBln:this.Donor_Balance__c,sourceDonorbalanceCurrentBlnc:this.sourceCurrentBal })
        .then((result) => {
            this.resultString = result;
            if(this.resultString=='Success'){
                updateGBT({ recordId: this.recordId,transferedFund:this.transferedFund })
                .then((result) => {
                    this.resultString = result;
                    console.log(this.resultString);
                    alert(this.resultString);
                    this.dispatchEvent(new CloseActionScreenEvent());
                   
                })
                .catch((error) => {
                     this.resultString = undefined;
                     //alert(this.resultString);
                });
            }
            console.log(this.resultString);
          //  alert(this.resultString);
           
        })
        .catch((error) => {
             this.resultString = undefined;
          //   alert(this.resultString);
        });
    }
    renderedCallback() {
        if (!this.retrievedRecordId && this.recordId) {
            console.log('this.recordId'+this.recordId);
            // Register error listener     
            getBalanceTransfer({ GAUId: this.recordId })
            .then((result) => {
                console.log('result'+JSON.stringify(result));
                this.resultString = result;
            
                
                this.totalAmount =parseInt(this.resultString.Total_Allocation__c);
                this.transferedFund = parseInt(this.resultString.Transfered_Fund__c);
                this.sourceCurrentBal = parseInt(this.resultString.Current_Balance__c);
                this.refundAmount = parseInt(this.resultString.Refunded_Amount__c);
                if(isNaN(this.totalAmount)){
                    this.totalAmount=0;
                }
                if(isNaN(this.transferedFund)){
                    this.transferedFund=0;
                }
                if(isNaN(this.sourceCurrentBal)){
                    this.sourceCurrentBal=0;
                }
                if(isNaN(this.refundAmount)){
                    this.refundAmount=0;
                }
                this.Source_GAU__c = this.resultString.Source_GAU__c;
                this.Destination_donor__c = this.resultString.Destination_donor__c;
                this.Destination_Donor_Balance__c = this.resultString.Destination_Donor_Balance__c;
                this.Donor_Balance__c = this.resultString.Donor_Balance__c;
                console.log('this.totalAmount'+this.totalAmount);
                console.log('this.transferedFund'+this.transferedFund);
                console.log('this.sourceCurrentBal'+this.sourceCurrentBal);
                console.log('this.refundAmount'+this.refundAmount);
               
               // alert(this.resultString);
                if(this.transferedFund >= this.totalAmount){
                    this.refund = false;
                }else{
                    this.refund = true;
                } 
                console.log('refund'+this.refund);        
            })
            .catch((error) => {
                console.log('error'+JSON.stringify(error));
                this.resultString = undefined;
                
            });
            this.retrievedRecordId = true;
        }
    }

}