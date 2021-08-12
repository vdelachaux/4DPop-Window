//%attributes = {"invisible":true}
C_LONGINT:C283($0)

C_LONGINT:C283($Lon_Bottom; $Lon_Left; $Lon_Right; $Lon_Top; $Lon_Window_Reference; $Lon_WindowPart)

If (False:C215)
	C_LONGINT:C283(env_ToolBar_Height; $0)
End if 

$Lon_Window_Reference:=Find window:C449(10; Menu bar height:C440+10; $Lon_WindowPart)

If ($Lon_Window_Reference#0)
	
	If (Get window title:C450($Lon_Window_Reference)="Main To")
		
		GET WINDOW RECT:C443($Lon_Left; $Lon_Top; $Lon_Right; $Lon_Bottom; $Lon_Window_Reference)
		$0:=$Lon_Bottom
		
	End if 
End if 