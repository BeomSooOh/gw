package neos.cmm.systemx.satistics.web;

import java.net.URLDecoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import neos.cmm.db.CommonSqlDAO;
import neos.cmm.systemx.satistics.service.SatisticsService;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import api.poi.service.ExcelService;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

@Controller
public class SatisticsController {
	@Resource(name="SatisticsService")
	private SatisticsService satisticsService;
	
	@Resource ( name = "commonSql" )
	private CommonSqlDAO commonSql;
	
	@Resource(name="ExcelService")
	private ExcelService excelService;
	
	/**
	 * 로그인 내역(View)호출
	 * 2016-10-05 장지훈 최초 작성
	 * */
	@RequestMapping("/cmm/systemx/satistics/loginSatisticsView.do")
	public ModelAndView loginSatisticsView(@RequestParam Map<String,Object> params) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		mv.setViewName("/neos/cmm/systemx/satistics/loginSatisticsView_new");
		
		return mv;
	}
	
	
	/**
	 * 로그인 내역 데이터 가져오기
	 * 2016-10-05 장지훈 최초 작성
	 * 
	 */
	@RequestMapping("/cmm/systemx/satistics/loginSatisticsData.do")
	public ModelAndView loginSatisticsData(@RequestParam Map<String,Object> params) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		if(!loginVO.getUserSe().equals("USER")){
			params.put("groupSeq", loginVO.getGroupSeq());
			params.put("langCode", loginVO.getLangCode());
			
			PaginationInfo paginationInfo = new PaginationInfo();
			paginationInfo.setCurrentPageNo(EgovStringUtil.zeroConvert(params.get("page")));
			paginationInfo.setPageSize(EgovStringUtil.zeroConvert(params.get("pageSize")));
			
			// all, web, mobile, msg
			Map<String, Object> loginSatisticsList = new HashMap<String, Object>();
			
			loginSatisticsList = satisticsService.loginSatisticsData(params, paginationInfo);
			
			mv.addAllObjects(loginSatisticsList);			
		}

		mv.setViewName("jsonView");
		
		return mv;
	}
	
	
	
	/**
	 * 로그인 내역 엑셀 다운로드
	 * 2018-11-23 주성덕 최초 작성
	 * 
	 */
	@RequestMapping("/cmm/systemx/satistics/loginSatisticsDataExcel.do")
	public ModelAndView loginSatisticsDataExcel(@RequestParam Map<String,Object> params, HttpServletResponse servletResponse, HttpServletRequest servletRequest) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		int defaultMaxSize = 25000;
		String empName = (String) params.get("empName");
		String maxRowSizeStr = EgovStringUtil.isNullToString(params.get("maxRowSize"));
		String multiDown = EgovStringUtil.isNullToString(params.get("multiDown"));
		String rowNoStr = EgovStringUtil.isNullToString(params.get("rowNo"));
		int rowNo = !rowNoStr.equals("") ? Integer.parseInt(rowNoStr) : 1;
		int maxRowSize = !maxRowSizeStr.equals("") ? Integer.parseInt(maxRowSizeStr) : defaultMaxSize;
		
		if (maxRowSize > Integer.MAX_VALUE || maxRowSize < Integer.MIN_VALUE) {//정수형 오버플로우 방지 적용
	        throw new IllegalArgumentException("out of bound");
	    }
		
		if(empName != null) {
			//사용자 이름은 JS단에서 URI 인코딩을 하기 때문에 서버에서 UTF-8 포맷으로 디코딩한다.
			params.put("empName", URLDecoder.decode(URLDecoder.decode(empName, "UTF-8")));
		}
		
		if(!loginVO.getUserSe().equals("USER")){
		    if (multiDown.equals("Y")) {
		    	long rowEnd = rowNo == 1 ? maxRowSize : rowNo * maxRowSize;
		    	long rowStart = rowEnd - maxRowSize;
		    	
		    	params.put("rowStart", rowStart);
		    	params.put("rowEnd", rowEnd);
            }
            
			List<Map<String, Object>> list = commonSql.list("Satistics.loginSatisticsExcel", params);
			mv.addObject("excelList", list);
		}
		
		mv.setViewName("jsonView");
		
		return mv;
	}
	
	/**
	 * 로그인 내역 엑셀 totalCount
	 * 2020-07-07 김택주
	 * 
	 */
	@RequestMapping("/cmm/systemx/satistics/loginSatisticsDataTotalCnt.do")
	public ModelAndView loginSatisticsDataTotalCnt(@RequestParam Map<String,Object> params, HttpServletResponse servletResponse, HttpServletRequest servletRequest) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		String empName = (String) params.get("empName");
		params.put("langCode", loginVO.getLangCode());
		
		if(empName != null) {
			//사용자 이름은 JS단에서 URI 인코딩을 하기 때문에 서버에서 UTF-8 포맷으로 디코딩한다.
			params.put("empName", URLDecoder.decode(URLDecoder.decode(empName, "UTF-8")));
		}
		
		if(!loginVO.getUserSe().equals("USER")){
			String totalCount = (String) commonSql.select("Satistics.loginSatisticsExcel_TOTALCOUNT", params);
			mv.addObject("totalCount", totalCount);
		}
		
		mv.setViewName("jsonView");
		return mv;
	}
	
	
	
	/**
	 * 메뉴사용 내역(View)호출
	 * 2016-10-12 장지훈 최초 작성
	 * */
	@RequestMapping("/cmm/systemx/satistics/menuSatisticsView.do")
	public ModelAndView menuSatisticsView(@RequestParam Map<String,Object> params) throws Exception {
		ModelAndView mv = new ModelAndView();
		
//		mv.setViewName("/neos/cmm/systemx/satistics/menuSatisticsView");
		mv.setViewName("/neos/cmm/systemx/satistics/menuSatisticsView_new"); // new
		
		return mv;
	}
	
	@RequestMapping("/cmm/systemx/satistics/menuSatisticsViewPop.do")
	public ModelAndView menuSatisticsViewPop(@RequestParam Map<String,Object> params) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		mv.setViewName("/neos/cmm/systemx/satistics/pop/menuSatisticsViewPop");
		
		return mv;
	}	
	
	/**
	 * 메뉴사용 내역 데이터 가져오기
	 * 2016-10-12 장지훈 최초 작성
	 * 
	 */
	@RequestMapping("/cmm/systemx/satistics/menuSatisticsData.do")
	public ModelAndView menuSatisticsData(@RequestParam Map<String,Object> params) throws Exception {
		ModelAndView mv = new ModelAndView();

		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		if(!loginVO.getUserSe().equals("USER")){
			params.put("groupSeq", loginVO.getGroupSeq());
			params.put("langCode", loginVO.getLangCode());
			
			PaginationInfo paginationInfo = new PaginationInfo();
			paginationInfo.setCurrentPageNo(EgovStringUtil.zeroConvert(params.get("page")));
			paginationInfo.setPageSize(EgovStringUtil.zeroConvert(params.get("pageSize")));
			
			// all, web, mobile, msg
			Map<String, Object> menuSatisticsList = new HashMap<String, Object>();
			
			menuSatisticsList = satisticsService.menuSatisticsData(params, paginationInfo);
			
			mv.addAllObjects(menuSatisticsList);			
		}

		mv.setViewName("jsonView");
		
		return mv;
	}
	
	
	
	/**
	 * 메뉴사용 내역 엑셀 다운로드
	 * 2018-11-23 주성덕 최초 작성
	 * 
	 */
	@RequestMapping("/cmm/systemx/satistics/menuSatisticsDataExcel.do")
	public ModelAndView menuSatisticsDataExcel(@RequestParam Map<String,Object> params, HttpServletResponse servletResponse, HttpServletRequest servletRequest) throws Exception {
		ModelAndView mv = new ModelAndView();
		
		LoginVO loginVO = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		if(!loginVO.getUserSe().equals("USER")){
            params.put("groupSeq", loginVO.getGroupSeq());
            params.put("langCode", loginVO.getLangCode());
            
            PaginationInfo paginationInfo = new PaginationInfo();
            paginationInfo.setCurrentPageNo(EgovStringUtil.zeroConvert(params.get("rowNo")));
            paginationInfo.setPageSize(EgovStringUtil.zeroConvert(params.get("maxRowSize")));
            
			Map<String, Object> preMenuAccessListExcel = satisticsService.menuAccessExcelList(params, paginationInfo);
			
			mv.addAllObjects(preMenuAccessListExcel);
		}
		
        mv.setViewName("jsonView");
        
        return mv;
	}
}
