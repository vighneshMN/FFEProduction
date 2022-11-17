/*
 * @purpose: This Class is used for Sign Up Page
 * @Author : Amritesh
 * @createdDate: 20/02/2017
*/ 
public class SignIn_CTRL {
    
    @RemoteAction
    Public static string generateLoginURL(String ffeId,String types){
        return Utility.temporaryDonorLoginURL(ffeId, null,types);
    }
    
    @RemoteAction
    Public static string generateLoginURLForEmail(String emailId,String types){
        return Utility.temporaryDonorLoginURL(null, emailId,types);
    }
}