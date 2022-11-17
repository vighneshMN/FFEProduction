import { api, wire, LightningElement } from 'lwc';
import { getRecord, getRecordNotifyChange, getFieldValue } from 'lightning/uiRecordApi';
import { CloseActionScreenEvent } from 'lightning/actions';
import checkStage from '@salesforce/apex/DonationAllocationAmtCalculation.checkOpportunityStageLwc';
import STAGENAME from '@salesforce/schema/Opportunity.StageName';
import PAYMENTORDER from '@salesforce/schema/Opportunity.Payment_Order__c';
import CCAPAYSTATUS from '@salesforce/schema/Opportunity.Payment_Order__r.CCAvenue_Payment_Status__c';
import ORDERNUM from '@salesforce/schema/Opportunity.Order_No__c';
import NPSPPRIMCONTACT from '@salesforce/schema/Opportunity.npsp__Primary_Contact__c';


export default class FfePostedLwc extends LightningElement {
    @api recordId;
 
    @wire(getRecord, {recordId : '$recordId', fields : [STAGENAME, PAYMENTORDER, CCAPAYSTATUS, ORDERNUM, NPSPPRIMCONTACT]})
    donation({error, data}){
        if(data){
            this.template.querySelector('c-ffe-popup-lwc').addEventListener("ok", e=> this.handleOk(), false);          
            let stageName = getFieldValue(data, STAGENAME);
            console.log('stageName--',stageName);
            if (stageName == 'Pledged'){
                let paymentOrder = getFieldValue(data, PAYMENTORDER); 
                console.log('paymentOrder--',paymentOrder);
                if (paymentOrder != null && paymentOrder != ''){
                   let ccaPayStatus = getFieldValue(data, CCAPAYSTATUS); 
                   console.log('ccaPayStatus--',ccaPayStatus);
                   if (ccaPayStatus == 'Success'){
                       let orderNum = getFieldValue(data, ORDERNUM);                        
                       let conId = getFieldValue(data, NPSPPRIMCONTACT);
                       checkStage({orderno : orderNum, oppid: this.recordId, contactid: conId})
                       .then(result =>{
                           if (result !=''){
                               this.template.querySelector('c-ffe-popup-lwc').showPopup (result, 'Posted', 'OK', '');
                           }
                           else{
                               this.handleOk(); 
                           }
                        })
                       .catch(error =>{
                           this.showToast ('Error', 'Something went wrong.', 'error', 'dismissable');
                       })
                   }
                   else{
                       this.template.querySelector('c-ffe-popup-lwc').showPopup ('Associated Payment Order is incomplete.', 'Posted', 'OK', '');     
                   }
                }
                else{
                    this.template.querySelector('c-ffe-popup-lwc').showPopup ('There is No Payment Order associated with this Donation.', 'Posted', 'OK', '');     
                }
            }
            else{
                this.template.querySelector('c-ffe-popup-lwc').showPopup ('Donation should be in "Pledged" stage.', 'Posted', 'OK', ''); 
            }
        }
        else{
            console.log('error while getting donation details' + error);
        }
    }

    handleOk (){
        getRecordNotifyChange([{recordId: this.recordId}]);
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}