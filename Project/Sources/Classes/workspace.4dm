property module : Text

shared singleton Class constructor
	
	This:C1470.module:="workspaces"
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns a fresh preferences instance (shared-singleton safe)
Function _preferences() : cs:C1710.pop.Preferences
	
	return cs:C1710.pop.Preferences.new(This:C1470.module)
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns persisted state in normalized format: {entries; current}
Function _state() : Object
	
	var $preferences : cs:C1710.pop.Preferences:=This:C1470._preferences()
	var $raw : Object:=$preferences.get() || New object:C1471
	
	If ($raw.entries#Null:C1517)
		
		return New object:C1471("entries"; $raw.entries || New object:C1471; "current"; String:C10($raw.current || ""); "autosave"; Bool:C1537($raw.autosave); "closing"; Bool:C1537($raw.closing))
		
	End if 
	
	// Backward compatibility with previous format ({name:workspace; ...})
	return New object:C1471("entries"; $raw; "current"; ""; "autosave"; False:C215; "closing"; False:C215)
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Persists normalized state
Function _saveState($state : Object)
	
	var $preferences : cs:C1710.pop.Preferences:=This:C1470._preferences()
	$preferences.set(New object:C1471("entries"; $state.entries || New object:C1471; "current"; String:C10($state.current || ""); "autosave"; Bool:C1537($state.autosave); "closing"; Bool:C1537($state.closing)))
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns autosave activation state for current workspace tracking
Function autosave() : Boolean
	
	return Bool:C1537(This:C1470._state().autosave)
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Sets autosave activation state
Function setAutosave($enabled : Boolean) : cs:C1710.workspace
	
	var $state : Object:=This:C1470._state()
	$state.autosave:=$enabled
	This:C1470._saveState($state)
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Toggles autosave activation state and returns the new value
Function toggleAutosave() : Boolean
	
	var $enabled : Boolean:=Not:C34(This:C1470.autosave())
	This:C1470.setAutosave($enabled)
	
	return $enabled
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns true while a mass window-closing operation is in progress
Function closing() : Boolean
	
	return Bool:C1537(This:C1470._state().closing)
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Sets the mass-closing state flag
Function setClosing($enabled : Boolean) : cs:C1710.workspace
	
	var $state:=This:C1470._state()
	$state.closing:=$enabled
	This:C1470._saveState($state)
	
	return This:C1470
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns workspace names sorted by most recent update first
Function _sortedNames($entries : Object) : Collection

	$entries:=$entries || {}
	var $rows:=[]

	var $name : Text
	For each ($name; OB Keys:C1719($entries))

		var $ws : Object:=$entries[$name]
		$rows.push({name: $name; updatedDate: $ws.updatedDate; updatedTime: $ws.updatedTime; date: String:C10($ws.date || "")})

	End for each 

	$rows:=$rows.orderBy("updatedDate desc,updatedTime desc,date desc,name asc")

	var $names:=[]
	var $row : Object
	For each ($row; $rows)

		$names.push($row.name)

	End for each 

	return $names

	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the list of saved workspace names
Function list() : Collection
	
	var $state : Object:=This:C1470._state()
	return This:C1470._sortedNames($state.entries)
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns true if a workspace name already exists
Function exists($name : Text) : Boolean
	
	If (Length:C16($name)=0)
		
		return False:C215
		
	End if 
	
	return This:C1470._state().entries[$name]#Null:C1517
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Returns the current workspace name (if any)
Function current() : Text
	
	return String:C10(This:C1470._state().current || "")
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Proposes a unique workspace name by suffixing with " 1", " 2", ...
Function suggestedName($base : Text) : Text
	
	$base:=String:C10($base)
	
	If (Length:C16($base)=0)
		
		$base:=Localized string:C991("WsDefaultName")
		
	End if 
	
	If (Not:C34(This:C1470.exists($base)))
		
		return $base
		
	End if 
	
	var $candidate : Text
	var $i : Integer:=1
	Repeat 
		
		$candidate:=$base+" "+String:C10($i)
		$i+=1
		
	Until (Not:C34(This:C1470.exists($candidate)))
	
	return $candidate
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Creates an empty workspace and sets it as current
Function create($name : Text) : Boolean
	
	If (Length:C16($name)=0)
		
		return False:C215
		
	End if 
	
	var $state : Object:=This:C1470._state()
	var $nowDate : Date:=Current date:C33
	var $nowTime : Time:=Current time:C178
	
	$state.entries[$name]:={\
		windows: []; \
		date: String:C10($nowDate)+" "+String:C10($nowTime); \
		updatedDate: $nowDate; \
		updatedTime: $nowTime}
	
	$state.current:=$name
	
	This:C1470._saveState($state)
	
	return True:C214
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Saves the currently open design windows under $name
	// Returns the number of windows saved
Function save($name : Text) : Integer
	
	If (Length:C16($name)=0)
		
		return 0
		
	End if 
	
	var $state : Object:=This:C1470._state()
	var $current : Text:=String:C10($state.current || "")
	var $currentWs : Object:=$state.entries[$current]
	
	// Save-as from current workspace duplicates the stored object exactly.
	If ((Length:C16($current)>0) && ($current#$name) && ($currentWs#Null:C1517))
		
		var $copy : Object:=$currentWs.copy()
		var $nowDate : Date:=Current date:C33
		var $nowTime : Time:=Current time:C178
		$copy.date:=String:C10($nowDate)+" "+String:C10($nowTime)
		$copy.updatedDate:=$nowDate
		$copy.updatedTime:=$nowTime
		$state.entries[$name]:=$copy
		$state.current:=$name
		
		This:C1470._saveState($state)
		
		If ($copy.windows#Null:C1517)
			
			return 0
			
		End if 
		
		return $copy.windows.length
		
	End if 
	
	var $windows : Collection:=component.captureWorkspace()
	$nowDate:=Current date:C33
	$nowTime:=Current time:C178
	
	$state.entries[$name]:=New object:C1471("windows"; $windows; "date"; String:C10($nowDate)+" "+String:C10($nowTime); "updatedDate"; $nowDate; "updatedTime"; $nowTime)
	$state.current:=$name
	
	This:C1470._saveState($state)
	return $windows.length
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Saves current open windows into the current workspace
	// Returns -1 when no current workspace exists
Function updateCurrent() : Integer
	
	If (This:C1470.closing())
		
		return -2
		
	End if 
	
	var $name : Text:=This:C1470.current()
	
	If (Length:C16($name)=0)
		
		return -1
		
	End if 
	
	return This:C1470.save($name)
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Closes current design windows and restores the named workspace
Function restore($name : Text)
	
	var $state : Object:=This:C1470._state()
	var $o : Object:=$state.entries
	
	If ($o=Null:C1517)
		
		return 
		
	End if 
	
	var $ws : Object:=$o[$name]
	
	If ($ws=Null:C1517)
		
		return 
		
	End if 
	
	$state.current:=$name
	This:C1470._saveState($state)
	
	component.restoreWorkspace($ws.windows)
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Deletes a saved workspace
Function delete($name : Text)
	
	var $state : Object:=This:C1470._state()
	var $o : Object:=$state.entries
	
	If ($o=Null:C1517)
		
		return 
		
	End if 
	
	OB REMOVE:C1226($o; $name)
	
	If ($state.current=$name)
		
		$state.current:=""
		$state.autosave:=False:C215
		
	End if 
	
	This:C1470._saveState($state)
	
	If (($state.current="") && (Not:C34(Bool:C1537($state.autosave))))
		
		Try(component._autosaveSync())
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === === ===
	// Builds and returns the workspace submenu
Function menu() : cs:C1710.menu
	
	var $state : Object:=This:C1470._state()
	var $entries : Object:=$state.entries || {}
	var $menu:=cs:C1710.menu.new("no-localization")
	var $current : Text:=String:C10($state.current || "")
	var $autosave : Boolean:=Bool:C1537($state.autosave)
	var $hasCurrent : Boolean:=(Length:C16($current)>0) && ($entries[$current]#Null:C1517)
	
	// New empty workspace
	$menu.append(Localized string:C991("WsNew"); "ws:new").icon("#Images/ws-save.svg")
	
	// Save current workspace
	$menu.append(Localized string:C991("WsSave"); "ws:save").icon("#Images/ws-save.svg")
	
	If ($hasCurrent)
		
		var $updateLabel : Text:=Localized string:C991("WsUpdate")+" \""+$current+"\""
		$menu.append($updateLabel; "ws:updateCurrent").icon("#Images/ws-update.svg").enable(Not:C34($autosave))
		
	End if 
	
	var $names : Collection:=This:C1470._sortedNames($entries)
	
	If ($names.length>0)
		
		$menu.line()
		
		// Restore submenu
		var $restore:=cs:C1710.menu.new("no-localization")
		
		var $name : Text
		For each ($name; $names)
			
			$restore.append($name; "ws:restore:"+$name)
			
			If ($autosave)\
				 && ($name=$current)
				
				$restore.disable()
				
			End if 
		End for each 
		
		$menu.append(Localized string:C991("WsRestore"); $restore).icon("#Images/ws-restore.svg")
		$menu.line()
		
		// Delete submenu
		var $delete:=cs:C1710.menu.new("no-localization")
		
		For each ($name; $names)
			
			$delete.append($name; "ws:delete:"+$name)
			
		End for each 
		
		$menu.append(Localized string:C991("WsDelete"); $delete).icon("#Images/ws-delete.svg")
		
	End if 
	
	If ($hasCurrent)
		
		$menu.line()
		$menu.append(Localized string:C991("WsAutosave"); "ws:autosave").icon("#Images/ws-autosave.svg").mark($autosave)
		
	End if 
	
	return $menu
	