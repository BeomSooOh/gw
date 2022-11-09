package neos.cmm.erp.batch.controller;

import java.util.TimerTask;

import javax.annotation.Resource;

import neos.cmm.erp.batch.service.ErpPartnerService;
import neos.cmm.util.code.service.CommonCodeService;

public class ErpBatchPartnerController extends TimerTask{

	CommonCodeService commonCodeService;
	
	@Resource(name="ErpPartnerService")
	ErpPartnerService erpPartnerService;
	
	@Override
	public void run() {
		/**
		 * batch 기능 사용 안함. 추후 사용하더라도 개발1팀에서 agent 실행할 예정이라고함.
		 */
		/*try {
			*//** 자동 동기화 기능 사용 여부 조회 *//*
			if (ErpCmmResource.PARTNER_AUTO == null) {
				String autoYn = "N";
				autoYn = CommonCodeUtil.getCodeFlag("ERP010", "205", "1");

				ErpCmmResource.PROJECT_SET_COUNT = CommonUtil.getIntNvl(CommonCodeUtil.getCodeFlag("ERP010", "201", "1"));

				if (EgovStringUtil.isEmpty(autoYn)) {
					ErpCmmResource.PARTNER_AUTO = "N";
				} else {
					ErpCmmResource.PARTNER_AUTO = autoYn;
				}
			}

			*//** 자동 동기화 *//*
			if (ErpCmmResource.PARTNER_AUTO.equals("Y")) {

				*//** 주기체크 *//*
				if (isRunCheck()) {

					ErpCmmResource.PARTNER_SYNC_RUN = true;
					*//** 프로젝트 동기화 시작 *//*
					erpPartnerService.syncPartnerFromErp();

					ErpCmmResource.PARTNER_SYNC_RUN = false;
				}

			} 
		} catch (Exception e) {
			System.out.println("cache code is null!!!");
			ErpCmmResource.PARTNER_SYNC_RUN = false;
		}*/
	}

}
