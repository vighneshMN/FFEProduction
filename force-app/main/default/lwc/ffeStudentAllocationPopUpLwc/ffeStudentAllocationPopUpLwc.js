import { LightningElement,wire,api,track } from 'lwc';
import getCountryListValuesLwc from '@salesforce/apex/DN_DonorAllocation_CTRL.getCountryListValuesLwc';
import getStateListValuesLwc from '@salesforce/apex/DN_DonorAllocation_CTRL.getStateListValuesLwc';
import getProgramsListValuesLwc from '@salesforce/apex/DN_DonorAllocation_CTRL.getProgramsListValuesLwc';
import getFilteredDonors_multiDonorLwc from '@salesforce/apex/DN_DonorAllocation_CTRL.getFilteredDonors_multiDonorLwc';
import save_multiDonorLwc from '@salesforce/apex/DN_DonorAllocation_CTRL.save_multiDonorLwc';

const columns = [
    { label: 'Donor Name', fieldName: 'Donor_Name__c' },
    { label: 'Donor Id', fieldName: 'FFE_ID__c' },
    { label: 'Donor Location', fieldName: 'MailingState'},
    { label: 'GAU Name', fieldName: 'Gau_Name__c' },
    { label: 'Current Balance', fieldName: 'Current_Balance__c'},
    { label: 'Mapped Fund', fieldName: 'MappedFund__c' },
    { label: 'Enter Amount to Disburse', fieldName: 'Amount_To_Disburse__c',type :'number',editable: true},
    { label: 'Donor Remarks', fieldName: 'Donor_Remark__c' ,editable: true},
    { label: 'Mark for Donation', fieldName: 'Select__c', type: 'boolean',editable: true }
    
];

export default class FfeStudentAllocationPopUpLwc extends LightningElement {
    countryList =[];
    countryListFilter = 'India';
    stateList = [];
    stateListFilter = [];
    listOfPrgms = [];
    prgmsFilter = [];
    donorCategoryFilter ;
    @api selectedstudent;
    @track filterDonorList = [];
    //totalAmount = 0 ;
    errormessage ;
    showerror = false;
    columnList = columns;

    

    @wire(getCountryListValuesLwc)
    wiredCountryPicklist({error, data}){
        if(data){
            for(const valueObject of data){
                this.countryList = [...this.countryList,{value: valueObject.DeveloperName , label:valueObject.Label}];
            }
        }else if(error){
            console.log('Error in the wired coursepicklist list ', error);
        }
    }

    handleCountryChange(event){
        this.countryListFilter = event.detail.value;
    }

    @wire(getStateListValuesLwc)
    wiredStatePicklist({error, data}){
        if(data){
            for(const valueObject of data){
                this.stateList = [...this.stateList,{value: valueObject.DeveloperName , label:valueObject.Label}];
            }
        }else if(error){
            console.log('Error in the wired coursepicklist list ', error);
        }
    }

    handleStateChange(event){
        this.stateListFilter = event.detail;
        console.log('State list filter ' , this.stateListFilter);
    }

    @wire(getProgramsListValuesLwc)
    wiredProgramslist({error, data}){
        if(data){
            for(const valueObject of data){
                console.log('::: Program List :::: ' ,valueObject );
                //let parsedObj = JSON.parse(valueObject);
                //console.log(JSON.parse(parsedObj).Name);
                this.listOfPrgms = [...this.listOfPrgms,{value: valueObject.Name , label:valueObject.Name}];
            }
        }else if(error){
            console.log('Error in the wired coursepicklist list ', error);
        }
    }

    handleProgramValueChange(event){
        this.prgmsFilter = event.detail;
        console.log('Program filter list ' , this.prgmsFilter);
    }

    get donorCategoryOptions(){
        return [
            { label: 'Individual', value: 'Individual' },
            { label: 'Corporate', value: 'Corporate' },
            { label: 'Foundation', value: 'Foundation' },
            { label: 'Charitable Trust', value: 'Charitable Trust' },
            { label: 'Corporate Individual', value: 'Corporate Individual' },
            { label: 'Alumni', value: 'Alumni' },
            { label: 'Non Profit Organization', value: 'Non Profit Organization' },
            { label: 'Other', value: 'Other' },
        ];

    }

    handleDonorCategoryChange(event){
        this.donorCategoryFilter = event.detail.value;
    }


    handleSearchClick(event){
        console.log('Handle search click called');
        this.dispatchEvent(new CustomEvent('showloading'));
        let donorFilter = {
            countryName : this.countryListFilter,
            locations   : this.stateListFilter,
            gaus        : this.prgmsFilter
        }
        getFilteredDonors_multiDonorLwc({searchFilter : donorFilter, strDonorCategory : this.donorCategoryFilter})
            .then(result =>{
                //Empty the old donor filter list 
                this.filterDonorList = [];
                console.log('getFilteredDonors_multiDonorLwc Success');
                let donorList = JSON.parse(result);
                console.log('@@@@@ ' ,donorList[0]);
                donorList.forEach(donor =>{
                    let filterdonor = {};
                    filterdonor.donorBalanceId = donor.donorBalanceId;
                    filterdonor.Donor_Name__c = donor.donorInfo.Name;
                    filterdonor.DonorId = donor.donorInfo.Id;
                    filterdonor.FFE_ID__c = donor.donorInfo.FFE_ID__c;
                    filterdonor.MailingState = donor.donorInfo.MailingState;
                    filterdonor.Gau_Name__c = donor.gauName;
                    filterdonor.Current_Balance__c = donor.currentBalance;
                    filterdonor.MappedFund__c = donor.mappedFund;
                    filterdonor.Amount_To_Disburse__c = '';
                    filterdonor.Donor_Remark__c = '';
                    filterdonor.Select__c = false;
                    this.filterDonorList = [...this.filterDonorList,filterdonor];
                })
                //console.log(JSON.parse(result));
                //let donorList = [];
                //donorList = JSON.parse(result);
                // console.log('Length of donor list ' ,donorList.length);
                // console.log('Donor list info ',donorList[0]);
                // console.log('Donor Name ', donorList[0].donorInfo.Name);
                // console.log('Donor Id ', donorList[0].donorInfo.FFE_ID__c);
                // console.log('Donor Location ', donorList[0].donorInfo.MailingState);
                // console.log('GAU Name ', donorList[0].gauName);
                // console.log('Current Balance ', donorList[0].currentBalance);
                // console.log('Mapped Fund ', donorList[0].mappedFund);
                // console.log('Enter Amount to Disburse ', donorList[0].donorInfo.);
                // console.log('Donor Remarks ', donorList[0].donorInfo.);
                this.dispatchEvent(new CustomEvent('hideloading'));
            })
            .catch(error =>{
                console.log('Error in getFilteredDonors_multiDonorLwc ', error);
                this.dispatchEvent(new CustomEvent('hideloading'));
            })
    }

    get totalApprovedScholarship(){
        //console.log(' @@@@ get totalApprovedScholarship @@@@@');
        if(this.selectedstudent){
            //console.log(this.selectedstudent.ScholarshipAmount__c);
            //console.log(this.selectedstudent.Id);
            console.log(JSON.stringify(this.selectedstudent));
            return this.selectedstudent.ScholarshipAmount__c;
        }
        
    }

    selectedRowHandler(event){
        console.log('selectedRowHandler called');
        const selectedRows = event.detail.selectedRows;

        // selectedRows.forEach(selecteddonor =>{
        //     console.log('selecteddonor' , selecteddonor);
        //     console.log('Amount_To_Disburse__c ' ,selecteddonor.Amount_To_Disburse__c);
        //     console.log('Donor_Remark__c ' ,selecteddonor.Donor_Remark__c);
        // });
    }

    handleSave(event){

    }

    handleCellChange(event){
        let recordvalues = event.detail.draftValues;
        console.log(recordvalues[0].donorBalanceId);
        console.log(recordvalues[0].Select__c);
        if(recordvalues[0].Select__c != undefined){
            console.log('Marked for donation changed');
            this.filterDonorList = this.filterDonorList.map(function(donor){
                if(donor.donorBalanceId == recordvalues[0].donorBalanceId){
                    donor.Select__c = false;
                    return donor;
                }else{
                    return donor;
                }

            });

        }else{
            console.log('Other cell changed');
        }

        // this.filterDonorList.forEach(donor =>{
        //     if(donor.donorBalanceId === recordvalues[0].donorBalanceId){
        //         if(recordvalues[0].Amount_To_Disburse__c){
        //             donor.Amount_To_Disburse__c = recordvalues[0].Amount_To_Disburse__c;
        //         }
        //         if(recordvalues[0].Donor_Remark__c){
        //             donor.Donor_Remark__c = recordvalues[0].Donor_Remark__c;
        //         }
        //     }
        // })
        
        
    }

    handleAmountChange(event){
        console.log('Handle amount change called');
        let targetId = event.target.dataset.id;
        console.log(targetId);
        console.log(event.detail.value);
        this.filterDonorList.forEach(donor =>{
            if(donor.donorBalanceId === targetId){
                if(event.detail.value > donor.Current_Balance__c){
                    this.errormessage = 'Disburse Amount cannot be greater than Current Balance.';
                    this.showerror = true;
                    donor.Select__c = false;
                    donor.Amount_To_Disburse__c = 0;
                } else if (event.detail.value > (donor.Current_Balance__c - donor.MappedFund__c)){
                    this.errormessage = 'Amount exhausted. Please crosscheck.';
                    this.showerror = true;
                    donor.Select__c = false;
                    donor.Amount_To_Disburse__c = 0;
                }else{
                    donor.Amount_To_Disburse__c = event.detail.value;
                    donor.Select__c = false;
                    this.errormessage ='';
                    this.showerror = false;
                }
                
            }
        })

    }

    handleRemarkChange(event){
        console.log('Handle remark change called');
        let targetId = event.target.dataset.id;
        console.log(targetId);
        console.log(event.detail.value);
        this.filterDonorList.forEach(donor =>{
            if(donor.donorBalanceId === targetId){
                donor.Donor_Remark__c = event.detail.value;
            }
        })
    }

    handleSelectChange(event){
        console.log('Handle select change called');
        let targetId = event.target.dataset.id;
        console.log(targetId);
        //console.log(event.detail.value);
        console.log(event.detail.checked);
        this.filterDonorList.forEach(donor =>{
            if(donor.donorBalanceId === targetId){
                donor.Select__c = event.detail.checked;
                console.log(donor.Amount_To_Disburse__c);
                console.log(donor.Select__c);
            }
        })

        let donorRow = this.filterDonorList.filter(item => item.donorBalanceId === targetId)[0];
        if(event.detail.checked){
            if(donorRow.Amount_To_Disburse__c === undefined || donorRow.Amount_To_Disburse__c === null || donorRow.Amount_To_Disburse__c === 0 || donorRow.Amount_To_Disburse__c === ''){
                console.log(donorRow.Amount_To_Disburse__c);
                this.errormessage = 'Disburse amount cannot be empty';
                this.showerror = true;
            }
            else if(donorRow.Amount_To_Disburse__c > this.selectedstudent.ScholarshipAmount__c){
                this.errormessage = 'Total amount greater than scholarship amount';
                this.showerror = true;
            }else{
                let totalAmount = this.calculateTotalAmount();
                if(totalAmount > this.selectedstudent.ScholarshipAmount__c){
                    this.errormessage = 'Total amount greater than scholarship amount';
                    this.showerror = true;
                }else{
                    this.errormessage = '';
                    this.showerror = false;
                }
                
            }
        }
        else{
            this.errormessage = '';
            this.showerror = false;
        }
        
    }

    showToast(title,message,variant,mode){
        console.log('Show toast called ');
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: mode
        });
        this.dispatchEvent(evt);
    }

    calculateTotalAmount(){
        let  selectedRows = this.filterDonorList.filter(donor => donor.Select__c === true);
        let totalAmount ;
        console.log('Selected rows length ' , selectedRows.length);
        if(selectedRows.length > 0){
            totalAmount = selectedRows.reduce((sumamount,row) => sumamount + parseInt(row.Amount_To_Disburse__c),0);
        }
        return totalAmount;
    }

    get totalAmount(){
        return this.calculateTotalAmount();
    }

    saveMultiDonor(event){
        console.log('Save multi donor called');
        let  selectedDonorLst = this.filterDonorList.filter(donor => donor.Select__c === true);
        if(selectedDonorLst.length === 0){
            this.errormessage = 'No rows selected';
            this.showerror = true;
            return true;
        }
        let totalAmount = this.calculateTotalAmount();
        if(totalAmount < this.selectedstudent.ScholarshipAmount__c){
            this.errormessage = 'Mapping still pending. Please map the entire amount.';
            this.showerror = true;
            return true;
        }

        this.dispatchEvent(new CustomEvent('showloading'));
        let donorBalanceList = [];
        let donorAppList = [];

        selectedDonorLst.forEach(donor =>{
            var donorBalanceMap = {"donorBalanceId" : "","Mapped_Fund__c":""};
            donorBalanceMap.donorBalanceId = donor.donorBalanceId;
            donorBalanceMap.Mapped_Fund__c = donor.Amount_To_Disburse__c;
            donorBalanceList.push(donorBalanceMap);
            // create donor app mappings
            var donorAppMap = {"Application__c" : "","Donor__c":"","Funding_amount__c" : "","Student__c":"","gauName":"","Donor_Remark__c":""};
            donorAppMap.Application__c = this.selectedstudent.Id;
            donorAppMap.Donor__c = donor.DonorId;
            donorAppMap.Funding_amount__c = donor.MappedFund__c;
            //donorAppMap.Student__c = this.selectedstudent.Student__c;
            donorAppMap.Student__c = this.selectedstudent.Student_Param__c;
            donorAppMap.gauName = donor.Gau_Name__c;
            donorAppMap.Donor_Remark__c = donor.Donor_Remark__c;
            donorAppList.push(donorAppMap);
        });

        save_multiDonorLwc({donorBalanceList : donorBalanceList,
                            donorAppList :donorAppList})
        .then(result =>{
            console.log('Success for save multidonor lwc');
            console.log('result ' , result); // Mappings created successfully 
            this.filterDonorList = [];
            this.dispatchEvent(new CustomEvent('hideloading'));
            this.dispatchEvent(new CustomEvent('resetpage',{detail : result}));
        })
        .catch(error =>{
            this.dispatchEvent(new CustomEvent('hideloading'));
            console.log('Error for save multidonor lwc');
            console.log(error);
        })
    }

    get filterDonorListResult(){
        return this.filterDonorList.length > 0;
    }

    clear(event){
        this.stateListFilter = [] ;
        this.prgmsFilter = [] ;
        this.donorCategoryFilter = '' ;
        let multiSelectPicklist = this.template.querySelectorAll('c-ffe-multi-select-picklist-lwc');
        multiSelectPicklist.forEach(multiselect =>{
            multiselect.clear();
        });
        this.filterDonorList = [];
        
    }

    cancel(){
        this.dispatchEvent(new CustomEvent('resetpage'));
    }
}