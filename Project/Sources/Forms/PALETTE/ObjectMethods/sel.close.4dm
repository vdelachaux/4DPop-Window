C_BOOLEAN:C305($Boo_; $Boo_expanded)
C_LONGINT:C283($Lon_; $Lon_bottom; $Lon_i; $Lon_j; $Lon_left; $Lon_origin)
C_LONGINT:C283($Lon_process; $Lon_right; $Lon_top; $Lst_opened; $Win_hdl)
C_TEXT:C284($Txt_buffer; $Txt_processName)

$Win_hdl:=Selected list items:C379(<>Lst_windows; *)

Case of 
		
		//______________________________________________________
	: ($Win_hdl<0)  //close all
		
		For ($Lon_i; 1; Count tasks:C335; 1)
			
			PROCESS PROPERTIES:C336($Lon_i; $Txt_processName; $Lon_; $Lon_; $Boo_; $Lon_; $Lon_origin)
			
			If ($Lon_origin=Design process:K36:9)
				
				$Lon_process:=$Lon_i
				$Lon_j:=MAXLONG:K35:2-1
				
			End if 
		End for 
		
		GET LIST ITEM:C378(<>Lst_windows; *; $Win_hdl; $Txt_buffer; $Lst_opened; $Boo_expanded)
		
		Repeat 
			
			GET LIST ITEM:C378($Lst_opened; 1; $Win_hdl; $Txt_buffer)
			
			GET WINDOW RECT:C443($Lon_left; $Lon_top; $Lon_right; $Lon_bottom; $Win_hdl)
			SET WINDOW RECT:C444($Lon_left; $Lon_top; $Lon_right; $Lon_bottom; $Win_hdl)
			
			POST KEY:C465(Character code:C91("w"); 0 ?+ Command key bit:K16:2; $Lon_process)
			DELAY PROCESS:C323(Current process:C322; 10)
			
		Until (Count list items:C380($Lst_opened)=0)
		
		//______________________________________________________
	: ($Win_hdl>0)  //close selected
		
		GET WINDOW RECT:C443($Lon_left; $Lon_top; $Lon_right; $Lon_bottom; $Win_hdl)
		SET WINDOW RECT:C444($Lon_left; $Lon_top; $Lon_right; $Lon_bottom; $Win_hdl)
		
		For ($Lon_i; 1; Count tasks:C335; 1)
			
			PROCESS PROPERTIES:C336($Lon_i; $Txt_processName; $Lon_; $Lon_; $Boo_; $Lon_; $Lon_origin)
			
			If ($Lon_origin=Design process:K36:9)
				
				POST KEY:C465(Character code:C91("w"); 0 ?+ Command key bit:K16:2; $Lon_i)
				
				$Lon_i:=MAXLONG:K35:2-1
				
			End if 
		End for 
		
		//______________________________________________________
	Else 
		
		TRACE:C157
		
		//______________________________________________________
End case 