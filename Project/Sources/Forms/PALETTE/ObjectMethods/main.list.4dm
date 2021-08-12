// ----------------------------------------------------
// Object method : methodPalette.Liste hiérarchique - (4DPop Window.4DB)
// Created 11/06/12 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
C_BOOLEAN:C305($Boo_expanded)
C_LONGINT:C283($Lon_; $Lon_bottom; $Lon_buffer; $Lon_button; $Lon_firstLine; $Lon_formEvent; $Lon_i; $Lon_left)
C_LONGINT:C283($Lon_line; $Lon_lineHeight; $Lon_mouseX; $Lon_mouseY; $Lon_right; $Lon_top; $Lon_wHandle; $Lst_opened)
C_PICTURE:C286($Pic_picto)
C_TEXT:C284($Txt_additional; $Txt_buffer; $Txt_command; $Txt_comment; $Txt_path; $Txt_title)

// ----------------------------------------------------
// Initialisations
$Lon_formEvent:=Form event code:C388
$Lon_wHandle:=Selected list items:C379(<>Lst_windows; *)

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($Lon_formEvent=On Mouse Move:K2:35)
		
		GET MOUSE:C468($Lon_mouseX; $Lon_mouseY; $Lon_button)
		
		OBJECT GET COORDINATES:C663(<>Lst_windows; $Lon_left; $Lon_top; $Lon_right; $Lon_bottom)
		$Lon_mouseY:=$Lon_mouseY-$Lon_top
		
		OBJECT GET SCROLL POSITION:C1114(<>Lst_windows; $Lon_firstLine)
		GET LIST PROPERTIES:C632(<>Lst_windows; $Lon_; $Lon_; $Lon_lineHeight)
		
		$Lon_line:=$Lon_firstLine+($Lon_mouseY\$Lon_lineHeight)
		
		For ($Lon_i; 1; Count list items:C380(<>Lst_windows); 1)
			
			GET LIST ITEM:C378(<>Lst_windows; $Lon_i; $Lon_buffer; $Txt_buffer)
			SET LIST ITEM PARAMETER:C986(<>Lst_windows; $Lon_buffer; Additional text:K28:7; "")
			
		End for 
		
		GET LIST ITEM:C378(<>Lst_windows; $Lon_line; $Lon_wHandle; $Txt_buffer; $Lst_opened; $Boo_expanded)
		If (Is a list:C621($Lst_opened))
			
			$Txt_additional:=Choose:C955($Boo_expanded; Get localized string:C991("Items_hide"); Get localized string:C991("Items_show"))
			
		Else 
			
			GET LIST ITEM PARAMETER:C985(<>Lst_windows; $Lon_wHandle; "path"; $Txt_path)
			
		End if 
		
		SET LIST ITEM PARAMETER:C986(<>Lst_windows; $Lon_wHandle; Additional text:K28:7; $Txt_additional)
		
		If (Length:C16($Txt_path)>0)
			
			METHOD GET COMMENTS:C1189($Txt_path; $Txt_comment; *)
			$Txt_comment:=ST Get plain text:C1092($Txt_comment)
			
		End if 
		
		OBJECT SET HELP TIP:C1181(<>Lst_windows; $Txt_comment)
		
		//______________________________________________________
	: ($Lon_formEvent=On Mouse Leave:K2:34)
		
		For ($Lon_i; 1; Count list items:C380(<>Lst_windows); 1)
			
			GET LIST ITEM:C378(<>Lst_windows; $Lon_i; $Lon_buffer; $Txt_buffer)
			SET LIST ITEM PARAMETER:C986(<>Lst_windows; $Lon_buffer; Additional text:K28:7; "")
			
		End for 
		
		//______________________________________________________
	: ($Lon_formEvent=On Selection Change:K2:29)
		
		Case of 
				
			: ($Lon_wHandle=0)
				
				OBJECT SET ENABLED:C1123(*; "sel.@"; False:C215)
				
			: ($Lon_wHandle<0)
				
				OBJECT SET ENABLED:C1123(*; "sel.@"; False:C215)
				SELECT LIST ITEMS BY POSITION:C381(<>Lst_windows; -1)
				
			Else 
				
				OBJECT SET ENABLED:C1123(*; "sel.@"; True:C214)
				GET LIST ITEM PARAMETER:C985(<>Lst_windows; $Lon_wHandle; "type"; $Lon_buffer)
				
				OBJECT SET ENABLED:C1123(*; "sel.properties"; $Lon_buffer=Path project method:K72:1)
				OBJECT SET ENABLED:C1123(*; "sel.comment"; $Lon_buffer#Path database method:K72:2)
				
		End case 
		
		//______________________________________________________
	: ($Lon_formEvent=On Clicked:K2:4)
		
		If (Contextual click:C713)
			
			Palette_MENU("context")
			
		Else 
			
			GET MOUSE:C468($Lon_mouseX; $Lon_mouseY; $Lon_button)
			
			OBJECT GET COORDINATES:C663(<>Lst_windows; $Lon_left; $Lon_top; $Lon_right; $Lon_bottom)
			
			If ($Lon_mouseX>($Lon_right-80))
				
				$Lon_mouseY:=$Lon_mouseY-$Lon_top
				
				OBJECT GET SCROLL POSITION:C1114(<>Lst_windows; $Lon_firstLine)
				GET LIST PROPERTIES:C632(<>Lst_windows; $Lon_; $Lon_; $Lon_lineHeight)
				
				$Lon_line:=$Lon_firstLine+($Lon_mouseY\$Lon_lineHeight)
				
				GET LIST ITEM:C378(<>Lst_windows; $Lon_line; $Lon_wHandle; $Txt_title; $Lst_opened; $Boo_expanded)
				
				If (Is a list:C621($Lst_opened))
					
					If (<>Lon_options ?? 4)
						
						$Txt_command:=Choose:C955($Boo_expanded; "hide"; "show")
						
						//Hide all windows attached…
						For ($Lon_i; 1; Count list items:C380($Lst_opened; *); 1)
							
							GET LIST ITEM:C378($Lst_opened; $Lon_i; $Lon_buffer; $Txt_buffer)
							WINDOW_ACTION($Txt_command; $Lon_buffer)
							
						End for 
						
						//…then finally mask the main window if it exists.
						WINDOW_ACTION($Txt_command; $Lon_wHandle)
						
					Else 
						
						$Txt_command:=Choose:C955($Boo_expanded; "dock"; "undock")
						
						//Si ($Txt_command="hide")
						
						//Hide all windows attached…
						For ($Lon_i; 1; Count list items:C380($Lst_opened; *); 1)
							
							GET LIST ITEM:C378($Lst_opened; $Lon_i; $Lon_buffer; $Txt_buffer)
							WINDOW_ACTION($Txt_command; $Lon_buffer)
							
						End for 
						
						//…then finally mask the main window if it exists.
						WINDOW_ACTION($Txt_command; $Lon_wHandle)
						
						//Sinon 
						//
						//  //Hide all windows attached…
						//Boucle ($Lon_i;1;Nombre elements($Lst_opened;*);1)
						//
						//INFORMATION ELEMENT($Lst_opened;$Lon_i;$Lon_buffer;$Txt_buffer)
						//COORDONNEES FENETRE($Lon_left;$Lon_top;$Lon_right;$Lon_bottom;$Lon_buffer)
						//CHANGER COORDONNEES FENETRE($Lon_left;$Lon_top;$Lon_right;$Lon_bottom;$Lon_buffer)
						//
						//Fin de boucle 
						//
						//  //…then finally mask the main window if it exists.
						//COORDONNEES FENETRE($Lon_left;$Lon_top;$Lon_right;$Lon_bottom;$Lon_wHandle)
						//CHANGER COORDONNEES FENETRE($Lon_left;$Lon_top;$Lon_right;$Lon_bottom;$Lon_wHandle)
						//
						//fin de si
					End if 
					
					$Boo_expanded:=Not:C34($Boo_expanded)
					SET LIST ITEM:C385(<>Lst_windows; $Lon_wHandle; $Txt_title; $Lon_wHandle; $Lst_opened; $Boo_expanded)
					SET LIST ITEM PARAMETER:C986(<>Lst_windows; $Lon_wHandle; Additional text:K28:7; Choose:C955($Boo_expanded; Get localized string:C991("Items_hide"); Get localized string:C991("Items_show")))
					GET LIST ITEM ICON:C951(<>Lst_windows; $Lon_wHandle; $Pic_picto)
					SET LIST ITEM PROPERTIES:C386(<>Lst_windows; $Lon_wHandle; False:C215; Bold:K14:2; 0; 0x00666666)
					SET LIST ITEM ICON:C950(<>Lst_windows; $Lon_wHandle; $Pic_picto)
					
					CLEAR VARIABLE:C89($Lon_wHandle)
					
				End if 
				
				
			Else 
				
				
				
				
				
			End if 
			
			If ($Lon_wHandle>0)
				
				Palette_MENU("foreground")
				
			Else 
				
				//LIRE PARAMETRE ELEMENT(<>Lst_methods;*;"path";$Txt_path)
				//METHODE OUVRIR CHEMIN($Txt_path;*)
				
			End if 
		End if 
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Unnecessarily activated form event")
		
		//______________________________________________________
End case 