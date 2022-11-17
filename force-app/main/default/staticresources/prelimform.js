angular.module('number', [])
    .directive('number', function () {
        return {
            require: 'ngModel',
            restrict: 'A',
            link: function (scope, element, attrs, ctrl) {
                ctrl.$parsers.push(function (input) {
                    if (input == undefined) return ''
                    var inputNumber = input.toString().replace(/[^0-9]/g, '');
                    if (inputNumber != input) {
                        ctrl.$setViewValue(inputNumber);
                        ctrl.$render();
                    }
                    return inputNumber;
                });
            }
        };
    });

    angular.module('text', [])
    .directive('text', function () {
        return {
            require: 'ngModel',
            restrict: 'A',
            link: function (scope, element, attrs, ctrl) {
                ctrl.$parsers.push(function (input) {
                    if (input == undefined) return ''
                    var inputText = input.toString().replace(/[^a-zA-Z\s]/g, '');
                    if (inputText != input) {
                        ctrl.$setViewValue(inputText);
                        ctrl.$render();
                    }
                    return inputText;
                });
            }
        };
    });

angular.module('textarea', [])
    .directive('textarea', function () {
        return {
            require: 'ngModel',
            restrict: 'A',
            link: function (scope, element, attrs, ctrl) {
                
                ctrl.$parsers.push(function (input) {
                    if (input == undefined) return ''
                
                    var inputText = input.toString().replace(/[^a-zA-Z\.\s]/g, '');
                    if (inputText != input) {
                
                        ctrl.$setViewValue(inputText);
                        ctrl.$render();
                    }
                    return inputText;
                });
            }
        };
    });
var app=angular.module('preApplication', ['ngRoute','ngAnimate','ngMaterial','number','text','textarea']);
/*app.directive('number1', function () {
    return {
        require: 'ngModel',
        restrict: 'A',
        link: function (scope, element, attrs, ctrl) {
            console.log('---@@@@');
            ctrl.$parsers.push(function (input) {
                if (input == undefined) return ''
                var inputNumber = input.toString().replace(/[^0-9]/g, '');
                if (inputNumber != input) {
                    ctrl.$setViewValue(inputNumber);
                    ctrl.$render();
                }
                return inputNumber;
            });
        }
    };
});*/

app.controller('preapplication', function($scope, $timeout, $window, $location,$element ) {
    
    $scope.APtypePickLstValues			= APtypePickLstValues;
    $scope.APGenderPickLstValues		= APGenderPickLstValues;
    $scope.mediumOfInstruction          = mediumOfInstruction;
    $scope.studentBranchs				= studentBranch;//added by sumit
    $scope.studentLawBranchs            = studentLawBranch;
    $scope.studentCourses				= studentCourse;
    $scope.listOfStates					= listOfStates;
    $scope.listOfExamBoards				= listOfExamBoards;
    $scope.occupations					= occupationlist;
    $scope.accomTypes					= accomTypesList;
    $scope.sibilingNo                   = sibilingList;
    $scope.btechYearList				= btechYearList;
    $scope.MtechYearList				= MtechYearList;
    $scope.MbbsYearList					= MbbsYearList;
    $scope.entranceTests				= entranceTests;
    debugger;
	//Start--Added scholarship criteria vraibales -- Sumit Gaurav - 11-June-2020
	$scope.maxAnnualFamilyIncome		= maxAnnualFamilyIncome;
	$scope.minPercentageForHS			= minPercentageForHS;
	$scope.minusYear					= minusYear;
    $scope.referedlist 					= referedlist;
    $scope.refSubcategry 				= refSubcategry;
    $scope.beneficiaryType              = beneficiaryType; // ##
    $scope.refDonorSubcategry 			= refDonorSubcategry;
    $scope.socialMediaList              = socialMediaList;
    $scope.sourceOfInfoReferedBy        = sourceOfInfoReferedBy;
    debugger;
	//End
	$scope.studentHouseNo ='';
    $scope.studentStreetNo ='';
    $scope.studentLocality= '';
    $scope.indexValueStudent			= 0;
    $scope.formInvalid					= false;
    $scope.student 						= {};
    $scope.application 					= {};
    $scope.hideButtons					= false;
    $scope.showSpace 					= false;
    $scope.dobError 					= false;
    $scope.maxMarks10_readOnly 			= false;
    $scope.maxMarks12_readOnly 			= false;
    $scope.birthdate					= '';
    var percent							= 0;
    var percent_HS						= 0;
    $scope.todate						=new Date();
    $scope.todate.setDate($scope.todate.getDate()-1);
    $scope.collegeOther=false;
    $scope.studentProfileURL			= StudentprofileURL;
    $scope.FFEUID                       = '';
    $scope.hashcode                     = '';
    $scope.DocumnetUploadMessage        = DocumnetUploadMessage;
    $scope.isFacilitatorTrue            = false;
    $scope.houseno = '';
    $scope.donorId = donorId;
    $scope.displayReferral = true;
    $scope.sonsoredDonorName = '';
    $scope.displaySponsrDonorDetails = false;
    $scope.showDonorSubcategory = false;
    $scope.showCognizantSubCat = false;
    $scope.cognizantOutreachBeni = true;
    $scope.notcognizantOutreachBeni = true;
    //$scope.socialMediaList = ['Facebook','Instagram','LinkedIn','Twitter','Whatsapp','Others'];
    $scope.showSubCat = true;
    
    //code by start by tushar
    
  
    
    // code end by tushar
    
    
    
    
    

    $scope.refDetails= function(){
        debugger;
         AP_Student_Application_CTRL.getReferedDonorDetail(donorId,function(result,event){
            if(event.status){
                $scope.showDonorSubcategory = true;
                if(result.Show_Subcategory__c ){
                	
                  $scope.donorOtherSubCat = true;
                }else{
                    $scope.donorOtherSubCat = false;
                }
                if(result.Name.indexOf("Cognizant") != -1){
                    $scope.showCognizantSubCat = true;
                }
                    $scope.sonsoredDonorName = result.Name;
                	$scope.showSubCat = result.Show_Subcategory__c;
                 //   $scope.showSubCat = result.Beneficiary_Type__c;
                $scope.displaySponsrDonorDetails = true;
                $scope.$apply();
            }else{
                $scope.showDonorSubcategory = false; 

            }
        });   

    } 
	
    if(donorId != ""){
        debugger;
        $scope.displayReferral = false;
        $scope.student.Referred_Donor__c = donorId;
        $scope.refDetails();
          
    }
                
       
    $element.find('input').on('keydown', function(ev) {
        ev.stopPropagation();
    });
    
    $scope.changeCollege = function(college){
        debugger;
        for(var i=0;i<$scope.colleges.length;i++){
            if(college == $scope.colleges[i].Id){
                if($scope.colleges[i].Name == 'Other'){
                    $scope.collegeOther=true;
                }
                else{
                    $scope.collegeOther=false;
                }
            }
        }
        
        $scope.clg ='';
        $scope.$apply();
    }    
    
    $scope.valid = function(value){
        if(value!=undefined){
            var x=value;
            var atpos = x.indexOf("@");
            var dotpos = x.lastIndexOf(".");
            if (atpos<1 || dotpos<atpos+2 || dotpos+2>=x.length) {
                if(value==$scope.student.Email){
                    $scope.invalidEmail = true;
                }
                else if(value==$scope.student.Facebook_login_ID__c){
                    $scope.invalidFEmail = true;
                }
                    else if(value==$scope.student.Google_login_ID__c){
                        $scope.invalidGmail = true;
                    }
            }
            else{
                if(value==$scope.student.Email){
                    $scope.invalidEmail = false;
                }
                else if(value==$scope.student.Facebook_login_ID__c){
                    $scope.invalidFEmail = false;
                }
                    else if(value==$scope.student.Google_login_ID__c){
                        $scope.invalidGmail = false;
                    }
            }
        }
    }
    
    $scope.CheckFacilitator = function(switchvalue){
        debugger;
        $scope.validStudent={Refered_by_Facilitator_Id__c:''}
        $scope.validStudent.Refered_by_Facilitator_Id__c=$scope.student.Refered_by_Facilitator_Id__c;
        if($scope.student.Refered_by_Facilitator_Id__c == null){
            $scope.isFacilitatorTrue = false;
            swal({title:'',text:"Please Enter Facilitator ID"});
        }
        else{
            $scope.loading=true;
            AP_Student_Application_CTRL.validateFacilitator($scope.validStudent,function(result,event){
                if(event.status){
                    if(result==FacilitatorErrorMessage){
                        swal({title:'',text:result});
                        $scope.isFacilitatorTrue = false;
                        $scope.loading=false;
                        
                    }
                    else{    
                        $scope.loading=false;
                        $scope.isFacilitatorTrue = true;
                        $scope.student.Refered_by_Facilitator_Name__c = result.toString();
                        
                    }
                }
                $scope.$apply();
            });
            
        }
    }
    $scope.isNumber=function(event){
        console.log(event);
    }
    $scope.next = function(switchvalue){
        debugger;
        console.log($scope.student.Father_Age__c);
        
        console.log('$scope.studentHouseNo::'+$scope.student.hono+'----'+$scope.student.streetNo);
        console.log('houseno::'+$scope.houseno);
        console.log($scope.houseno);
        var age;
        if($scope.donorOtherSubCat){
            if($scope.student.Source_of_information_Referred_by__c != undefined){
                if($scope.student.Source_of_information_Referred_by__c == "Amazon" && $scope.student.Reffered_by_Subcategory__c == undefined){
                    swal({title:'',text:"Enter Source of information / Referred by Subcategory"});
                    return;
                }
                if($scope.student.Source_of_information_Referred_by__c == "Social Media" && $scope.student.Social_Media__c == undefined){
                    swal({title:'',text:"Enter Social Media"});
                    return;
                }
                if($scope.student.Source_of_information_Referred_by__c == "Word of mouth / Online channels" && $scope.student.Word_of_mouth_Online_channels__c == undefined){
                    swal({title:'',text:"Enter Word of mouth / Online channels"});
                    return;
                }
                if($scope.student.Source_of_information_Referred_by__c == "NGOs" && $scope.student.NGOs__c == undefined){
                    swal({title:'',text:"Enter NGOs"});
                    return;
                }
                if($scope.student.Source_of_information_Referred_by__c == "Other Sources" && $scope.student.Other_Sources__c == undefined){
                    swal({title:'',text:"Enter Other Sources"});
                    return;
                }
            }else{
                swal({title:'',text:"Enter Source of information / Referred by"});
                return;
            }
        }
        if($scope.student.Birthdate != undefined){
            $scope.dobError = false;
            var ageDifMs = Date.now() - $scope.student.Birthdate.getTime();
            var ageDate = new Date(ageDifMs); // miliseconds from epoch
            age = Math.abs(ageDate.getUTCFullYear() - 1970);
        }
        else
        {
             $scope.dobError = true;
        }
        
       
        $scope.validStudent={MobilePhone:'',Email:'',Google_login_ID__c:'',Facebook_login_ID__c:'',Aadhar_number__c:'',Refered_by_Facilitator_Id__c:''}
        $scope.validStudent.MobilePhone=$scope.student.MobilePhone;
        $scope.validStudent.Email=$scope.student.Email;
        $scope.validStudent.Google_login_ID__c=$scope.student.Google_login_ID__c;
        $scope.validStudent.Facebook_login_ID__c=$scope.student.Facebook_login_ID__c;
        $scope.validStudent.Aadhar_number__c=$scope.student.Aadhar_number__c;
        $scope.validStudent.Refered_by_Facilitator_Id__c=$scope.student.Refered_by_Facilitator_Id__c;
         debugger;
        if(($scope.student.Parent_Phone__c != undefined && $scope.student.Parent_Phone__c != "") || ($scope.student.Parent_Mobile__c != undefined && $scope.student.Parent_Mobile__c != "")){
            if (angular.equals($scope.student.Parent_Phone__c, $scope.student.MobilePhone) || angular.equals($scope.student.Parent_Mobile__c, $scope.student.MobilePhone)){ 
                swal({title:'',text:"Parents phone number cannot be same as student mobile number"});
                return;
            }   
        }
        
        
        
        if((this.studentForm.$invalid || $scope.invalidEmail ||  $scope.dobError) && true){ 
            $scope.showSpace =true;
            $scope.formInvalid=true;
            swal({title:'',text:"Please fill all mandatory (*) fields"});
        }/*
        else if($scope.student.Annual_Family_Income__c > 250000 ){
            $scope.showSpace =true;
            $scope.formInvalid=true;
            swal({title:'',text:"Ensure Annual Family Income value entered is correct!"});
        }
        else if(age > 18){
            $scope.showSpace =true;
            $scope.formInvalid=true;
            swal({title:'',text:"Invalid Age. Age should be <= 18"});
        }*/
        
        
        else if($scope.emailValidation($scope.student.Email) && $scope.emailValidation($scope.student.Facebook_login_ID__c) && $scope.emailValidation($scope.student.Google_login_ID__c)){
            $scope.loading=true;
            debugger;
            if($scope.student.hono != undefined || $scope.student.streetNo != undefined || $scope.student.locality != undefined){
                $scope.student.MailingStreet = $scope.student.hono+'; '+$scope.student.streetNo+'; '+$scope.student.locality;
                delete $scope.student.hono;
                delete $scope.student.streetNo;
                delete $scope.student.locality;
            }
            AP_Student_Application_CTRL.validateStudentInfo($scope.validStudent,function(result,event){
                if(event.status){
                    if(result.status == 'Success'){
                        if($scope.student.Annual_Family_Income__c > $scope.maxAnnualFamilyIncome ){
                            swal("Entered Annual Family Income value will make the Application Ineligible!");
                        }
                        $scope.showSpace =false;
                        $scope.indexValueStudent=switchvalue;
                        $scope.hideButtons=true;
                        $scope.isFacilitatorTrue = true;
                        $scope.student.Refered_by_Facilitator_Name__c = result.message.toString();
                        $scope.moveToTop();
                        $scope.loading=false;
                        $scope.$apply();
                    }
                    else{
                        const addressList=$scope.student.MailingStreet.split("; ");
                        $scope.student.hono=addressList[0];
                        $scope.student.streetNo=addressList[1];
                        $scope.student.locality=addressList[2];
                        if(result.message!=undefined){
                            swal({title:'',text:result.message});
                            $scope.student.Refered_by_Facilitator_Name__c ='';
                            $scope.isFacilitatorTrue = false;
                            $scope.loading=false;
                            $scope.$apply();
                        }
                        else{
                            $scope.showSpace =false;
                            $scope.indexValueStudent=switchvalue;
                            $scope.hideButtons=true;
                            $scope.student.Refered_by_Facilitator_Name__c ='';
                            $scope.moveToTop();
                            $scope.loading=false;
                            $scope.$apply();
                        }
                        
                    }
                }
            });
        }
            else{
                swal({title:'',text:"Not a valid e-mail address"});
                $scope.loading=false;
            }
    }
    
    $scope.emailValidation = function(value){
        $scope.valid(value);
        if(value!=undefined && value!=''){
            var x=value;
            var atpos = x.indexOf("@");
            var dotpos = x.lastIndexOf(".");
            if (atpos<1 || dotpos<atpos+2 || dotpos+2>=x.length) {
                swal({title:'',text:"Not a valid e-mail address"});
                return false;
            }
            else if (value==$scope.student.Google_login_ID__c){
                var String=value.substring(value.lastIndexOf("@")+1,value.lastIndexOf(".com"));
                String=String.toLowerCase();
                if(String!='gmail'){
                    swal({title:'',text:"Please enter your Gmail Id"});
                    $scope.notGmail=true;
                    return false;
                }
                else{
                    $scope.notGmail=false;
                    return true;
                }
            }
                else{
                    return true;
                }
        }
        else{
            return true
        }
    }
    
    
    $scope.getCollege = function(value){ 
        if(value !='' && value != undefined){
            AP_Student_Application_CTRL.searchCollege(value,$scope.student.Course__c,function(result,event){
                if(event.status){
                    $scope.colleges=result;
                    $scope.$apply();
                }
            }); 
        }           
    }

    // ExamBased On Course

    debugger;
    $scope.ExamList = [];
    $scope.getExamName = function(value){
        debugger;
        if(value != '' && value != undefined){
            AP_Student_Application_CTRL.getExamDependingOnCourse(value,function(result,event){
                if(event.status){
                 $scope.ExamList = result;
                 $scope.$apply();
                }
            })
        }
    }

    // ExamBased On Course
    
    $scope.previous = function(switchvalue){
        $scope.indexValueStudent=switchvalue;
        $scope.hideButtons=false;
       
        const addressList=$scope.student.MailingStreet.split("; ");
        $scope.student.hono=addressList[0];
        $scope.student.streetNo=addressList[1];
        $scope.student.locality=addressList[2];
        $('.number').inputFilter(function(value) {
            return /^-?\d*$/.test(value);
        });
    }
    
    $scope.moveToTop = function(){
       
        document.getElementById('myContainerDiv').scrollTop =0;
    }
    $scope.toggle=function(){
         $scope.burgerToggle=false;
    }
    $scope.calc = function(marksObtained,maxMarks){
        if(marksObtained!=undefined && maxMarks!=undefined){
            if(marksObtained <= 10 && maxMarks <=10){
                percent = (parseFloat(marksObtained))*9.5;
                percent =  $scope.round(percent, 2);
            }
            else{
                percent = (parseInt(marksObtained)/parseInt(maxMarks)) * 100;
                percent =  $scope.round(percent, 2);
            }
            return percent;
        }
        else{
            return 0;
        }
    }
    $scope.calc_HS = function(marksObtained,maxMarks){
        if(marksObtained!=undefined && maxMarks!=undefined){
            if(marksObtained <= 10 && maxMarks <=10){
                percent_HS = (parseFloat(marksObtained))*9.5;
                percent_HS =  $scope.round(percent_HS, 2);
            }
            else{
                percent_HS = (parseInt(marksObtained)/parseInt(maxMarks)) * 100;
                percent_HS =  $scope.round(percent_HS, 2);
            }
            /*if(parseFloat(percent_HS) < 70){
                swal("Please recheck the 12th Percentage!");
            }*/
            return percent_HS;
        }
        else{
            return 0;
        }
    }
    
        $scope.calc_HSfromPercentage = function(percentage){
        debugger;
        if(percentage!=undefined){
       
            percent_HS =  percentage/100;
            return percent_HS;
        }
        else{
            return 0;
        }
    }
    
    
    $scope.round = function(value, decimals) {
        return Number(Math.round(value+'e'+decimals)+'e-'+decimals);
    }
    
    $scope.submit = function(){
        debugger;
        if($scope.student.Entrance_Test_Name__c != 'No Entrance Exam' && ($scope.student.Entrance_Exam_Taken_In_Year__c == "" || $scope.student.Entrance_Exam_Taken_In_Year__c == undefined)){
            swal({title:'',text:"Please enter the entrance exam year"});	
                        return;	
        }
        if($scope.student.Entrance_Test_Name__c == 'No Entrance Exam'){
            $scope.student.Entrance_Exam_Taken_In_Year__c = "0";
            $scope.student.Entrance_Test_Rank__c = "0";
        }
                    var JeeMainCRLRank = $scope.student.JEE_Main_CRL_Rank__c;	
                    var entranceTestRank = $scope.student.Entrance_Test_Rank__c;
					if($scope.student.Entrance_Test_Name__c == 'JEE (Advanced)' && (($scope.student.JEE_Advance_All_India_Rank__c == undefined  || $scope.student.JEE_Advance_Category_Rank__c == undefined || $scope.student.JEE_Main_CRL_Rank__c == undefined || $scope.student.JEE_Advance_All_India_Rank__c == ""  || $scope.student.JEE_Advance_Category_Rank__c == "" || $scope.student.JEE_Main_CRL_Rank__c == "") || ( $scope.student.JEE_Main_CRL_Rank__c== undefined || parseInt(JeeMainCRLRank) <1 || $scope.student.JEE_Main_CRL_Rank__c== ""))){
                        $scope.loading=false;	
                        swal({title:'',text:"Please enter a valid JEE(Main) CRL Rank"});	
                        return;	
                      	
                    } else if ($scope.student.Entrance_Test_Name__c == 'JEE (Main)' && ($scope.student.JEE_Main_CRL_Rank__c == undefined || $scope.student.JEE_Main_CRL_Rank__c == "" ||  parseInt(JeeMainCRLRank) < 1) ){	
                        $scope.loading=false;	
                        swal({title:'',text:"Please enter a valid JEE(Main) CRL Rank."});	
                        return;	
                    } else if(($scope.student.Entrance_Test_Name__c != 'JEE (Advanced)' && $scope.student.Entrance_Test_Name__c != 'No Entrance Exam'   && $scope.student.Entrance_Test_Name__c != 'JEE (Main)' && ($scope.student.Entrance_Test_Rank__c == undefined || parseInt(entranceTestRank) < 1 || $scope.student.Entrance_Test_Rank__c == ""))){    
                        $scope.loading=false;
                        swal({title:'',text:"Please enter a valid General CRL rank."});
                        return;
                    } 

        /* var currYear = new Date().getFullYear();
        var currMonth = new Date().getMonth(); */
		var currentDate=new Date();
		//currentDate.setDate(15);
		//currentDate.setYear(2021);
		//currentDate.setMonth(1);
		var currYear = currentDate.getFullYear();
        var currMonth = currentDate.getMonth();
        /*if(percent_HS != undefined && percent_HS < 70){
            
            swal({
                title: "Are you sure?",
                text: "12th percentage is < 70",
                type: "warning",
                showCancelButton: true,
                confirmButtonClass: "btn-danger",
                confirmButtonText: "Yes",
                closeOnConfirm: false
            },
                 function(){
                     console.log('fired');
                 });
        }  */
        $scope.loading=true;
        console.log('To review student : '+JSON.stringify($scope.student));
        if(this.studentCourse.$invalid){
            $scope.showSpace =true;
            $scope.formCourseInvalid=true;
            $scope.loading=false;
            swal({title:'',text:"Please fill all mandatory (*) fields"});
        }
        else if($scope.student.X10th_Year_Passed__c > $scope.student.X12th_Year_Passed__c){
            $scope.loading=false;
            swal({title:'',text:"10 th year of passing should be less than the 12th year of passing"});
        }
        /*else if(percent_HS != undefined && percent_HS < 70){
            $scope.loading=false;
            swal({title:'',text:"Ensure correct 12th percentage"});
        }
        
            else if((currYear - $scope.student.X12th_Year_Passed__c) > 1|| (currYear - $scope.student.X12th_Year_Passed__c) < 0){
                $scope.loading=false;
                swal({title:'',text:"Application will be ineligible as Year of Passing is more than the eligible criteria."});
            }*/
            else if ($scope.student.Entrance_Test_Name__c != 'No Entrance Exam' && $scope.student.X12th_Year_Passed__c > $scope.student.Entrance_Exam_Taken_In_Year__c){
                $scope.loading=false;
                swal({title:'',text:"Entrance exam taken in year should be greater than or equal to the 12th year of passing"});
            }
                else if(parseFloat($scope.student.X10th_Marks_Obtained__c) > parseFloat($scope.student.X10th_Maximum_Marks__c) || parseFloat($scope.student.X12th_Marks_Obtained__c) > parseFloat($scope.student.X12th_Maximum_Marks__c) || parseFloat($scope.student.Entrance_Test_Marks__c) > parseFloat($scope.student.Entrance_Exam_Maximum_Marks__c)){
                $scope.loading=false;
                swal({title:'',text:"Marks obtained should be less than or equal to Maximum marks."});
          
            }
                else{
                    console.log($scope.student);
                    var studentDOB = $scope.student.Birthdate;
                    $scope.student.Birthdate=Date.parse($scope.student.Birthdate);
                    $scope.student.Birthdate = $scope.student.Birthdate + (6*60*60*1000);
                    if($scope.application.Receiving_Full_AICTE_OtherTution_Fee_Wa__c != undefined && $scope.application.Receiving_Full_AICTE_OtherTution_Fee_Wa__c !='')
                        $scope.application.Receiving_Full_AICTE_OtherTution_Fee_Wa__c = JSON.parse($scope.application.Receiving_Full_AICTE_OtherTution_Fee_Wa__c)
                        if($scope.application.SchlrShp_FinancialAsst_Other_Than_FFE__c != undefined && $scope.application.SchlrShp_FinancialAsst_Other_Than_FFE__c !='')
                            $scope.application.SchlrShp_FinancialAsst_Other_Than_FFE__c = JSON.parse($scope.application.SchlrShp_FinancialAsst_Other_Than_FFE__c)
                            $scope.wrapper ={scholar:{},ScholarAppln:{}};
                    $scope.wrapper.scholar=$scope.student;
                    $scope.wrapper.ScholarAppln=$scope.application;
                    if($scope.student.Course__c=='MBBS'){
                        $scope.student.Branch_Stream__c ='';
                        $scope.student.Branch_Other__c ='';
                    }
                    
                   console.log('currYear='+currYear);
				   console.log('currMonth='+currMonth);
                   console.log('$scope.minusYear='+$scope.minusYear);
                   console.log('$scope.minPercentageForHS='+$scope.minPercentageForHS);
                   console.log('$scope.maxAnnualFamilyIncome='+$scope.maxAnnualFamilyIncome);
                   console.log('Entrance_Exam_Taken_In_Year__c='+$scope.student.Entrance_Exam_Taken_In_Year__c);
                   console.log('X12th_Year_Passed__c='+$scope.student.X12th_Year_Passed__c);
                   console.log('percent_HS='+percent_HS);
				   if(percent_HS < $scope.minPercentageForHS){
						console.log('Res1----');
					}
					if(percent_HS >= $scope.minPercentageForHS){
						console.log('Res2----');
					}
                    //code starts
                    var currYearMinusYear = currYear - $scope.minusYear;
					var minPercentage=$scope.minPercentageForHS * 100;
					console.log('currYearMinusYear='+currYearMinusYear);
					console.log('minPercentage='+minPercentage);
					if(percent_HS < minPercentage){
						console.log('Res3----');
					}
					if(percent_HS >= minPercentage){
						console.log('Res4----');
					}
            
                    if((currMonth < 3 && $scope.student.X12th_Year_Passed__c < (currYearMinusYear - 1)) || (currMonth > 2 && $scope.student.X12th_Year_Passed__c < currYearMinusYear) || (percent_HS  != undefined &&  percent_HS  < $scope.minPercentageForHS ) || ($scope.student.Entrance_Test_Name__c != 'Tamil Nadu Engineering Admissions (TNEA)/Counselling for Admission to MBBS' && ((currMonth < 3 && $scope.student.Entrance_Exam_Taken_In_Year__c != (currYear-1)) || (currMonth > 2 && $scope.student.Entrance_Exam_Taken_In_Year__c != currYear))) || ($scope.student.Entrance_Test_Name__c == 'Tamil Nadu Engineering Admissions (TNEA)/Counselling for Admission to MBBS' && ((currMonth < 3 && $scope.student.Entrance_Exam_Taken_In_Year__c != (currYear-1) && $scope.student.Entrance_Exam_Taken_In_Year__c != (currYear-2)) || (currMonth > 2 && $scope.student.Entrance_Exam_Taken_In_Year__c != currYear && $scope.student.Entrance_Exam_Taken_In_Year__c != (currYear-1))))){
                        $scope.loading=false;
                        
                        var errorMessage = '';
						
						if(currMonth < 3 && $scope.student.X12th_Year_Passed__c < (currYearMinusYear - 1)){
                            errorMessage +='Application will be ineligible as 12th Year of Passing does not match the eligibility criteria. \r\n';
                        }
                        else if(currMonth > 2 && $scope.student.X12th_Year_Passed__c < currYearMinusYear){
                            errorMessage +='Application will be ineligible as 12th Year of Passing does not match the eligibility criteria. \r\n';
                        }
                       /* if(percent_HS  != undefined &&  percent_HS  < $scope.minPercentageForHS){
                            errorMessage += 'Application will be ineligible as your 12th percentage is less than the eligible criteria. \r\n';
                        } */
                        
                        if($scope.student.X12th_percentage__c  != undefined &&  $scope.student.X12th_percentage__c  < $scope.minPercentageForHS){
                            errorMessage += 'Application will be ineligible as your 12th percentage is less than the eligible criteria. \r\n';
                        }

                      
                        
						if($scope.student.Entrance_Test_Name__c == 'Tamil Nadu Engineering Admissions (TNEA)/Counselling for Admission to MBBS'){
							console.log('TNEA');
							if(currMonth < 3 && $scope.student.Entrance_Exam_Taken_In_Year__c != (currYear-1) && $scope.student.Entrance_Exam_Taken_In_Year__c != (currYear-2)){
								errorMessage += 'Application will be ineligible as Entrance Exam taken in Year does not match the eligibility criteria.\r\n';
							}
							else if(currMonth > 2 && $scope.student.Entrance_Exam_Taken_In_Year__c != currYear && $scope.student.Entrance_Exam_Taken_In_Year__c != (currYear-1)){
								errorMessage += 'Application will be ineligible as Entrance Exam taken in Year does not match the eligibility criteria.\r\n';
							}
						}
						else if(currMonth < 3 && $scope.student.Entrance_Exam_Taken_In_Year__c != (currYear-1)){
                            errorMessage += 'Application will be ineligible as Entrance Exam taken in Year does not match the eligibility criteria.\r\n';
                        }
                        else if(currMonth > 2 && $scope.student.Entrance_Exam_Taken_In_Year__c != currYear){
                            errorMessage += 'Application will be ineligible as Entrance Exam taken in Year does not match the eligibility criteria.\r\n';
                        }
                        
                        swal({title:'',
                              text:errorMessage,
                              allowEscapeKey:false,
                              showCancelButton: true
                             },
                             function(isConfirm){ 
                                 swal.close();
                                 console.log('isConfirm ' +isConfirm);
                                 if(!isConfirm){
                                     $scope.student.Birthdate = studentDOB;
                                     return;
                                 }
                                 
                                 AP_Student_Application_CTRL.createStudentInSFDC($scope.wrapper,function(result,event){
                                     debugger;
                                     if(event.status){ 
                                         console.log(result);
                                         $scope.loading=false;
                                         swal({title:'',
                                               text:result.message,
                                               allowEscapeKey:false
                                              },
                                              function(isConfirm){ 
                                                  swal.close();
                                                  if (isConfirm) {
                                                      if($scope.student.Refered_by_Facilitator_Id__c==null && $scope.student.Refered_by_Facilitator_Name__c==null){
                                                          window.location.replace('http://www.ffe.org/');
                                                      }
                                                      else{
                                                          if(result.message == $scope.DocumnetUploadMessage){
                                                              
                                                              var form = document.createElement("form");
                                                              form.setAttribute("method", "post");
                                                              form.setAttribute("action", $scope.studentProfileURL);
                                                              
                                                              form.setAttribute("target", "_top");
                                                              
                                                              var hiddenField = document.createElement("input"); 
                                                              hiddenField.setAttribute("type", "hidden");
                                                              hiddenField.setAttribute("name", "encStudentId");
                                                              hiddenField.setAttribute("value", result.recordId);
                                                              form.appendChild(hiddenField);
                                                              document.body.appendChild(form);
                                                              
                                                              window.open('', '_top');
                                                              
                                                              form.submit();
                                                          }
                                                          else{
                                                              window.location.replace('http://www.ffe.org/');
                                                          }
                                                          
                                                      }
                                                  }
                                              });
                                         $scope.$apply();
                                     }
                                     else{
                                         $scope.loading=false;
                                         $scope.$apply();
                                     }
                                 });
                                 
                                 
                             });
                    }
                    else
                    {
                        
                        AP_Student_Application_CTRL.createStudentInSFDC($scope.wrapper,function(result,event){
                            if(event.status){ 
                                console.log(result);
                                $scope.loading=false;
                                swal({title:'',
                                      text:result.message,
                                      allowEscapeKey:false
                                     },
                                     function(isConfirm){ 
                                         swal.close();
                                         if (isConfirm) {
                                             if($scope.student.Refered_by_Facilitator_Id__c==null && $scope.student.Refered_by_Facilitator_Name__c==null){
                                                 window.location.replace('http://www.ffe.org/');
                                             }
                                             else{
                                                 if(result.message == $scope.DocumnetUploadMessage){
                                                     
                                                     var form = document.createElement("form");
                                                     form.setAttribute("method", "post");
                                                     form.setAttribute("action", $scope.studentProfileURL);
                                                     
                                                     form.setAttribute("target", "_top");
                                                     
                                                     var hiddenField = document.createElement("input"); 
                                                     hiddenField.setAttribute("type", "hidden");
                                                     hiddenField.setAttribute("name", "encStudentId");
                                                     hiddenField.setAttribute("value", result.recordId);
                                                     form.appendChild(hiddenField);
                                                     document.body.appendChild(form);
                                                     
                                                     window.open('', '_top');
                                                     
                                                     form.submit();
                                                 }
                                                 else{
                                                     window.location.replace('http://www.ffe.org/');
                                                 }
                                                 
                                             }
                                         }
                                     });
                                $scope.$apply();
                            }
                            else{
                                $scope.loading=false;
                                $scope.$apply();
                            }
                        });
                    }
                    //code ends
                    
                }
        
    }
    
    $scope.getCities = function(state){
        $scope.loading=true;
        AP_Student_Application_CTRL.getCities(state,function(result,event){
            if(event.status){
                $scope.listOfCities = JSON.parse(result);
                $scope.loading=false;
                $scope.$apply();
            }
            else{
                $scope.loading=false;
                $scope.$apply();
            }
        },{escape:false})
        
    }
    $scope.getBoardMaxMarks_X10 = function(state){
        $scope.loading=true;
        AP_Student_Application_CTRL.getBoardMaxMarks(state,function(result,event){
            if(event.status){ 
                $scope.student.X10th_Maximum_Marks__c = JSON.parse(result);
                $scope.loading=false;
                $scope.$apply();
            }
            else{
                $scope.loading=false;
                $scope.$apply();
            }
        },{escape:false})
        
    }
    $scope.maxMarksValidation = function(state1,state2){
        if(state1 < state2){
            swal({title:'',text:"Max Marks cannot be less that Marks Obtained."});
        }
    }
     console.log($scope.student.Father_Age__c);
    /*$scope.change=function(inputField){
        console.log($scope.student.Father_Age__c,inputField);
        $('.number').inputFilter(function(value) {
            var reg = new RegExp('/^[0-9]+$/');
            console.log(/^[0-9]+$/.test(value));//   /^-?\d*$/
            if(/^[0-9]+$/.test(value)==false){
                //inputField=undefined;
               // $scope.student.Father_Age__c=un
                 console.log($scope.student.Father_Age__c,inputField);
                return /^[0-9]+$/.test(value);


            }
        });
    }*/
    
    $scope.setMaxMarks_X10 = function(state){
        if(state != undefined && state != null && state <= 10){
            $scope.student.X10th_Maximum_Marks__c = 10;
            $scope.maxMarks10_readOnly = true;
        }
        else
        {
            $scope.maxMarks10_readOnly = false;
            $scope.student.X10th_Maximum_Marks__c = null;
        }
    }
    $scope.setMaxMarks_X12 = function(state){
        console.log(state);
        if(state != undefined && state != null && state <= 10){
            $scope.student.X12th_Maximum_Marks__c = 10;
            $scope.maxMarks12_readOnly = true;
        }
        else
        {
            $scope.maxMarks12_readOnly = false;
            $scope.student.X12th_Maximum_Marks__c = null;
        }
    }
    $scope.getmaxPercentage = function(value,type){
        debugger;
       
        if(value > 100){
            if(type == "X12th_percentage"){
             	$scope.student.X12th_percentage__c = 100;
            }else if(type == "X10th_percentage"){
                $scope.student.X10th_Percentage__c = 100;
            }
            return;
        }else{
            if(type == "X12th_percentage"){
                $scope.student.X12th_percentage__c = Number(value.toFixed(2));
            }else if(type == "X10th_percentage"){
                $scope.student.X10th_Percentage__c = Number(value.toFixed(2));
            }
        }
    }
    $scope.getBoardMaxMarks_X12 = function(state){
        $scope.loading=true;
        AP_Student_Application_CTRL.getBoardMaxMarks(state,function(result,event){
            if(event.status){ 
                $scope.student.X12th_Maximum_Marks__c = JSON.parse(result);
                $scope.loading=false;
                $scope.$apply();
            }
            else{
                $scope.loading=false;
                $scope.$apply();
            }
        },{escape:false})
        
    }
    
    function checkDec(el){
        debugger;
        var ex = /^[0-9]+\.?[0-9]*$/;
        if(ex.test(el.value)==false){
          el.value = el.value.substring(0,el.value.length - 1);
         }
       }
})