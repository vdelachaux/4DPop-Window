//%attributes = {"invisible":true,"shared":true}
// ----------------------------------------------------
// Method : Tool_Menu
// Created 31/05/07 by Vincent de Lachaux
// ----------------------------------------------------
// Description
// Display an ordered window menu
// ----------------------------------------------------
C_POINTER:C301($1)

C_BOOLEAN:C305($Boo_InMainMenu; $Boo_modifier; $Boo_visible)
C_LONGINT:C283($Lon_; $Lon_bottom; $Lon_i; $Lon_left; $Lon_right; $Lon_state)
C_LONGINT:C283($Lon_time; $Lon_top; $Lon_UID; $Lon_wFrontmost; $Lon_windowCount; $Lon_windowType)
C_LONGINT:C283($Lon_wReference; $Lon_x)
C_TEXT:C284($kTxt_form; $kTxt_search; $Mnu_application; $Mnu_databaseMethods; $Mnu_forms; $Mnu_main)
C_TEXT:C284($Mnu_methods; $Mnu_others; $Mnu_researches; $Mnu_target; $Mnu_trigger; $Mnu_windows)
C_TEXT:C284($Txt_form; $Txt_iconPath; $Txt_language; $Txt_method_path; $Txt_Name; $Txt_target)
C_TEXT:C284($Txt_type; $Txt_userChoice; $Txt_windowName)

ARRAY LONGINT:C221($tLon_windowReferences; 0)
ARRAY TEXT:C222($tTxt_forms; 0)

If (False:C215)
	C_POINTER:C301(Tool_Menu; $1)
End if 

ARRAY TEXT:C222($tTxt_Components; 0x0000)
COMPONENT LIST:C1001($tTxt_Components)
If (Find in array:C230($tTxt_Components; "4DPop")>0)
	
	EXECUTE METHOD:C1007("4DPop_applicationLanguage"; $Txt_language)
	SET DATABASE LOCALIZATION:C1104($Txt_language; *)
	
End if 

$kTxt_form:=Get localized string:C991("Form")
$kTxt_search:=Get localized string:C991("Researches")

WINDOW LIST:C442($tLon_windowReferences)

$Lon_windowCount:=Size of array:C274($tLon_windowReferences)

If ($Lon_windowCount>0)
	
	PREFERENCES("options.get"; -><>Lon_options)
	
	ARRAY LONGINT:C221($tLon_Process_IDs; $Lon_windowCount)
	ARRAY LONGINT:C221($tLon_Origins; $Lon_windowCount)
	ARRAY TEXT:C222($tTxt_Window_Names; $Lon_windowCount)
	
	For ($Lon_i; 1; $Lon_windowCount; 1)
		
		$tLon_Process_IDs{$Lon_i}:=Window process:C446($tLon_windowReferences{$Lon_i})
		PROCESS PROPERTIES:C336($tLon_Process_IDs{$Lon_i}; $Txt_Name; $Lon_state; $Lon_time; $Boo_visible; $Lon_UID; $tLon_Origins{$Lon_i})
		$tTxt_Window_Names{$Lon_i}:=Get window title:C450($tLon_windowReferences{$Lon_i})
		
	End for 
	
	MULTI SORT ARRAY:C718($tLon_Origins; >; $tTxt_Window_Names; >; $tLon_windowReferences)
	
	$Lon_wFrontmost:=Frontmost window:C447
	
	ARRAY TEXT:C222($tTxt_Database_Procs; 11)
	
	For ($Lon_i; 1; Size of array:C274($tTxt_Database_Procs); 1)
		
		$tTxt_Database_Procs{$Lon_i}:=Get localized string:C991("DatabaseProcs_"+String:C10($Lon_i))
		
	End for 
	
	//=====================
	//               Windows Menu
	//=====================
	For ($Lon_i; 1; $Lon_windowCount; 1)
		
		$Txt_windowName:=$tTxt_Window_Names{$Lon_i}
		
		$Lon_x:=Position:C15(" - "; $Txt_windowName)
		
		If ($Lon_x>0)
			
			$Txt_windowName:=Delete string:C232($Txt_windowName; 1; $Lon_x+2)
			
		End if 
		
		If ($tLon_Origins{$Lon_i}>0)
			
			$Txt_iconPath:="#Images/user.png"
			
			If (Length:C16($Mnu_application)=0)
				
				$Mnu_application:=Create menu:C408
				
			End if 
			
			$Txt_target:=$Mnu_application
			$Txt_type:="Application"
			
		Else 
			
			$Txt_method_path:=4DPopWindow_path($Txt_windowName; ->$Lon_windowType)
			
			Case of 
					
					//______________________________________________________
				: ($Lon_windowType=Path trigger:K72:4)  //[trigger]/Table_1
					
					$Txt_iconPath:="#Images/triggerMethod.png"
					
					If (Length:C16($Mnu_trigger)=0)
						
						$Mnu_trigger:=Create menu:C408
						
					End if 
					
					$Txt_windowName:=Replace string:C233($Txt_method_path; "[trigger]/"; "")
					$Txt_target:=$Mnu_trigger
					$Txt_type:="Trigger"
					
					//______________________________________________________
				: (Length:C16($Txt_method_path)=0)  //not a method
					
					Case of 
							
							//…………………………………………………………………………
						: (Position:C15($kTxt_search; $Txt_windowName)=1)
							
							If (Length:C16($Mnu_researches)=0)
								
								$Mnu_researches:=Create menu:C408
								
							End if 
							
							$Txt_windowName:=Replace string:C233($Txt_windowName; $kTxt_search; "")
							
							$Txt_iconPath:="#Images/search.png"
							$Txt_target:=$Mnu_researches
							$Txt_type:="search"
							
							//…………………………………………………………………………
						: (Position:C15($kTxt_form; $Txt_windowName)=1)
							
							$Txt_form:=Replace string:C233($Txt_windowName; $kTxt_form; "")
							$Lon_x:=Find in array:C230($tTxt_forms; $Txt_form)
							
							If ($Lon_x=-1)
								
								APPEND TO ARRAY:C911($tTxt_forms; $Txt_form)
								$Lon_x:=Size of array:C274($tTxt_forms)
								ARRAY TEXT:C222($tTxt_formMenus; $Lon_x)
								$tTxt_formMenus{$Lon_x}:=Create menu:C408
								
							End if 
							
							$Txt_target:=$tTxt_formMenus{$Lon_x}
							
							$Txt_iconPath:="#Images/form.png"
							$Txt_type:="Form"
							$Txt_windowName:=Get localized string:C991("MenuLabelsForm")
							
							//…………………………………………………………………………
						Else 
							
							$Txt_iconPath:="#Images/window.png"
							
							If (Length:C16($Mnu_others)=0)
								
								$Mnu_others:=Create menu:C408
								
							End if 
							
							$Txt_target:=$Mnu_others
							$Txt_type:="Other"
							
							//…………………………………………………………………………
					End case 
					
					//______________________________________________________
				: ($Lon_windowType=Path project method:K72:1)
					
					$Txt_iconPath:="#Images/method.png"
					
					If (Length:C16($Mnu_methods)=0)
						
						$Mnu_methods:=Create menu:C408
						
					End if 
					
					$Txt_target:=$Mnu_methods
					$Txt_windowName:=$Txt_method_path
					$Txt_type:="ProjectMethod"
					
					//______________________________________________________
				: ($Lon_windowType=Path project form:K72:3)\
					 | ($Lon_windowType=Path table form:K72:5)  //[projectForm]/PALETTE{/object}
					
					$Txt_method_path:=Replace string:C233($Txt_method_path; "[projectForm]/"; "")
					$Lon_x:=Position:C15("/{formMethod}"; $Txt_method_path)
					
					If ($Lon_x>0)  //form method
						
						$Txt_form:=Replace string:C233($Txt_method_path; "/{formMethod}"; "")
						$Txt_windowName:=Get localized string:C991("MenuLabelsFormMethod")
						$Txt_iconPath:="#Images/formMethod.png"
						$Txt_type:="FormMethod"
						
					Else   //object method
						
						$Lon_x:=Position:C15("/"; $Txt_method_path)
						$Txt_form:=Substring:C12($Txt_method_path; 1; $Lon_x-1)
						$Txt_windowName:=Substring:C12($Txt_method_path; $Lon_x+1)
						$Txt_iconPath:="#Images/method.png"
						$Txt_type:="ObjectMethod"
						
					End if 
					
					$Lon_x:=Find in array:C230($tTxt_forms; $Txt_form)
					
					If ($Lon_x=-1)
						
						APPEND TO ARRAY:C911($tTxt_forms; $Txt_form)
						$Lon_x:=Size of array:C274($tTxt_forms)
						ARRAY TEXT:C222($tTxt_formMenus; $Lon_x)
						$tTxt_formMenus{$Lon_x}:=Create menu:C408
						
					End if 
					
					$Txt_target:=$tTxt_formMenus{$Lon_x}
					
					//______________________________________________________
				: ($Lon_windowType=Path database method:K72:2)
					
					If (Length:C16($Mnu_databaseMethods)=0)
						
						$Mnu_databaseMethods:=Create menu:C408
						
					End if 
					
					$Txt_iconPath:="#Images/databaseMethod.png"
					$Txt_target:=$Mnu_databaseMethods
					$Txt_type:="DatabaseMethod"
					
					//______________________________________________________
				Else 
					
					TRACE:C157
					
					//______________________________________________________
			End case 
		End if 
		
		APPEND MENU ITEM:C411($Txt_target; $Txt_windowName)
		SET MENU ITEM PARAMETER:C1004($Txt_target; -1; String:C10($tLon_windowReferences{$Lon_i}))
		SET MENU ITEM ICON:C984($Txt_target; -1; $Txt_iconPath)
		SET MENU ITEM PROPERTY:C973($Txt_target; -1; "type"; $Txt_type)
		
		If ($tLon_windowReferences{$Lon_i}=$Lon_wFrontmost)
			
			SET MENU ITEM MARK:C208($Txt_target; -1; Char:C90(18))
			
		End if 
	End for 
	
	//=====================
	//               Main menu
	//=====================
	$Mnu_main:=Create menu:C408
	
	$Boo_InMainMenu:=Choose:C955(Shift down:C543; Not:C34(<>Lon_options ?? 1); <>Lon_options ?? 1)
	
	If ($Boo_InMainMenu)  //Windows in main menu
		
		$Mnu_target:=$Mnu_main
		
	Else 
		
		$Mnu_windows:=Create menu:C408
		$Mnu_target:=$Mnu_windows
		
	End if 
	
	//+++++++++++++++++++++
	//               Application submenu
	//+++++++++++++++++++++
	If (Count menu items:C405($Mnu_application)>0)
		
		APPEND MENU ITEM:C411($Mnu_target; Get localized string:C991("StringsApplication"); $Mnu_application)
		SET MENU ITEM ICON:C984($Mnu_target; -1; "#Images/user.png")
		APPEND MENU ITEM:C411($Mnu_target; "-")
		
	End if 
	
	//+++++++++++++++++++++
	//               Methods submenu
	//+++++++++++++++++++++
	If (Count menu items:C405($Mnu_methods)>0)
		
		APPEND MENU ITEM:C411($Mnu_target; Get localized string:C991("MenuLabelsProjectMethods"); $Mnu_methods)
		SET MENU ITEM ICON:C984($Mnu_target; -1; "#Images/method.png")
		APPEND MENU ITEM:C411($Mnu_target; "-")
		
	End if 
	
	//+++++++++++++++++++++
	//               Forms submenu
	//+++++++++++++++++++++
	If (Size of array:C274($tTxt_forms)>0)
		
		$Mnu_forms:=Create menu:C408
		
		For ($Lon_i; 1; Size of array:C274($tTxt_forms); 1)
			
			APPEND MENU ITEM:C411($Mnu_forms; $tTxt_forms{$Lon_i}; $tTxt_formMenus{$Lon_i})
			SET MENU ITEM PARAMETER:C1004($Mnu_forms; -1; "form")
			SET MENU ITEM ICON:C984($Mnu_forms; -1; "#Images/form.png")
			
		End for 
		
		APPEND MENU ITEM:C411($Mnu_target; Get localized string:C991("MenuLabelsForms"); $Mnu_forms)
		SET MENU ITEM ICON:C984($Mnu_target; -1; "#Images/form.png")
		
	End if 
	
	//+++++++++++++++++++++
	//     Database methods submenu
	//+++++++++++++++++++++
	If (Count menu items:C405($Mnu_databaseMethods)>0)
		
		If (Count menu items:C405($Mnu_target)>0)
			
			APPEND MENU ITEM:C411($Mnu_target; "-")
			
		End if 
		
		APPEND MENU ITEM:C411($Mnu_target; Get localized string:C991("MenuLabelsDatabaseMethods"); $Mnu_databaseMethods)
		SET MENU ITEM ICON:C984($Mnu_target; -1; "#Images/databaseMethod.png")
		
	End if 
	
	//+++++++++++++++++++++
	//               Triggers submenu
	//+++++++++++++++++++++
	If (Count menu items:C405($Mnu_trigger)>0)
		
		If (Count menu items:C405($Mnu_target)>0)
			
			APPEND MENU ITEM:C411($Mnu_target; "-")
			
		End if 
		
		APPEND MENU ITEM:C411($Mnu_target; Get localized string:C991("MenuLabelsTriggers"); $Mnu_trigger)
		SET MENU ITEM ICON:C984($Mnu_target; -1; "#Images/triggerMethod.png")
		
	End if 
	
	//+++++++++++++++++++++
	//               Researches submenu
	//+++++++++++++++++++++
	If (Count menu items:C405($Mnu_researches)>0)
		
		If (Count menu items:C405($Mnu_target)>0)
			
			APPEND MENU ITEM:C411($Mnu_target; "-")
			
		End if 
		
		APPEND MENU ITEM:C411($Mnu_target; Get localized string:C991("Menulabelsresearches"); $Mnu_researches)
		SET MENU ITEM ICON:C984($Mnu_target; -1; "#Images/researches.png")
		
	End if 
	
	//+++++++++++++++++++++
	//               Others submenu
	//+++++++++++++++++++++
	If (Count menu items:C405($Mnu_others)>0)
		
		If (Count menu items:C405($Mnu_target)>0)
			
			APPEND MENU ITEM:C411($Mnu_target; "-")
			
		End if 
		
		APPEND MENU ITEM:C411($Mnu_target; Get localized string:C991("MenuLabelsOthers"); $Mnu_others)
		SET MENU ITEM ICON:C984($Mnu_target; -1; "#Images/window.png")
		
	End if 
End if 

If ($Mnu_target=$Mnu_windows)  //Windows in submenu
	
	APPEND MENU ITEM:C411($Mnu_main; Get localized string:C991("StringsWindows"); $Mnu_windows)
	SET MENU ITEM ICON:C984($Mnu_main; -1; "#Images/window.png")
	
	If ($Lon_windowCount=0)
		
		DISABLE MENU ITEM:C150($Mnu_main; -1)
		
	End if 
End if 

APPEND MENU ITEM:C411($Mnu_main; "-")

//AJOUTER LIGNE MENU($Mnu_main;Lire traduction chaine("StringsStacksWindows"))
//FIXER PARAMETRE LIGNE MENU($Mnu_main;-1;"stack")
//FIXER ICONE LIGNE MENU($Mnu_main;-1;"#Images/order.png")
//Si ($Lon_Size<2)
//INACTIVER LIGNE MENU($Mnu_main;-1)
//Fin de si

APPEND MENU ITEM:C411($Mnu_main; Get localized string:C991("StringsPutFrontmostWindowInScreen"))
SET MENU ITEM PARAMETER:C1004($Mnu_main; -1; "inscreen")
SET MENU ITEM ICON:C984($Mnu_main; -1; "#Images/inscreen.png")

If ($Lon_windowCount=0)
	
	DISABLE MENU ITEM:C150($Mnu_main; -1)
	
Else 
	
	GET WINDOW RECT:C443($Lon_left; $Lon_top; $Lon_right; $Lon_bottom; $Lon_wFrontmost)
	
	If ($Lon_right<=(Screen width:C187))\
		 & ($Lon_bottom<=(Screen height:C188))
		
		DISABLE MENU ITEM:C150($Mnu_main; -1)
		
	End if 
End if 

APPEND MENU ITEM:C411($Mnu_main; "-")

APPEND MENU ITEM:C411($Mnu_main; Get localized string:C991("StringsNextWindow"))
SET MENU ITEM PARAMETER:C1004($Mnu_main; -1; "next")
SET MENU ITEM ICON:C984($Mnu_main; -1; "#Images/next.png")

If ($Lon_windowCount<2)
	
	DISABLE MENU ITEM:C150($Mnu_main; -1)
	
End if 

APPEND MENU ITEM:C411($Mnu_main; "-")

APPEND MENU ITEM:C411($Mnu_main; Get localized string:C991("MenuLabelsOptions")+"…")
SET MENU ITEM PARAMETER:C1004($Mnu_main; -1; "prf")

//=====================
If (Count parameters:C259>=1)  //Executed from 4DPop component
	
	OBJECT GET COORDINATES:C663($1->; $Lon_left; $Lon_; $Lon_; $Lon_bottom)
	$Txt_userChoice:=Dynamic pop up menu:C1006($Mnu_main; ""; $Lon_left; $Lon_bottom)
	
Else 
	
	$Txt_userChoice:=Dynamic pop up menu:C1006($Mnu_main)
	
End if 

$Boo_modifier:=(Macintosh option down:C545 | Windows Alt down:C563)

//=====================

mnu_RELEASE_MENU($Mnu_main)

Case of 
		
		//________________________
	: ($Txt_userChoice="prf")
		
		$Lon_wReference:=Open form window:C675("Preferences"; Movable form dialog box:K39:8)
		DIALOG:C40("Preferences")
		CLOSE WINDOW:C154
		
		tool_renameWindows
		Palette_RUN
		
		//________________________
	: ($Txt_userChoice="stack")
		
		TOOL_WINDOWS
		
		//________________________
	: ($Txt_userChoice="inscreen")
		
		WINDOW_ACTION("inscreen"; $Lon_wFrontmost)
		
		//________________________
	: ($Txt_userChoice="next")
		
		WINDOW_ACTION("next"; $Lon_wFrontmost)
		
		//________________________
	Else 
		
		$Lon_wReference:=Num:C11($Txt_userChoice)
		
		If ($Lon_wReference#0)
			
			WINDOW_ACTION("foreground"; $Lon_wReference)
			
			If ($Boo_modifier)  // close window
				
				WINDOW_ACTION("close"; $Lon_wReference)
				
			End if 
		End if 
		
		//________________________
End case 