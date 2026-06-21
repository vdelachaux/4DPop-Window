property preferences : cs:C1710.pop.Preferences
property database : cs:C1710.pop.database
property env : cs:C1710.pop.env
property motor : cs:C1710.pop.motor
property _databaseMethodNames : Collection

property minleft; minTop; maxRight; maxBottom : Integer
property screenWidth; screenHeight; hOffset; vOffset : Integer
property explorer : Text
property designProcess : Integer
property data : Object

Class constructor()
	
	var $key : Text
	var $i; $process : Integer
	var $o; $screen : Object
	var $c : Collection
	
	// Mark:Delegates 📦
	This:C1470.database:=cs:C1710.pop.database.new()
	This:C1470.preferences:=cs:C1710.pop.Preferences.new("PopWindows")
	This:C1470.env:=cs:C1710.pop.env.new(True:C214)
	This:C1470.motor:=cs:C1710.pop.motor.new()
	
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
	
	This:C1470.explorer:=Replace string:C233(Localized string:C991("_explorer"); "{project}"; This:C1470.database.name)
	
	This:C1470.hOffset:=10
	This:C1470.vOffset:=20
	
	For ($process; 1; Count tasks:C335; 1)
		
		If (Process info:C1843($process).type=Design process:K36:9)
			
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
		
		$o.name:=Try(Localized string:C991($o.name))
		
	End for each 

	// Cache localized database method names once, reused by methodPath()
	This:C1470._databaseMethodNames:=[]
	This:C1470._databaseMethodNames.push(Localized string:C991("onBackupShutdown"))
	This:C1470._databaseMethodNames.push(Localized string:C991("onBackupStartup"))
	This:C1470._databaseMethodNames.push(Localized string:C991("onDrop"))
	This:C1470._databaseMethodNames.push(Localized string:C991("onExit"))
	This:C1470._databaseMethodNames.push(Localized string:C991("onHostDatabaseEvent"))
	This:C1470._databaseMethodNames.push(Localized string:C991("onMobileAppAction"))
	This:C1470._databaseMethodNames.push(Localized string:C991("onMobileAppAuthentication"))
	This:C1470._databaseMethodNames.push(Localized string:C991("onRESTAuthentication"))
	This:C1470._databaseMethodNames.push(Localized string:C991("onServerCloseConnection"))
	This:C1470._databaseMethodNames.push(Localized string:C991("onServerOpenConnexion"))
	This:C1470._databaseMethodNames.push(Localized string:C991("onServerShutdown"))
	This:C1470._databaseMethodNames.push(Localized string:C991("onServerStartup"))
	This:C1470._databaseMethodNames.push(Localized string:C991("onSqlAuthentication"))
	This:C1470._databaseMethodNames.push(Localized string:C991("onStartup"))
	This:C1470._databaseMethodNames.push(Localized string:C991("onSystemEvent"))
	This:C1470._databaseMethodNames.push(Localized string:C991("onWebAuthentication"))
	This:C1470._databaseMethodNames.push(Localized string:C991("onWebConnection"))
	This:C1470._databaseMethodNames.push(Localized string:C991("onWebSessionClose"))
	
	This:C1470._autosaveSync()
	
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
		
		$window.coordinates.right:=$window.coordinates.right>=This:C1470.env.mainScreen.workArea.right\
			 ? This:C1470.env.mainScreen.workArea.right-This:C1470.hOffset\
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
	
	var $o:=This:C1470.windowDefinition($winRef)
	
	If ($o.offScreen | Shift down:C543)
		
		$o.coordinates.left:=This:C1470.env.mainScreen.workArea.left+This:C1470.hOffset
		$o.coordinates.top:=This:C1470.env.mainScreen.workArea.top+This:C1470.env.menuBarHeight+This:C1470.env.toolBarHeight+This:C1470.vOffset
		$o.coordinates.right:=$o.coordinates.left+$o.dimensions.width
		$o.coordinates.bottom:=$o.coordinates.top+$o.dimensions.height
		
		$o.coordinates.right:=$o.coordinates.right>=This:C1470.env.mainScreen.workArea.right\
			 ? This:C1470.env.mainScreen.workArea.right-This:C1470.hOffset\
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
Function windowList($withFloating : Boolean) : Collection
	
	var $i : Integer
	var $c : Collection
	
	ARRAY LONGINT:C221($refs; 0)
	
	$c:=New collection:C1472
	
	If ($withFloating)
		
		WINDOW LIST:C442($refs; *)
		
	Else 
		
		WINDOW LIST:C442($refs)
		
	End if 
	
	For ($i; 1; Size of array:C274($refs); 1)
		
		$c.push(This:C1470.windowDefinition($refs{$i}))
		
	End for 
	
	return $c
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function windowDefinition($winRef : Integer) : Object
	
	var $bottom; $indx; $left; $right; $top : Integer
	var $o : Object
	
	GET WINDOW RECT:C443($left; $top; $right; $bottom; $winRef)
	
	$o:={\
		ref: $winRef; \
		process: Window process:C446($winRef); \
		title: Get window title:C450($winRef); \
		kind: Window kind:C445($winRef)\
		}
	
	$indx:=Position:C15(" - "; $o.title)
	$o.title:=$indx>0 ? Delete string:C232($o.title; 1; $indx+2) : $o.title
	
	$o.coordinates:={\
		left: $left; \
		top: $top; \
		right: $right; \
		bottom: $bottom\
		}
	
	$o.offScreen:=($left<This:C1470.minleft)\
		 || ($top<This:C1470.minTop)\
		 || ($right>This:C1470.maxRight)\
		 || ($bottom>This:C1470.maxBottom)
	
	$o.dimensions:={\
		width: $right-$left; \
		height: $bottom-$top\
		}
	
	var $infos:=Process info:C1843($o.process)
	$o.name:=$infos.name
	$o.state:=$infos.state
	$o.visible:=$infos.visible
	$o.origin:=$infos.type
	
	$o.explorer:=$o.title=Localized string:C991("explorer")
	
	return $o
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function menu()
	
	var $formName : Text
	var $isOffScreen : Boolean
	var $bottom; $frontmostWindow; $indx; $left; $right; $top : Integer
	var $windowNumber : Integer
	var $data; $forms; $o; $window : Object
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
					$forms[$window.title].append(Localized string:C991("MenuLabelsForm"); $window.ref; 0)\
						.icon($o.icon)\
						.setData("window"; $window)\
						.mark($window.ref=$frontmostWindow)
					
					//______________________________________________________
				: (Position:C15($data.formMethod.name; $window.title)=1)
					
					$o:=$data.formMethod
					$window.title:=Replace string:C233($window.title; $o.name; "")
					$window.icon:=$o.icon
					
					$forms[$window.title]:=$forms[$window.title] || cs:C1710.menu.new()
					$forms[$window.title].append(Localized string:C991("MenuLabelsFormMethod"); $window.ref)\
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
	
	// MARK:Workspaces (first item)
	var $ws : cs:C1710.workspace:=cs:C1710.workspace.new()
	var $wsMenu : cs:C1710.menu:=$ws.menu()
	$menu.append(Localized string:C991("WsWorkspaces"); $wsMenu).icon("#Images/workspace.svg")
	$menu.line()
	
	// MARK:Application
	If ($menuApplication#Null:C1517)
		
		$menu.append(Localized string:C991("StringsApplication"); $menuApplication).icon($data.application.icon).line()
		
	End if 
	
	// MARK:Project methods
	If ($menuMethods#Null:C1517)
		
		$menu.append(Localized string:C991("MenuLabelsProjectMethods"); $menuMethods).icon($data.method.icon).line()
		
	End if 
	
	// MARK:Classes
	If ($menuClasses#Null:C1517)
		
		$menu.append(Localized string:C991("MenuLabelClasses"); $menuClasses).icon($data.class.icon).line()
		
	End if 
	
	// MARK:Triggers
	If ($menuTrigger#Null:C1517)
		
		$menu.append(Localized string:C991("MenuLabelsTriggers"); $menuTrigger).icon($data.trigger.icon).line()
		
	End if 
	
	// MARK:Database methods
	If ($menudatabaseMethods#Null:C1517)
		
		$menu.append(Localized string:C991("MenuLabelsDatabaseMethods"); $menudatabaseMethods).icon($data.databaseMethod.icon).line()
		
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
		
		$menu.append(Localized string:C991("MenuLabelsForms"); $menuForms).icon($data.form.icon).line()
		
	End if 
	
	// MARK:Find…
	If ($menuFind#Null:C1517)
		
		$menu.append(Localized string:C991("Menulabelsresearches"); $menuFind).icon($data.find.icon).line()
		
	End if 
	
	// MARK:Others
	If ($menuOthers#Null:C1517)
		
		$menu.append(Localized string:C991("MenuLabelsOthers"); $menuOthers).icon($data.other.icon)
		
	End if 
	
	If ($windowNumber>0) & ($isOffScreen)
		
		$menu.line()\
			.append(Localized string:C991("StringsPutFrontmostWindowInScreen"); "inscreen").icon("#Images/inscreen.png")
		
	End if 
	
	If ($windowNumber>=2)
		
		$menu.line()\
			.append(Localized string:C991("StringsNextWindow"); "next").icon("#Images/next.png")\
			.append(Localized string:C991("StringsStacksWindows"); "stack").icon("#Images/stack.png")
		
	End if 
	
	$menu.line()\
		.append(Localized string:C991("settings"); "settings").icon("/.PRODUCT_RESOURCES/Images/ObjectIcons/Icon_604.png")
	
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
		: ($menu.choice="ws:new")
			var $defaultName : Text:=$ws.suggestedName(Localized string:C991("WsDefaultName"))
			var $wsName : Text:=Request:C163(Localized string:C991("WsNamePrompt"); $defaultName)
			var $restoreAutosave : Boolean:=False:C215
			var $closed : Boolean:=False:C215
			
			If (OK=1)\
				 && (Length:C16($wsName)>0)
				
				If ($ws.exists($wsName))
					
					CONFIRM:C162(Localized string:C991("WsReplaceConfirm")+"\n"+$wsName)
					
				End if 
				
				If (OK=1)
					
					$restoreAutosave:=$ws.autosave()
					If ($restoreAutosave)
						$ws.setAutosave(False:C215)
						This:C1470._autosaveSync()
					End if 
					
					If ($ws.create($wsName))
						$closed:=This:C1470._ensureDesignWindowsClosed()
					End if 
					
					If ($restoreAutosave) && $closed
						$ws.setAutosave(True:C214)
						This:C1470._autosaveSync()
					End if 
					
				End if 
			End if 
			
			//______________________________________________________
		: ($menu.choice="ws:save")
			$defaultName:=$ws.suggestedName(Localized string:C991("WsDefaultName"))
			$wsName:=Request:C163(Localized string:C991("WsNamePrompt"); $defaultName)
			
			If (OK=1)\
				 && (Length:C16($wsName)>0)
				
				
				If ($ws.exists($wsName))
					
					CONFIRM:C162(Localized string:C991("WsReplaceConfirm")+"\n"+$wsName)
					
				End if 
				
				If (OK=1)
					
					$ws.save($wsName)
					
				End if 
			End if 
			
			//______________________________________________________
		: ($menu.choice="ws:updateCurrent")
			
			$ws.updateCurrent()
			
			//______________________________________________________
		: ($menu.choice="ws:autosave")
			
			$ws.toggleAutosave()
			This:C1470._autosaveSync()
			
			//______________________________________________________
		: (Position:C15("ws:restore:"; $menu.choice)=1)
			
			$ws.restore(Substring:C12($menu.choice; 12))
			
			//______________________________________________________
		: (Position:C15("ws:delete:"; $menu.choice)=1)
			
			$ws.delete(Substring:C12($menu.choice; 11))
			
			//______________________________________________________
		Else 
			
			This:C1470.bringToFront(Num:C11($menu.choice))
			
			//______________________________________________________
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the process number of autosave worker (0 if not running)
Function _autosaveWorkerProcess() : Integer
	
	var $i : Integer
	
	For ($i; 1; Count tasks:C335; 1)
		
		If (Process info:C1843($i).name="4DPopWindowsAutosaveWorker")
			
			return $i
			
		End if 
	End for 
	
	return 0
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Starts/stops autosave worker according to current autosave option
Function _autosaveSync()
	
	var $ws : cs:C1710.workspace:=cs:C1710.workspace.new()
	
	If ($ws.autosave())
		
		If (This:C1470._autosaveWorkerProcess()=0)
			
			CALL WORKER:C1389("4DPopWindowsAutosaveWorker"; Formula:C1597(WS_AUTOSAVE_MONITOR))
			
		End if 
		
	Else 
		
		If (This:C1470._autosaveWorkerProcess()>0)
			
			KILL WORKER:C1390("4DPopWindowsAutosaveWorker")
			
		End if 
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns a stable fingerprint of currently open design windows
Function workspaceFingerprint() : Text
	
	var $items : Collection:=[]
	var $window : Object
	
	For each ($window; This:C1470.captureWorkspace())
		
		var $key : Text:=String:C10($window.type)+"|"+String:C10($window.path)+"|"+String:C10($window.table)+"|"+String:C10($window.name)
		$items.push({k: $key})
		
	End for each 
	
	$items:=$items.orderBy("k asc")
	
	var $signature : Text:=""
	For each ($window; $items)
		$signature+=$window.k+"\n"
	End for each 
	
	return $signature

	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Builds a method path from title and method type (replacement for legacy _o_methodGetPath)
Function methodPath($name : Text; $type : Integer) : Text

	var $path : Text
	var $indx : Integer

	// Encode name
	$name:=Replace string:C233($name; "%"; "%25")
	$name:=Replace string:C233($name; "\""; "%22")
	$name:=Replace string:C233($name; "*"; "%2A")
	$name:=Replace string:C233($name; "/"; "%2F")
	$name:=Replace string:C233($name; ":"; "%3A")
	$name:=Replace string:C233($name; "<"; "%3C")
	$name:=Replace string:C233($name; ">"; "%3E")
	$name:=Replace string:C233($name; "?"; "%3F")
	$name:=Replace string:C233($name; "|"; "%7C")
	$name:=Replace string:C233($name; "\\"; "%5C")

	Case of 

			//______________________________________________________
		: ($type=Path class:K72:19)
			
			return "[class]/"+$name
			
			//______________________________________________________
		: ($type=Path trigger:K72:4)
			
			return "[trigger]/"+$name
			
			//______________________________________________________
		: ($type=Path project form:K72:3)
			
			return "[projectForm]/"+$name+"/{formMethod}"
			
			//______________________________________________________
		: ($type=Path table form:K72:5)
			
			$name:=Replace string:C233($name; "["; "")
			$name:=Replace string:C233($name; "]"; "/")
			return "[tableForm]/"+$name+"/{formMethod}"
			
			//______________________________________________________
		: ($type=Path project method:K72:1)
			
			return $name
			
			//______________________________________________________
		: ($type=Path database method:K72:2)
			
			$indx:=This:C1470._databaseMethodNames.indexOf($name)
			If ($indx#-1)
				return "[databaseMethod]/"+This:C1470._databaseMethodNames[$indx]
			End if 
			
			//______________________________________________________
		: ($type=Path all objects:K72:16)
			
			$path:=Position:C15("["; $name)=1 ? "[tableForm]/" : "[projectForm]/"
			$name:=Replace string:C233($name; "["; "")
			$name:=Replace string:C233($name; "]."; "/")
			$name:=Replace string:C233($name; "."; "/"; 1)
			
			return $path+$name
			
			//______________________________________________________
		Else 
			
			TRACE:C157
			return ""
			
			//______________________________________________________
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns a Collection of {type; path|name|table} for each identifiable open design window
Function captureWorkspace() : Collection
	
	var $windows:=[]
	var $data : Object:=This:C1470.data
	
	var $window : Object
	For each ($window; This:C1470.windowList())
		
		If ($window.explorer || ($window.origin>0))
			
			continue
			
		End if 
		
		var $t : Text:=$window.title
		
		Case of 
				
				//______________________________________________________
			: (Position:C15($data.method.name; $t)=1)
				
				var $o:={\
					type: "method"; \
					path: Replace string:C233($t; $data.method.name; ""; 1)}
				
				//______________________________________________________
			: (Position:C15($data.class.name; $t)=1)
				
				$o:={\
					type: "class"; \
					path: "[class]/"+Replace string:C233($t; $data.class.name; ""; 1)}
				
				//______________________________________________________
			: (Position:C15($data.trigger.name; $t)=1)
				
				$o:={\
					type: "trigger"; \
					path: "[trigger]/"+Replace string:C233($t; $data.trigger.name; ""; 1)}
				
				//______________________________________________________
			: (Position:C15($data.formMethod.name; $t)=1)
				
				$t:=Replace string:C233($t; $data.formMethod.name; ""; 1)
				
				If (Position:C15("["; $t)=1)  // Table form method
					
					$t:=Replace string:C233($t; "["; "")
					var $indx : Integer:=Position:C15("]"; $t)
					$o:={\
						type: "formMethod"; \
						path: "[tableForm]/"+Substring:C12($t; 1; $indx-1)+"/"+Substring:C12($t; $indx+1)+"/{formMethod}"}
					
				Else   // Project form method
					
					$o:={\
						type: "formMethod"; \
						path: "[projectForm]/"+$t+"/{formMethod}"}
					
				End if 
				
				//______________________________________________________
			: (Position:C15($data.form.name; $t)=1)
				
				$t:=Replace string:C233($t; $data.form.name; ""; 1)
				
				If (Position:C15("["; $t)=1)  // Table form
					
					$t:=Replace string:C233($t; "["; "")
					$indx:=Position:C15("]"; $t)
					$o:={\
						type: "tableForm"; \
						table: Substring:C12($t; 1; $indx-1); \
						name: Substring:C12($t; $indx+1)}
					
				Else   // Project form
					
					$o:={type: "projectForm"; name: $t}
					
				End if 
				
				//______________________________________________________
			: ($data.databaseMethod.methods.indexOf($t)#-1)
				
				$o:={type: "databaseMethod"; path: $t}
				
				//______________________________________________________
			Else 
				
				continue
				
				//______________________________________________________
		End case 
		
		$windows.push($o)
		
	End for each 
	
	return $windows
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns number of open design windows (excluding Explorer)
Function _designWindowsCount() : Integer
	
	var $count : Integer:=0
	var $window : Object
	
	For each ($window; This:C1470.windowList())
		
		If ($window.explorer | ($window.origin>0))
			continue
		End if 
		
		$count+=1
		
	End for each 
	
	return $count

	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Closes design windows in a single pass and returns remaining candidates count
Function _closeDesignWindowsPass() : Integer

	var $pending : Integer:=0
	var $window : Object

	For each ($window; This:C1470.windowList())

		If ($window.explorer | ($window.origin>0))
			continue
		End if 

		$pending+=1
		POST KEY:C465(Character code:C91("w"); 0 ?+ Command key bit:K16:2; $window.process)

	End for each 

	return $pending
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Closes all open design windows except the Explorer
Function closeDesignWindows()
	
	var $pass : Integer
	var $pending : Integer
	
	For ($pass; 1; 4; 1)
		
		$pending:=This:C1470._closeDesignWindowsPass()
		
		If ($pending=0)
			break
		End if 
		
		DELAY PROCESS:C323(Current process:C322; 5)
		
	End for 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Closes current design windows then reopens a saved set
Function restoreWorkspace($windows : Collection)
	
	This:C1470._ensureDesignWindowsClosed()
	
	var $window : Object
	For each ($window; $windows)
		
		Case of 
				
				// ______________________________________________________
			: ($window.type="method")\
				 | ($window.type="class")\
				 | ($window.type="trigger")\
				 | ($window.type="formMethod")\
				 | ($window.type="databaseMethod")
				
				METHOD OPEN PATH:C1213($window.path; *)
				
				// ______________________________________________________
			: ($window.type="projectForm")
				
				Formula from string:C1601("FORM EDIT:C1749($1)"; sk execute in host database:K88:5).call(Null:C1517; $window.name)
				
				// ______________________________________________________
			: ($window.type="tableForm")
				
				Try(Formula from string:C1601("FORM EDIT(["+$window.table+"]; $1)"; sk execute in host database:K88:5).call(Null:C1517; $window.name))
				
				// ______________________________________________________
		End case 
	End for each 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Tries repeatedly until all design windows are closed
Function _ensureDesignWindowsClosed() : Boolean
	
	var $pass : Integer
	var $closed : Boolean:=False:C215
	var $ws : cs:C1710.workspace:=cs:C1710.workspace.new()
	
	$ws.setClosing(True:C214)
	
	For ($pass; 1; 20; 1)

		If (This:C1470._closeDesignWindowsPass()=0)
			$closed:=True:C214
			break
		End if 
		
		DELAY PROCESS:C323(Current process:C322; 5)
		
	End for 
	
	If (Not:C34($closed))
		$closed:=This:C1470._closeDesignWindowsPass()=0
	End if 
	
	$ws.setClosing(False:C215)
	return $closed
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function doSettings()
	
	var $winRef:=Open form window:C675("PREFERENCES"; Movable form dialog box:K39:8; Horizontally centered:K39:1; Vertically centered:K39:4; *)
	DIALOG:C40("PREFERENCES")
	CLOSE WINDOW:C154($winRef)
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
Function localized($name : Text) : Text
	
	return String:C10(Formula from string:C1601(":C1578(\""+$name+"\")").call())