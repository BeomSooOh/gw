package neos.formEditor;

import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import egovframework.com.cmm.annotation.IncludedInfo;

/**
 * 양식 편집기
 *
 * @author 장지훈 연구원
 * @since 2016.01.08
 * @version 1.0
 * @see <pre>
 * &lt;&lt; 개정이력(Modification Information) &gt;&gt;
 *
 *  수정일                       수정자                      수정내용
 *  -----------  --------    ---------------------------
 *   2016.01.08    장지훈                 최초 생성
 *
 * </pre>
 */
@Controller
public class FormEditorController {
	
	// 양식 편집기 index 페이지 호출
	@IncludedInfo(name="양식편집기", order = 300 ,gid = 60)
	@RequestMapping("/formEditorIndex.do")
	public ModelAndView formEditorIndex(@RequestParam Map<String,Object> paramMap, HttpServletResponse response) throws Exception{
		ModelAndView mv = new ModelAndView();
		
		mv.setViewName("/neos/formEditor/formEditorIndex");
		return mv;
	}
}
