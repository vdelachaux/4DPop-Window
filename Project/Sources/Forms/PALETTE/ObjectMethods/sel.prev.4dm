C_LONGINT:C283($Lon_bottom; $Lon_end; $Lon_left; $Lon_right; $Lon_top; $Lon_x)
C_LONGINT:C283($Win_hdl)
C_TEXT:C284($Txt_)

$Lon_x:=Selected list items:C379(<>Lst_windows)
$Lon_end:=Count list items:C380(<>Lst_windows)

If ($Lon_x=0)
	
	$Lon_x:=List item position:C629(<>Lst_windows; Frontmost window:C447)
	
	If ($Lon_x=0)
		
		$Lon_x:=$Lon_end
		
	End if 
End if 

Repeat 
	
	$Lon_x:=Choose:C955($Lon_x=1; $Lon_end; $Lon_x-1)
	GET LIST ITEM:C378(<>Lst_windows; $Lon_x; $Win_hdl; $Txt_)
	
Until ($Win_hdl>0)

GET WINDOW RECT:C443($Lon_left; $Lon_top; $Lon_right; $Lon_bottom; $Win_hdl)
SET WINDOW RECT:C444($Lon_left; $Lon_top; $Lon_right; $Lon_bottom; $Win_hdl)

SELECT LIST ITEMS BY REFERENCE:C630(<>Lst_windows; $Win_hdl)