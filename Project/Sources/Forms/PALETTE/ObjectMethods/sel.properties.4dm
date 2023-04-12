C_LONGINT:C283($bottom; $height; $left; $right; $Lon_sBottom; $Lon_sLeft)
C_LONGINT:C283($Lon_sRight; $Lon_sTop; $top; $Lon_type; $Lon_wbottom; $Lon_width)
C_LONGINT:C283($Lon_wleft; $Lon_wright; $Lon_wtop; $Win_hdl)

GET WINDOW RECT:C443($Lon_wleft; $Lon_wtop; $Lon_wright; $Lon_wbottom; <>Win_palette)
$Lon_width:=$Lon_wright-$Lon_wleft
$height:=$Lon_wbottom-$Lon_wtop

$Win_hdl:=Choose:C955($height=24; Frontmost window:C447; Selected list items:C379(<>Lst_windows; *))

GET LIST ITEM PARAMETER:C985(<>Lst_windows; $Win_hdl; "type"; $Lon_type)

If ($Lon_type=Path project method:K72:1)
	
	OBJECT GET COORDINATES:C663(*; OBJECT Get name:C1087(Object current:K67:2); $left; $top; $right; $bottom)
	FORM GET PROPERTIES:C674("PROPERTIES"; $Lon_width; $height)
	
	$left:=$left+$Lon_wleft
	$top:=$Lon_wtop+$bottom
	$right:=$left+$Lon_width
	$bottom:=$top+$height
	
	SCREEN COORDINATES:C438($Lon_sLeft; $Lon_sTop; $Lon_sRight; $Lon_sBottom)
	
	$left:=Choose:C955($right>$Lon_sRight; $left-($right-$Lon_sRight)-2; $left)
	$right:=$left+$Lon_width
	
	$top:=Choose:C955($bottom>$Lon_sBottom; $top-($bottom-$Lon_sBottom)-2; $top)
	$bottom:=$top+$height
	
	$Win_hdl:=Open window:C153($left; $top; $right; $bottom; Pop up window:K34:14; String:C10($Win_hdl); "")
	DIALOG:C40("PROPERTIES")
	CLOSE WINDOW:C154
	
End if 