	// Ajax Form Submit (POST)
	function ajaxSubmit(formName, callback)
	{

		if(callback == undefined) 	async = false;
		else						async = true;

		var targetUrl = document.all[formName].action;
		
		var result = null;
		
		var sendData = $("#" + formName).serialize();

		$.ajax({
			type		: "post",
			async		: async,
			url			: targetUrl,
			contentType	:"application/x-www-form-urlencoded; charset=utf-8",
			data		: sendData, 
			dataType	: "text",
			success		:function(data){
				try {
					eval("result = " + data );
				} catch(e) {
					result = null;
				}
				if(callback != undefined) callback(result);
			},
			error		: function(e, state){
				alert("e");
				result = state;
				if(callback != undefined) callback(result);
			}
			
		});
		return result;
	}

	// Ajax URL Request (GET)
	// 'callback' 파라메터가 있는경우는 서버가 비동기 호출되며, callback함수로 결과 값을 리턴한다.
	// 'callback' 파라메터가 없는경우는 서버가 동기 호출 되며, 함수 수행이 끝나고 호출한곳으로 결과값을 리턴한다.
	function ajaxRequest(parm)
	{
		var targetUrl 	= parm.targetUrl;
		var jsonData 	= parm.jsonData;
		var callback 	= parm.callback;
		var method 		= parm.method;
		var p_async 	= parm.p_async;
		var contentType	= parm.contentType;
		
		if(callback == undefined) 	async = false;
		else						async = true;
		
		if(method 		== undefined) method 		= "post";
		if(p_async 		!= undefined) async 		= p_async;
		if(contentType	== undefined) contentType 	= "json";

		var result = null;
		
		var data = {};
		try {
			data.jsonData = JSON.stringify(jsonData);
		} catch(e) {
			alert('parameter가 json object가 아닙니다.');
			return;
		}
		$.ajax({
			type		: method,
			async		: async,
			url			: targetUrl,
			contentType	: "application/x-www-form-urlencoded; charset=utf-8",
			dataType	: contentType,
			data		: data,
			success		: function(data){
				result = data;
				if(callback != undefined) callback(data);
			},
			error		: function(e, state){
				result = state;
				if(callback != undefined) callback(result);
			}
		});
		return result;
	}
