@isTest
public class DecryptHashValue_Test {
    @isTest
   public static void testDecodeString(){
        string hashVal = '1234';
        test.startTest();
        DecryptHashValue_CTLR a = new DecryptHashValue_CTLR();
        a.hashValue = '';
        a.decodeString();
        String decodevalue =FFE_KYC_Verification.generateHashCode('abcd4356');
        a.hashValue = decodevalue;
        a.decodeString();
        DecryptHashValue_CTLR.getDecodeStringLwc(decodevalue);
        DecryptHashValue_CTLR.getDecodeStringLwc(hashVal);
        test.stopTest();
    }

}