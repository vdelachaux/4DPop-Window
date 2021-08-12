//%attributes = {}
//C_BLOB($Blb_buffer)
//C_TEXT($Dom_root;$Txt_4D;$Txt_buffer;$Txt_MD5;$Txt_root;$Txt_SHA1)

//$Txt_root:=4DPop_preferenceLoad ("PopWindows")
//$Dom_root:=DOM Parse XML variable($Txt_root)

//If (OK=1)

//DOM EXPORT TO VAR($Dom_root;$Txt_buffer)
//DOM CLOSE XML($Dom_root)

//$Txt_buffer:=Replace string($Txt_buffer;" ";"  ")

//While (Position("  ";$Txt_buffer)>0)

//$Txt_buffer:=Replace string($Txt_buffer;"  ";" ")

//End while 
//End if 

//$Txt_buffer:="Hello world"

//$Txt_4D:=Generate digest($Txt_buffer;4D digest)
//$Txt_MD5:=Generate digest($Txt_buffer;MD5 digest)
//$Txt_SHA1:=Generate digest($Txt_buffer;SHA1 digest)

//CONVERT FROM TEXT($Txt_buffer;"utf-8";$Blb_buffer)

//$Txt_MD5:=Generate digest($Blb_buffer;MD5 digest)
//$Txt_SHA1:=Generate digest($Blb_buffer;SHA1 digest)
//$Txt_4D:=Generate digest($Blb_buffer;4D digest)



