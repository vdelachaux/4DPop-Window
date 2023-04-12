//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : 4DPopWindow_path
// Database: 4DPop Window
// ID[DCF5F028CAF64690B95DAEE313323BE1]
// Created 13/11/12 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)
C_POINTER:C301($2)

C_LONGINT:C283($Lon_methodeType; $Lon_parameters; $Lon_x)
C_TEXT:C284($Txt_form; $Txt_method; $Txt_methodPath; $Txt_object; $Txt_table; $Txt_windowTitle)

If (False:C215)
	C_TEXT:C284(_o_4DPopWindow_path; $0)
	C_TEXT:C284(_o_4DPopWindow_path; $1)
	C_POINTER:C301(_o_4DPopWindow_path; $2)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0; "Missing parameter"))
	
	If ($Lon_parameters>=1)
		
		$Txt_windowTitle:=$1
		
	Else 
		
		$Txt_windowTitle:=Get window title:C450(Frontmost window:C447)
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
$Lon_x:=Position:C15("-"; $Txt_windowTitle)

If ($Lon_x>0)
	
	$Txt_windowTitle:=Delete string:C232($Txt_windowTitle; 1; $Lon_x+1)
	
End if 

$Lon_x:=Position:C15(":"; $Txt_windowTitle)

Case of 
		
		//…………………………………………………………………………………
	: (Position:C15(Get localized string:C991("w_formMethod"); $Txt_windowTitle)=1)
		
		$Txt_windowTitle:=Delete string:C232($Txt_windowTitle; 1; $Lon_x+1)
		
		If (Position:C15("["; $Txt_windowTitle)=1)
			
			$Lon_methodeType:=Path table form:K72:5
			
			$Lon_x:=Position:C15("]"; $Txt_windowTitle)
			
			$Txt_table:=Substring:C12($Txt_windowTitle; 1; $Lon_x)
			$Txt_windowTitle:=Substring:C12($Txt_windowTitle; $Lon_x+1)
			
		Else 
			
			$Lon_methodeType:=Path project form:K72:3
			
		End if 
		
		$Txt_form:=$Txt_windowTitle
		
		//…………………………………………………………………………………
	: (Position:C15(Get localized string:C991("w_triggerMethod"); $Txt_windowTitle)=1)
		
		$Lon_methodeType:=Path trigger:K72:4
		
		$Txt_table:=Delete string:C232($Txt_windowTitle; 1; $Lon_x)
		
		//…………………………………………………………………………………
	: (Position:C15(Get localized string:C991("w_method"); $Txt_windowTitle)=1)
		
		$Lon_methodeType:=Path project method:K72:1
		
		$Txt_method:=Delete string:C232($Txt_windowTitle; 1; $Lon_x+1)
		
		//…………………………………………………………………………………
	: (Position:C15(Get localized string:C991("w_objectMethod"); $Txt_windowTitle)=1)
		
		$Txt_windowTitle:=Delete string:C232($Txt_windowTitle; 1; $Lon_x+1)
		
		If (Position:C15("["; $Txt_windowTitle)=1)
			
			$Lon_methodeType:=Path table form:K72:5
			
			$Lon_x:=Position:C15("]"; $Txt_windowTitle)
			
			$Txt_table:=Substring:C12($Txt_windowTitle; 1; $Lon_x)
			$Txt_windowTitle:=Substring:C12($Txt_windowTitle; $Lon_x+2)  //+2 because there is a point after the table name
			
		Else 
			
			$Lon_methodeType:=Path project form:K72:3
			
		End if 
		
		$Lon_x:=Position:C15("."; $Txt_windowTitle)
		
		$Txt_form:=Substring:C12($Txt_windowTitle; 1; $Lon_x-1)
		$Txt_object:=Substring:C12($Txt_windowTitle; $Lon_x+1)
		
		//…………………………………………………………………………………
	: ($Txt_windowTitle=Get localized string:C991("Database_onStartup"))
		
		$Lon_methodeType:=Path database method:K72:2
		$Txt_method:="onStartup"
		
		//…………………………………………………………………………………
	: ($Txt_windowTitle=Get localized string:C991("Database_onExit"))
		
		$Lon_methodeType:=Path database method:K72:2
		$Txt_method:="onExit"
		
		//…………………………………………………………………………………
	: ($Txt_windowTitle=Get localized string:C991("Database_onDrop"))
		
		$Lon_methodeType:=Path database method:K72:2
		$Txt_method:="onDrop"
		
		//…………………………………………………………………………………
	: ($Txt_windowTitle=Get localized string:C991("Database_onBackupStartup"))
		
		$Lon_methodeType:=Path database method:K72:2
		$Txt_method:="onBackupStartup"
		
		//…………………………………………………………………………………
	: ($Txt_windowTitle=Get localized string:C991("Database_onBackupShutdown"))
		
		$Lon_methodeType:=Path database method:K72:2
		$Txt_method:="onBackupShutdown"
		
		//…………………………………………………………………………………
	: ($Txt_windowTitle=Get localized string:C991("Database_onWebConnection"))
		
		$Lon_methodeType:=Path database method:K72:2
		$Txt_method:="onWebConnection"
		
		//…………………………………………………………………………………
	: ($Txt_windowTitle=Get localized string:C991("Database_onWebAuthentication"))
		
		$Lon_methodeType:=Path database method:K72:2
		$Txt_method:="onWebAuthentication"
		
		//…………………………………………………………………………………
	: ($Txt_windowTitle=Get localized string:C991("Database_onWebSessionSuspend"))
		
		$Lon_methodeType:=Path database method:K72:2
		$Txt_method:="onWebSessionSuspend"
		
		//…………………………………………………………………………………
	: ($Txt_windowTitle=Get localized string:C991("Database_onServerStartup"))
		
		$Lon_methodeType:=Path database method:K72:2
		$Txt_method:="onServerStartup"
		
		//…………………………………………………………………………………
	: ($Txt_windowTitle=Get localized string:C991("Database_onServerShutdown"))
		
		$Lon_methodeType:=Path database method:K72:2
		$Txt_method:="onServerShutdown"
		
		//…………………………………………………………………………………
	: ($Txt_windowTitle=Get localized string:C991("Database_onServerOpenConnection"))
		
		$Lon_methodeType:=Path database method:K72:2
		$Txt_method:="onServerOpenConnection"
		
		//…………………………………………………………………………………
	: ($Txt_windowTitle=Get localized string:C991("Database_onServerCloseConnection"))
		
		$Lon_methodeType:=Path database method:K72:2
		$Txt_method:="onServerCloseConnection"
		
		//…………………………………………………………………………………
	: ($Txt_windowTitle=Get localized string:C991("Database_onSystemEvent"))
		
		$Lon_methodeType:=Path database method:K72:2
		$Txt_method:="onSystemEvent"
		
		//…………………………………………………………………………………
	: ($Txt_windowTitle=Get localized string:C991("Database_onSqlAuthentication"))
		
		$Lon_methodeType:=Path database method:K72:2
		$Txt_method:="onSqlAuthentication"
		
		//________________________________________
End case 

Case of 
		
		//…………………………………………………………………………………
	: ($Lon_methodeType=Path project method:K72:1)\
		 | ($Lon_methodeType=Path database method:K72:2)
		
		$Txt_methodPath:=METHOD Get path:C1164($Lon_methodeType; $Txt_method; *)
		
		//…………………………………………………………………………………
	: ($Lon_methodeType=Path project form:K72:3)
		
		$Txt_methodPath:=Choose:C955(Length:C16($Txt_object)>0; METHOD Get path:C1164($Lon_methodeType; $Txt_form; $Txt_object; *); METHOD Get path:C1164($Lon_methodeType; $Txt_form; *))
		
		//…………………………………………………………………………………
	: ($Lon_methodeType=Path table form:K72:5)
		
		$Txt_methodPath:=Choose:C955(Length:C16($Txt_object)>0; METHOD Get path:C1164($Lon_methodeType; tablePointer($Txt_table)->; $Txt_form; $Txt_object; *); METHOD Get path:C1164($Lon_methodeType; tablePointer($Txt_table)->; $Txt_form; *))
		
		//…………………………………………………………………………………
	: ($Lon_methodeType=Path trigger:K72:4)
		
		$Txt_methodPath:=METHOD Get path:C1164($Lon_methodeType; tablePointer($Txt_table)->; *)
		
		//________________________________________
End case 

$0:=$Txt_methodPath

If ($Lon_parameters>=2)
	
	$2->:=$Lon_methodeType
	
End if 

// ----------------------------------------------------
// End