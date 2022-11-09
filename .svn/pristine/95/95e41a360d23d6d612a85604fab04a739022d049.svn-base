package acc.money.web;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import neos.cmm.systemx.comp.service.CompManageService;
import neos.cmm.util.CommonUtil;
import neos.cmm.vo.ConnectionVO;
import net.sf.json.JSONArray;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import acc.money.service.AccMoneyAuthService;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;

@Controller
public class AccMoneyAuthController {

	/* 변수정의 */
	private ConnectionVO conVo = new ConnectionVO();
	/* 변수정의 서비스 */
	@Resource(name = "AccMoneyAuthService")
	private AccMoneyAuthService accMoneyAuthService;

	@Resource(name = "CompManageService")
	private CompManageService compService;

	/* 변수정의 로그 */
	private Logger LOG = LogManager.getLogger(this.getClass());

	/* View */
	/* View - 마스터/관리자 > 회계 > 자금관리 > 자금관리권한설정 */
	@RequestMapping("/accmoney/auth/AccSetAuthView.do")
	public ModelAndView AccSetAuthView(@RequestParam Map<String, Object> param)
			throws Exception {

		LOG.debug("+ [AMAUTH] INFO - @Controller >> /accmoney/auth/AccSetAuthView.do");

		ModelAndView mv = new ModelAndView();

		try {
			/* 변수정의 */
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper
					.getAuthenticatedUser();
			List<Map<String, Object>> compList = null;
			String userSe = loginVO.getUserSe();

			param.put("userSe", userSe);

			/* 반환처리 */
			mv.addObject("groupSeq", (loginVO.getGroupSeq() == null ? "0"
					: loginVO.getGroupSeq()));
			mv.addObject("empSeq",
					(loginVO.getUniqId() == null ? "0" : loginVO.getUniqId()));
			mv.addObject("deptSeq", (loginVO.getOrgnztId() == null ? "0"
					: loginVO.getOrgnztId()));
			mv.addObject("compSeq", (loginVO.getCompSeq() == null ? "0"
					: loginVO.getCompSeq()));
			mv.addObject("langCode", (loginVO.getLangCode() == null ? "kr"
					: loginVO.getLangCode()));
			mv.addObject("userSe",
					(loginVO.getUserSe() == null ? "" : loginVO.getUserSe()));

			if (userSe != null && !userSe.equals("USER")) {
				param.put("groupSeq", loginVO.getGroupSeq());
				param.put("langCode", loginVO.getLangCode());
				param.put("loginId", loginVO.getId());

				if (userSe.equals("ADMIN")) {
					param.put("empSeq", loginVO.getUniqId());
					param.put("compSeq", loginVO.getCompSeq());
				}
				compList = compService.getCompListAuth(param);
			}

			
			// compList = accMoneyAuthService.AccGWCompSelect(loginVO, param);
			JSONArray json = JSONArray.fromObject(compList);

			mv.addObject("compList", compList);
			mv.addObject("compListJson", json);
			mv.addObject("userSe", userSe);
			mv.setViewName("/acc/auth/AccSetAuthView");
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
//			LOG.error("! [AMAUTH] ERROR - " + exceptionAsStrting);
//			e.printStackTrace();
//			throw e;
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
		}

		LOG.debug("- [AMAUTH] INFO - @Controller >> /accmoney/auth/AccSetAuthView.do");

		return mv;
	}

	/* View - 팝업 : 권한편집 */
	@RequestMapping("/accmoney/auth/AccPopEditAuthView.do")
	public ModelAndView AccPopEditAuthView(
			@RequestParam Map<String, Object> param) throws Exception {

		LOG.debug("+ [AMAUTH] INFO - @Controller >> /accmoney/auth/AccSetAuthView.do");

		ModelAndView mv = new ModelAndView();

		try {
			/* 변수정의 */
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper
					.getAuthenticatedUser();

			/* 반환처리 */
			mv.addObject("groupSeq", (loginVO.getGroupSeq() == null ? "0"
					: loginVO.getGroupSeq()));
			mv.addObject("empSeq",
					(loginVO.getUniqId() == null ? "0" : loginVO.getUniqId()));
			mv.addObject("deptSeq", (loginVO.getOrgnztId() == null ? "0"
					: loginVO.getOrgnztId()));
			mv.addObject("compSeq", (loginVO.getCompSeq() == null ? "0"
					: loginVO.getCompSeq()));
			mv.addObject("langCode", (loginVO.getLangCode() == null ? "kr"
					: loginVO.getLangCode()));
			mv.addObject("userSe",
					(loginVO.getUserSe() == null ? "" : loginVO.getUserSe()));

			if ((loginVO.getUserSe() == null ? "" : loginVO.getUserSe())
					.toUpperCase().equals("MASTER")) {
				/* 로그인 사용자가 현재 MASTER 인 경우 */
			} else if ((loginVO.getUserSe() == null ? "" : loginVO.getUserSe())
					.toUpperCase().equals("ADMIN")) {
				/* 로그인 사용자가 현재 ADMIN 인 경우 */
			} else {
				/* 권한이 없는데 접근한 경우.. */
				throw new Exception(
						"[마스터/관리자 > 회계 > 자금관리 > 자금관리권한설정] 권한이 없습니다.");
			}

			mv.setViewName("/acc/auth/popup/AccPopEditAuthView");
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
//			LOG.error("! [AMAUTH] ERROR - " + exceptionAsStrting);
//			e.printStackTrace();
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("- [AMAUTH] INFO - @Controller >> /accmoney/auth/AccSetAuthView.do");

		return mv;
	}

	/* View - 팝업 : 사용자보기 */
	@RequestMapping("/accmoney/auth/AccPopUserShowView.do")
	public ModelAndView AccPopUserShowView(
			@RequestParam Map<String, Object> param) throws Exception {

		LOG.debug("+ [AMAUTH] INFO - @Controller >> /accmoney/auth/AccPopUserShowView.do");

		ModelAndView mv = new ModelAndView();

		try {
			/* 변수정의 */
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper
					.getAuthenticatedUser();

			/* 반환처리 */
			mv.addObject("groupSeq", (loginVO.getGroupSeq() == null ? "0"
					: loginVO.getGroupSeq()));
			mv.addObject("empSeq",
					(loginVO.getUniqId() == null ? "0" : loginVO.getUniqId()));
			mv.addObject("deptSeq", (loginVO.getOrgnztId() == null ? "0"
					: loginVO.getOrgnztId()));
			mv.addObject("compSeq", (loginVO.getCompSeq() == null ? "0"
					: loginVO.getCompSeq()));
			mv.addObject("langCode", (loginVO.getLangCode() == null ? "kr"
					: loginVO.getLangCode()));
			mv.addObject("userSe",
					(loginVO.getUserSe() == null ? "" : loginVO.getUserSe()));

			if ((loginVO.getUserSe() == null ? "" : loginVO.getUserSe())
					.toUpperCase().equals("MASTER")) {
				/* 로그인 사용자가 현재 MASTER 인 경우 */
			} else if ((loginVO.getUserSe() == null ? "" : loginVO.getUserSe())
					.toUpperCase().equals("ADMIN")) {
				/* 로그인 사용자가 현재 ADMIN 인 경우 */
			} else {
				/* 권한이 없는데 접근한 경우.. */
				throw new Exception(
						"[마스터/관리자 > 회계 > 자금관리 > 자금관리권한설정] 권한이 없습니다.");
			}

			mv.setViewName("/acc/auth/popup/AccPopUserShowView");
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
//			LOG.error("! [AMAUTH] ERROR - " + exceptionAsStrting);
//			e.printStackTrace();
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("- [AMAUTH] INFO - @Controller >> /accmoney/auth/AccSetAuthView.do");

		return mv;
	}

	/* Resource */
	/* 조회 */
	/* 조회 - 부서별 권한자 조회 */
	@RequestMapping("/accmoney/auth/DeptAuthEmpListInfoSelect.do")
	public ModelAndView DeptAuthEmpListInfoSelect(
			@RequestParam Map<String, Object> params, HttpServletRequest request)
			throws Exception {

		LOG.debug("+ [AMAUTH] INFO - @Controller >> /accmoney/auth/DeptAuthEmpListInfoSelect.do");

		ModelAndView mv = new ModelAndView();

		try {
			/* 변수정의 */
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper
					.getAuthenticatedUser();
			List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();

			/* 초기값 정의 */

			/* 조회 */
			result = accMoneyAuthService.DeptAuthEmpListInfoSelect(loginVO,
					params);

			/* 반환처리 */
			mv.setViewName("jsonView");
			mv.addObject("aaData", result);
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
//			LOG.error("! [AMAUTH] ERROR - " + exceptionAsStrting);
//			e.printStackTrace();
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("- [AMAUTH] INFO - @Controller >> /accmoney/auth/DeptAuthEmpListInfoSelect.do");

		return mv;
	}

	/* 조회 - 권한목록 조회 */
	@RequestMapping("/accmoney/auth/AuthListInfoSelect.do")
	public ModelAndView AuthListInfoSelect(
			@RequestParam Map<String, Object> params, HttpServletRequest request)
			throws Exception {

		LOG.debug("+ [AMAUTH] INFO - @Controller >> /accmoney/auth/AuthListInfoSelect.do");

		ModelAndView mv = new ModelAndView();

		try {
			/* 변수정의 */
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper
					.getAuthenticatedUser();
			List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();

			/* 조회 */
			result = accMoneyAuthService.AuthListInfoSelect(loginVO, params);

			/* 반환처리 */
			mv.setViewName("jsonView");
			mv.addObject("authList", result);
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
//			LOG.error("! [AMAUTH] ERROR - " + exceptionAsStrting);
//			e.printStackTrace();
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("- [AMAUTH] INFO - @Controller >> /accmoney/auth/AuthListInfoSelect.do");

		return mv;
	}

	/* 조회 - 권한목록 조회 검색 */
	@RequestMapping("/accmoney/auth/AuthListInfoSearchSelect.do")
	public ModelAndView AuthListInfoSearchSelect(
			@RequestParam Map<String, Object> params, HttpServletRequest request)
			throws Exception {

		LOG.debug("+ [AMAUTH] INFO - @Controller >> /accmoney/auth/AuthListInfoSearchSelect.do");

		ModelAndView mv = new ModelAndView();

		try {
			/* 변수정의 */
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper
					.getAuthenticatedUser();
			List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();

			/* 초기값 정의 */

			/* 조회 */
			result = accMoneyAuthService.AuthListInfoSearchSelect(loginVO,
					params);

			/* 반환처리 */
			mv.setViewName("jsonView");
			mv.addObject("authList", result);
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
//			LOG.error("! [AMAUTH] ERROR - " + exceptionAsStrting);
//			e.printStackTrace();
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("- [AMAUTH] INFO - @Controller >> /accmoney/auth/AuthListInfoSearchSelect.do");

		return mv;
	}

	/* 조회 - 권한대상자 조회 */
	@RequestMapping("/accmoney/auth/AuthEmpListInfoSelect.do")
	public ModelAndView AuthEmpListInfoSelect(
			@RequestParam Map<String, Object> params, HttpServletRequest request)
			throws Exception {

		LOG.debug("+ [AMAUTH] INFO - @Controller >> /accmoney/auth/AuthEmpListInfoSelect.do");

		ModelAndView mv = new ModelAndView();

		try {
			/* 변수정의 */
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper
					.getAuthenticatedUser();
			List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();

			/* 조회 */
			result = accMoneyAuthService.AuthEmpListInfoSelect(loginVO, params);

			/* 반환처리 */
			mv.setViewName("jsonView");
			mv.addObject("orgChart", result);
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
//			LOG.error("! [AMAUTH] ERROR - " + exceptionAsStrting);
//			e.printStackTrace();
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("- [AMAUTH] INFO - @Controller >> /accmoney/auth/AuthEmpListInfoSelect.do");

		return mv;
	}

	/* 조회 - 메뉴목록 조회 */
	@RequestMapping("/accmoney/auth/AuthMenuListInfoSelect.do")
	public ModelAndView AuthMenuListInfoSelect(
			@RequestParam Map<String, Object> params, HttpServletRequest request)
			throws Exception {

		LOG.debug("+ [AMAUTH] INFO - @Controller >> /accmoney/auth/AuthMenuListInfoSelect.do");

		ModelAndView mv = new ModelAndView();

		try {
			/* 변수정의 */
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper
					.getAuthenticatedUser();
			List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();

			/* 조회 */
			result = accMoneyAuthService
					.AuthMenuListInfoSelect(loginVO, params);

			/* 반환처리 */
			mv.setViewName("jsonView");
			mv.addObject("menuAuthList", result);
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
//			LOG.error("! [AMAUTH] ERROR - " + exceptionAsStrting);
//			e.printStackTrace();
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("- [AMAUTH] INFO - @Controller >> /accmoney/auth/AuthMenuListInfoSelect.do");

		return mv;
	}

	/* 조회 - ERP 조직도 정보 조회 */
	@RequestMapping("/accmoney/auth/ErpDeptListInfoSelect.do")
	public ModelAndView ErpDeptListInfoSelect(
			@RequestParam Map<String, Object> params, HttpServletRequest request)
			throws Exception {

		LOG.debug("+ [AMAUTH] INFO - @Controller >> /accmoney/auth/ErpDeptListInfoSelect.do");

		ModelAndView mv = new ModelAndView();

		try {
			/* 변수정의 */
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper
					.getAuthenticatedUser();
			List<Map<String, Object>> gwErpInfo = new ArrayList<Map<String, Object>>();
			List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
			String userSe = loginVO.getUserSe();
			List<Map<String, Object>> selectBoxList = new ArrayList<Map<String,Object>>();
			Map<String, Object> selectBoxListData = null;

			/* 초기값 정의 */

			/* 조회 */
			/* ERP, 그룹웨어 맵핑 정보값 조회 */
			params.put("userSe", userSe);
			params.put("langCode", loginVO.getLangCode());
			if (userSe.equals("ADMIN")) {
				params.put("compSeq", loginVO.getCompSeq());
			}

			/* 조회 - GW erp 맵핑된 회사 가져오기 */
			gwErpInfo = accMoneyAuthService.GWErpInfoSelect(loginVO, params);

			/* ERP 데이터 호출을 위한 변수값 정의 */
			if (gwErpInfo != null && gwErpInfo.size() > 0) {
				for (int i = 0; i < gwErpInfo.size(); i++) {
					String driver = gwErpInfo.get(i).get("driver").toString();
					String dataType = gwErpInfo.get(i).get("database_type")
							.toString();
					String userId = gwErpInfo.get(i).get("userid").toString();
					String password = gwErpInfo.get(i).get("password")
							.toString();
					String systemType = gwErpInfo.get(i).get("erp_type_code")
							.toString();
					String url = gwErpInfo.get(i).get("url").toString();

					conVo.setDatabaseType(dataType);
					conVo.setDriver(driver);
					conVo.setPassWord(password);
					conVo.setSystemType(systemType);
					conVo.setUrl(url);
					conVo.setUserId(userId);
					params.put("compSeq", gwErpInfo.get(i).get("comp_seq"));
					params.put("erpCompSeq",
							gwErpInfo.get(i).get("erp_comp_seq"));

					result.addAll(accMoneyAuthService.ErpDeptListInfoSelect(
							loginVO, params, conVo));

				}
			}
			
			
			for(int i=0; i<gwErpInfo.size(); i++) {
				selectBoxListData = new HashMap<String, Object>();
				for(int j=0; j<result.size(); j++) {
					if(gwErpInfo.get(i).get("comp_seq").equals(result.get(j).get("gwCompSeq")) && result.get(j).get("GBN").equals("C")){
						selectBoxListData.put("erpCompName", result.get(j).get("NAME").toString());
						selectBoxListData.put("GWCompName", gwErpInfo.get(i).get("comp_name").toString());
						selectBoxListData.put("compSeq", result.get(j).get("compSeq").toString());
						selectBoxListData.put("selectName", result.get(j).get("NAME").toString() + " - " + gwErpInfo.get(i).get("comp_name").toString());
					}
					
				}
				selectBoxList.add(selectBoxListData);
			}

			/* 반환처리 */
			mv.setViewName("jsonView");
			mv.addObject("selectBoxList", selectBoxList);
			mv.addObject("GWCompInfo", gwErpInfo);
			mv.addObject("GWErpInfoList", result);
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
//			LOG.error("! [AMAUTH] ERROR - " + exceptionAsStrting);
//			e.printStackTrace();
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("- [AMAUTH] INFO - @Controller >> /accmoney/auth/ErpDeptListInfoSelect.do");

		return mv;
	}

	/* 조회 - 권한 맵핑 (erp 조직도, 메뉴) 조회 */
	@RequestMapping("/accmoney/auth/AuthMappingData.do")
	public ModelAndView AuthMappingData(
			@RequestParam Map<String, Object> params, HttpServletRequest request)
			throws Exception {

		LOG.debug("+ [AMAUTH] INFO - @Controller >> /accmoney/auth/AuthMappingData.do");

		ModelAndView mv = new ModelAndView();

		try {
			/* 변수정의 */
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper
					.getAuthenticatedUser();
			List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();

			/* 조회 */
			/* 권한 맵핑 정보값 조회 */
			result = accMoneyAuthService.AuthMappingData(loginVO, params);

			/* 반환처리 */
			mv.setViewName("jsonView");
			mv.addObject("authMappingData", result);
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
//			LOG.error("! [AMAUTH] ERROR - " + exceptionAsStrting);
//			e.printStackTrace();
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("- [AMAUTH] INFO - @Controller >> /accmoney/auth/ErpDeptListInfoSelect.do");

		return mv;
	}

	/* 조회 - 권한 사용자 조회 */
	@RequestMapping("/accmoney/auth/AccPopAuthUserSelect.do")
	public ModelAndView AccPopAuthUserSelect(
			@RequestParam Map<String, Object> params, HttpServletRequest request)
			throws Exception {

		LOG.debug("+ [AMAUTH] INFO - @Controller >> /accmoney/auth/AccPopAuthUserSelect.do");

		ModelAndView mv = new ModelAndView();

		try {
			/* 변수정의 */
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper
					.getAuthenticatedUser();
			List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();

			/* 초기값 정의 */

			/* 조회 */
			/* 권한 맵핑 정보값 조회 */
			result = accMoneyAuthService.AccPopAuthUserSelect(loginVO, params);

			/* 반환처리 */
			mv.setViewName("jsonView");
			mv.addObject("authPopUserSelect", result);
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
//			LOG.error("! [AMAUTH] ERROR - " + exceptionAsStrting);
//			e.printStackTrace();
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("- [AMAUTH] INFO - @Controller >> /accmoney/auth/AccPopAuthUserSelect.do");

		return mv;
	}

	/* 조회 - 조직도 검색 조회 */
	@RequestMapping("/accmoney/auth/AuthEmpListInfoSearchSelect.do")
	public ModelAndView AuthEmpListInfoSearchSelect(
			@RequestParam Map<String, Object> params, HttpServletRequest request)
			throws Exception {

		LOG.debug("+ [AMAUTH] INFO - @Controller >> /accmoney/auth/AuthEmpListInfoSearchSelect.do");

		ModelAndView mv = new ModelAndView();

		try {
			/* 변수정의 */
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper
					.getAuthenticatedUser();
			List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();

			/* 초기값 정의 */

			/* 조회 */
			/* 권한 맵핑 정보값 조회 */
			result = accMoneyAuthService.AuthEmpListInfoSearchSelect(loginVO,
					params);

			/* 반환처리 */
			mv.setViewName("jsonView");
			mv.addObject("authSearchSelect", result);
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
//			LOG.error("! [AMAUTH] ERROR - " + exceptionAsStrting);
//			e.printStackTrace();
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("- [AMAUTH] INFO - @Controller >> /accmoney/auth/AuthEmpListInfoSearchSelect.do");

		return mv;
	}

	/* 생성 */
	/* 생성 - 권한 생성 */
	@RequestMapping("/accmoney/auth/AuthInfoInsert.do")
	public ModelAndView AuthInfoInsert(
			@RequestParam Map<String, Object> params, HttpServletRequest request)
			throws Exception {

		LOG.debug("+ [AMAUTH] INFO - @Controller >> /accmoney/auth/AuthInfoInsert.do");

		ModelAndView mv = new ModelAndView();

		try {
			/* 변수정의 */
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper
					.getAuthenticatedUser();
			Map<String, Object> result = new HashMap<String, Object>();
			String codeValue = null;

			params.put("accMoneyAuthSeq", "");
			params.put("langCode", loginVO.getLangCode());
			/* 생성 */
			result = accMoneyAuthService.AuthInfoInsert(loginVO, params);
			codeValue = result.get("authCode").toString();
			/* 반환처리 */
			mv.setViewName("jsonView");
			mv.addObject("aaData", codeValue);
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
//			LOG.error("! [AMAUTH] ERROR - " + exceptionAsStrting);
//			e.printStackTrace();
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("- [AMAUTH] INFO - @Controller >> /accmoney/auth/AuthInfoInsert.do");

		return mv;
	}

	/* 생성 - 권한 대상자 생성 */
	@RequestMapping("/accmoney/auth/AuthEmpInfoInsert.do")
	public ModelAndView AuthEmpInfoInsert(
			@RequestParam Map<String, Object> params, HttpServletRequest request)
			throws Exception {

		LOG.debug("+ [AMAUTH] INFO - @Controller >> /accmoney/auth/AuthEmpInfoInsert.do");

		ModelAndView mv = new ModelAndView();

		try {
			/* 변수정의 */
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper
					.getAuthenticatedUser();
			Map<String, Object> result = new HashMap<String, Object>();

			/* 초기값 정의 */

			/* 생성 */
			result = accMoneyAuthService.AuthEmpInfoInsert(loginVO, params);

			/* 반환처리 */
			mv.setViewName("jsonView");
			mv.addObject("result", result.get("result"));
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
//			LOG.error("! [AMAUTH] ERROR - " + exceptionAsStrting);
//			e.printStackTrace();
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("- [AMAUTH] INFO - @Controller >> /accmoney/auth/AuthEmpInfoInsert.do");

		return mv;
	}

	/* 생성 - 권한 메뉴, ERP 조직도 생성 */
	@RequestMapping("/accmoney/auth/AuthMenuDeptInfoInsert.do")
	public ModelAndView AuthMenuDeptInfoInsert(
			@RequestParam Map<String, Object> params, HttpServletRequest request)
			throws Exception {

		LOG.debug("+ [AMAUTH] INFO - @Controller >> /accmoney/auth/AuthMenuDeptInfoInsert.do");

		ModelAndView mv = new ModelAndView();

		try {
			/* 변수정의 */
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper
					.getAuthenticatedUser();
			Map<String, Object> result = new HashMap<String, Object>();

			/* 초기값 정의 */

			/* 생성 */
			result = accMoneyAuthService
					.AuthMenuDeptInfoInsert(loginVO, params);

			/* 반환처리 */
			mv.setViewName("jsonView");
			mv.addObject("result", result.get("insertResult"));
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
//			LOG.error("! [AMAUTH] ERROR - " + exceptionAsStrting);
//			e.printStackTrace();
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("- [AMAUTH] INFO - @Controller >> /accmoney/auth/AuthMenuDeptInfoInsert.do");

		return mv;
	}

	/* 생성 - 사용자 지정 권한 */
	@RequestMapping("/accmoney/auth/AuthUserInsert.do")
	public ModelAndView AuthUserInsert(
			@RequestParam Map<String, Object> params, HttpServletRequest request)
			throws Exception {

		LOG.debug("+ [AMAUTH] INFO - @Controller >> /accmoney/auth/AuthUserInsert.do");

		ModelAndView mv = new ModelAndView();

		try {
			/* 변수정의 */
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper
					.getAuthenticatedUser();
			Map<String, Object> result = new HashMap<String, Object>();

			/* 초기값 정의 */

			/* 생성 */
			result = accMoneyAuthService.AuthUserInsert(loginVO, params);

			/* 반환처리 */
			mv.setViewName("jsonView");
			mv.addObject("result", result.get("insertResult"));
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
//			LOG.error("! [AMAUTH] ERROR - " + exceptionAsStrting);
//			e.printStackTrace();
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("- [AMAUTH] INFO - @Controller >> /accmoney/auth/AuthUserInsert.do");

		return mv;
	}

	/* 수정 */
	/* 수정 - 권한 erp 조직도 수정 */
	@RequestMapping("/accmoney/auth/AuthMenuDeptInfoUpdate.do")
	public ModelAndView AuthMenuDeptInfoUpdate(
			@RequestParam Map<String, Object> params, HttpServletRequest request)
			throws Exception {

		LOG.debug("+ [AMAUTH] INFO - @Controller >> /accmoney/auth/AuthMenuDeptInfoUpdate.do");

		ModelAndView mv = new ModelAndView();

		try {
			/* 변수정의 */
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper
					.getAuthenticatedUser();
			Map<String, Object> result = new HashMap<String, Object>();

			/* 초기값 정의 */

			/* 생성 */
			result = accMoneyAuthService
					.AuthMenuDeptInfoUpdate(loginVO, params);

			/* 반환처리 */
			mv.setViewName("jsonView");
			mv.addObject("result", result.get("update"));
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
//			LOG.error("! [AMAUTH] ERROR - " + exceptionAsStrting);
//			e.printStackTrace();
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("- [AMAUTH] INFO - @Controller >> /accmoney/auth/AuthMenuDeptInfoInsert.do");

		return mv;
	}

	/* 삭제 */
	/* 삭제 - 권한 대상자 삭제 */
	@RequestMapping("/accmoney/auth/AuthEmpInfoDelete.do")
	public ModelAndView AuthEmpInfoDelete(
			@RequestParam Map<String, Object> params, HttpServletRequest request)
			throws Exception {

		LOG.debug("+ [AMAUTH] INFO - @Controller >> /accmoney/auth/AuthEmpInfoDelete.do");

		ModelAndView mv = new ModelAndView();

		try {
			/* 변수정의 */
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper
					.getAuthenticatedUser();
			Map<String, Object> result = new HashMap<String, Object>();

			/* 초기값 정의 */

			/* 삭제 */
			result = accMoneyAuthService.AuthEmpInfoDelete(loginVO, params);

			/* 반환처리 */
			mv.setViewName("jsonView");
			mv.addObject("aaData", result);
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
//			LOG.error("! [AMAUTH] ERROR - " + exceptionAsStrting);
//			e.printStackTrace();
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("- [AMAUTH] INFO - @Controller >> /accmoney/auth/AuthEmpInfoDelete.do");

		return mv;
	}

	/* 삭제 - 권한 메뉴, ERP 조직도 삭제 */
	@RequestMapping("/accmoney/auth/AuthMenuDeptInfoDelete.do")
	public ModelAndView AuthMenuDeptInfoDelete(
			@RequestParam Map<String, Object> params, HttpServletRequest request)
			throws Exception {

		LOG.debug("+ [AMAUTH] INFO - @Controller >> /accmoney/auth/AuthMenuDeptInfoDelete.do");

		ModelAndView mv = new ModelAndView();

		try {
			/* 변수정의 */
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper
					.getAuthenticatedUser();
			Map<String, Object> result = new HashMap<String, Object>();

			/* 초기값 정의 */

			/* 삭제 */
			result = accMoneyAuthService
					.AuthMenuDeptInfoDelete(loginVO, params);

			/* 반환처리 */
			mv.setViewName("jsonView");
			mv.addObject("result", result.get("delete"));
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
//			LOG.error("! [AMAUTH] ERROR - " + exceptionAsStrting);
//			e.printStackTrace();
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("- [AMAUTH] INFO - @Controller >> /accmoney/auth/AuthMenuDeptInfoDelete.do");

		return mv;
	}
	
	/* 샥제 - 유저 권한 삭제 */
	@RequestMapping("/accmoney/auth/AccUserAuthDelete.do")
	public ModelAndView AccUserAuthDelete(
			@RequestParam Map<String, Object> params, HttpServletRequest request)
			throws Exception {

		LOG.debug("+ [AMAUTH] INFO - @Controller >> /accmoney/auth/AccUserAuthDelete.do");

		ModelAndView mv = new ModelAndView();

		try {
			/* 변수정의 */
			LoginVO loginVO = (LoginVO) EgovUserDetailsHelper
					.getAuthenticatedUser();
			Map<String, Object> result = new HashMap<String, Object>();

			/* 초기값 정의 */

			/* 삭제 */
			result = accMoneyAuthService
					.AccUserAuthDelete(loginVO, params);

			/* 반환처리 */
			mv.setViewName("jsonView");
			mv.addObject("result", result.get("delete"));
		} catch (Exception e) {
//			StringWriter sw = new StringWriter();
//			e.printStackTrace(new PrintWriter(sw));
//			String exceptionAsStrting = sw.toString();
//			LOG.error("! [AMAUTH] ERROR - " + exceptionAsStrting);
//			e.printStackTrace();
			CommonUtil.printStatckTrace(e);//오류메시지를 통한 정보노출
			throw e;
		}

		LOG.debug("- [AMAUTH] INFO - @Controller >> /accmoney/auth/AccUserAuthDelete.do");

		return mv;
	}
	
}
