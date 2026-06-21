//%attributes = {"invisible":true,"shared":true}
#DECLARE()

COMPILER_MAIN

var $ws : cs:C1710.workspace:=cs:C1710.workspace.new()
var $lastSignature; $signature : Text
var $waitTicks : Integer:=20

Repeat 
	
	If (Not:C34($ws.autosave()))
		
		break
		
	End if 

	If ($ws.closing())
		DELAY PROCESS:C323(Current process:C322; $waitTicks)
		continue
	End if 
	
	If (Length:C16($ws.current())>0)
		
		$signature:=component.workspaceFingerprint()
		
		If ($signature#$lastSignature)
			
			If (Length:C16($lastSignature)>0)
				
				$ws.updateCurrent()
				
			End if 
			
			$lastSignature:=$signature
			
		End if 
		
	Else 
		
		$lastSignature:=""
		
	End if 
	
	DELAY PROCESS:C323(Current process:C322; $waitTicks)
	
Until (False:C215)
