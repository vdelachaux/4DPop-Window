//%attributes = {"invisible":true}
// ----------------------------------------------------
// Method : Palette_RUN
// Created 02/03/10 by Vincent de Lachaux
// ----------------------------------------------------
// Description
// Open the live window palette
// ----------------------------------------------------
#DECLARE($entry : Text)

COMPILER_MAIN

// ----------------------------------------------------
Case of 
		
		// ______________________________________________________
	: (Count parameters:C259=0)
		
		If (component.showPalette)
			
			BRING TO FRONT:C326(New process:C317(Current method name:C684; 0; "$4DPopWindows_palette"; "run"; *))
			
		Else 
			
			<>Win_palette:=-1
			
		End if 
		
		// ______________________________________________________
	: ($entry="run")
		
		COMPILER_MAIN
		
		<>Lst_windows:=New list:C375
		
		// Add already opened windows {
		ARRAY LONGINT:C221($tLon_wReferences; 0x0000)
		WINDOW LIST:C442($tLon_wReferences)
		
		var $i : Integer
		
		For ($i; 1; Size of array:C274($tLon_wReferences); 1)
			
			Palette_ADD_WINDOW($tLon_wReferences{$i})
			
		End for   // }
		
		<>Win_palette:=Open form window:C675("PALETTE"; Palette form window:K39:9; On the left:K39:2; At the top:K39:5; *)
		DIALOG:C40("PALETTE")
		CLOSE WINDOW:C154
		
		CLEAR LIST:C377(<>Lst_windows; *)
		
		CLEAR VARIABLE:C89(<>Win_palette)
		
		// ______________________________________________________
	Else 
		
		TRACE:C157
		
		// ______________________________________________________
End case 