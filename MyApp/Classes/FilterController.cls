public with sharing class FilterController {
	private String strId;
	private String returnUrl;
	public String strResult{set;get;}
	public List<FilterClass> lstFilterClass{set;get;}
	
	public FilterController(ApexPages.StandardController stdController)
	{
		init();
		returnUrl =  ApexPages.currentPage().getParameters().get('retURL');
		strId = ApexPages.currentPage().getParameters().get('id');
	}
	private void init()   
	{
		utility.addMessage('init');
		lstFilterClass = new List<FilterClass>();
		Map<String, Schema.SObjectField> M = Schema.SObjectType.Opportunity.fields.getMap();
	    Schema.DescribeSObjectResult D = Schema.SObjectType.Opportunity;
		List<Schema.SObjectField> LstFields = new List<Schema.SObjectField>();
		List<Schema.SObjectField> LstTempFields = new List<Schema.SObjectField>();
		lstFields = M.values();
		String expr = '';
		for( integer i=0; i < lstFields.size(); i++ )
		{
			if((String.valueof(lstFields[i].getDescribe().getType())) == 'String' || (String.valueof(lstFields[i].getDescribe().getType())).compareTo('Text Area') == 0 || (String.valueof(lstFields[i].getDescribe().getType())).compareTo('Text') == 0 || (String.valueof(lstFields[i].getDescribe().getType())).compareTo('Email') == 0)
			{
					expr += String.valueof(lstFields[i].getDescribe().getName()) + ',';
					LstTempFields.add(lstFields[i]);
					Filter__c objTemp = new Filter__c();
					objTemp.API_Field_Name__c = String.valueof(lstFields[i].getDescribe().getName());
					objTemp.Field_Name__c = String.valueof(lstFields[i].getDescribe().getLabel());
					objTemp.Object_Name__c = 'Opportunity';
					objTemp.IsFilter__c = false;
					lstFilterClass.add(new FilterClass(objTemp,false));
			}
		}
		String qry = 'Select ' + expr + ' from Opportunity';
	}
	
	public pageReference save()
	{
		List<Filter__c> lstToInsert = new List<Filter__c>();
		utility.addMessage('****Size()===>'+lstFilterClass.size());
		for(FilterClass objLstFilter : lstFilterClass)
			{
				utility.addMessage('outer condition'+objLstFilter);
				if(objLstFilter.isSelect == true)
				{
					Filter__c objTempFilter = objLstFilter.objFilter;
					objTempFilter.isFilter__c = objLstFilter.isSelect;
					lstToInsert.add(objTempFilter);
					utility.addMessage('Inner Save'+objTempFilter);
				} 
			}
		insert lstToInsert;
	 	utility.addMessage('Save successful..!!');
	 	return null;
	}
	
	public class FilterClass
	{
		public Boolean isSelect{set;get;}
		public Filter__c objFilter{set;get;}
		public FilterClass(Filter__c objFilter,boolean bvalue)
		{
			this.objFilter = objFilter;
			this.isSelect = bvalue;
		}
	}

}