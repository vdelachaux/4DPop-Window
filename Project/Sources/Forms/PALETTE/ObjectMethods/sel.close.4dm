var $winRef : Integer:=Selected list items:C379(<>Lst_windows; *)

Case of 
		
		// ______________________________________________________
	: ($winRef<0)  // Close all
		
		var $i : Integer
		
		For ($i; 1; Count tasks:C335; 1)
			
			If (Process info:C1843(Window process:C446($i)).type=Design process:K36:9)
				
				var $process:=$i
				
				break
				
			End if 
		End for 
		
		var $t : Text
		var $sublist : Integer
		var $expanded : Boolean
		GET LIST ITEM:C378(<>Lst_windows; *; $winRef; $t; $sublist; $expanded)
		
		Repeat 
			
			GET LIST ITEM:C378($sublist; 1; $winRef; $t)
			
			var $left; $top; $right; $bottom : Integer
			GET WINDOW RECT:C443($left; $top; $right; $bottom; $winRef)
			SET WINDOW RECT:C444($left; $top; $right; $bottom; $winRef)
			
			POST KEY:C465(Character code:C91("w"); 0 ?+ Command key bit:K16:2; $process)
			DELAY PROCESS:C323(Current process:C322; 10)
			
		Until (Count list items:C380($sublist)=0)
		
		// ______________________________________________________
	: ($winRef>0)  // Close selected
		
		GET WINDOW RECT:C443($left; $top; $right; $bottom; $winRef)
		SET WINDOW RECT:C444($left; $top; $right; $bottom; $winRef)
		
		For ($i; 1; Count tasks:C335; 1)
			
			If (Process info:C1843(Window process:C446($i)).type=Design process:K36:9)
				
				POST KEY:C465(Character code:C91("w"); 0 ?+ Command key bit:K16:2; $i)
				
				break
				
			End if 
		End for 
		
		// ______________________________________________________
	Else 
		
		TRACE:C157
		
		// ______________________________________________________
End case 