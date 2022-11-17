import { LightningElement,track,api,wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import getDonorDetails from '@salesforce/apex/DonorDetails_Controller.getDonorDetais';



const columns = [
    { label: 'Label', fieldName: 'Donor_Name__c' },
    { label: 'FFEUID', fieldName: 'Donor_FFEUID__c' },
];

export default class DonorDetailComp extends LightningElement {
    data = [];
    columns = columns;
    @api recordId;
    @wire(getDonorDetails , { applicationId: '$recordId' })
    wiredRecordsMethod({ error, data }) {
        console.log('Hello'+data);
        if (data) {
            debugger;
            this.data = data;
           /*  if(this.lstAccounts){
                this.lstAccounts.forEach(item => item['AccountURL'] = '/lightning/r/Account/' +item['Id'] +'/view');
                
            }  */
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.data  = undefined;
        }
    }

   
}