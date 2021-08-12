//%attributes = {"invisible":true}
// ----------------------------------------------------
// Method : TOOL_WINDOWS
// Alias : zFF_RANGER_FENETRES
// Created le 9/06/00 by Vincent de Lachaux
// ----------------------------------------------------
// Modified by vdl (31/05/07)
// v11 Component
// ----------------------------------------------------
C_LONGINT:C283($1)

C_BOOLEAN:C305($Boo_; $Boo_explorer)
C_LONGINT:C283($kLon_hOffset; $kLon_vOffset; $Lon_; $Lon_bottom; $Lon_horizontalOffset; $Lon_i)
C_LONGINT:C283($Lon_left; $Lon_number; $Lon_origin; $Lon_parameters; $Lon_right; $Lon_screenHight)
C_LONGINT:C283($Lon_screenWidth; $Lon_top; $Lon_verticalOffset; $Win_hdl)
C_TEXT:C284($kTxt_explorer; $Txt_)

ARRAY LONGINT:C221($tWin_hdl; 0)

If (False:C215)
	C_LONGINT:C283(TOOL_WINDOWS; $1)
End if 

$Lon_parameters:=Count parameters:C259
$Lon_screenWidth:=Screen width:C187-10
$Lon_screenHight:=Screen height:C188-10
$kTxt_explorer:=Get indexed string:C510(1030; 1)
$kLon_hOffset:=10
$kLon_vOffset:=20

If ($Lon_parameters>=1)
	
	$Win_hdl:=$1
	
End if 

$Lon_verticalOffset:=26+Menu bar height:C440+60  //Hauteur barre outils

If ($Win_hdl=0)
	
	//Stack windows
	WINDOW LIST:C442($tWin_hdl)
	$Lon_number:=Size of array:C274($tWin_hdl)
	
	For ($Lon_i; 1; $Lon_number; 1)
		
		If (Get window title:C450($tWin_hdl{$Lon_i})=$kTxt_explorer)
			
			GET WINDOW RECT:C443($Lon_left; $Lon_top; $Lon_right; $Lon_bottom; $tWin_hdl{$Lon_i})
			$Boo_explorer:=True:C214
			$Lon_i:=MAXLONG:K35:2-1
			
		End if 
	End for 
	
	$Lon_horizontalOffset:=$kLon_hOffset+(($Lon_right-$Lon_left)*Num:C11($Boo_explorer))
	
	For ($Lon_i; $Lon_number; 1; -1)
		
		PROCESS PROPERTIES:C336(Window process:C446($tWin_hdl{$Lon_i}); $Txt_; $Lon_; $Lon_; $Boo_; $Lon_; $Lon_origin)
		
		If ($Lon_origin<0)
			
			If (Get window title:C450($tWin_hdl{$Lon_i})#$kTxt_explorer)
				
				GET WINDOW RECT:C443($Lon_left; $Lon_top; $Lon_right; $Lon_bottom; $tWin_hdl{$Lon_i})
				$Lon_right:=$Lon_horizontalOffset+($Lon_right-$Lon_left)
				
				If ($Lon_right>$Lon_screenWidth)
					
					$Lon_right:=$Lon_screenWidth
					
				End if 
				
				$Lon_bottom:=$Lon_verticalOffset+($Lon_bottom-$Lon_top)
				
				If ($Lon_bottom>$Lon_screenHight)
					
					$Lon_bottom:=$Lon_screenHight
					
				End if 
				
				$Lon_left:=$Lon_horizontalOffset
				$Lon_top:=$Lon_verticalOffset
				SET WINDOW RECT:C444($Lon_left; $Lon_top; $Lon_right; $Lon_bottom; $tWin_hdl{$Lon_i})
				SHOW WINDOW:C435($tWin_hdl{$Lon_i})
				$Lon_horizontalOffset:=$Lon_horizontalOffset+$kLon_hOffset
				$Lon_verticalOffset:=$Lon_verticalOffset+$kLon_vOffset
				
			End if 
		End if 
	End for 
	
Else 
	
	GET WINDOW RECT:C443($Lon_left; $Lon_top; $Lon_right; $Lon_bottom; $Win_hdl)
	
	//Move and resize if out of screen
	If ($Lon_right>$Lon_screenWidth)\
		 | ($Lon_bottom>$Lon_screenHight)
		
		$Lon_horizontalOffset:=$kLon_hOffset
		$Lon_right:=$Lon_horizontalOffset+($Lon_right-$Lon_left)
		
		If ($Lon_right>$Lon_screenWidth)
			
			$Lon_right:=$Lon_screenWidth
			
		End if 
		
		$Lon_bottom:=$Lon_verticalOffset+($Lon_bottom-$Lon_top)
		
		If ($Lon_bottom>$Lon_screenHight)
			
			$Lon_bottom:=$Lon_screenHight
			
		End if 
		
		$Lon_left:=$Lon_horizontalOffset
		$Lon_top:=$Lon_verticalOffset
		
	End if 
	
	//Set as frontmost
	SET WINDOW RECT:C444($Lon_left; $Lon_top; $Lon_right; $Lon_bottom; $Win_hdl)
	SHOW WINDOW:C435($Win_hdl)
	
End if 