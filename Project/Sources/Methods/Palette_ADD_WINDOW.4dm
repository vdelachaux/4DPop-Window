//%attributes = {"invisible":true}
// ----------------------------------------------------
// Method : Palette_ADD_WINDOW
// Created 12/06/12 by Vincent de Lachaux
// ----------------------------------------------------
// Description
// Add the opened windows to the windows' palette
// ----------------------------------------------------
// Declarations
#DECLARE($winHandle : Integer)

var $i; $Lon_wHandle; $Lon_x : Integer
var $kTxt_databaseMethodLabel; $kTxt_formMethod; $kTxt_formMethodLabel; $kTxt_method; $kTxt_methodLabel; $kTxt_objectMethod; $kTxt_objectMethodLabel; $kTxt_trigger : Text
var $kTxt_triggerLabel; $Txt_path; $Txt_title : Text

// ----------------------------------------------------
// Initialisations
$Lon_wHandle:=$winHandle

$kTxt_method:=Localized string:C991("Method")
$kTxt_formMethod:=Localized string:C991("FormMethod")
$kTxt_objectMethod:=Localized string:C991("ObjectMethod")
$kTxt_trigger:=Localized string:C991("Trigger")

$kTxt_methodLabel:=Localized string:C991("MenuLabelsProjectMethods")
$kTxt_formMethodLabel:=Localized string:C991("MenuLabelsFormMethod")
$kTxt_objectMethodLabel:=Localized string:C991("MenuLabelsObjectMethod")
$kTxt_triggerLabel:=Localized string:C991("MenuLabelsTriggers")
$kTxt_databaseMethodLabel:=Localized string:C991("MenuLabelsDatabaseMethods")

ARRAY TEXT:C222($tTxt_databaseMethods; 11)

For ($i; 1; Size of array:C274($tTxt_databaseMethods); 1)
	
	$tTxt_databaseMethods{$i}:=Localized string:C991("DatabaseProcs_"+String:C10($i))
	
End for 

// ----------------------------------------------------
If (List item position:C629(<>Lst_windows; $Lon_wHandle)=0)
	
	$Txt_title:=Get window title:C450($Lon_wHandle)
	
	$Lon_x:=Position:C15(" - "; $Txt_title)
	
	If ($Lon_x>0)
		
		$Txt_title:=Delete string:C232($Txt_title; 1; $Lon_x+2)
		
	End if 
	
	Case of 
			
			//______________________________________________________
		: (Position:C15($kTxt_method; $Txt_title)=1)
			
			$Txt_title:=Replace string:C233($Txt_title; $kTxt_method; ""; 1)
			$Txt_path:=component.methodPath($Txt_title; Path project method:K72:1)
			Palette_ADD_ELEMENT($Txt_path; $Lon_wHandle)
			
			//______________________________________________________
		: (Position:C15($kTxt_trigger; $Txt_title)=1)
			
			$Txt_title:=Replace string:C233($Txt_title; $kTxt_trigger; ""; 1)
			$Txt_path:=component.methodPath($Txt_title; Path trigger:K72:4)
			Palette_ADD_ELEMENT($Txt_path; $Lon_wHandle)
			
			//______________________________________________________
		: (Position:C15($kTxt_formMethod; $Txt_title)=1)
			
			$Txt_title:=Replace string:C233($Txt_title; $kTxt_formMethod; ""; 1)
			$Txt_path:=component.methodPath($Txt_title; Choose:C955(Position:C15("["; $Txt_title)>0; Path table form:K72:5; Path project form:K72:3))
			Palette_ADD_ELEMENT($Txt_path; $Lon_wHandle)
			
			//______________________________________________________
		: (Position:C15($kTxt_objectMethod; $Txt_title)=1)
			
			$Txt_title:=Replace string:C233($Txt_title; $kTxt_objectMethod; ""; 1)
			$Txt_path:=component.methodPath($Txt_title; Path all objects:K72:16)
			Palette_ADD_ELEMENT($Txt_path; $Lon_wHandle)
			
			//_____________________________________________________
		: (Find in array:C230($tTxt_databaseMethods; $Txt_title)>0)
			
			$Txt_path:=component.methodPath($Txt_title; Path database method:K72:2)
			Palette_ADD_ELEMENT($Txt_path; $Lon_wHandle)
			
			//______________________________________________________
	End case 
End if 