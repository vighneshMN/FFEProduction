import { LightningElement,api,wire,track } from 'lwc';
import initMethod from '@salesforce/apex/ViewStudentHelper.initMethod';
import getStudentData from '@salesforce/apex/ViewStudentHelper.getStudentData';
import getBase64encoded from '@salesforce/apex/ViewStudentHelper.getBase64encoded';
import { loadScript } from 'lightning/platformResourceLoader';
import downloadjs from '@salesforce/resourceUrl/DownloadJs';

const columns = [
    { label: 'FFEUID', fieldName: 'FFEID' },
    { label: 'Student Name', fieldName: 'Name', type: 'text' },
    { label: 'Email Id', fieldName: 'Email', type: 'text' },
    { label: 'Mobile No', fieldName: 'MobilePhone', type: 'text' },
    { label: 'Gender', fieldName: 'Gender', type: 'text' },
    { label: '10%', fieldName: 'X10th', type: 'text' },
    { label: '12%', fieldName: 'X12th', type: 'text' },
    { label: 'Course', fieldName: 'Course', type: 'text' },
    { label: 'Branch', fieldName: 'Branch', type: 'text' }
];

export default class FfeStudentDataDownloadInWord extends LightningElement {
    @api recordId;
    gauNamesOptions = [];
    financialYearOptions = [];
    pdfFileNameLst = [];
    gauNameSelected;
    financialYearSelected;
    @track studentAttachmentList = [];
    showSpinner = false;
    errorMessage;
    columns = columns;
    downloadjsInitialized = false;

    renderedCallback(){
        if(this.downloadjsInitialized){
            return;
        }
        this.downloadjsInitialized = true;
        loadScript(this, downloadjs)
        .then(() => console.log('Loaded download.js'))
        .catch(error => console.log(error));
    }

    @wire (initMethod)
    wireInitMehotd({error,data}){
        if(data){
            for(const valueObject of data.gauNamesList){
                this.gauNamesOptions = [...this.gauNamesOptions,{value: valueObject,label: valueObject}];
            }
            for(const valueObject of data.financialYearDetailsList){
                this.financialYearOptions = [...this.financialYearOptions,{value: valueObject,label: valueObject}];
            }
            
        }else if(error){
            console.log('Error ' , error);
        }
    }


    handleGauChange(event){
        this.gauNameSelected = event.detail.value;
    }

    handleFinancialYearChange(event){
        this.financialYearSelected = event.detail.value;
    }

    handleSearchClick(event){
        console.log('Search called');
        this.errorMessage = '';
        if(this.gauNameSelected == '' || this.gauNameSelected == null || this.gauNameSelected == undefined){
            this.errorMessage = 'Please Select GAU';
            return;
        }
        if(this.financialYearSelected == '' || this.financialYearSelected == null || this.financialYearSelected == undefined){
            this.errorMessage = 'Please Select Financial Year';
            return;
        }
        this.showSpinner = true;
       getStudentData({Fyear : this.financialYearSelected, gau : this.gauNameSelected, donorId: this.recordId})
        .then(result =>{
            console.log('Success get student data ' , JSON.parse(result));
            this.studentAttachmentList = JSON.parse(result);
            this.showSpinner = false;
        })
        .catch(error =>{
            console.log('Error in get student data');
        })

    }

    get showError(){
        return this.errorMessage ? true : false;
    }

    get showtable(){
        return this.studentAttachmentList.length > 0;
    }

    handleDownloadClick(){
        this.showSpinner = true;
        this.errorMessage = '';
        this.pdfFileNameLst = [];
        console.log('Handle download click called');
        var selectedRecords = this.template.querySelector('lightning-datatable').getSelectedRows();
        console.log('Slected length ' , selectedRecords.length);
        console.log('Slected row ' , selectedRecords[0]);
        if(selectedRecords.length > 0){
            let downloadList = [];
            selectedRecords.forEach(row =>{
                let student = {
                    donorId : this.recordId,
                    financialYearSelected : this.financialYearSelected,
                    donatedAmt : row.donatedAmt,
                    scholarshipamt : row.scholarshipamt,
                    AttachmentLink : row.AttachmentLink
                }
                this.pdfFileNameLst = [...this.pdfFileNameLst,row.Name]
                downloadList = [...downloadList,student];
            });
            const jsonList = JSON.stringify(downloadList);
           getBase64encoded({jsonStudentList : jsonList})
            .then(result =>{
                console.log('Successful length', result.length);
                console.log('First ', result[0]);
                this.showSpinner = false;
                for(let i = 0 ;i < result.length; i++){
                    var strFile = "data:application/pdf;base64,"+result[i];
                    download(strFile,this.pdfFileNameLst[i], "application/pdf");
                }
                
            })
            .catch(error =>{
                console.log('Error  ', error);
                this.showSpinner = false;
            })
        }else{
            this.errorMessage = 'Please select a student to download the profile.';
            this.showSpinner = false;
        }

    }
}