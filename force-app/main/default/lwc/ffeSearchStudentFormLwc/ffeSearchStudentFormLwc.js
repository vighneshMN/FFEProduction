import { LightningElement,wire } from 'lwc';
import getIndianStateList from '@salesforce/apex/DN_DonorAllocation_CTRL.getStateListLwc';
import getStudentCourseYearPicklistValuesLwc from '@salesforce/apex/DN_DonorAllocation_CTRL.getStudentCourseYearPicklistValuesLwc';
import getGenderListValuesLwc from '@salesforce/apex/DN_DonorAllocation_CTRL.getGenderListValuesLwc';
import getBranchListValuesLwc from '@salesforce/apex/DN_DonorAllocation_CTRL.getBranchListValuesLwc';
import getClzRatingValuesLwc from '@salesforce/apex/DN_DonorAllocation_CTRL.getClzRatingValuesLwc';
import Greater_than_40000 from '@salesforce/label/c.Greater_than_40000';
import Equal_40000 from '@salesforce/label/c.Equal_40000';
import From_35000_to_40000 from '@salesforce/label/c.From_35000_to_40000';
import From_30000_to_35000 from '@salesforce/label/c.From_30000_to_35000';

export default class FfeSearchStudentFormLwc extends LightningElement {
    items= [];
    listOfStates = [];
    listOfStudentCourseYearPicklist = [];
    genderValueList = [];
    branchValueList = [];
    clzRatingValueList = []; 
    countrySelected = 'India';
    permanentStateFilter = [];
    currentStateFilter = [];
    courseValueFilter = [];
    genderValueFilter = [];
    branchValueFilter = [];
    clzRatingFilter = [];
    studentPriorityFilter ;
    scholarshipAmountFilter ;
    minFamilyIncome = 0;
    maxFamilyIncome = 250000;

    // connectedCallback(){
    //     console.log('Connected call back');
    //     this.items = [...this.items,{value:'one', 
    //                  label:'one'}];
    //     this.items = [...this.items,{value:'two', 
    //                  label:'two'}];
    //     this.items = [...this.items,{value:'three', 
    //                  label:'three'}];
    //     this.items = [...this.items,{value:'four', 
    //                  label:'four'}];
    // }

    handleValueChange(event){
        console.log('event caught ',event.detail);
    }

    handlePermanentValueChange(event){
        console.log('handlePermanentValueChange event caught ' , event.detail);
        this.permanentStateFilter = event.detail;
    }
    handleCurrentValueChange(event){
        console.log('handleCurrentValueChange event caught ' , event.detail);
        this.currentStateFilter = event.detail;
    }
    handleCourseValueChange(event){
        console.log('handleCourseValueChange event caught ' , event.detail);
        this.courseValueFilter = event.detail;
    }
    handleGenderValueChange(event){
        console.log('handleGenderValueChange event caught ' , event.detail);
        this.genderValueFilter = event.detail;
    }
    handleBranchValueChange(event){
        console.log('handleBranchValueChange event caught ' , event.detail);
        this.branchValueFilter = event.detail;
    }
    handleClzRatingValueChange(event){
        console.log('handleBranchValueChange event caught ' , event.detail);
        this.clzRatingFilter = event.detail;
    }

    @wire(getIndianStateList, { countryName: '$countrySelected' })
    wiredStateList({error, data}){
        if(data){
            //console.log('Wired success ',data);
            for(const valueObject of data){
                //console.log(valueObject.Label);
                this.listOfStates = [...this.listOfStates,{value: valueObject.Label, label:valueObject.Label}];
            }
        }else if(error){
            console.log('Error in the wired state list ',error);
        }
    }

    @wire(getStudentCourseYearPicklistValuesLwc)
    wiredCoursePicklist({error, data}){
        if(data){
            for(const valueObject of data){
                this.listOfStudentCourseYearPicklist = [...this.listOfStudentCourseYearPicklist,{value: valueObject, label:valueObject}];
            }
        }else if(error){
            console.log('Error in the wired coursepicklist list ', error);
        }
    }

    @wire(getGenderListValuesLwc)
    wiredGenderPicklist({error, data}){
        if(data){
            for(const valueObject of data){
                this.genderValueList = [...this.genderValueList,{value: valueObject, label:valueObject}];
            }
        }else if(error){
            console.log('Error in the wired coursepicklist list ', error);
        }
    }

    @wire(getBranchListValuesLwc)
    wiredBranchlist({error, data}){
        if(data){
            for(const valueObject of data){
                this.branchValueList = [...this.branchValueList,{value: valueObject, label:valueObject}];
            }
        }else if(error){
            console.log('Error in the wired coursepicklist list ', error);
        }
    }

    @wire(getClzRatingValuesLwc)
    wiredClzRatinglist({error, data}){
        if(data){
            for(const valueObject of data){
                this.clzRatingValueList = [...this.clzRatingValueList,{value: valueObject, label:valueObject}];
            }
        }else if(error){
            console.log('Error in the wired coursepicklist list ', error);
        }
    }

    get scholarshipAmountOptions(){
        return [
            { label: Greater_than_40000, value: Greater_than_40000 },
            { label: Equal_40000, value: Equal_40000 },
            { label: From_35000_to_40000, value: From_35000_to_40000 },
            { label: From_30000_to_35000, value: From_30000_to_35000 },
        ];

    }

    get priorityOptions(){
        return [
            { label: 'Priority 1', value: 'Priority 1' },
            { label: 'Priority 2', value: 'Priority 2' },
            { label: 'Priority 3', value: 'Priority 3' },
            { label: 'Priority 4', value: 'Priority 4' },
        ];

    }

    handlePriorityChange(event){
        this.studentPriorityFilter = event.detail.value;
    }

    handleScholarshipAmountChange(event){
        this.scholarshipAmountFilter = event.detail.value;
    }

    handleMinChange(event){
        this.minFamilyIncome = event.target.value;
    }

    handleMaxChange(event){
        this.maxFamilyIncome = event.target.value; 
    }
    handleSearchClick(event){
        console.log('Handle search click called @@@@');
        //let studentFilter = { genderList :['Male','Female']};
        //studentFilter.genderList = ['Male','Female'];
        let yettobeimplemented = [];
        let studentFilter = {
            studentState : this.permanentStateFilter,
            collegStates : this.currentStateFilter,
            collegeCity  : yettobeimplemented,
            collegeName  : yettobeimplemented,
            Course       : this.courseValueFilter,
            courseYear   : yettobeimplemented,
            genderList   : this.genderValueFilter,
            branchList   :this.branchValueFilter,
            collegeRating: this.clzRatingFilter,
            priorityList : this.studentPriorityFilter,
            ScholarshipAmountList : this.scholarshipAmountFilter,
            minIncome    : this.minFamilyIncome,
            maxIncome    : this.maxFamilyIncome    
        };
        this.dispatchEvent(new CustomEvent('searchstudent',{ detail: studentFilter }));
    }

    clear(event){
        // let multiSelectPicklist = this.template.querySelectorAll('c-ffe-multi-select-picklist-lwc');
        // multiSelectPicklist.forEach(multiselect =>{
        //     multiselect.clear();
        // }) remove the null pointer on the multiselectpicklist then uncomment
        this.permanentStateFilter = [];
        this.currentStateFilter = [];
        this.courseValueFilter = [];
        this.genderValueFilter = [];
        this.branchValueFilter = [];
        this.clzRatingFilter = [];
        this.dispatchEvent(new CustomEvent('resetstudentresult'));
    }
}