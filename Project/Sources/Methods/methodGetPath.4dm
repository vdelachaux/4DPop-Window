//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : methodGetPath
// ID[779435B5FCA34690B839127D7E3B016B]
// Created 12/06/12 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_TEXT:C284($0)
C_TEXT:C284($1)
C_LONGINT:C283($2)

C_LONGINT:C283($Lon_i; $Lon_parameters; $Lon_type)
C_TEXT:C284($Txt_name; $Txt_path)

If (False:C215)
	C_TEXT:C284(methodGetPath; $0)
	C_TEXT:C284(methodGetPath; $1)
	C_LONGINT:C283(methodGetPath; $2)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2; "Missing parameter"))
	
	$Lon_type:=$2
	$Txt_name:=$1
	
	//encode name
	$Txt_name:=Replace string:C233($Txt_name; "%"; "%25")
	$Txt_name:=Replace string:C233($Txt_name; "\""; "%22")
	$Txt_name:=Replace string:C233($Txt_name; "*"; "%2A")
	$Txt_name:=Replace string:C233($Txt_name; "/"; "%2F")
	$Txt_name:=Replace string:C233($Txt_name; ":"; "%3A")
	$Txt_name:=Replace string:C233($Txt_name; "<"; "%3C")
	$Txt_name:=Replace string:C233($Txt_name; ">"; "%3E")
	$Txt_name:=Replace string:C233($Txt_name; "?"; "%3F")
	$Txt_name:=Replace string:C233($Txt_name; "|"; "%7C")
	$Txt_name:=Replace string:C233($Txt_name; "\\"; "%5C")
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($Lon_type=-1)  //just encode
		
		$Txt_path:=$Txt_name
		
		//______________________________________________________
	: ($Lon_type=Path trigger:K72:4)
		
		$Txt_path:="[trigger]/"+$Txt_name
		
		//______________________________________________________
	: ($Lon_type=Path project form:K72:3)
		
		$Txt_path:="[projectForm]/"+$Txt_name+"/{formMethod}"
		
		//______________________________________________________
	: ($Lon_type=Path table form:K72:5)
		
		$Txt_name:=Replace string:C233($Txt_name; "["; "")
		$Txt_name:=Replace string:C233($Txt_name; "]"; "/")
		$Txt_path:="[tableForm]/"+$Txt_name+"/{formMethod}"
		
		//______________________________________________________
	: ($Lon_type=Path project method:K72:1)
		
		$Txt_path:=$Txt_name
		
		//______________________________________________________
	: ($Lon_type=Path database method:K72:2)
		
		ARRAY TEXT:C222($tTxt_tag; 0x0000)
		APPEND TO ARRAY:C911($tTxt_tag; "onStartup")
		APPEND TO ARRAY:C911($tTxt_tag; "onExit")
		APPEND TO ARRAY:C911($tTxt_tag; "onDrop")
		APPEND TO ARRAY:C911($tTxt_tag; "onBackupStartup")
		APPEND TO ARRAY:C911($tTxt_tag; "onBackupShutdown")
		APPEND TO ARRAY:C911($tTxt_tag; "onWebConnection")
		APPEND TO ARRAY:C911($tTxt_tag; "onWebAuthentication")
		APPEND TO ARRAY:C911($tTxt_tag; "onWebSessionSuspend")
		APPEND TO ARRAY:C911($tTxt_tag; "onServerStartup")
		APPEND TO ARRAY:C911($tTxt_tag; "onServerShutdown")
		APPEND TO ARRAY:C911($tTxt_tag; "onServerOpenConnexion")
		APPEND TO ARRAY:C911($tTxt_tag; "onServerCloseConnection")
		APPEND TO ARRAY:C911($tTxt_tag; "onSystemEvent")
		APPEND TO ARRAY:C911($tTxt_tag; "onSqlAuthentication")
		
		For ($Lon_i; 1; Size of array:C274($tTxt_tag); 1)
			
			If ($Txt_name=Get localized string:C991($tTxt_tag{$Lon_i}))
				
				$Txt_name:=$tTxt_tag{$Lon_i}
				$Lon_i:=MAXLONG:K35:2-1
				
			End if 
		End for 
		
		$Txt_path:="[databaseMethod]/"+$Txt_name
		
		//______________________________________________________
	: ($Lon_type=Path all objects:K72:16)
		
		$Txt_path:=Choose:C955(Position:C15("["; $Txt_name)=1; "[tableForm]/"; "[projectForm]/")
		
		$Txt_name:=Replace string:C233($Txt_name; "["; "")
		$Txt_name:=Replace string:C233($Txt_name; "]."; "/")
		$Txt_name:=Replace string:C233($Txt_name; "."; "/"; 1)
		
		$Txt_path:=$Txt_path+$Txt_name
		
		//______________________________________________________
	Else 
		
		TRACE:C157
		
		//______________________________________________________
End case 

$0:=$Txt_path

// ----------------------------------------------------
// End