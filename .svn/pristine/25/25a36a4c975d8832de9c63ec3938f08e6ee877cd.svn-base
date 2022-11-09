/*
* 테이블 셀의 정렬 드롭다운 다이알로그 
* 정의가 중복되어 table_cell_align_list 사용.
*/
var dzeTableCellAlignList = [
	{
		"align": "none",
	}
];

/*
 * 테이블 스타일 드롭다운 다이알로그
 * 
 * 1. 일반적인 스타일
 * 2. 세로 테두리가 없고 가로 테두리는 회색, 글자색은 검은색
 * 3. 세로 테두리가 없고 가로 테두리는 회색, 글자색도 회색 + 짝수번째 행은 옅은 회색
 * 4. 테두리가 모두 회색이고 첫 번째 행의 세로 테두리 및 배경색이 회색, 글자색은 검은색
 * 5. 테두리가 모두 흰색이고 첫 번째 행/열의 배경색이 짙은 회색, 글자색은 흰색 + 그 외의 셀은 짝수 번째가 회색, 홀수번째가 옅은 회색. 글자색은 검은색
 * 6. 테두리가 짙은 회색이고 세로 테두리는 없음. 첫 번째 행의 배경색이 짙은 회색, 글자색은 흰색 + 그 외의 셀은 열 테두리가 없으며 글자색은 검은색
 * 7. 첫 번째 행은 테두리 및 배경이 검은색이고 글자색은 흰색 + 그 외의 셀은 테두리가 모두 짙은 회색이며 배경색은 짝수 번째 행은 회색, 홀수 번째 행은 흰색. 글자색은 검은색
 * 8. 첫 번째 행은 테두리 및 배경이 검은색이고 글자색은 흰색 + 그 외의 셀은 테두리가 모두 흰색이며 첫 번째 열의 배경색은 검은색고 글자색은 흰색 + 짝수/홀수 번째 셀의 배경은 각각 짙음이 다른 회색. 글자색은 검은색
 * 9. 전체 배경색 및 테두리 색은 검은색이며 글자색은 흰색. 첫 번째 행 하단과 열의 우측 테두리는 흰색.
 * 
 * 첫 번째 행에 대한 테두리색, 열 구분 테두리색, 배경색, 글자색 + 기타 행의 열 구분 테두리색
 * 첫 번째 열에 대한 테두리색, 배경색, 글자색
 * 짝수 행의 테두리색, 배경색, 글자색
 * 홀수 행의 테두리색, 배경색, 글자색
 * 
 * 첫 번째 열의 배경색이 없을 경우에는 짝수/홀수 행의 배경색을 따라감.
 * color의 순서는 [ top , right , bottom , left ]
 */
var dzeTableStyleList = [
	{
		style: "style_one",
		firstRow_borderColor: ["#000000","#000000","#000000","#000000"],
		firstRow_seperateColor: "#000000",
		etcRow_seperateColor: "#000000",
		firstRow_backgroundColor: "#FFFFFF",
		firstRow_fontColor: "#000000",
		
		firstCol_borderColor: ["#000000","#000000","#000000","#000000"],
		firstCol_backgroundColor: "#FFFFFF",
		firstCol_fontColor: "#000000",
		
		evenRow_borderColor: ["#000000","#000000","#000000","#000000"],
		evenRow_backgroundColor: "#FFFFFF",
		evenRow_fontColor: "#000000",
		
		oddRow_borderColor: ["#000000","#000000","#000000","#000000"],
		oddRow_backgroundColor: "#FFFFFF",
		oddRow_fontColor: "#000000",
	},
	{
		style: "style_two",
		firstRow_borderColor: ["#9CA4A3","#FFFFFF","#9CA4A3","#FFFFFF"],
		firstRow_seperateColor: "",
		etcRow_seperateColor: "",
		firstRow_backgroundColor: "#FFFFFF",
		firstRow_fontColor: "#000000",
		
		firstCol_borderColor: ["#9CA4A3","","#9CA4A3","#FFFFFF"],
		firstCol_backgroundColor: "",
		firstCol_fontColor: "#000000",
		
		evenRow_borderColor: ["#9CA4A3","#FFFFFF","#9CA4A3","#FFFFFF"],
		evenRow_backgroundColor: "#FFFFFF",
		evenRow_fontColor: "#000000",
		
		oddRow_borderColor: ["#9CA4A3","#FFFFFF","#9CA4A3","#FFFFFF"],
		oddRow_backgroundColor: "#FFFFFF",
		oddRow_fontColor: "#000000",
	},
	{
		style: "style_three",
		firstRow_borderColor: ["#B0B6B5","#FFFFFF","#B0B6B5","#FFFFFF"],
		firstRow_seperateColor: "",
		etcRow_seperateColor: "",
		firstRow_backgroundColor: "#FFFFFF",
		firstRow_fontColor: "#90918F",
		
		firstCol_borderColor: ["#FFFFFF","","#FFFFFF","#FFFFFF"],
		firstCol_backgroundColor: "",
		firstCol_fontColor: "#90918F",
		
		evenRow_borderColor: ["#FFFFFF","#FFFFFF","#FFFFFF","#FFFFFF"],
		evenRow_backgroundColor: "#EEE9EF",
		evenRow_fontColor: "#90918F",
		
		oddRow_borderColor: ["#FFFFFF","#FFFFFF","#FFFFFF","#FFFFFF"],
		oddRow_backgroundColor: "#FFFFFF",
		oddRow_fontColor: "#90918F",
	},
	{
		style: "style_four",
		firstRow_borderColor: ["#B5B3B2","#B5B3B2","#B5B3B2","#B5B3B2"],
		firstRow_seperateColor: "#B5B3B2",
		etcRow_seperateColor: "#B5B3B2",
		firstRow_backgroundColor: "#CECFCE",
		firstRow_fontColor: "#000000",
		
		firstCol_borderColor: ["#B5B3B2","#B5B3B2","#B5B3B2","#B5B3B2"],
		firstCol_backgroundColor: "",
		firstCol_fontColor: "#000000",
		
		evenRow_borderColor: ["#B5B3B2","#B5B3B2","#B5B3B2","#B5B3B2"],
		evenRow_backgroundColor: "#FFFFFF",
		evenRow_fontColor: "#000000",
		
		oddRow_borderColor: ["#B5B3B2","#B5B3B2","#B5B3B2","#B5B3B2"],
		oddRow_backgroundColor: "#FFFFFF",
		oddRow_fontColor: "#000000",
	},
	{
		style: "style_five",
		firstRow_borderColor: ["#FFFFFF","#FFFFFF","#FFFFFF","#FFFFFF"],
		firstRow_seperateColor: "",
		etcRow_seperateColor: "#FFFFFF",
		firstRow_backgroundColor: "#A5A6A5",
		firstRow_fontColor: "#FFFFFF",
		
		firstCol_borderColor: ["#FFFFFF","#FFFFFF","#FFFFFF","#FFFFFF"],
		firstCol_backgroundColor: "#A5A6A5",
		firstCol_fontColor: "#FFFFFF",
		
		evenRow_borderColor: ["#FFFFFF","#FFFFFF","#FFFFFF","#FFFFFF"],
		evenRow_backgroundColor: "#DADBDA",
		evenRow_fontColor: "#000000",
		
		oddRow_borderColor: ["#FFFFFF","#FFFFFF","#FFFFFF","#FFFFFF"],
		oddRow_backgroundColor: "#ECEEEC",
		oddRow_fontColor: "#000000",
	},
	{
		style: "style_six",
		firstRow_borderColor: ["#A5A6A5","#A5A6A5","#A5A6A5","#A5A6A5"],
		firstRow_seperateColor: "",
		etcRow_seperateColor: "",
		firstRow_backgroundColor: "#A5A6A5",
		firstRow_fontColor: "#FFFFFF",
		
		firstCol_borderColor: ["#A5A6A5","","#A5A6A5","#A5A6A5"],
		firstCol_backgroundColor: "",
		firstCol_fontColor: "#000000",
		
		evenRow_borderColor: ["#A5A6A5","#A5A6A5","#A5A6A5","#A5A6A5"],
		evenRow_backgroundColor: "#FFFFFF",
		evenRow_fontColor: "#000000",
		
		oddRow_borderColor: ["#A5A6A5","#A5A6A5","#A5A6A5","#A5A6A5"],
		oddRow_backgroundColor: "#FFFFFF",
		oddRow_fontColor: "#000000",
	},
	{
		style: "style_seven",
		firstRow_borderColor: ["#000000","#000000","#000000","#000000"],
		firstRow_seperateColor: "",
		etcRow_seperateColor: "#7A7878",
		firstRow_backgroundColor: "#000000",
		firstRow_fontColor: "#FFFFFF",
		
		firstCol_borderColor: ["#7A7878","#7A7878","#7A7878","#7A7878"],
		firstCol_backgroundColor: "",
		firstCol_fontColor: "#000000",
		
		evenRow_borderColor: ["#7A7878","#7A7878","#7A7878","#7A7878"],
		evenRow_backgroundColor: "#C8CECD",
		evenRow_fontColor: "#000000",
		
		oddRow_borderColor: ["#7A7878","#7A7878","#7A7878","#7A7878"],
		oddRow_backgroundColor: "#FFFFFF",
		oddRow_fontColor: "#000000",
	},
	{
		style: "style_eight",
		firstRow_borderColor: ["#FFFFFF","#FFFFFF","#FFFFFF","#FFFFFF"],
		firstRow_seperateColor: "",
		etcRow_seperateColor: "#FFFFFF",
		firstRow_backgroundColor: "#000000",
		firstRow_fontColor: "#FFFFFF",
		
		firstCol_borderColor: ["#FFFFFF","#FFFFFF","#FFFFFF","#FFFFFF"],
		firstCol_backgroundColor: "#000000",
		firstCol_fontColor: "#FFFFFF",
		
		evenRow_borderColor: ["#FFFFFF","#FFFFFF","#FFFFFF","#FFFFFF"],
		evenRow_backgroundColor: "#9B9E95",
		evenRow_fontColor: "#000000",
		
		oddRow_borderColor: ["#FFFFFF","#FFFFFF","#FFFFFF","#FFFFFF"],
		oddRow_backgroundColor: "#CACFCA",
		oddRow_fontColor: "#000000",
	},
	{
		style: "style_nine",
		firstRow_borderColor: ["#000000","#000000","#FFFFFF","#000000"],
		firstRow_seperateColor: "",
		etcRow_seperateColor: "",
		firstRow_backgroundColor: "#000000",
		firstRow_fontColor: "#FFFFFF",
		
		firstCol_borderColor: ["#FFFFFF","#FFFFFF","#FFFFFF","#000000"],
		firstCol_backgroundColor: "",
		firstCol_fontColor: "#FFFFFF",
		
		evenRow_borderColor: ["#FFFFFF","#000000","#FFFFFF","#FFFFFF"],
		evenRow_backgroundColor: "#000000",
		evenRow_fontColor: "#FFFFFF",
		
		oddRow_borderColor: ["#FFFFFF","#000000","#FFFFFF","#FFFFFF"],
		oddRow_backgroundColor: "#000000",
		oddRow_fontColor: "#FFFFFF",
	}
];
