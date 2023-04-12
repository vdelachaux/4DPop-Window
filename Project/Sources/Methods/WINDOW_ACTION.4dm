//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : WINDOW_ACTION
// ID[ABC215F9B60B45F5B4F85D8308141955]
// Created 15/06/12 by Vincent de Lachaux
// ----------------------------------------------------
#DECLARE($todo : Text; $windowRef : Integer)

If (False:C215)
	C_TEXT:C284(WINDOW_ACTION; $1)
	C_LONGINT:C283(WINDOW_ACTION; $2)
End if 

var $bottom; $hOffset; $left; $right; $screenHeight; $screenWidth : Integer
var $top; $vOffset : Integer

$windowRef:=Count parameters:C259>=2 ? $windowRef : Frontmost window:C447

// ----------------------------------------------------

Case of 
		
		//______________________________________________________
	: ($todo="close")
		
		GET WINDOW RECT:C443($left; $top; $right; $bottom; $windowRef)
		SET WINDOW RECT:C444($left; $top; $right; $bottom; $windowRef)
		
		POST KEY:C465(Character code:C91("w"); 0 ?+ Command key bit:K16:2; component.designProcess)
		
		//______________________________________________________
	: ($todo="hide")
		
		If ($windowRef>0)
			
			HIDE WINDOW:C436($windowRef)
			SET LIST ITEM PARAMETER:C986(<>Lst_windows; $windowRef; "hide"; True:C214)
			
			APPEND TO LIST:C376(<>Lst_wHidden; ""; $windowRef)
			
		End if 
		
		//______________________________________________________
	: ($todo="show")\
		 | ($todo="undock")
		
		SHOW WINDOW:C435($windowRef)
		SET LIST ITEM PARAMETER:C986(<>Lst_windows; $windowRef; "hide"; False:C215)
		SET LIST ITEM PARAMETER:C986(<>Lst_windows; $windowRef; "docked"; False:C215)
		
		DELETE FROM LIST:C624(<>Lst_wHidden; $windowRef)
		
		If ($windowRef>0)
			
			If (Macintosh option down:C545)\
				 | ($todo="undock")  // Bring to Front
				
				GET WINDOW RECT:C443($left; $top; $right; $bottom; $windowRef)
				SET WINDOW RECT:C444($left; $top; $right; $bottom; $windowRef)
				
			End if 
		End if 
		
		//______________________________________________________
	: ($todo="dock")
		
		If (Is Windows:C1573)
			
			MINIMIZE WINDOW:C454($windowRef)
			SET LIST ITEM PARAMETER:C986(<>Lst_windows; $windowRef; "minimized"; True:C214)
			
		Else 
			
			If ($windowRef#Frontmost window:C447)
				
				GET WINDOW RECT:C443($left; $top; $right; $bottom; $windowRef)
				SET WINDOW RECT:C444($left; $top; $right; $bottom; $windowRef)
				
			End if 
			
			POST KEY:C465(Character code:C91("m"); 0 ?+ Command key bit:K16:2; component.designProcess)
			
			DELAY PROCESS:C323(Current process:C322; 1)
			
			SET LIST ITEM PARAMETER:C986(<>Lst_windows; $windowRef; "docked"; True:C214)
			
		End if 
		
		//______________________________________________________
	: ($todo="minimize")
		
		MINIMIZE WINDOW:C454($windowRef)
		SET LIST ITEM PARAMETER:C986(<>Lst_windows; $windowRef; "minimized"; True:C214)
		
		//______________________________________________________
	: ($todo="maximize")
		
		MAXIMIZE WINDOW:C453($windowRef)
		SET LIST ITEM PARAMETER:C986(<>Lst_windows; $windowRef; "minimized"; False:C215)
		
		//______________________________________________________
	: ($todo="foreground")
		
		GET WINDOW RECT:C443($left; $top; $right; $bottom; $windowRef)
		SET WINDOW RECT:C444($left; $top; $right; $bottom; $windowRef)
		
		//______________________________________________________
	: ($todo="next")
		
		$windowRef:=Next window:C448($windowRef)
		GET WINDOW RECT:C443($left; $top; $right; $bottom; $windowRef)
		SET WINDOW RECT:C444($left; $top; $right; $bottom; $windowRef)
		
		//______________________________________________________
	: ($todo="inscreen")
		
		$screenWidth:=Screen width:C187-10
		$screenHeight:=Screen height:C188-10
		$vOffset:=26+Menu bar height:C440+Tool bar height:C1016
		
		GET WINDOW RECT:C443($left; $top; $right; $bottom; $windowRef)
		
		// Move and resize if out of screen
		If ($right>$screenWidth)\
			 | ($bottom>$screenHeight)
			
			$hOffset:=10
			$right:=$hOffset+($right-$left)
			$right:=Choose:C955($right>$screenWidth; $screenWidth; $right)
			
			$bottom:=$vOffset+($bottom-$top)
			$bottom:=Choose:C955($bottom>$screenHeight; $screenHeight; $bottom)
			
			$left:=$hOffset
			$top:=$vOffset
			
		End if 
		
		SHOW WINDOW:C435($windowRef)
		SET WINDOW RECT:C444($left; $top; $right; $bottom; $windowRef)
		
		//______________________________________________________
	Else 
		
		TRACE:C157
		
		//______________________________________________________
End case 