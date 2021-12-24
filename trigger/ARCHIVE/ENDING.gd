extends Spatial

export var destination : String

func _on_ENDING_body_entered(body):
	if body.name == "Player":
		Global.goto_scene(destination)
