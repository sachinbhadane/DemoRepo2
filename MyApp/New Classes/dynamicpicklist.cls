public with sharing class dynamicpicklist 
{	
public String Name{get; set;}

public List<SelectOption> getcitynames()
{
  List<SelectOption> options = new List<SelectOption>();
  List<Country__c> citylist = new List<Country__c>();
  citylist = [Select Id, Name FROM Country__c ];
  options.add(new SelectOption('--None--','--None--'));
  for (Integer j=0;j<citylist.size();j++)
  {
      options.add(new SelectOption(citylist[j].Name,citylist[j].Name));
  }
  return options;
}
public String newpicklistvalue{get; set;}

public void saverec()
{
  Country__c newrec = new Country__c(Name=newpicklistvalue);
  insert newrec;
  newpicklistvalue=NULL;
}

}