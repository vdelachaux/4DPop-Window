//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : option_SET
// ID[B44A9FC75AD847D194552689410BDB43]
// Created 15/06/12 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
C_LONGINT:C283($1)
C_LONGINT:C283($2)

C_LONGINT:C283($Lon_bit; $Lon_parameters; $Lon_value)

If (False:C215)
	C_LONGINT:C283(option_SET; $1)
	C_LONGINT:C283(option_SET; $2)
End if 

// ----------------------------------------------------
// Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1; "Missing parameter"))
	
	$Lon_bit:=$1
	
	If ($Lon_parameters>=2)
		
		$Lon_value:=$2
		
	End if 
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------

If ($Lon_value=0)
	
	//uncheck
	<>Lon_options:=<>Lon_options ?- $Lon_bit
	
Else 
	
	//check
	<>Lon_options:=<>Lon_options ?+ $Lon_bit
	
End if 

// ----------------------------------------------------
// End