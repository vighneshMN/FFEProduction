import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import getApplicationType from '@salesforce/apex/FFE_DN_Fund_AllocationClass.getApplicationType';
import getAllStudents_multiDonor from '@salesforce/apex/FFE_DN_Fund_AllocationClass.getAllStudents_multiDonor';
import getMultiDonor from '@salesforce/apex/FFE_DN_Fund_AllocationClass.getMultiDonor';
import doFundDisburment from '@salesforce/apex/FFE_DN_Fund_AllocationClass.doFundDisburment';


export default class FFE_MultiDNFundAllocation extends LightningElement {


     //Variables
     applTypeOptions = [];
     selectedStudentBy;
     selectedApplType = [];
     searchByDnFfuid = '';
     @track showStudentResult = [];
     @track showDonorResult = [];
     selectedStdFilter = [];
     @api showLoadSpinner = false;
     @api showStudentDetails = false;
     @api showChildTable = false;
     @track selectedRecord = '';
     @track showDisburseform=false;;
     appType = '';
     studentRequestedAmount='';
     amountforcurrentApp='';
     selectedAmtDisburse='';
     disburseAmount = 0;
     remainingFund='';
     applicationId='';
     amountfunded=[];

   get studentoptions() {
      return [
          { label: 'All Multi Donor Mapped Student', value: 'All Multi Donor Mapped Student' }
      ];
    }

        

        // show Spinner
        showSpinnerOnPage() {
         this.showLoadSpinner = true;
         }
         // hide Spinner
         hideSpinnerOnPage() {
         this.showLoadSpinner = false;
         }

          //Notification method
        showNotification(title,message,variant) {
         const evt = new ShowToastEvent({
                 title: title,
                 message: message,
                 variant: variant,
         });
         this.dispatchEvent(evt);
      }

      handleStudentChange(event) {
            this.selectedStudentBy = event.detail.value;
            if(this.selectedApplType.length===0){
                for(var i=0;i<this.applTypeOptions.length;i++){
                        this.selectedApplType.push(this.applTypeOptions[i].value);
                }
            }
           console.log('selectedStudentBy>>'+this.selectedStudentBy);
           console.log('this.selectedApplType>>' , this.selectedApplType);
      }

      handleApplType(event){
         console.log('handleApplType>>' ,JSON.stringify(event));
         console.log('handleApplType0>>' , event.detail.value);
         if(event.detail.length>3){
                this.selectedApplType = [];
                for(var i=0;i<this.applTypeOptions.length;i++){
                        this.selectedApplType.push(this.applTypeOptions[i].value);
                }
         }else{
                this.selectedApplType = event.detail;
         }
         console.log('this.selectedApplType>>' , this.selectedApplType);
       }

      @wire(getApplicationType)
      wiredApplicationType({ error, data }){
         if(data){
                  for(const valueObject of data){
                         this.applTypeOptions = [...this.applTypeOptions,{value: valueObject.Id, label:valueObject.Name}];
                  }
                  console.log('this.applTypeOptions'+JSON.stringify(this.applTypeOptions));
         }else if(error){
                  console.log('Error in the wired Application Options list ', error);
         }
      }

       // Process Method
       processApplication(event){
        console.log('ctarget>>' , event.currentTarget.value);
        this.applicationId = event.currentTarget.value;
        try{
                console.log('this.showStudentResult.length'+this.showStudentResult.length);
                for(var i=0;i<this.showStudentResult.length;i++){
                        console.log('i-------------'+i);
                        console.log('this.showStudentResult[i].value.Name'+this.showStudentResult[i].value.Name);
                        if(this.selectedRecord===this.showStudentResult[i].value.Id){
                                console.log('Key Matched');
                                for(var j=0;j<this.showStudentResult[i].value.Applications__r.length;j++){
                                        console.log('this.showStudentResult[i].value.Applications__r'+this.showStudentResult[i].value.Applications__r[j].Id);
                                        if(event.currentTarget.value===this.showStudentResult[i].value.Applications__r[j].Id){
                                                console.log('Application Matched');
                                                this.studentRequestedAmount= this.showStudentResult[i].value.Applications__r[j].Amount_Requested__c;
                                                this.amountforcurrentApp= this.showStudentResult[i].value.Applications__r[j].Amount_Funded__c;
                                                this.remainingFund= this.showStudentResult[i].value.Applications__r[j].Remaining_Fund__c;
                                                this.appType= this.showStudentResult[i].value.Applications__r[j].RecordType.Name;
                                                this.selectedAmtDisburse= this.showStudentResult[i].value.Applications__r[j].Amount_Requested__c;
                                        }
                                }
                        }
                }
        }catch(error){
                console.log('Exception'+JSON.stringify(error));
        }
        if(this.applicationId.length>0){
                console.log('applicationId'+this.applicationId);
                getMultiDonor({applicationId:this.applicationId})
                .then((result) => {
                        console.log('showDonorResult'+JSON.stringify(result));
                    //    this.hideSpinnerOnPage();
                        this.showDonorResult = result;
                        this.amountfunded = [];
                        for(var i=0;i<this.showDonorResult.length;i++){
                                this.disburseAmount = this.disburseAmount + this.showDonorResult[i].Funding_amount__c;
                                this.amountfunded.push(this.showDonorResult[i].Funding_amount__c);
                        }
                        this.showDisburseform=true;
                        this.error = undefined;
                        console.log(' this.showDisburseform'+ this.showDisburseform);
                        console.log(' this.amountfunded'+ this.amountfunded);
                })
                .catch((error) => {
                  //      this.hideSpinnerOnPage();
                        this.error = error;
                        console.log('this.error'+JSON.stringify(error));
                     //   this.processResult = undefined;
                        this.showNotification('Error!','Sorry! Could not able to fetch details','error');
                });
        }
         
        
      }

      getAllStudents_multiDonor(){

         this.showStudentDetails = false;
         this.showStudentResult = [];
        // this.template.querySelector('lightning-datatable').selectedRows=[];
         this.selectedStdFilter.push({
                 studentType: this.selectedStudentBy,
                 applType: this.selectedApplType
         })
         console.log('97>>'+this.selectedApplType);
         if(this.selectedStdFilter.length>0){
            getAllStudents_multiDonor({studentType:  this.selectedStudentBy, applType: this.selectedApplType 
               })
                 .then((result) => {
                         this.hideSpinnerOnPage();
                         console.log('result>>'+JSON.stringify(result));
                         for(let key in result) {
                                // Preventing unexcepted data
                                console.log('result.hasOwnProperty(key)'+result.hasOwnProperty(key));
                                if (result.hasOwnProperty(key)) { // Filtering the data in the loop
                                        console.log (result[key].Applications__r); 
                                        if (result[key].Applications__r.length > 0){
                                                this.showStudentResult.push({value:result[key], Applications__r:result[key.Applications__r]});
                                                break;
                                        }
                                }
                         }
                         this.error = undefined;
                         this.showStudentDetails = true;
                         console.log('showStudentResult0>>'+this.showStudentResult);
                         console.log('showStudentResult>>'+JSON.stringify(this.showStudentResult));
                         if (this.showStudentResult.length>0) {
                                 this.showStudentDetails = true;
                         }
                 })
                 .catch((error) => {
                         this.hideSpinnerOnPage();
                         this.error = error;
                         this.processResult = undefined;
                         this.showStudentDetails = false;
                         console.log('error>>'+JSON.stringify(error));
                         console.log('error1>>'+error);
                         this.showNotification('Error!','Sorry! Could not able to fetch details','error');
                 });
         }

      }

      handleParentTable(event){
        
         console.log('handleParentTable>>' , event.detail);
         console.log('handleParentTableID>>' ,  event.currentTarget.dataset.id);
         console.log('recId>>' ,  event.currentTarget.dataset.recid);
         this.selectedRecord = event.currentTarget.dataset.recid;
         console.log('Inside Handle Parent Table'+JSON.stringify(event.currentTarget.dataset));
         let selectedDivRows = this.template.querySelectorAll('section');
         this.showChildTable = true;
         for(let i = 0; i < selectedDivRows.length; i++) {
                 console.log('cheking>>'+selectedDivRows[i].dataset.id);

                 if(selectedDivRows[i].dataset.id === 'divblock') {
                    //     console.log('key>>'+selectedDivRows[i].dataset.recordid)
                         if(selectedDivRows[i].dataset.recordid == event.currentTarget.dataset.recid){
                                 console.log('classname>>'+selectedDivRows[i].className);
                                 if(selectedDivRows[i].className == 'slds-hide'){
                                         selectedDivRows[i].className= 'slds-show';
                                 }else{
                                         selectedDivRows[i].className= 'slds-hide';
                                 }
                         }else{
                                 console.log('classname>>'+selectedDivRows[i].className);
                                 selectedDivRows[i].className= 'slds-hide';   
                         }
                 }
         }           

         }

        // Clear Filter
        clearFilter() {
         eval("$A.get('e.force:refreshView').fire();");
        }   
        cancelButton(){
                console.log('this.closeModal()');
                this.showDisburseform=false;
        }
        handleDisburseClick(){
               console.log('Disburse Called');
               
              
                doFundDisburment({student:this.selectedRecord,appln:this.applicationId,amtFunded:this.amountfunded,totalFundedAmt:this.disburseAmount})
                .then((result) => {
                        console.log('disburseAmount'+JSON.stringify(result));
                        this.showNotification('Success','Application Processed Successfully','Success');
                        this.clearFilter();
                   
                })
                .catch((error) => {
                  //      this.hideSpinnerOnPage();
                        this.error = error;
                        console.log('this.error'+JSON.stringify(error));
                     //   this.processResult = undefined;
                        this.showNotification('Error!','Sorry! Could not able to fetch details','error');
                });
        }

}