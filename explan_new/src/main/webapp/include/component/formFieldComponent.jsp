<%@ page contentType="text/html;charset=utf-8" %>

<%--
	- 20141202 위성열

	- 사용 방법
	1. 페이지 상단에 본 Compoenet를 include 한다.
		ex) 
			<!-- Form Field Component -->
			<%@include  file="/modelo/include/component/formFieldComponent.jsp" %>
	2. Component를 Loading할 위치에 make로 시작하는 각 컴포넌트 Method를 실행한다.
		ex)
			.
			.
			.
			<td>
				<!-- multi_input_box -->
				<script> _COMPONENT.makeMultiInputBox('projectCode'); </script>
			</td>
			.
			.
--%>

<script>
	var _COMPONENT = {
		// Common Config Data
		_CONFIG_DATA : {},
		
		/*
			Multi Input Box
			Type : MIB
		*/
		settingMultiInputBox : function(inputId) {
			var inputIdList = $("#" + inputId + "Text").val().trim();
			var inputIdArray = inputIdList.split("\n");
			var cnt = inputIdArray.length;
			var inputStr = inputIdArray[0];
			if(cnt > 1) inputStr += " 외 " + (cnt - 1) + "건";
			$("#" + inputId + "View").val(inputStr);
			$("#" + inputId + "Component .area_box").hide();
			var val = this.getValue(inputId);
			$("#" + inputId).val(val);
		},
		clearMultiInputBox : function (inputId) {
			$("#" + inputId).val("");
			$("#" + inputId + "Text").val("");
			$("#" + inputId + "View").val("All");
			$("#" + inputId + "Component .area_box").hide();
		},
		makeMultiInputBox	: function(inputId) {
			var jsonData = { inputId : inputId };
			this._CONFIG_DATA[inputId] = { type : "MIB" };
			var renderResult = $("#multiInputBox_template").render(jsonData);
			document.write(renderResult);
		},
		insertMultiInputBox	: function(inputId, targetId) {
			var jsonData = { inputId : inputId };
			this._CONFIG_DATA[inputId] = { type : "MIB" };
			var renderResult = $("#multiInputBox_template").render(jsonData);
			$("#" + targetId).html(renderResult);
			this.setComponentEvent();
		},
		multiInputBoxViewChange : function(inputId, domObj) {
			var val = $(domObj).val();
			$("#" + inputId).val(val);
		},
		/*
			Multi Select Box
			Type : MSB
		*/
		
		// 현재 위치에 직접 삽입
		makeMultiSelectBox	: function(inputId, commonTcd, config) {
			var renderResult = this.makeHtmlMultiSelectBox(inputId, commonTcd, config);
			document.write(renderResult);
			this.multiSelectBoxInit(inputId);
		},
		insertMultiSelectBox: function(targetId, inputId, commonTcd, config) {
			var renderResult = this.makeHtmlMultiSelectBox(inputId, commonTcd, config);
			alert(renderResult);
			$("#" + targetId).html(renderResult);
			this.multiSelectBoxInit(inputId);
			this.setComponentEvent();
		},
		// 컴포넌트 HTML 생성
		makeHtmlMultiSelectBox	: function(inputId, commonTcd, config) {
			if(config == undefined) config = { initCheck : true };
			if(config.initCheck == undefined) config.initCheck = true; 
			var list;
			if(typeof commonTcd == "string") 	list 	= _SVC_COM.getDDList(commonTcd);
			else								list 	= commonTcd;
			if(config.viewType == "code") {
				$.each(list, function() {
					this.COMMON_NAME_EN = this.COMMON_CODE;
				});
			}
			var codeMap	= arrayToMap(list, "COMMON_CODE", "COMMON_NAME_EN");
			this._CONFIG_DATA[inputId] = {
				type 	: "MSB"		,
				codeMap : codeMap	,	// 코드값에 대한 코드 Name 값 Mapping 정보
				config	: config		// 초기값 initCheck : [true/false] 생략 가능] - true => check된상태, false : check 안된상태
			};
			var jsonData = { inputId : inputId, list : list };
			var renderResult = $("#multiSelectBox_template").render(jsonData);
			return renderResult
		},
		allChangeMultiSelectBox	: function(checkVal, inputId) {
			var componentId = inputId + "Component";
			
			$("#" + componentId + " input[name="+inputId+"_cb]").each(function () {
				this.checked = checkVal;
			});
		},
		changeMultiSelectBox	: function(inputId) {
			var componentId = inputId + "Component";
			var resultAllCheck = true;	
			$("#" + componentId + " input[name="+inputId+"_cb]").each(function () {
				if(!this.checked) { resultAllCheck = false; return false; }
			});
			var cb = document.getElementById(inputId+"_cbAll");
			cb.checked = resultAllCheck;
		},
		setMultiSelectBoxData	: function(inputId) {
			var componentId 	= inputId + "Component";
			var codeMap			= this._CONFIG_DATA[inputId].codeMap;
			var resultData = "";
			var fItem = "";
			var cnt = -1;
			$("#" + componentId + " input[name="+inputId+"_cb]:checked").each(function(idx) {
				if(idx == 0) 	{
					resultData 	=  this.value;
					fItem		=  this.value;
				}
				else			resultData += "," + this.value;
				cnt = idx;
			});
			if(cnt == -1) {
				$("#" + componentId + " input[name="+inputId+"_cb]").each(function () {
					this.checked = true;
				});
				var cb = document.getElementById(inputId+"_cbAll");
				cb.checked = true;
				this.setMultiSelectBoxData(inputId);
				return;
			}
			var viewData = "All";
			if($("#" + componentId + " input[name="+inputId+"_cb]").length > (cnt + 1) ) {
				viewData = codeMap[fItem] + " 외 " + cnt + " 건";
				if(cnt == 0) viewData = codeMap[fItem];
			}
			var cb = document.getElementById(inputId+"_cbAll");
			if(cb.checked) resultData = "";
			$("#" + componentId + " #" + inputId).val(resultData);
			$("#" + componentId + " #" + inputId + "View").val(viewData);
		},
		// 설정한 값으로 Setting
		multiSelectBoxOk	: function(inputId) {
			this.setMultiSelectBoxData(inputId);
			$("#" + inputId + "Component .chk_box").hide();
		},
		// Component를 초기화 한다.
		multiSelectBoxInit: function(inputId) {
			var config = this._CONFIG_DATA[inputId].config;

			this.allChangeMultiSelectBox(config.initCheck, inputId);
			var cb = document.getElementById(inputId+"_cbAll");
			cb.checked = config.initCheck;

			this.setMultiSelectBoxData(inputId);
			$("#" + inputId + "Component .chk_box").hide();
		},
		/*
			공통
		*/
		getValue			: function(inputId) {
			if(this._CONFIG_DATA[inputId] == undefined) {
				alert(inputId + " ID로 생성된 컴포넌트가 없습니다.");
				return;
			}
			var comType = this._CONFIG_DATA[inputId].type;
			if		(comType == "MIB") {
				var componentId = inputId + "Component";
				var mVal = $("#" + componentId + " #" + inputId + "Text").val();
				var sVal = $("#" + componentId + " #" + inputId + "View").val();
				
				// MultiBox 우선
				if(isValid(mVal, 1)) {
					return mVal.replaceAll("\r", "").replaceAll("\n", ",");
				} else {
					// MultiBox가 없는경우 SingleBox처리
					if(sVal == "All") sVal = "";
					return sVal;
				}
			} else {
				// Type에 대한 정의가 없는경우 Default실행
				return $("#" + componentId + " #" + inputId).val();
			}
		},
		setComponentEvent : function() {
			$(".ico_dropdown, .ico_sdwrap").unbind("click");
			$(".ico_dropdown, .ico_sdwrap").bind("click", function(){
				$(this).next().toggle();
				$(".ico_dropdown, .ico_sdwrap").not(this).next().hide();
			});
		}
		
	}
</script>

<!-- Multi Input Box Template-->
<script type="text/x-jsrender" id="multiInputBox_template">
	<div class="form_dropdown_wrap" id="{{:inputId}}Component">
		<input type="text" id="{{:inputId}}View" name="{{:inputId}}View" class="text" value="All" onChange="_COMPONENT.multiInputBoxViewChange('{{:inputId}}', this)"> 
		<a href="#" class="ico_dropdown">Input DEV. PJT Code</a>
		<div class="area_box">
			<div class="area">
				<textarea id="{{:inputId}}Text" name="{{:inputId}}Text" rows="" cols="" class="textarea"></textarea>
				<input type="hidden" id="{{:inputId}}" name="{{:inputId}}"/> 
			</div>
			<div class="layer_button">
				<span class="btn_srch"><a href="javascript:_COMPONENT.settingMultiInputBox('{{:inputId}}')">OK</a></span> 
				<span class="btn_srch"><a href="javascript:_COMPONENT.clearMultiInputBox('{{:inputId}}')">Cancel</a></span>
			</div>
		</div>
	</div> 
</script>

<!-- Multi Select Box Template -->
<script type="text/x-jsrender" id="multiSelectBox_template">
	<div class="form_dropdown_wrap" id="{{:inputId}}Component">
		<input type="text" 		id="{{:inputId}}View" 	name="{{:inputId}}View" class="text" value="All" readOnly> 
		<input type="hidden" 	id="{{:inputId}}" 		name="{{:inputId}}" 	class="text" value="">
		<a href="#" class="ico_dropdown">Select Approval Status</a>
		<div class="chk_box">
			<ul>
				<li class="chkAll"><input type="checkbox" id="{{:inputId}}_cbAll" name="{{:inputId}}_cbAll" class="check" onChange="_COMPONENT.allChangeMultiSelectBox(this.checked, '{{:inputId}}')"><label for="#All">All</label></li>
			{{if list && list.length}}
			  {{for list ~inputId=inputId}}
			    <li><input type="checkbox" id="{{>~inputId}}_{{:COMMON_CODE}}_cb" name="{{>~inputId}}_cb" class="check" value="{{:COMMON_CODE}}" onClick="_COMPONENT.changeMultiSelectBox('{{>~inputId}}')"><label for="#Status1">{{:COMMON_NAME_EN}}</label></li>
			  {{/for}}
			{{/if}}
			</ul>
			<div class="layer_button">
				<span class="btn_srch"><a href="javascript:_COMPONENT.multiSelectBoxOk('{{:inputId}}')">OK</a></span>
				<span class="btn_srch"><a href="javascript:_COMPONENT.multiSelectBoxInit('{{:inputId}}')">Cancel</a></span>
			</div>
		</div>
	</div>
</script>
