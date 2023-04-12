// ----------------------------------------------------
// Form method : COMMENTS
// Created 11/06/12 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
C_LONGINT:C283($eventCode; $Lon_wHandle)
C_TEXT:C284($Txt_buffer; $Txt_path)

// ----------------------------------------------------
// Initialisations
$eventCode:=Form event code:C388

$Lon_wHandle:=Num:C11(Get window title:C450)
If (List item position:C629(<>Lst_windows; $Lon_wHandle)>0)
	
	GET LIST ITEM PARAMETER:C985(<>Lst_windows; $Lon_wHandle; "path"; $Txt_path)
	
End if 
// ----------------------------------------------------

Case of 
		//______________________________________________________
	: ($eventCode=On Load:K2:1)
		
		METHOD GET COMMENTS:C1189($Txt_path; (OBJECT Get pointer:C1124(Object named:K67:5; "comments"))->; *)
		
		SET TIMER:C645(-1)
		
		//______________________________________________________
	: ($eventCode=On Unload:K2:2)
		
		If (OBJECT Get pointer:C1124(Object with focus:K67:3)=OBJECT Get pointer:C1124(Object named:K67:5; "comments"))
			
			$Txt_buffer:=Get edited text:C655
			
		Else 
			
			$Txt_buffer:=(OBJECT Get pointer:C1124(Object named:K67:5; "comments"))->
			
		End if 
		
		METHOD SET COMMENTS:C1193($Txt_path; $Txt_buffer; *)
		
		//______________________________________________________
	: ($eventCode=On Timer:K2:25)
		SET TIMER:C645(0)
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily")
		
		//______________________________________________________
End case 