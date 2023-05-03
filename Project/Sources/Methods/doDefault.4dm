//%attributes = {"invisible":true}
#DECLARE($data : Object)

var $default : Text

COMPILER_MAIN

$default:=component.preferences.get("default")

Case of 
		
		//________________________
	: ($default="menu")
		
		component.menu()
		
		//________________________
	: ($default="stack")
		
		component.stackWindows()
		
		//________________________
	: ($default="inscreen")
		
		component.bringToFront(Frontmost window:C447)
		
		//________________________
	: ($default="next")
		
		component.bringToFront(Next window:C448(Frontmost window:C447))
		
		//________________________
End case 