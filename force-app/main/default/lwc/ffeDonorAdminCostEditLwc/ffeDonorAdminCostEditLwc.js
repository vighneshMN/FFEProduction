import { LightningElement,api, wire, track } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import strUserId from '@salesforce/user/Id';
import PROFILE_NAME_FIELD from '@salesforce/schema/User.Profile.Name';
import GAU_NAME_FIELD from '@salesforce/schema/Donor_Balance__c.GAU_Name__r.Name';
import GAU_NAME_ID_FIELD from '@salesforce/schema/Donor_Balance__c.GAU_Name__c';
import CURRENT_BALANCE_FIELD from '@salesforce/schema/Donor_Balance__c.Current_Balance__c';
import DONOR_FIELD from '@salesforce/schema/Donor_Balance__c.Donor_Name__r.Name';
import DONOR_ID_FIELD from '@salesforce/schema/Donor_Balance__c.Donor_Name__c';
import SHORT_COMMENTS_FIELD from '@salesforce/schema/Donor_Balance__c.Short_Comments__c';
import ID_FIELD from "@salesforce/schema/Donor_Balance__c.Id";
import {getRecord} from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { updateRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';

export default class FfeDonorAdminCostEditLwc extends NavigationMixin(LightningElement) {

    @api recordId;
    retrievedRecordId = false;
    showSpinner = true;
    //showClose = false;
    profileCheckMessage;
    gauNameCheckMessage;
    profileName;
    @track donorBalance;
    addFund;
    reduceFund;
    shortComments;

    @wire(getRecord,{recordId:strUserId,fields: [PROFILE_NAME_FIELD]})
    wireUser({error,data}){
        if(data){
            this.showSpinner = false;
            this.profileName=data.fields.Profile.value.fields.Name.value;
            console.log('Wire User called ',this.profileName);
            if(this.profileName != 'System Administrator' && this.profileName != 'Account Team'){
                this.profileCheckMessage= 'This edit is only for System Administrator and Account Team Users';
            }
        }
    }

    @wire(getRecord,{recordId:'$recordId',fields:[GAU_NAME_FIELD,CURRENT_BALANCE_FIELD,DONOR_FIELD,DONOR_ID_FIELD,GAU_NAME_ID_FIELD]})
    wiredDonorBalance({error,data}){
        if(data){
            this.showSpinner = false;
            console.log('Success wired donor called');
            console.log('Gau Name ',data.fields.GAU_Name__r.value.fields.Name.value);
            this.donorBalance = data;
            console.log('Gau Name ' + this.donorBalance.fields.GAU_Name__r.value.fields.Name.value);
            console.log('CUrrent balance  ' + this.donorBalance.fields.Current_Balance__c.value);
            console.log('Doonor id   ' + this.donorBalance.fields.Donor_Name__c.value);
            let gauName = data.fields.GAU_Name__r.value.fields.Name.value;
            if(gauName != 'Offline Donation Admin Cost (598)' && gauName != 'Offline Donation Admin Cost (723)'){
                this.gauNameCheckMessage = 'Allowed only for Offline Donation Admin Cost GAU';
            }
        }
    }

    renderedCallback(){
        // if (!this.retrievedRecordId && this.recordId) {
        //     this.showSpinner = true;
        //     this.retrievedRecordId = true; // Escape case from recursion
        // }
    }

    handleCloseClick(event){
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    get showClose(){
        return  this.profileCheckMessage ? true : this.gauNameCheckMessage ? true : false ;
    }

    get donorName(){
        if(this.donorBalance){
            return this.donorBalance.fields.Donor_Name__r.value.fields.Name.value ;
        }
    }

    get gauName(){
        if(this.donorBalance){
            return this.donorBalance.fields.GAU_Name__r.value.fields.Name.value ;
        }
    }

    get currentBalance(){
        if(this.donorBalance){
            return this.donorBalance.fields.Current_Balance__c.value ;
        }
    }

    handleFundChange(event){
        this.addFund = event.detail.value;
    }

    handleReduceFundChange(event){
        this.reduceFund = event.detail.value;
    }

    handleCommentsChange(event){
        this.shortComments = event.detail.value;
    }

    handleSaveClick(event){
        this.showSpinner = true;
        console.log(' addFund'  , this.addFund);
        console.log(' reduceFund'  , this.reduceFund);
        console.log(' shortComments'  , this.shortComments);
        if(this.shortComments == '' || this.shortComments == undefined || this.shortComments == null){
            const event = new ShowToastEvent({
                title: 'Error',
                message: 'Please enter comments.',
                variant : 'error'
            });
            this.dispatchEvent(event);
            this.showSpinner = false;
            return;
        }
        

        let totalFunds = this.donorBalance.fields.Current_Balance__c.value;
        if(this.addFund > 0){
            totalFunds =  parseInt(totalFunds) + parseInt(this.addFund);   
        }
        if(this.reduceFund > 0){
            totalFunds = parseInt(totalFunds) - parseInt(this.reduceFund);
        }

        const fields = {};

        fields[ID_FIELD.fieldApiName] = this.recordId;
        fields[CURRENT_BALANCE_FIELD.fieldApiName] = totalFunds;
        fields[SHORT_COMMENTS_FIELD.fieldApiName] = this.shortComments;
        const recordInput = {
            fields: fields
        };

        updateRecord(recordInput).then((record) => {
            console.log(record);
            this.showSpinner = false;
            const event = new ShowToastEvent({
                title: 'Success',
                message: 'Save has been successfull.',
                variant : 'success'
            });
            this.dispatchEvent(event);
            this.dispatchEvent(new CloseActionScreenEvent());
        });
        this.showSpinner = false;
    }

    navigateToDonor(event){
        console.log('Navigate to donor called ');
        console.log('Donor id ' , this.donorBalance.fields.Donor_Name__c.value);
        let donorId = this.donorBalance.fields.Donor_Name__c.value;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: donorId,
                objectApiName: 'Contact',
                actionName: 'view'
            }
        });
    }

    navigateToGau(event){
        let gauId = this.donorBalance.fields.GAU_Name__c.value;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: gauId,
                objectApiName: 'npsp__General_Accounting_Unit__c',
                actionName: 'view'
            }
        });
    }
}