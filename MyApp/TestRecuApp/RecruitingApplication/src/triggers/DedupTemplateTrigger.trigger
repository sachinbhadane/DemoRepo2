trigger DedupTemplateTrigger on Opportunity (before insert, before update) 
{
	if(Trigger.isBefore)
	{
		boolean bExist = true;
		List<Filter__c> lstFilter =[select Object_Name__c,isFilter__c,API_Field_Name__c,Field_Name__c from Filter__c where Object_Name__c = 'Opportunity' limit 1];
 		Map<String, Schema.SObjectField> mapToFieldValues = Schema.SObjectType.Opportunity.fields.getMap();
		List<Schema.SObjectField> lstFields = new List<Schema.SObjectField>();
		lstFields = mapToFieldValues.values();
		System.debug('******Map ===>>'+mapToFieldValues);
 		List<String> lstFieldNames = new List<String>();
 		//List<Opportunity> lstOppName =  [select Name from Opportunity];
 		//List<Opportunity> setOppName = [select Name from Opportunity];
 		string strQuery = 'select Name from Opportunity where ';
 		for(Opportunity opp :Trigger.new)
 		{
 			System.debug('****Filter__c Object'+lstFilter);
 			for(Filter__c objFilter :lstFilter)
 			{
 				system.debug('***First iteration');
 				string strcondition = 'opp.'+string.valueOf(objFilter.API_Field_Name__c);
				if(bExist)
 					strQuery += objFilter.API_Field_Name__c +' =: '+strcondition;
 				else
 					strQuery += ','+objFilter.API_Field_Name__c +' =: '+strcondition;
 				bExist = false;
 			}
 			System.debug('******opp.OPPName__c and opp.Name**>>'+opp.OPPName__c+'*'+opp.Name);
 		System.debug('******Query**>>'+strQuery);
 		 // strQuery += '';
 		  
 		//Utility.addMessage('******opp.OPPName__c and opp.Name**>>'+opp.OPPName__c+'*'+opp.Name);
 		List<Filter__c> lstResult = new List<Filter__c>();
 		lstResult   = database.query(strQuery);
 		
 		if(lstResult.size() != 0)
 			System.Debug('Duplicate Data');
 		else
 			system.debug('*********'+lstResult.size());  
 		}
	}
}