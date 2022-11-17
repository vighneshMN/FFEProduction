public class FFE_OpportunityTriggerHandler
{
    static Id ID_opportunityDonationRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Donation').getRecordTypeId();
    //@Future
    /*public static void updateDonationType(List<Id> listOpportunityIds)
    {
        List<Opportunity> listNewOpportunities = [SELECT
            Id, 
            RecordTypeId, 
            npsp__Primary_Contact__c, 
            createdDate
        FROM
            Opportunity
        WHERE
            Id in: listOpportunityIds];
        Map<Id, Set<string>> mapDonorAndDonationYears = new  Map<Id, Set<string>>();
        Set<Id> setDonorIds = new  Set<Id>();
        for(Opportunity objOpp: listNewOpportunities)
        {
            if(objOpp.recordTypeId == ID_opportunityDonationRecordType)
            {
                setDonorIds.add(objOpp.npsp__Primary_Contact__c);
            }
        }
        Integer year = Date.today().year();
        if(Test.isRunningTest())
        {
            year = year + 1;
        }
        List<Opportunity> listExistingDonations = [SELECT
            Id, 
            npsp__Primary_Contact__c, 
            createdDate, 
            RecordTypeId
        FROM
            Opportunity
        WHERE
            recordTypeId = : ID_opportunityDonationRecordType AND npsp__Primary_Contact__c in: setDonorIds AND Id not in: TRIGGER.NEW AND CALENDAR_YEAR(CreatedDate) <: year];
        for(Opportunity objOpp: listExistingDonations)
        {
            if(!listOpportunityIds.contains(objOpp.Id))
            {
                if(mapDonorAndDonationYears != null && mapDonorAndDonationYears.get(objOpp.npsp__Primary_Contact__c) != null)
                {
                    Set<string> setYears = mapDonorAndDonationYears.get(objOpp.npsp__Primary_Contact__c);
                    string strCreatedDate = string.valueOf(objOpp.createdDate);
                    strCreatedDate = strCreatedDate.subString(0, 4);
                    setYears.add(strCreatedDate);
                    mapDonorAndDonationYears.put(objOpp.npsp__Primary_Contact__c, setYears);
                }
                else
                {
                    Set<string> setYears = new  Set<string>();
                    string strCreatedDate = string.valueOf(objOpp.createdDate);
                    strCreatedDate = strCreatedDate.subString(0, 4);
                    setYears.add(strCreatedDate);
                    mapDonorAndDonationYears.put(objOpp.npsp__Primary_Contact__c, setYears);
                }
            }
        }
        List<Opportunity> listOppToUpdate = new  List<Opportunity>();
        for(Opportunity objOpp: listNewOpportunities)
        {
            if(objOpp.recordTypeId == ID_opportunityDonationRecordType)
            {
                string strCreatedDate = string.valueOf(objOpp.createdDate);
                strCreatedDate = strCreatedDate.subString(0, 4);
                // if(mapDonorAndDonationYears != null && mapDonorAndDonationYears.get(objOpp.npsp__Primary_Contact__c) != null && mapDonorAndDonationYears.get(objOpp.npsp__Primary_Contact__c).contains(strCreatedDate))
                if(mapDonorAndDonationYears != null && mapDonorAndDonationYears.get(objOpp.npsp__Primary_Contact__c) != null)
                {
                    objOpp.Type = 'Existing Funding';
                }
                else
                {
                    objOpp.Type = 'New Funding';
                }
                listOppToUpdate.add(objOpp);
            }
        }
        if(listOppToUpdate != null && listOppToUpdate.size() > 0)
        {
            Update listOppToUpdate;
        }
    }*/


    public static void updateDonationType(List<Id> listOpportunityIds)
    {
        system.debug('listOpportunityIds---'+listOpportunityIds);
        Set<Id> setDonorIds = new  Set<Id>();
        Set<Opportunity> listOppToUpdate = new  Set<Opportunity>();
        List<Opportunity> listNewOpportunities = [SELECT
            Id, 
            RecordTypeId, 
            npsp__Primary_Contact__c, 
            createdDate, 
            Actual_FY__c
        FROM
            Opportunity
        WHERE
            Id in: listOpportunityIds AND recordTypeId = : ID_opportunityDonationRecordType ];
		system.debug('listNewOpportunities-----'+listNewOpportunities);
        system.debug('listNewOpportunities.size---'+listNewOpportunities.size());
        Map<Id, Set<string>> mapDonorAndFinancialYears = new  Map<Id, Set<string>>();

        for(Opportunity objNewOpp: listNewOpportunities)
        {
            setDonorIds.add(objNewOpp.npsp__Primary_Contact__c);
        }
        system.debug('setDonorIds---'+setDonorIds);
        List<Opportunity> listExistingDonations = [SELECT
            Id, 
            npsp__Primary_Contact__c, 
            createdDate, 
            RecordTypeId, 
            Actual_FY__c
        FROM
            Opportunity
        WHERE
            recordTypeId = : ID_opportunityDonationRecordType AND npsp__Primary_Contact__c in: setDonorIds AND Id NOT IN: listOpportunityIds AND StageName = 'Posted' ];
        system.debug('listExistingDonations---'+listExistingDonations);
        system.debug('listExistingDonations.size-----'+listExistingDonations.size());
        for(Opportunity objExisOpp: listExistingDonations)
        {
            if(mapDonorAndFinancialYears != null && mapDonorAndFinancialYears.get(objExisOpp.npsp__Primary_Contact__c) != null)
            {
                system.debug('inside mapDonorAndFinancialYears != null '+objExisOpp.Actual_FY__c);
                Set<string> setYears = mapDonorAndFinancialYears.get(objExisOpp.npsp__Primary_Contact__c);
                setYears.add(String.valueOf(objExisOpp.Actual_FY__c));
                mapDonorAndFinancialYears.put(objExisOpp.npsp__Primary_Contact__c, setYears);
            }
            else
            {
                system.debug('inside mapDonorAndFinancialYears = null '+objExisOpp.Actual_FY__c);
                Set<string> setYears = new  Set<string>();
                setYears.add(String.valueOf(objExisOpp.Actual_FY__c));
                mapDonorAndFinancialYears.put(objExisOpp.npsp__Primary_Contact__c, setYears);
            }
        }
            for(Opportunity objNewOpp: listNewOpportunities)
            {
                objNewOpp.Type = 'New Funding';
                system.debug('mapDonorAndFinancialYears-----'+mapDonorAndFinancialYears);
                if(mapDonorAndFinancialYears != null && mapDonorAndFinancialYears.get(objNewOpp.npsp__Primary_Contact__c) != null)
                {
                    Set<string> setYears = mapDonorAndFinancialYears.get(objNewOpp.npsp__Primary_Contact__c);
                    system.debug('setYears-----'+setYears);
                    for(string financialYear: setYears)
                    {
                        system.debug('objNewOpp.Actual_FY__c---'+objNewOpp.Actual_FY__c+'--!=--'+financialYear+'----financialYear');
                        if(String.valueOf(objNewOpp.Actual_FY__c) != financialYear)
                        {
                            objNewOpp.Type = 'Existing Funding';
                            break;
                        }
                    }
                }
                listOppToUpdate.add(objNewOpp);
            }
            
        
        if(listOppToUpdate != null && listOppToUpdate.size() > 0)
            {
                List<Opportunity> listOppToUpdate_n = new List<Opportunity>(listOppToUpdate);

                Update listOppToUpdate_n;
            }
    }
    public static void updatePaymentOrderDonationStage(List<Id> listPaymentOrderIds)
    {
        List<Payment_Order__c> listPaymentOrder = [SELECT
            Id, 
            Donation_Stage__c
        FROM
            Payment_Order__c
        WHERE
            Id in: listPaymentOrderIds];
        for(Payment_Order__c objPaymentOrder: listPaymentOrder)
        {
            objPaymentOrder.Donation_Stage__c = 'Posted';
        }
        if(listPaymentOrder != null && listPaymentOrder.size() > 0)
        {
            Update listPaymentOrder;
        }
    }
    
    public static void updateTotalDonations(Map<Id, opportunity> newMap , Map<Id, opportunity> oldMap){
        system.debug('updateTotalDonations---newMap--'+newMap+'---oldMap--'+oldMap);
        set<string> contactIdSet = New set<string>();
        if(Trigger.isAfter && Trigger.isUpdate){
            for(opportunity opp:newMap.values()){
                if((oldMap.get(opp.Id).StageName != opp.StageName) && opp.StageName == 'Posted'){
                    contactIdSet.add(opp.npsp__Primary_Contact__c);
                }
            }
        system.debug('contactIdSet---'+contactIdSet);
            list<contact> conListToUpdate = New List<contact>();
            list<contact> conList = [select name,id,Lifetime_Donations__c,Lifetime_Donation_Amount__c,(select name,id,StageName,Amount from opportunities) from contact where id IN:contactIdSet];
            integer oppAmount;
            integer oppCount;
            for(contact con:conList){
                oppAmount = 0;
                oppCount = 0;
                if(con.opportunities != null){
                    for(opportunity opp:con.opportunities){
                        if(opp.StageName == 'Posted'){
                            if(opp.Amount != null){
                                oppAmount += Integer.valueOf(opp.Amount); 
                            }
                             
                            oppCount++;
                        }
                    }
                    con.Lifetime_Donation_Amount__c = oppAmount;
                    con.Lifetime_Donations__c = oppCount;
                    conListToUpdate.add(con);
                }
            }
            if(conListToUpdate.size() >0)
                update conListToUpdate;
        }
    }
  public static void updateTotalDonationsAfterDelete(List<opportunity> newList , Map<Id, opportunity> oldMap){
      system.debug('newList---'+newList+'----oldMap---'+oldMap);
      List<string> donorList = New List<string>();
      for(opportunity opp:oldMap.values()){
          if(opp.stageName == 'Posted'){
              donorList.add(opp.npsp__Primary_Contact__c);
          }
      }
          if(donorList.size() > 0){
               list<contact> conListToUpdate = New List<contact>();
            list<contact> conList = [select name,id,Lifetime_Donations__c,Lifetime_Donation_Amount__c,(select name,id,StageName,Amount from opportunities) from contact where id IN:donorList];
            integer oppAmount;
            integer oppCount;
            for(contact con:conList){
                oppAmount = 0;
                oppCount = 0;
                if(con.opportunities != null){
                    for(opportunity opp:con.opportunities){
                        if(opp.StageName == 'Posted'){
                            if(opp.Amount != null){
                              oppAmount += Integer.valueOf(opp.Amount);    
                            }
                            oppCount++;
                        }
                    }
                    con.Lifetime_Donation_Amount__c = oppAmount;
                    con.Lifetime_Donations__c = oppCount;
                    conListToUpdate.add(con);
                }
            }
              if(conListToUpdate.size() >0)
                  update conListToUpdate; 
          }
     
  }
    
}