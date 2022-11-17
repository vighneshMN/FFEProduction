import { LightningElement, wire, track } from 'lwc';
import getDecodeString from '@salesforce/apex/DecryptHashValue_CTLR.getDecodeStringLwc';

export default class DecryptHashValuesLwc extends LightningElement {
    @track hashVal='';
    @track error;
    @track req = false;
    @track encryVal;
    @track decryVal;
    @track showResult = false;
    @track msg1;
    @track msg2;
    handleChange(){
        this.showResult=false;
        this.req = false;
        this.template.querySelector('lightning-input').setCustomValidity( "" );
        this.template.querySelector('lightning-input').reportValidity();
    }
    handleSubmit(){

        this.hashVal = this.template.querySelector('lightning-input').value;
        if(this.template.querySelector('lightning-input').value){

            this.template.querySelector('lightning-input').setCustomValidity( "" );
            this.template.querySelector('lightning-input').reportValidity();
            getDecodeString({hashVal : this.hashVal})
            .then((result) => {       
                if(result){ 
                    this.showResult = true;               
                    let res =[];
                    res = result;
                    if(res[0] == 'false'){
                        this.msg1 = res[1];
                        this.msg2='';
                       
                    }else if(res[0] == 'true'){  
                        console.log(' this.decryVal'+ this.decryVal);          
                        this.decryVal = res[1];
                        this.msg1 = 'Encrypted Value :'+this.hashVal;
                        this.msg2 = 'Decrypted Value :'+this.decryVal;
                       // this.template.querySelector('lightning-input').value = '';
                    }
                    this.template.querySelector('lightning-input').value = '';
                }  
            
             })
         .catch((error) => {
            console.log(error); 
            });  
            }
        else{
            console.log('entered');
            this.req = true;
            this.showResult = false;
            this.msg1 = '';
            this.msg2 = '';
            this.template.querySelector('lightning-input').setCustomValidity('Please enter hash value');
            this.template.querySelector('lightning-input').reportValidity();
            
        }
        
    }
}