import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import { CloseActionScreenEvent } from 'lightning/actions';
import currentTenFinancialYearexcludingThisLwc from '@salesforce/apex/NotifyStudentHelper.currentTenFinancialYearexcludingThisLwc';
import checkForFundUtilizationLwc from '@salesforce/apex/WebServiceButtonHelper.checkForFundUtilizationLwc';
import saveAttachementForUtilizationLwc from '@salesforce/apex/WebServiceButtonHelper.saveAttachementForUtilizationLwc';

export default class FfeFundUtilizationsDetailsLwc extends LightningElement {

    @api recordId;
    @track fyOptions = [];
    fySelected;
    showSpinner = false;

    @wire (currentTenFinancialYearexcludingThisLwc)
    wiredFyear({error, data}){
        if(data){
            console.log('Data ' , data);
            for(const valueObject of data){
                this.fyOptions = [...this.fyOptions,{value: valueObject,label: valueObject}];
            }
        }else if(error){
            console.log('Error in get year 22 ', error);
            
        }
    }

    async handleExportClick(event){
        this.showSpinner = true;
        if(this.fySelected == '' || this.fySelected == null || this.fySelected == undefined ){
            console.log('Select year ');
            const evt = new ShowToastEvent({
                title: 'Error',
                message: 'Please select financial year',
                variant: 'error',
            });
            this.dispatchEvent(evt);
            this.showSpinner = false;
            return;
        }
        const response = await checkForFundUtilizationLwc({conId:this.recordId,fyear:this.fySelected});
        console.log('response ' , response);
        if(response == false){
            const evt = new ShowToastEvent({
                title: 'Note',
                message: 'No FundUtilization Details For ' + this.fySelected,
                variant: 'info',
            });
            this.dispatchEvent(evt);
            this.dispatchEvent(new CustomEvent('recordChange'));
            this.showSpinner = false;
            return;
        }else if(response == true){
            const res = await saveAttachementForUtilizationLwc({conId:this.recordId,financialYear:this.fySelected});
            const evt = new ShowToastEvent({
                title: 'success',
                message: 'The Fund Utilization Details for  FY ' + this.fySelected +' has been stored under the section - Notes & Attachments',
                variant: 'success',
            });
            this.dispatchEvent(evt);
            console.log('Secod result ', res);
            this.dispatchEvent(new CustomEvent('recordChange'));
            this.showSpinner = false;
        }
    
    }

    handleFinYearChange(event){
        this.fySelected = event.detail.value;
    }

}