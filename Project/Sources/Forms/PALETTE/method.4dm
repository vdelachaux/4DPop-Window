// ----------------------------------------------------
// Method : methodPalette
// Created 02/03/10 by Vincent de Lachaux
// ----------------------------------------------------
var $digest; $t : Text
var $b; $isMinimized; $isVisible : Boolean
var $bottom; $height; $i; $left; $l : Integer
var $zone; $origin; $right; $top : Integer
var $ptr : Pointer
var $e; $o : Object

$e:=FORM Event:C1606
SET TIMER:C645(0)

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: (Process aborted:C672)
		
		CLEAR LIST:C377(<>Lst_wHidden; *)
		CLEAR LIST:C377(<>Lst_windows; *)
		
		ACCEPT:C269
		
		//______________________________________________________
	: ($e.code=On Load:K2:1)
		
		$ptr:=OBJECT Get pointer:C1124(Object named:K67:5; "inited")
		
		If ($ptr->=0)
			
			$ptr->:=1
			
			$o:=component.preferences.get("palette")
			
			If (Num:C11($o.left)<0)
				
				GET WINDOW RECT:C443($left; $top; $right; $bottom; <>Win_palette)
				
				If (Find window:C449(0; Menu bar height:C440+1; $zone)>0)
					
					SET WINDOW RECT:C444($left; $top+60; $right; $bottom+60; <>Win_palette)
					
				End if 
				
			Else 
				
				$isMinimized:=component.preferences.get("paletteMini")
				
				If ($isMinimized)
					
					FORM SET HORIZONTAL RESIZING:C892(False:C215)
					FORM SET VERTICAL RESIZING:C893(False:C215)
					SET WINDOW RECT:C444($left; $top; $right; $top+24; <>Win_palette)
					
				Else 
					
					RESIZE FORM WINDOW:C890($right-$left; $bottom-$top)
					SET WINDOW RECT:C444($left; $top; $right; $bottom; <>Win_palette)
					
				End if 
			End if 
			
		Else 
			
			GET WINDOW RECT:C443($left; $top; $right; $bottom; <>Win_palette)
			$isMinimized:=(($bottom-$top)=24)
			
		End if 
		
		OBJECT SET FORMAT:C236(*; "reduce"; ";#images/skins/lightGrey/"+Choose:C955($isMinimized; "maxi"; "mini")+".png")
		
		(OBJECT Get pointer:C1124(Object named:K67:5; "hight_opened"))->:=($bottom-$top)
		
		// List roperties and position
		SET LIST PROPERTIES:C387(<>Lst_windows; -1; -1; 19; 1)
		
		//GET WINDOW RECT($left;$top;$right;$bottom;<>Win_palette)
		//$Lon_width:=$right-$left
		//OBJECT GET COORDINATES(*;"main.list";$left;$top;$right;$bottom)
		//OBJECT SET COORDINATES(*;"main.list";0;25;$Lon_width;$bottom)
		
		SET TIMER:C645(-1)
		
		//______________________________________________________
	: ($e.code=On Timer:K2:25)
		
		//$kTxt_formMethod:=Get localized string("FormMethod")
		//ARRAY LONGINT($tLon_windowHandles;0x0000)
		//WINDOW LIST($tLon_windowHandles;*)
		//If (Find in array($tLon_windowHandles;<>Win_palette)>0)  // The palette is active
		//  // Add form opened windows {
		//WINDOW LIST($tLon_windowHandles)
		//For ($i;1;Size of array($tLon_windowHandles);1)
		//$Win_hdl:=$tLon_windowHandles{$i}
		//$Txt_wName:=Get window title($Win_hdl)
		//$Lon_x:=Position(" - ";$Txt_wName)
		//If ($Lon_x>0)
		//$Txt_wName:=Delete string($Txt_wName;1;$Lon_x+2)
		// End if
		// Case of
		//  //_____________________________________________________
		//: ($Txt_wName=($kTxt_formMethod+"@"))
		//$Txt_title:=Replace string($Txt_wName;$kTxt_formMethod;"")
		//$Lon_x:=Find in list(<>Lst_windows;$Txt_title;0)
		//If ($Lon_x=0)
		//APPEND TO LIST(<>Lst_windows;Uppercase($Txt_title);$Win_hdl;New list;True)
		//SET LIST ITEM PROPERTIES(<>Lst_windows;$Win_hdl;False;Bold;0;0x00666666)
		//READ PICTURE FILE(Get 4D folder(Current resources folder)+"images"+Folder separator+"form.png";$Pic_picto)
		//SET LIST ITEM ICON(<>Lst_windows;0;$Pic_picto)
		// Else
		//GET LIST ITEM(<>Lst_windows;$Lon_x;$Lon_Ref;$Txt_buffer;$Lst_opened;$Boo_expanded)
		//If ($Win_hdl#0) & ($Lon_Ref#$Win_hdl)
		//SET LIST ITEM(<>Lst_windows;$Lon_Ref;$Txt_buffer;$Win_hdl;$Lst_opened;$Boo_expanded)
		// End if
		// End if
		//  //_____________________________________________________
		// End case
		// End for
		//  // }
		//  // Check window validity {
		//For ($i;Count list items(<>Lst_windows;*);1;-1)
		//GET LIST ITEM(<>Lst_windows;$i;$Win_hdl;$Txt_name;$Lst_opened;$Boo_expanded)
		//If ($Win_hdl>0)
		//If (Find in array($tLon_windowHandles;$Win_hdl)=-1)
		//GET LIST ITEM PARAMETER(<>Lst_windows;$Win_hdl;"hide";$Boo_hidden)
		//If (Not($Boo_hidden))
		//If (Count list items($Lst_opened)>0)
		//SET LIST ITEM(<>Lst_windows;$Win_hdl;$Txt_name;-$Win_hdl;$Lst_opened;$Boo_expanded)
		// Else
		//DELETE FROM LIST(<>Lst_windows;$Win_hdl)
		// End if
		// End if
		// Else
		//  // Perhaps the name (and the path !) is obsolete
		//$Txt_wName:=Get window title($Win_hdl)
		//$Lon_x:=Position(" - ";$Txt_wName)
		//If ($Lon_x>0)
		//$Txt_wName:=Delete string($Txt_wName;1;$Lon_x+2)
		// End if
		//GET LIST ITEM PARAMETER(<>Lst_windows;$Win_hdl;"wTitle";$Txt_buffer)
		//If (Length($Txt_buffer)>0)
		//If ($Txt_wName#$Txt_buffer)
		//SET LIST ITEM PARAMETER(<>Lst_windows;$Win_hdl;"wTitle";$Txt_wName)
		//$Txt_title:=$Txt_wName
		//$Lon_x:=Position(":";$Txt_title)
		//If ($Lon_x>0)
		//$Txt_title:=Delete string($Txt_title;1;$Lon_x+1)
		// End if
		//$Txt_wName:=$Txt_title
		//GET LIST ITEM PARAMETER(<>Lst_windows;$Win_hdl;"type";$Lon_type)
		//If ($Lon_type=Path project form) | ($Lon_type=Path table form)
		//  //$Lon_x:=Element parent(<>Lst_methods;$Lon_wHandle;*)
		//  //Si ($Lon_x>0)  // Form
		//  //
		//  //$Lon_x:=Element parent(<>Lst_methods;$Lon_wHandle)
		//  //INFORMATION ELEMENT(<>Lst_methods;$Lon_x;$Lon_x;$Txt_form;$Lst_opened;$Boo_expanded)
		//  //CHANGER ELEMENT(<>Lst_methods;$Lon_x;$Txt_title;$Lon_x;$Lst_opened;$Boo_expanded)
		//  //
		//  // Fin de si
		//$Txt_title:=$Txt_title+" ("+Get localized string("MenuLabelsFormMethod")+")"
		// End if
		//SET LIST ITEM(<>Lst_windows;$Win_hdl;$Txt_title;$Win_hdl;$Lst_opened;$Boo_expanded)
		//GET LIST ITEM PARAMETER(<>Lst_windows;$Win_hdl;"path";$Txt_path)
		//If (Length($Txt_path)>0)
		//$Lon_x:=Position(":";$Txt_buffer)
		//If ($Lon_x>0)
		//$Txt_buffer:=Delete string($Txt_buffer;1;$Lon_x+1)
		// End if
		//$Txt_path:=Replace string($Txt_path;$Txt_buffer;$Txt_wName)
		//SET LIST ITEM PARAMETER(<>Lst_windows;$Win_hdl;"path";$Txt_path)
		// End if
		// End if
		// End if
		// End if
		// End if
		//End for // }
		// If (Count list items(<>Lst_windows)>0)
		// SHOW WINDOW(<>Win_palette)
		//$Win_hdl:=Frontmost window
		//SELECT LIST ITEMS BY REFERENCE(<>Lst_windows;$Win_hdl)
		// Else
		// HIDE WINDOW(<>Win_palette)
		// End if
		// End if
		
		PROCESS PROPERTIES:C336(Window process:C446(Frontmost window:C447); $t; $l; $l; $b; $l; $origin)
		
		If ($origin=Design process:K36:9)
			
			// Add already opened windows {
			ARRAY LONGINT:C221($windows; 0x0000)
			WINDOW LIST:C442($windows)
			
			// Sort array else the digest will not be the same
			SORT ARRAY:C229($windows)
			
			$digest:=JSON Stringify array:C1228($windows)
			
			If ($digest#<>Txt_digest)
				
				// Update the list
				CLEAR LIST:C377(<>Lst_windows; *)
				
				<>Lst_windows:=New list:C375
				
				For ($i; 1; Size of array:C274($windows); 1)
					
					Palette_ADD_WINDOW($windows{$i})
					
				End for   // }
				
				// Keep digest
				<>Txt_digest:=$digest
				
			End if 
			
			If (Count list items:C380(<>Lst_windows)>0)
				
				// *** show a process already visible generate high processor activity ***
				PROCESS PROPERTIES:C336(Current process:C322; $t; $l; $l; $isVisible)
				
				If (Not:C34($isVisible))
					
					SHOW PROCESS:C325(Current process:C322)
					
				End if 
				
				SELECT LIST ITEMS BY REFERENCE:C630(<>Lst_windows; Frontmost window:C447)
				
			Else 
				
				HIDE PROCESS:C324(Current process:C322)
				
			End if 
			
		Else 
			
			HIDE PROCESS:C324(Current process:C322)
			
		End if 
		
		SET TIMER:C645(30)
		
		//______________________________________________________
	: ($e.code=On Deactivate:K2:10)
		
		// NOTHING MORE TO DO
		
		//______________________________________________________
	: ($e.code=On Activate:K2:9)
		
		SET TIMER:C645(-1)
		
		//______________________________________________________
	: ($e.code=On Close Box:K2:21)
		
		ACCEPT:C269
		
		//______________________________________________________
	: ($e.code=On Outside Call:K2:11)
		
		SET TIMER:C645(-1)
		
		//______________________________________________________
	: ($e.code=On Resize:K2:27)
		
		//GET WINDOW RECT($left;$top;$right;$bottom;<>Win_palette)
		//$height:=$bottom-$top
		//$isMinimized:=($height=24)
		//PREFERENCES ("w.palette.mini.set";->$isMinimized)
		//If (Not($isMinimized))
		//(OBJECT Get pointer(Object named;"hight_opened"))->:=$height
		//PREFERENCES ("w.palette.set";->$left;->$top;->$right;->$bottom)
		// End if
		// SET TIMER(-1)
		
		//______________________________________________________
	: ($e.code=On Unload:K2:2)
		
		GET WINDOW RECT:C443($left; $top; $right; $bottom; <>Win_palette)
		$height:=$bottom-$top
		$isMinimized:=($height=24)
		
		component.preferences.set("paletteMini"; $isMinimized)
		
		If ($height>24)
			
			(OBJECT Get pointer:C1124(Object named:K67:5; "hight_opened"))->:=$height
			component.preferences.set("palette"; New object:C1471(\
				"left"; $left; \
				"top"; $top; \
				"right"; $right; \
				"bottom"; $bottom))
			
		End if 
		
		CLEAR VARIABLE:C89(<>Win_palette)
		
		// Restore all hidden windows if any
		Palette_MENU("show_all")
		
		//______________________________________________________
	Else 
		
		TRACE:C157
		
		//______________________________________________________
End case 