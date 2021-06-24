package test;

import net.sf.json.JSONObject;

public class TestList {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		TestList tl = new TestList();
		tl.pushRegistTest();
	}
	public void pushRegistTest() {


		String jsonParmStr = "";
		
		jsonParmStr  = "{																		";
		jsonParmStr += "	 \"connectionType\"  	: \"http\"                                  ";
		jsonParmStr += "	,\"ipAddress\"  		: \"10.40.40.101\"                          ";
		jsonParmStr += "	,\"portNumber\"  		: \"83\"                                    ";
		jsonParmStr += "	,\"userId\"  			: \"sy01.wie\"                              ";
		jsonParmStr += "	,\"contextUrl\"  		: \"semp\"                                  ";
		jsonParmStr += "	,\"dataType\"  			: \"json\"                                  ";
		jsonParmStr += "	,\"sType\"  			: \"ws\"                                    ";
		jsonParmStr += "	,\"sCode\"  			: \"pushInfo\"                              ";
		jsonParmStr += "	,\"langCode\"  			: \"en\"                                    ";
		jsonParmStr += "	,\"paramCompressed\"  	: \"false\"                                 ";
		jsonParmStr += "	,\"paramEncrypted\"  	: \"false\"                                 ";
		jsonParmStr += "	,\"parameter\"  		: {                                         ";
		jsonParmStr += "							\"pushInfo\": {                             ";
		jsonParmStr += "								 \"userId\"	: \"sy01.wie\"              ";
		jsonParmStr += "								,\"empNo\"		: \"AQ097\"             ";
		jsonParmStr += "								,\"name\"		: \"위성열\"            ";
		jsonParmStr += "								,\"orgNumber\"	: \"02:00:00:00:00:00\" ";
		jsonParmStr += "								,\"password\"	: \"gmes2017\"          ";
		jsonParmStr += "							}                                           ";
		jsonParmStr += "						  }                                             ";
		jsonParmStr += "}                                                                      ";
		
		JSONObject jsonObject = JSONObject.fromObject(jsonParmStr);
		
		System.out.println(jsonObject.toString());
		
	}

}
