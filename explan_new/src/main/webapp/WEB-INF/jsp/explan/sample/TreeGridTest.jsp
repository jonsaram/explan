<%@ page contentType='text/html;charset=utf-8'%>

<!DOCTYPE html>
<html>
<head>

<meta charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<title>SysnetWeb Modelo</title>

<link rel="stylesheet" type="text/css" 					href="/js/modelo/dhtmlx/codebase/dhtmlx.css" 	/>
<script type="text/javascript" 							src="/js/modelo/jquery-1.9.0.min.js"            ></script>
<script type="text/javascript"							src="/js/modelo/dhtmlx/codebase/dhtmlx.js"		></script>



<script type="text/javascript">

$(document).ready(function(){
	
	
	
	var data = {
		        "rows": [
		            {
		                "id": "MN-0000000136",
		                "data": [
		                    "Community",
		                    "MN-0000000136",
		                    "0",
		                    "0",
		                    null,
		                    null,
		                    null,
		                    null,
		                    1,
		                    null,
		                    "N",
		                    "eunee.kwon",
		                    "권노은",
		                    "2014-11-26 02:47:26:17",
		                    "eunee.kwon",
		                    "권노은",
		                    "2014-11-26 02:47:26:17"
		                ],
		                "rows": [
		                    {
		                        "id": "MN-0000000143",
		                        "data": [
		                            "DD Board",
		                            "MN-0000000143",
		                            "1",
		                            "MN-0000000136",
		                            null,
		                            null,
		                            null,
		                            null,
		                            1,
		                            null,
		                            "N",
		                            "eunee.kwon",
		                            "권노은",
		                            "2014-11-26 03:00:26:13",
		                            "eunee.kwon",
		                            "권노은",
		                            "2014-11-26 03:00:26:13"
		                        ]
		                    }
		                ]
		            },
		            {
		                "id": "MN-0000000137",
		                "data": [
		                    "MVT Management",
		                    "MN-0000000137",
		                    "0",
		                    "0",
		                    null,
		                    null,
		                    null,
		                    null,
		                    2,
		                    null,
		                    "N",
		                    "eunee.kwon",
		                    "권노은",
		                    "2014-11-26 02:48:26:09",
		                    "eunee.kwon",
		                    "권노은",
		                    "2014-11-26 02:48:26:09"
		                ]
		            },
		            {
		                "id": "MN-0000000138",
		                "data": [
		                    "Model Management",
		                    "MN-0000000138",
		                    "0",
		                    "0",
		                    null,
		                    null,
		                    null,
		                    null,
		                    3,
		                    null,
		                    "N",
		                    "eunee.kwon",
		                    "권노은",
		                    "2014-11-26 02:48:26:09",
		                    "eunee.kwon",
		                    "권노은",
		                    "2014-11-26 02:48:26:09"
		                ]
		            },
		            {
		                "id": "MN-0000000139",
		                "data": [
		                    "Review",
		                    "MN-0000000139",
		                    "0",
		                    "0",
		                    null,
		                    null,
		                    null,
		                    null,
		                    4,
		                    null,
		                    "N",
		                    "eunee.kwon",
		                    "권노은",
		                    "2014-11-26 02:48:26:09",
		                    "eunee.kwon",
		                    "권노은",
		                    "2014-11-26 02:48:26:09"
		                ]
		            },
		            {
		                "id": "MN-0000000140",
		                "data": [
		                    "Audit",
		                    "MN-0000000140",
		                    "0",
		                    "0",
		                    null,
		                    null,
		                    null,
		                    null,
		                    5,
		                    null,
		                    "N",
		                    "eunee.kwon",
		                    "권노은",
		                    "2014-11-26 02:48:26:09",
		                    "eunee.kwon",
		                    "권노은",
		                    "2014-11-26 02:48:26:09"
		                ]
		            },
		            {
		                "id": "MN-0000000141",
		                "data": [
		                    "My Work",
		                    "MN-0000000141",
		                    "0",
		                    "0",
		                    null,
		                    null,
		                    null,
		                    null,
		                    6,
		                    null,
		                    "N",
		                    "eunee.kwon",
		                    "권노은",
		                    "2014-11-26 02:48:26:09",
		                    "eunee.kwon",
		                    "권노은",
		                    "2014-11-26 02:48:26:09"
		                ]
		            },
		            {
		                "id": "MN-0000000142",
		                "data": [
		                    "Admin",
		                    "MN-0000000142",
		                    "0",
		                    "0",
		                    null,
		                    null,
		                    null,
		                    null,
		                    7,
		                    null,
		                    "N",
		                    "eunee.kwon",
		                    "권노은",
		                    "2014-11-26 02:48:26:09",
		                    "eunee.kwon",
		                    "권노은",
		                    "2014-11-26 02:48:26:09"
		                ]
		            }
		        ]
		    }
		
	
			var data2 = {
					rows:[
					      { id:'1001', 
					       data:[
					        {"value":"row A","image":"folder.gif"},
					        "A Time to Kill",
					        "John Grisham",
					        "12.99",
					        "1",
					        "05/01/1998"],
					      rows:[
					  	    { id:'1001333', 
					  	 data:[
					  	      "subrowA",
					  		  "Blood and Smoke",
					  	      "Stephen King",
					  	      "0",
					  	      "1",
					  	      "01/01/2000"
					  		  ]
					  		  },
					  	    { id:'1001334', 
					  	 data:[
					  	      "subrowB",
					  	      "Blood and Smoke",
					  	      "Stephen King",
					  	      "0",
					  	      "1",
					  	      "01/01/2000"] }
					      ]
					   },
					     { id:'1002', 
					       xmlkids:'1',
					   data:[
					        "row B",
					        "The Green Mile",
					        "Stephen King",
					        "11.10",
					        "1",
					        "01/01/1992"] }
					        ]
					  };

			var mygrid = new dhtmlXGridObject('gridbox');
			mygrid.setImagePath("/js/modelo/dhtmlx/codebase/imgs/");
			mygrid.setHeader("Tree,Plain Text,Long Text,Color,Checkbox");
			mygrid.setColumnIds("tree,title,name,price,date")
			mygrid.setInitWidths("150,100,100,100,100")
			mygrid.setColAlign("left,left,left,left,center")
			mygrid.setColTypes("tree,ed,txt,ch,ch");
			mygrid.setColSorting("str,str,str,na,str")

			mygrid.init();
			mygrid.setSkin("dhx_skyblue")
		   	mygrid.parse(data, "json");
			
			
});


		

</script>


<!-- list -->
<div class="list_wrap">
	<!-- list_table -->
	<div id="gridbox" style="width:1000px;height:500px"></div>
</div>
<%@include  file="/modelo/include/footer.jsp" %>
