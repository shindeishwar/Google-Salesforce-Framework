/**
 * @group ByPassLogicModel
 * @description Return boolean based on data present in the heirarchial
 * customsetting ByPass_Setting__c
 */
public
class ByPassLogicModel {
  private
  static Bypass_Settings__c settingInstance = Bypass_Settings__c.getInstance();


  /**
   * @description Method checks for custom setting data related to trigger
   * bypass for Case object.
   * @return Boolean
   * @example
   * Boolean isCaseByPass = ByPassLogicModel.isCaseByPassed();
   * This will return true if custom setting checkbox Case_Trigger__c is checked or else
   * false.
   */
  public
  static Boolean isCaseByPassed() {
    return settingInstance != null && settingInstance.Case_Trigger__c;
  }
  



}
