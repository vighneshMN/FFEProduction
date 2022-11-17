import { api, wire, track, LightningElement } from 'lwc';
import { getRecord, getRecordNotifyChange, getFieldValue, createRecord } from 'lightning/uiRecordApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { CloseActionScreenEvent } from 'lightning/actions';
import APP_INTERNAL_STATUS_FIELD from '@salesforce/schema/Application__c.Internal_Status__c';
import APP_STUDENT_FIELD from '@salesforce/schema/Application__c.Student__c';
import APP_IS_MAPPED_FIELD from '@salesforce/schema/Application__c.IsMapped__c';
import APP_COURSE_NAME_FIELD from '@salesforce/schema/Application__c.Course_Name__c';
import APP_YEAR_FIELD from '@salesforce/schema/Application__c.Year__c';
import APPLICATION_OBJECT from "@salesforce/schema/Application__c";
import { NavigationMixin } from 'lightning/navigation';
export default class FfeAppAdditionalExpenseQuickActionLwc extends NavigationMixin(LightningElement) {
    
    @api recordId;
    @api objectApiName;

    /*@track objectInfo;*/
    @track APP_INTERNAL_STATUS_FIELD;
    @track APP_STUDENT_FIELD;

   @wire(getObjectInfo, { objectApiName: APPLICATION_OBJECT })
   objectInfo;
    

    applicationRecord = {};
    @wire(getRecord, {recordId : '$recordId', fields : [APP_INTERNAL_STATUS_FIELD,APP_STUDENT_FIELD,APP_IS_MAPPED_FIELD,APP_COURSE_NAME_FIELD,APP_YEAR_FIELD]})
    additionalexpense({error, data}){
        if(data){ 
            /*this.template.querySelector('c-ffe-popup-lwc').addEventListener("ok", e=> this.handleOk(), false);*/
            console.log(data);
            this.APP_INTERNAL_STATUS_FIELD = getFieldValue(data, APP_INTERNAL_STATUS_FIELD);
            this.APP_STUDENT_FIELD = getFieldValue(data,APP_STUDENT_FIELD);
            this.APP_IS_MAPPED_FIELD = getFieldValue(data,APP_IS_MAPPED_FIELD);
            this.APP_COURSE_NAME_FIELD = getFieldValue(data,APP_COURSE_NAME_FIELD);
            this.APP_YEAR_FIELD = getFieldValue(data,APP_YEAR_FIELD);
            if (this.APP_INTERNAL_STATUS_FIELD != null && 
                (this.APP_INTERNAL_STATUS_FIELD == 'Ready for Disbursement' || APP_INTERNAL_STATUS_FIELD == 'Disbursed'))
            {
                this.template.querySelector('c-ffe-popup-lwc').addEventListener("ok", e=> this.handleOk(), false);
                this.template.querySelector('c-ffe-popup-lwc').showPopup ('Are You Sure ?', 'Additional Expense', 'OK', 'Cancel');
                console.log('before calling apex method');
                

            }
            else{
                this.handleNoAdditionalExpense (); 
            }  
        }
        else{
            console.log('error while getting student id' + error);
        }
    }

    onSuccess (){
        this.template.querySelector('c-ffe-popup-lwc').showPopup ('Additional Expense Created', 'Additional Expense', 'OK', ''); 
    }

    onFail (){
        this.template.querySelector('c-ffe-popup-lwc').showPopup ('Opps!! Something went wrong.', 'Additional Expense', 'OK', ''); 
    }

    handleNoAdditionalExpense (){
        this.template.querySelector('c-ffe-popup-lwc').addEventListener("ok", e=> this.handleNoAdditionalExpenseOk(), false);
        this.template.querySelector('c-ffe-popup-lwc').showPopup ('Additional expense can be created only for applications which are in "Ready for Disbursement/Disbursed" status.', 'Additional Expense', 'OK', '');
    }

    handleNoAdditionalExpenseOk(){
        getRecordNotifyChange([{recordId: this.recordId}]);
        this.dispatchEvent(new CloseActionScreenEvent());
    }
    handleOk (){
        this.applicationRecord['Parent_Application__c'] = this.recordId;
        this.applicationRecord['Student__c'] = this.APP_STUDENT_FIELD;
        this.applicationRecord['IsMapped__c'] = this.APP_IS_MAPPED_FIELD;
        this.applicationRecord['Course_Name__c'] = this.APP_COURSE_NAME_FIELD;
        this.applicationRecord['Year__c'] = this.APP_YEAR_FIELD;
        const rtis = this.objectInfo.data.recordTypeInfos;
        this.applicationRecord['RecordTypeId'] = Object.keys(rtis).find(rti => rtis[rti].name === 'Additional Expense');
        const fields = this.applicationRecord;

        const recordInput = { apiName: APPLICATION_OBJECT.objectApiName, fields };

        createRecord(recordInput)
            .then((result) => {
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: result.id,
                        objectApiName: 'Application__c',
                        actionName: 'view'
                    }
                });
            })
            .catch((error) => {
                
            })
            .finally(() => {
                
            });
        
        getRecordNotifyChange([{recordId: this.recordId}]);
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}