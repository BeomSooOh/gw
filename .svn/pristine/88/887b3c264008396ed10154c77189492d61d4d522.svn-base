/*
배포쿼리 작성예제

-- 소스시퀀스배포 : 2730

/* 2018-08-02 수정사항
[시스템설정]
 - 메뉴정보관리 메뉴사용범위 선택팝업 IE브라우져 오류 수정
 - 공통옵션 쪽지,대화 첨부파일 자동삭제 설정 옵션 추가 (공통구분 추가)
*/

-- 2018-08-02 테이블 추가
CREATE TABLE IF NOT EXISTS `t_co_second_cert` (
  `seq` int(11) NOT NULL AUTO_INCREMENT COMMENT '인증시퀀스',
  `emp_seq` varchar(50) NOT NULL COMMENT '사용자시퀀스',
  `UUID` varchar(50) DEFAULT NULL COMMENT 'UUID',
  `status` char(1) DEFAULT NULL COMMENT '상태값   이차인증(type=L)=>S:성공, R:인증대기,D:본인인증기기아님,F:실패,X:유효하지않은 qr코드,A:이차인증 qr코드가 아님,H:이미 승인요청중인 기기    기기등록(type=D)=>D:이미요청된기기,O:인증기기개수초과,C:재등록불가,M:본인인증기기아님,S:성공,E:사용자 정보 불일치,A:기기등록 qr코드가 아님)',
  `type` char(1) DEFAULT NULL COMMENT '인증종류(L:로그인, D:인증기기등록)',
  PRIMARY KEY (`seq`,`emp_seq`)
) ENGINE=InnoDB AUTO_INCREMENT=2139 DEFAULT CHARSET=utf8 COMMENT='이차인증/기기등록 인증 테이블';

*/


/* 수정사항
[공통]
 - 커스텀 로그인페이지 SSO인증 시 로그인내역 저장하도록 개선
 - 모바일 로그인API 일정모듈 옵션데이터(일정초대사용여부/초대수락자동여부) 추가
[포털]
 - 전자결재 포틀릿 메뉴 바로가기 오류수정

*/

/*
-- 2018-08-02 알림관련 기초데이터 설정
insert ignore into t_alert_setting
(comp_seq, group_seq, alert_type, alert_yn, push_yn, talk_yn, mail_yn, sms_yn, portal_yn, timeline_yn, use_yn, create_seq, create_date, modify_seq, modify_date, divide_type, link_event) VALUES
('SYSTEM', 'SYSTEM', 'CU001', 'Y', 'Y', 'N', 'N', 'N', 'Y', 'N', 'Y', '0', NULL, NULL, NULL, 'CM', NULL);
insert ignore into t_co_event_setting
(type, code, portal_yn, timeline_yn, datas, seq, sub_seq, content_type, view_type, web_view_type, messenger_view_type, action_type, web_action_type) VALUES
('CUST', 'CU001', 'Y', 'N', 'title|contents', '', '', '0', 'B', 'Z', 'Z', 'Z', 'Z');
insert ignore into t_co_event_message
(type, code, lang_code, message_no_preview, param_no_preview, message_title, param_title, message_push, param_push, message_talk, param_talk, message_sms, param_sms, message_mail, param_mail, message_portal, param_portal) VALUES
('CUST', 'CU001', 'kr', '', '', '[%s]', 'title', '[%s] %s', 'title|contents', '[%s] %s', 'title|contents', NULL, NULL, NULL, NULL, NULL, NULL);
insert ignore into t_co_event_message
(type, code, lang_code, message_no_preview, param_no_preview, message_title, param_title, message_push, param_push, message_talk, param_talk, message_sms, param_sms, message_mail, param_mail, message_portal, param_portal) VALUES
('CUST', 'CU001', 'en', '', '', '[%s]', 'title', '[%s] %s', 'title|contents', '[%s] %s', 'title|contents', NULL, NULL, NULL, NULL, NULL, NULL);
insert ignore into t_co_event_message
(type, code, lang_code, message_no_preview, param_no_preview, message_title, param_title, message_push, param_push, message_talk, param_talk, message_sms, param_sms, message_mail, param_mail, message_portal, param_portal) VALUES
('CUST', 'CU001', 'jp', '', '', '[%s]', 'title', '[%s] %s', 'title|contents', '[%s] %s', 'title|contents', NULL, NULL, NULL, NULL, NULL, NULL);
insert ignore into t_co_event_message
(type, code, lang_code, message_no_preview, param_no_preview, message_title, param_title, message_push, param_push, message_talk, param_talk, message_sms, param_sms, message_mail, param_mail, message_portal, param_portal) VALUES
('CUST', 'CU001', 'cn', '', '', '[%s]', 'title', '[%s] %s', 'title|contents', '[%s] %s', 'title|contents', NULL, NULL, NULL, NULL, NULL, NULL);
delete from t_alert_admin where alert_type='CU001';
insert ignore into t_alert_admin
(comp_seq, group_seq, alert_type, alert_yn, push_yn, talk_yn, mail_yn, sms_yn, portal_yn, timeline_yn, use_yn, create_seq, create_date, modify_seq, modify_date, divide_type, link_event)
select b.comp_seq, b.group_seq, a.alert_type, a.alert_yn,a.push_yn, a.talk_yn, a.mail_yn, a.sms_yn, a.portal_yn, a.timeline_yn, a.use_yn, a.create_seq, a.create_date, a.modify_seq, a.modify_date, a.divide_type, a.link_event
from t_alert_setting a
join t_co_comp b on a.alert_type='CU001';

-- 2018-08-02 불필요 메뉴데이터 보정
update t_co_menu set url_gubun = '' where menu_no=501000000;
delete from t_co_menu where menu_no=501020000;
delete from t_co_menu_multi where menu_no=501020000;

-- 2018-08-02 불필요 코드데이터 삭제
delete from t_co_code_detail_multi where code='option0080' and lang_code!='kr';

-- 2018-08-02 공통옵션 쪽지,대화 첨부파일 자동삭제 설정 옵션 추가 (주성덕)
INSERT IGNORE INTO `tcmg_optionset` VALUES ('com100', '1', 'cm', 'single', '쪽지 자동삭제 설정', NULL, NULL, '1', '모바일, 메신저를 포함한 쪽지 데이터를 일정 기간 동안 보관 후 자동 삭제되도록 설정할 수 있습니다.\r\n\r\n쪽지 관련하여 영구보관 또는 첨부파일을\r\n일정 기간 동안 보관 후 자동 삭제되도록 설정할 수 있습니다.', '0', 'option0100', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `tcmg_optionset` VALUES ('com101', '1', 'cm', 'text', '보관기간 설정', 'com100', NULL, '2', '보관기간은 일 단위로 설정 가능하며,\r\n설정한 보관 기간이 지나면 데이터를 자동 삭제 처리합니다.\r\n또한 삭제된 데이터는 복원이 불가능합니다.\r\n\r\n보관기간은 [최소 30일 / 최대 1095일]까지 설정할 수 있습니다.', '30', 'option0054', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `tcmg_optionset` VALUES ('com200', '1', 'cm', 'single', '대화 자동삭제 설정', NULL, NULL, '1', '모바일, 메신저를 포함한 대화 데이터를 일정 기간 동안 보관 후 자동 삭제되도록 설정할 수 있습니다.\r\n\r\n대화 관련하여 영구보관 또는 첨부파일을\r\n일정 기간 동안 보관 후 자동 삭제되도록 설정할 수 있습니다.', '0', 'option0100', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `tcmg_optionset` VALUES ('com201', '1', 'cm', 'text', '보관기간 설정', 'com200', NULL, '2', '보관기간은 일 단위로 설정 가능하며,\r\n설정한 보관 기간이 지나면 데이터를 자동 삭제 처리합니다.\r\n또한 삭제된 데이터는 복원이 불가능합니다.\r\n\r\n보관기간은 [최소 30일 / 최대 1095일]까지 설정할 수 있습니다.', '30', 'option0054', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- 소스시퀀스배포 : 3165
*/

/* 2018-08-02 수정사항
[시스템설정]
 - 사원일괄등록 엑셀양식에 성별, 음력구분, 근태사용여부 추가
*/
/*
-- 2018-08-07 사원일괄등록 컬럼추가
ALTER TABLE t_co_emp_batch ADD COLUMN IF NOT EXISTS gender_code varchar(1);
ALTER TABLE t_co_emp_batch ADD COLUMN IF NOT EXISTS check_work_yn varchar(1);
ALTER TABLE t_co_emp_batch CHANGE COLUMN IF EXISTS bday bday varchar(15);
*/
-- 소스시퀀스배포 : 3196

/* 수정사항
[시스템설정]
 - 공통옵션 첨부파일 보기설정(문서뷰어/파일다운) 메일 모듈 추가.
*/
/*
-- 2018-08-08 공통옵션 첨부파일 보기설정(문서뷰어/파일다운) 메일모듈 추가.
update tcmg_optionset set use_yn = 'Y' where option_id = 'pathSeq700';

ALTER TABLE t_co_dept_batch ADD COLUMN IF NOT EXISTS dept_nickname varchar(128);
ALTER TABLE t_co_dept_batch ADD COLUMN IF NOT EXISTS order_num varchar(32);
ALTER TABLE t_co_dept_batch ADD COLUMN IF NOT EXISTS zip_code varchar(32);
ALTER TABLE t_co_dept_batch ADD COLUMN IF NOT EXISTS addr varchar(256);
ALTER TABLE t_co_dept_batch ADD COLUMN IF NOT EXISTS detail_addr varchar(256);
ALTER TABLE t_co_dept_batch ADD COLUMN IF NOT EXISTS inner_receive_yn varchar(1);
ALTER TABLE t_co_dept_batch ADD COLUMN IF NOT EXISTS standard_code varchar(50);
ALTER TABLE t_co_dept_batch ADD COLUMN IF NOT EXISTS sender_name varchar(64);
ALTER TABLE t_co_dutyposition_batch ADD COLUMN IF NOT EXISTS dp_name_en varchar(128);
ALTER TABLE t_co_dutyposition_batch ADD COLUMN IF NOT EXISTS dp_name_jp varchar(128);
ALTER TABLE t_co_dutyposition_batch ADD COLUMN IF NOT EXISTS dp_name_cn varchar(128);
ALTER TABLE t_co_dutyposition_batch ADD COLUMN IF NOT EXISTS comment_text varchar(512);
*/

-- 소스시퀀스배포 : 3212

/* 수정사항
[시스템설정]
 - 메신저 프로젝트 대화방 프로젝트 게시판 새글 링크 url 수정

[공통]
 - 문서뷰어 기능 수정 (엑셀 시트가 여러개일 경우 스크롤이 없어 확인이 불가능한 부분 수정)
 - api호출 도메인 통합관리 함수 추가
 - 일정포틀릿 생일 양력/음력 구분하여 표시되도록 수정

 [포털]
 - 결재현황 포틀릿 링크호출 시 파라미터 타입 오류수정
*/




-- 소스시퀀스배포 : 3234
/*

-- 2018-08-10
ALTER TABLE t_co_group ADD COLUMN IF NOT EXISTS messenger_gateway_url varchar(512) DEFAULT '';


-- 2018-08-13

CREATE TABLE IF NOT EXISTS `oneffice_document_history` (
	`history_no` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '이력 번호 (auto_increment)',
	`doc_no` VARCHAR(32) NOT NULL COMMENT '문서 번호',
	`action_user` VARCHAR(32) NOT NULL COMMENT '실행자 사번',
	`action_code` CHAR(2) NOT NULL COMMENT '실행코드',
	`action_data` TEXT NULL COMMENT 'action에 따른 보조적인 데이터',
	`user_gps` VARCHAR(32) NULL DEFAULT NULL COMMENT '사용자 GPS',
	`user_ip` VARCHAR(15) NOT NULL COMMENT '사용자 IP',
	`device_info` CHAR(2) NOT NULL COMMENT '접속 장비 정보',
	`reg_date` DATETIME NOT NULL COMMENT '실행일자',
	PRIMARY KEY (`history_no`)
)
COMMENT='원피스 문서 이력 관리'
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=1
;


-- 2018-08-14
ALTER TABLE `t_sc_lunarday`
	ADD INDEX IF NOT EXISTS `lunar_day` (`lunar_day`);

*/


/*

CREATE TABLE IF NOT EXISTS `t_at_personnel_card_master_auth` (
	`group_seq` VARCHAR(50) NOT NULL,
	`emp_seq` VARCHAR(50) NOT NULL,
	PRIMARY KEY (`group_seq`, `emp_seq`)
)
COMMENT='인사기록카드 조회 마스터 권한 테이블'
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;

ALTER TABLE t_co_group_api CHANGE COLUMN IF EXISTS `license_key` `license_key` VARCHAR(32);
*/

-- 소스시퀀스배포  : 3274


/*
-- 2018/08/22(주성덕) 사용자정렬값 컬럼 길이 수정(70 -> 255)
ALTER TABLE `t_co_emp_dept` CHANGE COLUMN IF EXISTS `order_text` `order_text` VARCHAR(255) NULL DEFAULT NULL COMMENT '사용자정렬텍스트' AFTER `order_num`;

insert ignore into t_msg_tcmg_link
(link_seq, link_upper_seq, link_position, group_seq, comp_seq, link_kind, link_nm_kr, link_nm_en, link_nm_jp, link_nm_cn, menu_no, gnb_menu_no, lnb_menu_no, msg_target, target_url, link_param, encrypt_seq, map_key, use_yn, icon_nm, icon_path, icon_ver, order_num, create_seq, create_date, modify_seq, modify_date) VALUES
('00015', '0', 'L', 'varGroupId', '0', 'I', '인사/근태', 'Co-worker service', '', '', 700000000, '', '', 'attend', '/gw/MsgLogOn.do', '', '0', '', 'N', 'btn_left_personnel_normal.png', '/gw/Images/msg/btn_left_personnel_normal.png', '0', 2, '0', NOW(), '0', NOW());

insert ignore into t_msg_tcmg_link
(link_seq, link_upper_seq, link_position, group_seq, comp_seq, link_kind, link_nm_kr, link_nm_en, link_nm_jp, link_nm_cn, menu_no, gnb_menu_no, lnb_menu_no, msg_target, target_url, link_param, encrypt_seq, map_key, use_yn, icon_nm, icon_path, icon_ver, order_num, create_seq, create_date, modify_seq, modify_date) VALUES
('00016', '0', 'L', 'varGroupId', '0', 'I', '회계', 'Co-worker service', '', '', 1000000000, '', '', 'ex', '/gw/MsgLogOn.do', '', '0', '', 'N', 'btn_left_accounting_normal.png', '/gw/Images/msg/btn_left_accounting_normal.png', '0', 2, '0', NOW(), '0', NOW());

insert ignore into t_msg_tcmg_link (link_seq, link_upper_seq, link_position, group_seq, comp_seq, link_kind, link_nm_kr, link_nm_en, link_nm_jp, link_nm_cn, menu_no, gnb_menu_no, lnb_menu_no, msg_target, target_url, link_param, encrypt_seq, map_key, use_yn, icon_nm, icon_path, icon_ver, order_num, create_seq, create_date)
select concat(a.link_seq, '_',b.comp_seq), case when a.link_upper_seq = '0' then '0' else concat(b.comp_seq, '_',a.link_upper_seq) end, a.link_position, b.group_seq, b.comp_seq, a.link_kind, a.link_nm_kr, a.link_nm_en, a.link_nm_jp, a.link_nm_cn, a.menu_no, a.gnb_menu_no, a.lnb_menu_no, a.msg_target,  a.target_url, a.link_param, a.encrypt_seq, a.map_key,  a.use_yn,  a.icon_nm, a.icon_path, 1, a.order_num, 'MIG', now()
from t_msg_tcmg_link a
join t_co_comp b on a.comp_seq='0' and a.link_seq in ('00015','00016');


INSERT ignore INTO `tcmg_optionset` (`option_id`, `option_gb`, `module_gb`, `option_group`, `option_nm`, `p_option_id`, `p_option_must_value`, `option_level`, `option_desc`, `option_d_value`, `option_value_id`, `demo_link`, `search_keyword`, `option_desc2`, `option_nm_en`, `option_nm_jp`, `option_nm_cn`, `option_desc_en`, `option_desc_jp`, `option_desc_cn`, `use_yn`, `display_yn`, `created_by`, `created_dt`, `modify_by`, `modify_dt`, `sort_order`) VALUES ('com100', '1', 'cm', 'single', '쪽지 자동삭제 설정', NULL, NULL, '1', '모바일, 메신저를 포함한 쪽지 데이터를 일정 기간 동안 보관 후 자동 삭제되도록 설정할 수 있습니다.\r\n\r\n쪽지 관련하여 영구보관 또는 첨부파일을\r\n일정 기간 동안 보관 후 자동 삭제되도록 설정할 수 있습니다.\r\n\r\n(※첨부파일 삭제 제외되는 경우 : 관심쪽지, 예약미전송쪽지, 즐겨찾기대화방, 프로젝트대화방※)', '0', 'option0100', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT ignore INTO `tcmg_optionset` (`option_id`, `option_gb`, `module_gb`, `option_group`, `option_nm`, `p_option_id`, `p_option_must_value`, `option_level`, `option_desc`, `option_d_value`, `option_value_id`, `demo_link`, `search_keyword`, `option_desc2`, `option_nm_en`, `option_nm_jp`, `option_nm_cn`, `option_desc_en`, `option_desc_jp`, `option_desc_cn`, `use_yn`, `display_yn`, `created_by`, `created_dt`, `modify_by`, `modify_dt`, `sort_order`) VALUES ('com101', '1', 'cm', 'text', '보관기간 설정', 'com100', NULL, '2', '보관기간은 일 단위로 설정 가능하며,\r\n설정한 보관 기간이 지나면 데이터를 자동 삭제 처리합니다.\r\n또한 삭제된 데이터는 복원이 불가능합니다.\r\n\r\n보관기간은 [최소 30일 / 최대 1095일]까지 설정할 수 있습니다.', '30', 'option0054', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT ignore INTO `tcmg_optionset` (`option_id`, `option_gb`, `module_gb`, `option_group`, `option_nm`, `p_option_id`, `p_option_must_value`, `option_level`, `option_desc`, `option_d_value`, `option_value_id`, `demo_link`, `search_keyword`, `option_desc2`, `option_nm_en`, `option_nm_jp`, `option_nm_cn`, `option_desc_en`, `option_desc_jp`, `option_desc_cn`, `use_yn`, `display_yn`, `created_by`, `created_dt`, `modify_by`, `modify_dt`, `sort_order`) VALUES ('com200', '1', 'cm', 'single', '대화 자동삭제 설정', NULL, NULL, '1', '모바일, 메신저를 포함한 대화 데이터를 일정 기간 동안 보관 후 자동 삭제되도록 설정할 수 있습니다.\r\n\r\n대화 관련하여 영구보관 또는 첨부파일을\r\n일정 기간 동안 보관 후 자동 삭제되도록 설정할 수 있습니다.\r\n\r\n(※첨부파일 삭제 제외되는 경우 : 관심쪽지, 예약미전송쪽지, 즐겨찾기대화방, 프로젝트대화방※)', '0', 'option0100', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT ignore INTO `tcmg_optionset` (`option_id`, `option_gb`, `module_gb`, `option_group`, `option_nm`, `p_option_id`, `p_option_must_value`, `option_level`, `option_desc`, `option_d_value`, `option_value_id`, `demo_link`, `search_keyword`, `option_desc2`, `option_nm_en`, `option_nm_jp`, `option_nm_cn`, `option_desc_en`, `option_desc_jp`, `option_desc_cn`, `use_yn`, `display_yn`, `created_by`, `created_dt`, `modify_by`, `modify_dt`, `sort_order`) VALUES ('com201', '1', 'cm', 'text', '보관기간 설정', 'com200', NULL, '2', '보관기간은 일 단위로 설정 가능하며,\r\n설정한 보관 기간이 지나면 데이터를 자동 삭제 처리합니다.\r\n또한 삭제된 데이터는 복원이 불가능합니다.\r\n\r\n보관기간은 [최소 30일 / 최대 1095일]까지 설정할 수 있습니다.', '30', 'option0054', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
*/
-- 소스시퀀스배포  : 3289
/*
update t_co_portlet_link set link_url='http://stax.duzon.com' where link_url='http://stax.duzon.com:8080/account';
*/

-- 소스시퀀스배포  : 3306

/*

INSERT IGNORE INTO `t_co_code_detail` (`detail_code`, `code`, `ischild`, `order_num`, `flag_1`, `flag_2`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`)
VALUES ('G20', 'COM519', 'N', 1002, NULL, NULL, 'Y', NULL, NULL, NULL, NULL);

INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`)
VALUES ('G20', 'COM519', 'kr', 'G20', '', 'Y', NULL, NULL, NULL, NULL);
*/
-- 소스시퀀스배포 : 3421
/*
insert ignore into t_co_code_detail
(detail_code, code, ischild, order_num, flag_1, flag_2, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('cloud', 'cm3000', 'N', NULL, NULL, NULL, 'Y', NULL, NULL, NULL, NULL);
insert ignore into t_co_code_detail_multi
(detail_code, code, lang_code, detail_name, note, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('cloud', 'cm3000', 'kr', 'B타입', '', 'Y', 'SYSTEM', NULL, 'SYSTEM', NULL);

update t_co_portal set portal_div='cloud'
where comp_seq='0'
and (select count(*) from t_co_emp_menu_history where menu_no=1912000001) < 1
and (select count(*) from t_co_portlet_set) = 11;
*/
-- 소스시퀀스배포 : 3475


/*
수정사항
[시스템설정]
 - 사원정보 삭제시 메일 조직도 동기화되지 않는 오류 수정.
 - 메신저 문자보내기 링크 오류 수정.


-- 이차인증 고도화 관련 쿼리(고객사 미오픈/메뉴미노출)
 ALTER TABLE `t_co_second_cert_option`
	DROP COLUMN IF EXISTS `change_yn`,
	DROP COLUMN IF EXISTS `re_reg_yn`;


ALTER TABLE `t_co_second_cert_device`
	ADD COLUMN IF NOT EXISTS `type` CHAR(1) NULL DEFAULT NULL COMMENT '기기타입("1":인증기기 "2":사용기기)' AFTER `comp_seq`;


update t_co_second_cert_option set use_yn = 'N', device_cnt = '4', `range` = 'A', target = 'E', approval_yn = 'Y', pin_yn = 'N';

-- DRM옵션관련 컬럼추가
ALTER TABLE `t_co_group` ADD COLUMN IF NOT EXISTS `drm_use_yn` char(1) NULL COMMENT 'DRM사용여부';
ALTER TABLE `t_co_group` ADD COLUMN IF NOT EXISTS `drm_type` varchar(32) NULL COMMENT 'DRM제품타입';
ALTER TABLE `t_co_group` ADD COLUMN IF NOT EXISTS `drm_option_val1` varchar(512) NULL COMMENT 'DRM옵션1';
ALTER TABLE `t_co_group` ADD COLUMN IF NOT EXISTS `drm_option_val2` varchar(512) NULL COMMENT 'DRM옵션2';
ALTER TABLE `t_co_group_path` ADD COLUMN IF NOT EXISTS `drm_use_yn` char(1) NULL COMMENT 'DRM사용여부';
ALTER TABLE `t_co_group_path` ADD COLUMN IF NOT EXISTS `drm_upload` char(1) NULL COMMENT 'DRM업로드옵션';
ALTER TABLE `t_co_group_path` ADD COLUMN IF NOT EXISTS `drm_download` char(1) NULL COMMENT 'DRM다운로드옵션';
ALTER TABLE `t_co_group_path` ADD COLUMN IF NOT EXISTS `file_extsn` varchar(512) NULL COMMENT 'DRM확장자범위';

ALTER TABLE `t_co_group_path` DROP COLUMN IF EXISTS `file_extsn`;
ALTER TABLE `t_co_group_path` ADD COLUMN IF NOT EXISTS `drm_file_extsn` varchar(512) NULL COMMENT 'DRM확장자범위';

*/


/*

수정사항
[확장기능]
 - 웹팩스 별칭 기능 추가.

[시스템설정]
 - 그룹웨어 용량 현황 기능 배포.

[공통옵션]
 - 첨부파일보기설정(쪽지,대화방 - 메신저용) 추가.

 --웹팩스 별칭기능관련 스크립트
CREATE TABLE IF NOT EXISTS `t_fx_fax_nickname_option` (
	`group_seq` VARCHAR(50) NULL DEFAULT NULL,
	`option` CHAR(1) NULL DEFAULT NULL COMMENT '"1":팩스번호, "2":팩스번호(별칭), "3":별칭(백스번호), "4":별칭'
)
COMMENT='팩스번호 별칠표시 설정테이블'
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

ALTER TABLE `t_fx_fax_no`
	ADD COLUMN IF NOT EXISTS `nick_name` VARCHAR(50) NULL DEFAULT NULL COMMENT '별칭' AFTER `use_end_date`;

INSERT IGNORE INTO `t_co_menu_adm` (`menu_no`, `menu_gubun`, `upper_menu_no`, `menu_ordr`, `use_yn`, `url_gubun`, `url_path`, `sso_use_yn`, `menu_depth`, `menu_img_class`, `create_seq`, `create_date`, `modify_seq`, `modify_date`, `menu_adm_gubun`, `menu_auth_type`, `public_yn`, `delete_yn`) VALUES (1901080000, '', 1901000000, 1901080000, 'Y', 'gw', '/cmm/systemx/groupVolumeManageView.do', 'Y', 3, NULL, NULL, NULL, NULL, NULL, NULL, 'MASTER', 'Y', NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1901080000, 'kr', '그룹웨어 용량 현황', '그룹웨어 용량 현황', NULL, NULL, NULL, NULL);

update tcmg_optionset set use_yn = 'Y' where option_id in('pathSeq800','pathSeq810')
*/
-- 소스시퀀스배포 : 3588

/*
insert ignore into t_co_code_detail
(detail_code, code, ischild, order_num, flag_1, flag_2, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('cloud', 'cm3000', 'N', NULL, NULL, NULL, 'Y', NULL, NULL, NULL, NULL);
insert ignore into t_co_code_detail_multi
(detail_code, code, lang_code, detail_name, note, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('cloud', 'cm3000', 'kr', 'B타입', '', 'Y', 'SYSTEM', NULL, 'SYSTEM', NULL);

update t_co_portal set portal_div='cloud'
where comp_seq='0'
and (select count(*) from t_co_emp_menu_history where menu_no=1912000001) < 1
and (select count(*) from t_co_portlet_set) = 11;

ALTER TABLE t_co_emp_multi CHANGE main_work main_work VARCHAR(256);

insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('cm1750', '1', 'cm', 'single', '공통 댓글 설정', NULL, NULL, '1', '댓글에 대하여 메뉴별로 타입을 설정할 수 있습니다.', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('cm1750_ea', '1', 'cm', 'single', '전자결재', 'cm1750', NULL, '2', '전자결재 메뉴의 댓글을 기본형, 기본형(프로필), 대화형 타입으로 설정할 수 있습니다.', 'type1', 'option0150', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0);

insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('cm1751_ea', '1', 'cm', 'single', '이미지 미리보기 사용여부', 'cm1750_ea', NULL, '3', '댓글의 이미지 파일 첨부 시, 미리보기 사용여부를 설정할 수 있습니다.', 'N', 'COM521', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0);

insert ignore into t_co_code
(code, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('option0150', 'Y', NULL, NULL, NULL, NULL);

insert ignore into t_co_code_multi
(code, lang_code, name, note, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('option0150', 'kr', '댓글 타입 설정', NULL, 'Y', NULL, NULL, NULL, NULL);

insert ignore into t_co_code_detail
(detail_code, code, ischild, order_num, flag_1, flag_2, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('type1', 'option0150', 'N', 0, NULL, NULL, 'Y', NULL, NULL, NULL, NULL),
('type2', 'option0150', 'N', 1, NULL, NULL, 'Y', NULL, NULL, NULL, NULL),
('type3', 'option0150', 'N', 2, NULL, NULL, 'Y', NULL, NULL, NULL, NULL);

insert ignore into t_co_code_detail_multi
(detail_code, code, lang_code, detail_name, note, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('type1', 'option0150', 'kr', '기본형 타입', NULL, 'Y', NULL, NULL, NULL, NULL),
('type2', 'option0150', 'kr', '기본형(프로필) 타입', NULL, 'Y', NULL, NULL, NULL, NULL),
('type3', 'option0150', 'kr', '대화형 타입', NULL, 'Y', NULL, NULL, NULL, NULL);

CREATE TABLE IF NOT EXISTS `t_co_patch_token` (
  `token` varchar(32) NOT NULL,
  `group_seq` varchar(32) NOT NULL,
  `emp_seq` varchar(32) NOT NULL,
  `emp_name` varchar(128) NOT NULL,
  `login_id` varchar(32) NOT NULL,
  `login_ip` varchar(32) NOT NULL,
  `create_date` datetime NOT NULL,
  `req_result` char(1) NOT NULL,
  PRIMARY KEY (`token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='마스터권한 업데이트 토큰테이블';

*/
-- 소스시퀀스배포 : 3644


/*
ALTER TABLE `t_co_second_cert_option`
	ADD COLUMN IF NOT EXISTS `app_confirm_yn` CHAR(1) NULL DEFAULT 'Y' COMMENT 'App 최초 로그인 인증처리 사용여부';

*/

/*
CREATE TABLE IF NOT EXISTS `oneffice_report_relate` (
	`org_seq` VARCHAR(50) NULL DEFAULT NULL
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;
*/
-- 소스시퀀스배포 : 4056




/*
update t_co_emp set use_yn = 'N' where license_check_yn = '3' and use_yn = 'Y';
update t_co_emp_dept set use_yn = 'N' where emp_seq in (select emp_seq from t_co_emp where  license_check_yn = '3');
update t_co_emp_dept_multi set use_yn = 'N' where emp_seq in (select emp_seq from t_co_emp where  license_check_yn = '3');
update t_co_emp_comp set use_yn = 'N' where emp_seq in (select emp_seq from t_co_emp where  license_check_yn = '3');

update t_co_emp set passwd_date=null where DATE_FORMAT(passwd_date, '%Y') = '0000';
update t_co_emp set join_day=null where DATE_FORMAT(join_day, '%Y') = '0000';
update t_co_emp set resign_day=null where DATE_FORMAT(resign_day, '%Y') = '0000';
update t_co_emp set bday=null where DATE_FORMAT(bday, '%Y') = '0000';
update t_co_emp set wedding_day=null where DATE_FORMAT(wedding_day, '%Y') = '0000';
update t_co_emp_comp set resign_day=null where DATE_FORMAT(resign_day, '%Y') = '0000';

ALTER TABLE t_co_emp ADD COLUMN IF NOT EXISTS last_resign_day date NULL COMMENT '최근퇴사일자';
ALTER TABLE t_co_emp ADD COLUMN IF NOT EXISTS last_emp_name varchar(512) NULL COMMENT '최근퇴사사원명';
ALTER TABLE t_co_emp ADD COLUMN IF NOT EXISTS last_dept_seq varchar(32) NULL COMMENT '최근부서시퀀스';
ALTER TABLE t_co_emp ADD COLUMN IF NOT EXISTS last_dept_name varchar(512) NULL COMMENT '최근퇴사부서명';
ALTER TABLE t_co_emp ADD COLUMN IF NOT EXISTS last_dept_path varchar(2048) NULL COMMENT '최근퇴사부서경로';
ALTER TABLE t_co_emp_history ADD COLUMN IF NOT EXISTS last_resign_day date NULL COMMENT '최근퇴사일자';
ALTER TABLE t_co_emp_history ADD COLUMN IF NOT EXISTS last_emp_name varchar(512) NULL COMMENT '최근퇴사사원명';
ALTER TABLE t_co_emp_history ADD COLUMN IF NOT EXISTS last_dept_seq varchar(32) NULL COMMENT '최근부서시퀀스';
ALTER TABLE t_co_emp_history ADD COLUMN IF NOT EXISTS last_dept_name varchar(512) NULL COMMENT '최근퇴사부서명';
ALTER TABLE t_co_emp_history ADD COLUMN IF NOT EXISTS last_dept_path varchar(2048) NULL COMMENT '최근퇴사부서경로';

DELIMITER $$
DROP TRIGGER /*!50032 IF EXISTS */ `TRG_T_CO_EMP_AD`$$

CREATE
    TRIGGER `TRG_T_CO_EMP_AD` AFTER DELETE ON `t_co_emp`
    FOR EACH ROW BEGIN
    /*************************************************************************
    # 설    명 : 사용자 정보 삭제시
    #*************************************************************************
    # 수정일자    | 수 정 자 | 수정내역
    #-------------------------------------------------------------------------
    # 2015/06/17 | 나 석 진 | 신규 작성
    # 2017/10/11 | 한 용 일 | 조직도 테이블 현행화
    # 9999/99/99 | 홍 길 동 |
    *************************************************************************/
    INSERT INTO t_co_emp_history (
		op_code,
		reg_date,
		emp_seq,
		login_id,
		emp_num,
		erp_emp_num,
		email_addr,
		login_passwd,
		appr_passwd,
		passwd_date,
		passwd_input_fail_count,
		pay_passwd,
		passwd_status_code,
		mobile_use_yn,
		messenger_use_yn,
		job_code,
		status_code,
		duty_code,
		position_code,
		native_lang_code,
		license_check_yn,
		join_day,
		resign_day,
		gender_code,
		bday,
		lunar_yn,
		work_status,
		home_tel_num,
		mobile_tel_num,
		wedding_yn,
		wedding_day,
		zip_code,
		pic_file_id,
		sign_file_id,
		use_yn,
		ls_role_id,
		create_seq,
		create_date,
		modify_seq,
		modify_date,
		private_yn,
		out_mail,
		out_domain,
		main_comp_login_yn,
		spring_secu,
		spring_date,
		sign_type,
    last_resign_day,
    last_emp_name,
    last_dept_seq,
    last_dept_name,
    last_dept_path
    )
    VALUES (
        'D',
        NOW(),
		OLD.emp_seq,
		OLD.login_id,
		OLD.emp_num,
		OLD.erp_emp_num,
		OLD.email_addr,
		OLD.login_passwd,
		OLD.appr_passwd,
		OLD.passwd_date,
		OLD.passwd_input_fail_count,
		OLD.pay_passwd,
		OLD.passwd_status_code,
		OLD.mobile_use_yn,
		OLD.messenger_use_yn,
		OLD.job_code,
		OLD.status_code,
		OLD.duty_code,
		OLD.position_code,
		OLD.native_lang_code,
		OLD.license_check_yn,
		OLD.join_day,
		OLD.resign_day,
		OLD.gender_code,
		OLD.bday,
		OLD.lunar_yn,
		OLD.work_status,
		OLD.home_tel_num,
		OLD.mobile_tel_num,
		OLD.wedding_yn,
		OLD.wedding_day,
		OLD.zip_code,
		OLD.pic_file_id,
		OLD.sign_file_id,
		OLD.use_yn,
		OLD.ls_role_id,
		OLD.create_seq,
		OLD.create_date,
		OLD.modify_seq,
		OLD.modify_date,
		OLD.private_yn,
		OLD.out_mail,
		OLD.out_domain,
		OLD.main_comp_login_yn,
		OLD.spring_secu,
		OLD.spring_date,
		OLD.sign_type,
    OLD.last_resign_day,
    OLD.last_emp_name,
    OLD.last_dept_seq,
    OLD.last_dept_name,
    OLD.last_dept_path
    );

    UPDATE
        t_co_orgchart
    SET
        task_status = CASE
                        WHEN    task_status = '0' THEN '1'  -- 0:대기(완료) 인 경우 1: 요청
                        WHEN    task_status = '2' THEN '3'  -- 2:진행 인 경우 3: 진행중 요청
                        ELSE    task_status END             -- 그외 경우 상태 그대로 유지
        , update_status = CASE
			WHEN   update_status < '1' THEN '1' -- 1:사원정보 변경, 99. 전체변경
			ELSE   update_status END
    WHERE
        group_seq = OLD.group_seq;
END;
$$
DELIMITER ;

DELIMITER $$
DROP TRIGGER /*!50032 IF EXISTS */ `TRG_T_CO_EMP_AI`$$

CREATE
    TRIGGER `TRG_T_CO_EMP_AI` AFTER INSERT ON `t_co_emp`
    FOR EACH ROW BEGIN
    /*************************************************************************
    # 설    명 : 사용자 정보 추가시
    #*************************************************************************
    # 수정일자    | 수 정 자 | 수정내역
    #-------------------------------------------------------------------------
    # 2015/06/17 | 나 석 진 | 신규 작성
    # 2017/10/11 | 한 용 일 | 조직도 테이블 현행화
    # 9999/99/99 | 홍 길 동 |
    *************************************************************************/
    INSERT INTO t_co_emp_history (
		op_code,
		reg_date,
		emp_seq,
		login_id,
		emp_num,
		erp_emp_num,
		email_addr,
		login_passwd,
		appr_passwd,
		passwd_date,
		passwd_input_fail_count,
		pay_passwd,
		passwd_status_code,
		mobile_use_yn,
		messenger_use_yn,
		job_code,
		status_code,
		duty_code,
		position_code,
		native_lang_code,
		license_check_yn,
		join_day,
		resign_day,
		gender_code,
		bday,
		lunar_yn,
		work_status,
		home_tel_num,
		mobile_tel_num,
		wedding_yn,
		wedding_day,
		zip_code,
		pic_file_id,
		sign_file_id,
		use_yn,
		ls_role_id,
		create_seq,
		create_date,
		modify_seq,
		modify_date,
		private_yn,
		out_mail,
		out_domain,
		main_comp_login_yn,
		spring_secu,
		spring_date,
		sign_type,
    last_resign_day,
    last_emp_name,
    last_dept_seq,
    last_dept_name,
    last_dept_path
    )
    VALUES (
        'I',
        NOW(),
		NEW.emp_seq,
		NEW.login_id,
		NEW.emp_num,
		NEW.erp_emp_num,
		NEW.email_addr,
		NEW.login_passwd,
		NEW.appr_passwd,
		NEW.passwd_date,
		NEW.passwd_input_fail_count,
		NEW.pay_passwd,
		NEW.passwd_status_code,
		NEW.mobile_use_yn,
		NEW.messenger_use_yn,
		NEW.job_code,
		NEW.status_code,
		NEW.duty_code,
		NEW.position_code,
		NEW.native_lang_code,
		NEW.license_check_yn,
		NEW.join_day,
		NEW.resign_day,
		NEW.gender_code,
		NEW.bday,
		NEW.lunar_yn,
		NEW.work_status,
		NEW.home_tel_num,
		NEW.mobile_tel_num,
		NEW.wedding_yn,
		NEW.wedding_day,
		NEW.zip_code,
		NEW.pic_file_id,
		NEW.sign_file_id,
		NEW.use_yn,
		NEW.ls_role_id,
		NEW.create_seq,
		NEW.create_date,
		NEW.modify_seq,
		NEW.modify_date,
		NEW.private_yn,
		NEW.out_mail,
		NEW.out_domain,
		NEW.main_comp_login_yn,
		NEW.spring_secu,
		NEW.spring_date,
		NEW.sign_type,
    NEW.last_resign_day,
    NEW.last_emp_name,
    NEW.last_dept_seq,
    NEW.last_dept_name,
    NEW.last_dept_path
    );

    UPDATE
        t_co_orgchart
    SET
        task_status = CASE
                        WHEN    task_status = '0' THEN '1'  -- 0:대기(완료) 인 경우 1: 요청
                        WHEN    task_status = '2' THEN '3'  -- 2:진행 인 경우 3: 진행중 요청
                        ELSE    task_status END             -- 그외 경우 상태 그대로 유지
        , update_status = CASE
			WHEN   update_status < '1' THEN '1' -- 1:사원정보 변경, 99. 전체변경
			ELSE   update_status END
    WHERE
        group_seq = NEW.group_seq;
END;
$$
DELIMITER ;

DELIMITER $$
DROP TRIGGER /*!50032 IF EXISTS */ `TRG_T_CO_EMP_AU`$$

CREATE
    TRIGGER `TRG_T_CO_EMP_AU` AFTER UPDATE ON `t_co_emp`
    FOR EACH ROW BEGIN
    /*************************************************************************
    # 설    명 : 사용자 정보 변경시
    #*************************************************************************
    # 수정일자    | 수 정 자 | 수정내역
    #-------------------------------------------------------------------------
    # 2015/06/17 | 나 석 진 | 신규 작성
    # 2017/10/11 | 한 용 일 | 조직도 테이블 현행화
    # 9999/99/99 | 홍 길 동 |
    *************************************************************************/
    IF old.group_seq != new.group_seq OR
      	old.login_id != new.login_id OR
      	old.emp_num != new.emp_num OR
      	old.erp_emp_num != new.erp_emp_num OR
      	old.email_addr != new.email_addr OR
      	old.out_mail != new.out_mail OR
      	old.out_domain != new.out_domain OR
      	old.login_passwd != new.login_passwd OR
      	old.appr_passwd != new.appr_passwd OR
      	old.pay_passwd != new.pay_passwd OR
      	old.mobile_use_yn != new.mobile_use_yn OR
      	old.messenger_use_yn != new.messenger_use_yn OR
      	old.check_work_yn != new.check_work_yn OR
      	old.shift != new.shift OR
      	old.job_code != new.job_code OR
      	old.status_code != new.status_code OR
      	old.main_comp_seq != new.main_comp_seq OR
      	old.main_comp_login_yn != new.main_comp_login_yn OR
      	old.duty_code != new.duty_code OR
      	old.position_code != new.position_code OR
      	old.native_lang_code != new.native_lang_code OR
      	old.license_check_yn != new.license_check_yn OR
      	old.join_day != new.join_day OR
      	old.resign_day != new.resign_day OR
      	old.gender_code != new.gender_code OR
      	old.bday != new.bday OR
      	old.lunar_yn != new.lunar_yn OR
      	old.work_status != new.work_status OR
      	old.home_tel_num != new.home_tel_num OR
      	old.mobile_tel_num != new.mobile_tel_num OR
      	old.wedding_yn != new.wedding_yn OR
      	old.wedding_day != new.wedding_day OR
      	old.private_yn != new.private_yn OR
      	old.zip_code != new.zip_code OR
      	old.pic_file_id != new.pic_file_id OR
      	old.sign_file_id != new.sign_file_id OR
      	old.use_yn != new.use_yn OR
      	old.ls_role_id != new.ls_role_id OR
      	old.sign_type != new.sign_type OR
        old.last_resign_day != new.last_resign_day OR
        old.last_emp_name != new.last_emp_name OR
        old.last_dept_seq != new.last_dept_seq OR
        old.last_dept_name != new.last_dept_name OR
        old.last_dept_path != new.last_dept_path
      THEN

	    INSERT INTO t_co_emp_history (
			op_code,
			reg_date,
			emp_seq,
			login_id,
			emp_num,
			erp_emp_num,
			email_addr,
			login_passwd,
			appr_passwd,
			passwd_date,
			passwd_input_fail_count,
			pay_passwd,
			passwd_status_code,
			mobile_use_yn,
			messenger_use_yn,
			job_code,
			status_code,
			duty_code,
			position_code,
			native_lang_code,
			license_check_yn,
			join_day,
			resign_day,
			gender_code,
			bday,
			lunar_yn,
			work_status,
			home_tel_num,
			mobile_tel_num,
			wedding_yn,
			wedding_day,
			zip_code,
			pic_file_id,
			sign_file_id,
			use_yn,
			ls_role_id,
			create_seq,
			create_date,
			modify_seq,
			modify_date,
			private_yn,
			out_mail,
			out_domain,
			main_comp_login_yn,
			spring_secu,
			spring_date,
		  sign_type,
      last_resign_day,
      last_emp_name,
      last_dept_seq,
      last_dept_name,
      last_dept_path
	    )
	    VALUES (
	        'U',
	        NOW(),
			NEW.emp_seq,
			NEW.login_id,
			NEW.emp_num,
			NEW.erp_emp_num,
			NEW.email_addr,
			NEW.login_passwd,
			NEW.appr_passwd,
			NEW.passwd_date,
			NEW.passwd_input_fail_count,
			NEW.pay_passwd,
			NEW.passwd_status_code,
			NEW.mobile_use_yn,
			NEW.messenger_use_yn,
			NEW.job_code,
			NEW.status_code,
			NEW.duty_code,
			NEW.position_code,
			NEW.native_lang_code,
			NEW.license_check_yn,
			NEW.join_day,
			NEW.resign_day,
			NEW.gender_code,
			NEW.bday,
			NEW.lunar_yn,
			NEW.work_status,
			NEW.home_tel_num,
			NEW.mobile_tel_num,
			NEW.wedding_yn,
			NEW.wedding_day,
			NEW.zip_code,
			NEW.pic_file_id,
			NEW.sign_file_id,
			NEW.use_yn,
			NEW.ls_role_id,
			NEW.create_seq,
			NEW.create_date,
			NEW.modify_seq,
			NEW.modify_date,
			NEW.private_yn,
			NEW.out_mail,
			NEW.out_domain,
			NEW.main_comp_login_yn,
			NEW.spring_secu,
			NEW.spring_date,
		  NEW.sign_type,
      NEW.last_resign_day,
      NEW.last_emp_name,
      NEW.last_dept_seq,
      NEW.last_dept_name,
      NEW.last_dept_path
	    );

	    UPDATE
	        t_co_orgchart
	    SET
	        task_status = CASE
	                        WHEN    task_status = '0' THEN '1'  -- 0:대기(완료) 인 경우 1: 요청
	                        WHEN    task_status = '2' THEN '3'  -- 2:진행 인 경우 3: 진행중 요청
	                        ELSE    task_status END             -- 그외 경우 상태 그대로 유지
	        , update_status = CASE
				WHEN   update_status < '1' THEN '1' -- 1:사원정보 변경, 99. 전체변경
				ELSE   update_status END
	    WHERE
	        group_seq = NEW.group_seq;
    END IF;
END;
$$
DELIMITER ;

update t_co_emp set work_status = '001', use_yn = 'N' where work_status != '001' and emp_seq not in (select distinct emp_seq from t_co_emp_comp where work_status != '001');

-- last_dept_seq / last_resign_day 보정 (t_co_emp_comp 데이터 조회)
update t_co_emp e
set e.last_dept_seq = ifnull(
(select ec.dept_seq from t_co_emp_comp ec where ec.emp_seq = e.emp_seq order by ec.resign_day desc, ec.modify_date desc limit 1)
,
(select ec.dept_seq from t_co_emp_comp_history ec where ec.emp_seq = e.emp_seq order by ec.resign_day desc, ec.reg_date desc, ec.modify_date desc limit 1)
),
e.last_resign_day = ifnull(
(select ifnull(ec.resign_day, ec.modify_date) from t_co_emp_comp ec where ec.emp_seq = e.emp_seq order by ec.resign_day desc, ec.modify_date desc limit 1)
,
ifnull((select ifnull(ec.resign_day, ec.modify_date) from t_co_emp_comp_history ec where ec.emp_seq = e.emp_seq order by ec.resign_day desc, ec.reg_date desc, ec.modify_date desc limit 1), e.last_resign_day)
)
where e.work_status = '001' and ifnull(e.last_dept_seq,'') = '';

-- last_resign_day 보정 (t_co_emp_dept 데이터조회)
update t_co_emp e
set e.last_resign_day = ifnull((select ec.modify_date from t_co_emp_dept ec where ec.emp_seq = e.emp_seq order by ec.modify_date desc limit 1), (select ifnull(ec.modify_date, ec.reg_date) from t_co_emp_dept_history ec where ec.emp_seq = e.emp_seq order by ec.reg_date desc, ec.modify_date desc limit 1))
where e.work_status = '001' and (e.last_resign_day is null or DATE_FORMAT(e.last_resign_day, '%Y') = '0000');

-- last_resign_day 보정 (t_co_emp 데이터조회)
update t_co_emp e
set e.last_resign_day = ifnull(e.modify_date, (select ec.reg_date from t_co_emp_history ec where ec.emp_seq = e.emp_seq order by ec.reg_date desc, ec.modify_date desc limit 1))
where e.work_status = '001' and (e.last_resign_day is null or DATE_FORMAT(e.last_resign_day, '%Y') = '0000');

-- last_dept_seq 보정 (t_co_emp_dept 데이터조회)
update t_co_emp e
set e.last_dept_seq = ifnull(
(select ec.dept_seq from t_co_emp_dept ec where ec.emp_seq = e.emp_seq order by ec.modify_date desc limit 1)
,
(select ec.dept_seq from t_co_emp_dept_history ec where ec.emp_seq = e.emp_seq order by ec.reg_date desc, ec.modify_date desc limit 1)
)
where e.work_status = '001' and ifnull(e.last_dept_seq,'') = '';

-- last_emp_name 보정
update t_co_emp e
left join v_t_co_emp_multi em on e.emp_seq = em.emp_seq
set e.last_emp_name = ifnull(em.emp_name_multi,(select concat(his.emp_name,'▦▦▦') from t_co_emp_multi_history his where his.emp_seq = e.emp_seq and his.lang_code = 'kr' order by his.reg_date desc limit 1))
where e.work_status = '001' and ifnull(e.last_emp_name,'') = '';

-- last_dept_name, last_dept_path 보정
update t_co_emp e
left join v_t_co_dept_multi dm on e.last_dept_seq = dm.dept_seq
set e.last_dept_name = ifnull(dm.dept_name_multi,(select concat(his.dept_name,'▦▦▦') from t_co_dept_multi_history his where his.dept_seq = e.last_dept_seq and his.lang_code = 'kr' order by his.reg_date desc limit 1)),
e.last_dept_path = ifnull(concat(dm.path_name,'▦▦▦'),(select concat(his.path_name,'▦▦▦') from t_co_dept_multi_history his where his.dept_seq = e.last_dept_seq and his.lang_code = 'kr' order by his.reg_date desc limit 1))
where e.work_status = '001' and ifnull(e.last_dept_name,'') = '';

*/
-- 소스시퀀스 4350


/*

수정사항
[포털]
 - B타입 포털 자동출근체크 안되는 문제 수정

[공통]
 - 메신져 로그인 시 로그인 내역IP 단말기 기준으로 등록되도록 개선
 - 신규회사 추가시 전자결재 기본옵션 추가되지 않는 오류 수정(클라우스 서버 한정)
 - 프로젝트게시판 관련 메신저 알림링크 오동작 오류 수정

[시스템설정]
 - 퇴사처리된 겸직회사 삭제 시 전체 겸직회사 매핑정보 삭제 오류 수정

[원피스]
 - 원피스 업무보고 모아보기 시 읽음처리 되지않는 오류 수정.
 */

/*
update t_co_alert_menu set lnb_menu_no = '401010000' where event_sub_type in('BO002','BO004', 'BO007', 'BO009');
update t_co_emp set spring_secu = 'main_comp_yn_set' where emp_seq in (select emp_seq from t_co_emp_dept where emp_seq not in (select emp_seq from t_co_emp_dept where main_comp_yn = 'Y'));
update t_co_emp_dept ed join t_co_emp e on ed.emp_seq = e.emp_seq and ed.comp_seq = e.main_comp_seq set ed.main_comp_yn = 'Y' where spring_secu = 'main_comp_yn_set';
update t_co_emp set spring_secu = '' where spring_secu = 'main_comp_yn_set';

ALTER TABLE `t_co_emp_login_history`
	ALTER `access_ip` DROP DEFAULT;
ALTER TABLE `t_co_emp_login_history`
	CHANGE COLUMN IF EXISTS  `access_ip` `access_ip` VARCHAR(32) NULL COMMENT '접속IP' AFTER `login_date`;

alter table t_at_annv_mst_abjust_history engine=InnoDB;
alter table t_at_config_detail engine=InnoDB;
alter table t_at_config_in_detail engine=InnoDB;
alter table t_at_err_doc_log engine=InnoDB;
alter table t_co_access engine=InnoDB;
alter table t_co_access_relate engine=InnoDB;
alter table t_co_certificate_alarm engine=InnoDB;
alter table t_co_dutyposition_batch engine=InnoDB;
alter table t_co_emp_move_history engine=InnoDB;
alter table t_co_group_api engine=InnoDB;
alter table t_co_group_api_history engine=InnoDB;
alter table t_co_group_volume_history engine=InnoDB;
alter table t_co_seq_imsi engine=InnoDB;
alter table t_ex_entertainment engine=InnoDB;
alter table t_ex_etax_transfer engine=InnoDB;
alter table t_ex_ezbaro_code_param engine=InnoDB;
alter table t_ex_ezbaro_erp_master engine=InnoDB;
alter table t_ex_ezbaro_erp_slave engine=InnoDB;
alter table t_ex_ezbaro_gw_master engine=InnoDB;
alter table t_ex_ezbaro_gw_slave engine=InnoDB;
alter table t_ex_transfer_log engine=InnoDB;
alter table t_secom_alarm engine=InnoDB;
alter table tcmg_optionvalue_history engine=InnoDB;
alter table teag_appdoc_accmoney engine=InnoDB;
alter table teag_form_money engine=InnoDB;
*/

-- 소스시퀀스 4542




/*
 수정사항
 [통합검색]
  -통합검색(업무관리) 상세보기 미노출 오류 수
 */

/*
update t_co_emp set use_yn = 'D' where login_id like '%▦%' and use_yn != 'D';
*/

-- 소스시퀀스 4653


/*
 수정사항
 [시스템설정]
  - 포틀릿 모듈 등록시 기본 다국어 정보 삽입되도록 개선
 */
/*
-- 포틀릿 클라우드 모듈별 다국어 업데이트 스크립트
UPDATE t_co_portlet_cloud_set SET portlet_info = REPLACE(portlet_info, '"port_name_kr":"설문조사","port_name_cn":"","port_name_jp":"","port_name_en":""', '"port_name_kr":"설문조사","port_name_cn":"问卷调查","port_name_jp":"アンケート","port_name_en":"Survey"');
UPDATE t_co_portlet_cloud_set SET portlet_info = REPLACE(portlet_info, '"port_name_kr":"메일현황","port_name_cn":"","port_name_jp":"","port_name_en":""', '"port_name_kr":"메일현황","port_name_cn":"邮件状态","port_name_jp":"メールステータス","port_name_en":"Mail Status"');
UPDATE t_co_portlet_cloud_set SET portlet_info = REPLACE(portlet_info, '"port_name_kr":"노트","port_name_cn":"","port_name_jp":"","port_name_en":""', '"port_name_kr":"노트","port_name_cn":"纪录","port_name_jp":"メモ","port_name_en":"Note"');
UPDATE t_co_portlet_cloud_set SET portlet_info = REPLACE(portlet_info, '"port_name_kr":"결재현황","port_name_cn":"","port_name_jp":"","port_name_en":""', '"port_name_kr":"결재현황","port_name_cn":"电子审批情况","port_name_jp":"電子決裁現況","port_name_en":"Current status of e-approval"');
UPDATE t_co_portlet_cloud_set SET portlet_info = REPLACE(portlet_info, '"port_name_kr":"결재양식","port_name_cn":"","port_name_jp":"","port_name_en":""', '"port_name_kr":"결재양식","port_name_cn":"审批格式","port_name_jp":"決裁フォーム","port_name_en":"Approval Form"');
UPDATE t_co_portlet_cloud_set SET portlet_info = REPLACE(portlet_info, '"port_name_kr":"전자결재","port_name_cn":"","port_name_jp":"","port_name_en":""', '"port_name_kr":"전자결재","port_name_cn":"电子审批","port_name_jp":"電子決裁","port_name_en":"E-Approval"');
UPDATE t_co_portlet_cloud_set SET portlet_info = REPLACE(portlet_info, '"port_name_kr":"게시판","port_name_cn":"","port_name_jp":"","port_name_en":""', '"port_name_kr":"게시판","port_name_cn":"留言板","port_name_jp":"掲示板","port_name_en":"Board"');
UPDATE t_co_portlet_cloud_set SET portlet_info = REPLACE(portlet_info, '"port_name_kr":"받은편지함","port_name_cn":"","port_name_jp":"","port_name_en":""', '"port_name_kr":"받은편지함","port_name_cn":"受信箱","port_name_jp":"收件箱","port_name_en":"Mail"');
UPDATE t_co_portlet_cloud_set SET portlet_info = REPLACE(portlet_info, '"port_name_kr":"일정캘린더","port_name_cn":"","port_name_jp":"","port_name_en":""', '"port_name_kr":"일정캘린더","port_name_cn":"安排日历","port_name_jp":"スケジュールカレンダー","port_name_en":"Schedule Calender"');

-- 포틀릿 구축형 모듈별 다국어 업데이트 스크립트
update t_co_portlet_set set portlet_nm_en="Schedule Calender", portlet_nm_cn="安排日历", portlet_nm_jp="スケジュールカレンダー" where portlet_tp="lr_so" and portlet_nm_kr is not NULL;
update t_co_portlet_set set portlet_nm_en="Survey", portlet_nm_cn="问卷调查", portlet_nm_jp="アンケート" where portlet_tp="lr_rs" and portlet_nm_kr is not NULL;
update t_co_portlet_set set portlet_nm_en="Mail Status", portlet_nm_cn="邮件状态", portlet_nm_jp="メールステータス" where portlet_tp="lr_em_count" and portlet_nm_kr is not NULL;
update t_co_portlet_set set portlet_nm_en="Note", portlet_nm_cn="纪录", portlet_nm_jp="メモ" where portlet_tp="lr_no" and portlet_nm_kr is not NULL;
update t_co_portlet_set set portlet_nm_en="Current status of e-approval(non)", portlet_nm_cn="电子审批情况(非营利)", portlet_nm_jp="電子決裁現況(非営利)" where portlet_tp="lr_ea_ea_count" and portlet_nm_kr is not NULL;
update t_co_portlet_set set portlet_nm_en="Current status of e-approval", portlet_nm_cn="电子审批情况", portlet_nm_jp="電子決裁現況" where portlet_tp="lr_ea_count" and portlet_nm_kr is not NULL;
update t_co_portlet_set set portlet_nm_en="Approval Form(non)", portlet_nm_cn="审批格式(非营利)", portlet_nm_jp="決裁フォーム(非営利)" where portlet_tp="lr_ea_form" and portlet_nm_kr is not NULL;
update t_co_portlet_set set portlet_nm_en="Approval Form", portlet_nm_cn="审批格式", portlet_nm_jp="決裁フォーム" where portlet_tp="lr_form" and portlet_nm_kr is not NULL;
update t_co_portlet_set set portlet_nm_en="[M] E-Approval(non)", portlet_nm_cn="[中] 电子审批(非营利)", portlet_nm_jp="[中] 電子決裁(非営利)" where portlet_tp="cn_ea_ea" and portlet_nm_kr is not NULL;
update t_co_portlet_set set portlet_nm_en="[M] E-Approval", portlet_nm_cn="[中] 电子审批", portlet_nm_jp="[中] 電子決裁" where portlet_tp="cn_ea" and portlet_nm_kr is not NULL;
update t_co_portlet_set set portlet_nm_en="[M] Mail", portlet_nm_cn="[中] 受信箱", portlet_nm_jp="[中] 收件箱" where portlet_tp="cn_em" and portlet_nm_kr is not NULL;
update t_co_portlet_set set portlet_nm_en="[M] Board", portlet_nm_cn="[中] 留言板", portlet_nm_jp="[中] 掲示板" where portlet_tp="cn_nb" and portlet_nm_kr is not NULL;
update t_co_portlet_set set portlet_nm_en="[S] E-Approval", portlet_nm_cn="[小] 电子审批", portlet_nm_jp="[小] 電子決裁" where portlet_tp="lr_ea" and portlet_nm_kr is not NULL;
update t_co_portlet_set set portlet_nm_en="[S] Mail", portlet_nm_cn="[小] 受信箱", portlet_nm_jp="[小] 收件箱" where portlet_tp="lr_em" and portlet_nm_kr is not NULL;
update t_co_portlet_set set portlet_nm_en="[S] Board", portlet_nm_cn="[小] 留言板", portlet_nm_jp="[小] 掲示板" where portlet_tp="lr_nb" and portlet_nm_kr is not NULL;
update t_co_portlet_set set portlet_nm_en="[L] E-Approval", portlet_nm_cn="[大] 电子审批", portlet_nm_jp="[大] 電子決裁" where portlet_tp="top_ea" and portlet_nm_kr is not NULL;
update t_co_portlet_set set portlet_nm_en="[L] Mail", portlet_nm_cn="[大] 受信箱", portlet_nm_jp="[大] 收件箱" where portlet_tp="top_em" and portlet_nm_kr is not NULL;
update t_co_portlet_set set portlet_nm_en="[L] Board", portlet_nm_cn="[大] 留言板", portlet_nm_jp="[大] 掲示板" where portlet_tp="top_nb" and portlet_nm_kr is not NULL;
*/
-- 소스시퀀스 4764
/*
ALTER TABLE t_co_comment
CHANGE emp_name emp_name VARCHAR(512),
CHANGE comp_name comp_name VARCHAR(512),
CHANGE dept_name dept_name VARCHAR(512),
CHANGE duty_name duty_name VARCHAR(512),
CHANGE position_name position_name VARCHAR(512);

update t_co_comp set comp_email_yn = 'N' where ifnull(email_domain,'') = '';
*/

-- 소스시퀀스 4875
/*
delete from tcmg_optionvalue where co_id = '0' and option_id in (select option_id from tcmg_optionset where option_gb = '2');
delete from tcmg_optionvalue where co_id != '0' and option_id in (select option_id from tcmg_optionset where option_gb = '1');
*/
/*
 수정사항
 [시스템설정]
  - 사원정보관리 사원정보 수정 시 권한이 비정상적으로 저장되는 오류 수정
  - 접근 IP 설정메뉴 공통조직도 팝업에서 조직도 트리조회 오류 수정
  - 포틀릿 등록시 기본 다국어 정보가 추가되도록 개선
  - 비영리 퇴사처리 프로세스 추가
  - 사원정보관리 사원정보 수정 시(퇴사자) 실패 팝업 오류 수정

 [더존에디터 dzeditor_v1.1.4.1]
  - 본문이 있는 모든 양식 상단에 한줄 빈공간 생김
  - 증명서 양식 저장 후 모든 텍스트 폰트 사이즈 10포인트로 초기화 됨
  - 엣지, 사파리 등 브라우저에서 ctrl + z 전체 삭제 또는 아예 복원 안되는 현상
  - 에디터 붙여넣기 기능에 대한 오류 수정요청
  - 에디터 스크롤바 활성화시 표 툴바 위치 틀어짐
  - 게시판 에디터 글꼴크기 변경시 반영오류

 [포털]
  - 연말정산 포틀릿 오류수정 및 ICUBE 사용업체만 노출되도록 개선
  - 통합알림 내 더보기 내용 노출형식 수정

 [공통]
  - 세션아웃 후 재로그인 시 간헐적 로그인 불가현상 수정(크롬브라우져)


 */
 /*
ALTER TABLE t_co_portlet ADD COLUMN IF NOT EXISTS portlet_nm_en varchar(50);
ALTER TABLE t_co_portlet ADD COLUMN IF NOT EXISTS portlet_nm_cn varchar(50);
ALTER TABLE t_co_portlet ADD COLUMN IF NOT EXISTS portlet_nm_jp varchar(50);
UPDATE t_co_portlet SET portlet_nm_cn = '[小] 留言板', portlet_nm_en = '[S] Board', portlet_nm_jp = '[小] 掲示板' WHERE portlet_tp = 'lr_nb';
UPDATE t_co_portlet SET portlet_nm_cn = '安排日历', portlet_nm_en = 'Schedule Calender', portlet_nm_jp = 'スケジュールカレンダー' WHERE portlet_tp = 'lr_so';
UPDATE t_co_portlet SET portlet_nm_cn = '[中] 电子审批', portlet_nm_en = '[M] E-approval', portlet_nm_jp = '[中] 電子決裁' WHERE portlet_tp = 'cn_ea';
UPDATE t_co_portlet SET portlet_nm_cn = '[中] 收件箱', portlet_nm_en = '[M] Mail', portlet_nm_jp = '[中] 受信箱' WHERE portlet_tp = 'cn_em';
UPDATE t_co_portlet SET portlet_nm_cn = '[大] 电子审批', portlet_nm_en = '[L] E-approval', portlet_nm_jp = '[大] 電子決裁' WHERE portlet_tp = 'top_ea';
UPDATE t_co_portlet SET portlet_nm_cn = '[大] 收件箱', portlet_nm_en = '[L] Mail', portlet_nm_jp = '[大] 受信箱' WHERE portlet_tp = 'top_em';
UPDATE t_co_portlet SET portlet_nm_cn = '[中] 电子审批(非盈利)', portlet_nm_en = '[M] E-approval (non)', portlet_nm_jp = '[中] 電子決裁(非営利)' WHERE portlet_tp = 'cn_ea_ea';
UPDATE t_co_portlet SET portlet_nm_cn = '电子审批情况', portlet_nm_en = 'Current status of electronic approval', portlet_nm_jp = '電子決裁現況' WHERE portlet_tp = 'lr_ea_count';
UPDATE t_co_portlet SET portlet_nm_cn = '邮件状态', portlet_nm_en = 'Mail Status', portlet_nm_jp = 'メールステータス' WHERE portlet_tp = 'lr_em_count';
UPDATE t_co_portlet SET portlet_nm_cn = '[小] 收件箱', portlet_nm_en = '[S] Mail', portlet_nm_jp = '[小] 受信箱' WHERE portlet_tp = 'lr_em';
UPDATE t_co_portlet SET portlet_nm_cn = '审批格式', portlet_nm_en = 'Approval Form', portlet_nm_jp = '決裁フォーム' WHERE portlet_tp = 'lr_form';
UPDATE t_co_portlet SET portlet_nm_cn = '[中] 留言板', portlet_nm_en = '[M] Board', portlet_nm_jp = '[中] 掲示板' WHERE portlet_tp = 'cn_nb';
UPDATE t_co_portlet SET portlet_nm_cn = '[大] 留言板', portlet_nm_en = '[L] Board', portlet_nm_jp = '[L] 掲示板' WHERE portlet_tp = 'top_nb';
UPDATE t_co_portlet SET portlet_nm_cn = '审批格式 (非营利)', portlet_nm_en = 'Approval Form (non)', portlet_nm_jp = '決裁フォーム (非営利)' WHERE portlet_tp = 'lr_ea_form';
UPDATE t_co_portlet SET portlet_nm_cn = '电子审批情况(非营利)', portlet_nm_en = 'Current status of e-approval(non)', portlet_nm_jp = '電子決裁現況(非営利)' WHERE portlet_tp = 'lr_ea_ea_count';
UPDATE t_co_portlet SET portlet_nm_cn = '[小] 电子审批', portlet_nm_en = '[S] E-approval', portlet_nm_jp = '[小] 電子決裁' WHERE portlet_tp = 'lr_ea';

update t_msg_tcmg_link set msg_target='tax', target_url = 'http://stax.douzone.com', link_kind = 'E' where msg_target = 'tax';
update t_co_portlet_set set link_id = null where portlet_tp in ('lr_tax','cn_tax');
update t_co_portlet set width_set = 182, height_set = 102 where portlet_tp = 'lr_tax';
update t_co_portlet set width_set = 278, height_set = 133 where portlet_tp = 'cn_tax';

update titg_code set use_yn = (case when use_yn in ('1','Y') then '1' else '0' end);
update titg_code_grp set use_yn = (case when use_yn in ('1','Y') then '1' else '0' end);
update titg_item set use_yn = (case when use_yn in ('1','Y') then '1' else '0' end);
*/

-- 소스시퀀스 : 5061



/*
update t_alert_admin set alert_yn='N' where alert_type in ('AMEA105','AMTA001','AMTA101') and alert_yn = 'B';
update t_alert_setting set alert_yn='Y' where alert_type in ('AMEA105','AMTA001','AMTA101');

/*
 * 수정사항
 * [시스템설정] 다국어 적용에 따른 UI 변경
 * 사용자정의 코드관리 다국어 컬럼 추가
 * 외부시스템 코드관리 다국어 컬럼 추가
 * */

ALTER TABLE titg_code ADD COLUMN IF NOT EXISTS code_val_en VARCHAR(50) AFTER code_val_nm;
ALTER TABLE titg_code ADD COLUMN IF NOT EXISTS code_val_jp VARCHAR(50) AFTER code_val_en;
ALTER TABLE titg_code ADD COLUMN IF NOT EXISTS code_val_cn VARCHAR(50) AFTER code_val_jp;
ALTER TABLE titg_customset ADD COLUMN IF NOT EXISTS display_type_en VARCHAR(50) AFTER display_type;
ALTER TABLE titg_customset ADD COLUMN IF NOT EXISTS display_type_jp VARCHAR(50) AFTER display_type_en;
ALTER TABLE titg_customset ADD COLUMN IF NOT EXISTS display_type_cn VARCHAR(50) AFTER display_type_jp;
ALTER TABLE titg_customset ADD COLUMN IF NOT EXISTS return_code_en VARCHAR(50) AFTER return_code;
ALTER TABLE titg_customset ADD COLUMN IF NOT EXISTS return_code_jp VARCHAR(50) AFTER return_code_en;
ALTER TABLE titg_customset ADD COLUMN IF NOT EXISTS return_code_cn VARCHAR(50) AFTER return_code_jp;
ALTER TABLE titg_customset ADD COLUMN IF NOT EXISTS return_code_display_type_en VARCHAR(50) AFTER return_code_display_type;
ALTER TABLE titg_customset ADD COLUMN IF NOT EXISTS return_code_display_type_jp VARCHAR(50) AFTER return_code_display_type_en;
ALTER TABLE titg_customset ADD COLUMN IF NOT EXISTS return_code_display_type_cn VARCHAR(50) AFTER return_code_display_type_jp;


/*
 * 수정사항
 * [시스템설정] 포털내 결재양식 오류건
 * t_co_portlet_user_set 테이블에 comp_seq 컬럼 추가및 PK 지정
 * 회사겸직을 하고 있는 사원일 경우 포틀릿 설정값의 pk값은 사원 시퀀스로만 구분짓기 때문에
 * 겸직 회사별 설정 값을 저장해야함 그래서 comp_seq컬럼을 추가하고 pk 지정함
 * */

ALTER TABLE t_co_portlet_user_set ADD COLUMN IF NOT EXISTS comp_seq VARCHAR(50) AFTER custom_value0;

UPDATE t_co_portlet_user_set a INNER JOIN v_user_info b on a.emp_seq = b.emp_seq SET a.comp_seq = b.main_comp_seq;

DELETE FROM t_co_portlet_user_set WHERE comp_seq IS NULL;

ALTER TABLE t_co_portlet_user_set DROP PRIMARY KEY,	ADD PRIMARY KEY (`portal_id`, `portlet_tp`, `portlet_key`, `emp_seq`, `comp_seq`);
*/

-- 소스시퀀스 5226

/*
 * 수정사항
 * [시스템설정] 권한부여관리 선택 시 사원리스트 조회오류 수정
 * */

-- 소스시퀀스 5238




/*
/*
 * 수정사항
 * [메신저] 사용자 프로필 부서정보에 사업장명 추가
 * [공통] 기본 로그인회사 미사용 설정 시 로그인 불가 오류 수정
 * [시스템설정] 권한부여관리 메뉴 사원리스트 미노출 오류 수정
 * [시스템설정] 권한관리 정렬값 공백 저장 시 오류수정
 * */

DELIMITER $$
DROP FUNCTION IF EXISTS get_dept_pathNm$$
CREATE FUNCTION `get_dept_pathNm`(_delimiter TEXT, _dept_seq VARCHAR(32), _group_seq VARCHAR(32), _lang_code VARCHAR(32)) RETURNS text CHARSET utf8
    READS SQL DATA
BEGIN
    DECLARE _path TEXT;
    DECLARE _id VARCHAR(32);
    DECLARE _nm VARCHAR(32);
    DECLARE _start_with VARCHAR(32);
    DECLARE EXIT HANDLER FOR NOT FOUND RETURN _path;

    SET _start_with = '0';
    SET _id = COALESCE(_dept_seq, _start_with);
    SELECT FN_GetMultiLang(_lang_code, dept_name_multi) INTO _nm FROM v_t_co_dept_multi WHERE dept_seq = _dept_seq AND group_seq = _group_seq;
    SET _path = _nm;
    LOOP
        SELECT  a.parent_dept_seq, CASE WHEN c.parent_dept_seq = '0' AND d.display_yn = 'Y' THEN CONCAT((SELECT FN_GetMultiLang(_lang_code, biz_name_multi) FROM v_t_co_biz_multi WHERE biz_seq = d.biz_seq LIMIT 1), _delimiter, FN_GetMultiLang(_lang_code, b.dept_name_multi)) ELSE FN_GetMultiLang(_lang_code, b.dept_name_multi) END
        INTO    _id, _nm
        FROM    t_co_dept a, v_t_co_dept_multi b, t_co_dept c, t_co_biz d
        WHERE   a.group_seq = _group_seq
        AND a.group_seq = b.group_seq
        AND a.parent_dept_seq = b.dept_seq
        AND b.dept_seq = c.dept_seq
        AND c.biz_seq = d.biz_seq
        AND a.dept_seq = _id
        AND COALESCE(a.parent_dept_seq <> _start_with, TRUE)
        AND COALESCE(a.parent_dept_seq <> _dept_seq, TRUE);
        SET _path = CONCAT(_nm, _delimiter, _path);
    END LOOP;
END$$
DELIMITER ;

update t_co_dept_multi set path_name=get_dept_pathNm('|', dept_seq, group_seq, lang_code);
*/    --소스시퀀스 5271 반영완료


/*
 * 수정사항
 * [공통포탈] 날씨 포틀릿 기상청 API 연동
 * - 야후 날씨 API 정책 변경에 따른 기상청 API연동 되도록 개선
 * [확장기능] 방문객 관리 수정
 * - 외주인원 승인 관련 쿼리 수정 (VisitorManageDAO.GetVisitorListApp)
 * - 입/퇴실 체크 관련 프로시져 내부 직급/직책명 함수 변경 수정 (get_emp_dp, get_comp_emp_dp ---> get_emp_duty_position_name)
 * */

/*
ALTER TABLE t_co_group	ADD COLUMN IF NOT EXISTS weather_api_key VARCHAR(100) NULL DEFAULT NULL COMMENT '기상청 API KEY' AFTER drm_option_val2;
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '48,109', tcdm.detail_code = '48,109' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28808958';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '51,110', tcdm.detail_code = '51,110' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132563';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '51,130', tcdm.detail_code = '51,130' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289161';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '54,100', tcdm.detail_code = '54,100' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1126255';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '54,112', tcdm.detail_code = '54,112' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289143';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '54,124', tcdm.detail_code = '54,124' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289263';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '55,106', tcdm.detail_code = '55,106' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289205';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '55,124', tcdm.detail_code = '55,124' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132496';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '55,128', tcdm.detail_code = '55,128' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1122361';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '56,125', tcdm.detail_code = '56,125' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132445';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '56,131', tcdm.detail_code = '56,131' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1126221';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '57,103', tcdm.detail_code = '57,103' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289135';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '57,119', tcdm.detail_code = '57,119' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '23424696';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '57,123', tcdm.detail_code = '57,123' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132562';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '57,128', tcdm.detail_code = '57,128' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1130853';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '58,107', tcdm.detail_code = '58,107' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289336';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '58,121', tcdm.detail_code = '58,121' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132444';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '58,125', tcdm.detail_code = '58,125' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132519';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '59,122', tcdm.detail_code = '59,122' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132516';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '59,123', tcdm.detail_code = '59,123' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132443';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '60,110', tcdm.detail_code = '60,110' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1118866';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '60,121', tcdm.detail_code = '60,121' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132567';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '60,122', tcdm.detail_code = '60,122' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '23424699';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '60,124', tcdm.detail_code = '60,124' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132518';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '60,127', tcdm.detail_code = '60,127' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132599';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '61,130', tcdm.detail_code = '61,130' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132577';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '61,131', tcdm.detail_code = '61,131' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28997340';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '61,134', tcdm.detail_code = '61,134' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132470';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '61,138', tcdm.detail_code = '61,138' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289321';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '62,114', tcdm.detail_code = '62,114' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132540';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '62,118', tcdm.detail_code = '62,118' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132536';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '62,127', tcdm.detail_code = '62,127' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132517';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '63,102', tcdm.detail_code = '63,102' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1122639';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '63,110', tcdm.detail_code = '63,110' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132455';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '63,124', tcdm.detail_code = '63,124' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132559';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '64,119', tcdm.detail_code = '64,119' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132094';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '64,126', tcdm.detail_code = '64,126' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1119565';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '64,128', tcdm.detail_code = '64,128' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '22724923';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '64,134', tcdm.detail_code = '64,134' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28997339';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '65,115', tcdm.detail_code = '65,115' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1118776';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '65,123', tcdm.detail_code = '65,123' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1123319';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '65,139', tcdm.detail_code = '65,139' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289129';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '67,100', tcdm.detail_code = '67,100' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '2345975';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '68,111', tcdm.detail_code = '68,111' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289221';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '68,121', tcdm.detail_code = '68,121' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132495';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '69,106', tcdm.detail_code = '69,106' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132456';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '69,125', tcdm.detail_code = '69,125' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289314';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '69,133', tcdm.detail_code = '69,133' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289167';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '71,110', tcdm.detail_code = '71,110' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28807479';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '72,113', tcdm.detail_code = '72,113' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289157';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '72,121', tcdm.detail_code = '72,121' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289320';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '72,139', tcdm.detail_code = '72,139' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289206';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '73,103', tcdm.detail_code = '73,103' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289112';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '73,134', tcdm.detail_code = '73,134' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132463';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '74,111', tcdm.detail_code = '74,111' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289172';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '75,130', tcdm.detail_code = '75,130' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289204';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '76,114', tcdm.detail_code = '76,114' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132464';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '76,122', tcdm.detail_code = '76,122' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132584';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '77,125', tcdm.detail_code = '77,125' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289203';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '77,139', tcdm.detail_code = '77,139' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289312';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '80,138', tcdm.detail_code = '80,138' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28807348';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '81,102', tcdm.detail_code = '81,102' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132552';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '81,106', tcdm.detail_code = '81,106' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1124086';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '81,118', tcdm.detail_code = '81,118' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132500';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '84,115', tcdm.detail_code = '84,115' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289144';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '84,123', tcdm.detail_code = '84,123' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289268';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '85,145', tcdm.detail_code = '85,145' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289178';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '86,107', tcdm.detail_code = '86,107' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289317';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '86,119', tcdm.detail_code = '86,119' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289330';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '87,141', tcdm.detail_code = '87,141' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132556';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '88,138', tcdm.detail_code = '88,138' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289316';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '89,111', tcdm.detail_code = '89,111' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132591';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '89,123', tcdm.detail_code = '89,123' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289218';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '90,101', tcdm.detail_code = '90,101' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289304';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '90,113', tcdm.detail_code = '90,113' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289113';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '91,106', tcdm.detail_code = '91,106' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132441';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '92,131', tcdm.detail_code = '92,131' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132475';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '95,119', tcdm.detail_code = '95,119' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132568';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '96,103', tcdm.detail_code = '96,103' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289133';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '97,108', tcdm.detail_code = '97,108' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289331';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '97,127', tcdm.detail_code = '97,127' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132575';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '98,125', tcdm.detail_code = '98,125' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1126796';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '102,103', tcdm.detail_code = '102,103' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289324';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '102,115', tcdm.detail_code = '102,115' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289306';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '127,127', tcdm.detail_code = '127,127' WHERE tcd.code like 'cm1010' AND tcd.detail_code like 'ULLEUNG';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '100,77', tcdm.detail_code = '100,77' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289235';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '100,91', tcdm.detail_code = '100,91' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132482';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '102,84', tcdm.detail_code = '102,84' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132578';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '102,94', tcdm.detail_code = '102,94' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132538';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '48,59', tcdm.detail_code = '48,59' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289222';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '50,66', tcdm.detail_code = '50,66' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289291';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '50,67', tcdm.detail_code = '50,67' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132525';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '52,33', tcdm.detail_code = '52,33' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1128226';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '52,71', tcdm.detail_code = '52,71' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289246';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '52,72', tcdm.detail_code = '52,72' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289199';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '52,77', tcdm.detail_code = '52,77' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289329';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '53,38', tcdm.detail_code = '53,38' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132454';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '54,61', tcdm.detail_code = '54,61' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289196';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '55,76', tcdm.detail_code = '55,76' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289281';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '56,66', tcdm.detail_code = '56,66' WHERE tcd.code like 'cm1010' AND tcd.detail_code like 'YEONGAM';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '56,71', tcdm.detail_code = '56,71' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132529';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '56,80', tcdm.detail_code = '56,80' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289171';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '56,87', tcdm.detail_code = '56,87' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289116';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '56,92', tcdm.detail_code = '56,92' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132480';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '57,56', tcdm.detail_code = '57,56' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289308';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '57,63', tcdm.detail_code = '57,63' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289162';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '57,77', tcdm.detail_code = '57,77' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289214';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '58,74', tcdm.detail_code = '58,74' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132481';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '58,83', tcdm.detail_code = '58,83' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132462';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '59,64', tcdm.detail_code = '59,64' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289213';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '59,88', tcdm.detail_code = '59,88' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1122359';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '59,99', tcdm.detail_code = '59,99' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289125';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '60,91', tcdm.detail_code = '60,91' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1121683';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '61,72', tcdm.detail_code = '61,72' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289208';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '61,78', tcdm.detail_code = '61,78' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289142';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '62,66', tcdm.detail_code = '62,66' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289115';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '62,91', tcdm.detail_code = '62,91' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289309';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '62,97', tcdm.detail_code = '62,97' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132532';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '63,79', tcdm.detail_code = '63,79' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28807928';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '63,89', tcdm.detail_code = '63,89' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132502';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '65,99', tcdm.detail_code = '65,99' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28997341';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '66,62', tcdm.detail_code = '66,62' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289173';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '66,77', tcdm.detail_code = '66,77' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289174';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '66,84', tcdm.detail_code = '66,84' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289211';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '68,80', tcdm.detail_code = '68,80' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132531';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '68,88', tcdm.detail_code = '68,88' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289220';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '69,75', tcdm.detail_code = '69,75' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28808096';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '69,95', tcdm.detail_code = '69,95' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289170';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '70,70', tcdm.detail_code = '70,70' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132566';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '70,85', tcdm.detail_code = '70,85' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289215';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '71,99', tcdm.detail_code = '71,99' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289262';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '72,93', tcdm.detail_code = '72,93' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289247';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '73,66', tcdm.detail_code = '73,66' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132596';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '73,70', tcdm.detail_code = '73,70' WHERE tcd.code like 'cm1010' AND tcd.detail_code like 'GWANGYANG';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '74,73', tcdm.detail_code = '74,73' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289195';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '74,82', tcdm.detail_code = '74,82' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289200';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '74,97', tcdm.detail_code = '74,97' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289327';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '76,80', tcdm.detail_code = '76,80' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289273';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '77,68', tcdm.detail_code = '77,68' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289257';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '77,86', tcdm.detail_code = '77,86' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289233';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '80,71', tcdm.detail_code = '80,71' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132548';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '80,96', tcdm.detail_code = '80,96' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1122356';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '81,75', tcdm.detail_code = '81,75' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132459';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '81,84', tcdm.detail_code = '81,84' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289202';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '83,78', tcdm.detail_code = '83,78' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289303';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '83,87', tcdm.detail_code = '83,87' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289176';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '83,91', tcdm.detail_code = '83,91' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289287';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '84,96', tcdm.detail_code = '84,96' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132479';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '85,71', tcdm.detail_code = '85,71' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289177';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '85,93', tcdm.detail_code = '85,93' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289136';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '86,77', tcdm.detail_code = '86,77' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28808803';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '87,68', tcdm.detail_code = '87,68' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132600';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '87,83', tcdm.detail_code = '87,83' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289126';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '88,99', tcdm.detail_code = '88,99' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289183';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '89,90', tcdm.detail_code = '89,90' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132466';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '90,69', tcdm.detail_code = '90,69' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1122513';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '90,77', tcdm.detail_code = '90,77' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132449';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '91,86', tcdm.detail_code = '91,86' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '28289131';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '91,90', tcdm.detail_code = '91,90' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1123509';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '92,83', tcdm.detail_code = '92,83' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132524';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '95,77', tcdm.detail_code = '95,77' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132509';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '95,93', tcdm.detail_code = '95,93' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1131941';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '97,79', tcdm.detail_code = '97,79' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132587';
UPDATE t_co_code_detail AS tcd INNER JOIN t_co_code_detail_multi AS tcdm ON tcd.code = tcdm.code AND tcd.detail_code = tcdm.detail_code	SET tcd.detail_code = '98,76', tcdm.detail_code = '98,76' WHERE tcd.code like 'cm1010' AND tcd.detail_code like '1132447';
INSERT INTO t_co_code_detail(detail_code, code, ischild, order_num, use_yn, create_seq) VALUES('66,103', 'cm1010', 'N', 167, 'Y', '1');
INSERT INTO t_co_code_detail_multi(detail_code, code, lang_code, detail_name, use_yn) VALUES('66,103', 'cm1010', 'kr', '세종특별자치시', 'Y');
INSERT INTO t_co_code_detail_multi(detail_code, code, lang_code, detail_name, use_yn) VALUES('66,103', 'cm1010', 'en', 'Sejong City', 'Y');
INSERT INTO t_co_code_detail_multi(detail_code, code, lang_code, detail_name, use_yn) VALUES('66,103', 'cm1010', 'jp', '世宗特別自治市', 'Y');
INSERT INTO t_co_code_detail_multi(detail_code, code, lang_code, detail_name, use_yn) VALUES('66,103', 'cm1010', 'cn', '世宗特別自治市', 'Y');
DELETE FROM t_co_code_detail_multi WHERE detail_code LIKE '28289333' AND code LIKE 'cm1010';
DELETE FROM t_co_code_detail WHERE detail_code LIKE '28289333' AND code LIKE 'cm1010';
DELETE FROM t_co_code_detail_multi WHERE detail_code LIKE '28289134' AND code LIKE 'cm1010';
DELETE FROM t_co_code_detail WHERE detail_code LIKE '28289134' AND code LIKE 'cm1010';
*/



-- 소스시퀀스 5367


/*
 * 수정사항
 * [공통댓글] 결재의견 메알알림 전송 시 등록자가 아닌 기안자로 표시되는 문제 수정
 * */

/*
DELIMITER $$
DROP PROCEDURE IF EXISTS Z_DUZONITGROUP_BS_VISITOR_S$$
CREATE PROCEDURE `Z_DUZONITGROUP_BS_VISITOR_S`(
	  IN nRNo INT
	, IN sDistinct VARCHAR(1)
	, IN sFrDT VARCHAR(20)
	, IN sToDT VARCHAR(20)
	, IN sType VARCHAR(8)
	, IN pDept VARCHAR(100)
	, IN pGrade VARCHAR(100)
	, IN pName VARCHAR(100)
	, IN pVisitCo VARCHAR(100)
	, IN pVisitNm VARCHAR(100)
	, IN empSeq VARCHAR(32)
	, IN userSe VARCHAR(10)
	, IN startNum INT
	, IN endNum INT
)
BEGIN
	DECLARE sAppGradeCD VARCHAR(5);

	SET sAppGradeCD = CASE WHEN (
						SELECT approver_emp_seq
						FROM Z_DUZONITGROUP_VISITORS_M
						WHERE r_no = nRNo) = NULL
					THEN ''
					WHEN (
						SELECT approver_emp_seq
						FROM Z_DUZONITGROUP_VISITORS_M
						WHERE r_no = nRNo) > 0
					THEN (
						SELECT get_emp_duty_position_name(b.group_seq,b.comp_seq,b.dept_duty_code,'DUTY','kr')
						FROM Z_DUZONITGROUP_VISITORS_M A
						JOIN v_user_info B
						ON A.approver_emp_seq = B.emp_seq AND A.approver_comp_seq = B.comp_seq
						WHERE B.main_dept_yn = 'y'
						LIMIT 0,1)
					END;

	IF sDistinct = 1 THEN
		BEGIN


			IF nRNo = 0 THEN
			BEGIN
				SELECT
				a.r_no,
				IFNULL(b.seq, 0) AS seq,
				e.comp_name man_comp_name,

 				e.dept_name man_dept_name,

				e.emp_name man_emp_name,

				e.dept_name man_dept_name,
				get_emp_duty_position_name(e.group_seq,e.comp_seq,e.dept_duty_code,'DUTY','kr') man_grade_name,


				a.req_comp_seq,
				a.req_emp_seq,
				IFNULL(f.comp_name, '') AS approver_comp_name,
				IFNULL(f.emp_name, '') AS approver_emp_name,
				IFNULL((CASE WHEN (
							SELECT approver_emp_seq
							FROM Z_DUZONITGROUP_VISITORS_M
							WHERE r_no = a.r_no) = NULL
						THEN ''
						WHEN (
							SELECT approver_emp_seq
							FROM Z_DUZONITGROUP_VISITORS_M
							WHERE r_no = a.r_no) > 0
						THEN (
							SELECT get_emp_duty_position_name(b.group_seq,b.comp_seq,b.dept_duty_code,'DUTY','kr')
							FROM Z_DUZONITGROUP_VISITORS_M A
							JOIN v_user_info B
							ON A.approver_emp_seq = B.emp_seq AND A.approver_comp_seq = B.comp_seq AND B.main_dept_yn = 'Y' AND B.emp_lang_code='kr'
							WHERE B.main_dept_yn = '1'
							LIMIT 0,1)
						END), '') AS approver_grade,
				a.visit_distinct,
				a.visitor_co,
				a.visitor_nm,
				a.visit_hp,
				a.visit_car_no,
				a.visit_aim,
				a.visit_cnt,
				DATE_FORMAT(STR_TO_DATE(a.visit_dt_fr, '%Y%m%d'),'%Y-%m-%d') visit_dt_fr,

				IFNULL(a.visit_dt_to, '') AS visit_dt_to,
				IFNULL(a.visit_tm_fr, '') AS visit_tm_fr,
				IFNULL(a.visit_tm_to, '') AS visit_tm_to,
				a.approval_yn,
				DATE_FORMAT(STR_TO_DATE(b.visit_dt, '%Y%m%d'),'%Y-%m-%d') visit_dt,

				CASE WHEN b.in_time != '' THEN CONCAT(SUBSTR(IFNULL(b.in_time,''),1,2),':',SUBSTR(IFNULL(b.in_time,''),3,2)) END AS in_time,
				CASE WHEN b.out_time != '' THEN CONCAT(SUBSTR(IFNULL(b.out_time,''),1,2),':',SUBSTR(IFNULL(b.out_time,''),3,2)) END AS out_time,

				IFNULL(b.visit_card_no, '') AS visit_card_no,
				IFNULL(a.etc, '') AS etc
			FROM Z_DUZONITGROUP_VISITORS_M a
			LEFT OUTER JOIN Z_DUZONITGROUP_VISITORS_D b ON a.r_no = b.r_no
			JOIN v_user_info e ON a.man_emp_seq = e.emp_seq AND a.man_comp_seq = e.comp_seq
			LEFT JOIN v_user_info f ON a.approver_emp_seq = f.emp_seq AND a.approver_comp_seq = f.comp_seq AND f.main_dept_yn = 'Y' AND f.emp_lang_code = 'kr'

			WHERE a.visit_distinct = 1 AND a.del_yn != 1 AND e.main_dept_yn = 'Y' AND e.emp_lang_code = 'kr'
				  AND (a.visit_dt_fr >= sFrDT AND a.visit_dt_fr <= sToDT)
				 AND IFNULL(e.dept_name,'') LIKE CONCAT('%' ,pDept, '%')
				 AND IFNULL(get_emp_duty_position_name(e.group_seq,e.comp_seq,e.dept_duty_code,'DUTY','kr'),'') LIKE CONCAT('%' ,pGrade, '%')

				 AND IFNULL(e.emp_name,'') LIKE CONCAT('%' ,pName, '%')
				 AND IFNULL(a.visitor_co,'') LIKE CONCAT('%' ,pVisitCo, '%')
				 AND IFNULL(a.visitor_nm,'') LIKE CONCAT('%' ,pVisitNm, '%')
				 AND a.req_emp_seq = CASE WHEN userSe = 'USER' THEN empSeq ELSE a.req_emp_seq END

 				 ORDER BY a.visit_dt_fr DESC



				LIMIT startNum, endNum;
			END;

			ELSE
				SELECT
				a.r_no,
				IFNULL(b.seq, 0) AS seq,
				e.comp_name man_comp_name,
				e.dept_seq AS man_dept_seq,
				e.dept_name man_dept_name,

				e.emp_name man_emp_name,
				get_emp_duty_position_name(e.group_seq,e.comp_seq,e.dept_duty_code,'DUTY','kr') man_grade_name,


				a.req_comp_seq,
				a.req_emp_seq,



				IFNULL(f.comp_name, '') AS approver_comp_name,
				IFNULL(f.emp_name, '') AS approver_emp_name,
				IFNULL(sAppGradeCD, '') AS approver_grade,
				a.visit_distinct,
				a.visitor_co,
				a.visitor_nm,
				a.visit_hp,
				a.visit_car_no,
				a.visit_aim,
				a.visit_cnt,
				a.visit_dt_fr,
				IFNULL(a.visit_dt_to, '') AS visit_dt_to,
				IFNULL(a.visit_tm_fr, '') AS visit_tm_fr,
				IFNULL(a.visit_tm_to, '') AS visit_tm_to,
				a.approval_yn,
				b.visit_dt,
				IFNULL(b.in_time, '') AS in_time,
				IFNULL(b.out_time, '') AS out_time,
				IFNULL(b.visit_card_no, '') AS visit_card_no,
				IFNULL(a.etc, '') AS etc
				FROM Z_DUZONITGROUP_VISITORS_M a

				LEFT OUTER JOIN Z_DUZONITGROUP_VISITORS_D b ON a.r_no = b.r_no


				LEFT JOIN v_user_info e ON a.man_emp_seq = e.emp_seq AND a.man_comp_seq = e.comp_seq AND e.emp_lang_code = 'kr'
				LEFT JOIN v_user_info f ON a.approver_emp_seq = f.emp_seq AND a.approver_comp_seq = f.comp_seq AND f.main_dept_yn = 'Y' AND f.emp_lang_code = 'kr'
				WHERE a.visit_distinct = 1 AND a.del_yn != 1 AND a.r_no = nRNo  AND e.main_dept_yn = 'Y' AND e.emp_lang_code = 'kr'

				AND e.dept_name LIKE CONCAT('%' ,pDept, '%')
				AND IFNULL(get_emp_duty_position_name(e.group_seq,e.comp_seq,e.dept_duty_code,'DUTY','kr'),'') LIKE CONCAT('%' ,pGrade, '%')

				AND e.emp_name LIKE CONCAT('%' ,pName, '%')
				AND a.visitor_co LIKE CONCAT('%' ,pVisitCo, '%')
				AND a.visitor_nm LIKE CONCAT('%' ,pVisitNm, '%')
				AND a.req_emp_seq = CASE WHEN userSe = 'USER' THEN empSeq ELSE a.req_emp_seq END
				ORDER BY a.visit_dt_fr DESC
				LIMIT startNum, endNum;
		   END IF;
		END;

	ELSE
		IF nRNo = 0 THEN
		BEGIN
			IF sType = 'check' THEN
			BEGIN
				SELECT
				a.r_no,
				b.seq,
				e.comp_name man_comp_name,
				e.dept_seq AS man_dept_seq,

				e.dept_name man_dept_name,

				get_comp_emp_dp(e.comp_seq,e.dept_duty_code,'DUTY','kr') man_grade_name,


				e.emp_name man_emp_name,

				a.req_comp_seq,
				a.req_emp_seq,
				IFNULL(f.comp_name, '') AS approver_comp_name,
				IFNULL(f.emp_name, '') AS approver_emp_name,
				IFNULL((CASE WHEN (
							SELECT approver_comp_seq
							FROM Z_DUZONITGROUP_VISITORS_M
							WHERE r_no = a.r_no) = NULL
						THEN ''
						WHEN (
							SELECT approver_emp_seq
							FROM Z_DUZONITGROUP_VISITORS_M
							WHERE r_no = a.r_no) > 0
						THEN (
							SELECT get_emp_duty_position_name(b.group_seq,b.comp_seq,b.dept_duty_code,'DUTY','kr')
							FROM Z_DUZONITGROUP_VISITORS_M A
							JOIN v_user_info b
							ON A.approver_emp_seq = B.emp_seq AND A.approver_comp_seq = B.comp_seq AND B.main_dept_yn = 'Y' AND B.emp_lang_code='kr'
							WHERE B.main_dept_yn = 'Y'



							LIMIT 0,1)
						END), '') AS approver_grade,
				a.visit_distinct,
				a.visitor_co,
				a.visitor_nm,
				a.visit_hp,
				a.visit_car_no,
				a.visit_aim,
				a.visit_cnt,
				DATE_FORMAT(STR_TO_DATE(b.visit_dt, '%Y%m%d'),'%Y-%m-%d') visit_dt_fr,
				DATE_FORMAT(STR_TO_DATE(a.visit_dt_fr, '%Y%m%d'),'%Y-%m-%d') visit_dt,
				IFNULL(a.visit_dt_to, '') AS visit_dt_to,
				IFNULL(a.visit_tm_fr, '') AS visit_tm_fr,
				IFNULL(a.visit_tm_to, '') AS visit_tm_to,
				a.approval_yn,
				CASE WHEN b.in_time != '' THEN CONCAT(SUBSTR(IFNULL(b.in_time,''),1,2),':',SUBSTR(IFNULL(b.in_time,''),3,2)) END AS in_time,
				CASE WHEN b.out_time != '' THEN CONCAT(SUBSTR(IFNULL(b.out_time,''),1,2),':',SUBSTR(IFNULL(b.out_time,''),3,2)) END AS out_time,


				IFNULL(b.visit_card_no, '') AS visit_card_no,
				IFNULL(a.etc, '') AS etc

				FROM Z_DUZONITGROUP_VISITORS_M a
				LEFT OUTER JOIN Z_DUZONITGROUP_VISITORS_D b ON a.r_no = b.r_no
				LEFT JOIN v_user_info e ON a.man_emp_seq = e.emp_seq AND a.man_comp_seq = e.comp_seq AND e.emp_lang_code = 'kr'
				LEFT JOIN v_user_info f ON a.approver_emp_seq = f.emp_seq AND a.approver_comp_seq = f.comp_seq AND f.main_dept_yn = 'Y' AND f.emp_lang_code = 'kr'



				WHERE
					a.visit_distinct = 2
					AND e.main_dept_yn = 'Y'
					AND a.del_yn != 1
					AND (b.visit_dt >= sFrDT AND b.visit_dt <= sToDT)
					AND e.dept_name LIKE CONCAT('%' ,pDept, '%')
					AND IFNULL(get_emp_duty_position_name(e.group_seq,e.comp_seq,e.dept_duty_code,'DUTY','kr'),'') LIKE CONCAT('%' ,pGrade, '%')

					AND e.emp_name LIKE CONCAT('%' ,pName, '%')
					AND a.visitor_co LIKE CONCAT('%' ,pVisitCo, '%')
					AND a.visitor_nm LIKE CONCAT('%' ,pVisitNm, '%')
					AND a.req_emp_seq = CASE WHEN userSe = 'USER' THEN empSeq ELSE a.req_emp_seq END
					ORDER BY DATE_FORMAT(STR_TO_DATE(b.visit_dt, '%Y%m%d'),'%Y-%m-%d') DESC
				LIMIT startNum, endNum;
			END;

			ELSE
				SELECT
				a.r_no,
				0 AS seq,
				e.comp_name man_comp_name,

				e.dept_seq AS man_dept_seq,

				e.dept_name man_dept_name,

				get_emp_duty_position_name(e.group_seq,e.comp_seq,e.dept_duty_code,'DUTY','kr') man_grade_name,


				e.emp_name man_emp_name,

				a.req_comp_seq,
				a.req_emp_seq,

				IFNULL(f.comp_name, '') AS approver_comp_name,
				IFNULL(f.emp_name, '') AS approver_emp_name,
				IFNULL((CASE WHEN (
							SELECT approver_emp_seq
							FROM Z_DUZONITGROUP_VISITORS_M
							WHERE r_no = a.r_no) = NULL
						THEN ''
						WHEN (
							SELECT approver_emp_seq
							FROM Z_DUZONITGROUP_VISITORS_M
							WHERE r_no = a.r_no) > 0
						THEN (
							SELECT get_emp_duty_position_name(b.group_seq,b.comp_seq,b.dept_duty_code,'DUTY','kr')
							FROM Z_DUZONITGROUP_VISITORS_M A
							JOIN v_user_info B
							ON A.approver_emp_seq = B.emp_seq AND A.approver_comp_seq = B.comp_seq AND B.main_dept_yn = 'Y'
							WHERE B.main_dept_yn = 'Y'
							LIMIT 0,1)
						END), '') AS approver_grade,
				a.visit_distinct,
				a.visitor_co,
				a.visitor_nm,
				a.visit_hp,
				a.visit_car_no,
				a.visit_aim,
				a.visit_cnt,
				DATE_FORMAT(STR_TO_DATE(a.visit_dt_fr, '%Y%m%d'),'%Y-%m-%d') visit_dt_fr,

				DATE_FORMAT(STR_TO_DATE(IFNULL(a.visit_dt_to, ''), '%Y%m%d'),'%Y-%m-%d') visit_dt_to,

				a.visit_tm_fr,
				a.visit_tm_fr visit_dt,
				IFNULL(a.visit_tm_to, '') AS visit_tm_to,
				CASE WHEN a.approval_yn = 0 THEN '대기' WHEN a.approval_yn = 1 THEN '승인'  ELSE '반려' END approval_yn,
				'' AS in_time,
				'' AS out_time,
				'' AS visit_card_no,
				IFNULL(a.etc, '') AS etc

				FROM Z_DUZONITGROUP_VISITORS_M a
				JOIN v_user_info e ON a.man_emp_seq = e.emp_seq AND a.man_comp_seq = e.comp_seq
				LEFT JOIN v_user_info f ON a.approver_emp_seq = f.emp_seq AND a.approver_comp_seq = f.comp_seq AND f.main_dept_yn = 'Y' AND f.emp_lang_code = 'kr'


				WHERE
					a.visit_distinct = 2
					 AND e.main_dept_yn = 'Y'
					 AND a.del_yn != 1
					 AND e.emp_lang_code='kr'
					 AND ((a.visit_dt_fr BETWEEN sFrDT AND sToDT) OR (a.visit_dt_to BETWEEN sFrDT AND sToDT))
					 AND e.dept_name LIKE CONCAT('%' ,pDept, '%')
					 AND IFNULL(get_emp_duty_position_name(e.group_seq,e.comp_seq,e.dept_duty_code,'DUTY','kr'),'') LIKE CONCAT('%' ,pGrade, '%')

				    AND e.emp_name LIKE CONCAT('%' ,pName, '%')
				    AND a.visitor_co LIKE CONCAT('%' ,pVisitCo, '%')
				    AND a.visitor_nm LIKE CONCAT('%' ,pVisitNm, '%')
				    AND a.req_emp_seq = CASE WHEN userSe = 'USER' THEN empSeq ELSE a.req_emp_seq END
				    ORDER BY a.visit_dt_fr DESC
				LIMIT startNum, endNum;









			END IF;
		END;

		ELSE
			SELECT
			a.r_no,
			0 AS seq,
			e.comp_name man_comp_name,

			e.dept_seq AS man_dept_seq,

			e.dept_name man_dept_name,

			get_emp_duty_position_name(e.group_seq,e.comp_seq,e.dept_duty_code,'DUTY','kr') man_grade_name,


			e.emp_name man_emp_name,

			a.req_comp_seq,
			a.req_emp_seq,
			IFNULL(f.comp_name, '') AS approver_comp_name,
			IFNULL(f.emp_name, '') AS approver_emp_name,
			IFNULL(sAppGradeCD, '') AS approver_grade,
			a.visit_distinct,
			a.visitor_co,
			a.visitor_nm,
			a.visit_hp,
			a.visit_car_no,
			a.visit_aim,
			a.visit_cnt,
			DATE_FORMAT(STR_TO_DATE(a.visit_dt_fr, '%Y%m%d'),'%Y-%m-%d') visit_dt_fr,
			DATE_FORMAT(STR_TO_DATE(a.visit_dt_fr, '%Y%m%d'),'%Y-%m-%d') visit_dt,

			DATE_FORMAT(STR_TO_DATE(IFNULL(a.visit_dt_to, ''), '%Y%m%d'),'%Y-%m-%d') visit_dt_to,

			a.visit_tm_fr,
			IFNULL(a.visit_tm_to, '') AS visit_tm_to,
			a.approval_yn,
			'' AS in_time,
			'' AS out_time,
			'' AS visit_card_no,
			IFNULL(a.etc, '') AS etc

		FROM Z_DUZONITGROUP_VISITORS_M a


		JOIN v_user_info e ON a.man_emp_seq = e.emp_seq AND a.man_comp_seq = e.comp_seq
		LEFT JOIN v_user_info f ON a.approver_emp_seq = f.emp_seq AND a.approver_comp_seq = f.comp_seq AND f.main_dept_yn = 'Y' AND f.emp_lang_code = 'kr'
		WHERE
			a.visit_distinct = 2
			AND e.main_dept_yn = 'Y'
			AND a.del_yn != 1
			AND a.r_no = nRNo
			ORDER BY a.visit_dt_fr DESC
		LIMIT startNum, endNum;
		END IF;
	END IF;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS Z_DUZONITGROUP_BS_VISITOR_S_TOTALCOUNT$$
CREATE PROCEDURE `Z_DUZONITGROUP_BS_VISITOR_S_TOTALCOUNT`(
	  IN nRNo INT
	, IN sDistinct VARCHAR(1)
	, IN sFrDT VARCHAR(20)
	, IN sToDT VARCHAR(20)
	, IN sType VARCHAR(8)
	, IN pDept VARCHAR(100)
	, IN pGrade VARCHAR(100)
	, IN pName VARCHAR(100)
	, IN pVisitCo VARCHAR(100)
	, IN pVisitNm VARCHAR(100)
	, IN userSe VARCHAR(10)
	, IN empSeq VARCHAR(32)
)
BEGIN
	IF sDistinct = 1 THEN
		BEGIN
			IF nRNo = 0 THEN
			BEGIN
				SELECT
					COUNT(a.r_no)
				FROM Z_DUZONITGROUP_VISITORS_M a
				JOIN v_user_info e ON a.man_emp_seq = e.emp_seq AND a.man_comp_seq = e.comp_seq AND e.main_dept_yn='Y' AND e.emp_lang_code='kr'
				WHERE a.visit_distinct = 1 AND a.del_yn != 1
					AND (a.visit_dt_fr >= sFrDT AND a.visit_dt_fr <= sToDT)
					AND e.dept_name LIKE CONCAT('%' ,pDept, '%')
					AND IFNULL(get_emp_duty_position_name(e.group_seq,e.comp_seq,e.duty_code,'DUTY','kr'),'') LIKE CONCAT('%' ,pGrade, '%')
					AND e.emp_name LIKE CONCAT('%' ,pName, '%')
					AND a.visitor_co LIKE CONCAT('%' ,pVisitCo, '%')
					AND a.visitor_nm LIKE CONCAT('%' ,pVisitNm, '%')
					AND a.req_emp_seq = CASE WHEN userSe = 'USER' THEN empSeq ELSE a.req_emp_seq END;
			END;
			ELSE
				SELECT
					COUNT(a.r_no)
				FROM Z_DUZONITGROUP_VISITORS_M a
				JOIN Z_DUZONITGROUP_VISITORS_D b ON a.r_no = b.r_no
				JOIN v_user_info e ON a.man_emp_seq = e.emp_seq AND a.man_comp_seq = e.comp_seq AND e.main_dept_yn='Y' AND e.emp_lang_code='kr'
				WHERE a.visit_distinct = 1 AND a.del_yn != 1 AND a.r_no = nRNo
					AND (a.visit_dt_fr >= sFrDT AND a.visit_dt_fr <= sToDT)
					AND e.dept_name LIKE CONCAT('%' ,pDept, '%')
					AND IFNULL(get_emp_duty_position_name(e.group_seq,e.comp_seq,e.duty_code,'DUTY','kr'),'') LIKE CONCAT('%' ,pGrade, '%')
					AND e.emp_name LIKE CONCAT('%' ,pName, '%')
					AND a.visitor_co LIKE CONCAT('%' ,pVisitCo, '%')
					AND a.visitor_nm LIKE CONCAT('%' ,pVisitNm, '%')
					AND a.req_emp_seq = CASE WHEN userSe = 'USER' THEN empSeq ELSE a.req_emp_seq END;
		   END IF;
		END;
	ELSE
		IF nRNo = 0 THEN
		BEGIN
			IF sType = 'check' THEN
			BEGIN
				SELECT COUNT(a.r_no)
				FROM Z_DUZONITGROUP_VISITORS_M a
				LEFT OUTER JOIN Z_DUZONITGROUP_VISITORS_D b ON a.r_no = b.r_no
				LEFT JOIN v_user_info e ON a.man_emp_seq = e.emp_seq AND a.man_comp_seq = e.comp_seq AND e.emp_lang_code = 'kr'
				LEFT JOIN v_user_info f ON a.approver_emp_seq = f.emp_seq AND a.approver_comp_seq = f.comp_seq AND f.main_dept_yn = 'Y' AND f.emp_lang_code = 'kr'
				WHERE
					a.visit_distinct = 2
					AND e.main_dept_yn = 'Y'
					AND a.del_yn != 1
					AND (b.visit_dt >= sFrDT AND b.visit_dt <= sToDT)
					AND e.dept_name LIKE CONCAT('%' ,pDept, '%')
					AND IFNULL(get_emp_duty_position_name(e.group_seq,e.comp_seq,e.dept_duty_code,'DUTY','kr'),'') LIKE CONCAT('%' ,pGrade, '%')
					AND e.emp_name LIKE CONCAT('%' ,pName, '%')
					AND a.visitor_co LIKE CONCAT('%' ,pVisitCo, '%')
					AND a.visitor_nm LIKE CONCAT('%' ,pVisitNm, '%')
					AND a.req_emp_seq = CASE WHEN userSe = 'USER' THEN empSeq ELSE a.req_emp_seq END;
			END;
			ELSE
				SELECT
					COUNT(a.r_no)
				FROM Z_DUZONITGROUP_VISITORS_M a
				JOIN v_user_info e ON a.man_emp_seq = e.emp_seq AND a.man_comp_seq = e.comp_seq AND e.main_dept_yn='Y' AND e.emp_lang_code='kr'
				WHERE
					a.visit_distinct = 2
					AND a.del_yn != 1
					AND (a.visit_dt_fr >= sFrDT AND a.visit_dt_fr <= sToDT)
					AND e.dept_name LIKE CONCAT('%' ,pDept, '%')
					AND IFNULL(get_emp_duty_position_name(e.group_seq,e.comp_seq,e.duty_code,'DUTY','kr'),'') LIKE CONCAT('%' ,pGrade, '%')
					AND e.emp_name LIKE CONCAT('%' ,pName, '%')
					AND a.visitor_co LIKE CONCAT('%' ,pVisitCo, '%')
					AND a.visitor_nm LIKE CONCAT('%' ,pVisitNm, '%')
					AND a.req_emp_seq = CASE WHEN userSe = 'USER' THEN empSeq ELSE a.req_emp_seq END;
			END IF;
		END;
		ELSE
			SELECT
				COUNT(a.r_no)
		FROM Z_DUZONITGROUP_VISITORS_M a
		JOIN v_user_info e ON a.man_emp_seq = e.emp_seq AND a.man_comp_seq = e.comp_seq AND e.main_dept_yn='Y' AND e.emp_lang_code='kr'
		WHERE
			a.visit_distinct = 2
			AND a.del_yn != 1
			AND a.r_no = nRNo
			AND e.dept_name LIKE CONCAT('%' ,pDept, '%')
			AND get_emp_duty_position_name(e.group_seq,e.comp_seq,e.duty_code,'DUTY','kr') LIKE CONCAT('%' ,pGrade, '%')
			AND e.emp_name LIKE CONCAT('%' ,pName, '%')
			AND a.visitor_co LIKE CONCAT('%' ,pVisitCo, '%')
			AND a.visitor_nm LIKE CONCAT('%' ,pVisitNm, '%')
			AND a.req_emp_seq = CASE WHEN userSe = 'USER' THEN empSeq ELSE a.req_emp_seq END;
		END IF;
	END IF;
END$$
DELIMITER ;
*/

-- 소스시퀀스 5382


/*
 * 수정사항
 * [사원정보관리] 사원/ID검색시 조회된 결과 값이 1번 페이지 포커스로 가지 않는 현상 수정
 * */


/*비영리 배포쿼리*/

/*
update t_co_menu_adm set delete_yn='Y' where menu_no=607003000;
update t_co_menu_adm set delete_yn='Y' where menu_no=607004000;

delete FROM t_co_menu_adm_multi WHERE menu_no IN (SELECT menu_no FROM t_Co_menu_adm WHERE menu_no LIKE '150%' AND menu_auth_type = 'MASTER');
delete FROM t_Co_menu_adm WHERE menu_no LIKE '150%' AND menu_auth_type = 'MASTER';
delete FROM t_co_menu_adm_multi WHERE menu_no IN (SELECT menu_no FROM t_Co_menu_adm WHERE menu_no LIKE '210%' AND menu_auth_type = 'MASTER');
delete FROM t_Co_menu_adm WHERE menu_no LIKE '210%' AND menu_auth_type = 'MASTER';

update t_co_menu set sso_use_yn = 'N' where sso_use_yn = 'Y' and menu_no not in ( select link_id from t_co_sso where link_tp = 'gw_menu');
update t_co_menu_adm set sso_use_yn = 'N' where sso_use_yn = 'Y' and menu_no not in ( select link_id from t_co_sso where link_tp = 'gw_menu');

update t_co_menu_adm_multi set menu_no=508000000 where menu_no=1912000003;
update t_co_menu_adm set menu_no=508000000 where menu_no=1912000003;
update t_co_menu_auth set menu_no=508000000 where menu_no=1912000003;
update t_co_emp_menu_history set menu_no=508000000 where menu_no=1912000003;
delete from t_co_menu_adm where menu_no between 1500000000 and 1599999999;
delete from t_co_menu_adm_multi where menu_no between 1500000000 and 1599999999;

insert ignore into t_co_menu_adm(menu_no, menu_gubun, upper_menu_no, menu_ordr, use_yn, url_gubun, url_path, sso_use_yn, menu_depth, menu_img_class, create_seq, create_date, modify_seq, modify_date, menu_adm_gubun, menu_auth_type, public_yn, delete_yn)
select menu_no+1000000000, menu_gubun, case when upper_menu_no != 0 then upper_menu_no+1000000000 else 1 end , menu_ordr, use_yn, url_gubun, url_path, sso_use_yn, menu_depth, menu_img_class, create_seq, create_date, modify_seq, modify_date, null, 'MASTER', public_yn, delete_yn
from t_co_menu_adm where menu_no between 500000000 and 599999999;

insert ignore into t_co_menu_adm_multi(menu_no, lang_code, menu_nm, menu_dc, create_seq, create_date, modify_seq, modify_date)
select menu_no+1000000000, lang_code, menu_nm, menu_dc, create_seq, create_date, modify_seq, modify_date
from t_co_menu_adm_multi where menu_no between 500000000 and 599999999;

delete from t_co_menu_adm where menu_no between 1600000000 and 1699999999;
delete from t_co_menu_adm_multi where menu_no between 1600000000 and 1699999999;
delete from t_co_menu_adm where menu_gubun='MENU006' and menu_auth_type='MASTER';

delete from t_co_menu_adm_multi where menu_no not in (select menu_no from t_co_menu_adm);
delete from t_co_menu_multi where menu_no not in (select menu_no from t_co_menu);

insert ignore into t_co_menu_adm(menu_no, menu_gubun, upper_menu_no, menu_ordr, use_yn, url_gubun, url_path, sso_use_yn, menu_depth, menu_img_class, create_seq, create_date, modify_seq, modify_date, menu_adm_gubun, menu_auth_type, public_yn, delete_yn)
select menu_no+1000000000, menu_gubun, case when upper_menu_no != 0 then upper_menu_no+1000000000 else 1 end , menu_ordr, use_yn, url_gubun, url_path, sso_use_yn, menu_depth, menu_img_class, create_seq, create_date, modify_seq, modify_date, null, 'MASTER', public_yn, delete_yn
from t_co_menu_adm where menu_no between 600000000 and 699999999;

insert ignore into t_co_menu_adm_multi(menu_no, lang_code, menu_nm, menu_dc, create_seq, create_date, modify_seq, modify_date)
select menu_no+1000000000, lang_code, menu_nm, menu_dc, create_seq, create_date, modify_seq, modify_date
from t_co_menu_adm_multi where menu_no between 600000000 and 699999999;
*/
-- 소스시퀀스 5562

/*
 * 수정사항
 * [그룹정보관리] 그룹기본정보 저장시  오류 수정
 * */


/*
 * 수정사항
 * [ERP조직도연동 오류] ERP조직도 연동시 프로필사진 사라지는 오류 수정.
 *
 * */
/*
CREATE TABLE IF NOT EXISTS `t_sc_work_report_attend_time_emp` (
	`emp_seq` VARCHAR(50) NULL DEFAULT NULL
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

ALTER TABLE t_co_group ADD COLUMN IF NOT EXISTS update_client_use_yn VARCHAR(1) NULL DEFAULT NULL COMMENT '업데이트클라이언트 사용여부';
*/


-- 소스시퀀스 5886
/*
 * 수정사항
 * [비영리 권한관리 관련] 주부서/부부서 메뉴 권한 따로 지정시 한쪽에라도 권한이 있는 메뉴가 있으면, 모든 부서에서 조회되는 문제 수정
 * */

/*
DELIMITER $$
DROP FUNCTION IF EXISTS get_auth_group_concat$$
CREATE FUNCTION `get_auth_group_concat`(I_COMP_SEQ VARCHAR(32), I_DEPT_SEQ VARCHAR(32), I_EMP_SEQ VARCHAR(32), I_DEPT_DUTY_CODE VARCHAR(32), I_DEPT_POSITION_CODE VARCHAR(32)) RETURNS varchar(512) CHARSET utf8
    READS SQL DATA
BEGIN

	DECLARE V_RETURN 		VARCHAR(512);

	SELECT GROUP_CONCAT(A.author_code SEPARATOR  '#') AS author_code
	INTO V_RETURN
	FROM
	(
                SELECT DISTINCT CAST(author_code AS CHAR) AS author_code
		FROM `t_co_auth_relate`
		WHERE comp_seq = I_COMP_SEQ
		AND   ((author_type = '002' AND dept_seq in (
															select dept_seq
															from	(
																select concat(comp_seq,'|',path) as path from t_co_dept where dept_seq = I_DEPT_SEQ
															)	d
															inner join v_org_chart v
															on d.path like concat(v.path,  '%')
														)
				)
		    OR (author_type <> '002' AND emp_seq = I_EMP_SEQ AND CASE WHEN (SELECT ea_type FROM T_CO_COMP WHERE COMP_SEQ = I_COMP_SEQ) = 'ea' then dept_seq = I_DEPT_SEQ ELSE 1=1 end))  -- 권한 옵션에 따라 부서조건 추가 되어야함
		AND	(author_type <> '005') -- 초기 로그인시 사용하는 함수 이므로 관리자 권한을 제외
	    ) A
            INNER JOIN t_co_authcode T
            ON T.author_code = A.author_code
            AND T.author_use_yn = 'Y'
           ;
	RETURN V_RETURN;
END$$
DELIMITER ;

/*
 * 수정사항
 * [다국어설정] 공통옵션관리 -> 공통옵션값 tcmg_optionset 테이블의 옵션 이름 다국어 업데이트 쿼리
 * [다국어설정] LNB 메뉴 메뉴 이름 다국어 업데이트 쿼리
 * */
UPDATE tcmg_optionset SET option_nm_en = 'Employee Information Excel Download Permission', option_nm_jp = '社員情報エクセルダウンロード権限', option_nm_cn = '员工信息下载Excel的权利' WHERE option_id = 'cm000' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Login/Logout control', option_nm_jp = 'ログイン/ログアウト制限', option_nm_cn = '控制登录/退出' WHERE option_id = 'cm100' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Restriction of basic information, revised item', option_nm_jp = '基本情報の修正項目制限', option_nm_cn = '限制基本信息修改项目' WHERE option_id = 'cm1000' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Change for the photograph of user', option_nm_jp = '', option_nm_cn = '' WHERE option_id = 'cm1001' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Change for the signature, image of user', option_nm_jp = '', option_nm_cn = '' WHERE option_id = 'cm1002' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Change for the task in charge of user', option_nm_jp = '担当業務', option_nm_cn = '担任业务' WHERE option_id = 'cm1003' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Phone number (company)', option_nm_jp = '電話番号(会社)', option_nm_cn = '电话号码(企业)' WHERE option_id = 'cm1006' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Telephone(Home)', option_nm_jp = '電話番号(自宅)', option_nm_cn = '电话号码(家)' WHERE option_id = 'cm1007' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Address(Office)', option_nm_jp = '住所(会社)', option_nm_cn = '地址(公司)' WHERE option_id = 'cm1008' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Address(Home)', option_nm_jp = '住所(自宅）', option_nm_cn = '地址(家)' WHERE option_id = 'cm1009' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Setting for the failure of log in', option_nm_jp = '', option_nm_cn = '' WHERE option_id = 'cm101' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Fax', option_nm_jp = 'FAX番号', option_nm_cn = '传真号码' WHERE option_id = 'cm1010' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Cell phone', option_nm_jp = '携帯電話', option_nm_cn = '手机' WHERE option_id = 'cm1011' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Going public or not of anniversary', option_nm_jp = '記念日公開有無', option_nm_cn = '公开纪念日与否' WHERE option_id = 'cm1012' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Password', option_nm_jp = 'パスワード', option_nm_cn = '密码' WHERE option_id = 'cm1014' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Setting for the failure of log in', option_nm_jp = '', option_nm_cn = '' WHERE option_id = 'cm101_1' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Setting for the time of compulsory log out', option_nm_jp = '自動ログアウト時間設定', option_nm_cn = '设定强行退出时间' WHERE option_id = 'cm102' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'ERP organization chart linkage', option_nm_jp = 'ERP組織図の連動', option_nm_cn = '联动ERP组织图' WHERE option_id = 'cm1100' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Organization chart registered in group ware', option_nm_jp = 'グループウェアで組織図登録可能', option_nm_cn = '在群组系统程序中可以登录组织图' WHERE option_id = 'cm1101' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Default Value of Group Equipment ID', option_nm_jp = 'グループウェアID作成の基本値', option_nm_cn = '创建群组系统程序ID的基本值' WHERE option_id = 'cm1102' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Modify user items', option_nm_jp = 'ユーザ項目の修正', option_nm_cn = '修改用户项目' WHERE option_id = 'cm1103' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'User item correction reflect ERP', option_nm_jp = 'ユーザ項目、修正内容ERP反映', option_nm_cn = 'ERP反映用户项目的修改内容' WHERE option_id = 'cm1104' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Birthdate', option_nm_jp = '生年月日', option_nm_cn = '生年月日' WHERE option_id = 'cm1105' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Wedding anniversary', option_nm_jp = '結婚記念日', option_nm_cn = '结婚纪念日' WHERE option_id = 'cm1106' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Telephone', option_nm_jp = '電話番号', option_nm_cn = '电话号码' WHERE option_id = 'cm1107' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Home Address', option_nm_jp = '家の住所', option_nm_cn = '家庭地址' WHERE option_id = 'cm1108' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'User name', option_nm_jp = 'ユーザー名', option_nm_cn = '用户名' WHERE option_id = 'cm1109' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'E-approval', option_nm_jp = '電子決裁', option_nm_cn = '电子审批' WHERE option_id = 'cm1501' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Board', option_nm_jp = '掲示板', option_nm_cn = '留言板' WHERE option_id = 'cm1502' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Task Reports', option_nm_jp = '業務報告', option_nm_cn = '业务报告' WHERE option_id = 'cm1503' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Document', option_nm_jp = '文書', option_nm_cn = '文件' WHERE option_id = 'cm1504' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'E-approval', option_nm_jp = '電子決裁', option_nm_cn = '电子审批' WHERE option_id = 'cm1601' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Schedule', option_nm_jp = 'スケジュール', option_nm_cn = '日程' WHERE option_id = 'cm1602' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Board', option_nm_jp = '掲示板', option_nm_cn = '留言板' WHERE option_id = 'cm1603' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Document', option_nm_jp = '文書', option_nm_cn = '文件' WHERE option_id = 'cm1604' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Personnel Management', option_nm_jp = '社員管理', option_nm_cn = '对职员服务' WHERE option_id = 'cm1605' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Setting the viewing of attached file', option_nm_jp = '添付ファイルの表示設定', option_nm_cn = '设定查看附件' WHERE option_id = 'cm1700' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'E-approval', option_nm_jp = '電子決裁', option_nm_cn = '电子审批' WHERE option_id = 'cm1750_ea' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Setting rule of password', option_nm_jp = '', option_nm_cn = '' WHERE option_id = 'cm200' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Setting for the digit number of password input', option_nm_jp = 'パスワード入力桁数設定', option_nm_cn = '设定密码输入位数' WHERE option_id = 'cm202' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Setting the rules of input', option_nm_jp = '', option_nm_cn = '' WHERE option_id = 'cm203' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Setting the restricted value of input', option_nm_jp = '', option_nm_cn = '' WHERE option_id = 'cm204' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Setting the use editor', option_nm_jp = '使用エディター設定', option_nm_cn = '设定使用编辑器' WHERE option_id = 'cm300' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Uploader/Downloader Setting', option_nm_jp = '', option_nm_cn = '' WHERE option_id = 'cm400' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'DownLoader activeX Setting', option_nm_jp = 'ダウンローダーactivX設定', option_nm_cn = '下载activX设定' WHERE option_id = 'cm410' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Setting the viewing of attached file', option_nm_jp = '添付ファイルの表示設定', option_nm_cn = '设定查看附件' WHERE option_id = 'cm500' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Setting for the open of OrgaChart tree', option_nm_jp = '組織図ツリーオープン設定', option_nm_cn = '设定open组织图分支 ' WHERE option_id = 'cm600' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Expression of department information', option_nm_jp = '部署情報表示', option_nm_cn = '显示部门信息' WHERE option_id = 'cm700' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Scope the portal individual information', option_nm_jp = 'ポータルサイトの個人情報範囲', option_nm_cn = '综合个人信息领域' WHERE option_id = 'cm701' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Scope the expression of list', option_nm_jp = 'リスト表示範囲', option_nm_cn = '列表显示领域' WHERE option_id = 'cm702' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Expression of OrgaChart, business place ', option_nm_jp = '組織図の事業者の表示', option_nm_cn = '显示组织图企业' WHERE option_id = 'cm800' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Fax', option_nm_jp = 'FAX', option_nm_cn = '传真' WHERE option_id = 'pathSeq1200' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Task management', option_nm_jp = '業務管理', option_nm_cn = '业务管理' WHERE option_id = 'pathSeq300' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Schedule', option_nm_jp = 'スケジュール', option_nm_cn = '日程' WHERE option_id = 'pathSeq400' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Board', option_nm_jp = '掲示板', option_nm_cn = '留言板' WHERE option_id = 'pathSeq500' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Document', option_nm_jp = '文書', option_nm_cn = '文件' WHERE option_id = 'pathSeq600' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Mail', option_nm_jp = 'メール', option_nm_cn = '邮件' WHERE option_id = 'pathSeq700' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Chat Room', option_nm_jp = 'チャットルーム', option_nm_cn = '聊天室' WHERE option_id = 'pathSeq800' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'Message', option_nm_jp = 'メッセージ', option_nm_cn = '纸条' WHERE option_id = 'pathSeq810' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_en = 'E-approval', option_nm_jp = '電子決裁', option_nm_cn = '电子审批' WHERE option_id = 'pathSeqEa' AND module_gb LIKE 'cm';

INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1905030000, 'en', 'Project management', '프로젝트관리', NULL, NOW(), NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1905030000, 'jp', 'プロジェクト管理', '프로젝트관리', NULL, NOW(), NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1905030000, 'cn', '项目管理', '프로젝트관리', NULL, NOW(), NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1905040000, 'en', 'Management of client', '거래처관리', NULL, NOW(), NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1905040000, 'jp', '取り引き先管理', '거래처관리', NULL, NOW(), NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1905040000, 'cn', '用户管理', '거래처관리', NULL, NOW(), NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1901070000, 'jp', '官印管理', '관인관리', NULL, NOW(), NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1901070000, 'cn', '公章管理', '관인관리', NULL, NOW(), NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (901070000, 'jp', '官印管理', '관인관리', NULL, NOW(), NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (901070000, 'cn', '公章管理', '관인관리', NULL, NOW(), NULL, NULL);

------- 소스시퀀스  6042
*/



/*
 * 2019.03.26
 * 수정사항
 * [다국어] 비밀번호 변경 팝업(passwordCheckPop.jsp, EgovLoginController.java) 다국어 처리
 * [erp조직도연동] 조직도 연동 오류 수정.
 * [BizboxIndexController] : /bizboxLink.do groupSeq 못 찾을경우 에러 수정
 * [EmpManage_SQL.xml, empRegBatchPop.jsp] : 대량엑셀 입사시 입사일 VALIDATION추가
 * */

/*
ALTER TABLE t_msg_tcmg_link ADD COLUMN IF NOT EXISTS app_key varchar(32) DEFAULT NULL COMMENT '앱키' AFTER map_key;

ALTER TABLE `t_tmp_emp`
	ADD COLUMN IF NOT EXISTS `gw_update_time` VARCHAR(200) NULL DEFAULT NULL COMMENT 'erp마지막 동기화시간' AFTER `result_code`;
	
/*
 * 2019.03.28
 * 수정사항 
 * [포틀릿] 문서 포틀릿 추가
 * [포틀릿] 문서 포틀릿 더보기 링크 데이터 추가
 * */	

INSERT IGNORE INTO `t_co_portlet` (`portlet_seq`, `portlet_tp`, `position_tp`, `position_d`, `sort_d`, `portlet_nm`, `width`, `width_set`, `height`, `height_set`, `min_height`, `min_height_set`, `resize_yn`, `package_yn`, `cust_add_yn`, `iframe_yn`, `iframe_url`, `iframe_error_url`, `set_btn_yn`, `portlet_nm_en`, `portlet_nm_cn`, `portlet_nm_jp`) VALUES (36, 'cn_doc', 'cn', '1', 0, '[중]문서', 346, 278, 224, 132, 136, NULL, 'Y', 'N', 'N', 'N', NULL, NULL, 'Y', '[M] Documents', '[中] 文書', '[中] 文書');
INSERT IGNORE INTO `t_co_portlet` (`portlet_seq`, `portlet_tp`, `position_tp`, `position_d`, `sort_d`, `portlet_nm`, `width`, `width_set`, `height`, `height_set`, `min_height`, `min_height_set`, `resize_yn`, `package_yn`, `cust_add_yn`, `iframe_yn`, `iframe_url`, `iframe_error_url`, `set_btn_yn`, `portlet_nm_en`, `portlet_nm_cn`, `portlet_nm_jp`) VALUES (35, 'lr_doc', 'lr', '1', 0, '[소]문서', 228, 182, 224, 179, 136, NULL, 'Y', 'N', '', 'N', NULL, NULL, 'Y', '[S] Documents', '[小] 文書', '[小] 文書');
INSERT IGNORE INTO `t_co_portlet` (`portlet_seq`, `portlet_tp`, `position_tp`, `position_d`, `sort_d`, `portlet_nm`, `width`, `width_set`, `height`, `height_set`, `min_height`, `min_height_set`, `resize_yn`, `package_yn`, `cust_add_yn`, `iframe_yn`, `iframe_url`, `iframe_error_url`, `set_btn_yn`, `portlet_nm_en`, `portlet_nm_cn`, `portlet_nm_jp`) VALUES (37, 'top_doc', 'top', '1', 0, '[대]문서', 700, 566, 224, 272, 136, NULL, 'Y', 'N', 'N', 'N', NULL, NULL, 'Y', '[L] Documents', '[大] 文書', '[大] 文書');

INSERT IGNORE INTO `t_co_main_portlet` (`comp_seq`, `portlet_type`, `order_num`, `gnb_menu_no`, `lnb_menu_no`, `lnb_menu_gubun`, `url_path`, `error_url_path`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('0', 'DOCUMENT', 12, 600000000, 601000000, 'edms', '/edms/doc/dorDirView.do', 'mainEmptyPage.do?page=document', NULL, NULL, NULL, NULL);

*/
------- 소스시퀀스  6261



/*

/*
 * 2019.03.30
 * 수정사항
 * [다국어] 시스템 설정 메뉴 다국어 추가
 * [다국어] 공통옵션 다국어 추가 
 * */
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (210000000, 'en', 'Approved mail', '승인메일', NULL, NOW(), NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (210000000, 'jp', '承認メール', '승인메일', NULL, NOW(), NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (210000000, 'cn', '批转邮件', '승인메일', NULL, NOW(), NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1901080000, 'en', 'Groupware capacity status', '그룹웨어 용량 현황', NULL, NOW(), NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1901080000, 'jp', 'グループウェア容量の現状', '그룹웨어 용량 현황', NULL, NOW(), NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1901080000, 'cn', 'OA系统容量情况', '그룹웨어 용량 현황', NULL, NOW(), NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (914000000, 'en', '2-step verification', '이차인증', NULL, NOW(), NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (914000000, 'jp', '2段階認証', '이차인증', NULL, NOW(), NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (914000000, 'cn', '二次认证', '이차인증', NULL, NOW(), NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1909000000, 'en', '2-step verification', '이차인증', NULL, NOW(), NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1909000000, 'jp', '2段階認証', '이차인증', NULL, NOW(), NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1909000000, 'cn', '二次认证', '이차인증', NULL, NOW(), NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (913002000, 'en', 'Verification device history', '인증기기 내역', NULL, NOW(), NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (913002000, 'jp', '認証用デバイスの内訳', '인증기기 내역', NULL, NOW(), NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (913002000, 'cn', '认证设备内容', '인증기기 내역', NULL, NOW(), NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1909003000, 'en', 'Verification device history', '인증기기 내역', NULL, NOW(), NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1909003000, 'jp', '認証用デバイスの内訳', '인증기기 내역', NULL, NOW(), NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1909003000, 'cn', '认证设备内容', '인증기기 내역', NULL, NOW(), NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1909002000, 'en', 'Verification device', '인증기기 승인관리', NULL, NOW(), NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1909002000, 'jp', '認証用デバイスの承認管理', '인증기기 승인관리', NULL, NOW(), NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1909002000, 'cn', '认证设备批准管理', '인증기기 승인관리', NULL, NOW(), NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (913001000, 'en', 'Verification device', '인증기기 승인관리', NULL, NOW(), NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (913001000, 'jp', '認証用デバイスの承認管理', '인증기기 승인관리', NULL, NOW(), NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (913001000, 'cn', '认证设备批准管理', '인증기기 승인관리', NULL, NOW(), NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1920102000, 'en', 'Custom code management', '사용자정의 코드관리', NULL, NOW(), NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1920102000, 'jp', 'ユーザー定義コードの管理', '사용자정의 코드관리', NULL, NOW(), NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1920102000, 'cn', '用户定义代码管理', '사용자정의 코드관리', NULL, NOW(), NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1920103000, 'en', 'External system management', '외부시스템코드관리', NULL, NOW(), NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1920103000, 'jp', '外部システムコードの管理', '외부시스템코드관리', NULL, NOW(), NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1920103000, 'cn', '外部系统代码管理', '외부시스템코드관리', NULL, NOW(), NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1901070001, 'en', 'AD organization peristalsis settings', 'AD조직도연동설정', NULL, NOW(), NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1901070001, 'jp', 'AD組織図連動設定', 'AD조직도연동설정', NULL, NOW(), NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1901070001, 'cn', '聯鎖设置AD组织图', 'AD조직도연동설정', NULL, NOW(), NULL, NULL);

UPDATE tcmg_optionset SET option_nm_jp = '画像イメージ', option_nm_cn = '照片图像', option_desc_en = 'Users can change their profile photograph.', option_desc_cn = '用户可以修改简历照片。', option_desc_jp = 'プロフィルの写真をユーザーが変更することができます。' WHERE option_id = 'cm1001' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_desc_jp = '組織図の社員情報エクセルダウンロードは権限に応じてボタンが表示されます。', option_desc_cn = '下载组织图上的职员信息Excel是根据权限露出按钮。', option_desc_en = 'In the organization chart, the download button for employee information Excel is exposed ' WHERE option_id = 'cm000' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_jp = '共通組織図ポップアップグループの設定', option_nm_cn = '设置共同组织图弹出窗口群组', option_nm_en = 'Common organization chart popup group settings',  option_desc_en = 'Use of common organization chart popup group settings',option_desc_cn = '是否使用共同组织图弹出窗口群组设置', option_desc_jp = '共通組織図ポップアップ　グループ設定の使用有無' WHERE option_id = 'cm001' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_jp = 'ログイン失敗時にロックアウト', option_nm_cn = '登录失败锁定设置', option_nm_en = 'Lock settings by failed login settings',  option_desc_en = 'You can set the number of failures and the lock status time with the login lock settings due to failed password entry attempts. (0: no limit)',option_desc_cn = '以输入密码失败而锁定登录设置，可以设置失败次数和锁定状态时间。', option_desc_jp = 'パスワード入力失敗によるログインロック設定で失敗回数とロック時間を設定することができます。(0:制限なし)' WHERE option_id = 'cm101' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_jp = 'ログイン未接続時にロックアウト', option_nm_cn = '未登录锁定设置', option_nm_en = 'Lock settings by unassessed login',  option_desc_en = 'This option turns on login lock when there is no connection for a period of time. You can set the unconnected period to be locked (0: no limit).',option_desc_cn = '以一定时间内没有连接时转换为锁定登录状态的选项，可以设置成为锁定状态的未连接期间。(0:没有限制)', option_desc_jp = '一定期間アクセスしないとログインロック状態へと転換させるオプションでロックアウトの基準となるアクセスしてない期間を設定することができます。(0:制限なし)' WHERE option_id = 'cm101_1' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_desc_en = 'You can set the forced logout time when the login is held for a long time (by minute / 0: Not checked).', option_desc_jp = 'Webに長時間ログインする時、強制ログアウトの時間を設定することができます。(分単位入力/0:チェックしない)', option_desc_cn = '长时间登录网站时，可以设置强制性退出时间。(按分输入时间/0:不选择)' WHERE option_id = 'cm102' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_desc_en = 'You can control not to edit some of user basic information items', option_desc_jp = 'ユーザ基本情報項目を一部修正できないように設定することができます。', option_desc_cn = '用户可以控制使无法控制基本信息项目的一部分。' WHERE option_id = 'cm1000' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_desc_en = 'Users can change their signature image.', option_desc_jp = 'サインイメージをユーザーが変更することができます。', option_desc_cn = '用户可以修改签字图像。' WHERE option_id = 'cm1002' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_desc_en = 'Users can edit their messenger and profile tasks.', option_desc_jp = 'メッセンジャーおよびプロフィルの担当業務の表示項目をユーザーが修正することができます。', option_desc_cn = '用户可以修改MSN及简历担当业务显示项目。' WHERE option_id = 'cm1003' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_jp = '名前(多国語含む)', option_nm_cn = '姓名(包括多国语言)', option_nm_en = 'Name (in multiple languages)',  option_desc_en = 'Users can be prevented from editing their username at My Page > Basic Information.',option_desc_cn = '用户可以设置使无法修改我的主页〉基本信息修改菜单中的用户名。', option_desc_jp = 'マイページ > 基本情報修正メニューで,ユーザー名をユーザが修正できないように設定することができます。' WHERE option_id = 'cm1004' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_desc_en = 'Users can be prevented from editing their telephone number (company) at My Page > Basic Information.',option_desc_cn = '用户可以设置使无法修改我的主页〉基本信息修改菜单中的电话号码(公司)。', option_desc_jp = 'マイページ > 基本情報修正メニューで,電話番号(会社)の項目をユーザが修正できないように設定することができます。' WHERE option_id = 'cm1006' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_desc_en = 'Users can be prevented from editing their telephone number (home) at My Page > Basic Information.',option_desc_cn = '用户可以设置使无法修改我的主页〉基本信息修改菜单中的电话号码(家)。', option_desc_jp = 'マイページ > 基本情報修正メニューで,電話番号(自宅)の項目をユーザが修正できないように設定することができます。' WHERE option_id = 'cm1007' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_desc_en = 'Users can be prevented from editing their address (company) at My Page > Basic Information.',option_desc_cn = '用户可以设置使无法修改我的主页〉基本信息修改菜单中的地址(公司)。', option_desc_jp = 'マイページ > 基本情報修正メニューで,住所(会社)項目をユーザが修正できないように設定することができます。' WHERE option_id = 'cm1008' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_desc_en = 'Users can be prevented from editing their address (home) at My Page > Basic Information.', option_desc_cn = '用户可以设置使无法修改我的主页〉基本信息修改菜单中的地址(家)。', option_desc_jp = 'マイページ > 基本情報修正メニューで,住所(自宅)項目をユーザが修正できないように設定することができます。' WHERE option_id = 'cm1009' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_desc_en = 'Users can be prevented from editing their fax number at My Page > Basic Information.', option_desc_cn = '用户可以设置使无法修改我的主页〉基本信息修改菜单中的传真号码项目。', option_desc_jp = 'マイページ > 基本情報修正メニューで,ファクス番号の項目をユーザが修正できないように設定することができます。' WHERE option_id = 'cm1010' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_desc_en = 'Users can be prevented from editing their mobile phone number at My Page > Basic Information.', option_desc_cn = '用户可以设置使无法修改我的主页〉基本信息修改菜单中的手机项目。', option_desc_jp = 'マイページ > 基本情報修正メニューで,携帯電話項目をユーザーに修正できないように設定することができます。' WHERE option_id = 'cm1011' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_desc_en = 'Users can be prevented from editing the open of their anniversary dates at My Page > Basic Information.', option_desc_cn = '用户可以设置使无法修改我的主页〉基本信息修改菜单中的是否公开纪念日项目。', option_desc_jp = 'マイページ > 基本情報修正メニューで,記念日公開の有無の項目をユーザが修正できないように設定することができます。' WHERE option_id = 'cm1012' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_jp = '個人メール', option_nm_cn = '个人邮件', option_nm_en = 'Private email',  option_desc_en = 'Users can be prevented from editing their email address at My Page > Basic Information.',option_desc_cn = '用户可以设置使无法修改我的主页〉基本信息修改菜单中的个人邮件项目。', option_desc_jp = 'マイページ > 基本情報修正メニューで,個人メールの項目をユーザーが修正できないように設定することができます。' WHERE option_id = 'cm1013' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_desc_en = 'Users can be prevented from editing their password at My Page > Basic Information. (Setting when interlinking password verification externally)', option_desc_cn = '用户可以设置使无法修改我的主页〉基本信息修改菜单中的密码项目。(与外部联动密码认证时设置)', option_desc_jp = 'マイページ > 基本情報修正メニューでパスワード項目をユーザが修正できないように設定できます(パスワード認証外部連動時に設定)。' WHERE option_id = 'cm1014' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_desc_en = 'As a download restriction function of attachments, you can set up attachment download, or document viewer by module [File extensions provided as viewer: bmp, gif, jpeg, jpg, png, hwp, doc, docx, ppt, pptx, xls, xlsx, and pdf].', option_desc_cn = '以限制下载附件功能，通过下载附件或者文件阅览器，可以按模块设置快捷键功能。[阅览器提供的文件扩展名： bmp, gif, jpeg, jpg, png, hwp, doc, docx, ppt, pptx, xls, xlsx, pdf]', option_desc_jp = '添付ファイルダウンロード制限機能で,添付されたファイルをダウンロードまたは文書ビューアのすぐ表示機能をモジュール別に設定することができます。 [ビューローで提供されるファイル拡張者: bmp, gif, jpg, jpg, png, hwp, doc, docx, ppt, pptx, xls, xlsx, pdf]' WHERE option_id = 'cm1700' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_jp = 'お気に入りの削除有無', option_nm_cn = '是否删除收藏', option_nm_en = 'Deletion of favorites',  option_desc_en = 'Deletion of favorites', option_desc_cn = '是否删除收藏', option_desc_jp = 'お気に入りの削除有無' WHERE option_id = 'com210' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_jp = 'メール受信のお知らせ　受信者設定', option_nm_cn = '设置接收邮件提醒的人', option_nm_en = 'Mail notification receiver settings',  option_desc_en = 'Mail notification receiver settings', option_desc_cn = '设置接收邮件提醒的人', option_desc_jp = 'メール受信のお知らせ　受信者設定' WHERE option_id = 'cm900' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_jp = 'カスタムオプション(使用なし）', option_nm_cn = '指定选项(未使用)', option_nm_en = 'Custom options (unused)',  option_desc_en = 'Decide whether or not to show all the paths of uploaded attachments.', option_desc_cn = '设置是否显示附件的上传路径。', option_desc_jp = 'アップロードする添付ファイルの経路の表示有無を設定します。' WHERE option_id = 'cm411' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_desc_en = 'Set whether or not to use activX when using the downloader.', option_desc_cn = '设置使用下载时是否使用activX。', option_desc_jp = 'ダウンローダの使用時,activXの使用有無を設定します。' WHERE option_id = 'cm410' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_desc_en = 'Set up the uploader to use.', option_desc_cn = '设置要使用的上传。', option_desc_jp = '使用するアップロードを設定します。' WHERE option_id = 'cm400' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_desc_en = 'The Douzone Web Editor and the DEXT5 Editor provide both Windows built-in fonts and size/line spacing.', option_desc_cn = 'douzone网络编成和DEXT5编成上提供所有window基本提供的字体及尺寸/间隔等。', option_desc_jp = 'ザ・ゾーン・ウェブエディターとDEXT5エディターで提供するウィンドウの基本フォント、およびサイズ/行間隔すべてを提供します。' WHERE option_id = 'cm300' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_jp = 'プロフィール生年月日の表示設定', option_nm_cn = '设置显示简历生年月日', option_nm_en = 'Profile birthdate display settings',  option_desc_en = 'You can set the display of birthdate for your profile, and it will be displayed on your Messenger/Mobile profile as well (You should save your birthdate at My Page> Basic Information).', option_desc_cn = '可以设置显示简历的生年月日，在MSN/手机上也会同样显示。(但，主页〉基本信息菜单上必须保存生年月日)', option_desc_jp = 'プロフィールの生年月日表示の設定ができ,メッセンジャー/モバイルプロフィールにも同様に表示されます。(但し,マイページ > 基本情報メニューに生年月日が保存されている場合に限ります。)' WHERE option_id = 'cm2200' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_jp = '基本情報の必須入力項目設定', option_nm_cn = '设置基本信息必须输入项目', option_nm_en = 'Required basic information entry settings',  option_desc_en = 'You can set up the items that users enter their information as mandatory at My Page > Edit Basic Information.', option_desc_cn = '在主页〉基本信息修改菜单中可以设置为让用户必须输入项目。', option_desc_jp = 'マイページ > 基本情報修正メニューで,ユーザーが必須入力できる項目を設定することができます。' WHERE option_id = 'cm2000' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_jp = 'ID/パスワード設定規則', option_nm_cn = '用户名/密码设置规定', option_nm_en = 'ID/password setting rules', option_desc_en = 'You can set restrictions on password expiration, entry rules, and so on. In this case, you can also set detailed options.', option_desc_cn = '可以设置对密码期限、输入规则等的限制，使用时可以设置详细选项。', option_desc_jp = 'パスワードの期限設定,入力規則などの制限設定をすることができます。 使用する場合,詳細オプションを設定することができます。' WHERE option_id = 'cm200' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_jp = 'メイン·ポータルで統合検査表示の使用有無', option_nm_cn = '是否露出主页综合搜索', option_nm_en = 'Exposure of main portal integrated search', option_desc_en = 'Set whether or not to expose integrated search on the main portal site.', option_desc_cn = '设置是否露出主页综合搜索。', option_desc_jp = 'メインポータル統合検索の表示有無を設定します。' WHERE option_id = 'cm1800' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_nm_jp = 'イメージの事前表示の使用有無', option_nm_cn = '是否使用预览图像', option_nm_en = 'Use of image preview', option_desc_en = 'When attaching image files to comments, you can enable or disable the preview.', option_desc_cn = '附上回复的图像文件时，可以设置是否使用预览。', option_desc_jp = 'コメントにイメージファイルを添付する場合,プレビューの使用有無を設定することができます。' WHERE option_id = 'cm1751_ea' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_desc_en = 'You can set comments in the e-approval menu as the Basic, Basic (Profile), or Interactive type.', option_desc_cn = '电子审批菜单的回复可以设置为基本型、基本型(简历)、对话型等类型。', option_desc_jp = '電子決裁メニューのコメントを基本型,基本型(プロフィール),会話型タイプに設定することができます。' WHERE option_id = 'cm1750_ea' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_desc_en = 'You can set the type of comment by menu.', option_desc_cn = '对回复可以按菜单设置类型。', option_desc_jp = 'メニュー別にコメントのタイプを設定することができます。' WHERE option_id = 'cm1750' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_desc_en = 'You can download attachments from the business management menu, or use the document viewer to check the content.', option_desc_cn = '通过下载业务管理菜单上的附件或者文件阅览器，可以使用快捷键功能。', option_desc_jp = '業務管理メニューの添付ファイルのダウンロードまたは文書ビューアによるすぐ表示機能を使用することができます。' WHERE option_id = 'pathSeq300' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_desc_en = 'You can download attachments from the schedule menu, or use the document viewer to check the content.', option_desc_cn = '通过下载一定菜单上的附件或者文件阅览器，可以使用快捷键功能。', option_desc_jp = '日程メニューの添付ファイルのダウンロード,または文書ビューアーによるすぐ表示機能を使用することができます。' WHERE option_id = 'pathSeq400' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_desc_en = 'You can download attachment from the board menu, or use the document viewer to check the content.', option_desc_cn = '通过下载留言板菜单上的附件或者文件阅览器，可以使用快捷键功能。', option_desc_jp = '掲示板メニューの添付ファイルのダウンロード,または文書ビューアーによるすぐ表示機能を使用することができます。' WHERE option_id = 'pathSeq600' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_desc_en = 'You can download attachments from the document menu, or use the document viewer to check the content.', option_desc_cn = '通过下载文件菜单上的附件或者文件阅览器，可以使用快捷键功能。', option_desc_jp = '文書メニューの添付ファイルのダウンロード,または文書ビューアーによるすぐ表示機能を使用することができます。' WHERE option_id = 'pathSeq600' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_desc_en = 'You can download attachment from the mail menu, or use the document viewer to check the content.', option_desc_cn = '通过下载邮件菜单上的附件或者文件阅览器，可以使用快捷键功能。', option_desc_jp = 'メールメニューの添付ファイルのダウンロード,または文書ビューアーによるすぐ表示機能を使用することができます。' WHERE option_id = 'pathSeq700' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_desc_en = 'You can download attachment from chat rooms, or use the document viewer to check the content.', option_desc_cn = '通过聊天室上下载附件或者文件阅览器，可以使用快捷键功能。', option_desc_jp = 'チャットルームで添付ファイルのダウンロード,または文書ビューアーによるすぐ表示機能を使用することができます。' WHERE option_id = 'pathSeq800' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_desc_en = 'You can download attachments from messages, or use the document viewer to check the content.', option_desc_cn = '通过纸条上下载附件或者文件阅览器，可以使用快捷键功能。', option_desc_jp = 'メッセージで添付ファイルのダウンロード,または文書ビューアーによるすぐ表示機能を使用することができます。' WHERE option_id = 'pathSeq810' AND module_gb LIKE 'cm';
UPDATE tcmg_optionset SET option_desc_en = 'You can download attachment from e-approval, or use the document viewer to check the content.', option_desc_cn = '通过电子审批上下载附件或者文件阅览器，可以使用快捷键功能。', option_desc_jp = '電子決裁で添付ファイルのダウンロード,または文書ビューアによるすぐ表示機能を使用することができます。' WHERE option_id = 'pathSeqEa' AND module_gb LIKE 'cm';

INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('0', 'option0098', 'en', 'Company mail', NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('0', 'option0098', 'jp', '会社のメール', NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('0', 'option0098', 'cn', '公司邮件', NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('1', 'option0098', 'en', 'Personal mail', NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('1', 'option0098', 'jp', '個人のメール', NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('1', 'option0098', 'cn', '个人邮件', NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('a', 'option0084', 'en', 'Photo', NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('a', 'option0084', 'jp', '写真', NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('a', 'option0084', 'cn', '照片', NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('b', 'option0084', 'en', 'Signature', NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('b', 'option0084', 'jp', 'サイン', NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('b', 'option0084', 'cn', '签名', NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('c', 'option0084', 'en', 'Roles & Responsibilities', NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('c', 'option0084', 'jp', '担当業務', NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('c', 'option0084', 'cn', '担任业务', NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('d', 'option0084', 'en', 'Name', NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('d', 'option0084', 'jp', '名前', NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('d', 'option0084', 'cn', '姓名', NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('f', 'option0084', 'en', 'Phone number (company)', NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('f', 'option0084', 'jp', '電話番号(会社)', NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('f', 'option0084', 'cn', '电话号码(企业)', NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('g', 'option0084', 'en', 'Telephone(Home)', NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('g', 'option0084', 'jp', '電話番号(自宅)', NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('g', 'option0084', 'cn', '电话号码(家)', NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('h', 'option0084', 'en', 'Address(Office)', NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('h', 'option0084', 'jp', '住所(会社)', NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('h', 'option0084', 'cn', '地址(公司)', NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('i', 'option0084', 'en', 'Address(Home)', NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('i', 'option0084', 'jp', '住所(自宅）', NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('i', 'option0084', 'cn', '地址(家)', NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('j', 'option0084', 'en', 'Fax', NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('j', 'option0084', 'jp', 'FAX番号', NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('j', 'option0084', 'cn', '传真号码', NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('k', 'option0084', 'en', 'Cell phone', NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('k', 'option0084', 'jp', '携帯電話', NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('k', 'option0084', 'cn', '手机', NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('l', 'option0084', 'en', 'Personal mail', NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('l', 'option0084', 'jp', '個人のメール', NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('l', 'option0084', 'cn', '个人邮件', NULL, 'Y', NULL, NULL, NULL, NULL);



ALTER TABLE t_co_ldap_emp ADD COLUMN IF NOT EXISTS erp_emp_seq varchar(32);
update t_co_ldap_emp set erp_emp_seq = '' where erp_emp_seq is null;

------------------  소스시퀀스 : 6309

*/
/*
/*
 * 2019.04.03
 * 수정사항
 * [포틀릿] [소] 문서 포틀릿 속성값 변경
 * */
UPDATE t_co_portlet SET cust_add_yn = 'Y' WHERE portlet_seq = '35';

*/

/*
 * 2019.04.05
 * 수정사항
 * [원피스] 사용자 동의 기능 구현에 따른API 수정.
 * [원피스] 원피스 메뉴 배포 
 * [시스템설정] ERP조직도연동 안정화 작업.
 * */
/*
ALTER TABLE `oneffice_user_env` ADD COLUMN IF NOT EXISTS `user_agree` CHAR(1) NOT NULL DEFAULT 'Y' AFTER `user_id`;
ALTER TABLE `oneffice_user_env` ADD COLUMN IF NOT EXISTS `user_agree_date` DATETIME DEFAULT NULL AFTER `user_agree`;

ALTER TABLE `t_tmp_emp` ADD COLUMN IF NOT EXISTS `row_num` VARCHAR(200) NULL DEFAULT NULL COMMENT '동기화순서' AFTER `gw_update_time`;


INSERT IGNORE INTO `t_co_menu` (`comp_seq`, `menu_gubun`, `menu_no`, `upper_menu_no`, `menu_ordr`, `use_yn`, `url_gubun`, `url_path`, `sso_use_yn`, `menu_depth`, `menu_img_path`, `menu_img_class`, `menu_type`, `create_seq`, `create_date`, `modify_seq`, `modify_date`, `public_yn`, `delete_yn`, `open_menu_no`) VALUES ('100084', 'ONEFFICE', 1, 0, 1, 'Y', 'link_pop', '/gw/oneffice/index.html', 'N', 1, NULL, 'of', NULL, 'SYSTEM', NOW(), NULL, null, 'Y', NULL, NULL);
INSERT IGNORE INTO `t_co_menu_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1, 'kr', 'ONEFFICE', '', 'SYSTEM', NOW(), NULL, null);


insert ignore into t_msg_tcmg_link
(link_seq, link_upper_seq, link_position, group_seq, comp_seq, link_kind, link_nm_kr, link_nm_en, link_nm_jp, link_nm_cn, menu_no, gnb_menu_no, lnb_menu_no, msg_target, target_url, link_param, encrypt_seq, map_key, app_key, use_yn, icon_nm, icon_path, icon_ver, order_num, create_seq, create_date, modify_seq, modify_date) VALUES
('ONEFFICE', '0', 'L', 'varGroupId', '0', 'I', 'ONEFFICE', '', ' ', ' ', 1, '', '', 'out_link', '/gw/MsgLogOn.do', '/oneffice/index.html', '0', ' ', 'oneffice', 'Y', 'btn_left_oneffice_normal.png', '/gw/Images/msg/btn_left_oneffice_normal.png', '4', 12, 'SYSTEM', NOW(), 'SYSTEM', NOW());

insert ignore into t_msg_tcmg_link(link_seq, link_upper_seq, link_position, group_seq, comp_seq, link_kind, link_nm_kr, link_nm_en, link_nm_jp, link_nm_cn, menu_no, gnb_menu_no, lnb_menu_no, msg_target, target_url, link_param, encrypt_seq, map_key, app_key, use_yn, icon_nm, icon_path, icon_ver, order_num, create_seq, create_date, modify_seq, modify_date)
select
concat(b.comp_seq, '_', a.link_seq), a.link_upper_seq, a.link_position, b.group_seq, b.comp_seq, a.link_kind, a.link_nm_kr, a.link_nm_en, a.link_nm_jp, a.link_nm_cn, a.menu_no, a.gnb_menu_no, a.lnb_menu_no, a.msg_target, a.target_url, a.link_param, a.encrypt_seq, a.map_key, a.app_key, a.use_yn, a.icon_nm, a.icon_path, a.icon_ver, a.order_num, a.create_seq, a.create_date, a.modify_seq, a.modify_date
from 
t_msg_tcmg_link a
join t_co_comp b on 1=1
left join t_msg_tcmg_link c on a.link_nm_kr = c.link_nm_kr and b.comp_seq = c.comp_seq
where c.comp_seq is null and a.link_seq = 'ONEFFICE';

insert ignore into t_co_menu_auth(menu_no, author_code)
select 1, a.author_code from t_co_authcode a
left join t_co_menu_auth m on a.author_code = m.author_code and m.menu_no = 1 
where a.author_base_yn = 'Y' and m.author_code is null;
*/

------------------  소스시퀀스 : 6468

/*
 * 수정사항
 * [시스템설정] 마스터권한 > 시스템설정 > 그룹정보관리 그룹웨어 업데이트기능 추가 
 * [포틀릿] 일정포틀릿 더보기 버튼 기능 추가.
 * [클라우드] 클라우드 공지사항 팝업 UI개선.
 * [통합검색] 원피스 검색 추가
 * [시스템설정] 항목 저장 시 오류 수정 키 길이 제한으로 인한 Validation 추가
 * [원피스] 원피스 메뉴 배포
 * [메뉴] 일정/업무관리 마스터메뉴 추가
 * */

/*
ALTER TABLE `t_co_org_img` DROP PRIMARY KEY, ADD PRIMARY KEY (`org_seq`, `img_type`, `os_type`, `app_type`, `disp_type`, `ph_type`);


DELIMITER $$

USE `neos`$$

DROP TRIGGER IF EXISTS `TRG_ONEFFICE_DOCUMENT_AD`$$

CREATE
    /*!50017 DEFINER = 'neos'@'%' */
    TRIGGER `TRG_ONEFFICE_DOCUMENT_AD` AFTER DELETE ON `oneffice_document` 
    FOR EACH ROW BEGIN
	INSERT INTO t_se_job	(event_date, job_type, pk_Seq, iud_type)
	VALUES
	(NOW(), 'oneffice-1', OLD.doc_no, 'D');
END;
$$

DELIMITER ;

DELIMITER $$

USE `neos`$$

DROP TRIGGER IF EXISTS `TRG_ONEFFICE_DOCUMENT_AI`$$

CREATE
    /*!50017 DEFINER = 'neos'@'%' */
    TRIGGER `TRG_ONEFFICE_DOCUMENT_AI` AFTER INSERT ON `oneffice_document` 
    FOR EACH ROW BEGIN
	INSERT INTO t_se_job	(event_date, job_type, pk_Seq, iud_type)
	VALUES
	(NOW(), 'oneffice-1', NEW.doc_no, 'I');
END;
$$

DELIMITER ;


DELIMITER $$

USE `neos`$$

DROP TRIGGER IF EXISTS `TRG_ONEFFICE_DOCUMENT_AU`$$

CREATE
    /*!50017 DEFINER = 'neos'@'%' */
    TRIGGER `TRG_ONEFFICE_DOCUMENT_AU` AFTER UPDATE ON `oneffice_document` 
    FOR EACH ROW BEGIN
	INSERT INTO t_se_job	(event_date, job_type, pk_Seq, iud_type)
	VALUES
	(NOW(), 'oneffice-1', NEW.doc_no, 'U');
END;
$$

DELIMITER ;


DELIMITER $$

USE `neos`$$

DROP TRIGGER IF EXISTS `TRG_ONEFFICE_SHARE_AD`$$

CREATE
    /*!50017 DEFINER = 'neos'@'%' */
    TRIGGER `TRG_ONEFFICE_SHARE_AD` AFTER DELETE ON `oneffice_share` 
    FOR EACH ROW BEGIN
	INSERT INTO t_se_job	(event_date, job_type, pk_Seq, iud_type)
	VALUES
	(NOW(), 'oneffice-1', OLD.doc_no, 'D');
END;
$$

DELIMITER ;


DELIMITER $$

USE `neos`$$

DROP TRIGGER IF EXISTS `TRG_ONEFFICE_SHARE_AI`$$

CREATE
    /*!50017 DEFINER = 'neos'@'%' */
    TRIGGER `TRG_ONEFFICE_SHARE_AI` AFTER INSERT ON `oneffice_share` 
    FOR EACH ROW BEGIN
	INSERT INTO t_se_job	(event_date, job_type, pk_Seq, iud_type)
	VALUES
	(NOW(), 'oneffice-1', NEW.doc_no, 'I');
END;
$$

DELIMITER ;


DELIMITER $$

USE `neos`$$

DROP TRIGGER IF EXISTS `TRG_ONEFFICE_SHARE_AU`$$

CREATE
    /*!50017 DEFINER = 'neos'@'%' */
    TRIGGER `TRG_ONEFFICE_SHARE_AU` AFTER UPDATE ON `oneffice_share` 
    FOR EACH ROW BEGIN
	INSERT INTO t_se_job	(event_date, job_type, pk_Seq, iud_type)
	VALUES
	(NOW(), 'oneffice-1', NEW.doc_no, 'U');
END;
$$

DELIMITER ;


UPDATE t_co_menu SET delete_yn = null WHERE menu_no = '1';
UPDATE t_msg_tcmg_link SET use_yn = 'Y' WHERE link_nm_kr = 'oneffice';

insert ignore into t_co_menu_auth(menu_no, author_code)
select 1, a.author_code from t_co_authcode a
left join t_co_menu_auth m on a.author_code = m.author_code and m.menu_no = 1 
where a.author_base_yn = 'Y' and m.author_code is null;

INSERT IGNORE INTO `t_co_code_detail` (`detail_code`, `code`, `ischild`, `order_num`, `flag_1`, `flag_2`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('ONEFFICE', 'MENU', 'N', 0, NULL, NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('ONEFFICE', 'MENU', 'kr', 'ONEFFICE', NULL, 'Y', NULL, NULL, NULL, NULL);

INSERT IGNORE INTO `t_co_menu_adm` (`menu_no`, `menu_gubun`, `upper_menu_no`, `menu_ordr`, `use_yn`, `url_gubun`, `url_path`, `sso_use_yn`, `menu_depth`, `menu_img_class`, `create_seq`, `create_date`, `modify_seq`, `modify_date`, `menu_adm_gubun`, `menu_auth_type`, `public_yn`, `delete_yn`) VALUES (1400000000, 'MENU004', 1, 1400000000, 'Y', 'project', '', 'N', 1, 'wk', NULL, NULL, NULL, NULL, 'MENU004', 'MASTER', 'Y', NULL);
INSERT IGNORE INTO `t_co_menu_adm` (`menu_no`, `menu_gubun`, `upper_menu_no`, `menu_ordr`, `use_yn`, `url_gubun`, `url_path`, `sso_use_yn`, `menu_depth`, `menu_img_class`, `create_seq`, `create_date`, `modify_seq`, `modify_date`, `menu_adm_gubun`, `menu_auth_type`, `public_yn`, `delete_yn`) VALUES (1401000000, 'MENU004', 1400000000, 1401000000, 'Y', 'project', '', 'N', 2, NULL, NULL, NULL, NULL, NULL, 'MENU004', 'MASTER', 'Y', NULL);
INSERT IGNORE INTO `t_co_menu_adm` (`menu_no`, `menu_gubun`, `upper_menu_no`, `menu_ordr`, `use_yn`, `url_gubun`, `url_path`, `sso_use_yn`, `menu_depth`, `menu_img_class`, `create_seq`, `create_date`, `modify_seq`, `modify_date`, `menu_adm_gubun`, `menu_auth_type`, `public_yn`, `delete_yn`) VALUES (1401020000, 'MENU004', 1401000000, 1401020000, 'Y', 'project', '/Views/Common/admin/groupManage', 'N', 3, NULL, NULL, NULL, '9912', '2017-04-04 20:20:28', 'MENU004', 'MASTER', 'Y', NULL);
INSERT IGNORE INTO `t_co_menu_adm` (`menu_no`, `menu_gubun`, `upper_menu_no`, `menu_ordr`, `use_yn`, `url_gubun`, `url_path`, `sso_use_yn`, `menu_depth`, `menu_img_class`, `create_seq`, `create_date`, `modify_seq`, `modify_date`, `menu_adm_gubun`, `menu_auth_type`, `public_yn`, `delete_yn`) VALUES (1402000000, 'MENU004', 1400000000, 1402000000, 'Y', 'project', '', 'N', 2, NULL, NULL, NULL, NULL, NULL, 'MENU004', 'MASTER', 'Y', NULL);
INSERT IGNORE INTO `t_co_menu_adm` (`menu_no`, `menu_gubun`, `upper_menu_no`, `menu_ordr`, `use_yn`, `url_gubun`, `url_path`, `sso_use_yn`, `menu_depth`, `menu_img_class`, `create_seq`, `create_date`, `modify_seq`, `modify_date`, `menu_adm_gubun`, `menu_auth_type`, `public_yn`, `delete_yn`) VALUES (1402010000, 'MENU004', 1402000000, 1402010000, 'Y', 'gw', '/cmm/systemx/alarm/moduleAlarm.do?codeValue=PROJECT', 'N', 3, NULL, NULL, NULL, '3899', '2016-07-27 14:56:43', 'MENU004', 'MASTER', 'Y', NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1400000000, 'cn', '业务管理', NULL, 'SYSTEM', '2017-06-28 14:30:49', 'SYSTEM', '2017-06-28 14:30:49');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1400000000, 'en', 'Task management', NULL, 'SYSTEM', '2016-12-27 11:57:58', NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1400000000, 'jp', '業務管理', NULL, 'SYSTEM', '2017-06-28 14:30:29', 'SYSTEM', '2017-06-28 14:30:29');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1400000000, 'kr', '업무관리', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1401000000, 'cn', '业务管理', NULL, 'SYSTEM', '2017-06-28 14:30:49', 'SYSTEM', '2017-06-28 14:30:49');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1401000000, 'en', 'Task management', NULL, 'SYSTEM', '2016-12-27 11:57:58', NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1401000000, 'jp', '業務管理', NULL, 'SYSTEM', '2017-06-28 14:30:29', 'SYSTEM', '2017-06-28 14:30:29');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1401000000, 'kr', '업무관리', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1401020000, 'en', 'Project management', '', 'SYSTEM', '2016-12-27 11:57:54', '9912', '2017-04-04 20:20:28');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1401020000, 'kr', '프로젝트 업무관리', '', NULL, NULL, '9912', '2017-04-04 20:20:28');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1402000000, 'cn', '选项管理', NULL, 'SYSTEM', '2017-06-28 14:30:44', 'SYSTEM', '2017-06-28 14:30:44');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1402000000, 'en', 'Option management', NULL, 'SYSTEM', '2016-12-27 11:57:53', NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1402000000, 'jp', 'オプション管理', NULL, 'SYSTEM', '2017-06-28 14:30:25', 'SYSTEM', '2017-06-28 14:30:25');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1402000000, 'kr', '옵션관리', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1402010000, 'cn', '设定通知', NULL, 'SYSTEM', '2017-06-28 14:30:46', 'SYSTEM', '2017-06-28 14:30:46');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1402010000, 'en', 'Set notification', NULL, 'SYSTEM', '2016-12-27 11:57:56', NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1402010000, 'jp', 'お知らせ設定', NULL, 'SYSTEM', '2017-06-28 14:30:27', 'SYSTEM', '2017-06-28 14:30:27');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1402010000, 'kr', '알림설정', '', NULL, NULL, '3899', '2016-07-27 14:56:43');
INSERT IGNORE INTO `t_co_menu_adm` (`menu_no`, `menu_gubun`, `upper_menu_no`, `menu_ordr`, `use_yn`, `url_gubun`, `url_path`, `sso_use_yn`, `menu_depth`, `menu_img_class`, `create_seq`, `create_date`, `modify_seq`, `modify_date`, `menu_adm_gubun`, `menu_auth_type`, `public_yn`, `delete_yn`) VALUES (1300000000, 'MENU003', 1, 1300000000, 'Y', 'schedule', '', 'N', 1, 'sc', NULL, NULL, NULL, NULL, 'MENU003', 'MASTER', 'Y', NULL);
INSERT IGNORE INTO `t_co_menu_adm` (`menu_no`, `menu_gubun`, `upper_menu_no`, `menu_ordr`, `use_yn`, `url_gubun`, `url_path`, `sso_use_yn`, `menu_depth`, `menu_img_class`, `create_seq`, `create_date`, `modify_seq`, `modify_date`, `menu_adm_gubun`, `menu_auth_type`, `public_yn`, `delete_yn`) VALUES (1301000000, 'MENU003', 1300000000, 1301000000, 'Y', '', '', 'N', 2, NULL, NULL, NULL, '3971', '2016-10-06 15:09:16', 'MENU003', 'MASTER', 'Y', NULL);
INSERT IGNORE INTO `t_co_menu_adm` (`menu_no`, `menu_gubun`, `upper_menu_no`, `menu_ordr`, `use_yn`, `url_gubun`, `url_path`, `sso_use_yn`, `menu_depth`, `menu_img_class`, `create_seq`, `create_date`, `modify_seq`, `modify_date`, `menu_adm_gubun`, `menu_auth_type`, `public_yn`, `delete_yn`) VALUES (1301020000, 'MENU003', 1301000000, 1301020000, 'Y', 'schedule', '/Views/Common/mCalendarManage/mCalendarManage', 'N', NULL, NULL, '3971', '2016-10-06 15:11:07', '707010014690', '2019-01-22 09:26:00', 'MENU003', 'MASTER', 'Y', NULL);
INSERT IGNORE INTO `t_co_menu_adm` (`menu_no`, `menu_gubun`, `upper_menu_no`, `menu_ordr`, `use_yn`, `url_gubun`, `url_path`, `sso_use_yn`, `menu_depth`, `menu_img_class`, `create_seq`, `create_date`, `modify_seq`, `modify_date`, `menu_adm_gubun`, `menu_auth_type`, `public_yn`, `delete_yn`) VALUES (1301070000, 'MENU003', 1301000000, 1301070000, 'Y', 'schedule', '/Views/Common/mCalendarManage/googleClient', 'N', NULL, NULL, '3971', '2016-10-06 15:11:07', '4498', '2019-02-22 13:37:44', 'MENU003', 'MASTER', 'Y', NULL);
INSERT IGNORE INTO `t_co_menu_adm` (`menu_no`, `menu_gubun`, `upper_menu_no`, `menu_ordr`, `use_yn`, `url_gubun`, `url_path`, `sso_use_yn`, `menu_depth`, `menu_img_class`, `create_seq`, `create_date`, `modify_seq`, `modify_date`, `menu_adm_gubun`, `menu_auth_type`, `public_yn`, `delete_yn`) VALUES (1302000000, 'MENU003', 1300000000, 1302000000, 'Y', '', '', 'N', 2, NULL, NULL, NULL, NULL, NULL, 'MENU003', 'MASTER', 'Y', NULL);
INSERT IGNORE INTO `t_co_menu_adm` (`menu_no`, `menu_gubun`, `upper_menu_no`, `menu_ordr`, `use_yn`, `url_gubun`, `url_path`, `sso_use_yn`, `menu_depth`, `menu_img_class`, `create_seq`, `create_date`, `modify_seq`, `modify_date`, `menu_adm_gubun`, `menu_auth_type`, `public_yn`, `delete_yn`) VALUES (1302040000, 'MENU003', 1302000000, 1302040000, 'Y', 'schedule', '/Views/Common/mCalendarManage/gbnManager', 'N', NULL, NULL, '3971', '2016-10-06 10:22:44', '707010014690', '2019-01-22 09:26:09', 'MENU003', 'MASTER', 'Y', NULL);
INSERT IGNORE INTO `t_co_menu_adm` (`menu_no`, `menu_gubun`, `upper_menu_no`, `menu_ordr`, `use_yn`, `url_gubun`, `url_path`, `sso_use_yn`, `menu_depth`, `menu_img_class`, `create_seq`, `create_date`, `modify_seq`, `modify_date`, `menu_adm_gubun`, `menu_auth_type`, `public_yn`, `delete_yn`) VALUES (1302050000, 'MENU003', 1302000000, 1302050000, 'Y', 'schedule', '/Views/Common/mCalendarManage/manager', 'N', NULL, NULL, '3971', '2016-10-06 10:23:17', '707010014690', '2019-01-22 09:26:18', 'MENU003', 'MASTER', 'Y', NULL);
INSERT IGNORE INTO `t_co_menu_adm` (`menu_no`, `menu_gubun`, `upper_menu_no`, `menu_ordr`, `use_yn`, `url_gubun`, `url_path`, `sso_use_yn`, `menu_depth`, `menu_img_class`, `create_seq`, `create_date`, `modify_seq`, `modify_date`, `menu_adm_gubun`, `menu_auth_type`, `public_yn`, `delete_yn`) VALUES (1302060000, 'MENU003', 1302000000, 1302060000, 'Y', 'schedule', '/Views/Common/resource/approvalManage', 'N', NULL, NULL, '3971', '2016-10-06 10:24:07', '707010014690', '2019-01-22 09:26:26', 'MENU003', 'MASTER', 'Y', NULL);
INSERT IGNORE INTO `t_co_menu_adm` (`menu_no`, `menu_gubun`, `upper_menu_no`, `menu_ordr`, `use_yn`, `url_gubun`, `url_path`, `sso_use_yn`, `menu_depth`, `menu_img_class`, `create_seq`, `create_date`, `modify_seq`, `modify_date`, `menu_adm_gubun`, `menu_auth_type`, `public_yn`, `delete_yn`) VALUES (1302070000, 'MENU003', 1302000000, 1302070000, 'Y', 'schedule', '/Views/Common/resource/calendar', 'N', NULL, NULL, '9871', '2016-10-22 18:36:00', '707010014690', '2019-01-22 09:26:35', 'MENU003', 'MASTER', 'Y', NULL);
INSERT IGNORE INTO `t_co_menu_adm` (`menu_no`, `menu_gubun`, `upper_menu_no`, `menu_ordr`, `use_yn`, `url_gubun`, `url_path`, `sso_use_yn`, `menu_depth`, `menu_img_class`, `create_seq`, `create_date`, `modify_seq`, `modify_date`, `menu_adm_gubun`, `menu_auth_type`, `public_yn`, `delete_yn`) VALUES (1303000000, 'MENU003', 1300000000, 1305000000, 'Y', 'schedule', '', 'N', 2, NULL, NULL, NULL, '3971', '2016-10-06 15:08:14', 'MENU003', 'MASTER', 'Y', NULL);
INSERT IGNORE INTO `t_co_menu_adm` (`menu_no`, `menu_gubun`, `upper_menu_no`, `menu_ordr`, `use_yn`, `url_gubun`, `url_path`, `sso_use_yn`, `menu_depth`, `menu_img_class`, `create_seq`, `create_date`, `modify_seq`, `modify_date`, `menu_adm_gubun`, `menu_auth_type`, `public_yn`, `delete_yn`) VALUES (1303010000, 'MENU003', 1303000000, 1303010000, 'Y', 'gw', '/cmm/systemx/alarm/moduleAlarm.do?codeValue=SCHEDULE', 'N', 3, NULL, NULL, NULL, NULL, NULL, 'MENU003', 'MASTER', 'Y', NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1300000000, 'cn', '日程管理', NULL, 'SYSTEM', '2017-06-28 14:30:51', 'SYSTEM', '2017-06-28 14:30:51');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1300000000, 'en', 'Calendar', NULL, 'SYSTEM', '2016-12-27 11:57:42', NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1300000000, 'jp', '日程管理', NULL, 'SYSTEM', '2017-06-28 14:30:31', 'SYSTEM', '2017-06-28 14:30:31');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1300000000, 'kr', '일정관리', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1301000000, 'cn', '日程管理', NULL, 'SYSTEM', '2017-06-28 14:30:51', 'SYSTEM', '2017-06-28 14:30:51');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1301000000, 'en', 'Calendar', NULL, 'SYSTEM', '2016-12-27 11:57:42', NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1301000000, 'jp', '日程管理', NULL, 'SYSTEM', '2017-06-28 14:30:31', 'SYSTEM', '2017-06-28 14:30:31');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1301000000, 'kr', '일정관리', '', NULL, NULL, '3971', '2016-10-06 15:09:16');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1301020000, 'cn', '日历管理', '', 'SYSTEM', '2017-06-28 14:30:50', '707010014690', '2019-01-22 09:26:00');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1301020000, 'jp', 'カレンダー管理', '', 'SYSTEM', '2017-06-28 14:30:31', '707010014690', '2019-01-22 09:26:00');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1301020000, 'kr', '캘린더관리', '', '3971', '2016-10-06 15:11:07', '707010014690', '2019-01-22 09:26:00');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1301070000, 'cn', '谷歌日历联动管理', '', 'SYSTEM', '2017-06-28 14:30:38', '4498', '2019-02-22 13:37:44');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1301070000, 'en', 'Linkage management of Google calendar', '', 'SYSTEM', '2016-12-27 11:57:45', '4498', '2019-02-22 13:37:44');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1301070000, 'jp', 'グーグルカレンダ連動管理', '', 'SYSTEM', '2017-06-28 14:30:19', '4498', '2019-02-22 13:37:44');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1301070000, 'kr', '구글캘린더 연동관리', '', NULL, NULL, '4498', '2019-02-22 13:37:44');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1302000000, 'cn', '资源管理', NULL, 'SYSTEM', '2017-06-28 14:30:51', 'SYSTEM', '2017-06-28 14:30:51');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1302000000, 'en', 'Product management', NULL, 'SYSTEM', '2016-12-27 11:57:54', NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1302000000, 'jp', 'リソース管理', NULL, 'SYSTEM', '2017-06-28 14:30:32', 'SYSTEM', '2017-06-28 14:30:32');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1302000000, 'kr', '자원관리', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1302040000, 'cn', '资源分类管理', '', 'SYSTEM', '2017-06-28 14:30:52', '707010014690', '2019-01-22 09:26:09');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1302040000, 'en', 'Management for the classification of resources', '', 'SYSTEM', '2016-12-27 11:57:46', '707010014690', '2019-01-22 09:26:09');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1302040000, 'jp', 'リソース分類管理', '', 'SYSTEM', '2017-06-28 14:30:32', '707010014690', '2019-01-22 09:26:09');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1302040000, 'kr', '자원분류관리', '', '3971', '2016-10-06 10:22:44', '707010014690', '2019-01-22 09:26:09');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1302050000, 'cn', '资源登录管理', '', 'SYSTEM', '2017-06-28 14:30:52', '707010014690', '2019-01-22 09:26:18');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1302050000, 'en', 'Management of resources registration', '', 'SYSTEM', '2017-01-26 09:45:49', '707010014690', '2019-01-22 09:26:18');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1302050000, 'jp', 'リソース登録管理', '', 'SYSTEM', '2017-06-28 14:30:32', '707010014690', '2019-01-22 09:26:18');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1302050000, 'kr', '자원등록관리', '', '3971', '2016-10-06 10:23:17', '707010014690', '2019-01-22 09:26:18');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1302060000, 'cn', '预约批准管理', '', 'SYSTEM', '2017-06-28 14:30:50', '707010014690', '2019-01-22 09:26:26');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1302060000, 'en', 'Management for the approval of reservation', '', 'SYSTEM', '2016-12-27 11:57:46', '707010014690', '2019-01-22 09:26:26');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1302060000, 'jp', '予約承認管理', '', 'SYSTEM', '2017-06-28 14:30:30', '707010014690', '2019-01-22 09:26:26');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1302060000, 'kr', '예약승인관리', '', '3971', '2016-10-06 10:24:07', '707010014690', '2019-01-22 09:26:26');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1302070000, 'cn', '资源日历', '', 'SYSTEM', '2017-06-28 14:30:52', '707010014690', '2019-01-22 09:26:35');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1302070000, 'jp', 'リソースカレンダー', '', 'SYSTEM', '2017-06-28 14:30:32', '707010014690', '2019-01-22 09:26:35');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1302070000, 'kr', '자원캘린더', '', '9871', '2016-10-22 18:36:00', '707010014690', '2019-01-22 09:26:35');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1303000000, 'cn', '选项管理', NULL, 'SYSTEM', '2017-06-28 14:30:44', 'SYSTEM', '2017-06-28 14:30:44');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1303000000, 'en', 'Option management', NULL, 'SYSTEM', '2016-12-27 11:57:53', NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1303000000, 'jp', 'オプション管理', NULL, 'SYSTEM', '2017-06-28 14:30:25', 'SYSTEM', '2017-06-28 14:30:25');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1303000000, 'kr', '옵션관리', '', NULL, NULL, '3971', '2016-10-06 15:08:14');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1303010000, 'cn', '设定通知', NULL, 'SYSTEM', '2017-06-28 14:30:46', 'SYSTEM', '2017-06-28 14:30:46');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1303010000, 'en', 'Set notification', NULL, 'SYSTEM', '2016-12-27 11:57:56', NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1303010000, 'jp', 'お知らせ設定', NULL, 'SYSTEM', '2017-06-28 14:30:27', 'SYSTEM', '2017-06-28 14:30:27');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1303010000, 'kr', '알림설정', NULL, NULL, NULL, NULL, NULL);

ALTER TABLE tcmg_optionset CHANGE COLUMN IF EXISTS `p_option_id` `p_option_id` VARCHAR(35);
*/

------------------  소스시퀀스 : 6573


/*
update t_msg_tcmg_link set target_url = '/gw/MsgLogOn.do' where link_kind = 'A';

------------------  소스시퀀스 : 6636
*/



/*
 * 2019.04.19
 * 수정사항
 * [업무보고] 공통댓글 배포
 * [포틀릿] 일정포틀릿 오류 수정 
 * */

/*
CREATE TABLE IF NOT EXISTS `t_co_atch_file_mig_report` (
	`file_id` VARCHAR(32) NOT NULL COMMENT '파일 아이디',
	`use_yn` CHAR(1) NULL DEFAULT NULL COMMENT '사용여부',
	`create_seq` VARCHAR(32) NULL DEFAULT NULL COMMENT '생성자',
	`create_date` DATETIME NULL DEFAULT NULL COMMENT '생성일자',
	`modify_seq` VARCHAR(32) NULL DEFAULT NULL COMMENT '수정자',
	`modify_date` DATETIME NULL DEFAULT NULL COMMENT '수정일자',
	`report_seq` VARCHAR(50) NOT NULL,
	`seq` VARCHAR(50) NULL DEFAULT NULL,
	PRIMARY KEY (`file_id`, `report_seq`)
)
COMMENT='사용자지원_파일속성'
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;


CREATE TABLE IF NOT EXISTS `t_co_atch_file_detail_mig_report` (
	`file_id` VARCHAR(32) NOT NULL COMMENT '첨부파일아이디' COLLATE 'utf8_general_ci',
	`file_sn` INT(10) NOT NULL COMMENT '파일연번',
	`path_seq` VARCHAR(32) NOT NULL COMMENT '절대경로시퀀스' COLLATE 'utf8_bin',
	`file_stre_cours` VARCHAR(2000) NOT NULL COMMENT '파일저장상대경로' COLLATE 'utf8_general_ci',
	`stre_file_name` VARCHAR(255) NOT NULL COMMENT '저장파일명' COLLATE 'utf8_general_ci',
	`orignl_file_name` VARCHAR(255) NULL DEFAULT NULL COMMENT '원파일명' COLLATE 'utf8_general_ci',
	`file_extsn` VARCHAR(20) NOT NULL COMMENT '파일확장자' COLLATE 'utf8_general_ci',
	`file_cn` TEXT NULL COMMENT '파일내용' COLLATE 'utf8_general_ci',
	`file_size` INT(8) NULL DEFAULT NULL COMMENT '파일크기',
	`use_yn` CHAR(1) NULL DEFAULT 'Y' COMMENT '사용유무' COLLATE 'utf8_bin',
	PRIMARY KEY (`file_id`, `file_sn`),
	UNIQUE INDEX `t_co_file_detail_pk01` (`file_id`, `file_sn`)
)
COMMENT='사용자지원_파일상세정보'
COLLATE='utf8_bin'
ENGINE=InnoDB
;



DELIMITER $$

USE `neos`$$

DROP FUNCTION IF EXISTS `mig_report`$$

CREATE DEFINER=`neos`@`%` FUNCTION `mig_report`(`reportSeq` VARCHAR(32), `seq` VARCHAR(50)) RETURNS BIGINT(20) UNSIGNED
    MODIFIES SQL DATA
    DETERMINISTIC
BEGIN
     DECLARE ret BIGINT UNSIGNED;
     DECLARE fileId VARCHAR(255);
     
     SELECT REPLACE(UUID(),'-','') INTO fileId;
     
     INSERT INTO t_co_atch_file_mig_report
     VALUES(fileId, 'Y', 'MIG', NOW(), NULL,NULL, reportSeq, seq);   
	  
	  INSERT INTO t_co_atch_file_detail_mig_report
	  SELECT 
		fileId,
		(@rownum:=@rownum+1) -1,
		path_seq,
		file_stre_cours,
		stre_file_name,
		orignl_file_name,
		file_extsn,
		file_cn,
		file_size,
		b.use_yn
		FROM t_sc_work_report_comment_file a
		INNER JOIN t_co_atch_file_detail b ON a.file_id = b.file_id
		, (SELECT @rownum:=0) tmp
		WHERE report_seq = reportSeq AND a.seq = seq;

	    
   
     RETURN reportSeq;
 END$$

DELIMITER ;



INSERT ignore into t_co_comment

select 
	commentSeq comment_seq,
	module_gbn_code,
	module_seq,
	commentSeq top_level_comment_seq,
	seq parent_comment_seq,
	commentSeq sort_comment_seq,
	depth,
	contents,
	comment_type,
	comp_seq,
	dept_seq,
	file_id,
	high_gbn_code,
	middle_gbn_code,
	emp_name,
	comment_password,
	comp_name,
	dept_name,
	duty_code,
	duty_name,
	position_code,
	position_name,
	notified_cnt,
	recomm_cnt,
	declare_cnt,
	create_ip,
	use_yn,
	view_yn,
	create_seq,
	create_date,
	modify_seq,
	modify_date	
from (


select 
	CONCAT((@rownum:=@rownum+1)*1000) rownum,
	(SELECT LPAD(CONVERT(IFNULL(MAX(comment_seq),0),UNSIGNED) + CONCAT((@rownum:=@rownum)*1000),16,0) AS commentSeq
		FROM t_co_comment
		where (parent_comment_seq is null || parent_comment_seq = '')) commentSeq,
	'' commet_seq,
	'report' module_gbn_code,
	a.report_seq module_seq,
	'' top_level_comment_seq,
	'' parent_comment_seq,
	'' sort_comment_seq,
	'1' depth,
	comment contents,
	'' comment_type,
	target_comp_seq comp_seq,
	target_dept_seq dept_seq,
	'' file_id,
	'' high_gbn_code,
	'' middle_gbn_code,
	(select concat('[',group_concat(concat('{"langCode":"',lang_code,'","empName":"', emp_name,'"}')),']') From t_co_emp_multi where emp_seq = a.create_seq) emp_name,
	'' comment_password,
	(select concat('[',group_concat(concat('{"langCode":"',lang_code,'","compName":"', comp_name,'"}')),']') From t_co_comp_multi where comp_seq = a.comp_seq) comp_name,
	null dept_name,
	c.duty_code duty_code,
	(select concat('[',group_concat(concat('{"langCode":"',lang_code,'","dutyName":"', dp_name,'"}')),']') From t_co_comp_duty_position_multi where dp_type = 'DUTY' and dp_seq = c.duty_code) duty_name,
	c.position_code position_code,
	(select concat('[',group_concat(concat('{"langCode":"',lang_code,'","positionName":"', dp_name,'"}')),']') From t_co_comp_duty_position_multi where dp_type = 'POSITION' and dp_seq = c.position_code) position_name,
	'0' notified_cnt,
	'0' recomm_cnt,
	'0' declare_cnt,
	'' create_ip,
	a.use_yn use_yn,
	'Y' view_yn,
	a.create_seq create_seq,
	a.create_date create_date,
	a.modify_seq modify_seq,
	a.modify_date modify_date,
	a.seq
from
	t_sc_work_report_comment a
inner join
 	t_sc_work_report b on a.report_seq = b.report_seq
inner join
	t_co_emp_dept c ON a.comp_seq = c.comp_seq AND a.create_seq = c.emp_seq and c.main_dept_yn = 'Y'
, (select @rownum:=0) tmp
) a;


select mig_report(a.module_seq, parent_comment_seq) from t_co_comment a where a.module_gbn_code = 'report';

insert ignore into t_co_atch_file 
select file_id, use_yn, create_seq, create_date, modify_seq, modify_date from t_co_atch_file_mig_report;

insert ignore into t_co_atch_file_detail
select *from t_co_atch_file_detail_mig_report;


update t_co_comment a
inner join t_co_atch_file_mig_report b on a.module_seq = b.report_seq and a.parent_comment_seq = b.seq
set a.file_id = b.file_id
where a.module_gbn_code = 'report';


update t_co_comment set parent_comment_seq = '' where module_gbn_code = 'report';

drop table IF EXISTS t_co_atch_file_mig_report;
drop table IF EXISTS t_co_atch_file_detail_mig_report;
DROP FUNCTION IF EXISTS mig_report;

INSERT ignore INTO t_co_comment_count
SELECT module_gbn_code, module_seq, (SELECT COUNT(*) FROM t_co_comment WHERE module_seq = a.module_seq  and module_gbn_code = 'report' and use_yn = 'Y' and view_yn = 'Y')cnt, use_yn, 'MIG',NOW(),NULL,NULL
FROM t_Co_comment a
WHERE a.module_gbn_code = 'report'
GROUP BY module_seq;



DELIMITER $$

USE `neos`$$

DROP FUNCTION IF EXISTS `URLENCODE`$$

CREATE DEFINER=`neos`@`%` FUNCTION `URLENCODE`(str VARCHAR(4096) CHARSET utf8) RETURNS VARCHAR(4096) CHARSET utf8
    DETERMINISTIC
BEGIN
   DECLARE sub VARCHAR(1) CHARSET utf8;   
   DECLARE val BIGINT DEFAULT 0;   
   DECLARE ind INT DEFAULT 1;      
   DECLARE OCT INT DEFAULT 0;   
   DECLARE ret VARCHAR(4096) DEFAULT '';   
   DECLARE octind INT DEFAULT 0; 
   IF ISNULL(str) THEN
      RETURN NULL;
   ELSE
      SET ret = '';           
      WHILE ind <= CHAR_LENGTH(str) DO
         SET sub = MID(str, ind, 1);
         SET val = ORD(sub);
         IF NOT (val BETWEEN 48 AND 57 OR     -- 48-57  = 0-9
                 val BETWEEN 65 AND 90 OR     -- 65-90  = A-Z
                 val BETWEEN 97 AND 122 OR    -- 97-122 = a-z
                 val IN (45, 46, 95, 126)) THEN
            SET octind = OCTET_LENGTH(sub);
            WHILE octind > 0 DO
               SET OCT = (val >> (8 * (octind - 1)));
               SET ret = CONCAT(ret, '%', LPAD(HEX(OCT), 2, 0));
               SET val = (val & (POWER(256, (octind - 1)) - 1));
               SET octind = (octind - 1);
            END WHILE;
         ELSE
            SET ret = CONCAT(ret, sub);
         END IF;
         SET ind = (ind + 1);
      END WHILE;
   END IF;
   RETURN ret;
END$$

DELIMITER ;

ALTER TABLE `t_co_group` ADD COLUMN if NOT EXISTS `gw_url` VARCHAR(512) NULL DEFAULT NULL COMMENT 'gw url' AFTER `mobile_url`;
UPDATE t_co_group SET gw_url = edms_url;
------------------  소스시퀀스 : 6699
*/

/*
 * 2019.04.25
 * 수정사항
 * [통합검색] 처리 로직 개선 (검색시에 먼저 검색되는 모듈 먼저 보여주도록 처리 변경에 따른 화면,서버개발)
 * [공통포털] B타입 포털 서브메뉴에서 겸직정보 팝업 폰트사이즈 수정
 * [시스템설정] 유일한 마스터계정은 삭제/퇴사처리 불가하도록 수정 
 * */
/*
update t_msg_tcmg_link set target_url = '/gw/MsgLogOn.do' where link_kind = 'A';
*/

------------------  소스시퀀스 : 6852


/*
 * 수정사항
 * [통합검색] 원피스 통합검색 트리거 수정
 * [업무보고] 모바일업무보고 로딩속도 개선
 * [시스템설정] 사원정보관리 메일계정 조회관련 개선 
 * [시스템설정] 인사이동 메뉴 재직여부 콤보박스 오작동 오류 수정
 * [파일업로드] 전자결재 첨부파일 오류 건.
	- 간헐적으로 전자결재 첨부파일 첨부시 0byte로 업로드 됨에 따라 GW 공통 업로드의 문제인지 전자결재 모듈의 파일이동 오류인지 추적이 필요하여, 공통 업로드 모듈에 로깅 추가 및 log4j main.web 로그레벨 debug로 조정.
*/

/*
DELIMITER $$

USE `neos`$$

DROP TRIGGER IF EXISTS `TRG_ONEFFICE_DOCUMENT_AU`$$

CREATE
    /*!50017 DEFINER = 'neos'@'%' */
    TRIGGER `TRG_ONEFFICE_DOCUMENT_AU` AFTER UPDATE ON `oneffice_document` 
    FOR EACH ROW BEGIN
	DECLARE iudType CHAR;
	
	IF NEW.deleted = '0' THEN
	   SET iudType = 'U';
	ELSEIF NEW.deleted = '1' THEN
	   SET iudType = 'D';
	END IF;

	INSERT INTO t_se_job	(event_date, job_type, pk_Seq, iud_type)
	VALUES
	(NOW(), 'oneffice-1', NEW.doc_no, iudType);
END;
$$

DELIMITER ;



ALTER TABLE `t_sc_work_report`
	ADD INDEX IF NOT EXISTS `report_seq` (`report_seq`),
	ADD INDEX IF NOT EXISTS `group_seq` (`group_seq`),
	ADD INDEX IF NOT EXISTS `state` (`state`),
	ADD INDEX IF NOT EXISTS `target_emp_seq` (`target_emp_seq`),
	ADD INDEX IF NOT EXISTS `read_yn` (`read_yn`),
	ADD INDEX IF NOT EXISTS `use_yn` (`use_yn`),
	ADD INDEX IF NOT EXISTS `open_yn` (`open_yn`),
	ADD INDEX IF NOT EXISTS `create_seq` (`create_seq`);


ALTER TABLE `t_sc_work_report_referer`
	ADD INDEX IF NOT EXISTS `report_seq` (`report_seq`),
	ADD INDEX IF NOT EXISTS `emp_seq` (`emp_seq`);
	
	
ALTER TABLE `t_co_second_cert_device` ADD COLUMN if NOT exists `flag_req` CHAR(1) NULL DEFAULT 'N' AFTER `token`;
*/

------------------  소스시퀀스 : 6957


/*
update tcmg_optionset set module_gb = 'msg', p_option_id = 'msg1600' where option_id in ('pathSeq800','pathSeq810');
update tcmg_optionset set p_option_must_value = '|1|2|' where p_option_id in ('com100','com100','com300');
update tcmg_optionset set p_option_must_value='|1|' where p_option_id in ('app100','app200','app300','app600','cm100','cm1000','cm1100','cm1101','cm1103','cm1104','cm1400','cm1500','cm1501','cm1502','cm1503','cm1600','cm1700','cm1800','cm200','cm700','com400','msg100','msg1600','msg1700','msg1900','msg200','msg600','msg800','msg900');
delete from tcmg_optionset where option_id = 'app400';

insert ignore into t_co_code
(code, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('option0206', 'Y', NULL, NULL, NULL, NULL);

insert ignore into t_co_code_multi
(code, lang_code, name, note, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('option0206', 'kr', '첨부파일 확장자설정 옵션', NULL, 'Y', NULL, NULL, NULL, NULL);

insert ignore into t_co_code_detail
(detail_code, code, ischild, order_num, flag_1, flag_2, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('0', 'option0206', 'N', 0, NULL, NULL, 'Y', NULL, NULL, NULL, NULL);

insert ignore into t_co_code_detail_multi
(detail_code, code, lang_code, detail_name, note, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('0', 'option0206', 'kr', '미사용', NULL, 'Y', NULL, NULL, NULL, NULL)
,('0', 'option0206', 'en', 'Unused', NULL, 'Y', NULL, NULL, NULL, NULL)
,('0', 'option0206', 'cn', '未使用', NULL, 'Y', NULL, NULL, NULL, NULL)
,('0', 'option0206', 'jp', '未使用', NULL, 'Y', NULL, NULL, NULL, NULL);

insert ignore into t_co_code_detail
(detail_code, code, ischild, order_num, flag_1, flag_2, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('1', 'option0206', 'N', 1, NULL, NULL, 'Y', NULL, NULL, NULL, NULL);

insert ignore into t_co_code_detail_multi
(detail_code, code, lang_code, detail_name, note, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('1', 'option0206', 'kr', '전체적용', NULL, 'Y', NULL, NULL, NULL, NULL)
,('1', 'option0206', 'en', 'All', NULL, 'Y', NULL, NULL, NULL, NULL)
,('1', 'option0206', 'cn', '全部', NULL, 'Y', NULL, NULL, NULL, NULL)
,('1', 'option0206', 'jp', '全体', NULL, 'Y', NULL, NULL, NULL, NULL);

insert ignore into t_co_code_detail
(detail_code, code, ischild, order_num, flag_1, flag_2, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('2', 'option0206', 'N', 2, NULL, NULL, 'Y', NULL, NULL, NULL, NULL);

insert ignore into t_co_code_detail_multi
(detail_code, code, lang_code, detail_name, note, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('2', 'option0206', 'kr', '선택적용', NULL, 'Y', NULL, NULL, NULL, NULL)
,('2', 'option0206', 'en', 'Select', NULL, 'Y', NULL, NULL, NULL, NULL)
,('2', 'option0206', 'cn', '选择', NULL, 'Y', NULL, NULL, NULL, NULL)
,('2', 'option0206', 'jp', '選択', NULL, 'Y', NULL, NULL, NULL, NULL);

insert ignore into t_co_code
(code, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('option0207', 'Y', NULL, NULL, NULL, NULL);

insert ignore into t_co_code_multi
(code, lang_code, name, note, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('option0207', 'kr', '첨부파일 확장자설정타입 옵션', NULL, 'Y', NULL, NULL, NULL, NULL);

insert ignore into t_co_code_detail
(detail_code, code, ischild, order_num, flag_1, flag_2, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('limit', 'option0207', 'N', 0, NULL, NULL, 'Y', NULL, NULL, NULL, NULL);

insert ignore into t_co_code_detail_multi
(detail_code, code, lang_code, detail_name, note, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('limit', 'option0207', 'kr', '제한확장자', NULL, 'Y', NULL, NULL, NULL, NULL);

insert ignore into t_co_code_detail
(detail_code, code, ischild, order_num, flag_1, flag_2, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('permit', 'option0207', 'N', 1, NULL, NULL, 'Y', NULL, NULL, NULL, NULL);

insert ignore into t_co_code_detail_multi
(detail_code, code, lang_code, detail_name, note, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('permit', 'option0207', 'kr', '허용확장자', NULL, 'Y', NULL, NULL, NULL, NULL);

insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('cm1710', '1', 'cm', 'single', '첨부파일 확장자 설정', NULL, NULL, '1', '첨부파일업로드시제한/허용확장자를설정할수있습니다.
-미사용:업로드를제한하지않습니다.
-전체적용:제한또는허용확장자를설정할수있습니다.
-선택적용:모듈별로제한또는허용확장자를설정할수있습니다.', '0', 'option0206', NULL, NULL, NULL, '', '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);

insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('cm1711', '1', 'cm', 'single', '업로드제한/허용확장자설정', 'cm1710', '|1|', '2', '첨부파일 업로드시 제한 및 허용할 확장자를 설정 할 수 있습니다.
확장자는 다수로 입력할 수 있습니다.

- 제한 확장자
   : 업로드를 제한할 확장자명을 입력 합니다. 입력된 확장자는 업로드 할 수 없습니다. 
- 허용 확장자
   : 업로드를 허용할 확장자 명을 입력 합니다. 입력된 확장자만 업로드 할 수 있습니다.

단, 제한확장자 또는 허용확장자는 중복 설정 할 수 없으며, 선택된 설정값으로 동작합니다. 
옵션 설정값은 변경시점 이후부터 적용됩니다.', 'limit▦', 'option0207', NULL, NULL, NULL, '', '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);

insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('cm1712', '1', 'cm', 'single', '전자결재', 'cm1710', '|2|', '2', '전자결재 첨부파일 업로드시 제한 및 허용할 확장자를 설정 할 수 있습니다.
확장자는 다수로 입력할 수 있습니다.

- 제한 확장자
   : 업로드를 제한할 확장자명을 입력 합니다. 입력된 확장자는 업로드 할 수 없습니다. 
- 허용 확장자
   : 업로드를 허용할 확장자 명을 입력 합니다. 입력된 확장자만 업로드 할 수 있습니다.

단, 제한확장자 또는 허용확장자는 중복 설정 할 수 없으며, 선택된 설정값으로 동작합니다. 
옵션 설정값은 변경시점 이후부터 적용됩니다.', 'limit▦', 'option0207', NULL, NULL, NULL, '', '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);

insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('cm1713', '1', 'cm', 'single', '메일', 'cm1710', '|2|', '2', '메일 첨부파일 업로드시 제한 및 허용할 확장자를 설정 할 수 있습니다.
확장자는 다수로 입력할 수 있습니다.

- 제한 확장자
   : 업로드를 제한할 확장자명을 입력 합니다. 입력된 확장자는 업로드 할 수 없습니다. 
- 허용 확장자
   : 업로드를 허용할 확장자 명을 입력 합니다. 입력된 확장자만 업로드 할 수 있습니다.

단, 제한확장자 또는 허용확장자는 중복 설정 할 수 없으며, 선택된 설정값으로 동작합니다. 
옵션 설정값은 변경시점 이후부터 적용됩니다.', 'limit▦', 'option0207', NULL, NULL, NULL, '', '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);

insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('cm1714', '1', 'cm', 'single', '업무관리', 'cm1710', '|2|', '2', '업무관리 첨부파일 업로드시 제한 및 허용할 확장자를 설정 할 수 있습니다.
확장자는 다수로 입력할 수 있습니다.

- 제한 확장자
   : 업로드를 제한할 확장자명을 입력 합니다. 입력된 확장자는 업로드 할 수 없습니다. 
- 허용 확장자
   : 업로드를 허용할 확장자 명을 입력 합니다. 입력된 확장자만 업로드 할 수 있습니다.

단, 제한확장자 또는 허용확장자는 중복 설정 할 수 없으며, 선택된 설정값으로 동작합니다. 
옵션 설정값은 변경시점 이후부터 적용됩니다.', 'limit▦', 'option0207', NULL, NULL, NULL, '', '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);

insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('cm1715', '1', 'cm', 'single', '일정/노트', 'cm1710', '|2|', '2', '일정/노트 첨부파일 업로드시 제한 및 허용할 확장자를 설정 할 수 있습니다.
확장자는 다수로 입력할 수 있습니다.

- 제한 확장자
   : 업로드를 제한할 확장자명을 입력 합니다. 입력된 확장자는 업로드 할 수 없습니다. 
- 허용 확장자
   : 업로드를 허용할 확장자 명을 입력 합니다. 입력된 확장자만 업로드 할 수 있습니다.

단, 제한확장자 또는 허용확장자는 중복 설정 할 수 없으며, 선택된 설정값으로 동작합니다. 
옵션 설정값은 변경시점 이후부터 적용됩니다.', 'limit▦', 'option0207', NULL, NULL, NULL, '', '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);

insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('cm1716', '1', 'cm', 'single', '업무보고', 'cm1710', '|2|', '2', '업무보고 첨부파일 업로드시 제한 및 허용할 확장자를 설정 할 수 있습니다.
확장자는 다수로 입력할 수 있습니다.

- 제한 확장자
   : 업로드를 제한할 확장자명을 입력 합니다. 입력된 확장자는 업로드 할 수 없습니다. 
- 허용 확장자
   : 업로드를 허용할 확장자 명을 입력 합니다. 입력된 확장자만 업로드 할 수 있습니다.

단, 제한확장자 또는 허용확장자는 중복 설정 할 수 없으며, 선택된 설정값으로 동작합니다. 
옵션 설정값은 변경시점 이후부터 적용됩니다.', 'limit▦', 'option0207', NULL, NULL, NULL, '', '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);

insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('cm1717', '1', 'cm', 'single', '게시판', 'cm1710', '|2|', '2', '게시판 첨부파일 업로드시 제한 및 허용할 확장자를 설정 할 수 있습니다.
확장자는 다수로 입력할 수 있습니다.

- 제한 확장자
   : 업로드를 제한할 확장자명을 입력 합니다. 입력된 확장자는 업로드 할 수 없습니다. 
- 허용 확장자
   : 업로드를 허용할 확장자 명을 입력 합니다. 입력된 확장자만 업로드 할 수 있습니다.

단, 제한확장자 또는 허용확장자는 중복 설정 할 수 없으며, 선택된 설정값으로 동작합니다. 
옵션 설정값은 변경시점 이후부터 적용됩니다.', 'limit▦', 'option0207', NULL, NULL, NULL, '', '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);

insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('cm1718', '1', 'cm', 'single', '문서', 'cm1710', '|2|', '2', '문서 첨부파일 업로드시 제한 및 허용할 확장자를 설정 할 수 있습니다.
확장자는 다수로 입력할 수 있습니다.

- 제한 확장자
   : 업로드를 제한할 확장자명을 입력 합니다. 입력된 확장자는 업로드 할 수 없습니다. 
- 허용 확장자
   : 업로드를 허용할 확장자 명을 입력 합니다. 입력된 확장자만 업로드 할 수 있습니다.

단, 제한확장자 또는 허용확장자는 중복 설정 할 수 없으며, 선택된 설정값으로 동작합니다. 
옵션 설정값은 변경시점 이후부터 적용됩니다.', 'limit▦', 'option0207', NULL, NULL, NULL, '', '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);

insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('msg1610', '1', 'msg', 'single', 'PC메신저 첨부파일 확장자 설정', NULL, NULL, '1', '첨부파일업로드시제한/허용확장자를설정할수있습니다.
-미사용:업로드를제한하지않습니다.
-전체적용:제한또는허용확장자를설정할수있습니다.
-선택적용:모듈별로제한또는허용확장자를설정할수있습니다.', '0', 'option0206', NULL, NULL, NULL, '', '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);

insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('msg1611', '1', 'msg', 'single', '업로드제한/허용확장자설정', 'msg1610', '|1|', '2', '첨부파일 업로드시 제한 및 허용할 확장자를 설정 할 수 있습니다.
확장자는 다수로 입력할 수 있습니다.

- 제한 확장자
   : 업로드를 제한할 확장자명을 입력 합니다. 입력된 확장자는 업로드 할 수 없습니다. 
- 허용 확장자
   : 업로드를 허용할 확장자 명을 입력 합니다. 입력된 확장자만 업로드 할 수 있습니다.

단, 제한확장자 또는 허용확장자는 중복 설정 할 수 없으며, 선택된 설정값으로 동작합니다. 
옵션 설정값은 변경시점 이후부터 적용됩니다.', 'limit▦', 'option0207', NULL, NULL, NULL, '', '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);


insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('msg1612', '1', 'msg', 'single', '쪽지', 'msg1610', '|2|', '2', '쪽지 첨부파일 업로드시 제한 및 허용할 확장자를 설정 할 수 있습니다.
확장자는 다수로 입력할 수 있습니다.

- 제한 확장자
   : 업로드를 제한할 확장자명을 입력 합니다. 입력된 확장자는 업로드 할 수 없습니다. 
- 허용 확장자
   : 업로드를 허용할 확장자 명을 입력 합니다. 입력된 확장자만 업로드 할 수 있습니다.

미사용을 선택한 경우, 해당 메뉴는 첨부파일 확장자 제한을 하지 않습니다.

※ Messenger 쪽지/대화방 내 전달기능에 대해서는 옵션 영향을 받지 않습니다.', 'limit▦', 'option0207', NULL, NULL, NULL, '', '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);

insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('msg1613', '1', 'msg', 'single', '대화방', 'msg1610', '|2|', '2', '대화방 첨부파일 업로드시 제한 및 허용할 확장자를 설정 할 수 있습니다.
확장자는 다수로 입력할 수 있습니다.

- 제한 확장자
   : 업로드를 제한할 확장자명을 입력 합니다. 입력된 확장자는 업로드 할 수 없습니다. 
- 허용 확장자
   : 업로드를 허용할 확장자 명을 입력 합니다. 입력된 확장자만 업로드 할 수 있습니다.

미사용을 선택한 경우, 해당 메뉴는 첨부파일 확장자 제한을 하지 않습니다.

※ Messenger 쪽지/대화방 내 전달기능에 대해서는 옵션 영향을 받지 않습니다.', 'limit▦', 'option0207', NULL, NULL, NULL, '', '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);

insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('app610', '1', 'app', 'single', '모바일 첨부파일 확장자 설정', NULL, NULL, '1', '첨부파일업로드시제한/허용확장자를설정할수있습니다.
-미사용:업로드를제한하지않습니다.
-전체적용:제한또는허용확장자를설정할수있습니다.
-선택적용:모듈별로제한또는허용확장자를설정할수있습니다.', '0', 'option0206', NULL, NULL, NULL, '', '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);

insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('app611', '1', 'app', 'single', '업로드제한/허용확장자설정', 'app610', '|1|', '2', '첨부파일 업로드시 제한 및 허용할 확장자를 설정 할 수 있습니다.
확장자는 다수로 입력할 수 있습니다.

- 제한 확장자
   : 업로드를 제한할 확장자명을 입력 합니다. 입력된 확장자는 업로드 할 수 없습니다. 
- 허용 확장자
   : 업로드를 허용할 확장자 명을 입력 합니다. 입력된 확장자만 업로드 할 수 있습니다.

단, 제한확장자 또는 허용확장자는 중복 설정 할 수 없으며, 선택된 설정값으로 동작합니다. 
옵션 설정값은 변경시점 이후부터 적용됩니다.', 'limit▦', 'option0207', NULL, NULL, NULL, '', '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);


insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('app612', '1', 'app', 'single', '전자결재', 'app610', '|2|', '2', '전자결재 첨부파일 업로드시 제한 및 허용할 확장자를 설정 할 수 있습니다.
확장자는 다수로 입력할 수 있습니다.

- 제한 확장자
   : 업로드를 제한할 확장자명을 입력 합니다. 입력된 확장자는 업로드 할 수 없습니다. 
- 허용 확장자
   : 업로드를 허용할 확장자 명을 입력 합니다. 입력된 확장자만 업로드 할 수 있습니다.

단, 제한확장자 또는 허용확장자는 중복 설정 할 수 없으며, 선택된 설정값으로 동작합니다. 
옵션 설정값은 변경시점 이후부터 적용됩니다.', 'limit▦', 'option0207', NULL, NULL, NULL, '', '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);

insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('app613', '1', 'app', 'single', '메일', 'app610', '|2|', '2', '메일 첨부파일 업로드시 제한 및 허용할 확장자를 설정 할 수 있습니다.
확장자는 다수로 입력할 수 있습니다.

- 제한 확장자
   : 업로드를 제한할 확장자명을 입력 합니다. 입력된 확장자는 업로드 할 수 없습니다. 
- 허용 확장자
   : 업로드를 허용할 확장자 명을 입력 합니다. 입력된 확장자만 업로드 할 수 있습니다.

단, 제한확장자 또는 허용확장자는 중복 설정 할 수 없으며, 선택된 설정값으로 동작합니다. 
옵션 설정값은 변경시점 이후부터 적용됩니다.', 'limit▦', 'option0207', NULL, NULL, NULL, '', '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);

insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('app614', '1', 'app', 'single', '업무관리', 'app610', '|2|', '2', '업무관리 첨부파일 업로드시 제한 및 허용할 확장자를 설정 할 수 있습니다.
확장자는 다수로 입력할 수 있습니다.

- 제한 확장자
   : 업로드를 제한할 확장자명을 입력 합니다. 입력된 확장자는 업로드 할 수 없습니다. 
- 허용 확장자
   : 업로드를 허용할 확장자 명을 입력 합니다. 입력된 확장자만 업로드 할 수 있습니다.

단, 제한확장자 또는 허용확장자는 중복 설정 할 수 없으며, 선택된 설정값으로 동작합니다. 
옵션 설정값은 변경시점 이후부터 적용됩니다.', 'limit▦', 'option0207', NULL, NULL, NULL, '', '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);

insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('app615', '1', 'app', 'single', '일정/노트', 'app610', '|2|', '2', '일정/노트 첨부파일 업로드시 제한 및 허용할 확장자를 설정 할 수 있습니다.
확장자는 다수로 입력할 수 있습니다.

- 제한 확장자
   : 업로드를 제한할 확장자명을 입력 합니다. 입력된 확장자는 업로드 할 수 없습니다. 
- 허용 확장자
   : 업로드를 허용할 확장자 명을 입력 합니다. 입력된 확장자만 업로드 할 수 있습니다.

단, 제한확장자 또는 허용확장자는 중복 설정 할 수 없으며, 선택된 설정값으로 동작합니다. 
옵션 설정값은 변경시점 이후부터 적용됩니다.', 'limit▦', 'option0207', NULL, NULL, NULL, '', '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
                    
insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('app616', '1', 'app', 'single', '업무보고', 'app610', '|2|', '2', '업무보고 첨부파일 업로드시 제한 및 허용할 확장자를 설정 할 수 있습니다.
확장자는 다수로 입력할 수 있습니다.

- 제한 확장자
   : 업로드를 제한할 확장자명을 입력 합니다. 입력된 확장자는 업로드 할 수 없습니다. 
- 허용 확장자
   : 업로드를 허용할 확장자 명을 입력 합니다. 입력된 확장자만 업로드 할 수 있습니다.

단, 제한확장자 또는 허용확장자는 중복 설정 할 수 없으며, 선택된 설정값으로 동작합니다. 
옵션 설정값은 변경시점 이후부터 적용됩니다.', 'limit▦', 'option0207', NULL, NULL, NULL, '', '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
       
insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('app617', '1', 'app', 'single', '게시판', 'app610', '|2|', '2', '게시판 첨부파일 업로드시 제한 및 허용할 확장자를 설정 할 수 있습니다.
확장자는 다수로 입력할 수 있습니다.

- 제한 확장자
   : 업로드를 제한할 확장자명을 입력 합니다. 입력된 확장자는 업로드 할 수 없습니다. 
- 허용 확장자
   : 업로드를 허용할 확장자 명을 입력 합니다. 입력된 확장자만 업로드 할 수 있습니다.

단, 제한확장자 또는 허용확장자는 중복 설정 할 수 없으며, 선택된 설정값으로 동작합니다. 
옵션 설정값은 변경시점 이후부터 적용됩니다.', 'limit▦', 'option0207', NULL, NULL, NULL, '', '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
       
insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('app618', '1', 'app', 'single', '문서', 'app610', '|2|', '2', '문서 첨부파일 업로드시 제한 및 허용할 확장자를 설정 할 수 있습니다.
확장자는 다수로 입력할 수 있습니다.

- 제한 확장자
   : 업로드를 제한할 확장자명을 입력 합니다. 입력된 확장자는 업로드 할 수 없습니다. 
- 허용 확장자
   : 업로드를 허용할 확장자 명을 입력 합니다. 입력된 확장자만 업로드 할 수 있습니다.

단, 제한확장자 또는 허용확장자는 중복 설정 할 수 없으며, 선택된 설정값으로 동작합니다. 
옵션 설정값은 변경시점 이후부터 적용됩니다.', 'limit▦', 'option0207', NULL, NULL, NULL, '', '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
       
insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('app619', '1', 'app', 'single', '쪽지', 'app610', '|2|', '2', '쪽지 첨부파일 업로드시 제한 및 허용할 확장자를 설정 할 수 있습니다.
확장자는 다수로 입력할 수 있습니다.

- 제한 확장자
   : 업로드를 제한할 확장자명을 입력 합니다. 입력된 확장자는 업로드 할 수 없습니다. 
- 허용 확장자
   : 업로드를 허용할 확장자 명을 입력 합니다. 입력된 확장자만 업로드 할 수 있습니다.

단, 제한확장자 또는 허용확장자는 중복 설정 할 수 없으며, 선택된 설정값으로 동작합니다. 
옵션 설정값은 변경시점 이후부터 적용됩니다.', 'limit▦', 'option0207', NULL, NULL, NULL, '', '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
       
insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('app620', '1', 'app', 'single', '대화방', 'app610', '|2|', '2', '대화방 첨부파일 업로드시 제한 및 허용할 확장자를 설정 할 수 있습니다.
확장자는 다수로 입력할 수 있습니다.

- 제한 확장자
   : 업로드를 제한할 확장자명을 입력 합니다. 입력된 확장자는 업로드 할 수 없습니다. 
- 허용 확장자
   : 업로드를 허용할 확장자 명을 입력 합니다. 입력된 확장자만 업로드 할 수 있습니다.

단, 제한확장자 또는 허용확장자는 중복 설정 할 수 없으며, 선택된 설정값으로 동작합니다. 
옵션 설정값은 변경시점 이후부터 적용됩니다.', 'limit▦', 'option0207', NULL, NULL, NULL, '', '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
*/

------------------  소스시퀀스 : 7152

/*
ALTER TABLE `t_co_patch_token` ADD COLUMN IF NOT EXISTS `dept_name` varchar(128) NULL COMMENT '부서명';
ALTER TABLE `t_co_patch_token` ADD COLUMN IF NOT EXISTS `position_name` varchar(128) NULL COMMENT '직급명';
ALTER TABLE `t_co_patch_token` ADD COLUMN IF NOT EXISTS `duty_name` varchar(128) NULL COMMENT '직책명';



ALTER TABLE t_co_comp ADD COLUMN IF NOT EXISTS wehago_key varchar(100) DEFAULT NULL COMMENT '위하고연동키';
ALTER TABLE t_co_comp ADD COLUMN IF NOT EXISTS wehago_id varchar(100) DEFAULT NULL COMMENT '위하고계정';
ALTER TABLE t_co_comp ADD COLUMN IF NOT EXISTS wehago_sync_date datetime DEFAULT NULL COMMENT '위하고연동일자';

ALTER TABLE t_co_comp ADD COLUMN IF NOT EXISTS wehago_key varchar(100) DEFAULT NULL COMMENT '위하고연동키';
ALTER TABLE t_co_comp ADD COLUMN IF NOT EXISTS wehago_id varchar(100) DEFAULT NULL COMMENT '위하고계정';
ALTER TABLE t_co_comp ADD COLUMN IF NOT EXISTS wehago_sync_date datetime DEFAULT NULL COMMENT '위하고연동일자';

ALTER TABLE t_co_dept ADD COLUMN IF NOT EXISTS wehago_key varchar(100) DEFAULT NULL COMMENT '위하고연동키';
ALTER TABLE t_co_dept ADD COLUMN IF NOT EXISTS wehago_sync_date datetime DEFAULT NULL COMMENT '위하고연동일자';

ALTER TABLE t_co_emp ADD COLUMN IF NOT EXISTS wehago_key varchar(100) DEFAULT NULL COMMENT '위하고연동키';
ALTER TABLE t_co_emp ADD COLUMN IF NOT EXISTS wehago_sync_date datetime DEFAULT NULL COMMENT '위하고연동일자';


insert ignore into t_co_menu_adm
(menu_no, menu_gubun, upper_menu_no, menu_ordr, use_yn, url_gubun, url_path, sso_use_yn, menu_depth, menu_img_class, create_seq, create_date, modify_seq, modify_date, menu_adm_gubun, menu_auth_type, public_yn, delete_yn) VALUES
(1901090000, '', 1901000000, 1901090000, 'Y', 'gw', '/systemx/wehagoManageView.do', 'N', 3, NULL, NULL, NULL, NULL, NULL, NULL, 'MASTER', 'Y', 'Y');
insert ignore into t_co_menu_adm_multi
(menu_no, lang_code, menu_nm, menu_dc, create_seq, create_date, modify_seq, modify_date) VALUES
(1901090000, 'kr', 'WEHAGO조직도연동설정', NULL, NULL, NULL, NULL, NULL);

insert ignore into t_co_code
(code, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('option0208', 'Y', NULL, NULL, NULL, NULL);

insert ignore into t_co_code_multi
(code, lang_code, name, note, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('option0208', 'kr', '첨부파일 타입기본값설정 옵션', NULL, 'Y', NULL, NULL, NULL, NULL);

insert ignore into t_co_code_detail
(detail_code, code, ischild, order_num, flag_1, flag_2, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('Thumbnail', 'option0208', 'N', 0, NULL, NULL, 'Y', NULL, NULL, NULL, NULL);

insert ignore into t_co_code_detail_multi
(detail_code, code, lang_code, detail_name, note, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('Thumbnail', 'option0208', 'kr', '썸네일', NULL, 'Y', NULL, NULL, NULL, NULL);

insert ignore into t_co_code_detail
(detail_code, code, ischild, order_num, flag_1, flag_2, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('List', 'option0208', 'N', 0, NULL, NULL, 'Y', NULL, NULL, NULL, NULL);

insert ignore into t_co_code_detail_multi
(detail_code, code, lang_code, detail_name, note, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('List', 'option0208', 'kr', '목록', NULL, 'Y', NULL, NULL, NULL, NULL);

insert ignore into t_co_code_detail
(detail_code, code, ischild, order_num, flag_1, flag_2, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('Detail', 'option0208', 'N', 0, NULL, NULL, 'Y', NULL, NULL, NULL, NULL);

insert ignore into t_co_code_detail_multi
(detail_code, code, lang_code, detail_name, note, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('Detail', 'option0208', 'kr', '자세히', NULL, 'Y', NULL, NULL, NULL, NULL);

insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('cm1720', '1', 'cm', 'single', '첨부파일 타입 기본값 설정', NULL, NULL, '1', '첨부파일 타입에 대해 기본값을 설정할 수 있습니다.
썸네일/목록/자세히 3가지 설정값을 제공합니다.
', '0', NULL, NULL, NULL, NULL, '', '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('cm1721', '1', 'cm', 'single', '전자결재', 'cm1720', NULL, '2', '전자결재 메뉴의 첨부파일 타입 기본값을 설정할 수 있습니다.
설정값에 따라 첨부파일 보기 기본 타입으로 적용됩니다.
', 'Thumbnail', 'option0208', NULL, NULL, NULL, '', '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('cm1722', '1', 'cm', 'single', '메일', 'cm1720', NULL, '2', '메일 메뉴의 첨부파일 타입 기본값을 설정할 수 있습니다.
설정값에 따라 첨부파일 보기 기본 타입으로 적용됩니다.
', 'Thumbnail', 'option0208', NULL, NULL, NULL, '', '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('cm1723', '1', 'cm', 'single', '업무관리', 'cm1720', NULL, '2', '업무관리 메뉴의 첨부파일 타입 기본값을 설정할 수 있습니다.
설정값에 따라 첨부파일 보기 기본 타입으로 적용됩니다.
', 'Thumbnail', 'option0208', NULL, NULL, NULL, '', '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('cm1724', '1', 'cm', 'single', '일정/노트', 'cm1720', NULL, '2', '일정/노트 메뉴의 첨부파일 타입 기본값을 설정할 수 있습니다.
설정값에 따라 첨부파일 보기 기본 타입으로 적용됩니다.
', 'Thumbnail', 'option0208', NULL, NULL, NULL, '', '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('cm1725', '1', 'cm', 'single', '업무보고', 'cm1720', NULL, '2', '업무보고 메뉴의 첨부파일 타입 기본값을 설정할 수 있습니다.
설정값에 따라 첨부파일 보기 기본 타입으로 적용됩니다.
', 'Thumbnail', 'option0208', NULL, NULL, NULL, '', '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('cm1726', '1', 'cm', 'single', '게시판', 'cm1720', NULL, '2', '게시판 메뉴의 첨부파일 타입 기본값을 설정할 수 있습니다.
설정값에 따라 첨부파일 보기 기본 타입으로 적용됩니다.
', 'Thumbnail', 'option0208', NULL, NULL, NULL, '', '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('cm1727', '1', 'cm', 'single', '문서', 'cm1720', NULL, '2', '문서 메뉴의 첨부파일 타입 기본값을 설정할 수 있습니다.
설정값에 따라 첨부파일 보기 기본 타입으로 적용됩니다.
', 'Thumbnail', 'option0208', NULL, NULL, NULL, '', '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);


/*
 * 수정사항
 * [로그인]아이디 저장후 재로그인시 아이디/아이디입력문구 겹치는 현상수정
 * [모바일 로그인 API]모바일 회사선택 순서 그룹웨어 회사선택 순서와 같도록 수정
 * [공통] 공통첨부파일 업/다운로더 기본타입 및 확장자 설정 옵션추가 
*/

*/

------------------  소스시퀀스 : 7281

/*
 * 수정사항
 * [ERP조직도연동] ERP조직도 연동 오류 수정.
*/

/*
ALTER TABLE `t_co_patch` ADD COLUMN IF NOT EXISTS `dept_name` VARCHAR(128) NULL COMMENT '부서명';
ALTER TABLE `t_co_patch` ADD COLUMN IF NOT EXISTS `position_name` VARCHAR(128) NULL COMMENT '직급명';
ALTER TABLE `t_co_patch` ADD COLUMN IF NOT EXISTS `duty_name` VARCHAR(128) NULL COMMENT '직책명';

update tcmg_optionset set use_yn = 'N' where option_id = 'cm1710' or p_option_id = 'cm1710';
update tcmg_optionset set use_yn = 'N' where option_id = 'cm1720' or p_option_id = 'cm1720';
update tcmg_optionset set use_yn = 'N' where option_id = 'msg1610' or p_option_id = 'msg1610';
update tcmg_optionset set use_yn = 'N' where option_id = 'app610' or p_option_id = 'app610';


UPDATE t_co_emp_comp a
INNER JOIN t_co_erp b ON a.comp_seq = b.comp_seq AND achr_gbn = 'hr'
SET a.erp_comp_seq = b.erp_comp_seq
WHERE (a.erp_comp_seq IS NULL OR a.erp_comp_seq = '') AND (a.erp_emp_seq != '');
*/

------------------  소스시퀀스 : 7290
/*
ALTER TABLE t_co_group ADD COLUMN IF NOT EXISTS wehago_token varchar(100) DEFAULT NULL COMMENT '위하고서버토큰';
ALTER TABLE t_co_group ADD COLUMN IF NOT EXISTS wehago_key varchar(100) DEFAULT NULL COMMENT '위하고암호화키';
ALTER TABLE t_co_group ADD COLUMN IF NOT EXISTS wehago_server varchar(100) DEFAULT NULL COMMENT '위하고서버주소';
ALTER TABLE t_co_group ADD COLUMN IF NOT EXISTS wehago_sync_date datetime DEFAULT NULL COMMENT '위하고연동일자';
*/

------------------  소스시퀀스 : 7308




/*
 * 수정사항
 * [인사이동] 인사이동 오류 수정.
 * [다국어] 시스템설정 다국어 미번역부분 반영
 * [조직도 팝업] selectUserProfileListEmpUniq- 사원 order_text as order4 추가 (회사=0,부서=1 고정)
 * [포털] 일정포틀릿 기본값옵션 추가 
 * [시스템통계] 로그인 내역 엑셀저장 오류 수정
 * [포털] 전자결재 포틀릿 작성일자 표시 깨지는 오류 수정
*/
/*
update t_co_emp_comp set erp_emp_seq='' where erp_emp_seq is null;


ALTER TABLE `t_co_emp_move_history`
     CHANGE COLUMN `new_dept_seq` `new_dept_seq` VARCHAR(500) NULL DEFAULT NULL AFTER `emp_seq`,
     CHANGE COLUMN `new_dept_nm` `new_dept_nm` VARCHAR(500) NULL DEFAULT NULL AFTER `new_dept_seq`,
     CHANGE COLUMN `new_dept_path_nm` `new_dept_path_nm` VARCHAR(500) NULL DEFAULT NULL AFTER `new_dept_nm`,
     CHANGE COLUMN `new_position_code` `new_position_code` VARCHAR(500) NULL DEFAULT NULL AFTER `new_dept_path_nm`,
     CHANGE COLUMN `new_position_nm` `new_position_nm` VARCHAR(500) NULL DEFAULT NULL AFTER `new_position_code`,
     CHANGE COLUMN `new_duty_code` `new_duty_code` VARCHAR(500) NULL DEFAULT NULL AFTER `new_position_nm`,
     CHANGE COLUMN `new_duty_nm` `new_duty_nm` VARCHAR(500) NULL DEFAULT NULL AFTER `new_duty_code`,
     CHANGE COLUMN `old_dept_seq` `old_dept_seq` VARCHAR(500) NULL DEFAULT NULL AFTER `new_duty_nm`,
     CHANGE COLUMN `old_dept_nm` `old_dept_nm` VARCHAR(500) NULL DEFAULT NULL AFTER `old_dept_seq`,
     CHANGE COLUMN `old_dept_path_nm` `old_dept_path_nm` VARCHAR(500) NULL DEFAULT NULL AFTER `old_dept_nm`,
     CHANGE COLUMN `old_position_code` `old_position_code` VARCHAR(500) NULL DEFAULT NULL AFTER `old_dept_path_nm`,
     CHANGE COLUMN `old_position_nm` `old_position_nm` VARCHAR(500) NULL DEFAULT NULL AFTER `old_position_code`,
     CHANGE COLUMN `old_duty_code` `old_duty_code` VARCHAR(500) NULL DEFAULT NULL AFTER `old_position_nm`,
     CHANGE COLUMN `old_duty_nm` `old_duty_nm` VARCHAR(500) NULL DEFAULT NULL AFTER `old_duty_code`;
     

     
delete from tcmg_optionset where option_id like 'cm171%';

insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('cm1710', '1', 'cm', 'single', '첨부파일 확장자 설정', NULL, NULL, '1', '첨부파일업로드시제한/허용확장자를설정할수있습니다.
-미사용:업로드를제한하지않습니다.
-전체적용:제한또는허용확장자를설정할수있습니다.
-선택적용:모듈별로제한또는허용확장자를설정할수있습니다.', '0', 'option0206', NULL, NULL, NULL, '', '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);

insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('cm1711', '1', 'cm', 'single', '업로드제한/허용확장자설정', 'cm1710', '|1|', '2', '첨부파일 업로드시 제한 및 허용할 확장자를 설정 할 수 있습니다.
확장자는 다수로 입력할 수 있습니다.

- 제한 확장자
   : 업로드를 제한할 확장자명을 입력 합니다. 입력된 확장자는 업로드 할 수 없습니다. 
- 허용 확장자
   : 업로드를 허용할 확장자 명을 입력 합니다. 입력된 확장자만 업로드 할 수 있습니다.

단, 제한확장자 또는 허용확장자는 중복 설정 할 수 없으며, 선택된 설정값으로 동작합니다. 
옵션 설정값은 변경시점 이후부터 적용됩니다.', 'limit▦', 'option0207', NULL, NULL, NULL, '', '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);

insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('cm1712', '1', 'cm', 'single', '전자결재', 'cm1710', '|2|', '2', '전자결재 첨부파일 업로드시 제한 및 허용할 확장자를 설정 할 수 있습니다.
확장자는 다수로 입력할 수 있습니다.

- 제한 확장자
   : 업로드를 제한할 확장자명을 입력 합니다. 입력된 확장자는 업로드 할 수 없습니다. 
- 허용 확장자
   : 업로드를 허용할 확장자 명을 입력 합니다. 입력된 확장자만 업로드 할 수 있습니다.

단, 제한확장자 또는 허용확장자는 중복 설정 할 수 없으며, 선택된 설정값으로 동작합니다. 
옵션 설정값은 변경시점 이후부터 적용됩니다.', 'limit▦', 'option0207', NULL, NULL, NULL, '', '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);

insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('cm1713', '1', 'cm', 'single', '메일', 'cm1710', '|2|', '2', '메일 첨부파일 업로드시 제한 및 허용할 확장자를 설정 할 수 있습니다.
확장자는 다수로 입력할 수 있습니다.

- 제한 확장자
   : 업로드를 제한할 확장자명을 입력 합니다. 입력된 확장자는 업로드 할 수 없습니다. 
- 허용 확장자
   : 업로드를 허용할 확장자 명을 입력 합니다. 입력된 확장자만 업로드 할 수 있습니다.

단, 제한확장자 또는 허용확장자는 중복 설정 할 수 없으며, 선택된 설정값으로 동작합니다. 
옵션 설정값은 변경시점 이후부터 적용됩니다.', 'limit▦', 'option0207', NULL, NULL, NULL, '', '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);

insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('cm1714', '1', 'cm', 'single', '업무관리', 'cm1710', '|2|', '2', '업무관리 첨부파일 업로드시 제한 및 허용할 확장자를 설정 할 수 있습니다.
확장자는 다수로 입력할 수 있습니다.

- 제한 확장자
   : 업로드를 제한할 확장자명을 입력 합니다. 입력된 확장자는 업로드 할 수 없습니다. 
- 허용 확장자
   : 업로드를 허용할 확장자 명을 입력 합니다. 입력된 확장자만 업로드 할 수 있습니다.

단, 제한확장자 또는 허용확장자는 중복 설정 할 수 없으며, 선택된 설정값으로 동작합니다. 
옵션 설정값은 변경시점 이후부터 적용됩니다.', 'limit▦', 'option0207', NULL, NULL, NULL, '', '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);

insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('cm1715', '1', 'cm', 'single', '일정/노트', 'cm1710', '|2|', '2', '일정/노트 첨부파일 업로드시 제한 및 허용할 확장자를 설정 할 수 있습니다.
확장자는 다수로 입력할 수 있습니다.

- 제한 확장자
   : 업로드를 제한할 확장자명을 입력 합니다. 입력된 확장자는 업로드 할 수 없습니다. 
- 허용 확장자
   : 업로드를 허용할 확장자 명을 입력 합니다. 입력된 확장자만 업로드 할 수 있습니다.

단, 제한확장자 또는 허용확장자는 중복 설정 할 수 없으며, 선택된 설정값으로 동작합니다. 
옵션 설정값은 변경시점 이후부터 적용됩니다.', 'limit▦', 'option0207', NULL, NULL, NULL, '', '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);

insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('cm1716', '1', 'cm', 'single', '업무보고', 'cm1710', '|2|', '2', '업무보고 첨부파일 업로드시 제한 및 허용할 확장자를 설정 할 수 있습니다.
확장자는 다수로 입력할 수 있습니다.

- 제한 확장자
   : 업로드를 제한할 확장자명을 입력 합니다. 입력된 확장자는 업로드 할 수 없습니다. 
- 허용 확장자
   : 업로드를 허용할 확장자 명을 입력 합니다. 입력된 확장자만 업로드 할 수 있습니다.

단, 제한확장자 또는 허용확장자는 중복 설정 할 수 없으며, 선택된 설정값으로 동작합니다. 
옵션 설정값은 변경시점 이후부터 적용됩니다.', 'limit▦', 'option0207', NULL, NULL, NULL, '', '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);

insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('cm1717', '1', 'cm', 'single', '게시판', 'cm1710', '|2|', '2', '게시판 첨부파일 업로드시 제한 및 허용할 확장자를 설정 할 수 있습니다.
확장자는 다수로 입력할 수 있습니다.

- 제한 확장자
   : 업로드를 제한할 확장자명을 입력 합니다. 입력된 확장자는 업로드 할 수 없습니다. 
- 허용 확장자
   : 업로드를 허용할 확장자 명을 입력 합니다. 입력된 확장자만 업로드 할 수 있습니다.

단, 제한확장자 또는 허용확장자는 중복 설정 할 수 없으며, 선택된 설정값으로 동작합니다. 
옵션 설정값은 변경시점 이후부터 적용됩니다.', 'limit▦', 'option0207', NULL, NULL, NULL, '', '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);

insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('cm1718', '1', 'cm', 'single', '문서', 'cm1710', '|2|', '2', '문서 첨부파일 업로드시 제한 및 허용할 확장자를 설정 할 수 있습니다.
확장자는 다수로 입력할 수 있습니다.

- 제한 확장자
   : 업로드를 제한할 확장자명을 입력 합니다. 입력된 확장자는 업로드 할 수 없습니다. 
- 허용 확장자
   : 업로드를 허용할 확장자 명을 입력 합니다. 입력된 확장자만 업로드 할 수 있습니다.

단, 제한확장자 또는 허용확장자는 중복 설정 할 수 없으며, 선택된 설정값으로 동작합니다. 
옵션 설정값은 변경시점 이후부터 적용됩니다.', 'limit▦', 'option0207', NULL, NULL, NULL, '', '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);

update tcmg_optionset set use_yn = 'N' where option_id = 'cm1710' or p_option_id = 'cm1710';     

     



update tcmg_optionset set option_nm_en = 'Approved Date Display Format' where option_id = 'ea501';
update tcmg_optionset set option_nm_en = 'Authorizer setting to convert official documents' where option_id = 'ea191';
update tcmg_optionset set option_nm_en = 'Board' where option_id = 'appPathSeq500';
update tcmg_optionset set option_nm_en = 'Capacity restriction for the attached file of chat room' where option_id = 'app301';
update tcmg_optionset set option_nm_en = 'Capacity restriction for the attached file of chat room' where option_id = 'msg910';
update tcmg_optionset set option_nm_en = 'Capacity restriction of attached file per the note' where option_id = 'app201';
update tcmg_optionset set option_nm_en = 'Capacity restriction of attached file per the note' where option_id = 'msg810';
update tcmg_optionset set option_nm_en = 'Chat Room' where option_id = 'appPathSeq800';
update tcmg_optionset set option_nm_en = 'Common comment settings' where option_id = 'cm1750';
update tcmg_optionset set option_nm_en = 'Department/staff viewing method' where option_id = 'msg500';
update tcmg_optionset set option_nm_en = 'Display job title/position on organization chart' where option_id = 'cm1900';
update tcmg_optionset set option_nm_en = 'Document' where option_id = 'appPathSeq600';
update tcmg_optionset set option_nm_en = 'E-approval' where option_id = 'appPathSeqEa';
update tcmg_optionset set option_nm_en = 'Fax' where option_id = 'appPathSeq1200';
update tcmg_optionset set option_nm_en = 'Function for the attachment of note file' where option_id = 'app200';
update tcmg_optionset set option_nm_en = 'Function for the attachment of note file' where option_id = 'msg800';
update tcmg_optionset set option_nm_en = 'Function for the selection of messenger automatic log in' where option_id = 'msg100';
update tcmg_optionset set option_nm_en = 'Function for the sending of file while conversing' where option_id = 'app300';
update tcmg_optionset set option_nm_en = 'Function for the sending of file while conversing' where option_id = 'msg900';
update tcmg_optionset set option_nm_en = 'Function of reserved note' where option_id = 'app100';
update tcmg_optionset set option_nm_en = 'Function of reserved note' where option_id = 'msg600';
update tcmg_optionset set option_nm_en = 'Mail' where option_id = 'appPathSeq700';
update tcmg_optionset set option_nm_en = 'Menu tree open settings' where option_id = 'cm1600';
update tcmg_optionset set option_nm_en = 'Opening the URL link' where option_id = 'msg400';
update tcmg_optionset set option_nm_en = 'Password check at time of linking the groupware' where option_id = 'msg300';
update tcmg_optionset set option_nm_en = 'Password entry rule settings' where option_id = 'cm203';
update tcmg_optionset set option_nm_en = 'Processing at time of double clicking the other party' where option_id = 'msg1400';
update tcmg_optionset set option_nm_en = 'Restricted value settings for password entry' where option_id = 'cm204';
update tcmg_optionset set option_nm_en = 'Salary statement inquiry method' where option_id = 'cm2100';
update tcmg_optionset set option_nm_en = 'Select a position/title.' where option_id = 'cm1110';
update tcmg_optionset set option_nm_en = 'Selection of messenger automatic going to the office processing is possible' where option_id = 'msg200';
update tcmg_optionset set option_nm_en = 'Setting (1) the viewing method of staff' where option_id = 'msg1200';
update tcmg_optionset set option_nm_en = 'Setting (2) the viewing method of staff' where option_id = 'msg1300';
update tcmg_optionset set option_nm_en = 'Setting for the viewing of attached file of mobile' where option_id = 'app400';
update tcmg_optionset set option_nm_en = 'Setting for the viewing of attached file of mobile' where option_id = 'app600';
update tcmg_optionset set option_nm_en = 'Setting the expiration time limit of password' where option_id = 'cm201';
update tcmg_optionset set option_nm_en = 'Setting the skin color' where option_id = 'msg1500';
update tcmg_optionset set option_nm_en = 'Settings of count use by menu' where option_id = 'cm1500';
update tcmg_optionset set option_nm_en = 'Signature image' where option_id = 'cm1002';
update tcmg_optionset set option_nm_en = 'Task management' where option_id = 'appPathSeq300';
update tcmg_optionset set option_nm_en = 'Task Reports' where option_id = 'appPathSeq1300';
update tcmg_optionset set option_nm_en = 'The possible number of detailed pop up reading  of chat room' where option_id = 'msg920';
update tcmg_optionset set option_nm_en = 'Uploader settings' where option_id = 'cm400';
update tcmg_optionset set option_nm_en = 'Use of automatic attendance' where option_id = 'cm1400';




update tcmg_optionset set option_nm_jp = '決裁日付表示形式設定' where option_id = 'ea501';
update tcmg_optionset set option_nm_jp = '公文変換の権限者設定' where option_id = 'ea191';
update tcmg_optionset set option_nm_jp = '掲示板' where option_id = 'appPathSeq500';
update tcmg_optionset set option_nm_jp = 'チャットルームの添付ファイル容量制限' where option_id = 'app301';
update tcmg_optionset set option_nm_jp = 'チャットルームの添付ファイル容量制限' where option_id = 'msg910';
update tcmg_optionset set option_nm_jp = 'メッセージあたりの添付ファイル容量制限' where option_id = 'app201';
update tcmg_optionset set option_nm_jp = 'メッセージあたりの添付ファイル容量制限' where option_id = 'msg810';
update tcmg_optionset set option_nm_jp = 'チャットルーム' where option_id = 'appPathSeq800';
update tcmg_optionset set option_nm_jp = '共通コメント設定' where option_id = 'cm1750';
update tcmg_optionset set option_nm_jp = '部署/社員見方' where option_id = 'msg500';
update tcmg_optionset set option_nm_jp = '組織図の職級/職責表示' where option_id = 'cm1900';
update tcmg_optionset set option_nm_jp = '文書' where option_id = 'appPathSeq600';
update tcmg_optionset set option_nm_jp = '電子決裁' where option_id = 'appPathSeqEa';
update tcmg_optionset set option_nm_jp = 'FAX' where option_id = 'appPathSeq1200';
update tcmg_optionset set option_nm_jp = 'メッセージのファイル添付機能' where option_id = 'app200';
update tcmg_optionset set option_nm_jp = 'メッセージのファイル添付機能' where option_id = 'msg800';
update tcmg_optionset set option_nm_jp = 'メッセンジャーの自動ログインの選択機能' where option_id = 'msg100';
update tcmg_optionset set option_nm_jp = '会話中のファイル送信機能' where option_id = 'app300';
update tcmg_optionset set option_nm_jp = '会話中のファイル送信機能' where option_id = 'msg900';
update tcmg_optionset set option_nm_jp = '予約メッセージ機能' where option_id = 'app100';
update tcmg_optionset set option_nm_jp = '予約メッセージ機能' where option_id = 'msg600';
update tcmg_optionset set option_nm_jp = 'メール' where option_id = 'appPathSeq700';
update tcmg_optionset set option_nm_jp = 'メニュートリのopen設定' where option_id = 'cm1600';
update tcmg_optionset set option_nm_jp = 'URLリンクを開く' where option_id = 'msg400';
update tcmg_optionset set option_nm_jp = 'グループウェアリンクの際、パスワードチェック' where option_id = 'msg300';
update tcmg_optionset set option_nm_jp = 'パスワード入力規則の設定' where option_id = 'cm203';
update tcmg_optionset set option_nm_jp = '相手をダブルクリックして処理' where option_id = 'msg1400';
update tcmg_optionset set option_nm_jp = 'パスワード入力制限値の設定' where option_id = 'cm204';
update tcmg_optionset set option_nm_jp = '給料明細書の照会方式の設定' where option_id = 'cm2100';
update tcmg_optionset set option_nm_jp = '職責/肩書選択' where option_id = 'cm1110';
update tcmg_optionset set option_nm_jp = 'メッセンジャーの自動出勤処理の選択機能' where option_id = 'msg200';
update tcmg_optionset set option_nm_jp = '社員表示タイプ設定(１)' where option_id = 'msg1200';
update tcmg_optionset set option_nm_jp = '社員表示タイプ設定(２)' where option_id = 'msg1300';
update tcmg_optionset set option_nm_jp = 'モバイルの添付ファイルの表示設定' where option_id = 'app400';
update tcmg_optionset set option_nm_jp = 'モバイルの添付ファイルの表示設定' where option_id = 'app600';
update tcmg_optionset set option_nm_jp = 'パスワード満了期限設定' where option_id = 'cm201';
update tcmg_optionset set option_nm_jp = '背景のカラーの設定' where option_id = 'msg1500';
update tcmg_optionset set option_nm_jp = 'メニュー別カウント使用の設定' where option_id = 'cm1500';
update tcmg_optionset set option_nm_jp = 'サイン·イメージ' where option_id = 'cm1002';
update tcmg_optionset set option_nm_jp = '業務管理' where option_id = 'appPathSeq300';
update tcmg_optionset set option_nm_jp = '業務報告' where option_id = 'appPathSeq1300';
update tcmg_optionset set option_nm_jp = 'チャットルームの詳細ポップアップ閲覧可能な個数' where option_id = 'msg920';
update tcmg_optionset set option_nm_jp = 'アップローダ設定' where option_id = 'cm400';
update tcmg_optionset set option_nm_jp = '自動出勤機能の使用有無' where option_id = 'cm1400';





update tcmg_optionset set option_nm_cn = '设定审批日期表示形式' where option_id = 'ea501';
update tcmg_optionset set option_nm_cn = '设置转换公文权限者' where option_id = 'ea191';
update tcmg_optionset set option_nm_cn = '留言板' where option_id = 'appPathSeq500';
update tcmg_optionset set option_nm_cn = '聊天室附件的容量限制' where option_id = 'app301';
update tcmg_optionset set option_nm_cn = '聊天室附件的容量限制' where option_id = 'msg910';
update tcmg_optionset set option_nm_cn = '各纸条附件的容量限制' where option_id = 'app201';
update tcmg_optionset set option_nm_cn = '各纸条附件的容量限制' where option_id = 'msg810';
update tcmg_optionset set option_nm_cn = '聊天室' where option_id = 'appPathSeq800';
update tcmg_optionset set option_nm_cn = '同样回复设置' where option_id = 'cm1750';
update tcmg_optionset set option_nm_cn = '查看部门/职员方式' where option_id = 'msg500';
update tcmg_optionset set option_nm_cn = '显示组织图职位/职责' where option_id = 'cm1900';
update tcmg_optionset set option_nm_cn = '文件 ' where option_id = 'appPathSeq600';
update tcmg_optionset set option_nm_cn = '电子审批' where option_id = 'appPathSeqEa';
update tcmg_optionset set option_nm_cn = '传真' where option_id = 'appPathSeq1200';
update tcmg_optionset set option_nm_cn = '附加纸条文件功能' where option_id = 'app200';
update tcmg_optionset set option_nm_cn = '附加纸条文件功能' where option_id = 'msg800';
update tcmg_optionset set option_nm_cn = '选择MSN自动登录功能' where option_id = 'msg100';
update tcmg_optionset set option_nm_cn = '聊天中发送文件功能' where option_id = 'app300';
update tcmg_optionset set option_nm_cn = '聊天中发送文件功能' where option_id = 'msg900';
update tcmg_optionset set option_nm_cn = '预约纸条功能' where option_id = 'app100';
update tcmg_optionset set option_nm_cn = '预约纸条功能' where option_id = 'msg600';
update tcmg_optionset set option_nm_cn = '邮件' where option_id = 'appPathSeq700';
update tcmg_optionset set option_nm_cn = '设置打开主菜单' where option_id = 'cm1600';
update tcmg_optionset set option_nm_cn = '打开URL链接' where option_id = 'msg400';
update tcmg_optionset set option_nm_cn = '链接群组系统时确认密码' where option_id = 'msg300';
update tcmg_optionset set option_nm_cn = '设置密码输入规则' where option_id = 'cm203';
update tcmg_optionset set option_nm_cn = '对方双击时处理' where option_id = 'msg1400';
update tcmg_optionset set option_nm_cn = '设置密码输入限定值' where option_id = 'cm204';
update tcmg_optionset set option_nm_cn = '设置工资单查询方式' where option_id = 'cm2100';
update tcmg_optionset set option_nm_cn = '选择职责/职位' where option_id = 'cm1110';
update tcmg_optionset set option_nm_cn = '选择MSN自动处理上班的功能' where option_id = 'msg200';
update tcmg_optionset set option_nm_cn = '设定职员查看方式 (1)' where option_id = 'msg1200';
update tcmg_optionset set option_nm_cn = '设定职员查看方式(2)' where option_id = 'msg1300';
update tcmg_optionset set option_nm_cn = '查看手机附件设定' where option_id = 'app400';
update tcmg_optionset set option_nm_cn = '查看手机附件设定' where option_id = 'app600';
update tcmg_optionset set option_nm_cn = '设定密码期满期限' where option_id = 'cm201';
update tcmg_optionset set option_nm_cn = '设定皮肤颜色' where option_id = 'msg1500';
update tcmg_optionset set option_nm_cn = '设置使用各菜单计数' where option_id = 'cm1500';
update tcmg_optionset set option_nm_cn = '签字图像' where option_id = 'cm1002';
update tcmg_optionset set option_nm_cn = '业务管理' where option_id = 'appPathSeq300';
update tcmg_optionset set option_nm_cn = '业务报告' where option_id = 'appPathSeq1300';
update tcmg_optionset set option_nm_cn = '可以阅览聊天室详细弹出窗口的数量' where option_id = 'msg920';
update tcmg_optionset set option_nm_cn = '设置上传' where option_id = 'cm400';
update tcmg_optionset set option_nm_cn = '是否使用自动出勤' where option_id = 'cm1400';


update tcmg_optionset set option_desc_en = 'An authorizer can be specified to convert approved documents to official ones. When the authorizer opens the details of approved documents, the feature of [Conversion to Official Document] will be dis' where option_id = 'ea191';
update tcmg_optionset set option_desc_en = 'Birthdate can be edited in groupware.' where option_id = 'cm1105';
update tcmg_optionset set option_desc_en = 'For edited user items, you can set whether to modify the contents only in GW or reflect the changes in ERP.' where option_id = 'cm1104';
update tcmg_optionset set option_desc_en = 'Home addresses can be edited in groupware.' where option_id = 'cm1108';
update tcmg_optionset set option_desc_en = 'If you use the control option, you can set detailed options.' where option_id = 'cm100';
update tcmg_optionset set option_desc_en = 'Select one of the positions/titles when the ERP organization chart is interlocked (selectable only for IU; ICUBE only has position values).' where option_id = 'cm1110';
update tcmg_optionset set option_desc_en = 'Select the information to be displayed from the department items of the list.' where option_id = 'cm702';
update tcmg_optionset set option_desc_en = 'Select the range of information that you want to display on the groupware portal (e.g. Company - Department - Team - User''s name)' where option_id = 'cm701';
update tcmg_optionset set option_desc_en = 'Select the required character combination for your password. The selected character combination will be checked when changing the password (multi-selectable).' where option_id = 'cm203';
update tcmg_optionset set option_desc_en = 'Select the restriction items when setting your password. After entering the selected restriction items, you cannot change them when changing the password. The administrator is not limited (multi-selec' where option_id = 'cm204';
update tcmg_optionset set option_desc_en = 'Select the restriction items when setting your password. After entering the selected restriction items, you cannot change them when changing the password. The administrator is not limited (multi-selec' where option_id = 'cm205';
update tcmg_optionset set option_desc_en = 'Set the criteria for displaying the position/title of users in the organization.' where option_id = 'cm1900';
update tcmg_optionset set option_desc_en = 'Set the default depth view on the screen where organization charts are displayed.' where option_id = 'cm600';
update tcmg_optionset set option_desc_en = 'Set the default value of ID to be created when registering GW user.' where option_id = 'cm1102';
update tcmg_optionset set option_desc_en = 'Set the depth of board menu tree.' where option_id = 'cm1603';
update tcmg_optionset set option_desc_en = 'Set the depth of document menu tree.' where option_id = 'cm1604';
update tcmg_optionset set option_desc_en = 'Set the depth of e-approval menu tree.' where option_id = 'cm1601';
update tcmg_optionset set option_desc_en = 'Set the depth of personnel/attendance menu tree.' where option_id = 'cm1605';
update tcmg_optionset set option_desc_en = 'Set the depth of schedule menu tree.' where option_id = 'cm1602';
update tcmg_optionset set option_desc_en = 'Set the depth of the left menu tree (0: Open the whole tree).' where option_id = 'cm1600';
update tcmg_optionset set option_desc_en = 'Set the display options for the area where departments are displayed. If enabled, you can set detailed options.' where option_id = 'cm700';
update tcmg_optionset set option_desc_en = 'Set the minimum or maximum entry value of a password (min: 4 / max: 16).' where option_id = 'cm202';
update tcmg_optionset set option_desc_en = 'Set viewer and download options for attachments (if you use only the document viewer, you cannot download attachments).' where option_id = 'cm500';
update tcmg_optionset set option_desc_en = 'Set whether or not to check for automatic attendance at login.' where option_id = 'cm1400';
update tcmg_optionset set option_desc_en = 'Set whether or not to display the count for each menu.' where option_id = 'cm1500';
update tcmg_optionset set option_desc_en = 'Set whether or not to display the count of bulletin board menu.' where option_id = 'cm1502';
update tcmg_optionset set option_desc_en = 'Set whether or not to display the count of business report menu.' where option_id = 'cm1503';
update tcmg_optionset set option_desc_en = 'Set whether to display the count of e-approval menu.' where option_id = 'cm1501';
update tcmg_optionset set option_desc_en = 'Set whether to search salary statements by salary category (salary, bonus, etc.) or monthly group.' where option_id = 'cm2100';
update tcmg_optionset set option_desc_en = 'Telephone numbers (home and mobile) can be edited in groupware.' where option_id = 'cm1107';
update tcmg_optionset set option_desc_en = 'The ERP organization chart can be used by being interlocked in GW. (organization chart is controlled at ERP.) (iCUBE/iU)' where option_id = 'cm1100';
update tcmg_optionset set option_desc_en = 'Usernames can be edited in groupware.' where option_id = 'cm1109';
update tcmg_optionset set option_desc_en = 'Users can create and manage their company address list at My Page> Manage Address List Management>Register Address List.' where option_id = 'com400';
update tcmg_optionset set option_desc_en = 'Users: Show/Do not show their workplace. Managers: Check/Uncheck the checkbox for workplace on the top of organization information management.' where option_id = 'cm800';
update tcmg_optionset set option_desc_en = 'Wedding anniversary can be edited in groupware.' where option_id = 'cm1106';
update tcmg_optionset set option_desc_en = 'When an ERP organization chart is interlinked, additional organizations can be registered in groupware. However, the organizations (department) can be interworked only by mapping the ERP code of their' where option_id = 'cm1101';
update tcmg_optionset set option_desc_en = 'You can download attachment from chat rooms, or use the document viewer to check the content.' where option_id = 'appPathSeq800';
update tcmg_optionset set option_desc_en = 'You can download attachment from the board menu, or use the document viewer to check the content.' where option_id = 'appPathSeq500';
update tcmg_optionset set option_desc_en = 'You can download attachment from the board menu, or use the document viewer to check the content.' where option_id = 'pathSeq500';
update tcmg_optionset set option_desc_en = 'You can download attachment from the mail menu, or use the document viewer to check the content.' where option_id = 'appPathSeq700';
update tcmg_optionset set option_desc_en = 'You can download attachments from messages, or use the document viewer to check the content.' where option_id = 'appPathSeq810';
update tcmg_optionset set option_desc_en = 'You can download attachments from the business management menu, or use the document viewer to check the content.' where option_id = 'appPathSeq300';
update tcmg_optionset set option_desc_en = 'You can download attachments from the document menu, or use the document viewer to check the content.' where option_id = 'appPathSeq600';
update tcmg_optionset set option_desc_en = 'You can download attachments from the fax, or use the document viewer to check the content.' where option_id = 'appPathSeq1200';
update tcmg_optionset set option_desc_en = 'You can download attachments from the fax, or use the document viewer to check the content.' where option_id = 'pathSeq1200';
update tcmg_optionset set option_desc_en = 'You can download attachments from the schedule menu, or use the document viewer to check the content.' where option_id = 'appPathSeq400';
update tcmg_optionset set option_desc_en = 'You can set whether or not to edit the user items. If you do not use this feature, the items cannot be edited in GW, but in ERP.' where option_id = 'cm1103';


update tcmg_optionset set option_desc_jp = '決裁完了した文書に対して公文に変換できる権限者を設定することができます。 設定された権限者によって,決裁文書の詳細オープン時に,[公文変換] 機能が提供されます。
' where option_id = 'ea191';
update tcmg_optionset set option_desc_jp = 'グループウェアで生年月日情報を修正することができます。' where option_id = 'cm1105';
update tcmg_optionset set option_desc_jp = '修正したユーザ項目に対して,修正内容をGWのみで管理するか,ERP に修正した内容を反映させるかを設定することができる。' where option_id = 'cm1104';
update tcmg_optionset set option_desc_jp = 'グループウェアで自宅住所の情報を修正することができます。' where option_id = 'cm1108';
update tcmg_optionset set option_desc_jp = '統制オプションを使用する場合,詳細オプションを設定することができます。' where option_id = 'cm100';
update tcmg_optionset set option_desc_jp = 'ERP組織図連動時,職責/肩書のいずれかを選択します。(IUである場合選択できる,ICUBEは職責値のみ存在)' where option_id = 'cm1110';
update tcmg_optionset set option_desc_jp = 'リストの部署項目に表示される情報を選択します。' where option_id = 'cm702';
update tcmg_optionset set option_desc_jp = 'グループウェアポータルに表示するユーザーの情報範囲を選択します(例:会社-部署-チーム-ホン・ギルドン)。' where option_id = 'cm701';
update tcmg_optionset set option_desc_jp = 'パスワードに必須の文字の組合せを選択します。選択した文字の組合せは,パスワードを変更するときに必須項目としてチェックされます。(マルチ選択可能)' where option_id = 'cm203';
update tcmg_optionset set option_desc_jp = 'パスワードの設定時,入力制限項目を選択します。 選択した制限項目を入力した後,パスワードを変更するときに変更されません。 管理者は制限しません。(マルチ選択可能)' where option_id = 'cm204';
update tcmg_optionset set option_desc_jp = 'パスワードの設定時,入力制限項目を選択します。 選択した制限項目を入力した後,パスワードを変更するときに変更されません。 管理者は制限しません。(マルチ選択可能)' where option_id = 'cm205';
update tcmg_optionset set option_desc_jp = '組織図のユーザの職級/職責の表示基準を設定する。' where option_id = 'cm1900';
update tcmg_optionset set option_desc_jp = '組織図が提供される画面で,基本depth 表示を設定します。' where option_id = 'cm600';
update tcmg_optionset set option_desc_jp = 'GWユーザ登録時に生成するIDの基本値を設定する。' where option_id = 'cm1102';
update tcmg_optionset set option_desc_jp = '掲示板 メニュートリ- のDepthを設定します。' where option_id = 'cm1603';
update tcmg_optionset set option_desc_jp = '文書 メニュートリ- のDepthを設定します。' where option_id = 'cm1604';
update tcmg_optionset set option_desc_jp = '電子決裁メニューツリー Depthを設定します。' where option_id = 'cm1601';
update tcmg_optionset set option_desc_jp = '人事/勤怠メニューリーDepthを設定します。' where option_id = 'cm1605';
update tcmg_optionset set option_desc_jp = 'スケジュールメニューツリーの Depthを設定します。' where option_id = 'cm1602';
update tcmg_optionset set option_desc_jp = '左のメニューツリーdepthを設定します。 (0:全体ツリーオープン)' where option_id = 'cm1600';
update tcmg_optionset set option_desc_jp = '部署が表示される領域の表示オプションを設定します。 使用の場合,詳細オプションを設定することができます。' where option_id = 'cm700';
update tcmg_optionset set option_desc_jp = 'パスワードの最小または最大入力値を設定します。(min:4/max:16)' where option_id = 'cm202';
update tcmg_optionset set option_desc_jp = '添付ファイルのビューアーおよびダウンロードオプションを設定します。' where option_id = 'cm500';
update tcmg_optionset set option_desc_jp = 'ログイン時に自動出勤チェックするかどうかを設定します。' where option_id = 'cm1400';
update tcmg_optionset set option_desc_jp = 'メニュー別カウント表示有無を設定します。' where option_id = 'cm1500';
update tcmg_optionset set option_desc_jp = '掲示板 メニューの カウント表示有無を設定します。' where option_id = 'cm1502';
update tcmg_optionset set option_desc_jp = '業務報告メニューのカウント表示有無を設定します。' where option_id = 'cm1503';
update tcmg_optionset set option_desc_jp = '電子決裁メニューのカウント表示有無を設定します。' where option_id = 'cm1501';
update tcmg_optionset set option_desc_jp = '給料明細書の照会時,給料区分別(給料,ボーナスなど)で照会するか,月単位でまとめて照会するかを設定します。' where option_id = 'cm2100';
update tcmg_optionset set option_desc_jp = 'グループウェアで電話番号(自宅,携帯電話)情報を修正することができます。' where option_id = 'cm1107';
update tcmg_optionset set option_desc_jp = 'ERP 組織図をGWに連動して使用することができる。(組織図はERPでコントロールする。)(iCUBE/iU)' where option_id = 'cm1100';
update tcmg_optionset set option_desc_jp = 'グループウェアでユーザー名を修正することができます。' where option_id = 'cm1109';
update tcmg_optionset set option_desc_jp = '使用者がマイページ>住所録管理>住所録グループ登録内の会社住所録グループ生成および管理することができます。' where option_id = 'com400';
update tcmg_optionset set option_desc_jp = 'ユーザ:事務所を表示/不表示します。 管理者:組織図情報の管理　
上段に事務所の表示チェックボックス基本チェック/なし処理します。' where option_id = 'cm800';
update tcmg_optionset set option_desc_jp = 'グループウェアで結婚記念日の情報を修正することができます。' where option_id = 'cm1106';
update tcmg_optionset set option_desc_jp = 'ERP組織図連動時,グループウェアに追加組織図を登録することができる。 但し,登録した組織図(部署)は上位部署のERPコードを別にマップしてから連動できる。' where option_id = 'cm1101';
update tcmg_optionset set option_desc_jp = 'チャットルームで添付ファイルのダウンロード,または文書ビューアーによるすぐ表示機能を使用することができます。' where option_id = 'appPathSeq800';
update tcmg_optionset set option_desc_jp = '掲示板メニューの添付ファイルのダウンロード,または文書ビューアーによるすぐ表示機能を使用することができます。' where option_id = 'appPathSeq500';
update tcmg_optionset set option_desc_jp = '掲示板メニューの添付ファイルのダウンロード,または文書ビューアーによるすぐ表示機能を使用することができます。' where option_id = 'pathSeq500';
update tcmg_optionset set option_desc_jp = 'メールメニューの添付ファイルのダウンロード,または文書ビューアーによるすぐ表示機能を使用することができます。' where option_id = 'appPathSeq700';
update tcmg_optionset set option_desc_jp = 'メッセージで添付ファイルのダウンロード,または文書ビューアーによるすぐ表示機能を使用することができます。' where option_id = 'appPathSeq810';
update tcmg_optionset set option_desc_jp = '業務管理メニューの添付ファイルのダウンロードまたは文書ビューアによるすぐ表示機能を使用することができます。' where option_id = 'appPathSeq300';
update tcmg_optionset set option_desc_jp = '文書メニューの添付ファイルのダウンロード,または文書ビューアーによるすぐ表示機能を使用することができます。' where option_id = 'appPathSeq600';
update tcmg_optionset set option_desc_jp = 'ファクスで添付ファイルのダウンロード,または文書ビューアによるすぐ表示機能を使用することができます。' where option_id = 'appPathSeq1200';
update tcmg_optionset set option_desc_jp = 'ファクスで添付ファイルのダウンロード,または文書ビューアによるすぐ表示機能を使用することができます。' where option_id = 'pathSeq1200';
update tcmg_optionset set option_desc_jp = '日程メニューの添付ファイルのダウンロード,または文書ビューアーによるすぐ表示機能を使用することができます。' where option_id = 'appPathSeq400';
update tcmg_optionset set option_desc_jp = 'ユーザ項目の修正を設定することができる。使用しない場合は,GWではユーザ項目を修正することはできず,ERPで修正して反映しなければならない。' where option_id = 'cm1103';






update tcmg_optionset set option_desc_cn = '可设置对已审批的文件可以转换为公文的权限者。根据被设置的权限者，详细打开审批文件时，提供[转换公文]功能。' where option_id = 'ea191';
update tcmg_optionset set option_desc_cn = '在OA系统上可以修改生年月日信息。' where option_id = 'cm1105';
update tcmg_optionset set option_desc_cn = '对修改的用户项目，设置是否只在GW上管理修改内容，还是将修改的内容反映在ERP上。' where option_id = 'cm1104';
update tcmg_optionset set option_desc_cn = '在OA系统上可以修改家地址信息。' where option_id = 'cm1108';
update tcmg_optionset set option_desc_cn = '使用控制选项时可以设置详细选项。' where option_id = 'cm100';
update tcmg_optionset set option_desc_cn = '选择联动ERP组织图时的职责/职位中一个。(IU时可选，ICUBE只存在职责值)' where option_id = 'cm1110';
update tcmg_optionset set option_desc_cn = '选择列表的部门项目上显示的信息。' where option_id = 'cm702';
update tcmg_optionset set option_desc_cn = '选择在OA系统网站上要显示的用户信息范围。(例：公司-部门-组-洪吉童)' where option_id = 'cm701';
update tcmg_optionset set option_desc_cn = '选择密码上必须使用的文字组合。所选的文字组合在修改密码时必须得确认。(可以多选)' where option_id = 'cm203';
update tcmg_optionset set option_desc_cn = '设置密码时选择输入限制项目。输入所选的限制项目后无法修改密码，但不限制管理者。(可以多选)' where option_id = 'cm204';
update tcmg_optionset set option_desc_cn = '设置密码时选择输入限制项目。输入所选的限制项目后无法修改密码，但不限制管理者。(可以多选)' where option_id = 'cm205';
update tcmg_optionset set option_desc_cn = '设置组织图内用户的职位/职责的显示标准。' where option_id = 'cm1900';
update tcmg_optionset set option_desc_cn = '提供组织图的画面上设置基本depth查看。' where option_id = 'cm600';
update tcmg_optionset set option_desc_cn = '设置登录GW用户时要生成的ID基本值。' where option_id = 'cm1102';
update tcmg_optionset set option_desc_cn = '设置留言板菜单Depth。' where option_id = 'cm1603';
update tcmg_optionset set option_desc_cn = '设置文件菜单Depth。' where option_id = 'cm1604';
update tcmg_optionset set option_desc_cn = '设置电子审批菜单Depth。' where option_id = 'cm1601';
update tcmg_optionset set option_desc_cn = '设置人事/出勤菜单Depth。' where option_id = 'cm1605';
update tcmg_optionset set option_desc_cn = '设置日程菜单Depth。' where option_id = 'cm1602';
update tcmg_optionset set option_desc_cn = '设置左侧菜单depth。(0 : 打开全部菜单)' where option_id = 'cm1600';
update tcmg_optionset set option_desc_cn = '设置显示部门领域的显示选项。使用时可以设置详细选项。' where option_id = 'cm700';
update tcmg_optionset set option_desc_cn = '可以设置密码的最少或者最多输入值。(min:4 / max:16)' where option_id = 'cm202';
update tcmg_optionset set option_desc_cn = '设置对附件的阅览及下载选项。(只使用文件阅览时不能下载附件。)' where option_id = 'cm500';
update tcmg_optionset set option_desc_cn = '设置登录时是否自动确认出勤。' where option_id = 'cm1400';
update tcmg_optionset set option_desc_cn = '设置是否显示各菜单计数。' where option_id = 'cm1500';
update tcmg_optionset set option_desc_cn = '设置是否显示留言板菜单计数。' where option_id = 'cm1502';
update tcmg_optionset set option_desc_cn = '设置是否显示业务报告菜单计数。' where option_id = 'cm1503';
update tcmg_optionset set option_desc_cn = '设置是否显示电子审批菜单计数。' where option_id = 'cm1501';
update tcmg_optionset set option_desc_cn = '查询工资单时，设置按工资区分(工资、奖金等)来查询，还是按月来查询。' where option_id = 'cm2100';
update tcmg_optionset set option_desc_cn = '在OA系统上可以修改电话号码(家、手机)信息。' where option_id = 'cm1107';
update tcmg_optionset set option_desc_cn = '可以联动ERP组织图而使用。(在ERP上控制组织图) (iCUBE/iU)' where option_id = 'cm1100';
update tcmg_optionset set option_desc_cn = '在OA系统上可以修改用户名。' where option_id = 'cm1109';
update tcmg_optionset set option_desc_cn = '用户在我的主页〉地址簿管理〉地址簿群组登录内，可以生成或管理公司地址簿群组' where option_id = 'com400';
update tcmg_optionset set option_desc_cn = '用户：显示/未显示营业场所。管理者：处理组织图信息管理上端上是否默认显示/未显示营业场所。' where option_id = 'cm800';
update tcmg_optionset set option_desc_cn = '在OA系统上可以修改结婚纪念日信息。' where option_id = 'cm1106';
update tcmg_optionset set option_desc_cn = '联动ERP组织图时，在OA系统上可以登录其他组织图。但是，登录的组织图(部门)必须额外连接上级部门的ERP代码才能联动。' where option_id = 'cm1101';
update tcmg_optionset set option_desc_cn = '通过聊天室上下载附件或者文件阅览器，可以使用快捷键功能。' where option_id = 'appPathSeq800';
update tcmg_optionset set option_desc_cn = '通过下载留言板菜单上的附件或者文件阅览器，可以使用快捷键功能。' where option_id = 'appPathSeq500';
update tcmg_optionset set option_desc_cn = '通过下载留言板菜单上的附件或者文件阅览器，可以使用快捷键功能。' where option_id = 'pathSeq500';
update tcmg_optionset set option_desc_cn = '通过下载邮件菜单上的附件或者文件阅览器，可以使用快捷键功能。' where option_id = 'appPathSeq700';
update tcmg_optionset set option_desc_cn = '通过纸条上下载附件或者文件阅览器，可以使用快捷键功能。' where option_id = 'appPathSeq810';
update tcmg_optionset set option_desc_cn = '通过下载业务管理菜单上的附件或者文件阅览器，可以使用快捷键功能。' where option_id = 'appPathSeq300';
update tcmg_optionset set option_desc_cn = '通过下载文件菜单上的附件或者文件阅览器，可以使用快捷键功能。' where option_id = 'appPathSeq600';
update tcmg_optionset set option_desc_cn = '通过传真上下载附件或者文件阅览器，可以使用快捷键功能。' where option_id = 'appPathSeq1200';
update tcmg_optionset set option_desc_cn = '通过传真上下载附件或者文件阅览器，可以使用快捷键功能。' where option_id = 'pathSeq1200';
update tcmg_optionset set option_desc_cn = '通过下载一定菜单上的附件或者文件阅览器，可以使用快捷键功能。' where option_id = 'appPathSeq400';
update tcmg_optionset set option_desc_cn = '可以设置是否要修改用户项目。未使用时无法修改GW上的用户项目，必须在ERP上修改而反映。' where option_id = 'cm1103';


insert ignore into t_co_Code_detail_multi values('바탕체','option0080','en','Batang font ','Batang font ','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('바탕','option0080','en','Batang','Batang','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('맑은 고딕','option0080','en','Clear gothic ','Clear gothic ','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('돋움체','option0080','en','Dodum font','Dodum font','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('돋움','option0080','en','Dotum','Dotum','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('궁서체','option0080','en','Gunseo font','Gunseo font','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('궁서','option0080','en','Gunseo','Gunseo','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('굴림체','option0080','en','Rolling style printing type','Rolling style printing type','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('굴림','option0080','en','Gullim','Gullim','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('Y','ex00028','en','Yes','Yes','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('Y','ex00004','en','Yes','Yes','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('Y','ERP022','en','','','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('useyn','cm0103','en','Use or not','Use or not','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('useyn','cm0102','en','Use or not','Use or not','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('TITLE(FORMNM:DOCNO)','ex00013','en','Document title (Format name : document number) - 100 words','Document title (Format name : document number) - 100 words','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('TITLE(DOCNO)','ex00013','en','Document title (Document number) - 100 words','Document title (Document number) - 100 words','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('summaryName','ex00003','en','Name of abstract','Name of abstract','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('summaryCode','ex00003','en','Scalar Code','Scalar Code','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('status','cm0101','en','Progress','Progress','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('SM','ex00005','en','Journal + management','Journal + management','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('S','ATT0021','en','Commencement of approval','Commencement of approval','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('RS002','COM510','en','Alert Approving Meeting Rooms','Alert Approving Meeting Rooms','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('p1_5','ex00014','en','5th day of next month','5th day of next month','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('p1_31','ex00014','en','31st day of next month (last day)','31st day of next month (last day)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('p1_25','ex00014','en','25th day of next month','25th day of next month','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('p1_20','ex00014','en','20th day of next month','20th day of next month','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('p1_15','ex00014','en','15th day of next month','15th day of next month','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('p1_10','ex00014','en','10th day of next month','10th day of next month','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('p0_p0','ex00014','en','Today','Today','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('p0_5','ex00014','en','5th day of this month','5th day of this month','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('p0_31','ex00014','en','31st day of this month (last day)','31st day of this month (last day)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('p0_25','ex00014','en','25th day of this month','25th day of this month','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('p0_20','ex00014','en','20th day of this month','20th day of this month','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('p0_15','ex00014','en','15th day of this month','15th day of this month','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('p0_10','ex00014','en','10th day of this month','10th day of this month','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('O','ATT0021','en','Termination of approval','Termination of approval','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('N','MobileWorkCheck','en','No','No','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('N','mentionUseYn','en','N','N','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('N','ex00028','en','No','No','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('N','ex00004','en','No','No','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('N','ex00001','en','No','No','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('N','AttTime','en','Yes','Yes','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('N','ATT0022','en','Before the closure','Before the closure','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('MENTION','ALARAM','en','Alpha mention','Alpha mention','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('m1_5','ex00014','en','5th day of previous month','5th day of previous month','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('m1_31','ex00014','en','31st day of previous month (last day)','31st day of previous month (last day)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('m1_25','ex00014','en','25th day of previous month','25th day of previous month','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('m1_20','ex00014','en','20th day of previous month','20th day of previous month','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('m1_15','ex00014','en','15th day of previous month','15th day of previous month','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('m1_10','ex00014','en','10th day of previous month','10th day of previous month','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('LSM','ex00005','en','Item + journal + management ','Item + journal + management ','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('LS','ex00005','en','Item + journal ','Item + journal ','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('LNK002','LNK','en','External system linkage','External system linkage','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('link_pop','COM518','en','External link (PopUp)','External link (PopUp)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('link_iframe','COM518','en','External link (I-Frame)','External link (I-Frame)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('J05','ERP030','en','Resigned','Resigned','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('J04','ERP030','en','Stand by','Stand by','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('J03','ERP030','en','On leave','On leave','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('J02','ERP030','en','Dispatch ','Dispatch ','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('J01','ERP030','en','Employed','Employed','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('FORMNM:TITLE(DOCNO)','ex00013','en','Format name : Document title - 100 words','Format name : Document title - 100 words','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('ETAXBTN','ex00027','en','N','N','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('ea0090','ea0007','en','Fund management','Fund management','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('drAcct','ex00003','en','Credit account code','Credit account code','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('crAcct','ex00003','en','Debit account code','Debit account code','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('CARDBTN','ex00027','en','N','N','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('BO003','COM510','en','Alerts for Comment Registrations for Posted Messages','Alerts for Comment Registrations for Posted Messages','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('BO001','COM510','en','New Message Alerts','New Message Alerts','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('B','ex00002','en','Resolution of purchase','Resolution of purchase','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('attend','COM518','en','Personnel Management','Personnel Management','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('A','ex00002','en','Request Expense Report Approval','Request Expense Report Approval','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('9','COM078','en','Confirmed permanently','Confirmed permanently','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('8','COM078','en','Confirmed permanently','Confirmed permanently','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('7','ATT0051','en','Saturday','Saturday','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('6','ATT0051','en','Friday','Friday','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('5','option0063','en','Orange','Orange','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('5','option0045','en','Department (Department name)','Department (Department name)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('5','It0009','en','5','5','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('5','ea0005','en','5 years','5 years','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('5','COM134','en','others','others','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('5','ATT0051','en','Thursday','Thursday','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('4','option0076','en','Overlaying right away','Overlaying right away','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('4','option0063','en','Green','Green','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('4','option0060','en','None','None','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('4','option0045','en','Provisional department','Provisional department','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('4','ex00010','en','Cost center code','Cost center code','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('4','ex00009','en','Budget unit + budget account (Not required)','Budget unit + budget account (Not required)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('4','ea0005','en','4 years','4 years','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('4','COM504','en','N/A','N/A','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('4','COM503','en','N/A','N/A','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('4','COM138','en','Confidential document','Confidential document','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('4','ATT0051','en','Wednesday','Wednesday','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('3','option0076','en','Notify by notification window (Turn off automatic hide after notifying)','Notify by notification window (Turn off automatic hide after notifying)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('3','option0074','en','Batang','Batang','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('3','option0063','en','Brown','Brown','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('3','option0060','en','ID','ID','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('3','option0049','en','Signature','Signature','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('3','option0045','en','Team','Team','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('3','option0040','en','special characters','special characters','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('3','option0007','en','Shared with','Shared with','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('3','option0003','en','Department','Department','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('3','ex00010','en','Project code','Project code','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('3','ex00009','en','Budget unit + budget account (Required)','Budget unit + budget account (Required)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('3','ERP042','en','','','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('3','ERP040','en','Resigned','Resigned','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('3','ea0011','en','Set Manually','Set Manually','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('3','ea0006','en','The third class','The third class','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('3','ea0005','en','3 years','3 years','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('3','COM530','en','Non-license','Non-license','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('3','COM504','en','Temporary employment','Temporary employment','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('3','COM503','en','Sales','Sales','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('3','ATT0051','en','Tuesday','Tuesday','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('3','ATT0012','en','Electronic/nonelectronic approval','Electronic/nonelectronic approval','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('200','option0070','en','Volume setting ','Volume setting ','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('20','option0069','en','Restriction on number ','Restriction on number ','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('20','ANNV0112','en','Adjustment of used annual leave.','Adjustment of used annual leave.','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('20','ANNV0111','en','To be used','To be used','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','option0200','en','Department','Department','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','option0076','en','Notify by notification window (Turn on automatic hide after notifying)','Notify by notification window (Turn on automatic hide after notifying)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','option0074','en','Dotum','Dotum','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','option0072','en','Open with IE browser (New window)','Open with IE browser (New window)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','option0071','en','Position','Position','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','option0068','en','ERP Email ID','ERP Email ID','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','option0063','en','Black','Black','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','option0062','en','Conversation','Conversation','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','option0061','en','Name (assigned task)','Name (assigned task)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','option0060','en','Position','Position','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','option0056','en','No','No','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','option0055','en','Viewing in one','Viewing in one','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','option0045','en','Department','Department','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','option0040','en','Figure','Figure','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','option0035','en','Termination + approval progress + rejected document','Termination + approval progress + rejected document','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','option0033','en','840101-*******','840101-*******','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','option0025','en','Use (pop up)','Use (pop up)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','option0014','en','Viewing in one','Viewing in one','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','option0013','en','work start month','work start month','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','option0012','en','Shared with','Shared with','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','option0011','en','descending order','descending order','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','option0010','en','Constant post date','Constant post date','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','option0009','en','24 hours','24 hours','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','option0008','en','Part revision is possible','Part revision is possible','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','option0007','en','Internal Participant','Internal Participant','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','option0006','en','Multi company','Multi company','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','option0005','en','Company','Company','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','option0003','en','Company - department','Company - department','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','It0009','en','2','2','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','ex00012','en','Debtor account subject code','Debtor account subject code','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','ex00010','en','department code','department code','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','ex00009','en','Budget unit + Business plan + Budget account (Not required)','Budget unit + Business plan + Budget account (Not required)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','ex00008','en','Browser popup link','Browser popup link','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','ex00007','en','Display the middle 8 digits of the card number in *','Display the middle 8 digits of the card number in *','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','ERP042','en','Women','Women','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','ERP041','en','Hired by the day','Hired by the day','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','ERP040','en','On leave','On leave','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','ea0025','en','main body','main body','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','ea0022','en','WebApi','WebApi','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','ea0011','en','Width','Width','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','ea0006','en','The second class','The second class','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','ea0005','en','2 years','2 years','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','COM530','en','Mail','Mail','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','COM504','en','Contracted work','Contracted work','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','COM503','en','Office','Office','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','COM138','en','Presidential document','Presidential document','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','CERT001','en','Employment Reference Letter','Employment Reference Letter','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','ATT0113','en','Separate column for attendance & leaving time','Separate column for attendance & leaving time','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','ATT0112','en','Data','Data','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','ATT0051','en','Monday','Monday','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','ATT0012','en','Electronic approval','Electronic approval','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','ANNV0011','en','based on the work start date','based on the work start date','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('120','ATT0023','en','Work group','Work group','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1020','ea0003','en','Form name (short)','Form name (short)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('10','It0011','en','Single day','Single day','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('10','It0010','en','List box','List box','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('10','It0005','en','Login department','Login department','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('10','It0004','en','Login user','Login user','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('10','ANNV0112','en','Adjustment of basic annual leave.','Adjustment of basic annual leave.','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('10','ANNV0111','en','Unconfirmed','Unconfirmed','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','yn0001','en','Yes','Yes','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','TX000017306','en','Unselection','Unselection','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','TX000010069','en','Basic business place','Basic business place','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','TX000006210','en','sub department','sub department','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','TX000006209','en','Main Department','Main Department','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','TX000003343','en','Do no print','Do no print','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','TX000000435','en','Year','Year','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0201','en','Basic document file','Basic document file','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0200','en','Form ','Form ','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0089','en','Viewing right away','Viewing right away','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0088','en','Opening after saving','Opening after saving','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0085','en','position','position','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0076','en','Notify by notification window (Do not limit automatic hide after notifying) ','Notify by notification window (Do not limit automatic hide after notifying) ','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0075','en','10','10','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0074','en','Position','Position','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0073','en','Position','Position','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0072','en','Open Window’s default browser','Open Window’s default browser','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0071','en','Position','Position','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0068','en','ERP staff number','ERP staff number','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0067','en','Unable to edit','Unable to edit','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0065','en','(App) Capacity restriction of attached file by the chat','(App) Capacity restriction of attached file by the chat','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0063','en','Blue','Blue','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0062','en','Send message','Send message','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0061','en','Name','Name','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0060','en','Position','Position','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0056','en','Yes','Yes','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0055','en','Viewing in dividing','Viewing in dividing','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0054','en','Setting for the open of OrgaChart tree','Setting for the open of OrgaChart tree','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0049','en','Text','Text','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0048','en','Display','Display','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0047','en','Both direction','Both direction','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0046','en','Team','Team','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0045','en','Workplace','Workplace','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0044','en','File down','File down','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0043','en','Basic provision of browser','Basic provision of browser','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0040','en','English (small letter)','English (small letter)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0035','en','Termination + document of approval progress','Termination + document of approval progress','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0033','en','840101-1******','840101-1******','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0030','en','Including the comment','Including the comment','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0029','en','At time of terminating','At time of terminating','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0025','en','Use (layer)','Use (layer)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0019','en','Available','Available','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0014','en','Viewing in dividing','Viewing in dividing','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0013','en','Year of joining the company','Year of joining the company','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0012','en','Registered by','Registered by','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0011','en','ascending order','ascending order','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0010','en','Registration Date','Registration Date','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0009','en','Registration on the very day','Registration on the very day','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0008','en','Possibility of revision','Possibility of revision','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0007','en','Managed by','Managed by','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0006','en','Single company','Single company','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0005','en','Group','Group','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0004','en','restriction','restriction','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0003','en','Company-business place-department','Company-business place-department','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','It0014','en','Select','Select','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','It0009','en','1','1','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','It0006','en','Available','Available','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','It0002','en','Select','Select','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','ex00012','en','Standard summary code','Standard summary code','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','ex00010','en','Standard summary code','Standard summary code','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','ex00009','en','Budget unit + Business plan + Budget account (Required)','Budget unit + Business plan + Budget account (Required)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','ex00008','en','Layer pop up link','Layer pop up link','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','ex00007','en','Display card name','Display card name','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','ERP042','en','Men','Men','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','ERP041','en','Regular employeement','Regular employeement','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','ERP040','en','Employed','Employed','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','ea0025','en','Code','Code','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','ea0022','en','InterLock','InterLock','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','ea0019','en','Disclosed','Disclosed','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','ea0011','en','Length','Length','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','ea0006','en','The first class','The first class','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','ea0005','en','1 year','1 year','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','COM530','en','groupware','groupware','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','COM504','en','Full-time position','Full-time position','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','COM503','en','Production/Manufacturing','Production/Manufacturing','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','COM135','en','General document','General document','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','COM102','en','Non-electronic','Non-electronic','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','COM078','en','Unconfirmed','Unconfirmed','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','cm2200','en','Date-Month','Date-Month','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','cm1020','en','All mail box','All mail box','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','cm0004','en','Yes','Yes','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','CERT001','en','Certificate of service','Certificate of service','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','ATT0113','en','Same column for attendance & leaving time','Same column for attendance & leaving time','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','ATT0112','en','Column','Column','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','ATT0051','en','Sunday','Sunday','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','ATT0012','en','Nonelectronic approval','Nonelectronic approval','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','ANNV0011','en','Setting the standard date (1/1)','Setting the standard date (1/1)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('099','ERP020','en','Resigned','Resigned','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0900100','ea0023','en','Data process of payment transfer (statement issue)','Data process of payment transfer (statement issue)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0800008','ea0023','en','Approval request of revenue','Approval request of revenue','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0800007','ea0023','en','Other approval request','Other approval request','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0800006','ea0023','en','Approval request for other income earner','Approval request for other income earner','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0800005','ea0023','en','Approval request for internal staff','Approval request for internal staff','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0800004','ea0023','en','Approval request for external client','Approval request for external client','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0800003','ea0023','en','Approval request of repair','Approval request of repair','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0800002','ea0023','en','Approval request of manufacture','Approval request of manufacture','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0800001','ea0023','en','Request for Decision - Purchase Order','Request for Decision - Purchase Order','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0700005','ea0023','en','Other substitution resolution letter','Other substitution resolution letter','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0700004','ea0023','en','Resolution letter for the setoff substitution of bond/liabilities','Resolution letter for the setoff substitution of bond/liabilities','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0700003','ea0023','en','Substitution resolution letter cash expenditure other than revenue and expenditure','Substitution resolution letter cash expenditure other than revenue and expenditure','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0700002','ea0023','en','Substitution resolution letter cash income other than revenue and expenditure','Substitution resolution letter cash income other than revenue and expenditure','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0700001','ea0023','en','Resolution letter of account substitution between banks','Resolution letter of account substitution between banks','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('06','option0026','en','NBB Editor + Naver Editor','NBB Editor + Naver Editor','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('05','option0026','en','Namo Cross Editor','Namo Cross Editor','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('04','option0026','en','Naver Editor','Naver Editor','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('03','option0026','en','CH Editor','CH Editor','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('02','option0026','en','CK Editor','CK Editor','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('018','COM085','en','others','others','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('017','COM119','en','Withraw','Withraw','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('015','COM119','en','Sending','Sending','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('015','COM085','en','Early Leave','Early Leave','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('014','COM089','en','Application for the welfare benefits','Application for the welfare benefits','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('013','COM085','en','Absent','Absent','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('012','COM089','en','Time and Attendance Application','Time and Attendance Application','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('012','COM085','en','Special holiday','Special holiday','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('011','COM137','en','Transmit cards','Transmit cards','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('011','COM089','en','An act ','An act ','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('011','COM085','en','Official vacation','Official vacation','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('010','COM137','en','Application of cards','Application of cards','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('010','COM089','en','Request for Decision','Request for Decision','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('01','option0026','en','NBB Editor + CK Editor','NBB Editor + CK Editor','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('009','COM137','en','Production of cards','Production of cards','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('009','COM109','en','Request to send','Request to send','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('009','COM085','en','Go out','Go out','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('008','COM137','en','Application of videos','Application of videos','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('008','COM109','en','Completion of approval.','Completion of approval.','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('007','COM137','en','Production of videos','Production of videos','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('007','COM092','en','Approve','Approve','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('007','COM089','en','Drafting all','Drafting all','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('006','COM137','en','Application of films','Application of films','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('006','COM120','en','Transfer','Transfer','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('006','COM092','en','Submit','Submit','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('006','COM085','en','On leave','On leave','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('005','COM137','en','Production of films','Production of films','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('005','COM120','en','Request to redesignate a person in charge','Request to redesignate a person in charge','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('005','COM107','en','Registered mail','Registered mail','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('005','COM085','en','Sick leave','Sick leave','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('004','COM137','en','Blueprints application','Blueprints application','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('004','COM092','en','cooperation','cooperation','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('004','COM085','en','Training','Training','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('003','COM180','en','Unit task','Unit task','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('003','COM137','en','Blueprints preparation, sending','Blueprints preparation, sending','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('003','COM120','en','Section receipt returned','Section receipt returned','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('003','COM119','en','Sending','Sending','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('003','COM107','en','Mail','Mail','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('003','COM092','en','Approved by','Approved by','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('003','COM085','en','Vacation','Vacation','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('002','ERP032','en','Women','Women','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('002','ERP031','en','Hired by the day','Hired by the day','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('002','ERP023','en','lunar calendar','lunar calendar','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('002','ERP022','en','Women','Women','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('002','ERP021','en','Hired by the day','Hired by the day','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('002','ERP020','en','On leave','On leave','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('002','COM180','en','Change the person in charge','Change the person in charge','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('002','COM137','en','General document application','General document application','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('002','COM111','en','Emergency document','Emergency document','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('002','COM092','en','Investigation','Investigation','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('002','COM088','en','Department head''s signature','Department head''s signature','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('002','COM085','en','Business trip to foreign country','Business trip to foreign country','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','ERP033','en','lunar calendar','lunar calendar','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','ERP032','en','Men','Men','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','ERP031','en','Regular employeement','Regular employeement','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','ERP023','en','solar calendar','solar calendar','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','ERP022','en','Men','Men','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','ERP021','en','Regular employeement','Regular employeement','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','ERP020','en','Employed','Employed','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','COM180','en','Refiling','Refiling','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','COM137','en','General document preparation, sending','General document preparation, sending','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','COM122','en','Received to reception deparment','Received to reception deparment','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','COM120','en','Receiving','Receiving','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','COM092','en','Drafts','Drafts','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','COM085','en','Business Trip (Abroad)','Business Trip (Abroad)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0000','COM519','en','dont use','dont use','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('000','ERP033','en','solar calendar','solar calendar','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('000','COM180','en','Work Handover','Work Handover','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('000','COM139','en','N/A','N/A','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('000','COM112','en','General document','General document','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('000','COM089','en','For multi-purposes including execution','For multi-purposes including execution','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0','option0202','en','Terminated document','Terminated document','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0','option0201','en','No selection','No selection','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0','option0099','en','My company','My company','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0','option0089','en','File down','File down','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0','option0088','en','Viewing right away','Viewing right away','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0','option0085','en','Position','Position','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0','option0076','en','Not limited','Not limited','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0','option0074','en','Clear gothic ','Clear gothic ','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0','option0073','en','Position','Position','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0','option0072','en','Not limited','Not limited','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0','option0071','en','Not limited','Not limited','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0','option0067','en','Possibility of revision','Possibility of revision','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0','option0043','en','DEXT5','DEXT5','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0','ea0005','en','Permanent preservation','Permanent preservation','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0','COM102','en','Electron','Electron','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0','COM079','en','Available for arbitrary approval','Available for arbitrary approval','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0','COM078','en','Complete','Complete','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0','cm2200','en','Date-Month-Year','Date-Month-Year','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0','cm1020','en','Mail','Mail','Y',null,null,null,null);







insert ignore into t_co_Code_detail_multi values('바탕체','option0080','jp','Batangche(パタンチェ）','Batangche(パタンチェ）','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('바탕','option0080','jp','デスクトップー＞PC일 경우  핸드펀일경우 틀림','デスクトップー＞PC일 경우  핸드펀일경우 틀림','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('맑은 고딕','option0080','jp','Malgun Gothic(マルグン・ゴシック)','Malgun Gothic(マルグン・ゴシック)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('돋움체','option0080','jp','Dotum(トドゥム体)','Dotum(トドゥム体)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('돋움','option0080','jp','（文字フォント種類の一種）','（文字フォント種類の一種）','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('궁서체','option0080','jp','Gungsuh(宮書体)','Gungsuh(宮書体)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('궁서','option0080','jp','（文字フォント種類の一種）','（文字フォント種類の一種）','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('굴림체','option0080','jp','クリム体','クリム体','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('굴림','option0080','jp','Gulim','Gulim','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('Y','ERP022','jp','','','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('useyn','cm0103','jp','使用有無','使用有無','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('useyn','cm0102','jp','使用有無','使用有無','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('TITLE(FORMNM:DOCNO)','ex00013','jp','文書のタイトル(フォーム名:文書番号)-100文字','文書のタイトル(フォーム名:文書番号)-100文字','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('TITLE(DOCNO)','ex00013','jp','文書のタイトル(文書番号)-100文字','文書のタイトル(文書番号)-100文字','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('TALK','COM512','jp','チャットルーム','チャットルーム','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('TA104','COM510','jp','プロジェクトのチャットルーム-チャットルーム退室','プロジェクトのチャットルーム-チャットルーム退室','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('TA103','COM510','jp','プロジェクトのチャットルーム-チャットルームの入室','プロジェクトのチャットルーム-チャットルームの入室','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('TA102','COM510','jp','プロジェクトのチャットルーム-チャットルームの設定内容プレビューON','プロジェクトのチャットルーム-チャットルームの設定内容プレビューON','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('TA101','COM510','jp','プロジェクトのチャットルーム-チャットルームの設定内容プレビューOff','プロジェクトのチャットルーム-チャットルームの設定内容プレビューOff','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('TA004','COM510','jp','チャットルーム退室','チャットルーム退室','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('TA003','COM510','jp','チャットルームの入室','チャットルームの入室','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('TA002','COM510','jp','チャットルームの設定内容プレビューON','チャットルームの設定内容プレビューON','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('TA001','COM510','jp','チャットルームの設定内容プレビューOff','チャットルームの設定内容プレビューOff','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('SM','ex00005','jp','仕訳+管理項目','仕訳+管理項目','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('S','ATT0021','jp','決裁開始','決裁開始','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('RS002','COM510','jp','資源承認要請お知らせ(承認手続き使用)','資源承認要請お知らせ(承認手続き使用)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('p1_5','ex00014','jp','翌月05日','翌月05日','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('p1_31','ex00014','jp','翌月31日(末日)','翌月31日(末日)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('p1_25','ex00014','jp','翌月25日','翌月25日','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('p1_20','ex00014','jp','翌月20日','翌月20日','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('p1_15','ex00014','jp','翌月15日','翌月15日','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('p1_10','ex00014','jp','翌月10日','翌月10日','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('p0_p0','ex00014','jp','今日付','今日付','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('p0_5','ex00014','jp','当月05日','当月05日','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('p0_31','ex00014','jp','当月に31日(末日)','当月に31日(末日)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('p0_25','ex00014','jp','当月に25日','当月に25日','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('p0_20','ex00014','jp','当月に20日','当月に20日','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('p0_15','ex00014','jp','当月15日','当月15日','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('p0_10','ex00014','jp','当月10日','当月10日','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('N','MobileWorkCheck','jp','未使用','未使用','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('N','mentionUseYn','jp','N','N','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('N','AttTime','jp','使用','使用','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('MENU001','MENU','jp','電子決裁(非営利)','電子決裁(非営利)','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('MENTION','ALARAM','jp','アルファメンション','アルファメンション','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('ME001','COM510','jp','メッセージ送信','メッセージ送信','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('m1_5','ex00014','jp','前月05日','前月05日','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('m1_31','ex00014','jp','前月31日(末日)','前月31日(末日)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('m1_25','ex00014','jp','前月25日','前月25日','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('m1_20','ex00014','jp','前月20日','前月20日','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('m1_15','ex00014','jp','前月15日','前月15日','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('m1_10','ex00014','jp','前月10日','前月10日','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('LSM','ex00005','jp','項目+仕訳+管理項目','項目+仕訳+管理項目','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('LS','ex00005','jp','項目+仕訳','項目+仕訳','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('LNK002','LNK','jp','外部システム連動','外部システム連動','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('LNK001','LNK','jp','連動文書','連動文書','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('LNK000','LNK','jp','一般','一般','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('link_pop','COM518','jp','外部リンク(PopUp)','外部リンク(PopUp)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('link_iframe','COM518','jp','外部リンク(I-Frame)','外部リンク(I-Frame)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('J02','ERP030','jp','派遣','派遣','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('FORMNM:TITLE(DOCNO)','ex00013','jp','フォーム名:文書のタイトル(文書番号)-100文字','フォーム名:文書のタイトル(文書番号)-100文字','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('ETAXBTN','ex00027','jp','N','N','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('ea0090','ea0007','jp','資金管理','資金管理','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('ea0070','ea0007','jp','文書管理連動用','文書管理連動用','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('ea0050','ea0007','jp','PMS文書','PMS文書','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('E','ATT0021','jp','決裁エラー','決裁エラー','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('DOCNO(TITLE)','ex00013','jp','文書番号(文書のタイトル)-100文字','文書番号(文書のタイトル)-100文字','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('DevInput','ex00018','jp','専用開発','専用開発','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('Default','ex00018','jp','基本値','基本値','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('D04','EXTRA001','jp','早期勤務','早期勤務','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('D01','EXTRA001','jp','早朝勤務','早朝勤務','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('d','COM109','jp','削除','削除','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('CARDBTN','ex00027','jp','N','N','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('attend','COM518','jp','社員管理','社員管理','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('ATTEND','ALARAM','jp','社員管理','社員管理','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('AT003','COM510','jp','証明書発給伴侶お知らせ','証明書発給伴侶お知らせ','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('AT002','COM510','jp','証明書発給承認お知らせ','証明書発給承認お知らせ','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('AT001','COM510','jp','証明書申請要請のお知らせ','証明書申請要請のお知らせ','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('999','COM517','jp','在職','在職','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('999','COM109','jp','決裁中','決裁中','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('998','COM109','jp','審査をキャンセル','審査をキャンセル','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('97,108','cm1010','jp','英陽郡','英陽郡','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('96,103','cm1010','jp','青松郡','青松郡','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('95,93','cm1010','jp','永川市','永川市','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('902','COM120','jp','文書廃棄','文書廃棄','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('902','COM119','jp','文書廃棄','文書廃棄','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('9','COM078','jp','永久確定','永久確定','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('89,111','cm1010','jp','栄州市','栄州市','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('81,84','cm1010','jp','陜川郡','陜川郡','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('81,106','cm1010','jp','聞慶市','聞慶市','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('801','COM089','jp','非電子文書','非電子文書','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('8','COM138','jp','個別管理記録物','個別管理記録物','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('8','COM078','jp','永久確定','永久確定','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('77,86','cm1010','jp','居昌郡','居昌郡','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('77,139','cm1010','jp','楊口郡','楊口郡','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('74,82','cm1010','jp','咸陽郡','咸陽郡','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('73,70','cm1010','jp','光陽市','光陽市','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('72,93','cm1010','jp','茂朱郡','茂朱郡','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('70,85','cm1010','jp','長水郡','長水郡','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('69,75','cm1010','jp','求礼郡','求礼郡','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('69,125','cm1010','jp','楊平郡(ヤンピョングン)','楊平郡(ヤンピョングン)','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('68,88','cm1010','jp','鎮安郡','鎮安郡','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('68,80','cm1010','jp','南原市','南原市','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('68,121','cm1010','jp','利川市','利川市','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('61,134','cm1010','jp','東豆川市','東豆川市','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('59,64','cm1010','jp','長興郡','長興郡','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('57,103','cm1010','jp','青陽郡','青陽郡','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('56,66','cm1010','jp','霊岩郡','霊岩郡','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('54,100','cm1010','jp','保寧市','保寧市','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('52,77','cm1010','jp','霊光郡','霊光郡','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('52,72','cm1010','jp','咸平郡','咸平郡','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('5','option0045','jp','部署(部署名)','部署(部署名)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('5','COM134','jp','その他','その他','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('48,59','cm1010','jp','珍島郡','珍島郡','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('4','ex00010','jp','コストセンターコード','コストセンターコード','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('4','ex00009','jp','予算単位+予算勘定(必修ではない)','予算単位+予算勘定(必修ではない)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('4','COM138','jp','秘密記録物','秘密記録物','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('32','COM138','jp','特修企画記録物','特修企画記録物','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('3','option0076','jp','お知らせ窓で通知(表示後に自動隠しOFF)','お知らせ窓で通知(表示後に自動隠しOFF)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('3','option0049','jp','サイン','サイン','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('3','ex00009','jp','予算単位+予算勘定(必須)','予算単位+予算勘定(必須)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('3','ERP042','jp','','','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('3','ERP040','jp','退職','退職','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('200','option0070','jp','容量の設定','容量の設定','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('20','option0069','jp','本数制限','本数制限','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('20','It0010','jp','Radio box','Radio box','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','option0200','jp','部署','部署','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','option0076','jp','お知らせ槍で知らせる(お知らせ後に自動隠すON)','お知らせ槍で知らせる(お知らせ後に自動隠すON)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','option0072','jp','IEブラウザで開くこと(新しいウィンドウ)','IEブラウザで開くこと(新しいウィンドウ)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','option0068','jp','ERP Email ID','ERP Email ID','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','ex00012','jp','借方勘定科目コード','借方勘定科目コード','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','ex00009','jp','予算単位+事業計画+予算勘定(必修ではない)','予算単位+事業計画+予算勘定(必修ではない)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','ex00008','jp','ブラウザポップアップリンク','ブラウザポップアップリンク','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','ex00007','jp','カード番号の真ん中の8桁表示','カード番号の真ん中の8桁表示','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','ERP042','jp','女','女','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','ERP041','jp','アルバイト','アルバイト','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','ERP040','jp','休職','休職','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','COM138','jp','大統領関連記録物','大統領関連記録物','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('16','COM138','jp','著作権保護記録物','著作権保護記録物','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('127,127','cm1010','jp','鬱陵郡','鬱陵郡','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('110','COM119','jp','受付差戻','受付差戻','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('102,103','cm1010','jp','盈徳郡','盈徳郡','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('10','It0011','jp','単一','単一','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('10','It0010','jp','List box','List box','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('10','It0005','jp','ログイン部署','ログイン部署','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('10','It0004','jp','ログインユーザ','ログインユーザ','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0201','jp','基本文書トレイ','基本文書トレイ','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0200','jp','書式','書式','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0089','jp','今すぐ見る','今すぐ見る','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0088','jp','保存してから閲覧','保存してから閲覧','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0085','jp','職位','職位','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0076','jp','お知らせ窓で通知(表示後に自動隠しの制限なし)','お知らせ窓で通知(表示後に自動隠しの制限なし)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0072','jp','ウィンドウ基本ブラウザ表示','ウィンドウ基本ブラウザ表示','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0068','jp','ERPの社員番号','ERPの社員番号','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0067','jp','修正不可能','修正不可能','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0049','jp','テキスト','テキスト','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','ex00012','jp','標準摘要コード','標準摘要コード','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','ex00010','jp','標準摘要コード','標準摘要コード','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','ex00009','jp','予算単位+事業計画+予算勘定(必須)','予算単位+事業計画+予算勘定(必須)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','ex00008','jp','Layerのポップアップリンク','Layerのポップアップリンク','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','ex00007','jp','カード名表示','カード名表示','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','ERP042','jp','男','男','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','ERP041','jp','職員','職員','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','ERP040','jp','在職','在職','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','COM135','jp','一般文書','一般文書','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','COM102','jp','非電子','非電子','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','COM078','jp','未確定','未確定','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','cm2200','jp','月‐日','月‐日','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('040','COM104','jp','永久','永久','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('030','COM104','jp','半永久','半永久','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('025','COM104','jp','30年','30年','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('018','COM085','jp','その他','その他','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('017','COM119','jp','引戻し','引戻し','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('015','COM119','jp','送信進行中','送信進行中','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('015','COM085','jp','早退','早退','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('014','COM089','jp','福利厚生申請書','福利厚生申請書','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('013','COM085','jp','欠勤','欠勤','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('012','COM089','jp','勤怠の申請書','勤怠の申請書','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('012','COM085','jp','特別休暇','特別休暇','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('011','COM137','jp','カード類二重発送','カード類二重発送','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('011','COM089','jp','承認書','承認書','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('011','COM085','jp','公式休暇','公式休暇','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('010','COM137','jp','カード類の受付','カード類の受付','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('010','COM104','jp','10年','10年','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('010','COM089','jp','稟議書','稟議書','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('009','COM137','jp','カード類生産','カード類生産','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('009','COM129','jp','セキュリティ文書','セキュリティ文書','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('009','COM109','jp','送信要求','送信要求','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('009','COM085','jp','外出','外出','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('008','COM137','jp','録音動画類の受付','録音動画類の受付','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('008','COM109','jp','決裁済み','決裁済み','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('007','COM137','jp','録音動画類生産','録音動画類生産','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('007','COM120','jp','軽油','軽油','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('007','COM119','jp','反送','反送','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('007','COM114','jp','決裁者','決裁者','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('007','COM109','jp','起案差し戻し','起案差し戻し','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('007','COM092','jp','決裁','決裁','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('007','COM089','jp','一括起案','一括起案','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('006','COM137','jp','写真フィルム類の受付','写真フィルム類の受付','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('006','COM120','jp','移送','移送','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('006','COM119','jp','受信','受信','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('006','COM109','jp','多重部署受付中','多重部署受付中','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('006','COM107','jp','Eメール','Eメール','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('006','COM092','jp','申請','申請','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('006','COM085','jp','休職','休職','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('005','COM137','jp','写真フィルム類生産','写真フィルム類生産','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('005','COM120','jp','担当者の再指定要請','担当者の再指定要請','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('005','COM119','jp','到達','到達','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('005','COM109','jp','文書回収','文書回収','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('005','COM107','jp','登記','登記','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('005','COM104','jp','5年','5年','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('005','COM085','jp','病欠','病欠','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('004','COM517','jp','休職','休職','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('004','COM137','jp','図面類の受付','図面類の受付','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('004','COM119','jp','送信失敗','送信失敗','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('004','COM110','jp','経緯文書','経緯文書','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('004','COM109','jp','決裁保留','決裁保留','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('004','COM107','jp','FAX','FAX','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('004','COM092','jp','協助','協助','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('004','COM089','jp','報告書','報告書','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('004','COM085','jp','教育','教育','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('003','COM180','jp','単位業務','単位業務','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('003','COM137','jp','図面類生産、発送','図面類生産、発送','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('003','COM121','jp','館内受付','館内受付','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('003','COM120','jp','過度な受付搬送','過度な受付搬送','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('003','COM119','jp','送信中','送信中','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('003','COM110','jp','クレーム文書','クレーム文書','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('003','COM109','jp','協調中','協調中','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('003','COM107','jp','カードの二重発送','カードの二重発送','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('003','COM106','jp','非公開','非公開','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('003','COM104','jp','3年','3年','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('003','COM092','jp','最終決裁','最終決裁','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('003','COM085','jp','休暇','休暇','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('002','COM180','jp','担当者変更','担当者変更','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('002','COM137','jp','一般文書の受付','一般文書の受付','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('002','COM122','jp','担当者受付','担当者受付','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('002','COM121','jp','社外受付','社外受付','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('002','COM119','jp','送信待機','送信待機','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('002','COM112','jp','経緯文書','経緯文書','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('002','COM111','jp','緊急処理文書','緊急処理文書','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('002','COM110','jp','対外文書','対外文書','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('002','COM109','jp','決裁中','決裁中','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('002','COM106','jp','部分公開','部分公開','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('002','COM092','jp','検討','検討','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('002','COM088','jp','部長サイン','部長サイン','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('002','COM085','jp','海外出張','海外出張','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','COM517','jp','退職','退職','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','COM180','jp','再ファイリング','再ファイリング','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','COM167','jp','対内文書','対内文書','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','COM137','jp','一般文書の生産、発送','一般文書の生産、発送','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','COM122','jp','受付課受付','受付課受付','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','COM121','jp','館内受付','館内受付','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','COM120','jp','受付中','受付中','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','COM119','jp','送信要求','送信要求','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','COM114','jp','起案者','起案者','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','COM110','jp','対内文書','対内文書','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','COM109','jp','起案中','起案中','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','COM108','jp','セキュリティ文書','セキュリティ文書','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','COM107','jp','電算網','電算網','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','COM106','jp','公開','公開','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','COM104','jp','1年','1年','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','COM103','jp','受付文書','受付文書','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','COM092','jp','起案','起案','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','COM085','jp','出張','出張','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('000','COM180','jp','受け渡し','受け渡し','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('000','COM167','jp','社内文書','社内文書','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('000','COM139','jp','該当なし','該当なし','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('000','COM137','jp','内部決裁文書','内部決裁文書','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('000','COM129','jp','一般文書','一般文書','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('000','COM121','jp','社外受付','社外受付','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('000','COM112','jp','一般文書','一般文書','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('000','COM111','jp','一般文書','一般文書','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('000','COM110','jp','内部決裁','内部決裁','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('000','COM103','jp','生産文書','生産文書','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('000','COM089','jp','施行文兼用','施行文兼用','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0','option0202','jp','終結文書','終結文書','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0','option0201','jp','選択なし','選択なし','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0','option0099','jp','自分の会社','自分の会社','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0','option0089','jp','ファイルダウンロード','ファイルダウンロード','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0','option0088','jp','今すぐ見る','今すぐ見る','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0','option0085','jp','役職','役職','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0','option0074','jp','Malgun Gothic(マルグン・ゴシック)','Malgun Gothic(マルグン・ゴシック)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0','option0072','jp','制限無し','制限無し','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0','COM102','jp','電子','電子','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0','COM078','jp','確定','確定','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0','cm2200','jp','年度‐月‐日','年度‐月‐日','Y',null,null,null,null);







insert ignore into t_co_Code_detail_multi values('바탕체','option0080','cn','底板字体','底板字体','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('바탕','option0080','cn','BATANG','BATANG','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('맑은 고딕','option0080','cn','Malgun Gothic字体','Malgun Gothic字体','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('돋움체','option0080','cn','突出字体','突出字体','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('돋움','option0080','cn','DOTUM','DOTUM','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('궁서체','option0080','cn','宫书字体','宫书字体','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('궁서','option0080','cn','GUNGSUHCHE','GUNGSUHCHE','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('굴림체','option0080','cn','滚动式字体','滚动式字体','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('굴림','option0080','cn','Gullim','Gullim','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('Y','ERP022','cn','','','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('useyn','cm0103','cn','使用与否','使用与否','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('useyn','cm0102','cn','使用与否','使用与否','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('TITLE(FORMNM:DOCNO)','ex00013','cn','文件标题(样式名：文件序号) - 100字','文件标题(样式名：文件序号) - 100字','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('TITLE(DOCNO)','ex00013','cn','文件标题(文件序号) - 100字','文件标题(文件序号) - 100字','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('TALK','COM512','cn','聊天室','聊天室','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('TA104','COM510','cn','项目聊天室 - 退出聊天室','项目聊天室 - 退出聊天室','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('TA103','COM510','cn','项目聊天室 - 进入聊天室','项目聊天室 - 进入聊天室','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('TA102','COM510','cn','项目聊天室 - 聊天室设定  预览内容ON','项目聊天室 - 聊天室设定  预览内容ON','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('TA101','COM510','cn','项目聊天室 - 聊天室设定  预览内容Off','项目聊天室 - 聊天室设定  预览内容Off','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('TA004','COM510','cn','退出聊天室','退出聊天室','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('TA003','COM510','cn','进入聊天室','进入聊天室','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('TA002','COM510','cn','打开聊天室设定、预览内容','打开聊天室设定、预览内容','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('TA001','COM510','cn','关闭聊天室设定、预览内容','关闭聊天室设定、预览内容','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('SM','ex00005','cn','分录+管理项目','分录+管理项目','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('S','ATT0021','cn','开始审批','开始审批','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('RS002','COM510','cn','要求批准资源提醒(使用批准程序)','要求批准资源提醒(使用批准程序)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('p1_5','ex00014','cn','下个月05号','下个月05号','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('p1_31','ex00014','cn','下个月31号(月末)','下个月31号(月末)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('p1_25','ex00014','cn','下个月25号','下个月25号','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('p1_20','ex00014','cn','下个月20号','下个月20号','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('p1_15','ex00014','cn','下个月15号','下个月15号','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('p1_10','ex00014','cn','下个月10号','下个月10号','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('p0_p0','ex00014','cn','今天日期','今天日期','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('p0_5','ex00014','cn','本月05号','本月05号','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('p0_31','ex00014','cn','本月31号(月末)','本月31号(月末)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('p0_25','ex00014','cn','本月25号','本月25号','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('p0_20','ex00014','cn','本月20号','本月20号','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('p0_15','ex00014','cn','本月15号','本月15号','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('p0_10','ex00014','cn','本月10号','本月10号','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('N','MobileWorkCheck','cn','未使用','未使用','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('N','mentionUseYn','cn','N','N','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('N','AttTime','cn','使用','使用','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('MENU001','MENU','cn','电子审批(非盈利)','电子审批(非盈利)','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('MENTION','ALARAM','cn','alpha提到','alpha提到','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('ME001','COM510','cn','发送纸条','发送纸条','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('m1_5','ex00014','cn','上个月05号','上个月05号','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('m1_31','ex00014','cn','上个月31号(月末)','上个月31号(月末)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('m1_25','ex00014','cn','上个月25号','上个月25号','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('m1_20','ex00014','cn','上个月20号','上个月20号','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('m1_15','ex00014','cn','上个月15号','上个月15号','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('m1_10','ex00014','cn','上个月10号','上个月10号','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('LSM','ex00005','cn','科目+分录+管理项目','科目+分录+管理项目','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('LS','ex00005','cn','科目+分录','科目+分录','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('LNK002','LNK','cn','联动外部系统','联动外部系统','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('LNK001','LNK','cn','联动文件','联动文件','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('LNK000','LNK','cn','一般','一般','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('link_pop','COM518','cn','外部链接(PopUp)','外部链接(PopUp)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('link_iframe','COM518','cn','外部链接(I-Frame)','外部链接(I-Frame)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('J02','ERP030','cn','派遣','派遣','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('FORMNM:TITLE(DOCNO)','ex00013','cn','样式名：文件标题(文件序号) - 100字','样式名：文件标题(文件序号) - 100字','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('ETAXBTN','ex00027','cn','N','N','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('ea0090','ea0007','cn','资金管理','资金管理','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('ea0070','ea0007','cn','文件管理联动用','文件管理联动用','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('ea0050','ea0007','cn','PMS文件','PMS文件','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('E','ATT0021','cn','审批错误','审批错误','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('DOCNO(TITLE)','ex00013','cn','文件序号(文件标题) - 100字','文件序号(文件标题) - 100字','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('DevInput','ex00018','cn','专用开发','专用开发','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('Default','ex00018','cn','默认值','默认值','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('D04','EXTRA001','cn','早班','早班','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('D01','EXTRA001','cn','凌晨出勤','凌晨出勤','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('d','COM109','cn','删除','删除','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('CARDBTN','ex00027','cn','N','N','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('attend','COM518','cn','对职员服务','对职员服务','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('ATTEND','ALARAM','cn','对职员服务','对职员服务','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('AT003','COM510','cn','退回颁发证明书提醒','退回颁发证明书提醒','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('AT002','COM510','cn','批准颁发证明书提醒','批准颁发证明书提醒','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('AT001','COM510','cn','要求申请证明书提醒','要求申请证明书提醒','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('999','COM517','cn','在职','在职','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('999','COM109','cn','审批中','审批中','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('998','COM109','cn','取消审批','取消审批','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('97,108','cm1010','cn','英阳郡','英阳郡','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('96,103','cm1010','cn','青松郡','青松郡','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('95,93','cm1010','cn','永川市','永川市','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('902','COM120','cn','销毁文件','销毁文件','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('902','COM119','cn','销毁文件','销毁文件','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('9','COM078','cn','永久确定','永久确定','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('89,111','cm1010','cn','荣州市','荣州市','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('81,84','cm1010','cn','陜川郡','陜川郡','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('81,106','cm1010','cn','闻庆市','闻庆市','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('801','COM089','cn','非电子文件','非电子文件','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('8','COM138','cn','各别管理记录物','各别管理记录物','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('8','COM078','cn','永久确定','永久确定','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('77,86','cm1010','cn','居昌郡','居昌郡','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('77,139','cm1010','cn','杨口郡','杨口郡','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('74,82','cm1010','cn','咸阳郡','咸阳郡','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('73,70','cm1010','cn','光阳市','光阳市','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('72,93','cm1010','cn','茂朱郡','茂朱郡','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('70,85','cm1010','cn','长水郡','长水郡','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('69,75','cm1010','cn','求礼郡','求礼郡','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('69,125','cm1010','cn','杨平郡','杨平郡','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('68,88','cm1010','cn','镇安郡','镇安郡','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('68,80','cm1010','cn','南原市','南原市','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('68,121','cm1010','cn','利川市 ','利川市 ','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('61,134','cm1010','cn','东豆川市','东豆川市','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('59,64','cm1010','cn','长兴郡','长兴郡','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('57,103','cm1010','cn','青阳郡','青阳郡','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('56,66','cm1010','cn','灵岩郡','灵岩郡','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('54,100','cm1010','cn','保宁市','保宁市','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('52,77','cm1010','cn','灵光郡','灵光郡','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('52,72','cm1010','cn','咸平郡','咸平郡','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('5','option0045','cn','部门(部门长)','部门(部门长)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('5','It0009','cn','5','5','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('5','COM134','cn','其他','其他','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('48,59','cm1010','cn','珍岛郡','珍岛郡','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('4','ex00010','cn','成本中心代码','成本中心代码','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('4','ex00009','cn','预算单位+预算帐号(不是必须)','预算单位+预算帐号(不是必须)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('4','COM138','cn','秘密记录物','秘密记录物','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('32','COM138','cn','特殊规格记录物','特殊规格记录物','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('3','option0076','cn','以提示窗口通知(通知后关闭自动隐藏)','以提示窗口通知(通知后关闭自动隐藏)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('3','option0049','cn','签名','签名','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('3','ex00009','cn','预算单位+预算帐号(必须)','预算单位+预算帐号(必须)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('3','ERP042','cn','','','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('3','ERP040','cn','退休','退休','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('25','so0007','cn','15','15','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('200','option0070','cn','容量设定','容量设定','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('20','so0008','cn','10','10','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('20','so0007','cn','10','10','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('20','option0069','cn','限制数量','限制数量','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('20','It0010','cn','Radio box','Radio box','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','option0200','cn','部门','部门','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','option0076','cn','以提示窗口通知(通知后打开自动隐藏)','以提示窗口通知(通知后打开自动隐藏)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','option0072','cn','打开IE浏览器(新建窗口)','打开IE浏览器(新建窗口)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','option0068','cn','ERP Email ID','ERP Email ID','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','It0009','cn','2','2','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','ex00012','cn','借方帐号科目代码','借方帐号科目代码','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','ex00009','cn','预算单位+事业计划+预算帐号(不是必须)','预算单位+事业计划+预算帐号(不是必须)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','ex00008','cn','浏览器弹出窗口链接','浏览器弹出窗口链接','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','ex00007','cn','卡号中间8位数以 * 显示','卡号中间8位数以 * 显示','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','ERP042','cn','女性','女性','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','ERP041','cn','临时职','临时职','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','ERP040','cn','停职','停职','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('2','COM138','cn','有关总统记录物','有关总统记录物','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('16','COM138','cn','版权保护记录物','版权保护记录物','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('15','ex00016','cn','15','15','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('127,127','cm1010','cn','郁陵郡','郁陵郡','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('110','COM119','cn','取消接收','取消接收','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('102,103','cm1010','cn','盈德郡','盈德郡','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('10','It0011','cn','单一','单一','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('10','It0010','cn','List box','List box','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('10','It0009','cn','10','10','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('10','It0005','cn','登录部门','登录部门','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('10','It0004','cn','登录用户','登录用户','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0201','cn','默认文件夹','默认文件夹','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0200','cn','样式','样式','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0089','cn','直接查看','直接查看','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0088','cn','保存并打开','保存并打开','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0085','cn','职位','职位','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0076','cn','以提示窗口通知(通知后不限制自动隐藏)','以提示窗口通知(通知后不限制自动隐藏)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0075','cn','10','10','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0072','cn','打开Windows基本浏览器','打开Windows基本浏览器','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0068','cn','ERP职员号','ERP职员号','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0067','cn','无法修改','无法修改','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','option0049','cn','文本','文本','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','It0009','cn','1','1','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','ex00012','cn','标准摘要代码','标准摘要代码','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','ex00010','cn','标准摘要代码','标准摘要代码','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','ex00009','cn','预算单位+事业计划+预算帐号(必须)','预算单位+事业计划+预算帐号(必须)','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','ex00008','cn','链接Layer弹出窗口','链接Layer弹出窗口','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','ex00007','cn','显示卡名','显示卡名','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','ERP042','cn','男性','男性','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','ERP041','cn','正式职','正式职','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','ERP040','cn','在职','在职','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','COM135','cn','一般文件','一般文件','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','COM102','cn','非电子','非电子','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','COM078','cn','未确定','未确定','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('1','cm2200','cn','年-月','年-月','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('040','COM104','cn','永久','永久','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('030','COM104','cn','半永久','半永久','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('025','COM104','cn','30年','30年','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('018','COM085','cn','其他','其他','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('017','COM119','cn','回收','回收','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('015','COM119','cn','正在发送','正在发送','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('015','COM085','cn','早退','早退','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('014','COM089','cn','福利申请书','福利申请书','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('013','COM085','cn','缺勤','缺勤','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('012','COM089','cn','考勤申请书','考勤申请书','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('012','COM085','cn','特别休假','特别休假','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('011','COM137','cn','移交发送卡类','移交发送卡类','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('011','COM089','cn','决议书','决议书','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('011','COM085','cn','公假','公假','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('010','COM137','cn','接收卡类','接收卡类','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('010','COM104','cn','10年','10年','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('010','COM089','cn','申请书','申请书','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('009','COM137','cn','生产卡类','生产卡类','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('009','COM129','cn','安全文件','安全文件','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('009','COM109','cn','请求发送','请求发送','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('009','COM085','cn','外出','外出','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('008','COM137','cn','接收录音视频类','接收录音视频类','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('008','COM109','cn','审批结束','审批结束','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('007','COM137','cn','生产录音视频类','生产录音视频类','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('007','COM120','cn','柴油','柴油','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('007','COM119','cn','退回','退回','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('007','COM114','cn','审批人','审批人','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('007','COM109','cn','退回申请','退回申请','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('007','COM092','cn','审批','审批','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('007','COM089','cn','统一申请','统一申请','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('006','COM137','cn','接收照片胶卷类','接收照片胶卷类','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('006','COM120','cn','移送','移送','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('006','COM119','cn','收信','收信','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('006','COM109','cn','接收多个部门中','接收多个部门中','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('006','COM107','cn','邮件','邮件','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('006','COM092','cn','接收','接收','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('006','COM085','cn','停职','停职','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('005','COM137','cn','生产照片胶卷类','生产照片胶卷类','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('005','COM120','cn','要求重新指定负责人','要求重新指定负责人','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('005','COM119','cn','到达','到达','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('005','COM109','cn','回收文件','回收文件','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('005','COM107','cn','挂号','挂号','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('005','COM104','cn','5年','5年','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('005','COM085','cn','病假','病假','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('004','COM517','cn','停职','停职','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('004','COM137','cn','接收图纸类','接收图纸类','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('004','COM119','cn','发送失败','发送失败','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('004','COM110','cn','经过文件','经过文件','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('004','COM109','cn','保留审批','保留审批','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('004','COM107','cn','传真','传真','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('004','COM092','cn','协助','协助','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('004','COM089','cn','报告书','报告书','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('004','COM085','cn','培训','培训','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('003','COM180','cn','各业务','各业务','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('003','COM137','cn','生产、发送图纸类','生产、发送图纸类','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('003','COM121','cn','关内接收','关内接收','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('003','COM120','cn','过接受返送','过接受返送','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('003','COM119','cn','正在发送','正在发送','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('003','COM110','cn','信访文件','信访文件','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('003','COM109','cn','协助中','协助中','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('003','COM107','cn','托人','托人','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('003','COM106','cn','非公开','非公开','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('003','COM104','cn','3年','3年','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('003','COM092','cn','最终审批','最终审批','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('003','COM085','cn','休假','休假','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('002','COM180','cn','修改负责人','修改负责人','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('002','COM137','cn','接收一般文件','接收一般文件','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('002','COM122','cn','负责人接收','负责人接收','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('002','COM121','cn','关外接收','关外接收','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('002','COM119','cn','等待发送','等待发送','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('002','COM112','cn','经过文件','经过文件','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('002','COM111','cn','紧急处理文件','紧急处理文件','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('002','COM110','cn','对外文件','对外文件','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('002','COM109','cn','审批中','审批中','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('002','COM106','cn','部分公开','部分公开','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('002','COM092','cn','检查','检查','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('002','COM088','cn','部门长签署','部门长签署','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('002','COM085','cn','国外出差','国外出差','N',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','COM517','cn','退休','退休','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','COM180','cn','重新保留','重新保留','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','COM167','cn','内部文件','内部文件','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','COM137','cn','生产、发送一般文件','生产、发送一般文件','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','COM122','cn','接受科已接受','接受科已接受','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','COM121','cn','关内接收','关内接收','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','COM120','cn','接受中','接受中','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','COM119','cn','请求发送','请求发送','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','COM114','cn','起草人','起草人','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','COM110','cn','内部文件','内部文件','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','COM109','cn','申请中','申请中','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','COM108','cn','安全文件','安全文件','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','COM107','cn','电脑网','电脑网','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','COM106','cn','公开','公开','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','COM104','cn','1年','1年','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','COM103','cn','接收的文件','接收的文件','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','COM092','cn','草稿','草稿','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('001','COM085','cn','出差','出差','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('000','COM180','cn','交接','交接','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('000','COM167','cn','内部文件','内部文件','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('000','COM139','cn','不属于','不属于','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('000','COM137','cn','内部审批文件','内部审批文件','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('000','COM129','cn','一般文件','一般文件','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('000','COM121','cn','关外接收','关外接收','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('000','COM112','cn','一般文件','一般文件','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('000','COM111','cn','一般文件','一般文件','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('000','COM110','cn','内部审批','内部审批','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('000','COM103','cn','生产文件','生产文件','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('000','COM089','cn','执行文兼用','执行文兼用','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0','option0202','cn','终止文件','终止文件','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0','option0201','cn','没有选择','没有选择','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0','option0099','cn','我的公司','我的公司','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0','option0089','cn','下载文件','下载文件','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0','option0088','cn','直接查看','直接查看','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0','option0085','cn','职责','职责','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0','option0074','cn','Malgun Gothic字体','Malgun Gothic字体','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0','option0072','cn','不推荐','不推荐','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0','COM102','cn','电子','电子','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0','COM078','cn','确定','确定','Y',null,null,null,null);
insert ignore into t_co_Code_detail_multi values('0','cm2200','cn','年-月-日','年-月-日','Y',null,null,null,null);



insert ignore into t_co_Code_multi values('option0098','en','Mail notification receiver settings','Mail notification receiver settings','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('option0087','en','Salary statement inquiry method','Salary statement inquiry method','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('option0068','en','Groupware ID generation basic value ','Groupware ID generation basic value ','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('ex00003','en','Search condition (standard abstract)','Search condition (standard abstract)','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('ex00002','en','Division of standard outlien','Division of standard outlien','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('ex00001','en','In Use','In Use','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM180','en','Classification of change','Classification of change','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM085','en','By class','By class','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('cm3000','en','portal type','portal type','Y',null,null,null,null);






insert ignore into t_co_Code_multi values('option0098','jp','メール受信のお知らせ　受信者設定','メール受信のお知らせ　受信者設定','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('option0087','jp','給料明細書の照会方式の設定','給料明細書の照会方式の設定','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('LNK','jp','連動の種類','連動の種類','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM513','jp','プロジェクト段階','プロジェクト段階','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM180','jp','変更区分','変更区分','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM167','jp','連動文書区分','連動文書区分','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM139','jp','記録物のタイプ','記録物のタイプ','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM138','jp','特殊記録物区分','特殊記録物区分','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM137','jp','記録物登録区分','記録物登録区分','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM135','jp','記録物のタイプ','記録物のタイプ','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM134','jp','主要閲覧用途','主要閲覧用途','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM133','jp','変更前保存先','変更前保存先','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM132','jp','変更保存方法','変更保存方法','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM129','jp','作業種類','作業種類','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM122','jp','担当区分','担当区分','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM121','jp','受付区分','受付区分','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM120','jp','受付状態','受付状態','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM119','jp','送受信状態','送受信状態','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM114','jp','署名者タイプ','署名者タイプ','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM112','jp','文書属性','文書属性','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM111','jp','文書のランク','文書のランク','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM110','jp','文書のタイプ','文書のタイプ','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM109','jp','文書状態','文書状態','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM108','jp','非電子文書理由','非電子文書理由','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM107','jp','文書取り扱い','文書取り扱い','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM106','jp','文書公開レベル','文書公開レベル','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM105','jp','文書公開の可否','文書公開の可否','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM104','jp','文書保存リミット','文書保存リミット','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM089','jp','フォーム種類区分','フォーム種類区分','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM088','jp','サインの種類','サインの種類','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM085','jp','種別','種別','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM080','jp','暗号化適用有無','暗号化適用有無','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('cm3000','jp','ポータルタイプ','ポータルタイプ','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('ATT0118','jp','出社・退社アップロードカラムの出社区分','出社・退社アップロードカラムの出社区分','N',null,null,null,null);
insert ignore into t_co_Code_multi values('ATT0117','jp','出社・退社アップロードカラムの出社区分','出社・退社アップロードカラムの出社区分','N',null,null,null,null);
insert ignore into t_co_Code_multi values('ATT0114','jp','出社・退社アップロードカラムの出入カード番号','出社・退社アップロードカラムの出入カード番号','N',null,null,null,null);
insert ignore into t_co_Code_multi values('ADDR001','jp','使用不使用','使用不使用','N',null,null,null,null);




insert ignore into t_co_Code_multi values('option0098','cn','设置接收邮件提醒的人','设置接收邮件提醒的人','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('option0087','cn','设置工资单查询方式','设置工资单查询方式','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('LNK','cn','联动种类','联动种类','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM513','cn','项目阶段','项目阶段','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM180','cn','修改区分','修改区分','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM167','cn','联动文件区分','联动文件区分','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM139','cn','记录物形态','记录物形态','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM138','cn','特殊记录物区分','特殊记录物区分','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM137','cn','登录记录物区分','登录记录物区分','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM135','cn','记录物形态','记录物形态','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM134','cn','主要阅览用途','主要阅览用途','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM133','cn','更换之前的保存场所','更换之前的保存场所','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM132','cn','更换保存方法','更换保存方法','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM129','cn','工作种类','工作种类','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM122','cn','负责类型','负责类型','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM121','cn','接收区分','接收区分','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM120','cn','接收状态','接收状态','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM119','cn','收发件状态','收发件状态','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM114','cn','签名者类型','签名者类型','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM112','cn','文件属性','文件属性','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM111','cn','文件等级','文件等级','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM110','cn','文件形态','文件形态','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM109','cn','文件状态','文件状态','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM108','cn','非电子文件理由','非电子文件理由','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM107','cn','处理文件','处理文件','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM106','cn','文件公开等级','文件公开等级','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM105','cn','文件公开与否','文件公开与否','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM104','cn','文件保存年限','文件保存年限','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM089','cn','格式种类区分','格式种类区分','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM088','cn','签名种类','签名种类','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM085','cn','按种类','按种类','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('COM080','cn','适用加密与否','适用加密与否','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('cm3000','cn','门户类型','门户类型','Y',null,null,null,null);
insert ignore into t_co_Code_multi values('ATT0118','cn','登记上下班专栏的下班区分','登记上下班专栏的下班区分','N',null,null,null,null);
insert ignore into t_co_Code_multi values('ATT0117','cn','登记上下班专栏的上班区分','登记上下班专栏的上班区分','N',null,null,null,null);
insert ignore into t_co_Code_multi values('ATT0114','cn','登记上下班专栏的出入卡号码','登记上下班专栏的出入卡号码','N',null,null,null,null);
insert ignore into t_co_Code_multi values('ADDR001','cn','使用与否','使用与否','N',null,null,null,null);



insert ignore into t_co_menu_adm_multi values('806000000','en','Approval Option Settings','Approval Option Settings',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('1106000000','en','Approval Option Settings','Approval Option Settings',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('507000000','en','Bookmark','Bookmark',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('1507000000','en','Bookmark','Bookmark',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('805000000','en','budget management','budget management',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('1302070000','en','Calendar','Calendar',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('802000000','en','Completed documents','Completed documents',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('802010000','en','Completed documents','Completed documents',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('805010000','en','Deferrence between budget and actual amount','Deferrence between budget and actual amount',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('501012000','en','Detailed options for bulletin board','Detailed options for bulletin board',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('1501012000','en','Detailed options for bulletin board','Detailed options for bulletin board',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('602001000','en','Document Transmission Status','Document Transmission Status',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('1602001000','en','Document Transmission Status','Document Transmission Status',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('1101010000','en','Management of formula','Management of formula',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('705050000','en','Manually Transferred Approved Documents','Manually Transferred Approved Documents',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('1920102001','en','Overtime','Overtime',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('1920102004','en','Overtime working setup','Overtime working setup',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('1920102002','en','Overtime working status','Overtime working status',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('1920102003','en','Overtime working status','Overtime working status',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('803010200','en','Pending transfer','Pending transfer',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('808010000','en','set approval line','set approval line',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('1108010000','en','set approval line','set approval line',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('1101020000','en','set external system interlocking','set external system interlocking',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('931020150','en','Setting for the environment of annual leave','Setting for the environment of annual leave',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('1301020000','en','Settings','Settings',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('805020000','en','Status by budget steps','Status by budget steps',null,null,null,null);


insert ignore into t_co_menu_adm_multi values('806000000','jp','決裁オプション管理','決裁オプション管理',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('1106000000','jp','決裁オプション管理','決裁オプション管理',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('507000000','jp','お気に入り','お気に入り',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('1507000000','jp','お気に入り','お気に入り',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('805000000','jp','予算管理','予算管理',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('1302070000','jp','リソースカレンダー','リソースカレンダー',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('802000000','jp','完了文書ボックス','完了文書ボックス',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('802010000','jp','完了文書ボックス','完了文書ボックス',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('805010000','jp','予実対比の状況','予実対比の状況',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('501012000','jp','掲示板の詳細オプション','掲示板の詳細オプション',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('1501012000','jp','掲示板の詳細オプション','掲示板の詳細オプション',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('602001000','jp','文書の送信状況','文書の送信状況',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('1602001000','jp','文書の送信状況','文書の送信状況',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('1101010000','jp','書式管理','書式管理',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('705050000','jp','終結された文書の受動移管','終結された文書の受動移管',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('1920102001','jp','残業','残業',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('1920102004','jp','時間外勤務の設定','時間外勤務の設定',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('1920102002','jp','時間外勤務の状況','時間外勤務の状況',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('1920102003','jp','時間外勤務の状況','時間外勤務の状況',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('803010200','jp','引継の待機','引継の待機',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('808010000','jp','決裁ライン設定','決裁ライン設定',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('1108010000','jp','決裁ライン設定','決裁ライン設定',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('1101020000','jp','外部システム連動設定','外部システム連動設定',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('931020150','jp','年次休暇の環境設定','年次休暇の環境設定',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('1301020000','jp','カレンダー管理','カレンダー管理',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('805020000','jp','予算段階情報','予算段階情報',null,null,null,null);



insert ignore into t_co_menu_adm_multi values('806000000','cn','审批选项管理','审批选项管理',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('1106000000','cn','审批选项管理','审批选项管理',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('507000000','cn','收藏夹','收藏夹',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('1507000000','cn','收藏夹','收藏夹',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('805000000','cn','预算管理','预算管理',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('1302070000','cn','资源日历','资源日历',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('802000000','cn','结束文件保管箱','结束文件保管箱',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('802010000','cn','结束文件保管箱','结束文件保管箱',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('805010000','cn','预算完成情况','预算完成情况',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('501012000','cn','留言板详细选项','留言板详细选项',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('1501012000','cn','留言板详细选项','留言板详细选项',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('602001000','cn','文件发送现状','文件发送现状',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('1602001000','cn','文件发送现状','文件发送现状',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('1101010000','cn','格式管理','格式管理',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('705050000','cn','手动移动结束文件','手动移动结束文件',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('1920102001','cn','加班','加班',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('1920102004','cn','设定加班','设定加班',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('1920102002','cn','加班状况','加班状况',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('1920102003','cn','加班状况','加班状况',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('803010200','cn','等待移交','等待移交',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('808010000','cn','设置审批程序','设置审批程序',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('1108010000','cn','设置审批程序','设置审批程序',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('1101020000','cn','外部系统连接设置','外部系统连接设置',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('931020150','cn','年假环境设定','年假环境设定',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('1301020000','cn','日历管理','日历管理',null,null,null,null);
insert ignore into t_co_menu_adm_multi values('805020000','cn','按预算阶段情况','按预算阶段情况',null,null,null,null);



insert ignore into t_co_menu_multi values('100000000','en','Electronic approval (non)','Electronic approval (non)',null,null,null,null);
insert ignore into t_co_menu_multi values('105000000','en','Completed documents','Completed documents',null,null,null,null);
insert ignore into t_co_menu_multi values('105010000','en','Completed documents','Completed documents',null,null,null,null);
insert ignore into t_co_menu_multi values('401080000','en','Project Management','Project Management',null,null,null,null);
insert ignore into t_co_menu_multi values('507000000','en','Bookmark','Bookmark',null,null,null,null);
insert ignore into t_co_menu_multi values('603040000','en','Record of file sending','Record of file sending',null,null,null,null);
insert ignore into t_co_menu_multi values('2006020001','en','Work Handover','Work Handover',null,null,null,null);
insert ignore into t_co_menu_multi values('2007020047','en','Employee''s Work Rotation Status','Employee''s Work Rotation Status',null,null,null,null);
insert ignore into t_co_menu_multi values('2007020048','en','View all shared calendar','View all shared calendar',null,null,null,null);
insert ignore into t_co_menu_multi values('2007020049','en','View all shared calendar','View all shared calendar',null,null,null,null);
insert ignore into t_co_menu_multi values('2007020051','en','Training','Training',null,null,null,null);
insert ignore into t_co_menu_multi values('2007020055','en','Report','Report',null,null,null,null);




insert ignore into t_co_menu_multi values('100000000','jp','電子決裁（非）','電子決裁（非）',null,null,null,null);
insert ignore into t_co_menu_multi values('105000000','jp','完了文書ボックス','完了文書ボックス',null,null,null,null);
insert ignore into t_co_menu_multi values('105010000','jp','完了文書ボックス','完了文書ボックス',null,null,null,null);
insert ignore into t_co_menu_multi values('401080000','jp','プロジェクト管理','プロジェクト管理',null,null,null,null);
insert ignore into t_co_menu_multi values('507000000','jp','お気に入り','お気に入り',null,null,null,null);
insert ignore into t_co_menu_multi values('603040000','jp','ファイル送信の記録','ファイル送信の記録',null,null,null,null);
insert ignore into t_co_menu_multi values('2006020001','jp','受け渡し','受け渡し',null,null,null,null);
insert ignore into t_co_menu_multi values('2007020047','jp','勤務変更の現況','勤務変更の現況',null,null,null,null);
insert ignore into t_co_menu_multi values('2007020048','jp','共有スケジュールをすべて表示','共有スケジュールをすべて表示',null,null,null,null);
insert ignore into t_co_menu_multi values('2007020049','jp','共有スケジュールをすべて表示','共有スケジュールをすべて表示',null,null,null,null);
insert ignore into t_co_menu_multi values('2007020051','jp','教育','教育',null,null,null,null);
insert ignore into t_co_menu_multi values('2007020055','jp','報告ボックス','報告ボックス',null,null,null,null);



insert ignore into t_co_menu_multi values('100000000','cn','电子审批(非)','电子审批(非)',null,null,null,null);
insert ignore into t_co_menu_multi values('105000000','cn','结束文件保管箱','结束文件保管箱',null,null,null,null);
insert ignore into t_co_menu_multi values('105010000','cn','结束文件保管箱','结束文件保管箱',null,null,null,null);
insert ignore into t_co_menu_multi values('401080000','cn','项目管理','项目管理',null,null,null,null);
insert ignore into t_co_menu_multi values('507000000','cn','收藏夹','收藏夹',null,null,null,null);
insert ignore into t_co_menu_multi values('603040000','cn','发送文件记录','发送文件记录',null,null,null,null);
insert ignore into t_co_menu_multi values('2006020001','cn','交接','交接',null,null,null,null);
insert ignore into t_co_menu_multi values('2007020047','cn','工作修改情况','工作修改情况',null,null,null,null);
insert ignore into t_co_menu_multi values('2007020048','cn','查看全部共享日程','查看全部共享日程',null,null,null,null);
insert ignore into t_co_menu_multi values('2007020049','cn','查看全部共享日程','查看全部共享日程',null,null,null,null);
insert ignore into t_co_menu_multi values('2007020051','cn','培训','培训',null,null,null,null);
insert ignore into t_co_menu_multi values('2007020055','cn','申请箱','申请箱',null,null,null,null);


insert ignore into t_co_Code_multi values ('option0074' ,'en' ,'(Common) Font selection' ,'(Common) Font selection' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0075' ,'en' ,'(Common) Font size selection' ,'(Common) Font size selection' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0076' ,'en' ,'(Messenger) Notification processing selection' ,'(Messenger) Notification processing selection' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0072' ,'en' ,'(Messenger) Open URL link' ,'(Messenger) Open URL link' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0061' ,'en' ,'(Messenger) Unrestricted / Name / Name [Responsibilities]' ,'(Messenger) Unrestricted / Name / Name [Responsibilities]' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0060' ,'en' ,'(Messenger) No restriction / Position / Position / ID / None' ,'(Messenger) No restriction / Position / Position / ID / None' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0071' ,'en' ,'(App) Employee view settings' ,'(App) Employee view settings' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0070' ,'en' ,'(App) Limit the size of each attachment in a message' ,'(App) Limit the size of each attachment in a message' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0069' ,'en' ,'(App) Limit the number of attachments per message' ,'(App) Limit the number of attachments per message' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0073' ,'en' ,'(Company) Position/job title display in the organization' ,'(Company) Position/job title display in the organization' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ERP031' ,'en' ,'ERP icube employment type' ,'ERP icube employment type' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ERP030' ,'en' ,'ERP icube working classification' ,'ERP icube working classification' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ERP021' ,'en' ,'ERP iu employment type' ,'ERP iu employment type' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ERP020' ,'en' ,'ERP iu working classification' ,'ERP iu working classification' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ERP022' ,'en' ,'ERP IU gender classification' ,'ERP IU gender classification' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ERP023' ,'en' ,'ERP iu gender classification' ,'ERP iu gender classification' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ERP032' ,'en' ,'ERP IU gender classification' ,'ERP IU gender classification' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ERP033' ,'en' ,'ERP iu gender classification' ,'ERP iu gender classification' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ERP041' ,'en' ,'GERP employment type' ,'GERP employment type' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ERP040' ,'en' ,'GERP working classification' ,'GERP working classification' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ERP042' ,'en' ,'GERP gender classification' ,'GERP gender classification' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('cm0103' ,'en' ,'Use of interlocking at iU Approval line view ' ,'Use of interlocking at iU Approval line view ' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0092' ,'en' ,'PDF file view type' ,'PDF file view type' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0205' ,'en' ,'Force logout screen setting' ,'Force logout screen setting' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('It0013' ,'en' ,'Individual/department' ,'Individual/department' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0049' ,'en' ,'Approval signature' ,'Approval signature' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('COM092' ,'en' ,'Approver property' ,'Approver property' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('cm0102' ,'en' ,'Customers'' use of common comments' ,'Customers'' use of common comments' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('cm0104' ,'en' ,'Determine to use common and options, or rebuild codes' ,'Determine to use common and options, or rebuild codes' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ex00031' ,'en' ,'Number of displayed common codes' ,'Number of displayed common codes' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('It0005' ,'en' ,'Default (login department)' ,'Default (login department)' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('It0004' ,'en' ,'Default (login user)' ,'Default (login user)' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0084' ,'en' ,'Basic information required fields' ,'Basic information required fields' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0204' ,'en' ,'Possible time to modify drafter approval line' ,'Possible time to modify drafter approval line' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0202' ,'en' ,'Setting reference condition of reference document when drafting' ,'Setting reference condition of reference document when drafting' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('It0012' ,'en' ,'Year/MonthYear/DayMonthYear/TimeDayMonthYear' ,'Year/MonthYear/DayMonthYear/TimeDayMonthYear' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('It0011' ,'en' ,'Single/Period' ,'Single/Period' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0091' ,'en' ,'Organization scope settings for the receiver of internal documents' ,'Organization scope settings for the receiver of internal documents' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0150' ,'en' ,'Comment type settings' ,'Comment type settings' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('COM530' ,'en' ,'License type' ,'License type' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('It0009' ,'en' ,'Number of lines (1-10)' ,'Number of lines (1-10)' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('mentionUseYn' ,'en' ,'Use of mention (temporary)' ,'Use of mention (temporary)' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('MobileWorkCheck' ,'en' ,'Use of mobile attendance check' ,'Use of mobile attendance check' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0203' ,'en' ,'Pop-up type settings to view the revision history of documents' ,'Pop-up type settings to view the revision history of documents' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0200' ,'en' ,'Transfer criteria settings for completed documents' ,'Transfer criteria settings for completed documents' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0201' ,'en' ,'Default settings for the document box' ,'Default settings for the document box' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('cm0004' ,'en' ,'In use No in use' ,'In use No in use' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('cm0101' ,'en' ,'User approval box Batch' ,'User approval box Batch' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('It0007' ,'en' ,'User, department/user' ,'User, department/user' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('It0003' ,'en' ,'Employee/Department' ,'Employee/Department' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('COM103' ,'en' ,'Produced/received document' ,'Produced/received document' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('It0014' ,'en' ,'Decimal places' ,'Decimal places' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0067' ,'en' ,'Possible/Impossible to edit' ,'Possible/Impossible to edit' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('AttTime' ,'en' ,'Use of business reporting hours' ,'Use of business reporting hours' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('yn0001' ,'en' ,'Yes No' ,'Yes No' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ex00004' ,'en' ,'Yes/No' ,'Yes/No' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0025' ,'en' ,'Option - Displaying the remarks of approval in the pop-up window.' ,'Option - Displaying the remarks of approval in the pop-up window.' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0026' ,'en' ,'Option - Editor' ,'Option - Editor' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0001' ,'en' ,'Option-YN' ,'Option-YN' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0009' ,'en' ,'Option _Period to display posts' ,'Option _Period to display posts' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0028' ,'en' ,'Option_Sorting criteria of approval storage box' ,'Option_Sorting criteria of approval storage box' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0017' ,'en' ,'Option _ a person with the right to delete comments on approval' ,'Option _ a person with the right to delete comments on approval' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0016' ,'en' ,'Option_Location of comments on approval' ,'Option_Location of comments on approval' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0015' ,'en' ,'Option_Alarm setting when a comment on approval is entered.' ,'Option_Alarm setting when a comment on approval is entered.' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0018' ,'en' ,'Option_Output of comments on approval' ,'Option_Output of comments on approval' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0020' ,'en' ,'Option_Selecting the display of approval line sending official documents' ,'Option_Selecting the display of approval line sending official documents' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0019' ,'en' ,'Option_Edit official documents' ,'Option_Edit official documents' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0030' ,'en' ,'Option_Whether or not to include comments when printing out announcement posts.' ,'Option_Whether or not to include comments when printing out announcement posts.' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0005' ,'en' ,'Option _ Group company' ,'Option _ Group company' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0011' ,'en' ,'Option _ Comments sorting' ,'Option _ Comments sorting' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0014' ,'en' ,'Option _ View messenger organization' ,'Option _ View messenger organization' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0003' ,'en' ,'Option _ Display department information' ,'Option _ Display department information' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0002' ,'en' ,'Option_Wheter or not to use' ,'Option_Wheter or not to use' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0007' ,'en' ,'Option_Custom designation scope 1' ,'Option_Custom designation scope 1' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0012' ,'en' ,'Option_Custom designation scope 2' ,'Option_Custom designation scope 2' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0010' ,'en' ,'Options _ Criteria of ordinary post sorting' ,'Options _ Criteria of ordinary post sorting' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0035' ,'en' ,'Option_CC searching conditions' ,'Option_CC searching conditions' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0008' ,'en' ,'Option_Select edit options' ,'Option_Select edit options' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0013' ,'en' ,'Option_Criteria to calculate annual leave' ,'Option_Criteria to calculate annual leave' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0029' ,'en' ,'Option _ Use of PDF storage function for e-approval' ,'Option _ Use of PDF storage function for e-approval' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0021' ,'en' ,'Option_Whether or not to close the view screen after completing e-approval' ,'Option_Whether or not to close the view screen after completing e-approval' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0004' ,'en' ,'Option_Application of limits' ,'Option_Application of limits' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0033' ,'en' ,'Option _Output type of resident registration number certificate' ,'Option _Output type of resident registration number certificate' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0022' ,'en' ,'Option_Searching conditions for reference documents' ,'Option_Searching conditions for reference documents' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0006' ,'en' ,'Option_Company single/multi' ,'Option_Company single/multi' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ea0033' ,'en' ,'How to use a seal' ,'How to use a seal' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ex00029' ,'en' ,'Setting the automatic statement transfer scope' ,'Setting the automatic statement transfer scope' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0088' ,'en' ,'Open after saving/Quick view' ,'Open after saving/Quick view' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('COM102' ,'en' ,'Classification between electronic and non-electronic' ,'Classification between electronic and non-electronic' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0099' ,'en' ,'Organzation search scope' ,'Organzation search scope' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('CERT004' ,'en' ,'Certificates in multi languages' ,'Certificates in multi languages' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ex00027' ,'en' ,'Whether or not to expose the expenditure resolution (for profit) button' ,'Whether or not to expose the expenditure resolution (for profit) button' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ex00028' ,'en' ,'Whether or not to use the expenditure resolution (for profit) budget' ,'Whether or not to use the expenditure resolution (for profit) budget' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0085' ,'en' ,'Job title/Position' ,'Job title/Position' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0100' ,'en' ,'Automatic message deletion settings' ,'Automatic message deletion settings' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0110' ,'en' ,'Automatic message deletion settings' ,'Automatic message deletion settings' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0089' ,'en' ,'File download/Quick view' ,'File download/Quick view' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('COM078' ,'en' ,'Identification of binding files' ,'Identification of binding files' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0097' ,'en' ,'The serial number of types of coordination documents' ,'The serial number of types of coordination documents' ,'Y' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('301060200' ,'en' ,'Create shared calendars' ,'Create shared calendars' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('301080000' ,'en' ,'View all my schedules' ,'View all my schedules' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('806000000' ,'en' ,'Verification device management' ,'Verification device management' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('806001000' ,'en' ,'2-step verification device settings' ,'2-step verification device settings' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('904000000' ,'en' ,'The management of paseenger cars for business' ,'The management of paseenger cars for business' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('904010000' ,'en' ,'Operation records' ,'Operation records' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('904020000' ,'en' ,'Operation records status' ,'Operation records status' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('1001010000' ,'en' ,'The status of my expenditure resolution' ,'The status of my expenditure resolution' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('1001020000' ,'en' ,'The status of my card use' ,'The status of my card use' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('1001030000' ,'en' ,'My tax bill status (ERPiU)' ,'My tax bill status (ERPiU)' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('1001040000' ,'en' ,'My tax bill status (iCUBE)' ,'My tax bill status (iCUBE)' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('1003020000' ,'en' ,'The status of my comparison between budget and performance (iCUBE)' ,'The status of my comparison between budget and performance (iCUBE)' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('1003030000' ,'en' ,'The status of my comparison between budget and performance (ERPiU)' ,'The status of my comparison between budget and performance (ERPiU)' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('2006020007' ,'en' ,'History of receipts and reports' ,'History of receipts and reports' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('2007020021' ,'en' ,'Overtime working status (manager)' ,'Overtime working status (manager)' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('2007020050' ,'en' ,'Concluded (closed)' ,'Concluded (closed)' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('401020000' ,'en' ,'Project business management' ,'Project business management' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('607003000' ,'en' ,'Document auto-transfer settings' ,'Document auto-transfer settings' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('607004000' ,'en' ,'Auto-transfer options settings' ,'Auto-transfer options settings' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('705040000' ,'en' ,'Transferred document box (all)' ,'Transferred document box (all)' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('707000000' ,'en' ,'Approval settings management' ,'Approval settings management' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('707010000' ,'en' ,'Substitute approval management by employee' ,'Substitute approval management by employee' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('803000000' ,'en' ,'Handover/Takeover of recorded folders' ,'Handover/Takeover of recorded folders' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('803010000' ,'en' ,'Handover' ,'Handover' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('803010100' ,'en' ,'Handover application' ,'Handover application' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('803010300' ,'en' ,'Handover status' ,'Handover status' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('803020000' ,'en' ,'Takeover' ,'Takeover' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('803020100' ,'en' ,'Takeover of department pending' ,'Takeover of department pending' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('803020200' ,'en' ,'My handover box' ,'My handover box' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('803020300' ,'en' ,'Takeover of department in progress' ,'Takeover of department in progress' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('803020400' ,'en' ,'Takeover of department completed' ,'Takeover of department completed' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('804000000' ,'en' ,'Handover/Takeover of records' ,'Handover/Takeover of records' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('804010000' ,'en' ,'Handover' ,'Handover' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('804010100' ,'en' ,'Application for the takeover of records' ,'Application for the takeover of records' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('804010200' ,'en' ,'Takeover of records pending' ,'Takeover of records pending' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('804010300' ,'en' ,'The status of takover of records ' ,'The status of takover of records ' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('804020000' ,'en' ,'Takeover' ,'Takeover' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('805030000' ,'en' ,'Report/Resolution status' ,'Report/Resolution status' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('806010000' ,'en' ,'Approval option settings' ,'Approval option settings' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('808000000' ,'en' ,'Approval group management' ,'Approval group management' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('808020000' ,'en' ,'Approval group settings' ,'Approval group settings' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('810104000' ,'en' ,'ICUBE interlocking documents status' ,'ICUBE interlocking documents status' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('810105000' ,'en' ,'Tax bill status (iCUBE)' ,'Tax bill status (iCUBE)' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('810106000' ,'en' ,'Tax bill status (ERPiU)' ,'Tax bill status (ERPiU)' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('810211000' ,'en' ,'Name settings' ,'Name settings' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('810212000' ,'en' ,'Button settings' ,'Button settings' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('810213000' ,'en' ,'Settings of the electronic tax invoice for purchase' ,'Settings of the electronic tax invoice for purchase' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('810214000' ,'en' ,'Settings of the standard brief & proof type by form' ,'Settings of the standard brief & proof type by form' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('810215000' ,'en' ,'Closing settings' ,'Closing settings' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('810502000' ,'en' ,'Comparison of budget and performance (iCUBE)' ,'Comparison of budget and performance (iCUBE)' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('810503000' ,'en' ,'Comparison of budget and performance (ERPiU)' ,'Comparison of budget and performance (ERPiU)' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('905050000' ,'en' ,'Project serial number management' ,'Project serial number management' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('910400000' ,'en' ,'Business passenger car management' ,'Business passenger car management' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('910400100' ,'en' ,'Operation record status' ,'Operation record status' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('911030200' ,'en' ,'Character statistics' ,'Character statistics' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('1106010000' ,'en' ,'Approval option settings' ,'Approval option settings' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('1108000000' ,'en' ,'Approval group management' ,'Approval group management' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('1108020000' ,'en' ,'Approval group settings' ,'Approval group settings' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('1401020000' ,'en' ,'Project business managmeent' ,'Project business managmeent' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('1607003000' ,'en' ,'Document auto-transfer settings' ,'Document auto-transfer settings' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('1607004000' ,'en' ,'Auto-transfer options setting' ,'Auto-transfer options setting' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('1705040000' ,'en' ,'Transferred document box (all)' ,'Transferred document box (all)' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('1707000000' ,'en' ,'Approval settings management' ,'Approval settings management' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('1707010000' ,'en' ,'Substitute approval managmenet by employee' ,'Substitute approval managmenet by employee' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('1909001000' ,'en' ,'2-step verification settings' ,'2-step verification settings' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('2104040010' ,'en' ,'Attendance history managmenet' ,'Attendance history managmenet' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('2104040011' ,'en' ,'Working change application status' ,'Working change application status' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('2104040016' ,'en' ,'ERP attendance interlocking' ,'ERP attendance interlocking' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('2104040017' ,'en' ,'Transmssion of attendance by period' ,'Transmssion of attendance by period' ,null ,null,null,null);
update tcmg_optionset set option_nm_en = 'Limit the number of attachments per message.' , option_nm_jp = 'メッセージ当たりの添付ファイルの個数制限', option_nm_cn = '限制各纸条的附件数量' where option_id = 'app202';
update tcmg_optionset set option_nm_en = 'Limit the size of each attachment included in a message' , option_nm_jp = 'メモ添付ファイル1個当たりの容量制限', option_nm_cn = '限制每个纸条的附件容量' where option_id = 'app203';
update tcmg_optionset set option_nm_en = 'Employee view method settings' , option_nm_jp = '社員表示方式設定', option_nm_cn = '设置查看职员方式' where option_id = 'app500';
update tcmg_optionset set option_nm_en = 'Schedule/note' , option_nm_jp = '日程/ノート', option_nm_cn = '日程/记录' where option_id = 'appPathSeq400';
update tcmg_optionset set option_nm_en = 'Message/conversaion room' , option_nm_jp = 'メッセージ/チャットルーム', option_nm_cn = '纸条/聊天室' where option_id = 'appPathSeq810';
update tcmg_optionset set option_nm_en = 'Force logout screen setting' , option_nm_jp = '強制ログアウト画面設定', option_nm_cn = '强制退出画面设置' where option_id = 'cm102_1';
update tcmg_optionset set option_nm_en = 'Restriction settings on words for password' , option_nm_jp = 'パスワード入力制限単語の設定', option_nm_cn = '设置密码限制输入单词' where option_id = 'cm205';
update tcmg_optionset set option_nm_en = 'Restriction settings on words for ID' , option_nm_jp = 'ID入力制限単語の設定', option_nm_cn = '设置用户名限制输入单词' where option_id = 'cm206';
update tcmg_optionset set option_nm_en = 'Layout settings for bottom icons' , option_nm_jp = 'レイアウト下段アイコン設定', option_nm_cn = '设置页面下段图标' where option_id = 'cm850';
update tcmg_optionset set option_nm_en = 'Automatic message deletion settings' , option_nm_jp = 'メッセージの自動削除設定', option_nm_cn = '自动删除纸条设置' where option_id = 'com100';
update tcmg_optionset set option_nm_en = 'Retention period settings' , option_nm_jp = '保存期間設定', option_nm_cn = '设置保存期间' where option_id = 'com101';
update tcmg_optionset set option_nm_en = 'Conversation auto-deletion settings' , option_nm_jp = 'チャットの自動削除設定', option_nm_cn = '设置自动删除对话' where option_id = 'com200';
update tcmg_optionset set option_nm_en = 'Retention period settings' , option_nm_jp = '保存期間設定', option_nm_cn = '设置保存期间' where option_id = 'com201';
update tcmg_optionset set option_nm_en = 'Automatic deletion settings for e-approval' , option_nm_jp = '電子決裁自動削除設定', option_nm_cn = '设置自动删除电子审批' where option_id = 'com300';
update tcmg_optionset set option_nm_en = 'Retention period settings' , option_nm_jp = '保存期間設定', option_nm_cn = '设置保存期间' where option_id = 'com301';
update tcmg_optionset set option_nm_en = 'Possibility of registering the group of company address list' , option_nm_jp = '会社住所録,グループ登録の可能有無', option_nm_cn = '是否按群组登录企业地址簿' where option_id = 'com400';
update tcmg_optionset set option_nm_en = 'Approval cancellation settings when closing an external system-approval interlocked document' , option_nm_jp = '外部システム - 決裁連動文書の終結時,決裁取り消し設定 ', option_nm_cn = '外部系统-设置审批联动文件结束时取消审批' where option_id = 'ea221';
update tcmg_optionset set option_nm_en = 'Mark the returned and redrafted documents with icons in the e-approval list.' , option_nm_jp = '電子決裁リストに返却文書の再起案文書アイコン表示', option_nm_cn = '在电子审批列表上显示退回文件的重新申请文件图标' where option_id = 'ea424';
update tcmg_optionset set option_nm_en = 'Display of Login_Id in the approval line' , option_nm_jp = '決裁ライン Login_Id表示有無', option_nm_cn = '在审批层次上是否显示Login_Id' where option_id = 'ea510';
update tcmg_optionset set option_nm_en = 'Establishment of criteria to transfer approval documents' , option_nm_jp = '決済完了文書の移管基準を設定', option_nm_cn = '设置审批结束文件的移交标准' where option_id = 'eatf100';
update tcmg_optionset set option_nm_en = 'Set the default selection values for the document box' , option_nm_jp = '文書ボックスの基本値を設定', option_nm_cn = '设置文件箱基本选择值' where option_id = 'eatf110';
update tcmg_optionset set option_nm_en = 'Receipt notification of messages' , option_nm_jp = 'メッセージ受信時お知らせ処理', option_nm_cn = '接收纸条时提醒处理' where option_id = 'msg1000';
update tcmg_optionset set option_nm_en = 'Receipt notification for conversation' , option_nm_jp = 'チャット受信時お知らせ処理', option_nm_cn = '接收对话时提醒处理' where option_id = 'msg1100';
update tcmg_optionset set option_nm_en = 'Attachment view settings on PC messenger' , option_nm_jp = 'PCメッセンジャー添付ファイルを表示設定', option_nm_cn = '设置查看PC的MSN附件' where option_id = 'msg1600';
update tcmg_optionset set option_nm_en = 'Options to save messenger password' , option_nm_jp = 'メッセンジャーパスワード保存選択機能', option_nm_cn = '选择保存MSN密码功能' where option_id = 'msg1700';
update tcmg_optionset set option_nm_en = 'Attachment view settings on PC messenger' , option_nm_jp = 'PCメッセンジャー添付ファイルの表示設定', option_nm_cn = '设置查看PC的MSN附件' where option_id = 'msg1800';
update tcmg_optionset set option_nm_en = 'Options to select messenger bulletin board roll-up' , option_nm_jp = 'メッセンジャー掲示板ロールアップの選択機能', option_nm_cn = '选择MSN留言板上传功能' where option_id = 'msg1900';
update tcmg_optionset set option_nm_en = 'Select the bulletin board you want to expose.' , option_nm_jp = '表示掲示板を選択します。', option_nm_cn = '选择要显示的留言板。' where option_id = 'msg1910';
update tcmg_optionset set option_nm_en = 'Set the number of posts to expose.' , option_nm_jp = '表示する掲示文の数を設定します。', option_nm_cn = '设置要显示的留言文章的数量。' where option_id = 'msg1920';
update tcmg_optionset set option_nm_en = 'Limit the number of attachments per message.' , option_nm_jp = 'メッセージ当たり添付ファイルの個数制限', option_nm_cn = '限制各纸条的附件数量' where option_id = 'msg820';
update tcmg_optionset set option_nm_en = 'Limit the size of each attachment to a message' , option_nm_jp = 'メッセージ添付ファイル1個当たりの容量制限', option_nm_cn = '限制每个纸条的附件容量' where option_id = 'msg830';
update tcmg_optionset set option_nm_en = 'Whether or not to enter approval password' , option_nm_jp = '決裁暗号の入力有無', option_nm_cn = '是否输入审批密码' where option_id = 'np100';
update tcmg_optionset set option_nm_en = 'Whether or not to close the pop-up window after completing approval' , option_nm_jp = '決裁終了後,ポップアップを閉じるかどうか', option_nm_cn = '审批结束后是否关闭弹出窗口' where option_id = 'np101';
update tcmg_optionset set option_nm_en = 'Basic settings for approval signature' , option_nm_jp = '決裁社の基本設定', option_nm_cn = '审批签署基本设置' where option_id = 'np111';
update tcmg_optionset set option_nm_en = 'Whether or not to use the Do Not Approve button' , option_nm_jp = '決裁しないボタン使用有無', option_nm_cn = '是否使用不做审批按键' where option_id = 'np201';
update tcmg_optionset set option_nm_en = 'Whether or not to use the Substitute Approval button' , option_nm_jp = '代決ボタン使用有無', option_nm_cn = '是否使用待批按键' where option_id = 'np202';
update tcmg_optionset set option_nm_en = 'Whether or not to use the Agree button' , option_nm_jp = '合意ボタンの使用有無', option_nm_cn = '是否使用协商按键' where option_id = 'np203';
update tcmg_optionset set option_nm_en = 'Whether or not to use parallel cooperation' , option_nm_jp = '並列協調使用有無', option_nm_cn = '是否使用并列协助' where option_id = 'np204';
update tcmg_optionset set option_nm_en = 'Whether or not to automatically send internal documents' , option_nm_jp = '社内文書自動発送有無', option_nm_cn = '是否自动发送对内文件' where option_id = 'np301';
update tcmg_optionset set option_nm_en = 'Whether or not to define the body file of non-electronic records as required' , option_nm_jp = '非電子記録物　本文ファイル　必須有無', option_nm_cn = '非电子记录物本文文的必选与否' where option_id = 'np310';
update tcmg_optionset set option_desc_en = 'You can set Use / Do Not Use for the reservation message button in the Send Message window.' , option_desc_jp = 'メッセージの送信画面の予約メッセージのボタン使用/未使用を設定することができます。', option_desc_cn = '可以设置发送纸条窗口内的预约纸条按键的使用与否。' where option_id = 'app100';
update tcmg_optionset set option_desc_en = 'You can set Enable / Disable for attachment button in the Send Message window.' , option_desc_jp = 'メッセージ送信画面の添付ファイルのボタンの使用/未使用を設定することができます。', option_desc_cn = '可以设置发送纸条窗口内的附件按键的使用与否。' where option_id = 'app200';
update tcmg_optionset set option_desc_en = 'Limit the total size of attachments for a message (MB).' , option_desc_jp = '1件のメッセージに送られる添付ファイルの総容量を制限します。(MB)', option_desc_cn = '限制1条纸条上可以发送的附件总容量。(MB)' where option_id = 'app201';
update tcmg_optionset set option_desc_en = 'Limit the number of attachments for a message.' , option_desc_jp = '1件のメッセージに送られる添付ファイルの総本数を制限します。', option_desc_cn = '限制1条纸条上可以发送的附件总数量。' where option_id = 'app202';
update tcmg_optionset set option_desc_en = 'Limit the size of each attachment for a message (MB).' , option_desc_jp = 'メッセージ内に含まれる添付ファイル1個当りの容量を制限します。(MB)', option_desc_cn = '限制纸条中包括的每个附件的容量。(MB)' where option_id = 'app203';
update tcmg_optionset set option_desc_en = 'Determine whether to allow chat rooms to add files.' , option_desc_jp = 'チャットルームのファイル添付機能を提供有無を設定できます。', option_desc_cn = '决定聊天室是否提供附件功能。' where option_id = 'app300';
update tcmg_optionset set option_desc_en = 'Limit the size of each attachment for a conversation (MB).' , option_desc_jp = 'チャットに送られる添付ファイル1件に対する容量を制限します。(MB)', option_desc_cn = '限制聊天中所发送的1件附件的容量。(MB)' where option_id = 'app301';
update tcmg_optionset set option_desc_en = 'Restriction on the download of attachments from mobile regardless of WEB (Three options are available: disabled when the function is not selected; downloading files; and document viewer).' , option_desc_jp = 'WEBとは関係なくモバイルで添付ファイルのダウンロードを制限する機能(米選択時に使用しない/ファイルらしい/文書ビューアー三つのオプションで使用可能)', option_desc_cn = '与WEB无关，在手机上限制下载附件的功能。(未选择时可以以不使用/下载文件/文件阅览等三个选项来使用)' where option_id = 'app400';
update tcmg_optionset set option_desc_en = 'You can decide how to set employees view.' , option_desc_jp = '社員表示方式を設定することができます。', option_desc_cn = '可以决定查看职员的方式。' where option_id = 'app500';
update tcmg_optionset set option_desc_en = 'It can be used for on mobile as well depending on the attachments view of WEB by module (when not using the function, attachments viewer and download are limited.)' , option_desc_jp = 'WEBのモジュール別添付ファイル表示設定オプションにより,モバイルにも使用できます。(未使用の場合,モバイルでは添付ファイルビューアーおよびダウンロードが制限されます。)', option_desc_cn = '根据查看WEB各模块附件的设置选项，也可以在手机上使用。(未使用时在手机上限制附件阅览及下载)' where option_id = 'app600';
update tcmg_optionset set option_desc_en = 'You can download attachments from the business report menu, or use Quick View through document viewer.' , option_desc_jp = '業務報告メニューの添付ファイルダウンロード,または文書ビューアのすぐ表示機能を使用することができます。', option_desc_cn = '可以使用下载业务报告菜单的附件或者通过文件阅览的快捷键功能' where option_id = 'appPathSeq1300';
update tcmg_optionset set option_desc_en = 'You can download attachments from the e-approval menu, or use Quick View through document viwer.' , option_desc_jp = '電子決裁メニューの添付ファイルのダウンロードまたは文書ビューアーのすぐ表示機能を使用することができます。', option_desc_cn = '可以使用下载电子审批菜单的附件或者通过文件阅览的快捷键功能' where option_id = 'appPathSeqEa';
update tcmg_optionset set option_desc_en = 'You can set the screen for forced logout when logging in WEB for a long period of time.' , option_desc_jp = 'Web長時間ログイン時,強制ログアウト画面を設定することができます。', option_desc_cn = '长时间登录WEB时，可以设置对强制退出的画面。' where option_id = 'cm102_1';
update tcmg_optionset set option_desc_en = 'Set the password expiration date from the date of the last password change per user (Enter by day / 0: no limit).' , option_desc_jp = '使用者別の最後の暗証番号変更日から暗証番号の有効期限を設定します。(一日単位で入力/0:制限なし)', option_desc_cn = '各用户设置最后修改密码日期到密码期满日期。(输入日单位 / 0:没有限制)' where option_id = 'cm201';
update tcmg_optionset set option_desc_en = 'Select input restriction items when setting ID. It is not applied when registering/changing ID after inputting the selected restriction item (Multi selection available).' , option_desc_jp = 'IDの設定時,入力制限項目を選択します。 選択した制限項目を入力した後,ID登録/変更の際は適用されません。(マルチ選択可能)', option_desc_cn = '设置用户名时选择输入限制项目。输入所选的限制项目后登录/修改用户名时不被适用。(可以选择多种)' where option_id = 'cm206';
update tcmg_optionset set option_desc_en = 'Default font settings' , option_desc_jp = '基本フォント設定', option_desc_cn = '设置基本字体' where option_id = 'cm301';
update tcmg_optionset set option_desc_en = 'Default font size settings' , option_desc_jp = '基本フォントサイズ設定', option_desc_cn = '设置基本字体大小' where option_id = 'cm302';
update tcmg_optionset set option_desc_en = 'Default line spacing settings' , option_desc_jp = '基本行間隔設定', option_desc_cn = '设置基本段隔' where option_id = 'cm303';
update tcmg_optionset set option_desc_en = 'Bottom icon layout settings' , option_desc_jp = 'レイアウト下段アイコン設定', option_desc_cn = '设置页面下端图标' where option_id = 'cm850';
update tcmg_optionset set option_desc_en = 'You can set up the automatic deletion of message data, including mobile and messenger after storage for a certain period of time.

You can set up to archive messages permanently, or to automatically delete attachments, or messages + attachments after storage for a certain period of time.

(※Attachments will not be deleted in the case of favorite messages, unsent reservation messages, favorite chat rooms, and project chat rooms.※)' , option_desc_jp = 'モバイル,メッセンジャーを含むチャットデータを一定期間保存した後,自動削除されるように設定することができます。

チャットの永久保管,添付ファイル,またはメッセージ内容+添付ファイルを
一定期間保存してから自動削除されるように設定することができます。

(※添付ファイルが削除されない場合:関心メッセージ,予約未送信メッセージ,お気に入りのチャットルーム,プロジェクトチャットルーム※)', option_desc_cn = '可以设置为一定期间内保存包括手机、MSN的纸条数据后将被自动删除。

对纸条，可以设置为永久保存或者一定时期内保存附件或者纸条内容+附件之后将被自动删除。

(※删除附件除外情况：关心纸条、预约未发送纸条、搜藏的聊天室、项目聊天室※)' where option_id = 'com100';
update tcmg_optionset set option_desc_en = 'The storage period can be set in days.
After the defined storage period, data will be automatically deleted.
The deleted data cannot be restored.

The storage period can be set to [30 days minimum / 1095 days maximum].' , option_desc_jp = '保存期間は日単位で設定可能で,

設定した保存期間が過ぎると,データを自動削除されます。

また,削除されたデータは復元が不可能です。



保存期間は[最小30日/最大1095日]まで設定できます。', option_desc_cn = '保存期间可以按日期单位设置，
所设置的保存期间已过，数据将被自动删除。
而且被删除的数据无法恢复。

保存期间可以设置为[最短30天/最长1095天]。' where option_id = 'com101';
update tcmg_optionset set option_desc_en = 'You can set up the automatic deletion of message data, including mobile and messenger after storage for a certain period of time.

You can set up to archive messages permanently, or to automatically delete attachments, or messages + attachments after storage for a certain period of time.

(※Attachments will not be deleted in the case of favorite messages, unsent reservation messages, favorite chat rooms, and project chat rooms.※)' , option_desc_jp = 'モバイル,メッセンジャーを含むチャットデータを一定期間保存した後,自動削除されるように設定することができます。

チャットの永久保管,添付ファイル,またはメッセージ内容+添付ファイルを
一定期間保存してから自動削除されるように設定することができます。

(※添付ファイルが削除されない場合:関心メッセージ,予約未送信メッセージ,お気に入りのチャットルーム,プロジェクトチャットルーム※)', option_desc_cn = '可以设置为一定期间内保存包括手机、MSN的纸条数据后将被自动删除。

对聊天，可以设置为永久保存或者一定时期内保存附件或者纸条内容+附件之后将被自动删除。

(※删除附件除外情况：关心纸条、预约未发送纸条、搜藏的聊天室、项目聊天室※)' where option_id = 'com200';
update tcmg_optionset set option_desc_en = 'The storage period can be set in days.
After the defined storage period, data will be automatically deleted.
The deleted data cannot be restored.

The storage period can be set to [30 days minimum / 1095 days maximum].' , option_desc_jp = '保管期間は日単位で設定可能で,

設定した保管期間が過ぎると,データを自動削除処理します。

また,削除されたデータは復元が不可能です。



保管期間は[最小30日/最大1095日]まで設定できます。', option_desc_cn = '保存期间可以按日期单位设置，
所设置的保存期间已过，数据将被自动删除。
而且被删除的数据无法恢复。

保存期间可以设置为[最短30天/最长1095天]。' where option_id = 'com201';
update tcmg_optionset set option_desc_en = 'The storage period can be set in days.
After the defined storage period, data will be automatically deleted.
The deleted data cannot be restored.

The storage period can be set to [30 days minimum / 1095 days maximum].' , option_desc_jp = '保存期間は日単位で設定可能で,

設定した保存期間が過ぎると,データを自動削されます。

また,削除されたデータは復元が不可能です。



保存期間は[最小30日/最大1095日]まで設定できます。', option_desc_cn = '保存期间可以按日期单位设置，
所设置的保存期间已过，数据将被自动删除。
而且被删除的数据无法恢复。

保存期间可以设置为[最短30天/最长1095天]。' where option_id = 'com301';
update tcmg_optionset set option_desc_en = 'You can set up to cancel approval on a finalized document when closing an external sytstem-electronic approval interlocked document.
However, this function is provided if the set values of ''Approval Process Management> Property Value Setting> Termination Type> Cancellation of Approval'' are available.
※ Documents linked with attendance should be used with [RECALL/DELETE] in the Attendance Application TIME-TIME APPLICATION MANAGEMENT menu.' , option_desc_jp = '外部システム - 電子決裁の連動文書が決裁終了時に終結した文書を取り消すできるように設定できます。
但し,決裁プロセス管理 > 属性値設定 > 「終結」 の種類 > 決裁取消可否の変数に対する設定値が
可能である場合提供されます。
※勤怠連動文書は,「勤怠申請管理」メニューで,[回収/削除]で使用できます。', option_desc_cn = '外部系统-电子审批的联动文件审批结束时，可以设置为取消审批已结束的文件。
但是，只在可以设置审批程序管理〉属性值设置〉''结束''种类〉是否取消审批等变数值时才能提供。
※出勤联动文件只能使用''出勤申请管理''菜单中的[回收/删除]功能。' where option_id = 'ea221';
update tcmg_optionset set option_desc_en = 'When you redraft create a returned approval document, you can mark the document as an icon in the approval box list.' , option_desc_jp = '返却された決裁文書を再起案して作成した決裁文書に対して,決裁ボックスリストにアイコンで表示することができます。', option_desc_cn = '再次申请被退回的审批文件时，对此审批文件能以图标表示在审批文件箱列表上。' where option_id = 'ea424';
update tcmg_optionset set option_desc_en = 'You can set how to display the approval date information marked on approval documents.  Please make a combination of year (y), month (m), and day (d).

※ Default format: yyyy-mm-dd
※ Other examples: yyyy/mm/dd, yy/mm/dd, yyyymmdd, yy.m.d

 However, if a date format that you make does not work, the default format will be applied.' , option_desc_jp = '決裁文書に表記された決裁日付情報の表示形式を設定することができます。
年(y),月(m),仕事(d)を組み合わせて作成してください。

※ 基本表示:yyy-mm-dd
※作成例: yyyy/mm/dd, yy/mm/dd, yyyymmdd, yy.m.d


 但し,入力された日付形式が合わない場合は,基本タイプで提供されます。', option_desc_cn = '可以设置要表示在审批文件中的审批日期信息的显示形式。
请组合年(y)、月(m)、日(d)而填写。


※ 基本显示 : yyyy-mm-dd
※ 填写例子 : yyyy/mm/dd, yy/mm/dd, yyyymmdd, yy.m.d

但是，输入的日期形式错误时，按照基本显示形式而提供。
' where option_id = 'ea501';
update tcmg_optionset set option_desc_en = 'Display of approval line Login_Id' , option_desc_jp = '決裁ライン Login_Id表示可否', option_desc_cn = '审批层次上是否显示Login_Id' where option_id = 'ea510';
update tcmg_optionset set option_desc_en = 'Automatically transfer electronic approval documents based on the selected setting value of [Form/ Organization/Organization C + Department].' , option_desc_jp = '[様式/ 組織図/組織図+部署]の中で選択した設定値基準で電子決裁文書を自動移管設定する。', option_desc_cn = '按照[样式/组织图/组织图+部门]中所选的设定值标准，将设置为自动移交电子审批文件。' where option_id = 'eatf100';
update tcmg_optionset set option_desc_en = 'Set the default selection value for the document box when reporting approval.

If it is set to auto-transfer, transfer to the document box, and if not set, expose the set value of the option.

(However, you can manually change the document box when you create a draft..)


-Move to primary archive, or to the default archive when closing document.

-If the document is terminated as no selection, the document will not be transferred.' , option_desc_jp = '決裁の上申時,文書ボックスの基本選択値を設定します。

自動移管設定がされている場合は,設定された文書ボックスに移管し,設定されていない場合はオプションの設定値を表示します。

(但し,文書ボックスは,使用者が起案作成時の手動に変更可能です。)


-基本保管ボックスに文書終結時,基本保管ボックスに移動

-選択なしの文書終結の際,文書移管しない', option_desc_cn = '申请审批时设置文件箱的基本选项值。
被设置为自动移交时将会移动到所设置的文件箱，没有设置时会显示选项设定值。

(但是，文件箱是用户填写申请时可以修改为手动。)

-以基本保管箱结束文件时将移动到基本保管箱。

- 没有选择而结束文件时不移动文件。' where option_id = 'eatf110';
update tcmg_optionset set option_desc_en = 'Determine the implementation of the automatic login selection feature within the messenger login page.' , option_desc_jp = 'メッセンジャーログインページ内の自動ログインの選択機能を設定することができます。', option_desc_cn = '决定对MSN登录页面内自动登录选项功能的实现。' where option_id = 'msg100';
update tcmg_optionset set option_desc_en = 'Decide the settings for message notification. If it is set to auto-transfer, transfer to the set bin, and if not set, expose the set value of the option.' , option_desc_jp = 'メッセージお知らせを設定することができます。', option_desc_cn = '决定对纸条提醒窗口的设置。' where option_id = 'msg1000';
update tcmg_optionset set option_desc_en = 'Decide how to set up conversation' , option_desc_jp = 'チャットルームお知らせを設定することができます。', option_desc_cn = '决定对聊天提醒窗口的设置。' where option_id = 'msg1100';
update tcmg_optionset set option_desc_en = 'You can decide the methods of employment view (However, the user can change the document manually when creating a draft.)' , option_desc_jp = '社員表示方式を設定することができます。', option_desc_cn = '可以决定查看职员的方式。' where option_id = 'msg1200';
update tcmg_optionset set option_desc_en = 'You can decide the methods of employment view' , option_desc_jp = '社員表示方式を決定できます。', option_desc_cn = '可以决定查看职员的方式。' where option_id = 'msg1300';
update tcmg_optionset set option_desc_en = 'Determines the functionality available when you double-click the manpower parts in the organization.' , option_desc_jp = '組織図マイ人数部分をダブルクリック時の機能有無を決めます。', option_desc_cn = '决定双击组织图内人员部分时的功能部分。' where option_id = 'msg1400';
update tcmg_optionset set option_desc_en = 'Determines the settings for the skin color.' , option_desc_jp = 'スキンカラーに対する設定を決定します。', option_desc_cn = '决定对皮肤颜色的设置。' where option_id = 'msg1500';
update tcmg_optionset set option_desc_en = 'According to the setting values for attachment view of WEB, PC messenger supports the features of attachment download and viewer. (When you do not use the features, the use of viewer and download will be limited for the attachments of message/conversation rooms in PC messenger.)' , option_desc_jp = 'WEBの添付ファイル表示設定オプションのメモ/チャットルームの設定値によって,PCメッセンジャーで添付ファイルのダウンロード及びビューア表示機能を支援します。(未使用時のPCメシンジャーのメモ/チャットルームの添付ファイルに対してビューアー及びダウンロードが制限されます。', option_desc_cn = '根据查看WEB的附件设置选项的纸条/聊天室的设定值，支援在PC的MSN上下载附件及阅览功能。(未使用时，对PC的MSN上的纸条/聊天室附件限制阅览及下载)' where option_id = 'msg1600';
update tcmg_optionset set option_desc_en = 'Determine the implementation for the Save My Password option in the messenger login page.' , option_desc_jp = 'メッセンジャーログインページ内のパスワード保存選択機能の使用梅を決めます。', option_desc_cn = '决定对MSN登录页面内保存密码选项功能的实现。' where option_id = 'msg1700';
update tcmg_optionset set option_desc_en = 'PC messenger supports attachment download and viewing is supported. (When you do not use the features, the use of viewer and download will be limited for the attachments of message/conversation rooms in PC messenger.)' , option_desc_jp = 'PCメッセンジャーで添付ファイルのダウンロード及びビューア表示機能をサポートします。(未使用時のPCメッセンジャーのメモ/対話ルームの添付ファイルに対してビューアー及びダウンロードが制限されます。)', option_desc_cn = '支援在PC的MSN上下载附件及阅览功能。(未使用时，对PC的MSN上的纸条/聊天室附件限制阅览及下载)' where option_id = 'msg1800';
update tcmg_optionset set option_desc_en = 'Decide the implementation of the function that will be automatically processed as attendance at the time of IM login.' , option_desc_jp = 'メッセンジャーログイン時,自動的に出勤処理される機能の実現を決めます。', option_desc_cn = '决定对登录MSN时自动处理为上班功能的实现。' where option_id = 'msg200';
update tcmg_optionset set option_desc_en = 'Decide whether to check password when calling the WEB page of groupware.' , option_desc_jp = 'グループウェア WEB ページを呼び出す際,パスワードのチェック処理をするかどうかを決めます。', option_desc_cn = '决定呼叫OA系统WEB页面时，是否要确认密码。' where option_id = 'msg300';
update tcmg_optionset set option_desc_en = 'If IE8 or later, decide whether or not to call the WEB page with a new session.' , option_desc_jp = 'IE8以上の場合,新しいセッションでWEBページを呼び出すかどうかを決めます。', option_desc_cn = '决定IE8以上时是否以新的会话呼叫WEB页面。' where option_id = 'msg400';
update tcmg_optionset set option_desc_en = 'Decide the view of organization displayed on the main of PC messenger.' , option_desc_jp = 'PCメッセンジャーのメインに表示する組織図の表示方式を決めます。', option_desc_cn = '决定显示在PC的ＭＳＮ主页上的组织图查看方式。' where option_id = 'msg500';
update tcmg_optionset set option_desc_en = 'Decide whether or not to provide the function of reservation page.' , option_desc_jp = '予約メッセージ機能の提供可否を決定します。', option_desc_cn = '决定是否提供预约纸条功能。' where option_id = 'msg600';
update tcmg_optionset set option_desc_en = 'Decide whether or not to allow messages to add attachments.' , option_desc_jp = 'メッセージファイル添付機能を提供するかどうかを決定します。', option_desc_cn = '决定是否提供纸条附件功能。' where option_id = 'msg800';
update tcmg_optionset set option_desc_en = 'Limit the total size of attachments that can be sent to a message (MB).' , option_desc_jp = '1件のメッセージに送られる添付ファイルの総容量を制限します。(MB)', option_desc_cn = '限制1条纸条上可以发送的附件总容量。(MB)' where option_id = 'msg810';
update tcmg_optionset set option_desc_en = 'Limit the total number of attachments that can be sent to one message.' , option_desc_jp = '1件のメッセージに送られる添付ファイルの総本数を制限します。', option_desc_cn = '限制1条纸条上可以发送的附件总数量。' where option_id = 'msg820';
update tcmg_optionset set option_desc_en = 'Limit the size of each attachment included in a message (MB).' , option_desc_jp = 'メモ内に含まれる添付ファイル1個当りの容量を制限します。(MB)', option_desc_cn = '限制纸条中包括的每个附件的容量。(MB)' where option_id = 'msg830';
update tcmg_optionset set option_desc_en = 'Determine whether or not to allow chat rooms to attach files.' , option_desc_jp = 'チャットルームのファイル添付機能を提供するかどうかを決めます。', option_desc_cn = '决定聊天室是否提供附件功能。' where option_id = 'msg900';
update tcmg_optionset set option_desc_en = 'Limit the size of each attachment that you can send to a conversation (MB).' , option_desc_jp = 'チャットルームに送られる添付ファイル1件に対する容量を制限します。(MB)', option_desc_cn = '限制聊天中所发送的1件附件的容量。(MB)' where option_id = 'msg910';
update tcmg_optionset set option_desc_en = 'Ability to limit the number of pop-ups at conversation room' , option_desc_jp = 'チャットルームのポップアップ数を制限する機能', option_desc_cn = '限制聊天室弹出窗口个数的功能' where option_id = 'msg920';
update tcmg_optionset set option_desc_en = 'Whether or not to use a password for approval' , option_desc_jp = '決裁時暗号入力可否', option_desc_cn = '审批时是否输入密码' where option_id = 'np100';
update tcmg_optionset set option_desc_en = 'Whether or not to close the pop-up window after completing the approval' , option_desc_jp = '決裁終了後,ポップアップを閉じる有無', option_desc_cn = '审批之后是否关闭弹出窗口' where option_id = 'np101';
update tcmg_optionset set option_desc_en = 'Whether or not to define a default image/text signature' , option_desc_jp = 'イメージ/テキストサインデフォルト指定可否', option_desc_cn = '是否基本指定图像/文字的签署' where option_id = 'np111';
update tcmg_optionset set option_desc_en = 'Whether or not to use the Do Not Approve button' , option_desc_jp = '決裁しないボタン使用の可否', option_desc_cn = '是否使用不做审批按键' where option_id = 'np201';
update tcmg_optionset set option_desc_en = 'Whether or not to use the Substitute Approval button' , option_desc_jp = '代決ボタン使用可否', option_desc_cn = '是否使用待批按键' where option_id = 'np202';
update tcmg_optionset set option_desc_en = 'Whether or not to use the Agree button' , option_desc_jp = '合意ボタンの使用有無', option_desc_cn = '是否使用协议按键' where option_id = 'np203';
update tcmg_optionset set option_desc_en = 'Whether or not to use parallel cooperation ' , option_desc_jp = '並列協調使用可否', option_desc_cn = '是否使用并列协助' where option_id = 'np204';
update tcmg_optionset set option_desc_en = 'Whether or not to automatically send internal documents (excluding the case of mobile approval)' , option_desc_jp = '社内文書自動発送可否(モバイル決裁時除く)', option_desc_cn = '是否自动发送对内文件(手机审批时除外)' where option_id = 'np301';
update tcmg_optionset set option_desc_en = 'Whether or not to define the body file of non-electronic records as required' , option_desc_jp = '非電子記録物の本文ファイル　必須可否', option_desc_cn = '非电子记录物本文文件必选与否' where option_id = 'np310';



insert ignore into t_co_Code_multi values ('option0074' ,'jp' ,'(共通)フォント選択' ,'(共通)フォント選択' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0075' ,'jp' ,'(共通)フォントサイズ選択' ,'(共通)フォントサイズ選択' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0076' ,'jp' ,'(メッセンジャー)お知らせ選択' ,'(メッセンジャー)お知らせ選択' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0072' ,'jp' ,'(メッセンジャー)URLリンクアクセス' ,'(メッセンジャー)URLリンクアクセス' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0061' ,'jp' ,'(メッセンジャー)制限なし/名前/名前[担当業務]' ,'(メッセンジャー)制限なし/名前/名前[担当業務]' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0060' ,'jp' ,'(メッセンジャー)制限なし/職級/職責/ID/なし' ,'(メッセンジャー)制限なし/職級/職責/ID/なし' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0071' ,'jp' ,'(アプリ)社員表示方式の設定' ,'(アプリ)社員表示方式の設定' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0070' ,'jp' ,'(アプリ)メッセージの添付ファイル1個当たりの容量制限' ,'(アプリ)メッセージの添付ファイル1個当たりの容量制限' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0069' ,'jp' ,'(アプリ)メッセージ1個当たり添付ファイルの個数制限' ,'(アプリ)メッセージ1個当たり添付ファイルの個数制限' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0073' ,'jp' ,'(会社)組織図職級/職責表示' ,'(会社)組織図職級/職責表示' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ERP031' ,'jp' ,'ERPicube雇用形態' ,'ERPicube雇用形態' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ERP030' ,'jp' ,'ERPicube勤務区分' ,'ERPicube勤務区分' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ERP021' ,'jp' ,'ERPiu雇用タイプ' ,'ERPiu雇用タイプ' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ERP020' ,'jp' ,'ERPiu勤務区分' ,'ERPiu勤務区分' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ERP022' ,'jp' ,'ERPIU性別区分' ,'ERPIU性別区分' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ERP023' ,'jp' ,'ERPiu性別区分' ,'ERPiu性別区分' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ERP032' ,'jp' ,'ERPIU性別区分' ,'ERPIU性別区分' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ERP033' ,'jp' ,'ERPiu性別区分' ,'ERPiu性別区分' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ERP041' ,'jp' ,'GERP雇用タイプ' ,'GERP雇用タイプ' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ERP040' ,'jp' ,'GERP勤務区分' ,'GERP勤務区分' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ERP042' ,'jp' ,'GERP性別区分' ,'GERP性別区分' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('cm0103' ,'jp' ,'iU決裁ラインビュー連動使用の有無' ,'iU決裁ラインビュー連動使用の有無' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0092' ,'jp' ,'PDFファイルビュータイプ' ,'PDFファイルビュータイプ' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0205' ,'jp' ,'強制ログアウト画面設定' ,'強制ログアウト画面設定' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('It0013' ,'jp' ,'個人/部署' ,'個人/部署' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0049' ,'jp' ,'決裁サイン' ,'決裁サイン' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('COM092' ,'jp' ,'決裁持続性' ,'決裁持続性' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('cm0102' ,'jp' ,'共通コメント　お客様使用の有無' ,'共通コメント　お客様使用の有無' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('cm0104' ,'jp' ,'共通オプション,コードrebuildの判断' ,'共通オプション,コードrebuildの判断' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ex00031' ,'jp' ,'共通コード表示個数' ,'共通コード表示個数' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('It0005' ,'jp' ,'基本値(ログイン部署)' ,'基本値(ログイン部署)' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('It0004' ,'jp' ,'基本値(ログインユーザー)' ,'基本値(ログインユーザー)' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0084' ,'jp' ,'基本情報必須入力項目' ,'基本情報必須入力項目' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0204' ,'jp' ,'起案者決裁ラインの修正可能時点' ,'起案者決裁ラインの修正可能時点' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0202' ,'jp' ,'起案作成時に参照文書の照会条件を設定' ,'起案作成時に参照文書の照会条件を設定' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('It0012' ,'jp' ,'年/年月/年月日/年月日時' ,'年/年月/年月日/年月日時' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('It0011' ,'jp' ,'単一/期間' ,'単一/期間' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0091' ,'jp' ,'社内文書の宛先組織図範囲の設定' ,'社内文書の宛先組織図範囲の設定' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0150' ,'jp' ,'コメントタイプ設定' ,'コメントタイプ設定' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('COM530' ,'jp' ,'ライセンスタイプ' ,'ライセンスタイプ' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('It0009' ,'jp' ,'ライン数(1~10)' ,'ライン数(1~10)' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('mentionUseYn' ,'jp' ,'メンション使用の有無(臨時)' ,'メンション使用の有無(臨時)' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('MobileWorkCheck' ,'jp' ,'モバイル出勤チェックの使用有無' ,'モバイル出勤チェックの使用有無' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0203' ,'jp' ,'文書修正内容の表示ポップアップタイプの設定' ,'文書修正内容の表示ポップアップタイプの設定' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0200' ,'jp' ,'文書完了　文書移管基準設定' ,'文書完了　文書移管基準設定' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0201' ,'jp' ,'文書ボックス　基本選択値の設定' ,'文書ボックス　基本選択値の設定' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('cm0004' ,'jp' ,'使用　未使用' ,'使用　未使用' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('cm0101' ,'jp' ,'ユーザー決裁ボックス' ,'ユーザー決裁ボックス' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('It0007' ,'jp' ,'ユーザー·部署/ユーザー' ,'ユーザー·部署/ユーザー' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('It0003' ,'jp' ,'社員/部署' ,'社員/部署' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('COM103' ,'jp' ,'生産/受付文書の可否' ,'生産/受付文書の可否' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('It0014' ,'jp' ,'小数点数' ,'小数点数' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0067' ,'jp' ,'修正可能/不可能' ,'修正可能/不可能' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('AttTime' ,'jp' ,'業務報告　勤務時間　使用有無' ,'業務報告　勤務時間　使用有無' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('yn0001' ,'jp' ,'はい いいえ' ,'はい いいえ' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ex00004' ,'jp' ,'はい/いいえ' ,'はい/いいえ' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0025' ,'jp' ,'オプション-決裁特異事項ポップアップ' ,'オプション-決裁特異事項ポップアップ' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0026' ,'jp' ,'オプション·エディター' ,'オプション·エディター' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0001' ,'jp' ,'オプション_YN' ,'オプション_YN' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0009' ,'jp' ,'オプション_掲示期間' ,'オプション_掲示期間' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0028' ,'jp' ,'オプション_決裁保管ボックス 整列基準' ,'オプション_決裁保管ボックス 整列基準' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0017' ,'jp' ,'オプション_決裁コメントの削除権限者' ,'オプション_決裁コメントの削除権限者' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0016' ,'jp' ,'オプション_決裁コメント位置' ,'オプション_決裁コメント位置' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0015' ,'jp' ,'オプション_決裁コメント入力時,お知らせ者設定' ,'オプション_決裁コメント入力時,お知らせ者設定' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0018' ,'jp' ,'オプション_決裁コメント出力オプション' ,'オプション_決裁コメント出力オプション' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0020' ,'jp' ,'オプション_公文発送決裁ライン表示の選択' ,'オプション_公文発送決裁ライン表示の選択' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0019' ,'jp' ,'オプション_公文発送修正' ,'オプション_公文発送修正' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0030' ,'jp' ,'オプション_お知らせを出力するとき,コメントを含めるかどうか' ,'オプション_お知らせを出力するとき,コメントを含めるかどうか' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0005' ,'jp' ,'オプション_グループ会社' ,'オプション_グループ会社' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0011' ,'jp' ,'オプション_コメント整列基準' ,'オプション_コメント整列基準' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0014' ,'jp' ,'オプション_メッセンジャー組織図表示' ,'オプション_メッセンジャー組織図表示' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0003' ,'jp' ,'オプション_部署情報表示' ,'オプション_部署情報表示' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0002' ,'jp' ,'オプション_使用有無' ,'オプション_使用有無' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0007' ,'jp' ,'オプション_使用者指定範囲1' ,'オプション_使用者指定範囲1' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0012' ,'jp' ,'オプション_使用者指定範囲2' ,'オプション_使用者指定範囲2' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0010' ,'jp' ,'オプション_常時掲示整列基準' ,'オプション_常時掲示整列基準' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0035' ,'jp' ,'オプション_受信参照照会条件' ,'オプション_受信参照照会条件' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0008' ,'jp' ,'オプション_修正可否選択' ,'オプション_修正可否選択' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0013' ,'jp' ,'オプション‐年次計算基準' ,'オプション‐年次計算基準' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0029' ,'jp' ,'オプション_電子決裁PDF保存機能使用有無' ,'オプション_電子決裁PDF保存機能使用有無' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0021' ,'jp' ,'オプション_電子決裁した後,表示画面を閉じる機能使用有無' ,'オプション_電子決裁した後,表示画面を閉じる機能使用有無' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0004' ,'jp' ,'オプション_制限可否' ,'オプション_制限可否' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0033' ,'jp' ,'オプション_証明書の住民登録番号の出力タイプ' ,'オプション_証明書の住民登録番号の出力タイプ' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0022' ,'jp' ,'オプション_参照文書の照会条件' ,'オプション_参照文書の照会条件' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0006' ,'jp' ,'オプション_会社単一マルチ' ,'オプション_会社単一マルチ' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ea0033' ,'jp' ,'人監査用方式' ,'人監査用方式' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ex00029' ,'jp' ,'自動伝票伝送範囲の設定' ,'自動伝票伝送範囲の設定' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0088' ,'jp' ,'保存後閲覧/すぐ表示' ,'保存後閲覧/すぐ表示' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('COM102' ,'jp' ,'電子非電子区分' ,'電子非電子区分' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0099' ,'jp' ,'組織図照会範囲' ,'組織図照会範囲' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('CERT004' ,'jp' ,'証明書多国語' ,'証明書多国語' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ex00027' ,'jp' ,'支出決議(営利)ボタン表示有無' ,'支出決議(営利)ボタン表示有無' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ex00028' ,'jp' ,'支出決議(営利)予算使用有無' ,'支出決議(営利)予算使用有無' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0085' ,'jp' ,'職責/職位' ,'職責/職位' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0100' ,'jp' ,'メッセージ自動削除設定' ,'メッセージ自動削除設定' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0110' ,'jp' ,'メッセージ自動削除設定' ,'メッセージ自動削除設定' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0089' ,'jp' ,'ファイルダウンロード/すぐ表示' ,'ファイルダウンロード/すぐ表示' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('COM078' ,'jp' ,'偏綴確定区分' ,'偏綴確定区分' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0097' ,'jp' ,'協力前に文書採番の種類' ,'協力前に文書採番の種類' ,'Y' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('301060200' ,'jp' ,'共有カレンダー生成' ,'共有カレンダー生成' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('301080000' ,'jp' ,'私の日程全体表示' ,'私の日程全体表示' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('806000000' ,'jp' ,'認証機器管理' ,'認証機器管理' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('806001000' ,'jp' ,'二次認証機器設定' ,'二次認証機器設定' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('904000000' ,'jp' ,'業務用乗用車管理' ,'業務用乗用車管理' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('904010000' ,'jp' ,'運行記録簿' ,'運行記録簿' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('904020000' ,'jp' ,'運行記録現況' ,'運行記録現況' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('1001010000' ,'jp' ,'私の支出の現況' ,'私の支出の現況' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('1001020000' ,'jp' ,'私のカード使用現況' ,'私のカード使用現況' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('1001030000' ,'jp' ,'私の税金計算書の現況(ERPiU)' ,'私の税金計算書の現況(ERPiU)' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('1001040000' ,'jp' ,'私の税金計算書の現況(iCUBE)' ,'私の税金計算書の現況(iCUBE)' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('1003020000' ,'jp' ,'私の予實対比現況(iCUBE)' ,'私の予實対比現況(iCUBE)' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('1003030000' ,'jp' ,'私の予實対比現況(ERPiU)' ,'私の予實対比現況(ERPiU)' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('2006020007' ,'jp' ,'受信上新内駅' ,'受信上新内駅' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('2007020021' ,'jp' ,'時間外勤務現況(管理者)' ,'時間外勤務現況(管理者)' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('2007020050' ,'jp' ,'既決(終結)' ,'既決(終結)' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('401020000' ,'jp' ,'プロジェクト業務管理' ,'プロジェクト業務管理' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('607003000' ,'jp' ,'文書自動移管設定' ,'文書自動移管設定' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('607004000' ,'jp' ,'自動移管オプション設定' ,'自動移管オプション設定' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('705040000' ,'jp' ,'移転文書箱(全)' ,'移転文書箱(全)' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('707000000' ,'jp' ,'決裁設定管理' ,'決裁設定管理' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('707010000' ,'jp' ,'社員別の代決管理' ,'社員別の代決管理' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('803000000' ,'jp' ,'記録物綴引受/引き継ぎ' ,'記録物綴引受/引き継ぎ' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('803010000' ,'jp' ,'引継ぎ' ,'引継ぎ' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('803010100' ,'jp' ,'引継ぎ申請' ,'引継ぎ申請' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('803010300' ,'jp' ,'引継ぎ現況' ,'引継ぎ現況' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('803020000' ,'jp' ,'引受' ,'引受' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('803020100' ,'jp' ,'課引受待機' ,'課引受待機' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('803020200' ,'jp' ,'マイ引受ボックス' ,'マイ引受ボックス' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('803020300' ,'jp' ,'課引受進行' ,'課引受進行' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('803020400' ,'jp' ,'課引受完了ボックス' ,'課引受完了ボックス' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('804000000' ,'jp' ,'記録物引受/引継' ,'記録物引受/引継' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('804010000' ,'jp' ,'引継ぎ' ,'引継ぎ' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('804010100' ,'jp' ,'記録物引継申請' ,'記録物引継申請' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('804010200' ,'jp' ,'記録物引継待機' ,'記録物引継待機' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('804010300' ,'jp' ,'記録物引継現況' ,'記録物引継現況' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('804020000' ,'jp' ,'引き継ぎ' ,'引き継ぎ' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('805030000' ,'jp' ,'稟議/決議書現況' ,'稟議/決議書現況' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('806010000' ,'jp' ,'決裁オプション設定' ,'決裁オプション設定' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('808000000' ,'jp' ,'決裁グループ管理' ,'決裁グループ管理' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('808020000' ,'jp' ,'決裁グループ設定' ,'決裁グループ設定' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('810104000' ,'jp' ,'ICUBE連動文書現状' ,'ICUBE連動文書現状' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('810105000' ,'jp' ,'税金計算書現況(iCUBE)' ,'税金計算書現況(iCUBE)' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('810106000' ,'jp' ,'税金計算書現況(ERPiU)' ,'税金計算書現況(ERPiU)' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('810211000' ,'jp' ,'名称設定' ,'名称設定' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('810212000' ,'jp' ,'ボタン設定' ,'ボタン設定' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('810213000' ,'jp' ,'購入電子税金計算書の権限設定' ,'購入電子税金計算書の権限設定' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('810214000' ,'jp' ,'様式別に標準適用&証憑類型を設定' ,'様式別に標準適用&証憑類型を設定' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('810215000' ,'jp' ,'締め切りの設定' ,'締め切りの設定' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('810502000' ,'jp' ,'予實対比現況(iCUBE)' ,'予實対比現況(iCUBE)' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('810503000' ,'jp' ,'予實比現況(ERPiU)' ,'予實比現況(ERPiU)' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('905050000' ,'jp' ,'プロジェクト採番管理' ,'プロジェクト採番管理' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('910400000' ,'jp' ,'業務用乗用車管理' ,'業務用乗用車管理' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('910400100' ,'jp' ,'運行記録現況' ,'運行記録現況' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('911030200' ,'jp' ,'文字統計' ,'文字統計' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('1106010000' ,'jp' ,'決裁オプション設定' ,'決裁オプション設定' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('1108000000' ,'jp' ,'決裁グループ管理' ,'決裁グループ管理' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('1108020000' ,'jp' ,'決裁グループ設定' ,'決裁グループ設定' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('1401020000' ,'jp' ,'プロジェクト業務管理' ,'プロジェクト業務管理' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('1607003000' ,'jp' ,'文書自動移管設定' ,'文書自動移管設定' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('1607004000' ,'jp' ,'自動移管オプション設定' ,'自動移管オプション設定' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('1705040000' ,'jp' ,'移転文書箱(全)' ,'移転文書箱(全)' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('1707000000' ,'jp' ,'決裁設定管理' ,'決裁設定管理' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('1707010000' ,'jp' ,'社員別の代決管理' ,'社員別の代決管理' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('1909001000' ,'jp' ,'二次認証設定' ,'二次認証設定' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('2104040010' ,'jp' ,'勤怠内容の管理' ,'勤怠内容の管理' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('2104040011' ,'jp' ,'勤務変更申請の現況' ,'勤務変更申請の現況' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('2104040016' ,'jp' ,'ERP勤怠連動' ,'ERP勤怠連動' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('2104040017' ,'jp' ,'期間別勤怠伝送' ,'期間別勤怠伝送' ,null ,null,null,null);


insert ignore into t_co_Code_multi values ('option0074' ,'cn' ,'(共同)选择大体字' ,'(共同)选择大体字' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0075' ,'cn' ,'(共同)选择字体大小' ,'(共同)选择字体大小' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0076' ,'cn' ,'(MSN)选择提醒处理' ,'(MSN)选择提醒处理' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0072' ,'cn' ,'(MSN)打开URL链接' ,'(MSN)打开URL链接' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0061' ,'cn' ,'(MSN)不限制/姓名/姓名[担任业务]' ,'(MSN)不限制/姓名/姓名[担任业务]' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0060' ,'cn' ,'(MSN)不限制/职位/职责/用户名/没有' ,'(MSN)不限制/职位/职责/用户名/没有' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0071' ,'cn' ,'(软件)设置查看职员的方式' ,'(软件)设置查看职员的方式' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0070' ,'cn' ,'(软件)限制纸条附件每个容量' ,'(软件)限制纸条附件每个容量' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0069' ,'cn' ,'(软件)限制各纸条附件数量' ,'(软件)限制各纸条附件数量' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0073' ,'cn' ,'(公司)显示组织图职责/职称' ,'(公司)显示组织图职责/职称' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ERP031' ,'cn' ,'ERP icube雇佣形态' ,'ERP icube雇佣形态' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ERP030' ,'cn' ,'ERP icube出勤区分' ,'ERP icube出勤区分' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ERP021' ,'cn' ,'ERP iu雇佣形态' ,'ERP iu雇佣形态' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ERP020' ,'cn' ,'ERP iu出勤区分' ,'ERP iu出勤区分' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ERP022' ,'cn' ,'ERP iu性别区分' ,'ERP iu性别区分' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ERP023' ,'cn' ,'ERP iu性别区分' ,'ERP iu性别区分' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ERP032' ,'cn' ,'ERP iu性别区分' ,'ERP iu性别区分' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ERP033' ,'cn' ,'ERP iu性别区分' ,'ERP iu性别区分' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ERP041' ,'cn' ,'GERP雇佣形态' ,'GERP雇佣形态' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ERP040' ,'cn' ,'GERP出勤区分' ,'GERP出勤区分' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ERP042' ,'cn' ,'GERP性别区分' ,'GERP性别区分' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('cm0103' ,'cn' ,'是否使用iU审批层次游览联动' ,'是否使用iU审批层次游览联动' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0092' ,'cn' ,'PDF文件游览类型' ,'PDF文件游览类型' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0205' ,'cn' ,'强制退出画面设置' ,'强制退出画面设置' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('It0013' ,'cn' ,'个人/部门' ,'个人/部门' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0049' ,'cn' ,'审批签署' ,'审批签署' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('COM092' ,'cn' ,'审批者属性' ,'审批者属性' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('cm0102' ,'cn' ,'是否使用共同回帖客户' ,'是否使用共同回帖客户' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('cm0104' ,'cn' ,'判断共同选项、代码rebuild与否' ,'判断共同选项、代码rebuild与否' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ex00031' ,'cn' ,'共同代码显示个数' ,'共同代码显示个数' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('It0005' ,'cn' ,'基本值(登录部门)' ,'基本值(登录部门)' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('It0004' ,'cn' ,'基本值(登录用户)' ,'基本值(登录用户)' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0084' ,'cn' ,'基本信息必选输入项目' ,'基本信息必选输入项目' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0204' ,'cn' ,'可以修改申请者审批层次的时点' ,'可以修改申请者审批层次的时点' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0202' ,'cn' ,'填写申请时设置参考文件查询条件' ,'填写申请时设置参考文件查询条件' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('It0012' ,'cn' ,'年/年月/年月日/年月日时' ,'年/年月/年月日/年月日时' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('It0011' ,'cn' ,'单一/期间' ,'单一/期间' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0091' ,'cn' ,'设置对内文件收件处组织图范围' ,'设置对内文件收件处组织图范围' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0150' ,'cn' ,'设置回帖类型' ,'设置回帖类型' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('COM530' ,'cn' ,'许可证种类' ,'许可证种类' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('It0009' ,'cn' ,'层次数(1~10)' ,'层次数(1~10)' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('mentionUseYn' ,'cn' ,'是否使用指定(临时)' ,'是否使用指定(临时)' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('MobileWorkCheck' ,'cn' ,'是否使用手机出勤确认' ,'是否使用手机出勤确认' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0203' ,'cn' ,'设置查看文件修改内容弹出窗口类型' ,'设置查看文件修改内容弹出窗口类型' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0200' ,'cn' ,'设置结束文件的移交标准' ,'设置结束文件的移交标准' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0201' ,'cn' ,'设置文件箱基本默认值' ,'设置文件箱基本默认值' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('cm0004' ,'cn' ,'使用未使用' ,'使用未使用' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('cm0101' ,'cn' ,'用户审批箱Batch' ,'用户审批箱Batch' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('It0007' ,'cn' ,'用户、部门/用户' ,'用户、部门/用户' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('It0003' ,'cn' ,'职员/部门' ,'职员/部门' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('COM103' ,'cn' ,'生产/接收文件与否' ,'生产/接收文件与否' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('It0014' ,'cn' ,'小数点位数' ,'小数点位数' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0067' ,'cn' ,'可以/不可以修改' ,'可以/不可以修改' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('AttTime' ,'cn' ,'是否使用业务报告出勤时间' ,'是否使用业务报告出勤时间' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('yn0001' ,'cn' ,'是否' ,'是否' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ex00004' ,'cn' ,'是/否' ,'是/否' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0025' ,'cn' ,'选项-审批特殊事项弹出窗口处理' ,'选项-审批特殊事项弹出窗口处理' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0026' ,'cn' ,'选项-编辑' ,'选项-编辑' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0001' ,'cn' ,'选项_YN' ,'选项_YN' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0009' ,'cn' ,'选项_留言板显示时间' ,'选项_留言板显示时间' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0028' ,'cn' ,'选项_审批保管箱整列标准' ,'选项_审批保管箱整列标准' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0017' ,'cn' ,'选项_审批意见可删除权限者' ,'选项_审批意见可删除权限者' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0016' ,'cn' ,'选项_审批意见位置' ,'选项_审批意见位置' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0015' ,'cn' ,'选项_输入审批意见时设置提醒者' ,'选项_输入审批意见时设置提醒者' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0018' ,'cn' ,'选项_审批意见打印选项' ,'选项_审批意见打印选项' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0020' ,'cn' ,'选项_选择公文发送审批层次显示' ,'选项_选择公文发送审批层次显示' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0019' ,'cn' ,'选项_修改公文发送' ,'选项_修改公文发送' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0030' ,'cn' ,'选项_打印公告留言板时是否包括回帖' ,'选项_打印公告留言板时是否包括回帖' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0005' ,'cn' ,'选项_集团企业' ,'选项_集团企业' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0011' ,'cn' ,'选项_回帖整列标准' ,'选项_回帖整列标准' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0014' ,'cn' ,'选项_查看MSN组织图' ,'选项_查看MSN组织图' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0003' ,'cn' ,'选项_显示部门信息' ,'选项_显示部门信息' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0002' ,'cn' ,'选项_使用与否' ,'选项_使用与否' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0007' ,'cn' ,'选项_用户指定范围1' ,'选项_用户指定范围1' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0012' ,'cn' ,'选项_用户指定范围2' ,'选项_用户指定范围2' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0010' ,'cn' ,'选项_随时公告整列标准' ,'选项_随时公告整列标准' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0035' ,'cn' ,'选项_查询抄送条件' ,'选项_查询抄送条件' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0008' ,'cn' ,'选项_选择是否修改' ,'选项_选择是否修改' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0013' ,'cn' ,'选项_年假计算标准' ,'选项_年假计算标准' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0029' ,'cn' ,'选项_是否使用电子审批PDF保存功能' ,'选项_是否使用电子审批PDF保存功能' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0021' ,'cn' ,'选项_电子审批之后是否关闭查看画面' ,'选项_电子审批之后是否关闭查看画面' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0004' ,'cn' ,'选项_限制与否' ,'选项_限制与否' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0033' ,'cn' ,'选项_证明书上居民登录号码打印类型' ,'选项_证明书上居民登录号码打印类型' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0022' ,'cn' ,'选项_查看参照文件条件' ,'选项_查看参照文件条件' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0006' ,'cn' ,'选项_企业单一多功能' ,'选项_企业单一多功能' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ea0033' ,'cn' ,'印章使用方式' ,'印章使用方式' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ex00029' ,'cn' ,'设置自动凭证传送范围' ,'设置自动凭证传送范围' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0088' ,'cn' ,'保存后打开/直接查看' ,'保存后打开/直接查看' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('COM102' ,'cn' ,'电子非电子区分' ,'电子非电子区分' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0099' ,'cn' ,'组织图查看范围' ,'组织图查看范围' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('CERT004' ,'cn' ,'证明书多国语言' ,'证明书多国语言' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ex00027' ,'cn' ,'是否显示支出决议(盈利)按键' ,'是否显示支出决议(盈利)按键' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('ex00028' ,'cn' ,'是否使用支出决议(盈利)预算' ,'是否使用支出决议(盈利)预算' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0085' ,'cn' ,'职责/职位' ,'职责/职位' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0100' ,'cn' ,'自动删除纸条设置' ,'自动删除纸条设置' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0110' ,'cn' ,'自动删除纸条设置' ,'自动删除纸条设置' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0089' ,'cn' ,'下载文件/直接查看' ,'下载文件/直接查看' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('COM078' ,'cn' ,'确定保留区分' ,'确定保留区分' ,'Y' ,null ,null,null,null);
insert ignore into t_co_Code_multi values ('option0097' ,'cn' ,'协助函文件编号种类' ,'协助函文件编号种类' ,'Y' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('301060200' ,'cn' ,'生成共享日历' ,'生成共享日历' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('301080000' ,'cn' ,'查看我的所有日程' ,'查看我的所有日程' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('806000000' ,'cn' ,'认证设备管理' ,'认证设备管理' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('806001000' ,'cn' ,'设置二次认证设备' ,'设置二次认证设备' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('904000000' ,'cn' ,'业务用轿车管理' ,'业务用轿车管理' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('904010000' ,'cn' ,'行驶记录簿' ,'行驶记录簿' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('904020000' ,'cn' ,'行驶记录情况' ,'行驶记录情况' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('1001010000' ,'cn' ,'我的支出决议情况' ,'我的支出决议情况' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('1001020000' ,'cn' ,'我的卡使用情况' ,'我的卡使用情况' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('1001030000' ,'cn' ,'我的发票情况(ERPiU)' ,'我的发票情况(ERPiU)' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('1001040000' ,'cn' ,'我的发票情况(ERPiU)' ,'我的发票情况(ERPiU)' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('1003020000' ,'cn' ,'我的预算完成情况(iCUBE)' ,'我的预算完成情况(iCUBE)' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('1003030000' ,'cn' ,'我的预算完成情况(iCUBE)' ,'我的预算完成情况(iCUBE)' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('2006020007' ,'cn' ,'收件申请内容' ,'收件申请内容' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('2007020021' ,'cn' ,'加班情况(管理者)' ,'加班情况(管理者)' ,null ,null,null,null);
insert ignore into t_co_menu_multi values ('2007020050' ,'cn' ,'已决(结束)' ,'已决(结束)' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('401020000' ,'cn' ,'项目业务管理' ,'项目业务管理' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('607003000' ,'cn' ,'设置文件自动移交' ,'设置文件自动移交' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('607004000' ,'cn' ,'设置自动移交选项' ,'设置自动移交选项' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('705040000' ,'cn' ,'之前文件箱(所有)' ,'之前文件箱(所有)' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('707000000' ,'cn' ,'审批设置管理' ,'审批设置管理' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('707010000' ,'cn' ,'各职员待批管理' ,'各职员待批管理' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('803000000' ,'cn' ,'接收/移交记录物簿' ,'接收/移交记录物簿' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('803010000' ,'cn' ,'移交' ,'移交' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('803010100' ,'cn' ,'申请移交' ,'申请移交' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('803010300' ,'cn' ,'移交情况' ,'移交情况' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('803020000' ,'cn' ,'接收' ,'接收' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('803020100' ,'cn' ,'等待科接收' ,'等待科接收' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('803020200' ,'cn' ,'我的接收箱' ,'我的接收箱' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('803020300' ,'cn' ,'进行科接收' ,'进行科接收' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('803020400' ,'cn' ,'科接收结束箱' ,'科接收结束箱' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('804000000' ,'cn' ,'记录物接收/移交' ,'记录物接收/移交' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('804010000' ,'cn' ,'移交' ,'移交' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('804010100' ,'cn' ,'申请记录物移交' ,'申请记录物移交' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('804010200' ,'cn' ,'等待记录物移交' ,'等待记录物移交' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('804010300' ,'cn' ,'记录物移交情况' ,'记录物移交情况' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('804020000' ,'cn' ,'接收' ,'接收' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('805030000' ,'cn' ,'申请/决议书情况' ,'申请/决议书情况' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('806010000' ,'cn' ,'设置审批选项' ,'设置审批选项' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('808000000' ,'cn' ,'管理审批群组' ,'管理审批群组' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('808020000' ,'cn' ,'设置审批群组' ,'设置审批群组' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('810104000' ,'cn' ,'ICUBE联动文件情况' ,'ICUBE联动文件情况' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('810105000' ,'cn' ,'发票情况(iCUBE)' ,'发票情况(iCUBE)' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('810106000' ,'cn' ,'发票情况(ERPiU)' ,'发票情况(ERPiU)' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('810211000' ,'cn' ,'设置名称' ,'设置名称' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('810212000' ,'cn' ,'设置按键' ,'设置按键' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('810213000' ,'cn' ,'设置采购电子发票权限' ,'设置采购电子发票权限' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('810214000' ,'cn' ,'设置各样式标准摘要&凭证类型' ,'设置各样式标准摘要&凭证类型' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('810215000' ,'cn' ,'设置结算' ,'设置结算' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('810502000' ,'cn' ,'预算情况(iCUBE)' ,'预算情况(iCUBE)' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('810503000' ,'cn' ,'预算情况(ERPiU)' ,'预算情况(ERPiU)' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('905050000' ,'cn' ,'项目编号管理' ,'项目编号管理' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('910400000' ,'cn' ,'业务用轿车管理' ,'业务用轿车管理' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('910400100' ,'cn' ,'行驶记录情况' ,'行驶记录情况' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('911030200' ,'cn' ,'短信统计' ,'短信统计' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('1106010000' ,'cn' ,'设置审批选项' ,'设置审批选项' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('1108000000' ,'cn' ,'管理审批群组' ,'管理审批群组' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('1108020000' ,'cn' ,'设置审批群组' ,'设置审批群组' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('1401020000' ,'cn' ,'项目业务管理' ,'项目业务管理' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('1607003000' ,'cn' ,'设置文件自动移交' ,'设置文件自动移交' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('1607004000' ,'cn' ,'设置自动移交选项' ,'设置自动移交选项' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('1705040000' ,'cn' ,'之前文件箱(所有)' ,'之前文件箱(所有)' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('1707000000' ,'cn' ,'审批设置管理' ,'审批设置管理' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('1707010000' ,'cn' ,'各职员待批管理' ,'各职员待批管理' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('1909001000' ,'cn' ,'二次认证设置' ,'二次认证设置' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('2104040010' ,'cn' ,'出勤内容管理' ,'出勤内容管理' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('2104040011' ,'cn' ,'修改出勤申请情况' ,'修改出勤申请情况' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('2104040016' ,'cn' ,'联动ERP出勤' ,'联动ERP出勤' ,null ,null,null,null);
insert ignore into t_co_menu_adm_multi values ('2104040017' ,'cn' ,'传送各期间出勤' ,'传送各期间出勤' ,null ,null,null,null);


ALTER TABLE `t_co_calendar`
	ADD COLUMN IF NOT EXISTS `holiday_name_en` VARCHAR(200) NULL DEFAULT NULL AFTER `modify_date`,
	ADD COLUMN IF NOT EXISTS `holiday_name_jp` VARCHAR(200) NULL DEFAULT NULL AFTER `holiday_name_en`,
	ADD COLUMN IF NOT EXISTS `holiday_name_cn` VARCHAR(200) NULL DEFAULT NULL AFTER `holiday_name_jp`;


INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) 
VALUES ('EA113', 'COM510', 'en', 'Notification of defined substitute approvers', 'Notification of defined substitute approvers', 'Y', NULL, NULL, NULL, NULL);


INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) 
VALUES ('EA113', 'COM510', 'jp', '代決者設定のお知らせ', '代決者設定のお知らせ', 'Y', NULL, NULL, NULL, NULL);


INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) 
VALUES ('EA113', 'COM510', 'cn', '待批者设置提醒', '待批者设置提醒', 'Y', NULL, NULL, NULL, NULL);


INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) 
VALUES ('EA114', 'COM510', 'en', 'Operator notification', 'Operator notification', 'Y', NULL, NULL, NULL, NULL);


INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) 
VALUES ('EA114', 'COM510', 'jp', '施行者知らせ', '施行者知らせ', 'Y', NULL, NULL, NULL, NULL);

INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) 
VALUES ('EA114', 'COM510', 'cn', '施行者知らせ', '施行者知らせ', 'Y', NULL, NULL, NULL, NULL);




INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) 
VALUES ('AMTA001', 'COM510', 'en', 'General conversation room @ Mention', 'General conversation room @ Mention', 'Y', NULL, NULL, NULL, NULL);


INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) 
VALUES ('AMTA001', 'COM510', 'jp', '一般チャットルーム@メンション', '一般チャットルーム@メンション', 'Y', NULL, NULL, NULL, NULL);



INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) 
VALUES ('AMTA001', 'COM510', 'cn', '一般聊天室 @指定', '一般聊天室 @指定', 'Y', NULL, NULL, NULL, NULL);



INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) 
VALUES ('AMTA101', 'COM510', 'en', 'Project conversation room @Mention', 'Project conversation room @Mention', 'Y', NULL, NULL, NULL, NULL);


INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) 
VALUES ('AMTA101', 'COM510', 'jp', 'プロジェクトのチャットルーム@メンション', 'プロジェクトのチャットルーム@メンション', 'Y', NULL, NULL, NULL, NULL);

INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) 
VALUES ('AMTA101', 'COM510', 'cn', '项目聊天室 @指定', '项目聊天室 @指定', 'Y', NULL, NULL, NULL, NULL);


INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) 
VALUES ('', 'cm3000', 'en', 'Type A', '', 'Y', 'SYSTEM', NULL, 'SYSTEM', NULL);

INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) 
VALUES ('', 'cm3000', 'jp', 'Aタイプ', '', 'Y', 'SYSTEM', NULL, 'SYSTEM', NULL);

INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) 
VALUES ('', 'cm3000', 'cn', 'A类型', '', 'Y', 'SYSTEM', NULL, 'SYSTEM', NULL);


INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) 
VALUES ('cloud', 'cm3000', 'en', 'Type B', '', 'Y', 'SYSTEM', NULL, 'SYSTEM', NULL);

INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) 
VALUES ('cloud', 'cm3000', 'jp', 'Bタイプ', '', 'Y', 'SYSTEM', NULL, 'SYSTEM', NULL);

INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) 
VALUES ('cloud', 'cm3000', 'cn', 'B类型', '', 'Y', 'SYSTEM', NULL, 'SYSTEM', NULL);



UPDATE t_co_portlet SET portlet_nm_en = 'My Info', portlet_nm_cn = '我的信息', portlet_nm_jp = '私の情報' WHERE portlet_nm = '내정보';
UPDATE t_co_portlet SET portlet_nm_en = 'Poll', portlet_nm_cn = '调查', portlet_nm_jp = '調査' WHERE portlet_nm = '설문조사';
UPDATE t_co_portlet SET portlet_nm_en = 'note', portlet_nm_cn = '笔记', portlet_nm_jp = 'ノート' WHERE portlet_nm = '노트';
UPDATE t_co_portlet SET portlet_nm_en = '[Large] Banner', portlet_nm_cn = '[大]横幅', portlet_nm_jp = '[大]バナー' WHERE portlet_nm = '[대] 배너';
UPDATE t_co_portlet SET portlet_nm_en = '[Small] Banner', portlet_nm_cn = '[小]横幅', portlet_nm_jp = '[小]バナー' WHERE portlet_nm = '[소] 배너';
UPDATE t_co_portlet SET portlet_nm_en = '[Middle] Banner', portlet_nm_cn = '[中]横幅', portlet_nm_jp = '[中]バナー' WHERE portlet_nm = '[중] 배너';
UPDATE t_co_portlet SET portlet_nm_en = 'Business management', portlet_nm_cn = '企业管理', portlet_nm_jp = '業務管理' WHERE portlet_nm = '업무관리';
UPDATE t_co_portlet SET portlet_nm_en = '[Middle] I-Frame', portlet_nm_cn = '[中] I-Frame', portlet_nm_jp = '[中] I-Frame' WHERE portlet_nm = '[중] I-Frame';
UPDATE t_co_portlet SET portlet_nm_en = '[Small] I-Frame', portlet_nm_cn = '[小] I-Frame', portlet_nm_jp = '[小] I-Frame' WHERE portlet_nm = '[소] I-Frame';
UPDATE t_co_portlet SET portlet_nm_en = 'Quick Links', portlet_nm_cn = '快速链接', portlet_nm_jp = 'クイックリンク' WHERE portlet_nm = '퀵링크';
UPDATE t_co_portlet SET portlet_nm_en = '[Large] I-Frame', portlet_nm_cn = '[Large] I-Frame', portlet_nm_jp = '[Large] I-Frame' WHERE portlet_nm = '[대] I-Frame';
UPDATE t_co_portlet SET portlet_nm_en = 'weather', portlet_nm_cn = '天气', portlet_nm_jp = '天気' WHERE portlet_nm = '날씨';
UPDATE t_co_portlet SET portlet_nm_en = 'Footer', portlet_nm_cn = 'Footer', portlet_nm_jp = 'Footer' WHERE portlet_nm = 'Footer';
UPDATE t_co_portlet SET portlet_nm_en = '[Small]Year-end settlement', portlet_nm_cn = '[小]年终结算', portlet_nm_jp = '[小]年末調整' WHERE portlet_nm = '[소] 연말정산';
UPDATE t_co_portlet SET portlet_nm_en = '[Middle]Year-end settlement', portlet_nm_cn = '[中]年终结算', portlet_nm_jp = '[中]年末調整' WHERE portlet_nm = '[중] 연말정산';


  소스시퀀스 7398   */

/*
ALTER TABLE t_co_group ADD COLUMN IF NOT EXISTS wehago_software_key varchar(100) DEFAULT NULL COMMENT '위하고소프트웨어키';
ALTER TABLE t_co_comp ADD COLUMN IF NOT EXISTS wehago_sync_yn varchar(1) DEFAULT NULL COMMENT '위하고조직도연동 여부';
ALTER TABLE t_co_emp ADD COLUMN IF NOT EXISTS wehago_id varchar(100) DEFAULT NULL COMMENT '위하고연동계정';

update t_co_group set wehago_server = 'https://api.wehago.com', wehago_key = 'kYnzIztVFrzeWqWi', wehago_software_key = '5182f74a-258d-4994-97da-1eee7f2e763a';

insert ignore into t_co_code_detail
(detail_code, code, ischild, order_num, flag_1, flag_2, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('SC005', 'COM510', 'N', 2, 'SCHEDULE', '일정', 'Y', NULL, NULL, NULL, NULL);

insert ignore into t_co_code_detail_multi
(detail_code, code, lang_code, detail_name, note, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('SC005', 'COM510', 'kr', '일정 댓글 등록 알림', '등록된 일정에 댓글 등록시 알림 사용여부', 'Y', NULL, NULL, NULL, NULL);

insert ignore into t_co_code_detail_multi
(detail_code, code, lang_code, detail_name, note, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('SC005', 'COM510', 'en', 'Schedule comment notification', 'Enable notifications when you comment on events', 'Y', NULL, NULL, NULL, NULL);

insert ignore into t_co_code_detail_multi
(detail_code, code, lang_code, detail_name, note, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('SC005', 'COM510', 'jp', '一定コメント登録通知', 'スケジュールにコメント登録時の通知を使用', 'Y', NULL, NULL, NULL, NULL);

insert ignore into t_co_code_detail_multi
(detail_code, code, lang_code, detail_name, note, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('SC005', 'COM510', 'cn', '安排评论通知', '在对事件发表评论时启用通知', 'Y', NULL, NULL, NULL, NULL);

update t_co_group set update_client_use_yn = 'Y';

소스시퀀스 7509       */




/*
ALTER TABLE t_co_group ADD COLUMN IF NOT EXISTS license_key varchar(256) DEFAULT NULL COMMENT '라이센스키';

UPDATE t_Co_dept_multi SET dept_nickname = dept_name WHERE dept_nickname IS NULL;
UPDATE t_Co_biz_multi SET biz_nickname = biz_name WHERE biz_nickname IS NULL;

소스시퀀스 7650       */



/*


CREATE TABLE IF NOT EXISTS `t_wehago_duty_position_sync` (
  `dp_seq` varchar(32) NOT NULL COMMENT '직책직급 시퀀스',
  `comp_seq` varchar(32) DEFAULT NULL COMMENT '직책직급 시퀀스',
  `dp_type` varchar(16) NOT NULL COMMENT 'DUTY : 직책, POSITION : 직급',
  `wehago_key` varchar(32) COLLATE utf8_bin DEFAULT NULL COMMENT '위하고연동키',
  `create_date` datetime DEFAULT NULL COMMENT '등록일',
  PRIMARY KEY (`dp_seq`, `comp_seq`, `dp_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='위하고직급/직책연동키';

ALTER TABLE t_co_comp ADD COLUMN IF NOT EXISTS wehago_position_group varchar(100) DEFAULT NULL COMMENT '위하고직급그룹코드';
ALTER TABLE t_co_comp ADD COLUMN IF NOT EXISTS wehago_duty_group varchar(100) DEFAULT NULL COMMENT '위하고직책그룹코드';

소스시퀀스 7683

*/





/*

update tcmg_optionset set option_nm='업로드 제한/허용 확장자 설정' where option_id in ('app611','cm1711','msg1611');
update tcmg_optionset set option_desc='첨부파일 업로드 시 제한/허용 확장자를 설정할 수 있습니다.
- 미사용 : 업로드를 제한하지 않습니다.
- 전체적용 : 제한 또는 허용 확장자를 설정할 수 있습니다.
- 선택적용 : 모듈별로 제한 또는 허용 확장자를 설정할 수 있습니다.' where option_id in ('app610','cm1710','msg1610');


ALTER TABLE `t_co_addr_batch`
	ADD COLUMN IF NOT EXISTS `regist_num` VARCHAR(32) NULL DEFAULT NULL AFTER `order_num`,
	ADD COLUMN IF NOT EXISTS `check_group_tp` VARCHAR(32) NULL DEFAULT NULL AFTER `regist_num`,
	ADD COLUMN IF NOT EXISTS `batch_group_tp` VARCHAR(32) NULL DEFAULT NULL AFTER `check_group_tp`;



ALTER TABLE `t_co_addr_batch`
	CHANGE COLUMN `addr_div_nm` `addr_div_nm` VARCHAR(500) NULL DEFAULT NULL AFTER `seq`,
	CHANGE COLUMN `addr_group_nm` `addr_group_nm` VARCHAR(500) NULL DEFAULT NULL AFTER `addr_div_nm`,
	CHANGE COLUMN `create_nm` `create_nm` VARCHAR(500) NULL DEFAULT NULL AFTER `addr_group_nm`,
	CHANGE COLUMN `emp_nm` `emp_nm` VARCHAR(500) NULL DEFAULT NULL AFTER `create_nm`,
	CHANGE COLUMN `emp_email` `emp_email` VARCHAR(500) NULL DEFAULT NULL AFTER `emp_nm`,
	CHANGE COLUMN `emp_hp` `emp_hp` VARCHAR(500) NULL DEFAULT NULL AFTER `emp_email`,
	CHANGE COLUMN `emp_tel` `emp_tel` VARCHAR(500) NULL DEFAULT NULL AFTER `emp_hp`,
	CHANGE COLUMN `emp_fax` `emp_fax` VARCHAR(500) NULL DEFAULT NULL AFTER `emp_tel`,
	CHANGE COLUMN `emp_addr` `emp_addr` VARCHAR(500) NULL DEFAULT NULL AFTER `emp_fax`,
	CHANGE COLUMN `comp_nm` `comp_nm` VARCHAR(500) NULL DEFAULT NULL AFTER `emp_addr`,
	CHANGE COLUMN `comp_tel` `comp_tel` VARCHAR(500) NULL DEFAULT NULL AFTER `comp_nm`,
	CHANGE COLUMN `comp_fax` `comp_fax` VARCHAR(500) NULL DEFAULT NULL AFTER `comp_tel`,
	CHANGE COLUMN `comp_addr` `comp_addr` VARCHAR(500) NULL DEFAULT NULL AFTER `comp_fax`,
	CHANGE COLUMN `etc` `etc` VARCHAR(500) NULL DEFAULT NULL AFTER `comp_addr`,
	CHANGE COLUMN `note` `note` VARCHAR(500) NULL DEFAULT NULL AFTER `etc`;


ALTER TABLE `t_tmpg_addr`
	CHANGE COLUMN `emp_nm` `emp_nm` VARCHAR(500) NULL DEFAULT NULL COMMENT '이름' AFTER `addr_div`,
	CHANGE COLUMN `emp_email` `emp_email` VARCHAR(500) NULL DEFAULT '' COMMENT '이메일' AFTER `emp_nm`,
	CHANGE COLUMN `emp_hp` `emp_hp` VARCHAR(500) NULL DEFAULT '' COMMENT '휴대전화' AFTER `emp_email`,
	CHANGE COLUMN `emp_tel` `emp_tel` VARCHAR(500) NULL DEFAULT '' COMMENT '일반전화' AFTER `emp_hp`,
	CHANGE COLUMN `emp_fax` `emp_fax` VARCHAR(500) NULL DEFAULT '' COMMENT '일반팩스' AFTER `emp_tel`,
	CHANGE COLUMN `emp_zip_cd` `emp_zip_cd` VARCHAR(500) NULL DEFAULT '' COMMENT '우편번호' AFTER `emp_fax`,
	CHANGE COLUMN `emp_zip_addr` `emp_zip_addr` VARCHAR(500) NULL DEFAULT '' COMMENT '주소' AFTER `emp_zip_cd`,
	CHANGE COLUMN `comp_nm` `comp_nm` VARCHAR(500) NULL DEFAULT '' COMMENT '회사명' AFTER `addr_comp_seq`,
	CHANGE COLUMN `comp_num` `comp_num` VARCHAR(500) NULL DEFAULT '' COMMENT '사업자번호' AFTER `comp_nm`,
	CHANGE COLUMN `comp_tel` `comp_tel` VARCHAR(500) NULL DEFAULT '' COMMENT '대표전화' AFTER `comp_num`,
	CHANGE COLUMN `comp_fax` `comp_fax` VARCHAR(500) NULL DEFAULT '' COMMENT '대표팩스' AFTER `comp_tel`,
	CHANGE COLUMN `comp_zip_cd` `comp_zip_cd` VARCHAR(500) NULL DEFAULT '' COMMENT '회사 우편번호' AFTER `comp_fax`,
	CHANGE COLUMN `comp_zip_addr` `comp_zip_addr` VARCHAR(500) NULL DEFAULT '' COMMENT '회사 주소' AFTER `comp_zip_cd`,
	CHANGE COLUMN `etc` `etc` VARCHAR(500) NULL DEFAULT '' COMMENT '추가정보' AFTER `comp_zip_addr`,
	CHANGE COLUMN `note` `note` VARCHAR(500) NULL DEFAULT '' COMMENT '비고' AFTER `etc`;




UPDATE t_co_atch_file_detail SET stre_file_name = 'BizBoxAlpha_주소록 엑셀업로드 양식', orignl_file_name = 'BizBoxAlpha_주소록 엑셀업로드 양식' WHERE file_id = 'gwFormFile' AND file_sn = '0';

소스시퀀스    7725
*/


/*
ALTER TABLE `t_tmp_emp`	ADD COLUMN IF NOT EXISTS `cd_duty_type` VARCHAR(200) NULL DEFAULT NULL COMMENT '직군직종코드' AFTER `row_num`;
UPDATE t_Co_menu_adm_multi SET menu_nm = '일정 연동 설정' WHERE menu_no IN('301070000','1301070000') AND lang_Code = 'kr';

소스시퀀스     7743
*/

/*
 * 수정사항
 * [공통] 첨부파일 업/다운로더 타입/확장자 설정옵션 추가
*/

/*
update tcmg_optionset set use_yn = 'Y' where option_id = 'cm1710' or p_option_id = 'cm1710';
update tcmg_optionset set use_yn = 'Y' where option_id = 'cm1720' or p_option_id = 'cm1720';
update tcmg_optionset set use_yn = 'Y' where option_id = 'msg1610' or p_option_id = 'msg1610';
update tcmg_optionset set use_yn = 'Y' where option_id = 'app610' or p_option_id = 'app610';

ALTER TABLE t_co_emp_login_history CHANGE COLUMN IF EXISTS login_date login_date datetime(3);

insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('cm1750_report', '1', 'cm', 'single', '업무보고 타입설정', 'cm1750', NULL, '2', '업무보고 메뉴의 댓글을 기본형, 기본형(프로필), 대화형 타입으로 설정할 수 있습니다.', 'type1', 'option0150', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, 0);

insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('cm1751_report', '1', 'cm', 'single', '이미지 미리보기 사용여부', 'cm1750_report', NULL, '3', '댓글의 이미지 파일 첨부 시, 미리보기 사용여부를 설정할 수 있습니다.', 'N', 'COM521', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, 0);

insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('cm1750_project', '1', 'cm', 'single', '업무관리 타입설정', 'cm1750', NULL, '2', '업무관리 메뉴의 댓글을 기본형, 기본형(프로필), 대화형 타입으로 설정할 수 있습니다.', 'type1', 'option0150', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, 0);

insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('cm1751_project', '1', 'cm', 'single', '이미지 미리보기 사용여부', 'cm1750_project', NULL, '3', '댓글의 이미지 파일 첨부 시, 미리보기 사용여부를 설정할 수 있습니다.', 'N', 'COM521', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, 0);

insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('cm1750_schedule', '1', 'cm', 'single', '일정 타입설정', 'cm1750', NULL, '2', '일정 메뉴의 댓글을 기본형, 기본형(프로필), 대화형 타입으로 설정할 수 있습니다.', 'type1', 'option0150', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, 0);

insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('cm1751_schedule', '1', 'cm', 'single', '이미지 미리보기 사용여부', 'cm1750_schedule', NULL, '3', '댓글의 이미지 파일 첨부 시, 미리보기 사용여부를 설정할 수 있습니다.', 'N', 'COM521', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, 0);

소스시퀀스     7812
*/

/*
update t_co_emp set passwd_status_code = 'I' where login_id = 'admin' and ifnull(spring_secu,'') = '';

delete from tcmg_optionvalue where option_id in ('cm200','cm201','cm202','cm203')
and (select count(*) from t_co_emp where login_id != 'admin' or ifnull(spring_secu,'') != '') = 0;

update tcmg_optionset set option_d_value = '1' where option_id='cm200'
and (select count(*) from t_co_emp where login_id != 'admin' or ifnull(spring_secu,'') != '') = 0;

update tcmg_optionset set option_d_value = '0|90' where option_id='cm201'
and (select count(*) from t_co_emp where login_id != 'admin' or ifnull(spring_secu,'') != '') = 0;

update tcmg_optionset set option_d_value = '8|16' where option_id='cm202'
and (select count(*) from t_co_emp where login_id != 'admin' or ifnull(spring_secu,'') != '') = 0;

update tcmg_optionset set option_d_value = '3|2|1|' where option_id='cm203'
and (select count(*) from t_co_emp where login_id != 'admin' or ifnull(spring_secu,'') != '') = 0;

update t_co_group set master_passwd = 'b8cZXVpAxHxlYSbvn1n2IPOOLVescODR/dVSqxZKLAo=' where master_passwd = 'pk2mmIOpycza94KY1MLBX8YabvLGqoIAS6Wa0H+X3mQ=';

update tcmg_optionset set option_d_value='Detail' where option_id='cm1722';

소스시퀀스     7854
*/


/*

INSERT IGNORE INTO `t_co_alert_menu` (`event_sub_type`, `lnb_menu_no`, `event_type`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('SC005', '301080000', 'SCHEDULE', NULL, NULL, NULL, NULL);

delete from t_co_group_path where path_seq = '2';
insert into t_co_group_path(group_seq, path_seq, path_name, os_type, absol_path, avail_capac, total_capac, module_capac, limit_file_count, create_seq, create_date, modify_seq, modify_date, drm_use_yn, drm_upload, drm_download, drm_file_extsn)
select group_seq, '2', '공통댓글 기본경로', os_type, concat(absol_path,'/comment'), avail_capac, total_capac, module_capac, limit_file_count, create_seq, create_date, modify_seq, modify_date, drm_use_yn, drm_upload, drm_download, drm_file_extsn from t_co_group_path where path_seq = '0';

update tcmg_optionset set use_yn='Y' where option_id in ('cm1750_report','cm1751_report');

소스시퀀스    7902
*/

/*

UPDATE t_co_Code_detail_multi SET detail_name = '朝文' WHERE CODE = 'LNG000' AND detail_code = 'kr' AND lang_code = 'cn';


소스시퀀스    7974

*/



/*

DELIMITER $$

DROP FUNCTION IF EXISTS `get_menu_depth`$$

CREATE FUNCTION `get_menu_depth`(
	`_menu_no` INT(20)

,
	`_menu_gubun` VARCHAR(50)
) RETURNS INT(11)
BEGIN
    DECLARE _path INT;
    DECLARE _id VARCHAR(32);
    DECLARE _start_with VARCHAR(32);
    DECLARE EXIT HANDLER FOR NOT FOUND RETURN _path;
    
    SET _start_with = '0';
    SET _id = COALESCE(_menu_no, _start_with);
    SET _path = 1;
    LOOP
        SELECT  upper_menu_no
        INTO    _id
        FROM    t_co_menu
        WHERE   menu_no = _id
        AND COALESCE(upper_menu_no <> _start_with, TRUE)
        AND upper_menu_no IS NOT NULL;
        SET _path = _path+1;
    END LOOP;
END$$

DELIMITER ;



DELIMITER $$

DROP FUNCTION IF EXISTS `get_menu_adm_depth`$$

CREATE FUNCTION `get_menu_adm_depth`(
	`_menu_no` INT(20)

,
	`_menu_gubun` VARCHAR(50)
) RETURNS INT(11)
BEGIN
    DECLARE _path INT;
    DECLARE _id VARCHAR(32);
    DECLARE _start_with VARCHAR(32);
    DECLARE EXIT HANDLER FOR NOT FOUND RETURN _path;
    
    SET _start_with = '0';
    SET _id = COALESCE(_menu_no, _start_with);
    SET _path = 1;
    LOOP
        SELECT  upper_menu_no
        INTO    _id
        FROM    t_co_menu_adm
        WHERE   menu_no = _id
        AND COALESCE(upper_menu_no <> _start_with, TRUE)
        AND upper_menu_no IS NOT NULL;
        SET _path = _path+1;
    END LOOP;
END$$

DELIMITER ;


UPDATE t_co_menu SET menu_depth = '1' WHERE upper_menu_no = '0';
UPDATE t_co_menu_adm SET menu_depth = '1' WHERE upper_menu_no = '0';
UPDATE t_co_menu SET menu_depth = get_menu_depth(menu_no,'') WHERE menu_no != '0';
UPDATE t_co_menu_adm SET menu_depth = get_menu_adm_depth(menu_no,'') WHERE menu_no != '0';

-- 보안등급관리 추가
-- 마스터 메뉴
INSERT IGNORE INTO `t_co_menu_adm` (`menu_no`, `menu_gubun`, `upper_menu_no`, `menu_ordr`, `use_yn`, `url_gubun`, `url_path`, `sso_use_yn`, `menu_depth`, `menu_img_class`, `create_seq`, `create_date`, `modify_seq`, `modify_date`, `menu_adm_gubun`, `menu_auth_type`, `public_yn`, `delete_yn`) VALUES (1930100000, 'MENU009', 1900000000, 1930100000, 'Y', 'gw', '', 'N', 2, NULL, NULL, NULL, NULL, NULL, NULL, 'MASTER', 'Y', NULL);
INSERT IGNORE INTO `t_co_menu_adm` (`menu_no`, `menu_gubun`, `upper_menu_no`, `menu_ordr`, `use_yn`, `url_gubun`, `url_path`, `sso_use_yn`, `menu_depth`, `menu_img_class`, `create_seq`, `create_date`, `modify_seq`, `modify_date`, `menu_adm_gubun`, `menu_auth_type`, `public_yn`, `delete_yn`) VALUES (1930101000, 'MENU009', 1930100000, 1930101000, 'Y', 'gw', '/cmm/systemx/secGrade/secGradeManageView.do', 'N', 3, NULL, NULL, NULL, NULL, NULL, NULL, 'MASTER', 'Y', NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1930100000, 'cn', '보안등급', NULL, 'SYSTEM', '2017-06-28 14:30:56', 'SYSTEM', '2017-06-28 14:30:56');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1930100000, 'en', '보안등급', NULL, 'SYSTEM', '2016-12-27 11:57:45', NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1930100000, 'jp', '보안등급', NULL, 'SYSTEM', '2017-06-28 14:30:36', 'SYSTEM', '2017-06-28 14:30:36');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1930100000, 'kr', '보안등급', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1930101000, 'cn', '보안등급 관리', NULL, 'SYSTEM', '2017-06-28 14:30:57', 'SYSTEM', '2017-06-28 14:30:57');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1930101000, 'en', '보안등급 관리', NULL, 'SYSTEM', '2016-12-30 14:45:10', 'SYSTEM', '2017-01-26 09:45:52');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1930101000, 'jp', '보안등급 관리', NULL, 'SYSTEM', '2017-06-28 14:30:36', 'SYSTEM', '2017-06-28 14:30:36');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (1930101000, 'kr', '보안등급 관리', NULL, NULL, NULL, NULL, NULL);

-- 관리자 메뉴
INSERT IGNORE INTO `t_co_menu_adm` (`menu_no`, `menu_gubun`, `upper_menu_no`, `menu_ordr`, `use_yn`, `url_gubun`, `url_path`, `sso_use_yn`, `menu_depth`, `menu_img_class`, `create_seq`, `create_date`, `modify_seq`, `modify_date`, `menu_adm_gubun`, `menu_auth_type`, `public_yn`, `delete_yn`) VALUES (930100000, 'MENU009', 900000000, 930100000, 'Y', 'gw', '', 'N', 2, NULL, NULL, NULL, NULL, NULL, 'MENU009', 'ADMIN', 'Y', NULL);
INSERT IGNORE INTO `t_co_menu_adm` (`menu_no`, `menu_gubun`, `upper_menu_no`, `menu_ordr`, `use_yn`, `url_gubun`, `url_path`, `sso_use_yn`, `menu_depth`, `menu_img_class`, `create_seq`, `create_date`, `modify_seq`, `modify_date`, `menu_adm_gubun`, `menu_auth_type`, `public_yn`, `delete_yn`) VALUES (930101000, 'MENU009', 930100000, 930101000, 'Y', 'gw', '/cmm/systemx/secGrade/secGradeManageView.do', 'N', 3, NULL, NULL, NULL, NULL, NULL, 'MENU009', 'ADMIN', 'Y', NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (930100000, 'cn', '보안등급', NULL, 'SYSTEM', '2017-06-28 14:30:56', 'SYSTEM', '2017-06-28 14:30:56');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (930100000, 'en', '보안등급', NULL, 'SYSTEM', '2016-12-27 11:57:45', NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (930100000, 'jp', '보안등급', NULL, 'SYSTEM', '2017-06-28 14:30:36', 'SYSTEM', '2017-06-28 14:30:36');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (930100000, 'kr', '보안등급', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (930101000, 'cn', '보안등급 관리', NULL, 'SYSTEM', '2017-06-28 14:30:57', 'SYSTEM', '2017-06-28 14:30:57');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (930101000, 'en', '보안등급 관리', NULL, 'SYSTEM', '2016-12-30 14:45:10', 'SYSTEM', '2017-01-26 09:45:52');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (930101000, 'jp', '보안등급 관리', NULL, 'SYSTEM', '2017-06-28 14:30:36', 'SYSTEM', '2017-06-28 14:30:36');
INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES (930101000, 'kr', '보안등급 관리', NULL, NULL, NULL, NULL, NULL);

-- 공통코드 (사용모듈)
INSERT IGNORE INTO `t_co_code` (`code`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('COM550', 'Y', '1', '2016-12-26 14:18:20', '1', '2016-12-26 14:18:20');
INSERT IGNORE INTO `t_co_code_detail` (`detail_code`, `code`, `ischild`, `order_num`, `flag_1`, `flag_2`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('eap', 'COM550', 'N', 0, NULL, NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('eap', 'COM550', 'kr', '전자결재', '보안등급관리 사용모듈(전자결재 영리)', 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('eap', 'COM550', 'cn', '전자결재', '보안등급관리 사용모듈(전자결재 영리)', 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('eap', 'COM550', 'en', '전자결재', '보안등급관리 사용모듈(전자결재 영리)', 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('eap', 'COM550', 'jp', '전자결재', '보안등급관리 사용모듈(전자결재 영리)', 'Y', NULL, NULL, NULL, NULL);

-- 보안등급관리 (t_co_sec_grade)
CREATE TABLE IF NOT EXISTS `t_co_sec_grade` (
	`sec_id` VARCHAR(32) NOT NULL COMMENT '보안등급코드',
	`upper_sec_id` VARCHAR(32) NULL DEFAULT NULL COMMENT '상위보안등급코드',
	`sec_name_kr` VARCHAR(128) NOT NULL DEFAULT '' COMMENT '보안등급명(kr)',
	`sec_name_en` VARCHAR(128) NOT NULL DEFAULT '' COMMENT '보안등급명(en)',
	`sec_name_jp` VARCHAR(128) NOT NULL DEFAULT '' COMMENT '보안등급명(jp)',
	`sec_name_cn` VARCHAR(128) NOT NULL DEFAULT '' COMMENT '보안등급명(cn)',
	`sec_depth` INT(2) NOT NULL COMMENT '보안등급 depth',
	`comp_seq` VARCHAR(32) NOT NULL COMMENT '회사시퀀스_0이면 그룹전용',
	`module` VARCHAR(32) NOT NULL COMMENT '사용모듈',
	`sec_order` DECIMAL(65,0) NOT NULL DEFAULT '0' COMMENT '순서',
	`etc` VARCHAR(500) NULL DEFAULT NULL COMMENT '비고',
	`icon_yn` CHAR(1) NOT NULL DEFAULT 'N' COMMENT '아이콘 표시여부',
	`use_yn` CHAR(1) NOT NULL DEFAULT 'Y' COMMENT '사용여부',
	`create_seq` VARCHAR(32) NULL DEFAULT NULL COMMENT '등록자시퀀스',
	`create_date` DATETIME NULL DEFAULT NULL COMMENT '등록일',
	`modify_seq` VARCHAR(32) NULL DEFAULT NULL COMMENT '수정자시퀀스',
	`modify_date` DATETIME NULL DEFAULT NULL COMMENT '수정일',
	PRIMARY KEY (`sec_id`),
	INDEX `index_comp_seq` (`comp_seq`),
	INDEX `index_module` (`module`),
	INDEX `index_upper_sec_id` (`upper_sec_id`)
)
COMMENT='보안등급관리'
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;


INSERT IGNORE INTO t_co_sec_grade (`sec_id`,`upper_sec_id`,`sec_name_kr`,`sec_name_en`,`sec_name_jp`,`sec_name_cn`,`sec_depth`,`comp_seq`,`module`,`sec_order`) VALUES ('000','#','그룹','Group','Group','Group',0,'0','eap',-999);
INSERT IGNORE INTO t_co_sec_grade (`sec_id`,`upper_sec_id`,`sec_name_kr`,`sec_name_en`,`sec_name_jp`,`sec_name_cn`,`sec_depth`,`comp_seq`,`module`,`sec_order`,`icon_yn`) VALUES ('001','000','1등급','1Grade','1Grade','1Grade',1,'0','eap',1,'Y');
INSERT IGNORE INTO t_co_sec_grade (`sec_id`,`upper_sec_id`,`sec_name_kr`,`sec_name_en`,`sec_name_jp`,`sec_name_cn`,`sec_depth`,`comp_seq`,`module`,`sec_order`) VALUES ('002','001','2등급','2Grade','2Grade','2Grade',2,'0','eap',1);
INSERT IGNORE INTO t_co_sec_grade (`sec_id`,`upper_sec_id`,`sec_name_kr`,`sec_name_en`,`sec_name_jp`,`sec_name_cn`,`sec_depth`,`comp_seq`,`module`,`sec_order`) VALUES ('003','002','3등급','3Grade','3Grade','3Grade',3,'0','eap',1);

CREATE TABLE IF NOT EXISTS `t_co_sec_grade_user` (
	`sec_id` VARCHAR(32) NOT NULL COMMENT '보안등급코드',
	`dept_seq` VARCHAR(32) NOT NULL COMMENT '부서시퀀스',
	`emp_seq` VARCHAR(32) NOT NULL COMMENT '사용자시퀀스',
	`group_seq` VARCHAR(32) NOT NULL COMMENT '그룹시퀀스',
	`comp_seq` VARCHAR(32) NOT NULL COMMENT '회사시퀀스',
	`biz_seq` VARCHAR(32) NOT NULL COMMENT '사업장시퀀스',
	`create_seq` VARCHAR(32) NULL DEFAULT NULL COMMENT '등록자시퀀스',
	`create_date` DATE NULL DEFAULT NULL COMMENT '등록일',
	`modify_seq` VARCHAR(32) NULL DEFAULT NULL COMMENT '수정자시퀀스',
	`modify_date` DATETIME NULL DEFAULT NULL COMMENT '수정일',
	PRIMARY KEY (`sec_id`, `dept_seq`, `emp_seq`),
	INDEX `index_comp_seq` (`comp_seq`),
	INDEX `t_co_sec_grade_user_fk2` (`dept_seq`),
	INDEX `t_co_sec_grade_user_fk3` (`emp_seq`),
	CONSTRAINT `t_co_sec_grade_user_fk1` FOREIGN KEY (`sec_id`) REFERENCES `t_co_sec_grade` (`sec_id`) ON UPDATE NO ACTION ON DELETE CASCADE
)
COMMENT='보안등급_사용자'
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;

DELIMITER $$
DROP FUNCTION IF EXISTS get_sec_name_info$$
CREATE FUNCTION `get_sec_name_info`(`I_SEC_ID` VARCHAR(32),`I_LANG_CODE` VARCHAR(32)) RETURNS varchar(128) CHARSET utf8
    CONTAINS SQL
BEGIN
    	  DECLARE V_RETURN 			VARCHAR(128);
			DECLARE R_SEC_NAME_KR        	VARCHAR(128);
			DECLARE R_SEC_NAME_EN      		VARCHAR(128);
			DECLARE R_SEC_NAME_JP     		VARCHAR(128);
			DECLARE R_SEC_NAME_CN    		VARCHAR(128);
		   
		   SELECT 
				sec_name_kr,
				sec_name_en,
				sec_name_jp,
				sec_name_cn
				INTO R_SEC_NAME_KR, R_SEC_NAME_EN, R_SEC_NAME_JP, R_SEC_NAME_CN
			FROM T_CO_SEC_GRADE
			WHERE sec_id = I_SEC_ID;
		   
			IF I_LANG_CODE = 'kr' THEN
			    SET V_RETURN = R_SEC_NAME_KR;
			  ELSEIF I_LANG_CODE = 'en' THEN
			    SET V_RETURN = R_SEC_NAME_EN;
			  ELSEIF I_LANG_CODE = 'jp' THEN
			    SET V_RETURN = R_SEC_NAME_JP;
			  ELSEIF I_LANG_CODE = 'cn' THEN
			    SET V_RETURN = R_SEC_NAME_CN;
			 ELSE
			    SET V_RETURN = NULL;
			 END IF;
			RETURN V_RETURN;
END$$
DELIMITER ;

DELIMITER $$
DROP FUNCTION IF EXISTS `get_sec_grade_connect_by_id` $$
CREATE FUNCTION `get_sec_grade_connect_by_id`(value VARCHAR(32)) RETURNS varchar(32) CHARSET utf8
        READS SQL DATA
BEGIN
        DECLARE _id VARCHAR(32);
        DECLARE _parent VARCHAR(32);
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET @id = NULL;
 
        SET _parent = @id;
        SET _id = '';
 
        IF @id IS NULL THEN
                RETURN NULL;
        END IF;
 
        LOOP
                SELECT  MIN(sec_id)
                INTO    @id
                FROM    t_co_sec_grade
                WHERE   upper_sec_id = _parent
                        AND sec_id > _id;
                IF @id IS NOT NULL OR _parent = @start_with THEN
                        SET @level = @level + 1;
                        RETURN @id;
                END IF;
                SET @level := @level - 1;
                SELECT  sec_id, upper_sec_id
                INTO    _id, _parent
                FROM    t_co_sec_grade
                WHERE   sec_id = _parent;
        END LOOP;       
END$$
DELIMITER ;

소스시퀀스 8007
*/

/*
ALTER TABLE t_co_group ADD COLUMN IF NOT EXISTS group_email_name varchar(128) DEFAULT NULL COMMENT '그룹메일 발신자명';
ALTER TABLE t_co_group ADD COLUMN IF NOT EXISTS out_smtp_use_yn varchar(1) DEFAULT 'N' COMMENT 'SMTP서버 사용여부';
ALTER TABLE t_co_group ADD COLUMN IF NOT EXISTS smtp_server  varchar(256) DEFAULT NULL COMMENT 'SMTP서버 도메인';
ALTER TABLE t_co_group ADD COLUMN IF NOT EXISTS smtp_port  varchar(10) DEFAULT NULL COMMENT 'SMTP 포트';
ALTER TABLE t_co_group ADD COLUMN IF NOT EXISTS smtp_id  varchar(256) DEFAULT NULL COMMENT 'SMTP 아이디';
ALTER TABLE t_co_group ADD COLUMN IF NOT EXISTS smtp_pw  varchar(256) DEFAULT NULL COMMENT 'SMTP 패스워드';

insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('cm1750_board', '1', 'cm', 'single', '게시판 타입설정', 'cm1750', NULL, '2', '게시판 메뉴의 댓글을 기본형, 기본형(프로필), 대화형 타입으로 설정할 수 있습니다.', 'type1', 'option0150', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, 0);

insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('cm1751_board', '1', 'cm', 'single', '이미지 미리보기 사용여부', 'cm1750_board', NULL, '3', '댓글의 이미지 파일 첨부 시, 미리보기 사용여부를 설정할 수 있습니다.', 'N', 'COM521', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, 0);

소스시퀀스 8022
*/



/*
*수정사항
[공통] 메신저 링크 다국어 반영
[시스템설정] 사원정보관리 사원정보팝업 리사이즈기능 추가.
[통합검색] 검색어 월별인덱스-> 개별 인덱스 변환
[공통] 대메뉴 기본페이지로 설정한 메뉴가 link_iframe 타입일 경우 메뉴이동 오류 수정
*/

/*
insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('cm210', '1', 'cm', 'multi', '비밀번호 찾기 설정', NULL, NULL, '1', '사용자 비밀번호 찾기를 설정할 수 있습니다.
상세 설정 값 모두 미선택 시, 로그인 화면 내 비밀번호 찾기 버튼을 제공하지 않습니다.

임시 비밀번호 또는 관리자 초기화 후 로그인 시, 사용자는 비밀번호 재설정이 필요합니다.

- 메일인증 : 개인메일 인증번호 발송 > 인증번호 확인 단계를 제공합니다.

※ 개인메일 등록 : 위와 같이 인증절차대로 사용 가능합니다.
※ 개인메일 미등록 : 관리자에게 별도 문의하도록 안내 문구만 제공합니다

- 관리자 요청 : 관리자에게 초기화 요청 알림 발송 > 관리자가 비밀번호 초기화 단계를 제공합니다.', '999', 'option0210', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, NULL);
insert ignore into t_co_code
(code, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('option0210', 'Y', NULL, NULL, NULL, NULL);
insert ignore into t_co_code_multi
(code, lang_code, name, note, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('option0210', 'kr', '비밀번호 찾기 설정', NULL, 'Y', NULL, NULL, NULL, NULL);
insert ignore into t_co_code_detail
(detail_code, code, ischild, order_num, flag_1, flag_2, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('0', 'option0210', 'N', 0, NULL, NULL, 'Y', NULL, NULL, NULL, NULL), 
('1', 'option0210', 'N', 1, NULL, NULL, 'Y', NULL, NULL, NULL, NULL);
insert ignore into t_co_code_detail_multi
(detail_code, code, lang_code, detail_name, note, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('0', 'option0210', 'kr', '메일 인증', NULL, 'Y', NULL, NULL, NULL, NULL), 
('1', 'option0210', 'kr', '관리자 요청', NULL, 'Y', NULL, NULL, NULL, NULL);


UPDATE t_msg_tcmg_link SET link_nm_en = 'In Tray box', link_nm_jp = '未決箱', link_nm_cn ='未决箱' WHERE link_nm_kr = '미결함';
UPDATE t_msg_tcmg_link SET link_nm_en = 'Co-worker service', link_nm_jp = '社員管理', link_nm_cn ='对职员服务' WHERE link_nm_kr = '인사/근태';
UPDATE t_msg_tcmg_link SET link_nm_en = 'Accounting', link_nm_jp = '会計', link_nm_cn ='会计' WHERE link_nm_kr = '회계';
UPDATE t_msg_tcmg_link SET link_nm_en = 'Reference received', link_nm_jp = '受信参考箱', link_nm_cn ='抄送箱' WHERE link_nm_kr = '수신참조함';
UPDATE t_msg_tcmg_link SET link_nm_en = 'Report work', link_nm_jp = '業務報告', link_nm_cn ='业务报告' WHERE link_nm_kr = '업무보고';
UPDATE t_msg_tcmg_link SET link_nm_en = 'E-approval', link_nm_jp = '電子決裁', link_nm_cn ='电子审批' WHERE link_nm_kr = '전자결재';
UPDATE t_msg_tcmg_link SET link_nm_en = 'My page', link_nm_jp = 'マイページ', link_nm_cn ='我的网页' WHERE link_nm_kr = '마이페이지';
UPDATE t_msg_tcmg_link SET link_nm_en = 'Schedule', link_nm_jp = 'スケジュール', link_nm_cn ='日程' WHERE link_nm_kr = '일정';
UPDATE t_msg_tcmg_link SET link_nm_en = 'Task management', link_nm_jp = '業務管理', link_nm_cn ='业务管理' WHERE link_nm_kr = '업무관리';
UPDATE t_msg_tcmg_link SET link_nm_en = 'Board', link_nm_jp = '掲示板', link_nm_cn ='留言板' WHERE link_nm_kr = '게시판';
UPDATE t_msg_tcmg_link SET link_nm_en = 'Document', link_nm_jp = '文書', link_nm_cn ='文件' WHERE link_nm_kr = '문서';


insert ignore into t_co_code
(code, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('option0211', 'Y', NULL, NULL, NULL, NULL);

insert ignore into t_co_code_multi
(code, lang_code, name, note, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('option0211', 'kr', '비밀번호 만료타입', NULL, 'Y', NULL, NULL, NULL, NULL);

insert ignore into t_co_code_detail
(detail_code, code, ischild, order_num, flag_1, flag_2, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('m', 'option0211', 'N', 0, NULL, NULL, 'Y', NULL, NULL, NULL, NULL);

insert ignore into t_co_code_detail_multi
(detail_code, code, lang_code, detail_name, note, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('m', 'option0211', 'kr', '매 월', NULL, 'Y', NULL, NULL, NULL, NULL);

insert ignore into t_co_code_detail
(detail_code, code, ischild, order_num, flag_1, flag_2, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('d', 'option0211', 'N', 1, NULL, NULL, 'Y', NULL, NULL, NULL, NULL);

insert ignore into t_co_code_detail_multi
(detail_code, code, lang_code, detail_name, note, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('d', 'option0211', 'kr', '선택기간', NULL, 'Y', NULL, NULL, NULL, NULL);

insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('cm1750_doc', '1', 'cm', 'single', '문서 타입설정', 'cm1750', NULL, '2', '문서 메뉴의 댓글을 기본형, 기본형(프로필), 대화형 타입으로 설정할 수 있습니다.', 'type1', 'option0150', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, 0);

insert ignore into tcmg_optionset
(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('cm1751_doc', '1', 'cm', 'single', '이미지 미리보기 사용여부', 'cm1750_doc', NULL, '3', '댓글의 이미지 파일 첨부 시, 미리보기 사용여부를 설정할 수 있습니다.', 'N', 'COM521', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, 0);


CREATE TABLE IF NOT EXISTS `t_co_cloud_backup_info` (
  `backup_seq` varchar(64) NOT NULL,
  `group_seq` varchar(32) NOT NULL,
  `backup_from_dt` varchar(8) NOT NULL,
  `backup_to_dt` varchar(8) NOT NULL,
  `backup_path` varchar(256) NOT NULL,
  `ea_backup_type` varchar(1) NOT NULL,
  `ea_proc_state` varchar(1) NOT NULL,
  `ea_count` int(11) DEFAULT NULL,
  `doc_backup_type` varchar(1) NOT NULL,
  `doc_proc_state` varchar(1) NOT NULL,
  `doc_count` int(11) DEFAULT NULL,
  `edoc_backup_type` varchar(1) NOT NULL,
  `edoc_proc_state` varchar(1) NOT NULL,
  `edoc_count` int(11) DEFAULT NULL,
  `board_backup_type` varchar(1) NOT NULL,
  `board_proc_state` varchar(1) NOT NULL,
  `board_count` int(11) DEFAULT NULL,
  `down_zip_path` varchar(256) DEFAULT NULL,
  `down_from_dt` varchar(8) NOT NULL,
  `down_to_dt` varchar(8) NOT NULL,
  `down_popup_yn` varchar(1) NOT NULL,
  `down_btn_yn` varchar(1) NOT NULL,
  `req_date` datetime NOT NULL,
  PRIMARY KEY (`backup_seq`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='백업서비스 요청';

CREATE TABLE IF NOT EXISTS `t_co_cloud_backup_down_his` (
  `down_seq` varchar(64) NOT NULL,
  `backup_seq` varchar(64) NOT NULL,
  `down_tp` varchar(32) NOT NULL,
  `down_date` datetime NOT NULL,
  `result_tp` varchar(1) NOT NULL,
  `emp_seq` varchar(256) DEFAULT NULL,
  `client_ip` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`down_seq`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='백업서비스 다운로드 이력';

update tcmg_optionset set
option_desc = '댓글의 이미지 파일 첨부 시, 미리보기 사용여부를 설정할 수 있습니다.
모바일의 경우, 이미지 파일 미리보기를 제공합니다.'
where option_id like 'cm1751_%';

update tcmg_optionset set
option_desc = '게시판 메뉴의 댓글을 기본형, 기본형(프로필), 대화형 타입으로 설정할 수 있습니다.
모바일의 경우, 대화형 타입만 제공합니다.'
where option_id like 'cm1750_board';

update tcmg_optionset set
option_desc = '문서 메뉴의 댓글을 기본형, 기본형(프로필), 대화형 타입으로 설정할 수 있습니다.
모바일의 경우, 대화형 타입만 제공합니다.'
where option_id like 'cm1750_doc';

update tcmg_optionset set
option_desc = '전자결재 메뉴의 댓글을 기본형, 기본형(프로필), 대화형 타입으로 설정할 수 있습니다.
모바일의 경우, 대화형 타입만 제공합니다.'
where option_id like 'cm1750_ea';

update tcmg_optionset set
option_desc = '업무관리 메뉴의 댓글을 기본형, 기본형(프로필), 대화형 타입으로 설정할 수 있습니다.
모바일의 경우, 대화형 타입만 제공합니다.'
where option_id like 'cm1750_project';

update tcmg_optionset set
option_desc = '업무보고 메뉴의 댓글을 기본형, 기본형(프로필), 대화형 타입으로 설정할 수 있습니다.
모바일의 경우, 대화형 타입만 제공합니다.'
where option_id like 'cm1750_report';

update tcmg_optionset set
option_desc = '일정 메뉴의 댓글을 기본형, 기본형(프로필), 대화형 타입으로 설정할 수 있습니다.
모바일의 경우, 대화형 타입만 제공합니다.'
where option_id like 'cm1750_schedule';

update tcmg_optionset set option_desc = '비밀번호 만료기한을 설정할 수 있습니다.
매 월 지정한 일 또는 선택 기간에 따라 비밀번호를 변경하도록 제공하는 기능입니다.

- 매 월 : 매월 특정일에 변경되도록 설정할 수 있고, 설정한 이후 비밀번호 변경 기능을 제 공합니다. 1일/3일/7일 전 안내가 가능하도록 선택할 수 있습니다.

- 선택 기간 : 일 입력 시, 마지막 비밀번호 변경일로부터 만료기한 체크 후 비밀번호 변경 기능을 제공합니다. 안내일자 입력 시, N일 이후 안내만 제공하며 만료일자 입력 시, N일 이 후 비밀번호 변경하도록 제공합니다. (일단위 입력 / 0: 제한없음)'
where  option_id='cm201';

update tcmg_optionset set option_group = 'single', option_d_value='d▦0|0', option_value_id='option0211' where option_id='cm201';
*/

-- 소스시퀀스 : 8184

/*
수정사항
[시스템설정] 접근가능IP대역 로직 체크 수정
[메뉴] 문서모듈 메뉴트리 많을경우 정렬 되는데 오래걸리는 현상 수정
[통합검색] GW 통합검색 API 에러메세지 강화
[메뉴] 메뉴정보관리-게시판-사내게시판 하위에 생성한 메뉴 기본페이지 설정시 미동작 수정
*/

/*
update t_co_menu set delete_yn = 'Y' where upper_menu_no = 0 and menu_gubun in
(select detail_code from t_co_code_detail where code = 'menu' and use_yn = 'N');

update t_co_menu_adm set delete_yn = 'Y' where upper_menu_no = 0 and menu_gubun in
(select detail_code from t_co_code_detail where code = 'menu' and use_yn = 'N');

DELIMITER $$
DROP FUNCTION IF EXISTS get_auth_group_concat$$
CREATE FUNCTION `get_auth_group_concat`(
	`I_COMP_SEQ` VARCHAR(32),
	`I_DEPT_SEQ` VARCHAR(32),
	`I_EMP_SEQ` VARCHAR(32),
	`I_DEPT_DUTY_CODE` VARCHAR(32),
	`I_DEPT_POSITION_CODE` VARCHAR(32)
) RETURNS varchar(512) CHARSET utf8
    READS SQL DATA
BEGIN

	DECLARE V_RETURN 		VARCHAR(512);
		
	SELECT GROUP_CONCAT(A.author_code SEPARATOR  '#') AS author_code
	INTO V_RETURN
	FROM 
	(
      select
      DISTINCT CAST(a.author_code AS CHAR) AS author_code
      from t_co_authcode a
      join t_co_auth_relate r on a.author_use_yn = 'Y' and a.author_code = r.author_code and a.comp_seq = I_COMP_SEQ and ((a.author_type = '001' and r.emp_seq = I_EMP_SEQ) or a.author_type = '002')
      join t_co_comp c on a.comp_seq = c.comp_seq
      left join t_co_dept d on r.author_type = '002' and d.dept_seq = I_DEPT_SEQ and concat('|',d.path,'|') like concat('%|',r.dept_seq,'|%')
      where (a.author_type = '001' or d.dept_seq is not null) and case when c.ea_type = 'ea' then r.dept_seq = I_DEPT_SEQ else 1=1 end    
	    ) A;	
           
	RETURN V_RETURN;	
END$$

DELIMITER ;


DELETE FROM oneffice_access_info WHERE access_status = '0';

ALTER TABLE `oneffice_access_info`
	ADD INDEX IF NOT EXISTS `idx_oneffice_access_info_2` (`access_status`),
	ADD INDEX IF NOT EXISTS `idx_oneffice_access_info_3` (`access_date`);


ALTER TABLE `oneffice_document_history`
	ADD INDEX IF NOT EXISTS `idx_oneffice_document_history_1` (`doc_no`);
	
update tcmg_optionset set use_yn = 'Y' where option_id in ('cm1750_board','cm1751_board','cm1750_doc','cm1751_doc');
*/

--        소스시퀀스 : 8307


/*
수정사항
[시스템설정] 사원정보관리 미사용 겸직 사용자정보 조회 사용으로 표시되는 오류 수정
[시스템설정] 비밀번호 찾기기능 추가
[공통] 공통댓글 등록 시 멘션만 등록 가능하도록 개선
*/

/*

insert ignore into t_co_code_detail
(detail_code, code, ischild, order_num, flag_1, flag_2, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('GW001', 'COM510', 'N', 0, 'COMMON', '공통/시스템설정', 'Y', NULL, NULL, NULL, NULL);
insert ignore into t_co_code_detail_multi
(detail_code, code, lang_code, detail_name, note, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('GW001', 'COM510', 'kr', '비밀번호 초기화 요청', '비밀번호 초기화 요청 시 관리자에게 알림 발송여부', 'Y', NULL, NULL, NULL, NULL);
insert ignore into t_co_code_detail
(detail_code, code, ischild, order_num, flag_1, flag_2, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('COMMON', 'ALARAM', 'N', 0, NULL, NULL, 'Y', 'SYSTEM', NOW(), 'SYSTEM', NOW());
insert ignore into t_co_code_detail_multi
(detail_code, code, lang_code, detail_name, note, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('COMMON', 'ALARAM', 'kr', '공통/시스템설정', '공통/시스템설정', 'Y', 'SYSTEM', NOW(), 'SYSTEM', NOW());

ALTER TABLE `t_co_emp_dept_history` CHANGE COLUMN IF EXISTS `order_text` `order_text` VARCHAR(255) NULL;


DELIMITER $$
DROP FUNCTION IF EXISTS neos_new.FN_GetMultiName$$
CREATE FUNCTION `FN_GetMultiName`(
	`langCode` VARCHAR(2),
	`orgDiv` VARCHAR(10),
	`seq` VARCHAR(32)

) RETURNS varchar(128) CHARSET utf8
BEGIN
    DECLARE nRetVal VARCHAR(128) DEFAULT '';
    
    IF langCode = '' THEN
       SET langCode = 'kr';
    END IF;
    
    IF orgDiv = 'EMP' THEN
    	SELECT ifnull(multi.emp_name, kr.emp_name) INTO nRetVal
		FROM t_co_emp_multi kr
		left join t_co_emp_multi multi on kr.emp_seq=multi.emp_seq and multi.lang_code=langCode
    	WHERE kr.emp_seq=seq AND kr.lang_code='kr';
    ELSEIF orgDiv = 'DEPT' THEN
      SELECT ifnull(multi.dept_name, kr.dept_name) INTO nRetVal 
		FROM t_co_dept_multi kr
		left join t_co_dept_multi multi on kr.dept_seq=multi.dept_seq and multi.lang_code=langCode
    	WHERE kr.dept_seq=seq AND kr.lang_code='kr';     
    ELSEIF orgDiv = 'COMP' THEN
      SELECT ifnull(multi.comp_name, kr.comp_name) INTO nRetVal 
		FROM t_co_comp_multi kr
		left join t_co_comp_multi multi on kr.comp_seq=multi.comp_seq AND multi.lang_code=langCode
    	WHERE kr.comp_seq=seq AND kr.lang_code='kr';
    ELSEIF orgDiv = 'BIZ' THEN
      SELECT ifnull(multi.biz_name, kr.biz_name) INTO nRetVal 
		FROM t_co_biz_multi kr
      left join t_co_biz_multi multi on kr.biz_seq=multi.biz_seq AND multi.lang_code=langCode
    	WHERE kr.biz_seq=seq AND kr.lang_code='kr';
    ELSEIF orgDiv = 'POSITION' THEN
      SELECT ifnull(multi.dp_name, kr.dp_name) INTO nRetVal 
		FROM t_co_comp_duty_position_multi kr
		left join t_co_comp_duty_position_multi multi on kr.dp_type=multi.dp_type and kr.dp_seq=multi.dp_seq and multi.lang_code=langCode
    	WHERE kr.dp_type = 'POSITION' and kr.dp_seq=seq AND kr.lang_code='kr';
    ELSEIF orgDiv = 'DUTY' THEN
      SELECT ifnull(multi.dp_name, kr.dp_name) INTO nRetVal 
		FROM t_co_comp_duty_position_multi kr
		left join t_co_comp_duty_position_multi multi on kr.dp_type=multi.dp_type and kr.dp_seq=multi.dp_seq and multi.lang_code=langCode
    	WHERE kr.dp_type = 'DUTY' and kr.dp_seq=seq AND kr.lang_code='kr';          
    END IF;
    
    RETURN nRetVal;
    
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS TRG_T_CO_ORGCHART_AD;
DROP TRIGGER IF EXISTS TRG_T_CO_ORGCHART_AI;
DROP TRIGGER IF EXISTS TRG_T_CO_ORGCHART_AU;

update tcmg_optionset set use_yn = 'Y' where option_id = 'cm210';



UPDATE t_Co_Code_Detail SET order_num = '10' WHERE CODE = 'COM517' AND detail_Code = '999';
UPDATE t_Co_Code_Detail SET order_num = '20' WHERE CODE = 'COM517' AND detail_Code = '004';
UPDATE t_Co_Code_Detail SET order_num = '30' WHERE CODE = 'COM517' AND detail_Code = '001';


INSERT IGNORE INTO t_co_code VALUES('option0212','Y',NULL,NULL,NULL,NULL);
INSERT IGNORE INTO t_Co_Code_multi VALUES('option0212','kr','사용자 연동 항목 설정',NULL,'Y',NULL,NULL,NULL,NULL);
INSERT IGNORE INTO t_co_code_detail VALUES('1','option0212','N',10,NULL,NULL,'Y',NULL,NULL,NULL,NULL);
INSERT IGNORE INTO t_co_code_detail VALUES('2','option0212','N',20,NULL,NULL,'Y',NULL,NULL,NULL,NULL);
INSERT IGNORE INTO t_co_code_detail VALUES('3','option0212','N',30,NULL,NULL,'Y',NULL,NULL,NULL,NULL);
INSERT IGNORE INTO t_co_code_detail VALUES('4','option0212','N',40,NULL,NULL,'Y',NULL,NULL,NULL,NULL);
INSERT IGNORE INTO t_co_code_detail VALUES('5','option0212','N',50,NULL,NULL,'Y',NULL,NULL,NULL,NULL);
INSERT IGNORE INTO t_co_code_detail VALUES('6','option0212','N',60,NULL,NULL,'Y',NULL,NULL,NULL,NULL);
INSERT IGNORE INTO t_co_code_detail VALUES('7','option0212','N',70,NULL,NULL,'Y',NULL,NULL,NULL,NULL);
INSERT IGNORE INTO t_co_code_detail_multi VALUES('1','option0212','kr','사진 이미지',NULL,'Y',NULL,NULL,NULL,NULL);
INSERT IGNORE INTO t_co_code_detail_multi VALUES('2','option0212','kr','성별',NULL,'Y',NULL,NULL,NULL,NULL);
INSERT IGNORE INTO t_co_code_detail_multi VALUES('3','option0212','kr','입사일자',NULL,'Y',NULL,NULL,NULL,NULL);
INSERT IGNORE INTO t_co_code_detail_multi VALUES('4','option0212','kr','퇴사일자',NULL,'Y',NULL,NULL,NULL,NULL);
INSERT IGNORE INTO t_co_code_detail_multi VALUES('5','option0212','kr','생년월일',NULL,'Y',NULL,NULL,NULL,NULL);
INSERT IGNORE INTO t_co_code_detail_multi VALUES('6','option0212','kr','전화번호',NULL,'Y',NULL,NULL,NULL,NULL);
INSERT IGNORE INTO t_co_code_detail_multi VALUES('7','option0212','kr','집주소',NULL,'Y',NULL,NULL,NULL,NULL);

INSERT ignore INTO `tcmg_optionset` (`option_id`, `option_gb`, `module_gb`, `option_group`, `option_nm`, `p_option_id`, `p_option_must_value`, `option_level`, `option_desc`, `option_d_value`, `option_value_id`, `demo_link`, `search_keyword`, `option_desc2`, `option_nm_en`, `option_nm_jp`, `option_nm_cn`, `option_desc_en`, `option_desc_jp`, `option_desc_cn`, `use_yn`, `display_yn`, `created_by`, `created_dt`, `modify_by`, `modify_dt`, `sort_order`) 
VALUES ('cm1120', '2', 'cm', 'multi', '사용자 연동 항목 설정', 'cm1100', '|1|', '2', '사용자 연동 항목 설정', '2|3|4|5|7', 'option0212', NULL, NULL, NULL, '', '', '', '', '', '', 'Y', NULL, NULL, NULL, NULL, NULL, NULL);


ALTER TABLE `t_co_erp_schedule`
	CHANGE COLUMN IF EXISTS `schedule_type` `schedule_type` CHAR(1) NOT NULL DEFAULT '0' COMMENT '스케줄타입(0:사용안함,1:매일,2:매주,3:매월,4:지정한시간,5:반복)' AFTER `comp_seq`,
	ADD COLUMN IF NOT EXISTS `repeat_type` VARCHAR(32) NULL DEFAULT NULL COMMENT '반복종류(분/시간)' AFTER `special_day`,
	ADD COLUMN IF NOT EXISTS `repeat_value` VARCHAR(32) NULL DEFAULT NULL COMMENT '반복시간(분/시간)' AFTER `repeat_type`;


ALTER TABLE `t_co_erp`
	ADD COLUMN IF NOT EXISTS `org_auto_sync_status` VARCHAR(4) NOT NULL DEFAULT 'C' COMMENT '자동동기화상태값' AFTER `g20_yn`;



UPDATE tcmg_optionset SET sort_order = '10' WHERE option_id = 'cm1102';
UPDATE tcmg_optionset SET sort_order = '20' WHERE option_id = 'cm1120';
UPDATE tcmg_optionset SET sort_order = '30' WHERE option_id = 'cm1103';
UPDATE tcmg_optionset SET sort_order = '40' WHERE option_id = 'cm1110';
UPDATE tcmg_optionset SET use_yn = 'N' WHERE option_id = 'cm1110';
UPDATE tcmg_optionset SET use_yn = 'N' WHERE option_id = 'cm1104';



UPDATE tcmg_optionset SET option_nm = '사용자 항목 그룹웨어 수정' WHERE option_id = 'cm1103';

UPDATE tcmg_optionset SET option_desc = 'ERP 조직도 동기화 시 ERP에서 그룹웨어로 동기화 되는 항목을 설정할 수 있습니다.
선택된 항목만 그룹웨어에 동기화 되며, 미선택 시 필수 항목만 동기화처리됩니다.

- 필수 항목 : 사원명, 부서명, ERP사번, 메일 ID, 직급, 직책, 근무구분' WHERE option_id = 'cm1120';




UPDATE tcmg_optionset SET option_desc = 'ERP 조직도 동기화 시 그룹웨어에서 사용자 항목에 대하여 수정 여부를 설정 할 수 있습니다.
연동된 사용자 항목에 대해서 마이페이지 > 기본정보수정 메뉴에서 수정할 수 있으며,
미사용인 경우 그룹웨어에서 사용자 항목에 대하여 수정 할 수 없습니다.' WHERE option_id = 'cm1103';

DELETE FROM t_co_Code_Detail WHERE CODE = 'option0212' AND detail_code = '1';
DELETE FROM t_co_Code_Detail_multi WHERE CODE = 'option0212' AND detail_code = '1';

UPDATE tcmg_optionset SET option_d_value = '2|3|4|5|6|7' WHERE option_id = 'cm1120';



INSERT IGNORE INTO `tcmg_optionset` (`option_id`, `option_gb`, `module_gb`, `option_group`, `option_nm`, `p_option_id`, `p_option_must_value`, `option_level`, `option_desc`, `option_d_value`, `option_value_id`, `demo_link`, `search_keyword`, `option_desc2`, `option_nm_en`, `option_nm_jp`, `option_nm_cn`, `option_desc_en`, `option_desc_jp`, `option_desc_cn`, `use_yn`, `display_yn`, `created_by`, `created_dt`, `modify_by`, `modify_dt`, `sort_order`) VALUES ('pathSeq1400', '1', 'cm', 'multi', '회계', 'cm1700', '|1|', '2', '회계 메뉴의 첨부파일을 다운로드 또는 문서뷰어를 통한 바로보기 기능을 사용할 수 있습니다.', '0|1|', 'option0044', NULL, NULL, NULL, 'Accounting', '会計', '会计', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, 20);



DELIMITER $$

DROP FUNCTION IF EXISTS `set_erp_option`$$

CREATE FUNCTION `set_erp_option`(
) RETURNS VARCHAR(1000) CHARSET utf8mb4
BEGIN
	DECLARE sGroupSeq VARCHAR(32);
	DECLARE sCompSeq VARCHAR(32);
	DECLARE sCodeType VARCHAR(32);
	DECLARE sErpCode VARCHAR(32);
	DECLARE sGowCode VARCHAR(32);
	DECLARE optionvalue VARCHAR(32);
	DECLARE sCompList VARCHAR(32);
	DECLARE compCnt VARCHAR(32);
	DECLARE erpType VARCHAR(32);
	
	
	
	myloop: LOOP
		SELECT COUNT(*) INTO compCnt FROM tcmg_optionvalue WHERE option_id = 'cm1110' AND option_value != '0' LIMIT 1;
		IF compCnt = 0 THEN
			LEAVE myloop;
		END IF;
		
		SELECT co_id, group_seq INTO sCompList, sGroupSeq FROM tcmg_optionvalue INNER JOIN t_co_group g ON 1=1 WHERE option_id = 'cm1110' AND option_value = '1' LIMIT 1;
		SELECT erp_Type_Code INTO erpType FROM t_Co_erp WHERE comp_Seq = sCompList AND achr_gbn = 'hr' LIMIT 1;
		SELECT if(COUNT(*) = 0, '0', option_value) INTO optionvalue FROM tcmg_optionvalue WHERE option_id = 'cm1110' AND co_id = sCompList LIMIT 1;
		
		IF optionvalue != '0' THEN		
			IF erpType = 'ERPiU' THEN
				INSERT IGNORE INTO t_co_erp_sync_code VALUES(sGroupSeq,sCompList,'40','1','1','직급',NULL,NULL,NULL);	
				INSERT IGNORE INTO t_co_erp_sync_code VALUES(sGroupSeq,sCompList,'40','2','3','직책',NULL,NULL,NULL);
				INSERT IGNORE INTO t_co_erp_sync_code VALUES(sGroupSeq,sCompList,'40','3','2','직위',NULL,NULL,NULL); 
			END IF; 
		END IF;
		
		DELETE FROM tcmg_optionvalue WHERE option_id = 'cm1110' AND co_id = sCompList;
		 
	END LOOP myloop;



	RETURN '123123';
    END$$

DELIMITER ;

DROP FUNCTION IF EXISTS set_erp_option;

*/

-- 	소스시퀀스 8499

/*
수정사항
[시스템설정] 공통옵션설정 > 기본정보수정항목제한 개선(로그인패스워드/결재패스워드/급여패스워드 별도설정)
[통합검색] 통합검색 문서 검색시 권한이 없는 문서도 검색 되는 현상 수정
*/

/*
update tcmg_optionset set p_option_must_value = '|1|2|' where option_id='com201';

insert ignore into tcmg_optionset(option_id, option_gb, module_gb, option_group, option_nm, p_option_id, p_option_must_value, option_level, option_desc, option_d_value, option_value_id, demo_link, search_keyword, option_desc2, option_nm_en, option_nm_jp, option_nm_cn, option_desc_en, option_desc_jp, option_desc_cn, use_yn, display_yn, created_by, created_dt, modify_by, modify_dt, sort_order) VALUES
('rep001', '1', 'hid', 'single', '받은업무보고삭제가능여부(숨김)', NULL, NULL, '1', '', '0', 'option0002', NULL, NULL, NULL, '', '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);


update tcmg_optionset set option_nm='비밀번호', option_group='multi', option_d_value='', option_value_id='option0101', option_desc='마이페이지 기본정보 수정 메뉴에서 비밀번호 별 수정 여부 설정 가능합니다.
체크된 항목은 수정할 수 없으며, 미체크된 항목에 [변경]버튼이 노출되어 수정이 가능합니다.'  where option_id='cm1014';

insert ignore into t_co_code
(code, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('option0101', 'Y', NULL, NULL, NULL, NULL);

insert ignore into t_co_code_multi
(code, lang_code, name, note, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('option0101', 'kr', '패스워드구분', NULL, 'Y', NULL, NULL, NULL, NULL);

insert ignore into t_co_code_detail
(detail_code, code, ischild, order_num, flag_1, flag_2, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('def', 'option0101', 'N', 0, NULL, NULL, 'Y', NULL, NULL, NULL, NULL), 
('app', 'option0101', 'N', 1, NULL, NULL, 'Y', NULL, NULL, NULL, NULL),
('pay', 'option0101', 'N', 2, NULL, NULL, 'Y', NULL, NULL, NULL, NULL);

insert ignore into t_co_code_detail_multi
(detail_code, code, lang_code, detail_name, note, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('def', 'option0101', 'kr', '로그인 비밀번호', NULL, 'Y', NULL, NULL, NULL, NULL),
('def', 'option0101', 'en', 'Password of Log in', NULL, 'Y', NULL, NULL, NULL, NULL),
('def', 'option0101', 'jp', 'ログインパスワード', NULL, 'Y', NULL, NULL, NULL, NULL),
('def', 'option0101', 'cn', '登录密码', NULL, 'Y', NULL, NULL, NULL, NULL),
('app', 'option0101', 'kr', '결재 비밀번호', NULL, 'Y', NULL, NULL, NULL, NULL),
('app', 'option0101', 'en', 'Approval of password', NULL, 'Y', NULL, NULL, NULL, NULL),
('app', 'option0101', 'jp', '決裁パスワード', NULL, 'Y', NULL, NULL, NULL, NULL),
('app', 'option0101', 'cn', '审批密码', NULL, 'Y', NULL, NULL, NULL, NULL),
('pay', 'option0101', 'kr', '급여 비밀번호', NULL, 'Y', NULL, NULL, NULL, NULL),
('pay', 'option0101', 'en', 'Password of salary', NULL, 'Y', NULL, NULL, NULL, NULL),
('pay', 'option0101', 'jp', '給料パスワード', NULL, 'Y', NULL, NULL, NULL, NULL),
('pay', 'option0101', 'cn', '工资密码', NULL, 'Y', NULL, NULL, NULL, NULL);

update tcmg_optionvalue set option_value='def|app|pay|' where option_id='cm1014' and option_value='1';
*/

-- 	소스시퀀스 8751


/*
수정사항
[마이페이지] 기본정보관리 수정 시 패스워드 인증하도록 보안개선
[알림] 메신저 시스템대화방 자원예약 알림 링크 오류 수정.
[일정] 일정 일괄 등록 메뉴추가(관리자)
[공통옵션] 쪽지 회수옵션 추가
*/

/*
INSERT IGNORE INTO `t_co_alert_menu` (`event_sub_type`, `lnb_menu_no`, `event_type`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('RS005', '302030000', 'RESOURCE', NULL, NULL, NULL, NULL);


DELIMITER $$
DROP FUNCTION IF EXISTS neos_new.FN_GetMultiName$$
CREATE FUNCTION `FN_GetMultiName`(
	`langCode` VARCHAR(2),
	`orgDiv` VARCHAR(10),
	`seq` VARCHAR(32)

) RETURNS varchar(128) CHARSET utf8
BEGIN
    DECLARE nRetVal VARCHAR(128) DEFAULT '';
    
    IF langCode = '' THEN
       SET langCode = 'kr';
    END IF;
    
    IF orgDiv = 'EMP' THEN
    	SELECT ifnull(multi.emp_name, kr.emp_name) INTO nRetVal
		FROM t_co_emp_multi kr
		left join t_co_emp_multi multi on kr.emp_seq=multi.emp_seq and multi.lang_code=langCode
    	WHERE kr.emp_seq=seq AND kr.lang_code='kr';
    ELSEIF orgDiv = 'DEPT' THEN
      SELECT ifnull(multi.dept_name, kr.dept_name) INTO nRetVal 
		FROM t_co_dept_multi kr
		left join t_co_dept_multi multi on kr.dept_seq=multi.dept_seq and multi.lang_code=langCode
    	WHERE kr.dept_seq=seq AND kr.lang_code='kr';     
    ELSEIF orgDiv = 'COMP' THEN
      SELECT ifnull(multi.comp_name, kr.comp_name) INTO nRetVal 
		FROM t_co_comp_multi kr
		left join t_co_comp_multi multi on kr.comp_seq=multi.comp_seq AND multi.lang_code=langCode
    	WHERE kr.comp_seq=seq AND kr.lang_code='kr';
    ELSEIF orgDiv = 'BIZ' THEN
      SELECT ifnull(multi.biz_name, kr.biz_name) INTO nRetVal 
		FROM t_co_biz_multi kr
      left join t_co_biz_multi multi on kr.biz_seq=multi.biz_seq AND multi.lang_code=langCode
    	WHERE kr.biz_seq=seq AND kr.lang_code='kr';
    ELSEIF orgDiv = 'POSITION' THEN
      SELECT ifnull(multi.dp_name, kr.dp_name) INTO nRetVal 
		FROM t_co_comp_duty_position_multi kr
		left join t_co_comp_duty_position_multi multi on kr.dp_type=multi.dp_type and kr.dp_seq=multi.dp_seq and multi.lang_code=langCode
    	WHERE kr.dp_type = 'POSITION' and binary(kr.dp_seq)=seq AND kr.lang_code='kr';
    ELSEIF orgDiv = 'DUTY' THEN
      SELECT ifnull(multi.dp_name, kr.dp_name) INTO nRetVal 
		FROM t_co_comp_duty_position_multi kr
		left join t_co_comp_duty_position_multi multi on kr.dp_type=multi.dp_type and kr.dp_seq=multi.dp_seq and multi.lang_code=langCode
    	WHERE kr.dp_type = 'DUTY' and binary(kr.dp_seq)=seq AND kr.lang_code='kr';          
    END IF;
    
    RETURN nRetVal;
    
END$$
DELIMITER ;


INSERT IGNORE INTO `t_co_menu_adm` (`menu_no`, `menu_gubun`, `upper_menu_no`, `menu_ordr`, `use_yn`, `url_gubun`, `url_path`, `sso_use_yn`, `menu_depth`, `menu_img_class`, `create_seq`, `create_date`, `modify_seq`, `modify_date`, `menu_adm_gubun`, `menu_auth_type`, `public_yn`, `delete_yn`) 
VALUES (301080000, 'MENU003', 301000000, 301080000, 'Y', 'schedule', '/Views/Common/mCalendarManage/registExcel', 'N', 3, NULL, 'SYSTEM', NOW(), null, null, 'MENU003', 'ADMIN', 'Y', NULL);

INSERT IGNORE INTO `t_co_menu_adm_multi` (`menu_no`, `lang_code`, `menu_nm`, `menu_dc`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) 
VALUES (301080000, 'kr', '일정 일괄 등록', '', 'SYSTEM', NOW(), NULL, NULL);


INSERT IGNORE INTO `tcmg_optionset` (`option_id`, `option_gb`, `module_gb`, `option_group`, `option_nm`, `p_option_id`, `p_option_must_value`, `option_level`, `option_desc`, `option_d_value`, `option_value_id`, `demo_link`, `search_keyword`, `option_desc2`, `option_nm_en`, `option_nm_jp`, `option_nm_cn`, `option_desc_en`, `option_desc_jp`, `option_desc_cn`, `use_yn`, `display_yn`, `created_by`, `created_dt`, `modify_by`, `modify_dt`, `sort_order`) 
VALUES ('com700', '1', 'cm', 'single', '쪽지 회수기능 사용', NULL, '1', '1', '사용자가 보낸 쪽지를 회수 할 수 있습니다. \r\n\r\n- 사용 : 회수 기능 사용 [시간 설정 필요] \r\n ㄴ 읽은 쪽지 : “회수된 쪽지입니다.” 문구 제공\r\n ㄴ 안읽은 쪽지 : 받은 쪽지함에서 미노출 처리 \r\n- 미사용 : 회수 기능 미사용  ', '0', 'option0002', NULL, NULL, NULL, '', '', '', '', '', '', 'Y', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `tcmg_optionset` (`option_id`, `option_gb`, `module_gb`, `option_group`, `option_nm`, `p_option_id`, `p_option_must_value`, `option_level`, `option_desc`, `option_d_value`, `option_value_id`, `demo_link`, `search_keyword`, `option_desc2`, `option_nm_en`, `option_nm_jp`, `option_nm_cn`, `option_desc_en`, `option_desc_jp`, `option_desc_cn`, `use_yn`, `display_yn`, `created_by`, `created_dt`, `modify_by`, `modify_dt`, `sort_order`) 
VALUES ('com701', '1', 'cm', 'single', '쪽지 회수 시간설정 ', 'com700', '|1|', '2', '발송시간을 기준으로 설정한 시간 이후 부터는 쪽지 회수가 불가능합니다.\r\n- 제한 안함 : 회수 가능 시간을 제한하지 않습니다.\r\n- 제한 시간 설정 : 회수 기능 시간을 직접 입력합니다.\r\nㄴ 텍스트 + 분 : 분단위 시간을 설정합니다. (min : 1, max : 60)\r\nㄴ 텍스트 + 시간 : 시간단위 시간을 설정합니다. (min : 1, max : 24)\r\nㄴ 텍스트 + 일 : 일단위 시간을 설정합니다. (min : 1, max : 90)', '1|h', 'option0300', NULL, NULL, NULL, '', '', '', '', '', '', 'Y', NULL, NULL, NULL, NULL, NULL, NULL);


INSERT IGNORE INTO `t_co_code` (`code`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('option0300', 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_multi` (`code`, `lang_code`, `name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('option0300', 'kr', '쪽지 회수 시간설정', '', 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail` (`detail_code`, `code`, `ischild`, `order_num`, `flag_1`, `flag_2`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('0', 'option0300', 'N', 10, NULL, NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail` (`detail_code`, `code`, `ischild`, `order_num`, `flag_1`, `flag_2`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('1', 'option0300', 'N', 20, NULL, NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('0', 'option0300', 'kr', '제한 안함', '', 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('1', 'option0300', 'kr', '제한 시간 설정', '', 'Y', NULL, NULL, NULL, NULL);

ALTER TABLE t_co_atch_file_detail CHARACTER SET utf8mb4;
ALTER TABLE t_co_atch_file_detail MODIFY file_id varchar(32) CHARACTER SET utf8mb4;
*/

-- 소스시퀀스 : 8871



/*

ALTER TABLE t_co_atch_file_detail 
MODIFY   file_id varchar(32) CHARACTER SET utf8mb4,
MODIFY  `path_seq` varchar(32) CHARACTER SET utf8mb4 DEFAULT NULL,
MODIFY  `file_stre_cours` varchar(2000) CHARACTER SET utf8mb4 DEFAULT NULL,
MODIFY  `stre_file_name` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
MODIFY  `orignl_file_name` varchar(255) CHARACTER SET utf8mb4 COMMENT '원파일명',
MODIFY  `file_extsn` varchar(20) CHARACTER SET utf8mb4 DEFAULT NULL,
MODIFY  `use_yn` char(1) CHARACTER SET utf8mb4 DEFAULT 'Y' COMMENT '사용유무';

ALTER TABLE tcmg_optionvalue_history CHARACTER SET utf8mb4;
ALTER TABLE tcmg_optionvalue_history 
MODIFY  `seq` int(11) NOT NULL AUTO_INCREMENT,
MODIFY  `op_code` char(1) CHARACTER SET utf8mb4 NOT NULL DEFAULT '0',
MODIFY  `option_id` varchar(50) CHARACTER SET utf8mb4 DEFAULT NULL,
MODIFY  `co_id` varchar(50) CHARACTER SET utf8mb4 DEFAULT NULL,
MODIFY  `option_value` varchar(50) CHARACTER SET utf8mb4 DEFAULT NULL,
MODIFY  `created_by` varchar(50) CHARACTER SET utf8mb4 DEFAULT NULL,
MODIFY  `modify_by` varchar(50) CHARACTER SET utf8mb4 DEFAULT NULL;

ALTER TABLE t_interlock_token CHARACTER SET utf8mb4;
ALTER TABLE t_interlock_token 
MODIFY  `token` varchar(64) CHARACTER SET utf8mb4 NOT NULL,
MODIFY  `device_id` varchar(128) CHARACTER SET utf8mb4 NOT NULL,
MODIFY  `login_id` varchar(32) CHARACTER SET utf8mb4 NOT NULL,
MODIFY  `v_type` varchar(10) CHARACTER SET utf8mb4 NOT NULL;

ALTER TABLE t_interlock_token_time CHARACTER SET utf8mb4;
ALTER TABLE t_interlock_token_time 
MODIFY  `v_type` varchar(10) CHARACTER SET utf8mb4 NOT NULL,
MODIFY  `v_sub_type` varchar(10) CHARACTER SET utf8mb4 NOT NULL DEFAULT '0';

ALTER TABLE t_fx_fax_nickname_option CHARACTER SET utf8mb4;
ALTER TABLE t_fx_fax_nickname_option 
MODIFY  `group_seq` varchar(50) CHARACTER SET utf8mb4 DEFAULT NULL,
MODIFY  `option` char(1) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '"1":팩스번호, "2":팩스번호(별칭), "3":별칭(백스번호), "4":별칭';

ALTER TABLE t_ext_tcmg_link CHARACTER SET utf8mb4;
ALTER TABLE t_ext_tcmg_link 
MODIFY  `link_type` varchar(32) CHARACTER SET utf8mb4 NOT NULL COMMENT '링크타잎',
MODIFY  `link_detail_type` varchar(32) CHARACTER SET utf8mb4 NOT NULL COMMENT '링크타잎 상세',
MODIFY  `group_seq` varchar(32) CHARACTER SET utf8mb4 DEFAULT '1' COMMENT '그룹 시퀀스',
MODIFY  `link_nm_kr` varchar(32) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '링크명(한국어)',
MODIFY  `gnb_menu_no` varchar(32) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '상단 메뉴 번호',
MODIFY  `lnb_menu_no` varchar(32) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '왼쪽 메뉴 번호',
MODIFY  `type` char(1) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '링크타입',
MODIFY  `view_type` char(1) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '뷰타입',
MODIFY  `target` char(20) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '링크 모듈',
MODIFY  `url_path` varchar(256) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '링크 주소 : URL or URI',
MODIFY  `create_seq` varchar(32) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '등록자 시퀀스',
MODIFY  `modify_seq` varchar(32) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '수정자 시퀀스';

update tcmg_optionset set use_yn = 'N' where option_id='cm400';
delete from tcmg_optionvalue where option_id='cm400';

INSERT IGNORE INTO `t_co_alert_menu` (`event_sub_type`, `lnb_menu_no`, `event_type`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('RS005', '302030000', 'RESOURCE', NULL, NULL, NULL, NULL);
*/

-- 소스시퀀스 9033


/*
수정사항
[원피스] 소유자변경 기능 추가
[조직도정보관리] 부서 사용여부 N 처리시 하위부서 사용여부 N 처리 기능 추가
*/


/*
DROP TABLE IF EXISTS ONEFFICE_CHANGE_OWNER_DOC;
DROP TABLE IF EXISTS ONEFFICE_CHANGE_OWNER_REQ;

CREATE TABLE IF NOT EXISTS ONEFFICE_CHANGE_OWNER_REQ (

  req_id VARCHAR(32) NOT NULL,

  org_owner_id VARCHAR(32) NOT NULL,

  new_owner_id VARCHAR(32) NOT NULL,

  state CHAR(1) DEFAULT '0',

  reg_date DATETIME DEFAULT CURRENT_TIMESTAMP,

  mod_date DATETIME DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (req_id)

) ENGINE=INNODB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS ONEFFICE_CHANGE_OWNER_DOC (

  req_id VARCHAR(32) NOT NULL,

  doc_no VARCHAR(32) NOT NULL,

  CONSTRAINT FK_ONEFFICE_CHANGE_OWNER_REQ FOREIGN KEY (req_id) REFERENCES oneffice_change_owner_req (req_id) ON DELETE CASCADE

) ENGINE=INNODB DEFAULT CHARSET=utf8;

UPDATE t_co_dept SET use_yn = 'N' WHERE dept_seq IN (SELECT DISTINCT cild.dept_seq FROM (SELECT dept_seq, path FROM t_co_dept WHERE use_yn = 'Y') cild JOIN (SELECT path FROM t_co_dept WHERE use_yn = 'N') par WHERE INSTR(CONCAT('|',cild.path,'|'), concat('|',par.path,'|')));
*/

-- 소스시퀀스 9198

/*
수정사항
[시스템설정] ERP조직도연동 기능 수정
*/

/*

UPDATE t_co_emp_comp a INNER JOIN t_co_erp b
ON a.comp_seq = b.comp_seq AND b.achr_gbn = 'hr'
SET a.erp_comp_seq = b.erp_comp_seq
WHERE ifnull(a.erp_emp_seq,'') != '' AND IFNULL(a.erp_comp_seq,'') = '';

ALTER TABLE `t_co_second_cert_device`
	ADD INDEX IF NOT EXISTS `t_co_second_cert_device_fk01` (`emp_seq`);
	

CREATE TABLE IF NOT EXISTS `t_co_function_list` (
  `function_cd` varchar(32) NOT NULL COMMENT '펑션코드',
  `function_tp` varchar(32) NOT NULL COMMENT '펑션타입',  
  `menu_no` int(20) NOT NULL COMMENT '메뉴코드',
  PRIMARY KEY (`function_cd`, `menu_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='펑션리스트';

insert ignore into t_co_function_list
(function_cd, function_tp, menu_no) VALUES
('ACCOUNT', 'APP', 804000000), 
('BOARD', 'WEB', 500000000), 
('CGATE', 'APP', 0), 
('DOWNLOAD', 'APP', 0), 
('EAPPROVAL', 'WEB', 100000000), 
('EAPPROVAL', 'WEB', 2000000000), 
('EDMS', 'WEB', 600000000), 
('FAX', 'WEB', 901000000), 
('FUND', 'APP', 0), 
('KISS', 'APP', 1100000000), 
('MAIL', 'WEB', 200000000), 
('MESSAGE', 'APP', 0), 
('MYGRP', 'APP', 0), 
('NOTE', 'WEB', 303010000), 
('ORGCHART', 'APP', 0), 
('PROJECT', 'WEB', 400000000), 
('QR_AUTH', 'APP', 0), 
('REPORT', 'WEB', 304000000), 
('RESOURCE', 'WEB', 302020000), 
('SCHEDULE', 'WEB', 301000000), 
('TALK', 'APP', 0);


*/

-- 소스시퀀스 9309

/*
수정사항
[시스템설정] 메뉴사용내역 web elastic > db 저장
*/

/*
 
CREATE TABLE IF NOT EXISTS `t_co_menu_access_sync` (
    `group_seq` VARCHAR(32) NOT NULL COMMENT '그룹시퀀스',
    `emp_seq`   VARCHAR(32) NOT NULL COMMENT '사용자시퀀스',
    `use_date`  DATETIME NOT NULL COMMENT '메뉴사용일자',
    `type_code` CHAR(1) NULL COMMENT '웹/모바일 구분(ex:0=web, 1=mobile)',
    `lang_code` VARCHAR(32) NULL COMMENT '언어코드',
    `login_id`  VARCHAR(32) NULL COMMENT '로그인ID',
    `emp_name`  VARCHAR(128) NULL COMMENT '사용자이름',
    `menu_no`   INT(20) NULL COMMENT '메뉴번호',
    `menu_name` VARCHAR(60) NULL COMMENT '메뉴명',
    `menu_auth` VARCHAR(30) NULL COMMENT '메뉴 권한 ("USER" OR "ADMIN" OR "MASTER")',
    `access_ip` VARCHAR(32) NULL COMMENT '사용IP'
)
COMMENT='WEB 메뉴사용내역 동기화 테이블'
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;

 */

-- 소스시퀀스 9342







/*
수정사항
[인사/근태] 회사신규 생성시 인사근태 기초데이터 추가(출/퇴근관련 정보)
*/


/*
DELIMITER $$

DROP PROCEDURE IF EXISTS `p_baseDateSet`$$

CREATE DEFINER=`root`@`%` PROCEDURE `p_baseDateSet`(
	IN `compSeq` VARCHAR(50),
	IN `groupSeq` VARCHAR(50),
	IN `empSeq` VARCHAR(50)
)
    COMMENT '회사 신규 추가시 기초데이터 셋팅 프로시저.'
BEGIN
	DECLARE userAuthCode VARCHAR(50);
	DECLARE adminAuthCode VARCHAR(50);
	
	
	SET userAuthCode= (SELECT CONCAT('A',nextval('authorCode')));
	SET adminAuthCode= (SELECT CONCAT('B',nextval('authorCode')));	
	
	
	INSERT IGNORE INTO t_co_authcode (author_code, author_type, author_base_yn, author_use_yn, group_seq, comp_seq, create_seq, create_date, modify_seq, modify_date, order_num, dept_seq) VALUES (userAuthCode, '001', 'Y', 'Y', groupSeq, compSeq, empSeq, NOW(), NULL, NULL, NULL, NULL);
	INSERT IGNORE INTO t_co_authcode (author_code, author_type, author_base_yn, author_use_yn, group_seq, comp_seq, create_seq, create_date, modify_seq, modify_date, order_num, dept_seq) VALUES (adminAuthCode, '005', 'N', 'Y', groupSeq, compSeq, empSeq, NOW(), NULL, NULL, NULL, NULL);
	INSERT IGNORE INTO t_co_authcode_multi (author_code, lang_code, author_nm, author_dc, create_seq, create_date, modify_seq, modify_date) VALUES (userAuthCode, 'kr', '일반사용자권한', '', NOW(), empSeq, NULL, NULL);
	INSERT IGNORE INTO t_co_authcode_multi (author_code, lang_code, author_nm, author_dc, create_seq, create_date, modify_seq, modify_date) VALUES (adminAuthCode, 'kr', '회사관리자', '', NOW(), empSeq, NULL, NULL);
	
	
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('1000000000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('100000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('1001000000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('1001010000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('1001020000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('1001030000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('1002020000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('1003000000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('1003010000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('101000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('101010000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('101020000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('101030000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('101040000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('101050000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('101060000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('102000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('102010000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('102020000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('102030000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('102040000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('103000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('103010000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('103010100' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('103010200' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('103010300' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('103020000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('103020100' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('103020200' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('103020300' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('103020400' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('103030000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('103030100' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('103030200' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('103030300' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('104000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('104010000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('104010100' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('104010200' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('104010300' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('104020000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('104030000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('104040000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('104050000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('104060000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('104060100' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('104060200' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('104060300' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('104060400' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('104070000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('104070100' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('104070200' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('104080000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('200000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('2000000000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('2001000000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('2001010000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('2001020000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('2001030000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('2002000000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('2002010000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('2002020000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('2002050000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('2002060000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('2002070000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('2002080000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('2002090000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('2002100000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('2002110000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('2002120000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('2002130000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('2004000000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('2004010000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('2004020000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('2004030000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('300000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('301000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('301030000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('301040000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('301050000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('301060000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('301060100' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('302000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('302010000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('302020000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('302030000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('303000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('303010000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('304000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('304010000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('304020000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('304030000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('304040000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('390000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('400000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('401000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('401010000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('500000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('501000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('501030000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('502000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('502010000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('504000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('504010000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('504020000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('504030000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('555'		 , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('600000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('601000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('601010000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('601030000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('601040000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('601050000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('603000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('603040000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('700000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('701000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('701010000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('701020000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('701030000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('800000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('803000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('803010000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('805000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('805010000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('805020000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('805030000' , userAuthCode);
	
	
	
	
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('0'		 ,adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('200000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('300000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('301000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('301020000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('302000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('302010000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('302020000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('302030000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('302040000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('302050000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('302060000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('302070000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('303000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('303010000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('400000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('401000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('401020000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('401040000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('402000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('402010000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('500000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('501000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('501005000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('501006000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('501007000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('501011000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('502000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('502001000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('502002000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('502003000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('502004000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('503000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('503001000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('504000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('504001000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('504002000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('504003000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('504004000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('504005000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('504006000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('505000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('505001000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('505002000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('505003000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('506000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('600000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('601000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('601001000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('601002000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('601003000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('601004000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('602000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('602001000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('603000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('603001000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('603002000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('603003000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('603004000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('603005000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('604000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('604001000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('605001000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('605002000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('700000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('701000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('701010000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('701020000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('701030000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('701040000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('701060000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('702000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('702010000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('702020000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('702040000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('702050000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('703000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('703010000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('703020000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('704000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('704010000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('705000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('705010000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('705020000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('705030000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('706000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('706010000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('706020000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('800000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('801000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('801010000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('801020000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('810000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('810100000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('810101000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('900000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('901000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('901020000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('901030000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('901040000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('902000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('902010000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('902020000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('903000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('903020000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('903030000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('905000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('905010000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('905020000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('905030000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('905040000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('907000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('908000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('908010000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('909000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('909010000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('910000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('911000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('911010000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('912000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('912000001',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('920000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('920100000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('920100100',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('920100200',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('920100300',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('930000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('931000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('931010000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('931010010',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('931010020',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('931010030',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('931010040',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('931020000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('931020010',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('931020030',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('931020040',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('931020060',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('931020070',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('931020090',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('931020100',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('931020130',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('931020140',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('931040000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('960000000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('960100000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('960101000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('960102000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('960103000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('960104000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('960105000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('960207000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('960300000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('960301000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('960302000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('960303000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('960304000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('960305000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('960306000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('960307000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('960308000',adminAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('960309000',adminAuthCode);
	
	
	
	INSERT IGNORE INTO teag_form_auth (org_div, org_id, form_id, created_dt, created_by, modify_dt, modify_by) VALUES
	('c', compSeq, 1, NOW(), 'SYSTEM', NOW(), 'SYSTEM'),
	('c', compSeq, 2, NOW(), 'SYSTEM', NOW(), 'SYSTEM'),
	('c', compSeq, 3, NOW(), 'SYSTEM', NOW(), 'SYSTEM'),
	('c', compSeq, 4, NOW(), 'SYSTEM', NOW(), 'SYSTEM'),
	('c', compSeq, 5, NOW(), 'SYSTEM', NOW(), 'SYSTEM'),
	('c', compSeq, 6, NOW(), 'SYSTEM', NOW(), 'SYSTEM'),
	('c', compSeq, 7, NOW(), 'SYSTEM', NOW(), 'SYSTEM'),
	('c', compSeq, 8, NOW(), 'SYSTEM', NOW(), 'SYSTEM'),
	('c', compSeq, 9, NOW(), 'SYSTEM', NOW(), 'SYSTEM');
INSERT IGNORE INTO teag_form_auth (org_div, org_id, form_id, created_dt, created_by, modify_dt, modify_by) VALUES
	('c', compSeq, 10, NOW(), 'SYSTEM', NOW(), 'SYSTEM'),
	('c', compSeq, 11, NOW(), 'SYSTEM', NOW(), 'SYSTEM'),
	('c', compSeq, 12, NOW(), 'SYSTEM', NOW(), 'SYSTEM'),
	('c', compSeq, 13, NOW(), 'SYSTEM', NOW(), 'SYSTEM'),
	('c', compSeq, 14, NOW(), 'SYSTEM', NOW(), 'SYSTEM'),
	('c', compSeq, 15, NOW(), 'SYSTEM', NOW(), 'SYSTEM'),
	('c', compSeq, 16, NOW(), 'SYSTEM', NOW(), 'SYSTEM'),
	('c', compSeq, 17, NOW(), 'SYSTEM', NOW(), 'SYSTEM'),
	('c', compSeq, 18, NOW(), 'SYSTEM', NOW(), 'SYSTEM');
INSERT IGNORE INTO teag_form_auth (org_div, org_id, form_id, created_dt, created_by, modify_dt, modify_by) VALUES
	('c', compSeq, 19, NOW(), 'SYSTEM', NOW(), 'SYSTEM'),
	('c', compSeq, 20, NOW(), 'SYSTEM', NOW(), 'SYSTEM'),
	('c', compSeq, 24, NOW(), 'SYSTEM', NOW(), 'SYSTEM');
INSERT IGNORE INTO teag_form_docauth (form_id, org_div, org_id, co_id, created_by, created_dt, modify_by, modify_dt) VALUES
	(1, 'm', 0, compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW()),
	(1, 'm', 1, compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW()),
	(2, 'm', 0, compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW()),
	(2, 'm', 1, compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW()),
	(3, 'm', 0, compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW()),
	(3, 'm', 1, compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW()),
	(4, 'm', 0, compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW()),
	(4, 'm', 1, compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW()),
	(5, 'm', 0, compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW());
INSERT IGNORE INTO teag_form_docauth (form_id, org_div, org_id, co_id, created_by, created_dt, modify_by, modify_dt) VALUES
	(5, 'm', 1, compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW()),
	(6, 'm', 0, compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW()),
	(6, 'm', 1, compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW()),
	(7, 'm', 0, compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW()),
	(7, 'm', 1, compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW()),
	(8, 'm', 0, compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW()),
	(8, 'm', 1, compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW()),
	(9, 'm', 0, compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW()),
	(9, 'm', 1, compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW());
INSERT IGNORE INTO teag_form_docauth (form_id, org_div, org_id, co_id, created_by, created_dt, modify_by, modify_dt) VALUES
	(10, 'm', 0, compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW()),
	(10, 'm', 1, compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW()),
	(11, 'm', 0, compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW()),
	(11, 'm', 1, compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW()),
	(12, 'm', 0, compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW()),
	(12, 'm', 1, compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW()),
	(13, 'm', 0, compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW()),
	(13, 'm', 1, compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW()),
	(14, 'm', 0, compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW());
INSERT IGNORE INTO teag_form_docauth (form_id, org_div, org_id, co_id, created_by, created_dt, modify_by, modify_dt) VALUES
	(14, 'm', 1, compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW()),
	(15, 'm', 0, compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW()),
	(15, 'm', 1, compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW()),
	(16, 'm', 0, compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW()),
	(16, 'm', 1, compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW()),
	(17, 'm', 0, compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW()),
	(17, 'm', 1, compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW()),
	(18, 'm', 0, compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW()),
	(18, 'm', 1, compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW());
INSERT IGNORE INTO teag_form_docauth (form_id, org_div, org_id, co_id, created_by, created_dt, modify_by, modify_dt) VALUES
	(19, 'm', 0, compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW()),
	(19, 'm', 1, compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW()),
	(20, 'm', 0, compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW()),
	(20, 'm', 1, compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW()),
	(24, 'm', 0, compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW()),
	(24, 'm', 1, compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW());

	
	INSERT IGNORE INTO teag_numberingpublic (numbering_id, public_gb, org_div, org_id, created_by, created_dt, modify_by, modify_dt) VALUES
		('1001', '20', 'C', compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW());	
		
INSERT IGNORE INTO t_at_commute_set(comp_seq, group_seq, type_code, coverage_web, coverage_messenger, coverage_mobile, apply_date, start_date, end_date, status_yn, use_yn, create_seq, modify_seq) VALUES
	(compSeq, groupSeq, 'B', 'Y', 'Y', 'N', '20190101', '20190101', '', 'N', 'Y', 'SYSTEM', 'SYSTEM');

INSERT IGNORE INTO t_at_commute_set_basic(commute_set_sqno, comp_seq, group_seq, type_code, apply_item_code, apply_div_code, apply_div_name, use_yn, create_seq, create_dt, modify_seq, modify_dt)
	SELECT commute_set_sqno, comp_seq, group_seq, type_code, '0', '0', '기본', 'Y', create_seq, create_dt, modify_seq, modify_dt FROM t_at_commute_set WHERE comp_seq = compSeq;


END$$

DELIMITER ;
*/

-- 소스시퀀스 9423

/*
수정사항
[시스템설정] 마스터 권한 > 비밀번호 초기화 요청 팝업 개선(모든 사용자 완료 후 팝업 닫힘 처리)
*/



-- 소스시퀀스 9537
/*

UPDATE t_co_group SET master_passwd = '';

-- 소스시퀀스 9597

*/

-- 소스시퀀스 9648

/*
ALTER TABLE t_co_group ADD COLUMN IF NOT EXISTS mfp_use_yn varchar(1) DEFAULT 'N' COMMENT '복합기연동 사용여부';
ALTER TABLE t_co_group ADD COLUMN IF NOT EXISTS mfp_url  varchar(512) DEFAULT NULL COMMENT '복합기연동 URL';

UPDATE t_co_menu_adm SET delete_yn = NULL WHERE menu_no = '2104040010';

ALTER TABLE t_co_group ADD COLUMN IF NOT EXISTS smtp_secu_tp  varchar(16) DEFAULT '' COMMENT 'SMTP보안설정타입';


DELIMITER $$

DROP TRIGGER IF EXISTS `TRG_T_CO_TS_REPORT_AD`$$

CREATE
    TRIGGER `TRG_T_CO_TS_REPORT_AD` BEFORE DELETE ON `t_sc_work_report` 
    FOR EACH ROW BEGIN

INSERT INTO t_se_job (
        event_date,
        job_type,
        pk_seq,
        iud_type
    )
   SELECT NOW(),
	CASE WHEN OLD.type = '1' THEN 'report-1'
	WHEN OLD.type = '2' THEN 'report-2' END
	,report_seq,'D' FROM
	t_sc_work_report WHERE TYPE IN ('1','2') AND report_seq = OLD.report_seq;

END;
$$

DELIMITER ;




DELIMITER $$

DROP TRIGGER IF EXISTS `TRG_T_CO_TS_REPORT_AI`$$

CREATE
    TRIGGER `TRG_T_CO_TS_REPORT_AI` AFTER INSERT ON `t_sc_work_report` 
    FOR EACH ROW BEGIN

INSERT INTO t_se_job (
        event_date,
        job_type,
        pk_seq,
        iud_type
    )
    SELECT NOW(),
	CASE WHEN NEW.type = '1' THEN 'report-1'
	WHEN NEW.type = '2' THEN 'report-2' END
	,report_seq,'I' FROM
	t_sc_work_report WHERE TYPE IN('1','2') AND report_seq = NEW.report_seq;
	
END;
$$

DELIMITER ;





DELIMITER $$

DROP TRIGGER IF EXISTS `TRG_T_CO_TS_REPORT_AU`$$

CREATE
    TRIGGER `TRG_T_CO_TS_REPORT_AU` AFTER UPDATE ON `t_sc_work_report` 
    FOR EACH ROW BEGIN

INSERT INTO t_se_job (
        event_date,
        job_type,
        pk_seq,
        iud_type
    )
    SELECT NOW(),
	CASE WHEN NEW.type = '1' THEN 'report-1'
	WHEN NEW.type = '2' THEN 'report-2' END
	,report_seq,
	CASE WHEN use_yn = 'Y' THEN 'U'
	     WHEN use_yn = 'N' THEN 'D' END
	FROM
	t_sc_work_report WHERE TYPE IN ('1','2') AND report_seq = NEW.report_seq;

END;
$$

DELIMITER ;


INSERT INTO t_se_job
SELECT 
	NOW(),
	'report-2',
	report_seq,
	'I'
FROM
	t_sc_work_report 
WHERE 
	TYPE = '2' AND use_yn = 'Y';
	
	
INSERT IGNORE INTO `t_co_code_detail` (`detail_code`, `code`, `ischild`, `order_num`, `flag_1`, `flag_2`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('SC015', 'COM510', 'N', 2, 'SCHEDULE', '일정', 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('SC015', 'COM510', 'kr', '일정 수정 알림', '일정 수정시 알림 사용여부', 'Y', NULL, NULL, NULL, NULL);
*/
	

/*
 * [알림]
 *  - 원피스 댓글 알림항목 추가
 *  - 대화회수 옵션 추가
 */


/*
INSERT IGNORE INTO `t_co_alert_menu` (`event_sub_type`, `lnb_menu_no`, `event_type`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('ONE001', NULL, 'ONEFFICE', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail` (`detail_code`, `code`, `ischild`, `order_num`, `flag_1`, `flag_2`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('ONE001', 'COM510', 'N', 6, 'ONEFFICE', '원피스', 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('ONE001', 'COM510', 'kr', 'ONEFFICE 댓글알림', 'ONEFFICE 문서에 댓글 등록시 알림 사용여부', 'Y', NULL, NULL, NULL, NULL);


INSERT IGNORE INTO `tcmg_optionset` (`option_id`, `option_gb`, `module_gb`, `option_group`, `option_nm`, `p_option_id`, `p_option_must_value`, `option_level`, `option_desc`, `option_d_value`, `option_value_id`, `demo_link`, `search_keyword`, `option_desc2`, `option_nm_en`, `option_nm_jp`, `option_nm_cn`, `option_desc_en`, `option_desc_jp`, `option_desc_cn`, `use_yn`, `display_yn`, `created_by`, `created_dt`, `modify_by`, `modify_dt`, `sort_order`) VALUES ('com600', '1', 'cm', 'single', '대화 회수 기능 사용', NULL, NULL, '1', '사용자가 대화방에서 보낸 메시지를 회수 할 수 있습니다.\r\n\r\n- 모든 메시지 회수 : 상대방의 읽음여부와 상관없이 메시지 회수가 가능합니다.\r\n- 상대방이 읽지않은 메시지만 회수 : 상대방이 메시지를 읽은 경우에는 회수가\r\n  불가능하며, 읽지않은 메시지만 회수 가능합니다.\r\n- 미사용 : 대화방 메시지 회수기능을 사용하지 않습니다. \r\n', '0', 'com600', NULL, NULL, NULL, '', '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code` (`code`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('com600', 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_multi` (`code`, `lang_code`, `name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('com600', 'kr', '대화회수옵션', NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail` (`detail_code`, `code`, `ischild`, `order_num`, `flag_1`, `flag_2`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('0', 'com600', 'N', 3, NULL, NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail` (`detail_code`, `code`, `ischild`, `order_num`, `flag_1`, `flag_2`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('1', 'com600', 'N', 1, NULL, NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail` (`detail_code`, `code`, `ischild`, `order_num`, `flag_1`, `flag_2`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('2', 'com600', 'N', 2, NULL, NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('0', 'com600', 'kr', '미사용', '', 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('1', 'com600', 'kr', '모든 메시지 회수', '', 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('2', 'com600', 'kr', '상대방이 읽지 않은 메시지만 회수', '', 'Y', NULL, NULL, NULL, NULL);
*/
-- 소스시퀀스 9735


/*	v1.2.104
 * [시스템설정]
 *  - ERP조직도연동 초기 비밀번호 설정 옵션 추가
 *  - 조직도 트리 open 설정옵션 기능 추가
 *  - 그룹정보관리 SMTP 보안설정 항목 추가
 *  - 보안등급관리 보안등급 추가 버그 수정 
 *  - 기상청 API 변경에 따른 날씨 포틀릿 로직 수정
 */
/*
ALTER TABLE t_co_group ADD COLUMN IF NOT EXISTS domain_redirect_yn  char(1) DEFAULT 'N' COMMENT '로그인페이지도메인리다이렉트여부';


INSERT IGNORE INTO `tcmg_optionset` (`option_id`, `option_gb`, `module_gb`, `option_group`, `option_nm`, `p_option_id`, `p_option_must_value`, `option_level`, `option_desc`, `option_d_value`, `option_value_id`, `demo_link`, `search_keyword`, `option_desc2`, `option_nm_en`, `option_nm_jp`, `option_nm_cn`, `option_desc_en`, `option_desc_jp`, `option_desc_cn`, `use_yn`, `display_yn`, `created_by`, `created_dt`, `modify_by`, `modify_dt`, `sort_order`) VALUES ('cm1140', '2', 'cm', 'text', '그룹웨어 초기 비밀번호 설정', 'cm1100', '|1|', '2', 'ERP 조직도 동기화 시 연동되는 사용자의 초기 비밀번호를 설정할 수 있습니다.\r\n\r\n초기 비밀번호 변경 후 연동되는 사용자부터 반영되며,\r\n로그인/급여/결재 비밀번호에 일괄 반영됩니다', '1111', 'option1140', NULL, NULL, NULL, '', '', '', '', '', '', 'Y', NULL, NULL, NULL, NULL, NULL, 10);
INSERT IGNORE INTO `t_co_code` (`code`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('option1140', 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_multi` (`code`, `lang_code`, `name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('option1140', 'kr', '그룹웨어 초기 비밀번호 설정(ERP조직도연동)', NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail` (`detail_code`, `code`, `ischild`, `order_num`, `flag_1`, `flag_2`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('1', 'option1140', 'N', NULL, NULL, NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('1', 'option1140', 'kr', '그룹웨어 초기 비밀번호 설정(ERP조직도연동)', NULL, 'Y', NULL, NULL, NULL, NULL);
DELETE FROM tcmg_optionvalue WHERE option_id = 'cm600';
DELETE FROM tcmg_optionset WHERE option_id = 'cm600';
INSERT IGNORE INTO `tcmg_optionset` (`option_id`, `option_gb`, `module_gb`, `option_group`, `option_nm`, `p_option_id`, `p_option_must_value`, `option_level`, `option_desc`, `option_d_value`, `option_value_id`, `demo_link`, `search_keyword`, `option_desc2`, `option_nm_en`, `option_nm_jp`, `option_nm_cn`, `option_desc_en`, `option_desc_jp`, `option_desc_cn`, `use_yn`, `display_yn`, `created_by`, `created_dt`, `modify_by`, `modify_dt`, `sort_order`) VALUES ('cm600', '2', 'cm', 'single', '조직도 트리 open 설정', NULL, NULL, '1', '조직도가 제공되는 화면에서 기본 depth 보기를 설정할 수 있습니다.\r\n※ 포털 하단 조직도는 적용되지 않습니다.\r\n\r\n- 사용 : 조직도 내 오픈할 depth를 설정합니다. 설정 이후 조직도 선택 시, 설정한 depth로 오픈됩니다.\r\n(0: 전체 트리 오픈 / 최대값 : 100)\r\n\r\n- 미사용 : 조직도 선택 시, 본인이 속한 부서로 오픈됩니다.', '0▦', 'option0002', NULL, NULL, NULL, '', '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);

ALTER TABLE `t_sc_work_report`
	ALTER `target_dept_seq` DROP DEFAULT;
ALTER TABLE `t_sc_work_report`
	CHANGE COLUMN `target_dept_seq` `target_dept_seq` VARCHAR(32) NULL COMMENT '보고대상 부서 seq' AFTER `target_comp_seq`;
	
*/
-- 소스시퀀스 9831




/* v 1.2.105
[시스템설정]
 - 메뉴사용내역 오류 수정(동적메뉴 menu_no 타입 오류)
 - 통합검색 특수문자 검색시 이상현상 수정
 - 통합검색 첨부파일 페이징 오동작 현상 수정
 - 통합검색 첨부파일 오픈시 에러현상 수정
 - 통합검색 문서첨부파일 검색 안되는 현상 수정
 [원피스]
  - 원피스 V3.0.2.7 반영
 [웹에디터]
  - 더존 웹에디터 v1.1.6.3 배포 
*/
/*
 ALTER TABLE `t_co_menu_access_sync` CHANGE COLUMN `menu_no` `menu_no` VARCHAR(32) NULL DEFAULT NULL COMMENT '메뉴번호' AFTER `emp_name`;
 
*/
-- 소스시퀀스 9949




/* v 1.2.106
[시스템설정]
 - ERP조직도연동 부서 변경시 권한 초기화되는 현상 수정(주성덕)
 - 포틀릿설정 퀵링크 양식크기 오타수정(6x > 10x)(김영조)
 - 비영리 통합검색 첨부파일 오류수정(박수빈)
 - 날씨 포틀릿 오류 수정(배성원)
 [마이페이지]
  - 마이페이지 수정시 초기화 오류 수정(박수빈)
 [웹에디터]
  - 더존 웹에디터 v1.1.6.4 배포 
 [원피스]
  - 원피스 원피스 V3.0.2.8 배포  
*/

-- 소스시퀀스 10087





/* v 1.2.106 (Bizbox Alpha V1.2.106 2차 소스 취합)
[시스템설정]
 - 일정 수정 알림 링크 오류 수정 - 메신저(주성덕) 

INSERT IGNORE INTO `t_co_alert_menu` (`event_sub_type`, `lnb_menu_no`, `event_type`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) 
VALUES ('SC015', '301080000', 'SCHEDULE', 'SYSTEM', now(), NULL, NULL);

*/
-- 소스시퀀스 10126





/* v 1.2.107
[통합검색]
 - 모바일 통합검색 특수문자 검색 안되는 현상 수정 (안호진) 

[원피스]
 - 업무보고(원피스) 특수문자(+,&)인코딩 오류 수정
 - 원피스 공통댓글 알림 상세링크 기능추가
 - oneffice_3.0.2.9
 
[포털]
 - 포털타입B 공휴일 상세 제목 나오지 않는 오류 수정
 - 설문조사 포틀릿 탭 마우스 오버시 커서모양 변경 삭제(김영조)
  
[공통]
 - Snackbard 공통처리(업무보고,노트,개인정보관리,주소록,방문객관리)
 - 권한없는 메뉴 url 직접접근 불가처리
 - jpg확장자 제한 삭제
 - 결제의견 삭제 오류 수정 (프로퍼티 값 추가)
 - 공통업다운로더 첨부파일 업로드후 삭제시 총용량에서 삭제파일 크기 삭제 안되는건 수정 (김영조)
 - dzeditor_v1.1.6.5
 
[그룹정보관리]
 - 로그인문구 저장시 ', " 에러 수정(김영조)

*/

/*
ALTER TABLE t_co_group ADD COLUMN IF NOT EXISTS df_use_yn varchar(1) DEFAULT 'N' COMMENT '딥파인더연동 사용여부';
ALTER TABLE t_co_group ADD COLUMN IF NOT EXISTS df_url  varchar(512) DEFAULT NULL COMMENT '딥파인더연동 URL';
UPDATE t_co_event_setting SET view_type = 'A', web_view_type = 'A', messenger_view_type = 'A', action_type = 'A', web_action_type = 'A' WHERE TYPE = 'ONEFFICE' AND CODE = 'ONE001';

CREATE TABLE IF NOT EXISTS `z_duzonitgroup_visitors_req` (
  `req_no` int(11) NOT NULL COMMENT '번호',
  `man_comp_seq` varchar(32) NOT NULL COMMENT '담당자회사seq',
  `man_dept_seq` varchar(32) NOT NULL,
  `man_emp_seq` varchar(32) NOT NULL COMMENT '담당자 seq',
  `req_comp_seq` varchar(32) NOT NULL COMMENT '회사seq',
  `req_emp_seq` varchar(32) NOT NULL COMMENT '유저seq',
  `approver_comp_seq` varchar(32) DEFAULT NULL COMMENT '승인자 회사seq',
  `approver_emp_seq` varchar(32) DEFAULT NULL COMMENT '승인자 유저seq',
  `visit_distinct` char(1) NOT NULL COMMENT '방문구분',
  `visitor_co` varchar(100) DEFAULT NULL COMMENT '방문자회사이름',
  `visitor_detail_info` varchar(1024) DEFAULT NULL COMMENT '방문자상세정보',
  `visit_dt_fr` char(8) NOT NULL COMMENT '방문일자',
  `visit_dt_to` char(8) DEFAULT NULL COMMENT '방문일자',
  `visit_tm_fr` char(4) DEFAULT NULL,
  `visit_tm_to` char(4) DEFAULT NULL,
  `visit_aim` varchar(255) DEFAULT NULL COMMENT '방문목적',
  `visit_cnt` int(11) NOT NULL COMMENT '방문인원',
  `etc` varchar(255) DEFAULT NULL COMMENT '비고',
  `edited_dt` datetime DEFAULT NULL COMMENT '수정일자',
  `created_dt` datetime NOT NULL COMMENT '생성일자',
  `del_yn` char(1) DEFAULT NULL COMMENT '삭제여부',
  `visit_place_code` varchar(32) DEFAULT NULL COMMENT '방문장소코드',
  `visit_place_sub_code` varchar(32) DEFAULT NULL COMMENT '방문장소서브코드',
  `elet_appv_interface_key` varchar(256) NOT NULL DEFAULT '' COMMENT '전자결재인터페이스키',
  `elct_appv_doc_id` varchar(256) NOT NULL DEFAULT '' COMMENT '전자결재문서아이디',
  PRIMARY KEY (`req_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='방문객신청정보';

ALTER TABLE `z_duzonitgroup_visitors_m` ADD COLUMN IF NOT EXISTS `visit_place_code` varchar(32) NULL COMMENT '방문장소코드';
ALTER TABLE `z_duzonitgroup_visitors_m` ADD COLUMN IF NOT EXISTS `visit_place_sub_code` varchar(32) NULL COMMENT '방문장소서브코드';
ALTER TABLE `z_duzonitgroup_visitors_m` ADD COLUMN IF NOT EXISTS `visit_place_name` varchar(255) NULL COMMENT '방문장소명';
ALTER TABLE `z_duzonitgroup_visitors_m` ADD COLUMN IF NOT EXISTS `visit_pticket_yn` char(1) NULL DEFAULT 'N' COMMENT '주차권발급여부';
ALTER TABLE `z_duzonitgroup_visitors_m` ADD COLUMN IF NOT EXISTS `elet_appv_link_yn` varchar(1) NOT NULL DEFAULT 'N' COMMENT '전자결재연동여부';
ALTER TABLE `z_duzonitgroup_visitors_m` ADD COLUMN IF NOT EXISTS `elet_appv_interface_key` varchar(256) NOT NULL DEFAULT '' COMMENT '전자결재인터페이스키';
ALTER TABLE `z_duzonitgroup_visitors_m` ADD COLUMN IF NOT EXISTS `elct_appv_doc_id` varchar(256) NOT NULL DEFAULT '' COMMENT '전자결재문서아이디';
ALTER TABLE `z_duzonitgroup_visitors_m` ADD COLUMN IF NOT EXISTS `elct_appv_doc_status` varchar(32) NOT NULL DEFAULT '' COMMENT '전자결재문서상태';
ALTER TABLE `z_duzonitgroup_visitors_m` ADD COLUMN IF NOT EXISTS `qr_data` varchar(512) NOT NULL DEFAULT '' COMMENT 'QR코드데이터';
ALTER TABLE `z_duzonitgroup_visitors_m` ADD COLUMN IF NOT EXISTS `qr_send_status_code` varchar(32) NOT NULL DEFAULT '' COMMENT 'QR발송상태코드';
ALTER TABLE `z_duzonitgroup_visitors_m` ADD COLUMN IF NOT EXISTS `qr_send_date` datetime DEFAULT NULL COMMENT 'QR발송일시';
ALTER TABLE t_fx_fax ADD COLUMN IF NOT EXISTS mms_calback_no varchar(32) NULL COMMENT 'MMS전송 발신번호';

ALTER TABLE `oneffice_document`
	COLLATE='utf8mb4_general_ci';

ALTER TABLE `oneffice_document`
	CHANGE COLUMN `content` `content` MEDIUMTEXT NULL;
*/
-- 소스시퀀스 10210


/* v 1.2.107 (Bizbox Alpha V1.2.107 2차 소스 취합)
[원피스]
 - 원피스 공통댓글 알림옵션 추가
 - 원피스 편집권한 요청오류 수정 

CREATE TABLE if NOT exists `oneffice_access_manager` (
  `doc_no` varchar(32) NOT NULL,
  `editor_id` varchar(32) NOT NULL,
  `editor_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `request_id` varchar(32) DEFAULT NULL,
  `request_time` varchar(32) DEFAULT NULL,
  `response_answer` char(1) DEFAULT NULL,
  PRIMARY KEY (`doc_no`)
) ENGINE=InnoDB DEFAULT CHARSET=UTF8;


INSERT IGNORE INTO `t_co_event_message` (`type`, `code`, `lang_code`, `message_no_preview`, `param_no_preview`, `message_title_push`, `param_title_push`, `message_push`, `param_push`, `message_talk`, `param_talk`, `message_sms`, `param_sms`, `message_mail`, `param_mail`, `message_portal`, `param_portal`, `message_title_talk`, `param_title_talk`, `message_title_sms`, `param_title_sms`, `message_title_mail`, `param_title_mail`, `message_title_portal`, `param_title_portal`) VALUES ('ONEFFICE', 'ONE001', 'cn', '', '', '[원피스댓글] %s', 'user_nm', '%s', 'noti_msg', '%s', 'noti_msg', '%s', 'noti_msg', '%s', 'noti_msg', '%s', 'noti_msg', '[원피스댓글] %s', 'user_nm', '[원피스댓글] %s', 'user_nm', '[원피스댓글] %s', 'user_nm', '[원피스댓글] %s', 'user_nm');
INSERT IGNORE INTO `t_co_event_message` (`type`, `code`, `lang_code`, `message_no_preview`, `param_no_preview`, `message_title_push`, `param_title_push`, `message_push`, `param_push`, `message_talk`, `param_talk`, `message_sms`, `param_sms`, `message_mail`, `param_mail`, `message_portal`, `param_portal`, `message_title_talk`, `param_title_talk`, `message_title_sms`, `param_title_sms`, `message_title_mail`, `param_title_mail`, `message_title_portal`, `param_title_portal`) VALUES ('ONEFFICE', 'ONE001', 'en', '', '', '[원피스댓글] %s', 'user_nm', '%s', 'noti_msg', '%s', 'noti_msg', '%s', 'noti_msg', '%s', 'noti_msg', '%s', 'noti_msg', '[원피스댓글] %s', 'user_nm', '[원피스댓글] %s', 'user_nm', '[원피스댓글] %s', 'user_nm', '[원피스댓글] %s', 'user_nm');
INSERT IGNORE INTO `t_co_event_message` (`type`, `code`, `lang_code`, `message_no_preview`, `param_no_preview`, `message_title_push`, `param_title_push`, `message_push`, `param_push`, `message_talk`, `param_talk`, `message_sms`, `param_sms`, `message_mail`, `param_mail`, `message_portal`, `param_portal`, `message_title_talk`, `param_title_talk`, `message_title_sms`, `param_title_sms`, `message_title_mail`, `param_title_mail`, `message_title_portal`, `param_title_portal`) VALUES ('ONEFFICE', 'ONE001', 'jp', '', '', '[원피스댓글] %s', 'user_nm', '%s', 'noti_msg', '%s', 'noti_msg', '%s', 'noti_msg', '%s', 'noti_msg', '%s', 'noti_msg', '[원피스댓글] %s', 'user_nm', '[원피스댓글] %s', 'user_nm', '[원피스댓글] %s', 'user_nm', '[원피스댓글] %s', 'user_nm');
INSERT IGNORE INTO `t_co_event_message` (`type`, `code`, `lang_code`, `message_no_preview`, `param_no_preview`, `message_title_push`, `param_title_push`, `message_push`, `param_push`, `message_talk`, `param_talk`, `message_sms`, `param_sms`, `message_mail`, `param_mail`, `message_portal`, `param_portal`, `message_title_talk`, `param_title_talk`, `message_title_sms`, `param_title_sms`, `message_title_mail`, `param_title_mail`, `message_title_portal`, `param_title_portal`) VALUES ('ONEFFICE', 'ONE001', 'kr', '', '', '[원피스댓글] %s', 'user_nm', '%s', 'noti_msg', '%s', 'noti_msg', '%s', 'noti_msg', '%s', 'noti_msg', '%s', 'noti_msg', '[원피스댓글] %s', 'user_nm', '[원피스댓글] %s', 'user_nm', '[원피스댓글] %s', 'user_nm', '[원피스댓글] %s', 'user_nm');
INSERT IGNORE INTO `t_co_event_setting` (`type`, `code`, `portal_yn`, `timeline_yn`, `datas`, `seq`, `sub_seq`, `content_type`, `view_type`, `web_view_type`, `messenger_view_type`, `action_type`, `web_action_type`) VALUES ('ONEFFICE', 'ONE001', 'Y', 'N', 'doc_url', 'doc_url', '', '3', 'A', 'A', 'A', 'A', 'A');
INSERT IGNORE INTO `t_alert_setting` (`comp_seq`, `group_seq`, `alert_type`, `alert_yn`, `push_yn`, `talk_yn`, `mail_yn`, `sms_yn`, `portal_yn`, `timeline_yn`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`, `divide_type`, `link_event`) VALUES ('SYSTEM', 'SYSTEM', 'ONE001', 'Y', 'Y', 'Y', 'Y', 'N', 'Y', 'B', 'Y', '0', '2019-10-21 16:33:33', '0', '2019-10-21 16:33:33', 'CM', NULL);
INSERT IGNORE INTO t_alert_admin(comp_seq, group_seq, alert_type, alert_yn, push_yn, talk_yn, mail_yn, sms_yn, portal_yn, timeline_yn, use_yn, create_seq, create_date, modify_seq, modify_date, divide_type, link_event)
SELECT comp_seq, group_seq, 'ONE001',  'Y', 'Y', 'N', 'Y', 'B', 'Y', 'B', 'Y', '0', now(), '0', now(), 'CM', NULL 
FROM t_co_comp WHERE use_yn = 'Y';

INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('ONEFFICE', 'ALARAM', 'kr', 'ONEFFICE', 'ONEFFICE', 'Y', NULL, NULL, NULL, NULL);

*/
-- 소스시퀀스 10324



/* v 1.2.108

 [ERP조직도연동]
  - erp 신규 등록부서 연동항목 누락 오류 수정 
 [업무보고]
  - 원피스 업무보고 등록버튼 메뉴 권한에따라 노출/미노출 되도록 수정  
  - 원피스 업무보고(모바일) 특수문자 인코딩 오류 수정
 [부서경로프로시저 수정]
  - 1level 부서 사업장명 표시 누락 수정
 [로그인 사용 내역]
  - Custom property BizboxA.ProxyAddYn 값에 따른 L4 / Proxy 대응 로직 추가
  - HTTP_CLIENT_IP / HTTP_X_FORWARDED_FOR / X-Real-IP
 [포털]
  - path_name -> 부서 Seq 정렬로 인한 정렬 오류 수정 
 [마이페이지]
  - 취소 버튼 다국어 처리 반영
 [공통옵션설정 비밀번호 만료기한 수정]
  - 비밀번호 만료 시간체크 일단위 수정
 [결재양식 포틀릿 수정]
  - 결재양식 포틀릿 팝업 사이즈 오류 수정
*/

/*
DELIMITER $$

DROP PROCEDURE IF EXISTS `p_baseDateSet`$$

CREATE DEFINER=`root`@`%` PROCEDURE `p_baseDateSet`(
	IN `compSeq` VARCHAR(50),
	IN `groupSeq` VARCHAR(50),
	IN `empSeq` VARCHAR(50)
)
    COMMENT '회사 신규 추가시 기초데이터 셋팅 프로시저.'
BEGIN
	DECLARE userAuthCode VARCHAR(50);
	DECLARE adminAuthCode VARCHAR(50);
	
	
	SET userAuthCode= (SELECT CONCAT('A',nextval('authorCode')));
	SET adminAuthCode= (SELECT CONCAT('B',nextval('authorCode')));	
	
	
	INSERT IGNORE INTO t_co_authcode (author_code, author_type, author_base_yn, author_use_yn, group_seq, comp_seq, create_seq, create_date, modify_seq, modify_date, order_num, dept_seq) VALUES (userAuthCode, '001', 'Y', 'Y', groupSeq, compSeq, empSeq, NOW(), NULL, NULL, NULL, NULL);
	INSERT IGNORE INTO t_co_authcode (author_code, author_type, author_base_yn, author_use_yn, group_seq, comp_seq, create_seq, create_date, modify_seq, modify_date, order_num, dept_seq) VALUES (adminAuthCode, '005', 'N', 'Y', groupSeq, compSeq, empSeq, NOW(), NULL, NULL, NULL, NULL);
	INSERT IGNORE INTO t_co_authcode_multi (author_code, lang_code, author_nm, author_dc, create_seq, create_date, modify_seq, modify_date) VALUES (userAuthCode, 'kr', '일반사용자권한', '', NOW(), empSeq, NULL, NULL);
	INSERT IGNORE INTO t_co_authcode_multi (author_code, lang_code, author_nm, author_dc, create_seq, create_date, modify_seq, modify_date) VALUES (adminAuthCode, 'kr', '회사관리자', '', NOW(), empSeq, NULL, NULL);
	
	
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('1000000000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('100000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('1001000000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('1001010000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('1001020000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('1001030000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('1002020000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('1003000000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('1003010000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('101000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('101010000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('101020000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('101030000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('101040000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('101050000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('101060000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('102000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('102010000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('102020000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('102030000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('102040000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('103000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('103010000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('103010100' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('103010200' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('103010300' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('103020000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('103020100' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('103020200' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('103020300' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('103020400' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('103030000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('103030100' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('103030200' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('103030300' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('104000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('104010000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('104010100' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('104010200' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('104010300' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('104020000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('104030000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('104040000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('104050000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('104060000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('104060100' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('104060200' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('104060300' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('104060400' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('104070000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('104070100' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('104070200' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('104080000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('200000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('2000000000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('2001000000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('2001010000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('2001020000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('2001030000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('2002000000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('2002010000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('2002020000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('2002050000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('2002060000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('2002070000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('2002080000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('2002090000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('2002100000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('2002110000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('2002120000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('2002130000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('2004000000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('2004010000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('2004020000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('2004030000', userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('300000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('301000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('301030000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('301040000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('301050000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('301060000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('301060100' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('302000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('302010000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('302020000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('302030000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('303000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('303010000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('304000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('304010000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('304020000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('304030000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('304040000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('390000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('400000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('401000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('401010000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('500000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('501000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('501030000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('502000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('502010000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('504000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('504010000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('504020000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('504030000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('555'		 , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('600000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('601000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('601010000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('601030000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('601040000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('601050000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('603000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('603040000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('700000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('701000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('701010000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('701020000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('701030000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('800000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('803000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('803010000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('805000000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('805010000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('805020000' , userAuthCode);
	INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES('805030000' , userAuthCode);
	
	
	

  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('0'		 ,adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('200000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('300000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('301000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('301020000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('302000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('302010000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('302020000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('302030000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('302040000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('302050000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('302060000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('302070000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('303000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('303010000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('400000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('401000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('401020000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('401040000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('402000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('402010000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('500000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('501000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('501005000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('501006000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('501007000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('501011000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('502000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('502001000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('502002000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('502003000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('502004000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('503000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('503001000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('504000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('504001000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('504002000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('504003000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('504004000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('504005000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('504006000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('505000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('505001000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('505002000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('505003000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('506000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('600000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('601000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('601001000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('601002000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('601003000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('601004000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('602000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('602001000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('603000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('603001000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('603002000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('603003000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('603004000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('603005000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('604000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('604001000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('605001000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('605002000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('700000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('701000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('701010000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('701020000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('701030000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('701040000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('701060000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('702000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('702010000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('702020000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('702040000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('702050000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('703000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('703010000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('703020000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('704000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('704010000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('705000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('705010000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('705020000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('705030000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('706000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('706010000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('706020000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('800000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('801000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('801010000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('801020000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('810000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('810100000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('810101000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('900000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('901000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('901020000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('901030000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('901040000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('902000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('902010000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('902020000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('903000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('903020000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('903030000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('905000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('905010000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('905020000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('905030000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('905040000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('907000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('908000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('908010000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('909000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('909010000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('910000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('911000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('911010000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('912000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('912000001',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('920000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('920100000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('920100100',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('920100200',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('920100300',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('930000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('931000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('931010000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('931010010',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('931010020',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('931010030',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('931010040',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('931020000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('931020010',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('931020030',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('931020040',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('931020060',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('931020070',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('931020090',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('931020100',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('931020130',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('931020140',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('931040000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('960000000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('960100000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('960101000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('960102000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('960103000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('960104000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('960105000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('960207000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('960300000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('960301000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('960302000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('960303000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('960304000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('960305000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('960306000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('960307000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('960308000',adminAuthCode);
  INSERT IGNORE INTO t_co_menu_auth (menu_no, author_code) VALUES ('960309000',adminAuthCode);

  	
  INSERT IGNORE INTO teag_form_auth (org_div, org_id, form_id, created_dt, created_by, modify_dt, modify_by)
  SELECT 'c', compSeq, form_id, NOW(), 'SYSTEM', NOW(), 'SYSTEM' FROM teag_form WHERE co_id = '0' AND use_yn = '1';

  INSERT IGNORE INTO teag_form_docauth (form_id, org_div, org_id, co_id, created_by, created_dt, modify_by, modify_dt) 
  SELECT form_id, 'm', 1, compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW() FROM teag_form WHERE co_id = '0' AND use_yn = '1';
  	
  INSERT IGNORE INTO teag_numberingpublic (numbering_id, public_gb, org_div, org_id, created_by, created_dt, modify_by, modify_dt) VALUES
  		('1001', '20', 'C', compSeq, 'SYSTEM', NOW(), 'SYSTEM', NOW());	
  		
  INSERT IGNORE INTO t_at_commute_set(comp_seq, group_seq, type_code, coverage_web, coverage_messenger, coverage_mobile, apply_date, start_date, end_date, status_yn, use_yn, create_seq, modify_seq) VALUES
  	(compSeq, groupSeq, 'B', 'Y', 'Y', 'N', '20190101', '20190101', '', 'N', 'Y', 'SYSTEM', 'SYSTEM');

  INSERT IGNORE INTO t_at_commute_set_basic(commute_set_sqno, comp_seq, group_seq, type_code, apply_item_code, apply_div_code, apply_div_name, use_yn, create_seq, create_dt, modify_seq, modify_dt)
  	SELECT commute_set_sqno, comp_seq, group_seq, type_code, '0', '0', '기본', 'Y', create_seq, create_dt, modify_seq, modify_dt FROM t_at_commute_set WHERE comp_seq = compSeq;


END$$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `get_dept_pathNm`$$

CREATE DEFINER=`root`@`%` FUNCTION `get_dept_pathNm`(
	`_delimiter` TEXT,
	`_dept_seq` VARCHAR(32),
	`_group_seq` VARCHAR(32),
	`_lang_code` VARCHAR(32)
) RETURNS TEXT CHARSET utf8
    READS SQL DATA
BEGIN
    DECLARE _path TEXT;
    DECLARE _id VARCHAR(32);
    DECLARE _nm VARCHAR(32);
    DECLARE _start_with VARCHAR(32);
    DECLARE EXIT HANDLER FOR NOT FOUND RETURN _path;
    
    SET _start_with = '0';
    SET _id = COALESCE(_dept_seq, _start_with);
    SELECT CASE WHEN t2.parent_dept_seq = '0' AND t3.display_yn = 'Y' THEN CONCAT(FN_GetMultiLang(_lang_code, t4.biz_name_multi),'|',FN_GetMultiLang(_lang_code, t1.dept_name_multi)) ELSE FN_GetMultiLang(_lang_code, dept_name_multi) END INTO _nm  FROM v_t_co_dept_multi t1 JOIN t_co_dept t2 ON t1.dept_seq = t2.dept_seq JOIN t_co_biz t3 ON t1.biz_seq = t3.biz_seq JOIN v_t_co_biz_multi t4 ON t1.biz_seq = t4.biz_Seq WHERE t1.dept_Seq = _dept_seq AND t1.group_seq = _group_seq;
    SET _path = _nm;
    LOOP
        SELECT  a.parent_dept_seq, CASE WHEN c.parent_dept_seq = '0' AND d.display_yn = 'Y' THEN CONCAT((SELECT FN_GetMultiLang(_lang_code, biz_name_multi) FROM v_t_co_biz_multi WHERE biz_seq = d.biz_seq LIMIT 1), _delimiter, FN_GetMultiLang(_lang_code, b.dept_name_multi)) ELSE FN_GetMultiLang(_lang_code, b.dept_name_multi) END
        INTO    _id, _nm
        FROM    t_co_dept a, v_t_co_dept_multi b, t_co_dept c, t_co_biz d
        WHERE   a.group_seq = _group_seq
        AND a.group_seq = b.group_seq
        AND a.parent_dept_seq = b.dept_seq
        AND b.dept_seq = c.dept_seq
        AND c.biz_seq = d.biz_seq
        AND a.dept_seq = _id
        AND COALESCE(a.parent_dept_seq <> _start_with, TRUE)
        AND COALESCE(a.parent_dept_seq <> _dept_seq, TRUE);
        SET _path = CONCAT(_nm, _delimiter, _path);
    END LOOP;
END$$

DELIMITER ;

UPDATE t_co_dept_multi SET path_name = get_dept_pathNm('|', dept_seq, group_seq, lang_code);

*/

-- 소스시퀀스 10414




/* v 1.2.109

 [공통옵션]
  - MAC OS 메신저 설치파일 다운로드 버튼 추가
  - 비밀번호 만료기한 옵션 개선
*/

/*
UPDATE tcmg_optionset SET option_desc = '비밀번호 만료기한을 설정할 수 있습니다.\r\n매 월 지정 일 또는 선택 기간에 따라 비밀번호를 변경하도록 제공하는 기능입니다.\r\n\r\n- 매 월 : 매월 특정일에 모든 사용자의 비밀번호를 일괄 변경 하도록 만료 일 후 사용자가 비밀번호 변경 후 로그인이 가능합니다. (0일/ 1일/3일/7일 전 안내 팝업을 설정 할 수 있습니다)\r\n\r\n- 선택 기간 : 사용자별 비밀번호를 변경한 날짜를 기준으로 N일(설정일)이 지난 시점에 만료되어 변경하도록 제공됩니다. (비밀번호 변경 후 N일 이후 안내 만료 안내 팝업을 설정 할 수 있습니다.)\r\n\r\n* 안내 팝업의 설정일이 ‘0’ 값인 경우 안내팝업이 제공되지 않습니다.' WHERE option_id = 'cm201';

INSERT IGNORE INTO `t_co_code_detail` (`detail_code`, `code`, `ischild`, `order_num`, `flag_1`, `flag_2`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) 
VALUES ('0', 'option0211', 'N', 0, NULL, NULL, 'Y', NULL, NULL, NULL, NULL);

INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) 
VALUES ('0', 'option0211', 'kr', '미사용', NULL, 'Y', NULL, NULL, NULL, NULL);

UPDATE t_co_code_detail SET order_num = '1' WHERE detail_code = 'm' AND CODE = 'option0211';
UPDATE t_co_code_detail SET order_num = '2' WHERE detail_code = 'd' AND CODE = 'option0211';
*/

-- 소스시퀀스 10474

/*
[원피스]
 - 원피스 최근 문서 관리 DB 추가
[공통]
 - 브라우저 팝업차단 안내메시지 추가 (openWindow2 함수)
 - 비밀번호변경팝업 스낵바함수 오류수정
[시스템설정]
 - 접근가능IP설정 수정
 - OrgAdapter 회사 삭제, 부서 삭제, 사용자 수정/삭제 접근가능IP 설정 로직 추가
[통합검색]
 - 첨부파일>문서 미리보기 관련 문구 수정
[포털]
 - 날씨 포틀릿 중복 셋팅 오류수정
 [메신저]
  - 메신저 일반대화방 문서링크 오류 수정
*/


/* v 1.2.109

ALTER TABLE t_co_group ADD COLUMN IF NOT EXISTS master_passwd_exp_dt DATETIME COMMENT '마스터패스워드 만료일시' AFTER master_passwd;

ALTER TABLE `z_duzonitgroup_visitors_req` ADD COLUMN IF NOT EXISTS `man_tel_num` varchar(32) DEFAULT NULL COMMENT '';
ALTER TABLE `z_duzonitgroup_visitors_m` ADD COLUMN IF NOT EXISTS `man_tel_num` varchar(32) DEFAULT NULL COMMENT '';
alter table z_duzonitgroup_visitors_m modify visit_pticket_yn varchar(32);


CREATE TABLE `oneffice_recent_document` (
  `seq` bigint(11) NOT NULL AUTO_INCREMENT,
  `doc_no` varchar(32) NOT NULL,
  `user_id` varchar(32) NOT NULL,
  `owner_id` varchar(32) DEFAULT NULL,
  `owner_name` varchar(16) DEFAULT NULL COMMENT '소유자명',
  `read_date` datetime DEFAULT NULL,
  `share_date` datetime DEFAULT NULL,
  PRIMARY KEY (`seq`,`doc_no`,`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

UPDATE t_co_timeline_menu SET lnb_menu_no = '601010000' WHERE event_sub_type IN ('ED001','ED005','ED006','ED007','ED008','ED009','ED010');
*/

-- 소스시퀀스 10525

/* v 1.2.110 
 [포털]
 - 비영리 클라우드 결재함 포틀릿 조회 오류 수정
 - 주소록 그룹등록 관리자/마스터 권한에 따른 조회 범위 수정
 [시스템 설정]
 - 마스터 권한 삭제 오류 수정
 - 사업장 / 부서 seq 중복 시 관련 없는 데이터 리스트 노출 오류
 [마이페이지]
 - 주소록 페이지 접근 시 부서 권한 체크 오류 수정
 [통합검색]
 - IE 브라우저 인코딩 대응
 [ONEFFICE]
 - V3.0.3.6
 [웹에디터]
 - 더존 웹에디터 v1.1.6.6 
 */

/*
ALTER TABLE t_co_group ADD COLUMN IF NOT EXISTS tmap_server varchar(100) DEFAULT NULL COMMENT 't-map 서버';
ALTER TABLE t_co_group ADD COLUMN IF NOT EXISTS tmap_token  varchar(100) DEFAULT NULL COMMENT 't-map 인증토큰';
*/
-- 소스시퀀스 10702


/* v 1.2.111
 [공통]
 - 로그인,메일 ID관련 컬럼 길이수정 32->64 (DERP연동 사용자 삭제 이슈사항)
 [포털]
 - 포털 B타입 관리자/마스터 전환 버튼 조건 => 메인부서 삭제
 - 사용자 / 관리자 / 마스터 화면 좌측 프로필 영역 부서 표기 오류 수정
 - 날씨 포틀릿 API(당기예보조회) 변경
 - 결재함 포틀릿 긴급 결재건 아이콘 노출
 [통합검색]
 - 역슬러쉬(\) 검색 시 누락되는 에러 수정
 [주소록]
 - 메일 쓰기 시 주소록 그룹 사용 여부에 따른 리스트 표기 되도록 수정
 [시스템 설정]
 - 퇴사 처리 시 대결자 설정 기선택 오류 수정
 - 사원부서연결의 겸직 사용자 대화방/쪽지 조직도 표시 설정에 따른 컨펌 안내창 추가
 - 메뉴정보관리-관리자의 메뉴 사용여부에 따라 권한관리에서 메뉴트리 조회
 - OrgAdapter-empResignProcFinish 사원 퇴사시 주부서 재설정 로직 수정
 */



/*
ALTER TABLE `t_co_emp_history`
	CHANGE COLUMN IF EXISTS `login_id` `login_id` VARCHAR(128) NULL DEFAULT NULL COMMENT '로그인아이디' AFTER `group_seq`,
	CHANGE COLUMN IF EXISTS `email_addr` `email_addr` VARCHAR(128) NULL DEFAULT NULL COMMENT '이메일아이디' AFTER `erp_emp_num`;

ALTER TABLE `t_co_emp`
	CHANGE COLUMN IF EXISTS `login_id` `login_id` VARCHAR(128) NULL DEFAULT NULL AFTER `group_seq`,
	CHANGE COLUMN IF EXISTS `email_addr` `email_addr` VARCHAR(128) NULL DEFAULT NULL COMMENT '이메일아이디' AFTER `erp_emp_num`;

update tcmg_optionset set option_desc = replace(option_desc,'4','6'),option_desc_en = replace(option_desc_en,'4','6'),option_desc_jp = replace(option_desc_jp,'4','6'),option_desc_cn = replace(option_desc_cn,'4','6') where option_id='cm202';


DELIMITER $$
DROP FUNCTION IF EXISTS FN_GetMultiName$$
CREATE FUNCTION `FN_GetMultiName`(
	`langCode` VARCHAR(2),
	`orgDiv` VARCHAR(10),
	`seq` VARCHAR(32)

) RETURNS varchar(128) CHARSET utf8
BEGIN
    DECLARE nRetVal VARCHAR(128) DEFAULT '';
    
    IF langCode = '' THEN
       SET langCode = 'kr';
    END IF;
    
    IF orgDiv = 'EMP' THEN
    	SELECT ifnull(multi.emp_name, kr.emp_name) INTO nRetVal
		FROM t_co_emp_multi kr
		left join t_co_emp_multi multi on kr.emp_seq=multi.emp_seq and multi.lang_code=langCode
    	WHERE kr.emp_seq=seq AND kr.lang_code='kr';
    ELSEIF orgDiv = 'DEPT' THEN
      SELECT ifnull(multi.dept_name, kr.dept_name) INTO nRetVal 
		FROM t_co_dept_multi kr
		left join t_co_dept_multi multi on kr.dept_seq=multi.dept_seq and multi.lang_code=langCode
    	WHERE kr.dept_seq=seq AND kr.lang_code='kr';     
    ELSEIF orgDiv = 'DEPT_PATH' THEN
      SELECT ifnull(multi.path_name, kr.path_name) INTO nRetVal 
		FROM t_co_dept_multi kr
		left join t_co_dept_multi multi on kr.dept_seq=multi.dept_seq and multi.lang_code=langCode
    	WHERE kr.dept_seq=seq AND kr.lang_code='kr';         
    ELSEIF orgDiv = 'COMP' THEN
      SELECT ifnull(multi.comp_name, kr.comp_name) INTO nRetVal 
		FROM t_co_comp_multi kr
		left join t_co_comp_multi multi on kr.comp_seq=multi.comp_seq AND multi.lang_code=langCode
    	WHERE kr.comp_seq=seq AND kr.lang_code='kr';
    ELSEIF orgDiv = 'BIZ' THEN
      SELECT ifnull(multi.biz_name, kr.biz_name) INTO nRetVal 
		FROM t_co_biz_multi kr
      left join t_co_biz_multi multi on kr.biz_seq=multi.biz_seq AND multi.lang_code=langCode
    	WHERE kr.biz_seq=seq AND kr.lang_code='kr';
    ELSEIF orgDiv = 'POSITION' THEN
      SELECT ifnull(multi.dp_name, kr.dp_name) INTO nRetVal 
		FROM t_co_comp_duty_position_multi kr
		left join t_co_comp_duty_position_multi multi on kr.dp_type=multi.dp_type and kr.dp_seq=multi.dp_seq and multi.lang_code=langCode
    	WHERE kr.dp_type = 'POSITION' and binary(kr.dp_seq)=seq AND kr.lang_code='kr';
    ELSEIF orgDiv = 'DUTY' THEN
      SELECT ifnull(multi.dp_name, kr.dp_name) INTO nRetVal 
		FROM t_co_comp_duty_position_multi kr
		left join t_co_comp_duty_position_multi multi on kr.dp_type=multi.dp_type and kr.dp_seq=multi.dp_seq and multi.lang_code=langCode
    	WHERE kr.dp_type = 'DUTY' and binary(kr.dp_seq)=seq AND kr.lang_code='kr';          
    END IF;
    
    RETURN nRetVal;
    
END$$
DELIMITER ;
*/
-- 소스시퀀스 10873






/*
 * v 1.2.112 
 [공통]
 - DRM 암호화 문서 바로보기 시 서버 내 생성되는 복호화 임시파일 제거
 - 공통댓글에 이모티콘이 포한된 경우 등록 불가 개선  
 [방문객관리]
 - 저장 프로시저 수정 => nManCoSeq, nManUserSeq, nReqCoSeq, nReqUserSeq 타입 변경(INT -> VARCHAR(50))
 [시스템설정]
 - 회사관리 erp연결설정 g20 연동오류 수정
 - 모바일, PC 메신저 로그인시 관리자 or 마스터 권한만 있을 경우에도 로그인 될 수 있도록 권한 조회 수정 
 */
/*
CREATE TABLE IF NOT EXISTS `t_co_orgchart_name` (
  `org_sync_date` datetime DEFAULT NULL COMMENT '연동일자',
  `gbn_org` char(1) NOT NULL COMMENT '조직구분(c: 회사, b:사업장, d:부서)',
  `seq` varchar(32) NOT NULL COMMENT '조직도 seq',
  `parent_gbn` char(1) NOT NULL COMMENT '상위 조직구분(g: 그룹, c: 회사, b:사업장, d:부서)',
  `parent_seq` varchar(32) NOT NULL COMMENT '상위 seq',
  `level` decimal(10,0) NOT NULL COMMENT '부서레벨',
  `order_num` decimal(10,0) DEFAULT NULL COMMENT '정렬순서',
  `org_cd` varchar(32) NOT NULL COMMENT '사업장 표시여부',
  `inner_receive_yn` char(1) DEFAULT 'Y' COMMENT '대내수신여부(비영리용)',
  `ea_yn` char(1) DEFAULT 'N' COMMENT '결재전용부서여부',
  `org_use_yn` char(1) NOT NULL COMMENT 'org_div 구분에 따른 조직(회사/사업장/부서) 여부',
  `comp_seq` varchar(32) NOT NULL COMMENT '회사 seq',
  `biz_seq` varchar(32) DEFAULT '' COMMENT '사업장 seq',
  `biz_display_yn` char(1) DEFAULT '' COMMENT '사업장 표시여부',
  `dept_seq` varchar(32) DEFAULT '' COMMENT '부서 seq',
  `path` varchar(256) NOT NULL COMMENT '회사|사업장|부서 seq path	t_co_biz 테이블의 display_yn 상관없이 pull path seq',
  `display_path_name_kr` varchar(512) NOT NULL COMMENT '회사|사업장|부서 path명(KR)',
  `display_path_name_en` varchar(512) NOT NULL COMMENT '회사|사업장|부서 path명(EN)',
  `display_path_name_jp` varchar(512) NOT NULL COMMENT '회사|사업장|부서 path명(JP)',
  `display_path_name_cn` varchar(512) NOT NULL COMMENT '회사|사업장|부서 path명(CN)',
  `comp_name_kr` varchar(128) NOT NULL COMMENT '회사명(KR)',
  `comp_name_en` varchar(128) NOT NULL COMMENT '회사명(EN)',
  `comp_name_jp` varchar(128) NOT NULL COMMENT '회사명(JP)',
  `comp_name_cn` varchar(128) NOT NULL COMMENT '회사명(CN)',
  `biz_name_kr` varchar(128) DEFAULT '' COMMENT '사업장명(KR)',
  `biz_name_en` varchar(128) DEFAULT '' COMMENT '사업장명(EN)',
  `biz_name_jp` varchar(128) DEFAULT '' COMMENT '사업장명(JP)',
  `biz_name_cn` varchar(128) DEFAULT '' COMMENT '사업장명(CN)',
  `dept_name_kr` varchar(128) DEFAULT '' COMMENT '부서명(KR)',
  `dept_name_en` varchar(128) DEFAULT '' COMMENT '부서명(EN)',
  `dept_name_jp` varchar(128) DEFAULT '' COMMENT '부서명(JP)',
  `dept_name_cn` varchar(128) DEFAULT '' COMMENT '부서명(CN)',
  `comp_display_name` varchar(128) DEFAULT '' COMMENT '회사표시명',
  `comp_nickname` varchar(128) DEFAULT '' COMMENT '회사약칭',
  `biz_nickname` varchar(128) DEFAULT '' COMMENT '사업장약칭',
  `dept_display_name` varchar(128) DEFAULT '' COMMENT '부서표시명',
  `dept_nickname` varchar(128) DEFAULT '' COMMENT '부서약칭',
  PRIMARY KEY (`gbn_org`,`seq`),
  KEY `t_co_orgchart_name_fk_01` (`comp_seq`,`biz_seq`,`dept_seq`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='조직도 PATH NAME 테이블';

-- 테이블 초기화
delete from t_co_orgchart_name;

-- 회사정보 일괄저장
insert ignore into t_co_orgchart_name
(org_sync_date, gbn_org, seq, parent_gbn, parent_seq, level, order_num, org_cd, org_use_yn, comp_seq, path, display_path_name_kr, display_path_name_en, display_path_name_jp, display_path_name_cn, comp_name_kr, comp_name_en, comp_name_jp, comp_name_cn, comp_display_name, comp_nickname )
select NOW()
,'c'
,c.comp_seq
,'g'
,'0'
,1
,c.order_num
,c.comp_cd
,c.use_yn
,c.comp_seq
,c.comp_seq
,kr.comp_name
,case when ifnull(en.comp_name,'')='' then kr.comp_name else en.comp_name end
,case when ifnull(jp.comp_name,'')='' then kr.comp_name else jp.comp_name end
,case when ifnull(cn.comp_name,'')='' then kr.comp_name else cn.comp_name end
,kr.comp_name
,case when ifnull(en.comp_name,'')='' then kr.comp_name else en.comp_name end
,case when ifnull(jp.comp_name,'')='' then kr.comp_name else jp.comp_name end
,case when ifnull(cn.comp_name,'')='' then kr.comp_name else cn.comp_name end
,ifnull(kr.comp_display_name,'')
,ifnull(kr.comp_nickname,'')
from t_co_comp c
join t_co_comp_multi kr on kr.lang_code='kr' and c.comp_seq=kr.comp_seq
left join t_co_comp_multi en on en.lang_code='en' and c.comp_seq=en.comp_seq
left join t_co_comp_multi jp on jp.lang_code='jp' and c.comp_seq=jp.comp_seq
left join t_co_comp_multi cn on cn.lang_code='cn' and c.comp_seq=cn.comp_seq;

-- 사업장정보 일괄저장
insert ignore into t_co_orgchart_name
(org_sync_date, gbn_org, seq, parent_gbn, parent_seq, level, order_num, org_cd, org_use_yn, comp_seq, biz_seq, biz_display_yn, path, display_path_name_kr, display_path_name_en, display_path_name_jp, display_path_name_cn, comp_name_kr, comp_name_en, comp_name_jp, comp_name_cn, biz_name_kr, biz_name_en, biz_name_jp, biz_name_cn, comp_display_name, comp_nickname, biz_nickname)
select NOW()
,'b'
,b.biz_seq
,'c'
,b.comp_seq
,2
,b.order_num
,b.biz_cd
,b.use_yn
,b.comp_seq
,b.biz_seq
,b.display_yn
,concat(b.comp_seq,'|',b.biz_seq)
,concat(c_kr.comp_name,(case when b.display_yn = 'Y' then concat('|',b_kr.biz_name) else '' end))
,concat((case when ifnull(c_en.comp_name,'')='' then c_kr.comp_name else c_en.comp_name end),(case when b.display_yn = 'Y' then concat('|',(case when ifnull(b_en.biz_name,'')='' then b_kr.biz_name else b_en.biz_name end)) else '' end))
,concat((case when ifnull(c_jp.comp_name,'')='' then c_kr.comp_name else c_jp.comp_name end),(case when b.display_yn = 'Y' then concat('|',(case when ifnull(b_jp.biz_name,'')='' then b_kr.biz_name else b_jp.biz_name end)) else '' end))
,concat((case when ifnull(c_cn.comp_name,'')='' then c_kr.comp_name else c_cn.comp_name end),(case when b.display_yn = 'Y' then concat('|',(case when ifnull(b_cn.biz_name,'')='' then b_kr.biz_name else b_cn.biz_name end)) else '' end))
,c_kr.comp_name
,case when ifnull(c_en.comp_name,'')='' then c_kr.comp_name else c_en.comp_name end
,case when ifnull(c_jp.comp_name,'')='' then c_kr.comp_name else c_jp.comp_name end
,case when ifnull(c_cn.comp_name,'')='' then c_kr.comp_name else c_cn.comp_name end
,b_kr.biz_name
,case when ifnull(b_en.biz_name,'')='' then b_kr.biz_name else b_en.biz_name end
,case when ifnull(b_jp.biz_name,'')='' then b_kr.biz_name else b_jp.biz_name end
,case when ifnull(b_cn.biz_name,'')='' then b_kr.biz_name else b_cn.biz_name end
,ifnull(c_kr.comp_display_name,'')
,ifnull(c_kr.comp_nickname,'')
,ifnull(b_kr.biz_nickname,'')
from t_co_biz b
join t_co_biz_multi b_kr on b_kr.lang_code='kr' and b.biz_seq=b_kr.biz_seq
left join t_co_biz_multi b_en on b_en.lang_code='en' and b.biz_seq=b_en.biz_seq
left join t_co_biz_multi b_jp on b_jp.lang_code='jp' and b.biz_seq=b_jp.biz_seq
left join t_co_biz_multi b_cn on b_cn.lang_code='cn' and b.biz_seq=b_cn.biz_seq
join t_co_comp_multi c_kr on c_kr.lang_code='kr' and b.comp_seq=c_kr.comp_seq
left join t_co_comp_multi c_en on c_en.lang_code='en' and b.comp_seq=c_en.comp_seq
left join t_co_comp_multi c_jp on c_jp.lang_code='jp' and b.comp_seq=c_jp.comp_seq
left join t_co_comp_multi c_cn on c_cn.lang_code='cn' and b.comp_seq=c_cn.comp_seq;

-- 부서정보 일괄저장
insert ignore into t_co_orgchart_name
(org_sync_date, gbn_org, seq, parent_gbn, parent_seq, level, order_num, org_cd, org_use_yn, comp_seq, biz_seq, biz_display_yn, dept_seq, path, display_path_name_kr, display_path_name_en, display_path_name_jp, display_path_name_cn, comp_name_kr, comp_name_en, comp_name_jp, comp_name_cn, biz_name_kr, biz_name_en, biz_name_jp, biz_name_cn, dept_name_kr, dept_name_en, dept_name_jp, dept_name_cn, comp_display_name, comp_nickname, biz_nickname, dept_display_name, dept_nickname)
select NOW()
,'d'
,d.dept_seq
,case when d.parent_dept_seq != '0' then 'd' when b.display_yn = 'Y' then 'b' else 'c' end
,case when d.parent_dept_seq != '0' then d.parent_dept_seq when b.display_yn = 'Y' then d.biz_seq else d.comp_seq end
,case when b.display_yn = 'Y' then d.dept_level + 2 else d.dept_level + 1 end
,d.order_num
,d.dept_cd
,d.use_yn
,d.comp_seq
,d.biz_seq
,b.display_yn
,d.dept_seq
,concat(d.comp_seq,'|',(case when b.display_yn = 'Y' then concat(d.biz_seq,'|') else '' end),d.path)
,concat(c_kr.comp_name,get_dept_pathNm('|',d.dept_seq,d.group_seq,'kr'))
,concat(case when ifnull(c_en.comp_name,'')='' then c_kr.comp_name else c_en.comp_name end,get_dept_pathNm('|',d.dept_seq,d.group_seq,'en'))
,concat(case when ifnull(c_jp.comp_name,'')='' then c_kr.comp_name else c_jp.comp_name end,get_dept_pathNm('|',d.dept_seq,d.group_seq,'jp'))
,concat(case when ifnull(c_cn.comp_name,'')='' then c_kr.comp_name else c_cn.comp_name end,get_dept_pathNm('|',d.dept_seq,d.group_seq,'cn'))
,c_kr.comp_name
,case when ifnull(c_en.comp_name,'')='' then c_kr.comp_name else c_en.comp_name end
,case when ifnull(c_jp.comp_name,'')='' then c_kr.comp_name else c_jp.comp_name end
,case when ifnull(c_cn.comp_name,'')='' then c_kr.comp_name else c_cn.comp_name end
,b_kr.biz_name
,case when ifnull(b_en.biz_name,'')='' then b_kr.biz_name else b_en.biz_name end
,case when ifnull(b_jp.biz_name,'')='' then b_kr.biz_name else b_jp.biz_name end
,case when ifnull(b_cn.biz_name,'')='' then b_kr.biz_name else b_cn.biz_name end
,d_kr.dept_name
,case when ifnull(d_en.dept_name,'')='' then d_kr.dept_name else d_en.dept_name end
,case when ifnull(d_jp.dept_name,'')='' then d_kr.dept_name else d_jp.dept_name end
,case when ifnull(d_cn.dept_name,'')='' then d_kr.dept_name else d_cn.dept_name end
,ifnull(c_kr.comp_display_name,'')
,ifnull(c_kr.comp_nickname,'')
,ifnull(b_kr.biz_nickname,'')
,ifnull(d_kr.dept_display_name,'')
,ifnull(d_kr.dept_nickname,'')
from t_co_dept d
join t_co_biz b on d.biz_seq = b.biz_seq
join t_co_dept_multi d_kr on d_kr.lang_code='kr' and d.dept_seq=d_kr.dept_seq
left join t_co_dept_multi d_en on d_en.lang_code='en' and d.dept_seq=d_en.dept_seq
left join t_co_dept_multi d_jp on d_jp.lang_code='jp' and d.dept_seq=d_jp.dept_seq
left join t_co_dept_multi d_cn on d_cn.lang_code='cn' and d.dept_seq=d_cn.dept_seq
join t_co_biz_multi b_kr on b_kr.lang_code='kr' and d.biz_seq=b_kr.biz_seq
left join t_co_biz_multi b_en on b_en.lang_code='en' and d.biz_seq=b_en.biz_seq
left join t_co_biz_multi b_jp on b_jp.lang_code='jp' and d.biz_seq=b_jp.biz_seq
left join t_co_biz_multi b_cn on b_cn.lang_code='cn' and d.biz_seq=b_cn.biz_seq
join t_co_comp_multi c_kr on c_kr.lang_code='kr' and d.comp_seq=c_kr.comp_seq
left join t_co_comp_multi c_en on c_en.lang_code='en' and d.comp_seq=c_en.comp_seq
left join t_co_comp_multi c_jp on c_jp.lang_code='jp' and d.comp_seq=c_jp.comp_seq
left join t_co_comp_multi c_cn on c_cn.lang_code='cn' and d.comp_seq=c_cn.comp_seq;



DELIMITER $$
DROP TRIGGER IF EXISTS `TRG_T_CO_COMP_MULTI_AI`$$
CREATE TRIGGER `TRG_T_CO_COMP_MULTI_AI` AFTER INSERT ON t_co_comp_multi FOR EACH ROW
BEGIN
    INSERT INTO t_co_comp_multi_history (
		op_code,
		reg_date,
		group_seq,
		comp_seq,
		lang_code,
		comp_name,
		comp_display_name,
		owner_name,
		sender_name,
		biz_condition,
		item,
		addr,
		detail_addr,
		use_yn,
		create_seq,
		create_date,
		modify_seq,
		modify_date,
		comp_nickname
    )
    VALUES (
        'I',
        NOW(),
		NEW.group_seq,
		NEW.comp_seq,
		NEW.lang_code,
		NEW.comp_name,
		NEW.comp_display_name,
		NEW.owner_name,
		NEW.sender_name,
		NEW.biz_condition,
		NEW.item,
		NEW.addr,
		NEW.detail_addr,
		NEW.use_yn,
		NEW.create_seq,
		NEW.create_date,
		NEW.modify_seq,
		NEW.modify_date,
		NEW.comp_nickname
    );
    
    UPDATE 
        t_co_orgchart
    SET
        task_status = CASE 
                        WHEN    task_status = '0' THEN '1'  
                        WHEN    task_status = '2' THEN '3'  
                        ELSE    task_status END             
        , update_status = CASE
			WHEN   update_status < '99' THEN '99' 
			ELSE   update_status END
    WHERE 
        group_seq = NEW.group_seq;
    
    -- 조직도 패스테이블 적용
    IF NEW.lang_code = 'kr' THEN
      
      delete from t_co_orgchart_name where gbn_org = 'c' and comp_seq = NEW.comp_seq;
      
      insert ignore into t_co_orgchart_name
      (org_sync_date, gbn_org, seq, parent_gbn, parent_seq, level, order_num, org_cd, org_use_yn, comp_seq, path, display_path_name_kr, display_path_name_en, display_path_name_jp, display_path_name_cn, comp_name_kr, comp_name_en, comp_name_jp, comp_name_cn, comp_display_name, comp_nickname )
      select NOW()
      ,'c'
      ,c.comp_seq
      ,'g'
      ,'0'
      ,1
      ,c.order_num
      ,c.comp_cd
      ,c.use_yn
      ,c.comp_seq
      ,c.comp_seq
      ,kr.comp_name
      ,case when ifnull(en.comp_name,'')='' then kr.comp_name else en.comp_name end
      ,case when ifnull(jp.comp_name,'')='' then kr.comp_name else jp.comp_name end
      ,case when ifnull(cn.comp_name,'')='' then kr.comp_name else cn.comp_name end
      ,kr.comp_name
      ,case when ifnull(en.comp_name,'')='' then kr.comp_name else en.comp_name end
      ,case when ifnull(jp.comp_name,'')='' then kr.comp_name else jp.comp_name end
      ,case when ifnull(cn.comp_name,'')='' then kr.comp_name else cn.comp_name end
      ,ifnull(kr.comp_display_name,'')
      ,ifnull(kr.comp_nickname,'')
      from t_co_comp c
      join t_co_comp_multi kr on kr.lang_code='kr' and c.comp_seq=kr.comp_seq
      left join t_co_comp_multi en on en.lang_code='en' and c.comp_seq=en.comp_seq
      left join t_co_comp_multi jp on jp.lang_code='jp' and c.comp_seq=jp.comp_seq
      left join t_co_comp_multi cn on cn.lang_code='cn' and c.comp_seq=cn.comp_seq
      where c.comp_seq = NEW.comp_seq;
      
    END IF;
    
END$$
DELIMITER ;


DELIMITER $$
DROP TRIGGER IF EXISTS `TRG_T_CO_COMP_MULTI_AU`$$
CREATE TRIGGER `TRG_T_CO_COMP_MULTI_AU` AFTER UPDATE ON t_co_comp_multi FOR EACH ROW
BEGIN
    DECLARE V_SAME_CNT int(11);

    INSERT INTO t_co_comp_multi_history (
		op_code,
		reg_date,
		group_seq,
		comp_seq,
		lang_code,
		comp_name,
		comp_display_name,
		owner_name,
		sender_name,
		biz_condition,
		item,
		addr,
		detail_addr,
		use_yn,
		create_seq,
		create_date,
		modify_seq,
		modify_date,
		comp_nickname
    )
    VALUES (
        'U',
        NOW(),
		NEW.group_seq,
		NEW.comp_seq,
		NEW.lang_code,
		NEW.comp_name,
		NEW.comp_display_name,
		NEW.owner_name,
		NEW.sender_name,
		NEW.biz_condition,
		NEW.item,
		NEW.addr,
		NEW.detail_addr,
		NEW.use_yn,
		NEW.create_seq,
		NEW.create_date,
		NEW.modify_seq,
		NEW.modify_date,
		NEW.comp_nickname
    );
    UPDATE 
        t_co_orgchart
    SET
        task_status = CASE 
                        WHEN    task_status = '0' THEN '1'  
                        WHEN    task_status = '2' THEN '3'  
                        ELSE    task_status END             
        , update_status = CASE
			WHEN   update_status < '99' THEN '99' 
			ELSE   update_status END 
    WHERE 
        group_seq = NEW.group_seq;
    
    
    -- 조직도 패스테이블 적용
    IF NEW.lang_code = 'kr' THEN
    
      select count(*)
      into V_SAME_CNT
      from t_co_orgchart_name con
      left join t_co_comp_multi c_en on con.comp_seq=c_en.comp_seq and c_en.lang_code='en'
      left join t_co_comp_multi c_jp on con.comp_seq=c_jp.comp_seq and c_jp.lang_code='jp'
      left join t_co_comp_multi c_cn on con.comp_seq=c_cn.comp_seq and c_cn.lang_code='cn'   
      where con.gbn_org='c' and con.comp_seq=NEW.comp_seq
      and con.comp_name_kr = NEW.comp_name
      and con.comp_name_en = ifnull(c_en.comp_name, NEW.comp_name)
      and con.comp_name_jp = ifnull(c_jp.comp_name, NEW.comp_name)
      and con.comp_name_cn = ifnull(c_cn.comp_name, NEW.comp_name);       
    
      delete from t_co_orgchart_name where gbn_org = 'c' and comp_seq = NEW.comp_seq;
      
      insert ignore into t_co_orgchart_name
      (org_sync_date, gbn_org, seq, parent_gbn, parent_seq, level, order_num, org_cd, org_use_yn, comp_seq, path, display_path_name_kr, display_path_name_en, display_path_name_jp, display_path_name_cn, comp_name_kr, comp_name_en, comp_name_jp, comp_name_cn, comp_display_name, comp_nickname )
      select NOW()
      ,'c'
      ,c.comp_seq
      ,'g'
      ,'0'
      ,1
      ,c.order_num
      ,c.comp_cd
      ,c.use_yn
      ,c.comp_seq
      ,c.comp_seq
      ,kr.comp_name
      ,case when ifnull(en.comp_name,'')='' then kr.comp_name else en.comp_name end
      ,case when ifnull(jp.comp_name,'')='' then kr.comp_name else jp.comp_name end
      ,case when ifnull(cn.comp_name,'')='' then kr.comp_name else cn.comp_name end
      ,kr.comp_name
      ,case when ifnull(en.comp_name,'')='' then kr.comp_name else en.comp_name end
      ,case when ifnull(jp.comp_name,'')='' then kr.comp_name else jp.comp_name end
      ,case when ifnull(cn.comp_name,'')='' then kr.comp_name else cn.comp_name end
      ,ifnull(kr.comp_display_name,'')
      ,ifnull(kr.comp_nickname,'')
      from t_co_comp c
      join t_co_comp_multi kr on kr.lang_code='kr' and c.comp_seq=kr.comp_seq
      left join t_co_comp_multi en on en.lang_code='en' and c.comp_seq=en.comp_seq
      left join t_co_comp_multi jp on jp.lang_code='jp' and c.comp_seq=jp.comp_seq
      left join t_co_comp_multi cn on cn.lang_code='cn' and c.comp_seq=cn.comp_seq
      where c.comp_seq = NEW.comp_seq;   
      
      IF IFNULL(V_SAME_CNT,0) = 0 THEN
      
        delete from t_co_orgchart_name where gbn_org in ('b','d') and comp_seq = NEW.comp_seq;
      
        insert ignore into t_co_orgchart_name
        (org_sync_date, gbn_org, seq, parent_gbn, parent_seq, level, order_num, org_cd, org_use_yn, comp_seq, biz_seq, biz_display_yn, path, display_path_name_kr, display_path_name_en, display_path_name_jp, display_path_name_cn, comp_name_kr, comp_name_en, comp_name_jp, comp_name_cn, biz_name_kr, biz_name_en, biz_name_jp, biz_name_cn, comp_display_name, comp_nickname, biz_nickname)
        select NOW()
        ,'b'
        ,b.biz_seq
        ,'c'
        ,b.comp_seq
        ,2
        ,b.order_num
        ,b.biz_cd
        ,b.use_yn
        ,b.comp_seq
        ,b.biz_seq
        ,b.display_yn
        ,concat(b.comp_seq,'|',b.biz_seq)
        ,concat(c_kr.comp_name,(case when b.display_yn = 'Y' then concat('|',b_kr.biz_name) else '' end))
        ,concat((case when ifnull(c_en.comp_name,'')='' then c_kr.comp_name else c_en.comp_name end),(case when b.display_yn = 'Y' then concat('|',(case when ifnull(b_en.biz_name,'')='' then b_kr.biz_name else b_en.biz_name end)) else '' end))
        ,concat((case when ifnull(c_jp.comp_name,'')='' then c_kr.comp_name else c_jp.comp_name end),(case when b.display_yn = 'Y' then concat('|',(case when ifnull(b_jp.biz_name,'')='' then b_kr.biz_name else b_jp.biz_name end)) else '' end))
        ,concat((case when ifnull(c_cn.comp_name,'')='' then c_kr.comp_name else c_cn.comp_name end),(case when b.display_yn = 'Y' then concat('|',(case when ifnull(b_cn.biz_name,'')='' then b_kr.biz_name else b_cn.biz_name end)) else '' end))
        ,c_kr.comp_name
        ,case when ifnull(c_en.comp_name,'')='' then c_kr.comp_name else c_en.comp_name end
        ,case when ifnull(c_jp.comp_name,'')='' then c_kr.comp_name else c_jp.comp_name end
        ,case when ifnull(c_cn.comp_name,'')='' then c_kr.comp_name else c_cn.comp_name end
        ,b_kr.biz_name
        ,case when ifnull(b_en.biz_name,'')='' then b_kr.biz_name else b_en.biz_name end
        ,case when ifnull(b_jp.biz_name,'')='' then b_kr.biz_name else b_jp.biz_name end
        ,case when ifnull(b_cn.biz_name,'')='' then b_kr.biz_name else b_cn.biz_name end
        ,ifnull(c_kr.comp_display_name,'')
        ,ifnull(c_kr.comp_nickname,'')
        ,ifnull(b_kr.biz_nickname,'')
        from t_co_biz b
        join t_co_biz_multi b_kr on b_kr.lang_code='kr' and b.biz_seq=b_kr.biz_seq
        left join t_co_biz_multi b_en on b_en.lang_code='en' and b.biz_seq=b_en.biz_seq
        left join t_co_biz_multi b_jp on b_jp.lang_code='jp' and b.biz_seq=b_jp.biz_seq
        left join t_co_biz_multi b_cn on b_cn.lang_code='cn' and b.biz_seq=b_cn.biz_seq
        join t_co_comp_multi c_kr on c_kr.lang_code='kr' and b.comp_seq=c_kr.comp_seq
        left join t_co_comp_multi c_en on c_en.lang_code='en' and b.comp_seq=c_en.comp_seq
        left join t_co_comp_multi c_jp on c_jp.lang_code='jp' and b.comp_seq=c_jp.comp_seq
        left join t_co_comp_multi c_cn on c_cn.lang_code='cn' and b.comp_seq=c_cn.comp_seq
        where b.comp_seq = NEW.comp_seq;

        insert ignore into t_co_orgchart_name
        (org_sync_date, gbn_org, seq, parent_gbn, parent_seq, level, order_num, org_cd, org_use_yn, comp_seq, biz_seq, biz_display_yn, dept_seq, path, display_path_name_kr, display_path_name_en, display_path_name_jp, display_path_name_cn, comp_name_kr, comp_name_en, comp_name_jp, comp_name_cn, biz_name_kr, biz_name_en, biz_name_jp, biz_name_cn, dept_name_kr, dept_name_en, dept_name_jp, dept_name_cn, comp_display_name, comp_nickname, biz_nickname, dept_display_name, dept_nickname)
        select NOW()
        ,'d'
        ,d.dept_seq
        ,case when d.parent_dept_seq != '0' then 'd' when b.display_yn = 'Y' then 'b' else 'c' end
        ,case when d.parent_dept_seq != '0' then d.parent_dept_seq when b.display_yn = 'Y' then d.biz_seq else d.comp_seq end
        ,case when b.display_yn = 'Y' then d.dept_level + 2 else d.dept_level + 1 end
        ,d.order_num
        ,d.dept_cd
        ,d.use_yn
        ,d.comp_seq
        ,d.biz_seq
        ,b.display_yn
        ,d.dept_seq
        ,concat(d.comp_seq,'|',(case when b.display_yn = 'Y' then concat(d.biz_seq,'|') else '' end),d.path)
        ,concat(c_kr.comp_name,get_dept_pathNm('|',d.dept_seq,d.group_seq,'kr'))
        ,concat(case when ifnull(c_en.comp_name,'')='' then c_kr.comp_name else c_en.comp_name end,get_dept_pathNm('|',d.dept_seq,d.group_seq,'en'))
        ,concat(case when ifnull(c_jp.comp_name,'')='' then c_kr.comp_name else c_jp.comp_name end,get_dept_pathNm('|',d.dept_seq,d.group_seq,'jp'))
        ,concat(case when ifnull(c_cn.comp_name,'')='' then c_kr.comp_name else c_cn.comp_name end,get_dept_pathNm('|',d.dept_seq,d.group_seq,'cn'))
        ,c_kr.comp_name
        ,case when ifnull(c_en.comp_name,'')='' then c_kr.comp_name else c_en.comp_name end
        ,case when ifnull(c_jp.comp_name,'')='' then c_kr.comp_name else c_jp.comp_name end
        ,case when ifnull(c_cn.comp_name,'')='' then c_kr.comp_name else c_cn.comp_name end
        ,b_kr.biz_name
        ,case when ifnull(b_en.biz_name,'')='' then b_kr.biz_name else b_en.biz_name end
        ,case when ifnull(b_jp.biz_name,'')='' then b_kr.biz_name else b_jp.biz_name end
        ,case when ifnull(b_cn.biz_name,'')='' then b_kr.biz_name else b_cn.biz_name end
        ,d_kr.dept_name
        ,case when ifnull(d_en.dept_name,'')='' then d_kr.dept_name else d_en.dept_name end
        ,case when ifnull(d_jp.dept_name,'')='' then d_kr.dept_name else d_jp.dept_name end
        ,case when ifnull(d_cn.dept_name,'')='' then d_kr.dept_name else d_cn.dept_name end
        ,ifnull(c_kr.comp_display_name,'')
        ,ifnull(c_kr.comp_nickname,'')
        ,ifnull(b_kr.biz_nickname,'')
        ,ifnull(d_kr.dept_display_name,'')
        ,ifnull(d_kr.dept_nickname,'')
        from t_co_dept d
        join t_co_biz b on d.biz_seq = b.biz_seq
        join t_co_dept_multi d_kr on d_kr.lang_code='kr' and d.dept_seq=d_kr.dept_seq
        left join t_co_dept_multi d_en on d_en.lang_code='en' and d.dept_seq=d_en.dept_seq
        left join t_co_dept_multi d_jp on d_jp.lang_code='jp' and d.dept_seq=d_jp.dept_seq
        left join t_co_dept_multi d_cn on d_cn.lang_code='cn' and d.dept_seq=d_cn.dept_seq
        join t_co_biz_multi b_kr on b_kr.lang_code='kr' and d.biz_seq=b_kr.biz_seq
        left join t_co_biz_multi b_en on b_en.lang_code='en' and d.biz_seq=b_en.biz_seq
        left join t_co_biz_multi b_jp on b_jp.lang_code='jp' and d.biz_seq=b_jp.biz_seq
        left join t_co_biz_multi b_cn on b_cn.lang_code='cn' and d.biz_seq=b_cn.biz_seq
        join t_co_comp_multi c_kr on c_kr.lang_code='kr' and d.comp_seq=c_kr.comp_seq
        left join t_co_comp_multi c_en on c_en.lang_code='en' and d.comp_seq=c_en.comp_seq
        left join t_co_comp_multi c_jp on c_jp.lang_code='jp' and d.comp_seq=c_jp.comp_seq
        left join t_co_comp_multi c_cn on c_cn.lang_code='cn' and d.comp_seq=c_cn.comp_seq  
        where d.comp_seq = NEW.comp_seq;      
      END IF;
    END IF;
END$$
DELIMITER ;

DELIMITER $$
DROP TRIGGER IF EXISTS `TRG_T_CO_COMP_MULTI_AD`$$
CREATE TRIGGER `TRG_T_CO_COMP_MULTI_AD` AFTER DELETE ON t_co_comp_multi FOR EACH ROW
BEGIN
    INSERT INTO t_co_comp_multi_history (
		op_code,
		reg_date,
		group_seq,
		comp_seq,
		lang_code,
		comp_name,
		comp_display_name,
		owner_name,
		sender_name,
		biz_condition,
		item,
		addr,
		detail_addr,
		use_yn,
		create_seq,
		create_date,
		modify_seq,
		modify_date,
		comp_nickname
    )
    VALUES (
        'D',
        NOW(),
		OLD.group_seq,
		OLD.comp_seq,
		OLD.lang_code,
		OLD.comp_name,
		OLD.comp_display_name,
		OLD.owner_name,
		OLD.sender_name,
		OLD.biz_condition,
		OLD.item,
		OLD.addr,
		OLD.detail_addr,
		OLD.use_yn,
		OLD.create_seq,
		OLD.create_date,
		OLD.modify_seq,
		OLD.modify_date,
		OLD.comp_nickname
    );
    
    UPDATE 
        t_co_orgchart
    SET
        task_status = CASE 
                        WHEN    task_status = '0' THEN '1'  
                        WHEN    task_status = '2' THEN '3'  
                        ELSE    task_status END             
        , update_status = CASE
			WHEN   update_status < '99' THEN '99' 
			ELSE   update_status END
    WHERE 
        group_seq = OLD.group_seq;
        
    -- 조직도 패스테이블 적용
    IF OLD.lang_code = 'kr' THEN
      delete from t_co_orgchart_name where comp_seq = OLD.comp_seq;     
    END IF;
    
END$$
DELIMITER ;





DELIMITER $$
DROP TRIGGER IF EXISTS `TRG_T_CO_BIZ_MULTI_AI`$$
CREATE TRIGGER `TRG_T_CO_BIZ_MULTI_AI` AFTER INSERT ON t_co_biz_multi FOR EACH ROW
BEGIN
    INSERT INTO t_co_biz_multi_history (
		op_code,
		reg_date,
		group_seq,
		comp_seq,
		biz_seq,
		lang_code,
		biz_name,
		owner_name,
		biz_condition,
		sender_name,
		biz_nickname,
		item,
		addr,
		detail_addr,
		use_yn,
		create_seq,
		create_date,
		modify_seq,
		modify_date
    )
    VALUES (
        'I',
        NOW(),
		NEW.group_seq,
		NEW.comp_seq,
		NEW.biz_seq,
		NEW.lang_code,
		NEW.biz_name,
		NEW.owner_name,
		NEW.biz_condition,
		NEW.sender_name,
		NEW.biz_nickname,
		NEW.item,
		NEW.addr,
		NEW.detail_addr,
		NEW.use_yn,
		NEW.create_seq,
		NEW.create_date,
		NEW.modify_seq,
		NEW.modify_date
    );
    
    UPDATE 
        t_co_orgchart
    SET
        task_status = CASE 
                        WHEN    task_status = '0' THEN '1'  
                        WHEN    task_status = '2' THEN '3'  
                        ELSE    task_status END             
        , update_status = CASE
			WHEN   update_status < '99' THEN '99' 
			ELSE   update_status END 
    WHERE 
        group_seq = NEW.group_seq;
        
    -- 조직도 패스테이블 적용
    IF NEW.lang_code = 'kr' THEN
      delete from t_co_orgchart_name where biz_seq = NEW.biz_seq;
      
      insert ignore into t_co_orgchart_name
      (org_sync_date, gbn_org, seq, parent_gbn, parent_seq, level, order_num, org_cd, org_use_yn, comp_seq, biz_seq, biz_display_yn, path, display_path_name_kr, display_path_name_en, display_path_name_jp, display_path_name_cn, comp_name_kr, comp_name_en, comp_name_jp, comp_name_cn, biz_name_kr, biz_name_en, biz_name_jp, biz_name_cn, comp_display_name, comp_nickname, biz_nickname)
      select NOW()
      ,'b'
      ,b.biz_seq
      ,'c'
      ,b.comp_seq
      ,2
      ,b.order_num
      ,b.biz_cd
      ,b.use_yn
      ,b.comp_seq
      ,b.biz_seq
      ,b.display_yn
      ,concat(b.comp_seq,'|',b.biz_seq)
      ,concat(c_kr.comp_name,(case when b.display_yn = 'Y' then concat('|',b_kr.biz_name) else '' end))
      ,concat((case when ifnull(c_en.comp_name,'')='' then c_kr.comp_name else c_en.comp_name end),(case when b.display_yn = 'Y' then concat('|',(case when ifnull(b_en.biz_name,'')='' then b_kr.biz_name else b_en.biz_name end)) else '' end))
      ,concat((case when ifnull(c_jp.comp_name,'')='' then c_kr.comp_name else c_jp.comp_name end),(case when b.display_yn = 'Y' then concat('|',(case when ifnull(b_jp.biz_name,'')='' then b_kr.biz_name else b_jp.biz_name end)) else '' end))
      ,concat((case when ifnull(c_cn.comp_name,'')='' then c_kr.comp_name else c_cn.comp_name end),(case when b.display_yn = 'Y' then concat('|',(case when ifnull(b_cn.biz_name,'')='' then b_kr.biz_name else b_cn.biz_name end)) else '' end))
      ,c_kr.comp_name
      ,case when ifnull(c_en.comp_name,'')='' then c_kr.comp_name else c_en.comp_name end
      ,case when ifnull(c_jp.comp_name,'')='' then c_kr.comp_name else c_jp.comp_name end
      ,case when ifnull(c_cn.comp_name,'')='' then c_kr.comp_name else c_cn.comp_name end
      ,b_kr.biz_name
      ,case when ifnull(b_en.biz_name,'')='' then b_kr.biz_name else b_en.biz_name end
      ,case when ifnull(b_jp.biz_name,'')='' then b_kr.biz_name else b_jp.biz_name end
      ,case when ifnull(b_cn.biz_name,'')='' then b_kr.biz_name else b_cn.biz_name end
      ,ifnull(c_kr.comp_display_name,'')
      ,ifnull(c_kr.comp_nickname,'')
      ,ifnull(b_kr.biz_nickname,'')
      from t_co_biz b
      join t_co_biz_multi b_kr on b_kr.lang_code='kr' and b.biz_seq=b_kr.biz_seq
      left join t_co_biz_multi b_en on b_en.lang_code='en' and b.biz_seq=b_en.biz_seq
      left join t_co_biz_multi b_jp on b_jp.lang_code='jp' and b.biz_seq=b_jp.biz_seq
      left join t_co_biz_multi b_cn on b_cn.lang_code='cn' and b.biz_seq=b_cn.biz_seq
      join t_co_comp_multi c_kr on c_kr.lang_code='kr' and b.comp_seq=c_kr.comp_seq
      left join t_co_comp_multi c_en on c_en.lang_code='en' and b.comp_seq=c_en.comp_seq
      left join t_co_comp_multi c_jp on c_jp.lang_code='jp' and b.comp_seq=c_jp.comp_seq
      left join t_co_comp_multi c_cn on c_cn.lang_code='cn' and b.comp_seq=c_cn.comp_seq
      where b.biz_seq = NEW.biz_seq;
    END IF;
END$$
DELIMITER ;





DELIMITER $$
DROP TRIGGER IF EXISTS `TRG_T_CO_BIZ_MULTI_AU`$$
CREATE TRIGGER `TRG_T_CO_BIZ_MULTI_AU` AFTER UPDATE ON t_co_biz_multi FOR EACH ROW
BEGIN

    DECLARE V_SAME_CNT int(11);
    
    INSERT INTO t_co_biz_multi_history (
		op_code,
		reg_date,
		group_seq,
		comp_seq,
		biz_seq,
		lang_code,
		biz_name,
		owner_name,
		biz_condition,
		sender_name,
		biz_nickname,
		item,
		addr,
		detail_addr,
		use_yn,
		create_seq,
		create_date,
		modify_seq,
		modify_date
    )
    VALUES (
        'U',
        NOW(),
		NEW.group_seq,
		NEW.comp_seq,
		NEW.biz_seq,
		NEW.lang_code,
		NEW.biz_name,
		NEW.owner_name,
		NEW.biz_condition,
		NEW.sender_name,
		NEW.biz_nickname,
		NEW.item,
		NEW.addr,
		NEW.detail_addr,
		NEW.use_yn,
		NEW.create_seq,
		NEW.create_date,
		NEW.modify_seq,
		NEW.modify_date
    );
    UPDATE 
        t_co_orgchart
    SET
        task_status = CASE 
                        WHEN    task_status = '0' THEN '1'  
                        WHEN    task_status = '2' THEN '3'  
                        ELSE    task_status END             
        , update_status = CASE
			WHEN   update_status < '99' THEN '99' 
			ELSE   update_status END 
    WHERE 
        group_seq = NEW.group_seq;
    
    -- 조직도 패스테이블 적용
    IF NEW.lang_code = 'kr' THEN
    
      select count(*)
      into V_SAME_CNT
      from t_co_orgchart_name con
      join t_co_biz b on con.biz_seq = b.biz_seq
      left join t_co_biz_multi b_en on con.biz_seq=b_en.biz_seq and b_en.lang_code='en'
      left join t_co_biz_multi b_jp on con.biz_seq=b_jp.biz_seq and b_jp.lang_code='jp'
      left join t_co_biz_multi b_cn on con.biz_seq=b_cn.biz_seq and b_cn.lang_code='cn'   
      where con.gbn_org='b' and con.biz_seq=NEW.biz_seq
      and con.biz_display_yn = b.display_yn
      and con.biz_name_kr = NEW.biz_name
      and con.biz_name_en = ifnull(b_en.biz_name, NEW.biz_name)
      and con.biz_name_jp = ifnull(b_jp.biz_name, NEW.biz_name)
      and con.biz_name_cn = ifnull(b_cn.biz_name, NEW.biz_name);        
    
      delete from t_co_orgchart_name where gbn_org = 'b' and biz_seq = NEW.biz_seq;
    
      insert ignore into t_co_orgchart_name
      (org_sync_date, gbn_org, seq, parent_gbn, parent_seq, level, order_num, org_cd, org_use_yn, comp_seq, biz_seq, biz_display_yn, path, display_path_name_kr, display_path_name_en, display_path_name_jp, display_path_name_cn, comp_name_kr, comp_name_en, comp_name_jp, comp_name_cn, biz_name_kr, biz_name_en, biz_name_jp, biz_name_cn, comp_display_name, comp_nickname, biz_nickname)
      select NOW()
      ,'b'
      ,b.biz_seq
      ,'c'
      ,b.comp_seq
      ,2
      ,b.order_num
      ,b.biz_cd
      ,b.use_yn
      ,b.comp_seq
      ,b.biz_seq
      ,b.display_yn
      ,concat(b.comp_seq,'|',b.biz_seq)
      ,concat(c_kr.comp_name,(case when b.display_yn = 'Y' then concat('|',b_kr.biz_name) else '' end))
      ,concat((case when ifnull(c_en.comp_name,'')='' then c_kr.comp_name else c_en.comp_name end),(case when b.display_yn = 'Y' then concat('|',(case when ifnull(b_en.biz_name,'')='' then b_kr.biz_name else b_en.biz_name end)) else '' end))
      ,concat((case when ifnull(c_jp.comp_name,'')='' then c_kr.comp_name else c_jp.comp_name end),(case when b.display_yn = 'Y' then concat('|',(case when ifnull(b_jp.biz_name,'')='' then b_kr.biz_name else b_jp.biz_name end)) else '' end))
      ,concat((case when ifnull(c_cn.comp_name,'')='' then c_kr.comp_name else c_cn.comp_name end),(case when b.display_yn = 'Y' then concat('|',(case when ifnull(b_cn.biz_name,'')='' then b_kr.biz_name else b_cn.biz_name end)) else '' end))
      ,c_kr.comp_name
      ,case when ifnull(c_en.comp_name,'')='' then c_kr.comp_name else c_en.comp_name end
      ,case when ifnull(c_jp.comp_name,'')='' then c_kr.comp_name else c_jp.comp_name end
      ,case when ifnull(c_cn.comp_name,'')='' then c_kr.comp_name else c_cn.comp_name end
      ,b_kr.biz_name
      ,case when ifnull(b_en.biz_name,'')='' then b_kr.biz_name else b_en.biz_name end
      ,case when ifnull(b_jp.biz_name,'')='' then b_kr.biz_name else b_jp.biz_name end
      ,case when ifnull(b_cn.biz_name,'')='' then b_kr.biz_name else b_cn.biz_name end
      ,ifnull(c_kr.comp_display_name,'')
      ,ifnull(c_kr.comp_nickname,'')
      ,ifnull(b_kr.biz_nickname,'')
      from t_co_biz b
      join t_co_biz_multi b_kr on b_kr.lang_code='kr' and b.biz_seq=b_kr.biz_seq
      left join t_co_biz_multi b_en on b_en.lang_code='en' and b.biz_seq=b_en.biz_seq
      left join t_co_biz_multi b_jp on b_jp.lang_code='jp' and b.biz_seq=b_jp.biz_seq
      left join t_co_biz_multi b_cn on b_cn.lang_code='cn' and b.biz_seq=b_cn.biz_seq
      join t_co_comp_multi c_kr on c_kr.lang_code='kr' and b.comp_seq=c_kr.comp_seq
      left join t_co_comp_multi c_en on c_en.lang_code='en' and b.comp_seq=c_en.comp_seq
      left join t_co_comp_multi c_jp on c_jp.lang_code='jp' and b.comp_seq=c_jp.comp_seq
      left join t_co_comp_multi c_cn on c_cn.lang_code='cn' and b.comp_seq=c_cn.comp_seq
      where b.biz_seq = NEW.biz_seq;    
    
      IF IFNULL(V_SAME_CNT,0) = 0 THEN
        delete from t_co_orgchart_name where gbn_org = 'd' and biz_seq = NEW.biz_seq;

        insert ignore into t_co_orgchart_name
        (org_sync_date, gbn_org, seq, parent_gbn, parent_seq, level, order_num, org_cd, org_use_yn, comp_seq, biz_seq, biz_display_yn, dept_seq, path, display_path_name_kr, display_path_name_en, display_path_name_jp, display_path_name_cn, comp_name_kr, comp_name_en, comp_name_jp, comp_name_cn, biz_name_kr, biz_name_en, biz_name_jp, biz_name_cn, dept_name_kr, dept_name_en, dept_name_jp, dept_name_cn, comp_display_name, comp_nickname, biz_nickname, dept_display_name, dept_nickname)
        select NOW()
        ,'d'
        ,d.dept_seq
        ,case when d.parent_dept_seq != '0' then 'd' when b.display_yn = 'Y' then 'b' else 'c' end
        ,case when d.parent_dept_seq != '0' then d.parent_dept_seq when b.display_yn = 'Y' then d.biz_seq else d.comp_seq end
        ,case when b.display_yn = 'Y' then d.dept_level + 2 else d.dept_level + 1 end
        ,d.order_num
        ,d.dept_cd
        ,d.use_yn
        ,d.comp_seq
        ,d.biz_seq
        ,b.display_yn
        ,d.dept_seq
        ,concat(d.comp_seq,'|',(case when b.display_yn = 'Y' then concat(d.biz_seq,'|') else '' end),d.path)
        ,concat(c_kr.comp_name,get_dept_pathNm('|',d.dept_seq,d.group_seq,'kr'))
        ,concat(case when ifnull(c_en.comp_name,'')='' then c_kr.comp_name else c_en.comp_name end,get_dept_pathNm('|',d.dept_seq,d.group_seq,'en'))
        ,concat(case when ifnull(c_jp.comp_name,'')='' then c_kr.comp_name else c_jp.comp_name end,get_dept_pathNm('|',d.dept_seq,d.group_seq,'jp'))
        ,concat(case when ifnull(c_cn.comp_name,'')='' then c_kr.comp_name else c_cn.comp_name end,get_dept_pathNm('|',d.dept_seq,d.group_seq,'cn'))
        ,c_kr.comp_name
        ,case when ifnull(c_en.comp_name,'')='' then c_kr.comp_name else c_en.comp_name end
        ,case when ifnull(c_jp.comp_name,'')='' then c_kr.comp_name else c_jp.comp_name end
        ,case when ifnull(c_cn.comp_name,'')='' then c_kr.comp_name else c_cn.comp_name end
        ,b_kr.biz_name
        ,case when ifnull(b_en.biz_name,'')='' then b_kr.biz_name else b_en.biz_name end
        ,case when ifnull(b_jp.biz_name,'')='' then b_kr.biz_name else b_jp.biz_name end
        ,case when ifnull(b_cn.biz_name,'')='' then b_kr.biz_name else b_cn.biz_name end
        ,d_kr.dept_name
        ,case when ifnull(d_en.dept_name,'')='' then d_kr.dept_name else d_en.dept_name end
        ,case when ifnull(d_jp.dept_name,'')='' then d_kr.dept_name else d_jp.dept_name end
        ,case when ifnull(d_cn.dept_name,'')='' then d_kr.dept_name else d_cn.dept_name end
        ,ifnull(c_kr.comp_display_name,'')
        ,ifnull(c_kr.comp_nickname,'')
        ,ifnull(b_kr.biz_nickname,'')
        ,ifnull(d_kr.dept_display_name,'')
        ,ifnull(d_kr.dept_nickname,'')
        from t_co_dept d
        join t_co_biz b on d.biz_seq = b.biz_seq
        join t_co_dept_multi d_kr on d_kr.lang_code='kr' and d.dept_seq=d_kr.dept_seq
        left join t_co_dept_multi d_en on d_en.lang_code='en' and d.dept_seq=d_en.dept_seq
        left join t_co_dept_multi d_jp on d_jp.lang_code='jp' and d.dept_seq=d_jp.dept_seq
        left join t_co_dept_multi d_cn on d_cn.lang_code='cn' and d.dept_seq=d_cn.dept_seq
        join t_co_biz_multi b_kr on b_kr.lang_code='kr' and d.biz_seq=b_kr.biz_seq
        left join t_co_biz_multi b_en on b_en.lang_code='en' and d.biz_seq=b_en.biz_seq
        left join t_co_biz_multi b_jp on b_jp.lang_code='jp' and d.biz_seq=b_jp.biz_seq
        left join t_co_biz_multi b_cn on b_cn.lang_code='cn' and d.biz_seq=b_cn.biz_seq
        join t_co_comp_multi c_kr on c_kr.lang_code='kr' and d.comp_seq=c_kr.comp_seq
        left join t_co_comp_multi c_en on c_en.lang_code='en' and d.comp_seq=c_en.comp_seq
        left join t_co_comp_multi c_jp on c_jp.lang_code='jp' and d.comp_seq=c_jp.comp_seq
        left join t_co_comp_multi c_cn on c_cn.lang_code='cn' and d.comp_seq=c_cn.comp_seq  
        where d.biz_seq = NEW.biz_seq and NEW.lang_code = 'kr';            
        
      END IF;
    
    END IF;

END$$
DELIMITER ;

DELIMITER $$
DROP TRIGGER IF EXISTS `TRG_T_CO_BIZ_MULTI_AD`$$
CREATE TRIGGER `TRG_T_CO_BIZ_MULTI_AD` AFTER DELETE ON t_co_biz_multi FOR EACH ROW
BEGIN
    INSERT INTO t_co_biz_multi_history (
		op_code,
		reg_date,
		group_seq,
		comp_seq,
		biz_seq,
		lang_code,
		biz_name,
		owner_name,
		biz_condition,
		sender_name,
		biz_nickname,
		item,
		addr,
		detail_addr,
		use_yn,
		create_seq,
		create_date,
		modify_seq,
		modify_date
    )
    VALUES (
        'D',
        NOW(),
		OLD.group_seq,
		OLD.comp_seq,
		OLD.biz_seq,
		OLD.lang_code,
		OLD.biz_name,
		OLD.owner_name,
		OLD.biz_condition,
		OLD.sender_name,
		OLD.biz_nickname,
		OLD.item,
		OLD.addr,
		OLD.detail_addr,
		OLD.use_yn,
		OLD.create_seq,
		OLD.create_date,
		OLD.modify_seq,
		OLD.modify_date
    );
    
    UPDATE 
        t_co_orgchart
    SET
        task_status = CASE 
                        WHEN    task_status = '0' THEN '1'  
                        WHEN    task_status = '2' THEN '3'  
                        ELSE    task_status END             
        , update_status = CASE
			WHEN   update_status < '99' THEN '99' 
			ELSE   update_status END
    WHERE 
        group_seq = OLD.group_seq;
        
    -- 조직도 패스테이블 적용
    IF OLD.lang_code = 'kr' THEN
      delete from t_co_orgchart_name where biz_seq = OLD.biz_seq;        
    END IF;
END$$
DELIMITER ;


DELIMITER $$
DROP TRIGGER IF EXISTS `TRG_T_CO_DEPT_MULTI_AI`$$
CREATE TRIGGER `TRG_T_CO_DEPT_MULTI_AI` AFTER INSERT ON t_co_dept_multi FOR EACH ROW
BEGIN
    
    INSERT INTO t_co_dept_multi_history (
		op_code,
		reg_date,
		group_seq,
		comp_seq,
		biz_seq,
		dept_seq,
		lang_code,
		dept_name,
		dept_display_name,
		sender_name,
		addr,
		detail_addr,
		path_name,
		use_yn,
		create_seq,
		create_date,
		modify_seq,
		modify_date,
		dept_nickname
    )
    VALUES (
        'I',
        NOW(),
NEW.group_seq,
NEW.comp_seq,
NEW.biz_seq,
NEW.dept_seq,
NEW.lang_code,
NEW.dept_name,
NEW.dept_display_name,
NEW.sender_name,
NEW.addr,
NEW.detail_addr,
NEW.path_name,
NEW.use_yn,
NEW.create_seq,
NEW.create_date,
NEW.modify_seq,
NEW.modify_date,
NEW.dept_nickname
    );
    
    UPDATE 
        t_co_orgchart
    SET
        task_status = CASE 
                        WHEN    task_status = '0' THEN '1'  
                        WHEN    task_status = '2' THEN '3'  
                        ELSE    task_status END             
        , update_status = CASE
			WHEN   update_status < '99' THEN '99' 
			ELSE   update_status END 
    WHERE 
        group_seq = NEW.group_seq;
        
    -- 조직도 패스테이블 적용
    IF NEW.lang_code = 'kr' THEN
      
      delete from t_co_orgchart_name where dept_seq = NEW.dept_seq;
      
      insert ignore into t_co_orgchart_name
      (org_sync_date, gbn_org, seq, parent_gbn, parent_seq, level, order_num, org_cd, org_use_yn, comp_seq, biz_seq, biz_display_yn, dept_seq, path, display_path_name_kr, display_path_name_en, display_path_name_jp, display_path_name_cn, comp_name_kr, comp_name_en, comp_name_jp, comp_name_cn, biz_name_kr, biz_name_en, biz_name_jp, biz_name_cn, dept_name_kr, dept_name_en, dept_name_jp, dept_name_cn, comp_display_name, comp_nickname, biz_nickname, dept_display_name, dept_nickname)
      select NOW()
      ,'d'
      ,d.dept_seq
      ,case when d.parent_dept_seq != '0' then 'd' when b.display_yn = 'Y' then 'b' else 'c' end
      ,case when d.parent_dept_seq != '0' then d.parent_dept_seq when b.display_yn = 'Y' then d.biz_seq else d.comp_seq end
      ,case when b.display_yn = 'Y' then d.dept_level + 2 else d.dept_level + 1 end
      ,d.order_num
      ,d.dept_cd
      ,d.use_yn
      ,d.comp_seq
      ,d.biz_seq
      ,b.display_yn
      ,d.dept_seq
      ,concat(d.comp_seq,'|',(case when b.display_yn = 'Y' then concat(d.biz_seq,'|') else '' end),d.path)
      ,concat(c_kr.comp_name,get_dept_pathNm('|',d.dept_seq,d.group_seq,'kr'))
      ,concat(case when ifnull(c_en.comp_name,'')='' then c_kr.comp_name else c_en.comp_name end,get_dept_pathNm('|',d.dept_seq,d.group_seq,'en'))
      ,concat(case when ifnull(c_jp.comp_name,'')='' then c_kr.comp_name else c_jp.comp_name end,get_dept_pathNm('|',d.dept_seq,d.group_seq,'jp'))
      ,concat(case when ifnull(c_cn.comp_name,'')='' then c_kr.comp_name else c_cn.comp_name end,get_dept_pathNm('|',d.dept_seq,d.group_seq,'cn'))
      ,c_kr.comp_name
      ,case when ifnull(c_en.comp_name,'')='' then c_kr.comp_name else c_en.comp_name end
      ,case when ifnull(c_jp.comp_name,'')='' then c_kr.comp_name else c_jp.comp_name end
      ,case when ifnull(c_cn.comp_name,'')='' then c_kr.comp_name else c_cn.comp_name end
      ,b_kr.biz_name
      ,case when ifnull(b_en.biz_name,'')='' then b_kr.biz_name else b_en.biz_name end
      ,case when ifnull(b_jp.biz_name,'')='' then b_kr.biz_name else b_jp.biz_name end
      ,case when ifnull(b_cn.biz_name,'')='' then b_kr.biz_name else b_cn.biz_name end
      ,d_kr.dept_name
      ,case when ifnull(d_en.dept_name,'')='' then d_kr.dept_name else d_en.dept_name end
      ,case when ifnull(d_jp.dept_name,'')='' then d_kr.dept_name else d_jp.dept_name end
      ,case when ifnull(d_cn.dept_name,'')='' then d_kr.dept_name else d_cn.dept_name end
      ,ifnull(c_kr.comp_display_name,'')
      ,ifnull(c_kr.comp_nickname,'')
      ,ifnull(b_kr.biz_nickname,'')
      ,ifnull(d_kr.dept_display_name,'')
      ,ifnull(d_kr.dept_nickname,'')
      from t_co_dept d
      join t_co_biz b on d.biz_seq = b.biz_seq
      join t_co_dept_multi d_kr on d_kr.lang_code='kr' and d.dept_seq=d_kr.dept_seq
      left join t_co_dept_multi d_en on d_en.lang_code='en' and d.dept_seq=d_en.dept_seq
      left join t_co_dept_multi d_jp on d_jp.lang_code='jp' and d.dept_seq=d_jp.dept_seq
      left join t_co_dept_multi d_cn on d_cn.lang_code='cn' and d.dept_seq=d_cn.dept_seq
      join t_co_biz_multi b_kr on b_kr.lang_code='kr' and d.biz_seq=b_kr.biz_seq
      left join t_co_biz_multi b_en on b_en.lang_code='en' and d.biz_seq=b_en.biz_seq
      left join t_co_biz_multi b_jp on b_jp.lang_code='jp' and d.biz_seq=b_jp.biz_seq
      left join t_co_biz_multi b_cn on b_cn.lang_code='cn' and d.biz_seq=b_cn.biz_seq
      join t_co_comp_multi c_kr on c_kr.lang_code='kr' and d.comp_seq=c_kr.comp_seq
      left join t_co_comp_multi c_en on c_en.lang_code='en' and d.comp_seq=c_en.comp_seq
      left join t_co_comp_multi c_jp on c_jp.lang_code='jp' and d.comp_seq=c_jp.comp_seq
      left join t_co_comp_multi c_cn on c_cn.lang_code='cn' and d.comp_seq=c_cn.comp_seq  
      where d.dept_seq = NEW.dept_seq;            
    END IF;    
END$$
DELIMITER ;



DELIMITER $$
DROP TRIGGER IF EXISTS `TRG_T_CO_DEPT_MULTI_AU`$$
CREATE TRIGGER `TRG_T_CO_DEPT_MULTI_AU` AFTER UPDATE ON t_co_dept_multi FOR EACH ROW
BEGIN
    INSERT INTO t_co_dept_multi_history (
		op_code,
		reg_date,
		group_seq,
		comp_seq,
		biz_seq,
		dept_seq,
		lang_code,
		dept_name,
		dept_display_name,
		sender_name,
		addr,
		detail_addr,
		path_name,
		use_yn,
		create_seq,
		create_date,
		modify_seq,
		modify_date,
		dept_nickname
    )
    VALUES (
        'U',
        NOW(),
		NEW.group_seq,
		NEW.comp_seq,
		NEW.biz_seq,
		NEW.dept_seq,
		NEW.lang_code,
		NEW.dept_name,
		NEW.dept_display_name,
		NEW.sender_name,
		NEW.addr,
		NEW.detail_addr,
		NEW.path_name,
		NEW.use_yn,
		NEW.create_seq,
		NEW.create_date,
		NEW.modify_seq,
		NEW.modify_date,
		NEW.dept_nickname
    );
    UPDATE 
        t_co_orgchart
    SET
        task_status = CASE 
                        WHEN    task_status = '0' THEN '1'  
                        WHEN    task_status = '2' THEN '3'  
                        ELSE    task_status END             
        , update_status = CASE
			WHEN   update_status < '99' THEN '99' 
			ELSE   update_status END
    WHERE 
        group_seq = NEW.group_seq;
        
    -- 조직도 패스테이블 적용
    IF NEW.lang_code = 'kr' THEN
      delete from t_co_orgchart_name where dept_seq = NEW.dept_seq;

      insert ignore into t_co_orgchart_name
      (org_sync_date, gbn_org, seq, parent_gbn, parent_seq, level, order_num, org_cd, org_use_yn, comp_seq, biz_seq, biz_display_yn, dept_seq, path, display_path_name_kr, display_path_name_en, display_path_name_jp, display_path_name_cn, comp_name_kr, comp_name_en, comp_name_jp, comp_name_cn, biz_name_kr, biz_name_en, biz_name_jp, biz_name_cn, dept_name_kr, dept_name_en, dept_name_jp, dept_name_cn, comp_display_name, comp_nickname, biz_nickname, dept_display_name, dept_nickname)
      select NOW()
      ,'d'
      ,d.dept_seq
      ,case when d.parent_dept_seq != '0' then 'd' when b.display_yn = 'Y' then 'b' else 'c' end
      ,case when d.parent_dept_seq != '0' then d.parent_dept_seq when b.display_yn = 'Y' then d.biz_seq else d.comp_seq end
      ,case when b.display_yn = 'Y' then d.dept_level + 2 else d.dept_level + 1 end
      ,d.order_num
      ,d.dept_cd
      ,d.use_yn
      ,d.comp_seq
      ,d.biz_seq
      ,b.display_yn
      ,d.dept_seq
      ,concat(d.comp_seq,'|',(case when b.display_yn = 'Y' then concat(d.biz_seq,'|') else '' end),d.path)
      ,concat(c_kr.comp_name,get_dept_pathNm('|',d.dept_seq,d.group_seq,'kr'))
      ,concat(case when ifnull(c_en.comp_name,'')='' then c_kr.comp_name else c_en.comp_name end,get_dept_pathNm('|',d.dept_seq,d.group_seq,'en'))
      ,concat(case when ifnull(c_jp.comp_name,'')='' then c_kr.comp_name else c_jp.comp_name end,get_dept_pathNm('|',d.dept_seq,d.group_seq,'jp'))
      ,concat(case when ifnull(c_cn.comp_name,'')='' then c_kr.comp_name else c_cn.comp_name end,get_dept_pathNm('|',d.dept_seq,d.group_seq,'cn'))
      ,c_kr.comp_name
      ,case when ifnull(c_en.comp_name,'')='' then c_kr.comp_name else c_en.comp_name end
      ,case when ifnull(c_jp.comp_name,'')='' then c_kr.comp_name else c_jp.comp_name end
      ,case when ifnull(c_cn.comp_name,'')='' then c_kr.comp_name else c_cn.comp_name end
      ,b_kr.biz_name
      ,case when ifnull(b_en.biz_name,'')='' then b_kr.biz_name else b_en.biz_name end
      ,case when ifnull(b_jp.biz_name,'')='' then b_kr.biz_name else b_jp.biz_name end
      ,case when ifnull(b_cn.biz_name,'')='' then b_kr.biz_name else b_cn.biz_name end
      ,d_kr.dept_name
      ,case when ifnull(d_en.dept_name,'')='' then d_kr.dept_name else d_en.dept_name end
      ,case when ifnull(d_jp.dept_name,'')='' then d_kr.dept_name else d_jp.dept_name end
      ,case when ifnull(d_cn.dept_name,'')='' then d_kr.dept_name else d_cn.dept_name end
      ,ifnull(c_kr.comp_display_name,'')
      ,ifnull(c_kr.comp_nickname,'')
      ,ifnull(b_kr.biz_nickname,'')
      ,ifnull(d_kr.dept_display_name,'')
      ,ifnull(d_kr.dept_nickname,'')
      from t_co_dept d
      join t_co_biz b on d.biz_seq = b.biz_seq
      join t_co_dept_multi d_kr on d_kr.lang_code='kr' and d.dept_seq=d_kr.dept_seq
      left join t_co_dept_multi d_en on d_en.lang_code='en' and d.dept_seq=d_en.dept_seq
      left join t_co_dept_multi d_jp on d_jp.lang_code='jp' and d.dept_seq=d_jp.dept_seq
      left join t_co_dept_multi d_cn on d_cn.lang_code='cn' and d.dept_seq=d_cn.dept_seq
      join t_co_biz_multi b_kr on b_kr.lang_code='kr' and d.biz_seq=b_kr.biz_seq
      left join t_co_biz_multi b_en on b_en.lang_code='en' and d.biz_seq=b_en.biz_seq
      left join t_co_biz_multi b_jp on b_jp.lang_code='jp' and d.biz_seq=b_jp.biz_seq
      left join t_co_biz_multi b_cn on b_cn.lang_code='cn' and d.biz_seq=b_cn.biz_seq
      join t_co_comp_multi c_kr on c_kr.lang_code='kr' and d.comp_seq=c_kr.comp_seq
      left join t_co_comp_multi c_en on c_en.lang_code='en' and d.comp_seq=c_en.comp_seq
      left join t_co_comp_multi c_jp on c_jp.lang_code='jp' and d.comp_seq=c_jp.comp_seq
      left join t_co_comp_multi c_cn on c_cn.lang_code='cn' and d.comp_seq=c_cn.comp_seq  
      where d.dept_seq = NEW.dept_seq;    
    END IF;
END$$
DELIMITER ;

DELIMITER $$
DROP TRIGGER IF EXISTS `TRG_T_CO_DEPT_MULTI_AD`$$
CREATE TRIGGER `TRG_T_CO_DEPT_MULTI_AD` AFTER DELETE ON t_co_dept_multi FOR EACH ROW
BEGIN
    INSERT INTO t_co_dept_multi_history (
		op_code,
		reg_date,
		group_seq,
		comp_seq,
		biz_seq,
		dept_seq,
		lang_code,
		dept_name,
		dept_display_name,
		sender_name,
		addr,
		detail_addr,
		path_name,
		use_yn,
		create_seq,
		create_date,
		modify_seq,
		modify_date,
		dept_nickname
    )
    VALUES (
        'D',
        NOW(),
		OLD.group_seq,
		OLD.comp_seq,
		OLD.biz_seq,
		OLD.dept_seq,
		OLD.lang_code,
		OLD.dept_name,
		OLD.dept_display_name,
		OLD.sender_name,
		OLD.addr,
		OLD.detail_addr,
		OLD.path_name,
		OLD.use_yn,
		OLD.create_seq,
		OLD.create_date,
		OLD.modify_seq,
		OLD.modify_date,
		OLD.dept_nickname
    );
    
    UPDATE 
        t_co_orgchart
    SET
        task_status = CASE 
                        WHEN    task_status = '0' THEN '1'  
                        WHEN    task_status = '2' THEN '3'  
                        ELSE    task_status END             
        , update_status = CASE
			WHEN   update_status < '99' THEN '99' 
			ELSE   update_status END
    WHERE 
        group_seq = OLD.group_seq;
        
    -- 조직도 패스테이블 적용
    IF OLD.lang_code = 'kr' THEN
      delete from t_co_orgchart_name where dept_seq = OLD.dept_seq;
    END IF;
    
END$$
DELIMITER ;


DELIMITER $$
DROP TRIGGER IF EXISTS `TRG_T_CO_COMP_AD`$$
CREATE TRIGGER `TRG_T_CO_COMP_AD` AFTER DELETE ON t_co_comp FOR EACH ROW
BEGIN
    
    INSERT INTO t_co_comp_history (
        op_code,
        reg_date,
        group_seq,
        comp_seq,
        parent_comp_seq,
        comp_regist_num,
        comp_num,
        standard_code,
        tel_num,
        fax_num,
        homepg_addr,
        comp_domain,
        email_addr,
        email_domain,
        zip_code,
        sms_id,
        sms_passwd,
        native_lang_code,
        order_num,
        use_yn,
        ea_type,
        create_seq,
        create_date,
        modify_seq,
        modify_date,
        comp_email_yn,
        erp_use_yn,
	sms_use_yn,
	comp_cd,
	erp_use,
	sms_use
    )
    VALUES (
        'D',
        NOW(),
        OLD.group_seq,
        OLD.comp_seq,
        OLD.parent_comp_seq,
        OLD.comp_regist_num,
        OLD.comp_num,
        OLD.standard_code,
        OLD.tel_num,
        OLD.fax_num,
        OLD.homepg_addr,
        OLD.comp_domain,
        OLD.email_addr,
        OLD.email_domain,
        OLD.zip_code,
        OLD.sms_id,
        OLD.sms_passwd,
        OLD.native_lang_code,
        OLD.order_num,
        OLD.use_yn,
        OLD.ea_type,
        OLD.create_seq,
        OLD.create_date,
        OLD.modify_seq,
        OLD.modify_date,
        OLD.comp_email_yn,
        OLD.erp_use_yn,
	OLD.sms_use_yn,
	OLD.comp_cd,
	OLD.erp_use,
	OLD.sms_use
    );
    
    UPDATE 
        t_co_orgchart
    SET
        task_status = CASE 
                        WHEN    task_status = '0' THEN '1'  
                        WHEN    task_status = '2' THEN '3'  
                        ELSE    task_status END             
        , update_status = CASE
			WHEN   update_status < '99' THEN '99' 
			ELSE   update_status END
    WHERE 
        group_seq = OLD.group_seq;
        
    -- 조직도 패스테이블 적용
    delete from t_co_orgchart_name where comp_seq = OLD.comp_seq;   
    
END$$
DELIMITER ;

DELIMITER $$
DROP TRIGGER IF EXISTS `TRG_T_CO_BIZ_AD`$$
CREATE TRIGGER `TRG_T_CO_BIZ_AD` AFTER DELETE ON t_co_biz FOR EACH ROW
BEGIN
    
    INSERT INTO t_co_biz_history (
		op_code,
		reg_date,
		group_seq,
		comp_seq,
		biz_seq,
		comp_regist_num,
		comp_num,
		tel_num,
		fax_num,
		homepg_addr,
		zip_code,
		display_yn,
		native_lang_code,
		order_num,
		use_yn,
		create_seq,
		create_date,
		modify_seq,
		modify_date
    )
    VALUES (
        'D',
        NOW(),
		OLD.group_seq,
		OLD.comp_seq,
		OLD.biz_seq,
		OLD.comp_regist_num,
		OLD.comp_num,
		OLD.tel_num,
		OLD.fax_num,
		OLD.homepg_addr,
		OLD.zip_code,
		OLD.display_yn,
		OLD.native_lang_code,
		OLD.order_num,
		OLD.use_yn,
		OLD.create_seq,
		OLD.create_date,
		OLD.modify_seq,
		OLD.modify_date
    );
    
    UPDATE 
        t_co_orgchart
    SET
        task_status = CASE 
                        WHEN    task_status = '0' THEN '1'  
                        WHEN    task_status = '2' THEN '3'  
                        ELSE    task_status END             
        , update_status = CASE
			when   update_status < '99' then '99' 
			else   update_status END
    WHERE 
        group_seq = OLD.group_seq;
        
    -- 조직도 패스테이블 적용
    delete from t_co_orgchart_name where biz_seq = OLD.biz_seq;   
    
END$$
DELIMITER ;

DELIMITER $$
DROP TRIGGER IF EXISTS `TRG_T_CO_DEPT_AD`$$
CREATE TRIGGER `TRG_T_CO_DEPT_AD` AFTER DELETE ON t_co_dept FOR EACH ROW
BEGIN
    
    INSERT INTO t_co_dept_history (
		op_code,
		reg_date,
		group_seq,
		comp_seq,
		biz_seq,
		dept_seq,
		parent_dept_seq,
		tel_num,
		fax_num,
		homepg_addr,
		zip_code,
		susin_yn,
		vir_dept_yn,
		team_yn,
		native_lang_code,
		path,
		ptype,
		dept_level,
		order_num,
		use_yn,
		create_seq,
		create_date,
		modify_seq,
		modify_date,
		dept_manager,
		display_yn,
		dept_cd,
		display_dept_seq,
		inner_receive_yn
    )
    VALUES (
        'D',
        NOW(),
		OLD.group_seq,
		OLD.comp_seq,
		OLD.biz_seq,
		OLD.dept_seq,
		OLD.parent_dept_seq,
		OLD.tel_num,
		OLD.fax_num,
		OLD.homepg_addr,
		OLD.zip_code,
		OLD.susin_yn,
		OLD.vir_dept_yn,
		OLD.team_yn,
		OLD.native_lang_code,
		OLD.path,
		OLD.ptype,
		OLD.dept_level,
		OLD.order_num,
		OLD.use_yn,
		OLD.create_seq,
		OLD.create_date,
		OLD.modify_seq,
		OLD.modify_date,
		OLD.dept_manager,
		OLD.display_yn,
		OLD.dept_cd,
		OLD.display_dept_seq,
		OLD.inner_receive_yn
    );
    
    UPDATE 
        t_co_orgchart
    SET
        task_status = CASE 
                        WHEN    task_status = '0' THEN '1'  
                        WHEN    task_status = '2' THEN '3'  
                        ELSE    task_status END             
        , update_status = CASE
			WHEN   update_status < '99' THEN '99' 
			ELSE   update_status END 
    WHERE 
        group_seq = OLD.group_seq;
        
    -- 조직도 패스테이블 적용
    delete from t_co_orgchart_name where dept_seq = OLD.dept_seq;        
END$$
DELIMITER ;


DELIMITER $$

DROP PROCEDURE IF EXISTS `Z_DUZONITGROUP_BS_VISITOR_I`$$

CREATE PROCEDURE `Z_DUZONITGROUP_BS_VISITOR_I`(
	IN `nManCoSeq` VARCHAR(50),
	IN `nManUserSeq` VARCHAR(50),
	IN `nReqCoSeq` VARCHAR(50),
	IN `nReqUserSeq` VARCHAR(50),
	IN `sDistnct` VARCHAR(1),
	IN `sVisitCO` VARCHAR(100),
	IN `sVisitNM` VARCHAR(100),
	IN `sVisitHP` VARCHAR(15),
	IN `sVisitCarNo` VARCHAR(30),
	IN `sVisitFrDT` VARCHAR(8),
	IN `sVisitToDT` VARCHAR(8),
	IN `sVisitFrTM` VARCHAR(4),
	IN `sVisitToTM` VARCHAR(4),
	IN `sVisitAIM` VARCHAR(255),
	IN `nVisitCnt` INT,
	IN `sETC` VARCHAR(255),
	IN `sVisitDT` VARCHAR(8),
	IN `sInTime` VARCHAR(4),
	IN `sOutTime` VARCHAR(4)

)
BEGIN
	DECLARE nR_NO INT;
	DECLARE nSeq INT;
	
	DECLARE FR_DATE	DATETIME;
	DECLARE TO_DATE	DATETIME;
	DECLARE VISIT_DT	NVARCHAR(8);
	DECLARE SEQ		INT;
	
	
	SET nR_NO = (SELECT MAX(r_no) FROM Z_DUZONITGROUP_VISITORS_M) + 1;
	SET nSeq = (SELECT COUNT(*) FROM Z_DUZONITGROUP_VISITORS_D WHERE r_no = nR_NO) + 1;
	
	
	IF sDistnct = 1 THEN
	BEGIN
		INSERT INTO Z_DUZONITGROUP_VISITORS_M ( r_no, 
					man_comp_seq, 
					man_emp_seq, 
					req_comp_seq, 
					req_emp_seq, 
					visit_distinct, 
					visitor_co, 
					visitor_nm, 
					visit_hp, 
					visit_car_no, 
					visit_dt_fr, 
					visit_tm_fr, 
					visit_aim, 
					visit_cnt, 
					approval_yn, 
					etc, 
					created_dt, 
					del_yn
				)
		VALUES ( nR_NO, 
					nManCoSeq, 
					nManUserSeq, 
					nReqCoSeq, 
					nReqUserSeq, 
					sDistnct, 
					sVisitCO, 
					sVisitNM, 
					sVisitHP, 
					sVisitCarNo, 
					sVisitFrDT, 
					sVisitFrTM, 
					sVisitAIM, 
					nVisitCnt, 
					'1', 
					sETC, 
					NOW(), 
					'0'
				);
				
		INSERT INTO Z_DUZONITGROUP_VISITORS_D (seq, r_no, visit_dt, created_dt)
		VALUES (nSeq, nR_NO, sVisitDT, NOW());
	END;
	
	ELSE
		INSERT INTO z_duzonitgroup_bs_log (log_str)
		SELECT 'insert table (distincg=2)';
		
		INSERT INTO Z_DUZONITGROUP_VISITORS_M ( r_no, 
					man_comp_seq, 
					man_emp_seq, 
					req_comp_seq, 
					req_emp_seq, 
					visit_distinct, 
					visitor_co, 
					visitor_nm, 
					visit_hp, 
					visit_car_no, 
					visit_dt_fr, 
					visit_dt_to, 
					visit_tm_fr, 
					visit_tm_to, 
					visit_aim, 
					visit_cnt, 
					approval_yn, 
					etc, 
					created_dt, 
					del_yn
				)
		VALUES ( nR_NO, 
					nManCoSeq, 
					nManUserSeq, 
					nReqCoSeq, 
					nReqUserSeq, 
					sDistnct, 
					sVisitCO, 
					sVisitNM, 
					sVisitHP, 
					sVisitCarNo, 
					sVisitFrDT, 
					sVisitToDT, 
					sVisitFrTM, 
					sVisitToTM, 
					sVisitAIM, 
					nVisitCnt, 
					'0', 
					sETC, 
					NOW(), 
					'0'
				);
	
		INSERT INTO z_duzonitgroup_bs_log (log_str)
		SELECT 'success insert table (distincg=2)';
		
		
		INSERT INTO z_duzonitgroup_bs_log (log_str)
		SELECT 'insert date';
		
		INSERT INTO z_duzonitgroup_bs_log (log_str)
		SELECT sVisitFrDT;
		
		SET FR_DATE = CAST(DATE_FORMAT(CAST(sVisitFrDT AS CHAR(10)),'%Y-%m-%d %H:%i:%s') AS CHAR(19));
		INSERT INTO z_duzonitgroup_bs_log (log_str, fr_date)
		SELECT 'fr_date', FR_DATE;
	
		SET TO_DATE = CAST(DATE_FORMAT(CAST(sVisitToDT AS CHAR(10)),'%Y-%m-%d %H:%i:%s') AS CHAR(19));
	
		INSERT INTO z_duzonitgroup_bs_log (log_str, to_date)
		SELECT 'insert date', TO_DATE;
		
		
		
		SET SEQ = 1;
		
		INSERT INTO z_duzonitgroup_bs_log (fr_date, to_date, seq)
		SELECT FR_DATE, TO_DATE, SEQ;
			
		WHILE FR_DATE <= TO_DATE	DO
			SET VISIT_DT = CAST(DATE_FORMAT(FR_DATE,'%Y%m%d') AS CHAR(8));
			
			 INSERT INTO Z_DUZONITGROUP_VISITORS_D (r_no, seq, visit_dt, created_dt)
			 VALUES (nR_NO, SEQ, VISIT_DT, NOW());
			
			SET FR_DATE = FR_DATE + INTERVAL 1 DAY;
			SET SEQ = SEQ + 1;
		END WHILE;	
			
	END IF;
END$$

DELIMITER ;


alter table t_co_comment character set utf8mb4;
alter table t_co_comment modify contents text character set utf8mb4;

*/

/*
 * v 1.2.113 
 [방문객관리]
 - 입/퇴실체크(외주인원) 조회 프로시저 수정 
 [공통]
 - 공통조직도팝업 사용자 정렬값 수정 (OrgChart.selectUserProfileList : order_num > order_text)
 */

/*
DELIMITER $$

DROP PROCEDURE IF EXISTS `Z_DUZONITGROUP_BS_VISITOR_S`$$

CREATE PROCEDURE `Z_DUZONITGROUP_BS_VISITOR_S`(
	IN `nRNo` INT
	,
	IN `sDistinct` VARCHAR(1)
	,
	IN `sFrDT` VARCHAR(20)
	,
	IN `sToDT` VARCHAR(20)
	,
	IN `sType` VARCHAR(8)
	,
	IN `pDept` VARCHAR(100)
	,
	IN `pGrade` VARCHAR(100)
	,
	IN `pName` VARCHAR(100)
	,
	IN `pVisitCo` VARCHAR(100)
	,
	IN `pVisitNm` VARCHAR(100)
	,
	IN `empSeq` VARCHAR(32)
	,
	IN `userSe` VARCHAR(10)
	,
	IN `startNum` INT
	,
	IN `endNum` INT

)
BEGIN
	DECLARE sAppGradeCD VARCHAR(5);
	
	SET sAppGradeCD = CASE WHEN (
						SELECT approver_emp_seq 
						FROM Z_DUZONITGROUP_VISITORS_M 
						WHERE r_no = nRNo) = NULL
					THEN ''
					WHEN (
						SELECT approver_emp_seq
						FROM Z_DUZONITGROUP_VISITORS_M 
						WHERE r_no = nRNo) > 0
					THEN (
						SELECT get_emp_duty_position_name(b.group_seq,b.comp_seq,b.dept_duty_code,'DUTY','kr') 
						FROM Z_DUZONITGROUP_VISITORS_M A 
						JOIN v_user_info B 
						ON A.approver_emp_seq = B.emp_seq AND A.approver_comp_seq = B.comp_seq
						WHERE B.main_dept_yn = 'y'
						LIMIT 0,1)
					END;
	
	IF sDistinct = 1 THEN 
		BEGIN
		
		
			IF nRNo = 0 THEN
			BEGIN
				SELECT 
				a.r_no, 
				IFNULL(b.seq, 0) AS seq,
				e.comp_name man_comp_name,
 				
 				e.dept_name man_dept_name,
				
				e.emp_name man_emp_name,
				
				e.dept_name man_dept_name,
				get_emp_duty_position_name(e.group_seq,e.comp_seq,e.dept_duty_code,'DUTY','kr') man_grade_name,
				
				
				a.req_comp_seq,
				a.req_emp_seq,
				IFNULL(f.comp_name, '') AS approver_comp_name, 
				IFNULL(f.emp_name, '') AS approver_emp_name,
				IFNULL((CASE WHEN (
							SELECT approver_emp_seq
							FROM Z_DUZONITGROUP_VISITORS_M 
							WHERE r_no = a.r_no) = NULL
						THEN '' 
						WHEN (
							SELECT approver_emp_seq
							FROM Z_DUZONITGROUP_VISITORS_M 
							WHERE r_no = a.r_no) > 0 
						THEN (
							SELECT get_emp_duty_position_name(b.group_seq,b.comp_seq,b.dept_duty_code,'DUTY','kr') 
							FROM Z_DUZONITGROUP_VISITORS_M A 
							JOIN v_user_info B 
							ON A.approver_emp_seq = B.emp_seq AND A.approver_comp_seq = B.comp_seq AND B.main_dept_yn = 'Y' AND B.emp_lang_code='kr'
							WHERE B.main_dept_yn = '1'
							LIMIT 0,1) 
						END), '') AS approver_grade,
				a.visit_distinct,
				a.visitor_co,
				a.visitor_nm,
				a.visit_hp,
				a.visit_car_no,
				a.visit_aim,
				a.visit_cnt,
				DATE_FORMAT(STR_TO_DATE(a.visit_dt_fr, '%Y%m%d'),'%Y-%m-%d') visit_dt_fr,
				
				IFNULL(a.visit_dt_to, '') AS visit_dt_to,
				IFNULL(a.visit_tm_fr, '') AS visit_tm_fr,
				IFNULL(a.visit_tm_to, '') AS visit_tm_to, 
				a.approval_yn,
				DATE_FORMAT(STR_TO_DATE(b.visit_dt, '%Y%m%d'),'%Y-%m-%d') visit_dt,
				
				CASE WHEN b.in_time != '' THEN CONCAT(SUBSTR(IFNULL(b.in_time,''),1,2),':',SUBSTR(IFNULL(b.in_time,''),3,2)) END AS in_time,
				CASE WHEN b.out_time != '' THEN CONCAT(SUBSTR(IFNULL(b.out_time,''),1,2),':',SUBSTR(IFNULL(b.out_time,''),3,2)) END AS out_time,
				
				IFNULL(b.visit_card_no, '') AS visit_card_no,
				IFNULL(a.etc, '') AS etc
			FROM Z_DUZONITGROUP_VISITORS_M a
			LEFT OUTER JOIN Z_DUZONITGROUP_VISITORS_D b ON a.r_no = b.r_no
			JOIN v_user_info e ON a.man_emp_seq = e.emp_seq AND a.man_comp_seq = e.comp_seq 
			LEFT JOIN v_user_info f ON a.approver_emp_seq = f.emp_seq AND a.approver_comp_seq = f.comp_seq AND f.main_dept_yn = 'Y' AND f.emp_lang_code = 'kr'
			
			WHERE a.visit_distinct = 1 AND a.del_yn != 1 AND e.main_dept_yn = 'Y' AND e.emp_lang_code = 'kr'				 
				  AND (a.visit_dt_fr >= sFrDT AND a.visit_dt_fr <= sToDT)
				 AND IFNULL(e.dept_name,'') LIKE CONCAT('%' ,pDept, '%')
				 AND IFNULL(get_emp_duty_position_name(e.group_seq,e.comp_seq,e.dept_duty_code,'DUTY','kr'),'') LIKE CONCAT('%' ,pGrade, '%')
				 
				 AND IFNULL(e.emp_name,'') LIKE CONCAT('%' ,pName, '%')
				 AND IFNULL(a.visitor_co,'') LIKE CONCAT('%' ,pVisitCo, '%')
				 AND IFNULL(a.visitor_nm,'') LIKE CONCAT('%' ,pVisitNm, '%')
				 AND a.req_emp_seq = CASE WHEN userSe = 'USER' THEN empSeq ELSE a.req_emp_seq END
				 
 				 ORDER BY a.visit_dt_fr DESC
 				 
 				
 				 
				LIMIT startNum, endNum;
			END;
			
			ELSE
				SELECT 
				a.r_no, 
				IFNULL(b.seq, 0) AS seq,				
				e.comp_name man_comp_name,
				e.dept_seq AS man_dept_seq, 
				e.dept_name man_dept_name,
				
				e.emp_name man_emp_name,
				get_emp_duty_position_name(e.group_seq,e.comp_seq,e.dept_duty_code,'DUTY','kr') man_grade_name,
				
				
				a.req_comp_seq,
				a.req_emp_seq,
				
				
				
				IFNULL(f.comp_name, '') AS approver_comp_name, 
				IFNULL(f.emp_name, '') AS approver_emp_name, 
				IFNULL(sAppGradeCD, '') AS approver_grade,
				a.visit_distinct,
				a.visitor_co,
				a.visitor_nm,
				a.visit_hp,
				a.visit_car_no,
				a.visit_aim,
				a.visit_cnt,
				a.visit_dt_fr,
				IFNULL(a.visit_dt_to, '') AS visit_dt_to,
				IFNULL(a.visit_tm_fr, '') AS visit_tm_fr,
				IFNULL(a.visit_tm_to, '') AS visit_tm_to, 
				a.approval_yn,
				b.visit_dt,
				IFNULL(b.in_time, '') AS in_time, 
				IFNULL(b.out_time, '') AS out_time, 
				IFNULL(b.visit_card_no, '') AS visit_card_no,
				IFNULL(a.etc, '') AS etc
				FROM Z_DUZONITGROUP_VISITORS_M a
				
				LEFT OUTER JOIN Z_DUZONITGROUP_VISITORS_D b ON a.r_no = b.r_no
				
				
				LEFT JOIN v_user_info e ON a.man_emp_seq = e.emp_seq AND a.man_comp_seq = e.comp_seq AND e.emp_lang_code = 'kr'
				LEFT JOIN v_user_info f ON a.approver_emp_seq = f.emp_seq AND a.approver_comp_seq = f.comp_seq AND f.main_dept_yn = 'Y' AND f.emp_lang_code = 'kr'
				WHERE a.visit_distinct = 1 AND a.del_yn != 1 AND a.r_no = nRNo  AND e.main_dept_yn = 'Y' AND e.emp_lang_code = 'kr'
			
				AND e.dept_name LIKE CONCAT('%' ,pDept, '%')
				AND IFNULL(get_emp_duty_position_name(e.group_seq,e.comp_seq,e.dept_duty_code,'DUTY','kr'),'') LIKE CONCAT('%' ,pGrade, '%')
				
				AND e.emp_name LIKE CONCAT('%' ,pName, '%')
				AND a.visitor_co LIKE CONCAT('%' ,pVisitCo, '%')
				AND a.visitor_nm LIKE CONCAT('%' ,pVisitNm, '%')
				AND a.req_emp_seq = CASE WHEN userSe = 'USER' THEN empSeq ELSE a.req_emp_seq END
				ORDER BY a.visit_dt_fr DESC
				LIMIT startNum, endNum;
		   END IF;
		END;
	
	ELSE
		IF nRNo = 0 THEN
		BEGIN
			IF sType = 'check' THEN
			BEGIN
				SELECT 
				a.r_no,
				b.seq,
				e.comp_name man_comp_name,
				e.dept_seq AS man_dept_seq,
				
				e.dept_name man_dept_name,
				
				get_comp_emp_dp(e.comp_seq,e.dept_duty_code,'DUTY','kr') man_grade_name,
				
				
				e.emp_name man_emp_name,
				
				a.req_comp_seq,
				a.req_emp_seq,
				IFNULL(f.comp_name, '') AS approver_comp_name, 
				IFNULL(f.emp_name, '') AS approver_emp_name,
				IFNULL((CASE WHEN (
							SELECT approver_comp_seq
							FROM Z_DUZONITGROUP_VISITORS_M
							WHERE r_no = a.r_no) = NULL
						THEN ''
						WHEN (
							SELECT approver_emp_seq
							FROM Z_DUZONITGROUP_VISITORS_M
							WHERE r_no = a.r_no) > 0
						THEN (
							SELECT get_emp_duty_position_name(b.group_seq,b.comp_seq,b.dept_duty_code,'DUTY','kr') 
							FROM Z_DUZONITGROUP_VISITORS_M A
							JOIN v_user_info b
							ON A.approver_emp_seq = B.emp_seq AND A.approver_comp_seq = B.comp_seq AND B.main_dept_yn = 'Y' AND B.emp_lang_code='kr'
							WHERE B.main_dept_yn = 'Y'							
							
							
							
							LIMIT 0,1)
						END), '') AS approver_grade,
				a.visit_distinct, 
				a.visitor_co, 
				a.visitor_nm, 
				a.visit_hp, 
				a.visit_car_no, 
				a.visit_aim, 
				a.visit_cnt, 
				DATE_FORMAT(STR_TO_DATE(b.visit_dt, '%Y%m%d'),'%Y-%m-%d') visit_dt_fr,
				DATE_FORMAT(STR_TO_DATE(a.visit_dt_fr, '%Y%m%d'),'%Y-%m-%d') visit_dt,
				IFNULL(a.visit_dt_to, '') AS visit_dt_to, 
				IFNULL(a.visit_tm_fr, '') AS visit_tm_fr, 
				IFNULL(a.visit_tm_to, '') AS visit_tm_to, 
				a.approval_yn, 
				CASE WHEN b.in_time != '' THEN CONCAT(SUBSTR(IFNULL(b.in_time,''),1,2),':',SUBSTR(IFNULL(b.in_time,''),3,2)) END AS in_time,
				CASE WHEN b.out_time != '' THEN CONCAT(SUBSTR(IFNULL(b.out_time,''),1,2),':',SUBSTR(IFNULL(b.out_time,''),3,2)) END AS out_time,
				
				
				IFNULL(b.visit_card_no, '') AS visit_card_no,
				IFNULL(a.etc, '') AS etc
				
				FROM Z_DUZONITGROUP_VISITORS_M a
				LEFT OUTER JOIN Z_DUZONITGROUP_VISITORS_D b ON a.r_no = b.r_no
				LEFT JOIN v_user_info e ON a.man_emp_seq = e.emp_seq AND a.man_comp_seq = e.comp_seq AND e.emp_lang_code = 'kr'
				LEFT JOIN v_user_info f ON a.approver_emp_seq = f.emp_seq AND a.approver_comp_seq = f.comp_seq AND f.main_dept_yn = 'Y' AND f.emp_lang_code = 'kr'
				
				
				
				WHERE 
					a.visit_distinct = 2 
					AND e.main_dept_yn = 'Y' 
					AND a.del_yn != 1
					AND (b.visit_dt >= sFrDT AND b.visit_dt <= sToDT)
					AND e.dept_name LIKE CONCAT('%' ,pDept, '%')
					AND a.approval_yn = 1
					AND IFNULL(get_emp_duty_position_name(e.group_seq,e.comp_seq,e.dept_duty_code,'DUTY','kr'),'') LIKE CONCAT('%' ,pGrade, '%')
					
					AND e.emp_name LIKE CONCAT('%' ,pName, '%')
					AND a.visitor_co LIKE CONCAT('%' ,pVisitCo, '%')
					AND a.visitor_nm LIKE CONCAT('%' ,pVisitNm, '%')
					AND a.req_emp_seq = CASE WHEN userSe = 'USER' THEN empSeq ELSE a.req_emp_seq END
					ORDER BY DATE_FORMAT(STR_TO_DATE(b.visit_dt, '%Y%m%d'),'%Y-%m-%d') DESC
				LIMIT startNum, endNum;
			END;
			
			ELSE
				SELECT 
				a.r_no, 
				0 AS seq,
				e.comp_name man_comp_name,
				
				e.dept_seq AS man_dept_seq,
				
				e.dept_name man_dept_name,
				
				get_emp_duty_position_name(e.group_seq,e.comp_seq,e.dept_duty_code,'DUTY','kr') man_grade_name,
				
				
				e.emp_name man_emp_name,
				
				a.req_comp_seq, 
				a.req_emp_seq, 
		
				IFNULL(f.comp_name, '') AS approver_comp_name, 
				IFNULL(f.emp_name, '') AS approver_emp_name, 
				IFNULL((CASE WHEN (
							SELECT approver_emp_seq 
							FROM Z_DUZONITGROUP_VISITORS_M 
							WHERE r_no = a.r_no) = NULL
						THEN '' 
						WHEN (
							SELECT approver_emp_seq 
							FROM Z_DUZONITGROUP_VISITORS_M 
							WHERE r_no = a.r_no) > 0 
						THEN (
							SELECT get_emp_duty_position_name(b.group_seq,b.comp_seq,b.dept_duty_code,'DUTY','kr') 
							FROM Z_DUZONITGROUP_VISITORS_M A 
							JOIN v_user_info B 
							ON A.approver_emp_seq = B.emp_seq AND A.approver_comp_seq = B.comp_seq AND B.main_dept_yn = 'Y' 
							WHERE B.main_dept_yn = 'Y'
							LIMIT 0,1) 
						END), '') AS approver_grade,
				a.visit_distinct, 
				a.visitor_co, 
				a.visitor_nm, 
				a.visit_hp, 
				a.visit_car_no, 
				a.visit_aim, 
				a.visit_cnt, 
				DATE_FORMAT(STR_TO_DATE(a.visit_dt_fr, '%Y%m%d'),'%Y-%m-%d') visit_dt_fr,
				
				DATE_FORMAT(STR_TO_DATE(IFNULL(a.visit_dt_to, ''), '%Y%m%d'),'%Y-%m-%d') visit_dt_to,
				
				a.visit_tm_fr, 
				a.visit_tm_fr visit_dt,
				IFNULL(a.visit_tm_to, '') AS visit_tm_to, 
				CASE WHEN a.approval_yn = 0 THEN '대기' WHEN a.approval_yn = 1 THEN '승인'  ELSE '반려' END approval_yn,
				'' AS in_time, 
				'' AS out_time, 
				'' AS visit_card_no,
				IFNULL(a.etc, '') AS etc
					
				FROM Z_DUZONITGROUP_VISITORS_M a
				JOIN v_user_info e ON a.man_emp_seq = e.emp_seq AND a.man_comp_seq = e.comp_seq 
				LEFT JOIN v_user_info f ON a.approver_emp_seq = f.emp_seq AND a.approver_comp_seq = f.comp_seq AND f.main_dept_yn = 'Y' AND f.emp_lang_code = 'kr'
				
				
				WHERE 
					a.visit_distinct = 2 
					 AND e.main_dept_yn = 'Y'
					 AND a.del_yn != 1
					 AND e.emp_lang_code='kr'
					 AND ((a.visit_dt_fr BETWEEN sFrDT AND sToDT) OR (a.visit_dt_to BETWEEN sFrDT AND sToDT))
					 AND e.dept_name LIKE CONCAT('%' ,pDept, '%')
					 AND IFNULL(get_emp_duty_position_name(e.group_seq,e.comp_seq,e.dept_duty_code,'DUTY','kr'),'') LIKE CONCAT('%' ,pGrade, '%')
				    
				    AND e.emp_name LIKE CONCAT('%' ,pName, '%')
				    AND a.visitor_co LIKE CONCAT('%' ,pVisitCo, '%')
				    AND a.visitor_nm LIKE CONCAT('%' ,pVisitNm, '%')
				    AND a.req_emp_seq = CASE WHEN userSe = 'USER' THEN empSeq ELSE a.req_emp_seq END
				    ORDER BY a.visit_dt_fr DESC
				LIMIT startNum, endNum;
				  
				  
				  
				  
				
				
				
				
			
			END IF;
		END;
		
		ELSE
			SELECT 
			a.r_no, 
			0 AS seq,
			e.comp_name man_comp_name,
			
			e.dept_seq AS man_dept_seq,
			
			e.dept_name man_dept_name,
			
			get_emp_duty_position_name(e.group_seq,e.comp_seq,e.dept_duty_code,'DUTY','kr') man_grade_name,
			
			
			e.emp_name man_emp_name,
			
			a.req_comp_seq, 
			a.req_emp_seq, 
			IFNULL(f.comp_name, '') AS approver_comp_name, 
			IFNULL(f.emp_name, '') AS approver_emp_name, 
			IFNULL(sAppGradeCD, '') AS approver_grade,
			a.visit_distinct, 
			a.visitor_co, 
			a.visitor_nm, 
			a.visit_hp, 
			a.visit_car_no, 
			a.visit_aim, 
			a.visit_cnt, 
			DATE_FORMAT(STR_TO_DATE(a.visit_dt_fr, '%Y%m%d'),'%Y-%m-%d') visit_dt_fr,
			DATE_FORMAT(STR_TO_DATE(a.visit_dt_fr, '%Y%m%d'),'%Y-%m-%d') visit_dt,
			
			DATE_FORMAT(STR_TO_DATE(IFNULL(a.visit_dt_to, ''), '%Y%m%d'),'%Y-%m-%d') visit_dt_to,
			
			a.visit_tm_fr, 
			IFNULL(a.visit_tm_to, '') AS visit_tm_to, 
			a.approval_yn, 
			'' AS in_time, 
			'' AS out_time, 
			'' AS visit_card_no,
			IFNULL(a.etc, '') AS etc
			
		FROM Z_DUZONITGROUP_VISITORS_M a
		
		
		JOIN v_user_info e ON a.man_emp_seq = e.emp_seq AND a.man_comp_seq = e.comp_seq 
		LEFT JOIN v_user_info f ON a.approver_emp_seq = f.emp_seq AND a.approver_comp_seq = f.comp_seq AND f.main_dept_yn = 'Y' AND f.emp_lang_code = 'kr'
		WHERE 
			a.visit_distinct = 2 
			AND e.main_dept_yn = 'Y' 
			AND a.del_yn != 1
			AND a.r_no = nRNo
			ORDER BY a.visit_dt_fr DESC
		LIMIT startNum, endNum;
		END IF;
	END IF;
END$$

DELIMITER ;

*/ 
-- 소스시퀀스  11173

/*
ALTER TABLE oneffice_recent_document ADD INDEX IF NOT EXISTS idx_recent_userid (user_id);


CREATE TABLE IF NOT EXISTS `z_duzonitgroup_tmap_connect` (
`comp_seq` VARCHAR(32) NULL DEFAULT NULL,
`storeId` VARCHAR(50) NULL DEFAULT NULL COMMENT '입주사 아이디',
`parkingLotId` VARCHAR(50) NULL DEFAULT NULL COMMENT '주차장 아이디',
`maxParkingCount` INT(11) NOT NULL COMMENT '주차장 최대 주차 개수'
)
COMMENT='t_map 연동 정보 테이블\r\n'
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;

ALTER TABLE `z_duzonitgroup_visitors_m`
	ADD COLUMN IF NOT EXISTS `t_map_seq` VARCHAR(32) NULL DEFAULT NULL COMMENT 't_map 주차권 연동 seq' AFTER `visit_place_name`;

ALTER TABLE `z_duzonitgroup_visitors_m`
	ADD COLUMN IF NOT EXISTS `visit_car_in_time` CHAR(4) NULL DEFAULT NULL COMMENT '방문객 차량 입차시간' AFTER `t_map_seq`;

ALTER TABLE `z_duzonitgroup_visitors_m`
	ADD COLUMN IF NOT EXISTS `visit_car_out_time` CHAR(4) NULL DEFAULT NULL COMMENT '방문객 차량 출차시간' AFTER `visit_car_in_time`;


ALTER TABLE `z_duzonitgroup_visitors_req`
	ADD COLUMN IF NOT EXISTS `visit_car_in_time` CHAR(4) NULL DEFAULT NULL COMMENT '방문객 차량 입차시간' AFTER `elct_appv_doc_id`;

ALTER TABLE `z_duzonitgroup_visitors_req`
	ADD COLUMN IF NOT EXISTS `visit_car_out_time` CHAR(4) NULL DEFAULT NULL COMMENT '방문객 차량 출차시간' AFTER `visit_car_in_time`;
*/


-- 소스시퀀스  11191


/*
 * v 1.2.114 
 [공통]
 - Attend 공통조직도팝업 사용자 비라이센스 검색용 API 추가(selectFilterdUserProfileListAttend)
 - 한국보육진흥원 그룹웨어 웹 취약점 조치 : 정보누출 /webapp/html/egovframework 폴더 삭제
 - 한국보육진흥원 그룹웨어 웹 취약점 조치 : 관리자페이지 노출 (web.xml <login-config> 제거)
 [시스템설정]
 - 퇴사처리팝업 > 발송권한 화면 AUTH_TYPE = 1:대내 / 2:대외 오타수정
 [원피스]
 - 한국보육진흥원 그룹웨어 웹 취약점 조치 : 파일 업로드 그림/동영상 업로드시 jsp 확장자 서버 업로드 체크 처리
  [방문객관리]
 - 입/퇴실체크(외주인원) 조회 프로시저 수정 (내림차순 -> 오름차순)
 */

-- 소스시퀀스 11314


/*
 * v 1.2.114 2차 소스취합분
 * */
-----------------------
/*
INSERT IGNORE INTO `t_co_group_path` (`group_seq`, `path_seq`, `path_name`, `os_type`, `absol_path`, `avail_capac`, `total_capac`, `module_capac`, `limit_file_count`, `create_seq`, `create_date`, `modify_seq`, `modify_date`, `drm_use_yn`, `drm_upload`, `drm_download`, `drm_file_extsn`) VALUES ('varGroupId', '1600', '원피스', 'linux', '/home/upload/oneffice', '0', '0', NULL, 0, NULL, NULL, NULL, NULL, 'N', 'E', 'E', NULL);
INSERT IGNORE INTO `t_co_group_path` (`group_seq`, `path_seq`, `path_name`, `os_type`, `absol_path`, `avail_capac`, `total_capac`, `module_capac`, `limit_file_count`, `create_seq`, `create_date`, `modify_seq`, `modify_date`, `drm_use_yn`, `drm_upload`, `drm_download`, `drm_file_extsn`) VALUES ('varGroupId', '1600', '원피스', 'windows', 'd:/upload/oneffice', '0', '0', NULL, 0, NULL, NULL, NULL, NULL, 'N', 'E', 'E', NULL);


DELIMITER $$

DROP PROCEDURE IF EXISTS `Z_DUZONITGROUP_BS_VISITOR_S`$$

CREATE PROCEDURE `Z_DUZONITGROUP_BS_VISITOR_S`(
	IN `nRNo` INT
	,
	IN `sDistinct` VARCHAR(1)
	,
	IN `sFrDT` VARCHAR(20)
	,
	IN `sToDT` VARCHAR(20)
	,
	IN `sType` VARCHAR(8)
	,
	IN `pDept` VARCHAR(100)
	,
	IN `pGrade` VARCHAR(100)
	,
	IN `pName` VARCHAR(100)
	,
	IN `pVisitCo` VARCHAR(100)
	,
	IN `pVisitNm` VARCHAR(100)
	,
	IN `empSeq` VARCHAR(32)
	,
	IN `userSe` VARCHAR(10)
	,
	IN `startNum` INT
	,
	IN `endNum` INT


)
BEGIN
	DECLARE sAppGradeCD VARCHAR(5);
	
	SET sAppGradeCD = CASE WHEN (
						SELECT approver_emp_seq 
						FROM Z_DUZONITGROUP_VISITORS_M 
						WHERE r_no = nRNo) = NULL
					THEN ''
					WHEN (
						SELECT approver_emp_seq
						FROM Z_DUZONITGROUP_VISITORS_M 
						WHERE r_no = nRNo) > 0
					THEN (
						SELECT get_emp_duty_position_name(b.group_seq,b.comp_seq,b.dept_duty_code,'DUTY','kr') 
						FROM Z_DUZONITGROUP_VISITORS_M A 
						JOIN v_user_info B 
						ON A.approver_emp_seq = B.emp_seq AND A.approver_comp_seq = B.comp_seq
						WHERE B.main_dept_yn = 'y'
						LIMIT 0,1)
					END;
	
	IF sDistinct = 1 THEN 
		BEGIN
		
		
			IF nRNo = 0 THEN
			BEGIN
				SELECT 
				a.r_no, 
				IFNULL(b.seq, 0) AS seq,
				e.comp_name man_comp_name,
 				
 				e.dept_name man_dept_name,
				
				e.emp_name man_emp_name,
				
				e.dept_name man_dept_name,
				get_emp_duty_position_name(e.group_seq,e.comp_seq,e.dept_duty_code,'DUTY','kr') man_grade_name,
				
				
				a.req_comp_seq,
				a.req_emp_seq,
				IFNULL(f.comp_name, '') AS approver_comp_name, 
				IFNULL(f.emp_name, '') AS approver_emp_name,
				IFNULL((CASE WHEN (
							SELECT approver_emp_seq
							FROM Z_DUZONITGROUP_VISITORS_M 
							WHERE r_no = a.r_no) = NULL
						THEN '' 
						WHEN (
							SELECT approver_emp_seq
							FROM Z_DUZONITGROUP_VISITORS_M 
							WHERE r_no = a.r_no) > 0 
						THEN (
							SELECT get_emp_duty_position_name(b.group_seq,b.comp_seq,b.dept_duty_code,'DUTY','kr') 
							FROM Z_DUZONITGROUP_VISITORS_M A 
							JOIN v_user_info B 
							ON A.approver_emp_seq = B.emp_seq AND A.approver_comp_seq = B.comp_seq AND B.main_dept_yn = 'Y' AND B.emp_lang_code='kr'
							WHERE B.main_dept_yn = '1'
							LIMIT 0,1) 
						END), '') AS approver_grade,
				a.visit_distinct,
				a.visitor_co,
				a.visitor_nm,
				a.visit_hp,
				a.visit_car_no,
				a.visit_aim,
				a.visit_cnt,
				DATE_FORMAT(STR_TO_DATE(a.visit_dt_fr, '%Y%m%d'),'%Y-%m-%d') visit_dt_fr,
				
				IFNULL(a.visit_dt_to, '') AS visit_dt_to,
				IFNULL(a.visit_tm_fr, '') AS visit_tm_fr,
				IFNULL(a.visit_tm_to, '') AS visit_tm_to, 
				a.approval_yn,
				DATE_FORMAT(STR_TO_DATE(b.visit_dt, '%Y%m%d'),'%Y-%m-%d') visit_dt,
				
				CASE WHEN b.in_time != '' THEN CONCAT(SUBSTR(IFNULL(b.in_time,''),1,2),':',SUBSTR(IFNULL(b.in_time,''),3,2)) END AS in_time,
				CASE WHEN b.out_time != '' THEN CONCAT(SUBSTR(IFNULL(b.out_time,''),1,2),':',SUBSTR(IFNULL(b.out_time,''),3,2)) END AS out_time,
				
				IFNULL(b.visit_card_no, '') AS visit_card_no,
				IFNULL(a.etc, '') AS etc
			FROM Z_DUZONITGROUP_VISITORS_M a
			LEFT OUTER JOIN Z_DUZONITGROUP_VISITORS_D b ON a.r_no = b.r_no
			JOIN v_user_info e ON a.man_emp_seq = e.emp_seq AND a.man_comp_seq = e.comp_seq 
			LEFT JOIN v_user_info f ON a.approver_emp_seq = f.emp_seq AND a.approver_comp_seq = f.comp_seq AND f.main_dept_yn = 'Y' AND f.emp_lang_code = 'kr'
			
			WHERE a.visit_distinct = 1 AND a.del_yn != 1 AND e.main_dept_yn = 'Y' AND e.emp_lang_code = 'kr'				 
				  AND (a.visit_dt_fr >= sFrDT AND a.visit_dt_fr <= sToDT)
				 AND IFNULL(e.dept_name,'') LIKE CONCAT('%' ,pDept, '%')
				 AND IFNULL(get_emp_duty_position_name(e.group_seq,e.comp_seq,e.dept_duty_code,'DUTY','kr'),'') LIKE CONCAT('%' ,pGrade, '%')
				 
				 AND IFNULL(e.emp_name,'') LIKE CONCAT('%' ,pName, '%')
				 AND IFNULL(a.visitor_co,'') LIKE CONCAT('%' ,pVisitCo, '%')
				 AND IFNULL(a.visitor_nm,'') LIKE CONCAT('%' ,pVisitNm, '%')
				 AND a.req_emp_seq = CASE WHEN userSe = 'USER' THEN empSeq ELSE a.req_emp_seq END
				 
 				 ORDER BY a.visit_dt_fr DESC
 				 
 				
 				 
				LIMIT startNum, endNum;
			END;
			
			ELSE
				SELECT 
				a.r_no, 
				IFNULL(b.seq, 0) AS seq,				
				e.comp_name man_comp_name,
				e.dept_seq AS man_dept_seq, 
				e.dept_name man_dept_name,
				
				e.emp_name man_emp_name,
				get_emp_duty_position_name(e.group_seq,e.comp_seq,e.dept_duty_code,'DUTY','kr') man_grade_name,
				
				
				a.req_comp_seq,
				a.req_emp_seq,
				
				
				
				IFNULL(f.comp_name, '') AS approver_comp_name, 
				IFNULL(f.emp_name, '') AS approver_emp_name, 
				IFNULL(sAppGradeCD, '') AS approver_grade,
				a.visit_distinct,
				a.visitor_co,
				a.visitor_nm,
				a.visit_hp,
				a.visit_car_no,
				a.visit_aim,
				a.visit_cnt,
				a.visit_dt_fr,
				IFNULL(a.visit_dt_to, '') AS visit_dt_to,
				IFNULL(a.visit_tm_fr, '') AS visit_tm_fr,
				IFNULL(a.visit_tm_to, '') AS visit_tm_to, 
				a.approval_yn,
				b.visit_dt,
				IFNULL(b.in_time, '') AS in_time, 
				IFNULL(b.out_time, '') AS out_time, 
				IFNULL(b.visit_card_no, '') AS visit_card_no,
				IFNULL(a.etc, '') AS etc
				FROM Z_DUZONITGROUP_VISITORS_M a
				
				LEFT OUTER JOIN Z_DUZONITGROUP_VISITORS_D b ON a.r_no = b.r_no
				
				
				LEFT JOIN v_user_info e ON a.man_emp_seq = e.emp_seq AND a.man_comp_seq = e.comp_seq AND e.emp_lang_code = 'kr'
				LEFT JOIN v_user_info f ON a.approver_emp_seq = f.emp_seq AND a.approver_comp_seq = f.comp_seq AND f.main_dept_yn = 'Y' AND f.emp_lang_code = 'kr'
				WHERE a.visit_distinct = 1 AND a.del_yn != 1 AND a.r_no = nRNo  AND e.main_dept_yn = 'Y' AND e.emp_lang_code = 'kr'
			
				AND e.dept_name LIKE CONCAT('%' ,pDept, '%')
				AND IFNULL(get_emp_duty_position_name(e.group_seq,e.comp_seq,e.dept_duty_code,'DUTY','kr'),'') LIKE CONCAT('%' ,pGrade, '%')
				
				AND e.emp_name LIKE CONCAT('%' ,pName, '%')
				AND a.visitor_co LIKE CONCAT('%' ,pVisitCo, '%')
				AND a.visitor_nm LIKE CONCAT('%' ,pVisitNm, '%')
				AND a.req_emp_seq = CASE WHEN userSe = 'USER' THEN empSeq ELSE a.req_emp_seq END
				ORDER BY a.visit_dt_fr DESC
				LIMIT startNum, endNum;
		   END IF;
		END;
	
	ELSE
		IF nRNo = 0 THEN
		BEGIN
			IF sType = 'check' THEN
			BEGIN
				SELECT 
				a.r_no,
				b.seq,
				e.comp_name man_comp_name,
				e.dept_seq AS man_dept_seq,
				
				e.dept_name man_dept_name,
				
				get_comp_emp_dp(e.comp_seq,e.dept_duty_code,'DUTY','kr') man_grade_name,
				
				
				e.emp_name man_emp_name,
				
				a.req_comp_seq,
				a.req_emp_seq,
				IFNULL(f.comp_name, '') AS approver_comp_name, 
				IFNULL(f.emp_name, '') AS approver_emp_name,
				IFNULL((CASE WHEN (
							SELECT approver_comp_seq
							FROM Z_DUZONITGROUP_VISITORS_M
							WHERE r_no = a.r_no) = NULL
						THEN ''
						WHEN (
							SELECT approver_emp_seq
							FROM Z_DUZONITGROUP_VISITORS_M
							WHERE r_no = a.r_no) > 0
						THEN (
							SELECT get_emp_duty_position_name(b.group_seq,b.comp_seq,b.dept_duty_code,'DUTY','kr') 
							FROM Z_DUZONITGROUP_VISITORS_M A
							JOIN v_user_info b
							ON A.approver_emp_seq = B.emp_seq AND A.approver_comp_seq = B.comp_seq AND B.main_dept_yn = 'Y' AND B.emp_lang_code='kr'
							WHERE B.main_dept_yn = 'Y'							
							
							
							
							LIMIT 0,1)
						END), '') AS approver_grade,
				a.visit_distinct, 
				a.visitor_co, 
				a.visitor_nm, 
				a.visit_hp, 
				a.visit_car_no, 
				a.visit_aim, 
				a.visit_cnt, 
				DATE_FORMAT(STR_TO_DATE(b.visit_dt, '%Y%m%d'),'%Y-%m-%d') visit_dt_fr,
				DATE_FORMAT(STR_TO_DATE(a.visit_dt_fr, '%Y%m%d'),'%Y-%m-%d') visit_dt,
				IFNULL(a.visit_dt_to, '') AS visit_dt_to, 
				IFNULL(a.visit_tm_fr, '') AS visit_tm_fr, 
				IFNULL(a.visit_tm_to, '') AS visit_tm_to, 
				a.approval_yn, 
				CASE WHEN b.in_time != '' THEN CONCAT(SUBSTR(IFNULL(b.in_time,''),1,2),':',SUBSTR(IFNULL(b.in_time,''),3,2)) END AS in_time,
				CASE WHEN b.out_time != '' THEN CONCAT(SUBSTR(IFNULL(b.out_time,''),1,2),':',SUBSTR(IFNULL(b.out_time,''),3,2)) END AS out_time,
				
				
				IFNULL(b.visit_card_no, '') AS visit_card_no,
				IFNULL(a.etc, '') AS etc
				
				FROM Z_DUZONITGROUP_VISITORS_M a
				LEFT OUTER JOIN Z_DUZONITGROUP_VISITORS_D b ON a.r_no = b.r_no
				LEFT JOIN v_user_info e ON a.man_emp_seq = e.emp_seq AND a.man_comp_seq = e.comp_seq AND e.emp_lang_code = 'kr'
				LEFT JOIN v_user_info f ON a.approver_emp_seq = f.emp_seq AND a.approver_comp_seq = f.comp_seq AND f.main_dept_yn = 'Y' AND f.emp_lang_code = 'kr'
				
				
				
				WHERE 
					a.visit_distinct = 2 
					AND e.main_dept_yn = 'Y' 
					AND a.del_yn != 1
					AND (b.visit_dt >= sFrDT AND b.visit_dt <= sToDT)
					AND e.dept_name LIKE CONCAT('%' ,pDept, '%')
					AND a.approval_yn = 1
					AND IFNULL(get_emp_duty_position_name(e.group_seq,e.comp_seq,e.dept_duty_code,'DUTY','kr'),'') LIKE CONCAT('%' ,pGrade, '%')
					
					AND e.emp_name LIKE CONCAT('%' ,pName, '%')
					AND a.visitor_co LIKE CONCAT('%' ,pVisitCo, '%')
					AND a.visitor_nm LIKE CONCAT('%' ,pVisitNm, '%')
					AND a.req_emp_seq = CASE WHEN userSe = 'USER' THEN empSeq ELSE a.req_emp_seq END
					ORDER BY DATE_FORMAT(STR_TO_DATE(b.visit_dt, '%Y%m%d'),'%Y-%m-%d')
				LIMIT startNum, endNum;
			END;
			
			ELSE
				SELECT 
				a.r_no, 
				0 AS seq,
				e.comp_name man_comp_name,
				
				e.dept_seq AS man_dept_seq,
				
				e.dept_name man_dept_name,
				
				get_emp_duty_position_name(e.group_seq,e.comp_seq,e.dept_duty_code,'DUTY','kr') man_grade_name,
				
				
				e.emp_name man_emp_name,
				
				a.req_comp_seq, 
				a.req_emp_seq, 
		
				IFNULL(f.comp_name, '') AS approver_comp_name, 
				IFNULL(f.emp_name, '') AS approver_emp_name, 
				IFNULL((CASE WHEN (
							SELECT approver_emp_seq 
							FROM Z_DUZONITGROUP_VISITORS_M 
							WHERE r_no = a.r_no) = NULL
						THEN '' 
						WHEN (
							SELECT approver_emp_seq 
							FROM Z_DUZONITGROUP_VISITORS_M 
							WHERE r_no = a.r_no) > 0 
						THEN (
							SELECT get_emp_duty_position_name(b.group_seq,b.comp_seq,b.dept_duty_code,'DUTY','kr') 
							FROM Z_DUZONITGROUP_VISITORS_M A 
							JOIN v_user_info B 
							ON A.approver_emp_seq = B.emp_seq AND A.approver_comp_seq = B.comp_seq AND B.main_dept_yn = 'Y' 
							WHERE B.main_dept_yn = 'Y'
							LIMIT 0,1) 
						END), '') AS approver_grade,
				a.visit_distinct, 
				a.visitor_co, 
				a.visitor_nm, 
				a.visit_hp, 
				a.visit_car_no, 
				a.visit_aim, 
				a.visit_cnt, 
				DATE_FORMAT(STR_TO_DATE(a.visit_dt_fr, '%Y%m%d'),'%Y-%m-%d') visit_dt_fr,
				
				DATE_FORMAT(STR_TO_DATE(IFNULL(a.visit_dt_to, ''), '%Y%m%d'),'%Y-%m-%d') visit_dt_to,
				
				a.visit_tm_fr, 
				a.visit_tm_fr visit_dt,
				IFNULL(a.visit_tm_to, '') AS visit_tm_to, 
				CASE WHEN a.approval_yn = 0 THEN '대기' WHEN a.approval_yn = 1 THEN '승인'  ELSE '반려' END approval_yn,
				'' AS in_time, 
				'' AS out_time, 
				'' AS visit_card_no,
				IFNULL(a.etc, '') AS etc
					
				FROM Z_DUZONITGROUP_VISITORS_M a
				JOIN v_user_info e ON a.man_emp_seq = e.emp_seq AND a.man_comp_seq = e.comp_seq 
				LEFT JOIN v_user_info f ON a.approver_emp_seq = f.emp_seq AND a.approver_comp_seq = f.comp_seq AND f.main_dept_yn = 'Y' AND f.emp_lang_code = 'kr'
				
				
				WHERE 
					a.visit_distinct = 2 
					 AND e.main_dept_yn = 'Y'
					 AND a.del_yn != 1
					 AND e.emp_lang_code='kr'
					 AND ((a.visit_dt_fr BETWEEN sFrDT AND sToDT) OR (a.visit_dt_to BETWEEN sFrDT AND sToDT))
					 AND e.dept_name LIKE CONCAT('%' ,pDept, '%')
					 AND IFNULL(get_emp_duty_position_name(e.group_seq,e.comp_seq,e.dept_duty_code,'DUTY','kr'),'') LIKE CONCAT('%' ,pGrade, '%')
				    
				    AND e.emp_name LIKE CONCAT('%' ,pName, '%')
				    AND a.visitor_co LIKE CONCAT('%' ,pVisitCo, '%')
				    AND a.visitor_nm LIKE CONCAT('%' ,pVisitNm, '%')
				    AND a.req_emp_seq = CASE WHEN userSe = 'USER' THEN empSeq ELSE a.req_emp_seq END
				    ORDER BY a.visit_dt_fr DESC
				LIMIT startNum, endNum;
				  
				  
				  
				  
				
				
				
				
			
			END IF;
		END;
		
		ELSE
			SELECT 
			a.r_no, 
			0 AS seq,
			e.comp_name man_comp_name,
			
			e.dept_seq AS man_dept_seq,
			
			e.dept_name man_dept_name,
			
			get_emp_duty_position_name(e.group_seq,e.comp_seq,e.dept_duty_code,'DUTY','kr') man_grade_name,
			
			
			e.emp_name man_emp_name,
			
			a.req_comp_seq, 
			a.req_emp_seq, 
			IFNULL(f.comp_name, '') AS approver_comp_name, 
			IFNULL(f.emp_name, '') AS approver_emp_name, 
			IFNULL(sAppGradeCD, '') AS approver_grade,
			a.visit_distinct, 
			a.visitor_co, 
			a.visitor_nm, 
			a.visit_hp, 
			a.visit_car_no, 
			a.visit_aim, 
			a.visit_cnt, 
			DATE_FORMAT(STR_TO_DATE(a.visit_dt_fr, '%Y%m%d'),'%Y-%m-%d') visit_dt_fr,
			DATE_FORMAT(STR_TO_DATE(a.visit_dt_fr, '%Y%m%d'),'%Y-%m-%d') visit_dt,
			
			DATE_FORMAT(STR_TO_DATE(IFNULL(a.visit_dt_to, ''), '%Y%m%d'),'%Y-%m-%d') visit_dt_to,
			
			a.visit_tm_fr, 
			IFNULL(a.visit_tm_to, '') AS visit_tm_to, 
			a.approval_yn, 
			'' AS in_time, 
			'' AS out_time, 
			'' AS visit_card_no,
			IFNULL(a.etc, '') AS etc
			
		FROM Z_DUZONITGROUP_VISITORS_M a
		
		
		JOIN v_user_info e ON a.man_emp_seq = e.emp_seq AND a.man_comp_seq = e.comp_seq 
		LEFT JOIN v_user_info f ON a.approver_emp_seq = f.emp_seq AND a.approver_comp_seq = f.comp_seq AND f.main_dept_yn = 'Y' AND f.emp_lang_code = 'kr'
		WHERE 
			a.visit_distinct = 2 
			AND e.main_dept_yn = 'Y' 
			AND a.del_yn != 1
			AND a.r_no = nRNo
			ORDER BY a.visit_dt_fr DESC
		LIMIT startNum, endNum;
		END IF;
	END IF;
END$$

DELIMITER ;
*/
-----------------------
-- 소스시퀀스 : 11335



/*
 * v 1.2.115 
 [확장기능] 방문객관리 - 방문객 리스트 조회 프로시저 수정(입실/퇴실 시간 조회 조건 수정)
 [시스템설정] 회사정보관리 - 회사접속정보 탭 타이틀명 한글저장 안되는 오류 수정
 [시스템설정] 항목별 알림설정 - 일장관리 모듈 항목 추가 및 수정 스크립트 
 [시스템설정] 조직도정보관리 - 부서 or 사업장 약칭 저장 제한 수정 / 부서명, 상위부서명 홑따옴표, 겹따옴표 처리 수정
 [공통] 비영리전자결재 포틀릿 긴급아이콘 url 수정
 */

/*
DELIMITER $$

DROP PROCEDURE IF EXISTS `Z_DUZONITGROUP_BS_VISITOR_S`$$

CREATE PROCEDURE `Z_DUZONITGROUP_BS_VISITOR_S`(
	IN `nRNo` INT
	,
	IN `sDistinct` VARCHAR(1)
	,
	IN `sFrDT` VARCHAR(20)
	,
	IN `sToDT` VARCHAR(20)
	,
	IN `sType` VARCHAR(8)
	,
	IN `pDept` VARCHAR(100)
	,
	IN `pGrade` VARCHAR(100)
	,
	IN `pName` VARCHAR(100)
	,
	IN `pVisitCo` VARCHAR(100)
	,
	IN `pVisitNm` VARCHAR(100)
	,
	IN `empSeq` VARCHAR(32)
	,
	IN `userSe` VARCHAR(10)
	,
	IN `startNum` INT
	,
	IN `endNum` INT



)
BEGIN
	DECLARE sAppGradeCD VARCHAR(5);
	
	SET sAppGradeCD = CASE WHEN (
						SELECT approver_emp_seq 
						FROM Z_DUZONITGROUP_VISITORS_M 
						WHERE r_no = nRNo) = NULL
					THEN ''
					WHEN (
						SELECT approver_emp_seq
						FROM Z_DUZONITGROUP_VISITORS_M 
						WHERE r_no = nRNo) > 0
					THEN (
						SELECT get_emp_duty_position_name(b.group_seq,b.comp_seq,b.dept_duty_code,'DUTY','kr') 
						FROM Z_DUZONITGROUP_VISITORS_M A 
						JOIN v_user_info B 
						ON A.approver_emp_seq = B.emp_seq AND A.approver_comp_seq = B.comp_seq
						WHERE B.main_dept_yn = 'y'
						LIMIT 0,1)
					END;
	
	IF sDistinct = 1 THEN 
		BEGIN
		
		
			IF nRNo = 0 THEN
			BEGIN
				SELECT 
				a.r_no, 
				IFNULL(b.seq, 0) AS seq,
				e.comp_name man_comp_name,		
 				e.dept_name man_dept_name,			
				e.emp_name man_emp_name,			
				e.dept_name man_dept_name,
				get_emp_duty_position_name(e.group_seq,e.comp_seq,e.dept_duty_code,'DUTY','kr') man_grade_name,							
				a.req_comp_seq,
				a.req_emp_seq,
				IFNULL(f.comp_name, '') AS approver_comp_name, 
				IFNULL(f.emp_name, '') AS approver_emp_name,
				IFNULL((CASE WHEN (
							SELECT approver_emp_seq
							FROM Z_DUZONITGROUP_VISITORS_M 
							WHERE r_no = a.r_no) = NULL
						THEN '' 
						WHEN (
							SELECT approver_emp_seq
							FROM Z_DUZONITGROUP_VISITORS_M 
							WHERE r_no = a.r_no) > 0 
						THEN (
							SELECT get_emp_duty_position_name(b.group_seq,b.comp_seq,b.dept_duty_code,'DUTY','kr') 
							FROM Z_DUZONITGROUP_VISITORS_M A 
							JOIN v_user_info B 
							ON A.approver_emp_seq = B.emp_seq AND A.approver_comp_seq = B.comp_seq AND B.main_dept_yn = 'Y' AND B.emp_lang_code='kr'
							WHERE B.main_dept_yn = '1'
							LIMIT 0,1) 
						END), '') AS approver_grade,
				a.visit_distinct,
				a.visitor_co,
				a.visitor_nm,
				a.visit_hp,
				a.visit_car_no,
				a.visit_aim,
				a.visit_cnt,
				DATE_FORMAT(STR_TO_DATE(a.visit_dt_fr, '%Y%m%d'),'%Y-%m-%d') visit_dt_fr,				
				IFNULL(a.visit_dt_to, '') AS visit_dt_to,
				IFNULL(a.visit_tm_fr, '') AS visit_tm_fr,
				IFNULL(a.visit_tm_to, '') AS visit_tm_to, 
				a.approval_yn,
				DATE_FORMAT(STR_TO_DATE(b.visit_dt, '%Y%m%d'),'%Y-%m-%d') visit_dt,				
				CASE WHEN b.in_time != '' THEN CONCAT(SUBSTR(IFNULL(b.in_time,''),1,2),':',SUBSTR(IFNULL(b.in_time,''),3,2)) END AS in_time,
				CASE WHEN b.out_time != '' THEN CONCAT(SUBSTR(IFNULL(b.out_time,''),1,2),':',SUBSTR(IFNULL(b.out_time,''),3,2)) END AS out_time,
				b.in_time AS f_in_time ,
				b.out_time AS f_out_time,			
				IFNULL(b.visit_card_no, '') AS visit_card_no,
				IFNULL(a.etc, '') AS etc
			FROM Z_DUZONITGROUP_VISITORS_M a
			LEFT OUTER JOIN Z_DUZONITGROUP_VISITORS_D b ON a.r_no = b.r_no
			JOIN v_user_info e ON a.man_emp_seq = e.emp_seq AND a.man_comp_seq = e.comp_seq 
			LEFT JOIN v_user_info f ON a.approver_emp_seq = f.emp_seq AND a.approver_comp_seq = f.comp_seq AND f.main_dept_yn = 'Y' AND f.emp_lang_code = 'kr'
			
			WHERE a.visit_distinct = 1 AND a.del_yn != 1 AND e.main_dept_yn = 'Y' AND e.emp_lang_code = 'kr'				 
				  AND (a.visit_dt_fr >= sFrDT AND a.visit_dt_fr <= sToDT)
				 AND IFNULL(e.dept_name,'') LIKE CONCAT('%' ,pDept, '%')
				 AND IFNULL(get_emp_duty_position_name(e.group_seq,e.comp_seq,e.dept_duty_code,'DUTY','kr'),'') LIKE CONCAT('%' ,pGrade, '%')	 
				 AND IFNULL(e.emp_name,'') LIKE CONCAT('%' ,pName, '%')
				 AND IFNULL(a.visitor_co,'') LIKE CONCAT('%' ,pVisitCo, '%')
				 AND IFNULL(a.visitor_nm,'') LIKE CONCAT('%' ,pVisitNm, '%')
				 AND a.req_emp_seq = CASE WHEN userSe = 'USER' THEN empSeq ELSE a.req_emp_seq END			 
 				 ORDER BY a.visit_dt_fr DESC			 					 
				LIMIT startNum, endNum;
			END;
			
			ELSE
				SELECT 
				a.r_no, 
				IFNULL(b.seq, 0) AS seq,				
				e.comp_name man_comp_name,
				e.dept_seq AS man_dept_seq, 
				e.dept_name man_dept_name,				
				e.emp_name man_emp_name,
				get_emp_duty_position_name(e.group_seq,e.comp_seq,e.dept_duty_code,'DUTY','kr') man_grade_name,								
				a.req_comp_seq,
				a.req_emp_seq,				
				IFNULL(f.comp_name, '') AS approver_comp_name, 
				IFNULL(f.emp_name, '') AS approver_emp_name, 
				IFNULL(sAppGradeCD, '') AS approver_grade,
				a.visit_distinct,
				a.visitor_co,
				a.visitor_nm,
				a.visit_hp,
				a.visit_car_no,
				a.visit_aim,
				a.visit_cnt,
				a.visit_dt_fr,
				IFNULL(a.visit_dt_to, '') AS visit_dt_to,
				IFNULL(a.visit_tm_fr, '') AS visit_tm_fr,
				IFNULL(a.visit_tm_to, '') AS visit_tm_to, 
				a.approval_yn,
				b.visit_dt,
				IFNULL(b.in_time, '') AS in_time, 
				IFNULL(b.out_time, '') AS out_time, 
				IFNULL(b.visit_card_no, '') AS visit_card_no,
				IFNULL(a.etc, '') AS etc
				FROM Z_DUZONITGROUP_VISITORS_M a				
				LEFT OUTER JOIN Z_DUZONITGROUP_VISITORS_D b ON a.r_no = b.r_no				
				LEFT JOIN v_user_info e ON a.man_emp_seq = e.emp_seq AND a.man_comp_seq = e.comp_seq AND e.emp_lang_code = 'kr'
				LEFT JOIN v_user_info f ON a.approver_emp_seq = f.emp_seq AND a.approver_comp_seq = f.comp_seq AND f.main_dept_yn = 'Y' AND f.emp_lang_code = 'kr'
				WHERE a.visit_distinct = 1 AND a.del_yn != 1 AND a.r_no = nRNo  AND e.main_dept_yn = 'Y' AND e.emp_lang_code = 'kr'
				AND e.dept_name LIKE CONCAT('%' ,pDept, '%')
				AND IFNULL(get_emp_duty_position_name(e.group_seq,e.comp_seq,e.dept_duty_code,'DUTY','kr'),'') LIKE CONCAT('%' ,pGrade, '%')			
				AND e.emp_name LIKE CONCAT('%' ,pName, '%')
				AND a.visitor_co LIKE CONCAT('%' ,pVisitCo, '%')
				AND a.visitor_nm LIKE CONCAT('%' ,pVisitNm, '%')
				AND a.req_emp_seq = CASE WHEN userSe = 'USER' THEN empSeq ELSE a.req_emp_seq END
				ORDER BY a.visit_dt_fr DESC
				LIMIT startNum, endNum;
		   END IF;
		END;
	
	ELSE
		IF nRNo = 0 THEN
		BEGIN
			IF sType = 'check' THEN
			BEGIN
				SELECT 
				a.r_no,
				b.seq,
				e.comp_name man_comp_name,
				e.dept_seq AS man_dept_seq,
				e.dept_name man_dept_name,			
				get_comp_emp_dp(e.comp_seq,e.dept_duty_code,'DUTY','kr') man_grade_name,
				e.emp_name man_emp_name,			
				a.req_comp_seq,
				a.req_emp_seq,
				IFNULL(f.comp_name, '') AS approver_comp_name, 
				IFNULL(f.emp_name, '') AS approver_emp_name,
				IFNULL((CASE WHEN (
							SELECT approver_comp_seq
							FROM Z_DUZONITGROUP_VISITORS_M
							WHERE r_no = a.r_no) = NULL
						THEN ''
						WHEN (
							SELECT approver_emp_seq
							FROM Z_DUZONITGROUP_VISITORS_M
							WHERE r_no = a.r_no) > 0
						THEN (
							SELECT get_emp_duty_position_name(b.group_seq,b.comp_seq,b.dept_duty_code,'DUTY','kr') 
							FROM Z_DUZONITGROUP_VISITORS_M A
							JOIN v_user_info b
							ON A.approver_emp_seq = B.emp_seq AND A.approver_comp_seq = B.comp_seq AND B.main_dept_yn = 'Y' AND B.emp_lang_code='kr'
							WHERE B.main_dept_yn = 'Y'							
							LIMIT 0,1)
						END), '') AS approver_grade,
				a.visit_distinct, 
				a.visitor_co, 
				a.visitor_nm, 
				a.visit_hp, 
				a.visit_car_no, 
				a.visit_aim, 
				a.visit_cnt, 
				DATE_FORMAT(STR_TO_DATE(b.visit_dt, '%Y%m%d'),'%Y-%m-%d') visit_dt_fr,
				DATE_FORMAT(STR_TO_DATE(a.visit_dt_fr, '%Y%m%d'),'%Y-%m-%d') visit_dt,
				IFNULL(a.visit_dt_to, '') AS visit_dt_to, 
				IFNULL(a.visit_tm_fr, '') AS visit_tm_fr, 
				IFNULL(a.visit_tm_to, '') AS visit_tm_to, 
				a.approval_yn, 
				CASE WHEN b.in_time != '' THEN CONCAT(SUBSTR(IFNULL(b.in_time,''),1,2),':',SUBSTR(IFNULL(b.in_time,''),3,2)) END AS in_time,
				CASE WHEN b.out_time != '' THEN CONCAT(SUBSTR(IFNULL(b.out_time,''),1,2),':',SUBSTR(IFNULL(b.out_time,''),3,2)) END AS out_time,		
				b.in_time AS f_in_time,
				b.out_time AS f_out_time,
				IFNULL(b.visit_card_no, '') AS visit_card_no,
				IFNULL(a.etc, '') AS etc
				FROM Z_DUZONITGROUP_VISITORS_M a
				LEFT OUTER JOIN Z_DUZONITGROUP_VISITORS_D b ON a.r_no = b.r_no
				LEFT JOIN v_user_info e ON a.man_emp_seq = e.emp_seq AND a.man_comp_seq = e.comp_seq AND e.emp_lang_code = 'kr'
				LEFT JOIN v_user_info f ON a.approver_emp_seq = f.emp_seq AND a.approver_comp_seq = f.comp_seq AND f.main_dept_yn = 'Y' AND f.emp_lang_code = 'kr'
				WHERE 
					a.visit_distinct = 2 
					AND e.main_dept_yn = 'Y' 
					AND a.del_yn != 1
					AND (b.visit_dt >= sFrDT AND b.visit_dt <= sToDT)
					AND e.dept_name LIKE CONCAT('%' ,pDept, '%')
					AND a.approval_yn = 1
					AND IFNULL(get_emp_duty_position_name(e.group_seq,e.comp_seq,e.dept_duty_code,'DUTY','kr'),'') LIKE CONCAT('%' ,pGrade, '%')
					AND e.emp_name LIKE CONCAT('%' ,pName, '%')
					AND a.visitor_co LIKE CONCAT('%' ,pVisitCo, '%')
					AND a.visitor_nm LIKE CONCAT('%' ,pVisitNm, '%')
					AND a.req_emp_seq = CASE WHEN userSe = 'USER' THEN empSeq ELSE a.req_emp_seq END
					ORDER BY DATE_FORMAT(STR_TO_DATE(b.visit_dt, '%Y%m%d'),'%Y-%m-%d')
				LIMIT startNum, endNum;
			END;
			
			ELSE
				SELECT 
				a.r_no, 
				0 AS seq,
				e.comp_name man_comp_name,
				e.dept_seq AS man_dept_seq,			
				e.dept_name man_dept_name,		
				get_emp_duty_position_name(e.group_seq,e.comp_seq,e.dept_duty_code,'DUTY','kr') man_grade_name,							
				e.emp_name man_emp_name,			
				a.req_comp_seq, 
				a.req_emp_seq, 
				IFNULL(f.comp_name, '') AS approver_comp_name, 
				IFNULL(f.emp_name, '') AS approver_emp_name, 
				IFNULL((CASE WHEN (
							SELECT approver_emp_seq 
							FROM Z_DUZONITGROUP_VISITORS_M 
							WHERE r_no = a.r_no) = NULL
						THEN '' 
						WHEN (
							SELECT approver_emp_seq 
							FROM Z_DUZONITGROUP_VISITORS_M 
							WHERE r_no = a.r_no) > 0 
						THEN (
							SELECT get_emp_duty_position_name(b.group_seq,b.comp_seq,b.dept_duty_code,'DUTY','kr') 
							FROM Z_DUZONITGROUP_VISITORS_M A 
							JOIN v_user_info B 
							ON A.approver_emp_seq = B.emp_seq AND A.approver_comp_seq = B.comp_seq AND B.main_dept_yn = 'Y' 
							WHERE B.main_dept_yn = 'Y'
							LIMIT 0,1) 
						END), '') AS approver_grade,
				a.visit_distinct, 
				a.visitor_co, 
				a.visitor_nm, 
				a.visit_hp, 
				a.visit_car_no, 
				a.visit_aim, 
				a.visit_cnt, 
				DATE_FORMAT(STR_TO_DATE(a.visit_dt_fr, '%Y%m%d'),'%Y-%m-%d') visit_dt_fr,
				DATE_FORMAT(STR_TO_DATE(IFNULL(a.visit_dt_to, ''), '%Y%m%d'),'%Y-%m-%d') visit_dt_to,
				a.visit_tm_fr, 
				a.visit_tm_fr visit_dt,
				IFNULL(a.visit_tm_to, '') AS visit_tm_to, 
				CASE WHEN a.approval_yn = 0 THEN '대기' WHEN a.approval_yn = 1 THEN '승인'  ELSE '반려' END approval_yn,
				'' AS in_time, 
				'' AS out_time, 
				'' AS visit_card_no,
				IFNULL(a.etc, '') AS etc
				FROM Z_DUZONITGROUP_VISITORS_M a
				JOIN v_user_info e ON a.man_emp_seq = e.emp_seq AND a.man_comp_seq = e.comp_seq 
				LEFT JOIN v_user_info f ON a.approver_emp_seq = f.emp_seq AND a.approver_comp_seq = f.comp_seq AND f.main_dept_yn = 'Y' AND f.emp_lang_code = 'kr'							
				WHERE 
					a.visit_distinct = 2 
					 AND e.main_dept_yn = 'Y'
					 AND a.del_yn != 1
					 AND e.emp_lang_code='kr'
					 AND ((a.visit_dt_fr BETWEEN sFrDT AND sToDT) OR (a.visit_dt_to BETWEEN sFrDT AND sToDT))
					 AND e.dept_name LIKE CONCAT('%' ,pDept, '%')
					 AND IFNULL(get_emp_duty_position_name(e.group_seq,e.comp_seq,e.dept_duty_code,'DUTY','kr'),'') LIKE CONCAT('%' ,pGrade, '%')		    
				    AND e.emp_name LIKE CONCAT('%' ,pName, '%')
				    AND a.visitor_co LIKE CONCAT('%' ,pVisitCo, '%')
				    AND a.visitor_nm LIKE CONCAT('%' ,pVisitNm, '%')
				    AND a.req_emp_seq = CASE WHEN userSe = 'USER' THEN empSeq ELSE a.req_emp_seq END
				    ORDER BY a.visit_dt_fr DESC
				LIMIT startNum, endNum;
			
			END IF;
		END;
		
		ELSE
			SELECT 
			a.r_no, 
			0 AS seq,
			e.comp_name man_comp_name,
			e.dept_seq AS man_dept_seq,
			e.dept_name man_dept_name,
			get_emp_duty_position_name(e.group_seq,e.comp_seq,e.dept_duty_code,'DUTY','kr') man_grade_name,
			e.emp_name man_emp_name,
			a.req_comp_seq, 
			a.req_emp_seq, 
			IFNULL(f.comp_name, '') AS approver_comp_name, 
			IFNULL(f.emp_name, '') AS approver_emp_name, 
			IFNULL(sAppGradeCD, '') AS approver_grade,
			a.visit_distinct, 
			a.visitor_co, 
			a.visitor_nm, 
			a.visit_hp, 
			a.visit_car_no, 
			a.visit_aim, 
			a.visit_cnt, 
			DATE_FORMAT(STR_TO_DATE(a.visit_dt_fr, '%Y%m%d'),'%Y-%m-%d') visit_dt_fr,
			DATE_FORMAT(STR_TO_DATE(a.visit_dt_fr, '%Y%m%d'),'%Y-%m-%d') visit_dt,
			DATE_FORMAT(STR_TO_DATE(IFNULL(a.visit_dt_to, ''), '%Y%m%d'),'%Y-%m-%d') visit_dt_to,
			a.visit_tm_fr, 
			IFNULL(a.visit_tm_to, '') AS visit_tm_to, 
			a.approval_yn, 
			'' AS in_time, 
			'' AS out_time, 
			'' AS visit_card_no,
			IFNULL(a.etc, '') AS etc
		FROM Z_DUZONITGROUP_VISITORS_M a
		JOIN v_user_info e ON a.man_emp_seq = e.emp_seq AND a.man_comp_seq = e.comp_seq 
		LEFT JOIN v_user_info f ON a.approver_emp_seq = f.emp_seq AND a.approver_comp_seq = f.comp_seq AND f.main_dept_yn = 'Y' AND f.emp_lang_code = 'kr'
		WHERE 
			a.visit_distinct = 2 
			AND e.main_dept_yn = 'Y' 
			AND a.del_yn != 1
			AND a.r_no = nRNo
			ORDER BY a.visit_dt_fr DESC
		LIMIT startNum, endNum;
		END IF;
	END IF;
END$$

DELIMITER ;


 update t_co_code_detail_multi set note='일정 등록 시 알림 사용여부(개인캘린더-초대일정 포함)' where detail_code='SC001' and lang_code='kr';
 update t_co_code_detail_multi set note='일정 수정 시 예약 알림 사용여부(개인캘린더-초대일정 포함)' where detail_code='SC015' and lang_code='kr';

 INSERT IGNORE INTO t_alert_setting
(comp_seq, group_seq, alert_type, alert_yn, push_yn, talk_yn, mail_yn, sms_yn, portal_yn, timeline_yn, use_yn, create_seq, create_date, modify_seq, modify_date, divide_type, link_event)
VALUES('SYSTEM', 'SYSTEM', 'SC013', 'Y', 'Y', 'N', 'N', 'N', 'Y', 'N', 'Y', '0', '2020-07-14 19:54:34.0', '0', '2020-07-14 19:54:34.0', 'CM', NULL);

INSERT IGNORE INTO t_co_code_detail
(detail_code, code, ischild, order_num, flag_1, flag_2, use_yn, create_seq, create_date, modify_seq, modify_date)
VALUES('SC013', 'COM510', 'N', 2, 'SCHEDULE', '일정', 'Y', NULL, NULL, NULL, NULL);

INSERT IGNORE INTO t_co_code_detail_multi
(detail_code, code, lang_code, detail_name, note, use_yn, create_seq, create_date, modify_seq, modify_date)
VALUES('SC013', 'COM510', 'kr', '초대 일정 나가기 알림', '개인 초대 일정 나가기 시 알림 사용여부(초대자가 나간 경우)', 'Y', NULL, NULL, NULL, NULL);

INSERT IGNORE INTO t_alert_setting
(comp_seq, group_seq, alert_type, alert_yn, push_yn, talk_yn, mail_yn, sms_yn, portal_yn, timeline_yn, use_yn, create_seq, create_date, modify_seq, modify_date, divide_type, link_event)
VALUES('SYSTEM', 'SYSTEM', 'SC014', 'Y', 'Y', 'N', 'N', 'N', 'Y', 'N', 'Y', '0', '2020-07-14 19:54:34.0', '0', '2020-07-14 19:54:34.0', 'CM', NULL);


INSERT IGNORE INTO t_co_code_detail
(detail_code, code, ischild, order_num, flag_1, flag_2, use_yn, create_seq, create_date, modify_seq, modify_date)
VALUES('SC014', 'COM510', 'N', 2, 'SCHEDULE', '일정', 'Y', NULL, NULL, NULL, NULL);

INSERT IGNORE INTO t_co_code_detail_multi
(detail_code, code, lang_code, detail_name, note, use_yn, create_seq, create_date, modify_seq, modify_date)
VALUES('SC014', 'COM510', 'kr', '초대 일정 삭제 알림', '개인 초대 일정 삭제 시 알림 사용여부(주최자가 삭제한 경우)', 'Y', NULL, NULL, NULL, NULL);

update t_co_code_detail set order_num='1' where detail_code='SC001';
update t_co_code_detail set order_num='2' where detail_code='SC002';
update t_co_code_detail set order_num='3' where detail_code='SC015';
update t_co_code_detail set order_num='4' where detail_code='SC005';
update t_co_code_detail set order_num='5' where detail_code='SC013';
update t_co_code_detail set order_num='6' where detail_code='SC014';
update t_co_code_detail set order_num='7' where detail_code='RP001';
update t_co_code_detail set order_num='8' where detail_code='RP002';
update t_co_code_detail set order_num='9' where detail_code='RP003';
update t_co_code_detail set order_num='10' where detail_code='RP004';

--소스시퀀스 11437
*/   

/*
 * v 1.2.116 
 [공통] 웹/메신저 사용자 부부서 프로필 정보 조회 시 회사 전화, 팩스번호, 주소 조회 불가 오류 수정
 [공통] TRG_T_CO_COMP_MULTI_AU / TRG_T_CO_BIZ_MULTI_AU 약칭 변경 시 하위값들도 변경되도록 수정
 [공통] 조직도 관련 트리거 t_co_orgchart_name 부서 insert시 display_path_name 값 회사명 뒤에 '|' 누락 수정
 [공통] 하단 조직도팝업 마스터 권한시 트리에 모든 회사 나오도록 수정
 [통합검색]
- pdf 뷰어보기 되도록 개선
- IE에서 파일저장시 파일명 깨지는 현상 수정
- hwp 뷰어보기시 에러발생 수정
- 페이징 처리 이동버튼 4개로 개선
 */

/*
DELIMITER $$
DROP TRIGGER IF EXISTS `TRG_T_CO_COMP_MULTI_AU`$$
CREATE TRIGGER `TRG_T_CO_COMP_MULTI_AU` AFTER UPDATE ON t_co_comp_multi FOR EACH ROW
BEGIN
    DECLARE V_SAME_CNT int(11);

    INSERT INTO t_co_comp_multi_history (
		op_code,
		reg_date,
		group_seq,
		comp_seq,
		lang_code,
		comp_name,
		comp_display_name,
		owner_name,
		sender_name,
		biz_condition,
		item,
		addr,
		detail_addr,
		use_yn,
		create_seq,
		create_date,
		modify_seq,
		modify_date,
		comp_nickname
    )
    VALUES (
        'U',
        NOW(),
		NEW.group_seq,
		NEW.comp_seq,
		NEW.lang_code,
		NEW.comp_name,
		NEW.comp_display_name,
		NEW.owner_name,
		NEW.sender_name,
		NEW.biz_condition,
		NEW.item,
		NEW.addr,
		NEW.detail_addr,
		NEW.use_yn,
		NEW.create_seq,
		NEW.create_date,
		NEW.modify_seq,
		NEW.modify_date,
		NEW.comp_nickname
    );
    UPDATE 
        t_co_orgchart
    SET
        task_status = CASE 
                        WHEN    task_status = '0' THEN '1'
                        WHEN    task_status = '2' THEN '3'
                        ELSE    task_status END
        , update_status = CASE
			WHEN   update_status < '99' THEN '99' 
			ELSE   update_status END 
    WHERE 
        group_seq = NEW.group_seq;
    
    
    -- 조직도 패스테이블 적용
    IF NEW.lang_code = 'kr' THEN
    
      select count(*)
      into V_SAME_CNT
      from t_co_orgchart_name con
      left join t_co_comp_multi c_en on con.comp_seq=c_en.comp_seq and c_en.lang_code='en'
      left join t_co_comp_multi c_jp on con.comp_seq=c_jp.comp_seq and c_jp.lang_code='jp'
      left join t_co_comp_multi c_cn on con.comp_seq=c_cn.comp_seq and c_cn.lang_code='cn'
      where con.gbn_org='c' and con.comp_seq=NEW.comp_seq
      and con.comp_name_kr = NEW.comp_name
      and con.comp_nickname = NEW.comp_nickname
      and con.comp_display_name = NEW.comp_display_name
      and con.comp_name_en = ifnull(c_en.comp_name, NEW.comp_name)
      and con.comp_name_jp = ifnull(c_jp.comp_name, NEW.comp_name)
      and con.comp_name_cn = ifnull(c_cn.comp_name, NEW.comp_name);
    
      delete from t_co_orgchart_name where gbn_org = 'c' and comp_seq = NEW.comp_seq;
      
      insert ignore into t_co_orgchart_name
      (org_sync_date, gbn_org, seq, parent_gbn, parent_seq, level, order_num, org_cd, org_use_yn, comp_seq, path, display_path_name_kr, display_path_name_en, display_path_name_jp, display_path_name_cn, comp_name_kr, comp_name_en, comp_name_jp, comp_name_cn, comp_display_name, comp_nickname )
      select NOW()
      ,'c'
      ,c.comp_seq
      ,'g'
      ,'0'
      ,1
      ,c.order_num
      ,c.comp_cd
      ,c.use_yn
      ,c.comp_seq
      ,c.comp_seq
      ,kr.comp_name
      ,case when ifnull(en.comp_name,'')='' then kr.comp_name else en.comp_name end
      ,case when ifnull(jp.comp_name,'')='' then kr.comp_name else jp.comp_name end
      ,case when ifnull(cn.comp_name,'')='' then kr.comp_name else cn.comp_name end
      ,kr.comp_name
      ,case when ifnull(en.comp_name,'')='' then kr.comp_name else en.comp_name end
      ,case when ifnull(jp.comp_name,'')='' then kr.comp_name else jp.comp_name end
      ,case when ifnull(cn.comp_name,'')='' then kr.comp_name else cn.comp_name end
      ,ifnull(kr.comp_display_name,'')
      ,ifnull(kr.comp_nickname,'')
      from t_co_comp c
      join t_co_comp_multi kr on kr.lang_code='kr' and c.comp_seq=kr.comp_seq
      left join t_co_comp_multi en on en.lang_code='en' and c.comp_seq=en.comp_seq
      left join t_co_comp_multi jp on jp.lang_code='jp' and c.comp_seq=jp.comp_seq
      left join t_co_comp_multi cn on cn.lang_code='cn' and c.comp_seq=cn.comp_seq
      where c.comp_seq = NEW.comp_seq;   
      
      IF IFNULL(V_SAME_CNT,0) = 0 THEN
      
        delete from t_co_orgchart_name where gbn_org in ('b','d') and comp_seq = NEW.comp_seq;
      
        insert ignore into t_co_orgchart_name
        (org_sync_date, gbn_org, seq, parent_gbn, parent_seq, level, order_num, org_cd, org_use_yn, comp_seq, biz_seq, biz_display_yn, path, display_path_name_kr, display_path_name_en, display_path_name_jp, display_path_name_cn, comp_name_kr, comp_name_en, comp_name_jp, comp_name_cn, biz_name_kr, biz_name_en, biz_name_jp, biz_name_cn, comp_display_name, comp_nickname, biz_nickname)
        select NOW()
        ,'b'
        ,b.biz_seq
        ,'c'
        ,b.comp_seq
        ,2
        ,b.order_num
        ,b.biz_cd
        ,b.use_yn
        ,b.comp_seq
        ,b.biz_seq
        ,b.display_yn
        ,concat(b.comp_seq,'|',b.biz_seq)
        ,concat(c_kr.comp_name,(case when b.display_yn = 'Y' then concat('|',b_kr.biz_name) else '' end))
        ,concat((case when ifnull(c_en.comp_name,'')='' then c_kr.comp_name else c_en.comp_name end),(case when b.display_yn = 'Y' then concat('|',(case when ifnull(b_en.biz_name,'')='' then b_kr.biz_name else b_en.biz_name end)) else '' end))
        ,concat((case when ifnull(c_jp.comp_name,'')='' then c_kr.comp_name else c_jp.comp_name end),(case when b.display_yn = 'Y' then concat('|',(case when ifnull(b_jp.biz_name,'')='' then b_kr.biz_name else b_jp.biz_name end)) else '' end))
        ,concat((case when ifnull(c_cn.comp_name,'')='' then c_kr.comp_name else c_cn.comp_name end),(case when b.display_yn = 'Y' then concat('|',(case when ifnull(b_cn.biz_name,'')='' then b_kr.biz_name else b_cn.biz_name end)) else '' end))
        ,c_kr.comp_name
        ,case when ifnull(c_en.comp_name,'')='' then c_kr.comp_name else c_en.comp_name end
        ,case when ifnull(c_jp.comp_name,'')='' then c_kr.comp_name else c_jp.comp_name end
        ,case when ifnull(c_cn.comp_name,'')='' then c_kr.comp_name else c_cn.comp_name end
        ,b_kr.biz_name
        ,case when ifnull(b_en.biz_name,'')='' then b_kr.biz_name else b_en.biz_name end
        ,case when ifnull(b_jp.biz_name,'')='' then b_kr.biz_name else b_jp.biz_name end
        ,case when ifnull(b_cn.biz_name,'')='' then b_kr.biz_name else b_cn.biz_name end
        ,ifnull(c_kr.comp_display_name,'')
        ,ifnull(c_kr.comp_nickname,'')
        ,ifnull(b_kr.biz_nickname,'')
        from t_co_biz b
        join t_co_biz_multi b_kr on b_kr.lang_code='kr' and b.biz_seq=b_kr.biz_seq
        left join t_co_biz_multi b_en on b_en.lang_code='en' and b.biz_seq=b_en.biz_seq
        left join t_co_biz_multi b_jp on b_jp.lang_code='jp' and b.biz_seq=b_jp.biz_seq
        left join t_co_biz_multi b_cn on b_cn.lang_code='cn' and b.biz_seq=b_cn.biz_seq
        join t_co_comp_multi c_kr on c_kr.lang_code='kr' and b.comp_seq=c_kr.comp_seq
        left join t_co_comp_multi c_en on c_en.lang_code='en' and b.comp_seq=c_en.comp_seq
        left join t_co_comp_multi c_jp on c_jp.lang_code='jp' and b.comp_seq=c_jp.comp_seq
        left join t_co_comp_multi c_cn on c_cn.lang_code='cn' and b.comp_seq=c_cn.comp_seq
        where b.comp_seq = NEW.comp_seq;

        insert ignore into t_co_orgchart_name
        (org_sync_date, gbn_org, seq, parent_gbn, parent_seq, level, order_num, org_cd, org_use_yn, comp_seq, biz_seq, biz_display_yn, dept_seq, path, display_path_name_kr, display_path_name_en, display_path_name_jp, display_path_name_cn, comp_name_kr, comp_name_en, comp_name_jp, comp_name_cn, biz_name_kr, biz_name_en, biz_name_jp, biz_name_cn, dept_name_kr, dept_name_en, dept_name_jp, dept_name_cn, comp_display_name, comp_nickname, biz_nickname, dept_display_name, dept_nickname)
        select NOW()
        ,'d'
        ,d.dept_seq
        ,case when d.parent_dept_seq != '0' then 'd' when b.display_yn = 'Y' then 'b' else 'c' end
        ,case when d.parent_dept_seq != '0' then d.parent_dept_seq when b.display_yn = 'Y' then d.biz_seq else d.comp_seq end
        ,case when b.display_yn = 'Y' then d.dept_level + 2 else d.dept_level + 1 end
        ,d.order_num
        ,d.dept_cd
        ,d.use_yn
        ,d.comp_seq
        ,d.biz_seq
        ,b.display_yn
        ,d.dept_seq
        ,concat(d.comp_seq,'|',(case when b.display_yn = 'Y' then concat(d.biz_seq,'|') else '' end),d.path)
        ,concat(c_kr.comp_name,'|',get_dept_pathNm('|',d.dept_seq,d.group_seq,'kr'))
        ,concat(case when ifnull(c_en.comp_name,'')='' then c_kr.comp_name else c_en.comp_name end,'|',get_dept_pathNm('|',d.dept_seq,d.group_seq,'en'))
        ,concat(case when ifnull(c_jp.comp_name,'')='' then c_kr.comp_name else c_jp.comp_name end,'|',get_dept_pathNm('|',d.dept_seq,d.group_seq,'jp'))
        ,concat(case when ifnull(c_cn.comp_name,'')='' then c_kr.comp_name else c_cn.comp_name end,'|',get_dept_pathNm('|',d.dept_seq,d.group_seq,'cn'))
        ,c_kr.comp_name
        ,case when ifnull(c_en.comp_name,'')='' then c_kr.comp_name else c_en.comp_name end
        ,case when ifnull(c_jp.comp_name,'')='' then c_kr.comp_name else c_jp.comp_name end
        ,case when ifnull(c_cn.comp_name,'')='' then c_kr.comp_name else c_cn.comp_name end
        ,b_kr.biz_name
        ,case when ifnull(b_en.biz_name,'')='' then b_kr.biz_name else b_en.biz_name end
        ,case when ifnull(b_jp.biz_name,'')='' then b_kr.biz_name else b_jp.biz_name end
        ,case when ifnull(b_cn.biz_name,'')='' then b_kr.biz_name else b_cn.biz_name end
        ,d_kr.dept_name
        ,case when ifnull(d_en.dept_name,'')='' then d_kr.dept_name else d_en.dept_name end
        ,case when ifnull(d_jp.dept_name,'')='' then d_kr.dept_name else d_jp.dept_name end
        ,case when ifnull(d_cn.dept_name,'')='' then d_kr.dept_name else d_cn.dept_name end
        ,ifnull(c_kr.comp_display_name,'')
        ,ifnull(c_kr.comp_nickname,'')
        ,ifnull(b_kr.biz_nickname,'')
        ,ifnull(d_kr.dept_display_name,'')
        ,ifnull(d_kr.dept_nickname,'')
        from t_co_dept d
        join t_co_biz b on d.biz_seq = b.biz_seq
        join t_co_dept_multi d_kr on d_kr.lang_code='kr' and d.dept_seq=d_kr.dept_seq
        left join t_co_dept_multi d_en on d_en.lang_code='en' and d.dept_seq=d_en.dept_seq
        left join t_co_dept_multi d_jp on d_jp.lang_code='jp' and d.dept_seq=d_jp.dept_seq
        left join t_co_dept_multi d_cn on d_cn.lang_code='cn' and d.dept_seq=d_cn.dept_seq
        join t_co_biz_multi b_kr on b_kr.lang_code='kr' and d.biz_seq=b_kr.biz_seq
        left join t_co_biz_multi b_en on b_en.lang_code='en' and d.biz_seq=b_en.biz_seq
        left join t_co_biz_multi b_jp on b_jp.lang_code='jp' and d.biz_seq=b_jp.biz_seq
        left join t_co_biz_multi b_cn on b_cn.lang_code='cn' and d.biz_seq=b_cn.biz_seq
        join t_co_comp_multi c_kr on c_kr.lang_code='kr' and d.comp_seq=c_kr.comp_seq
        left join t_co_comp_multi c_en on c_en.lang_code='en' and d.comp_seq=c_en.comp_seq
        left join t_co_comp_multi c_jp on c_jp.lang_code='jp' and d.comp_seq=c_jp.comp_seq
        left join t_co_comp_multi c_cn on c_cn.lang_code='cn' and d.comp_seq=c_cn.comp_seq
        where d.comp_seq = NEW.comp_seq;
      END IF;
    END IF;
END$$
DELIMITER ;


DELIMITER $$
DROP TRIGGER IF EXISTS `TRG_T_CO_BIZ_MULTI_AU`$$
CREATE TRIGGER `TRG_T_CO_BIZ_MULTI_AU` AFTER UPDATE ON t_co_biz_multi FOR EACH ROW
BEGIN

    DECLARE V_SAME_CNT int(11);
    
    INSERT INTO t_co_biz_multi_history (
		op_code,
		reg_date,
		group_seq,
		comp_seq,
		biz_seq,
		lang_code,
		biz_name,
		owner_name,
		biz_condition,
		sender_name,
		biz_nickname,
		item,
		addr,
		detail_addr,
		use_yn,
		create_seq,
		create_date,
		modify_seq,
		modify_date
    )
    VALUES (
        'U',
        NOW(),
		NEW.group_seq,
		NEW.comp_seq,
		NEW.biz_seq,
		NEW.lang_code,
		NEW.biz_name,
		NEW.owner_name,
		NEW.biz_condition,
		NEW.sender_name,
		NEW.biz_nickname,
		NEW.item,
		NEW.addr,
		NEW.detail_addr,
		NEW.use_yn,
		NEW.create_seq,
		NEW.create_date,
		NEW.modify_seq,
		NEW.modify_date
    );
    UPDATE 
        t_co_orgchart
    SET
        task_status = CASE 
                        WHEN    task_status = '0' THEN '1'
                        WHEN    task_status = '2' THEN '3'
                        ELSE    task_status END
        , update_status = CASE
			WHEN   update_status < '99' THEN '99' 
			ELSE   update_status END 
    WHERE 
        group_seq = NEW.group_seq;
    
    -- 조직도 패스테이블 적용
    IF NEW.lang_code = 'kr' THEN
    
      select count(*)
      into V_SAME_CNT
      from t_co_orgchart_name con
      join t_co_biz b on con.biz_seq = b.biz_seq
      left join t_co_biz_multi b_en on con.biz_seq=b_en.biz_seq and b_en.lang_code='en'
      left join t_co_biz_multi b_jp on con.biz_seq=b_jp.biz_seq and b_jp.lang_code='jp'
      left join t_co_biz_multi b_cn on con.biz_seq=b_cn.biz_seq and b_cn.lang_code='cn'
      where con.gbn_org='b' and con.biz_seq=NEW.biz_seq
      and con.biz_display_yn = b.display_yn
      and con.biz_name_kr = NEW.biz_name
      and con.biz_nickname = NEW.biz_nickname
      and con.biz_name_en = ifnull(b_en.biz_name, NEW.biz_name)
      and con.biz_name_jp = ifnull(b_jp.biz_name, NEW.biz_name)
      and con.biz_name_cn = ifnull(b_cn.biz_name, NEW.biz_name);
    
      delete from t_co_orgchart_name where gbn_org = 'b' and biz_seq = NEW.biz_seq;
    
      insert ignore into t_co_orgchart_name
      (org_sync_date, gbn_org, seq, parent_gbn, parent_seq, level, order_num, org_cd, org_use_yn, comp_seq, biz_seq, biz_display_yn, path, display_path_name_kr, display_path_name_en, display_path_name_jp, display_path_name_cn, comp_name_kr, comp_name_en, comp_name_jp, comp_name_cn, biz_name_kr, biz_name_en, biz_name_jp, biz_name_cn, comp_display_name, comp_nickname, biz_nickname)
      select NOW()
      ,'b'
      ,b.biz_seq
      ,'c'
      ,b.comp_seq
      ,2
      ,b.order_num
      ,b.biz_cd
      ,b.use_yn
      ,b.comp_seq
      ,b.biz_seq
      ,b.display_yn
      ,concat(b.comp_seq,'|',b.biz_seq)
      ,concat(c_kr.comp_name,(case when b.display_yn = 'Y' then concat('|',b_kr.biz_name) else '' end))
      ,concat((case when ifnull(c_en.comp_name,'')='' then c_kr.comp_name else c_en.comp_name end),(case when b.display_yn = 'Y' then concat('|',(case when ifnull(b_en.biz_name,'')='' then b_kr.biz_name else b_en.biz_name end)) else '' end))
      ,concat((case when ifnull(c_jp.comp_name,'')='' then c_kr.comp_name else c_jp.comp_name end),(case when b.display_yn = 'Y' then concat('|',(case when ifnull(b_jp.biz_name,'')='' then b_kr.biz_name else b_jp.biz_name end)) else '' end))
      ,concat((case when ifnull(c_cn.comp_name,'')='' then c_kr.comp_name else c_cn.comp_name end),(case when b.display_yn = 'Y' then concat('|',(case when ifnull(b_cn.biz_name,'')='' then b_kr.biz_name else b_cn.biz_name end)) else '' end))
      ,c_kr.comp_name
      ,case when ifnull(c_en.comp_name,'')='' then c_kr.comp_name else c_en.comp_name end
      ,case when ifnull(c_jp.comp_name,'')='' then c_kr.comp_name else c_jp.comp_name end
      ,case when ifnull(c_cn.comp_name,'')='' then c_kr.comp_name else c_cn.comp_name end
      ,b_kr.biz_name
      ,case when ifnull(b_en.biz_name,'')='' then b_kr.biz_name else b_en.biz_name end
      ,case when ifnull(b_jp.biz_name,'')='' then b_kr.biz_name else b_jp.biz_name end
      ,case when ifnull(b_cn.biz_name,'')='' then b_kr.biz_name else b_cn.biz_name end
      ,ifnull(c_kr.comp_display_name,'')
      ,ifnull(c_kr.comp_nickname,'')
      ,ifnull(b_kr.biz_nickname,'')
      from t_co_biz b
      join t_co_biz_multi b_kr on b_kr.lang_code='kr' and b.biz_seq=b_kr.biz_seq
      left join t_co_biz_multi b_en on b_en.lang_code='en' and b.biz_seq=b_en.biz_seq
      left join t_co_biz_multi b_jp on b_jp.lang_code='jp' and b.biz_seq=b_jp.biz_seq
      left join t_co_biz_multi b_cn on b_cn.lang_code='cn' and b.biz_seq=b_cn.biz_seq
      join t_co_comp_multi c_kr on c_kr.lang_code='kr' and b.comp_seq=c_kr.comp_seq
      left join t_co_comp_multi c_en on c_en.lang_code='en' and b.comp_seq=c_en.comp_seq
      left join t_co_comp_multi c_jp on c_jp.lang_code='jp' and b.comp_seq=c_jp.comp_seq
      left join t_co_comp_multi c_cn on c_cn.lang_code='cn' and b.comp_seq=c_cn.comp_seq
      where b.biz_seq = NEW.biz_seq;    
    
      IF IFNULL(V_SAME_CNT,0) = 0 THEN
        delete from t_co_orgchart_name where gbn_org = 'd' and biz_seq = NEW.biz_seq;

        insert ignore into t_co_orgchart_name
        (org_sync_date, gbn_org, seq, parent_gbn, parent_seq, level, order_num, org_cd, org_use_yn, comp_seq, biz_seq, biz_display_yn, dept_seq, path, display_path_name_kr, display_path_name_en, display_path_name_jp, display_path_name_cn, comp_name_kr, comp_name_en, comp_name_jp, comp_name_cn, biz_name_kr, biz_name_en, biz_name_jp, biz_name_cn, dept_name_kr, dept_name_en, dept_name_jp, dept_name_cn, comp_display_name, comp_nickname, biz_nickname, dept_display_name, dept_nickname)
        select NOW()
        ,'d'
        ,d.dept_seq
        ,case when d.parent_dept_seq != '0' then 'd' when b.display_yn = 'Y' then 'b' else 'c' end
        ,case when d.parent_dept_seq != '0' then d.parent_dept_seq when b.display_yn = 'Y' then d.biz_seq else d.comp_seq end
        ,case when b.display_yn = 'Y' then d.dept_level + 2 else d.dept_level + 1 end
        ,d.order_num
        ,d.dept_cd
        ,d.use_yn
        ,d.comp_seq
        ,d.biz_seq
        ,b.display_yn
        ,d.dept_seq
        ,concat(d.comp_seq,'|',(case when b.display_yn = 'Y' then concat(d.biz_seq,'|') else '' end),d.path)
        ,concat(c_kr.comp_name,'|',get_dept_pathNm('|',d.dept_seq,d.group_seq,'kr'))
        ,concat(case when ifnull(c_en.comp_name,'')='' then c_kr.comp_name else c_en.comp_name end,'|',get_dept_pathNm('|',d.dept_seq,d.group_seq,'en'))
        ,concat(case when ifnull(c_jp.comp_name,'')='' then c_kr.comp_name else c_jp.comp_name end,'|',get_dept_pathNm('|',d.dept_seq,d.group_seq,'jp'))
        ,concat(case when ifnull(c_cn.comp_name,'')='' then c_kr.comp_name else c_cn.comp_name end,'|',get_dept_pathNm('|',d.dept_seq,d.group_seq,'cn'))
        ,c_kr.comp_name
        ,case when ifnull(c_en.comp_name,'')='' then c_kr.comp_name else c_en.comp_name end
        ,case when ifnull(c_jp.comp_name,'')='' then c_kr.comp_name else c_jp.comp_name end
        ,case when ifnull(c_cn.comp_name,'')='' then c_kr.comp_name else c_cn.comp_name end
        ,b_kr.biz_name
        ,case when ifnull(b_en.biz_name,'')='' then b_kr.biz_name else b_en.biz_name end
        ,case when ifnull(b_jp.biz_name,'')='' then b_kr.biz_name else b_jp.biz_name end
        ,case when ifnull(b_cn.biz_name,'')='' then b_kr.biz_name else b_cn.biz_name end
        ,d_kr.dept_name
        ,case when ifnull(d_en.dept_name,'')='' then d_kr.dept_name else d_en.dept_name end
        ,case when ifnull(d_jp.dept_name,'')='' then d_kr.dept_name else d_jp.dept_name end
        ,case when ifnull(d_cn.dept_name,'')='' then d_kr.dept_name else d_cn.dept_name end
        ,ifnull(c_kr.comp_display_name,'')
        ,ifnull(c_kr.comp_nickname,'')
        ,ifnull(b_kr.biz_nickname,'')
        ,ifnull(d_kr.dept_display_name,'')
        ,ifnull(d_kr.dept_nickname,'')
        from t_co_dept d
        join t_co_biz b on d.biz_seq = b.biz_seq
        join t_co_dept_multi d_kr on d_kr.lang_code='kr' and d.dept_seq=d_kr.dept_seq
        left join t_co_dept_multi d_en on d_en.lang_code='en' and d.dept_seq=d_en.dept_seq
        left join t_co_dept_multi d_jp on d_jp.lang_code='jp' and d.dept_seq=d_jp.dept_seq
        left join t_co_dept_multi d_cn on d_cn.lang_code='cn' and d.dept_seq=d_cn.dept_seq
        join t_co_biz_multi b_kr on b_kr.lang_code='kr' and d.biz_seq=b_kr.biz_seq
        left join t_co_biz_multi b_en on b_en.lang_code='en' and d.biz_seq=b_en.biz_seq
        left join t_co_biz_multi b_jp on b_jp.lang_code='jp' and d.biz_seq=b_jp.biz_seq
        left join t_co_biz_multi b_cn on b_cn.lang_code='cn' and d.biz_seq=b_cn.biz_seq
        join t_co_comp_multi c_kr on c_kr.lang_code='kr' and d.comp_seq=c_kr.comp_seq
        left join t_co_comp_multi c_en on c_en.lang_code='en' and d.comp_seq=c_en.comp_seq
        left join t_co_comp_multi c_jp on c_jp.lang_code='jp' and d.comp_seq=c_jp.comp_seq
        left join t_co_comp_multi c_cn on c_cn.lang_code='cn' and d.comp_seq=c_cn.comp_seq
        where d.biz_seq = NEW.biz_seq and NEW.lang_code = 'kr';
        
      END IF;
    
    END IF;

END$$
DELIMITER ;
-- 소스시퀀스 : 11566
*/

/*
DELIMITER $$
DROP TRIGGER IF EXISTS `TRG_T_CO_DEPT_MULTI_AI`$$
CREATE TRIGGER `TRG_T_CO_DEPT_MULTI_AI` AFTER INSERT ON t_co_dept_multi FOR EACH ROW
BEGIN
    
    INSERT INTO t_co_dept_multi_history (
		op_code,
		reg_date,
		group_seq,
		comp_seq,
		biz_seq,
		dept_seq,
		lang_code,
		dept_name,
		dept_display_name,
		sender_name,
		addr,
		detail_addr,
		path_name,
		use_yn,
		create_seq,
		create_date,
		modify_seq,
		modify_date,
		dept_nickname
    )
    VALUES (
        'I',
        NOW(),
        NEW.group_seq,
        NEW.comp_seq,
        NEW.biz_seq,
        NEW.dept_seq,
        NEW.lang_code,
        NEW.dept_name,
        NEW.dept_display_name,
        NEW.sender_name,
        NEW.addr,
        NEW.detail_addr,
        NEW.path_name,
        NEW.use_yn,
        NEW.create_seq,
        NEW.create_date,
        NEW.modify_seq,
        NEW.modify_date,
        NEW.dept_nickname
    );
    
    UPDATE 
        t_co_orgchart
    SET
        task_status = CASE 
                        WHEN    task_status = '0' THEN '1'  
                        WHEN    task_status = '2' THEN '3'  
                        ELSE    task_status END             
        , update_status = CASE
			WHEN   update_status < '99' THEN '99' 
			ELSE   update_status END 
    WHERE 
        group_seq = NEW.group_seq;
        
    -- 조직도 패스테이블 적용
    IF NEW.lang_code = 'kr' THEN
      
      delete from t_co_orgchart_name where dept_seq = NEW.dept_seq;
      
      insert ignore into t_co_orgchart_name
      (org_sync_date, gbn_org, seq, parent_gbn, parent_seq, level, order_num, org_cd, org_use_yn, comp_seq, biz_seq, biz_display_yn, dept_seq, path, display_path_name_kr, display_path_name_en, display_path_name_jp, display_path_name_cn, comp_name_kr, comp_name_en, comp_name_jp, comp_name_cn, biz_name_kr, biz_name_en, biz_name_jp, biz_name_cn, dept_name_kr, dept_name_en, dept_name_jp, dept_name_cn, comp_display_name, comp_nickname, biz_nickname, dept_display_name, dept_nickname)
      select NOW()
      ,'d'
      ,d.dept_seq
      ,case when d.parent_dept_seq != '0' then 'd' when b.display_yn = 'Y' then 'b' else 'c' end
      ,case when d.parent_dept_seq != '0' then d.parent_dept_seq when b.display_yn = 'Y' then d.biz_seq else d.comp_seq end
      ,case when b.display_yn = 'Y' then d.dept_level + 2 else d.dept_level + 1 end
      ,d.order_num
      ,d.dept_cd
      ,d.use_yn
      ,d.comp_seq
      ,d.biz_seq
      ,b.display_yn
      ,d.dept_seq
      ,concat(d.comp_seq,'|',(case when b.display_yn = 'Y' then concat(d.biz_seq,'|') else '' end),d.path)
      ,concat(c_kr.comp_name,'|',get_dept_pathNm('|',d.dept_seq,d.group_seq,'kr'))
      ,concat(case when ifnull(c_en.comp_name,'')='' then c_kr.comp_name else c_en.comp_name end,'|',get_dept_pathNm('|',d.dept_seq,d.group_seq,'en'))
      ,concat(case when ifnull(c_jp.comp_name,'')='' then c_kr.comp_name else c_jp.comp_name end,'|',get_dept_pathNm('|',d.dept_seq,d.group_seq,'jp'))
      ,concat(case when ifnull(c_cn.comp_name,'')='' then c_kr.comp_name else c_cn.comp_name end,'|',get_dept_pathNm('|',d.dept_seq,d.group_seq,'cn'))
      ,c_kr.comp_name
      ,case when ifnull(c_en.comp_name,'')='' then c_kr.comp_name else c_en.comp_name end
      ,case when ifnull(c_jp.comp_name,'')='' then c_kr.comp_name else c_jp.comp_name end
      ,case when ifnull(c_cn.comp_name,'')='' then c_kr.comp_name else c_cn.comp_name end
      ,b_kr.biz_name
      ,case when ifnull(b_en.biz_name,'')='' then b_kr.biz_name else b_en.biz_name end
      ,case when ifnull(b_jp.biz_name,'')='' then b_kr.biz_name else b_jp.biz_name end
      ,case when ifnull(b_cn.biz_name,'')='' then b_kr.biz_name else b_cn.biz_name end
      ,d_kr.dept_name
      ,case when ifnull(d_en.dept_name,'')='' then d_kr.dept_name else d_en.dept_name end
      ,case when ifnull(d_jp.dept_name,'')='' then d_kr.dept_name else d_jp.dept_name end
      ,case when ifnull(d_cn.dept_name,'')='' then d_kr.dept_name else d_cn.dept_name end
      ,ifnull(c_kr.comp_display_name,'')
      ,ifnull(c_kr.comp_nickname,'')
      ,ifnull(b_kr.biz_nickname,'')
      ,ifnull(d_kr.dept_display_name,'')
      ,ifnull(d_kr.dept_nickname,'')
      from t_co_dept d
      join t_co_biz b on d.biz_seq = b.biz_seq
      join t_co_dept_multi d_kr on d_kr.lang_code='kr' and d.dept_seq=d_kr.dept_seq
      left join t_co_dept_multi d_en on d_en.lang_code='en' and d.dept_seq=d_en.dept_seq
      left join t_co_dept_multi d_jp on d_jp.lang_code='jp' and d.dept_seq=d_jp.dept_seq
      left join t_co_dept_multi d_cn on d_cn.lang_code='cn' and d.dept_seq=d_cn.dept_seq
      join t_co_biz_multi b_kr on b_kr.lang_code='kr' and d.biz_seq=b_kr.biz_seq
      left join t_co_biz_multi b_en on b_en.lang_code='en' and d.biz_seq=b_en.biz_seq
      left join t_co_biz_multi b_jp on b_jp.lang_code='jp' and d.biz_seq=b_jp.biz_seq
      left join t_co_biz_multi b_cn on b_cn.lang_code='cn' and d.biz_seq=b_cn.biz_seq
      join t_co_comp_multi c_kr on c_kr.lang_code='kr' and d.comp_seq=c_kr.comp_seq
      left join t_co_comp_multi c_en on c_en.lang_code='en' and d.comp_seq=c_en.comp_seq
      left join t_co_comp_multi c_jp on c_jp.lang_code='jp' and d.comp_seq=c_jp.comp_seq
      left join t_co_comp_multi c_cn on c_cn.lang_code='cn' and d.comp_seq=c_cn.comp_seq  
      where d.dept_seq = NEW.dept_seq;            
    END IF;    
END$$
DELIMITER ;


DELIMITER $$
DROP TRIGGER IF EXISTS `TRG_T_CO_DEPT_MULTI_AU`$$
CREATE TRIGGER `TRG_T_CO_DEPT_MULTI_AU` AFTER UPDATE ON t_co_dept_multi FOR EACH ROW
BEGIN
    INSERT INTO t_co_dept_multi_history (
		op_code,
		reg_date,
		group_seq,
		comp_seq,
		biz_seq,
		dept_seq,
		lang_code,
		dept_name,
		dept_display_name,
		sender_name,
		addr,
		detail_addr,
		path_name,
		use_yn,
		create_seq,
		create_date,
		modify_seq,
		modify_date,
		dept_nickname
    )
    VALUES (
        'U',
        NOW(),
		NEW.group_seq,
		NEW.comp_seq,
		NEW.biz_seq,
		NEW.dept_seq,
		NEW.lang_code,
		NEW.dept_name,
		NEW.dept_display_name,
		NEW.sender_name,
		NEW.addr,
		NEW.detail_addr,
		NEW.path_name,
		NEW.use_yn,
		NEW.create_seq,
		NEW.create_date,
		NEW.modify_seq,
		NEW.modify_date,
		NEW.dept_nickname
    );
    UPDATE 
        t_co_orgchart
    SET
        task_status = CASE 
                        WHEN    task_status = '0' THEN '1'  
                        WHEN    task_status = '2' THEN '3'  
                        ELSE    task_status END             
        , update_status = CASE
			WHEN   update_status < '99' THEN '99' 
			ELSE   update_status END
    WHERE 
        group_seq = NEW.group_seq;
        
    -- 조직도 패스테이블 적용
    IF NEW.lang_code = 'kr' THEN
      delete from t_co_orgchart_name where dept_seq = NEW.dept_seq;

      insert ignore into t_co_orgchart_name
      (org_sync_date, gbn_org, seq, parent_gbn, parent_seq, level, order_num, org_cd, org_use_yn, comp_seq, biz_seq, biz_display_yn, dept_seq, path, display_path_name_kr, display_path_name_en, display_path_name_jp, display_path_name_cn, comp_name_kr, comp_name_en, comp_name_jp, comp_name_cn, biz_name_kr, biz_name_en, biz_name_jp, biz_name_cn, dept_name_kr, dept_name_en, dept_name_jp, dept_name_cn, comp_display_name, comp_nickname, biz_nickname, dept_display_name, dept_nickname)
      select NOW()
      ,'d'
      ,d.dept_seq
      ,case when d.parent_dept_seq != '0' then 'd' when b.display_yn = 'Y' then 'b' else 'c' end
      ,case when d.parent_dept_seq != '0' then d.parent_dept_seq when b.display_yn = 'Y' then d.biz_seq else d.comp_seq end
      ,case when b.display_yn = 'Y' then d.dept_level + 2 else d.dept_level + 1 end
      ,d.order_num
      ,d.dept_cd
      ,d.use_yn
      ,d.comp_seq
      ,d.biz_seq
      ,b.display_yn
      ,d.dept_seq
      ,concat(d.comp_seq,'|',(case when b.display_yn = 'Y' then concat(d.biz_seq,'|') else '' end),d.path)
      ,concat(c_kr.comp_name,'|',get_dept_pathNm('|',d.dept_seq,d.group_seq,'kr'))
      ,concat(case when ifnull(c_en.comp_name,'')='' then c_kr.comp_name else c_en.comp_name end,'|',get_dept_pathNm('|',d.dept_seq,d.group_seq,'en'))
      ,concat(case when ifnull(c_jp.comp_name,'')='' then c_kr.comp_name else c_jp.comp_name end,'|',get_dept_pathNm('|',d.dept_seq,d.group_seq,'jp'))
      ,concat(case when ifnull(c_cn.comp_name,'')='' then c_kr.comp_name else c_cn.comp_name end,'|',get_dept_pathNm('|',d.dept_seq,d.group_seq,'cn'))
      ,c_kr.comp_name
      ,case when ifnull(c_en.comp_name,'')='' then c_kr.comp_name else c_en.comp_name end
      ,case when ifnull(c_jp.comp_name,'')='' then c_kr.comp_name else c_jp.comp_name end
      ,case when ifnull(c_cn.comp_name,'')='' then c_kr.comp_name else c_cn.comp_name end
      ,b_kr.biz_name
      ,case when ifnull(b_en.biz_name,'')='' then b_kr.biz_name else b_en.biz_name end
      ,case when ifnull(b_jp.biz_name,'')='' then b_kr.biz_name else b_jp.biz_name end
      ,case when ifnull(b_cn.biz_name,'')='' then b_kr.biz_name else b_cn.biz_name end
      ,d_kr.dept_name
      ,case when ifnull(d_en.dept_name,'')='' then d_kr.dept_name else d_en.dept_name end
      ,case when ifnull(d_jp.dept_name,'')='' then d_kr.dept_name else d_jp.dept_name end
      ,case when ifnull(d_cn.dept_name,'')='' then d_kr.dept_name else d_cn.dept_name end
      ,ifnull(c_kr.comp_display_name,'')
      ,ifnull(c_kr.comp_nickname,'')
      ,ifnull(b_kr.biz_nickname,'')
      ,ifnull(d_kr.dept_display_name,'')
      ,ifnull(d_kr.dept_nickname,'')
      from t_co_dept d
      join t_co_biz b on d.biz_seq = b.biz_seq
      join t_co_dept_multi d_kr on d_kr.lang_code='kr' and d.dept_seq=d_kr.dept_seq
      left join t_co_dept_multi d_en on d_en.lang_code='en' and d.dept_seq=d_en.dept_seq
      left join t_co_dept_multi d_jp on d_jp.lang_code='jp' and d.dept_seq=d_jp.dept_seq
      left join t_co_dept_multi d_cn on d_cn.lang_code='cn' and d.dept_seq=d_cn.dept_seq
      join t_co_biz_multi b_kr on b_kr.lang_code='kr' and d.biz_seq=b_kr.biz_seq
      left join t_co_biz_multi b_en on b_en.lang_code='en' and d.biz_seq=b_en.biz_seq
      left join t_co_biz_multi b_jp on b_jp.lang_code='jp' and d.biz_seq=b_jp.biz_seq
      left join t_co_biz_multi b_cn on b_cn.lang_code='cn' and d.biz_seq=b_cn.biz_seq
      join t_co_comp_multi c_kr on c_kr.lang_code='kr' and d.comp_seq=c_kr.comp_seq
      left join t_co_comp_multi c_en on c_en.lang_code='en' and d.comp_seq=c_en.comp_seq
      left join t_co_comp_multi c_jp on c_jp.lang_code='jp' and d.comp_seq=c_jp.comp_seq
      left join t_co_comp_multi c_cn on c_cn.lang_code='cn' and d.comp_seq=c_cn.comp_seq  
      where d.dept_seq = NEW.dept_seq;    
    END IF;
END$$
DELIMITER ;
-- 소스시퀀스 11593
*/


/*
  - v1.2.117
  
DELIMITER $$

DROP FUNCTION IF EXISTS `get_dept_pathNm`$$

CREATE FUNCTION `get_dept_pathNm`(
	`_delimiter` TEXT,
	`_dept_seq` VARCHAR(32),
	`_group_seq` VARCHAR(32),
	`_lang_code` VARCHAR(32)
) RETURNS TEXT CHARSET utf8
    READS SQL DATA
BEGIN
    DECLARE _path TEXT;
    DECLARE _id VARCHAR(32);
    DECLARE _nm VARCHAR(32);
    DECLARE _start_with VARCHAR(32);
    DECLARE _depth INT;
    DECLARE EXIT HANDLER FOR NOT FOUND RETURN _path;
    
    SET _start_with = '0';
    SET _depth = 0;
    
    SET _id = COALESCE(_dept_seq, _start_with);
    SELECT CASE WHEN t2.parent_dept_seq = '0' AND t3.display_yn = 'Y' THEN CONCAT(FN_GetMultiLang(_lang_code, t4.biz_name_multi),'|',FN_GetMultiLang(_lang_code, t1.dept_name_multi)) ELSE FN_GetMultiLang(_lang_code, dept_name_multi) END INTO _nm  FROM v_t_co_dept_multi t1 JOIN t_co_dept t2 ON t1.dept_seq = t2.dept_seq JOIN t_co_biz t3 ON t1.biz_seq = t3.biz_seq JOIN v_t_co_biz_multi t4 ON t1.biz_seq = t4.biz_Seq WHERE t1.dept_Seq = _dept_seq AND t1.group_seq = _group_seq;
    SET _path = _nm;
    LOOP
    
        IF _depth > 15 THEN
        RETURN _path;
        END IF;
    
        SELECT  a.parent_dept_seq, CASE WHEN c.parent_dept_seq = '0' AND d.display_yn = 'Y' THEN CONCAT((SELECT FN_GetMultiLang(_lang_code, biz_name_multi) FROM v_t_co_biz_multi WHERE biz_seq = d.biz_seq LIMIT 1), _delimiter, FN_GetMultiLang(_lang_code, b.dept_name_multi)) ELSE FN_GetMultiLang(_lang_code, b.dept_name_multi) END, _depth + 1
        INTO    _id, _nm, _depth
        FROM    t_co_dept a, v_t_co_dept_multi b, t_co_dept c, t_co_biz d
        WHERE   a.group_seq = _group_seq
        AND a.group_seq = b.group_seq
        AND a.parent_dept_seq = b.dept_seq
        AND b.dept_seq = c.dept_seq
        AND c.biz_seq = d.biz_seq
        AND a.dept_seq = _id
        AND COALESCE(a.parent_dept_seq <> _start_with, TRUE)
        AND COALESCE(a.parent_dept_seq <> _dept_seq, TRUE);
        SET _path = CONCAT(_nm, _delimiter, _path);
    END LOOP;
END$$

DELIMITER ;

DELIMITER $$

DROP FUNCTION IF EXISTS `get_dept_path`$$

CREATE FUNCTION `get_dept_path`(_delimiter TEXT, _dept_seq VARCHAR(32), _group_seq VARCHAR(32)) RETURNS TEXT CHARSET utf8
    READS SQL DATA
BEGIN
    DECLARE _path TEXT;
    DECLARE _id VARCHAR(32);
    DECLARE _start_with VARCHAR(32);
    DECLARE _depth INT;
    DECLARE EXIT HANDLER FOR NOT FOUND RETURN _path;
    
    SET _start_with = '0';
    SET _depth = 0;
    SET _id = COALESCE(_dept_seq, _start_with);
    SET _path = _id;
    LOOP
        IF _depth > 15 THEN
        RETURN _path;
        END IF;
        
        SELECT  parent_dept_seq, _depth + 1
        INTO    _id, _depth
        FROM    t_co_dept
        WHERE   group_seq = _group_seq
        AND dept_seq = _id
        AND COALESCE(parent_dept_seq <> _start_with, TRUE)
        AND COALESCE(parent_dept_seq <> _dept_seq, TRUE);
        SET _path = CONCAT(_id, _delimiter, _path);
    END LOOP;
END$$

DELIMITER ;

ALTER TABLE tcmg_optionvalue CHANGE COLUMN IF EXISTS option_value option_value varchar(512);
*/
-- 소스시퀀스 : 11689



/*
DELIMITER $$
DROP TRIGGER IF EXISTS `TRG_T_CO_COMP_MULTI_AU`$$
CREATE TRIGGER `TRG_T_CO_COMP_MULTI_AU` AFTER UPDATE ON t_co_comp_multi FOR EACH ROW
BEGIN
    DECLARE V_SAME_CNT int(11);

    INSERT INTO t_co_comp_multi_history (
		op_code,
		reg_date,
		group_seq,
		comp_seq,
		lang_code,
		comp_name,
		comp_display_name,
		owner_name,
		sender_name,
		biz_condition,
		item,
		addr,
		detail_addr,
		use_yn,
		create_seq,
		create_date,
		modify_seq,
		modify_date,
		comp_nickname
    )
    VALUES (
        'U',
        NOW(),
		NEW.group_seq,
		NEW.comp_seq,
		NEW.lang_code,
		NEW.comp_name,
		NEW.comp_display_name,
		NEW.owner_name,
		NEW.sender_name,
		NEW.biz_condition,
		NEW.item,
		NEW.addr,
		NEW.detail_addr,
		NEW.use_yn,
		NEW.create_seq,
		NEW.create_date,
		NEW.modify_seq,
		NEW.modify_date,
		NEW.comp_nickname
    );
    UPDATE 
        t_co_orgchart
    SET
        task_status = CASE 
                        WHEN    task_status = '0' THEN '1'
                        WHEN    task_status = '2' THEN '3'
                        ELSE    task_status END
        , update_status = CASE
			WHEN   update_status < '99' THEN '99' 
			ELSE   update_status END 
    WHERE 
        group_seq = NEW.group_seq;
    
    
    -- 조직도 패스테이블 적용
    IF NEW.lang_code = 'kr' THEN
    
      select count(*)
      into V_SAME_CNT
      from t_co_orgchart_name con
      left join t_co_comp_multi c_en on con.comp_seq=c_en.comp_seq and c_en.lang_code='en'
      left join t_co_comp_multi c_jp on con.comp_seq=c_jp.comp_seq and c_jp.lang_code='jp'
      left join t_co_comp_multi c_cn on con.comp_seq=c_cn.comp_seq and c_cn.lang_code='cn'
      where con.gbn_org='c' and con.comp_seq=NEW.comp_seq
      and con.comp_name_kr = NEW.comp_name
      and con.comp_nickname = NEW.comp_nickname
      and con.comp_display_name = NEW.comp_display_name
      and con.comp_name_en = ifnull(c_en.comp_name, NEW.comp_name)
      and con.comp_name_jp = ifnull(c_jp.comp_name, NEW.comp_name)
      and con.comp_name_cn = ifnull(c_cn.comp_name, NEW.comp_name);
    
      delete from t_co_orgchart_name where gbn_org = 'c' and comp_seq = NEW.comp_seq;
      
      insert ignore into t_co_orgchart_name
      (org_sync_date, gbn_org, seq, parent_gbn, parent_seq, level, order_num, org_cd, org_use_yn, comp_seq, path, display_path_name_kr, display_path_name_en, display_path_name_jp, display_path_name_cn, comp_name_kr, comp_name_en, comp_name_jp, comp_name_cn, comp_display_name, comp_nickname )
      select NOW()
      ,'c'
      ,c.comp_seq
      ,'g'
      ,'0'
      ,1
      ,c.order_num
      ,c.comp_cd
      ,c.use_yn
      ,c.comp_seq
      ,c.comp_seq
      ,kr.comp_name
      ,case when ifnull(en.comp_name,'')='' then kr.comp_name else en.comp_name end
      ,case when ifnull(jp.comp_name,'')='' then kr.comp_name else jp.comp_name end
      ,case when ifnull(cn.comp_name,'')='' then kr.comp_name else cn.comp_name end
      ,kr.comp_name
      ,case when ifnull(en.comp_name,'')='' then kr.comp_name else en.comp_name end
      ,case when ifnull(jp.comp_name,'')='' then kr.comp_name else jp.comp_name end
      ,case when ifnull(cn.comp_name,'')='' then kr.comp_name else cn.comp_name end
      ,ifnull(kr.comp_display_name,'')
      ,ifnull(kr.comp_nickname,'')
      from t_co_comp c
      join t_co_comp_multi kr on kr.lang_code='kr' and c.comp_seq=kr.comp_seq
      left join t_co_comp_multi en on en.lang_code='en' and c.comp_seq=en.comp_seq
      left join t_co_comp_multi jp on jp.lang_code='jp' and c.comp_seq=jp.comp_seq
      left join t_co_comp_multi cn on cn.lang_code='cn' and c.comp_seq=cn.comp_seq
      where c.comp_seq = NEW.comp_seq;   
      
      IF IFNULL(V_SAME_CNT,0) = 0 THEN
      
        delete from t_co_orgchart_name where gbn_org in ('b','d') and comp_seq = NEW.comp_seq;
      
        insert ignore into t_co_orgchart_name
        (org_sync_date, gbn_org, seq, parent_gbn, parent_seq, level, order_num, org_cd, org_use_yn, comp_seq, biz_seq, biz_display_yn, path, display_path_name_kr, display_path_name_en, display_path_name_jp, display_path_name_cn, comp_name_kr, comp_name_en, comp_name_jp, comp_name_cn, biz_name_kr, biz_name_en, biz_name_jp, biz_name_cn, comp_display_name, comp_nickname, biz_nickname)
        select NOW()
        ,'b'
        ,b.biz_seq
        ,'c'
        ,b.comp_seq
        ,2
        ,b.order_num
        ,b.biz_cd
        ,b.use_yn
        ,b.comp_seq
        ,b.biz_seq
        ,b.display_yn
        ,concat(b.comp_seq,'|',b.biz_seq)
        ,concat(c_kr.comp_name,(case when b.display_yn = 'Y' then concat('|',b_kr.biz_name) else '' end))
        ,concat((case when ifnull(c_en.comp_name,'')='' then c_kr.comp_name else c_en.comp_name end),(case when b.display_yn = 'Y' then concat('|',(case when ifnull(b_en.biz_name,'')='' then b_kr.biz_name else b_en.biz_name end)) else '' end))
        ,concat((case when ifnull(c_jp.comp_name,'')='' then c_kr.comp_name else c_jp.comp_name end),(case when b.display_yn = 'Y' then concat('|',(case when ifnull(b_jp.biz_name,'')='' then b_kr.biz_name else b_jp.biz_name end)) else '' end))
        ,concat((case when ifnull(c_cn.comp_name,'')='' then c_kr.comp_name else c_cn.comp_name end),(case when b.display_yn = 'Y' then concat('|',(case when ifnull(b_cn.biz_name,'')='' then b_kr.biz_name else b_cn.biz_name end)) else '' end))
        ,c_kr.comp_name
        ,case when ifnull(c_en.comp_name,'')='' then c_kr.comp_name else c_en.comp_name end
        ,case when ifnull(c_jp.comp_name,'')='' then c_kr.comp_name else c_jp.comp_name end
        ,case when ifnull(c_cn.comp_name,'')='' then c_kr.comp_name else c_cn.comp_name end
        ,b_kr.biz_name
        ,case when ifnull(b_en.biz_name,'')='' then b_kr.biz_name else b_en.biz_name end
        ,case when ifnull(b_jp.biz_name,'')='' then b_kr.biz_name else b_jp.biz_name end
        ,case when ifnull(b_cn.biz_name,'')='' then b_kr.biz_name else b_cn.biz_name end
        ,ifnull(c_kr.comp_display_name,'')
        ,ifnull(c_kr.comp_nickname,'')
        ,ifnull(b_kr.biz_nickname,'')
        from t_co_biz b
        join t_co_biz_multi b_kr on b_kr.lang_code='kr' and b.biz_seq=b_kr.biz_seq
        left join t_co_biz_multi b_en on b_en.lang_code='en' and b.biz_seq=b_en.biz_seq
        left join t_co_biz_multi b_jp on b_jp.lang_code='jp' and b.biz_seq=b_jp.biz_seq
        left join t_co_biz_multi b_cn on b_cn.lang_code='cn' and b.biz_seq=b_cn.biz_seq
        join t_co_comp_multi c_kr on c_kr.lang_code='kr' and b.comp_seq=c_kr.comp_seq
        left join t_co_comp_multi c_en on c_en.lang_code='en' and b.comp_seq=c_en.comp_seq
        left join t_co_comp_multi c_jp on c_jp.lang_code='jp' and b.comp_seq=c_jp.comp_seq
        left join t_co_comp_multi c_cn on c_cn.lang_code='cn' and b.comp_seq=c_cn.comp_seq
        where b.comp_seq = NEW.comp_seq;

        insert ignore into t_co_orgchart_name
        (org_sync_date, gbn_org, seq, parent_gbn, parent_seq, level, order_num, org_cd, org_use_yn, comp_seq, biz_seq, biz_display_yn, dept_seq, path, display_path_name_kr, display_path_name_en, display_path_name_jp, display_path_name_cn, comp_name_kr, comp_name_en, comp_name_jp, comp_name_cn, biz_name_kr, biz_name_en, biz_name_jp, biz_name_cn, dept_name_kr, dept_name_en, dept_name_jp, dept_name_cn, comp_display_name, comp_nickname, biz_nickname, dept_display_name, dept_nickname)
        select NOW()
        ,'d'
        ,d.dept_seq
        ,case when d.parent_dept_seq != '0' then 'd' when b.display_yn = 'Y' then 'b' else 'c' end
        ,case when d.parent_dept_seq != '0' then d.parent_dept_seq when b.display_yn = 'Y' then d.biz_seq else d.comp_seq end
        ,case when b.display_yn = 'Y' then d.dept_level + 2 else d.dept_level + 1 end
        ,d.order_num
        ,d.dept_cd
        ,d.use_yn
        ,d.comp_seq
        ,d.biz_seq
        ,b.display_yn
        ,d.dept_seq
        ,concat(d.comp_seq,'|',(case when b.display_yn = 'Y' then concat(d.biz_seq,'|') else '' end),d.path)
        ,concat(c_kr.comp_name,'|',d_kr.path_name)
        ,concat(case when ifnull(c_en.comp_name,'')='' then c_kr.comp_name else c_en.comp_name end,'|',case when ifnull(d_en.path_name,'')='' then d_kr.path_name else d_en.path_name end)
        ,concat(case when ifnull(c_jp.comp_name,'')='' then c_kr.comp_name else c_jp.comp_name end,'|',case when ifnull(d_jp.path_name,'')='' then d_kr.path_name else d_jp.path_name end)
        ,concat(case when ifnull(c_cn.comp_name,'')='' then c_kr.comp_name else c_cn.comp_name end,'|',case when ifnull(d_cn.path_name,'')='' then d_kr.path_name else d_cn.path_name end)
        ,c_kr.comp_name
        ,case when ifnull(c_en.comp_name,'')='' then c_kr.comp_name else c_en.comp_name end
        ,case when ifnull(c_jp.comp_name,'')='' then c_kr.comp_name else c_jp.comp_name end
        ,case when ifnull(c_cn.comp_name,'')='' then c_kr.comp_name else c_cn.comp_name end
        ,b_kr.biz_name
        ,case when ifnull(b_en.biz_name,'')='' then b_kr.biz_name else b_en.biz_name end
        ,case when ifnull(b_jp.biz_name,'')='' then b_kr.biz_name else b_jp.biz_name end
        ,case when ifnull(b_cn.biz_name,'')='' then b_kr.biz_name else b_cn.biz_name end
        ,d_kr.dept_name
        ,case when ifnull(d_en.dept_name,'')='' then d_kr.dept_name else d_en.dept_name end
        ,case when ifnull(d_jp.dept_name,'')='' then d_kr.dept_name else d_jp.dept_name end
        ,case when ifnull(d_cn.dept_name,'')='' then d_kr.dept_name else d_cn.dept_name end
        ,ifnull(c_kr.comp_display_name,'')
        ,ifnull(c_kr.comp_nickname,'')
        ,ifnull(b_kr.biz_nickname,'')
        ,ifnull(d_kr.dept_display_name,'')
        ,ifnull(d_kr.dept_nickname,'')
        from t_co_dept d
        join t_co_biz b on d.biz_seq = b.biz_seq
        join t_co_dept_multi d_kr on d_kr.lang_code='kr' and d.dept_seq=d_kr.dept_seq
        left join t_co_dept_multi d_en on d_en.lang_code='en' and d.dept_seq=d_en.dept_seq
        left join t_co_dept_multi d_jp on d_jp.lang_code='jp' and d.dept_seq=d_jp.dept_seq
        left join t_co_dept_multi d_cn on d_cn.lang_code='cn' and d.dept_seq=d_cn.dept_seq
        join t_co_biz_multi b_kr on b_kr.lang_code='kr' and d.biz_seq=b_kr.biz_seq
        left join t_co_biz_multi b_en on b_en.lang_code='en' and d.biz_seq=b_en.biz_seq
        left join t_co_biz_multi b_jp on b_jp.lang_code='jp' and d.biz_seq=b_jp.biz_seq
        left join t_co_biz_multi b_cn on b_cn.lang_code='cn' and d.biz_seq=b_cn.biz_seq
        join t_co_comp_multi c_kr on c_kr.lang_code='kr' and d.comp_seq=c_kr.comp_seq
        left join t_co_comp_multi c_en on c_en.lang_code='en' and d.comp_seq=c_en.comp_seq
        left join t_co_comp_multi c_jp on c_jp.lang_code='jp' and d.comp_seq=c_jp.comp_seq
        left join t_co_comp_multi c_cn on c_cn.lang_code='cn' and d.comp_seq=c_cn.comp_seq
        where d.comp_seq = NEW.comp_seq;
      END IF;
    END IF;
END$$
DELIMITER ;

DELIMITER $$
DROP TRIGGER IF EXISTS `TRG_T_CO_BIZ_MULTI_AU`$$
CREATE TRIGGER `TRG_T_CO_BIZ_MULTI_AU` AFTER UPDATE ON t_co_biz_multi FOR EACH ROW
BEGIN

    DECLARE V_SAME_CNT int(11);
    
    INSERT INTO t_co_biz_multi_history (
		op_code,
		reg_date,
		group_seq,
		comp_seq,
		biz_seq,
		lang_code,
		biz_name,
		owner_name,
		biz_condition,
		sender_name,
		biz_nickname,
		item,
		addr,
		detail_addr,
		use_yn,
		create_seq,
		create_date,
		modify_seq,
		modify_date
    )
    VALUES (
        'U',
        NOW(),
		NEW.group_seq,
		NEW.comp_seq,
		NEW.biz_seq,
		NEW.lang_code,
		NEW.biz_name,
		NEW.owner_name,
		NEW.biz_condition,
		NEW.sender_name,
		NEW.biz_nickname,
		NEW.item,
		NEW.addr,
		NEW.detail_addr,
		NEW.use_yn,
		NEW.create_seq,
		NEW.create_date,
		NEW.modify_seq,
		NEW.modify_date
    );
    UPDATE 
        t_co_orgchart
    SET
        task_status = CASE 
                        WHEN    task_status = '0' THEN '1'
                        WHEN    task_status = '2' THEN '3'
                        ELSE    task_status END
        , update_status = CASE
			WHEN   update_status < '99' THEN '99' 
			ELSE   update_status END 
    WHERE 
        group_seq = NEW.group_seq;
    
    -- 조직도 패스테이블 적용
    IF NEW.lang_code = 'kr' THEN
    
      select count(*)
      into V_SAME_CNT
      from t_co_orgchart_name con
      join t_co_biz b on con.biz_seq = b.biz_seq
      left join t_co_biz_multi b_en on con.biz_seq=b_en.biz_seq and b_en.lang_code='en'
      left join t_co_biz_multi b_jp on con.biz_seq=b_jp.biz_seq and b_jp.lang_code='jp'
      left join t_co_biz_multi b_cn on con.biz_seq=b_cn.biz_seq and b_cn.lang_code='cn'
      where con.gbn_org='b' and con.biz_seq=NEW.biz_seq
      and con.biz_display_yn = b.display_yn
      and con.biz_name_kr = NEW.biz_name
      and con.biz_nickname = NEW.biz_nickname
      and con.biz_name_en = ifnull(b_en.biz_name, NEW.biz_name)
      and con.biz_name_jp = ifnull(b_jp.biz_name, NEW.biz_name)
      and con.biz_name_cn = ifnull(b_cn.biz_name, NEW.biz_name);
    
      delete from t_co_orgchart_name where gbn_org = 'b' and biz_seq = NEW.biz_seq;
    
      insert ignore into t_co_orgchart_name
      (org_sync_date, gbn_org, seq, parent_gbn, parent_seq, level, order_num, org_cd, org_use_yn, comp_seq, biz_seq, biz_display_yn, path, display_path_name_kr, display_path_name_en, display_path_name_jp, display_path_name_cn, comp_name_kr, comp_name_en, comp_name_jp, comp_name_cn, biz_name_kr, biz_name_en, biz_name_jp, biz_name_cn, comp_display_name, comp_nickname, biz_nickname)
      select NOW()
      ,'b'
      ,b.biz_seq
      ,'c'
      ,b.comp_seq
      ,2
      ,b.order_num
      ,b.biz_cd
      ,b.use_yn
      ,b.comp_seq
      ,b.biz_seq
      ,b.display_yn
      ,concat(b.comp_seq,'|',b.biz_seq)
      ,concat(c_kr.comp_name,(case when b.display_yn = 'Y' then concat('|',b_kr.biz_name) else '' end))
      ,concat((case when ifnull(c_en.comp_name,'')='' then c_kr.comp_name else c_en.comp_name end),(case when b.display_yn = 'Y' then concat('|',(case when ifnull(b_en.biz_name,'')='' then b_kr.biz_name else b_en.biz_name end)) else '' end))
      ,concat((case when ifnull(c_jp.comp_name,'')='' then c_kr.comp_name else c_jp.comp_name end),(case when b.display_yn = 'Y' then concat('|',(case when ifnull(b_jp.biz_name,'')='' then b_kr.biz_name else b_jp.biz_name end)) else '' end))
      ,concat((case when ifnull(c_cn.comp_name,'')='' then c_kr.comp_name else c_cn.comp_name end),(case when b.display_yn = 'Y' then concat('|',(case when ifnull(b_cn.biz_name,'')='' then b_kr.biz_name else b_cn.biz_name end)) else '' end))
      ,c_kr.comp_name
      ,case when ifnull(c_en.comp_name,'')='' then c_kr.comp_name else c_en.comp_name end
      ,case when ifnull(c_jp.comp_name,'')='' then c_kr.comp_name else c_jp.comp_name end
      ,case when ifnull(c_cn.comp_name,'')='' then c_kr.comp_name else c_cn.comp_name end
      ,b_kr.biz_name
      ,case when ifnull(b_en.biz_name,'')='' then b_kr.biz_name else b_en.biz_name end
      ,case when ifnull(b_jp.biz_name,'')='' then b_kr.biz_name else b_jp.biz_name end
      ,case when ifnull(b_cn.biz_name,'')='' then b_kr.biz_name else b_cn.biz_name end
      ,ifnull(c_kr.comp_display_name,'')
      ,ifnull(c_kr.comp_nickname,'')
      ,ifnull(b_kr.biz_nickname,'')
      from t_co_biz b
      join t_co_biz_multi b_kr on b_kr.lang_code='kr' and b.biz_seq=b_kr.biz_seq
      left join t_co_biz_multi b_en on b_en.lang_code='en' and b.biz_seq=b_en.biz_seq
      left join t_co_biz_multi b_jp on b_jp.lang_code='jp' and b.biz_seq=b_jp.biz_seq
      left join t_co_biz_multi b_cn on b_cn.lang_code='cn' and b.biz_seq=b_cn.biz_seq
      join t_co_comp_multi c_kr on c_kr.lang_code='kr' and b.comp_seq=c_kr.comp_seq
      left join t_co_comp_multi c_en on c_en.lang_code='en' and b.comp_seq=c_en.comp_seq
      left join t_co_comp_multi c_jp on c_jp.lang_code='jp' and b.comp_seq=c_jp.comp_seq
      left join t_co_comp_multi c_cn on c_cn.lang_code='cn' and b.comp_seq=c_cn.comp_seq
      where b.biz_seq = NEW.biz_seq;    
    
      IF IFNULL(V_SAME_CNT,0) = 0 THEN

        update t_co_orgchart_name set gbn_org = '2' where gbn_org = 'd' and biz_seq = NEW.biz_seq;

        insert ignore into t_co_orgchart_name
        (org_sync_date, gbn_org, seq, parent_gbn, parent_seq, level, order_num, org_cd, org_use_yn, comp_seq, biz_seq, biz_display_yn, dept_seq, path, display_path_name_kr, display_path_name_en, display_path_name_jp, display_path_name_cn, comp_name_kr, comp_name_en, comp_name_jp, comp_name_cn, biz_name_kr, biz_name_en, biz_name_jp, biz_name_cn, dept_name_kr, dept_name_en, dept_name_jp, dept_name_cn, comp_display_name, comp_nickname, biz_nickname, dept_display_name, dept_nickname)
        select NOW()
        ,'d'
        ,d.dept_seq
        ,case when d.parent_dept_seq != '0' then 'd' when b.display_yn = 'Y' then 'b' else 'c' end
        ,case when d.parent_dept_seq != '0' then d.parent_dept_seq when b.display_yn = 'Y' then d.biz_seq else d.comp_seq end
        ,case when b.display_yn = 'Y' then d.dept_level + 2 else d.dept_level + 1 end
        ,d.order_num
        ,d.dept_cd
        ,d.use_yn
        ,d.comp_seq
        ,d.biz_seq
        ,b.display_yn
        ,d.dept_seq
        ,concat(d.comp_seq,'|',(case when b.display_yn = 'Y' then concat(d.biz_seq,'|') else '' end),d.path)
        ,concat(c_kr.comp_name,'|',case when b.display_yn = 'Y' then (concat(b_kr.biz_name, '|')) else '' end,(select group_concat(dept_name_kr ORDER BY level SEPARATOR '|') from t_co_orgchart_name where gbn_org='2' and concat('|',d.path,'|') like concat('%|', dept_seq, '|%')))
        ,concat(c_kr.comp_name,'|',case when b.display_yn = 'Y' then (concat(case when ifnull(b_en.biz_name,'')='' then b_kr.biz_name else b_en.biz_name end, '|')) else '' end,(select group_concat(dept_name_en ORDER BY level SEPARATOR '|') from t_co_orgchart_name where gbn_org='2' and concat('|',d.path,'|') like concat('%|', dept_seq, '|%')))
        ,concat(c_kr.comp_name,'|',case when b.display_yn = 'Y' then (concat(case when ifnull(b_jp.biz_name,'')='' then b_kr.biz_name else b_jp.biz_name end, '|')) else '' end,(select group_concat(dept_name_jp ORDER BY level SEPARATOR '|') from t_co_orgchart_name where gbn_org='2' and concat('|',d.path,'|') like concat('%|', dept_seq, '|%')))
        ,concat(c_kr.comp_name,'|',case when b.display_yn = 'Y' then (concat(case when ifnull(b_cn.biz_name,'')='' then b_kr.biz_name else b_cn.biz_name end, '|')) else '' end,(select group_concat(dept_name_cn ORDER BY level SEPARATOR '|') from t_co_orgchart_name where gbn_org='2' and concat('|',d.path,'|') like concat('%|', dept_seq, '|%')))        
        ,c_kr.comp_name
        ,case when ifnull(c_en.comp_name,'')='' then c_kr.comp_name else c_en.comp_name end
        ,case when ifnull(c_jp.comp_name,'')='' then c_kr.comp_name else c_jp.comp_name end
        ,case when ifnull(c_cn.comp_name,'')='' then c_kr.comp_name else c_cn.comp_name end
        ,b_kr.biz_name
        ,case when ifnull(b_en.biz_name,'')='' then b_kr.biz_name else b_en.biz_name end
        ,case when ifnull(b_jp.biz_name,'')='' then b_kr.biz_name else b_jp.biz_name end
        ,case when ifnull(b_cn.biz_name,'')='' then b_kr.biz_name else b_cn.biz_name end
        ,d_kr.dept_name
        ,case when ifnull(d_en.dept_name,'')='' then d_kr.dept_name else d_en.dept_name end
        ,case when ifnull(d_jp.dept_name,'')='' then d_kr.dept_name else d_jp.dept_name end
        ,case when ifnull(d_cn.dept_name,'')='' then d_kr.dept_name else d_cn.dept_name end
        ,ifnull(c_kr.comp_display_name,'')
        ,ifnull(c_kr.comp_nickname,'')
        ,ifnull(b_kr.biz_nickname,'')
        ,ifnull(d_kr.dept_display_name,'')
        ,ifnull(d_kr.dept_nickname,'')
        from t_co_dept d
        join t_co_biz b on d.biz_seq = b.biz_seq
        join t_co_dept_multi d_kr on d_kr.lang_code='kr' and d.dept_seq=d_kr.dept_seq
        left join t_co_dept_multi d_en on d_en.lang_code='en' and d.dept_seq=d_en.dept_seq
        left join t_co_dept_multi d_jp on d_jp.lang_code='jp' and d.dept_seq=d_jp.dept_seq
        left join t_co_dept_multi d_cn on d_cn.lang_code='cn' and d.dept_seq=d_cn.dept_seq
        join t_co_biz_multi b_kr on b_kr.lang_code='kr' and d.biz_seq=b_kr.biz_seq
        left join t_co_biz_multi b_en on b_en.lang_code='en' and d.biz_seq=b_en.biz_seq
        left join t_co_biz_multi b_jp on b_jp.lang_code='jp' and d.biz_seq=b_jp.biz_seq
        left join t_co_biz_multi b_cn on b_cn.lang_code='cn' and d.biz_seq=b_cn.biz_seq
        join t_co_comp_multi c_kr on c_kr.lang_code='kr' and d.comp_seq=c_kr.comp_seq
        left join t_co_comp_multi c_en on c_en.lang_code='en' and d.comp_seq=c_en.comp_seq
        left join t_co_comp_multi c_jp on c_jp.lang_code='jp' and d.comp_seq=c_jp.comp_seq
        left join t_co_comp_multi c_cn on c_cn.lang_code='cn' and d.comp_seq=c_cn.comp_seq
        where d.biz_seq = NEW.biz_seq and NEW.lang_code = 'kr';
        
        delete from t_co_orgchart_name where gbn_org = '2' and biz_seq = NEW.biz_seq;
        
      END IF;
    
    END IF;

END$$
DELIMITER ;
-- 소스시퀀스 : 11827
*/

/*
 * v 1.2.119 
 [확장기능] 방문객 등록 프로시저 수정(bs_log 테이블 저장 로직 제거)
 [시스템설정] ERP조직도연동 연동항목 옵션 추가(사원명)
 [조직도동기화] t_co_emp_dept sqlite 동기화 조회 쿼리 주부서 2건 이상 오류 수정
 [시스템설정] 회사 신규등록시 한국어-다국어 저장 오류 수정
 */

/*
DELIMITER $$

DROP PROCEDURE IF EXISTS `Z_DUZONITGROUP_BS_VISITOR_I`$$

CREATE PROCEDURE `Z_DUZONITGROUP_BS_VISITOR_I`(
	IN `nManCoSeq` VARCHAR(50),
	IN `nManUserSeq` VARCHAR(50),
	IN `nReqCoSeq` VARCHAR(50),
	IN `nReqUserSeq` VARCHAR(50),
	IN `sDistnct` VARCHAR(1),
	IN `sVisitCO` VARCHAR(100),
	IN `sVisitNM` VARCHAR(100),
	IN `sVisitHP` VARCHAR(15),
	IN `sVisitCarNo` VARCHAR(30),
	IN `sVisitFrDT` VARCHAR(8),
	IN `sVisitToDT` VARCHAR(8),
	IN `sVisitFrTM` VARCHAR(4),
	IN `sVisitToTM` VARCHAR(4),
	IN `sVisitAIM` VARCHAR(255),
	IN `nVisitCnt` INT,
	IN `sETC` VARCHAR(255),
	IN `sVisitDT` VARCHAR(8),
	IN `sInTime` VARCHAR(4),
	IN `sOutTime` VARCHAR(4)

)
BEGIN
	DECLARE nR_NO INT;
	DECLARE nSeq INT;
	
	DECLARE FR_DATE	DATETIME;
	DECLARE TO_DATE	DATETIME;
	DECLARE VISIT_DT	NVARCHAR(8);
	DECLARE SEQ		INT;
	
	
	SET nR_NO = (SELECT IFNULL(MAX(r_no),0) FROM Z_DUZONITGROUP_VISITORS_M) + 1;
	SET nSeq = (SELECT COUNT(*) FROM Z_DUZONITGROUP_VISITORS_D WHERE r_no = nR_NO) + 1;
	
	
	IF sDistnct = 1 THEN
	BEGIN
		INSERT INTO Z_DUZONITGROUP_VISITORS_M ( r_no, 
					man_comp_seq, 
					man_emp_seq, 
					req_comp_seq, 
					req_emp_seq, 
					visit_distinct, 
					visitor_co, 
					visitor_nm, 
					visit_hp, 
					visit_car_no, 
					visit_dt_fr, 
					visit_tm_fr, 
					visit_aim, 
					visit_cnt, 
					approval_yn, 
					etc, 
					created_dt, 
					del_yn
				)
		VALUES ( nR_NO, 
					nManCoSeq, 
					nManUserSeq, 
					nReqCoSeq, 
					nReqUserSeq, 
					sDistnct, 
					sVisitCO, 
					sVisitNM, 
					sVisitHP, 
					sVisitCarNo, 
					sVisitFrDT, 
					sVisitFrTM, 
					sVisitAIM, 
					nVisitCnt, 
					'1', 
					sETC, 
					NOW(), 
					'0'
				);
				
		INSERT INTO Z_DUZONITGROUP_VISITORS_D (seq, r_no, visit_dt, created_dt)
		VALUES (nSeq, nR_NO, sVisitDT, NOW());
	END;
	
	ELSE
		
		INSERT INTO Z_DUZONITGROUP_VISITORS_M ( r_no, 
					man_comp_seq, 
					man_emp_seq, 
					req_comp_seq, 
					req_emp_seq, 
					visit_distinct, 
					visitor_co, 
					visitor_nm, 
					visit_hp, 
					visit_car_no, 
					visit_dt_fr, 
					visit_dt_to, 
					visit_tm_fr, 
					visit_tm_to, 
					visit_aim, 
					visit_cnt, 
					approval_yn, 
					etc, 
					created_dt, 
					del_yn
				)
		VALUES ( nR_NO, 
					nManCoSeq, 
					nManUserSeq, 
					nReqCoSeq, 
					nReqUserSeq, 
					sDistnct, 
					sVisitCO, 
					sVisitNM, 
					sVisitHP, 
					sVisitCarNo, 
					sVisitFrDT, 
					sVisitToDT, 
					sVisitFrTM, 
					sVisitToTM, 
					sVisitAIM, 
					nVisitCnt, 
					'0', 
					sETC, 
					NOW(), 
					'0'
				);
		
			
	END IF;
END$$

DELIMITER ;

-- 테이블 초기화
delete from t_co_orgchart_name;

-- 회사정보 일괄저장
insert ignore into t_co_orgchart_name
(org_sync_date, gbn_org, seq, parent_gbn, parent_seq, level, order_num, org_cd, org_use_yn, comp_seq, path, display_path_name_kr, display_path_name_en, display_path_name_jp, display_path_name_cn, comp_name_kr, comp_name_en, comp_name_jp, comp_name_cn, comp_display_name, comp_nickname )
select NOW()
,'c'
,c.comp_seq
,'g'
,'0'
,1
,c.order_num
,c.comp_cd
,c.use_yn
,c.comp_seq
,c.comp_seq
,kr.comp_name
,case when ifnull(en.comp_name,'')='' then kr.comp_name else en.comp_name end
,case when ifnull(jp.comp_name,'')='' then kr.comp_name else jp.comp_name end
,case when ifnull(cn.comp_name,'')='' then kr.comp_name else cn.comp_name end
,kr.comp_name
,case when ifnull(en.comp_name,'')='' then kr.comp_name else en.comp_name end
,case when ifnull(jp.comp_name,'')='' then kr.comp_name else jp.comp_name end
,case when ifnull(cn.comp_name,'')='' then kr.comp_name else cn.comp_name end
,ifnull(kr.comp_display_name,'')
,ifnull(kr.comp_nickname,'')
from t_co_comp c
join t_co_comp_multi kr on kr.lang_code='kr' and c.comp_seq=kr.comp_seq
left join t_co_comp_multi en on en.lang_code='en' and c.comp_seq=en.comp_seq
left join t_co_comp_multi jp on jp.lang_code='jp' and c.comp_seq=jp.comp_seq
left join t_co_comp_multi cn on cn.lang_code='cn' and c.comp_seq=cn.comp_seq;

-- 사업장정보 일괄저장
insert ignore into t_co_orgchart_name
(org_sync_date, gbn_org, seq, parent_gbn, parent_seq, level, order_num, org_cd, org_use_yn, comp_seq, biz_seq, biz_display_yn, path, display_path_name_kr, display_path_name_en, display_path_name_jp, display_path_name_cn, comp_name_kr, comp_name_en, comp_name_jp, comp_name_cn, biz_name_kr, biz_name_en, biz_name_jp, biz_name_cn, comp_display_name, comp_nickname, biz_nickname)
select NOW()
,'b'
,b.biz_seq
,'c'
,b.comp_seq
,2
,b.order_num
,b.biz_cd
,b.use_yn
,b.comp_seq
,b.biz_seq
,b.display_yn
,concat(b.comp_seq,'|',b.biz_seq)
,concat(c_kr.comp_name,(case when b.display_yn = 'Y' then concat('|',b_kr.biz_name) else '' end))
,concat((case when ifnull(c_en.comp_name,'')='' then c_kr.comp_name else c_en.comp_name end),(case when b.display_yn = 'Y' then concat('|',(case when ifnull(b_en.biz_name,'')='' then b_kr.biz_name else b_en.biz_name end)) else '' end))
,concat((case when ifnull(c_jp.comp_name,'')='' then c_kr.comp_name else c_jp.comp_name end),(case when b.display_yn = 'Y' then concat('|',(case when ifnull(b_jp.biz_name,'')='' then b_kr.biz_name else b_jp.biz_name end)) else '' end))
,concat((case when ifnull(c_cn.comp_name,'')='' then c_kr.comp_name else c_cn.comp_name end),(case when b.display_yn = 'Y' then concat('|',(case when ifnull(b_cn.biz_name,'')='' then b_kr.biz_name else b_cn.biz_name end)) else '' end))
,c_kr.comp_name
,case when ifnull(c_en.comp_name,'')='' then c_kr.comp_name else c_en.comp_name end
,case when ifnull(c_jp.comp_name,'')='' then c_kr.comp_name else c_jp.comp_name end
,case when ifnull(c_cn.comp_name,'')='' then c_kr.comp_name else c_cn.comp_name end
,b_kr.biz_name
,case when ifnull(b_en.biz_name,'')='' then b_kr.biz_name else b_en.biz_name end
,case when ifnull(b_jp.biz_name,'')='' then b_kr.biz_name else b_jp.biz_name end
,case when ifnull(b_cn.biz_name,'')='' then b_kr.biz_name else b_cn.biz_name end
,ifnull(c_kr.comp_display_name,'')
,ifnull(c_kr.comp_nickname,'')
,ifnull(b_kr.biz_nickname,'')
from t_co_biz b
join t_co_biz_multi b_kr on b_kr.lang_code='kr' and b.biz_seq=b_kr.biz_seq
left join t_co_biz_multi b_en on b_en.lang_code='en' and b.biz_seq=b_en.biz_seq
left join t_co_biz_multi b_jp on b_jp.lang_code='jp' and b.biz_seq=b_jp.biz_seq
left join t_co_biz_multi b_cn on b_cn.lang_code='cn' and b.biz_seq=b_cn.biz_seq
join t_co_comp_multi c_kr on c_kr.lang_code='kr' and b.comp_seq=c_kr.comp_seq
left join t_co_comp_multi c_en on c_en.lang_code='en' and b.comp_seq=c_en.comp_seq
left join t_co_comp_multi c_jp on c_jp.lang_code='jp' and b.comp_seq=c_jp.comp_seq
left join t_co_comp_multi c_cn on c_cn.lang_code='cn' and b.comp_seq=c_cn.comp_seq;

-- 부서정보 일괄저장
insert ignore into t_co_orgchart_name
(org_sync_date, gbn_org, seq, parent_gbn, parent_seq, level, order_num, org_cd, org_use_yn, comp_seq, biz_seq, biz_display_yn, dept_seq, path, display_path_name_kr, display_path_name_en, display_path_name_jp, display_path_name_cn, comp_name_kr, comp_name_en, comp_name_jp, comp_name_cn, biz_name_kr, biz_name_en, biz_name_jp, biz_name_cn, dept_name_kr, dept_name_en, dept_name_jp, dept_name_cn, comp_display_name, comp_nickname, biz_nickname, dept_display_name, dept_nickname)
select NOW()
,'d'
,d.dept_seq
,case when d.parent_dept_seq != '0' then 'd' when b.display_yn = 'Y' then 'b' else 'c' end
,case when d.parent_dept_seq != '0' then d.parent_dept_seq when b.display_yn = 'Y' then d.biz_seq else d.comp_seq end
,case when b.display_yn = 'Y' then d.dept_level + 2 else d.dept_level + 1 end
,d.order_num
,d.dept_cd
,d.use_yn
,d.comp_seq
,d.biz_seq
,b.display_yn
,d.dept_seq
,concat(d.comp_seq,'|',(case when b.display_yn = 'Y' then concat(d.biz_seq,'|') else '' end),d.path)
,concat(c_kr.comp_name,'|',get_dept_pathNm('|',d.dept_seq,d.group_seq,'kr'))
,concat(case when ifnull(c_en.comp_name,'')='' then c_kr.comp_name else c_en.comp_name end,'|',get_dept_pathNm('|',d.dept_seq,d.group_seq,'en'))
,concat(case when ifnull(c_jp.comp_name,'')='' then c_kr.comp_name else c_jp.comp_name end,'|',get_dept_pathNm('|',d.dept_seq,d.group_seq,'jp'))
,concat(case when ifnull(c_cn.comp_name,'')='' then c_kr.comp_name else c_cn.comp_name end,'|',get_dept_pathNm('|',d.dept_seq,d.group_seq,'cn'))
,c_kr.comp_name
,case when ifnull(c_en.comp_name,'')='' then c_kr.comp_name else c_en.comp_name end
,case when ifnull(c_jp.comp_name,'')='' then c_kr.comp_name else c_jp.comp_name end
,case when ifnull(c_cn.comp_name,'')='' then c_kr.comp_name else c_cn.comp_name end
,b_kr.biz_name
,case when ifnull(b_en.biz_name,'')='' then b_kr.biz_name else b_en.biz_name end
,case when ifnull(b_jp.biz_name,'')='' then b_kr.biz_name else b_jp.biz_name end
,case when ifnull(b_cn.biz_name,'')='' then b_kr.biz_name else b_cn.biz_name end
,d_kr.dept_name
,case when ifnull(d_en.dept_name,'')='' then d_kr.dept_name else d_en.dept_name end
,case when ifnull(d_jp.dept_name,'')='' then d_kr.dept_name else d_jp.dept_name end
,case when ifnull(d_cn.dept_name,'')='' then d_kr.dept_name else d_cn.dept_name end
,ifnull(c_kr.comp_display_name,'')
,ifnull(c_kr.comp_nickname,'')
,ifnull(b_kr.biz_nickname,'')
,ifnull(d_kr.dept_display_name,'')
,ifnull(d_kr.dept_nickname,'')
from t_co_dept d
join t_co_biz b on d.biz_seq = b.biz_seq
join t_co_dept_multi d_kr on d_kr.lang_code='kr' and d.dept_seq=d_kr.dept_seq
left join t_co_dept_multi d_en on d_en.lang_code='en' and d.dept_seq=d_en.dept_seq
left join t_co_dept_multi d_jp on d_jp.lang_code='jp' and d.dept_seq=d_jp.dept_seq
left join t_co_dept_multi d_cn on d_cn.lang_code='cn' and d.dept_seq=d_cn.dept_seq
join t_co_biz_multi b_kr on b_kr.lang_code='kr' and d.biz_seq=b_kr.biz_seq
left join t_co_biz_multi b_en on b_en.lang_code='en' and d.biz_seq=b_en.biz_seq
left join t_co_biz_multi b_jp on b_jp.lang_code='jp' and d.biz_seq=b_jp.biz_seq
left join t_co_biz_multi b_cn on b_cn.lang_code='cn' and d.biz_seq=b_cn.biz_seq
join t_co_comp_multi c_kr on c_kr.lang_code='kr' and d.comp_seq=c_kr.comp_seq
left join t_co_comp_multi c_en on c_en.lang_code='en' and d.comp_seq=c_en.comp_seq
left join t_co_comp_multi c_jp on c_jp.lang_code='jp' and d.comp_seq=c_jp.comp_seq
left join t_co_comp_multi c_cn on c_cn.lang_code='cn' and d.comp_seq=c_cn.comp_seq;

UPDATE tcmg_optionset SET option_desc = 'ERP 조직도 동기화 시 ERP에서 그룹웨어로 동기화 되는 항목을 설정할 수 있습니다.
선택된 항목만 그룹웨어에 동기화 되며, 미선택 시 필수 항목만 동기화처리됩니다.

- 필수 항목 : 부서명, ERP사번, 메일 ID, 직급, 직책, 근무구분', option_d_value = '2|3|4|5|6|7|8'
WHERE option_id = 'cm1120';
INSERT IGNORE INTO `t_co_code_detail` (`detail_code`, `code`, `ischild`, `order_num`, `flag_1`, `flag_2`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('8', 'option0212', 'N', 80, NULL, NULL, 'Y', NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `t_co_code_detail_multi` (`detail_code`, `code`, `lang_code`, `detail_name`, `note`, `use_yn`, `create_seq`, `create_date`, `modify_seq`, `modify_date`) VALUES ('8', 'option0212', 'kr', '사원명', NULL, 'Y', NULL, NULL, NULL, NULL);
UPDATE tcmg_optionvalue SET option_value = (CASE WHEN INSTR(option_value,'8') = 0 then CONCAT(option_value,'8','|') ELSE option_value END) WHERE option_id = 'cm1120';
*/

-- 소스시퀀스 : 11989

/*
 * v 1.2.119 (검수오류 취합) 
 [확장기능] 방문객 등록 프로시저 수정(방문시간 테이블 추가 로직 수정)
 */

/*
DELIMITER $$

DROP PROCEDURE IF EXISTS `Z_DUZONITGROUP_BS_VISITOR_I`$$

CREATE PROCEDURE `Z_DUZONITGROUP_BS_VISITOR_I`(
	IN `nManCoSeq` VARCHAR(50),
	IN `nManUserSeq` VARCHAR(50),
	IN `nReqCoSeq` VARCHAR(50),
	IN `nReqUserSeq` VARCHAR(50),
	IN `sDistnct` VARCHAR(1),
	IN `sVisitCO` VARCHAR(100),
	IN `sVisitNM` VARCHAR(100),
	IN `sVisitHP` VARCHAR(15),
	IN `sVisitCarNo` VARCHAR(30),
	IN `sVisitFrDT` VARCHAR(8),
	IN `sVisitToDT` VARCHAR(8),
	IN `sVisitFrTM` VARCHAR(4),
	IN `sVisitToTM` VARCHAR(4),
	IN `sVisitAIM` VARCHAR(255),
	IN `nVisitCnt` INT,
	IN `sETC` VARCHAR(255),
	IN `sVisitDT` VARCHAR(8),
	IN `sInTime` VARCHAR(4),
	IN `sOutTime` VARCHAR(4)

)
BEGIN
	DECLARE nR_NO INT;
	DECLARE nSeq INT;
	
	DECLARE FR_DATE	DATETIME;
	DECLARE TO_DATE	DATETIME;
	DECLARE VISIT_DT	NVARCHAR(8);
	DECLARE SEQ		INT;
	
	
	SET nR_NO = (SELECT IFNULL(MAX(r_no),0) FROM Z_DUZONITGROUP_VISITORS_M) + 1;
	SET nSeq = (SELECT COUNT(*) FROM Z_DUZONITGROUP_VISITORS_D WHERE r_no = nR_NO) + 1;
	
	
	IF sDistnct = 1 THEN
	BEGIN
		INSERT INTO Z_DUZONITGROUP_VISITORS_M ( r_no, 
					man_comp_seq, 
					man_emp_seq, 
					req_comp_seq, 
					req_emp_seq, 
					visit_distinct, 
					visitor_co, 
					visitor_nm, 
					visit_hp, 
					visit_car_no, 
					visit_dt_fr, 
					visit_tm_fr, 
					visit_aim, 
					visit_cnt, 
					approval_yn, 
					etc, 
					created_dt, 
					del_yn
				)
		VALUES ( nR_NO, 
					nManCoSeq, 
					nManUserSeq, 
					nReqCoSeq, 
					nReqUserSeq, 
					sDistnct, 
					sVisitCO, 
					sVisitNM, 
					sVisitHP, 
					sVisitCarNo, 
					sVisitFrDT, 
					sVisitFrTM, 
					sVisitAIM, 
					nVisitCnt, 
					'1', 
					sETC, 
					NOW(), 
					'0'
				);
				
		INSERT INTO Z_DUZONITGROUP_VISITORS_D (seq, r_no, visit_dt, created_dt)
		VALUES (nSeq, nR_NO, sVisitDT, NOW());
	END;
	
	ELSE
		
		INSERT INTO Z_DUZONITGROUP_VISITORS_M ( r_no, 
					man_comp_seq, 
					man_emp_seq, 
					req_comp_seq, 
					req_emp_seq, 
					visit_distinct, 
					visitor_co, 
					visitor_nm, 
					visit_hp, 
					visit_car_no, 
					visit_dt_fr, 
					visit_dt_to, 
					visit_tm_fr, 
					visit_tm_to, 
					visit_aim, 
					visit_cnt, 
					approval_yn, 
					etc, 
					created_dt, 
					del_yn
				)
		VALUES ( nR_NO, 
					nManCoSeq, 
					nManUserSeq, 
					nReqCoSeq, 
					nReqUserSeq, 
					sDistnct, 
					sVisitCO, 
					sVisitNM, 
					sVisitHP, 
					sVisitCarNo, 
					sVisitFrDT, 
					sVisitToDT, 
					sVisitFrTM, 
					sVisitToTM, 
					sVisitAIM, 
					nVisitCnt, 
					'0', 
					sETC, 
					NOW(), 
					'0'
				);
		INSERT INTO Z_DUZONITGROUP_VISITORS_D (seq, r_no, visit_dt, created_dt)
		VALUES (nSeq, nR_NO, sVisitDT, NOW());
			
	END IF;
END$$

DELIMITER ;
*/


/*
 v 1.2.120 
 [시스템설정] ERP조직도연동 근태적용유무 옵션추가
 [확장기능] 방문객 등록 프로시저 로직 수정
 */
/*

ALTER TABLE `t_co_erp_sync_code`
	ADD COLUMN IF NOT EXISTS `gw_code2` VARCHAR(128) NULL DEFAULT NULL AFTER `gw_code`;
	
UPDATE t_co_erp_sync_code SET gw_code2 = '' WHERE code_type IN ('20','30');

*소스시퀀스 12076 */ 

/*

DELIMITER $$

DROP PROCEDURE IF EXISTS `Z_DUZONITGROUP_BS_VISITOR_I`$$

CREATE PROCEDURE `Z_DUZONITGROUP_BS_VISITOR_I`(
	IN `nManCoSeq` VARCHAR(50),
	IN `nManUserSeq` VARCHAR(50),
	IN `nReqCoSeq` VARCHAR(50),
	IN `nReqUserSeq` VARCHAR(50),
	IN `sDistnct` VARCHAR(1),
	IN `sVisitCO` VARCHAR(100),
	IN `sVisitNM` VARCHAR(100),
	IN `sVisitHP` VARCHAR(15),
	IN `sVisitCarNo` VARCHAR(30),
	IN `sVisitFrDT` VARCHAR(8),
	IN `sVisitToDT` VARCHAR(8),
	IN `sVisitFrTM` VARCHAR(4),
	IN `sVisitToTM` VARCHAR(4),
	IN `sVisitAIM` VARCHAR(255),
	IN `nVisitCnt` INT,
	IN `sETC` VARCHAR(255),
	IN `sVisitDT` VARCHAR(8),
	IN `sInTime` VARCHAR(4),
	IN `sOutTime` VARCHAR(4)

)
BEGIN
	DECLARE nR_NO INT;
	DECLARE nSeq INT;
	
	DECLARE FR_DATE	DATETIME;
	DECLARE TO_DATE	DATETIME;
	DECLARE VISIT_DT	NVARCHAR(8);
	DECLARE SEQ		INT;
	
	
	SET nR_NO = (SELECT IFNULL(MAX(r_no),0) FROM Z_DUZONITGROUP_VISITORS_M) + 1;
	SET nSeq = (SELECT COUNT(*) FROM Z_DUZONITGROUP_VISITORS_D WHERE r_no = nR_NO) + 1;
	
	IF sDistnct = 1 THEN
	BEGIN
		INSERT INTO Z_DUZONITGROUP_VISITORS_M ( r_no, 
					man_comp_seq, 
					man_emp_seq, 
					req_comp_seq, 
					req_emp_seq, 
					visit_distinct, 
					visitor_co, 
					visitor_nm, 
					visit_hp, 
					visit_car_no, 
					visit_dt_fr, 
					visit_tm_fr, 
					visit_aim, 
					visit_cnt, 
					approval_yn, 
					etc, 
					created_dt, 
					del_yn
				)
		VALUES ( nR_NO, 
					nManCoSeq, 
					nManUserSeq, 
					nReqCoSeq, 
					nReqUserSeq, 
					sDistnct, 
					sVisitCO, 
					sVisitNM, 
					sVisitHP, 
					sVisitCarNo, 
					sVisitFrDT, 
					sVisitFrTM, 
					sVisitAIM, 
					nVisitCnt, 
					'1', 
					sETC, 
					NOW(), 
					'0'
				);
				
		INSERT INTO Z_DUZONITGROUP_VISITORS_D (seq, r_no, visit_dt, created_dt)
		VALUES (nSeq, nR_NO, sVisitDT, NOW());
	END;
	
	ELSE
	
		INSERT INTO Z_DUZONITGROUP_VISITORS_M ( r_no, 
					man_comp_seq, 
					man_emp_seq, 
					req_comp_seq, 
					req_emp_seq, 
					visit_distinct, 
					visitor_co, 
					visitor_nm, 
					visit_hp, 
					visit_car_no, 
					visit_dt_fr, 
					visit_dt_to, 
					visit_tm_fr, 
					visit_tm_to, 
					visit_aim, 
					visit_cnt, 
					approval_yn, 
					etc, 
					created_dt, 
					del_yn
				)
		VALUES ( nR_NO, 
					nManCoSeq, 
					nManUserSeq, 
					nReqCoSeq, 
					nReqUserSeq, 
					sDistnct, 
					sVisitCO, 
					sVisitNM, 
					sVisitHP, 
					sVisitCarNo, 
					sVisitFrDT, 
					sVisitToDT, 
					sVisitFrTM, 
					sVisitToTM, 
					sVisitAIM, 
					nVisitCnt, 
					'0', 
					sETC, 
					NOW(), 
					'0'
				);
	
		SET FR_DATE = CAST(DATE_FORMAT(CAST(sVisitFrDT AS CHAR(10)),'%Y-%m-%d %H:%i:%s') AS CHAR(19));
	
		SET TO_DATE = CAST(DATE_FORMAT(CAST(sVisitToDT AS CHAR(10)),'%Y-%m-%d %H:%i:%s') AS CHAR(19));
	
		SET SEQ = 1;
		
		WHILE FR_DATE <= TO_DATE	DO
			SET VISIT_DT = CAST(DATE_FORMAT(FR_DATE,'%Y%m%d') AS CHAR(8));
			
			 INSERT INTO Z_DUZONITGROUP_VISITORS_D (r_no, seq, visit_dt, created_dt)
			 VALUES (nR_NO, SEQ, VISIT_DT, NOW());
			
			SET FR_DATE = FR_DATE + INTERVAL 1 DAY;
			SET SEQ = SEQ + 1;
		END WHILE;	
			
	END IF;
END$$

DELIMITER ;

/*


/*
 v 1.2.121
 [포털] 비영리 전자결재 결재양식 포틀릿 다국어 적용
 [공통] 공통조직도팝업 emailAddr 값 추가 - 원피스팀 요청
 [시스템설정] 인사이동현황 부서 선택 팝업 오류 수정 
 [조직도동기화] t_co_emp_dept sqlite 동기화 조회 쿼리 주부서 2건 이상 오류 t_co_emp_dept_multi 관련 추가 수정
 */

-- 소스시퀀스 : 12196


/*
 * v 1.2.122
 [시스템설정] JDK / ORACLE 버전 업데이트로 인한 ojdbc8.jar 적용
 [시스템설정] 관리자 > 사원정보관리 엑셀저장 회사콤보박스 관련 오류 수정
 */*/*/
-- 소스시퀀스 : 12301


/*
CREATE TABLE IF NOT EXISTS `t_co_authcode_history` (
  `seq` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '시퀀스',
  `op_code` char(1) DEFAULT NULL,
  `reg_date` datetime DEFAULT NULL COMMENT '변경일',
  `author_code` varchar(30) NOT NULL COMMENT '권한코드',
  `author_type` varchar(3) NOT NULL COMMENT '권한타입',
  `author_base_yn` char(1) DEFAULT NULL COMMENT '권한 기본부여 여부',
  `author_use_yn` char(1) DEFAULT NULL COMMENT '권한 사용여부',
  `group_seq` varchar(32) DEFAULT NULL COMMENT '그룹코드',
  `comp_seq` varchar(32) DEFAULT NULL COMMENT '회사코드',
  `create_seq` varchar(32) DEFAULT NULL COMMENT '등록자',
  `create_date` datetime DEFAULT NULL COMMENT '등록일자',
  `modify_seq` varchar(32) DEFAULT NULL COMMENT '수정자',
  `modify_date` datetime DEFAULT NULL COMMENT '수정일자',
  `order_num` decimal(65,0) DEFAULT NULL COMMENT '정렬순서',
  `dept_seq` varchar(32) DEFAULT NULL COMMENT '부서코드',
  PRIMARY KEY (`seq`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `t_co_authcode_multi_history` (
  `seq` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '시퀀스',
  `op_code` char(1) DEFAULT NULL,
  `reg_date` datetime DEFAULT NULL COMMENT '변경일',
  `author_code` varchar(30) NOT NULL COMMENT '권한코드',
  `lang_code` varchar(32) NOT NULL COMMENT '언어코드',
  `author_nm` varchar(60) DEFAULT NULL,
  `author_dc` varchar(200) DEFAULT NULL COMMENT '권한설명',
  `create_seq` varchar(32) DEFAULT NULL COMMENT '등록자',
  `create_date` datetime DEFAULT NULL COMMENT '등록일자',
  `modify_seq` varchar(32) DEFAULT NULL COMMENT '수정자',
  `modify_date` datetime DEFAULT NULL COMMENT '수정일자',
  PRIMARY KEY (`seq`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `t_co_auth_relate_history` (
  `seq` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '시퀀스',
  `op_code` char(1) DEFAULT NULL,
  `reg_date` datetime DEFAULT NULL COMMENT '변경일',
  `author_code` varchar(30) NOT NULL COMMENT '권한코드',
  `author_type` varchar(3) NOT NULL COMMENT '권한타입',
  `comp_seq` varchar(32) NOT NULL COMMENT '사용자회사시퀀스',
  `dept_seq` varchar(32) NOT NULL COMMENT '사용자부서시퀀스',
  `emp_seq` varchar(32) NOT NULL COMMENT '사용자시퀀스',
  PRIMARY KEY (`seq`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `t_co_menu_auth_history` (
  `seq` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '시퀀스',
  `op_code` char(1) DEFAULT NULL,
  `reg_date` datetime DEFAULT NULL COMMENT '변경일',
  `menu_no` int(20) NOT NULL COMMENT '메뉴번호',
  `author_code` varchar(30) NOT NULL COMMENT '권한코드',
  PRIMARY KEY (`seq`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

DELIMITER $$
DROP TRIGGER IF EXISTS `TRG_T_CO_AUTHCODE_AI`$$
CREATE TRIGGER `TRG_T_CO_AUTHCODE_AI` AFTER INSERT ON t_co_authcode FOR EACH ROW
BEGIN
    INSERT INTO t_co_authcode_history (op_code, reg_date, author_code, author_type, author_base_yn, author_use_yn, group_seq, comp_seq, create_seq, create_date, modify_seq, modify_date, order_num, dept_seq)
    VALUES ('I', NOW(), NEW.author_code, NEW.author_type, NEW.author_base_yn, NEW.author_use_yn, NEW.group_seq, NEW.comp_seq, NEW.create_seq, NEW.create_date, NEW.modify_seq, NEW.modify_date, NEW.order_num, NEW.dept_seq);
END$$
DELIMITER ;

DELIMITER $$
DROP TRIGGER IF EXISTS `TRG_T_CO_AUTHCODE_AU`$$
CREATE TRIGGER `TRG_T_CO_AUTHCODE_AU` AFTER UPDATE ON t_co_authcode FOR EACH ROW
BEGIN
    INSERT INTO t_co_authcode_history (op_code, reg_date, author_code, author_type, author_base_yn, author_use_yn, group_seq, comp_seq, create_seq, create_date, modify_seq, modify_date, order_num, dept_seq)
    VALUES ('U', NOW(), NEW.author_code, NEW.author_type, NEW.author_base_yn, NEW.author_use_yn, NEW.group_seq, NEW.comp_seq, NEW.create_seq, NEW.create_date, NEW.modify_seq, NEW.modify_date, NEW.order_num, NEW.dept_seq);
END$$
DELIMITER ;

DELIMITER $$
DROP TRIGGER IF EXISTS `TRG_T_CO_AUTHCODE_AD`$$
CREATE TRIGGER `TRG_T_CO_AUTHCODE_AD` AFTER DELETE ON t_co_authcode FOR EACH ROW
BEGIN
    INSERT INTO t_co_authcode_history (op_code, reg_date, author_code, author_type, author_base_yn, author_use_yn, group_seq, comp_seq, create_seq, create_date, modify_seq, modify_date, order_num, dept_seq)
    VALUES ('D', NOW(), OLD.author_code, OLD.author_type, OLD.author_base_yn, OLD.author_use_yn, OLD.group_seq, OLD.comp_seq, OLD.create_seq, OLD.create_date, OLD.modify_seq, OLD.modify_date, OLD.order_num, OLD.dept_seq);
END$$
DELIMITER ;

DELIMITER $$
DROP TRIGGER IF EXISTS `TRG_T_CO_AUTHCODE_MULTI_AI`$$
CREATE TRIGGER `TRG_T_CO_AUTHCODE_MULTI_AI` AFTER INSERT ON t_co_authcode_multi FOR EACH ROW
BEGIN
    INSERT INTO t_co_authcode_multi_history (op_code, reg_date, author_code, lang_code, author_nm, author_dc, create_seq, create_date, modify_seq, modify_date)
    VALUES ('I', NOW(), NEW.author_code, NEW.lang_code, NEW.author_nm, NEW.author_dc, NEW.create_seq, NEW.create_date, NEW.modify_seq, NEW.modify_date);
END$$
DELIMITER ;

DELIMITER $$
DROP TRIGGER IF EXISTS `TRG_T_CO_AUTHCODE_MULTI_AU`$$
CREATE TRIGGER `TRG_T_CO_AUTHCODE_MULTI_AU` AFTER UPDATE ON t_co_authcode_multi FOR EACH ROW
BEGIN
    INSERT INTO t_co_authcode_multi_history (op_code, reg_date, author_code, lang_code, author_nm, author_dc, create_seq, create_date, modify_seq, modify_date)
    VALUES ('U', NOW(), NEW.author_code, NEW.lang_code, NEW.author_nm, NEW.author_dc, NEW.create_seq, NEW.create_date, NEW.modify_seq, NEW.modify_date);
END$$
DELIMITER ;

DELIMITER $$
DROP TRIGGER IF EXISTS `TRG_T_CO_AUTHCODE_MULTI_AD`$$
CREATE TRIGGER `TRG_T_CO_AUTHCODE_MULTI_AD` AFTER DELETE ON t_co_authcode_multi FOR EACH ROW
BEGIN
    INSERT INTO t_co_authcode_multi_history (op_code, reg_date, author_code, lang_code, author_nm, author_dc, create_seq, create_date, modify_seq, modify_date)
    VALUES ('D', NOW(), OLD.author_code, OLD.lang_code, OLD.author_nm, OLD.author_dc, OLD.create_seq, OLD.create_date, OLD.modify_seq, OLD.modify_date);
END$$
DELIMITER ;

DELIMITER $$
DROP TRIGGER IF EXISTS `TRG_T_CO_MENU_AUTH_AI`$$
CREATE TRIGGER `TRG_T_CO_MENU_AUTH_AI` AFTER INSERT ON t_co_menu_auth FOR EACH ROW
BEGIN
    INSERT INTO t_co_menu_auth_history (op_code, reg_date, menu_no, author_code)
    VALUES ('I', NOW(), NEW.menu_no, NEW.author_code);
END$$
DELIMITER ;

DELIMITER $$
DROP TRIGGER IF EXISTS `TRG_T_CO_MENU_AUTH_AU`$$
CREATE TRIGGER `TRG_T_CO_MENU_AUTH_AU` AFTER UPDATE ON t_co_menu_auth FOR EACH ROW
BEGIN
    INSERT INTO t_co_menu_auth_history (op_code, reg_date, menu_no, author_code)
    VALUES ('U', NOW(), NEW.menu_no, NEW.author_code);
END$$
DELIMITER ;

DELIMITER $$
DROP TRIGGER IF EXISTS `TRG_T_CO_MENU_AUTH_AD`$$
CREATE TRIGGER `TRG_T_CO_MENU_AUTH_AD` AFTER DELETE ON t_co_menu_auth FOR EACH ROW
BEGIN
    INSERT INTO t_co_menu_auth_history (op_code, reg_date, menu_no, author_code)
    VALUES ('D', NOW(), OLD.menu_no, OLD.author_code);
END$$
DELIMITER ;

DELIMITER $$
DROP TRIGGER IF EXISTS `TRG_T_CO_AUTH_RELATE_AI`$$
CREATE TRIGGER `TRG_T_CO_AUTH_RELATE_AI` AFTER INSERT ON t_co_auth_relate FOR EACH ROW
BEGIN
    INSERT INTO t_co_auth_relate_history (op_code, reg_date, author_code, author_type, comp_seq, dept_seq, emp_seq)
    VALUES ('I', NOW(), NEW.author_code, NEW.author_type, NEW.comp_seq, NEW.dept_seq, NEW.emp_seq);
END$$
DELIMITER ;

DELIMITER $$
DROP TRIGGER IF EXISTS `TRG_T_CO_AUTH_RELATE_AU`$$
CREATE TRIGGER `TRG_T_CO_AUTH_RELATE_AU` AFTER UPDATE ON t_co_auth_relate FOR EACH ROW
BEGIN
    INSERT INTO t_co_auth_relate_history (op_code, reg_date, author_code, author_type, comp_seq, dept_seq, emp_seq)
    VALUES ('U', NOW(), NEW.author_code, NEW.author_type, NEW.comp_seq, NEW.dept_seq, NEW.emp_seq);
END$$
DELIMITER ;

DELIMITER $$
DROP TRIGGER IF EXISTS `TRG_T_CO_AUTH_RELATE_AD`$$
CREATE TRIGGER `TRG_T_CO_AUTH_RELATE_AD` AFTER DELETE ON t_co_auth_relate FOR EACH ROW
BEGIN
    INSERT INTO t_co_auth_relate_history (op_code, reg_date, author_code, author_type, comp_seq, dept_seq, emp_seq)
    VALUES ('D', NOW(), OLD.author_code, OLD.author_type, OLD.comp_seq, OLD.dept_seq, OLD.emp_seq);
END$$
DELIMITER ;

*/ 
-- 소스시퀀스 12370


/*
 v 1.2.123
 [시스템설정] 메일전용 라이선스 카운트 체크 개선 (비정상 등록 제한)
 [공통] 그룹웨어 유튜브 링크 제공 (웹 하단 버튼, 메신저 좌측 메뉴 )
 [시스템설정] 회사정보관리 회사 데이터 수정시 compDomain 처리 수정
 [시스템설정] ojdbc 버전 업데이트 후 oracle 연동오류로 인한  orai18n.jar 적용 
 */

/*
insert ignore into t_msg_tcmg_link
(link_seq, link_upper_seq, link_position, group_seq, comp_seq, link_kind, link_nm_kr, link_nm_en, link_nm_jp, link_nm_cn, menu_no, gnb_menu_no, lnb_menu_no, msg_target, target_url, link_param, encrypt_seq, map_key, app_key, use_yn, icon_nm, icon_path, icon_ver, order_num, create_seq, create_date, modify_seq, modify_date) VALUES
('YT', '0', 'L', 'varGroupId', '0', 'E', 'YouTube', '', '', '', 0, '', '', 'youtube', 'http://publicgcms.bizboxa.com/PublicView/BizBoxAlpha/FAQ.aspx?cust=varGroupId', '', '0', '', NULL, 'Y', 'btn_left_youtube_normal.png', '/gw/Images/msg/btn_left_youtube_normal.png', '6', 12, 'SYSTEM', NOW(), 'SYSTEM', NOW());

insert ignore into t_msg_tcmg_link
(link_seq, link_upper_seq, link_position, group_seq, comp_seq, link_kind, link_nm_kr, link_nm_en, link_nm_jp, link_nm_cn, menu_no, gnb_menu_no, lnb_menu_no, msg_target, target_url, link_param, encrypt_seq, map_key, app_key, use_yn, icon_nm, icon_path, icon_ver, order_num, create_seq, create_date, modify_seq, modify_date)
select 
concat(b.comp_seq, '_YT'), '0', 'L', a.group_seq, b.comp_seq, 'E', 'YouTube', '', '', '', 0, '', '', 'youtube', 'http://publicgcms.bizboxa.com/PublicView/BizBoxAlpha/FAQ.aspx?cust=varGroupId', '', '0', '', NULL, 'Y', 'btn_left_youtube_normal.png', '/gw/Images/msg/btn_left_youtube_normal.png', '6', 12, 'SYSTEM', NOW(), 'SYSTEM', NOW()
from t_msg_tcmg_link a
join t_co_comp b on b.comp_seq not in (select comp_seq from t_msg_tcmg_link where msg_target = 'youtube');

update tcmg_optionset set option_d_value = '0|1|1-1|2|3|4|5|6' where option_id = 'cm850';

update tcmg_optionvalue set option_value = concat(option_value, '|6|') where option_id = 'cm850' and option_value not like '%|6%';

insert ignore into t_co_code_detail
(detail_code, code, ischild, order_num, flag_1, flag_2, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('6', 'option0090', 'N', -1, NULL, NULL, 'Y', 'SYSTEM', NOW(), NULL, NULL);

insert ignore into t_co_code_detail_multi
(detail_code, code, lang_code, detail_name, note, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES
('6', 'option0090', 'kr', 'YouTube', 'YouTube', 'Y', 'SYSTEM', NOW(), NULL, NULL);

update t_co_group_path set absol_path = replace(absol_path, '/bbs', '/edms') where path_seq = '500';

*/ -- 소스시퀀스 12475 (1.2.123버전)



/*
CREATE TABLE IF NOT EXISTS `t_co_qr_stay_log` (
  `stay_seq` int(11) NOT NULL AUTO_INCREMENT COMMENT '방문 시퀀스',
  `qr_gbn_code` varchar(32) NOT NULL COMMENT '구분코드',
  `qr_code` varchar(32) NOT NULL COMMENT '코드',
  `qr_detail_code` varchar(32) NOT NULL COMMENT '상세코드',
  `compName` varchar(128) DEFAULT NULL COMMENT '회사명',
  `deptPathName` varchar(512) DEFAULT NULL COMMENT '부서경로명',
  `empName` varchar(128) DEFAULT NULL COMMENT '사원명',
  `empSeq` varchar(32) NOT NULL COMMENT '사원시퀀스',
  `mobile_tel_num` varchar(32) DEFAULT NULL COMMENT '핸드폰번호',
  `gps_info` varchar(256) DEFAULT NULL COMMENT 'GPS정보',
  `location_addr` varchar(256) DEFAULT NULL,
  `create_seq` varchar(32) DEFAULT NULL COMMENT '등록자시퀀스',
  `create_date` datetime DEFAULT NULL COMMENT '등록일',
  `modify_seq` varchar(32) DEFAULT NULL COMMENT '수정자시퀀스',
  `modify_date` datetime DEFAULT NULL COMMENT '수정일',
  PRIMARY KEY (`stay_seq`),
  KEY `t_co_qr_stay_log_fk01` (`qr_gbn_code`,`qr_code`,`qr_detail_code`,`empSeq`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='사용자 방문로그 테이블';

*/		-- 소스시퀀스 12574 (1.2.124버전)

/*
 v 1.2.126
 [시스템설정] 직책 직급 일괄등록 오류 수정 
 */

/*
ALTER TABLE t_co_dutyposition_batch MODIFY COLUMN dp_name varchar(128) NULL;
*/

-- 소스시퀀스 12766

/*
[시스템설정]마스터 권한 설정 속도 이슈 수정
[더존에디터] 더존 에디터 본문 내 개체(파일)첨부 후 다운로드 불가 현상 수정
*/

-- 소스시퀀스 12916

/*
 v 1.2.128
 [시스템설정-항목설정] DATETIME Type '년월일시분' 추가 개선
 [공통] 퇴사처리 시 부서매핑정보 삭제 후 메신져/모바일에서 Unknown사용자로 조회되는 문제 수정
 [시스템설정-조직도정보관리] 사업장/부서 약칭 '년도/월/일' 문자열 제한처리 제거
 [조직도동기화] 모바일/메신저 정렬 기준을 웹 정렬 기준과 동일하게 맞추기 위해서 order_num 수정
 */

/*
INSERT IGNORE INTO t_co_code_detail (detail_code, code, ischild, order_num, flag_1, flag_2, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES ('50', 'It0012', 'N', NULL, NULL, NULL, 'Y', 'SYSTEM', now(), NULL, NULL);
INSERT IGNORE INTO t_co_code_detail_multi (detail_code, code, lang_code, detail_name, note, use_yn, create_seq, create_date, modify_seq, modify_date) VALUES ('50', 'It0012', 'kr', '년월일시분', NULL, 'Y','SYSTEM', now(), NULL, NULL);

*/
-- 소스시퀀스 12940

/*
 v 1.2.129
 [시스템설정-인사이동현황] v_t_co_emp_multi-langCode 오류 수정
 */

-- 소스시퀀스 13037


/*
 v 1.2.131
 [시스템설정] 공통코드 항목설정관리 , 권한관리 다국어 추가
 [시스템설정] 공휴일관리 법정공휴일 다국어 추가
 [마이페이지] 주소록 사용여부 코드 use_yn = 'Y' 설정
 */

/*
INSERT IGNORE INTO t_co_code_detail_multi (detail_code, code, lang_code, detail_name, note, use_yn, create_seq, create_date) VALUES('50', 'It0012', 'cn', '年月日时分', '年月日时分', 'Y', 'SYSTEM', now());
INSERT IGNORE INTO t_co_code_detail_multi (detail_code, code, lang_code, detail_name, note, use_yn, create_seq, create_date) VALUES('50', 'It0012', 'en', 'Year month day time minute', NULL, 'Y', 'SYSTEM', now());
INSERT IGNORE INTO t_co_code_detail_multi (detail_code, code, lang_code, detail_name, note, use_yn, create_seq, create_date) VALUES('50', 'It0012', 'jp', '年月日時分', '年月日時分', 'Y', 'SYSTEM', now());

INSERT IGNORE INTO t_co_code_detail_multi (detail_code, code, lang_code, detail_name, note, use_yn, create_seq, create_date) VALUES ('001', 'COM505', 'cn', '用户', '用户', 'Y', 'SYSTEM', now());
INSERT IGNORE INTO t_co_code_detail_multi (detail_code, code, lang_code, detail_name, note, use_yn, create_seq, create_date) VALUES ('001', 'COM505', 'en', 'User', 'User', 'Y', 'SYSTEM', now());
INSERT IGNORE INTO t_co_code_detail_multi (detail_code, code, lang_code, detail_name, note, use_yn, create_seq, create_date) VALUES ('001', 'COM505', 'jp', '使用者', '使用者', 'Y', 'SYSTEM', now());
INSERT IGNORE INTO t_co_code_detail_multi (detail_code, code, lang_code, detail_name, note, use_yn, create_seq, create_date) VALUES ('002', 'COM505', 'cn', '部门', '部门', 'Y', 'SYSTEM', now());
INSERT IGNORE INTO t_co_code_detail_multi (detail_code, code, lang_code, detail_name, note, use_yn, create_seq, create_date) VALUES ('002', 'COM505', 'en', 'Department', 'Department', 'Y', 'SYSTEM', now());
INSERT IGNORE INTO t_co_code_detail_multi (detail_code, code, lang_code, detail_name, note, use_yn, create_seq, create_date) VALUES ('002', 'COM505', 'jp', '部署', '部署', 'Y', 'SYSTEM', now());
INSERT IGNORE INTO t_co_code_detail_multi (detail_code, code, lang_code, detail_name, note, use_yn, create_seq, create_date) VALUES ('003', 'COM505', 'cn', '职责', '职责', 'Y', 'SYSTEM', now());
INSERT IGNORE INTO t_co_code_detail_multi (detail_code, code, lang_code, detail_name, note, use_yn, create_seq, create_date) VALUES ('003', 'COM505', 'en', 'duties', 'duties', 'Y', 'SYSTEM', now());
INSERT IGNORE INTO t_co_code_detail_multi (detail_code, code, lang_code, detail_name, note, use_yn, create_seq, create_date) VALUES ('003', 'COM505', 'jp', '役職', '役職', 'Y', 'SYSTEM', now());
INSERT IGNORE INTO t_co_code_detail_multi (detail_code, code, lang_code, detail_name, note, use_yn, create_seq, create_date) VALUES ('004', 'COM505', 'cn', '职务', '职务', 'Y', 'SYSTEM', now());
INSERT IGNORE INTO t_co_code_detail_multi (detail_code, code, lang_code, detail_name, note, use_yn, create_seq, create_date) VALUES ('004', 'COM505', 'en', 'The class', 'The class', 'Y', 'SYSTEM', now());
INSERT IGNORE INTO t_co_code_detail_multi (detail_code, code, lang_code, detail_name, note, use_yn, create_seq, create_date) VALUES ('004', 'COM505', 'jp', '職級', '職級', 'Y', 'SYSTEM', now());
INSERT IGNORE INTO t_co_code_detail_multi (detail_code, code, lang_code, detail_name, note, use_yn, create_seq, create_date) VALUES ('005', 'COM505', 'cn', '管理者', '管理者', 'Y', 'SYSTEM', now());
INSERT IGNORE INTO t_co_code_detail_multi (detail_code, code, lang_code, detail_name, note, use_yn, create_seq, create_date) VALUES ('005', 'COM505', 'en', 'admin', 'admin', 'Y', 'SYSTEM', now());
INSERT IGNORE INTO t_co_code_detail_multi (detail_code, code, lang_code, detail_name, note, use_yn, create_seq, create_date) VALUES ('005', 'COM505', 'jp', '管理者', '管理者', 'Y', 'SYSTEM', now());

UPDATE t_co_code_multi SET NAME = '年/年月/年月日/年月日时/年月日时分' WHERE CODE = 'It0012' AND lang_code = 'cn';
UPDATE t_co_code_multi SET NAME = 'Year/YearMonth/YearMonthDay/YearMonthDayHour/YearMonthDayHourMinute' WHERE CODE = 'It0012' AND lang_code = 'en';
UPDATE t_co_code_multi SET NAME = '年/年月/年月日/年月日時/年月日時分' WHERE CODE = 'It0012' AND lang_code = 'jp';
UPDATE t_co_code_multi SET NAME = '년/년월/년월일/년월일시/년월일시분' WHERE CODE = 'It0012' AND lang_code = 'kr';

DELETE FROM t_co_calendar;
INSERT IGNORE INTO t_co_calendar (h_month,h_day,lunar_yn,holiday_name,create_seq,create_date,modify_seq,modify_date,holiday_name_en,holiday_name_jp,holiday_name_cn) VALUES ('01','01','N','설연휴','','','','','New Years holiday','旧正月の連休','元旦长假');
INSERT IGNORE INTO t_co_calendar (h_month,h_day,lunar_yn,holiday_name,create_seq,create_date,modify_seq,modify_date,holiday_name_en,holiday_name_jp,holiday_name_cn) VALUES ('01','01','Y','신정','','','','','New Years Day','正月','元旦');
INSERT IGNORE INTO t_co_calendar (h_month,h_day,lunar_yn,holiday_name,create_seq,create_date,modify_seq,modify_date,holiday_name_en,holiday_name_jp,holiday_name_cn) VALUES ('03','01','Y','삼일절','','','','','Independence Movement Day','3.1節','独立运动纪念日');
INSERT IGNORE INTO t_co_calendar (h_month,h_day,lunar_yn,holiday_name,create_seq,create_date,modify_seq,modify_date,holiday_name_en,holiday_name_jp,holiday_name_cn) VALUES ('04','08','N','석가탄신일','','','','','Buddhas Birthday','仏性日','佛诞日');
INSERT IGNORE INTO t_co_calendar (h_month,h_day,lunar_yn,holiday_name,create_seq,create_date,modify_seq,modify_date,holiday_name_en,holiday_name_jp,holiday_name_cn) VALUES ('05','05','Y','어린이날','','','','','Childrens Day','子供の日','儿童节');
INSERT IGNORE INTO t_co_calendar (h_month,h_day,lunar_yn,holiday_name,create_seq,create_date,modify_seq,modify_date,holiday_name_en,holiday_name_jp,holiday_name_cn) VALUES ('06','06','Y','현충일','','','','','Memorial Day','メモリアルデー','纪念日');
INSERT IGNORE INTO t_co_calendar (h_month,h_day,lunar_yn,holiday_name,create_seq,create_date,modify_seq,modify_date,holiday_name_en,holiday_name_jp,holiday_name_cn) VALUES ('08','15','N','추석연휴','','','','','Consecutive holidays of Moon Festival','中秋節の連休','中秋长假');
INSERT IGNORE INTO t_co_calendar (h_month,h_day,lunar_yn,holiday_name,create_seq,create_date,modify_seq,modify_date,holiday_name_en,holiday_name_jp,holiday_name_cn) VALUES ('08','15','Y','광복절','','','','','Liberation Day','光復節','独立日');
INSERT IGNORE INTO t_co_calendar (h_month,h_day,lunar_yn,holiday_name,create_seq,create_date,modify_seq,modify_date,holiday_name_en,holiday_name_jp,holiday_name_cn) VALUES ('10','03','Y','개천절','','','','','National Foundation Day','開天節','基金会日');
INSERT IGNORE INTO t_co_calendar (h_month,h_day,lunar_yn,holiday_name,create_seq,create_date,modify_seq,modify_date,holiday_name_en,holiday_name_jp,holiday_name_cn) VALUES ('10','09','Y','한글날','','','','','Hangul Day','ハングルの日','基金会日');
INSERT IGNORE INTO t_co_calendar (h_month,h_day,lunar_yn,holiday_name,create_seq,create_date,modify_seq,modify_date,holiday_name_en,holiday_name_jp,holiday_name_cn) VALUES ('12','25','Y','성탄절','','','','','Christmas','クリスマス','圣诞节');

UPDATE t_co_code SET use_yn = 'Y' WHERE CODE = 'ADDR001';
UPDATE t_co_code_multi SET use_yn = 'Y' WHERE CODE = 'ADDR001';

UPDATE t_co_group SET oneffice_token_api_url = mobile_gateway_url;

-- 소스시퀀스 13111
*/

/*
 v 1.2.136
 [시스템설정] 직급직책관리 정렬순서 max 4 > 9 수정
 */

/*
 v 1.2.138
 [공통] 날씨 포틀릿 기상청 API 키 컬럼 사이즈 변경 100 > 512
 */

/*
ALTER TABLE t_co_group MODIFY weather_api_key VARCHAR(512);
*/
-- 소스시퀀스 13356

/*
ALTER TABLE t_co_group ADD COLUMN IF NOT EXISTS erp10_auth_url varchar(256) DEFAULT '';
*/

-- 소스시퀀스 13419

/*
 v 1.2.145
 자원옵션관리 메뉴 추가
 */


/*
INSERT ignore INTO t_co_menu_adm
(menu_no, menu_gubun, upper_menu_no, menu_ordr, use_yn, url_gubun, url_path, sso_use_yn, menu_depth, menu_img_class, create_seq, create_date, modify_seq, modify_date, menu_adm_gubun, menu_auth_type, public_yn, delete_yn)
VALUES(302090000, 'MENU003', 302000000, 302090000, 'Y', 'schedule', '/Views/Common/mCalendar/adminManager', 'N', 3, NULL, 'SYSTEM', now(), NULL, NULL, 'MENU003', 'ADMIN', 'Y', NULL);
INSERT ignore INTO t_co_menu_adm_multi
(menu_no, lang_code, menu_nm, menu_dc, create_seq, create_date, modify_seq, modify_date)
VALUES(302090000, 'kr', '자원옵션관리', NULL, NULL, now(), NULL, NULL);
INSERT ignore INTO t_co_menu_adm_multi
(menu_no, lang_code, menu_nm, menu_dc, create_seq, create_date, modify_seq, modify_date)
VALUES(302090000, 'cn', '资源选项管理', NULL, 'SYSTEM', now(), 'SYSTEM', null);
INSERT ignore INTO t_co_menu_adm_multi
(menu_no, lang_code, menu_nm, menu_dc, create_seq, create_date, modify_seq, modify_date)
VALUES(302090000, 'en', 'Resource option management', NULL, 'SYSTEM', now(), NULL, NULL);
INSERT ignore INTO t_co_menu_adm_multi
(menu_no, lang_code, menu_nm, menu_dc, create_seq, create_date, modify_seq, modify_date)
VALUES(302090000, 'jp', '資源オプションの管理', NULL, 'SYSTEM', now(), NULL, NULL);

INSERT ignore INTO t_co_menu_adm
(menu_no, menu_gubun, upper_menu_no, menu_ordr, use_yn, url_gubun, url_path, sso_use_yn, menu_depth, menu_img_class, create_seq, create_date, modify_seq, modify_date, menu_adm_gubun, menu_auth_type, public_yn, delete_yn)
VALUES(1302090000, 'MENU003', 1302000000, 1302090000, 'Y', 'schedule', '/Views/Common/mCalendar/adminManager', 'N', 4, NULL, '3971', now(), '4498', null, 'MENU003', 'MASTER', 'Y', NULL);
INSERT ignore INTO t_co_menu_adm_multi
(menu_no, lang_code, menu_nm, menu_dc, create_seq, create_date, modify_seq, modify_date)
VALUES(1302090000, 'kr', '자원옵션관리', NULL, NULL, now(), NULL, NULL);
INSERT ignore INTO t_co_menu_adm_multi
(menu_no, lang_code, menu_nm, menu_dc, create_seq, create_date, modify_seq, modify_date)
VALUES(1302090000, 'cn', '资源选项管理', NULL, 'SYSTEM', now(), 'SYSTEM', null);
INSERT ignore INTO t_co_menu_adm_multi
(menu_no, lang_code, menu_nm, menu_dc, create_seq, create_date, modify_seq, modify_date)
VALUES(1302090000, 'en', 'Resource option management', NULL, 'SYSTEM', now(), NULL, NULL);
INSERT ignore INTO t_co_menu_adm_multi
(menu_no, lang_code, menu_nm, menu_dc, create_seq, create_date, modify_seq, modify_date)
VALUES(1302090000, 'jp', '資源オプションの管理', NULL, 'SYSTEM', now(), NULL, NULL);
*/

-- 소스시퀀스 13486

/*
 v 1.2.150
 인사근태 확장형 모듈 배포 메뉴 오류 보정 쿼리 추가
 */
/*
delete from t_co_menu_adm where menu_no = '2104040022' and menu_gubun = 'ATTENDEX001';
delete from t_co_menu_adm where menu_no = '2104040023' and menu_gubun = 'ATTENDEX001';
*/

/*
 v 1.2.155
 get_dept_pathNm 함수 수정
 */
--DELIMITER $$
--DROP FUNCTION IF EXISTS `get_dept_pathNm`$$
--
--CREATE FUNCTION `get_dept_pathNm`(
--	`_delimiter` TEXT,
--	`_dept_seq` VARCHAR(32),
--	`_group_seq` VARCHAR(32),
--	`_lang_code` VARCHAR(32)
--) RETURNS text CHARSET utf8
--    READS SQL DATA
--BEGIN
--    DECLARE _path TEXT;
--    DECLARE _id VARCHAR(32);
--    DECLARE _nm VARCHAR(128);
--    DECLARE _start_with VARCHAR(32);
--    DECLARE _depth INT;
--    DECLARE EXIT HANDLER FOR NOT FOUND RETURN _path;
--    
--    SET _start_with = '0';
--    SET _depth = 0;
--    
--    SET _id = COALESCE(_dept_seq, _start_with);
--    SELECT CASE WHEN t2.parent_dept_seq = '0' AND t3.display_yn = 'Y' THEN CONCAT(FN_GetMultiLang(_lang_code, t4.biz_name_multi),'|',FN_GetMultiLang(_lang_code, t1.dept_name_multi)) ELSE FN_GetMultiLang(_lang_code, dept_name_multi) END INTO _nm  FROM v_t_co_dept_multi t1 JOIN t_co_dept t2 ON t1.dept_seq = t2.dept_seq JOIN t_co_biz t3 ON t1.biz_seq = t3.biz_seq JOIN v_t_co_biz_multi t4 ON t1.biz_seq = t4.biz_Seq WHERE t1.dept_Seq = _dept_seq AND t1.group_seq = _group_seq;
--    SET _path = _nm;
--    LOOP
--    
--        IF _depth > 15 THEN
--        RETURN _path;
--        END IF;
--    
--        SELECT  a.parent_dept_seq, CASE WHEN c.parent_dept_seq = '0' AND d.display_yn = 'Y' THEN CONCAT((SELECT FN_GetMultiLang(_lang_code, biz_name_multi) FROM v_t_co_biz_multi WHERE biz_seq = d.biz_seq LIMIT 1), _delimiter, FN_GetMultiLang(_lang_code, b.dept_name_multi)) ELSE FN_GetMultiLang(_lang_code, b.dept_name_multi) END, _depth + 1
--        INTO    _id, _nm, _depth
--        FROM    t_co_dept a, v_t_co_dept_multi b, t_co_dept c, t_co_biz d
--        WHERE   a.group_seq = _group_seq
--        AND a.group_seq = b.group_seq
--        AND a.parent_dept_seq = b.dept_seq
--        AND b.dept_seq = c.dept_seq
--        AND c.biz_seq = d.biz_seq
--        AND a.dept_seq = _id
--        AND COALESCE(a.parent_dept_seq <> _start_with, TRUE)
--        AND COALESCE(a.parent_dept_seq <> _dept_seq, TRUE);
--        SET _path = CONCAT(_nm, _delimiter, _path);
--    END LOOP;
--END$$
--DELIMITER ;

-- 소스시퀀스 13838


/*
 v 1.2.167
 - WEHAGO 연동을 위한 aes key 컬럼 추가
 - WEHAGO 연동을 위한 wehago domain service key 컬럼 추가
 - WEHAGO GNB 메뉴 추가
 */

--ALTER TABLE t_co_group ADD COLUMN IF NOT EXISTS wehago_aes_key varchar(100) DEFAULT NULL COMMENT '위하고AES 암호키' AFTER wehago_software_key;
--ALTER TABLE t_co_comp ADD COLUMN IF NOT EXISTS wehago_domain_service_key varchar(100) DEFAULT NULL COMMENT '위하고 도메인 서비스키' AFTER wehago_duty_group;
--
--INSERT IGNORE INTO t_co_menu
--(comp_seq, menu_gubun, menu_no, upper_menu_no, menu_ordr, use_yn, url_gubun, url_path, sso_use_yn, menu_depth, menu_img_path, menu_img_class, menu_type, create_seq, create_date, modify_seq, modify_date, public_yn, delete_yn, open_menu_no)
--VALUES(NULL, 'WEHAGO', 2022000000, 0, 2022000000, 'N', 'WEHAGO', '/', 'N', 1, NULL, 'wehago', NULL, 'SYSTEM', NOW(), 'SYSTEM', NOW(), 'Y', '', 2022000000);
--
--INSERT IGNORE INTO t_co_menu_multi
--(menu_no, lang_code, menu_nm, menu_dc, create_seq, create_date, modify_seq, modify_date)
--VALUES(2022000000, 'kr', 'WEHAGO', '', 'SYSTEM', NOW(), 'SYSTEM', NOW());

-- 소스시퀀스 14163

/*
[ 공통 ] 멀티도메인 사용 시 SSL적용 후 메일세션 오류 개선
*/

-- 소스시퀀스 14206