({
    doInit: function(component, event, helper) {
        var action = component.get("c.getPiklistValues");
        action.setParams({  "appId" : component.get("v.recordId")  });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                var plValues = [];
                for (var i = 0; i < result.length; i++) {
                    plValues.push({
                        label: result[i],
                        value: result[i]
                    });
                }
                component.set("v.DocumentList", plValues);
            }
        });
        $A.enqueueAction(action);
    },     
    handleDocumentChange: function (component, event, helper) {
        //Get the Selected values   
        var selectedValues = event.getParam("value");
         
        //Update the Selected Values  
        component.set("v.selectedDocumentList", selectedValues);
    },         
    getSelectedDocument : function(component, event, helper){
        var selectedValues = component.get("v.selectedDocumentList");
        var remarks = component.find("remarks").get("v.value");
        
        var action = component.get("c.doStuff");
        action.setParams({  "docList" : selectedValues,"content":remarks,"appId" : component.get("v.recordId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                if(result==0)
                {
                $A.get("e.force:closeQuickAction").fire();    
                alert('Action Not Valid');
                }
                else
                {
                  $A.get("e.force:closeQuickAction").fire();                    
                 alert('Email Sent Successfully to the Student.'); 
                }
                }
    });
          $A.enqueueAction(action);
    }
})