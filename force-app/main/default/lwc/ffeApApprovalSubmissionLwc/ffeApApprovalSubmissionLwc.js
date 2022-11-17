import { api, wire, track, LightningElement } from 'lwc';
import { getRecord, updateRecord, getRecordNotifyChange, getFieldValue } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import IDFIELD from '@salesforce/schema/Application__c.Id';
import EXTERNALSTATUS from '@salesforce/schema/Application__c.External_Status__c';
import INTERNALSTATUS from '@salesforce/schema/Application__c.Internal_Status__c';
import COURSENAME from '@salesforce/schema/Application__c.Course_Name__c';
import APPLICATIONOWNER from '@salesforce/schema/Application__c.Application_owner__c';
import COLLEGEFEES from '@salesforce/schema/Application__c.Student_College_Fees__c';
import HOSTELMESSEXPENSE from '@salesforce/schema/Application__c.Student_Hostel_Mess_Expenses__c';
import BOOKEXPENSE from '@salesforce/schema/Application__c.Student_Books_Expenses__c';
import TRANSPORTEXPENSE from '@salesforce/schema/Application__c.Student_Transportation_Expenses__c';
import UNIFORMEXPENSE from '@salesforce/schema/Application__c.Student_Uniform_Expenses__c';
import TUTIONFEES from '@salesforce/schema/Application__c.Calc_Tuition_Fees__c'; 
import OTHERFEES from '@salesforce/schema/Application__c.Calc_Other_Fees__c'; 
import HOSETLESTABLISHMENTFEES from '@salesforce/schema/Application__c.Calc_Hostel_Establishment_Fees__c';
import AVGMESSFEES from '@salesforce/schema/Application__c.Calc_Average_Mess_Fees_per_month__c';
import TRANSPORTFEES from '@salesforce/schema/Application__c.Calc_Transportation_Expenses__c';
import BOOKFEES from '@salesforce/schema/Application__c.Calc_Book_Expenses__c';
import UNIFORMFEES from '@salesforce/schema/Application__c.Calc_Uniform_Expenses__c';
import OTHERAMOUNT from '@salesforce/schema/Application__c.Calc_Others__c';
import REQUESTEDFEES from '@salesforce/schema/Application__c.Amount_Requested__c';
import CURRENTUSERID from '@salesforce/user/Id';
import getPriceList from '@salesforce/apex/WebServiceButtonHelper.getPriceListLwc';
import submitToApprovalProcess from '@salesforce/apex/WebServiceButtonHelper.submitToApprovalProcessLwc';

export default class FfeApApprovalSubmissionLwc extends LightningElement {
    @api recordId; 
    @track appRecord; 
    showDetails = false; 
    specialDonor = false;
    requestedAmount = 0; 
    @track priceList = [];
    scholarshipAmount;
    courseName; 
    applicationOwner; 
    tempfields = {}; 

    @wire(getRecord, {recordId : '$recordId', fields : [EXTERNALSTATUS, INTERNALSTATUS, 
        //COLLEGEFEES, HOSTELMESSEXPENSE, BOOKEXPENSE, TRANSPORTEXPENSE, UNIFORMEXPENSE, 
        COURSENAME, APPLICATIONOWNER, 
        TUTIONFEES, OTHERFEES, HOSETLESTABLISHMENTFEES, AVGMESSFEES, TRANSPORTFEES, 
        BOOKFEES, UNIFORMFEES, OTHERAMOUNT, REQUESTEDFEES]})
    application({error, data}){
        console.log('record id' + this.recordId);
        if(data){ 
            //this.applicationRecord = ; 
            this.appRecord = data; 
            this.evaluateSubmission(data);             
        }
        else{
            console.log('error while getting application id:: ' + error);
        }
    }

    handleOk (){
        getRecordNotifyChange([{recordId: this.recordId}]);
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    handleOkNoClose (){}

    

    handleChangeInOption(event){
        this.scholarshipAmount = event.detail.value;
    }


    evaluateSubmission (applicationRecord){
        var extStatus = getFieldValue(applicationRecord, EXTERNALSTATUS);
        if (extStatus != 'Document Missing'){
            var intStatus = getFieldValue(applicationRecord, INTERNALSTATUS);
            if (intStatus != 'Pending_Approval')
            {
                if (extStatus != 'Approved'){
                    if(intStatus == 'Pending_FFE_Staff_Review' || intStatus == 'Pending FFE Staff Review'
                        || intStatus== 'Re-evaluate Application')
                    {
                        this.courseName = getFieldValue(this.appRecord, COURSENAME); 
                        this.applicationOwner  = getFieldValue (this.appRecord, APPLICATIONOWNER); 
                        this.requestedAmount = getFieldValue(applicationRecord, REQUESTEDFEES);
                        this.retrivePricelist();
                        this.showDetails = true; 
                        
                    }
                    else {
                        this.template.querySelector('c-ffe-popup-lwc').addEventListener("ok", e=> this.handleOk(), false);
                        this.template.querySelector('c-ffe-popup-lwc').showPopup ('Approval cannot be sent for current Internal Status', 'Approval Submission', 'OK', '');         
                    }
                }
                else{
                    this.template.querySelector('c-ffe-popup-lwc').addEventListener("ok", e=> this.handleOk(), false); 
                    this.template.querySelector('c-ffe-popup-lwc').showPopup ('Application is already approved', 'Approval Submission', 'OK', ''); 
                }
            }
            else{
                this.template.querySelector('c-ffe-popup-lwc').addEventListener("ok", e=> this.handleOk(), false); 
                this.template.querySelector('c-ffe-popup-lwc').showPopup ('Application is already pending for approval', 'Approval Submission', 'OK', ''); 
            }
        }
        else {
            this.template.querySelector('c-ffe-popup-lwc').addEventListener("ok", e=> this.handleOk(), false); 
            this.template.querySelector('c-ffe-popup-lwc').showPopup ('Record cannot be sent for Approval, because External status is "Document Missing"', 'Approval Submission', 'OK', ''); 
        }
         
    }
     
    retrivePricelist(){
        getPriceList({appId : this.recordId})
            .then((result) => {        
                result.forEach(opt => { 
                    const option = {
                        label: opt,
                        value: opt
                    };
                    //this.priceList.push({label : opt, value: opt})
                    this.priceList = [ ...this.priceList, option];
                });
                //this.priceList.push({key: result, value: result});
            })
            .catch((error) => {
                console.log(error);
                return null;
            });
    }

    setSpecialDonor (ev){
        console.log(ev.target.checked); 
        this.specialDonor = ev.target.checked; 
        if (!this.specialDonor){
            this.requestedAmount = 0;
        }
    }

    handleChange (ev){
        let sum = 0; 

        this.template.querySelectorAll ('.allinput').forEach(element => { 
            console.log(element.getAttribute('data-field')); 
            console.log (REQUESTEDFEES.fieldApiName); 
            console.log(element.label + ':: ' + element.value); 
            if(element.getAttribute('data-field') == REQUESTEDFEES.fieldApiName){
                return; 
            }
            
            if (isNaN(element.value)){
                this.template.querySelector('c-ffe-popup-lwc').addEventListener("ok", e=> this.handleOkNoClose(), false);
                this.template.querySelector('c-ffe-popup-lwc').showPopup ('Please enter valid ' + element.label, 'Approval Submission', 'OK', '');   
            }
            let temp = isNaN (parseInt(element.value)) ? 0 : parseInt(element.value);
            if(element.getAttribute('data-field') == AVGMESSFEES.fieldApiName){
                let messCharges;  
                if (this.courseName == 'MBBS'){
                    messCharges = temp * 11; 
                }
                else {
                    messCharges = temp * 10;
                }
                sum += messCharges; 
            }
            else {
                sum += temp; 
            }
        });
        console.log (sum);
        this.requestedAmount = sum;
    }

    handleSubmit (){
        let isSuccess = false; 
        if (this.specialDonor){
            console.log('special Donar');
            isSuccess = this.handleSubmitForSpecialDonor(); 
            console.log (isSuccess); 
        }
        else{
            console.log('non special Donar');
            isSuccess = this.handleSubmitForNonSpecialDonor(); 
        }
        
        if (isSuccess){
            if (this.tempfields[REQUESTEDFEES.fieldApiName] > 0){
                if (this.applicationOwner == ''){
                    this.tempfields[APPLICATIONOWNER.fieldApiName] = CURRENTUSERID;
                }
                let fields = this.tempfields; 
                const recordInput = { fields };
                console.log (recordInput);

                updateRecord(recordInput)
                    .then(() => {
                        this.submitForApproval();                 
                    })
                    .catch(error => {
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Error creating record',
                                message: error.body.message,
                                variant: 'error'
                            })
                        );
                        console.log('error : '+error);
                    });
            }
            else{
                this.template.querySelector('c-ffe-popup-lwc').addEventListener("ok", e=> this.handleOkNoClose(), false);
                this.template.querySelector('c-ffe-popup-lwc').showPopup ('Scholarship Amount cannot be Zero or Negative', 'Approval Submission', 'OK', ''); 
            } 
        }       
    }

    submitForApproval (){
        submitToApprovalProcess ({appId: this.recordId, currentSubmitterID: CURRENTUSERID, approvalProcessName:"Student_scholarship_status"})
            .then((result) => {
                this.template.querySelector('c-ffe-popup-lwc').addEventListener("ok", e=> this.handleOk(), false);      
                this.template.querySelector('c-ffe-popup-lwc').showPopup ('Successfully submitted for approval', 'Approval Submission', 'OK', ''); 
                
                //this.priceList.push({key: result, value: result});
            })
            .catch((error) => {
                console.log('error : '+error.body.message);
                this.template.querySelector('c-ffe-popup-lwc').addEventListener("ok", e=> this.handleOk(), false);
                this.template.querySelector('c-ffe-popup-lwc').showPopup ('Failed approval submission', 'Approval Submission', 'OK', ''); 
                return null;
            });
    }

    handleSubmitForNonSpecialDonor (){
        console.log('in non doner method');
        if (isNaN (this.scholarshipAmount) || typeof this.scholarshipAmount == undefined){
            this.template.querySelector('c-ffe-popup-lwc').addEventListener("ok", e=> this.handleOkNoClose(), false);
            this.template.querySelector('c-ffe-popup-lwc').showPopup ('Select the Scholarship Amount to proceed further', 'Approval Submission', 'OK', ''); 
            console.log(this.scholarshipAmount);
            return false; 
        }
        this.tempfields[IDFIELD.fieldApiName] = this.recordId;
        this.tempfields[REQUESTEDFEES.fieldApiName] = this.scholarshipAmount;
        console.log('end of all statements');
        return true; 
    }

    handleSubmitForSpecialDonor(){
        const allValid = [...this.template.querySelectorAll('.allinput')]
            .reduce((validSoFar, inputFields) => {
                inputFields.reportValidity();
                return validSoFar && inputFields.checkValidity();
            }, true);

        if (allValid) {
            console.log('its all valid'); 
            this.tempfields[IDFIELD.fieldApiName] = this.recordId;
             
            this.template.querySelectorAll ('.allinput').forEach(element => {
                let fieldApiName = element.getAttribute('data-field'); 
                let temp = element.value; 
                console.log(temp);
                if (fieldApiName == TUTIONFEES.fieldApiName || fieldApiName == OTHERFEES.fieldApiName 
                    || fieldApiName == HOSETLESTABLISHMENTFEES.fieldApiName){
                    
                    if (temp.length == 0){
                        this.tempfields[COLLEGEFEES.fieldApiName] = 0; //element.value;
                    }
                    else{
                        this.tempfields[fieldApiName] = isNaN(parseInt(temp)) ? 0 : parseInt(temp);
                    }
                }
                else if(fieldApiName ==AVGMESSFEES.fieldApiName){
                    if (temp.length == 0){
                        this.tempfields[HOSTELMESSEXPENSE.fieldApiName] = 0; //element.value;
                    }
                    else{
                        this.tempfields[fieldApiName] = isNaN(parseInt(temp)) ? 0 : parseInt(temp);
                    }

                }
                else {   
                    this.tempfields[fieldApiName] = temp.length == 0 ? 0 : (isNaN(parseInt(temp)) ? 0 : parseInt(temp));
                }
            }); 

            console.log('recordinput : '+this.recordInput); 
            return true; 
            /*
        updateRecord(recordInput)
                .then(() => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Contact updated',
                            variant: 'success'
                        })
                    );
                    // Display fresh data in the form
                    return refreshApex(this.contact);
                })
                .catch(error => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error creating record',
                            message: error.body.message,
                            variant: 'error'
                        })
                    );
                });*/

        }
        return false; 


       
    }
}