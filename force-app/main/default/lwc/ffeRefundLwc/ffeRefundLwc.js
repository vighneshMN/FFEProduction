import { api, wire, LightningElement } from 'lwc';
import getRefundDetails from '@salesforce/apex/AP_Refund_CTRL.fetchRefundDetails';
import saveRefundDetails from '@salesforce/apex/AP_Refund_CTRL.doSaveLWc';
import { getRecordNotifyChange } from 'lightning/uiRecordApi';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class FfeRefundLwc extends LightningElement {
    @api recordId; 

    refund; 
    applicationLink;  
    refundedAmount;
    refundTransactionNo;  
    fundUtilization = []; 
    errormessage;
    isRefundReceived = false; 

    @wire(getRefundDetails, { refundId: '$recordId'})
    refundDetails ({error, data}){
        if (data){
            if (data.refund.Refund_Status__c === 'Refund received'){ 
                console.log (data.refund.Refund_Status__c);                
                this.isRefundReceived = true; 
                this.template.querySelector('c-ffe-popup-lwc').showPopup ('Refund is already received', 'Refund', 'OK', ''); 
                this.template.querySelector('c-ffe-popup-lwc').addEventListener("ok", e=> this.cancelClick(), false);
                return; 
            }
            this.refund = data.refund; 
            if (this.refund.Application__c != null){
                this.applicationLink = "/" + this.refund.Application__c; 
            }
            this.refundedAmount = data.refund.Refunded_Amount__c;
            this.refundTransactionNo = data.refund.Refund_Transaction_No__c; 
            let fundUtil = JSON.parse(JSON.stringify(data.fundUtilz)); 
            console.log (data.fundUtilz); 
            let i = 0; 
            fundUtil.forEach((row)=>{
                let rowData={};
                rowData.rowNumber = i++; 
                rowData.Id = row.Id;
                rowData.Donor_Balance__c = row.Donor_Balance__c;
                rowData.Disbursed_Amount__c = row.Disbursed_Amount__c;
                rowData.Refunded_Amount__c = row.Refunded_Amount__c;

                if (row.Donor_Balance__c != null && row.Donor_Balance__c!= undefined){
                    rowData.Donor_Balance__r = row.Donor_Balance__r; 
                    rowData.Donor_Balance__r.Current_Balance__c = row.Donor_Balance__r.Current_Balance__c;
                    rowData.Donor_Balance__r.Id = row.Donor_Balance__r.id;
                    rowData.DBLink = "/" +row.Donor_Balance__c;
                    rowData.DBName =row.Donor_Balance__r.Name; 
                }
                if (row.Donor__c != null) {
                    rowData.Donor__c =  row.Donor__c; 
                    rowData.DonorLink = "/" + row.Donor__c; 
                    rowData.DonorName=row.Donor__r.Name; 
                }
                else { rowData.DonorName= ''; }

                if (row.General_Accounting_Unit__c != null) { 
                    rowData.General_Accounting_Unit__c = row.General_Accounting_Unit__c; 
                    rowData.GAUnitLink = "/" +row.General_Accounting_Unit__c;
                    rowData.GAUnitName =row.General_Accounting_Unit__r.Name; 
                }
                else { rowData.GAUnitName= ''; }
                
                this.fundUtilization.push(rowData);

            });
            //this.fundUtilization = { fundUtil: fundUtil.map(record=>({...record, General_Accounting_Unit__r__Name: record.General_Accounting_Unit__r.Name, Donor__r__Name: record.Donor__r.Name}))};
        } else if (error){
            console.log (error); 
        }
    }

    handleRefundChange (event){
        if (event.target.label === 'Refunded Amount'){
            this.refundedAmount = event.detail.value;
        }
        else if (event.target.label === 'Refund Transaction No.'){
            this.refundTransactionNo = event.detail.value;
        }
    }

    handleRefundAmtChange (event){
        let idx = event.target.dataset.id; 
        this.fundUtilization[idx].Refunded_Amount__c = event.detail.value; 
    }

    showToast(title,message,variant,mode){
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: mode
        });
        this.dispatchEvent(evt);
    }

    okClick (){
        this.errormessage = ''; 
        if (this.refund.Application__c!=null && this.refundedAmount > this.refund.Application__r.Scholarship_Amount__c){
            this.errormessage = 'Refunding amount can\'t be more than approved amount'; 
            return;
        }
        console.log ('Start');
        let totalRefund = 0; 
        this.fundUtilization.forEach((row)=>{
            totalRefund += parseInt(row.Refunded_Amount__c); 
        });

        console.log ('Start2');
        if(totalRefund != this.refundedAmount || totalRefund == 0){
            if(totalRefund == 0){
                this.errormessage = 'Please enter donor balance to refund.';      
                return;
            }else{
                this.errormessage = 'Sum of all donor balance to refund should be equal to refunded amount.';
                return;
            }
        }

        console.log ('1');
        let refund = {Id: this.refund.Id, Refunded_Amount__c : this.refundedAmount, Refund_Transaction_No__c : this.refundTransactionNo, Application__c : this.refund.Application__c}; 
        console.log ('2');
        //let fundUtil = JSON.parse(JSON.stringify(data.fundUtilz)); 

        let wrapper = {refund: refund, fundUtilz: this.fundUtilization}; 
        console.log (3); 
        saveRefundDetails({rWrapStr : JSON.stringify(wrapper)})
        .then(result =>{
            this.showToast ('Success', 'Amount refunded successfully.', 'success', 'dismissable');
            getRecordNotifyChange([{recordId: this.recordId}]);
            this.dispatchEvent(new CloseActionScreenEvent());
        })
        .catch(error =>{
            console.log (error);
            this.showToast ('Error', 'Something went wrong.', 'error', 'dismissable');
        })
    }

    cancelClick(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}