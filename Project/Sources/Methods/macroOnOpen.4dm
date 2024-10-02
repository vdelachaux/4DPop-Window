//%attributes = {"invisible":true,"shared":true}
// ----------------------------------------------------
// Method : 4DPopWindow_macroOnOpen
// Created 02/03/10 by Vincent de Lachaux
// ----------------------------------------------------
// Description
// Macro triggered on opening or creating a method.
// ----------------------------------------------------
#DECLARE($methodPath : Text)

var $options : Integer

COMPILER_MAIN
var component : cs:C1710._component
component:=component || cs:C1710._component.new()

$options:=component.preferences.get("options")

If ($options ?? 2)
	
	If (<>Win_palette=0)
		
		Palette_RUN
		
		Repeat 
			
			IDLE:C311
			DELAY PROCESS:C323(Current process:C322; 10)
			
		Until (<>Win_palette#0)
		
	Else 
		
		SHOW WINDOW:C435(<>Win_palette)
		
	End if 
	
	// ----------------------------------------------------
	//If (Count parameters>=1)
	//Palette_ADD_ELEMENT ($methodPath)
	//End if
	//If (Count list items(<>Lst_windows;*)>0)
	//SHOW WINDOW(<>Win_palette)
	
	POST OUTSIDE CALL:C329(-1)
	
	//Else
	//HIDE WINDOW(<>Win_palette)
	//End if
	
End if 