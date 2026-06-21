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
	
	POST OUTSIDE CALL:C329(-1)
	
End if 