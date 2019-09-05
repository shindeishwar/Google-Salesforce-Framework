/**
 * @group TestBuilder
 * @description Collection of test methods for NoOp Class
 */

@isTest 
public class NoOpTest {
    private static final Integer EMPLOYEE_PID_1 = 1;
    private static final Integer EMPLOYEE_PID_2 = 2;
	private static NoOp noOp = new NoOp();
    
    private static myHandler handler = new MyHandler();    
    private Class MyProvider extends BaseProvider implements IProvider {
    }
    private Class MyHandler extends BaseHandler implements IHandler {
        private MyProvider provider = (MyProvider)loadProvider();	
        public MyHandler(){
            setProvider((MyProvider)loadProvider());
        }
        public override Iprovider loadProvider () {
			return (Iprovider) new myProvider();
		}        
        public Database.UpsertResult[] upsertSObjects(List<sObject> sObjectList){
            return provider.upsertSObjects(sObjectList);
        }
        public Database.SaveResult[] updateSObjects(List<sObject> sObjectList){
            return provider.updateSObjects(sObjectList);
        }        
        public Database.SaveResult[] insertSObjects(List<sObject> sObjectList){
            return provider.insertSObjects(sObjectList);
        }
        public Database.DeleteResult[] deleteSObjects(List<sObject> sObjectList){
            return provider.deleteSObjects(sObjectList);
        }
        public Database.UndeleteResult[] undeleteSObjects(List<sObject> sObjectList){
            return provider.undeleteSObjects(sObjectList);
        }
        public Database.UpsertResult[] partialUpsertSObjects(List<sObject> sObjectList){
            return provider.partialUpsertSObjects(sObjectList);
        }
        public Database.SaveResult[] partialUpdateSObjects(List<sObject> sObjectList){
            return provider.partialUpdateSObjects(sObjectList);
        }
        public Database.SaveResult[] partialInsertSObjects(List<sObject> sObjectList){
            return provider.partialInsertSObjects(sObjectList);
        }
        public Database.DeleteResult[] partialDeleteSObjects(List<sObject> sObjectList){
            return provider.partialDeleteSObjects(sObjectList);
        }
        public Database.UndeleteResult[] partialUndeleteSObjects(List<sObject> sObjectList){
            return provider.partialUndeleteSObjects(sObjectList);
        }
	}
    
    
    //Set up basic testing data necessary for all test methods (such as records for Contact, Competitor__c,
    //and Custom Setting object Case_Workflow_Values__c)
    @testSetup static void setup(){
        Country__c myCountry = TestFactory.initCountry()[0];
        insert myCountry;
        
        Location__c myLocation = TestFactory.initLocation(myCountry.Id)[0];
        insert myLocation;

        List<Contact> contacts = new List<Contact>();
        contacts.addAll(TestFactory.initContact(myLocation.Id, null));
        contacts.addAll(TestFactory.initContact(myLocation.Id, null));
        contacts[0].PID__c = EMPLOYEE_PID_1;
        contacts[1].PID__c = EMPLOYEE_PID_2;
        insert contacts;
    }
    
    private static List<Contact> getContacts() {
		List<Contact> myContacts = [
            SELECT 
            Id, 
            Name,
            PID__c,
            Location__c
            FROM Contact
            ORDER BY
            Id
        ]; 
        return myContacts;
    }
    
    private static void testExceptionMethod(){
        throw new IllegalArgumentException('Test Error');
    }
        
    //Test with no exception for 
    //  ILogContext withCause(Exception e)
    //  log()
    //  log(String message)
    @isTest static void passWithCauseException(){
        Object returnObj;
        try {
            testExceptionMethod();
        } catch (Exception e){
            returnObj = noOp.withCause(e);
      		noOp.log();
        }
        system.debug('noOp ==> ' + noOp);
        system.assert(
            returnObj == noOp, 
            'passWithCauseException() expects returnObj == noOp, but returnObj => ' + returnObj
        );
    } 
    
    //Test with no exception for ILogContext withMethod(String methodName) 
    @isTest static void passWithCauseExceptionWithMethodName(){
        Object returnObj;
        try {
            testExceptionMethod();
        } catch (Exception e){
            returnObj = noOp.withMethod('testExceptionMethod');
			noOp.log(e.getMessage());
        }
        system.debug('noOp ==> ' + noOp);
        system.assert(
            returnObj == noOp, 
            'passWithCauseExceptionWithMethodName() expects returnObj == noOp, but returnObj => ' + returnObj
        );
    }      
    
    //Test with no exception for ILogContext withLineNumber(Integer lineNumber)
    @isTest static void passWithCauseExceptionWithLineNumber(){
        Object returnObj;
        try {
            testExceptionMethod();
        } catch (Exception e){
            returnObj = noOp.withLineNumber(e.getLineNumber());
        }
        system.debug('noOp ==> ' + noOp);
        system.assert(
            returnObj == noOp, 
            'passWithCauseExceptionWithLineNumber() expects returnObj == noOp, but returnObj => ' + returnObj
        );
    }
    
	//Test for no exception for stageLog(Log__c log)
    @isTest static void passStageLog(){
        Boolean getLogged = false; 
        try {
            testExceptionMethod();
        } catch (Exception e){
            Log__c myLog = new Log__c (
                Name='ErrorLog', Class__c='TestClass', Method__c='testExceptionMethod', 
                Level__c='ERROR', Message__c='Dummy Error'
            );
            noOp.stageLog(myLog);
            getLogged = true;
        }
        system.assert(
            getLogged, 
            'passStageLog() expects getLogged to be true, but getLogged = ' + getLogged
        );
    } 
 
    
    //Test for no exception for ILogContext withRecordId(String recordId) 
    @isTest static void passWithCauseExceptionWithRecordId(){
        Object returnObj;
        String myRecordId = getContacts()[0].id;
        try {
            testExceptionMethod();
        } catch (Exception e){
            returnObj = noOp.withRecordId(myRecordId);            
        }
        system.debug('noOp ==> ' + noOp);
        system.assert(
            returnObj == noOp, 
            'passWithCauseExceptionWithRecordId() expects returnObj == noOp, but returnObj => ' + returnObj
        );
    } 
      
    //Test for no exception for ILogContext withCause(List<Database.SaveResult> dmlResults)
    @isTest static void passWithCauseDMLSaveResult(){
        Object returnObj;
        List<Database.SaveResult> dmlResults;
        try {
            system.assert(
                handler.getProvider() != null, 
                'handler.getProvider() should not return null'
            );
            system.assert(
                handler.getProvider() != null, 
                'handler.getProvider() should not return null'
            );
            List<Contact> updContacts = getContacts();
            updContacts[0].PID__c = EMPLOYEE_PID_2;
            dmlResults = handler.updateSObjects(updContacts);
            system.debug('Should not get here - Not allow duplicate value for PID__c field!');
            
        } catch (DmlException e){
            system.debug('Got DmlException e = ' + e);
            returnObj = noOp.withCause(dmlResults);
        }
        system.debug('noOp ==> ' + noOp);
        system.assert(
            returnObj == noOp, 
            'passWithCauseDMLSaveResult() expects returnObj == noOp, but returnObj => ' + returnObj
        );
    }  
    
    //Test for no exception for ILogContext withCause(List<Database.UpsertResult> dmlResults) 
    @isTest static void passWithCauseDMLUpsertResult(){
        Object returnObj;
        List<Database.UpsertResult> dmlResults;
        try {
            List<Contact> updContacts = getContacts();
            updContacts[0].PID__c = EMPLOYEE_PID_2;
            dmlResults = handler.upsertSObjects(updContacts);
            system.debug('Should not get here - Not allow duplicate value for PID__c field!');
        } catch (DmlException e){
            system.debug('Got DmlException e = ' + e);
            returnObj = noOp.withCause(dmlResults);
        }
        system.debug('noOp ==> ' + noOp);
        system.assert(
            returnObj == noOp, 
            'passWithCauseDMLUpsertResult() expects returnObj == noOp, but returnObj => ' + returnObj
        );
    }
    
    //Test for no exception for ILogContext withCause(List<Database.DeleteResult> dmlResults) 
    @isTest static void passWithCauseDMLDeleteResult(){
        Object returnObj;
        List<Database.DeleteResult> dmlResults;
        Boolean expectingErrorInNextStep = false;
        try {
            List<Contact> delContacts = getContacts();
            handler.partialDeleteSObjects(delContacts);
            handler.partialUndeleteSObjects(delContacts);
            handler.deleteSObjects(delContacts);
            expectingErrorInNextStep = true;
            handler.deleteSObjects(delContacts);
            system.debug('Should not get here - Not allow to delete twice!');
        } catch (DmlException e){
            if (expectingErrorInNextStep){
                system.debug('Got DmlException e = ' + e);
                returnObj = noOp.withCause(dmlResults);
            }
        }
        system.debug('noOp ==> ' + noOp);
        system.assert(
            returnObj == noOp, 
            'passWithCauseDMLDeleteResult() expects returnObj == noOp, but returnObj => ' + returnObj
        );
    } 
   
    //Test for no exception for ILogContext withCause(List<Database.UndeleteResult> dmlResults)
    @isTest static void passWithCauseDMLUnDeleteResult(){
        Object returnObj;
        List<Database.UndeleteResult> dmlResults;
        try {
            List<Contact> myContacts = getContacts();
            myContacts.add ( new Contact (LastName = 'Test3',FirstName='TestName3', email='test@test.com', PID__c=3) );
            handler.partialUpsertSObjects(myContacts);
            myContacts = getContacts();
            handler.undeleteSObjects(myContacts);
            system.debug('Should not get here - Not allow to undelete when they are not deleted yet!');
        } catch (DmlException e){
            system.debug('Got DmlException e = ' + e);
            returnObj = noOp.withCause(dmlResults);
        }
        system.debug('noOp ==> ' + noOp);
        system.assert(
            returnObj == noOp, 
            'passWithCauseDMLUnDeleteResult() expects returnObj == noOp, but returnObj => ' + returnObj
        );
    } 
}