extends Spatial

var _body : KinematicBody = null

export var destination : String
export var entranceID : String


func _on_Area_body_entered(body):
	if body.name == "Player":
		_body = body

func _on_Area_body_exited(body):
	if body.name == "Player":
		_body = null

func _physics_process(_delta):
	if !is_instance_valid(_body):
		return
	
	if !Input.is_action_just_pressed("gp_interaction"):
		return
		
	if Toolbox._is_front(_body.transform, transform, 0.4):
		Infos.spawnID = entranceID
		Global.goto_scene(destination)

