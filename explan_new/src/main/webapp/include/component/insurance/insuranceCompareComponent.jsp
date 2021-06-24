<%@ page contentType='text/html;charset=utf-8'%>

<%-- Component Id 설정 --%>
<c:set var="comId" value="insuranceCompareComponent"/>

<script type="text/javascript">

	_SVC_COM.loadJsFile("/explan/js/class/C_INSURANCE_GROUP.js");
	
	$(function() {
	});
	
	_G_FN["${comId}"] = {
		/* Component Title 필수 등록 */
		title				: "보험 기본 비교",
		/* Parameter */
		sendParm			: undefined,
		cInsuranceGroupase	: undefined,
		cInsuranceGroup		: undefined,
		/* 콜백함수 필수 등록 */
		callback 	: undefined,
		init 		: function(sendParm, callback) {
			/* 필수 지정 */
			this.sendParm = sendParm;
			this.callback = callback;

			if(!isValid(_SESSION["BASE_PLAN_NUM"])) return;
			
			var cInsuranceGroup 		= sendParm.cInsuranceGroup;
			
			var cInsuranceGroupBase 	= sendParm.cInsuranceGroupBase;
			
			var renderHtml = $("#${comId}Grid_template").render({base : cInsuranceGroupBase, change : cInsuranceGroup });
			$("#${comId}Grid").html(renderHtml);
			
			var parm = {
				 startIdx 	: 1
				,endIdx 	: 1
			}
			mergeTableTD("${comId}Grid_left", parm);
			mergeTableTD("${comId}Grid_right", parm);
			
			//this.loadInsuranceList();
		},
		// 화면 Load
		loadInsuranceList : function() {
			var renderHtml = $("#${comId}Grid_template").render(this.cInsuranceGroupBase);
			$("#${comId}Grid").html(renderHtml);
		}
	}
</script>
<div id="${comId}">
	<div name="pageBlock">
		<div class="list_wrap">
			<div class="table_wrap">
				<table class="list_table" id="${comId}Grid">
				</table>
				<script type="text/x-jsrender" id="${comId}Grid_template" >
					<colgroup>
						<col width="50%">
						<col width="50%">
					</colgroup>
					<tr class="no_padding">
						<td>
							<table class="list_table" style="min-width:300px;">
								<tr>
									<th class="add_rightline">기존 보험 목록</th>
								</tr>
							</table>
						</td>
						<td>
							<table class="list_table" style="min-width:300px;">
								<tr>
									<th>제안 보험 목록</th>
								</tr>
							</table>
						</td>
					</tr>
					<tr class="no_padding top">
						<td>
							<table class="list_table" style="min-width:300px" id="${comId}Grid_left">
								<colgroup>
									<col width="20%">
									<col width="20%">
									<col width="20%">
									<col width="20%">
									<col width="20%">
								</colgroup>
								<tr>
									<th>주피보험자</th>
									<th>종피보험자</th>
									<th>보험사</th>
									<th>상품명</th>
									<th class="add_rightline">월납입액</th>
								</tr>
						{{if base.gridList && base.gridList.length ~alltotal=base.allTotal ~isExistSubInsured=base.isExistSubInsured()}}
						  {{for base.gridList}}
						    {{for list}}
								{{if DUMMY == "Y"}}
								<tr>
									<td class="ctr">{{:mainInsured}}	</td>
									<td class="ctr">&nbsp;				</td>
									<td class="ctr">&nbsp;				</td>
									<td class="ctr">&nbsp;				</td>
									<td class="rgt add_rightline">&nbsp;</td>
								</tr>
								{{else}}
								<tr>
									<td class="ctr">{{:mainInsured}}		</td>
									<td class="ctr">{{:getSubInsuredName()}}</td>
									<td class="ctr">{{:COMPANY_NAME}}		</td>
									<td class="ctr">{{:TITLE}}				</td>
									<td class="rgt add_rightline"				>{{:getPayEachMonth()}}				</td>
								</tr>
								{{/if}}
							{{/for}}
								<tr>
									<td											>{{:total.mainInsured}}				</td>
									<td class="ctr" colspan="3"					>계: </td>
									<td class="rgt del_leftline add_rightline"	>{{:total.getSumPayEachMonth()}}	</td>
								</tr>
						  {{/for}}
								<tr>
									<td class="ctr" colspan="4"					>총계 :								</td>
									<td class="rgt del_leftline add_rightline"	>{{:~alltotal.getSumPayEachMonth()}}</td>
								</tr>
						{{else}}
								<tr>
									<td colspan="5">&nbsp;</td>
								</tr>
								<tr>
									<td class="ctr" colspan="4"					>총계 :								</td>
									<td class="rgt del_leftline add_rightline"	>0									</td>
								</tr>
						{{/if}}
							</table>
						</td>
						<td>
							<table class="list_table" style="min-width:300px;" id="${comId}Grid_right">
								<colgroup>
									<col width="17%">
									<col width="17%">
									<col width="17%">
									<col width="17%">
									<col width="17%">
									<col width="15%">
								</colgroup>
								<tr>
									<th>주피보험자</th>
									<th>종피보험자</th>
									<th>보험사</th>
									<th>상품명</th>
									<th>월납입액</th>
									<th>상태</th>
								</tr>
						{{if change.gridList && change.gridList.length ~alltotal=change.allTotal ~isExistSubInsured = change.isExistSubInsured()}}
						  {{for change.gridList}}
						    {{for list}}
								<tr>
									<td class="ctr"										  >{{:mainInsured}}			</td>
									<td class="ctr" style="background:{{:getBackColor()}}">{{:getSubInsuredName()}}	</td>
									<td class="ctr" style="background:{{:getBackColor()}}">{{:COMPANY_NAME}}		</td>
									<td class="ctr" style="background:{{:getBackColor()}}">{{:TITLE}}				</td>
									<td class="rgt" style="background:{{:getBackColor()}}">{{:getPayEachMonth()}}	</td>
									<td class="ctr" style="background:{{:getBackColor()}}">{{:STATE}}				</td>
								</tr>
							{{/for}}
								<tr>
									<td										>{{:total.mainInsured}}				</td>
									<td class="ctr" colspan=3				>계: </td>
									<td class="rgt del_leftline"			>{{:total.getSumPayEachMonth()}}	</td>
									<td class="ctr del_leftline"			></td>
								</tr>
						  {{/for}}
								<tr>
									<td class="ctr" colspan="4"				>총계 :								</td>
									<td class="rgt del_leftline"			>{{:~alltotal.getSumPayEachMonth()}}</td>
									<td class="rgt del_leftline"			>&nbsp;</td>
								</tr>
						{{else}}
								<tr>
									<td colspan="5">&nbsp;</td>
								</tr>
								<tr>
									<td class="ctr" colspan="4"				>총계 :								</td>
									<td class="rgt del_leftline"			>0									</td>
									<td class="rgt del_leftline"			>&nbsp;								</td>
								</tr>
						{{/if}}
							</table>
						</td>
					</tr>
					
				</script>
			</div>
		</div>
	</div>
</div>
