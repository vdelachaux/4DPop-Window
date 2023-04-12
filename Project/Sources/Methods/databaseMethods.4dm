//%attributes = {"invisible":true}
#DECLARE($which : Text; $eventCode : Integer)

If (False:C215)
	C_TEXT:C284(databaseMethods; $1)
	C_LONGINT:C283(databaseMethods; $2)
End if 

var component : cs:C1710._component

Case of 
		
		//______________________________________________________
	: ($which="On Startup")
		
		If (Not:C34(Is compiled mode:C492))
			
			ARRAY TEXT:C222($componentsArray; 0x0000)
			COMPONENT LIST:C1001($componentsArray)
			
			If (Find in array:C230($componentsArray; "4DPop QuickOpen")>0)
				
				// Installing quickOpen
				EXECUTE METHOD:C1007("quickOpenInit"; *; Formula:C1597(MODIFIERS); Formula:C1597(KEYCODE))
				ON EVENT CALL:C190("quickOpenEventHandler"; "$quickOpenListener")
				
			End if 
		End if 
		
		component:=cs:C1710._component.new()
		
		//______________________________________________________
	: ($which="On Exit")
		
		//
		
		//______________________________________________________
	: ($which="On Host Database Event")
		
		Case of 
				
				//________________________________________
			: ($eventCode=On before host database startup:K74:3)
				
/*
The host database has just been started.
The On Startup database method method of the host database has not yet been called.
*/
				
				If (Is compiled mode:C492)\
					 | (Structure file:C489#Structure file:C489(*))
					
					// Define the global error handler
					ON ERR CALL:C155("noError"; ek global:K92:2)
					
				Else 
					
					// No error handler for the dev mode
					ON ERR CALL:C155(""; ek global:K92:2)
					SET ASSERT ENABLED:C1131(True:C214; *)
					
				End if 
				
				//________________________________________
			: ($eventCode=On after host database startup:K74:4)
				
/*
The On Startup database method of the host database just finished running
*/
				
				component:=cs:C1710._component.new()
				
				If (component.preferences.get("option") ?? 3)  // Prepend title of windows with the name of the database
					
					tool_renameWindows
					
				End if 
				
				//________________________________________
			: ($eventCode=On before host database exit:K74:5)
				
/*
The host database is closing.
The On Exit database method of the host database has not yet been called.
*/
				
				
				//________________________________________
			: ($eventCode=On after host database exit:K74:6)
				
/*
The On Exit database method of the host database has just finished running
*/
				
				//________________________________________
		End case 
		
		//______________________________________________________
End case 