//%attributes = {"invisible":true,"publishedWsdl":true}
// ----------------------------------------------------
// Method : Palette_ADD_ELEMENT
// Created 29/03/10 by Vincent de Lachaux
// ----------------------------------------------------
// Description
// Just for fun give a look to the method "add_item_to_list" (in the v11 or v12 component)
// and note how it's easier to manage the palette ;-)
// ----------------------------------------------------
// Declarations
C_TEXT:C284($1)
C_LONGINT:C283($2)

C_BOOLEAN:C305($Boo_expanded)
C_LONGINT:C283($Lon_buffer; $Lon_formWindow; $Lon_i; $Lon_parent; $Lon_type; $Lon_x)
C_LONGINT:C283($Lst_opened; $Win_hdl)
C_PICTURE:C286($Pic_picto)
C_POINTER:C301($Ptr_table)
C_TEXT:C284($Txt_buffer; $Txt_name; $Txt_object; $Txt_parent; $Txt_path; $Txt_title)
C_TEXT:C284($Txt_wName)

ARRAY LONGINT:C221($tLon_windowReferences; 0)

If (False:C215)
	C_TEXT:C284(Palette_ADD_ELEMENT; $1)
	C_LONGINT:C283(Palette_ADD_ELEMENT; $2)
End if 

// ----------------------------------------------------
// Initialisations
$Txt_path:=$1

If (Count parameters:C259>=2)
	
	$Win_hdl:=$2
	
Else 
	
	$Win_hdl:=Frontmost window:C447
	
End if 

// ----------------------------------------------------
If (List item position:C629(<>Lst_windows; $Win_hdl)=0)
	
	METHOD RESOLVE PATH:C1165($Txt_path; $Lon_type; $Ptr_table; $Txt_name; $Txt_object; *)
	
	Case of 
			
			//______________________________________________________
		: (Length:C16($Txt_object)>0)
			
			//$Txt_title:=Choose(Not(Nil($Ptr_table));"["+Table name($Ptr_table)+"]"+$Txt_name;$Txt_name)
			If (Not:C34(Is nil pointer:C315($Ptr_table)))
				
				//table form
				$Txt_title:="["+Table name:C256($Ptr_table)+"]"+$Txt_name
				
			Else 
				
				$Txt_title:=$Txt_name
				
			End if 
			
			WINDOW LIST:C442($tLon_windowReferences)
			
			For ($Lon_i; 1; Size of array:C274($tLon_windowReferences); 1)
				
				If (Get window title:C450($tLon_windowReferences{$Lon_i})=("@"+Get localized string:C991("Form")+$Txt_title))\
					 & ($tLon_windowReferences{$Lon_i}#$Win_hdl)
					
					$Lon_formWindow:=$tLon_windowReferences{$Lon_i}
					$Lon_i:=MAXLONG:K35:2-1
					
				End if 
			End for 
			
			$Lon_x:=Find in list:C952(<>Lst_windows; $Txt_title; 0)
			
			If ($Lon_x=0)
				
				$Lon_parent:=Choose:C955($Lon_formWindow#0; $Lon_formWindow; -(Count list items:C380(<>Lst_windows)+1))
				
				APPEND TO LIST:C376(<>Lst_windows; Uppercase:C13($Txt_title); $Lon_parent; New list:C375; True:C214)
				
				SET LIST ITEM PROPERTIES:C386(<>Lst_windows; $Lon_parent; False:C215; Bold:K14:2; 0; 0x00666666)
				
				READ PICTURE FILE:C678(Get 4D folder:C485(Current resources folder:K5:16)+"images"+Folder separator:K24:12+"form.png"; $Pic_picto)
				SET LIST ITEM ICON:C950(<>Lst_windows; 0; $Pic_picto)
				
			Else 
				
				GET LIST ITEM:C378(<>Lst_windows; $Lon_x; $Lon_parent; $Txt_buffer; $Lst_opened; $Boo_expanded)
				
				If ($Lon_formWindow#0)\
					 & ($Lon_parent#$Lon_formWindow)
					
					SET LIST ITEM:C385(<>Lst_windows; $Lon_parent; $Txt_buffer; $Lon_formWindow; $Lst_opened; $Boo_expanded)
					
				End if 
			End if 
			
			$Txt_title:=$Txt_title+"."+$Txt_object
			READ PICTURE FILE:C678(Get 4D folder:C485(Current resources folder:K5:16)+"images"+Folder separator:K24:12+"method.png"; $Pic_picto)
			
			$Lon_type:=0
			
			//______________________________________________________
		: ($Lon_type=Path project method:K72:1)
			
			$Txt_parent:=" "+Uppercase:C13(Get localized string:C991("MenuLabelsProjectMethods"))
			$Lon_parent:=Find in list:C952(<>Lst_windows; $Txt_parent; 0; *)
			
			If ($Lon_parent=0)
				
				$Lon_parent:=-(Count list items:C380(<>Lst_windows)+1)
				
				APPEND TO LIST:C376(<>Lst_windows; $Txt_parent; $Lon_parent; New list:C375; True:C214)
				SET LIST ITEM PROPERTIES:C386(<>Lst_windows; $Lon_parent; False:C215; Bold:K14:2; 0; 0x00666666)
				
				READ PICTURE FILE:C678(Get 4D folder:C485(Current resources folder:K5:16)+"images"+Folder separator:K24:12+"group.png"; $Pic_picto)
				SET LIST ITEM ICON:C950(<>Lst_windows; 0; $Pic_picto)
				
			End if 
			
			$Txt_title:=$Txt_name
			READ PICTURE FILE:C678(Get 4D folder:C485(Current resources folder:K5:16)+"images"+Folder separator:K24:12+"method.png"; $Pic_picto)
			
			//______________________________________________________
		: ($Lon_type=Path database method:K72:2)
			
			$Txt_parent:=" "+Uppercase:C13(Get localized string:C991("MenuLabelsDatabaseMethods"))
			$Lon_parent:=Find in list:C952(<>Lst_windows; $Txt_parent; 0; *)
			
			If ($Lon_parent=0)
				
				$Lon_parent:=-(Count list items:C380(<>Lst_windows)+1)
				
				APPEND TO LIST:C376(<>Lst_windows; $Txt_parent; $Lon_parent; New list:C375; True:C214)
				SET LIST ITEM PROPERTIES:C386(<>Lst_windows; $Lon_parent; False:C215; Bold:K14:2; 0; 0x00666666)
				
				//LIRE FICHIER IMAGE(Dossier 4D(Dossier Resources courant)+"images"+Séparateur dossier+"group.png";$Pic_picto)
				//FIXER ICONE ELEMENT(<>Lst_methods;0;$Pic_picto)
				
			End if 
			
			$Txt_buffer:=Get localized string:C991($Txt_name)
			$Txt_title:=Choose:C955(Length:C16($Txt_buffer)>0; $Txt_buffer; $Txt_name)
			READ PICTURE FILE:C678(Get 4D folder:C485(Current resources folder:K5:16)+"images"+Folder separator:K24:12+"databaseMethod.png"; $Pic_picto)
			
			//______________________________________________________
		: ($Lon_type=Path trigger:K72:4)
			
			$Txt_parent:=" "+Uppercase:C13(Get localized string:C991("MenuLabelsTriggers"))
			$Lon_parent:=Find in list:C952(<>Lst_windows; $Txt_parent; 0; *)
			
			If ($Lon_parent=0)
				
				$Lon_parent:=-(Count list items:C380(<>Lst_windows)+1)
				
				APPEND TO LIST:C376(<>Lst_windows; $Txt_parent; $Lon_parent; New list:C375; True:C214)
				SET LIST ITEM PROPERTIES:C386(<>Lst_windows; $Lon_parent; False:C215; Bold:K14:2; 0; 0x00666666)
				
				//LIRE FICHIER IMAGE(Dossier 4D(Dossier Resources courant)+"images"+Séparateur dossier+"group.png";$Pic_picto)
				//FIXER ICONE ELEMENT(<>Lst_methods;0;$Pic_picto)
				
			End if 
			
			$Txt_title:="["+Table name:C256($Ptr_table)+"]"
			READ PICTURE FILE:C678(Get 4D folder:C485(Current resources folder:K5:16)+"images"+Folder separator:K24:12+"triggerMethod.png"; $Pic_picto)
			
			//______________________________________________________
		: ($Lon_type=Path project form:K72:3)\
			 | ($Lon_type=Path table form:K72:5)
			
			//$Txt_title:=Choose($Lon_type=Path project form;$Txt_name;"["+Table name($Ptr_table)+"]"+$Txt_name)
			If ($Lon_type=Path project form:K72:3)
				
				//project form
				$Txt_title:=$Txt_name
				
			Else 
				
				$Txt_title:="["+Table name:C256($Ptr_table)+"]"+$Txt_name
				
			End if 
			
			WINDOW LIST:C442($tLon_windowReferences)
			
			For ($Lon_i; 1; Size of array:C274($tLon_windowReferences); 1)
				
				If (Get window title:C450($tLon_windowReferences{$Lon_i})=("@"+Get localized string:C991("Form")+$Txt_title))\
					 & ($tLon_windowReferences{$Lon_i}#$Win_hdl)
					
					$Lon_formWindow:=$tLon_windowReferences{$Lon_i}
					$Lon_i:=MAXLONG:K35:2-1
					
				End if 
			End for 
			
			$Lon_x:=Find in list:C952(<>Lst_windows; $Txt_title; 0)
			
			If ($Lon_x=0)
				
				$Lon_parent:=Choose:C955($Lon_formWindow#0; $Lon_formWindow; -(Count list items:C380(<>Lst_windows)+1))
				
				APPEND TO LIST:C376(<>Lst_windows; Uppercase:C13($Txt_title); $Lon_parent; New list:C375; True:C214)
				SET LIST ITEM PROPERTIES:C386(<>Lst_windows; $Lon_parent; False:C215; Bold:K14:2; 0; 0x00666666)
				
				READ PICTURE FILE:C678(Get 4D folder:C485(Current resources folder:K5:16)+"images"+Folder separator:K24:12+"form.png"; $Pic_picto)
				SET LIST ITEM ICON:C950(<>Lst_windows; 0; $Pic_picto)
				
			Else 
				
				GET LIST ITEM:C378(<>Lst_windows; $Lon_x; $Lon_parent; $Txt_buffer; $Lst_opened; $Boo_expanded)
				
				If ($Lon_formWindow#0)\
					 & ($Lon_parent#$Lon_formWindow)
					
					SET LIST ITEM:C385(<>Lst_windows; $Lon_parent; $Txt_buffer; $Lon_formWindow; $Lst_opened; $Boo_expanded)
					
				End if 
			End if 
			
			$Txt_title:=$Txt_title+" ("+Get localized string:C991("MenuLabelsFormMethod")+")"
			READ PICTURE FILE:C678(Get 4D folder:C485(Current resources folder:K5:16)+"images"+Folder separator:K24:12+"formMethod.png"; $Pic_picto)
			
			//______________________________________________________
		Else 
			
			TRACE:C157
			
			//______________________________________________________
	End case 
	
	If ($Lon_parent#0)
		
		GET LIST ITEM:C378(<>Lst_windows; \
			List item position:C629(<>Lst_windows; $Lon_parent); \
			$Lon_buffer; \
			$Txt_buffer; \
			$Lst_opened; \
			$Boo_expanded)
		
		If ($Lon_buffer#0)\
			 & ($Lst_opened#0)
			
			If (Find in list:C952($Lst_opened; $Txt_title; 0)=0)
				
				APPEND TO LIST:C376($Lst_opened; $Txt_title; $Win_hdl)
				
			End if 
			
			SET LIST ITEM PARAMETER:C986($Lst_opened; $Win_hdl; "path"; $Txt_path)
			SET LIST ITEM PARAMETER:C986($Lst_opened; $Win_hdl; "type"; $Lon_type)
			
			$Txt_wName:=Get window title:C450($Win_hdl)
			
			$Lon_x:=Position:C15(" - "; $Txt_wName)
			
			If ($Lon_x>0)
				
				$Txt_wName:=Delete string:C232($Txt_wName; 1; $Lon_x+2)
				
			End if 
			
			SET LIST ITEM PARAMETER:C986($Lst_opened; $Win_hdl; "wTitle"; $Txt_wName)
			
			SET LIST ITEM ICON:C950(<>Lst_windows; $Win_hdl; $Pic_picto)
			
			SORT LIST:C391(<>Lst_windows)
			
		End if 
		
		SELECT LIST ITEMS BY REFERENCE:C630(<>Lst_windows; $Win_hdl)
		
	End if 
End if 