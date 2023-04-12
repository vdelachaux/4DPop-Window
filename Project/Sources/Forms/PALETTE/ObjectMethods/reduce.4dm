var $isOpen : Boolean
var $bottom; $height; $left; $right; $top : Integer

GET WINDOW RECT:C443($left; $top; $right; $bottom; <>Win_palette)
$height:=$bottom-$top
$isOpen:=($height=24)

If ($isOpen)
	
	$height:=(OBJECT Get pointer:C1124(Object named:K67:5; "hight_opened"))->
	RESIZE FORM WINDOW:C890($right-$left; $height)
	OBJECT SET COORDINATES:C1248(*; "main.@"; 0; 25; $right-$left; $height)
	
Else 
	
	(OBJECT Get pointer:C1124(Object named:K67:5; "hight_opened"))->:=$height
	$height:=24
	
End if 

component.preferences.set("paletteMini"; Not:C34($isOpen))

FORM SET HORIZONTAL RESIZING:C892($isOpen)
FORM SET VERTICAL RESIZING:C893($isOpen)
SET WINDOW RECT:C444($left; $top; $right; $top+$height; <>Win_palette)

OBJECT SET FORMAT:C236(*; OBJECT Get name:C1087(Object current:K67:2); ";#images/skins/lightGrey/"+Choose:C955($isOpen; "mini"; "maxi")+".png")