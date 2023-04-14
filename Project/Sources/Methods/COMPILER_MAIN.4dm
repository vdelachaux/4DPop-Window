//%attributes = {"invisible":true}
var component : cs:C1710._component
component:=component || cs:C1710._component.new()

C_LONGINT:C283(<>Win_palette)
C_LONGINT:C283(<>Lst_windows)
C_LONGINT:C283(<>Lst_wHidden)

C_TEXT:C284(<>Txt_digest)

<>Lst_wHidden:=<>Lst_wHidden || New list:C375

If (False:C215)
	
	C_TEXT:C284(DATABASE METHOD; $1)
	C_LONGINT:C283(DATABASE METHOD; $2)
	
End if 

If (False:C215)  // Macros
	
	C_TEXT:C284(macroOnOpen; $1)
	
	C_TEXT:C284(macroOnClose; $1)
	
End if 

If (False:C215)
	
	C_LONGINT:C283(_o_TOOL_WINDOWS; $1)
	
	C_TEXT:C284(_o_methodGetPath; $0)
	C_TEXT:C284(_o_methodGetPath; $1)
	C_LONGINT:C283(_o_methodGetPath; $2)
	
	C_TEXT:C284(tool_renameWindows; $1)
	
	C_TEXT:C284(Palette_ADD_ELEMENT; $1)
	C_LONGINT:C283(Palette_ADD_ELEMENT; $2)
	
	C_LONGINT:C283(Palette_ADD_WINDOW; $1)
	
	C_TEXT:C284(Palette_MENU; $1)
	
	C_TEXT:C284(Palette_RUN; $1)
	
End if 