// ----------------------------------------------------
// Form method : Preferences
// Created 08/06/12 by Vincent de Lachaux
// ----------------------------------------------------
var $options : Integer
var $e; $o : Object

$e:=FORM Event:C1606

Case of 
		
		//______________________________________________________
	: ($e.code=On Load:K2:1)
		
		var component : cs:C1710._component
		component:=component || cs:C1710._component.new()
		$o:=component.preferences.get()
		
		Form:C1466.menu:=Not:C34($o.options ?? 1)
		Form:C1466.palette:=$o.options ?? 2
		Form:C1466.prefix:=$o.options ?? 3
		
		Form:C1466.stack:=$o.default="stack"
		Form:C1466.next:=Not:C34(Form:C1466.stack)
		
		//______________________________________________________
	: ($e.code=On Validate:K2:3)
		
		$options:=Not:C34(Form:C1466.menu) ? 0 ?+ 1 : 0
		$options:=Form:C1466.palette ? $options ?+ 2 : $options
		$options:=Form:C1466.prefix ? $options ?+ 3 : $options
		component.preferences.set("options"; $options)
		
		component.preferences.set("default"; Form:C1466.next ? "next" : "stack")
		
		//______________________________________________________
End case 