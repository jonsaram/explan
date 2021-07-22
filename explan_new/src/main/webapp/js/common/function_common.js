	// 숫자 컴마 찍기
	function addComma(src)
	{
		var srcArr = (src + "").split(".");
		
		src = Number(srcArr[0]);
		
		var fl = srcArr[1];
		
		if(fl == undefined) 	fl = "";
		else					fl = "." + fl;
		
		src = src + "";
		if(!isNumber(src)) return src;
	    var temp_str = src.replace(/,/g, ""); 

		for(var i = 0 , retValue = String() , stop = temp_str.length; i < stop ; i++)
		{
			retValue = ((i%3) == 0) && i != 0 ? temp_str.charAt((stop - i) -1) + "," + retValue : temp_str.charAt((stop - i) -1) + retValue; 
		}

		return retValue + fl;
	} 
	/**
	 *    orgChar 문자열에서 rmChar문자열을 없애고 리턴한다
	 *    계좌번호나 금액에서 '-'나 ','를 제거할때 사용한다
	 *    (2002.06.07)
	 */
	function removeChar(orgChar, rmChar){
	    return replace(orgChar,rmChar,"");
	}

	/**
	 *  문자열에 있는 특정문자패턴을 다른 문자패턴으로 바꾸는 함수.
	 */
	function replace(targetStr, searchStr, replaceStr)
	{
	    var len, i, tmpstr;

	    len = targetStr.length;
	    tmpstr = "";

	    for ( i = 0 ; i < len ; i++ ) {
	        if ( targetStr.charAt(i) != searchStr ) {
	            tmpstr = tmpstr + targetStr.charAt(i);
	        }
	        else {
	            tmpstr = tmpstr + replaceStr;
	        }
	    }
	    return tmpstr;
	}

	// 두 년 월의 차이를 월단위로 리턴해준다.
	function getDistanceMonth(startMonth, endMonth)
	{
		startMonth 	= startMonth.replaceAll("-", "");
		startMonth 	= startMonth.replaceAll("/", "");
		endMonth 	= endMonth.replaceAll("-", "");
		endMonth 	= endMonth.replaceAll("/", "");
		
		var sy = startMonth.substr(0, 4);
		var sm = startMonth.substr(4, 2);

		var ey = endMonth.substr(0, 4);
		var em = endMonth.substr(4, 2);
		
		var dy = ey - sy;
		var dm = em - sm;
		
		if(dm < 0) 
		{
			dy--;
			dm = 12 + dm;
		}
		
		return dy * 12 + dm;
	}
	// 두 년 월의 차이를 일 단위로 반환한다.
	function dateCompare(sDate, eDate, split_str) 
	{

		var sp_sDate = sDate.split(split_str); 
		var sp_eDate = eDate.split(split_str);
		var sDate = new Date();
		sDate.setFullYear(sp_sDate[0],sp_sDate[1],sp_sDate[2]);

		var eDate = new Date();
		eDate.setFullYear(sp_eDate[0],sp_eDate[1],sp_eDate[2]);

		// 하루 초를 나눈다음. 소수점 이하 처리 하여 출력.
		var oneDay = (1000*60*60*24);

		return Math.ceil((eDate - sDate)/oneDay);  

	}	
	//사업자등록번호 유효성 체크 
	function checkBizID(bizID)  
	{ 
	    // bizID는 숫자만 10자리로 해서 문자열로 넘긴다. 
	    var checkID = new Array(1, 3, 7, 1, 3, 7, 1, 3, 5, 1); 
	    var i, chkSum=0, c2, remander; 
	     bizID = bizID.replace(/-/gi,''); 

	     for (i=0; i<=7; i++) chkSum += checkID[i] * bizID.charAt(i); 
	     c2 = "0" + (checkID[8] * bizID.charAt(8)); 
	     c2 = c2.substring(c2.length - 2, c2.length); 
	     chkSum += Math.floor(c2.charAt(0)) + Math.floor(c2.charAt(1)); 
	     remander = (10 - (chkSum % 10)) % 10 ; 

	    if (Math.floor(bizID.charAt(9)) == remander) return true ; // OK! 
	      return false; 
	} 
	//사업자 번호 받으면 3 - 2 - 5 로 잘라서 리턴한다.
	function fn_company_number (num) {
		if( num.length == 10 ) {
			var bsns_cum = num.substring(0,3) + "-";
			bsns_cum += num.substring(3,5) + "-";
			bsns_cum += num.substring(5,10);
			return bsns_cum;
		}
		else {
			alert("사업자 번호가 잘못되었습니다.");
			return "";
		}
	}
	// 현재 날짜를 '20080101010101'형식으로 반환한다.
	// len은 필요한 자리수 만큼만 지정해준다. 	미지정인경우 8
	// getToday() 	=> 20110102
	// getToday(12) => 201101020304
	// getToday(14) => 20110102030405
	function getToday(len, gubunStr)
	{
		if(len == undefined) len = 8;
		var todate = new Date();
		var result = todate.getFullYear() + "" + fillZero(parseInt(todate.getMonth()) + 1, 2) + "" + fillZero(todate.getDate(), 2) + fillZero(todate.getHours(), 2) + fillZero(todate.getMinutes(), 2) + fillZero(todate.getSeconds(), 2);
		result = result.substring(0, len);
		if(gubunStr != undefined) result = getDateFormat(result, len, gubunStr);
		return result;
	}

	// 날짜를 변환한다.
	function getDateToStr(todate, len, gubunStr)
	{
		if(len == undefined) len = 8;
		var result = todate.getFullYear() + "" + fillZero(parseInt(todate.getMonth()) + 1, 2) + "" + fillZero(todate.getDate(), 2) + fillZero(todate.getHours(), 2) + fillZero(todate.getMinutes(), 2) + fillZero(todate.getSeconds(), 2);
		result = result.substring(0, len);
		if(gubunStr != undefined) result = getDateFormat(result, len, gubunStr);
		return result;
	}

	// 정해진 자리수에 맞춰 앞쪽에 0을 채운다   
	function fillZero(ipt, cnt)
	{
		var tgt = ipt + "";
		while(tgt.length < cnt)
		{
			tgt = "0" + tgt;
		}
		return tgt;
	}
	
	// 정해진 자리수에 맞춰 뒷쪽에 0을 채운다   
	function fillZero2(ipt, cnt)
	{
		var tgt = ipt + "";
		while(tgt.length < cnt)
		{
			tgt = tgt + "0";
		}
		return tgt;
	}
	
	// 한화 억단위 넘어갔을때 말만들기 x억 xx만원 (만원단위)
	function makeMoneyStr(source)
	{
		var sorc = (source + "").replaceAll(",", "");
		
		
		if(!isNumber(sorc)) return 0;
		
		var pv = (sorc + "").split(".")[1];
		
		if(pv == undefined) 	pv = "";
		else					pv = "." + pv;
		
		var negaitive 	= false;
		
		var target = Math.floor(Number(sorc)); 
		
		if(target < 0) {
			target 		= target * -1;
			negaitive 	= true;
		}
		var result	= 0;
		var result1 = Math.floor(target / 10000);
		
		var result2 = (target % 10000) + pv;
		
		if 		(result1 == 0)	result = addComma(result2 + "") + "만원";
		else if	(result2 == 0) 	result = result1 + "억원";
		else					result = result1 + "억 " + addComma(result2 + "") + "만원";
		if(negaitive)			result = "-" + result;
		return result;
	}
	// 한화 억단위 넘어갔을때 말만들기 역변환
	function makeUnMoneyStr(source) {
		source = source + "";
		var strArr = source.replaceAll(",", "").replaceAll("원", "").replaceAll("만", "").trim();
		var strArr = strArr.split("억");
		if(strArr.length == 1) {
			if(isNumber(strArr[0])) return Number(strArr[0]);
			else					return source;
		} else if(strArr.length == 2){
			var result = 0;
			if(isNumber(strArr[0])) result += (strArr[0] * 10000);
			else {
				return source;
			}
			if(!isValid(strArr[1])) {
				return Number(result);
			} else if (isNumber(strArr[1])) {
				return Number(result) + Number(strArr[1]);
			} else {
				return source;
			}
		}
	}
	

	// 날짜 문자열을 	14자리 -> '2010-05-05 11:22:33'
	// 					12자리 -> '2010-05-05 11:22'
	//					8자리  -> '2010-05-05' 
	//					6자리  -> '2010-05'
	//					의 형식으로 변환(문자열 자리수에 따라 자동 변환함)
	//					fixSeat를 지정해주면 자리수가 길어도 fixSeat자리수 만큼만 처리한다.
	function getDateFormat(dateStr, fixSeat, gubunStr)
	{
		if(gubunStr == undefined) gubunStr = "-";
		if(Object.prototype.toString.call(dateStr)  != '[object String]') return "";
		dateStr = dateStr.replaceAll(gubunStr, "");
		if(dateStr.length > fixSeat) {
			dateStr = dateStr.substring(0, fixSeat);
		}
		if(dateStr.length == 6)
			return dateStr.substring(0, 4) + gubunStr + dateStr.substring(4, 6);
		if(dateStr.length < 8) return null;
		var yyyy = dateStr.substring(0, 4);
		var mm = dateStr.substring(4, 6);
		var dd = dateStr.substring(6, 8);
		var result = yyyy + gubunStr + mm + gubunStr + dd;
		if(dateStr.length > 11)
		{
			var hh = dateStr.substring(8, 10);
			var ii = dateStr.substring(10, 12);
			result = result + " " + hh + ":" + ii;
		}
		if(dateStr.length == 14)
		{
			var ss = dateStr.substring(12, 14);
			result = result + ":" + ss;
		}
		return result;

	}

	// 날짜 스트링을 날짜 년,월,일 날짜 객체로 반환
	function getDateStringToDateObject(src)
	{
	    var src 	= src.replace(/-/g, ""); 
	    
		var yyyy 	= src.substring(0, 4);
		var mm 		= src.substring(4, 6);
		var dd 		= src.substring(6, 8);
		
		var obj = {};
		obj.yyyy = yyyy ;
		obj.mm 	 = mm 	;
		obj.dd 	 = dd 	;
	    return obj;
	}

	//날짜 스트링을 날짜 년 월 일로 스트링으로 반환
	function fn_changeDateFormat(src)
	{
		var obj = getDateStringToDateObject(src);
	    return obj.yyyy+"년"+obj.mm +"월"+obj.dd+"일";
	}

	// 날짜 문자열을 스트링으로 변환  2011-09-09 11:10 -> 201109091110 이런식~
	function getDateStringToNormalString(src)
	{
		if(!isValid(src)) return null;
		return src.replace(/\s|-|:/g,"");
	}

	// 레디오 버튼 선택된 값구하기.
	function fn_getRadio(rName)
	{
		return $("input[name=" + rName + "]:checked").val();
	}
	// 레디오 버튼 해당 되는값 찾아 선택하기
	// 레디오 버튼 해당 되는값 찾아 선택하기
	function fn_setRadio(rName, val)
	{
		$("input[name='" + rName + "']").each( function () {
			if	($(this).val() == val) $(this).attr("checked", true);
			else						$(this).attr("checked", false);
		});
	}
	// select box의 선택된 값을 읽어온다.
	function fn_getSelectBox(sName)
	{
		return $("select[name='" + sName + "'] option:selected").val();
	}
	// select box의 선택된 값의 Text를 읽어온다.
	function fn_getTextSelectBox(sName)
	{
		return $("select[name='" + sName + "'] option:selected").text();
	}
	// select box에 원하는 값으로 Setting한다.(name을 우선으로 찾고, 없으면 id로 찾는다.
	function fn_setSelectBox(sName, val)
	{
		var executeCheck = false;
		$("select[name='" + sName + "'] option").each(function() {
			if($(this).val() == val) $(this).attr("selected", true);
			executeCheck = true;
		});
		if(executeCheck) return;
		$("#" + sName + " option").each(function() {
			if($(this).val() == val) $(this).attr("selected", true);
		});
	}
	
	//select의 option 추가하는 함수
	function fn_addSelectOption(id, text, value) {
		$("#" + id).get(0).options[$("#" + id).get(0).length] = new Option(text, value);
		// $("#" + id).selectmenu("refresh");
	}
	/**
	 * Json Object 를 select 객체의 Option을 세팅한다.
	 * ex)
	 * jsonObject = {
	 * 		"Cd1" : "text1",
	 * 		"Cd2" : "text2"
	 * }
	 * <select id="(id)"></select> 에 
	 * 		<option value="Cd1">text1</option>
	 * 		<option value="Cd2">text2</option>
	 * </select>
	 * 형태로 추가된다.
	 * 
	 * @param id		: DOC ID
	 * @param jsonObject : Json data
	 * @param clearCheck : true 인경우 기존 Option 을 모두 제거후 새로 작성
	 * 						생략하거나, false 인경우 기존 Option 뒤에 붙임.
	 */
	function fn_addJsonToSelectBox(id, jsonObject, clearCheck) {
		if(clearCheck) $("#" + id).empty();
		$.each(jsonObject, function(value, text) {
			fn_addSelectOption(id, text, value);
		});
	}
	//select의 option을 삭제하는 함수 (범위 지정가능)
	function fn_All_delete_select_option(id, start, end) {
		if ( !isValid(start) ) 	var start = 0;
		if ( !isValid(end) )	var end = $("#" + id).get(0).length;
		
		for ( var i = start; i <= end; i++ ) {
			$("#" + id).get(0).options[start] = null;	
		}
		
		// $("#" + id).selectmenu("refresh");
	}

	/**
	 * 문자열의 바이트 길이를 리턴
	 * ex) if (getByteLength(form.title) > 100) {
	 *         alert("제목은 한글 50자(영문 100자) 이상 입력할 수 없습니다.");
	 *     }
	 */
	function getByte(s){
		if(!isValid(s)) return 0;
	   var len = 0;
	   s = s.replace(/\r/g, "");
	   if ( s == null ) return 0;
	   for(var i=0;i<s.length;i++){
	      var c = escape(s.charAt(i));
	      if ( c.length == 1 ) len ++;
	      else if ( c.indexOf("%u") != -1 ) len += 2;
	      else if ( c.indexOf("%") != -1 ) len += c.length/3;
	   }
	   return len;
	}

	// 개월을 년월 단위 객체로 변환
	function changeMonthToYearMonth(month) {
		if(!isValid(month)) return { yyyy : 0, mm : 0};
		var result = {};
		result.yyyy = Math.floor(month / 12);
		result.mm	= month % 12;
		return result;
	}
	// 개월수를 받아서 년 월로 리턴해준다.
	function changeMonthToYearMonthStr(month)
	{
		var tmp = parseInt(month / 12);
		var yStr = "";
		var mStr = "";
		if( tmp > 0) yStr = tmp + "년";
		tmp = month % 12;
		if( tmp > 0) mStr = tmp + "개월";
		if		(yStr == "") return mStr;
		else if	(mStr == "") return yStr;
		else 			return yStr + " " + mStr;
	}
	
	// 날짜 연산  년  월 일 시 분 초  30일 후( 이전일경우 -30으로 함)
	// 사용방법 getDateByAddDay(30, "2010-11-22")
	function getDateByAddDay2(tDay, tDate)
	{
		tDate = tDate.replaceAll("-", "");
		var yyyy 	= tDate.substring(0, 4);
		var mm 		= tDate.substring(4, 6);
		var dd 		= tDate.substring(6, 8);
		var tt 		= getDateByAddDay(tDay, yyyy, mm, dd);
		var result = "" + tt.getFullYear() + "-" + fillZero(tt.getMonth() + 1, 2) + "-" + fillZero(tt.getDate(), 2);
		return result;
	}
	// 날짜 연산  년  월 일 시 분 초  30일 후( 이전일경우 -30으로 함)
	// 사용방법 getDateByAddDay(30, 2010,11,22,09,08,12)
	function getDateByAddDay(tDay, yyyy, mm, dd, hh, ii, ss)
	{
		var loadDt = new Date(); //현재 날짜 및 시간
		if(yyyy != undefined) 	loadDt.setYear	(yyyy)  ;
		if(mm != undefined) 	loadDt.setMonth	(mm - 1)    ;
		if(dd != undefined)	loadDt.setDate	(dd)	;
		if(hh != undefined)	loadDt.setHours	(hh)    ;
		if(ii != undefined)	loadDt.setMinutes(ii)    ;
		if(ss != undefined)	loadDt.setSeconds(ss)    ;
		loadDt.setDate(loadDt.getDate() + tDay);
		return loadDt;
	}
	function getDateByAddDayFromNow(tDay)
	{
		var tt = new Date(); //현재 날짜 및 시간
		tt.setDate(tt.getDate() + tDay);
		var result = "" + tt.getFullYear() + fillZero(tt.getMonth() + 1, 2) + fillZero(tt.getDate(), 2) + fillZero(tt.getHours(), 2) + fillZero(tt.getMinutes(), 2) + fillZero(tt.getSeconds(), 2);
		return result;
	}
	// 월을 증가시킨 날짜를 구한다.(년 월 일 까지)
	function getAddMonth(input, addValue)
	{
		var tt = new Date(input.toDateStr("-"));
		tt.setMonth(Number(tt.getMonth()) + Number(addValue));
		var result = "" + tt.getFullYear() + fillZero(tt.getMonth() + 1, 2) + fillZero(tt.getDate(), 2);
		return result.toDateStr("-");
	}
	
	// 연을 증가시킨 날짜를 구한다.
	function getAddYear(tYear)
	{
		var tt = new Date();
		tt.setFullYear(tt.getFullYear()+ tYear);
		var result = "" + tt.getFullYear() + fillZero(tt.getMonth() + 1, 2) + fillZero(tt.getDate(), 2);
		return result;
	}
	
	// 날짜객체를 스트링형태로 변환 '2010-05-05'
	function getDateStr(dateObj, gubun)
	{
		if(dateObj == undefined || dateObj == null) return;
		
		var yy = dateObj.getYear() + "";
		var mm = dateObj.getMonth();
		var dd = dateObj.getDate() + "";
		mm = (eval(mm) + 1) + ""; 
		if(mm.length < 2) mm = "0" + mm;
		if(dd.length < 2) dd = "0" + dd;
		
		var result = yy + gubun + mm + gubun + dd;
		return result;
	}
	// 날짜 유효성 Check
	function fgb_checkDate(str) {
		try {
			str = str + "";
			var result = str.replaceAll("-", "");
			if(!isNumber(result)) return false;
			if(result.length != 8) return false;
			var p1 = result.substring(0, 4);
			var p2 = result.substring(4, 6);
			var p3 = result.substring(6, 8);
	
			if(p2 > 12 || p2 < 1) return false;
			
			var m31 = ["01", "03", "05", "07", "08", "10", "12"];
	
			if(p3 > "31" || p3 < "01") return false;
			
			if(!in_array(p2,  m31) && p3 > "30" ) return false;
			
			if( p2 == "02" && p3 > "29") return false;
			
			return true;
		} catch(e) {
			return false;
		}
	}
	String.prototype.trim = function() {
		return this.replace(/^\s+/g, '').replace(/\s+$/g, '');
	}
	String.prototype.replaceAll = function(source, target) {
		return this.split(source).join(target);
	}
	String.prototype.toDateStr = function(gubun) {
		if(gubun == undefined) gubun = "-";
		var yyyy 	= this.substr(0, 4);
		var mm 		= this.substr(4, 2);
		var dd 		= this.substr(6, 2);
		var result = yyyy + gubun + mm + gubun + dd;
		return result;
	}
	/**
	 * 특정 영역의 문자열을 제거한다.
	 */
	String.prototype.removeRangeChar = function(sd, ed) {
		var src = this;
		
		if(!isValid(src) || !isValid(sd) || !isValid(ed)) return "";
		while(true) {
			var startIdx 	= src.indexOf(sd);
			var endIdx 		= src.indexOf(ed, startIdx);
			
			if(startIdx < 0 || endIdx < 0) break;
			
			var target = src.substring(startIdx, endIdx + ed.length);
			src = src.replace(target, "");
		}
		
		return src;
	}
	/**
	 * 특정 영역의 문자열의 내용을 가져온다.
	 */
	String.prototype.getRangeChar = function(sd, ed) {
		var src = this + "";
		
		if(!isValid(src) || !isValid(sd) || !isValid(ed)) return "";

		var startIdx 	= src.indexOf(sd);
		var endIdx 		= src.indexOf(ed, startIdx);
		
		if(startIdx < 0 || endIdx < 0) return null;
		
		var target = src.substring(startIdx + sd.length, endIdx);

		return target;
	}
	
	String.prototype.render = function(sd, ed, parm) {
		var src = this + "";
		src = src.replaceAll("&lt;", "<");
		src = src.replaceAll("&gt;", ">");
		
		if(!isValid(src) || !isValid(sd) || !isValid(ed)) return "";
		var cursorPos = 0;
		while(true) {
			var startIdx 	= src.indexOf(sd, cursorPos);
			var endIdx 		= src.indexOf(ed, startIdx);
			
			if(startIdx < 0 || endIdx < 0) break;


			var target 		= src.substring(startIdx, endIdx + ed.length);
			var fKey		= src.substring(startIdx + sd.length, endIdx);
			var fKeySpt		= fKey.split("|");
			var key 		= fKeySpt[0];
			var defaultStr	= fKeySpt[1] == undefined ? "" : fKeySpt[1];
			var addParm;
			if(isValid(fKeySpt[2])) {
				addParm = fKeySpt[2].split(",");
			}
			
			var dest = getParseObject(key, parm);

			if(dest == undefined) {
				if(defaultStr != "") dest = defaultStr;
			}
			dest = __render(dest, addParm, parm);
			dest = dest.replaceAll("\\n", "<br/>");
			dest = dest.replaceAll("\n", "<br/>");
			src = src.replaceAll(target, dest);

			cursorPos = endIdx - target.length;
		}
		return src;
	}
	/**
	 * 	Key 값에 따라 Object Tree에서 해당 Path를 찾음
	 * 	ex)
	 * 	parm = { 
	 * 		a : { b : 1 }
	 * 	}
	 * 	result = getParseObject("a.b", parm);			
	 * 
	 * 
	 * @param key
	 * @param parm
	 * @returns
	 */
	function getParseObject(key, parm) {
		var keyArray = key.split(".");
		var dest = parm[keyArray[0]];
		$.each(keyArray, function(idx) {
			if(idx == 0) return true;
			if(!isValid(dest)) return false;
			dest = dest[this];
		});
		return dest;
	}
	// String.prototype.render에서만 사용
	function __render(str, addParm, baseMap) {
		if(!isValid(addParm)) return str;
		str = str + "";
		$.each(addParm, function(idx) {
			var addStr 	= this + "";
			var token 	= addStr.getRangeChar("[", "]");
			if(isValid(token)) addStr = getParseObject(token, baseMap);
			str = str.replaceAll("{"+idx+"}", addStr);
		});
		return str;
	}
	
	/**
	 * 앞에만 대문자 변환
	 * @returns
	 */
	String.prototype.headerUpperCase = function() {
		if(!isValid(this)) return this;
		var str = this.toLowerCase();
		return str.substring(0, 1).toUpperCase() + str.substring(1);
	};
	
	Array.prototype.removeItem = function(itemName) {
		for(var ii=0;ii < this.length;ii++) {
			this[ii][itemName] = undefined;
		}
	};
	// 항목을 검색하여 검색된 항목에 대해 특정 항목을 Update한다.
	Array.prototype.updateItem = function(sItemName, sVal, tItemName, tVal) {
		if(tItemName 	== undefined) tItemName 	= sItemName;
		if(tVal 		== undefined) tVal 		= sVal;
		$.each(this, function() {
			if(this[sItemName] == sVal) this[tItemName] = tVal;
		});
	};
	/**
	 * 배열에 삽입한다.
	 * ex) target = sourceArray.insertItem(insertObj, 0);
	 */
	Array.prototype.insertItem = function(itemObj, idx) {
		var newii = 0;
		var newArray = Array();
		for(var ii=0;ii < this.length;ii++) {
			if(ii == idx) newArray[newArray.length] = itemObj;
			newArray[newArray.length] = this[ii];
		}
		return newArray;
	}
	
	//배열 중복 제거  // 원래의 배열 값의 배열은 그대로 두고 리턴 배열 값을 중복 제거 한다.
	Array.prototype.unique = function()
	{
		var arrResult = new Array(this.length);
		for(var i=0; i <this.length; i++){
			arrResult[i]=this[i];
		}
		var a = {};
		for(var i=0; i <arrResult.length; i++){
			if(typeof a[arrResult[i]] == "undefined")
				a[arrResult[i]] = 1;
		}
		arrResult.length = 0;
		for(var i in a)
			arrResult[arrResult.length] = i;
		return arrResult;
	}
	// 배열을 정렬한다.
	// ex)
	//	var list = [
	//	  	 { "ITEM" : "A", "VAL" : 4 }
	//	  	,{ "ITEM" : "D", "VAL" : 1 }
	//	  	,{ "ITEM" : "C", "VAL" : 2 }
	//		,{ "ITEM" : "B", "VAL" : 3 }
	//	];
	//	   	
	//	list.orderBy("ITEM", "asc");
	Array.prototype.orderBy = function(itemName, direct) {
		if(direct == undefined) direct = "ASC";
		
		this.sort(function(a, b) {
			if			(direct.toUpperCase() == "ASC") {
				return(a[itemName]<b[itemName])?-1:(a[itemName]>b[itemName])?1:0;
			} else if	(direct.toUpperCase() == "DESC") {
				return(a[itemName]<b[itemName])?1:(a[itemName]>b[itemName])?-1:0;
			} else {
				return 0;
			}
		}); 
		return this;
	}

	// 배열을 병합한다.
	function fn_mergeArray(arry1, arry2) {
		if(Object.prototype.toString.call(arry1) != '[object Array]') return arry2;
		if(Object.prototype.toString.call(arry2) != '[object Array]') return arry1;
		for(var ii = 0; ii < arry2.length ; ii++) arry1[arry1.length] = arry2[ii];
		return arry1;
	}
	// 배열을 특정 항목에 대해 Grouping 한다.
	function fn_groupingArray(arry, groupItemName) {
		if(Object.prototype.toString.call(arry) != '[object Array]') return null;
		var returnMap = {};
		$.each(arry, function() {
			var gkey = this[groupItemName];
			if(returnMap[gkey] == undefined) returnMap[gkey] = [];
			returnMap[gkey].push(this);
		});
		return returnMap;
	}
	
	
	
	// 문자 유효성 체크
	function isValid(str)
	{
		if(str == null || str == undefined || (str + "").trim().length == 0) return false;
		return true;
	}
	function isEmpty(str) {
		return !isValid(str);
	}
	// 배타적 유효성 Check
	function isExclusiveValid(val1, val2) {
		var c1 = isValid(val1);
		var c2 = isValid(val2);
		if(c1 && c2) return false;
		if(!c1 && !c2) return false;
		return true;
	}
	
	
	// 현재 경로에서 Root경로 path를 구한다.
	// ex) path = "aaa/bbb/ccc.html" 인경우 "../../"를 리턴한다.
	function getRootPos()
	{
		var path =getCurrentPath();

		var depth = path.split("/").length - 1;
		var result = "";
		for(var ii=0 ; ii < depth ; ii++) result += "../";
		
		return result;
	}
	
	// 현재 경로 Path를 구한다.
	function getCurrentPath()
	{
		var cPath = location.href;

		var path = cPath.substring(cPath.lastIndexOf("biss") + 5, cPath.length);

		return path;
	}
	
	// 현재 Page file name을 구한다.
	function getCurrentPageFileName()
	{
		var cPath = location.href;

		var path = cPath.substring(cPath.lastIndexOf("/") + 1, cPath.length);

		return path;
	}

	function cf_getContentObj(callback)
	{
		$("div").each(function (i, obj) {
			if( $(obj).attr("data-role") == "content")
			{
				callback(obj);
			}
		});
	}
	function cf_getListViewObjArry(callback)
	{
		var listViewArry = Array();
		var idx = 0;
		$("ul").each(function (i, obj) {
			if( $(obj).attr("data-role") == "listview")
			{
				listViewArry[idx++] = obj;
			}
		});
		callback(listViewArry);
	}
	function viewJson(obj, idx)
	{
		if(idx == undefined) idx = 0;
		if(isValid(obj)) 	pageAPI.alert(idx + ":" + JSON.stringify(obj));
		else				pageAPI.alert(idx + ":" + obj);
	}

	//두개의 Json데이터를 Merge하는 함수
	function fn_MergeJson(leftObj, rightObj, forcePushTableArray, addHeader){
		if(addHeader == undefined) addHeader = "";
		if 		 ( leftObj == null && rightObj != null )
		{
			return rightObj;
		}
		else if ( leftObj != null && rightObj == null )
		{
			return leftObj;
		}
		else if ( leftObj != null && rightObj != null )
		{
			$.each(rightObj, function(key, value){
	
				if(isValid(value) || in_array(key, forcePushTableArray))
				{
					if(key != "INFO") leftObj[addHeader + key] = value;
				}
			})
		    return leftObj;
		}
		else 
		{
			
			return null;
		}
	}
	
	/**
	 * Array To json map
	 * arrayList 가 Object array이어야함.
	 */
	function arrayToMap(arrayList, key, valueColumn, defaultMap) {
		if(!isValid(arrayList)) return {};
		var returnMap = {};
		if(defaultMap != undefined) {
			$.each(defaultMap, function(key, value) {
				returnMap[key] = value;
			});
		}
		$.each(arrayList, function() {
			if(!isValid(this[key])) return true;
			if(valueColumn == undefined) 	returnMap[this[key]] = this;
			else 							returnMap[this[key]] = this[valueColumn];
		});
		return returnMap;
	}
	/**
	 * Array To json map Grouping
	 * ex) arrayList 내용이 다음과 같고, groupColumn 이 A 인경우
	 * [ 
	 * 		{ A : CO1, B : A1, C : 가1 }, 
	 * 		{ A : CO1, B : A2, C : 가2 }, 
	 * 		{ A : CO2, B : B1, C : 나1 }, 
	 * 		{ A : CO2, B : B2, C : 나2 } 
	 * ]
	 * 결과 :
	 * { 
	 *   CO1 : [ 
	 * 				{ A : CO1, B : A1, C : 가1 }, 
	 * 				{ A : CO1, B : A2, C : 가2 } 
	 * 			],
	 *   CO2 : [
	 * 				{ A : CO2, B : B1, C : 나1 }, 
	 * 				{ A : CO2, B : B2, C : 나2 } 
	 * 			]
	 * }
	 * 
	 */	
	function arrayToGroup(arrayList, groupColumn) {
		if(!isValid(arrayList)) return {};
		var returnMap = {};
		$.each(arrayList, function() {
			if(!isValid(this[groupColumn])) return true;
			if(returnMap[this[groupColumn]] == undefined) returnMap[this[groupColumn]] = [];
			returnMap[this[groupColumn]][returnMap[this[groupColumn]].length] = this;
		});
		return returnMap;
	}

	// Json 객체를 복사한다.
	// functionCheck가 true인경우 함수까지 복사한다.(단 하위객체의 함수는 무시됨)
	function fn_jsonClone(obj, functionCheck)
	{
		var objStr = JSON.stringify(obj);
		try{
			var newObj = JSON.parse(objStr);
				// function에 대한 처리
				$.each(obj, function(key, value) {
					if(typeof value == "function") newObj[key] = obj[key];
				});
			return newObj;
		}catch(e) {
			alert('fn_jsonClone error : Object객체가 아닙니다.');
		}
	}

	// 스트링 Array 에 특정 스트링이 있는지 검사
	function in_array(str, arry)
	{
		if(Object.prototype.toString.call(str)  == '[object Number]') str = str + "";
		if(Object.prototype.toString.call(str)  != '[object String]') return false;
		if(Object.prototype.toString.call(arry) != '[object Array]') return false;
		
		for(var ii = 0; ii < arry.length ; ii++) if(arry[ii] == str) return true;
		
		return false;
	}
	// 스트링 Array 에 특정 스트링의 위치
	function in_array_pos(str, arry)
	{
		if(Object.prototype.toString.call(str)  != '[object String]') return -1;
		if(Object.prototype.toString.call(arry) != '[object Array]') return -1;
		
		for(var ii = 0; ii < arry.length ; ii++) if(arry[ii] == str) return ii;
		
		return -1;
	}
	// JSON객체를 정렬한다.
	// 정렬된 값은 전달된 객체에 저장된다.
	function fn_jsonSort(tObj, tKey, direct)
	{
		var dir = 1;
		if		(direct == undefined) 	dir = 1;
		else if	(direct == "asc") 		dir = 1;
		else if (direct == "desc") 		dir = -1;
	
		var result = tObj.sort( function (obj1, obj2) {
			if( obj1[tKey] < obj2[tKey] ) return dir * (-1);
			if( obj1[tKey] > obj2[tKey] ) return dir;
			return 0;
		});
		return result;
	}
	
	//배열의 해당 Array를 제거한다.
	function fn_removeArrayItem(arrayObj ,idx){
		
		var reBuildObj;
		var temp;
		
		if(arrayObj.length<idx){
			
			return arrayObj;
		
		}else if(idx<0){
			
			return arrayObj;
			
		}else{
			
			reBuildObj = arrayObj.slice(0,idx);
			temp	   = arrayObj.slice(idx+1,arrayObj.length);
			
			for(var i=0; i<temp.length; i++){
				
				reBuildObj[reBuildObj.length] = temp[i]
				
			}
			
			return reBuildObj;
			
		}
	}
	// 배열에서 특정 배열 값을 삭제.
	function fn_removeArrayString(keyArray, removeKey)
	{
		var resultArray = Array();
		for(var ii=0; ii < keyArray.length;ii++)
		{
			if(keyArray[ii] != removeKey) resultArray[resultArray.length] = keyArray[ii];
		}
		return resultArray;
	}
	
	//숫자 유효성 검사
	//받은 변수에 숫자외 다른 문자가 있는지 판별
	function isNumber(input) {
		return $.isNumeric(input);
	}
	function hasCharsOnly(input,chars) {
		if(!isValid(input)) return false;
	    for (var inx = 0; inx < input.length; inx++) {
	       if (chars.indexOf(input.charAt(inx)) == -1){
	
	           return false;
	       }
	    }
	    return true;
	}

	// 디버깅용
	function fn_try(fn, parm)
	{
		try {
			fn(parm);
		} catch(e) {
			fn_printLog(e.stack + "\n\n" + e);
		}
	}
	// Array Data값을 DB조건 형태로 변환
	// arrayObj가 String배열인경우 	arrayObj[ii] 를 대상으로 생성
	// arrayObj가 Object인경우 		arrayObj[ii][itemName]을 대상으로 생성
	// 결과물은 '1', '2', '3', '4' 형태로 반환
	function fn_getTransArray(arrayObj, itemName)
	{
		if		(Object.prototype.toString.call(arrayObj) == '[object Array]')
		{
			var objCheck = false;
			
			if	(Object.prototype.toString.call(arrayObj[0]) == '[object Object]') objCheck = true;
			
			var all_item = "";
			
			for(var ii=0; ii < arrayObj.length; ii++)
			{
				var addData = (objCheck ? arrayObj[ii][itemName] : arrayObj[ii]);
				if(addData == undefined) continue;
				if(all_item.indexOf("'" + addData + "'") < 0 ) {
					if( all_item == "" ) 	all_item = "'" + addData + "'";
					else					all_item += ", '" + addData + "'";
				}
			}
			return all_item;
		} else return "";
	}
	
	// OBJECT 배열에서 특정 ITEM(Key)의 값을 검색해서 첫번째 일치하는 OBJECT를 반환한다.
	// retType 이 "idx"를 보내주면 해당 아이템의 인덱스를 리턴한다.
	function fn_searchObjectItem(targetObjArray, searchKey, searchValue, retType)
	{
		if		(Object.prototype.toString.call(targetObjArray) != '[object Array]')	return null;
		if		(targetObjArray.length == 0) 											return null;
		if		(targetObjArray[0][searchKey] == undefined) 							return null;
		
		var result = null;
		for(var ii=0; ii < targetObjArray.length; ii++)
		{
			if(targetObjArray[ii][searchKey] == searchValue)
			{
				result = targetObjArray[ii];
				if(retType == "idx") 	return ii;
				else					return result;
				break;
			}
		}
		if(retType == "idx") 	return -1;
		else					return null;
	}
	// OBJECT 배열에서 특정 ITEM(Key)의 값을 검색해서 일치하는 OBJECT를 모두 반환한다.
	// searchType : "E" => Equal, "L" => "Like"
	function fn_searchJsonObjectArray(objArray, searchKey, searchData, searchType)
	{
		if		(Object.prototype.toString.call(objArray) 	!= '[object Array]')	return null;
		if		(objArray.length == 0) 											return null;
		if		(objArray[0][searchKey] == undefined) 							return null;
		if		(Object.prototype.toString.call(searchData) == '[object String]'){
			var t = searchData;
			searchData = Array();
			searchData[0] = t;
		}
		if(searchType == undefined) searchType = "E";
		var result = Array();
		var idx = 0;
		for(var ii=0; ii < objArray.length; ii++)
		{
			if			(searchType == "E") {
			if( in_array( objArray[ii][searchKey], searchData)) result[idx++] = objArray[ii];
			} else if	(searchType == "L"){
				if(objArray[ii][searchKey].indexOf(searchData) > -1) result[idx++] = objArray[ii];
			}
		}
		return result;
	}
	// OBJECT 배열에서 특정 ITEM(Key)의 값을 검색해서 일치하는 OBJECT를 제거한다.
	function fn_removeJsonObjectArray(objArray, searchKey, searchData)
	{
		if		(Object.prototype.toString.call(objArray) 	!= '[object Array]')	return null;
		if		(objArray.length == 0) 											return null;
		if		(objArray[0][searchKey] == undefined) 							return null;
		if		(Object.prototype.toString.call(searchData) == '[object String]'){
			var t = searchData;
			searchData = Array();
			searchData[0] = t;
		}
		var result = Array();
		var idx = 0;
		for(var ii=0; ii < objArray.length; ii++)
		{
			if( !in_array( objArray[ii][searchKey], searchData)) result[idx++] = objArray[ii];
		}
		return result;
	}
	function fn_byteTransform(size, fixed) {
		if(fixed == undefined) fixed = 2;
        if (typeof size !== 'number') {
            return '';
        }
        if (size >= 1073741824) {
            return (size / 1073741824).toFixed(fixed) + ' GB';
        }
        if (size >= 1048576) {
            return (size / 1048576).toFixed(fixed) + ' MB';
        }
        return (size / 1024).toFixed(fixed) + ' KB';
    }


	//
	// jquery library
	//
	
	// <form ... id="theForm" > Data => json 형태로 변환
	// ex) var jsonObj = $('#theForm').serializeJSON();
	$.fn.serializeJSON=function() {
	    var json = {};
	    jQuery.map($(this).serializeArray(), function(n, i){
	        json[n['name']] = n['value'];
	    });
	    return json;
	};

	/**
	 * showLayer: 레이어를 브라우저 중앙에 표시
	 * 사용 법 : $('#layerID').showLayer();
	 */
	$.fn.showLayerCenter = function(docObj, baseX, baseY, clientWidth, clientHeight){
		if(docObj 	== undefined) docObj 	= document;
		if(baseX 	== undefined) baseX 	= 0;
		if(baseY 	== undefined) baseY 	= 0;
		var obj = $(this);
		if(clientWidth 		== undefined) clientWidth = 1180; // docObj.body.clientWidth
		if(clientHeight 	== undefined) clientHeight = docObj.body.clientHeight;
		var iWidth 		= (clientWidth 	/ 2) - obj.width() 	/ 2 + docObj.body.scrollLeft 	+ baseX;
		var iHeight 	= (clientHeight / 2) - obj.height() / 2 + docObj.body.scrollTop 	+ baseY;
		if(iWidth 	< 0 ) iWidth 	= 0;
		if(iHeight 	< 0 ) iHeight 	= 0;
		
		obj.css({
			position: 'absolute',
			display	: 'block'   ,
			top		: iHeight   ,
			left	: iWidth    
		});
		
	};
	
	/**
	 * <form ..></form> 안의 항목의 값을 Setting한다.
	 * 사용 법 : $('#formID').setFormData( { 항목1 : 항목값 , 항목2 : 항목값);
	 * 참조 : 	'checkbox'의 경우 name과 value가 모두 동일해야 check됨.
	 * 			'radio'의 경우 value가 동일한 항목이 선택됨.
	 */
	$.fn.setFormData = function(ol_data, sl_idStr) {
		var formId = $(this).attr("id");
		if(sl_idStr != undefined) formId = sl_idStr.substring(1);
		$("#" + formId + " input, #" + formId + " select, #" + formId + " textarea").each(function() {
			var itemName = $(this).attr("name");
			var setValue = ol_data[itemName];
			if(setValue == undefined) return true;
			var itemType = $(this).attr("type")
			var tagName = $(this).prop("tagName").toLowerCase();
			if(isValid(itemType)) 	itemType 	= itemType.toLowerCase();
			if(isValid(tagName )) 	tagName 	= tagName .toLowerCase();
			if		 (	itemType == "text" 	|| 
						itemType == "hidden" ||
						tagName	 == "textarea" ) {
				$(this).val(setValue);
			}
			else if (	itemType == "radio"	) {
				if	($(this).val() == setValue) $(this).attr("checked", true);
				else							 $(this).attr("checked", false);
			}
			else if (	tagName  == "select"	) {
				fn_setSelectBox	(itemName, setValue);
			}
			else if (	itemType == "checkbox") {
				if($(this).val() == setValue) $(this).attr("checked", true);
			}
			if(itemType == "text") {
				var keyupMethod = $(this).attr("onKeyUp");
				if(isValid(keyupMethod)) eval(keyupMethod);
			}
		});
	};
	/**
	 * 레이어를 x, y위치로 이동시킨다.
	 * ex) $("#id").setPosition(100, 100);
	 */
	$.fn.setPosition = function(x, y) {
		$(this).css("position", "absolute");
		$(this).css("left", x);
		$(this).css("top", y);
	};
	/**
	 * 메뉴 Popup을 띄운다.
	 * jqueryui lib 필요
	 */
	$.fn.setPopupMenu = function() {
		$(this).menu();
		var thisObj = this;
		$(this).bind("mouseover", function() {
			$(thisObj).show();
		});
		$(this).bind("mouseout", function() {
			$(thisObj).hide();
		});
	};
	// Outer html
	$.fn.getOuterHtml = function() {
		return $(this).clone().wrapAll('<div/>').parent().html();
	}	
	//Json Debugging
	function dalert(obj, type) {
		var str = JSON.stringify(obj);
		if(type == 1) 	alert(obj);
		else			alert(str);
	}
	function dwrite(obj) {
		var str = obj;
		if(typeof obj == "object") str = JSON.stringify(obj);
		var org = $("#debugTextarea").val();
		if(!isValid(org)) org = ""; 
		$("#debugDiv").remove();
		$("body").append("<div class=list_wrap id=debugDiv style=margin-left:300px;margin-bottom:50px;z-index:1;><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><textarea id=debugTextarea cols=100 rows=20></textarea></div>");
		$("#debugTextarea").val(str + "\n\n" + org);
	}
	function _mergeTableTD(tableId, index, parm) {
		var startIdx 	= parm.startIdx;
		var type		= parm.type;
		var startRowIdx	= parm.startRowIdx;
		if(index 		== undefined) index 		= 0;
		if(startIdx 	== undefined) startIdx 		= 1;
		if(type 		== undefined) type 			= 1;
		if(startRowIdx 	== undefined) startRowIdx 	= 1;
		if(startRowIdx < 1) {
			alert('startRowIdx는 1이상이어야 합니다.');
			return;
		}
		startRowIdx--;
		var rowSpanArray = [];
		var rowspan = 0;
		var lastIdx = 0;
		var targetBlockObj = $("#" + tableId + " tr").eq(0).parent();
		targetBlockObj.children().each(function(listIdx) {
			if(startRowIdx > listIdx) return true;
			var thisKey = "";
			for(var ii=(startIdx - 1); ii <= index; ii++ ) {
				try {
					thisKey += $(this).children().eq(ii).html().trim();
				} catch(e) {}
			}
			rowSpanArray[listIdx] = {};
			var preKey = null;
			if(listIdx > startRowIdx) preKey = rowSpanArray[listIdx - 1].key;
			
			if(preKey != null && thisKey == preKey) {
				rowSpanArray[listIdx].key 		= thisKey;
				rowSpanArray[listIdx].state 	= "D";
				rowspan++;
			} else {
				rowSpanArray[listIdx].key 		= thisKey;
				rowSpanArray[listIdx].state 	= "H";
				if(listIdx > 0) rowSpanArray[listIdx - rowspan].rowspan = rowspan;
				rowspan = 1;
			}
			lastIdx = listIdx;
		});
		if(rowSpanArray.length == 0) return true;
		rowSpanArray[lastIdx - rowspan + 1].rowspan = rowspan;
		if(type == 1) {
			targetBlockObj.children().each(function(listIdx) {
				if(startRowIdx > listIdx) return true;
				if(rowSpanArray[listIdx].state == "H") {
					$(this).children().eq(index).attr("rowspan", rowSpanArray[listIdx].rowspan);
				} else if(rowSpanArray[listIdx].state == "D") {
					$(this).children().eq(index).remove();
				}
			});
		} else {
			targetBlockObj.children().each(function(listIdx) {
				if(startRowIdx >= listIdx) return true;
				if(rowSpanArray[listIdx].state == "D") {
					$(this).children().eq(index).html("");
				}
			});
		}
	};
	/**
	 * Table Merge작업을 한다.
	 * 설명 : 	targetId에 해당하는 DOM에서 첫번째 tr Tage를 찾아, 해당 Tr에 속한 Table에서 Merge를 진행한다.
	 * 
	 * ex ) 
	 * var parm = {    
	 * 				startIdx 	: 1,	// 시작 Column (1부터 시작)
	 * 				endIdx		: 2,	// 끝 Column
	 * 				startRowIdx : 2		// 시작 Row(1부터 시작)
	 * } 
	 * mergeTableTD('testTable', parm);
	 */
	function mergeTableTD(targetId, parm) {
		var startIdx 	= parm.startIdx;
		var endIdx		= parm.endIdx;
		if(startIdx < 1) {
			alert('startIdx 는 1이상이어야 합니다.');
			return;
		}
		if(endIdx == undefined) endIdx = startIdx;
		endIdx--;
		for ( var ii = endIdx + 1; ii > (startIdx - 1); ii--) {
			this._mergeTableTD(targetId, ii - 1, parm);
		}
	};
	
	function mergeTableTBodyRowspan(domId) {
	    $("#" + domId + " tbody[mergerow=Y]").each(function() {
	        var pos    = $(this).attr("mergeparm");
	        var id    = $(this).attr("id");
	        if(!isValid(id)) {
	            var key    = "A" + getUniqueId();
	            $(this).attr("id", key);
	            id = key;
	        }
	        var posArr = pos.split(",");
	        posArr = posArr.sort(function(a,b){return b-a});
	        $.each(posArr, function() {
		        mergeTableTD(id, {startIdx:Number(this)});    
	        })
	    });
	}
	function mergeTableTBodyColspan(domId) {
	    $("#" + domId + " tbody[mergecol=Y]").each(function() {
			$(this).find("tr").each(function() {
				var preTxt			= null;	
				var preCell		= null;	
				var preColSpan	= 0;	
				$(this).find("td").each(function(idx) {
					var cellTxt = $(this).html();
					if(preTxt == cellTxt) {
						$(this).remove();
						preColSpan++;
					} else {
						if(preCell != null) {
							if(preColSpan > 1) $(preCell).attr("colspan", preColSpan);
						}
						preCell = this;
						preColSpan = 1;
						preTxt = cellTxt;
					}
				}); 
				if(preColSpan > 1) $(preCell).attr("colspan", preColSpan);
			});
	    });
	};

	/**
	 * Object Copy
	 * ex) var target = Object.create(source);
	 */
	if (typeof Object.create !== 'function') {
		Object.create = function (o) {
			function F() { }
			F.prototype = o;
			return new F();
		};
	};
	/**
	 * Object Copy
	 * ex) var target = Object.create(source);
	 */
	function fn_copyObject(o) {
		var robj = {}
		robj = $.extend(robj,o);
		return robj;
	}
	function fn_copyFullObject(o) {
	    var copy = o,k;
	    if (o && typeof o === 'object') {
	        copy = Object.prototype.toString.call(o) === '[object Array]' ? [] : {};
	        for (k in o) {
	            copy[k] = fn_copyFullObject(o[k]);
	        }
	    }
	    return copy;
	}
	// 고유키를 생성한다.
	function getUniqueId() {
		var t = (new Date()).getTime();
		var a = Math.round(Math.random()*100);
		return t + "" + a;
	}
	
	function getNodeCount(obj) {
		var type = Object.prototype.toString.call(obj);
		if(type  == '[object Object]') {
			var cnt = 0;
			$.each(obj, function() {
				if(this != undefined) cnt++;
			});
			return cnt;
		} else if(type = '[object Array]' ) {
			return obj.length;
		} else return 0;
	}
	
	// Map을 Order 순서대로 정렬한 Array를 리턴한다.
	function mapToArrayByOrder(map, array, key) {
		if(key == undefined) return [];
		if(map == undefined) return [];
		if(array == undefined) return [];
		var resultList = [];
		$.each(array, function() {
			var comp = this[key];
			if(comp == undefined) return true;
			if(isValid(map[comp])) resultList.push(map[comp]);
		});
		return resultList;
	}
	// Map의 Key 값과 Value값을 List로 변환한다.
	// ex) var map = {                                    
	//     	 "AA" : "11"                              
	//     	,"BB" : "22"                              
	//     }                                             
	//     var list = mapToArray(map, "title", "value"); 
	//
	//	   list =>  [{
	//              	"title": "AA",
	//              	"value": "11"
	//              }, 
	//              {
	//              	"title": "BB",
	//              	"value": "22"
	//              }]
	function mapToArray(map, keyName, valueName) {
  		var resultList = [];
  		$.each(map, function(key, val) {
  			var map = {};
  			map[keyName] 	= key;
  			map[valueName] 	= val;
  			resultList.push(map);
  		});
  		return resultList;
	}
	// 한글 마지막글자가 받침으로 끝나면 true, 아니면 false
	function endsWithJong(str){
		var sTest = str.charAt(str.length-1);
		var nTmp = sTest.charCodeAt(0) - 0xAC00;
		var jong = nTmp % 28;
		return jong != 0 ? true : false;
	}
	
	// input field에서 Key 입력 Filter
	// ex) 	<input type='text' onkeyup="inputKeyup(this, '0123456789')"/> => "0123456789"만 허용
	//		<input type='text' onkeyup="inputKeyup(this)"/> => "0123456789"를 생략할경우 _DEFAULT_KEY_SET을 사용함. 
	var _DEFAULT_KEY_SET = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-_/,.:*()";
	function inputKeyup(obj, cset) {
		if(cset == undefined) cset = _DEFAULT_KEY_SET;
		var backup 	= $(obj).attr("backup");
		if(!isValid(backup)) backup = "";
		var input = $(obj).val();
		if(input != "" && !hasCharsOnly(input, cset, true)) {
			$(obj).val(backup);
		}
		input = $(obj).val();
		$(obj).attr("backup", input);
	}
	
	// 문자열 개수를 구한다.
	function getCountStringFromTargetString(searchStr, targetStr) {
		if(!isValid(targetStr)) return 0;
		var arry = targetStr.split(searchStr);
		return arry.length - 1;
	}
	
	// String의 마지막이 특정 단어로 끝나는지 검사
	function fgb_endAsWord(src, word) {
		if(!isValid(src)) return false;
		if(!isValid(word)) return false;
		src = src.trim();
		word = word.trim();
		var wordlen = word.length;
		var srclen = src.length
		if(srclen < wordlen) return false;
		var lastWord = src.substring(srclen - wordlen);
		return word == lastWord;
	}
	
	// 년 월을 개월수로 리턴
	function changeMonthFromYearMonth(val) {
		var newVal = val.replaceAll("년", "").replaceAll("개월", "").replaceAll(" ", "");
		if(isNumber(newVal) && (fgb_endAsWord(val, "개월") || fgb_endAsWord(val, "년"))) {
			var y = 0;
			var m = 0;
			if(val.indexOf("년") > -1 ) {
				y = val.split("년")[0]
				m = val.split("년")[1].replaceAll("개월", "");
			} else {
				m = val.split("개월")[0];
			}
			if(!isValid(y)) y = 0;
			if(!isValid(m)) m = 0;
			var month = Number(y) * 12 + Number(m);
			return month;
		}
		else {
			return -1;
		}
	}
	
	// 변수 Naming 변환
	// ex)  ABC_DEF_GHI => abcDefGhi
	function fn_changeNaming(valName) {
		var nameArr = valName.split("_");
		result = "";
		$.each(nameArr, function(idx) {
			if(idx == 0) result = this.toLowerCase();
			else result += this.headerUpperCase();
		});
		return result;
	}
	
	// Json Object Naming 변환
	function fn_changeKeyNamingJsonObject(jsonObj) {
		if(!isValid(jsonObj)) return jsonObj;
		var resultObj = {};
		$.each(jsonObj, function(key, value) {
			resultObj[fn_changeNaming(key)] = value;
		});
		return resultObj;
	}
	// Json Object List Naming 변환
	function fn_changeKeyNamingJsonList(jsonList) {
		if(!isValid(jsonList)) return jsonList;
		var resultList = [];
		$.each(jsonList, function(idx) {
			resultList[idx] = fn_changeKeyNamingJsonObject(this);
		});
		return resultList;
	}
	
	// 소수점 자르기
	function fn_fix(num, seat) {
		if(!isValid(seat)) seat = 0;
		var s = Math.pow(10,  seat);
		return Math.round(num * s) / s;
	}
	
	function nvl(val, dstr) {
		if(isEmpty(val)) 	return dstr;
		else				return val;
	}
	
	// Map To List
	// ex1)
	// var map  = {"A" : "1", "B" : "2"}
	// var list = mapToList(map, ["ITEM1", "TEM2"]);
	//------ Result ---------------
	// 	list => [
	//				 {"ITEM1" : "A", "ITEM2" : "1"}
	//				,{"ITEM1" : "B", "ITEM2" : "2"}
	//			]
	//
	// ex2)
	// var map  = {
	//				"A" : {"ITEM2" : "1", "ITEM3" : "2"}
	//				"B" : {"ITEM2" : "3", "ITEM3" : "4"}
	//			  }
	// var list = mapToList(map, ["ITEM1"]);
	//------ Result ---------------
	// 	list => [
	//				 {"ITEM1" : "A", "ITEM2" : "1", "ITEM3" : "2"}
	//				,{"ITEM1" : "B", "ITEM2" : "3", "ITEM3" : "4"}
	//			]
	function mapToList(map, itemNameList) {
		var listArray = [];
		$.each(map, function(key, value) {
			var idx = listArray.length;
			listArray[idx] = {};
			listArray[idx][itemNameList[0]] = key;
			if(typeof value == "object") {
				listArray[idx] = $.extend(listArray[idx], value);
			} else {
				listArray[idx][itemNameList[1]] = value;
			}
		});
		return listArray;
	}
	
	// 20210621
	var tFn = Number;
	var Number = function(num) {
		var x = (num + "").replace(",", "");
		return tFn(x);
	}
	
	function pagePrintPreview(){
		var browser = navigator.userAgent.toLowerCase();
		if ( -1 != browser.indexOf('chrome') ){
			window.print();
		}else if ( -1 != browser.indexOf('trident') ){
			try{
				//참고로 IE 5.5 이상에서만 동작함
				
				//웹 브라우저 컨트롤 생성
				var webBrowser = '<OBJECT ID="previewWeb" WIDTH=0 HEIGHT=0 CLASSID="CLSID:8856F961-340A-11D0-A96B-00C04FD705A2"></OBJECT>';
				
				//웹 페이지에 객체 삽입
				document.body.insertAdjacentHTML('beforeEnd', webBrowser);
				
				//ExexWB 메쏘드 실행 (7 : 미리보기 , 8 : 페이지 설정 , 6 : 인쇄하기(대화상자))
				previewWeb.ExecWB(7, 1);
				
				//객체 해제
				previewWeb.outerHTML = "";
			}catch (e) {
				alert("- 도구 > 인터넷 옵션 > 보안 탭 > 신뢰할 수 있는 사이트 선택\n   1. 사이트 버튼 클릭 > 사이트 추가\n   2. 사용자 지정 수준 클릭 > 스크립팅하기 안전하지 않은 것으로 표시된 ActiveX 컨트롤 (사용)으로 체크\n\n※ 위 설정은 프린트 기능을 사용하기 위함임");
			}
			
		}
	}

	
	
