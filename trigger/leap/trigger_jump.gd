extends Spatial

var body_stay : bool = false
var _body : KinematicBody
var player
onready var animationPlayer = get_node("AnimationPlayer")

func _on_Area_body_entered(body):
	if body.name == "Player":
		player = body
		_body = body
		body_stay = true


func _on_Area_body_exited(body):
	if body.name == "Player":
		body_stay = false

func _physics_process(_delta):
	if !body_stay:
		return
		
	if !Input.is_action_just_pressed("gp_interaction"):
		return
	
	if Toolbox._is_front(_body.transform, transform, 0.9):
		player.visible = false
		$AnimationPlayer/Spatial.visible = true
		animationPlayer.connect("animation_finished", self, "jump_finished")
		animationPlayer.play("JumpRoof")

func jump_finished(_arg0):
	$AnimationPlayer/Spatial.visible = false
	player.transform.origin = get_node("/root/Room/Spawn/02").transform.origin
	player.visible = true
	pass
