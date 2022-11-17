public class DecryptHashValue_CTLR {

    public string hashValue {get;set;}
    public string decrytedValue {get;set;}
    public string encrytedValue {get;set;}
    public boolean showResult {get;set;}
    public static string hashValToConvert {get;set;}
    public static string decrytedVal {get;set;}
    public static string encrytedVal {get;set;}
    
    
    public void decodeString(){
        try{
            if(!String.IsBlank(hashValue)){
                encrytedValue=hashValue;
                String keyValue='9876543210123456';
                Blob key = Blob.valueOf(keyValue);
                Blob blobData = EncodingUtil.base64Decode(hashValue);     
                Blob decryptedBlob = Crypto.decryptWithManagedIV('AES128', key, blobData);      
                decrytedValue=decryptedBlob.toString(); 
                hashValue='';
                
                showResult=true;
            }
            else{
                encrytedValue='';
                decrytedValue='';
                showResult=false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter hash value'));
            }
        }catch(exception e){
            encrytedValue='';
            decrytedValue='';
            showResult=false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, string.valueof(e)));
        }
    }
    
    @AuraEnabled 
    public static List<String> getDecodeStringLwc(string hashVal){
        List<String> decryptedValues  = new List<String>();
        String returnString ='';
        try{
            if(!String.IsBlank(hashVal)){
                encrytedVal=hashVal;
                String keyValue='9876543210123456';
                Blob key = Blob.valueOf(keyValue);
                Blob blobData = EncodingUtil.base64Decode(hashVal);                 
                Blob decryptedBlob = Crypto.decryptWithManagedIV('AES128', key, blobData);      
                decrytedVal=decryptedBlob.toString(); 
                hashVal='';
            }
        }catch(exception e){
            encrytedVal='';
            decrytedVal='';
            system.debug('exptn');
            returnString = string.valueof(e);
            decryptedValues.add('false');
            decryptedValues.add(returnString);
            return decryptedValues;
        }
        decryptedValues.add('true');
        decryptedValues.add(decrytedVal);
        return decryptedValues;
    }
}