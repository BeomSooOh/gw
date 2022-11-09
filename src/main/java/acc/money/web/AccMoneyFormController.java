/*
 * Copyright 이재혁 by Duzon Newturns.,
 * All rights reserved.
 */
package acc.money.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import acc.money.service.AccMoneyFormService;
import bizbox.orgchart.service.vo.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;

/**
 *<pre>
 * 1. Package Name	: acc.money.web
 * 2. Class Name	: AccMoneyFormController.java
 * 3. Description	: 
 * ------- 개정이력(Modification Information) ----------
 *    작성일            작성자         작성정보
 *    2016. 6. 15.     이재혁       최초작성
 *  -----------------------------------------------------
 *</pre>
 */

@Controller
public class AccMoneyFormController {
    
    @Resource(name="AccMoneyFormService")
    private AccMoneyFormService accMoneyFormService;
    
    @RequestMapping("/acc/money/AccMoneyForm.do") /* 자금일보 양식 설정  */
    public ModelAndView AccMoneyForm(@RequestParam Map<String, Object> param, HttpServletResponse response) throws Exception {
        LoginVO loginVo = getLoginVO();
        ModelAndView mv = new ModelAndView();
        mv.addObject("compSeq", loginVo.getCompSeq());
        mv.setViewName("/acc/money/AccMoneyForm");       

        return mv;
    }
    
    @RequestMapping("/acc/money/AccMoneyFormInit.do")
    public ModelAndView AccMoneyFormInit(@RequestParam Map<String, Object> param, HttpServletResponse response) throws Exception {
        LoginVO loginVo = getLoginVO();
        ModelAndView mv = new ModelAndView();
        String auth = loginVo.getUserSe();
        param.put("loginVo", loginVo);
        List<HashMap<String, Object>> selectComp = accMoneyFormService.selectComp(param);
        Map<String, Object> map = new HashMap<String, Object>();
        
        /* 스마트 자금관리 옵션 조회 */
        map.put( "smartOption001", accMoneyFormService.SelectSmartOption001( param ) );
        map.put("selectComp", selectComp);
        mv.addObject("compSeq", loginVo.getCompSeq());
        mv.addObject("auth", auth);
        mv.addAllObjects(map);
        mv.setViewName("jsonView");        

        return mv;
    }
    
    @RequestMapping("/acc/money/AccMoneyFormInsert.do") /* 자금일보 양식 저장  */
    public ModelAndView AccMoneyFormInsert(@RequestParam Map<String, Object> param) throws Exception {
        LoginVO loginVo = getLoginVO();
        ModelAndView mv = new ModelAndView();
        param.put("loginVo", loginVo);
        try {
        	accMoneyFormService.UpdateSmartOption001(param);
            accMoneyFormService.InsertMoneyForm(param);
            mv.addObject("data", "y");
            mv.setViewName("jsonView");
        }
        catch (Exception e) {
            //System.out.println(e.getMessage());
            mv.addObject("data", "n");
        }

        return mv;
    }
    
    @RequestMapping("/acc/money/AccMoneyFormBySeq.do") /* 자금일보 양식 가져오기  */
    public ModelAndView AccMoneyFormBySeq(@RequestParam Map<String, Object> param) throws Exception {
        LoginVO loginVo = getLoginVO();
        ModelAndView mv = new ModelAndView();
        param.put("loginVo", loginVo);
        HashMap<String, Object> selForm = new HashMap<String, Object>();
        try {
            selForm = accMoneyFormService.SelectMoneyFormBySeq(param);
            mv.addObject("data", "y");
            mv.addObject("selForm", selForm);
            mv.setViewName("jsonView");
        }
        catch (Exception e) {
            //System.out.println(e.getMessage());
            mv.addObject("data", "n");
        }

        return mv;
    }
    
    private LoginVO getLoginVO(){
        LoginVO loginVo = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
        return loginVo;
    }

}
 

