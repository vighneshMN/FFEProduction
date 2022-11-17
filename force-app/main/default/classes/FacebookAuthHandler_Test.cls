@isTest
public class FacebookAuthHandler_Test {
    
    @isTest public static void generateFBAuthCodeTest(){
        FacebookAuthHandler.generateFBAuthCode('','','','','');
        FacebookAuthHandler.getFBPublicDetails('endpointURL', 'appId', 'appSecret', 'authCode');
        FacebookAuthHandler.getFBPublicDetails(null, null, null, null);        
        FacebookAuthHandler.fbDetailWrapper fbWrapper = new FacebookAuthHandler.fbDetailWrapper('abc','bcd','cdf','def');
        FacebookAuthHandler.parse(json.serialize(fbWrapper));
    }

}