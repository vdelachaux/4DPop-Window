//%attributes = {"invisible":true}
#DECLARE($table : Text) : Pointer

If (False:C215)
	C_TEXT:C284(tablePointer; $1)
	C_POINTER:C301(tablePointer; $0)
End if 

var $i : Integer

$table:=Replace string:C233($table; "["; "")
$table:=Replace string:C233($table; "]"; "")

For ($i; 1; Get last table number:C254; 1)
	
	If (Is table number valid:C999($i))\
		 && (Table name:C256($i)=$table)
		
		return Table:C252($i)
		
	End if 
End for 