//%attributes = {"invisible":true,"shared":true}
// ----------------------------------------------------
// Method : 4DPopWindow_macroOnClose
// Created 02/03/10 by Vincent de Lachaux
// ----------------------------------------------------
// Description
//
// ----------------------------------------------------
// Declarations
C_TEXT:C284($1)

C_BOOLEAN:C305($Boo_)
C_LONGINT:C283($Lon_i; $Lon_parent; $Lon_reference; $Lst_sub)
C_TEXT:C284($Txt_; $Txt_buffer; $Txt_methodPath)

If (False:C215)
	C_TEXT:C284(4DPopWindow_macroOnClose; $1)
End if 

// ----------------------------------------------------
// Initialisations
If (Process aborted:C672)
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
If (<>Lon_options ?? 2)
	
	If (<>Win_palette#0)
		
		// #31-10-2014 - window is now closed before the macro call !
		//$Lon_ref:=Frontmost window
		//If (List item position(<>Lst_methods;$Lon_ref)>0)
		//$Lon_parent:=List item parent(<>Lst_methods;$Lon_ref)
		//$Lon_position:=List item position(<>Lst_methods;$Lon_parent)
		//GET LIST ITEM(<>Lst_methods;$Lon_position;$Lon_reference;$Txt_label;$Lon_sublist;$Boo_expanded)
		//If (Count list items($Lon_sublist)=1)
		//If ($Lon_reference<0)
		//CLEAR LIST($Lon_sublist)
		//DELETE FROM LIST(<>Lst_methods;$Lon_reference)
		//Else
		//DELETE FROM LIST(<>Lst_methods;$Lon_ref)
		//End if
		//Else
		//DELETE FROM LIST(<>Lst_methods;$Lon_ref)
		//End if
		//End if
		
		If (Count parameters:C259>=1)
			
			$Txt_methodPath:=$1
			
			For ($Lon_i; 1; Count list items:C380(<>Lst_windows); 1)
				
				GET LIST ITEM:C378(<>Lst_windows; $Lon_i; $Lon_reference; $Txt_)
				GET LIST ITEM PARAMETER:C985(<>Lst_windows; $Lon_reference; "path"; $Txt_buffer)
				
				If ($Txt_buffer=$Txt_methodPath)
					
					//get the parent's informations
					GET LIST ITEM:C378(<>Lst_windows; \
						List item position:C629(<>Lst_windows; List item parent:C633(<>Lst_windows; $Lon_reference)); \
						$Lon_parent; \
						$Txt_; \
						$Lst_sub; \
						$Boo_)
					
					If (Count list items:C380($Lst_sub)=1)
						
						//last item for the parent
						If ($Lon_parent<0)
							
							CLEAR LIST:C377($Lst_sub)
							DELETE FROM LIST:C624(<>Lst_windows; $Lon_parent)
							
						Else 
							
							DELETE FROM LIST:C624(<>Lst_windows; $Lon_reference)
							
						End if 
						
					Else 
						
						DELETE FROM LIST:C624(<>Lst_windows; $Lon_reference)
						
					End if 
					
					$Lon_i:=MAXLONG:K35:2-1
					
				End if 
			End for 
		End if 
		
		If (Count list items:C380(<>Lst_windows)>0)
			
			//SHOW WINDOW(<>Win_palette)
			POST OUTSIDE CALL:C329(-1)
			
		Else 
			
			HIDE WINDOW:C436(<>Win_palette)
			
		End if 
	End if 
End if 