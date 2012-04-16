public with sharing class LookupScoreCardTemplateController {
  public TemplateMaster__c objTemplateMaster {get;set;} // new Template Master to create
  public List<TemplateMaster__c> lstTemplateMaster{get;set;} // search results
  public string searchString{get;set;} // search keyword
 
  public LookupScoreCardTemplateController() {
    objTemplateMaster = new TemplateMaster__c();
    // get the current search string
    searchString = System.currentPageReference().getParameters().get('lksrch');
    runSearch();  
  }
 
  // performs the keyword search
  public PageReference search() {
    runSearch();
    return null;
  }
 
  // prepare the query and issue the search command
  private void runSearch() {
    // TODO prepare query string for complex serarches & prevent injections
    lstTemplateMaster = performSearch(searchString);     
    if(lstTemplateMaster.size()==0)
    	Utitlity.addError('Template Now found.');           
  } 
 
  // run the search and return the records found. 
  private List<TemplateMaster__c> performSearch(string searchString) {
 
    String soql = 'select Name, TStatus__c, Version__c from TemplateMaster__c where TStatus__c =\''+Label.TemplateStatus_Active +'\'';
    if(searchString != '' && searchString != null)
      soql = soql +  ' and Name LIKE \'%' + searchString +'%\' Order by Name';
    System.debug(soql);
    List<TemplateMaster__c> objTemp = database.query(soql);
    
    return objTemp; 
 
  }
}