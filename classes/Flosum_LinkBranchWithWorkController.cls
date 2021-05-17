public with sharing class Flosum_LinkBranchWithWorkController {
    
    @AuraEnabled
    public static String updateBranch(String branchId, String workId){
        List<Flosum__Branch__c> branhLi = [SELECT Id,Flosum__External_Work_ID__c FROM Flosum__Branch__c WHERE Id=:branchId LIMIT 1];
        if(branhLi.size() == 1){
            branhLi[0].Flosum__External_Work_ID__c = workId;
            update branhLi;
            return 'done';
        }
        return '';
    }

    @AuraEnabled
    public static String getWorkList(String branchId, String searchText){
        List<Flosum__Branch__c> branhLi = [SELECT Id,Flosum__External_Work_ID__c FROM Flosum__Branch__c WHERE Id=:branchId LIMIT 1];
        if(branhLi.size() == 1){
            //branhLi[0].Flosum__External_Work_ID__c
            Flosum__Agile_Org__c agO = (Flosum__Agile_Org__c.getOrgDefaults() != null && Flosum__Agile_Org__c.getOrgDefaults().id != null) ? Flosum__Agile_Org__c.getOrgDefaults() : new Flosum__Agile_Org__c();
            if(agO != null && agO.Flosum__Org_Id__c != null){
                Flosum.FlosumUtils utils = new Flosum.FlosumUtils();
                Flosum.FlosumUtils.AuthenticateDetails authDetails = utils.authenticateAnOrg(agO.Flosum__Org_Id__c);
                if(Test.isRunningTest()){
                    authDetails = new Flosum.FlosumUtils.AuthenticateDetails();
                    authDetails.isSuccess = true;
                    authDetails.details = new Flosum__AuthorizationDetails__c(Flosum__InstanceURL__c='https://login.salesforce.com',Flosum__AccessToken__c='test');
                }
                if(authDetails != null && authDetails.isSuccess){
                    String query;
                    if(searchText == null || searchText == ''){
                        query = 'SELECT Id,Name,agf__Assignee__r.Name,agf__Epic_Name__c,agf__Subject__c,agf__Product_Tag_Name__c,RecordType.Name,agf__Details__c FROM agf__ADM_Work__c ORDER BY CreatedDate DESC LIMIT 1000';
                    }
                    else{
                        String likeText = '\'%'+String.escapeSingleQuotes(searchText)+'%\'';
                        query = 'SELECT Id,Name,agf__Assignee__r.Name,agf__Epic_Name__c,agf__Subject__c,agf__Product_Tag_Name__c,RecordType.Name,agf__Details__c FROM agf__ADM_Work__c WHERE (Name LIKE '+likeText+' OR agf__Subject__c LIKE '+likeText+' OR agf__Epic_Name__c LIKE '+likeText+') ORDER BY CreatedDate DESC LIMIT 1000';
                    }
                    String endpoint = authDetails.details.Flosum__InstanceURL__c + '/services/data/v48.0/query/?q=' + EncodingUtil.urlEncode(query, 'UTF-8');
                    
                    HttpRequest req = new HttpRequest();
                    req.setHeader('Authorization', 'Bearer ' + authDetails.details.Flosum__AccessToken__c);
                    req.setHeader('Content-Type', 'application/json');
                    req.setEndpoint(endpoint);
                    req.setMethod('GET');
                    req.setTimeout(120000);
                    Http httpreq = new Http();
                    HttpResponse res = httpreq.send(req);
                    if(res.getStatusCode() == 200){
                        return res.getBody();
                    }
                    else {
                        CalloutException e = new CalloutException();
                        e.setMessage(res.getBody());
                        throw e;
                    }
                }
            }
            else {
                CalloutException e = new CalloutException();
                e.setMessage('Go to the "Agile Settings" page and register the Agile org.');
                throw e;
            }
        }
        return null;
    }

    @AuraEnabled
    public static String getWorkDetails(String branchId){
        List<Flosum__Branch__c> branhLi = [SELECT Id,Flosum__External_Work_ID__c FROM Flosum__Branch__c WHERE Id=:branchId LIMIT 1];
        if(branhLi.size() == 1){
            //branhLi[0].External_Work_ID__c
            Flosum__Agile_Org__c agO = (Flosum__Agile_Org__c.getOrgDefaults() != null && Flosum__Agile_Org__c.getOrgDefaults().id != null) ? Flosum__Agile_Org__c.getOrgDefaults() : new Flosum__Agile_Org__c();
            if(agO != null && agO.Flosum__Org_Id__c != null){
                Flosum.FlosumUtils utils = new Flosum.FlosumUtils();
                Flosum.FlosumUtils.AuthenticateDetails authDetails = utils.authenticateAnOrg(agO.Flosum__Org_Id__c);
                if(Test.isRunningTest()){
                    authDetails = new Flosum.FlosumUtils.AuthenticateDetails();
                    authDetails.isSuccess = true;
                    authDetails.details = new Flosum__AuthorizationDetails__c(Flosum__InstanceURL__c='https://login.salesforce.com',Flosum__AccessToken__c='test');
                }
                if(authDetails != null && authDetails.isSuccess){
                    String query = 'SELECT Id,Name,agf__Assignee__r.Name,agf__Epic_Name__c,agf__Subject__c,RecordType.Name,agf__Status__c,agf__Product_Tag_Name__c,agf__Priority__c,agf__Description__c,agf__Details__c,agf__Details_and_Steps_to_Reproduce__c,agf__Additional_Details__c,agf__Feedback__c FROM agf__ADM_Work__c WHERE Id=\''+branhLi[0].Flosum__External_Work_ID__c+'\'';
                    String endpoint = authDetails.details.Flosum__InstanceURL__c + '/services/data/v48.0/query/?q=' + EncodingUtil.urlEncode(query, 'UTF-8');
                    
                    HttpRequest req = new HttpRequest();
                    req.setHeader('Authorization', 'Bearer ' + authDetails.details.Flosum__AccessToken__c);
                    req.setHeader('Content-Type', 'application/json');
                    req.setEndpoint(endpoint);
                    req.setMethod('GET');
                    req.setTimeout(120000);
                    Http httpreq = new Http();
                    HttpResponse res = httpreq.send(req);
                    if(res.getStatusCode() == 200){
                        return res.getBody();
                    }
                }
            }
        }
        return null;
    }
}