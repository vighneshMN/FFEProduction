import { LightningElement,api,wire } from 'lwc';
//import getFormDetails from '@salesforce/apex/ffePaymentGenerate80GForm_CTRL.getTaxExemptionFormDetails';
import FFElogoLabel from '@salesforce/label/c.FFElogo';

const headercolumns = [
    { label: '(Registered as Public Charitable Trust. Regn. No:BNG(U)-JNR160/2003-2004,Bangalore)',hideDefaultActions: true},
    { label: 'PAN - AAATF0985D;&nbsp;&nbsp;FCRA Registration No:094421348', fieldName: 'recordLink',hideDefaultActions: true },
    { label: '#840,"MHT HOUSE" FIRST FLOOR, 5TH MAIN, INDRANAGAR FIRST STAGE, BENGALURU, KARNATAKA, 560038',hideDefaultActions: true },
    { label: 'Website: www.ffe.org ; Ph: 080-25201925/42042654', hideDefaultActions: true },
];
export default class FfeTaxExemptionForm extends LightningElement {
    @api paymentRecordId;
    headercolumns = headercolumns;
    label = {
        FFElogoLabel
    }
   /* @wire(getFormDetails, {paymentId : '$paymentRecordId'})
    formDetails({error, data}){
    }*/
}