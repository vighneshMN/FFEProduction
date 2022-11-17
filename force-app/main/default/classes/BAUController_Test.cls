@isTest
public class BAUController_Test {
    @isTest
    static void testMethod1(){
        Contact student = Utility_Test.insertSingleStudent('jayanth','b');   
        insert student;    
            
		Application__c app = new Application__c(Student__c=student.id,Amount_Requested__c=10000);
        insert app;
            
        Business_Account_Utilization__c bau = new Business_Account_Utilization__c(Application__c=app.id); 
        insert bau;
        
        List<Business_Account_Utilization__c> bauList = new List<Business_Account_Utilization__c>();
        bauList.add(bau);
        
        test.startTest();
       ApexPages.StandardSetController controller =  new ApexPages.StandardSetController(bauList);
        BAUController cntrlr = new BAUController(controller);
        
        
        test.stopTest();
    }

}