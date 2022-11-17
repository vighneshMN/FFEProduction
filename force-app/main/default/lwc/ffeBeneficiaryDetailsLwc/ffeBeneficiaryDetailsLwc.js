import { LightningElement, api, wire, track} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import { CloseActionScreenEvent } from 'lightning/actions';
import currentTenFinancialYearexcludingThisLwc from '@salesforce/apex/NotifyStudentHelper.currentTenFinancialYearexcludingThisLwc';
import checkForDonAppMappingLwc from '@salesforce/apex/WebServiceButtonHelper.checkForDonAppMappingLwc';
import saveAttachementLwc from '@salesforce/apex/WebServiceButtonHelper.saveAttachementLwc';

export default class FfeBeneficiaryDetailsLwc extends NavigationMixin(LightningElement) {

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
        const response = await checkForDonAppMappingLwc({conId:this.recordId,fyear:this.fySelected});
        console.log('response ' , response);
        if(response == false){
            const evt = new ShowToastEvent({
                title: 'Note',
                message: 'No Beneficiary Details for ' + this.fySelected,
                variant: 'info',
            });
            this.dispatchEvent(evt);
            this.showSpinner = false;
            return;
        }else if(response == true){
            const res = await saveAttachementLwc({conId:this.recordId,financialYear:this.fySelected});
            const evt = new ShowToastEvent({
                title: 'success',
                message: 'The Beneficiary Details for FY ' + this.fySelected +' has been stored under the section - Notes & Attachments',
                variant: 'success',
            });
            this.dispatchEvent(evt);
            console.log('Secod result ', res);
            // this.dispatchEvent(new CloseActionScreenEvent());
            this.showSpinner = false;
            this.dispatchEvent(new CustomEvent('recordChange'));
            
        }      
        
    }

    handleFinYearChange(event){
        this.fySelected = event.detail.value;
    }
    
}