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
	
	This:C1470.data:=JSON Parse:C1218(File:C1566("/RESOURCES/desc.json").getText())
	
	var $key : Text
	var $i : Integer
	var $o : Object
	var $c : Collection
	
	For each ($key; This:C1470.data)
		
		$o:=This:C1470.data[$key]
		
		If ($key="databaseMethod")
			
			For ($i; 0; $o.methods.length-1; 1)
				
				$o.methods[$i]:=String:C10(Formula from string:C1601(":C1578(\""+Delete string:C232($o.methods[$i]; 1; 1)+"\")").call())
				
			End for 
			
		Else 
			
			If ($o.name=".@")
				
				$o.name:=Delete string:C232($o.name; 1; 1)
				$c:=Split string:C1554($o.name; ";")
				$o.name:=String:C10(Formula from string:C1601(":C1578(\""+($c.length=2 ? ($c[0]+","+$c[1]) : $o.name)+"\")").call())
				
			Else 
				
				$o.name:=Get localized string:C991($key)
				
			End if 
		End if 
	End for each 
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== 
Function get useSubmenu() : Boolean
	
	return This:C1470.preferences.get("options") ?? 1
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== 
Function get showPalette() : Boolean
	
	return This:C1470.preferences.get("options") ?? 2
	
	// <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== <== 
Function get prependWindowNames() : Boolean
	
	return This:C1470.preferences.get("options") ?? 3
	
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
Function next($winRef : Integer)
	
	This:C1470.bringToFront(Next window:C448($winRef))
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function bringToFront($winRef : Integer)
	
	var $bottom; $left; $right; $top : Integer
	
	GET WINDOW RECT:C443($left; $top; $right; $bottom; $winRef)
	
	//// Move and resize if out of screen
	//If ($right>This.screenWidth)\
				 | ($bottom>This.screenHeight)
	
	//$right:=This.hOffset+($right-$left)
	
	//If ($right>This.screenWidth)
	
	//$right:=This.screenWidth
	
	//End if 
	
	//$bottom:=This.vOffset+($bottom-$top)
	
	//If ($bottom>This.screenHeight)
	
	//$bottom:=This.screenHeight
	
	//End if 
	
	//$left:=This.hOffset
	//$top:=This.vOffset
	
	//End if 
	
	// Set as frontmost
	SET WINDOW RECT:C444($left; $top; $right; $bottom; $winRef)
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function menu()
	
	var $formName; $key; $name : Text
	var $isOffScreen; $visible : Boolean
	var $bottom; $frontmostWindow; $i; $indx; $left; $origin : Integer
	var $right; $state; $time; $top; $UID; $windowNumber : Integer
	var $windowRef : Integer
	var $forms; $o; $window : Object
	var $c; $windows : Collection
	var $menu; $menuApplication; $menuClasses; $menudatabaseMethods; $menuFind; $menuForms; $menuMethods; $menuOthers; $menuTrigger : cs:C1710.menu
	
	ARRAY LONGINT:C221($windowReferences; 0)
	
	WINDOW LIST:C442($windowReferences)
	$windowNumber:=Size of array:C274($windowReferences)
	
	If ($windowNumber=0)
		
		return 
		
	End if 
	
	$windows:=New collection:C1472
	
	For ($i; 1; $windowNumber; 1)
		
		$o:=New object:C1471
		$o.ref:=$windowReferences{$i}
		$o.process:=Window process:C446($o.ref)
		$o.title:=Get window title:C450($o.ref)
		
		PROCESS PROPERTIES:C336($o.process; $name; $state; $time; $visible; $UID; $origin)
		$o.name:=$name
		$o.state:=$state
		$o.visible:=$visible
		$o.origin:=$origin
		
		$windows.push($o)
		
	End for 
	
	$frontmostWindow:=Frontmost window:C447
	
	GET WINDOW RECT:C443($left; $top; $right; $bottom; $frontmostWindow)
	
	If ($right<=(This:C1470.screenWidth))\
		 && ($bottom<=(This:C1470.screenHeight))
		
		$isOffScreen:=True:C214
		
	End if 
	
	$forms:=New object:C1471
	
	For each ($window; $windows.orderBy("origin asc,title asc"))
		
		$indx:=Position:C15(" - "; $window.title)
		$window.title:=$indx>0 ? Delete string:C232($window.title; 1; $indx+2) : $window.title
		
		If ($window.origin>0)
			
			$window.icon:=This:C1470.data.application.icon
			$window.family:="Application"
			
			$menuApplication:=$menuApplication || cs:C1710.menu.new()
			$menuApplication.append($window.title; $window.ref)\
				.icon($window.icon)\
				.setData("window"; $window)\
				.mark($window.ref=$frontmostWindow)
			
		Else 
			
			Case of 
					
					//______________________________________________________
				: (Position:C15(This:C1470.data.trigger.name; $window.title)=1)
					
					$o:=This:C1470.data.trigger
					$window.title:=Replace string:C233($window.title; $o.name; "")
					$window.icon:=$o.icon
					
					$menuTrigger:=$menuTrigger || cs:C1710.menu.new()
					$menuTrigger.append($window.title; $window.ref)\
						.icon($window.icon)\
						.setData("window"; $window)\
						.mark($window.ref=$frontmostWindow)
					
					//______________________________________________________
				: (Position:C15(This:C1470.data.method.name; $window.title)=1)
					
					$o:=This:C1470.data.method
					$window.title:=Replace string:C233($window.title; $o.name; "")
					$window.icon:=$o.icon
					
					$menuMethods:=$menuMethods || cs:C1710.menu.new()
					$menuMethods.append(Replace string:C233($window.title; $o.name; ""); $window.ref)\
						.icon($window.icon)\
						.setData("window"; $window)\
						.mark($window.ref=$frontmostWindow)
					
					//______________________________________________________
				: (Position:C15(This:C1470.data.class.name; $window.title)=1)
					
					$o:=This:C1470.data.class
					$window.title:=Replace string:C233($window.title; $o.name; "")
					$window.icon:=$o.icon
					
					$menuClasses:=$menuClasses || cs:C1710.menu.new()
					$menuClasses.append($window.title; $window.ref)\
						.icon($window.icon)\
						.setData("window"; $window)\
						.mark($window.ref=$frontmostWindow)
					
					//______________________________________________________
				: (Position:C15(This:C1470.data.form.name; $window.title)=1)
					
					$o:=This:C1470.data.form
					$window.title:=Replace string:C233($window.title; $o.name; "")
					$window.icon:=$o.icon
					
					$forms[$window.title]:=$forms[$window.title] || cs:C1710.menu.new()
					$forms[$window.title].append(Get localized string:C991("MenuLabelsForm"); $window.ref; 0)\
						.icon($o.icon)\
						.setData("window"; $window)\
						.mark($window.ref=$frontmostWindow)
					
					//______________________________________________________
				: (Position:C15(This:C1470.data.formMethod.name; $window.title)=1)
					
					$o:=This:C1470.data.formMethod
					$window.title:=Replace string:C233($window.title; $o.name; "")
					$window.icon:=$o.icon
					
					$forms[$window.title]:=$forms[$window.title] || cs:C1710.menu.new()
					$forms[$window.title].append(Get localized string:C991("MenuLabelsFormMethod"); $window.ref)\
						.icon($o.icon)\
						.setData("window"; $window)\
						.mark($window.ref=$frontmostWindow)
					
					//______________________________________________________
				: (Position:C15(This:C1470.data.objectMethod.name; $window.title)=1)
					
					$o:=This:C1470.data.objectMethod
					$window.title:=Replace string:C233($window.title; $o.name; "")
					$indx:=Position:C15("."; $window.title)
					$formName:=Substring:C12($window.title; 1; $indx-1)
					$window.title:=Substring:C12($window.title; $indx+1)
					$window.icon:=$o.icon
					
					$forms[$formName]:=$forms[$formName] || cs:C1710.menu.new()
					$forms[$formName].append($window.title; $window.ref)\
						.icon($o.icon)\
						.setData("window"; $window)\
						.mark($window.ref=$frontmostWindow)
					
					//______________________________________________________
				: (Position:C15(This:C1470.data.find.name; $window.title)=1)
					
					$o:=This:C1470.data.find
					$window.title:=Replace string:C233($window.title; $o.name; "")
					$window.icon:=$o.icon
					
					$menuFind:=$menuFind || cs:C1710.menu.new()
					$menuFind.append($window.title; $window.ref)\
						.icon($window.icon)\
						.setData("window"; $window)\
						.mark($window.ref=$frontmostWindow)
					
					//______________________________________________________
				: (This:C1470.data.databaseMethod.methods.indexOf($window.title)#-1)
					
					$o:=This:C1470.data.databaseMethod
					$window.icon:=$o.icon
					$window.family:="DatabaseMethod"
					
					$menudatabaseMethods:=$menudatabaseMethods || cs:C1710.menu.new()
					$menudatabaseMethods.append($window.title; $window.ref)\
						.icon($window.icon)\
						.setData("window"; $window)\
						.mark($window.ref=$frontmostWindow)
					
					//______________________________________________________
				Else 
					
					$o:=This:C1470.data.other
					$window.icon:=$o.icon
					
					$window.title:=Replace string:C233($window.title; "{project} - "; "")
					$menuOthers:=$menuOthers || cs:C1710.menu.new()
					$menuOthers.append($window.title; $window.ref)\
						.icon($window.icon)\
						.setData("window"; $window)\
						.mark($window.ref=$frontmostWindow)
					
					//______________________________________________________
			End case 
		End if 
	End for each 
	
	$menu:=cs:C1710.menu.new()
	
	// MARK:Application
	If ($menuApplication#Null:C1517)
		
		$menu.append(Get localized string:C991("StringsApplication"); $menuApplication).icon("#Images/user.png").line()
		
	End if 
	
	// MARK:Project methods
	If ($menuMethods#Null:C1517)
		
		$menu.append(Get localized string:C991("MenuLabelsProjectMethods"); $menuMethods).icon(This:C1470.data.method.icon).line()
		
	End if 
	
	// MARK:Classes
	If ($menuClasses#Null:C1517)
		
		$menu.append(Get localized string:C991("MenuLabelClasses"); $menuClasses).icon(This:C1470.data.class.icon).line()
		
	End if 
	
	// MARK:Triggers
	If ($menuTrigger#Null:C1517)
		
		$menu.append(Get localized string:C991("MenuLabelsTriggers"); $menuTrigger).icon(This:C1470.data.trigger.icon).line()
		
	End if 
	
	// MARK:Database methods
	If ($menudatabaseMethods#Null:C1517)
		
		$menu.append(Get localized string:C991("MenuLabelsDatabaseMethods"); $menudatabaseMethods).icon(This:C1470.data.databaseMethod.icon).line()
		
	End if 
	
	// MARK:Forms & Co
	$c:=OB Entries:C1720($forms)
	
	If ($c.length>0)
		
		$menuForms:=cs:C1710.menu.new()
		
		For each ($o; $c)
			
			$menuForms.append($o.key; $o.value)\
				.icon($o.value.window.icon)\
				.parameter("form")\
				.setData("window"; $o.value.window)
			
		End for each 
		
		$menu.append(Get localized string:C991("MenuLabelsForms"); $menuForms).icon(This:C1470.data.form.icon).line()
		
	End if 
	
	// MARK:Find…
	If ($menuFind#Null:C1517)
		
		$menu.append(Get localized string:C991("Menulabelsresearches"); $menuFind).icon(This:C1470.data.find.icon).line()
		
	End if 
	
	// MARK:Others
	If ($menuOthers#Null:C1517)
		
		$menu.append(Get localized string:C991("MenuLabelsOthers"); $menuOthers).icon(This:C1470.data.other.icon)
		
	End if 
	
	If ($windowNumber>0) && ($isOffScreen)
		
		$menu.line()\
			.append("StringsPutFrontmostWindowInScreen"; "inscreen").icon("#Images/inscreen.png")
		
	End if 
	
	If ($windowNumber>=2)
		
		$menu.line()\
			.append("StringsNextWindow"; "next").icon("#Images/next.png")
		
	End if 
	
	$menu.popup()
	
	Case of 
			
			//______________________________________________________
		: (Not:C34($menu.selected))
			
			// Nothing to do
			
			//______________________________________________________
		: ($menu.choice="inscreen")
			
			This:C1470.bringToFront($frontmostWindow)
			
			//______________________________________________________
		: ($menu.choice="next")
			
			This:C1470.next($frontmostWindow)
			
			//______________________________________________________
		: ($menu.choice="stack")
			
			This:C1470.stack()
			
			//______________________________________________________
		Else 
			
			This:C1470.bringToFront(Num:C11($menu.choice))
			
			If (Macintosh option down:C545 | Windows Alt down:C563)
				
				// Close the window
				POST KEY:C465(Character code:C91("w"); 0 ?+ Command key bit:K16:2; This:C1470.designProcess)
				
			End if 
			
			//______________________________________________________
	End case 
	
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function localized($name : Text) : Text
	
	return String:C10(Formula from string:C1601(":C1578(\""+$name+"\")").call())