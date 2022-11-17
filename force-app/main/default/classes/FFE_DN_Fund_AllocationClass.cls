public class FFE_DN_Fund_AllocationClass {

    static string currentFiscalYear;

    @AuraEnabled(cacheable=true)
    public static List<RecordType> getApplicationType(){
        List<String> lstPickvals = new List<String>();
        List<RecordType> appRtList = new List<RecordType>();
        appRtList = DN_FundAllocation_Helper.getApplicationType();
        for (RecordType a : appRtList) {
            lstPickvals.add(String.ValueOf(a.Name));
        }
        return appRtList;        
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getGauOptions(){
        return DN_DonorAllocation_Helper.getGeneralAccountUnit();        
    }

    @AuraEnabled
    public static string doFundDisburment(string student,string appln,List<string> amtFunded,
    string totalFundedAmt){
        string message;
        try {
            FundDisburseWrapper fundWrp = new FundDisburseWrapper();
            fundWrp.amtFunded           = new List<FundDisburseWrapper.fundedAmtByGAU>();
            fundWrp.student = new Contact(Id=student);
            List<Application__c> appList = [Select Id,Recordtype.Name from Application__c where Id=:appln ];
            Application__c application = new Application__c();
            if(appList.size()>0){
                application.RecordType = appList[0].Recordtype;
            }
            System.debug('appList[0].Recordtype.Name'+appList[0].Recordtype.Name);
            List<Donor_Application_Mapping__c> damList = [Select Id,Donor__c,Application__c from Donor_Application_Mapping__c
                            where Application__c=:appln ];
            Set<Id> donorIds = new Set<Id>();
            if(damList.size()>0){
                for(Donor_Application_Mapping__c dam:damList){
                    donorIds.add(dam.Donor__c);
                }
            }
            FundDisburseWrapper.fundedAmtByGAU fundAmt;
            List<String> donorBalanceIds = new List<String>();
            List<Donor_Balance__c> dbList = [Select Id,Current_Balance__c,GAU_Name__c,
            Mapped_Fund__c,Total_Available_Fund__c,Donor_Name__c from Donor_Balance__c where Id In:donorIds];
            if(dbList.size()>0){
                for(Donor_Balance__c db:dbList){
                    donorBalanceIds.add(db.Id);
                    fundAmt = new FundDisburseWrapper.fundedAmtByGAU();
                    fundAmt.donorbalance = db;
                    fundWrp.amtFunded.add(fundAmt);
                }
            }
            fundWrp.donorBalanceIds = donorBalanceIds;
            application.Id = appln;
            fundWrp.appln = application;
           // fundWrp.amtFunded = amtFunded;
            fundWrp.totalFundedAmt = decimal.valueOf(totalFundedAmt);
             
           
            message = 'Success';
            DN_FundAllocation_Helper.isMultiDonorFlag = True;
            message = DN_FundAllocation_Helper.doFundDisburment(fundWrp);

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
           
        }
        return message;
    }

    @AuraEnabled(cacheable=true)
    public static List<Donor_Application_Mapping__c> getMultiDonor(string applicationId){ 
      
        List<Donor_Application_Mapping__c> contactList = [Select Id,Application__c,Donor__r.Name,Donor__r.Current_Balance__c,Donor__r.FFE_ID__c,Funding_amount__c
                         from Donor_Application_Mapping__c where Application__c=:applicationId];
        
        return contactList;
    }

    @AuraEnabled()
    public static List<Contact> getAllStudents_multiDonor(String studentType, List<String> applType){  
        DN_FundAllocation_CTRL.searchFilterWrapper searchWrp = new DN_FundAllocation_CTRL.searchFilterWrapper ();
        searchWrp.studentType= studentType; 
        searchWrp.applType = applType; 
        return DN_FundAllocation_Helper.getAllFilteredStudents_multi(searchWrp); 
        /*System.debug('applType'+applType);
        Set<String> idStrs = (Set<String>)JSON.deserialize(JSON.serialize(applType), Set<String>.class);
        List<Id> recordTypes = new List<Id> ();
        for(string app:idStrs){
            recordTypes.add(app);
        }
        System.debug('recordTypes'+recordTypes);
        List<Contact> contactList = new List<Contact>();
        if(recordTypes.size()>0){
            contactList = DN_FundAllocation_Helper.getAllStudents_multiDonor(recordTypes);
        }
        system.debug('contactList'+contactList[0]);
         system.debug('contactList'+contactList[1]);
        return contactList;*/
    }

    @AuraEnabled()
    public static List<Contact> getStudentswithApplication(List<String> applType, string studentType ){
        
        currentFiscalYear = Utility.financialYear();
        List<Contact> awaitingCons  = new List<Contact>();
        System.debug('studentType>>'+studentType);
        Set<String> idStrs = (Set<String>)JSON.deserialize(JSON.serialize(applType), Set<String>.class);
        List<Id> recordTypes = new List<Id> ();
        for(string app:idStrs){
            recordTypes.add(app);
        }
        System.debug('idStrings>>' + idStrs);
        if(studentType == Constants.ALL_AWAITING_STUDENT){
            awaitingCons    = getAllAwaitingStudents(recordTypes);
            system.debug('<<con>>'+awaitingCons[0].Name+'<<app24>>'+awaitingCons[0].Applications__r);
            system.debug('awaitingCons>>'+awaitingCons);
            return awaitingCons;//getAwatingingApplications(recordTypes,awaitingCons);
        }else if(studentType == Constants.ALL_MAPPED_STUDENT){
            awaitingCons    = getAllMappedStudents(applType);
            return getAwatingingApplications(applType,awaitingCons);
        }else if(studentType == Constants.ALL_UNMAPPED_STUDENT){
            return getAllUnMappedStudents(applType);
        }else{
            return new List<Contact>();
        }
        /*       
        String studentRecordType    = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId();

        awaitingCons = [Select id,Name,FFE_ID__c,ScholarshipAmount__c,toLabel(Internal_Status__c),MailingCity,MailingState,
        Full_Bank_Account_No_With_all_digits__c,Bank_Account_Holder_s_Name__c,X11_character_IFSC_Code_of_the_Branch__c,
        Bank_Name__c,Branch_Address__c,Bank_City__c,
        (select id,Name,Amount_Requested__c,Amount_Funded__c,RecordTypeId, RecordType.Name,IsMapped__c,
         Student__c,toLabel(Internal_Status__c),Course__c,Year__c,Course_Name__c,Application_Stage__c,Remaining_Fund__c
         from Applications__r where (Internal_Status__c =:Constants.AWAITING_FUND_STATUS OR Internal_Status__c =:Constants.AWAITING_FUND_STATUS_API)
         AND Application_Stage__c =:Constants.ACTIVE_APPLICATION AND RecordTypeId IN : idStrs
        AND RPT_Financial_Year__c =:currentFiscalYear AND Student_Confirmation_on_Receipt__c = true)
        from Contact where RecordTypeId =: studentRecordType 
        AND (Internal_Status__c =:Constants.AWAITING_FUND_STATUS OR Internal_Status__c =:Constants.AWAITING_FUND_STATUS_API) order by Name];    
        
        
        system.debug('<<con>>'+awaitingCons[0].Name+'<<app24>>'+awaitingCons[0].Applications__r);

        return awaitingCons;*/
    }
    
    
    /*
     * @purpose     : Get all student with Awaiting for Fund Status
     * @returnType  : List<Contact>
    */ 
    public static List<Contact> getAllAwaitingStudents(List<Id> recordTypes){ 
        System.debug('getAllAwaitingStudents>>');       
        String studentRecordType    = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId(); 
        if(recordTypes.size() > 0){
            return [Select id,Name,FFE_ID__c,ScholarshipAmount__c,toLabel(Internal_Status__c),MailingCity,MailingState,
                    Full_Bank_Account_No_With_all_digits__c,Bank_Account_Holder_s_Name__c,X11_character_IFSC_Code_of_the_Branch__c,
                    Bank_Name__c,Branch_Address__c,Bank_City__c,
                    (select id,Name,Amount_Requested__c,Amount_Funded__c,RecordTypeId, RecordType.Name,IsMapped__c,
                     Student__c,toLabel(Internal_Status__c),Course__c,Year__c,Course_Name__c,Application_Stage__c,Remaining_Fund__c
                     from Applications__r where (Internal_Status__c =:Constants.AWAITING_FUND_STATUS OR Internal_Status__c =:Constants.AWAITING_FUND_STATUS_API)
                     AND Application_Stage__c =:Constants.ACTIVE_APPLICATION AND RecordTypeId IN : recordTypes
                    AND RPT_Financial_Year__c =:currentFiscalYear AND Student_Confirmation_on_Receipt__c = true)
                    from Contact where RecordTypeId =: studentRecordType 
                    AND (Internal_Status__c =:Constants.AWAITING_FUND_STATUS OR Internal_Status__c =:Constants.AWAITING_FUND_STATUS_API) order by Name];
            
        }else{
            return [Select id,Name,FFE_ID__c,ScholarshipAmount__c,toLabel(Internal_Status__c),MailingCity,MailingState,
                    Full_Bank_Account_No_With_all_digits__c,Bank_Account_Holder_s_Name__c,X11_character_IFSC_Code_of_the_Branch__c,
                    Bank_Name__c,Branch_Address__c,Bank_City__c,
                    (select id,Name,Amount_Requested__c,Amount_Funded__c,RecordTypeId, RecordType.Name,IsMapped__c,
                     Student__c,toLabel(Internal_Status__c),Course__c,Year__c,Course_Name__c,Application_Stage__c,Remaining_Fund__c
                     from Applications__r where (Internal_Status__c =:Constants.AWAITING_FUND_STATUS OR Internal_Status__c =:Constants.AWAITING_FUND_STATUS_API) 
                     AND Application_Stage__c =:Constants.ACTIVE_APPLICATION AND RPT_Financial_Year__c =:currentFiscalYear AND Student_Confirmation_on_Receipt__c = true)
                    from Contact where RecordTypeId =: studentRecordType AND 
                    (Internal_Status__c =:Constants.AWAITING_FUND_STATUS OR Internal_Status__c =:Constants.AWAITING_FUND_STATUS_API) order by Name];
            
        }
    }
    
    /*
     * @purpose     : Get all student with Awaiting for Fund Status, who are 
     *                mapped to donor
     * @returnType  : List<Contact>
    */
    public static List<Contact> getAllMappedStudents(List<Id> recordTypes){
        
        String studentRecordType    = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId(); 

        if(recordTypes.size() > 0){
            return [Select id,Name,FFE_ID__c,ScholarshipAmount__c,toLabel(Internal_Status__c),MailingCity,MailingState,
                    Full_Bank_Account_No_With_all_digits__c,Bank_Account_Holder_s_Name__c,X11_character_IFSC_Code_of_the_Branch__c,
                    Bank_Name__c,Branch_Address__c,Bank_City__c,
                    (select id,Name,Amount_Requested__c,Amount_Funded__c,RecordTypeId, RecordType.Name,IsMapped__c,
                     Student__c,toLabel(Internal_Status__c),Course__c,Year__c,Course_Name__c,Application_Stage__c,Remaining_Fund__c
                     from Applications__r where (Internal_Status__c =:Constants.AWAITING_FUND_STATUS OR Internal_Status__c =:Constants.AWAITING_FUND_STATUS_API) 
                     AND Application_Stage__c =:Constants.ACTIVE_APPLICATION AND RecordTypeId IN : recordTypes
                    AND RPT_Financial_Year__c =:currentFiscalYear AND Student_Confirmation_on_Receipt__c = true)
                    from Contact where RecordTypeId =: studentRecordType AND (Internal_Status__c =:Constants.AWAITING_FUND_STATUS OR Internal_Status__c =:Constants.AWAITING_FUND_STATUS_API) 
                    AND ID IN (Select Student__c from Donor_Application_Mapping__c 
                               where (Student__r.Internal_Status__c =:Constants.AWAITING_FUND_STATUS 
                                OR Student__r.Internal_Status__C =:Constants.AWAITING_FUND_STATUS_API)
                              AND Financial_Year__c =:currentFiscalYear ) 
                    order by Name];
        
        }else{
            return [Select id,Name,FFE_ID__c,ScholarshipAmount__c,toLabel(Internal_Status__c),MailingCity,MailingState,
                    Full_Bank_Account_No_With_all_digits__c,Bank_Account_Holder_s_Name__c,X11_character_IFSC_Code_of_the_Branch__c,
                    Bank_Name__c,Branch_Address__c,Bank_City__c,
                    (select id,Name,Amount_Requested__c,Amount_Funded__c,RecordTypeId, RecordType.Name,IsMapped__c,
                     Student__c,toLabel(Internal_Status__c),Course__c,Year__c,Course_Name__c,Application_Stage__c,Remaining_Fund__c
                     from Applications__r where (Internal_Status__c =:Constants.AWAITING_FUND_STATUS OR Internal_Status__c =:Constants.AWAITING_FUND_STATUS_API)
                     AND Application_Stage__c =:Constants.ACTIVE_APPLICATION AND RPT_Financial_Year__c =:currentFiscalYear AND Student_Confirmation_on_Receipt__c = true)
                    from Contact where RecordTypeId =: studentRecordType AND (Internal_Status__c =:Constants.AWAITING_FUND_STATUS OR Internal_Status__c =:Constants.AWAITING_FUND_STATUS_API)
                    AND ID IN (Select Student__c from Donor_Application_Mapping__c 
                               where (Student__r.Internal_Status__c =:Constants.AWAITING_FUND_STATUS 
                               OR Student__r.Internal_Status__c =:Constants.AWAITING_FUND_STATUS_API)
                              AND Financial_Year__c =:currentFiscalYear)
                    order by Name];
        }
    }
    
    /*
     * @purpose     : Get all student with Awaiting for Fund Status, who are not
     *                mapped to any donor
     * @returnType  : List<Contact>
    */
    public static List<Contact> getAllUnMappedStudents(List<Id> recordTypes){
        
        String studentRecordType    = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId(); 
        if(recordTypes.size() > 0){
            return [Select id,Name,FFE_ID__c,ScholarshipAmount__c,toLabel(Internal_Status__c),MailingCity,MailingState,
                    Full_Bank_Account_No_With_all_digits__c,Bank_Account_Holder_s_Name__c,X11_character_IFSC_Code_of_the_Branch__c,
                    Bank_Name__c,Branch_Address__c,Bank_City__c,
                    (select id,Name,Amount_Requested__c,Amount_Funded__c,RecordTypeId, RecordType.Name,IsMapped__c,
                     Student__c,toLabel(Internal_Status__c),Course__c,Year__c,Course_Name__c,Application_Stage__c,Remaining_Fund__c
                     from Applications__r where (Internal_Status__c =:Constants.AWAITING_FUND_STATUS OR Internal_Status__c =:Constants.AWAITING_FUND_STATUS_API) 
                     AND Application_Stage__c =:Constants.ACTIVE_APPLICATION AND RecordTypeId =: recordTypes
                     AND RPT_Financial_Year__c =:currentFiscalYear AND Student_Confirmation_on_Receipt__c = true)
                    from Contact where RecordTypeId =: studentRecordType AND (Internal_Status__c =:Constants.AWAITING_FUND_STATUS OR Internal_Status__c =:Constants.AWAITING_FUND_STATUS_API) 
                    AND ID NOT IN (Select Student__c from Donor_Application_Mapping__c 
                                   where (Student__r.Internal_Status__c =:Constants.AWAITING_FUND_STATUS OR Student__r.Internal_Status__c =:Constants.AWAITING_FUND_STATUS_API)
                                  AND Financial_Year__c =:currentFiscalYear)
                    order by Name];
        }else{
            return [Select id,Name,FFE_ID__c,ScholarshipAmount__c,toLabel(Internal_Status__c),MailingCity,MailingState,
                    Full_Bank_Account_No_With_all_digits__c,Bank_Account_Holder_s_Name__c,X11_character_IFSC_Code_of_the_Branch__c,
                    Bank_Name__c,Branch_Address__c,Bank_City__c,
                    (select id,Name,Amount_Requested__c,Amount_Funded__c,RecordTypeId, RecordType.Name,IsMapped__c,
                     Student__c,toLabel(Internal_Status__c),Course__c,Year__c,Course_Name__c,Application_Stage__c,Remaining_Fund__c
                     from Applications__r where (Internal_Status__c =:Constants.AWAITING_FUND_STATUS OR Internal_Status__c =:Constants.AWAITING_FUND_STATUS_API) 
                     AND Application_Stage__c =:Constants.ACTIVE_APPLICATION AND RPT_Financial_Year__c =:currentFiscalYear AND Student_Confirmation_on_Receipt__c = true)
                    from Contact where RecordTypeId =: studentRecordType AND (Internal_Status__c =:Constants.AWAITING_FUND_STATUS OR Internal_Status__c =:Constants.AWAITING_FUND_STATUS_API) 
                    AND ID NOT IN (Select Student__c from Donor_Application_Mapping__c 
                                   where (Student__r.Internal_Status__c =:Constants.AWAITING_FUND_STATUS OR Student__r.Internal_Status__c =:Constants.AWAITING_FUND_STATUS_API)
                                  AND Financial_Year__c =:currentFiscalYear) order by Name];
        }
        
    }
      
    /*
     * @Purpose:  Check if any Additional Expensne Application is available for selected recordType. 
     *            if Yes: add those contacts to List to awaitingContacts 
     *              else: return same awaitingContacts list
     * @param: recordTypeIds : Selected Application RecordType Ids
     * @param: awaitingContacts: All contains whose application are in awaiting for fund for current year 
     */ 
    public static List<Contact> getAwatingingApplications(List<String> recordTypeIds ,List<Contact> awaitingContacts){
        try{
            Set<String> appRecordIDs    = new Set<String>(recordTypeIds);
            String studentRecordType    = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(Constants.FFE_DONOR_STUDENT).getRecordTypeId(); 
            String addAppRecordType     = Schema.SObjectType.Application__c.getRecordTypeInfosByName().get(Constants.ADDITIONAL_APPLICATION).getRecordTypeId(); 
            
            if(recordTypeIds.size() > 0 && (appRecordIDs != null && appRecordIDs.contains(addAppRecordType))){
                Map<Id,Contact> addnExpnsConts  = new Map<Id,Contact>();
                addnExpnsConts  = getAdditionalExpnsAppln(addAppRecordType,studentRecordType); 
                
                if(awaitingContacts.size() > 0 && addnExpnsConts.size() > 0){
                    for(String s: addnExpnsConts.keySet()){
                        for(Contact c: awaitingContacts){
                            if(!addnExpnsConts.containsKey(s)){
                                awaitingContacts.add(addnExpnsConts.get(s));
                            }
                        }
                    } 
                }else{
                    return awaitingContacts;                    
                }                
            }else{                
                return awaitingContacts;
            }            
        }catch(Exception ex){           
            awaitingContacts    = new List<Contact>();           
        }       
        return awaitingContacts;
    }
    
    public static Map<Id,Contact> getAdditionalExpnsAppln(String addExpnsRecordTypeId, string studentRecordType){
        return new Map<Id,Contact>([Select id,Name,FFE_ID__c,ScholarshipAmount__c,toLabel(Internal_Status__c),MailingCity ,MailingState,
                    Full_Bank_Account_No_With_all_digits__c,Bank_Account_Holder_s_Name__c,X11_character_IFSC_Code_of_the_Branch__c,
                    Bank_Name__c,Branch_Address__c,Bank_City__c,
                    (select id,Name,Amount_Requested__c,Amount_Funded__c,RecordTypeId, RecordType.Name,IsMapped__c,
                     Student__c,toLabel(Internal_Status__c),Course__c,Year__c,Course_Name__c,Application_Stage__c,Remaining_Fund__c
                     from Applications__r where (Internal_Status__c =:Constants.AWAITING_FUND_STATUS OR Internal_Status__c =:Constants.AWAITING_FUND_STATUS_API) 
                     AND Application_Stage__c =:Constants.ACTIVE_APPLICATION AND RecordTypeId =: addExpnsRecordTypeId
                     AND RPT_Financial_Year__c =:currentFiscalYear)
                    from Contact where RecordTypeId =: studentRecordType
                    AND ID IN (Select Student__c from Application__c 
                                   where (Internal_Status__c =:Constants.AWAITING_FUND_STATUS OR Internal_Status__c =:Constants.AWAITING_FUND_STATUS_API) 
                     AND Application_Stage__c =:Constants.ACTIVE_APPLICATION AND RecordTypeId =: addExpnsRecordTypeId
                     AND RPT_Financial_Year__c =:currentFiscalYear)
                    order by Name]); 
    }

    @AuraEnabled()
    Public static string getDonorStudentMapping(string applicationId){
        System.debug('getDonorStudentMapping>>'+applicationId);
        return JSON.serializePretty(DN_FundAllocation_Helper.getDonorDetails(applicationId));
    }

    @AuraEnabled
    public static string getGAUWiseDonorBalance(string gauId,string donorCategorydata){
        try {
            return JSON.serializePretty(DN_FundAllocation_Helper.getGAUWiseBalance(gauId,donorCategorydata));            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled()
    Public static string disburseAllFund(FundDisburseWrapperLwc fundWrp){
        try{
            System.debug('fundWrp>>'+fundWrp);
            FundDisburseWrapper fundWrpNew = new FundDisburseWrapper();
            List<fundedAmtByGAU> fundedAmtByGAUWrap = new List<fundedAmtByGAU>();
            fundWrpNew.student = fundWrp.student;
            fundWrpNew.appln = fundWrp.appln;
            for(integer i=0;i<fundWrp.amtFunded.size();i++){
                fundedAmtByGAU newfundedAmtByGAU = new fundedAmtByGAU(); 
                newfundedAmtByGAU.donorbalance = fundWrp.amtFunded[i].donorbalance;
                fundedAmtByGAUWrap.add(newfundedAmtByGAU);
            }
            fundWrpNew.totalFundedAmt = fundWrp.totalFundedAmt;
            fundWrpNew.donorBalanceIds = fundWrp.donorBalanceIds;
            System.debug('fundWrpNew>>'+fundWrpNew);
            return DN_FundAllocation_Helper.doFundDisburment(fundWrpNew);
        }
        catch (Exception e){
            System.debug (e.getMessage()); 
   			System.debug(e.getCause());
            System.debug(e.getLineNumber());
        }
        return null; 
    }

    public class FundDisburseWrapperLwc{
        @AuraEnabled
        public Contact 					student {get;set;}
        @AuraEnabled
        public Application__c 			appln {get;set;}
        @AuraEnabled
        public List<fundedAmtByGAU> 	amtFunded {get;set;}
        @AuraEnabled
        public double 					totalFundedAmt {get;set;}
        @AuraEnabled
        public List<String> 			donorBalanceIds {get;set;}   

        public FundDisburseWrapperLwc(){
            this.student			= new Contact();
            this.appln				= new Application__c();
            this.amtFunded			= new List<fundedAmtByGAU>();
            this.donorBalanceIds	= new List<String>();
        }         
    
    }
    public class fundedAmtByGAU { 
        @AuraEnabled       
        public Donor_Balance__c	donorbalance {get;set;}
        @AuraEnabled
        public String 			extraFunds {get;set;}
        
        public fundedAmtByGAU(){
            this.donorbalance	= new Donor_Balance__c();
        }
                
    }  
}