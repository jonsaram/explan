<%@ page contentType='text/html;charset=utf-8'%>

<%-- Component Id 설정 --%>
<c:set var="comId" value="financyAnalysisComponent"/>

<script type="text/javascript">

	$(function() {
	});
	
	_G_FN["${comId}"] = {
		/* 콜백함수 필수 등록 */
		 callback 	: undefined
		,init 		: function(sendParm, callback) {
			/* 필수 지정 */
			this.sendParm = sendParm;
			this.callback = callback;
			
			this.loadInsuranceList({});
		}
		// 화면 Load
		,loadInsuranceList : function(sendParm) {
			var renderHtml = $("#${comId}Grid_template").render({});
			$("#${comId}Grid").html(renderHtml);
			
			
/*
			// TD Merge가 필요한경우
			var parm = {
				startIdx 	: 1,
				endIdx		: 1,
				startRowIdx : 2
			}
			mergeTableTD("${comId}Grid", parm);
*/			
			
		}
	}
</script>

<div id="${comId}">
	<div name="pageBlock">
		<h4>Title</h4>
		<div class="list_wrap">
			<div class="table_wrap">
				<table class="list_table" id="${comId}Grid">
				</table>
				<script type="text/x-jsrender" id="${comId}Grid_template" >
						<colgroup>
							<col width="50%">
							<col width="50%">
						</colgroup>
						<tr>
							<th>title1</th>
							<th>title2</th>
						</tr>
						<tr>
							<td class="ctr">1</td>
							<td class="ctr">2</td>
						</tr>
				</script>
			</div>
		</div>
	</div>
</div>
