C_LONGINT:C283($bottom; $Lon_end; $left; $right; $top; $Lon_x)
C_LONGINT:C283($Win_hdl)
C_TEXT:C284($Txt_)

$Lon_x:=Selected list items:C379(<>Lst_windows)
$Lon_end:=Count list items:C380(<>Lst_windows)

If ($Lon_x=0)
	
	$Lon_x:=List item position:C629(<>Lst_windows; Frontmost window:C447)
	
	If ($Lon_x=0)
		
		$Lon_x:=1
		
	End if 
End if 

Repeat 
	
	$Lon_x:=Choose:C955($Lon_x=$Lon_end; 1; $Lon_x+1)
	GET LIST ITEM:C378(<>Lst_windows; $Lon_x; $Win_hdl; $Txt_)
	
Until ($Win_hdl>0)

GET WINDOW RECT:C443($left; $top; $right; $bottom; $Win_hdl)
SET WINDOW RECT:C444($left; $top; $right; $bottom; $Win_hdl)

SELECT LIST ITEMS BY REFERENCE:C630(<>Lst_windows; $Win_hdl)