/*
alter table t_co_comment modify(emp_name varchar(512));
alter table t_co_comment modify(comp_name varchar(512));
alter table t_co_comment modify(dept_name varchar(512));
alter table t_co_comment modify(duty_name varchar(512));
alter table t_co_comment modify(position_name varchar(512));

update t_co_comp set comp_email_yn = 'N' where email_domain is null;
delete from tcmg_optionvalue where co_id = '0' and option_id in (select option_id from tcmg_optionset where option_gb = '2');
delete from tcmg_optionvalue where co_id != '0' and option_id in (select option_id from tcmg_optionset where option_gb = '1');

ALTER TABLE t_co_portlet ADD (portlet_nm_en varchar(50));
ALTER TABLE t_co_portlet ADD (portlet_nm_cn varchar(50));
ALTER TABLE t_co_portlet ADD (portlet_nm_jp varchar(50

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

update t_alert_admin set alert_yn='N' where alert_type in ('AMEA105','AMTA001','AMTA101') and alert_yn = 'B';
update t_alert_setting set alert_yn='Y' where alert_type in ('AMEA105','AMTA001','AMTA101');
*/

-- 소스시퀀스 5229

/*
 * 항목관리 기능 추가에 따른 다국어 쿼리 추가 
 * 사용자정의코드관리 (다국어 컬럼 추가)
 * 외부시스템코드관리 (다국어 컬럼 추가)
 * 
 * */

ALTER TABLE TITG_CODE ADD(code_val_en VARCHAR2(50));
ALTER TABLE TITG_CODE ADD(code_val_jp VARCHAR2(50));
ALTER TABLE TITG_CODE ADD(code_val_cn VARCHAR2(50));
ALTER TABLE TITG_CUSTOMSET ADD(display_type_en VARCHAR2(50));
ALTER TABLE TITG_CUSTOMSET ADD(display_type_jp VARCHAR2(50));
ALTER TABLE TITG_CUSTOMSET ADD(display_type_cn VARCHAR2(50));
ALTER TABLE TITG_CUSTOMSET ADD(return_code_en VARCHAR2(50));
ALTER TABLE TITG_CUSTOMSET ADD(return_code_jp VARCHAR2(50));
ALTER TABLE TITG_CUSTOMSET ADD(return_code_cn VARCHAR2(50));
ALTER TABLE TITG_CUSTOMSET ADD(return_code_display_type_en VARCHAR2(50));
ALTER TABLE TITG_CUSTOMSET ADD(return_code_display_type_jp VARCHAR2(50));
ALTER TABLE TITG_CUSTOMSET ADD(return_code_display_type_cn VARCHAR2(50));
 