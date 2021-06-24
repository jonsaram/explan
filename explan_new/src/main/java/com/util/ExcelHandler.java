package com.util;

import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.hssf.util.Region;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;

/**
 * Excel Download
 *
 * @author 위성열(sy01.wie)
 * @since 2015. 7. 23.
 * @version  v1.0.0.00(20150723)
 */
public class ExcelHandler{
	static private Set<String> mimeTypes = new HashSet<String>();
	static private Set<String> excelFileExtensions = new HashSet<String>();

	static{
		mimeTypes.add("application/xls");
		mimeTypes.add("application/x-xls");
		mimeTypes.add("application/excel");
		mimeTypes.add("application/msexcel");
		mimeTypes.add("application/x-excel");
		mimeTypes.add("application/x-msexcel");
		mimeTypes.add("application/x-ms-excel");
		mimeTypes.add("application/vnd.ms-excel");
		mimeTypes.add("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
		mimeTypes.add("application/vnd.openxmlformats-officedocument.spreadsheetml.template");

		excelFileExtensions.add(".xls");
		excelFileExtensions.add(".xlsx");
	}

	/**
	 * List<Map>을 엑셀로 다운로드 하기
	 * fileName
	 * header : "a,b,c"
	 * sheetName : "sheetname"
	 * response
	 * @param fileName
	 * @param header
	 * @param sheetName
	 * @param list
	 * @param response
	 * @throws Exception
	 */
	public static void excelDownList(String fileName, String header, String sheetName, List list, HttpServletResponse response) throws Exception{
		String headerArr[]={header};
		List paramList = new ArrayList(1);
		paramList.add(list);
		excelDownList(fileName, headerArr, null, sheetName, paramList, response);
	}

	public static void excelDownList(String fileName, String header, String columnList, String sheetName, List list, HttpServletResponse response) throws Exception{
		String headerArr[]={header};
		String columnArr[]={columnList};
		List paramList = new ArrayList(1);
		paramList.add(list);
		excelDownList(fileName, headerArr, columnArr, sheetName, paramList, response);
	}
	/**
	 * 엑셀 Data를 정해진 Format으로 받아 다운로드 한다.
	 * @author 위성열 (sy01.wie)
	 * @since 2015. 08. 17
	 * @param fileName
	 * @param multiExcelDataList 의 내용은 아래와 같은 Map형태로 Sheet개수 만큼 Setting.
	 * 		fullHeader : "header1,header2,header3,#cspn,header5//subHeader1,#rspan,subHeader3,subHeader4,subHeader5" => Header가 여러줄인경우 '//'으로 구분
	 * 					 '#cspn'인경우 가로 병합, '#rspn'인경우 세로 병합, 가로 세로 중복 병합은 Error발생 주의 요인임.
	 * 		fullColumn : "column1,column2,column3,column4,column5" 	=> Header개수에 맞게 Column Mapping
	 * 		dataList   : List<Map> Format의 Grid Data
	 * 		sheetName  : Sheet Name
	 * @param response
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public static void excelDownList(String fileName, List<Map> multiExcelDataList, HttpServletResponse response) throws Exception{
		
		int size = multiExcelDataList.size();
		
		String headerArr[] 	= new String[size];
		String columnArr[] 	= new String[size];
		List paramList 		= new ArrayList(size);
		String sheetNameList= null;
		
		int ii = 0;;
		for (Map infoMap : multiExcelDataList) {
			String fullHeader 	= (String)infoMap.get("fullHeader");
			String fullColumn 	= (String)infoMap.get("fullColumn");
			List InfoList 		= (List)infoMap  .get("dataList");
			String sheetName	= (String)infoMap.get("sheetName");
			
			headerArr[ii] 		= fullHeader;
			columnArr[ii] 		= fullColumn;
			paramList.add(InfoList);
			if(sheetNameList == null) 	sheetNameList  = 	   sheetName;
			else						sheetNameList += "," + sheetName;
			ii++;
		}
		excelDownList(fileName, headerArr, columnArr, sheetNameList, paramList, response);
	}

	
	
	/**
	 * 엑셀다운로드 리스트 다운로드 하기
	 * @param fileName
	 * @param header [a,b,c,d][a,b,c,d]
	 * @param sheetName a,b
	 * @param list
	 * @param response
	 * @throws Exception
	 */
	public static void excelDownList(String fileName, String header[], String sheetName, List list, HttpServletResponse response) throws Exception{
		excelDownList(fileName, header, null, sheetName, list, response);
	}
	@SuppressWarnings("deprecation")
	public static void excelDownList(String fileName, String header[], String columnArr[], String sheetName, List list, HttpServletResponse response) throws Exception{
		HSSFWorkbook workbook = new HSSFWorkbook();
		String sheetNameArr[]  =sheetName.split(",");
		int cellWidth = 5000;
		int sheetCount=sheetNameArr.length;
		  
		//shee개수만큼 돌린다.
		for (int a=0;a<sheetCount;a++){
			HSSFSheet sheet 		= workbook.createSheet(sheetNameArr[a]);
			
			List<Map> dataList 		= (List<Map>)list.get(a);
			String headerNameArr[]	= header[a].split("//");
			int totalRowCount		= dataList.size();
			int rowCount			= 0;
			int columnCnt 			= 0;
			int painRow				= headerNameArr.length;
			
			// 대외비 출력
			String hname[]=headerNameArr[0].split(",");
			Row secRow = sheet.createRow(rowCount++);
			for (int ii=0;ii<hname.length;ii++){
				Cell cell = secRow.createCell(ii);
				if(ii == hname.length - 1)	{
					cell.setCellValue("Confidential");
					cell.setCellStyle(getSecurityCellStyle(workbook));
				}
			}
			
			//header title 생성
			for (int ii=0;ii<headerNameArr.length;ii++){				
				String headerName[]=headerNameArr[ii].split(",");
				HSSFRow titleRow = sheet.createRow(rowCount++);
				columnCnt = headerName.length;
				for (int b=0;b<headerName.length;b++){
					Cell titleCell= titleRow.createCell(b);				
					titleCell.setCellStyle(getHeaderCellStyle(workbook));				
					titleCell.setCellValue(headerName[b]);
				}
			}
			// Format에 따라 Cell Merge
			getMergeMatrix(header[a], sheet);
			
			if(columnArr == null) {
				for (int c=0;c<totalRowCount;c++){
					 HSSFRow daraRow = sheet.createRow(rowCount++);					 
					 Object[] excelData = dataList.get(c).values().toArray();
					 
					 for (int d=0;d<excelData.length;d++){	
						 
						 if (excelData[d]==null || excelData[d].toString().trim().equals("")){
							// daraRow.createCell(d).setCellValue("");
						 }else{
							 HSSFCell objCell = daraRow.createCell(d);
							 
							//수정 (엑셀 숫자형 표시 위해서)
							 if ( isStringDouble(excelData[d].toString().trim()) == false)//문자형
							 {
								 objCell.setCellType(HSSFCell.CELL_TYPE_STRING);
								 objCell.setCellValue(excelData[d].toString().trim()); 
							 } 
							 else // 숫자형
							 {
								 objCell.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
								 objCell.setCellValue(Double.parseDouble(excelData[d].toString().trim())); 
							 }
							 
							 //daraRow.createCell(d).setCellValue(excelData[d].toString().trim()); 
						 }
					 }
				}
			} else {
				String columnArrName[]=columnArr[a].split(",");
				
				for (int c=0;c<totalRowCount;c++){
					 HSSFRow daraRow = sheet.createRow(rowCount++);					 
					 Map excelData = dataList.get(c);
					 
					 for (int d=0;d<columnArrName.length;d++){	
						 Object itemName = excelData.get(columnArrName[d]);
						 if (itemName==null || itemName.toString().trim().equals("")){
							// daraRow.createCell(d).setCellValue("");
						 }else{
							 HSSFCell objCell = daraRow.createCell(d);
							 String objValue = itemName.toString().trim();
							 //수정 (엑셀 숫자형 표시 위해서)
							 if ( isStringDouble(objValue) == false)//문자형
							 {
								 objCell.setCellType(HSSFCell.CELL_TYPE_STRING);
								 objCell.setCellValue(objValue); 
								 //HSSFCellStyle cs = workbook.createCellStyle();
								 //cs.setWrapText(true);
								 //objCell.setCellStyle(cs);
							 } 
							 else // 숫자형
							 {
								 objCell.setCellType(HSSFCell.CELL_TYPE_NUMERIC);
								 objCell.setCellValue(Double.parseDouble(objValue)); 
							 }
							 
							 
							 
						 }
					 }
				}
			}
			// 각Sheet의 Column Width를 자동으로 설정한다.
			for (int i=0;i<columnCnt;i++){
			   sheet.autoSizeColumn(i, true);
			   sheet.setColumnWidth(i, sheet.getColumnWidth(i) + 500);
			}
			sheet.createFreezePane(0,painRow);
		}
		
		OutputStream fileOut = null;
		try{
			response.setContentType("application/octet-stream");
	    	response.setHeader("Content-Disposition", "attachment; filename="+new String(fileName.getBytes("KSC5601"), "8859_1")+".xls");
	    	response.setHeader("Content-Description", "JSP Generated Data");  
	    	response.setHeader("Content-Transfer-Encoding", "binary;");
	    	response.setHeader("Pragma", "no-cache;");
	    	response.setHeader("Expires", "-1;");
	    	
	    	fileOut =response.getOutputStream();
	    	
	    	workbook.write(fileOut);
		}catch (Exception e){
    		throw e;
    	} finally {
    		try{
    			if (fileOut != null) {
    				fileOut.flush();
    				fileOut.close();
    			}
    		}catch(IOException ex){
    			throw ex;
    		}
    	}
	}
	
	/* 문자 숫자 구분 */
	public static boolean isStringDouble(String s) {
	    try {
	        Double.parseDouble(s);
	        return true;
	    } catch (NumberFormatException e) {
	        return false;
	    }
	  }
	
	/**
	 * 대외비용 스타일
	 * @param workbook
	 * @return
	 */
	protected static CellStyle getSecurityCellStyle( HSSFWorkbook workbook ){
		CellStyle securityStyle = workbook.createCellStyle();
		Font securityFont = workbook.createFont();
		securityFont.setColor(IndexedColors.RED.getIndex());
		securityStyle.setAlignment(CellStyle.ALIGN_CENTER);
		securityStyle.setLeftBorderColor(IndexedColors.RED.getIndex());
		securityStyle.setRightBorderColor(IndexedColors.RED.getIndex());
		securityStyle.setTopBorderColor(IndexedColors.RED.getIndex());
		securityStyle.setBottomBorderColor(HSSFColor.RED.index);
		securityStyle.setBorderLeft(CellStyle.BORDER_THIN);
		securityStyle.setBorderRight(CellStyle.BORDER_THIN);
		securityStyle.setBorderTop(CellStyle.BORDER_THIN);
		securityStyle.setBorderBottom(CellStyle.BORDER_THIN);
		securityStyle.setFont(securityFont);
		return securityStyle;
	}
	
	/**
	 * 헤더스타일
	 * @param workbook
	 * @param cellStyleName
	 * @return
	 */
	private static CellStyle getHeaderCellStyle( HSSFWorkbook workbook ){
		CellStyle headerStyle = workbook.createCellStyle();
		Font font = workbook.createFont();
		headerStyle.setFillForegroundColor(IndexedColors.PALE_BLUE.getIndex());
		headerStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);
		headerStyle.setBorderLeft(CellStyle.BORDER_THIN);
		headerStyle.setBorderRight(CellStyle.BORDER_THIN);
		headerStyle.setBorderTop(CellStyle.BORDER_THIN);
		headerStyle.setBorderBottom(CellStyle.BORDER_THIN);
		headerStyle.setAlignment(CellStyle.ALIGN_CENTER);
		headerStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		headerStyle.setFont(font);		
		headerStyle.setLocked(false);
		
		return headerStyle;
	}
	/**
	 * 엑셀의 Cell을 병합한다.
	 * @author 위성열 (sy01.wie)
	 * @since 2015. 08. 17
	 * @param headerNameStr
	 * @param sheet
	 */
	@SuppressWarnings({ "deprecation", "unchecked" })
	private static void getMergeMatrix(String headerNameStr, HSSFSheet sheet) {

		Map mergeMap = new HashMap();
		
		String headerNameArr[]	=headerNameStr.split("//");
		String headerArr[][]	= new String[headerNameArr.length][];
		for (int ii=0;ii<headerNameArr.length;ii++){		
			String headerName[]=headerNameArr[ii].split(",");
			headerArr[ii] = new String[headerName.length];
			for (int jj=0;jj<headerName.length;jj++){
				headerArr[ii][jj] = headerName[jj];
			}
		}
		for (int ii=0;ii<headerArr.length;ii++){				
			int prejj = 0;
			for (int jj=0;jj<headerArr[ii].length;jj++){
				if("#cspn".equals(headerArr[ii][jj])) {
					String start 	= ii+"/"+prejj;
					String end		= ii+"/"+jj;	
					mergeMap.put(start, end);
				} else prejj = jj;
			}
		}

		for (int ii=0;ii<headerArr[0].length;ii++){				
			int prejj = 0;
			for (int jj=0;jj<headerArr.length;jj++){
				if("#rspn".equals(headerArr[jj][ii])) {
					String start 	= prejj+"/"+ii;
					String end		= jj+"/"+ii;	
					mergeMap.put(start, end);
				} else prejj = jj;
			}
		}
		Iterator it = mergeMap.keySet().iterator(); 
		while(it.hasNext()) { 
			String start 		= it.next().toString();
			String end 			= (String)mergeMap.get(start);
			String [] startArr 	= start.split("/");
			String [] endtArr 	= end.split("/");
			short sy = Short.parseShort(startArr[0]);
			short sx = Short.parseShort(startArr[1]);
			short ey = Short.parseShort(endtArr[0]);
			short ex = Short.parseShort(endtArr[1]);
			sheet.addMergedRegion(new Region(sy,sx,ey,ex));
		} 
		
	}
}
