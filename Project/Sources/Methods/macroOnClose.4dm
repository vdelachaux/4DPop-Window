//%attributes = {"invisible":true,"shared":true}
// ----------------------------------------------------
// Method : 4DPopWindow_macroOnClose
// Created 02/03/10 by Vincent de Lachaux
// ----------------------------------------------------
#DECLARE($methodPath : Text)

var $buffer; $t : Text
var $b : Boolean
var $i; $options; $parent; $reference; $sub : Integer

If (Process aborted:C672)
	
	ABORT:C156
	
End if 

COMPILER_MAIN
var component : cs:C1710._component
component:=component || cs:C1710._component.new()

$options:=component.preferences.get("options")

If ($options ?? 2)\
 && (<>Win_palette#0)
	
	// #31-10-2014 - window is now closed before the macro call !
	//$Lon_ref:=Frontmost window
	//If (List item position(<>Lst_methods;$Lon_ref)>0)
	//$Lon_parent:=List item parent(<>Lst_methods;$Lon_ref)
	//$Lon_position:=List item position(<>Lst_methods;$Lon_parent)
	//GET LIST ITEM(<>Lst_methods;$Lon_position;$Lon_reference;$Txt_label;$Lon_sublist;$Boo_expanded)
	//If (Count list items($Lon_sublist)=1)
	//If ($Lon_reference<0)
	//CLEAR LIST($Lon_sublist)
	//DELETE FROM LIST(<>Lst_methods;$Lon_reference)
	// Else
	//DELETE FROM LIST(<>Lst_methods;$Lon_ref)
	// End if
	// Else
	//DELETE FROM LIST(<>Lst_methods;$Lon_ref)
	// End if
	// End if
	
	If (Count parameters:C259>=1)
		
		For ($i; 1; Count list items:C380(<>Lst_windows); 1)
			
			GET LIST ITEM:C378(<>Lst_windows; $i; $reference; $t)
			GET LIST ITEM PARAMETER:C985(<>Lst_windows; $reference; "path"; $buffer)
			
			If ($buffer=$methodPath)
				
				// Get the parent's informations
				GET LIST ITEM:C378(<>Lst_windows; \
					List item position:C629(<>Lst_windows; List item parent:C633(<>Lst_windows; $reference)); $parent; $t; $sub; $b)
				
				If (Count list items:C380($sub)=1)
					
					// Last item for the parent
					If ($parent<0)
						
						CLEAR LIST:C377($sub)
						DELETE FROM LIST:C624(<>Lst_windows; $parent)
						
					Else 
						
						DELETE FROM LIST:C624(<>Lst_windows; $reference)
						
					End if 
					
				Else 
					
					DELETE FROM LIST:C624(<>Lst_windows; $reference)
					
				End if 
				
				break
				
			End if 
		End for 
	End if 
	
	If (Count list items:C380(<>Lst_windows)>0)
		
		POST OUTSIDE CALL:C329(-1)
		
	Else 
		
		HIDE WINDOW:C436(<>Win_palette)
		
	End if 
End if 