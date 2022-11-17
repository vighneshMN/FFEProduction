import { api, LightningElement } from 'lwc';

export default class FfePopupLwc extends LightningElement {
    messageToShow = '';
    isModalOpen = false; 
    header = 'Sample Header'
    okText;
    cancelText; 

    @api
    showPopup (message, popupHeader, okButtonText, cancelButtonText){
        this.messageToShow = message; 
        this.header = popupHeader; 
        this.okText = okButtonText; 
        this.cancelText = cancelButtonText;
        this.isModalOpen = true; 
    }

    okClick (){
        this.isModalOpen = false; 
        const okEvent = new CustomEvent("ok", {});
        this.dispatchEvent(okEvent);
    }

    cancelClick (){
        this.isModalOpen = false; 
        const cancelEvent = new CustomEvent("cancel", {});
        this.dispatchEvent(cancelEvent);
    }

    closeModal(){
        this.cancelClick();
    }
}