/* 단축키 안내 */
var bMac = (g_browserCHK && g_browserCHK.isMacPC()) ? true : false;
var shortcutsInfo = [
	
	{
		"category": ID_RES_DIALOG_SHORTCUTS_BASIC,
		"data" : 
			[
				["SpaceBar","-",ID_RES_DIALOG_SHORTCUTS_SPACE],
				["Enter","-",ID_RES_DIALOG_SHORTCUTS_ENTER],
				["←","-",ID_RES_DIALOG_SHORTCUTS_LEFT],
				["→","-",ID_RES_DIALOG_SHORTCUTS_RIGHT],
				["↓","-",ID_RES_DIALOG_SHORTCUTS_DOWN],
				["↑","-",ID_RES_DIALOG_SHORTCUTS_UP],
				["Ctrl+→","-",ID_RES_DIALOG_SHORTCUTS_RIGHT_WORD],
				["Ctrl+←","-",ID_RES_DIALOG_SHORTCUTS_LEFT_WORD],
				["Ctrl+↓","-",ID_RES_DIALOG_SHORTCUTS_DOWN_PARAGRAPH],
				["Ctrl+↑","-",ID_RES_DIALOG_SHORTCUTS_UP_PARAGRAPH],
				["Home","-",ID_RES_DIALOG_SHORTCUTS_HOME],
				["End","-",ID_RES_DIALOG_SHORTCUTS_END],
				["Ctrl+Home","-",ID_RES_DIALOG_SHORTCUTS_HOME_PAGE],
				["Ctrl+End","-",ID_RES_DIALOG_SHORTCUTS_END_PAGE],
				["Delete","-",ID_RES_DIALOG_SHORTCUTS_DELETE],
				["BackSpace","-",ID_RES_DIALOG_SHORTCUTS_BACKSPACE],
				["Ctrl+Delete","-",ID_RES_DIALOG_SHORTCUTS_DELETE_WORD],
				["Ctrl+BackSpace","-",ID_RES_DIALOG_SHORTCUTS_DELETE_PREV_WORD]
			]
	},	
	{
		"category": ID_RES_DIALOG_SHORTCUTS_FILE,
		"data" : 
			[
				["Alt+N",ID_RES_TOOL_STRING_MENU_FILE+" - "+ID_RES_CONST_STRING_FILE_NEW,ID_RES_CONST_STRING_FILE_NEW],
				["Alt+O",ID_RES_TOOL_STRING_MENU_FILE+" - "+ID_RES_CONST_STRING_FILE_OPEN,ID_RES_CONST_STRING_FILE_OPEN],
				[bMac ? "Alt+S / Cmd+S" : "Alt+S / Ctrl+S",ID_RES_TOOL_STRING_MENU_FILE+" - "+ID_RES_CONST_STRING_SAVE_REMOTE,ID_RES_CONST_STRING_SAVE_REMOTE],
				[bMac ? "Alt+P / Cmd+P" : "Alt+P / Ctrl+P",ID_RES_TOOL_STRING_MENU_FILE+" - "+ID_RES_CONST_STRING_PRINT,ID_RES_CONST_STRING_PRINT]
			]
	},
	{
		"category": ID_RES_DIALOG_SHORTCUTS_EDIT,
		"data" : 
			[
				[bMac ? "Cmd+Z" : "Ctrl+Z",ID_RES_TOOL_STRING_MENU_EDIT+" - "+ID_RES_CONST_STRING_UNDO,ID_RES_CONST_STRING_UNDO],
				[bMac ? "Cmd+Shift+Z" : "Ctrl+Y",ID_RES_TOOL_STRING_MENU_EDIT+" - "+ID_RES_CONST_STRING_REDO,ID_RES_CONST_STRING_REDO],
				[bMac ? "Cmd+X / Shift+Delete" : "Ctrl+X / Shift+Delete",ID_RES_TOOL_STRING_MENU_EDIT+" - "+ID_RES_CONST_STRING_CUT,ID_RES_CONST_STRING_CUT],
				[bMac ? "Cmd+C / Ctrl+Insert" : "Ctrl+C / Ctrl+Insert",ID_RES_TOOL_STRING_MENU_EDIT+" - "+ID_RES_CONST_STRING_COPY,ID_RES_CONST_STRING_COPY],
				[bMac ? "Cmd+V / Shift+Insert" : "Ctrl+V / Shift+Insert",ID_RES_TOOL_STRING_MENU_EDIT+" - "+ID_RES_CONST_STRING_PASTE,ID_RES_CONST_STRING_PASTE],
				[bMac ? "Cmd+Alt+V" : "Ctrl+Alt+V",ID_RES_TOOL_STRING_MENU_EDIT+" - "+ID_RES_CONST_STRING_EDIT_PASTESPECIAL,ID_RES_CONST_STRING_EDIT_PASTESPECIAL],
				[bMac ? "Cmd+E" : "Ctrl+E",ID_RES_TOOL_STRING_MENU_EDIT+" - "+ID_RES_CONST_STRING_DELETE,ID_RES_CONST_STRING_DELETE],
				[bMac ? "Cmd+A" : "Ctrl+A",ID_RES_TOOL_STRING_MENU_EDIT+" - "+ID_RES_CONST_STRING_SELECT_ALL,ID_RES_CONST_STRING_SELECT_ALL],
				[bMac ? "Cmd+Q,F / Cmd+F" : "Ctrl+Q,F / Ctrl+F",ID_RES_TOOL_STRING_MENU_EDIT+" - "+ID_RES_CONST_STRING_EDIT_SEARCH,ID_RES_CONST_STRING_EDIT_SEARCH],
				[bMac ? "Cmd+Q,A / Cmd+H" : "Ctrl+Q,A / Ctrl+H",ID_RES_TOOL_STRING_MENU_EDIT+" - "+ID_RES_CONST_STRING_EDIT_REPLACE,ID_RES_CONST_STRING_EDIT_REPLACE],
				["F7",ID_RES_TOOL_STRING_MENU_EDIT+" - "+ID_RES_CONST_STRING_PAGE_SETTING,ID_RES_CONST_STRING_PAGE_SETTING]
			]
	},
	{

		"category": ID_RES_DIALOG_SHORTCUTS_INSERT,
		"data" : 
			[
				[bMac ? "Cmd+F10" : "Ctrl+F10",ID_RES_TOOL_STRING_MENU_INSERT+" - "+ID_RES_CONST_STRING_INSERT_SPECIALCHARS,ID_RES_CONST_STRING_INSERT_SPECIALCHARS],
				[bMac ? "Cmd+K,B" : "Ctrl+K,B",ID_RES_TOOL_STRING_MENU_INSERT+" - "+ID_RES_CONST_STRING_INSERT_BOOKMARK,ID_RES_CONST_STRING_INSERT_BOOKMARK],
				[bMac ? "Cmd+K,H" : "Ctrl+K,H",ID_RES_TOOL_STRING_MENU_INSERT+" - "+ID_RES_CONST_STRING_HYPERLINK_INSERT,ID_RES_CONST_STRING_HYPERLINK_INSERT],
				[bMac ? "Cmd+Alt+E" : "Ctrl+Alt+E",ID_RES_TOOL_STRING_MENU_INSERT+" - "+ID_RES_CONST_STRING_TABLE_CREATE,ID_RES_CONST_STRING_TABLE_INSERT],
			]
	},
	{
		"category": ID_RES_DIALOG_SHORTCUTS_STYLE,
		"data" : 
			[
				["Alt+L",ID_RES_TOOL_STRING_MENU_BASIC+" - "+ID_RES_CONST_STRING_STYLE_FONT,ID_RES_CONST_STRING_STYLE_FONT],
				["Alt+W",ID_RES_TOOL_STRING_MENU_BASIC+" - "+ID_RES_CONST_STRING_STYLE_PARAGRAPH,ID_RES_CONST_STRING_STYLE_PARAGRAPH],
				["Alt+C",ID_RES_TOOL_STRING_MENU_BASIC+" - "+ID_RES_CONST_STRING_COPY, ID_RES_TOOL_STRING_MENU_BASIC+' '+ID_RES_CONST_STRING_COPY],
				["Alt+V",ID_RES_TOOL_STRING_MENU_BASIC+" - "+ID_RES_CONST_STRING_PASTE, ID_RES_TOOL_STRING_MENU_BASIC+' '+ID_RES_CONST_STRING_PASTE],

				["Ctrl+Shift+[",ID_RES_TOOL_STRING_MENU_BASIC+" - "+ID_RES_CONST_STRING_ORDERLIST+"<br />"+ID_RES_PROP_BUILDER_BLOCK_PROP_ITEM_APPLY+"/"+ID_RES_CONST_STRING_CLEAR,ID_RES_CONST_STRING_ORDERLIST+"<br />"+ID_RES_PROP_BUILDER_BLOCK_PROP_ITEM_APPLY+"/"+ID_RES_CONST_STRING_CLEAR],
				["Ctrl+Shift+]",ID_RES_TOOL_STRING_MENU_BASIC+" - "+ID_RES_CONST_STRING_UNORDERLIST+"<br />"+ID_RES_PROP_BUILDER_BLOCK_PROP_ITEM_APPLY+"/"+ID_RES_CONST_STRING_CLEAR,ID_RES_CONST_STRING_UNORDERLIST+"<br />"+ID_RES_PROP_BUILDER_BLOCK_PROP_ITEM_APPLY+"/"+ID_RES_CONST_STRING_CLEAR],
				["Alt+←",ID_RES_TOOL_STRING_MENU_BASIC+" - "+ID_RES_CONST_STRING_STYLE_INCREASEORDER,ID_RES_CONST_STRING_STYLE_INCREASEORDER],
				["Alt+→",ID_RES_TOOL_STRING_MENU_BASIC+" - "+ID_RES_CONST_STRING_STYLE_DECREASEORDER,ID_RES_CONST_STRING_STYLE_DECREASEORDER],
				["Alt+Shift+E / Ctrl+]",ID_RES_TOOL_STRING_MENU_BASIC+" - "+ID_RES_CONST_STRING_STYLE_FONT,ID_RES_CONST_STRING_STYLE_INCREASE_FONTSIZE],
				["Alt+Shift+R / Ctrl+[",ID_RES_TOOL_STRING_MENU_BASIC+" - "+ID_RES_CONST_STRING_STYLE_FONT,ID_RES_CONST_STRING_STYLE_DECREASE_FONTSIZE],
				["Alt+Shift+W",ID_RES_TOOL_STRING_MENU_BASIC+" - "+ID_RES_CONST_STRING_STYLE_FONT,ID_RES_CONST_STRING_INCREASE_LETTERSPACING],
				["Alt+Shift+N",ID_RES_TOOL_STRING_MENU_BASIC+" - "+ID_RES_CONST_STRING_STYLE_FONT,ID_RES_CONST_STRING_DECREASE_LETTERSPACING],
				["Alt+Shift+U / Ctrl+U",ID_RES_TOOL_STRING_MENU_BASIC+" - "+ID_RES_CONST_STRING_STYLE_FONT,ID_RES_CONST_STRING_UNDERLINE],
				["Alt+Shift+B / Ctrl+B",ID_RES_TOOL_STRING_MENU_BASIC+" - "+ID_RES_CONST_STRING_STYLE_FONT,ID_RES_CONST_STRING_BOLD],
				["Alt+Shift+I / Ctrl+I",ID_RES_TOOL_STRING_MENU_BASIC+" - "+ID_RES_CONST_STRING_STYLE_FONT,ID_RES_CONST_STRING_ITALIC],
				["Alt+Shift+P",ID_RES_TOOL_STRING_MENU_BASIC+" - "+ID_RES_CONST_STRING_STYLE_FONT,ID_RES_CONST_STRING_SUPERSCRIPT],
				["Alt+Shift+S",ID_RES_TOOL_STRING_MENU_BASIC+" - "+ID_RES_CONST_STRING_STYLE_FONT,ID_RES_CONST_STRING_SUBSCRIPT],
				[bMac ? "Cmd+Alt+A" : "Ctrl+Alt+A",ID_RES_TOOL_STRING_MENU_BASIC+" - "+ID_RES_CONST_STRING_STYLE_FONT,ID_RES_CONST_STRING_SUPERSCRIPT+"/"+ID_RES_CONST_STRING_SUBSCRIPT+"/"+ID_RES_DIALOG_STRING_NORMAL],
				[bMac ? "Cmd+Alt+5" : "Ctrl+Alt+5",ID_RES_TOOL_STRING_MENU_BASIC+" - "+ID_RES_CONST_STRING_STYLE_PARAGRAPH,ID_RES_CONST_STRING_DECREASE_MARGIN_LEFT],
				[bMac ? "Cmd+Alt+6" : "Ctrl+Alt+6",ID_RES_TOOL_STRING_MENU_BASIC+" - "+ID_RES_CONST_STRING_STYLE_PARAGRAPH,ID_RES_CONST_STRING_INCREASE_MARGIN_LEFT],
				[bMac ? "Cmd+Alt+7" : "Ctrl+Alt+7",ID_RES_TOOL_STRING_MENU_BASIC+" - "+ID_RES_CONST_STRING_STYLE_PARAGRAPH,ID_RES_CONST_STRING_INCREASE_MARGIN_RIGHT],
				[bMac ? "Cmd+Alt+8" : "Ctrl+Alt+8",ID_RES_TOOL_STRING_MENU_BASIC+" - "+ID_RES_CONST_STRING_STYLE_PARAGRAPH,ID_RES_CONST_STRING_DECREASE_MARGIN_RIGHT],
				[bMac ? "Cmd+F5 / Cmd+Shift+O" : "Ctrl+F5 / Ctrl+Shift+O",ID_RES_TOOL_STRING_MENU_BASIC+" - "+ID_RES_CONST_STRING_STYLE_PARAGRAPH,ID_RES_CONST_STRING_FIRST_PARAGRAPH_OUTDENT],
				[bMac ? "Cmd+F6 / Cmd+Shift+I" : "Ctrl+F6 / Ctrl+Shift+I",ID_RES_TOOL_STRING_MENU_BASIC+" - "+ID_RES_CONST_STRING_STYLE_PARAGRAPH,ID_RES_CONST_STRING_FIRST_PARAGRAPH_INDENT],
				["Alt+Shift+Z ",ID_RES_TOOL_STRING_MENU_BASIC+" - "+ID_RES_CONST_STRING_STYLE_PARAGRAPH,ID_RES_CONST_STRING_INCREASE_LINEHEIGHT],
				["Alt+Shift+A ",ID_RES_TOOL_STRING_MENU_BASIC+" - "+ID_RES_CONST_STRING_STYLE_PARAGRAPH,ID_RES_CONST_STRING_DECREASE_LINEHEIGHT],
				[bMac ? "Cmd+Shift+M" : "Ctrl+Shift+M",ID_RES_TOOL_STRING_MENU_BASIC+" - "+ID_RES_CONST_STRING_STYLE_PARAGRAPH,ID_RES_CONST_STRING_JUSTIFYJUSTIFY],
				[bMac ? "Cmd+Shift+L" : "Ctrl+Shift+L",ID_RES_TOOL_STRING_MENU_BASIC+" - "+ID_RES_CONST_STRING_STYLE_PARAGRAPH,ID_RES_CONST_STRING_JUSTIFYLEFT],
				[bMac ? "Cmd+Shift+R" : "Ctrl+Shift+R",ID_RES_TOOL_STRING_MENU_BASIC+" - "+ID_RES_CONST_STRING_STYLE_PARAGRAPH,ID_RES_CONST_STRING_JUSTIFYRIGHT],
				[bMac ? "Cmd+Shift+C" : "Ctrl+Shift+C",ID_RES_TOOL_STRING_MENU_BASIC+" - "+ID_RES_CONST_STRING_STYLE_PARAGRAPH,ID_RES_CONST_STRING_JUSTIFYCENTER]
			]
	},
	{
		"category": ID_RES_DIALOG_SHORTCUTS_TABLE,
		"data" : 
			[
				["Shift+F5","-",ID_RES_CONST_STRING_SELECT_CURRENT_CELL],
				[ID_RES_CONST_STRING_ARROW_KEY,"-",ID_RES_CONST_STRING_MOVE_CELL_UNIT],
				[bMac ? "Cmd+Enter" : "Ctrl+Enter","-",ID_RES_PROP_TAG_ADD_ROW],
				[bMac ? "Cmd+BackSpace" : "Ctrl+BackSpace","-",ID_RES_CONST_STRING_TABLE_DELETE_ROW],
				["Tab","-",ID_RES_CONST_STRING_MOVE_NEXT_CELL],
				["Alt + T","-",ID_RES_STRING_INSERT_TAB],				
				//["Shift+Tab","-",ID_RES_CONST_STRING_MOVE_PREV_CELL],
				["Alt+Insert",ID_RES_TOOL_STRING_MENU_TABLE+" - "+ID_RES_CONST_STRING_TABLE_ADD_ROW_COL,ID_RES_CONST_STRING_TABLE_ADD_ROW_COL],
				//["Alt+Delete",ID_RES_TOOL_STRING_MENU_TABLE+" - "+ID_RES_CONST_STRING_TABLE_DELETE_ROW_COL,ID_RES_CONST_STRING_TABLE_DELETE_ROW_COL],
				[bMac ? "Cmd+Shift+H" : "Ctrl+Shift+H",ID_RES_CONST_STRING_TABLE_EASY_FORMULA+" - "+ID_RES_CONST_STRING_TABLE_HORIZONTAL_SUM,ID_RES_CONST_STRING_TABLE_HORIZONTAL_SUM],
				[bMac ? "Cmd+Shift+V" : "Ctrl+Shift+V",ID_RES_CONST_STRING_TABLE_EASY_FORMULA+" - "+ID_RES_CONST_STRING_TABLE_VERTICAL_SUM,ID_RES_CONST_STRING_TABLE_VERTICAL_SUM],
				[bMac ? "Cmd+Shift+J" : "Ctrl+Shift+J",ID_RES_CONST_STRING_TABLE_EASY_FORMULA+" - "+ID_RES_CONST_STRING_TABLE_HORIZONTAL_AVERAGE,ID_RES_CONST_STRING_TABLE_HORIZONTAL_AVERAGE],
				[bMac ? "Cmd+Shift+B" : "Ctrl+Shift+B",ID_RES_CONST_STRING_TABLE_EASY_FORMULA+" - "+ID_RES_CONST_STRING_TABLE_VERTICAL_AVERAGE,ID_RES_CONST_STRING_TABLE_VERTICAL_AVERAGE],
				[bMac ? "Cmd+Shift+K" : "Ctrl+Shift+K",ID_RES_CONST_STRING_TABLE_EASY_FORMULA+" - "+ID_RES_CONST_STRING_TABLE_HORIZONTAL_MULTIPLY,ID_RES_CONST_STRING_TABLE_HORIZONTAL_MULTIPLY],
				[bMac ? "Cmd+Shift+G" : "Ctrl+Shift+G",ID_RES_CONST_STRING_TABLE_EASY_FORMULA+" - "+ID_RES_CONST_STRING_TABLE_VERTICAL_MULTIPLY,ID_RES_CONST_STRING_TABLE_VERTICAL_MULTIPLY],
				[bMac ? "Cmd+Space" : "Ctrl+Space","-",ID_RES_CONST_STRING_BLOCK_ALL_COL],
				[bMac ? "Cmd+Shift+Space" : "Ctrl+Shift+Space","-",ID_RES_CONST_STRING_BLOCK_ALL_ROW],
				[bMac ? "Cmd+A" : "Ctrl+A","-",ID_RES_CONST_STRING_SELECT_ALL],
				[bMac ? "Cmd+Alt+H" : "Ctrl+Alt+H",ID_RES_CONST_STRING_TABLE_CELL_SAME_HEIGHT+"<br/>("+ID_RES_CONST_STRING_MULTI_CELL_SELECT+")",ID_RES_CONST_STRING_TABLE_CELL_SAME_HEIGHT],
				[bMac ? "Cmd+Alt+W" : "Ctrl+Alt+W",ID_RES_CONST_STRING_TABLE_CELL_SAME_WIDTH+"<br/>("+ID_RES_CONST_STRING_MULTI_CELL_SELECT+")",ID_RES_CONST_STRING_TABLE_CELL_SAME_WIDTH],
				[bMac ? "Cmd+Alt+M" : "Ctrl+Alt+M",ID_RES_CONST_STRING_TABLE_MERGE_CELL+"<br/>("+ID_RES_CONST_STRING_MULTI_CELL_SELECT+")",ID_RES_CONST_STRING_TABLE_MERGE_CELL],
				[bMac ? "Cmd+Alt+S" : "Ctrl+Alt+S",ID_RES_CONST_STRING_TABLE_SPLIT_CELL,ID_RES_CONST_STRING_TABLE_SPLIT_CELL],
				[bMac ? "Cmd+L" : "Ctrl+L",ID_RES_TOOL_STRING_MENU_TABLE+" - "+ID_RES_CONST_STRING_TABLE_CELL_STYLE,ID_RES_CONST_STRING_TABLE_CELL_STYLE]
			]
	},	
	{
		"category": ID_RES_TOOL_STRING_MENU_VIEW,
		"data" : 
			[
				["Alt+Enter","-",ID_RES_TOOL_STRING_TAB_PREVIEW],
				["Ctrl+G","-",ID_RES_CONST_STRING_PAGE_MOVE],
			]
	}		
];