/**
 * @group Utility
 * @description HandlerDispatcher is used to get the instance of Object handler
 * using Sobject Type. Please ensure you have handler class created for Sobject
 * before calling this method. 
 * Class name should be in this format :( Sobject Name without '__c' + 'Handler')
 */
public with sharing class HandlerDispatcher {
    
    private static Map<Schema.sObjectType, String> sObjectTypeNameMap = new Map<Schema.sObjectType, String>();
    
    public static IHandler getHandlerInstance(Schema.sObjectType entityType){
        
        String sObjectName = sObjectTypeNameMap.get(entityType);
        
        if(sObjectName == null || sObjectName == ''){
            sObjectName = entityType.getDescribe().getName();
            System.debug('sObjectName **** ' + sObjectName);
            if(sObjectName.endsWith('__c')) {
                sObjectName = sObjectName.substring(0, sObjectName.indexOf('__c'));
            }
            sObjectTypeNameMap.put(entityType, sObjectName);
        }
        
        // Get the Type corresponding to the class name
        Type t = Type.forName( sObjectName + 'Handler');
        // Instantiate the type.
        // The type of the instantiated object is the interface.
        IHandler entityHandler = (IHandler)t.newInstance();
        
        return entityHandler;
    }
    
}