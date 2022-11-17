public class MentorAssociationTriggerHelper {
    
    public static Boolean runOnce =true;
    public static Boolean runOnceAfterUpdate =true;
    private static MentorAssociationTriggerHelper instance {get;set;}
    
    private MentorAssociationTriggerHelper(){}
    
    public static MentorAssociationTriggerHelper getInstance(){
        // lazy load the record type - only initialize if it doesn't already exist
        if(instance == null) instance = new MentorAssociationTriggerHelper();
        return instance;
    }

    public void updateMentoringHoursOnInsert (List<Mentor_Mentee_Association__c> newMap){
        system.debug('newMap----'+newMap);
        map<string, decimal> moduleMap = new map<string, decimal>();
        List<Program__c> allModuleData = [SELECT Hours_Required__c,Name FROM Program__c];
        system.debug('allModuleData'+allModuleData);
        set<id> mmaIds = new set<id>();
        for(Program__c pr : allModuleData ){
            if(pr.Hours_Required__c != null){
            	moduleMap.put(pr.Name,pr.Hours_Required__c);
            }
        }
        if(!newMap.isEmpty()){
            for(Mentor_Mentee_Association__c newMma : newMap){
                system.debug('newMma.Modules__c---'+newMma.Modules__c);
                if(newMma.Modules__c != null){
                    list<string> moduleArray = newMma.Modules__c.split(';');
                    decimal hours = 0;
                    for(string module:moduleArray){
                        system.debug('moduleMap.get(module)---'+moduleMap.get(module));
                        if(moduleMap.get(module) != null){
                        	hours += moduleMap.get(module);
                        }
                        system.debug('single hours----'+hours);
                    }
                    system.debug('Total hours----'+hours);
                    newMma.Total_Mentoring_Hours__c = hours;
                }
            }
        }
    }
    




    public void updateTotalHoursAtInsert(Map<Id, Mentor_Mentee_Association__c> newMmaMap , Map<Id, Mentor_Mentee_Association__c> oldMmaMap){
        Map<id, String> selectedModuleMap = new Map<id, String>();
        List<Mentor_Mentee_Association__c> listToBeUpdated = new List<Mentor_Mentee_Association__c>();
        
        map<string, decimal> moduleMap = new map<string, decimal>();
        List<Program__c> allModuleData = [SELECT Hours_Required__c,Name FROM Program__c];
        set<id> mmaIds = new set<id>();
        for(Program__c pr : allModuleData ){
            moduleMap.put(pr.Name,pr.Hours_Required__c);
        }
        system.debug('All module map data hour and name'+moduleMap);
        
        for(Mentor_Mentee_Association__c mm :newMmaMap.values()){
            if(mm.Modules__c != oldMmaMap.get(mm.Id).Modules__c){
            if((mm.Modules__c != null && oldMmaMap == null) || (mm.Modules__c != null && oldMmaMap.get(mm.Id).Modules__c != mm.Modules__c)){
                List<String> allThemodules = mm.Modules__c.split(';');
                
                System.debug('allThemodules'+allThemodules);
                decimal hour = 0;
                
                for(String individyalModule : allThemodules){
                    if(moduleMap.containsKey(individyalModule))
                        hour += moduleMap.get(individyalModule);
                }
                if(hour == 0){
                    Mentor_Mentee_Association__c mma = new Mentor_Mentee_Association__c(Id=mm.Id);
                    mma.Total_Mentoring_Hours__c = 0;
                    listToBeUpdated.add(mma);
                }
                else if(hour > 0){
                    Mentor_Mentee_Association__c mma = new Mentor_Mentee_Association__c(Id=mm.Id);
                    mma.Total_Mentoring_Hours__c = hour;
                    listToBeUpdated.add(mma);  
                }
            }
            else{
                decimal hour = 0;
                
                Mentor_Mentee_Association__c mma = new Mentor_Mentee_Association__c(Id=mm.Id);
                mma.Total_Mentoring_Hours__c = hour;
                listToBeUpdated.add(mma);  
            }
        }
        }
        
        update listToBeUpdated; 
    }
    public void updateMentorLoad(Map<Id, Mentor_Mentee_Association__c> newMap , Map<Id, Mentor_Mentee_Association__c> oldMap){
        system.debug('inside TRIGGER----------------');
        system.debug('inside newMap----'+newMap);
        if(!newMap.isEmpty()){
            
            set<string> conIdSet = New set<string> ();
            for(Mentor_Mentee_Association__c newAssociation:newMap.values()){
                system.debug('inside FOR loop');
                if(newAssociation.Id == oldMap.get(newAssociation.Id).Id){
                    system.debug('oldmap == newMap');
                    system.debug('newAssociation.Mentor__c --'+newAssociation.Mentor__c +'----oldMap.get(newAssociation.Id).Mentor__c----'+oldMap.get(newAssociation.Id).Mentor__c);
                if(newAssociation.Mentor__c != null && oldMap.get(newAssociation.Id).Mentor__c == null){ 
                        conIdSet.add(newAssociation.Mentor__c);
                    }
            }
        }
        list<contact> conList = New list<contact>();
        system.debug('conIdSet--------'+conIdSet);
        if(!conIdSet.isEmpty()){
            conList = [SELECT name,id,(select name,id from Mentor_Mentee_Associations1__r) FROM Contact where Id IN :conIdSet];
        }
        system.debug('conList----'+conList);
        if(!conList.isEmpty()){
            for(contact con:conList){
                con.Mentor_load__c = con.Mentor_Mentee_Associations1__r.size();
            }
            update conList;
        }
    }
}

    public void getMentorNameOnStudentProfile(Map<Id, Mentor_Mentee_Association__c> newMap , Map<Id, Mentor_Mentee_Association__c> oldMap){
        map<string,string> mentorInfo = new Map<string,string>();
        list<contact> conListToUpdate = New list<contact>();
        for(Mentor_Mentee_Association__c mm :newMap.values()){
            system.debug('mm.Mentor__r.Name----'+mm.Mentor__r.Name);
            system.debug('mm.Mentor__r.Name----'+mm.Mentor__c);
            if((mm.Mentor__c != null) && (oldMap.get(mm.Id).Mentor__c != mm.Mentor__c)){
                system.debug('mm.Mentor__r.Name----'+mm.Mentor__r.Name);
                system.debug('mm.Mentor__r.Name----'+mm.Mentor__c);
                conListToUpdate.add(New contact(id=mm.mentee_del__c,Mentor_Name_Mentee__c=mm.Mentor_Name__c,Mentor_Corporate_mentee__c=mm.Mentor_Corporate__c));
        }
    }
        if(conListToUpdate.size() > 0)
            update conListToUpdate;
        runOnceAfterUpdate =false;
}
}