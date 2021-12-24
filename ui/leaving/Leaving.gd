extends Panel
var cheapFix = true

func _process(delta):
	if cheapFix:
		$Leaving/NO.grab_focus()
		cheapFix = false
