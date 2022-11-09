docApprovalDraft = {
		successUploadFile : function(arrDestFileName) {
			lumpApproval.setHwpFileName(arrDestFileName);
			frmMain.action = _g_contextPath+"/edoc/eapproval/workflow/docApprovalIUInsert.do" ;
			frmMain.method= "post";
			frmMain.target = "hiddenFrame" ;
			frmMain.enctype="multipart/form-data" ;
			frmMain.submit();
			frmMain.enctype="application/x-www-form-urlencoded" ;
		},

		successTempUploadFile : function(arrDestFileName) {
			lumpApproval.setHwpFileName(arrDestFileName);

			frmMain.action = _g_contextPath+"/edoc/eapproval/workflow/docTempApprovalIUInsert.do" ;
			frmMain.method= "post";
			frmMain.target = "hiddenFrame" ;
			frmMain.enctype="multipart/form-data" ;
			frmMain.submit();
			frmMain.enctype="application/x-www-form-urlencoded" ;
		}
}