property preferences : cs:C1710.pop.Preferences
property database : cs:C1710.pop.database
property env : cs:C1710.pop.env
property motor : cs:C1710.pop.motor

Class constructor
	
	// Mark:Delegates 📦
	
	//FIXME: Turn around
	//This.database:=cs.pop.database.new()
	//This.preferences:=cs.pop.Preferences.new("PopWindows")
	//This.env:=cs.pop.env.new(True)
	//This.motor:=cs.pop.motor.new()
	This:C1470.database:=pop.database.new()
	This:C1470.preferences:=pop.Preferences.new("PopWindows")
	This:C1470.env:=pop.env.new(True:C214)
	This:C1470.motor:=pop.motor.new()
	
	// MARK: Default values
	This:C1470.preferences.default(New object:C1471(\
		"default"; "Next"; \
		"options"; 0; \
		"palette"; Null:C1517; \
		"paletteMini"; False:C215))
	
	This:C1470.screenWidth:=This:C1470.env.mainScreen.dimensions.width-10
	This:C1470.screenHeight:=This:C1470.env.mainScreen.dimensions.height-10
	This:C1470.explorer:=Replace string:C233(Get localized string:C991("Explorer"); "{project}"; This:C1470.database.name)
	This:C1470.hOffset:=10
	This:C1470.vOffset:=20
	
	var $name : Text
	var $mode; $origin; $process; $state; $time; $uid : Integer
	
	For ($process; 1; Count tasks:C335; 1)
		
		PROCESS PROPERTIES:C336($process; $name; $state; $time; $mode; $uid; $origin)
		
		If ($origin=Design process:K36:9)
			
			This:C1470.designProcess:=$process
			break
			
		End if 
	End for 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function stack()
	
	var $t : Text
	var $b : Boolean
	var $bottom; $horizontalOffset; $i; $l; $left : Integer
	var $number; $origin; $right; $top : Integer
	var $verticalOffset; $winExplorer : Integer
	
	ARRAY LONGINT:C221($windowRefs; 0)
	WINDOW LIST:C442($windowRefs)
	
	$number:=Size of array:C274($windowRefs)
	
	// Is the browser open?
	For ($i; 1; $number; 1)
		
		If (Get window title:C450($windowRefs{$i})=This:C1470.explorer)
			
			$winExplorer:=$windowRefs{$i}
			GET WINDOW RECT:C443($left; $top; $right; $bottom; $windowRefs{$i})
			
			break
			
		End if 
	End for 
	
	$horizontalOffset:=This:C1470.hOffset+(($right-$left)*Num:C11($winExplorer#0))
	
	For ($i; $number; 1; -1)
		
		PROCESS PROPERTIES:C336(Window process:C446($windowRefs{$i}); $t; $l; $l; $b; $l; $origin)
		
		If ($origin<0)\
			 && ($windowRefs{$i}#$winExplorer)
			
			GET WINDOW RECT:C443($left; $top; $right; $bottom; $windowRefs{$i})
			$right:=$horizontalOffset+($right-$left)
			
			If ($right>This:C1470.screenWidth)
				
				$right:=This:C1470.screenWidth
				
			End if 
			
			$bottom:=$verticalOffset+($bottom-$top)
			
			If ($bottom>This:C1470.screenHeight)
				
				$bottom:=This:C1470.screenHeight
				
			End if 
			
			$left:=$horizontalOffset
			$top:=$verticalOffset
			SET WINDOW RECT:C444($left; $top; $right; $bottom; $windowRefs{$i})
			SHOW WINDOW:C435($windowRefs{$i})
			$horizontalOffset:=$horizontalOffset+This:C1470.hOffset
			$verticalOffset:=$verticalOffset+This:C1470.vOffset
			
		End if 
	End for 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function bringToFront($winRef : Integer)
	
	var $bottom; $left; $right; $top : Integer
	
	GET WINDOW RECT:C443($left; $top; $right; $bottom; $winRef)
	
	// Move and resize if out of screen
	If ($right>This:C1470.screenWidth)\
		 | ($bottom>This:C1470.screenHeight)
		
		$right:=This:C1470.hOffset+($right-$left)
		
		If ($right>This:C1470.screenWidth)
			
			$right:=This:C1470.screenWidth
			
		End if 
		
		$bottom:=This:C1470.vOffset+($bottom-$top)
		
		If ($bottom>This:C1470.screenHeight)
			
			$bottom:=This:C1470.screenHeight
			
		End if 
		
		$left:=This:C1470.hOffset
		$top:=This:C1470.vOffset
		
	End if 
	
	// Set as frontmost
	SET WINDOW RECT:C444($left; $top; $right; $bottom; $winRef)
	SHOW WINDOW:C435($winRef)