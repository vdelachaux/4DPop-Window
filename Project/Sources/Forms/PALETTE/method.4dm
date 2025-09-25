// ----------------------------------------------------
// Method : methodPalette
// Created 02/03/10 by Vincent de Lachaux
// ----------------------------------------------------
var $digest : Text
var $isMinimized : Boolean
var $bottom; $height; $i; $left; $right; $top : Integer
var $zone : Integer
var $ptr : Pointer
var $o : Object

SET TIMER:C645(0)

var $e:=FORM Event:C1606

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
		
		SET TIMER:C645(-1)
		
		//______________________________________________________
	: ($e.code=On Timer:K2:25)
		
		If (Process info:C1843(Window process:C446(Frontmost window:C447)).type=Design process:K36:9)
			
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
				If (Not:C34(Process info:C1843(Current process:C322).visible))
					
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
		
		//
		
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