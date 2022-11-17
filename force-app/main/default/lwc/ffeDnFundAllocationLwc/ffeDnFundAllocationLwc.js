import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

// Import methods
import getApplicationType from '@salesforce/apex/FFE_DN_Fund_AllocationClass.getApplicationType';
import getStudentswithApplication from '@salesforce/apex/FFE_DN_Fund_AllocationClass.getStudentswithApplication';
import getDonorStudentMapping from '@salesforce/apex/FFE_DN_Fund_AllocationClass.getDonorStudentMapping';
import disburseAllFund from '@salesforce/apex/FFE_DN_Fund_AllocationClass.disburseAllFund';
import getGauOptions from '@salesforce/apex/FFE_DN_Fund_AllocationClass.getGauOptions';
import getGAUWiseDonorBalance from '@salesforce/apex/FFE_DN_Fund_AllocationClass.getGAUWiseDonorBalance'; 

// Import custom labels
import ALL_AWAITING_STUDENT from '@salesforce/label/c.All_Awaiting_Student';
import ALL_MAPPED_STUDENT from '@salesforce/label/c.All_Mapped_Student';
import ALL_UNMAPPED_STUDENT from '@salesforce/label/c.All_UnMapped_Student';

export default class FfeDnFundAllocation extends LightningElement {

        //Variables
        @track showSaveDonors = true;
        @track showAddFund = true;
        @track showDisburse = false;
        @track showAddFundPageTableButtons = false;
        @track disburseDis = false;
        @track addFundPop = false;
        applTypeOptions = [];
        gauOptions = [];
        extraFundsRecords=[];
        selectedStudentBy;
        donorCategoryValue;
        childRecords = [];
        selectedChildRecord;
        selectedParentRecord;
        selectedGAUid;
        selectedCategoryValue;
        studentsMatch={Amount_Funded__c:'0',Amount_Requested__c:'0',ApplName:'',Remaining_Fund__c:'0',currentlyFunded:'0'};
        parentIndex;
        studentContact;
        remainingFromDonor;
        DonorExtraFunds=false;
        DonorPopup=false;
        studentPopup=false;
        studentFundsDetails;
        @track extraDonors=[];
        @track NODonorMappingresults=[];
        recordsOfGau=[];
        totalIndexAmount=[];
        indexArray=[];
        @track DonorMappingresults = [];        
        selectedApplType = [];
        showDonor = [];
        searchByDnFfuid = '';
        selectedStdFilter = [];
        @track showStudentResult = [];
        @api showLoadSpinner = false;
        @api showStudentDetails = false;
        @api showChildTable = false;
        @track openModal = false;

        //Filter value methods
        get studentByOptions() {
                return [
                { label: ALL_AWAITING_STUDENT, value: ALL_AWAITING_STUDENT },
                { label: ALL_MAPPED_STUDENT, value: ALL_MAPPED_STUDENT },
                { label: ALL_UNMAPPED_STUDENT, value: ALL_UNMAPPED_STUDENT },
                ];
        }
        //Filter value methods
        get donorCategoryOptions() {
                return [
                { label: 'Individual', value: 'Individual' },
                { label: 'Corporate', value: 'Corporate' },
                { label: 'Foundation', value: 'Foundation' },
                { label: 'Charitable Trust', value: 'Charitable Trust' },
                { label: 'Corporate Individual', value: 'Corporate Individual' },
                { label: 'Scholar', value: 'Scholar' },
                { label: 'Non Profit Organization', value: 'Non Profit Organization' },
                { label: 'Other', value: 'Other' },
                ];
        }

        showModal() {
                this.studentPopup = true;
        }
        closeModal() {
                this.studentPopup = false;
        }
        showAddFundModal() {
                this.DonorExtraFunds = true;
        }
        closeAddFundModal() {
                this.DonorExtraFunds = false;
        }
        closeAllModals(){
                this.studentPopup = false;
                this.DonorExtraFunds = false;

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
        
        @wire(getApplicationType)
                wiredApplicationType({ error, data }){
                if(data){
                        for(const valueObject of data){
                        this.applTypeOptions = [...this.applTypeOptions,{value: valueObject.Id, label:valueObject.Name}];
                        }
                }else if(error){
                        console.log('Error in the wired Application Options list ', error);
                }
        }
        
        @wire(getGauOptions)
                wiredApplicationType({ error, data }){
                if(data){
                        let result = JSON.parse(data);
                        for(var i = 0; i < result.length; i++){
                                const option = {
                                        label : result[i].Name,
                                        value : result[i].Id
                                };
                                this.gauOptions = [...this.gauOptions, option];
                            
                        }
                }else if(error){
                        console.log('Error in fetching GAU Options '+error);
                }
        }

        //Captured selected filter 
        handleStdByChange(event) {
                this.selectedStudentBy = event.detail.value;
                console.log('selectedStudentBy>>'+this.selectedStudentBy);
        }
        handleDonorCatChange(event) {
                this.selectedCategoryValue = event.detail.value;
                console.log('selectedCategoryValue>>'+this.selectedCategoryValue);
        }
        handleGauChange(event) {
                this.selectedGAUid = event.detail.value;
                console.log('selectedGAUid>>'+this.selectedGAUid);
        }
        handleApplType(event){
                console.log('handleApplType>>' , event.detail.label);
                console.log('handleApplType0>>' , event.detail.value);
                this.selectedApplType = event.detail;
                const index = this.selectedApplType.indexOf('--None--');
                if (index > -1) {
                        this.selectedApplType.splice(index, 1);
                }
        }
        handleDnFfeuidValue(event){
                console.log('handleDnFfeuidValue>>' , event.detail.value);
                this.searchByDnFfuid = event.detail.value;
        }
        handleParentTable(event){
                this.showLoadSpinner = true;
                console.log('handleParentTable>>' , event.detail);
                
                console.log('handleParentTableID>>' ,  event.currentTarget.dataset.id);
                console.log('recId>>' ,  event.currentTarget.dataset.recid);
                let selectedDivRows = this.template.querySelectorAll('section');
                this.showChildTable = true;
                for(let i = 0; i < selectedDivRows.length; i++) {
                        console.log('cheking>>'+selectedDivRows[i].dataset.id);

                        if(selectedDivRows[i].dataset.id === 'divblock') {
                                console.log('key>>'+selectedDivRows[i].dataset.recordid)
                                if(selectedDivRows[i].dataset.recordid == event.currentTarget.dataset.recid){                                        
                                        this.selParentRecId = selectedDivRows[i].dataset.recordid;
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
                
                this.showLoadSpinner = false;          

        }
        // Process Method
        match(event){
                this.showLoadSpinner = true;

                console.log('index>>' + event.currentTarget.dataset.index)
                console.log('parentIndex>>'+this.parentIndex);
                console.log('selParentRecId>>'+this.selParentRecId);
                for(let i = 0; i < this.showStudentResult.length; i++) {
                        if(this.showStudentResult[i].value.Id == this.selParentRecId){ 
                                console.log('childRecords00>>'+this.showStudentResult[i].value.Applications__r);                                        
                                this.childRecords = this.showStudentResult[i].value.Applications__r;
                                this.selectedParentRecord = this.showStudentResult[i].value;
                                this.selectedChildRecord = this.childRecords[event.currentTarget.dataset.index];
                        }
                }
                console.log('childRecords>>'+this.childRecords);
                this.studentsMatch = this.selectedChildRecord;
                if(this.selectedChildRecord.Amount_Funded__c!=undefined){
                        this.studentsMatch.Amount_Funded__c=this.selectedChildRecord.Amount_Funded__c;
                }
                else{
                        this.studentsMatch.Amount_Funded__c=0;
                }
                if(this.selectedChildRecord.Amount_Requested__c!=undefined){
                        this.studentsMatch.Amount_Requested__c=this.selectedChildRecord.Amount_Requested__c;
                }
                else{
                        this.studentsMatch.Amount_Requested__c=0;
                }
                if(this.selectedChildRecord.Remaining_Fund__c!=undefined){
                        this.studentsMatch.Remaining_Fund__c=this.selectedChildRecord.Remaining_Fund__c;
                }
                else{
                        this.studentsMatch.Remaining_Fund__c=0;
                }
                this.studentsMatch.ApplName	= this.selectedChildRecord.RecordType.Name;
                this.studentsMatch.currentlyFunded =0;
                this.studentContact = this.selectedParentRecord;
                this.studentPopup=true;
                this.studentFundsDetails=this.selectedChildRecord;
                this.recordsOfGau=[];
                this.totalIndexAmount=[];
                this.indexArray=[];
                console.log('Here: '+this.studentsMatch);
                getDonorStudentMapping({applicationId: this.selectedChildRecord.Id})
                .then((result) => {                                
                        console.log('Result>>'+result);
                        this.DonorMappingresults= JSON.parse(result);                                
                        console.log('DonorMappingresults>>'+this.DonorMappingresults);
                        this.showDonor.length=this.DonorMappingresults.length;
                        if(this.DonorMappingresults.length > 0){
                                console.log('len>>'+this.DonorMappingresults.length);
                                for(var i=0;i<this.DonorMappingresults.length;i++){
                                        this.showDonor[i]=false;
                                }
                                for(var i=0;i<this.DonorMappingresults.length;i++){
                                        if(this.DonorMappingresults[i].Donor_Balances__r != undefined && 
                                                this.DonorMappingresults[i].Donor_Balances__r.records != undefined){
                                                for(var j=0;j<this.DonorMappingresults[i].Donor_Balances__r.records.length;j++){
                                                        this.DonorMappingresults[i].Donor_Balances__r.records[j].extraFunds=0;
                                                        this.DonorMappingresults[i].Donor_Balances__r.records[j].totalExtraFunds=0;
                                                }
                                        }
                                        if(this.DonorMappingresults[i].GAU_Name__r == undefined){
                                                this.DonorMappingresults.pop(i);

                                        }        
                                }
                        }
                        console.log('final>>'+JSON.stringify(this.DonorMappingresults));
                })
                .catch((error) => {              
                        console.log('error>>'+JSON.stringify(error)); 
                        this.showNotification('Error!','Sorry! Could not able to fetch details','error');
                });                             
                //this.showModal();
                //to enable/disable disburse button
                this.showDisburse = false;
                this.showLoadSpinner = false;
        }
        // Process Method
        matchNodonor(event){
                this.showLoadSpinner = true;
                for(let i = 0; i < this.showStudentResult.length; i++) {
                        if(this.showStudentResult[i].value.Id == this.selParentRecId){ 
                                console.log('childRecords00>>'+this.showStudentResult[i].value.Applications__r);                                        
                                this.childRecords = this.showStudentResult[i].value.Applications__r;
                                this.selectedParentRecord = this.showStudentResult[i].value;
                                this.selectedChildRecord = this.childRecords[event.currentTarget.dataset.index];
                        }
                }
                console.log('childRecords>>'+this.childRecords); 
                this.studentsMatch = this.selectedChildRecord;
                
                this.showNoresults=false;
                if(this.selectedChildRecord.Amount_Funded__c!=undefined){
                        this.studentsMatch.Amount_Funded__c=this.selectedChildRecord.Amount_Funded__c;
                }
                else{
                        this.studentsMatch.Amount_Funded__c=0;
                }
                if(this.selectedChildRecord.Amount_Requested__c!=undefined){
                        this.studentsMatch.Amount_Requested__c=this.selectedChildRecord.Amount_Requested__c;
                }
                else{
                        this.studentsMatch.Amount_Requested__c=0;
                }
                if(this.selectedChildRecord.Remaining_Fund__c!=undefined){
                        this.studentsMatch.Remaining_Fund__c=this.selectedChildRecord.Remaining_Fund__c;
                }
                else{
                        this.studentsMatch.Remaining_Fund__c=0;
                }
                this.remainingFromDonor=this.studentsMatch.Remaining_Fund__c;
                this.studentsMatch.ApplName=this.selectedChildRecord.RecordType.Name;
                this.studentsMatch.currentlyFunded =0;
                this.studentContact = this.selectedParentRecord;
                this.studentFundsDetails=this.selectedChildRecord;
                this.DonorExtraFunds=true;
                this.DonorPopup=true;
                this.extraDonors=[];
                this.NODonorMappingresults=[];
                this.totalIndexAmount=[];
                this.indexArray=[];
                //to enable/disable disburse button
                this.showDisburse = false;  
                this.showLoadSpinner = false;             
        }
        // Search Method
        getStudentswithApplication(){
                this.showLoadSpinner = true;
                this.showStudentResult = [];
                this.selectedStdFilter.push({
                        studentType: this.selectedStudentBy,
                        applType: this.selectedApplType
                })
                console.log('97>>'+this.selectedApplType);
                if(this.selectedStdFilter.length>0){
                        getStudentswithApplication({applType: this.selectedApplType, 
                                                studentType: this.selectedStudentBy 
                        })
                        .then((result) => {
                                console.log('result>>'+JSON.stringify(result));
                                for(let key in result) {
                                // Preventing unexcepted data
                                if (result.hasOwnProperty(key)) { // Filtering the data in the loop
                                        this.showStudentResult.push({value:result[key], Applications__r:result[key.Applications__r]});
                                }
                                }
                                this.error = undefined;
                                this.showStudentDetails = true;
                                console.log('showStudentResult0>>'+this.showStudentResult);
                                console.log('showStudentResult>>'+JSON.stringify(this.showStudentResult));
                                if (this.showStudentResult.length>0) {
                                        this.showStudentDetails = true;
                                }
                                this.showLoadSpinner = false;
                        })
                        .catch((error) => {
                                this.showLoadSpinner = false;
                                this.error = error;
                                this.processResult = undefined;
                                this.showStudentDetails = false;
                                this.showNotification('Error!','Sorry! Could not able to fetch details','error');
                        });
                }

        }

        //Enter fund to dsburse calculation (Add Fund button screen)
        handleExtraAddFunds(event){
                let fundExtraEntered;
                this.extraDonors[event.currentTarget.dataset.addfundindex].totalExtraFunds=new Number(event.detail.value);
                fundExtraEntered = event.detail.value;
                if(fundExtraEntered > this.extraDonors[event.currentTarget.dataset.addfundindex].totalExtraFunds){
                        this.showAddFundPageTableButtons = false;
                }else{
                        this.showAddFundPageTableButtons = true;
                }
        }

        //Enter fund to dsburse calculation
        handleExtraFunds(event){
                let fundEntered;
                //this.totalExtraFunds = event.detail.value;
                this.DonorMappingresults[event.currentTarget.dataset.parentindex].Donor_Balances__r.records[event.currentTarget.dataset.childid].totalExtraFunds=new Number(event.detail.value);
                fundEntered = event.detail.value;
                if(fundEntered > this.DonorMappingresults[event.currentTarget.dataset.parentindex].Donor_Balances__r.records[event.currentTarget.dataset.childid].Current_Balance__c){
                        this.showSaveDonors = false;
                        console.log('dissableSaveDonors>>'+this.dissableSaveDonors);
                }else{
                        this.showSaveDonors = true;
                        this.showAddFund = true;
                }

                if(fundEntered > this.studentsMatch.Amount_Requested__c){
                        this.showAddFund = false;
                        this.showSaveDonors = false;
                }else{
                        this.showAddFund = true;
                }
        }

        //Add Fund - 1 Method
        addExtraDonors(){

                this.DonorExtraFunds = true;
        }

        saveExtraDonor(){
                if(this.studentFundsDetails.IsMapped__c){
                    var k=0;
                    var lengthOfDonor=this.DonorMappingresults[this.DonorIndex].Donor_Balances__r.records.length;
                    for(var j=0;j<extraDonors.length;j++){
                        this.isRecord=false;
                        if(extraDonors[j].extraFunds != undefined && extraDonors[j].extraFunds !=''){
                            if(parseInt(extraDonors[j].extraFunds) > 0){                    
                                
                                this.valuesForExtraDonor =extraDonors[j];
                                for(var m=0;m<this.DonorMappingresults[this.DonorIndex].Donor_Balances__r.records.length;m++){
                                    if((this.valuesForExtraDonor.Donor_Name__r.Id==this.DonorMappingresults[this.DonorIndex].Donor_Balances__r.records[m].Donor_Name__r.Id) && (this.valuesForExtraDonor.GAU_Name__r.Id==this.DonorMappingresults[this.DonorIndex].Donor_Balances__r.records[m].GAU_Name__r.Id)){
                                        this.DonorMappingresults[this.DonorIndex].Donor_Balances__r.records[m].extraFunds =parseInt(this.DonorMappingresults[this.DonorIndex].Donor_Balances__r.records[m].extraFunds)+parseInt(this.valuesForExtraDonor.extraFunds);
                                        this.isRecord=true;
                                    }
                                }
                                if(!this.isRecord){
                                    this.DonorMappingresults[this.DonorIndex].Donor_Balances__r.records[lengthOfDonor+k]=this.valuesForExtraDonor;
                                    k++;
                                }
                                
                                this.DonorExtraFunds= false;
                                this.DonorPopup=false;
                            }
                        }
                    }
                }
                else if(!this.studentFundsDetails.IsMapped__c){
                    if(this.NODonorMappingresults.length==0){
                        var k=0;
                        for(var i=0;i<this.extraDonors.length;i++){
                            if( this.extraDonors[i].extraFunds!=0 && this.extraDonors[i].extraFunds!=undefined){                      
                                this.NODonorMappingresults[k]= this.extraDonors[i];
                                k++
                            }
                        }
                    }else {
                        var length=this.NODonorMappingresults.length;
                        var m=0;
                        for(var i=0;i<this.extraDonors.length ;i++){
                            this.isNodonor = true;
                            for(var j=0;j<this.NODonorMappingresults.length;j++){
                                if((this.NODonorMappingresults[j].Donor_Name__r.Id==this.extraDonors[i].Donor_Name__r.Id) && (this.NODonorMappingresults[j].GAU_Name__r.Id==this.extraDonors[i].GAU_Name__r.Id)){
                                    if(this.extraDonors[i].extraFunds>0){
                                        this.NODonorMappingresults[j].extraFunds = parseInt(this.NODonorMappingresults[j].extraFunds)+parseInt(this.extraDonors[i].extraFunds);
                                        this.isNodonor = false;
                                        break;
                                    }
                                }
                            }
                            if(this.isNodonor){
                                if( this.extraDonors[i].extraFunds!=0 && this.extraDonors[i].extraFunds!=undefined){
                                    this.NODonorMappingresults[this.NODonorMappingresults.length]= this.extraDonors[i];
                                }
                            }
                        }
                    }
                    if(this.NODonorMappingresults.length>0){
                        this.DonorExtraFunds= false;
                        this.DonorPopup=false;
                        this.studentAllocationPopUp =true;
                        this.studentPopup=true;
                        this.getTotalDisburseNodonors(this.NODonorMappingresults);
                    }
                    
                }
                this.showLoadSpinner = false;

        }
        getTotalDisburseNodonors(){
                let notAllow= true;
                this.showLoadSpinner = true;
                
                
                for(var k=0;k<nodonors.length;k++){
                    if(nodonors[k].Current_Balance__c < nodonors[k].extraFunds){
                        //if(nodonors[k].extraFunds == ''){
                        //    swal({title:'',text:'The Funding amount cannot be empty either make it 0'});
                        //}
                        this.disburseDis=true;
                        this.addFundPop=true;
                        notAllow= false;
                    }
                }
                if(notAllow){
                    this.totalAmountNodonors=0;
                    this.addFundPop=false;
                    var totalAmount=0;
                    var total=0;
                    for(var j=0;j<this.NODonorMappingresults.length;j++){
                        if(this.NODonorMappingresults[j].extraFunds != undefined && this.NODonorMappingresults[j].extraFunds !=''){
                            total = total+parseInt(this.NODonorMappingresults[j].extraFunds)
                        }
                    }
                    if(total > (this.studentsMatch.Remaining_Fund__c+this.studentsMatch.Amount_Requested__c)){
                        this.disburseDis=true;
                        this.addFundPop=true;
                        swal({title:'',text:'The Amount Funded should be less than or equal to Amount Requested.'});
                        this.totalAmountNodonors=parseInt(total);
                        return;
                    }
                    this.studentsMatch.currentlyFunded = total;
                    this.studentsMatch.Remaining_Fund__c= this.studentsMatch.Amount_Requested__c- this.studentsMatch.currentlyFunded-this.studentsMatch.Amount_Funded__c;
                    if(this.studentsMatch.currentlyFunded > this.studentsMatch.Amount_Requested__c || this.studentsMatch.Remaining_Fund__c < 0){
                        this.disburseDis=true;
                        this.addFundPop=true;
                    }
                    else{
                        this.disburseDis=false;
                        this.addFundPop=false;
                    }
                    this.totalAmountNodonors=parseInt(total);
                }
                this.showLoadSpinner = false;

        }

        //Save method
        saveDonors(){
                this.showLoadSpinner = true;
                let totalFund = 0;
                for(var k=0;k<this.extraDonors.length;k++){
                        totalFund += new Number(this.extraDonors[k].totalExtraFunds);
                }

                for(var i=0;i<this.DonorMappingresults.length;i++){
                        if(this.DonorMappingresults[i].Donor_Balances__r != undefined && 
                                this.DonorMappingresults[i].Donor_Balances__r.records != undefined){
                                for(var j=0;j<this.DonorMappingresults[i].Donor_Balances__r.records.length;j++){
                                       totalFund += new Number(this.DonorMappingresults[i].Donor_Balances__r.records[j].totalExtraFunds);
                                }
                        }       
                }
                console.log('totalFund>>'+totalFund);
                this.studentsMatch.currentlyFunded = new Number(totalFund);
                this.studentsMatch.Remaining_Fund__c = this.studentsMatch.Amount_Requested__c- this.studentsMatch.currentlyFunded-this.studentsMatch.Amount_Funded__c;
                console.log('currentlyFunded>>'+this.studentsMatch.currentlyFunded);

                //to enable/disable disburse button
                if((this.studentsMatch.Remaining_Fund__c <= 0) || 
                        totalFund > this.studentsMatch.Amount_Requested__c - this.studentsMatch.Amount_Funded__c){
                                this.showDisburse = true;

                }else{
                        this.showDisburse = false;
                }

                if(this.DonorExtraFunds){
                        this.DonorExtraFunds = false;
                }
                this.showLoadSpinner = false;

        }
    
        disburse(){
                let disburseWrapper={};
                if(this.studentFundsDetails.IsMapped__c){
                        if(this.studentsMatch.currentlyFunded > 0){
                                if(this.studentsMatch.Remaining_Fund__c==0){
                                        disburseWrapper ={student:{},appln:{},amtFunded:[],totalFundedAmt:'',donorBalanceIds:[]};
                                        var k=0;
                                        for(var i=0;i<this.DonorMappingresults.length;i++){
                                                if(this.DonorMappingresults[i].Donor_Balances__r != undefined && 
                                                        this.DonorMappingresults[i].Donor_Balances__r.records != undefined){
                                                        for(var m=0;m<this.DonorMappingresults[i].Donor_Balances__r.records.length;m++){
                                                                if( parseInt(this.DonorMappingresults[i].Donor_Balances__r.records[m].extraFunds) !=undefined && parseInt(this.DonorMappingresults[i].Donor_Balances__r.records[m].extraFunds) !='' && parseInt(this.DonorMappingresults[i].Donor_Balances__r.records[m].extraFunds) != 0)
                                                                {
                                                                this.extraFundsRecords[k] =this.DonorMappingresults[i].Donor_Balances__r.records[m];
                                                                delete this.extraFundsRecords[k]["attributes"];
                                                                delete this.extraFundsRecords[k].Donor_Name__r["attributes"];
                                                                delete this.extraFundsRecords[k].GAU_Name__r["attributes"];
                                                                disburseWrapper.donorBalanceIds[k]=this.DonorMappingresults[i].Donor_Balances__r.records[m].Id;
                                                                k++;
                                                                }
                                                        }
                                                }
                                        }
                                        disburseWrapper.student=this.studentContact;
                                        delete disburseWrapper.student["attributes"];
                                        delete disburseWrapper.student["Applications__r"];
                                        delete disburseWrapper.student["$$hashKey"];
                                        disburseWrapper.appln=this.studentFundsDetails;
                                        delete disburseWrapper.appln["attributes"];
                                        delete disburseWrapper.appln["RecordType"];
                                        delete disburseWrapper.appln["$$hashKey"];
                                        for(var r=0;r<this.extraFundsRecords.length;r++){
                                                disburseWrapper.amtFunded.push({donorbalance:this.extraFundsRecords[r],extraFunds:this.extraFundsRecords[r].extraFunds});
                                                delete disburseWrapper.amtFunded[r].donorbalance["extraFunds"];
                                                delete disburseWrapper.amtFunded[r].donorbalance["$$hashKey"];
                                        }
                                        disburseWrapper.totalFundedAmt=this.studentsMatch.currentlyFunded;
                                        this.disburseFundMethod(disburseWrapper);
                                }
                                else{
                                        this.showNotification('Please make sure you are disbursing full amount.','warning');
                                }
                        
                        }
                        else{
                                this.showNotification('Please make sure you are disbursing full amount.','warning');
                                return;
                        }
                }
                else if(!this.studentFundsDetails.IsMapped__c){
                        if(this.studentsMatch.Remaining_Fund__c==0){
                        disburseWrapper ={student:{},appln:{},amtFunded:[],totalFundedAmt:'',donorBalanceIds:[]};
                        disburseWrapper.student=this.studentContact;
                        delete disburseWrapper.student["attributes"];
                        delete disburseWrapper.student["Applications__r"];
                        delete disburseWrapper.student["$$hashKey"];
                        disburseWrapper.appln=this.studentFundsDetails;
                        delete disburseWrapper.appln["attributes"];
                        delete disburseWrapper.appln["RecordType"];
                        delete disburseWrapper.appln["$$hashKey"];
                        for(var r=0;r<this.NODonorMappingresults.length;r++){
                                disburseWrapper.amtFunded.push({donorbalance:this.NODonorMappingresults[r],extraFunds:this.NODonorMappingresults[r].extraFunds});
                                disburseWrapper.donorBalanceIds[r]=this.NODonorMappingresults[r].Id;
                                delete disburseWrapper.amtFunded[r].donorbalance["extraFunds"];
                                delete disburseWrapper.amtFunded[r].donorbalance["$$hashKey"];
                                delete disburseWrapper.amtFunded[r].donorbalance["attributes"];
                                delete disburseWrapper.amtFunded[r].donorbalance.Donor_Name__r["attributes"];
                                delete disburseWrapper.amtFunded[r].donorbalance.GAU_Name__r["attributes"];
                        }
                        disburseWrapper.totalFundedAmt=this.studentsMatch.currentlyFunded;
                        this.disburseFundMethod(disburseWrapper);
                        }
                        else{
                                this.showNotification('Please make sure you are disbursing full amount.','warning');
                        }
                }
                this.showLoadSpinner = false;
        }
    
        disburseFundMethod(wrapper){
            console.log('Wrapper is: '+JSON.stringify(wrapper));
            disburseAllFund({fundWrp: wrapper})
            .then((result) => {
                    this.DonorExtraFunds = false;
                    this.studentPopup =false;
                    this.studentPopup=false;
                    this.DonorPopup=false;
                    this.showNotification(result,'info');
                    this.search(this.student,this.AppType);
                    this.studentsMatch.currentlyFunded =0;  
                    closeAllModals();
                    this.showLoadSpinner = false;               
                })
                .catch((error) => {
                        this.showSpinnerOnPage();
                });
                this.showLoadSpinner = false;
        }

        // Clear Filter
        clearFilter() {
                eval("$A.get('e.force:refreshView').fire();");
                this.showLoadSpinner = false;
        }
        
        //Search button for Add Extra Fund
        searchDonorByGau(){
                if(this.extraDonors.length > 0){
                        this.showAddFundPageTableButtons = true;
                }
                this.showLoadSpinner=true;
                this.showNoresults = false;
                if(this.selectedGAUid == null || this.selectedGAUid == '' || this.selectedCategoryValue == null || this.selectedCategoryValue == ''){
                    this.showLoadSpinner=false;
                    this.showNotification('Please select both Donor Category and GAU.','warning');
                    return;
                }
                getGAUWiseDonorBalance({gauId: this.selectedGAUid,donorCategorydata: this.selectedCategoryValue})
                .then((result) => {
                        this.extraDonors=JSON.parse(result);
                        for(var i=0;i<this.extraDonors.length;i++){
                            this.extraDonors[i].extraFunds=0;
                            this.extraDonors[i].totalExtraFunds=0;
                            if(this.extraDonors[i].Current_Balance__c==undefined || this.extraDonors[i].Current_Balance__c==''){
                                this.extraDonors[i].Current_Balance__c =0;
                            }
                            if(this.extraDonors[i].Blocked_Funds__c==undefined || this.extraDonors[i].Blocked_Funds__c==''){
                                this.extraDonors[i].Blocked_Funds__c =0;
                            }
                            if(this.extraDonors[i].Total_Available_Fund__c==undefined || this.extraDonors[i].Total_Available_Fund__c==''){
                                this.extraDonors[i].Total_Available_Fund__c =0;
                            }
                            if(this.extraDonors[i].Last_Instalment_Amount__c==undefined || this.extraDonors[i].Last_Instalment_Amount__c==''){
                                this.extraDonors[i].Last_Instalment_Amount__c =0;
                            }
                            
                        }
                        if(this.extraDonors.length > 0){
                            this.showNoresults = false;
                        }
                        else{
                            this.showNoresults = true;
                        }
                        if(this.studentFundsDetails.IsMapped__c){
                            if(this.recordsOfGau !=undefined){
                                for(var i=0;i<this.extraDonors.length;i++){
                                    for(var j=0;j<this.recordsOfGau.length;j++){
                                        if((this.recordsOfGau[j].Donor_Name__r.Id==this.extraDonors[i].Donor_Name__r.Id) && (this.recordsOfGau[j].GAU_Name__r.Id==this.extraDonors[i].GAU_Name__r.Id)){
                                            if(this.recordsOfGau[j].extraFunds!=undefined){
                                                this.extraDonors[i].Current_Balance__c = this.extraDonors[i].Current_Balance__c-this.recordsOfGau[j].extraFunds;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if (!this.studentFundsDetails.IsMapped__c){
                            for(var m=0;m<this.NODonorMappingresults.length;m++){
                                for(var i=0;i<this.extraDonors.length;i++){
                                    if((this.NODonorMappingresults[m].Donor_Name__r.Id==this.extraDonors[i].Donor_Name__r.Id) && (this.NODonorMappingresults[m].GAU_Name__r.Id==this.extraDonors[i].GAU_Name__r.Id)){
                                        if(this.NODonorMappingresults[m].extraFunds!=undefined){
                                            this.extraDonors[i].Current_Balance__c = this.extraDonors[i].Current_Balance__c-this.NODonorMappingresults[m].extraFunds;                    
                                        }
                                    }
                                }
                            }
                        }
                        this.showLoadSpinner=false;                    
                })
                .catch((error) => {
                        this.showLoadSpinner=false;
                        this.showNotification('Could n\'t complete search. Error: '+JSON.parse(error),'error');

                }); 
                this.showLoadSpinner = false;              
        }
}