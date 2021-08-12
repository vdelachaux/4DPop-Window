//%attributes = {"invisible":true,"shared":true}
// ----------------------------------------------------
// Method : Tool_Default
// Created 05/06/07 by Vincent de Lachaux
// ----------------------------------------------------
// Description
//
// ----------------------------------------------------
C_POINTER:C301($1)

C_TEXT:C284($Txt_Default_Action)

If (False:C215)
	C_POINTER:C301(Tool_Default; $1)
End if 

PREFERENCES("default.get"; ->$Txt_Default_Action)

Case of 
		
		//________________________
	: ($Txt_Default_Action="stack")
		
		TOOL_WINDOWS
		
		//________________________
	: ($Txt_Default_Action="inscreen")
		
		TOOL_WINDOWS(Frontmost window:C447)
		
		//________________________
	: ($Txt_Default_Action="next")
		
		TOOL_WINDOWS(Next window:C448(Frontmost window:C447))
		
		//________________________
End case 