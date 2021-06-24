<%@ page contentType='text/html;charset=utf-8'%>

<%-- 
	-- Popup 호출 하는 방법 예제
	
	_SVC_POPUP.setConfig("popupIdAdp", sendParm, function(returnData) {
		alert(returnData);
	});
	_SVC_POPUP.show("popupIdAdp");

 --%>

<%-- Popup Id 설정 --%>
<% String popupIdAdp = "addDamboPopup"; %>

<script type="text/javascript">

	$(function() {
		_SVC_POPUP.initPopup("<%=popupIdAdp%>");
	});
	
	_G_FN["<%=popupIdAdp%>"] = {
		/* 콜백함수 필수 등록 */
		callback 		: undefined,
		guaranteeTerm	: undefined,
		deleteDamboList : [],
		isSaved			: false,
		init 		: function(sendParm, callback) {
			/* 필수 지정 */
			_G_FN["<%=popupIdAdp%>"].callback = callback;
			
			// Category List 가져오기
			var resultInfo 	= requestService("GET_COMMON", {"sqlId" : "Insurance.getDamboList"});
			
			var damboList = resultInfo.data;

			var userDamboList = [];
			
			$.each(damboList, function() {
				if(this.USER_ID == '${loginId}') userDamboList.push(this);
			});
			
			// CATEGORY_NAME Combo 처리위한 DD값 세팅
			if(_DD_MAP["CATEGORY_NAME"] == undefined) {
				_DD_MAP		["CATEGORY_NAME"] = {};
				_DD_CODE_MAP["CATEGORY_NAME"] = {};
				$.each(damboList, function() {
					_DD_MAP		["CATEGORY_NAME"][this.CATEGORY_NAME] = this.CATEGORY_NAME;
					_DD_CODE_MAP["CATEGORY_NAME"][this.CATEGORY_NAME] = this.CATEGORY_NUM;
				});
			}
			
			// 
			var validatorList = {};
			validatorList["CATEGORY_NAME"] = function(cellData) {
				if(isValid(_DD_MAP["CATEGORY_NAME"][cellData]))	return true;
				else											return false;
			}			
			validatorList["DAMBO_NAME"] = function(cellData) {
				if(isValid(cellData))	return true;
				else					return false;
			}			
			
			var orderList = "[!CB],[!RN],[!HD]DAMBO_NUM,CATEGORY_NAME,DAMBO_NAME";
			
	  		var columnConfig 	= {
	  			"CATEGORY_NAME" : { "colType" : "combo"}
	  		}
			
	 		var gridParm = {
				"targetDivId"	: "<%=popupIdAdp%>_gridbox"	,
				"orderList" 	: orderList				,
	 			"gridData"		: userDamboList			,
				"cellConfig"	: {
					"defaultConfig" : {
						"width" 		: "*"		,
						"align" 		: "left"	,
						"colType" 		: "edtxt"
					},
					"columnConfig" 	: columnConfig
				},
				"validatorList"	: validatorList	,
	 			"useBlockCopy"	: true			,
	 			"pasteAutoExtend": true				// 복사 붙여 넣기 할때 붙여넣는 항목이 더 많을경우, 자동으로 Row수를 늘려서 맞춤.
			}
			var mygrid = explanGrid.makeGrid(gridParm);
	  		
	  		if(userDamboList.length == 0) _G_FN["<%=popupIdAdp%>"].addRow();
		},
		addRow : function() {
			var empty = explanGrid.isEmpty("<%=popupIdAdp%>_gridbox");
			var rowId = explanGrid.addRow("<%=popupIdAdp%>_gridbox");
			return rowId;
		},
		delRow : function() {
			rowIdList = explanGrid.getCheckedRowId("<%=popupIdAdp%>_gridbox", "[!CB]");
			$.each(rowIdList, function() {
				var damboNum = explanGrid.getValueById("<%=popupIdAdp%>_gridbox", this, "DAMBO_NUM");
				if(isValid(damboNum)) {
					_G_FN["<%=popupIdAdp%>"].deleteDamboList.push(damboNum);
				}
				explanGrid.deleteRowById("<%=popupIdAdp%>_gridbox", this);
			});
		},
		goSave : function() {
			var isEmpty = explanGrid.isEmpty("<%=popupIdAdp%>_gridbox");
			if(isEmpty) {
				alert("저장 할 내용이 없습니다.");
				return;
			}
			var changeCheck = explanGrid.isChanged("<%=popupIdAdp%>_gridbox");
			if(!changeCheck) {
				alert("변경 내용이 없습니다.");
				return;
			}

			var resultMap 	= explanGrid.validCheckAllGrid("<%=popupIdAdp%>_gridbox");
			
			if(!resultMap.valid) {
				alert(resultMap.getMsg());
				return;
			}
			var jsonData 	= explanGrid.getGridToJson("<%=popupIdAdp%>_gridbox", null, "C");
			$.each(jsonData, function() {
				this.CATEGORY_NUM = _DD_CODE_MAP["CATEGORY_NAME"][this.CATEGORY_NAME];
			});
			var sendParm = {
				 "userDamboList" 	: jsonData
				,"deleteDamboList"	: _G_FN["<%=popupIdAdp%>"].deleteDamboList.join()
			}
			var resultInfo = requestService("SAVE_USER_DAMBO_LIST", sendParm);

			if(resultInfo.state == "S"){
				alert('저장 되었습니다.');
				explanGrid.clearChanged("<%=popupIdAdp%>_gridbox");

				_G_FN["<%=popupIdAdp%>"].deleteDamboList = [];
				
				_G_FN["<%=popupIdAdp%>"].isSaved = true;
				
			} else 	{
				alert(resultInfo.msg);
			}
		},
		close : function(retParm) {
			var changeCheck = explanGrid.isChanged("<%=popupIdAdp%>_gridbox");
			_G_FN["<%=popupIdAdp%>"].callback({changeCheck:_G_FN["<%=popupIdAdp%>"].isSaved});
			_SVC_POPUP.hide("<%=popupIdAdp%>");
			_G_FN["<%=popupIdAdp%>"].isSaved = false;
		}
	}
	
	function close() {
		_G_FN["<%=popupIdAdp%>"].close();
	}
</script>

<div class="layer_pop_wrap" style="visibility:hidden" id="<%=popupIdAdp%>">
	<div class="layer_pop" style="width:500px">
		<div class="tit_layer">담보 항목 추가</div>
		<div class="contents">
			<div class="list_wrap">
				<div class="list_head">
					<div class="button" id="btnEdit">
						<span class="btn_list"><a href="javascript:var tmp = _G_FN['<%=popupIdAdp%>'].addRow();">항목 추가</a></span>
						<span class="btn_list"><a href="javascript:_G_FN['<%=popupIdAdp%>'].delRow();">항목 삭제</a></span>
					</div>
				</div>
				<div style="width:100%;height:500px">
					<div id="<%=popupIdAdp%>_gridbox" style="width:100%;height:100%"></div>				
				</div>
			</div>
		</div>
		<div class="pop_button">
			<span class="btn_page"><a href="#Close" onClick="explanGrid.execAfterEdit('<%=popupIdAdp%>_gridbox', _G_FN['<%=popupIdAdp%>'].goSave)">저장</a></span>
			<span class="btn_page"><a href="#Close" onClick="_G_FN['<%=popupIdAdp%>'].close()">닫기</a></span>
		</div>
	</div>
</div>
