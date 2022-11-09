package neos.cmm.systemx.wehagoAdapter.web;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import neos.cmm.menu.service.MenuManageService;
import neos.cmm.systemx.comp.service.CompManageService;
import neos.cmm.systemx.wehagoAdapter.dao.wehagoAdapterDAO;
import neos.cmm.systemx.wehagoAdapter.service.wehagoAdapterService;
import neos.cmm.util.BizboxAProperties;


@Controller
public class wehagoAdapterController {

	@Resource(name="wehagoAdapterService")
	public wehagoAdapterService wehagoManageService;

	@Resource(name = "wehagoAdapterDAO")
	private wehagoAdapterDAO wehagoAdapterDAO;

	@Resource(name="MenuManageService")
	private MenuManageService menuManageService;

	@Resource(name = "CompManageService")
	private CompManageService compService;

	// WEHAGO조직도연동설정 페이지 호출
	@RequestMapping("/systemx/wehagoManageView.do")
	public ModelAndView wehagoManageView(@RequestParam Map<String,Object> paramMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();

		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		if (loginVO == null || !loginVO.getUserSe().equals("MASTER")) {
			mv.setViewName("redirect:/forwardIndex.do");
			return mv;
		}

		mv.setViewName("/neos/cmm/systemx/wehagoAdapter/wehagoManageView");

		return mv;
	}

	// 회사 정보 조회(grid)
	// params = {syncTp: '', compName: '', compCd: '', compRegistNum: '', ownerName: ''}
	@RequestMapping("/systemx/getWehagoSetInfoList.do")
	public ModelAndView getWehagoSetInfo(@RequestParam Map<String,Object> params) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");

		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		if (loginVO != null && loginVO.getUserSe().equals("MASTER")) {
			params.put("langCode", loginVO.getLangCode());
			mv.addObject("wehagoSetInfoList", wehagoAdapterDAO.getWehagoSetInfoList(params));
		}

		return mv;
	}

	// wehago 가입 도메인 조회
	// t_co_comp - wehagoKey = '' or null 인 경우 wehagoJoinPop - iframe 영역 호출할 도메인 및 파라미터 암호화 후 리턴
	// ex) https://api.wehago.com/#/interface/join?is_douzone=T&service_key=SuxBv1ZrCYH1FvRtTHzTY0Sx4a7xM2magy6SIvHPKNOiMViUSXcweGrhNvKxwKq62at9RuswgzJ3b5V3m9t30WHp9RcQ8a3nA4t%2FnCtArb4XVUHp1FDI5gq%2FQtdv8ZWUV65WmSA2sasUvLRa8TgCVev%2Fvx5BYvCn88S%2Bo0WrvC5H5EvOqO2byMkhjqVafAdXTtBDbhc8i2sLneE3XmpcPAeKhbfsqOzwhUbX3I0xrzvugiu2Z%2BckS3JP1Dd70Rs6GkventZGRSoyXU8%2BhOHbnyFR6WI%2Fj6Q2zHlf6vAGNWKluWd%2BDq0O1Bc6RQMuaIgJ9ZAHq%2F8OxhxqaI%2FftlT8wWrGC0mLeax64DMUkHIfcVBjv2QOVFHuTVxnNSql%2Bj8V1uv0jEzSqUgwJIkqLaf9jTbfYlrW%2BGhvNV4tcdb6qsPvcgkbWeMXiFQLuORRzxPy3JpHc69VkpOpuM2p9UcPvBlLqOkN8b7Wa36y9DwWcKwNmjGbLskMqUa3o06vggFaPR4RsEGdFZz3%2FTS4ohkD165coHrtvUrXn9raYvEY38pDzTPf%2F1GxDOcTDhIXzBzyCYFGarIttwAH5j12G46UWIJ0bWyOROdbjRmoDD6LBlxrzc7ufEIl6hwRD2qag43%2FQgmYI12sYgEEDgHadzKZRwiMbRpuQ7BabWbvXCwrT0ko4Z4kfezasP5Q63BxcOkTDJXGKfrn7gxRYAYJb%2F59oH93XTegVcFYOZ%2BRuhV%2Fvfab75S0cf3BMorvR0XKOPLbB5ho88cr7n1iLfSHYyd2DFfn3AZC9wr23IfTLf%2FUxyPHWhD3kufjapXiXkf7luF13PnYRP4XbalNaNJpR0P2H5dgWLUbLtmcjRcW51DMKCQv%2FNy3Ttt1S4MzklkvPbqbyLFj0jXetHBpA2mSxnF1H%2F1ZG4LuMFZ46bXj3UDG458WQdQwQmiEvaZRSkL72WxyC0DTNnO81QQJHdN4NKVjpv%2BUGHPpXhuLZN7SF0cv1D8rKnSh1EMWT7FzakQ1R6N5&service_code=bizbox
	@RequestMapping("/systemx/getWehagoJoinUrl.do")
	public ModelAndView getWehagoJoinUrl(@RequestParam Map<String,Object> paramMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");

		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		if (loginVO != null && loginVO.getUserSe().equals("MASTER")) {
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("langCode", loginVO.getLangCode());

			if (!BizboxAProperties.getCustomProperty("BizboxA.Cust.wehagoCallbackDomain").equals("99")) {
				paramMap.put("domain", BizboxAProperties.getCustomProperty("BizboxA.Cust.wehagoCallbackDomain"));
			}
			else {
				paramMap.put("domain", request.getScheme() + "://" + request.getServerName() + (request.getServerPort() == 80 ? "" : ":" + request.getServerPort()));
			}
			mv.addAllObjects(wehagoManageService.getWehagoJoinUrl(paramMap));
		}
		return mv;
	}

	// getWehagoJoinUrl 조회 성공시 wehago 가입 팝업 호출
	@RequestMapping("/systemx/wehagoJoinPop.do")
	public ModelAndView wehagoJoinPop(@RequestParam Map<String,Object> paramMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/neos/cmm/systemx/wehagoAdapter/pop/wehagoJoinPop");
		return mv;
	}

	// wehago 가입 상태 호출
	// jsp에서 resultCode = C 일떄까지 계속 호출
	// iframe 내부는 wehago에서 처리하는 부분이라 wehago에서 완료시 상태코드 C로 업데이트 해주는것 같고 업데이트 완료때까지 계속 API 호출 체크
	// 완료처리는 hrExtInterlockController - joinCallback 이걸로 업데이트 - 테스트 필요
	@RequestMapping("/systemx/getWehagoJoinState.do")
	public ModelAndView getWehagoJoinState(@RequestParam Map<String,Object> paramMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");

		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		if (loginVO != null) {
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("langCode", loginVO.getLangCode());
			mv.addAllObjects(wehagoManageService.getWehagoJoinState(paramMap));
		}
		return mv;
	}

	// 조직도 최초 연동
	// wehago 가입 상태(t_co_comp - wehago_key != "") 에서 조직도 데이터 전달
	// paramMap = {compSeq: '1000'}
	@RequestMapping("/systemx/wehagoInsertOrgEmpChartAll.do")
	public ModelAndView wehagoInsertOrgEmpChartAll(@RequestParam Map<String,Object> paramMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");

		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		if (loginVO != null && loginVO.getUserSe().equals("MASTER")) {
			String groupSeq = loginVO.getGroupSeq();
			String compSeq = paramMap.get("compSeq").toString();
			paramMap.put("langCode", loginVO.getLangCode());

			mv.addObject("wehagoInsertDutyPositionAll", wehagoManageService.wehagoInsertDutyPositionAll(groupSeq, compSeq));
			mv.addObject("wehagoInsertOrgChartAll", wehagoManageService.wehagoInsertOrgChartAll(groupSeq, compSeq));
			mv.addObject("wehagoInsertEmpAll", wehagoManageService.wehagoInsertEmpAll(groupSeq, compSeq));
		}
		return mv;
	}

	@RequestMapping("/systemx/wehagoLogin.do")
	public ModelAndView wehagoLogin(@RequestParam Map<String,Object> paramMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();

		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		if (loginVO != null) {
			Map<String, Object> wehagoSyncInfo = wehagoAdapterDAO.getWehagoSyncInfo(paramMap);
			if (wehagoSyncInfo.get("wehagoServer").toString().contains("dev")) {
				mv.addObject("mode","dev");
			}
			else {
				mv.addObject("mode","live");
			}

			mv.setViewName("/neos/cmm/systemx/wehagoAdapter/pop/wehagoLogin");
		}
		return mv;
	}

	// wehago 로그인 성공시 paramMap: {state=ac19359-907-7372, access_token=8RQ3Qx8D0JWR2cLUJMj4bHcpMt7qxP, wehago_id=kimyj}
	@RequestMapping("/systemx/wehagoLoginCallback.do")
	public ModelAndView wehagoLoginCallback(@RequestParam Map<String,Object> paramMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();

		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		if (loginVO != null) {
			Map<String, Object> wehagoSyncInfo = wehagoAdapterDAO.getWehagoSyncInfo(paramMap);
			if (wehagoSyncInfo.get("wehagoServer").toString().contains("dev")) {
				mv.addObject("mode","dev");
			}
			else {
				mv.addObject("mode","live");
			}

			mv.setViewName("/neos/cmm/systemx/wehagoAdapter/pop/wehagoLoginCallback");
		}
		return mv;
	}

	@RequestMapping("/systemx/wehagoSendMail.do")
	public ModelAndView wehagoSendMail(@RequestParam Map<String,Object> paramMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");

		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		if (loginVO != null && loginVO.getUserSe().equals("MASTER")) {
			String groupSeq = loginVO.getGroupSeq();
			String compSeq = paramMap.get("compSeq").toString();

			mv.addObject("wehagoSendMail", wehagoManageService.wehagoSendMail(groupSeq, compSeq));
		}
		return mv;
	}

	@RequestMapping("/wehagoApiCall.do")
	public ModelAndView wehagoApiCall(@RequestParam Map<String,Object> paramMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");

		String groupSeq = "";
		String compSeq = "";

		if (paramMap.get("groupSeq") != null) {
			groupSeq = paramMap.get("groupSeq").toString();
			compSeq = paramMap.get("compSeq").toString();
		}
		else {
			LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
			if (loginVO != null) {
				groupSeq = loginVO.getGroupSeq();
			}
		}
		
		String wehagoServer = paramMap.get("wehagoServer").toString();
		String accessTokenIn = paramMap.get("accessTokenIn").toString();
		String hashKeyIn = paramMap.get("hashKeyIn").toString();
		String deviceIdIn = paramMap.get("deviceIdIn").toString();
		String softwareKeyIn = paramMap.get("softwareKeyIn").toString();
		String cno = paramMap.get("cno").toString();

		Map<String, Object> apiParam = new HashMap<String, Object>();
		
		//Map<String,Object> wehagoApiCall = wehagoManageService.wehagoUpdateGroupInfo(groupSeq, paramMap.get("url").toString(), paramMap.get("method").toString(), apiParam);

		//Map<String,Object> wehagoApiCall = wehagoManageService.wehagoApiTest(groupSeq, compSeq, apiParam);

		//Map<String,Object> wehagoApiCall = wehagoManageService.wehagoGetOrgChart(groupSeq, compSeq);

		//Map<String,Object> wehagoApiCall = wehagoManageService.wehagoInsertEmpOneSync(groupSeq, compSeq, "10", "");

		//Map<String,Object> wehagoApiCall = wehagoManageService.wehagoInsertOrgChartAll(groupSeq, compSeq);

		//Map<String,Object> wehagoApiCall = wehagoManageService.wehagoInsertDutyPositionAll(groupSeq, compSeq);
		
		String resultToken = wehagoManageService.wehagoGetServerToken(wehagoServer, accessTokenIn, hashKeyIn, deviceIdIn, softwareKeyIn, cno);
		apiParam.put("resultToken", resultToken);

		mv.addAllObjects(apiParam);

		return mv;
	}

	@RequestMapping("/systemx/wehagoSignInCallback.do")
	public ModelAndView wehagoSignInCallback(@RequestParam Map<String,Object> paramMap, HttpServletRequest request) throws Exception {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("resultCode","fail");

		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		if (loginVO != null) {
			paramMap.put("groupSeq", loginVO.getGroupSeq());
			paramMap.put("empSeq", loginVO.getUniqId());

			Map<String, Object> result = wehagoAdapterDAO.getWehagoSignInUserInfo(paramMap);
			if (result != null) {
				wehagoAdapterDAO.updateWehagoSignInUser(paramMap);
				mv.addObject("resultCode","success");
			}
		}
		return mv;
	}
}
