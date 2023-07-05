//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : _o_methodGetPath
// ID[779435B5FCA34690B839127D7E3B016B]
// Created 12/06/12 by Vincent de Lachaux
// ----------------------------------------------------
#DECLARE($name : Text; $type : Integer) : Text

If (False:C215)
	C_TEXT:C284(_o_methodGetPath; $1)
	C_LONGINT:C283(_o_methodGetPath; $2)
	C_TEXT:C284(_o_methodGetPath; $0)
End if 

var $path : Text
var $indx : Integer
var $c : Collection

// Encode name
$name:=Replace string:C233($name; "%"; "%25")
$name:=Replace string:C233($name; "\""; "%22")
$name:=Replace string:C233($name; "*"; "%2A")
$name:=Replace string:C233($name; "/"; "%2F")
$name:=Replace string:C233($name; ":"; "%3A")
$name:=Replace string:C233($name; "<"; "%3C")
$name:=Replace string:C233($name; ">"; "%3E")
$name:=Replace string:C233($name; "?"; "%3F")
$name:=Replace string:C233($name; "|"; "%7C")
$name:=Replace string:C233($name; "\\"; "%5C")

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($type=-1)  // Only encoded
		
		return $name
		
		//______________________________________________________
	: ($type=Path class:K72:19)
		
		return "[class]/"+$name
		
		//______________________________________________________
	: ($type=Path trigger:K72:4)
		
		return "[trigger]/"+$name
		
		//______________________________________________________
	: ($type=Path project form:K72:3)
		
		return "[projectForm]/"+$name+"/{formMethod}"
		
		//______________________________________________________
	: ($type=Path table form:K72:5)
		
		$name:=Replace string:C233($name; "["; "")
		$name:=Replace string:C233($name; "]"; "/")
		return "[tableForm]/"+$name+"/{formMethod}"
		
		//______________________________________________________
	: ($type=Path project method:K72:1)
		
		return $name
		
		//______________________________________________________
	: ($type=Path database method:K72:2)
		
		$c:=New collection:C1472
		$c.push(Get localized string:C991("onBackupShutdown"))
		$c.push(Get localized string:C991("onBackupStartup"))
		$c.push(Get localized string:C991("onDrop"))
		$c.push(Get localized string:C991("onExit"))
		$c.push(Get localized string:C991("onHostDatabaseEvent"))
		$c.push(Get localized string:C991("onMobileAppAction"))
		$c.push(Get localized string:C991("onMobileAppAuthentication"))
		$c.push(Get localized string:C991("onRESTAuthentication"))
		$c.push(Get localized string:C991("onServerCloseConnection"))
		$c.push(Get localized string:C991("onServerOpenConnexion"))
		$c.push(Get localized string:C991("onServerShutdown"))
		$c.push(Get localized string:C991("onServerStartup"))
		$c.push(Get localized string:C991("onSqlAuthentication"))
		$c.push(Get localized string:C991("onStartup"))
		$c.push(Get localized string:C991("onSystemEvent"))
		$c.push(Get localized string:C991("onWebAuthentication"))
		$c.push(Get localized string:C991("onWebConnection"))
		$c.push(Get localized string:C991("onWebSessionClose"))
		
		$indx:=$c.indexOf($name)
		
		If ($indx#-1)
			
			return "[databaseMethod]/"+$c[$indx]
			
		End if 
		
		//______________________________________________________
	: ($type=Path all objects:K72:16)
		
		$path:=Position:C15("["; $name)=1 ? "[tableForm]/" : "[projectForm]/"
		$name:=Replace string:C233($name; "["; "")
		$name:=Replace string:C233($name; "]."; "/")
		$name:=Replace string:C233($name; "."; "/"; 1)
		
		return $path+$name
		
		//______________________________________________________
	Else 
		
		TRACE:C157
		
		//______________________________________________________
End case 