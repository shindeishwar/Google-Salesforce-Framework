/**
 * @group Logger
 * @description This class is implementation of Interface ILogContext,
 *              which disgards all the chainable methods when the log
 *              statement should not be logged, i.e. isLoggable = false.
 */
public
class NoOp implements ILogContext {
  public
  ILogContext noOp() {
    return (ILogContext) this;
  }

  public
  ILogContext withCause(Exception e) {
    return noOp();
  }

  public
  ILogContext withCause(List<Database.SaveResult> dmlResults) {
    return noOp();
  }

  public
  ILogContext withCause(List<Database.DeleteResult> dmlResults) {
    return noOp();
  }

  public
  ILogContext withCause(List<Database.UndeleteResult> dmlResults) {
    return noOp();
  }

  public
  ILogContext withCause(List<Database.UpsertResult> dmlResults) {
    return noOp();
  }

  public
  ILogContext withMethod(String methodName) {
    return noOp();
  }

  public
  ILogContext withLineNumber(Integer lineNumber) {
    return noOp();
  }
    
  public 
  ILogContext withRecordId(String recordId) {
    return noOp();
  }
  public
  void log() {
    return;
  }

  public
  void log(String message) {
    return;
  }
  
  public
  void stageLog(Log__c log) {
    return;
  }
 
}