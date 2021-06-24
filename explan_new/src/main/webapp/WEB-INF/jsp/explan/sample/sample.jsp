<%@ page language="java" errorPage="/explan/common/error.jsp" pageEncoding="UTF-8" contentType="text/html;charset=utf-8" %>

<%@include  file="/include/headerBaseSet.jsp" %>


<!-- UI 작성 부분 -->
<!-- 보험 기본 분석 Component  -->









<!----------------------------->

<!-- 보험 담보 분석 Component  -->







<div class="layer_pop_wrap" id="popupIdDgmp">
	<div class="layer_pop" style="width:1200px">
		<div class="tit_layer">담보 그룹 관리</div>
		<div class="contents">
			<div class="table_wrap" style="margin-bottom:10px">
				<table class="list_table">
					<colgroup>
						<col width="200">
						<col width="*">
					</colgroup>
					<tbody>
						<tr>
							<th>담보 그룹 선택</th>
							<td>담보 그룹 선택</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="div_wrap">
				<div class="div_left">
					<h4>담보 선택</h4>
					<div class="list_wrap">
						<div class="list_head">
							<div class="button" id="btnEdit">
								<span class="btn_list"><a href="javascript:_G_FN['popupIdDgmp'].damboGroupInfoManagePopup();">담보그룹 정보관리</a></span>
							</div>
						</div>
						<div style="width:100%;height:400px">
							<div id="popupIdDgmp_gridboxDambo" style="width:100%;height:100%"></div>
						</div>
					</div>
				</div>
				<div class="div_right">
					<h4>담보 선택 요약</h4>
					<div class="list_wrap">
						<div class="list_head">
							<div class="button" id="btnEdit">
								<span class="btn_list"><a href="javascript:_G_FN['popupIdDgmp'].deleteDamboSummaryRow();">선택담보제외</a></span>
							</div>
						</div>
						<div style="width:100%;height:400px">
							<div id="popupIdDgmp_gridboxDamboSummary" style="width:100%;height:100%"></div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="pop_button">
			<span class="btn_page"><a href="#Close" onClick="_G_FN['popupIdDgmp'].goSave()">저장</a></span>
			<span class="btn_page"><a href="#Close" onClick="_G_FN['popupIdDgmp'].close()">닫기</a></span>
		</div>
	</div>
</div>

<!----------------------------->



<%@include  file="/include/footerBaseSet.jsp" %>
