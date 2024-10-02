//%attributes = {"invisible":true}
var component : cs:C1710._component
component:=component || cs:C1710._component.new()

If (False:C215)
	var <>Win_palette : Integer
	var <>Lst_windows : Integer
	var <>Lst_wHidden : Integer
	
	var <>Txt_digest : Text
	
	<>Lst_wHidden:=<>Lst_wHidden || New list:C375
End if 

If (False:C215)
	_O_C_TEXT:C284(tool_renameWindows; $1)
	
	_O_C_TEXT:C284(Palette_ADD_ELEMENT; $1)
	_O_C_LONGINT:C283(Palette_ADD_ELEMENT; $2)
	
	_O_C_LONGINT:C283(Palette_ADD_WINDOW; $1)
	
	_O_C_TEXT:C284(Palette_MENU; $1)
	
	_O_C_TEXT:C284(Palette_RUN; $1)
	
End if 