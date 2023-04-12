//%attributes = {"invisible":true}
// ----------------------------------------------------
// Method : TOOL_WINDOWS
// Alias : zFF_RANGER_FENETRES
// Created le 9/06/00 by Vincent de Lachaux
// ----------------------------------------------------
// Modified by vdl (31/05/07)
// V11 Component
// ----------------------------------------------------
#DECLARE($winRef : Integer)

If (False:C215)
	C_LONGINT:C283(TOOL_WINDOWS; $1)
End if 

var $explorer; $t : Text
var $b; $withExplorer : Boolean
var $bottom; $hOffset; $horizontalOffset; $i; $l; $left : Integer
var $number; $origin; $right; $screenHight; $screenWidth; $top : Integer
var $verticalOffset; $vOffset : Integer

ARRAY LONGINT:C221($windowRefs; 0)

$screenWidth:=Screen width:C187-10
$screenHight:=Screen height:C188-10
$explorer:=Get indexed string:C510(1030; 1)
$hOffset:=10
$vOffset:=20

$verticalOffset:=26+Menu bar height:C440+60  // Hauteur barre outils

If ($winRef=0)
	
	// Stack windows
	WINDOW LIST:C442($windowRefs)
	$number:=Size of array:C274($windowRefs)
	
	For ($i; 1; $number; 1)
		
		If (Get window title:C450($windowRefs{$i})=$explorer)
			
			GET WINDOW RECT:C443($left; $top; $right; $bottom; $windowRefs{$i})
			$withExplorer:=True:C214
			break
			
		End if 
	End for 
	
	$horizontalOffset:=$hOffset+(($right-$left)*Num:C11($withExplorer))
	
	For ($i; $number; 1; -1)
		
		PROCESS PROPERTIES:C336(Window process:C446($windowRefs{$i}); $t; $l; $l; $b; $l; $origin)
		
		If ($origin<0)
			
			If (Get window title:C450($windowRefs{$i})#$explorer)
				
				GET WINDOW RECT:C443($left; $top; $right; $bottom; $windowRefs{$i})
				$right:=$horizontalOffset+($right-$left)
				
				If ($right>$screenWidth)
					
					$right:=$screenWidth
					
				End if 
				
				$bottom:=$verticalOffset+($bottom-$top)
				
				If ($bottom>$screenHight)
					
					$bottom:=$screenHight
					
				End if 
				
				$left:=$horizontalOffset
				$top:=$verticalOffset
				SET WINDOW RECT:C444($left; $top; $right; $bottom; $windowRefs{$i})
				SHOW WINDOW:C435($windowRefs{$i})
				$horizontalOffset:=$horizontalOffset+$hOffset
				$verticalOffset:=$verticalOffset+$vOffset
				
			End if 
		End if 
	End for 
	
Else 
	
	GET WINDOW RECT:C443($left; $top; $right; $bottom; $winRef)
	
	// Move and resize if out of screen
	If ($right>$screenWidth)\
		 | ($bottom>$screenHight)
		
		$horizontalOffset:=$hOffset
		$right:=$horizontalOffset+($right-$left)
		
		If ($right>$screenWidth)
			
			$right:=$screenWidth
			
		End if 
		
		$bottom:=$verticalOffset+($bottom-$top)
		
		If ($bottom>$screenHight)
			
			$bottom:=$screenHight
			
		End if 
		
		$left:=$horizontalOffset
		$top:=$verticalOffset
		
	End if 
	
	// Set as frontmost
	SET WINDOW RECT:C444($left; $top; $right; $bottom; $winRef)
	SHOW WINDOW:C435($winRef)
	
End if 