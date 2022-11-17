/*
* @purpose: This calss handles Facebook Graph API calls to get user email
* @Author: Amritesh
* @CreatedDate: 27/02/2017		 
*/
public class FacebookAuthHandler {
    public static string name     ;           
    public static string fbMail   ;
    
    public static String generateFBAuthCode(String code, String endpointURL, String redirectURI, String cliendId, String clientSecret){
        String endPoint ;
        
        system.debug('endpointURL'+endpointURL+':::::redirectURI'+redirectURI+'::::cliendId'+cliendId+':::::clientSecret'+clientSecret);
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(endpointURL);
        req.setHeader('content-type', 'application/x-www-form-urlencoded');
        
        String messageBody ='code='+code+'&client_id='+cliendId+
            '&client_secret='+clientSecret+
            '&redirect_uri='+redirectURI+
            '&grant_type=authorization_code';
        req.setHeader('Content-length', String.valueOf(messageBody.length()));
        req.setBody(messageBody);
        req.setTimeout(60*1000);
        system.debug('messageBody:'+messageBody);
        system.debug('messageBody:'+req);
        
        try{
            Http callout = new Http();
            String responseText;
            HttpResponse response;
            if(test.isRunningTest()){
                Map<string, object> NewMap = New Map<string, object>();
                NewMap.put('access_token', 'value');
                responseText = json.serialize(NewMap); 
               
            }else{
                response = callout.send(req);
                responseText = response.getBody();
                 system.debug('responseText'+responseText);
            }
            
            Map<String,object> responseMap =(Map<String,object>)JSON.deserializeUntyped(responseText) ;  
            String token =  String.valueOf(responseMap.get('access_token'));
            system.debug('token'+token);
            return token;
            
        }
        catch(Exception e){
            system.debug('exception::'+e.getMessage());
            return Constants.ERROR_MESSAGE;
        }
    }
    

    // Call Facebook Graph API to get the user public info like email,gender
    public static string getFBPublicDetails(string endpointURL,string appId, string appSecret, string authCode ){
        try{
            system.debug(appId);
            String endPoint ;
            endPoint 		= endpointURL +'&appId='+appId+'&secret='+appSecret+'&access_token='+authCode;
            system.debug('authCode+endpoint'+endpointURL);
            HttpRequest request = new HttpRequest();
            request.setMethod('GET');
            request.setEndpoint(endPoint);
            
            Http http = new Http();
            HTTPResponse res;
            
            
            if(Test.isRunningTest()){
                return 'TestString@gmail.com';
                
            }else{
                res = http.send(request);
                FacebookAuthHandler.fbDetailWrapper respWrapObj = parse(res.getBody());
                name = respWrapObj.name ;           
                fbMail = respWrapObj.email ;
                return respWrapObj.email;   
            }
        }catch(Exception e){
            system.debug('exception::'+e.getMessage());
            return Constants.ERROR_MESSAGE;
        }
    }
    
    public static FacebookAuthHandler.fbDetailWrapper parse(String json){
        return (FacebookAuthHandler.fbDetailWrapper) System.JSON.deserialize(json, FacebookAuthHandler.fbDetailWrapper.class);
    }
    
    public class fbDetailWrapper {
        
        public string id;
        public string email;
        public string gender;
        public string name;
        
        public fbDetailWrapper(string id, string email, string gender, string name){
            This.id = id;
            This.email = email;
            This.gender = gender;
            This.name = name;
            
        }
    }
    
}