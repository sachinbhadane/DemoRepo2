		//var GotTotalId = 'NewScoreCard:idForm:idPageBlock:j_id28:pgbSecItem_TotalScoreGets:idTotalScoreGets';
		//var GiveTotalId ='NewScoreCard:idForm:idPageBlock:j_id28:pgbSecItem_TotalScoreGives:idTotalScoreGives';
		
		var GotTotalId ='totalScoreGet';
		var GiveTotalId = 'totalScoreGives';
		
		function CheckifNull()
		{
		var GiveTotal = isNaN(parseInt($(".totalScoreGives").val()))?0 :parseInt($(".totalScoreGives").val());
			$(".totalScoreGives").val(GiveTotal);
			var GetTotal = isNaN(parseInt($(".totalScoreGet").val()))?0 :parseInt($(".totalScoreGet").val());
			$(".totalScoreGet").val(GetTotal);
			/*document.getElementById(GotTotalId).value = isNaN(parseInt(document.getElementById(GotTotalId).value))?0 :parseInt(document.getElementById(GotTotalId).value);
			document.getElementById(GiveTotalId).value = isNaN(parseInt(document.getElementById(GiveTotalId).value)) ? 0 :parseInt(document.getElementById(GiveTotalId).value);*/
		}
		function total(textSfId,txtGaveId,textPointId,textTotalId,textFreqId,classTotalGive)
		{
			var splitid = textSfId.split(':');
			var strid ='';
	        var currentId='';
	        var Gtotalvalue =0;
	        for(var j=0;j<splitid.length-2;j++)
	        {
	        	strid +=splitid[j]+':';
	        }
	        currentId = splitid[splitid.length-2];
	        if(document.getElementById(textSfId).checked)
	        {
		        var PointValue = document.getElementById(strid+currentId+':'+textPointId).innerHTML;
		        
		        if(document.getElementById(strid+currentId+':'+textFreqId).value !='' && document.getElementById(strid+currentId+':'+textFreqId).value != 0)
		        {	
		        	document.getElementById(strid+currentId+':'+textTotalId).value = PointValue *document.getElementById(strid+currentId+':'+textFreqId).value;
		        }
		        else
		        {
		        	document.getElementById(strid+currentId+':'+textFreqId).value = 1 ;
		        	document.getElementById(strid+currentId+':'+textTotalId).value = PointValue ;
		        }
		        
		    }
	        else
	        {
	        	document.getElementById(strid+currentId+':'+textTotalId).value = 0;
	        	document.getElementById(strid+currentId+':'+textFreqId).value = 0;
	        }
	        //For count total
	        //subTotalValue(textSfId,textTotalId,classTotalGive);
	        subTotalValue(textSfId,textTotalId,GiveTotalId);
	      }
	    function subTotalValue(textSfId,textTotalId,ClassTotalId)
	    {
	    	var splitid = textSfId.split(':');
			var strid ='';
	        var Gtotalvalue =0;
	        for(var j=0;j<splitid.length-2;j++)
	        {
	        	strid +=splitid[j]+':';
	        }
	        
	        for(var j=0;j<100;j++)
	        {
	        	try
	        	{
	        		SubTotal = document.getElementById(strid+j+':'+textTotalId).value;
	        	}
	        	catch(e)
	        	{
	        		break;
	        	}
	        	if(SubTotal == null)
	        	break
	        	if(SubTotal != null && SubTotal != '')
	        		Gtotalvalue += parseInt(SubTotal) ;
	        }
	        //document.getElementById(ClassTotalId).value = Gtotalvalue; 
	        $("."+ClassTotalId).val(Gtotalvalue);
	        //document.getElementsByClassName(ClassTotalId)[0].value = Gtotalvalue;
	    }
	    function NoOfTime(NoOfTimeId,idTotal,idPoint,ClassTotalGive,idGiveCheck,idFreq)
	    {
//	    	var NoOfTime =document.getElementById(NoOfTimeId).value;
			var NoOfTime =document.getElementById(SalesforceID(NoOfTimeId,idFreq)).value;
			var Total = document.getElementById(SalesforceID(NoOfTimeId,idTotal));
		    var Points = document.getElementById(SalesforceID(NoOfTimeId,idPoint));
		    var GiveCheckbox = document.getElementById(SalesforceID(NoOfTimeId,idGiveCheck));
	    	Points = parseInt(Points.innerHTML);
	    	
	    	if(isNaN(Points * NoOfTime))
	    	{
	    		alert('Please Enter Currect Value.');
	    		document.getElementById(NoOfTimeId).value =0;
	    		Total.value= 0;
	    		GiveCheckbox.checked = false;
	    		subTotalValue(NoOfTimeId,idTotal,GiveTotalId);
	    	}
	    	else
	    	{
	    		if(GiveCheckbox.checked)
	    		{
	    			Total.value = Points * NoOfTime ;
	    			if(Total.value == 0 )
	    				GiveCheckbox.checked = false;
	    			//subTotalValue(NoOfTimeId,idTotal,ClassTotalGive);
	    			subTotalValue(NoOfTimeId,idTotal,GiveTotalId);
	    		}
	    	}	
	    }
	    function SalesforceID(textSfId,textId)
	    {
	    	var splitid = textSfId.split(':');
			var strid ='';
	        var currentId='';
	        for(var j=0;j<splitid.length-2;j++)
	        {
	        	strid +=splitid[j]+':';
	        }
	        currentId = splitid[splitid.length-2];
	        return strid+currentId+':'+textId;
	    }
		function gotValue(sfCurrentId,strNotGotId,strAskDenied,strGot,strGotSubTotal,strPoint,ClassTotalGet)
		{
			var splitid = sfCurrentId.split(':');
			var strid ='';
	        var currentId='';
	        for(var j=0;j<splitid.length-2;j++)
	        {
	        	strid +=splitid[j]+':';
	        }
	        currentIdNum = splitid[splitid.length-2];
	        currentId = splitid[splitid.length-1];
	        if(document.getElementById(sfCurrentId).checked)
			{
				if(strNotGotId == currentId)
				{
					document.getElementById(strid+currentIdNum +':'+strGotSubTotal).value =0;
					document.getElementById(strid+currentIdNum +':'+strAskDenied).checked =false;
					document.getElementById(strid+currentIdNum +':'+strGot).checked =false;
				}	
				if(strAskDenied == currentId)	
				{
					document.getElementById(strid+currentIdNum +':'+strGotSubTotal).value =0;
					document.getElementById(strid+currentIdNum +':'+strGot).checked =false;
					document.getElementById(strid+currentIdNum +':'+strNotGotId).checked =false;
				}
				if(strGot == currentId)	
				{
					document.getElementById(strid+currentIdNum +':'+strGotSubTotal).value = document.getElementById(strid+currentIdNum +':'+strPoint).innerHTML ;
					document.getElementById(strid+currentIdNum +':'+strNotGotId).checked =false;
					document.getElementById(strid+currentIdNum +':'+strAskDenied).checked =false;
				}
			}
			else
			{
				document.getElementById(strid+currentIdNum +':'+strGotSubTotal).value =0;
			}
			//subTotalValue(sfCurrentId,strGotSubTotal,ClassTotalGet);
			subTotalValue(sfCurrentId,strGotSubTotal,GotTotalId);
		}
		function cantEdit(SFid)
		{
			return false;
		}
		function blankTemplate(ClassName)
		{
			if(document.getElementsByClassName(ClassName)[0]!= null)
				document.getElementsByClassName(ClassName)[0].value='';
		}
		
		function popupPrintWindow(PageURL)
	 	{
	 		openPopup(PageURL, "lookup", 350, 480, "width=650,height=500,toolbar=no,status=no,directories=no,menubar=no,resizable=yes,scrollable=no", true);
	 	}
	 	function popupWindow(txtValue)
	 	{ 
	 		var URL = 'LookupScoreCardTemplate?lksrch='+document.getElementById('NewScoreCard:idForm:idPageBlock:pgbSecGeneral:pgbSecItem_23:txtTemplate').value;
	 		openPopup(URL, "lookup", 350, 480, "width=650,height=500,toolbar=no,status=no,directories=no,menubar=no,resizable=yes,scrollable=no", true);
	 	}
	 	function changeClass(linkId)
	 	{
	 		document.getElementById(linkId).setAttribute("class", "lookupIconOn");
	 	}
	 	function changeClassRemove(linkId)
	 	{
	 		document.getElementById(linkId).setAttribute("class", "lookupIcon");	
	 	}