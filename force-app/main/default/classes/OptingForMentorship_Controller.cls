public withOut sharing class OptingForMentorship_Controller {


    @RemoteAction
    public static string optingForMentorship(string MentorId) {
        if(!String.isBlank(MentorId)){
            List<contact> mentorDetils = [select name,id,Is_Mentor__c,Opting_for_mentorship__c from contact where id=:MentorId];
            if(mentorDetils.size() > 0){
                if(mentorDetils[0].Is_Mentor__c){
                    mentorDetils[0].Opting_for_mentorship__c = true;
                    update mentorDetils[0];
                    return 'success';
                }
            }
        }
        return null;
    }
}