	package neos.cmm.ex.visitor.service.impl;

import java.awt.Color;
import java.awt.Font;
import java.awt.FontMetrics;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;
import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.imageio.ImageIO;

import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.client.j2se.MatrixToImageConfig;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;

import api.fax.service.SmsService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import neos.cmm.db.CommonSqlDAO;
import neos.cmm.ex.visitor.service.VisitorManageService;
import neos.cmm.systemx.orgchart.service.OrgChartService;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.HttpJsonUtil;
import neos.cmm.util.code.CommonCodeUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

@Service("VisitorManageService")
public class VisitorManageServiceImpl implements VisitorManageService{

	@Resource(name = "commonSql")
	private CommonSqlDAO commonSql;

	@Resource(name = "OrgChartService")
	private OrgChartService orgChartService;

	@Override
	public Map<String, Object> getVisitorList(Map<String, Object> paramMap, PaginationInfo paginationInfo) {
		return commonSql.listOfPaging2(paramMap, paginationInfo, "VisitorManageDAO.getVisitorList");
	}

	@Override
	public void insertVisitor(Map<String, Object> paramMap) {

		if(StringUtils.isEmpty(paramMap.get("visit_aim"))){
			paramMap.put("visit_aim", " ");
		}
		commonSql.insert("VisitorManageDAO.insertVisitor", paramMap);

		//		try {
		//			if(StringUtils.isEmpty(paramMap.get("visit_aim"))){
		//				paramMap.put("visit_aim", " ");
		//			}
		//			commonSql.insert("VisitorManageDAO.insertVisitor", paramMap);
		//			result.put("resultCode", "SUCCESS");
		//			result.put("resultMessage", "방문객 등록 성공");
		//			
		//		}
		//				
		//		catch(Exception e) {
		//			result.put("resultCode", "FAIL");
		//			result.put("resultMessage", e);
		//			System.out.println("방문객 등록 중 에러 발생 : " + e);
		//		}
	}


	@Override
	public void DeleteVisitor(Map<String, Object> paramMap) throws Exception {

		String[] rNoList = paramMap.get("r_no_list").toString().split(",");
		for(int i=0; i<rNoList .length; i++) {
			paramMap.put("R_NO", rNoList[i]);
			commonSql.delete("VisitorManageDAO.deleteVisitor", paramMap);
			paramMap.remove("R_NO");
		}

	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> GetVisitor(Map<String, Object> paramMap) {
		return (Map<String, Object>) commonSql.select("VisitorManageDAO.getVisitorList", paramMap);
	}

	@Override
	public List<Map<String, Object>> GetApproverList(Map<String, Object> paramMap) {
		return commonSql.list("VisitorManageDAO.getApproverList", paramMap);
	}

	@Override
	public void CheckVisitor(Map<String, Object> paramMap) {

		commonSql.update("VisitorManageDAO.CheckVisitor", paramMap);

		//			if(paramMap.get("sType").equals("in")) {
		//				/* 퇴실처리하지 않은 표찰번호인지 여부 확인 */
		//				int check = (int)commonSql.select("VisitorManageDAO.getCheckVisitCardNo", paramMap);
		//				if(check > 0) {
		//					result.put("resultCode", "ERR001");
		//					result.put("resultMessage", "퇴실하지 않은 표찰번호입니다.");
		//					return result;
		//				}
		//			}
		//			commonSql.update("VisitorManageDAO.CheckNormalVisitor", paramMap);
		//			result.put("resultCode", "SUCCESS");
		//			result.put("resultMessage", "입퇴실 체크 완료");
	}

	@Override
	public List<Map<String, Object>> GetVisitorWeekList(Map<String, Object> paramMap) {
		return commonSql.list("VisitorManageDAO.GetVisitorWeekList", paramMap);
	}

	@Override
	public Map<String, Object> GetVisitorListApp(Map<String, Object> paramMap, PaginationInfo paginationInfo) {
		return commonSql.listOfPaging2(paramMap, paginationInfo, "VisitorManageDAO.GetVisitorListApp");
	}

	@Override
	public void SetVisitorApp(Map<String, Object> paramMap) {
		commonSql.update("VisitorManageDAO.SetVisitorApp", paramMap);
	}

	@Override
	public void SetVisitApproval(Map<String, Object> paramMap) {
		commonSql.update("VisitorManageDAO.SetVisitApproval", paramMap);
	}

	@Override
	public Map<String, Object> GetAppInfo(Map<String, Object> paramMap) {
		Map<String, Object> item = (Map<String, Object>) commonSql.select("VisitorManageDAO.GetAppInfo", paramMap);

		if("0".equals(String.valueOf(paramMap.get("nRNo"))) && item == null) {
			item = new HashMap<>();
			item.put("r_no", 0);
			item.put("app_comp_seq", 0);
			item.put("app_comp_name", "");
			item.put("app_emp_seq", 0);
			item.put("app_emp_name", "");
			item.put("app_dept_seq", 0);
			item.put("app_dept_name", "");
			item.put("app_grade_name", "");
		}
		return  item;
	}

	static BufferedImage qrOverlayNormal = null;
	static BufferedImage qrOverlayVip = null;
	static BufferedImage qrOverlayEdu = null;
	static BufferedImage qrManNo = null;
	static Font font = null;

	@Override
	public Map<String, Object> sendMMSQrImage(Map<String, Object> paramMap) {

		Map<String, Object> qrInfo = (Map<String, Object>) commonSql.select("VisitorManageDAO.GetQrImageInfo", paramMap);
		Map<String, Object> result = new HashMap<String, Object>();

		int sendResult = -3;

		if(qrInfo != null) {

			try {

				String qrData = "dzqr://visitor/string/" + qrInfo.get("qrData").toString();
				String qrDate = qrInfo.get("qrDate").toString();
				String qrName = qrInfo.get("qrName").toString();
				String qrComp = qrInfo.get("qrComp").toString();
				String qrPlace = qrInfo.get("qrPlace").toString();
				String qrPlaceSubCode = qrInfo.get("qrPlaceSubCode").toString();
				String qrCar = qrInfo.get("qrCar").toString();
				String qrManager = qrInfo.get("qrManager").toString();
				String qrManagerDept = qrInfo.get("qrManagerDept").toString();
				String qrManTelNum = qrInfo.get("qrManTelNum").toString();				

				if(font == null) {
					font = Font.createFont( Font.TRUETYPE_FONT, new FileInputStream(new File(this.getClass().getClassLoader().getResource("").getPath().replace("WEB-INF/classes/", "css/font/DOUZONEText30.ttf"))));
				}

				if(qrOverlayNormal == null) {
					qrOverlayNormal = ImageIO.read(new File(this.getClass().getClassLoader().getResource("").getPath().replace("WEB-INF/classes/", "Images/bg/qr_bg_normal.jpg")));
				}

				if(qrOverlayVip == null) {
					qrOverlayVip = ImageIO.read(new File(this.getClass().getClassLoader().getResource("").getPath().replace("WEB-INF/classes/", "Images/bg/qr_bg_vip.jpg")));
				}

				if(qrOverlayEdu == null) {
					qrOverlayEdu = ImageIO.read(new File(this.getClass().getClassLoader().getResource("").getPath().replace("WEB-INF/classes/", "Images/bg/qr_bg_edu.jpg")));
				}	

				if(qrManNo == null) {
					qrManNo = ImageIO.read(new File(this.getClass().getClassLoader().getResource("").getPath().replace("WEB-INF/classes/", "Images/bg/qr_bg_man_no.jpg")));
				}

				BufferedImage qrOverlay = null;

				if(qrPlaceSubCode.equals("vip")) {
					qrOverlay = clone(qrOverlayVip);
				}else if(qrPlaceSubCode.equals("edu")) {
					qrOverlay = clone(qrOverlayEdu);
				}else {
					qrOverlay = clone(qrOverlayNormal);
				}

				String codeurl = new String(qrData.getBytes("UTF-8"),"ISO-8859-1");
				int qrcodeColor = 0xff000000;
				int backgroundColor = 0xFFFFFFFF;
				QRCodeWriter qrCodeWriter = new QRCodeWriter();

				BitMatrix bitMatrix = qrCodeWriter.encode(codeurl,BarcodeFormat.QR_CODE, 250, 250);
				MatrixToImageConfig matrixToImageConfig = new MatrixToImageConfig(qrcodeColor, backgroundColor);
				BufferedImage qrCode = MatrixToImageWriter.toBufferedImage(bitMatrix, matrixToImageConfig);		    

				Graphics2D g = qrOverlay.createGraphics();

				g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
				g.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_ON);
				g.setRenderingHint(RenderingHints.KEY_FRACTIONALMETRICS, RenderingHints.VALUE_FRACTIONALMETRICS_ON);
				g.setRenderingHint(RenderingHints.KEY_ALPHA_INTERPOLATION, RenderingHints.VALUE_ALPHA_INTERPOLATION_QUALITY);
				g.setRenderingHint(RenderingHints.KEY_COLOR_RENDERING, RenderingHints.VALUE_COLOR_RENDER_QUALITY);
				g.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);

				g.drawImage(qrCode, 90, 118, null);

				g.setFont(font.deriveFont(Font.BOLD, 23f));
				g.setColor(new Color(32,143,246));
				g.drawString(qrDate, 110, 461);

				g.setFont(font.deriveFont(Font.PLAIN, 19f));
				g.setColor(new Color(30,30,30));

				drawString(g, qrName, 519); 
				drawString(g, qrComp, 561); 
				drawString(g, qrPlace, 604); 
				drawString(g, qrCar, 647);

				String qrManagerDeptText = qrManager + " > " + qrManagerDept;
				FontMetrics qrManagerDeptTextFontMetrics = g.getFontMetrics();

				int lineNoGap = 0;

				if(qrManagerDeptTextFontMetrics.stringWidth(qrManagerDeptText.trim()) > 260) {
					drawString(g, qrManager, 688);
					drawString(g, qrManagerDept, 710);
				}else {
					drawString(g, qrManagerDeptText, 688);
					lineNoGap = 13;
				}

				if(!qrManTelNum.equals("")) {
					g.drawImage(qrManNo, 35, 730 - lineNoGap, null);
					drawString(g, qrManTelNum, 749 - lineNoGap);
				}				

				//ImageIO.write(qrOverlay, "JPEG", new File("/Users/beomsoo/Downloads/qr/qr_bg_result.jpg"));

				//MMS전송 구현예정
				ByteArrayOutputStream output = new ByteArrayOutputStream();
				ImageIO.write(qrOverlay, "JPEG", output);

				SmsService mmsService = new SmsService();
				sendResult = mmsService.mmsSendAPI(qrInfo, output.toByteArray());
				output.close();

			}catch(Exception ex) {
				paramMap.put("qr_send_status_code", "Fail");
				commonSql.update("VisitorManageDAO.updateQrSendStatus",paramMap);
				CommonUtil.printStatckTrace(ex);//오류메시지를 통한 정보노출

				result.put("resultCode", "Fail");
				result.put("resultMessage", ex);

				return result;
			}

		}else {
			sendResult = -1;
		}

		//성공
		if(sendResult >= 0) {
			paramMap.put("qr_send_status_code", "Success");
			commonSql.update("VisitorManageDAO.updateQrSendStatus",paramMap);

			result.put("resultCode", "SUCCESS");
			result.put("resultMessage", "QR코드 전송 성공");
		}
		//실패
		else {
			paramMap.put("qr_send_status_code", "Fail");
			commonSql.update("VisitorManageDAO.updateQrSendStatus",paramMap);
			//System.out.println("QR코드 전송 실패 : qrInfo is null " );

			result.put("resultCode", "Fail");
			result.put("resultMessage", "qrInfo is null");
		}

		return result;

	}

	public static final BufferedImage clone(BufferedImage image) {
		BufferedImage clone = new BufferedImage(image.getWidth(),
				image.getHeight(), image.getType());
		Graphics2D g2d = clone.createGraphics();
		g2d.drawImage(image, 0, 0, null);
		g2d.dispose();
		return clone;
	}		

	void drawString(Graphics g, String text, int y) {

		text = text.trim();

		FontMetrics fontMetrics = g.getFontMetrics();

		int textWidth = fontMetrics.stringWidth(text);

		if(textWidth > 260) {

			String subText = "";

			for(int i = 10; i < text.length(); i++) {

				if(fontMetrics.stringWidth(text.substring(0, i)) < 240) {
					subText = text.substring(0, i);	
				}else {
					break;
				}
			}			

			text = subText + ".."; 
			textWidth = fontMetrics.stringWidth(text);
		}

		g.drawString(text, 395 - textWidth, y);
	}

	@Override
	public Map<String, Object> InsertVisitorExt(Map<String, Object> paramMap) {

		// 신규 생성
		if("".equals(paramMap.get("req_no"))) {
			commonSql.insert("VisitorManageDAO.InsertVisitorExt", paramMap);
		}
		// 업데이트
		else {
			commonSql.update("VisitorManageDAO.UpdateVisitorExt", paramMap);
		}

		Object reqNo = commonSql.select("VisitorManageDAO.GetReqNo", paramMap);
		String sReqNo = reqNo.toString();

		paramMap.put("approKey", "VISIT01_"+sReqNo);
		paramMap.put("reqNo", sReqNo);

		return paramMap;
	}

	@Override
	public void UpdateDocId(Map<String, Object> request) {

		commonSql.update("VisitorManageDAO.updateDocId", request);
	}

	@Override
	public Map<String, Object> getVisitorPopContent(Map<String, Object> paramMap) {

		return (Map<String, Object>) commonSql.select("VisitorManageDAO.getVisitorPopContent", paramMap);
	}


	/* 전자결재 외부 API 연동 return 상태값에 따라 update */
	@Override
	public void UpdateAppvDocSts(Map<String, Object> paramMap) {

		commonSql.update("VisitorManageDAO.UpdateAppvDocSts", paramMap);
	}

	/* 전자결재 종결 시 QR 전송을 위한 r_no list / qr전송여부 가져오기 */
	@Override
	public Map<String, Object> getRNoList(Map<String, Object> paramMap) {

		return (Map<String,Object>) commonSql.select("VisitorManageDAO.getRNoList", paramMap);
	}

	@Override
	public Map<String, Object> updateVisitor(Map<String, Object> paramMap) throws Exception {
		
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			/* 주차권 발급인 경우(입/출차 시간 변동이 있는 경우)에 t_map 연동 */
			if(paramMap.get("pTicket_yn").equals("Issue") && paramMap.get("carNoCheckFlag").equals("1")) {
				paramMap.put("rNo", paramMap.get("req_no"));
				Map<String, Object> info = (Map<String, Object>) commonSql.select("VisitorManageDAO.getVisitorInfoSimple", paramMap);

				paramMap.put("connect_type", "update");
				paramMap.put("t_map_seq", info.get("t_map_seq").toString());

				Map<String, Object> tMapConnectResult = tMapConnect(paramMap);

				/* 실패 */
				if(!tMapConnectResult.get("resultCode").equals("CM200")) {
					result.put("resultCode", "ERR000");
					result.put("resultMessage", "t-map 주차권 업데이트 중 오류 발생..");
					return result;
				}
				else {
					commonSql.update("VisitorManageDAO.updateVisitorInfo", paramMap);
				}
			}
			else {
				commonSql.update("VisitorManageDAO.updateVisitorInfo", paramMap);
			}
			
			result.put("resultCode", "SUCCESS");
			result.put("resultMessage", "방문객 정보 업데이트 성공");
			
		}
		catch(Exception e) {
			result.put("resultCode", "FAIL");
			result.put("resultMessage", e.getMessage());
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
		return result;
	}

	@Override
	public int checkEapDoc(Map<String, Object> request) {

		return (int) commonSql.select("VisitorManageDAO.checkEapDoc", request);
	}

	@Override
	public void deleteReqData(Map<String, Object> request) {

		commonSql.delete("VisitorManageDAO.deleteReqData", request);
	}


	/* 전자결재 - 삭제 - 해당 데이터 삭제 로직 */
	@Override
	public void DeleteVisitorByAppv(Map<String, Object> request) {

		Map<String, Object> result = new HashMap<String, Object>();
		result = (Map<String, Object>) commonSql.select("VisitorManageDAO.getRNoList", request);
		String[] rNoList = result.get("r_no_list").toString().split(",");

		/* 마스터 테이블 데이터 삭제 */
		for(int i=0; i<rNoList.length; i++) {
			request.put("R_NO", rNoList[i]);
			commonSql.delete("VisitorManageDAO.deleteVisitor", request);
			request.remove("R_NO");
		}

		/* Ext 테이블 데이터 삭제 */
		commonSql.delete("VisitorManageDAO.deleteReqData", request);

	}

	@Override
	public Map<String, Object> getQrListTotalCount(Map<String, Object> request) {

		Map<String, Object> result = new HashMap<String, Object>();
		result.put("result", commonSql.select("VisitorManageDAO.getQrSendList_TOTALCOUNT", request));

		return result;
	}

	@Override
	public Map<String, Object> InsertVisitorNew(Map<String, Object> paramMap) {

		Map<String, Object> result = new HashMap<String, Object>();

		Map<String, Object> insertData = new HashMap<String, Object>();

		ArrayList<Integer> rNoList = new ArrayList<Integer>();
		
		List<String> insertFailList = new ArrayList<String>();
		List<Map<String, Object>> insertSuccessList = new ArrayList<Map<String, Object>>();
		
		try {
			/* 결재 연동 - popContent에서 입력 데이터 추출 */
			if(paramMap.get("elet_appv_link_yn").toString().equals("Y")) {
				Map<String, Object> popContent = getVisitorPopContent(paramMap);
				paramMap.putAll(popContent);
			}

			/* 방문자 정보 리스트 */
			String[] visitorInfoList = paramMap.get("visitor_detail_info").toString().substring(0, paramMap.get("visitor_detail_info").toString().length()-1).split("▦");

			for(int i=0; i<visitorInfoList.length; i++) {

				// nR_NO, nSeq 세팅(현재 max값 +1)
				int maxRNo = (int)commonSql.select("VisitorManageDAO.getMaxRNo", paramMap) +1;
				insertData.put("nR_NO", maxRNo);

				int nSeq = (int)commonSql.select("VisitorManageDAO.getNseq", paramMap) +1;
				insertData.put("nSeq", nSeq);

				/* 공통 데이터 세팅 */
				insertData.put("nManCoSeq", paramMap.get("man_comp_seq"));
				insertData.put("nManUserSeq", paramMap.get("man_emp_seq"));
				insertData.put("nReqCoSeq",paramMap.get("req_comp_seq"));
				insertData.put("nReqUserSeq", paramMap.get("req_emp_seq"));
				insertData.put("sDistinct", paramMap.get("visit_distinct"));
				insertData.put("sVisitFrDT", paramMap.get("visit_dt_fr"));
				insertData.put("sVisitFrTM", paramMap.get("visit_tm_fr"));
				insertData.put("sVisitAIM", paramMap.get("visit_aim"));
				insertData.put("nVisitCnt", paramMap.get("visit_cnt"));
				insertData.put("visit_place_code", paramMap.get("visit_place_code"));
				insertData.put("visit_place_sub_code",paramMap.get("visit_place_sub_code"));
				insertData.put("nManTelNum", paramMap.get("man_tel_num"));

				/* 방문자 정보 - 개별 */
				String[] visitorInfo = visitorInfoList[i].split("\\|");

				insertData.put("sVisitCO", visitorInfo[0]);
				insertData.put("sVisitNM",visitorInfo[1]);		
				insertData.put("sVisitHP",visitorInfo[2]);
				insertData.put("sVisitCarNo",visitorInfo[3]);

				/* visit_pticket_yn : 주차권 발급 여부 */
				if(visitorInfo[4].equals("Issue")) {
					insertData.put("visit_pticket_yn","Issue");

					insertData.put("visitCarInTime", paramMap.get("visit_car_in_time"));
					insertData.put("visitCarOutTime", paramMap.get("visit_car_out_time"));
				}
				else if(visitorInfo[4].equals("noIssue")) {
					insertData.put("visit_pticket_yn","noIssue");
				}
				else {
					insertData.put("visit_pticket_yn","noCar");
				}

				String approvalYn = "1"; //승인여부
				String eletAppvLinkYn = ""; //전자결재 연동 여부
				String eletAppvInterfaceKey = ""; // 전자결재 연동 approKey
				String elctAppvDocId = ""; //전자결재 연동 docId
				String elctAppvDocStatus = ""; //전자결재 진행 상태
				String qrData = ""; // QR데이터
				String qrSendStatusCode = ""; //QR발송상태
				String visitPlaceName = ""; // 방문 장소

				/* 결재 연동 */
				if(paramMap.get("elet_appv_link_yn").toString().equals("Y")) {

					visitPlaceName = CommonCodeUtil.getCodeName("VISIT001", paramMap.get("visit_place_code").toString());

					eletAppvLinkYn = "Y";
					eletAppvInterfaceKey = paramMap.get("elet_appv_interface_key").toString();
					elctAppvDocId = paramMap.get("elct_appv_doc_id").toString();

					/* 전자결재 진행 상태 */
					/* docSts : 전자결재 외부연동 API 문서 상태값 */
					elctAppvDocStatus = paramMap.get("docStatus").toString(); 

					/* qr 데이터 */
					if(paramMap.get("qr_send_yn").toString().equals("Y")) {
						qrData = maxRNo+"";
					}

					/* qr 발송상태 */
					qrSendStatusCode = ""; // QR발송 후 업데이트

				}
				/* 결재 비연동 */
				else {
					visitPlaceName = paramMap.get("visit_place_name").toString();
					if(paramMap.get("qr_send_yn").equals("Y")) {
						/* 비연동 + qr전송(Y)인 경우 해당 r_no 값 저장 후 return - qr 전송을 위함 */
//						r_no_list.add(maxRNo);
						qrData = maxRNo+"";
					}
					eletAppvLinkYn = "N";
				}

				insertData.put("approvalYn", approvalYn);
				insertData.put("visit_place_name", visitPlaceName);
				insertData.put("elet_appv_link_yn",eletAppvLinkYn);
				insertData.put("elet_appv_interface_key", eletAppvInterfaceKey);
				insertData.put("elct_appv_doc_id", elctAppvDocId);
				insertData.put("elct_appv_doc_status", elctAppvDocStatus);
				insertData.put("qr_data",qrData);
				insertData.put("qr_send_status_code",qrSendStatusCode);
				
				Map<String, Object> tMapConnectResult = new HashMap<String, Object>();
				
				/* 결재연동이 아닌 경우의 로직 - 결재연동인 경우에는 별도의 로직을 태움 
				 * 결재연동 && 주차권 발급인 경우 
				 */
				if(!paramMap.get("elet_appv_link_yn").equals("Y") && insertData.get("visit_pticket_yn").equals("Issue")) {
					
					/* 주차권 무료발급인 경우 t-map 연동 */
					insertData.put("connect_type", "insert");
					insertData.put("man_comp_seq", paramMap.get("man_comp_seq"));
					tMapConnectResult = tMapConnect(insertData);

					/* t-map 연동 성공 */
					if(tMapConnectResult.get("resultCode").equals("CM200")) {
						insertData.put("t_map_seq", tMapConnectResult.get("t_map_seq"));
						commonSql.insert("VisitorManageDAO.insertNormalVisitor", insertData);
						commonSql.insert("VisitorManageDAO.insertNormalVisitorInOutTime", insertData);
						Map<String, Object> visitor = new HashMap<String ,Object>();
						visitor.put("r_no", maxRNo);
						visitor.put("visitorInfo", visitorInfoList[i]);
						visitor.put("message", insertData.get("sVisitNM").toString()+"[성공]");
						insertSuccessList.add(visitor);
					}
					/* t-map 연동 실패 */
					else {
						insertFailList.add(insertData.get("sVisitNM") + "[실패]: " +tMapConnectResult.get("resultMessage"));
					}
				}
				/* 결재 연동이 아닌 경우 또는 주차권 발급이 아닌 경우 바로 insert */
				else {
					commonSql.insert("VisitorManageDAO.insertNormalVisitor", insertData);
					commonSql.insert("VisitorManageDAO.insertNormalVisitorInOutTime", insertData);
					Map<String, Object> visitor = new HashMap<String ,Object>();
					visitor.put("r_no", maxRNo);
					visitor.put("visitorInfo", visitorInfoList[i]);
					visitor.put("message", insertData.get("sVisitNM").toString()+"[성공]");
					insertSuccessList.add(visitor);
				}
			}
			
			String resultCode = "";
			String successMessage = "";
			String failMessage = "";
			String resultMessage = "";
			String visitorInfoListStr = "";
			
			if(insertFailList.size() > 0) {
				
				/* 전부 등록 실패한 경우 */
				if(insertSuccessList.size() == 0) {
					resultCode = "ERR000";
				}
				/* 하나라도 등록 성공한 경우 */
				else {
					resultCode = "ERR001";
				}
				
				for(String message: insertFailList) {
					failMessage += message+"\n";
				}
			}
			else {
				resultCode = "SUCCESS";
			}
			
			for(Map<String, Object> obj : insertSuccessList) {
				successMessage += obj.get("message")+"\n";
				if(paramMap.get("qr_send_yn").equals("Y")) {
					rNoList.add(Integer.parseInt(obj.get("r_no").toString()));
				}
				visitorInfoListStr += obj.get("visitorInfo") + "▦";
			}
			
			resultMessage = successMessage + failMessage + "저장이 성공한 방문객만 등록됩니다. 저장 실패사유를 확인해주세요.";
			
			result.put("r_no_list", rNoList);
			result.put("visitorInfoListStr", visitorInfoListStr);
			result.put("resultCode", resultCode);
			result.put("resultMessage", resultMessage);
		}
		
		catch(Exception e) {
			result.put("resultCode", "FAIL");
			result.put("resultMessage", e.getMessage());
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		
		return result;
	}

	@Override
	public void DeleteVisitorNew(Map<String, Object> paramMap) throws Exception {

		Map<String, Object> param = new HashMap<String, Object>();
		
		SimpleDateFormat format1 = new SimpleDateFormat("yyyyMMdd");
		Date time = new Date();
		int currentTime = Integer.parseInt(format1.format(time));
		
		String[] rNoList = paramMap.get("r_no_list").toString().split(",");

		/* 그룹사 고도화 메뉴 - 무료주차권 삭제 요청 로직(t_map) */
		for(int i=0; i<rNoList .length; i++) {
			paramMap.put("rNo", rNoList[i]);
			Map<String, Object> info = (Map<String, Object>) commonSql.select("VisitorManageDAO.getVisitorInfoSimple", paramMap);
			int visitDt = Integer.parseInt(info.get("visit_dt_fr").toString());
			
			if(info.get("t_map_seq") != null && visitDt >= currentTime) {
				/* 시간 체크 - 이미 지난 주차권인 경우 gw 테이블만 delete */
				param.put("man_comp_seq", info.get("man_comp_seq"));
				param.put("t_map_seq",info.get("t_map_seq"));
				param.put("visit_car_no",info.get("visit_car_no"));
				param.put("visitor_nm",info.get("visitor_nm"));
				param.put("visit_hp",info.get("visit_hp"));
				param.put("visit_dt_fr",info.get("visit_dt_fr"));
				param.put("visit_tm_fr",info.get("visit_tm_fr"));
				param.put("visit_aim",info.get("visit_aim"));
				param.put("visit_car_out_time", info.get("visit_car_out_time"));
				param.put("connect_type", "delete");

				Map<String, Object> tMapConnectResult = tMapConnect(param);

				if(tMapConnectResult.get("resultCode").equals("CM200")) {
					paramMap.put("R_NO", rNoList[i]);
					commonSql.delete("VisitorManageDAO.deleteVisitor", paramMap);
				}
				else if(tMapConnectResult.get("resultCode").equals("RM480")) {
					throw new Exception("현재 사용중인 주차권이므로 삭제할 수 없습니다.");
				}
				// 이미 출차시간이 지난 경우
				else if(tMapConnectResult.get("resultCode").equals("RM470")){
					paramMap.put("R_NO", rNoList[i]);
					commonSql.delete("VisitorManageDAO.deleteVisitor", paramMap);
				}
				else {
					throw new Exception("무료 주차권 삭제 처리 중 오류..");
				}
				
			}
			else {
				paramMap.put("R_NO", rNoList[i]);
				commonSql.delete("VisitorManageDAO.deleteVisitor", paramMap);
			}

		}
	}

	@Override
	public Map<String, Object> getNormalVisitorList(Map<String, Object> paramMap, PaginationInfo paginationInfo) {
		return commonSql.listOfPaging2(paramMap, paginationInfo, "VisitorManageDAO.getNormalVisitorList");
	}

	@Override
	public Map<String, Object> getVisitorNew(Map<String, Object> paramMap) throws Exception {

		Map<String, Object> result = (Map<String, Object>) commonSql.select("VisitorManageDAO.getNormalVisitorList", paramMap); 
		
		if(result.get("visit_place_code") != null && result.get("visit_place_code") != null) {
			String visitPlace = CommonCodeUtil.getCodeName("VISIT001", result.get("visit_place_code").toString());
			String visitPlaceSub = CommonCodeUtil.getCodeName("VISIT002", result.get("visit_place_sub_code").toString());
			result.put("visit_place", visitPlace);
			result.put("visit_place_sub", visitPlaceSub);
		}

		return result;
	}

	@Override
	public String getEmpTelNum(Map<String, Object> request) {

		return (String)commonSql.select("VisitorManageDAO.getEmpTelNum", request);
	}

	@Override
	public Map<String, Object> CheckVisitorNew(Map<String, Object> paramMap) {
		Map<String ,Object> result = new HashMap<String ,Object>();

		try {
			commonSql.update("VisitorManageDAO.CheckNormalVisitor", paramMap);
			
			result.put("resultCode", "SUCCESS");
			result.put("resultMessage", "입/퇴실 체크 완료");
		}
		catch(Exception e) {
			result.put("resultCode", "ERR000");
			result.put("resultMessage", "입/퇴실 체크 오류");
		}

		return result;


	}

	@Override
	public Map<String, Object> CheckVisitCard(Map<String, Object> paramMap) {

		Map<String, Object> result = new HashMap<String, Object>();

		/* 퇴실처리하지 않은 표찰번호인지 여부 확인 */
		int check = (int)commonSql.select("VisitorManageDAO.getCheckVisitCardNo", paramMap);
		if(check > 0) {
			result.put("resultCode", "ERR001");
			result.put("resultMessage", "이미 사용중인 번호입니다.");
			return result;
		}
		result.put("resultCode", "SUCCESS");
		result.put("resultMessage", "");

		return result; 
	}

	@Override
	public String getEaDocFormId(Map<String, Object> paramMap) {
		return (String) commonSql.select("VisitorManageDAO.getEaDocFormId", paramMap);
	}

	@Override
	public int getEaDocId(Map<String, Object> request) {
		return (int) commonSql.select("VisitorManageDAO.getEaDocId", request);
	}

	/* 일정 등록 */
	@Override
	public Map<String, Object> insertSchedule(Map<String ,Object> param) {

		/* 일정 API Url 설정 */
		String serverName = param.get("serverName").toString();
		String scheduleUrl = serverName + "/schedule/MobileSchedule/InsertAttendSchedule";

		Map<String, Object> result = new HashMap<String, Object>();

		try {

			/* 결재 연동 - popContent에서 입력 데이터 추출 */
			if(param.get("elet_appv_link_yn").toString().equals("Y")) {
				Map<String, Object> popContent = getVisitorPopContent(param);
				/* 방문장소 세팅 */
				popContent.put("visit_place_name", CommonCodeUtil.getCodeName("VISIT001", popContent.get("visit_place_code").toString()));
				param.putAll(popContent);
			}

			JSONObject header = new JSONObject();
			JSONObject body = new JSONObject();
			JSONObject companyInfo = new JSONObject();

			JSONObject indiParam = new JSONObject();
			//			JSONObject calListParam = new JSONObject();
			String mcalSeq = param.get("mcalSeq").toString();

			List<Map<String, Object>> schUserList = new ArrayList<Map<String, Object>>(); //일정사용자목록 - 빈값으로 넘김
			List<Map<String, Object>> schInviterList = new ArrayList<Map<String, Object>>(); //초대자
			List<Map<String, Object>> schReferList = new ArrayList<Map<String, Object>>(); //공개범위

			/* 담당자/등록자 정보 세팅 */
			Map<String, Object> manInfo = (Map<String, Object>) commonSql.select("VisitorManageDAO.getManInfoSch", param);
			Map<String, Object> reqInfo = (Map<String, Object>) commonSql.select("VisitorManageDAO.getReqInfoSch", param);

			/* 공통 */
			header.put("groupSeq", param.get("groupSeq"));
			header.put("compSeq", param.get("man_comp_seq"));
			header.put("tId", "");
			header.put("pId", "");

			/* 담당자 캘린더에 등록 */
			if(param.get("calCheck").equals("man")) {
				companyInfo.put("compSeq", manInfo.get("compSeq"));
				companyInfo.put("bizSeq", manInfo.get("bizSeq"));
				companyInfo.put("empSeq", manInfo.get("empSeq"));
				companyInfo.put("deptSeq", manInfo.get("deptSeq"));
				companyInfo.put("emailAddr", manInfo.get("emailAddr"));
				companyInfo.put("emailDomain", manInfo.get("emailDomain"));
			}
			/* 등록자 캘린더에 등록 */
			else {
				companyInfo.put("compSeq", reqInfo.get("compSeq"));
				companyInfo.put("bizSeq", reqInfo.get("bizSeq"));
				companyInfo.put("empSeq", reqInfo.get("empSeq"));
				companyInfo.put("deptSeq", reqInfo.get("deptSeq"));
				companyInfo.put("emailAddr", reqInfo.get("emailAddr"));
				companyInfo.put("emailDomain", reqInfo.get("emailDomain"));
			}

			/* 일정 등록 - 담당자 */
			//			body.put("companyInfo", companyInfo);
			//			body.put("calType","E");
			//			body.put("writeYn", "N");
			//			body.put("deptSeq", param.get("man_dept_seq"));
			//			body.put("empSeq", param.get("man_emp_seq"));
			//			body.put("langCode", "kr");

			//			calListParam.put("header", header);
			//			calListParam.put("body", body);

			//			JSONObject calListData =  getPostJSON(scheduleListUrl, calListParam.toString());

			/* 개인캘린더 목록 조회 */
			//			if(calListData != null && calListData.get("resultCode").equals("0") && calListData.get("result") != null && !calListData.get("result").equals("")) {
			//				String calListInfo = calListData.get("result").toString();
			//				JSONObject  jsonObject = JSONObject.fromObject(JSONSerializer.toJSON(calListInfo));
			//				JSONArray calListResult = (JSONArray)jsonObject.getJSONArray("calList");
			//				JSONObject obj = (JSONObject) calListResult.get(0);
			//				mcalSeq = obj.get("mcalSeq").toString();
			//			}
			//			else {
			//				result.put("resultCode", "FAIL");
			//				result.put("resultMessage", "개인 캘린더 목록 조회 API 호출 실패 ");
			//				return result;
			//			}
			/***** 담당자 개인캘린더 목록 조회 완료 - mcalSeq 세팅 *****/

			//			body.clear();

			/* 담당자와 등록자가 다른 경우 */
			JSONObject inviteObj = new JSONObject();

			if(!param.get("man_emp_seq").equals(param.get("req_emp_seq"))) {
				if(param.get("calCheck").equals("man")) {
					inviteObj.put("inviterType","W");
					inviteObj.put("empSeq",reqInfo.get("empSeq"));
					inviteObj.put("empName",reqInfo.get("empName"));
					inviteObj.put("compSeq",reqInfo.get("compSeq"));
					inviteObj.put("deptSeq",reqInfo.get("deptSeq"));
				}
				else {
					inviteObj.put("inviterType","W");
					inviteObj.put("empSeq",manInfo.get("empSeq"));
					inviteObj.put("empName",manInfo.get("empName"));
					inviteObj.put("compSeq",manInfo.get("compSeq"));
					inviteObj.put("deptSeq",manInfo.get("deptSeq"));
				}
				schInviterList.add(inviteObj);
			}

			/* 결재연동 시 결재라인/수신참조 - 초대자/공개범위 세팅 */
			if(param.get("elet_appv_link_yn").equals("Y")) {
				/* 결재라인 - 초대자 */
				List<Map<String,Object>> appLineList = commonSql.list("VisitorManageDAO.getEapAppLineList", param);
				if(appLineList.size() > 0 ) {
					for( Map<String, Object> obj : appLineList ) {
						obj.put("inviterType", "W");
						schInviterList.add(obj);
					}
				}
				/* 수신참조 - 공개범위 */
				List<Map<String,Object>> refList = commonSql.list("VisitorManageDAO.getEapRefList", param);
				if(refList.size() > 0) {
					for( Map<String, Object> obj : refList ) {
						schReferList.add(obj);
					}
				}
			}

			/* schTitle 설정 */
			String visitDistinct = "";
			if(param.get("visit_place_sub_code").equals("normal")) {
				visitDistinct = "일반";
			}
			else if(param.get("visit_place_sub_code").equals("edu")) {
				visitDistinct  = "교육";
			}
			else {
				visitDistinct  = "VIP";
			}
			String schTitle = param.get("visit_place_name") + "/" + visitDistinct + " 방문객 방문";

			/* 내용 설정 */
			String contents = "※ 방문자 정보\n";
			String[] visitorInfoList = param.get("visitor_detail_info").toString().substring(0, param.get("visitor_detail_info").toString().length()-1).split("▦");
			for(int i=0; i<visitorInfoList.length; i++) {
				String[] visitorInfo = visitorInfoList[i].split("\\|");

				for(int j=0; j<visitorInfo.length; j++) {
					if(j == 0) {
						contents += "- 회사 : " + visitorInfo[j] + "\n";}
					else if(j == 1) {
						contents += "- 이름 : " + visitorInfo[j] + "\n";}
					else if(j == 2) {
						contents += "- 전화번호 : " + visitorInfo[j] + "\n";}
					else if(j == 3) {
						if(visitorInfo[j].equals("")) {
							contents += "- 차량번호 : " + "미등록\n";
						}
						else {
							contents += "- 차량번호 : " + visitorInfo[j] + "\n";
						}
					}
					else {
						continue;
					}
				}
				contents += "\n";
			}

			// 개인 전체일정
			body.put("companyInfo", companyInfo);
			body.put("mcalSeq", mcalSeq);
			body.put("calType", "E");
			body.put("schViewer", "");
			body.put("langCode", "kr");
			body.put("startDate", param.get("visit_dt_fr"));
			body.put("endDate", param.get("visit_dt_fr"));
			body.put("schTitle", schTitle);
			body.put("contents", contents);
			body.put("attDivCode", "");
			body.put("schPlace", "");
			body.put("alldayYn", "N");
			body.put("alarm_yn", "N");
			body.put("groupSeq", param.get("groupSeq"));
			if(param.get("calCheck").equals("man")) {
				body.put("empSeq", param.get("man_emp_seq"));
				body.put("compSeq", param.get("man_comp_seq"));
				body.put("deptSeq", param.get("man_dept_seq"));
			}
			else {
				body.put("empSeq", param.get("req_emp_seq"));
				body.put("compSeq", param.get("req_comp_seq"));
				body.put("deptSeq", param.get("req_dept_seq"));
			}
			body.put("schUserList", schUserList);
			body.put("inviterType", "M");
			body.put("schInviterList", schInviterList);
			body.put("schReferList", schReferList);

			indiParam.put("header", header);
			indiParam.put("body", body);

			JSONObject insertData = getPostJSON(scheduleUrl, indiParam.toString());
			if(insertData != null && insertData.get("resultCode").equals("0") && insertData.get("result") != null && !insertData.get("result").equals("")) {
				result.put("resultCode", "SUCCESS");
				result.put("resultMessage", "일정 등록 성공");
			}
			else {
				result.put("resultCode", "FAIL");
				result.put("resultMessage", "일정 등록 API 호출 실패 ");
				throw new Exception("일정 등록 API 호출 실패");
			}
		}
		catch( Exception e ) {
			result.put("resultCode", "FAIL");
			result.put("resultMessage", "일정 등록 중 예외 오류 발생 " + e);
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}
		return result;

	}

	public static JSONObject getPostJSON(String url, String data) {
		StringBuilder sbBuf = new StringBuilder();
		HttpURLConnection con = null;
		BufferedReader brIn = null;
		OutputStreamWriter wr = null;
		String line = null;
		try {
			con = (HttpURLConnection) new URL(url).openConnection();
			con.setRequestMethod("POST");
			con.setConnectTimeout(5000);
			con.setRequestProperty("Content-Type", "application/json;charset=UTF-8");
			con.setDoOutput(true);
			con.setDoInput(true);

			wr = new OutputStreamWriter(con.getOutputStream());
			wr.write(data);
			wr.flush();
			brIn = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8"));
			while ((line = brIn.readLine()) != null) {
				sbBuf.append(line);
			}
			// System.out.println(sbBuf);

			JSONObject rtn = JSONObject.fromObject(sbBuf.toString());

			sbBuf = null;

			return rtn;
		} catch (Exception e) {
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			return null;
		} finally {
			try {
				if(wr!=null) {//Null Pointer 역참조
				wr.close();
				}
			} catch (Exception e) {
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
			try {
				if(brIn!=null) {//Null Pointer 역참조
				brIn.close();
				}
			} catch (Exception e) {
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
			try {
				if(con!=null) {//Null Pointer 역참조
				con.disconnect();
				}
			} catch (Exception e) {
				CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			}
		}
	}

	@Override
	public Map<String, Object> checkCalendar(Map<String, Object> paramMap) {

		Map<String, Object> result = new HashMap<String, Object>();

		String scheduleListUrl = paramMap.get("url").toString();

		JSONObject header = new JSONObject();
		JSONObject body = new JSONObject();
		JSONObject companyInfo = new JSONObject();
		JSONObject calListParam = new JSONObject();

		/* 공통 */
		header.put("groupSeq", paramMap.get("groupSeq"));
		header.put("compSeq", paramMap.get("man_comp_seq"));
		header.put("tId", "");
		header.put("pId", "");

		/* 담당자 정보 세팅 */
		Map<String, Object> manInfo = (Map<String, Object>) commonSql.select("VisitorManageDAO.getManInfoSch", paramMap);
		companyInfo.put("compSeq", manInfo.get("compSeq"));
		companyInfo.put("bizSeq", manInfo.get("bizSeq"));
		companyInfo.put("empSeq", manInfo.get("empSeq"));
		companyInfo.put("deptSeq", manInfo.get("deptSeq"));
		companyInfo.put("emailAddr", manInfo.get("emailAddr"));
		companyInfo.put("emailDomain", manInfo.get("emailDomain"));

		/* 일정 등록 - 담당자 */
		body.put("companyInfo", companyInfo);
		body.put("calType","E");
		body.put("writeYn", "N");
		body.put("deptSeq", paramMap.get("man_dept_seq"));
		body.put("empSeq", paramMap.get("man_emp_seq"));
		body.put("langCode", "kr");

		calListParam.put("header", header);
		calListParam.put("body", body);

		JSONObject calListData =  getPostJSON(scheduleListUrl, calListParam.toString());

		String mcalSeq = "";

		/* 개인캘린더 목록 조회 */
		if(calListData != null && calListData.get("resultCode").equals("0") && calListData.get("result") != null && !calListData.get("result").equals("")) {
			String calListInfo = calListData.get("result").toString();
			JSONObject  jsonObject = JSONObject.fromObject(JSONSerializer.toJSON(calListInfo));
			JSONArray calListResult = (JSONArray)jsonObject.getJSONArray("calList");
			if(calListResult.size() > 0) {
				JSONObject obj = (JSONObject) calListResult.get(0);
				mcalSeq = obj.get("mcalSeq").toString();
				result.put("resultCode", "man");
			}
			else {
				result.put("resultCode", "no");
				result.put("mcalSeq", mcalSeq);
			}
		}
		else {
			result.put("resultCode", "FAIL");
			result.put("resultMessage", "개인 캘린더 목록 조회 API 호출 실패 ");
		}

		/* 담당자 캘린더 부재인 경우 등록자 체크 */
		if(result.get("resultCode").equals("no")) {

			companyInfo.clear();
			body.clear();

			Map<String, Object> reqInfo = (Map<String, Object>) commonSql.select("VisitorManageDAO.getReqInfoSch", paramMap);
			companyInfo.put("compSeq", reqInfo.get("compSeq"));
			companyInfo.put("bizSeq", reqInfo.get("bizSeq"));
			companyInfo.put("empSeq", reqInfo.get("empSeq"));
			companyInfo.put("deptSeq", reqInfo.get("deptSeq"));
			companyInfo.put("emailAddr", reqInfo.get("emailAddr"));
			companyInfo.put("emailDomain", reqInfo.get("emailDomain"));

			body.put("companyInfo", companyInfo);
			body.put("calType","E");
			body.put("writeYn", "N");
			body.put("deptSeq", paramMap.get("req_dept_seq"));
			body.put("empSeq", paramMap.get("req_emp_seq"));
			body.put("langCode", "kr");

			calListParam.put("body", body);

			calListData =  getPostJSON(scheduleListUrl, calListParam.toString());

			if(calListData != null && calListData.get("resultCode").equals("0") && calListData.get("result") != null && !calListData.get("result").equals("")) {
				String calListInfo = calListData.get("result").toString();
				JSONObject  jsonObject = JSONObject.fromObject(JSONSerializer.toJSON(calListInfo));
				JSONArray calListResult = (JSONArray)jsonObject.getJSONArray("calList");
				if(calListResult.size() > 0) {
					JSONObject obj = (JSONObject) calListResult.get(0);
					mcalSeq = obj.get("mcalSeq").toString();
					result.put("resultCode", "req");
				}
				else {
					result.put("resultCode", "no");
				}
			}
			else {
				result.put("resultCode", "FAIL");
				result.put("resultMessage", "개인 캘린더 목록 조회 API 호출 실패 ");
				return result;
			}
		}

		result.put("mcalSeq", mcalSeq);
		return result;
	}

	/* T-map 연동 */
	static String Authorization = "";

	@Override
	public Map<String, Object> tMapConnect(Map<String, Object> paramMap) throws Exception {

		Map<String, Object> result = new HashMap<String, Object>();
		Map<String, Object> param = new HashMap<String, Object>();

		HttpJsonUtil http = new HttpJsonUtil();
		Map<String, Object> header = new HashMap<String, Object>();
		String url = "";

		String status = "";
		String message = "";
		String seq = "";

		JSONObject jsonResult = new JSONObject();
		
		Map<String, Object> tmapServerInfo = (Map<String, Object>) commonSql.select("VisitorManageDAO.getTmapServerInfo", paramMap);
		
		if(Authorization.equals("")) {
			/* 1. access Token 발급 */
			//header 세팅 - API명세서와 다름(Content-Type)
			header.put("Content-Type", "application/x-www-form-urlencoded");
			header.put("Authorization", tmapServerInfo.get("tmap_token"));

			// url 세팅
//			url = "https://gate-dev.tmapparking.co.kr/oauth/oauth2/token";
			url = tmapServerInfo.get("tmap_server").toString() + "/oauth/oauth2/token";
			
			// param 세팅
			param.put("grant_type","client_credentials");
			jsonResult = JSONObject.fromObject( http.executeCustomSSL("POST", url, param, header));

			/* API 호출 실패 */
			if( jsonResult.isNullObject() ) {
				result.put("resultCode", "ERROR");
				result.put("resultMessage", "t-map access Token 발급 중 에러발생..");
				return result;
			}

			String accessToken = String.valueOf(jsonResult.get("access_token"));
			String tokenType = String.valueOf(jsonResult.get("token_type"));

			/* 인증 헤더값 세팅 */
			Authorization = tokenType+" "+accessToken;
		}

		header.put("Content-Type", "application/json;charset=UTF-8");
		header.put("Authorization", Authorization);

		Map<String, Object> tMapInfo = (Map<String, Object>) commonSql.select("VisitorManageDAO.getTmapInfo", paramMap);
		
		/* executeCustomSSLnoEncoding: 임시 인코딩 해제 */
		/* 주차권 신규 발급 */
		if(paramMap.get("connect_type").equals("insert")) {

//			url = "https://gate-dev.tmapparking.co.kr/retail-api/v1/open-api/freecar";
			url = tmapServerInfo.get("tmap_server").toString() + "/retail-api/v1/open-api/freecar";
			
			JSONObject insertParam = new JSONObject();
			insertParam.put("carNum", paramMap.get("sVisitCarNo").toString().replaceAll(" ", ""));
			insertParam.put("carKind", "중형");
			insertParam.put("categoryName", "일반");
			insertParam.put("ownerName", paramMap.get("sVisitNM"));
			insertParam.put("ownerMobileNum", paramMap.get("sVisitHP").toString());

			insertParam.put("startDt", paramMap.get("sVisitFrDT") + paramMap.get("visitCarInTime").toString()+"00");
			insertParam.put("endDt", paramMap.get("sVisitFrDT") + paramMap.get("visitCarOutTime").toString()+"00");

			insertParam.put("memo", paramMap.get("sVisitAIM"));
			insertParam.put("storeId", tMapInfo.get("storeId"));
			insertParam.put("parkingLotId", tMapInfo.get("parkingLotId"));
			insertParam.put("useYN", "Y");

			jsonResult = JSONObject.fromObject( HttpJsonUtil.executeCustomSSLnoEncoding("POST", url, insertParam, header));
			
			if( jsonResult.isNullObject() ) {
				status = "ERROR";
				message = "T-map API 호출 실패..";
			}
			else {
				status = String.valueOf(jsonResult.get("status"));
				message = String.valueOf(jsonResult.get("message"));
			}
			
			String resultMessage = "";
			
			/* 주차권 등록 완료 */
			if(status.equals("CM200")) {
				seq = String.valueOf(jsonResult.get("seq"));
				result.put("t_map_seq", seq);
				resultMessage = "주차권 등록 성공";
			}
			else if(status.equals("RM414") && message.equals("FreeCar Number Duplicated")) {
				resultMessage = "동일한 차량번호로 주차권이 발급되어 있습니다.";
			}
			else if(status.equals("RM430") && message.equals("FreeCar Count is over")) {
				resultMessage = "주차권 발급 가능 대수가 초과하였습니다.";
			}
			else {
				resultMessage = message;
			}
			
			result.put("resultCode", status);
			result.put("resultMessage", resultMessage);

		}
		/* 주차권 수정/삭제 */
		else if(paramMap.get("connect_type").equals("update") || paramMap.get("connect_type").equals("delete")) {

			//url = "https://gate-dev.tmapparking.co.kr/retail-api/v1/open-api/freecarinfo";
			url = tmapServerInfo.get("tmap_server").toString() + "/retail-api/v1/open-api/freecarinfo";
			
			JSONObject updateParam = new JSONObject();
			updateParam.put("seq", paramMap.get("t_map_seq"));
			updateParam.put("carNum", paramMap.get("visit_car_no").toString().replaceAll(" ", ""));
			updateParam.put("carKind", "중형");
			updateParam.put("categoryName", "일반");
			updateParam.put("ownerName", paramMap.get("visitor_nm"));
			updateParam.put("ownerMobileNum", paramMap.get("visit_hp").toString());

			String startDt = "";
			String endDt = "";
			if(paramMap.get("connect_type").equals("update")) {
				startDt = paramMap.get("visit_dt_fr").toString() + paramMap.get("visit_car_in_time").toString()+"00";
				endDt = paramMap.get("visit_dt_fr").toString() + paramMap.get("visit_car_out_time").toString()+"00";
			}
			/* 주차권 삭제 처리 - endDt를 startDt와 같게 처리(주차권 만료) */
			else {
				endDt = paramMap.get("visit_dt_fr").toString() + paramMap.get("visit_car_out_time")+"00";
				startDt = endDt;
			}

			updateParam.put("startDt", startDt);
			updateParam.put("endDt", endDt);

			updateParam.put("memo", paramMap.get("visit_aim"));
			updateParam.put("storeId", tMapInfo.get("storeId"));
			updateParam.put("parkingLotId", tMapInfo.get("parkingLotId"));
			updateParam.put("useYN", "Y");

			jsonResult = JSONObject.fromObject( HttpJsonUtil.executeCustomSSLnoEncoding("PUT", url, updateParam, header));
			
			if( jsonResult.isNullObject() ) {
				status = "ERROR";
				message = "T-map API 호출 실패..";
			}
			else {
				status = String.valueOf(jsonResult.get("status"));
				message = String.valueOf(jsonResult.get("message"));
			}

			if(status.equals("CM200")) {
				result.put("resultCode", status);
				result.put("resultMessage", "주차권 삭제/수정 성공");
			}
			else {
				result.put("resultCode", status);
				result.put("resultMessage", message);
			}
		}
		return result;
	}

	@Override
	public Map<String, Object> tMapConnectSetting(Map<String, Object> rNoListAndQrSendYn) throws Exception {

		Map<String, Object> param = rNoListAndQrSendYn;
		String rNoList = param.get("r_no_list").toString();
		String[] rNoArr = rNoList.split(",");
		Map<String, Object> result = new HashMap<String, Object>();
		List<Map<String, Object>> failList = new ArrayList<Map<String, Object>>();
		
		param.put("connect_type", "insert");
		for(int i=0; i<rNoArr.length; i++) {
			param.put("rNo", rNoArr[i]);
			Map<String, Object> info = (Map<String, Object>) commonSql.select("VisitorManageDAO.getVisitorInfoSimple", param);

			if(info.get("visit_pticket_yn").equals("Issue")) {

				/* 파라미터 세팅 */
				param.put("man_comp_seq", info.get("man_comp_seq"));
				param.put("sVisitCarNo", info.get("visit_car_no"));
				param.put("sVisitNM", info.get("visitor_nm"));
				param.put("sVisitHP", info.get("visit_hp"));
				param.put("sVisitFrDT", info.get("visit_dt_fr"));
				param.put("sVisitFrTM", info.get("visit_tm_fr"));
				param.put("sVisitAIM", info.get("visit_aim"));
				param.put("visitCarInTime", info.get("visit_car_in_time"));
				param.put("visitCarOutTime", info.get("visit_car_out_time"));
				
				result = tMapConnect(param);

				if(result.get("resultCode").equals("CM200")) {
					param.put("t_map_seq", result.get("t_map_seq"));
					param.put("nR_NO",param.get("rNo"));
					updateTmapSeq(param);
				}
				else {
					Map<String, Object> failObj = new HashMap<String ,Object>();
					failObj.put("status", result.get("status"));
					failObj.put("message", result.get("message"));
					failObj.put("rNo", rNoArr[i]);
					failList.add(failObj);
				}
			}
		}
		if(failList.size() > 0) {
			result.put("resultCode", "ERR000");
			result.put("failList", failList);
		}
		else {
			result.put("resultCode", "SUCCESS");
		}
		
		return result;
	}

	public void updateTmapSeq(Map<String, Object> paramMap) {
		commonSql.update("VisitorManageDAO.updateTmapSeq", paramMap);
	}

	@Override
	public Map<String, Object> checkVisitCarNo(Map<String, Object> paramMap) {

		Map<String, Object> result = new HashMap<String, Object>();

		List<String> carNoList = new ArrayList<String>();
		/* 방문자 차량번호/주차권 발급여부 파싱 */
		String visitCarNoStr[] = paramMap.get("visitCarNoStr").toString().split("▦");
		for(String s : visitCarNoStr) {

			String carNo = s.split("\\|")[0];
			String ticket = s.split("\\|")[1];
			if(ticket.equals("Issue")) {
				carNoList.add(carNo);
			}
		}
		if(carNoList.size() > 0 ) {
			/* 신규 등록 */
			if(!paramMap.get("updateYn").equals("Y")) {
				/* 1. count 조회 */
				List<Map<String, Object>> count = (List<Map<String, Object>>) commonSql.list("VisitorManageDAO.checkPticketCount", paramMap);
				if( Integer.parseInt(count.get(0).get("count")+"") + carNoList.size() > Integer.parseInt(count.get(1).get("count")+"")) {
					result.put("resultCode", "ERR000");
					result.put("resultMessage", "주차권 발급 가능 대수가 초과하였습니다.");
					return result;
				}

				/* 2. 중복 체크 - 건 별로 체크 */
				List<String> dupleList = new ArrayList<String>();
				for(int i=0; i<carNoList.size(); i++) {
					paramMap.put("visitCarNo", carNoList.get(i).replaceAll(" ", ""));

					int duple = (int)commonSql.select("VisitorManageDAO.checkPticketDuple", paramMap);
					if(duple > 0) {
						dupleList.add(paramMap.get("visitCarNo").toString());
					}
				}
				if(dupleList.size() > 0) {
					String dupleCarStr = "";
					for(String carNo : dupleList) {
						dupleCarStr += carNo +",";
					}
					dupleCarStr = dupleCarStr.substring(0, dupleCarStr.length()-1);
					
					result.put("resultCode", "ERR001");
					result.put("resultMessage", "동일한 차량번호로 주차권이 발급되어 있습니다.(" + dupleCarStr + ")");
					return result;
				}
			}
			
			/* update 시 주차권 체크 */
			else {
				/* 1. count 조회 */
				List<Map<String, Object>> count = (List<Map<String, Object>>) commonSql.list("VisitorManageDAO.checkPticketCount", paramMap);
				if( Integer.parseInt(count.get(0).get("count")+"") + carNoList.size() > Integer.parseInt(count.get(1).get("count")+"")) {
					result.put("resultCode", "ERR000");
					result.put("resultMessage", "주차권 발급 가능 대수가 초과하였습니다.");
					return result;
				}
				else {
					/* 차량번호 변경 불가.. tmap에서 변경 안됨 */
				}
			}
		}
		

		result.put("resultCode", "SUCCESS");
		result.put("resultMessage", "주차권 발급 가능");
		return result;
	}

	@Override
	public Map<String, Object> getTmapList(Map<String, Object> paramMap) throws Exception {
		
		Map<String, Object> result = new HashMap<String, Object>();
		Map<String, Object> param = new HashMap<String, Object>();

		HttpJsonUtil http = new HttpJsonUtil();
		Map<String, Object> header = new HashMap<String, Object>();
		String url = "";

		String status = "";
		String message = "";
		String seq = "";

		JSONObject jsonResult = new JSONObject();
		
		Map<String, Object> tmapServerInfo = (Map<String, Object>) commonSql.select("VisitorManageDAO.getTmapServerInfo", paramMap);
		
		if(Authorization.equals("")) {
			/* 1. access Token 발급 */
			//header 세팅 - API명세서와 다름(Content-Type)
			header.put("Content-Type", "application/x-www-form-urlencoded");
			header.put("Authorization", tmapServerInfo.get("tmap_token"));

			// url 세팅
//			url = "https://gate-dev.tmapparking.co.kr/oauth/oauth2/token";
			url = tmapServerInfo.get("tmap_server").toString() + "/oauth/oauth2/token";
			
			// param 세팅
			param.put("grant_type","client_credentials");
			jsonResult = JSONObject.fromObject( http.executeCustomSSL("POST", url, param, header));

			/* API 호출 실패 */
			if( jsonResult.isNullObject() ) {
				result.put("resultCode", "ERROR");
				result.put("resultMessage", "t-map access Token 발급 중 에러발생..");
				return result;
			}

			String accessToken = String.valueOf(jsonResult.get("access_token"));
			String tokenType = String.valueOf(jsonResult.get("token_type"));

			/* 인증 헤더값 세팅 */
			Authorization = tokenType+" "+accessToken;
		}

		header.put("Content-Type", "application/json;charset=UTF-8");
		header.put("Authorization", Authorization);

		Map<String, Object> tMapInfo = (Map<String, Object>) commonSql.select("VisitorManageDAO.getTmapInfo", paramMap);
		
		/* 주차권 목록 조회 API */
		url = tmapServerInfo.get("tmap_server").toString() + "/retail-api/v1/open-api/freecars";
		
		JSONObject searchParam = new JSONObject();
		searchParam.put("storeId", tMapInfo.get("storeId"));
		searchParam.put("parkingLotId", tMapInfo.get("parkingLotId"));
		
		jsonResult = JSONObject.fromObject( HttpJsonUtil.executeCustomSSLnoEncoding("POST", url, searchParam, header));
		
		if( jsonResult.isNullObject() ) {
			status = "ERROR";
			message = "T-map 주차권 목록 조회 API 호출 실패..";
		}
		else {
			status = String.valueOf(jsonResult.get("status"));
			message = String.valueOf(jsonResult.get("message"));
		}
		
		/* 주차권 등록 완료 */
		if(status.equals("CM200")) {
			seq = String.valueOf(jsonResult.get("seq"));
			result.put("resultCode", status);
			result.put("freeCarList", jsonResult.get("freeCarList"));
			result.put("resultMessage", "주차권 목록 조회 성공");
		}
		else {
			result.put("resultCode", status);
			result.put("resultMessage", message);
		}
		
		return result;
		
	}

	@Override
	public List<Map<String, Object>> getQrPlaceCertificationData(Map<String, Object> paramMap) {
		List<Map<String, Object>> list = (List<Map<String, Object>>) commonSql.list("VisitorManageDAO.getQrPlaceCertificationData", paramMap);
		return list;
	}

}