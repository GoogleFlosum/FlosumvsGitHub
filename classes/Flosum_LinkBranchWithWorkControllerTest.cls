@isTest 
private class Flosum_LinkBranchWithWorkControllerTest {
    
    static testMethod void linkWorkTest() {
        Test.setMock(HttpCalloutMock.class, new LinkToWorkResponseGenerator());

        Flosum__Organisation__c org = new Flosum__Organisation__c(Name = 'Test Org',Flosum__Username__c = 'test@testOrg.com');
        insert org;
        
        Flosum__AuthorizationDetails__c auth = new Flosum__AuthorizationDetails__c(Flosum__AuthorisedUser__c = 'test@testOrg.com', Name = 'test@testOrg.com', Flosum__AccessToken__c = 'test', Flosum__RefreshToken__c = 'test', Flosum__InstanceURL__c = 'test');
        insert auth;

        Flosum__Repository__c rep = new Flosum__Repository__c();
        rep.Name = 'repTest';
        insert rep;

        Flosum__Agile_Org__c agO = Flosum__Agile_Org__c.getOrgDefaults();
        agO.Flosum__Org_Id__c = org.Id;
        insert agO;

        Flosum__Repository_Permission__c repPerm = new Flosum__Repository_Permission__c();
        repPerm.Flosum__Repository__c = rep.Id;
        repPerm.Flosum__User__c = UserInfo.getUserId();
        insert repPerm;
            
        Flosum__Branch__c br = new Flosum__Branch__c(Flosum__Branch_Name__c = 'Test Branch',Flosum__Repository__c = rep.Id);
        insert br;
        Test.startTest();
        Flosum_LinkBranchWithWorkController.getWorkList(br.Id,'');
        Flosum_LinkBranchWithWorkController.getWorkList(br.Id,'abc');
        Flosum_LinkBranchWithWorkController.getWorkDetails(br.Id);
        String result = Flosum_LinkBranchWithWorkController.updateBranch(br.Id, 'testId');
        System.assertEquals('done',result);
        Test.stopTest();
    }

    public class LinkToWorkResponseGenerator implements HttpCalloutMock 
    {
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest req) 
        {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String endPoint = req.getEndpoint();
            if(endPoint.endsWith('query/?q=')) {
                res.setBody('');
            }
            else if(endPoint.endsWith('/services/data/v26.0/'))
                res.setBody('{"Error":"Error","id":"https://login.salesforce.com/id/00Dx0000000BV7z/005x00000012Q9P", "issued_at":"1278448101416", "refresh_token":"5Aep8614iLM.Dq661ePDmPEgaAW9Oh_L3JKkDpB4xReb54_ pZebnUG0h6Sb4KUVDpNtWEofWM39yg==", "instance_url":"https://na1.salesforce.com", "signature":"CMJ4l+CCaPQiKjoOEwEig9H4wqhpuLSk4J2urAe+fVg=", "access_token":"00Dx0000000BV7z!AR8AQP0jITN80ESEsj5EbaZTFG0R NBaT1cyWk7TrqoDjoNIWQ2ME_sTZzBjfmOE6zMHq6y8PIW4eWze9JksNEkWUl.Cju7m4", "username":"test@testOrg.com"}');
            else if(endPoint.contains('/services/data/v34.0/tooling/'))
                res.setBody('{"records": [{"fullName": "TempTest__c"}, {"fileName": "objects/Temptest.object"}, {"lastModifiedByName": "Shyam"}, {"lastModifiedDate": "2015-10-23 10:22:38"}, {"type": "ApexClass"}]}');
            else
                res.setBody('{"id":"https://login.salesforce.com/id/00Dx0000000BV7z/005x00000012Q9P", "issued_at":"1278448101416", "refresh_token":"5Aep8614iLM.Dq661ePDmPEgaAW9Oh_L3JKkDpB4xReb54_ pZebnUG0h6Sb4KUVDpNtWEofWM39yg==", "instance_url":"https://na1.salesforce.com", "signature":"CMJ4l+CCaPQiKjoOEwEig9H4wqhpuLSk4J2urAe+fVg=", "access_token":"00Dx0000000BV7z!AR8AQP0jITN80ESEsj5EbaZTFG0R NBaT1cyWk7TrqoDjoNIWQ2ME_sTZzBjfmOE6zMHq6y8PIW4eWze9JksNEkWUl.Cju7m4", "username":"test@testOrg.com"}');
            res.setStatusCode(200);
            return res;
        }
    }
}