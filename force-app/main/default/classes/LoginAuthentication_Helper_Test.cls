@isTest
public class LoginAuthentication_Helper_Test {
    
    @TestSetup
    static void insertAPICustomSettings(){
        Google_API_Details__c googleApi	= new Google_API_Details__c(Application_Redirect_URL__c='www.test123.com',
                                                                   Auth_Endpoint_URL__c='www.test.com',Client_Id__c='gtest12345',
                                                                   Client_Secret__c='gSecret12345',Redirect_URI__c='www.test123.com',
                                                                   Endpoint_URL__c='www.123Test.com');
        insert googleApi;
        
        Facebook_API_Details__c fbApi	= new Facebook_API_Details__c(Application_Redirect_URL__c='www.test123.com',
                                                                   Auth_Endpoint_URL__c='www.test.com',App_Id__c='ftest12345',
                                                                   App_Secret__c='fSecret12345',Redirect_URL__c='www.test123.com',
                                                                   Endpoint_URL__c='www.123Test.com');
        insert fbApi;
    }
    
    public static testmethod void mailAndApproval(){
        
        test.startTest();
        User auser = Utility_Test.createUser('ZXYSpoo099@gmail.com');
        System.runAs(auser){
            LoginAuthentication_Helper.getGoogleAuthCode('XJDHFVNJ', 'Donor');//for if block
           // LoginAuthentication_Helper.getGoogleAuthCode('XJDHFVNJ', null);//for else block
            LoginAuthentication_Helper.getGoogleEmail('AUTHCODE1111');
            LoginAuthentication_Helper.getFBAuthCode('XJDHFVNJ', 'Donor');//for if block
            LoginAuthentication_Helper.getFBAuthCode('XJDHFVNJ', 'null');//for else block
            LoginAuthentication_Helper.getFacebookEmail('AUTHCODE2222');
           // LoginAuthentication_Helper.getinstaEmail('AUTHCODE2222');
        }
        test.stopTest();
    }
}