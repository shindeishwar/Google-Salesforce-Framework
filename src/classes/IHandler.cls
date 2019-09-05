/**
 * @group Utility
 * @description IHandler is a public interface to enforce consistent patterns across
 * all object's handler. 
 * Handler class is used to handle the business logic specific to one Sobject.
 */
public interface IHandler {

    void setProvider (IProvider provider);
    
}