//%attributes = {"invisible":true}
var component : cs:C1710._component
component:=component || cs:C1710._component.new()

C_BOOLEAN:C305(<>Boo_inited)

If (Not:C34(<>Boo_inited))
	
	C_LONGINT:C283(<>Lon_options)
	
	C_LONGINT:C283(<>Win_palette)
	C_LONGINT:C283(<>Lst_windows)
	C_LONGINT:C283(<>Lst_wHidden)
	
	C_TEXT:C284(<>Txt_digest)
	
	<>Boo_inited:=True:C214
	
	<>Lst_wHidden:=New list:C375
	
End if 

If (False:C215)
	
	C_TEXT:C284(databaseMethods; $1)
	C_LONGINT:C283(databaseMethods; $2)
	
End if 

If (False:C215)  //shared
	
	C_POINTER:C301(menu; $1)
	
	C_OBJECT:C1216(window; $0)
	
	C_TEXT:C284(macroOnOpen; $1)
	
	C_TEXT:C284(macroOnClose; $1)
	
End if 

If (False:C215)
	
	C_TEXT:C284(_o_4DPopWindow_path; $0)
	C_TEXT:C284(_o_4DPopWindow_path; $1)
	C_POINTER:C301(_o_4DPopWindow_path; $2)
	
	C_POINTER:C301(tablePointer; $0)
	C_TEXT:C284(tablePointer; $1)
	
	C_TEXT:C284(mnu_RELEASE_MENU; $1)
	
	C_LONGINT:C283(TOOL_WINDOWS; $1)
	
	C_TEXT:C284(methodGetPath; $0)
	C_TEXT:C284(methodGetPath; $1)
	C_LONGINT:C283(methodGetPath; $2)
	
	C_TEXT:C284(tool_renameWindows; $1)
	
	C_TEXT:C284(Palette_ADD_ELEMENT; $1)
	C_LONGINT:C283(Palette_ADD_ELEMENT; $2)
	
	C_LONGINT:C283(Palette_ADD_WINDOW; $1)
	
	C_TEXT:C284(Palette_MENU; $1)
	
	C_TEXT:C284(Palette_RUN; $1)
	
	C_TEXT:C284(WINDOW_ACTION; $1)
	C_LONGINT:C283(WINDOW_ACTION; $2)
End if 