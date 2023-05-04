property preferences : cs:C1710.pop.Preferences
property database : cs:C1710.pop.database
property env : cs:C1710.pop.env
property motor : cs:C1710.pop.motor

Class constructor()
	
	var $key; $name : Text
	var $i; $mode; $origin; $process; $state; $time : Integer
	var $uid : Integer
	var $o; $screen : Object
	var $c : Collection
	
	// Mark:Delegates 📦
	If (False:C215)
		
		// FIXME: Turn around 🐞
		// This.database:=cs.pop.database.new()
		// This.preferences:=cs.pop.Preferences.new("PopWindows")
		// This.env:=cs.pop.env.new(True)
		// This.motor:=cs.pop.motor.new()
		
	Else 
		
		This:C1470.database:=pop.database.new()
		This:C1470.preferences:=pop.Preferences.new("PopWindows")
		This:C1470.env:=pop.env.new(True:C214)
		This:C1470.motor:=pop.motor.new()
		
	End if 
	
	This:C1470.minleft:=0
	This:C1470.minTop:=0
	This:C1470.maxRight:=0
	This:C1470.maxBottom:=0
	
	// MARK: Default values
	This:C1470.preferences.default({\
		default: "menu"; \
		options: 0; \
		palette: Null:C1517; \
		paletteMini: False:C215})
	
	For each ($screen; This:C1470.env.screens)
		
		This:C1470.minleft:=$screen.coordinates.left<This:C1470.minleft ? $screen.coordinates.left : This:C1470.minleft
		This:C1470.minTop:=$screen.coordinates.top<This:C1470.minTop ? $screen.coordinates.top : This:C1470.minTop
		This:C1470.maxRight:=$screen.coordinates.right>This:C1470.maxRight ? $screen.coordinates.right : This:C1470.maxRight
		This:C1470.maxBottom:=$screen.coordinates.bottom>This:C1470.maxBottom ? $screen.coordinates.bottom : This:C1470.maxBottom
		
	End for each 
	
	// Main screen
	This:C1470.screenWidth:=This:C1470.env.mainScreen.dimensions.width-10
	This:C1470.screenHeight:=This:C1470.env.mainScreen.dimensions.height-10
	
	This:C1470.explorer:=Replace string:C233(Get localized string:C991("_explorer"); "{project}"; This:C1470.database.name)
	
	This:C1470.hOffset:=10
	This:C1470.vOffset:=20
	
	For ($process; 1; Count tasks:C335; 1)
		
		PROCESS PROPERTIES:C336($process; $name; $state; $time; $mode; $uid; $origin)
		
		If ($origin=Design process:K36:9)
			
			This:C1470.designProcess:=$process
			break
			
		End if 
	End for 
	
	This:C1470.data:=JSON Parse:C1218(File:C1566("/RESOURCES/desc.json").getText())
	
	For each ($key; This:C1470.data)
		
		$o:=This:C1470.data[$key]
		
		If ($key="databaseMethod")
			
			For ($i; 0; $o.methods.length-1; 1)
				
				$o.methods[$i]:=This:C1470.localized(Delete string:C232($o.methods[$i]; 1; 1))
				
			End for 
			
			continue
			
		End if 
		
		If ($o.name=".@")
			
			$o.name:=Delete string:C232($o.name; 1; 1)
			$c:=Split string:C1554($o.name; ";")
			$o.name:=This:C1470.localized(($c.length=2 ? ($c[0]+","+$c[1]) : $o.name))
			
			continue
			
		End if 
		
		$o.name:=Get localized string:C991($key)
		
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
Function stackWindows()
	
	var $left; $middleH; $middleV; $top; $waLeft; $waTop : Integer
	var $explorer; $o; $window; $workArea : Object
	var $windows : Collection
	
	$windows:=This:C1470.windowList()
	$explorer:=$windows.query("explorer = true").pop()
	
	$workArea:=This:C1470.env.mainScreen.workArea
	$waLeft:=($explorer=Null:C1517 ? $workArea.left : $explorer.coordinates.right)+This:C1470.hOffset
	$waTop:=This:C1470.env.mainScreen.workArea.top+This:C1470.env.menuBarHeight+This:C1470.env.toolBarHeight+This:C1470.vOffset
	$middleH:=($workArea.right-$workArea.left)\2
	$middleV:=($workArea.bottom-$workArea.top)\2
	
	$left:=$waLeft
	$top:=$waTop
	
	For each ($window; $windows)
		
		If ($window.explorer)\
			 | ($window.origin>0)
			
			continue
			
		End if 
		
		$window.coordinates.left:=$left
		$window.coordinates.top:=$top
		$window.coordinates.right:=$left+$window.dimensions.width
		$window.coordinates.bottom:=$top+$window.dimensions.height
		
		$window.coordinates.right:=$window.coordinates.right>=This:C1470.en.mainScreen.workArea.right\
			 ? This:C1470.en.mainScreen.workArea.right-This:C1470.hOffset\
			 : $window.coordinates.right
		
		$window.coordinates.bottom:=$window.coordinates.bottom>=This:C1470.env.mainScreen.workArea.bottom\
			 ? This:C1470.env.mainScreen.workArea.bottom-This:C1470.vOffset\
			 : $window.coordinates.bottom
		
		$o:=$window.coordinates
		SET WINDOW RECT:C444($o.left; $o.top; $o.right; $o.bottom; $window.ref)
		SHOW WINDOW:C435($window.ref)
		
		$left+=This:C1470.hOffset
		$top+=This:C1470.vOffset
		
		$left:=$left>$middleH ? $waLeft : $left
		$top:=$top>$middleH ? $waTop : $top
		
	End for each 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function next($winRef : Integer)
	
	This:C1470.bringToFront(Next window:C448($winRef))
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function bringToFront($winRef : Integer)
	
	var $o : Object
	
	$o:=This:C1470.windowDefinition($winRef)
	
	If ($o.offScreen | Shift down:C543)
		
		$o.coordinates.left:=This:C1470.env.mainScreen.workArea.left+This:C1470.hOffset
		$o.coordinates.top:=This:C1470.env.mainScreen.workArea.top+This:C1470.env.menuBarHeight+This:C1470.env.toolBarHeight+This:C1470.vOffset
		$o.coordinates.right:=$o.coordinates.left+$o.dimensions.width
		$o.coordinates.bottom:=$o.coordinates.top+$o.dimensions.height
		
		$o.coordinates.right:=$o.coordinates.right>=This:C1470.en.mainScreen.workArea.right\
			 ? This:C1470.en.mainScreen.workArea.right-This:C1470.hOffset\
			 : $o.coordinates.right
		
		$o.coordinates.bottom:=$o.coordinates.bottom>=This:C1470.env.mainScreen.workArea.bottom\
			 ? This:C1470.env.mainScreen.workArea.bottom-This:C1470.vOffset\
			 : $o.coordinates.bottom
		
	End if 
	
	$o:=$o.coordinates
	SET WINDOW RECT:C444($o.left; $o.top; $o.right; $o.bottom; $winRef)
	
	If (Macintosh option down:C545 | Windows Alt down:C563)
		
		// Close the window
		POST KEY:C465(Character code:C91("w"); 0 ?+ Command key bit:K16:2; This:C1470.designProcess)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function windowList() : Collection
	
	var $i : Integer
	var $c : Collection
	
	ARRAY LONGINT:C221($refs; 0)
	
	$c:=New collection:C1472
	
	WINDOW LIST:C442($refs)
	
	For ($i; 1; Size of array:C274($refs); 1)
		
		$c.push(This:C1470.windowDefinition($refs{$i}))
		
	End for 
	
	return $c
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function windowDefinition($winRef : Integer) : Object
	
	var $name : Text
	var $visible : Boolean
	var $bottom; $indx; $left; $origin; $right; $state : Integer
	var $top; $UID : Integer
	var $time : Time
	var $o : Object
	
	GET WINDOW RECT:C443($left; $top; $right; $bottom; $winRef)
	
	$o:={}
	$o.ref:=$winRef
	$o.process:=Window process:C446($o.ref)
	$o.title:=Get window title:C450($o.ref)
	
	$indx:=Position:C15(" - "; $o.title)
	$o.title:=$indx>0 ? Delete string:C232($o.title; 1; $indx+2) : $o.title
	
	$o.coordinates:={\
		left: $left; \
		top: $top; \
		right: $right; \
		bottom: $bottom}
	
	$o.offScreen:=($left<This:C1470.minleft)\
		 || ($top<This:C1470.minTop)\
		 || ($right>This:C1470.maxRight)\
		 || ($bottom>This:C1470.maxBottom)
	
	$o.dimensions:={\
		width: $right-$left; \
		height: $bottom-$top}
	
	PROCESS PROPERTIES:C336($o.process; $name; $state; $time; $visible; $UID; $origin)
	$o.name:=$name
	$o.state:=$state
	$o.visible:=$visible
	$o.origin:=$origin
	
	$o.explorer:=$o.title=Get localized string:C991("explorer")
	
	return $o
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function menu()
	
	var $formName : Text
	var $isOffScreen : Boolean
	var $bottom; $frontmostWindow; $i; $indx; $left; $right : Integer
	var $top; $windowNumber : Integer
	var $data; $forms; $o; $window; $windowReferences : Object
	var $c; $windows : Collection
	var $menu; $menuApplication; $menuClasses; $menudatabaseMethods; $menuFind; $menuForms; $menuMethods; $menuOthers; $menuTrigger : cs:C1710.menu
	
	$windows:=This:C1470.windowList()
	$windowNumber:=$windows.length
	
	If ($windowNumber=0)
		
		return 
		
	End if 
	
	$frontmostWindow:=Frontmost window:C447
	
	GET WINDOW RECT:C443($left; $top; $right; $bottom; $frontmostWindow)
	
	$isOffScreen:=($left<This:C1470.minleft)\
		 || ($top<This:C1470.minTop)\
		 || ($right>This:C1470.maxRight)\
		 || ($bottom>This:C1470.maxBottom)
	
	$data:=This:C1470.data
	
	$forms:={}
	
	For each ($window; $windows.orderBy("origin asc,title asc"))
		
		If ($window.origin>0)
			
			$window.icon:=$data.application.icon
			$window.family:="Application"
			
			$menuApplication:=$menuApplication || cs:C1710.menu.new()
			$menuApplication.append($window.title; $window.ref)\
				.icon($window.icon)\
				.setData("window"; $window)\
				.mark($window.ref=$frontmostWindow)
			
		Else 
			
			Case of 
					
					//______________________________________________________
				: (Position:C15($data.trigger.name; $window.title)=1)
					
					$o:=$data.trigger
					$window.title:=Replace string:C233($window.title; $o.name; "")
					$window.icon:=$o.icon
					
					$menuTrigger:=$menuTrigger || cs:C1710.menu.new()
					$menuTrigger.append($window.title; $window.ref)\
						.icon($window.icon)\
						.setData("window"; $window)\
						.mark($window.ref=$frontmostWindow)
					
					//______________________________________________________
				: (Position:C15($data.method.name; $window.title)=1)
					
					$o:=$data.method
					$window.title:=Replace string:C233($window.title; $o.name; "")
					$window.icon:=$o.icon
					
					$menuMethods:=$menuMethods || cs:C1710.menu.new()
					$menuMethods.append(Replace string:C233($window.title; $o.name; ""); $window.ref)\
						.icon($window.icon)\
						.setData("window"; $window)\
						.mark($window.ref=$frontmostWindow)
					
					//______________________________________________________
				: (Position:C15($data.class.name; $window.title)=1)
					
					$o:=$data.class
					$window.title:=Replace string:C233($window.title; $o.name; "")
					$window.icon:=$o.icon
					
					$menuClasses:=$menuClasses || cs:C1710.menu.new()
					$menuClasses.append($window.title; $window.ref)\
						.icon($window.icon)\
						.setData("window"; $window)\
						.mark($window.ref=$frontmostWindow)
					
					//______________________________________________________
				: (Position:C15($data.form.name; $window.title)=1)
					
					$o:=$data.form
					$window.title:=Replace string:C233($window.title; $o.name; "")
					$window.icon:=$o.icon
					
					$forms[$window.title]:=$forms[$window.title] || cs:C1710.menu.new()
					$forms[$window.title].append(Get localized string:C991("MenuLabelsForm"); $window.ref; 0)\
						.icon($o.icon)\
						.setData("window"; $window)\
						.mark($window.ref=$frontmostWindow)
					
					//______________________________________________________
				: (Position:C15($data.formMethod.name; $window.title)=1)
					
					$o:=$data.formMethod
					$window.title:=Replace string:C233($window.title; $o.name; "")
					$window.icon:=$o.icon
					
					$forms[$window.title]:=$forms[$window.title] || cs:C1710.menu.new()
					$forms[$window.title].append(Get localized string:C991("MenuLabelsFormMethod"); $window.ref)\
						.icon($o.icon)\
						.setData("window"; $window)\
						.mark($window.ref=$frontmostWindow)
					
					//______________________________________________________
				: (Position:C15($data.objectMethod.name; $window.title)=1)
					
					$o:=$data.objectMethod
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
				: (Position:C15($data.find.name; $window.title)=1)
					
					$o:=$data.find
					$window.title:=Replace string:C233($window.title; $o.name; "")
					$window.icon:=$o.icon
					
					$menuFind:=$menuFind || cs:C1710.menu.new()
					$menuFind.append($window.title; $window.ref)\
						.icon($window.icon)\
						.setData("window"; $window)\
						.mark($window.ref=$frontmostWindow)
					
					//______________________________________________________
				: ($data.databaseMethod.methods.indexOf($window.title)#-1)
					
					$o:=$data.databaseMethod
					$window.icon:=$o.icon
					$window.family:="DatabaseMethod"
					
					$menudatabaseMethods:=$menudatabaseMethods || cs:C1710.menu.new()
					$menudatabaseMethods.append($window.title; $window.ref)\
						.icon($window.icon)\
						.setData("window"; $window)\
						.mark($window.ref=$frontmostWindow)
					
					//______________________________________________________
				Else 
					
					$o:=$data.other
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
		
		$menu.append(Get localized string:C991("StringsApplication"); $menuApplication).icon($data.application.icon).line()
		
	End if 
	
	// MARK:Project methods
	If ($menuMethods#Null:C1517)
		
		$menu.append(Get localized string:C991("MenuLabelsProjectMethods"); $menuMethods).icon($data.method.icon).line()
		
	End if 
	
	// MARK:Classes
	If ($menuClasses#Null:C1517)
		
		$menu.append(Get localized string:C991("MenuLabelClasses"); $menuClasses).icon($data.class.icon).line()
		
	End if 
	
	// MARK:Triggers
	If ($menuTrigger#Null:C1517)
		
		$menu.append(Get localized string:C991("MenuLabelsTriggers"); $menuTrigger).icon($data.trigger.icon).line()
		
	End if 
	
	// MARK:Database methods
	If ($menudatabaseMethods#Null:C1517)
		
		$menu.append(Get localized string:C991("MenuLabelsDatabaseMethods"); $menudatabaseMethods).icon($data.databaseMethod.icon).line()
		
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
		
		$menu.append(Get localized string:C991("MenuLabelsForms"); $menuForms).icon($data.form.icon).line()
		
	End if 
	
	// MARK:Find…
	If ($menuFind#Null:C1517)
		
		$menu.append(Get localized string:C991("Menulabelsresearches"); $menuFind).icon($data.find.icon).line()
		
	End if 
	
	// MARK:Others
	If ($menuOthers#Null:C1517)
		
		$menu.append(Get localized string:C991("MenuLabelsOthers"); $menuOthers).icon($data.other.icon)
		
	End if 
	
	If ($windowNumber>0) & ($isOffScreen)
		
		$menu.line()\
			.append(Get localized string:C991("StringsPutFrontmostWindowInScreen"); "inscreen").icon("#Images/inscreen.png")
		
	End if 
	
	If ($windowNumber>=2)
		
		$menu.line()\
			.append(Get localized string:C991("StringsNextWindow"); "next").icon("#Images/next.png")\
			.append(Get localized string:C991("StringsStacksWindows"); "stack").icon("#Images/stack.png")
		
	End if 
	
	$menu.line()\
		.append(Get localized string:C991("settings"); "settings").icon("/.PRODUCT_RESOURCES/Images/ObjectIcons/Icon_604.png")
	
	If (Not:C34($menu.popup().selected))
		
		return 
		
	End if 
	
	Case of 
			
			//______________________________________________________
		: ($menu.choice="settings")
			
			This:C1470.doSettings()
			
			//______________________________________________________
		: ($menu.choice="inscreen")
			
			This:C1470.bringToFront($frontmostWindow)
			
			//______________________________________________________
		: ($menu.choice="next")
			
			This:C1470.next($frontmostWindow)
			
			//______________________________________________________
		: ($menu.choice="stack")
			
			This:C1470.stackWindows()
			
			//______________________________________________________
		Else 
			
			This:C1470.bringToFront(Num:C11($menu.choice))
			
			//______________________________________________________
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function doSettings()
	
	var $winRef : Integer
	
	$winRef:=Open form window:C675("PREFERENCES"; Movable form dialog box:K39:8; Horizontally centered:K39:1; Vertically centered:K39:4; *)
	DIALOG:C40("PREFERENCES")
	CLOSE WINDOW:C154($winRef)
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function localized($name : Text) : Text
	
	return String:C10(Formula from string:C1601(":C1578(\""+$name+"\")").call())