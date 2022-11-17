import { api, LightningElement, wire, track } from 'lwc';
import getPlacementInformation from '@salesforce/apex/TrainingAndSkillDevelopment_CTRL.getPlacementStudentDataLWC';
import getSecondYearDataLengthLWC from '@salesforce/apex/TrainingAndSkillDevelopment_CTRL.getSecondYearDataLengthLWC';
import englishAndAptitudeAppData from '@salesforce/apex/TrainingAndSkillDevelopment_CTRL.englishAndAptitudeAppDataLWC';
import getThirdYearDataLengthLWC from '@salesforce/apex/TrainingAndSkillDevelopment_CTRL.getThirdYearDataLengthLWC';
import getThirdYearDataEnglishValue from '@salesforce/apex/TrainingAndSkillDevelopment_CTRL.getThirdYearDataEnglisLengthLWC';
import getThirdYearApirationalLength from '@salesforce/apex/TrainingAndSkillDevelopment_CTRL.getThirdYearApirationalLengthLWC';
import getMockinterViewRecordForThirdYearLWC from '@salesforce/apex/TrainingAndSkillDevelopment_CTRL.getMockinterViewRecordForThirdYearLWC';
import getFourthYearDataLengthLWC from '@salesforce/apex/TrainingAndSkillDevelopment_CTRL.getFourthYearDataLengthLWC';
import getfourthYearDataLWC from'@salesforce/apex/TrainingAndSkillDevelopment_CTRL.getfourthYearDataLWC';
import getSecondYearDataLWC from '@salesforce/apex/TrainingAndSkillDevelopment_CTRL.getSecondYearDataLWC';
import getThirdYearData_1LWC from '@salesforce/apex/TrainingAndSkillDevelopment_CTRL.getThirdYearData_1LWC';
import getfourthYearData_1LWC from '@salesforce/apex/TrainingAndSkillDevelopment_CTRL.getfourthYearData_1LWC';
import getThirdYearDataLWC from '@salesforce/apex/TrainingAndSkillDevelopment_CTRL.getThirdYearDataLWC';
import getMockInterViewRecordDetailForThirdYearLWC from '@salesforce/apex/TrainingAndSkillDevelopment_CTRL.getMockInterViewRecordDetailForThirdYearLWC';
export default class TrainingAndSkillDevelopmentLWC extends LightningElement {
    selected =0;
    training = '';
    @track displaySecondYearEnglishData = false; 
    @track displaySecondYearAptitudeData = false; 
    @track displaySecondYearAllData = false;
    @track preandpostAsses = false;
    @track preandpostAsses_midline = false;
    @track mocktable = false; 
    @track preandpostAsses_endline = false;
    
    @api showLoadSpinner = false;
    
    @track secondyear = false;
    @track thirdyear = false;
    @track thirdYearEng = false;
    @track tgirdYearIT = false;
    @track fourthyear = false;
    @track fourthYearTechandHR = false;
    @track isemptyMessage = true;
    @track secondYearAmcatPreandPostLenght = 0;
    @track secondYearEnglishLength = 0;
    @track secondYearAptitudeLength = 0;
    @track secondYearAspiringLength = 0;
    @track getThirdYearDataEnglish = 0;
    @track getThirdYearDataIT = 0;
    @track getfourthYearDataHR =0;
    @track getfourthYearDataTech =0;
    @track getfourthYearDataHRAndTech = 0;
    @track yearIsSelected = true;
    @track placedStudentsCount = 0;
    @track mockInterViewCount = 0;
    @track showcourses='';
    @track midline = 0;
    @track endline = 0;
    @track isemptyMessage = true;
    @api studentList=[];
    

    getfourthYearData_length(){
        this.showSpinnerOnPage();
        console.log('getfourthYearData_length');
        getFourthYearDataLengthLWC().then(result=>{
          
            if(result){
                  console.log('getfourthYearData_length'+ result);
                if(result != null){
                    this.endline = result;
                    console.log(this.endline+'endline');
                    this.preandpostAsses = true;
                    this.isemptyMessage = true;
                }else{
                    this.isemptyMessage = false;
                }
            }
        
        });
           
        
        this.hideSpinnerOnPage();
    }
    connectedCallback(){
        this.englishAndAptitudeApp('English');
        this.englishAndAptitudeApp('English');
        this.englishAndAptitudeApp('Aptitude');
        this.englishAndAptitudeApp('Aspiring Program');
        this.getfourthYearData('Mock Interview HR');
        this.getfourthYearData('Mock Interview Tech');
        this.getfourthYearData('All');
        this.getThirdYearDataEnglishValue();
        this.getThirdYearApirationalLength();
       this.getMockinterViewRecordForThirdYearLWC();   
    }
  
    getMockinterViewRecordForThirdYearLWC(){
       
        getMockinterViewRecordForThirdYearLWC().then(result=>{
        //this.preandpostAsses = false;
        console.log('getThirdYearMockInterview'+ result);
        
        if(result){
            if(result != null){
                this.mockInterViewCount = result;
                this.preandpostAsses = true;
                this.isemptyMessage = true;
            }else{
                this.isemptyMessage = false;
            }
        }
        });
    }


    getThirdYearApirationalLength(){
    getThirdYearApirationalLength().then(result=>{
        console.log('result'+ result);
        this.preandpostAsses = false;
        if(result){
            if(result != null){
                    
                this.tgirdYearIT = true;
                
                this.getThirdYearDataIT = result;
                this.preandpostAsses = true;
                this.isemptyMessage = true;
            }else{
                this.isemptyMessage = false;
            }
        }
    });
}
    getThirdYearDataEnglishValue(){
    getThirdYearDataEnglishValue().then(result=>{
        console.log('result'+ result);
        this.preandpostAsses_midline = false;
        if(result){
            if(result != null){
                    
                this.tgirdYearIT = false;
                
                this.getThirdYearDataEnglish = result;
                this.thirdYearEng = true;
                this.isemptyMessage = true;
            }else{
                this.isemptyMessage = false;
            }
        }
    });
}
    getThirdYearDataLen(){
        this.showSpinnerOnPage();
        getThirdYearDataLengthLWC().then(result=>{
            console.log('result------------'+ result);
        this.preandpostAsses = false;
        if(result){
            if(result != null ) {
                this.midline = result;
                this.preandpostAsses = true; 
                this.isemptyMessage = true;
            }
            else {
                this.isemptyMessage = false;
            }
        }
        }) ;
        this.hideSpinnerOnPage();
    }
   
    getSecondYearData(){
        
        this.showSpinnerOnPage();
        this.preandpostAsses = true;
        getSecondYearDataLengthLWC().then((result) =>{
            console.log('result'+ result);
            if(result){
                console.log('result');
                if(result != null ) {
                    this.secondYearAmcatPreandPostLenght = result;
                    this.preandpostAsses = true; 
                    this.isemptyMessage = true;
                    this.hideSpinnerOnPage();
                }
                else {
                    this.isemptyMessage = false;
                }
                this.hideSpinnerOnPage();
                this.getThirdYearDataLen();
                this.getfourthYearData_length();
            }

        }).catch((error) => {
            console.log(error);
           
        });

    }
    
    @wire (getPlacementInformation)
    getPlacementInformation({error,result}){
        this.displayPlacementData = false;
        console.log('result'+ result);
        this.getSecondYearData();
        
        if(result){
            console.log('result');
            this.studentPlacementList = JSON.parse(result);
            this.displayPlacementData = true;
            this.fourthYearTechandHR = false;
            this.fourthYearTech = false;
            this.fourthYearHR = false;
            this.isemptyMessage = true;
            this.placedStudentsCount = studentPlacementList.length;
            if(this.studentPlacementList.length <= 0){
                this.displayPlacementData = false;
                this.isemptyMessage = false;
            }
            
        }else if(error){
            console.log('Error ' , error);
        }
    }
    renderedCallback(){
    //  this.getThirdYearMockInterview();
      


    }
    getfourthYearData(training){
        this.displayPlacementData = false;
        this.preandpostAsses_endline = false; 
        getfourthYearDataLWC({trainingType :training }) .then((result) => {        
            console.log('getfourthYearData method');
            if(training == 'Mock Interview HR'){
                    this.studentfourthYearHRList	= JSON.parse(result);
                    this.fourthYearTech = false;
                    this.fourthYearTechandHR = false;
                    if(this.studentfourthYearHRList.length>0){
                        this.getfourthYearDataHR = this.studentfourthYearHRList.length;
                        this.fourthYearHR = true;
                        this.isemptyMessage = true;
                    }else{
                        this.isemptyMessage = false;
                    }
            }else if(training == 'Mock Interview Tech'){
               
                this.fourthYearHR = false;
                this.fourthYearTechandHR = false;
                this.studentfourthYearTechList = JSON.parse(result);
               
                    if(this.studentfourthYearTechList.length>0){
                        this.getfourthYearDataTech =this.studentfourthYearTechList.length;
                        this.fourthYearTech = true;
                        this.isemptyMessage = true;
                    }else{
                        this.isemptyMessage = false;
                    }
            }else if(training == 'All'){
                console.log('All'+result);
                this.studentfourthYearHRTechList	= JSON.parse(result);
                
                this.fourthYearHR = false;
                this.fourthYearTech = false;
                if(this.studentfourthYearHRTechList.length>0){
                    this.getfourthYearDataHRAndTech = this.studentfourthYearHRTechList.length;
                    this.fourthYearTechandHR = true;
                    this.isemptyMessage = true;
                }else{
                    this.isemptyMessage = false;
                }
            }
        })
        .catch((error) => {
            console.log(error);
           
        });

    }

    
    englishAndAptitudeApp(training){
        this.showLoadSpinner =true;
        this.preandpostAsses = false;
        console.log('training'+training);
       // this.isemptyMessage = false;
        englishAndAptitudeAppData({trainingType :training }) .then((result) => { 
            if(training == 'English'){
                this.studentwithTrainingList	=JSON.parse(result);
                console.log('studentwithTrainingList '+ this.studentwithTrainingList);
                this.displaySecondYearAptitudeData = false;
                this.displaySecondYearAllData = false;
                if(this.studentwithTrainingList != null){
                if(this.studentwithTrainingList.length>0){
                    this.secondYearEnglishLength = this.studentwithTrainingList.length;
                    this.displaySecondYearEnglishData = true;
                    this.isemptyMessage = true;
                }
                this.showLoadSpinner =false;
            }else{
                    this.showLoadSpinner =false;
                    this.isemptyMessage = false;
                }
            }else if(training == 'Aptitude'){
                this.showLoadSpinner =true;
                this.studentwithTrainingListAptitude	= JSON.parse(result);
                this.displaySecondYearEnglishData = false;
                this.displaySecondYearAllData = false;
                if(this.studentwithTrainingListAptitude != null){
                if(this.studentwithTrainingListAptitude.length>0){
                    this.secondYearAptitudeLength = this.studentwithTrainingListAptitude.length;
                    this.displaySecondYearAptitudeData = true;
                    this.isemptyMessage = true;
                    this.showLoadSpinner =false;
                }
            }else{
                    this.isemptyMessage = false;
                    this.showLoadSpinner = false;
                }
            }else if(training == 'Aspiring Program'){
                console.log('Aspiring Program');
                this.showLoadSpinner =true;
                this.studentwithTrainingListAll	= JSON.parse(result);
                console.log('Aspiring Program'+result);
                this.displaySecondYearEnglishData = false;
                this.displaySecondYearAptitudeData = false;
                if(this.studentwithTrainingListAll != null){
                if(this.studentwithTrainingListAll.length>0){
                    this.secondYearAspiringLength = this.studentwithTrainingListAll.length;
                    this.displaySecondYearAllData = true;
                    this.isemptyMessage = true;
                    this.showLoadSpinner =false;
                }
            else{
                    console.log('in else');
                    this.isemptyMessage = false;
                   
                }
                this.showLoadSpinner =false;}
            }
        })
        .catch((error) => {
            console.log(error);
           
        });

    }
    get yearsOfStudy() {
        return [
            { label: '2nd Year', value: '2nd Year' },
            { label: '3rd Year', value: '3rd Year' },
            { label: '4th Year', value: '4th Year' }
        ];
      }

      handleYearChange(event){
          //this.showSpinnerOnPage();
          console.log(event.detail.value);
        if(event.detail.value == '2nd Year'){
            this.showLoadSpinner =true;
             this.thirdyear = false;
            this.fourthyear = false;
            this.secondyear = true;
            this.selected = 0;
            this.yearIsSelected = false;
            this.getSecondYearData_1();
            
        }else if(event.detail.value  == '3rd Year'){
            this.showLoadSpinner = true;
            this.secondyear = false;
            this.fourthyear = false;
            this.thirdyear = true;
            this.selected = 0;
            this.fourthyear = false;
            this.selected = 0;
            this.yearIsSelected = false;
            this.showLoadSpinner =true;
            this.getThirdYearData_new();
        }else if(event.detail.value  == '4th Year'){
            this.showLoadSpinner =true;
            this.preandpostAsses_midline =false;
            this.secondyear = false;
            this.fourthyear = false;
            this.thirdyear = false;
            this.selected = 0;
            this.fourthyear = true;
            this.selected = 0;
            this.yearIsSelected = false;
            this.showLoadSpinner =true;
            this.getfourthYearData_new();
            this.showLoadSpinner =false;
        }
      //  this.hideSpinnerOnPage();
    }

    
    getSecondYearData_1(){ 
        this.showSpinnerOnPage();
        this.displaySecondYearEnglishData = false; 
        this.displaySecondYearAptitudeData = false;
        this.displaySecondYearAllData = false;
        getSecondYearDataLWC().then((result) =>{
            if(result){
                this.studentList	= JSON.parse(result);
                console.log('studentList'+this.studentList[0].Name);
                if(this.studentList.length > 0){
                    this.preandpostAsses = true; 
                    this.isemptyMessage = true;
                }else{
                    this.isemptyMessage = false;
                }
            }
           // this.hideSpinnerOnPage();
        });
    }
    
    getThirdYearData_new(){
        this.showSpinnerOnPage();
        this.tgirdYearIT = false; 
        getThirdYearData_1LWC().then((result) =>{
            console.log(result+'####');

            if(result){
                this.studentList	= JSON.parse(result);
                if(this.studentList.length > 0){
                    
                    this.midline = this.studentList.length;
                    this.preandpostAsses_midline = true; 
                    this.isemptyMessage = true;
                    this.tgirdYearIT = false;
                    this.thirdYearEng = false;
                    this.mocktable = false;
                    this.hideSpinnerOnPage();
                }else{
                    this.isemptyMessage = false;
                    this.hideSpinnerOnPage();
                }

            }
        });
        
    }

        getfourthYearData_new(){
            this.showSpinnerOnPage();
            this.tgirdYearIT = false;
            this.fourthYearTechandHR = false;
            this.displayPlacementData = false;
            getfourthYearData_1LWC().then((result) =>{
                console.log('###'+result);
                if(result){
                    this.studentList	= JSON.parse(result);
                    console.log(this.studentList);
                    if(this.studentList.length > 0){
                        
                        this.endline = this.studentList.length;
                        this.preandpostAsses_endline = true; 
                        this.isemptyMessage = true;
                        this.tgirdYearIT = false;
                    }else{
                        this.isemptyMessage = false;
                    }
                }
            });
            this.hideSpinnerOnPage();
        }

        getThirdYearMockInterviewDetail(){
            getMockInterViewRecordDetailForThirdYearLWC().then((result)=>{
                console.log('getThirdYearMockInterviewDetail'+result);
                if(result){
                    this.tgirdYearIT = false;
                    this.thirdYearEng = false;
                    this.preandpostAsses_midline = false;
                    this.mockList	= JSON.parse(result);
                if(this.mockList.length > 0){
                    this.mocktable = true;
                    this.isemptyMessage = true;
                }else{
                    this.isemptyMessage = false;
                }
                }
            });
        }
    
        getThirdYearData(training){            
            this.showSpinnerOnPage();
            this.trainingType = training;
            this.preandpostAsses_midline = false;
            getThirdYearDataLWC({trainingType :this.trainingType }).then(result=>{
                if(result){
                if(this.trainingType == 'Aspiring English'){
                    this.studentThirdYearEngList	= JSON.parse(result);
                    this.tgirdYearIT = false;
                    if(this.studentThirdYearEngList.length>0){
                        this.getThirdYearDataEnglish = this.studentThirdYearEngList.length;
                        this.thirdYearEng = true;
                        this.mocktable = false;
                        this.isemptyMessage = true;                        
                        this.hideSpinnerOnPage();
                    }else{
                        this.isemptyMessage = false;
                    }
                }else if(this.trainingType == 'IT'){
                    this.thirdYearEng = false;
                    this.studentThirdYearIT	= JSON.parse(result); 
                    if(this.studentThirdYearIT.length>0){
                        this.getThirdYearDataIT = this.studentThirdYearIT.length;
                        this.mocktable = false; 
                        this.tgirdYearIT = true;
                        this.isemptyMessage = true;
                        this.hideSpinnerOnPage();
                    }else{
                        this.isemptyMessage = false;
                    }
                }
                }
                
            
            });

        }
        
        showTabcontent(event){
            console.log(event.target.value);
           // this.showSpinnerOnPage();
           if(event.target.value == 0){
               if(this.secondyear){
                    this.showLoadSpinner = true;
                    this.getSecondYearData_1();
               }else if(this.thirdyear){  
                    this.showLoadSpinner = true;
                    console.log(this.thirdyear);            
                    this.getThirdYearData_new();
                }else if(this.fourthyear){  
                    this.showLoadSpinner = true;
                    console.log(this.fourthyear);            
                    this.getfourthYearData_new();
                }
            }else if(event.target.value == 1){
                if(this.secondyear){
                    this.showLoadSpinner = true;
                    this.englishAndAptitudeApp('English');
                }
                else if(this.thirdyear){
                    this.showLoadSpinner = true;
                    this.getThirdYearData('Aspiring English');
                }else if(this.fourthyear){  
                    this.showLoadSpinner = true;
                    console.log(this.fourthyear);            
                 this.getfourthYearData('All');
             }
               
            }else if(event.target.value == 2){
                if(this.secondyear){
                    this.showLoadSpinner = true;
                this.englishAndAptitudeApp('Aptitude');
                }else  if(this.thirdyear){
                    this.getThirdYearData('IT');
                    this.showLoadSpinner = true;
                }


            }else if(event.target.value == 3){
                if(this.secondyear){
                    this.showLoadSpinner = true;
                this.englishAndAptitudeApp('Aspiring Program');
                }else  if(this.thirdyear){
                    this.showLoadSpinner = true;
                    this.getThirdYearMockInterviewDetail();
                }

            }
            this.hideSpinnerOnPage();
        }
        backToSummary(){
        this.showLoadSpinner =true;
        this.secondyear = false;
        this.thirdyear = false;
        this.fourthyear = false;
        this.yearIsSelected = true;
        this.isemptyMessage = true;
        this.yearSelected = '';
        this.template.querySelectorAll('lightning-combobox ').forEach(x=>{x.value='';});
        this.showLoadSpinner= false;
        }

         // show Spinner
         showSpinnerOnPage() {
            this.showLoadSpinner = true;
            }
            // hide Spinner
            hideSpinnerOnPage() {
            this.showLoadSpinner = false;
            }

}