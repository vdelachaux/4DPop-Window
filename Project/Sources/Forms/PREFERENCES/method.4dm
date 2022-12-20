// ----------------------------------------------------
// Form method : Preferences
// Created 08/06/12 by Vincent de Lachaux
// ----------------------------------------------------
// Declarations
C_LONGINT:C283($Lon_formEvent)
C_TEXT:C284($Txt_defaultAction)

// ----------------------------------------------------
// Initialisations
$Lon_formEvent:=Form event code:C388

// ----------------------------------------------------
Case of 
		//______________________________________________________
	: ($Lon_formEvent=On Load:K2:1)
		
		(OBJECT Get pointer:C1124(Object named:K67:5; "button.menu"))->:=Num:C11(Not:C34(<>Lon_options ?? 1))
		(OBJECT Get pointer:C1124(Object named:K67:5; "option.palette"))->:=Num:C11(<>Lon_options ?? 2)
		(OBJECT Get pointer:C1124(Object named:K67:5; "option.prefix"))->:=Num:C11(<>Lon_options ?? 3)
		
		PREFERENCES("default.get"; ->$Txt_defaultAction)
		(OBJECT Get pointer:C1124(Object named:K67:5; "default."+$Txt_defaultAction))->:=1
		
		SET TIMER:C645(-1)
		
		//______________________________________________________
	: ($Lon_formEvent=On Unload:K2:2)
		
		//______________________________________________________
	: ($Lon_formEvent=On Validate:K2:3)
		
		option_SET(1; (OBJECT Get pointer:C1124(Object named:K67:5; "button.menu"))->)
		option_SET(2; (OBJECT Get pointer:C1124(Object named:K67:5; "option.palette"))->)
		option_SET(3; (OBJECT Get pointer:C1124(Object named:K67:5; "option.prefix"))->)
		PREFERENCES("options.set"; -><>Lon_options)
		
		$Txt_defaultAction:=Choose:C955((OBJECT Get pointer:C1124(Object named:K67:5; "default.Next"))->=1; "Next"; "Stack")
		PREFERENCES("default.set"; ->$Txt_defaultAction)
		
		//______________________________________________________
	: ($Lon_formEvent=On Timer:K2:25)
		SET TIMER:C645(0)
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215; "Form event activated unnecessarily")
		
		//______________________________________________________
End case 