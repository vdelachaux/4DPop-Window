//%attributes = {"invisible":true,"shared":true}
// ----------------------------------------------------
// Method : Tool_Default
// Created 05/06/07 by Vincent de Lachaux
// ----------------------------------------------------
var $default : Text

COMPILER_MAIN

$default:=component.preferences.get("default")

Case of 
		
		//________________________
	: ($default="stack")
		
		component.stack()
		
		//________________________
	: ($default="inscreen")
		
		component.bringToFront(Frontmost window:C447)
		
		//________________________
	: ($default="next")
		
		component.bringToFront(Next window:C448(Frontmost window:C447))
		
		//________________________
End case 