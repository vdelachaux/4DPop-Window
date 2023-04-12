// ----------------------------------------------------
// Form method : COMMENTS
// Created 11/06/12 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
C_LONGINT:C283($eventCode; $Lon_wHandle)
C_TEXT:C284($Txt_path)

// ----------------------------------------------------
// Initialisations
$eventCode:=Form event code:C388

$Lon_wHandle:=Num:C11(Get window title:C450)
If (List item position:C629(<>Lst_windows; $Lon_wHandle)>0)
	
	GET LIST ITEM PARAMETER:C985(<>Lst_windows; $Lon_wHandle; "path"; $Txt_path)
	
End if 

// ----------------------------------------------------
Case of 
		//______________________________________________________
	: ($eventCode=On Load:K2:1)
		
		(OBJECT Get pointer:C1124(Object named:K67:5; "p.invisible"))->:=Num:C11(METHOD Get attribute:C1169($Txt_path; Attribute invisible:K72:6; *))
		(OBJECT Get pointer:C1124(Object named:K67:5; "p.shared"))->:=Num:C11(METHOD Get attribute:C1169($Txt_path; Attribute shared:K72:10; *))
		(OBJECT Get pointer:C1124(Object named:K67:5; "p.server"))->:=Num:C11(METHOD Get attribute:C1169($Txt_path; Attribute executed on server:K72:12; *))
		(OBJECT Get pointer:C1124(Object named:K67:5; "p.html"))->:=Num:C11(METHOD Get attribute:C1169($Txt_path; Attribute published Web:K72:7; *))
		(OBJECT Get pointer:C1124(Object named:K67:5; "p.soap"))->:=Num:C11(METHOD Get attribute:C1169($Txt_path; Attribute published SOAP:K72:8; *))
		(OBJECT Get pointer:C1124(Object named:K67:5; "p.wsdl"))->:=Num:C11(METHOD Get attribute:C1169($Txt_path; Attribute published WSDL:K72:9; *))
		(OBJECT Get pointer:C1124(Object named:K67:5; "p.sql"))->:=Num:C11(METHOD Get attribute:C1169($Txt_path; Attribute published SQL:K72:11; *))
		
		SET TIMER:C645(-1)
		
		//______________________________________________________
	: ($eventCode=On Unload:K2:2)
		
		METHOD SET ATTRIBUTE:C1192($Txt_path; Attribute invisible:K72:6; ((OBJECT Get pointer:C1124(Object named:K67:5; "p.invisible"))->=1); *)
		METHOD SET ATTRIBUTE:C1192($Txt_path; Attribute shared:K72:10; ((OBJECT Get pointer:C1124(Object named:K67:5; "p.shared"))->=1); *)
		METHOD SET ATTRIBUTE:C1192($Txt_path; Attribute executed on server:K72:12; ((OBJECT Get pointer:C1124(Object named:K67:5; "p.server"))->=1); *)
		METHOD SET ATTRIBUTE:C1192($Txt_path; Attribute published Web:K72:7; ((OBJECT Get pointer:C1124(Object named:K67:5; "p.html"))->=1); *)
		METHOD SET ATTRIBUTE:C1192($Txt_path; Attribute published SOAP:K72:8; ((OBJECT Get pointer:C1124(Object named:K67:5; "p.soap"))->=1); *)
		METHOD SET ATTRIBUTE:C1192($Txt_path; Attribute published WSDL:K72:9; ((OBJECT Get pointer:C1124(Object named:K67:5; "p.wsdl"))->=1); *)
		METHOD SET ATTRIBUTE:C1192($Txt_path; Attribute published SQL:K72:11; ((OBJECT Get pointer:C1124(Object named:K67:5; "p.sql"))->=1); *)
		
		//______________________________________________________
	: ($eventCode=On Timer:K2:25)
		SET TIMER:C645(0)
		
		OBJECT SET ENABLED:C1123(*; "p.wsdl"; (OBJECT Get pointer:C1124(Object named:K67:5; "p.soap"))->=1)
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily")
		
		//______________________________________________________
End case 