C_LONGINT:C283($Lon_bottom; $Lon_height; $Lon_left; $Lon_right; $Lon_sBottom; $Lon_sLeft)
C_LONGINT:C283($Lon_sRight; $Lon_sTop; $Lon_top; $Lon_type; $Lon_wbottom; $Lon_width)
C_LONGINT:C283($Lon_wleft; $Lon_wright; $Lon_wtop; $Win_hdl)

GET WINDOW RECT:C443($Lon_wleft; $Lon_wtop; $Lon_wright; $Lon_wbottom; <>Win_palette)
$Lon_width:=$Lon_wright-$Lon_wleft
$Lon_height:=$Lon_wbottom-$Lon_wtop

$Win_hdl:=Choose:C955($Lon_height=24; Frontmost window:C447; Selected list items:C379(<>Lst_windows; *))

GET LIST ITEM PARAMETER:C985(<>Lst_windows; $Win_hdl; "type"; $Lon_type)

If ($Lon_type=Path project method:K72:1)
	
	OBJECT GET COORDINATES:C663(*; OBJECT Get name:C1087(Object current:K67:2); $Lon_left; $Lon_top; $Lon_right; $Lon_bottom)
	FORM GET PROPERTIES:C674("PROPERTIES"; $Lon_width; $Lon_height)
	
	$Lon_left:=$Lon_left+$Lon_wleft
	$Lon_top:=$Lon_wtop+$Lon_bottom
	$Lon_right:=$Lon_left+$Lon_width
	$Lon_bottom:=$Lon_top+$Lon_height
	
	SCREEN COORDINATES:C438($Lon_sLeft; $Lon_sTop; $Lon_sRight; $Lon_sBottom)
	
	$Lon_left:=Choose:C955($Lon_right>$Lon_sRight; $Lon_left-($Lon_right-$Lon_sRight)-2; $Lon_left)
	$Lon_right:=$Lon_left+$Lon_width
	
	$Lon_top:=Choose:C955($Lon_bottom>$Lon_sBottom; $Lon_top-($Lon_bottom-$Lon_sBottom)-2; $Lon_top)
	$Lon_bottom:=$Lon_top+$Lon_height
	
	$Win_hdl:=Open window:C153($Lon_left; $Lon_top; $Lon_right; $Lon_bottom; Pop up window:K34:14; String:C10($Win_hdl); "")
	DIALOG:C40("PROPERTIES")
	CLOSE WINDOW:C154
	
End if 