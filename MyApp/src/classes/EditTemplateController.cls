public with sharing class EditTemplateController

{
	
//Member Variables

	private Integer childCount;









	public String returnURL;
	
//Properties
	private String strId{set;get;}

	public Boolean disableFlag{set;get;}
	
public TemplateMaster__c objTemplate {set;get;}
	

	public List<TemplateItems> lstTemplateItems{set;get;}
	
private TemplateMaster__c objNewTemplateVersion{set;get;}
	
private  List<TemplateDetail__c> lstTempItemDetails{set;get;}
	

	public List<TemplateItems> oldLstTemplateItems{set;get;}
	
private List<TemplateItems> lstSelectedItems{set;get;}

	public List<TemplateItems> lstDeleteItems{set;get;}
	
public List<TemplateDetail__c> lstTempItemDetailsDelete{set;get;}
	

	
	//Constructor
	
public EditTemplateController(ApexPages.StandardController stdController)

	{
		returnURL = ApexPages.currentPage().getParameters().get('retURL');
	
	strId = ApexPages.currentPage().getParameters().get('id');
		
lstTemplateItems = new List<TemplateItems>();
		
this.objTemplate = (TemplateMaster__c)stdController.getRecord();

		
		objTemplate  = [Select t.TStatus__c, t.TName__c,t.Version__c,t.Name,t.Id From TemplateMaster__c t where Id =:strId];		
	
	if(objTemplate.TStatus__c == Label.TemplateStatus_Active)
		
{
			disableFlag=false;
		}

		else
		{
			disableFlag=true;
		}	
		
		lstTempItemDetails = [Select t.id,t.TemplateMaster__c, t.Give_Description__c, t.Get_Points__c, t.Get_Description__c
							  From TemplateDetail__c t where TemplateMaster__c =:objTemplate.Id order by t.Get_Points__c Asc];
		init();
	}
	//init method for declaration
	public void init()
	{
		lstDeleteItems = new List<TemplateItems>();
		childCount = 0;
		if(lstTempItemDetails != null && lstTempItemDetails.size() > 0)
		{
			for(TemplateDetail__c objTemplateDetail : lstTempItemDetails)
			{
				lstTemplateItems.add(new TemplateItems(objTemplateDetail,childCount));	
				childCount++;
			}
		}
	}
	//method for adding row (one row at a time) to the page
	public void addMore()
	{	
		lstTemplateItems.add(new TemplateItems(new TemplateDetail__c(TemplateMaster__c = objTemplate.Id),lstTemplateItems.size()));
	}
	
	//method to remove selected rows from the page
	public pagereference remove()
	{
		//lstDeleteItems.clear();
		lstSelectedItems = new List<TemplateItems>();
		//Selecting the rows for creating new Version
		if(lstTemplateItems != null && lstTemplateItems.size() > 0)
		{
			for(TemplateItems ptrToList: lstTemplateItems)
			{
				if(ptrToList.flag == false)
				{
					lstSelectedItems.add(ptrToList);
				}
				else if(ptrToList.detailsItems.id != null)
					lstDeleteItems.add(ptrToList);
			}
		}
		
		//error condition for empty version
		if(lstSelectedItems.size()==0)
		{
			Utitlity.addError(Label.Error_Message_for_Empty_Version);
			return null;
		}
		
		//Checking if there is no selection of rows for removal 
		if(lstSelectedItems.size() == lstTemplateItems.size())
		{
			Utitlity.addError(Label.Error_Message_for_CheckBoxSelection);
			return null;
		}
		//preparing new list of detail records for new version
		lstTemplateItems.clear();
		lstTemplateItems = lstSelectedItems.clone();
		childCount=lstTemplateItems.size();
		//pagereference pgRef=new pagereference('/apex/EditTemplatePage?retURL='+returnURL);
		return null;
	}
	//Method to save version of template 
	public pagereference save()
	{
		//Checking if there is any blank row entered by the user or not
		for(TemplateItems objTemp : lstTemplateItems)
		{
			if((objTemp.detailsItems.Get_Points__c == null) || (objTemp.detailsItems.Get_Description__c == null) || (objTemp.detailsItems.Give_Description__c == null)||String.valueOf(objTemp.detailsItems.Get_Points__c) == '' || (objTemp.detailsItems.Get_Description__c == '') || (objTemp.detailsItems.Give_Description__c == '') )
			{
				Utitlity.addError(Label.Error_Message_for_Blank_Row);
				return null;
			}
		}
		if(returnURL != null )
		{
			//Deleted Record if Remove
			lstTempItemDetailsDelete = new List<TemplateDetail__c>();
			for(TemplateItems delToTemplateItems : lstDeleteItems)
			{
				lstTempItemDetailsDelete.add(delToTemplateItems.detailsItems);
			}
			//delete lstTempItemDetails;
			List<TemplateDetail__c> lstTempItemDetailsNew = new List<TemplateDetail__c>();
			for(TemplateItems ptrToTemplateItems : lstTemplateItems)
			{
				for(TemplateDetail__c objClass : lstTempItemDetailsNew)
				{
					if(objClass.Give_Description__c == null ||objClass.Get_Description__c == null || objClass.Get_Points__c == null
					|| objClass.Give_Description__c == '' ||objClass.Get_Description__c == '' || string.ValueOf(objClass.Get_Points__c)=='')
					{
						Utitlity.addError(Label.Error_Message_for_Blank_Row);
						return null;
					}
					//Check For duplicate Values
					if(objClass.Give_Description__c == ptrToTemplateItems.detailsItems.Give_Description__c
					 && objClass.Get_Description__c == ptrToTemplateItems.detailsItems.Get_Description__c)
					{
						Utitlity.addError(Label.Error_Message_for_Duplicate_Records);
						return null;
					}
				}
				lstTempItemDetailsNew.add(ptrToTemplateItems.detailsItems);
			}
			upsert(lstTempItemDetailsNew);
			if(lstTempItemDetailsDelete.size()>0)
				delete lstTempItemDetailsDelete;
			Utitlity.addMessage(Label.Template_UpdateError);
			return null;
		}
		else
		{
			List<TemplateDetail__c> objOldTemplateItemDetails = new List<TemplateDetail__c>();
			oldLstTemplateItems = new List<TemplateItems>();
			objOldTemplateItemDetails = [Select t.TemplateMaster__c, t.Give_Description__c, t.Get_Points__c, t.Get_Description__c
								  From TemplateDetail__c t where TemplateMaster__c =:objTemplate.Id order by Get_Points__c Asc];
			childCount=0;
			if(objOldTemplateItemDetails != null && objOldTemplateItemDetails.size() > 0)
			{
				for(TemplateDetail__c objTemplateDetail : objOldTemplateItemDetails)
				{
					oldLstTemplateItems.add(new TemplateItems(objTemplateDetail,childCount));
					childCount++;		
				}
			} 
			//Checking for the simillarity of old and new version
			pagereference pgref = checkSimillarityFunction();
			return pgref;
		}
	}
	
	//Method for checking simillarity of new and old version
	public pagereference checkSimillarityFunction()
	{
		//Checking for Duplicate records in the new Version	
		Boolean checkDuplicateRecordFlag = checkDuplicateRecordFunction(lstTemplateItems);
		integer ptsCounter;
		if(checkDuplicateRecordFlag==false)
		{	
			//Checking for the simillarity of old and new version
			if(lstTemplateItems != null && (lstTemplateItems.size() == oldLstTemplateItems.size()))
			{
				ptsCounter=0;
				for(TemplateItems objTemp : lstTemplateItems)
				{
					for(TemplateItems oldObjTemp : oldLstTemplateItems)
					{
						if(objTemp.detailsItems.Get_Points__c==oldObjTemp.detailsItems.Get_Points__c)
						{
							if((objTemp.detailsItems.Get_Description__c==oldObjTemp.detailsItems.Get_Description__c)&&(objTemp.detailsItems.Give_Description__c==oldObjTemp.detailsItems.Give_Description__c))
							{
								ptsCounter++;
							}
						}
					}
				}
				//Error Condition if new version and old version will be same
				if(ptsCounter==oldLstTemplateItems.size())
				{
					//Error Message
					Utitlity.addError(Label.Error_Message_for_Version);
					return null;
				}
				//Calling save(saveExtension) method
				else
				{
					pagereference pgRef;
					pgRef=saveExtension();
					return pgRef;
				}
			}
			else
			{
					pagereference pgRef;
					pgRef=saveExtension();  //Calling save(saveExtension) method
					return pgRef;
			}
		}
		else
		{
			//Error Message for Duplicate records
			Utitlity.addError(Label.Error_Message_for_Duplicate_Records);
			return null;
		}
	}
	//Method to check duplicate Detail records in new version
	public boolean checkDuplicateRecordFunction (List<TemplateItems> recordList)
	{
		TemplateDetail__c tempRecord = new TemplateDetail__c();
		integer tempCounter=0;
		for(TemplateItems ptrToList : recordList )
		{
			tempRecord=ptrToList.detailsItems;
			tempCounter=0;
			for(TemplateItems ptrToSameList : recordList )
			{
				if((tempRecord.Get_Points__c==ptrToSameList.detailsItems.Get_Points__c) && (tempRecord.Get_Description__c==ptrToSameList.detailsItems.Get_Description__c) && (tempRecord.Give_Description__c==ptrToSameList.detailsItems.Give_Description__c) )
				{
					tempCounter++;
				}
				else if((tempRecord.Get_Points__c != ptrToSameList.detailsItems.Get_Points__c) && (tempRecord.Get_Description__c==ptrToSameList.detailsItems.Get_Description__c) && (tempRecord.Give_Description__c==ptrToSameList.detailsItems.Give_Description__c) )
				{
					tempCounter++;
				}
			}
			//Error condition for duplicate records
			if(tempCounter > 1)
			{
				UtitLity.addError(Label.Error_Message_for_Duplicate_Records);
				return true;
			}
		}
		return false;
	}
	//method to insert new version data to database
	public pagereference saveExtension()
	{
		List<TemplateDetail__c> lstToInsert = new List<TemplateDetail__c>(); 
		//Updating old version with Obsolete status
		objTemplate.TStatus__c=Label.TemplateStatus_Obsolete;
			update objTemplate;
			objNewTemplateVersion = new TemplateMaster__c();
			objNewTemplateVersion.Name=objTemplate.Name;
			objNewTemplateVersion.TStatus__c=Label.TemplateStatus_Active;
			objNewTemplateVersion.Version__c=objTemplate.Version__c + 1;
			//Inserting new Template object with same name as old one with status active and new version number
			Database.Saveresult objSaveTemplateVersion = Database.insert(objNewTemplateVersion);
			if(objSaveTemplateVersion.isSuccess())
			{
				if(lstTemplateItems != null && lstTemplateItems.size() > 0)
				{
					for(TemplateItems ptrToTemplateItems : lstTemplateItems)
					{
						TemplateDetail__c objNewTemplateDetails = new TemplateDetail__c();
						objNewTemplateDetails.Get_Points__c = ptrToTemplateItems.detailsItems.Get_Points__c;
						objNewTemplateDetails.TemplateMaster__c = objSaveTemplateVersion.getId();
						objNewTemplateDetails.Give_Description__c = ptrToTemplateItems.detailsItems.Give_Description__c;
						objNewTemplateDetails.Get_Description__c=ptrToTemplateItems.detailsItems.Get_Description__c;
						lstToInsert.add(objNewTemplateDetails);
					}
					insert lstToInsert;
				}
			}
			pagereference pgref=new pagereference('/apex/viewTemplatePage?id='+objSaveTemplateVersion.getId());
			return pgref;
	}
	//Wrapper Class
	public class TemplateItems
	{
		public integer iIndex{set;get;}
		public TemplateDetail__c detailsItems{set;get;}
		public Boolean flag {set;get;}
		public TemplateItems(TemplateDetail__c detailsItems,Integer index)
		{
			this.iIndex = index;
			this.detailsItems = detailsItems;	
			this.flag = false;
		}	
	}
}