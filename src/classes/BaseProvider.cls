/**
 * @group Utility
 * @description IProvider is a public interface to enforce consistent patterns/methods
 * across all object's provider. 
 * Provider class is used to handle the Database operations.
 */
public abstract class BaseProvider implements IProvider{ 
    //Added Comment for b/122960858 - Only works with Id field, not for External Id field
    public Database.UpsertResult[] upsertSObjects(List<sObject> sObjectList){
        return Database.upsert(sObjectList);
    }
    
    public Database.SaveResult[] updateSObjects(List<sObject> sObjectList){
        return Database.update(sObjectList);
    }
    
    public Database.SaveResult[] insertSObjects(List<sObject> sObjectList){
        return Database.insert(sObjectList);
    }
    
    public Database.DeleteResult[] deleteSObjects(List<sObject> sObjectList){
        return Database.delete(sObjectList);
    }
    
    public Database.UndeleteResult[] undeleteSObjects(List<sObject> sObjectList){
        return Database.undelete(sObjectList);
    }
    
    public Database.UpsertResult[] partialUpsertSObjects(List<sObject> sObjectList){
        return Database.upsert(sObjectList,false);
    }
    
    public Database.SaveResult[] partialUpdateSObjects(List<sObject> sObjectList){
        return Database.update(sObjectList,false);
    }
    
    public Database.SaveResult[] partialInsertSObjects(List<sObject> sObjectList){
        return Database.insert(sObjectList,false);
    }
    
    public Database.DeleteResult[] partialDeleteSObjects(List<sObject> sObjectList){
        return Database.delete(sObjectList,false);
    }
    
    public Database.UndeleteResult[] partialUndeleteSObjects(List<sObject> sObjectList){
        return Database.undelete(sObjectList,false);
    }
     
}