C_BOOLEAN:C305($Boo_minimized; $Boo_open)
C_LONGINT:C283($Lon_bottom; $Lon_height; $Lon_left; $Lon_right; $Lon_top)

GET WINDOW RECT:C443($Lon_left; $Lon_top; $Lon_right; $Lon_bottom; <>Win_palette)
$Lon_height:=$Lon_bottom-$Lon_top
$Boo_open:=($Lon_height=24)

If ($Boo_open)
	
	$Lon_height:=(OBJECT Get pointer:C1124(Object named:K67:5; "hight_opened"))->
	RESIZE FORM WINDOW:C890($Lon_right-$Lon_left; $Lon_height)
	OBJECT SET COORDINATES:C1248(*; "main.@"; 0; 25; $Lon_right-$Lon_left; $Lon_height)
	
Else 
	
	(OBJECT Get pointer:C1124(Object named:K67:5; "hight_opened"))->:=$Lon_height
	$Lon_height:=24
	
End if 

$Boo_minimized:=Not:C34($Boo_open)
PREFERENCES("w.palette.mini.set"; ->$Boo_minimized)

FORM SET HORIZONTAL RESIZING:C892($Boo_open)
FORM SET VERTICAL RESIZING:C893($Boo_open)
SET WINDOW RECT:C444($Lon_left; $Lon_top; $Lon_right; $Lon_top+$Lon_height; <>Win_palette)

OBJECT SET FORMAT:C236(*; OBJECT Get name:C1087(Object current:K67:2); ";#images/skins/lightGrey/"+Choose:C955($Boo_open; "mini"; "maxi")+".png")