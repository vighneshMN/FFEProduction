import { LightningElement, api } from 'lwc';
import getDocRecordClsWrapper from '@salesforce/apex/DocumentUploadLwc.getDocRecordClsWrapper';
import submit from '@salesforce/apex/DocumentUploadLwc.submit';
import { CloseActionScreenEvent } from 'lightning/actions';
const columns = [
    { label: 'Category', fieldName: 'docrelated' },
    { label: 'Document Name', fieldName: 'docObj' }
];

export default class FfeStudentDocumentsLwc extends LightningElement {
    @api recordId;
    retrievedRecordId = false;
    documentList = [];
    columns = columns;
    data= [];
    preSelectedRows = [];
    selectedRowNumber = [];
    showClose= false;
    message;
    showSpinner = false;

    renderedCallback(){
        console.log('Rendered callback called ');
        // if(this.recordId == undefined || this.recordId == null || this.recordId == ''){
        //     console.log('Apex within renderd callback called ');
        //     getDocRecordClsWrapper({conId : this.recordId})
        //     .then(result =>{
        //         console.log('Success ', result);
        //     })
        //     .catch(error =>{
        //         console.log('Error ' , error);
        //     })
        // }

        if (!this.retrievedRecordId && this.recordId) {
            this.showSpinner = true;
            this.retrievedRecordId = true; // Escape case from recursion
            console.log('Found recordId: ' + this.recordId);
            // Execute some function or backend controller call that needs the recordId
            getDocRecordClsWrapper({conId : this.recordId})
            .then(result =>{
                console.log('Success ');
                console.log(result);
                this.data = result;
                for(let dataObj of this.data){
                    if(dataObj.isSelected){
                       //this.preSelectedRows.push(dataObj.rowNum);
                       this.preSelectedRows = [...this.preSelectedRows,dataObj.rowNum];
                       this.selectedRowNumber = [...this.selectedRowNumber,dataObj.rowNum];     
                    }
                }
                console.log('Check preselected');
                this.preSelectedRows.forEach(item =>{
                    console.log(item);
                })
                this.showSpinner = false;
            })
            .catch(error =>{
                console.log('Error ' , error);
                this.showSpinner = false;
            })
        }
    }

    handleSubmitClick(){
        this.showSpinner = true;
        console.log('Submit click called');
        this.data.forEach(item =>{
            if(this.selectedRowNumber.includes(item.rowNum)){
                item.isSelected = true;
            }else{
                item.isSelected = false;
            }
        });
        submit({docRecordList : this.data, conId :this.recordId})
        .then(result =>{
            console.log('Message from apex ', result);
            this.showClose= true;
            this.message = result;
            this.showSpinner = false;
        })
        .catch(error =>{
            console.log('Error ', result);
            this.showSpinner = false;
        })
    }

    handleSelection(event){
        console.log('Handle selection called ');
        console.log('Selected row num');
        this.selectedRowNumber = [];
        const selectedRows = event.detail.selectedRows;
        selectedRows.forEach(item =>{
            console.log(item.rowNum);
            this.selectedRowNumber.push(item.rowNum);
        })
    }

    handleCloseClick(event){
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}