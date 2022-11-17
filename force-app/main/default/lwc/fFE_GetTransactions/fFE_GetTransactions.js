import { LightningElement,api  } from 'lwc';
import getBAUTransactions from '@salesforce/apex/WebServiceButtonHelper.getBAUTransactions';

export default class FFE_GetTransactions extends LightningElement {
    errormessage='';
    resultString='';
    @api selectedBatxns;
    
    handleClick(){
        console.log(this.selectedBatxns);
        debugger;
        if(this.errormessage.length===0){
            console.log('this.selectedBatxns'+this.selectedBatxns);
            getBAUTransactions({ BAU_Ids:this.selectedBatxns})
            .then((result) => {
                this.resultString = result;
                console.log(this.resultString);
                alert(this.resultString);
               
            })
            .catch((error) => {
                 this.resultString = undefined;
                 alert(this.resultString);
            });
        }else{
            alert(this.errormessage);
        }
    }

    connectedCallback() {
        debugger;
        if(this.selectedBatxns) {
            this.selectedBatxns = this.selectedBatxns.substring(1, this.selectedBatxns.length-1);
            this.selectedBatxns = this.selectedBatxns.split(',');
            this.handleClick();
        }else {
            alert('Please select atleast a BATXN record to proceed.');
        }
    }
}