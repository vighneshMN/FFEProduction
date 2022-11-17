import { LightningElement } from 'lwc';

export default class FfeSearchByFfeuid extends LightningElement {
    ffeUid;

    handleUidChange(event){
        this.ffeUid = event.detail.value;
        console.log('FFEuid search term ' , this.ffeUid);
    }

    handleSearchClick(event){
        let studentFilter ={
            FFEUId : this.ffeUid
        }
        this.dispatchEvent(new CustomEvent('searchstudent',{ detail: studentFilter }));
    }

    clear(event){
        this.ffeUid = '';
        this.dispatchEvent(new CustomEvent('resetstudentresult'));
    }
}