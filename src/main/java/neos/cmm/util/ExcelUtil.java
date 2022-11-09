package neos.cmm.util;

//import kofia.pims.address.vo.KfAddressVO;

public class ExcelUtil {
	
	private ExcelUtil() {
	}
	/*
	public static List<KfAddressVO> AddressList(File file, EgovIdGnrService idgenAddressSeqService, String userId, String userNm) throws NumberFormatException, FdlException {
		
		List<KfAddressVO> list = new ArrayList<KfAddressVO> ();
		KfAddressVO kfAddressVO = null;
		String compNm = "";
		String codeVal = "";
		try {
			HSSFWorkbook workbook = new HSSFWorkbook(new FileInputStream(file));
			HSSFSheet sheet = workbook.getSheetAt(0);
		    
		    int rows = sheet.getLastRowNum();
		    for (int i = 1; i <= rows; i++) {
		    	
		        HSSFRow row = sheet.getRow(i);
		        kfAddressVO = new KfAddressVO();
		    
		        int idx = 0;
		        
		        compNm = row.getCell(idx++).toString(); // 회사명	
		        if(compNm.trim().equals("금융투자협회")){
		        	kfAddressVO.setCompany_code("KFA");
		        	kfAddressVO.setContainer_name(compNm);
		        }else{
		        	// map에서 회사명으로 코드를 뽑아온다.
		        	codeVal = codeMap(compNm.trim());
		        	if(codeVal == null){
		        		kfAddressVO.setCompany_code("ETC");
			        	kfAddressVO.setContainer_name(compNm);
		        	}else{
		        		String [] arr = codeVal.split("``");
		        		System.out.println(arr.length);
		        		System.out.println(arr[0]);
		        		kfAddressVO.setCompany_code(arr[0]);
			        	kfAddressVO.setContainer_code(arr[1]);
		        	}
		        }
		        
		        kfAddressVO.setCompany_code(row.getCell(idx++).toString()); // 회사명	
		        kfAddressVO.setDept_name(row.getCell(idx++).toString()); 	// 부서명	
		        kfAddressVO.setName(row.getCell(idx++).toString()); 		// 성명	
		        kfAddressVO.setJobs(row.getCell(idx++).toString()); 		// 직위(직책)	
		        kfAddressVO.setWork(row.getCell(idx++).toString()); 		// 담당업무	
		        kfAddressVO.setPhone(row.getCell(idx++).toString()); 		// 전화	
		        kfAddressVO.setFax(row.getCell(idx++).toString()); 			// 팩스	
		        kfAddressVO.setMobile(row.getCell(idx++).toString()); 		// 핸드폰번호	
		        kfAddressVO.setEmail(row.getCell(idx++).toString()); 		// 이메일	
		        kfAddressVO.setBirthday(row.getCell(idx++).toString()); 	// 생년월일	
		        kfAddressVO.setBirthplace(row.getCell(idx++).toString()); 	// 출생지	
		        kfAddressVO.setEducation(row.getCell(idx++).toString()); 	// 학력사항	
		        kfAddressVO.setCareer(row.getCell(idx++).toString()); 		// 주요경력	
		        kfAddressVO.setMemo1(row.getCell(idx++).toString()); 		// 기타(1)	
		        kfAddressVO.setMemo2(row.getCell(idx++).toString()); 		// 기타(2)
		        
		        // 기본정보 셋팅
		        kfAddressVO.setRegister_seq(Integer.parseInt(idgenAddressSeqService.getNextStringId()));
		        kfAddressVO.setIns_userid(userId);
		        kfAddressVO.setIns_name(userNm);
		        kfAddressVO.setUpd_userid(userId);
		        kfAddressVO.setUpd_name(userNm);
		        
		        list.add(kfAddressVO);
		    }
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return list;
	}
	*/
	//제거되지 않고 남은 디버그 코드
//	public static void main(String[] args) {
//		return;
//	}
}
