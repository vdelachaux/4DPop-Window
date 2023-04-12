//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : Palette_MENU
// ID[4860AD2C46614218BBE84AFFBEA16310]
// Created 13/06/12 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
// Contextual and action menu of the palette
// ----------------------------------------------------
// Declarations
C_TEXT:C284($1)

C_BOOLEAN:C305($Boo_always; $Boo_expanded; $Boo_hide; $Boo_selected)
C_LONGINT:C283($bottom; $height; $i; $left; $Lon_opened; $Lon_parameters; $right; $top)
C_LONGINT:C283($Lon_wbottom; $Lon_wHandle; $Lon_width; $Lon_wleft; $Lon_wright; $Lon_wtop)
C_TEXT:C284($Mnu_main; $Txt_action; $Txt_buffer)

ARRAY LONGINT:C221($tLon_wHandles; 0)

If (False:C215)
	C_TEXT:C284(Palette_MENU; $1)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1; "Missing parameter"))
	
	GET WINDOW RECT:C443($Lon_wleft; $Lon_wtop; $Lon_wright; $Lon_wbottom; <>Win_palette)
	$Lon_width:=$Lon_wright-$Lon_wleft
	$height:=$Lon_wbottom-$Lon_wtop
	
	$Lon_wHandle:=Choose:C955($height=19; Frontmost window:C447; Selected list items:C379(<>Lst_windows; *))
	
	$Boo_selected:=($Lon_wHandle>0)
	
	Case of 
			
			//______________________________________________________
		: ($1="context")
			
			//______________________________________________________
		: ($1="action")
			
			$Boo_always:=True:C214
			
			//______________________________________________________
		Else 
			
			$Txt_action:=$1
			
			//______________________________________________________
	End case 
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
If (Length:C16($Txt_action)=0)
	
	$Mnu_main:=Create menu:C408
	
	If ($Boo_selected | $Boo_always)
		
		APPEND MENU ITEM:C411($Mnu_main; Get localized string:C991("Items_foreground"))
		SET MENU ITEM PARAMETER:C1004($Mnu_main; -1; "foreground")
		
		If (Not:C34($Boo_selected))
			
			DISABLE MENU ITEM:C150($Mnu_main; -1)
			
		End if 
	End if 
	
	If ($Boo_selected | $Boo_always)
		
		APPEND MENU ITEM:C411($Mnu_main; Get localized string:C991("Items_close"))
		SET MENU ITEM PARAMETER:C1004($Mnu_main; -1; "close")
		
		If (Not:C34($Boo_selected))
			
			DISABLE MENU ITEM:C150($Mnu_main; -1)
			
		End if 
	End if 
	
	If ($Boo_selected | $Boo_always)
		
		APPEND MENU ITEM:C411($Mnu_main; "-")
		
		APPEND MENU ITEM:C411($Mnu_main; Get localized string:C991("Items_minimize"))
		SET MENU ITEM PARAMETER:C1004($Mnu_main; -1; "dock")
		
		If (Not:C34($Boo_selected))
			
			DISABLE MENU ITEM:C150($Mnu_main; -1)
			
		End if 
	End if 
	
	//Si ($Boo_selected | $Boo_always)
	//
	//AJOUTER LIGNE MENU($Mnu_main;Lire traduction chaine("Items_maximize"))
	//FIXER PARAMETRE LIGNE MENU($Mnu_main;-1;"maximize")
	//
	//Si (Non($Boo_selected))
	//
	//INACTIVER LIGNE MENU($Mnu_main;-1)
	//
	//Fin de si
	//Fin de si
	
	If (Count menu items:C405($Mnu_main)>0)
		
		APPEND MENU ITEM:C411($Mnu_main; "-")
		
	End if 
	
	If ($Boo_selected)
		
		GET LIST ITEM PARAMETER:C985(<>Lst_windows; $Lon_wHandle; "hide"; $Boo_hide)
		
	End if 
	
	If ($Boo_selected | $Boo_always)
		
		APPEND MENU ITEM:C411($Mnu_main; Get localized string:C991("Items_hide"))
		SET MENU ITEM PARAMETER:C1004($Mnu_main; -1; "hide")
		
		If (Not:C34($Boo_selected) | $Boo_hide)
			
			DISABLE MENU ITEM:C150($Mnu_main; -1)
			
		End if 
	End if 
	
	If ($Boo_selected | $Boo_always)
		
		APPEND MENU ITEM:C411($Mnu_main; Get localized string:C991("Items_show"))
		SET MENU ITEM PARAMETER:C1004($Mnu_main; -1; "show")
		
		If (Not:C34($Boo_selected & $Boo_hide))
			
			DISABLE MENU ITEM:C150($Mnu_main; -1)
			
		End if 
	End if 
	
	If (Count menu items:C405($Mnu_main)>0)
		
		APPEND MENU ITEM:C411($Mnu_main; "-")
		
	End if 
	
	APPEND MENU ITEM:C411($Mnu_main; Get localized string:C991("MenulabelsshowAllWindows"))
	SET MENU ITEM PARAMETER:C1004($Mnu_main; -1; "show_all")
	
	If (Count list items:C380(<>Lst_wHidden)=0)
		
		DISABLE MENU ITEM:C150($Mnu_main; -1)
		
	End if 
	
	//AJOUTER LIGNE MENU($Mnu_main;Lire traduction chaine("StringsStacksWindows"))
	//FIXER PARAMETRE LIGNE MENU($Mnu_main;-1;"stack")
	//LISTE FENETRES($tLon_wHandles)
	//
	//Si (Taille tableau($tLon_wHandles)<2)
	//
	//INACTIVER LIGNE MENU($Mnu_main;-1)
	//
	//Fin de si
	
	If ($Boo_selected | $Boo_always)
		
		APPEND MENU ITEM:C411($Mnu_main; "-")
		
		APPEND MENU ITEM:C411($Mnu_main; Get localized string:C991("StringsPutFrontmostWindowInScreen"))
		SET MENU ITEM PARAMETER:C1004($Mnu_main; -1; "inscreen")
		GET WINDOW RECT:C443($left; $top; $right; $bottom; $Lon_wHandle)
		
		If ($right<=Screen width:C187) & ($bottom<=Screen height:C188)
			
			DISABLE MENU ITEM:C150($Mnu_main; -1)
			
		End if 
	End if 
	
	//APPEND MENU ITEM($Mnu_main;"dock")
	//SET MENU ITEM PARAMETER($Mnu_main;-1;"dock")
	
	$Txt_action:=Dynamic pop up menu:C1006($Mnu_main)
	RELEASE MENU:C978($Mnu_main)
	
End if 

Case of 
		
		//______________________________________________________
	: (Length:C16($Txt_action)=0)
		
		//______________________________________________________
	: ($Txt_action="dock")
		
		WINDOW_ACTION($Txt_action; $Lon_wHandle)
		
		//______________________________________________________
	: ($Txt_action="stack")
		
		component.stack()
		
		//______________________________________________________
	: ($Txt_action="show_all")
		
		For ($i; 1; Count list items:C380(<>Lst_windows; *); 1)
			
			GET LIST ITEM:C378(<>Lst_windows; $i; $Lon_wHandle; $Txt_buffer; $Lon_opened; $Boo_expanded)
			
			WINDOW_ACTION("show"; $Lon_wHandle)
			
			If (Is a list:C621($Lon_opened))
				
				If (Not:C34($Boo_expanded))
					
					SET LIST ITEM:C385(<>Lst_windows; $Lon_wHandle; $Txt_buffer; $Lon_wHandle; $Lon_opened; True:C214)
					
				End if 
			End if 
		End for 
		
		//______________________________________________________
	Else 
		
		WINDOW_ACTION($Txt_action; $Lon_wHandle)
		
		//______________________________________________________
End case 

// ----------------------------------------------------
// End