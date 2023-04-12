//%attributes = {}
var $windowCount : Integer

ARRAY LONGINT:C221($windowReferences; 0)

WINDOW LIST:C442($windowReferences)

$windowCount:=Size of array:C274($windowReferences)

If ($windowCount=0)
	
	return 
	
End if 