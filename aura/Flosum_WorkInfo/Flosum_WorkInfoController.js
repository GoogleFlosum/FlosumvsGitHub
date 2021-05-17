({
    doInit : function(component, event, helper) {

        var action = component.get("c.getWorkDetails");
        var recordIdVal = component.get("v.recordId");
        action.setParams({branchId:recordIdVal});
        action.setCallback(this, function(a){
            var rtnValue = a.getReturnValue();
            if (rtnValue !== null) {
                console.log(rtnValue);
                var result = JSON.parse(rtnValue);
                if(result.done && result.records != undefined && result.records.length > 0){
                    component.set("v.rec",result.records[0]);
                }
            }
        });
        $A.enqueueAction(action);
    },
    linkWorkRecord : function(component, event, helper) {

        var recordIdVal = component.get("v.recordId");
        
        var compName = 'c:Flosum_LinkBranchWithWork';
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : compName,
            componentAttributes: {
                recordId : recordIdVal
            }
        });
        evt.fire();
    }
})