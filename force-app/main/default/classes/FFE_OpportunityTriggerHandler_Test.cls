@isTest
public class FFE_OpportunityTriggerHandler_Test
{
    static testmethod void test1()
    {
        List<Contact> conList = new  List<Contact>();
        Contact Con = new  Contact();
        Con.FirstName = 'Test';
        Con.LastName = 'Demo ' + '\n';
        Con.email = 'test@test.com';
        Con.X11_character_IFSC_Code_of_the_Branch__c = 'asdsaddsadasda';
        Con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Donor').getRecordTypeId();
        conList.add(con);
        Insert conList;
        System.assertNotEquals(conList[0].Id, null);
		
        Payment_Order__c paymentOrder = New Payment_Order__c();
        paymentOrder.Order_No__c = 'DN16324636295644539433139';
        paymentOrder.Transaction_ID__c = '345273321632463629566';
        paymentOrder.Order_Amount__c = 20000;
        paymentOrder.Transaction_Date__c = date.today();
        paymentOrder.Donor__c = Con.Id;
        insert paymentOrder;
        
        Opportunity objOpp = new Opportunity();
        objOpp.Name = 'test2';
        objOpp.npsp__Primary_Contact__c = con.Id;
        objOpp.StageName = 'Posted';
        objOpp.CloseDate = date.today();
        objOpp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Donation').getRecordTypeId();
        objOpp.Payment_Order__c = paymentOrder.Id;
        Insert objOpp;
        System.assertNotEquals(objOpp.Id, null);

        Test.startTest();
        Opportunity objOpp1 = new Opportunity();
        objOpp1.Name = 'test1';
        objOpp1.StageName = 'Pledged';
        objOpp1.amount = 2000;
        objOpp1.CloseDate = date.today();
        objOpp1.npsp__Primary_Contact__c = con.Id;
        objOpp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Donation').getRecordTypeId();
        objOpp1.Payment_Order__c = paymentOrder.Id;
        Insert objOpp1;
        System.assertNotEquals(objOpp1.Id, null);
        
       Opportunity objOpp2 = new Opportunity();
        objOpp2.Name = 'test2';
        objOpp2.npsp__Primary_Contact__c = con.Id;
        objOpp2.StageName = 'Pledged';
        objOpp2.CloseDate = date.today();
        objOpp2.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Donation').getRecordTypeId();
        objOpp2.Payment_Order__c = paymentOrder.Id;
        Insert objOpp2;
        
        Opportunity oppToupdate = [select name,Id,StageName from opportunity where Id =:objOpp2.Id limit 1];
        oppToupdate.StageName = 'Posted';
        update oppToupdate;
        
        Opportunity oppToDelete = [select name,Id,StageName from opportunity where Id =:objOpp2.Id limit 1];
        delete oppToDelete;
        
        Test.stopTest();
    }
}