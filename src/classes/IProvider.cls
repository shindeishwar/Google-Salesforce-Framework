public interface IProvider {

    Database.UpsertResult[] upsertSObjects(List<sObject> sObjectList);
    
    Database.SaveResult[] updateSObjects(List<sObject> sObjectList);
    
    Database.SaveResult[] insertSObjects(List<sObject> sObjectList);
    
    Database.DeleteResult[] deleteSObjects(List<sObject> sObjectList);
    
    Database.UndeleteResult[] undeleteSObjects(List<sObject> sObjectList);
	
    Database.UpsertResult[] partialUpsertSObjects(List<sObject> sObjectList);
    
    Database.SaveResult[] partialUpdateSObjects(List<sObject> sObjectList);
    
    Database.SaveResult[] partialInsertSObjects(List<sObject> sObjectList);
    
    Database.DeleteResult[] partialDeleteSObjects(List<sObject> sObjectList);
    
    Database.UndeleteResult[] partialUndeleteSObjects(List<sObject> sObjectList);
}