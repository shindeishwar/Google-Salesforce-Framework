/**
* @group Utility
* @description BaseHandler is a abstract class & implements  IHandler
* Handler class is used to handle the business logic specific to one Sobject.
*/
public abstract class BaseHandler implements IHandler{
    // This change should get checked in Cider DemoTest - Yuying  
    // the provider for this handler
    // This changes should not get checked in Cider DemoTest - Santosh
    private IProvider provider;  
    
    // get the provider
    public virtual IProvider getProvider(){
        if (this.provider == null){
            this.provider = this.loadProvider();
        }
        
        return this.provider;
    }
    
    // load the provider
    public abstract IProvider loadProvider();
    
    public void setProvider (IProvider provider) {
        this.provider = provider;
    }
    
    /**
	* @description Check SaveResult[] and log any database errors if applicable
	* @param methodName - The name of method that is calling from
	* @param result - List of Database.SaveResult
	* @return true or false to indicate whether these is any database error found
	*/  
    //Created for b/122960858   
    public Boolean logDatabaseErrors (logger Logger, String methodName, Database.SaveResult[] result){
        List<Database.SaveResult> errResults = new List<Database.SaveResult>();
        List<String> errors = new List<String>();
        
        for (Integer i = 0; i < result.size(); i++) {
            if (!result.get(i).isSuccess()) {
                errResults.add(result.get(i));
                Database.Error error = result.get(i).getErrors().get(0);
                errors.add(error.getMessage());
            }
        }
        if (errResults.size() > 0) {
            Logger
                .atError()
                .withMethod(methodName)
                .withCause(errResults)
                .log('** Database Error(s) from ' + methodName + '():' + String.join(errors, '; ') );
            
            return true;
            
        } else {
            return false;
        }
    }
    
    
    /**
	* @description Check UpsertResult[] and log any database errors if applicable
	* @param methodName - The name of method that is calling from
	* @param result - List of Database.UpsertResult
	* @return true or false to indicate whether these is any database error found
	*/    
    //Created for b/122960858
    public Boolean logDatabaseErrors (logger Logger, String methodName, Database.UpsertResult[] result){
        List<Database.UpsertResult> errResults = new List<Database.UpsertResult>();
        List<String> errors = new List<String>();
        
        for (Integer i = 0; i < result.size(); i++) {
            if (!result.get(i).isSuccess()) {
                errResults.add(result.get(i));
                Database.Error error = result.get(i).getErrors().get(0);
                errors.add(error.getMessage());
            }
        }
        if (errResults.size() > 0) {
            Logger
                .atError()
                .withMethod(methodName)
                .withCause(errResults)
                .log('** Database Error(s) from ' + methodName + '(): ' + String.join(errors, '; ') );
            
            return true;
            
        } else {
            return false;
        }
    } 
}