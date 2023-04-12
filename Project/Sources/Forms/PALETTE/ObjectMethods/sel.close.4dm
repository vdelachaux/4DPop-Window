C_BOOLEAN:C305($Boo_; $Boo_expanded)
C_LONGINT:C283($Lon_; $bottom; $i; $Lon_j; $left; $origin)
C_LONGINT:C283($Lon_process; $right; $top; $Lst_opened; $Win_hdl)
C_TEXT:C284($Txt_buffer; $Txt_processName)

$Win_hdl:=Selected list items:C379(<>Lst_windows; *)

Case of 
		
		//______________________________________________________
	: ($Win_hdl<0)  //close all
		
		For ($i; 1; Count tasks:C335; 1)
			
			PROCESS PROPERTIES:C336($i; $Txt_processName; $Lon_; $Lon_; $Boo_; $Lon_; $origin)
			
			If ($origin=Design process:K36:9)
				
				$Lon_process:=$i
				$Lon_j:=MAXLONG:K35:2-1
				
			End if 
		End for 
		
		GET LIST ITEM:C378(<>Lst_windows; *; $Win_hdl; $Txt_buffer; $Lst_opened; $Boo_expanded)
		
		Repeat 
			
			GET LIST ITEM:C378($Lst_opened; 1; $Win_hdl; $Txt_buffer)
			
			GET WINDOW RECT:C443($left; $top; $right; $bottom; $Win_hdl)
			SET WINDOW RECT:C444($left; $top; $right; $bottom; $Win_hdl)
			
			POST KEY:C465(Character code:C91("w"); 0 ?+ Command key bit:K16:2; $Lon_process)
			DELAY PROCESS:C323(Current process:C322; 10)
			
		Until (Count list items:C380($Lst_opened)=0)
		
		//______________________________________________________
	: ($Win_hdl>0)  //close selected
		
		GET WINDOW RECT:C443($left; $top; $right; $bottom; $Win_hdl)
		SET WINDOW RECT:C444($left; $top; $right; $bottom; $Win_hdl)
		
		For ($i; 1; Count tasks:C335; 1)
			
			PROCESS PROPERTIES:C336($i; $Txt_processName; $Lon_; $Lon_; $Boo_; $Lon_; $origin)
			
			If ($origin=Design process:K36:9)
				
				POST KEY:C465(Character code:C91("w"); 0 ?+ Command key bit:K16:2; $i)
				
				$i:=MAXLONG:K35:2-1
				
			End if 
		End for 
		
		//______________________________________________________
	Else 
		
		TRACE:C157
		
		//______________________________________________________
End case 