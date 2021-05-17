({
    doInit : function(component, event, helper) {
        component.set("v.message",'');
        var action = component.get("c.getWorkList");
        var recordIdVal = component.get("v.recordId");
        console.log('recordIdVal--'+recordIdVal);
        action.setParams({
            branchId:recordIdVal,
            searchText:''
        });
        
        action.setCallback(this, function(a){

            var state = a.getState();
            console.log('state--'+state);
            if (state === "SUCCESS") {
                var rtnValue = a.getReturnValue();
                if (rtnValue !== null) {
                    var result = JSON.parse(rtnValue);
                    if(result.done && result.records != undefined && result.records.length > 0){
                        component.set("v.recList",result.records);
                        component.set("v.messageType",'info');
                        component.set("v.message",'Please select a work record to link with branch.');
                    }
                    else{
                        component.set("v.messageType",'info');
                        component.set("v.message",'No records found.');
                    }
                }
            }
            else if (state === "ERROR") {
                let errors = a.getError();
                let message = 'Unknown error'; // Default error message
                // Retrieve the error message sent by the server
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                // Display the message
                console.log(message);
                component.set("v.messageType",'error');
                component.set("v.message",message);
            }
        });
        $A.enqueueAction(action);
    },
    saveWork : function(component, event, helper) {
        component.set("v.message",'');

        var recordIdVal = component.get("v.recordId");
        var res = document.querySelector('input[name="workOptions"]:checked');
        if(res != undefined && res.value != undefined){
            var workId = res.value;
            console.log('recordIdVal--'+recordIdVal);
            console.log('workId-------'+workId);
            var action = component.get("c.updateBranch");
            action.setParams({
                branchId:recordIdVal,
                workId:workId
            });
            action.setCallback(this, function(a){

                var state = a.getState();
                console.log('state--'+state);
                if (state === "SUCCESS") {
                    var rtnValue = a.getReturnValue();
                    console.log(rtnValue);
                    if(rtnValue == 'done'){
                        component.set("v.messageType",'success');
                        component.set("v.message",'Saved Successfully.');
                        try{
                            var navEvt = $A.get("e.force:navigateToSObject");
                            navEvt.setParams({
                                "recordId": recordIdVal,
                                "slideDevName": "Detail"
                            });
                            navEvt.fire();
                        }
                        catch(e){
                            console.log(e);
                            window.location.href = '/' + recordIdVal;
                        }
                    }
                    else{
                        
                    }
                }
                else if (state === "ERROR") {
                    let errors = a.getError();
                    let message = 'Unknown error'; // Default error message
                    // Retrieve the error message sent by the server
                    if (errors && Array.isArray(errors) && errors.length > 0) {
                        message = errors[0].message;
                    }
                    // Display the message
                    console.log(message);
                    component.set("v.messageType",'error');
                    component.set("v.message",message);
                }
            });
            $A.enqueueAction(action);
        }
    },
    searchWithText : function(component, event, helper) {
        var sTxt = component.get("v.searchText");
        var recordIdVal = component.get("v.recordId");
        console.log('sTxt--'+sTxt);
        console.log(typeof sTxt);
        console.log('recordIdVal--'+recordIdVal);
        component.set("v.message",'');
        component.set("v.recList",[]);
        var action = component.get("c.getWorkList");
        action.setParams({
            branchId:recordIdVal,
            searchText:sTxt
        });
        
        action.setCallback(this, function(a){

            var state = a.getState();
            console.log('state--'+state);
            if (state === "SUCCESS") {
                var rtnValue = a.getReturnValue();
                console.log(rtnValue);
                if (rtnValue !== null) {
                    var result = JSON.parse(rtnValue);
                    if(result.done && result.records != undefined && result.records.length > 0){
                        component.set("v.recList",result.records);
                        component.set("v.messageType",'info');
                        component.set("v.message",'Please select a work record to link with branch.');
                    }
                    else{
                        component.set("v.messageType",'info');
                        component.set("v.message",'No records found.');
                    }
                }
            }
            else if (state === "ERROR") {
                let errors = a.getError();
                let message = 'Unknown error'; // Default error message
                // Retrieve the error message sent by the server
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                // Display the message
                console.log(message);
                component.set("v.messageType",'error');
                component.set("v.message",message);
            }
        });
        $A.enqueueAction(action);
    }
})