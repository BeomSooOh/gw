package neos.cmm.erp.batch.controller;

import java.util.TimerTask;

import javax.annotation.Resource;

import egovframework.com.utl.fcc.service.EgovStringUtil;
import neos.cmm.erp.batch.service.ErpProjectService;
import neos.cmm.erp.constant.ErpConstant;
import neos.cmm.util.CommonUtil;
import neos.cmm.util.code.CommonCodeUtil;
import neos.cmm.util.code.service.CommonCodeService;

/**
 * erp 프로젝트 데이터 동기화
 * @author yongil
 *
 */
public class ErpBatchProjectController extends TimerTask {
	
	@Resource(name="ErpProjectService")
	ErpProjectService erpProjectSevice;
	
	@Resource(name="CommonCodeService")
	CommonCodeService commonCodeService;
	
	@Override
	public void run() {
		try {
			/** 자동 동기화 기능 사용 여부 조회 */
			if (ErpConstant.PROJECT_AUTO == null) {
				String autoYn = "N";
				autoYn = CommonCodeUtil.getCodeFlag("ERP010", "105", "1");

				ErpConstant.PROJECT_SET_COUNT = CommonUtil.getIntNvl(CommonCodeUtil.getCodeFlag("ERP010", "101", "1"));
				if (EgovStringUtil.isEmpty(autoYn)) {
					ErpConstant.PARTNER_AUTO = "N";
				} else {
					ErpConstant.PARTNER_AUTO = autoYn;
				}
				if (EgovStringUtil.isEmpty(autoYn)) {
					ErpConstant.PROJECT_AUTO = "N";
				} else {
					ErpConstant.PROJECT_AUTO = autoYn;
				}
			}

			/** 자동 동기화 */
			if (ErpConstant.PROJECT_AUTO.equals("Y")) {

				/** 주기체크 */
				if (isRunCheck()) {
					ErpConstant.PROJECT_SYNC_RUN = true;

					/** 프로젝트 동기화 시작 */
					erpProjectSevice.syncProjectFromErp();

					ErpConstant.PROJECT_SYNC_RUN = false;
				}

			} 
		} catch (Exception e) {
			ErpConstant.PROJECT_SYNC_RUN = false;
		}
	}
	
	private boolean isRunCheck() {
		/** 동기화 중인지 */
		if (ErpConstant.PROJECT_SYNC_RUN) {
			return false;
		}
		
		/** 현재주기 횟수 증가 */
		int curCnt = ++ErpConstant.PROJECT_CYCLE_COUNT;
		
		int setCnt = ErpConstant.PROJECT_SET_COUNT;
		
		if (setCnt > 0) {
			if (curCnt >= setCnt) {
				ErpConstant.PROJECT_CYCLE_COUNT = 0;
				return true;
			}
		}
		
		return false;		
		
	}

	

}
