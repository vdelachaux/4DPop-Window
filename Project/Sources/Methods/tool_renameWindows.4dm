//%attributes = {"invisible":true}
// ----------------------------------------------------
// Method :  tool_renameWindows
// Created 18/06/10 by Vincent de Lachaux
// ----------------------------------------------------
// Description
//
// ----------------------------------------------------
// Declarations
C_TEXT:C284($1)

C_BOOLEAN:C305($Boo_)
C_LONGINT:C283($Lon_; $Lon_origin; $Lon_parameters; $Lon_process; $Lon_x; $Win_hdl)
C_TEXT:C284($Txt_; $Txt_databaseName; $Txt_entryPoint; $Txt_prefix; $Txt_title)

If (False:C215)
	C_TEXT:C284(tool_renameWindows; $1)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If ($Lon_parameters>=1)
	
	$Txt_entryPoint:=$1
	
End if 

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: (Length:C16($Txt_entryPoint)=0)
		
		$Lon_process:=New process:C317(Current method name:C684; 0; "$4DPopWindows_tool"; "_run"; *)
		
		//______________________________________________________
	: ($Txt_entryPoint="_run")
		
		COMPILER_MAIN
		
		// #31-10-2014 - old
		//$Txt_databaseName:=Structure file(*)
		//For ($Lon_i;Length($Txt_databaseName);1;-1)
		//If ($Txt_databaseName[[$Lon_i]]=Folder separator)
		//$Txt_databaseName:=Delete string($Txt_databaseName;1;$Lon_i)
		//$Lon_i:=0
		//End if
		//End for
		//For ($Lon_i;Length($Txt_databaseName);1;-1)
		//If ($Txt_databaseName[[$Lon_i]]=".")
		//$Txt_databaseName:=Substring($Txt_databaseName;1;$Lon_i-1)
		//$Lon_i:=0
		//End if
		//End for
		
		$Txt_databaseName:=Replace string:C233(Structure file:C489(*); Get 4D folder:C485(Database folder:K5:14; *); "")
		$Lon_x:=Position:C15("."; $Txt_databaseName)
		
		If ($Lon_x>0)
			
			$Txt_databaseName:=Substring:C12($Txt_databaseName; 1; $Lon_x-1)
			
		End if 
		
		$Txt_prefix:=$Txt_databaseName+" - "
		
		While (Not:C34(Process aborted:C672))
			
			If ((<>Lon_options ?? 3))
				
				$Win_hdl:=Frontmost window:C447
				
				//not for modal | floating | external
				If (Window kind:C445($Win_hdl)=Regular window:K27:1)
					
					PROCESS PROPERTIES:C336(Window process:C446($Win_hdl); $Txt_; $Lon_; $Lon_; $Boo_; $Lon_; $Lon_origin)
					
					Case of 
							
							//-----------------------------------
						: ($Lon_origin=Design process:K36:9)
							
							$Txt_title:=Get window title:C450($Win_hdl)
							
							If (Position:C15($Txt_prefix; $Txt_title)#1)
								
								SET WINDOW TITLE:C213($Txt_prefix+$Txt_title; $Win_hdl)
								
							End if 
							
							//-----------------------------------
						Else 
							
							//
							
							//-----------------------------------
					End case 
				End if 
			End if 
			
			If (True:C214)
				
				ARRAY LONGINT:C221($tWin_hdl; 0x0000)
				WINDOW LIST:C442($tWin_hdl)
				
			End if 
			
			DELAY PROCESS:C323(Current process:C322; 30)
			
		End while 
		
		//______________________________________________________
	Else 
		
		BEEP:C151
		
		//______________________________________________________
End case 