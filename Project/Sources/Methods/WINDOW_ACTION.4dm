//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : WINDOW_ACTION
// ID[ABC215F9B60B45F5B4F85D8308141955]
// Created 15/06/12 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_TEXT:C284($1)
C_LONGINT:C283($2)

C_LONGINT:C283($kLon_hOffset; $Lon_bottom; $Lon_hOffset; $Lon_left; $Lon_parameters; $Lon_platform; $Lon_right; $Lon_screenHight)
C_LONGINT:C283($Lon_screenWidth; $Lon_top; $Lon_vOffset; $Lon_wHandle)
C_TEXT:C284($Txt_action)

If (False:C215)
	C_TEXT:C284(WINDOW_ACTION; $1)
	C_LONGINT:C283(WINDOW_ACTION; $2)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1; "Missing parameter"))
	
	$Txt_action:=$1
	
	If ($Lon_parameters>=2)
		
		$Lon_wHandle:=$2
		
	Else 
		
		$Lon_wHandle:=Frontmost window:C447
		
	End if 
	
	_O_PLATFORM PROPERTIES:C365($Lon_platform)
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------

Case of 
		
		//______________________________________________________
	: ($Txt_action="close")
		
		GET WINDOW RECT:C443($Lon_left; $Lon_top; $Lon_right; $Lon_bottom; $Lon_wHandle)
		SET WINDOW RECT:C444($Lon_left; $Lon_top; $Lon_right; $Lon_bottom; $Lon_wHandle)
		
		env_POST_KEY("w")
		
		//______________________________________________________
	: ($Txt_action="hide")
		
		If ($Lon_wHandle>0)
			
			HIDE WINDOW:C436($Lon_wHandle)
			SET LIST ITEM PARAMETER:C986(<>Lst_windows; $Lon_wHandle; "hide"; True:C214)
			
			APPEND TO LIST:C376(<>Lst_wHidden; ""; $Lon_wHandle)
			
		End if 
		
		//______________________________________________________
	: ($Txt_action="show") | ($Txt_action="undock")
		
		SHOW WINDOW:C435($Lon_wHandle)
		SET LIST ITEM PARAMETER:C986(<>Lst_windows; $Lon_wHandle; "hide"; False:C215)
		SET LIST ITEM PARAMETER:C986(<>Lst_windows; $Lon_wHandle; "docked"; False:C215)
		
		DELETE FROM LIST:C624(<>Lst_wHidden; $Lon_wHandle)
		
		If ($Lon_wHandle>0)
			
			If (Macintosh option down:C545) | ($Txt_action="undock")  // Bring to Front
				
				GET WINDOW RECT:C443($Lon_left; $Lon_top; $Lon_right; $Lon_bottom; $Lon_wHandle)
				SET WINDOW RECT:C444($Lon_left; $Lon_top; $Lon_right; $Lon_bottom; $Lon_wHandle)
				
			End if 
		End if 
		
		//______________________________________________________
	: ($Txt_action="dock")
		
		If ($Lon_platform=Windows:K25:3)
			
			MINIMIZE WINDOW:C454($Lon_wHandle)
			SET LIST ITEM PARAMETER:C986(<>Lst_windows; $Lon_wHandle; "minimized"; True:C214)
			
		Else 
			
			If ($Lon_wHandle#Frontmost window:C447)
				
				GET WINDOW RECT:C443($Lon_left; $Lon_top; $Lon_right; $Lon_bottom; $Lon_wHandle)
				SET WINDOW RECT:C444($Lon_left; $Lon_top; $Lon_right; $Lon_bottom; $Lon_wHandle)
				
			End if 
			
			env_POST_KEY("m")
			
			DELAY PROCESS:C323(Current process:C322; 1)
			
			SET LIST ITEM PARAMETER:C986(<>Lst_windows; $Lon_wHandle; "docked"; True:C214)
			
		End if 
		
		//______________________________________________________
	: ($Txt_action="minimize")
		
		MINIMIZE WINDOW:C454($Lon_wHandle)
		SET LIST ITEM PARAMETER:C986(<>Lst_windows; $Lon_wHandle; "minimized"; True:C214)
		
		//______________________________________________________
	: ($Txt_action="maximize")
		
		MAXIMIZE WINDOW:C453($Lon_wHandle)
		SET LIST ITEM PARAMETER:C986(<>Lst_windows; $Lon_wHandle; "minimized"; False:C215)
		
		//______________________________________________________
	: ($Txt_action="foreground")
		
		GET WINDOW RECT:C443($Lon_left; $Lon_top; $Lon_right; $Lon_bottom; $Lon_wHandle)
		SET WINDOW RECT:C444($Lon_left; $Lon_top; $Lon_right; $Lon_bottom; $Lon_wHandle)
		
		//______________________________________________________
	: ($Txt_action="next")
		
		$Lon_wHandle:=Next window:C448($Lon_wHandle)
		GET WINDOW RECT:C443($Lon_left; $Lon_top; $Lon_right; $Lon_bottom; $Lon_wHandle)
		SET WINDOW RECT:C444($Lon_left; $Lon_top; $Lon_right; $Lon_bottom; $Lon_wHandle)
		
		//______________________________________________________
	: ($Txt_action="inscreen")
		
		$Lon_screenWidth:=Screen width:C187-10
		$Lon_screenHight:=Screen height:C188-10
		$kLon_hOffset:=10
		$Lon_vOffset:=26+Menu bar height:C440+Tool bar height:C1016
		
		GET WINDOW RECT:C443($Lon_left; $Lon_top; $Lon_right; $Lon_bottom; $Lon_wHandle)
		
		//Move and resize if out of screen
		If ($Lon_right>$Lon_screenWidth) | ($Lon_bottom>$Lon_screenHight)
			
			$Lon_hOffset:=$kLon_hOffset
			$Lon_right:=$Lon_hOffset+($Lon_right-$Lon_left)
			$Lon_right:=Choose:C955($Lon_right>$Lon_screenWidth; $Lon_screenWidth; $Lon_right)
			
			$Lon_bottom:=$Lon_vOffset+($Lon_bottom-$Lon_top)
			$Lon_bottom:=Choose:C955($Lon_bottom>$Lon_screenHight; $Lon_screenHight; $Lon_bottom)
			
			$Lon_left:=$Lon_hOffset
			$Lon_top:=$Lon_vOffset
			
		End if 
		
		SHOW WINDOW:C435($Lon_wHandle)
		SET WINDOW RECT:C444($Lon_left; $Lon_top; $Lon_right; $Lon_bottom; $Lon_wHandle)
		
		//______________________________________________________
	Else 
		
		TRACE:C157
		
		//______________________________________________________
End case 

// ----------------------------------------------------
// End