({
	refreshView : function(component, event, helper) {
		console.log('Event record change caught');
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
        $A.get('e.force:refreshView').fire();
	}
})