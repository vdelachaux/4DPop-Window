//%attributes = {"invisible":true}
#DECLARE()

var component : cs:C1710._component
component:=component || cs:C1710._component.new()

If (False:C215)
	
	var <>Win_palette : Integer
	var <>Lst_windows : Integer
	var <>Lst_wHidden : Integer
	
	var <>Txt_digest : Text
	
	<>Lst_wHidden:=<>Lst_wHidden || New list:C375
	
End if 