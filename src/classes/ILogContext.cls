public
interface ILogContext {
  ILogContext withCause(Exception e);

  ILogContext withCause(List<Database.SaveResult> dmlResults);

  ILogContext withCause(List<Database.DeleteResult> dmlResults);

  ILogContext withCause(List<Database.UndeleteResult> dmlResults);

  ILogContext withCause(List<Database.UpsertResult> dmlResults);

  ILogContext withMethod(String methodName);

  ILogContext withLineNumber(Integer lineNumber);
    
  ILogContext withRecordId(String recordId);

  void log();

  void log(String message);
  
  void stageLog(Log__c log);
}