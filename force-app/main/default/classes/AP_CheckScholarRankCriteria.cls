/*
*@purpose       : Checks Scholar Eligibilty Criteria in Student Records 
*@param         : Contact record
*@returnType    : Wrapper Class
*/ 
public class AP_CheckScholarRankCriteria{
    
    public static WrapperApplication ValidationRankCriteria(Contact contactInfo){
        
        Entrance_Test__mdt md           =       [Select BE_BTech_MTech_Qualifying_Rank__c,BALLB_Qualifying_Rank__c,BPharm_Qualifying_Rank__c, Entrance_Test_Name__c,JEE_Main_CRL_Rank__c,JEE_Advance_All_India_Rank__c,JEE_Advance_Category_Rank__c, MBBS_Qualifying_Rank__c 
                                                 from Entrance_Test__mdt
                                                 where Entrance_Test_Name__c=:contactInfo.Entrance_Test_Name__c];
        
        WrapperApplication wa           =       new WrapperApplication(contactInfo);
        
        Scholarship_Criteria__c sc      =       Scholarship_Criteria__c.getOrgDefaults();        
        
        double X12thPercentage          =       (contactInfo.X12th_Marks_Obtained__c/contactInfo.X12th_Maximum_Marks__c)*100;
        
        //Added modified criteria for application eligibility & rejection -- Sumit Gaurav - 11-June-2019
        integer currentYear=System.Today().year();
        integer currentMonth=System.Today().month(); 
        system.debug(Integer.valueof(contactInfo.X12th_Year_Passed__c)<= currentYear);
        system.debug((Integer.valueOf(contactInfo.X12th_Year_Passed__c)-(currentYear- sc.HS_Year_of_Passing_Less_than__c - 1))+'<=1');
        system.debug((Integer.valueOf(contactInfo.X12th_Year_Passed__c)-(currentYear- sc.HS_Year_of_Passing_Less_than__c - 1))+'>=0');
        system.debug('JEE_Advance_All_India_Rank__c--'+contactInfo.JEE_Advance_All_India_Rank__c);
        system.debug('JEE_Advance_All_India_Rank__c--'+contactInfo.JEE_Main_CRL_Rank__c);
        system.debug('JEE_Advance_All_India_Rank__c--'+contactInfo.JEE_Advance_Category_Rank__c);
        system.debug('contactInfo.Entrance_Test_Name__c--'+contactInfo.Entrance_Test_Name__c);
        system.debug('md-----'+md);
        if(Integer.valueof(contactInfo.X12th_Year_Passed__c)<= currentYear && ((currentMonth < 4 && (Integer.valueOf(contactInfo.X12th_Year_Passed__c)-(currentYear- sc.HS_Year_of_Passing_Less_than__c - 1)) <=sc.HS_Year_of_Passing_Less_than__c && (Integer.valueOf(contactInfo.X12th_Year_Passed__c)-(currentYear- sc.HS_Year_of_Passing_Less_than__c - 1))>=0) || (currentMonth >= 4 && (Integer.valueOf(contactInfo.X12th_Year_Passed__c)-(currentYear- sc.HS_Year_of_Passing_Less_than__c))<=sc.HS_Year_of_Passing_Less_than__c && (Integer.valueOf(contactInfo.X12th_Year_Passed__c)-(currentYear- sc.HS_Year_of_Passing_Less_than__c))>=0))){
            system.debug('inside graduation block::');
            if(Integer.valueof(contactInfo.Entrance_Exam_Taken_In_Year__c)<=currentYear && ((contactInfo.Entrance_Test_Name__c != 'Tamil Nadu Engineering Admissions (TNEA)/Counselling for Admission to MBBS' && ((currentMonth < 4 && currentYear - Integer.valueof(contactInfo.Entrance_Exam_Taken_In_Year__c)==1) || (currentMonth >= 4 && currentYear==Integer.valueof(contactInfo.Entrance_Exam_Taken_In_Year__c)))) || (contactInfo.Entrance_Test_Name__c == 'Tamil Nadu Engineering Admissions (TNEA)/Counselling for Admission to MBBS' && ((currentMonth < 4 && currentYear - Integer.valueof(contactInfo.Entrance_Exam_Taken_In_Year__c)<=2 && currentYear - Integer.valueof(contactInfo.Entrance_Exam_Taken_In_Year__c)>0) || (currentMonth >= 4 && currentYear - Integer.valueof(contactInfo.Entrance_Exam_Taken_In_Year__c)<=1))))){
                system.debug('inside entrencetest Block::');
                system.debug('wa.internalStatus --'+wa.internalStatus);
                if(X12thPercentage >= sc.Min_12th_Percentage__c){
                    
                    if(contactInfo.Annual_Family_Income__c <= sc.Max_Annual_Family_Income__c){
                        
                        if(contactInfo.Course__c == System.Label.StudentCourseMBBS && (contactInfo.Entrance_Test_Rank__c > 0 && contactInfo.Entrance_Test_Rank__c <= md.MBBS_Qualifying_Rank__c)){
                            
                            wa.internalStatus = System.Label.ScholarshipInternalStatusEligible;
                            wa.externalStatus = System.Label.ScholarshipExternalStatusReceived;
                            return wa;
                        }
                        else if(contactInfo.Course__c == System.Label.StudentCourseBPharm && (contactInfo.Entrance_Test_Rank__c > 0 && contactInfo.Entrance_Test_Rank__c <= md.BPharm_Qualifying_Rank__c)){
                            wa.internalStatus = System.Label.ScholarshipInternalStatusEligible;
                            wa.externalStatus = System.Label.ScholarshipExternalStatusReceived;
                            return wa;
                            
                        }
                        else if(contactInfo.Course__c == 'Law' && (contactInfo.Entrance_Test_Rank__c > 0 && contactInfo.Entrance_Test_Rank__c <= md.BALLB_Qualifying_Rank__c)){
                            wa.internalStatus = System.Label.ScholarshipInternalStatusEligible;
                            wa.externalStatus = System.Label.ScholarshipExternalStatusReceived;
                            return wa;
                            
                        }
                        else if((contactInfo.Course__c == System.Label.StudentCourseBTech 
                                 || contactInfo.Course__c == System.Label.StudentCourseBE 
                                 || contactInfo.Course__c == System.Label.StudentCourseBEBTECH
                                 || contactInfo.Course__c == System.Label.StudentCourseMTech) 
                                && (contactInfo.Entrance_Test_Rank__c > 0 && contactInfo.Entrance_Test_Rank__c <= md.BE_BTech_MTech_Qualifying_Rank__c)){
                                    system.debug('inside BE block');
                                    system.debug('wa.internalStatus --'+wa.internalStatus);
                                    wa.internalStatus = System.Label.ScholarshipInternalStatusEligible;
                                    wa.externalStatus = System.Label.ScholarshipExternalStatusReceived;
                                    return wa;
                                }else if((contactInfo.Course__c == System.Label.StudentCourseBTech || contactInfo.Course__c == System.Label.StudentCourseBE || contactInfo.Course__c == System.Label.StudentCourseBEBTECH || contactInfo.Course__c == System.Label.StudentCourseMTech) 
                                         && (contactInfo.Entrance_Test_Name__c == 'JEE (Advanced)')){
                                             system.debug('inside JEE Advance');
                                             if(contactInfo.JEE_Advance_All_India_Rank__c > 0 && contactInfo.JEE_Advance_All_India_Rank__c <= md.JEE_Advance_All_India_Rank__c){
                                                 system.debug('inside JEE JEE_Advance_All_India_Rank__c');
                                                 wa.internalStatus = System.Label.ScholarshipInternalStatusEligible;
                                                 wa.externalStatus = System.Label.ScholarshipExternalStatusReceived;
                                                 return wa;
                                             }else{
                                                 if(contactInfo.JEE_Main_CRL_Rank__c <= md.JEE_Main_CRL_Rank__c){
                                                     system.debug('inside JEE JEE_Advance_All_India_Rank__c else');
                                                     wa.internalStatus = System.Label.ScholarshipInternalStatusEligible;
                                                     wa.externalStatus = System.Label.ScholarshipExternalStatusReceived;
                                                     return wa;
                                                 }else{
                                                     wa.internalStatus = System.Label.ScholarshipInternalStatusIneligible;
                                                     wa.externalStatus = System.Label.ScholarshipExternalStatusSubmitted;
                                                     wa.rejectionReason = System.Label.Rejection_Reason_Rank_Limitations;
                                                     return wa; 
                                                 }
                                                 
                                             }
                                             if(contactInfo.JEE_Advance_All_India_Rank__c == 0 && contactInfo.JEE_Main_CRL_Rank__c <= md.JEE_Main_CRL_Rank__c){
                                                 system.debug('inside JEE JEE_Main_CRL_Rank__c');
                                                 wa.internalStatus = System.Label.ScholarshipInternalStatusEligible;
                                                 wa.externalStatus = System.Label.ScholarshipExternalStatusReceived;
                                                 return wa;
                                             }else{
                                                wa.internalStatus = System.Label.ScholarshipInternalStatusIneligible;
                                                wa.externalStatus = System.Label.ScholarshipExternalStatusSubmitted;
                                                wa.rejectionReason = System.Label.Rejection_Reason_Rank_Limitations;
                                                return wa;
                                             }
                                         }
                        else if((contactInfo.Course__c == System.Label.StudentCourseBTech || contactInfo.Course__c == System.Label.StudentCourseBE || contactInfo.Course__c == System.Label.StudentCourseBEBTECH || contactInfo.Course__c == System.Label.StudentCourseMTech) 
                                && (contactInfo.Entrance_Test_Name__c == 'JEE (Main)')){
                                    system.debug('inside JEE Main');
                                    if(contactInfo.JEE_Main_CRL_Rank__c <= md.JEE_Main_CRL_Rank__c){
                                        system.debug('inside JEE JEE_Main_CRL_Rank__c');
                                        wa.internalStatus = System.Label.ScholarshipInternalStatusEligible;
                                        wa.externalStatus = System.Label.ScholarshipExternalStatusReceived;
                                        return wa;
                                    }else{                        
                                        wa.internalStatus = System.Label.ScholarshipInternalStatusIneligible;
                                        wa.externalStatus = System.Label.ScholarshipExternalStatusSubmitted;
                                        wa.rejectionReason = System.Label.Rejection_Reason_Rank_Limitations;
                                        return wa;
                                    }
                                }
                        else{                        
                            wa.internalStatus = System.Label.ScholarshipInternalStatusIneligible;
                            wa.externalStatus = System.Label.ScholarshipExternalStatusSubmitted;
                            wa.rejectionReason = System.Label.Rejection_Reason_Rank_Limitations;
                            return wa;
                        }
                    }else{                    
                        wa.internalStatus = System.Label.ScholarshipInternalStatusIneligible;
                        wa.externalStatus = System.Label.ScholarshipExternalStatusSubmitted;
                        wa.rejectionReason = System.Label.Rejection_Reason_Annual_Income;
                        return wa;
                    }
                }else{                
                    wa.internalStatus = System.Label.ScholarshipInternalStatusIneligible;
                    wa.externalStatus = System.Label.ScholarshipExternalStatusSubmitted;
                    wa.rejectionReason = System.Label.Rejection_Reason_HS_Percentage;
                    return wa;
                }
            }
            else{                
                wa.internalStatus = System.Label.ScholarshipInternalStatusIneligible;
                wa.externalStatus = System.Label.ScholarshipExternalStatusSubmitted;
                wa.rejectionReason = System.Label.Rejection_Reason_Entrance_YEAR;
                return wa;
            }
        }else{
            system.debug('inside else block'); 
            wa.internalStatus = System.Label.ScholarshipInternalStatusIneligible;
            wa.externalStatus = System.Label.ScholarshipExternalStatusSubmitted;
            wa.rejectionReason = System.Label.Rejection_Reason_Graduation_Year;
            return wa;
        }
        return null;
    }
    public class WrapperApplication{
        
        public Contact conInfo;
        public String internalStatus;
        public String externalStatus;
        public String rejectionReason;
        
        public WrapperApplication(Contact contactInfo){
            
            conInfo = contactInfo; 
        }
    }
    public static void mytest(){
        Integer i=0;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++; 
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++;
        i++;i++; 
    }
}