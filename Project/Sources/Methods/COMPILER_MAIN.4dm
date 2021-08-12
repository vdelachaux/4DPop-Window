//%attributes = {"invisible":true}
C_LONGINT:C283($0)
C_LONGINT:C283($0)
C_LONGINT:C283($0)
C_LONGINT:C283($1)
C_LONGINT:C283($1)
C_LONGINT:C283($1)
C_POINTER:C301(${2})

C_TEXT:C284($Txt_language)

If (False:C215)
	C_LONGINT:C283(COMPILER_MAIN; $0)
	C_LONGINT:C283(COMPILER_MAIN; $0)
	C_LONGINT:C283(COMPILER_MAIN; $0)
	C_LONGINT:C283(COMPILER_MAIN; $1)
	C_LONGINT:C283(COMPILER_MAIN; $1)
	C_LONGINT:C283(COMPILER_MAIN; $1)
	C_POINTER:C301(COMPILER_MAIN; ${2})
End if 

C_BOOLEAN:C305(<>Boo_inited)

If (Not:C34(<>Boo_inited))
	
	C_LONGINT:C283(<>Lon_options)
	
	C_LONGINT:C283(<>Win_palette)
	C_LONGINT:C283(<>Lst_windows)
	C_LONGINT:C283(<>Lst_wHidden)
	
	C_TEXT:C284(<>Txt_digest)
	
	<>Boo_inited:=True:C214
	
	//SET DATABASE LOCALIZATION(4DPop_applicationLanguage ;*)
	
	<>Lst_wHidden:=New list:C375
	
	PREFERENCES("options.get"; -><>Lon_options)
	
	SET ASSERT ENABLED:C1131(Structure file:C489=Structure file:C489(*); *)
	
	ARRAY TEXT:C222($tTxt_Components; 0x0000)
	COMPONENT LIST:C1001($tTxt_Components)
	If (Find in array:C230($tTxt_Components; "4DPop")>0)
		
		EXECUTE METHOD:C1007("4DPop_applicationLanguage"; $Txt_language)
		SET DATABASE LOCALIZATION:C1104($Txt_language; *)
		
	End if 
End if 

If (False:C215)  //shared
	
	C_POINTER:C301(4DPopWindow_init)
	
	C_TEXT:C284(4DPopWindow_macroOnOpen)
	
	C_TEXT:C284(4DPopWindow_macroOnClose)
	
	C_POINTER:C301(Tool_Menu)
	
	C_POINTER:C301(Tool_Default)
	
	C_TEXT:C284(4DPopWindow_path)
	C_TEXT:C284(4DPopWindow_path)
	
End if 

If (False:C215)
	
	C_POINTER:C301(ptr_table)
	C_TEXT:C284(ptr_table)
	
	C_TEXT:C284(env_POST_KEY)
	
	C_LONGINT:C283(env_ToolBar_Height)
	
	C_TEXT:C284(mnu_RELEASE_MENU)
	
	C_TEXT:C284(PREFERENCES)
	C_POINTER:C301(PREFERENCES)
	
	C_LONGINT:C283(TOOL_WINDOWS)
	
	C_TEXT:C284(methodGetPath)
	C_TEXT:C284(methodGetPath)
	C_LONGINT:C283(methodGetPath)
	
	C_LONGINT:C283(option_SET)
	C_LONGINT:C283(option_SET)
	
	C_TEXT:C284(tool_renameWindows)
	
	C_TEXT:C284(Palette_ADD_ELEMENT)
	C_LONGINT:C283(Palette_ADD_ELEMENT)
	
	C_LONGINT:C283(Palette_ADD_WINDOW)
	
	C_TEXT:C284(Palette_MENU)
	
	C_TEXT:C284(Palette_RUN)
	
	C_TEXT:C284(WINDOW_ACTION)
	C_LONGINT:C283(WINDOW_ACTION)
	
End if 