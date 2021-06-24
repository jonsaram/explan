<%@ page contentType='text/html;charset=utf-8'%>

<%-- Component Id 설정 --%>
<c:set var="comId" value="insuranceBaseAnalysisComponent"/>
<link rel="stylesheet" href="style.css" type="text/css">

<script type="text/javascript">

	_SVC_COM.loadJsFile("/explan/js/class/C_INSURANCE_GROUP.js");
	
	$(function() {
	});
	
	_G_FN["${comId}"] = {
		/* 콜백함수 필수 등록 */
		callback 		: undefined,
		/* Component Title 필수 등록 */
		title			: "보험 기본 분석",
		/* Parameter */
		sendParm		: undefined,
		cInsuranceGroup	: undefined,
		init 		: function(sendParm, callback) {
			/* 필수 지정 */
			this.sendParm			= sendParm;
			this.callback 			= callback;
			this.cInsuranceGroup 	= sendParm.cInsuranceGroup;
			
			/* Module 초기화 */
			this.loadInsuranceList(this.sendParm);
		},
		// 화면 Load
		loadInsuranceList : function(sendParm) {
			var renderHtml = $("#${comId}Grid_template").render(this.cInsuranceGroup);
			$("#${comId}Grid").html(renderHtml);
			var parm = {
				startIdx 	: 1,
				endIdx		: 1,
				startRowIdx : 2
			}
			mergeTableTD("${comId}Grid", parm);
		}
	}
</script>

<div id="${comId}">
	<div name="pageBlock">
		<h4>보험 기본 분석</h4>
		<div class="list_wrap">
			<div class="table_wrap">
				<table class="list_table" id="${comId}Grid">
				</table>
				<script type="text/x-jsrender" id="${comId}Grid_template" >
						<colgroup>
							{{if isExistSubInsured()}}
							<col width="7%">
							<col width="7%">
							<col width="7%">
							<col width="8%">
							<col width="*">
							<col width="7%">
							<col width="9%">
							<col width="7%">
							<col width="7%">
							<col width="6%">
							<col width="4%">
							<col width="8%">
							<col width="9%">
							<col width="7%">
							{{else}}
							<col width="7%">
							<col width="7%">
							<col width="8%">
							<col width="*">
							<col width="8%">
							<col width="8%">
							<col width="6%">
							<col width="8%">
							<col width="8%">
							<col width="4%">
							<col width="10%">
							<col width="11%">
							<col width="9%">
							{{/if}}
						</colgroup>
						<tr>
							{{if isExistSubInsured()}}
							<th>주피보험자			</th>
							<th>종피보험자			</th>
							{{else}}
							<th>피보험자			</th>
							{{/if}}
							<th>보험종류			</th>
							<th>보험회사명			</th>
							<th>보험상품명			</th>
							<th>월납입액			</th>
							<th>가입일				</th>
							<th>납입회수/남은횟수	</th>
							<th>보장기간			</th>
							<th>납입기간			</th>
							<th>상태				</th>
							<th>기납입<br/>보험료	</th>
							<th>납입예정<br/>보험료	</th>
							<th>총보험료</th>
						</tr>
				    {{if gridList && gridList.length ~alltotal=allTotal ~isExistSubInsured=isExistSubInsured()}}
					    {{for gridList}}
						    {{for list}}
							<tr>
								<td class="ctr">{{:mainInsured}}							</td>
								{{if ~isExistSubInsured}}
								<td class="ctr" style="background:{{:getBackColor()}}">{{:getSubInsuredName()}}						</td>
								{{/if}}
								<td class="ctr" style="background:{{:getBackColor()}}">{{:INSURANCE_TYPE}}                 			</td>
								<td class="ctr" style="background:{{:getBackColor()}}">{{:COMPANY_NAME}}		            		</td>
								<td class="ctr" style="background:{{:getBackColor()}}">{{:TITLE}}		                    		</td>
								<td class="ctr" style="background:{{:getBackColor()}}">{{:getPayEachMonth()}}		        		</td>
								<td class="ctr" style="background:{{:getBackColor()}}">{{dt:START_DATE}}		            		</td>
								<td class="ctr" style="background:{{:getBackColor()}}">{{:PAY_COUNT}}/{{:REST_COUNT}}      			</td>
								<td class="ctr" style="background:{{:getBackColor()}}">{{:GUARANTEE_TERM}}{{:GUARANTEE_TERM_TYPE}}	</td>
								<td class="ctr" style="background:{{:getBackColor()}}">{{:PAY_TERM}}{{:PAY_TERM_TYPE}}				</td>
								<td class="ctr" style="background:{{:getBackColor()}}">{{:STATE}}									</td>
								<td class="ctr" style="background:{{:getBackColor()}}">{{:getNowTotalPay()}}						</td>
								<td class="ctr" style="background:{{:getBackColor()}}">{{:getRestTotalPay()}}	            		</td>
								<td class="ctr" style="background:{{:getBackColor()}}">{{:getTotalPay()}}			        		</td>
							</tr>
							{{/for}}
							<tr>
								<td class="ctr"								>{{:total.mainInsured}}				</td>
								{{if ~isExistSubInsured}}
								<td class="ctr" colspan="4"					>계 : 								</td>
								{{else}}
								<td class="ctr" colspan="3"					>계 : 								</td>
								{{/if}}
								<td class="ctr del_leftline"				>{{:total.getSumPayEachMonth()}}	</td>
								<td class="ctr del_leftline" colspan="5"	>&nbsp;								</td>
								<td class="ctr del_leftline"				>{{:total.getSumNowTotalPay()}}		</td>
								<td class="ctr del_leftline"				>{{:total.getSumRestTotalPay()}}	</td>
								<td class="ctr del_leftline"				>{{:total.getSumTotalPay()}}		</td>
							</tr>
						{{/for}}
							<tr>
								{{if ~isExistSubInsured}}
								<td class="ctr" colspan="5"					>총계 :								</td>
								{{else}}
								<td class="ctr" colspan="4"					>총계 :								</td>
								{{/if}}
								<td class="ctr del_leftline"				>{{:~alltotal.getSumPayEachMonth()}}</td>
								<td class="ctr del_leftline" colspan="5"	>&nbsp;								</td>
								<td class="ctr del_leftline"				>{{:~alltotal.getSumNowTotalPay()}}	</td>
								<td class="ctr del_leftline"				>{{:~alltotal.getSumRestTotalPay()}}</td>
								<td class="ctr del_leftline"				>{{:~alltotal.getSumTotalPay()}}	</td>
							</tr>
					{{else}}
						<tr>
							<td colspan="12">&nbsp;</td>
						</tr>
					{{/if}}
				</script>
			</div>
		</div>
	</div>
</div>


