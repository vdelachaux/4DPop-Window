//%attributes = {"invisible":true}
// ----------------------------------------------------
// Method : mnu_RELEASE_MENU
// Created 21/07/06 by vdl
// ----------------------------------------------------
// Description
// Clears from memory  the menu $1 and all menu called from this one
//----------------------------------------------------
C_TEXT:C284($1)

C_LONGINT:C283($Lon_i)

ARRAY TEXT:C222($tMnu_references; 0)
ARRAY TEXT:C222($Txt_labels; 0)

If (False:C215)
	C_TEXT:C284(mnu_RELEASE_MENU; $1)
End if 

If (Length:C16($1)>0)
	
	GET MENU ITEMS:C977($1; $Txt_labels; $tMnu_references)
	
	For ($Lon_i; 1; Size of array:C274($tMnu_references); 1)
		
		If (Length:C16($tMnu_references{$Lon_i})>0)
			
			mnu_RELEASE_MENU($tMnu_references{$Lon_i})  //<-- Recursive
			
		End if 
	End for 
	
	RELEASE MENU:C978($1)
	
End if 