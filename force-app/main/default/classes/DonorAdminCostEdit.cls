/*
* @ purpose : To Transfer Fund/Amount from one DonorBalance(source) to Another DonorBalance(destination).
* @ if Destion DonorBalance is present then updates the record by adding amount to current balance
* @ else creates a new Destination DonorBalance.
*/ 
public class DonorAdminCostEdit {
    
    public Donor_Balance__c dbBalance        {get;set;}
    public Donor_Balance__c dbBalancereduce  {get;set;}
    public String gauName                    {get;set;}
    public Donor_Balance__c donorBalance     = new Donor_Balance__c();
    public String desDonorName               = '';
    public String desGAUName                 = '';
    Public String desDonorBalanceId          = '';
    public boolean isDisplay                 {get;set;}
    public string donorBalanceId            {get; set;}
    //public Expense__c expenses 				{get; set;}
    
    public DonorAdminCostEdit(Apexpages.StandardController stdCon){    
        dbBalance = new Donor_Balance__c();
        dbBalancereduce =  new Donor_Balance__c();
        isDisplay = true;
        if(stdCon!=null){
            donorBalance    = [SELECT id,name,GAU_Name__r.Business_Account__r.Name,Current_Balance__c,GAU_Name__c,Donor_Name__c,Donor_Name__r.Name,GAU_Name__r.Name from Donor_Balance__c where id=:((Donor_Balance__c)stdCon.getRecord()).Id LIMIT 1];
            donorBalanceId  = donorBalance.Id;
            system.debug('@@ '+donorBalance.GAU_Name__r.Name);
            gauName         = String.valueOf(donorBalance.GAU_Name__r.Name);
            system.debug('@@ '+gauName);
            Id profileId = UserInfo.getProfileId();
            String profileName =[Select Id, Name from Profile where Id=:profileId].Name;
            system.debug('Profile Name'+profileName);
            if(profileName != 'System Administrator' && profileName != 'Account Team' && profileName != 'Accounts Team (Data Manage)'){
                ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,'This edit is only for System Administrator and Account Team Users'));
                isDisplay = false;
            }
            // metaData(Allowed_Expense__mdt)
            List<Allowed_Expense__mdt> allowedExpenseList = [SELECT GAU_Name__c FROM Allowed_Expense__mdt where GAU_Name__c =: gauName];
          /*  boolean matched = false;
            for(Allowed_Expense__mdt allowedExpenseRec : allowedExpenseList){
				if(allowedExpenseRec.GAU_Name__c == gauName){
					matched = true;
            	}
			}
            if(matched){
            }
            else{
                ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,'Allowed only for Offline Donation Admin Cost GAU'));
                isDisplay = false;
            } 
            
            */
            if(allowedExpenseList.size() > 0){
           
            }else{
                ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,'Allowed only for Offline Donation Admin Cost GAU'));
                isDisplay = false;
            }
            
            //if(gauName.containsIgnoreCase('Offline')){
            /*if((gauName == 'Offline Donation Admin Cost (598)')||(gauName == 'Offline Donation Admin Cost (723)')){
			}else{
				ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,'Allowed only for Offline Donation Admin Cost GAU'));
				isDisplay = false;
			}*/
        } 
    }    
    
    public void donorAdminCostEditDetails(){
        try{
            Expense__c expense = new Expense__c();
            if(dbBalance.Current_Balance__c > 0){
                expense.Funds_Added__c = dbBalance.Current_Balance__c ;
                donorBalance.Current_Balance__c = donorBalance.Current_Balance__c + dbBalance.Current_Balance__c;
            }
            update donorBalance;
            if(dbBalancereduce.Current_Balance__c > 0){
                expense.Funds_Deducted__c = dbBalancereduce.Current_Balance__c;
                donorBalance.Current_Balance__c = donorBalance.Current_Balance__c - dbBalancereduce.Current_Balance__c;
            }
            expense.Comments__c = dbBalance.Short_Comments__c;
            donorBalance.Short_Comments__c = dbBalance.Short_Comments__c;
            expense.Donor_Balance__c = donorBalance.Id;
            update donorBalance;
            insert expense;
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,'Funds has been successfully updated'));
            isDisplay = false;
            //
        }catch(Exception ex){
            HandleBusinessException.captureError('DonorAdminCostEdit', 'destinationDonorDetails', ex);
        }
    }
}